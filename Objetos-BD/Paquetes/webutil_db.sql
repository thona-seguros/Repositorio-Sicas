--
-- WEBUTIL_DB  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   UTL_ENCODE (Synonym)
--   UTL_RAW (Synonym)
--   DBMS_LOB (Synonym)
--
CREATE OR REPLACE PACKAGE SICAS_OC."WEBUTIL_DB" AUTHID CURRENT_USER AS

/*********************************************************************************\
 * WebUtil_DB - Database functions used by the WebUtil_File_Transfer
 * Package.  These functions allow reading and writing direct
 * to the specified BLOB in the database.
 *  The functions should not be called externally from WebUtil
 *********************************************************************************
 * Version 1.0.0
 *********************************************************************************
 * Change History
 *   DRMILLS 11/JAN/2003 - Creation
 *
\*********************************************************************************/

  FUNCTION  OpenBlob(blobTable  in VARCHAR2,
                     blobColumn in VARCHAR2,
                     blobWhere  in VARCHAR2,
                     openMode   in VARCHAR2,
                     chunkSize  in PLS_INTEGER default null) return BOOLEAN;

  FUNCTION  CloseBlob(checksum in PLS_INTEGER) return BOOLEAN;

  PROCEDURE WriteData(data in VARCHAR2);

  FUNCTION ReadData return VARCHAR;

  FUNCTION GetLastError return PLS_INTEGER;

  FUNCTION GetSourceLength  return PLS_INTEGER;

  FUNCTION GetSourceChunks  return PLS_INTEGER;

END WEBUTIL_DB;
/

--
-- WEBUTIL_DB  (Package Body) 
--
--  Dependencies: 
--   WEBUTIL_DB (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC."WEBUTIL_DB" AS
  m_binaryData   BLOB;
  m_blobTable    VARCHAR2(60);
  m_blobColumn   VARCHAR2(60);
  m_blobWhere    VARCHAR2(1024);
  m_mode         CHAR(1);
  m_lastError    PLS_INTEGER := 0;
  m_sourceLength PLS_INTEGER := 0;
  m_bytesRead    PLS_INTEGER := 0;
  MAX_READ_BYTES PLS_INTEGER := 4096;

  -- internal Program Units
  PROCEDURE Reset;

  PROCEDURE Reset is
  BEGIN
    m_blobTable     := null;
    m_blobColumn    := null;
    m_blobWhere     := null;
    m_mode          := null;
    m_lastError     := 0;
    m_sourceLength  := 0;
    m_bytesRead     := 0;
  END Reset;


  FUNCTION  OpenBlob(blobTable in VARCHAR2, blobColumn in VARCHAR2, blobWhere in VARCHAR2, openMode in VARCHAR2, chunkSize PLS_INTEGER default null) return BOOLEAN is
    result BOOLEAN := false;
    stmtFetch   VARCHAR2(2000);
    hit    PLS_INTEGER;
  BEGIN
    -- New transaction clean up
    reset;

    m_blobTable  := blobTable;
    m_blobColumn := blobColumn;
    m_blobWhere  := blobWhere;
    m_mode       := upper(openMode);

    if chunkSize is not null then
      if chunkSize > 16384 then
        MAX_READ_BYTES := 16384;
      else
        MAX_READ_BYTES := chunkSize;
      end if;
    end if;

    -- check the target row exists
    stmtFetch := 'select count(*) from '||m_blobTable||' where '||m_blobWhere;
    EXECUTE IMMEDIATE stmtFetch into hit;

    if hit = 1 then
      if m_mode = 'W' then
        DBMS_LOB.CREATETEMPORARY(m_binaryData,false);
        DBMS_LOB.OPEN(m_binaryData,DBMS_LOB.LOB_READWRITE);
        m_sourceLength := 0;
        result := true;
      elsif m_mode = 'R' then
        stmtFetch := 'select '||m_blobColumn||' from '||m_blobTable||' where '||m_blobWhere;
        EXECUTE IMMEDIATE stmtFetch into m_binaryData;
        if m_binaryData is not null then
          m_sourceLength := dbms_lob.getlength(m_binaryData);
          if m_sourceLength > 0 then
            result := true;
          else
            m_lastError := 110;
          end if;
        else
          m_lastError := 111;
        end if;
      else
          m_lastError := 112;
      end if; -- mode
    else
      -- too many rows
      m_lastError := 113;
    end if; -- Hit
    return result;
  END OpenBlob;

  FUNCTION  CloseBlob(checksum in PLS_INTEGER) return BOOLEAN is
    sourceBlob  BLOB;
    stmtFetch   VARCHAR2(2000);
    stmtInit    VARCHAR2(2000);
    result      BOOLEAN := false;
  BEGIN
    if m_mode = 'W' then
      m_sourceLength := DBMS_LOB.GETLENGTH(m_binaryData);
    end if;

    -- checksum
    if checksum = m_sourceLength then
      if m_mode = 'W' then
        -- get the locator to the table blob
        stmtFetch := 'select '||m_blobColumn||' from '||m_blobTable||' where '||m_blobWhere||' for update';
        EXECUTE IMMEDIATE stmtFetch into sourceBlob;

        -- Check the blob has been initialised
        -- and if it's not empty clear it out
        if sourceBlob is null then
          stmtInit := 'update '||m_blobTable||' set '||m_blobColumn||'=EMPTY_BLOB()  where '||m_blobWhere;
          EXECUTE IMMEDIATE stmtInit;
          EXECUTE IMMEDIATE stmtFetch into sourceBlob;
        elsif dbms_lob.getlength(sourceBlob) > 0 then
          dbms_lob.TRIM(sourceBlob,0);
        end if;
        -- now replace the table data with the temp BLOB
        DBMS_LOB.APPEND(sourceBlob,m_binaryData);
        DBMS_LOB.CLOSE(m_binaryData);
        result := true;
      else
       -- todo
        null;
      end if; --mode
    else
      m_lastError := 115;
    end if; --checksum
    return result;
  END CloseBlob;

  PROCEDURE WriteData(data in VARCHAR2) is
    rawData raw(16384);
  BEGIN
    rawData := utl_encode.BASE64_DECODE(utl_raw.CAST_TO_RAW(data));
    dbms_lob.WRITEAPPEND(m_binaryData, utl_raw.LENGTH(rawData), rawData);
  END WriteData;


  FUNCTION ReadData return VARCHAR is
    rawData     RAW(16384);
    bytesToRead PLS_INTEGER;
  BEGIN
    bytesToRead :=  (m_sourceLength - m_bytesRead);
    if bytesToRead >  MAX_READ_BYTES then
      bytesToRead := MAX_READ_BYTES;
    end if;
    DBMS_LOB.READ(m_binaryData, bytesToRead, (m_bytesRead + 1), rawData);
    m_bytesRead := m_bytesRead + bytesToRead;
    return UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(rawData));
  END ReadData;

  FUNCTION GetLastError return PLS_INTEGER is
  BEGIN
    return m_lastError;
  END GetLastError;


  FUNCTION GetSourceLength  return PLS_INTEGER is
  BEGIN
    return m_sourceLength;
  END GetSourceLength;

  FUNCTION GetSourceChunks  return PLS_INTEGER is
   chunks PLS_INTEGER;
  BEGIN
    chunks := floor(m_sourceLength/MAX_READ_BYTES);
    if mod(m_sourceLength,MAX_READ_BYTES) > 0 then
      chunks := chunks+1;
    end if;
    return chunks;
  END GetSourceChunks;

END;
/

--
-- WEBUTIL_DB  (Synonym) 
--
--  Dependencies: 
--   WEBUTIL_DB (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM WEBUTIL_DB FOR SICAS_OC.WEBUTIL_DB
/


GRANT EXECUTE ON SICAS_OC.WEBUTIL_DB TO PUBLIC
/

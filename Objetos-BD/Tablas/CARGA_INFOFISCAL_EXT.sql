DROP TABLE SICAS_OC.CARGA_INFOFISCAL_EXT
/
--
-- CARGA_INFOFISCAL_EXT  (Table) 
--
CREATE TABLE SICAS_OC.CARGA_INFOFISCAL_EXT
   ( IDPOLIZA                    NUMBER(14,0)
   , CODCLIENTE                  NUMBER(14,0)
   , TIPO_DOC_IDENTIFICACION     VARCHAR2(6 BYTE)
   , NUM_DOC_IDENTIFICACION      VARCHAR2(20 BYTE)
   , RAZONSOCIALFACT             VARCHAR2(300 BYTE)
   , IDREGFISSAT                 NUMBER(5,0)
   , DESCRIPCION_REGFIS          VARCHAR2(500 BYTE)
   , TIPO_DIRECCION              VARCHAR2(6 BYTE)
   , CORRELATIVO_DIRECCION       NUMBER(5,0)
   , DIRECCION                   VARCHAR2(250 BYTE)
   , CODPAIS                     VARCHAR2(3 BYTE)
   , CODESTADO                   VARCHAR2(3 BYTE)
   , CODCIUDAD                   VARCHAR2(3 BYTE)
   , CODMUNICIPIO                VARCHAR2(3 BYTE)
   , CODIGO_POSTAL               VARCHAR2(30 BYTE)
   , CODCOLONIA                  VARCHAR2(6 BYTE)
   , NUMINTERIOR                 VARCHAR2(20 BYTE)
   , NUMEXTERIOR                 VARCHAR2(20 BYTE)
   , CODUSOCFDI                  VARCHAR2(10 BYTE)
   , CODOBJETOIMP                VARCHAR2(10 BYTE)
   , TIPO_PERSONA                VARCHAR2(6 BYTE)
   , NUM_CARGA                   NUMBER(2,0)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "DIR_TMP"
      ACCESS PARAMETERS
         ( RECORDS DELIMITED BY NEWLINE
           BADFILE DIR_TMP:'carga_infofiscal.bad'
           LOGFILE DIR_TMP:'carga_infofiscal.log'
           FIELDS TERMINATED BY '|' 
           MISSING FIELD VALUES ARE NULL
              ( IDPOLIZA
              , CODCLIENTE
              , TIPO_DOC_IDENTIFICACION
              , NUM_DOC_IDENTIFICACION
              , RAZONSOCIALFACT
              , IDREGFISSAT
              , DESCRIPCION_REGFIS
              , TIPO_DIRECCION
              , CORRELATIVO_DIRECCION
              , DIRECCION
              , CODPAIS
              , CODESTADO
              , CODCIUDAD
              , CODMUNICIPIO
              , CODIGO_POSTAL
              , CODCOLONIA
              , NUMINTERIOR
              , NUMEXTERIOR
              , CODUSOCFDI
              , CODOBJETOIMP
              , TIPO_PERSONA
              , NUM_CARGA
            )
         )
      LOCATION ( 'carga_infofiscal.txt' )
    )
   REJECT LIMIT UNLIMITED
/

--
-- CARGA_INFOFISCAL_EXT  (Synonym) 
--
--  Dependencies: 
--   CARGA_INFOFISCAL_EXT (Table)
--
CREATE OR REPLACE PUBLIC SYNONYM CARGA_INFOFISCAL_EXT FOR SICAS_OC.CARGA_INFOFISCAL_EXT
/

GRANT SELECT ON SICAS_OC.CARGA_INFOFISCAL_EXT TO PUBLIC
/
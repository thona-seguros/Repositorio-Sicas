--
-- OC_MAIL  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_LOB (Synonym)
--   DBMS_OUTPUT (Synonym)
--   PLITBLM (Synonym)
--   UTL_ENCODE (Synonym)
--   UTL_FILE (Synonym)
--   UTL_RAW (Synonym)
--   UTL_SMTP (Synonym)
--   UTL_SMTP (Synonym)
--   UTL_TCP (Synonym)
--   UTL_TCP (Synonym)
--   OC_GENERALES (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_MAIL IS
   /* Package variable Declaration. */
   nCodCia                          NUMBER;
   cCtaEnvio                        VARCHAR2(50);
   cPwdCtaEnvio                     VARCHAR2(100);
   SMTP_HOST                        VARCHAR2 (256);
   SMTP_PORT                        PLS_INTEGER;
   SMTP_DOMAIN                      VARCHAR2 (256);
   MAILER_ID CONSTANT               VARCHAR2 (256) := 'Mailer by Oracle UTL_SMTP';
   /* Boundary is an arbitrary string used as seperator marker for different
      sections of the of the e-mail. Separates various parts of e-mail and attachments. */

   BOUNDARY CONSTANT                VARCHAR2 (256) := '__7D81B75CCC90D2974F7A1CBD__';
   FIRST_BOUNDARY CONSTANT          VARCHAR2 (256) := '--' || BOUNDARY || UTL_TCP.CRLF;
   LAST_BOUNDARY CONSTANT           VARCHAR2 (256) := '--' || BOUNDARY || '--' || UTL_TCP.CRLF;
   MULTIPART_MIME_TYPE CONSTANT     VARCHAR2 (256) := 'multipart/mixed; boundary="' || BOUNDARY || '"';
   MAX_BASE64_LINE_WIDTH CONSTANT   PLS_INTEGER := 76 / 4 * 3;  -- do not change this line.

   /* Table declaration for storing e-mail attachment file names. */

   TYPE ATTACHMENT IS RECORD (FILENAME VARCHAR2 (100));

   TYPE TAB_OF_ATTACHMENTS IS TABLE OF ATTACHMENT;

   /* Package Function and procedures. */
   
   PROCEDURE INIT_PARAM;

   PROCEDURE MAIL (SENDER       IN VARCHAR2
                 , RECIPIENTS   IN VARCHAR2
                 , CC           IN VARCHAR2 DEFAULT NULL
                 , BCC          IN VARCHAR2 DEFAULT NULL
                 , SUBJECT      IN VARCHAR2
                 , MESSAGE      IN VARCHAR2
                  );

   FUNCTION BEGIN_MAIL (SENDER       IN VARCHAR2
                      , RECIPIENTS   IN VARCHAR2
                      , CC           IN VARCHAR2 DEFAULT NULL
                      , BCC          IN VARCHAR2 DEFAULT NULL
                      , SUBJECT      IN VARCHAR2
                      , MIME_TYPE    IN VARCHAR2 DEFAULT 'text/plain'
                      , PRIORITY     IN PLS_INTEGER DEFAULT NULL
                       )
      RETURN UTL_SMTP.CONNECTION;

   PROCEDURE WRITE_TEXT (CONN IN OUT NOCOPY UTL_SMTP.CONNECTION, MESSAGE IN VARCHAR2);

   PROCEDURE WRITE_MB_TEXT (CONN IN OUT NOCOPY UTL_SMTP.CONNECTION, MESSAGE IN VARCHAR2);

   PROCEDURE WRITE_RAW (CONN IN OUT NOCOPY UTL_SMTP.CONNECTION, MESSAGE IN RAW);

   PROCEDURE ATTACH_TEXT (CONN        IN OUT NOCOPY UTL_SMTP.CONNECTION
                        , DATA        IN            VARCHAR2
                        , MIME_TYPE   IN            VARCHAR2 DEFAULT 'text/plain'
                        , INLINE      IN            BOOLEAN DEFAULT TRUE
                        , FILENAME    IN            VARCHAR2 DEFAULT NULL
                        , LAST        IN            BOOLEAN DEFAULT FALSE
                         );

   PROCEDURE ATTACH_MB_TEXT (CONN        IN OUT NOCOPY UTL_SMTP.CONNECTION
                           , DATA        IN            VARCHAR2
                           , MIME_TYPE   IN            VARCHAR2 DEFAULT 'text/plain'
                           , INLINE      IN            BOOLEAN DEFAULT TRUE
                           , FILENAME    IN            VARCHAR2 DEFAULT NULL
                           , LAST        IN            BOOLEAN DEFAULT FALSE
                            );

   PROCEDURE ATTACH_BASE64 (CONN        IN OUT NOCOPY UTL_SMTP.CONNECTION
                          , DATA        IN            RAW
                          , MIME_TYPE   IN            VARCHAR2 DEFAULT 'application/octet'
                          , INLINE      IN            BOOLEAN DEFAULT TRUE
                          , FILENAME    IN            VARCHAR2 DEFAULT NULL
                          , LAST        IN            BOOLEAN DEFAULT FALSE
                           );

   PROCEDURE BEGIN_ATTACHMENT (CONN           IN OUT NOCOPY UTL_SMTP.CONNECTION
                             , MIME_TYPE      IN            VARCHAR2 DEFAULT 'text/plain'
                             , INLINE         IN            BOOLEAN DEFAULT TRUE
                             , FILENAME       IN            VARCHAR2 DEFAULT NULL
                             , TRANSFER_ENC   IN            VARCHAR2 DEFAULT NULL
                              );

   PROCEDURE END_ATTACHMENT (CONN IN OUT NOCOPY UTL_SMTP.CONNECTION, LAST IN BOOLEAN DEFAULT FALSE );

   PROCEDURE END_MAIL (CONN IN OUT NOCOPY UTL_SMTP.CONNECTION);

   FUNCTION BEGIN_SESSION(nCodCia NUMBER)
      RETURN UTL_SMTP.CONNECTION;

   PROCEDURE BEGIN_MAIL_IN_SESSION (CONN         IN OUT NOCOPY UTL_SMTP.CONNECTION
                                  , SENDER       IN            VARCHAR2
                                  , RECIPIENTS   IN            VARCHAR2
                                  , CC           IN            VARCHAR2 DEFAULT NULL
                                  , BCC          IN            VARCHAR2 DEFAULT NULL
                                  , SUBJECT      IN            VARCHAR2
                                  , MIME_TYPE    IN            VARCHAR2 DEFAULT 'text/plain'
                                  , PRIORITY     IN            PLS_INTEGER DEFAULT NULL
                                   );

   PROCEDURE END_MAIL_IN_SESSION (CONN IN OUT NOCOPY UTL_SMTP.CONNECTION);

   PROCEDURE END_SESSION (CONN IN OUT NOCOPY UTL_SMTP.CONNECTION);

   PROCEDURE SEND_EMAIL (P_DIRECTORY     IN     VARCHAR2
                       , P_SENDER        IN     VARCHAR2
                       , P_RECIPIENT     IN     VARCHAR2
                       , P_CC            IN     VARCHAR2
                       , P_BCC           IN     VARCHAR2
                       , P_SUBJECT       IN     VARCHAR2
                       , P_BODY          IN     VARCHAR2
                       , P_ATTACHMENT1   IN     VARCHAR2 DEFAULT NULL
                       , P_ATTACHMENT2   IN     VARCHAR2 DEFAULT NULL
                       , P_ATTACHMENT3   IN     VARCHAR2 DEFAULT NULL
                       , P_ATTACHMENT4   IN     VARCHAR2 DEFAULT NULL
                       , P_ERROR            OUT VARCHAR2
                        );
END OC_MAIL;
/

--
-- OC_MAIL  (Package Body) 
--
--  Dependencies: 
--   OC_MAIL (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_MAIL IS
    
   PROCEDURE INIT_PARAM IS
   BEGIN
       OC_MAIL.nCodCia      := OC_GENERALES.CODCIA_USUARIO(USER);
       OC_MAIL.SMTP_HOST    := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'019');
       OC_MAIL.SMTP_PORT    := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'020');
       OC_MAIL.SMTP_DOMAIN  := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'019');
   END INIT_PARAM;

   FUNCTION GET_ADDRESS (ADDR_LIST IN OUT VARCHAR2)
      RETURN VARCHAR2 IS
      ADDR   VARCHAR2 (256);
      I      PLS_INTEGER;

      FUNCTION LOOKUP_UNQUOTED_CHAR (STR IN VARCHAR2, CHRS IN VARCHAR2)
         RETURN PLS_INTEGER AS
         C              VARCHAR2 (5);
         I              PLS_INTEGER;
         LEN            PLS_INTEGER;
         INSIDE_QUOTE   BOOLEAN;
      BEGIN
         INSIDE_QUOTE :=   FALSE;
         I :=              1;
         LEN :=            LENGTH (STR);

         WHILE (I <= LEN) LOOP
            C :=   SUBSTR (STR, I, 1);

            IF (INSIDE_QUOTE) THEN
               IF (C = '"') THEN
                  INSIDE_QUOTE :=   FALSE;
               ELSIF (C = '\') THEN
                  I :=   I + 1;                                                              -- Skip the quote character
               END IF;
            END IF;

            IF (C = '"') THEN
               INSIDE_QUOTE :=   TRUE;
            END IF;

            IF (INSTR (CHRS, C) >= 1) THEN
               RETURN I;
            END IF;

            I :=   I + 1;
         END LOOP;

         RETURN 0;
      END;
   BEGIN
      ADDR_LIST :=   LTRIM (ADDR_LIST);
      I :=           LOOKUP_UNQUOTED_CHAR (ADDR_LIST, ',;');

      IF (I >= 1) THEN
         ADDR :=        SUBSTR (ADDR_LIST, 1, I - 1);
         ADDR_LIST :=   SUBSTR (ADDR_LIST, I + 1);
      ELSE
         ADDR :=        ADDR_LIST;
         ADDR_LIST :=   '';
      END IF;

      I :=           LOOKUP_UNQUOTED_CHAR (ADDR, '<');

      IF (I >= 1) THEN
         ADDR :=   SUBSTR (ADDR, I + 1);
         I :=      INSTR (ADDR, '>');

         IF (I >= 1) THEN
            ADDR :=   SUBSTR (ADDR, 1, I - 1);
         END IF;
      END IF;

      RETURN ADDR;
   END;

   PROCEDURE WRITE_MIME_HEADER (CONN IN OUT NOCOPY UTL_SMTP.CONNECTION, NAME IN VARCHAR2, VALUE IN VARCHAR2) IS
   BEGIN
      UTL_SMTP.WRITE_RAW_DATA (CONN, UTL_RAW.CAST_TO_RAW (NAME || ': ' || VALUE || UTL_TCP.CRLF));
   END;

   PROCEDURE WRITE_BOUNDARY (CONN IN OUT NOCOPY UTL_SMTP.CONNECTION, LAST IN BOOLEAN DEFAULT FALSE ) AS
   BEGIN
      IF (LAST) THEN
         UTL_SMTP.WRITE_DATA (CONN, LAST_BOUNDARY);
      ELSE
         UTL_SMTP.WRITE_DATA (CONN, FIRST_BOUNDARY);
      END IF;
   END;

   PROCEDURE MAIL (SENDER       IN VARCHAR2
                 , RECIPIENTS   IN VARCHAR2
                 , CC           IN VARCHAR2 DEFAULT NULL
                 , BCC          IN VARCHAR2 DEFAULT NULL
                 , SUBJECT      IN VARCHAR2
                 , MESSAGE      IN VARCHAR2
                  ) IS
      CONN   UTL_SMTP.CONNECTION;
   BEGIN
      CONN :=
         BEGIN_MAIL (SENDER
                   , RECIPIENTS
                   , CC
                   , BCC
                   , SUBJECT
                    );
      WRITE_TEXT (CONN, MESSAGE);
      END_MAIL (CONN);
   END;

   FUNCTION BEGIN_MAIL (SENDER       IN VARCHAR2
                      , RECIPIENTS   IN VARCHAR2
                      , CC           IN VARCHAR2 DEFAULT NULL
                      , BCC          IN VARCHAR2 DEFAULT NULL
                      , SUBJECT      IN VARCHAR2
                      , MIME_TYPE    IN VARCHAR2 DEFAULT 'text/plain'
                      , PRIORITY     IN PLS_INTEGER DEFAULT NULL
                       )
      RETURN UTL_SMTP.CONNECTION IS
      CONN   UTL_SMTP.CONNECTION;
   BEGIN
      CONN :=   BEGIN_SESSION(nCodCia);
      BEGIN_MAIL_IN_SESSION (CONN
                           , SENDER
                           , RECIPIENTS
                           , CC
                           , BCC
                           , SUBJECT
                           , MIME_TYPE
                           , PRIORITY
                            );
      RETURN CONN;
   END;

   PROCEDURE WRITE_TEXT (CONN IN OUT NOCOPY UTL_SMTP.CONNECTION, MESSAGE IN VARCHAR2) IS
   BEGIN
      UTL_SMTP.WRITE_DATA (CONN, MESSAGE);
   END;

   PROCEDURE WRITE_MB_TEXT (CONN IN OUT NOCOPY UTL_SMTP.CONNECTION, MESSAGE IN VARCHAR2) IS
   BEGIN
      UTL_SMTP.WRITE_RAW_DATA (CONN, UTL_RAW.CAST_TO_RAW (MESSAGE));
   END;

   PROCEDURE WRITE_RAW (CONN IN OUT NOCOPY UTL_SMTP.CONNECTION, MESSAGE IN RAW) IS
   BEGIN
      UTL_SMTP.WRITE_RAW_DATA (CONN, MESSAGE);
   END;

   PROCEDURE ATTACH_TEXT (CONN        IN OUT NOCOPY UTL_SMTP.CONNECTION
                        , DATA        IN            VARCHAR2
                        , MIME_TYPE   IN            VARCHAR2 DEFAULT 'text/plain'
                        , INLINE      IN            BOOLEAN DEFAULT TRUE
                        , FILENAME    IN            VARCHAR2 DEFAULT NULL
                        , LAST        IN            BOOLEAN DEFAULT FALSE
                         ) IS
   BEGIN
      BEGIN_ATTACHMENT (CONN
                      , MIME_TYPE
                      , INLINE
                      , FILENAME
                       );
      WRITE_TEXT (CONN, DATA);
      END_ATTACHMENT (CONN, LAST);
   END;

   PROCEDURE ATTACH_MB_TEXT (CONN        IN OUT NOCOPY UTL_SMTP.CONNECTION
                           , DATA        IN            VARCHAR2
                           , MIME_TYPE   IN            VARCHAR2 DEFAULT 'text/plain'
                           , INLINE      IN            BOOLEAN DEFAULT TRUE
                           , FILENAME    IN            VARCHAR2 DEFAULT NULL
                           , LAST        IN            BOOLEAN DEFAULT FALSE
                            ) IS
   BEGIN
      BEGIN_ATTACHMENT (CONN
                      , MIME_TYPE
                      , INLINE
                      , FILENAME
                       );
      UTL_SMTP.WRITE_RAW_DATA (CONN, UTL_RAW.CAST_TO_RAW (DATA));
      END_ATTACHMENT (CONN, LAST);
   END;

   PROCEDURE ATTACH_BASE64 (CONN        IN OUT NOCOPY UTL_SMTP.CONNECTION
                          , DATA        IN            RAW
                          , MIME_TYPE   IN            VARCHAR2 DEFAULT 'application/octet'
                          , INLINE      IN            BOOLEAN DEFAULT TRUE
                          , FILENAME    IN            VARCHAR2 DEFAULT NULL
                          , LAST        IN            BOOLEAN DEFAULT FALSE
                           ) IS
      I     PLS_INTEGER;
      LEN   PLS_INTEGER;
   BEGIN
      BEGIN_ATTACHMENT (CONN
                      , MIME_TYPE
                      , INLINE
                      , FILENAME
                      , 'base64'
                       );
      I :=     1;
      LEN :=   UTL_RAW.LENGTH (DATA);

      WHILE (I < LEN) LOOP
         IF (I + MAX_BASE64_LINE_WIDTH < LEN) THEN
            UTL_SMTP.WRITE_RAW_DATA (CONN, UTL_ENCODE.BASE64_ENCODE (UTL_RAW.SUBSTR (DATA, I, MAX_BASE64_LINE_WIDTH)));
         ELSE
            UTL_SMTP.WRITE_RAW_DATA (CONN, UTL_ENCODE.BASE64_ENCODE (UTL_RAW.SUBSTR (DATA, I)));
         END IF;

         UTL_SMTP.WRITE_DATA (CONN, UTL_TCP.CRLF);
         I :=   I + MAX_BASE64_LINE_WIDTH;
      END LOOP;

      END_ATTACHMENT (CONN, LAST);
   END;

   PROCEDURE BEGIN_ATTACHMENT (CONN           IN OUT NOCOPY UTL_SMTP.CONNECTION
                             , MIME_TYPE      IN            VARCHAR2 DEFAULT 'text/plain'
                             , INLINE         IN            BOOLEAN DEFAULT TRUE
                             , FILENAME       IN            VARCHAR2 DEFAULT NULL
                             , TRANSFER_ENC   IN            VARCHAR2 DEFAULT NULL
                              ) IS
   BEGIN
      WRITE_BOUNDARY (CONN);
      WRITE_MIME_HEADER (CONN, 'Content-Type', MIME_TYPE);

      IF (FILENAME IS NOT NULL) THEN
         IF (INLINE) THEN
            WRITE_MIME_HEADER (CONN, 'Content-Disposition', 'inline; filename="' || FILENAME || '"');
         ELSE
            WRITE_MIME_HEADER (CONN, 'Content-Disposition', 'attachment; filename="' || FILENAME || '"');
         END IF;
      END IF;

      IF (TRANSFER_ENC IS NOT NULL) THEN
         WRITE_MIME_HEADER (CONN, 'Content-Transfer-Encoding', TRANSFER_ENC);
      END IF;

      UTL_SMTP.WRITE_DATA (CONN, UTL_TCP.CRLF);
   END;

   PROCEDURE END_ATTACHMENT (CONN IN OUT NOCOPY UTL_SMTP.CONNECTION, LAST IN BOOLEAN DEFAULT FALSE ) IS
   BEGIN
      UTL_SMTP.WRITE_DATA (CONN, UTL_TCP.CRLF);

      IF (LAST) THEN
         WRITE_BOUNDARY (CONN, LAST);
      END IF;
   END;

   PROCEDURE END_MAIL (CONN IN OUT NOCOPY UTL_SMTP.CONNECTION) IS
   BEGIN
      END_MAIL_IN_SESSION (CONN);
      END_SESSION (CONN);
   END;

   FUNCTION BEGIN_SESSION(nCodCia NUMBER)
      RETURN UTL_SMTP.CONNECTION IS
      CONN   UTL_SMTP.CONNECTION;
      cPathWallet VARCHAR2(100)   := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'017');
      cPwdWallet    VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'018');
   BEGIN
      CONN := UTL_SMTP.OPEN_CONNECTION (host => OC_MAIL.SMTP_HOST, 
                                        port => OC_MAIL.SMTP_PORT--,
                                        --wallet_path => 'file:'||cPathWallet,
                                        --wallet_password => cPwdWallet,
                                        --secure_connection_before_smtp => FALSE
                                        );
      --UTL_SMTP.HELO (CONN, SMTP_DOMAIN);
      --UTL_SMTP.EHLO(CONN, OC_MAIL.SMTP_DOMAIN);
      --UTL_SMTP.STARTTLS(CONN);
      UTL_SMTP.EHLO(CONN, OC_MAIL.SMTP_DOMAIN);
      UTL_SMTP.command(CONN, 'AUTH','LOGIN');
      UTL_SMTP.command(CONN,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(OC_MAIL.cCtaEnvio))));
      UTL_SMTP.command(CONN,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(OC_MAIL.cPwdCtaEnvio))));
      RETURN CONN;
   END;

   PROCEDURE BEGIN_MAIL_IN_SESSION (CONN         IN OUT NOCOPY UTL_SMTP.CONNECTION
                                  , SENDER       IN            VARCHAR2
                                  , RECIPIENTS   IN            VARCHAR2
                                  , CC           IN            VARCHAR2 DEFAULT NULL
                                  , BCC          IN            VARCHAR2 DEFAULT NULL
                                  , SUBJECT      IN            VARCHAR2
                                  , MIME_TYPE    IN            VARCHAR2 DEFAULT 'text/plain'
                                  , PRIORITY     IN            PLS_INTEGER DEFAULT NULL
                                   ) IS
      MY_RECIPIENTS   VARCHAR2 (32767) := RECIPIENTS;
      MY_SENDER       VARCHAR2 (32767) := SENDER;
      MY_CC           VARCHAR2 (32767) := CC;
      MY_BCC          VARCHAR2 (32767) := BCC;
   BEGIN
      UTL_SMTP.MAIL (CONN, GET_ADDRESS (MY_SENDER));

      WHILE (MY_RECIPIENTS IS NOT NULL) LOOP
         UTL_SMTP.RCPT (CONN, GET_ADDRESS (MY_RECIPIENTS));
      END LOOP;

      WHILE (MY_CC IS NOT NULL) LOOP
         UTL_SMTP.RCPT (CONN, GET_ADDRESS (MY_CC));
      END LOOP;

      WHILE (MY_BCC IS NOT NULL) LOOP
         UTL_SMTP.RCPT (CONN, GET_ADDRESS (MY_BCC));
      END LOOP;

      UTL_SMTP.OPEN_DATA (CONN);
      WRITE_MIME_HEADER (CONN, 'From', SENDER);
      WRITE_MIME_HEADER (CONN, 'To', RECIPIENTS);
      WRITE_MIME_HEADER (CONN, 'CC', CC);
      WRITE_MIME_HEADER (CONN, 'BCC', BCC);
      WRITE_MIME_HEADER (CONN, 'Subject', SUBJECT);
      WRITE_MIME_HEADER (CONN, 'Content-Type', MIME_TYPE);
      WRITE_MIME_HEADER (CONN, 'X-Mailer', MAILER_ID);

      IF (PRIORITY IS NOT NULL) THEN
         WRITE_MIME_HEADER (CONN, 'X-Priority', PRIORITY);
      END IF;

      UTL_SMTP.WRITE_DATA (CONN, UTL_TCP.CRLF);

      IF (MIME_TYPE LIKE 'multipart/mixed%') THEN
         WRITE_TEXT (CONN, 'This is a multi-part message in MIME format.' || UTL_TCP.CRLF);
      END IF;
   END;

   PROCEDURE END_MAIL_IN_SESSION (CONN IN OUT NOCOPY UTL_SMTP.CONNECTION) IS
   BEGIN
      UTL_SMTP.CLOSE_DATA (CONN);
   END;

   PROCEDURE END_SESSION (CONN IN OUT NOCOPY UTL_SMTP.CONNECTION) IS
   BEGIN
      UTL_SMTP.QUIT (CONN);
   END;

   --------------------------------------------------------------------------------------------------------
   ------------------------------------------- Main email procedure ---------------------------------------
   --------------------------------------------------------------------------------------------------------

   PROCEDURE SEND_EMAIL (P_DIRECTORY     IN     VARCHAR2
                       , P_SENDER        IN     VARCHAR2
                       , P_RECIPIENT     IN     VARCHAR2
                       , P_CC            IN     VARCHAR2
                       , P_BCC           IN     VARCHAR2
                       , P_SUBJECT       IN     VARCHAR2
                       , P_BODY          IN     VARCHAR2
                       , P_ATTACHMENT1   IN     VARCHAR2 DEFAULT NULL
                       , P_ATTACHMENT2   IN     VARCHAR2 DEFAULT NULL
                       , P_ATTACHMENT3   IN     VARCHAR2 DEFAULT NULL
                       , P_ATTACHMENT4   IN     VARCHAR2 DEFAULT NULL
                       , P_ERROR            OUT VARCHAR2
                        ) IS
      FIL                BFILE;
      FILE_LEN           PLS_INTEGER;
      MAX_LINE_WIDTH     PLS_INTEGER := 54;
      BUF                RAW (2100);
      AMT                BINARY_INTEGER := 672 * 3;                                    /* ensures proper format; 2016 */
      POS                PLS_INTEGER := 1;                                                  /* pointer for each piece */
      FILEPOS            PLS_INTEGER := 1;                                                    /* pointer for the file */
      T_FILE1            VARCHAR2 (100) := P_ATTACHMENT1;                                   /* binary file attachment */
      T_FILE2            VARCHAR2 (100) := P_ATTACHMENT2;                                   /* binary file attachment */
      T_FILE3            VARCHAR2 (100) := P_ATTACHMENT3;                                   /* binary file attachment */
      T_FILE4            VARCHAR2 (100) := P_ATTACHMENT4;                                   /* binary file attachment */
      V_FILE_NAME        VARCHAR2 (100) := NULL;                                             /* ascii file attachment */
      V_FILE_HANDLE      UTL_FILE.FILE_TYPE;
      V_DIRECTORY_NAME   VARCHAR2 (100) := P_DIRECTORY;
      V_LINE             VARCHAR2 (2000);
      V_RLINE            RAW (1000);
      CONN               UTL_SMTP.CONNECTION;
      MESG               VARCHAR2 (32767);
      MESG_LEN           NUMBER;
      CRLF               VARCHAR2 (2) := CHR (13) || CHR (10);
      DATA               RAW (2100);
      CHUNKS             PLS_INTEGER;
      LEN                PLS_INTEGER := 1;
      MODULO             PLS_INTEGER;
      PIECES             PLS_INTEGER;
      ERR_NUM            NUMBER;
      ERR_MSG            VARCHAR2 (100);
      --v_mime_type_bin varchar2(30) := 'application/pdf';
      --v_mime_type_bin varchar2(30) := 'application/doc';
      --v_mime_type_bin varchar2(30) := 'application/jpg';

      /* Use this mime type when multiple attachments of different types are sent. */
      V_MIME_TYPE_BIN    VARCHAR2 (30) := 'application/octet-stream';
      -- working storage
      FILES              TAB_OF_ATTACHMENTS;
      T_FILE_COUNT       NUMBER := 0;
   BEGIN
      P_ERROR :=   '0';

      -- put the attachments into the pl/sql table
      IF T_FILE1 IS NOT NULL THEN
         FILES :=                TAB_OF_ATTACHMENTS (NULL);
         FILES (1).FILENAME :=   T_FILE1;
         T_FILE_COUNT :=         1;

         IF T_FILE2 IS NOT NULL THEN
            FILES.EXTEND (1);
            FILES (2).FILENAME :=   T_FILE2;
            T_FILE_COUNT :=         2;
         END IF;

         IF T_FILE3 IS NOT NULL THEN
            FILES.EXTEND (1);
            FILES (3).FILENAME :=   T_FILE3;
            T_FILE_COUNT :=         3;
         END IF;

         IF T_FILE4 IS NOT NULL THEN
            FILES.EXTEND (1);
            FILES (4).FILENAME :=   T_FILE4;
            T_FILE_COUNT :=         4;
         END IF;
      ELSE
         T_FILE_COUNT :=   0;
      END IF;


      BEGIN
         CONN :=
            OC_MAIL.BEGIN_MAIL (SENDER => P_SENDER
                                , RECIPIENTS => P_RECIPIENT
                                , CC =>     P_CC
                                , BCC =>    P_BCC
                                , SUBJECT => P_SUBJECT
                                , MIME_TYPE => OC_MAIL.MULTIPART_MIME_TYPE
                                 );
      END BEGIN_MAIL;

      BEGIN
        --OC_MAIL.ATTACH_TEXT (CONN => CONN, DATA => P_BODY || CRLF || CRLF, MIME_TYPE => 'text/html');
        OC_MAIL.ATTACH_MB_TEXT (CONN => CONN, DATA => P_BODY || CRLF || CRLF, MIME_TYPE => 'text/html');
      END ATTACH_TEXT;


      BEGIN
         -- check to see if there are any attachments (otherwise the loop will error!)
         IF T_FILE_COUNT > 0 THEN
            -- loop through attachments
            FOR I IN 1 .. FILES.COUNT LOOP
               OC_MAIL.BEGIN_ATTACHMENT (CONN =>   CONN
                                         , MIME_TYPE => V_MIME_TYPE_BIN
                                         , INLINE => TRUE
                                         , FILENAME => FILES (I).FILENAME
                                         , TRANSFER_ENC => 'base64'
                                          );

               BEGIN
                  FILEPOS :=    1;                                   /* Insures we are pointing to beginning of file. */
                  AMT :=        672 * 3;                             /* Insures amount is re-initialize for each file */
                  FIL :=        BFILENAME (V_DIRECTORY_NAME, FILES (I).FILENAME);
                  FILE_LEN :=   DBMS_LOB.GETLENGTH (FIL);
                  MODULO :=     MOD (FILE_LEN, AMT);

                  PIECES :=     TRUNC (FILE_LEN / AMT);

                  IF (MODULO <> 0) THEN
                     PIECES :=   PIECES + 1;
                  END IF;

                  DBMS_LOB.FILEOPEN (FIL, DBMS_LOB.FILE_READONLY);
                  DBMS_LOB.READ (FIL
                               , AMT
                               , FILEPOS
                               , BUF
                                );
                  DATA :=       NULL;

                  FOR I IN 1 .. PIECES LOOP
                     FILEPOS :=    I * AMT + 1;
                     FILE_LEN :=   FILE_LEN - AMT;
                     DATA :=       UTL_RAW.CONCAT (DATA, BUF);
                     CHUNKS :=     TRUNC (UTL_RAW.LENGTH (DATA) / MAX_LINE_WIDTH);

                     IF (I <> PIECES) THEN
                        CHUNKS :=   CHUNKS - 1;
                     END IF;

                     OC_MAIL.WRITE_RAW (CONN => CONN, MESSAGE => UTL_ENCODE.BASE64_ENCODE (DATA));
                     DATA :=       NULL;

                     IF (FILE_LEN < AMT
                     AND FILE_LEN > 0) THEN
                        AMT :=   FILE_LEN;
                     END IF;

                     /* Insures we only read again if there is more data. */
                     /*Commented and changed on 18-Apr-2008*/
                     --if (file_len > amt) then
                     --dbms_lob.read(fil, amt, filepos, buf);
                     --end if;
                     ---Changed code----------
                     IF (FILE_LEN = 0) THEN
                        NULL;
                     ELSE
                        DBMS_LOB.READ (FIL
                                     , AMT
                                     , FILEPOS
                                     , BUF
                                      );
                     END IF;
                  -----------------------------
                  END LOOP;
               END;

               DBMS_LOB.FILECLOSE (FIL);
               OC_MAIL.END_ATTACHMENT (CONN => CONN);
            END LOOP;
         END IF;
      END BEGIN_ATTACHMENT;

      OC_MAIL.END_MAIL (CONN => CONN);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         OC_MAIL.END_ATTACHMENT (CONN => CONN);
         DBMS_LOB.FILECLOSE (FIL);
         P_ERROR :=   'Error: No data found.';
      WHEN OTHERS THEN
         OC_MAIL.END_ATTACHMENT (CONN => CONN);
         ERR_NUM :=   SQLCODE;
         ERR_MSG :=   SUBSTR (SQLERRM, 1, 100);
         P_ERROR :=   'Error: ' || ERR_NUM || ' - ' || ERR_MSG;
         DBMS_OUTPUT.PUT_LINE ('Error number is ' || ERR_NUM);
         DBMS_OUTPUT.PUT_LINE ('Error message is ' || ERR_MSG);
         DBMS_LOB.FILECLOSE (FIL);
   END;
END OC_MAIL;
/

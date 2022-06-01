DROP TABLE SICAS_OC.CARGA_ASEGURADOS_EXT
/
--
-- CARGA_ASEGURADOS_EXT  (Table) 
--
CREATE TABLE SICAS_OC.CARGA_ASEGURADOS_EXT
   (	CODEMPRESA               NUMBER(14,0)
   ,  IDTIPOSEG                VARCHAR2(200 BYTE)
   ,  PLANCOB                  VARCHAR2(200 BYTE)
   ,  NUMPOLUNICO              VARCHAR2(200 BYTE)
   ,  SUBGRUPO                 NUMBER
   ,  TIPO_DOC_IDENTIFICACION  VARCHAR2(200 BYTE)
   ,  NUM_DOC_IDENTIFICACION   VARCHAR2(200 BYTE)
   ,  NOMBRE                   VARCHAR2(200 BYTE)
   ,  APELLIDO_PATERNO         VARCHAR2(200 BYTE)
   ,  APELLIDO_MATERNO         VARCHAR2(200 BYTE)
   ,  SEXO                     VARCHAR2(200 BYTE)
   ,  FECNACIMIENTO            DATE
   ,  TIPO_ID_TRIBUTARIA       VARCHAR2(200 BYTE)
   ,  NUMTRIBUTARIO            VARCHAR2(200 BYTE)
   ,  FECINGRESO               DATE
   ,  FECSTATUS                DATE
   ,  DIRECRES                 VARCHAR2(200 BYTE)
   ,  CODIGOZIP                VARCHAR2(200 BYTE)
   ,  CLIENTEUNICO             VARCHAR2(200 BYTE)
   ,  FECINIVIG                DATE
   ,  FECFINVIG                DATE
   ,  FECINIVIG2               DATE
   ,  FECFINVIG2               DATE
   ,  SUMAASEGURADA            NUMBER(18,2)
   ,  SUELDO                   NUMBER(18,2)
   ,  NUTRA                    NUMBER
   ,  VECESSALARIO             NUMBER(18,2)
   ,  CAMPOFLEXIBLE1           NUMBER(18,2)
   ,  CAMPOFLEXIBLE2           NUMBER(18,2)
   ,  CAMPOFLEXIBLE3           NUMBER(18,2)
   ,  CAMPOFLEXIBLE4           NUMBER(18,2)
   ,  CAMPOFLEXIBLE5           NUMBER(18,2)
   ,  CAMPOFLEXIBLE6           NUMBER(18,2)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "DIR_TMP"
      ACCESS PARAMETERS
         ( RECORDS DELIMITED BY NEWLINE
           BADFILE DIR_TMP:'carga_asegurados.bad'
           LOGFILE DIR_TMP:'carga_asegurados.log'
           FIELDS TERMINATED BY ',' 
           MISSING FIELD VALUES ARE NULL
           ( CODEMPRESA
           , IDTIPOSEG
           , PLANCOB
           , NUMPOLUNICO
           , SUBGRUPO
           , TIPO_DOC_IDENTIFICACION
           , NUM_DOC_IDENTIFICACION
           , NOMBRE
           , APELLIDO_PATERNO
           , APELLIDO_MATERNO
           , SEXO
           , FECNACIMIENTO            CHAR DATE_FORMAT DATE MASK "DD/MM/YYYY"
           , TIPO_ID_TRIBUTARIA
           , NUMTRIBUTARIO
           , FECINGRESO               CHAR DATE_FORMAT DATE MASK "DD/MM/YYYY"
           , FECSTATUS                CHAR DATE_FORMAT DATE MASK "DD/MM/YYYY"
           , DIRECRES
           , CODIGOZIP
           , CLIENTEUNICO
           , FECINIVIG                CHAR DATE_FORMAT DATE MASK "DD/MM/YYYY"
           , FECFINVIG                CHAR DATE_FORMAT DATE MASK "DD/MM/YYYY"
           , FECINIVIG2               CHAR DATE_FORMAT DATE MASK "DD/MM/YYYY"
           , FECFINVIG2               CHAR DATE_FORMAT DATE MASK "DD/MM/YYYY"
           , SUMAASEGURADA
           , SUELDO
           , NUTRA
           , VECESSALARIO
           , CAMPOFLEXIBLE1
           , CAMPOFLEXIBLE2
           , CAMPOFLEXIBLE3
           , CAMPOFLEXIBLE4
           , CAMPOFLEXIBLE5
           , CAMPOFLEXIBLE6
           )
         )
      LOCATION ( 'carga_asegurados.csv' )
    )
   REJECT LIMIT UNLIMITED
/

--
-- CARGA_ASEGURADOS_EXT  (Synonym) 
--
--  Dependencies: 
--   CARGA_ASEGURADOS_EXT (Table)
--
CREATE OR REPLACE PUBLIC SYNONYM CARGA_ASEGURADOS_EXT FOR SICAS_OC.CARGA_ASEGURADOS_EXT
/

GRANT SELECT ON SICAS_OC.CARGA_ASEGURADOS_EXT TO PUBLIC
/
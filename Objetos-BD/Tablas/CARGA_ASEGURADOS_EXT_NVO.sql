DROP TABLE SICAS_OC.CARGA_ASEGURADOS_EXT;
-- Create table
CREATE TABLE SICAS_OC.CARGA_ASEGURADOS_EXT
(
  codempresa              NUMBER(14),
  idtiposeg               VARCHAR2(200),
  plancob                 VARCHAR2(200),
  numpolunico             VARCHAR2(200),
  subgrupo                NUMBER,
  tipo_doc_identificacion VARCHAR2(200),
  num_doc_identificacion  VARCHAR2(200),
  nombre                  VARCHAR2(200),
  apellido_paterno        VARCHAR2(200),
  apellido_materno        VARCHAR2(200),
  sexo                    VARCHAR2(200),
  fecnacimiento           DATE,
  tipo_id_tributaria      VARCHAR2(200),
  numtributario           VARCHAR2(200),
  fecingreso              DATE,
  fecstatus               DATE,
  direcres                VARCHAR2(200),
  codigozip               VARCHAR2(200),
  clienteunico            VARCHAR2(200),
  fecinivig               DATE,
  fecfinvig               DATE,
  fecinivig2              DATE,
  fecfinvig2              DATE,
  sumaasegurada           NUMBER(18,2),
  sueldo                  NUMBER(18,2),
  nutra                   VARCHAR2(200),
  vecessalario            NUMBER(18,2),
  campoflexible1          NUMBER(18,2),
  campoflexible2          NUMBER(18,2),
  campoflexible3          NUMBER(18,2),
  campoflexible4          NUMBER(18,2),
  campoflexible5          NUMBER(18,2),
  campoflexible6          NUMBER(18,2)
)
ORGANIZATION EXTERNAL
(
  type ORACLE_LOADER
  default directory DIR_CARGA_ASEG
  access parameters 
  (
    RECORDS DELIMITED BY NEWLINE
    BADFILE DIR_CARGA_ASEG:'carga_asegurados.bad'
    LOGFILE DIR_CARGA_ASEG:'carga_asegurados.log'
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
  location (DIR_CARGA_ASEG:'carga_asegurados.csv')
)
REJECT LIMIT UNLIMITED;
-- Grant/Revoke object privileges 
grant select on SICAS_OC.CARGA_ASEGURADOS_EXT to PUBLIC;
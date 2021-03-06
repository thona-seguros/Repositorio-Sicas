DROP TABLE SICAS_OC.CATEGORIAS;

CREATE TABLE SICAS_OC.CATEGORIAS
(
  CODCIA          NUMBER(14),
  CODEMPRESA      NUMBER(14),
  CODTIPONEGOCIO  VARCHAR2(100),
  CODCATEGO       VARCHAR2(14 CHAR),
  DESCCATEGO      VARCHAR2(200 CHAR),
  CODUSUARIO      VARCHAR2(30 CHAR) DEFAULT USER,
  FECHAMODIF      DATE DEFAULT SYSDATE
)
RESULT_CACHE (MODE DEFAULT)
STORAGE    (
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
NOMONITORING;

COMMENT ON TABLE SICAS_OC.CATEGORIAS IS 'Cat�logo del subnivel del tipo de negocio (categorias)';
COMMENT ON COLUMN SICAS_OC.CATEGORIAS.CODCIA IS 'C�digo de la compa�ia';
COMMENT ON COLUMN SICAS_OC.CATEGORIAS.CODEMPRESA IS 'C�digo de la empresa';
COMMENT ON COLUMN SICAS_OC.CATEGORIAS.CODTIPONEGOCIO IS 'Identifica el tipo de negocio';
COMMENT ON COLUMN SICAS_OC.CATEGORIAS.CODCATEGO IS 'Identifica la categoria';
COMMENT ON COLUMN SICAS_OC.CATEGORIAS.DESCCATEGO IS 'Descripci�n de la categoria';
COMMENT ON COLUMN  SICAS_OC.CATEGORIAS.CODUSUARIO IS  'Usuario que modifica el registro';
COMMENT ON COLUMN  SICAS_OC.CATEGORIAS.FECHAMODIF IS  'Fecha en que se modifica el registro';
/
ALTER TABLE SICAS_OC.CATEGORIAS ADD (
  CONSTRAINT CATEGORIAS_PK
  PRIMARY KEY
  (CODCIA, CODEMPRESA, CODTIPONEGOCIO, CODCATEGO)
  ENABLE VALIDATE);
/
GRANT SELECT, INSERT, UPDATE, DELETE, INDEX, ALTER ON SICAS_OC.CATEGORIAS TO "PUBLIC"; 
/
CREATE PUBLIC SYNONYM CATEGORIAS FOR SICAS_OC.CATEGORIAS;
/

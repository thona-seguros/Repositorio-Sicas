DROP TABLE SICAS_OC.COTIZACIONES_GPO_COBERT_WEB
/
--
-- COTIZACIONES_GPO_COBERT_WEB  (Table) 
--
CREATE TABLE SICAS_OC.COTIZACIONES_GPO_COBERT_WEB
(
  CODCIA            NUMBER(14)           NOT NULL,
  CODEMPRESA        NUMBER(14)           NOT NULL,
  IDCOTIZACION      NUMBER(14)           NOT NULL,
  CODGPOCOBERTWEB   VARCHAR2(6 BYTE)     NOT NULL
)
TABLESPACE TS_SICASOC
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/

COMMENT ON TABLE SICAS_OC.COTIZACIONES_GPO_COBERT_WEB IS 'Cotizaciones Grupo Coberturas Web'
/

COMMENT ON COLUMN SICAS_OC.COTIZACIONES_GPO_COBERT_WEB.CODCIA IS 'C�digo de la Compa��a'
/

COMMENT ON COLUMN SICAS_OC.COTIZACIONES_GPO_COBERT_WEB.CODEMPRESA IS 'C�digo de la Empresa'
/

COMMENT ON COLUMN SICAS_OC.COTIZACIONES_GPO_COBERT_WEB.IDCOTIZACION IS 'No. de Cotizaci�n'
/

COMMENT ON COLUMN SICAS_OC.COTIZACIONES_GPO_COBERT_WEB.CODGPOCOBERTWEB IS 'C�digo del Grupo de Coberturas Web'
/



--
-- COTIZACIONES_GPO_COBERT_WEB_PK  (Index) 
--
--  Dependencies: 
--   COTIZACIONES_GPO_COBERT_WEB (Table)
--
CREATE UNIQUE INDEX SICAS_OC.COTIZACIONES_GPO_COBERT_WEB_PK ON SICAS_OC.COTIZACIONES_GPO_COBERT_WEB
(CODCIA, CODEMPRESA, IDCOTIZACION, CODGPOCOBERTWEB)
LOGGING
TABLESPACE IDX_SICASOC
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL
/


--
-- COTIZACIONES_GPO_COBERT_WEB  (Synonym) 
--
--  Dependencies: 
--   COTIZACIONES_GPO_COBERT_WEB (Table)
--
CREATE OR REPLACE PUBLIC SYNONYM COTIZACIONES_GPO_COBERT_WEB FOR SICAS_OC.COTIZACIONES_GPO_COBERT_WEB
/


-- 
-- Non Foreign Key Constraints for Table COTIZACIONES_GPO_COBERT_WEB 
-- 
ALTER TABLE SICAS_OC.COTIZACIONES_GPO_COBERT_WEB ADD (
  CONSTRAINT COTIZACIONES_GPO_COBERT_WEB_PK
  PRIMARY KEY
  (CODCIA, CODEMPRESA, IDCOTIZACION, CODGPOCOBERTWEB)
  USING INDEX SICAS_OC.COTIZACIONES_GPO_COBERT_WEB_PK
  ENABLE VALIDATE)
/

GRANT DELETE, INSERT, SELECT, UPDATE ON SICAS_OC.COTIZACIONES_GPO_COBERT_WEB TO PUBLIC
/
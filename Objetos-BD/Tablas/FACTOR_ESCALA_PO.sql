DROP TABLE SICAS_OC.FACTOR_ESCALA_PO Cascade Constraints;
/
--
-- FACTOR_ESCALA_PO  (Table) 
--
CREATE TABLE SICAS_OC.FACTOR_ESCALA_PO
(
  CodCia              NUMBER(14)                NOT NULL,
  CodEmpresa          NUMBER(14)                NOT NULL,
  IdTipoSeg           VARCHAR2(6 BYTE)          NOT NULL,
  PlanCob             VARCHAR2(15 BYTE)         NOT NULL,
  CodCobert           VARCHAR2(7 BYTE)          NOT NULL,
  Escala              VARCHAR2(1 BYTE)          NOT NULL,
  Factor              NUMBER(9,7)
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

COMMENT ON TABLE SICAS_OC.FACTOR_ESCALA_PO IS 'Factor Para El Gasto Usual Acostumbrado'
/

COMMENT ON COLUMN SICAS_OC.FACTOR_ESCALA_PO.CodCia IS 'Código del Compañía'
/

COMMENT ON COLUMN SICAS_OC.FACTOR_ESCALA_PO.CodEmpresa IS 'Código de la Empresa'
/

COMMENT ON COLUMN SICAS_OC.FACTOR_ESCALA_PO.IdTipoSeg IS 'Identificador del Tipo de Seguro'
/

COMMENT ON COLUMN SICAS_OC.FACTOR_ESCALA_PO.PlanCob IS 'Identificador del Plan de Coberturas'
/

COMMENT ON COLUMN SICAS_OC.FACTOR_ESCALA_PO.CodCobert IS 'Código de Cobertura'
/

COMMENT ON COLUMN SICAS_OC.FACTOR_ESCALA_PO.Escala IS 'Escala de Perdida Orgánica'
/

COMMENT ON COLUMN SICAS_OC.FACTOR_ESCALA_PO.Factor IS 'Factor'
/

--
-- FACTOR_ESCALA_PO_PK  (Index) 
--
--  Dependencies: 
--   FACTOR_ESCALA_PO (Table)
--
CREATE UNIQUE INDEX SICAS_OC.FACTOR_ESCALA_PO_PK ON SICAS_OC.FACTOR_ESCALA_PO
(CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodCobert, Escala )
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
-- FACTOR_ESCALA_PO  (Synonym) 
--
--  Dependencies: 
--   FACTOR_ESCALA_PO (Table)
--
CREATE OR REPLACE PUBLIC SYNONYM FACTOR_ESCALA_PO FOR SICAS_OC.FACTOR_ESCALA_PO
/


-- 
-- Non Foreign Key Constraints for Table FACTOR_ESCALA_PO 
-- 
ALTER TABLE SICAS_OC.FACTOR_ESCALA_PO ADD (
  CONSTRAINT FACTOR_ESCALA_PO_PK
  PRIMARY KEY
  (CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodCobert, Escala )
  USING INDEX SICAS_OC.FACTOR_ESCALA_PO_PK
  ENABLE VALIDATE)
/

GRANT DELETE, INSERT, SELECT, UPDATE ON SICAS_OC.FACTOR_ESCALA_PO TO PUBLIC
/
CREATE TABLE FACTORES_RIESGOS
 (CodCia               NUMBER(14) NOT NULL,
  CodEmpresa           NUMBER(14,0) NOT NULL,
  IdTipoSeg            VARCHAR2(6) NOT NULL,
  PlanCob              VARCHAR2(15) NOT NULL,
  FecIniVig            DATE NOT NULL,
  FecFinVig            DATE NOT NULL,
  RiesgoTarifa         VARCHAR2(2) NOT NULL,
  FactorRiesgo         NUMBER(14,9) NOT NULL)

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
MONITORING;  
/
COMMENT ON TABLE FACTORES_RIESGOS IS 'Factor Tipo por Riesgo'
/
COMMENT ON COLUMN FACTORES_RIESGOS.CodCia IS 'Código del Compañía'
/
COMMENT ON COLUMN FACTORES_RIESGOS.CodEmpresa IS 'Código de Empresa'
/
COMMENT ON COLUMN FACTORES_RIESGOS.IdTipoSeg IS 'Identificador Unico del Tipo de Seguro'
/
COMMENT ON COLUMN FACTORES_RIESGOS.PlanCob IS 'Identificador del Plan de Coberturas'
/
COMMENT ON COLUMN FACTORES_RIESGOS.FecIniVig IS 'Fecha de Inicio de Vigencia del Factor Riesgo'
/
COMMENT ON COLUMN FACTORES_RIESGOS.FecFinVig IS 'Fecha de Fin de Vigencia del Factor Riesgo'
/
COMMENT ON COLUMN FACTORES_RIESGOS.RiesgoTarifa IS 'Riesgo del Asegurado para Tarifa'
/
COMMENT ON COLUMN FACTORES_RIESGOS.FactorRiesgo IS 'Factor de Riesgo'
/

ALTER TABLE FACTORES_RIESGOS
   ADD (CONSTRAINT PK_FACTORES_RIESGOS
    PRIMARY KEY (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, FecFinVig, RiesgoTarifa)
    USING INDEX)
/

-- Foreign Key
ALTER TABLE FACTORES_RIESGOS
ADD FOREIGN KEY (CodCia, CodEmpresa, IdTipoSeg, PlanCob)
REFERENCES PLAN_COBERTURAS(CodCia, CodEmpresa, IdTipoSeg, PlanCob) ON DELETE CASCADE
/

CREATE PUBLIC SYNONYM FACTORES_RIESGOS FOR FACTORES_RIESGOS;
/
-- =============================
-- Genera los permisos
-- ============================= 
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER, INDEX ON SICAS_OC.FACTORES_RIESGOS TO ROL_MODIFICA_SICAS;
GRANT SELECT ON SICAS_OC.FACTORES_RIESGOS TO ROL_CONSULTA_SICAS;

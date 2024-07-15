-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM REGI_COBRANZA_MASIVA;
DROP TABLE SICAS_OC.REGI_COBRANZA_MASIVA;

CREATE TABLE REGI_COBRANZA_MASIVA (
CodCia         NUMBER(14)     NOT NULL,
CodEmpresa     NUMBER(14)     NOT NULL,
IdCobranza     NUMBER(14)     NOT NULL,
IdPoliza       NUMBER(14)     NOT NULL,
IDetPol        NUMBER(14)     NOT NULL,
IdFactura      NUMBER(14)     NOT NULL,
IdTipoSeg      VARCHAR2(6)    NOT NULL,
PlanCob        VARCHAR2(15)   NOT NULL,
TipoProceso    VARCHAR2(30)   NOT NULL,
RegDatosProc   VARCHAR2(4000) NOT NULL,
NumPolUnico    VARCHAR2(30),
NumDetUnico    VARCHAR2(30),
IndColectiva   VARCHAR2(1),
IndAsegurado   VARCHAR2(1),
FechaEstatus   DATE           default sysdate,
CodUsuario     VARCHAR2(30 CHAR) default USER,
status         VARCHAR2(1)
)
TABLESPACE TS_SICASOC
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
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
/
ALTER TABLE SICAS_OC.REGI_COBRANZA_MASIVA ADD (
  CONSTRAINT PK_REGI_COBRANZA_MASIVA
  PRIMARY KEY
  (CodCia, CodEmpresa, IdCobranza)
  USING INDEX
    TABLESPACE TS_SICASOC
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
  ENABLE VALIDATE);
/
COMMENT ON TABLE REGI_COBRANZA_MASIVA IS 'Tabla para Cargar Cobranza Masiva del Sistema'
/
COMMENT ON COLUMN REGI_COBRANZA_MASIVA.IdCobranza IS 'Id de Registro de Cobranza Masiva'
/
COMMENT ON COLUMN REGI_COBRANZA_MASIVA.CodCia IS 'Codigo de compañia'
/
COMMENT ON COLUMN REGI_COBRANZA_MASIVA.CodEmpresa IS 'Codigo de empresa'
/
COMMENT ON COLUMN REGI_COBRANZA_MASIVA.IdPoliza IS 'Consecutivo de Póliza'
/
COMMENT ON COLUMN REGI_COBRANZA_MASIVA.IDetPol IS 'No. Detalle de Póliza'
/
COMMENT ON COLUMN REGI_COBRANZA_MASIVA.IdFactura IS 'Número de Factura'
/
COMMENT ON COLUMN REGI_COBRANZA_MASIVA.IdTipoSeg  IS 'Tipo de Seguro'
/
COMMENT ON COLUMN REGI_COBRANZA_MASIVA.PlanCob IS 'Plan de Cobertura'
/
COMMENT ON COLUMN REGI_COBRANZA_MASIVA.TipoProceso IS 'Tipo de Proceso: Emisi¿n, Cancelación, Siniestros, etc.'
/
COMMENT ON COLUMN REGI_COBRANZA_MASIVA.RegDatosProc IS 'Registro de Datos para el Proceso'
/
COMMENT ON COLUMN REGI_COBRANZA_MASIVA.NumPolUnico IS 'No. Unico de Póliza'
/
COMMENT ON COLUMN REGI_COBRANZA_MASIVA.NumDetUnico IS 'No. Unico de Detalle o Certificado'
/
COMMENT ON COLUMN REGI_COBRANZA_MASIVA.IndColectiva IS 'Indicador de Poliza Colectiva'
/
COMMENT ON COLUMN REGI_COBRANZA_MASIVA.IndAsegurado IS 'Indicador de Asegurado'
/
COMMENT ON COLUMN REGI_COBRANZA_MASIVA.FechaEstatus IS 'Fecha de Status'
/
COMMENT ON COLUMN REGI_COBRANZA_MASIVA.CodUsuario IS 'Usuario que Procesa el Pago'
/
COMMENT ON COLUMN REGI_COBRANZA_MASIVA.status IS 'El status del registro'

/
-- =============================
-- Genera los permisos
-- ============================= 
grant select, insert, update, delete on SICAS_OC.REGI_COBRANZA_MASIVA to PUBLIC;
/
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE OR REPLACE PUBLIC SYNONYM REGI_COBRANZA_MASIVA FOR SICAS_OC.REGI_COBRANZA_MASIVA;

/
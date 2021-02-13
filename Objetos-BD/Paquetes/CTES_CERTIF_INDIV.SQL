-- Tablas de Clientes y Usuarios para Asegurados UNAM (nueva funcionalidad Febrero 2021).
-- Tabla de Clientes con Servicio de Certificados (Polizas) Individuales (UNAM Cliente inicial)
CREATE TABLE CTES_CERTIF_INDIV (
IdCertCte	        NUMBER(14,0) NOT NULL,-- PRIMARY KEY,
CodCia	            NUMBER(14,0) NOT NULL,
CodEmpresa	        NUMBER(14,0) NOT NULL,
CodCliente	        NUMBER(14,0) NOT NULL,
StsCertCte	        VARCHAR2(10 BYTE),
FecRegistro         DATE,
UserRegistro        VARCHAR2(30 BYTE),
FecUltActualiza     DATE,
UserUltActualiza    VARCHAR2(30 BYTE),
CONSTRAINT PK_CTE_CERTIF_IND PRIMARY KEY(IdCertCte, CodCia, CodEmpresa) USING INDEX TABLESPACE IDX_SICASOC
--constraint PK_USR_CERTIF_IND (IdCertCte) USING INDEX TABLESPACE IDX_SICASOC
) TABLESPACE TS_SICASOC;
/
COMMENT ON TABLE CTES_CERTIF_INDIV IS 'Clientes con Servicio de Impresion de Certificados Individuales';
COMMENT ON COLUMN CTES_CERTIF_INDIV.IdCertCte IS 'ID del Cliente con este Servicio';
COMMENT ON COLUMN CTES_CERTIF_INDIV.CodCia IS 'Codigo de Compañia';
COMMENT ON COLUMN CTES_CERTIF_INDIV.CodEmpresa IS 'Codigo de Empresa';
COMMENT ON COLUMN CTES_CERTIF_INDIV.CodCliente IS 'Codigo del Cliente';
COMMENT ON COLUMN CTES_CERTIF_INDIV.StsCertCte IS 'Estado del Cliente con este servicio';
/
CREATE OR REPLACE PUBLIC SYNONYM CTES_CERTIF_INDIV FOR SICAS_OC.CTES_CERTIF_INDIV;
/
GRANT SELECT, INSERT, UPDATE, DELETE ON CTES_CERTIF_INDIV TO PUBLIC;
/

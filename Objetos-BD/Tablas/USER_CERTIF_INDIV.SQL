-- Tabla de Asegurados con Servicio de Certificados (Polizas) Individuales (UNAM Cliente inicial)
CREATE TABLE USER_CERTIF_INDIV (
IdUsuario           NUMBER(10),
CodCia	            NUMBER(14,0) NOT NULL,
CodEmpresa	        NUMBER(14,0) NOT NULL,
CodAsegurado	    NUMBER(14,0) NOT NULL,
Password	        VARCHAR2(2000 BYTE) NOT NULL,
Email               VARCHAR2(150 BYTE) NOT NULL,
NoIntento	        NUMBER(2,0) NOT NULL,
StsUser             VARCHAR2(10 BYTE) NOT NULL,
IdCertCte	        NUMBER(14,0) NOT NULL,
FecRegistro         DATE NOT NULL,
UserRegistro        VARCHAR2(30 BYTE) NOT NULL,
FecUltActualiza     DATE,
UserUltActualiza    VARCHAR2(30 BYTE),
CONSTRAINT PK_USR_CERTIF_IND2 PRIMARY KEY (IdUsuario, CodCia, CodEmpresa) USING INDEX TABLESPACE IDX_SICASOC,
CONSTRAINT FK_USR_CERTIF_IND2 FOREIGN KEY (IdCertCte, CodCia, CodEmpresa) REFERENCES CTES_CERTIF_INDIV (IdCertCte, CodCia, CodEmpresa)
) TABLESPACE TS_SICASOC;
/
COMMENT ON TABLE USER_CERTIF_INDIV IS 'Tabla de Usuarios para Certificados Individuales';
COMMENT ON COLUMN USER_CERTIF_INDIV.IdUsuario IS 'Consecutivo del Usuario del sistema para el Asegurado';
COMMENT ON COLUMN USER_CERTIF_INDIV.CodCia IS 'Codigo de Compañia';
COMMENT ON COLUMN USER_CERTIF_INDIV.CodEmpresa IS 'Codigo de Empresa';
COMMENT ON COLUMN USER_CERTIF_INDIV.CodAsegurado IS 'Codigo del Asegurado';
COMMENT ON COLUMN USER_CERTIF_INDIV.Password IS 'Contraseña del usuario Encriptada';
COMMENT ON COLUMN USER_CERTIF_INDIV.Email IS 'Correo Electronico del Asegurado';
COMMENT ON COLUMN USER_CERTIF_INDIV.NoIntento IS 'Numero de intentos de impresion de Certificado';
COMMENT ON COLUMN USER_CERTIF_INDIV.StsUser IS 'Estado del Usuario del Asegurado';
COMMENT ON COLUMN USER_CERTIF_INDIV.IdCertCte IS 'ID del Cliente al que pertenece el Asegurado';
COMMENT ON COLUMN USER_CERTIF_INDIV.FecRegistro IS 'Fecha de registro o alta del Usuario en esta tabla';
COMMENT ON COLUMN USER_CERTIF_INDIV.UserRegistro IS 'Fecha de registro o alta del Usuario en esta tabla';
COMMENT ON COLUMN USER_CERTIF_INDIV.FecUltActualiza IS 'Fecha de ultima actualizacion del registro';
COMMENT ON COLUMN USER_CERTIF_INDIV.UserUltActualiza IS 'Usuario que actualizo por ultima ve el registro';
/
CREATE OR REPLACE PUBLIC SYNONYM USER_CERTIF_INDIV FOR SICAS_OC.USER_CERTIF_INDIV;
/
GRANT SELECT, INSERT, UPDATE, DELETE ON USER_CERTIF_INDIV TO PUBLIC;
/

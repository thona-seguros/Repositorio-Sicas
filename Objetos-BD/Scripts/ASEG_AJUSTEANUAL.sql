-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM ASEG_AJUSTEANUAL;
DROP TABLE SICAS_OC.ASEG_AJUSTEANUAL;

CREATE TABLE SICAS_OC.ASEG_AJUSTEANUAL
(
  CodEmpresa               NUMBER(14)    NOT NULL,
  IdRegistro               NUMBER        NOT NULL,
  IdPoliza                 NUMBER(14)    NOT NULL,
  CodUsuario               VARCHAR2(30 CHAR)NOT NULL,
  NumPolunico              VARCHAR2(30)  NOT NULL,
  IDetPol                  NUMBER(14)    NOT NULL,
  Tipo_Doc_Identificacion  VARCHAR2(6)   NOT NULL, 
  Num_Doc_Identificacion   VARCHAR2(20)  NOT NULL,
  Nombre                   VARCHAR2(200) NOT NULL,
  Apellido_Paterno         VARCHAR2(50)  NOT NULL,
  Apellido_Materno         VARCHAR2(50)  NOT NULL,
  Sexo                     VARCHAR2(1)   NOT NULL,
  FecNacimiento            DATE          NOT NULL,
  Direcres                 VARCHAR2(250),
  CodPosres                VARCHAR2(30),
  FecInvig                 DATE          NOT NULL,
  FecFinVig                DATE          NOT NULL,
  SumaAseg                 NUMBER(18,2)  NOT NULL,
  Sueldo                   NUMBER(18,2),
  Nutra                    VARCHAR2(500)
)
TABLESPACE TS_SICASOC
  PCTFREE 10
  INITRANS 1
  MAXTRANS 255
  STORAGE 
  (
    INITIAL 64K
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
/
-- =============================
-- CREA COMENTARIOS DE LA TABLA
-- =============================
comment on table SICAS_OC.ASEG_AJUSTEANUAL
  is 'Tabla de paso para los Asegurados de Ajuste Anual';
-- Add comments to the columns 
comment on column SICAS_OC.ASEG_AJUSTEANUAL.CodEmpresa 
  is 'Codigo de empresa';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.IdRegistro 
  is 'Numero de Registro';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.IdPoliza
  is 'Consecutivo de Póliza';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.CodUsuario
  is 'Usuario que Procesa el Archivo';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.NumPolunico
  is 'Numero de Poliza Unico';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.IDetPol
  is 'No. Detalle de Póliza';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.Tipo_Doc_Identificacion
  is 'Tipo de documento de Identicacion';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.Num_Doc_Identificacion
  is 'No. de Documento de Identificacion';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.Nombre
  is 'Nombre del Asegurado';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.Apellido_Paterno
  is 'Apellido Paterno del Asegurado';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.Apellido_Materno
  is 'Apellido Materno del Asegurado';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.Sexo
  is 'Tipo de Sexo del Asegurado';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.FecNacimiento
  is 'Fecha de Nacimiento del Asegurado';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.Direcres
  is 'Direccion del Asegurado';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.CodPosres
  is 'Codigo Postal del Asegurado';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.FecInvig
  is 'Fecha de Incio de vigencia';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.FecFinVig
  is 'Fecha de fin de Vigencia';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.SumaAseg
  is 'Suma Asegurada del Asegurado';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.Sueldo
  is 'Sueldo del Asegurado';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.Nutra
  is 'Nutra';
/
-- =============================
-- Genera Primary key
-- =============================
ALTER TABLE SICAS_OC.ASEG_AJUSTEANUAL
  ADD CONSTRAINT ASEG_AJUSTEANUAL_PK PRIMARY KEY (CODEMPRESA, IDPOLIZA, CODUSUARIO, IDREGISTRO)
  USING INDEX  
  TABLESPACE IDX_SICASOC
  PCTFREE  10
  INITRANS 2
  MAXTRANS 255
  STORAGE 
  (
    INITIAL 64K
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  );
  
/

-- =============================
-- Crea el Sinónimo
-- =============================
CREATE OR REPLACE PUBLIC SYNONYM ASEG_AJUSTEANUAL FOR SICAS_OC.ASEG_AJUSTEANUAL;

/
-- =============================
-- Genera los permisos
-- ============================= 
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER, INDEX ON SICAS_OC.ASEG_AJUSTEANUAL TO ROL_MODIFICA_SICAS;
GRANT SELECT ON SICAS_OC.ASEG_AJUSTEANUAL TO ROL_CONSULTA_SICAS;

/
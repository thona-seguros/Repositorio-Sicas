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
  Apellido_Materno         VARCHAR2(50),
  Sexo                     VARCHAR2(1)   NOT NULL,
  FecNacimiento            DATE          NOT NULL,
  Direcres                 VARCHAR2(250),
  CodPosres                VARCHAR2(30),
  FecInvig                 DATE          NOT NULL,
  FecFinVig                DATE          NOT NULL,
  SumaAseg                 NUMBER(14)    NOT NULL,
  Sueldo                   NUMBER(18,2),
  Nutra                    VARCHAR2(500),
  CodCobert1               VARCHAR2(6),
  SumaAseg_1               NUMBER(18,2),
  CodCobert2               VARCHAR2(6),
  SumaAseg_2               NUMBER(18,2),
  CodCobert3               VARCHAR2(6),
  SumaAseg_3               NUMBER(18,2),
  CodCobert4               VARCHAR2(6),
  SumaAseg_4               NUMBER(18,2),
  CodCobert5               VARCHAR2(6),
  SumaAseg_5               NUMBER(18,2),
  CodCobert6               VARCHAR2(6),
  SumaAseg_6               NUMBER(18,2),
  CodCobert7               VARCHAR2(6),
  SumaAseg_7               NUMBER(18,2),
  CodCobert8               VARCHAR2(6),
  SumaAseg_8               NUMBER(18,2),
  Cod_Asegurado            NUMBER(14,0)
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
comment on column SICAS_OC.ASEG_AJUSTEANUAL.CodCobert1
  is 'primera cobertura';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.SumaAseg_1
  is 'Suma Asegurada del Asegurado de la cobertura1';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.CodCobert2
  is 'Segunda cobertura';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.SumaAseg_2
  is 'Suma Asegurada del Asegurado de la cobertura2';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.CodCobert3
  is 'Tercera cobertura';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.SumaAseg_3
  is 'Suma Asegurada del Asegurado de la cobertura3';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.CodCobert4
  is 'Cuarta cobertura';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.SumaAseg_4
  is 'Suma Asegurada del Asegurado de la cobertura4';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.CodCobert5
  is 'Quinta cobertura';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.SumaAseg_5
  is 'Suma Asegurada del Asegurado de la cobertura5';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.CodCobert6
  is 'Sexta cobertura';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.SumaAseg_6
  is 'Suma Asegurada del Asegurado de la cobertura6';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.CodCobert7
  is 'Septima cobertura';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.SumaAseg_7
  is 'Suma Asegurada del Asegurado de la cobertura7';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.CodCobert8
  is 'Octava cobertura';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.SumaAseg_8
  is 'Suma Asegurada del Asegurado de la cobertura8';
comment on column SICAS_OC.ASEG_AJUSTEANUAL.Cod_Asegurado
  is 'Codigo de Asegurado a Modificar';
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
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON SICAS_OC.ASEG_AJUSTEANUAL TO ROL_MODIFICA_SICAS;
GRANT SELECT ON SICAS_OC.ASEG_AJUSTEANUAL TO ROL_CONSULTA_SICAS;

/
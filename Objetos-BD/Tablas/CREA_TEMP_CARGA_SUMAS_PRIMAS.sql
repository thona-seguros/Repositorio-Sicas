-- =============================
-- Crea Tabla
-- =============================

DROP PUBLIC SYNONYM TEMP_CARGA_SUMAS_PRIMAS
;
DROP TABLE TEMP_CARGA_SUMAS_PRIMAS
;
create table SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS
(
  CODCIA                   NUMBER(14) not null,
  CODEMPRESA               NUMBER(14) not null,
  IDPOLIZA                 NUMBER(14) not null,
  IDETPOL                  NUMBER(14) not null,
  COD_ASEGURADO            NUMBER(14) not null,
  IDTIPOSEG                VARCHAR2(6) not null,
  PLANCOB                  VARCHAR2(15),
  NUMPOLUNICO              VARCHAR2(30),
  TIPO_DOC_IDENTIFICACION  VARCHAR2(6),
  NUM_DOC_IDENTIFICACION   VARCHAR2(20),
  NOMBRE                   VARCHAR2(200),
  APELLIDO_PATERNO         VARCHAR2(50),
  APELLIDO_MATERNO         VARCHAR2(50),
  SEXO                     VARCHAR2(1),
  FECNACIMIENTO            DATE,
  TIPO_DOC_IDENTIFICACION2 VARCHAR2(6),
  IDENDOSO                 NUMBER(14) default 0,
  FECHA1                   DATE,
  FECHA2                   DATE,
  FECHA3                   DATE,
  FECHA4                   DATE,
  FECHA5                   DATE,
  FECHA6                   DATE,
  FECANULEXCLU             DATE,
  IDENDOSOEXCLU            NUMBER(14) default 0,
  MOTIVANULEXCLU           VARCHAR2(6),
  CAMPO1                   VARCHAR2(500),
  CAMPO2                   VARCHAR2(500),
  CAMPO3                   VARCHAR2(500),
  CAMPO4                   VARCHAR2(500),
  CAMPO5                   VARCHAR2(500),
  CAMPO6                   VARCHAR2(500),
  CAMPO7                   VARCHAR2(500),
  CAMPO8                   VARCHAR2(500),
  CAMPO9                   VARCHAR2(500),
  CAMPO10                  VARCHAR2(500),
  CAMPO11                  VARCHAR2(500),
  CAMPO12                  VARCHAR2(500),
  CAMPO13                  VARCHAR2(500),
  CAMPO14                  VARCHAR2(500),
  CAMPO15                  VARCHAR2(500),
  CAMPO16                  VARCHAR2(500),
  CAMPO17                  VARCHAR2(500),
  CAMPO18                  VARCHAR2(500),
  CAMPO19                  VARCHAR2(500),
  CAMPO20                  VARCHAR2(500)
)
tablespace TS_SICASOC
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
  
-- =============================
-- Genera Indice
-- =============================
-- Create/Recreate primary, unique and foreign key constraints 
alter table SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS
  add constraint PK_TEMP_CARGA_SUMAS_PRIMAS primary key (CODCIA, CODEMPRESA, IDPOLIZA, IDETPOL, COD_ASEGURADO)
  using index 
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate indexes 
create index SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS_IDX_1 on SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS (COD_ASEGURADO)
  tablespace TS_SICASOC
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS_IDX_2 on SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS (IDPOLIZA)
  tablespace TS_SICASOC
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  )
  compress;
create index SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS_IDX_3 on SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS (IDPOLIZA, IDETPOL)
  tablespace TS_SICASOC
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  )
  compress;
create index SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS_IDX_4 on SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS (TIPO_DOC_IDENTIFICACION, NUM_DOC_IDENTIFICACION)
  tablespace TS_SICASOC
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  )
  compress;

-- =============================
-- Genera los permisos
-- =============================  
-- Grant/Revoke object privileges 
grant select, insert, update, delete on SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS to PUBLIC;

-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM TEMP_CARGA_SUMAS_PRIMAS FOR TEMP_CARGA_SUMAS_PRIMAS
;  

-- =============================
-- Crea Comentarios
-- =============================  
-- Add comments to the columns 
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO1
  is 'Datos generales para el Campo1';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO2
  is 'Datos generales para el Campo2';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO3
  is 'Datos generales para el Campo3';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO4
  is 'Datos generales para el Campo4';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO5
  is 'Datos generales para el Campo5';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO6
  is 'Datos generales para el Campo6';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO7
  is 'Datos generales para el Campo7';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO8
  is 'Datos generales para el Campo8';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO9
  is 'Datos generales para el Campo9';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO10
  is 'Datos generales para el Campo10';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO11
  is 'Datos generales para el Campo11';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO12
  is 'Datos generales para el Campo12';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO13
  is 'Datos generales para el Campo13';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO14
  is 'Datos generales para el Campo14';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO15
  is 'Datos generales para el Campo15';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO16
  is 'Datos generales para el Campo16';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO17
  is 'Datos generales para el Campo17';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO18
  is 'Datos generales para el Campo18';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO19
  is 'Datos generales para el Campo19';
comment on column SICAS_OC.TEMP_CARGA_SUMAS_PRIMAS.CAMPO20
  is 'Datos generales para el Campo20';


-- Create table
create table TEMP_INDICADORES
(
  IDCARGA                    NUMBER(10) not null,
  IDCONSECUTIVO              NUMBER(10) not null,
  ANIO                       NUMBER(4) not null,
  MES                        NUMBER(2) not null,
  CONSECUTIVO                NUMBER(14),
  NUMPOLUNICO                VARCHAR2(30),
  STSPOLIZA                  VARCHAR2(3),
  FECINIVIG                  DATE,
  FECFINVIG                  DATE,
  FECEMISION                 DATE,
  CONTRATANTE                VARCHAR2(500),
  PRIMANETA_LOCAL            NUMBER(18,2),
  SUMAASEG_LOCAL             NUMBER(18,2),
  RAMO                       VARCHAR2(100),
  IDTIPOSEG                  VARCHAR2(6),
  NUM_COTIZACION             NUMBER(14),
  NUMFOLIOPORTAL             VARCHAR2(30),
  NUMPOLREF                  VARCHAR2(30),
  TIPO_VIGENCIA              VARCHAR2(15),
  NUMERO_RENOVACION          NUMBER(5),
  AGRUPADOR                  VARCHAR2(6),
  GRUPO_ECONOMICO            VARCHAR2(20),
  ESCONTRIBUTORIO_ACTUAL     VARCHAR2(2),
  ESCONTRIBUTORIO_NUEVO      VARCHAR2(2),
  PORCENCONTRIBUTORIO_ACTUAL NUMBER(12,6),
  PORCENCONTRIBUTORIO_NUEVO  NUMBER(12,6),
  GIRONEGOCIO_ACTUAL         VARCHAR2(4000),
  GIRONEGOCIO_NUEVO          VARCHAR2(4000),
  CODTIPONEGOCIO_ACTUAL      VARCHAR2(10),
  CODTIPONEGOCIO_NUEVO       VARCHAR2(10),
  TIPONEGOCIO_ACTUAL         VARCHAR2(30),
  TIPONEGOCIO_NUEVO          VARCHAR2(30),
  CODFUENTERECURSOS_ACTUAL   VARCHAR2(6),
  CODFUENTERECURSOS_NUEVO    VARCHAR2(6),
  FUENTERECURSOS_ACTUAL      VARCHAR2(30),
  FUENTERECURSOS_NUEVO       VARCHAR2(30),
  CODPAQCOMERCIAL_ACTUAL     VARCHAR2(200),
  CODPAQCOMERCIAL_NUEVO      VARCHAR2(250),
  CODCATEGO_ACTUAL           VARCHAR2(14),
  CODCATEGO_NUEVO            VARCHAR2(14),
  CATEGORIA_ACTUAL           VARCHAR2(200),
  CATEGORIA_NUEVO            VARCHAR2(200),
  CODCANALFORMAVENTA_ACTUAL  VARCHAR2(50),
  CODCANALFORMAVENTA_NUEVO   VARCHAR2(50),
  CANALFORMAVENTA_ACTUAL     VARCHAR2(50),
  CANALFORMAVENTA_NUEVO      VARCHAR2(50),
  AGENTE                     NUMBER(18),
  PROMOTOR                   NUMBER(18),
  REGIONAL                   NUMBER(18),
  TIPO_VIGENCIA_ACTUAL       VARCHAR2(15),
  TIPO_VIGENCIA_NUEVO        VARCHAR2(15),
  NUMAGRUPADOR_ACTUAL        VARCHAR2(10),
  NUMAGRUPADOR_NUEVO         VARCHAR2(10),
  AGRUPADOR_ACTUAL           VARCHAR2(200),
  AGRUPADOR_NUEVO            VARCHAR2(200),
  PREVIO                     VARCHAR2(50),
  IDRENTDIC                  VARCHAR2(50),
  AGRUPADORDIC               VARCHAR2(50),
  SUBRAMO                    VARCHAR2(50),
  NOM_AGENTE                 VARCHAR2(500),
  NOM_DR                     VARCHAR2(500),
  FECCARGA                   DATE default SYSDATE,
  STSCARGA                   VARCHAR2(20) default 'XPR',
  CODUSUARIO                 VARCHAR2(8) default 'SICAS_OC',
  FECACTUALIZACION           DATE,
  CODUSUARIOACT              VARCHAR2(8)
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
-- Create/Recreate primary, unique and foreign key constraints 
alter table TEMP_INDICADORES
  add primary key (IDCARGA, IDCONSECUTIVO)
  using index 
  tablespace IDX_SICASOC
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
create index TEMP_INDICADORES_01 on TEMP_INDICADORES (CONSECUTIVO)
  tablespace IDX_SICASOC
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
create index TEMP_INDICADORES_02 on TEMP_INDICADORES (ANIO, MES)
  tablespace IDX_SICASOC
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
-- Grant/Revoke object privileges 
grant select, insert, update, delete on TEMP_INDICADORES to PUBLIC;

-- =============================
-- Crea Tabla
-- =============================

DROP PUBLIC SYNONYM CTROL_CGA_RESERVA
;
DROP TABLE CTROL_CGA_RESERVA
;

create table CTROL_CGA_RESERVA
(
  IDCARGA        NUMBER(8) not null,
  IDVERSION      NUMBER(8) not null,
  PERIODICIDAD   VARCHAR2(22) not null,
  FECINICIAL     DATE not null,
  FECFINAL       DATE not null,
  ID_SINIESTRO   NUMBER(14),
  IMPTE_RVA_INI  NUMBER(18,2),
  TOT_REGS_RI    NUMBER(8),
  IMPTE_AJUMAS   NUMBER(18,2),
  TOT_REGS_AA    NUMBER(8),
  IMPTE_AJUMENOS NUMBER(18,2),
  TOT_REG_AD     NUMBER(8),
  IMPTE_PAGOS    NUMBER(18,2),
  TOT_REGS_PA    NUMBER(8),
  IMPTE_DESPAGOS NUMBER(18,2),
  TOT_REGS_DESP  NUMBER(8),
  TI_PROCESO     VARCHAR2(30),
  TF_PROCESO     VARCHAR2(30),
  FECCARGA       DATE DEFAULT SYSDATE,
  CODUSUARIO     VARCHAR2(30)
);

-- =============================
-- Genera Indice
-- =============================

create index CTROL_CGA_RESERVA_IDX_1 on CTROL_CGA_RESERVA (IDCARGA, IDVERSION, PERIODICIDAD)
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
create index CTROL_CGA_RESERVA_IDX_2 on CTROL_CGA_RESERVA (IDCARGA, IDVERSION, PERIODICIDAD, FECINICIAL, FECFINAL)
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

-- Create/Recreate primary, unique and foreign key constraints 
alter table SICAS_OC.CTROL_CGA_RESERVA
  add constraint PK_CTROL_CGA_RESERVA primary key (IDCARGA, IDVERSION);


-- =============================
-- Genera los permisos
-- =============================
grant select, insert, update, delete, alter, index on CTROL_CGA_RESERVA to PUBLIC;

-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM CTROL_CGA_RESERVA FOR CTROL_CGA_RESERVA
;

-- =============================
-- Crea Comentarios
-- =============================
-- Add comments to the columns 
comment on column SICAS_OC.CTROL_CGA_RESERVA.IDCARGA
  is 'Identificador de la carga.';
comment on column SICAS_OC.CTROL_CGA_RESERVA.IDVERSION
  is 'Consecutivo de la carga.';
comment on column SICAS_OC.CTROL_CGA_RESERVA.PERIODICIDAD
  is 'Periodicidad de la Carga.';
comment on column SICAS_OC.CTROL_CGA_RESERVA.FECINICIAL
  is 'Fecha Inicio del Periodo.';
comment on column SICAS_OC.CTROL_CGA_RESERVA.FECFINAL
  is 'Fecha Fin del Periodo.';
comment on column SICAS_OC.CTROL_CGA_RESERVA.ID_SINIESTRO
  is 'Número de Siniestro Procesado.';
comment on column SICAS_OC.CTROL_CGA_RESERVA.IMPTE_RVA_INI
  is 'Importe Total de Reserva Inicial.';
comment on column SICAS_OC.CTROL_CGA_RESERVA.TOT_REGS_RI
  is 'Total de Registros Cargados de Reserva Incial.';
comment on column SICAS_OC.CTROL_CGA_RESERVA.IMPTE_AJUMAS
  is 'Importe Total de Ajustes de Aumento.';
comment on column SICAS_OC.CTROL_CGA_RESERVA.TOT_REGS_AA
  is 'Total de Registros Cargados de Ajustes de Aumento.';
comment on column SICAS_OC.CTROL_CGA_RESERVA.IMPTE_AJUMENOS
  is 'Importe Total de Ajustes de Disminución.';
comment on column SICAS_OC.CTROL_CGA_RESERVA.TOT_REG_AD
  is 'Total de Registros Cargados de Ajustes de Disminución.';
comment on column SICAS_OC.CTROL_CGA_RESERVA.IMPTE_PAGOS
  is 'Importe Total de Pagos.';
comment on column SICAS_OC.CTROL_CGA_RESERVA.TOT_REGS_PA
  is 'Total de Registros Cargados de Pagos.';
comment on column SICAS_OC.CTROL_CGA_RESERVA.IMPTE_DESPAGOS
  is 'Importe Total de Despagos.';
comment on column SICAS_OC.CTROL_CGA_RESERVA.TOT_REGS_DESP
  is 'Total de Registros Cargados de Despagos.';
comment on column SICAS_OC.CTROL_CGA_RESERVA.TI_PROCESO
  is 'Tiempo Inicial del proceso de carga';
comment on column SICAS_OC.CTROL_CGA_RESERVA.TF_PROCESO
  is 'Tiempo Final del proceso de carga';
comment on column SICAS_OC.CTROL_CGA_RESERVA.FECCARGA
  is 'Fecha de Carga';
comment on column SICAS_OC.CTROL_CGA_RESERVA.CODUSUARIO
  is 'Usuario que ejecutó el proceso';


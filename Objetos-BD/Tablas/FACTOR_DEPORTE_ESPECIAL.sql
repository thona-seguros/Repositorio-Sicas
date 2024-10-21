-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM FACTOR_DEPORTE_ESPECIAL;
DROP TABLE SICAS_OC.FACTOR_DEPORTE_ESPECIAL;

CREATE TABLE SICAS_OC.FACTOR_DEPORTE_ESPECIAL
(
  CODCIA            NUMBER(14) not null,
  CODEMPRESA        NUMBER(14) not null,
  IDTIPOSEG         VARCHAR2(6) not null,
  PLANCOB           VARCHAR2(15) not null,
  CODCOBERT         VARCHAR2(7) not null,
  DEPORTE           VARCHAR2(20) not null,
  RIESGO            VARCHAR2(1) not null,
  FACTOR            NUMBER(9,6) not null,
  ACTUALIZO_USUARIO VARCHAR2(30 CHAR) default USER,
  ACTUALIZO_FECHA   DATE default sysdate
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
comment on table SICAS_OC.FACTOR_DEPORTE_ESPECIAL
  is 'Factor para los Deportes Especiales';
-- Add comments to the columns 
comment on column SICAS_OC.FACTOR_DEPORTE_ESPECIAL.CODCIA
  is 'Código del Compañía';
comment on column SICAS_OC.FACTOR_DEPORTE_ESPECIAL.CODEMPRESA
  is 'Código de la Empresa';
comment on column SICAS_OC.FACTOR_DEPORTE_ESPECIAL.IDTIPOSEG
  is 'Identificador del Tipo de Seguro';
comment on column SICAS_OC.FACTOR_DEPORTE_ESPECIAL.PLANCOB
  is 'Identificador del Plan de Coberturas';
comment on column SICAS_OC.FACTOR_DEPORTE_ESPECIAL.CODCOBERT
  is 'Código de Cobertura';
comment on column SICAS_OC.FACTOR_DEPORTE_ESPECIAL.DEPORTE
  is 'Descripcion del Deporte';
comment on column SICAS_OC.FACTOR_DEPORTE_ESPECIAL.RIESGO
  is 'Indicador de Riesgo';
comment on column SICAS_OC.FACTOR_DEPORTE_ESPECIAL.FACTOR
  is 'Factor';
comment on column SICAS_OC.FACTOR_DEPORTE_ESPECIAL.ACTUALIZO_USUARIO
  is 'Usuario que incrementa o altera el registro';
comment on column SICAS_OC.FACTOR_DEPORTE_ESPECIAL.ACTUALIZO_FECHA
  is 'Fecha en que se incrementa o se alteró el registro';
/
-- =============================
-- Genera Primary key
-- =============================
ALTER TABLE SICAS_OC.FACTOR_DEPORTE_ESPECIAL
  ADD CONSTRAINT FACTOR_DEPORTE_ESPECIAL_PK PRIMARY KEY (CODCIA, CODEMPRESA, IDTIPOSEG, PLANCOB, CODCOBERT, DEPORTE)
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
-- Genera los permisos
-- ============================= 
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER, INDEX ON SICAS_OC.FACTOR_DEPORTE_ESPECIAL TO ROL_MODIFICA_SICAS;
GRANT SELECT ON SICAS_OC.FACTOR_DEPORTE_ESPECIAL TO ROL_CONSULTA_SICAS;
/
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE OR REPLACE PUBLIC SYNONYM FACTOR_DEPORTE_ESPECIAL FOR SICAS_OC.FACTOR_DEPORTE_ESPECIAL;

/
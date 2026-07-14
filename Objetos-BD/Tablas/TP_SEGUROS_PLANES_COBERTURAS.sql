-- Create table
DROP PUBLIC SYNONYM TP_SEGUROS_PLANES_COBERTURAS;
DROP table SICAS_OC.TP_SEGUROS_PLANES_COBERTURAS;
/
CREATE TABLE SICAS_OC.TP_SEGUROS_PLANES_COBERTURAS (
    IDTIPOSEG              VARCHAR2(6),
    PLANCOB                VARCHAR2(15),
    CODCOBERT              VARCHAR2(8),
    PRIORIDAD              NUMBER(2),
    FECHA_CARGA            DATE DEFAULT SYSDATE,
	USUARIO                VARCHAR2(30 CHAR) default USER
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
comment on table SICAS_OC.TP_SEGUROS_PLANES_COBERTURAS
  is 'Configuracion de los tipos de seguros y planes para las coberturas';
-- Add comments to the columns 
comment on column SICAS_OC.TP_SEGUROS_PLANES_COBERTURAS.IDTIPOSEG
  is 'Id de Tipo de Seguro';
comment on column SICAS_OC.TP_SEGUROS_PLANES_COBERTURAS.PLANCOB
  is 'Plan de Cobertura';
comment on column SICAS_OC.TP_SEGUROS_PLANES_COBERTURAS.CODCOBERT
  is 'Codigo de Cobertura';
comment on column SICAS_OC.TP_SEGUROS_PLANES_COBERTURAS.PRIORIDAD
  is 'Prioridad a la cobertura.';
comment on column SICAS_OC.TP_SEGUROS_PLANES_COBERTURAS.FECHA_CARGA
  is 'Fecha en se realizo la carga';
comment on column SICAS_OC.TP_SEGUROS_PLANES_COBERTURAS.USUARIO
  is 'Usuario que incrementa o altera el registro';

/
-- =============================
-- Genera Primary key
-- =============================
ALTER TABLE SICAS_OC.TP_SEGUROS_PLANES_COBERTURAS
  ADD CONSTRAINT TP_SEGUROS_PLANES_COBERTURAS_PK PRIMARY KEY (IDTIPOSEG, PLANCOB, CODCOBERT)
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

 ---GRANT SELECT ON "SICAS_OC"."TP_SEGUROS_PLANES_COBERTURAS" TO PUBLIC;
 -- =============================
-- Genera los permisos
-- ============================= 
grant select, insert, update, delete on SICAS_OC.TP_SEGUROS_PLANES_COBERTURAS to PUBLIC;
 /
  -- =============================
-- Crea el Sinónimo
-- =============================
CREATE OR REPLACE PUBLIC SYNONYM TP_SEGUROS_PLANES_COBERTURAS FOR SICAS_OC.TP_SEGUROS_PLANES_COBERTURAS;
/
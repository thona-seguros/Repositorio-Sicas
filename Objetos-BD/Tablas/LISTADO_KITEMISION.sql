-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM LISTADO_KITEMISION;
DROP TABLE SICAS_OC.LISTADO_KITEMISION;

CREATE TABLE SICAS_OC.LISTADO_KITEMISION
(
  IDPOLIZA          NUMBER(14) not null,
  REPORTE           VARCHAR2(20),
  DESCRIPCION       VARCHAR2(100),
  CODVALOR          VARCHAR2(6),
  DESCVALLST        VARCHAR2(200),
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
comment on table SICAS_OC.LISTADO_KITEMISION
  is 'Configuracion de los reportes de Kit de emision o Poliza';
-- Add comments to the columns 
comment on column SICAS_OC.LISTADO_KITEMISION.IDPOLIZA
  is 'Código de la Poliza';
comment on column SICAS_OC.LISTADO_KITEMISION.REPORTE
  is 'Nombre del Reporte';
comment on column SICAS_OC.LISTADO_KITEMISION.DESCRIPCION
  is 'Descripcion del Reporte, generalidades.';
comment on column SICAS_OC.LISTADO_KITEMISION.CODVALOR
  is 'Codigo del Paquete de Papeleria';
comment on column SICAS_OC.LISTADO_KITEMISION.DESCVALLST
  is 'Descripcion del Paquete de Papeleria';
comment on column SICAS_OC.LISTADO_KITEMISION.ACTUALIZO_USUARIO
  is 'Usuario que incrementa o altera el registro';
comment on column SICAS_OC.LISTADO_KITEMISION.ACTUALIZO_FECHA
  is 'Fecha en que se incrementa o se alteró el registro';
/
-- =============================
-- Genera Primary key
-- =============================
ALTER TABLE SICAS_OC.LISTADO_KITEMISION
  ADD CONSTRAINT LISTADO_KITEMISION_PK PRIMARY KEY (IDPOLIZA, REPORTE)
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
grant select, insert, update, delete on SICAS_OC.LISTADO_KITEMISION to PUBLIC;
/
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE OR REPLACE PUBLIC SYNONYM LISTADO_KITEMISION FOR SICAS_OC.LISTADO_KITEMISION;

/
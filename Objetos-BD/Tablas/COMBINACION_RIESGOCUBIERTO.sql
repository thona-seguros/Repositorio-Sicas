-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM COMBINACION_RIESGOCUBIERTO;
DROP TABLE SICAS_OC.COMBINACION_RIESGOCUBIERTO;

CREATE TABLE SICAS_OC.COMBINACION_RIESGOCUBIERTO
(
  CODCIA               NUMBER(14) not null,
  CODEMPRESA           NUMBER(14) not null,
  TIPO_NEGOCIO         VARCHAR2(10),
  LABORAL_RIESG        VARCHAR2(1),
  DIA24365_RIESG       VARCHAR2(1),
  TRASLADO_RIESG       VARCHAR2(1),
  TEXTOELEGIBILIDAD    VARCHAR2(4000),
  TEXTORIESGOCUBIERTO  VARCHAR2(4000)
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
comment on table SICAS_OC.COMBINACION_RIESGOCUBIERTO
  is 'Combinacion de textos para Riesgos a Cubrir';
-- Add comments to the columns 
comment on column SICAS_OC.COMBINACION_RIESGOCUBIERTO.CODCIA
  is 'Código de Compañía'; 
comment on column SICAS_OC.COMBINACION_RIESGOCUBIERTO.CODEMPRESA
  is 'Código de Empresa';
comment on column SICAS_OC.COMBINACION_RIESGOCUBIERTO.TIPO_NEGOCIO
  is 'Tipo de Negocio Web';
comment on column SICAS_OC.COMBINACION_RIESGOCUBIERTO.LABORAL_RIESG
  is 'Tipo de Riesgo a cubrir Laboral';
comment on column SICAS_OC.COMBINACION_RIESGOCUBIERTO.DIA24365_RIESG
  is 'Tipo de Riesgo a cubrir 24/365';
comment on column SICAS_OC.COMBINACION_RIESGOCUBIERTO.TRASLADO_RIESG
  is 'Tipo de Riesgo a cubrir Traslado';
comment on column SICAS_OC.COMBINACION_RIESGOCUBIERTO.TEXTOELEGIBILIDAD
  is 'Descripcion del tipo de Texto de Elegibilidad';
comment on column SICAS_OC.COMBINACION_RIESGOCUBIERTO.TEXTORIESGOCUBIERTO
  is 'Descripcion del tipo de riesgo a cubrir';
/
-- =============================
-- Genera Primary key
-- =============================
ALTER TABLE SICAS_OC.COMBINACION_RIESGOCUBIERTO
  ADD CONSTRAINT COMBINACION_RIESGOCUBIERTO_PK PRIMARY KEY (CODCIA, CODEMPRESA,TEXTORIESGOCUBIERTO)
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
----grant select, insert, update, delete on SICAS_OC.COMBINACION_RIESGOCUBIERTO to PUBLIC;

GRANT SELECT, INSERT, UPDATE, DELETE, ALTER, INDEX ON SICAS_OC.COMBINACION_RIESGOCUBIERTO TO ROL_MODIFICA_SICAS;
GRANT SELECT ON SICAS_OC.COMBINACION_RIESGOCUBIERTO TO ROL_CONSULTA_SICAS;

/
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE OR REPLACE PUBLIC SYNONYM COMBINACION_RIESGOCUBIERTO FOR SICAS_OC.COMBINACION_RIESGOCUBIERTO;

/
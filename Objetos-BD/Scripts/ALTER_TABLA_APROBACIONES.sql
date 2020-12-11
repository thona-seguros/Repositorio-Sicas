-- =============================
-- Modifica tabla
-- =============================
--  
ALTER TABLE APROBACIONES
ADD
(
CODCIA	NUMBER(14)	,
CODEMPRESA	NUMBER(14)	,
COD_MONEDA	VARCHAR2(5)	,
CODCOBERT	VARCHAR2(6)	,
COD_ASEGURADO	NUMBER(14)	,
CODUSUARIO_ALTA	VARCHAR2(30)	,
FECREGISTRO	DATE
)
;

comment on column APROBACIONES.CODCIA is 'Codigo de la compañia de seguros';
comment on column APROBACIONES.CODEMPRESA is 'Codigo de la empresa de seguros';
comment on column APROBACIONES.COD_MONEDA is 'Codigo Moneda';
comment on column APROBACIONES.CODCOBERT is 'Codigo de Cobertura';
comment on column APROBACIONES.COD_ASEGURADO is 'Codigo de asegurado';
comment on column APROBACIONES.CODUSUARIO_ALTA is 'Usuario de alta';
comment on column APROBACIONES.FECREGISTRO is 'Fecha de alta';

-- =============================
-- Borra Primaty key
-- =============================
--ALTER TABLE APROBACIONES drop constraint SYS_C0032084 cascade; --PRUEBAS
--ALTER TABLE APROBACIONES drop constraint SYS_C0020846 cascade; --ALTERNO
ALTER TABLE APROBACIONES drop constraint SYS_C0021286 cascade; --PRODUCCION
 

  
-- =============================
-- Borra Indice
-- =============================
DROP INDEX APROBACIONES_IDX_1;
DROP INDEX IN_DX1_APROBACIONES;


-- =============================
-- Genera Indice
-- =============================
create  index APROBACIONES_IDX_1 on APROBACIONES(IDSINIESTRO, NUM_APROBACION, CODCIA)
  tablespace TS_SICASOC
;
create  index APROBACIONES_IDX_2 on APROBACIONES(IDPOLIZA, IDSINIESTRO, NUM_APROBACION, CODCIA)
  tablespace TS_SICASOC
;
create  index APROBACIONES_IDX_3 on APROBACIONES(IDSINIESTRO, COD_TPRESERVA, CODCOBERT, CODCIA)
  tablespace TS_SICASOC
;

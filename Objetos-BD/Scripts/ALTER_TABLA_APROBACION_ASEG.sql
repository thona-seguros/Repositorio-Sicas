-- =============================
-- Modifica tabla
-- =============================
--  
ALTER TABLE APROBACION_ASEG
ADD
(
CODCIA	NUMBER(14)	,
CODEMPRESA	NUMBER(14)	,
COD_MONEDA	VARCHAR2(5)	,
CODCOBERT	VARCHAR2(6)	,
CODUSUARIO_ALTA	VARCHAR2(30)	,
FECREGISTRO	DATE
)
;

comment on column APROBACION_ASEG.CODCIA is 'Codigo de la compañia de seguros';
comment on column APROBACION_ASEG.CODEMPRESA is 'Codigo de la empresa de seguros';
comment on column APROBACION_ASEG.COD_MONEDA is 'Codigo Moneda';
comment on column APROBACION_ASEG.CODCOBERT is 'Codigo de cobertura';
comment on column APROBACION_ASEG.CODUSUARIO_ALTA is 'Usuario de alta';
comment on column APROBACION_ASEG.FECREGISTRO is 'Fecha de alta';


-- =============================
-- Borra Primaty key
-- =============================
--ALTER TABLE APROBACION_ASEG drop constraint SYS_C0017446 cascade; --DESARROLLO
--ALTER TABLE APROBACION_ASEG drop constraint SYS_C0031953 cascade; --PRUEBAS
--ALTER TABLE APROBACION_ASEG drop constraint SYS_C0020847 cascade; --ALTERNO
ALTER TABLE APROBACION_ASEG drop constraint SYS_C0021287 cascade; --PRODUCCION
 
 
-- =============================
-- Borra Indice
-- =============================

DROP INDEX APROBACION_ASEG_IDX_1;

-- =============================
-- Genera Indice
-- =============================
create  index APROBACION_ASEG_IDX_1 on APROBACION_ASEG(IDSINIESTRO, NUM_APROBACION, CODCIA)
  tablespace TS_SICASOC
;
create  index APROBACION_ASEG_IDX_2 on APROBACION_ASEG(IDPOLIZA, IDSINIESTRO, NUM_APROBACION, CODCIA)
  tablespace TS_SICASOC
;
create  index APROBACION_ASEG_IDX_3 on APROBACION_ASEG(IDSINIESTRO, COD_TPRESERVA, CODCOBERT, CODCIA)
  tablespace TS_SICASOC
;


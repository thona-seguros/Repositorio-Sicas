-- =============================
-- Modifica tabla
-- =============================
--  
ALTER TABLE COBERTURA_SINIESTRO
ADD
(
CODCIA	NUMBER(14)	,
CODEMPRESA	NUMBER(14)	,
COD_MONEDA	VARCHAR2(5)	,
COD_ASEGURADO	NUMBER(14)	,
COD_TPRESERVA	VARCHAR2(6)	,
IDTPRESERVA	NUMBER(5)	,
CODUSUARIO	VARCHAR2(30)	,
FECREGISTRO	DATE
)
;
comment on column COBERTURA_SINIESTRO.CODCIA is 'Codigo de la compania de seguros';
comment on column COBERTURA_SINIESTRO.CODEMPRESA is 'Codigo de la empresa de seguros';
comment on column COBERTURA_SINIESTRO.COD_MONEDA is 'Codigo Moneda';
comment on column COBERTURA_SINIESTRO.COD_ASEGURADO is 'Codigo de asegurado';
comment on column COBERTURA_SINIESTRO.COD_TPRESERVA is 'Codigo de tipo de reserva';
comment on column COBERTURA_SINIESTRO.IDTPRESERVA is 'Secuencia del tipo de reserva';
comment on column COBERTURA_SINIESTRO.CODUSUARIO is 'Usuario de alta';
comment on column COBERTURA_SINIESTRO.FECREGISTRO is 'Fecha de alta';

-- =============================
-- Borra Primaty key
-- =============================
--ALTER TABLE COBERTURA_SINIESTRO drop constraint SYS_C0017440 cascade; --DESARROLLO
--ALTER TABLE COBERTURA_SINIESTRO drop constraint SYS_C0032088 cascade; --PRUEBAS
--ALTER TABLE COBERTURA_SINIESTRO drop constraint SYS_C0020842 cascade; --ALTERNO
ALTER TABLE COBERTURA_SINIESTRO drop constraint SYS_C0021282 cascade; --PRODUCCION
 
 
-- =============================
-- Borra Indice
-- =============================

DROP INDEX COBERTURA_SINIESTRO_IDX_1;

-- =============================
-- Genera Indice
-- =============================
create  index COBERTURA_SINIESTRO_IDX_1 on COBERTURA_SINIESTRO(IDSINIESTRO, COD_TPRESERVA, CODCOBERT, CODCIA)
  tablespace TS_SICASOC
;
create  index COBERTURA_SINIESTRO_IDX_4 on COBERTURA_SINIESTRO(IDPOLIZA, IDSINIESTRO, CODCOBERT, CODCIA)
  tablespace TS_SICASOC
;


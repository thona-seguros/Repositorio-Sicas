-- =============================
-- Modifica tabla
-- =============================
--  
ALTER TABLE COBERTURA_SINIESTRO_ASEG
ADD
(
CODCIA	NUMBER(14),
CODEMPRESA	NUMBER(14),
COD_MONEDA	VARCHAR2(5),
COD_TPRESERVA	VARCHAR2(6),
IDTPRESERVA	NUMBER(5),
CODUSUARIO	VARCHAR2(30),
FECREGISTRO	DATE
)
;

comment on column COBERTURA_SINIESTRO_ASEG.CODCIA is 'Codigo de la compania de seguros';
comment on column COBERTURA_SINIESTRO_ASEG.CODEMPRESA is 'Codigo de la empresa de seguros';
comment on column COBERTURA_SINIESTRO_ASEG.COD_MONEDA is 'Codigo Moneda';
comment on column COBERTURA_SINIESTRO_ASEG.COD_TPRESERVA is 'Codigo de tipo de reserva';
comment on column COBERTURA_SINIESTRO_ASEG.IDTPRESERVA is 'Secuencia del tipo de reserva';
comment on column COBERTURA_SINIESTRO_ASEG.CODUSUARIO is 'Usuario de alta';
comment on column COBERTURA_SINIESTRO_ASEG.FECREGISTRO is 'Fecha de alta';


-- =============================
-- Borra Primaty key
-- =============================
--ALTER TABLE COBERTURA_SINIESTRO_ASEG drop constraint SYS_C0017183 cascade;  --DESARROLLO
--ALTER TABLE COBERTURA_SINIESTRO_ASEG drop constraint SYS_C0032085 cascade;  --PRUEBAS
--ALTER TABLE COBERTURA_SINIESTRO_ASEG drop constraint SYS_C0020845 cascade;  --ALTERNO
ALTER TABLE COBERTURA_SINIESTRO_ASEG drop constraint SYS_C0021285 cascade;  --PRODUCCION
 
 
-- =============================
-- Borra Indice
-- =============================

DROP INDEX COB_SIN_ASEG_IDX_1;

-- =============================
-- Genera Indice
-- =============================
create  index COB_SIN_ASEG_IDX_1 on COBERTURA_SINIESTRO_ASEG(IDSINIESTRO, COD_TPRESERVA, CODCOBERT, CODCIA)
  tablespace TS_SICASOC
;
create  index COB_SIN_ASEG_IDX_4 on COBERTURA_SINIESTRO_ASEG(IDPOLIZA, IDSINIESTRO, CODCOBERT, CODCIA)
  tablespace TS_SICASOC
;


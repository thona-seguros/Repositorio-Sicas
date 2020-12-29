-- =============================
-- Modifica tabla
-- =============================
-- 
ALTER TABLE OBSERVACION_SINIESTRO
ADD 
(
CODCIA	NUMBER(14)	,
CODEMPRESA	NUMBER(14)
)
;
comment on column OBSERVACION_SINIESTRO.CODCIA is 'Codigo de la compania de seguros';
comment on column OBSERVACION_SINIESTRO.CODEMPRESA is 'Codigo de la empresa de seguros';


-- =============================
-- Borra Indice
-- =============================

DROP INDEX OBSERVACION_SINIESTRO_IDX_1;


-- =============================
-- Genera Indice
-- =============================
create  index OBSERVACION_SINIESTRO_IDX_1 on OBSERVACION_SINIESTRO(IDSINIESTRO,  CODCIA)
  tablespace TS_SICASOC
;


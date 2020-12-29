-- =============================
-- Modifica tabla 
-- =============================
--  
ALTER TABLE DETALLE_APROBACION_ASEG
ADD
(
CODCIA	NUMBER(14)	,
CODEMPRESA	NUMBER(14)	,
COD_MONEDA	VARCHAR2(5)	
)
;

comment on column DETALLE_APROBACION_ASEG.CODCIA is 'Codigo de la compania de seguros';
comment on column DETALLE_APROBACION_ASEG.CODEMPRESA is 'Codigo de la empresa de seguros';
comment on column DETALLE_APROBACION_ASEG.COD_MONEDA is 'Codigo Moneda';


-- =============================
-- Borra Primaty key
-- =============================
ALTER TABLE DETALLE_APROBACION_ASEG drop constraint PK_DETALLE_APROBACION_ASEG cascade;
 
 
-- =============================
-- Borra Indice
-- =============================

--


-- =============================
-- Genera Indice
-- =============================
create  index DETALLE_APROB_ASEG_IDX_1 on DETALLE_APROBACION_ASEG(IDSINIESTRO, NUM_APROBACION, IDDETAPROB, CODCIA)
  tablespace TS_SICASOC
;

-- =============================
-- Modifica tabla 
-- =============================
--  
ALTER TABLE DETALLE_APROBACION
ADD
(
CODCIA	NUMBER(14)	,
CODEMPRESA	NUMBER(14)	,
COD_MONEDA	VARCHAR2(5)	
)
;

comment on column DETALLE_APROBACION.CODCIA is 'Codigo de la compania de seguros';
comment on column DETALLE_APROBACION.CODEMPRESA is 'Codigo de la empresa de seguros';
comment on column DETALLE_APROBACION.COD_MONEDA is 'Codigo Moneda';


-- =============================
-- Borra Primaty key
-- =============================
ALTER TABLE DETALLE_APROBACION drop constraint PK_DETALLE_APROBACION cascade;
 
 
 
-- =============================
-- Borra Indice
-- =============================

--

-- =============================
-- Genera Indice
-- =============================
create  index DETALLE_APROBACION_IDX_1 on DETALLE_APROBACION(IDSINIESTRO, NUM_APROBACION, IDDETAPROB, CODCIA)
  tablespace TS_SICASOC
;




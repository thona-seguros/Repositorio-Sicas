-- =============================
-- Modifica tabla
-- =============================
-- 
ALTER TABLE DETALLE_SINIESTRO_ASEG
ADD
(
CODCIA	NUMBER(14)	,
CODEMPRESA	NUMBER(14)	,
COD_MONEDA	VARCHAR2(5)	
)
;
comment on column DETALLE_SINIESTRO_ASEG.CODCIA is 'Codigo de la compania de seguros';
comment on column DETALLE_SINIESTRO_ASEG.CODEMPRESA is 'Codigo de la empresa de seguros';
comment on column DETALLE_SINIESTRO_ASEG.COD_MONEDA is 'Codigo Moneda';




-- =============================
-- Borra Primaty key
-- =============================
--ALTER TABLE DETALLE_SINIESTRO_ASEG drop constraint SYS_C0021288 cascade;  --DESARROLLO
--ALTER TABLE DETALLE_SINIESTRO_ASEG drop constraint SYS_C0031952 cascade;  --PRUEBAS
--ALTER TABLE DETALLE_SINIESTRO_ASEG drop constraint SYS_C0020848 cascade;  --ALTERNO
ALTER TABLE DETALLE_SINIESTRO_ASEG drop constraint SYS_C0021288 cascade;  --PRODUCCION
 
 
-- =============================
-- Borra Indice
-- =============================

--


-- =============================
-- Genera Indice
-- =============================
create  index DETALLE_SIN_ASEG_INDX_1 on DETALLE_SINIESTRO_ASEG(IDSINIESTRO, COD_ASEGURADO,CODCIA)
  tablespace TS_SICASOC
;
create  index DETALLE_SIN_ASEG_INDX_2 on DETALLE_SINIESTRO_ASEG(IDPOLIZA, COD_ASEGURADO,CODCIA)
  tablespace TS_SICASOC
;

-- =============================
-- Modifica tabla
-- =============================
--  
ALTER TABLE DETALLE_SINIESTRO
ADD
(
CODCIA	NUMBER(14)	,
CODEMPRESA	NUMBER(14)	,
COD_MONEDA	VARCHAR2(5)	,
COD_ASEGURADO	NUMBER(14)
)
;
comment on column DETALLE_SINIESTRO.CODCIA is 'Codigo de la compania de seguros';
comment on column DETALLE_SINIESTRO.CODEMPRESA is 'Codigo de la empresa de seguros';
comment on column DETALLE_SINIESTRO.COD_MONEDA is 'Codigo Moneda';
comment on column DETALLE_SINIESTRO.COD_ASEGURADO is 'Codigo de asegurado';


-- =============================
-- Borra Primaty key
-- =============================

--ALTER TABLE DETALLE_SINIESTRO drop constraint SYS_C0017375 cascade;  --DESARROLLO
--ALTER TABLE DETALLE_SINIESTRO drop constraint SYS_C0031950 cascade;  --PRUEBAS
--ALTER TABLE DETALLE_SINIESTRO drop constraint SYS_C0020850 cascade;  --ALTERNO
ALTER TABLE DETALLE_SINIESTRO drop constraint SYS_C0021290 cascade;  --PRODUCCION
 
 
-- =============================
-- Borra Indice
-- =============================



-- =============================
-- Genera Indice
-- =============================
create  index DETALLE_SINIESTRO_INDX_1 on DETALLE_SINIESTRO(IDSINIESTRO, COD_ASEGURADO,CODCIA)
  tablespace TS_SICASOC
;
create  index DETALLE_SINIESTRO_INDX_2 on DETALLE_SINIESTRO(IDPOLIZA, CODCIA)
  tablespace TS_SICASOC
;


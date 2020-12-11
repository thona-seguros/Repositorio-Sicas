-- =============================
-- Modifica tabla 
-- =============================
--  
ALTER TABLE DATOS_PART_SINIESTROS
ADD
(
CODEMPRESA	NUMBER(14)
)
;

comment on column DATOS_PART_SINIESTROS.CODEMPRESA is 'Codigo de la empresa de seguros';

-- =============================
-- Borra Primaty key
-- =============================
ALTER TABLE DATOS_PART_SINIESTROS drop constraint PK_DATOS_PART_SINIESTROS cascade;
 
 
-- =============================
-- Borra Indice
-- =============================
DROP INDEX INDX_SIN_DATOS_PART_SINIESTROS;

-- =============================
-- Genera Indice
-- =============================
create  index DATOS_PART_SINIESTROS_IDX_1 on DATOS_PART_SINIESTROS(IDSINIESTRO,  CODCIA)
  tablespace TS_SICASOC
;


-- =============================
-- Modifica tabla
-- =============================

ALTER TABLE COBERTURA_SINIESTRO
ADD
(
TP_SERVICIO	VARCHAR2(6)
)
;
comment on column COBERTURA_SINIESTRO.TP_SERVICIO is 'Identificador de tipo de servicio';


ALTER TABLE COBERTURA_SINIESTRO_ASEG
ADD
(
TP_SERVICIO	VARCHAR2(6)
)
;
comment on column COBERTURA_SINIESTRO_ASEG.TP_SERVICIO is 'Identificador de tipo de servicio';


ALTER TABLE PLAN_COBERTURAS
ADD
(
SUMA_ASEG_MAX             NUMBER(18,2)
)
;
comment on column PLAN_COBERTURAS.SUMA_ASEG_MAX  IS 'Suma Asegurada Maxima';




-- =============================
-- Modifica tabla
-- =============================
-- 
ALTER TABLE CAMCAR_PORCEN
ADD
(
ID_AÑO	NUMBER(5)	,
TP_MOVTO	VARCHAR(6)	DEFAULT 'CAMCAR'
)
;
comment on column CAMCAR_PORCEN.ID_AÑO is 'Año polizá';
comment on column CAMCAR_PORCEN.TP_MOVTO is 'Tipo de movimientro';


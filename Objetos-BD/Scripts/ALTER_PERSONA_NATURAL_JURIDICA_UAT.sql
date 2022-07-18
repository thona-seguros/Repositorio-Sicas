-- =============================
-- Modifica tabla
-- =============================
--  
ALTER TABLE PERSONA_NATURAL_JURIDICA
ADD
FECMOVTOSICAS	DATE,
FECAPLICASAT	DATE
)
;

COMMENT on column PERSONA_NATURAL_JURIDICA.FECMOVTOSICAS is 'Fecha movimiento en SICAS';
comment on column PERSONA_NATURAL_JURIDICA.FECAPLICASAT is 'Fecha aplicabilidad en SAT';


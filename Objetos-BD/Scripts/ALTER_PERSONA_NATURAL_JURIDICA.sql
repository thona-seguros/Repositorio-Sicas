-- =============================
-- Modifica tabla
-- =============================
--  
ALTER TABLE PERSONA_NATURAL_JURIDICA
ADD
RAZONSOCIALFACT	VARCHAR2(300),
FECMOVTOSICAS	DATE,
FECAPLICASAT	DATE
)
;
COMMENT ON COLUMN PERSONA_NATURAL_JURIDICA.RAZONSOCIALFACT IS 'Razón Social Facturación Electrónica';
COMMENT on column PERSONA_NATURAL_JURIDICA.FECMOVTOSICAS is 'Fecha movimiento en SICAS';
comment on column PERSONA_NATURAL_JURIDICA.FECAPLICASAT is 'Fecha aplicabilidad en SAT';


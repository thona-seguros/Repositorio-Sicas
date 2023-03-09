-- Modifica tabla
-- =============================
--  
ALTER TABLE PLD_OPE_PREOCUPANTES
ADD
(
ST_OPERACION VARCHAR2(6) DEFAULT 'PEND',
OBSERVACIONES VARCHAR2(500)
)
;
 
comment on column PLD_OPE_PREOCUPANTES.ST_OPERACION is 'Estatus de  Operación (ESTADOS)';
comment on column PLD_OPE_PREOCUPANTES.OBSERVACIONES is 'Observaciones';

/



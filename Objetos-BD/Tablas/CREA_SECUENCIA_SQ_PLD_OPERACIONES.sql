-- =============================
-- borra sequence 
-- =============================
--DROP SEQUENCE SQ_PLD_OPERACIONES;  

-- =============================
-- Create sequence 
-- =============================
create sequence SQ_PLD_OPERACIONES
minvalue 1
maxvalue 99999999999999
start with 20230000001
increment by 1
cache 20;

-- =============================
-- Genera los permisos
-- =============================
create or replace public synonym SQ_PLD_OPERACIONES
  for SICAS_OC.SQ_PLD_OPERACIONES;
  
GRANT SELECT ON SQ_PLD_OPERACIONES TO PUBLIC
;

GRANT ALTER ON SQ_PLD_OPERACIONES TO PUBLIC
;

 
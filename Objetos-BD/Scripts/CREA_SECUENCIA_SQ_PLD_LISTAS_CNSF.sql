-- =============================
-- borra sequence 
-- =============================
--DROP SEQUENCE PLD_LISTAS_CNSF;  
 
-- =============================
-- Create sequence 
-- =============================
create sequence SQ_PLD_LISTAS_CNSF
minvalue 1
maxvalue 99999999999999
start with 1
increment by 1
cache 20;

-- =============================
-- Genera los permisos
-- =============================
create or replace public synonym SQ_PLD_LISTAS_CNSF
  for SICAS_OC.SQ_PLD_LISTAS_CNSF;
  
GRANT SELECT ON SQ_PLD_LISTAS_CNSF TO PUBLIC
;

GRANT ALTER ON SQ_PLD_LISTAS_CNSF TO PUBLIC
;

 
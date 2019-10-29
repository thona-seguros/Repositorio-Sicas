-- =============================
-- Create sequence 
-- =============================
create sequence SQ_NOMINA
minvalue 1
maxvalue 99999999999999
start with 20190000000
increment by 1
cache 20;

-- =============================
-- Genera los permisos
-- =============================
create or replace public synonym SQ_NOMINA
  for SICAS_OC.SQ_NOMINA;
  
grant select on SQ_NOMINA to PUBLIC
;


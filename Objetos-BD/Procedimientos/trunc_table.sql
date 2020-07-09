--
-- TRUNC_TABLE  (Procedure) 
--
--  Dependencies: 
--   STANDARD (Package)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--
CREATE OR REPLACE PROCEDURE SICAS_OC.TRUNC_TABLE(tbl_name in varchar2)
IS
   PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
  execute immediate 'truncate table ' ||  tbl_name;

END trunc_table;
/

--
-- TRUNC_TABLE  (Synonym) 
--
--  Dependencies: 
--   TRUNC_TABLE (Procedure)
--
CREATE OR REPLACE PUBLIC SYNONYM TRUNC_TABLE FOR SICAS_OC.TRUNC_TABLE
/


GRANT EXECUTE ON SICAS_OC.TRUNC_TABLE TO PUBLIC
/

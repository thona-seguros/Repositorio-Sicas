--
-- PROC_PRUEBA  (Procedure) 
--
--  Dependencies: 
--   STANDARD (Package)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   PERSONA_NATURAL_JURIDICA (Table)
--
CREATE OR REPLACE PROCEDURE SICAS_OC."PROC_PRUEBA" IS
   cDummy VARCHAR2(1);
BEGIN
    select 'X' into cdummy
    from persona_natural_juridica
    where rownum = 1;
EXCEPTION
    WHEN no_data_found THEN null;
END; -- Procedure
/

--
-- PROC_PRUEBA  (Synonym) 
--
--  Dependencies: 
--   PROC_PRUEBA (Procedure)
--
CREATE OR REPLACE PUBLIC SYNONYM PROC_PRUEBA FOR SICAS_OC.PROC_PRUEBA
/


GRANT EXECUTE ON SICAS_OC.PROC_PRUEBA TO PUBLIC
/

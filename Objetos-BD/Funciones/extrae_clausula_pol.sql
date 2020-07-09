--
-- EXTRAE_CLAUSULA_POL  (Function) 
--
--  Dependencies: 
--   STANDARD (Package)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   CLAUSULAS_POLIZA (Table)
--
CREATE OR REPLACE FUNCTION SICAS_OC.EXTRAE_CLAUSULA_POL(RowID_of_Long   IN ROWID) RETURN VARCHAR2 IS
    Long_to_Varchar VARCHAR(32767);

BEGIN
    SELECT TEXTO
      INTO Long_to_Varchar
      FROM CLAUSULAS_POLIZA
     WHERE ROWID = rowid_of_long;
    RETURN long_to_varchar;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error occurred on rowid: '||rowid_of_long||' '||SQLERRM;
END;
/

--
-- EXTRAE_CLAUSULA_POL  (Synonym) 
--
--  Dependencies: 
--   EXTRAE_CLAUSULA_POL (Function)
--
CREATE OR REPLACE PUBLIC SYNONYM EXTRAE_CLAUSULA_POL FOR SICAS_OC.EXTRAE_CLAUSULA_POL
/

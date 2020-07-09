--
-- GET_COMNT_TXT  (Function) 
--
--  Dependencies: 
--   STANDARD (Package)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   ASISTENCIAS (Table)
--
CREATE OR REPLACE FUNCTION SICAS_OC.Get_Comnt_txt (RowID_of_Long IN ROWID) RETURN VARCHAR2 IS
    Long_to_Varchar VARCHAR(32767);
BEGIN
    SELECT textoasistencia
      INTO Long_to_Varchar
      FROM asistencias
     WHERE ROWID = rowid_of_long;
    RETURN long_to_varchar;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error occurred on rowid: '||rowid_of_long||' '||SQLERRM;
END;
/

--
-- GET_COMNT_TXT  (Synonym) 
--
--  Dependencies: 
--   GET_COMNT_TXT (Function)
--
CREATE OR REPLACE PUBLIC SYNONYM GET_COMNT_TXT FOR SICAS_OC.GET_COMNT_TXT
/

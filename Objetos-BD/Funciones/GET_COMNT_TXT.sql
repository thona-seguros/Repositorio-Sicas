FUNCTION Get_Comnt_txt (RowID_of_Long IN ROWID) RETURN VARCHAR2 IS
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

create or replace FUNCTION SICAS_OC.FN_OBTENER_REGIMEN_FISCAL (
    p_IDREGFISSAT      IN NUMBER DEFAULT NULL,
    p_DESCTIPOREGIMEN  IN VARCHAR2 DEFAULT NULL
) RETURN CLOB
AS
    v_resultado         SYS_REFCURSOR;
    v_json              CLOB;
    v_temp              CLOB;
    
    -- Variables para almacenar cada columna del resultado
    v_IDREGFISSAT       CAT_REGIMEN_FISCAL.IDREGFISSAT%TYPE;
    v_TIPOPERSONA       CAT_REGIMEN_FISCAL.TIPOPERSONA%TYPE;
    v_DESCTIPOREGIMEN   CAT_REGIMEN_FISCAL.DESCTIPOREGIMEN%TYPE;
BEGIN
    -- Crear un CLOB temporal para construir el JSON
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH('[ '), '[ ');
    
    -- Llamar al procedure para obtener el cursor con los datos
    WS_OBTENER_REGIMEN_FISCAL(
        p_IDREGFISSAT      => p_IDREGFISSAT,
        p_DESCTIPOREGIMEN  => p_DESCTIPOREGIMEN,
        p_resultado        => v_resultado
    );
    
    -- Recorrer el cursor y construir manualmente el JSON
    LOOP
        FETCH v_resultado INTO v_IDREGFISSAT, v_TIPOPERSONA, v_DESCTIPOREGIMEN;
        EXIT WHEN v_resultado%NOTFOUND;
        
        v_temp := '{
            "IDREGFISSAT": ' || v_IDREGFISSAT || ',
            "TIPOPERSONA": "' || v_TIPOPERSONA || '",
            "DESCTIPOREGIMEN": "' || v_DESCTIPOREGIMEN || '"
        }';
        
        -- Agregar coma si ya existe contenido previo (más de solo el "[ ")
        IF DBMS_LOB.GETLENGTH(v_json) > 2 THEN
            DBMS_LOB.WRITEAPPEND(v_json, LENGTH(', '), ', ');
        END IF;
        
        DBMS_LOB.WRITEAPPEND(v_json, LENGTH(v_temp), v_temp);
    END LOOP;
    
    CLOSE v_resultado;
    
    -- Cerrar el array JSON
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH(' ]'), ' ]');
    
    RETURN v_json;
EXCEPTION
    WHEN OTHERS THEN
        RETURN '{ "error": "' || SQLERRM || '" }';
END FN_OBTENER_REGIMEN_FISCAL;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_OBTENER_REGIMEN_FISCAL FOR SICAS_OC.FN_OBTENER_REGIMEN_FISCAL
/

GRANT EXECUTE ON SICAS_OC.FN_OBTENER_REGIMEN_FISCAL TO PUBLIC
/

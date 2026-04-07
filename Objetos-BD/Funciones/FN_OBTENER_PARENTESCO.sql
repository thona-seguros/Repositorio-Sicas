create or replace FUNCTION SICAS_OC.FN_OBTENER_PARENTESCO (
    p_CodParentesco IN NUMBER DEFAULT NULL,
    p_DescParentesco IN VARCHAR2 DEFAULT NULL
) RETURN CLOB
AS
    v_resultado SYS_REFCURSOR;
    v_json      CLOB;
    v_temp      CLOB;
    
    -- Variables para cada columna del resultado
    v_CodValor  VALORES_DE_LISTAS.CodValor%TYPE;
    v_Descrip   VARCHAR2(400);
BEGIN
    -- Crear un CLOB temporal para almacenar el JSON
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH('[ '), '[ ');
    
    -- Llamar al procedure para obtener el cursor con los datos
    WS_OBTENER_PARENTESCO(
        p_CodParentesco => p_CodParentesco,
        p_DescParentesco => p_DescParentesco,
        p_resultado     => v_resultado
    );
    
    -- Recorrer el cursor y construir el JSON manualmente
    LOOP
        FETCH v_resultado INTO v_Descrip, v_CodValor;
        EXIT WHEN v_resultado%NOTFOUND;
        
        v_temp := '{
            "DESCRIP": "' || v_Descrip || '",
            "CODPARENTESCO": "' || v_CodValor || '"
        }';
        
        -- Agregar coma si ya hay contenido previo (más de solo el "[ ")
        IF DBMS_LOB.GETLENGTH(v_json) > 2 THEN
            DBMS_LOB.WRITEAPPEND(v_json, LENGTH(', '), ', ');
        END IF;
        
        DBMS_LOB.WRITEAPPEND(v_json, LENGTH(v_temp), v_temp);
    END LOOP;
    
    CLOSE v_resultado;
    
    -- Cerrar JSON array
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH(' ]'), ' ]');
    
    RETURN v_json;
EXCEPTION
    WHEN OTHERS THEN
        RETURN '{ "error": "' || SQLERRM || '" }';
END FN_OBTENER_PARENTESCO;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_OBTENER_PARENTESCO FOR SICAS_OC.FN_OBTENER_PARENTESCO
/

GRANT EXECUTE ON SICAS_OC.FN_OBTENER_PARENTESCO TO PUBLIC
/
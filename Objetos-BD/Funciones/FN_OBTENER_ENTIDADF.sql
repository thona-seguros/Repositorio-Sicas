create or replace FUNCTION SICAS_OC.FN_OBTENER_ENTIDADF (
    p_codentidad  IN NUMBER DEFAULT NULL,
    p_descentidad IN VARCHAR2 DEFAULT NULL,
    p_codcia       IN NUMBER DEFAULT NULL,
    p_codempresa   IN NUMBER DEFAULT NULL
) RETURN CLOB 
AS
    v_resultado SYS_REFCURSOR;
    v_json      CLOB;
    v_temp      CLOB;
    
    -- Variables para cada columna del resultado
    v_CodEntidad ENTIDAD_FINANCIERA.CODENTIDAD%TYPE;
    v_DescEntidad VARCHAR2(300);
BEGIN
    -- Crear un CLOB temporal para almacenar el JSON
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH('[ '), '[ ');
    
    -- Llamar al procedimiento para obtener el cursor con los datos
    WS_OBTENER_ENTIDADF(
        p_codentidad  => p_codentidad,
        p_descentidad => p_descentidad,
        p_codcia      => p_codcia,
        p_codempresa  => p_codempresa,
        p_resultado   => v_resultado
    );
    
    -- Recorrer el cursor y construir el JSON manualmente
    LOOP
        FETCH v_resultado INTO v_CodEntidad, v_DescEntidad;
        EXIT WHEN v_resultado%NOTFOUND;
        
        v_temp := '{
            "CODENTIDAD": "' || v_CodEntidad || '",
            "DESCENTIDAD": "' || v_DescEntidad || '"
        }';
        
        -- Si ya hay contenido (más de solo el [ ) agregar coma
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
END FN_OBTENER_ENTIDADF;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_OBTENER_ENTIDADF FOR SICAS_OC.FN_OBTENER_ENTIDADF
/

GRANT EXECUTE ON SICAS_OC.FN_OBTENER_ENTIDADF TO PUBLIC
/
create or replace FUNCTION SICAS_OC.FN_OBTENER_TIPO_SINIESTROS (
    p_codvalor IN VARCHAR2 DEFAULT NULL,
    p_descval  IN VARCHAR2 DEFAULT NULL
) RETURN CLOB
AS
    v_resultado   SYS_REFCURSOR;
    v_json        CLOB;
    v_temp        CLOB;
    v_codvalor    VALORES_DE_LISTAS.CODVALOR%TYPE;
    v_descval     VALORES_DE_LISTAS.DescValLst%TYPE;
BEGIN
    -- Inicializar CLOB para el JSON
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH('[ '), '[ ');
    -- Llamar al procedimiento para obtener los datos
    WS_OBTENER_TIPO_SINIESTROS(
        p_codvalor  => p_codvalor,
        p_descval   => p_descval,
        p_resultado => v_resultado
    );
    -- Iterar sobre el cursor y construir el JSON
    LOOP
        FETCH v_resultado INTO
            v_codvalor,
            v_descval;
        EXIT WHEN v_resultado%NOTFOUND;
        v_temp := '{
            "CodValor": "' || v_codvalor || '",
            "DescVal": "' || v_descval || '"
        }';
        -- Añadir coma si no es el primer elemento
        IF DBMS_LOB.GETLENGTH(v_json) > 2 THEN
            DBMS_LOB.WRITEAPPEND(v_json, 2, ', ');
        END IF;
        -- Añadir el objeto JSON al CLOB
        DBMS_LOB.WRITEAPPEND(v_json, LENGTH(v_temp), v_temp);
    END LOOP;
    -- Cerrar el cursor
    CLOSE v_resultado;
    -- Cerrar el array JSON
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH(' ]'), ' ]');
    RETURN v_json;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejo de errores
        RETURN '{ "error": "' || SQLERRM || '" }';
END FN_OBTENER_TIPO_SINIESTROS;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_OBTENER_TIPO_SINIESTROS FOR SICAS_OC.FN_OBTENER_TIPO_SINIESTROS
/

GRANT EXECUTE ON SICAS_OC.FN_OBTENER_TIPO_SINIESTROS TO PUBLIC
/
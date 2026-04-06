create or replace FUNCTION SICAS_OC.FN_OBTENER_DIAGNOSTICO (
    p_nombre_concepto IN VARCHAR2 DEFAULT NULL,
    p_valor_largo     IN VARCHAR2 DEFAULT NULL
) RETURN CLOB
AS
    v_resultado       SYS_REFCURSOR;
    v_json            CLOB;
    v_temp            CLOB;
    v_cage_nom_concep SAI_CAT_GENERAL.CAGE_NOM_CONCEP%TYPE;
    v_cage_valor_largo SAI_CAT_GENERAL.CAGE_VALOR_LARGO%TYPE;
BEGIN
    -- Inicializar CLOB para el JSON
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH('[ '), '[ ');
    -- Llamar al procedimiento para obtener los datos
    WS_OBTENER_DIAGNOSTICO(
        p_nombre_concepto => p_nombre_concepto,
        p_valor_largo     => p_valor_largo,
        p_resultado       => v_resultado
    );
    -- Iterar sobre el cursor y construir el JSON
    LOOP
        FETCH v_resultado INTO
            v_cage_nom_concep,
            v_cage_valor_largo;
        EXIT WHEN v_resultado%NOTFOUND;
        v_temp := '{
            "CodValor": "' || v_cage_nom_concep || '",
            "DescVal": "' || v_cage_valor_largo || '"
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
END FN_OBTENER_DIAGNOSTICO;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_OBTENER_DIAGNOSTICO FOR SICAS_OC.FN_OBTENER_DIAGNOSTICO
/

GRANT EXECUTE ON SICAS_OC.FN_OBTENER_DIAGNOSTICO TO PUBLIC
/
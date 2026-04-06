create or replace FUNCTION SICAS_OC.FN_OBTENER_MUNICIPIOS (
     p_codigo_pais         IN VARCHAR2 DEFAULT NULL,
    p_codigo_estado       IN VARCHAR2 DEFAULT NULL,
    p_codmunicipio  IN VARCHAR2 DEFAULT NULL,
    p_descmunicipio IN VARCHAR2 DEFAULT NULL
) RETURN CLOB
AS
    v_resultado     SYS_REFCURSOR;
    v_json          CLOB;
    v_temp          CLOB;
    v_codmunicipio  CORREGIMIENTO.CODMUNICIPIO%TYPE;
    v_descmunicipio CORREGIMIENTO.DESCMUNICIPIO%TYPE;
    v_codciudad     CORREGIMIENTO.CODCIUDAD%TYPE;   -- Nuevo campo
    v_codestado     CORREGIMIENTO.CODESTADO%TYPE;   -- Nuevo campo
    v_codpais       CORREGIMIENTO.CODPAIS%TYPE;     -- Nuevo campo
BEGIN
    -- Inicializar CLOB para el JSON
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH('[ '), '[ ');
    -- Llamar al procedimiento para obtener los datos
    WS_OBTENER_MUNICIPIOS(
        p_codigo_pais   => p_codigo_pais,
        p_codigo_estado => p_codigo_estado,
        p_codmunicipio  => p_codmunicipio,
        p_descmunicipio => p_descmunicipio,
        p_resultado     => v_resultado
    );
    -- Iterar sobre el cursor y construir el JSON
    LOOP
        FETCH v_resultado INTO
            v_codmunicipio,
            v_descmunicipio,
            v_codciudad,    -- Fetch del nuevo campo
            v_codestado,    -- Fetch del nuevo campo
            v_codpais;      -- Fetch del nuevo campo
        EXIT WHEN v_resultado%NOTFOUND;
        v_temp := '{
            "CODMUNICIPIO": "' || v_codmunicipio || '",
            "DESCMUNICIPIO": "' || v_descmunicipio || '",
            "CODCIUDAD": "' || v_codciudad || '",  
            "CODESTADO": "' || v_codestado || '",  
            "CODPAIS": "' || v_codpais || '"       
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
END FN_OBTENER_MUNICIPIOS;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_OBTENER_MUNICIPIOS FOR SICAS_OC.FN_OBTENER_MUNICIPIOS
/

GRANT EXECUTE ON SICAS_OC.FN_OBTENER_MUNICIPIOS TO PUBLIC
/
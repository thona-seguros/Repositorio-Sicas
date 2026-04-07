create or replace FUNCTION SICAS_OC.FN_OBTENER_COLONIA (
    p_codigo_postal        IN NUMBER DEFAULT NULL,
    p_descripcion_colonia  IN VARCHAR2 DEFAULT NULL,
    p_descripcion_municipio IN VARCHAR2 DEFAULT NULL
) RETURN CLOB 
AS
    v_resultado            SYS_REFCURSOR;
    v_json                 CLOB;
    v_temp                 CLOB;
    
    -- Variables para cada columna del resultado
    v_codigo_postal        COLONIA.CODIGO_POSTAL%TYPE;
    v_codigo_colonia       COLONIA.CODIGO_COLONIA%TYPE;
    v_desc_colonia         COLONIA.DESCRIPCION_COLONIA%TYPE;
    v_codmunicipio         COLONIA.CODMUNICIPIO%TYPE;
    v_descmunicipio        CORREGIMIENTO.DESCMUNICIPIO%TYPE;
    v_codestado            COLONIA.CODESTADO%TYPE;
    v_desceestado          PROVINCIA.DESCESTADO%TYPE;
    v_codprovalterno       PROVINCIA.CODPROVALTERNO%TYPE;
    v_codpais              COLONIA.CODPAIS%TYPE;
    v_descpais             PAIS.DESCPAIS%TYPE;
    v_codpaisalterno       PAIS.CODPAISALTERNO%TYPE;
    
BEGIN
    -- Crear un CLOB temporal para almacenar el JSON
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH('[ '), '[ ');
    
    -- Llamar al procedimiento para obtener el cursor con los datos
    WS_OBTENER_COLONIA(
        p_codigo_postal        => p_codigo_postal,
        p_descripcion_colonia  => p_descripcion_colonia,
        p_descripcion_municipio => p_descripcion_municipio,
        p_resultado            => v_resultado
    );
    
    -- Recorrer el cursor y construir el JSON manualmente
    LOOP
        FETCH v_resultado INTO 
            v_codigo_postal,
            v_codigo_colonia,
            v_desc_colonia,
            v_codmunicipio,
            v_descmunicipio,
            v_codestado,
            v_desceestado,
            v_codprovalterno,
            v_codpais,
            v_descpais,
            v_codpaisalterno;
        EXIT WHEN v_resultado%NOTFOUND;
        
        v_temp := '{
            "CODIGO_POSTAL": ' || v_codigo_postal || ',
            "CODIGO_COLONIA": "' || v_codigo_colonia || '",
            "DESCRIPCION_COLONIA": "' || v_desc_colonia || '",
            "CODMUNICIPIO": "' || v_codmunicipio || '",
            "DESCMUNICIPIO": "' || v_descmunicipio || '",
            "CODESTADO": "' || v_codestado || '",
            "DESCESTADO": "' || v_desceestado || '",
            "CODPROVALTERNO": "' || v_codprovalterno || '",
            "CODPAIS": "' || v_codpais || '",
            "DESCPAIS": "' || v_descpais || '",
            "CODPAISALTERNO": "' || v_codpaisalterno || '"
        }';
        
        -- Agregar coma si no es la primera fila
        IF DBMS_LOB.GETLENGTH(v_json) > 2 THEN
            DBMS_LOB.WRITEAPPEND(v_json, LENGTH(', '), ', ');
        END IF;
        
        DBMS_LOB.WRITEAPPEND(v_json, LENGTH(v_temp), v_temp);
    END LOOP;
    
    -- Cerrar el cursor
    CLOSE v_resultado;
    
    -- Cerrar JSON array
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH(' ]'), ' ]');
    
    -- Retornar el JSON generado
    RETURN v_json;
EXCEPTION
    WHEN OTHERS THEN
        RETURN '{ "error": "' || SQLERRM || '" }';
END FN_OBTENER_COLONIA;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_OBTENER_COLONIA FOR SICAS_OC.FN_OBTENER_COLONIA
/

GRANT EXECUTE ON SICAS_OC.FN_OBTENER_COLONIA TO PUBLIC
/
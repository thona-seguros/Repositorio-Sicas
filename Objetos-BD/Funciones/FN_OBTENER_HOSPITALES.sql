create or replace FUNCTION SICAS_OC.FN_OBTENER_HOSPITALES (
    p_codproveedor  IN VARCHAR2 DEFAULT NULL,
    p_nombre_hospital IN VARCHAR2 DEFAULT NULL
) RETURN CLOB
AS
    v_resultado       SYS_REFCURSOR;
    v_json            CLOB;
    v_temp            CLOB;
    v_codproveedor    PROVEEDORES.CodProveedor%TYPE;
    v_hospital_nombre VARCHAR2(100); -- Ajustar el tamaño según el SUBSTR en la consulta
BEGIN
    -- Inicializar CLOB para el JSON
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH('[ '), '[ ');
    -- Llamar al procedimiento para obtener los datos
    WS_OBTENER_HOSPITALES(
        p_codproveedor    => p_codproveedor,
        p_nombre_hospital => p_nombre_hospital,
        p_resultado       => v_resultado
    );
    -- Iterar sobre el cursor y construir el JSON
    LOOP
        FETCH v_resultado INTO
            v_codproveedor,
            v_hospital_nombre;
        EXIT WHEN v_resultado%NOTFOUND;
        v_temp := '{
            "CodHospital": "' || v_codproveedor || '",
            "DescHospital": "' || v_hospital_nombre || '"
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
END FN_OBTENER_HOSPITALES;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_OBTENER_HOSPITALES FOR SICAS_OC.FN_OBTENER_HOSPITALES
/

GRANT EXECUTE ON SICAS_OC.FN_OBTENER_HOSPITALES TO PUBLIC
/
create or replace FUNCTION SICAS_OC.FN_OBTENER_ESTADO (
    p_codigo_pais         IN VARCHAR2 DEFAULT NULL,
    p_codigo_estado       IN VARCHAR2 DEFAULT NULL,
    p_descripcion_estado  IN VARCHAR2 DEFAULT NULL
) RETURN CLOB
AS
    v_resultado           SYS_REFCURSOR;
    v_json                CLOB;
    v_temp                CLOB;
    v_codestado           PROVINCIA.CODESTADO%TYPE;
    v_desceestado         PROVINCIA.DESCESTADO%TYPE;
    v_codprovalterno      PROVINCIA.CODPROVALTERNO%TYPE;
    v_codpais             PROVINCIA.CODPAIS%TYPE;
    v_descpais            PAIS.DESCPAIS%TYPE;
    v_codpaisalterno      PAIS.CODPAISALTERNO%TYPE;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH('[ '), '[ ');
    WS_OBTENER_ESTADO(
        p_codigo_pais         => p_codigo_pais,
        p_codigo_estado       => p_codigo_estado,
        p_descripcion_estado  => p_descripcion_estado,
        p_resultado           => v_resultado
    );
    LOOP
        FETCH v_resultado INTO 
            v_codestado,
            v_desceestado,
            v_codprovalterno,
            v_codpais,
            v_descpais,
            v_codpaisalterno;
        EXIT WHEN v_resultado%NOTFOUND;
        v_temp := '{
            "CODESTADO": "' || v_codestado || '",
            "DESCESTADO": "' || v_desceestado || '",
            "CODPROVALTERNO": "' || v_codprovalterno || '",
            "CODPAIS": "' || v_codpais || '",
            "DESCPAIS": "' || v_descpais || '",
            "CODPAISALTERNO": "' || v_codpaisalterno || '"
        }';
        IF DBMS_LOB.GETLENGTH(v_json) > 2 THEN
            DBMS_LOB.WRITEAPPEND(v_json, 2, ', ');
        END IF;
        DBMS_LOB.WRITEAPPEND(v_json, LENGTH(v_temp), v_temp);
    END LOOP;
    CLOSE v_resultado;
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH(' ]'), ' ]');
    RETURN v_json;
EXCEPTION
    WHEN OTHERS THEN
        RETURN '{ "error": "' || SQLERRM || '" }';
END;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_OBTENER_ESTADO FOR SICAS_OC.FN_OBTENER_ESTADO
/

GRANT EXECUTE ON SICAS_OC.FN_OBTENER_ESTADO TO PUBLIC
/
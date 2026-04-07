create or replace FUNCTION SICAS_OC.FN_OBTENER_BENEFICIARIO (
    p_idpoliza       IN NUMBER,
    p_cod_asegurado  IN NUMBER
) RETURN CLOB
AS
    v_resultado         SYS_REFCURSOR;
    v_json              CLOB;
    v_temp              CLOB;
    v_benef             NUMBER;
    v_nombre            VARCHAR2(300);
    v_porcepart         NUMBER;
    v_codparent         VARCHAR2(10);
    v_estado            VARCHAR2(10);
    v_sexo              VARCHAR2(1);
    v_fecnac            DATE;
    v_indirrevocable    VARCHAR2(1);
    v_idsiniestro       NUMBER;
    v_origen            VARCHAR2(20);
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH('[ '), '[ ');
    WS_OBTENER_BENEFICIARIO(
        p_idpoliza      => p_idpoliza,
        p_cod_asegurado => p_cod_asegurado,
        p_resultado     => v_resultado
    );
    LOOP
        FETCH v_resultado INTO 
            v_benef,
            v_nombre,
            v_porcepart,
            v_codparent,
            v_estado,
            v_sexo,
            v_fecnac,
            v_indirrevocable,
            v_idsiniestro,
            v_origen;
        EXIT WHEN v_resultado%NOTFOUND;
        v_temp := '{
            "BENEF": "' || v_benef || '",
            "NOMBRE": "' || v_nombre || '",
            "PORCEPART": "' || v_porcepart || '",
            "CODPARENT": "' || v_codparent || '",
            "ESTADO": "' || v_estado || '",
            "SEXO": "' || v_sexo || '",
            "FECNAC": "' || TO_CHAR(v_fecnac, 'YYYY-MM-DD') || '",
            "INDIRREVOCABLE": "' || NVL(v_indirrevocable, '') || '",
            "IDSINIESTRO": "' || NVL(v_idsiniestro, '') || '",
            "ORIGEN": "' || v_origen || '"
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
END FN_OBTENER_BENEFICIARIO;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_OBTENER_BENEFICIARIO FOR SICAS_OC.FN_OBTENER_BENEFICIARIO
/

GRANT EXECUTE ON SICAS_OC.FN_OBTENER_BENEFICIARIO TO PUBLIC
/
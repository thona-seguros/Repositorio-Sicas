create or replace FUNCTION SICAS_OC.FN_OBTENER_CAUSAS_SINIESTRO (
    p_codvalor IN VARCHAR2 DEFAULT NULL,
    p_descval  IN VARCHAR2 DEFAULT NULL
) RETURN CLOB
AS
    v_resultado CLOB;
BEGIN
    WS_OBTENER_CAUSAS_SINIESTRO(
        p_codvalor  => p_codvalor,
        p_descval   => p_descval,
        p_resultado => v_resultado
    );
    RETURN v_resultado;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejo de errores para la función, devolviendo un JSON con el error
        RETURN '{ "success": false, "mensaje": "Error en FN_OBTENER_CAUSAS_SINIESTRO: ' || SQLERRM || '", "data": [] }';
END FN_OBTENER_CAUSAS_SINIESTRO;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_OBTENER_CAUSAS_SINIESTRO FOR SICAS_OC.FN_OBTENER_CAUSAS_SINIESTRO
/

GRANT EXECUTE ON SICAS_OC.FN_OBTENER_CAUSAS_SINIESTRO TO PUBLIC
/
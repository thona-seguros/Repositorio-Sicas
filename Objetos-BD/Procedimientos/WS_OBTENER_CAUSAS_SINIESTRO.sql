create or replace PROCEDURE SICAS_OC.WS_OBTENER_CAUSAS_SINIESTRO (
    p_codvalor  IN VARCHAR2 DEFAULT NULL,
    p_descval   IN VARCHAR2 DEFAULT NULL,
    p_resultado OUT CLOB 
) AS
BEGIN
    -- Genera el array JSON completo directamente desde la consulta SQL
    SELECT
        JSON_ARRAYAGG(
            JSON_OBJECT(
                'CodValor' VALUE CodValor,
                'DescVal'  VALUE DescValLst
            )
            ORDER BY DescValLst 
            RETURNING CLOB       
        )
    INTO p_resultado
    FROM VALORES_DE_LISTAS
    WHERE CODLISTA = 'CAUSIN'
      AND (p_codvalor IS NULL OR CODVALOR = p_codvalor)
      AND (p_descval IS NULL OR UPPER(DescValLst) LIKE '%' || UPPER(p_descval) || '%');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Si no se encuentran registros, devolver un array JSON vacío
        p_resultado := '[]';
    WHEN OTHERS THEN
        -- Captura cualquier otro error y devuelve un JSON de error
        p_resultado := '{ "error": "Error interno al obtener causas de siniestro: ' || SQLERRM || '" }';
END WS_OBTENER_CAUSAS_SINIESTRO;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_OBTENER_CAUSAS_SINIESTRO FOR SICAS_OC.WS_OBTENER_CAUSAS_SINIESTRO
/

GRANT EXECUTE ON SICAS_OC.WS_OBTENER_CAUSAS_SINIESTRO TO PUBLIC
/
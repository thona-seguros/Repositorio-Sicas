create or replace PROCEDURE SICAS_OC.WS_OBTENER_TIPO_SINIESTROS (
    p_codvalor  IN VARCHAR2 DEFAULT NULL,
    p_descval   IN VARCHAR2 DEFAULT NULL,
    p_resultado OUT SYS_REFCURSOR
) AS
BEGIN
    -- Abrir el cursor con la consulta de tipos de siniestro
    OPEN p_resultado FOR
        SELECT
            CodValor,
            DescValLst
        FROM VALORES_DE_LISTAS
        WHERE CODLISTA = 'TIPOSINI'
          AND (p_codvalor IS NULL OR CODVALOR = p_codvalor)
          AND (p_descval IS NULL OR UPPER(DescValLst) LIKE '%' || UPPER(p_descval) || '%')
        ORDER BY DescValLst;
END WS_OBTENER_TIPO_SINIESTROS;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_OBTENER_TIPO_SINIESTROS FOR SICAS_OC.WS_OBTENER_TIPO_SINIESTROS
/

GRANT EXECUTE ON SICAS_OC.WS_OBTENER_TIPO_SINIESTROS TO PUBLIC
/

create or replace PROCEDURE SICAS_OC.WS_OBTENER_MUNICIPIOS (
    p_codigo_pais         IN VARCHAR2 DEFAULT NULL,
    p_codigo_estado       IN VARCHAR2 DEFAULT NULL,
    p_codmunicipio  IN VARCHAR2 DEFAULT NULL,
    p_descmunicipio IN VARCHAR2 DEFAULT NULL,
    p_resultado     OUT SYS_REFCURSOR
) AS
BEGIN
    -- Abrir el cursor con la consulta de municipios
    OPEN p_resultado FOR
        SELECT CODMUNICIPIO, DESCMUNICIPIO, CODCIUDAD, CODESTADO, CODPAIS
        FROM CORREGIMIENTO
        WHERE (p_codigo_pais IS NULL OR CODPAIS = p_codigo_pais)
          AND (p_codigo_estado IS NULL OR CODESTADO = p_codigo_estado)
          AND (p_codmunicipio IS NULL OR CODMUNICIPIO = p_codmunicipio)
          AND (p_descmunicipio IS NULL OR UPPER(DESCMUNICIPIO) LIKE '%' || UPPER(p_descmunicipio) || '%')
        ORDER BY DESCMUNICIPIO;
END WS_OBTENER_MUNICIPIOS;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_OBTENER_MUNICIPIOS FOR SICAS_OC.WS_OBTENER_MUNICIPIOS
/

GRANT EXECUTE ON SICAS_OC.WS_OBTENER_MUNICIPIOS TO PUBLIC
/
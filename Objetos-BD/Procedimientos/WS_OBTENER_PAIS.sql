create or replace PROCEDURE SICAS_OC.WS_OBTENER_PAIS (
    p_codigo_pais       IN VARCHAR2 DEFAULT NULL,
    p_descripcion_pais  IN VARCHAR2 DEFAULT NULL,
    p_resultado         OUT SYS_REFCURSOR
) AS
BEGIN
    /*IF p_codigo_pais IS NULL AND p_descripcion_pais IS NULL THEN
        RAISE_APPLICATION_ERROR(-20201, 'Debe especificar al menos un parámetro de búsqueda.');
    END IF;
    IF p_descripcion_pais IS NOT NULL AND LENGTH(TRIM(p_descripcion_pais)) < 3 THEN
        RAISE_APPLICATION_ERROR(-20202, 'La descripción del país debe tener al menos 3 caracteres.');
    END IF;*/
    OPEN p_resultado FOR
        SELECT 
            P.CODPAIS,
            P.DESCPAIS,
            P.CODPAISALTERNO
        FROM PAIS P
        WHERE (p_codigo_pais IS NULL OR P.CODPAIS = p_codigo_pais)
          AND (p_descripcion_pais IS NULL OR UPPER(P.DESCPAIS) LIKE '%' || UPPER(p_descripcion_pais) || '%');
END WS_OBTENER_PAIS;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_OBTENER_PAIS FOR SICAS_OC.WS_OBTENER_PAIS
/

GRANT EXECUTE ON SICAS_OC.WS_OBTENER_PAIS TO PUBLIC
/
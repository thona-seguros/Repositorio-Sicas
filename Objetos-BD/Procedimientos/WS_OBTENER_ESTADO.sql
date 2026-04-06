create or replace PROCEDURE SICAS_OC.WS_OBTENER_ESTADO (
    p_codigo_pais         IN VARCHAR2 DEFAULT NULL,
    p_codigo_estado       IN VARCHAR2 DEFAULT NULL,
    p_descripcion_estado  IN VARCHAR2 DEFAULT NULL,
    p_resultado           OUT SYS_REFCURSOR
) AS
BEGIN
   /* IF p_codigo_estado IS NULL AND p_descripcion_estado IS NULL THEN
        RAISE_APPLICATION_ERROR(-20101, 'Debe especificar al menos un parámetro de búsqueda.');
    END IF;
    IF p_descripcion_estado IS NOT NULL AND LENGTH(TRIM(p_descripcion_estado)) < 3 THEN
        RAISE_APPLICATION_ERROR(-20102, 'La descripción del estado debe tener al menos 3 caracteres.');
    END IF;*/
    OPEN p_resultado FOR
        SELECT 
            E.CODESTADO,
            E.DESCESTADO,
            E.CODPROVALTERNO,
            E.CODPAIS,
            P.DESCPAIS,
            P.CODPAISALTERNO
        FROM PROVINCIA E
        JOIN PAIS P ON E.CODPAIS = P.CODPAIS
        WHERE (p_codigo_pais IS NULL OR E.CODPAIS = p_codigo_pais)
          AND (p_codigo_estado IS NULL OR E.CODESTADO = p_codigo_estado)
          AND (p_descripcion_estado IS NULL OR UPPER(E.DESCESTADO) LIKE '%' || UPPER(p_descripcion_estado) || '%');
END WS_OBTENER_ESTADO;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_OBTENER_ESTADO FOR SICAS_OC.WS_OBTENER_ESTADO
/

GRANT EXECUTE ON SICAS_OC.WS_OBTENER_ESTADO TO PUBLIC
/
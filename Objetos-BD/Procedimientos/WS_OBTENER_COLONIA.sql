create or replace PROCEDURE SICAS_OC.WS_OBTENER_COLONIA (
    p_codigo_postal         IN NUMBER DEFAULT NULL,
    p_descripcion_colonia   IN VARCHAR2 DEFAULT NULL,
    p_descripcion_municipio IN VARCHAR2 DEFAULT NULL,
    p_resultado             OUT SYS_REFCURSOR
) AS
BEGIN
    -- Validación: Debe especificarse al menos un parámetro de búsqueda
    IF p_codigo_postal IS NULL 
       AND p_descripcion_colonia IS NULL 
       AND p_descripcion_municipio IS NULL THEN
       RAISE_APPLICATION_ERROR(-20001, 'Debe especificar al menos un parámetro de búsqueda.');
    END IF;
    
    -- Validación para descripciones (mínimo 3 caracteres)
    IF p_descripcion_colonia IS NOT NULL AND LENGTH(TRIM(p_descripcion_colonia)) < 3 THEN
       RAISE_APPLICATION_ERROR(-20002, 'La descripción de colonia debe tener al menos 3 caracteres.');
    END IF;
    
    IF p_descripcion_municipio IS NOT NULL AND LENGTH(TRIM(p_descripcion_municipio)) < 3 THEN
       RAISE_APPLICATION_ERROR(-20003, 'La descripción de municipio debe tener al menos 3 caracteres.');
    END IF;
    
    -- Apertura del cursor con la consulta ajustada
    OPEN p_resultado FOR
        SELECT 
            C.CODIGO_POSTAL,
            C.CODIGO_COLONIA,
            C.DESCRIPCION_COLONIA,
            C.CODMUNICIPIO,
            M.DESCMUNICIPIO,
            C.CODESTADO,
            E.DESCESTADO,
            CODPROVALTERNO,
            C.CODPAIS,
            P.DESCPAIS,
            P.CODPAISALTERNO
        FROM COLONIA C
        JOIN CORREGIMIENTO M 
            ON (C.CODMUNICIPIO = M.CODMUNICIPIO AND C.CODESTADO = M.CODESTADO)
        JOIN PROVINCIA E 
            ON (E.CODESTADO = C.CODESTADO)
        JOIN PAIS P 
            ON (C.CODPAIS = P.CODPAIS)
        WHERE (p_codigo_postal IS NULL OR LPAD(C.CODIGO_POSTAL, 5, '0') = LPAD(p_codigo_postal, 5, '0'))
          AND (p_descripcion_colonia IS NULL OR UPPER(C.DESCRIPCION_COLONIA) LIKE '%' || UPPER(p_descripcion_colonia) || '%')
          AND (p_descripcion_municipio IS NULL OR UPPER(M.DESCMUNICIPIO) LIKE '%' || UPPER(p_descripcion_municipio) || '%');
END WS_OBTENER_COLONIA;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_OBTENER_COLONIA FOR SICAS_OC.WS_OBTENER_COLONIA
/

GRANT EXECUTE ON SICAS_OC.WS_OBTENER_COLONIA TO PUBLIC
/
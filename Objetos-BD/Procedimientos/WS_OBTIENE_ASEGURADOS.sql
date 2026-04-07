create or replace PROCEDURE SICAS_OC.WS_OBTIENE_ASEGURADOS (
    p_tipo_doc_identificacion IN VARCHAR2 DEFAULT NULL,
    p_num_doc_identificacion IN VARCHAR2 DEFAULT NULL,
    p_nombre IN VARCHAR2 DEFAULT NULL,
    p_apellido_paterno IN VARCHAR2 DEFAULT NULL,
    p_apellido_materno IN VARCHAR2 DEFAULT NULL,
    p_fec_nacimiento IN DATE DEFAULT NULL,
    p_codcia IN NUMBER DEFAULT NULL,
    p_codempresa IN NUMBER DEFAULT NULL, 
    p_resultado OUT SYS_REFCURSOR
) AS
    v_sql VARCHAR2(4000);
BEGIN
    IF p_num_doc_identificacion IS NULL 
       AND p_nombre IS NULL 
       AND p_apellido_paterno IS NULL 
       AND p_fec_nacimiento IS NULL THEN
       RAISE_APPLICATION_ERROR(-20001, 'Debe especificar al menos un parámetro de búsqueda.');
    END IF;
    IF p_num_doc_identificacion IS NOT NULL THEN
        v_sql := 'SELECT 
            AF.COD_ASEGURADO,
            PN.TIPO_DOC_IDENTIFICACION,
            PN.NUM_DOC_IDENTIFICACION,
            PN.NOMBRE,
            PN.APELLIDO_PATERNO,
            PN.APELLIDO_MATERNO,
            PN.TIPO_PERSONA,
            PN.FECNACIMIENTO,
            PN.DIRECRES,
            PN.NUMEXTERIOR,
            PN.NUMINTERIOR,
            PN.CODPAISRES,
            PN.CODPROVRES,
            PN.CODDISTRES,
            PN.CODCORRRES,
            PN.CODPOSRES,
            PN.CODCOLRES,
            PN.EMAIL,
            PN.TELRES,
            C.DESCRIPCION_COLONIA,
            M.DESCMUNICIPIO,
            E.DESCESTADO,
            P.DESCPAIS
        FROM ASEGURADO AF
        INNER JOIN PERSONA_NATURAL_JURIDICA PN 
            ON AF.TIPO_DOC_IDENTIFICACION = PN.TIPO_DOC_IDENTIFICACION 
           AND AF.NUM_DOC_IDENTIFICACION = PN.NUM_DOC_IDENTIFICACION
        LEFT JOIN COLONIA C 
            ON PN.CODCOLRES = C.CODIGO_COLONIA
           AND PN.CODPAISRES = C.CODPAIS
           AND PN.CODPROVRES = C.CODESTADO
           AND PN.CODDISTRES = C.CODMUNICIPIO
        LEFT JOIN CORREGIMIENTO M 
            ON C.CODMUNICIPIO = M.CODMUNICIPIO 
           AND C.CODESTADO = M.CODESTADO
        LEFT JOIN PROVINCIA E 
            ON C.CODESTADO = E.CODESTADO
        LEFT JOIN PAIS P 
            ON C.CODPAIS = P.CODPAIS
        WHERE AF.TIPO_DOC_IDENTIFICACION = :1
          AND AF.NUM_DOC_IDENTIFICACION = :2';
    ELSE
        v_sql := 'SELECT 
            AF.COD_ASEGURADO,
            PN.TIPO_DOC_IDENTIFICACION,
            PN.NUM_DOC_IDENTIFICACION,
            PN.NOMBRE,
            PN.APELLIDO_PATERNO,
            PN.APELLIDO_MATERNO,
            PN.TIPO_PERSONA,
            PN.FECNACIMIENTO,
            PN.DIRECRES,
            PN.NUMEXTERIOR,
            PN.NUMINTERIOR,
            PN.CODPAISRES,
            PN.CODPROVRES,
            PN.CODDISTRES,
            PN.CODCORRRES,
            PN.CODPOSRES,
            PN.CODCOLRES,
            PN.EMAIL,
            PN.TELRES,
            C.DESCRIPCION_COLONIA,
            M.DESCMUNICIPIO,
            E.DESCESTADO,
            P.DESCPAIS
        FROM ASEGURADO AF
        INNER JOIN PERSONA_NATURAL_JURIDICA PN 
            ON AF.TIPO_DOC_IDENTIFICACION = PN.TIPO_DOC_IDENTIFICACION 
           AND AF.NUM_DOC_IDENTIFICACION = PN.NUM_DOC_IDENTIFICACION
        LEFT JOIN COLONIA C 
            ON PN.CODCOLRES = C.CODIGO_COLONIA
           AND PN.CODPAISRES = C.CODPAIS
           AND PN.CODPROVRES = C.CODESTADO
           AND PN.CODDISTRES = C.CODMUNICIPIO
        LEFT JOIN CORREGIMIENTO M 
            ON C.CODMUNICIPIO = M.CODMUNICIPIO 
           AND C.CODESTADO = M.CODESTADO
        LEFT JOIN PROVINCIA E 
            ON C.CODESTADO = E.CODESTADO
        LEFT JOIN PAIS P 
            ON C.CODPAIS = P.CODPAIS
        WHERE UPPER(PN.NOMBRE) LIKE UPPER(:1) || ''%''
          AND UPPER(PN.APELLIDO_PATERNO) LIKE UPPER(:2) || ''%''
          AND PN.FECNACIMIENTO = :3';
        IF p_apellido_materno IS NOT NULL THEN
            v_sql := v_sql || ' AND UPPER(PN.APELLIDO_MATERNO) LIKE UPPER(:4) || ''%''';
        END IF;
    END IF;
    IF p_num_doc_identificacion IS NOT NULL THEN
        OPEN p_resultado FOR v_sql USING p_tipo_doc_identificacion, p_num_doc_identificacion;
    ELSE
        IF p_apellido_materno IS NOT NULL THEN
            OPEN p_resultado FOR v_sql USING p_nombre, p_apellido_paterno, p_fec_nacimiento, p_apellido_materno;
        ELSE
            OPEN p_resultado FOR v_sql USING p_nombre, p_apellido_paterno, p_fec_nacimiento;
        END IF;
    END IF;
END WS_OBTIENE_ASEGURADOS;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_OBTIENE_ASEGURADOS FOR SICAS_OC.WS_OBTIENE_ASEGURADOS
/

GRANT EXECUTE ON SICAS_OC.WS_OBTIENE_ASEGURADOS TO PUBLIC
/
create or replace FUNCTION SICAS_OC.FN_BUSCAR_ASEGURADOS (
    p_tipo_doc_identificacion IN VARCHAR2 DEFAULT NULL,
    p_num_doc_identificacion IN VARCHAR2 DEFAULT NULL,
    p_nombre IN VARCHAR2 DEFAULT NULL,
    p_apellido_paterno IN VARCHAR2 DEFAULT NULL,
    p_apellido_materno IN VARCHAR2 DEFAULT NULL,
    p_fec_nacimiento IN DATE DEFAULT NULL,
    p_CodCia IN NUMBER DEFAULT NULL,
    p_CodEmpresa IN NUMBER DEFAULT NULL  
) RETURN CLOB 
AS
    v_resultado SYS_REFCURSOR;
    v_json CLOB;
    v_temp CLOB;
    -- Variables para cada columna del resultado
    v_cod_asegurado      ASEGURADO.COD_ASEGURADO%TYPE;
    v_tipo_doc_identificacion PERSONA_NATURAL_JURIDICA.TIPO_DOC_IDENTIFICACION%TYPE;
    v_num_doc_identificacion  PERSONA_NATURAL_JURIDICA.NUM_DOC_IDENTIFICACION%TYPE;
    v_nombre            PERSONA_NATURAL_JURIDICA.NOMBRE%TYPE;
    v_apellido_paterno  PERSONA_NATURAL_JURIDICA.APELLIDO_PATERNO%TYPE;
    v_apellido_materno  PERSONA_NATURAL_JURIDICA.APELLIDO_MATERNO%TYPE;
    v_tipo_persona      PERSONA_NATURAL_JURIDICA.TIPO_PERSONA%TYPE;
    v_fec_nacimiento    PERSONA_NATURAL_JURIDICA.FECNACIMIENTO%TYPE;
    v_direcres          PERSONA_NATURAL_JURIDICA.DIRECRES%TYPE;
    v_num_exterior      PERSONA_NATURAL_JURIDICA.NUMEXTERIOR%TYPE;
    v_num_interior      PERSONA_NATURAL_JURIDICA.NUMINTERIOR%TYPE;
    v_codpaisres        PERSONA_NATURAL_JURIDICA.CODPAISRES%TYPE;
    v_codprovres        PERSONA_NATURAL_JURIDICA.CODPROVRES%TYPE;
    v_coddistres        PERSONA_NATURAL_JURIDICA.CODDISTRES%TYPE;
    v_codcorrres        PERSONA_NATURAL_JURIDICA.CODCORRRES%TYPE;
    v_codposres         PERSONA_NATURAL_JURIDICA.CODPOSRES%TYPE;
    v_codcolonia        PERSONA_NATURAL_JURIDICA.CODCOLRES%TYPE;
    v_email             PERSONA_NATURAL_JURIDICA.EMAIL%TYPE;
    v_telefono          PERSONA_NATURAL_JURIDICA.TELRES%TYPE;
    -- Nuevas variables de descripción
    v_desc_colonia      COLONIA.DESCRIPCION_COLONIA%TYPE;
    v_desc_municipio    CORREGIMIENTO.DESCMUNICIPIO%TYPE;
    v_desc_estado       PROVINCIA.DESCESTADO%TYPE;
    v_desc_pais         PAIS.DESCPAIS%TYPE;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH('[ '), '[ ');
    WS_OBTIENE_ASEGURADOS(
        p_tipo_doc_identificacion => p_tipo_doc_identificacion,
        p_num_doc_identificacion => p_num_doc_identificacion,
        p_nombre => p_nombre,
        p_apellido_paterno => p_apellido_paterno,
        p_apellido_materno => p_apellido_materno,
        p_fec_nacimiento => p_fec_nacimiento,
        p_codcia => p_CodCia,
        p_codempresa => p_CodEmpresa,
        p_resultado => v_resultado
    );
    LOOP
        FETCH v_resultado INTO 
            v_cod_asegurado,
            v_tipo_doc_identificacion,
            v_num_doc_identificacion,
            v_nombre,
            v_apellido_paterno,
            v_apellido_materno,
            v_tipo_persona,
            v_fec_nacimiento,
            v_direcres,
            v_num_exterior,
            v_num_interior,
            v_codpaisres,
            v_codprovres,
            v_coddistres,
            v_codcorrres,
            v_codposres,
            v_codcolonia,
            v_email,
            v_telefono,
            v_desc_colonia,
            v_desc_municipio,
            v_desc_estado,
            v_desc_pais;
        EXIT WHEN v_resultado%NOTFOUND;
        v_temp := '{
            "COD_ASEGURADO": "' || v_cod_asegurado || '",
            "TIPO_DOC_IDENTIFICACION": "' || v_tipo_doc_identificacion || '",
            "NUM_DOC_IDENTIFICACION": "' || v_num_doc_identificacion || '",
            "NOMBRE": "' || v_nombre || '",
            "APELLIDO_PATERNO": "' || v_apellido_paterno || '",
            "APELLIDO_MATERNO": "' || v_apellido_materno || '",
            "TIPO_PERSONA": "' || v_tipo_persona || '",
            "FEC_NACIMIENTO": "' || TO_CHAR(v_fec_nacimiento, 'YYYY-MM-DD') || '",
            "DIRECRES": "' || v_direcres || '",
            "NUM_INTERIOR": "' || v_num_interior || '",
            "NUM_EXTERIOR": "' || v_num_exterior || '",
            "CODCOLONIA": "' || v_codcolonia || '",
            "DESCRIPCION_COLONIA": "' || v_desc_colonia || '",
            "CODCORRRES": "' || v_codcorrres || '",
            "DESCRIPCION_MUNICIPIO": "' || v_desc_municipio || '",
            "CODPROVRES": "' || v_codprovres || '",
            "DESCRIPCION_ESTADO": "' || v_desc_estado || '",
            "CODPAISRES": "' || v_codpaisres || '",
            "DESCRIPCION_PAIS": "' || v_desc_pais || '",
            "CODPOSRES": "' || v_codposres || '",
            "EMAIL": "' || v_email || '",
            "TELEFONO": "' || v_telefono || '"
        }';
        IF DBMS_LOB.GETLENGTH(v_json) > 2 THEN
            DBMS_LOB.WRITEAPPEND(v_json, LENGTH(', '), ', ');
        END IF;
        DBMS_LOB.WRITEAPPEND(v_json, LENGTH(v_temp), v_temp);
    END LOOP;
    CLOSE v_resultado;
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH(' ]'), ' ]');
    RETURN v_json;
EXCEPTION
    WHEN OTHERS THEN
        RETURN '{ "error": "' || SQLERRM || '" }';
END FN_BUSCAR_ASEGURADOS;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_BUSCAR_ASEGURADOS FOR SICAS_OC.FN_BUSCAR_ASEGURADOS
/

GRANT EXECUTE ON SICAS_OC.FN_BUSCAR_ASEGURADOS TO PUBLIC
/
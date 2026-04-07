create or replace PROCEDURE SICAS_OC.WS_OBTENER_BENEFICIARIO (
    p_idpoliza       IN NUMBER,
    p_cod_asegurado  IN NUMBER,
    p_resultado      OUT SYS_REFCURSOR
) AS
BEGIN
    IF p_idpoliza IS NULL OR p_cod_asegurado IS NULL THEN
        RAISE_APPLICATION_ERROR(-20301, 'Debe proporcionar ID de póliza y código de asegurado.');
    END IF;
    OPEN p_resultado FOR
        SELECT 
            B.BENEF,
            B.NOMBRE,
            B.PORCEPART,
            B.CODPARENT,
            B.ESTADO,
            B.SEXO,
            B.FECNAC,
            B.INDIRREVOCABLE,
            NULL AS IDSINIESTRO,
            'BENEFICIARIO' AS ORIGEN
        FROM BENEFICIARIO B
        WHERE B.IDPOLIZA = p_idpoliza
          AND B.COD_ASEGURADO = p_cod_asegurado
        UNION ALL
        SELECT 
            BS.BENEF,
            BS.NOMBRE || ' ' || BS.APELLIDO_PATERNO || ' ' || BS.APELLIDO_MATERNO AS NOMBRE,
            BS.PORCEPART,
            BS.CODPARENT,
            BS.ESTADO,
            BS.SEXO,
            BS.FECNAC,
            NULL AS INDIRREVOCABLE,
            BS.IDSINIESTRO,
            'BENEF_SIN' AS ORIGEN
        FROM BENEF_SIN BS
        WHERE BS.IDPOLIZA = p_idpoliza
          AND BS.COD_ASEGURADO = p_cod_asegurado;
END WS_OBTENER_BENEFICIARIO;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_OBTENER_BENEFICIARIO FOR SICAS_OC.WS_OBTENER_BENEFICIARIO
/

GRANT EXECUTE ON SICAS_OC.WS_OBTENER_BENEFICIARIO TO PUBLIC
/
create or replace PROCEDURE SICAS_OC.WS_OBTENER_ENTIDADF (
    p_codentidad  IN NUMBER DEFAULT NULL,
    p_descentidad IN VARCHAR2 DEFAULT NULL,
    p_codcia       IN NUMBER DEFAULT NULL,
    p_codempresa   IN NUMBER DEFAULT NULL, 
    p_resultado   OUT SYS_REFCURSOR
) AS
BEGIN
    IF p_CodCia IS NULL THEN
       RAISE_APPLICATION_ERROR(-20001, 'Debe especificar el código de compañía (p_CodCia).');
    END IF;
    
    OPEN p_resultado FOR
        SELECT CodEntidad,
               CodEntidad || ' - ' || SUBSTR(OC_ENTIDAD_FINANCIERA.NOMBRE_COMERCIAL(CodCia, CodEntidad), 1, 300) AS DescEntidad
          FROM ENTIDAD_FINANCIERA
         WHERE CodCia = p_codcia
           AND (p_codentidad IS NULL OR CODENTIDAD = p_codentidad)
           AND (p_descentidad IS NULL OR UPPER(OC_ENTIDAD_FINANCIERA.NOMBRE_COMERCIAL(CodCia, CodEntidad))
                              LIKE '%' || UPPER(p_DescEntidad) || '%')
         ORDER BY CodEntidad;
END WS_OBTENER_ENTIDADF;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_OBTENER_ENTIDADF FOR SICAS_OC.WS_OBTENER_ENTIDADF
/

GRANT EXECUTE ON SICAS_OC.WS_OBTENER_ENTIDADF TO PUBLIC
/
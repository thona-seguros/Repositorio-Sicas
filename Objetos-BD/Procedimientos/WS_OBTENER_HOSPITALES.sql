create or replace PROCEDURE SICAS_OC.WS_OBTENER_HOSPITALES (
    p_codproveedor    IN VARCHAR2 DEFAULT NULL,
    p_nombre_hospital IN VARCHAR2 DEFAULT NULL,
    p_resultado       OUT SYS_REFCURSOR
) AS
BEGIN
    -- Abrir el cursor con la consulta de hospitales
    OPEN p_resultado FOR
        SELECT
            CodProveedor,
            SUBSTR(OC_PROVEEDORES.NOMBRE_PROVEEDOR(CodCia, CodProveedor),1,100) AS Hospital
        FROM PROVEEDORES
        WHERE CODCIA         = 1
          AND CLASEPROVEEDOR = 'HOSPIT'
          AND (p_codproveedor IS NULL OR CodProveedor = p_codproveedor)
          AND (p_nombre_hospital IS NULL OR UPPER(SUBSTR(OC_PROVEEDORES.NOMBRE_PROVEEDOR(CodCia, CodProveedor),1,100)) LIKE '%' || UPPER(p_nombre_hospital) || '%')
        ORDER BY Hospital ASC;
END WS_OBTENER_HOSPITALES;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_OBTENER_HOSPITALES FOR SICAS_OC.WS_OBTENER_HOSPITALES
/

GRANT EXECUTE ON SICAS_OC.WS_OBTENER_HOSPITALES TO PUBLIC
/
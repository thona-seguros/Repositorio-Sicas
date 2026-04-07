create or replace PROCEDURE SICAS_OC.WS_OBTENER_DIAGNOSTICO (
    p_nombre_concepto IN VARCHAR2 DEFAULT NULL,
    p_valor_largo     IN VARCHAR2 DEFAULT NULL,
    p_resultado       OUT SYS_REFCURSOR
) AS
BEGIN
    -- Abrir el cursor con la consulta de diagnósticos
    OPEN p_resultado FOR
        SELECT
            A.CAGE_NOM_CONCEP,
            A.CAGE_VALOR_LARGO
        FROM SAI_CAT_GENERAL A
        WHERE A.CAGE_CD_CATALOGO = 9
          AND A.CAGE_CD_ESTATUS  = 'ACT'
          AND (p_nombre_concepto IS NULL OR UPPER(A.CAGE_NOM_CONCEP) LIKE '%' || UPPER(p_nombre_concepto) || '%')
          AND (p_valor_largo IS NULL OR UPPER(A.CAGE_VALOR_LARGO) LIKE '%' || UPPER(p_valor_largo) || '%')
        ORDER BY A.CAGE_NOM_CONCEP;
END WS_OBTENER_DIAGNOSTICO;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_OBTENER_DIAGNOSTICO FOR SICAS_OC.WS_OBTENER_DIAGNOSTICO
/

GRANT EXECUTE ON SICAS_OC.WS_OBTENER_DIAGNOSTICO TO PUBLIC
/
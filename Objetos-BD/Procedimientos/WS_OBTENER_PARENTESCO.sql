create or replace PROCEDURE SICAS_OC.WS_OBTENER_PARENTESCO (
    p_CodParentesco IN NUMBER DEFAULT NULL,
    p_DescParentesco IN VARCHAR2 DEFAULT NULL,
    p_resultado     OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_resultado FOR
        SELECT CodValor || ' - ' || DescValLst AS DESCRIP,
               CodValor
          FROM VALORES_DE_LISTAS
         WHERE CodLista = 'PARENT'
           AND (p_CodParentesco IS NULL OR CodValor = p_CodParentesco)
           AND (p_DescParentesco IS NULL OR UPPER(DescValLst) LIKE '%' || UPPER(p_DescParentesco) || '%')
         ORDER BY UPPER(DescValLst);
END WS_OBTENER_PARENTESCO;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_OBTENER_PARENTESCO FOR SICAS_OC.WS_OBTENER_PARENTESCO
/

GRANT EXECUTE ON SICAS_OC.WS_OBTENER_PARENTESCO TO PUBLIC
/
CREATE OR REPLACE PACKAGE GT_REPORTE_FORMATO AS
    FUNCTION FORMATO_PRINCIPAL(nIdReporte IN NUMBER) RETURN VARCHAR2;
END GT_REPORTE_FORMATO;
/

CREATE OR REPLACE PACKAGE BODY GT_REPORTE_FORMATO AS
    FUNCTION FORMATO_PRINCIPAL(nIdReporte IN NUMBER) RETURN VARCHAR2 IS
        cFormato REPORTE_FORMATO.Formato%TYPE;
    BEGIN
        BEGIN
            SELECT Formato
              INTO cFormato
              FROM REPORTE_FORMATO
             WHERE IdReporte = nIdReporte
               AND Principal = 'S';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                cFormato := 'SF';
            WHEN TOO_MANY_ROWS THEN
                RAISE_APPLICATION_ERROR (-20100,'Reporte Con Multiples Formatos Principales, Por Favor Valide Su Configuración');
        END;
        RETURN cFormato;
    END FORMATO_PRINCIPAL;
END GT_REPORTE_FORMATO;

--
-- GT_REPORTE_FORMATO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   REPORTE_FORMATO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_REPORTE_FORMATO AS
    FUNCTION FORMATO_PRINCIPAL(nIdReporte IN NUMBER) RETURN VARCHAR2;
END GT_REPORTE_FORMATO;
/

--
-- GT_REPORTE_FORMATO  (Package Body) 
--
--  Dependencies: 
--   GT_REPORTE_FORMATO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_REPORTE_FORMATO AS
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
/

--
-- GT_REPORTE_FORMATO  (Synonym) 
--
--  Dependencies: 
--   GT_REPORTE_FORMATO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_REPORTE_FORMATO FOR SICAS_OC.GT_REPORTE_FORMATO
/


GRANT EXECUTE ON SICAS_OC.GT_REPORTE_FORMATO TO PUBLIC
/

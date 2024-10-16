--
-- OC_FACT_ELECT_CAT_CAMPOS_CFDI  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   FACT_ELECT_CAT_CAMPOS_CFDI (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_FACT_ELECT_CAT_CAMPOS_CFDI AS
    FUNCTION RUTINA_CALCULO(nCodCia NUMBER,cCodIdentificador VARCHAR2,cCodAtributo VARCHAR2) RETURN VARCHAR2;
END OC_FACT_ELECT_CAT_CAMPOS_CFDI;
/

--
-- OC_FACT_ELECT_CAT_CAMPOS_CFDI  (Package Body) 
--
--  Dependencies: 
--   OC_FACT_ELECT_CAT_CAMPOS_CFDI (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_FACT_ELECT_CAT_CAMPOS_CFDI AS
    FUNCTION RUTINA_CALCULO(nCodCia NUMBER,cCodIdentificador VARCHAR2,cCodAtributo VARCHAR2) RETURN VARCHAR2 IS
        cCodRutinaCalc FACT_ELECT_CAT_CAMPOS_CFDI.CodRutinaCalc%TYPE;
    BEGIN
        BEGIN
            SELECT CodRutinaCalc
              INTO cCodRutinaCalc
              FROM FACT_ELECT_CAT_CAMPOS_CFDI
             WHERE CodCia           = nCodCia
               AND CodIdentificador = cCodIdentificador
               AND CodAtributo      = cCodAtributo;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                cCodRutinaCalc := 'NO EXISTE';
        END;
        RETURN cCodRutinaCalc; 
    END RUTINA_CALCULO;
END OC_FACT_ELECT_CAT_CAMPOS_CFDI;
/

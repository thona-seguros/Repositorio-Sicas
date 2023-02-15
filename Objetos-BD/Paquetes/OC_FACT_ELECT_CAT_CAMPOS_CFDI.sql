CREATE OR REPLACE PACKAGE OC_FACT_ELECT_CAT_CAMPOS_CFDI AS
    FUNCTION RUTINA_CALCULO(nCodCia NUMBER,cCodIdentificador VARCHAR2,cCodAtributo VARCHAR2) RETURN VARCHAR2;
END OC_FACT_ELECT_CAT_CAMPOS_CFDI;
/

CREATE OR REPLACE PACKAGE BODY OC_FACT_ELECT_CAT_CAMPOS_CFDI AS
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

--
-- OC_FACT_ELECT_CAT_GPO_LINEA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   FACT_ELECT_CAT_GPO_LINEA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_FACT_ELECT_CAT_GPO_LINEA IS
    FUNCTION DESCRIPCION_IDENTIFICADOR(nCodCia NUMBER,cCodIdentificador VARCHAR2,cVersionCfdi VARCHAR2) RETURN VARCHAR2;
END OC_FACT_ELECT_CAT_GPO_LINEA;
/

--
-- OC_FACT_ELECT_CAT_GPO_LINEA  (Package Body) 
--
--  Dependencies: 
--   OC_FACT_ELECT_CAT_GPO_LINEA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_FACT_ELECT_CAT_GPO_LINEA IS
    FUNCTION DESCRIPCION_IDENTIFICADOR(nCodCia NUMBER,cCodIdentificador VARCHAR2,cVersionCfdi VARCHAR2) RETURN VARCHAR2 IS
        cDescIdentificador FACT_ELECT_CAT_GPO_LINEA.DescIdentificador%TYPE;
    BEGIN
        SELECT DescIdentificador
          INTO cDescIdentificador
          FROM FACT_ELECT_CAT_GPO_LINEA
         WHERE CodCia           = nCodCia
           AND CodIdentificador = cCodIdentificador
           AND VersionCfdi      = cVersionCfdi;
        RETURN cDescIdentificador;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            cDescIdentificador := 'IDENTIFICADOR DE LINEA INEXISTENTE';
            RETURN cDescIdentificador;
    END DESCRIPCION_IDENTIFICADOR;
END OC_FACT_ELECT_CAT_GPO_LINEA;
/

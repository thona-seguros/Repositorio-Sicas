--
-- OC_FACT_ELECT_CLAVE_UNIDAD  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   FACT_ELECT_CLAVE_UNIDAD (Table)
--   FACT_ELECT_PROD_SERV (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_FACT_ELECT_CLAVE_UNIDAD IS
    FUNCTION DESCRIPCION (nCodCia NUMBER, cClaveUnidad VARCHAR2) RETURN VARCHAR2;
    FUNCTION CLAVE_UNIDAD (nCodCia NUMBER, cClaveProdServ VARCHAR2) RETURN VARCHAR2;
END OC_FACT_ELECT_CLAVE_UNIDAD;
/

--
-- OC_FACT_ELECT_CLAVE_UNIDAD  (Package Body) 
--
--  Dependencies: 
--   OC_FACT_ELECT_CLAVE_UNIDAD (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_FACT_ELECT_CLAVE_UNIDAD IS
    FUNCTION DESCRIPCION (nCodCia NUMBER, cClaveUnidad VARCHAR2) RETURN VARCHAR2 IS
        cNombreClaveUnidad FACT_ELECT_CLAVE_UNIDAD.NombreClaveUnidad%TYPE;
    BEGIN
        BEGIN
            SELECT NombreClaveUnidad
              INTO cNombreClaveUnidad
              FROM FACT_ELECT_CLAVE_UNIDAD
             WHERE ClaveUnidad = cClaveUnidad
               AND IndAplicaNegocio = 'S';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                cNombreClaveUnidad := 'NO EXISTE';
        END;
        RETURN cNombreClaveUnidad;
    END DESCRIPCION;
    
    FUNCTION CLAVE_UNIDAD (nCodCia NUMBER, cClaveProdServ VARCHAR2) RETURN VARCHAR2 IS
        cClaveUnidad FACT_ELECT_CLAVE_UNIDAD.ClaveUnidad%TYPE;
    BEGIN
        BEGIN
            SELECT FC.ClaveUnidad
              INTO cClaveUnidad
              FROM FACT_ELECT_CLAVE_UNIDAD FC,FACT_ELECT_PROD_SERV FP
             WHERE FC.CodCia           = nCodCia
               AND FC.IndAplicaNegocio = 'S'
               AND FP.ClaveProdServ    = cClaveProdServ
               AND FC.CodCia           = FP.CodCia
               AND FC.ClaveUnidad      = FP.ClaveUnidad;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                cClaveUnidad := 'NO EXISTE';
        END;
        RETURN cClaveUnidad;
    END CLAVE_UNIDAD;
END OC_FACT_ELECT_CLAVE_UNIDAD;
/

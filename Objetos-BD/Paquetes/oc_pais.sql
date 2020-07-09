--
-- OC_PAIS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   PAIS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_PAIS IS

  FUNCTION NOMBRE_PAIS(cCodPais VARCHAR2) RETURN VARCHAR2;
  FUNCTION CODIGO_ALTERNATIVO(cCodPais VARCHAR2) RETURN VARCHAR2;

END OC_PAIS;
/

--
-- OC_PAIS  (Package Body) 
--
--  Dependencies: 
--   OC_PAIS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_PAIS IS

FUNCTION NOMBRE_PAIS(cCodPais VARCHAR2) RETURN VARCHAR2 IS
cDescPais    PAIS.DescPais%TYPE;
BEGIN
   BEGIN
      SELECT DescPais
        INTO cDescPais
        FROM PAIS
       WHERE CodPais   = cCodPais;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescPais  := 'PAIS NO EXISTE';
   END;
   RETURN(cDescPais);
END NOMBRE_PAIS;

FUNCTION CODIGO_ALTERNATIVO(cCodPais VARCHAR2) RETURN VARCHAR2 IS
cCodPaisAlterno    PAIS.CodPaisAlterno%TYPE;
BEGIN
   BEGIN
      SELECT CodPaisAlterno
        INTO cCodPaisAlterno
        FROM PAIS
       WHERE CodPais   = cCodPais;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodPaisAlterno  := NULL;
   END;
   RETURN(cCodPaisAlterno);
END CODIGO_ALTERNATIVO;

END OC_PAIS;
/

--
-- OC_PAIS  (Synonym) 
--
--  Dependencies: 
--   OC_PAIS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_PAIS FOR SICAS_OC.OC_PAIS
/


GRANT EXECUTE ON SICAS_OC.OC_PAIS TO PUBLIC
/

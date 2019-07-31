--
-- OC_PROVINCIA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   PROVINCIA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_PROVINCIA IS

  FUNCTION NOMBRE_PROVINCIA(cCodPais VARCHAR2, cCodEstado VARCHAR2) RETURN VARCHAR2;
  FUNCTION CODIGO_ALTERNATIVO(cCodPais VARCHAR2, cCodEstado VARCHAR2) RETURN VARCHAR2;

END OC_PROVINCIA;
/

--
-- OC_PROVINCIA  (Package Body) 
--
--  Dependencies: 
--   OC_PROVINCIA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_PROVINCIA IS

FUNCTION NOMBRE_PROVINCIA(cCodPais VARCHAR2, cCodEstado VARCHAR2) RETURN VARCHAR2 IS
cDescEstado    PROVINCIA.DescEstado%TYPE;
BEGIN
   BEGIN
      SELECT DescEstado
        INTO cDescEstado
        FROM PROVINCIA
       WHERE CodPais   = cCodPais
         AND CodEstado = cCodEstado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescEstado  := 'PROVINCIA NO EXISTE';
   END;
   RETURN(cDescEstado);
END NOMBRE_PROVINCIA;

FUNCTION CODIGO_ALTERNATIVO(cCodPais VARCHAR2, cCodEstado VARCHAR2) RETURN VARCHAR2 IS
cCodProvAlterno    PROVINCIA.CodProvAlterno%TYPE;
BEGIN
   BEGIN
      SELECT CodProvAlterno
        INTO cCodProvAlterno
        FROM PROVINCIA
       WHERE CodPais   = cCodPais
         AND CodEstado = cCodEstado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodProvAlterno  := '999';
   END;
   RETURN(cCodProvAlterno);
END CODIGO_ALTERNATIVO;

END OC_PROVINCIA;
/

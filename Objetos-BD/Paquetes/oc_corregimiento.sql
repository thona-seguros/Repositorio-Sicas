--
-- OC_CORREGIMIENTO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   CORREGIMIENTO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.oc_corregimiento IS

  FUNCTION NOMBRE_CORREGIMIENTO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2, cCodMunicipio VARCHAR2) RETURN VARCHAR2;
  FUNCTION CODIGO_ALTERNATIVO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2, cCodMunicipio VARCHAR2) RETURN VARCHAR2;

END OC_CORREGIMIENTO;
/

--
-- OC_CORREGIMIENTO  (Package Body) 
--
--  Dependencies: 
--   OC_CORREGIMIENTO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.oc_corregimiento IS

FUNCTION NOMBRE_CORREGIMIENTO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2, cCodMunicipio VARCHAR2) RETURN VARCHAR2 IS
cDescMunicipio    CORREGIMIENTO.DescMunicipio%TYPE;
BEGIN
   BEGIN
      SELECT DescMunicipio
        INTO cDescMunicipio
        FROM CORREGIMIENTO
       WHERE CodPais      = cCodPais
         AND CodEstado    = cCodEstado
         AND CodCiudad    = cCodCiudad
         AND CodMunicipio = cCodMunicipio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescMunicipio  := 'CORREGIMIENTO NO EXISTE';
   END;
   RETURN(cDescMunicipio);
END NOMBRE_CORREGIMIENTO;

FUNCTION CODIGO_ALTERNATIVO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2, cCodMunicipio VARCHAR2) RETURN VARCHAR2 IS
cCodCorregAlterno    CORREGIMIENTO.CodCorregAlterno%TYPE;
BEGIN
   BEGIN
      SELECT CodCorregAlterno
        INTO cCodCorregAlterno
        FROM CORREGIMIENTO
       WHERE CodPais      = cCodPais
         AND CodEstado    = cCodEstado
         AND CodCiudad    = cCodCiudad
         AND CodMunicipio = cCodMunicipio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodCorregAlterno  := NULL;
   END;
   RETURN(cCodCorregAlterno);
END CODIGO_ALTERNATIVO;

END OC_CORREGIMIENTO;
/

--
-- OC_CORREGIMIENTO  (Synonym) 
--
--  Dependencies: 
--   OC_CORREGIMIENTO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_CORREGIMIENTO FOR SICAS_OC.OC_CORREGIMIENTO
/


GRANT EXECUTE ON SICAS_OC.OC_CORREGIMIENTO TO PUBLIC
/

CREATE OR REPLACE PACKAGE oc_corregimiento IS

  FUNCTION NOMBRE_CORREGIMIENTO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2, cCodMunicipio VARCHAR2) RETURN VARCHAR2;
  FUNCTION CODIGO_ALTERNATIVO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2, cCodMunicipio VARCHAR2) RETURN VARCHAR2;

END OC_CORREGIMIENTO;
 
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY oc_corregimiento IS

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

CREATE OR REPLACE PACKAGE OC_MUNICIPIO IS
--  MODIFICACION
--  14/01/2021 SE CREO  -- JICO 
  FUNCTION NOMBRE_MUNICIPIO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodMunicipio VARCHAR2) RETURN VARCHAR2;
  FUNCTION CODIGO_ALTERNATIVO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodMunicipio VARCHAR2) RETURN VARCHAR2;

END OC_MUNICIPIO;
 
 
 
 
 
/
CREATE OR REPLACE PACKAGE BODY OC_MUNICIPIO IS

FUNCTION NOMBRE_MUNICIPIO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodMunicipio VARCHAR2) RETURN VARCHAR2 IS
cDescMunicipio    CORREGIMIENTO.DescMunicipio%TYPE;
BEGIN
   BEGIN
      SELECT DescMunicipio
        INTO cDescMunicipio
        FROM CORREGIMIENTO
       WHERE CodPais      = cCodPais
         AND CodEstado    = cCodEstado
         AND CodMunicipio = cCodMunicipio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescMunicipio  := 'MUNICIPIO NO EXISTE';
   END;
   RETURN(cDescMunicipio);
END NOMBRE_MUNICIPIO;

FUNCTION CODIGO_ALTERNATIVO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodMunicipio VARCHAR2) RETURN VARCHAR2 IS
cCodCorregAlterno    CORREGIMIENTO.CodCorregAlterno%TYPE;
BEGIN
   BEGIN
      SELECT CodCorregAlterno
        INTO cCodCorregAlterno
        FROM CORREGIMIENTO
       WHERE CodPais      = cCodPais
         AND CodEstado    = cCodEstado
         AND CodMunicipio = cCodMunicipio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodCorregAlterno  := NULL;
   END;
   RETURN(cCodCorregAlterno);
END CODIGO_ALTERNATIVO;

END OC_MUNICIPIO;
/

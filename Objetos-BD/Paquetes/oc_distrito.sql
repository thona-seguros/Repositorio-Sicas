--
-- OC_DISTRITO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DISTRITO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_DISTRITO IS

  FUNCTION NOMBRE_DISTRITO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2) RETURN VARCHAR2;
  FUNCTION CODIGO_ALTERNATIVO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2) RETURN VARCHAR2;
  FUNCTION ZONA_GEOGRAFICA(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2) RETURN VARCHAR2;

END OC_DISTRITO;
/

--
-- OC_DISTRITO  (Package Body) 
--
--  Dependencies: 
--   OC_DISTRITO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.oc_distrito IS

FUNCTION NOMBRE_DISTRITO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2) RETURN VARCHAR2 IS
cDescCiudad    DISTRITO.DescCiudad%TYPE;
BEGIN
   BEGIN
      SELECT DescCiudad
        INTO cDescCiudad
        FROM DISTRITO
       WHERE CodPais   = cCodPais
         AND CodEstado = cCodEstado
                        AND CodCiudad = cCodCiudad;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescCiudad  := 'DISTRITO NO EXISTE';
   END;
   RETURN(cDescCiudad);
END NOMBRE_DISTRITO;

FUNCTION CODIGO_ALTERNATIVO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2) RETURN VARCHAR2 IS
cCodDistritoAlterno    DISTRITO.CodDistritoAlterno%TYPE;
BEGIN
   BEGIN
      SELECT CodDistritoAlterno
        INTO cCodDistritoAlterno
        FROM DISTRITO
       WHERE CodPais   = cCodPais
         AND CodEstado = cCodEstado
                        AND CodCiudad = cCodCiudad;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodDistritoAlterno  := NULL;
   END;
   RETURN(cCodDistritoAlterno);
END CODIGO_ALTERNATIVO;

FUNCTION ZONA_GEOGRAFICA(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2) RETURN VARCHAR2 IS
cCodZonaGeo    DISTRITO.CodZonaGeo%TYPE;
BEGIN
   BEGIN
      SELECT CodZonaGeo
        INTO cCodZonaGeo
        FROM DISTRITO
       WHERE CodPais   = cCodPais
         AND CodEstado = cCodEstado
         AND CodCiudad = cCodCiudad;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodZonaGeo  := NULL;
   END;
   RETURN(cCodZonaGeo);
END ZONA_GEOGRAFICA;

END OC_DISTRITO;
/

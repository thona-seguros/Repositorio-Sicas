CREATE OR REPLACE PACKAGE OC_DISTRITO IS
--
-- MODIFICACIONES  
-- 07/03/2023 Se agrega funcion BUSCA_DESC_CNSF y ES_CIUDAD_ALTO_RIESGO JICO                                                                          |
-- 
FUNCTION NOMBRE_DISTRITO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2) RETURN VARCHAR2;

FUNCTION CODIGO_ALTERNATIVO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2) RETURN VARCHAR2;

FUNCTION ZONA_GEOGRAFICA(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2) RETURN VARCHAR2;

FUNCTION BUSCA_CLAVE_CNSF(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2) RETURN VARCHAR2;

FUNCTION ES_CIUDAD_ALTO_RIESGO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2) RETURN VARCHAR2;

END OC_DISTRITO;
 
 
 
 
/
CREATE OR REPLACE PACKAGE BODY oc_distrito IS

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

FUNCTION BUSCA_CLAVE_CNSF(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2) RETURN VARCHAR2 IS
cCLAVE_CNSF    DISTRITO.CVE_CNSF%TYPE;
BEGIN
   BEGIN
      SELECT CVE_CNSF
        INTO cCLAVE_CNSF
        FROM DISTRITO
       WHERE CodPais   = cCodPais
         AND CodEstado = cCodEstado
         AND CodCiudad = cCodCiudad;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCLAVE_CNSF  := NULL;
   END;
   RETURN(cCLAVE_CNSF);
END BUSCA_CLAVE_CNSF;

FUNCTION ES_CIUDAD_ALTO_RIESGO(cCodPais VARCHAR2, cCodEstado VARCHAR2, cCodCiudad VARCHAR2) RETURN VARCHAR2 IS
CES_CIUDAD_ALTORIESGO     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO CES_CIUDAD_ALTORIESGO
        FROM DISTRITO D
       WHERE CodPais      = cCodPais
         AND CodEstado    = cCodEstado
         AND CodCiudad    = cCodCiudad
         AND D.TIPORIESGO = 'ALTO';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         CES_CIUDAD_ALTORIESGO := 'N';
      WHEN TOO_MANY_ROWS THEN
         CES_CIUDAD_ALTORIESGO := 'S';
   END;
   
   RETURN(CES_CIUDAD_ALTORIESGO);
END ES_CIUDAD_ALTO_RIESGO;

END OC_DISTRITO;
/

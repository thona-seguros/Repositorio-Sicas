CREATE OR REPLACE PACKAGE OC_FACTOR_ZONA_GEOGRAFICA IS

  FUNCTION FACTOR_ZONA(cCodZonaGeo VARCHAR2, dFecFactor DATE) RETURN NUMBER;

END OC_FACTOR_ZONA_GEOGRAFICA;
/

CREATE OR REPLACE PACKAGE BODY OC_FACTOR_ZONA_GEOGRAFICA IS

FUNCTION FACTOR_ZONA(cCodZonaGeo VARCHAR2, dFecFactor DATE) RETURN NUMBER IS
nFactorZona    FACTOR_ZONA_GEOGRAFICA.FactorZona%TYPE;
BEGIN
   BEGIN
      SELECT FactorZona
        INTO nFactorZona
        FROM FACTOR_ZONA_GEOGRAFICA
       WHERE CodZonaGeo    = cCodZonaGeo
         AND FecIniVig    >= dFecFactor
         AND FecIniVig    <= dFecFactor;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFactorZona := 0;
   END;
   RETURN(nFactorZona);
END FACTOR_ZONA;

END OC_FACTOR_ZONA_GEOGRAFICA;
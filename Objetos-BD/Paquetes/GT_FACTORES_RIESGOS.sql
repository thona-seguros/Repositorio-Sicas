CREATE OR REPLACE PACKAGE GT_FACTORES_RIESGOS IS

  FUNCTION FACTOR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                  cPlanCob VARCHAR2, cRiesgoTarifa VARCHAR2, dFecFactor DATE) RETURN NUMBER;

END GT_FACTORES_RIESGOS;
/
CREATE OR REPLACE PACKAGE BODY GT_FACTORES_RIESGOS IS

FUNCTION FACTOR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                cPlanCob VARCHAR2, cRiesgoTarifa VARCHAR2, dFecFactor DATE) RETURN NUMBER IS
nFactorRiesgo    FACTORES_RIESGOS.FactorRiesgo%TYPE;
BEGIN
   BEGIN
      SELECT FactorRiesgo
        INTO nFactorRiesgo
        FROM FACTORES_RIESGOS
       WHERE CodCia           = nCodCia
         AND CodEmpresa       = nCodEmpresa
         AND IdTipoSeg        = cIdTipoSeg
         AND PlanCob          = cPlanCob
         AND dFecFactor BETWEEN FecIniVig AND FecFinVig
         --AND FecIniVig    >= dFecFactor
         --AND FecFinVig    <= dFecFactor
         AND RiesgoTarifa     = cRiesgoTarifa;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFactorRiesgo := 0;
   END;
   RETURN(nFactorRiesgo);
END FACTOR;

END GT_FACTORES_RIESGOS;

-------PERMISOS
 
GRANT EXECUTE ON SICAS_OC.GT_FACTORES_RIESGOS TO PUBLIC;
/
  --SINONIMO
CREATE OR REPLACE PUBLIC SYNONYM GT_FACTORES_RIESGOS FOR SICAS_OC.GT_FACTORES_RIESGOS;
/
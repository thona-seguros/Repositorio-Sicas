CREATE OR REPLACE PACKAGE OC_GASTO_USUAL_ACOSTUMBRADO IS

  FUNCTION FACTOR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                  cPlanCob VARCHAR2, nPorcentajeGUA NUMBER, dFecFactor DATE) RETURN NUMBER;

  PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                   cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);

END OC_GASTO_USUAL_ACOSTUMBRADO;
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_GASTO_USUAL_ACOSTUMBRADO IS

FUNCTION FACTOR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                cPlanCob VARCHAR2, nPorcentajeGUA NUMBER, dFecFactor DATE) RETURN NUMBER IS
nFactorGUA    GASTO_USUAL_ACOSTUMBRADO.FactorGUA%TYPE;
BEGIN
   BEGIN
      SELECT FactorGUA
        INTO nFactorGUA
        FROM GASTO_USUAL_ACOSTUMBRADO
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdTipoSeg     = cIdTipoSeg
         AND PlanCob       = cPlanCob
         AND FecIniVig    >= dFecFactor
         AND FecFinVig    <= dFecFactor
         AND PorcentajeGUA = nPorcentajeGUA;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFactorGUA := 0;
   END;
   RETURN(nFactorGUA);
END FACTOR;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2) IS
CURSOR GUA_Q IS
  SELECT FecIniVig, FecFinVig, PorcentajeGUA, FactorGUA
    FROM GASTO_USUAL_ACOSTUMBRADO
   WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdTipoSeg  = cIdTipoSegOrig
     AND PlanCob    = cPlanCobOrig;
BEGIN
   FOR X IN GUA_Q LOOP
      INSERT INTO GASTO_USUAL_ACOSTUMBRADO
             (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, 
              FecFinVig, PorcentajeGUA, FactorGUA)
      VALUES (nCodCia, nCodEmpresa, cIdTipoSegDest, cPlanCobDest, X.FecIniVig,
              X.FecFinVig, X.PorcentajeGUA, X.FactorGUA);
   END LOOP;
END COPIAR;

END OC_GASTO_USUAL_ACOSTUMBRADO;

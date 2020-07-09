--
-- OC_GASTO_USUAL_ACOSTUMBRADO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   GASTO_USUAL_ACOSTUMBRADO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_GASTO_USUAL_ACOSTUMBRADO IS

  FUNCTION FACTOR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                  cPlanCob VARCHAR2, nPorcentajeGUA NUMBER, dFecFactor DATE) RETURN NUMBER;

  PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                   cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);

END OC_GASTO_USUAL_ACOSTUMBRADO;
/

--
-- OC_GASTO_USUAL_ACOSTUMBRADO  (Package Body) 
--
--  Dependencies: 
--   OC_GASTO_USUAL_ACOSTUMBRADO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_GASTO_USUAL_ACOSTUMBRADO IS

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
/

--
-- OC_GASTO_USUAL_ACOSTUMBRADO  (Synonym) 
--
--  Dependencies: 
--   OC_GASTO_USUAL_ACOSTUMBRADO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_GASTO_USUAL_ACOSTUMBRADO FOR SICAS_OC.OC_GASTO_USUAL_ACOSTUMBRADO
/


GRANT EXECUTE ON SICAS_OC.OC_GASTO_USUAL_ACOSTUMBRADO TO PUBLIC
/

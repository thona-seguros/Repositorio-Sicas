--
-- OC_FACTOR_DEDUCIBLE  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   FACTOR_DEDUCIBLE (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_FACTOR_DEDUCIBLE IS

  FUNCTION FACTOR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                  cPlanCob VARCHAR2, nMontoDeducible NUMBER, dFecFactor DATE) RETURN NUMBER;

  PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                   cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);

END OC_FACTOR_DEDUCIBLE;
/

--
-- OC_FACTOR_DEDUCIBLE  (Package Body) 
--
--  Dependencies: 
--   OC_FACTOR_DEDUCIBLE (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_FACTOR_DEDUCIBLE IS

FUNCTION FACTOR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                cPlanCob VARCHAR2, nMontoDeducible NUMBER, dFecFactor DATE) RETURN NUMBER IS
nFactorDeducible    FACTOR_DEDUCIBLE.FactorDeducible%TYPE;
BEGIN
   BEGIN
      SELECT FactorDeducible
        INTO nFactorDeducible
        FROM FACTOR_DEDUCIBLE
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdTipoSeg      = cIdTipoSeg
         AND PlanCob        = cPlanCob
         AND FecIniVig     >= dFecFactor
         AND FecFinVig     <= dFecFactor
         AND MontoDeducible = nMontoDeducible;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFactorDeducible := 0;
   END;
   RETURN(nFactorDeducible);
END FACTOR;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2) IS
CURSOR GUA_Q IS
  SELECT FecIniVig, FecFinVig, MontoDeducible, FactorDeducible
    FROM FACTOR_DEDUCIBLE
   WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdTipoSeg  = cIdTipoSegOrig
     AND PlanCob    = cPlanCobOrig;
BEGIN
   FOR X IN GUA_Q LOOP
      INSERT INTO FACTOR_DEDUCIBLE
             (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, 
              FecFinVig, MontoDeducible, FactorDeducible)
      VALUES (nCodCia, nCodEmpresa, cIdTipoSegDest, cPlanCobDest, X.FecIniVig,
              X.FecFinVig, X.MontoDeducible, X.FactorDeducible);
   END LOOP;
END COPIAR;

END OC_FACTOR_DEDUCIBLE;
/

--
-- OC_FACTOR_DEDUCIBLE  (Synonym) 
--
--  Dependencies: 
--   OC_FACTOR_DEDUCIBLE (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_FACTOR_DEDUCIBLE FOR SICAS_OC.OC_FACTOR_DEDUCIBLE
/


GRANT EXECUTE ON SICAS_OC.OC_FACTOR_DEDUCIBLE TO PUBLIC
/

--
-- OC_FACTOR_SUMA_ASEGURADA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   FACTOR_SUMA_ASEGURADA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_FACTOR_SUMA_ASEGURADA IS

  FUNCTION FACTOR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                  cPlanCob VARCHAR2, nMontoSumaAseg NUMBER, dFecFactor DATE) RETURN NUMBER;

  PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                   cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);

END OC_FACTOR_SUMA_ASEGURADA;
/

--
-- OC_FACTOR_SUMA_ASEGURADA  (Package Body) 
--
--  Dependencies: 
--   OC_FACTOR_SUMA_ASEGURADA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_FACTOR_SUMA_ASEGURADA IS

FUNCTION FACTOR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                cPlanCob VARCHAR2, nMontoSumaAseg NUMBER, dFecFactor DATE) RETURN NUMBER IS
nFactorSumaAseg    FACTOR_SUMA_ASEGURADA.FactorSumaAseg%TYPE;
BEGIN
   BEGIN
      SELECT FactorSumaAseg
        INTO nFactorSumaAseg
        FROM FACTOR_SUMA_ASEGURADA
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdTipoSeg      = cIdTipoSeg
         AND PlanCob        = cPlanCob
         AND FecIniVig     >= dFecFactor
         AND FecFinVig     <= dFecFactor
         AND MontoSumaAseg  = nMontoSumaAseg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFactorSumaAseg := 0;
   END;
   RETURN(nFactorSumaAseg);
END FACTOR;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2) IS
CURSOR GUA_Q IS
  SELECT FecIniVig, FecFinVig, MontoSumaAseg, FactorSumaAseg
    FROM FACTOR_SUMA_ASEGURADA
   WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdTipoSeg  = cIdTipoSegOrig
     AND PlanCob    = cPlanCobOrig;
BEGIN
   FOR X IN GUA_Q LOOP
      INSERT INTO FACTOR_SUMA_ASEGURADA
             (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, 
              FecFinVig, MontoSumaAseg, FactorSumaAseg)
      VALUES (nCodCia, nCodEmpresa, cIdTipoSegDest, cPlanCobDest, X.FecIniVig,
              X.FecFinVig, X.MontoSumaAseg, X.FactorSumaAseg);
   END LOOP;
END COPIAR;

END OC_FACTOR_SUMA_ASEGURADA;
/

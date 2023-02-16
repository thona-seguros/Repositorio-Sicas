CREATE OR REPLACE PACKAGE OC_FACTOR_COASEGURO IS

  FUNCTION FACTOR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                  cPlanCob VARCHAR2, nPorcenCoaseguro NUMBER, dFecFactor DATE) RETURN NUMBER;

  PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                   cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);

END OC_FACTOR_COASEGURO;
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_FACTOR_COASEGURO IS

FUNCTION FACTOR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                cPlanCob VARCHAR2, nPorcenCoaseguro NUMBER, dFecFactor DATE) RETURN NUMBER IS
nFactorCoaseguro    FACTOR_COASEGURO.FactorCoaseguro%TYPE;
BEGIN
   BEGIN
      SELECT FactorCoaseguro
        INTO nFactorCoaseguro
        FROM FACTOR_COASEGURO
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND IdTipoSeg       = cIdTipoSeg
         AND PlanCob         = cPlanCob
         AND FecIniVig      >= dFecFactor
         AND FecFinVig      <= dFecFactor
         AND PorcenCoaseguro = nPorcenCoaseguro;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFactorCoaseguro := 0;
   END;
   RETURN(nFactorCoaseguro);
END FACTOR;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2) IS
CURSOR GUA_Q IS
  SELECT FecIniVig, FecFinVig, PorcenCoaseguro, FactorCoaseguro
    FROM FACTOR_COASEGURO
   WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdTipoSeg  = cIdTipoSegOrig
     AND PlanCob    = cPlanCobOrig;
BEGIN
   FOR X IN GUA_Q LOOP
      INSERT INTO FACTOR_COASEGURO
             (CodCia, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, 
              FecFinVig, PorcenCoaseguro, FactorCoaseguro)
      VALUES (nCodCia, nCodEmpresa, cIdTipoSegDest, cPlanCobDest, X.FecIniVig,
              X.FecFinVig, X.PorcenCoaseguro, X.FactorCoaseguro);
   END LOOP;
END COPIAR;

END OC_FACTOR_COASEGURO;

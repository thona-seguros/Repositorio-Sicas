CREATE OR REPLACE PACKAGE OC_NIVEL_PLAN_COBERTURA IS

  PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                   cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);
END OC_NIVEL_PLAN_COBERTURA;
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_NIVEL_PLAN_COBERTURA IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2) IS
CURSOR NIVEL_Q IS
  SELECT CodNivel, ComAgeNivel, Origen
    FROM NIVEL_PLAN_COBERTURA
   WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdTipoSeg  = cIdTipoSegOrig
     AND PlanCob    = cPlanCobOrig;
BEGIN
   FOR X IN NIVEL_Q LOOP
      INSERT INTO NIVEL_PLAN_COBERTURA
             (CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodNivel, ComAgeNivel, Origen)
      VALUES (nCodCia, nCodEmpresa, cIdTipoSegDest, cPlanCobDest, X.CodNivel, X.ComAgeNivel, X.Origen);
   END LOOP;
END COPIAR;

END OC_NIVEL_PLAN_COBERTURA;

--
-- OC_NIVEL_PLAN_COBERTURA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   NIVEL_PLAN_COBERTURA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_NIVEL_PLAN_COBERTURA IS

  PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                   cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);
END OC_NIVEL_PLAN_COBERTURA;
/

--
-- OC_NIVEL_PLAN_COBERTURA  (Package Body) 
--
--  Dependencies: 
--   OC_NIVEL_PLAN_COBERTURA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_NIVEL_PLAN_COBERTURA IS

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
/

--
-- OC_NIVEL_PLAN_COBERTURA  (Synonym) 
--
--  Dependencies: 
--   OC_NIVEL_PLAN_COBERTURA (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_NIVEL_PLAN_COBERTURA FOR SICAS_OC.OC_NIVEL_PLAN_COBERTURA
/


GRANT EXECUTE ON SICAS_OC.OC_NIVEL_PLAN_COBERTURA TO PUBLIC
/

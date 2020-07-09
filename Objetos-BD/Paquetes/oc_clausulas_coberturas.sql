--
-- OC_CLAUSULAS_COBERTURAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   CLAUSULAS_COBERTURAS (Table)
--   OC_CLAUSULAS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.oc_clausulas_coberturas IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                   cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);

FUNCTION EXISTEN_OBLIGATORIAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2;

END OC_CLAUSULAS_COBERTURAS;
/

--
-- OC_CLAUSULAS_COBERTURAS  (Package Body) 
--
--  Dependencies: 
--   OC_CLAUSULAS_COBERTURAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.oc_clausulas_coberturas IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                   cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2) IS
CURSOR CLAU_Q IS
  SELECT CodCobert, CodClausula
    FROM CLAUSULAS_COBERTURAS
   WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdTipoSeg  = cIdTipoSegOrig
     AND PlanCob    = cPlanCobOrig;
BEGIN
   FOR X IN CLAU_Q LOOP
      INSERT INTO CLAUSULAS_COBERTURAS
             (CodCia, CodEmpresa, IdTipoSeg, PlanCob,
              CodCobert, CodClausula)
      VALUES (nCodCia, nCodEmpresa, cIdTipoSegDest, cPlanCobDest,
              X.CodCobert, X.CodClausula);

   END LOOP;
END COPIAR;

FUNCTION EXISTEN_OBLIGATORIAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM CLAUSULAS_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob
         AND OC_CLAUSULAS.OBLIGATORIA(CodCia, CodEmpresa, CodClausula) = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTEN_OBLIGATORIAS;

END OC_CLAUSULAS_COBERTURAS;
/

--
-- OC_CLAUSULAS_COBERTURAS  (Synonym) 
--
--  Dependencies: 
--   OC_CLAUSULAS_COBERTURAS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_CLAUSULAS_COBERTURAS FOR SICAS_OC.OC_CLAUSULAS_COBERTURAS
/


GRANT EXECUTE ON SICAS_OC.OC_CLAUSULAS_COBERTURAS TO PUBLIC
/

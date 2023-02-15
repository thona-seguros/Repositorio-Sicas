CREATE OR REPLACE PACKAGE GT_COBERTURAS_EXCLUYENTES IS

FUNCTION TIENE_COBERTURAS_EXCLUYENTES(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                      cPlanCob VARCHAR2, cCodCobert VARCHAR2) RETURN VARCHAR2;
FUNCTION ES_COBERTURA_EXCLUYENTE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                 cPlanCob VARCHAR2, cCodCobert VARCHAR2, cCodCobertExclu VARCHAR2) RETURN VARCHAR2;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);

END GT_COBERTURAS_EXCLUYENTES;
/

CREATE OR REPLACE PACKAGE BODY GT_COBERTURAS_EXCLUYENTES IS

FUNCTION TIENE_COBERTURAS_EXCLUYENTES(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                      cPlanCob VARCHAR2, cCodCobert VARCHAR2) RETURN VARCHAR2 IS
cExiste      VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM COBERTURAS_EXCLUYENTES
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob
         AND CodCobert  = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END TIENE_COBERTURAS_EXCLUYENTES;

FUNCTION ES_COBERTURA_EXCLUYENTE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                 cPlanCob VARCHAR2, cCodCobert VARCHAR2, cCodCobertExclu VARCHAR2) RETURN VARCHAR2 IS
cEsCobertExclu      VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cEsCobertExclu
        FROM COBERTURAS_EXCLUYENTES
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdTipoSeg      = cIdTipoSeg
         AND PlanCob        = cPlanCob
         AND CodCobert      = cCodCobert
         AND CodCobertExclu = cCodCobertExclu;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cEsCobertExclu := 'N';
      WHEN TOO_MANY_ROWS THEN
         cEsCobertExclu := 'S';
   END;
   RETURN(cEsCobertExclu);
END ES_COBERTURA_EXCLUYENTE;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2) IS
CURSOR COB_Q IS
   SELECT CodCobert, CodCobertExclu
     FROM COBERTURAS_EXCLUYENTES
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdTipoSeg  = cIdTipoSegOrig
      AND PlanCob    = cPlanCobOrig;
BEGIN
   FOR X IN COB_Q LOOP
      INSERT INTO COBERTURAS_EXCLUYENTES
             (CodCia, CodEmpresa, IdTipoSeg, PlanCob, 
              CodCobert, CodCobertExclu)
      VALUES (nCodCia, nCodEmpresa, cIdTipoSegDest, cPlanCobDest, 
              X.CodCobert, X.CodCobertExclu);
   END LOOP;
END COPIAR;

END GT_COBERTURAS_EXCLUYENTES;

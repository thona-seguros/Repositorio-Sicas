CREATE OR REPLACE PACKAGE oc_texto_cobertura IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                  cPlanCob VARCHAR2, cCodCobert VARCHAR2, nCorrTexto NUMBER);

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                 cPlanCob VARCHAR2, cCodCobert VARCHAR2, nCorrTexto NUMBER);

FUNCTION TEXTO_DE_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                            cPlanCob VARCHAR2, cCodCobert VARCHAR2) RETURN VARCHAR2;

END OC_TEXTO_COBERTURA;
 
/

CREATE OR REPLACE PACKAGE BODY oc_texto_cobertura IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                   cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2) IS
CURSOR TXT_Q IS
  SELECT CodCobert, CorrTexto, Texto, Estado, FechaVigenteDesde
    FROM TEXTO_COBERTURA
   WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdTipoSeg  = cIdTipoSegOrig
     AND PlanCob    = cPlanCobOrig;
BEGIN
   FOR X IN TXT_Q LOOP
      INSERT INTO TEXTO_COBERTURA
             (CodCia, CodEmpresa, IdTipoSeg, PlanCob,
              CodCobert, CorrTexto, Texto, Estado, FechaVigenteDesde)
      VALUES (nCodCia, nCodEmpresa, cIdTipoSegDest, cPlanCobDest,
              X.CodCobert, X.CorrTexto, X.Texto, X.Estado, X.FechaVigenteDesde);
   END LOOP;
END COPIAR;

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                  cPlanCob VARCHAR2, cCodCobert VARCHAR2, nCorrTexto NUMBER) IS
BEGIN
   UPDATE TEXTO_COBERTURA
      SET Estado            = 'ACTIVO',
          FechaVigenteDesde = SYSDATE
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa         
      AND IdTipoSeg  = cIdTipoSeg
      AND PlanCob    = cPlanCob
      AND CodCobert  = cCodCobert
      AND CorrTexto  = nCorrTexto;
END ACTIVAR;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                  cPlanCob VARCHAR2, cCodCobert VARCHAR2, nCorrTexto NUMBER) IS
BEGIN
   UPDATE TEXTO_COBERTURA
      SET Estado     = 'ANULAD'
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa         
      AND IdTipoSeg  = cIdTipoSeg
      AND PlanCob    = cPlanCob
      AND CodCobert  = cCodCobert
      AND CorrTexto  = nCorrTexto;
END ANULAR;

FUNCTION TEXTO_DE_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                            cPlanCob VARCHAR2, cCodCobert VARCHAR2) RETURN VARCHAR2 IS
cTexto    TEXTO_COBERTURA.Texto%TYPE;
BEGIN
   BEGIN
      SELECT Texto
        INTO cTexto
        FROM TEXTO_COBERTURA
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa         
         AND IdTipoSeg   = cIdTipoSeg
         AND PlanCob     = cPlanCob
         AND CodCobert   = cCodCobert
         AND CorrTexto  IN (SELECT MAX(CorrTexto)
                              FROM TEXTO_COBERTURA
                             WHERE CodCia      = nCodCia
                               AND CodEmpresa  = nCodEmpresa           
                               AND IdTipoSeg   = cIdTipoSeg
                               AND PlanCob     = cPlanCob
                               AND CodCobert   = cCodCobert
                               AND Estado      = 'ACTIVO');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTexto := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Textos para Cobertura: ' || cCodCobert);
   END;
   RETURN(cTexto);
END TEXTO_DE_COBERTURA;

END OC_TEXTO_COBERTURA;

CREATE OR REPLACE PACKAGE GT_REA_ESQUEMAS_CONTRATOS IS
  PROCEDURE ACTIVAR_CONTRATOS(nCodCia NUMBER, cCodEsquema VARCHAR2);
  PROCEDURE SUSPENDER_CONTRATOS(nCodCia NUMBER, cCodEsquema VARCHAR2);
  PROCEDURE CONFIGURAR_CONTRATOS(nCodCia NUMBER, cCodEsquema VARCHAR2);
  PROCEDURE COPIAR_CONTRATOS(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2);
END GT_REA_ESQUEMAS_CONTRATOS;
/

CREATE OR REPLACE PACKAGE BODY GT_REA_ESQUEMAS_CONTRATOS IS

PROCEDURE ACTIVAR_CONTRATOS(nCodCia NUMBER, cCodEsquema VARCHAR2) IS
BEGIN
   UPDATE REA_ESQUEMAS_CONTRATOS
      SET StsEsqContrato  = 'ACTIVO',
          FecStatus       = TRUNC(SYSDATE)
    WHERE CodCia          = nCodCia
      AND CodEsquema      = cCodEsquema
      AND StsEsqContrato IN ('CONFIG','SUSPEN');
END ACTIVAR_CONTRATOS;

PROCEDURE SUSPENDER_CONTRATOS(nCodCia NUMBER, cCodEsquema VARCHAR2) IS
BEGIN
   UPDATE REA_ESQUEMAS_CONTRATOS
      SET StsEsqContrato = 'SUSPEN',
          FecStatus      = TRUNC(SYSDATE)
    WHERE CodCia         = nCodCia
      AND CodEsquema     = cCodEsquema
      AND StsEsqContrato = 'ACTIVO';
END SUSPENDER_CONTRATOS;

PROCEDURE CONFIGURAR_CONTRATOS(nCodCia NUMBER, cCodEsquema VARCHAR2) IS
BEGIN
   UPDATE REA_ESQUEMAS_CONTRATOS
      SET StsEsqContrato = 'CONFIG',
          FecStatus      = TRUNC(SYSDATE)
    WHERE CodCia         = nCodCia
      AND CodEsquema     = cCodEsquema
      AND StsEsqContrato = 'ACTIVO';
END CONFIGURAR_CONTRATOS;

PROCEDURE COPIAR_CONTRATOS(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2) IS
CURSOR CONT_Q IS
   SELECT IdEsqContrato, CodContrato, CodRiesgo, CodMoneda, FecVigInicial, FecVigFinal,
          NumSerie, IndTraspCartera, CodMonedaLiq, RutinaCalcEspecial, Observaciones,
          StsEsqContrato, FecStatus, CodTarifaReaseg
     FROM REA_ESQUEMAS_CONTRATOS
    WHERE CodCia     = nCodCia
      AND CodEsquema = cCodEsquemaOrig;
BEGIN
   FOR W IN CONT_Q LOOP
      INSERT INTO REA_ESQUEMAS_CONTRATOS
             (CodCia, CodEsquema, IdEsqContrato, CodContrato, CodRiesgo, CodMoneda, 
              FecVigInicial, FecVigFinal, NumSerie, IndTraspCartera, CodMonedaLiq, 
              RutinaCalcEspecial, Observaciones, StsEsqContrato, FecStatus, CodTarifaReaseg)
      VALUES (nCodCia, cCodEsquemaDest, W.IdEsqContrato, W.CodContrato, W.CodRiesgo, W.CodMoneda, 
              W.FecVigInicial, W.FecVigFinal, W.NumSerie, W.IndTraspCartera, W.CodMonedaLiq, 
              W.RutinaCalcEspecial, W.Observaciones, 'ACTIVO', TRUNC(SYSDATE), W.CodTarifaReaseg);
   END LOOP;
END COPIAR_CONTRATOS;

END GT_REA_ESQUEMAS_CONTRATOS;

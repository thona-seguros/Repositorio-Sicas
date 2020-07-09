--
-- GT_REA_ESQUEMAS_CAPAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   REA_ESQUEMAS_CAPAS (Table)
--   REA_ESQUEMAS_CONTRATOS (Table)
--   GT_REA_ESQUEMAS_EMPRESAS (Package)
--   GT_REA_TIPOS_CONTRATOS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_REA_ESQUEMAS_CAPAS IS
  PROCEDURE ACTIVAR_CAPAS(nCodCia NUMBER, cCodEsquema VARCHAR2);
  PROCEDURE SUSPENDER_CAPAS(nCodCia NUMBER, cCodEsquema VARCHAR2);
  PROCEDURE CONFIGURAR_CAPAS(nCodCia NUMBER, cCodEsquema VARCHAR2);
  PROCEDURE COPIAR_CAPAS(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2);
END GT_REA_ESQUEMAS_CAPAS;
/

--
-- GT_REA_ESQUEMAS_CAPAS  (Package Body) 
--
--  Dependencies: 
--   GT_REA_ESQUEMAS_CAPAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_REA_ESQUEMAS_CAPAS IS

PROCEDURE ACTIVAR_CAPAS(nCodCia NUMBER, cCodEsquema VARCHAR2) IS
CURSOR CAPAS_Q IS
   SELECT C.IdEsqContrato, C.IdCapaContrato, CO.CodContrato
     FROM REA_ESQUEMAS_CAPAS C, REA_ESQUEMAS_CONTRATOS CO
    WHERE GT_REA_TIPOS_CONTRATOS.CONTRATO_FACULTATIVO(CO.CodCia, CO.CodContrato) = 'N'
      AND CO.IdEsqContrato   = C.IdEsqContrato
      AND CO.CodEsquema      = C.CodEsquema
      AND CO.CodCia          = C.CodCia
      AND C.CodCia           = nCodCia
      AND C.CodEsquema       = cCodEsquema
      AND C.StsCapaContrato  = 'CONFIG';
BEGIN
   FOR W IN CAPAS_Q LOOP
      IF GT_REA_ESQUEMAS_EMPRESAS.PORCENTAJE_EMPRESAS_CAPA(nCodCia, cCodEsquema, W.IdEsqContrato, W.IdCapaContrato) != 100 THEN
         RAISE_APPLICATION_ERROR(-20000,'NO Puede Activar el Esquema de Reaseguro, porque el Porcentaje de Participación de Empresas ' ||
                                 'NO Suman el 100% en el Esquema ' || cCodEsquema || 
                                 ' del Contrato ' || W.CodContrato || ' en la Capa No. ' || W.IdCapaContrato);
      END IF;
   END LOOP;
   UPDATE REA_ESQUEMAS_CAPAS
      SET StsCapaContrato  = 'ACTIVO',
          FecStatus        = TRUNC(SYSDATE)
    WHERE CodCia           = nCodCia
      AND CodEsquema       = cCodEsquema
      AND StsCapaContrato IN ('CONFIG','SUSPEN');
END ACTIVAR_CAPAS;

PROCEDURE SUSPENDER_CAPAS(nCodCia NUMBER, cCodEsquema VARCHAR2) IS
BEGIN
   UPDATE REA_ESQUEMAS_CAPAS
      SET StsCapaContrato = 'SUSPEN',
          FecStatus       = TRUNC(SYSDATE)
    WHERE CodCia          = nCodCia
      AND CodEsquema      = cCodEsquema
      AND StsCapaContrato = 'ACTIVO';
END SUSPENDER_CAPAS;

PROCEDURE CONFIGURAR_CAPAS(nCodCia NUMBER, cCodEsquema VARCHAR2) IS
BEGIN
   UPDATE REA_ESQUEMAS_CAPAS
      SET StsCapaContrato = 'CONFIG',
          FecStatus       = TRUNC(SYSDATE)
    WHERE CodCia          = nCodCia
      AND CodEsquema      = cCodEsquema
      AND StsCapaContrato = 'ACTIVO';
END CONFIGURAR_CAPAS;

PROCEDURE COPIAR_CAPAS(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2) IS
CURSOR CAPAS_Q IS
   SELECT IdEsqContrato, IdCapaContrato, FecVigInicial, FecVigFinal,
          PorcEsqContrato, NumPlenos, PorcCapa, LimiteMaxCapa, LimiteResp,
          LimiteRentas, PrimaEstimadaXl, MtoSiniContado, RutinaCalcEspecial,
          StsCapaContrato, FecStatus
     FROM REA_ESQUEMAS_CAPAS
    WHERE CodCia     = nCodCia
      AND CodEsquema = cCodEsquemaOrig;
BEGIN
   FOR W IN CAPAS_Q LOOP
      INSERT INTO REA_ESQUEMAS_CAPAS
             (CodCia, CodEsquema, IdEsqContrato, IdCapaContrato, FecVigInicial, FecVigFinal,
              PorcEsqContrato, NumPlenos, PorcCapa, LimiteMaxCapa, LimiteResp,
              LimiteRentas, PrimaEstimadaXl, MtoSiniContado, RutinaCalcEspecial,
              StsCapaContrato, FecStatus)
      VALUES (nCodCia, cCodEsquemaDest, W.IdEsqContrato, W.IdCapaContrato, W.FecVigInicial, W.FecVigFinal,
              W.PorcEsqContrato, W.NumPlenos, W.PorcCapa, W.LimiteMaxCapa, W.LimiteResp,
              W.LimiteRentas, W.PrimaEstimadaXl, W.MtoSiniContado, W.RutinaCalcEspecial,
              'ACTIVO', TRUNC(SYSDATE));
   END LOOP;
END COPIAR_CAPAS;

END GT_REA_ESQUEMAS_CAPAS;
/

--
-- GT_REA_ESQUEMAS_CAPAS  (Synonym) 
--
--  Dependencies: 
--   GT_REA_ESQUEMAS_CAPAS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_REA_ESQUEMAS_CAPAS FOR SICAS_OC.GT_REA_ESQUEMAS_CAPAS
/


GRANT EXECUTE ON SICAS_OC.GT_REA_ESQUEMAS_CAPAS TO PUBLIC
/

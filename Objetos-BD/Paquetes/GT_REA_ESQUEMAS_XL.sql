CREATE OR REPLACE PACKAGE GT_REA_ESQUEMAS_XL IS
  PROCEDURE COPIAR_ESQUEMA_XL(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2);
END GT_REA_ESQUEMAS_XL;
/

CREATE OR REPLACE PACKAGE BODY GT_REA_ESQUEMAS_XL IS

PROCEDURE COPIAR_ESQUEMA_XL(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2) IS
CURSOR XL_Q IS
   SELECT IdEsqContrato, IdCapaContrato, CodEmpresaGremio, MtoPrioridadXl,
          MtoLimCobertXl, ReInstalMaxXl, PorcReinstal, CantReinstalXl,
          PrimaRetEstimada, TasaMinXl, TasaMaxXl, PrimaMinimaXl,
          PrimaDepositoXl, FormaPagoDepXl, PrimaFlatXl, PorcRecargoXl,
          CodInterReaseg
     FROM REA_ESQUEMAS_XL
    WHERE CodCia     = nCodCia
      AND CodEsquema = cCodEsquemaOrig;
BEGIN
   FOR W IN XL_Q LOOP
      INSERT INTO REA_ESQUEMAS_XL
             (CodCia, CodEsquema, IdEsqContrato, IdCapaContrato, CodEmpresaGremio, 
              MtoPrioridadXl, MtoLimCobertXl, ReInstalMaxXl, PorcReinstal, CantReinstalXl,
              PrimaRetEstimada, TasaMinXl, TasaMaxXl, PrimaMinimaXl,
              PrimaDepositoXl, FormaPagoDepXl, PrimaFlatXl, PorcRecargoXl, CodInterReaseg)
      VALUES (nCodCia, cCodEsquemaDest, W.IdEsqContrato, W.IdCapaContrato, W.CodEmpresaGremio, 
              W.MtoPrioridadXl, W.MtoLimCobertXl, W.ReInstalMaxXl, W.PorcReinstal, W.CantReinstalXl,
              W.PrimaRetEstimada, W.TasaMinXl, W.TasaMaxXl, W.PrimaMinimaXl,
              W.PrimaDepositoXl, W.FormaPagoDepXl, W.PrimaFlatXl, W.PorcRecargoXl, W.CodInterReaseg);
   END LOOP;
END COPIAR_ESQUEMA_XL;

END GT_REA_ESQUEMAS_XL;

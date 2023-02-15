CREATE OR REPLACE PACKAGE GT_REA_ESQUEMAS_XL_REINSTAL IS
  PROCEDURE COPIAR_REINSTALAMENTOS(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2);
END GT_REA_ESQUEMAS_XL_REINSTAL;
/

CREATE OR REPLACE PACKAGE BODY GT_REA_ESQUEMAS_XL_REINSTAL IS

PROCEDURE COPIAR_REINSTALAMENTOS(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2) IS
CURSOR REINS_Q IS
   SELECT IdEsqContrato, IdCapaContrato, CodEmpresaGremio, IdReinstalamento,
          PorcReinstal, StsReinstal, FecStatus, CodInterReaseg
     FROM REA_ESQUEMAS_XL_REINSTAL
    WHERE CodCia     = nCodCia
      AND CodEsquema = cCodEsquemaOrig;
BEGIN
   FOR W IN REINS_Q LOOP
      INSERT INTO REA_ESQUEMAS_XL_REINSTAL
             (CodCia, CodEsquema, IdEsqContrato, IdCapaContrato, CodEmpresaGremio, 
              IdReinstalamento, PorcReinstal, StsReinstal, FecStatus, CodInterReaseg)
      VALUES (nCodCia, cCodEsquemaDest, W.IdEsqContrato, W.IdCapaContrato, W.CodEmpresaGremio, 
              W.IdReinstalamento, W.PorcReinstal, 'ACTIVO', TRUNC(SYSDATE), W.CodInterReaseg);
   END LOOP;
END COPIAR_REINSTALAMENTOS;

END GT_REA_ESQUEMAS_XL_REINSTAL;

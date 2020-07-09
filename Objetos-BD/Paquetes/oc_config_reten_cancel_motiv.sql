--
-- OC_CONFIG_RETEN_CANCEL_MOTIV  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   CONFIG_RETEN_CANCEL_MOTIV (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONFIG_RETEN_CANCEL_MOTIV IS

  FUNCTION APLICA_MOTIVO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, dFecAnul DATE,
                         nDiasAnul NUMBER, cCodMotivoAnul VARCHAR2) RETURN VARCHAR2;

  PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cIdTipoSegDest VARCHAR2);

END OC_CONFIG_RETEN_CANCEL_MOTIV;
/

--
-- OC_CONFIG_RETEN_CANCEL_MOTIV  (Package Body) 
--
--  Dependencies: 
--   OC_CONFIG_RETEN_CANCEL_MOTIV (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CONFIG_RETEN_CANCEL_MOTIV IS

FUNCTION APLICA_MOTIVO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, dFecAnul DATE,
                       nDiasAnul NUMBER, cCodMotivoAnul VARCHAR2) RETURN VARCHAR2 IS
cExiste    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM CONFIG_RETEN_CANCEL_MOTIV
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdTipoSeg      = cIdTipoSeg
         AND FecIniReten   <= dFecAnul
         AND FecFinReten   >= dFecAnul
         AND DiasIniReten  <= nDiasAnul
         AND DiasFinReten  >= nDiasAnul
         AND CodMotivoCanc  = cCodMotivoAnul;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END APLICA_MOTIVO;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2) IS
CURSOR RETEN_Q IS
   SELECT FecIniReten, FecFinReten, DiasIniReten, 
          DiasFinReten, CodMotivoCanc
     FROM CONFIG_RETEN_CANCEL_MOTIV
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa      
      AND IdTipoSeg  = cIdTipoSegOrig;
BEGIN
   FOR X IN RETEN_Q  LOOP
      INSERT INTO CONFIG_RETEN_CANCEL_MOTIV
             (CodCia, CodEmpresa, IdTipoSeg,FecIniReten, FecFinReten, 
              DiasIniReten, DiasFinReten, CodMotivoCanc)
      VALUES (nCodCia, nCodEmpresa, cIdTipoSegDest, X.FecIniReten, X.FecFinReten, 
              X.DiasIniReten, X.DiasFinReten, X.CodMotivoCanc);
   END LOOP;
END COPIAR;

END OC_CONFIG_RETEN_CANCEL_MOTIV;
/

--
-- OC_CONFIG_RETEN_CANCEL_MOTIV  (Synonym) 
--
--  Dependencies: 
--   OC_CONFIG_RETEN_CANCEL_MOTIV (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_CONFIG_RETEN_CANCEL_MOTIV FOR SICAS_OC.OC_CONFIG_RETEN_CANCEL_MOTIV
/


GRANT EXECUTE ON SICAS_OC.OC_CONFIG_RETEN_CANCEL_MOTIV TO PUBLIC
/

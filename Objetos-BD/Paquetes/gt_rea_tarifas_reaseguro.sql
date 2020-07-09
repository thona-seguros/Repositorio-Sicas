--
-- GT_REA_TARIFAS_REASEGURO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   REA_TARIFAS_REASEGURO (Table)
--   GT_REA_TARIFAS_REASEGURO_DET (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_REA_TARIFAS_REASEGURO IS

  FUNCTION DESCRIPCION_TARIFA(nCodCia NUMBER, cCodTarifaReaseg VARCHAR2) RETURN VARCHAR2;
  PROCEDURE CONFIGURAR_TARIFA(nCodCia NUMBER, cCodTarifaReaseg VARCHAR2);
  PROCEDURE ACTIVAR_TARIFA(nCodCia NUMBER, cCodTarifaReaseg VARCHAR2);
  PROCEDURE SUSPENDER_TARIFA(nCodCia NUMBER, cCodTarifaReaseg VARCHAR2);
  FUNCTION VIGENCIA_TARIFA(nCodCia NUMBER, cCodTarifaReaseg VARCHAR2, dFecOperacion DATE) RETURN VARCHAR2;
  PROCEDURE COPIAR(nCodCia NUMBER, cCodTarifaReaSegOrig VARCHAR2, cCodTarifaReaSegDest VARCHAR2, 
                   cDescTarifaReaSegDest VARCHAR2, dFecIniTarifa DATE, dFecFinTarifa DATE);

END GT_REA_TARIFAS_REASEGURO;
/

--
-- GT_REA_TARIFAS_REASEGURO  (Package Body) 
--
--  Dependencies: 
--   GT_REA_TARIFAS_REASEGURO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_REA_TARIFAS_REASEGURO IS

FUNCTION DESCRIPCION_TARIFA(nCodCia NUMBER, cCodTarifaReaseg VARCHAR2) RETURN VARCHAR2 IS
cDescTarifaReaseg       REA_TARIFAS_REASEGURO.DescTarifaReaseg%TYPE;
BEGIN
   BEGIN
      SELECT DescTarifaReaseg
        INTO cDescTarifaReaseg
        FROM REA_TARIFAS_REASEGURO
       WHERE CodCia           = nCodCia
         AND CodTarifaReaseg  = cCodTarifaReaseg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescTarifaReaseg := 'Tarifa NO Existe';
   END;
   RETURN(cDescTarifaReaseg);
END DESCRIPCION_TARIFA;

PROCEDURE CONFIGURAR_TARIFA(nCodCia NUMBER, cCodTarifaReaseg VARCHAR2) IS
BEGIN
   UPDATE REA_TARIFAS_REASEGURO
      SET StsTarifaReaseg  = 'CONFIG',
          FecStatus        = TRUNC(SYSDATE),
          CodUsuario       = USER,
          FecUltModif      = TRUNC(SYSDATE)
    WHERE CodCia           = nCodCia
      AND CodTarifaReaseg  = cCodTarifaReaseg;
END CONFIGURAR_TARIFA;

PROCEDURE ACTIVAR_TARIFA(nCodCia NUMBER, cCodTarifaReaseg VARCHAR2) IS
BEGIN
   UPDATE REA_TARIFAS_REASEGURO
      SET StsTarifaReaseg  = 'ACTIVA',
          FecStatus        = TRUNC(SYSDATE),
          CodUsuario       = USER,
          FecUltModif      = TRUNC(SYSDATE)
    WHERE CodCia           = nCodCia
      AND CodTarifaReaseg  = cCodTarifaReaseg;
END ACTIVAR_TARIFA;

PROCEDURE SUSPENDER_TARIFA(nCodCia NUMBER, cCodTarifaReaseg VARCHAR2) IS
BEGIN
   UPDATE REA_TARIFAS_REASEGURO
      SET StsTarifaReaseg  = 'SUSPEN',
          FecStatus        = TRUNC(SYSDATE),
          CodUsuario       = USER,
          FecUltModif      = TRUNC(SYSDATE)
    WHERE CodCia           = nCodCia
      AND CodTarifaReaseg  = cCodTarifaReaseg;
END SUSPENDER_TARIFA;

FUNCTION VIGENCIA_TARIFA(nCodCia NUMBER, cCodTarifaReaseg VARCHAR2, dFecOperacion DATE) RETURN VARCHAR2 IS
cTarifaVigente       VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cTarifaVigente
        FROM REA_TARIFAS_REASEGURO
       WHERE CodCia            = nCodCia
         AND CodTarifaReaseg   = cCodTarifaReaseg
         AND FecIniTarifa     <= dFecOperacion
         AND FecFinTarifa     >= dFecOperacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTarifaVigente := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR (-20100,'Error en Configuración de Tarifa de Reaseguro '||cCodTarifaReaseg);
   END;
   RETURN(cTarifaVigente);
END VIGENCIA_TARIFA;

PROCEDURE COPIAR(nCodCia NUMBER, cCodTarifaReaSegOrig VARCHAR2, cCodTarifaReaSegDest VARCHAR2, 
                 cDescTarifaReaSegDest VARCHAR2, dFecIniTarifa DATE, dFecFinTarifa DATE) IS
CURSOR TARIREA_Q IS
   SELECT CodCia, CodTarifaReaSeg, DescTarifaReaSeg, FecIniTarifa, FecFinTarifa, StsTarifaReaSeg, 
          FecStatus, CodUsuario, FecUltModif
     FROM REA_TARIFAS_REASEGURO
    WHERE CodCia            = nCodCia
      AND CodTarifaReaSeg   = cCodTarifaReaSegOrig;
BEGIN
   FOR W IN TARIREA_Q LOOP
      INSERT INTO REA_TARIFAS_REASEGURO
             (CodCia, CodTarifaReaSeg, DescTarifaReaSeg, FecIniTarifa, FecFinTarifa, 
              StsTarifaReaSeg, FecStatus, CodUsuario, FecUltModif)
      VALUES (nCodCia, cCodTarifaReaSegDest, cDescTarifaReaSegDest, dFecIniTarifa, dFecFinTarifa, 
              'CONFIG', TRUNC(SYSDATE), W.CodUsuario, TRUNC(SYSDATE));
      GT_REA_TARIFAS_REASEGURO_DET.COPIAR(nCodCia, cCodTarifaReaSegOrig, cCodTarifaReaSegDest);
   END LOOP;
END COPIAR;

END GT_REA_TARIFAS_REASEGURO;
/

--
-- GT_REA_TARIFAS_REASEGURO  (Synonym) 
--
--  Dependencies: 
--   GT_REA_TARIFAS_REASEGURO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_REA_TARIFAS_REASEGURO FOR SICAS_OC.GT_REA_TARIFAS_REASEGURO
/


GRANT EXECUTE ON SICAS_OC.GT_REA_TARIFAS_REASEGURO TO PUBLIC
/

--
-- GT_FAI_EMAIL_MOVIMIENTO_FONDO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   FAI_EMAIL_MOVIMIENTO_FONDO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_EMAIL_MOVIMIENTO_FONDO AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, 
                   cCodCptoMov VARCHAR2, dFecIniEmail DATE, dFecFinEmail DATE);

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, 
                      cCodCptoMov VARCHAR2, dFecIniEmail DATE, dFecFinEmail DATE);

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, 
                     cCodCptoMov VARCHAR2, dFecIniEmail DATE, dFecFinEmail DATE);

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, 
                     cCodCptoMov VARCHAR2, dFecIniEmail DATE, dFecFinEmail DATE);

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cCodCptoMovOrig VARCHAR2,
                 dFecIniEmailOrig DATE,  dFecFinEmailOrig DATE, cTipoFondoDest VARCHAR2, cCodCptoMovDest VARCHAR2);

END GT_FAI_EMAIL_MOVIMIENTO_FONDO;
/

--
-- GT_FAI_EMAIL_MOVIMIENTO_FONDO  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_EMAIL_MOVIMIENTO_FONDO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_EMAIL_MOVIMIENTO_FONDO AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, 
                   cCodCptoMov VARCHAR2, dFecIniEmail DATE, dFecFinEmail DATE) IS
BEGIN
   UPDATE FAI_EMAIL_MOVIMIENTO_FONDO
      SET StsEmail    = 'ACTIVO',
          FecStatus   = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondo
	   AND CodCptoMov  = cCodCptoMov
      AND FecIniEmail = dFecIniEmail
      AND FecFinEmail = dFecFinEmail;
END ACTIVAR;

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, 
                      cCodCptoMov VARCHAR2, dFecIniEmail DATE, dFecFinEmail DATE) IS
BEGIN
   UPDATE FAI_EMAIL_MOVIMIENTO_FONDO
      SET StsEmail    = 'CONFIG',
          FecStatus   = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondo
	   AND CodCptoMov  = cCodCptoMov
      AND FecIniEmail = dFecIniEmail
      AND FecFinEmail = dFecFinEmail;
END CONFIGURAR;

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, 
                     cCodCptoMov VARCHAR2, dFecIniEmail DATE, dFecFinEmail DATE) IS
BEGIN
   UPDATE FAI_EMAIL_MOVIMIENTO_FONDO
      SET StsEmail    = 'ACTIVO',
          FecStatus   = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondo
	   AND CodCptoMov  = cCodCptoMov
      AND FecIniEmail = dFecIniEmail
      AND FecFinEmail = dFecFinEmail;
END REACTIVAR;

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, 
                     cCodCptoMov VARCHAR2, dFecIniEmail DATE, dFecFinEmail DATE) IS
BEGIN
   UPDATE FAI_EMAIL_MOVIMIENTO_FONDO
      SET StsEmail    = 'SUSPEN',
          FecStatus   = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondo
	   AND CodCptoMov  = cCodCptoMov
      AND FecIniEmail = dFecIniEmail
      AND FecFinEmail = dFecFinEmail;
END SUSPENDER;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cCodCptoMovOrig VARCHAR2, 
                 dFecIniEmailOrig DATE, dFecFinEmailOrig DATE, cTipoFondoDest VARCHAR2, cCodCptoMovDest VARCHAR2) IS
CURSOR EMAIL_Q IS
   SELECT CodCptoMov, FecIniEmail, FecFinEmail, TextoEmail
     FROM FAI_EMAIL_MOVIMIENTO_FONDO
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondoOrig
	   AND CodCptoMov  = cCodCptoMovOrig
      AND FecIniEmail = dFecIniEmailOrig
      AND FecFinEmail = dFecFinEmailOrig;
BEGIN
   FOR X IN EMAIL_Q LOOP
      INSERT INTO FAI_EMAIL_MOVIMIENTO_FONDO
             (CodCia, CodEmpresa, TipoFondo, CodCptoMov, FecIniEmail, 
              FecFinEmail, StsEmail, FecStatus, TextoEmail)
      VALUES (nCodCia, nCodEmpresa, cTipoFondoDest, cCodCptoMovDest, X.FecIniEmail, 
              X.FecFinEmail, 'CONFIG', TRUNC(SYSDATE), X.TextoEmail);
   END LOOP;
END COPIAR;

END GT_FAI_EMAIL_MOVIMIENTO_FONDO;
/

--
-- GT_FAI_EMAIL_MOVIMIENTO_FONDO  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_EMAIL_MOVIMIENTO_FONDO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_EMAIL_MOVIMIENTO_FONDO FOR SICAS_OC.GT_FAI_EMAIL_MOVIMIENTO_FONDO
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_FAI_EMAIL_MOVIMIENTO_FONDO TO PUBLIC
/

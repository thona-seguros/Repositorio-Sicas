--
-- GT_FAI_CONF_MOVIMIENTOS_FONDO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   FAI_CONF_EMAIL_MOV_FONDO (Table)
--   FAI_CONF_MOVIMIENTOS_FONDO (Table)
--   GT_FAI_CONF_EMAIL_MOV_FONDO (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_CONF_MOVIMIENTOS_FONDO AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMov VARCHAR2);

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMov VARCHAR2);

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMov VARCHAR2);

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMov VARCHAR2);

END GT_FAI_CONF_MOVIMIENTOS_FONDO;
/

--
-- GT_FAI_CONF_MOVIMIENTOS_FONDO  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_CONF_MOVIMIENTOS_FONDO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_CONF_MOVIMIENTOS_FONDO AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMov VARCHAR2) IS
CURSOR EMAIL_Q IS
   SELECT FecIniEmail, FecFinEmail
     FROM FAI_CONF_EMAIL_MOV_FONDO
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND CodCptoMov  = cCodCptoMov
      AND StsEmail    = 'CONFIG';
BEGIN
   UPDATE FAI_CONF_MOVIMIENTOS_FONDO
      SET StsMovFondo = 'ACTIVO',
          FecStatus   = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND CodCptoMov = cCodCptoMov;

   FOR W IN EMAIL_Q LOOP
      GT_FAI_CONF_EMAIL_MOV_FONDO.ACTIVAR(nCodCia, nCodEmpresa, cCodCptoMov, W.FecIniEmail, W.FecFinEmail);
   END LOOP;
END ACTIVAR;

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMov VARCHAR2) IS
CURSOR EMAIL_Q IS
   SELECT FecIniEmail, FecFinEmail
     FROM FAI_CONF_EMAIL_MOV_FONDO
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND CodCptoMov  = cCodCptoMov
      AND StsEmail    = 'ACTIVO';
BEGIN
   UPDATE FAI_CONF_MOVIMIENTOS_FONDO
      SET StsMovFondo = 'CONFIG',
          FecStatus   = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND CodCptoMov = cCodCptoMov;
   FOR W IN EMAIL_Q LOOP
      GT_FAI_CONF_EMAIL_MOV_FONDO.CONFIGURAR(nCodCia, nCodEmpresa, cCodCptoMov, W.FecIniEmail, W.FecFinEmail);
   END LOOP;
END CONFIGURAR;

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMov VARCHAR2) IS
CURSOR EMAIL_Q IS
   SELECT FecIniEmail, FecFinEmail
     FROM FAI_CONF_EMAIL_MOV_FONDO
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND CodCptoMov  = cCodCptoMov
      AND StsEmail    = 'SUSPEN';
BEGIN
   UPDATE FAI_CONF_MOVIMIENTOS_FONDO
      SET StsMovFondo = 'ACTIVO',
          FecStatus   = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND CodCptoMov = cCodCptoMov;

   FOR W IN EMAIL_Q LOOP
      GT_FAI_CONF_EMAIL_MOV_FONDO.REACTIVAR(nCodCia, nCodEmpresa, cCodCptoMov, W.FecIniEmail, W.FecFinEmail);
   END LOOP;

END REACTIVAR;

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMov VARCHAR2) IS
CURSOR EMAIL_Q IS
   SELECT FecIniEmail, FecFinEmail
     FROM FAI_CONF_EMAIL_MOV_FONDO
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND CodCptoMov  = cCodCptoMov
      AND StsEmail    = 'ACTIVO';
BEGIN
   UPDATE FAI_CONF_MOVIMIENTOS_FONDO
      SET StsMovFondo = 'SUSPEN',
          FecStatus   = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND CodCptoMov = cCodCptoMov;

   FOR W IN EMAIL_Q LOOP
      GT_FAI_CONF_EMAIL_MOV_FONDO.SUSPENDER(nCodCia, nCodEmpresa, cCodCptoMov, W.FecIniEmail, W.FecFinEmail);
   END LOOP;

END SUSPENDER;

END GT_FAI_CONF_MOVIMIENTOS_FONDO;
/

--
-- GT_FAI_CONF_MOVIMIENTOS_FONDO  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_CONF_MOVIMIENTOS_FONDO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_CONF_MOVIMIENTOS_FONDO FOR SICAS_OC.GT_FAI_CONF_MOVIMIENTOS_FONDO
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_FAI_CONF_MOVIMIENTOS_FONDO TO PUBLIC
/

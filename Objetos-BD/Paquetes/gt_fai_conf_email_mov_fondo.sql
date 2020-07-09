--
-- GT_FAI_CONF_EMAIL_MOV_FONDO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_CONF_EMAIL_MOV_FONDO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_CONF_EMAIL_MOV_FONDO AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMov VARCHAR2, 
                   dFecIniEmail DATE, dFecFinEmail DATE);

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMov VARCHAR2, 
                      dFecIniEmail DATE, dFecFinEmail DATE);

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMov VARCHAR2, 
                     dFecIniEmail DATE, dFecFinEmail DATE);

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMov VARCHAR2, 
                     dFecIniEmail DATE, dFecFinEmail DATE);

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMovOrig VARCHAR2, 
                 dFecIniEmailOrig DATE, dFecFinEmailOrig DATE, cCodCptoMovDest VARCHAR2);

END GT_FAI_CONF_EMAIL_MOV_FONDO;
/

--
-- GT_FAI_CONF_EMAIL_MOV_FONDO  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_CONF_EMAIL_MOV_FONDO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_CONF_EMAIL_MOV_FONDO AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMov VARCHAR2, 
                   dFecIniEmail DATE, dFecFinEmail DATE) IS
BEGIN
   UPDATE FAI_CONF_EMAIL_MOV_FONDO
      SET StsEmail  = 'ACTIVO',
          FecStatus = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND CodCptoMov  = cCodCptoMov
      AND FecIniEmail = dFecIniEmail
      AND FecFinEmail = dFecFinEmail;
END ACTIVAR;

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMov VARCHAR2, 
                      dFecIniEmail DATE, dFecFinEmail DATE) IS
BEGIN
   UPDATE FAI_CONF_EMAIL_MOV_FONDO
      SET StsEmail  = 'CONFIG',
          FecStatus = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND CodCptoMov  = cCodCptoMov
      AND FecIniEmail = dFecIniEmail
      AND FecFinEmail = dFecFinEmail;
END CONFIGURAR;

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMov VARCHAR2, 
                     dFecIniEmail DATE, dFecFinEmail DATE) IS
BEGIN
   UPDATE FAI_CONF_EMAIL_MOV_FONDO
      SET StsEmail  = 'ACTIVO',
          FecStatus = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND CodCptoMov  = cCodCptoMov
      AND FecIniEmail = dFecIniEmail
      AND FecFinEmail = dFecFinEmail;
END REACTIVAR;

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMov VARCHAR2, 
                     dFecIniEmail DATE, dFecFinEmail DATE) IS
BEGIN
   UPDATE FAI_CONF_EMAIL_MOV_FONDO
      SET StsEmail  = 'SUSPEN',
          FecStatus = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND CodCptoMov  = cCodCptoMov
      AND FecIniEmail = dFecIniEmail
      AND FecFinEmail = dFecFinEmail;
END SUSPENDER;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCptoMovOrig VARCHAR2, 
                 dFecIniEmailOrig DATE,  dFecFinEmailOrig DATE, cCodCptoMovDest VARCHAR2) IS
CURSOR EMAIL_Q IS
   SELECT CodCptoMov, FecIniEmail, FecFinEmail, TextoEmail
     FROM FAI_CONF_EMAIL_MOV_FONDO
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND CodCptoMov  = cCodCptoMovOrig
      AND FecIniEmail = dFecIniEmailOrig
      AND FecFinEmail = dFecFinEmailOrig;

BEGIN
   FOR X IN EMAIL_Q LOOP
      BEGIN
          INSERT INTO FAI_CONF_EMAIL_MOV_FONDO
                 (CodCia, CodEmpresa, CodCptoMov, FecIniEmail, 
                  FecFinEmail, StsEmail, FecStatus, TextoEmail)
          VALUES (nCodCia, nCodEmpresa, cCodCptoMovDest, X.FecIniEmail,
                  X.FecFinEmail, 'CONFIG', TRUNC(SYSDATE), X.TextoEmail);
      EXCEPTION 
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20225,'Ya Existe Configuración para este Concepto Por Favor Valide o Seleccione Otro Concepto');
      END;
   END LOOP;
END COPIAR;

END GT_FAI_CONF_EMAIL_MOV_FONDO;
/

--
-- GT_FAI_CONF_EMAIL_MOV_FONDO  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_CONF_EMAIL_MOV_FONDO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_CONF_EMAIL_MOV_FONDO FOR SICAS_OC.GT_FAI_CONF_EMAIL_MOV_FONDO
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_FAI_CONF_EMAIL_MOV_FONDO TO PUBLIC
/

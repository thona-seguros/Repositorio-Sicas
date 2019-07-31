--
-- GT_FAI_DESCANSO_APORTACIONES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   FAI_DESCANSO_APORTACIONES (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_DESCANSO_APORTACIONES AS

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, nNumPeriodoDesc NUMBER);

PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, nNumPeriodoDesc NUMBER);

PROCEDURE TERMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, nNumPeriodoDesc NUMBER);

FUNCTION PERIODO_DESCANSO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2;

FUNCTION NUMERO_PERIODO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER) RETURN NUMBER;

END GT_FAI_DESCANSO_APORTACIONES;
/

--
-- GT_FAI_DESCANSO_APORTACIONES  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_DESCANSO_APORTACIONES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_DESCANSO_APORTACIONES AS

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, nNumPeriodoDesc NUMBER) IS
BEGIN
   UPDATE FAI_DESCANSO_APORTACIONES
      SET StsPerDescanso = 'ACTIVO',
          FecStatus      = TRUNC(SYSDATE)
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdPoliza       = nIdPoliza
      AND IDetPol        = nIDetPol
      AND CodAsegurado   = nCodAsegurado
      AND NumPeriodoDesc = nNumPeriodoDesc;
END ACTIVAR;

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, nNumPeriodoDesc NUMBER) IS
BEGIN
   UPDATE FAI_DESCANSO_APORTACIONES
      SET StsPerDescanso = 'SUSPEN',
          FecStatus      = TRUNC(SYSDATE)
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdPoliza       = nIdPoliza
      AND IDetPol        = nIDetPol
      AND CodAsegurado   = nCodAsegurado
      AND NumPeriodoDesc = nNumPeriodoDesc;
END SUSPENDER;

PROCEDURE TERMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, nNumPeriodoDesc NUMBER) IS
BEGIN
   UPDATE FAI_DESCANSO_APORTACIONES
      SET StsPerDescanso = 'TERMIN',
          FecStatus      = TRUNC(SYSDATE)
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdPoliza       = nIdPoliza
      AND IDetPol        = nIDetPol
      AND CodAsegurado   = nCodAsegurado
      AND NumPeriodoDesc = nNumPeriodoDesc;
END TERMINAR;

FUNCTION PERIODO_DESCANSO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
	BEGIN
	   SELECT 'S'
	     INTO cExiste
	     FROM FAI_DESCANSO_APORTACIONES
	    WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdPoliza       = nIdPoliza
         AND IDetPol        = nIDetPol
         AND CodAsegurado   = nCodAsegurado
         AND StsPerDescanso = 'ACTIVO';
	EXCEPTION
	   WHEN NO_DATA_FOUND THEN
	      cExiste := 'N';
	   WHEN TOO_MANY_ROWS THEN
	      cExiste := 'S';
	END;
   RETURN(cExiste);
END PERIODO_DESCANSO;

FUNCTION NUMERO_PERIODO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER) RETURN NUMBER IS
cNumPeriodo     FAI_DESCANSO_APORTACIONES.NumPeriodoDesc%TYPE;
BEGIN
	BEGIN
	   SELECT COUNT(*) + 1
	     INTO cNumPeriodo
	     FROM FAI_DESCANSO_APORTACIONES
	    WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdPoliza       = nIdPoliza
         AND IDetPol        = nIDetPol
         AND CodAsegurado   = nCodAsegurado;
	END;
   RETURN(cNumPeriodo);
END NUMERO_PERIODO;

END GT_FAI_DESCANSO_APORTACIONES;
/

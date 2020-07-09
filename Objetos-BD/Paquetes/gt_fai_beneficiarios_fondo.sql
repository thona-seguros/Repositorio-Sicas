--
-- GT_FAI_BENEFICIARIOS_FONDO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_BENEFICIARIOS_FONDO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_BENEFICIARIOS_FONDO AS

FUNCTION NUMERO_BENEFICIARIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                             nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                 nCodAsegurado NUMBER, nIdFondoOrig NUMBER, nIdFondoDest NUMBER);

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                  nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER);

PROCEDURE SOLICITUD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                    nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                    nNumRenov NUMBER);

PROCEDURE REACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                    nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER);

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                  nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER);

PROCEDURE EXCLUIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                  nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                  nNumBenef NUMBER, cCodMotExc VARCHAR2, cTextMotvExc VARCHAR2, 
                  dFecExclusion DATE);

PROCEDURE RENOVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                  nCodAsegurado NUMBER, nIdFondoOrig NUMBER, nIdPolizaRen NUMBER, nIdFondoDest NUMBER);

END GT_FAI_BENEFICIARIOS_FONDO;
/

--
-- GT_FAI_BENEFICIARIOS_FONDO  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_BENEFICIARIOS_FONDO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_BENEFICIARIOS_FONDO AS

FUNCTION NUMERO_BENEFICIARIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                             nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER IS
nNumBenef          FAI_BENEFICIARIOS_FONDO.NumBenef%TYPE;
BEGIN
   SELECT NVL(MAX(NumBenef),0) + 1
     INTO nNumBenef
     FROM FAI_BENEFICIARIOS_FONDO
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCodAsegurado
      AND IdFondo       = nIdFondo;

   RETURN(nNumBenef);
END NUMERO_BENEFICIARIO;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                 nCodAsegurado NUMBER, nIdFondoOrig NUMBER, nIdFondoDest NUMBER) IS
CURSOR BENEF_Q IS
   SELECT NumBenef, CodParent, PorcPart, Observaciones, NivPrioridad
     FROM FAI_BENEFICIARIOS_FONDO
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondoOrig;
BEGIN
   FOR X IN BENEF_Q LOOP
      BEGIN
         INSERT INTO FAI_BENEFICIARIOS_FONDO
               (CodCia, CodEmpresa, IdPoliza, IDetPol, CodAsegurado, 
                IdFondo, NumBenef, StsBenef, FecStatus, CodParent,
                FecIngreso, PorcPart, Observaciones, NivPrioridad)
         VALUES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, 
                nIdFondoDest, X.NumBenef, 'SOLICI', TRUNC(SYSDATE), X.CodParent,
                TRUNC(SYSDATE), X.PorcPart, X.Observaciones, X.NivPrioridad);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20100,'Error al Copiar Beneficiarios del Fondo No. ' || nIdFondoDest);
      END;
   END LOOP;
END COPIAR;

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                  nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
CURSOR BENEF_Q IS
   SELECT NumBenef
     FROM FAI_BENEFICIARIOS_FONDO
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCodAsegurado
      AND IdFondo       = nIdFondo
      AND StsBenef     IN ('SOLICI','XRENOV');
BEGIN
   FOR W IN BENEF_Q LOOP
      UPDATE FAI_BENEFICIARIOS_FONDO
         SET StsBenef   = 'ACTIVO',
             FecStatus  = TRUNC(SYSDATE)
       WHERE CodCia     = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
         AND IdFondo      = nIdFondo
         AND NumBenef     = W.NumBenef;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Activar Beneficiarios del Fondo No. ' || nIdFondo);
END ACTIVAR;

PROCEDURE SOLICITUD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                    nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                    nNumRenov NUMBER) IS

cStsBenef               FAI_BENEFICIARIOS_FONDO.StsBenef%TYPE;

CURSOR BENEF_Q IS
   SELECT NumBenef
     FROM FAI_BENEFICIARIOS_FONDO
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo
      AND StsBenef     = 'ACTIVO';
BEGIN
   IF nNumRenov = 0 THEN
      cStsBenef := 'SOLICI';
   ELSE
      cStsBenef := 'XRENOV';
   END IF;

   FOR W IN BENEF_Q LOOP
      UPDATE FAI_BENEFICIARIOS_FONDO
         SET StsBenef   = cStsBenef,
             FecStatus  = TRUNC(SYSDATE)
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
	      AND IdFondo      = nIdFondo
         AND NumBenef     = W.NumBenef;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Cambiar a Solicitud Beneficiarios del Fondo No. ' || nIdFondo);
END SOLICITUD;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                 nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
CURSOR BENEF_Q IS
   SELECT NumBenef
     FROM FAI_BENEFICIARIOS_FONDO
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
	   AND IdFondo      = nIdFondo
	   AND StsBenef     = 'ACTIVO';
BEGIN
   FOR W IN BENEF_Q LOOP
      UPDATE FAI_BENEFICIARIOS_FONDO
         SET StsBenef  = 'ANULAD',
             FecStatus = TRUNC(SYSDATE)
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
	      AND IdFondo      = nIdFondo
         AND NumBenef     = W.NumBenef;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Anular Beneficiarios del Fondo No. ' || nIdFondo);
END ANULAR;

PROCEDURE REACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                    nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
CURSOR BENEF_Q IS
   SELECT NumBenef
     FROM FAI_BENEFICIARIOS_FONDO
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo
      AND StsBenef     = 'ANULAD';
BEGIN
   FOR W IN BENEF_Q LOOP
      UPDATE FAI_BENEFICIARIOS_FONDO
         SET StsBenef   = 'ACTIVO',
             FecStatus  = TRUNC(SYSDATE)
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
         AND IdFondo      = nIdFondo
         AND NumBenef     = W.NumBenef;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Reactivar Beneficiarios del Fondo No. ' || nIdFondo);
END REACTIVAR;

PROCEDURE EXCLUIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                  nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                  nNumBenef NUMBER, cCodMotExc VARCHAR2, cTextMotvExc VARCHAR2, 
                  dFecExclusion DATE) IS
BEGIN
   UPDATE FAI_BENEFICIARIOS_FONDO
      SET StsBenef        = 'EXCLUI',
          FecStatus       = TRUNC(SYSDATE),
          FecExclusion    = dFecExclusion,
          CodMotvExc      = cCodMotExc,
          TextMotvExc     = cTextMotvExc
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCodAsegurado
      AND IdFondo       = nIdFondo
      AND NumBenef      = nNumBenef;
END EXCLUIR;

PROCEDURE RENOVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                  nCodAsegurado NUMBER, nIdFondoOrig NUMBER, nIdPolizaRen NUMBER, nIdFondoDest NUMBER) IS
CURSOR BENEF_Q IS
   SELECT NumBenef, CodParent, PorcPart, Observaciones, NivPrioridad
     FROM FAI_BENEFICIARIOS_FONDO
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondoOrig;
BEGIN
   FOR X IN BENEF_Q LOOP
      BEGIN
         INSERT INTO FAI_BENEFICIARIOS_FONDO
               (CodCia, CodEmpresa, IdPoliza, IDetPol, CodAsegurado, 
                IdFondo, NumBenef, StsBenef, FecStatus, CodParent,
                FecIngreso, PorcPart, Observaciones, NivPrioridad)
         VALUES(nCodCia, nCodEmpresa, nIdPolizaRen, nIDetPol, nCodAsegurado, 
                nIdFondoDest, X.NumBenef, 'XRENOV', TRUNC(SYSDATE), X.CodParent,
                TRUNC(SYSDATE), X.PorcPart, X.Observaciones, X.NivPrioridad);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20100,'Error al Copiar Beneficiarios del Fondo No. ' || nIdFondoDest);
      END;
   END LOOP;
END RENOVAR;

END GT_FAI_BENEFICIARIOS_FONDO;
/

--
-- GT_FAI_BENEFICIARIOS_FONDO  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_BENEFICIARIOS_FONDO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_BENEFICIARIOS_FONDO FOR SICAS_OC.GT_FAI_BENEFICIARIOS_FONDO
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_FAI_BENEFICIARIOS_FONDO TO PUBLIC
/

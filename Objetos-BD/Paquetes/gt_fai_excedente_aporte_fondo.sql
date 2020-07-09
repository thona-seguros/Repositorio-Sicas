--
-- GT_FAI_EXCEDENTE_APORTE_FONDO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_EXCEDENTE_APORTE_FONDO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_EXCEDENTE_APORTE_FONDO AS

PROCEDURE CREAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                nNumAporte NUMBER, nExcedente NUMBER, cStsExcedente VARCHAR2,
                dFecUltMov DATE, cOrigenExcedente VARCHAR2);

PROCEDURE APLICAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                  nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                  nNumAporte NUMBER, nNumExcedente NUMBER, nIdTransaccion NUMBER);

FUNCTION VERIFICA_SALDO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                        nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER;

FUNCTION NUMERO_EXCEDENTE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                          nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                          nNumAporte NUMBER) RETURN NUMBER;

PROCEDURE REVERTIR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                    nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER, nIdTransaccion NUMBER);

END GT_FAI_EXCEDENTE_APORTE_FONDO;
/

--
-- GT_FAI_EXCEDENTE_APORTE_FONDO  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_EXCEDENTE_APORTE_FONDO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_EXCEDENTE_APORTE_FONDO AS

PROCEDURE CREAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                nNumAporte NUMBER, nExcedente NUMBER, cStsExcedente VARCHAR2,
                dFecUltMov DATE, cOrigenExcedente VARCHAR2) IS

nNumExcedente    FAI_EXCEDENTE_APORTE_FONDO.NumExcedente%TYPE;
BEGIN                
   nNumExcedente := GT_FAI_EXCEDENTE_APORTE_FONDO.NUMERO_EXCEDENTE(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, 
                                                                   nCodAsegurado, nIdFondo, nNumAporte);
  
   INSERT INTO FAI_EXCEDENTE_APORTE_FONDO
         (CodCia, CodEmpresa, IdPoliza, IDetPol, CodAsegurado,
          IdFondo, NumAporte, NumExcedente, Excedente,
          OrigenExcedente, StsExcedente, FecUltMov)
   VALUES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado,
          nIdFondo, nNumAporte, nNumExcedente, nExcedente,
          cOrigenExcedente,cStsExcedente, dFecUltMov);
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error insertando en FAI_EXCEDENTE_APORTE_FONDO '||SQLERRM);
END CREAR;

PROCEDURE APLICAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                  nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                  nNumAporte NUMBER, nNumExcedente NUMBER, nIdTransaccion NUMBER) IS
BEGIN
   UPDATE FAI_EXCEDENTE_APORTE_FONDO
      SET StsExcedente   = 'APLICA',
          FecUltMov      = TRUNC(SYSDATE),
          IdTransaccion  = nIdTransaccion
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo
      AND NumAporte    = nNumAporte
      AND NumExcedente = nNumExcedente;
END APLICAR;

FUNCTION VERIFICA_SALDO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                        nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER IS
nExcedente      FAI_EXCEDENTE_APORTE_FONDO.Excedente%TYPE;
BEGIN
   BEGIN
      SELECT NVL(SUM(Excedente),0)
        INTO nExcedente
        FROM FAI_EXCEDENTE_APORTE_FONDO
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND CodAsegurado  = nCodAsegurado
         AND IdFondo       = nIdFondo
         AND StsExcedente  = 'ACTIVO';
   END;
   RETURN (nExcedente);
END VERIFICA_SALDO;

FUNCTION NUMERO_EXCEDENTE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                          nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                          nNumAporte NUMBER) RETURN NUMBER IS
nNumExcedente   FAI_EXCEDENTE_APORTE_FONDO.NumExcedente%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MAX(NumExcedente),1)
        INTO nNumExcedente
        FROM FAI_EXCEDENTE_APORTE_FONDO
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
         AND IdFondo      = nIdFondo
         AND NumAporte    = nNumAporte;
   END;
  
   RETURN (nNumExcedente);
END NUMERO_EXCEDENTE;

PROCEDURE REVERTIR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                    nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER, nIdTransaccion NUMBER) IS
CURSOR cExcedentes IS
   SELECT NumAporte, NumExcedente
     FROM FAI_EXCEDENTE_APORTE_FONDO
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCodAsegurado
      AND IdFondo       = nIdFondo
      AND IdTransaccion = nIdTransaccion;
BEGIN
   BEGIN
      DELETE FAI_EXCEDENTE_APORTE_FONDO
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND IdPoliza        = nIdPoliza
         AND IDetPol         = nIDetPol
         AND CodAsegurado    = nCodAsegurado
         AND IdFondo         = nIdFondo
         AND IdTransaccion   = nIdTransaccion
         AND OrigenExcedente = 'EXCAPL'
         AND StsExcedente    = 'ACTIVO';
   END;

   FOR X in cExcedentes LOOP
      BEGIN
         UPDATE FAI_EXCEDENTE_APORTE_FONDO
            SET StsExcedente    = 'ACTIVO',
                FecUltMov       = TRUNC(SYSDATE),
                IdTransaccion   = NULL
          WHERE CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa
            AND IdPoliza      = nIdPoliza
            AND IDetPol       = nIDetPol
            AND CodAsegurado  = nCodAsegurado
            AND IdFondo       = nIdFondo
            AND IdTransaccion = nIdTransaccion
            AND NumAporte     = X.NumAporte
            AND NumExcedente  = X.NumExcedente;
      END;
   END LOOP;
END REVERTIR;

END GT_FAI_EXCEDENTE_APORTE_FONDO;
/

--
-- GT_FAI_EXCEDENTE_APORTE_FONDO  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_EXCEDENTE_APORTE_FONDO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_EXCEDENTE_APORTE_FONDO FOR SICAS_OC.GT_FAI_EXCEDENTE_APORTE_FONDO
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_FAI_EXCEDENTE_APORTE_FONDO TO PUBLIC
/

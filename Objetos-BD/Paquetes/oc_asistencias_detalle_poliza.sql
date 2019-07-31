--
-- OC_ASISTENCIAS_DETALLE_POLIZA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   ASISTENCIAS_ASEGURADO (Table)
--   ASISTENCIAS_DETALLE_POLIZA (Table)
--   CONFIG_ASISTENCIAS_PLANCOB (Table)
--   OC_ASISTENCIAS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_ASISTENCIAS_DETALLE_POLIZA IS

  PROCEDURE CARGAR_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                               nIdPoliza NUMBER, nIDetPol NUMBER, nTasaCambio NUMBER, cCodMoneda VARCHAR2,
                               dFecIniVig DATE, dFecFinVig DATE);
  PROCEDURE EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER);
  PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER);
  FUNCTION TOTAL_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER;
  PROCEDURE RENOVAR(nCodCia NUMBER, nIdPolizaRen NUMBER, nIdPoliza NUMBER);
  PROCEDURE COPIAR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPolOrig NUMBER, nIdPolizaDest NUMBER, nIDetPolDest NUMBER);
  PROCEDURE EXCLUIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER);
  PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER);
  PROCEDURE REHABILITAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER);

END OC_ASISTENCIAS_DETALLE_POLIZA;
/

--
-- OC_ASISTENCIAS_DETALLE_POLIZA  (Package Body) 
--
--  Dependencies: 
--   OC_ASISTENCIAS_DETALLE_POLIZA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_ASISTENCIAS_DETALLE_POLIZA IS

PROCEDURE CARGAR_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                             nIdPoliza NUMBER, nIDetPol NUMBER, nTasaCambio NUMBER, cCodMoneda VARCHAR2,
                             dFecIniVig DATE, dFecFinVig DATE) IS
nMontoAsistLocal     ASISTENCIAS_ASEGURADO.MontoAsistLocal%TYPE;
nMontoAsistMoneda    ASISTENCIAS_ASEGURADO.MontoAsistMoneda%TYPE;

CURSOR ASIST_Q IS
  SELECT CodAsistencia
    FROM CONFIG_ASISTENCIAS_PLANCOB
   WHERE CodCia          = nCodCia
     AND CodEmpresa      = nCodEmpresa
     AND IdTipoSeg       = cIdTipoSeg
     AND PlanCob         = cPlanCob
     AND IndAsistOblig   = 'S'
     AND StsPlanCobAsist = 'ACTIVA';
BEGIN
   FOR X IN ASIST_Q LOOP
      nMontoAsistMoneda := OC_ASISTENCIAS.CALCULA_ASISTENCIA(nCodCia, nCodEmpresa, X.CodAsistencia,
                                                             dFecIniVig, dFecFinVig);
      nMontoAsistLocal  := nMontoAsistMoneda * nTasaCambio;
      INSERT INTO ASISTENCIAS_DETALLE_POLIZA
             (CodCia, CodEmpresa, IdPoliza, IDetPol, CodAsistencia,
              CodMoneda, MontoAsistLocal, MontoAsistMoneda, StsAsistencia,
              FecSts, IdEndoso)
      VALUES (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, X.CodAsistencia,
              cCodMoneda, nMontoAsistLocal, nMontoAsistMoneda, 'SOLICI',
              TRUNC(SYSDATE), 0);
   END LOOP;
END CARGAR_ASISTENCIAS;

PROCEDURE EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) IS
BEGIN
   UPDATE ASISTENCIAS_DETALLE_POLIZA
      SET StsAsistencia = 'EMITID',
          FecSts        = TRUNC(SYSDATE)
   WHERE CodCia         = nCodCia
     AND CodEmpresa     = nCodEmpresa
     AND IdPoliza       = nIdPoliza
     AND IDetPol        = nIDetPol
     AND IdEndoso       = nIdEndoso
     AND StsAsistencia IN ('SOLICI','XRENOV');
END EMITIR;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) IS
BEGIN
   UPDATE ASISTENCIAS_DETALLE_POLIZA
      SET StsAsistencia = 'ANULAD',
          FecSts        = TRUNC(SYSDATE)
   WHERE CodCia        = nCodCia
     AND CodEmpresa    = nCodEmpresa
     AND IdPoliza      = nIdPoliza
     AND IDetPol       = nIDetPol
     AND StsAsistencia = 'EMITID';
END ANULAR;

FUNCTION TOTAL_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER IS
nMontoAsistLocal      ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
BEGIN
   SELECT NVL(SUM(MontoAsistLocal),0)
     INTO nMontoAsistLocal
     FROM ASISTENCIAS_DETALLE_POLIZA
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdPoliza       = nIdPoliza
      AND IDetPol        = nIDetPol
      AND StsAsistencia != 'ANULAD';

   RETURN(nMontoAsistLocal);
END TOTAL_ASISTENCIAS;

PROCEDURE RENOVAR(nCodCia NUMBER, nIdPolizaRen NUMBER, nIdPoliza NUMBER) IS
CURSOR ASIST_Q IS
   SELECT CodCia, CodEmpresa, IDetPol, CodAsistencia, CodMoneda, 
          MontoAsistLocal, MontoAsistMoneda, StsAsistencia,
          FecSts, IdEndoso
     FROM ASISTENCIAS_DETALLE_POLIZA
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;
BEGIN
   FOR W IN ASIST_Q LOOP
      INSERT INTO ASISTENCIAS_DETALLE_POLIZA
             (CodCia, CodEmpresa, IdPoliza, IDetPol, CodAsistencia,
              CodMoneda, MontoAsistLocal, MontoAsistMoneda, StsAsistencia,
              FecSts, IdEndoso)
      VALUES (W.CodCia, W.CodEmpresa, nIdPoliza, W.IDetPol, W.CodAsistencia,
              W.CodMoneda, W.MontoAsistLocal, W.MontoAsistMoneda, 'XRENOV',
              TRUNC(SYSDATE), 0);
   END LOOP;

   UPDATE ASISTENCIAS_DETALLE_POLIZA
      SET StsAsistencia = 'REN',
          FecSts        = TRUNC(SYSDATE)
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;
END RENOVAR;

PROCEDURE COPIAR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPolOrig NUMBER, nIdPolizaDest NUMBER, nIDetPolDest NUMBER) IS
CURSOR ASIST_Q IS
   SELECT CodCia, CodEmpresa, IDetPol, CodAsistencia, CodMoneda, 
          MontoAsistLocal, MontoAsistMoneda, StsAsistencia,
          FecSts, IdEndoso
     FROM ASISTENCIAS_DETALLE_POLIZA
    WHERE IdPoliza = nIdPoliza
      AND IDetPol  = nIDetPolOrig
      AND CodCia   = nCodCia;
BEGIN
   FOR W IN ASIST_Q LOOP
      INSERT INTO ASISTENCIAS_DETALLE_POLIZA
             (CodCia, CodEmpresa, IdPoliza, IDetPol, CodAsistencia,
              CodMoneda, MontoAsistLocal, MontoAsistMoneda, StsAsistencia,
              FecSts, IdEndoso)
      VALUES (W.CodCia, W.CodEmpresa, nIdPolizaDest, nIDetPolDest, W.CodAsistencia,
              W.CodMoneda, W.MontoAsistLocal, W.MontoAsistMoneda, 'SOLICI',
              TRUNC(SYSDATE), 0);
   END LOOP;
END COPIAR;

PROCEDURE EXCLUIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) IS
BEGIN
   UPDATE ASISTENCIAS_DETALLE_POLIZA
      SET StsAsistencia = 'EXCLUI',
          FecSts        = TRUNC(SYSDATE)
   WHERE CodCia        = nCodCia
     AND CodEmpresa    = nCodEmpresa
     AND IdPoliza      = nIdPoliza
     AND IDetPol       = nIDetPol
     AND StsAsistencia = 'EMITID';
END EXCLUIR;

PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) IS
BEGIN
   UPDATE ASISTENCIAS_DETALLE_POLIZA
      SET StsAsistencia = 'SOLICI',
          FecSts        = TRUNC(SYSDATE)
   WHERE CodCia        = nCodCia
     AND CodEmpresa    = nCodEmpresa
     AND IdPoliza      = nIdPoliza
     AND IDetPol       = nIDetPol
     AND IdEndoso      = nIdEndoso
     AND StsAsistencia = 'EMITID';
END REVERTIR_EMISION;

PROCEDURE REHABILITAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) IS
BEGIN
   UPDATE ASISTENCIAS_DETALLE_POLIZA
      SET StsAsistencia = 'EMITID',
          FecSts        = TRUNC(SYSDATE)
   WHERE CodCia        = nCodCia
     AND CodEmpresa    = nCodEmpresa
     AND IdPoliza      = nIdPoliza
     AND IDetPol       = nIDetPol
     AND StsAsistencia = 'ANULAD';
END REHABILITAR;

END OC_ASISTENCIAS_DETALLE_POLIZA;
/

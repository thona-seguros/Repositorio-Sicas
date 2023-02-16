CREATE OR REPLACE PACKAGE OC_ASISTENCIAS_ASEGURADO IS

  PROCEDURE CARGAR_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                               nIdPoliza NUMBER, nIDetPol NUMBER, nTasaCambio NUMBER, nCod_Asegurado NUMBER,
                               cCodMoneda VARCHAR2, dFecIniVig DATE, dFecFinVig DATE);
  PROCEDURE EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER);
  PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);
  FUNCTION TOTAL_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                             nIDetPol NUMBER, nCod_Asegurado NUMBER) RETURN NUMBER;
  PROCEDURE RENOVAR(nCodCia NUMBER, nIdPolizaRen NUMBER, nIdPoliza NUMBER);
  PROCEDURE COPIAR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPolOrig NUMBER, nIdPolizaDest NUMBER, nIDetPolDest NUMBER);
  PROCEDURE HEREDA_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                               nCod_Asegurado NUMBER,  cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2);
  PROCEDURE EXCLUIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);

  PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER);

  PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER);

  PROCEDURE REHABILITAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);

END OC_ASISTENCIAS_ASEGURADO;
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_ASISTENCIAS_ASEGURADO IS

PROCEDURE CARGAR_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                             nIdPoliza NUMBER, nIDetPol NUMBER, nTasaCambio NUMBER, nCod_Asegurado NUMBER,
                             cCodMoneda VARCHAR2, dFecIniVig DATE, dFecFinVig DATE) IS
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
      BEGIN
         INSERT INTO ASISTENCIAS_ASEGURADO
                (CodCia, CodEmpresa, IdPoliza, IDetPol, Cod_Asegurado, CodAsistencia,
                 CodMoneda, MontoAsistLocal, MontoAsistMoneda, StsAsistencia,
                 FecSts, IdEndoso)
         VALUES (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado, X.CodAsistencia,
                 cCodMoneda, nMontoAsistLocal, nMontoAsistMoneda, 'SOLICI',
                 TRUNC(SYSDATE), 0);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20225,'Existen Asistencias Duplicadas para Detalle de la Póliza: '||
                                    TRIM(TO_CHAR(nIdPoliza))||' - '||TO_CHAR(nIDetPol) || ' y Asegurado '||
                                    nCod_Asegurado);
      END;
   END LOOP;
END CARGAR_ASISTENCIAS;

PROCEDURE EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER) IS
BEGIN
   UPDATE ASISTENCIAS_ASEGURADO
      SET StsAsistencia  = 'EMITID',
          FecSts         = TRUNC(SYSDATE)
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdPoliza       = nIdPoliza
      AND IDetPol        = nIDetPol
      AND IdEndoso       = nIdEndoso
      AND Cod_Asegurado  = nCod_Asegurado
      AND StsAsistencia IN ('SOLICI','XRENOV');
END EMITIR;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
BEGIN
   UPDATE ASISTENCIAS_ASEGURADO
      SET StsAsistencia = 'ANULAD',
          FecSts        = TRUNC(SYSDATE)
   WHERE CodCia        = nCodCia
     AND CodEmpresa    = nCodEmpresa
     AND IdPoliza      = nIdPoliza
     AND IDetPol       = nIDetPol
     AND Cod_Asegurado = nCod_Asegurado
     AND StsAsistencia = 'EMITID';
END ANULAR;

FUNCTION TOTAL_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                           nIDetPol NUMBER, nCod_Asegurado NUMBER) RETURN NUMBER IS
nMontoAsistLocal      ASISTENCIAS_ASEGURADO.MontoAsistLocal%TYPE;
BEGIN
   SELECT NVL(SUM(MontoAsistLocal),0)
     INTO nMontoAsistLocal
     FROM ASISTENCIAS_ASEGURADO
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdPoliza       = nIdPoliza
      AND IDetPol        = nIDetPol
      AND Cod_Asegurado  = nCod_Asegurado
      AND StsAsistencia != 'ANULAD';

   RETURN(nMontoAsistLocal);
END TOTAL_ASISTENCIAS;

PROCEDURE RENOVAR(nCodCia NUMBER, nIdPolizaRen NUMBER, nIdPoliza NUMBER) IS
CURSOR ASIST_Q IS
   SELECT CodCia, CodEmpresa, IDetPol, Cod_Asegurado, CodAsistencia,
          CodMoneda, MontoAsistLocal, MontoAsistMoneda, StsAsistencia,
          FecSts, IdEndoso
     FROM ASISTENCIAS_ASEGURADO
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;
BEGIN
   FOR P IN ASIST_Q LOOP
      BEGIN
         INSERT INTO ASISTENCIAS_ASEGURADO
                (CodCia, CodEmpresa, IdPoliza, IDetPol, Cod_Asegurado, CodAsistencia,
                 CodMoneda, MontoAsistLocal, MontoAsistMoneda, StsAsistencia,
                 FecSts, IdEndoso)
         VALUES (P.CodCia, P.CodEmpresa, nIdPoliza, P.IDetPol, P.Cod_Asegurado, P.CodAsistencia,
                 P.CodMoneda, P.MontoAsistLocal, P.MontoAsistMoneda, 'XRENOV',
                 TRUNC(SYSDATE), 0);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20225,'Existen Asistencias Duplicadas para Detalle de la Póliza: '||
                                    TRIM(TO_CHAR(nIdPoliza))||' - '||TO_CHAR(P.IDetPol) || ' y Asegurado '||
                                    P.Cod_Asegurado);
      END;
   END LOOP;

   UPDATE ASISTENCIAS_ASEGURADO
      SET StsAsistencia = 'RENOVA',
          FecSts        = TRUNC(SYSDATE)
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;
END RENOVAR;

PROCEDURE COPIAR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPolOrig NUMBER, nIdPolizaDest NUMBER, nIDetPolDest NUMBER) IS
CURSOR ASIST_Q IS
   SELECT CodCia, CodEmpresa, IDetPol, Cod_Asegurado, CodAsistencia,
          CodMoneda, MontoAsistLocal, MontoAsistMoneda, StsAsistencia,
          FecSts, IdEndoso
     FROM ASISTENCIAS_ASEGURADO
    WHERE IdPoliza = nIdPoliza
      AND IDetPol  = nIDetPolOrig
      AND CodCia   = nCodCia;
BEGIN
   FOR P IN ASIST_Q LOOP
      BEGIN
         INSERT INTO ASISTENCIAS_ASEGURADO
                (CodCia, CodEmpresa, IdPoliza, IDetPol, Cod_Asegurado, CodAsistencia,
                 CodMoneda, MontoAsistLocal, MontoAsistMoneda, StsAsistencia,
                 FecSts, IdEndoso)
         VALUES (P.CodCia, P.CodEmpresa, nIdPolizaDest, nIDetPolDest, P.Cod_Asegurado, P.CodAsistencia,
                 P.CodMoneda, P.MontoAsistLocal, P.MontoAsistMoneda, 'SOLICI',
                 TRUNC(SYSDATE), 0);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20225,'Existen Asistencias Duplicadas para Detalle de la Póliza: '||
                                    TRIM(TO_CHAR(nIdPolizaDest))||' - '||TO_CHAR(nIDetPolDest) || ' y Asegurado '||
                                    P.Cod_Asegurado);
      END;
   END LOOP;
END COPIAR;

PROCEDURE HEREDA_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                            nCod_Asegurado NUMBER,  cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) IS
nIdEndoso    ASEGURADO_CERTIFICADO.IdEndoso%TYPE;
CURSOR ASIST_Q IS
   SELECT CodAsistencia, CodMoneda, MontoAsistLocal, MontoAsistMoneda,
          StsAsistencia, FecSts, IdEndoso
     FROM ASISTENCIAS_ASEGURADO
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado;
CURSOR ASEG_Q IS
   SELECT Cod_Asegurado, Estado, IdEndoso
     FROM ASEGURADO_CERTIFICADO
    WHERE CodCia         = nCodCia
      AND IdPoliza       = nIdPoliza
      AND IDetPol        = nIDetPol
      AND IdEndoso       = nIdEndoso
      AND Cod_Asegurado != nCod_Asegurado
      AND Estado        IN ('SOL','XRE');
BEGIN
   BEGIN
      SELECT IdEndoso
        INTO nIdEndoso
        FROM ASEGURADO_CERTIFICADO
       WHERE CodCia         = nCodCia
         AND IdPoliza       = nIdPoliza
         AND IDetPol        = nIDetPol
         AND Cod_Asegurado  = nCod_Asegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'No Existe Asegurado: ' || nCod_Asegurado || ' en Póliza y Detalle No. ' ||
                                TRIM(TO_CHAR(nIdPoliza))||' - '||TO_CHAR(nIDetPol));
   END;

   FOR W IN ASEG_Q LOOP
      DELETE ASISTENCIAS_ASEGURADO
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdPoliza       = nIdPoliza
         AND IdetPol        = nIDetPol
         AND StsAsistencia IN ('SOLICI','XRENOV')
         AND Cod_Asegurado  = W.Cod_Asegurado;

      FOR Z IN ASIST_Q LOOP
         BEGIN
            INSERT INTO ASISTENCIAS_ASEGURADO
                   (CodCia, CodEmpresa, IdPoliza, IDetPol, Cod_Asegurado, CodAsistencia,
                    CodMoneda, MontoAsistLocal, MontoAsistMoneda, StsAsistencia,
                    FecSts, IdEndoso)
            VALUES (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, W.Cod_Asegurado, Z.CodAsistencia,
                    Z.CodMoneda, Z.MontoAsistLocal, Z.MontoAsistMoneda, DECODE(W.Estado,'SOL','SOLICI','XRENOV'),
                    TRUNC(SYSDATE), Z.IdEndoso);
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
               RAISE_APPLICATION_ERROR(-20225,'Existen Asistencias Duplicadas para Detalle de la Póliza: '||
                                       TRIM(TO_CHAR(nIdPoliza))||' - '||TO_CHAR(nIDetPol) || ' y Asegurado '||
                                       W.Cod_Asegurado);
         END;
      END LOOP;
      OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIdetPol, W.Cod_Asegurado);
      OC_ASEGURADO_CERTIFICADO.ACTUALIZA_ASISTENCIAS(nCodCia, nCodEmpresa, nIdPoliza, nIdetPol, W.Cod_Asegurado);
   END LOOP;
   IF nIdEndoso = 0 THEN
      OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIDetPol, 0);
      OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);
   ELSE
      OC_ENDOSO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
   END IF;
END HEREDA_ASISTENCIAS;

PROCEDURE EXCLUIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
BEGIN
   UPDATE ASISTENCIAS_ASEGURADO
      SET StsAsistencia = 'EXCLUI',
          FecSts        = TRUNC(SYSDATE)
   WHERE CodCia        = nCodCia
     AND CodEmpresa    = nCodEmpresa
     AND IdPoliza      = nIdPoliza
     AND IDetPol       = nIDetPol
     AND Cod_Asegurado = nCod_Asegurado
     AND StsAsistencia = 'EMITID';
END EXCLUIR;

PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                           nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER) IS
BEGIN
   UPDATE ASISTENCIAS_ASEGURADO
      SET StsAsistencia = 'SOLICI',
          FecSts        = TRUNC(SYSDATE)
   WHERE CodCia        = nCodCia
     AND CodEmpresa    = nCodEmpresa
     AND IdPoliza      = nIdPoliza
     AND IDetPol       = nIDetPol
     AND IdEndoso      = nIdEndoso
     AND Cod_Asegurado = nCod_Asegurado
     AND StsAsistencia = 'EMITID';
END REVERTIR_EMISION;

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER, nIdEndoso NUMBER) IS
BEGIN
   DELETE ASISTENCIAS_ASEGURADO
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdPoliza       = nIdPoliza
      AND IdetPol        = nIDetPol
      AND Cod_Asegurado  = nCod_Asegurado
      AND IdEndoso       = nIdEndoso;
END ELIMINAR;

PROCEDURE REHABILITAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
BEGIN
   UPDATE ASISTENCIAS_ASEGURADO
      SET StsAsistencia = 'EMITID',
          FecSts        = TRUNC(SYSDATE)
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado
      AND StsAsistencia = 'ANULAD';
END REHABILITAR;

END OC_ASISTENCIAS_ASEGURADO;

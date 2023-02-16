CREATE OR REPLACE PACKAGE          GT_FAI_CONCENTRADORA_FONDO AS

FUNCTION NUMERO_MOVIMIENTO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                           nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER;

FUNCTION SALDO_CONCENTRADORA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                             nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                             dFecCalc IN DATE) RETURN NUMBER;

PROCEDURE SALDO_CONCENTRADORA_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, dFecSaldo IN DATE,
                                     cVerificaEvalua VARCHAR, nSaldoTotLocal IN OUT NUMBER, nSaldoTotMoneda IN OUT NUMBER);

PROCEDURE ACTIVA_MOVIMIENTOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                             nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                             nIdTransaccion NUMBER);

PROCEDURE ACTIVA_MOV_INFORMATIVOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                  nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                                  nIdTransaccion NUMBER);

PROCEDURE ELIMINA_MOVIMIENTOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                              nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                              nIdTransaccion NUMBER);

PROCEDURE INSERTA_MOV_CONCENTRADORA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                    nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                                    cCodCptoMov VARCHAR2, nIdTransaccion NUMBER, cCodMoneda VARCHAR2,
                                    nMontoMovMoneda IN OUT NUMBER,  nMontoMovLocal IN OUT NUMBER,
                                    cTipoTasa VARCHAR2, nTasaCambioMov NUMBER,
                                    dFecTasaCambio DATE, dFecMovimiento DATE, cDescMovimiento VARCHAR2);

PROCEDURE APLICA_CARGOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                        nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                        nIdFondo NUMBER, nIdMovimiento NUMBER, dFecMovimiento DATE,
                        cCodCargo VARCHAR2, nMontoMovOrig NUMBER, nIdTransaccion NUMBER);

FUNCTION CALCULA_CARGO_ABONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                             nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                             nIdFondo NUMBER, cCodigo VARCHAR2, cTipoCalc VARCHAR2,
                             nMtoBase NUMBER, cIndRetorno VARCHAR2, dFecMovimiento DATE,
                             cTipoCargoBono IN OUT VARCHAR2, cPeriodoCargoBono IN OUT VARCHAR2,
                             nPorcCargoBono IN OUT NUMBER, cTipoInteres IN OUT VARCHAR2,
                             cCodRutinaCalc IN OUT VARCHAR2, nMontoMovOrig NUMBER,
                             nMontoFijo IN OUT NUMBER, nTasaCambioMov NUMBER, nIdTransaccion NUMBER) RETURN NUMBER;

FUNCTION CALCULO_RUTINA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                        nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                        nIdFondo NUMBER, cCodRutinaCalc IN OUT VARCHAR2, cTipoCalc VARCHAR2,
                        dFecCalc  DATE, cCodCptoMov VARCHAR2, nMontoMov NUMBER,
                        nIdTransaccion NUMBER) RETURN NUMBER;

FUNCTION EXISTE_FEE_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                           nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                           cCptoMovFondo VARCHAR2) RETURN VARCHAR2;

PROCEDURE APLICA_BONOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                        nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                        nIdFondo NUMBER, nIdMovimiento NUMBER, dFecMovimiento DATE,
                        cCodBono VARCHAR2, nMontoMovOrig NUMBER, nIdTransaccion NUMBER);

PROCEDURE APLICA_RETENCION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                           nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                           nIdFondo NUMBER, nIdMovimiento NUMBER, dFecMovimiento DATE,
                           cCodCptoRet VARCHAR2, nMontoMovOrig NUMBER, nIdTransaccion NUMBER,
                           nDiasPeriodicidad NUMBER DEFAULT NULL);

PROCEDURE CALCULA_ADMIN(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                        nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                        nIdFondo NUMBER, dFecCalcFee DATE, nSaldoFondo NUMBER,
                        cTipoProceso VARCHAR2, nMontoFee IN OUT NUMBER);

FUNCTION FECHA_INICIO_ALTURA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                             nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                             dFecIniVig DATE) RETURN DATE;

PROCEDURE CALCULA_OTROS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                        nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                        nIdFondo NUMBER, cCodMovim VARCHAR2, dFecCalculo DATE,
                        nSaldoFondo NUMBER, cTipoProceso VARCHAR2, nMontoCargo IN OUT NUMBER );

PROCEDURE CALCULA_INTERES_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                                nIdFondo NUMBER, dFecCalcInt DATE, nSaldoFondo NUMBER,
                                cTipoProceso VARCHAR2, nMontoInteres IN OUT NUMBER);

PROCEDURE CALCULA_INFLACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                            nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                            nIdFondo NUMBER, dFecCalcInf DATE, nSaldoFondo NUMBER);

PROCEDURE RESCATE_AUTOMATICO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                             nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                             nIdFondo NUMBER, dFecRescate DATE, cIndCancelacion VARCHAR2);

PROCEDURE CARGOS_MESVERSARIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                             nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                             nIdFondo NUMBER, dFecCalc DATE, cTipoProceso VARCHAR2,
                             nMontoCargo IN OUT NUMBER);

FUNCTION MESVERSARIO(dFecEmision DATE, dFecCalc DATE, cTipoAplic VARCHAR2) RETURN VARCHAR2;

FUNCTION ASIGNA_FECHA_PROG_RETIRO(dFechaBase DATE) RETURN DATE;

PROCEDURE APLICA_MOV_INTERESCARGO_DIARIO(nCodCia NUMBER, nCodEmpresa NUMBER);

PROCEDURE TRASPASO_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPolizaOrig NUMBER, nIDetPolOrig NUMBER,
                          nCodAseguradoOrig NUMBER, cTipoFondoOrig VARCHAR2, nIdFondoOrig IN OUT NUMBER,
                          cCodCptoMovOrig VARCHAR2, nIdPolizaDest NUMBER, nIDetPolDest NUMBER,
                          nCodAseguradoDest NUMBER,  nIdFondoDest IN OUT NUMBER, cTipoFondoDest VARCHAR2,
                          cCodCptoMovDest VARCHAR2, cTipoTraspaso VARCHAR2, dFecTraspaso DATE,
                          nMontoTraspaso NUMBER, cTipoTasa VARCHAR2, dFecTasaCambio DATE, nTasaCambio NUMBER,
                          cOrigenTraspaso VARCHAR2 DEFAULT NULL);

FUNCTION REVISA_RETIROS_EXISTENTES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                   nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                                   cCodCptoMov VARCHAR2, dFecIni DATE, dFecFin DATE ) RETURN NUMBER;

PROCEDURE ACTUALIZA_FACTURA_MOVIMIENTOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                        nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                                        nIdTransaccion NUMBER, nIdFactura NUMBER);

FUNCTION ES_FACTURA_DE_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                              nIDetPol NUMBER, nIdFactura NUMBER) RETURN VARCHAR2;

FUNCTION MONTO_CONCEPTO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                        nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                        cTipoMovimiento VARCHAR2, dFecInicial IN DATE, dFecFinal IN DATE) RETURN NUMBER;

FUNCTION TOTAL_MOVIMIENTOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                           nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                           cTipoMovimiento VARCHAR2, dFecInicial IN DATE, dFecFinal IN DATE) RETURN NUMBER;

PROCEDURE ELIMINA_MOV_SOLICITUD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER);

END GT_FAI_CONCENTRADORA_FONDO;

/
create or replace PACKAGE BODY          GT_FAI_CONCENTRADORA_FONDO AS

FUNCTION NUMERO_MOVIMIENTO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                           nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER IS
nIdMovimiento      FAI_CONCENTRADORA_FONDO.IdMovimiento%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MAX(IdMovimiento),0)+1
        INTO nIdMovimiento
        FROM FAI_CONCENTRADORA_FONDO
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND IdPoliza        = nIdPoliza
         AND IDetPol         = nIDetPol
         AND CodAsegurado    = nCodAsegurado
         AND IdFondo         = nIdFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nIdMovimiento := 1;
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR( -20100, 'Error al Seleccionar Número de Movimiento de la Concentradora del Fondo ' || SQLERRM);
   END;
   RETURN(nIdMovimiento);
END NUMERO_MOVIMIENTO;

FUNCTION SALDO_CONCENTRADORA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                             nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                             dFecCalc IN DATE) RETURN NUMBER IS
nMontoMovMoneda      FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
BEGIN
   BEGIN
      SELECT NVL(SUM(MontoMovMoneda),0)
        INTO nMontoMovMoneda
        FROM FAI_CONCENTRADORA_FONDO
       WHERE CodCia                = nCodCia
         AND CodEmpresa            = nCodEmpresa
         AND IdPoliza              = nIdPoliza
         AND IDetPol               = nIDetPol
         AND CodAsegurado          = nCodAsegurado
         AND IdFondo               = nIdFondo
         AND TRUNC(FecMovimiento) <= TRUNC(dFecCalc)
         AND StsMovimiento         = 'ACTIVO';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMontoMovMoneda := 0;
   END;
   RETURN(nMontoMovMoneda);
END SALDO_CONCENTRADORA;


PROCEDURE SALDO_CONCENTRADORA_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, dFecSaldo IN DATE,
                                     cVerificaEvalua VARCHAR, nSaldoTotLocal IN OUT NUMBER, nSaldoTotMoneda IN OUT NUMBER ) IS
nSaldoMoneda           FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nSaldoLocal            FAI_CONCENTRADORA_FONDO.MontoMovLocal%TYPE;
CURSOR FONDO_Q IS
    SELECT IdPoliza, IDetPol, CodAsegurado, IdFondo,
           GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(CodCia, CodEmpresa, TipoFondo) CodMoneda,
           GT_FAI_TIPOS_DE_FONDOS.INDICADORES(CodCia, CodEmpresa, TipoFondo, 'IR') IndAplicaIR
      FROM FAI_FONDOS_DETALLE_POLIZA
     WHERE CodCia          = nCodCia
       AND CodEmpresa      = nCodEmpresa
       AND IdPoliza        = nIdPoliza
       AND IDetPol         > 0
       AND CodAsegurado    > 0
       AND StsFondo        = 'EMITID';
BEGIN
   nSaldoTotLocal  := 0;
   nSaldoTotMoneda := 0;

   FOR W IN FONDO_Q LOOP
      IF cVerificaEvalua = 'INTERESREAL' THEN

         IF W.IndAplicaIR = 'S' THEN   -- Aplica a los fondos que lo tengan
             nSaldoMoneda := GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza,
                                                                            W.IDetPol, W.CodAsegurado, W.IdFondo, dFecSaldo);
             nSaldoLocal  := nSaldoMoneda * OC_GENERALES.FUN_TASA_CAMBIO(W.CodMoneda, dFecSaldo );

             nSaldoTotMoneda := nSaldoTotMoneda + NVL( nSaldoMoneda, 0);
             nSaldoTotLocal  := nSaldoTotLocal  + NVL(  nSaldoLocal, 0);
          END IF;
       ELSE
          nSaldoMoneda := GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza,
                                                                         W.IDetPol, W.CodAsegurado, W.IdFondo, dFecSaldo);
          nSaldoLocal  := nSaldoMoneda * OC_GENERALES.FUN_TASA_CAMBIO(W.CodMoneda, dFecSaldo );

          nSaldoTotLocal  := nSaldoTotLocal  + NVL(  nSaldoLocal, 0);
          nSaldoTotMoneda := nSaldoTotMoneda + NVL( nSaldoMoneda, 0);
       END IF;
   END LOOP;
END SALDO_CONCENTRADORA_POLIZA;

PROCEDURE ACTIVA_MOVIMIENTOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                             nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                             nIdTransaccion NUMBER) IS
BEGIN
   UPDATE FAI_CONCENTRADORA_FONDO
      SET StsMovimiento   = 'ACTIVO',
          FecStatus       = TRUNC(SYSDATE)
    WHERE CodCia          = nCodCia
      AND CodEmpresa      = nCodEmpresa
      AND IdPoliza        = nIdPoliza
      AND IDetPol         = nIDetPol
      AND CodAsegurado    = nCodAsegurado
      AND IdFondo         = nIdFondo
      AND IdTransaccion   = nIdTransaccion
      AND FecMovimiento  <= TRUNC(SYSDATE);
END ACTIVA_MOVIMIENTOS;

PROCEDURE ACTIVA_MOV_INFORMATIVOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                  nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                                  nIdTransaccion NUMBER) IS
cTipoFondo       FAI_TIPOS_DE_FONDOS.TipoFondo%TYPE;
CURSOR MOV_INF_Q IS
   SELECT CodCptoMov
     FROM FAI_CONCENTRADORA_FONDO
    WHERE CodCia          = nCodCia
      AND CodEmpresa      = nCodEmpresa
      AND IdPoliza        = nIdPoliza
      AND IDetPol         = nIDetPol
      AND CodAsegurado    = nCodAsegurado
      AND IdFondo         = nIdFondo
      AND IdTransaccion   = nIdTransaccion;
BEGIN
   cTipoFondo := GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(nIdFondo);
   FOR W IN MOV_INF_Q LOOP
      IF GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(nCodCia, nCodEmpresa, cTipoFondo, W.CodCptoMov, 'NS') = 'S' THEN
         UPDATE FAI_CONCENTRADORA_FONDO
            SET StsMovimiento   = 'INFORM',
                FecStatus       = TRUNC(SYSDATE)
          WHERE CodCia          = nCodCia
            AND CodEmpresa      = nCodEmpresa
            AND IdPoliza        = nIdPoliza
            AND IDetPol         = nIDetPol
            AND CodAsegurado    = nCodAsegurado
            AND IdFondo         = nIdFondo
            AND IdTransaccion   = nIdTransaccion
            AND CodCptoMov      = W.CodCptoMov;
       END IF;
   END LOOP;
END ACTIVA_MOV_INFORMATIVOS;

PROCEDURE ELIMINA_MOVIMIENTOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                              nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                              nIdTransaccion NUMBER) IS
BEGIN
   DELETE DETALLE_TRANSACCION
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdTransaccion = nIdTransaccion;

   DELETE TRANSACCION
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdTransaccion = nIdTransaccion;

   DELETE FAI_CONCENTRADORA_FONDO
    WHERE CodCia          = nCodCia
      AND CodEmpresa      = nCodEmpresa
      AND IdPoliza        = nIdPoliza
      AND IDetPol         = nIDetPol
      AND CodAsegurado    = nCodAsegurado
      AND IdFondo         = nIdFondo
      AND IdTransaccion   = nIdTransaccion;
END ELIMINA_MOVIMIENTOS;

PROCEDURE INSERTA_MOV_CONCENTRADORA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                    nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                                    cCodCptoMov VARCHAR2, nIdTransaccion NUMBER, cCodMoneda VARCHAR2,
                                    nMontoMovMoneda IN OUT NUMBER,  nMontoMovLocal IN OUT NUMBER,
                                    cTipoTasa VARCHAR2, nTasaCambioMov NUMBER,
                                    dFecTasaCambio DATE, dFecMovimiento DATE, cDescMovimiento VARCHAR2) IS

nIdMovimiento       FAI_CONCENTRADORA_FONDO.IdMovimiento%TYPE;
nMontoOrigen        FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
cTipoFondo          FAI_TIPOS_DE_FONDOS.TipoFondo%TYPE;
cCodRutinaCalc      FAI_MOVIMIENTOS_FONDOS.CodRutinaCalc%TYPE;
cCodCptoRet         FAI_MOVIMIENTOS_FONDOS.CodCptoRet%TYPE;
cCodCptoMovCargo    FAI_MOVIMIENTOS_FONDOS.CodCptoMov%TYPE;
cCodCptoMovBono     FAI_MOVIMIENTOS_FONDOS.CodCptoMov%TYPE;

BEGIN
   cTipoFondo     := GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(nIdFondo);
   cCodRutinaCalc := GT_FAI_MOVIMIENTOS_FONDOS.RUTINA_CALCULO(nCodCia, nCodEmpresa, cTipoFondo, cCodCptoMov);
   nIdMovimiento  := GT_FAI_CONCENTRADORA_FONDO.NUMERO_MOVIMIENTO(nCodCia, nCodEmpresa, nIdPoliza,
                                                                  nIDetPol, nCodAsegurado, nIdFondo);
   IF cCodRutinaCalc IS NOT NULL AND
      GT_FAI_MOVIMIENTOS_FONDOS.TIPO_MOVIMIENTO(nCodCia, nCodEmpresa, cTipoFondo, cCodCptoMov) IN ('RT','RP','TR','RX','RPP') THEN
      nMontoOrigen    := NVL(nMontoMovMoneda,0);
      nMontoMovMoneda := GT_FAI_CONCENTRADORA_FONDO.CALCULO_RUTINA(nCodCia, nCodEmpresa, nIdPoliza,
                                                                   nIDetPol, nCodAsegurado, cTipoFondo,
                                                                   nIdFondo, cCodRutinaCalc, 'M',
                                                                   dFecMovimiento, cCodCptoMov, nMontoMovMoneda,
                                                                   nIdTransaccion);
      nMontoMovLocal  := NVL(nMontoMovMoneda,0) * nTasaCambioMov;
      IF cCodRutinaCalc = 'CALCRETINT' THEN
         nMontoOrigen    := NVL(nMontoMovMoneda,0);
      ELSIF cCodRutinaCalc = 'CALCSOBMTO' THEN
         nMontoOrigen    := NVL(nMontoMovMoneda,0);
      END IF;
   ELSE
      nMontoOrigen    := NVL(nMontoMovMoneda,0);
   END IF;
   IF OC_CATALOGO_DE_CONCEPTOS.SIGNO_CONCEPTO(nCodCia, cCodCptoMov) = '-' AND nMontoMovMoneda > 0 AND
      GT_FAI_MOVIMIENTOS_FONDOS.TIPO_MOVIMIENTO(nCodCia, nCodEmpresa, cTipoFondo, cCodCptoMov) != 'RV' THEN
      nMontoMovLocal  := -nMontoMovLocal;
      nMontoMovMoneda := -nMontoMovMoneda;
   END IF;
   BEGIN
      INSERT INTO FAI_CONCENTRADORA_FONDO
            (CodCia, CodEmpresa, IdPoliza, IDetPol, CodAsegurado, IdFondo,
             IdMovimiento, CodCptoMov, IdTransaccion, IdTransaccionAnu,
             TipoTasa, CodMonedaPago, TasaCambioMov, FecTasaCambio,
             MontoMovMoneda, MontoMovLocal, FecMovimiento, DescMovimiento,
             StsMovimiento, FecStatus, FechaConf, IdFormaPago,
             CodUsuario, FecRealRegistro, IdFactura)
      VALUES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo,
             nIdMovimiento, cCodCptoMov, nIdTransaccion, NULL,
             cTipoTasa, cCodMoneda, nTasaCambioMov, dFecTasaCambio,
             nMontoMovMoneda, nMontoMovLocal, dFecMovimiento, cDescMovimiento,
             'SOLICI', TRUNC(SYSDATE), NULL, NULL, USER, TRUNC(SYSDATE), 0);
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error al Insertar Movimiento en Concentradora de Fondo '||
                                 nIdFondo || ' ' || SQLERRM);
   END;

   IF (NVL(nIdTransaccion,0) > 0 AND
      OC_POLIZAS.ALTURA_CERO(nCodCia, nCodEmpresa,nIdPoliza) = 'N' AND
      OC_POLIZAS.APLICA_RETIRO_PRIMA_NIVELADA(nCodCia, nCodEmpresa, nIdPoliza) = 'N') OR 
      (NVL(nIdTransaccion,0) > 0 AND 
      GT_FAI_MOVIMIENTOS_FONDOS.TIPO_MOVIMIENTO(nCodCia, nCodEmpresa, cTipoFondo, cCodCptoMov) != 'RPP') THEN
      OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa,  21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                  nIdPoliza, nIDetPol, nIdFondo, cCodCptoMov, NVL(nMontoMovMoneda,0));
   END IF;

   IF GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(nCodCia, nCodEmpresa, cTipoFondo, cCodCptoMov, 'AB')  = 'S' THEN
      cCodCptoMovBono := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_BONO(nCodCia, nCodEmpresa, cTipoFondo, cCodCptoMov);
      GT_FAI_CONCENTRADORA_FONDO.APLICA_BONOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado,
                                              cTipoFondo, nIdFondo, nIdMovimiento,
                                              dFecMovimiento, cCodCptoMovBono, NVL(nMontoOrigen,0), nIdTransaccion );
   END IF;

   IF GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(nCodCia, nCodEmpresa, cTipoFondo, cCodCptoMov, 'AC')  = 'S' THEN
      cCodCptoMovCargo := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_CARGO(nCodCia, nCodEmpresa, cTipoFondo, cCodCptoMov);

      GT_FAI_CONCENTRADORA_FONDO.APLICA_CARGOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado,
                                               cTipoFondo, nIdFondo, nIdMovimiento,
                                               dFecMovimiento, cCodCptoMovCargo, NVL(nMontoOrigen,0), nIdTransaccion );
   END IF;
   IF GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(nCodCia, nCodEmpresa, cTipoFondo, cCodCptoMov, 'AR')  = 'S' THEN
      cCodCptoRet := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_RETENCION(nCodCia, nCodEmpresa, cTipoFondo, cCodCptoMov);

      GT_FAI_CONCENTRADORA_FONDO.APLICA_RETENCION(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado,
                                                  cTipoFondo, nIdFondo, nIdMovimiento, dFecMovimiento, cCodCptoRet,
                                                  NVL(nMontoOrigen,0), nIdTransaccion, 0);
   END IF;

END INSERTA_MOV_CONCENTRADORA;

PROCEDURE APLICA_CARGOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                        nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                        nIdFondo NUMBER, nIdMovimiento NUMBER, dFecMovimiento DATE,
                        cCodCargo VARCHAR2, nMontoMovOrig NUMBER, nIdTransaccion NUMBER) IS

cTipoCargo        FAI_CARGOS_FONDOS.TipoCargo%TYPE;
cPeriodoCargo     FAI_CARGOS_FONDOS.PeriodoCargo%TYPE;
cCptoMovFondo     FAI_CARGOS_FONDOS.CptoMovFondo%TYPE;
cTipoAplic        FAI_CARGOS_FONDOS.TipoAplic%TYPE;
nPorcCargo        FAI_CARGOS_FONDOS_DET.PorcCargo%TYPE;
cTipoInteres      FAI_CARGOS_FONDOS_DET.TipoInteres%TYPE;
cCodRutinaCalc    FAI_CARGOS_FONDOS_DET.CodRutinaCalc%TYPE;
nMontoCargo       FAI_CARGOS_FONDOS_DET.MontoCargo%TYPE;
nMtoCargoLocal    FAI_CONCENTRADORA_FONDO.MontoMovLocal%TYPE;
nMtoCargoMoneda   FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
cTipoTasa         FAI_CONCENTRADORA_FONDO.TipoTasa%TYPE;
nTasaCambioMov    FAI_CONCENTRADORA_FONDO.TasaCambioMov%TYPE;
dFecTasaCambio    FAI_CONCENTRADORA_FONDO.FecTasaCambio%TYPE;
nMontoMovMoneda   FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
cDescMovFondo     FAI_CONCENTRADORA_FONDO.DescMovimiento%TYPE;
cTipoMov          FAI_MOVIMIENTOS_FONDOS.TipoMov%TYPE;
cCodMoneda        FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
BEGIN
   BEGIN
      SELECT CptoMovFondo, TipoAplic, TipoCargo
        INTO cCptoMovFondo, cTipoAplic, cTipoCargo
        FROM FAI_CARGOS_FONDOS
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND CodCargo     = cCodCargo
         AND TipoFondo    = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'NO Existe Configurado el Cargo ' || cCodCargo);
   END;

   BEGIN
      SELECT C.TipoTasa, C.TasaCambioMov, C.FecTasaCambio,
             DECODE(nMontoMovOrig,0,C.MontoMovMoneda,nMontoMovOrig), M.TipoMov
        INTO cTipoTasa, nTasaCambioMov, dFecTasaCambio,
             nMontoMovMoneda, cTipoMov
        FROM FAI_CONCENTRADORA_FONDO C, FAI_FONDOS_DETALLE_POLIZA F, FAI_MOVIMIENTOS_FONDOS M
       WHERE M.CodCia       = F.CodCia
         AND M.CodEmpresa   = F.CodEmpresa
         AND M.CodCptoMov   = C.CodCptoMov
         AND M.TipoFondo    = F.TipoFondo
         AND F.CodCia       = C.CodCia
         AND F.CodEmpresa   = C.CodEmpresa
         AND F.IdPoliza     = C.IdPoliza
         AND F.IDetPol      = C.IDetPol
         AND F.CodAsegurado = C.CodAsegurado
         AND F.IdFondo      = C.IdFondo
         AND C.CodCia       = nCodCia
         AND C.CodEmpresa   = nCodEmpresa
         AND C.IdPoliza     = nIdPoliza
         AND C.IDetPol      = nIDetPol
         AND C.CodAsegurado = nCodAsegurado
         AND C.IdFondo      = nIdFondo
         AND C.IdMovimiento = nIdMovimiento;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'NO Existe Movimiento No. ' || nIdMovimiento || ' en Concentradora de Fondos No. ' || nIdFondo);
   END;

   IF cTipoAplic NOT IN ('PM','MA') AND cTipoCargo = 'RANGO' AND cTipoMov = 'AP' THEN
      SELECT NVL(SUM(MtoAporteIniMoneda),0)
        INTO nMontoMovMoneda
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
         AND IdFondo      = nIdFondo;
   END IF;

   cCodMoneda      := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondo);

    nMtoCargoMoneda := GT_FAI_CONCENTRADORA_FONDO.CALCULA_CARGO_ABONO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, cTipoFondo,
                                                                     nIdFondo,  cCodCargo, 'C', nMontoMovMoneda, 'MT', dFecMovimiento,
                                                                     cTipoCargo, cPeriodoCargo, nPorcCargo, cTipoInteres,
                                                                     cCodRutinaCalc, NVL(nMontoMovOrig,0), nMontoCargo,
                                                                     nTasaCambioMov, nIdTransaccion);

   -- Si es Cargo por Monto se verifica que no exista para Otro Fondo,
   -- porque el Cargo es por póliza
   IF cTipoCargo = 'M' THEN
      IF GT_FAI_CONCENTRADORA_FONDO.EXISTE_FEE_POLIZA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo, cCptoMovFondo) = 'S' THEN
         nMtoCargoMoneda := 0;
      END IF;
   END IF;

   IF NVL(nMtoCargoMoneda,0) != 0 THEN
      nMtoCargoLocal := NVL(nMtoCargoMoneda,0) * NVL(nTasaCambioMov,0);
      BEGIN
         SELECT 'Cargo por Movimiento No. '||TRIM(TO_CHAR(nIdMovimiento))||' Realizado el '||
                TO_CHAR(dFecMovimiento,'DD/MM/YYYY')||' Aplicado por '||
                DECODE(cPeriodoCargo,'V','Vigencias','P','Año Póliza','C','Plazo Fijo','Vigencias, Año Póliza o Plazo Fijo')||
                ' y se calculo por '||
                DECODE(cTipoCargo,'PORCEN','Porcentaje del '||TO_CHAR(nPorcCargo,'999.999999'),
                                  'INTERE','Tipo de Interes '||cTipoInteres,
                                  'OTROS','Rutina de Cálculo '||cCodRutinaCalc,
                                  'MONTO','Monto Fijo '||TO_CHAR(nMontoCargo,'999,999,999,990.00'),
                                  'RANGO','Rangos ','No Definido')||
                ' Sobre el Monto de '||TRIM(TO_CHAR(NVL(nMontoMovMoneda,0),'999,999,999,990.00'))
           INTO cDescMovFondo
           FROM DUAL;
      END;
      IF cTipoAplic IN ('PM','MA') THEN  -- Por Movimiento y Mensual Anticipado
         GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo,
                                                              cCptoMovFondo, nIdTransaccion, cCodMoneda, nMtoCargoLocal, nMtoCargoMoneda,
                                                              cTipoTasa, nTasaCambioMov, dFecTasaCambio, dFecMovimiento, cDescMovFondo);

      ELSE
         IF GT_FAI_CARGOS_BONOS_FONDO_POL.EXISTE_BONO_CARGO_FONDO_POL(nCodCia, nCodEmpresa, nIdPoliza,
                                                                       nIDetPol, cCptoMovFondo, dFecMovimiento) = 'N' THEN
            -- Inserta Cargo en Tabla para Aplicarse a Futuro
            GT_FAI_CARGOS_BONOS_FONDO_POL.INSERTAR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                    nCodAsegurado, 'C', cCptoMovFondo, nIdTransaccion,
                                                    dFecMovimiento, nMtoCargoMoneda, cDescMovFondo);
         END IF;
      END IF;
   END IF;
END APLICA_CARGOS;

FUNCTION CALCULA_CARGO_ABONO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                             nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                             nIdFondo NUMBER, cCodigo VARCHAR2, cTipoCalc VARCHAR2,
                             nMtoBase NUMBER, cIndRetorno VARCHAR2, dFecMovimiento DATE,
                             cTipoCargoBono IN OUT VARCHAR2, cPeriodoCargoBono IN OUT VARCHAR2,
                             nPorcCargoBono IN OUT NUMBER, cTipoInteres IN OUT VARCHAR2,
                             cCodRutinaCalc IN OUT VARCHAR2, nMontoMovOrig NUMBER,
                             nMontoFijo IN OUT NUMBER, nTasaCambioMov NUMBER, nIdTransaccion NUMBER) RETURN NUMBER IS

cCptoMovFondo       FAI_BONOS_FONDOS.CptoMovFondo%TYPE;
nMtoMoneda          FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nMtoBaseLocal       FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nPlazoComprometido  FAI_FONDOS_DETALLE_POLIZA.PlazoComprometido%TYPE;
nPlazoObligado      FAI_FONDOS_DETALLE_POLIZA.PlazoObligado%TYPE;
nMontoAporteLocal   FAI_CONFIG_APORTE_FONDO_DET.MontoAporteLocal%TYPE;
nMontoAporteAnual   FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;
dFecEmision         FAI_FONDOS_DETALLE_POLIZA.FecEmision%TYPE;
cIndTipoEmpleado    FAI_CARGOS_FONDOS_EMPRESA.IndTipoEmpleado%TYPE;
cCodEmpleadoFunc    EMPLEADOS_FUNCIONARIOS.CodEmpleadoFunc%TYPE;
cCodGrupoEc         POLIZAS.CodGrupoEc%TYPE;
cCodMoneda          FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
nAltura             NUMBER(5);

BEGIN
   BEGIN
      SELECT NVL(PlazoComprometido,0), NVL(PlazoObligado,0),
             FecEmision, CodEmpleado
        INTO nPlazoComprometido, nPlazoObligado,
             dFecEmision, cCodEmpleadoFunc
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
         AND IdFondo      = nIdFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20200,'NO Existe Fondo No. ' || nIdFondo);
   END;

   IF cCodEmpleadoFunc IS NOT NULL THEN
      BEGIN
         SELECT 'EM'
           INTO cIndTipoEmpleado
           FROM EMPLEADOS_FUNCIONARIOS
          WHERE CodCia            = nCodCia
            AND CodEmpleadoFunc   = cCodEmpleadoFunc
            AND StsEmpleadoFunc   = 'ACTIV';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cIndTipoEmpleado := 'EX';
         WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20200,'Existen Varios Registros del Empleados o Funcionarios con el Código ' || cCodEmpleadoFunc);
      END;
      BEGIN
         SELECT CodGrupoEc
           INTO cCodGrupoEc
           FROM POLIZAS
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdPoliza   = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20200,'NO Existe Póliza No. ' || nIdPoliza);
      END;
   ELSE
      cIndTipoEmpleado := 'N';
   END IF;

   nMtoBaseLocal := NVL(nMtoBase,0) * nTasaCambioMov;
   nAltura       := GT_FAI_FONDOS_DETALLE_POLIZA.ALTURA_FONDO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo);
   cCodMoneda    := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondo);

   IF cTipoCalc = 'C' THEN -- Calcula Cargos
      BEGIN
         SELECT NVL(TipoCargo,'P'), NVL(PeriodoCargo,'V'), CptoMovFondo
           INTO cTipoCargoBono, cPeriodoCargoBono, cCptoMovFondo
           FROM FAI_CARGOS_FONDOS
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND TipoFondo  = cTipoFondo
            AND CodCargo   = cCodigo;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20200,'NO Existe Cargo ' || cCodigo || ' en el Fondo ' || cTipoFondo);
      END;

      IF cPeriodoCargoBono = 'V' THEN -- Por Vigencias
         BEGIN
            SELECT PorcCargo, TipoInteres, CodRutinaCalc, MontoCargo
              INTO nPorcCargoBono, cTipoInteres, cCodRutinaCalc, nMontoFijo
              FROM FAI_CARGOS_FONDOS_DET
             WHERE FecIniCargo <= dFecMovimiento
               AND FecFinCargo >= dFecMovimiento + 0.99999
               AND CodCargo     = cCodigo
               AND TipoFondo    = cTipoFondo
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa
             UNION
            SELECT PorcCargo, NULL, CodRutinaCalc, MontoCargo
              FROM FAI_CARGOS_FONDOS_RANGOS
             WHERE FecIniCargo <= dFecMovimiento
               AND FecFinCargo >= dFecMovimiento + 0.99999
               AND RangoIni    <= NVL(nMtoBase,0)
               AND RangoFin    >= NVL(nMtoBase,0)
               AND CodCargo     = cCodigo
               AND TipoFondo    = cTipoFondo
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa
             UNION
            SELECT PorcCargo, NULL, CodRutinaCalc, MontoCargo
              FROM FAI_CARGOS_FONDOS_EMPRESA
             WHERE FecIniCargo     <= dFecMovimiento
               AND FecFinCargo     >= dFecMovimiento + 0.99999
               AND IndTipoEmpleado  = cIndTipoEmpleado
               AND CodGrupoPol      = cCodGrupoEc
               AND CodCargo         = cCodigo
               AND TipoFondo        = cTipoFondo
               AND CodCia           = nCodCia
               AND CodEmpresa       = nCodEmpresa;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               nPorcCargoBono  := 0;
               cTipoInteres    := NULL;
               cCodRutinaCalc  := NULL;
               nMontoFijo      := 0;
         END;
      ELSIF cPeriodoCargoBono = 'P' THEN -- Por Año Póliza o Altura del Fondo
         BEGIN
            SELECT PorcCargo, TipoInteres, CodRutinaCalc, MontoCargo
              INTO nPorcCargoBono, cTipoInteres, cCodRutinaCalc, nMontoFijo
              FROM FAI_CARGOS_FONDOS_DET
             WHERE AnioCargo    = nAltura
               AND CodCargo     = cCodigo
               AND TipoFondo    = cTipoFondo
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa
             UNION -- Agregado Control por Rangos EC - 21/01/2008
            SELECT PorcCargo, NULL, CodRutinaCalc, MontoCargo
              FROM FAI_CARGOS_FONDOS_RANGOS
             WHERE AnoIniRango <= nAltura
               AND AnoFinRango >= nAltura
               AND RangoIni    <= NVL(nMtoBase,0)
               AND RangoFin    >= NVL(nMtoBase,0)
               AND CodCargo     = cCodigo
               AND TipoFondo    = cTipoFondo
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               nPorcCargoBono  := 0;
               cTipoInteres    := NULL;
               cCodRutinaCalc  := NULL;
               nMontoFijo      := 0;
         END;
      ELSIF cPeriodoCargoBono = 'A' THEN -- Por Vigencias y Año Póliza o Altura del Fondo
         BEGIN
            SELECT PorcCargo, TipoInteres, CodRutinaCalc, MontoCargo
              INTO nPorcCargoBono, cTipoInteres, cCodRutinaCalc, nMontoFijo
              FROM FAI_CARGOS_FONDOS_DET
             WHERE FecIniCargo <= dFecMovimiento
               AND FecFinCargo >= dFecMovimiento + 0.99999
               AND AnioCargo    = nAltura
               AND CodCargo     = cCodigo
               AND TipoFondo    = cTipoFondo
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa
             UNION -- Agregado Control por Rangos EC - 21/01/2008
            SELECT PorcCargo, NULL, CodRutinaCalc, MontoCargo
              FROM FAI_CARGOS_FONDOS_RANGOS
             WHERE FecIniCargo <= dFecMovimiento
               AND FecFinCargo >= dFecMovimiento + 0.99999
               AND AnoIniRango <= nAltura
               AND AnoFinRango >= nAltura
               AND RangoIni    <= NVL(nMtoBase,0)
               AND RangoFin    >= NVL(nMtoBase,0)
               AND CodCargo     = cCodigo
               AND TipoFondo    = cTipoFondo
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa
             UNION
            SELECT PorcCargo, NULL, CodRutinaCalc, MontoCargo
              FROM FAI_CARGOS_FONDOS_EMPRESA
             WHERE FecIniCargo     <= dFecMovimiento
               AND FecFinCargo     >= dFecMovimiento + 0.99999
               AND IndTipoEmpleado  = cIndTipoEmpleado
               AND CodGrupoPol      = cCodGrupoEc
               AND CodCargo         = cCodigo
               AND TipoFondo        = cTipoFondo
               AND CodCia           = nCodCia
               AND CodEmpresa       = nCodEmpresa;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               nPorcCargoBono  := 0;
               cTipoInteres    := NULL;
               cCodRutinaCalc  := NULL;
               nMontoFijo      := 0;
         END;
      ELSIF cPeriodoCargoBono = 'C' THEN -- Por Plazo Comprometido EC - 03/07/2008
         BEGIN
            SELECT PorcCargo, TipoInteres, CodRutinaCalc, MontoCargo
              INTO nPorcCargoBono, cTipoInteres, cCodRutinaCalc, nMontoFijo
              FROM FAI_CARGOS_FONDOS_DET
             WHERE FecIniCargo <= dFecMovimiento
               AND FecFinCargo >= dFecMovimiento + 0.99999
               AND AnioCargo    = nPlazoComprometido
               AND CodCargo     = cCodigo
               AND TipoFondo    = cTipoFondo
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa
             UNION
            SELECT PorcCargo, NULL, CodRutinaCalc, MontoCargo
              FROM FAI_CARGOS_FONDOS_RANGOS
             WHERE FecIniCargo <= dFecMovimiento
               AND FecFinCargo >= dFecMovimiento + 0.99999
               AND AnoIniRango <= nPlazoComprometido
               AND AnoFinRango >= nPlazoComprometido
               AND RangoIni    <= NVL(nMtoBase,0)
               AND RangoFin    >= NVL(nMtoBase,0)
               AND CodCargo     = cCodigo
               AND TipoFondo    = cTipoFondo
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               nPorcCargoBono  := 0;
               cTipoInteres    := NULL;
               cCodRutinaCalc  := NULL;
               nMontoFijo      := 0;
         END;
      END IF;
   ELSIF cTipoCalc = 'B' THEN
      BEGIN
         SELECT NVL(TipoBono,'P'), NVL(PeriodoBono,'V'), CptoMovFondo
           INTO cTipoCargoBono, cPeriodoCargoBono, cCptoMovFondo
           FROM FAI_BONOS_FONDOS
          WHERE CodBono    = cCodigo
            AND TipoFondo  = cTipoFondo
            AND CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20200,'NO Existe Bono ' || cCodigo || ' en el Fondo ' || cTipoFondo);
      END;
      IF cPeriodoCargoBono = 'V' THEN -- Por Vigencias
         BEGIN
            SELECT PorcBono, TipoInteres, CodRutinaCalc, MontoBono
              INTO nPorcCargoBono, cTipoInteres, cCodRutinaCalc, nMontoFijo
              FROM FAI_BONOS_FONDOS_DET
             WHERE FecIniBono  <= dFecMovimiento
               AND FecFinBono  >= dFecMovimiento + 0.99999
               AND CodBono      = cCodigo
               AND TipoFondo    = cTipoFondo
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa
             UNION
            SELECT PorcBono, NULL, CodRutinaCalc, MontoBono
              FROM FAI_BONOS_FONDOS_RANGOS
             WHERE FecIniBono  <= dFecMovimiento
               AND FecFinBono  >= dFecMovimiento + 0.99999
               AND RangoIni    <= NVL(nMtoBase,0)
               AND RangoFin    >= NVL(nMtoBase,0)
               AND CodBono      = cCodigo
               AND TipoFondo    = cTipoFondo
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               nPorcCargoBono  := 0;
               cTipoInteres    := NULL;
               cCodRutinaCalc  := NULL;
         END;
      ELSIF cPeriodoCargoBono = 'P' THEN -- Por Año Póliza o Altura del Fondo
         BEGIN
            SELECT PorcBono, TipoInteres, CodRutinaCalc, MontoBono
              INTO nPorcCargoBono, cTipoInteres, cCodRutinaCalc, nMontoFijo
              FROM FAI_BONOS_FONDOS_DET
             WHERE AnioBono     = nAltura
               AND CodBono      = cCodigo
               AND TipoFondo    = cTipoFondo
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa
             UNION
            SELECT PorcBono, NULL, CodRutinaCalc, MontoBono
              FROM FAI_BONOS_FONDOS_RANGOS
             WHERE AnoIniRango <= nAltura
               AND AnoFinRango >= nAltura
               AND RangoIni    <= NVL(nMtoBase,0)
               AND RangoFin    >= NVL(nMtoBase,0)
               AND CodBono      = cCodigo
               AND TipoFondo    = cTipoFondo
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               nPorcCargoBono  := 0;
               cTipoInteres    := NULL;
               cCodRutinaCalc  := NULL;
         END;
      ELSIF cPeriodoCargoBono = 'A' THEN -- Por Vigencias y Año Póliza o Altura del Fondo
         BEGIN
            SELECT PorcBono, TipoInteres, CodRutinaCalc, MontoBono
              INTO nPorcCargoBono, cTipoInteres, cCodRutinaCalc, nMontoFijo
              FROM FAI_BONOS_FONDOS_DET
             WHERE FecIniBono  <= dFecMovimiento
               AND FecFinBono  >= dFecMovimiento + 0.99999
               AND AnioBono     = nAltura
               AND CodBono      = cCodigo
               AND TipoFondo    = cTipoFondo
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa
             UNION
            SELECT PorcBono, NULL, CodRutinaCalc, MontoBono
              FROM FAI_BONOS_FONDOS_RANGOS
             WHERE FecIniBono  <= dFecMovimiento
               AND FecFinBono  >= dFecMovimiento + 0.99999
               AND AnoIniRango <= nAltura
               AND AnoFinRango >= nAltura
               AND RangoIni    <= NVL(nMtoBase,0)
               AND RangoFin    >= NVL(nMtoBase,0)
               AND CodBono      = cCodigo
               AND TipoFondo    = cTipoFondo
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               nPorcCargoBono  := 0;
               cTipoInteres    := NULL;
               cCodRutinaCalc  := NULL;
         END;
      ELSIF cPeriodoCargoBono = 'C' THEN -- Por Plazo Comprometido EC - 03/07/2008
         --  Monto Anual para Buscar % de Bono
         BEGIN
            SELECT SUM(NVL(MontoAporteMoneda,0))
              INTO nMontoAporteAnual
              FROM FAI_CONFIG_APORTE_FONDO_DET
             WHERE FecAporte   >= dFecEmision
               AND FecAporte   <= ADD_MONTHS(dFecEmision,12)
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa
               AND IdPoliza     = nIdPoliza
               AND IDetPol      = nIDetPol
               AND CodAsegurado = nCodAsegurado
               AND GT_FAI_TIPOS_DE_FONDOS.CLASE_FONDO(CodCia, CodEmpresa, GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO (IdFondo)) = 'OB';
         END;

         BEGIN
            SELECT PorcBono, TipoInteres, CodRutinaCalc, MontoBono
              INTO nPorcCargoBono, cTipoInteres, cCodRutinaCalc, nMontoFijo
              FROM FAI_BONOS_FONDOS_DET
             WHERE FecIniBono  <= dFecMovimiento
               AND FecFinBono  >= dFecMovimiento + 0.99999
               AND AnioBono     = nPlazoComprometido
               AND CodBono      = cCodigo
               AND TipoFondo    = cTipoFondo
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa
             UNION
            SELECT PorcBono, NULL, CodRutinaCalc, MontoBono
              FROM FAI_BONOS_FONDOS_RANGOS
             WHERE FecIniBono  <= dFecMovimiento
               AND FecFinBono  >= dFecMovimiento + 0.99999
               AND AnoIniRango <= nPlazoComprometido
               AND AnoFinRango >= nPlazoComprometido
               AND RangoIni    <= NVL(nMontoAporteAnual,0)
               AND RangoFin    >= NVL(nMontoAporteAnual,0)
               AND CodBono      = cCodigo
               AND TipoFondo    = cTipoFondo
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               nPorcCargoBono  := 0;
               cTipoInteres    := NULL;
               cCodRutinaCalc  := NULL;
         END;
      END IF;
   END IF;
   -- Cálculo del Cargo / Abono
   IF cIndRetorno = 'MT' THEN -- Devuelve Monto
      IF cTipoCargoBono = 'PORCEN' AND nPorcCargoBono != 0 THEN
         nMtoMoneda := TRUNC(NVL(nMtoBase,0) * (nPorcCargoBono / 100),6);
      ELSIF cTipoCargoBono = 'INTERE' AND cTipoInteres IS NOT NULL THEN
         nMtoMoneda := TRUNC(NVL(nMtoBase,0) * (GT_FAI_TASAS_DE_INTERES.TASA_INTERES(cTipoInteres, cTipoFondo, dFecMovimiento) / 100),6);
      ELSIF cTipoCargoBono = 'OTROS' AND cCodRutinaCalc IS NOT NULL THEN
         nMtoMoneda := GT_FAI_CONCENTRADORA_FONDO.CALCULO_RUTINA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado,
                                                                 cTipoFondo, nIdFondo, cCodRutinaCalc, 'M', dFecMovimiento,
                                                                 cCptoMovFondo, nMtoBase, nIdTransaccion);
      ELSIF cTipoCargoBono = 'MONTO' AND NVL(nMontoFijo,0) != 0 THEN
         nMtoMoneda := NVL(nMontoFijo,0);-- * OC_GENERALES.FUN_TASA_CAMBIO(PR_TIPOS_DE_FONDOS.MONEDA_FONDO(cTipoFondo),dFecMovimiento);
      ELSIF cTipoCargoBono = 'RANGO' AND nPorcCargoBono != 0 THEN
         nMtoMoneda := TRUNC(NVL(nMtoBase,0) * (nPorcCargoBono / 100),6);
      ELSIF cTipoCargoBono = 'RANGO' AND NVL(nMontoFijo,0) != 0 THEN
         nMtoMoneda := NVL(nMontoFijo,0);-- * OC_GENERALES.FUN_TASA_CAMBIO(cCodMoneda, dFecMovimiento);
      ELSIF cTipoCargoBono = 'RANGO' AND cCodRutinaCalc IS NOT NULL THEN
         nMtoMoneda := GT_FAI_CONCENTRADORA_FONDO.CALCULO_RUTINA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado,
                                                                 cTipoFondo, nIdFondo, cCodRutinaCalc, 'M', dFecMovimiento,
                                                                 cCptoMovFondo, nMtoBase, nIdTransaccion);
      ELSE
         nMtoMoneda := 0;
      END IF;
      RETURN(nMtoMoneda);
   ELSIF cIndRetorno = 'PC' THEN -- Devuelve Porcentaje
      RETURN(NVL(nPorcCargoBono,0) / 100);
   ELSIF cIndRetorno = 'TI' THEN -- Devuelve Tasa de Interes
      cTipoInteres := GT_FAI_TIPOS_DE_FONDOS.TIPO_INTERES(nCodCia, nCodEmpresa, cTipoFondo);
      RETURN(GT_FAI_TASAS_DE_INTERES.TASA_INTERES (cTipoInteres, cTipoFondo, dFecMovimiento) / 100);
   ELSIF cIndRetorno = 'RU' THEN -- Devuelve Monto de Rutina
      RETURN(GT_FAI_CONCENTRADORA_FONDO.CALCULO_RUTINA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado,
                                                       cTipoFondo, nIdFondo, cCodRutinaCalc, 'M', dFecMovimiento,
                                                       cCptoMovFondo, nMontoMovOrig, nIdTransaccion));
   ELSIF cIndRetorno = 'MF' THEN -- Devuelve Monto Fijo
      RETURN(NVL(nMontoFijo,0));-- * OC_GENERALES.FUN_TASA_CAMBIO(cCodMoneda, dFecMovimiento);
   END IF;
END CALCULA_CARGO_ABONO;

FUNCTION CALCULO_RUTINA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                        nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                        nIdFondo NUMBER, cCodRutinaCalc IN OUT VARCHAR2, cTipoCalc VARCHAR2,
                        dFecCalc  DATE, cCodCptoMov VARCHAR2, nMontoMov NUMBER,
                        nIdTransaccion NUMBER) RETURN NUMBER IS

nValMonto           FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
cIndAplicaCargo     FAI_MOVIMIENTOS_FONDOS.IndAplicaCargo%TYPE;
cCodCargo           FAI_MOVIMIENTOS_FONDOS.CodCargo%TYPE;
cIndAplicaBono      FAI_MOVIMIENTOS_FONDOS.IndAplicaBono%TYPE;
cCodBono            FAI_MOVIMIENTOS_FONDOS.CodBono%TYPE;
cIndAplicaRet       FAI_MOVIMIENTOS_FONDOS.IndAplicaRet%TYPE;
cCodCptoRet         FAI_MOVIMIENTOS_FONDOS.CodCptoRet%TYPE;
nPorcRet            FAI_MOVIMIENTOS_FONDOS.PorcCptoMov%TYPE;
cTipoCargo          FAI_CARGOS_FONDOS.TipoCargo%TYPE;
cPeriodoCargo       FAI_CARGOS_FONDOS.PeriodoCargo%TYPE;
cTipoInteres        FAI_CARGOS_FONDOS_DET.TipoInteres%TYPE;
nPorcCargo          FAI_CARGOS_FONDOS_DET.PorcCargo%TYPE;
cCodRutCalc         FAI_CARGOS_FONDOS_DET.CodRutinaCalc%TYPE;
nPorcCargoRes       FAI_CARGOS_FONDOS_DET.PorcCargo%TYPE;
nPorcBonoRes        FAI_CARGOS_FONDOS_DET.PorcCargo%TYPE;
nMontoFijo          FAI_CARGOS_FONDOS_DET.MontoCargo%TYPE;
nValRes             FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nRetImp             FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nPorcFee            FAI_TASAS_DE_INTERES.TasaInteres%TYPE;
nMtoMovFee          FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nDias               NUMBER(10);
nDiasMes            NUMBER(10);
nPorcBonoEmp        FAI_FONDOS_DETALLE_POLIZA.PorcBonoEmp%TYPE;
dFecFinAplicBono    FAI_FONDOS_DETALLE_POLIZA.FecFinAplicBono%TYPE;
cTipoBono           FAI_BONOS_FONDOS.TipoBono%TYPE;
cPeriodoBono        FAI_BONOS_FONDOS.PeriodoBono%TYPE;
nMontoAporteMoneda  FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;
dFecEmision         FAI_FONDOS_DETALLE_POLIZA.FecEmision%TYPE;
cCodMoneda          FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
cCodRutinaCalcRet   FAI_MOVIMIENTOS_FONDOS.CodRutinaCalc%TYPE;
nMontoOrig          FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nMontoMov1          FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nIdControlMov       FAI_CONCENTRADORA_FONDO.IdMovimiento%TYPE;
nDif                FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nTasaCambio         FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nMtoMovCostoSeg     FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nPrimaCosto         COBERT_ACT.Prima_Moneda%TYPE;
nTasa               COBERT_ACT.Tasa%TYPE;
cCodPlanPago        POLIZAS.CodPlanPago%TYPE;
nCantPagos          PLAN_DE_PAGOS.NumPagos%TYPE;
nMtoPrimaFrac       FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nMtoCargoPrimaComp  FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nPorcGtoAdmin       POLIZAS.PorcGtoAdmin%TYPE;
nPorcUtilidad       POLIZAS.PorcUtilidad%TYPE;
nPorcGtoAdqui       POLIZAS.PorcGtoAdqui%TYPE;
cSexo               PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
cRiesgo             ACTIVIDADES_ECONOMICAS.RiesgoActividad%TYPE;
dFecIniVig          POLIZAS.FecIniVig%TYPE;
nEdad               NUMBER(5);
nIdTarifa           TARIFA_CONTROL_VIGENCIAS.IdTarifa%TYPE;
nPorcGtoAdminTar    TARIFA_SEXO_EDAD_RIESGO.PorcGtoAdmin%TYPE;

CURSOR COB_Q IS
   SELECT IdTipoSeg, PlanCob, CodCobert, NVL(SumaAseg_Moneda,0) SumaAseg_Moneda,
          NVL(SUM(Prima_Moneda + PrimaNivMoneda),0) PrimaCosto
     FROM COBERT_ACT
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCodAsegurado
      AND IdEndoso      = 0
    GROUP BY IdTipoSeg, PlanCob, CodCobert, SumaAseg_Moneda;
BEGIN
   --nIdControlMov := PR_CONCENTRADORA_FONDOS.RECUPERA_IDCONTROL;

   BEGIN
      SELECT MF.IndAplicaCargo, MF.CodCargo, MF.IndAplicaBono, MF.CodBono,
             MF.IndAplicaRet, MF.CodCptoRet, MF.PorcCptoMov,
             TRUNC(FP.FecEmision), T.CodMoneda, T.TipoInteres, PorcBonoEmp, FecFinAplicBono
        INTO cIndAplicaCargo, cCodCargo, cIndAplicaBono, cCodBono,
             cIndAplicaRet, cCodCptoRet, nPorcRet,
             dFecEmision, cCodMoneda, cTipoInteres,  nPorcBonoEmp, dFecFinAplicBono
        FROM FAI_TIPOS_DE_FONDOS T, FAI_FONDOS_DETALLE_POLIZA FP, FAI_MOVIMIENTOS_FONDOS MF
       WHERE MF.CodCptoMov   = cCodCptoMov
         AND MF.TipoFondo    = FP.TipoFondo
         AND MF.CodCia       = FP.CodCia
         AND MF.CodEmpresa   = FP.CodEmpresa
         AND T.TipoFondo     = FP.Tipofondo
         AND T.CodCia        = FP.CodCia
         AND T.CodEmpresa    = FP.CodEmpresa
         AND FP.CodCia       = nCodCia
         AND FP.CodEmpresa   = nCodEmpresa
         AND FP.IdPoliza     = nIdPoliza
         AND FP.IDetPol      = nIDetPol
         AND FP.CodAsegurado = nCodAsegurado
         AND FP.IdFondo      = nIdFondo;
   END;

   nTasaCambio := OC_GENERALES.FUN_TASA_CAMBIO(cCodMoneda, dFecCalc );

   -- Busca Porcentaje del Cargo
   IF NVL(cIndAplicaCargo,'N') = 'S' THEN
      nPorcCargoRes := GT_FAI_CONCENTRADORA_FONDO.CALCULA_CARGO_ABONO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado,
                                                                      cTipoFondo, nIdFondo, cCodCargo, 'C', nMontoMov, 'PC', dFecCalc,
                                                                      cTipoCargo, cPeriodoCargo, nPorcCargo, cTipoInteres,
                                                                      cCodRutinaCalc, nMontoMov, nMontoFijo, nTasaCambio, nIdTransaccion);
   END IF;
   -- Busca Porcentaje del Retención de Impuestos
   IF NVL(cIndAplicaRet,'N') = 'S' THEN
      BEGIN
         SELECT (PorcCptoMov / 100), CodRutinaCalc
           INTO nPorcRet, cCodRutinaCalcRet
           FROM FAI_MOVIMIENTOS_FONDOS
          WHERE CodCptoMov  = cCodCptoRet
            AND TipoFondo   = cTipoFondo
            AND CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa;
      END;

      IF NVL(nPorcRet,0) = 0 THEN
         RAISE_APPLICATION_ERROR(-20200,'No existe Porcentaje Definido para la Retención '|| cCodCptoRet||
                                 ' en el Tipo de Fondo ' || cTipoFondo);
      END IF;

   END IF;

   IF cCodRutinaCalc = 'CALCRETIRO' THEN
      nValMonto := NVL(nMontoMov,0);
      RETURN(nValMonto);
   ELSIF cCodRutinaCalc = 'CALCRESCATE' THEN
      IF cTipoCalc = 'P' THEN
         RETURN(nPorcCargoRes);
      ELSIF cTipoCalc = 'M' THEN
         nValMonto := NVL(nMontoMov,0) * NVL(nPorcCargoRes,0);
         RETURN(nValMonto);
      END IF;
   ELSIF cCodRutinaCalc = 'CALCRETINT' THEN
      nMontoOrig  := nMontoMov * -1;
      nMontoMov1  := nMontoMov * -1;

      LOOP
         nValRes := NVL(nMontoMov1,0) * NVL(nPorcCargoRes,0);

         IF cCodRutinaCalcRet = 'INTERESREAL' THEN
            nRetImp := 0;
            --nRetImp := PR_INDICE_PRECIOS_CONSUMIDOR.CALCULO_ACT_SALDO_INPC( 'PRE', nIdControlMov, nIdFondo, dFecCalc, cCodCptoMov, PR_OPERACION.nNumOper, nMontoMov1 );
         ELSE
            nRetImp := (NVL(nMontoMov1,0) - NVL(nValRes,0)) * NVL(nPorcRet,0);
         END IF;

         nValMonto := NVL(nMontoMov1,0) - NVL(nValRes,0) - NVL(nRetImp,0);

         --GT_CONCENTRADORA_FONDO_CP.RESETEA( nIdControlMov );
         nDif := nMontoMov1 - nValMonto;

         IF nDif <= 0 THEN
            nMontoMov1 := nMontoMov1 + nDif;

         ELSE
            --GT_CONCENTRADORA_FONDO_CP.ACTUALIZA_MONTOS( nIDControlMov, nIdFondo, ( nMontoMov1 * -1 ), ( nMontoMov1 * -1 ) * nTasaCambio );
            nValMonto := nMontoMov1;
            EXIT;
         END IF;

      END LOOP;

      RETURN(nValMonto);

   ELSIF cCodRutinaCalc = 'BONOEMPLEADO' THEN --FS-- 21/04/2008. Se agrega nueva rutina
      -- Se Valida Fecha Final de Aplicación del Bono por Póliza - EC - 30/04/2008
      IF TRUNC(dFecFinAplicBono) >= TRUNC(dFecCalc) THEN
         nValMonto := NVL(nMontoMov,0) * (NVL(nPorcBonoEmp,0) / 100);
      ELSE
         nValMonto := 0;
      END IF;
      RETURN(nValMonto);
   ELSIF cCodRutinaCalc = 'CALCFEEADM' THEN
      BEGIN
         SELECT SUM(MontoMovMoneda)
           INTO nMtoMovFee
           FROM FAI_CONCENTRADORA_FONDO
          WHERE CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa
            AND IdPoliza      = nIdPoliza
            AND IDetPol       = nIDetPol
            AND CodAsegurado  = nCodAsegurado
            AND IdFondo       = nIdFondo
            AND IdTransaccion = nIdTransaccion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            nMtoMovFee := 0;
      END;
      BEGIN
         SELECT TRUNC(1 - POWER((1 - (PorcCargo / 100)),(1/12)),6)
           INTO nPorcFee
           FROM FAI_CARGOS_FONDOS_DET
          WHERE FecIniCargo <= dFecCalc
            AND FecFinCargo >= dFecCalc + 0.99999
            AND CodCargo     = cCodCptoMov
            AND TipoFondo    = cTipoFondo
            AND CodCia       = nCodCia
            AND CodEmpresa   = nCodEmpresa;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            nPorcFee := 0;
      END;
      nDias     := LAST_DAY(TRUNC(dFecCalc)) - TRUNC(dFecCalc) + 1;
      nDiasMes  := TO_NUMBER(TO_CHAR(LAST_DAY(TRUNC(dFecCalc)),'DD'));
      nValMonto := TRUNC(NVL(nMtoMovFee,0) * NVL(nPorcFee,0) * (nDias / nDiasMes),6);
      RETURN(nValMonto);
   ELSIF cCodRutinaCalc = 'COSTOSEGURO' THEN
      BEGIN
         SELECT FecIniVig
           INTO dFecIniVig
           FROM POLIZAS
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20200,'NO Existe Póliza No. ' || nIdPoliza);
      END;

      cSexo           := OC_ASEGURADO.SEXO_ASEGURADO(nCodCia, nCodEmpresa, nCodAsegurado);
      cRiesgo         := 'NA'; --OC_ACTIVIDADES_ECONOMICAS.RIESGO_ACTIVIDAD(cCodActividad);
      nEdad           := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, nCodAsegurado, dFecIniVig);
      nPrimaCosto     := 0;

      FOR W IN COB_Q LOOP
         nIdTarifa       := GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, W.IdTipoSeg, W.PlanCob, dFecIniVig);
         nTasa           := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, W.IdTipoSeg, W.PlanCob,
                                                                   W.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);
         nPrimaCosto     := NVL(nPrimaCosto,0) + (W.SumaAseg_Moneda * nTasa / 1000);
      END LOOP;

      cCodPlanPago    := OC_POLIZAS.PLAN_DE_PAGOS(nCodCia, nCodEmpresa, nIdPoliza);
      nCantPagos      := OC_PLAN_DE_PAGOS.CANTIDAD_PAGOS(nCodCia, nCodEmpresa, cCodPlanPago);
      nMtoMovCostoSeg := NVL(nPrimaCosto,0) / nCantPagos;
      RETURN(nMtoMovCostoSeg);
   ELSIF cCodRutinaCalc = 'COSTOCOMPLEMENTO' THEN
      BEGIN
         SELECT FecIniVig
           INTO dFecIniVig
           FROM POLIZAS
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdPoliza    = nIdPoliza;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20200,'NO Existe Póliza No. ' || nIdPoliza);
      END;

      cSexo             := OC_ASEGURADO.SEXO_ASEGURADO(nCodCia, nCodEmpresa, nCodAsegurado);
      cRiesgo           := 'NA'; --OC_ACTIVIDADES_ECONOMICAS.RIESGO_ACTIVIDAD(cCodActividad);
      nEdad             := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, nCodAsegurado, dFecIniVig);
      nPrimaCosto       := 0;
      nPorcGtoAdminTar  := 0;

      FOR W IN COB_Q LOOP
         nIdTarifa         := GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, W.IdTipoSeg, W.PlanCob, dFecIniVig);
         nTasa             := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, W.IdTipoSeg, W.PlanCob,
                                                                     W.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);
         nPrimaCosto       := NVL(nPrimaCosto,0) + NVL(W.PrimaCosto,0);
         nPorcGtoAdminTar  := NVL(nPorcGtoAdmin,0) +
                              OC_TARIFA_SEXO_EDAD_RIESGO.PORCEN_GASTOS_ADMIN(nCodCia, nCodEmpresa, W.IdTipoSeg, W.PlanCob,
                                                                             W.CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa, NULL);
      END LOOP;

      cCodPlanPago    := OC_POLIZAS.PLAN_DE_PAGOS(nCodCia, nCodEmpresa, nIdPoliza);
      nCantPagos      := OC_PLAN_DE_PAGOS.CANTIDAD_PAGOS(nCodCia, nCodEmpresa, cCodPlanPago);
      nMtoPrimaFrac   := NVL(nPrimaCosto,0) / nCantPagos;

      BEGIN
         SELECT DECODE(NVL(P.PorcGtoAdmin,0),0,OC_PLAN_COBERTURAS.GASTOS_ADMINISTRACION(DP.CodCia, DP.CodEmpresa, DP.IdTipoSeg, DP.PlanCob),NVL(P.PorcGtoAdmin,0)),
                DECODE(NVL(P.PorcUtilidad,0),0,OC_PLAN_COBERTURAS.UTILIDAD(DP.CodCia, DP.CodEmpresa, DP.IdTipoSeg, DP.PlanCob),NVL(P.PorcUtilidad,0)),
                DECODE(NVL(P.PorcGtoAdqui,0),0,OC_PLAN_COBERTURAS.GASTOS_ADQUISICION(DP.CodCia, DP.CodEmpresa, DP.IdTipoSeg, DP.PlanCob),NVL(P.PorcGtoAdqui,0))
           INTO nPorcGtoAdmin, nPorcUtilidad, nPorcGtoAdqui
           FROM DETALLE_POLIZA DP, POLIZAS P
          WHERE P.IdPoliza       = DP.IdPoliza
            AND P.CodCia         = DP.CodCia
            AND DP.Cod_Asegurado = nCodAsegurado
            AND DP.IDetPol       = nIDetPol
            AND DP.IdPoliza      = nIdPoliza
            AND DP.CodEmpresa    = nCodEmpresa
            AND DP.CodCia        = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            nPorcGtoAdmin  := 0;
            nPorcUtilidad  := 0;
            nPorcGtoAdqui  := 0;
      END;

      nMtoCargoPrimaComp := NVL(nMtoPrimaFrac,0) * (NVL(nPorcGtoAdmin,0) + NVL(nPorcUtilidad,0) + NVL(nPorcGtoAdqui,0) + NVL(nPorcGtoAdminTar,0)) / 100;
      RETURN(nMtoCargoPrimaComp);
   END IF;
END CALCULO_RUTINA;

FUNCTION EXISTE_FEE_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                           nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                           cCptoMovFondo VARCHAR2) RETURN VARCHAR2 IS
cExiste      VARCHAR2(1);
BEGIN
   -- Si es Cargo por Monto se verifica que no exista para Otro Fondo,
   -- porque el Cargo es por póliza
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM FAI_CONCENTRADORA_FONDO
       WHERE CodCptoMov    = cCptoMovFondo
         AND CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND CodAsegurado  = nCodAsegurado
         AND IdFondo      != nIdFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTE_FEE_POLIZA;

PROCEDURE APLICA_BONOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                       nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                       nIdFondo NUMBER, nIdMovimiento NUMBER, dFecMovimiento DATE,
                       cCodBono VARCHAR2, nMontoMovOrig NUMBER, nIdTransaccion NUMBER) IS

cTipoBono           FAI_BONOS_FONDOS.TipoBono%TYPE;
cPeriodoBono        FAI_BONOS_FONDOS.PeriodoBono%TYPE;
cCptoMovFondo       FAI_BONOS_FONDOS.CptoMovFondo%TYPE;
cTipoAplic          FAI_BONOS_FONDOS.TipoAplic%TYPE;
nPorcBono           FAI_BONOS_FONDOS_DET.PorcBono%TYPE;
cTipoInteres        FAI_BONOS_FONDOS_DET.TipoInteres%TYPE;
cCodRutinaCalc      FAI_BONOS_FONDOS_DET.CodRutinaCalc%TYPE;
nMontoFijo          FAI_BONOS_FONDOS_DET.MontoBono%TYPE;
nMtoBonoLocal       FAI_CONCENTRADORA_FONDO.MontoMovLocal%TYPE;
nMtoBonoMoneda      FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
cTipoTasa           FAI_CONCENTRADORA_FONDO.TipoTasa%TYPE;
nTasaCambioMov      FAI_CONCENTRADORA_FONDO.TasaCambioMov%TYPE;
dFecTasaCambio      FAI_CONCENTRADORA_FONDO.FecTasaCambio%TYPE;
nMontoMovMoneda     FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
cDescMovimiento     FAI_CONCENTRADORA_FONDO.DescMovimiento%TYPE;
cTipoMov            FAI_MOVIMIENTOS_FONDOS.TipoMov%TYPE;
nMontoAporteMoneda  FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;
dFecEmision         FAI_FONDOS_DETALLE_POLIZA.FecEmision%TYPE;
nPlazoObligado      FAI_FONDOS_DETALLE_POLIZA.PlazoObligado%TYPE;
cCodMoneda          FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
nMontoBono          FAI_CARGOS_FONDOS_DET.MontoCargo%TYPE;
nMontoAporteAnual   FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;
BEGIN
   BEGIN
      SELECT CptoMovFondo, TipoAplic, TipoBono
        INTO cCptoMovFondo, cTipoAplic, cTipoBono
        FROM FAI_BONOS_FONDOS
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND CodBono      = cCodBono
         AND TipoFondo    = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'NO Existe Configurado el Bono ' || cCodBono);
   END;

   BEGIN
      SELECT C.TipoTasa, C.TasaCambioMov, C.FecTasaCambio,F.FecEmision,
             DECODE(nMontoMovOrig,0,C.MontoMovMoneda,nMontoMovOrig), M.TipoMov,
             F.PlazoObligado
        INTO cTipoTasa, nTasaCambioMov, dFecTasaCambio, dFecEmision,
             nMontoMovMoneda, cTipoMov, nPlazoObligado
        FROM FAI_CONCENTRADORA_FONDO C, FAI_FONDOS_DETALLE_POLIZA F, FAI_MOVIMIENTOS_FONDOS M
       WHERE M.CodCia       = F.CodCia
         AND M.CodEmpresa   = F.CodEmpresa
         AND M.CodCptoMov   = C.CodCptoMov
         AND M.TipoFondo    = F.TipoFondo
         AND F.CodCia       = C.CodCia
         AND F.CodEmpresa   = C.CodEmpresa
         AND F.IdPoliza     = C.IdPoliza
         AND F.IDetPol      = C.IDetPol
         AND F.CodAsegurado = C.CodAsegurado
         AND F.IdFondo      = C.IdFondo
         AND C.CodCia       = nCodCia
         AND C.CodEmpresa   = nCodEmpresa
         AND C.IdPoliza     = nIdPoliza
         AND C.IDetPol      = nIDetPol
         AND C.CodAsegurado = nCodAsegurado
         AND C.IdFondo      = nIdFondo
         AND C.IdMovimiento = nIdMovimiento;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'NO Existe Movimiento No. ' || nIdMovimiento || ' en Concentradora de Fondos No. ' || nIdFondo);
   END;

   IF cTipoAplic NOT IN ('PM','MA') AND cTipoBono = 'RANGO' AND cTipoMov = 'AP' THEN
      SELECT NVL(SUM(MtoAporteIniMoneda),0)
        INTO nMontoMovMoneda
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
         AND IdFondo      = nIdFondo;
   END IF;

   cCodMoneda      := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondo);

   nMtoBonoMoneda  := GT_FAI_CONCENTRADORA_FONDO.CALCULA_CARGO_ABONO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, cTipoFondo,
                                                                     nIdFondo,  cCodBono, 'B', nMontoMovMoneda, 'MT', dFecMovimiento,
                                                                     cTipoBono, cPeriodoBono, nPorcBono, cTipoInteres,
                                                                     cCodRutinaCalc, NVL(nMontoMovOrig,0), nMontoBono,
                                                                     nTasaCambioMov, nIdTransaccion);

   IF cPeriodoBono = 'C' THEN
      BEGIN
         SELECT SUM(NVL(MontoAporteMoneda,0))
           INTO nMontoAporteAnual
           FROM FAI_CONFIG_APORTE_FONDO_DET
          WHERE FecAporte   >= dFecEmision
            AND FecAporte   <= ADD_MONTHS(dFecEmision,12)
            AND CodCia       = nCodCia
            AND CodEmpresa   = nCodEmpresa
            AND IdPoliza     = nIdPoliza
            AND IDetPol      = nIDetPol
            AND CodAsegurado = nCodAsegurado
            AND GT_FAI_TIPOS_DE_FONDOS.CLASE_FONDO(CodCia, CodEmpresa, GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO (IdFondo)) = 'OB';
      END;
   END IF;

   IF NVL(nMtoBonoMoneda,0) != 0 THEN
      nMtoBonoLocal := NVL(nMtoBonoMoneda,0) * NVL(nTasaCambioMov,0);
      BEGIN
         SELECT 'Bono por Movimiento No. '||TRIM(TO_CHAR(nIdMovimiento))||' Realizado el '||
                TO_CHAR(dFecMovimiento,'DD/MM/YYYY')||' Aplicado por '||
                DECODE(cPeriodoBono,'V','Vigencias','P','Año Póliza','C','Plazo Fijo','Vigencias, Año Póliza o Plazo Fijo')||
                ' y se calculo por '||
                DECODE(cTipoBono,'PORCEN','Porcentaje del '||TO_CHAR(nPorcBono,'999.999999'),
                                 'INTERE','Tipo de Interes '||cTipoInteres,
                                 'OTROS','Rutina de Cálculo '||cCodRutinaCalc,
                                 'MONTO','Monto Fijo '||TO_CHAR(nMontoBono,'999,999,999,990.00'),
                                 'RANGO','Rangos ','No Definido')||
                ' Sobre el Monto de '||TRIM(TO_CHAR(NVL(nMtoBonoMoneda,0),'999,999,999,990.00'))
           INTO cDescMovimiento
           FROM DUAL;

           IF cPeriodoBono = 'C' THEN -- Plazo Fijo
              IF NVL(nPorcBono,0) != 0 THEN
                 cDescMovimiento := cDescMovimiento || ' con un Porcentaje del '||TO_CHAR(nPorcBono,'999.999999');
              ELSIF NVL(nMontoFijo,0) != 0 THEN
                 cDescMovimiento := cDescMovimiento || ' a un Monto Fijo de '||TO_CHAR(nMontoFijo,'999,999,999,990.00');
              END IF;
              cDescMovimiento := cDescMovimiento || ' y una Base Anual de '||TRIM(TO_CHAR(NVL(nMontoAporteAnual,0),'999,999,999,990.00'));
           END IF;
      END;
      IF cTipoAplic IN ('PM','MA') THEN  -- Por Movimiento y Mensual Anticipado
         GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo,
                                                              cCptoMovFondo, nIdTransaccion, cCodMoneda, nMtoBonoLocal, nMtoBonoMoneda,
                                                              cTipoTasa, nTasaCambioMov, dFecTasaCambio, dFecMovimiento, cDescMovimiento);

      ELSE
         IF GT_FAI_CARGOS_BONOS_FONDO_POL.EXISTE_BONO_CARGO_FONDO_POL(nCodCia, nCodEmpresa, nIdPoliza,
                                                                       nIDetPol, cCptoMovFondo, dFecMovimiento) = 'N' THEN
            -- Inserta Cargo en Tabla para Aplicarse a Futuro
            GT_FAI_CARGOS_BONOS_FONDO_POL.INSERTAR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                    nCodAsegurado, 'C', cCptoMovFondo, nIdTransaccion,
                                                    dFecMovimiento, nMtoBonoMoneda, cDescMovimiento);
         END IF;
      END IF;
   END IF;
END APLICA_BONOS;

PROCEDURE APLICA_RETENCION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                           nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                           nIdFondo NUMBER, nIdMovimiento NUMBER, dFecMovimiento DATE,
                           cCodCptoRet VARCHAR2, nMontoMovOrig NUMBER, nIdTransaccion NUMBER,
                           nDiasPeriodicidad NUMBER DEFAULT NULL) IS

nPorcRet            FAI_MOVIMIENTOS_FONDOS.PorcCptoMov%TYPE;
nMtoRetLocal        FAI_CONCENTRADORA_FONDO.MontoMovLocal%TYPE;
nMtoRetMoneda       FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nMontoMov           FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
cTipoTasa           FAI_CONCENTRADORA_FONDO.TipoTasa%TYPE := NULL;
nTasaCambioMov      FAI_CONCENTRADORA_FONDO.TasaCambioMov%TYPE := NULL;
dFecTasaCambio      FAI_CONCENTRADORA_FONDO.FecTasaCambio%TYPE := NULL;
cDescMovimiento     FAI_CONCENTRADORA_FONDO.DescMovimiento%TYPE := NULL;
cTipoMov            FAI_CONF_MOVIMIENTOS_FONDO.TipoMov%TYPE;
cCodRutinaCalc      FAI_MOVIMIENTOS_FONDOS.CodRutinaCalc%TYPE;
cCodCptoMov         FAI_CONCENTRADORA_FONDO.CodCptoMov%TYPE;
cCodMoneda          FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
nSaldoFondo         FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nIdTransaccionRet   FAI_CONCENTRADORA_FONDO.IdTransaccion%TYPE;
cIndImpuesto        FAI_MOVIMIENTOS_FONDOS.IndImpuesto%TYPE;
cCodImpuesto        FAI_MOVIMIENTOS_FONDOS.CodImpuesto%TYPE;
nTasaIntAplic       NUMBER(20,12);

BEGIN
--   nIdControlMov := PR_CONCENTRADORA_FONDOS.RECUPERA_IDCONTROL;

   IF nIdTransaccion > 0 THEN
      BEGIN
         SELECT C.TipoTasa, C.TasaCambioMov, C.FecTasaCambio,
                M.TipoMov, M.CodCptoMov
           INTO cTipoTasa, nTasaCambioMov, dFecTasaCambio,
                cTipoMov, cCodCptoMov
           FROM FAI_CONCENTRADORA_FONDO C, FAI_FONDOS_DETALLE_POLIZA F, FAI_MOVIMIENTOS_FONDOS M
          WHERE M.CodCia       = F.CodCia
            AND M.CodEmpresa   = F.CodEmpresa
            AND M.CodCptoMov   = cCodCptoRet
            AND M.TipoFondo    = F.TipoFondo
            AND F.CodCia       = C.CodCia
            AND F.CodEmpresa   = C.CodEmpresa
            AND F.IdPoliza     = C.IdPoliza
            AND F.IDetPol      = C.IDetPol
            AND F.CodAsegurado = C.CodAsegurado
            AND F.IdFondo      = C.IdFondo
            AND C.CodCia       = nCodCia
            AND C.CodEmpresa   = nCodEmpresa
            AND C.IdPoliza     = nIdPoliza
            AND C.IDetPol      = nIDetPol
            AND C.CodAsegurado = nCodAsegurado
            AND C.IdFondo      = nIdFondo
            AND C.IdMovimiento = nIdMovimiento;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20200,'NO Existe Movimiento No. ' || nIdMovimiento || ' en Concentradora de Fondos No. ' || nIdFondo);
      END;

      nIdTransaccionRet := nIdTransaccion;
   END IF;

   BEGIN
      SELECT (PorcCptoMov / 100), CodRutinaCalc, IndImpuesto, CodImpuesto
        INTO nPorcRet, cCodRutinaCalc, cIndImpuesto, cCodImpuesto
        FROM FAI_MOVIMIENTOS_FONDOS M
       WHERE CodCptoMov   = cCodCptoRet
         AND TipoFondo    = cTipoFondo
         AND CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'NO Existe Concepto de Retención ' || cCodCptoRet || ' en Tipo de Fondos ' || cTipoFondo);
   END;

   IF cIndImpuesto = 'S' THEN
      nPorcRet  := GT_FAI_TASAS_DE_IMPUESTOS.TASA_IMPUESTO (cCodImpuesto, dFecMovimiento) / 100;
   END IF;

   IF NVL(nPorcRet,0) = 0 THEN
      RAISE_APPLICATION_ERROR(-20200,'No existe Porcentaje Definido para la Retención o Impuesto  '|| cCodCptoRet||' En el Tipo de Fondo '||cTipoFondo);
   END IF;

   IF cTipoMov IN ('RT','RP','TR','RX','RPP') THEN -- Retiros y Traspasos
      IF cCodRutinaCalc IS NULL THEN
         SELECT NVL(SUM(MontoMovMoneda),0)
           INTO nMontoMov
           FROM FAI_CONCENTRADORA_FONDO
          WHERE CodCia         = nCodCia
            AND CodEmpresa     = nCodEmpresa
            AND IdPoliza       = nIdPoliza
            AND IDetPol        = nIDetPol
            AND CodAsegurado   = nCodAsegurado
            AND IdFondo        = nIdFondo
            AND IdMovimiento   > nIdMovimiento
            AND IdTransaccion  = nIdTransaccion;

         nMtoRetMoneda  := (NVL(nMontoMovOrig,0) - NVL(nMontoMov,0)) * NVL(nPorcRet,0);

      ELSIF cCodRutinaCalc = 'INTERESREAL' THEN

         nMtoRetMoneda := 0;
         --nMtoRetLocal := PR_INDICE_PRECIOS_CONSUMIDOR.CALCULO_ACT_SALDO_INPC( 'DEF', nIdControlMov, nIdeFondo, dFecMov, cCodCptoMov, PR_OPERACION.nNumOper, nMontoMovOrig );
      END IF;
   ELSIF cCodRutinaCalc = 'ISRDIARIO' THEN
      nSaldoFondo := GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                    nCodAsegurado, nIdFondo, dFecMovimiento);

      nTasaIntAplic   := TRUNC((POWER(1 + NVL(nPorcRet,0),(nDiasPeriodicidad/360))) - 1,12);

      nMtoRetMoneda   := NVL(nSaldoFondo,0) * NVL(nTasaIntAplic,0);

      -- Se registra el Movimiento un día después de cuando se calcula
      nIdTransaccionRet  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');

      OC_DETALLE_TRANSACCION.CREA(nIdTransaccionRet, nCodCia,  nCodEmpresa, 21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                  nIdPoliza, nIDetPol, nIdFondo, cCodCptoRet, NVL(nMtoRetMoneda,0));

      cDescMovimiento := 'Retención de Impuestos Realizado el ' || TO_CHAR(dFecMovimiento,'DD/MM/YYYY') ||
                         ' Aplicada a una Tasa del  '||TO_CHAR(nTasaIntAplic,'999.999999999999') ||
                         '% Sobre el Monto de ' || TRIM(TO_CHAR(NVL(nSaldoFondo,0),'999,999,999,990.00'));
   ELSE
      nMtoRetMoneda  := NVL(nMontoMovOrig,0) * NVL(nPorcRet,0);
   END IF;

   IF NVL(nMtoRetMoneda,0) != 0 THEN
      IF cDescMovimiento IS NULL THEN
         cDescMovimiento := 'Retención de Impuestos por Movimiento No. '||TRIM(TO_CHAR(nIdMovimiento))||' Realizado el '||
                            TO_CHAR(dFecMovimiento,'DD/MM/YYYY')||' Aplicada al '||TO_CHAR((nPorcRet * 100),'999.999999')||
                            '% Sobre el Monto de '||TRIM(TO_CHAR(NVL(nMontoMovOrig,0)- NVL(nMontoMov,0),'999,999,999,990.00'));
      END IF;

      cCodMoneda      := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondo);
      nTasaCambioMov  := OC_GENERALES.FUN_TASA_CAMBIO(cCodMoneda, dFecMovimiento);
      nMtoRetLocal    := NVL(nMtoRetMoneda,0) / NVL(nTasaCambioMov,0);

      GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo,
                                                           cCodCptoRet, nIdTransaccionRet, cCodMoneda, nMtoRetLocal, nMtoRetMoneda,
                                                           NVL(cTipoTasa,'D'), nTasaCambioMov, NVL(dFecTasaCambio,dFecMovimiento),
                                                           dFecMovimiento, cDescMovimiento);

      IF cCodRutinaCalc = 'ISRDIARIO' THEN
         GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                       nCodAsegurado, nIdFondo, nIdTransaccionRet);
      END IF;
   END IF;
END APLICA_RETENCION;

PROCEDURE CALCULA_ADMIN(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                        nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                        nIdFondo NUMBER, dFecCalcFee DATE, nSaldoFondo NUMBER,
                        cTipoProceso VARCHAR2, nMontoFee IN OUT NUMBER) IS

cTipoCargo          FAI_CARGOS_FONDOS.TipoCargo%TYPE;
cPeriodoCargo       FAI_CARGOS_FONDOS.PeriodoCargo%TYPE;
cCptoMovFondo       FAI_CARGOS_FONDOS.CptoMovFondo%TYPE;
cTipoInteres        FAI_CARGOS_FONDOS_DET.TipoInteres%TYPE;
cCodRutinaCalc      FAI_CARGOS_FONDOS_DET.CodRutinaCalc%TYPE;
nMontoFijo          FAI_CARGOS_FONDOS_DET.MontoCargo%TYPE;
nMtoFeeLocal        FAI_CONCENTRADORA_FONDO.MontoMovLocal%TYPE;
nMtoFeeMoneda       FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
cDescMovimiento     FAI_CONCENTRADORA_FONDO.DescMovimiento%TYPE;
cCodMoneda          FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
cCodCargo           FAI_CARGOS_FONDOS.CodCargo%TYPE    := 'FEEADM';
nPorcCargo          FAI_CARGOS_FONDOS_DET.PorcCargo%TYPE;
nPorcCargoAplic     FAI_CARGOS_FONDOS_DET.PorcCargo%TYPE;
nIdMovimientoAnt    FAI_CONCENTRADORA_FONDO.IdMovimiento%TYPE;
dFecIniAlt          POLIZAS.FecIniVig%TYPE;
dFecEmision         FAI_FONDOS_DETALLE_POLIZA.FecEmision%TYPE;
dFecFinAlt          POLIZAS.FecFinVig%TYPE;
nIdTransaccion      TRANSACCION.IdTransaccion%TYPE;
nTasaCambioMov      FAI_CONCENTRADORA_FONDO.TasaCambioMov%TYPE;

CURSOR MOV_SOL_Q IS
   SELECT DISTINCT IdTransaccion
     FROM FAI_CONCENTRADORA_FONDO
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdPoliza       = nIdPoliza
      AND IDetPol        = nIDetPol
      AND CodAsegurado   = nCodAsegurado
      AND IdFondo        = nIdFondo
      AND IdMovimiento   > nIdMovimientoAnt
      AND StsMovimiento  = 'SOLICI';

CURSOR MOV_INF_Q IS  -- Movimientos informativos
   SELECT DISTINCT IdTransaccion
     FROM FAI_CONCENTRADORA_FONDO
    WHERE CodCia           = nCodCia
      AND CodEmpresa       = nCodEmpresa
      AND IdPoliza         = nIdPoliza
      AND IDetPol          = nIDetPol
      AND CodAsegurado     = nCodAsegurado
      AND IdFondo          = nIdFondo
      AND IdMovimiento     > nIdMovimientoAnt
      AND StsMovimiento    = 'ACTIVO'
      AND GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(CodCia, CodEmpresa, cTipoFondo, CodCptoMov, 'NS') = 'S';
BEGIN
   nIdMovimientoAnt := GT_FAI_CONCENTRADORA_FONDO.NUMERO_MOVIMIENTO(nCodCia, nCodEmpresa, nIdPoliza,
                                                                    nIDetPol, nCodAsegurado, nIdFondo) - 1;
   cCodMoneda       := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondo);
   nTasaCambioMov   := OC_GENERALES.FUN_TASA_CAMBIO(cCodMoneda, dFecCalcFee);
   cCptoMovFondo    := GT_FAI_CARGOS_FONDOS.CONCEPTO_CARGO(nCodCia, nCodEmpresa, cTipoFondo, cCodCargo);

   IF cCptoMovFondo IS NULL THEN
      RAISE_APPLICATION_ERROR(-20200,'NO Existe Código de Cargo ' || cCodCargo || ' en Tipo de Fondo ' || cTipoFondo);
   END IF;

   nIdTransaccion  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');

   nPorcCargoAplic := GT_FAI_CONCENTRADORA_FONDO.CALCULA_CARGO_ABONO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, cTipoFondo,
                                                                     nIdFondo,  cCodCargo, 'C', nSaldoFondo, 'PC', dFecCalcFee,
                                                                     cTipoCargo, cPeriodoCargo, nPorcCargo, cTipoInteres,
                                                                     cCodRutinaCalc, NVL(nSaldoFondo,0), nMontoFijo,
                                                                     nTasaCambioMov, nIdTransaccion);

   IF NVL(nPorcCargoAplic,0) != 0 THEN
      -- Cálculo del Cargo
      nPorcCargo    := 1 - POWER((1 - (nPorcCargoAplic)),(1/12));
      nMtoFeeMoneda := TRUNC(NVL(nSaldoFondo,0) * nPorcCargo,6);
   ELSE
      -- Verifica si es Aniversario Póliza y Fee es por Monto
      BEGIN
         SELECT FecIniVig
           INTO dFecEmision
           FROM POLIZAS
          WHERE CodCia       = nCodCia
            AND CodEmpresa   = nCodEmpresa
            AND IdPoliza     = nIdPoliza;
      END;
      dFecIniAlt  := GT_FAI_CONCENTRADORA_FONDO.FECHA_INICIO_ALTURA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                    nCodAsegurado, nIdFondo, dFecEmision);
      dFecFinAlt  := ADD_MONTHS(dFecIniAlt,12);
      IF dFecFinAlt <= dFecCalcFee OR dFecIniAlt >= dFecCalcFee THEN
         IF GT_FAI_CONCENTRADORA_FONDO.EXISTE_FEE_POLIZA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo, cCptoMovFondo) = 'N' THEN
            nMtoFeeMoneda := GT_FAI_CONCENTRADORA_FONDO.CALCULA_CARGO_ABONO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, cTipoFondo,
                                                                            nIdFondo,  cCodCargo, 'C', nSaldoFondo, 'MF', dFecCalcFee,
                                                                            cTipoCargo, cPeriodoCargo, nPorcCargo, cTipoInteres,
                                                                            cCodRutinaCalc, NVL(nSaldoFondo,0), nMontoFijo,
                                                                            nTasaCambioMov, nIdTransaccion);
         END IF;
      END IF;
   END IF;

   IF NVL(nMtoFeeMoneda,0) != 0 THEN
      OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia,  nCodEmpresa, 21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                  nIdPoliza, nIDetPol, nIdFondo, cCodCargo, NVL(nMtoFeeMoneda,0));

      nMtoFeeLocal := TRUNC(NVL(nMtoFeeMoneda,0) * nTasaCambioMov,6);
      IF cTipoProceso IS NULL THEN
         BEGIN
            SELECT 'Cargo por Administración del Fondo No. '||TRIM(TO_CHAR(nIdFondo))||' Realizado el '||
                   TO_CHAR(dFecCalcFee,'DD/MM/YYYY')||' Aplicado por '||
                   DECODE(cPeriodoCargo,'V','Vigencias','P','Año Póliza','Vigencias y Año Póliza')||
                   ' y se calculo por '||
                   DECODE(cTipoCargo,'PORCEN','Porcentaje del '||TO_CHAR(nPorcCargo,'999.999999'),
                                     'INTERE','Tipo de Interes '||cTipoInteres,
                                     'OTROS','Rutina de Cálculo '||cCodRutinaCalc,'No Definido')||
                   ' Sobre el Saldo de la Concentradora de ' || TRIM(TO_CHAR(NVL(nSaldoFondo,0),'999,999,999,990.00'))
              INTO cDescMovimiento
              FROM DUAL;
         END;

         GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo,
                                                              cCptoMovFondo, nIdTransaccion, cCodMoneda, nMtoFeeLocal, nMtoFeeMoneda,
                                                              'D', nTasaCambioMov, dFecCalcFee, dFecCalcFee, cDescMovimiento);

         FOR W IN MOV_SOL_Q LOOP
            GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                          nCodAsegurado, nIdFondo, W.IdTransaccion);
         END LOOP;

         -- Movimientos informativos
         --
         FOR W IN MOV_INF_Q LOOP
            GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                          nCodAsegurado, nIdFondo, W.IdTransaccion);
         END LOOP;

      ELSIF cTipoProceso = 'FEERETRO' THEN
         nMontoFee := NVL(nMtoFeeMoneda,0);
      END IF;
      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');
   END IF;
END CALCULA_ADMIN;

FUNCTION FECHA_INICIO_ALTURA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                             nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                             dFecIniVig DATE) RETURN DATE IS
dFecInicio   POLIZAS.FecIniVig%TYPE;
nAltura      NUMBER(5);
BEGIN
   nAltura    := GT_FAI_FONDOS_DETALLE_POLIZA.ALTURA_FONDO(nCodCia, nCodEmpresa, nIdPoliza,
                                                           nIDetPol, nCodAsegurado, nIdFondo);
   dFecInicio := ADD_MONTHS(dFecIniVig,((nAltura - 1) * 12));
   RETURN(dFecInicio);
END FECHA_INICIO_ALTURA;

PROCEDURE CALCULA_OTROS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                        nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                        nIdFondo NUMBER, cCodMovim VARCHAR2, dFecCalculo DATE,
                        nSaldoFondo NUMBER, cTipoProceso VARCHAR2, nMontoCargo IN OUT NUMBER ) IS

cTipoCargo          FAI_CARGOS_FONDOS.TipoCargo%TYPE;
cPeriodoCargo       FAI_CARGOS_FONDOS.PeriodoCargo%TYPE;
cCptoMovFondo       FAI_CARGOS_FONDOS.CptoMovFondo%TYPE;
cTipoInteres        FAI_CARGOS_FONDOS_DET.TipoInteres%TYPE;
cCodRutinaCalc      FAI_CARGOS_FONDOS_DET.CodRutinaCalc%TYPE;
nMontoFijo          FAI_CARGOS_FONDOS_DET.MontoCargo%TYPE;
nMtoCargoLocal      FAI_CONCENTRADORA_FONDO.MontoMovLocal%TYPE;
nMtoCargoMoneda     FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
cDescMovimiento     FAI_CONCENTRADORA_FONDO.DescMovimiento%TYPE;
cCodMoneda          FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
nSaldoFondoAnt      FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nPorcCargo          FAI_CARGOS_FONDOS_DET.PorcCargo%TYPE;
nPorcCargoAplic     FAI_CARGOS_FONDOS_DET.PorcCargo%TYPE;
nIdMovimientoAnt    FAI_CONCENTRADORA_FONDO.IdMovimiento%TYPE;
cDescConcepto       CATALOGO_DE_CONCEPTOS.DescripConcepto%TYPE;
nIdTransaccion      TRANSACCION.IdTransaccion%TYPE;
nTasaCambioMov      FAI_CONCENTRADORA_FONDO.TasaCambioMov%TYPE;

CURSOR MOV_SOL_Q IS
   SELECT DISTINCT IdTransaccion
     FROM FAI_CONCENTRADORA_FONDO
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdPoliza       = nIdPoliza
      AND IDetPol        = nIDetPol
      AND CodAsegurado   = nCodAsegurado
      AND IdFondo        = nIdFondo
      AND IdMovimiento   > nIdMovimientoAnt
      AND StsMovimiento  = 'SOLICI';

CURSOR MOV_INF_Q IS  -- Movimientos informativos
   SELECT DISTINCT IdTransaccion
     FROM FAI_CONCENTRADORA_FONDO
    WHERE CodCia           = nCodCia
      AND CodEmpresa       = nCodEmpresa
      AND IdPoliza         = nIdPoliza
      AND IDetPol          = nIDetPol
      AND CodAsegurado     = nCodAsegurado
      AND IdFondo          = nIdFondo
      AND IdMovimiento     > nIdMovimientoAnt
      AND StsMovimiento    = 'ACTIVO'
      AND GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(CodCia, CodEmpresa, cTipoFondo, CodCptoMov, 'NS') = 'S';
BEGIN
   nIdMovimientoAnt := GT_FAI_CONCENTRADORA_FONDO.NUMERO_MOVIMIENTO(nCodCia, nCodEmpresa, nIdPoliza,
                                                                    nIDetPol, nCodAsegurado, nIdFondo) - 1;
   cCodMoneda      := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondo);
   nTasaCambioMov  := OC_GENERALES.FUN_TASA_CAMBIO(cCodMoneda, dFecCalculo);
   cCptoMovFondo   := GT_FAI_CARGOS_FONDOS.CONCEPTO_CARGO(nCodCia, nCodEmpresa, cTipoFondo, cCodMovim);

   IF cCptoMovFondo IS NULL THEN
      RAISE_APPLICATION_ERROR(-20200,'NO Existe Código de Cargo ' || cCodMovim || ' en Tipo de Fondo ' || cTipoFondo);
   END IF;

   nSaldoFondoAnt  := NVL(nSaldoFondo,0);
   cDescConcepto   := OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, cCptoMovFondo);

   nPorcCargoAplic := GT_FAI_CONCENTRADORA_FONDO.CALCULA_CARGO_ABONO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, cTipoFondo,
                                                                     nIdFondo,  cCodMovim, 'C', nSaldoFondoAnt, 'PC', dFecCalculo,
                                                                     cTipoCargo, cPeriodoCargo, nPorcCargo, cTipoInteres,
                                                                     cCodRutinaCalc, NVL(nSaldoFondoAnt,0), nMontoFijo,
                                                                     nTasaCambioMov, nIdTransaccion);

   IF NVL(nPorcCargoAplic,0) != 0 THEN

      nMtoCargoMoneda := TRUNC(NVL(nSaldoFondoAnt,0) * nPorcCargo,6) / 100;

      IF NVL(nMtoCargoMoneda,0) != 0 THEN
         nMtoCargoLocal := TRUNC(NVL(nMtoCargoMoneda,0) * nTasaCambioMov,6);
         IF cTipoProceso IS NULL THEN
            BEGIN
               SELECT 'Cargo por ' || cDescConcepto || ' No. '||TRIM(TO_CHAR(nIdFondo))||' Realizado el '||
                      TO_CHAR(dFecCalculo,'DD/MM/YYYY')||' Aplicado por '||
                      DECODE(cPeriodoCargo,'V','Vigencias','P','Año Póliza','Vigencias y Año Póliza')||
                      ' y se calculo por '||
                      DECODE(cTipoCargo,'PORCEN','Porcentaje del '||TO_CHAR(nPorcCargo,'999.999999'),
                                        'INTERE','Tipo de Interes '||cTipoInteres,
                                        'OTROS','Rutina de Cálculo '||cCodRutinaCalc,'No Definido')||
                      ' Sobre el Saldo de la Concentradora de ' || TRIM(TO_CHAR(NVL(nSaldoFondoAnt,0),'999,999,999,990.00'))
                 INTO cDescMovimiento
                 FROM DUAL;
            END;

            nIdTransaccion  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');

            OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia,  nCodEmpresa, 21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                        nIdPoliza, nIDetPol, nIdFondo, cCodMovim, NVL(nMtoCargoMoneda,0));

            GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo,
                                                                 cCptoMovFondo, nIdTransaccion, cCodMoneda, nMtoCargoLocal, nMtoCargoMoneda,
                                                                 'D', nTasaCambioMov, dFecCalculo, dFecCalculo, cDescMovimiento);

            FOR W IN MOV_SOL_Q LOOP
               GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                             nCodAsegurado, nIdFondo, W.IdTransaccion);
             END LOOP;

            -- Movimientos informativos
            FOR W IN MOV_INF_Q LOOP
               GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                             nCodAsegurado, nIdFondo, W.IdTransaccion);
            END LOOP;
         ELSIF cTipoProceso = 'CARGORETRO' THEN
            nMontoCargo := NVL(nMtoCargoMoneda,0);
         END IF;
         OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');
      END IF;
   END IF;
END CALCULA_OTROS;

PROCEDURE CALCULA_INTERES_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                                nIdFondo NUMBER, dFecCalcInt DATE, nSaldoFondo NUMBER,
                                cTipoProceso VARCHAR2, nMontoInteres IN OUT NUMBER) IS

nTasaIntAnual      FAI_TASAS_DE_INTERES.TasaInteres%TYPE;
nTasaIntAnualEmp   FAI_TASAS_DE_INTERES.TasaInteres%TYPE;
nValIntMoneda      FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nValIntLocal       FAI_CONCENTRADORA_FONDO.MontoMovLocal%TYPE;
cDescMovimiento    FAI_CONCENTRADORA_FONDO.DescMovimiento%TYPE;
dFecUltInt         FAI_CONCENTRADORA_FONDO.FecMovimiento%TYPE;
dFecIniAlt         POLIZAS.FecIniVig%TYPE;
dFecFinAlt         POLIZAS.FecFinVig%TYPE;
cCodMonedaRango    FAI_RANGOS_APORTE_RENDIM.CodMoneda%TYPE;
nPorcTasaInt       FAI_RANGOS_APORTE_RENDIM.PorcTasaInt%TYPE;
nValorRango        FAI_RANGOS_APORTE_RENDIM.RangoIni%TYPE;
cCodCptoMov        FAI_MOVIMIENTOS_FONDOS.CodCptoMov%TYPE;
cTipoMov           FAI_MOVIMIENTOS_FONDOS.TipoMov%TYPE;
cCodMoneda         FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
nSaldoFondoAnt     FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nTasaUdiAct        FAI_TASAS_DE_INTERES.TasaInteres%TYPE;
nTasaUdiAnt        FAI_TASAS_DE_INTERES.TasaInteres%TYPE;
dFecIntIni         FAI_CONCENTRADORA_FONDO.FecMovimiento%TYPE;
nIdFondoAplic      FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
dFecEmision        FAI_CONCENTRADORA_FONDO.FecMovimiento%TYPE;
nIdMovimientoAnt   FAI_CONCENTRADORA_FONDO.IdMovimiento%TYPE;
nIdPolizaSalMin    POLIZAS.IdPoliza%TYPE;
nIdTransaccion     TRANSACCION.IdTransaccion%TYPE := 0;
nTasaCambioMov     FAI_CONCENTRADORA_FONDO.TasaCambioMov%TYPE;
cPeriodicidad      FAI_TIPOS_DE_INTERES.Periodicidad%TYPE;
nDiasPeriodicidad  NUMBER(5);
nAltura            NUMBER(5);
nTasaIntAplic      NUMBER(20,12);
nTasaIntAplicEmp   NUMBER(20,12);

CURSOR FONDOS_Q IS
   SELECT FP.TasaIntGar, FP.TipoFondo, FP.FecEmision, TF.CodRutinaCalcInt,
          FP.TipoRangoAportes, TF.TipoInteres, TF.CodMoneda, FP.IdPoliza
     FROM FAI_FONDOS_DETALLE_POLIZA FP, FAI_TIPOS_DE_FONDOS TF
    WHERE TF.CodCia         = TF.CodCia
      AND TF.CodEmpresa     = TF.CodEmpresa
      AND TF.TipoFondo      = FP.TipoFondo
      AND TF.CodCia         = nCodCia
      AND FP.CodEmpresa     = nCodEmpresa
      AND FP.IdPoliza       = nIdPoliza
      AND FP.IDetPol        = nIDetPol
      AND FP.CodAsegurado   = nCodAsegurado
      AND FP.IdFondo        = nIdFondo;

CURSOR RFC_APOINI_Q IS
   SELECT CF.MontoMovMoneda, CF.MontoMovLocal, CF.FecMovimiento,
          FP.IdPoliza, FP.IDetPol, FP.IdFondo,
          GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(FP.CodCia, FP.CodEmpresa, FP.TipoFondo) CodMoneda
     FROM FAI_CONCENTRADORA_FONDO CF, FAI_FONDOS_DETALLE_POLIZA FP, FAI_MOVIMIENTOS_FONDOS MF
    WHERE MF.TipoMov        = cTipoMov
      AND MF.CodCptoMov     = CF.CodCptoMov
      AND MF.TipoFondo      = GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO (FP.IdFondo)
      AND MF.CodCia         = CF.CodCia
      AND MF.CodEmpresa     = CF.CodEmpresa
      AND CF.FecMovimiento  = TRUNC(dFecEmision)
      AND CF.CodCia         = FP.CodCia
      AND CF.CodEmpresa     = FP.CodEmpresa
      AND CF.IdPoliza       = FP.IdPoliza
      AND CF.IDetPol        = FP.IDetPol
      AND CF.CodAsegurado   = FP.CodAsegurado
      AND CF.IdFondo        = FP.IdFondo
      AND CF.StsMovimiento  = 'ACTIVO'
      AND FP.CodCia         = nCodCia
      AND FP.CodEmpresa     = nCodEmpresa
      AND FP.IdPoliza       = nIdPoliza
      AND FP.IDetPol        = nIDetPol
      AND FP.CodAsegurado   = nCodAsegurado
      AND FP.StsFondo       = 'EMITID';

CURSOR RFC_ADIC_Q IS
   SELECT CF.MontoMovMoneda, CF.MontoMovLocal, CF.FecMovimiento,
          FP.IdPoliza, FP.IDetPol, FP.IdFondo,
          GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(FP.CodCia, FP.CodEmpresa, FP.TipoFondo) CodMoneda
     FROM FAI_CONCENTRADORA_FONDO CF, FAI_FONDOS_DETALLE_POLIZA FP, FAI_MOVIMIENTOS_FONDOS MF
    WHERE MF.TipoMov              IN ('AP','AA','AE')
      AND MF.CodCptoMov            = CF.CodCptoMov
      AND MF.TipoFondo             = GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO (FP.IdFondo)
      AND MF.CodCia                = CF.CodCia
      AND MF.CodEmpresa            = CF.CodEmpresa
      AND TRUNC(CF.FecMovimiento) <= TRUNC(dFecFinAlt)
      AND TRUNC(CF.FecMovimiento) >= TRUNC(dFecIniAlt)
      AND CF.CodCia                = FP.CodCia
      AND CF.CodEmpresa            = FP.CodEmpresa
      AND CF.IdPoliza              = FP.IdPoliza
      AND CF.IDetPol               = FP.IDetPol
      AND CF.CodAsegurado          = FP.CodAsegurado
      AND CF.IdFondo               = FP.IdFondo
      AND CF.StsMovimiento         = 'ACTIVO'
      AND FP.CodCia                = nCodCia
      AND FP.CodEmpresa            = nCodEmpresa
      AND FP.IdPoliza              = nIdPoliza
      AND FP.IDetPol               = nIDetPol
      AND FP.CodAsegurado          = nCodAsegurado
      AND FP.StsFondo              = 'EMITID';

CURSOR MOV_SOL_Q IS
   SELECT DISTINCT IdTransaccion
     FROM FAI_CONCENTRADORA_FONDO
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdPoliza       = nIdPoliza
      AND IDetPol        = nIDetPol
      AND CodAsegurado   = nCodAsegurado
      AND IdFondo        = nIdFondo
      AND IdMovimiento   > nIdMovimientoAnt
      AND StsMovimiento  = 'SOLICI';

CURSOR MOV_INF_Q IS  -- Movimientos informativos
   SELECT DISTINCT IdTransaccion
     FROM FAI_CONCENTRADORA_FONDO
    WHERE CodCia           = nCodCia
      AND CodEmpresa       = nCodEmpresa
      AND IdPoliza         = nIdPoliza
      AND IDetPol          = nIDetPol
      AND CodAsegurado     = nCodAsegurado
      AND IdFondo          = nIdFondo
      AND IdMovimiento     > nIdMovimientoAnt
      AND StsMovimiento    = 'ACTIVO'
      AND GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(CodCia, CodEmpresa, cTipoFondo, CodCptoMov, 'NS') = 'S';
BEGIN
   nIdMovimientoAnt := GT_FAI_CONCENTRADORA_FONDO.NUMERO_MOVIMIENTO(nCodCia, nCodEmpresa, nIdPoliza,
                                                                    nIDetPol, nCodAsegurado, nIdFondo) - 1;
   cCodMoneda      := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondo);
   nTasaCambioMov  := OC_GENERALES.FUN_TASA_CAMBIO(cCodMoneda, dFecCalcInt);

   FOR W IN FONDOS_Q LOOP
      -- Se Lee Fecha de Ultimo Cálculo de Intereses
      BEGIN
         SELECT MAX(CF.FecMovimiento)
           INTO dFecUltInt
           FROM FAI_CONCENTRADORA_FONDO CF, FAI_MOVIMIENTOS_FONDOS MF
          WHERE MF.TipoMov       IN ('IN','IT')
            AND MF.CodCptoMov     = CF.CodCptoMov
            AND MF.CodCia         = CF.CodCia
            AND MF.CodEmpresa     = CF.CodEmpresa
            AND MF.TipoFondo      = cTipoFondo
            AND CF.CodCia         = nCodCia
            AND CF.CodEmpresa     = nCodEmpresa
            AND CF.IdPoliza       = nIdPoliza
            AND CF.IDetPol        = nIDetPol
            AND CF.CodAsegurado   = nCodAsegurado
            AND CF.IdFondo        = nIdFondo;

         IF dFecUltInt IS NULL THEN
            -- Sino Existe Fecha de Intereses se lee el Primer Movimiento
            BEGIN
               SELECT MIN(FecMovimiento)
                 INTO dFecUltInt
                 FROM FAI_CONCENTRADORA_FONDO
                WHERE CodCia         = nCodCia
                  AND CodEmpresa     = nCodEmpresa
                  AND IdPoliza       = nIdPoliza
                  AND IDetPol        = nIDetPol
                  AND CodAsegurado   = nCodAsegurado
                  AND IdFondo        = nIdFondo;
            END;
            dFecIntIni     := TRUNC(dFecUltInt);
         ELSE
            dFecIntIni     := TRUNC(dFecUltInt) + 1;
         END IF;
      END;
      -- Condiciones para Nuevo Cálculo
      IF W.TipoRangoAportes = 'R1V1DOLAR' OR W.TipoRangoAportes IS NULL THEN
         dFecEmision    := W.FecEmision;
         nIdFondoAplic  := nIdFondo;
      ELSIF W.TipoRangoAportes IN ('SMG01PESOS','SMG02RENVA') THEN -- Salarios Mínimos
         BEGIN
            SELECT MIN(IdPoliza)
              INTO nIdPolizaSalMin
              FROM POLIZAS
             WHERE StsPoliza IN ('EMI','REN')
               AND CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa
               AND NumPolUnico IN (SELECT NumPolUnico
                                     FROM POLIZAS
                                    WHERE CodCia      = nCodCia
                                      AND CodEmpresa  = nCodEmpresa
                                      AND IdPoliza    = nIdPoliza);
         END;
         IF nIdPolizaSalMin = nIdPoliza THEN
            dFecEmision    := W.FecEmision;
            nIdFondoAplic  := nIdFondo;
         ELSE
            BEGIN
               SELECT NVL(MIN(IdFondo),nIdFondo), NVL(MIN(FecEmision),W.FecEmision)
                 INTO nIdFondoAplic, dFecEmision
                 FROM FAI_FONDOS_DETALLE_POLIZA
                WHERE CodCia         = nCodCia
                  AND CodEmpresa     = nCodEmpresa
                  AND IdPoliza       = nIdPolizaSalMin
                  AND IDetPol        = nIDetPol;
            END;
         END IF;
      ELSIF W.TipoRangoAportes IN ( 'ESPGRP01', 'ESPGRP02' ) THEN
         dFecEmision    := W.FecEmision;
         nIdFondoAplic  := nIdFondo;
      END IF;

      nAltura     := GT_FAI_FONDOS_DETALLE_POLIZA.ALTURA_FONDO(nCodCia, nCodEmpresa, nIdPoliza,
                                                               nIDetPol, nCodAsegurado, nIdFondoAplic);
      dFecIniAlt  := GT_FAI_CONCENTRADORA_FONDO.FECHA_INICIO_ALTURA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                    nCodAsegurado, nIdFondoAplic, dFecEmision);
      dFecFinAlt  := ADD_MONTHS(dFecIniAlt,12);
      IF NVL(nAltura,1) = 1 THEN
         cTipoMov := 'AP';
      ELSE
         -- Se Resta un año porque debe leer los Aportes del periodo anterior para
         -- determinar el rendimiento de la tasa de Interes
         dFecIniAlt  := ADD_MONTHS(dFecIniAlt,-12);
         dFecFinAlt  := ADD_MONTHS(dFecIniAlt,12);
         cTipoMov    := 'AA';
      END IF;

      cCodMonedaRango := NVL(GT_FAI_RANGOS_APORTE_RENDIM.MONEDA_RANGO(nCodCia, nCodEmpresa, W.TipoRangoAportes),cCodMoneda);

      -- Evalúa Rango de Aportes para Definir Rendimientos a la Tasa de Interés
      nValorRango := 0;
      IF W.TipoRangoAportes = 'R1V1DOLAR' THEN
          IF NVL(nAltura,1) = 1 THEN
             FOR Y IN RFC_APOINI_Q LOOP
                 IF Y.CodMoneda != cCodMonedaRango THEN
                    nValorRango := NVL(nValorRango,0) + (NVL(Y.MontoMovLocal,0) / OC_GENERALES.FUN_TASA_CAMBIO(cCodMonedaRango, Y.FecMovimiento));
                 ELSE
                    nValorRango := NVL(nValorRango,0) + NVL(Y.MontoMovMoneda,0);
                 END IF;
            END LOOP;
         ELSE
           FOR Y IN RFC_ADIC_Q LOOP
              IF Y.CodMoneda != cCodMonedaRango THEN
                 nValorRango := NVL(nValorRango,0) + (NVL(Y.MontoMovLocal,0) / OC_GENERALES.FUN_TASA_CAMBIO(cCodMonedaRango, Y.FecMovimiento));
              ELSE
                 nValorRango := NVL(nValorRango,0) + NVL(Y.MontoMovMoneda,0);
              END IF;
           END LOOP;
         END IF;
      ELSIF W.TipoRangoAportes IN ('SMG01PESOS','SGM02RENVA') THEN -- Salarios Mínimos
         IF NVL(nAltura,1) = 1 THEN
            FOR Y IN RFC_APOINI_Q LOOP
               nValorRango := NVL(nValorRango,0) + NVL(Y.MontoMovMoneda,0);
            END LOOP;
         ELSE
            FOR Y IN RFC_ADIC_Q LOOP
               nValorRango := NVL(nValorRango,0) + NVL(Y.MontoMovMoneda,0);
            END LOOP;
         END IF;
      END IF;

      IF W.TipoRangoAportes IS NOT NULL THEN
         nPorcTasaInt := GT_FAI_RANGOS_APORTE_RENDIM.PORCENTAJE_TASA(nCodCia, nCodEmpresa, W.TipoRangoAportes, cCodMonedaRango, nAltura, nValorRango);
      ELSE
         nPorcTasaInt := 100;
      END IF;

      IF NVL(nPorcTasaInt,0) > 0 THEN
         --nTasaIntAnual  := TRUNC(GT_FAI_TASAS_DE_INTERES.TASA_INTERES(W.TipoInteres, W.TipoFondo, dFecCalcInt) * (nPorcTasaInt / 100),12);
         nTasaIntAnual     := TRUNC(GT_FAI_TASAS_DE_INTERES.TASA_CLIENTES(W.TipoInteres, W.TipoFondo, dFecCalcInt) * (nPorcTasaInt / 100),12);
         nTasaIntAnualEmp  := TRUNC(GT_FAI_TASAS_DE_INTERES.TASA_EMPRESA(W.TipoInteres, W.TipoFondo, dFecCalcInt) * (nPorcTasaInt / 100),12);
      ELSE
         nTasaIntAnual     := TRUNC(NVL(W.TasaIntGar,0),12) / 100;
      END IF;
      IF W.CodRutinaCalcInt = 'INTGRAL' THEN
         BEGIN
            cPeriodicidad     := GT_FAI_TIPOS_DE_INTERES.PERIODICIDAD(W.TipoInteres);
            nDiasPeriodicidad := TO_NUMBER(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('DIASPERIOD', cPeriodicidad));
         EXCEPTION
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20200,'Error en Periodicidad/Intereses de Rutina INTGRAL para Tipo de Interes ' || W.TipoInteres);
         END;

         IF W.CodMoneda != 'PS' THEN
            cCodMoneda    := W.CodMoneda;
            -- Fórmula Redefinida el 14/02/2008
            IF W.TipoRangoAportes = 'SGM02RENVA' THEN
               nTasaIntAplic := TRUNC(NVL(nTasaIntAnual,0),12);
            ELSE
               nTasaIntAplic     := TRUNC((POWER(1 + NVL(nTasaIntAnual,0),(nDiasPeriodicidad/360))) - 1,12);
               nTasaIntAplicEmp  := TRUNC((POWER(1 + NVL(nTasaIntAnualEmp,0),(nDiasPeriodicidad/360))) - 1,12);
               --nTasaIntAplicEmp  := TRUNC((POWER(1 + (NVL(nTasaIntAnualEmp,0) - NVL(nTasaIntAnual,0)),(nDiasPeriodicidad/360))) - 1,12);
            END IF;
         ELSE
            IF W.CodMoneda = 'PS' THEN
               cCodMoneda := W.CodMoneda; -- 'UDI'
            ELSE
               cCodMoneda := W.CodMoneda;
            END IF;
            --nTasaUdiAct := OC_GENERALES.FUN_TASA_CAMBIO(cCodMoneda, dFecCalcInt);
            --nTasaUdiAnt := OC_GENERALES.FUN_TASA_CAMBIO(cCodMoneda, dFecCalcInt - 1);
            -- Fórmula Redefinida el 21/08/2007
            --nTasaIntAplic := TRUNC((POWER(1 + NVL(nTasaIntAnual,0),(1/360)) * (nTasaUdiAct / nTasaUdiAnt)) - 1,12);
            nTasaIntAplic     := TRUNC((POWER(1 + NVL(nTasaIntAnual,0),(nDiasPeriodicidad/360))) - 1,12);
            nTasaIntAplicEmp  := TRUNC((POWER(1 + NVL(nTasaIntAnualEmp,0),(nDiasPeriodicidad/360))) - 1,12);
            --nTasaIntAplicEmp  := TRUNC((POWER(1 + (NVL(nTasaIntAnualEmp,0) - NVL(nTasaIntAnual,0)),(nDiasPeriodicidad/360))) - 1,12);
         END IF;
      ELSIF W.CodRutinaCalcInt = 'INTNOMCOL' THEN
         nTasaIntAplic := TRUNC((NVL(nTasaIntAnual,0) / 360),12);
      ELSIF W.CodRutinaCalcInt = 'INTVARCOL' THEN
         nTasaIntAplic := NVL(nTasaIntAnual,0);
      END IF;

      nSaldoFondoAnt := GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                       nCodAsegurado, nIdFondo, dFecUltInt);
      nValIntMoneda  := TRUNC(NVL(nSaldoFondo,0) * NVL(nTasaIntAplic,0),12);
      nValIntLocal   := TRUNC(NVL(nValIntMoneda,0) * OC_GENERALES.FUN_TASA_CAMBIO(W.CodMoneda, dFecCalcInt),12);

      IF cTipoProceso IS NULL THEN
         IF NVL(nValIntMoneda,0) > 0 THEN
            cDescMovimiento := 'Cálculo de Intereses con base en Aportaciones de '||TRIM(TO_CHAR(NVL(nValorRango,0),'999,999,999,990.00'))||
                               ' que alcanzan un '||TRIM(TO_CHAR(NVL(nPorcTasaInt,0),'990.00'))||
                               '% de la Tasa y se otorga una Tasa de Rendimiento Anual del '||TRIM(TO_CHAR(NVL(nTasaIntAnual,0),'990.999999'))||
                               ' y tasa diaria del '||TRIM(TO_CHAR(NVL(nTasaIntAplic,0),'990.999999'))||
                               ' aplicados el '||TO_CHAR(dFecCalcInt,'DD/MM/YYYY')||
                               ' Sobre el Saldo de la Concentradora de ' || TRIM(TO_CHAR(NVL(nSaldoFondo,0),'999,999,999,990.00'));

            -- Se Busca Movimiento para Intereses al Fondo
            cCodCptoMov := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, cTipoFondo, 'IN');

            -- Se registra el Movimiento un día después de cuando se calcula
            nIdTransaccion  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');

            OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia,  nCodEmpresa, 21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                        nIdPoliza, nIDetPol, nIdFondo, cCodCptoMov, NVL(nValIntMoneda,0));

            GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo,
                                                                 cCodCptoMov, nIdTransaccion, cCodMoneda, nValIntLocal, nValIntMoneda,
                                                                'D', nTasaCambioMov, dFecCalcInt, dFecCalcInt, cDescMovimiento);
         END IF;

         -- Calcula Intereses de Empresa
         nValIntMoneda  := TRUNC(NVL(nSaldoFondo,0) * NVL(nTasaIntAplicEmp,0),12);
         nValIntLocal   := TRUNC(NVL(nValIntMoneda,0) * OC_GENERALES.FUN_TASA_CAMBIO(W.CodMoneda, dFecCalcInt),12);

         IF NVL(nValIntMoneda,0) > 0 THEN
            IF NVL(nIdTransaccion,0) = 0 THEN
               nIdTransaccion  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');
            END IF;

            cDescMovimiento := 'Cálculo de Intereses con base en Aportaciones de '||TRIM(TO_CHAR(NVL(nValorRango,0),'999,999,999,990.00'))||
                               ' que alcanzan un '||TRIM(TO_CHAR(NVL(nPorcTasaInt,0),'990.00'))||
                               '% de la Tasa y se otorga una Tasa de Rendimiento Anual del '||TRIM(TO_CHAR(NVL(nTasaIntAnualEmp,0),'990.999999'))||
                               ' y tasa diaria del '||TRIM(TO_CHAR(NVL(nTasaIntAplicEmp,0),'990.999999'))||
                               ' aplicados el '||TO_CHAR(dFecCalcInt,'DD/MM/YYYY')||
                               ' Sobre el Saldo de la Concentradora de ' || TRIM(TO_CHAR(NVL(nSaldoFondo,0),'999,999,999,990.00'));

            cCodCptoMov    := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, cTipoFondo, 'IT');

            OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia,  nCodEmpresa, 21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                        nIdPoliza, nIDetPol, nIdFondo, cCodCptoMov, NVL(nValIntMoneda,0));

            GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo,
                                                                 cCodCptoMov, nIdTransaccion, cCodMoneda, nValIntLocal, nValIntMoneda,
                                                                 'D', nTasaCambioMov, dFecCalcInt, dFecCalcInt, cDescMovimiento);
         END IF;
         FOR W IN MOV_SOL_Q LOOP
            GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                          nCodAsegurado, nIdFondo, W.IdTransaccion);
         END LOOP;

         -- Movimientos informativos
         FOR W IN MOV_INF_Q LOOP
            GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOV_INFORMATIVOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                               nCodAsegurado, nIdFondo, W.IdTransaccion);
         END LOOP;
      ELSIF cTipoProceso = 'INTRETRO' THEN
         nMontoInteres := NVL(nValIntMoneda,0);
      END IF;
      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');
   END LOOP;
END CALCULA_INTERES_FONDO;

PROCEDURE CALCULA_INFLACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                            nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                            nIdFondo NUMBER, dFecCalcInf DATE, nSaldoFondo NUMBER) IS

nTasaInfAct         FAI_TASAS_DE_INTERES.TasaInteres%TYPE;
nTasaInfAnt         FAI_TASAS_DE_INTERES.TasaInteres%TYPE;
nTasaInfAplic       FAI_TASAS_DE_INTERES.TasaInteres%TYPE;
nValInfMoneda       FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nValInfLocal        FAI_CONCENTRADORA_FONDO.MontoMovLocal%TYPE;
cDescMovimiento     FAI_CONCENTRADORA_FONDO.DescMovimiento%TYPE;
dFecUltInf          FAI_CONCENTRADORA_FONDO.FecMovimiento%TYPE;
dFecIniAlt          POLIZAS.FecIniVig%TYPE;
dFecFinAlt          POLIZAS.FecFinVig%TYPE;
cCodCptoMov         FAI_MOVIMIENTOS_FONDOS.CodCptoMov%TYPE;
cCodMoneda          FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
nIdTransaccion      TRANSACCION.IdTransaccion%TYPE;
nTasaCambioMov      FAI_CONCENTRADORA_FONDO.TasaCambioMov%TYPE;
nAltura             NUMBER(5);
cTipoMov            VARCHAR2(2);
dFecha              DATE;

CURSOR FONDOS_Q IS
   SELECT FP.TipoFondo, FP.FecEmision, TF.TipoInflacion, TF.CodMoneda
     FROM FAI_FONDOS_DETALLE_POLIZA FP, FAI_TIPOS_DE_FONDOS TF
    WHERE TF.TipoInflacion IS NOT NULL
      AND TF.TipoFondo      = FP.TipoFondo
      AND FP.CodEmpresa     = FP.CodEmpresa
      AND TF.CodCia         = FP.CodCia
      AND FP.StsFondo       = 'EMITID'
      AND FP.CodCia         = nCodCia
      AND FP.CodEmpresa     = nCodEmpresa
      AND FP.IdPoliza       = nIdPoliza
      AND FP.IDetPol        = nIDetPol
      AND FP.CodAsegurado   = nCodAsegurado
      AND FP.IdFondo        = nIdFondo;
BEGIN
   cCodMoneda      := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondo);
   nTasaCambioMov  := OC_GENERALES.FUN_TASA_CAMBIO(cCodMoneda, dFecCalcInf);

   FOR W IN FONDOS_Q LOOP
      -- Se Lee Fecha de Ultimo Cálculo de Inflación
      BEGIN
         SELECT MAX(CF.FecMovimiento) + 1
           INTO dFecUltInf
           FROM FAI_CONCENTRADORA_FONDO CF, FAI_MOVIMIENTOS_FONDOS MF
          WHERE MF.TipoMov        = 'IF'
            AND MF.CodCptoMov     = CF.CodCptoMov
            AND MF.CodCia         = CF.CodCia
            AND MF.CodEmpresa     = CF.CodEmpresa
            AND MF.TipoFondo      = cTipoFondo
            AND CF.CodCia         = nCodCia
            AND CF.CodEmpresa     = nCodEmpresa
            AND CF.IdPoliza       = nIdPoliza
            AND CF.IDetPol        = nIDetPol
            AND CF.CodAsegurado   = nCodAsegurado
            AND CF.IdFondo        = nIdFondo;

         IF dFecUltInf IS NULL THEN
            -- Sino Existe Fecha de Inflación se lee el Primer Movimiento
            BEGIN
               SELECT NVL(MIN(FecMovimiento),TRUNC(SYSDATE))
                 INTO dFecUltInf
                 FROM FAI_CONCENTRADORA_FONDO
                WHERE CodCia         = nCodCia
                  AND CodEmpresa     = nCodEmpresa
                  AND IdPoliza       = nIdPoliza
                  AND IDetPol        = nIDetPol
                  AND CodAsegurado   = nCodAsegurado
                  AND IdFondo        = nIdFondo;
            END;
         END IF;
      END;

      nAltura     := GT_FAI_FONDOS_DETALLE_POLIZA.ALTURA_FONDO(nCodCia, nCodEmpresa, nIdPoliza,
                                                               nIDetPol, nCodAsegurado, nIdFondo);
      dFecIniAlt  := GT_FAI_CONCENTRADORA_FONDO.FECHA_INICIO_ALTURA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                    nCodAsegurado, nIdFondo, W.FecEmision);
      dFecFinAlt  := ADD_MONTHS(dFecIniAlt,12);

      IF NVL(nAltura,1) = 1 THEN
         cTipoMov    := 'AP';
      ELSE
         -- Se Resta un año porque debe leer los Aportes del periodo anterior para
         -- determinar el ajuste por inflación
         dFecIniAlt  := ADD_MONTHS(dFecIniAlt,-12);
         dFecFinAlt  := ADD_MONTHS(dFecIniAlt,12);
         cTipoMov    := 'AD';
      END IF;

      IF W.CodMoneda = 'PS' THEN
         cCodMoneda := 'UDI';
      ELSE
         cCodMoneda := W.CodMoneda;
      END IF;

      nTasaInfAct    := OC_GENERALES.FUN_TASA_CAMBIO(cCodMoneda, dFecCalcInf);

      IF TO_CHAR( W.FecEmision, 'MMRRRR' ) = TO_CHAR( dFecCalcInf, 'MMRRRR' ) THEN
         nTasaInfAnt := OC_GENERALES.FUN_TASA_CAMBIO(cCodMoneda, W.FecEmision);
         dFecha      := W.FecEmision;
      ELSE
         dFecha      := TO_DATE('01/' || TO_CHAR(dFecCalcInf,'MM') || '/' || TO_CHAR(dFecCalcInf,'RRRR' ),'DD/MM/RRRR');
         dFecha      := dFecha - 1;
         nTasaInfAnt := OC_GENERALES.FUN_TASA_CAMBIO(cCodMoneda, dFecha);
      END IF;

      nTasaInfAplic  := ( NVL(nTasaInfAct,0) - NVL(nTasaInfAnt,0) ) / NVL(nTasaInfAnt,0);

      -- Se Busca Movimiento para Intereses al Fondo
      cCodCptoMov := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, cTipoFondo, 'IF');

      nValInfMoneda := NVL(NVL(nSaldoFondo,0) * NVL(nTasaInfAplic,0),0);
      nValInfLocal  := NVL(nValInfMoneda,0) * OC_GENERALES.FUN_TASA_CAMBIO(W.CodMoneda, dFecha);

      cDescMovimiento := 'Ajuste por Inflación con la Tasa Anterior del '||TO_CHAR(NVL(nTasaInfAnt,0),'999.999999')||
                         ' de Fecha '||TO_CHAR(dFecUltInf,'DD/MM/YYYY')||' y Tasa Actual del '||
                         TO_CHAR(NVL(nTasaInfAct,0),'999.999999')||
                         ' de Fecha '||TO_CHAR(dFecCalcInf,'DD/MM/YYYY')||
                         ' Sobre el Saldo de la Concentradora de ' || TRIM(TO_CHAR(NVL(nSaldoFondo,0),'999,999,999,990.00'));

      nIdTransaccion  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');

      OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia,  nCodEmpresa, 21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                  nIdPoliza, nIDetPol, nIdFondo, cCodCptoMov, NVL(nValInfMoneda,0));

      GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo,
                                                           cCodCptoMov, nIdTransaccion, cCodMoneda, nValInfLocal, nValInfMoneda,
                                                          'D', nTasaCambioMov, dFecCalcInf, dFecCalcInf, cDescMovimiento);

      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');
   END LOOP;
END CALCULA_INFLACION;

PROCEDURE RESCATE_AUTOMATICO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                             nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                             nIdFondo NUMBER, dFecRescate DATE, cIndCancelacion VARCHAR2) IS

nSaldoFondoMoneda     FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nSaldoFondoLocal      FAI_CONCENTRADORA_FONDO.MontoMovLocal%TYPE;
cCptoResAutom         FAI_TIPOS_DE_FONDOS.CodCptoResAutom%TYPE;
cDescMovimiento       FAI_CONCENTRADORA_FONDO.DescMovimiento%TYPE;
nMtoMinConcentradora  FAI_TIPOS_DE_FONDOS.MtoMinConcentradora%TYPE;
cCodMoneda            FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
nNumFondos            NUMBER(5);
nIdMovimientoAnt      FAI_CONCENTRADORA_FONDO.IdMovimiento%TYPE;
dFecAnul              POLIZAS.FecAnul%TYPE;
nIdTransaccion        TRANSACCION.IdTransaccion%TYPE;
nTasaCambioMov        FAI_CONCENTRADORA_FONDO.TasaCambioMov%TYPE;

CURSOR MOV_SOL_Q IS
   SELECT DISTINCT IdTransaccion
     FROM FAI_CONCENTRADORA_FONDO
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdPoliza       = nIdPoliza
      AND IDetPol        = nIDetPol
      AND CodAsegurado   = nCodAsegurado
      AND IdFondo        = nIdFondo
      AND IdMovimiento   > nIdMovimientoAnt
      AND StsMovimiento  = 'SOLICI';

CURSOR MOV_INF_Q IS  -- Movimientos informativos
   SELECT DISTINCT IdTransaccion
     FROM FAI_CONCENTRADORA_FONDO
    WHERE CodCia           = nCodCia
      AND CodEmpresa       = nCodEmpresa
      AND IdPoliza         = nIdPoliza
      AND IDetPol          = nIDetPol
      AND CodAsegurado     = nCodAsegurado
      AND IdFondo          = nIdFondo
      AND IdMovimiento     > nIdMovimientoAnt
      AND StsMovimiento    = 'ACTIVO'
      AND GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(CodCia, CodEmpresa, cTipoFondo, CodCptoMov, 'NS') = 'S';
BEGIN
   nIdMovimientoAnt := GT_FAI_CONCENTRADORA_FONDO.NUMERO_MOVIMIENTO(nCodCia, nCodEmpresa, nIdPoliza,
                                                                    nIDetPol, nCodAsegurado, nIdFondo) - 1;
   cCodMoneda      := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondo);
   nTasaCambioMov  := OC_GENERALES.FUN_TASA_CAMBIO(cCodMoneda, dFecRescate);

   BEGIN
      SELECT TF.CodCptoResAutom, TF.MtoMinConcentradora
        INTO cCptoResAutom, nMtoMinConcentradora
        FROM FAI_TIPOS_DE_FONDOS TF, FAI_MOVIMIENTOS_FONDOS MF
       WHERE TF.IndRescateAutomatico = 'S'
         AND TF.TipoFondo            = MF.TipoFondo
         AND TF.CodEmpresa           = MF.CodEmpresa
         AND TF.CodCia               = MF.CodCia
         AND TF.CodCptoResAutom      = MF.CodCptoMov
         AND MF.TipoFondo            = cTipoFondo
         AND MF.CodCia               = nCodCia
         AND MF.CodEmpresa           = nCodEmpresa;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'Tipo de Fondos ' || cTipoFondo || ' NO Permite Rescate Automático');
   END;

   nSaldoFondoMoneda := GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                       nCodAsegurado, nIdFondo, TRUNC(dFecRescate)) * -1;
   nSaldoFondoLocal  := NVL(nSaldoFondoMoneda,0) * nTasaCambioMov;

   IF cIndCancelacion = 'S' THEN
      cDescMovimiento  := 'Cancelacion del Fondo No. '||TRIM(TO_CHAR(nIdFondo))||' Realizado el '||
                          TO_CHAR(dFecRescate,'DD/MM/YYYY')||' con un Saldo de ' ||
                          TRIM(TO_CHAR(NVL(ABS(nSaldoFondoMoneda),0),'999,999,999,990.00'))||
                          ' por Cancelación de Póliza/Certficado/Asegurado';
   ELSE
      cDescMovimiento  := 'Rescate Automático del Fondo No. '||TRIM(TO_CHAR(nIdFondo))||' Realizado el '||
                          TO_CHAR(dFecRescate,'DD/MM/YYYY')||' con un Saldo de ' ||
                          TRIM(TO_CHAR(NVL(ABS(nSaldoFondoMoneda),0),'999,999,999,990.00'))||
                          ' que es Menor al Saldo Mínimo Establecido de '||
                          TRIM(TO_CHAR(NVL(nMtoMinConcentradora,0),'999,999,999,990.00'));
   END IF;

   nIdTransaccion  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');

   OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia,  nCodEmpresa, 21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                               nIdPoliza, nIDetPol, nIdFondo, cCptoResAutom, NVL(nSaldoFondoMoneda,0));

   GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo,
                                                        cCptoResAutom, nIdTransaccion, cCodMoneda, nSaldoFondoLocal, nSaldoFondoMoneda,
                                                       'D', nTasaCambioMov, dFecRescate, dFecRescate, cDescMovimiento);

   FOR W IN MOV_SOL_Q LOOP
      GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                    nCodAsegurado, nIdFondo, W.IdTransaccion);
   END LOOP;

   -- Movimientos informativos
   FOR W IN MOV_INF_Q LOOP
      GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                    nCodAsegurado, nIdFondo, W.IdTransaccion);
   END LOOP;

   GT_FAI_FONDOS_DETALLE_POLIZA.FONDO_RESCATADO(nCodCia, nCodEmpresa, nIdPoliza,
                                                nIDetPol, nCodAsegurado, nIdFondo);

   OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');

END RESCATE_AUTOMATICO;

PROCEDURE CARGOS_MESVERSARIO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                             nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2,
                             nIdFondo NUMBER, dFecCalc DATE, cTipoProceso VARCHAR2,
                             nMontoCargo IN OUT NUMBER) IS

cTipoCargo          FAI_CARGOS_FONDOS.TipoCargo%TYPE;
cPeriodoCargo       FAI_CARGOS_FONDOS.PeriodoCargo%TYPE;
cTipoInteres        FAI_CARGOS_FONDOS_DET.TipoInteres%TYPE;
cCodRutinaCalc      FAI_CARGOS_FONDOS_DET.CodRutinaCalc%TYPE;
nMontoFijo          FAI_CARGOS_FONDOS_DET.MontoCargo%TYPE;
nMtoCargoLocal      FAI_CONCENTRADORA_FONDO.MontoMovLocal%TYPE;
nMtoCargoMoneda     FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
cDescMovimiento     FAI_CONCENTRADORA_FONDO.DescMovimiento%TYPE;
cCodMoneda          FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
nSaldoFondo         FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nPorcCargo          FAI_CARGOS_FONDOS_DET.PorcCargo%TYPE;
nPorcCargoAplic     FAI_CARGOS_FONDOS_DET.PorcCargo%TYPE;
nIdMovimientoAnt    FAI_CONCENTRADORA_FONDO.IdMovimiento%TYPE;
cTipoAplic          FAI_CARGOS_FONDOS.TipoAplic%TYPE;
cDescConcepto       CATALOGO_DE_CONCEPTOS.DescripConcepto%TYPE;
nIdTransaccion      TRANSACCION.IdTransaccion%TYPE;
nTasaCambioMov      FAI_CONCENTRADORA_FONDO.TasaCambioMov%TYPE;
dFecIniAlt          POLIZAS.FecIniVig%TYPE;
dFecFinAlt          POLIZAS.FecFinVig%TYPE;

CURSOR MOV_SOL_Q IS
   SELECT DISTINCT IdTransaccion
     FROM FAI_CONCENTRADORA_FONDO
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdPoliza       = nIdPoliza
      AND IDetPol        = nIDetPol
      AND CodAsegurado   = nCodAsegurado
      AND IdFondo        = nIdFondo
      AND IdMovimiento   > nIdMovimientoAnt
      AND StsMovimiento  = 'SOLICI';

CURSOR MOV_INF_Q IS  -- Movimientos informativos
   SELECT DISTINCT IdTransaccion
     FROM FAI_CONCENTRADORA_FONDO
    WHERE CodCia           = nCodCia
      AND CodEmpresa       = nCodEmpresa
      AND IdPoliza         = nIdPoliza
      AND IDetPol          = nIDetPol
      AND CodAsegurado     = nCodAsegurado
      AND IdFondo          = nIdFondo
      AND IdMovimiento     > nIdMovimientoAnt
      AND StsMovimiento    = 'ACTIVO'
      AND GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(CodCia, CodEmpresa, cTipoFondo, CodCptoMov, 'NS') = 'S';

CURSOR CARGOS_Q IS
   SELECT CF.CodCargo, CF.CptoMovFondo, CF.TipoAplic, FP.FecEmision
     FROM FAI_FONDOS_DETALLE_POLIZA FP, FAI_CARGOS_FONDOS CF
    WHERE CF.TipoAplic  IN ('MA','TM') -- Mensual Anticipado y Trimestral
      AND CF.TipoFondo     = FP.TipoFondo
      AND CF.CodEmpresa    = FP.CodEmpresa
      AND CF.CodCia        = FP.CodCia
      AND FP.CodCia        = nCodCia
      AND FP.CodEmpresa    = nCodEmpresa
      AND FP.IdPoliza      = nIdPoliza
      AND FP.IDetPol       = nIDetPol
      AND FP.CodAsegurado  = nCodAsegurado
      AND FP.IdFondo       = nIdFondo;
BEGIN
   FOR W IN CARGOS_Q LOOP
      IF GT_FAI_CONCENTRADORA_FONDO.MESVERSARIO(W.FecEmision, dFecCalc, W.TipoAplic) = 'S' THEN
         nSaldoFondo     := GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                           nCodAsegurado, nIdFondo, dFecCalc);

         nIdTransaccion  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');

         nMtoCargoMoneda := GT_FAI_CONCENTRADORA_FONDO.CALCULA_CARGO_ABONO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, cTipoFondo,
                                                                           nIdFondo,  W.CodCargo, 'C', nSaldoFondo, 'MT', dFecCalc,
                                                                           cTipoCargo, cPeriodoCargo, nPorcCargo, cTipoInteres,
                                                                           cCodRutinaCalc, NVL(nSaldoFondo,0), nMontoFijo,
                                                                           nTasaCambioMov, nIdTransaccion);

         IF NVL(nMtoCargoMoneda,0) != 0 THEN
            IF cTipoProceso IS NULL THEN -- Cálculo Normal
               nIdMovimientoAnt := GT_FAI_CONCENTRADORA_FONDO.NUMERO_MOVIMIENTO(nCodCia, nCodEmpresa, nIdPoliza,
                                                                                nIDetPol, nCodAsegurado, nIdFondo) - 1;
               cCodMoneda      := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondo);
               nTasaCambioMov  := OC_GENERALES.FUN_TASA_CAMBIO(cCodMoneda, dFecCalc);
               nMtoCargoLocal  := TRUNC(NVL(nMtoCargoMoneda,0) * nTasaCambioMov,6);
               cDescConcepto   := OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, W.CodCargo);

               SELECT cDescConcepto || ' del Fondo No. '||TRIM(TO_CHAR(nIdFondo))||' Realizado el '||
                      TO_CHAR(dFecCalc,'DD/MM/YYYY')||' Aplicado por '||
                      DECODE(cPeriodoCargo,'V','Vigencias','P','Año Póliza','Vigencias y Año Póliza')||
                      ' y se calculo por '||
                      DECODE(cTipoCargo,'PORCEN','Porcentaje del '||TO_CHAR(nPorcCargo,'999.999999'),
                                        'INTERE','Tipo de Interes '||cTipoInteres,
                                        'OTROS','Rutina de Cálculo '||cCodRutinaCalc,'No Definido')||
                      ' Sobre el Saldo de la Concentradora de ' || TRIM(TO_CHAR(NVL(nSaldoFondo,0),'999,999,999,990.00'))
                 INTO cDescMovimiento
                 FROM DUAL;

               OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia,  nCodEmpresa, 21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                           nIdPoliza, nIDetPol, nIdFondo, W.CptoMovFondo, NVL(nMtoCargoMoneda,0));

               GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo,
                                                                    W.CptoMovFondo, nIdTransaccion, cCodMoneda, nMtoCargoLocal, nMtoCargoMoneda,
                                                                   'D', nTasaCambioMov, dFecCalc, dFecCalc, cDescMovimiento);

               FOR W IN MOV_SOL_Q LOOP
                  GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                nCodAsegurado, nIdFondo, W.IdTransaccion);
               END LOOP;

               -- Movimientos informativos
               FOR W IN MOV_INF_Q LOOP
                  GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                nCodAsegurado, nIdFondo, W.IdTransaccion);
               END LOOP;

               OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');

            ELSIF cTipoProceso = 'CARGORETRO' THEN  -- Proceso Retroactivo
               nMontoCargo := NVL(nMtoCargoMoneda,0);
            END IF;
         END IF;
      END IF;
   END LOOP;
END CARGOS_MESVERSARIO;

FUNCTION MESVERSARIO(dFecEmision DATE, dFecCalc DATE, cTipoAplic VARCHAR2) RETURN VARCHAR2 IS
dFecInicial   DATE;
cAplica       VARCHAR2(1);
BEGIN
   -- Se considera el Año Bisiesto
   IF TO_CHAR(dFecEmision,'DD/MM') = '29/02' AND TO_CHAR(LAST_DAY(dFecCalc),'DD/MM') = '28/02' THEN
      RETURN('S');
   -- Mesversario (Mensual)
   ELSIF cTipoAplic = 'MA' AND TO_CHAR(dFecEmision,'DD') = TO_CHAR(dFecCalc,'DD') THEN
      RETURN('S');
   -- Mesversario (Trimestral)
   ELSIF cTipoAplic = 'TM' THEN
      -- Se agregan 3 meses, porque NO Generar Cargo en Emisión, sino al Trimestre
      dFecInicial := TRUNC(ADD_MONTHS(dFecEmision,3));
      cAplica     := 'N';
      LOOP
         IF TRUNC(dFecInicial) = TRUNC(dFecCalc) THEN
            cAplica := 'S';
         END IF;
         dFecInicial := ADD_MONTHS(TRUNC(dFecInicial),3);
         IF TRUNC(dFecInicial) > TRUNC(dFecCalc) THEN
            EXIT;
         END IF;
      END LOOP;
      RETURN(cAplica);
   ELSE
      RETURN('N');
   END IF;
END MESVERSARIO;

FUNCTION ASIGNA_FECHA_PROG_RETIRO(dFechaBase DATE) RETURN DATE IS

dFecha       DATE;
dFechaAplica DATE;
nDiaAplica   NUMBER(2);
nMesAplica   NUMBER(2);
nAnioAplica  NUMBER(4);
nDiaSemana   NUMBER(3);
nRegs        NUMBER(3);
nDiasTrans   NUMBER(3) := 1;
BEGIN
   dFecha      := TRUNC(dFechaBase);
   nDiaAplica  := 1;
   nMesAplica  := TO_NUMBER( TO_CHAR(dFecha,'MM' )) + 1;
   nAnioAplica := TO_NUMBER( TO_CHAR(dFecha,'RRRR'));

   IF nMesAplica = 13 THEN
      nMesAplica  := 1;
      nAnioAplica := nAnioAplica + 1;
   END IF;

   LOOP
      dFechaAplica  := TO_DATE(TO_CHAR(nDiaAplica,'00') || '/' || TO_CHAR(nMesAplica,'00') || '/' || TO_CHAR(nAnioAplica,'0000'),'DD/MM/RRRR');

      IF dFecha >= dFechaAplica THEN

         /*SELECT COUNT(*)
           INTO nRegs
           FROM FERIADO
          WHERE FECHA = dFecha;*/
         nRegs := 0;
         IF nRegs = 0 THEN
            nDiaSemana := TO_NUMBER(TO_CHAR(dFecha,'D'));
            IF nDiaSemana IN (6,7) THEN
               nDiaAplica := nDiaAplica + 1;
            ELSE
               IF nDiasTrans = 2 THEN
                  EXIT;
               ELSE
                  nDiasTrans := nDiasTrans + 1;
                  nDiaAplica := nDiaAplica + 1;
               END IF;
            END IF;
         ELSE
            nDiaAplica := nDiaAplica + 1;
         END IF;
      END IF;

      dFecha := dFecha + 1;
   END LOOP;
   RETURN( dFecha );
END ASIGNA_FECHA_PROG_RETIRO;

PROCEDURE APLICA_MOV_INTERESCARGO_DIARIO(nCodCia NUMBER, nCodEmpresa NUMBER) IS
dFecIntInf     DATE := TRUNC( SYSDATE );
nSaldoFondo    FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nMontoFee      FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nMontoInteres  FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;

CURSOR FONDOS_Q IS
   SELECT DISTINCT IdPoliza, IDetPol, CodAsegurado, TipoFondo, IdFondo
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE StsFondo     = 'EMITID'
      AND IdFondo      > 0
      AND CodAsegurado > 0
      AND IDetPol      > 0
      AND IdPoliza     > 0
      AND CodEmpresa   = nCodEmpresa
      AND CodCia       = nCodCia;
BEGIN
   FOR W IN FONDOS_Q LOOP
      -- Se Calculan Primero los Intereses
      nSaldoFondo     := GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, W.IdPoliza, W.IDetPol,
                                                                        W.CodAsegurado, W.IdFondo, dFecIntInf);

      IF NVL(nSaldoFondo,0) > 0 THEN
         GT_FAI_CONCENTRADORA_FONDO.CALCULA_INTERES_FONDO(nCodCia, nCodEmpresa, W.IdPoliza, W.IDetPol,
                                                          W.CodAsegurado, W.TipoFondo, W.IdFondo, dFecIntInf,
                                                          nSaldoFondo, NULL, nMontoInteres);
      END IF;

      -- Se Calcula a Fin de Mes pero se registra el 01 el siguiente mes
      -- Incluyendo los Intereses registrados el 01 del mes
      IF TRUNC(dFecIntInf) = TRUNC(LAST_DAY(dFecIntInf)) THEN
         dFecIntInf  := dFecIntInf + 1;
         nSaldoFondo     := GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, W.IdPoliza, W.IDetPol,
                                                                           W.CodAsegurado, W.IdFondo, dFecIntInf);
         GT_FAI_CONCENTRADORA_FONDO.CALCULA_ADMIN(nCodCia, nCodEmpresa, W.IdPoliza, W.IDetPol,
                                                  W.CodAsegurado, W.TipoFondo, W.IdFondo, dFecIntInf,
                                                  NVL(nSaldoFondo,0), NULL, nMontoFee);
      END IF;
   END LOOP;
END APLICA_MOV_INTERESCARGO_DIARIO;

PROCEDURE TRASPASO_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPolizaOrig NUMBER, nIDetPolOrig NUMBER,
                          nCodAseguradoOrig NUMBER, cTipoFondoOrig VARCHAR2, nIdFondoOrig IN OUT NUMBER,
                          cCodCptoMovOrig VARCHAR2, nIdPolizaDest NUMBER, nIDetPolDest NUMBER,
                          nCodAseguradoDest NUMBER,  nIdFondoDest IN OUT NUMBER, cTipoFondoDest VARCHAR2,
                          cCodCptoMovDest VARCHAR2, cTipoTraspaso VARCHAR2, dFecTraspaso DATE,
                          nMontoTraspaso NUMBER, cTipoTasa VARCHAR2, dFecTasaCambio DATE, nTasaCambio NUMBER,
                          cOrigenTraspaso VARCHAR2 DEFAULT NULL) IS

nMontoMovLocal           FAI_CONCENTRADORA_FONDO.MontoMovLocal%TYPE;
nMontoMovMoneda          FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
cDescMovimiento          FAI_CONCENTRADORA_FONDO.DescMovimiento%TYPE;
cCodMonedaOrig           FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
cCodMonedaDest           FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
nIdTransaccion           TRANSACCION.IdTransaccion%TYPE;
nTasaCambioMov           FAI_CONCENTRADORA_FONDO.TasaCambioMov%TYPE;
nIdFondo                 FAI_CONCENTRADORA_FONDO.IdFondo%TYPE;
cEnvioEstCta             FAI_FONDOS_DETALLE_POLIZA.EnvioEstCta%TYPE;
cNumSolicitud            FAI_FONDOS_DETALLE_POLIZA.NumSolicitud%TYPE;
nNumNip                  FAI_FONDOS_DETALLE_POLIZA.NumNip%TYPE;
cCodEmpleado             FAI_FONDOS_DETALLE_POLIZA.CodEmpleado%TYPE;
cIndAplicaCobDiferido    FAI_FONDOS_DETALLE_POLIZA.IndAplicaCobDiferido%TYPE;
cIndAplicCobOpcional     FAI_FONDOS_DETALLE_POLIZA.IndAplicCobOpcional%TYPE;
cReglaRetiros            FAI_FONDOS_DETALLE_POLIZA.ReglaRetiros%TYPE;
cIndBonoPolizaEmp        FAI_FONDOS_DETALLE_POLIZA.IndBonoPolizaEmp%TYPE;
nPorcBonoEmp             FAI_FONDOS_DETALLE_POLIZA.PorcBonoEmp%TYPE;
dFecFinAplicBono         FAI_FONDOS_DETALLE_POLIZA.FecFinAplicBono%TYPE;
nPlazoObligado           FAI_FONDOS_DETALLE_POLIZA.PlazoObligado%TYPE;
nPlazoComprometido       FAI_FONDOS_DETALLE_POLIZA.PlazoComprometido%TYPE;
cIndRevaluaAportComp     FAI_FONDOS_DETALLE_POLIZA.IndRevaluaAportComp%TYPE;
nEdadBeneficios          FAI_FONDOS_DETALLE_POLIZA.EdadBeneficios%TYPE;
nEdadJubilacion          FAI_FONDOS_DETALLE_POLIZA.EdadJubilacion%TYPE;
cIndDescPrimaCob         FAI_FONDOS_DETALLE_POLIZA.IndDescPrimaCob%TYPE;
nMesesPreferencial       FAI_FONDOS_DETALLE_POLIZA.MesesPreferencial%TYPE;
dFecFinPreferencial      FAI_FONDOS_DETALLE_POLIZA.FecFinPreferencial%TYPE;
nTasaPreferencial        FAI_FONDOS_DETALLE_POLIZA.TasaPreferencial%TYPE;
cStsFondo                FAI_FONDOS_DETALLE_POLIZA.StsFondo%TYPE;
nPorcFondo               FAI_FONDOS_DETALLE_POLIZA.PorcFondo%TYPE;
cExiste                  VARCHAR2(1);
cTraspaso                VARCHAR2(1);

BEGIN
   -- Datos de Póliza Origen
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM POLIZAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPolizaOrig;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'No Existe Póliza Origen ' || nIdPolizaOrig);
   END;

   -- Datos de Póliza Destino
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM POLIZAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdPoliza   = nIdPolizaDest;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'No Existe Póliza Destino ' || nIdPolizaDest);
   END;

   IF cTipoTraspaso IN ('NFM','NFO') THEN
      BEGIN
         SELECT PorcFondo, EnvioEstCta, NumSolicitud, NumNip, CodEmpleado, IndAplicaCobDiferido,
                IndAplicCobOpcional, ReglaRetiros, IndBonoPolizaEmp, PorcBonoEmp, FecFinAplicBono,
                PlazoObligado, PlazoComprometido, IndRevaluaAportComp, EdadBeneficios, EdadJubilacion,
                IndDescPrimaCob, MesesPreferencial, FecFinPreferencial, TasaPReferencial
           INTO nPorcFondo, cEnvioEstCta, cNumSolicitud, nNumNip, cCodEmpleado, cIndAplicaCobDiferido,
                cIndAplicCobOpcional, cReglaRetiros, cIndBonoPolizaEmp, nPorcBonoEmp, dFecFinAplicBono,
                nPlazoObligado, nPlazoComprometido, cIndRevaluaAportComp, nEdadBeneficios, nEdadJubilacion,
                cIndDescPrimaCob, nMesesPreferencial, dFecFinPreferencial, nTasaPreferencial
           FROM FAI_FONDOS_DETALLE_POLIZA
          WHERE CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa
            AND IdPoliza      = nIdPolizaOrig
            AND IDetPol       = nIDetPolOrig
            AND CodAsegurado  = nCodAseguradoOrig
            AND IdFondo       = nIdFondoOrig;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20200,'No Existe Fondo Origen ' || nIdFondoOrig);
      END;

      IF cOrigenTraspaso = 'RENOVACION' THEN
         cStsFondo := 'XRENOV';
         cTraspaso := 'N';
      ELSE
         cStsFondo := 'EMITID';
         cTraspaso := 'S';
      END IF;
      GT_FAI_FONDOS_DETALLE_POLIZA.INSERTA_NUEVO_FONDO(nCodCia, nCodEmpresa, nIdPolizaDest, nIDetPolDest, nCodAseguradoDest,
                                                       cTipoFondoDest, dFecTraspaso, cStsFondo, dFecTraspaso, cEnvioEstCta,
                                                       cNumSolicitud, ABS(nMontoTraspaso), cTipoTasa, nTasaCambio, dFecTasaCambio,
                                                       nNumNIP, cCodEmpleado, nIdFondoOrig, dFecTraspaso, cIndAplicaCobDiferido,
                                                       cIndAplicCobOpcional, cReglaRetiros, cIndBonoPolizaEmp, nPorcBonoEmp,
                                                       dFecFinAplicBono, nPlazoObligado, nPlazoComprometido,
                                                       cIndRevaluaAportComp, nEdadBeneficios, nEdadJubilacion, cIndDescPrimaCob,
                                                       nMesesPreferencial, dFecFinPreferencial, nTasaPreferencial, nIdFondo,
                                                       cTraspaso, nIdFondoDest, nPorcFondo);
   END IF;

   -- Inserta Movimiento a Fondo Origen
   nIdTransaccion  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');
   cCodMonedaOrig  := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondoOrig);
   nMontoMovMoneda := nMontoTraspaso * -1;
   nMontoMovLocal  := nMontoMovMoneda * nTasaCambio;
   IF cOrigenTraspaso != 'APORTECONTRAT' THEN
      cDescMovimiento := 'Traspaso del Fondo ' || cTipoFondoOrig || ' de la Póliza ' || nIdPolizaOrig ||
                         ' para el Fondo ' || cTipoFondoDest ||' de la Póliza ' || nIdPolizaDest ||
                         ' Realizado el ' || TO_CHAR(dFecTraspaso,'DD/MM/YYYY')||' Por un Monto Local de '||
                         TRIM(TO_CHAR(ABS(nMontoMovLocal),'999,999,999,990.00'))||' y un Monto Moneda de '||
                         TRIM(TO_CHAR(ABS(nMontoMovMoneda),'999,999,999,990.00'));
   ELSE
      cDescMovimiento := 'Traspaso de Aporte del Fondo del Contratante ' || cTipoFondoOrig || ' No. ' || nIdFondoOrig ||
                         ' de la Póliza ' || nIdPolizaOrig || ' para aporte al Fondo del Asegurado ' || cTipoFondoDest ||
                         ' No. ' || nIdFondoDest || ' de la Póliza ' || nIdPolizaDest || ' Realizado el ' ||
                         TO_CHAR(dFecTraspaso,'DD/MM/YYYY') || ' Por un Monto Local de ' ||
                         TRIM(TO_CHAR(ABS(nMontoMovLocal),'999,999,999,990.00')) ||  ' y un Monto Moneda de ' ||
                         TRIM(TO_CHAR(ABS(nMontoMovMoneda),'999,999,999,990.00'));
   END IF;
   /*OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia,  nCodEmpresa, 21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                               nIdPolizaOrig, nIDetPolOrig, nIdFondoOrig, cCodCptoMovOrig, NVL(nMontoMovMoneda,0));*/

   GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPolizaOrig, nIDetPolOrig, nCodAseguradoOrig, nIdFondoOrig,
                                                        cCodCptoMovOrig, nIdTransaccion, cCodMonedaOrig, nMontoMovLocal, nMontoMovMoneda,
                                                        'D', nTasaCambio, dFecTasaCambio, dFecTraspaso, cDescMovimiento);

   IF cOrigenTraspaso IN ('RENOVACION', 'APORTECONTRAT') THEN
      GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPolizaOrig, nIDetPolOrig,
                                                    nCodAseguradoOrig, nIdFondoOrig, nIdTransaccion);

      GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOV_INFORMATIVOS(nCodCia, nCodEmpresa, nIdPolizaOrig, nIDetPolOrig,
                                                         nCodAseguradoOrig, nIdFondoOrig, nIdTransaccion);

      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');

      IF cOrigenTraspaso = 'RENOVACION' THEN
         UPDATE FAI_CONCENTRADORA_FONDO
            SET MontoMovLocal    = nMontoMovLocal * -1, 
                MontoMovMoneda   = nMontoMovMoneda * -1
          WHERE CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa
            AND IdPoliza      = nIdPolizaOrig
            AND IDetPol       = nIDetPolOrig
            AND CodAsegurado  = nCodAseguradoOrig
            AND IdFondo       = nIdFondoOrig
            AND IdTransaccion = nIdTransaccion;
      END IF;
   END IF;

   -- Inserta Movimiento a Fondo Destino
   IF cOrigenTraspaso != 'RENOVACION' THEN
      nIdTransaccion  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');
      cCodMonedaDest  := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondoDest);
      IF cCodMonedaDest != cCodMonedaOrig THEN
         nMontoMovMoneda := nMontoMovLocal / OC_GENERALES.FUN_TASA_CAMBIO(cCodMonedaDest,dFecTasaCambio);
      END IF;
      nMontoMovLocal  := ABS(nMontoMovLocal);
      nMontoMovMoneda := ABS(nMontoMovMoneda);
      IF cOrigenTraspaso != 'APORTECONTRAT' THEN
         cDescMovimiento := 'Traspaso del Fondo ' || cTipoFondoOrig || ' de la Póliza ' || nIdPolizaOrig ||
                            ' para el Fondo ' || cTipoFondoDest || ' de la Póliza ' || nIdPolizaDest ||
                            ' Realizado el ' || TO_CHAR(dFecTraspaso,'DD/MM/YYYY') || ' Por un Monto Local de ' ||
                            TRIM(TO_CHAR(nMontoMovLocal,'999,999,999,990.00'))||' y un Monto Moneda de '||
                            TRIM(TO_CHAR(nMontoMovMoneda,'999,999,999,990.00'));
      ELSE
         cDescMovimiento := 'Traspaso de Aporte del Fondo del Contratante ' || cTipoFondoOrig || ' No. ' || nIdFondoOrig ||
                            ' de la Póliza ' || nIdPolizaOrig || ' para aporte al Fondo del Asegurado ' || cTipoFondoDest ||
                            ' No. ' || nIdFondoDest || ' de la Póliza ' || nIdPolizaDest || ' Realizado el ' ||
                            TO_CHAR(dFecTraspaso,'DD/MM/YYYY') ||  ' Por un Monto Local de ' ||
                            TRIM(TO_CHAR(nMontoMovLocal,'999,999,999,990.00')) || ' y un Monto Moneda de ' ||
                            TRIM(TO_CHAR(nMontoMovMoneda,'999,999,999,990.00'));
      END IF;
      /*OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia,  nCodEmpresa, 21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                  nIdPolizaDest, nIDetPolDest, nIdFondoDest, cCodCptoMovDest, NVL(nMontoMovMoneda,0));*/

      GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPolizaDest, nIDetPolDest, nCodAseguradoDest, nIdFondoDest,
                                                           cCodCptoMovDest, nIdTransaccion, cCodMonedaDest, nMontoMovLocal, nMontoMovMoneda,
                                                           'D', nTasaCambio, dFecTasaCambio, dFecTraspaso, cDescMovimiento);

      IF cOrigenTraspaso = 'APORTECONTRAT' THEN
         GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPolizaDest, nIDetPolDest,
                                                       nCodAseguradoDest, nIdFondoDest, nIdTransaccion);

         GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOV_INFORMATIVOS(nCodCia, nCodEmpresa, nIdPolizaDest, nIDetPolDest,
                                                            nCodAseguradoDest, nIdFondoDest, nIdTransaccion);

         OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');
      END IF;
   ELSE
      IF NVL(nIdFondo,0) > 0 THEN
         nIdTransaccion  := 0;
         cCodMonedaDest  := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondoDest);
         IF cCodMonedaDest != cCodMonedaOrig THEN
            nMontoMovMoneda := nMontoMovLocal / OC_GENERALES.FUN_TASA_CAMBIO(cCodMonedaDest,dFecTasaCambio);
         END IF;
         nMontoMovLocal  := ABS(nMontoMovLocal);
         nMontoMovMoneda := ABS(nMontoMovMoneda);
         cDescMovimiento := 'Traspaso del Fondo ' || cTipoFondoOrig || ' de la Póliza ' || nIdPolizaOrig ||
                            ' para el Fondo ' || cTipoFondoDest || ' de la Póliza ' || nIdPolizaDest ||
                            ' Realizado el ' || TO_CHAR(dFecTraspaso,'DD/MM/YYYY') || ' Por un Monto Local de ' ||
                            TRIM(TO_CHAR(nMontoMovLocal,'999,999,999,990.00'))||' y un Monto Moneda de '||
                            TRIM(TO_CHAR(nMontoMovMoneda,'999,999,999,990.00'));

         GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPolizaDest, nIDetPolDest, nCodAseguradoDest, nIdFondo,
                                                              cCodCptoMovDest, nIdTransaccion, cCodMonedaDest, nMontoMovLocal, nMontoMovMoneda,
                                                              'D', nTasaCambio, dFecTasaCambio, dFecTraspaso, cDescMovimiento);
      END IF;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR( -20100, 'Error en Traspado de Fondo ' || SQLERRM);
END TRASPASO_FONDOS;

FUNCTION REVISA_RETIROS_EXISTENTES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                   nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                                   cCodCptoMov VARCHAR2, dFecIni DATE, dFecFin DATE ) RETURN NUMBER IS
nCantRetiros    NUMBER;
BEGIN

  SELECT COUNT(*)
    INTO nCantRetiros
    FROM FAI_CONCENTRADORA_FONDO
   WHERE CodCia           = nCodCia
     AND CodEmpresa       = nCodEmpresa
     AND IdPoliza         = nIdPoliza
     AND IDetPol          = nIDetPol
     AND CodAsegurado     = nCodAsegurado
     AND IdFondo          = nIdFondo
     AND CodCptoMov       = cCodCptoMov
     AND StsMovimiento    = 'ACTIVO'
     AND FecMovimiento   >= dFecIni
     AND FecMovimiento   <= dFecFin;

   RETURN(nCantRetiros);
END REVISA_RETIROS_EXISTENTES;

PROCEDURE ACTUALIZA_FACTURA_MOVIMIENTOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                        nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                                        nIdTransaccion NUMBER, nIdFactura NUMBER) IS
BEGIN
   UPDATE FAI_CONCENTRADORA_FONDO
      SET IdFactura       = nIdFactura
    WHERE CodCia          = nCodCia
      AND CodEmpresa      = nCodEmpresa
      AND IdPoliza        = nIdPoliza
      AND IDetPol         = nIDetPol
      AND CodAsegurado    = nCodAsegurado
      AND IdFondo         = nIdFondo
      AND IdTransaccion   = nIdTransaccion;
END ACTUALIZA_FACTURA_MOVIMIENTOS;

FUNCTION ES_FACTURA_DE_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                              nIDetPol NUMBER, nIdFactura NUMBER) RETURN VARCHAR2 IS
cExisteFact    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExisteFact
        FROM FAI_CONCENTRADORA_FONDO
       WHERE CodCia           = nCodCia
         AND CodEmpresa       = nCodEmpresa
         AND IdPoliza         = nIdPoliza
         AND IDetPol          = nIDetPol
         AND CodAsegurado     > 0
         AND IdFactura        = nIdFactura;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExisteFact := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExisteFact := 'S';
   END;
   RETURN(cExisteFact);
END ES_FACTURA_DE_FONDOS;

FUNCTION MONTO_CONCEPTO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                        nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                        cTipoMovimiento VARCHAR2, dFecInicial IN DATE, dFecFinal IN DATE) RETURN NUMBER IS
cTipoFondo           FAI_FONDOS_DETALLE_POLIZA.TipoFondo%TYPE;
nMontoMovMoneda      FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
BEGIN
   cTipoFondo := GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO (nIdFondo);
   BEGIN
      SELECT NVL(SUM(MontoMovMoneda),0)
        INTO nMontoMovMoneda
        FROM FAI_CONCENTRADORA_FONDO
       WHERE CodCia                = nCodCia
         AND CodEmpresa            = nCodEmpresa
         AND IdPoliza              = nIdPoliza
         AND IDetPol               = nIDetPol
         AND CodAsegurado          = nCodAsegurado
         AND IdFondo               = nIdFondo
         AND TRUNC(FecMovimiento) >= TRUNC(dFecInicial)
         AND TRUNC(FecMovimiento) <= TRUNC(dFecFinal)
         AND StsMovimiento         = 'ACTIVO'
         AND GT_FAI_MOVIMIENTOS_FONDOS.TIPO_MOVIMIENTO(nCodCia, nCodEmpresa, cTipoFondo, CodCptoMov) = cTipoMovimiento;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMontoMovMoneda := 0;
   END;
   RETURN(nMontoMovMoneda);
END MONTO_CONCEPTO;

FUNCTION TOTAL_MOVIMIENTOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                           nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                           cTipoMovimiento VARCHAR2, dFecInicial IN DATE, dFecFinal IN DATE) RETURN NUMBER IS
cTipoFondo           FAI_FONDOS_DETALLE_POLIZA.TipoFondo%TYPE;
nTotalMovimientos    NUMBER(10);
BEGIN
   cTipoFondo := GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO (nIdFondo);
   BEGIN
      SELECT COUNT(*)
        INTO nTotalMovimientos
        FROM FAI_CONCENTRADORA_FONDO
       WHERE CodCia                = nCodCia
         AND CodEmpresa            = nCodEmpresa
         AND IdPoliza              = nIdPoliza
         AND IDetPol               = nIDetPol
         AND CodAsegurado          = nCodAsegurado
         AND IdFondo               = nIdFondo
         AND TRUNC(FecMovimiento) >= TRUNC(dFecInicial)
         AND TRUNC(FecMovimiento) <= TRUNC(dFecFinal)
         AND StsMovimiento         = 'ACTIVO'
         AND GT_FAI_MOVIMIENTOS_FONDOS.TIPO_MOVIMIENTO(nCodCia, nCodEmpresa, cTipoFondo, CodCptoMov) = cTipoMovimiento;
   END;
   RETURN(nTotalMovimientos);
END TOTAL_MOVIMIENTOS;

PROCEDURE ELIMINA_MOV_SOLICITUD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
BEGIN
   DELETE FAI_CONCENTRADORA_FONDO
    WHERE CodCia          = nCodCia
      AND CodEmpresa      = nCodEmpresa
      AND IdPoliza        = nIdPoliza
      AND IDetPol         = nIDetPol
      AND CodAsegurado    = nCodAsegurado
      AND IdFondo         = nIdFondo
      AND  StsMovimiento  = 'SOLICI';
END ELIMINA_MOV_SOLICITUD;

END GT_FAI_CONCENTRADORA_FONDO;
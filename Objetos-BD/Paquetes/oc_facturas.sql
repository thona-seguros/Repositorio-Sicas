CREATE OR REPLACE PACKAGE SICAS_OC.OC_FACTURAS IS

    PROCEDURE PAGAR_CON_PRIMA_DEPOSITO(nIdFactura NUMBER, nIdPrimaDeposito NUMBER, cNumReciboPago VARCHAR2,
                                       dFecPago DATE, cNumDepBancario VARCHAR2, nIdTransaccion NUMBER);

    PROCEDURE PAGAR_CON_NOTA_DE_CREDITO(nIdFactura NUMBER, nIdNcr NUMBER, cNumReciboPago VARCHAR2,
                                        dFecPago DATE, cNumDepBancario VARCHAR2, nIdTransaccion NUMBER);

    FUNCTION INSERTAR(nIdPoliza NUMBER, nIDetPol NUMBER, nCodCliente NUMBER, dFecPago DATE,
                      nMtoPagoLocal NUMBER, nMtoPagoMoneda NUMBER, nIdEndoso NUMBER,
                      nMtoComisiLocal NUMBER, nMtoComisiMoneda NUMBER, nNumPago NUMBER,
                      nTasaCambio NUMBER, cCod_Agente VARCHAR2, cCodTipoDoc VARCHAR2,
                      nCodCia NUMBER, cCodMoneda VARCHAR2, nCodResPago NUMBER,
                      nIdTransaccion NUMBER, cIndFactElectronica VARCHAR2) RETURN NUMBER;

    PROCEDURE ACTUALIZA_FACTURA(nIdFactura NUMBER);
    PROCEDURE ACTUALIZA_FACTURA_STS(nIdFactura NUMBER);
    FUNCTION PAGAR(nIdFactura NUMBER, cNumReciboPago VARCHAR2, dFecPago DATE,
                   nMontoPago NUMBER, cFormPago VARCHAR2, cEntPago VARCHAR2, nIdTransaccion NUMBER) RETURN NUMBER;

    FUNCTION PAGAR_FONDOS(nIdFactura NUMBER, cNumReciboPago VARCHAR2, dFecPago DATE,
                          nMontoPago NUMBER, cFormPago VARCHAR2, cEntPago VARCHAR2,
                          nIdTransaccion NUMBER, nPrimaNivelada NUMBER, nMontoAporteFondo NUMBER) RETURN NUMBER;

    FUNCTION EXISTE_SALDO (nCodCia NUMBER, nIdPoliza NUMBER ) RETURN VARCHAR2;

    PROCEDURE ARCHIVO_CLIENTES_FACT_ELECT(nCodCia NUMBER, dFecDesde DATE, dFecHasta DATE);
    PROCEDURE ARCHIVO_FACTURAS_FACT_ELECT(nCodCia NUMBER, dFecDesde DATE, dFecHasta DATE, nIdFactura NUMBER, nLinea IN OUT NUMBER);
    PROCEDURE ARCHIVO_FACT_ELECT_ANUL(nCodCia NUMBER, nIdFactura NUMBER, nLinea IN OUT NUMBER);
    FUNCTION  FRECUENCIA_PAGO(nCodCia NUMBER, nIdFactura NUMBER) RETURN VARCHAR2;
    FUNCTION  CODIGO_PLAN_PAGOS(nCodCia NUMBER, nIdFactura NUMBER) RETURN VARCHAR2;
    PROCEDURE ACTUALIZA_CONTABILIZACION(nCodCia NUMBER, nIdTransaccion NUMBER);
    PROCEDURE CONTABILIZAR_FACTURAS(nCodCia NUMBER, dFecContabilizar DATE);
    PROCEDURE ANULAR(nCodCia NUMBER, nIdFactura NUMBER, dFecAnul DATE, cMotivAnul VARCHAR2,
                     nCodCobrador NUMBER, nIdTransaccion NUMBER);

    PROCEDURE REHABILITACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFacturaAnu NUMBER, nIdTransaccion NUMBER);

    PROCEDURE REVERTIR_PAGO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura NUMBER, nIdRecibo NUMBER,
                            dFecReversion DATE, nCodCobrador NUMBER, nIdTransaccion NUMBER);
    PROCEDURE CAMBIO_COMISIONES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, cStsFact VARCHAR2, dfeinivig DATE);  --COMI --ICOCOMI

    FUNCTION VIGENCIA_FINAL(nCodCia        NUMBER,   nCodEmpresa    NUMBER,  nIdPoliza      NUMBER,
                            nIdFactura     NUMBER,   nIdEndoso      NUMBER,  dFecIniVigFact DATE,
                            dFecFinVigPol  DATE,     nNUMCUOTA      NUMBER,  cCodPlanPagos  VARCHAR2) RETURN DATE;   -- INICIA FINVIG  LARPLA

    FUNCTION F_GET_FACT ( P_Msg_Regreso    out  nocopy varchar2 ) RETURN NUMBER; --SEQ XDS 2016/07/27

    FUNCTION EN_COBRANZA_MASIVA(nCodCia NUMBER, nIdFactura NUMBER) RETURN VARCHAR2;

    FUNCTION FACTURA_ELECTRONICA(nIdFactura  NUMBER, nCodCia  NUMBER, nCodEmpresa  NUMBER,
                                     cTipoCfdi VARCHAR2, cIndRelaciona VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;

    FUNCTION DESC_COMPLEMENTARIA_FACT_ELECT(nIdFactura  NUMBER, nCodCia  NUMBER) RETURN VARCHAR2;

    FUNCTION IND_RFC_GENERICO_FACT_ELECT(nIdFactura  NUMBER, nCodCia  NUMBER) RETURN VARCHAR2;
    FUNCTION CTE_RFC_GENERICO_FACT_ELECT(nIdFactura  NUMBER, nCodCia  NUMBER) RETURN NUMBER;

    FUNCTION NUM_INTENTOS_COBRA_REALIZADOS (nIdFactura  NUMBER, nCodCia  NUMBER) RETURN NUMBER;

    FUNCTION INTENTOS_COBRANZA_CUMPLIDOS (nIdFactura  NUMBER, nCodCia  NUMBER) RETURN VARCHAR2;

    PROCEDURE ACTUALIZA_NUMERO_INTENTOS (nIdFactura  NUMBER, nCodCia  NUMBER, nNumIntento NUMBER);

    PROCEDURE MARCA_INTENTOS_CUMPLIDOS (nIdFactura  NUMBER, nCodCia  NUMBER);

    FUNCTION CALCULA_AÑO_POLIZA(nIdPoliza NUMBER, nFechaproceso  DATE) RETURN NUMBER;

    FUNCTION PRIMA_COMPLEMENTARIA (nCodCia NUMBER, nIdPoliza NUMBER, nIdFactura NUMBER) RETURN NUMBER;

    FUNCTION PAGAR_ALTURA_CERO(nIdFactura NUMBER, cNumReciboPago VARCHAR2, dFecPago DATE, nMontoPago NUMBER,
                               cFormPago VARCHAR2, cEntPago VARCHAR2, nIdTransaccion NUMBER,
                               nMontoPrimaCompMoneda NUMBER, nMontoAporteFondo NUMBER) RETURN NUMBER;
    --                               
    FUNCTION FACTURA_ELECTRONICA_SAT40(P_CODCIA     NUMBER,                                       
                                       PIDFACTURA  NUMBER,
                                       PIDNCR      NUMBER,
                                       P_CVE_MOTIVCANCFACT VARCHAR2,
                                       P_IdTimbre OUT NUMBER) RETURN VARCHAR2;    
    FUNCTION FACTURA_RELACIONADA_UUID_CANC(P_CODCIA     NUMBER,                                       
                                        PIDFACTURA  NUMBER) RETURN VARCHAR2;
    --
    FUNCTION FACTURA_RELACIONADA_ENDOSO(P_CODCIA     NUMBER,                                       
                                        PIDFACTURA  NUMBER) RETURN VARCHAR2;
    --    
    FUNCTION FACTURA_RELACIONADA(P_CODCIA     NUMBER,                                       
                                 PIDFACTURA   NUMBER) RETURN NUMBER;         
    --
END OC_FACTURAS;
/
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_FACTURAS IS
    --
    -- MODIFICACIONES
    -- INSERCION DE FECHAS A COMISIONES                                       2018/03/06  ICO COMI
    -- CALCULO Y REGISTRO DEL FIN DE VIGENCIA DE RECIBOS Y NOTAS DE CREDITO   2018/03/09  ICO FINVIG
    -- FORMAS DE PAGO                                                         2018/11/05  ICO FREPAG
    -- CALCULO DEL AÑO POLIZA DE RECIBOS Y NOTAS DE CREDITO                   2019/03/27  ICO LARPLA
    --
    PROCEDURE PAGAR_CON_PRIMA_DEPOSITO(nIdFactura NUMBER, nIdPrimaDeposito NUMBER, cNumReciboPago VARCHAR2,
                                       dFecPago DATE, cNumDepBancario VARCHAR2, nIdTransaccion NUMBER) IS
    nCodCia                  EMPRESAS.CodCia%TYPE;
    nCodEmpresa              DETALLE_POLIZA.CodEmpresa%TYPE;
    nSldoFactL               FACTURAS.Saldo_Local%TYPE;
    nSldoFactM               FACTURAS.Saldo_Moneda%TYPE;
    nPorcApl                 FACTURAS.Saldo_Local%TYPE;
    cCod_Moneda              FACTURAS.Cod_Moneda%TYPE;
    nMonto_Fact_Moneda       FACTURAS.Monto_Fact_Moneda%TYPE;
    nSaldo_MonedaPD          PRIMAS_DEPOSITO.Saldo_Moneda%TYPE;
    nSaldo_LocalPD           PRIMAS_DEPOSITO.Saldo_Local%TYPE;
    nMontoPago               FACTURAS.Monto_Fact_Moneda%TYPE;
    nMontoPagoLocal          FACTURAS.Monto_Fact_Local%TYPE;
    cIndPago                 VARCHAR2(1);
    dFecHoy                  DATE;
    nIdRecibo                PAGOS.IdRecibo%TYPE;
    nIdPoliza                FACTURAS.IdPoliza%TYPE;
    nIDetPol                 FACTURAS.IDetPol%TYPE;
    nCodCobrador             FACTURAS.CodCobrador%TYPE;
    nIdEndoso                ENDOSOS.IdEndoso%TYPE;
    nExisteRecPrevio         NUMBER(5);
    dFecVenc                 FACTURAS.FecVenc%TYPE;
    BEGIN
       BEGIN
          SELECT F.CodCia, F.Saldo_Moneda, F.Saldo_Local, F.IDetPol,
                 F.Monto_Fact_Moneda, DP.CodEmpresa, F.Cod_Moneda, F.IdPoliza,
                 F.CodCobrador, F.IdEndoso, F.FecVenc
            INTO nCodCia, nSldoFactM, nSldoFactL, nIDetPol,
                 nMonto_Fact_Moneda, nCodEmpresa, cCod_Moneda, nIdPoliza,
                 nCodCobrador, nIdEndoso, dFecVenc
            FROM FACTURAS F, DETALLE_POLIZA DP
           WHERE DP.IdPoliza = F.IdPoliza
             AND DP.IDetPol  = F.IDetPol
             AND F.IdFactura = nIdFactura;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'No Existe Factura x Pagar '||nIdFactura);
       END;

       IF GT_FAI_CONCENTRADORA_FONDO.ES_FACTURA_DE_FONDOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdFactura) = 'N' THEN
          SELECT COUNT(*)
            INTO nExisteRecPrevio
            FROM FACTURAS
           WHERE CodCia     = nCodCia
             AND IdPoliza   = nIdPoliza
             AND IDetPol    = nIDetPol
             AND IdEndoso   = nIdEndoso
             --AND IdFactura  < nIdFactura
             AND FecVenc    < dFecVenc
             AND StsFact    = 'EMI';

          IF NVL(nExisteRecPrevio,0) > 0 THEN
             RAISE_APPLICATION_ERROR (-20100,'Existen Facturas Anteriores Pendientes de Pago.  NO puede Realizar la Cobranza de la Factura No. '||nIdFactura);
          END IF;
       END IF;

       BEGIN
          SELECT Saldo_Moneda, Saldo_Local
            INTO nSaldo_MonedaPD, nSaldo_LocalPD
            FROM PRIMAS_DEPOSITO
           WHERE IdPrimaDeposito = nIdPrimaDeposito;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'No Existe Prima en Depósito x Aplicar '||nIdPrimaDeposito);
       END;

       nIdRecibo := OC_PAGOS.CORRELATIVO_PAGO(nCodCia, nCodEmpresa);

    --   nIdTransac := OC_TRANSACCION.CREA(nCodCia, 1, 12, 'PAG');
        /*Paga o Abona Factura*/
       IF nSaldo_MonedaPD > nMonto_Fact_Moneda THEN
          nPorcApl   := (nMonto_Fact_Moneda / nSaldo_MonedaPD)*100;
       ELSE
          nPorcApl   := (nSaldo_MonedaPD / nMonto_Fact_Moneda)*100;
       END IF;
       --
       IF NVL(nSaldo_MonedaPD,0) != 0 THEN
          IF nSaldo_MonedaPD >= nSldoFactM THEN
             nMontoPago       := nSldoFactM;
             nMontoPagoLocal  := nSldoFactL;
             OC_PAGOS.INGRESA_PAGOS(nCodCia, nCodEmpresa, cCod_Moneda, nIdFactura, nSldoFactM,
                                    nIdTransaccion, 'PRD', nIdRecibo, TO_CHAR(nIdPrimaDeposito));
             UPDATE FACTURAS
                SET StsFact      = 'PAG',
                    Saldo_Moneda = 0,
                    Saldo_local  = 0,
                    ReciboPago   = cNumReciboPago,
                    NumFact      = cNumDepBancario,
                    FecPago      = dFecPago,
                    FecSts       = dFecPago
              WHERE IdFactura = nIdFactura;
             cIndPago := 'T';
          ELSE
             nMontoPago      := nSaldo_MonedaPD;
             nMontoPagoLocal := nSaldo_LocalPD;
             OC_PAGOS.INGRESA_PAGOS(nCodCia, nCodEmpresa, cCod_Moneda, nIdFactura, nSaldo_MonedaPD,
                                    nIdTransaccion, 'PRD', nIdRecibo, TO_CHAR(nIdPrimaDeposito));
             UPDATE FACTURAS
                SET StsFact      = 'ABO',
                    Saldo_Moneda = Saldo_Moneda - nSaldo_MonedaPD,
                    Saldo_local  = Saldo_Local  - nSaldo_LocalPD,
                    ReciboPago   = cNumReciboPago,
                    FecPago      = dFecPago,
                    FecSts       = dFecPago
              WHERE IdFactura = nIdFactura;
             cIndPago := 'P';
          END IF;

          /*Paga o Abona Detalle de Factura*/
          OC_DETALLE_FACTURAS.PAGO_ABONO_DETALLE(nIdFactura, nMontoPago, nMontoPagoLocal, nIdRecibo);
          IF nCodCobrador IS NOT NULL THEN
             OC_COMISION_COBRADOR.PROC_PAGA_COMI_COBRA(nIdFactura, nMontoPago, dFecPago, nPorcApl, cIndPago,
                                                       nCodCobrador, cCod_Moneda, cNumReciboPago);
          END IF;
          OC_DETALLE_TRANSACCION.CREA (nIdTransaccion, nCodCia, 1, 12, 'PAG', 'FACTURAS', nIdPoliza, nIDetPol, NULL, nIdFactura, nMontoPago);
          ACTUALIZA_FACTURA_STS(nIdFactura);
          OC_COMISIONES.PAGA_ABONA_COMISION(nIdFactura, cNumReciboPago, TRUNC(SYSDATE), nPorcApl, cIndPago);
          /*Paga o abona Prima Deposito*/
          -- Se cambia la aplicación y contabilidad a la forma mantfact o los procesos que pagan con Prima en Depósito - EC - 24-Oct-2014
          --OC_PRIMAS_DEPOSITO.APLICAR(nCodCia, nCodEmpresa, nIdPrimaDeposito, dFecPago, cNumReciboPago,
          --                           nSaldo_MonedaPD, nSaldo_LocalPD, nSldoFactM, nSldoFactL);
          --OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransac, 'C');
       ELSE
          RAISE_APPLICATION_ERROR (-20100,'Prima en Depósito '||nIdPrimaDeposito|| ' No tiene Saldo por Aplicar');
       END IF;
    END PAGAR_CON_PRIMA_DEPOSITO;

    PROCEDURE PAGAR_CON_NOTA_DE_CREDITO(nIdFactura NUMBER, nIdNcr NUMBER, cNumReciboPago VARCHAR2,
                                        dFecPago DATE, cNumDepBancario VARCHAR2, nIdTransaccion NUMBER) IS
    nCodCia                  EMPRESAS.CodCia%TYPE;
    nCodEmpresa              DETALLE_POLIZA.CodEmpresa%TYPE;
    nSldoFactL               FACTURAS.Saldo_Local%TYPE;
    nSldoFactM               FACTURAS.Saldo_Moneda%TYPE;
    nPorcApl                 FACTURAS.Saldo_Local%TYPE;
    cCod_Moneda              FACTURAS.Cod_Moneda%TYPE;
    nMonto_Fact_Moneda       FACTURAS.Monto_Fact_Moneda%TYPE;
    nSaldo_Ncr_Local         NOTAS_DE_CREDITO.Saldo_Ncr_Local%TYPE;
    nSaldo_Ncr_Moneda        NOTAS_DE_CREDITO.Saldo_Ncr_Moneda%TYPE;
    nMontoPago               FACTURAS.Monto_Fact_Moneda%TYPE;
    nMontoPagoLocal          FACTURAS.Monto_Fact_Local%TYPE;
    cIndPago                 VARCHAR2(1);
    dFecHoy                  DATE;
    nIdRecibo                PAGOS.IdRecibo%TYPE;
    nIdPoliza                FACTURAS.IdPoliza%TYPE;
    nIDetPol                 FACTURAS.IDetPol%TYPE;
    nCodCobrador             FACTURAS.CodCobrador%TYPE;
    nIdEndoso                ENDOSOS.IdEndoso%TYPE;
    nExisteRecPrevio         NUMBER(5);
    BEGIN
       BEGIN
          SELECT F.CodCia, F.Saldo_Moneda, F.Saldo_Local, F.IDetPol,
                 F.Monto_Fact_Moneda, DP.CodEmpresa, F.Cod_Moneda, F.IdPoliza,
                 F.CodCobrador, F.IdEndoso
            INTO nCodCia, nSldoFactM, nSldoFactL, nIDetPol,
                 nMonto_Fact_Moneda, nCodEmpresa, cCod_Moneda, nIdPoliza,
                 nCodCobrador, nIdEndoso
            FROM FACTURAS F, DETALLE_POLIZA DP
           WHERE DP.IdPoliza = F.IdPoliza
             AND DP.IDetPol  = F.IDetPol
             AND F.IdFactura = nIdFactura;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'No Existe Factura x Pagar '||nIdFactura);
       END;

       SELECT COUNT(*)
         INTO nExisteRecPrevio
         FROM FACTURAS
        WHERE CodCia     = nCodCia
          AND IdPoliza   = nIdPoliza
          AND IDetPol    = nIDetPol
          AND IdEndoso   = nIdEndoso
          AND IdFactura  < nIdFactura
          AND StsFact    = 'EMI';

       IF NVL(nExisteRecPrevio,0) > 0 THEN
          RAISE_APPLICATION_ERROR (-20100,'Existen Facturas Anteriores Pendientes de Pago.  NO puede Realizar la Cobranza de la Factura No. '||nIdFactura);
       END IF;

       BEGIN
          SELECT Saldo_Ncr_Moneda, Saldo_Ncr_Local
            INTO nSaldo_Ncr_Moneda, nSaldo_Ncr_Local
            FROM NOTAS_DE_CREDITO
           WHERE IdNcr = nIdNcr;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'No Existe Nota de Crédito x Aplicar '||nIdNcr);
       END;

       nIdRecibo := OC_PAGOS.CORRELATIVO_PAGO(nCodCia, nCodEmpresa);

    --   nIdTransac := OC_TRANSACCION.CREA(nCodCia, 1, 12, 'PAG');
        /*Paga o Abona Factura*/
       IF NVL(nSaldo_Ncr_Moneda,0) > NVL(nMonto_Fact_Moneda,0) THEN
          nPorcApl   := (nMonto_Fact_Moneda / nSaldo_Ncr_Moneda)*100;
       ELSE
          nPorcApl   := (nSaldo_Ncr_Moneda / nMonto_Fact_Moneda)*100;
       END IF;
       --
       IF NVL(nSaldo_Ncr_Moneda,0) != 0 THEN
          IF nSaldo_Ncr_Moneda >= nSldoFactM THEN
             nMontoPago       := nSldoFactM;
             nMontoPagoLocal  := nSldoFactL;
             OC_PAGOS.INGRESA_PAGOS(nCodCia, nCodEmpresa, cCod_Moneda, nIdFactura, nSldoFactM,
                                    nIdTransaccion, 'NCR', nIdRecibo, TO_CHAR(nIdNcr));
             UPDATE FACTURAS
                SET StsFact      = 'PAG',
                    Saldo_Moneda = 0,
                    Saldo_local  = 0,
                    ReciboPago   = cNumReciboPago,
                    NumFact      = cNumDepBancario,
                    FecPago      = dFecPago,
                    FecSts       = dFecPago
              WHERE IdFactura = nIdFactura;
             cIndPago := 'T';
          ELSE
             nMontoPago      := nSaldo_Ncr_Moneda;
             nMontoPagoLocal := nSaldo_Ncr_Local;
             OC_PAGOS.INGRESA_PAGOS(nCodCia, nCodEmpresa, cCod_Moneda, nIdFactura, nSaldo_Ncr_Moneda,
                                    nIdTransaccion, 'NCR', nIdRecibo, TO_CHAR(nIdNcr));
             UPDATE FACTURAS
                SET StsFact      = 'ABO',
                    Saldo_Moneda = Saldo_Moneda - nSaldo_Ncr_Moneda,
                    Saldo_local  = Saldo_Local  - nSaldo_Ncr_Local,
                    ReciboPago   = cNumReciboPago,
                    FecPago      = dFecPago,
                    FecSts       = dFecPago
              WHERE IdFactura = nIdFactura;
             cIndPago := 'P';
          END IF;

          /*Paga o Abona Detalle de Factura*/
          OC_DETALLE_FACTURAS.PAGO_ABONO_DETALLE(nIdFactura, nMontoPago, nMontoPagoLocal, nIdRecibo);
          IF nCodCobrador IS NOT NULL THEN
             OC_COMISION_COBRADOR.PROC_PAGA_COMI_COBRA(nIdFactura, nMontoPago, dFecPago, nPorcApl, cIndPago,
                                                       nCodCobrador, cCod_Moneda, cNumReciboPago);
          END IF;
          OC_DETALLE_TRANSACCION.CREA (nIdTransaccion, nCodCia, 1, 12, 'PAG', 'FACTURAS', nIdPoliza, nIDetPol, NULL, nIdFactura, nMontoPago);
          ACTUALIZA_FACTURA_STS(nIdFactura);
          OC_COMISIONES.PAGA_ABONA_COMISION(nIdFactura, cNumReciboPago, TRUNC(SYSDATE), nPorcApl, cIndPago);
       ELSE
          RAISE_APPLICATION_ERROR (-20100,'Nota de Crédito '||nIdNcr|| ' No tiene Saldo por Aplicar');
       END IF;
    END PAGAR_CON_NOTA_DE_CREDITO;

    FUNCTION INSERTAR(nIdPoliza     NUMBER,    nIDetPol        NUMBER,   nCodCliente         NUMBER,
                      dFecPago      DATE,      nMtoPagoLocal   NUMBER,   nMtoPagoMoneda      NUMBER,
                      nIdEndoso     NUMBER,    nMtoComisiLocal NUMBER,   nMtoComisiMoneda    NUMBER,
                      nNumPago      NUMBER,    nTasaCambio     NUMBER,   cCod_Agente         VARCHAR2,
                      cCodTipoDoc   VARCHAR2,  nCodCia         NUMBER,   cCodMoneda          VARCHAR2,
                      nCodResPago   NUMBER,    nIdTransaccion  NUMBER,   cIndFactElectronica VARCHAR2   --INICIO LARPLA
                      ) RETURN NUMBER IS
    --
    nIdFactura      FACTURAS.IDFACTURA%TYPE;
    P_Msg_Regreso   VARCHAR2(50);                 -- XDS
    nId_Año_Poliza  FACTURAS.Id_Año_Poliza%TYPE;
    dFecFinVigFact  FACTURAS.FecFinVig%TYPE;
    dFecFinVigPol   POLIZAS.FecFinVig%TYPE;
    nCodEmpresa     POLIZAS.CodEmpresa%TYPE;
    cCodPlanPago    POLIZAS.CodPlanPago%TYPE;
    BEGIN
      --
      BEGIN
        SELECT P.FecFinVig,   P.CodEmpresa,   P.CodPlanPago
          INTO dFecFinVigPol, nCodEmpresa,    cCodPlanPago
          FROM POLIZAS P
         WHERE P.IDPOLIZA = nIdPoliza;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             dFecFinVigPol := '';
             nCodEmpresa   := '';
             cCodPlanPago  := '';
        WHEN TOO_MANY_ROWS THEN
             dFecFinVigPol := '';
             nCodEmpresa   := '';
             cCodPlanPago  := '';
        WHEN OTHERS THEN
             dFecFinVigPol := '';
             nCodEmpresa   := '';
             cCodPlanPago  := '';
      END;
      --
      nIdFactura     := OC_FACTURAS.F_GET_FACT(P_Msg_Regreso);  -- Cambio a secuencia XDS
      --
      nId_Año_Poliza := OC_FACTURAS.CALCULA_AÑO_POLIZA(nIdPoliza, dFecPago);
      --
      IF nIdEndoso > 0 AND nNumPago = 1 THEN
                 --Query para determinar la fecha de vencimiento del primer recibo en caso de que se trate de un endoso
                 SELECT FecFinVig
                 INTO   dFecFinVigFact
                 FROM   FACTURAS
                 WHERE  CodCia   = nCodCia
                   AND  IdPoliza = nIdPoliza
                   AND  IDetPol  = nIDetPol
                   AND  IdEndoso = 0
                   AND  TRUNC(dFecPago) BETWEEN TRUNC(FecVenc) AND TRUNC(FecFinVig)
                   AND  IdFactura = ( SELECT MAX(A.IdFactura)
                                      FROM   FACTURAS A
                                      WHERE  A.CodCia   = nCodCia
                                        AND  A.IdPoliza = nIdPoliza
                                        AND  A.IDetPol  = nIDetPol
                                        AND  A.IdEndoso = 0
                                        AND  TRUNC(dFecPago) BETWEEN TRUNC(A.FecVenc) AND TRUNC(A.FecFinVig));
      ELSE
         dFecFinVigFact := OC_FACTURAS.VIGENCIA_FINAL(nCodCia,       nCodEmpresa,  nIdPoliza,
                                                      nIdFactura,    nIdEndoso,    dFecPago,
                                                      dFecFinVigPol, nNumPago,     cCodPlanPago);
      END IF;
      --
      INSERT INTO FACTURAS
              (IdFactura,            IdPoliza,           IDetPol,              CodCliente,
               NumFact,              FecVenc,            Monto_Fact_Local,     Monto_Fact_Moneda,
               StsFact,              FecSts,             ReciboPago,           FecAnul,
               MotivAnul,            IdEndoso,           MtoComisi_Local,      MtoComisi_Moneda,
               NumCuota,             Tasa_Cambio,        CodGenerador,         CodTipoDoc,
               CodCia,               Saldo_Local,        Saldo_Moneda,         Cod_Moneda,
               CodResPago,           IdTransaccion,      IndContabilizada,     FecContabilizada,
               IndFactElectronica,   IndGenAviCob,       FecGenAviCob,         FecFinVig,
               CodPlanPago,          Id_Año_Poliza,      MontoPrimaCompLocal,  MontoPrimaCompMoneda)
      VALUES  (nIdFactura,           nIdPoliza,          nIDetPol,             nCodCliente,
               NULL,                 dFecPago,           nMtoPagoLocal,        nMtoPagoMoneda,
               'EMI',                TRUNC(SYSDATE),     NULL,                 NULL,
               NULL,                 nIdEndoso,          nMtoComisiLocal,      nMtoComisiMoneda,
               nNumPago,             nTasaCambio,        cCod_Agente,          cCodTipoDoc,
               nCodCia,              nMtoPagoLocal,      nMtoPagoMoneda,       cCodMoneda,
               nCodResPago,          nIdTransaccion,     'N',                  NULL,
               cIndFactElectronica,  'N',                NULL,                 dFecFinVigFact,
               cCodPlanPago,         nId_Año_Poliza,     0,                    0);
      --
      RETURN(nIdFactura);
      --
    EXCEPTION
      WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR (-20100,'Error al Insertar Factura '||nIdFactura|| ' ' || SQLERRM);
    END INSERTAR;   --FIN  LARPLA

    PROCEDURE ACTUALIZA_FACTURA(nIdFactura NUMBER) IS
    nMtoTotalLocal        DETALLE_FACTURAS.Monto_Det_Local%TYPE;
    nMtoTotalMoneda       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
    nComision_Local       COMISIONES.Comision_Local%TYPE;
    nComision_Moneda      COMISIONES.Comision_Moneda%TYPE;
    BEGIN
       -- Actualiza Valor de la Factura con Impuestos
       SELECT SUM(Monto_Det_Local), SUM(Monto_Det_Moneda)
         INTO nMtoTotalLocal, nMtoTotalMoneda
         FROM DETALLE_FACTURAS
        WHERE IdFactura = nIdFactura;

       SELECT NVL(SUM(Comision_Local),0), NVL(SUM(Comision_Moneda),0)
         INTO nComision_Local, nComision_Moneda
         FROM COMISIONES
        WHERE IdFactura = nIdFactura;

       UPDATE FACTURAS
          SET Monto_Fact_Local  = nMtoTotalLocal,
              Monto_Fact_Moneda = nMtoTotalMoneda,
              Saldo_Local       = nMtoTotalLocal,
              Saldo_Moneda      = nMtoTotalMoneda,
              MtoComisi_Local   = nComision_Local,
              MtoComisi_Moneda  = nComision_Moneda
        WHERE IdFactura = nIdFactura;
    END ACTUALIZA_FACTURA;

    PROCEDURE ACTUALIZA_FACTURA_STS(nIdFactura NUMBER) IS
    nMtoTotalLocal        DETALLE_FACTURAS.Monto_Det_Local%TYPE;
    nMtoTotalMoneda       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
    BEGIN
       -- Actualiza Valor de la Factura con Impuestos
       SELECT NVL(SUM(Saldo_Det_Moneda),0)
         INTO nMtoTotalLocal
         FROM DETALLE_FACTURAS
        WHERE IdFactura = nIdFactura;
       IF NVL(nMtoTotalLocal,0) = 0 THEN
          UPDATE FACTURAS
             SET StsFact   = 'PAG',
                 FecSts    = TRUNC(SYSDATE)
           WHERE IdFactura = nIdFactura;
       ELSE
          UPDATE FACTURAS
             SET StsFact   = 'ABO',
                 FecSts    = TRUNC(SYSDATE)
           WHERE IdFactura = nIdFactura;
       END IF;
    END ACTUALIZA_FACTURA_STS;

    FUNCTION PAGAR(nIdFactura NUMBER, cNumReciboPago VARCHAR2, dFecPago DATE, nMontoPago NUMBER,
                   cFormPago VARCHAR2, cEntPago VARCHAR2, nIdTransaccion NUMBER) RETURN NUMBER IS
    nCodCia                  EMPRESAS.CodCia%TYPE;
    nCodEmpresa              DETALLE_POLIZA.CodEmpresa%TYPE;
    nSldoFactL               FACTURAS.Saldo_Local%TYPE;
    nSldoFactM               FACTURAS.Saldo_Moneda%TYPE;
    nPorcApl                 FACTURAS.Saldo_Local%TYPE;
    nMonto_Fact_Moneda       FACTURAS.Monto_Fact_Moneda%TYPE;
    nMontoPago_Local         FACTURAS.Monto_Fact_Moneda%TYPE;
    nCodCobrador             FACTURAS.CodCobrador%TYPE;
    cIndPago                 VARCHAR2(1);
    dFecHoy                  DATE;
    cCodMoneda               FACTURAS.Cod_Moneda%type;
    nTasaCambio              TASAS_CAMBIO.Tasa_Cambio%TYPE;
    nCodCliente              FACTURAS.CodCliente%type;
    nNumPD                   primas_deposito.idprimadeposito%type;
    nIdRecibo                PAGOS.IdRecibo%TYPE;
    nIdPoliza                POLIZAS.IdPoliza%TYPE;
    nIDetPol                 DETALLE_POLIZA.IDetPol%TYPE;
    nIdEndoso                ENDOSOS.IdEndoso%TYPE;
    nExisteRecPrevio         NUMBER(5);
    cIdTipoSeg               DETALLE_POLIZA.IdTipoSeg%TYPE;
    nCodAsegurado            DETALLE_POLIZA.Cod_Asegurado%TYPE;
    BEGIN
       BEGIN
          SELECT F.CodCia, F.Saldo_Moneda, F.Saldo_Local, F.Monto_Fact_Moneda,
                 DP.CodEmpresa, F.Cod_Moneda, F.CodCliente, DP.IdPoliza, F.CodCobrador,
                 DP.IDetPol, F.IdEndoso, DP.IdTipoSeg, DP.Cod_Asegurado
            INTO nCodCia, nSldoFactM, nSldoFactL, nMonto_Fact_Moneda,
                 nCodEmpresa, cCodMoneda, nCodCliente, nIdPoliza, nCodCobrador,
                 nIDetPol, nIdEndoso, cIdTipoSeg, nCodAsegurado
            FROM FACTURAS F, DETALLE_POLIZA DP
           WHERE DP.IdPoliza = F.IdPoliza
             AND DP.IDetPol  = F.IDetPol
             AND F.IdFactura = nIdFactura;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RETURN(2);
       END;

       SELECT COUNT(*)
         INTO nExisteRecPrevio
         FROM FACTURAS
        WHERE CodCia     = nCodCia
          AND IdPoliza   = nIdPoliza
          AND IDetPol    = nIDetPol
          AND IdEndoso   = nIdEndoso
          AND IdFactura  < nIdFactura
          AND StsFact    = 'EMI';

       IF NVL(nExisteRecPrevio,0) > 0 THEN
          RAISE_APPLICATION_ERROR (-20100,'Existen Factura Anteriores Pendientes de Pago.  NO puede Realizar la Cobranza de la Factura No. '||nIdFactura);
       END IF;

       nTasaCambio      := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
       nMontoPago_Local := nMontoPago * NVL(nTasaCambio,0);

       nIdRecibo  := OC_PAGOS.CORRELATIVO_PAGO(nCodCia, nCodEmpresa);

       --nIdTransac := OC_TRANSACCION.CREA(nCodCia, 1, 12, 'PAG');
       IF nMontoPago >= nMonto_Fact_Moneda THEN
          nPorcApl   := (nMonto_Fact_Moneda / nMontoPago) * 100;
       ELSE
          nPorcApl   := (nMontoPago / nMonto_Fact_Moneda) * 100;
       END IF;
       IF nMontoPago = nSldoFactM THEN
          OC_PAGOS.INGRESA_PAGOS(nCodCia, nCodEmpresa, cCodMoneda, nIdFactura, nMontoPago,
                                 nIdTransaccion, cFormPago, nIdRecibo, cNumReciboPago);
          UPDATE FACTURAS
            SET StsFact      = 'PAG',
                Saldo_Moneda = 0,
                Saldo_local  = 0,
                ReciboPago   = cNumReciboPago,
                FormPago     = cFormPago,
                FecPago      = dFecPago,
                EntPago      = cEntPago
          WHERE IdFactura    = nIdFactura;
          cIndPago := 'T';
       ELSIF nMontoPago > nSldoFactM THEN
          OC_PAGOS.INGRESA_PAGOS(nCodCia, nCodEmpresa, cCodMoneda, nIdFactura, nMontoPago,
                                 nIdTransaccion, cFormPago, nIdRecibo, cNumReciboPago);
          UPDATE FACTURAS
             SET StsFact      = 'PAG',
                 Saldo_Moneda = 0,
                 Saldo_local  = 0,
                 ReciboPago   = cNumReciboPago,
                 FormPago     = cFormPago,
                 FecPago      = dFecPago,
                 EntPago      = cEntPago
           WHERE IdFactura = nIdFactura;
          cIndPago := 'T';
          nNumPD   := OC_PRIMAS_DEPOSITO.INSERTAR(nCodCliente , nMontoPago-nSldoFactM,  cCodMoneda,
                                                  'Por Sobrante en el Pago de la Factura : '||nIdFactura,
                                                  nIdPoliza, nIDetPol);
          OC_PRIMAS_DEPOSITO.EMITIR(nCodCia, nCodEmpresa, nNumPD, TRUNC(SYSDATE), cNumReciboPago);
       ELSE
          OC_PAGOS.INGRESA_PAGOS(nCodCia, nCodEmpresa, cCodMoneda, nIdFactura, nMontoPago,
                                 nIdTransaccion, cFormPago, nIdRecibo, cNumReciboPago);
          UPDATE FACTURAS
            SET StsFact      = 'ABO',
                Saldo_Moneda = Saldo_Moneda - nMontoPago,
                Saldo_local  = Saldo_Local  - nMontoPago_Local,
                ReciboPago   = cNumReciboPago,
                FormPago     = cFormPago,
                FecPago      = dFecPago,
                EntPago      = cEntPago
          WHERE IdFactura    = nIdFactura;
          cIndPago := 'P';
       END IF;
       OC_DETALLE_FACTURAS.PAGO_ABONO_DETALLE(nIdFactura, nMontoPago, nMontoPago_Local, nIdRecibo);
       IF nCodCobrador IS NOT NULL THEN
          OC_COMISION_COBRADOR.PROC_PAGA_COMI_COBRA(nIdFactura, nMontoPago, dFecPago, nPorcApl, cIndPago,
                                                    nCodCobrador, cCodMoneda, cNumReciboPago);
       END IF;

       OC_DETALLE_TRANSACCION.CREA (nIdTransaccion, nCodCia, 1, 12, 'PAG', 'FACTURAS', nIdPoliza, nIDetPol, NULL, nIdFactura, nMontoPago);
       OC_FACTURAS.ACTUALIZA_FACTURA_STS(nIdFactura);
       /*Paga o Abona Detalle de Factura*/
       OC_COMISIONES.PAGA_ABONA_COMISION(nIdFactura, cNumReciboPago, TRUNC(SYSDATE), nPorcApl, cIndPago);
       IF cFormPago IN ('CLAB','CTC','DOMI','LIN') AND OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(nCodCia, nIdPoliza, nIDetPol, nCodAsegurado) = 'N' THEN
          IF OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(nCodCia, nCodEmpresa, cIdTipoSeg) = 'S' THEN
             NOTIFICACOBRANZAOK(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdFactura);
    --      ELSE
    --         NOTIFICACOBRANZAOKSTD (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdFactura);
          END IF;
       END IF;
       RETURN(1);
    EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR (-20100,'Error en Pago de Factura: '||nIdFactura||SQLERRM);
      --  RETURN(0);
    END PAGAR;

    FUNCTION PAGAR_FONDOS(nIdFactura NUMBER, cNumReciboPago VARCHAR2, dFecPago DATE, nMontoPago NUMBER,
                          cFormPago VARCHAR2, cEntPago VARCHAR2, nIdTransaccion NUMBER,
                          nPrimaNivelada NUMBER, nMontoAporteFondo NUMBER) RETURN NUMBER IS
    nCodCia                  EMPRESAS.CodCia%TYPE;
    nCodEmpresa              DETALLE_POLIZA.CodEmpresa%TYPE;
    nSldoFactL               FACTURAS.Saldo_Local%TYPE;
    nSldoFactM               FACTURAS.Saldo_Moneda%TYPE;
    nPorcApl                 FACTURAS.Saldo_Local%TYPE;
    nMonto_Fact_Moneda       FACTURAS.Monto_Fact_Moneda%TYPE;
    nMontoPago_Local         FACTURAS.Monto_Fact_Moneda%TYPE;
    nCodCobrador             FACTURAS.CodCobrador%TYPE;
    cIndPago                 VARCHAR2(1);
    dFecHoy                  DATE;
    cCodMoneda               FACTURAS.Cod_Moneda%type;
    nTasaCambioMov           TASAS_CAMBIO.Tasa_Cambio%TYPE;
    nCodCliente              FACTURAS.CodCliente%type;
    nNumPD                   primas_deposito.idprimadeposito%type;
    nIdRecibo                PAGOS.IdRecibo%TYPE;
    nIdPoliza                POLIZAS.IdPoliza%TYPE;
    nIDetPol                 DETALLE_POLIZA.IDetPol%TYPE;
    nIdEndoso                ENDOSOS.IdEndoso%TYPE;
    nCodAsegurado            DETALLE_POLIZA.Cod_Asegurado%TYPE;
    nNumCuota                FACTURAS.NumCuota%TYPE;
    cObservaciones           PRIMAS_DEPOSITO.Observaciones%TYPE;
    cCodCptoMov              FAI_MOVIMIENTOS_FONDOS.CodCptoMov%TYPE;
    nIdFondo                 FAI_CONCENTRADORA_FONDO.IdFondo%TYPE;
    nIdPrimaDeposito         PRIMAS_DEPOSITO.IdPrimaDeposito%TYPE;
    nIdTransaccionMov        TRANSACCION.IdTransaccion%TYPE;
    nIdTransaccionFact       TRANSACCION.IdTransaccion%TYPE;
    nIdTransaccionPag        TRANSACCION.IdTransaccion%TYPE;
    nIdTransaccionRetiro     TRANSACCION.IdTransaccion%TYPE;
    nMontoMovMoneda          FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
    nMontoMovLocal           FAI_CONCENTRADORA_FONDO.MontoMovLocal%TYPE;
    nSaldoPorAplicar         FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
    nSaldoRestante           FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
    nMontoPrimaDepMon        PRIMAS_DEPOSITO.Monto_Moneda%TYPE;
    nMontoPrimaDepLoc        PRIMAS_DEPOSITO.Monto_Local%TYPE;
    nPorcComis               DETALLE_POLIZA.PorcComis%TYPE;
    nIdFacturaPN             FACTURAS.IdFactura%TYPE;
    nIdFacturaAportes        FACTURAS.IdFactura%TYPE;
    nMtoComisiMoneda         FACTURAS.MtoComisi_Moneda%TYPE;
    nMtoComisiLocal          FACTURAS.MtoComisi_Local%TYPE;
    nTotComiMoneda           FACTURAS.MtoComisi_Moneda%TYPE;
    cIdTipoSeg               DETALLE_POLIZA.IdTipoSeg%TYPE;
    cPlanCob                 DETALLE_POLIZA.PlanCob%TYPE;
    nCod_Agente              AGENTES_DETALLES_POLIZAS.Cod_Agente%TYPE;
    nCodTipoDoc              TIPO_DE_DOCUMENTO.CodTipoDoc%TYPE;
    cIndFactElectronica      DETALLE_POLIZA.IndFactElectronica%TYPE;
    cCodPlanPago             DETALLE_POLIZA.CodPlanPago%TYPE;
    dFecFinVigFact           FACTURAS.FecFinVig%TYPE;
    nSaldoFondo              FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
    nMontoInteres            FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
    cTipoFondo               FAI_FONDOS_DETALLE_POLIZA.TipoFondo%TYPE;
    cNumPolUnico             POLIZAS.NumPolUnico%TYPE;
    nIdPolizaAnu             POLIZAS.IdPoliza%TYPE;
    nExisteRecPrevio         NUMBER(5);
    cFondoPagoPrimas         VARCHAR2(1);
    cCobroFactura            VARCHAR2(1);
    cIndTipoAporte           VARCHAR2(1);

    CURSOR FOND_Q IS
        SELECT TipoFondo, NumSolicitud, PorcFondo, IdFondo
          FROM FAI_FONDOS_DETALLE_POLIZA
         WHERE CodCia        = nCodCia
           AND CodEmpresa    = nCodEmpresa
           AND IdPoliza      = nIdPoliza
           AND IDetPol       = nIDetPol
           AND CodAsegurado  = nCodAsegurado
           AND GT_FAI_TIPOS_DE_FONDOS.INDICADORES(CodCia, CodEmpresa, TipoFondo, 'EPP') = cFondoPagoPrimas
         ORDER BY IdFondo;
    CURSOR CONCEN_Q IS
        SELECT IdFondo, IdMovimiento, CodCptoMov, MontoMovMoneda
          FROM FAI_CONCENTRADORA_FONDO
         WHERE CodCia        = nCodCia
           AND CodEmpresa    = nCodEmpresa
           AND IdPoliza      = nIdPoliza
           AND IDetPol       = nIDetPol
           AND CodAsegurado  = nCodAsegurado
           AND IdFondo       = nIdFondo
           AND StsMovimiento = 'SOLICI'
           AND GT_FAI_MOVIMIENTOS_FONDOS.TIPO_MOVIMIENTO(CodCia, CodEmpresa, cTipoFondo, CodCptoMov) IN ('AA','AP');
    BEGIN
       IF NVL(nMontoPago,0) <> 0 AND NVL(nPrimaNivelada,0) <> 0 THEN
          cIndTipoAporte := 'R';
       ELSIF NVL(nMontoPago,0) = 0 AND NVL(nPrimaNivelada,0) = 0 THEN
          cIndTipoAporte := 'A';
       END IF;

       BEGIN
          SELECT F.CodCia, F.Saldo_Moneda, F.Saldo_Local, F.Monto_Fact_Moneda,
                 DP.CodEmpresa, F.Cod_Moneda, F.CodCliente, DP.IdPoliza, F.CodCobrador,
                 DP.IDetPol, F.IdEndoso, DP.Cod_Asegurado, F.NumCuota, DP.PorcComis,
                 DP.IdTipoSeg, DP.IndFactElectronica, DP.CodPlanPago, DP.PlanCob
            INTO nCodCia, nSldoFactM, nSldoFactL, nMonto_Fact_Moneda,
                 nCodEmpresa, cCodMoneda, nCodCliente, nIdPoliza, nCodCobrador,
                 nIDetPol, nIdEndoso, nCodAsegurado, nNumCuota, nPorcComis,
                 cIdTipoSeg, cIndFactElectronica, cCodPlanPago, cPlanCob
            FROM FACTURAS F, DETALLE_POLIZA DP
           WHERE DP.IdPoliza = F.IdPoliza
             AND DP.IDetPol  = F.IDetPol
             AND F.IdFactura = nIdFactura;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RETURN(2);
       END;

       IF GT_FAI_TIPOS_FONDOS_PRODUCTOS.FONDOS_COLECTIVOS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob) = 'S' THEN
          nCodAsegurado := TO_NUMBER(SUBSTR(cNumReciboPago,11,8));
          nIDetPol      := TO_NUMBER(SUBSTR(cNumReciboPago,8,3));
       END IF;

       BEGIN
          SELECT Cod_Agente
            INTO nCod_Agente
            FROM AGENTES_DETALLES_POLIZAS
           WHERE IdPoliza      = nIdPoliza
             AND IdetPol       = nIDetPol
             AND IdTipoSeg     = cIdTipoSeg
             AND Ind_Principal = 'S';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'No Existe un Agente Definido para el Tipo de Seguro '||cIdTipoSeg);
          WHEN TOO_MANY_ROWS THEN
             RAISE_APPLICATION_ERROR (-20100,'Existen Varios Agentes Definidos como Principal');
          WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR (-20100,'Existe un Error NO Definido de Cobranza de Factura con Fondos');
       END;

       IF cIndTipoAporte = 'R' THEN
          SELECT COUNT(*)
            INTO nExisteRecPrevio
            FROM FACTURAS
           WHERE CodCia     = nCodCia
             AND IdPoliza   = nIdPoliza
             AND IDetPol    = nIDetPol
             AND IdEndoso   = nIdEndoso
             AND IdFactura  < nIdFactura
             AND StsFact    = 'EMI';

          IF NVL(nExisteRecPrevio,0) > 0 THEN
             RAISE_APPLICATION_ERROR (-20100,'Existen Factura Anteriores Pendientes de Pago.  NO puede Realizar la Cobranza de la Factura No. '||nIdFactura);
          END IF;

          IF NVL(nMontoPago,0) < (NVL(nSldoFactM,0) + NVL(nPrimaNivelada,0) + NVL(nMontoAporteFondo,0)) AND
             nNumCuota = 1 THEN
             RAISE_APPLICATION_ERROR (-20100,'Para Pólizas con Manejo de Fondos, debe Cubrir Completo el 1er. Pago para Activarla.  ' ||
                                      ' NO puede Realizar la Cobranza de la Factura No. '||nIdFactura);
          END IF;
       ELSE
          nNumCuota := NULL;
       END IF;

       BEGIN
          SELECT CodTipoDoc
            INTO nCodTipoDoc
            FROM TIPO_DE_DOCUMENTO
           WHERE CodClase = 'F'
             AND Sugerido = 'S';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             nCodTipoDoc := NULL;
       END;

       nTasaCambioMov   := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(dFecPago));

       IF cIndTipoAporte = 'R' THEN
          nSaldoPorAplicar := NVL(nMontoPago,0);
          IF NVL(nPrimaNivelada,0) < 0 THEN -- 30/01/2019
             nIdFondo := GT_FAI_FONDOS_DETALLE_POLIZA.FONDO_PAGO_PRIMA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado);
             IF GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                               nCodAsegurado, nIdFondo,  TRUNC(dFecPago)) > ABS(NVL(nPrimaNivelada,0)) THEN
                nSaldoPorAplicar := NVL(nMontoPago,0) + ABS(NVL(nPrimaNivelada,0));
             ELSE
                RAISE_APPLICATION_ERROR (-20100,'Saldo del Fondo No. ' || nIdFondo || ' NO alcanza para Cubrir la Prima Nivelada por ' ||
                                         ABS(NVL(nPrimaNivelada,0)) || ' para la Cobranza de la Factura No. '||nIdFactura);
             END IF;
          END IF;
       ELSE
          nSaldoPorAplicar := NVL(nMontoAporteFondo,0);
       END IF;

       cCobroFactura    := 'N';

       -- Se realiza el Cobro de la Factura con Prima en Depósito
       IF NVL(nSaldoPorAplicar,0) >= NVL(nSldoFactM,0) OR
          GT_FAI_TIPOS_FONDOS_PRODUCTOS.FONDOS_COLECTIVOS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob) = 'S' THEN
          IF cFormPago != 'PRD' THEN
             IF cIndTipoAporte = 'R' THEN
                cObservaciones     := 'Primas para Pago en Póliza con Fondos de Ahorro de Factura No. ' || nIdFactura ||
                                      ' con Valor de ' || NVL(nMonto_Fact_Moneda,0);
             ELSE
                cObservaciones := 'Aporte Adicional con Valor de '||nvl(nSaldoPorAplicar,0);
                nSldoFactM     := NVL(nSaldoPorAplicar,0);
             END IF;
             nIdPrimaDeposito   := OC_PRIMAS_DEPOSITO.INSERTAR(nCodCliente, NVL(nSldoFactM,0), cCodMoneda,
                                                               cObservaciones, nIdPoliza, nIDetPol);
             OC_PRIMAS_DEPOSITO.EMITIR(nCodCia, nCodEmpresa, nIdPrimaDeposito, dFecPago, cNumReciboPago);
          ELSE
             SELECT MAX(NumPolUnico)
               INTO cNumPolUnico
               FROM POLIZAS
              WHERE CodCia    = nCodCia
                AND IdPoliza  = nIdPoliza;

             SELECT NVL(MAX(IdPoliza),0)
               INTO nIdPolizaAnu
               FROM POLIZAS
              WHERE CodCia       = nCodCia
                AND IdPoliza     < nIdPoliza
                AND MotivAnul    = 'REEX'
                AND StsPoliza    = 'ANU'
                AND NumPolUnico  = cNumPolUnico;

             IF NVL(nIdPolizaAnu,0) = 0 THEN
                RAISE_APPLICATION_ERROR (-20100,'Solo puede Realizar Cobranza con Primas en Depósito por Reexpedición de Póliza ' ||
                                         ' y NO existe una Póliza Anulada con el No. ' || cNumPolUnico);
             ELSE
                SELECT NVL(MIN(IdPrimaDeposito),0)
                  INTO nIdPrimaDeposito
                  FROM PRIMAS_DEPOSITO
                 WHERE CodCliente    = nCodCliente
                   AND IdPoliza      = nIdPolizaAnu
                   AND Cod_Moneda    = cCodMoneda
                   AND Saldo_Moneda >= nSldoFactM
                   AND Estado        = 'PAF'; -- Por Aplicar en Fondo;

                IF NVL(nIdPrimaDeposito,0) = 0 THEN
                   RAISE_APPLICATION_ERROR (-20100,'No Existe Primas en Depósito Con Saldo en Póliza Anulada No. ' || nIdPolizaAnu ||
                                            ' y No. de Póliza Unico ' || cNumPolUnico ||
                                            ' por un Monto Mayor o Igual al Saldo de la Factura de ' || nSldoFactM);
                END IF;
             END IF;
          END IF;

          IF cIndTipoAporte = 'R' THEN
             nIdTransaccionMov  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 12, 'PAG');
             OC_FACTURAS.PAGAR_CON_PRIMA_DEPOSITO(nIdFactura, nIdPrimaDeposito, cNumReciboPago,
                                                  TRUNC(SYSDATE), NULL, nIdTransaccionMov);

             BEGIN
                SELECT MAX(IdRecibo)
                  INTO nIdRecibo
                  FROM PAGOS
                 WHERE CodCia    = nCodCia
                   AND IdFactura = nIdFactura;
             END;

             OC_DETALLE_PRIMAS_DEPOSITO.INSERTAR(nCodCliente, nIdRecibo, nIdPrimaDeposito,
                                                 nIdFactura, nIdPoliza, nSldoFactM, 'PAT');
             OC_PRIMAS_DEPOSITO.APLICAR_FACTURA(nCodCia, nCodEmpresa, nIdPrimaDeposito,
                                                TRUNC(SYSDATE), nIdRecibo, nSldoFactM,
                                                nSldoFactL, nSldoFactM, nSldoFactL,
                                                nIdTransaccionMov);

             OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccionMov, 'C');
             nSaldoPorAplicar  := NVL(nSaldoPorAplicar,0) - NVL(nSldoFactM,0);

             cCobroFactura     := 'S';
          END IF;
       END IF;

       -- Se Crea Prima en Depósito por lo Ingresado que NO Cubre la Factura
       IF cIndTipoAporte = 'R' THEN
          nMontoPrimaDepMon     := NVL(nSaldoPorAplicar,0);
          nMontoPrimaDepLoc     := NVL(nMontoPrimaDepMon,0) * nTasaCambioMov;
          IF cCobroFactura = 'N' THEN
             cObservaciones   := 'Primas no Alcanzan para Pago en Póliza y Aportes al Fondo de Factura No. ' || nIdFactura ||
                                 ' con Valor de ' || NVL(nMonto_Fact_Moneda,0) ||
                                 ' con Prima Nivelada de ' || NVL(nPrimaNivelada,0) ||
                                 ' y un Aporte a Fondos de ' || NVL(nMontoAporteFondo,0);

             nIdPrimaDeposito   := OC_PRIMAS_DEPOSITO.INSERTAR(nCodCliente, NVL(nMontoPrimaDepMon,0), cCodMoneda,
                                                               cObservaciones, nIdPoliza, nIDetPol);
             OC_PRIMAS_DEPOSITO.EMITIR(nCodCia, nCodEmpresa, nIdPrimaDeposito, dFecPago, cNumReciboPago);
          ELSIF cFormPago != 'PRD' THEN
             -- Se Crea Prima en Depósito Por la Prima Nivelada y Aportes al Fondo
             cObservaciones   := 'Primas para Aportes al Fondo de Factura No. ' || nIdFactura ||
                                 ' con Prima Nivelada de ' || NVL(nPrimaNivelada,0) ||
                                 ' y un Aporte a Fondos de ' || NVL(nMontoAporteFondo,0);

             nIdPrimaDeposito   := OC_PRIMAS_DEPOSITO.INSERTAR(nCodCliente, NVL(nMontoPrimaDepMon,0), cCodMoneda,
                                                               cObservaciones, nIdPoliza, nIDetPol);
             OC_PRIMAS_DEPOSITO.EMITIR(nCodCia, nCodEmpresa, nIdPrimaDeposito, dFecPago, cNumReciboPago);
          ELSE
             SELECT NVL(MIN(IdPrimaDeposito),0), NVL(SUM(Saldo_Moneda),0), NVL(SUM(Saldo_Local),0)
               INTO nIdPrimaDeposito, nMontoPrimaDepMon, nMontoPrimaDepLoc
               FROM PRIMAS_DEPOSITO
              WHERE CodCliente    = nCodCliente
                AND IdPoliza      = nIdPolizaAnu
                AND Cod_Moneda    = cCodMoneda
                AND Saldo_Moneda >= NVL(nPrimaNivelada,0)
                AND Estado        = 'PAF'; -- Por Aplicar en Fondo

             IF NVL(nIdPrimaDeposito,0) = 0 THEN
                RAISE_APPLICATION_ERROR (-20100,'No Existen Primas en Depósito Con Saldo Mayor o Igual a la Prima Nivelada en Póliza Anulada No. ' ||
                                         nIdPolizaAnu || ' y No. de Póliza Unico ' || cNumPolUnico);
             END IF;
          END IF;
       END IF;
       /*OC_PRIMAS_DEPOSITO.APLICAR(nCodCia, nCodEmpresa, nIdPrimaDeposito, TRUNC(dFecPago), cNumReciboPago,
                                  nMontoPrimaDepMon, nMontoPrimaDepLoc, nMontoPrimaDepMon, nMontoPrimaDepLoc);*/

       -- Fondos Exclusivos para Pago de Primas
       cFondoPagoPrimas  := 'S';
       nIdRecibo         := NULL;
       nIdTransaccionMov := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');
       IF cIndTipoAporte = 'R' THEN
          FOR W IN FOND_Q LOOP
             -- Se ingresa la Fondo el Monto de la Factura / Prima
             IF cCobroFactura = 'N' THEN
                IF NVL(nSaldoPorAplicar,0) > 0 THEN
                   nMontoMovMoneda   := NVL(nSaldoPorAplicar,0);
                   cCodCptoMov       := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, W.TipoFondo, 'CP');
                   OC_DETALLE_TRANSACCION.CREA(nIdTransaccionMov, nCodCia, nCodEmpresa,  21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                               nIdPoliza, nIDetPol, W.IdFondo, cCodCptoMov, NVL(nMontoMovMoneda,0));
                   nMontoMovLocal    := NVL(nMontoMovMoneda,0) * nTasaCambioMov;
                   GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                        nCodAsegurado, W.IdFondo, cCodCptoMov,
                                                                        nIdTransaccionMov, cCodMoneda, nMontoMovMoneda, nMontoMovLocal,
                                                                        'D', nTasaCambioMov, TRUNC(dFecPago), TRUNC(dFecPago),
                                                                        OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, cCodCptoMov));
                   nSaldoPorAplicar := 0;
                END IF;
             ELSE
                nMontoMovMoneda   := NVL(nSldoFactM,0);
                cCodCptoMov       := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, W.TipoFondo, 'CP');
                nMontoMovLocal    := NVL(nMontoMovMoneda,0) * nTasaCambioMov;
                GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                     nCodAsegurado, W.IdFondo, cCodCptoMov,
                                                                     0, cCodMoneda, nMontoMovMoneda, nMontoMovLocal,
                                                                     'D', nTasaCambioMov, TRUNC(dFecPago), TRUNC(dFecPago),
                                                                     OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, cCodCptoMov));
                GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, W.IdFondo, 0);
                GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOV_INFORMATIVOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, W.IdFondo, 0);
             END IF;

             -- Se ingresa la Fondo el Monto de la Prima Nivelada
             IF NVL(nSaldoPorAplicar,0) >= NVL(nPrimaNivelada,0) THEN
                nMontoMovMoneda   := NVL(nPrimaNivelada,0);
                nSaldoPorAplicar  := NVL(nSaldoPorAplicar,0) - ABS(NVL(nPrimaNivelada,0));
             ELSE
                nMontoMovMoneda   := NVL(nSaldoPorAplicar,0);
             END IF;
             IF NVL(nMontoMovMoneda,0) > 0 THEN
                cCodCptoMov       := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, W.TipoFondo, 'AA');
                OC_DETALLE_TRANSACCION.CREA(nIdTransaccionMov, nCodCia, nCodEmpresa,  21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                            nIdPoliza, nIDetPol, W.IdFondo, cCodCptoMov, NVL(nMontoMovMoneda,0));
                nMontoMovLocal    := NVL(nMontoMovMoneda,0) * nTasaCambioMov;
                GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                     nCodAsegurado, W.IdFondo, cCodCptoMov,
                                                                     nIdTransaccionMov, cCodMoneda, nMontoMovMoneda, nMontoMovLocal,
                                                                     'D', nTasaCambioMov, TRUNC(dFecPago), TRUNC(dFecPago),
                                                                     OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, cCodCptoMov));

                -- Generación de Factura por Movimiento de Prima Nivelada
                nIdTransaccionFact := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'FACFON');

                nMtoComisiMoneda := NVL(nMontoMovMoneda,0) * nPorcComis / 100;
                nMtoComisiLocal  := NVL(nMontoMovLocal,0) * nPorcComis / 100;
                -- LARPLA
                nIdFacturaPN := OC_FACTURAS.INSERTAR(nIdPoliza,               nIDetPol,               nCodCliente, TRUNC(dFecPago),
                                                     NVL(nMontoMovLocal,0),   NVL(nMontoMovMoneda,0), 0,           NVL(nMtoComisiLocal,0),
                                                     NVL(nMtoComisiMoneda,0), nNumCuota,              nTasaCambioMov,
                                                     nCod_Agente, nCodTipoDoc, nCodCia, cCodMoneda, NULL, nIdTransaccionFact, cIndFactElectronica);

                OC_DETALLE_FACTURAS.INSERTAR(nIdFacturaPN, cCodCptoMov, 'S', NVL(nMontoMovLocal,0), NVL(nMontoMovMoneda,0));
                OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFacturaPN, cCodCptoMov, 'S', NVL(nMontoMovLocal,0), NVL(nMontoMovMoneda,0));
                OC_FACTURAR.PROC_COMISIONAG (nIdPoliza, nIDetPol, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFacturaPN,
                                             NVL(nMontoMovLocal,0), NVL(nMontoMovMoneda,0), nTasaCambioMov);
                OC_FACTURAS.ACTUALIZA_FACTURA(nIdFacturaPN);
                OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia, nIdFacturaPN, 'IVASIN');
                BEGIN
                   SELECT NVL(SUM(Comision_Moneda),0)
                     INTO nTotComiMoneda
                     FROM COMISIONES C
                    WHERE CodCia     = nCodCia
                      AND IdComision > 0
                      AND IdPoliza   = nIdPoliza
                      AND EXISTS (SELECT 1
                                    FROM FACTURAS F
                                   WHERE F.IdFactura     = C.IdFactura
                                     AND F.IdTransaccion = nIdTransaccionFact);
                END;
                OC_DETALLE_TRANSACCION.CREA (nIdTransaccionFact, nCodCia, nCodEmpresa, 21, 'FACFON', 'FACTURAS',
                                             nIdPoliza, nIDetPol, W.IdFondo, nIdFacturaPN, NVL(nMontoMovMoneda,0));
                OC_DETALLE_TRANSACCION.CREA (nIdTransaccionFact, nCodCia, nCodEmpresa, 7, 'COMFON', 'COMISIONES',
                                             nIdPoliza, nIDetPol, nIdFacturaPN, NULL, NVL(nTotComiMoneda,0));
                GT_FAI_CONCENTRADORA_FONDO.ACTUALIZA_FACTURA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, W.IdFondo,
                                                                         nIdTransaccionMov, nIdFacturaPN);
                -- Se Registra el Pago
                nIdTransaccionPag := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 12, 'PAGPRD');
                OC_FACTURAS.PAGAR_CON_PRIMA_DEPOSITO(nIdFacturaPN, nIdPrimaDeposito, cNumReciboPago, TRUNC(dFecPago),
                                                     NULL, nIdTransaccionPag);
                BEGIN
                   SELECT MAX(IdRecibo)
                     INTO nIdRecibo
                     FROM PAGOS
                    WHERE CodCia    = nCodCia
                      AND IdFactura = nIdFacturaPN;
                END;
                OC_DETALLE_PRIMAS_DEPOSITO.INSERTAR(nCodCliente, nIdRecibo, nIdPrimaDeposito,
                                                    nIdFacturaPN, nIdPoliza, NVL(nMontoMovMoneda,0), 'PAT');

                OC_PRIMAS_DEPOSITO.APLICAR_FACTURA(nCodCia, nCodEmpresa, nIdPrimaDeposito, TRUNC(dFecPago), nIdRecibo,
                                                   NVL(nMontoPrimaDepMon,0), NVL(nMontoPrimaDepMon,0), NVL(nMontoMovMoneda,0),
                                                   NVL(nMontoMovLocal,0), nIdTransaccionPag);
             ELSIF NVL(nMontoMovMoneda,0) < 0 THEN
                nMontoMovMoneda      := ABS(NVL(nMontoMovMoneda,0));
                nIdTransaccionRetiro := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');
                cCodCptoMov          := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, W.TipoFondo, 'RPP');
                OC_DETALLE_TRANSACCION.CREA(nIdTransaccionRetiro, nCodCia, nCodEmpresa,  21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                            nIdPoliza, nIDetPol, W.IdFondo, cCodCptoMov, NVL(nMontoMovMoneda,0));
                nMontoMovLocal    := NVL(nMontoMovMoneda,0) * nTasaCambioMov;
                GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                     nCodAsegurado, W.IdFondo, cCodCptoMov,
                                                                     nIdTransaccionRetiro, cCodMoneda, nMontoMovMoneda, nMontoMovLocal,
                                                                     'D', nTasaCambioMov, TRUNC(dFecPago), TRUNC(dFecPago),
                                                                     OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, cCodCptoMov));
                GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                              nCodAsegurado, W.IdFondo, nIdTransaccionRetiro);
                GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOV_INFORMATIVOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                   nCodAsegurado, W.IdFondo, nIdTransaccionRetiro);
                OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccionRetiro, 'C');
             END IF;
             GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                           nCodAsegurado, W.IdFondo, nIdTransaccionMov);
             GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOV_INFORMATIVOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                nCodAsegurado, W.IdFondo, nIdTransaccionMov);

             /*-- Se Registra Retiro Parcial para Pago de Factura de Prima
             IF GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                               nCodAsegurado, W.IdFondo,  TRUNC(dFecPago)) > NVL(nSldoFactM,0) THEN
                nIdTransaccionMov := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');
                nMontoMovMoneda   := NVL(nSldoFactM,0);
                cCodCptoMov       := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, W.TipoFondo, 'RP');
                OC_DETALLE_TRANSACCION.CREA(nIdTransaccionMov, nCodCia, nCodEmpresa,  21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                            nIdPoliza, nIDetPol, W.IdFondo, cCodCptoMov, NVL(nMontoMovMoneda,0));
                nMontoMovLocal    := NVL(nMontoMovMoneda,0) * nTasaCambioMov;
                GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                     nCodAsegurado, W.IdFondo, cCodCptoMov,
                                                                     nIdTransaccionMov, cCodMoneda, nMontoMovMoneda, nMontoMovLocal,
                                                                     'D', nTasaCambioMov, TRUNC(dFecPago), TRUNC(dFecPago),
                                                                     OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, cCodCptoMov));
             END IF;*/
          END LOOP;
       END IF;

       -- Si Existe Saldo para Aportes se Crea Factura de Movimientos
       IF NVL(nSaldoPorAplicar,0) > 0 THEN

          IF cFormPago = 'PRD' THEN
             SELECT NVL(MIN(IdPrimaDeposito),0)
               INTO nIdPrimaDeposito
               FROM PRIMAS_DEPOSITO
              WHERE CodCliente    = nCodCliente
                AND IdPoliza      = nIdPolizaAnu
                AND Cod_Moneda    = cCodMoneda
                AND Saldo_Moneda >= NVL(nSaldoPorAplicar,0)
                AND Estado        = 'PAF'; -- Por Aplicar en Fondo

             IF NVL(nIdPrimaDeposito,0) = 0 THEN
                RAISE_APPLICATION_ERROR (-20100,'No Existen Primas en Depósito Con Saldo Mayor o Igual a los Aportes al Fondo en Póliza Anulada No. ' ||
                                         nIdPolizaAnu || ' y No. de Póliza Unico ' || cNumPolUnico);
             END IF;
          END IF;
          -- Generación de Factura por Movimiento de Aportes Iniciales al Fondo
          nIdTransaccionFact := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'FACFON');

          --nMtoComisiMoneda := NVL(nSaldoPorAplicar,0) * nPorcComis / 100;
          --nMtoComisiLocal  := NVL(nSaldoPorAplicar,0) * nTasaCambioMov * nPorcComis / 100;
          nMtoComisiMoneda := 0;
          nMtoComisiLocal  := 0;
          -- LARPLA
          nIdFacturaAportes := OC_FACTURAS.INSERTAR(nIdPoliza,               nIDetPol,                nCodCliente,    TRUNC(dFecPago),
                                                    NVL(nSaldoPorAplicar,0), NVL(nSaldoPorAplicar,0), 0,              NVL(nMtoComisiLocal,0),
                                                    NVL(nMtoComisiMoneda,0), NVL(nNumCuota,1),        nTasaCambioMov, nCod_Agente,
                                                    nCodTipoDoc,             nCodCia,                 cCodMoneda,     NULL,
                                                    nIdTransaccionFact,      cIndFactElectronica);

       END IF;

       -- Fondos para Ahorro o Jubilación NO Exclusivos para Pago de Primas
       cFondoPagoPrimas := 'N';
       nSaldoRestante   := NVL(nSaldoPorAplicar,0);
       FOR W IN FOND_Q LOOP
          nIdFondo   := W.IdFondo;
          cTipoFondo := W.TipoFondo;
          IF NVL(nNumCuota,0) = 1 THEN
             FOR Y IN CONCEN_Q LOOP
                OC_DETALLE_TRANSACCION.CREA(nIdTransaccionMov, nCodCia, nCodEmpresa,  21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                            nIdPoliza, nIDetPol, Y.IdFondo, Y.CodCptoMov, NVL(Y.MontoMovMoneda,0));

                -- Se Aplica el Saldo Proporcional a los Fondos y se Actualiza el Valor de Cada Aporte Inicial
                -- Por si el Asegurado paga más en el primer pago de lo esperado.
                nMontoMovMoneda   := NVL(nSaldoRestante,0) * W.PorcFondo / 100;
                nMontoMovLocal    := NVL(nMontoMovMoneda,0) * nTasaCambioMov;

                UPDATE FAI_CONCENTRADORA_FONDO
                   SET IdTransaccion   = nIdTransaccionMov,
                       MontoMovMoneda  = nMontoMovMoneda,
                       MontoMovLocal   = nMontoMovLocal,
                       FecTasaCambio   = TRUNC(dFecPago),
                       TasaCambioMov   = nTasaCambioMov,
                       FecMovimiento   = TRUNC(dFecPago),
                       FecRealRegistro = TRUNC(dFecPago)
                 WHERE CodCia        = nCodCia
                   AND CodEmpresa    = nCodEmpresa
                   AND IdPoliza      = nIdPoliza
                   AND IDetPol       = nIDetPol
                   AND CodAsegurado  = nCodAsegurado
                   AND IdFondo       = Y.IdFondo
                   AND IdMovimiento  = Y.IdMovimiento;

                OC_DETALLE_FACTURAS.INSERTAR(nIdFacturaAportes, Y.CodCptoMov, 'S', NVL(nMontoMovLocal,0), NVL(nMontoMovMoneda,0));
                OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFacturaAportes, Y.CodCptoMov, 'S', NVL(nMontoMovLocal,0), NVL(nMontoMovMoneda,0));
                GT_FAI_CONCENTRADORA_FONDO.ACTUALIZA_FACTURA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, W.IdFondo,
                                                                         nIdTransaccionMov, nIdFacturaAportes);
             END LOOP;
          ELSE
             nMontoMovMoneda   := NVL(nSaldoRestante,0) * W.PorcFondo / 100;
             nSaldoPorAplicar  := NVL(nSaldoPorAplicar,0) - NVL(nMontoMovMoneda,0);
             IF NVL(nMontoMovMoneda,0) > 0 THEN
                IF cIndTipoAporte = 'R' THEN
                   cCodCptoMov       := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, W.TipoFondo, 'AA');
                ELSIF cIndTipoAporte = 'A' THEN
                   cCodCptoMov       := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, W.TipoFondo, 'AE');
                END IF;

                nMontoMovLocal    := NVL(nMontoMovMoneda,0) * nTasaCambioMov;
                GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                     nCodAsegurado, W.IdFondo, cCodCptoMov,
                                                                     nIdTransaccionMov, cCodMoneda, nMontoMovMoneda, nMontoMovLocal,
                                                                     'D', nTasaCambioMov, TRUNC(dFecPago), TRUNC(dFecPago),
                                                                     OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, cCodCptoMov));
                OC_DETALLE_FACTURAS.INSERTAR(nIdFacturaAportes, cCodCptoMov, 'S', NVL(nMontoMovLocal,0), NVL(nMontoMovMoneda,0));
                OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFacturaAportes, cCodCptoMov, 'S', NVL(nMontoMovLocal,0), NVL(nMontoMovMoneda,0));
                GT_FAI_CONCENTRADORA_FONDO.ACTUALIZA_FACTURA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, W.IdFondo,
                                                                         nIdTransaccionMov, nIdFacturaAportes);
             END IF;
          END IF;
          GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, W.IdFondo,
                                                        nIdTransaccionMov);
          GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOV_INFORMATIVOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                             nCodAsegurado, W.IdFondo, nIdTransaccionMov);
          -- Para Movimientos que NO tienen Transacción
          GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, W.IdFondo,
                                                        0);
          GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOV_INFORMATIVOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                             nCodAsegurado, W.IdFondo, 0);
       END LOOP;

       -- Complementa Factura y su Pago
       IF NVL(nIdFacturaAportes,0) > 0 THEN
          /*OC_FACTURAR.PROC_COMISIONAG (nIdPoliza, nIDetPol, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFacturaAportes,
                                       NVL(nSaldoPorAplicar,0) * nTasaCambioMov, NVL(nSaldoPorAplicar,0), nTasaCambioMov);*/
          OC_FACTURAS.ACTUALIZA_FACTURA(nIdFacturaAportes);
          OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia, nIdFacturaAportes, 'IVASIN');
          OC_DETALLE_TRANSACCION.CREA (nIdTransaccionFact, nCodCia, nCodEmpresa, 21, 'FACFON', 'FACTURAS',
                                       nIdPoliza, nIDetPol, nIdFondo, nIdFacturaAportes, NVL(nSaldoRestante,0));
          -- Se Registra el Pago
          nIdTransaccionPag := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 12, 'PAGPRD');
          OC_FACTURAS.PAGAR_CON_PRIMA_DEPOSITO(nIdFacturaAportes, nIdPrimaDeposito, SUBSTR(cNumReciboPago,1,20), TRUNC(dFecPago),
                                               NULL, nIdTransaccionPag);
          BEGIN
             SELECT MAX(IdRecibo)
               INTO nIdRecibo
               FROM PAGOS
              WHERE CodCia    = nCodCia
                AND IdFactura = nIdFacturaAportes;
          END;
          OC_DETALLE_PRIMAS_DEPOSITO.INSERTAR(nCodCliente, nIdRecibo, nIdPrimaDeposito,
                                              nIdFacturaAportes, nIdPoliza, NVL(nSaldoRestante,0), 'PAT');

          OC_PRIMAS_DEPOSITO.APLICAR_FACTURA(nCodCia, nCodEmpresa, nIdPrimaDeposito, TRUNC(dFecPago), nIdRecibo,
                                             NVL(nSaldoRestante,0), NVL(nSaldoRestante,0) * nTasaCambioMov,
                                             NVL(nSaldoRestante,0), NVL(nSaldoRestante,0) * nTasaCambioMov, nIdTransaccionPag);
       END IF;
       OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccionMov, 'C');

       /*-- Fondos Exclusivos para Pago de Primas
       cFondoPagoPrimas  := 'S';
       nIdTransaccionMov := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');
       FOR W IN FOND_Q LOOP
          nSaldoFondo := GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                        nCodAsegurado, W.IdFondo, TRUNC(dFecPago));
          GT_FAI_CONCENTRADORA_FONDO.CALCULA_INTERES_FONDO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                           nCodAsegurado, W.TipoFondo, W.IdFondo,
                                                           TRUNC(dFecPago), nSaldoFondo, NULL, nMontoInteres);
       END LOOP;
       cFondoPagoPrimas  := 'N';
       FOR W IN FOND_Q LOOP
          nSaldoFondo := GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                        nCodAsegurado, W.IdFondo, TRUNC(dFecPago));
          GT_FAI_CONCENTRADORA_FONDO.CALCULA_INTERES_FONDO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                           nCodAsegurado, W.TipoFondo, W.IdFondo,
                                                           TRUNC(dFecPago), nSaldoFondo, NULL, nMontoInteres);
       END LOOP;*/
       IF cFormPago IN ('CLAB','CTC','DOMI','LIN') AND OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(nCodCia, nIdPoliza, nIDetPol, nCodAsegurado) = 'N' THEN
          IF OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(nCodCia, nCodEmpresa, cIdTipoSeg) = 'S' THEN
             NOTIFICACOBRANZAOK(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdFactura);
    --      ELSE
    --         NOTIFICACOBRANZAOKSTD (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdFactura);
          END IF;
       END IF;
       RETURN(1);
    EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR (-20100,'Error en Proceso de Fondos para Pago de Factura: '||nIdFactura||SQLERRM);
      --  RETURN(0);
    END PAGAR_FONDOS;

    FUNCTION EXISTE_SALDO (nCodCia NUMBER, nIdPoliza NUMBER ) RETURN VARCHAR2 IS
    nTotFact  FACTURAS.Monto_Fact_Local%TYPE;
    cDeuda    VARCHAR2(1);
    BEGIN
       cDeuda := 'S';
       SELECT SUM(Monto_Fact_Local)
         INTO nTotFact
         FROM FACTURAS
        WHERE IdPoliza = nIdPoliza
          AND CodCia   = nCodCia
          AND StsFact IN ('XEM','EMI');

       IF NVL(nTotFact,0) = 0 THEN
          cDeuda := 'N';
       ELSE
         cDeuda := 'S';
       END IF;
       RETURN(cDeuda);
    END EXISTE_SALDO;


    PROCEDURE ARCHIVO_CLIENTES_FACT_ELECT(nCodCia NUMBER, dFecDesde DATE, dFecHasta DATE) IS
    cDescColonia               COLONIA.Descripcion_Colonia%TYPE;
    cDescEstado                PROVINCIA.DescEstado%TYPE;
    cDescCiudad                DISTRITO.DescCiudad%TYPE;
    cTipo_Doc_Identificacion   PERSONA_NATURAL_JURIDICA.Tipo_Doc_Identificacion%TYPE;
    cNum_Doc_Identificacion    PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE;
    cEmailCia                  CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
    cEmailAgteDirec            CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
    cCodCliente                FACTURAS.CodCliente%TYPE;
    cCodPosRes                 PERSONA_NATURAL_JURIDICA.CodPosRes%TYPE;
    cNumExterior               PERSONA_NATURAL_JURIDICA.NumExterior%TYPE;
    cNumInterior               PERSONA_NATURAL_JURIDICA.NumInterior%TYPE;
    cDirecRes                  VARCHAR2(500);
    cCodUser                   VARCHAR2(30)   := USER;
    nLinea                     NUMBER(15)     := 1;
    cCadena                    VARCHAR2(4000);
    cEmailsFactElect           VARCHAR2(255);
    cSeparador                 VARCHAR2(1)    := '|';
    cAsignoEjec                VARCHAR2(1)    := 'N';

    GRABA              BOOLEAN;

    CURSOR CLI_Q IS
       SELECT DISTINCT F.CodCliente,
              P.Nombre || ' ' || P.Apellido_Paterno || ' ' || P.Apellido_Materno NombreCliente,
              REPLACE(REPLACE(P.DirecRes,CHR(13),' '),CHR(10),' ') DirecRes, P.CodPaisRes, P.CodProvRes,
              P.CodDistRes, P.CodCorrRes, P.CodPosRes, P.CodColRes, P.TelRes, P.Email,
              P.NumInterior, P.NumExterior, P.Tipo_Doc_Identificacion, P.Num_Doc_Identificacion,
              DECODE(P.Tipo_Doc_Identificacion,'RFC',P.Num_Doc_Identificacion,P.Num_Tributario) Num_Tributario,
              PO.CodCliente CodClientePol, 0 IdDirecAviCob, NULL NombreFilial
         FROM FACTURAS F, POLIZAS PO, CLIENTES C, PERSONA_NATURAL_JURIDICA P
        WHERE P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
          AND P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
          AND C.CodCliente         = F.CodCliente
          AND PO.IndFacturaPol     = 'S'
          AND PO.CodCia            = F.CodCia
          AND PO.IdPoliza          = F.IdPoliza
          AND F.CodCia             = nCodCia
          AND ((F.StsFact          = 'PAG'
          AND F.FecPago           >= dFecDesde
          AND F.FecPago           <= dFecHasta)
           OR (F.StsFact           = 'EMI'
          AND F.FecVenc           >= dFecDesde
          AND F.FecVenc           <= dFecHasta))
          AND F.IndFactElectronica = 'S'
          AND F.CodUsuarioEnvFact  = 'XENVIAR'
          AND F.FecEnvFactElec    IS NULL
        UNION
       SELECT DISTINCT TO_NUMBER('99999' || LPAD(TO_CHAR(D.Cod_Asegurado),9,'0')) CodCliente,
              P.Nombre || ' ' || P.Apellido_Paterno || ' ' || P.Apellido_Materno NombreCliente,
              REPLACE(P.DirecRes,CHR(13),' ') DirecRes, P.CodPaisRes, P.CodProvRes, P.CodDistRes,
              P.CodCorrRes, P.CodPosRes, P.CodColRes, P.TelRes, P.Email, P.NumInterior, P.NumExterior,
              P.Tipo_Doc_Identificacion, P.Num_Doc_Identificacion,
              DECODE(P.Tipo_Doc_Identificacion,'RFC',P.Num_Doc_Identificacion,P.Num_Tributario) Num_Tributario,
              PO.CodCliente CodClientePol, NVL(D.IdDirecAviCob,0) IdDirecAviCob,
              OC_FILIALES.NOMBRE_ADICIONAL(D.CodCia, PO.CodGrupoEc, D.CodFilial) NombreFilial
         FROM FACTURAS F, POLIZAS PO, DETALLE_POLIZA D, ASEGURADO A, PERSONA_NATURAL_JURIDICA P
        WHERE P.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
          AND P.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
          AND A.Cod_Asegurado      = D.Cod_Asegurado
          AND D.CodCia             = F.CodCia
          AND D.IdPoliza           = F.IdPoliza
          AND D.IDetPol            = F.IDetPol
          AND PO.IndFacturaPol     = 'N'
          AND PO.CodCia            = F.CodCia
          AND PO.IdPoliza          = F.IdPoliza
          AND F.CodCia             = nCodCia
          AND ((F.StsFact          = 'PAG'
          AND F.FecPago           >= dFecDesde
          AND F.FecPago           <= dFecHasta)
           OR (F.StsFact           = 'EMI'
          AND F.FecVenc           >= dFecDesde
          AND F.FecVenc           <= dFecHasta))
          AND F.IndFactElectronica = 'S'
          AND F.CodUsuarioEnvFact  = 'XENVIAR'
          AND F.FecEnvFactElec    IS NULL;
    CURSOR AGT_Q IS
       SELECT DISTINCT CO.Cod_Agente, A.Tipo_Doc_Identificacion,
              A.Num_Doc_Identificacion, A.CodTipo, A.CodNivel, NVL(A.idcuentacorreo,0) CtaMail --AEVS 14062017
         FROM FACTURAS F, COMISIONES CO, AGENTES A
        WHERE A.Cod_Agente         = CO.Cod_Agente
          AND CO.IdFactura         = F.IdFactura
          AND F.CodCliente         = cCodCliente
          AND F.CodCia             = nCodCia
          AND ((F.StsFact          = 'PAG'
          AND F.FecPago           >= dFecDesde
          AND F.FecPago           <= dFecHasta)
           OR (F.StsFact           = 'EMI'
          AND F.FecVenc           >= dFecDesde
          AND F.FecVenc           <= dFecHasta))
          AND F.IndFactElectronica = 'S'
          AND F.CodUsuarioEnvFact  = 'XENVIAR'
          AND F.FecEnvFactElec    IS NULL
        ORDER BY A.CodNivel;
    BEGIN
    /*  --
      GRABA := TRUE;
      --

    IF GRABA THEN GRABA_TIEMPO(4,1,'Inicio del debug',1,USER);  END IF;
    */
       cTipo_Doc_Identificacion  := OC_EMPRESAS.TIPO_IDENTIFICACION_TRIBUTARIA(nCodCia);
       cNum_Doc_Identificacion   := OC_EMPRESAS.IDENTIFICACION_TRIBUTARIA(nCodCia);
       cEmailCia                 := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(cTipo_Doc_Identificacion, cNum_Doc_Identificacion);

       FOR X IN CLI_Q LOOP
          IF X.Email IS NOT NULL THEN
             cEmailsFactElect := X.Email || '; ' || cEmailCia;
          ELSE
             cEmailsFactElect := cEmailCia;
          END IF;

          cCodCliente := X.CodClientePol;
          cAsignoEjec := 'N';
          FOR W IN AGT_Q LOOP
             IF OC_AGENTES.EJECUTIVO_COMERCIAL(nCodCia, W.Cod_Agente) != 0 AND cAsignoEjec = 'N' THEN
                cEmailAgteDirec := OC_EJECUTIVO_COMERCIAL.EMAIL_EJECUTIVO(nCodCia, OC_AGENTES.EJECUTIVO_COMERCIAL(nCodCia, W.Cod_Agente));
                cAsignoEjec     := 'S';
             ELSE
                IF W.CtaMail <> 0 THEN
                   cEmailAgteDirec := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_ESPECIFICO(W.Tipo_Doc_Identificacion, W.Num_Doc_Identificacion, W.CtaMail);
                ELSE
                   cEmailAgteDirec := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(W.Tipo_Doc_Identificacion, W.Num_Doc_Identificacion);
                END IF;

                  /*IF W.CodTipo LIKE 'AGTE%' THEN
                       cEmailAgteDirec := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(W.Tipo_Doc_Identificacion, W.Num_Doc_Identificacion);
                    ELSIF W.CodTipo LIKE 'DIRE%' THEN
                       cEmailAgteDirec := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(W.Tipo_Doc_Identificacion, W.Num_Doc_Identificacion);
                    ELSE
                       cEmailAgteDirec := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(W.Tipo_Doc_Identificacion, W.Num_Doc_Identificacion);
                    END IF;*/
             END IF;
             IF cEmailAgteDirec IS NOT NULL THEN
                IF LENGTH(cEmailsFactElect) + LENGTH(cEmailAgteDirec) <= 255 THEN
                   cEmailsFactElect := cEmailsFactElect || '; ' || cEmailAgteDirec;
                END IF;
             END IF;
          END LOOP;
          IF X.IdDirecAviCob = 0 THEN
             cDescColonia := OC_COLONIA.DESCRIPCION_COLONIA(X.CodPaisRes, X.CodProvRes, X.CodDistRes, X.CodCorrRes,
                                                            X.CodPosRes, X.CodColRes);
             cDescEstado  := OC_PROVINCIA.NOMBRE_PROVINCIA(X.CodPaisRes, X.CodProvRes);
             cDescCiudad  := OC_DISTRITO.NOMBRE_DISTRITO(X.CodPaisRes, X.CodProvRes, X.CodDistRes);
             cDirecRes    := X.DirecRes;
             cCodPosRes   := X.CodPosRes;
             cNumExterior := X.NumExterior;
             cNumInterior := X.NumInterior;
          ELSE
             cTipo_Doc_Identificacion  := X.Tipo_Doc_Identificacion;
             cNum_Doc_Identificacion   := X.Num_Doc_Identificacion;
             BEGIN
                SELECT REPLACE(REPLACE(Direccion,CHR(13),' '),CHR(10),' ') DirecRes,
                       NumExterior, NumInterior, Codigo_Postal,
                       OC_COLONIA.DESCRIPCION_COLONIA(CodPais, CodEstado, CodCiudad, CodMunicipio, Codigo_Postal, CodAsentamiento) Colonia,
                       OC_PROVINCIA.NOMBRE_PROVINCIA(CodPais, CodEstado) Estado,
                       OC_DISTRITO.NOMBRE_DISTRITO(CodPais, CodEstado, CodCiudad) Ciudad
                  INTO cDirecRes, cNumExterior, cNumInterior, cCodPosRes,
                       cDescColonia, cDescEstado, cDescCiudad
                  FROM DIRECCIONES_PNJ D
                 WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
                   AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
                   AND Correlativo_Direccion   = X.IdDirecAviCob;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   cDirecRes     := NULL;
                   cNumExterior  := NULL;
                   cNumInterior  := NULL;
                   cCodPosRes    := NULL;
                   cDescColonia  := NULL;
                   cDescEstado   := NULL;
                   cDescCiudad   := NULL;
             END;
          END IF;

          IF cDescColonia = 'COLONIA NO EXISTE' THEN
             cDescColonia := NULL;
          END IF;

          cCadena := TRIM(TO_CHAR(X.CodCliente,'00000000000000')) || cSeparador ||
                     X.NombreCliente || ' ' || X.NombreFilial     || cSeparador ||
                     ' '                                          || cSeparador ||
                     cDirecRes                                    || cSeparador ||
                     cDescColonia                                 || cSeparador ||
                     cDescCiudad                                  || cSeparador ||
                     cDescEstado                                  || cSeparador ||
                     cCodPosRes                                   || cSeparador ||
                     X.TelRes                                     || cSeparador ||
                     X.Num_Tributario                             || cSeparador ||
                     cNumExterior                                 || cSeparador ||
                     cNumInterior                                 || cSeparador ||
                     cEmailsFactElect                             || cSeparador || CHR(13);
          OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
          nLinea  := NVL(nLinea,0) + 1;
       END LOOP;
    EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20100,'Error al generar archivo de clientes: ' || SQLERRM);
    END ARCHIVO_CLIENTES_FACT_ELECT;

    PROCEDURE ARCHIVO_FACTURAS_FACT_ELECT(nCodCia NUMBER, dFecDesde DATE, dFecHasta DATE, nIdFactura NUMBER, nLinea IN OUT NUMBER) IS
    cNum_TributarioCia     EMPRESAS.Num_Tributario%TYPE;
    cNum_TributarioCli     PERSONA_NATURAL_JURIDICA.Num_Tributario%TYPE;
    cNumPolUnico           POLIZAS.NumPolUnico%TYPE;
    nMtoIVA                DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
    nMtoNetoFactura        FACTURAS.Monto_Fact_Moneda%TYPE;
    nPrimaNeta             DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
    nRecargos              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
    nDerechos              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
    nImpuesto              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
    nTasaIVA               CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
    nCodEmpresa            POLIZAS.CodEmpresa%TYPE;
    cCodPlanPagos          PLAN_DE_PAGOS.CodPlanPago%TYPE;
    cIndFacturaPol         POLIZAS.IndFacturaPol%TYPE;
    nCod_Asegurado         DETALLE_POLIZA.Cod_Asegurado%TYPE;
    nCodigoCliente         POLIZAS.CodCliente%TYPE;
    cTipoEndoso            ENDOSOS.TipoEndoso%TYPE;
    cSucursal              VARCHAR2(3)    := '000';
    cTipoDocumento         VARCHAR2(30)   := 'Ingreso';
    --cFormaPago             VARCHAR2(255)  := 'NO IDENTIFICADO';
    cDescFrecPago          VARCHAR2(20);
    cCondPago              VARCHAR2(10)   := 'CONTADO';
    nCantArticulos         NUMBER(18,6)   := 1;
    cSeparador             VARCHAR2(1)    := '|';
    cMoneda                VARCHAR2(5);
    cDescripcion           VARCHAR2(255);
    cCadena                VARCHAR2(4000);
    cCodUser               VARCHAR2(30)   := USER;
    nTotFacturas           NUMBER(15);

    --nLinea                 NUMBER(15)     := 1;

    CURSOR FACT_Q IS
     SELECT IdFactura, NumFact, CodCliente, IdPoliza, IDetPol, IdEndoso,
              Cod_Moneda, Tasa_Cambio, Monto_Fact_Moneda, Monto_Fact_Local,
              IdTransaccion, NumCuota, CASE FormPago                                          --  INI 13/07/2016  Se agrega el CASE             MAGO
                                            WHEN 'DOMI' THEN '04'                             --  para asignar el codigo de la forma de pago    MAGO
                                            WHEN 'LIN'  THEN '04'
                                            WHEN 'DXN'  THEN '04'
                                            WHEN 'CTC'  THEN '04'
                                            ELSE 'NA'
                                       END FormaPago                                          --  FIN                                           MAGO
         FROM FACTURAS
        WHERE CodCia             = nCodCia
          AND IdFactura          = nIdFactura -- Se Agrega para MANDar solo Facturas Seleccionadas por el usuario
          AND IndFactElectronica = 'S'
          AND FecEnvFactElec    IS NULL
        ORDER BY IdFactura;
    CURSOR DET_Q IS
       SELECT D.CodCpto, D.Monto_Det_Moneda, D.IndCptoPrima, C.IndCptoServicio
         FROM DETALLE_FACTURAS D, FACTURAS F, CATALOGO_DE_CONCEPTOS C
        WHERE C.CodConcepto = D.CodCpto
          AND C.CodCia      = F.CodCia
          AND D.IdFactura   = F.IdFactura
          AND F.IdFactura   = nIdFactura;
    BEGIN
       cNum_TributarioCia := OC_EMPRESAS.IDENTIFICACION_TRIBUTARIA(nCodCia);

       FOR W IN FACT_Q LOOP
          cDescFrecPago      := OC_FACTURAS.FRECUENCIA_PAGO(nCodCia, W.IdFactura);
          cMoneda            := OC_MONEDA.CODIGO_SISTEMA_CONTABLE(W.Cod_Moneda);
          cCodPlanPagos      := OC_FACTURAS.CODIGO_PLAN_PAGOS(nCodCia, W.IdFactura);

          IF W.IdEndoso = 0 THEN
    /*         SELECT COUNT(*)
               INTO nTotFacturas
               FROM FACTURAS
              WHERE IdTransaccion = W.IdTransaccion
                AND CodCia        = nCodCia
                AND IdPoliza      = W.IdPoliza
                AND IDetPol       = W.IDetPol
                AND IdEndoso      = W.IdEndoso;
    */
             SELECT numpagos
               INTO nTotFacturas
               FROM PLAN_DE_PAGOS
              WHERE CodPlanPago = cCodPlanPagos;
          ELSE
             SELECT TipoEndoso
               INTO cTipoEndoso
               FROM ENDOSOS
              WHERE IdPoliza      = W.IdPoliza
                AND CodCia        = nCodCia
                AND IDetPol       = W.IDetPol
                AND IdEndoso      = W.IdEndoso;

             IF cTipoEndoso != 'EAD' THEN
    /*            SELECT COUNT(*)
                  INTO nTotFacturas
                  FROM FACTURAS
                 WHERE IdTransaccion = W.IdTransaccion
                   AND CodCia        = nCodCia
                   AND IdPoliza      = W.IdPoliza
                   AND IDetPol       = W.IDetPol
                   AND IdEndoso      = W.IdEndoso;
    */
                SELECT numpagos
                  INTO nTotFacturas
                  FROM PLAN_DE_PAGOS
                 WHERE CodPlanPago = (SELECT CodPlanPago
                                        FROM ENDOSOS
                                       WHERE IdPoliza    = W.IdPoliza
                                         AND IdEndoso    = W.IdEndoso);
             ELSE -- Endoso a Declaración
                SELECT COUNT(*)
                  INTO nTotFacturas
                  FROM FACTURAS
                 WHERE IdTransaccion IN (SELECT MIN(IdTransaccion)
                                           FROM FACTURAS
                                          WHERE CodCia         = nCodCia
                                            AND IdPoliza       = W.IdPoliza
                                            AND IDetPol        = W.IDetPol
                                            AND NumCuota       = W.NumCuota
                                            AND IdEndoso       = 0)
                   AND CodCia         = nCodCia
                   AND IdPoliza       = W.IdPoliza
                   AND IDetPol        = W.IDetPol;
             END IF;
          END IF;
          BEGIN
             SELECT P.NumPolUnico, P.CodEmpresa, P.IndFacturaPol, D.Cod_Asegurado
               INTO cNumPolUnico, nCodEmpresa, cIndFacturaPol, nCod_Asegurado
               FROM POLIZAS P, DETALLE_POLIZA D
              WHERE D.CodCia    = P.CodCia
                AND D.IdPoliza  = W.IdPoliza
                AND D.IdetPol   = W.IDetPol
                AND P.CodCia    = nCodCia
                AND P.IdPoliza  = W.IdPoliza;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR (-20100,'NO Existe Póliza No. Consecutivo '|| W.IdPoliza || ' ' || SQLERRM);
          END;

          IF cIndFacturaPol = 'S' THEN
             cNum_TributarioCli := OC_CLIENTES.IDENTIFICACION_TRIBUTARIA(W.CodCliente);
             nCodigoCliente     := W.CodCliente;
          ELSE
             BEGIN
                SELECT DECODE(Tipo_Doc_Identificacion,'RFC',Num_Doc_Identificacion,Num_Tributario)
                  INTO cNum_TributarioCli
                  FROM PERSONA_NATURAL_JURIDICA
                 WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
                       (SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                          FROM ASEGURADO
                         WHERE CodCia        = nCodCia
                           AND CodEmpresa    = nCodEmpresa
                           AND Cod_Asegurado = nCod_Asegurado);
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   RAISE_APPLICATION_ERROR(-20225,'No Existe Asegurado: '||TRIM(TO_CHAR(nCod_Asegurado)) || ' en Persona Natural Juridica');
             END;
             IF cNum_TributarioCli IS NULL THEN
                RAISE_APPLICATION_ERROR(-20225,'Asegurado: '||TRIM(TO_CHAR(nCod_Asegurado)) || ' No Posee Identificación Tributaria');
             END IF;
             nCodigoCliente     := TO_NUMBER('99999' || LPAD(TO_CHAR(nCod_Asegurado),9,'0'));
          END IF;
          nPrimaNeta      := 0;
          nRecargos       := 0;
          nDerechos       := 0;
          nImpuesto       := 0;

          FOR W IN DET_Q LOOP
             IF W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S' THEN
                nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(W.Monto_Det_Moneda,0);
             ELSIF W.CodCpto = 'RECFIN' THEN
                nRecargos   := NVL(nRecargos,0) + NVL(W.Monto_Det_Moneda,0);
             ELSIF W.CodCpto = 'DEREMI' THEN
                nDerechos   := NVL(nDerechos,0) + NVL(W.Monto_Det_Moneda,0);
             ELSIF W.CodCpto = 'IVASIN' THEN
                nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
                nTasaIVA    := OC_CONCEPTOS_PLAN_DE_PAGOS.PORCENTAJE_CONCEPTO(nCodCia, nCodEmpresa, cCodPlanPagos, W.CodCpto);
             ELSE
                nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
             END IF;
          END LOOP;

          -- Prima Neta
          IF W.IdEndoso = 0 THEN
              cDescripcion    := 'PRIMAS DE SEGURO DE LA POLIZA ' || cNumPolUnico || ' RECIBO ' || TRIM(TO_CHAR(nIdFactura,'0000000000')) ||
                                 ' - ' || TRIM(TO_CHAR(W.NumCuota,'990')) || '/' || TRIM(TO_CHAR(nTotFacturas,'990'));
          ELSE
              cDescripcion    := 'PRIMAS DE SEGURO DE LA POLIZA ' || cNumPolUnico || ' RECIBO ' || TRIM(TO_CHAR(nIdFactura,'0000000000')) ||
                                 ' - ' || TRIM(TO_CHAR(W.NumCuota,'990')) || '/' || TRIM(TO_CHAR(nTotFacturas,'990')) || ' - ' || 'DEL ENDOSO ' || TRIM(TO_CHAR(W.IdEndoso,'990'));
          END IF;
          nMtoIVA         := NVL(NVL(nPrimaNeta,0) * nTasaIVA / 100,0);

          cCadena := TRIM(TO_CHAR(W.IdFactura,'00000000000000'))    || cSeparador ||
                     TRIM(cNum_TributarioCia)                       || cSeparador ||
                     cSucursal                                      || cSeparador ||
                     TRIM(cNum_TributarioCli)                       || cSeparador ||
                     TRIM(TO_CHAR(nCodigoCliente,'00000000000000')) || cSeparador ||
                     cTipoDocumento                                 || cSeparador ||
                     W.FormaPago                                    || cSeparador ||
                     cDescFrecPago                                  || cSeparador ||
                     cCondPago                                      || cSeparador ||
                     TRIM(cMoneda)                                  || cSeparador ||
                     TO_CHAR(SYSDATE,'DD/MM/YYYY HH:MI:SS')         || cSeparador ||
                     TO_CHAR(W.Tasa_Cambio,'00000000.0000')         || cSeparador ||
                     TRIM(TO_CHAR(nCantArticulos,'9999999990'))     || cSeparador ||
                     TO_CHAR(nPrimaNeta,'99999999990.00')           || cSeparador ||
                     TO_CHAR(nPrimaNeta,'99999999990.00')           || cSeparador ||
                     cDescripcion                                   || cSeparador ||
                     TO_CHAR(NVL(nMtoIVA,0),'99999999990.00')       || cSeparador ||
                     '0.00'                                         || cSeparador || -- Descuento
                     'NO APLICA'                                    || cSeparador || -- Unidad de Medida
                     '1'                                            || cSeparador || CHR(13);   -- No. de Artículo
          OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
          nLinea  := NVL(nLinea,0) + 1;

          -- Recargo por Pago Fraccionado
          cDescripcion    := 'FINANCIAMIENTO POR PAGO FRACCIONADO';
          nMtoIVA         := NVL(NVL(nRecargos,0) * nTasaIVA / 100,0);

          cCadena := TRIM(TO_CHAR(W.IdFactura,'00000000000000'))    || cSeparador ||
                     TRIM(cNum_TributarioCia)                       || cSeparador ||
                     cSucursal                                      || cSeparador ||
                     TRIM(cNum_TributarioCli)                       || cSeparador ||
                     TRIM(TO_CHAR(nCodigoCliente,'00000000000000')) || cSeparador ||
                     cTipoDocumento                                 || cSeparador ||
                     W.FormaPago                                    || cSeparador ||
                     cDescFrecPago                                  || cSeparador ||
                     cCondPago                                      || cSeparador ||
                     TRIM(cMoneda)                                  || cSeparador ||
                     TO_CHAR(SYSDATE,'DD/MM/YYYY HH:MI:SS')         || cSeparador ||
                     TO_CHAR(W.Tasa_Cambio,'00000000.0000')         || cSeparador ||
                     TRIM(TO_CHAR(nCantArticulos,'9999999990'))     || cSeparador ||
                     TO_CHAR(nRecargos,'99999999990.00')            || cSeparador ||
                     TO_CHAR(nRecargos,'99999999990.00')            || cSeparador ||
                     cDescripcion                                   || cSeparador ||
                     TO_CHAR(NVL(nMtoIVA,0),'99999999990.00')       || cSeparador ||
                     '0.00'                                         || cSeparador || -- Descuento
                     'NO APLICA'                                    || cSeparador || -- Unidad de Medida
                     '1'                                            || cSeparador || CHR(13);   -- No. de Artículo
          OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
          nLinea  := NVL(nLinea,0) + 1;

          -- Derechos de Póliza o Gastos de Expedición
          cDescripcion    := 'GASTOS DE EXPEDICION';
          nMtoIVA         := NVL(NVL(nDerechos,0) * nTasaIVA / 100,0);

          cCadena := TRIM(TO_CHAR(W.IdFactura,'00000000000000'))    || cSeparador ||
                     TRIM(cNum_TributarioCia)                       || cSeparador ||
                     cSucursal                                      || cSeparador ||
                     TRIM(cNum_TributarioCli)                       || cSeparador ||
                     TRIM(TO_CHAR(nCodigoCliente,'00000000000000')) || cSeparador ||
                     cTipoDocumento                                 || cSeparador ||
                     W.FormaPago                                    || cSeparador ||
                     cDescFrecPago                                  || cSeparador ||
                     cCondPago                                      || cSeparador ||
                     TRIM(cMoneda)                                  || cSeparador ||
                     TO_CHAR(SYSDATE,'DD/MM/YYYY HH:MI:SS')         || cSeparador ||
                     TO_CHAR(W.Tasa_Cambio,'00000000.0000')         || cSeparador ||
                     TRIM(TO_CHAR(nCantArticulos,'9999999990'))     || cSeparador ||
                     TO_CHAR(nDerechos,'99999999990.00')            || cSeparador ||
                     TO_CHAR(nDerechos,'99999999990.00')            || cSeparador ||
                     cDescripcion                                   || cSeparador ||
                     TO_CHAR(NVL(nMtoIVA,0),'99999999990.00')       || cSeparador ||
                     '0.00'                                         || cSeparador || -- Descuento
                     'NO APLICA'                                    || cSeparador || -- Unidad de Medida
                     '1'                                            || cSeparador || CHR(13);   -- No. de Artículo
          OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
          nLinea  := NVL(nLinea,0) + 1;
       END LOOP;
       UPDATE FACTURAS
          SET FecEnvFactElec     = SYSDATE,
              CodUsuarioEnvFact  = USER
        WHERE CodCia             = nCodCia
          AND IdFactura          = nIdFactura -- Se Agrega para MANDar solo Facturas Seleccionadas por el usuario
          AND IndFactElectronica = 'S'
          AND FecEnvFactElec    IS NULL;
    EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20100,SQLERRM);
    END ARCHIVO_FACTURAS_FACT_ELECT;

    PROCEDURE ARCHIVO_FACT_ELECT_ANUL(nCodCia NUMBER, nIdFactura NUMBER, nLinea IN OUT NUMBER) IS
    cNum_TributarioCia     EMPRESAS.Num_Tributario%TYPE;
    cNum_TributarioCli     PERSONA_NATURAL_JURIDICA.Num_Tributario%TYPE;
    cNumPolUnico           POLIZAS.NumPolUnico%TYPE;
    nMtoIVA                DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
    nMtoNetoFactura        FACTURAS.Monto_Fact_Moneda%TYPE;
    nPrimaNeta             DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
    nRecargos              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
    nDerechos              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
    nImpuesto              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
    nTasaIVA               CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
    nCodEmpresa            POLIZAS.CodEmpresa%TYPE;
    cCodPlanPagos          PLAN_DE_PAGOS.CodPlanPago%TYPE;
    cIndFacturaPol         POLIZAS.IndFacturaPol%TYPE;
    nCod_Asegurado         DETALLE_POLIZA.Cod_Asegurado%TYPE;
    nCodigoCliente         POLIZAS.CodCliente%TYPE;
    cSucursal              VARCHAR2(3)    := '000';
    cTipoDocumento         VARCHAR2(30)   := 'Ingreso';
    --cFormaPago             VARCHAR2(255)  := 'NO IDENTIFICADO';
    cDescFrecPago          VARCHAR2(20);
    cCondPago              VARCHAR2(10)   := 'CONTADO';
    nCantArticulos         NUMBER(18,6)   := 1;
    cSeparador             VARCHAR2(1)    := '|';
    cMoneda                VARCHAR2(5);
    cDescripcion           VARCHAR2(255);
    cCadena                VARCHAR2(4000);
    cCodUser               VARCHAR2(30)   := USER;
    nTotFacturas           NUMBER(15);

    CURSOR FACT_Q IS
       SELECT IdFactura, NumFact, CodCliente, IdPoliza, IDetPol, IdEndoso,
              Cod_Moneda, Tasa_Cambio, Monto_Fact_Moneda, Monto_Fact_Local,
              IdTransaccion, NumCuota, FolioFactElec
         FROM FACTURAS
        WHERE CodCia               = nCodCia
          AND IdFactura            = nIdFactura -- Se Agrega para MANDar solo Facturas Seleccionadas por el usuario
          AND IndFactElectronica   = 'S'
          AND FolioFactElec       IS NOT NULL
          AND CodUsuarioEnvFactAnu = 'XENVIAR'
          AND FecEnvFactElecAnu   IS NULL
        ORDER BY IdFactura;
    BEGIN
       cNum_TributarioCia := OC_EMPRESAS.IDENTIFICACION_TRIBUTARIA(nCodCia);

       FOR W IN FACT_Q LOOP
          BEGIN
             SELECT P.NumPolUnico, P.CodEmpresa, P.IndFacturaPol, D.Cod_Asegurado
               INTO cNumPolUnico, nCodEmpresa, cIndFacturaPol, nCod_Asegurado
               FROM POLIZAS P, DETALLE_POLIZA D
              WHERE D.CodCia    = P.CodCia
                AND D.IdPoliza  = W.IdPoliza
                AND D.IdetPol   = W.IDetPol
                AND P.CodCia    = nCodCia
                AND P.IdPoliza  = W.IdPoliza;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR (-20100,'NO Existe Póliza No. Consecutivo '|| W.IdPoliza || ' ' || SQLERRM);
          END;

          IF cIndFacturaPol = 'S' THEN
             cNum_TributarioCli := OC_CLIENTES.IDENTIFICACION_TRIBUTARIA(W.CodCliente);
             nCodigoCliente     := W.CodCliente;
          ELSE
             BEGIN
                SELECT DECODE(Tipo_Doc_Identificacion,'RFC',Num_Doc_Identificacion,Num_Tributario)
                  INTO cNum_TributarioCli
                  FROM PERSONA_NATURAL_JURIDICA
                 WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
                       (SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                          FROM ASEGURADO
                         WHERE CodCia        = nCodCia
                           AND CodEmpresa    = nCodEmpresa
                           AND Cod_Asegurado = nCod_Asegurado);
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   RAISE_APPLICATION_ERROR(-20225,'No Existe Asegurado: '||TRIM(TO_CHAR(nCod_Asegurado)) || ' en Persona Natural Juridica');
             END;
             IF cNum_TributarioCli IS NULL THEN
                RAISE_APPLICATION_ERROR(-20225,'Asegurado: '||TRIM(TO_CHAR(nCod_Asegurado)) || ' No Posee Identificación Tributaria');
             END IF;
             nCodigoCliente     := TO_NUMBER('99999' || LPAD(TO_CHAR(nCod_Asegurado),9,'0'));
          END IF;

          cCadena := TRIM(cNum_TributarioCia)                       || cSeparador ||
                     TRIM(cNum_TributarioCli)                       || cSeparador ||
                     TRIM(W.FolioFactElec)                          || cSeparador || CHR(13);
          OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
          nLinea  := NVL(nLinea,0) + 1;
       END LOOP;
       UPDATE FACTURAS
          SET FecEnvFactElecAnu     = SYSDATE,
              CodUsuarioEnvFactAnu  = USER
        WHERE CodCia                = nCodCia
          AND IdFactura             = nIdFactura
          AND IndFactElectronica    = 'S'
          AND FolioFactElec        IS NOT NULL
          AND FecEnvFactElecAnu    IS NULL;
    EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20100,SQLERRM);
    END ARCHIVO_FACT_ELECT_ANUL;

    FUNCTION FRECUENCIA_PAGO(nCodCia NUMBER, nIdFactura NUMBER) RETURN VARCHAR2 IS
    nIdPoliza      FACTURAS.IdPoliza%TYPE;
    nIDetPol       FACTURAS.IDetPol%TYPE;
    nIdEndoso      FACTURAS.IdEndoso%TYPE;
    cCodPlanPago   PLAN_DE_PAGOS.CodPlanPago%TYPE;
    nCodEmpresa    POLIZAS.CodEmpresa%TYPE;
    cDescFrecPago  VARCHAR2(20);
    nFrecPagos     PLAN_DE_PAGOS.FrecPagos%TYPE;
    BEGIN
       SELECT IdPoliza, IDetPol, IdEndoso
         INTO nIdPoliza, nIDetPol, nIdEndoso
         FROM FACTURAS
        WHERE CodCia    = nCodCia
          AND IdFactura = nIdFactura;

       IF NVL(nIdEndoso,0) != 0 THEN
          BEGIN
             SELECT CodPlanPago, CodEmpresa
               INTO cCodPlanPago, nCodEmpresa
               FROM ENDOSOS
              WHERE CodCia     = nCodCia
                AND IdPoliza   = nIdPoliza
                AND IDetPol    = nIDetPol
                AND IdEndoso   = nIdEndoso;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                cCodPlanPago := NULL;
             WHEN TOO_MANY_ROWS THEN
                cCodPlanPago := NULL;
          END;
        ELSE
          BEGIN
             SELECT CodPlanPago, CodEmpresa
               INTO cCodPlanPago, nCodEmpresa
               FROM DETALLE_POLIZA
              WHERE CodCia     = nCodCia
                AND IdPoliza   = nIdPoliza
                AND IDetPol    = nIDetPol;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                cCodPlanPago := NULL;
             WHEN TOO_MANY_ROWS THEN
                cCodPlanPago := NULL;
          END;
          IF cCodPlanPago IS NULL THEN
             BEGIN
                SELECT CodPlanPago, CodEmpresa
                  INTO cCodPlanPago, nCodEmpresa
                  FROM POLIZAS
                 WHERE CodCia     = nCodCia
                   AND IdPoliza   = nIdPoliza;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   cCodPlanPago := NULL;
                WHEN TOO_MANY_ROWS THEN
                   cCodPlanPago := NULL;
             END;
          END IF;
       END IF;
       IF cCodPlanPago IS NULL THEN
          cDescFrecPago   := 'CONTADO';
       ELSE
          BEGIN
             SELECT FrecPagos
               INTO nFrecPagos
               FROM PLAN_DE_PAGOS
              WHERE CodCia      = nCodCia
                AND CodEmpresa  = nCodEmpresa
                AND CodPlanPago = cCodPlanPago;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                nFrecPagos := 12;
             WHEN TOO_MANY_ROWS THEN
                nFrecPagos := 12;
          END;
         IF    nFrecPagos = 99 THEN
             cDescFrecPago := 'CONTADO';
          ELSIF nFrecPagos = 12 THEN
             cDescFrecPago := 'CONTADO';
          ELSIF nFrecPagos = 2 THEN
             cDescFrecPago := 'BIMENSUAL';
          ELSIF nFrecPagos = 3 THEN
             cDescFrecPago := 'TRIMESTRAL';
          ELSIF nFrecPagos = 6 THEN
             cDescFrecPago := 'SEMESTRAL';
          ELSIF nFrecPagos = 1 THEN
             cDescFrecPago := 'MENSUAL';
          ELSIF nFrecPagos = 15 THEN       -- FREPAG
             cDescFrecPago := 'QUINCENAL'; -- FREPAG
          ELSIF nFrecPagos = 7 THEN        -- FREPAG
             cDescFrecPago := 'SEMANAL';   -- FREPAG
          END IF;
       END IF;
       RETURN(cDescFrecPago);
    END FRECUENCIA_PAGO;

    FUNCTION CODIGO_PLAN_PAGOS(nCodCia NUMBER, nIdFactura NUMBER) RETURN VARCHAR2 IS
    nIdPoliza      FACTURAS.IdPoliza%TYPE;
    nIDetPol       FACTURAS.IDetPol%TYPE;
    nIdEndoso      FACTURAS.IdEndoso%TYPE;
    cCodPlanPago   PLAN_DE_PAGOS.CodPlanPago%TYPE;
    BEGIN
       SELECT IdPoliza, IDetPol, IdEndoso
         INTO nIdPoliza, nIDetPol, nIdEndoso
         FROM FACTURAS
        WHERE CodCia    = nCodCia
          AND IdFactura = nIdFactura;

       IF NVL(nIdEndoso,0) != 0 THEN
          BEGIN
             SELECT CodPlanPago
               INTO cCodPlanPago
               FROM ENDOSOS
              WHERE CodCia     = nCodCia
                AND IdPoliza   = nIdPoliza
                AND IDetPol    = nIDetPol
                AND IdEndoso   = nIdEndoso;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                cCodPlanPago := NULL;
             WHEN TOO_MANY_ROWS THEN
                cCodPlanPago := NULL;
          END;
        ELSE
          BEGIN
             SELECT CodPlanPago
               INTO cCodPlanPago
               FROM DETALLE_POLIZA
              WHERE CodCia     = nCodCia
                AND IdPoliza   = nIdPoliza
                AND IDetPol    = nIDetPol;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                cCodPlanPago := NULL;
             WHEN TOO_MANY_ROWS THEN
                cCodPlanPago := NULL;
          END;
          IF cCodPlanPago IS NULL THEN
             BEGIN
                SELECT CodPlanPago
                  INTO cCodPlanPago
                  FROM POLIZAS
                 WHERE CodCia     = nCodCia
                   AND IdPoliza   = nIdPoliza;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   cCodPlanPago := NULL;
                WHEN TOO_MANY_ROWS THEN
                   cCodPlanPago := NULL;
             END;
          END IF;
       END IF;
       RETURN(cCodPlanPago);
    END CODIGO_PLAN_PAGOS;

    PROCEDURE ACTUALIZA_CONTABILIZACION(nCodCia NUMBER, nIdTransaccion NUMBER)IS
    CURSOR FACT_Q IS
       SELECT F.IdFactura, TRUNC(T.FechaTransaccion) FechaTransaccion
         FROM TRANSACCION T, FACTURAS F, DETALLE_TRANSACCION D, DETALLE_POLIZA DP
        WHERE DP.IdPoliza        = F.IdPoliza
          AND DP.IDetPol         = NVL(F.IDetPol,DP.IDetPol)
          AND DP.CodCia          = D.CodCia
          AND ((F.FecVenc       <= TRUNC(FechaTransaccion)
          AND OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'DEVENG')
           OR OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'ANTICI')
          AND T.IdTransaccion    = F.IdTransaccion
          AND (F.IdTransaccion   = D.IdTransaccion
           OR F.IdTransaccionAnu = D.IdTransaccion
           OR F.IdTransacContab  = D.IdTransaccion)
          AND D.Correlativo      = 1
          AND D.IdTransaccion    = nIdTransaccion
          AND D.CodCia           = nCodCia;
    BEGIN
       FOR W IN FACT_Q LOOP
          UPDATE FACTURAS
             SET IndContabilizada = 'S',
                 FecContabilizada = W.FechaTransaccion
           WHERE IdFactura = W.IdFactura;
       END LOOP;
    END ACTUALIZA_CONTABILIZACION;

    PROCEDURE CONTABILIZAR_FACTURAS(nCodCia NUMBER, dFecContabilizar DATE) IS
    nIdTransaccion   TRANSACCION.IdTransaccion%TYPE;

    CURSOR FACT_Q IS
       SELECT F.IdFactura, F.IDetPol, F.Monto_Fact_Moneda, DP.CodEmpresa, DP.IdPoliza
         FROM FACTURAS F, DETALLE_POLIZA DP
        WHERE DP.IdPoliza        = F.IdPoliza
          AND DP.IDetPol         = NVL(F.IDetPol,DP.IDetPol)
          AND DP.CodCia          = nCodCia
          AND F.IndContabilizada = 'N'
          AND F.FecVenc         <= dFecContabilizar
          AND F.StsFact          = 'EMI'
          AND OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, DP.CodEmpresa, DP.IdTipoSeg) = 'DEVENG';
    BEGIN
       FOR W IN FACT_Q LOOP
          nIdTransaccion := OC_TRANSACCION.CREA(nCodCia, W.CodEmpresa, 14, 'CONFAC');
          OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, W.CodEmpresa, 14, 'CONFAC',
                                      'FACTURAS', W.IdPoliza, W.IDetPol, NULL, W.IdFactura, W.Monto_Fact_Moneda);
          UPDATE FACTURAS
             SET IdTransacContab  = nIdTransaccion,
                 IndContabilizada = 'S',
                 FecContabilizada = TRUNC(SYSDATE)
           WHERE IdFactura = W.IdFactura;
          OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');
       END LOOP;
    END CONTABILIZAR_FACTURAS;

    PROCEDURE ANULAR(nCodCia NUMBER, nIdFactura NUMBER, dFecAnul DATE, cMotivAnul VARCHAR2,
                     nCodCobrador NUMBER, nIdTransaccion NUMBER) IS
    cFolioFactElec         FACTURAS.FolioFactElec%TYPE;
    cIndFactElectronica    FACTURAS.IndFactElectronica%TYPE;
    cCodUsuarioEnvFactAnu  FACTURAS.CodUsuarioEnvFactAnu%TYPE;
    BEGIN
       BEGIN
          SELECT IndFactElectronica, FolioFactElec
            INTO cIndFactElectronica, cFolioFactElec
            FROM FACTURAS
           WHERE IdFactura  = nIdFactura
             AND CodCia     = nCodcia;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR(-20100,'No. de Recibo '||TRIM(TO_CHAR(nIdFactura)) || ' NO Existe para Anularlo');
       END;

       IF cIndFactElectronica = 'S' AND cFolioFactElec IS NOT NULL THEN
          cCodUsuarioEnvFactAnu := 'XENVIAR';
       ELSE
          cCodUsuarioEnvFactAnu := NULL;
       END IF;

       UPDATE FACTURAS
          SET StsFact              = 'ANU',
              FecSts               = TRUNC(SYSDATE),
              FecAnul              = dFecAnul,
              MotivAnul            = cMotivAnul,
              IdTransaccionAnu     = nIdTransaccion,
              CodUsuarioEnvFactAnu = cCodUsuarioEnvFactAnu
        WHERE IdFactura  = nIdFactura
          AND CodCia     = nCodCia;

       OC_COMISION_COBRADOR.ANULAR_COMISION(nIdFactura, nCodCobrador );

    END ANULAR;

    PROCEDURE REHABILITACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFacturaAnu NUMBER, nIdTransaccion NUMBER) IS
    nIdFactura    FACTURAS.IdFactura%TYPE;
    fFecFinVig    FACTURAS.FecFinVig%TYPE;      -- ICOFINVIG

    CURSOR FACT_Q IS
       SELECT IdPoliza, IDetPol, CodCliente, FecVenc, Monto_Fact_Local, Monto_Fact_Moneda, IdEndoso,
              MtoComisi_Local, MtoComisi_Moneda, NumCuota, Tasa_Cambio, CodGenerador, CodTipoDoc,
              Cod_Moneda, CodResPago, IndFactElectronica, IndGenAviCob, FecGenAviCob, FecFinVig, CodPlanPago           --ICOFINVIG
         FROM FACTURAS
        WHERE CodCia    = nCodCia
          AND IdFactura = nIdFacturaAnu;
    CURSOR DET_Q IS
       SELECT CodCpto, Monto_Det_Local, Monto_Det_Moneda,
              Saldo_Det_Moneda, Saldo_Det_Local, IndCptoPrima,
              MtoOrigDetLocal, MtoOrigDetMoneda, IndPagoServicio,
              FecPagoServicio, CodProveedor
         FROM DETALLE_FACTURAS
        WHERE IdFactura = nIdFacturaAnu;
    CURSOR COMI_Q IS
       SELECT C.Cod_Agente, C.CodEmpresa, C.Comision_Local, C.Comision_Moneda,
              C.Origen, D.IdTipoSeg
         FROM COMISIONES C, DETALLE_POLIZA D
        WHERE D.IDetPol   = C.IDetPol
          AND D.IdPoliza  = C.IdPoliza
          AND D.CodCia    = C.CodCia
          AND C.IdFactura = nIdFacturaAnu;
    BEGIN
      FOR W IN FACT_Q LOOP
          -- LARPLA
          nIdFactura := OC_FACTURAS.INSERTAR(W.IdPoliza,         W.IDetPol,           W.CodCliente,  W.FecVenc,
                                             W.Monto_Fact_Local, W.Monto_Fact_Moneda, W.IdEndoso,    W.MtoComisi_Local,
                                             W.MtoComisi_Moneda, W.NumCuota,          W.Tasa_Cambio, W.CodGenerador,
                                             W.CodTipoDoc,       nCodCia,             W.Cod_Moneda,  W.CodResPago,
                                             nIdTransaccion,     W.IndFactElectronica);
          UPDATE FACTURAS f
             SET IndGenAviCob = W.IndGenAviCob,
                 FecGenAviCob = W.FecGenAviCob
           WHERE CodCia    = nCodCia
             AND IdFactura = nIdFactura;

          OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 18, 'REHAB', 'FACTURAS',
                                      W.IdPoliza, W.IDetPol, NULL, nIdFactura, W.Monto_Fact_Moneda);

          FOR Z IN DET_Q LOOP
             INSERT INTO DETALLE_FACTURAS
                    (IdFactura, CodCpto, Monto_Det_Local, Monto_Det_Moneda,
                     Saldo_Det_Moneda, Saldo_Det_Local, IndCptoPrima,
                     MtoOrigDetLocal, MtoOrigDetMoneda, IndPagoServicio,
                     FecPagoServicio, CodProveedor)
             VALUES (nIdFactura, Z.CodCpto, Z.Monto_Det_Local, Z.Monto_Det_Moneda,
                     Z.Saldo_Det_Moneda, Z.Saldo_Det_Local, Z.IndCptoPrima,
                     Z.MtoOrigDetLocal, Z.MtoOrigDetMoneda, Z.IndPagoServicio,
                     Z.FecPagoServicio, Z.CodProveedor);
          END LOOP;

          FOR Y IN COMI_Q LOOP
             OC_COMISIONES.INSERTAR_COMISION_FACT(nIdFactura, W.IdPoliza, W.IDetPol, W.Cod_Moneda,
                                                  Y.Cod_Agente, nCodCia, Y.CodEmpresa,
                                                  Y.Comision_Local, Y.Comision_Moneda, W.Tasa_Cambio,
                                                  Y.Origen, Y.IdTipoSeg);
          END LOOP;
          OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
       END LOOP;
    END REHABILITACION;

    PROCEDURE REVERTIR_PAGO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura NUMBER, nIdRecibo NUMBER,
                            dFecReversion DATE, nCodCobrador NUMBER, nIdTransaccion NUMBER) IS
    nMontoPago           PAGOS.Monto%TYPE;
    cCodMoneda           PAGOS.Moneda%TYPE;
    dFecPago             PAGOS.Fecha%TYPE;
    nIdReciboAnt         PAGOS.IdRecibo%TYPE;
    cFormPago            PAGOS.FormPago%TYPE;
    cNumDoc              PAGOS.NumDoc%TYPE;
    nSaldo_Moneda        FACTURAS.Saldo_Moneda%TYPE;
    nMonto_Fact_Moneda   FACTURAS.Monto_Fact_Moneda%TYPE;
    nTasaCambio          TASAS_CAMBIO.Tasa_Cambio%TYPE;
    nIdPoliza            FACTURAS.IdPoliza%TYPE;
    nIDetPol             FACTURAS.IDetPol%TYPE;
    nComisLiq            NUMBER(10);

    BEGIN
       SELECT COUNT(*)
         INTO nComisLiq
         FROM COMISIONES
        WHERE IdFactura  = nIdFactura
          AND CodCia     = nCodCia
          AND CodEmpresa = nCodEmpresa
          AND Estado     = 'LIQ';

       IF NVL(nComisLiq,0) != 0 THEN
          RAISE_APPLICATION_ERROR (-20100,'No puede Revertir Pago de Factura No. ' || nIdFactura ||
                                   ' Porque ya Liquidaron Comisiones');
       END IF;

       BEGIN
          SELECT NVL(Monto,0), Moneda, TRUNC(Fecha)
            INTO nMontoPago, cCodMoneda, dFecPago
            FROM PAGOS
           WHERE IdRecibo  = nIdRecibo
             AND IdFactura = nIdFactura
             AND CodCia    = nCodCia;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'No Existe Pago con Recibo No. '||nIdRecibo);
          WHEN TOO_MANY_ROWS THEN
             RAISE_APPLICATION_ERROR (-20100,'Existen Varios Pagos con Recibo No. '||nIdRecibo);
       END;

       BEGIN
          SELECT NVL(Monto_Fact_Moneda,0), NVL(Saldo_Moneda,0), IdPoliza, IDetPol
            INTO nMonto_Fact_Moneda, nSaldo_Moneda, nIdPoliza, nIDetPol
            FROM FACTURAS
           WHERE IdFactura = nIdFactura
             AND CodCia    = nCodCia;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'No Existe Factura No. '||nIdFactura);
       END;

       nTasaCambio      := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(dFecPago));
       IF (nMontoPago + nSaldo_Moneda) >= nMonto_Fact_Moneda THEN
          UPDATE FACTURAS
             SET StsFact          = 'EMI',
                 FecSts           = TRUNC(SYSDATE),
                 FecPago          = NULL,
                 ReciboPago       = NULL,
                 FormPago         = NULL,
                 EntPago          = NULL,
                 CodTipoDoc       = NULL,
                 Saldo_Local      = Monto_Fact_Local,
                 Saldo_Moneda     = Monto_Fact_Moneda
           WHERE IdFactura  = nIdFactura
             AND CodCia     = nCodCia;
       ELSE
          BEGIN
             SELECT IdRecibo, FormPago, NumDoc, TRUNC(Fecha)
               INTO nIdReciboAnt, cFormPago, cNumDoc, dFecPago
               FROM PAGOS
              WHERE IdFactura = nIdFactura
                AND CodCia    = nCodCia
                AND IdRecibo IN (SELECT MAX(IdRecibo)
                                   FROM PAGOS
                                  WHERE IdFactura        = nIdFactura
                                    AND CodCia           = nCodCia
                                    AND IdRecibo         < nIdRecibo
                                    AND IdTransaccionAnu IS NULL);
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR (-20100,'No Existe Mas Pagos para Factura No. '||nIdFactura);
          END;

          UPDATE FACTURAS
             SET StsFact          = 'ABO',
                 FecSts           = TRUNC(SYSDATE),
                 FecPago          = dFecPago,
                 ReciboPago       = nIdReciboAnt,
                 FormPago         = cFormPago,
                 EntPago          = NULL,
                 CodTipoDoc       = cNumDoc,
                 Saldo_Local      = NVL(Saldo_Local,0) + (nMontoPago * nTasaCambio),
                 Saldo_Moneda     = NVL(Saldo_Moneda,0) + nMontoPago
           WHERE IdFactura  = nIdFactura
             AND CodCia     = nCodCia;
       END IF;

       OC_DETALLE_FACTURAS.REVERTIR_PAGO(nIdRecibo, nIdFactura);

       IF GT_FAI_CONCENTRADORA_FONDO.ES_FACTURA_DE_FONDOS(nCodCia, 1, nIdPoliza, nIDetPol, nIdFactura) = 'S' THEN
          OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 21, 'REVPAG', 'FACTURAS',
                                      nIdPoliza, nIDetPol, NULL, nIdFactura, nMontoPago);
       ELSE
          OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 12, 'REVPAG', 'FACTURAS',
                                      nIdPoliza, nIDetPol, NULL, nIdFactura, nMontoPago);
       END IF;

       OC_COMISION_COBRADOR.ANULAR_COMISION(nIdFactura, nCodCobrador);
       OC_PAGOS.ANULAR(nCodCia, nCodEmpresa, nIdRecibo, nIdFactura, dFecReversion, nIdTransaccion);
    END REVERTIR_PAGO;

    PROCEDURE CAMBIO_COMISIONES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, cStsFact VARCHAR2, dfeinivig DATE) IS   --COMI --ICOCOMI
    nTotPagos          DETALLE_FACTURAS.Saldo_Det_Local%TYPE;
    nTotPrimaCanc      DETALLE_FACTURAS.Saldo_Det_Local%TYPE;
    nIdTransacAnul     TRANSACCION.IdTransaccion%TYPE;
    nIdTransacAnulNC   TRANSACCION.IdTransaccion%TYPE;
    nIdTransacPagos    TRANSACCION.IdTransaccion%TYPE;
    nIdTransacEmis     TRANSACCION.IdTransaccion%TYPE;
    nIdTransacEmisNC   TRANSACCION.IdTransaccion%TYPE;
    nIdTransacAplic    TRANSACCION.IdTransaccion%TYPE;
    nCodCliente        POLIZAS.CodCliente%TYPE;
    cCod_Moneda        POLIZAS.Cod_Moneda%TYPE;
    nIdPrimaDeposito   PRIMAS_DEPOSITO.IdPrimaDeposito%TYPE;
    nIdFactura         FACTURAS.IdFactura%TYPE;
    nIdFacturaAnt      FACTURAS.IdFactura%TYPE;
    nComision_Local    COMISIONES.Comision_Local%TYPE;
    nComision_Moneda   COMISIONES.Comision_Moneda%TYPE;
    nMonto_Det_Moneda  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
    nMonto_Det_Local   DETALLE_FACTURAS.Monto_Det_Local%TYPE;
    cIndFacturaPol     POLIZAS.IndFacturaPol%TYPE;
    nSaldo_MonedaPD    PRIMAS_DEPOSITO.Saldo_Moneda%TYPE;
    nSaldo_LocalPD     PRIMAS_DEPOSITO.Saldo_Local%TYPE;
    nTotAplicadoLocal  FACTURAS.Saldo_Local%TYPE;
    nTotAplicadoMoneda FACTURAS.Saldo_Moneda%TYPE;
    nIDetPol           FACTURAS.IDetPol%TYPE;
    nPorcComisiones    DETALLE_POLIZA.PorcComis%TYPE;
    nMontoComisiones   DETALLE_POLIZA.MontoComis%TYPE;
    cIdTipoSeg         DETALLE_POLIZA.IdTipoSeg%TYPE;
    nMontoComiLocal    COMISIONES.Comision_Local%TYPE;
    nMontoComiMoneda   COMISIONES.Comision_Moneda%TYPE;
    nIdComision        COMISIONES.IdComision%TYPE;
    nTotNotaCredCanc   DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
    nCod_Agente        AGENTE_POLIZA.Cod_Agente%TYPE;
    nIdNcr             NOTAS_DE_CREDITO.IdNcr%TYPE;
    nIdNcrAnt          NOTAS_DE_CREDITO.IdNcr%TYPE;
    cExiste            VARCHAR2(1);
    fFecFinVig         FACTURAS.FecFinVig%TYPE;      -- ICOFINVIG

    CURSOR PAG_Q IS
       SELECT F.IdFactura, F.CodCobrador, F.IDetPol,
              P.IdRecibo, NVL(P.Monto,0) MontoPago
         FROM FACTURAS F, PAGOS P
        WHERE P.IdFactura = F.IdFactura
          AND P.CodCia    = F.CodCia
          AND F.CodCia    = nCodCia
          AND F.IdPoliza  = nIdPoliza
          AND F.StsFact  IN ('ABO','PAG')
          AND F.FECVENC   >= dfeinivig               --COMI --ICOCOMI
          AND NOT EXISTS (SELECT 'S'
                            FROM COMISIONES
                           WHERE IdFactura = F.IdFactura
                             AND Estado    = 'LIQ')
        ORDER BY F.IdFactura, P.IdRecibo DESC;
    CURSOR FACT_Q IS
       SELECT IdFactura, CodCobrador, IDetPol, Saldo_Moneda
         FROM FACTURAS
        WHERE CodCia   = nCodCia
          AND IdPoliza = nIdPoliza
          AND FECVENC  >= dfeinivig               --COMI
          AND StsFact  = 'EMI'
          AND FECVENC  >= dfeinivig               --ICOCOMI
        ORDER BY IdFactura;
    CURSOR NCR_Q IS
       SELECT IdNcr, IDetPol, IdEndoso, Saldo_Ncr_Moneda
         FROM NOTAS_DE_CREDITO
        WHERE CodCia       = nCodCia
          AND IdPoliza     = nIdPoliza
          AND StsNcr       = 'EMI'
          AND FECDEVOL   >= dfeinivig               --COMI  PENDIENTE  --ICOCOMI
        ORDER BY IdNcr;
    CURSOR FACT_ANU_Q IS
       SELECT F.IdPoliza, F.IDetPol, F.CodCliente, F.FecVenc, F.Monto_Fact_Local, F.Monto_Fact_Moneda, F.IdEndoso,
              F.MtoComisi_Local, F.MtoComisi_Moneda, F.NumCuota, F.Tasa_Cambio, F.CodGenerador, F.CodTipoDoc,
              F.Cod_Moneda, F.CodResPago, F.IndFactElectronica, F.IndGenAviCob, F.FecGenAviCob, D.IdTipoSeg,
              F.IdFactura,
              F.FecFinVig,           F.CodPlanPago           --ICOFINVIG
         FROM FACTURAS F, DETALLE_POLIZA D
        WHERE F.CodCia           = nCodCia
          AND F.IdPoliza         = nIdPoliza
          AND F.IdTransaccionAnu = nIdTransacAnul
          AND F.StsFact          = 'ANU'
          AND D.CodCia           = F.CodCia
          AND D.IdPoliza         = F.IdPoliza
          AND D.IDetPol          = F.IDetPol
        ORDER BY F.IdFactura;
    CURSOR DET_Q IS
       SELECT CodCpto, Monto_Det_Local, Monto_Det_Moneda,
              Saldo_Det_Moneda, Saldo_Det_Local, IndCptoPrima,
              MtoOrigDetLocal, MtoOrigDetMoneda, IndPagoServicio,
              FecPagoServicio, CodProveedor
         FROM DETALLE_FACTURAS
        WHERE IdFactura = nIdFacturaAnt;
    CURSOR NCR_ANU_Q IS
       SELECT N.IdPoliza, N.IDetPol, N.CodCliente, N.FecDevol, N.Monto_Ncr_Local, N.Monto_Ncr_Moneda, N.IdEndoso,
              N.MtoComisi_Local, N.MtoComisi_Moneda, N.Tasa_Cambio, N.Cod_Agente, N.CodTipoDoc,
              N.CodMoneda, N.IndFactElectronica, D.IdTipoSeg, N.IdNcr,
              N.FecFinVig,            N.CodPlanPago
         FROM NOTAS_DE_CREDITO N, DETALLE_POLIZA D
        WHERE N.CodCia           = nCodCia
          AND N.IdPoliza         = nIdPoliza
          AND N.IdTransaccionAnu = nIdTransacAnulNC
          AND N.StsNcr           = 'ANU'
          AND D.CodCia           = N.CodCia
          AND D.IdPoliza         = N.IdPoliza
          AND D.IDetPol          = N.IDetPol
        ORDER BY N.IdNcr;
    CURSOR DET_NCR_Q IS
       SELECT CodCpto, Monto_Det_Local, Monto_Det_Moneda,
              IndCptoPrima, MtoOrigDetLocal, MtoOrigDetMoneda
         FROM DETALLE_NOTAS_DE_CREDITO
        WHERE IdNcr  = nIdNcrAnt;
    CURSOR PAG_FACT_Q IS
       SELECT IdFactura, CodCliente, Saldo_Local, Saldo_Moneda
         FROM FACTURAS
        WHERE IdPoliza       = nIdPoliza
          AND CodCia         = nCodCia
          AND IdTransaccion  = nIdTransacEmis
          AND StsFact        = 'EMI'
          AND (IDetPol, NumCuota) IN (SELECT F.IDetPol, F.NumCuota
                                        FROM FACTURAS F, PAGOS P
                                       WHERE P.IdTransaccionAnu = nIdTransacPagos
                                         AND P.IdFactura        = F.IdFactura
                                         AND F.IdPoliza         = nIdPoliza
                                         AND F.CodCia           = nCodCia
                                         AND F.StsFact          = 'ANU')
        ORDER BY IdFactura;
    CURSOR C_AGENTES_D IS
      SELECT Cod_Agente_Distr Cod_Agente, Porc_Com_Proporcional Porc_Comision,
             Porc_Com_Distribuida, Origen
        FROM AGENTES_DISTRIBUCION_COMISION
       WHERE IdPoliza   = nIdPoliza
         AND IDetPol    = nIdetPol;
    BEGIN
       SELECT IndFacturaPol
         INTO cIndFacturaPol
         FROM POLIZAS
        WHERE CodCia    = nCodCia
          AND IdPoliza  = nIdPoliza;

       nIdTransacPagos := 0;
       IF cStsFact = 'TODOS' THEN
          -- Se Reversan todos los Pagos de Facturas
          FOR W IN PAG_Q LOOP
             IF NVL(nIdTransacPagos,0) = 0 THEN
                nIdTransacPagos  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 12, 'REVPAG');
                nIDetPol         := W.IDetPol;
             END IF;
             -- Acumula Total de Pagos
             nTotPagos  := NVL(nTotPagos,0) + W.MontoPago;
             OC_FACTURAS.REVERTIR_PAGO(nCodCia, nCodEmpresa, W.IdFactura, W.IdRecibo,
                                       TRUNC(SYSDATE), W.CodCobrador, nIdTransacPagos);
             OC_COMISIONES.REVERSA_PAGO(nCodCia, W.IdFactura);
          END LOOP;

          IF NVL(nIdTransacPagos,0) > 0 THEN
             OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacPagos, 'C');

             SELECT CodCliente, Cod_Moneda
               INTO nCodCliente, cCod_Moneda
               FROM POLIZAS
              WHERE IdPoliza = nIdPoliza
                AND CodCia   = nCodCia;
             nIdPrimaDeposito := OC_PRIMAS_DEPOSITO.INSERTAR(nCodCliente, nTotPagos, cCod_Moneda,
                                                             'Prima en Depósito por Reverso de Pagos realizados a la ' ||
                                                             'Póliza No. ' || nIdPoliza || ' Por Cambio de la Estructura ' ||
                                                             'de Comisiones para Agentes, Promotores y Dirección Regional',
                                                             nIdPoliza, nIDetPol);
             OC_PRIMAS_DEPOSITO.EMITIR(nCodCia, nCodEmpresa, nIdPrimaDeposito, TRUNC(SYSDATE), NULL);
          END IF;
       END IF;
       -- Anulación de Facturas Emitidas
       nIdTransacAnul := 0;
       FOR W IN FACT_Q LOOP
          IF NVL(nIdTransacAnul,0) = 0 THEN
             nIdTransacAnul := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 2, 'FAC');
          END IF;
          OC_FACTURAS.ANULAR(nCodCia, W.IdFactura, TRUNC(SYSDATE), 'CCO', W.CodCobrador, nIdTransacAnul);
          OC_DETALLE_TRANSACCION.CREA(nIdTransacAnul, nCodCia, nCodEmpresa, 2, 'FAC', 'FACTURAS',
                                      nIdPoliza, W.IDetPol, NULL, W.IdFactura, W.Saldo_Moneda);
       END LOOP;
       IF NVL(nIdTransacAnul,0) > 0 THEN
          OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacAnul, 'C');
       END IF;

       -- Anulación de Notas de Crédito
       nIdTransacAnulNC := 0;
       FOR W IN NCR_Q LOOP
          IF NVL(nIdTransacAnulNC,0) = 0 THEN
             nIdTransacAnulNC := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 8, 'ANUNCR');
          END IF;
          -- Acumula Prima Devuelta
          SELECT NVL(SUM(Monto_Det_Moneda),0)
            INTO nTotNotaCredCanc
            FROM DETALLE_NOTAS_DE_CREDITO D, NOTAS_DE_CREDITO N, CATALOGO_DE_CONCEPTOS C
           WHERE C.CodConcepto      = D.CodCpto
             AND C.CodCia           = N.CodCia
             AND (D.IndCptoPrima    = 'S'
              OR C.IndCptoServicio  = 'S')
             AND D.IdNcr            = N.IdNcr
             AND N.IdNcr            = W.IdNcr;

          OC_NOTAS_DE_CREDITO.ANULAR(W.IdNcr, TRUNC(SYSDATE), 'CCO', nIdTransacAnulNC);

          OC_DETALLE_TRANSACCION.CREA(nIdTransacAnulNC, nCodCia,  nCodEmpresa, 8, 'ANUNCR', 'NOTAS_DE_CREDITO',
                                      nIdPoliza, W.IDetPol, W.IdEndoso, W.IdNcr, nTotNotaCredCanc);
       END LOOP;
       IF NVL(nIdTransacAnulNC,0) > 0 THEN
          OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacAnulNC, 'C');
       END IF;

       -- Cambia Distribución de Comisiones
       OC_AGENTE_POLIZA_T.CAMBIAR_DISTRIBUCION(nCodCia, nIdPoliza);

       SELECT MAX(Cod_Agente)
         INTO nCod_Agente
         FROM AGENTE_POLIZA
        WHERE CodCia        = nCodCia
          AND IdPoliza      = nIdPoliza
          AND Ind_Principal = 'S';

       -- Reemite las Facturas Anulada por el Cambio de Comisiones
       IF NVL(nIdTransacAnul,0) > 0 THEN
          FOR W IN FACT_ANU_Q LOOP
             IF NVL(nIdTransacEmis,0) = 0 THEN
                nIdTransacEmis := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 7, 'FAC');
             END IF;
             -- LARPLA
             nIdFactura := OC_FACTURAS.INSERTAR(W.IdPoliza,         W.IDetPol,           W.CodCliente,  W.FecVenc,
                                                W.Monto_Fact_Local, W.Monto_Fact_Moneda, W.IdEndoso,    W.MtoComisi_Local,
                                                W.MtoComisi_Moneda, W.NumCuota,          W.Tasa_Cambio, nCod_Agente,
                                                W.CodTipoDoc,       nCodCia,             W.Cod_Moneda,  W.CodResPago,
                                                nIdTransacEmis,     W.IndFactElectronica);
             UPDATE FACTURAS F
                SET IndGenAviCob = W.IndGenAviCob,
                    FecGenAviCob = W.FecGenAviCob
              WHERE CodCia    = nCodCia
                AND IdFactura = nIdFactura;

             OC_DETALLE_TRANSACCION.CREA(nIdTransacEmis, nCodCia, nCodEmpresa, 7, 'FAC', 'FACTURAS',
                                         W.IdPoliza, W.IDetPol, NULL, nIdFactura, W.Monto_Fact_Moneda);

             nIdFacturaAnt := W.IdFactura;
             FOR Z IN DET_Q LOOP
                INSERT INTO DETALLE_FACTURAS
                       (IdFactura, CodCpto, Monto_Det_Local, Monto_Det_Moneda,
                        Saldo_Det_Moneda, Saldo_Det_Local, IndCptoPrima,
                        MtoOrigDetLocal, MtoOrigDetMoneda, IndPagoServicio,
                        FecPagoServicio, CodProveedor)
                VALUES (nIdFactura, Z.CodCpto, Z.Monto_Det_Local, Z.Monto_Det_Moneda,
                        Z.Saldo_Det_Moneda, Z.Saldo_Det_Local, Z.IndCptoPrima,
                        Z.MtoOrigDetLocal, Z.MtoOrigDetMoneda, Z.IndPagoServicio,
                        Z.FecPagoServicio, Z.CodProveedor);
             END LOOP;

             SELECT NVL(SUM(Monto_Det_Moneda),0), NVL(SUM(Monto_Det_Moneda),0)
               INTO nMonto_Det_Moneda, nMonto_Det_Local
               FROM DETALLE_FACTURAS D, FACTURAS F, CATALOGO_DE_CONCEPTOS C
              WHERE C.CodConcepto      = D.CodCpto
                AND C.CodCia           = F.CodCia
                AND (D.IndCptoPrima    = 'S'
                 OR C.IndCptoServicio  = 'S')
                AND D.IdFactura        = F.IdFactura
                AND F.IdFactura        = nIdFactura;

             nIDetPol  := W.IDetPol;
             FOR R IN C_AGENTES_D LOOP
                SELECT NVL(PorcComis,0), NVL(MontoComis,0), IdTipoSeg
                  INTO nPorcComisiones, nMontoComisiones, cIdTipoSeg
                  FROM DETALLE_POLIZA
                 WHERE IdPoliza  = nIdPoliza
                   AND IDetPol   = nIDetPol
                   AND CodCia    = nCodCia;

                IF NVL(nMontoComisiones,0) = 0 THEN
                   nMontoComiLocal  := nMonto_Det_Local * (R.Porc_Com_Distribuida/100);
                   nMontoComiMoneda := nMonto_Det_Moneda * (R.Porc_Com_Distribuida/100);
                ELSE
                   nMontoComiLocal  := nMontoComisiones * (R.Porc_Comision/100);
                   nMontoComiMoneda := nMontoComisiones / W.Tasa_Cambio * (R.Porc_Comision/100);
                END IF;

                BEGIN
                   SELECT 'S'
                     INTO cExiste
                     FROM COMISIONES
                    WHERE IdPoliza  = nIdPoliza
                      AND IdFactura = nIdFactura
                      AND Cod_Agente = R.Cod_Agente;
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                      cExiste :='N';
                  WHEN TOO_MANY_ROWS THEN
                      cExiste :='S';
                END;

                IF cExiste = 'N' THEN
                   OC_COMISIONES.INSERTAR_COMISION_FACT(nIdFactura, nIdPoliza, W.IdetPol, W.Cod_Moneda, R.Cod_Agente,
                                                        nCodCia, nCodEmpresa, nMontoComiLocal, nMontoComiMoneda,
                                                        W.Tasa_Cambio, R.Origen, cIdTipoSeg);
                ELSIF cExiste = 'S' THEN
                   UPDATE COMISIONES
                      SET Comision_Moneda  = Comision_Moneda + nMontoComiMoneda,
                          Comision_Local   = Comision_Local   + nMontoComiLocal,
                          Com_Saldo_Local  = Com_Saldo_Local  + nMontoComiLocal,
                          Com_Saldo_Moneda = Com_Saldo_Moneda + nMontoComiMoneda
                    WHERE IdPoliza   = IdPoliza
                      AND IdFactura  = nIdFactura
                      AND Cod_Agente = R.Cod_Agente;

                   nMontoComiLocal  := 0;
                   nMontoComiMoneda := 0;

                   SELECT IdComision
                     INTO nIdComision
                     FROM COMISIONES
                    WHERE IdPoliza   = nIdPoliza
                      AND IdFactura  = nIdFactura
                      AND Cod_Agente = R.Cod_Agente;

                   -- Elimina para Recalcular los Conceptos del Detale
                   DELETE DETALLE_COMISION
                    WHERE IdComision = nIdComision;

                   OC_DETALLE_COMISION.INSERTA_DETALLE_COMISION(nCodCia, nIdPoliza, nIdComision, R.Origen, cIdTipoSeg);
                END IF;
                nMontoComiLocal  := 0;
                nMontoComiMoneda := 0;
             END LOOP;

             SELECT NVL(SUM(Comision_Local),0), NVL(SUM(Comision_Moneda),0)
               INTO nComision_Local, nComision_Moneda
               FROM COMISIONES
              WHERE IdFactura = nIdFactura;

             UPDATE FACTURAS
                SET MtoComisi_Local  = nComision_Local,
                    MtoComisi_Moneda = nComision_Moneda
              WHERE IdFactura = nIdFactura;
          END LOOP;
          OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacEmis, 'C');
       END IF;

       -- Reemite las Notas de Crédito Anulada por el Cambio de Comisiones
       IF NVL(nIdTransacAnulNC,0) > 0 THEN
          FOR W IN NCR_ANU_Q LOOP
             IF NVL(nIdTransacEmisNC,0) = 0 THEN
                nIdTransacEmisNC := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 2, 'NOTACR');
             END IF;
             --LARPLA
             nIdNcr := OC_NOTAS_DE_CREDITO.INSERTA_NOTA_CREDITO(nCodCia,           W.IdPoliza,          W.IDetPol,         W.IdEndoso,
                                                                W.CodCliente,      W.FecDevol,          W.Monto_Ncr_Local, W.Monto_Ncr_Moneda,
                                                                W.MtoComisi_Local, W.MtoComisi_Moneda,  nCod_Agente,       W.CodMoneda,
                                                                W.Tasa_Cambio,     nIdTransacEmisNC,    W.IndFactElectronica);

             OC_DETALLE_TRANSACCION.CREA (nIdTransacEmisNC, nCodCia,  nCodEmpresa, 2, 'NOTACR', 'NOTAS_DE_CREDITO',
                                          W.IdPoliza, W.IDetPol, W.IdEndoso, nIdNcr, W.Monto_Ncr_Moneda);

             nIdNcrAnt := W.IdNcr;
             FOR Z IN DET_NCR_Q LOOP
                INSERT INTO DETALLE_NOTAS_DE_CREDITO
                       (IdNcr, CodCpto, Monto_Det_Local, Monto_Det_Moneda,
                        IndCptoPrima, MtoOrigDetLocal, MtoOrigDetMoneda)
                VALUES (nIdNcr, Z.CodCpto, Z.Monto_Det_Local, Z.Monto_Det_Moneda,
                        Z.IndCptoPrima, Z.MtoOrigDetLocal, Z.MtoOrigDetMoneda);
             END LOOP;

             OC_NOTAS_DE_CREDITO.ACTUALIZA_NOTA(nIdNcr);
             OC_COMISIONES.INSERTA_COMISION_NC(nIdNcr);
             OC_NOTAS_DE_CREDITO.EMITIR(nIdNcr, NULL);
          END LOOP;
          IF NVL(nIdTransacEmisNC,0) != 0 THEN
             OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacEmisNC, 'C');
          END IF;
       END IF;

       IF cStsFact = 'TODOS' AND nIdPrimaDeposito != 0 AND NVL(nIdTransacPagos,0) > 0 THEN
          -- Aplica Pagos con la Prima en Depósito Generada.
          nIdTransacAplic := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 12, 'PAG');
          BEGIN
             SELECT Saldo_Moneda, Saldo_Local
               INTO nSaldo_MonedaPD, nSaldo_LocalPD
               FROM PRIMAS_DEPOSITO
              WHERE IdPrimaDeposito = nIdPrimaDeposito;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR (-20100,'No Existe Prima en Depósito x Aplicar '||nIdPrimaDeposito);
          END;

          nTotAplicadoLocal  := 0;
          nTotAplicadoMoneda := 0;
          FOR W IN PAG_FACT_Q LOOP
             IF nSaldo_MonedaPD >= W.Saldo_Moneda THEN
                nTotAplicadoLocal  := NVL(nTotAplicadoLocal,0) + W.Saldo_Local;
                nTotAplicadoMoneda := NVL(nTotAplicadoMoneda,0) + W.Saldo_Moneda;
                OC_FACTURAS.PAGAR_CON_PRIMA_DEPOSITO(W.IdFactura, nIdPrimaDeposito, nIdPrimaDeposito, TRUNC(SYSDATE), NULL, nIdTransacAplic);
                OC_DETALLE_PRIMAS_DEPOSITO.INSERTAR(W.CodCliente, nIdPrimaDeposito, nIdPrimaDeposito,
                                                    W.IdFactura, nIdPoliza, W.Saldo_Moneda, 'PAT');
                nSaldo_MonedaPD := NVL(nSaldo_MonedaPD,0) - W.Saldo_Moneda;
                nSaldo_LocalPD  := NVL(nSaldo_LocalPD,0) - W.Saldo_Local;
             END IF;
          END LOOP;
          OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacAplic, 'C');

          IF NVL(nTotAplicadoMoneda,0) != 0 THEN
             nSaldo_MonedaPD := NVL(nSaldo_MonedaPD,0) + nTotAplicadoMoneda;
             nSaldo_LocalPD  := NVL(nSaldo_LocalPD,0) + nTotAplicadoLocal;
             OC_PRIMAS_DEPOSITO.APLICAR(nCodCia, nCodEmpresa, nIdPrimaDeposito, TRUNC(SYSDATE),
                                        nIdPrimaDeposito, nSaldo_MonedaPD, nSaldo_LocalPD,
                                        nTotAplicadoMoneda, nTotAplicadoLocal);
          END IF;
       END IF;
    END CAMBIO_COMISIONES;

    FUNCTION VIGENCIA_FINAL(nCodCia        NUMBER,   nCodEmpresa    NUMBER,  nIdPoliza      NUMBER,
                            nIdFactura     NUMBER,   nIdEndoso      NUMBER,  dFecIniVigFact DATE,
                            dFecFinVigPol  DATE,     nNUMCUOTA      NUMBER,  cCodPlanPagos  VARCHAR2) RETURN DATE IS   -- INICIA FINVIG  LARPLA
    --
    nFrecPagos     PLAN_DE_PAGOS.FrecPagos%TYPE;
    cTipoEndoso    ENDOSOS.TipoEndoso%TYPE;
    dFecFinVig     ENDOSOS.FecFinVig%TYPE;
    dFecFinVigFact DATE;
    --
    BEGIN
      --
      nFrecPagos := OC_PLAN_DE_PAGOS.FRECUENCIA_PAGOS(nCodCia, nCodEmpresa, cCodPlanPagos);
      --
      IF nIdEndoso != 0 THEN
         BEGIN
           SELECT TipoEndoso, FecFinVig
             INTO cTipoEndoso, dFecFinVig
             FROM ENDOSOS
            WHERE IdPoliza = nIdPoliza
              AND IdEndoso = nIdEndoso
              AND CodCia   = nCodCia;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
                cTipoEndoso := NULL;
           WHEN TOO_MANY_ROWS THEN
                cTipoEndoso := NULL;
           WHEN OTHERS THEN
                cTipoEndoso := NULL;
         END;
      ELSE
         cTipoEndoso := NULL;
      END IF;
      --
      IF cTipoEndoso IN ('RSS','EAD') THEN
         dFecFinVigFact  := dFecFinVig;
      ELSE
         IF nFrecPagos = 15 THEN
            IF nNUMCUOTA = 24 THEN
               dFecFinVigFact := dFecFinVigPol;
            ELSE
               dFecFinVigFact := dFecIniVigFact + nFrecPagos;
            END IF;
         ELSIF nFrecPagos = 7 THEN
            IF nNUMCUOTA = 52 THEN
               dFecFinVigFact := dFecFinVigPol;
            ELSE
               dFecFinVigFact := dFecIniVigFact + nFrecPagos;
            END IF;
         ELSE
            dFecFinVigFact := ADD_MONTHS(dFecIniVigFact, nFrecPagos);
         END IF;
       --
         IF dFecFinVigFact > dFecFinVigPol THEN
            dFecFinVigFact := dFecFinVigPol;
         END IF;
       --
      END IF;
      --
      RETURN(dFecFinVigFact);
      --
    END VIGENCIA_FINAL;   -- FIN FINVIG  LARPLA



    --------------------------------------------------------------------
       -- Funcion para buscar el proximo numero de Facturas   ---
    --------------------------------------------------------------------
    FUNCTION F_GET_FACT ( P_Msg_Regreso OUT NOCOPY VARCHAR2 ) RETURN NUMBER AS
    PRAGMA AUTONOMOUS_TRANSACTION;

    vNumFACT        PARAMETROS_ENUM_FAC.Paen_Cont_Fin%type;
    vNombreTabla    varchar2(30);
    vIdProducto     number(6);
    BEGIN
     -- Buscar el nombre de la tabla de la cual se obtendra por la descripcion y la bANDera
       SELECT PA.Pame_Ds_Numerador, PA.Paem_Id_Producto
         INTO vNombreTabla, vIdProducto
         FROM PARAMETROS_EMISION PA
        WHERE PA.Paem_Cd_Producto   =  4
          AND PA.Paem_Des_Producto  = 'FACTURAS'
          AND Pa.Paem_Flag          =  1;

     -- Obtener el numero de facturas

      SELECT PNF.Paen_Cont_Fin
        INTO vNumFACT
        FROM PARAMETROS_ENUM_FAC PNF
       WHERE PNF.Paen_Id_Fac = vIdProducto;
         --FOR UPDATE OF pnf.paen_cont_fin;

    --  Actualizar al siguiente numero
       BEGIN
          UPDATE PARAMETROS_ENUM_FAC PE
             SET PE.Paen_Cont_Fin = vNumFACT + 1
           WHERE PE.Paen_Id_Fac  = vIdProducto;
           COMMIT;
       END;
    -- Hacer permanentes los cambios para evitar bloqueo de la tabla
    --       commit;
       RETURN vNumFACT;

    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          P_Msg_Regreso := '.:: No se ha dado de alta '|| vNombreTabla ||' en PARAMETROS_EMISION ::.'||SQLERRM;
          ROLLBACK;
         RETURN 0;
       WHEN OTHERS THEN
          P_Msg_Regreso := '.:: Error en "OC_UTILS.F_GET_FACT" .:: -> '||SQLERRM;
          ROLLBACK;
          RETURN 0;
    END F_GET_FACT;

    FUNCTION EN_COBRANZA_MASIVA(nCodCia NUMBER, nIdFactura NUMBER) RETURN VARCHAR2 IS
    cIndDomiciliado   FACTURAS.IndDomiciliado%TYPE;
    BEGIN
       SELECT NVL(MAX(IndDomiciliado),'N')
         INTO cIndDomiciliado
         FROM FACTURAS
        WHERE CodCia    = nCodCia
          AND IdFactura = nIdFactura;

       RETURN(cIndDomiciliado);
    END EN_COBRANZA_MASIVA;

    FUNCTION FACTURA_ELECTRONICA(nIdFactura  NUMBER, nCodCia  NUMBER, nCodEmpresa  NUMBER,
                                 cTipoCfdi VARCHAR2, cIndRelaciona VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS
        cCodRespuesta PARAMETROS_GLOBALES.Descripcion%TYPE := '000';
        cStsFact      FACTURAS.Stsfact%TYPE;
        cProceso      VALORES_DE_LISTAS.CodValor%TYPE;
        cIndRel       VARCHAR2(1);
        cIndEnvia     VARCHAR2(1) := 'N';
    BEGIN
        --RAISE_APPLICATION_ERROR (-20100,'ENTRA A TIMBRAR A FACTURAR.... ');
        BEGIN
            SELECT StsFact
              INTO cStsFact
              FROM FACTURAS
             WHERE IdFactura = nIdFactura;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR (-20100,'No Es Posible Determinar La Factura '||nIdFactura||' Para Facturar Electrónicamente, Por Favor Valide Que Existe La Factura');
        END;
        IF cStsFact = 'ANU' THEN
            cProceso := 'CAN';
            cIndRel := 'N';
            IF OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO(nCodCia, nCodEmpresa, nIdFactura, '', cProceso) = 'N' THEN
                cIndEnvia := 'S';
            ELSE
                cIndEnvia := 'N';
            END IF;
        ELSIF cStsFact = 'EMI' THEN
            cProceso := 'EMI';
            cIndRel := 'N';
            IF OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO(nCodCia, nCodEmpresa, nIdFactura, '', cProceso) = 'N' THEN
                cIndEnvia := 'S';
            ELSE
                cIndEnvia := 'N';
            END IF;
        ELSIF cStsFact IN ('ABO','PAG') THEN
            cProceso := 'PAG';
            cIndRel := 'S';
            IF OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO(nCodCia, nCodEmpresa, nIdFactura, '', cProceso) = 'N' THEN
                cIndEnvia := 'S';
            ELSE
                cIndEnvia := 'N';
            END IF;
        END IF;
        IF cIndEnvia = 'S' THEN
                OC_FACT_ELECT_CONF_DOCTO.TIMBRAR(nIdFactura, NULL, nCodCia, nCodEmpresa, cProceso, cTipoCfdi, cIndRel, cCodRespuesta);
        END IF;
        RETURN cCodRespuesta;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN cCodRespuesta;
    END FACTURA_ELECTRONICA;

    FUNCTION DESC_COMPLEMENTARIA_FACT_ELECT(nIdFactura  NUMBER, nCodCia  NUMBER) RETURN VARCHAR2 IS
        cDescComplementaria VARCHAR2(2000);
        nTotFacturas        NUMBER(14);
        cTipoEndoso         ENDOSOS.TipoEndoso%TYPE;
        cCodPlanPagos       PLAN_DE_PAGOS.CodPlanPago%TYPE;
        nIdPoliza           POLIZAS.IdPoliza%TYPE;
        nIDetPol            FACTURAS.IDetPol%TYPE;
        nIdEndoso           FACTURAS.IdEndoso%TYPE;
        nNumCuota           FACTURAS.NumCuota%TYPE;


    BEGIN
        BEGIN
            SELECT IdPoliza, IDetPol, IdEndoso,
                   NumCuota
              INTO nIdPoliza, nIDetPol, nIdEndoso,
                   nNumCuota
              FROM FACTURAS
             WHERE CodCia             = nCodCia
               AND IdFactura          = nIdFactura;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR (-20100,'Error al Determinar Número de Cuota de Recibo: '||nIdFactura);
        END;

        cCodPlanPagos      := OC_FACTURAS.CODIGO_PLAN_PAGOS(nCodCia, nIdFactura);

        IF nIdEndoso = 0 THEN
            SELECT NumPagos
              INTO nTotFacturas
              FROM PLAN_DE_PAGOS
             WHERE CodPlanPago = cCodPlanPagos;
        ELSE
            SELECT TipoEndoso
              INTO cTipoEndoso
              FROM ENDOSOS
             WHERE IdPoliza      = nIdPoliza
               AND CodCia        = nCodCia
               AND IDetPol       = nIDetPol
               AND IdEndoso      = nIdEndoso;

            IF cTipoEndoso != 'EAD' THEN
                SELECT numpagos
                  INTO nTotFacturas
                  FROM PLAN_DE_PAGOS
                 WHERE CodPlanPago = (SELECT CodPlanPago
                                        FROM ENDOSOS
                                       WHERE IdPoliza    = nIdPoliza
                                         AND IdEndoso    = nIdEndoso);
            ELSE -- Endoso a Declaración
                SELECT COUNT(*)
                  INTO nTotFacturas
                  FROM FACTURAS
                 WHERE IdTransaccion IN (SELECT MIN(IdTransaccion)
                                           FROM FACTURAS
                                          WHERE CodCia         = nCodCia
                                            AND IdPoliza       = nIdPoliza
                                            AND IDetPol        = nIDetPol
                                            AND NumCuota       = nNumCuota
                                            AND IdEndoso       = 0)
                   AND CodCia         = nCodCia
                   AND IdPoliza       = nIdPoliza
                   AND IDetPol        = nIDetPol;
                   --AND StsFact        = 'EMI' --AEVS 21082018
            END IF;
        END IF;

        IF nIdEndoso = 0 THEN
            cDescComplementaria    := ' - ' || TRIM(TO_CHAR(nNumCuota,'990')) || '/' || TRIM(TO_CHAR(nTotFacturas,'990'));
        ELSE
            cDescComplementaria    := ' - ' || TRIM(TO_CHAR(nNumCuota,'990')) || '/' || TRIM(TO_CHAR(nTotFacturas,'990')) || ' - ' || 'DEL ENDOSO ' || TRIM(TO_CHAR(nIdEndoso,'990'));
        END IF;

        RETURN cDescComplementaria;
    END DESC_COMPLEMENTARIA_FACT_ELECT;

    FUNCTION IND_RFC_GENERICO_FACT_ELECT(nIdFactura  NUMBER, nCodCia  NUMBER) RETURN VARCHAR2 IS
        cIndFactCteRFCGenerico FACTURAS.IndFactCteRFCGenerico%TYPE;
    BEGIN
        SELECT IndFactCteRFCGenerico
          INTO cIndFactCteRFCGenerico
          FROM FACTURAS
         WHERE IdFactura = nIdFactura
           AND nCodCia   = nCodCia;

        RETURN cIndFactCteRFCGenerico;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR (-20100,'Error al Determinar Indicador de RFC Genérico');
    END IND_RFC_GENERICO_FACT_ELECT;

    FUNCTION CTE_RFC_GENERICO_FACT_ELECT(nIdFactura  NUMBER, nCodCia  NUMBER) RETURN NUMBER IS
        nCodCliRFCGenerico FACTURAS.CodCliRFCGenerico%TYPE;
    BEGIN
        SELECT NVL(CodCliRFCGenerico,0)
          INTO nCodCliRFCGenerico
          FROM FACTURAS
         WHERE IdFactura = nIdFactura
           AND CodCia    = nCodCia;

        RETURN nCodCliRFCGenerico;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR (-20100,'Error al Determinar Cliente de RFC Genérico');
    END CTE_RFC_GENERICO_FACT_ELECT;

    FUNCTION NUM_INTENTOS_COBRA_REALIZADOS (nIdFactura  NUMBER, nCodCia  NUMBER) RETURN NUMBER IS
        nNumIntentosCobraRealizados FACTURAS.NumIntentosCobraRealizados%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(NumIntentosCobraRealizados,0)
              INTO nNumIntentosCobraRealizados
              FROM FACTURAS
             WHERE IdFactura = nIdFactura
               AND CodCia    = nCodCia;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR (-20100,'Error al Determinar el Aviso de Cobro');
        END;
        RETURN nNumIntentosCobraRealizados;
    END NUM_INTENTOS_COBRA_REALIZADOS;

    FUNCTION INTENTOS_COBRANZA_CUMPLIDOS (nIdFactura  NUMBER, nCodCia  NUMBER) RETURN VARCHAR2 IS
        cIndIntentosCumplidos FACTURAS.IndIntentosCumplidos%TYPE;
    BEGIN
        BEGIN
            SELECT NVL(IndIntentosCumplidos,'N')
              INTO cIndIntentosCumplidos
              FROM FACTURAS
             WHERE IdFactura = nIdFactura
               AND CodCia    = nCodCia;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR (-20100,'Error al Determinar el Aviso de Cobro');
        END;
        RETURN cIndIntentosCumplidos;
    END INTENTOS_COBRANZA_CUMPLIDOS;

    PROCEDURE ACTUALIZA_NUMERO_INTENTOS (nIdFactura  NUMBER, nCodCia  NUMBER, nNumIntento NUMBER) IS
    BEGIN
        UPDATE FACTURAS
           SET NumIntentosCobraRealizados = nNumIntento
         WHERE IdFactura = nIdFactura
           AND CodCia    = nCodCia;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR (-20100,'Error al Actualizar Número de Intentos de Cobranza Para el Aviso de Cobro '||nIdFactura);
    END ACTUALIZA_NUMERO_INTENTOS;

    PROCEDURE MARCA_INTENTOS_CUMPLIDOS (nIdFactura  NUMBER, nCodCia  NUMBER) IS
    BEGIN
        UPDATE FACTURAS
           SET IndIntentosCumplidos = 'S'
         WHERE IdFactura = nIdFactura
           AND CodCia    = nCodCia;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR (-20100,'Error al Actualizar el Aviso de Cobro '||nIdFactura||' como Intentos de Cobro Cumplidos');
    END MARCA_INTENTOS_CUMPLIDOS;

    FUNCTION CALCULA_AÑO_POLIZA(nIdPoliza NUMBER, nFechaproceso DATE) RETURN NUMBER IS --LARPLA
    nAño_Poliza FACTURAS.Id_Año_Poliza%TYPE;
    BEGIN
       BEGIN
          SELECT TRUNC(ABS((P.FecIniVig - nFechaproceso))/365) + 1
            INTO nAño_Poliza
            FROM POLIZAS P
           WHERE P.IdPoliza = nIdPoliza;
           --
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
             nAño_Poliza := 1;
          WHEN OTHERS THEN
             nAño_Poliza := 1;
       END;
       RETURN nAño_Poliza;
    END CALCULA_AÑO_POLIZA;

    FUNCTION PRIMA_COMPLEMENTARIA (nCodCia NUMBER, nIdPoliza NUMBER, nIdFactura NUMBER) RETURN NUMBER IS
    nMontoPrimaCompMoneda FACTURAS.MontoPrimaCompMoneda%TYPE;
    BEGIN
       BEGIN
          SELECT NVL(MontoPrimaCompMoneda,0)
            INTO nMontoPrimaCompMoneda
            FROM FACTURAS
           WHERE CodCia     = nCodCia
             AND IdPoliza   = nIdPoliza
             AND IdFactura  = nIdFactura;
       END;
       RETURN nMontoPrimaCompMoneda;
    END PRIMA_COMPLEMENTARIA;

    FUNCTION PAGAR_ALTURA_CERO(nIdFactura NUMBER, cNumReciboPago VARCHAR2, dFecPago DATE, nMontoPago NUMBER,
                               cFormPago VARCHAR2, cEntPago VARCHAR2, nIdTransaccion NUMBER,
                               nMontoPrimaCompMoneda NUMBER, nMontoAporteFondo NUMBER) RETURN NUMBER IS
    nCodCia                 EMPRESAS.CodCia%TYPE;
    nCodEmpresa             DETALLE_POLIZA.CodEmpresa%TYPE;
    nSldoFactL              FACTURAS.Saldo_Local%TYPE;
    nSldoFactM              FACTURAS.Saldo_Moneda%TYPE;
    nPorcApl                FACTURAS.Saldo_Local%TYPE;
    nMonto_Fact_Moneda      FACTURAS.Monto_Fact_Moneda%TYPE;
    nMontoPago_Local        FACTURAS.Monto_Fact_Moneda%TYPE;
    nCodCobrador            FACTURAS.CodCobrador%TYPE;
    cIndPago                VARCHAR2(1);
    dFecHoy                 DATE;
    cCodMoneda              FACTURAS.Cod_Moneda%type;
    nTasaCambioMov          TASAS_CAMBIO.Tasa_Cambio%TYPE;
    nCodCliente             FACTURAS.CodCliente%type;
    nNumPD                  primas_deposito.idprimadeposito%type;
    nIdRecibo               PAGOS.IdRecibo%TYPE;
    nIdPoliza               POLIZAS.IdPoliza%TYPE;
    nIDetPol                DETALLE_POLIZA.IDetPol%TYPE;
    nIdEndoso               ENDOSOS.IdEndoso%TYPE;
    nCodAsegurado           DETALLE_POLIZA.Cod_Asegurado%TYPE;
    nNumCuota               FACTURAS.NumCuota%TYPE;
    cObservaciones          PRIMAS_DEPOSITO.Observaciones%TYPE;
    cCodCptoMov             FAI_MOVIMIENTOS_FONDOS.CodCptoMov%TYPE;
    nIdFondo                FAI_CONCENTRADORA_FONDO.IdFondo%TYPE;
    nIdPrimaDeposito        PRIMAS_DEPOSITO.IdPrimaDeposito%TYPE;
    nIdTransaccionMov       TRANSACCION.IdTransaccion%TYPE;
    nIdTransaccionFact      TRANSACCION.IdTransaccion%TYPE;
    nIdTransaccionPag       TRANSACCION.IdTransaccion%TYPE;
    nIdTransaccionRetiro    TRANSACCION.IdTransaccion%TYPE;
    nMontoMovMoneda         FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
    nMontoMovLocal          FAI_CONCENTRADORA_FONDO.MontoMovLocal%TYPE;
    nSaldoPorAplicar        FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
    nSaldoRestante          FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
    nMontoPrimaDepMon       PRIMAS_DEPOSITO.Monto_Moneda%TYPE;
    nMontoPrimaDepLoc       PRIMAS_DEPOSITO.Monto_Local%TYPE;
    nPorcComis              DETALLE_POLIZA.PorcComis%TYPE;
    nIdFacturaPN            FACTURAS.IdFactura%TYPE;
    nIdFacturaAportes       FACTURAS.IdFactura%TYPE;
    nMtoComisiMoneda        FACTURAS.MtoComisi_Moneda%TYPE;
    nMtoComisiLocal         FACTURAS.MtoComisi_Local%TYPE;
    nTotComiMoneda          FACTURAS.MtoComisi_Moneda%TYPE;
    cIdTipoSeg              DETALLE_POLIZA.IdTipoSeg%TYPE;
    cPlanCob                DETALLE_POLIZA.PlanCob%TYPE;
    nCod_Agente             AGENTES_DETALLES_POLIZAS.Cod_Agente%TYPE;
    nCodTipoDoc             TIPO_DE_DOCUMENTO.CodTipoDoc%TYPE;
    cIndFactElectronica     DETALLE_POLIZA.IndFactElectronica%TYPE;
    cCodPlanPago            DETALLE_POLIZA.CodPlanPago%TYPE;
    dFecFinVigFact          FACTURAS.FecFinVig%TYPE;
    nSaldoFondo             FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
    nMontoInteres           FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
    cTipoFondo              FAI_FONDOS_DETALLE_POLIZA.TipoFondo%TYPE;
    cNumPolUnico            POLIZAS.NumPolUnico%TYPE;
    nIdPolizaAnu            POLIZAS.IdPoliza%TYPE;
    nExisteRecPrevio        NUMBER(5);
    cFondoPagoPrimas        VARCHAR2(1);
    cCobroFactura           VARCHAR2(1);
    cIndTipoAporte          VARCHAR2(1);

    cIndContabilizada       FACTURAS.IndContabilizada%TYPE;
    nIdTransaccionCont      TRANSACCION.IdTransaccion%TYPE;

    CURSOR FOND_Q IS
       SELECT TipoFondo, NumSolicitud, PorcFondo, IdFondo
         FROM FAI_FONDOS_DETALLE_POLIZA
        WHERE CodCia        = nCodCia
          AND CodEmpresa    = nCodEmpresa
          AND IdPoliza      = nIdPoliza
          AND IDetPol       = nIDetPol
          AND CodAsegurado  = nCodAsegurado
          AND GT_FAI_TIPOS_DE_FONDOS.INDICADORES(CodCia, CodEmpresa, TipoFondo, 'EPP') = cFondoPagoPrimas
        ORDER BY IdFondo;
    CURSOR CONCEN_Q IS
       SELECT IdFondo, IdMovimiento, CodCptoMov, MontoMovMoneda
         FROM FAI_CONCENTRADORA_FONDO
        WHERE CodCia        = nCodCia
          AND CodEmpresa    = nCodEmpresa
          AND IdPoliza      = nIdPoliza
          AND IDetPol       = nIDetPol
          AND CodAsegurado  = nCodAsegurado
          AND IdFondo       = nIdFondo
          AND StsMovimiento = 'SOLICI'
          AND GT_FAI_MOVIMIENTOS_FONDOS.TIPO_MOVIMIENTO(CodCia, CodEmpresa, cTipoFondo, CodCptoMov) IN ('AA','AP');
    BEGIN
       BEGIN
          SELECT F.CodCia, F.Saldo_Moneda, F.Saldo_Local, F.Monto_Fact_Moneda,
                 DP.CodEmpresa, F.Cod_Moneda, F.CodCliente, DP.IdPoliza, F.CodCobrador,
                 DP.IDetPol, F.IdEndoso, DP.Cod_Asegurado, F.NumCuota, DP.PorcComis,
                 DP.IdTipoSeg, DP.IndFactElectronica, DP.CodPlanPago, DP.PlanCob,
                 F.IndContabilizada
            INTO nCodCia, nSldoFactM, nSldoFactL, nMonto_Fact_Moneda,
                 nCodEmpresa, cCodMoneda, nCodCliente, nIdPoliza, nCodCobrador,
                 nIDetPol, nIdEndoso, nCodAsegurado, nNumCuota, nPorcComis,
                 cIdTipoSeg, cIndFactElectronica, cCodPlanPago, cPlanCob,
                 cIndContabilizada
            FROM FACTURAS F, DETALLE_POLIZA DP
           WHERE DP.IdPoliza = F.IdPoliza
             AND DP.IDetPol  = F.IDetPol
             AND F.IdFactura = nIdFactura;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RETURN(2);
       END;

       BEGIN
          SELECT Cod_Agente
            INTO nCod_Agente
            FROM AGENTES_DETALLES_POLIZAS
           WHERE IdPoliza      = nIdPoliza
             AND IdetPol       = nIDetPol
             AND IdTipoSeg     = cIdTipoSeg
             AND Ind_Principal = 'S';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'No Existe un Agente Definido para el Tipo de Seguro '||cIdTipoSeg);
          WHEN TOO_MANY_ROWS THEN
             RAISE_APPLICATION_ERROR (-20100,'Existen Varios Agentes Definidos como Principal');
          WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR (-20100,'Existe un Error NO Definido de Cobranza de Factura con Fondos');
       END;

       SELECT COUNT(*)
         INTO nExisteRecPrevio
         FROM FACTURAS
        WHERE CodCia     = nCodCia
          AND IdPoliza   = nIdPoliza
          AND IDetPol    = nIDetPol
          AND IdEndoso   = nIdEndoso
          AND IdFactura  < nIdFactura
          AND StsFact    = 'EMI';

       IF NVL(nExisteRecPrevio,0) > 0 THEN
          RAISE_APPLICATION_ERROR (-20100,'Existen Factura Anteriores Pendientes de Pago.  NO puede Realizar la Cobranza de la Factura No. '||nIdFactura);
       END IF;

       IF NVL(nMontoPago,0) < (NVL(nSldoFactM,0) + NVL(nMontoPrimaCompMoneda,0) + NVL(nMontoAporteFondo,0)) THEN
          RAISE_APPLICATION_ERROR (-20100,'Para Pólizas con Manejo de Fondos, debe Cubrir Completo el Pago.  ' ||
                                   ' NO puede Realizar la Cobranza de la Factura No. '||nIdFactura);
       END IF;

       BEGIN
          SELECT CodTipoDoc
            INTO nCodTipoDoc
            FROM TIPO_DE_DOCUMENTO
           WHERE CodClase = 'F'
             AND Sugerido = 'S';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             nCodTipoDoc := NULL;
       END;

       -- Se aplica retiro al fondo de pago de primas y se contabiliza.
       nTasaCambioMov       := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(dFecPago));
       cFondoPagoPrimas     := 'S';
       nIdTransaccionRetiro := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'RETPP');
       nMontoMovMoneda      := nMontoPrimaCompMoneda;
       FOR W IN FOND_Q LOOP
          cCodCptoMov := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, W.TipoFondo, 'RPP');
          OC_DETALLE_TRANSACCION.CREA(nIdTransaccionRetiro, nCodCia, nCodEmpresa,  21, 'RETPP', 'FAI_CONCENTRADORA_FONDO',
                                      nIdPoliza, nIDetPol, W.IdFondo, cCodCptoMov, NVL(nMontoMovMoneda,0));
          nMontoMovLocal    := NVL(nMontoMovMoneda,0) * nTasaCambioMov;
          GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                               nCodAsegurado, W.IdFondo, cCodCptoMov,
                                                               nIdTransaccionRetiro, cCodMoneda, nMontoMovMoneda, nMontoMovLocal,
                                                               'D', nTasaCambioMov, TRUNC(dFecPago), TRUNC(dFecPago),
                                                               OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, cCodCptoMov));
          GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                        nCodAsegurado, W.IdFondo, nIdTransaccionRetiro);
          GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOV_INFORMATIVOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                             nCodAsegurado, W.IdFondo, nIdTransaccionRetiro);
          OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccionRetiro, 'C');
       END LOOP;

       -- Se realiza el Cobro de la Factura con Prima en Depósito, se agregan Primas en Deposito para el saldo de la factura menos prima complementaria
       IF cFormPago != 'PRD' THEN
          cObservaciones    := 'Primas para Pago en Póliza con Fondos de Ahorro de Factura No. ' || nIdFactura || ' con Valor de ' || NVL(nMonto_Fact_Moneda,0);
          nIdPrimaDeposito  := OC_PRIMAS_DEPOSITO.INSERTAR(nCodCliente, NVL(nSldoFactM,0), cCodMoneda,
                                                           cObservaciones, nIdPoliza, nIDetPol);
          OC_PRIMAS_DEPOSITO.EMITIR(nCodCia, nCodEmpresa, nIdPrimaDeposito, dFecPago, cNumReciboPago);
       ELSE
          SELECT MAX(NumPolUnico)
            INTO cNumPolUnico
            FROM POLIZAS
           WHERE CodCia    = nCodCia
             AND IdPoliza  = nIdPoliza;

          SELECT NVL(MAX(IdPoliza),0)
            INTO nIdPolizaAnu
            FROM POLIZAS
           WHERE CodCia       = nCodCia
             AND IdPoliza     < nIdPoliza
             AND MotivAnul    = 'REEX'
             AND StsPoliza    = 'ANU'
             AND NumPolUnico  = cNumPolUnico;

          IF NVL(nIdPolizaAnu,0) = 0 THEN
             RAISE_APPLICATION_ERROR (-20100, 'Solo puede Realizar Cobranza con Primas en Depósito por Reexpedición de Póliza '||
                                              ' y NO existe una Póliza Anulada con el No. '                                    || cNumPolUnico);
          ELSE
             SELECT NVL(MIN(IdPrimaDeposito),0)
               INTO nIdPrimaDeposito
               FROM PRIMAS_DEPOSITO
              WHERE CodCliente    = nCodCliente
                AND IdPoliza      = nIdPolizaAnu
                AND Cod_Moneda    = cCodMoneda
                AND Saldo_Moneda >= nSldoFactM
                AND Estado        = 'PAF'; -- Por Aplicar en Fondo;

             IF NVL(nIdPrimaDeposito,0) = 0 THEN
                RAISE_APPLICATION_ERROR (-20100, 'No Existe Primas en Depósito Con Saldo en Póliza Anulada No. '|| nIdPolizaAnu ||
                                                 ' y No. de Póliza Unico '                                      || cNumPolUnico ||
                                                 ' por un Monto Mayor o Igual al Saldo de la Factura de '       || nSldoFactM);
             END IF;
          END IF;
       END IF;

       nIdTransaccionMov  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 12, 'PAG');
       OC_FACTURAS.PAGAR_CON_PRIMA_DEPOSITO(nIdFactura, nIdPrimaDeposito, cNumReciboPago,
                                            TRUNC(SYSDATE), NULL, nIdTransaccionMov);
       BEGIN
          SELECT MAX(IdRecibo)
            INTO nIdRecibo
            FROM PAGOS
           WHERE CodCia    = nCodCia
             AND IdFactura = nIdFactura;
       END;
       -- Genera detalle de Prima en Deposito por el monto del recibo menos monto de retiro
       OC_DETALLE_PRIMAS_DEPOSITO.INSERTAR(nCodCliente, nIdRecibo, nIdPrimaDeposito,
                                           nIdFactura, nIdPoliza, (nSldoFactM + nMontoPrimaCompMoneda), 'PAT');
       FOR W IN FOND_Q LOOP
          -- Genera detalle de Prima en Deposito por el monto de retiro disrtibuido por cada fondo para pago de primas
          nSaldoPorAplicar := ABS(nMontoPrimaCompMoneda * (W.PorcFondo / 100));
          OC_DETALLE_PRIMAS_DEPOSITO.INSERTAR(nCodCliente, nIdRecibo, nIdPrimaDeposito,
                                           nIdFactura, nIdPoliza, nSaldoPorAplicar, 'PAT');
       END LOOP;
       OC_PRIMAS_DEPOSITO.APLICAR_FACTURA(nCodCia, nCodEmpresa, nIdPrimaDeposito,
                                          TRUNC(SYSDATE), nIdRecibo, nSldoFactM,
                                          nSldoFactM, nSldoFactM, nSldoFactM,
                                          nIdTransaccionMov);
       OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccionMov, 'C');
       --DBMS_OUTPUT.PUT_LINE(nIdTransaccionMov);

       -- se agrega movimiento de prima basica al fondo base
       cFondoPagoPrimas  := 'S';
       nIdRecibo         := NULL;
       nIdTransaccionMov := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');
       nSaldoPorAplicar  := nMonto_Fact_Moneda;
       FOR W IN FOND_Q LOOP
          IF cCobroFactura = 'N' THEN
             IF NVL(nSaldoPorAplicar,0) > 0 THEN
                nMontoMovMoneda   := NVL(nSaldoPorAplicar,0);
                cCodCptoMov       := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, W.TipoFondo, 'CP');
                OC_DETALLE_TRANSACCION.CREA(nIdTransaccionMov, nCodCia, nCodEmpresa,  21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                            nIdPoliza, nIDetPol, W.IdFondo, cCodCptoMov, NVL(nMontoMovMoneda,0));
                nMontoMovLocal    := NVL(nMontoMovMoneda,0) * nTasaCambioMov;
                GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                     nCodAsegurado, W.IdFondo, cCodCptoMov,
                                                                     nIdTransaccionMov, cCodMoneda, nMontoMovMoneda, nMontoMovLocal,
                                                                     'D', nTasaCambioMov, TRUNC(dFecPago), TRUNC(dFecPago),
                                                                     OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, cCodCptoMov));
                nSaldoPorAplicar := 0;
             END IF;
          ELSE
             nMontoMovMoneda   := NVL(nSldoFactM,0);
             cCodCptoMov       := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, W.TipoFondo, 'CP');
             nMontoMovLocal    := NVL(nMontoMovMoneda,0) * nTasaCambioMov;
             GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                  nCodAsegurado, W.IdFondo, cCodCptoMov,
                                                                  0, cCodMoneda, nMontoMovMoneda, nMontoMovLocal,
                                                                  'D', nTasaCambioMov, TRUNC(dFecPago), TRUNC(dFecPago),
                                                                  OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, cCodCptoMov));
             GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, W.IdFondo, 0);
             GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOV_INFORMATIVOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, W.IdFondo, 0);
          END IF;
       END LOOP;

       ----------------
       nSaldoPorAplicar := NVL(nMontoAporteFondo,0);
       cCobroFactura    := 'S';
       --- Si Existe Saldo para Aportes se Crea Factura de Movimientos
       IF NVL(nSaldoPorAplicar,0) > 0 THEN
          nMontoPrimaDepMon  := NVL(nSaldoPorAplicar,0);
          nMontoPrimaDepLoc  := NVL(nMontoPrimaDepMon,0) * nTasaCambioMov;
          -- Generación de Factura por Movimiento de Aportes Iniciales al Fondo
          nIdTransaccionFact := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'FACFON');

          nMtoComisiMoneda := 0;
          nMtoComisiLocal  := 0;
          nIdFacturaAportes := OC_FACTURAS.INSERTAR(nIdPoliza,               nIDetPol,                nCodCliente,    TRUNC(dFecPago),
                                                    NVL(nSaldoPorAplicar,0), NVL(nSaldoPorAplicar,0), 0,              NVL(nMtoComisiLocal,0),
                                                    NVL(nMtoComisiMoneda,0), NVL(nNumCuota,1),        nTasaCambioMov, nCod_Agente,
                                                    nCodTipoDoc,             nCodCia,                 cCodMoneda,     NULL,
                                                    nIdTransaccionFact,      cIndFactElectronica);

          IF cFormPago != 'PRD' THEN
             -- Se Crea Prima en Depósito Por la Prima Nivelada y Aportes al Fondo
             cObservaciones   := 'Primas para Aportes al Fondo de Factura No. ' || nIdFacturaAportes ||
                                 ' con un Aporte a Fondos de ' || NVL(nMontoAporteFondo,0);

             nIdPrimaDeposito   := OC_PRIMAS_DEPOSITO.INSERTAR(nCodCliente, NVL(nMontoPrimaDepMon,0), cCodMoneda,
                                                               cObservaciones, nIdPoliza, nIDetPol);
             OC_PRIMAS_DEPOSITO.EMITIR(nCodCia, nCodEmpresa, nIdPrimaDeposito, dFecPago, cNumReciboPago);
          ELSE
             SELECT NVL(MIN(IdPrimaDeposito),0), NVL(SUM(Saldo_Moneda),0), NVL(SUM(Saldo_Local),0)
               INTO nIdPrimaDeposito, nMontoPrimaDepMon, nMontoPrimaDepLoc
               FROM PRIMAS_DEPOSITO
              WHERE CodCliente    = nCodCliente
                AND IdPoliza      = nIdPoliza
                AND Cod_Moneda    = cCodMoneda
                AND Saldo_Moneda >= NVL(nMontoAporteFondo,0)
                AND Estado        = 'PAF'; -- Por Aplicar en Fondo

             IF NVL(nIdPrimaDeposito,0) = 0 THEN
                RAISE_APPLICATION_ERROR (-20100,'No Existen Primas en Depósito Con Saldo Mayor o Igual al Aporte al Fondo en Póliza No. ' || nIdPoliza );
             END IF;
          END IF;
       END IF;
       cFondoPagoPrimas  := 'N';
       nSaldoRestante    := NVL(nSaldoPorAplicar,0);
       nIdTransaccionMov := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');
       FOR W IN FOND_Q LOOP
          nIdFondo   := W.IdFondo;
          cTipoFondo := W.TipoFondo;
          IF NVL(nNumCuota,0) = 1 THEN
             FOR Y IN CONCEN_Q LOOP
                OC_DETALLE_TRANSACCION.CREA(nIdTransaccionMov, nCodCia, nCodEmpresa,  21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                            nIdPoliza, nIDetPol, Y.IdFondo, Y.CodCptoMov, NVL(Y.MontoMovMoneda,0));

                -- Se Aplica el Saldo Proporcional a los Fondos y se Actualiza el Valor de Cada Aporte Inicial
                -- Por si el Asegurado paga más en el primer pago de lo esperado.
                nMontoMovMoneda   := NVL(nSaldoRestante,0) * W.PorcFondo / 100;
                nMontoMovLocal    := NVL(nMontoMovMoneda,0) * nTasaCambioMov;

                UPDATE FAI_CONCENTRADORA_FONDO
                   SET IdTransaccion   = nIdTransaccionMov,
                       MontoMovMoneda  = nMontoMovMoneda,
                       MontoMovLocal   = nMontoMovLocal,
                       FecTasaCambio   = TRUNC(dFecPago),
                       TasaCambioMov   = nTasaCambioMov,
                       FecMovimiento   = TRUNC(dFecPago),
                       FecRealRegistro = TRUNC(dFecPago)
                 WHERE CodCia        = nCodCia
                   AND CodEmpresa    = nCodEmpresa
                   AND IdPoliza      = nIdPoliza
                   AND IDetPol       = nIDetPol
                   AND CodAsegurado  = nCodAsegurado
                   AND IdFondo       = Y.IdFondo
                   AND IdMovimiento  = Y.IdMovimiento;

                OC_DETALLE_FACTURAS.INSERTAR(nIdFacturaAportes, Y.CodCptoMov, 'S', NVL(nMontoMovLocal,0), NVL(nMontoMovMoneda,0));
                OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFacturaAportes, Y.CodCptoMov, 'S', NVL(nMontoMovLocal,0), NVL(nMontoMovMoneda,0));
                GT_FAI_CONCENTRADORA_FONDO.ACTUALIZA_FACTURA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, W.IdFondo,
                                                                         nIdTransaccionMov, nIdFacturaAportes);
             END LOOP;
          ELSE
             nMontoMovMoneda   := NVL(nSaldoRestante,0) * W.PorcFondo / 100;
             nSaldoPorAplicar  := NVL(nSaldoPorAplicar,0) - NVL(nMontoMovMoneda,0);
             IF NVL(nMontoMovMoneda,0) > 0 THEN
                cCodCptoMov       := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, W.TipoFondo, 'AA');
                nMontoMovLocal    := NVL(nMontoMovMoneda,0) * nTasaCambioMov;
                GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                     nCodAsegurado, W.IdFondo, cCodCptoMov,
                                                                     nIdTransaccionMov, cCodMoneda, nMontoMovMoneda, nMontoMovLocal,
                                                                     'D', nTasaCambioMov, TRUNC(dFecPago), TRUNC(dFecPago),
                                                                     OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, cCodCptoMov));
                OC_DETALLE_FACTURAS.INSERTAR(nIdFacturaAportes, cCodCptoMov, 'S', NVL(nMontoMovLocal,0), NVL(nMontoMovMoneda,0));
                OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFacturaAportes, cCodCptoMov, 'S', NVL(nMontoMovLocal,0), NVL(nMontoMovMoneda,0));
                GT_FAI_CONCENTRADORA_FONDO.ACTUALIZA_FACTURA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, W.IdFondo,
                                                                         nIdTransaccionMov, nIdFacturaAportes);
             END IF;
          END IF;
          GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, W.IdFondo,
                                                        nIdTransaccionMov);
          GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOV_INFORMATIVOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                             nCodAsegurado, W.IdFondo, nIdTransaccionMov);
          -- Para Movimientos que NO tienen Transacción
          GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, W.IdFondo,
                                                        0);
          GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOV_INFORMATIVOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                             nCodAsegurado, W.IdFondo, 0);
       END LOOP;

       -- Complementa Factura y su Pago
       IF NVL(nIdFacturaAportes,0) > 0 THEN
          /*OC_FACTURAR.PROC_COMISIONAG (nIdPoliza, nIDetPol, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFacturaAportes,
                                       NVL(nSaldoPorAplicar,0) * nTasaCambioMov, NVL(nSaldoPorAplicar,0), nTasaCambioMov);*/
          OC_FACTURAS.ACTUALIZA_FACTURA(nIdFacturaAportes);
          OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia, nIdFacturaAportes, 'IVASIN');
          OC_DETALLE_TRANSACCION.CREA (nIdTransaccionFact, nCodCia, nCodEmpresa, 21, 'FACFON', 'FACTURAS',
                                       nIdPoliza, nIDetPol, nIdFondo, nIdFacturaAportes, NVL(nSaldoRestante,0));
          -- Se Registra el Pago
          nIdTransaccionPag := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 12, 'PAGPRD');
          OC_FACTURAS.PAGAR_CON_PRIMA_DEPOSITO(nIdFacturaAportes, nIdPrimaDeposito, SUBSTR(cNumReciboPago,1,20), TRUNC(dFecPago),
                                               NULL, nIdTransaccionPag);
          BEGIN
             SELECT MAX(IdRecibo)
               INTO nIdRecibo
               FROM PAGOS
              WHERE CodCia    = nCodCia
                AND IdFactura = nIdFacturaAportes;
          END;
          OC_DETALLE_PRIMAS_DEPOSITO.INSERTAR(nCodCliente, nIdRecibo, nIdPrimaDeposito,
                                              nIdFacturaAportes, nIdPoliza, NVL(nSaldoRestante,0), 'PAT');

          OC_PRIMAS_DEPOSITO.APLICAR_FACTURA(nCodCia, nCodEmpresa, nIdPrimaDeposito, TRUNC(dFecPago), nIdRecibo,
                                             NVL(nSaldoRestante,0), NVL(nSaldoRestante,0) * nTasaCambioMov,
                                             NVL(nSaldoRestante,0), NVL(nSaldoRestante,0) * nTasaCambioMov, nIdTransaccionPag);
       END IF;
       OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccionMov, 'C');

       IF cFormPago IN ('CLAB','CTC','DOMI','LIN') AND OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(nCodCia, nIdPoliza, nIDetPol, nCodAsegurado) = 'N' THEN
          IF OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(nCodCia, nCodEmpresa, cIdTipoSeg) = 'S' THEN
             NOTIFICACOBRANZAOK(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdFactura);
          END IF;
       END IF;
       RETURN(1);
    END PAGAR_ALTURA_CERO;
    --
    FUNCTION FACTURA_ELECTRONICA_SAT40(P_CODCIA    NUMBER,
                                       PIDFACTURA  NUMBER,
                                       PIDNCR      NUMBER,
                                       P_CVE_MOTIVCANCFACT VARCHAR2,
                                       P_IdTimbre  OUT NUMBER) RETURN VARCHAR2 IS    
            --
            --P_CODCIA     NUMBER := 1;
            --P_IDFACTURA  NUMBER := 318981;
            --P_IDNCR      NUMBER := 0;
            --P_CVE_MOTIVCANCFACT VARCHAR2(10) := '01';
            --    
            cLin                VARCHAR2(32767);
            cResultado          VARCHAR2(32767);
            cCVE_MOTIVCANCFACT  VARCHAR2(30);
            P_IDFACTURA NUMBER := PIDFACTURA;
            P_IDNCR     NUMBER := PIDNCR;
                                       
            --RESPUESTA
            cCodigoResp         VARCHAR2(100);
            cDescResp           VARCHAR2(1000);
            cFechaResp          DATE;
            nIdTimbre           NUMBER;            
            --
        BEGIN
            -- VALIDACION    
            IF NVL(P_IDFACTURA, 0) = 0           THEN P_IDFACTURA := NULL; END IF;
            IF NVL(P_IDNCR, 0) = 0               THEN P_IDNCR     := NULL; END IF;
            IF P_IDNCR IS NULL AND P_IDFACTURA IS NULL THEN 
                RAISE_APPLICATION_ERROR(-20200,'El numero de IDFACTURA o de IDNCR no es válido: '||P_IDNCR ||P_IDFACTURA);
            END IF;

            BEGIN        
                SELECT CVEMOTIVCANCFACT 
                  INTO cCVE_MOTIVCANCFACT
                  FROM FACT_ELECT_MOTIVO_CANCELA M
                 WHERE M.CODCIA = P_CODCIA
                   AND M.CVEMOTIVCANCFACT = P_CVE_MOTIVCANCFACT;
            EXCEPTION WHEN OTHERS THEN
                 RAISE_APPLICATION_ERROR(-20200,'No existe el motivo de cancelación del CFDI o no es válido: '||P_CVE_MOTIVCANCFACT);
            END;
                    
            --
            IF P_CVE_MOTIVCANCFACT = '01' THEN
                    -- EXTRAE LOS RECIBOS ANULADOS Y EMITIDOS QUE HACEN MATCH
                    FOR ENT IN (SELECT DISTINCT P.CODCIA,
                                       P.CODEMPRESA,
                                       P.IDPOLIZA,
                                       D.IDETPOL,
                                       NVL((SELECT CASE WHEN F2.IDENDOSO > 0 THEN F2.IDENDOSO ELSE MAX(IDENDOSO) END FROM ENDOSOS E1 WHERE E1.CODCIA     = P.CODCIA
                                                                                           AND E1.CODEMPRESA = P.CODEMPRESA
                                                                                           AND E1.IDPOLIZA   = P.IDPOLIZA
                                                                                           AND E1.IDETPOL    = D.IDETPOL
                                                                                           AND TRUNC(E1.FECEMISION) = TRUNC(F2.FECSTS)                                            
                                                                                           AND E1.STSENDOSO  = 'EMI'), F2.IDENDOSO) IDENDOSO,
                                       F2.IDENDOSO    IDENDOSO_EMI,             
                                       F.IDENDOSO     IDENDOSO_ANU,
                                       F2.FECVENC     INICIO_ANU,
                                       F2.FECFINVIG   FINAL_ANU,     
                                       F2.IDFACTURA   IDFACTURA_EMITIDA,
                                       F2.STSFACT     STSEMI,
                                       TEMI.UUID      UUID_SUSTITUYE,
                                       TEMI.CODPROCESO,   
                                       F.IDFACTURA    IDFACTURA_ANULAR,
                                       F.STSFACT      STSANU,
                                       NVL(P_CVE_MOTIVCANCFACT, NVL(F.CVE_MOTIVCANCFACT, E.CVE_MOTIVCANCFACT)) CVE_MOTIVCANCFACT,
                                       TANU.UUID      UUID_CANCELAR,
                                       NULL           IdNcr_ANULAR         
                                  FROM polizas p INNER JOIN DETALLE_POLIZA D                ON D.CODCIA         = P.CODCIA
                                                                                           AND D.CODEMPRESA     = P.CODEMPRESA 
                                                                                           AND D.IDPOLIZA       = P.IDPOLIZA
                                                 INNER JOIN ENDOSOS        E                ON E.CODCIA     = P.CODCIA
                                                                                           AND E.CODEMPRESA = P.CODEMPRESA
                                                                                           AND E.IDPOLIZA   = P.IDPOLIZA
                                                                                           AND E.IDETPOL    = D.IDETPOL                                            
                                                                                           AND E.STSENDOSO  = 'EMI'
                                                 -- FACTURAS EMITIDA QUE REMPLAZAA LA ANULADA Y ESTA YA TIMBRADA                                                           
                                                 INNER JOIN FACTURAS      F2                ON P.CODCIA     = F2.CODCIA 
                                                                                           AND P.IDPOLIZA   = F2.IDPOLIZA 
                                                                                           AND D.IDETPOL    = F2.IDETPOL
                                                                                           AND F2.IDENDOSO  IN (E.IDENDOSO, 0)  
                                                                                           AND F2.STSFACT IN ('EMI') 
                                                                                           AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO(P.CODCIA ,P.CODEMPRESA, F2.IDFACTURA,'', F2.STSFACT) = 'S'                                                           
                                                 INNER JOIN FACT_ELECT_DETALLE_TIMBRE TEMI  ON TEMI.CODCIA     = P.CODCIA
                                                                                           AND TEMI.CODEMPRESA = P.CODEMPRESA
                                                                                           AND TEMI.IDFACTURA  = F2.IDFACTURA 
                                                                                           AND TEMI.IDNCR      = 0
                                                                                           AND TEMI.UUID IS NOT NULL     
                                                                                           AND TEMI.CODPROCESO = F2.STSFACT  
                                                                                           AND TEMI.UUIDCANCELADO IS  NULL                                                 
                                                 -- FACTURAS QUE NO HAN SIDO TIMBRADAS (PERO YA ESTAN ANULADAS)                                                           
                                                 INNER JOIN FACTURAS       F                ON F.CODCIA         = P.CODCIA 
                                                                                           AND F.IDPOLIZA       = P.IDPOLIZA 
                                                                                           AND F.IDETPOL        = D.IDETPOL 
                                                                                           AND F.STSFACT        = 'ANU'
                                                                                           AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO(P.CODCIA ,P.CODEMPRESA, F.IDFACTURA,'', 'CAN') = 'N'
                                                 INNER JOIN FACT_ELECT_DETALLE_TIMBRE TANU  ON TANU.CODCIA     = P.CODCIA
                                                                                           AND TANU.CODEMPRESA = P.CODEMPRESA
                                                                                           AND TANU.IDFACTURA  = F.IDFACTURA 
                                                                                           AND TANU.IDNCR      = 0
                                                                                           AND TANU.UUID IS NOT NULL     
                                                                                           AND TANU.CODPROCESO = 'EMI'  
                                                                                           AND TANU.CODRESPUESTASAT = '201'
                                                                                           AND TANU.UUIDCANCELADO IS NULL                                                 
                                WHERE F2.CODCIA = P_CODCIA AND   
                                      F2.IDFACTURA = P_IDFACTURA AND
                                      F.FECVENC  = NVL(F2.FECVENC, TRUNC(SYSDATE))   AND
                                      F.FECFINVIG= NVL(F2.FECFINVIG, TRUNC(SYSDATE))) LOOP

                            cLin := GT_WEB_SERVICES.Ejecuta_WS(1,1,4000, -4000, cResultado,':nCodCia='  || 1 || 
                                                                                    ',:Wuuid='   || '¨' || ENT.UUID_CANCELAR     || '¨' ||
                                                                                    ',:Wmotivo=' || '¨' || ENT.CVE_MOTIVCANCFACT || '¨' ||
                                                                                    ',:WuuNuevo='|| '¨' || ENT.UUID_SUSTITUYE    || '¨' 
                                                                      ).getClobVal;     
                            --                                        
                            --dbms_output.put_line('Respuesta-->Codigo: ' || GT_WEB_SERVICES.ExtraStr ('codigo xsi:type="xsd:string"', cLin) || '-' ||
                            --                         'Descripcion: ' || GT_WEB_SERVICES.ExtraStr('descripcion xsi:type="xsd:string"', cLin)    || '-' ||                                                                
                            --                         'Fecha: ' || GT_WEB_SERVICES.ExtraStr('fecha xsi:type="xsd:string"', cLin));
                            --
                            cCodigoResp:= GT_WEB_SERVICES.ExtraStr('codigo xsi:type="xsd:string"',      cLin);
                            cDescResp  := GT_WEB_SERVICES.ExtraStr('descripcion xsi:type="xsd:string"', cLin);
                            cFechaResp := to_date(GT_WEB_SERVICES.ExtraStr('fecha xsi:type="xsd:string"',       cLin), 'YYYY-MM-DD HH24:MI:SS');
                            --
                            UPDATE FACTURAS S SET S.CVE_MOTIVCANCFACT = NVL(S.CVE_MOTIVCANCFACT, P_CVE_MOTIVCANCFACT)                                                                                                    
                            WHERE S.CODCIA    = ENT.CODCIA
                              AND S.IDFACTURA = ENT.IDFACTURA_ANULAR;
                            -- 
                            UPDATE FACTURAS S SET S.IDENDOSO = ENT.IDENDOSO
                            WHERE S.CODCIA    = ENT.CODCIA
                              AND S.IDFACTURA = ENT.IDFACTURA_EMITIDA
                              AND S.IDENDOSO  = ENT.IDENDOSO_EMI;
                            --
                            --ACTUALIZAR LA FACTURA CON LOS DATOS DE LA FACTURA CANCELADA EN SUSTITUCION
                            UPDATE FACT_ELECT_DETALLE_TIMBRE T SET T.CVE_MOTIVCANCFACT = P_CVE_MOTIVCANCFACT,
                                                                   T.UUIDRELACIONADO   = ENT.UUID_CANCELAR
                            WHERE T.UUID = ENT.UUID_SUSTITUYE;
                            --
                            -- INSERTA EL CFDI ANULADO
                            OC_FACT_ELECT_DETALLE_TIMBRE.INSERTA_DETALLE(ENT.CODCIA, 
                                                                         ENT.CODEMPRESA, 
                                                                         ENT.IDFACTURA_ANULAR,
                                                                         ENT.IdNcr_ANULAR, 
                                                                         'CAN', 
                                                                         null,
                                                                         TRUNC(SYSDATE), 
                                                                         null,
                                                                         null,
                                                                         CASE WHEN cCodigoResp IN ('201','2001') THEN '201' ELSE '501' END,
                                                                         ENT.UUID_CANCELAR,
                                                                         NULL, --cCve_MotivCancFact,                                                                 
                                                                         nIdTimbre,
                                                                         ENT.UUID_SUSTITUYE, --ENT.UUID_SUSTITUYE,
                                                                         cCodigoResp,
                                                                         cDescResp,
                                                                         nvl(cFechaResp, sysdate)
                                                                         );
                            --                       
                            OC_FACT_ELECT_CONF_DOCTO.ENVIA_CORREO(ENT.CodCia, ENT.CodEmpresa,ENT.IDFACTURA_ANULAR,PIDNCR,'CAN',cCodigoResp,cDescResp,ENT.UUID_CANCELAR);
                            --
                       END LOOP;
                       --
                ELSE
                    FOR ENT IN (SELECT F.CODCIA,
                                       T.CODEMPRESA,
                                       P_IDFACTURA IDFACTURA_ANULAR,
                                       NULL        IDNCR_ANULAR,
                                       T.UUID      UUID_CANCELAR,
                                       NVL(P_CVE_MOTIVCANCFACT, F.CVE_MOTIVCANCFACT) CVE_MOTIVCANCFACT
                                  FROM FACTURAS F INNER JOIN FACT_ELECT_DETALLE_TIMBRE T ON T.CODCIA = F.CODCIA
                                                                                        AND T.CODEMPRESA = 1
                                                                                        AND T.IDFACTURA = P_IDFACTURA 
                                                                                        AND T.CODPROCESO IN ('EMI','PAG')
                                                                                        AND T.CODRESPUESTASAT = '201'
                                 WHERE F.CODCIA    = P_CODCIA
                                   AND F.IDFACTURA = P_IDFACTURA
                                ) LOOP               
                        --                                
                        cLin := GT_WEB_SERVICES.Ejecuta_WS(1,1,4000, -4000, cResultado,':nCodCia='  || 1 || 
                                                                ',:Wuuid='   || '¨' || ENT.UUID_CANCELAR     || '¨' ||
                                                                ',:Wmotivo=' || '¨' || ENT.CVE_MOTIVCANCFACT || '¨' ||
                                                                ',:WuuNuevo='|| '¨' || NULL    || '¨' 
                                                  ).getClobVal;           
                        --                                          
                        --dbms_output.put_line('Respuesta-->Codigo: ' || GT_WEB_SERVICES.ExtraStr ('codigo xsi:type="xsd:string"', cLin) || '-' ||
                        --                         'Descripcion: ' || GT_WEB_SERVICES.ExtraStr('descripcion xsi:type="xsd:string"', cLin)    || '-' ||                                                                
                        --                         'Fecha: ' || GT_WEB_SERVICES.ExtraStr('fecha xsi:type="xsd:string"', cLin));
                        --
                        cCodigoResp:= GT_WEB_SERVICES.ExtraStr('codigo xsi:type="xsd:string"',      cLin);
                        cDescResp  := GT_WEB_SERVICES.ExtraStr('descripcion xsi:type="xsd:string"', cLin);
                        cFechaResp := to_date(GT_WEB_SERVICES.ExtraStr('fecha xsi:type="xsd:string"',       cLin), 'YYYY-MM-DD HH24:MI:SS');                
                        --                
                        UPDATE FACTURAS S SET S.CVE_MOTIVCANCFACT = cCve_MotivCancFact
                        WHERE S.CODCIA    = ENT.CODCIA
                          AND S.IDFACTURA = ENT.IDFACTURA_ANULAR;
                        --
                        OC_FACT_ELECT_DETALLE_TIMBRE.INSERTA_DETALLE(ENT.CODCIA, 
                                                                     ENT.CODEMPRESA, 
                                                                     ENT.IDFACTURA_ANULAR,
                                                                     ENT.IdNcr_ANULAR, 
                                                                     'CAN', 
                                                                     null,
                                                                     TRUNC(SYSDATE), 
                                                                     null,
                                                                     null,
                                                                     CASE WHEN cCodigoResp IN ('201','2001') THEN '201' ELSE '501' END,
                                                                     ENT.UUID_CANCELAR,
                                                                     ENT.CVE_MOTIVCANCFACT,                                                                 
                                                                     nIdTimbre,
                                                                     NULL,
                                                                     cCodigoResp,
                                                                     cDescResp,
                                                                     nvl(cFechaResp, sysdate)
                                                                     );

                            --                       
                            OC_FACT_ELECT_CONF_DOCTO.ENVIA_CORREO(ENT.CodCia, ENT.CodEmpresa, ENT.IDFACTURA_ANULAR, PIDNCR,'CAN', cCodigoResp, cDescResp, ENT.UUID_CANCELAR);
                            --

                    END LOOP;
                    --                          
               END IF;
            --
            dbms_output.put_line('nIdTimbre: ' || nIdTimbre );        
            P_IdTimbre := nIdTimbre;
            --
            cCodigoResp := CASE WHEN cCodigoResp IN ('201','2001') THEN '201' ELSE '501' END;
             
            RETURN cCodigoResp;

    EXCEPTION WHEN OTHERS THEN
                OC_FACT_ELECT_CONF_DOCTO.ENVIA_CORREO(1, 1, P_IDNCR || P_IDFACTURA, PIDNCR,'CAN', '501', '<<Error en la cancelacion del CFDI del Recibo o NCR No.: '|| P_IDNCR || P_IDFACTURA || ', motivo cancelación: ' || P_CVE_MOTIVCANCFACT || '>>' || chr(10), sqlerrm);
               RETURN '<<Error en la cancelacion del CFDI del Recibo o NCR No.: '|| P_IDNCR || P_IDFACTURA || ', motivo cancelación: ' || P_CVE_MOTIVCANCFACT || '>>' || chr(10) || sqlerrm;    
    END FACTURA_ELECTRONICA_SAT40;
    --
    FUNCTION FACTURA_RELACIONADA_UUID_CANC(P_CODCIA     NUMBER,                                       
                                        PIDFACTURA   NUMBER) RETURN VARCHAR2 IS 
        Relacion VARCHAR2(32700);
    BEGIN
        FOR ENT IN (  
        SELECT DISTINCT TANU.UUID      UUID_CANCELAR          
                  FROM polizas p INNER JOIN DETALLE_POLIZA D                ON D.CODCIA         = P.CODCIA
                                                                           AND D.CODEMPRESA     = P.CODEMPRESA 
                                                                           AND D.IDPOLIZA       = P.IDPOLIZA
                                 INNER JOIN ENDOSOS        E                ON E.CODCIA     = P.CODCIA
                                                                           AND E.CODEMPRESA = P.CODEMPRESA
                                                                           AND E.IDPOLIZA   = P.IDPOLIZA
                                                                           AND E.IDETPOL    = D.IDETPOL                                            
                                                                           AND E.STSENDOSO  = 'EMI'
                                 -- FACTURAS EMITIDA QUE REMPLAZAA LA ANULADA Y ESTA YA TIMBRADA                                                           
                                 INNER JOIN FACTURAS      F2                ON P.CODCIA     = F2.CODCIA 
                                                                           AND P.IDPOLIZA   = F2.IDPOLIZA 
                                                                           AND D.IDETPOL    = F2.IDETPOL
                                                                           AND F2.IDENDOSO  IN(E.IDENDOSO, 0)  
                                                                           AND F2.STSFACT IN ('EMI') 
                                                                           AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO(P.CODCIA ,P.CODEMPRESA, F2.IDFACTURA,'', F2.STSFACT) = 'N'                                                           
                                 -- FACTURAS QUE NO HAN SIDO TIMBRADAS (PERO YA ESTAN ANULADAS)                                                           
                                 INNER JOIN FACTURAS       F3                ON F3.CODCIA         = P.CODCIA 
                                                                           AND F3.IDPOLIZA       = P.IDPOLIZA 
                                                                           AND F3.IDETPOL        = D.IDETPOL 
                                                                           AND F3.STSFACT        = 'ANU'
                                                                           AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO(P.CODCIA ,P.CODEMPRESA, F3.IDFACTURA,'', 'CAN') = 'N'
                                 INNER JOIN FACT_ELECT_DETALLE_TIMBRE TANU  ON TANU.CODCIA     = P.CODCIA
                                                                           AND TANU.CODEMPRESA = P.CODEMPRESA
                                                                           AND TANU.IDFACTURA  = F3.IDFACTURA 
                                                                           AND TANU.IDNCR      = 0
                                                                           AND TANU.UUID IS NOT NULL     
                                                                           AND TANU.CODPROCESO = 'EMI'  
                                                                           AND TANU.CODRESPUESTASAT = '201'
                                                                           AND TANU.UUIDCANCELADO IS NULL                                                 
                 WHERE F2.CODCIA = P_CODCIA AND                                          
                       (F2.IDFACTURA = PIDFACTURA OR                                    
                       F3.IDFACTURA = PIDFACTURA ) AND 
                       F3.FECVENC  = NVL(F2.FECVENC, TRUNC(SYSDATE)) AND
                       F3.FECFINVIG= NVL(F2.FECFINVIG, TRUNC(SYSDATE))) LOOP
            --                       
            IF LENGTH(Relacion) > 0 THEN Relacion := Relacion || CHR(10) || 'CREL|||UUID|'; END IF;                       
            Relacion := Relacion || ENT.UUID_CANCELAR;                                              
        END LOOP;                      
        RETURN Relacion;
                                   
    EXCEPTION WHEN OTHERS THEN
        RETURN NULL;                           
    END FACTURA_RELACIONADA_UUID_CANC;
    --
    FUNCTION FACTURA_RELACIONADA_ENDOSO(P_CODCIA     NUMBER,                                       
                                        PIDFACTURA   NUMBER) RETURN VARCHAR2 IS 
        Relacion VARCHAR2(10);
        Respuesta VARCHAR2(1);
    BEGIN
        SELECT NVL(MAX(1), 0)
          INTO Relacion         
                  FROM polizas p INNER JOIN DETALLE_POLIZA D                ON D.CODCIA         = P.CODCIA
                                                                           AND D.CODEMPRESA     = P.CODEMPRESA 
                                                                           AND D.IDPOLIZA       = P.IDPOLIZA
                                 INNER JOIN ENDOSOS        E                ON E.CODCIA     = P.CODCIA
                                                                           AND E.CODEMPRESA = P.CODEMPRESA
                                                                           AND E.IDPOLIZA   = P.IDPOLIZA
                                                                           AND E.IDETPOL    = D.IDETPOL                                            
                                                                           AND E.STSENDOSO  = 'EMI'
                                 -- FACTURAS EMITIDA QUE REMPLAZAA LA ANULADA Y ESTA YA TIMBRADA                                                           
                                 INNER JOIN FACTURAS      F2                ON P.CODCIA     = F2.CODCIA 
                                                                           AND P.IDPOLIZA   = F2.IDPOLIZA 
                                                                           AND D.IDETPOL    = F2.IDETPOL
                                                                           AND F2.IDENDOSO  IN(E.IDENDOSO, 0)  
                                                                           AND F2.STSFACT IN ('EMI') 
                                                                           AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO(P.CODCIA ,P.CODEMPRESA, F2.IDFACTURA,'', F2.STSFACT) = 'N'                                                           
                                 -- FACTURAS QUE NO HAN SIDO TIMBRADAS (PERO YA ESTAN ANULADAS)                                                           
                                 INNER JOIN FACTURAS       F3                ON F3.CODCIA         = P.CODCIA 
                                                                           AND F3.IDPOLIZA       = P.IDPOLIZA 
                                                                           AND F3.IDETPOL        = D.IDETPOL 
                                                                           AND F3.STSFACT        = 'ANU'
                                                                           AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO(P.CODCIA ,P.CODEMPRESA, F3.IDFACTURA,'', 'CAN') = 'N'
                                 INNER JOIN FACT_ELECT_DETALLE_TIMBRE TANU  ON TANU.CODCIA     = P.CODCIA
                                                                           AND TANU.CODEMPRESA = P.CODEMPRESA
                                                                           AND TANU.IDFACTURA  = F3.IDFACTURA 
                                                                           AND TANU.IDNCR      = 0
                                                                           AND TANU.UUID IS NOT NULL     
                                                                           AND TANU.CODPROCESO = 'EMI'  
                                                                           AND TANU.CODRESPUESTASAT = '201'
                                                                           AND TANU.UUIDCANCELADO IS NULL                                                 
                 WHERE F2.CODCIA = P_CODCIA AND                                          
                       (F2.IDFACTURA = PIDFACTURA OR                                    
                       F3.IDFACTURA = PIDFACTURA ) AND 
                       F3.FECVENC  = NVL(F2.FECVENC, TRUNC(SYSDATE)) AND
                       F3.FECFINVIG= NVL(F2.FECFINVIG, TRUNC(SYSDATE));
        IF Relacion = 1 THEN
            RESPUESTA :='S';
        ELSE
            RESPUESTA :='N';
        END IF;
            RETURN RESPUESTA;                           
    EXCEPTION WHEN OTHERS THEN
        RETURN 'N';                           
    END FACTURA_RELACIONADA_ENDOSO;    
    --        
    FUNCTION FACTURA_RELACIONADA(P_CODCIA     NUMBER,                                       
                                 PIDFACTURA   NUMBER) RETURN NUMBER IS         
        nIDFACTURA NUMBER;
    BEGIN
          
        SELECT DISTINCT CASE WHEN PIDFACTURA = F2.IDFACTURA THEN F3.IDFACTURA ELSE F2.IDFACTURA END 
          INTO NIDFACTURA          
                  FROM polizas p INNER JOIN DETALLE_POLIZA D                ON D.CODCIA         = P.CODCIA
                                                                           AND D.CODEMPRESA     = P.CODEMPRESA 
                                                                           AND D.IDPOLIZA       = P.IDPOLIZA
                                 INNER JOIN ENDOSOS        E                ON E.CODCIA     = P.CODCIA
                                                                           AND E.CODEMPRESA = P.CODEMPRESA
                                                                           AND E.IDPOLIZA   = P.IDPOLIZA
                                                                           AND E.IDETPOL    = D.IDETPOL                                            
                                                                           AND E.STSENDOSO  = 'EMI'
                                 -- FACTURAS EMITIDA QUE REMPLAZAA LA ANULADA                                                            
                                 INNER JOIN FACTURAS      F2                ON P.CODCIA     = F2.CODCIA 
                                                                           AND P.IDPOLIZA   = F2.IDPOLIZA 
                                                                           AND D.IDETPOL    = F2.IDETPOL
                                                                           AND F2.IDENDOSO  IN(E.IDENDOSO, 0)  
                                                                           AND F2.STSFACT IN ('EMI')                                                                                                                                       
                                 -- FACTURAS QUE NO HAN SIDO TIMBRADAS (PERO YA ESTAN ANULADAS)                                                           
                                 INNER JOIN FACTURAS       F3                ON F3.CODCIA         = P.CODCIA 
                                                                           AND F3.IDPOLIZA       = P.IDPOLIZA 
                                                                           AND F3.IDETPOL        = D.IDETPOL 
                                                                           AND F3.STSFACT        = 'ANU'
                                                                           --AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO(P.CODCIA ,P.CODEMPRESA, F3.IDFACTURA,'', 'CAN') = 'N'
                                 INNER JOIN FACT_ELECT_DETALLE_TIMBRE TANU  ON TANU.CODCIA     = P.CODCIA
                                                                           AND TANU.CODEMPRESA = P.CODEMPRESA
                                                                           AND TANU.IDFACTURA  = F3.IDFACTURA 
                                                                           AND TANU.IDNCR      = 0
                                                                           AND TANU.UUID IS NOT NULL     
                                                                           AND TANU.CODPROCESO = 'EMI'  
                                                                           AND TANU.CODRESPUESTASAT = '201'
                                                                           AND TANU.UUIDCANCELADO IS NULL                                                 
                 WHERE F2.CODCIA = P_CODCIA AND                                          
                       (F2.IDFACTURA = PIDFACTURA OR                                    
                       F3.IDFACTURA = PIDFACTURA ) AND 
                       F3.FECVENC  = NVL(F2.FECVENC, TRUNC(SYSDATE)) AND
                       F3.FECFINVIG= NVL(F2.FECFINVIG, TRUNC(SYSDATE)) AND
                       ROWNUM = 1;
            --                       
                     
        RETURN NIDFACTURA;
                                   
    EXCEPTION WHEN OTHERS THEN
        RETURN NULL;                           
    END FACTURA_RELACIONADA;
    --
END OC_FACTURAS;
/
--
-- OC_FACTURAS  (Synonym) 
--
--  Dependencies: 
--   OC_FACTURAS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_FACTURAS FOR SICAS_OC.OC_FACTURAS
/


GRANT EXECUTE ON SICAS_OC.OC_FACTURAS TO PUBLIC
/

--
-- OC_PRIMAS_DEPOSITO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   DBMS_STANDARD (Package)
--   PRIMAS_DEPOSITO (Table)
--   OC_DETALLE_TRANSACCION (Package)
--   TRANSACCION (Table)
--   SQ_PRIMAS_DEPOSITO (Sequence)
--   OC_TRANSACCION (Package)
--   OC_COMPROBANTES_CONTABLES (Package)
--   OC_GENERALES (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_PRIMAS_DEPOSITO IS

FUNCTION CORRELATIVO RETURN NUMBER;

FUNCTION INSERTAR(nCodCliente NUMBER, nMontoTarjeta NUMBER, cCodMoneda VARCHAR2, 
                  cObservaciones LONG, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER;

PROCEDURE EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPrimaDeposito NUMBER, dFecEmision DATE,cNumDepBancario VARCHAR2 DEFAULT NULL);

PROCEDURE APLICAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPrimaDeposito NUMBER, dFecAplic DATE,
                  cNumReciboRef VARCHAR2, nPagoM NUMBER, nPagoL NUMBER, nSldoFactM NUMBER, nSldoFactL NUMBER);

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPrimaDeposito NUMBER, dFecAnul DATE);

PROCEDURE DEVOLVER(nIdPrimaDeposito NUMBER, dFecDevol DATE);

PROCEDURE APLICAR_FACTURA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPrimaDeposito NUMBER, dFecAplic DATE,
                          cNumReciboRef VARCHAR2, nPagoM NUMBER, nPagoL NUMBER, nSldoFactM NUMBER,
                          nSldoFactL NUMBER, nIdTransaccion NUMBER);

PROCEDURE REVERTIR_APLICACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPrimaDeposito NUMBER);

END OC_PRIMAS_DEPOSITO;
/

--
-- OC_PRIMAS_DEPOSITO  (Package Body) 
--
--  Dependencies: 
--   OC_PRIMAS_DEPOSITO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_PRIMAS_DEPOSITO IS

FUNCTION CORRELATIVO RETURN NUMBER IS
nIdPrimaDeposito  PRIMAS_DEPOSITO.IdPrimaDeposito%TYPE;
BEGIN

   /**SELECT NVL(MAX(IdPrimaDeposito),0) + 1
     INTO nIdPrimaDeposito
     FROM PRIMAS_DEPOSITO;*/
   /**  Cambio  a Secuencia XDS **/  
      SELECT SQ_PRIMAS_DEPOSITO.NEXTVAL     
        INTO nIdPrimaDeposito
        FROM DUAL;
     

   RETURN(nIdPrimaDeposito);
END CORRELATIVO;

FUNCTION INSERTAR(nCodCliente NUMBER, nMontoTarjeta NUMBER, cCodMoneda VARCHAR2,
                  cObservaciones LONG, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER IS
nIdPrimaDeposito  PRIMAS_DEPOSITO.IdPrimaDeposito%TYPE;
nMonto_Local      PRIMAS_DEPOSITO.Monto_Local%TYPE;
nTasaCambio       PRIMAS_DEPOSITO.TasaCambio%TYPE;
BEGIN
   nIdPrimaDeposito := OC_PRIMAS_DEPOSITO.CORRELATIVO;
   nTasaCambio      := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
   nMonto_Local     := NVL(nMontoTarjeta,0) * NVL(nTasaCambio,0); 

   BEGIN
      INSERT INTO PRIMAS_DEPOSITO
             (IdPrimaDeposito, CodCliente, Fecha, Monto_Local, Monto_Moneda,
              Costo_Total_Poliza_Moneda, Saldo_Moneda, Saldo_Local, Observaciones,
              Estado, Numero_Recibo_Referencia, Cod_Moneda, TasaCambio,
              Costo_Total_Poliza_Local, FecSts, IdPoliza, IDetPol)
      VALUES (nIdPrimaDeposito, nCodCliente, TRUNC(SYSDATE), nMonto_Local, nMontoTarjeta,
              nMontoTarjeta, nMontoTarjeta, nMonto_Local, cObservaciones,
              'SOL', NULL, cCodMoneda, nTasaCambio, nMonto_Local, TRUNC(SYSDATE), NVL(nIdPoliza,0), NVL(nIDetPol,0));
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20100,'No. de Prima en Depósito '||TRIM(TO_CHAR(nIdPrimaDeposito)) || ' Ya Existe');
   END;
   RETURN(nIdPrimaDeposito);
END INSERTAR;

PROCEDURE EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPrimaDeposito NUMBER, dFecEmision DATE, cNumDepBancario VARCHAR2 DEFAULT NULL) IS
cEmitida       VARCHAR2(1);
nIdTransac     TRANSACCION.IdTransaccion%TYPE;
nMonto_Local   PRIMAS_DEPOSITO.Monto_Local%TYPE;
BEGIN
   BEGIN
      SELECT 'N', Monto_Local
        INTO cEmitida, nMonto_Local
        FROM PRIMAS_DEPOSITO
       WHERE IdPrimaDeposito = nIdPrimaDeposito
         AND Estado          = 'SOL';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'No. de Prima en Depósito '||TRIM(TO_CHAR(nIdPrimaDeposito)) || ' NO Esta en SOLICITUD y No Puede Emitirse');
   END;

   nIdTransac := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 10, 'EMIPRD');
   OC_DETALLE_TRANSACCION.CREA(nIdTransac, nCodCia, nCodEmpresa, 10, 'EMIPRD', 'PRIMAS_DEPOSITO',
                               nIdPrimaDeposito, NULL, NULL, NULL, nMonto_Local);
   UPDATE PRIMAS_DEPOSITO
      SET IdTransacEmit            = nIdTransac,
          Estado                   = 'EMI',
          FecSts                   = dFecEmision,
          Numero_Recibo_Referencia = cNumDepBancario
    WHERE IdPrimaDeposito = nIdPrimaDeposito;

   OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransac, 'C');
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Emitir No. de Prima en Depósito '||TRIM(TO_CHAR(nIdPrimaDeposito)) || SQLERRM);
END EMITIR;

PROCEDURE APLICAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPrimaDeposito NUMBER, dFecAplic DATE,
                  cNumReciboRef VARCHAR2, nPagoM NUMBER, nPagoL NUMBER, nSldoFactM NUMBER, nSldoFactL NUMBER) IS

nMtoLocal    PRIMAS_DEPOSITO.Saldo_Local%TYPE;
nMtoMoneda   PRIMAS_DEPOSITO.Saldo_Moneda%TYPE;
cAplicada    VARCHAR2(1);
nIdTransac   TRANSACCION.IdTransaccion%TYPE;
BEGIN
   BEGIN
      SELECT 'N'
        INTO cAplicada
        FROM PRIMAS_DEPOSITO
       WHERE IdPrimaDeposito = nIdPrimaDeposito
         AND Estado         IN ('EMI','APP');

      nMtoMoneda := nPagoM;
      nMtoLocal  := nPagoL;
      IF nSldoFactM  <= nMtoMoneda THEN
         nMtoMoneda := nSldoFactM;
         nMtoLocal  := nSldoFactL;
      END IF;

      nIdTransac := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 10, 'APLPRD');
      OC_DETALLE_TRANSACCION.CREA(nIdTransac, nCodCia, nCodEmpresa, 10, 'APLPRD', 'PRIMAS_DEPOSITO',
                                  nIdPrimaDeposito, NULL, NULL, NULL, nMtoLocal);

      IF nMtoMoneda >= nPagoM THEN
         UPDATE PRIMAS_DEPOSITO
            SET Estado                   = 'APL',
                FecSts                   = dFecAplic,
                Saldo_Local              = 0,
                Saldo_Moneda             = 0,
                Numero_Recibo_Referencia = cNumReciboRef,
                IdTransacAplic           = nIdTransac
          WHERE IdPrimaDeposito = nIdPrimaDeposito;
      ELSE
         UPDATE PRIMAS_DEPOSITO
            SET Estado                   = 'APP',
                FecSts                   = dFecAplic,
                Saldo_Local              = Saldo_Local  - nSldoFactL,
                Saldo_Moneda             = Saldo_Moneda - nSldoFactM,
                Numero_Recibo_Referencia = cNumReciboRef,
                IdTransacAplic           = nIdTransac
          WHERE IdPrimaDeposito = nIdPrimaDeposito;
      END IF;
      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransac, 'C');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'No. de Prima en Depósito '||TRIM(TO_CHAR(nIdPrimaDeposito)) || ' NO Esta EMITIDA y no Puede Aplicarse');
   END;
END APLICAR;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPrimaDeposito NUMBER, dFecAnul DATE) IS
cAplicada    VARCHAR2(1);
nIdTransac   TRANSACCION.IdTransaccion%TYPE;
nMonto_Local PRIMAS_DEPOSITO.Monto_Local%TYPE;
BEGIN
   BEGIN
      SELECT 'N', Monto_Local
        INTO cAplicada, nMonto_Local
        FROM PRIMAS_DEPOSITO
       WHERE IdPrimaDeposito  = nIdPrimaDeposito
         AND Estado      NOT IN  ('APL','APP');

      nIdTransac := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 10, 'ANUPRD');
      OC_DETALLE_TRANSACCION.CREA(nIdTransac, nCodCia, nCodEmpresa, 10, 'ANUPRD', 'PRIMAS_DEPOSITO',
                                  nIdPrimaDeposito, NULL, NULL, NULL, nMonto_Local);

      UPDATE PRIMAS_DEPOSITO
         SET Estado        = 'ANU',
             FecSts        = dFecAnul,
             IdTransacAnul = nIdTransac
       WHERE IdPrimaDeposito = nIdPrimaDeposito;

      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransac, 'C');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'Prima en Depósito No. '||TRIM(TO_CHAR(nIdPrimaDeposito)) || ' Esta Aplicada y NO Puede Anularse');
   END;
END ANULAR;

PROCEDURE DEVOLVER(nIdPrimaDeposito NUMBER, dFecDevol DATE) IS
BEGIN
   UPDATE PRIMAS_DEPOSITO
      SET Estado        = 'DEVUEL',
          FecSts        = dFecDevol
    WHERE IdPrimaDeposito = nIdPrimaDeposito;
END DEVOLVER;

PROCEDURE APLICAR_FACTURA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPrimaDeposito NUMBER, dFecAplic DATE,
                          cNumReciboRef VARCHAR2, nPagoM NUMBER, nPagoL NUMBER, nSldoFactM NUMBER,
                          nSldoFactL NUMBER, nIdTransaccion NUMBER) IS

nMtoLocal    PRIMAS_DEPOSITO.Saldo_Local%TYPE;
nMtoMoneda   PRIMAS_DEPOSITO.Saldo_Moneda%TYPE;
nIdPoliza    PRIMAS_DEPOSITO.IdPoliza%TYPE;
nIDetPol     PRIMAS_DEPOSITO.IDetPol%TYPE;
cAplicada    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'N', IdPoliza, IDetPol
        INTO cAplicada, nIdPoliza, nIDetPol
        FROM PRIMAS_DEPOSITO
       WHERE IdPrimaDeposito = nIdPrimaDeposito
         AND Estado         IN ('EMI','APP');

      nMtoMoneda := nPagoM;
      nMtoLocal  := nPagoL;
      IF nSldoFactM  <= nMtoMoneda THEN
         nMtoMoneda := nSldoFactM;
         nMtoLocal  := nSldoFactL;
      END IF;

      OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 12, 'PAGPRD', 'PRIMAS_DEPOSITO',
                                  nIdPrimaDeposito, nIdPoliza, nIDetPol, NULL, nMtoLocal);

      IF nMtoMoneda >= nPagoM THEN
         UPDATE PRIMAS_DEPOSITO
            SET Estado                   = 'APL',
                FecSts                   = dFecAplic,
                Saldo_Local              = 0,
                Saldo_Moneda             = 0,
                Numero_Recibo_Referencia = cNumReciboRef,
                IdTransacAplic           = nIdTransaccion
          WHERE IdPrimaDeposito = nIdPrimaDeposito;
      ELSE
         UPDATE PRIMAS_DEPOSITO
            SET Estado                   = 'APP',
                FecSts                   = dFecAplic,
                Saldo_Local              = Saldo_Local  - nSldoFactL,
                Saldo_Moneda             = Saldo_Moneda - nSldoFactM,
                Numero_Recibo_Referencia = cNumReciboRef,
                IdTransacAplic           = nIdTransaccion
          WHERE IdPrimaDeposito = nIdPrimaDeposito;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'No. de Prima en Depósito '||TRIM(TO_CHAR(nIdPrimaDeposito)) || ' NO Esta EMITIDA y no Puede Aplicarse');
   END;
END APLICAR_FACTURA;

PROCEDURE REVERTIR_APLICACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPrimaDeposito NUMBER) IS
cAplicada               VARCHAR2(1);
nIdTransac              TRANSACCION.IdTransaccion%TYPE;
nMonto_Local            PRIMAS_DEPOSITO.Monto_Local%TYPE;
nMonto_Moneda           PRIMAS_DEPOSITO.Monto_Moneda%TYPE;
nCodCliente             PRIMAS_DEPOSITO.CodCliente%TYPE;
cCodMoneda              PRIMAS_DEPOSITO.Cod_Moneda%TYPE;
nIdPoliza               PRIMAS_DEPOSITO.IdPoliza%TYPE;
nIDetPol                PRIMAS_DEPOSITO.IDetPol%TYPE;
nIdPrimaDepNueva        PRIMAS_DEPOSITO.IDetPol%TYPE;
cNum_Recibo_Referencia  PRIMAS_DEPOSITO.Numero_Recibo_Referencia%TYPE;
BEGIN
   BEGIN
      SELECT 'N', Monto_Local, Monto_Moneda, CodCliente,
             Cod_Moneda, IdPoliza, IDetPol, Numero_Recibo_Referencia
        INTO cAplicada, nMonto_Local, nMonto_Moneda, nCodCliente,
             cCodMoneda, nIdPoliza, nIDetPol, cNum_Recibo_Referencia
        FROM PRIMAS_DEPOSITO
       WHERE IdPrimaDeposito = nIdPrimaDeposito
         AND Estado         IN ('APL','APP');

      nIdTransac := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 10, 'ANUPRD');
      OC_DETALLE_TRANSACCION.CREA(nIdTransac, nCodCia, nCodEmpresa, 10, 'ANUPRD', 'PRIMAS_DEPOSITO',
                                  nIdPrimaDeposito, NULL, NULL, NULL, nMonto_Local);

      UPDATE PRIMAS_DEPOSITO
         SET Estado        = 'ANU',
             FecSts        = TRUNC(SYSDATE),
             IdTransacAnul = nIdTransac
       WHERE IdPrimaDeposito = nIdPrimaDeposito;

      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransac, 'C');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'Prima en Depósito No. '||TRIM(TO_CHAR(nIdPrimaDeposito)) || ' NO está Aplicada y NO Puede Revertirse');
   END;
END REVERTIR_APLICACION;

END OC_PRIMAS_DEPOSITO;
/

CREATE OR REPLACE PACKAGE GT_FAI_PRESTAMOS AS

FUNCTION NUMERO_PRESTAMO(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER;

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER, dFeEfectiva DATE);

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER, nIdPoliza NUMBER, cCodMotvAnul VARCHAR2, dFecAnul DATE);

FUNCTION SALDO_PRESTAMO(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER) RETURN NUMBER;

PROCEDURE INTERES_DEVENGADO(nCodCia NUMBER, nCodEmpresa NUMBER);

PROCEDURE PAGOS(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER, nidPoliza NUMBER, nIDetPol NUMBER, nMtoAbonoMoneda NUMBER, nMtoAbonoLocal NUMBER,
                nTasaCambio NUMBER, cCodMonedaPago VARCHAR2, nIdFormaPago NUMBER, nIdTransaccion OUT NUMBER, nIdFactura OUT NUMBER);

FUNCTION POSEE_PRESTAMO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN VARCHAR2;

--FUNCTION VALIDA_ABONO_PRESTAMO(nNumPrestamo NUMBER, nMontoTotal NUMBER,
--                               dFecEfectiva IN OUT DATE) RETURN VARCHAR2;

--PROCEDURE COBRA_ABONO_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdFactura NUMBER, dFecEfectiva DATE);

END GT_FAI_PRESTAMOS;
/

CREATE OR REPLACE PACKAGE BODY GT_FAI_PRESTAMOS AS

FUNCTION NUMERO_PRESTAMO(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER IS
nNumPrestamo    FAI_PRESTAMOS.NumPrestamo%TYPE;
BEGIN
  BEGIN
    SELECT NVL(MAX(NumPrestamo),0)+1
      INTO nNumPrestamo
      FROM FAI_PRESTAMOS
     WHERE CodCia      = nCodCia
       AND CodEmpresa  = nCodEmpresa;
  END;
  RETURN(nNumPrestamo);
END NUMERO_PRESTAMO;

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER, dFeEfectiva DATE) IS
cTipoFondo           FAI_TIPOS_DE_FONDOS.TipoFondo%TYPE;
nIdTransaccion       TRANSACCION.IdTransaccion%TYPE;
nIdPro               SUB_PROCESO.IdProceso%TYPE := 22;
cIdSProc             SUB_PROCESO.CodSubProceso%TYPE := 'ACTPTM';
nMtoPrestamoMoneda   FAI_PRESTAMOS.MtoPrestamoMoneda%TYPE;
nIdPoliza            FAI_PRESTAMOS.IdPoliza%TYPE;
BEGIN
  -- Actualiza Fecha Efectiva del Préstamo
  BEGIN
    UPDATE FAI_PRESTAMOS
       SET StsPrestamo = 'ACTIVO',
           FecStatus   = TRUNC(SYSDATE),
           FecEfectiva = dFeEfectiva
     WHERE CodCia      = nCodCia
       AND CodEmpresa  = nCodEmpresa
       AND NumPrestamo = nNumPrestamo;
  END;

   SELECT IdPoliza, NVL(SUM(MtoPrestamoMoneda),0)
     INTO nIdPoliza, nMtoPrestamoMoneda
     FROM FAI_PRESTAMOS
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND NumPrestamo = nNumPrestamo;


  nIdTransaccion := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, nIdPro ,cIdSProc);

  OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, nIdPro, cIdSProc, 'FAI_PRESTAMOS',
                              nCodCia, nCodEmpresa, nNumPrestamo, nIdPoliza, nMtoPrestamoMoneda);

  GT_FAI_PRESTAMOS_MOV.ACTIVAR(nCodCia, nCodEmpresa, nNumPrestamo,  nIdPro ,cIdSProc, nIdTransaccion);
  
  OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');

END ACTIVAR;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER, nIdPoliza NUMBER, cCodMotvAnul VARCHAR2, dFecAnul DATE) IS
nIdTransaccionAnu   TRANSACCION.IdTransaccion%TYPE;
nIdPro              SUB_PROCESO.IdProceso%TYPE := 22;
cIdSProc            SUB_PROCESO.CodSubProceso%TYPE := 'ANUPTM';
nIdNcr              FAI_PRESTAMOS_MOV.IdNcr%TYPE;

CURSOR MOV_Q IS
   SELECT NumMov, TipoMov, IdFactura, IdNcr, MontoMovLocal, MontoMovMoneda,
          DescMovimiento, TasaCambio, FecTasaCambio, IdTransaccion
     FROM FAI_PRESTAMOS_MOV
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND NumPrestamo = nNumPrestamo
      AND StsMov     != 'ANULAD';
BEGIN
  nIdTransaccionAnu := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, nIdPro ,cIdSProc);
  FOR X IN MOV_Q LOOP
    GT_FAI_PRESTAMOS_MOV.INSERTAR_MOV(nCodCia, nCodEmpresa, nNumPrestamo, X.TipoMov, X.MontoMovLocal * -1,
                                      X.MontoMovMoneda * -1, X.IdFactura, X.IdNcr,
                                      'Anulación de '||X.DescMovimiento, X.TasaCambio, X.FecTasaCambio,
                                      dFecAnul, Null, nIdTransaccionAnu);
    OC_DETALLE_TRANSACCION.CREA(nIdTransaccionAnu, nCodCia, nCodEmpresa, nIdPro, cIdSProc, 'FAI_PRESTAMOS',
                                nCodCia, nCodEmpresa, nNumPrestamo, nIdPoliza, X.MontoMovLocal * -1);
    nIdNcr := X.IdNcr;
  END LOOP;
  OC_NOTAS_DE_CREDITO.ANULAR(nIdNcr, dFecAnul, cCodMotvAnul, nIdTransaccionAnu);

  OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccionAnu, 'C');

  BEGIN
    UPDATE FAI_PRESTAMOS
       SET StsPrestamo = 'ANULAD',
           FecStatus   = TRUNC(SYSDATE),
           FecAnul     = dFecAnul,
           CodMotvAnul = cCodMotvAnul
     WHERE CodCia      = nCodCia
       AND CodEmpresa  = nCodEmpresa
       AND NumPrestamo = nNumPrestamo;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR (-20100,'ERROR al Anular Préstamo No. '||TO_CHAR(nNumPrestamo));
  END;
END ANULAR;

FUNCTION SALDO_PRESTAMO(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER) RETURN NUMBER IS
nSaldo    FAI_PRESTAMOS_MOV.MontoMovMoneda%TYPE := 0;
BEGIN
   BEGIN
      SELECT SUM(NVL(MontoMovMoneda,0))
        INTO nSaldo
        FROM FAI_PRESTAMOS_MOV
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND NumPrestamo = nNumPrestamo
         AND StsMov     != 'ANULAD';
   END;
   RETURN(NVL(nSaldo,0));
END SALDO_PRESTAMO;

PROCEDURE INTERES_DEVENGADO(nCodCia NUMBER, nCodEmpresa NUMBER) IS
cCalcIntPrestamos  VARCHAR2(1);
cTipoFondo         VARCHAR2(1);
nInteresMovLocal   FAI_PRESTAMOS.MtoPrestamoLocal%TYPE;
nInteresMovMoneda  FAI_PRESTAMOS.MtoPrestamoMoneda%TYPE;
      
CURSOR PRES_Q IS
   SELECT CodCia, CodEmpresa, NumPrestamo, IdPoliza, IDetPol, CodAsegurado, NumSolicitud, StsPrestamo,
          FecStatus, TipoPrestamo, CodMoneda, ValMaxPrestamo, SaldoPtmoAnt, CapNuevoPtmo, MtoPrestamoLocal,
          MtoPrestamoMoneda, TasaCambio, FecTasaCambio, FecEmision, FecEfectiva, FecVencimiento, TipoTasa,
          Spread, FecAnul, CodMotvAnul, PagoPrima, IdFormaPago, CodMonedaPago, TRUNC(SYSDATE) - FecEfectiva DiasCalculo
     FROM FAI_PRESTAMOS P
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa;
BEGIN
  FOR X IN PRES_Q LOOP
    BEGIN
      SELECT DISTINCT T.CalcIntPrestamos, T.TipoFondo
        INTO cCalcIntPrestamos, cTipoFondo
        FROM FAI_TIPOS_DE_FONDOS T, FAI_FONDOS_DETALLE_POLIZA F
       WHERE T.IndPrestamos = 'S'
         AND T.TipoFondo    = F.TipoFondo
         AND F.CodCia       = X.CodCia
         AND F.CodEmpresa   = X.CodEmpresa
         AND F.IdPoliza     = X.IdPoliza;
    EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        cCalcIntPrestamos := 'V';
    END;
    nInteresMovMoneda := NVL(X.MtoPrestamoMoneda,0) * (NVL(GT_FAI_TASAS_DE_INTERES.TASA_INTERES(X.TipoTasa, cTipoFondo, X.FecEfectiva),0) + NVL(X.Spread,0))*NVL(X.DiasCalculo,0);
    nInteresMovLocal  := NVL(nInteresMovMoneda,0) * NVL(OC_GENERALES.TASA_DE_CAMBIO(X.CodMoneda, X.FecEfectiva),0);

    IF cCalcIntPrestamos = 'A' THEN
       BEGIN
         UPDATE FAI_PRESTAMOS_MOV
            SET MontoMovLocal  = nInteresMovLocal,
                MontoMovMoneda = nInteresMovMoneda
          WHERE CodCia      = X.CodCia
            AND CodEmpresa  = X.CodEmpresa
            AND NumPrestamo = X.NumPrestamo
            AND TipoMov     = 'INTVEN';
         IF SQL%NOTFOUND THEN
            GT_FAI_PRESTAMOS_MOV.INSERTAR_MOV(X.CodCia, X.CodEmpresa, X.NumPrestamo, 'INTVEN', nInteresMovLocal,
                                              nInteresMovMoneda, NULL, NULL, 'Intereses Vencidos del Préstamo No. '||TO_CHAR(X.NumPrestamo), X.TasaCambio,
                                              X.FecTasaCambio, TRUNC(SYSDATE), NULL, NULL);
         END IF;
       END;
    ELSE
       BEGIN
         UPDATE FAI_PRESTAMOS_MOV
            SET MontoMovLocal  = nInteresMovLocal * -1,
                MontoMovMoneda = nInteresMovMoneda * -1
          WHERE CodCia      = X.CodCia
            AND CodEmpresa  = X.CodEmpresa
            AND NumPrestamo = X.NumPrestamo
            AND TipoMov     = 'INTANT';
         IF SQL%NOTFOUND THEN
            GT_FAI_PRESTAMOS_MOV.INSERTAR_MOV(X.CodCia, X.CodEmpresa, X.NumPrestamo, 'INTANT', nInteresMovLocal,
                                              nInteresMovMoneda, NULL, NULL, 'Intereses Vencidos del Préstamo No. '||TO_CHAR(X.NumPrestamo), X.TasaCambio,
                                              X.FecTasaCambio, TRUNC(SYSDATE), NULL, NULL);
         END IF;
       END;
    END IF;
  END LOOP;
END INTERES_DEVENGADO;

PROCEDURE PAGOS(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER, nidPoliza NUMBER, nIDetPol NUMBER, nMtoAbonoMoneda NUMBER, nMtoAbonoLocal NUMBER,
                nTasaCambio NUMBER, cCodMonedaPago VARCHAR2, nIdFormaPago NUMBER, nIdTransaccion OUT NUMBER, nIdFactura OUT NUMBER) IS
nCodCliente      FACTURAS.CodCliente%TYPE;

BEGIN
  BEGIN
    SELECT CodCliente
      INTO nCodCliente
      FROM POLIZAS
     WHERE CodCia     = nCodEmpresa
       AND CodEmpresa = nCodCia
       AND IdPoliza   = nIdPoliza;
  END;
  nIdTransaccion := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 22, 'PAGPTM');

  nIdFactura := OC_FACTURAS.INSERTAR(nIdPoliza, nIDetPol, nCodCliente, TRUNC(SYSDATE) /*dFecAbono*/, nMtoAbonoLocal, nMtoAbonoMoneda, NULL,
                                     NULL, NULL, 1, nTasaCambio, NULL, NULL, nCodCia, cCodMonedaPago, NULL, nIdTransaccion, 'N');
  BEGIN
    UPDATE FACTURAS
       SET NumPrestamo = nNumPrestamo
     WHERE IdFactura = nIdFactura;
  END;

  BEGIN
    UPDATE FAI_PRESTAMOS
       SET StsPrestamo   = 'PAGADO',
           FecStatus     = TRUNC(SYSDATE),
           CodMonedaPago = cCodMonedaPago,
           IdFormaPago   = nIdFormaPago
     WHERE CodCia      = nCodCia
       AND CodEmpresa  = nCodEmpresa
       AND NumPrestamo = nNumPrestamo;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR (-20100,'ERROR al Anular Préstamo No. '||TO_CHAR(nNumPrestamo));
  END;

END PAGOS;

FUNCTION POSEE_PRESTAMO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN VARCHAR2 IS
cExiste   VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM FAI_PRESTAMOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdPoliza    = nIdPoliza
         AND IDetPol     = nIDetPol
         AND StsPrestamo IN ('ACTIVO','SOLICI');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste  := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste  := 'S';
   END;
   RETURN(cExiste);
END POSEE_PRESTAMO;
/*
FUNCTION VALIDA_ABONO_PRESTAMO(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER, nMontoTotal NUMBER, dFecEfectiva IN OUT DATE) RETURN VARCHAR2 IS
cExiste           VARCHAR2(1) := 'N';
nNumSolicitud     FAI_PRESTAMOS.NumSolicitud%TYPE;

CURSOR DEP_Q IS
   SELECT C.CodEntFinan, C.NumRelCta, SUM(C.MtoIngreso) MtoIngreso,
          E.CodMoneda, C.OpenItem, C.FecEfectiva
     FROM CONTROL_INGRESOS_COBRANZA C, CUENTA_EF E
    WHERE E.NumRelCta    = C.NumRelCta
      AND E.CodEntFinan  = C.CodEntFinan
      AND C.TipoAplic    = 'ABOPTM'
      AND C.NumSolicitud = nNumSolicitud
      AND C.StsReg       = 'RPS'
    GROUP BY C.CodEntFinan, C.NumRelCta, E.CodMoneda, C.OpenItem, C.FecEfectiva;
BEGIN
   BEGIN
      SELECT NumSolicitud
        INTO nNumSolicitud
        FROM FAI_PRESTAMOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND NumPrestamo = nNumPrestamo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20220, 'No Existe Préstamo No. '||nNumPrestamo);
   END;
   FOR X IN DEP_Q LOOP
      cExiste := 'N';
      -- Se Compara el Valor del Depósito con Monto Total del Abono
      IF NVL(nMontoTotal,0) = NVL(X.MtoIngreso,0) THEN
         --cOpenItem    := X.OpenItem;
         dFecEfectiva := X.FecEfectiva;
         cExiste        := 'S';
      END IF;
   END LOOP;
   RETURN(cExiste);
END VALIDA_ABONO_PRESTAMO;
*/
/*PROCEDURE COBRA_ABONO_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdFactura NUMBER, dFecEfectiva DATE) IS
cCodCptoMov     FAI_CONCENTRADORA_FONDO.CodCptoMov%TYPE;
cCodCobertPaf   FAI_TIPOS_DE_FONDOS.CodCobertPaf%TYPE;
cTipoFondo      FAI_TIPOS_DE_FONDOS.TipoFondo%TYPE;
cCodMoneda      FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
--nIdFactura      FACTURAS.IdFactura%TYPE;
nNumFact        FACTURAS.NumFact%TYPE;
dFecVencFact    FACTURAS.FecVenc%TYPE;
cCodInter       VARCHAR2(10); --FACTURAS.CodInter%TYPE;
nMtoFactLocal   FACTURAS.Monto_Fact_Local%TYPE;
nMtoFactMoneda  FACTURAS.Monto_Fact_Moneda%TYPE;
nNumOperFact    FACTURAS.NumMov%TYPE;
--nNumOperOblig   OBLIGACION.NumOper%TYPE;
cCodMonedaFact  FACTURAS.Cod_Moneda%TYPE;
cDescMovFondo   FAI_CONCENTRADORA_FONDO.DescMovimiento%TYPE;
nIdFondo        FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
nSaldoFondo     FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nValorMovMoneda FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nValorMovLocal  FAI_CONCENTRADORA_FONDO.MontoMovLocal%TYPE;
nIdeFondoCob    FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
dFecHoy         DATE := TRUNC(SYSDATE);
nNumMovAnt      FAI_CONCENTRADORA_FONDO.IdMovimiento%TYPE;
nRegs           NUMBER(8) := 0;
nSaldoConcent   FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nIDetPol        FAI_FONDOS_DETALLE_POLIZA.IDetPol%TYPE;
nCodAsegurado   FAI_FONDOS_DETALLE_POLIZA.CodAsegurado%TYPE;
nIdTransaccion  TRANSACCION.IdTransaccion%TYPE;
nNumPrestamo    FACTURAS.NumPrestamo%TYPE;

/*CURSOR FOND_Q IS
   SELECT F.IdFondo, T.IndDctoCobFondo, T.IndRescateAutomatico, T.MtoMinConcentradora, T.CodMoneda,
--          FP.OrdenFondo, F.FechaConf, T.CodCobertPaf, T.TipoFondo
     FROM FAI_TIPOS_DE_FONDOS T, FAI_FONDOS_DETALLE_POLIZA F, POLIZA P, TIPOS_FONDOS_PLAN_PROD FP
    --WHERE FP.TipoFondo      = F.TipoFondo
    --  AND FP.CodRamo        = F.CodRamoCert
    --  AND FP.RevPlan        = F.RevPlan
    --  AND FP.CodPlan        = F.CodPlan
    --  AND FP.CodProd        = P.CodProd
    WHERE T.TipoFondo       = F.TipoFondo
      AND T.IndDctoCobFondo = 'S'
      AND P.CodCia          = F.CodCia
      AND P.CodEmpresa      = F.CodEmpresa
      AND P.IdPoliza        = F.IdPoliza
      AND F.CodCia          = nCodCia
      AND F.CodEmpresa      = nCodEmpresa
      AND F.IdePol          = nIdePol;
     --ORDER BY FP.OrdenFondo;

CURSOR FOND_Q IS
   SELECT F.IDetPol, F.CodAsegurado, F.IdFondo, F.TipoFondo, T.CodMoneda, T.IndRescateAutomatico,
          T.MtoMinConcentradora, F.FechaConf
     FROM FAI_FONDOS_DETALLE_POLIZA F, FAI_TIPOS_DE_FONDOS T
    WHERE T.IndPrestamos = 'S'
      AND T.TipoFondo    = F.TipoFondo
      AND F.StsFondo     = 'ACT'
      AND F.CodCia       = nCodCia
      AND F.CodEmpresa   = nCodEmpresa
      AND F.IdPoliza     = nIdPoliza;
BEGIN
   --  Suma Saldo de Fondos que Permiten Préstamo
   nSaldoConcent := 0;
   FOR X IN FOND_Q LOOP
     nSaldoConcent := NVL(nSaldoConcent,0) +
                      ROUND(OC_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, X.IdetPol, X.CodAsegurado, X.IdFondo, dFecEfectiva) *
                      OC_GENERALES.TASA_DE_CAMBIO(OC_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, X.TipoFondo), dFecEfectiva),2);
     nIDetPol      := X.IdetPol;
     nCodAsegurado := X.CodAsegurado;
   END LOOP;

   BEGIN
      SELECT NumPrestamo, NumFact, FecVenc, 'FALTA' CodInter,
             Monto_Fact_Local, Monto_Fact_Moneda, NumMov NumOper, Cod_Moneda
        INTO nNumPrestamo, nNumFact, dFecVencFact, cCodInter,
             nMtoFactLocal, nMtoFactMoneda, nNumOperFact, cCodMonedaFact
        FROM FACTURAS
       WHERE IdFactura = nIdFactura;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20052,'No existe Factura para Cobro No. '||nIdFactura);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20052,'Existe varias Factura para Cobro con el mismo No. '||nIdFactura);
   END;

   -- Se leen los Fondos por Orden de Aplicación para Determinar de Donde se Descuenta la Factura
   -- En todos siempre verificar que Tengan suficiente Saldo y no Bajen del Mínimo
   FOR X IN FOND_Q LOOP
      nRegs := nRegs + 1;

      IF X.CodMoneda != cCodMonedaFact THEN
         nValorMovMoneda := NVL(nMtoFactLocal,0) / OC_GENERALES.TASA_DE_CAMBIO(X.CodMoneda, X.FechaConf);
      ELSE
         nValorMovMoneda := NVL(nMtoFactMoneda,0);
      END IF;
      nValorMovLocal := NVL(nValorMovMoneda,0) * OC_GENERALES.TASA_DE_CAMBIO(X.CodMoneda, X.FechaConf);
      nSaldoFondo := OC_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, X.IdetPol, X.CodAsegurado, X.IdFondo, X.FechaConf) - NVL(nValorMovMoneda,0);

      IF X.IndRescateAutomatico = 'S' AND
         NVL(nSaldoFondo,0) > X.MtoMinConcentradora THEN
         nIdeFondoCob := X.IdFondo;
      ELSIF X.IndRescateAutomatico = 'N' THEN
         nIdeFondoCob := X.IdFondo;
      END IF;
   END LOOP;

   BEGIN
      SELECT CodCptoMov
        INTO cCodCptoMov
        FROM FAI_MOVIMIENTOS_FONDOS
       WHERE TipoFondo  = cTipoFondo
         AND CodCptoMov LIKE '%'||SUBSTR(cCodCobertPaf,1,3)||'%';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20052,'No existe Movimiento del Fondo ' || cTipoFondo || ' para el Cobro de Primas ' || cCodCobertPaf);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20052,'Existe mas de un Movimiento del Fondo ' || cTipoFondo || ' para el Cobro de Primas ' || cCodCobertPaf);
   END;

   cDescMovFondo := 'Cobro de Factura No. '||nIdFactura||'-'||TRIM(TO_CHAR(nNumFact))||' IdFactura '||TRIM(TO_CHAR(nIdFactura))||
                    ' Con Fecha de Vencimiento el '||TO_CHAR(dFecVencFact,'DD/MM/YYYY')||' Moneda: '||cCodMonedaFact||
                    ' Por un Monto Local de '|| TRIM(TO_CHAR(nMtoFactLocal,'999,999,999,990.00'))||
                    ' y Monto Moneda de '|| TRIM(TO_CHAR(nMtoFactMoneda,'999,999,999,990.00'));
   --PR_OPERACION.INICIAR('COBFA','CONCEN_FO',TO_CHAR(nIdeFondoCob));
   nIdTransaccion := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 22, 'PAGPTM');
   OC_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdeFondoCob, cCodCptoMov, nIdTransaccion,
                                                        cCodMoneda, nValorMovMoneda, nValorMovLocal, 'D', OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, dFecHoy),
                                                        dFecHoy, dFecHoy, cDescMovFondo);
   nNumMovAnt := OC_FAI_CONCENTRADORA_FONDO.NUMERO_MOVIMIENTO(nCodCia, nCodEmpresa, nIdPoliza, 
                                                              nIDetPol, nCodAsegurado, nIdFondo);
   --ASIG_NUMMOV(nIdeFondoCob) - 1;
   
   OC_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo, nIdTransaccion);
   OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 22, 'PAGPTM', 'FAI_PRESTAMOS',
                               nCodCia, nCodEmpresa, nNumPrestamo, nIdPoliza, nValorMovMoneda);

                             --GENERAR_TRANSACCION(nIdeFondoCob,nNumMovAnt,'ACTIV');
   --OC_FAI_CONCENTRADORA_FONDO.GEN_ACRE_OBLIG(nIdeFondoCob,nNumMovAnt);
   --nNumOperOblig := PR_OPERACION.nNumOper;
   --PR_OPERACION.TERMINAR;
   --PR_REL_ING.COBRANZA_AUTOMATICA(nNumOperFact, nNumOperOblig, cCodInter, cCodMonedaFact, '01');
END COBRA_ABONO_FONDO;
*/
END GT_FAI_PRESTAMOS;

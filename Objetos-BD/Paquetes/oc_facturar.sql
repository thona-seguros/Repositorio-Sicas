CREATE OR REPLACE PACKAGE OC_FACTURAR IS
   PROCEDURE PROC_EMITE_FACTURAS (nIdPoliza NUMBER, nIdEndoso NUMBER, pCodCia NUMBER,nTransa NUMBER);
   PROCEDURE PROC_EMITE_FACT_POL (nIdPoliza NUMBER, nIdEndoso NUMBER, pCodCia NUMBER,nTransa NUMBER);
   PROCEDURE PROC_EMITE_FACT_END (nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER,nTransa NUMBER);
   PROCEDURE PROC_EMITE_FACT_CAM (nIdPoliza NUMBER, nIdEndoso NUMBER, pCodCia NUMBER,nTransa NUMBER);
   PROCEDURE PROC_FACT_FIANZA (nIdPoliza NUMBER, nIdEndoso NUMBER, pCodCia NUMBER,nTransa NUMBER);
   FUNCTION FUNC_VALIDA_RESP_POL (nIdPoliza NUMBER, nCodCia NUMBER)RETURN VARCHAR2;
   PROCEDURE PROC_INSERT_RESP_D  (nIdPoliza NUMBER, nCodCia NUMBER);
   FUNCTION FUNC_VALIDA_RESP_DET (nIdPoliza NUMBER, nCodCia NUMBER,nIdetPol NUMBER) RETURN VARCHAR2;
   PROCEDURE PROC_COMISIONAG (nIdPoliza NUMBER ,nIdetPol NUMBER,nCodCia NUMBER,nCodEmpresa NUMBER,cIdTipoSeg VARCHAR2 ,cCodMoneda VARCHAR2,nIdFactura NUMBER,nmontodetlocal  NUMBER,nmontodetmoneda  NUMBER,nTasaCambio NUMBER);
   PROCEDURE PROC_MOVCONTA (nCodCia NUMBER, nIdPoliza NUMBER, cCodMoneda VARCHAR2, cProceso VARCHAR2);
   PROCEDURE PROC_COMISIONPOL(nIdPoliza NUMBER ,nIdetPol NUMBER,nCodCia NUMBER,nCodEmpresa NUMBER,cIdTipoSeg VARCHAR2 ,cCodMoneda VARCHAR2,nIdFactura NUMBER,nmontodetlocal  NUMBER,nmontodetmoneda  NUMBER,nTasaCambio NUMBER);
   PROCEDURE PROC_ENDO_COMI (nIdPoliza NUMBER ,nIdetPol NUMBER,nIdEndoso NUMBER,nCodCia NUMBER,nCodEmpresa NUMBER ,cIdTipoSeg VARCHAR2,cCodMoneda VARCHAR2,nIdFactura NUMBER,nmontodetlocal NUMBER,nmontodetmoneda NUMBER ,nTasaCambio NUMBER);
   PROCEDURE PROC_EMITE_FACT_MENSUAL (nIdPoliza NUMBER, nIdEndoso NUMBER, pCodCia NUMBER,nTransa NUMBER,nCuota NUMBER );
   PROCEDURE PROC_EMITE_FACT_PERIODO (nIdPoliza NUMBER, nIdEndoso NUMBER, pCodCia NUMBER,nTransa NUMBER,nCuota NUMBER );
   FUNCTION FUNC_VALIDA_FECHA (nCodCia NUMBER,nCodEmpresa NUMBER ,nIdPoliza NUMBER, dFecIni DATE,cCodPlanPlago VARCHAR2)RETURN VARCHAR2 ;
   PROCEDURE PROC_EMITE_FACT_ENDO_PERIODO(nIdPoliza NUMBER, nIdEndoso NUMBER, pCodCia NUMBER,nTransa NUMBER,nCuota NUMBER );
   FUNCTION F_GET_FACT ( p_msg_regreso    out  nocopy varchar2 ) RETURN NUMBER;--SEQ XDS 2016/07/27
END OC_FACTURAR;
/
CREATE OR REPLACE PACKAGE BODY OC_FACTURAR IS
--
-- MODIFICACIONES
-- CALCULO Y REGISTRO DEL FIN DE VIGENCIA DE RECIBOS Y NOTAS DE CREDITO      2018/03/09  ICOFINVIG
-- CALCULO DEL AÑO POLIZA DE RECIBOS Y NOTAS DE CREDITO                      2019/03/27  ICO LARPLA
-- CORRECCION DEL TIPO DE CAMBIO PARA COMPONENTES                            2019/06/12  ICO LARPLA1
-- CAMBIO DE VIGENCIA POR AÑOS SUBSECUENTES                                  2019/08/21  ICO LARPLA2
--
PROCEDURE PROC_EMITE_FACTURAS(nIdPoliza NUMBER, nIdEndoso NUMBER, pCodCia NUMBER, nTransa NUMBER) IS
nIdFactura               FACTURAS.IdFactura%TYPE;
nNumPagos                PLAN_DE_PAGOS.NumPagos%TYPE;
nNumPagosReal            PLAN_DE_PAGOS.NumPagos%TYPE;
/* nFrecPagos               PLAN_DE_PAGOS.FrecPagos%TYPE; */
nPorcInicial             PLAN_DE_PAGOS.PorcInicial%TYPE;
nCodCliente              POLIZAS.CodCliente%TYPE;
cIdTipoSeg               DETALLE_POLIZA.IdTipoSeg%TYPE;
nTotPrimas               DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDifer                   DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDiferMoneda             DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoDet                  DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoDetMoneda            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoTotal                DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoTotalMoneda          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cCodMoneda               POLIZAS.Cod_Moneda%TYPE;
nPrimaNetaMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoPagoMoneda           FACTURAS.Monto_Fact_Moneda%TYPE;
cCodMonedaLocal          EMPRESAS.Cod_Moneda%TYPE;
nPrimaRestMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoComisiMoneda         FACTURAS.MtoComisi_Local%TYPE;
nTotPrimasMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nCodCia                  POLIZAS.CodCia%TYPE;
nCodEmpresa              POLIZAS.CodEmpresa%TYPE;
cCodPlanPago             DETALLE_POLIZA.CodPlanPago%TYPE;
nTasaCambio              DETALLE_POLIZA.Tasa_Cambio%TYPE;
nMtoCpto                 CONCEPTOS_PLAN_DE_PAGOS.MtoCpto%TYPE;
nPorcCpto                CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
cAplica                  CONCEPTOS_PLAN_DE_PAGOS.Aplica%TYPE;
nCod_Agente              AGENTES_DETALLES_POLIZAS.Cod_Agente%TYPE;
--
nMtoRecD_Local           DETALLE_RECARGO.Monto_Local%TYPE;
nMtoRecD_Moneda          DETALLE_RECARGO.Monto_Moneda%TYPE;
nMtoDescD_Local          DETALLE_DESCUENTO.Monto_Local%TYPE;
nMtoDescD_Moneda         DETALLE_DESCUENTO.Monto_Moneda%TYPE;
--
nMtoRec_Local            RECARGOS.Monto_Local%TYPE;
nMtoRec_Moneda           RECARGOS.Monto_Moneda%TYPE;
nMtoDesc_Local           DESCUENTOS.Monto_Local%TYPE;
nMtoDesc_Moneda          DESCUENTOS.Monto_Moneda%TYPE;
nPrimaTotalM             DETALLE_POLIZA.Prima_Moneda%TYPE;
nPrimaTotalL             DETALLE_POLIZA.Prima_Local%TYPE;
nRec_Local               RECARGOS.Monto_Local%TYPE ;
nRec_Moneda              RECARGOS.Monto_Moneda%TYPE;
nDesc_Local              DESCUENTOS.Monto_Local%TYPE;
nDesc_Moneda             DESCUENTOS.Monto_Moneda%TYPE;
nNumCert                 DETALLE_POLIZA.IDetPol%type;
nPorcResPago             RESPONSABLE_PAGO_DET.PorcResPago%TYPE;
nCodTipoDoc              TIPO_DE_DOCUMENTO.CodTipoDoc%type;
cContabilidad_Automatica EMPRESAS.Contabilidad_Automatica%TYPE;
nIdTranc                 TRANSACCION.IdTransaccion%TYPE;
nIdTransac               TRANSACCION.IdTransaccion%TYPE;
nMtoT                    FACTURAS.Monto_Fact_Local%TYPE := 0;
nMtoTM                   FACTURAS.Monto_Fact_Local%TYPE := 0;
nTotComi                 COMISIONES.Comision_Local%TYPE;
nMtoAsistLocal           ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nMtoAsistMoneda          ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
nAsistRestLocal          ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nAsistRestMoneda         ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
nTotAsistLocal           ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nTotAsistMoneda          ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
nFactor                  NUMBER (14,8);
cRespPol                 VARCHAR2(1):='N';
cRespDet                 VARCHAR2(1):='N';
Dummy                    NUMBER(5);
dFecPago                 DATE;
nMtoPago                 NUMBER(18,2);
nMtoComisi               NUMBER(18,2);
nPrimaRest               NUMBER(18,2);
cGraba                   VARCHAR2(1);
nCantPagosReal           NUMBER(5);
nFrecPagos               PLAN_DE_PAGOS.FrecPagos%TYPE;
fFecfinvig               FACTURAS.FECFINVIG%TYPE;      -- ICOFINVIG

CURSOR DET_POL_Q IS
   SELECT D.Prima_Local PrimaLocal, D.Prima_Moneda PrimaMoneda, D.CodPlanPago, D.PorcComis,
          P.FecIniVig, P.FecFinVig, P.FecEmision, D.IDetPol, D.Tasa_Cambio, D.IdTipoSeg,
          P.IndCalcDerechoEmis, P.IndFactElectronica
     FROM DETALLE_POLIZA D, POLIZAS P
    WHERE D.Prima_Moneda  > 0
      AND D.IdPoliza      = P.IdPoliza
      AND P.StsPoliza    IN  ('SOL','XRE')
      AND P.IdPoliza      = nIdPoliza;

CURSOR CPTO_PLAN_Q IS
   SELECT CP.CodCpto, CP.PorcCpto, CP.Aplica, CP.MtoCpto, CP.RutinaCalculo,
          CC.IndRangosTipseg
     FROM CONCEPTOS_PLAN_DE_PAGOS CP, CATALOGO_DE_CONCEPTOS CC
    WHERE CC.IndCptoAjuste = 'N'
      AND CC.IndCptoPrimas = 'N'
      AND CC.CodConcepto   = CP.CodCpto
      AND CC.CodCia        = CP.CodCia
      AND CP.CodCia        = pCodCia
      AND CP.CodEmpresa    = nCodEmpresa
      AND CP.CodPlanPago   = cCodPlanPago
      AND EXISTS (SELECT 'S'
                    FROM RAMOS_CONCEPTOS_PLAN
                   WHERE CodCia      = CP.CodCia
                     AND CodEmpresa  = CP.CodEmpresa
                     AND IdTipoSeg   = cIdTipoSeg
                     AND CodCpto     = CP.CodCpto
                     AND CodPlanPago = CP.CodPlanPago)
    ORDER BY CP.Prioridad;

CURSOR RESP_PAGO IS
   SELECT R.PorcResPago, R.CodResPago, R.IDetPol
     FROM RESPONSABLE_PAGO_DET R
    WHERE R.IdPoliza    = nIdPoliza
      AND R.CodCia      = pCodCia
      AND R.CodEmpresa  = nCodEmpresa
      AND R.IdetPol     = nNumCert;

CURSOR RESP_PAGO_POL IS
   SELECT R.PorcResPago, R.CodResPago
     FROM RESPONSABLE_PAGO_POL R
    WHERE R.IdPoliza    = nIdPoliza
      AND R.CodCia      = pCodCia
      AND R.CodEmpresa  = nCodEmpresa;

CURSOR CPTO_PRIMAS_Q IS
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERT_ACT C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert   = C.CodCobert
      AND CS.PlanCob     = C.PlanCob
      AND CS.IdTipoSeg   = C.IdTipoSeg
      AND CS.CodEmpresa  = C.CodEmpresa
      AND CS.CodCia      = C.CodCia
      AND C.StsCobertura IN ('EMI','SOL','XRE')
      AND C.IDetPol      = nNumCert
      AND C.IdPoliza     = nIdPoliza
      AND C.CodCia       = pCodCia
       GROUP BY CS.CodCpto
  UNION ALL
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERT_ACT_ASEG C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert   = C.CodCobert
      AND CS.PlanCob     = C.PlanCob
      AND CS.IdTipoSeg   = C.IdTipoSeg
      AND CS.CodEmpresa  = C.CodEmpresa
      AND CS.CodCia      = C.CodCia
      AND C.StsCobertura IN ('EMI','SOL','XRE')
      AND C.IDetPol      = nNumCert
      AND C.IdPoliza     = nIdPoliza
      AND C.CodCia       = pCodCia
    GROUP BY CS.CodCpto;

CURSOR CPTO_ASIST_Q IS
   SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
          SUM(A.MontoAsistMoneda) MontoAsistMoneda
     FROM ASISTENCIAS_DETALLE_POLIZA A, DETALLE_POLIZA D, ASISTENCIAS T
    WHERE T.CodAsistencia  = A.CodAsistencia
      AND D.IDetPol        = A.IDetPol
      AND D.IdPoliza       = A.IdPoliza
      AND D.CodCia         = A.CodCia
      AND A.StsAsistencia IN ('EMITID','SOLICI','XRENOV')
      AND A.IDetPol        = nNumCert
      AND A.IdPoliza       = nIdPoliza
      AND A.CodCia         = pCodCia
    GROUP BY T.CodCptoServicio
  UNION ALL
   SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
          SUM(A.MontoAsistMoneda) MontoAsistMoneda
     FROM ASISTENCIAS_ASEGURADO A, DETALLE_POLIZA D, ASISTENCIAS T
    WHERE T.CodAsistencia  = A.CodAsistencia
      AND D.IDetPol        = A.IDetPol
      AND D.IdPoliza       = A.IdPoliza
      AND D.CodCia         = A.CodCia
      AND A.StsAsistencia IN ('EMITID','SOLICI','XRENOV')
      AND A.IDetPol        = nNumCert
      AND A.IdPoliza       = nIdPoliza
      AND A.CodCia         = pCodCia
    GROUP BY T.CodCptoServicio;
BEGIN
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

   BEGIN
      SELECT 'S'
        INTO cRespPol
        FROM RESPONSABLE_PAGO_POL
       WHERE StsResPago = 'ACT'
         AND CodCia     = pCodCia
         AND IdPoliza   = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cRespPol := 'N';
      WHEN TOO_MANY_ROWS THEN
         cRespPol := 'S';
   END;
   IF cRespPol = 'S' AND  FUNC_VALIDA_RESP_POL (nIdPoliza,pCodCia)= 'S' THEN
      PROC_INSERT_RESP_D(nIdPoliza,pCodCia);
   END IF;
   BEGIN
      SELECT CodCliente, Cod_Moneda, CodCia, CodEmpresa
        INTO nCodCliente, cCodMoneda, nCodCia, nCodEmpresa
        FROM POLIZAS
       WHERE IdPoliza = nIdPoliza;
   END;
   BEGIN
      SELECT Cod_Moneda
        INTO cCodMonedaLocal
        FROM EMPRESAS
       WHERE CodCia = nCodCia;
   END;
   BEGIN
      SELECT SUM(D.Prima_Local) PrimaLocal, SUM(D.Prima_Moneda)PrimaMoneda
        INTO nPrimaTotalL, nPrimaTotalM
        FROM DETALLE_POLIZA D, POLIZAS P
       WHERE D.Prima_Moneda  > 0
         AND D.IdPoliza      = P.IdPoliza
         AND P.StsPoliza    IN ('SOL','XRE')
         AND P.IdPoliza      = nIdPoliza;
   END;
   BEGIN
      SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
        INTO nMtoRec_Local, nMtoRec_Moneda
        FROM RECARGOS
       WHERE IdPoliza = nIdPoliza
         AND Estado   = 'ACT';
   EXCEPTION
      WHEN OTHERS THEN
         nMtoRec_Local  := 0;
         nMtoRec_Moneda := 0;
   END;
   BEGIN
      SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
        INTO nMtoDesc_Local, nMtoDesc_Moneda
        FROM DESCUENTOS
       WHERE IdPoliza  = nIdPoliza
         AND Estado    = 'ACT';
   EXCEPTION
      WHEN OTHERS THEN
         nMtoDesc_Local  := 0;
         nMtoDesc_Moneda := 0;
   END;

   FOR X IN DET_POL_Q LOOP
      nMtoT := 0;
  --    nMtotM := 0;
      OC_DETALLE_TRANSACCION.CREA (nTransa,nCodCia,nCodEmpresa,7,'CER', 'DETALLE_POLIZA',
                                   nIdPoliza, x.idetpol,NULL,  NULL, X.PrimaLocal);
      nNumCert   := X.IDetPol;
      cIdTipoSeg := X.IdTipoSeg;
      BEGIN
         SELECT 'S'
           INTO cRespDet
           FROM RESPONSABLE_PAGO_DET R
          WHERE R.IdPoliza    = nIdPoliza
            AND R.CodCia      = pCodCia
            AND R.CodEmpresa  = nCodEmpresa
            AND R.IdetPol     = X.IDetPol;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cRespDet:='N';
         WHEN TOO_MANY_ROWS THEN
            cRespDet:='S';
      END;
      IF cRespPol = 'N' AND cRespDet = 'N' THEN
         BEGIN
            SELECT Cod_Agente
              INTO nCod_Agente
              FROM AGENTES_DETALLES_POLIZAS
             WHERE IdPoliza      = nIdPoliza
               AND IdetPol       = X.IdetPol
               AND IdTipoSeg     = X.IdTipoSeg
               AND Ind_Principal = 'S';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR (-20100,'No Existe un Agente Definido para el Tipo de Seguro '||X.IdTipoSeg);
            WHEN TOO_MANY_ROWS THEN
               RAISE_APPLICATION_ERROR (-20100,'Existe Mas de un Agente Definido como Principal');
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR (-20100,'Existe un error de otros');
         END;
         cCodPlanPago := X.CodPlanPago;
         IF nMtoRec_Local != 0 OR nMtoRec_Moneda != 0 OR nMtoDesc_Local != 0 OR nMtoDesc_Moneda != 0 THEN
            nFactor      := (X.PrimaLocal / NVL(nPrimaTotalL,0)) * 100;
            nRec_Local   := (nMtoRec_Local   * nFactor) / 100;
            nRec_Moneda  := (nMtoRec_Moneda  * nFactor) / 100;
            nDesc_Local  := (nMtoDesc_Local  * nFactor) / 100;
            nDesc_Moneda := (nMtoDesc_Moneda * nFactor) / 100;
         END IF;
         IF nIdEndoso = 0 THEN
            nTasaCambio := X.Tasa_Cambio;
         ELSE
            nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
         END IF;
         -- Caracteristicas del Plan de Pago
         BEGIN
            SELECT NumPagos, FrecPagos, PorcInicial
              INTO nNumPagos, nFrecPagos, nPorcInicial
              FROM PLAN_DE_PAGOS
             WHERE CodCia      = nCodCia
               AND CodEmpresa  = nCodEmpresa
               AND CodPlanPago = X.CodPlanPago;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR (-20100,'No Existe Plan de Pagos '||X.CodPlanPago);
         END;

         -- Determina Meses de Vigencia para Plan de Pagos
         IF nNumPagos <= 12 THEN
            nCantPagosReal  := FLOOR(MONTHS_BETWEEN(X.FecFinVig, X.FecIniVig) / nFrecPagos);
         ELSE
            nCantPagosReal  := FLOOR((X.FecFinVig - X.FecIniVig) / nFrecPagos);
         END IF;
         IF nCantPagosReal <= 0 THEN
            nCantPagosReal := 1;
         END IF;
         IF nCantPagosReal < nNumPagos THEN
            nNumPagos := nCantPagosReal;
         END IF;

         -- Fecha del Primer Pago Siempre a Inicio de Vigencia
         dFecPago := X.FecIniVig;
         /*IF X.FecIniVig > X.FecEmision THEN
            dFecPago := X.FecIniVig;
         ELSE
            dFecPago := X.FecEmision;
         END IF;*/
         -- Monto del Primer Pago
         nTotPrimas       := 0;
         nTotPrimasMoneda := 0;
         BEGIN
            SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
              INTO nMtoRecD_Local, nMtoRecD_Moneda
              FROM DETALLE_RECARGO
             WHERE IdPoliza = nIdPoliza
               AND IDetPol  = X.IDetPol
               AND Estado   = 'ACT';
         EXCEPTION
            WHEN OTHERS THEN
               nMtoRecD_Local  := 0;
               nMtoRecD_Moneda := 0;
         END;
         BEGIN
            SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
              INTO nMtoDescD_Local, nMtoDescD_Moneda
              FROM DETALLE_DESCUENTO
             WHERE IdPoliza  = nIdPoliza
               AND IDetPol   = X.IDetPol
               AND Estado    = 'ACT';
         EXCEPTION
            WHEN OTHERS THEN
               nMtoDescD_Local  := 0;
               nMtoDescD_Moneda := 0;
         END;
         IF NVL(nPorcInicial,0) <> 0 THEN
            nMtoPago       := ((NVL(X.PrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) * nPorcInicial / 100) ;
            nMtoPagoMoneda := ((NVL(X.PrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) * nPorcInicial / 100);
         ELSE
            nMtoPago       :=( (NVL(X.PrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) / nNumPagos );
            nMtoPagoMoneda :=( (NVL(X.PrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) /nNumPagos );
         END IF;
         nPrimaRest       := (NVL(X.PrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local+ NVL(nRec_Local,0) - NVL(nDesc_Local,0)) - NVL(nMtoPago,0);
         nMtoComisi       := (nMtoPago * X.PorcComis / 100);
         nTotPrimas       := NVL(nTotPrimas,0) + NVL(nMtoPago,0);
         nPrimaRestMoneda := (NVL(X.PrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0))  - NVL(nMtoPagoMoneda,0);
         nMtoComisiMoneda := nMtoPagoMoneda * X.PorcComis / 100 ;
         nTotPrimasMoneda := NVL(nTotPrimasMoneda,0) + NVL(nMtoPagoMoneda,0);

         FOR NP IN 1..nNumPagos LOOP
            IF NP > 1 THEN
               nMtoPago         := NVL(nPrimaRest,0) / (nNumPagos - 1) ;
               nTotPrimas       := NVL(nTotPrimas,0) + NVL(nMtoPago,0) ;
               nMtoComisi       := nMtoPago * X.PorcComis / 100;
               IF nFrecPagos NOT IN (15,7) THEN
                  dFecPago         := ADD_MONTHS(dFecPago,nFrecPagos);
               ELSE
                  dFecPago         := dFecPago + nFrecPagos;
               END IF;
               nMtoPagoMoneda   := NVL(nPrimaRestMoneda,0) / (nNumPagos - 1);
               nTotPrimasMoneda := NVL(nTotPrimasMoneda,0) + NVL(nMtoPagoMoneda,0) ;
               nMtoComisiMoneda := nMtoPagoMoneda * X.PorcComis / 100;
            END IF;
            -- LARPLA
            nIdFactura := OC_FACTURAS.INSERTAR(nIdPoliza,        X.IDetPol,      nCodCliente, dFecPago, 
                                               nMtoPago,         nMtoPagoMoneda, nIdEndoso,   nMtoComisi, 
                                               nMtoComisiMoneda, NP,             nTasaCambio, nCod_Agente, 
                                               nCodTipoDoc,      pCodCia,        cCodMoneda,  NULL, 
                                               nTransa,          X.IndFactElectronica);

            FOR W IN CPTO_PRIMAS_Q LOOP
               nFactor        := W.Prima_Local / X.PrimaLocal;
               OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
               OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
            END LOOP;

            nTotAsistLocal   := 0;
            nTotAsistMoneda  := 0;
            FOR K IN CPTO_ASIST_Q LOOP
               nAsistRestLocal  := 0;
               nAsistRestMoneda := 0;
               IF NVL(nPorcInicial,0) <> 0 THEN
                  nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) * nPorcInicial / 100);
                  nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) * nPorcInicial / 100);
               ELSE
                  nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) / nNumPagos);
                  nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) / nNumPagos);
               END IF;
               nAsistRestLocal  := NVL(nAsistRestLocal,0) + NVL(K.MontoAsistLocal,0) - nMtoAsistLocal;
               nAsistRestMoneda := NVL(nAsistRestMoneda,0) + NVL(K.MontoAsistMoneda,0) - nMtoAsistMoneda;
               IF NP > 1 THEN
                  nMtoAsistLocal  := (NVL(nAsistRestLocal,0) / (nNumPagos - 1));
                  nMtoAsistMoneda := (NVL(nAsistRestMoneda,0) / (nNumPagos - 1));
               END IF;
               nTotAsistLocal  := NVL(nTotAsistLocal,0) + NVL(nMtoAsistLocal,0);
               nTotAsistMoneda := NVL(nTotAsistMoneda,0) + NVL(nMtoAsistMoneda,0);
               OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
               OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
            END LOOP;

            nMtoT := nMtoT + nMtoPago;-- + NVL(nTotAsistLocal,0);
            nMtoTM:= nMtoTM + nMtoPagoMoneda;-- + NVL(nTotAsistMoneda,0);
            -- Genera comisiones por agente por certificado
            PROC_COMISIONAG (nIdPoliza, X.IDetPol, nCodCia, nCodEmpresa, X.IdTipoSeg,
                             cCodMoneda, nIdFactura, nMtoPago, nMtoPagoMoneda, nTasaCambio);

            --PROC_COMISIONAG (nIdPoliza, X.IDetPol, nCodCia, nCodEmpresa, X.IdTipoSeg,
            --                cCodMoneda, nIdFactura, nMtot, nMtoTM, nTasaCambio);

            -- Distribuye la comision por agente.
            FOR Y IN CPTO_PLAN_Q LOOP
               BEGIN
                  SELECT 'S'
                    INTO cGraba
                    FROM RAMOS_CONCEPTOS_PLAN
                   WHERE CodPlanPago = cCodPlanPago
                     AND CodCpto     = Y.CodCpto
                     AND CodCia      = nCodCia
                     AND CodEmpresa  = nCodEmpresa
                     AND IdTipoSeg   = X.IdTipoSeg;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     cGraba := 'N';
                  WHEN TOO_MANY_ROWS THEN
                     cGraba := 'S';
               END;
              IF cGraba = 'S' THEN
                  IF Y.IndRangosTipseg = 'S' THEN
                     IF X.IndCalcDerechoEmis = 'S' THEN
                        OC_CATALOGO_CONCEPTOS_RANGOS.VALOR_CONCEPTO(nCodCia, nCodEmpresa, Y.CodCpto, X.IdTipoSeg,
                                                                    nIdPoliza, X.IdetPol, nIdEndoso, nMtoCpto, nPorcCpto);
                        IF OC_DETALLE_FACTURAS.EXISTE_CONCEPTO(nCodCia, nIdPoliza, nTransa, Y.CodCpto) = 'N' THEN
                           IF NVL(nMtoCpto,0) = 0 AND NVL(nPorcCpto,0) = 0 THEN
                              nMtoCpto  := Y.MtoCpto;
                              nPorcCpto := Y.PorcCpto;
                           END IF;
                        ELSE
                           nMtoCpto  := 0;
                           nPorcCpto := 0;
                        END IF;
                     ELSE
                        nMtoCpto  := 0;
                        nPorcCpto := 0;
                     END IF;
                  ELSE
                     nMtoCpto  := Y.MtoCpto;
                     nPorcCpto := Y.PorcCpto;
                  END IF;
                  IF Y.Aplica = 'P' THEN
                     IF NVL(nMtoCpto,0) <> 0 AND NP = 1 THEN
                        nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                     ELSIF NP = 1 THEN
                        nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                        nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                     ELSE
                        nMtoDet       := 0;
                        nMtoDetMoneda := 0;
                     END IF;
                     IF NVL(nMtoDet,0) != 0 THEN
                        OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                        nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                     END IF;
                  ELSIF Y.Aplica = 'T' THEN
                     IF NVL(nMtoCpto,0) <> 0 THEN
                        nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                     ELSE
                        nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                        nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                     END IF;
                     IF NVL(nMtoDet,0) != 0 THEN
                        OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                        nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                     END IF;
                  END IF;
                  nMtoT := nMtoT + nMtoDet;
               END IF;
            END LOOP;
            OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
         END LOOP;
         -------------->
         BEGIN
            SELECT SUM(Comision_Local)
              INTO nTotComi
              FROM COMISIONES C
             WHERE IdPoliza  = nIdPoliza
               AND EXISTS (SELECT 1
                             FROM FACTURAS F
                            WHERE F.IdFactura     = C.IdFactura
                              AND F.IdTransaccion = nTransa);
         END;
         OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'FAC', 'FACTURAS',
                                      nIdPoliza, X.IdetPol, NULL, NULL, nMtoT);
         OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'COM', 'COMISIONES',
                                      nIdPoliza, X.IdetPol, NULL, NULL, nTotComi);

         /*IF (NVL(X.PrimaLocal,0) + nMtoRecD_Local - nMtoDescD_Local +
             NVL(nRec_Local,0) - NVL(nDesc_Local,0) + NVL(nTotAsistLocal,0)) <> NVL(nTotPrimas,0) THEN*/
         IF (NVL(X.PrimaLocal,0) + nMtoRecD_Local - nMtoDescD_Local +
             NVL(nRec_Local,0) - NVL(nDesc_Local,0)) <> NVL(nTotPrimas,0) THEN
            nDifer       := (NVL(X.PrimaLocal,0)+ nMtoRecD_Local - nMtoDescD_Local +
                             NVL(nRec_Local,0) - NVL(nDesc_Local,0)) - NVL(nTotPrimas,0);
            nDiferMoneda := (NVL(X.PrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda +
                             NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) - NVL(nTotPrimasMoneda,0);
            OC_DETALLE_FACTURAS.ACTUALIZA_DIFERENCIA(nIdFactura, nDifer, nDiferMoneda);
            OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
            OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
         END IF;
      ELSE
         IF cRespDet = 'S' AND FUNC_VALIDA_RESP_DET(nIdPoliza, pCodCia, X.idetpol ) = 'S' THEN
          FOR J IN RESP_PAGO LOOP
               BEGIN
                  SELECT Cod_Agente
                    INTO nCod_Agente
                    FROM AGENTES_DETALLES_POLIZAS
                   WHERE IdPoliza      = nIdPoliza
                     AND IdetPol       = X.IdetPol
                     AND IdTipoSeg     = X.IdTipoSeg
                     AND Ind_Principal = 'S';
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     RAISE_APPLICATION_ERROR (-20100,'No Existe un Agente Definido para el Tipo de Seguro '||X.IdTipoSeg);
                  WHEN TOO_MANY_ROWS THEN
                     RAISE_APPLICATION_ERROR (-20100,'Existe Mas de un Agente Definido como Principal');
                  WHEN OTHERS THEN
                     RAISE_APPLICATION_ERROR (-20100,'Existe un error de otros');
               END;
               cCodPlanPago := X.CodPlanPago;
               IF nMtoRec_Local != 0 OR nMtoRec_Moneda != 0 OR nMtoDesc_Local != 0 OR nMtoDesc_Moneda != 0 THEN
                  nFactor      := ((X.PrimaLocal   * NVL(J.PorcResPago,0)/100) / NVL(nPrimaTotalL,0)) * 100;
                  nRec_Local   := (nMtoRec_Local   * nFactor) / 100;
                  nRec_Moneda  := (nMtoRec_Moneda  * nFactor) / 100;
                  nDesc_Local  := (nMtoDesc_Local  * nFactor) / 100;
                  nDesc_Moneda := (nMtoDesc_Moneda * nFactor) / 100;
               END IF;
               IF nIdEndoso = 0 THEN
                  nTasaCambio := X.Tasa_Cambio;
               ELSE
                  nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
               END IF;
               -- Caracteristicas del Plan de Pago
               BEGIN
                  SELECT NumPagos, FrecPagos, PorcInicial
                    INTO nNumPagos, nFrecPagos, nPorcInicial
                    FROM PLAN_DE_PAGOS
                   WHERE CodCia      = nCodCia
                     AND CodEmpresa  = nCodEmpresa
                     AND CodPlanPago = X.CodPlanPago;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     RAISE_APPLICATION_ERROR (-20100,'No Existe Plan de Pagos '||X.CodPlanPago);
               END;

               -- Determina Meses de Vigencia para Plan de Pagos
               IF nNumPagos <= 12 THEN
                  nCantPagosReal  := FLOOR(MONTHS_BETWEEN(X.FecFinVig, X.FecIniVig) / nFrecPagos);
               ELSE
                  nCantPagosReal  := FLOOR((X.FecFinVig - X.FecIniVig) / nFrecPagos);
               END IF;

               IF nCantPagosReal <= 0 THEN
                  nCantPagosReal := 1;
               END IF;
               IF nCantPagosReal < nNumPagos THEN
                  nNumPagos := nCantPagosReal;
               END IF;

               -- Fecha del Primer Pago Siempre a Inicio de Vigencia
               dFecPago := X.FecIniVig;
               /*IF X.FecIniVig > X.FecEmision THEN
                  dFecPago := X.FecIniVig;
               ELSE
                  dFecPago := X.FecEmision;
               END IF;*/
               -- Monto del Primer Pago
               nTotPrimas       := 0;
               nTotPrimasMoneda := 0;
               BEGIN
                  SELECT  NVL(SUM(Monto_Local),0),NVL(SUM(Monto_Moneda),0)
                    INTO nMtoRecD_Local,nMtoRecD_Moneda
                    FROM DETALLE_RECARGO
                   WHERE IdPoliza = nIdPoliza
                     AND IDetPol  = X.IDetPol
                     AND Estado   = 'ACT';
               EXCEPTION
                  WHEN OTHERS THEN
                     nMtoRecD_Local  := 0;
                     nMtoRecD_Moneda := 0;
               END;
               BEGIN
                  SELECT  NVL(SUM(Monto_Local),0),NVL(SUM(Monto_Moneda),0)
                    INTO nMtoDescD_Local,nMtoDescD_Moneda
                    FROM DETALLE_DESCUENTO
                   WHERE IdPoliza  = nIdPoliza
                     AND IDetPol   = X.IDetPol
                     AND Estado    = 'ACT';
               EXCEPTION
                  WHEN OTHERS THEN
                     nMtoDescD_Local  := 0;
                     nMtoDescD_Moneda := 0;
               END;
               IF NVL(J.PorcResPago,0) != 0  THEN
                  IF NVL(nPorcInicial,0) <> 0 THEN
                     nMtoPago       :=( (NVL(X.PrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0))  * nPorcInicial / 100)  *  NVL(J.PorcResPago,0)/100;
                     nMtoPagoMoneda :=( (NVL(X.PrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) * nPorcInicial / 100)  *  NVL(J.PorcResPago,0)/100;
                  ELSE
                     nMtoPago       :=( (NVL(X.PrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) / nNumPagos ) *  NVL(J.PorcResPago,0)/100;
                     nMtoPagoMoneda :=( (NVL(X.PrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) /nNumPagos )  *  NVL(J.PorcResPago,0)/100;
                  END IF;
                  nPrimaRest       := ((NVL(X.PrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local+ NVL(nRec_Local,0) - NVL(nDesc_Local,0)) *  NVL(J.PorcResPago,0)/100) - NVL(nMtoPago,0)  ;
                  nMtoComisi       := (nMtoPago * X.PorcComis / 100);
                  nTotPrimas       := (NVL(nTotPrimas,0) *  NVL(J.PorcResPago,0)/100) + NVL(nMtoPago,0);
                  nPrimaRestMoneda :=( (NVL(X.PrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) *  NVL(J.PorcResPago,0)/100) - NVL(nMtoPagoMoneda,0);
                  nMtoComisiMoneda := nMtoPagoMoneda * X.PorcComis / 100;
                  nTotPrimasMoneda :=( NVL(nTotPrimasMoneda,0) *  NVL(J.PorcResPago,0)/100) + NVL(nMtoPagoMoneda,0);
               END IF;
               FOR NP IN 1..nNumPagos LOOP
                  IF NP > 1 THEN
                     nMtoPago         := NVL(nPrimaRest,0) / (nNumPagos - 1) ;
                     nTotPrimas       := NVL(nTotPrimas,0) + NVL(nMtoPago,0) ;
                     nMtoComisi       := nMtoPago * X.PorcComis / 100;
                     IF nFrecPagos NOT IN (15,7) THEN
                        dFecPago         := ADD_MONTHS(dFecPago,nFrecPagos);
                     ELSE
                        dFecPago         := dFecPago + nFrecPagos;
                     END IF;
                     nMtoPagoMoneda   := NVL(nPrimaRestMoneda,0) / (nNumPagos - 1);
                     nTotPrimasMoneda := NVL(nTotPrimasMoneda,0) + NVL(nMtoPagoMoneda,0) ;
                     nMtoComisiMoneda := nMtoPagoMoneda * X.PorcComis / 100;
                  END IF;
                  -- LARPLA
                  nIdFactura := OC_FACTURAS.INSERTAR(nIdPoliza,        X.IDetPol,      nCodCliente, dFecPago, 
                                                     nMtoPago,         nMtoPagoMoneda, nIdEndoso,   nMtoComisi, 
                                                     nMtoComisiMoneda, NP,             nTasaCambio, nCod_Agente, 
                                                     nCodTipoDoc,      pCodCia,        cCodMoneda,  J.CodResPago, 
                                                     nTransa,          X.IndFactElectronica);

                  FOR W IN CPTO_PRIMAS_Q LOOP
                     nFactor := W.Prima_Local / (X.PrimaLocal + NVL(J.PorcResPago,0)/100);
                     OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
                     OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
                  END LOOP;

                  nTotAsistLocal  := 0;
                  nTotAsistMoneda := 0;
                  FOR K IN CPTO_ASIST_Q LOOP
                     nAsistRestLocal  := 0;
                     nAsistRestMoneda := 0;
                     IF NVL(nPorcInicial,0) <> 0 THEN
                        nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) * nPorcInicial / 100) * NVL(J.PorcResPago,0)/100;
                        nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) * nPorcInicial / 100) * NVL(J.PorcResPago,0)/100;
                     ELSE
                        nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) / nNumPagos) * NVL(J.PorcResPago,0)/100;
                        nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) / nNumPagos) * NVL(J.PorcResPago,0)/100;
                     END IF;
                     /*nAsistRestLocal  := NVL(nAsistRestLocal,0) + (NVL(K.MontoAsistLocal,0) * NVL(J.PorcResPago,0)/100) - nMtoAsistLocal;
                     nAsistRestMoneda := NVL(nAsistRestMoneda,0) + (NVL(K.MontoAsistMoneda,0) * NVL(J.PorcResPago,0)/100) - nMtoAsistMoneda;
                     IF NP > 1 THEN
                        nMtoAsistLocal  := (NVL(nAsistRestLocal,0) / (nNumPagos - 1));
                        nMtoAsistMoneda := (NVL(nAsistRestMoneda,0) / (nNumPagos - 1));
                     END IF;*/
                     nTotAsistLocal  := NVL(nTotAsistLocal,0) + NVL(nMtoAsistLocal,0);
                     nTotAsistMoneda := NVL(nTotAsistMoneda,0) + NVL(nMtoAsistMoneda,0);
                     OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
                     OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
                  END LOOP;

                  nMtoT := nMtoT + nMtoPago;-- + NVL(nTotAsistLocal,0);
                  nMtoTM:= nMtoTM + nMtoPagoMoneda;-- + NVL(nTotAsistMoneda,0);
                  -- Genera comisiones por agente por certificado
                  PROC_COMISIONAG (nIdPoliza, X.IdetPol, nCodCia, nCodEmpresa, X.IdTipoSeg,
                                   cCodMoneda, nIdFactura, nMtoPago, nMtoPagoMoneda, nTasaCambio);

                  -- PROC_COMISIONAG (nIdPoliza, X.IdetPol, nCodCia, nCodEmpresa, X.IdTipoSeg,
                    --                cCodMoneda, nIdFactura, nMtot, nMtoTM, nTasaCambio);
                  -- Distribuye la comision por agente.
                  FOR Y IN CPTO_PLAN_Q LOOP
                     BEGIN
                        SELECT 'S'
                          INTO cGraba
                          FROM RAMOS_CONCEPTOS_PLAN
                         WHERE CodPlanPago = cCodPlanPago
                           AND CodCpto     = Y.CodCpto
                           AND CodCia      = nCodCia
                           AND CodEmpresa  = nCodEmpresa
                           AND IdTipoSeg   = X.IdTipoSeg;
                     EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                           cGraba := 'N';
                        WHEN TOO_MANY_ROWS THEN
                           cGraba := 'S';
                     END;
                     IF cGraba = 'S' THEN
                        IF Y.IndRangosTipseg = 'S' THEN
                           IF X.IndCalcDerechoEmis = 'S' THEN
                              OC_CATALOGO_CONCEPTOS_RANGOS.VALOR_CONCEPTO(nCodCia, nCodEmpresa, Y.CodCpto, X.IdTipoSeg,
                                                                          nIdPoliza, X.IdetPol, nIdEndoso, nMtoCpto, nPorcCpto);
                              IF OC_DETALLE_FACTURAS.EXISTE_CONCEPTO(nCodCia, nIdPoliza, nTransa, Y.CodCpto) = 'N' THEN
                                 IF NVL(nMtoCpto,0) = 0 AND NVL(nPorcCpto,0) = 0 THEN
                                    nMtoCpto  := Y.MtoCpto;
                                    nPorcCpto := Y.PorcCpto;
                                 END IF;
                              ELSE
                                 nMtoCpto  := 0;
                                 nPorcCpto := 0;
                              END IF;
                           ELSE
                              nMtoCpto  := 0;
                              nPorcCpto := 0;
                           END IF;
                        ELSE
                           nMtoCpto  := Y.MtoCpto;
                           nPorcCpto := Y.PorcCpto;
                        END IF;
                        IF Y.Aplica = 'P' THEN
                           IF NVL(nMtoCpto,0) <> 0 AND NP = 1 THEN
                              nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                           ELSIF NP = 1 THEN
                              nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                              nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                           ELSE
                              nMtoDet       := 0;
                              nMtoDetMoneda := 0;
                           END IF;
                           IF NVL(nMtoDet,0) != 0 THEN
                              OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                              OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                              nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                              nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                           END IF;
                        ELSIF Y.Aplica = 'T' THEN
                           IF NVL(nMtoCpto,0) <> 0 THEN
                              nMtoDet       := NVL(nMtoCpto,0);
                              nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio ;
                           ELSE
                              nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                              nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                           END IF;
                           IF NVL(nMtoDet,0) != 0 THEN
                              OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                              OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                              nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                              nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                           END IF;
                        END IF;
                        nMtoT := nMtoT + nMtoDet;
                     END IF;
                  END LOOP;
                  OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
               END LOOP;
               IF NVL(J.PorcResPago,0) != 0 THEN
                  IF (NVL(X.PrimaLocal,0) * NVL(J.PorcResPago,0) + nMtoRecD_Local - nMtoDescD_Local +
                      NVL(nRec_Local,0) - NVL(nDesc_Local,0)) <> NVL(nTotPrimas,0) THEN
                     nDifer       := (((NVL(X.PrimaLocal,0)* NVL(J.PorcResPago,0))/100 + nMtoRecD_Local - nMtoDescD_Local +
                                        NVL(nRec_Local,0) - NVL(nDesc_Local,0))) - NVL(nTotPrimas,0);
                     nDiferMoneda := (((NVL(X.PrimaMoneda,0)* NVL(J.PorcResPago,0))/100+ nMtoRecD_Moneda - nMtoDescD_Moneda +
                                        NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0))) - NVL(nTotPrimasMoneda,0);

                     OC_DETALLE_FACTURAS.ACTUALIZA_DIFERENCIA(nIdFactura, nDifer, nDiferMoneda);

                     OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
                  END IF;
               END IF;
               nMtoT := nMtoT + nMtoTotal;
            END LOOP;
            BEGIN
               SELECT SUM(Comision_Local)
                 INTO nTotComi
                 FROM COMISIONES C
                WHERE IdPoliza  = nIdPoliza
                  AND EXISTS (SELECT 1
                                FROM FACTURAS F
                               WHERE F.IdFactura     = C.IdFactura
                                 AND F.IdTransaccion = nTransa);
            END;
            OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'FAC', 'FACTURAS',
                                         nIdFactura, X.IdetPol, NULL, NULL, nMtoT);

            OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'COM', 'COMISIONES',
                                         nIdFactura, X.IdetPol, NULL, NULL, nTotComi);
         ELSE
            RAISE_APPLICATION_ERROR (-20100,'Error');
         END IF;
      END IF;
      OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
   END LOOP;

   BEGIN
      SELECT Contabilidad_Automatica
        INTO cContabilidad_Automatica
        FROM EMPRESAS
       WHERE CodCia = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cContabilidad_Automatica := 'N';
   END;
   IF cContabilidad_Automatica = 'S' THEN
      PROC_MOVCONTA(nCodCia, nIdPoliza, cCodMoneda, 'EMI');
   END IF;
END PROC_EMITE_FACTURAS;

PROCEDURE PROC_EMITE_FACT_POL(nIdPoliza NUMBER, nIdEndoso NUMBER, pCodCia NUMBER, nTransa NUMBER) IS
nIdFactura               FACTURAS.IdFactura%TYPE;
nNumPagos                PLAN_DE_PAGOS.NumPagos%TYPE;
nFrecPagos               PLAN_DE_PAGOS.FrecPagos%TYPE;
nPorcInicial             PLAN_DE_PAGOS.PorcInicial%TYPE;
nCodCliente              POLIZAS.CodCliente%TYPE;
cIdTipoSeg               DETALLE_POLIZA.IdTipoSeg%TYPE;
nTotPrimas               DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDifer                   DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDiferMoneda             DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoDet                  DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoDetMoneda            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoTotal                DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoTotalMoneda          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cCodMoneda               POLIZAS.Cod_Moneda%TYPE;
nPrimaNetaMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoPagoMoneda           FACTURAS.Monto_Fact_Moneda%TYPE;
cCodMonedaLocal          EMPRESAS.Cod_Moneda%TYPE;
nPrimaRestMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoComisiMoneda         FACTURAS.MtoComisi_Local%TYPE;
nTotPrimasMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nCodCia                  POLIZAS.CodCia%TYPE;
nCodEmpresa              POLIZAS.CodEmpresa%TYPE;
cCodPlanPago             DETALLE_POLIZA.CodPlanPago%TYPE;
nTasaCambio              DETALLE_POLIZA.Tasa_Cambio%TYPE;
nMtoCpto                 CONCEPTOS_PLAN_DE_PAGOS.MtoCpto%TYPE;
nPorcCpto                CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
cAplica                  CONCEPTOS_PLAN_DE_PAGOS.Aplica%TYPE;
Dummy                    NUMBER(5);
dFecPago                 DATE;
nMtoPago                 NUMBER(18,2);
nMtoComisi               NUMBER(18,2);
nPrimaRest               NUMBER(18,2);
dFecHoy                  DATE;
cGraba                   VARCHAR2(1);
nCod_Agente              AGENTES_DETALLES_POLIZAS.Cod_Agente%TYPE;
nMtoRecD_Local           DETALLE_RECARGO.Monto_Local%TYPE;
nMtoRecD_Moneda          DETALLE_RECARGO.Monto_Moneda%TYPE;
nMtoDescD_Local          DETALLE_DESCUENTO.Monto_Local%TYPE;
nMtoDescD_Moneda         DETALLE_DESCUENTO.Monto_Moneda%TYPE;
nMtoRec_Local            RECARGOS.Monto_Local%TYPE;
nMtoRec_Moneda           RECARGOS.Monto_Moneda%TYPE;
nMtoDesc_Local           DESCUENTOS.Monto_Local%TYPE;
nMtoDesc_Moneda          DESCUENTOS.Monto_Moneda%TYPE;
nPrimaTotalM             DETALLE_POLIZA.Prima_Moneda%TYPE;
nPrimaTotalL             DETALLE_POLIZA.Prima_Local%TYPE;
nFactor                  NUMBER (14,8);
nRec_Local               RECARGOS.Monto_Local%TYPE ;
nRec_Moneda              RECARGOS.Monto_Moneda%TYPE;
nDesc_Local              DESCUENTOS.Monto_Local%TYPE;
nDesc_Moneda             DESCUENTOS.Monto_Moneda%TYPE;
cCodPlanPagoPol          POLIZAS.CodPlanPago%TYPE;
nPorcComis               DETALLE_POLIZA.PorcComis%TYPE;
nNumCert                 DETALLE_POLIZA.IdetPol%TYPE;
nPrimaLocal              NUMBER(18,2);
nPrimaMoneda             NUMBER(18,2);
nIdTransac               NUMBER(14,0);
nMtoComisiRest           NUMBER(18,2);
nMtoComisiMonedaRest     NUMBER(18,2);
nMtoComisiPag            NUMBER(18,2);
nMtoComisiMonedaPag      NUMBER(18,2);
nMtoComiTot              NUMBER(18,2);
nMtoComisiMonedaTot      NUMBER(18,2);
nMtoComiL                NUMBER(18,2);
nMtoComisiM              NUMBER(18,2);
nDiferC                  DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDiferCMon               DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cRespPol                 VARCHAR2(1):='N';
cRespDet                 VARCHAR2(1):='N';
nPorcT                   NUMBER(18,2);
nFact                    NUMBER(18,2);
nCodTipoDoc              TIPO_DE_DOCUMENTO.CodTipoDoc%TYPE;
nIdetPol                 DETALLE_POLIZA.IdetPol%TYPE := 0;
cContabilidad_Automatica EMPRESAS.Contabilidad_Automatica%TYPE;
nIdTranc                 TRANSACCION.idtransaccion%TYPE;
nMtoT                    FACTURAS.monto_fact_local%TYPE := 0;
nMtoTM                   FACTURAS.monto_fact_local%TYPE := 0;
nMtoAsistLocal           ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nMtoAsistMoneda          ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
nAsistRestLocal          ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nAsistRestMoneda         ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
nTotAsistLocal           ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nTotAsistMoneda          ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
cIndFactElectronica      POLIZAS.IndFactElectronica%TYPE;
cIndCalcDerechoEmis      POLIZAS.IndCalcDerechoEmis%TYPE;
nCantPagosReal           NUMBER(5);
fFecfinvig               FACTURAS.FECFINVIG%TYPE;      -- ICOFINVIG

CURSOR DET_POL_Q IS
   SELECT D.Prima_Local PrimaLocal, D.Prima_Moneda PrimaMoneda, D.CodPlanPago, D.PorcComis,
          P.FecIniVig, P.FecFinVig, P.FecEmision, D.IDetPol, D.Tasa_Cambio, D.IdTipoSeg
     FROM DETALLE_POLIZA D, POLIZAS P
    WHERE D.Prima_Moneda  > 0
      AND D.IdPoliza      = P.IdPoliza
      AND P.StsPoliza    IN  ('SOL','XRE')
      AND P.IdPoliza      = nIdPoliza
    ORDER BY D.IDetPol;

CURSOR CPTO_PLAN_Q IS
   SELECT CP.CodCpto, CP.PorcCpto, CP.Aplica, CP.MtoCpto,
          CC.IndRangosTipseg
     FROM CONCEPTOS_PLAN_DE_PAGOS CP, CATALOGO_DE_CONCEPTOS CC
    WHERE CC.IndCptoAjuste = 'N'
      AND CC.IndCptoPrimas = 'N'
      AND CC.CodConcepto   = CP.CodCpto
      AND CC.CodCia        = CP.CodCia
      AND CP.CodCia        = pCodCia
      AND CP.CodEmpresa    = nCodEmpresa
      AND CP.CodPlanPago   = cCodPlanPago
      AND EXISTS (SELECT 'S'
                    FROM RAMOS_CONCEPTOS_PLAN
                   WHERE CodCia      = CP.CodCia
                     AND CodEmpresa  = CP.CodEmpresa
                     AND IdTipoSeg  IN (SELECT IdTipoSeg
                                          FROM DETALLE_POLIZA
                                         WHERE IdPoliza  = nIdPoliza)
                     AND CodCpto     = CP.CodCpto
                     AND CodPlanPago = CP.CodPlanPago)
    ORDER BY CP.Prioridad;

CURSOR RESP_PAGO IS
  SELECT R.CodResPago
    FROM RESPONSABLE_PAGO_DET R
   WHERE R.IdPoliza    = nIdPoliza
     AND R.CodCia      = pCodCia
     AND R.CodEmpresa  = nCodEmpresa
   GROUP BY R.CodResPago;

CURSOR CPTO_PRIMAS_Q IS
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERT_ACT C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert  = C.CodCobert
      AND CS.PlanCob    = C.PlanCob
      AND CS.IdTipoSeg  = C.IdTipoSeg
      AND CS.CodEmpresa = C.CodEmpresa
      AND CS.CodCia     = C.CodCia
      AND C.StsCobertura IN ('EMI','SOL','XRE')
      AND C.IdPoliza    = nIdPoliza
      AND C.CodCia      = pCodCia
    GROUP BY CS.CodCpto
    UNION ALL
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERT_ACT_ASEG C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert  = C.CodCobert
      AND CS.PlanCob    = C.PlanCob
      AND CS.IdTipoSeg  = C.IdTipoSeg
      AND CS.CodEmpresa = C.CodEmpresa
      AND CS.CodCia     = C.CodCia
      AND C.StsCobertura IN ('EMI','SOL','XRE')
      AND C.IdPoliza    = nIdPoliza
      AND C.CodCia      = pCodCia
    GROUP BY CS.CodCpto;
CURSOR CPTO_ASIST_Q IS
   SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
          SUM(A.MontoAsistMoneda) MontoAsistMoneda
     FROM ASISTENCIAS_DETALLE_POLIZA A, DETALLE_POLIZA D, ASISTENCIAS T
    WHERE T.CodAsistencia  = A.CodAsistencia
      AND D.IDetPol        = A.IDetPol
      AND D.IdPoliza       = A.IdPoliza
      AND D.CodCia         = A.CodCia
      AND A.StsAsistencia IN ('EMITID','SOLICI','XRENOV')
      AND A.IdPoliza       = nIdPoliza
      AND A.CodCia         = pCodCia
    GROUP BY T.CodCptoServicio
  UNION ALL
   SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
          SUM(A.MontoAsistMoneda) MontoAsistMoneda
     FROM ASISTENCIAS_ASEGURADO A, DETALLE_POLIZA D, ASISTENCIAS T
    WHERE T.CodAsistencia  = A.CodAsistencia
      AND D.IDetPol        = A.IDetPol
      AND D.IdPoliza       = A.IdPoliza
      AND D.CodCia         = A.CodCia
      AND A.StsAsistencia IN ('EMITID','SOLICI','XRENOV')
      AND A.IdPoliza       = nIdPoliza
      AND A.CodCia         = pCodCia
    GROUP BY T.CodCptoServicio;
BEGIN
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
  BEGIN
      SELECT CodCliente, Cod_Moneda, CodCia, CodEmpresa,
             CodPlanPago, IndFactElectronica, IndCalcDerechoEmis
        INTO nCodCliente, cCodMoneda, nCodCia, nCodEmpresa,
             cCodPlanPagoPol, cIndFactElectronica, cIndCalcDerechoEmis
        FROM POLIZAS
       WHERE IdPoliza = nIdPoliza;
    END;
    BEGIN
       SELECT Cod_Moneda
         INTO cCodMonedaLocal
         FROM EMPRESAS
        WHERE CodCia = nCodCia;
  END;
  BEGIN
     SELECT SUM(D.Prima_Local) PrimaLocal, SUM(D.Prima_Moneda) PrimaMoneda, COUNT(IdetPol)
       INTO nPrimaTotalL, nPrimaTotalM, nNumCert
       FROM DETALLE_POLIZA D, POLIZAS P
      WHERE D.Prima_Moneda  > 0
        AND D.IdPoliza   = P.IdPoliza
        AND P.StsPoliza IN ('SOL','XRE')
        AND P.IdPoliza   = nIdPoliza;
   END;

   BEGIN
      SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
        INTO nMtoRec_Local, nMtoRec_Moneda
        FROM RECARGOS
       WHERE IdPoliza = nIdPoliza
         AND Estado   = 'ACT';
   EXCEPTION
      WHEN OTHERS THEN
         nMtoRec_Local  := 0;
         nMtoRec_Moneda := 0;
   END;
   BEGIN
      SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
        INTO nMtoDesc_Local, nMtoDesc_Moneda
        FROM DESCUENTOS
       WHERE IdPoliza  = nIdPoliza
         AND Estado    = 'ACT';
   EXCEPTION
      WHEN OTHERS THEN
         nMtoDesc_Local  := 0;
         nMtoDesc_Moneda := 0;
   END;
   -- Caracteristicas del Plan de Pago
   BEGIN
      SELECT NumPagos, FrecPagos, PorcInicial
        INTO nNumPagos, nFrecPagos, nPorcInicial
        FROM PLAN_DE_PAGOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodPlanPago = cCodPlanPagoPol;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'No Existe Plan de Pagos '||cCodPlanPagoPol);
   END;
   BEGIN
      SELECT 'S'
        INTO cRespPol
        FROM RESPONSABLE_PAGO_POL
       WHERE StsResPago = 'ACT'
         AND CodCia     = pCodCia
         AND IdPoliza   = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cRespPol := 'N';
      WHEN TOO_MANY_ROWS THEN
         cRespPol := 'S';
   END;
   IF cRespPol = 'S' AND FUNC_VALIDA_RESP_POL (nIdPoliza,pCodCia) = 'S' THEN
      PROC_INSERT_RESP_D (nIdPoliza,pCodCia);
   END IF;
   BEGIN
      SELECT 'S'
        INTO cRespDet
        FROM RESPONSABLE_PAGO_DET R
       WHERE R.IdPoliza    = nIdPoliza
         AND R.CodCia      = pCodCia
         AND R.CodEmpresa  = nCodEmpresa;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cRespDet:='N';
      WHEN TOO_MANY_ROWS THEN
         cRespDet:='S';
   END;
   IF cRespPol = 'N' AND cRespDet = 'N' THEN
      FOR X IN DET_POL_Q LOOP
         IF NVL(nIDetPol,0) = 0 THEN
            nIDetPol  := X.IDetPol;
         END IF;
         cIdTipoSeg := X.IdTipoSeg;
         BEGIN
            SELECT Cod_Agente
              INTO nCod_Agente
              FROM AGENTES_DETALLES_POLIZAS
             WHERE IdPoliza      = nIdPoliza
               AND IdetPol       = X.IdetPol
               AND IdTipoSeg     = X.IdTipoSeg
               AND Ind_Principal = 'S';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR (-20100,'No Existe un Agente Definido para el Tipo de Seguro '||X.IdTipoSeg);
            WHEN TOO_MANY_ROWS THEN
               RAISE_APPLICATION_ERROR (-20100,'Existe Mas de un Agente Definido como Principal');
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR (-20100,'Existe un error de otros');
         END;
         cCodPlanPago := X.CodPlanPago;
         nMtoT        := 0;

         OC_DETALLE_TRANSACCION.CREA (nTransa,nCodCia,nCodEmpresa,7,'CER', 'DETALLE_POLIZA',
                                      nIdPoliza, X.IdetPol, NULL, NULL, X.PrimaLocal);

         IF nMtoRec_Local != 0 OR nMtoRec_Moneda != 0 OR nMtoDesc_Local != 0 OR nMtoDesc_Moneda != 0 THEN
            nFactor      := (X.PrimaLocal    / NVL(nPrimaTotalL,0)) * 100;
            nRec_Local   := (nMtoRec_Local  * nFactor) / 100;
            nRec_Moneda  := (nMtoRec_Moneda * nFactor) / 100;
            nDesc_Local  := (nMtoDesc_Local * nFactor) / 100;
            nDesc_Moneda := (nMtoDesc_Moneda * nFactor)/ 100;
         END IF;
         IF nIdEndoso = 0 THEN
            nTasaCambio := X.Tasa_Cambio;
         ELSE
            nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
         END IF;

         -- Determina Meses de Vigencia para Plan de Pagos
         IF nNumPagos <= 12 THEN
            nCantPagosReal  := FLOOR(MONTHS_BETWEEN(X.FecFinVig, X.FecIniVig) / nFrecPagos);
         ELSE
            nCantPagosReal  := FLOOR((X.FecFinVig - X.FecIniVig) / nFrecPagos);
         END IF;
         IF nCantPagosReal <= 0 THEN
            nCantPagosReal := 1;
         END IF;
         IF nCantPagosReal < nNumPagos THEN
            nNumPagos := nCantPagosReal;
         END IF;

         -- Fecha del Primer Pago Siempre a Inicio de Vigencia
         dFecPago := X.FecIniVig;
         /*IF X.FecIniVig > X.FecEmision THEN
            dFecPago := X.FecIniVig;
         ELSE
            dFecPago := X.FecEmision;
         END IF;*/
         -- Monto del Primer Pago
         nTotPrimas       := 0;
         nTotPrimasMoneda := 0;
         nMtoComisi       := 0;
         nMtoComisiMoneda := 0;
         BEGIN
            SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
              INTO nMtoRecD_Local, nMtoRecD_Moneda
              FROM DETALLE_RECARGO
             WHERE IdPoliza = nIdPoliza
               AND IDetPol  = X.IDetPol
               AND Estado   = 'ACT';
         EXCEPTION
            WHEN OTHERS THEN
               nMtoRecD_Local  := 0;
               nMtoRecD_Moneda := 0;
         END;
         BEGIN
            SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
              INTO nMtoDescD_Local, nMtoDescD_Moneda
              FROM DETALLE_DESCUENTO
             WHERE IdPoliza  = nIdPoliza
               AND IDetPol   = X.IDetPol
               AND Estado    = 'ACT';
         EXCEPTION
            WHEN OTHERS THEN
               nMtoDescD_Local  := 0;
               nMtoDescD_Moneda := 0;
         END;

         IF NVL(nPorcInicial,0) <> 0 THEN

            nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0))  * nPorcInicial / 100  ;
            nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) * nPorcInicial / 100 ;
            nMtoComisiPag       := NVL(nMtoComisiPag,0)       + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100) * nPorcInicial / 100 );
            nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + ((NVL(X.PrimaMoneda,0)* X.PorcComis / 100) * nPorcInicial / 100) ;
         ELSE
            nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local    - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) / nNumPagos  ;
            nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda   - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) /nNumPagos ;
            nMtoComisiPag       := nvl(nMtoComisiPag,0)              + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100) / nNumPagos ;
            nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100) / nNumPagos ;
         END IF;

         nPrimaRest           := NVL(nPrimaRest,0)           + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) - NVL(nMtoPago,0);
         nMtoComisiRest       := NVL(nMtoComisiRest,0)       + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100 ) -  NVL(nMtoComisiPag,0));
         nTotPrimas           := NVL(nTotPrimas,0)           + NVL(nMtoPago,0);
         nMtoComisi           := NVL(nMtoComisi,0)           + NVL(nMtoComisiPag,0);
         nPrimaRestMoneda     := NVL(nPrimaRestMoneda,0)     + (NVL(X.PrimaMoneda,0)  + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) - NVL(nMtoPagoMoneda,0);
         nMtoComisiMonedaRest := NVL(nMtoComisiMonedaRest,0) + ((NVL(X.PrimaMoneda,0) * X.PorcComis / 100) -   NVL(nMtoComisiMonedaPag,0));
         nMtoComisiMoneda     := NVL(nMtoComisiMoneda,0)     + NVL(nMtoComisiMonedaPag,0);
         nTotPrimasMoneda     := NVL(nTotPrimasMoneda,0)     + NVL(nMtoPagoMoneda,0);
         nPrimaMoneda         := NVL(nPrimaMoneda,0)         + NVL(X.PrimaMoneda,0);
         nPrimaLocal          := NVL(nPrimaLocal,0)          + NVL(X.PrimaLocal,0) ;
         nMtoComiL            := NVL(nMtoComiL,0)            + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100) ;
         nMtoComisiM          := NVL(nMtoComisiM,0)          + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100) ;
      END LOOP;
      nPrimaRest           := NVL(nPrimaLocal,0)  - NVL(nMtoPago,0);
      nPrimaRestMoneda     := NVL(nPrimaMoneda,0) - NVL(nMtoPagoMoneda,0);
      nMtoComisiRest       := NVL(nMtoComiL,0)    - NVL(nMtoComisiPag,0);
      nMtoComisiMonedaRest := NVL(nMtoComisiM,0)  - NVL(nMtoComisiMonedaPag,0);
      IF NVL(nMtoPagoMoneda,0) != 0 THEN
      
         FOR NP IN 1..nNumPagos LOOP
            IF NP > 1 THEN
               nMtoPago            := NVL(nPrimaRest,0)     / (nNumPagos - 1);
               nMtoComisiPag       := NVL(nMtoComisiRest,0) / (nNumPagos - 1);
               nTotPrimas          := NVL(nTotPrimas,0) + NVL(nMtoPago,0);
               nMtoComisi          := NVL(nMtoComisi,0) + NVL(nMtoComisiPag,0);
               IF nFrecPagos NOT IN (15,7) THEN
                  dFecPago         := ADD_MONTHS(dFecPago,nFrecPagos);
               ELSE
                  dFecPago         := dFecPago + nFrecPagos;
               END IF;
               nMtoPagoMoneda      := NVL(nPrimaRestMoneda,0)     / (nNumPagos - 1);
               nTotPrimasMoneda    := NVL(nTotPrimasMoneda,0)     +  NVL(nMtoPagoMoneda,0);
               nMtoComisiMonedaPag := NVL(nMtoComisiMonedaRest,0) / (nNumPagos - 1);
               nMtoComisiMoneda    := NVL(nMtoComisiMoneda,0) + NVL(nMtoComisiMonedaPag,0);
            END IF;
            -- LARPLA
            nIdFactura := OC_FACTURAS.INSERTAR(nIdPoliza,           nIDetPol,       nCodCliente, dFecPago, 
                                               nMtoPago,            nMtoPagoMoneda, nIdEndoso,   nMtoComisiPag, 
                                               nMtoComisiMonedaPag, NP,             nTasaCambio, nCod_Agente,
                                               nCodTipoDoc,         pCodCia,        cCodMoneda,  NULL, 
                                               nTransa,             cIndFactElectronica);

            FOR W IN CPTO_PRIMAS_Q LOOP
               nFactor := W.Prima_Local / NVL(nPrimaLocal,0);
               OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
               OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
            END LOOP;

            nTotAsistLocal  := 0;
            nTotAsistMoneda := 0;
            FOR K IN CPTO_ASIST_Q LOOP
               nAsistRestLocal  := 0;
               nAsistRestMoneda := 0;
               IF NVL(nPorcInicial,0) <> 0 THEN
                  nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) * nPorcInicial / 100);
                  nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) * nPorcInicial / 100);
               ELSE
                  nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) / nNumPagos);
                  nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) / nNumPagos);
               END IF;
               /*nAsistRestLocal  := NVL(nAsistRestLocal,0) + NVL(K.MontoAsistLocal,0) - nMtoAsistLocal;
               nAsistRestMoneda := NVL(nAsistRestMoneda,0) + NVL(K.MontoAsistMoneda,0) - nMtoAsistMoneda;
               IF NP > 1 THEN
                  nMtoAsistLocal  := (NVL(nAsistRestLocal,0) / (nNumPagos - 1));
                  nMtoAsistMoneda := (NVL(nAsistRestMoneda,0) / (nNumPagos - 1));
               END IF;*/
               nTotAsistLocal  := NVL(nTotAsistLocal,0) + NVL(nMtoAsistLocal,0);
               nTotAsistMoneda := NVL(nTotAsistMoneda,0) + NVL(nMtoAsistMoneda,0);
               OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
               OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
               OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
            END LOOP;

            nMtoT := nMtoT + nMtoPago;-- + nTotAsistLocal;
            nMtoTM:= nMtoTM + nMtoPagoMoneda;-- + NVL(nTotAsistMoneda,0);

            -- Genera comisiones por agente por Poliza
            PROC_COMISIONPOL (nIdPoliza, nIDetPol, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFactura,
                              nMtoComisiPag/nNumCert, nMtoComisiMonedaPag/nNumCert, nTasaCambio);

           -- Distribuye la comision por agente.
            FOR Y IN CPTO_PLAN_Q LOOP
               BEGIN
                  SELECT 'S'
                    INTO cGraba
                    FROM RAMOS_CONCEPTOS_PLAN R
                   WHERE R.CodPlanPago = cCodPlanPago
                     AND R.CodCpto     = Y.CodCpto
                     AND R.CodCia      = nCodCia
                     AND R.CodEmpresa  = nCodEmpresa
                     AND EXISTS   (SELECT 1
                                     FROM DETALLE_POLIZA D, POLIZAS P
                                    WHERE D.IdPoliza   = P.IdPoliza
                                      AND D.IdTipoSeg  = R.IdTipoSeg
                                      AND P.StsPoliza IN ('SOL','XRE')
                                      AND P.IdPoliza   = nIdPoliza);
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     cGraba := 'N';
                  WHEN TOO_MANY_ROWS THEN
                     cGraba := 'S';
               END;

               IF cGraba = 'S' THEN
                  IF Y.IndRangosTipseg = 'S' THEN
                     IF cIndCalcDerechoEmis = 'S' THEN
                        OC_CATALOGO_CONCEPTOS_RANGOS.VALOR_CONCEPTO(nCodCia, nCodEmpresa, Y.CodCpto, cIdTipoSeg,
                                                                    nIdPoliza, 0, nIdEndoso, nMtoCpto, nPorcCpto);
                        IF OC_DETALLE_FACTURAS.EXISTE_CONCEPTO(nCodCia, nIdPoliza, nTransa, Y.CodCpto) = 'N' THEN
                           IF NVL(nMtoCpto,0) = 0 AND NVL(nPorcCpto,0) = 0 THEN
                              nMtoCpto  := Y.MtoCpto;
                              nPorcCpto := Y.PorcCpto;
                           END IF;
                        ELSE
                           nMtoCpto  := 0;
                           nPorcCpto := 0;
                        END IF;
                     ELSE
                        nMtoCpto  := 0;
                        nPorcCpto := 0;
                     END IF;
                  ELSE
                     nMtoCpto  := Y.MtoCpto;
                     nPorcCpto := Y.PorcCpto;
                  END IF;
                  IF Y.Aplica = 'P' THEN
                     IF NVL(nMtoCpto,0) <> 0 AND NP = 1 THEN
                        nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                     ELSIF NP = 1 THEN
                        nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                        nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                     ELSE
                        nMtoDet       := 0;
                        nMtoDetMoneda := 0;
                     END IF;
                     IF NVL(nMtoDet,0) != 0 THEN
                        OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                        nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                     END IF;
                  ELSIF Y.Aplica = 'T' THEN
                     IF NVL(nMtoCpto,0) <> 0 THEN
                        nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                     ELSE
                        nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                        nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                     END IF;
                     IF NVL(nMtoDet,0) != 0 THEN
                        OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                        nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                     END IF;
                  END IF;
                  nMtoT := nMtoT + nMtoDet;
               END IF;
            END LOOP;
            OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
            OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
         END LOOP;
         OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'FAC', 'FACTURAS',
                                      nIdPoliza, nIdetPol, NULL, NULL, nMtoT);
         OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'COM', 'COMISIONES',
                                      nIdPoliza, nIdetPol, NULL, NULL, nMtoComisiPag);

         IF (NVL(nPrimaLocal,0) + nMtoRecD_Local - nMtoDescD_Local +
             NVL(nRec_Local,0) - NVL(nDesc_Local,0)) <> NVL(nTotPrimas,0) THEN
            nDifer       := (NVL(nPrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local   +
                             NVL(nRec_Local,0)  - NVL(nDesc_Local,0)) - NVL(nTotPrimas,0);
            nDiferMoneda := (NVL(nPrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda  +
                             NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) - NVL(nTotPrimasMoneda,0);
            nDiferC      :=  NVL(nMtoComiL,0)   - NVL(nMtoComisi,0);
            nDiferCMon   :=  NVL(nMtoComisiM,0) - NVL(nMtoComisiMoneda,0);
  -- Esta llamada generaba un registro adicional en el calculo de comisiones.
  -- OC24
  --          PROC_COMISIONPOL (nIdPoliza, nIDetPol, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFactura,
  --                            nDiferC/nNumCert, nDiferCMon/nNumCert, nTasaCambio);

            OC_DETALLE_FACTURAS.ACTUALIZA_DIFERENCIA(nIdFactura, nDifer, nDiferMoneda);

            OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
            OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');

            UPDATE FACTURAS
               SET MtoComisi_Local   = MtoComisi_Local   + NVL(nDiferC,0),
                   MtoComisi_Moneda  = MtoComisi_Moneda  + NVL(nDiferCMon,0)
             WHERE IdFactura = nIdFactura;
         END IF;
      END IF;
   ELSE
      BEGIN
         SELECT SUM(R.PorcResPago)
           INTO nPorcT
           FROM RESPONSABLE_PAGO_DET R
          WHERE R.IdPoliza    = nIdPoliza
            AND R.CodCia      = nCodCia
            AND R.CodEmpresa  = nCodEmpresa ;
      END;
      FOR J IN RESP_PAGO LOOP
         BEGIN
            SELECT (SUM(PORCRESPAGO)/nPorcT) * 100
              INTO nFact
              FROM RESPONSABLE_PAGO_DET r
             WHERE R.IdPoliza    = nIdPoliza
               AND R.CodCia      = nCodCia
               AND R.CodEmpresa  = nCodEmpresa
               AND R.CodResPago  = J.CodResPago;
         END;
         nMtoPago             := 0;
         nMtoPagoMoneda       := 0;
         nMtoComisiPag        := 0;
         nMtoComisiMonedaPag  := 0;
         nPrimaRest           := 0;
         nMtoComisiRest       := 0;
         nTotPrimas           := 0;
         nMtoComisi           := 0;
         nPrimaRestMoneda     := 0;
         nMtoComisiMonedaRest := 0;
         nMtoComisiMoneda     := 0;
         nTotPrimasMoneda     := 0;
         nPrimaMoneda         := 0;
         nPrimaLocal          := 0;
         nMtoComiL            := 0;
         nMtoComisiM          := 0;
         FOR X IN DET_POL_Q LOOP
            cIdTipoSeg := X.IdTipoSeg;
            BEGIN
               SELECT Cod_Agente
                 INTO nCod_Agente
                 FROM AGENTES_DETALLES_POLIZAS
                WHERE IdPoliza      = nIdPoliza
                  AND IdetPol       = X.IdetPol
                  AND IdTipoSeg     = X.IdTipoSeg
                  AND Ind_Principal = 'S';
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR (-20100,'No Existe un Agente Definido para el Tipo de Seguro '||X.IdTipoSeg);
               WHEN TOO_MANY_ROWS THEN
                  RAISE_APPLICATION_ERROR (-20100,'Existe Mas de un Agente Definido como Principal');
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR (-20100,'Existe un error de otros');
            END;
            cCodPlanPago := X.CodPlanPago;
            IF nMtoRec_Local != 0 OR nMtoRec_Moneda != 0 OR nMtoDesc_Local != 0 OR nMtoDesc_Moneda != 0 THEN
               nFactor      := (X.PrimaLocal * NVL(nFact,0)/100) / NVL(nPrimaTotalL,0) * 100;
               nRec_Local   := (nMtoRec_Local  * nFactor) / 100;
               nRec_Moneda  := (nMtoRec_Moneda * nFactor) / 100;
               nDesc_Local  := (nMtoDesc_Local * nFactor) / 100;
               nDesc_Moneda := (nMtoDesc_Moneda * nFactor)/ 100;
            END IF;
            IF nIdEndoso = 0 THEN
               nTasaCambio := X.Tasa_Cambio;
            ELSE
               nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
            END IF;

            -- Determina Meses de Vigencia para Plan de Pagos
            IF nNumPagos <= 12 THEN
               nCantPagosReal  := FLOOR(MONTHS_BETWEEN(X.FecFinVig, X.FecIniVig) / nFrecPagos);
            ELSE
               nCantPagosReal  := FLOOR((X.FecFinVig - X.FecIniVig) / nFrecPagos);
            END IF;

            IF nCantPagosReal <= 0 THEN
               nCantPagosReal := 1;
            END IF;
            IF nCantPagosReal < nNumPagos THEN
               nNumPagos := nCantPagosReal;
            END IF;

            -- Fecha del Primer Pago Siempre a Inicio de Vigencia
            dFecPago := X.FecIniVig;
            /*IF X.FecIniVig > X.FecEmision THEN
               dFecPago := X.FecIniVig;
            ELSE
               dFecPago := X.FecEmision;
            END IF;*/
                -- Monto del Primer Pago
            nTotPrimas       := 0;
            nTotPrimasMoneda := 0;
            nMtoComisi       := 0;
            nMtoComisiMoneda := 0;
            BEGIN
               SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
                 INTO nMtoRecD_Local, nMtoRecD_Moneda
                 FROM DETALLE_RECARGO
                WHERE IdPoliza = nIdPoliza
                  AND IDetPol  = X.IDetPol
                  AND Estado   = 'ACT';
            EXCEPTION
               WHEN OTHERS THEN
                  nMtoRecD_Local  := 0;
                  nMtoRecD_Moneda := 0;
            END;
            BEGIN
               SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
                 INTO nMtoDescD_Local, nMtoDescD_Moneda
                 FROM DETALLE_DESCUENTO
                WHERE IdPoliza  = nIdPoliza
                  AND IDetPol   = X.IDetPol
                  AND Estado    = 'ACT';
            EXCEPTION
               WHEN OTHERS THEN
                  nMtoDescD_Local  := 0;
                  nMtoDescD_Moneda := 0;
            END;

            IF NVL(nPorcInicial,0) <> 0 THEN
               nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0))  * nPorcInicial / 100 * NVL(nFact,0)/100;
               nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) * nPorcInicial / 100 *  NVL(nFact,0)/100;
               nMtoComisiPag       := NVL(nMtoComisiPag,0)       + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100) * nPorcInicial / 100 )* NVL(nFact,0)/100;
               nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + ((NVL(X.PrimaMoneda,0)* X.PorcComis / 100) * nPorcInicial / 100)* NVL(nFact,0)/100;
            ELSE
               nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local    - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) / nNumPagos * NVL(nFact,0)/100;
               nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda   - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) /nNumPagos* NVL(nFact,0)/100;
               nMtoComisiPag       := nMtoComisiPag              + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100) / nNumPagos * NVL(nFact,0)/100;
               nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100) / nNumPagos * NVL(nFact,0)/100;
            END IF;
            nPrimaRest           := NVL(nPrimaRest,0)     + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local + NVL(nRec_Local,0) - NVL(nDesc_Local,0) * NVL(nFact,0)/100) - NVL(nMtoPago,0);
            nMtoComisiRest       := NVL(nMtoComisiRest,0) + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100 * NVL(nFact,0)/100) -  NVL(nMtoComisiPag,0));
            nTotPrimas           := NVL(nTotPrimas,0) * NVL(nFact,0)/100 + NVL(nMtoPago,0);
            nMtoComisi           := NVL(nMtoComisi,0)  + NVL(nMtoComisiPag,0);

            nPrimaRestMoneda     := NVL(nPrimaRestMoneda,0)     + (NVL(X.PrimaMoneda,0)  + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0) * NVL(nFact,0)/100) - NVL(nMtoPagoMoneda,0);
            nMtoComisiMonedaRest := NVL(nMtoComisiMonedaRest,0) + ((NVL(X.PrimaMoneda,0) * X.PorcComis / 100) -   NVL(nMtoComisiMonedaPag,0))* NVL(nFact,0)/100;
            nMtoComisiMoneda     := NVL(nMtoComisiMoneda,0)     + NVL(nMtoComisiMonedaPag,0);
            nTotPrimasMoneda     := NVL(nTotPrimasMoneda,0)* NVL(nFact,0)/100   + NVL(nMtoPagoMoneda,0);

            nPrimaMoneda         := NVL(nPrimaMoneda,0) + NVL(X.PrimaMoneda,0)* NVL(nFact,0)/100;
            nPrimaLocal          := NVL(nPrimaLocal,0)  + NVL(X.PrimaLocal,0)* NVL(nFact,0)/100;
            nMtoComiL            := NVL(nMtoComiL,0)    + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100)* NVL(nFact,0)/100;
            nMtoComisiM          := NVL(nMtoComisiM,0)  + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100)* NVL(nFact,0)/100;
         END LOOP;
         nPrimaRest           := NVL(nPrimaLocal,0)  - NVL(nMtoPago,0);
         nPrimaRestMoneda     := NVL(nPrimaMoneda,0) - NVL(nMtoPagoMoneda,0);
         nMtoComisiRest       := NVL(nMtoComiL,0)    - NVL(nMtoComisiPag,0);
         nMtoComisiMonedaRest := NVL(nMtoComisiM,0)  - NVL(nMtoComisiMonedaPag,0);
         nMtoT                := 0;

         IF NVL(nMtoPagoMoneda,0) != 0 THEN
            FOR NP IN 1..nNumPagos LOOP
               IF NP > 1 THEN
                  nMtoPago            := NVL(nPrimaRest,0)     / (nNumPagos - 1);
                  nMtoComisiPag       := NVL(nMtoComisiRest,0) / (nNumPagos - 1);
                  nTotPrimas          := NVL(nTotPrimas,0) + NVL(nMtoPago,0);
                  nMtoComisi          := NVL(nMtoComisi,0) + NVL(nMtoComisiPag,0);
                  IF nFrecPagos NOT IN (15,7) THEN
                     dFecPago         := ADD_MONTHS(dFecPago,nFrecPagos);
                  ELSE
                     dFecPago         := dFecPago + nFrecPagos;
                  END IF;
                  nMtoPagoMoneda      := NVL(nPrimaRestMoneda,0)     / (nNumPagos - 1);
                  nTotPrimasMoneda    := NVL(nTotPrimasMoneda,0)     +  NVL(nMtoPagoMoneda,0);
                  nMtoComisiMonedaPag := NVL(nMtoComisiMonedaRest,0) / (nNumPagos - 1);
                  nMtoComisiMoneda    := NVL(nMtoComisiMoneda,0) + NVL(nMtoComisiMonedaPag,0);
               END IF;
               -- LARPLA
               nIdFactura := OC_FACTURAS.INSERTAR(nIdPoliza,           nIdetPol,       nCodCliente, dFecPago, 
                                                  nMtoPago,            nMtoPagoMoneda, nIdEndoso,   nMtoComisiPag, 
                                                  nMtoComisiMonedaPag, NP,             nTasaCambio, nCod_Agente, 
                                                  nCodTipoDoc,         pCodCia,        cCodMoneda,  J.CodResPago, 
                                                  nTransa,             cIndFactElectronica);

               FOR W IN CPTO_PRIMAS_Q LOOP
                  nFactor := W.Prima_Local / NVL(nPrimaLocal,0);
                  OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
                  OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
               END LOOP;

               nTotAsistLocal  := 0;
               nTotAsistMoneda := 0;
               FOR K IN CPTO_ASIST_Q LOOP
                  nAsistRestLocal  := 0;
                  nAsistRestMoneda := 0;
                  IF NVL(nPorcInicial,0) <> 0 THEN
                     nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) * nPorcInicial / 100) * NVL(nFact,0)/100;
                     nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) * nPorcInicial / 100) * NVL(nFact,0)/100;
                  ELSE
                     nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) / nNumPagos) * NVL(nFact,0)/100;
                     nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) / nNumPagos) * NVL(nFact,0)/100;
                  END IF;
                  /*nAsistRestLocal  := NVL(nAsistRestLocal,0) + (NVL(K.MontoAsistLocal,0) * NVL(nFact,0)/100) - nMtoAsistLocal;
                  nAsistRestMoneda := NVL(nAsistRestMoneda,0) + (NVL(K.MontoAsistMoneda,0) * NVL(nFact,0)/100) - nMtoAsistMoneda;
                  IF NP > 1 THEN
                     nMtoAsistLocal  := (NVL(nAsistRestLocal,0) / (nNumPagos - 1));
                     nMtoAsistMoneda := (NVL(nAsistRestMoneda,0) / (nNumPagos - 1));
                  END IF;*/
                  nTotAsistLocal  := NVL(nTotAsistLocal,0) + NVL(nMtoAsistLocal,0);
                  nTotAsistMoneda := NVL(nTotAsistMoneda,0) + NVL(nMtoAsistMoneda,0);
                  OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
                  OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
               END LOOP;

               nMtoT := nMtoT + nMtoPago;-- + nTotAsistLocal;
               PROC_COMISIONPOL (nIdPoliza, nIDetPol, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFactura,
                                 nMtoComisiPag/nNumCert, nMtoComisiMonedaPag/nNumCert, nTasaCambio);

               -- Distribuye la comision por agente.
               FOR Y IN CPTO_PLAN_Q LOOP
                  BEGIN
                     SELECT 'S'
                       INTO cGraba
                       FROM RAMOS_CONCEPTOS_PLAN R
                      WHERE R.CodPlanPago = cCodPlanPago
                        AND R.CodCpto     = Y.CodCpto
                        AND R.CodCia      = nCodCia
                        AND R.CodEmpresa  = nCodEmpresa
                        AND EXISTS   (SELECT 1
                                        FROM DETALLE_POLIZA D, POLIZAS P
                                       WHERE D.IdPoliza   = P.IdPoliza
                                         AND D.IdTipoSeg  = R.IdTipoSeg
                                         AND P.StsPoliza IN ('SOL','XRE')
                                         AND P.IdPoliza   = nIdPoliza);
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        cGraba := 'N';
                     WHEN TOO_MANY_ROWS THEN
                        cGraba := 'S';
                  END;

                  IF cGraba = 'S' THEN
                     IF Y.IndRangosTipseg = 'S' THEN
                        IF cIndCalcDerechoEmis = 'S' THEN
                           OC_CATALOGO_CONCEPTOS_RANGOS.VALOR_CONCEPTO(nCodCia, nCodEmpresa, Y.CodCpto, cIdTipoSeg,
                                                                       nIdPoliza, 0, nIdEndoso, nMtoCpto, nPorcCpto);
                           IF OC_DETALLE_FACTURAS.EXISTE_CONCEPTO(nCodCia, nIdPoliza, nTransa, Y.CodCpto) = 'N' THEN
                              IF NVL(nMtoCpto,0) = 0 AND NVL(nPorcCpto,0) = 0 THEN
                                 nMtoCpto  := Y.MtoCpto;
                                 nPorcCpto := Y.PorcCpto;
                              END IF;
                           ELSE
                              nMtoCpto  := 0;
                              nPorcCpto := 0;
                           END IF;
                        ELSE
                           nMtoCpto  := 0;
                           nPorcCpto := 0;
                        END IF;
                     ELSE
                        nMtoCpto  := Y.MtoCpto;
                        nPorcCpto := Y.PorcCpto;
                     END IF;

                     IF Y.Aplica = 'P' THEN
                        IF NVL(nMtoCpto,0) <> 0 AND NP = 1 THEN
                           nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                        ELSIF NP = 1 THEN
                           nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                           nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                        ELSE
                           nMtoDet       := 0;
                           nMtoDetMoneda := 0;
                        END IF;
                        IF NVL(nMtoDet,0) != 0 THEN
                           OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                           OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                           nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                           nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                        END IF;
                     ELSIF Y.Aplica = 'T' THEN
                        IF NVL(nMtoCpto,0) <> 0 THEN
                           nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                        ELSE
                           nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                           nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                        END IF;
                        IF NVL(nMtoDet,0) != 0 THEN
                           OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                           OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                           nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                           nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                        END IF;
                     END IF;
                     nMtoT := nMtoT + nMtoDet;
                  END IF;
               END LOOP;
               OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
               OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
            END LOOP;

            IF (NVL(nPrimaLocal,0)+ nMtoRecD_Local - nMtoDescD_Local +
                NVL(nRec_Local,0) - NVL(nDesc_Local,0)) <> NVL(nTotPrimas,0) THEN
               nDifer       := (NVL(nPrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local   +
                                NVL(nRec_Local,0)  - NVL(nDesc_Local,0)) - NVL(nTotPrimas,0);
               nDiferMoneda := (NVL(nPrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda  +
                                NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) - NVL(nTotPrimasMoneda,0);
               nDiferC      :=  NVL(nMtoComiL,0)   - NVL(nMtoComisi,0);
               nDiferCMon   :=  NVL(nMtoComisiM,0) - NVL(nMtoComisiMoneda,0);

               PROC_COMISIONPOL (nIdPoliza, nIDetPol, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFactura,
                                 nDiferC/nNumCert, nDiferCMon/nNumCert, nTasaCambio);

               OC_DETALLE_FACTURAS.ACTUALIZA_DIFERENCIA(nIdFactura, nDifer, nDiferMoneda);

               OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
               OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');

               UPDATE FACTURAS
                  SET MtoComisi_Local   = MtoComisi_Local   + NVL(nDiferC,0),
                      MtoComisi_Moneda  = MtoComisi_Moneda  + NVL(nDiferCMon,0)
                WHERE IdFactura = nIdFactura;
            END IF;
         END IF;
      END LOOP;
      OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
      IF NVL(nPrimaRestMoneda,0) != 0 THEN
         OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'FAC', 'FACTURAS',
                                      nIdPoliza, nIdetPol, NULL, NULL, nMtoT);
         OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'COM', 'COMISIONES',
                                      nIdPoliza, nIdetPol, NULL, NULL, nMtoDet);
      END IF;
   END IF;
   BEGIN
      SELECT Contabilidad_Automatica
        INTO cContabilidad_Automatica
        FROM EMPRESAS
       WHERE CodCia = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cContabilidad_Automatica := 'N';
   END;
   IF cContabilidad_Automatica = 'S' THEN
      PROC_MOVCONTA(nCodCia, nIdPoliza, cCodMoneda, 'EMI');
   END IF;
END PROC_EMITE_FACT_POL;

PROCEDURE PROC_EMITE_FACT_END (nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER, nTransa NUMBER) IS
nIdFactura               FACTURAS.IdFactura%TYPE;
nNumPagos                PLAN_DE_PAGOS.NumPagos%TYPE;
nFrecPagos               PLAN_DE_PAGOS.FrecPagos%TYPE;
nPorcInicial             PLAN_DE_PAGOS.PorcInicial%TYPE;
nCodCliente              POLIZAS.CodCliente%TYPE;
cIdTipoSeg               DETALLE_POLIZA.IdTipoSeg%TYPE;
nTotPrimas               DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDifer                   DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDiferMoneda             DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoDet                  DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoDetMoneda            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoTotal                DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoTotalMoneda          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cCodMoneda               POLIZAS.Cod_Moneda%TYPE;
nPrimaNetaMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoPagoMoneda           FACTURAS.Monto_Fact_Moneda%TYPE;
cCodMonedaLocal          EMPRESAS.Cod_Moneda%TYPE;
nPrimaRestMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoComisiMoneda         FACTURAS.MtoComisi_Local%TYPE;
nTotPrimasMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nCodCia                  POLIZAS.CodCia%TYPE;
nCodEmpresa              POLIZAS.CodEmpresa%TYPE;
cCodPlanPago             DETALLE_POLIZA.CodPlanPago%TYPE;
nTasaCambio              DETALLE_POLIZA.Tasa_Cambio%TYPE;
nMtoCpto                 CONCEPTOS_PLAN_DE_PAGOS.MtoCpto%TYPE;
nPorcCpto                CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
cAplica                  CONCEPTOS_PLAN_DE_PAGOS.Aplica%TYPE;
nFactor                  NUMBER (14,8);
Dummy                    NUMBER(5);
dFecPago                 DATE;
nMtoPago                 NUMBER(18,2);
nMtoComisi               NUMBER(18,2);
nPrimaRest               NUMBER(18,2);
cGraba                   VARCHAR2(1);
nNumCert                 DETALLE_POLIZA.idetPol%TYPE;
cRespPol                 VARCHAR2(1):= 'N';
cRespDet                 VARCHAR2(1):= 'N';
nCodTipoDoc              TIPO_DE_DOCUMENTO.CodTipoDoc%TYPE;
cContabilidad_Automatica EMPRESAS.Contabilidad_Automatica%TYPE;
nCod_Agente              AGENTES_DETALLES_POLIZAS.Cod_Agente%TYPE;
nMtoT                    FACTURAS.monto_fact_local%TYPE := 0;
nTotComi                 COMISIONES.Comision_Local%TYPE;
nMtoAsistLocal           ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nMtoAsistMoneda          ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
nAsistRestLocal          ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nAsistRestMoneda         ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
nTotAsistLocal           ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nTotAsistMoneda          ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
cIndFactElectronica      POLIZAS.IndFactElectronica%TYPE;
cTipoEndoso              ENDOSOS.TipoEndoso%TYPE;
nPrimaLocal              ENDOSOS.Prima_Neta_Moneda%TYPE;
nPrimaMoneda             ENDOSOS.Prima_Neta_Local%TYPE;
nCantPagosReal           NUMBER(5);
fFecfinvig               FACTURAS.FECFINVIG%TYPE;      -- ICOFINVIG

CURSOR ENDOSO_Q IS
   SELECT E.Prima_Neta_Local PrimaLocal, E.Prima_Neta_Moneda PrimaMoneda, E.CodPlanPago, E.PorcComis,
          E.FecIniVig, E.FecFinVig, E.FecEmision, E.IDetPol, D.IdTipoSeg, E.TipoEndoso, E.IndCalcDerechoEmis
     FROM DETALLE_POLIZA D, ENDOSOS E
    WHERE D.IdPoliza           = E.IdPoliza
      AND D.IDetPol            = E.IDetPol
      AND E.Prima_Neta_Moneda  > 0
      AND E.IdPoliza           = nIdPoliza
      AND E.IDetPol            = nIDetPol
      AND E.IdEndoso           = nIdEndoso;

CURSOR CPTO_PLAN_Q IS
   SELECT CP.CodCpto, CP.PorcCpto, CP.Aplica, CP.MtoCpto,
          CC.IndRangosTipseg
     FROM CONCEPTOS_PLAN_DE_PAGOS CP, CATALOGO_DE_CONCEPTOS CC
    WHERE CC.IndCptoAjuste = 'N'
      AND CC.IndCptoPrimas = 'N'
      AND CC.CodConcepto   = CP.CodCpto
      AND CC.CodCia        = CP.CodCia
      AND CP.CodCia        = nCodCia
      AND CP.CodEmpresa    = nCodEmpresa
      AND CP.CodPlanPago   = cCodPlanPago
      AND EXISTS (SELECT 'S'
                    FROM RAMOS_CONCEPTOS_PLAN
                   WHERE CodCia      = CP.CodCia
                     AND CodEmpresa  = CP.CodEmpresa
                     AND IdTipoSeg   = cIdTipoSeg
                     AND CodCpto     = CP.CodCpto
                     AND CodPlanPago = CP.CodPlanPago)
    ORDER BY CP.Prioridad;

CURSOR RESP_PAGO IS
  SELECT R.PorcResPago, R.CodResPago, R.IDetPol
    FROM RESPONSABLE_PAGO_DET R
   WHERE R.IdPoliza    = nIdPoliza
     AND R.CodCia      = nCodCia
     AND R.CodEmpresa  = nCodEmpresa
     AND R.IdetPol     = nNumCert;
CURSOR CPTO_PRIMAS_Q IS
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERT_ACT C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert   = C.CodCobert
      AND CS.PlanCob     = C.PlanCob
      AND CS.IdTipoSeg   = C.IdTipoSeg
      AND CS.CodEmpresa  = C.CodEmpresa
      AND CS.CodCia      = C.CodCia
      AND C.StsCobertura IN ('EMI','SOL','XRE')
      AND C.IdEndoso     = nIdEndoso
      AND C.IDetPol      = nNumCert
      AND C.IdPoliza     = nIdPoliza
      AND C.CodCia       = nCodCia
    GROUP BY CS.CodCpto
  UNION ALL
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERT_ACT_ASEG C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert     = C.CodCobert
      AND CS.PlanCob       = C.PlanCob
      AND CS.IdTipoSeg     = C.IdTipoSeg
      AND CS.CodEmpresa    = C.CodEmpresa
      AND CS.CodCia        = C.CodCia
      AND C.StsCobertura  IN ('EMI','SOL','XRE')
      AND cTipoEndoso NOT IN ('EAD')
      AND C.IdEndoso       = nIdEndoso
      --AND C.IDetPol      = nNumCert
      AND C.IdPoliza       = nIdPoliza
      AND C.CodCia         = nCodCia
    GROUP BY CS.CodCpto
    UNION
   SELECT MAX(CS.CodCpto) CodCpto, nPrimaLocal Prima_Local, nPrimaMoneda Prima_Moneda
     FROM DETALLE_POLIZA D, COBERTURAS_DE_SEGUROS CS
    WHERE CS.Cobertura_Basica = 'S'
      AND CS.PlanCob          = D.PlanCob
      AND CS.IdTipoSeg        = D.IdTipoSeg
      AND CS.CodEmpresa       = D.CodEmpresa
      AND CS.CodCia           = D.CodCia
      AND D.IDetPol           = nIDetPol
      AND D.IdPoliza          = nIdPoliza
      AND D.CodCia            = nCodCia
      AND cTipoEndoso        IN ('RSS', 'EAD', 'AUM','CFP')
    GROUP BY CS.CodCpto;
CURSOR CPTO_ASIST_Q IS
   SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
          SUM(A.MontoAsistMoneda) MontoAsistMoneda
     FROM ASISTENCIAS_DETALLE_POLIZA A, DETALLE_POLIZA D, ASISTENCIAS T
    WHERE T.CodAsistencia = A.CodAsistencia
      AND D.IDetPol        = A.IDetPol
      AND D.IdPoliza       = A.IdPoliza
      AND D.CodCia         = A.CodCia
      AND A.IdEndoso       = nIdEndoso
      AND A.StsAsistencia IN ('EMITID','SOLICI','XRENOV')
      AND A.IDetPol        = nNumCert
      AND A.IdPoliza       = nIdPoliza
      AND A.CodCia         = nCodCia
    GROUP BY T.CodCptoServicio
  UNION ALL
   SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
          SUM(A.MontoAsistMoneda) MontoAsistMoneda
     FROM ASISTENCIAS_ASEGURADO A, DETALLE_POLIZA D, ASISTENCIAS T
    WHERE T.CodAsistencia  = A.CodAsistencia
      AND D.IDetPol        = A.IDetPol
      AND D.IdPoliza       = A.IdPoliza
      AND D.CodCia         = A.CodCia
      AND A.IdEndoso       = nIdEndoso
      AND A.StsAsistencia IN ('EMITID','SOLICI','XRENOV')
      --AND A.IDetPol        = nNumCert
      AND A.IdPoliza       = nIdPoliza
      AND A.CodCia         = nCodCia
    GROUP BY T.CodCptoServicio;
BEGIN
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
   BEGIN
      SELECT CodCliente, Cod_Moneda, CodCia, CodEmpresa, IndFactElectronica
        INTO nCodCliente, cCodMoneda, nCodCia, nCodEmpresa, cIndFactElectronica
        FROM POLIZAS
       WHERE IdPoliza = nIdPoliza;
   END;
   BEGIN
      SELECT Cod_Moneda
        INTO cCodMonedaLocal
        FROM EMPRESAS
       WHERE CodCia = nCodCia;
   END;
   BEGIN
      SELECT 'S'
        INTO cRespPol
        FROM RESPONSABLE_PAGO_POL
       WHERE StsResPago = 'ACT'
         AND CodCia     = nCodCia
         AND IdPoliza   = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cRespPol := 'N';
      WHEN TOO_MANY_ROWS THEN
         cRespPol := 'S';
   END;

   IF cRespPol = 'S' AND FUNC_VALIDA_RESP_POL (nIdPoliza, nCodCia) = 'S' THEN
      PROC_INSERT_RESP_D (nIdPoliza,nCodCia);
   END IF;

   FOR X IN ENDOSO_Q LOOP
      nNumcert     := X.IDetPol;
      cIdTipoSeg   := X.IdTipoSeg;
      cTipoEndoso  := X.TipoEndoso;
      nPrimaLocal  := X.PrimaLocal;
      nPrimaMoneda := X.PrimaMoneda;

      IF cTipoEndoso NOT IN ('RSS', 'EAD') THEN
         OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 8, 'CER', 'DETALLE_POLIZA',
                                      nIdPoliza, X.IDetPol, NULL, NULL, X.PrimaLocal);
      END IF;

      BEGIN
         SELECT 'S'
           INTO cRespDet
           FROM RESPONSABLE_PAGO_DET R
          WHERE R.IdPoliza    = nIdPoliza
            AND R.CodCia      = nCodCia
            AND R.CodEmpresa  = nCodEmpresa
            AND R.IdetPol     = X.IDetPol;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cRespDet:='N';
         WHEN TOO_MANY_ROWS THEN
             cRespDet:='S';
      END;
      IF cRespPol = 'N' AND cRespDet = 'N' THEN
         cCodPlanPago := X.CodPlanPago;
         nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(X.FecEmision));
         BEGIN
            SELECT Cod_Agente
              INTO nCod_Agente
              FROM AGENTES_DETALLES_POLIZAS
             WHERE IdPoliza      = nIdPoliza
               AND IdetPol       = X.IdetPol
               AND IdTipoSeg     = X.IdTipoSeg
               AND Ind_Principal = 'S';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR (-20100,'No Existe un Agente Definido para el Tipo de Seguro '||X.IdTipoSeg);
            WHEN TOO_MANY_ROWS THEN
               RAISE_APPLICATION_ERROR (-20100,'Existe Mas de un Agente Definido como Principal');
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR (-20100,'Existe un error de otros');
         END;

         -- Caracteristicas del Plan de Pago
         BEGIN
            SELECT NumPagos, FrecPagos, PorcInicial
              INTO nNumPagos, nFrecPagos, nPorcInicial
              FROM PLAN_DE_PAGOS
             WHERE CodCia      = nCodCia
               AND CodEmpresa  = nCodEmpresa
               AND CodPlanPago = X.CodPlanPago;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR (-20100,'No Existe Plan de Pagos '||X.CodPlanPago);
         END;

         -- Determina Meses de Vigencia para Plan de Pagos
         IF nNumPagos <= 12 THEN
            nCantPagosReal  := FLOOR(MONTHS_BETWEEN(X.FecFinVig, X.FecIniVig) / nFrecPagos);
         ELSE
            nCantPagosReal  := FLOOR((X.FecFinVig - X.FecIniVig) / nFrecPagos);
         END IF;

         IF nCantPagosReal <= 0 THEN
            nCantPagosReal := 1;
         END IF;
         IF nCantPagosReal < nNumPagos THEN
            nNumPagos := nCantPagosReal;
         END IF;

         -- Fecha del Primer Pago Siempre a Inicio de Vigencia
         dFecPago := X.FecIniVig;
         /*IF X.FecIniVig > X.FecEmision THEN
            dFecPago := X.FecIniVig;
         ELSE
            dFecPago := X.FecEmision;
         END IF;*/
      -- Monto del Primer Pago
         nTotPrimas       := 0;
         nTotPrimasMoneda := 0;

         IF NVL(nPorcInicial,0) <> 0 THEN
            nMtoPago       := NVL(X.PrimaLocal,0) * nPorcInicial / 100  ;
            nMtoPagoMoneda := NVL(X.PrimaMoneda,0) * nPorcInicial / 100 ;
         ELSE
            nMtoPago := NVL(X.PrimaLocal,0) / nNumPagos      ;
            nMtoPagoMoneda := NVL(X.PrimaMoneda,0) /nNumPagos;
         END IF;

         nPrimaRest := (NVL(X.PrimaLocal,0)) - NVL(nMtoPago,0);
         nMtoComisi := nMtoPago * X.PorcComis / 100;
         nTotPrimas := (NVL(nTotPrimas,0)) + NVL(nMtoPago,0);

         -- Cambio Multimoneda Ref. F. Ortiz 24/01/2007
         nPrimaRestMoneda := (NVL(X.PrimaMoneda,0)) - NVL(nMtoPagoMoneda,0);
         nMtoComisiMoneda := nMtoPagoMoneda * X.PorcComis / 100;
         nTotPrimasMoneda := (NVL(nTotPrimasMoneda,0)) + NVL(nMtoPagoMoneda,0);

         FOR NP IN 1..nNumPagos LOOP
            IF NP > 1 THEN
               nMtoPago         := NVL(nPrimaRest,0) / (nNumPagos - 1);
               nTotPrimas       := NVL(nTotPrimas,0) + NVL(nMtoPago,0);
               nMtoComisi       := nMtoPago * X.PorcComis / 100;
               IF nFrecPagos NOT IN (15,7) THEN
                  dFecPago         := ADD_MONTHS(dFecPago,nFrecPagos);
               ELSE
                  dFecPago         := dFecPago + nFrecPagos;
               END IF;
               nMtoPagoMoneda   := NVL(nPrimaRestMoneda,0) / (nNumPagos - 1);
               nTotPrimasMoneda := NVL(nTotPrimasMoneda,0) + NVL(nMtoPagoMoneda,0);
               nMtoComisiMoneda := nMtoPagoMoneda * X.PorcComis / 100;
            END IF;
            -- LARPLA
            nIdFactura := OC_FACTURAS.INSERTAR(nIdPoliza,        X.IDetPol,      nCodCliente, dFecPago, 
                                               nMtoPago,         nMtoPagoMoneda, nIdEndoso,   nMtoComisi, 
                                               nMtoComisiMoneda, NP,             nTasaCambio, nCod_Agente, 
                                               nCodTipoDoc,      nCodCia,        cCodMoneda,  NULL, 
                                               nTransa,          cIndFactElectronica);

            FOR W IN CPTO_PRIMAS_Q LOOP
               nFactor := W.Prima_Local / NVL(X.PrimaLocal,0);
               OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
               OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
            END LOOP;

            nTotAsistLocal  := 0;
            nTotAsistMoneda := 0;
            FOR K IN CPTO_ASIST_Q LOOP
               nAsistRestLocal  := 0;
               nAsistRestMoneda := 0;
               IF NVL(nPorcInicial,0) <> 0 THEN
                  nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) * nPorcInicial / 100);
                  nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) * nPorcInicial / 100);
               ELSE
                  nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) / nNumPagos);
                  nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) / nNumPagos);
               END IF;
               /*nAsistRestLocal  := NVL(nAsistRestLocal,0) + NVL(K.MontoAsistLocal,0) - nMtoAsistLocal;
               nAsistRestMoneda := NVL(nAsistRestMoneda,0) + NVL(K.MontoAsistMoneda,0) - nMtoAsistMoneda;
               IF NP > 1 THEN
                  nMtoAsistLocal  := (NVL(nAsistRestLocal,0) / (nNumPagos - 1));
                  nMtoAsistMoneda := (NVL(nAsistRestMoneda,0) / (nNumPagos - 1));
               END IF;*/
               nTotAsistLocal  := NVL(nTotAsistLocal,0) + NVL(nMtoAsistLocal,0);
               nTotAsistMoneda := NVL(nTotAsistMoneda,0) + NVL(nMtoAsistMoneda,0);
               OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
               OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
            END LOOP;

            nMtoT := nMtoT + nMtoPago;-- + NVL(nTotAsistLocal,0);

   --       Genera comisiones por agente por certificado
            PROC_ENDO_COMI (nIdPoliza, X.IdetPol, nIdEndoso, nCodCia, nCodEmpresa, X.IdTipoSeg,
                            cCodMoneda, nIdFactura, nMtoPago, nMtoPagoMoneda, nTasaCambio);

            FOR Y IN CPTO_PLAN_Q LOOP
               BEGIN
                  SELECT 'S'
                    INTO cGraba
                    FROM RAMOS_CONCEPTOS_PLAN
                   WHERE CodPlanPago = cCodPlanPago
                     AND CodCpto     = Y.CodCpto
                     AND CodCia      = nCodCia
                     AND CodEmpresa  = nCodEmpresa
                     AND IdTipoSeg   = X.IdTipoSeg;
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     cGraba := 'N';
                  WHEN TOO_MANY_ROWS THEN
                     cGraba := 'S';
               END;
               IF cGraba = 'S' THEN
                  IF Y.IndRangosTipseg = 'S' THEN
                     -- No Calcula Derechos de Emisión en Endosos
                     nMtoCpto  := 0;
                     nPorcCpto := 0;
                     OC_CATALOGO_CONCEPTOS_RANGOS.VALOR_CONCEPTO(nCodCia, nCodEmpresa, Y.CodCpto, X.IdTipoSeg,
                                                                 nIdPoliza, X.IdetPol, nIdEndoso, nMtoCpto, nPorcCpto);
                     IF NVL(X.IndCalcDerechoEmis,'N') = 'S' THEN
                        IF NVL(nMtoCpto,0) = 0 AND NVL(nPorcCpto,0) = 0 THEN
                           nMtoCpto  := Y.MtoCpto;
                           nPorcCpto := Y.PorcCpto;
                        END IF;
                     ELSE
                        nMtoCpto  := 0;
                        nPorcCpto := 0;
                     END IF;
                  ELSE
                     nMtoCpto  := Y.MtoCpto;
                     nPorcCpto := Y.PorcCpto;
                  END IF;
                  IF Y.Aplica = 'P' THEN
                     IF NVL(nMtoCpto,0) <> 0 AND NP = 1 THEN
                        nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                     ELSIF NP = 1 THEN
                        nMtoDet       := (NVL(X.PrimaLocal,0) + NVL(nTotAsistLocal,0)) * nPorcCpto / 100;
                        nMtoDetMoneda := (NVL(X.PrimaMoneda,0) + NVL(nTotAsistMoneda,0)) * nPorcCpto / 100;
                     ELSE
                        nMtoDet       := 0;
                        nMtoDetMoneda := 0;
                     END IF;
                     IF NVL(nMtoDet,0) != 0 THEN
                        OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                        nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                     END IF;
                  ELSIF Y.Aplica = 'T' THEN
                     IF NVL(nMtoCpto,0) <> 0 THEN
                        nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                     ELSE
                        nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                        nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                     END IF;
                     IF NVL(nMtoDet,0) != 0 THEN
                        OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                        nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                     END IF;
                  END IF;
               END IF;
               nMtoT := nMtoT + nMtoDet;
            END LOOP;
            OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
      OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
      --*****************************************************************************************
         END LOOP;

         IF (NVL(X.PrimaLocal,0)) <> NVL(nTotPrimas,0) THEN
            nDifer       := (NVL(X.PrimaLocal,0)) - NVL(nTotPrimas,0);
            nDiferMoneda := (NVL(X.PrimaMoneda,0)) - NVL(nTotPrimasMoneda,0);

            OC_DETALLE_FACTURAS.ACTUALIZA_DIFERENCIA(nIdFactura, nDifer, nDiferMoneda);

            OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
         END IF;
      ELSE
         FOR J IN RESP_PAGO LOOP
            cCodPlanPago := X.CodPlanPago;
            nTasaCambio  := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(X.FecEmision));

            -- Caracteristicas del Plan de Pago
            BEGIN
               SELECT NumPagos, FrecPagos, PorcInicial
                 INTO nNumPagos, nFrecPagos, nPorcInicial
                 FROM PLAN_DE_PAGOS
                WHERE CodCia      = nCodCia
                  AND CodEmpresa  = nCodEmpresa
                  AND CodPlanPago = X.CodPlanPago;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR (-20100,'No Existe Plan de Pagos '||X.CodPlanPago);

            END;

            -- Determina Meses de Vigencia para Plan de Pagos
            IF nNumPagos <= 12 THEN
               nCantPagosReal  := FLOOR(MONTHS_BETWEEN(X.FecFinVig, X.FecIniVig) / nFrecPagos);
            ELSE
               nCantPagosReal  := FLOOR((X.FecFinVig - X.FecIniVig) / nFrecPagos);
            END IF;

            IF nCantPagosReal <= 0 THEN
               nCantPagosReal := 1;
            END IF;
            IF nCantPagosReal < nNumPagos THEN
               nNumPagos := nCantPagosReal;
            END IF;

            -- Fecha del Primer Pago Siempre a Inicio de Vigencia
            dFecPago := X.FecIniVig;
            /*IF X.FecIniVig > X.FecEmision THEN
               dFecPago := X.FecIniVig;
            ELSE
               dFecPago := X.FecEmision;
            END IF;*/
         -- Monto del Primer Pago
            nTotPrimas       := 0;
            nTotPrimasMoneda := 0;

            IF NVL(nPorcInicial,0) <> 0 THEN
               nMtoPago       := NVL(X.PrimaLocal,0) * nPorcInicial / 100  *  NVL(J.PorcResPago,0)/100;
               nMtoPagoMoneda := NVL(X.PrimaMoneda,0) * nPorcInicial / 100 *  NVL(J.PorcResPago,0)/100;
            ELSE
               nMtoPago := NVL(X.PrimaLocal,0) / nNumPagos       *  NVL(J.PorcResPago,0)/100;
               nMtoPagoMoneda := NVL(X.PrimaMoneda,0) /nNumPagos *  NVL(J.PorcResPago,0)/100;
            END IF;

            nPrimaRest := (NVL(X.PrimaLocal,0)*  NVL(J.PorcResPago,0)/100) - NVL(nMtoPago,0);
            nMtoComisi := nMtoPago * X.PorcComis / 100;
            nTotPrimas := (NVL(nTotPrimas,0)*  NVL(J.PorcResPago,0)/100) + NVL(nMtoPago,0);

            -- Cambio Multimoneda Ref. F. Ortiz 24/01/2007
            nPrimaRestMoneda := (NVL(X.PrimaMoneda,0)*  NVL(J.PorcResPago,0)/100) - NVL(nMtoPagoMoneda,0);
            nMtoComisiMoneda := nMtoPagoMoneda * X.PorcComis / 100;
            nTotPrimasMoneda := (NVL(nTotPrimasMoneda,0)*  NVL(J.PorcResPago,0)/100) + NVL(nMtoPagoMoneda,0);

            FOR NP IN 1..nNumPagos LOOP
               IF NP > 1 THEN
                  nMtoPago         := NVL(nPrimaRest,0) / (nNumPagos - 1);
                  nTotPrimas       := NVL(nTotPrimas,0) + NVL(nMtoPago,0);
                  nMtoComisi       := nMtoPago * X.PorcComis / 100;
                  IF nFrecPagos NOT IN (15,7) THEN
                     dFecPago         := ADD_MONTHS(dFecPago,nFrecPagos);
                  ELSE
                     dFecPago         := dFecPago + nFrecPagos;
                  END IF;
                  nMtoPagoMoneda   := NVL(nPrimaRestMoneda,0) / (nNumPagos - 1);
                  nTotPrimasMoneda := NVL(nTotPrimasMoneda,0) + NVL(nMtoPagoMoneda,0);
                  nMtoComisiMoneda := nMtoPagoMoneda * X.PorcComis / 100;
               END IF;
            -- LARPLA
               nIdFactura := OC_FACTURAS.INSERTAR(nIdPoliza,        X.IDetPol,       nCodCliente, dFecPago, 
                                                  nMtoPago,         nMtoPagoMoneda,  nIdEndoso,   nMtoComisi, 
                                                  nMtoComisiMoneda, NP,              nTasaCambio, nCod_Agente, 
                                                  nCodTipoDoc,      nCodCia,         cCodMoneda,  J.CodResPago, 
                                                  nTransa,          cIndFactElectronica);

               FOR W IN CPTO_PRIMAS_Q LOOP
                  nFactor := W.Prima_Local / NVL(X.PrimaLocal,0);
                  OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
                  OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
               END LOOP;

               nTotAsistLocal  := 0;
               nTotAsistMoneda := 0;
               FOR K IN CPTO_ASIST_Q LOOP
                  nAsistRestLocal  := 0;
                  nAsistRestMoneda := 0;
                  IF NVL(nPorcInicial,0) <> 0 THEN
                     nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) * nPorcInicial / 100) * NVL(J.PorcResPago,0)/100;
                     nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) * nPorcInicial / 100) * NVL(J.PorcResPago,0)/100;
                  ELSE
                     nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) / nNumPagos) * NVL(J.PorcResPago,0)/100;
                     nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) / nNumPagos) * NVL(J.PorcResPago,0)/100;
                  END IF;
                  /*nAsistRestLocal  := NVL(nAsistRestLocal,0) + (NVL(K.MontoAsistLocal,0) * NVL(J.PorcResPago,0)/100) - nMtoAsistLocal;
                  nAsistRestMoneda := NVL(nAsistRestMoneda,0) + (NVL(K.MontoAsistMoneda,0) * NVL(J.PorcResPago,0)/100) - nMtoAsistMoneda;
                  IF NP > 1 THEN
                     nMtoAsistLocal  := (NVL(nAsistRestLocal,0) / (nNumPagos - 1));
                     nMtoAsistMoneda := (NVL(nAsistRestMoneda,0) / (nNumPagos - 1));
                  END IF;*/
                  nTotAsistLocal  := NVL(nTotAsistLocal,0) + NVL(nMtoAsistLocal,0);
                  nTotAsistMoneda := NVL(nTotAsistMoneda,0) + NVL(nMtoAsistMoneda,0);
                  OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
                  OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
               END LOOP;

               nMtoT := nMtoT + nMtoPago;-- + NVL(nTotAsistLocal,0);

      --       Genera comisiones por agente por certificado
               PROC_ENDO_COMI (nIdPoliza, X.IdetPol, nIdEndoso, nCodCia, nCodEmpresa, X.IdTipoSeg,
                               cCodMoneda, nIdFactura, nMtoPago, nMtoPagoMoneda, nTasaCambio);

               FOR Y IN CPTO_PLAN_Q LOOP
                  BEGIN
                     SELECT 'S'
                       INTO cGraba
                       FROM RAMOS_CONCEPTOS_PLAN
                      WHERE CodPlanPago = cCodPlanPago
                        AND CodCpto     = Y.CodCpto
                        AND CodCia      = nCodCia
                        AND CodEmpresa  = nCodEmpresa
                        AND IdTipoSeg   = X.IdTipoSeg;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        cGraba := 'N';
                     WHEN TOO_MANY_ROWS THEN
                        cGraba := 'S';
                  END;
                  IF cGraba = 'S' THEN
                     IF Y.IndRangosTipseg = 'S' THEN
                        -- No Calcula Derechos de Emisión en Endosos
                        nMtoCpto  := 0;
                        nPorcCpto := 0;
                        OC_CATALOGO_CONCEPTOS_RANGOS.VALOR_CONCEPTO(nCodCia, nCodEmpresa, Y.CodCpto, X.IdTipoSeg,
                                                                    nIdPoliza, X.IdetPol, nIdEndoso, nMtoCpto, nPorcCpto);
                        IF NVL(X.IndCalcDerechoEmis,'N') = 'S' THEN
                           IF NVL(nMtoCpto,0) = 0 AND NVL(nPorcCpto,0) = 0 THEN
                              nMtoCpto  := Y.MtoCpto;
                              nPorcCpto := Y.PorcCpto;
                           END IF;
                        ELSE
                           nMtoCpto  := 0;
                           nPorcCpto := 0;
                        END IF;
                     ELSE
                        nMtoCpto  := Y.MtoCpto;
                        nPorcCpto := Y.PorcCpto;
                     END IF;

                     IF Y.Aplica = 'P' THEN
                        IF NVL(nMtoCpto,0) <> 0 AND NP = 1 THEN
                           nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                        ELSIF NP = 1 THEN
                           nMtoDet       := (NVL(X.PrimaLocal,0) + NVL(nTotAsistLocal,0)) * nPorcCpto / 100;
                           nMtoDetMoneda := (NVL(X.PrimaMoneda,0) + NVL(nTotAsistMoneda,0)) * nPorcCpto / 100;
                        ELSE
                           nMtoDet       := 0;
                           nMtoDetMoneda := 0;
                        END IF;
                        IF NVL(nMtoDet,0) != 0 THEN
                           OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                           OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                           nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                           nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                        END IF;
                     ELSIF Y.Aplica = 'T' THEN
                        IF NVL(nMtoCpto,0) <> 0 THEN
                           nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                        ELSE
                           nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                           nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                        END IF;
                        IF NVL(nMtoDet,0) != 0 THEN
                           OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                           OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                           nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                           nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                        END IF;
                     END IF;
                     nMtoT := nMtoT + nMtoDet;
                  END IF;
               END LOOP;
               OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
         OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
            END LOOP;

            IF NVL(X.PrimaLocal,0) <> NVL(nTotPrimas,0) THEN
               nDifer       := (NVL(X.PrimaLocal,0)) - NVL(nTotPrimas,0);
               nDiferMoneda := (NVL(X.PrimaMoneda,0)) - NVL(nTotPrimasMoneda,0);

               OC_DETALLE_FACTURAS.ACTUALIZA_DIFERENCIA(nIdFactura, nDifer, nDiferMoneda);

               OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
            END IF;
            nMtoT := nMtoT + nMtoTotal;
         END LOOP;
      END IF;
      BEGIN
         SELECT SUM(Comision_Local)
           INTO nTotComi
           FROM COMISIONES C
          WHERE IdPoliza  = nIdPoliza
            AND EXISTS (SELECT 1
                          FROM FACTURAS F
                         WHERE F.IdFactura     = C.IdFactura
                           AND F.IdTransaccion = nTransa);
      END;
      BEGIN
         SELECT SUM (Monto_Fact_Local)
           INTO nMtoT
           FROM FACTURAS
          WHERE IdPoliza      = nIdPoliza
            AND IdTransaccion = nTransa;
      END;
      IF cTipoEndoso NOT IN ('RSS', 'EAD') THEN
         OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 8, 'FAC', 'FACTURAS',
                                      nIdPoliza, X.IDetPol, nIdEndoso, nIdFactura, nMtoT);
         OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 8, 'COM', 'COMISIONES',
                                      nIdPoliza, X.IdetPol, NULL, NULL, nTotComi);
      ELSE
         OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 8, 'FAC', 'FACTURAS',
                                      nIdPoliza, X.IDetPol, nIdEndoso, nIdFactura, nMtoT);
      END IF;
      INSERT INTO DETALLE_ENDOSO(IdPoliza,IdEndoso,IdetPol,Monto,IdFactura)
      VALUES (nIdPoliza,nIdEndoso,X.IdetPol,X.PrimaLocal,nIdFactura);

      OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
   END LOOP;
   --
   BEGIN
      SELECT Contabilidad_Automatica
        INTO cContabilidad_Automatica
        FROM EMPRESAS
       WHERE CodCia = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cContabilidad_Automatica := 'N';
   END;
   IF cContabilidad_Automatica = 'S' THEN
      PROC_MOVCONTA(nCodCia, nIdPoliza, cCodMoneda, 'EMI');
   END IF;
END PROC_EMITE_FACT_END;
--
--
-- 
PROCEDURE PROC_EMITE_FACT_CAM(nIdPoliza NUMBER, nIdEndoso NUMBER, pCodCia NUMBER, nTransa NUMBER) IS --LARPLA2
nIdFactura               FACTURAS.IdFactura%TYPE;
nNumPagos                PLAN_DE_PAGOS.NumPagos%TYPE;
nFrecPagos               PLAN_DE_PAGOS.FrecPagos%TYPE;
nPorcInicial             PLAN_DE_PAGOS.PorcInicial%TYPE;
nCodCliente              POLIZAS.CodCliente%TYPE;
cIdTipoSeg               DETALLE_POLIZA.IdTipoSeg%TYPE;
nTotPrimas               DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDifer                   DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDiferMoneda             DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoDet                  DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoDetMoneda            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoTotal                DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoTotalMoneda          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cCodMoneda               POLIZAS.Cod_Moneda%TYPE;
nPrimaNetaMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoPagoMoneda           FACTURAS.Monto_Fact_Moneda%TYPE;
cCodMonedaLocal          EMPRESAS.Cod_Moneda%TYPE;
nPrimaRestMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoComisiMoneda         FACTURAS.MtoComisi_Local%TYPE;
nTotPrimasMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nCodCia                  POLIZAS.CodCia%TYPE;
nCodEmpresa              POLIZAS.CodEmpresa%TYPE;
cCodPlanPago             DETALLE_POLIZA.CodPlanPago%TYPE;
nTasaCambio              DETALLE_POLIZA.Tasa_Cambio%TYPE;
nMtoCpto                 CONCEPTOS_PLAN_DE_PAGOS.MtoCpto%TYPE;
nPorcCpto                CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
cAplica                  CONCEPTOS_PLAN_DE_PAGOS.Aplica%TYPE;
Dummy                    NUMBER(5);
dFecPago                 DATE;
nMtoPago                 NUMBER(18,2);
nMtoComisi               NUMBER(18,2);
nPrimaRest               NUMBER(18,2);
dFecHoy                  DATE;
cGraba                   VARCHAR2(1);
nCod_Agente              AGENTES_DETALLES_POLIZAS.Cod_Agente%TYPE;
nMtoRecD_Local           DETALLE_RECARGO.Monto_Local%TYPE;
nMtoRecD_Moneda          DETALLE_RECARGO.Monto_Moneda%TYPE;
nMtoDescD_Local          DETALLE_DESCUENTO.Monto_Local%TYPE;
nMtoDescD_Moneda         DETALLE_DESCUENTO.Monto_Moneda%TYPE;
nMtoRec_Local            RECARGOS.Monto_Local%TYPE;
nMtoRec_Moneda           RECARGOS.Monto_Moneda%TYPE;
nMtoDesc_Local           DESCUENTOS.Monto_Local%TYPE;
nMtoDesc_Moneda          DESCUENTOS.Monto_Moneda%TYPE;
nPrimaTotalM             DETALLE_POLIZA.Prima_Moneda%TYPE;
nPrimaTotalL             DETALLE_POLIZA.Prima_Local%TYPE;
nFactor                  NUMBER (14,8);
nRec_Local               RECARGOS.Monto_Local%TYPE ;
nRec_Moneda              RECARGOS.Monto_Moneda%TYPE;
nDesc_Local              DESCUENTOS.Monto_Local%TYPE;
nDesc_Moneda             DESCUENTOS.Monto_Moneda%TYPE;
cCodPlanPagoPol          POLIZAS.CodPlanPago%TYPE;
nPorcComis               DETALLE_POLIZA.PorcComis%TYPE;
nNumCert                 DETALLE_POLIZA.IdetPol%TYPE;
nPrimaLocal              NUMBER(18,2);
nPrimaMoneda             NUMBER(18,2);
nIdTransac               NUMBER(14,0);
nMtoComisiRest           NUMBER(18,2);
nMtoComisiMonedaRest     NUMBER(18,2);
nMtoComisiPag            NUMBER(18,2);
nMtoComisiMonedaPag      NUMBER(18,2);
nMtoComiTot              NUMBER(18,2);
nMtoComisiMonedaTot      NUMBER(18,2);
nMtoComiL                NUMBER(18,2);
nMtoComisiM              NUMBER(18,2);
nDiferC                  DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDiferCMon               DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cRespPol                 VARCHAR2(1):='N';
cRespDet                 VARCHAR2(1):='N';
nPorcT                   NUMBER(18,2);
nFact                    NUMBER(18,2);
nCodTipoDoc              TIPO_DE_DOCUMENTO.CodTipoDoc%TYPE;
nIdetPol                 DETALLE_POLIZA.IdetPol%TYPE := 0;
cContabilidad_Automatica EMPRESAS.Contabilidad_Automatica%TYPE;
nIdTranc                 TRANSACCION.idtransaccion%TYPE;
nMtoT                    FACTURAS.monto_fact_local%TYPE := 0;
nMtoTM                   FACTURAS.monto_fact_local%TYPE := 0;
nMtoAsistLocal           ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nMtoAsistMoneda          ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
nAsistRestLocal          ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nAsistRestMoneda         ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
nTotAsistLocal           ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nTotAsistMoneda          ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
cIndFactElectronica      POLIZAS.IndFactElectronica%TYPE;
cIndCalcDerechoEmis      POLIZAS.IndCalcDerechoEmis%TYPE;
nCantPagosReal           NUMBER(5);
fFecfinvig               FACTURAS.FECFINVIG%TYPE;      -- ICOFINVIG

CURSOR DET_POL_Q IS
   SELECT D.Prima_Local PrimaLocal, D.Prima_Moneda PrimaMoneda, D.CodPlanPago, D.PorcComis,
          P.FecIniVig, P.FecFinVig, P.FecEmision, D.IDetPol, D.Tasa_Cambio, D.IdTipoSeg,P.FECRENOVACION
     FROM DETALLE_POLIZA D, POLIZAS P
    WHERE D.Prima_Moneda  > 0
      AND D.IdPoliza      = P.IdPoliza
      AND P.StsPoliza    IN  ('SOL','XRE')
      AND P.IdPoliza      = nIdPoliza
    ORDER BY D.IDetPol;

CURSOR CPTO_PLAN_Q IS
   SELECT CP.CodCpto, CP.PorcCpto, CP.Aplica, CP.MtoCpto,
          CC.IndRangosTipseg
     FROM CONCEPTOS_PLAN_DE_PAGOS CP, CATALOGO_DE_CONCEPTOS CC
    WHERE CC.IndCptoAjuste = 'N'
      AND CC.IndCptoPrimas = 'N'
      AND CC.CodConcepto   = CP.CodCpto
      AND CC.CodCia        = CP.CodCia
      AND CP.CodCia        = pCodCia
      AND CP.CodEmpresa    = nCodEmpresa
      AND CP.CodPlanPago   = cCodPlanPago
      AND EXISTS (SELECT 'S'
                    FROM RAMOS_CONCEPTOS_PLAN
                   WHERE CodCia      = CP.CodCia
                     AND CodEmpresa  = CP.CodEmpresa
                     AND IdTipoSeg  IN (SELECT IdTipoSeg
                                          FROM DETALLE_POLIZA
                                         WHERE IdPoliza  = nIdPoliza)
                     AND CodCpto     = CP.CodCpto
                     AND CodPlanPago = CP.CodPlanPago)
    ORDER BY CP.Prioridad;

CURSOR RESP_PAGO IS
  SELECT R.CodResPago
    FROM RESPONSABLE_PAGO_DET R
   WHERE R.IdPoliza    = nIdPoliza
     AND R.CodCia      = pCodCia
     AND R.CodEmpresa  = nCodEmpresa
   GROUP BY R.CodResPago;

CURSOR CPTO_PRIMAS_Q IS
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERT_ACT C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert  = C.CodCobert
      AND CS.PlanCob    = C.PlanCob
      AND CS.IdTipoSeg  = C.IdTipoSeg
      AND CS.CodEmpresa = C.CodEmpresa
      AND CS.CodCia     = C.CodCia
      AND C.StsCobertura IN ('EMI','SOL','XRE')
      AND C.IdPoliza    = nIdPoliza
      AND C.CodCia      = pCodCia
    GROUP BY CS.CodCpto
    UNION ALL
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERT_ACT_ASEG C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert  = C.CodCobert
      AND CS.PlanCob    = C.PlanCob
      AND CS.IdTipoSeg  = C.IdTipoSeg
      AND CS.CodEmpresa = C.CodEmpresa
      AND CS.CodCia     = C.CodCia
      AND C.StsCobertura IN ('EMI','SOL','XRE')
      AND C.IdPoliza    = nIdPoliza
      AND C.CodCia      = pCodCia
    GROUP BY CS.CodCpto;
CURSOR CPTO_ASIST_Q IS
   SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
          SUM(A.MontoAsistMoneda) MontoAsistMoneda
     FROM ASISTENCIAS_DETALLE_POLIZA A, DETALLE_POLIZA D, ASISTENCIAS T
    WHERE T.CodAsistencia  = A.CodAsistencia
      AND D.IDetPol        = A.IDetPol
      AND D.IdPoliza       = A.IdPoliza
      AND D.CodCia         = A.CodCia
      AND A.StsAsistencia IN ('EMITID','SOLICI','XRENOV')
      AND A.IdPoliza       = nIdPoliza
      AND A.CodCia         = pCodCia
    GROUP BY T.CodCptoServicio
  UNION ALL
   SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
          SUM(A.MontoAsistMoneda) MontoAsistMoneda
     FROM ASISTENCIAS_ASEGURADO A, DETALLE_POLIZA D, ASISTENCIAS T
    WHERE T.CodAsistencia  = A.CodAsistencia
      AND D.IDetPol        = A.IDetPol
      AND D.IdPoliza       = A.IdPoliza
      AND D.CodCia         = A.CodCia
      AND A.StsAsistencia IN ('EMITID','SOLICI','XRENOV')
      AND A.IdPoliza       = nIdPoliza
      AND A.CodCia         = pCodCia
    GROUP BY T.CodCptoServicio;
BEGIN
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
  BEGIN
      SELECT CodCliente, Cod_Moneda, CodCia, CodEmpresa,
             CodPlanPago, IndFactElectronica, IndCalcDerechoEmis
        INTO nCodCliente, cCodMoneda, nCodCia, nCodEmpresa,
             cCodPlanPagoPol, cIndFactElectronica, cIndCalcDerechoEmis
        FROM POLIZAS
       WHERE IdPoliza = nIdPoliza;
    END;
    BEGIN
       SELECT Cod_Moneda
         INTO cCodMonedaLocal
         FROM EMPRESAS
        WHERE CodCia = nCodCia;
  END;
  BEGIN
     SELECT SUM(D.Prima_Local) PrimaLocal, SUM(D.Prima_Moneda) PrimaMoneda, COUNT(IdetPol)
       INTO nPrimaTotalL, nPrimaTotalM, nNumCert
       FROM DETALLE_POLIZA D, POLIZAS P
      WHERE D.Prima_Moneda  > 0
        AND D.IdPoliza   = P.IdPoliza
        AND P.StsPoliza IN ('SOL','XRE')
        AND P.IdPoliza   = nIdPoliza;
   END;

   BEGIN
      SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
        INTO nMtoRec_Local, nMtoRec_Moneda
        FROM RECARGOS
       WHERE IdPoliza = nIdPoliza
         AND Estado   = 'ACT';
   EXCEPTION
      WHEN OTHERS THEN
         nMtoRec_Local  := 0;
         nMtoRec_Moneda := 0;
   END;
   BEGIN
      SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
        INTO nMtoDesc_Local, nMtoDesc_Moneda
        FROM DESCUENTOS
       WHERE IdPoliza  = nIdPoliza
         AND Estado    = 'ACT';
   EXCEPTION
      WHEN OTHERS THEN
         nMtoDesc_Local  := 0;
         nMtoDesc_Moneda := 0;
   END;
   -- Caracteristicas del Plan de Pago
   BEGIN
      SELECT NumPagos, FrecPagos, PorcInicial
        INTO nNumPagos, nFrecPagos, nPorcInicial
        FROM PLAN_DE_PAGOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodPlanPago = cCodPlanPagoPol;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'No Existe Plan de Pagos '||cCodPlanPagoPol);
   END;
   BEGIN
      SELECT 'S'
        INTO cRespPol
        FROM RESPONSABLE_PAGO_POL
       WHERE StsResPago = 'ACT'
         AND CodCia     = pCodCia
         AND IdPoliza   = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cRespPol := 'N';
      WHEN TOO_MANY_ROWS THEN
         cRespPol := 'S';
   END;
   IF cRespPol = 'S' AND FUNC_VALIDA_RESP_POL (nIdPoliza,pCodCia) = 'S' THEN
      PROC_INSERT_RESP_D (nIdPoliza,pCodCia);
   END IF;
   BEGIN
      SELECT 'S'
        INTO cRespDet
        FROM RESPONSABLE_PAGO_DET R
       WHERE R.IdPoliza    = nIdPoliza
         AND R.CodCia      = pCodCia
         AND R.CodEmpresa  = nCodEmpresa;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cRespDet:='N';
      WHEN TOO_MANY_ROWS THEN
         cRespDet:='S';
   END;
   IF cRespPol = 'N' AND cRespDet = 'N' THEN
      FOR X IN DET_POL_Q LOOP
         IF NVL(nIDetPol,0) = 0 THEN
            nIDetPol  := X.IDetPol;
         END IF;
         cIdTipoSeg := X.IdTipoSeg;
         BEGIN
            SELECT Cod_Agente
              INTO nCod_Agente
              FROM AGENTES_DETALLES_POLIZAS
             WHERE IdPoliza      = nIdPoliza
               AND IdetPol       = X.IdetPol
               AND IdTipoSeg     = X.IdTipoSeg
               AND Ind_Principal = 'S';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR (-20100,'No Existe un Agente Definido para el Tipo de Seguro '||X.IdTipoSeg);
            WHEN TOO_MANY_ROWS THEN
               RAISE_APPLICATION_ERROR (-20100,'Existe Mas de un Agente Definido como Principal');
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR (-20100,'Existe un error de otros');
         END;
         cCodPlanPago := X.CodPlanPago;
         nMtoT        := 0;

         OC_DETALLE_TRANSACCION.CREA (nTransa,nCodCia,nCodEmpresa,7,'CER', 'DETALLE_POLIZA',
                                      nIdPoliza, X.IdetPol, NULL, NULL, X.PrimaLocal);

         IF nMtoRec_Local != 0 OR nMtoRec_Moneda != 0 OR nMtoDesc_Local != 0 OR nMtoDesc_Moneda != 0 THEN
            nFactor      := (X.PrimaLocal    / NVL(nPrimaTotalL,0)) * 100;
            nRec_Local   := (nMtoRec_Local  * nFactor) / 100;
            nRec_Moneda  := (nMtoRec_Moneda * nFactor) / 100;
            nDesc_Local  := (nMtoDesc_Local * nFactor) / 100;
            nDesc_Moneda := (nMtoDesc_Moneda * nFactor)/ 100;
         END IF;
         IF nIdEndoso = 0 THEN
            nTasaCambio := X.Tasa_Cambio;
         ELSE
            nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
         END IF;

         -- Determina Meses de Vigencia para Plan de Pagos
         IF nNumPagos <= 12 THEN
            nCantPagosReal  := FLOOR(MONTHS_BETWEEN(X.FecFinVig, X.FecIniVig) / nFrecPagos);
         ELSE
            nCantPagosReal  := FLOOR((X.FecFinVig - X.FecIniVig) / nFrecPagos);
         END IF;
         IF nCantPagosReal <= 0 THEN
            nCantPagosReal := 1;
         END IF;
         IF nCantPagosReal < nNumPagos THEN
            nNumPagos := nCantPagosReal;
         END IF;

         -- Fecha del Primer Pago Siempre a Inicio de Vigencia
         dFecPago := X.FECRENOVACION;  --LARPLA
         -- Monto del Primer Pago
         nTotPrimas       := 0;
         nTotPrimasMoneda := 0;
         nMtoComisi       := 0;
         nMtoComisiMoneda := 0;
         BEGIN
            SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
              INTO nMtoRecD_Local, nMtoRecD_Moneda
              FROM DETALLE_RECARGO
             WHERE IdPoliza = nIdPoliza
               AND IDetPol  = X.IDetPol
               AND Estado   = 'ACT';
         EXCEPTION
            WHEN OTHERS THEN
               nMtoRecD_Local  := 0;
               nMtoRecD_Moneda := 0;
         END;
         BEGIN
            SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
              INTO nMtoDescD_Local, nMtoDescD_Moneda
              FROM DETALLE_DESCUENTO
             WHERE IdPoliza  = nIdPoliza
               AND IDetPol   = X.IDetPol
               AND Estado    = 'ACT';
         EXCEPTION
            WHEN OTHERS THEN
               nMtoDescD_Local  := 0;
               nMtoDescD_Moneda := 0;
         END;

         IF NVL(nPorcInicial,0) <> 0 THEN

            nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0))  * nPorcInicial / 100  ;
            nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) * nPorcInicial / 100 ;
            nMtoComisiPag       := NVL(nMtoComisiPag,0)       + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100) * nPorcInicial / 100 );
            nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + ((NVL(X.PrimaMoneda,0)* X.PorcComis / 100) * nPorcInicial / 100) ;
         ELSE
            nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local    - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) / nNumPagos  ;
            nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda   - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) /nNumPagos ;
            nMtoComisiPag       := nvl(nMtoComisiPag,0)              + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100) / nNumPagos ;
            nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100) / nNumPagos ;
         END IF;

         nPrimaRest           := NVL(nPrimaRest,0)           + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) - NVL(nMtoPago,0);
         nMtoComisiRest       := NVL(nMtoComisiRest,0)       + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100 ) -  NVL(nMtoComisiPag,0));
         nTotPrimas           := NVL(nTotPrimas,0)           + NVL(nMtoPago,0);
         nMtoComisi           := NVL(nMtoComisi,0)           + NVL(nMtoComisiPag,0);
         nPrimaRestMoneda     := NVL(nPrimaRestMoneda,0)     + (NVL(X.PrimaMoneda,0)  + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) - NVL(nMtoPagoMoneda,0);
         nMtoComisiMonedaRest := NVL(nMtoComisiMonedaRest,0) + ((NVL(X.PrimaMoneda,0) * X.PorcComis / 100) -   NVL(nMtoComisiMonedaPag,0));
         nMtoComisiMoneda     := NVL(nMtoComisiMoneda,0)     + NVL(nMtoComisiMonedaPag,0);
         nTotPrimasMoneda     := NVL(nTotPrimasMoneda,0)     + NVL(nMtoPagoMoneda,0);
         nPrimaMoneda         := NVL(nPrimaMoneda,0)         + NVL(X.PrimaMoneda,0);
         nPrimaLocal          := NVL(nPrimaLocal,0)          + NVL(X.PrimaLocal,0) ;
         nMtoComiL            := NVL(nMtoComiL,0)            + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100) ;
         nMtoComisiM          := NVL(nMtoComisiM,0)          + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100) ;
      END LOOP;
      nPrimaRest           := NVL(nPrimaLocal,0)  - NVL(nMtoPago,0);
      nPrimaRestMoneda     := NVL(nPrimaMoneda,0) - NVL(nMtoPagoMoneda,0);
      nMtoComisiRest       := NVL(nMtoComiL,0)    - NVL(nMtoComisiPag,0);
      nMtoComisiMonedaRest := NVL(nMtoComisiM,0)  - NVL(nMtoComisiMonedaPag,0);
      IF NVL(nMtoPagoMoneda,0) != 0 THEN
      
         FOR NP IN 1..nNumPagos LOOP
            IF NP > 1 THEN
               nMtoPago            := NVL(nPrimaRest,0)     / (nNumPagos - 1);
               nMtoComisiPag       := NVL(nMtoComisiRest,0) / (nNumPagos - 1);
               nTotPrimas          := NVL(nTotPrimas,0) + NVL(nMtoPago,0);
               nMtoComisi          := NVL(nMtoComisi,0) + NVL(nMtoComisiPag,0);
               IF nFrecPagos NOT IN (15,7) THEN
                  dFecPago         := ADD_MONTHS(dFecPago,nFrecPagos);
               ELSE
                  dFecPago         := dFecPago + nFrecPagos;
               END IF;
               nMtoPagoMoneda      := NVL(nPrimaRestMoneda,0)     / (nNumPagos - 1);
               nTotPrimasMoneda    := NVL(nTotPrimasMoneda,0)     +  NVL(nMtoPagoMoneda,0);
               nMtoComisiMonedaPag := NVL(nMtoComisiMonedaRest,0) / (nNumPagos - 1);
               nMtoComisiMoneda    := NVL(nMtoComisiMoneda,0) + NVL(nMtoComisiMonedaPag,0);
            END IF;
            -- LARPLA
            nIdFactura := OC_FACTURAS.INSERTAR(nIdPoliza,           nIDetPol,       nCodCliente, dFecPago, 
                                               nMtoPago,            nMtoPagoMoneda, nIdEndoso,   nMtoComisiPag, 
                                               nMtoComisiMonedaPag, NP,             nTasaCambio, nCod_Agente,
                                               nCodTipoDoc,         pCodCia,        cCodMoneda,  NULL, 
                                               nTransa,             cIndFactElectronica);

            FOR W IN CPTO_PRIMAS_Q LOOP
               nFactor := W.Prima_Local / NVL(nPrimaLocal,0);
               OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
               OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
            END LOOP;

            nTotAsistLocal  := 0;
            nTotAsistMoneda := 0;
            FOR K IN CPTO_ASIST_Q LOOP
               nAsistRestLocal  := 0;
               nAsistRestMoneda := 0;
               IF NVL(nPorcInicial,0) <> 0 THEN
                  nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) * nPorcInicial / 100);
                  nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) * nPorcInicial / 100);
               ELSE
                  nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) / nNumPagos);
                  nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) / nNumPagos);
               END IF;
               nTotAsistLocal  := NVL(nTotAsistLocal,0) + NVL(nMtoAsistLocal,0);
               nTotAsistMoneda := NVL(nTotAsistMoneda,0) + NVL(nMtoAsistMoneda,0);
               OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
               OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
               OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
            END LOOP;

            nMtoT := nMtoT + nMtoPago;
            nMtoTM:= nMtoTM + nMtoPagoMoneda;

            -- Genera comisiones por agente por Poliza
            PROC_COMISIONPOL (nIdPoliza, nIDetPol, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFactura,
                              nMtoComisiPag/nNumCert, nMtoComisiMonedaPag/nNumCert, nTasaCambio);

           -- Distribuye la comision por agente.
            FOR Y IN CPTO_PLAN_Q LOOP
               BEGIN
                  SELECT 'S'
                    INTO cGraba
                    FROM RAMOS_CONCEPTOS_PLAN R
                   WHERE R.CodPlanPago = cCodPlanPago
                     AND R.CodCpto     = Y.CodCpto
                     AND R.CodCia      = nCodCia
                     AND R.CodEmpresa  = nCodEmpresa
                     AND EXISTS   (SELECT 1
                                     FROM DETALLE_POLIZA D, POLIZAS P
                                    WHERE D.IdPoliza   = P.IdPoliza
                                      AND D.IdTipoSeg  = R.IdTipoSeg
                                      AND P.StsPoliza IN ('SOL','XRE')
                                      AND P.IdPoliza   = nIdPoliza);
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     cGraba := 'N';
                  WHEN TOO_MANY_ROWS THEN
                     cGraba := 'S';
               END;

               IF cGraba = 'S' THEN
                  IF Y.IndRangosTipseg = 'S' THEN
                     IF cIndCalcDerechoEmis = 'S' THEN
                        OC_CATALOGO_CONCEPTOS_RANGOS.VALOR_CONCEPTO(nCodCia, nCodEmpresa, Y.CodCpto, cIdTipoSeg,
                                                                    nIdPoliza, 0, nIdEndoso, nMtoCpto, nPorcCpto);
                        IF OC_DETALLE_FACTURAS.EXISTE_CONCEPTO(nCodCia, nIdPoliza, nTransa, Y.CodCpto) = 'N' THEN
                           IF NVL(nMtoCpto,0) = 0 AND NVL(nPorcCpto,0) = 0 THEN
                              nMtoCpto  := Y.MtoCpto;
                              nPorcCpto := Y.PorcCpto;
                           END IF;
                        ELSE
                           nMtoCpto  := 0;
                           nPorcCpto := 0;
                        END IF;
                     ELSE
                        nMtoCpto  := 0;
                        nPorcCpto := 0;
                     END IF;
                  ELSE
                     nMtoCpto  := Y.MtoCpto;
                     nPorcCpto := Y.PorcCpto;
                  END IF;
                  IF Y.Aplica = 'P' THEN
                     IF NVL(nMtoCpto,0) <> 0 AND NP = 1 THEN
                        nMtoDet       := NVL(nMtoCpto,0);
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                     ELSIF NP = 1 THEN
                        nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                        nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                     ELSE
                        nMtoDet       := 0;
                        nMtoDetMoneda := 0;
                     END IF;
                     IF NVL(nMtoDet,0) != 0 THEN
                        OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                        nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                     END IF;
                  ELSIF Y.Aplica = 'T' THEN
                     IF NVL(nMtoCpto,0) <> 0 THEN
                        nMtoDet       := NVL(nMtoCpto,0);
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                     ELSE
                        nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                        nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                     END IF;
                     IF NVL(nMtoDet,0) != 0 THEN
                        OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                        nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                     END IF;
                  END IF;
                  nMtoT := nMtoT + nMtoDet;
               END IF;
            END LOOP;
            OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
            OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
         END LOOP;
         OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'FAC', 'FACTURAS',
                                      nIdPoliza, nIdetPol, NULL, NULL, nMtoT);
         OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'COM', 'COMISIONES',
                                      nIdPoliza, nIdetPol, NULL, NULL, nMtoComisiPag);

         IF (NVL(nPrimaLocal,0) + nMtoRecD_Local - nMtoDescD_Local +
             NVL(nRec_Local,0) - NVL(nDesc_Local,0)) <> NVL(nTotPrimas,0) THEN
            nDifer       := (NVL(nPrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local   +
                             NVL(nRec_Local,0)  - NVL(nDesc_Local,0)) - NVL(nTotPrimas,0);
            nDiferMoneda := (NVL(nPrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda  +
                             NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) - NVL(nTotPrimasMoneda,0);
            nDiferC      :=  NVL(nMtoComiL,0)   - NVL(nMtoComisi,0);
            nDiferCMon   :=  NVL(nMtoComisiM,0) - NVL(nMtoComisiMoneda,0);

            OC_DETALLE_FACTURAS.ACTUALIZA_DIFERENCIA(nIdFactura, nDifer, nDiferMoneda);

            OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
            OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');

            UPDATE FACTURAS
               SET MtoComisi_Local   = MtoComisi_Local   + NVL(nDiferC,0),
                   MtoComisi_Moneda  = MtoComisi_Moneda  + NVL(nDiferCMon,0)
             WHERE IdFactura = nIdFactura;
         END IF;
      END IF;
   ELSE
      BEGIN
         SELECT SUM(R.PorcResPago)
           INTO nPorcT
           FROM RESPONSABLE_PAGO_DET R
          WHERE R.IdPoliza    = nIdPoliza
            AND R.CodCia      = nCodCia
            AND R.CodEmpresa  = nCodEmpresa ;
      END;
      FOR J IN RESP_PAGO LOOP
         BEGIN
            SELECT (SUM(PORCRESPAGO)/nPorcT) * 100
              INTO nFact
              FROM RESPONSABLE_PAGO_DET r
             WHERE R.IdPoliza    = nIdPoliza
               AND R.CodCia      = nCodCia
               AND R.CodEmpresa  = nCodEmpresa
               AND R.CodResPago  = J.CodResPago;
         END;
         nMtoPago             := 0;
         nMtoPagoMoneda       := 0;
         nMtoComisiPag        := 0;
         nMtoComisiMonedaPag  := 0;
         nPrimaRest           := 0;
         nMtoComisiRest       := 0;
         nTotPrimas           := 0;
         nMtoComisi           := 0;
         nPrimaRestMoneda     := 0;
         nMtoComisiMonedaRest := 0;
         nMtoComisiMoneda     := 0;
         nTotPrimasMoneda     := 0;
         nPrimaMoneda         := 0;
         nPrimaLocal          := 0;
         nMtoComiL            := 0;
         nMtoComisiM          := 0;
         FOR X IN DET_POL_Q LOOP
            cIdTipoSeg := X.IdTipoSeg;
            BEGIN
               SELECT Cod_Agente
                 INTO nCod_Agente
                 FROM AGENTES_DETALLES_POLIZAS
                WHERE IdPoliza      = nIdPoliza
                  AND IdetPol       = X.IdetPol
                  AND IdTipoSeg     = X.IdTipoSeg
                  AND Ind_Principal = 'S';
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR (-20100,'No Existe un Agente Definido para el Tipo de Seguro '||X.IdTipoSeg);
               WHEN TOO_MANY_ROWS THEN
                  RAISE_APPLICATION_ERROR (-20100,'Existe Mas de un Agente Definido como Principal');
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR (-20100,'Existe un error de otros');
            END;
            cCodPlanPago := X.CodPlanPago;
            IF nMtoRec_Local != 0 OR nMtoRec_Moneda != 0 OR nMtoDesc_Local != 0 OR nMtoDesc_Moneda != 0 THEN
               nFactor      := (X.PrimaLocal * NVL(nFact,0)/100) / NVL(nPrimaTotalL,0) * 100;
               nRec_Local   := (nMtoRec_Local  * nFactor) / 100;
               nRec_Moneda  := (nMtoRec_Moneda * nFactor) / 100;
               nDesc_Local  := (nMtoDesc_Local * nFactor) / 100;
               nDesc_Moneda := (nMtoDesc_Moneda * nFactor)/ 100;
            END IF;
            IF nIdEndoso = 0 THEN
               nTasaCambio := X.Tasa_Cambio;
            ELSE
               nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
            END IF;

            -- Determina Meses de Vigencia para Plan de Pagos
            IF nNumPagos <= 12 THEN
               nCantPagosReal  := FLOOR(MONTHS_BETWEEN(X.FecFinVig, X.FecIniVig) / nFrecPagos);
            ELSE
               nCantPagosReal  := FLOOR((X.FecFinVig - X.FecIniVig) / nFrecPagos);
            END IF;

            IF nCantPagosReal <= 0 THEN
               nCantPagosReal := 1;
            END IF;
            IF nCantPagosReal < nNumPagos THEN
               nNumPagos := nCantPagosReal;
            END IF;

            -- Fecha del Primer Pago Siempre a Inicio de Vigencia
            dFecPago := X.FECRENOVACION;   --LARPLA
            -- Monto del Primer Pago
            nTotPrimas       := 0;
            nTotPrimasMoneda := 0;
            nMtoComisi       := 0;
            nMtoComisiMoneda := 0;
            BEGIN
               SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
                 INTO nMtoRecD_Local, nMtoRecD_Moneda
                 FROM DETALLE_RECARGO
                WHERE IdPoliza = nIdPoliza
                  AND IDetPol  = X.IDetPol
                  AND Estado   = 'ACT';
            EXCEPTION
               WHEN OTHERS THEN
                  nMtoRecD_Local  := 0;
                  nMtoRecD_Moneda := 0;
            END;
            BEGIN
               SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
                 INTO nMtoDescD_Local, nMtoDescD_Moneda
                 FROM DETALLE_DESCUENTO
                WHERE IdPoliza  = nIdPoliza
                  AND IDetPol   = X.IDetPol
                  AND Estado    = 'ACT';
            EXCEPTION
               WHEN OTHERS THEN
                  nMtoDescD_Local  := 0;
                  nMtoDescD_Moneda := 0;
            END;

            IF NVL(nPorcInicial,0) <> 0 THEN
               nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0))  * nPorcInicial / 100 * NVL(nFact,0)/100;
               nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) * nPorcInicial / 100 *  NVL(nFact,0)/100;
               nMtoComisiPag       := NVL(nMtoComisiPag,0)       + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100) * nPorcInicial / 100 )* NVL(nFact,0)/100;
               nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + ((NVL(X.PrimaMoneda,0)* X.PorcComis / 100) * nPorcInicial / 100)* NVL(nFact,0)/100;
            ELSE
               nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local    - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) / nNumPagos * NVL(nFact,0)/100;
               nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda   - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) /nNumPagos* NVL(nFact,0)/100;
               nMtoComisiPag       := nMtoComisiPag              + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100) / nNumPagos * NVL(nFact,0)/100;
               nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100) / nNumPagos * NVL(nFact,0)/100;
            END IF;
            nPrimaRest           := NVL(nPrimaRest,0)     + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local + NVL(nRec_Local,0) - NVL(nDesc_Local,0) * NVL(nFact,0)/100) - NVL(nMtoPago,0);
            nMtoComisiRest       := NVL(nMtoComisiRest,0) + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100 * NVL(nFact,0)/100) -  NVL(nMtoComisiPag,0));
            nTotPrimas           := NVL(nTotPrimas,0) * NVL(nFact,0)/100 + NVL(nMtoPago,0);
            nMtoComisi           := NVL(nMtoComisi,0)  + NVL(nMtoComisiPag,0);

            nPrimaRestMoneda     := NVL(nPrimaRestMoneda,0)     + (NVL(X.PrimaMoneda,0)  + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0) * NVL(nFact,0)/100) - NVL(nMtoPagoMoneda,0);
            nMtoComisiMonedaRest := NVL(nMtoComisiMonedaRest,0) + ((NVL(X.PrimaMoneda,0) * X.PorcComis / 100) -   NVL(nMtoComisiMonedaPag,0))* NVL(nFact,0)/100;
            nMtoComisiMoneda     := NVL(nMtoComisiMoneda,0)     + NVL(nMtoComisiMonedaPag,0);
            nTotPrimasMoneda     := NVL(nTotPrimasMoneda,0)* NVL(nFact,0)/100   + NVL(nMtoPagoMoneda,0);

            nPrimaMoneda         := NVL(nPrimaMoneda,0) + NVL(X.PrimaMoneda,0)* NVL(nFact,0)/100;
            nPrimaLocal          := NVL(nPrimaLocal,0)  + NVL(X.PrimaLocal,0)* NVL(nFact,0)/100;
            nMtoComiL            := NVL(nMtoComiL,0)    + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100)* NVL(nFact,0)/100;
            nMtoComisiM          := NVL(nMtoComisiM,0)  + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100)* NVL(nFact,0)/100;
         END LOOP;
         nPrimaRest           := NVL(nPrimaLocal,0)  - NVL(nMtoPago,0);
         nPrimaRestMoneda     := NVL(nPrimaMoneda,0) - NVL(nMtoPagoMoneda,0);
         nMtoComisiRest       := NVL(nMtoComiL,0)    - NVL(nMtoComisiPag,0);
         nMtoComisiMonedaRest := NVL(nMtoComisiM,0)  - NVL(nMtoComisiMonedaPag,0);
         nMtoT                := 0;

         IF NVL(nMtoPagoMoneda,0) != 0 THEN
            FOR NP IN 1..nNumPagos LOOP
               IF NP > 1 THEN
                  nMtoPago            := NVL(nPrimaRest,0)     / (nNumPagos - 1);
                  nMtoComisiPag       := NVL(nMtoComisiRest,0) / (nNumPagos - 1);
                  nTotPrimas          := NVL(nTotPrimas,0) + NVL(nMtoPago,0);
                  nMtoComisi          := NVL(nMtoComisi,0) + NVL(nMtoComisiPag,0);
                  IF nFrecPagos NOT IN (15,7) THEN
                     dFecPago         := ADD_MONTHS(dFecPago,nFrecPagos);
                  ELSE
                     dFecPago         := dFecPago + nFrecPagos;
                  END IF;
                  nMtoPagoMoneda      := NVL(nPrimaRestMoneda,0)     / (nNumPagos - 1);
                  nTotPrimasMoneda    := NVL(nTotPrimasMoneda,0)     +  NVL(nMtoPagoMoneda,0);
                  nMtoComisiMonedaPag := NVL(nMtoComisiMonedaRest,0) / (nNumPagos - 1);
                  nMtoComisiMoneda    := NVL(nMtoComisiMoneda,0) + NVL(nMtoComisiMonedaPag,0);
               END IF;
               -- LARPLA
               nIdFactura := OC_FACTURAS.INSERTAR(nIdPoliza,           nIdetPol,       nCodCliente, dFecPago, 
                                                  nMtoPago,            nMtoPagoMoneda, nIdEndoso,   nMtoComisiPag, 
                                                  nMtoComisiMonedaPag, NP,             nTasaCambio, nCod_Agente, 
                                                  nCodTipoDoc,         pCodCia,        cCodMoneda,  J.CodResPago, 
                                                  nTransa,             cIndFactElectronica);

               FOR W IN CPTO_PRIMAS_Q LOOP
                  nFactor := W.Prima_Local / NVL(nPrimaLocal,0);
                  OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
                  OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
               END LOOP;

               nTotAsistLocal  := 0;
               nTotAsistMoneda := 0;
               FOR K IN CPTO_ASIST_Q LOOP
                  nAsistRestLocal  := 0;
                  nAsistRestMoneda := 0;
                  IF NVL(nPorcInicial,0) <> 0 THEN
                     nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) * nPorcInicial / 100) * NVL(nFact,0)/100;
                     nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) * nPorcInicial / 100) * NVL(nFact,0)/100;
                  ELSE
                     nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) / nNumPagos) * NVL(nFact,0)/100;
                     nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) / nNumPagos) * NVL(nFact,0)/100;
                  END IF;
                  nTotAsistLocal  := NVL(nTotAsistLocal,0) + NVL(nMtoAsistLocal,0);
                  nTotAsistMoneda := NVL(nTotAsistMoneda,0) + NVL(nMtoAsistMoneda,0);
                  OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
                  OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
               END LOOP;

               nMtoT := nMtoT + nMtoPago;
               PROC_COMISIONPOL (nIdPoliza, nIDetPol, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFactura,
                                 nMtoComisiPag/nNumCert, nMtoComisiMonedaPag/nNumCert, nTasaCambio);

               -- Distribuye la comision por agente.
               FOR Y IN CPTO_PLAN_Q LOOP
                  BEGIN
                     SELECT 'S'
                       INTO cGraba
                       FROM RAMOS_CONCEPTOS_PLAN R
                      WHERE R.CodPlanPago = cCodPlanPago
                        AND R.CodCpto     = Y.CodCpto
                        AND R.CodCia      = nCodCia
                        AND R.CodEmpresa  = nCodEmpresa
                        AND EXISTS   (SELECT 1
                                        FROM DETALLE_POLIZA D, POLIZAS P
                                       WHERE D.IdPoliza   = P.IdPoliza
                                         AND D.IdTipoSeg  = R.IdTipoSeg
                                         AND P.StsPoliza IN ('SOL','XRE')
                                         AND P.IdPoliza   = nIdPoliza);
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        cGraba := 'N';
                     WHEN TOO_MANY_ROWS THEN
                        cGraba := 'S';
                  END;

                  IF cGraba = 'S' THEN
                     IF Y.IndRangosTipseg = 'S' THEN
                        IF cIndCalcDerechoEmis = 'S' THEN
                           OC_CATALOGO_CONCEPTOS_RANGOS.VALOR_CONCEPTO(nCodCia, nCodEmpresa, Y.CodCpto, cIdTipoSeg,
                                                                       nIdPoliza, 0, nIdEndoso, nMtoCpto, nPorcCpto);
                           IF OC_DETALLE_FACTURAS.EXISTE_CONCEPTO(nCodCia, nIdPoliza, nTransa, Y.CodCpto) = 'N' THEN
                              IF NVL(nMtoCpto,0) = 0 AND NVL(nPorcCpto,0) = 0 THEN
                                 nMtoCpto  := Y.MtoCpto;
                                 nPorcCpto := Y.PorcCpto;
                              END IF;
                           ELSE
                              nMtoCpto  := 0;
                              nPorcCpto := 0;
                           END IF;
                        ELSE
                           nMtoCpto  := 0;
                           nPorcCpto := 0;
                        END IF;
                     ELSE
                        nMtoCpto  := Y.MtoCpto;
                        nPorcCpto := Y.PorcCpto;
                     END IF;

                     IF Y.Aplica = 'P' THEN
                        IF NVL(nMtoCpto,0) <> 0 AND NP = 1 THEN
                           nMtoDet       := NVL(nMtoCpto,0);
                           nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                        ELSIF NP = 1 THEN
                           nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                           nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                        ELSE
                           nMtoDet       := 0;
                           nMtoDetMoneda := 0;
                        END IF;
                        IF NVL(nMtoDet,0) != 0 THEN
                           OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                           OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                           nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                           nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                        END IF;
                     ELSIF Y.Aplica = 'T' THEN
                        IF NVL(nMtoCpto,0) <> 0 THEN
                           nMtoDet       := NVL(nMtoCpto,0);
                           nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                        ELSE
                           nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                           nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                        END IF;
                        IF NVL(nMtoDet,0) != 0 THEN
                           OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                           OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                           nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                           nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                        END IF;
                     END IF;
                     nMtoT := nMtoT + nMtoDet;
                  END IF;
               END LOOP;
               OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
               OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
            END LOOP;

            IF (NVL(nPrimaLocal,0)+ nMtoRecD_Local - nMtoDescD_Local +
                NVL(nRec_Local,0) - NVL(nDesc_Local,0)) <> NVL(nTotPrimas,0) THEN
               nDifer       := (NVL(nPrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local   +
                                NVL(nRec_Local,0)  - NVL(nDesc_Local,0)) - NVL(nTotPrimas,0);
               nDiferMoneda := (NVL(nPrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda  +
                                NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) - NVL(nTotPrimasMoneda,0);
               nDiferC      :=  NVL(nMtoComiL,0)   - NVL(nMtoComisi,0);
               nDiferCMon   :=  NVL(nMtoComisiM,0) - NVL(nMtoComisiMoneda,0);

               PROC_COMISIONPOL (nIdPoliza, nIDetPol, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFactura,
                                 nDiferC/nNumCert, nDiferCMon/nNumCert, nTasaCambio);

               OC_DETALLE_FACTURAS.ACTUALIZA_DIFERENCIA(nIdFactura, nDifer, nDiferMoneda);

               OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
               OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');

               UPDATE FACTURAS
                  SET MtoComisi_Local   = MtoComisi_Local   + NVL(nDiferC,0),
                      MtoComisi_Moneda  = MtoComisi_Moneda  + NVL(nDiferCMon,0)
                WHERE IdFactura = nIdFactura;
            END IF;
         END IF;
      END LOOP;
      OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
      IF NVL(nPrimaRestMoneda,0) != 0 THEN
         OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'FAC', 'FACTURAS',
                                      nIdPoliza, nIdetPol, NULL, NULL, nMtoT);
         OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'COM', 'COMISIONES',
                                      nIdPoliza, nIdetPol, NULL, NULL, nMtoDet);
      END IF;
   END IF;
   BEGIN
      SELECT Contabilidad_Automatica
        INTO cContabilidad_Automatica
        FROM EMPRESAS
       WHERE CodCia = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cContabilidad_Automatica := 'N';
   END;
   IF cContabilidad_Automatica = 'S' THEN
      PROC_MOVCONTA(nCodCia, nIdPoliza, cCodMoneda, 'EMI');
   END IF;
END PROC_EMITE_FACT_CAM;  --LARPLA2
--
--
--
PROCEDURE PROC_FACT_FIANZA (nIdPoliza NUMBER, nIdEndoso NUMBER, pCodCia NUMBER, nTransa NUMBER) IS
nIdFactura               FACTURAS.IdFactura%TYPE;
nNumPagos                PLAN_DE_PAGOS.NumPagos%TYPE;
nFrecPagos               PLAN_DE_PAGOS.FrecPagos%TYPE;
nPorcInicial             PLAN_DE_PAGOS.PorcInicial%TYPE;
nCodCliente              POLIZAS.CodCliente%TYPE;
cIdTipoSeg               DETALLE_POLIZA.IdTipoSeg%TYPE;
nTotPrimas               DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDifer                   DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDiferMoneda             DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoDet                  DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoDetMoneda            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoTotal                DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoTotalMoneda          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cCodMoneda               POLIZAS.Cod_Moneda%TYPE;
nPrimaNetaMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoPagoMoneda           FACTURAS.Monto_Fact_Moneda%TYPE;
cCodMonedaLocal          EMPRESAS.Cod_Moneda%TYPE;
nPrimaRestMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoComisiMoneda         FACTURAS.MtoComisi_Local%TYPE;
nTotPrimasMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nCodCia                  POLIZAS.CodCia%TYPE;
nCodEmpresa              POLIZAS.CodEmpresa%TYPE;
cCodPlanPago             DETALLE_POLIZA.CodPlanPago%TYPE;
nTasaCambio              DETALLE_POLIZA.Tasa_Cambio%TYPE;
nMtoCpto                 CONCEPTOS_PLAN_DE_PAGOS.MtoCpto%TYPE;
nPorcCpto                CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
cAplica                  CONCEPTOS_PLAN_DE_PAGOS.Aplica%TYPE;
Dummy                    NUMBER(5);
dFecPago                 DATE;
nMtoPago                 NUMBER(18,2);
nMtoComisi               NUMBER(18,2);
nPrimaRest               NUMBER(18,2);
dFecHoy                  DATE;
cGraba                   VARCHAR2(1);
nCod_Agente              AGENTES_DETALLES_POLIZAS.Cod_Agente%TYPE;
--
nMtoRecD_Local           DETALLE_RECARGO.Monto_Local%TYPE;
nMtoRecD_Moneda          DETALLE_RECARGO.Monto_Moneda%TYPE;
nMtoDescD_Local          DETALLE_DESCUENTO.Monto_Local%TYPE;
nMtoDescD_Moneda         DETALLE_DESCUENTO.Monto_Moneda%TYPE;
--
nMtoRec_Local            RECARGOS.Monto_Local%TYPE;
nMtoRec_Moneda           RECARGOS.Monto_Moneda%TYPE;
nMtoDesc_Local           DESCUENTOS.Monto_Local%TYPE;
nMtoDesc_Moneda          DESCUENTOS.Monto_Moneda%TYPE;
nPrimaTotalM             DETALLE_POLIZA.Prima_Moneda%TYPE;
nPrimaTotalL             DETALLE_POLIZA.Prima_Local%TYPE;
nFactor                  NUMBER (18,2);
nRec_Local               RECARGOS.Monto_Local%TYPE ;
nRec_Moneda              RECARGOS.Monto_Moneda%TYPE;
nDesc_Local              DESCUENTOS.Monto_Local%TYPE;
nDesc_Moneda             DESCUENTOS.Monto_Moneda%TYPE;
nNumCert                 DETALLE_POLIZA.idetPol%type;
nPorcResPago             RESPONSABLE_PAGO_DET.PorcResPago%TYPE;
cRespPol                 VARCHAR2(1):='N';
cRespDet                 VARCHAR2(1):='N';
nCodTipoDoc              TIPO_DE_DOCUMENTO.CodTipoDoc%TYPE;
cContabilidad_Automatica EMPRESAS.Contabilidad_Automatica%TYPE;
nMtoT                    FACTURAS.monto_fact_local%TYPE := 0;
nMtoTM                   FACTURAS.monto_fact_local%TYPE := 0;
nIdetPol                 DETALLE_POLIZA.IdetPol%TYPE := 1;
cIndCalcDerechoEmis      POLIZAS.IndCalcDerechoEmis%TYPE;
p_msg_regreso varchar2(50);----var XDS
nCantPagosReal           NUMBER(5);
fFecfinvig               FACTURAS.FECFINVIG%TYPE;      -- ICOFINVIG

CURSOR DET_POL_Q IS
   SELECT D.PrimaLocal PrimaLocal, D.PrimaMoneda PrimaMoneda, D.CodPlanPago,
          P.FecIniVig, P.FecFinVig, P.FecEmision, D.Correlativo IDetpol, D.PorcComis,
          D.IdTipoSeg, P.IndFactElectronica
     FROM FZ_DETALLE_FIANZAS D, POLIZAS P
    WHERE D.PrimaLocal  > 0
      AND D.IdPoliza    = P.IdPoliza
      AND P.StsPoliza  IN ('SOL','XRE')
      AND P.IdPoliza    = nIdPoliza;

CURSOR CPTO_PLAN_Q IS
   SELECT CP.CodCpto, CP.PorcCpto, CP.Aplica, CP.MtoCpto,
          CC.IndRangosTipseg
     FROM CONCEPTOS_PLAN_DE_PAGOS CP, CATALOGO_DE_CONCEPTOS CC
    WHERE CC.IndCptoAjuste = 'N'
      AND CC.IndCptoPrimas = 'N'
      AND CC.CodConcepto   = CP.CodCpto
      AND CC.CodCia        = CP.CodCia
      AND CP.CodCia        = nCodCia
      AND CP.CodEmpresa    = nCodEmpresa
      AND CP.CodPlanPago   = cCodPlanPago
      AND EXISTS (SELECT 'S'
                    FROM RAMOS_CONCEPTOS_PLAN
                   WHERE CodCia      = CP.CodCia
                     AND CodEmpresa  = CP.CodEmpresa
                     AND IdTipoSeg   = cIdTipoSeg
                     AND CodCpto     = CP.CodCpto
                     AND CodPlanPago = CP.CodPlanPago)
    ORDER BY CP.Prioridad;

CURSOR RESP_PAGO IS
  SELECT R.PORCRESPAGO,R.CODRESPAGO,R.IDetPol
    FROM RESPONSABLE_PAGO_DET R
   WHERE R.IdPoliza    = nIdPoliza
     AND R.CodCia      = pCodCia
     AND R.CodEmpresa  = nCodEmpresa
     and R.IdetPol     = nNumCert;

CURSOR RESP_PAGO_POL IS
  SELECT R.PORCRESPAGO,R.CODRESPAGO
    FROM RESPONSABLE_PAGO_POL R
   WHERE R.IdPoliza    = nIdPoliza
     AND R.CodCia      = pCodCia
     AND R.CodEmpresa  = nCodEmpresa;
BEGIN
   BEGIN
      SELECT CODTIPODOC
        INTO nCodTipoDoc
        FROM TIPO_DE_DOCUMENTO
       WHERE  CODCLASE = 'F'
         AND SUGERIDO = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nCodTipoDoc := NULL;
   END;
   BEGIN
      SELECT 'S'
        INTO cRespPol
        FROM RESPONSABLE_PAGO_POL
       WHERE StsResPago = 'ACT'
         AND CodCia     = pCodCia
         AND IdPoliza   = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cRespPol := 'N';
      WHEN TOO_MANY_ROWS THEN
         cRespPol := 'S';
   END;
   IF cRespPol = 'S' AND  FUNC_VALIDA_RESP_POL (nIdPoliza,pCodCia)= 'S' THEN
       PROC_INSERT_RESP_D (nIdPoliza,pCodCia);
   END IF;
   BEGIN
      SELECT CodCliente, Cod_Moneda, CodCia, CodEmpresa, IndCalcDerechoEmis
        INTO nCodCliente, cCodMoneda, nCodCia, nCodEmpresa, cIndCalcDerechoEmis
        FROM POLIZAS
       WHERE IdPoliza = nIdPoliza;
   END;
   BEGIN
      SELECT Cod_Moneda
        INTO cCodMonedaLocal
        FROM EMPRESAS
       WHERE CodCia = nCodCia;
   END;
   BEGIN
      SELECT SUM(D.Prima_Local) PrimaLocal, SUM(D.Prima_Moneda)PrimaMoneda
        INTO nPrimaTotalL,nPrimaTotalM
        FROM DETALLE_POLIZA D, POLIZAS P
       WHERE D.IdPoliza   = P.IdPoliza
         AND P.StsPoliza IN ('SOL','XRE')
         AND P.IdPoliza   = nIdPoliza;
   END;
   BEGIN
      SELECT NVL(SUM(Monto_Local),0),NVL(SUM(Monto_Moneda),0)
        INTO nMtoRec_Local,nMtoRec_Moneda
        FROM RECARGOS
       WHERE IdPoliza = nIdPoliza
         AND Estado   = 'ACT';
   EXCEPTION
        WHEN OTHERS THEN
            nMtoRec_Local  := 0;
            nMtoRec_Moneda := 0;
    END;
    BEGIN
         SELECT NVL(SUM(Monto_Local),0),NVL(SUM(Monto_Moneda),0)
           INTO nMtoDesc_Local,nMtoDesc_Moneda
         FROM DESCUENTOS
        WHERE IdPoliza  = nIdPoliza
          AND Estado    = 'ACT';
    EXCEPTION
        WHEN OTHERS THEN
            nMtoDesc_Local  := 0;
            nMtoDesc_Moneda := 0;
    END;
    FOR X IN DET_POL_Q LOOP
       nMtoT        := 0;
       OC_DETALLE_TRANSACCION.CREA (nTransa,nCodCia,nCodEmpresa,7,'CER', 'FZ_DETALLE_FIANZAS',
                                   nIdPoliza, x.idetpol,NULL,  NULL, X.PrimaLocal);
       nNUmcert := x.idetpol;
       BEGIN
          SELECT 'S'
            INTO  cRespDet
            FROM RESPONSABLE_PAGO_DET R
           WHERE R.IdPoliza    = nIdPoliza
             AND R.CodCia      = pCodCia
             AND R.CodEmpresa  = nCodEmpresa
             AND R.IdetPol     = x.idetpol;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             cRespDet:='N';
          WHEN TOO_MANY_ROWS THEN
              cRespDet:='S';
       END;
       IF cRespPol = 'N' AND  cRespDet = 'N' THEN
          cCodPlanPago := X.CodPlanPago;
          IF nMtoRec_Local != 0 OR nMtoRec_Moneda != 0 OR nMtoDesc_Local != 0 OR nMtoDesc_Moneda != 0 THEN
             nFactor      := (X.PrimaLocal / NVL(nPrimaTotalL,0)) * 100;
             nRec_Local   := (nMtoRec_Local   * nFactor) / 100;
             nRec_Moneda  := (nMtoRec_Moneda  * nFactor) / 100;
             nDesc_Local  := (nMtoDesc_Local  * nFactor) / 100;
             nDesc_Moneda := (nMtoDesc_Moneda * nFactor) / 100;
          END IF;
          BEGIN
             SELECT Cod_Agente
               INTO nCod_Agente
               FROM AGENTES_DETALLES_POLIZAS
              WHERE IdPoliza      = nIdPoliza
                AND IdetPol       = X.IdetPol
                AND IdTipoSeg     = X.IdTipoSeg
                AND Ind_Principal = 'S';
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR (-20100,'No Existe un Agente Definido para el Tipo de Seguro ');
             WHEN TOO_MANY_ROWS THEN
                RAISE_APPLICATION_ERROR (-20100,'Existe Mas de un Agente Definido como Principal');
             WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20100,'Existe un error de otros');

          END;
          nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
          -- Características del Plan de Pago
          BEGIN
             SELECT NumPagos, FrecPagos, PorcInicial
               INTO nNumPagos, nFrecPagos, nPorcInicial
               FROM PLAN_DE_PAGOS
              WHERE CodCia      = nCodCia
                AND CodEmpresa  = nCodEmpresa
                AND CodPlanPago = X.CodPlanPago;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR (-20100,'No Existe Plan de Pagos '||X.CodPlanPago);

          END;

          -- Determina Meses de Vigencia para Plan de Pagos
          IF nNumPagos <= 12 THEN
             nCantPagosReal  := FLOOR(MONTHS_BETWEEN(X.FecFinVig, X.FecIniVig) / nFrecPagos);
          ELSE
             nCantPagosReal  := FLOOR((X.FecFinVig - X.FecIniVig) / nFrecPagos);
          END IF;

          IF nCantPagosReal <= 0 THEN
             nCantPagosReal := 1;
          END IF;
          IF nCantPagosReal < nNumPagos THEN
             nNumPagos := nCantPagosReal;
          END IF;

            -- Fecha del Primer Pago Siempre a Inicio de Vigencia
            dFecPago := X.FecIniVig;
            /*IF X.FecIniVig > X.FecEmision THEN
               dFecPago := X.FecIniVig;
            ELSE
               dFecPago := X.FecEmision;
            END IF;*/
           -- Monto del Primer Pago
              nTotPrimas       := 0;
              nTotPrimasMoneda := 0;
               BEGIN
                  SELECT  NVL(SUM(Monto_Local),0),NVL(SUM(Monto_Moneda),0)
                    INTO nMtoRecD_Local,nMtoRecD_Moneda
                    FROM DETALLE_RECARGO
                   WHERE IdPoliza = nIdPoliza
                     AND IDetPol  = X.IDetPol
                     AND Estado   = 'ACT';
               EXCEPTION
                  WHEN OTHERS THEN
                     nMtoRecD_Local  := 0;
                     nMtoRecD_Moneda := 0;
               END;
               BEGIN
                  SELECT  NVL(SUM(Monto_Local),0),NVL(SUM(Monto_Moneda),0)
                    INTO nMtoDescD_Local,nMtoDescD_Moneda
                    FROM DETALLE_DESCUENTO
                   WHERE IdPoliza  = nIdPoliza
                     AND IDetPol   = X.IDetPol
                     AND Estado    = 'ACT';
               EXCEPTION
                  WHEN OTHERS THEN
                     nMtoDescD_Local  := 0;
                     nMtoDescD_Moneda := 0;
              END;
              IF NVL(nPorcInicial,0) <> 0 THEN
                 nMtoPago       :=( (NVL(X.PrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0))  * nPorcInicial / 100) ;
                 nMtoPagoMoneda :=( (NVL(X.PrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) * nPorcInicial / 100);
              ELSE
                 nMtoPago       :=( (NVL(X.PrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) / nNumPagos );
                 nMtoPagoMoneda :=( (NVL(X.PrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) /nNumPagos );
              END IF;
              nPrimaRest := (NVL(X.PrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local+ NVL(nRec_Local,0) - NVL(nDesc_Local,0)) - NVL(nMtoPago,0)  ;
              nMtoComisi := (nMtoPago * X.PorcComis / 100);
              nTotPrimas := NVL(nTotPrimas,0) + NVL(nMtoPago,0);
              nPrimaRestMoneda := (NVL(X.PrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0))  - NVL(nMtoPagoMoneda,0);
              nMtoComisiMoneda := nMtoPagoMoneda * X.PorcComis / 100 ;
              nTotPrimasMoneda := NVL(nTotPrimasMoneda,0)  + NVL(nMtoPagoMoneda,0);
              FOR NP IN 1..nNumPagos LOOP
                 IF NP > 1 THEN
                    nMtoPago         := NVL(nPrimaRest,0) / (nNumPagos - 1) ;
                    nTotPrimas       := NVL(nTotPrimas,0) + NVL(nMtoPago,0) ;
                    nMtoComisi       := nMtoPago * X.PorcComis / 100;
                    IF nFrecPagos NOT IN (15,7) THEN
                       dFecPago         := ADD_MONTHS(dFecPago,nFrecPagos);
                    ELSE
                       dFecPago         := dFecPago + nFrecPagos;
                    END IF;
                    nMtoPagoMoneda   := NVL(nPrimaRestMoneda,0) / (nNumPagos - 1);
                    nTotPrimasMoneda := NVL(nTotPrimasMoneda,0) + NVL(nMtoPagoMoneda,0) ;
                    nMtoComisiMoneda := nMtoPagoMoneda * X.PorcComis / 100;
                 END IF;
                 -- Inserta Factura solamente con Prima
                --
               --SELECT NVL(MAX(IdFactura),0)+1
               --    INTO nIdFactura
               --    FROM FACTURAS;
               --
               /** Cambio a secuencia XDS**/
               --
               --nIdFactura :=OC_FACTURAR.F_GET_FACT(p_msg_regreso);
               --
                 SELECT SYSDATE
                   INTO dFecHoy
                   FROM DUAL;
                 -- LARPLA
                 nIdFactura := OC_FACTURAS.INSERTAR(nIdPoliza,        X.IDetPol,      nCodCliente, dFecPago, 
                                                    nMtoPago,         nMtoPagoMoneda, nIdEndoso,   nMtoComisi, 
                                                    nMtoComisiMoneda, NP,             nTasaCambio, nCod_Agente, 
                                                    nCodTipoDoc,      pCodCia,        cCodMoneda,  NULL, 
                                                    nTransa,          X.IndFactElectronica);

                  OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, 'PRIBAS', 'S', nMtoPago , nMtoPagoMoneda );
                  OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, 'PRIBAS', 'S', nMtoPago , nMtoPagoMoneda );
               -- Genera comisiones por agente por certificado
                nMtoT := nMtoT + nMtoPago;

                 PROC_COMISIONAG (nIdPoliza, x.IdetPol, nCodCia, nCodEmpresa, x.IdTipoSeg, cCodMoneda,
                                  nIdFactura, nMtoPago, nMtoPagoMoneda, nTasaCambio);
                 --PROC_COMISIONAG (nIdPoliza,x.IdetPol,nCodCia,nCodEmpresa,x.IdTipoSeg,cCodMoneda,nIdFactura,nMtot,nMtoTM,nTasaCambio);
               -- Distribuye la comision por agente.
                 FOR Y IN CPTO_PLAN_Q LOOP
                    BEGIN
                       SELECT 'S'
                         INTO cGraba
                         FROM RAMOS_CONCEPTOS_PLAN
                        WHERE CodPlanPago = cCodPlanPago
                          AND CodCpto     = Y.CodCpto
                          AND CodCia      = nCodCia
                          AND CodEmpresa  = nCodEmpresa
                          AND IdTipoSeg   = X.IdTipoSeg;
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          cGraba := 'N';
                       WHEN TOO_MANY_ROWS THEN
                          cGraba := 'S';
                    END;
                    IF cGraba = 'S' THEN
                       IF Y.IndRangosTipseg = 'S' THEN
                          IF cIndCalcDerechoEmis = 'S' THEN
                             OC_CATALOGO_CONCEPTOS_RANGOS.VALOR_CONCEPTO(nCodCia, nCodEmpresa, Y.CodCpto, X.IdTipoSeg,
                                                                         nIdPoliza, X.IdetPol, nIdEndoso, nMtoCpto, nPorcCpto);
                             IF OC_DETALLE_FACTURAS.EXISTE_CONCEPTO(nCodCia, nIdPoliza, nTransa, Y.CodCpto) = 'N' THEN
                                IF NVL(nMtoCpto,0) = 0 AND NVL(nPorcCpto,0) = 0 THEN
                                   nMtoCpto  := Y.MtoCpto;
                                   nPorcCpto := Y.PorcCpto;
                                END IF;
                             ELSE
                                nMtoCpto  := 0;
                                nPorcCpto := 0;
                             END IF;
                          ELSE
                             nMtoCpto  := 0;
                             nPorcCpto := 0;
                          END IF;
                       ELSE
                          nMtoCpto  := Y.MtoCpto;
                          nPorcCpto := Y.PorcCpto;
                       END IF;
                       IF Y.Aplica = 'P' AND NP = 1 THEN
                          IF NVL(Y.MtoCpto,0) <> 0 THEN
                             nMtoDet       := NVL(Y.MtoCpto,0);
                             nMtoDetMoneda := NVL(Y.MtoCpto,0) * nTasaCambio;
                          ELSIF NP = 1 THEN
                             nMtoDet       := NVL(nMtoPago,0) * Y.PorcCpto / 100 ;
                             nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * Y.PorcCpto / 100 ;
                             /*nMtoDet       := NVL(X.PrimaLocal,0)  + nMtoRecD_Local - nMtoDescD_Local + NVL(nRec_Local,0) - NVL(nDesc_Local,0) * Y.PorcCpto / 100;
                             nMtoDetMoneda := NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0) * Y.PorcCpto / 100;*/
                          ELSE
                             nMtoDet       := 0;
                             nMtoDetMoneda := 0;
                          END IF;
                          IF NVL(nMtoDet,0) != 0 THEN
                             OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet , nMtoDetMoneda);
                             OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                             nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                             nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                          END IF;
                          IF Y.CodCpto = 'PRIBAS' THEN
                             PROC_COMISIONAG (nIdPoliza,x.IdetPol,nCodCia,nCodEmpresa,x.IdTipoSeg,cCodMoneda
                                               ,nIdFactura,nMtoPago,nMtoPagoMoneda,nTasaCambio);
                             --PROC_COMISIONAG (nIdPoliza,x.IdetPol,nCodCia,nCodEmpresa,x.IdTipoSeg,cCodMoneda
                             --                  ,nIdFactura,nMtot,nMtoTM,nTasaCambio);

                          END IF;
                       ELSIF Y.Aplica = 'T' THEN
                          IF NVL(Y.MtoCpto,0) <> 0 THEN
                             nMtoDet       := NVL(Y.MtoCpto,0);
                             nMtoDetMoneda := NVL(Y.MtoCpto,0) * nTasaCambio ;
                          ELSE
                             nMtoDet       := NVL(nMtoPago,0) * Y.PorcCpto / 100 ;
                             nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * Y.PorcCpto / 100 ;
                          END IF;
                          IF NVL(nMtoDet,0) != 0 THEN
                             OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                             OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                             nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                             nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                          END IF;
                          IF Y.CodCpto = 'PRIBAS' THEN
                             --PROC_COMISIONAG (nIdPoliza,x.IdetPol,nCodCia,nCodEmpresa,x.IdTipoSeg,cCodMoneda
                             --                  ,nIdFactura,nMtot,nMtoTM,nTasaCambio);
                             PROC_COMISIONAG (nIdPoliza,x.IdetPol,nCodCia,nCodEmpresa,x.IdTipoSeg,cCodMoneda,
                                              nIdFactura,nMtoPago,nMtoPagoMoneda,nTasaCambio);

                          END IF;
                       END IF;
                       nMtoT := nMtoT + nMtoDet;
                    END IF;
                 END LOOP;
                 OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
                 OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'FAC', 'FACTURAS',
                                              nIdPoliza, nIdetPol, NULL, NULL, nMtoT);
                 OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'COM', 'COMISIONES',
                                              nIdPoliza, nIdetPol, NULL, NULL, nMtoComisiMoneda);
                 -- Aplica el IVA
                 BEGIN
                    SELECT PorcCpto, Aplica, MtoCpto
                      INTO nPorcCpto, cAplica, nMtoCpto
                      FROM CONCEPTOS_PLAN_DE_PAGOS
                     WHERE CodCia      = nCodCia
                       AND CodEmpresa  = nCodEmpresa
                       AND CodPlanPago = cCodPlanPago
                       AND CodCpto     = 'IMPIVA';
                 EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                       nPorcCpto := 0;
                 END;
                 IF NVL(nPorcCpto,0) <> 0 OR NVL(nMtoCpto,0) <> 0 THEN
                    SELECT SUM(Monto_Det_Local), SUM(Monto_Det_Moneda)
                      INTO nMtoTotal, nMtoTotalMoneda
                      FROM DETALLE_FACTURAS
                     WHERE IdFactura = nIdFactura
                      AND CodCpto != 'IMPBOM';
                      IF NVL(nMtoCpto,0) <> 0 THEN
                         nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                      ELSE
                       nMtoDet       := NVL(nMtoTotal,0) * nPorcCpto / 100 ;
                       nMtoDetMoneda := NVL(nMtoTotalMoneda,0) * nPorcCpto / 100   ;
                    END IF;
                    BEGIN
                       SELECT 'S'
                         INTO cGraba
                         FROM RAMOS_CONCEPTOS_PLAN
                        WHERE CodPlanPago = cCodPlanPago
                          AND CodCpto     = 'IMPIVA'
                          AND CodCia      = nCodCia
                          AND CodEmpresa  = nCodEmpresa
                          AND IdTipoSeg   = X.IdTipoSeg;
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          cGraba := 'N';
                       WHEN TOO_MANY_ROWS THEN
                          cGraba := 'S';
                    END;
                    IF cGraba = 'S' THEN
                       IF cAplica = 'P' AND NP = 1 THEN
                         OC_DETALLE_FACTURAS.INSERTAR(nIdFactura,  'IMPIVA', 'N', nMtoDet, nMtoDetMoneda);
                       ELSIF cAplica = 'T' THEN
                          OC_DETALLE_FACTURAS.INSERTAR(nIdFactura,  'IMPIVA', 'N', nMtoDet, nMtoDetMoneda);
                       END IF;
                    END IF;
                 END IF;
                 -- Actualiza Valor de la Factura con Impuestos
                 SELECT SUM(Monto_Det_Local), SUM(Monto_Det_Moneda)
                   INTO nMtoTotal, nMtoTotalMoneda
                   FROM DETALLE_FACTURAS
                  WHERE IdFactura = nIdFactura;

                 UPDATE FACTURAS
                    SET Monto_Fact_Local  = nMtoTotal,
                        Monto_Fact_Moneda = nMtoTotalMoneda,
                        Saldo_Local   = nMtoTotal,
                        Saldo_Moneda  = nMtoTotalMoneda
                  WHERE IdFactura = nIdFactura;
                  OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
              END LOOP;
              IF (NVL(X.PrimaLocal,0) + nMtoRecD_Local - nMtoDescD_Local + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) <> NVL(nTotPrimas,0) THEN
                 nDifer       := (NVL(X.PrimaLocal,0)+ nMtoRecD_Local - nMtoDescD_Local + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) - NVL(nTotPrimas,0);
                 nDiferMoneda := (NVL(X.PrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) - NVL(nTotPrimasMoneda,0);
                 UPDATE DETALLE_FACTURAS
                    SET Monto_Det_Local  = Monto_Det_Local + NVL(nDifer,0),
                        Monto_Det_Moneda = Monto_Det_Moneda + NVL(nDiferMoneda,0),
                        Saldo_Det_Local  = Monto_Det_Local + NVL(nDifer,0),
                        Saldo_Det_Moneda = Monto_Det_Moneda + NVL(nDiferMoneda,0)
                  WHERE IdFactura = nIdFactura
                    AND CodCpto   = 'PRIBAS';
                 UPDATE FACTURAS
                    SET Monto_Fact_Local  = Monto_Fact_Local + NVL(nDifer,0),
                        Monto_Fact_Moneda = Monto_Fact_Moneda + NVL(nDiferMoneda,0),
                        Saldo_local       = Monto_Fact_Local + NVL(nDifer,0),
                        Saldo_Moneda      = Monto_Fact_Moneda + NVL(nDiferMoneda,0)
                  WHERE IdFactura = nIdFactura;
              END IF;
   ELSE
       IF cRespDet = 'S' AND  FUNC_VALIDA_RESP_DET (nIdPoliza,pCodCia , x.idetpol ) = 'S' THEN
          FOR J IN RESP_PAGO LOOP
             cCodPlanPago := X.CodPlanPago;
             IF nMtoRec_Local != 0 OR nMtoRec_Moneda != 0 OR nMtoDesc_Local != 0 OR nMtoDesc_Moneda != 0 THEN
                nFactor      := ((X.PrimaLocal   *  NVL(J.PORCRESPAGO,0)/100) / NVL(nPrimaTotalL,0)) * 100;
                nRec_Local   := (nMtoRec_Local   * nFactor) / 100;
                nRec_Moneda  := (nMtoRec_Moneda  * nFactor) / 100;
                nDesc_Local  := (nMtoDesc_Local  * nFactor) / 100;
                nDesc_Moneda := (nMtoDesc_Moneda * nFactor) / 100;
             END IF;
             BEGIN
                SELECT Cod_Agente
                  INTO nCod_Agente
                  FROM AGENTES_DETALLES_POLIZAS
                 WHERE IdPoliza      = nIdPoliza
                   AND IdetPol       = X.IdetPol
                   AND IdTipoSeg     = X.IdTipoSeg
                   AND Ind_Principal = 'S';
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR (-20100,'No Existe un Agente Definido para el Tipo de Seguro '||X.IdTipoSeg);
                WHEN TOO_MANY_ROWS THEN
                    RAISE_APPLICATION_ERROR (-20100,'Existe Mas de un Agente Definido como Principal');
                WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR (-20100,'Existe un error de otros');
              END;
              nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
              -- Características del Plan de Pago
              BEGIN
                 SELECT NumPagos, FrecPagos, PorcInicial
                   INTO nNumPagos, nFrecPagos, nPorcInicial
                   FROM PLAN_DE_PAGOS
                  WHERE CodCia      = nCodCia
                    AND CodEmpresa  = nCodEmpresa
                    AND CodPlanPago = X.CodPlanPago;
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR (-20100,'No Existe Plan de Pagos '||X.CodPlanPago);

              END;

              -- Determina Meses de Vigencia para Plan de Pagos
              IF nNumPagos <= 12 THEN
                 nCantPagosReal  := FLOOR(MONTHS_BETWEEN(X.FecFinVig, X.FecIniVig) / nFrecPagos);
              ELSE
                 nCantPagosReal  := FLOOR((X.FecFinVig - X.FecIniVig) / nFrecPagos);
              END IF;

              IF nCantPagosReal <= 0 THEN
                 nCantPagosReal := 1;
              END IF;
              IF nCantPagosReal < nNumPagos THEN
                 nNumPagos := nCantPagosReal;
              END IF;

              -- Fecha del Primer Pago Siempre a Inicio de Vigencia
              dFecPago := X.FecIniVig;
              /*IF X.FecIniVig > X.FecEmision THEN
                 dFecPago := X.FecIniVig;
              ELSE
                 dFecPago := X.FecEmision;
              END IF;*/

           -- Monto del Primer Pago
              nTotPrimas       := 0;
              nTotPrimasMoneda := 0;
              BEGIN
                 SELECT  NVL(SUM(Monto_Local),0),NVL(SUM(Monto_Moneda),0)
                   INTO nMtoRecD_Local,nMtoRecD_Moneda
                   FROM DETALLE_RECARGO
                  WHERE IdPoliza = nIdPoliza
                    AND IDetPol  = X.IDetPol
                    AND Estado   = 'ACT';
              EXCEPTION
                 WHEN OTHERS THEN
                    nMtoRecD_Local  := 0;
                    nMtoRecD_Moneda := 0;
              END;
              BEGIN
                 SELECT  NVL(SUM(Monto_Local),0),NVL(SUM(Monto_Moneda),0)
                   INTO nMtoDescD_Local,nMtoDescD_Moneda
                   FROM DETALLE_DESCUENTO
                  WHERE IdPoliza  = nIdPoliza
                    AND IDetPol   = X.IDetPol
                    AND Estado    = 'ACT';
              EXCEPTION
                 WHEN OTHERS THEN
                    nMtoDescD_Local  := 0;
                    nMtoDescD_Moneda := 0;
             END;
             IF NVL(J.PORCRESPAGO,0) != 0  THEN
                IF NVL(nPorcInicial,0) <> 0 THEN
                   nMtoPago       :=( (NVL(X.PrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0))  * nPorcInicial / 100)  *  NVL(J.PORCRESPAGO,0)/100;
                   nMtoPagoMoneda :=( (NVL(X.PrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) * nPorcInicial / 100)  *  NVL(J.PORCRESPAGO,0)/100;
                ELSE
                   nMtoPago       :=( (NVL(X.PrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) / nNumPagos ) *  NVL(J.PORCRESPAGO,0)/100;
                   nMtoPagoMoneda :=( (NVL(X.PrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) /nNumPagos )  *  NVL(J.PORCRESPAGO,0)/100;
                END IF;
                nPrimaRest := ((NVL(X.PrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local+ NVL(nRec_Local,0) - NVL(nDesc_Local,0)) *  NVL(J.PORCRESPAGO,0)/100) - NVL(nMtoPago,0)  ;
                nMtoComisi := (nMtoPago * X.PorcComis / 100);
                nTotPrimas := (NVL(nTotPrimas,0) *  NVL(J.PORCRESPAGO,0)/100) + NVL(nMtoPago,0);
                nPrimaRestMoneda :=( (NVL(X.PrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0))   *  NVL(J.PORCRESPAGO,0)/100) - NVL(nMtoPagoMoneda,0);
                nMtoComisiMoneda := nMtoPagoMoneda * X.PorcComis / 100;
                nTotPrimasMoneda :=( NVL(nTotPrimasMoneda,0) *  NVL(J.PORCRESPAGO,0)/100) + NVL(nMtoPagoMoneda,0);
              END IF;
              FOR NP IN 1..nNumPagos LOOP
                 IF NP > 1 THEN
                    nMtoPago         := NVL(nPrimaRest,0) / (nNumPagos - 1) ;
                    nTotPrimas       := NVL(nTotPrimas,0) + NVL(nMtoPago,0) ;
                    nMtoComisi       := nMtoPago * X.PorcComis / 100;
                    IF nFrecPagos NOT IN (15,7) THEN
                       dFecPago         := ADD_MONTHS(dFecPago,nFrecPagos);
                    ELSE
                       dFecPago         := dFecPago + nFrecPagos;
                    END IF;
                    nMtoPagoMoneda   := NVL(nPrimaRestMoneda,0) / (nNumPagos - 1);
                    nTotPrimasMoneda := NVL(nTotPrimasMoneda,0) + NVL(nMtoPagoMoneda,0) ;
                    nMtoComisiMoneda := nMtoPagoMoneda * X.PorcComis / 100;
                 END IF;
                 -- Inserta Factura solamente con Prima

              --
               --SELECT NVL(MAX(IdFactura),0)+1
               --    INTO nIdFactura
               --    FROM FACTURAS;
               --
               /** Cambio a secuencia XDS**/
               --
               --nIdFactura :=OC_FACTURAR.F_GET_FACT(p_msg_regreso);
               --
                 SELECT SYSDATE
                   INTO dFecHoy
                   FROM DUAL;
               -- LARPLA
               nIdFactura := OC_FACTURAS.INSERTAR(nIdPoliza,        X.IDetPol,      nCodCliente, dFecPago, 
                                                  nMtoPago,         nMtoPagoMoneda, nIdEndoso,   nMtoComisi, 
                                                  nMtoComisiMoneda, NP,             nTasaCambio, nCod_Agente, 
                                                  nCodTipoDoc,      pCodCia,        cCodMoneda,  NULL, 
                                                  nTransa,          X.IndFactElectronica);

                -- Inserta Detalle de Factura
                  OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, 'PRIBAS', 'S', nMtoPago , nMtoPagoMoneda );
                  OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, 'PRIBAS', 'S', nMtoPago , nMtoPagoMoneda );
                -- Genera comisiones por agente por certificado
                  PROC_COMISIONAG (nIdPoliza,x.IdetPol,nCodCia,nCodEmpresa,x.IdTipoSeg,cCodMoneda,nIdFactura,nMtoPago,nMtoPagoMoneda,nTasaCambio);
                  --PROC_COMISIONAG (nIdPoliza,x.IdetPol,nCodCia,nCodEmpresa,x.IdTipoSeg,cCodMoneda,nIdFactura,nMtot,nMtoTM,nTasaCambio);
                -- Distribuye la comision por agente.
                 FOR Y IN CPTO_PLAN_Q LOOP
                    BEGIN
                       SELECT 'S'
                         INTO cGraba
                         FROM RAMOS_CONCEPTOS_PLAN
                        WHERE CodPlanPago = cCodPlanPago
                          AND CodCpto     = Y.CodCpto
                          AND CodCia      = nCodCia
                          AND CodEmpresa  = nCodEmpresa
                          AND IdTipoSeg   = X.IdTipoSeg;
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          cGraba := 'N';
                       WHEN TOO_MANY_ROWS THEN
                          cGraba := 'S';
                    END;
                    IF cGraba = 'S' THEN
                       IF Y.IndRangosTipseg = 'S' THEN
                          IF cIndCalcDerechoEmis = 'S' THEN
                             OC_CATALOGO_CONCEPTOS_RANGOS.VALOR_CONCEPTO(nCodCia, nCodEmpresa, Y.CodCpto, X.IdTipoSeg,
                                                                         nIdPoliza, X.IdetPol, nIdEndoso, nMtoCpto, nPorcCpto);
                             IF OC_DETALLE_FACTURAS.EXISTE_CONCEPTO(nCodCia, nIdPoliza, nTransa, Y.CodCpto) = 'N' THEN
                                IF NVL(nMtoCpto,0) = 0 AND NVL(nPorcCpto,0) = 0 THEN
                                   nMtoCpto  := Y.MtoCpto;
                                   nPorcCpto := Y.PorcCpto;
                                END IF;
                             ELSE
                                nMtoCpto  := 0;
                                nPorcCpto := 0;
                             END IF;
                          ELSE
                             nMtoCpto  := 0;
                             nPorcCpto := 0;
                          END IF;
                       ELSE
                          nMtoCpto  := Y.MtoCpto;
                          nPorcCpto := Y.PorcCpto;
                       END IF;
                       IF Y.Aplica = 'P' AND NP = 1 THEN
                          IF NVL(Y.MtoCpto,0) <> 0 THEN
                             nMtoDet       := NVL(Y.MtoCpto,0);
                             nMtoDetMoneda := NVL(Y.MtoCpto,0) * nTasaCambio;
                          ELSIF NP = 1 THEN
                             nMtoDet       := NVL(nMtoPago,0) * Y.PorcCpto / 100 ;
                             nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * Y.PorcCpto / 100 ;
                             /*nMtoDet       := NVL(X.PrimaLocal,0)  + nMtoRecD_Local - nMtoDescD_Local + NVL(nRec_Local,0) - NVL(nDesc_Local,0) * Y.PorcCpto / 100;
                             nMtoDetMoneda := NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0) * Y.PorcCpto / 100;*/
                          ELSE
                             nMtoDet       := 0;
                             nMtoDetMoneda := 0;
                          END IF;
                          IF NVL(nMtoDet,0) != 0 THEN
                             OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, 'PRIBAS', 'S', nMtoPago , nMtoPagoMoneda);
                             nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                             nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                          END IF;
                        ELSIF Y.Aplica = 'T' THEN
                          IF NVL(Y.MtoCpto,0) <> 0 THEN
                             nMtoDet       := NVL(Y.MtoCpto,0);
                             nMtoDetMoneda := NVL(Y.MtoCpto,0) * nTasaCambio ;
                          ELSE
                             nMtoDet       := NVL(nMtoPago,0) * Y.PorcCpto / 100 ;
                             nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * Y.PorcCpto / 100 ;
                          END IF;
                          IF NVL(nMtoDet,0) != 0 THEN
                             OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoPago , nMtoPagoMoneda );
                             nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                             nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                          END IF;
                          IF Y.CodCpto = 'PRIBAS' THEN
                             --PROC_COMISIONAG (nIdPoliza,x.IdetPol,nCodCia,nCodEmpresa,x.IdTipoSeg,cCodMoneda
                             --                  ,nIdFactura,nMtot,nMtoTM,nTasaCambio);

                             PROC_COMISIONAG (nIdPoliza,x.IdetPol,nCodCia,nCodEmpresa,x.IdTipoSeg,cCodMoneda,
                                              nIdFactura,nMtoPago,nMtoPagoMoneda,nTasaCambio);
                          END IF;
                       END IF;
                    END IF;
                 END LOOP;
                 -- Aplica el IVA
                 BEGIN
                    SELECT PorcCpto, Aplica, MtoCpto
                      INTO nPorcCpto, cAplica, nMtoCpto
                      FROM CONCEPTOS_PLAN_DE_PAGOS
                     WHERE CodCia      = nCodCia
                       AND CodEmpresa  = nCodEmpresa
                       AND CodPlanPago = cCodPlanPago
                       AND CodCpto     = 'IMPIVA';
                 EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                       nPorcCpto := 0;
                 END;
                 IF NVL(nPorcCpto,0) <> 0 OR NVL(nMtoCpto,0) <> 0 THEN
                    SELECT SUM(Monto_Det_Local), SUM(Monto_Det_Moneda)
                      INTO nMtoTotal, nMtoTotalMoneda
                      FROM DETALLE_FACTURAS
                     WHERE IdFactura = nIdFactura
                      AND CodCpto != 'IMPBOM';
                      IF NVL(nMtoCpto,0) <> 0 THEN
                         nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                      ELSE
                       nMtoDet       := NVL(nMtoTotal,0) * nPorcCpto / 100 ;
                       nMtoDetMoneda := NVL(nMtoTotalMoneda,0) * nPorcCpto / 100   ;
                    END IF;
                    BEGIN
                       SELECT 'S'
                         INTO cGraba
                         FROM RAMOS_CONCEPTOS_PLAN
                        WHERE CodPlanPago = cCodPlanPago
                          AND CodCpto     = 'IMPIVA'
                          AND CodCia      = nCodCia
                          AND CodEmpresa  = nCodEmpresa
                          AND IdTipoSeg   = X.IdTipoSeg;
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                          cGraba := 'N';
                       WHEN TOO_MANY_ROWS THEN
                          cGraba := 'S';
                    END;
                    IF cGraba = 'S' THEN
                       IF cAplica = 'P' AND NP = 1 THEN
                          OC_DETALLE_FACTURAS.INSERTAR(nIdFactura,  'IMPIVA', 'N', nMtoDet, nMtoDetMoneda);
                       ELSIF cAplica = 'T' THEN
                          OC_DETALLE_FACTURAS.INSERTAR(nIdFactura,  'IMPIVA', 'N', nMtoDet, nMtoDetMoneda);
                       END IF;
                    END IF;
                 END IF;
                 -- Actualiza Valor de la Factura con Impuestos
                 SELECT SUM(Monto_Det_Local), SUM(Monto_Det_Moneda)
                   INTO nMtoTotal, nMtoTotalMoneda
                   FROM DETALLE_FACTURAS
                  WHERE IdFactura = nIdFactura;

                 UPDATE FACTURAS
                    SET Monto_Fact_Local  = nMtoTotal,
                        Monto_Fact_Moneda = nMtoTotalMoneda,
                        Saldo_Local   = nMtoTotal,
                        Saldo_Moneda  = nMtoTotalMoneda
                  WHERE IdFactura = nIdFactura;

              END LOOP;
              IF  NVL(J.PORCRESPAGO,0) != 0 THEN
                   IF (NVL(X.PrimaLocal,0)* NVL(J.PORCRESPAGO,0) + nMtoRecD_Local - nMtoDescD_Local + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) <> NVL(nTotPrimas,0) THEN
                       nDifer       :=( ((NVL(X.PrimaLocal,0)* NVL(J.PORCRESPAGO,0))/100+ nMtoRecD_Local - nMtoDescD_Local + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) )- NVL(nTotPrimas,0) ;
                       nDiferMoneda := ( ((NVL(X.PrimaMoneda,0)* NVL(J.PORCRESPAGO,0))/100+ nMtoRecD_Moneda - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0))  ) - NVL(nTotPrimasMoneda,0) ;
                       UPDATE DETALLE_FACTURAS
                          SET Monto_Det_Local  = Monto_Det_Local + NVL(nDifer,0),
                              Monto_Det_Moneda = Monto_Det_Moneda + NVL(nDiferMoneda,0),
                              Saldo_Det_Local  = Monto_Det_Local + NVL(nDifer,0),
                              Saldo_Det_Moneda = Monto_Det_Moneda + NVL(nDiferMoneda,0)
                        WHERE IdFactura = nIdFactura
                          AND CodCpto   = 'PRIBAS';
                       UPDATE FACTURAS
                           SET Monto_Fact_Local  = Monto_Fact_Local + NVL(nDifer,0),
                               Monto_Fact_Moneda = Monto_Fact_Moneda + NVL(nDiferMoneda,0),
                               Saldo_local       = Monto_Fact_Local + NVL(nDifer,0),
                               Saldo_Moneda      = Monto_Fact_Moneda + NVL(nDiferMoneda,0)
                        WHERE IdFactura = nIdFactura;
                 END IF;
             END IF;
          END LOOP;
         ELSE
         RAISE_APPLICATION_ERROR (-20100,'Error');
       END IF;
     END IF;
     OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
 END LOOP;
   --
 BEGIN
    SELECT Contabilidad_Automatica
      INTO cContabilidad_Automatica
      FROM EMPRESAS
     WHERE CodCia = nCodCia;
 EXCEPTION
    WHEN NO_DATA_FOUND THEN
        cContabilidad_Automatica := 'N';
 END;
 IF cContabilidad_Automatica = 'S' THEN
    PROC_MOVCONTA(nCodCia, nIdPoliza, cCodMoneda, 'EMI');
 END IF;

END PROC_FACT_FIANZA;

FUNCTION FUNC_VALIDA_RESP_POL (nIdPoliza NUMBER, nCodCia NUMBER) RETURN VARCHAR2  IS
Dummy         NUMBER(5);
nEmite        VARCHAR2(1);
nPorcResp     RESPONSABLE_PAGO_POL.PorcResPago%TYPE;
cRespPol      VARCHAR2(1):='N';
BEGIN
   BEGIN
      SELECT NVL(SUM(PorcResPago),0)
        INTO nPorcResp
        FROM RESPONSABLE_PAGO_POL
       WHERE StsResPago = 'ACT'
         AND CodCia     = nCodCia
         AND IdPoliza   = nIdPoliza;
   END;

   IF nPorcResp != 0 AND nPorcResp <> 100 THEN
      RAISE_APPLICATION_ERROR (-20100,'Porcentajes de Responsables de Pago NO Suman 100%. Debe Ajustas los Porcentajes.');
      nEmite := 'N';
   ELSE
      nEmite := 'S';
   END IF;
   RETURN(nEmite);
END FUNC_VALIDA_RESP_POL;

PROCEDURE PROC_INSERT_RESP_D (nIdPoliza NUMBER, nCodCia NUMBER) IS
nPorcResPago             RESPONSABLE_PAGO_DET.PorcResPago%TYPE;
cTipo_Doc_Identificacion RESPONSABLE_PAGO_POL.Tipo_Doc_Identificacion%TYPE;
nNum_Doc_Identificacion  RESPONSABLE_PAGO_DET.Num_Doc_Identificacion%TYPE;
nCodResPago              RESPONSABLE_PAGO_DET.CodResPago%TYPE;
nCodEmpresa              RESPONSABLE_PAGO_DET.CodEmpresa%TYPE;
cRespPol                 VARCHAR2(1):='N';
cRespDet                 VARCHAR2(1):='N';
Dummy                    NUMBER(5);
nEmite                   VARCHAR2(1);

CURSOR RESP_DET IS
   SELECT IdetPol
     FROM DETALLE_POLIZA
    WHERE IdPoliza = nIdPoliza
      AND CodCia   = nCodCia;
CURSOR RESP_POL IS
   SELECT PorcResPago, Tipo_Doc_Identificacion, Num_Doc_Identificacion, CodResPago, CodEmpresa
     FROM RESPONSABLE_PAGO_POL
    WHERE StsResPago = 'ACT'
      AND CodCia     = nCodCia
      AND IdPoliza   = nIdPoliza;
BEGIN
   BEGIN
      SELECT 'S'
        INTO cRespPol
        FROM RESPONSABLE_PAGO_POL
       WHERE StsResPago = 'ACT'
         AND CodCia     = nCodCia
         AND IdPoliza   = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cRespPol := 'N';
      WHEN TOO_MANY_ROWS THEN
         cRespPol := 'S';
   END;
   FOR I IN RESP_DET  LOOP
      BEGIN
         SELECT 'S'
           INTO cRespDet
           FROM RESPONSABLE_PAGO_DET
          WHERE StsResPago = 'ACT'
            AND CodCia     = nCodCia
            AND IdPoliza   = nIdPoliza
            AND Idetpol    = I.IdetPol;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cRespDet := 'N';
         WHEN TOO_MANY_ROWS THEN
            cRespDet := 'S';
      END;
      IF cRespPol = 'S' AND cRespDet = 'N' THEN
         FOR J IN  RESP_POL LOOP
            BEGIN
               INSERT INTO RESPONSABLE_PAGO_DET
                     (IdPoliza, Tipo_Doc_Identificacion, Num_Doc_Identificacion, IDetPol, CodCia,
                      CodResPago, StsResPago, PorcResPago, CodEmpresa, FecAlta)
               VALUES(nIdPoliza, J.Tipo_Doc_Identificacion, J.Num_Doc_Identificacion, I.IDetPol, nCodCia,
                      J.CodResPago, 'ACT', J.PorcResPago, J.CodEmpresa, SYSDATE);
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         END LOOP;
      END IF;
   END LOOP;
END PROC_INSERT_RESP_D;

FUNCTION FUNC_VALIDA_RESP_DET (nIdPoliza NUMBER, nCodCia NUMBER,nIdetPol NUMBER) RETURN VARCHAR2 IS
Dummy         NUMBER(5);
nEmite        VARCHAR2(1);
nPorcResp   RESPONSABLE_PAGO_DET.PorcResPago%TYPE;
cRespPol VARCHAR2(1):='N';
BEGIN
   BEGIN
      SELECT NVL(SUM(PorcResPago),0)
        INTO nPorcResp
        FROM RESPONSABLE_PAGO_DET
       WHERE StsResPago = 'ACT'
         AND CodCia     = nCodCia
         AND IdPoliza   = nIdPoliza
         AND IDetPol    = nIDetPol;
      IF nPorcResp != 0 AND nPorcResp <> 100 THEN
         RAISE_APPLICATION_ERROR (-20100,'Porcentajes de Responsables de Pago NO Suman 100%. Debe Ajustas los Porcentajes.');
         nEmite := 'N';
      ELSE
        nEmite := 'S';
      END IF;
  END;
  RETURN(nEmite);
END FUNC_VALIDA_RESP_DET;

PROCEDURE PROC_COMISIONAG(nIdPoliza NUMBER, nIdetPol NUMBER, nCodCia NUMBER,
                          nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cCodMoneda VARCHAR2,
                          nIdFactura NUMBER, nMontoDetLocal NUMBER, nMontoDetMoneda NUMBER,
                          nTasaCambio NUMBER) IS
nMontoComiLocal   COMISIONES.Comision_Local%TYPE;
nMontoComiMoneda  COMISIONES.Comision_Moneda%TYPE;
nPorcComisiones   DETALLE_POLIZA.PorcComis%TYPE;
nMontoComisiones  DETALLE_POLIZA.MontoComis%TYPE;
nIdTransac        TRANSACCION.IdTransaccion%TYPE;
nMonto            COMISIONES.Comision_Local%TYPE := 0;
nCod_Agente       COMISIONES.Cod_Agente%TYPE;

CURSOR C_AGENTES IS
   SELECT Cod_Agente, Porc_Comision
     FROM AGENTES_DETALLES_POLIZAS
    WHERE IdPoliza  = nIdPoliza
      AND IDetPol   = nIdetPol
      AND IdTipoSeg = cIdTipoSeg;
CURSOR C_AGENTES_D IS
  SELECT Cod_Agente_Distr Cod_Agente, Porc_Com_Proporcional Porc_Comision,
         Porc_Com_Distribuida, Origen
    FROM AGENTES_DISTRIBUCION_COMISION
   WHERE IdPoliza   = nIdPoliza
     AND IDetPol    = nIdetPol
     AND Cod_Agente = nCod_Agente;
BEGIN
   FOR I IN C_AGENTES LOOP
      nCod_Agente := I.Cod_Agente;
      FOR R_Agentes IN C_AGENTES_D LOOP
         SELECT NVL(PorcComis,0), NVL(MontoComis,0)
           INTO nPorcComisiones, nMontoComisiones
           FROM DETALLE_POLIZA
          WHERE IdPoliza  = nIdPoliza
            AND IDetPol   = nIdetPol
            AND CodCia    = nCodCia
            AND IdTipoSeg = cIdTipoSeg
          UNION ALL
         SELECT NVL(PorcComis,0), 0 MontoComis
           FROM FZ_DETALLE_FIANZAS
          WHERE IdPoliza    = nIdPoliza
            AND Correlativo = nIdetPol
            AND CodCia      = nCodCia
            AND IDTIPOSEG   = CIDTIPOSEG;

         IF NVL(nMontoComisiones,0) = 0 THEN
            nMontoComiLocal  := nMontoDetLocal * R_Agentes.Porc_Com_Distribuida/100 * (I.Porc_Comision/100);
            nMontoComiMoneda := nMontoDetLocal  * R_Agentes.Porc_Com_Distribuida/100 * (I.Porc_Comision/100);
            --nMontoComiLocal  := nMontoDetLocal * (nPorcComisiones/100) * (R_Agentes.Porc_Comision/100) * (I.Porc_Comision/100);
            --nMontoComiMoneda :=nMontoDetLocal  * (nPorcComisiones/100) * (R_Agentes.Porc_Comision/100) * (I.Porc_Comision/100);
         ELSE
            nMontoComiLocal  := nMontoComisiones * (R_Agentes.Porc_Comision/100) * (I.Porc_Comision/100);
            nMontoComiMoneda := nMontoComisiones / nTasaCambio * (R_Agentes.Porc_Comision/100) * (I.Porc_Comision/100);
         END IF;

         OC_COMISIONES.INSERTAR_COMISION_FACT(nIdFactura, nIdPoliza, nIdetPol, cCodMoneda, R_Agentes.Cod_Agente,
                                              nCodCia, nCodEmpresa, nMontoComiLocal, nMontoComiMoneda, nTasaCambio,
                                              R_Agentes.Origen, cIdTipoSeg);
         nMonto := nMonto + nMontoComiLocal;
      END LOOP;
   END LOOP;
END PROC_COMISIONAG;

PROCEDURE PROC_MOVCONTA (nCodCia NUMBER, nIdPoliza NUMBER, cCodMoneda VARCHAR2, cProceso VARCHAR2) IS
   --
nIdeOpeContable OPERACION_CONTABLE.IdeOpeContable%TYPE := 10;
nCodPeriodo     PERIODO_CONTABLE.CodPeriodo%TYPE;
dFecInicio      PERIODO_CONTABLE.FecInicio%TYPE;
dFecFinal       PERIODO_CONTABLE.FecFinal%TYPE;
dFecMov         MOVIMIENTO_CONTABLE.FecMov%TYPE;
nNumMov         MOVIMIENTO_CONTABLE.NumMov%TYPE;
cDescMov        MOVIMIENTO_CONTABLE.DescMov%TYPE;
nTasaCambio     MOVIMIENTO_CONTABLE.TasaCambio%TYPE;
nCodCentro      CENTROS_DE_COSTO.CodCentro%TYPE;
nDebeLocal      DETALLE_MOVIMIENTO_CONTABLE.DebeLocal%TYPE;
nHaberLocal     DETALLE_MOVIMIENTO_CONTABLE.HaberLocal%TYPE;
nDebeMoneda     DETALLE_MOVIMIENTO_CONTABLE.DebeMoneda%TYPE;
--
nDummy          NUMBER;
--
CURSOR CUR_CUENTAS IS
   SELECT DOC.IdeOpeContable, C.Cod_Moneda, DOC.IdeCuenta, C.IdPoliza,
          SUM(DECODE(DOC.TipoOpeContable,'D',NVL(C.Comision_Local ,0),0)) DebeLocal ,
          SUM(DECODE(DOC.TipoOpeContable,'H',NVL(C.Comision_Local ,0),0)) HaberLocal,
          SUM(DECODE(DOC.TipoOpeContable,'D',NVL(C.Comision_Moneda,0),0)) DebeMoneda,
          SUM(DECODE(DOC.TipoOpeContable,'H',NVL(C.Comision_Moneda,0),0)) HaberMoneda
     FROM COMISIONES C, DETALLE_POLIZA DP, DETALLE_OPERACION_CONTABLE DOC
    WHERE C.IdPoliza         = nIdPoliza
      AND C.Estado           = 'PRY'
      AND DP.IdPoliza        = C.IdPoliza
      AND DP.IdeTpol         = C.IdetPol
      AND DOC.CodCia         = DP.CodCia
      AND DOC.CodEmpresa     = DP.CodEmpresa
      AND DOC.CodPlanPago    = DP.CodPlanPago
      AND DOC.IdeOpeContable = nIdeOpeContable
   GROUP BY DOC.IdeOpeContable, C.Cod_Moneda, DOC.IdeCuenta, C.IdPoliza;
BEGIN
   BEGIN
      SELECT CodPeriodo , FecInicio , FecFinal
        INTO nCodPeriodo, dFecInicio, dFecFinal
        FROM PERIODO_CONTABLE
       WHERE CodCia     = nCodCia
         AND StsPeriodo = 'PRO';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'No Existe un Periodo en Proceso para la Compa?ia '||nCodCia);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR (-20100,'Existen mas un Periodo en Proceso para la Compa?ia '||nCodCia);
   END;
   --
   SELECT NVL(MAX(NumMov),0)+1
     INTO nNumMov
     FROM MOVIMIENTO_CONTABLE
    WHERE Codcia         = nCodCia
      AND CodPeriodo     = nCodPeriodo
      AND IdeOpeContable = nIdeOpeContable;
   --
   IF TRUNC(SYSDATE) >= dFecInicio AND TRUNC(SYSDATE) <= dFecFinal THEN
      dFecMov := TRUNC(SYSDATE);
   ELSE
      dFecMov := dFecFinal;
   END IF;
   --
   IF cProceso = 'EMI' THEN
      cDescMov := 'COMISIONES PROYECTADAS PARA LA POLIZA '||nIdPoliza;
   ELSIF cProceso = 'REV' THEN
      cDescMov := 'REVERSION DE COMISIONES PROYECTADAS POR REVERSION DE EMISION DE POLIZA '||nIdPoliza;
   ELSIF cProceso = 'ANU' THEN
      cDescMov := 'REVERSION DE COMISIONES PROYECTADAS POR ANULACION DE POLIZA '||nIdPoliza;
   END IF;
   --
   INSERT INTO MOVIMIENTO_CONTABLE
          (CodCia, CodPeriodo, IdeOpeContable, NumMov, FecMov, DescMov, CodMoneda,
           TasaCambio, StsMov, FecstsMov, OrigenMov, FecCaptura, UsrCaptura, Descuadrado)
   VALUES (nCodCia, nCodPeriodo, nIdeOpeContable, nNumMov, dFecMov, cDescMov, cCodMoneda,
           0, 'VAL', SYSDATE, 'A', SYSDATE, USER, 'S');
   --
   nDebeLocal  := 0;
   nHaberLocal := 0;
   --
   FOR X IN CUR_CUENTAS LOOP
       BEGIN
          SELECT CodCentro
            INTO nCodCentro
            FROM CENCOSXCTACON
           WHERE CodCia    = nCodCia
             AND IdeCuenta = X.IdeCuenta;
       EXCEPTION
           WHEN NO_DATA_FOUND THEN
                nCodCentro := NULL;
           WHEN TOO_MANY_ROWS THEN
                RAISE_APPLICATION_ERROR (-20100,'La Cuenta Contable '||X.IdeCuenta||' esta Asignada a mas de un Centro de Costo');

       END;
       --
       nDebeLocal  := NVL(nDebeLocal ,0) + NVL(X.DebeLocal ,0);
       nHaberLocal := NVL(nHaberLocal,0) + NVL(X.HaberLocal,0);
       nDebeMoneda := NVL(nDebeMoneda,0) + NVL(X.DebeMoneda,0);
       --
       IF cProceso = 'EMI' THEN
          INSERT INTO DETALLE_MOVIMIENTO_CONTABLE ( CodCia      , CodPeriodo  , IdeOpeContable , NumMov       , IdeCuenta   , Referencia,
                                                    DebeLocal   , HaberLocal  , DebeMoneda     , HaberMoneda  , CodCentro  )
                                           VALUES ( nCodCia     , nCodPeriodo , nIdeOpeContable, nNumMov      , X.IdeCuenta , X.IdPoliza,
                                                    X.DebeLocal , X.HaberLocal, X.DebeMoneda   , X.HaberMoneda, nCodCentro );
       ELSE
          INSERT INTO DETALLE_MOVIMIENTO_CONTABLE ( CodCia      , CodPeriodo  , IdeOpeContable , NumMov       , IdeCuenta   , Referencia,
                                                    DebeLocal   , HaberLocal  , DebeMoneda     , HaberMoneda  , CodCentro  )
                                           VALUES ( nCodCia     , nCodPeriodo , nIdeOpeContable, nNumMov      , X.IdeCuenta , X.IdPoliza,
                                                    X.HaberLocal, X.DebeLocal , X.HaberMoneda  , X.DebeMoneda , nCodCentro );
       END IF;
   END LOOP;
   --
   nTasaCambio := ROUND(nDebeLocal/nDebeMoneda,8);
   --
   UPDATE MOVIMIENTO_CONTABLE
      SET TasaCambio = nTasaCAmbio
    WHERE CodCia         = nCodCia
      AND CodPeriodo     = nCodPeriodo
      AND IdeOpeContable = nIdeOpeContable
      AND NumMov         = nNumMov;
   --
   IF NVL(nDebeLocal,0) = NVL(nHaberLocal,0) THEN
      UPDATE MOVIMIENTO_CONTABLE
         SET Descuadrado = 'N'
       WHERE CodCia         = nCodCia
         AND CodPeriodo     = nCodPeriodo
         AND IdeOpeContable = nIdeOpeContable
         AND NumMov         = nNumMov;
   END IF;
EXCEPTION
     WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR (-20100,'PROC_MOVCONTA - Ocurrio el siguiente error: '||SQLERRM);

END PROC_MOVCONTA;

PROCEDURE PROC_COMISIONPOL(nIdPoliza NUMBER, nIdetPol NUMBER, nCodCia NUMBER,
                           nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cCodMoneda VARCHAR2,
                           nIdFactura NUMBER, nMontoDetLocal NUMBER, nMontoDetMoneda NUMBER,
                           nTasaCambio NUMBER) IS

nMontoComiLocal   COMISIONES.Comision_Local%TYPE;
nMontoComiMoneda  COMISIONES.Comision_Moneda%TYPE;
nPorcComisiones   DETALLE_POLIZA.PorcComis%TYPE;
nMontoComisiones  DETALLE_POLIZA.MontoComis%TYPE;
nIdTransac        TRANSACCION.IdTransaccion%TYPE;
cExiste           VARCHAR2(1);
nMonto            COMISIONES.Comision_Local%TYPE := 0;
nCod_Agente       COMISIONES.Cod_Agente%TYPE;
nnIdetPol         DETALLE_POLIZA.IdetPol%TYPE;
nPrimaMoneda      DETALLE_POLIZA.Prima_Moneda%TYPE;
nPrimaLocal       DETALLE_POLIZA.Prima_local%TYPE;
nNumPagos         PLAN_DE_PAGOS.NUMPAGOS%TYPE;
nFrecPagos        PLAN_DE_PAGOS.FrecPagos%TYPE;
dFecIniVig        POLIZAS.FecIniVig%TYPE;
dFecFinVig        POLIZAS.FecFinVig%TYPE;
nIdComision       COMISIONES.IdComision%TYPE;
nCantPagosReal    NUMBER(5);

CURSOR C_Agentes IS
  SELECT Cod_Agente, Porc_Comision, IdetPol, IdTipoSeg
    FROM AGENTES_DETALLES_POLIZAS
   WHERE IdPoliza  = nIdPoliza;


CURSOR C_AGENTES_D(nCod_Agente NUMBER) IS
  SELECT Cod_Agente_Distr Cod_Agente, Porc_Com_Proporcional Porc_Comision,
         Porc_Com_Distribuida, Origen
    FROM AGENTES_DISTRIBUCION_COMISION
   WHERE IdPoliza   = nIdPoliza
     AND IDetPol    = nIdetPol
     AND Cod_Agente = nCod_Agente;
BEGIN
   SELECT NumPagos, FrecPagos
     INTO nNumPagos, nFrecPagos
     FROM PLAN_DE_PAGOS
     WHERE CodPlanPago IN (SELECT CodPlanPago
                             FROM Polizas
                            WHERE Idpoliza = nIdPoliza);

   SELECT FecIniVig, FecFinVig
     INTO dFecIniVig, dFecFinVig
     FROM POLIZAS
    WHERE CodCia    = nCodCia
      AND IdPoliza  = nIdPoliza;

   -- Determina Meses de Vigencia para Plan de Pagos
   IF nNumPagos <= 12 THEN
      nCantPagosReal  := FLOOR(MONTHS_BETWEEN(dFecFinVig, dFecIniVig) / nFrecPagos);
   ELSE
      nCantPagosReal  := FLOOR((dFecFinVig - dFecIniVig) / nFrecPagos);
   END IF;

   IF nCantPagosReal <= 0 THEN
      nCantPagosReal := 1;
   END IF;
   IF nCantPagosReal < nNumPagos THEN
      nNumPagos := nCantPagosReal;
   END IF;

   FOR I IN C_AGENTES LOOP
      --FOR R_Agentes IN C_Agentes LOOP
      nCod_Agente := I.Cod_Agente;
      -- nnIdetPol    := I.IdetPol;

      FOR R_Agentes IN C_AGENTES_D(I.Cod_Agente) LOOP
         --OC-17, Se agrega Prima Local y Prima Moneda
         SELECT NVL(PorcComis,0), NVL(MontoComis,0), NVL(Prima_Local,0), NVL(Prima_Moneda,0)
           INTO nPorcComisiones, nMontoComisiones, nPrimaLocal, nPrimaMoneda
           FROM DETALLE_POLIZA
          WHERE IdPoliza  = nIdPoliza
            AND IDETPOL   = I.IDETPOL
            AND CodCia    = nCodCia
            AND IdTipoSeg = I.IdTipoSeg;

         IF NVL(nMontoComisiones,0) = 0 THEN
            --OC17 CAMBIOS REALIZADOS OC GUATEMALA.
            --OC17--nMontoComiLocal  := nMontoDetLocal * (R_Agentes.Porc_Comision/100) * (I.Porc_Comision/100);
            --OC17 nMontoComiLocal  := (nPrimaLocal*nPorcComisiones/100) * (R_Agentes.Porc_Comision/100) * (I.Porc_Comision/100);
            --OC17  nMontoComiMoneda := nMontoDetMoneda * (R_Agentes.Porc_Comision/100) * (I.Porc_Comision/100);
            --OC17nMontoComiMoneda := (nPrimaMoneda*nPorcComisiones/100) * (R_Agentes.Porc_Comision/100) * (I.Porc_Comision/100);
            nMontoComiLocal  := (nPrimaLocal*(R_Agentes.Porc_com_distribuida/100)/nNumPagos);
            nMontoComiMoneda := (nPrimaMoneda*R_Agentes.Porc_com_distribuida/100)/nNumPagos;
         ELSE
            nMontoComiLocal  := nMontoComisiones * (R_Agentes.Porc_Comision/100) * (I.Porc_Comision/100);
            nMontoComiMoneda := nMontoComisiones / nTasaCambio * (R_AGENTES.Porc_Comision/100) * (I.Porc_Comision/100);
         END IF;

         BEGIN
            SELECT 'S'
              INTO cExiste
              FROM COMISIONES
             WHERE IdPoliza  = nIdPoliza
               AND IdFactura = nIdFactura
        --       AND IDETPOL = I.IDETPOL
              AND Cod_Agente = R_Agentes.Cod_Agente;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cExiste :='N';
           WHEN TOO_MANY_ROWS THEN
               cExiste :='S';
         END;

         IF cExiste = 'N' THEN
            OC_COMISIONES.INSERTAR_COMISION_FACT(nIdFactura, nIdPoliza, I.IdetPol, cCodMoneda, R_Agentes.Cod_Agente,
                                                 nCodCia, nCodEmpresa, nMontoComiLocal, nMontoComiMoneda,
                                                 nTasaCambio, R_Agentes.Origen, I.IdTipoSeg);
         ELSIF cExiste = 'S' THEN
            UPDATE COMISIONES
               SET Comision_Moneda  = Comision_Moneda + nMontoComiMoneda,
                   Comision_Local   = Comision_Local   + nMontoComiLocal,
                   Com_Saldo_Local  = Com_Saldo_Local  + nMontoComiLocal,
                   Com_Saldo_Moneda = Com_Saldo_Moneda + nMontoComiMoneda
             WHERE IdPoliza   = IdPoliza
               AND IdFactura  = nIdFactura
               AND Cod_Agente = R_AGENTES.Cod_Agente;

            nMontoComiLocal := 0;

            SELECT IdComision
              INTO nIdComision
              FROM COMISIONES
             WHERE IdPoliza  = nIdPoliza
               AND IdFactura = nIdFactura
               AND Cod_Agente = R_Agentes.Cod_Agente;

            -- Elimina para Recalcular los Conceptos del Detale
            DELETE DETALLE_COMISION
             WHERE IdComision = nIdComision;
            OC_DETALLE_COMISION.INSERTA_DETALLE_COMISION(nCodCia, nIdPoliza, nIdComision, R_Agentes.Origen, I.IdTipoSeg);
         END IF;
         nMontoComiLocal := 0;
      END LOOP;
      nMontoComiLocal:=0;
   END LOOP;
END PROC_COMISIONPOL;

PROCEDURE PROC_ENDO_COMI (nIdPoliza NUMBER, nIdetPol NUMBER, nIdEndoso NUMBER,
                          nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                          cCodMoneda VARCHAR2, nIdFactura NUMBER, nMontoDetLocal NUMBER,
                          nMontoDetMoneda NUMBER, nTasaCambio NUMBER) IS
nMontoComiLocal          COMISIONES.Comision_Local%TYPE;
nMontoComiMoneda         COMISIONES.Comision_Moneda%TYPE;
nPorcComisiones          DETALLE_POLIZA.PorcComis%TYPE;
nMontoComisiones         DETALLE_POLIZA.MontoComis%TYPE;
nCod_Agente              COMISIONES.Cod_Agente%TYPE;
nPrimaMoneda             DETALLE_POLIZA.Prima_Moneda%TYPE;
nPrimaLocal              DETALLE_POLIZA.Prima_local%TYPE;
cExiste                  VARCHAR2(1);
nNumPagos                PLAN_DE_PAGOS.NUMPAGOS%TYPE;
nFrecPagos               PLAN_DE_PAGOS.FrecPagos%TYPE;
nIdComision              COMISIONES.IdComision%TYPE;
nCantPagosReal           NUMBER(5);
dFecIniVig               POLIZAS.FecIniVig%TYPE;
dFecFinVig               POLIZAS.FecFinVig%TYPE;

CURSOR C_Agentes IS
  SELECT Cod_Agente, Porc_Comision, IdetPol, IdTipoSeg
    FROM AGENTES_DETALLES_POLIZAS
   WHERE IdPoliza  = nIdPoliza
     AND IDetPol   = nIdetPol
     AND IdTipoSeg = cIdTipoSeg;


CURSOR C_AGENTES_D(nCod_Agente NUMBER) IS
  SELECT Cod_Agente_Distr Cod_Agente, Porc_Com_Proporcional Porc_Comision,
         Porc_Com_Distribuida, Origen
    FROM AGENTES_DISTRIBUCION_COMISION
   WHERE IdPoliza   = nIdPoliza
     AND IDetPol    = nIdetPol
     AND Cod_Agente = nCod_Agente;
BEGIN
   SELECT NumPagos, FrecPagos
     INTO nNumPagos, nFrecPagos
     FROM PLAN_DE_PAGOS
    WHERE CodPlanPago IN (SELECT CodPlanPago
                            FROM ENDOSOS
                           WHERE Idpoliza = nIdPoliza
                             AND Idetpol  = nIdetPol
                             AND IdEndoso = nIdEndoso);

   SELECT FecIniVig, FecFinVig
     INTO dFecIniVig, dFecFinVig
     FROM ENDOSOS
    WHERE CodCia    = nCodCia
      AND IdPoliza  = nIdPoliza
      AND IDetpol   = nIDetPol
      AND IdEndoso  = nIdEndoso;

   -- Determina Meses de Vigencia para Plan de Pagos
   IF nNumPagos <= 12 THEN
      nCantPagosReal  := FLOOR(MONTHS_BETWEEN(dFecFinVig, dFecIniVig) / nFrecPagos);
   ELSE
      nCantPagosReal  := FLOOR((dFecFinVig - dFecIniVig) / nFrecPagos);
   END IF;

   IF nCantPagosReal <= 0 THEN
      nCantPagosReal := 1;
   END IF;
   IF nCantPagosReal < nNumPagos THEN
      nNumPagos := nCantPagosReal;
   END IF;

   FOR I IN C_AGENTES LOOP
      nCod_Agente := I.Cod_Agente;
      FOR R_Agentes IN C_AGENTES_D(I.Cod_Agente) LOOP
         SELECT PorcComis, Prima_Neta_Local, Prima_Neta_Moneda
           INTO NPORCCOMISIONES, NPRIMALOCAL,NPRIMAMONEDA
           FROM ENDOSOS
          WHERE IdPoliza  = nIdPoliza
            AND IDETPOL   = I.IDETPOL
            AND CodCia    = nCodCia
            AND IdEndoso  = nIdEndoso;

         IF NVL(NMONTOCOMISIONES,0) = 0 THEN
              nMontoComiLocal  := (nPrimaLocal*(R_Agentes.Porc_com_distribuida/100)/nNumPagos);
              nMontoComiMoneda := (nPrimaMoneda*R_Agentes.Porc_com_distribuida/100)/nNumPagos;
         ELSE
            nMontoComiLocal  := nMontoComisiones * (R_Agentes.Porc_Comision/100) * (I.Porc_Comision/100);
            nMontoComiMoneda := nMontoComiMoneda / nTasaCambio * (R_AGENTES.Porc_Comision/100) * (I.Porc_Comision/100);
         END IF;
         BEGIN
            SELECT 'S'
              INTO cExiste
              FROM COMISIONES
             WHERE IdPoliza   = nIdPoliza
               AND IdFactura  = nIdFactura
               AND Cod_Agente = R_Agentes.Cod_Agente;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cExiste :='N';
            WHEN TOO_MANY_ROWS THEN
               cExiste :='S';
         END;

         IF cExiste = 'N' THEN
            OC_COMISIONES.INSERTAR_COMISION_FACT(nIdFactura, nIdPoliza, I.IdetPol, cCodMoneda, R_Agentes.Cod_Agente,
                                                 nCodCia, nCodEmpresa, nMontoComiLocal, nMontoComiMoneda, nTasaCambio,
                                                 R_Agentes.Origen, I.IdTipoSeg);
         ELSIF cExiste = 'S' THEN
            UPDATE COMISIONES
               SET Comision_Moneda  = Comision_Moneda + nMontoComiMoneda,
                   Comision_Local   = Comision_Local   + nMontoComiLocal,
                   Com_Saldo_Local  = Com_Saldo_Local  + nMontoComiLocal,
                   Com_Saldo_Moneda = Com_Saldo_Moneda + nMontoComiMoneda
             WHERE IdPoliza   = IdPoliza
               AND IdFactura  = nIdFactura
               AND Cod_Agente = R_AGENTES.Cod_Agente;

             nMontoComiLocal:=0;

            SELECT IdComision
              INTO nIdComision
              FROM COMISIONES
             WHERE IdPoliza  = nIdPoliza
               AND IdFactura = nIdFactura
               AND Cod_Agente = R_Agentes.Cod_Agente;

            -- Elimina para Recalcular los Conceptos del Detale
            DELETE DETALLE_COMISION
             WHERE IdComision = nIdComision;
            OC_DETALLE_COMISION.INSERTA_DETALLE_COMISION(nCodCia, nIdPoliza, nIdComision, R_Agentes.Origen, I.IdTipoSeg);
         END IF;
         nMontoComiLocal := 0;
      END LOOP;
      nMontoComiLocal := 0;
   END LOOP;
END PROC_ENDO_COMI;

PROCEDURE PROC_EMITE_FACT_MENSUAL(nIdPoliza NUMBER, nIdEndoso NUMBER, pCodCia NUMBER, nTransa NUMBER,nCuota NUMBER) IS
nIdFactura               FACTURAS.IdFactura%TYPE;
nNumPagos                PLAN_DE_PAGOS.NumPagos%TYPE;
nFrecPagos               PLAN_DE_PAGOS.FrecPagos%TYPE;
nPorcInicial             PLAN_DE_PAGOS.PorcInicial%TYPE;
nCodCliente              POLIZAS.CodCliente%TYPE;
cIdTipoSeg               DETALLE_POLIZA.IdTipoSeg%TYPE;
nTotPrimas               DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDifer                   DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDiferMoneda             DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoDet                  DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoDetMoneda            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoTotal                DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoTotalMoneda          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cCodMoneda               POLIZAS.Cod_Moneda%TYPE;
nPrimaNetaMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoPagoMoneda           FACTURAS.Monto_Fact_Moneda%TYPE;
cCodMonedaLocal          EMPRESAS.Cod_Moneda%TYPE;
nPrimaRestMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoComisiMoneda         FACTURAS.MtoComisi_Local%TYPE;
nTotPrimasMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nCodCia                  POLIZAS.CodCia%TYPE;
nCodEmpresa              POLIZAS.CodEmpresa%TYPE;
cCodPlanPago             DETALLE_POLIZA.CodPlanPago%TYPE;
nTasaCambio              DETALLE_POLIZA.Tasa_Cambio%TYPE;
nMtoCpto                 CONCEPTOS_PLAN_DE_PAGOS.MtoCpto%TYPE;
nPorcCpto                CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
cAplica                  CONCEPTOS_PLAN_DE_PAGOS.Aplica%TYPE;
Dummy                    NUMBER(5);
dFecPago                 DATE;
nMtoPago                 NUMBER(18,2);
nMtoComisi               NUMBER(18,2);
nPrimaRest               NUMBER(18,2);
dFecHoy                  DATE;
cGraba                   VARCHAR2(1);
nCod_Agente              AGENTES_DETALLES_POLIZAS.Cod_Agente%TYPE;
--
nMtoRecD_Local           DETALLE_RECARGO.Monto_Local%TYPE;
nMtoRecD_Moneda          DETALLE_RECARGO.Monto_Moneda%TYPE;
nMtoDescD_Local          DETALLE_DESCUENTO.Monto_Local%TYPE;
nMtoDescD_Moneda         DETALLE_DESCUENTO.Monto_Moneda%TYPE;
--
nMtoRec_Local            RECARGOS.Monto_Local%TYPE;
nMtoRec_Moneda           RECARGOS.Monto_Moneda%TYPE;
nMtoDesc_Local           DESCUENTOS.Monto_Local%TYPE;
nMtoDesc_Moneda          DESCUENTOS.Monto_Moneda%TYPE;
nPrimaTotalM             DETALLE_POLIZA.Prima_Moneda%TYPE;
nPrimaTotalL             DETALLE_POLIZA.Prima_Local%TYPE;
nFactor                  NUMBER (14,8);
nRec_Local               RECARGOS.Monto_Local%TYPE ;
nRec_Moneda              RECARGOS.Monto_Moneda%TYPE;
nDesc_Local              DESCUENTOS.Monto_Local%TYPE;
nDesc_Moneda             DESCUENTOS.Monto_Moneda%TYPE;
cCodPlanPagoPol          POLIZAS.CodPlanPago%TYPE;
--
nPorcComis               DETALLE_POLIZA.PorcComis%TYPE;
nNumCert                 DETALLE_POLIZA.IdetPol%TYPE;
nPrimaLocal              NUMBER(18,2);
nPrimaMoneda             NUMBER(18,2);
nIdTransac               NUMBER(14,0);
nMtoComisiRest           NUMBER(18,2);
nMtoComisiMonedaRest     NUMBER(18,2);
nMtoComisiPag            NUMBER(18,2);
nMtoComisiMonedaPag      NUMBER(18,2);
nMtoComiTot              NUMBER(18,2);
nMtoComisiMonedaTot      NUMBER(18,2);
nMtoComiL                NUMBER(18,2);
nMtoComisiM              NUMBER(18,2);
nDiferC                  DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDiferCMon               DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cRespPol                 VARCHAR2(1):='N';
cRespDet                 VARCHAR2(1):='N';
nPorcT                   NUMBER(18,2);
nFact                    NUMBER(18,2);
nCodTipoDoc              TIPO_DE_DOCUMENTO.CodTipoDoc%TYPE;
nIdetPol                 DETALLE_POLIZA.IdetPol%TYPE; --:= 1;
cContabilidad_Automatica EMPRESAS.Contabilidad_Automatica%TYPE;
nIdTranc                 TRANSACCION.idtransaccion%TYPE;
nMtoT                    FACTURAS.monto_fact_local%TYPE := 0;
NP                       NUMBER (10);
nMtoAsistLocal           ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nMtoAsistMoneda          ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
nAsistRestLocal          ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nAsistRestMoneda         ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
nTotAsistLocal           ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nTotAsistMoneda          ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
cPrimerFact              VARCHAR2(1) := 'N';
cIndFactElectronica      POLIZAS.IndFactElectronica%TYPE;
cIndCalcDerechoEmis      POLIZAS.IndCalcDerechoEmis%TYPE;
fFecfinvig               FACTURAS.FECFINVIG%TYPE;      -- ICOFINVIG

CURSOR DET_POL_Q IS
   SELECT D.Prima_Local PrimaLocal, D.Prima_Moneda PrimaMoneda, D.CodPlanPago, D.PorcComis,
          P.FecIniVig, P.FecEmision, D.IDetPol, D.Tasa_Cambio, D.IdTipoSeg
     FROM DETALLE_POLIZA D, POLIZAS P
    WHERE D.Prima_Local > 0
      AND D.IdPoliza    = P.IdPoliza
      AND D.StsDetalle IN ('SOL','XRE') -- ('EMI','INC','XRE','SOL')
      AND P.IdPoliza    = nIdPoliza;

CURSOR CPTO_PLAN_Q IS
   SELECT CP.CodCpto, CP.PorcCpto, CP.Aplica, CP.MtoCpto, CP.RutinaCalculo,
          CC.IndRangosTipseg
     FROM CONCEPTOS_PLAN_DE_PAGOS CP, CATALOGO_DE_CONCEPTOS CC
    WHERE CC.IndCptoAjuste = 'N'
      AND CC.IndCptoPrimas = 'N'
      AND CC.CodConcepto   = CP.CodCpto
      AND CC.CodCia        = CP.CodCia
      AND CP.CodCia        = pCodCia
      AND CP.CodEmpresa    = nCodEmpresa
      AND CP.CodPlanPago   = cCodPlanPago
      AND EXISTS (SELECT 'S'
                    FROM RAMOS_CONCEPTOS_PLAN
                   WHERE CodCia      = CP.CodCia
                     AND CodEmpresa  = CP.CodEmpresa
                     AND IdTipoSeg  IN (SELECT IdTipoSeg
                                          FROM DETALLE_POLIZA
                                         WHERE IdPoliza  = nIdPoliza)
                     AND CodCpto     = CP.CodCpto
                     AND CodPlanPago = CP.CodPlanPago)
    ORDER BY CP.Prioridad;

CURSOR RESP_PAGO IS
  SELECT R.CodResPago
    FROM RESPONSABLE_PAGO_DET R
   WHERE R.IdPoliza    = nIdPoliza
     AND R.CodCia      = pCodCia
     AND R.CodEmpresa  = nCodEmpresa
   GROUP BY R.CodResPago;

CURSOR CPTO_PRIMAS_Q IS
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERT_ACT C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert   = C.CodCobert
      AND CS.PlanCob     = C.PlanCob
      AND CS.IdTipoSeg   = C.IdTipoSeg
      AND CS.CodEmpresa  = C.CodEmpresa
      AND CS.CodCia      = C.CodCia
      AND C.IDetPol      = nIdetPol
      AND C.StsCobertura IN ('EMI','SOL','XRE')
      AND C.IdPoliza     = nIdPoliza
      AND C.CodCia       = pCodCia
    GROUP BY CS.CodCpto
      UNION ALL
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERT_ACT_ASEG C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert   = C.CodCobert
      AND CS.PlanCob     = C.PlanCob
      AND CS.IdTipoSeg   = C.IdTipoSeg
      AND CS.CodEmpresa  = C.CodEmpresa
      AND CS.CodCia      = C.CodCia
      AND C.StsCobertura IN ('EMI','SOL','XRE')
      AND C.IDetPol      = nIdetPol
      AND C.IdPoliza     = nIdPoliza
      AND C.CodCia       = pCodCia
      AND c.Prima_Local != 0
    GROUP BY CS.CodCpto;
CURSOR CPTO_ASIST_Q IS
   SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
          SUM(A.MontoAsistMoneda) MontoAsistMoneda
     FROM ASISTENCIAS_DETALLE_POLIZA A, DETALLE_POLIZA D, ASISTENCIAS T
    WHERE T.CodAsistencia  = A.CodAsistencia
      AND D.IDetPol        = A.IDetPol
      AND D.IdPoliza       = A.IdPoliza
      AND D.CodCia         = A.CodCia
      AND A.StsAsistencia IN ('EMITID','SOLICI','XRENOV')
      AND A.IDetPol        = nNumCert
      AND A.IdPoliza       = nIdPoliza
      AND A.CodCia         = pCodCia
    GROUP BY T.CodCptoServicio
  UNION ALL
   SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
          SUM(A.MontoAsistMoneda) MontoAsistMoneda
     FROM ASISTENCIAS_ASEGURADO A, DETALLE_POLIZA D, ASISTENCIAS T
    WHERE T.CodAsistencia  = A.CodAsistencia
      AND D.IDetPol        = A.IDetPol
      AND D.IdPoliza       = A.IdPoliza
      AND D.CodCia         = A.CodCia
      AND A.StsAsistencia IN ('EMITID','SOLICI','XRENOV')
      AND A.IDetPol        = nNumCert
      AND A.IdPoliza       = nIdPoliza
      AND A.CodCia         = pCodCia
    GROUP BY T.CodCptoServicio;
BEGIN
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
  BEGIN
      SELECT CodCliente, Cod_Moneda, CodCia, CodEmpresa,
             CodPlanPago, IndFactElectronica, IndCalcDerechoEmis
        INTO nCodCliente, cCodMoneda, nCodCia, nCodEmpresa,
             cCodPlanPagoPol, cIndFactElectronica, cIndCalcDerechoEmis
        FROM POLIZAS
       WHERE IdPoliza = nIdPoliza;
    END;
    BEGIN
       SELECT Cod_Moneda
         INTO cCodMonedaLocal
         FROM EMPRESAS
        WHERE CodCia = nCodCia;
  END;
  BEGIN
     SELECT SUM(D.Prima_Local) PrimaLocal, SUM(D.Prima_Moneda) PrimaMoneda, COUNT(IdetPol)
       INTO nPrimaTotalL, nPrimaTotalM, nNumCert
       FROM DETALLE_POLIZA D, POLIZAS P
      WHERE D.IdPoliza  = P.IdPoliza
        AND D.StsDetalle IN ('SOL','XRE')--('EMI','SOL')
        AND P.IdPoliza  = nIdPoliza;
   END;
   BEGIN
      SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
        INTO nMtoRec_Local, nMtoRec_Moneda
        FROM RECARGOS
       WHERE IdPoliza = nIdPoliza
         AND Estado   = 'ACT';
   EXCEPTION
      WHEN OTHERS THEN
         nMtoRec_Local  := 0;
         nMtoRec_Moneda := 0;
   END;
   BEGIN
      SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
        INTO nMtoDesc_Local, nMtoDesc_Moneda
        FROM DESCUENTOS
       WHERE IdPoliza  = nIdPoliza
         AND Estado    = 'ACT';
   EXCEPTION
      WHEN OTHERS THEN
         nMtoDesc_Local  := 0;
         nMtoDesc_Moneda := 0;
   END;
   -- Características del Plan de Pago
   BEGIN
      SELECT NumPagos, FrecPagos, PorcInicial
        INTO nNumPagos, nFrecPagos, nPorcInicial
        FROM PLAN_DE_PAGOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodPlanPago = cCodPlanPagoPol;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'No Existe Plan de Pagos '||cCodPlanPagoPol);
   END;
   BEGIN
      SELECT 'S'
        INTO cRespPol
        FROM RESPONSABLE_PAGO_POL
       WHERE StsResPago = 'ACT'
         AND CodCia     = pCodCia
         AND IdPoliza   = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cRespPol := 'N';
      WHEN TOO_MANY_ROWS THEN
         cRespPol := 'S';
   END;
   IF cRespPol = 'S' AND FUNC_VALIDA_RESP_POL (nIdPoliza,pCodCia) = 'S' THEN
      PROC_INSERT_RESP_D (nIdPoliza,pCodCia);
   END IF;
   BEGIN
      SELECT 'S'
        INTO cRespDet
        FROM RESPONSABLE_PAGO_DET R
       WHERE R.IdPoliza    = nIdPoliza
         AND R.CodCia      = pCodCia
         AND R.CodEmpresa  = nCodEmpresa;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cRespDet:='N';
      WHEN TOO_MANY_ROWS THEN
         cRespDet:='S';
   END;
   IF cRespPol = 'N' AND cRespDet = 'N' THEN
      FOR X IN DET_POL_Q LOOP
         nIdetPol   := X.IdetPol;
         cIdTipoSeg := X.IdTipoSeg;
         BEGIN
            SELECT Cod_Agente
              INTO nCod_Agente
              FROM AGENTES_DETALLES_POLIZAS
             WHERE IdPoliza      = nIdPoliza
               AND IdetPol       = X.IdetPol
               AND IdTipoSeg     = X.IdTipoSeg
               AND Ind_Principal = 'S';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR (-20100,'No Existe un Agente Definido para el Tipo de Seguro '||X.IdTipoSeg);
            WHEN TOO_MANY_ROWS THEN
               RAISE_APPLICATION_ERROR (-20100,'Existe Mas de un Agente Definido como Principal');
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR (-20100,'Existe un error de otros');
         END;

         cCodPlanPago := X.CodPlanPago;
         nMtoT        := 0;

         OC_DETALLE_TRANSACCION.CREA (nTransa,nCodCia,nCodEmpresa,7,'CER', 'DETALLE_POLIZA',
                                      nIdPoliza, X.IdetPol, NULL, NULL, X.PrimaLocal);

         IF nMtoRec_Local != 0 OR nMtoRec_Moneda != 0 OR nMtoDesc_Local != 0 OR nMtoDesc_Moneda != 0 THEN
            nFactor      := (X.PrimaLocal    / NVL(nPrimaTotalL,0)) * 100;
            nRec_Local   := (nMtoRec_Local  * nFactor) / 100;
            nRec_Moneda  := (nMtoRec_Moneda * nFactor) / 100;
            nDesc_Local  := (nMtoDesc_Local * nFactor) / 100;
            nDesc_Moneda := (nMtoDesc_Moneda * nFactor)/ 100;
         END IF;
         IF nIdEndoso = 0 THEN
            nTasaCambio := X.Tasa_Cambio;
         ELSE
            nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
         END IF;
         -- Fecha del Primer Pago Siempre a Inicio de Vigencia
         dFecPago := X.FecIniVig;
         /*IF X.FecIniVig > X.FecEmision THEN
            dFecPago := X.FecIniVig;
         ELSE
            dFecPago := X.FecEmision;
         END IF;*/
         -- Monto del Primer Pago
         nTotPrimas       := 0;
         nTotPrimasMoneda := 0;
         nMtoComisi       := 0;
         nMtoComisiMoneda := 0;
         BEGIN
            SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
              INTO nMtoRecD_Local, nMtoRecD_Moneda
              FROM DETALLE_RECARGO
             WHERE IdPoliza = nIdPoliza
               AND IDetPol  = X.IDetPol
               AND Estado   = 'ACT';
         EXCEPTION
            WHEN OTHERS THEN
               nMtoRecD_Local  := 0;
               nMtoRecD_Moneda := 0;
         END;
         BEGIN
            SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
              INTO nMtoDescD_Local, nMtoDescD_Moneda
              FROM DETALLE_DESCUENTO
             WHERE IdPoliza  = nIdPoliza
               AND IDetPol   = X.IDetPol
               AND Estado    = 'ACT';
         EXCEPTION
            WHEN OTHERS THEN
               nMtoDescD_Local  := 0;
               nMtoDescD_Moneda := 0;
         END;
         IF NVL(nPorcInicial,0) <> 0 THEN
            nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0))  * nPorcInicial / 100  ;
            nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) * nPorcInicial / 100 ;
            nMtoComisiPag       := NVL(nMtoComisiPag,0)       + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100) * nPorcInicial / 100 );
            nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + ((NVL(X.PrimaMoneda,0)* X.PorcComis / 100) * nPorcInicial / 100) ;
         ELSE
            nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local    - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) / nNumPagos  ;
            nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda   - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) /nNumPagos ;
            nMtoComisiPag       := nMtoComisiPag              + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100) / nNumPagos ;
            nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100) / nNumPagos ;
         END IF;
         nPrimaRest           := NVL(nPrimaRest,0)           + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) - NVL(nMtoPago,0);
         nMtoComisiRest       := NVL(nMtoComisiRest,0)       + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100 ) -  NVL(nMtoComisiPag,0));
         nTotPrimas           := NVL(nTotPrimas,0)           + NVL(nMtoPago,0);
         nMtoComisi           := NVL(nMtoComisi,0)           + NVL(nMtoComisiPag,0);
         nPrimaRestMoneda     := NVL(nPrimaRestMoneda,0)     + (NVL(X.PrimaMoneda,0)  + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) - NVL(nMtoPagoMoneda,0);
         nMtoComisiMonedaRest := NVL(nMtoComisiMonedaRest,0) + ((NVL(X.PrimaMoneda,0) * X.PorcComis / 100) -   NVL(nMtoComisiMonedaPag,0));
         nMtoComisiMoneda     := NVL(nMtoComisiMoneda,0)     + NVL(nMtoComisiMonedaPag,0);
         nTotPrimasMoneda     := NVL(nTotPrimasMoneda,0)     + NVL(nMtoPagoMoneda,0);
         nPrimaMoneda         := NVL(nPrimaMoneda,0)         + NVL(X.PrimaMoneda,0);
         nPrimaLocal          := NVL(nPrimaLocal,0)          + NVL(X.PrimaLocal,0) ;
         nMtoComiL            := NVL(nMtoComiL,0)            + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100) ;
         nMtoComisiM          := NVL(nMtoComisiM,0)          + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100) ;
--      END LOOP;

        nPrimaRest           := NVL(nPrimaLocal,0)  - NVL(nMtoPago,0);
        nPrimaRestMoneda     := NVL(nPrimaMoneda,0) - NVL(nMtoPagoMoneda,0);
        nMtoComisiRest       := NVL(nMtoComiL,0)    - NVL(nMtoComisiPag,0);
        nMtoComisiMonedaRest := NVL(nMtoComisiM,0)  - NVL(nMtoComisiMonedaPag,0);
        NP := nCuota;
        BEGIN
           IF nFrecPagos NOT IN (15,7) THEN
              SELECT TRUNC(NVL(ADD_MONTHS(MAX(FECVENC),1),SYSDATE))
                INTO dFecPago
                FROM FACTURAS
               WHERE IdPoliza = nIdPoliza
                 AND IDetPol  = nIdetPol
                 AND CodCia   = pCodCia;
           ELSE
              SELECT TRUNC(NVL(MAX(FECVENC),SYSDATE))+nFrecPagos
                INTO dFecPago
                FROM FACTURAS
               WHERE IdPoliza = nIdPoliza
                 AND IDetPol  = nIdetPol
                 AND CodCia   = pCodCia;
           END IF;
           -- Valida si es realmente el primer pago o pagos posteriores
           IF dFecPago = TRUNC(SYSDATE) THEN
              cPrimerFact := 'S';
           ELSE
              cPrimerFact := 'N';
           END IF;
        END;

      IF OC_GENERALES.VALIDA_FECHA(dFecPago) = 'S' THEN
         -- LARPLA
         nIdFactura := OC_FACTURAS.INSERTAR(nIdPoliza,           nIDetPol,        nCodCliente, dFecPago, 
                                            nMtoPago,            nMtoPagoMoneda,  nIdEndoso,   nMtoComisiPag, 
                                            nMtoComisiMonedaPag, NP,              nTasaCambio, nCod_Agente, 
                                            nCodTipoDoc,         pCodCia,         cCodMoneda,  NULL, 
                                            nTransa,             cIndFactElectronica);

         FOR W IN CPTO_PRIMAS_Q LOOP
             --nFactor := W.Prima_Local / NVL(nMtoPago,0);
            nFactor := (W.Prima_Local /nNumPagos) / NVL(X.PrimaLocal,0);
            OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
            OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
         END LOOP;

         nTotAsistLocal  := 0;
         nTotAsistMoneda := 0;
         FOR K IN CPTO_ASIST_Q LOOP
            nAsistRestLocal  := 0;
            nAsistRestMoneda := 0;
            IF NVL(nPorcInicial,0) <> 0 THEN
               nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) * nPorcInicial / 100);
               nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) * nPorcInicial / 100);
            ELSE
               nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) / nNumPagos);
               nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) / nNumPagos);
            END IF;
            /*nAsistRestLocal  := NVL(nAsistRestLocal,0) + NVL(K.MontoAsistLocal,0) - nMtoAsistLocal;
            nAsistRestMoneda := NVL(nAsistRestMoneda,0) + NVL(K.MontoAsistMoneda,0) - nMtoAsistMoneda;
            IF NP > 1 THEN
               nMtoAsistLocal  := (NVL(nAsistRestLocal,0) / (nNumPagos - 1));
               nMtoAsistMoneda := (NVL(nAsistRestMoneda,0) / (nNumPagos - 1));
            END IF;*/
            nTotAsistLocal  := NVL(nTotAsistLocal,0) + NVL(nMtoAsistLocal,0);
            nTotAsistMoneda := NVL(nTotAsistMoneda,0) + NVL(nMtoAsistMoneda,0);
            OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
            OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);

         END LOOP;

         nMtoT := nMtoT + nMtoPago;-- + NVL(nTotAsistLocal,0);

         -- Genera comisiones por agente por Poliza
         PROC_COMISIONPOL (nIdPoliza, NULL, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFactura,
                           nMtoComisiPag/nNumCert, nMtoComisiMonedaPag/nNumCert, nTasaCambio);
        -- Distribuye la comision por agente.
         FOR Y IN CPTO_PLAN_Q LOOP
            BEGIN
               SELECT 'S'
                 INTO cGraba
                 FROM RAMOS_CONCEPTOS_PLAN R
                WHERE R.CodPlanPago = cCodPlanPago
                  AND R.CodCpto     = Y.CodCpto
                  AND R.CodCia      = nCodCia
                  AND R.CodEmpresa  = nCodEmpresa
                  AND EXISTS   (SELECT 1
                                  FROM DETALLE_POLIZA D, POLIZAS P
                                 WHERE D.IdPoliza  = P.IdPoliza
                                   AND D.IdTipoSeg = R.IdTipoSeg
                                   AND P.StsPoliza IN ('EMI','SOL','XRE')
                                   AND P.IdPoliza  = nIdPoliza);
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cGraba := 'N';
               WHEN TOO_MANY_ROWS THEN
                  cGraba := 'S';
            END;

            IF cGraba = 'S' THEN
               IF Y.IndRangosTipseg = 'S' THEN
                  IF cIndCalcDerechoEmis = 'S' THEN
                     OC_CATALOGO_CONCEPTOS_RANGOS.VALOR_CONCEPTO(nCodCia, nCodEmpresa, Y.CodCpto, cIdTipoSeg,
                                                                 nIdPoliza, nIdetPol, nIdEndoso, nMtoCpto, nPorcCpto);
                     IF OC_DETALLE_FACTURAS.EXISTE_CONCEPTO(nCodCia, nIdPoliza, nTransa, Y.CodCpto) = 'N' THEN
                        IF NVL(nMtoCpto,0) = 0 AND NVL(nPorcCpto,0) = 0 THEN
                           nMtoCpto  := Y.MtoCpto;
                           nPorcCpto := Y.PorcCpto;
                        END IF;
                     ELSE
                        nMtoCpto  := 0;
                        nPorcCpto := 0;
                     END IF;
                  ELSE
                     nMtoCpto  := 0;
                     nPorcCpto := 0;
                  END IF;
               ELSE
                  nMtoCpto  := Y.MtoCpto;
                  nPorcCpto := Y.PorcCpto;
               END IF;
               IF Y.Aplica = 'P' THEN
                  IF NVL(nMtoCpto,0) <> 0 AND cPrimerFact = 'S' THEN --NP = 1 THEN
                     nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                  ELSIF Y.RutinaCalculo = 'DECLARA'  AND NVL(nMtoCpto,0) <> 0 AND cPrimerFact = 'S' THEN
                     nMtoDet        :=  NVL( OC_CONCEPTOS_PLAN_DE_PAGOS.MONTO_CONCEPTO (nCodCia,nIdPoliza,nIdetPol,nMtoCpto),0);
                     nMtoDetMoneda  :=  NVL( OC_CONCEPTOS_PLAN_DE_PAGOS.MONTO_CONCEPTO (nCodCia,nIdPoliza,nIdetPol,nMtoCpto),0) * nTasaCambio;
                  ELSIF cPrimerFact = 'S' THEN
                     nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                     nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                  ELSE
                     nMtoDet       := 0;
                     nMtoDetMoneda := 0;
                  END IF;
                  IF NVL(nMtoDet,0) != 0 THEN
                     OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                     OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                     nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                     nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                  END IF;
               ELSIF Y.Aplica = 'T'  THEN
                  IF NVL(nMtoCpto,0) <> 0 AND Y.RutinaCalculo IS NULL THEN
                     nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                  ELSIF Y. RutinaCalculo = 'DECLARA'  AND NVL(nMtoCpto,0) <> 0 THEN
                     nMtoDet        :=  NVL( OC_CONCEPTOS_PLAN_DE_PAGOS.MONTO_CONCEPTO (nCodCia,nIdPoliza,nIdetPol,nMtoCpto),0);
                     nMtoDetMoneda  :=  NVL( OC_CONCEPTOS_PLAN_DE_PAGOS.MONTO_CONCEPTO (nCodCia,nIdPoliza,nIdetPol,nMtoCpto),0) * nTasaCambio;
                  ELSE
                     nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                     nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                  END IF;
                  IF NVL(nMtoDet,0) != 0 THEN
                     OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                     OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                     nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                     nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                  END IF;
               END IF;
               nMtoT := nMtoT + nMtoDet;
            END IF;
         END LOOP;
         OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);

      ELSE
         RAISE_APPLICATION_ERROR(-20200,'La Factura Corresponde a la Fecha : '||TO_CHAR(dFecPago,'DD-MM-YYYY')||' ' ||'Posterior al mes corriente, Favor verificar');
      END IF;
    --  END LOOP;
      OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'FAC', 'FACTURAS',
                                   nIdPoliza, nIdetPol, NULL, NULL, nMtoT);
      OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'COM', 'COMISIONES',
                                   nIdPoliza, nIdetPol, NULL, NULL, nMtoComisiPag);

      OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
      END LOOP;
   ELSE
      BEGIN
         SELECT SUM(R.PorcResPago)
           INTO nPorcT
           FROM RESPONSABLE_PAGO_DET R
          WHERE R.IdPoliza    = nIdPoliza
            AND R.CodCia      = nCodCia
            AND R.CodEmpresa  = nCodEmpresa ;
      END;
      FOR J IN RESP_PAGO LOOP
         BEGIN
            SELECT (SUM(PORCRESPAGO)/nPorcT) * 100
              INTO nFact
              FROM RESPONSABLE_PAGO_DET r
             WHERE R.IdPoliza    = nIdPoliza
               AND R.CodCia      = nCodCia
               AND R.CodEmpresa  = nCodEmpresa
               AND R.CodResPago  = J.CodResPago;
         END;
         nMtoPago             := 0;
         nMtoPagoMoneda       := 0;
         nMtoComisiPag        := 0;
         nMtoComisiMonedaPag  := 0;
         nPrimaRest           := 0;
         nMtoComisiRest       := 0;
         nTotPrimas           := 0;
         nMtoComisi           := 0;
         nPrimaRestMoneda     := 0;
         nMtoComisiMonedaRest := 0;
         nMtoComisiMoneda     := 0;
         nTotPrimasMoneda     := 0;
         nPrimaMoneda         := 0;
         nPrimaLocal          := 0;
         nMtoComiL            := 0;
         nMtoComisiM          := 0;
         FOR X IN DET_POL_Q LOOP
            cIdTipoSeg := X.IdTipoSeg;
            nIdetPol   := X.IdetPol;
            BEGIN
               SELECT Cod_Agente
                 INTO nCod_Agente
                 FROM AGENTES_DETALLES_POLIZAS
                WHERE IdPoliza      = nIdPoliza
                  AND IdetPol       = X.IdetPol
                  AND IdTipoSeg     = X.IdTipoSeg
                  AND Ind_Principal = 'S';
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR (-20100,'No Existe un Agente Definido para el Tipo de Seguro '||X.IdTipoSeg);
               WHEN TOO_MANY_ROWS THEN
                  RAISE_APPLICATION_ERROR (-20100,'Existe Mas de un Agente Definido como Principal');
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR (-20100,'Existe un error de otros');
            END;
            cCodPlanPago := X.CodPlanPago;
            IF nMtoRec_Local != 0 OR nMtoRec_Moneda != 0 OR nMtoDesc_Local != 0 OR nMtoDesc_Moneda != 0 THEN
               nFactor      := (X.PrimaLocal * NVL(nFact,0)/100) / NVL(nPrimaTotalL,0) * 100;
               nRec_Local   := (nMtoRec_Local  * nFactor) / 100;
               nRec_Moneda  := (nMtoRec_Moneda * nFactor) / 100;
               nDesc_Local  := (nMtoDesc_Local * nFactor) / 100;
               nDesc_Moneda := (nMtoDesc_Moneda * nFactor)/ 100;
            END IF;
            IF nIdEndoso = 0 THEN
               nTasaCambio := X.Tasa_Cambio;
            ELSE
               nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
            END IF;

            -- Fecha del Primer Pago Siempre a Inicio de Vigencia
            dFecPago := X.FecIniVig;
            /*IF X.FecIniVig > X.FecEmision THEN
               dFecPago := X.FecIniVig;
            ELSE
               dFecPago := X.FecEmision;
            END IF;*/
                -- Monto del Primer Pago
            nTotPrimas       := 0;
            nTotPrimasMoneda := 0;
            nMtoComisi       := 0;
            nMtoComisiMoneda := 0;
            BEGIN
               SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
                 INTO nMtoRecD_Local, nMtoRecD_Moneda
                 FROM DETALLE_RECARGO
                WHERE IdPoliza = nIdPoliza
                  AND IDetPol  = X.IDetPol
                  AND Estado   = 'ACT';
            EXCEPTION
               WHEN OTHERS THEN
                  nMtoRecD_Local  := 0;
                  nMtoRecD_Moneda := 0;
            END;
            BEGIN
               SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
                 INTO nMtoDescD_Local, nMtoDescD_Moneda
                 FROM DETALLE_DESCUENTO
                WHERE IdPoliza  = nIdPoliza
                  AND IDetPol   = X.IDetPol
                  AND Estado    = 'ACT';
            EXCEPTION
               WHEN OTHERS THEN
                  nMtoDescD_Local  := 0;
                  nMtoDescD_Moneda := 0;
            END;

            IF NVL(nPorcInicial,0) <> 0 THEN
               nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0))  * nPorcInicial / 100 * NVL(nFact,0)/100;
               nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) * nPorcInicial / 100 *  NVL(nFact,0)/100;
               nMtoComisiPag       := NVL(nMtoComisiPag,0)       + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100) * nPorcInicial / 100 )* NVL(nFact,0)/100;
               nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + ((NVL(X.PrimaMoneda,0)* X.PorcComis / 100) * nPorcInicial / 100)* NVL(nFact,0)/100;
            ELSE
               nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local    - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) / nNumPagos * NVL(nFact,0)/100;
               nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda   - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) /nNumPagos* NVL(nFact,0)/100;
               nMtoComisiPag       := nMtoComisiPag              + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100) / nNumPagos * NVL(nFact,0)/100;
               nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100) / nNumPagos * NVL(nFact,0)/100;
            END IF;
            nPrimaRest           := NVL(nPrimaRest,0)     + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local + NVL(nRec_Local,0) - NVL(nDesc_Local,0) * NVL(nFact,0)/100) - NVL(nMtoPago,0);
            nMtoComisiRest       := NVL(nMtoComisiRest,0) + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100 * NVL(nFact,0)/100) -  NVL(nMtoComisiPag,0));
            nTotPrimas           := NVL(nTotPrimas,0) * NVL(nFact,0)/100 + NVL(nMtoPago,0);
            nMtoComisi           := NVL(nMtoComisi,0)  + NVL(nMtoComisiPag,0);

            nPrimaRestMoneda     := NVL(nPrimaRestMoneda,0)     + (NVL(X.PrimaMoneda,0)  + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0) * NVL(nFact,0)/100) - NVL(nMtoPagoMoneda,0);
            nMtoComisiMonedaRest := NVL(nMtoComisiMonedaRest,0) + ((NVL(X.PrimaMoneda,0) * X.PorcComis / 100) -   NVL(nMtoComisiMonedaPag,0))* NVL(nFact,0)/100;
            nMtoComisiMoneda     := NVL(nMtoComisiMoneda,0)     + NVL(nMtoComisiMonedaPag,0);
            nTotPrimasMoneda     := NVL(nTotPrimasMoneda,0)* NVL(nFact,0)/100   + NVL(nMtoPagoMoneda,0);

            nPrimaMoneda         := NVL(nPrimaMoneda,0) + NVL(X.PrimaMoneda,0)* NVL(nFact,0)/100;
            nPrimaLocal          := NVL(nPrimaLocal,0)  + NVL(X.PrimaLocal,0)* NVL(nFact,0)/100;
            nMtoComiL            := NVL(nMtoComiL,0)    + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100)* NVL(nFact,0)/100;
            nMtoComisiM          := NVL(nMtoComisiM,0)  + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100)* NVL(nFact,0)/100;
         END LOOP;
         nPrimaRest           := NVL(nPrimaLocal,0)  - NVL(nMtoPago,0);
         nPrimaRestMoneda     := NVL(nPrimaMoneda,0) - NVL(nMtoPagoMoneda,0);
         nMtoComisiRest       := NVL(nMtoComiL,0)    - NVL(nMtoComisiPag,0);
         nMtoComisiMonedaRest := NVL(nMtoComisiM,0)  - NVL(nMtoComisiMonedaPag,0);

         nMtoT                := 0;

      --   FOR NP IN 1..nNumPagos LOOP
         NP := nCuota;
     -- nNumPagos := 12;
         BEGIN
            IF nFrecPagos NOT IN (15,7) THEN
               SELECT TRUNC(NVL(ADD_MONTHS(MAX(FECVENC),1),SYSDATE))
                 INTO dFecPago
                 FROM FACTURAS
                WHERE IdPoliza = nIdPoliza
                  AND IdetPol  = nIdetPol
                  AND CodCia   = pCodCia;
            ELSE
               SELECT TRUNC(NVL(MAX(FECVENC),SYSDATE))+ nFrecPagos
                 INTO dFecPago
                 FROM FACTURAS
                WHERE IdPoliza = nIdPoliza
                  AND IdetPol  = nIdetPol
                  AND CodCia   = pCodCia;
            END IF;
            -- Valida si es realmente el primer pago o pagos posteriores
            IF dFecPago = TRUNC(SYSDATE) THEN
               cPrimerFact := 'S';
            ELSE
               cPrimerFact := 'N';
            END IF;
         END;
            IF NP > 1 THEN
               nMtoPago            := NVL(nPrimaRest,0)     / (nNumPagos - 1);
               nMtoComisiPag       := NVL(nMtoComisiRest,0) / (nNumPagos - 1);
               nTotPrimas          := NVL(nTotPrimas,0) + NVL(nMtoPago,0);
               nMtoComisi          := NVL(nMtoComisi,0) + NVL(nMtoComisiPag,0);
               IF nFrecPagos NOT IN (15,7) THEN
                  dFecPago         := ADD_MONTHS(dFecPago,nFrecPagos);
               ELSE
                  dFecPago         := dFecPago + nFrecPagos;
               END IF;
               nMtoPagoMoneda      := NVL(nPrimaRestMoneda,0)     / (nNumPagos - 1);
               nTotPrimasMoneda    := NVL(nTotPrimasMoneda,0)     +  NVL(nMtoPagoMoneda,0);
               nMtoComisiMonedaPag := NVL(nMtoComisiMonedaRest,0) / (nNumPagos - 1);
               nMtoComisiMoneda    := NVL(nMtoComisiMoneda,0) + NVL(nMtoComisiMonedaPag,0);
            END IF;
 --IF OC_generales.VALIDA_FECHA(dFecPago) = 'S' THEN
            -- LARPLA
            nIdFactura := OC_FACTURAS.INSERTAR(nIdPoliza,           nIdetPol,       nCodCliente, dFecPago, 
                                               nMtoPago,            nMtoPagoMoneda, nIdEndoso,   nMtoComisiPag, 
                                               nMtoComisiMonedaPag, NP,             nTasaCambio, nCod_Agente, 
                                               nCodTipoDoc,         pCodCia,        cCodMoneda,  J.CodResPago, 
                                               nTransa,             cIndFactElectronica);

            FOR W IN CPTO_PRIMAS_Q LOOP
               nFactor := (W.Prima_Local /nNumPagos) / NVL(nPrimaLocal,0);
               OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
               OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
            END LOOP;

            nTotAsistLocal  := 0;
            nTotAsistMoneda := 0;
            FOR K IN CPTO_ASIST_Q LOOP
               nAsistRestLocal  := 0;
               nAsistRestMoneda := 0;
               IF NVL(nPorcInicial,0) <> 0 THEN
                  nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) * nPorcInicial / 100) * NVL(nFact,0)/100;
                  nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) * nPorcInicial / 100) * NVL(nFact,0)/100;
               ELSE
                  nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) / nNumPagos) * NVL(nFact,0)/100;
                  nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) / nNumPagos) * NVL(nFact,0)/100;
               END IF;
               /*nAsistRestLocal  := NVL(nAsistRestLocal,0) + (NVL(K.MontoAsistLocal,0) * NVL(nFact,0)/100) - nMtoAsistLocal;
               nAsistRestMoneda := NVL(nAsistRestMoneda,0) + (NVL(K.MontoAsistMoneda,0) * NVL(nFact,0)/100) - nMtoAsistMoneda;
               IF NP > 1 THEN
                  nMtoAsistLocal  := (NVL(nAsistRestLocal,0) / (nNumPagos - 1));
                  nMtoAsistMoneda := (NVL(nAsistRestMoneda,0) / (nNumPagos - 1));
               END IF;*/
               nTotAsistLocal  := NVL(nTotAsistLocal,0) + NVL(nMtoAsistLocal,0);
               nTotAsistMoneda := NVL(nTotAsistMoneda,0) + NVL(nMtoAsistMoneda,0);
               OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
               OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
            END LOOP;

            nMtoT := nMtoT + nMtoPago;--NVL(nTotAsistLocal,0);

            PROC_COMISIONPOL (nIdPoliza, NULL, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFactura,
                              nMtoComisiPag/nNumCert, nMtoComisiMonedaPag/nNumCert, nTasaCambio);

            -- Distribuye la comision por agente.
            FOR Y IN CPTO_PLAN_Q LOOP
               BEGIN
                  SELECT 'S'
                    INTO cGraba
                    FROM RAMOS_CONCEPTOS_PLAN R
                   WHERE R.CodPlanPago = cCodPlanPago
                     AND R.CodCpto     = Y.CodCpto
                     AND R.CodCia      = nCodCia
                     AND R.CodEmpresa  = nCodEmpresa
                     AND EXISTS   (SELECT 1
                                     FROM DETALLE_POLIZA D, POLIZAS P
                                    WHERE D.IdPoliza   = P.IdPoliza
                                      AND D.IdTipoSeg  = R.IdTipoSeg
                                      AND P.StsPoliza IN ('SOL','XRE')
                                      AND P.IdPoliza   = nIdPoliza);
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     cGraba := 'N';
                  WHEN TOO_MANY_ROWS THEN
                     cGraba := 'S';
               END;

               IF cGraba = 'S' THEN
                  IF Y.IndRangosTipseg = 'S' THEN
                     IF cIndCalcDerechoEmis = 'S' THEN
                        OC_CATALOGO_CONCEPTOS_RANGOS.VALOR_CONCEPTO(nCodCia, nCodEmpresa, Y.CodCpto, cIdTipoSeg,
                                                                    nIdPoliza, nIdetPol, nIdEndoso, nMtoCpto, nPorcCpto);
                        IF OC_DETALLE_FACTURAS.EXISTE_CONCEPTO(nCodCia, nIdPoliza, nTransa, Y.CodCpto) = 'N' THEN
                           IF NVL(nMtoCpto,0) = 0 AND NVL(nPorcCpto,0) = 0 THEN
                              nMtoCpto  := Y.MtoCpto;
                              nPorcCpto := Y.PorcCpto;
                           END IF;
                        ELSE
                           nMtoCpto  := 0;
                           nPorcCpto := 0;
                        END IF;
                     ELSE
                        nMtoCpto  := 0;
                        nPorcCpto := 0;
                     END IF;
                  ELSE
                     nMtoCpto  := Y.MtoCpto;
                     nPorcCpto := Y.PorcCpto;
                  END IF;

                  IF Y.Aplica = 'P' THEN
                     IF NVL(nMtoCpto,0) <> 0 AND cPrimerFact = 'S' THEN --NP = 1 THEN
                        nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                     ELSIF cPrimerFact = 'S' THEN
                        nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                        nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                     ELSE
                        nMtoDet       := 0;
                        nMtoDetMoneda := 0;
                     END IF;
                     IF NVL(nMtoDet,0) != 0 THEN
                        OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                        nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                     END IF;
                  ELSIF Y.Aplica = 'T' THEN
                     IF NVL(nMtoCpto,0) <> 0 THEN
                        nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                     ELSE
                        nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                        nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                     END IF;
                     IF NVL(nMtoDet,0) != 0 THEN
                        OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                        nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                     END IF;
                  END IF;
                  nMtoT := nMtoT + nMtoDet;
               END IF;
            END LOOP;
         --   END IF;
            OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
        -- END LOOP;

         IF (NVL(nPrimaLocal,0)+ nMtoRecD_Local - nMtoDescD_Local +
             NVL(nRec_Local,0) - NVL(nDesc_Local,0)) <> NVL(nTotPrimas,0) THEN
            nDifer       := (NVL(nPrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local   +
                             NVL(nRec_Local,0)  - NVL(nDesc_Local,0)) - NVL(nTotPrimas,0);
            nDiferMoneda := (NVL(nPrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda  +
                             NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) - NVL(nTotPrimasMoneda,0);
            nDiferC      :=  NVL(nMtoComiL,0)   - NVL(nMtoComisi,0);
            nDiferCMon   :=  NVL(nMtoComisiM,0) - NVL(nMtoComisiMoneda,0);

            PROC_COMISIONPOL (nIdPoliza, NULL, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFactura,
                              nDiferC/nNumCert, nDiferCMon/nNumCert, nTasaCambio);

            OC_DETALLE_FACTURAS.ACTUALIZA_DIFERENCIA(nIdFactura, nDifer, nDiferMoneda);

            OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);

            UPDATE FACTURAS
               SET MtoComisi_Local   = MtoComisi_Local   + NVL(nDiferC,0),
                   MtoComisi_Moneda  = MtoComisi_Moneda  + NVL(nDiferCMon,0)
             WHERE IdFactura = nIdFactura;
         END IF;
         OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
      END LOOP;
      OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'FAC', 'FACTURAS',
                                   nIdPoliza, nIdetPol, NULL, NULL, nMtoT);
      OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'COM', 'COMISIONES',
                                   nIdPoliza, nIdetPol, NULL, NULL, nMtoDet);
   END IF;
   BEGIN
      SELECT Contabilidad_Automatica
        INTO cContabilidad_Automatica
        FROM EMPRESAS
       WHERE CodCia = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cContabilidad_Automatica := 'N';
   END;
   IF cContabilidad_Automatica = 'S' THEN
      PROC_MOVCONTA(nCodCia, nIdPoliza, cCodMoneda, 'EMI');
   END IF;
END PROC_EMITE_FACT_MENSUAL;

PROCEDURE PROC_EMITE_FACT_PERIODO(nIdPoliza NUMBER, nIdEndoso NUMBER, pCodCia NUMBER, nTransa NUMBER,nCuota NUMBER) IS
nIdFactura               FACTURAS.IdFactura%TYPE;
nNumPagos                PLAN_DE_PAGOS.NumPagos%TYPE;
nFrecPagos               PLAN_DE_PAGOS.FrecPagos%TYPE;
nPorcInicial             PLAN_DE_PAGOS.PorcInicial%TYPE;
nCodCliente              POLIZAS.CodCliente%TYPE;
cIdTipoSeg               DETALLE_POLIZA.IdTipoSeg%TYPE;
nTotPrimas               DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDifer                   DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDiferMoneda             DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoDet                  DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoDetMoneda            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoTotal                DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoTotalMoneda          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cCodMoneda               POLIZAS.Cod_Moneda%TYPE;
nPrimaNetaMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoPagoMoneda           FACTURAS.Monto_Fact_Moneda%TYPE;
cCodMonedaLocal          EMPRESAS.Cod_Moneda%TYPE;
nPrimaRestMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoComisiMoneda         FACTURAS.MtoComisi_Local%TYPE;
nTotPrimasMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nCodCia                  POLIZAS.CodCia%TYPE;
nCodEmpresa              POLIZAS.CodEmpresa%TYPE;
cCodPlanPago             DETALLE_POLIZA.CodPlanPago%TYPE;
nTasaCambio              DETALLE_POLIZA.Tasa_Cambio%TYPE;
nMtoCpto                 CONCEPTOS_PLAN_DE_PAGOS.MtoCpto%TYPE;
nPorcCpto                CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
cAplica                  CONCEPTOS_PLAN_DE_PAGOS.Aplica%TYPE;
Dummy                    NUMBER(5);
dFecPago                 DATE;
nMtoPago                 NUMBER(18,2);
nMtoComisi               NUMBER(18,2);
nPrimaRest               NUMBER(18,2);
dFecHoy                  DATE;
cGraba                   VARCHAR2(1);
nCod_Agente              AGENTES_DETALLES_POLIZAS.Cod_Agente%TYPE;
--
nMtoRecD_Local           DETALLE_RECARGO.Monto_Local%TYPE;
nMtoRecD_Moneda          DETALLE_RECARGO.Monto_Moneda%TYPE;
nMtoDescD_Local          DETALLE_DESCUENTO.Monto_Local%TYPE;
nMtoDescD_Moneda         DETALLE_DESCUENTO.Monto_Moneda%TYPE;
--
nMtoRec_Local            RECARGOS.Monto_Local%TYPE;
nMtoRec_Moneda           RECARGOS.Monto_Moneda%TYPE;
nMtoDesc_Local           DESCUENTOS.Monto_Local%TYPE;
nMtoDesc_Moneda          DESCUENTOS.Monto_Moneda%TYPE;
nPrimaTotalM             DETALLE_POLIZA.Prima_Moneda%TYPE;
nPrimaTotalL             DETALLE_POLIZA.Prima_Local%TYPE;
nFactor                  NUMBER (14,8);
nRec_Local               RECARGOS.Monto_Local%TYPE ;
nRec_Moneda              RECARGOS.Monto_Moneda%TYPE;
nDesc_Local              DESCUENTOS.Monto_Local%TYPE;
nDesc_Moneda             DESCUENTOS.Monto_Moneda%TYPE;
cCodPlanPagoPol          POLIZAS.CodPlanPago%TYPE;
--
nPorcComis               DETALLE_POLIZA.PorcComis%TYPE;
nNumCert                 DETALLE_POLIZA.IdetPol%TYPE;
nPrimaLocal              NUMBER(18,2);
nPrimaMoneda             NUMBER(18,2);
nIdTransac               NUMBER(14,0);
nMtoComisiRest           NUMBER(18,2);
nMtoComisiMonedaRest     NUMBER(18,2);
nMtoComisiPag            NUMBER(18,2);
nMtoComisiMonedaPag      NUMBER(18,2);
nMtoComiTot              NUMBER(18,2);
nMtoComisiMonedaTot      NUMBER(18,2);
nMtoComiL                NUMBER(18,2);
nMtoComisiM              NUMBER(18,2);
nDiferC                  DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDiferCMon               DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cRespPol                 VARCHAR2(1):='N';
cRespDet                 VARCHAR2(1):='N';
nPorcT                   NUMBER(18,2);
nFact                    NUMBER(18,2);
nCodTipoDoc              TIPO_DE_DOCUMENTO.CodTipoDoc%TYPE;
nIdetPol                 DETALLE_POLIZA.IdetPol%TYPE; --:= 1;
cContabilidad_Automatica EMPRESAS.Contabilidad_Automatica%TYPE;
nIdTranc                 TRANSACCION.idtransaccion%TYPE;
nMtoT                    FACTURAS.monto_fact_local%TYPE := 0;
NP                       NUMBER(10);
nMes                     NUMBER(10);
nMontoAdic               NUMBER(18,2);
nMtoAsistLocal           ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nMtoAsistMoneda          ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
nAsistRestLocal          ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nAsistRestMoneda         ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
nTotAsistLocal           ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nTotAsistMoneda          ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
cPrimerFact              VARCHAR2(1) := 'N';
cStsPoliza               POLIZAS.StsPoliza%TYPE;
cIndFactElectronica      POLIZAS.IndFactElectronica%TYPE;
cIndCalcDerechoEmis      POLIZAS.IndCalcDerechoEmis%TYPE;
fFecfinvig               FACTURAS.FECFINVIG%TYPE;      -- ICOFINVIG

CURSOR DET_POL_Q IS
   SELECT D.Prima_Local PrimaLocal, D.Prima_Moneda PrimaMoneda, D.CodPlanPago, D.PorcComis,D.StsDetalle,
          P.FecIniVig, P.FecEmision, D.IDetPol, D.Tasa_Cambio, D.IdTipoSeg, D.FecIniVig FecIniCert,P.StsPoliza
     FROM DETALLE_POLIZA D, POLIZAS P
    WHERE D.Prima_Local > 0
      AND D.IdPoliza    = P.IdPoliza
      AND D.StsDetalle IN ('EMI','SOL','XRE') -- ('EMI','INC','XRE','SOL')
      AND P.IdPoliza    = nIdPoliza;

CURSOR CPTO_PLAN_Q IS
   SELECT CP.CodCpto, CP.PorcCpto, CP.Aplica, CP.MtoCpto,
          CC.IndRangosTipseg
     FROM CONCEPTOS_PLAN_DE_PAGOS CP, CATALOGO_DE_CONCEPTOS CC
    WHERE CC.IndCptoAjuste = 'N'
      AND CC.IndCptoPrimas = 'N'
      AND CC.CodConcepto   = CP.CodCpto
      AND CC.CodCia        = CP.CodCia
      AND CP.CodCia        = pCodCia
      AND CP.CodEmpresa    = nCodEmpresa
      AND CP.CodPlanPago   = cCodPlanPago
      AND EXISTS (SELECT 'S'
                    FROM RAMOS_CONCEPTOS_PLAN
                   WHERE CodCia      = CP.CodCia
                     AND CodEmpresa  = CP.CodEmpresa
                     AND IdTipoSeg  IN (SELECT IdTipoSeg
                                          FROM DETALLE_POLIZA
                                         WHERE IdPoliza  = nIdPoliza)
                     AND CodCpto     = CP.CodCpto
                     AND CodPlanPago = CP.CodPlanPago)
    ORDER BY CP.Prioridad;

CURSOR RESP_PAGO IS
  SELECT R.CodResPago
    FROM RESPONSABLE_PAGO_DET R
   WHERE R.IdPoliza    = nIdPoliza
     AND R.CodCia      = pCodCia
     AND R.CodEmpresa  = nCodEmpresa
   GROUP BY R.CodResPago;

CURSOR CPTO_PRIMAS_Q IS
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERT_ACT C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert   = C.CodCobert
      AND CS.PlanCob     = C.PlanCob
      AND CS.IdTipoSeg   = C.IdTipoSeg
      AND CS.CodEmpresa  = C.CodEmpresa
      AND CS.CodCia      = C.CodCia
      AND C.StsCobertura IN ('EMI','SOL','XRE')
      AND C.IdPoliza     = nIdPoliza
      AND C.CodCia       = pCodCia
    GROUP BY CS.CodCpto
      UNION ALL
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERT_ACT_ASEG C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert   = C.CodCobert
      AND CS.PlanCob     = C.PlanCob
      AND CS.IdTipoSeg   = C.IdTipoSeg
      AND CS.CodEmpresa  = C.CodEmpresa
      AND CS.CodCia      = C.CodCia
  --    AND C.IDetPol     = nIdetPol
      AND C.StsCobertura IN ('EMI','SOL','XRE')
      AND C.IdPoliza     = nIdPoliza
      AND C.CodCia       = pCodCia
    GROUP BY CS.CodCpto;
CURSOR CPTO_ASIST_Q IS
   SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
          SUM(A.MontoAsistMoneda) MontoAsistMoneda
     FROM ASISTENCIAS_DETALLE_POLIZA A, DETALLE_POLIZA D, ASISTENCIAS T
    WHERE T.CodAsistencia  = A.CodAsistencia
      AND D.IDetPol        = A.IDetPol
      AND D.IdPoliza       = A.IdPoliza
      AND D.CodCia         = A.CodCia
      AND A.StsAsistencia IN ('EMITID','SOLICI','XRENOV')
      AND A.IDetPol        = nNumCert
      AND A.IdPoliza       = nIdPoliza
      AND A.CodCia         = pCodCia
    GROUP BY T.CodCptoServicio
  UNION ALL
   SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
          SUM(A.MontoAsistMoneda) MontoAsistMoneda
     FROM ASISTENCIAS_ASEGURADO A, DETALLE_POLIZA D, ASISTENCIAS T
    WHERE T.CodAsistencia  = A.CodAsistencia
      AND D.IDetPol        = A.IDetPol
      AND D.IdPoliza       = A.IdPoliza
      AND D.CodCia         = A.CodCia
      AND A.StsAsistencia IN ('EMITID','SOLICI','XRENOV')
      AND A.IDetPol        = nNumCert
      AND A.IdPoliza       = nIdPoliza
      AND A.CodCia         = pCodCia
    GROUP BY T.CodCptoServicio;
BEGIN
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
  BEGIN
      SELECT CodCliente, Cod_Moneda, CodCia, CodEmpresa,
             CodPlanPago, IndFactElectronica, IndCalcDerechoEmis
        INTO nCodCliente, cCodMoneda, nCodCia, nCodEmpresa,
             cCodPlanPagoPol, cIndFactElectronica, cIndCalcDerechoEmis
        FROM POLIZAS
       WHERE IdPoliza = nIdPoliza;
    END;
    BEGIN
       SELECT Cod_Moneda
         INTO cCodMonedaLocal
         FROM EMPRESAS
        WHERE CodCia = nCodCia;
  END;
  BEGIN
     SELECT SUM(D.Prima_Local) PrimaLocal, SUM(D.Prima_Moneda) PrimaMoneda, COUNT(IdetPol)
       INTO nPrimaTotalL, nPrimaTotalM, nNumCert
       FROM DETALLE_POLIZA D, POLIZAS P
      WHERE D.IdPoliza  = P.IdPoliza
        AND D.StsDetalle IN ('EMI','SOL','XRE')--('EMI','SOL')
        AND P.IdPoliza  = nIdPoliza;
   END;
--dbms_output.put_line('nNumCert:'||nNumCert||''||nIdPoliza);
   BEGIN
      SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
        INTO nMtoRec_Local, nMtoRec_Moneda
        FROM RECARGOS
       WHERE IdPoliza = nIdPoliza
         AND Estado   = 'ACT';
   EXCEPTION
      WHEN OTHERS THEN
         nMtoRec_Local  := 0;
         nMtoRec_Moneda := 0;
   END;
   BEGIN
      SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
        INTO nMtoDesc_Local, nMtoDesc_Moneda
        FROM DESCUENTOS
       WHERE IdPoliza  = nIdPoliza
         AND Estado    = 'ACT';
   EXCEPTION
      WHEN OTHERS THEN
         nMtoDesc_Local  := 0;
         nMtoDesc_Moneda := 0;
   END;
   -- Características del Plan de Pago
   BEGIN
      SELECT NumPagos, FrecPagos, PorcInicial
        INTO nNumPagos, nFrecPagos, nPorcInicial
        FROM PLAN_DE_PAGOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodPlanPago = cCodPlanPagoPol;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'No Existe Plan de Pagos '||cCodPlanPagoPol);
   END;
   BEGIN
      SELECT 'S'
        INTO cRespPol
        FROM RESPONSABLE_PAGO_POL
       WHERE StsResPago = 'ACT'
         AND CodCia     = pCodCia
         AND IdPoliza   = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cRespPol := 'N';
      WHEN TOO_MANY_ROWS THEN
         cRespPol := 'S';
   END;
   IF cRespPol = 'S' AND FUNC_VALIDA_RESP_POL (nIdPoliza,pCodCia) = 'S' THEN
      PROC_INSERT_RESP_D (nIdPoliza,pCodCia);
   END IF;
   BEGIN
      SELECT 'S'
        INTO cRespDet
        FROM RESPONSABLE_PAGO_DET R
       WHERE R.IdPoliza    = nIdPoliza
         AND R.CodCia      = pCodCia
         AND R.CodEmpresa  = nCodEmpresa;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cRespDet:='N';
      WHEN TOO_MANY_ROWS THEN
         cRespDet:='S';
   END;

   IF cRespPol = 'N' AND cRespDet = 'N' THEN
      FOR X IN DET_POL_Q LOOP
         nIdetPol   := X.IdetPol;
         cIdTipoSeg := X.IdTipoSeg;
         BEGIN
            SELECT Cod_Agente
              INTO nCod_Agente
              FROM AGENTES_DETALLES_POLIZAS
             WHERE IdPoliza      = nIdPoliza
               AND IdetPol       = X.IdetPol
               AND IdTipoSeg     = X.IdTipoSeg
               AND Ind_Principal = 'S';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR (-20100,'No Existe un Agente Definido para el Tipo de Seguro '||X.IdTipoSeg);
            WHEN TOO_MANY_ROWS THEN
               RAISE_APPLICATION_ERROR (-20100,'Existe Mas de un Agente Definido como Principal');
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR (-20100,'Existe un error de otros');
         END;

         cCodPlanPago := X.CodPlanPago;
         nMtoT        := 0;

         OC_DETALLE_TRANSACCION.CREA (nTransa,nCodCia,nCodEmpresa,7,'CER', 'DETALLE_POLIZA',
                                      nIdPoliza, X.IdetPol, NULL, NULL, X.PrimaLocal);

         IF nMtoRec_Local != 0 OR nMtoRec_Moneda != 0 OR nMtoDesc_Local != 0 OR nMtoDesc_Moneda != 0 THEN
            nFactor      := (X.PrimaLocal    / NVL(nPrimaTotalL,0)) * 100;
            nRec_Local   := (nMtoRec_Local  * nFactor) / 100;
            nRec_Moneda  := (nMtoRec_Moneda * nFactor) / 100;
            nDesc_Local  := (nMtoDesc_Local * nFactor) / 100;
            nDesc_Moneda := (nMtoDesc_Moneda * nFactor)/ 100;
         END IF;
         IF nIdEndoso = 0 THEN
            nTasaCambio := X.Tasa_Cambio;
         ELSE
            nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
         END IF;
         -- Fecha del Primer Pago
         IF nCuota = 1 THEN
            dFecPago := X.FecIniVig;
         END IF;
/*        IF X.FecIniVig > X.FecEmision THEN
            dFecPago := X.FecIniVig;
         ELSE
            dFecPago := X.FecEmision;
         END IF;*/
         -- Monto del Primer Pago
         nTotPrimas       := 0;
         nTotPrimasMoneda := 0;
         nMtoComisi       := 0;
         nMtoComisiMoneda := 0;
         BEGIN
            SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
              INTO nMtoRecD_Local, nMtoRecD_Moneda
              FROM DETALLE_RECARGO
             WHERE IdPoliza = nIdPoliza
               AND IDetPol  = X.IDetPol
               AND Estado   = 'ACT';
         EXCEPTION
            WHEN OTHERS THEN
               nMtoRecD_Local  := 0;
               nMtoRecD_Moneda := 0;
         END;
         BEGIN
            SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
              INTO nMtoDescD_Local, nMtoDescD_Moneda
              FROM DETALLE_DESCUENTO
             WHERE IdPoliza  = nIdPoliza
               AND IDetPol   = X.IDetPol
               AND Estado    = 'ACT';
         EXCEPTION
            WHEN OTHERS THEN
               nMtoDescD_Local  := 0;
               nMtoDescD_Moneda := 0;
         END;
         IF NVL(nPorcInicial,0) <> 0 THEN
            nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0))  * nPorcInicial / 100  ;
            nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) * nPorcInicial / 100 ;
            nMtoComisiPag       := NVL(nMtoComisiPag,0)       + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100) * nPorcInicial / 100 );
            nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + ((NVL(X.PrimaMoneda,0)* X.PorcComis / 100) * nPorcInicial / 100) ;
         ELSE
            nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local    - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) / nNumPagos  ;
            nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda   - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) /nNumPagos ;
            nMtoComisiPag       := nMtoComisiPag              + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100) / nNumPagos ;
            nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100) / nNumPagos ;
         END IF;
         IF X.StsPoliza = 'EMI' THEN
            IF nFrecPagos NOT IN (15,7) THEN
               BEGIN
                  SELECT TRUNC(NVL(ADD_MONTHS(MAX(FECVENC),nFrecPagos),SYSDATE))
                    INTO dFecPago
                    FROM FACTURAS
                   WHERE IdPoliza = nIdPoliza
                     AND IDetPol  = X.IDetPol
                     AND IdEndoso = 0
                     AND CodCia   = pCodCia;
               END;
            ELSE
               BEGIN
                  SELECT TRUNC(NVL(MAX(FECVENC),SYSDATE))+nFrecPagos
                    INTO dFecPago
                    FROM FACTURAS
                   WHERE IdPoliza = nIdPoliza
                     AND IDetPol  = X.IDetPol
                     AND IdEndoso = 0
                     AND CodCia   = pCodCia;
               END;
            END IF;
            cPrimerFact := 'N';
         ELSE
            cPrimerFact := 'S';
         END IF;
         IF X.StsDetalle = 'SOL' AND X.StsPoliza = 'EMI' THEN
            nMes := OC_GENERALES.VALIDA_FECHA_FACTURA(X.FecIniCert,dFecPago);
            IF NVL(nMes,0) > 0  THEN
               nMontoAdic := NVL(nMontoAdic,0) + (X.PrimaLocal / 12) * nMes;
            END IF;
         END IF;
         nPrimaRest           := NVL(nPrimaRest,0)           + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) - NVL(nMtoPago,0);
         nMtoComisiRest       := NVL(nMtoComisiRest,0)       + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100 ) -  NVL(nMtoComisiPag,0));
         nTotPrimas           := NVL(nTotPrimas,0)           + NVL(nMtoPago,0);
         nMtoComisi           := NVL(nMtoComisi,0)           + NVL(nMtoComisiPag,0);
         nPrimaRestMoneda     := NVL(nPrimaRestMoneda,0)     + (NVL(X.PrimaMoneda,0)  + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) - NVL(nMtoPagoMoneda,0);
         nMtoComisiMonedaRest := NVL(nMtoComisiMonedaRest,0) + ((NVL(X.PrimaMoneda,0) * X.PorcComis / 100) -   NVL(nMtoComisiMonedaPag,0));
         nMtoComisiMoneda     := NVL(nMtoComisiMoneda,0)     + NVL(nMtoComisiMonedaPag,0);
         nTotPrimasMoneda     := NVL(nTotPrimasMoneda,0)     + NVL(nMtoPagoMoneda,0);
         nPrimaMoneda         := NVL(nPrimaMoneda,0)         + NVL(X.PrimaMoneda,0);
         nPrimaLocal          := NVL(nPrimaLocal,0)          + NVL(X.PrimaLocal,0) ;
         nMtoComiL            := NVL(nMtoComiL,0)            + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100) ;
         nMtoComisiM          := NVL(nMtoComisiM,0)          + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100) ;
      END LOOP;

      nPrimaRest           := NVL(nPrimaLocal,0)  - NVL(nMtoPago,0);
      nPrimaRestMoneda     := NVL(nPrimaMoneda,0) - NVL(nMtoPagoMoneda,0);
      nMtoComisiRest       := NVL(nMtoComiL,0)    - NVL(nMtoComisiPag,0);
      nMtoComisiMonedaRest := NVL(nMtoComisiM,0)  - NVL(nMtoComisiMonedaPag,0);
    --  FOR NP IN 1..nNumPagos LOOP
       NP := nCuota;
    --   nNumPagos := 12;
         IF NP > 1 THEN
            nMtoPago            := NVL(nPrimaRest,0)     / (nNumPagos - 1) + NVL(nMontoAdic,0);
            nMtoComisiPag       := NVL(nMtoComisiRest,0) / (nNumPagos - 1);
            nTotPrimas          := NVL(nTotPrimas,0) + NVL(nMtoPago,0) + NVL(nMontoAdic,0);
            nMtoComisi          := NVL(nMtoComisi,0) + NVL(nMtoComisiPag,0);

            nMtoPagoMoneda      := NVL(nPrimaRestMoneda,0)     / (nNumPagos - 1) + NVL(nMontoAdic,0);
            nTotPrimasMoneda    := NVL(nTotPrimasMoneda,0)     +  NVL(nMtoPagoMoneda,0) + NVL(nMontoAdic,0);
            nMtoComisiMonedaPag := NVL(nMtoComisiMonedaRest,0) / (nNumPagos - 1);
            nMtoComisiMoneda    := NVL(nMtoComisiMoneda,0) + NVL(nMtoComisiMonedaPag,0);
         END IF;

       --  dFecPago := trunc(SYSDATE);
      IF OC_GENERALES.VALIDA_FECHA(dFecPago) = 'S' THEN
            -- LARPLA
            nIdFactura := OC_FACTURAS.INSERTAR(nIdPoliza,          /*nIDetPol*/1,  nCodCliente, dFecPago, 
                                              nMtoPago,            nMtoPagoMoneda, nIdEndoso,   nMtoComisiPag, 
                                              nMtoComisiMonedaPag, NP,             nTasaCambio, nCod_Agente, 
                                              nCodTipoDoc,         pCodCia,        cCodMoneda,  NULL, 
                                              nTransa,             cIndFactElectronica);

            FOR W IN CPTO_PRIMAS_Q LOOP
              --nFactor := W.Prima_Local / NVL(nMtoPago,0);
              --nFactor := ((W.Prima_Local  /nNumPagos) /*+ NVL(nMontoAdic,0)*/)/ NVL(nMtoPago,0);
              --nFactor := ((W.Prima_Local  /nNumPagos) /*+ NVL(nMontoAdic,0)*/)/ (NVL(nMtoPago,0) - NVL(nMontoAdic,0));
              --nFactor := ((W.Prima_Local  /nNumPagos) /*+ NVL(nMontoAdic,0)*/)/ (NVL(nPrimaLocal,0) - NVL(nMontoAdic,0));
              nFactor := W.Prima_Local / NVL(nPrimaLocal,0);
              OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
              OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
            END LOOP;

            nTotAsistLocal  := 0;
            nTotAsistMoneda := 0;
            FOR K IN CPTO_ASIST_Q LOOP
               nAsistRestLocal  := 0;
               nAsistRestMoneda := 0;
               IF NVL(nPorcInicial,0) <> 0 THEN
                  nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) * nPorcInicial / 100);
                  nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) * nPorcInicial / 100);
               ELSE
                  nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) / nNumPagos);
                  nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) / nNumPagos);
               END IF;
               /*nAsistRestLocal  := NVL(nAsistRestLocal,0) + NVL(K.MontoAsistLocal,0) - nMtoAsistLocal;
               nAsistRestMoneda := NVL(nAsistRestMoneda,0) + NVL(K.MontoAsistMoneda,0) - nMtoAsistMoneda;
               IF NP > 1 THEN
                  nMtoAsistLocal  := (NVL(nAsistRestLocal,0) / (nNumPagos - 1));
                  nMtoAsistMoneda := (NVL(nAsistRestMoneda,0) / (nNumPagos - 1));
               END IF;*/
               nTotAsistLocal  := NVL(nTotAsistLocal,0) + NVL(nMtoAsistLocal,0);
               nTotAsistMoneda := NVL(nTotAsistMoneda,0) + NVL(nMtoAsistMoneda,0);
               OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
               OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
            END LOOP;

         nMtoT := nMtoT + nMtoPago; -- + NVL(nTotAsistLocal,0);
         -- Genera comisiones por agente por Poliza
         PROC_COMISIONPOL (nIdPoliza, NULL, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFactura,
                           nMtoComisiPag/nNumCert, nMtoComisiMonedaPag/nNumCert, nTasaCambio);

        -- Distribuye la comision por agente.
         FOR Y IN CPTO_PLAN_Q LOOP
            BEGIN
               SELECT 'S'
                 INTO cGraba
                 FROM RAMOS_CONCEPTOS_PLAN R
                WHERE R.CodPlanPago = cCodPlanPago
                  AND R.CodCpto     = Y.CodCpto
                  AND R.CodCia      = nCodCia
                  AND R.CodEmpresa  = nCodEmpresa
                  AND EXISTS   (SELECT 1
                                  FROM DETALLE_POLIZA D, POLIZAS P
                                 WHERE D.IdPoliza  = P.IdPoliza
                                   AND D.IdTipoSeg = R.IdTipoSeg
                                   AND P.StsPoliza IN ('EMI','SOL','XRE')
                                   AND P.IdPoliza  = nIdPoliza);
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cGraba := 'N';
               WHEN TOO_MANY_ROWS THEN
                  cGraba := 'S';
            END;

            IF cGraba = 'S' THEN
               IF Y.IndRangosTipseg = 'S' THEN
                  IF cIndCalcDerechoEmis = 'S' THEN
                     OC_CATALOGO_CONCEPTOS_RANGOS.VALOR_CONCEPTO(nCodCia, nCodEmpresa, Y.CodCpto, cIdTipoSeg,
                                                                 nIdPoliza, nIdetPol, nIdEndoso, nMtoCpto, nPorcCpto);
                     IF OC_DETALLE_FACTURAS.EXISTE_CONCEPTO(nCodCia, nIdPoliza, nTransa, Y.CodCpto) = 'N' THEN
                        IF NVL(nMtoCpto,0) = 0 AND NVL(nPorcCpto,0) = 0 THEN
                           nMtoCpto  := Y.MtoCpto;
                           nPorcCpto := Y.PorcCpto;
                        END IF;
                     ELSE
                        nMtoCpto  := 0;
                        nPorcCpto := 0;
                     END IF;
                  ELSE
                     nMtoCpto  := 0;
                     nPorcCpto := 0;
                  END IF;
               ELSE
                  nMtoCpto  := Y.MtoCpto;
                  nPorcCpto := Y.PorcCpto;
               END IF;
               IF Y.Aplica = 'P' THEN
                  IF NVL(nMtoCpto,0) <> 0 AND cPrimerFact = 'S' THEN --NP = 1 THEN
                     nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                  ELSIF cPrimerFact = 'S' THEN
                     nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                     nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                  ELSE
                     nMtoDet       := 0;
                     nMtoDetMoneda := 0;
                  END IF;
                  IF NVL(nMtoDet,0) != 0 THEN
                     OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                     OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                     nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                     nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                  END IF;
               ELSIF Y.Aplica = 'T' THEN
                  IF NVL(nMtoCpto,0) <> 0 THEN
                     nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                  ELSE
                     nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                     nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                  END IF;
                  IF NVL(nMtoDet,0) != 0 THEN
                     OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                     OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                     nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                     nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                  END IF;
               END IF;
               nMtoT := nMtoT + nMtoDet;
            END IF;
         END LOOP;
         OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
         OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
      ELSE
         RAISE_APPLICATION_ERROR(-20200,'La Factura Corresponde a la Fecha : '||TO_CHAR(dFecPago,'DD-MM-YYYY')||' ' ||'Posterior al mes corriente, Favor verificar');
      END IF;
    --  END LOOP;
      OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'FAC', 'FACTURAS',
                                   nIdPoliza, nIdetPol, NULL, NULL, nMtoT);
      OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'COM', 'COMISIONES',
                                   nIdPoliza, nIdetPol, NULL, NULL, nMtoComisiPag);
   ELSE
      BEGIN
         SELECT SUM(R.PorcResPago)
           INTO nPorcT
           FROM RESPONSABLE_PAGO_DET R
          WHERE R.IdPoliza    = nIdPoliza
            AND R.CodCia      = nCodCia
            AND R.CodEmpresa  = nCodEmpresa ;
      END;
      FOR J IN RESP_PAGO LOOP
         BEGIN
            SELECT (SUM(PORCRESPAGO)/nPorcT) * 100
              INTO nFact
              FROM RESPONSABLE_PAGO_DET r
             WHERE R.IdPoliza    = nIdPoliza
               AND R.CodCia      = nCodCia
               AND R.CodEmpresa  = nCodEmpresa
               AND R.CodResPago  = J.CodResPago;
         END;
         nMtoPago             := 0;
         nMtoPagoMoneda       := 0;
         nMtoComisiPag        := 0;
         nMtoComisiMonedaPag  := 0;
         nPrimaRest           := 0;
         nMtoComisiRest       := 0;
         nTotPrimas           := 0;
         nMtoComisi           := 0;
         nPrimaRestMoneda     := 0;
         nMtoComisiMonedaRest := 0;
         nMtoComisiMoneda     := 0;
         nTotPrimasMoneda     := 0;
         nPrimaMoneda         := 0;
         nPrimaLocal          := 0;
         nMtoComiL            := 0;
         nMtoComisiM          := 0;
         FOR X IN DET_POL_Q LOOP
            cIdTipoSeg := X.IdTipoSeg;
            cStsPoliza := X.StsPoliza;
            nIdetPol   := X.IdetPol;
            BEGIN
               SELECT Cod_Agente
                 INTO nCod_Agente
                 FROM AGENTES_DETALLES_POLIZAS
                WHERE IdPoliza      = nIdPoliza
                  AND IdetPol       = X.IdetPol
                  AND IdTipoSeg     = X.IdTipoSeg
                  AND Ind_Principal = 'S';
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR (-20100,'No Existe un Agente Definido para el Tipo de Seguro '||X.IdTipoSeg);
               WHEN TOO_MANY_ROWS THEN
                  RAISE_APPLICATION_ERROR (-20100,'Existe Mas de un Agente Definido como Principal');
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR (-20100,'Existe un error de otros');
            END;
            cCodPlanPago := X.CodPlanPago;
            IF nMtoRec_Local != 0 OR nMtoRec_Moneda != 0 OR nMtoDesc_Local != 0 OR nMtoDesc_Moneda != 0 THEN
               nFactor      := (X.PrimaLocal * NVL(nFact,0)/100) / NVL(nPrimaTotalL,0) * 100;
               nRec_Local   := (nMtoRec_Local  * nFactor) / 100;
               nRec_Moneda  := (nMtoRec_Moneda * nFactor) / 100;
               nDesc_Local  := (nMtoDesc_Local * nFactor) / 100;
               nDesc_Moneda := (nMtoDesc_Moneda * nFactor)/ 100;
            END IF;
            IF nIdEndoso = 0 THEN
               nTasaCambio := X.Tasa_Cambio;
            ELSE
               nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
            END IF;

            -- Fecha del Primer Pago Siempre a Inicio de Vigencia
            dFecPago := X.FecIniVig;
            /*IF X.FecIniVig > X.FecEmision THEN
               dFecPago := X.FecIniVig;
            ELSE
               dFecPago := X.FecEmision;
            END IF;*/
                -- Monto del Primer Pago
            nTotPrimas       := 0;
            nTotPrimasMoneda := 0;
            nMtoComisi       := 0;
            nMtoComisiMoneda := 0;
            BEGIN
               SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
                 INTO nMtoRecD_Local, nMtoRecD_Moneda
                 FROM DETALLE_RECARGO
                WHERE IdPoliza = nIdPoliza
                  AND IDetPol  = X.IDetPol
                  AND Estado   = 'ACT';
            EXCEPTION
               WHEN OTHERS THEN
                  nMtoRecD_Local  := 0;
                  nMtoRecD_Moneda := 0;
            END;
            BEGIN
               SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
                 INTO nMtoDescD_Local, nMtoDescD_Moneda
                 FROM DETALLE_DESCUENTO
                WHERE IdPoliza  = nIdPoliza
                  AND IDetPol   = X.IDetPol
                  AND Estado    = 'ACT';
            EXCEPTION
               WHEN OTHERS THEN
                  nMtoDescD_Local  := 0;
                  nMtoDescD_Moneda := 0;
            END;

            IF NVL(nPorcInicial,0) <> 0 THEN
               nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0))  * nPorcInicial / 100 * NVL(nFact,0)/100;
               nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) * nPorcInicial / 100 *  NVL(nFact,0)/100;
               nMtoComisiPag       := NVL(nMtoComisiPag,0)       + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100) * nPorcInicial / 100 )* NVL(nFact,0)/100;
               nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + ((NVL(X.PrimaMoneda,0)* X.PorcComis / 100) * nPorcInicial / 100)* NVL(nFact,0)/100;
            ELSE
               nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local    - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) / nNumPagos * NVL(nFact,0)/100;
               nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda   - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) /nNumPagos* NVL(nFact,0)/100;
               nMtoComisiPag       := nMtoComisiPag              + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100) / nNumPagos * NVL(nFact,0)/100;
               nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100) / nNumPagos * NVL(nFact,0)/100;
            END IF;
            nPrimaRest           := NVL(nPrimaRest,0)     + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local + NVL(nRec_Local,0) - NVL(nDesc_Local,0) * NVL(nFact,0)/100) - NVL(nMtoPago,0);
            nMtoComisiRest       := NVL(nMtoComisiRest,0) + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100 * NVL(nFact,0)/100) -  NVL(nMtoComisiPag,0));
            nTotPrimas           := NVL(nTotPrimas,0) * NVL(nFact,0)/100 + NVL(nMtoPago,0);
            nMtoComisi           := NVL(nMtoComisi,0)  + NVL(nMtoComisiPag,0);

            nPrimaRestMoneda     := NVL(nPrimaRestMoneda,0)     + (NVL(X.PrimaMoneda,0)  + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0) * NVL(nFact,0)/100) - NVL(nMtoPagoMoneda,0);
            nMtoComisiMonedaRest := NVL(nMtoComisiMonedaRest,0) + ((NVL(X.PrimaMoneda,0) * X.PorcComis / 100) -   NVL(nMtoComisiMonedaPag,0))* NVL(nFact,0)/100;
            nMtoComisiMoneda     := NVL(nMtoComisiMoneda,0)     + NVL(nMtoComisiMonedaPag,0);
            nTotPrimasMoneda     := NVL(nTotPrimasMoneda,0)* NVL(nFact,0)/100   + NVL(nMtoPagoMoneda,0);

            nPrimaMoneda         := NVL(nPrimaMoneda,0) + NVL(X.PrimaMoneda,0)* NVL(nFact,0)/100;
            nPrimaLocal          := NVL(nPrimaLocal,0)  + NVL(X.PrimaLocal,0)* NVL(nFact,0)/100;
            nMtoComiL            := NVL(nMtoComiL,0)    + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100)* NVL(nFact,0)/100;
            nMtoComisiM          := NVL(nMtoComisiM,0)  + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100)* NVL(nFact,0)/100;
         END LOOP;
         nPrimaRest           := NVL(nPrimaLocal,0)  - NVL(nMtoPago,0);
         nPrimaRestMoneda     := NVL(nPrimaMoneda,0) - NVL(nMtoPagoMoneda,0);
         nMtoComisiRest       := NVL(nMtoComiL,0)    - NVL(nMtoComisiPag,0);
         nMtoComisiMonedaRest := NVL(nMtoComisiM,0)  - NVL(nMtoComisiMonedaPag,0);

         nMtoT                := 0;

      --   FOR NP IN 1..nNumPagos LOOP
          NP := nCuota;
         IF cStsPoliza = 'EMI' THEN
            IF nFrecPagos NOT IN (15,7) THEN
               BEGIN
                  SELECT TRUNC(NVL(ADD_MONTHS(MAX(FECVENC),nFrecPagos),SYSDATE))
                    INTO dFecPago
                    FROM FACTURAS
                   WHERE IdPoliza = nIdPoliza
                     AND IDetPol  = nIDetPol
                     AND IdEndoso = 0
                     AND CodCia   = pCodCia;
               END;
            ELSE
               BEGIN
                  SELECT TRUNC(NVL(MAX(FECVENC),SYSDATE))+nFrecPagos
                    INTO dFecPago
                    FROM FACTURAS
                   WHERE IdPoliza = nIdPoliza
                     AND IDetPol  = nIDetPol
                     AND IdEndoso = 0
                     AND CodCia   = pCodCia;
               END;
            END IF;
            cPrimerFact := 'N';
         ELSE
            cPrimerFact := 'S';
         END IF;

     -- nNumPagos := 12;
            IF NP > 1 THEN
               nMtoPago            := NVL(nPrimaRest,0)     / (nNumPagos - 1);
               nMtoComisiPag       := NVL(nMtoComisiRest,0) / (nNumPagos - 1);
               nTotPrimas          := NVL(nTotPrimas,0) + NVL(nMtoPago,0);
               nMtoComisi          := NVL(nMtoComisi,0) + NVL(nMtoComisiPag,0);
               IF nFrecPagos NOT IN (15,7) THEN
                  dFecPago         := ADD_MONTHS(dFecPago,nFrecPagos);
               ELSE
                  dFecPago         := dFecPago + nFrecPagos;
               END IF;
               nMtoPagoMoneda      := NVL(nPrimaRestMoneda,0)     / (nNumPagos - 1);
               nTotPrimasMoneda    := NVL(nTotPrimasMoneda,0)     +  NVL(nMtoPagoMoneda,0);
               nMtoComisiMonedaPag := NVL(nMtoComisiMonedaRest,0) / (nNumPagos - 1);
               nMtoComisiMoneda    := NVL(nMtoComisiMoneda,0) + NVL(nMtoComisiMonedaPag,0);
            END IF;
 --IF OC_generales.VALIDA_FECHA(dFecPago) = 'S' THEN
            -- LARPLA
            nIdFactura := OC_FACTURAS.INSERTAR(nIdPoliza,           nIdetPol,       nCodCliente, dFecPago, 
                                               nMtoPago,            nMtoPagoMoneda, nIdEndoso,   nMtoComisiPag, 
                                               nMtoComisiMonedaPag, NP,             nTasaCambio, nCod_Agente, 
                                               nCodTipoDoc,         pCodCia,        cCodMoneda,  J.CodResPago, 
                                               nTransa, cIndFactElectronica);

            FOR W IN CPTO_PRIMAS_Q LOOP
               nFactor := W.Prima_Local / NVL(nPrimaLocal,0);
               OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
               OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
            END LOOP;

            nTotAsistLocal  := 0;
            nTotAsistMoneda := 0;
            FOR K IN CPTO_ASIST_Q LOOP
               nAsistRestLocal  := 0;
               nAsistRestMoneda := 0;
               IF NVL(nPorcInicial,0) <> 0 THEN
                  nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) * nPorcInicial / 100) * NVL(nFact,0)/100;
                  nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) * nPorcInicial / 100) * NVL(nFact,0)/100;
               ELSE
                  nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) / nNumPagos) * NVL(nFact,0)/100;
                  nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) / nNumPagos) * NVL(nFact,0)/100;
               END IF;
               /*nAsistRestLocal  := NVL(nAsistRestLocal,0) + (NVL(K.MontoAsistLocal,0) * NVL(nFact,0)/100) - nMtoAsistLocal;
               nAsistRestMoneda := NVL(nAsistRestMoneda,0) + (NVL(K.MontoAsistMoneda,0) * NVL(nFact,0)/100) - nMtoAsistMoneda;
               IF NP > 1 THEN
                  nMtoAsistLocal  := (NVL(nAsistRestLocal,0) / (nNumPagos - 1));
                  nMtoAsistMoneda := (NVL(nAsistRestMoneda,0) / (nNumPagos - 1));
               END IF;*/
               nTotAsistLocal  := NVL(nTotAsistLocal,0) + NVL(nMtoAsistLocal,0);
               nTotAsistMoneda := NVL(nTotAsistMoneda,0) + NVL(nMtoAsistMoneda,0);
               OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
               OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
            END LOOP;

            nMtoT := nMtoT + nMtoPago;-- + NVL(nTotAsistLocal,0);

            PROC_COMISIONPOL (nIdPoliza, NULL, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFactura,
                              nMtoComisiPag/nNumCert, nMtoComisiMonedaPag/nNumCert, nTasaCambio);

            -- Distribuye la comision por agente.
            FOR Y IN CPTO_PLAN_Q LOOP
               BEGIN
                  SELECT 'S'
                    INTO cGraba
                    FROM RAMOS_CONCEPTOS_PLAN R
                   WHERE R.CodPlanPago = cCodPlanPago
                     AND R.CodCpto     = Y.CodCpto
                     AND R.CodCia      = nCodCia
                     AND R.CodEmpresa  = nCodEmpresa
                     AND EXISTS   (SELECT 1
                                     FROM DETALLE_POLIZA D, POLIZAS P
                                    WHERE D.IdPoliza   = P.IdPoliza
                                      AND D.IdTipoSeg  = R.IdTipoSeg
                                      AND P.StsPoliza IN ('SOL','XRE')
                                      AND P.IdPoliza   = nIdPoliza);
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     cGraba := 'N';
                  WHEN TOO_MANY_ROWS THEN
                     cGraba := 'S';
               END;

               IF cGraba = 'S' THEN
                  IF Y.IndRangosTipseg = 'S' THEN
                     IF cIndCalcDerechoEmis = 'S' THEN
                        OC_CATALOGO_CONCEPTOS_RANGOS.VALOR_CONCEPTO(nCodCia, nCodEmpresa, Y.CodCpto, cIdTipoSeg,
                                                                    nIdPoliza, nIdetPol, nIdEndoso, nMtoCpto, nPorcCpto);
                        IF OC_DETALLE_FACTURAS.EXISTE_CONCEPTO(nCodCia, nIdPoliza, nTransa, Y.CodCpto) = 'N' THEN
                           IF NVL(nMtoCpto,0) = 0 AND NVL(nPorcCpto,0) = 0 THEN
                              nMtoCpto  := Y.MtoCpto;
                              nPorcCpto := Y.PorcCpto;
                           END IF;
                        ELSE
                           nMtoCpto  := 0;
                           nPorcCpto := 0;
                        END IF;
                     ELSE
                        nMtoCpto  := 0;
                        nPorcCpto := 0;
                     END IF;
                  ELSE
                     nMtoCpto  := Y.MtoCpto;
                     nPorcCpto := Y.PorcCpto;
                  END IF;
                  IF Y.Aplica = 'P' THEN
                     IF NVL(nMtoCpto,0) <> 0 AND cPrimerFact = 'S' THEN --NP = 1 THEN
                        nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                     ELSIF cPrimerFact = 'S' THEN
                        nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                        nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                     ELSE
                        nMtoDet       := 0;
                        nMtoDetMoneda := 0;
                     END IF;
                     IF NVL(nMtoDet,0) != 0 THEN
                        OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                        nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                     END IF;
                  ELSIF Y.Aplica = 'T' THEN
                     IF NVL(nMtoCpto,0) <> 0 THEN
                        nMtoDet       := NVL(nMtoCpto,0);
--                        nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;  --LARPLA1
                        nMtoDetMoneda := NVL(nMtoCpto,0) / nTasaCambio;    --LARPLA1
                     ELSE
                        nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                        nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                     END IF;
                     IF NVL(nMtoDet,0) != 0 THEN
                        OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                        nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                     END IF;
                  END IF;
                  nMtoT := nMtoT + nMtoDet;
               END IF;
            END LOOP;
         --   END IF;
            OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
        -- END LOOP;

         IF (NVL(nPrimaLocal,0)+ nMtoRecD_Local - nMtoDescD_Local +
             NVL(nRec_Local,0) - NVL(nDesc_Local,0)) <> NVL(nTotPrimas,0) THEN
            nDifer       := (NVL(nPrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local   +
                             NVL(nRec_Local,0)  - NVL(nDesc_Local,0)) - NVL(nTotPrimas,0);
            nDiferMoneda := (NVL(nPrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda  +
                             NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) - NVL(nTotPrimasMoneda,0);
            nDiferC      :=  NVL(nMtoComiL,0)   - NVL(nMtoComisi,0);
            nDiferCMon   :=  NVL(nMtoComisiM,0) - NVL(nMtoComisiMoneda,0);

            PROC_COMISIONPOL (nIdPoliza, NULL, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFactura,
                              nDiferC/nNumCert, nDiferCMon/nNumCert, nTasaCambio);

            OC_DETALLE_FACTURAS.ACTUALIZA_DIFERENCIA(nIdFactura, nDifer, nDiferMoneda);

            OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);

            UPDATE FACTURAS
               SET MtoComisi_Local   = MtoComisi_Local   + NVL(nDiferC,0),
                   MtoComisi_Moneda  = MtoComisi_Moneda  + NVL(nDiferCMon,0)
             WHERE IdFactura = nIdFactura;
         END IF;
         OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
      END LOOP;
      OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'FAC', 'FACTURAS',
                                   nIdPoliza, nIdetPol, NULL, NULL, nMtoT);
      OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'COM', 'COMISIONES',
                                   nIdPoliza, nIdetPol, NULL, NULL, nMtoDet);
   END IF;
   BEGIN
      SELECT Contabilidad_Automatica
        INTO cContabilidad_Automatica
        FROM EMPRESAS
       WHERE CodCia = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cContabilidad_Automatica := 'N';
   END;
   IF cContabilidad_Automatica = 'S' THEN
      PROC_MOVCONTA(nCodCia, nIdPoliza, cCodMoneda, 'EMI');
   END IF;
END PROC_EMITE_FACT_PERIODO;

FUNCTION FUNC_VALIDA_FECHA ( nCodCia NUMBER,nCodEmpresa NUMBER ,nIdPoliza NUMBER, dFecIni DATE,cCodPlanPlago VARCHAR2)RETURN VARCHAR2 IS
nNumPagos             PLAN_DE_PAGOS.NumPagos%TYPE;
nFrecPagos            PLAN_DE_PAGOS.FrecPagos%TYPE;
dFecPago              FACTURAS.FECPAGO%TYPE;
--nPorcInicial          PLAN_DE_PAGOS.PorcInicial%TYPE;
BEGIN
   BEGIN
      SELECT NumPagos, FrecPagos
        INTO nNumPagos, nFrecPagos
        FROM PLAN_DE_PAGOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodPlanPago = cCodPlanPlago;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'No Existe Plan de Pagos '||cCodPlanPlago);
   END;
   BEGIN
     SELECT TRUNC(NVL(ADD_MONTHS(MAX(FECVENC),nFrecPagos),SYSDATE))
       INTO dFecPago
       FROM FACTURAS
      WHERE IdPoliza = nIdPoliza
        AND IdEndoso = 0
        AND CodCia   = nCodCia;
   END;
   IF dFecIni > dFecPago THEN
      RETURN('S');
   ELSE
      RETURN ('N');
   END IF;
END FUNC_VALIDA_FECHA;

PROCEDURE PROC_EMITE_FACT_ENDO_PERIODO(nIdPoliza NUMBER, nIdEndoso NUMBER, pCodCia NUMBER, nTransa NUMBER,nCuota NUMBER) IS
nIdFactura               FACTURAS.IdFactura%TYPE;
nNumPagos                PLAN_DE_PAGOS.NumPagos%TYPE;
nFrecPagos               PLAN_DE_PAGOS.FrecPagos%TYPE;
nPorcInicial             PLAN_DE_PAGOS.PorcInicial%TYPE;
nCodCliente              POLIZAS.CodCliente%TYPE;
cIdTipoSeg               DETALLE_POLIZA.IdTipoSeg%TYPE;
nTotPrimas               DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDifer                   DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDiferMoneda             DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoDet                  DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoDetMoneda            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMtoTotal                DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoTotalMoneda          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cCodMoneda               POLIZAS.Cod_Moneda%TYPE;
nPrimaNetaMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoPagoMoneda           FACTURAS.Monto_Fact_Moneda%TYPE;
cCodMonedaLocal          EMPRESAS.Cod_Moneda%TYPE;
nPrimaRestMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nMtoComisiMoneda         FACTURAS.MtoComisi_Local%TYPE;
nTotPrimasMoneda         POLIZAS.PrimaNeta_Moneda%TYPE;
nCodCia                  POLIZAS.CodCia%TYPE;
nCodEmpresa              POLIZAS.CodEmpresa%TYPE;
cCodPlanPago             DETALLE_POLIZA.CodPlanPago%TYPE;
nTasaCambio              DETALLE_POLIZA.Tasa_Cambio%TYPE;
nMtoCpto                 CONCEPTOS_PLAN_DE_PAGOS.MtoCpto%TYPE;
nPorcCpto                CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
cAplica                  CONCEPTOS_PLAN_DE_PAGOS.Aplica%TYPE;
Dummy                    NUMBER(5);
dFecPago                 DATE;
nMtoPago                 NUMBER(18,2);
nMtoComisi               NUMBER(18,2);
nPrimaRest               NUMBER(18,2);
dFecHoy                  DATE;
cGraba                   VARCHAR2(1);
nCod_Agente              AGENTES_DETALLES_POLIZAS.Cod_Agente%TYPE;
--
nMtoRecD_Local           DETALLE_RECARGO.Monto_Local%TYPE;
nMtoRecD_Moneda          DETALLE_RECARGO.Monto_Moneda%TYPE;
nMtoDescD_Local          DETALLE_DESCUENTO.Monto_Local%TYPE;
nMtoDescD_Moneda         DETALLE_DESCUENTO.Monto_Moneda%TYPE;
--
nMtoRec_Local            RECARGOS.Monto_Local%TYPE;
nMtoRec_Moneda           RECARGOS.Monto_Moneda%TYPE;
nMtoDesc_Local           DESCUENTOS.Monto_Local%TYPE;
nMtoDesc_Moneda          DESCUENTOS.Monto_Moneda%TYPE;
nPrimaTotalM             DETALLE_POLIZA.Prima_Moneda%TYPE;
nPrimaTotalL             DETALLE_POLIZA.Prima_Local%TYPE;
nFactor                  NUMBER (14,8);
nRec_Local               RECARGOS.Monto_Local%TYPE ;
nRec_Moneda              RECARGOS.Monto_Moneda%TYPE;
nDesc_Local              DESCUENTOS.Monto_Local%TYPE;
nDesc_Moneda             DESCUENTOS.Monto_Moneda%TYPE;
cCodPlanPagoPol          POLIZAS.CodPlanPago%TYPE;
--
nPorcComis               DETALLE_POLIZA.PorcComis%TYPE;
nNumCert                 DETALLE_POLIZA.IdetPol%TYPE;
nPrimaLocal              NUMBER(18,2);
nPrimaMoneda             NUMBER(18,2);
nIdTransac               NUMBER(14,0);
nMtoComisiRest           NUMBER(18,2);
nMtoComisiMonedaRest     NUMBER(18,2);
nMtoComisiPag            NUMBER(18,2);
nMtoComisiMonedaPag      NUMBER(18,2);
nMtoComiTot              NUMBER(18,2);
nMtoComisiMonedaTot      NUMBER(18,2);
nMtoComiL                NUMBER(18,2);
nMtoComisiM              NUMBER(18,2);
nDiferC                  DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDiferCMon               DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cRespPol                 VARCHAR2(1):='N';
cRespDet                 VARCHAR2(1):='N';
nPorcT                   NUMBER(18,2);
nFact                    NUMBER(18,2);
nCodTipoDoc              TIPO_DE_DOCUMENTO.CodTipoDoc%TYPE;
nIdetPol                 DETALLE_POLIZA.IdetPol%TYPE; --:= 1;
cContabilidad_Automatica EMPRESAS.Contabilidad_Automatica%TYPE;
nIdTranc                 TRANSACCION.idtransaccion%TYPE;
nMtoT                    FACTURAS.monto_fact_local%TYPE := 0;
NP                       NUMBER (10);
nMes                     NUMBER (10);
nMontoAdic               NUMBER(18,2);
nMtoAsistLocal           ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nMtoAsistMoneda          ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
nAsistRestLocal          ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nAsistRestMoneda         ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
nTotAsistLocal           ASISTENCIAS_DETALLE_POLIZA.MontoAsistLocal%TYPE;
nTotAsistMoneda          ASISTENCIAS_DETALLE_POLIZA.MontoAsistMoneda%TYPE;
cIndFactElectronica      POLIZAS.IndFactElectronica%TYPE;
fFecfinvig               FACTURAS.FECFINVIG%TYPE;      -- ICOFINVIG

CURSOR DET_POL_Q IS
   SELECT E.Prima_Neta_Local PrimaLocal, E.Prima_Neta_Moneda PrimaMoneda, D.CodPlanPago, D.PorcComis,D.StsDetalle,
          E.FecIniVig, E.FecEmision, D.IDetPol, D.Tasa_Cambio, D.IdTipoSeg, E.FecIniVig FecIniCert, E.IdEndoso--E,P.StsPoliza
     FROM DETALLE_POLIZA D, ENDOSOS E
    WHERE D.IdPoliza         = E.IdPoliza
      AND D.IDetPol          = E.IDetPol
      AND E.Prima_Neta_Local > 0
      AND E.IdPoliza         = nIdPoliza
     -- AND E.IDetPol    = nIDetPol
      AND E.StsEndoso        = 'SOL'
      AND E.TipoEndoso       = 'AUM';

CURSOR CPTO_PLAN_Q IS
   SELECT CP.CodCpto, CP.PorcCpto, CP.Aplica, CP.MtoCpto,
          CC.IndRangosTipseg
     FROM CONCEPTOS_PLAN_DE_PAGOS CP, CATALOGO_DE_CONCEPTOS CC
    WHERE CC.IndCptoAjuste = 'N'
      AND CC.IndCptoPrimas = 'N'
      AND CC.CodConcepto   = CP.CodCpto
      AND CC.CodCia        = CP.CodCia
      AND CP.CodCia        = pCodCia
      AND CP.CodEmpresa    = nCodEmpresa
      AND CP.CodPlanPago   = cCodPlanPago
      AND EXISTS (SELECT 'S'
                    FROM RAMOS_CONCEPTOS_PLAN
                   WHERE CodCia      = CP.CodCia
                     AND CodEmpresa  = CP.CodEmpresa
                     AND IdTipoSeg  IN (SELECT IdTipoSeg
                                          FROM DETALLE_POLIZA
                                         WHERE IdPoliza  = nIdPoliza)
                     AND CodCpto     = CP.CodCpto
                     AND CodPlanPago = CP.CodPlanPago)
    ORDER BY CP.Prioridad;

CURSOR RESP_PAGO IS
  SELECT R.CodResPago
    FROM RESPONSABLE_PAGO_DET R
   WHERE R.IdPoliza    = nIdPoliza
     AND R.CodCia      = pCodCia
     AND R.CodEmpresa  = nCodEmpresa
   GROUP BY R.CodResPago;

CURSOR CPTO_PRIMAS_Q IS
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERT_ACT C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert   = C.CodCobert
      AND CS.PlanCob     = C.PlanCob
      AND CS.IdTipoSeg   = C.IdTipoSeg
      AND CS.CodEmpresa  = C.CodEmpresa
      AND CS.CodCia      = C.CodCia
      AND C.StsCobertura IN ('EMI','SOL','XRE')
      AND C.IdEndoso     = nIdEndoso
      AND C.IDetPol      = nNumCert
      AND C.IdPoliza     = nIdPoliza
      AND C.CodCia       = pCodCia
    GROUP BY CS.CodCpto
  UNION ALL
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERT_ACT_ASEG C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert   = C.CodCobert
      AND CS.PlanCob     = C.PlanCob
      AND CS.IdTipoSeg   = C.IdTipoSeg
      AND CS.CodEmpresa  = C.CodEmpresa
      AND CS.CodCia      = C.CodCia
      AND C.StsCobertura IN ('EMI','SOL','XRE')
      AND C.IdEndoso     = nIdEndoso
      --AND C.IDetPol      = nNumCert
      AND C.IdPoliza     = nIdPoliza
      AND C.CodCia       = pCodCia
    GROUP BY CS.CodCpto;
CURSOR CPTO_ASIST_Q IS
   SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
          SUM(A.MontoAsistMoneda) MontoAsistMoneda
     FROM ASISTENCIAS_DETALLE_POLIZA A, DETALLE_POLIZA D, ASISTENCIAS T
    WHERE T.CodAsistencia  = A.CodAsistencia
      AND D.IDetPol        = A.IDetPol
      AND D.IdPoliza       = A.IdPoliza
      AND D.CodCia         = A.CodCia
      AND A.IdEndoso     = nIdEndoso
      AND A.StsAsistencia IN ('EMITID','SOLICI','XRENOV')
      AND A.IDetPol        = nNumCert
      AND A.IdPoliza       = nIdPoliza
      AND A.CodCia         = pCodCia
    GROUP BY T.CodCptoServicio
  UNION ALL
   SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
          SUM(A.MontoAsistMoneda) MontoAsistMoneda
     FROM ASISTENCIAS_ASEGURADO A, DETALLE_POLIZA D, ASISTENCIAS T
    WHERE T.CodAsistencia  = A.CodAsistencia
      AND D.IDetPol        = A.IDetPol
      AND D.IdPoliza       = A.IdPoliza
      AND D.CodCia         = A.CodCia
      AND A.IdEndoso       = nIdEndoso
      AND A.StsAsistencia IN ('EMITID','SOLICI','XRENOV')
      --AND A.IDetPol        = nNumCert
      AND A.IdPoliza       = nIdPoliza
      AND A.CodCia         = pCodCia
    GROUP BY T.CodCptoServicio;
BEGIN
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
  BEGIN
      SELECT CodCliente, Cod_Moneda, CodCia, CodEmpresa,
             CodPlanPago, IndFactElectronica
        INTO nCodCliente, cCodMoneda, nCodCia, nCodEmpresa,
             cCodPlanPagoPol, cIndFactElectronica
        FROM POLIZAS
       WHERE IdPoliza = nIdPoliza;
    END;
    BEGIN
       SELECT Cod_Moneda
         INTO cCodMonedaLocal
         FROM EMPRESAS
        WHERE CodCia = nCodCia;
  END;
  BEGIN
     SELECT SUM(D.Prima_Local) PrimaLocal, SUM(D.Prima_Moneda) PrimaMoneda, COUNT(IdetPol)
       INTO nPrimaTotalL, nPrimaTotalM, nNumCert
       FROM DETALLE_POLIZA D, POLIZAS P
      WHERE D.IdPoliza  = P.IdPoliza
        AND D.StsDetalle IN ('EMI','SOL','XRE')--('EMI','SOL')
        AND P.IdPoliza  = nIdPoliza;
   END;
   BEGIN
      SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
        INTO nMtoRec_Local, nMtoRec_Moneda
        FROM RECARGOS
       WHERE IdPoliza = nIdPoliza
         AND Estado   = 'ACT';
   EXCEPTION
      WHEN OTHERS THEN
         nMtoRec_Local  := 0;
         nMtoRec_Moneda := 0;
   END;
   BEGIN
      SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
        INTO nMtoDesc_Local, nMtoDesc_Moneda
        FROM DESCUENTOS
       WHERE IdPoliza  = nIdPoliza
         AND Estado    = 'ACT';
   EXCEPTION
      WHEN OTHERS THEN
         nMtoDesc_Local  := 0;
         nMtoDesc_Moneda := 0;
   END;
   -- Características del Plan de Pago
   BEGIN
      SELECT NumPagos, FrecPagos, PorcInicial
        INTO nNumPagos, nFrecPagos, nPorcInicial
        FROM PLAN_DE_PAGOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodPlanPago = cCodPlanPagoPol;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'No Existe Plan de Pagos '||cCodPlanPagoPol);
   END;
   BEGIN
      SELECT 'S'
        INTO cRespPol
        FROM RESPONSABLE_PAGO_POL
       WHERE StsResPago = 'ACT'
         AND CodCia     = pCodCia
         AND IdPoliza   = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cRespPol := 'N';
      WHEN TOO_MANY_ROWS THEN
         cRespPol := 'S';
   END;
   IF cRespPol = 'S' AND FUNC_VALIDA_RESP_POL (nIdPoliza,pCodCia) = 'S' THEN
      PROC_INSERT_RESP_D (nIdPoliza,pCodCia);
   END IF;
   BEGIN
      SELECT 'S'
        INTO cRespDet
        FROM RESPONSABLE_PAGO_DET R
       WHERE R.IdPoliza    = nIdPoliza
         AND R.CodCia      = pCodCia
         AND R.CodEmpresa  = nCodEmpresa;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cRespDet:='N';
      WHEN TOO_MANY_ROWS THEN
         cRespDet:='S';
   END;

   IF cRespPol = 'N' AND cRespDet = 'N' THEN
      FOR X IN DET_POL_Q LOOP
          nIdetPol := X.IdetPol;
         BEGIN
            SELECT Cod_Agente
              INTO nCod_Agente
              FROM AGENTES_DETALLES_POLIZAS
             WHERE IdPoliza      = nIdPoliza
               AND IdetPol       = X.IdetPol
               AND IdTipoSeg     = X.IdTipoSeg
               AND Ind_Principal = 'S';
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR (-20100,'No Existe un Agente Definido para el Tipo de Seguro '||X.IdTipoSeg);
            WHEN TOO_MANY_ROWS THEN
               RAISE_APPLICATION_ERROR (-20100,'Existe Mas de un Agente Definido como Principal');
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR (-20100,'Existe un error de otros');
         END;

         cCodPlanPago := X.CodPlanPago;
         nMtoT        := 0;

         OC_DETALLE_TRANSACCION.CREA (nTransa,nCodCia,nCodEmpresa,7,'CER', 'DETALLE_POLIZA',
                                      nIdPoliza, X.IdetPol, NULL, NULL, X.PrimaLocal);

         IF nMtoRec_Local != 0 OR nMtoRec_Moneda != 0 OR nMtoDesc_Local != 0 OR nMtoDesc_Moneda != 0 THEN
            nFactor      := (X.PrimaLocal    / NVL(nPrimaTotalL,0)) * 100;
            nRec_Local   := (nMtoRec_Local  * nFactor) / 100;
            nRec_Moneda  := (nMtoRec_Moneda * nFactor) / 100;
            nDesc_Local  := (nMtoDesc_Local * nFactor) / 100;
            nDesc_Moneda := (nMtoDesc_Moneda * nFactor)/ 100;
         END IF;
         IF nIdEndoso = 0 THEN
            nTasaCambio := X.Tasa_Cambio;
         ELSE
            nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
         END IF;
         -- Fecha del Primer Pago
         IF nCuota = 1 THEN
            IF X.FecIniVig < TRUNC (SYSDATE) THEN
               dFecPago := TRUNC (SYSDATE);
            ELSE
               dFecPago := X.FecIniVig;
            END IF;
         END IF;

         -- Monto del Primer Pago
         nTotPrimas       := 0;
         nTotPrimasMoneda := 0;
         nMtoComisi       := 0;
         nMtoComisiMoneda := 0;
         BEGIN
            SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
              INTO nMtoRecD_Local, nMtoRecD_Moneda
              FROM DETALLE_RECARGO
             WHERE IdPoliza = nIdPoliza
               AND IDetPol  = X.IDetPol
               AND Estado   = 'ACT';
         EXCEPTION
            WHEN OTHERS THEN
               nMtoRecD_Local  := 0;
               nMtoRecD_Moneda := 0;
         END;
         BEGIN
            SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
              INTO nMtoDescD_Local, nMtoDescD_Moneda
              FROM DETALLE_DESCUENTO
             WHERE IdPoliza  = nIdPoliza
               AND IDetPol   = X.IDetPol
               AND Estado    = 'ACT';
         EXCEPTION
            WHEN OTHERS THEN
               nMtoDescD_Local  := 0;
               nMtoDescD_Moneda := 0;
         END;
        -- dbms_output.put_line('nPorcInicial:'||nPorcInicial||' '||X.PrimaLocal);
         nPorcInicial:= 100;
         IF NVL(nPorcInicial,0) <> 0 THEN
            nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0))  * nPorcInicial / 100  ;
            nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) * nPorcInicial / 100 ;
            nMtoComisiPag       := NVL(nMtoComisiPag,0)       + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100) * nPorcInicial / 100 );
            nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + ((NVL(X.PrimaMoneda,0)* X.PorcComis / 100) * nPorcInicial / 100) ;
         ELSE
            nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local    - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) / nNumPagos  ;
            nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda   - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) /nNumPagos ;
            nMtoComisiPag       := nMtoComisiPag              + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100) / nNumPagos ;
            nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100) / nNumPagos ;
         END IF;
         nPrimaRest           := NVL(nPrimaRest,0)           + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) - NVL(nMtoPago,0);
         nMtoComisiRest       := NVL(nMtoComisiRest,0)       + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100 ) -  NVL(nMtoComisiPag,0));
         nTotPrimas           := NVL(nTotPrimas,0)           +  NVL(nMtoPago,0);
         nMtoComisi           := NVL(nMtoComisi,0)           +  NVL(nMtoComisiPag,0);
         nPrimaRestMoneda     := NVL(nPrimaRestMoneda,0)     + (NVL(X.PrimaMoneda,0)  + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) - NVL(nMtoPagoMoneda,0);
         nMtoComisiMonedaRest := NVL(nMtoComisiMonedaRest,0) + ((NVL(X.PrimaMoneda,0) * X.PorcComis / 100) -   NVL(nMtoComisiMonedaPag,0));
         nMtoComisiMoneda     := NVL(nMtoComisiMoneda,0)     +  NVL(nMtoComisiMonedaPag,0);
         nTotPrimasMoneda     := NVL(nTotPrimasMoneda,0)     +  NVL(nMtoPagoMoneda,0);
         nPrimaMoneda         := NVL(nPrimaMoneda,0)         +  NVL(X.PrimaMoneda,0);
         nPrimaLocal          := NVL(nPrimaLocal,0)          +  NVL(X.PrimaLocal,0) ;
         nMtoComiL            := NVL(nMtoComiL,0)            + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100) ;
         nMtoComisiM          := NVL(nMtoComisiM,0)          + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100) ;
        INSERT INTO DETALLE_ENDOSO(IdPoliza,IdEndoso,IdetPol,Monto)
             VALUES (nIdPoliza,X.IdEndoso,X.IdetPol,X.PrimaLocal);
      END LOOP;

      nPrimaRest           := NVL(nPrimaLocal,0)  - NVL(nMtoPago,0);
      nPrimaRestMoneda     := NVL(nPrimaMoneda,0) - NVL(nMtoPagoMoneda,0);
      nMtoComisiRest       := NVL(nMtoComiL,0)    - NVL(nMtoComisiPag,0);
      nMtoComisiMonedaRest := NVL(nMtoComisiM,0)  - NVL(nMtoComisiMonedaPag,0);
    --  FOR NP IN 1..nNumPagos LOOP
       NP := nCuota;
    --   nNumPagos := 12;
         IF NP > 1 THEN
            nMtoPago            := NVL(nPrimaRest,0)     / (nNumPagos - 1) + NVL(nMontoAdic,0);
            nMtoComisiPag       := NVL(nMtoComisiRest,0) / (nNumPagos - 1);
            nTotPrimas          := NVL(nTotPrimas,0) + NVL(nMtoPago,0) + NVL(nMontoAdic,0);
            nMtoComisi          := NVL(nMtoComisi,0) + NVL(nMtoComisiPag,0);

          --  dFecPago            := ADD_MONTHS(dFecPago,nFrecPagos);

            nMtoPagoMoneda      := NVL(nPrimaRestMoneda,0)     / (nNumPagos - 1) + NVL(nMontoAdic,0);
            nTotPrimasMoneda    := NVL(nTotPrimasMoneda,0)     +  NVL(nMtoPagoMoneda,0) + NVL(nMontoAdic,0);
            nMtoComisiMonedaPag := NVL(nMtoComisiMonedaRest,0) / (nNumPagos - 1);
            nMtoComisiMoneda    := NVL(nMtoComisiMoneda,0) + NVL(nMtoComisiMonedaPag,0);
         END IF;

              --   dbms_output.put_line('dFecPago:'||dFecPago);
         dbms_output.put_line('nIDetPol:'||nIDetPol||'-'||nMtoPago);
       --  dFecPago := trunc(SYSDATE);
      IF OC_generales.VALIDA_FECHA(dFecPago) = 'S'   THEN
      --  IF  nMontoAdic > 0 THEN
         -- LARPLA
         nIdFactura := OC_FACTURAS.INSERTAR(nIdPoliza,           /*nIDetPol*/1,   nCodCliente, dFecPago, 
                                            nMtoPago,            nMtoPagoMoneda,  nIdEndoso,   nMtoComisiPag, 
                                            nMtoComisiMonedaPag, NP,              nTasaCambio, nCod_Agente, 
                                            nCodTipoDoc,         pCodCia,         cCodMoneda,  NULL, 
                                            nTransa,             cIndFactElectronica);

         FOR W IN CPTO_PRIMAS_Q LOOP
            nFactor := W.Prima_Local / NVL(nPrimaLocal,0);
           --   nFactor := (W.Prima_Local /* /nNumPagos) + NVL(nMontoAdic,0)*// NVL(nMtoPago,0);
           --  nFactor := ((W.Prima_Local/nNumPagos) /*+ NVL(nMontoAdic,0)*/)/ (NVL(nMtoPago,0) /*- NVL(nMontoAdic,0)*/);
            OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, W.CodCpto, 'S', nMtoPago*nFactor , nMtoPagoMoneda * nFactor );
            OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
         END LOOP;

         nTotAsistLocal  := 0;
         nTotAsistMoneda := 0;
         FOR K IN CPTO_ASIST_Q LOOP
            nAsistRestLocal  := 0;
            nAsistRestMoneda := 0;
            IF NVL(nPorcInicial,0) <> 0 THEN
               nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) * nPorcInicial / 100);
               nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) * nPorcInicial / 100);
            ELSE
               nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) / nNumPagos);
               nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) / nNumPagos);
            END IF;
            /*nAsistRestLocal  := NVL(nAsistRestLocal,0) + NVL(K.MontoAsistLocal,0) - nMtoAsistLocal;
            nAsistRestMoneda := NVL(nAsistRestMoneda,0) + NVL(K.MontoAsistMoneda,0) - nMtoAsistMoneda;
            IF NP > 1 THEN
               nMtoAsistLocal  := (NVL(nAsistRestLocal,0) / (nNumPagos - 1));
               nMtoAsistMoneda := (NVL(nAsistRestMoneda,0) / (nNumPagos - 1));
            END IF;*/
            nTotAsistLocal  := NVL(nTotAsistLocal,0) + NVL(nMtoAsistLocal,0);
            nTotAsistMoneda := NVL(nTotAsistMoneda,0) + NVL(nMtoAsistMoneda,0);
            OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
            OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
         END LOOP;

         nMtoT := nMtoT + nMtoPago;-- + NVL(nTotAsistLocal,0);
         -- Genera comisiones por agente por Poliza
         PROC_COMISIONPOL (nIdPoliza, NULL, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFactura,
                           nMtoComisiPag/nNumCert, nMtoComisiMonedaPag/nNumCert, nTasaCambio);

        -- Distribuye la comision por agente.

         FOR Y IN CPTO_PLAN_Q LOOP
            BEGIN
               SELECT 'S'
                 INTO cGraba
                 FROM RAMOS_CONCEPTOS_PLAN R
                WHERE R.CodPlanPago = cCodPlanPago
                  AND R.CodCpto     = Y.CodCpto
                  AND R.CodCia      = nCodCia
                  AND R.CodEmpresa  = nCodEmpresa
                  AND EXISTS   (SELECT 1
                                  FROM DETALLE_POLIZA D, POLIZAS P
                                 WHERE D.IdPoliza  = P.IdPoliza
                                   AND D.IdTipoSeg = R.IdTipoSeg
                                   AND P.StsPoliza IN ('EMI','SOL','XRE')
                                   AND P.IdPoliza  = nIdPoliza);
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cGraba := 'N';
               WHEN TOO_MANY_ROWS THEN
                  cGraba := 'S';
            END;

            IF cGraba = 'S' THEN
               IF Y.Aplica = 'P' THEN
                  NULL; -- No Aplica para Endoso
                  /*IF NVL(Y.MtoCpto,0) <> 0 AND NP = 1 THEN
                     nMtoDet       := NVL(Y.MtoCpto,0);
                     nMtoDetMoneda := NVL(Y.MtoCpto,0) * nTasaCambio;
                  ELSE
                     nMtoDet       := (NVL(nPrimaLocal,0)+ nMtoRecD_Local - nMtoDescD_Local +
                                       NVL(nRec_Local,0) - NVL(nDesc_Local,0) + NVL(nTotAsistLocal,0)) * Y.PorcCpto / 100;
                     nMtoDetMoneda := (NVL(nPrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda +
                                       NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0) + NVL(nTotAsistMoneda,0)) * Y.PorcCpto / 100;
                  END IF;
                  IF NVL(nMtoDet,0) != 0 THEN
                     OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                     OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                  END IF;*/
               ELSIF Y.Aplica = 'T' THEN
                  IF NVL(Y.MtoCpto,0) <> 0 THEN
                     nMtoDet       := NVL(Y.MtoCpto,0);
                     nMtoDetMoneda := NVL(Y.MtoCpto,0) * nTasaCambio;
                  ELSE
                     nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                     nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                  END IF;
                  IF NVL(nMtoDet,0) != 0 THEN
                     OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                     OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                     nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                     nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                  END IF;
               END IF;
               nMtoT := nMtoT + nMtoDet;
            END IF;
         END LOOP;
         OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
         OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
    -- END IF;
      ELSE
         RAISE_APPLICATION_ERROR(-20200,'La Factura Corresponde a la Fecha : '||TO_CHAR(dFecPago,'DD-MM-YYYY')||' ' ||'Posterior al mes corriente, Favor verificar');
      END IF;
    --  END LOOP;
      OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'FAC', 'FACTURAS',
                                   nIdPoliza, nIdetPol, NULL, NULL, nMtoT);
      OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'COM', 'COMISIONES',
                                   nIdPoliza, nIdetPol, NULL, NULL, nMtoComisiPag);
   ELSE
      BEGIN
         SELECT SUM(R.PorcResPago)
           INTO nPorcT
           FROM RESPONSABLE_PAGO_DET R
          WHERE R.IdPoliza    = nIdPoliza
            AND R.CodCia      = nCodCia
            AND R.CodEmpresa  = nCodEmpresa ;
      END;
      FOR J IN RESP_PAGO LOOP
         BEGIN
            SELECT (SUM(PORCRESPAGO)/nPorcT) * 100
              INTO nFact
              FROM RESPONSABLE_PAGO_DET r
             WHERE R.IdPoliza    = nIdPoliza
               AND R.CodCia      = nCodCia
               AND R.CodEmpresa  = nCodEmpresa
               AND R.CodResPago  = J.CodResPago;
         END;
         nMtoPago             := 0;
         nMtoPagoMoneda       := 0;
         nMtoComisiPag        := 0;
         nMtoComisiMonedaPag  := 0;
         nPrimaRest           := 0;
         nMtoComisiRest       := 0;
         nTotPrimas           := 0;
         nMtoComisi           := 0;
         nPrimaRestMoneda     := 0;
         nMtoComisiMonedaRest := 0;
         nMtoComisiMoneda     := 0;
         nTotPrimasMoneda     := 0;
         nPrimaMoneda         := 0;
         nPrimaLocal          := 0;
         nMtoComiL            := 0;
         nMtoComisiM          := 0;
         FOR X IN DET_POL_Q LOOP
            BEGIN
               SELECT Cod_Agente
                 INTO nCod_Agente
                 FROM AGENTES_DETALLES_POLIZAS
                WHERE IdPoliza      = nIdPoliza
                  AND IdetPol       = X.IdetPol
                  AND IdTipoSeg     = X.IdTipoSeg
                  AND Ind_Principal = 'S';
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR (-20100,'No Existe un Agente Definido para el Tipo de Seguro '||X.IdTipoSeg);
               WHEN TOO_MANY_ROWS THEN
                  RAISE_APPLICATION_ERROR (-20100,'Existe Mas de un Agente Definido como Principal');
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR (-20100,'Existe un error de otros');
            END;
            cCodPlanPago := X.CodPlanPago;
            IF nMtoRec_Local != 0 OR nMtoRec_Moneda != 0 OR nMtoDesc_Local != 0 OR nMtoDesc_Moneda != 0 THEN
               nFactor      := (X.PrimaLocal * NVL(nFact,0)/100) / NVL(nPrimaTotalL,0) * 100;
               nRec_Local   := (nMtoRec_Local  * nFactor) / 100;
               nRec_Moneda  := (nMtoRec_Moneda * nFactor) / 100;
               nDesc_Local  := (nMtoDesc_Local * nFactor) / 100;
               nDesc_Moneda := (nMtoDesc_Moneda * nFactor)/ 100;
            END IF;
            IF nIdEndoso = 0 THEN
               nTasaCambio := X.Tasa_Cambio;
            ELSE
               nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
            END IF;

            -- Fecha del Primer Pago Siempre a Inicio de Vigencia
            dFecPago := X.FecIniVig;
            /*IF X.FecIniVig > X.FecEmision THEN
               dFecPago := X.FecIniVig;
            ELSE
               dFecPago := X.FecEmision;
            END IF;*/
                -- Monto del Primer Pago
            nTotPrimas       := 0;
            nTotPrimasMoneda := 0;
            nMtoComisi       := 0;
            nMtoComisiMoneda := 0;
            BEGIN
               SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
                 INTO nMtoRecD_Local, nMtoRecD_Moneda
                 FROM DETALLE_RECARGO
                WHERE IdPoliza = nIdPoliza
                  AND IDetPol  = X.IDetPol
                  AND Estado   = 'ACT';
            EXCEPTION
               WHEN OTHERS THEN
                  nMtoRecD_Local  := 0;
                  nMtoRecD_Moneda := 0;
            END;
            BEGIN
               SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
                 INTO nMtoDescD_Local, nMtoDescD_Moneda
                 FROM DETALLE_DESCUENTO
                WHERE IdPoliza  = nIdPoliza
                  AND IDetPol   = X.IDetPol
                  AND Estado    = 'ACT';
            EXCEPTION
               WHEN OTHERS THEN
                  nMtoDescD_Local  := 0;
                  nMtoDescD_Moneda := 0;
            END;

            IF NVL(nPorcInicial,0) <> 0 THEN
               nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0))  * nPorcInicial / 100 * NVL(nFact,0)/100;
               nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) * nPorcInicial / 100 *  NVL(nFact,0)/100;
               nMtoComisiPag       := NVL(nMtoComisiPag,0)       + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100) * nPorcInicial / 100 )* NVL(nFact,0)/100;
               nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + ((NVL(X.PrimaMoneda,0)* X.PorcComis / 100) * nPorcInicial / 100)* NVL(nFact,0)/100;
            ELSE
               nMtoPago            := NVL(nMtoPago,0)            + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local    - nMtoDescD_Local  + NVL(nRec_Local,0) - NVL(nDesc_Local,0)) / nNumPagos * NVL(nFact,0)/100;
               nMtoPagoMoneda      := NVL(nMtoPagoMoneda,0)      + (NVL(X.PrimaMoneda,0) + nMtoRecD_Moneda   - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) /nNumPagos* NVL(nFact,0)/100;
               nMtoComisiPag       := nMtoComisiPag              + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100) / nNumPagos * NVL(nFact,0)/100;
               nMtoComisiMonedaPag := NVL(nMtoComisiMonedaPag,0) + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100) / nNumPagos * NVL(nFact,0)/100;
            END IF;
            nPrimaRest           := NVL(nPrimaRest,0)     + (NVL(X.PrimaLocal,0)  + nMtoRecD_Local     - nMtoDescD_Local + NVL(nRec_Local,0) - NVL(nDesc_Local,0) * NVL(nFact,0)/100) - NVL(nMtoPago,0);
            nMtoComisiRest       := NVL(nMtoComisiRest,0) + ((NVL(X.PrimaLocal,0) * X.PorcComis / 100 * NVL(nFact,0)/100) -  NVL(nMtoComisiPag,0));
            nTotPrimas           := NVL(nTotPrimas,0) * NVL(nFact,0)/100 + NVL(nMtoPago,0);
            nMtoComisi           := NVL(nMtoComisi,0)  + NVL(nMtoComisiPag,0);

            nPrimaRestMoneda     := NVL(nPrimaRestMoneda,0)     + (NVL(X.PrimaMoneda,0)  + nMtoRecD_Moneda    - nMtoDescD_Moneda + NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0) * NVL(nFact,0)/100) - NVL(nMtoPagoMoneda,0);
            nMtoComisiMonedaRest := NVL(nMtoComisiMonedaRest,0) + ((NVL(X.PrimaMoneda,0) * X.PorcComis / 100) -   NVL(nMtoComisiMonedaPag,0))* NVL(nFact,0)/100;
            nMtoComisiMoneda     := NVL(nMtoComisiMoneda,0)     + NVL(nMtoComisiMonedaPag,0);
            nTotPrimasMoneda     := NVL(nTotPrimasMoneda,0)* NVL(nFact,0)/100   + NVL(nMtoPagoMoneda,0);

            nPrimaMoneda         := NVL(nPrimaMoneda,0) + NVL(X.PrimaMoneda,0)* NVL(nFact,0)/100;
            nPrimaLocal          := NVL(nPrimaLocal,0)  + NVL(X.PrimaLocal,0)* NVL(nFact,0)/100;
            nMtoComiL            := NVL(nMtoComiL,0)    + (NVL(X.PrimaLocal,0)  * X.PorcComis / 100)* NVL(nFact,0)/100;
            nMtoComisiM          := NVL(nMtoComisiM,0)  + (NVL(X.PrimaMoneda,0) * X.PorcComis / 100)* NVL(nFact,0)/100;
         END LOOP;
         nPrimaRest           := NVL(nPrimaLocal,0)  - NVL(nMtoPago,0);
         nPrimaRestMoneda     := NVL(nPrimaMoneda,0) - NVL(nMtoPagoMoneda,0);
         nMtoComisiRest       := NVL(nMtoComiL,0)    - NVL(nMtoComisiPag,0);
         nMtoComisiMonedaRest := NVL(nMtoComisiM,0)  - NVL(nMtoComisiMonedaPag,0);

         nMtoT                := 0;

      --   FOR NP IN 1..nNumPagos LOOP
          NP := nCuota;
     -- nNumPagos := 12;
            IF NP > 1 THEN
               nMtoPago            := NVL(nPrimaRest,0)     / (nNumPagos - 1);
               nMtoComisiPag       := NVL(nMtoComisiRest,0) / (nNumPagos - 1);
               nTotPrimas          := NVL(nTotPrimas,0) + NVL(nMtoPago,0);
               nMtoComisi          := NVL(nMtoComisi,0) + NVL(nMtoComisiPag,0);
               IF nFrecPagos NOT IN (15,7) THEN
                  dFecPago         := ADD_MONTHS(dFecPago,nFrecPagos);
               ELSE
                  dFecPago         := dFecPago + nFrecPagos;
               END IF;
               nMtoPagoMoneda      := NVL(nPrimaRestMoneda,0)     / (nNumPagos - 1);
               nTotPrimasMoneda    := NVL(nTotPrimasMoneda,0)     +  NVL(nMtoPagoMoneda,0);
               nMtoComisiMonedaPag := NVL(nMtoComisiMonedaRest,0) / (nNumPagos - 1);
               nMtoComisiMoneda    := NVL(nMtoComisiMoneda,0) + NVL(nMtoComisiMonedaPag,0);
            END IF;
 --IF OC_generales.VALIDA_FECHA(dFecPago) = 'S' THEN
            -- LARPLA
            nIdFactura := OC_FACTURAS.INSERTAR(nIdPoliza,           nIdetPol,       nCodCliente, dFecPago, 
                                               nMtoPago,            nMtoPagoMoneda, nIdEndoso,   nMtoComisiPag, 
                                               nMtoComisiMonedaPag, NP,             nTasaCambio, nCod_Agente, 
                                               nCodTipoDoc,         pCodCia,        cCodMoneda,  J.CodResPago, 
                                               nTransa,             cIndFactElectronica);

            FOR W IN CPTO_PRIMAS_Q LOOP
               nFactor := (W.Prima_Local /nNumPagos) / NVL(nPrimaLocal,0);
               OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
               OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, W.CodCpto, 'S', nMtoPago * nFactor, nMtoPagoMoneda * nFactor);
            END LOOP;

            nTotAsistLocal  := 0;
            nTotAsistMoneda := 0;
            FOR K IN CPTO_ASIST_Q LOOP
               nAsistRestLocal  := 0;
               nAsistRestMoneda := 0;
               IF NVL(nPorcInicial,0) <> 0 THEN
                  nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) * nPorcInicial / 100) * NVL(nFact,0)/100;
                  nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) * nPorcInicial / 100) * NVL(nFact,0)/100;
               ELSE
                  nMtoAsistLocal  := (NVL(K.MontoAsistLocal,0) / nNumPagos) * NVL(nFact,0)/100;
                  nMtoAsistMoneda := (NVL(K.MontoAsistMoneda,0) / nNumPagos) * NVL(nFact,0)/100;
               END IF;
               /*nAsistRestLocal  := NVL(nAsistRestLocal,0) + (NVL(K.MontoAsistLocal,0) * NVL(nFact,0)/100) - nMtoAsistLocal;
               nAsistRestMoneda := NVL(nAsistRestMoneda,0) + (NVL(K.MontoAsistMoneda,0) * NVL(nFact,0)/100) - nMtoAsistMoneda;
               IF NP > 1 THEN
                  nMtoAsistLocal  := (NVL(nAsistRestLocal,0) / (nNumPagos - 1));
                  nMtoAsistMoneda := (NVL(nAsistRestMoneda,0) / (nNumPagos - 1));
               END IF;*/
               nTotAsistLocal  := NVL(nTotAsistLocal,0) + NVL(nMtoAsistLocal,0);
               nTotAsistMoneda := NVL(nTotAsistMoneda,0) + NVL(nMtoAsistMoneda,0);
               OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
               OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, K.CodCptoServicio, 'N', nMtoAsistLocal, nMtoAsistMoneda);
            END LOOP;

            nMtoT := nMtoT + nMtoPago;-- + NVL(nTotAsistLocal,0);

            PROC_COMISIONPOL (nIdPoliza, NULL, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFactura,
                              nMtoComisiPag/nNumCert, nMtoComisiMonedaPag/nNumCert, nTasaCambio);

            -- Distribuye la comision por agente.
            FOR Y IN CPTO_PLAN_Q LOOP
               BEGIN
                  SELECT 'S'
                    INTO cGraba
                    FROM RAMOS_CONCEPTOS_PLAN R
                   WHERE R.CodPlanPago = cCodPlanPago
                     AND R.CodCpto     = Y.CodCpto
                     AND R.CodCia      = nCodCia
                     AND R.CodEmpresa  = nCodEmpresa
                     AND EXISTS   (SELECT 1
                                     FROM DETALLE_POLIZA D, POLIZAS P
                                    WHERE D.IdPoliza   = P.IdPoliza
                                      AND D.IdTipoSeg  = R.IdTipoSeg
                                      AND P.StsPoliza IN ('SOL','XRE')
                                      AND P.IdPoliza   = nIdPoliza);
               EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     cGraba := 'N';
                  WHEN TOO_MANY_ROWS THEN
                     cGraba := 'S';
               END;

               IF cGraba = 'S' THEN
                  IF Y.Aplica = 'P' THEN
                     NULL; -- No Aplica para Endosos
                     /*IF NVL(Y.MtoCpto,0) <> 0 AND NP = 1 THEN
                        nMtoDet       := NVL(Y.MtoCpto,0);
                        nMtoDetMoneda := NVL(Y.MtoCpto,0) * nTasaCambio;
                     ELSIF NP = 1 THEN
                        nMtoDet       := (NVL(nPrimaLocal,0)+ nMtoRecD_Local - nMtoDescD_Local +
                                          NVL(nRec_Local,0) - NVL(nDesc_Local,0) + NVL(nTotAsistLocal,0)) * Y.PorcCpto / 100;
                        nMtoDetMoneda := (NVL(nPrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda +
                                          NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0) + NVL(nTotAsistMoneda,0)) * Y.PorcCpto / 100;
                     END IF;
                     IF NVL(nMtoDet,0) != 0 THEN
                        OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                     END IF;*/
                  ELSIF Y.Aplica = 'T' THEN
                     IF NVL(Y.MtoCpto,0) <> 0 THEN
                        nMtoDet       := NVL(Y.MtoCpto,0);
                        nMtoDetMoneda := NVL(Y.MtoCpto,0) * nTasaCambio;
                     ELSE
                        nMtoDet       := NVL(nMtoPago,0) * (nPorcCpto / 100);
                        nMtoDetMoneda := NVL(nMtoPagoMoneda,0) * (nPorcCpto / 100);
                     END IF;
                     IF NVL(nMtoDet,0) != 0 THEN
                        OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        OC_DETALLE_FACTURAS.AJUSTAR(nCodCia, nIdFactura, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
                        nMtoPago       := NVL(nMtoPago,0) + NVL(nMtoDet,0);
                        nMtoPagoMoneda := NVL(nMtoPagoMoneda,0) + NVL(nMtoDetMoneda,0);
                     END IF;
                  END IF;
                  nMtoT := nMtoT + nMtoDet;
               END IF;
            END LOOP;
         --   END IF;
            OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
        -- END LOOP;

         IF (NVL(nPrimaLocal,0)+ nMtoRecD_Local - nMtoDescD_Local + NVL(nRec_Local,0) -
             NVL(nDesc_Local,0)) <> NVL(nTotPrimas,0) THEN
            nDifer       := (NVL(nPrimaLocal,0) + nMtoRecD_Local  - nMtoDescD_Local   +
                             NVL(nRec_Local,0)  - NVL(nDesc_Local,0)) - NVL(nTotPrimas,0);
            nDiferMoneda := (NVL(nPrimaMoneda,0)+ nMtoRecD_Moneda - nMtoDescD_Moneda  +
                             NVL(nRec_Moneda,0) - NVL(nDesc_Moneda,0)) - NVL(nTotPrimasMoneda,0);
            nDiferC      :=  NVL(nMtoComiL,0)   - NVL(nMtoComisi,0);
            nDiferCMon   :=  NVL(nMtoComisiM,0) - NVL(nMtoComisiMoneda,0);

            PROC_COMISIONPOL (nIdPoliza, NULL, nCodCia, nCodEmpresa, cIdTipoSeg, cCodMoneda, nIdFactura,
                              nDiferC/nNumCert, nDiferCMon/nNumCert, nTasaCambio);

            OC_DETALLE_FACTURAS.ACTUALIZA_DIFERENCIA(nIdFactura, nDifer, nDiferMoneda);

            OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);

            UPDATE FACTURAS
               SET MtoComisi_Local   = MtoComisi_Local   + NVL(nDiferC,0),
                   MtoComisi_Moneda  = MtoComisi_Moneda  + NVL(nDiferCMon,0)
             WHERE IdFactura = nIdFactura;
         END IF;
         OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia,nIdFactura,'IVASIN');
      END LOOP;
      OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'FAC', 'FACTURAS',
                                   nIdPoliza, nIdetPol, NULL, NULL, nMtoT);
      OC_DETALLE_TRANSACCION.CREA (nTransa, nCodCia, nCodEmpresa, 7, 'COM', 'COMISIONES',
                                   nIdPoliza, nIdetPol, NULL, NULL, nMtoDet);
   END IF;
   BEGIN
      SELECT Contabilidad_Automatica
        INTO cContabilidad_Automatica
        FROM EMPRESAS
       WHERE CodCia = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cContabilidad_Automatica := 'N';
   END;
   IF cContabilidad_Automatica = 'S' THEN
      PROC_MOVCONTA(nCodCia, nIdPoliza, cCodMoneda, 'EMI');
   END IF;
END PROC_EMITE_FACT_ENDO_PERIODO;


--------------------------------------------------------------------
   -- Funcion para buscar el proximo numero de Facturas   ---
--------------------------------------------------------------------
 FUNCTION F_GET_FACT ( p_msg_regreso    out  nocopy varchar2 ) RETURN NUMBER AS


      vNumFACT        parametros_enum_fac.paen_cont_fin%type;
      vNombreTabla    varchar2(30);
      vIdProducto     number(6);


   BEGIN
    -- Buscar el nombre de la tabla de la cual se obtendra por la descripcion y la bandera
      select pa.pame_ds_numerador,
             pa.paem_id_producto
        into vNombreTabla,
             vIdProducto
        from PARAMETROS_EMISION pa
       where pa.paem_cd_producto   =  4
         and pa.paem_des_producto  = 'FACTURAS'
         and pa.paem_flag          =  1;

    -- Obtener el numero de facturas

     select pnf.paen_cont_fin
       into vNumFACT
       from parametros_enum_fac pnf
      where pnf.paen_id_fac = vIdProducto
        FOR UPDATE OF pnf.paen_cont_fin;

 --  Actualizar al siguiente numero
      update parametros_enum_fac pe
         set pe.paen_cont_fin = vNumFACT +1
       where pe.paen_id_fac  = vIdProducto;


 -- Hacer permanentes los cambios para evitar bloqueo de la tabla
       commit;


     return vNumFACT;


 EXCEPTION
      when no_data_found then
         p_msg_regreso := '.:: No se ha dado de alta '|| vNombreTabla ||' en PARAMETROS_EMISION ::.'||sqlerrm;
         dbms_output.put_line(p_msg_regreso);
         rollback;
        return 0;
      when others then
         p_msg_regreso := '.:: Error en "OC_UTILS.F_GET_FACT" .:: -> '||sqlerrm;
         dbms_output.put_line(p_msg_regreso);
         rollback;
         return 0;
 END F_GET_FACT;

END OC_FACTURAR;
/

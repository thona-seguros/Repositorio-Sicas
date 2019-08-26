--
-- OC_DETALLE_POLIZA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   POLIZAS (Table)
--   FACTURAS (Table)
--   FAI_FONDOS_DETALLE_POLIZA (Table)
--   FZ_DETALLE_FIANZAS (Table)
--   DATOS_PARTICULARES_BIENES (Table)
--   DATOS_PARTICULARES_PERSONAS (Table)
--   DATOS_PARTICULARES_VEHICULO (Table)
--   DETALLE_FACTURAS (Table)
--   DETALLE_NOTAS_DE_CREDITO (Table)
--   DETALLE_POLIZA (Table)
--   DETALLE_TRANSACCION (Table)
--   ENDOSOS (Table)
--   TASAS_CAMBIO (Table)
--   GT_FAI_TIPOS_FONDOS_PRODUCTOS (Package)
--   OC_DETALLE_NOTAS_DE_CREDITO (Package)
--   OC_DETALLE_TRANSACCION (Package)
--   AGENTES_DETALLES_POLIZAS (Table)
--   AGENTES_DISTRIBUCION_COMISION (Table)
--   AGENTE_POLIZA (Table)
--   ASEGURADO_CERT (Table)
--   ASEGURADO_CERTIFICADO (Table)
--   ASISTENCIAS (Table)
--   ASISTENCIAS_ASEGURADO (Table)
--   ASISTENCIAS_DETALLE_POLIZA (Table)
--   GT_FAI_FONDOS_DETALLE_POLIZA (Package)
--   NOTAS_DE_CREDITO (Table)
--   TIPOS_DE_SEGUROS (Table)
--   TRANSACCION (Table)
--   CATALOGO_DE_CONCEPTOS (Table)
--   CLAUSULAS (Table)
--   CLAUSULAS_DETALLE (Table)
--   CLAUSULAS_PLAN_COBERTURAS (Table)
--   CLAUSULAS_TIPOS_SEGUROS (Table)
--   COBERTURAS (Table)
--   COBERTURAS_DE_SEGUROS (Table)
--   COBERT_ACT (Table)
--   COBERT_ACT_ASEG (Table)
--   OC_FACTURAR (Package)
--   OC_FACTURAS (Package)
--   OC_TIPOS_DE_SEGUROS (Package)
--   OC_TRANSACCION (Package)
--   OC_ASEGURADO_CERTIFICADO (Package)
--   OC_ASISTENCIAS_ASEGURADO (Package)
--   OC_ASISTENCIAS_DETALLE_POLIZA (Package)
--   OC_BENEFICIARIO (Package)
--   OC_CLAUSULAS_COBERT_ACT (Package)
--   OC_CLAUSULAS_COBERT_ACT_ASEG (Package)
--   OC_CLAUSULAS_DETALLE (Package)
--   OC_COBERT_ACT (Package)
--   OC_COBERT_ACT_ASEG (Package)
--   OC_COMISIONES (Package)
--   OC_COMPROBANTES_CONTABLES (Package)
--   OC_GENERALES (Package)
--   OC_NOTAS_DE_CREDITO (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_DETALLE_POLIZA IS

  FUNCTION INSERTAR_DETALLE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                            cPlanCob VARCHAR2, nIdPoliza NUMBER, nTasaCambio NUMBER,
                            nPorcComis NUMBER, nCod_Asegurado NUMBER, cCodPlanPago VARCHAR2,
                            cNumDetRef VARCHAR2, cCodPromotor VARCHAR2,dFecIniVg DATE) RETURN NUMBER;

  PROCEDURE ACTUALIZA_VALORES(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER);

  PROCEDURE ANULAR_DETALLE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, dFecAnul DATE,
                           cMotivAnul VARCHAR2, cContabilidad_Automatica VARCHAR2, cCod_Moneda VARCHAR2,
                           cTipoProceso VARCHAR2);
  FUNCTION EXISTE_POLIZA_DETALLE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdpoliza NUMBER,cNumDetRef VARCHAR2) RETURN VARCHAR2;

  FUNCTION DECLARATIVA (nCodCia NUMBER, nCodEmpresa NUMBER,nIdPoliza NUMBER, nIDetPol NUMBER) RETURN VARCHAR2;

  FUNCTION TOTAL_PRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER;

  FUNCTION TOTAL_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER;

  PROCEDURE EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER,nIdPoliza NUMBER, nIDetPol NUMBER);

  PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER,nIdPoliza NUMBER, nIDetPol NUMBER);

  PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPolOrig NUMBER, nIDetPolDest NUMBER,
                   cCodFilialDest VARCHAR2, cCodCategoriaDest VARCHAR2, cIndIncluyeAseg VARCHAR2);

  PROCEDURE REHABILITAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER);

  PROCEDURE REHABILITACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER);

  PROCEDURE INSERTA_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER);
  
  FUNCTION FORMA_COBRO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER;

  FUNCTION MONTO_APORTE_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER;

END OC_DETALLE_POLIZA;
/

--
-- OC_DETALLE_POLIZA  (Package Body) 
--
--  Dependencies: 
--   OC_DETALLE_POLIZA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.oc_detalle_poliza IS
--
-- BITACORA DE CAMBIOS
-- SE AGREGO LA FUNCIONALIDAD PARA RENOVACION DE CLAUSULAS 10/08/2017  CLAUREN
--
FUNCTION INSERTAR_DETALLE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                          cPlanCob VARCHAR2, nIdPoliza NUMBER, nTasaCambio NUMBER,
                          nPorcComis NUMBER, nCod_Asegurado NUMBER, cCodPlanPago VARCHAR2,
                                  cNumDetRef VARCHAR2, cCodPromotor VARCHAR2,dFecIniVg DATE) RETURN NUMBER IS
nIDetPol     DETALLE_POLIZA.IDetPol%TYPE;
/*dFecSistema  DATE := TRUNC(SYSDATE);
dFecFinVig   DATE := ADD_MONTHS(TRUNC(SYSDATE),12);*/
dFecSistema  DATE := TRUNC(dFecIniVg);
dFecFinVig   DATE := ADD_MONTHS(TRUNC(dFecSistema),12);
BEGIN
   SELECT NVL(MAX(IDetPol),0)+1
     INTO nIDetPol
     FROM DETALLE_POLIZA
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdPoliza   = nIdPoliza;

   BEGIN
      INSERT INTO DETALLE_POLIZA
            (IdPoliza, IDetPol, CodCia, CodEmpresa, Cod_Asegurado,
             CodPlanPago, Suma_Aseg_Local, Suma_Aseg_Moneda,
             Prima_Local, Prima_Moneda, FecIniVig, FecFinVig,
             IdTipoSeg, Tasa_Cambio, PorcComis, PlanCob,
             MontoComis, NumDetRef, StsDetalle, FecAnul, MotivAnul,
             CodPromotor, MontoAporteFondo)
      VALUES(nIdPoliza, nIDetPol, nCodCia, nCodEmpresa, nCod_Asegurado,
             cCodPlanPago, 0, 0, 0, 0, dFecSistema, dFecFinVig,
             cIdTipoSeg, nTasaCambio, nPorcComis, cPlanCob,
             0, cNumDetRef, 'SOL', NULL, NULL, cCodPromotor, 0);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20225,'Ya Existe el Detalle de Póliza: '||TRIM(TO_CHAR(nIdPoliza))||
                                 '-'||TRIM(TO_CHAR(nIDetPol)));
   END;
   RETURN(nIDetPol);
END INSERTAR_DETALLE;

PROCEDURE ACTUALIZA_VALORES(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) IS
nSumaLocal          COBERTURAS.Suma_Asegurada_Local%TYPE;
nSumaMoneda         COBERTURAS.Suma_Asegurada_Moneda%TYPE;
nPrimaLocal         COBERTURAS.Prima_Local%TYPE;
nPrimaMoneda        COBERTURAS.Prima_Moneda%TYPE;
cIndDeclara         DETALLE_POLIZA.IndDeclara%TYPE;
cIndSinAseg         DETALLE_POLIZA.IndSinAseg%TYPE;
nMontoAsistLocal    ASISTENCIAS_ASEGURADO.MontoAsistLocal%TYPE;
nMontoAsistMoneda   ASISTENCIAS_ASEGURADO.MontoAsistMoneda%TYPE;

BEGIN
   SELECT NVL(SUM(SumaAseg_Local),0), NVL(SUM(SumaAseg_Moneda),0),
          NVL(SUM(Prima_Local),0), NVL(SUM(Prima_Moneda),0)
     INTO nSumaLocal, nSumaMoneda,
          nPrimaLocal, nPrimaMoneda
     FROM COBERT_ACT
    WHERE CodCia         = nCodCia
      AND IdPoliza       = nIdPoliza
      AND IDetPol        = nIDetPol
      AND StsCobertura NOT IN ('CEX');

   SELECT NVL(SUM(MontoAsistLocal),0), NVL(SUM(MontoAsistMoneda),0)
     INTO nMontoAsistLocal, nMontoAsistMoneda
     FROM ASISTENCIAS_DETALLE_POLIZA
   WHERE CodCia          = nCodCia
      AND IdPoliza        = nIdPoliza
      AND IDetPol         = nIDetPol
      AND StsAsistencia NOT IN ('EXCLUI');

   SELECT NVL(nSumaLocal,0) + NVL(SUM(SumaAseg_Local),0), NVL(nSumaMoneda,0) + NVL(SUM(SumaAseg_Moneda),0),
          NVL(nPrimaLocal,0) + NVL(SUM(Prima_Local),0), NVL(nPrimaMoneda,0) + NVL(SUM(Prima_Moneda),0)
     INTO nSumaLocal, nSumaMoneda,
          nPrimaLocal, nPrimaMoneda
     FROM COBERT_ACT_ASEG
    WHERE CodCia         = nCodCia
      AND IdPoliza       = nIdPoliza
      AND IDetPol        = nIDetPol
      AND StsCobertura NOT IN ('CEX');

   SELECT NVL(nMontoAsistLocal,0) + NVL(SUM(MontoAsistLocal),0),
          NVL(nMontoAsistMoneda,0) + NVL(SUM(MontoAsistMoneda),0)
     INTO nMontoAsistLocal, nMontoAsistMoneda
     FROM ASISTENCIAS_ASEGURADO
    WHERE CodCia          = nCodCia
      AND IdPoliza        = nIdPoliza
      AND IDetPol         = nIDetPol
      AND StsAsistencia NOT IN ('EXCLUI');

   UPDATE DETALLE_POLIZA
      SET Suma_Aseg_Local  = NVL(nSumaLocal,0),
          Suma_Aseg_Moneda = NVL(nSumaMoneda,0),
          Prima_Local      = NVL(nPrimaLocal,0) + NVL(nMontoAsistLocal,0),
          Prima_Moneda     = NVL(nPrimaMoneda,0) + NVL(nMontoAsistMoneda,0)
    WHERE CodCia    = nCodCia
      AND IdPoliza  = nIdPoliza
      AND IDetPol   = nIDetPol;
END ACTUALIZA_VALORES;

PROCEDURE ANULAR_DETALLE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, dFecAnul DATE,
                         cMotivAnul VARCHAR2, cContabilidad_Automatica VARCHAR2, cCod_Moneda VARCHAR2,
                         cTipoProceso VARCHAR2) IS
nIdTransaccion       TRANSACCION.IdTransaccion%TYPE;
nIdTransacNc         TRANSACCION.IdTransaccion%TYPE;
nIdTransacEmiNc      TRANSACCION.IdTransaccion%TYPE;
nPrima               POLIZAS.PrimaNeta_Local%TYPE;
nPrimaCanc           POLIZAS.PrimaNeta_Local%TYPE;
dFecIniVig           DETALLE_POLIZA.FecIniVig%TYPE;
dFecFinVig           DETALLE_POLIZA.FecFinVig%TYPE;
nPrima_Local         DETALLE_POLIZA.Prima_Local%TYPE;
nTotPrimaCanc        DETALLE_FACTURAS.Saldo_Det_Local%TYPE;
nIdNcr               NOTAS_DE_CREDITO.IdNcr%TYPE;
nCodCliente          POLIZAS.CodCliente%TYPE;
nMtoNcrLocal         NOTAS_DE_CREDITO.Monto_NCR_Local%TYPE;
nMtoNcrMoneda        NOTAS_DE_CREDITO.Monto_NCR_Moneda%TYPE;
nMtoComisLocal       NOTAS_DE_CREDITO.MtoComisi_Local%TYPE;
nMtoComisMoneda      NOTAS_DE_CREDITO.MtoComisi_Moneda%TYPE;
nPorcComis           POLIZAS.PorcComis%TYPE;
cCodPlanPago         POLIZAS.CodPlanPago%TYPE;
nTasaCambio          TASAS_CAMBIO.Tasa_Cambio%TYPE;
dFecAnulReal         POLIZAS.FecAnul%TYPE;
nTotPrimaPag         FACTURAS.Monto_Fact_Moneda%TYPE;
nTotPrimaEmit        FACTURAS.Monto_Fact_Moneda%TYPE;
cIndFactElectronica  POLIZAS.IndFactElectronica%TYPE;
nTotNotaCredCanc     DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nTotPrimaFact        DETALLE_FACTURAS.Saldo_Det_Moneda%TYPE;
cIdTipoSeg           DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob             DETALLE_POLIZA.PlanCob%TYPE;
nCod_Agente          AGENTE_POLIZA.Cod_Agente%TYPE;
nCod_Asegurado       DETALLE_POLIZA.Cod_Asegurado%TYPE;
nPorcPrima           NUMBER(10,6);
nDiasAnul            NUMBER(6);
nFactProrrata        NUMBER(11,8);
nFactor              NUMBER (14,8);
nDiasAno             NUMBER(6) := 365;
nDiasPagados         NUMBER(6);
cContabiliza         VARCHAR2(1);

CURSOR PRIMA_Q IS
   SELECT F.StsFact, F.IdFactura, NVL(D.Monto_Det_Moneda,0) Monto_Det_Moneda,
          D.Saldo_Det_Moneda, F.IdEndoso
     FROM DETALLE_FACTURAS D, FACTURAS F, CATALOGO_DE_CONCEPTOS C
    WHERE C.CodConcepto      = D.CodCpto
      AND C.CodCia           = F.CodCia
      AND (D.IndCptoPrima    = 'S'
       OR C.IndCptoServicio  = 'S')
      AND D.IdFactura        = F.IdFactura
      AND F.StsFact         != 'ANU'
      AND F.IdPoliza         = nIdPoliza
      AND F.IDetPol          = nIDetPol
      AND F.CodCia           = nCodCia;

CURSOR FAC_Q IS
   SELECT IdFactura, IDetPol, CodCia, Saldo_Local, CodCobrador
     FROM FACTURAS
    WHERE IdPoliza = nIdPoliza
      AND IDetPol  = nIDetPol
      AND StsFact = 'EMI';

CURSOR NCR_Q IS
   SELECT IdNcr, CodCia, IdPoliza, IDetPol, IdEndoso
     FROM NOTAS_DE_CREDITO
    WHERE IdPoliza = nIdPoliza
      AND IDetPol  = nIDetPol
      AND StsNcr   = 'EMI';

CURSOR CPTO_PRIMAS_Q IS
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERT_ACT C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert   = C.CodCobert
      AND CS.PlanCob     = C.PlanCob
      AND CS.IdTipoSeg   = C.IdTipoSeg
      AND CS.CodEmpresa  = C.CodEmpresa
      AND CS.CodCia      = C.CodCia
      AND C.StsCobertura = 'EMI'
      AND C.IDetPol      = nIDetPol
      AND C.IdPoliza     = nIdPoliza
      AND C.CodCia       = nCodCia
    GROUP BY CS.CodCpto
    UNION
   SELECT CS.CodCpto, SUM(C.Prima_Local) Prima_Local, SUM(C.Prima_Moneda) Prima_Moneda
     FROM COBERT_ACT_ASEG C, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert   = C.CodCobert
      AND CS.PlanCob     = C.PlanCob
      AND CS.IdTipoSeg   = C.IdTipoSeg
      AND CS.CodEmpresa  = C.CodEmpresa
      AND CS.CodCia      = C.CodCia
      AND C.StsCobertura = 'EMI'
      AND C.IDetPol      = nIDetPol
      AND C.IdPoliza     = nIdPoliza
      AND C.CodCia       = nCodCia
    GROUP BY CS.CodCpto;

CURSOR CPTO_ASIST_Q IS
   SELECT T.CodCptoServicio, SUM(A.MontoAsistLocal) MontoAsistLocal,
          SUM(A.MontoAsistMoneda) MontoAsistMoneda
     FROM ASISTENCIAS_DETALLE_POLIZA A, DETALLE_POLIZA D, ASISTENCIAS T
    WHERE T.CodAsistencia  = A.CodAsistencia
      AND D.IDetPol        = A.IDetPol
      AND D.IdPoliza       = A.IdPoliza
      AND D.CodCia         = A.CodCia
      AND A.IDetPol        = nIDetPol
      AND A.StsAsistencia  = 'EMITID'
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
      AND A.IDetPol        = nIDetPol
      AND A.StsAsistencia  = 'EMITID'
      AND A.IdPoliza       = nIdPoliza
      AND A.CodCia         = nCodCia
    GROUP BY T.CodCptoServicio;

CURSOR ASEG_Q IS
   SELECT IDetPol, Cod_Asegurado
     FROM ASEGURADO_CERTIFICADO
    WHERE IdPoliza = nIdPoliza
      AND nIDetPol = nIDetPol
      AND CodCia   = nCodCia
      AND Estado   = 'EMI';

CURSOR FONDOS_Q IS -- GTC - 17-12-2018
   SELECT CodAsegurado, IdFondo
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE StsFondo      = 'EMITID'
      AND IDetPol       = nIDetPol
      AND IdPoliza      = nIdPoliza
      AND CodCia        = nCodCia;
BEGIN
   SELECT D.FecIniVig, D.FecFinVig, P.CodCliente, D.IndFactElectronica, D.PlanCob, 
          D.PorcComis, D.CodPlanPago, D.Prima_Local, IdTipoSeg, Cod_Asegurado
     INTO dFecIniVig, dFecFinVig, nCodCliente, cIndFactElectronica, cPlanCob,
          nPorcComis, cCodPlanPago, nPrima_Local, cIdTipoSeg, nCod_Asegurado
     FROM DETALLE_POLIZA D, POLIZAS P
    WHERE P.IdPoliza      = D.IdPoliza
      AND P.CodCia        = D.CodCia
      AND D.IDetPol       = nIDetPol
      AND D.IdPoliza      = nIdPoliza
      AND D.CodCia        = nCodCia;

   -- Calcula Fecha de Anulación para NO Devolver Prima
   nDiasAno      := TRUNC(dFecFinVig) - TRUNC(dFecIniVig);

   nTotPrimaPag  := 0;
   nTotPrimaEmit := 0;

   FOR W IN PRIMA_Q LOOP
      nTotPrimaEmit    := NVL(nTotPrimaEmit,0) + W.Monto_Det_Moneda;
      IF W.StsFact IN ('PAG','ABO') THEN
         nTotPrimaPag  := NVL(nTotPrimaPag,0) + (W.Monto_Det_Moneda - W.Saldo_Det_Moneda);
      END IF;
   END LOOP;

   nDiasPagados   := ROUND(nTotPrimaPag / (nTotPrimaEmit / nDiasAno));
   IF NVL(nDiasPagados,0) != 0 AND cTipoProceso != 'DETALLE' THEN
      dFecAnulReal   := dFecIniVig + nDiasPagados;
   ELSE
      dFecAnulReal   := dFecAnul;
   END IF;

   nDiasAnul      := nDiasPagados;
   nFactProrrata  := OC_GENERALES.PRORRATA(dFecIniVig, dFecFinVig, dFecAnulReal);
   nPrimaCanc     := nTotPrimaEmit * nFactProrrata;

   IF NVL(nTotPrimaPag,0) = 0 THEN
      -- Anula Notas de Crédito
      FOR X IN NCR_Q LOOP
         IF NVL(nIdTransacNc,0) = 0 THEN
            nIdTransacNc := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 8, 'ANUNCR');
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
            AND N.IdNcr            = X.IdNcr;

         OC_NOTAS_DE_CREDITO.ANULAR(X.IdNcr, dFecAnulReal, cMotivAnul, nIdTransacNc);

         OC_DETALLE_TRANSACCION.CREA(nIdTransacNc, nCodCia,  nCodEmpresa, 8, 'ANUNCR', 'NOTAS_DE_CREDITO',
                                     nIdPoliza, X.IDetPol, X.IdEndoso, X.IdNcr, nTotNotaCredCanc);
      END LOOP;

      IF NVL(nIdTransacNc,0) != 0 THEN
         OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacNc, 'C');
      END IF;
   END IF;

   cContabiliza   := 'N';
   nIdTransaccion := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 2, 'CER');

   OC_DETALLE_TRANSACCION.CREA (nIdTransaccion, nCodCia,  nCodEmpresa, 2, 'CER', 'DETALLE_POLIZA',
                                nIdPoliza, nIDetPol, NULL, NULL, nPrimaCanc);

   IF cContabilidad_Automatica = 'S' THEN
      OC_FACTURAR.PROC_MOVCONTA(nCodCia, nIdPoliza, cCod_Moneda, 'ANU');
   END IF;
   --
   nTotPrimaCanc := 0;
   FOR X IN FAC_Q LOOP
      -- Acumula Prima Anulada
      SELECT NVL(SUM(Saldo_Det_Moneda),0)
        INTO nTotPrimaFact
        FROM DETALLE_FACTURAS D, FACTURAS F, CATALOGO_DE_CONCEPTOS C
       WHERE C.CodConcepto      = D.CodCpto
         AND C.CodCia           = F.CodCia
         AND (D.IndCptoPrima    = 'S'
          OR C.IndCptoServicio  = 'S')
         AND D.IdFactura        = F.IdFactura
         AND F.IdFactura        = X.IdFactura;

          nTotPrimaCanc := NVL(nTotPrimaCanc,0) + NVL(nTotPrimaFact,0);
          OC_FACTURAS.ANULAR(X.CodCia, X.IdFactura, dFecAnulReal, cMotivAnul, X.CodCobrador, nIdTransaccion);
          OC_DETALLE_TRANSACCION.CREA (nIdTransaccion, nCodCia,  nCodEmpresa, 2, 'FAC', 'FACTURAS',
                                       nIdPoliza, X.IDetPol, NULL, X.IdFactura, NVL(nTotPrimaFact,0));
          cContabiliza := 'S';
   END LOOP;

   IF cContabiliza = 'S' THEN
      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');
   END IF;

   cContabiliza := 'N';
   IF nTotPrimaCanc != nPrimaCanc  AND NVL(nPrimaCanc,0) > NVL(nTotPrimaCanc,0) THEN
      SELECT MIN(Cod_Agente)
        INTO nCod_Agente
        FROM AGENTES_DETALLES_POLIZAS
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND Ind_Principal = 'S';

      IF NVL(nIdTransacEmiNc,0) = 0 THEN
         nIdTransacEmiNc := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 2, 'NOTACR');
      END IF;

      nTasaCambio    := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(SYSDATE));
      nMtoNcrLocal    := NVL(nPrimaCanc,0) - NVL(nTotPrimaCanc,0);
      nMtoNcrMoneda   := NVL(nMtoNcrLocal,0) * nTasaCambio;
      nMtoComisLocal  := NVL(nMtoNcrLocal,0) * (NVL(nPorcComis,0) / 100);
      nMtoComisMoneda := NVL(nMtoNcrMoneda,0) * (NVL(nPorcComis,0) / 100);

      cContabiliza := 'S';
      nIdNcr := OC_NOTAS_DE_CREDITO.INSERTA_NOTA_CREDITO(nCodCia, nIdPoliza, nIDetPol, 0, nCodCliente, TRUNC(SYSDATE),
                                                         nMtoNcrLocal, nMtoNcrMoneda, nMtoComisLocal, nMtoComisMoneda,
                                                         nCod_Agente, cCod_Moneda, nTasaCambio, nIdTransacEmiNc, cIndFactElectronica);
      FOR W IN CPTO_PRIMAS_Q LOOP
         nFactor := W.Prima_Moneda / NVL(nTotPrimaEmit,0);
         OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, W.CodCpto, 'S', nMtoNcrLocal * nFactor, nMtoNcrMoneda * nFactor);
         OC_DETALLE_NOTAS_DE_CREDITO.AJUSTAR(nCodCia, nIdNcr, W.CodCpto, 'S', nMtoNcrLocal * nFactor, nMtoNcrMoneda * nFactor);
         OC_DETALLE_NOTAS_DE_CREDITO.APLICAR_RETENCION(nCodCia, nCodEmpresa, cIdTipoSeg, dFecAnulReal,
                                                       nDiasAnul, cMotivAnul, nIdNcr, W.CodCpto);
      END LOOP;

      FOR K IN CPTO_ASIST_Q LOOP
         nFactor := K.MontoAsistMoneda / NVL(nTotPrimaEmit,0);
         OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, K.CodCptoServicio, 'N', nMtoNcrLocal * nFactor, nMtoNcrMoneda * nFactor);
         OC_DETALLE_NOTAS_DE_CREDITO.AJUSTAR(nCodCia, nIdNcr, K.CodCptoServicio, 'N', nMtoNcrLocal * nFactor, nMtoNcrMoneda * nFactor);
         OC_DETALLE_NOTAS_DE_CREDITO.APLICAR_RETENCION(nCodCia, nCodEmpresa, cIdTipoSeg, dFecAnulReal,
                                                       nDiasAnul, cMotivAnul, nIdNcr, K.CodCptoServicio);
      END LOOP;

      OC_DETALLE_NOTAS_DE_CREDITO.GENERA_CONCEPTOS(nCodCia, nCodEmpresa, cCodPlanPago, cIdTipoSeg,
                                                   nIdNcr, nTasaCambio);
      OC_NOTAS_DE_CREDITO.ACTUALIZA_NOTA(nIdNcr);
      OC_NOTAS_DE_CREDITO.EMITIR(nIdNcr, NULL);
      OC_COMISIONES.INSERTA_COMISION_NC(nIdNcr);
      OC_DETALLE_TRANSACCION.CREA (nIdTransacEmiNc, nCodCia,  nCodEmpresa, 2, 'NOTACR', 'NOTAS_DE_CREDITO',
                                   nIdPoliza, nIDetPol, 0, nIdNcr, nMtoNcrMoneda);
   END IF;

   IF cContabiliza = 'S' THEN
      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacEmiNc, 'C');
   END IF;

   UPDATE ENDOSOS
      SET StsEndoso = 'ANU',
          FecAnul   = dFecAnulReal,
          MotivAnul = cMotivAnul,
          FecSts    = TRUNC(SYSDATE)
    WHERE IdPoliza   = nIdPoliza
      AND IdetPol    = nIDetPol
      AND CodCia     = nCodCia
      AND StsEndoso != 'SOL';

   UPDATE DETALLE_POLIZA
      SET StsDetalle = 'ANU',
          FecAnul    = dFecAnulReal,
          MotivAnul  = cMotivAnul
    WHERE IdPoliza   = nIdPoliza
      AND IdetPol    = nIDetPol
      AND CodCia     = nCodCia;

   IF OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(nCodCia, nCodEmpresa, cIdTipoSeg) = 'S' THEN -- GTC - 06/02/2019
      IF GT_FAI_TIPOS_FONDOS_PRODUCTOS.FONDOS_COLECTIVOS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob) = 'N' THEN  
         IF cMotivAnul != 'REEX' THEN
            IF NVL(nTotPrimaPag,0) = 0 THEN
               FOR F IN FONDOS_Q LOOP
                  GT_FAI_FONDOS_DETALLE_POLIZA.ANULAR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, F.CodAsegurado, F.IdFondo, dFecAnulReal);
               END LOOP;
            END IF;
         ELSE
            GT_FAI_FONDOS_DETALLE_POLIZA.ANULAR_POR_REEXPEDICION(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado, dFecAnulReal);
         END IF;
      END IF;
   END IF;

   OC_COBERT_ACT.ANULAR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol);
   OC_ASISTENCIAS_DETALLE_POLIZA.ANULAR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol);
   OC_BENEFICIARIO.ANULAR(nIdPoliza, nIDetPol, nCod_Asegurado);

   FOR Z IN ASEG_Q LOOP
      OC_ASISTENCIAS_ASEGURADO.ANULAR(nCodCia, nCodEmpresa, nIdPoliza, Z.IDetPol, Z.Cod_Asegurado);
      OC_ASEGURADO_CERTIFICADO.ANULAR(nCodCia, nIdPoliza, Z.IDetPol, Z.Cod_Asegurado, dFecAnulReal, cMotivAnul);
      OC_COBERT_ACT_ASEG.ANULAR(nCodCia, nCodEmpresa, nIdPoliza, Z.IDetPol, Z.Cod_Asegurado);
      OC_BENEFICIARIO.ANULAR(nIdPoliza, Z.IDetPol, Z.Cod_Asegurado);
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al Anular Detalle de Póliza: '||TRIM(TO_CHAR(nIdPoliza))||
                                 '-'||TRIM(TO_CHAR(nIDetPol))|| ' ' ||SQLERRM);
END ANULAR_DETALLE;

FUNCTION EXISTE_POLIZA_DETALLE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdpoliza NUMBER,cNumDetRef VARCHAR2) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM DETALLE_POLIZA
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdPoliza    = nIdpoliza
         AND NumDetRef   = cNumDetRef;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
  END;
  RETURN(cExiste);
END EXISTE_POLIZA_DETALLE;

FUNCTION DECLARATIVA (nCodCia NUMBER, nCodEmpresa NUMBER,nIdPoliza NUMBER, nIDetPol NUMBER) RETURN VARCHAR2 IS
cIndDeclara DETALLE_POLIZA.IndDeclara%TYPE;
BEGIN
   BEGIN
      SELECT IndDeclara
        INTO cIndDeclara
        FROM DETALLE_POLIZA
       WHERE IdPoliza    = nIdPoliza
         AND IdetPol     = nIdetPol
         AND CodEmpresa  = nCodEmpresa
         AND CodCia      = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndDeclara := 'N';
      WHEN TOO_MANY_ROWS THEN
        cIndDeclara  := 'S';
   END;
   RETURN (cIndDeclara);
END DECLARATIVA;

FUNCTION TOTAL_PRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER IS
nPrimaTotal      DETALLE_POLIZA.Prima_Moneda%TYPE;
BEGIN
   SELECT SUM(D.Prima_Moneda)
     INTO nPrimaTotal
     FROM DETALLE_POLIZA D
    WHERE D.StsDetalle IN ('SOL','XRE','EMI')
      AND D.IDetPoL    = nIDetPol
      AND D.IdPoliza   = nIdPoliza;
   RETURN(nPrimaTotal);
END TOTAL_PRIMA;

FUNCTION TOTAL_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER IS
nTotalAseg      NUMBER(10);
BEGIN
   SELECT COUNT(*)
     INTO nTotalAseg
     FROM ASEGURADO_CERTIFICADO AC, DETALLE_POLIZA D
    WHERE AC.CodCia        = D.CodCia
      AND AC.IdPoliza      = D.IdPoliza
      AND AC.IDetPol       = D.IDetPol
      AND AC.Cod_Asegurado = D.Cod_Asegurado
      AND AC.Estado       IN ('SOL','XRE','EMI')
      AND D.IdPoliza       = nIdPoliza
      AND D.IDetPol        = nIDetPol
      AND D.CodCia         = nCodCia;

   SELECT NVL(SUM(CantAsegModelo),0) + NVL(nTotalAseg,0)
     INTO nTotalAseg
     FROM TIPOS_DE_SEGUROS TS, DETALLE_POLIZA D
    WHERE TS.IdTipoSeg    = D.IdTipoSeg
      AND TS.CodEmpresa   = D.CodEmpresa
      AND TS.CodCia       = D.CodCia
      AND TS.TipoSeg      = 'P'
      AND D.IndAsegModelo = 'S'
      AND D.StsDetalle   IN ('SOL','XRE','EMI')
      AND D.IdPoliza      = nIdPoliza
      AND D.IDetPol       = nIDetPol
      AND D.CodCia        = nCodCia;

   IF NVL(nTotalAseg,0) = 0 THEN
      SELECT COUNT(*)
        INTO nTotalAseg
        FROM TIPOS_DE_SEGUROS TS, DETALLE_POLIZA D
       WHERE TS.IdTipoSeg    = D.IdTipoSeg
         AND TS.CodEmpresa   = D.CodEmpresa
         AND TS.CodCia       = D.CodCia
         AND TS.TipoSeg      = 'P'
         AND D.IndAsegModelo = 'N'
         AND D.StsDetalle   IN ('SOL','XRE','EMI')
         AND D.IdPoliza      = nIdPoliza
         AND D.IDetPol       = nIDetPol
         AND D.CodCia        = nCodCia;
   END IF;
   RETURN(nTotalAseg);
END TOTAL_ASEGURADOS;

PROCEDURE EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) IS
BEGIN
   UPDATE DETALLE_POLIZA
      SET StsDetalle    = 'EMI'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol;
END EMITIR;

PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) IS
BEGIN
   UPDATE DETALLE_POLIZA
      SET StsDetalle    = 'SOL'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IdetPol       = nIDetPol;
END REVERTIR_EMISION;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPolOrig NUMBER, nIDetPolDest NUMBER,
                 cCodFilialDest VARCHAR2, cCodCategoriaDest VARCHAR2, cIndIncluyeAseg VARCHAR2) IS
nIDetPol       DETALLE_POLIZA.IDetPol%TYPE;
cTipoSeg       TIPOS_DE_SEGUROS.TipoSeg%TYPE;
Dummy          NUMBER(5);
dFecHoy        DATE  := TRUNC(SYSDATE);
NumRenovAnt    NUMBER(5);
nExiste        NUMBER(5);
nExisteFilial  NUMBER(5);

CURSOR DET_Q IS
   SELECT IdPoliza, IDetPol, Cod_Asegurado, CodCia, CodEmpresa, CodPlanPago, Suma_Aseg_Local,
          Suma_Aseg_Moneda, Prima_Local, Prima_Moneda, IdTipoSeg, Tasa_Cambio,
          PorcComis,  NULL CodContrato, NULL CodProyecto, NULL Cod_Moneda,
          PlanCob, MontoComis, NumDetRef, FecAnul, Motivanul, CodPromotor,
          IndDeclara, IndSinAseg, CodFilial, CodCategoria, IndFactElectronica,
          IndAsegModelo, CantAsegModelo, MontoComisH, PorcComisH, IdDirecAviCob,
          FecIniVig, FecFinVig, IdFormaCobro, MontoAporteFondo
     FROM DETALLE_POLIZA
    WHERE IDetPol  = nIDetPolOrig
      AND IdPoliza = nIdPoliza
      AND CodCia   = nCodCia
    UNION
   SELECT IdPoliza, Correlativo IDetPol, 0 Cod_Asegurado, CodCia, CodEmpresa, CodPlanPago,
          MontoLocal Suma_Aseg_Local, MontoMoneda Suma_Aseg_Moneda, PrimaLocal Prima_Local,
          PrimaMoneda Prima_Moneda, IdTipoSeg,0 Tasa_Cambio, PorcComis, CodContrato,
          CodProyecto, Cod_Moneda, NULL PlanCob, 0 MontoComis, NULL NumDetRef, NULL FecAnul,
          NULL Motivanul, NULL CodPromotor, NULL IndDeclara, NULL IndSinAseg, NULL CodFilial,
          NULL CodCategoria, NULL IndFactElectronica, NULL IndAsegModelo, NULL CantAsegModelo,
          NULL MontoComisH, NULL PorcComisH, NULL IdDirecAviCob, Inicio_Vigencia FecIniVig,
          Fin_Vigencia FecFinVig, 0 IdFormaCobro, 0 MontoAporteFondo
     FROM FZ_DETALLE_FIANZAS
    WHERE Correlativo = nIDetPolOrig
      AND IdPoliza    = nIdPoliza
      AND CodCia      = nCodCia;

CURSOR COB_Q IS
   SELECT DP.IdPoliza, CA.IDetPol, CA.CodEmpresa, CA.CodCia, DP.IdTipoSeg, CA.CodCobert,
          CA.SumaAseg_Moneda, CA.Prima_Moneda, TipoRef, CA.NumRef, CA.IdEndoso,
          CA.PlanCob, CA.Cod_Moneda, CA.Deducible_Local, CA.Deducible_Moneda,
          CA.Cod_Asegurado
     FROM COBERT_ACT CA, DETALLE_POLIZA DP
    WHERE DP.IDetPol  = CA.IDetPol
      AND DP.IdPoliza = CA.IdPoliza
      AND CA.IDetPol  = nIDetPolOrig
      AND CA.IdPoliza = nIdPoliza
      AND CA.CodCia   = nCodCia;

CURSOR PER_Q IS
   SELECT IdPoliza, IDetPol, Estatura, Peso, Cavidad_Toraxica_Min,
          Cavidad_Toraxica_Max, Capacidad_Abdominal,
          Presion_Arterial_Min, Presion_Arterial_Max,
          Pulso, Mortalidad, Suma_Aseg_Moneda, Suma_Aseg_Local,
          Extra_Prima_Moneda, Extra_Prima_Local, Id_Fumador,
          Observaciones, Porc_SubNormal, Prima_Local,
          Prima_Moneda
     FROM DATOS_PARTICULARES_PERSONAS
    WHERE IDetPol  = nIDetPolOrig
      AND IdPoliza = nIdPoliza
      AND CodCia   = nCodCia;

CURSOR BIEN_Q IS
   SELECT IdPoliza, Num_Bien, IDetPol, CodPais, CodEstado, CodCiudad,
          CodMunicipio, Ubicacion_Bien, Tipo_Bien,
          Suma_Aseg_Local_Bien, Suma_Aseg_Moneda_Bien,
          Prima_Neta_Local_Bien, Prima_Neta_Moneda_Bien
     FROM DATOS_PARTICULARES_BIENES
    WHERE IDetPol  = nIDetPolOrig
      AND IdPoliza = nIdPoliza
      AND CodCia   = nCodCia;

CURSOR AUTO_Q IS
   SELECT IdPoliza, IDetPol, Num_Vehi, Cod_Marca, Cod_Version,
          Cod_Modelo, Anio_Vehiculo, Placa,
          Cantidad_Pasajeros, Tarjeta_Circulacion,
          Color, Numero_Chasis, Numero_Motor,
          SumaAseg_Local, SumaAseg_Moneda,
          PrimaNeta_Local, PrimaNeta_Moneda
     FROM DATOS_PARTICULARES_VEHICULO
    WHERE IDetPol  = nIDetPolOrig
      AND IdPoliza = nIdPoliza
      AND CodCia   = nCodCia;

CURSOR AGENTES_Q IS
   SELECT IdPoliza, Cod_Agente, Ind_Principal, Porc_Comision, CodCia, Origen
     FROM AGENTES_DETALLES_POLIZAS
    WHERE IDetPol  = nIDetPolOrig
      AND IdPoliza = nIdPoliza
      AND CodCia   = nCodCia;

CURSOR AG_DET_Q IS
   SELECT CodCia, IdPoliza, CodNivel, Cod_Agente, Cod_Agente_Distr,
          Porc_Comision_Plan, Porc_Comision_Agente, Porc_Com_Distribuida,
          Porc_Com_Proporcional, Cod_Agente_Jefe, Origen
     FROM AGENTES_DISTRIBUCION_COMISION
    WHERE IDetPol  = nIDetPolOrig
      AND IdPoliza = nIdPoliza
      AND CodCia   = nCodCia;

CURSOR ASEG_CERT_Q IS
   SELECT CodCia, IdPoliza, Cod_Asegurado, FechaAlta, FechaBaja, CodEmpresa,
          SumaAseg, Primaneta
     FROM ASEGURADO_CERT
    WHERE IDetPol  = nIDetPolOrig
      AND IdPoliza = nIdPoliza
      AND CodCia   = nCodCia;

BEGIN
   FOR Y IN DET_Q LOOP
      nIDetPol := nIDetPolDest;
      BEGIN
         SELECT DISTINCT TipoSeg
           INTO cTipoSeg
           FROM TIPOS_DE_SEGUROS
          WHERE IdTipoSeg  = Y.IdTipoSeg
            AND CodCia     = nCodCia
            AND CodEmpresa = Y.CodEmpresa;
      END;
      BEGIN
         IF cTipoSeg != 'F' THEN
            INSERT INTO DETALLE_POLIZA
                  (IdPoliza, IDetPol, CodCia, Cod_Asegurado, CodEmpresa, CodPlanPago,
                   Suma_Aseg_Local, Suma_Aseg_Moneda, Prima_Local, Prima_Moneda,
                   FecIniVig, FecFinVig, IdTipoSeg,  Tasa_Cambio, PorcComis, StsDetalle,
                   PlanCob, MontoComis, NumDetRef, FecAnul, Motivanul, CodPromotor,
                   IndDeclara, IndSinAseg, CodFilial, CodCategoria, IndFactElectronica,
                   IndAsegModelo, CantAsegModelo, MontoComisH, PorcComisH, IdDirecAviCob, 
                   IdFormaCobro, MontoAporteFondo)
            VALUES(Y.IdPoliza, nIDetPol, Y.CodCia, Y.Cod_Asegurado, Y.CodEmpresa, Y.CodPlanPago,
                   Y.Suma_Aseg_Local, Y.Suma_Aseg_Moneda, Y.Prima_Local, Y.Prima_Moneda,
                   Y.FecIniVig, Y.FecFinVig, Y.IdTipoSeg, Y.Tasa_Cambio, Y.PorcComis, 'SOL',
                   Y.PlanCob, Y.MontoComis, Y.NumDetRef, Y.FecAnul, Y.Motivanul, Y.CodPromotor,
                   Y.IndDeclara, Y.IndSinAseg, cCodFilialDest, cCodCategoriaDest, Y.IndFactElectronica,
                   Y.IndAsegModelo, Y.CantAsegModelo, Y.MontoComisH, Y.PorcComisH, Y.IdDirecAviCob, 
                   Y.IdFormaCobro, Y.MontoAporteFondo);
         ELSE
            INSERT INTO FZ_DETALLE_FIANZAS
                  (IdPoliza, Correlativo, CodCia,  CodEmpresa, CodPlanPago,
                   MontoLocal, MontoMoneda, PrimaLocal, PrimaMoneda, Inicio_Vigencia,
                   Fin_Vigencia, IdTipoSeg, PorcComis,Estado, CodContrato, CodProyecto,
                   Cod_Moneda)
            VALUES(Y.IdPoliza, nIDetPol, nCodCia, Y.CodEmpresa,
                   Y.CodPlanPago, Y.Suma_Aseg_Local, Y.Suma_Aseg_Moneda, Y.Prima_Local,
                   Y.Prima_Moneda, Y.FecIniVig, Y.FecFinVig, Y.IdTipoSeg,
                   Y.PorcComis, 'SOL', Y.CodContrato, Y.CodProyecto, Y.Cod_Moneda);
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20225,'Error en Copiado de Nuevo Detalle de Póliza ' ||SQLERRM);
      END;

      FOR J IN AGENTES_Q LOOP
         INSERT INTO AGENTES_DETALLES_POLIZAS
                (IdPoliza, IdetPol, IdTiposeg, Cod_Agente, Porc_Comision,
                 Ind_Principal, CodCia, Origen)
         VALUES (J.IdPoliza, nIDetPol, Y.IdTiposeg, J.Cod_Agente, J.Porc_Comision,
                 J.Ind_Principal, J.CodCia, J.Origen);
      END LOOP;



      FOR W IN AG_DET_Q LOOP
         INSERT INTO AGENTES_DISTRIBUCION_COMISION
                (CodCia, IdPoliza, IdetPol, CodNivel, Cod_Agente, Cod_Agente_Distr,
                 Porc_Comision_Plan, Porc_Comision_Agente, Porc_Com_Distribuida,
                 Porc_Com_Proporcional, Cod_Agente_Jefe, Origen)
         VALUES (W.CodCia, W.IdPoliza, nIdetPol, W.CodNivel, W.Cod_Agente, W.Cod_Agente_Distr,
                 W.Porc_Comision_Plan, W.Porc_Comision_Agente, W.Porc_Com_Distribuida,
                 W.Porc_Com_Proporcional, W.Cod_Agente_Jefe, W.Origen);
      END LOOP;

      OC_BENEFICIARIO.COPIAR(nIdPoliza, nIDetPolOrig, Y.Cod_Asegurado, nIdPoliza, nIDetPol, Y.Cod_Asegurado);
      OC_CLAUSULAS_DETALLE.COPIAR(nCodCia, nIdPoliza, nIDetPolOrig, nIdPoliza, nIDetPolDest);

      IF OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(nCodCia, Y.CodEmpresa, Y.IdTipoSeg) = 'S' THEN -- GTC - 06/02/2019
         IF GT_FAI_TIPOS_FONDOS_PRODUCTOS.FONDOS_COLECTIVOS(nCodCia, Y.CodEmpresa, Y.IdTipoSeg, Y.PlanCob) = 'N' THEN  
            GT_FAI_FONDOS_DETALLE_POLIZA.COPIAR_FONDOS_CERTIFICADO(nCodCia, Y.CodEmpresa, nIdPoliza, nIDetPolOrig, Y.Cod_Asegurado, nIdPoliza, nIDetPolDest);
         END IF;
      END IF;
   END LOOP;

   IF cTipoSeg != 'F' THEN

      FOR Z IN COB_Q LOOP
         INSERT INTO COBERT_ACT
                (IdPoliza,  IDetPol, CodEmpresa, CodCia, CodCobert, StsCobertura,
                 SumaAseg_Local, SumaAseg_Moneda, Prima_Local, Prima_Moneda, Tasa,
                 IdEndoso, IdTipoSeg, TipoRef, NumRef, PlanCob, Cod_Moneda,
                 Deducible_Local, Deducible_Moneda, Cod_Asegurado)
         VALUES (Z.IdPoliza, nIDetPol, Z.CodEmpresa, Z.CodCia, Z.CodCobert, 'SOL',
                 Z.SumaAseg_Moneda, Z.SumaAseg_Moneda, Z.Prima_Moneda, Z.Prima_Moneda, NULL,
                 0, Z.IdTipoSeg, Z.TipoRef, Z.NumRef, Z.PlanCob, Z.Cod_Moneda,
                 Z.Deducible_Local, Z.Deducible_Moneda, Z.Cod_Asegurado);
      END LOOP;

      OC_ASISTENCIAS_DETALLE_POLIZA.COPIAR(nCodCia, nIdPoliza, nIDetPolOrig, nIdPoliza, nIDetPol);

      OC_CLAUSULAS_DETALLE.COPIAR(nCodCia, nIdPoliza, nIDetPolOrig, nIdPoliza, nIDetPol);
      OC_CLAUSULAS_COBERT_ACT.COPIAR(nCodCia, nIdPoliza, nIDetPolOrig, nIdPoliza, nIDetPol);


      FOR W IN PER_Q LOOP
         INSERT INTO DATOS_PARTICULARES_PERSONAS
               (IdPoliza, IDetPol, Estatura, Peso, Cavidad_Toraxica_Min,
                Cavidad_Toraxica_Max, Capacidad_Abdominal, Presion_Arterial_Min,
                Presion_Arterial_Max, Pulso, Mortalidad, Suma_Aseg_Moneda,
                Suma_Aseg_Local, Extra_Prima_Moneda, Extra_Prima_Local, Id_Fumador,
                Observaciones, Porc_SubNormal, Prima_Local, Prima_Moneda)
         VALUES(W.IdPoliza, nIDetPol, W.Estatura, W.Peso, W.Cavidad_Toraxica_Min,
                W.Cavidad_Toraxica_Max, W.Capacidad_Abdominal, W.Presion_Arterial_Min,
                W.Presion_Arterial_Max, W.Pulso, W.Mortalidad, W.Suma_Aseg_Moneda,
                W.Suma_Aseg_Local,  W.Extra_Prima_Moneda, W.Extra_Prima_Local, W.Id_Fumador,
                W.Observaciones, W.Porc_SubNormal, W.Prima_Local, W.Prima_Moneda);
      END LOOP;
      FOR B IN BIEN_Q LOOP
         INSERT INTO DATOS_PARTICULARES_BIENES
               (IdPoliza, Num_Bien, IDetPol, CodPais, CodEstado, CodCiudad,
                CodMunicipio, Ubicacion_Bien, Tipo_Bien, Suma_Aseg_Local_Bien,
                Suma_Aseg_Moneda_Bien,Prima_Neta_Local_Bien, Prima_Neta_Moneda_Bien,
                Inicio_Vigencia, Fin_Vigencia)
         VALUES(B.IdPoliza, B.Num_Bien, B.IDetPol, B.CodPais, B.CodEstado, B.CodCiudad,
                B.CodMunicipio, B.Ubicacion_Bien, B.Tipo_Bien, B.Suma_Aseg_Local_Bien,
                B.Suma_Aseg_Moneda_Bien, B.Prima_Neta_Local_Bien, B.Prima_Neta_Moneda_Bien,
                dFecHoy, ADD_MONTHS(dFecHoy,12));
      END LOOP;
      FOR A IN AUTO_Q LOOP
         INSERT INTO DATOS_PARTICULARES_VEHICULO
               (IdPoliza, IDetPol, Num_Vehi, Cod_Marca, Cod_Version,
                Cod_Modelo, Anio_Vehiculo, Placa, Cantidad_Pasajeros,
                Tarjeta_Circulacion, Color, Numero_Chasis, Numero_Motor,
                SumaAseg_Local, SumaAseg_Moneda, PrimaNeta_Local, PrimaNeta_Moneda)
         VALUES(A.IdPoliza, A.IDetPol, A.Num_Vehi, A.Cod_Marca, A.Cod_Version,
                A.Cod_Modelo, A.Anio_Vehiculo, A.Placa, A.Cantidad_Pasajeros,
                A.Tarjeta_Circulacion, A.Color, A.Numero_Chasis, A.Numero_Motor,
                A.SumaAseg_Local, A.SumaAseg_Moneda,  A.PrimaNeta_Local, A.PrimaNeta_Moneda);
      END LOOP;
      IF cIndIncluyeAseg = 'S' THEN
         FOR Q IN ASEG_CERT_Q LOOP
            INSERT INTO ASEGURADO_CERT
                   (CodCia, IdPoliza, IdetPol, Cod_Asegurado, FechaAlta, FechaBaja,
                    CodEmpresa, SumaAseg, Primaneta, Estado)
            VALUES (Q.CodCia, Q.IdPoliza, nIdetPol, Q.Cod_Asegurado, Q.FechaAlta, Q.FechaBaja,
                    Q.CodEmpresa, Q.SumaAseg, Q.Primaneta, 'SOL');
         END LOOP;

         OC_ASEGURADO_CERTIFICADO.COPIAR(nCodCia, nIdPoliza, nIDetPolOrig, nIdPoliza, nIDetPol);

         OC_COBERT_ACT_ASEG.COPIAR(nCodCia, nIdPoliza, nIDetPolOrig, nIdPoliza, nIDetPol);

         OC_ASISTENCIAS_ASEGURADO.COPIAR(nCodCia, nIdPoliza, nIDetPolOrig, nIdPoliza, nIDetPol);

         OC_CLAUSULAS_COBERT_ACT_ASEG.COPIAR(nCodCia, nIdPoliza, nIDetPolOrig, nIdPoliza, nIDetPol);

         OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIDetPol, 0);
      END IF;
   END IF;
END COPIAR;

PROCEDURE REHABILITAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) IS
BEGIN
   UPDATE DETALLE_POLIZA
      SET StsDetalle = 'EMI',
          Fecanul    = NULL,
          MotivAnul  = NULL
    WHERE IdPoliza   = nIdPoliza
      AND IDetPol    = nIDetPol
      AND StsDetalle = 'ANU';
END REHABILITAR;

PROCEDURE REHABILITACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) IS
nIdTransaccionAnu     FACTURAS.IdTransaccionAnu%TYPE;
nIdTransaccionAnuNc   FACTURAS.IdTransaccionAnu%TYPE;
nIdTransaccionEmiNc   FACTURAS.IdTransaccionAnu%TYPE;
nIdTransaccion        TRANSACCION.IdTransaccion%TYPE;
nPrimaNeta_Moneda     POLIZAS.PrimaNeta_Moneda%TYPE;
cStsDetalle           DETALLE_POLIZA.StsDetalle%TYPE;
dFecAnul              POLIZAS.FecAnul%TYPE;
nIdTransacNc          TRANSACCION.IdTransaccion%TYPE;
nIdTransacNcRehab     TRANSACCION.IdTransaccion%TYPE;
nTotNotaCredCanc      DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;

CURSOR ASEG_Q IS
   SELECT IDetPol, Cod_Asegurado
     FROM ASEGURADO_CERTIFICADO
    WHERE IdPoliza = nIdPoliza
      AND IDetPol  = nIDetPol;

CURSOR DET_Q IS
   SELECT IDetPol, Cod_Asegurado
     FROM DETALLE_POLIZA
    WHERE IdPoliza   = nIdPoliza
      AND CodCia     = nCodCia
      AND IDetPol    = nIDetPol;

CURSOR FACT_Q IS
   SELECT IdFactura
     FROM FACTURAS
    WHERE IdTransaccionAnu = nIdTransaccionAnu
      AND IdPoliza         = nIdPoliza
      AND IDetPol          = nIDetPol
    ORDER BY IdFactura;

CURSOR NCR_Q IS
   SELECT IdNcr, CodCia, IdPoliza, IDetPol, IdEndoso
     FROM NOTAS_DE_CREDITO
    WHERE IdPoliza      = nIdPoliza
      AND IdTransaccion = nIdTransaccionEmiNc
      AND IDetPol       = nIDetPol
      AND StsNcr        = 'EMI';

CURSOR NCR_ANU_Q IS
   SELECT IdNcr, CodCia, IdPoliza, IDetPol, IdEndoso
     FROM NOTAS_DE_CREDITO
    WHERE IdPoliza         = nIdPoliza
      AND IDetPol          = nIDetPol
      AND IdTransaccionAnu = nIdTransaccionAnuNc;
BEGIN
   BEGIN
      SELECT StsDetalle, Prima_Moneda, FecAnul
        INTO cStsDetalle, nPrimaNeta_Moneda, dFecAnul
        FROM DETALLE_POLIZA
       WHERE CodCia    = nCodCia
         AND IdPoliza  = nIdPoliza
         AND IDetPol   = nIDetPol;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO existe el Certificado/Subgrupo No. ' || TRIM(TO_CHAR(nIDetPol)) || ' para Rehabilitarlo');
   END;

   IF cStsDetalle = 'ANU' THEN
      FOR W IN DET_Q LOOP
         OC_DETALLE_POLIZA.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol);
         OC_COBERT_ACT.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol);
         OC_ASISTENCIAS_DETALLE_POLIZA.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol);
         OC_BENEFICIARIO.REHABILITAR(nIdPoliza, W.IDetPol, W.Cod_Asegurado);
      END LOOP;

      FOR X IN ASEG_Q LOOP
         OC_ASEGURADO_CERTIFICADO.REHABILITAR(nCodCia, nIdPoliza, X.IdetPol, X.Cod_Asegurado);
         OC_COBERT_ACT_ASEG.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, X.IdetPol, X.Cod_Asegurado);
         OC_ASISTENCIAS_ASEGURADO.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, X.IdetPol, X.Cod_Asegurado);
         OC_BENEFICIARIO.REHABILITAR(nIdPoliza, X.IDetPol, X.Cod_Asegurado);
      END LOOP;

      UPDATE ENDOSOS
         SET StsEndoso = 'EMI',
             FecAnul   = NULL,
             MotivAnul = NULL,
             FecSts    = TRUNC(SYSDATE)
       WHERE IdPoliza  = nIdPoliza
         AND IDetPol   = nIDetPol
         AND StsEndoso = 'ANU'
         AND FecAnul   = dFecAnul;

      -- Rehabilita Facturas Anuladas
      SELECT MAX(T.IdTransaccion)
        INTO nIdTransaccionAnu
        FROM TRANSACCION T, DETALLE_TRANSACCION D
       WHERE D.CodSubProceso     = 'FAC'
         AND D.CodCia            = nCodCia
         AND D.CodEmpresa        = nCodEmpresa
         AND TO_NUMBER(D.Valor1) = nIdPoliza
         AND TO_NUMBER(D.Valor2) = nIDetPol
         AND D.Valor3           IS NULL
         AND T.IdTransaccion     = D.IdTransaccion
         AND T.IdProceso         = 2;

      nIdTransaccion := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 18, 'REHAB');

      OC_DETALLE_TRANSACCION.CREA (nIdTransaccion, nCodCia,  nCodEmpresa, 18, 'REHAB', 'DETALLE_POLIZA',
                                   nIdPoliza, nIDetPol, NULL, NULL, nPrimaNeta_Moneda);

      FOR W IN FACT_Q LOOP
         OC_FACTURAS.REHABILITACION(nCodCia, nCodEmpresa, W.IdFactura, nIdTransaccion);
      END LOOP;

      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');

      -- Rehabilita Notas de Crédito Anuladas
      SELECT MAX(T.IdTransaccion)
        INTO nIdTransaccionAnuNc
        FROM TRANSACCION T, DETALLE_TRANSACCION D
       WHERE D.CodSubProceso     = 'ANUNCR'
         AND D.CodCia            = nCodCia
         AND D.CodEmpresa        = nCodEmpresa
         AND TO_NUMBER(D.Valor1) = nIdPoliza
         AND TO_NUMBER(D.Valor2) = nIDetPol
         AND T.IdTransaccion     = D.IdTransaccion
         AND T.IdProceso         = 8;

      FOR W IN NCR_ANU_Q LOOP
         IF NVL(nIdTransacNcRehab,0) = 0 THEN
            nIdTransacNcRehab := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 18, 'REHNCR');
         END IF;

         OC_NOTAS_DE_CREDITO.REHABILITACION(nCodCia, nCodEmpresa, W.IdNcr, nIdTransacNcRehab);
      END LOOP;

      IF nIdTransacNcRehab != 0 THEN
         OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacNcRehab, 'C');
      END IF;

      -- Anula Notas de Crédito de la Anulación
      SELECT MAX(T.IdTransaccion)
        INTO nIdTransaccionEmiNc
        FROM TRANSACCION T, DETALLE_TRANSACCION D
       WHERE D.CodSubProceso     = 'NOTACR'
         AND D.CodCia            = nCodCia
         AND D.CodEmpresa        = nCodEmpresa
         AND TO_NUMBER(D.Valor1) = nIdPoliza
         AND TO_NUMBER(D.Valor2) = nIDetPol
         AND T.IdTransaccion     = D.IdTransaccion
         AND T.IdProceso         = 2;

      FOR X IN NCR_Q LOOP
         IF NVL(nIdTransacNc,0) = 0 THEN
            nIdTransacNc := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 8, 'ANUNCR');
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
            AND N.IdNcr            = X.IdNcr;

         OC_NOTAS_DE_CREDITO.ANULAR(X.IdNcr, TRUNC(SYSDATE), 'REHAB', nIdTransacNc);

         OC_DETALLE_TRANSACCION.CREA(nIdTransacNc, nCodCia,  nCodEmpresa, 8, 'ANUNCR', 'NOTAS_DE_CREDITO',
                                     nIdPoliza, X.IDetPol, X.IdEndoso, X.IdNcr, nTotNotaCredCanc);
      END LOOP;

      IF NVL(nIdTransacNc,0) != 0 THEN
         OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacNc, 'C');
      END IF;
   ELSE
      RAISE_APPLICATION_ERROR(-20225,'El Certificado/Subgrupo No. ' || TRIM(TO_CHAR(nIDetPol)) ||
                              ' de la Póliza No. ' || TRIM(TO_CHAR(nIdPoliza)) || ' NO está Anulado para Rehabilitarse');
   END IF;
END REHABILITACION;

PROCEDURE INSERTA_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) IS
nIDetPol        DETALLE_POLIZA.IDetPol%TYPE;
cIdTipoSeg      DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob        DETALLE_POLIZA.PlanCob%TYPE;
nCod_Clausula   CLAUSULAS_DETALLE.Cod_Clausula%TYPE;
cTextoClausula  CLAUSULAS.TextoClausula%TYPE;

CURSOR DET_Q IS
   SELECT DISTINCT IDetPol, IdTipoSeg, PlanCob, FecIniVig, FecFinVig
     FROM DETALLE_POLIZA
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdPoliza   = nIdPoliza;

CURSOR CLAU_Q IS
   SELECT C.CodClausula
     FROM CLAUSULAS_TIPOS_SEGUROS CTS, CLAUSULAS C
    WHERE CTS.IdTipoSeg   = cIdTipoSeg
      AND CTS.CodCia      = nCodCia
      AND CTS.CodEmpresa  = nCodEmpresa
      AND CTS.IDRENOVACION = 'N'  --CLAUREN
      AND C.CodClausula   = CTS.CodClausula
      AND C.CodCia        = CTS.CodCia
      AND C.CodEmpresa    = CTS.CodEmpresa
      AND C.StsClausula   = 'ACTIVA'
      AND C.IndOblig      = 'S'
    UNION
   SELECT C.CodClausula
     FROM CLAUSULAS_PLAN_COBERTURAS CTS, CLAUSULAS C
   WHERE CTS.PlanCob     = cPlanCOb
      AND CTS.IdTipoSeg   = cIdTipoSeg
      AND CTS.CodCia      = nCodCia
      AND CTS.CodEmpresa  = nCodEmpresa
      AND CTS.IDRENOVACION = 'N'  --CLAUREN
      AND C.CodClausula   = CTS.CodClausula
      AND C.CodCia        = CTS.CodCia
      AND C.CodEmpresa    = CTS.CodEmpresa
      AND C.StsClausula   = 'ACTIVA'
      AND C.IndOblig      = 'S'
    MINUS
   SELECT CD.Tipo_Clausula
     FROM CLAUSULAS_DETALLE CD
    WHERE CD.IdPoliza  = nIdPoliza
      AND CD.IdeTpol   = nIDetPol
      AND CD.CodCia    = nCodCia;
BEGIN
   FOR Y IN DET_Q LOOP
      nIDetPol   := Y.IDetPol;
      cIdTipoSeg := Y.IdTipoSeg;
      cPlanCob   := Y.PlanCob;
      FOR X IN CLAU_Q LOOP
         SELECT NVL(MAX(Cod_Clausula),0) + 1
           INTO nCod_Clausula
           FROM CLAUSULAS_DETALLE
          WHERE CodCia    = nCodCia
            AND IdPoliza  = nIdPoliza
            AND IDetPol   = nIdetPol;

            BEGIN
               SELECT TextoClausula
                 INTO cTextoClausula
                 FROM CLAUSULAS
                WHERE CodCia      = nCodCia
                  AND CodEmpresa  = nCodEmpresa
                  AND CodClausula = X.CodClausula;
            EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    cTextoClausula := NULL;
            END;

         INSERT INTO CLAUSULAS_DETALLE
                (CodCia, IdPoliza, IDetpol, Cod_Clausula, Tipo_Clausula,
                 Texto, Inicio_Vigencia, Fin_Vigencia, Estado)
         VALUES (nCodCia, nIdPoliza, nIDetPol, nCod_Clausula, X.CodClausula,
                 cTextoClausula, Y.FecIniVig, Y.FecFinVig, 'SOLICI');
      END LOOP;
   END LOOP;
END INSERTA_CLAUSULAS;

FUNCTION FORMA_COBRO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER IS
nIdFormaCobro POLIZAS.IdFormaCobro%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IdFormaCobro,0)
        INTO nIdFormaCobro
        FROM DETALLE_POLIZA
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IdetPol       = nIDetPol;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nIdFormaCobro := 0;
   END;
   RETURN nIdFormaCobro;
END FORMA_COBRO;

FUNCTION MONTO_APORTE_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER IS
nMontoAporteFondo     DETALLE_POLIZA.MontoAporteFondo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MontoAporteFondo,0)
        INTO nMontoAporteFondo
        FROM DETALLE_POLIZA
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IdetPol       = nIDetPol;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMontoAporteFondo := 0;
   END;
   RETURN(nMontoAporteFondo);
END MONTO_APORTE_FONDOS;

END OC_DETALLE_POLIZA;
/

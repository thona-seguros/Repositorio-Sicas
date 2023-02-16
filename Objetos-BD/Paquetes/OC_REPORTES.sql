CREATE OR REPLACE PACKAGE OC_REPORTES IS

PROCEDURE FACTURAS_ELECTRONICAS_REC(cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, cCodMoneda VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE, dFecHasta DATE, dFecGenera DATE, cTipoReporte VARCHAR2);

PROCEDURE FACTURAS_ELECTRONICAS_NCR(cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, cCodMoneda VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE, dFecHasta DATE, dFecGenera DATE, cTipoReporte VARCHAR2);

END OC_REPORTES;

/

CREATE OR REPLACE PACKAGE BODY OC_REPORTES IS

PROCEDURE FACTURAS_ELECTRONICAS_REC(cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, cCodMoneda VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE, dFecHasta DATE, dFecGenera DATE, cTipoReporte VARCHAR2) IS

cCodUser        VARCHAR2(30);
nIdFactura      FACTURAS.IdFactura%TYPE;
nPrimaNeta      DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nReducPrima     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nRecargos       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nDerechos       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nImpuesto       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nPrimaTotal     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nTasaIVA        CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
cCodPlanPagos   PLAN_DE_PAGOS.CodPlanPago%TYPE;
cNumComprobCon  COMPROBANTES_CONTABLES.NumComprob%TYPE;
cNumComprobAnu  COMPROBANTES_CONTABLES.NumComprob%TYPE;
nTemporal       TRANSACCION.IDTRANSACCION%TYPE;
cCadena         VARCHAR2(4000);

CURSOR EMI_Q (XcIdTipoSeg VARCHAR2, XcPlanCob VARCHAR2, XcCodMoneda VARCHAR2, XcCodAgente VARCHAR2, XdFecDesde DATE, XdFecHasta DATE) IS
      SELECT DISTINCT * FROM (
            SELECT P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.CodFilial, OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
                      OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante, F.IdEndoso, F.IdFactura,
                      CASE --F.IDTRANSACCONTAB
                          WHEN F.IDTRANSACCONTAB is NULL THEN OC_TRANSACCION.FechaTransaccion(F.IDTRANSACCION)
                          when F.IDTRANSACCONTAB is not NULL then OC_TRANSACCION.FechaTransaccion(F.IDTRANSACCONTAB)
                      END FechaEmision,
                      OC_TRANSACCION.FechaTransaccion(F.IDTRANSACCIONANU) FechaAnulacion,
                      F.FecVenc, P.CodCia, F.NumCuota, P.CodEmpresa, F.IdTransaccion, F.IdTransaccontab, F.IdTransaccionanu,
                      F.FolioFactElec, F.FecEnvFactElec, F.CodUsuarioEnvFact, F.FecEnvFactElecAnu,
                      F.CodUsuarioEnvFactAnu, F.LogProcesoFactElec, F.IndFactElectronica, P.Cod_Moneda,
                      DP.IdTipoSeg, PC.CodTipoPlan, F.StsFact, F.FecAnul --, f.idtransaccion FIDTRANS, f.idtransaccionanu FTRANSANU, f.idtransaccontab FTRANSCONTAB, t.idtransaccion TTRANS
            FROM facturas f
            INNER JOIN polizas p ON (F.idpoliza = P.idpoliza)
            INNER JOIN detalle_poliza dp ON (dp.idpoliza = f.idpoliza
                                          and dp.idetpol = f.idetpol)
            INNER JOIN plan_coberturas pc ON (pc.plancob = dp.plancob
                      AND pc.idtiposeg = dp.idtiposeg
                      AND pc.codempresa = dp.codempresa
                      AND pc.codcia = dp.codcia)
            INNER JOIN TRANSACCION T ON (T.IDTRANSACCION = F.IDTRANSACCION
                                      OR T.IDTRANSACCION = F.IDTRANSACCIONANU
                                      OR T.IDTRANSACCION = F.IDTRANSACCONTAB)
            WHERE (  -- EMITIDOS
                    F.INDcontabilizada          = 'S'
                AND TRUNC(T.FechaTransaccion)  >= dFecDesde
                AND TRUNC(T.FechaTransaccion)  <= dFecHasta
                AND T.IdProceso                IN (7, 8, 14,18)   -- Anulaciones y Endoso
                AND ((T.IdTransaccion          = F.IdTransaccion AND F.IdTransacContab IS NULL)
                  OR T.IdTransaccion           = F.IdTransacContab))
              OR ( -- FACT ELECT
                (TRUNC(F.FecEnvFactElec)       >= dFecDesde
                AND TRUNC(F.FecEnvFactElec)    <= dFecHasta)
              OR (TRUNC(F.FecEnvFactElecAnu)   >= dFecDesde
                AND TRUNC(F.FecEnvFactElecAnu) <= dFecHasta))
              OR (  -- ANULADOS
                    F.INDcontabilizada          = 'S'
                AND TRUNC(T.FechaTransaccion)  >= dFecDesde
                AND TRUNC(T.FechaTransaccion)  <= dFecHasta
                AND F.StsFact                   = 'ANU')
            ORDER BY F.IDFACTURA, F.IDTRANSACCONTAB, F.IDTRANSACCIONANU
      );

CURSOR DET_Q IS
   SELECT D.CodCpto, D.Monto_Det_Moneda, D.IndCptoPrima, C.IndCptoServicio
     FROM DETALLE_FACTURAS D, FACTURAS F, CATALOGO_DE_CONCEPTOS C
    WHERE C.CodConcepto = D.CodCpto
      AND C.CodCia      = F.CodCia
      AND D.IdFactura   = F.IdFactura
      AND F.IdFactura   = nIdFactura;

BEGIN
    SELECT SYS_CONTEXT ('USERENV','CURRENT_USERID')
     INTO cCodUser
     FROM DUAL;

     nTemporal := 0;

   FOR X IN EMI_Q (cIdTipoSeg, cPlanCob, cCodMoneda, cCodAgente, dFecDesde, dFecHasta) LOOP
--nDummy := STOPALERT('En el FOR REC: ');
   	  nIdFactura      := X.IdFactura;
      nPrimaNeta      := 0;
      nReducPrima     := 0;
      nRecargos       := 0;
      nDerechos       := 0;
      nImpuesto       := 0;
      nPrimaTotal     := 0;
      cNumComprobCon  := NULL;
      cNumComprobAnu  := NULL;

      FOR W IN DET_Q LOOP
         IF W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S' THEN
            nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'RECFIN' THEN
            nRecargos   := NVL(nRecargos,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'DEREMI' THEN
            nDerechos   := NVL(nDerechos,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'IVASIN' THEN
            nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
            nTasaIVA    := OC_CONCEPTOS_PLAN_DE_PAGOS.PORCENTAJE_CONCEPTO(X.CodCia, X.CodEmpresa, cCodPlanPagos, W.CodCpto);
         ELSE
            nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
         END IF;
         nPrimaTotal  := NVL(nPrimaTotal,0) + NVL(W.Monto_Det_Moneda,0);
      END LOOP;

      IF ntemporal <> X.IDFACTURA THEN
          IF NVL(X.IDTRANSACCONTAB,0) > 0 THEN
              SELECT NVL(MIN(NumComprob),'0')
                INTO cNumComprobCon
                FROM COMPROBANTES_CONTABLES
               WHERE NumTransaccion = X.IDTRANSACCONTAB;
          END IF;
          IF NVL(X.IDTRANSACCIONANU,0) > 0 THEN
              SELECT NVL(MIN(NumComprob),'0')
                INTO cNumComprobAnu
                FROM COMPROBANTES_CONTABLES
               WHERE NumTransaccion = X.IDTRANSACCIONANU;
          END IF;
          IF NVL(X.IDTRANSACCIONANU,0) = 0 AND NVL(X.IDTRANSACCONTAB,0) = 0  THEN
              SELECT NVL(MIN(NumComprob),'0')
                INTO cNumComprobCon
                FROM COMPROBANTES_CONTABLES
               WHERE NumTransaccion = X.IDTRANSACCION;
          END IF;
          --INSERT INTO REPORTES_TMP VALUES (SQ_REPORTES_TMP.NEXTVAL, X.NumPolUnico, X.IdPoliza, X.NumPolRef, X.IdTipoSeg, X.CodTipoPlan,
          INSERT INTO REPORTES_TMP VALUES (X.NumPolUnico, X.IdPoliza, X.NumPolRef, X.IdTipoSeg, X.CodTipoPlan,
                      X.CodFilial, X.Contratante, X.IdEndoso, 'RECIBO', X.StsFact,
                      X.IdFactura, X.FechaEmision, X.FechaAnulacion, X.FecVenc, X.FecAnul,
                      X.Cod_Moneda, nPrimaNeta, nReducPrima, nRecargos, nDerechos,
                      nImpuesto, nPrimaTotal, X.IndFactElectronica, X.FolioFactElec, X.FecEnvFactElec,
                      X.CodUsuarioEnvFact, X.FecEnvFactElecAnu, X.CodUsuarioEnvFactAnu, X.LogProcesoFactElec, cNumComprobCon,
                      cNumComprobAnu, null, null, null, null, null, null, null, null, null,
                      null, null, null, null, null, null, null, null, null, null,
                      null, null, null, null, null, null, null, null, null, null,
                      USER, dFecGenera, cTipoReporte);
          ntemporal := X.IDFACTURA;
      END IF;

   END LOOP;
   COMMIT;

END FACTURAS_ELECTRONICAS_REC;

PROCEDURE FACTURAS_ELECTRONICAS_NCR(cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, cCodMoneda VARCHAR2, cCodAgente VARCHAR2, dFecDesde DATE, dFecHasta DATE, dFecGenera DATE, cTipoReporte VARCHAR2) IS

nIdFactura      FACTURAS.IdFactura%TYPE;
nPrimaNeta      DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nReducPrima     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nRecargos       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nDerechos       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nImpuesto       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nPrimaTotal     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nTasaIVA        CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
cCodPlanPagos   PLAN_DE_PAGOS.CodPlanPago%TYPE;
nIdNcr          NOTAS_DE_CREDITO.IdNcr%TYPE;
cNumComprobCon  COMPROBANTES_CONTABLES.NumComprob%TYPE;
cNumComprobAnu  COMPROBANTES_CONTABLES.NumComprob%TYPE;
nTemporal       TRANSACCION.IDTRANSACCION%TYPE;
cCadena         VARCHAR2(4000);

CURSOR REP_TMP_NCR(XcIdTipoSeg VARCHAR2, XcPlanCob VARCHAR2, XcCodMoneda VARCHAR2, XcCodAgente VARCHAR2, XdFecDesde DATE, XdFecHasta DATE) IS
      SELECT DISTINCT * FROM (
            SELECT P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.CodFilial, OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
                        OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
                        N.IdEndoso, N.IdNcr,
                        OC_TRANSACCION.FechaTransaccion(N.IDTRANSACCION) FechaEmision,
                        OC_TRANSACCION.FechaTransaccion(N.IDTRANSACCIONANU) FechaAnulacion, N.FecDevol, P.CodCia, 1 NumCuota, P.CodEmpresa,
                        N.FolioFactElec, N.FecEnvFactElec, N.CodUsuarioEnvFact, N.FecEnvFactElecAnu,
                        N.CodUsuarioEnvFactAnu, N.LogProcesoFactElec, N.IndFactElectronica, P.Cod_Moneda, N.IdTransaccion, N.IdTransaccionanu,
                        DP.IdTipoSeg, PC.CodTipoPlan, N.StsNcr, N.FecAnul
              FROM NOTAS_DE_CREDITO N
              INNER JOIN POLIZAS P ON (N.IDPOLIZA = P.IDPOLIZA)
              INNER JOIN DETALLE_POLIZA DP ON (DP.IDPOLIZA = P.IDPOLIZA
                  AND dp.idetpol = N.idetpol)
              INNER JOIN plan_coberturas pc ON (pc.plancob = dp.plancob
                        AND pc.idtiposeg = dp.idtiposeg
                        AND pc.codempresa = dp.codempresa
                        AND pc.codcia = dp.codcia)
              INNER JOIN TRANSACCION T ON (T.IDTRANSACCION = N.IDTRANSACCION
                                        OR T.IDTRANSACCION = N.IDTRANSACCIONANU)
              WHERE (  -- EMITIDOS
                      T.IdTransaccion                 = N.IdTransaccionAnu
                  AND T.IdProceso                IN (2, 8)   -- Anulaciones y Endoso
                  AND TRUNC(T.FechaTransaccion)  >= dFecDesde
                  AND TRUNC(T.FechaTransaccion)  <= dFecHasta)
                OR ( -- FACT ELECT
                  (TRUNC(N.FecEnvFactElec)       >= dFecDesde
                  AND TRUNC(N.FecEnvFactElec)    <= dFecHasta)
                OR (TRUNC(N.FecEnvFactElecAnu)   >= dFecDesde
                  AND TRUNC(N.FecEnvFactElecAnu) <= dFecHasta))
                OR (  -- ANULADOS
                      T.IdTransaccion                = N.IdTransaccion
                  AND T.IdProceso               IN (2, 8, 18)   -- Anulaciones y Endoso
                  AND TRUNC(T.FechaTransaccion) >= dFecDesde
                  AND TRUNC(T.FechaTransaccion) <= dFecHasta)
                  ORDER BY N.IDNCR, N.IDTRANSACCIONANU, N.IDTRANSACCION
                  );

CURSOR DET_NC_Q IS
   SELECT D.CodCpto, D.Monto_Det_Moneda, D.IndCptoPrima, C.IndCptoServicio
     FROM DETALLE_NOTAS_DE_CREDITO D, NOTAS_DE_CREDITO N, CATALOGO_DE_CONCEPTOS C
    WHERE C.CodConcepto = D.CodCpto
      AND C.CodCia      = N.CodCia
      AND D.IdNcr       = N.IdNcr
      AND N.IdNcr       = nIdNcr;

BEGIN

     nTemporal := 0;

		FOR X IN REP_TMP_NCR(cIdTipoSeg, cPlanCob, cCodMoneda, cCodAgente, dFecDesde, dFecHasta) LOOP
   	  nIdNcr          := X.IdNcr;
      nPrimaNeta      := 0;
      nReducPrima     := 0;
      nRecargos       := 0;
      nDerechos       := 0;
      nImpuesto       := 0;
      nPrimaTotal     := 0;
      cNumComprobCon  := NULL;
      cNumComprobAnu  := NULL;

      FOR W IN DET_NC_Q LOOP
         IF W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S' THEN
            nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'RECFIN' THEN
            nRecargos   := NVL(nRecargos,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'DEREMI' THEN
            nDerechos   := NVL(nDerechos,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'IVASIN' THEN
            nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
            nTasaIVA    := OC_CONCEPTOS_PLAN_DE_PAGOS.PORCENTAJE_CONCEPTO(X.CodCia, X.CodEmpresa, cCodPlanPagos, W.CodCpto);
         ELSE
            nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
         END IF;
         nPrimaTotal  := NVL(nPrimaTotal,0) + NVL(W.Monto_Det_Moneda,0);
      END LOOP;

      IF ntemporal <> X.IDNCR THEN

          IF NVL(X.IDTRANSACCIONANU,0) > 0 THEN
              SELECT NVL(MIN(NumComprob),'0')
                INTO cNumComprobCon
                FROM COMPROBANTES_CONTABLES
               WHERE NumTransaccion = X.IDTRANSACCIONANU;
          END IF;
          IF NVL(X.IDTRANSACCION,0) > 0 THEN
              SELECT NVL(MIN(NumComprob),'0')
                INTO cNumComprobAnu
                FROM COMPROBANTES_CONTABLES
               WHERE NumTransaccion = X.IDTRANSACCION;
          END IF;
          -- INSERT INTO REPORTES_TMP VALUES (SQ_REPORTES_TMP.NEXTVAL, X.IdPoliza, X.NumPolUnico, X.NumPolRef, X.CodFilial,
          INSERT INTO REPORTES_TMP VALUES (X.IdPoliza, X.NumPolUnico, X.NumPolRef, X.CodFilial,
                X.Contratante, X.IdEndoso, 'NCR', X.IdNcr, X.FechaEmision, X.FechaAnulacion,
                X.FecDevol, X.CodCia, X.NumCuota, X.CodEmpresa, X.FolioFactElec,
                X.FecEnvFactElec, X.CodUsuarioEnvFact, X.FecEnvFactElecAnu, X.CodUsuarioEnvFactAnu, X.LogProcesoFactElec,
                X.IndFactElectronica, X.Cod_Moneda, X.IdTipoSeg, X.CodTipoPlan, X.StsNcr,
                X.FecAnul, cNumComprobCon, nPrimaNeta, nReducPrima, nRecargos,
                nDerechos, nImpuesto, nPrimaTotal, cNumComprobAnu , NULL, NULL, NULL, NULL, NULL, NULL,
                NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                USER, dFecGenera, cTipoReporte);

          ntemporal := X.IDNCR;

      END IF;
		END LOOP;
   COMMIT;

END FACTURAS_ELECTRONICAS_NCR;

END OC_REPORTES;

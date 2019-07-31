--
-- GT_REA_LIQUIDACION  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FACTURAS (Table)
--   TASAS_CAMBIO (Table)
--   GT_REA_CONCEPTOS_LIQUIDACION (Package)
--   GT_REA_ESQUEMAS_EMPRESAS (Package)
--   GT_REA_LIQUIDACION_REASEG (Package)
--   GT_REA_LIQUIDACION_REASEG_DET (Package)
--   GT_REA_TIPOS_CONTRATOS (Package)
--   OC_DETALLE_FACTURAS (Package)
--   OC_DETALLE_NOTAS_DE_CREDITO (Package)
--   OC_DETALLE_TRANSACCION (Package)
--   APROBACIONES (Table)
--   APROBACION_ASEG (Table)
--   NOTAS_DE_CREDITO (Table)
--   TRANSACCION (Table)
--   COBERTURA_SINIESTRO (Table)
--   COBERTURA_SINIESTRO_ASEG (Table)
--   OC_FACTURAS (Package)
--   OC_TRANSACCION (Package)
--   OC_COMPROBANTES_CONTABLES (Package)
--   REA_CONCEPTOS_LIQUIDACION (Table)
--   REA_DISTRIBUCION (Table)
--   REA_DISTRIBUCION_EMPRESAS (Table)
--   REA_ESQUEMAS_CONTRATOS (Table)
--   REA_LIQUIDACION (Table)
--   REA_LIQUIDACION_REASEG (Table)
--   REA_LIQUIDACION_REASEG_DET (Table)
--   OC_GENERALES (Package)
--   OC_NOTAS_DE_CREDITO (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_REA_LIQUIDACION IS
  PROCEDURE ACTIVAR_LIQUIDACION(nCodCia NUMBER, nIdLiquidacion NUMBER);
  PROCEDURE ANULAR_LIQUIDACION(nCodCia NUMBER, nIdLiquidacion NUMBER);
  PROCEDURE LIQUIDACION_REASEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, dFecIniLiquida DATE, 
                                  dFecFinLiquida DATE, cIndLiberaRvas VARCHAR2);
  PROCEDURE LIBERACION_RESERVAS(nCodCia NUMBER, nIdLiquidacion NUMBER, nIdDetLiqReaseg NUMBER, dFecIniLiquida DATE, 
                                dFecFinLiquida DATE, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2,
                                cCodMonedaLiq VARCHAR2);
  PROCEDURE CERRAR_LIQUIDACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdLiquidacion NUMBER);
  FUNCTION INSERTA_LIQUIDACION(nCodCia NUMBER, nCodEmpresa NUMBER, dFecIniLiquida DATE, dFecFinLiquida DATE) RETURN NUMBER;
END GT_REA_LIQUIDACION;
/

--
-- GT_REA_LIQUIDACION  (Package Body) 
--
--  Dependencies: 
--   GT_REA_LIQUIDACION (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_REA_LIQUIDACION IS

PROCEDURE ACTIVAR_LIQUIDACION(nCodCia NUMBER, nIdLiquidacion NUMBER) IS
BEGIN
   UPDATE REA_LIQUIDACION
      SET StsLiquida      = 'ACTIVA',
          FecStatus       = TRUNC(SYSDATE),
          FecAnulada      = NULL
    WHERE CodCia          = nCodCia
      AND IdLiquidacion   = nIdLiquidacion;
END ACTIVAR_LIQUIDACION;

PROCEDURE ANULAR_LIQUIDACION(nCodCia NUMBER, nIdLiquidacion NUMBER) IS
BEGIN
   UPDATE REA_LIQUIDACION
      SET StsLiquida = 'ANULAD',
          FecStatus  = TRUNC(SYSDATE),
          FecAnulada = TRUNC(SYSDATE)
    WHERE CodCia         = nCodCia
      AND IdLiquidacion  = nIdLiquidacion;

   UPDATE REA_DISTRIBUCION_EMPRESAS
      SET IdLiquidacion     = NULL,
          IdLiquidLibRvas   = NULL,
          IntRvasLiberadas  = 0,
          ImpRvasLiberadas  = 0,
          FecLiberacionRvas = NULL
    WHERE CodCia           = nCodCia
      AND IdLiquidacion    = nIdLiquidacion;
END ANULAR_LIQUIDACION;

PROCEDURE LIQUIDACION_REASEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, dFecIniLiquida DATE, 
                                dFecFinLiquida DATE, cIndLiberaRvas VARCHAR2) IS
nIdLiquidacion        REA_LIQUIDACION.IdLiquidacion%TYPE;
nIdDetLiqReaseg       REA_LIQUIDACION_REASEG.IdDetLiqReaseg%TYPE;
cCodCptoContable      REA_CONCEPTOS_LIQUIDACION.CodCptoContable%TYPE;

CURSOR LIQ_Q IS
   SELECT RDE.CodEmpresaGremio, RDE.CodInterReaseg, EC.CodMonedaLiq,
          SUM(RDE.PrimaDistrib) PrimaDistrib, 
          SUM(0) MtoSiniDistrib,
          SUM(0) MtoSiniDistribPag,
          SUM(RDE.MontoComision) MontoComision, 
          SUM(RDE.MontoReserva) MontoReserva 
     FROM REA_DISTRIBUCION_EMPRESAS RDE, REA_DISTRIBUCION RD, REA_ESQUEMAS_CONTRATOS EC
    WHERE RDE.CodCia         = RD.CodCia
      AND RDE.IdDistribRea   = RD.IdDistribRea
      AND RDE.NumDistrib     = RD.NumDistrib
      AND RDE.IdLiquidacion IS NULL
      AND RD.FecMovDistrib  >= dFecIniLiquida
      AND RD.FecMovDistrib  <= dFecFinLiquida
      AND RD.IdSiniestro     = 0
      AND GT_REA_TIPOS_CONTRATOS.CONTRATO_RETENCION(EC.CodCia, EC.CodContrato) = 'N'
      AND EC.CodCia          = RD.CodCia
      AND EC.CodEsquema      = RD.CodEsquema
      AND EC.IdEsqContrato   = RD.IdEsqContrato
    GROUP BY RDE.CodEmpresaGremio, RDE.CodInterReaseg, EC.CodMonedaLiq
    UNION ALL
   SELECT RDE.CodEmpresaGremio, RDE.CodInterReaseg, EC.CodMonedaLiq,
          SUM(0) PrimaDistrib,
          SUM(RDE.MtoSiniDistrib) MtoSiniDistrib,
          SUM(0) MtoSiniDistribPag,
          SUM(0) MontoComision, SUM(0) MontoReserva
     FROM REA_DISTRIBUCION_EMPRESAS RDE, REA_DISTRIBUCION RD, REA_ESQUEMAS_CONTRATOS EC
    WHERE RDE.CodCia         = RD.CodCia
      AND RDE.IdDistribRea   = RD.IdDistribRea
      AND RDE.NumDistrib     = RD.NumDistrib
      AND RDE.IdLiquidacion IS NULL
      AND RD.FecMovDistrib  >= dFecIniLiquida
      AND RD.FecMovDistrib  <= dFecFinLiquida
      AND RD.IdSiniestro     > 0
      --AND GT_REA_TIPOS_CONTRATOS.CONTRATO_RETENCION(EC.CodCia, EC.CodContrato) = 'N'
      AND EC.CodCia          = RD.CodCia
      AND EC.CodEsquema      = RD.CodEsquema
      AND EC.IdEsqContrato   = RD.IdEsqContrato
      AND EXISTS (SELECT 'S'
                    FROM COBERTURA_SINIESTRO
                   WHERE IdSiniestro   = RD.IdSiniestro
                     AND IdPoliza      = RD.IdPoliza
                     AND IdDetSin      = RD.IDetPol
                     AND IdTransaccion = RD.IdTransaccion
                   UNION ALL
                  SELECT 'S'
                    FROM COBERTURA_SINIESTRO_ASEG
                   WHERE IdSiniestro   = RD.IdSiniestro
                     AND IdPoliza      = RD.IdPoliza
                     AND IdDetSin      = RD.IDetPol
                     AND IdTransaccion = RD.IdTransaccion)
    GROUP BY RDE.CodEmpresaGremio, RDE.CodInterReaseg, EC.CodMonedaLiq
    UNION ALL
   SELECT RDE.CodEmpresaGremio, RDE.CodInterReaseg, EC.CodMonedaLiq,
          SUM(0) PrimaDistrib,
          SUM(0) MtoSiniDistrib,
          ABS(SUM(RDE.MtoSiniDistrib)) MtoSiniDistribPag,
          SUM(0) MontoComision, SUM(0) MontoReserva
     FROM REA_DISTRIBUCION_EMPRESAS RDE, REA_DISTRIBUCION RD, REA_ESQUEMAS_CONTRATOS EC
    WHERE RDE.CodCia         = RD.CodCia
      AND RDE.IdDistribRea   = RD.IdDistribRea
      AND RDE.NumDistrib     = RD.NumDistrib
      AND RDE.IdLiquidacion IS NULL
      AND RD.FecMovDistrib  >= dFecIniLiquida
      AND RD.FecMovDistrib  <= dFecFinLiquida
      AND RD.IdSiniestro     > 0
      --AND GT_REA_TIPOS_CONTRATOS.CONTRATO_RETENCION(EC.CodCia, EC.CodContrato) = 'N'
      AND EC.CodCia          = RD.CodCia
      AND EC.CodEsquema      = RD.CodEsquema
      AND EC.IdEsqContrato   = RD.IdEsqContrato
      AND EXISTS (SELECT 'S'
                    FROM APROBACIONES
                   WHERE IdSiniestro   = RD.IdSiniestro
                     AND IdPoliza      = RD.IdPoliza
                     AND IdDetSin      = RD.IDetPol
                     AND IdTransaccion = RD.IdTransaccion
                   UNION ALL
                  SELECT 'S'
                    FROM APROBACION_ASEG
                   WHERE IdSiniestro   = RD.IdSiniestro
                     AND IdPoliza      = RD.IdPoliza
                     AND IdDetSin      = RD.IDetPol
                     AND IdTransaccion = RD.IdTransaccion)
    GROUP BY RDE.CodEmpresaGremio, RDE.CodInterReaseg, EC.CodMonedaLiq;
BEGIN
   nIdLiquidacion := GT_REA_LIQUIDACION.INSERTA_LIQUIDACION(nCodCia, nCodEmpresa, dFecIniLiquida, dFecFinLiquida);
   FOR X IN LIQ_Q LOOP
      GT_REA_LIQUIDACION_REASEG.INSERTAR(nCodCia, nIdLiquidacion, X.CodEmpresaGremio,
                                         X.CodInterReaseg, X.CodMonedaLiq);
      SELECT MAX(IdDetLiqReaseg)
        INTO nIdDetLiqReaseg
        FROM REA_LIQUIDACION_REASEG
       WHERE CodCia     = nCodCia
         AND IdLiquidacion = nIdLiquidacion;
         
      IF NVL(X.PrimaDistrib,0) != 0 THEN
         cCodCptoContable := GT_REA_CONCEPTOS_LIQUIDACION.CONCEPTO_CONTABLE(nCodCia, 'PRICED');
         IF cCodCptoContable != 'NO EXISTE' THEN
            GT_REA_LIQUIDACION_REASEG_DET.INSERTAR(nCodCia, nIdLiquidacion, nIdDetLiqReaseg, cCodCptoContable,
                                                   NVL(X.PrimaDistrib,0), 'Primas Cedidas a Reasegurador del '||
                                                   TO_CHAR(dFecIniLiquida,'DD/MM/YYYY') || ' Al ' ||
                                                   TO_CHAR(dFecFinLiquida,'DD/MM/YYYY'));
         END IF;
      END IF;
      IF NVL(X.MtoSiniDistrib,0) != 0 THEN
         cCodCptoContable := GT_REA_CONCEPTOS_LIQUIDACION.CONCEPTO_CONTABLE(nCodCia, 'MONTSI');
         IF cCodCptoContable != 'NO EXISTE' THEN
            GT_REA_LIQUIDACION_REASEG_DET.INSERTAR(nCodCia, nIdLiquidacion, nIdDetLiqReaseg, cCodCptoContable,
                                                   NVL(X.MtoSiniDistrib,0) * -1, 'Monto de Siniestros de Primas Cedidas al ' ||
                                                   ' Reasegurador del '|| TO_CHAR(dFecIniLiquida,'DD/MM/YYYY') || ' Al ' ||
                                                   TO_CHAR(dFecFinLiquida,'DD/MM/YYYY'));
         END IF;
      END IF;

      IF NVL(X.MtoSiniDistribPag,0) != 0 THEN
         cCodCptoContable := GT_REA_CONCEPTOS_LIQUIDACION.CONCEPTO_CONTABLE(nCodCia, 'SINPAG');
         IF cCodCptoContable != 'NO EXISTE' THEN
            GT_REA_LIQUIDACION_REASEG_DET.INSERTAR(nCodCia, nIdLiquidacion, nIdDetLiqReaseg, cCodCptoContable,
                                                   NVL(X.MtoSiniDistribPag,0) * -1, 'Monto de Siniestros Pagados por Cobrar al ' ||
                                                   ' Reasegurador del '|| TO_CHAR(dFecIniLiquida,'DD/MM/YYYY') || ' Al ' ||
                                                   TO_CHAR(dFecFinLiquida,'DD/MM/YYYY'));
         END IF;
      END IF;

      IF NVL(X.MontoComision,0) != 0 THEN
         cCodCptoContable := GT_REA_CONCEPTOS_LIQUIDACION.CONCEPTO_CONTABLE(nCodCia, 'COMREA');
         IF cCodCptoContable != 'NO EXISTE' THEN
            GT_REA_LIQUIDACION_REASEG_DET.INSERTAR(nCodCia, nIdLiquidacion, nIdDetLiqReaseg, cCodCptoContable,
                                                   NVL(X.MontoComision,0) * -1, 'Comisiones de Reaseguro del '||
                                                   TO_CHAR(dFecIniLiquida,'DD/MM/YYYY') || ' Al ' ||
                                                   TO_CHAR(dFecFinLiquida,'DD/MM/YYYY'));
         END IF;
      END IF;

      IF NVL(X.MontoReserva,0) != 0 THEN
         cCodCptoContable := GT_REA_CONCEPTOS_LIQUIDACION.CONCEPTO_CONTABLE(nCodCia, 'RESRET');
         IF cCodCptoContable != 'NO EXISTE' THEN
            GT_REA_LIQUIDACION_REASEG_DET.INSERTAR(nCodCia, nIdLiquidacion, nIdDetLiqReaseg, cCodCptoContable,
                                                   NVL(X.MontoReserva,0) * -1, 'Reservas Retenidas al Reasegurador del '||
                                                   TO_CHAR(dFecIniLiquida,'DD/MM/YYYY') || ' Al ' ||
                                                   TO_CHAR(dFecFinLiquida,'DD/MM/YYYY'));
         END IF;
      END IF;
      IF cIndLiberaRvas = 'S' THEN
         GT_REA_LIQUIDACION.LIBERACION_RESERVAS(nCodCia, nIdLiquidacion, nIdDetLiqReaseg, dFecIniLiquida,
                                                dFecFinLiquida,  X.CodEmpresaGremio, X.CodInterReaseg, X.CodMonedaLiq);
      END IF;
      GT_REA_LIQUIDACION_REASEG.ACTUALIZAR_MONTO(nCodCia, nIdLiquidacion, nIdDetLiqReaseg);

      UPDATE REA_DISTRIBUCION_EMPRESAS
         SET IdLiquidacion    = nIdLiquidacion
       WHERE CodCia                      = nCodCia
         AND (IdDistribRea, NumDistrib) IN (SELECT RD.IdDistribRea, RD.NumDistrib
                                              FROM REA_DISTRIBUCION_EMPRESAS RDE, REA_DISTRIBUCION RD, REA_ESQUEMAS_CONTRATOS EC
                                             WHERE RDE.CodCia         = RD.CodCia
                                               AND RDE.IdDistribRea   = RD.IdDistribRea
                                               AND RDE.NumDistrib     = RD.NumDistrib
                                               AND RDE.IdLiquidacion IS NULL
                                               AND RD.FecMovDistrib  >= dFecIniLiquida
                                               AND RD.FecMovDistrib  <= dFecFinLiquida
                                               AND RD.IdSiniestro     = 0
                                               AND GT_REA_TIPOS_CONTRATOS.CONTRATO_RETENCION(EC.CodCia, EC.CodContrato) = 'N'
                                               AND EC.CodCia          = RD.CodCia
                                               AND EC.CodEsquema      = RD.CodEsquema
                                               AND EC.IdEsqContrato   = RD.IdEsqContrato
                                             UNION
                                            SELECT RD.IdDistribRea, RD.NumDistrib
                                              FROM REA_DISTRIBUCION_EMPRESAS RDE, REA_DISTRIBUCION RD, REA_ESQUEMAS_CONTRATOS EC
                                             WHERE RDE.CodCia         = RD.CodCia
                                               AND RDE.IdDistribRea   = RD.IdDistribRea
                                               AND RDE.NumDistrib     = RD.NumDistrib
                                               AND RDE.IdLiquidacion IS NULL
                                               AND RD.FecMovDistrib  >= dFecIniLiquida
                                               AND RD.FecMovDistrib  <= dFecFinLiquida
                                               AND RD.IdSiniestro     > 0
                                               AND GT_REA_TIPOS_CONTRATOS.CONTRATO_RETENCION(EC.CodCia, EC.CodContrato) = 'N'
                                               AND EC.CodCia          = RD.CodCia
                                               AND EC.CodEsquema      = RD.CodEsquema
                                               AND EC.IdEsqContrato   = RD.IdEsqContrato);
   END LOOP;
END LIQUIDACION_REASEGURO;

PROCEDURE LIBERACION_RESERVAS(nCodCia NUMBER, nIdLiquidacion NUMBER, nIdDetLiqReaseg NUMBER, dFecIniLiquida DATE, 
                              dFecFinLiquida DATE, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2,
                              cCodMonedaLiq VARCHAR2) IS
nIntRvasLiberadas     REA_DISTRIBUCION_EMPRESAS.IntRvasLiberadas%TYPE;
nImpRvasLiberadas     REA_DISTRIBUCION_EMPRESAS.ImpRvasLiberadas%TYPE;
nMontoReservaTot      REA_DISTRIBUCION_EMPRESAS.MontoReserva%TYPE       := 0;
nIntRvasLibTot        REA_DISTRIBUCION_EMPRESAS.IntRvasLiberadas%TYPE   := 0;
nImpRvasLibTot        REA_DISTRIBUCION_EMPRESAS.ImpRvasLiberadas%TYPE   := 0;
dFecIniLibRvas        DATE  := ADD_MONTHS(dFecIniLiquida,-12);
dFecFinLibRvas        DATE  := ADD_MONTHS(dFecFinLiquida,-12);
cCodCptoContable      REA_CONCEPTOS_LIQUIDACION.CodCptoLiquida%TYPE;

CURSOR RVAS_Q IS
   SELECT RDE.IdDistribRea, RDE.NumDistrib, RDE.MontoReserva, RD.CodEsquema,
          RD.IdEsqContrato, RD.IdCapaContrato
     FROM REA_DISTRIBUCION_EMPRESAS RDE, REA_DISTRIBUCION RD
    WHERE RDE.CodEmpresaGremio = cCodEmpresaGremio
      AND RDE.CodInterReaseg   = cCodinterReaseg
      AND RDE.CodCia           = RD.CodCia
      AND RDE.IdDistribRea     = RD.IdDistribRea
      AND RDE.NumDistrib       = RD.NumDistrib
      AND RDE.IdLiquidLibRvas IS NULL
      AND RDE.MontoReserva    != 0
      AND RD.FecMovDistrib    >= dFecIniLibRvas
      AND RD.FecMovDistrib    <= dFecFinLibRvas
      AND RD.CodMoneda         = cCodMonedaLiq
      AND RD.IdSiniestro       = 0;
BEGIN
   FOR W IN RVAS_Q LOOP
      nIntRvasLiberadas := W.MontoReserva * 
                           (GT_REA_ESQUEMAS_EMPRESAS.PORCENTAJE(nCodCia, W.CodEsquema, W.IdEsqContrato, W.IdCapaContrato,
                                                                cCodEmpresaGremio, cCodInterReaseg, 'PIRP') / 100);
      nImpRvasLiberadas := (W.MontoReserva + nIntRvasLiberadas) * 
                           (GT_REA_ESQUEMAS_EMPRESAS.PORCENTAJE(nCodCia, W.CodEsquema, W.IdEsqContrato, W.IdCapaContrato,
                                                                cCodEmpresaGremio, cCodInterReaseg, 'PRIM') / 100);
      nMontoReservaTot  := NVL(nMontoReservaTot,0) + NVL(W.MontoReserva,0);
      nIntRvasLibTot    := NVL(nIntRvasLibTot,0) + NVL(nIntRvasLiberadas,0);
      nImpRvasLibTot    := NVL(nImpRvasLibTot,0) + NVL(nImpRvasLiberadas,0);

      UPDATE REA_DISTRIBUCION_EMPRESAS
         SET IdLiquidLibRvas   = nIdLiquidacion,
             IntRvasLiberadas  = nIntRvasLiberadas,
             ImpRvasLiberadas  = nImpRvasLiberadas,
             FecLiberacionRvas = TRUNC(SYSDATE)
       WHERE CodCia       = nCodCia
         AND IdDistribRea = W.IdDistribRea
         AND NumDistrib   = W.NumDistrib;
   END LOOP;

   IF NVL(nMontoReservaTot,0) != 0 THEN
      cCodCptoContable := GT_REA_CONCEPTOS_LIQUIDACION.CONCEPTO_CONTABLE(nCodCia, 'RESLIB');
      IF cCodCptoContable != 'NO EXISTE' THEN
         GT_REA_LIQUIDACION_REASEG_DET.INSERTAR(nCodCia, nIdLiquidacion, nIdDetLiqReaseg, cCodCptoContable,
                                                NVL(nMontoReservaTot,0), 'Liberación de Reservas a Reasegurador del '||
                                                TO_CHAR(dFecIniLibRvas,'DD/MM/YYYY') || ' Al ' ||
                                                TO_CHAR(dFecFinLibRvas,'DD/MM/YYYY'));
      END IF;
   END IF;

   IF NVL(nIntRvasLibTot,0) != 0 THEN
      cCodCptoContable := GT_REA_CONCEPTOS_LIQUIDACION.CONCEPTO_CONTABLE(nCodCia, 'INTLIB');
      IF cCodCptoContable != 'NO EXISTE' THEN
         GT_REA_LIQUIDACION_REASEG_DET.INSERTAR(nCodCia, nIdLiquidacion, nIdDetLiqReaseg, cCodCptoContable,
                                                NVL(nIntRvasLibTot,0), 'Intereses por Liberación de Reservas a Reasegurador del '||
                                                TO_CHAR(dFecIniLibRvas,'DD/MM/YYYY') || ' Al ' ||
                                                TO_CHAR(dFecFinLibRvas,'DD/MM/YYYY'));
      END IF;
   END IF;

   IF NVL(nImpRvasLibTot,0) != 0 THEN
      cCodCptoContable := GT_REA_CONCEPTOS_LIQUIDACION.CONCEPTO_CONTABLE(nCodCia, 'IMPRET');
      IF cCodCptoContable != 'NO EXISTE' THEN
         GT_REA_LIQUIDACION_REASEG_DET.INSERTAR(nCodCia, nIdLiquidacion, nIdDetLiqReaseg, cCodCptoContable,
                                                NVL(nImpRvasLibTot,0) * -1, 'Impuestos Retenidos por Liberación de Reservas a Reasegurador del '||
                                                TO_CHAR(dFecIniLibRvas,'DD/MM/YYYY') || ' Al ' ||
                                                TO_CHAR(dFecFinLibRvas,'DD/MM/YYYY'));
      END IF;
   END IF;
END LIBERACION_RESERVAS;

PROCEDURE CERRAR_LIQUIDACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdLiquidacion NUMBER) IS
nTotCptoLiquida       REA_LIQUIDACION_REASEG_DET.TotCptoLiquida%TYPE;
nIdDetLiqReaseg       REA_LIQUIDACION_REASEG_DET.IdDetLiqReaseg%TYPE;
nTasaCambio           TASAS_CAMBIO.Tasa_Cambio%TYPE;
nIdNcr                NOTAS_DE_CREDITO.IdNcr%TYPE;
nIdFactura            FACTURAS.IdFactura%TYPE;
nIdTransaccion        TRANSACCION.IdTransaccion%TYPE;

CURSOR EMP_Q IS
   SELECT IdDetLiqReaseg, CodEmpresaGremio, CodInterReaseg, CodMoneda
     FROM REA_LIQUIDACION_REASEG
    WHERE CodCia          = nCodCia
      AND IdLiquidacion   = nIdLiquidacion
      AND StsDetLiqReaseg = 'ACTIVA';
CURSOR DET_Q IS
   SELECT C.CodCptoContable, SUM(D.TotCptoLiquida) TotCptoLiquida
     FROM REA_LIQUIDACION_REASEG_DET D, REA_CONCEPTOS_LIQUIDACION C
    WHERE C.CodCptoLiquida  = D.CodCptoLiquida
      AND C.CodCia          = D.CodCia
      AND D.CodCia          = nCodCia
      AND D.IdLiquidacion   = nIdLiquidacion
      AND D.IdDetLiqReaseg  = nIdDetLiqReaseg
    GROUP BY C.CodCptoContable;
BEGIN
   nIdTransaccion := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 23, 'CIELIQ');

   FOR W IN EMP_Q LOOP
      nTasaCambio     := OC_GENERALES.TASA_DE_CAMBIO(W.CodMoneda, TRUNC(SYSDATE));
      nIdNcr          := NULL;
      nIdFactura      := NULL;
      nIdDetLiqReaseg := W.IdDetLiqReaseg;
      nTotCptoLiquida := GT_REA_LIQUIDACION_REASEG_DET.TOTAL_LIQUIDACION(nCodCia, nIdLiquidacion, W.IdDetLiqReaseg);
      IF nTotCptoLiquida > 0 THEN
         nIdNcr := OC_NOTAS_DE_CREDITO.INSERTA_NOTA_CREDITO(nCodCia, 0, 0, 0, 1, TRUNC(SYSDATE), nTotCptoLiquida, 
                                                            nTotCptoLiquida * nTasaCambio, 0, 0, NULL, null, nTasaCambio, nIdTransaccion, null);

         OC_DETALLE_TRANSACCION.CREA (nIdTransaccion, nCodCia,  nCodEmpresa, 23, 'CIELIQ', 'REA_LIQUIDACION',
                                      nIdLiquidacion, NULL, nIdNcr, NULL, nTotCptoLiquida);

         FOR X IN DET_Q LOOP
            OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, X.CodCptoContable, 'N', X.TotCptoLiquida, 
                                                             X.TotCptoLiquida * nTasaCambio);
         END LOOP;
         OC_NOTAS_DE_CREDITO.ACTUALIZA_NOTA(nIdNcr);
      ELSE
         nIdFactura := OC_FACTURAS.INSERTAR(0, 0, 1, TRUNC(SYSDATE), nTotCptoLiquida, nTotCptoLiquida * nTasaCambio, 0,
                                            0, 0, 1, nTasaCambio, NULL, NULL, nCodCia, W.CodMoneda, NULL, nIdTransaccion, null);

         OC_DETALLE_TRANSACCION.CREA (nIdTransaccion, nCodCia,  nCodEmpresa, 23, 'CIELIQ', 'REA_LIQUIDACION',
                                      nIdLiquidacion, nIdFactura, NULL, NULL, nTotCptoLiquida);

         FOR X IN DET_Q LOOP
            OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, X.CodCptoContable, 'N', X.TotCptoLiquida, 
                                         X.TotCptoLiquida * nTasaCambio);
         END LOOP;
         OC_FACTURAS.ACTUALIZA_FACTURA(nIdFactura);
      END IF;
      UPDATE REA_LIQUIDACION_REASEG
         SET IdFactura           = nIdFactura,
             IdNcr               = nIdNcr,
             StsDetLiqReaseg     = 'LIQUID',
             FecStatus           = TRUNC(SYSDATE)
       WHERE CodCia          = nCodCia
         AND IdLiquidacion   = nIdLiquidacion
         AND IdDetLiqReaseg  = nIdDetLiqReaseg
         AND StsDetLiqReaseg = 'ACTIVA';
   END LOOP;

   -- Contabiliza la Liquidación para Todos los Reaseguradores
   OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');
   UPDATE REA_LIQUIDACION
      SET StsLiquida          = 'LIQUID',
          FecStatus           = TRUNC(SYSDATE),
          FecContaCierre      = TRUNC(SYSDATE),
          IdTransaccionCierre = nIdTransaccion
    WHERE CodCia        = nCodCia
      AND IdLiquidacion = nIdLiquidacion
      AND StsLiquida    = 'ACTIVA';
END CERRAR_LIQUIDACION;

FUNCTION INSERTA_LIQUIDACION(nCodCia NUMBER, nCodEmpresa NUMBER, dFecIniLiquida DATE, dFecFinLiquida DATE) RETURN NUMBER IS
nIdLiquidacion       REA_LIQUIDACION.IdLiquidacion%TYPE;
nIdTransaccion       TRANSACCION.IdTransaccion%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MAX(IdLiquidacion),0)+1
        INTO nIdLiquidacion
        FROM REA_LIQUIDACION
       WHERE CodCia          = nCodCia;
   END;

   nIdTransaccion := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 23, 'LIQREA');

   OC_DETALLE_TRANSACCION.CREA (nIdTransaccion, nCodCia,  nCodEmpresa, 23, 'LIQREA', 'REA_LIQUIDACION',
                                nIdLiquidacion, NULL, NULL, NULL, 0.00);

   BEGIN
      INSERT INTO REA_LIQUIDACION
             (CodCia, IdLiquidacion, FecIniLiquida, FecFinLiquida, IdTransaccion,
              StsLiquida, FecStatus, CodUsuario, FecGenerada, FecAnulada, FecContabilizada)
      VALUES (nCodCia, nIdLiquidacion, dFecIniLiquida, dFecFinLiquida, nIdTransaccion,
              'ACTIVA', TRUNC(SYSDATE), USER, TRUNC(SYSDATE), NULL, NULL);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20200,'Liquidación de Reaseguro No. ' || nIdLiquidacion || ' Duplicada');
   END;
   RETURN(nIdLiquidacion);
END INSERTA_LIQUIDACION;

END GT_REA_LIQUIDACION;
/

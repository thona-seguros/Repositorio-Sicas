--
-- OC_COMPROBANTES_CONTABLES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   DBMS_OUTPUT (Synonym)
--   DBMS_STANDARD (Package)
--   PLANTILLAS_CONTABLES (Table)
--   PRIMAS_DEPOSITO (Table)
--   PROCESOS_CONTABLES (Table)
--   PROC_TAREA (Table)
--   FACTURAS (Table)
--   FAI_CONCENTRADORA_FONDO (Table)
--   FZ_DETALLE_FIANZAS (Table)
--   DETALLE_APROBACION (Table)
--   DETALLE_APROBACION_ASEG (Table)
--   DETALLE_FACTURAS (Table)
--   DETALLE_NOTAS_DE_CREDITO (Table)
--   DETALLE_POLIZA (Table)
--   DETALLE_SINIESTRO (Table)
--   DETALLE_SINIESTRO_ASEG (Table)
--   DETALLE_TRANSACCION (Table)
--   EMPRESAS (Table)
--   TARJETAS_PREPAGO (Table)
--   TASAS_CAMBIO (Table)
--   AGENTES (Table)
--   AGENTES_DISTRIBUCION_COMISION (Table)
--   APROBACIONES (Table)
--   APROBACION_ASEG (Table)
--   GT_FAI_FONDOS_DETALLE_POLIZA (Package)
--   GT_FAI_MOVIMIENTOS_FONDOS (Package)
--   NOTAS_DE_CREDITO (Table)
--   TIPOS_DE_SEGUROS (Table)
--   TRANSACCION (Table)
--   VALORES_DE_LISTAS (Table)
--   OC_PROCESOS_CONTABLES (Package)
--   OC_PROC_TAREA (Package)
--   OC_SUB_PROCESO (Package)
--   RESERVAS_TECNICAS (Table)
--   RESERVAS_TECNICAS_CONTAB (Table)
--   SINIESTRO (Table)
--   SQ_COMPR_CONTA (Sequence)
--   SUB_PROCESO (Table)
--   COMISIONES (Table)
--   COMPROBANTES_CONTABLES (Table)
--   COMPROBANTES_DETALLE (Table)
--   CONCEPTOS_PLAN_DE_PAGOS (Table)
--   CONFIG_RESERVAS (Table)
--   CONFIG_RESERVAS_TIPOSEG (Table)
--   CATALOGO_CONTABLE (Table)
--   COBERTURA_SINIESTRO (Table)
--   COBERTURA_SINIESTRO_ASEG (Table)
--   OC_EMPRESAS (Package)
--   OC_FACTURAS (Package)
--   OC_TIPOS_DE_SEGUROS (Package)
--   OC_VALORES_DE_LISTAS (Package)
--   PAGOS (Table)
--   PAGO_DETALLE (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--   OC_ARCHIVO (Package)
--   OC_CATALOGO_CONTABLE (Package)
--   OC_CATALOGO_DE_CONCEPTOS (Package)
--   OC_COMPROBANTES_DETALLE (Package)
--   OC_GENERALES (Package)
--   OC_MONEDA (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.oc_comprobantes_contables IS

  FUNCTION NUM_COMPROBANTE(nCodCia NUMBER) RETURN NUMBER;

  FUNCTION CREA_COMPROBANTE(nCodCia NUMBER, cTipoComprob VARCHAR2, nNumTransaccion NUMBER,
                            cTipoDiario VARCHAR2, cCodMoneda VARCHAR2) RETURN NUMBER;

  PROCEDURE CUADRA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER);

  PROCEDURE ANULA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER);

  PROCEDURE REHABILITA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER);

  PROCEDURE REVERSA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER, cTipoCompRev VARCHAR2);

  PROCEDURE ACTUALIZA_ENVIO(nCodCia NUMBER, nNumComprob NUMBER, nNumPolMizar NUMBER := 0);

  PROCEDURE CONTABILIZAR(nCodCia NUMBER, nIdTransaccion NUMBER, cTipoComp VARCHAR2 DEFAULT 'C');

  PROCEDURE TRASLADO(nCodCia NUMBER, dFecDesde DATE, dFecHasta DATE, nNumComprobSC NUMBER,
                     dFecRegistro DATE, cCodUser VARCHAR2, cConcepto VARCHAR2, nDiario NUMBER,
                     cTipoComprob VARCHAR2, cTipoDiario VARCHAR2, cCodMoneda VARCHAR2, 
                     cTipoTraslado VARCHAR2, nLinea IN OUT NUMBER);

  PROCEDURE RECONTABILIZAR(nCodCia NUMBER, nIdTransaccion NUMBER, cTipoComp VARCHAR2 DEFAULT 'C', nNumComprob NUMBER);

  PROCEDURE ELIMINA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER);

  PROCEDURE TRASLADO_SUN(nCodCia NUMBER, dFecDesde DATE, dFecHasta DATE, nNumComprobSun NUMBER,
                         dFecRegistro DATE, cCodUser VARCHAR2, cTipoComprob VARCHAR2,
                         cEncabezado VARCHAR2, nLinea  IN OUT NUMBER);
  PROCEDURE RECONTABILIZAR_MASIVO (cTipoComprob VARCHAR2,dFecIni DATE, dFecFin DATE);

  FUNCTION COMISION_TIPO_PERSONA(nCodCia NUMBER, nIdTransaccion NUMBER, cIdTipoSeg VARCHAR2,
                                 cTipoPersona VARCHAR2, cTipoAgente VARCHAR2) RETURN NUMBER;

  FUNCTION APLICA_CANAL_VENTA(nCodCia NUMBER, nIdTransaccion NUMBER, cIdTipoSeg VARCHAR2,
                              cCanalComisVenta VARCHAR2) RETURN VARCHAR2;

  FUNCTION APLICA_TIPO_AGENTE(nCodCia NUMBER, nIdTransaccion NUMBER, cIdTipoSeg VARCHAR2,
                              cTipoAgente VARCHAR2) RETURN VARCHAR2;

  PROCEDURE ACTUALIZA_MONEDA(nCodCia NUMBER, nNumComprob NUMBER, cCodMoneda VARCHAR2);

  FUNCTION STATUS_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER) RETURN VARCHAR2;

  FUNCTION POSEE_COMPROBANTE(nCodCia NUMBER, nIdTransaccion NUMBER) RETURN VARCHAR2;

  FUNCTION ENVIADO_SISTEMA_CONTABLE(nCodCia NUMBER, nIdTransaccion NUMBER) RETURN VARCHAR2;

END OC_COMPROBANTES_CONTABLES;
/

--
-- OC_COMPROBANTES_CONTABLES  (Package Body) 
--
--  Dependencies: 
--   OC_COMPROBANTES_CONTABLES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.oc_comprobantes_contables IS


---- ADICIONO UNA VALIDACION EN LA FUNCION APLICA_CANAL_VENTA
---- SI EL SINIESTRO YA FUE ABIERTO, YA NO VALIDA CERTIFICADO NI ESTATUS
---- PERMITE CONTINUAR                                                        25/11/2016   AEVS 
-- SE QUITO LA PROGRAMACION EL GRABADO DE GRABA_TIEMPO  JICO 21/04/2017
--
FUNCTION NUM_COMPROBANTE(nCodCia NUMBER) RETURN NUMBER IS
nNumComprob   COMPROBANTES_CONTABLES.NumComprob%TYPE;
BEGIN
--   BEGIN                                      -- JICO  JICO 20151229
--      SELECT NVL(MAX(NumComprob),0)+1
--        INTO nNumComprob
--        FROM COMPROBANTES_CONTABLES
--       WHERE CodCia = nCodCia;
--   END;
   
   
  SELECT SQ_COMPR_CONTA.NEXTVAL      -- JICO  JICO 20151229
    INTO nNumComprob
    FROM DUAL;
    
   
   RETURN(nNumComprob);
END NUM_COMPROBANTE;

FUNCTION CREA_COMPROBANTE(nCodCia NUMBER, cTipoComprob VARCHAR2, nNumTransaccion NUMBER,
                          cTipoDiario VARCHAR2, cCodMoneda VARCHAR2) RETURN NUMBER IS
nNumComprob   COMPROBANTES_CONTABLES.NumComprob%TYPE;
BEGIN
   nNumComprob := OC_COMPROBANTES_CONTABLES.NUM_COMPROBANTE(nCodCia);

   BEGIN
      INSERT INTO COMPROBANTES_CONTABLES
             (CodCia, NumComprob, TipoComprob, FecComprob, StsComprob, FecSts,
              NumTransaccion, TotalDebitos, TotalCreditos, TotalDifComp,
              FecEnvioSC, NumComprobSC, FecEnvioSun, NumComprobSun, TipoDiario,
              CodMoneda, IndAutomatico)
      VALUES (nCodCia, nNumComprob, cTipoComprob, TRUNC(SYSDATE), 'DES', TRUNC(SYSDATE),
              nNumTransaccion, 0 , 0 , 0, NULL, NULL, NULL, NULL, cTipoDiario,
              cCodMoneda, 'S');
   END;
   RETURN(nNumComprob);
END CREA_COMPROBANTE;

PROCEDURE CUADRA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER) IS
nTotDebitos          COMPROBANTES_CONTABLES.TotalDebitos%TYPE;
nTotCreditos         COMPROBANTES_CONTABLES.TotalCreditos%TYPE;
nTotDebitosLocal     COMPROBANTES_CONTABLES.TotalDebitosLocal%TYPE;
nTotCreditosLocal    COMPROBANTES_CONTABLES.TotalCreditosLocal%TYPE;
nTotalDifComp        COMPROBANTES_CONTABLES.TotalDifComp%TYPE;
cStsComprob          COMPROBANTES_CONTABLES.stscomprob%TYPE;
BEGIN

   nTotDebitos        := OC_COMPROBANTES_DETALLE.TOTAL_DEBITOS(nCodCia, nNumComprob);
   nTotCreditos       := OC_COMPROBANTES_DETALLE.TOTAL_CREDITOS(nCodCia, nNumComprob);
   nTotDebitosLocal   := OC_COMPROBANTES_DETALLE.TOTAL_DEBITOS_LOCAL(nCodCia, nNumComprob);
   nTotCreditosLocal  := OC_COMPROBANTES_DETALLE.TOTAL_CREDITOS_LOCAL(nCodCia, nNumComprob);
   nTotalDifComp      := ABS(nTotDebitos - nTotCreditos);

   IF nTotalDifComp = 0 AND (nTotDebitos != 0 OR nTotCreditos != 0) THEN
      cStsComprob := 'CUA';
   ELSE
      cStsComprob := 'DES';
   END IF;

   BEGIN
      UPDATE COMPROBANTES_CONTABLES
         SET StsComprob         = cStsComprob,
             FecSts             = FecComprob,
             TotalDebitos       = nTotDebitos,
             TotalCreditos      = nTotCreditos,
             TotalDebitosLocal  = nTotDebitosLocal,
             TotalCreditosLocal = nTotCreditosLocal,
             TotalDifComp       = nTotalDifComp
       WHERE CodCia     = nCodCia
         AND NumComprob = nNumComprob;
   END;
END CUADRA_COMPROBANTE;

PROCEDURE ANULA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER) IS
BEGIN
   BEGIN
      UPDATE COMPROBANTES_CONTABLES
         SET StsComprob  = 'ANU',
             FecSts      = TRUNC(SYSDATE)
       WHERE CodCia     = nCodCia
         AND NumComprob = nNumComprob;
   END;
END ANULA_COMPROBANTE;

PROCEDURE REHABILITA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER) IS
BEGIN
   OC_COMPROBANTES_CONTABLES.CUADRA_COMPROBANTE(nCodCia, nNumComprob);
END REHABILITA_COMPROBANTE;

PROCEDURE REVERSA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER, cTipoCompRev VARCHAR2) IS
nNumComprobRev    COMPROBANTES_CONTABLES.NumComprob%TYPE;
nNumTransaccion   COMPROBANTES_CONTABLES.NumTransaccion%TYPE;
cTipoDiario       COMPROBANTES_CONTABLES.TipoDiario%TYPE;
cCodMoneda        COMPROBANTES_CONTABLES.CodMoneda%TYPE;
dFecComprob       COMPROBANTES_CONTABLES.FecComprob%TYPE;
BEGIN
   BEGIN
      SELECT NumTransaccion, TipoDiario, CodMoneda
        INTO nNumTransaccion, cTipoDiario, cCodMoneda
        FROM COMPROBANTES_CONTABLES
       WHERE CodCia     = nCodCia
         AND NumComprob = nNumComprob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000,'No Existe Comprobante No. '||nNumComprob || ' de Compañía ' || nCodCia);
   END;
--   nNumTransaccion := OC_TRANSACCIONES.CREAR_TRANSACCION;
   nNumComprobRev  := OC_COMPROBANTES_CONTABLES.CREA_COMPROBANTE(nCodCia, cTipoCompRev, nNumTransaccion, cTipoDiario, cCodMoneda);
   OC_COMPROBANTES_DETALLE.REVERSA_DETALLE(nCodCia, nNumComprob, nNumComprobRev);

   BEGIN
      SELECT FecComprob
        INTO dFecComprob
        FROM COMPROBANTES_CONTABLES
       WHERE CodCia     = nCodCia
         AND NumComprob = nNumComprobRev;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000,'No Existe Comprobante de Reverso No. '||nNumComprobRev || ' de Compañía ' || nCodCia);
   END;

   OC_COMPROBANTES_DETALLE.ACTUALIZA_FECHA(nCodCia, nNumComprob, dFecComprob);
   OC_COMPROBANTES_CONTABLES.CUADRA_COMPROBANTE(nCodCia, nNumComprobRev);
END REVERSA_COMPROBANTE;

PROCEDURE ACTUALIZA_ENVIO(nCodCia NUMBER, nNumComprob NUMBER, nNumPolMizar NUMBER := 0) IS
BEGIN
   BEGIN
      UPDATE COMPROBANTES_CONTABLES
         SET StsComprob  = 'ENV',
             FecSts      = TRUNC(SYSDATE),
             FecEnvioSC  = TRUNC(SYSDATE),
             NUMCOMPROBSC= nNumPolMizar
       WHERE CodCia     = nCodCia
         AND NumComprob = nNumComprob;
   END;
END ACTUALIZA_ENVIO;

PROCEDURE CONTABILIZAR(nCodCia NUMBER, nIdTransaccion NUMBER, cTipoComp VARCHAR2 DEFAULT 'C') IS
nCodEmpresa        TIPOS_DE_SEGUROS.CodEmpresa%TYPE;
cIdTipoSeg         TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;
cCodCpto           CONCEPTOS_PLAN_DE_PAGOS.CodCpto%TYPE;
cTipoComprob       PROCESOS_CONTABLES.TipoComprob%TYPE;
nNumComprob        COMPROBANTES_CONTABLES.NumComprob%TYPE  := 0;
cDescMovCuenta     COMPROBANTES_DETALLE.DescMovCuenta%TYPE := NULL;
cDescMovGeneral    COMPROBANTES_DETALLE.DescMovCuenta%TYPE := NULL;
nMtoMovCuenta      COMPROBANTES_DETALLE.MtoMovCuenta%TYPE;
nMtoMovCuentaLocal COMPROBANTES_DETALLE.MtoMovCuentaLocal%TYPE;
nIdProceso         TRANSACCION.IdProceso%TYPE;
cDescProceso       PROC_TAREA.Descripcion_Proceso%TYPE;
cCodSubProceso     SUB_PROCESO.CodSubProceso%TYPE;
cDescSubProceso    SUB_PROCESO.Descripcion%TYPE;
dFechaTransaccion  TRANSACCION.FechaTransaccion%TYPE;
cCodProceso        SUB_PROCESO.CodProcesoCont%TYPE;
cDescConcepto      VALORES_DE_LISTAS.DescValLst%TYPE;
nIdTransac         TRANSACCION.IdTransaccion%TYPE;
cTipoDiario        COMPROBANTES_CONTABLES.TipoDiario%TYPE;
cCodMoneda         COMPROBANTES_CONTABLES.CodMoneda%TYPE := NULL;
cCodMonedaCia      EMPRESAS.Cod_Moneda%TYPE;
nTasaCambio        TASAS_CAMBIO.Tasa_Cambio%TYPE;
cContabilizo       VARCHAR2(1);
--
CURSOR PLANT_Q IS
   SELECT NivelCta1, NivelCta2, NivelCta3, NivelCta4, NivelCta5,
          NivelCta6, NivelCta7, NivelAux, RegDebCred, TipoRegistro,
          CodCentroCosto, CodUnidadNegocio, TipoPersona, CanalComisVenta,
          DescCptoGeneral, TipoAgente
     FROM PLANTILLAS_CONTABLES
    WHERE CodMoneda  = cCodMoneda
      AND CodCpto    = cCodCpto
      AND IdTipoSeg  = cIdTipoSeg
      AND CodEmpresa = nCodEmpresa
      AND CodProceso = cCodProceso
      AND CodCia     = nCodCia
    ORDER BY IdRegPlantilla;

CURSOR SUBPROC_Q IS
   SELECT DISTINCT CodSubProceso
     INTO cCodSubProceso
     FROM DETALLE_TRANSACCION D
    WHERE IdTransaccion = nIdTransaccion
    ORDER BY CodSubProceso;

CURSOR MOV_Q IS
   SELECT D.CodEmpresa, DP.IdTipoSeg, DF.CodCpto, F.Cod_Moneda CodMoneda, SUM(DF.Monto_Det_Moneda) MtoMovCuenta,
          SUM(F.MtoComisi_Moneda) MtoComisCuenta, 'FACTURAS CONTABILIZADAS' DescripMov
     FROM DETALLE_FACTURAS DF, FACTURAS F, DETALLE_TRANSACCION D, TRANSACCION T, DETALLE_POLIZA DP
    WHERE DP.IdPoliza         = F.IdPoliza
      AND DP.IDetPol          = NVL(F.IDetPol,DP.IDetPol)
      AND DP.CodCia           = D.CodCia
      AND ((TRUNC(F.FecVenc) <= TRUNC(FechaTransaccion)
      AND   OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'DEVENG')
       OR OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'ANTICI')
      AND DF.IdFactura        = F.IdFactura
      AND T.IdTransaccion     = nIdTransaccion
      AND (F.IdTransaccion    = D.IdTransaccion
       OR (F.IdTransaccionAnu = D.IdTransaccion
      AND  F.IndContabilizada = 'S')
       OR F.IdTransacContab   = D.IdTransaccion)
      AND D.Correlativo       = 1
      AND D.IdTransaccion     = nIdTransaccion
      AND D.CodCia            = nCodCia
    GROUP BY D.CodEmpresa, DP.IdTipoSeg, DF.CodCpto, F.Cod_Moneda, NULL
    UNION
   SELECT D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
          SUM(N.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov
     FROM DETALLE_NOTAS_DE_CREDITO DN, DETALLE_TRANSACCION D, NOTAS_DE_CREDITO N, DETALLE_POLIZA DP
    WHERE DP.IdPoliza          = N.IdPoliza
      AND DP.IDetPol           = NVL(N.IDetPol, DP.IDetPol)
      AND DP.CodCia            = D.CodCia
      AND DN.IdNcr             = N.IdNcr
      AND N.IdTransaccion      = D.IdTransaccion
      AND D.Correlativo        = 1
      AND D.IdTransaccion      = nIdTransaccion
      AND D.CodCia             = nCodCia
    GROUP BY D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, NULL
UNION
   SELECT D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
          SUM(N.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov
     FROM DETALLE_NOTAS_DE_CREDITO DN, DETALLE_TRANSACCION D, NOTAS_DE_CREDITO N, DETALLE_POLIZA DP
    WHERE DP.IdPoliza          = N.IdPoliza
      AND DP.IDetPol           = NVL(N.IDetPol, DP.IDetPol)
      AND DP.CodCia            = D.CodCia
      AND DN.IdNcr             = N.IdNcr
      AND N.IdTransaccionAnu   = D.IdTransaccion
      AND D.Correlativo        = 1
      AND D.IdTransaccion      = nIdTransaccion
      AND D.CodCia             = nCodCia
    GROUP BY D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, NULL
UNION
   SELECT D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
          SUM(N.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov
     FROM DETALLE_NOTAS_DE_CREDITO DN, DETALLE_TRANSACCION D, NOTAS_DE_CREDITO N, DETALLE_POLIZA DP
    WHERE DP.IdPoliza          = N.IdPoliza
      AND DP.IDetPol           = NVL(N.IDetPol, DP.IDetPol)
      AND DP.CodCia            = D.CodCia
      AND DN.IdNcr             = N.IdNcr
      AND N.IdTransacAplic     = D.IdTransaccion
      AND D.Correlativo        = 1
      AND D.IdTransaccion      = nIdTransaccion
      AND D.CodCia             = nCodCia
    GROUP BY D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, NULL
UNION
   SELECT D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
          SUM(N.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov
     FROM DETALLE_NOTAS_DE_CREDITO DN, DETALLE_TRANSACCION D, NOTAS_DE_CREDITO N, DETALLE_POLIZA DP
    WHERE DP.IdPoliza          = N.IdPoliza
      AND DP.IDetPol           = NVL(N.IDetPol, DP.IDetPol)
      AND DP.CodCia            = D.CodCia
      AND DN.IdNcr             = N.IdNcr
      AND N.IdTransacRevAplic  = D.IdTransaccion
      AND D.Correlativo        = 1
      AND D.IdTransaccion      = nIdTransaccion
      AND D.CodCia             = nCodCia
    GROUP BY D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, NULL           
    UNION
   SELECT D.CodEmpresa, 'GENERA' IdTipoSeg, DN.CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
          SUM(N.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov
     FROM DETALLE_NOTAS_DE_CREDITO DN, DETALLE_TRANSACCION D, NOTAS_DE_CREDITO N 
    WHERE DN.IdNcr             = N.IdNcr
      AND N.IdPoliza          IS NULL
      AND N.IdTransaccion     = D.IdTransaccion
      AND D.Correlativo        = 1
      AND D.IdTransaccion      = nIdTransaccion
      AND D.CodCia             = nCodCia
    GROUP BY D.CodEmpresa, 'GENERA', DN.CodCpto, N.CodMoneda, NULL
UNION
   SELECT D.CodEmpresa, 'GENERA' IdTipoSeg, DN.CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
          SUM(N.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov
     FROM DETALLE_NOTAS_DE_CREDITO DN, DETALLE_TRANSACCION D, NOTAS_DE_CREDITO N 
    WHERE DN.IdNcr             = N.IdNcr
      AND N.IdPoliza          IS NULL
      AND N.IdTransaccionAnu  = D.IdTransaccion
      AND D.Correlativo        = 1
      AND D.IdTransaccion      = nIdTransaccion
      AND D.CodCia             = nCodCia
    GROUP BY D.CodEmpresa, 'GENERA', DN.CodCpto, N.CodMoneda, NULL
UNION
   SELECT D.CodEmpresa, 'GENERA' IdTipoSeg, DN.CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
          SUM(N.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov
     FROM DETALLE_NOTAS_DE_CREDITO DN, DETALLE_TRANSACCION D, NOTAS_DE_CREDITO N 
    WHERE DN.IdNcr             = N.IdNcr
      AND N.IdPoliza          IS NULL
      AND N.IdTransacAplic    = D.IdTransaccion
      AND D.Correlativo        = 1
      AND D.IdTransaccion      = nIdTransaccion
      AND D.CodCia             = nCodCia
    GROUP BY D.CodEmpresa, 'GENERA', DN.CodCpto, N.CodMoneda, NULL
UNION
   SELECT D.CodEmpresa, 'GENERA' IdTipoSeg, DN.CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
          SUM(N.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov
     FROM DETALLE_NOTAS_DE_CREDITO DN, DETALLE_TRANSACCION D, NOTAS_DE_CREDITO N 
    WHERE DN.IdNcr             = N.IdNcr
      AND N.IdPoliza          IS NULL
      AND N.IdTransacRevAplic = D.IdTransaccion
      AND D.Correlativo        = 1
      AND D.IdTransaccion      = nIdTransaccion
      AND D.CodCia             = nCodCia
    GROUP BY D.CodEmpresa, 'GENERA', DN.CodCpto, N.CodMoneda, NULL
    UNION
   SELECT DISTINCT CFT.CodEmpresa, CFT.IdTipoSeg, RTC.CodCptoRva, cCodMonedaCia CodMoneda,
          SUM(RTC.MtoCptoRva) MtoMovCuenta, 0 MtoComisCuenta, RTC.DescCptoRva DescripMov
     FROM RESERVAS_TECNICAS_CONTAB RTC, RESERVAS_TECNICAS RT,
          CONFIG_RESERVAS CF, CONFIG_RESERVAS_TIPOSEG CFT
    WHERE CFT.CodCia       = CF.Codcia
      AND CFT.CodReserva   = CF.CodReserva
      AND CF.CodCia        = RT.CodCia
      AND CF.CodReserva    = RT.CodReserva
      AND RTC.IdReserva    = RT.IdReserva
      AND RT.IdTransaccion = nIdTransaccion
    GROUP BY CFT.CodEmpresa, CFT.IdTipoSeg, RTC.CodCptoRva, cCodMonedaCia, RTC.DescCptoRva
    UNION
   SELECT S.CodEmpresa, D.IdTipoSeg, C.CodCptoTransac CodCpto, S.Cod_Moneda CodMoneda,
          SUM(C.Monto_Reservado_Moneda) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION DT, COBERTURA_SINIESTRO C, SINIESTRO S, DETALLE_SINIESTRO D
    WHERE S.IdSiniestro        = C.IdSiniestro
      AND S.IdSiniestro        = D.IdSiniestro
      AND S.CodCia             = nCodCia
      AND DT.Correlativo       = 1
      --  JICO 20160823
      AND C.IDSINIESTRO        = DT.VALOR1
      AND C.CODCOBERT          = DT.VALOR3
      AND (C.IdTransaccion     = DT.IdTransaccion
       OR  C.IdTransaccionAnul = DT.IdTransaccion)
      AND DT.IdTransaccion     = nIdTransaccion
    GROUP BY s.CodEmpresa, D.IdTipoSeg, C.CodCptoTransac, S.Cod_Moneda, NULL
    UNION
   SELECT S.CodEmpresa, D.IdTipoSeg, DA.CodCptoTransac CodCpto, S.Cod_Moneda CodMoneda,
          SUM(DA.Monto_Moneda) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION DT, DETALLE_APROBACION DA, APROBACIONES A, SINIESTRO S, DETALLE_SINIESTRO D
    WHERE S.IdSiniestro        = A.IdSiniestro
      AND S.IdSiniestro        = D.IdSiniestro
      AND A.IdSiniestro        = DA.IdSiniestro
      AND A.Num_Aprobacion     = DA.Num_Aprobacion
      AND S.CodCia             = nCodCia
      AND DT.Correlativo       = 1
      --  JICO 20160823
      AND A.IDSINIESTRO        = DT.VALOR1
      AND (A.IdTransaccion     = DT.IdTransaccion
       OR  A.IdTransaccionAnul = DT.IdTransaccion)
      AND DT.IdTransaccion     = nIdTransaccion
    GROUP BY S.CodEmpresa, D.IdTipoSeg, DA.CodCptoTransac, S.Cod_Moneda, NULL
    UNION
   SELECT D.CodEmpresa, TP.IdTipoSeg, 'PRIMDE' CodCpto, P.Cod_Moneda CodMoneda,
          SUM(Monto_Moneda) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION D, PRIMAS_DEPOSITO P, TARJETAS_PREPAGO TP
    WHERE TP.IdPrimaDeposito = P.IdPrimaDeposito
      --  JICO 20160823
      AND P.IDPRIMADEPOSITO  = D.VALOR1
      AND (P.IdTransacEmit   = D.IdTransaccion
       OR P.IdTransacAplic   = D.IdTransaccion
       OR P.IdTransacAnul    = D.IdTransaccion)
      AND D.IdTransaccion    = nIdTransaccion
      AND D.CodCia           = nCodCia
    GROUP BY D.CodEmpresa, TP.IdTipoSeg, 'PRIMDE', P.Cod_Moneda, NULL
    UNION
   SELECT D.CodEmpresa, DP.IdTipoSeg, 'PRIMDE' CodCpto, P.Cod_Moneda CodMoneda,
          SUM(Monto_Moneda) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION D, PRIMAS_DEPOSITO P, DETALLE_POLIZA DP
    WHERE DP.IDetPol         = P.IDetPol
      AND DP.IdPoliza        = P.IdPoliza
      AND DP.CodCia          = nCodCia
      --  JICO 20160823
      AND P.IDPRIMADEPOSITO  = D.VALOR1      
      AND (P.IdTransacEmit   = D.IdTransaccion
       OR P.IdTransacAplic   = D.IdTransaccion
       OR P.IdTransacAnul    = D.IdTransaccion)
      AND D.IdTransaccion    = nIdTransaccion
      AND D.CodCia           = nCodCia
    GROUP BY D.CodEmpresa, DP.IdTipoSeg, 'PRIMDE', P.Cod_Moneda, NULL
    UNION
   SELECT DP.CodEmpresa, DP.IdTipoSeg, PD.CodCpto, P.Moneda CodMoneda,
          SUM(PD.Monto) MtoMovCuenta, SUM(F.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION D, FACTURAS F, PAGOS P, PAGO_DETALLE PD, DETALLE_POLIZA DP
    WHERE F.IdFactura         = P.IdFactura
      AND PD.IdRecibo         = P.IdRecibo
      AND P.IdTransaccion     = D.IdTransaccion
      AND D.Correlativo       = 1
      AND D.IdTransaccion     = nIdTransaccion
      AND F.IDetPol           = DP.IDetPol
      AND F.IdPoliza          = DP.IdPoliza
    GROUP BY DP.CodEmpresa, DP.IdTipoSeg, PD.CodCpto, P.Moneda, NULL
UNION
   SELECT DP.CodEmpresa, DP.IdTipoSeg, PD.CodCpto, P.Moneda CodMoneda,
          SUM(PD.Monto) MtoMovCuenta, SUM(F.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION D, FACTURAS F, PAGOS P, PAGO_DETALLE PD, DETALLE_POLIZA DP
    WHERE F.IdFactura         = P.IdFactura
      AND PD.IdRecibo         = P.IdRecibo
      AND P.IdTransaccionAnu  = D.IdTransaccion
      AND D.Correlativo       = 1
      AND D.IdTransaccion     = nIdTransaccion
      AND F.IDetPol           = DP.IDetPol
      AND F.IdPoliza          = DP.IdPoliza
    GROUP BY DP.CodEmpresa, DP.IdTipoSeg, PD.CodCpto, P.Moneda, NULL
    UNION
   SELECT PD.CodEmpresa, PD.IdTipoSeg, DECODE(P.FormPago,'NCR','PAGNCR','PAGREC') CodCpto, P.Moneda CodMoneda,
          SUM(P.Monto) MtoMovCuenta, 1 MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION D, FACTURAS F, PAGOS P, DETALLE_POLIZA PD
    WHERE F.IdFactura         = P.IdFactura
      AND (P.IdTransaccion    = D.IdTransaccion
       OR  P.IdTransaccionAnu = D.IdTransaccion)
      AND D.Correlativo       = 1
      AND D.IdTransaccion     = nIdTransaccion
      AND F.IdetPol           = PD.IdetPol
      AND F.IdPoliza          = PD.IdPoliza
    GROUP BY PD.CodEmpresa, PD.IdTipoSeg, DECODE(P.FormPago,'NCR','PAGNCR','PAGREC'), P.Moneda, NULL
   UNION
   SELECT S.CodEmpresa, D.IdTipoSeg, C.CodCptoTransac CodCpto, S.Cod_Moneda CodMoneda,
          SUM(C.Monto_Reservado_Moneda) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION DT, COBERTURA_SINIESTRO_ASEG C, SINIESTRO S, DETALLE_SINIESTRO_ASEG D
    WHERE S.IdSiniestro        = C.IdSiniestro
      AND S.IdSiniestro        = D.IdSiniestro
      AND S.CodCia             = nCodCia
      AND DT.Correlativo       = 1
      --  JICO 20160823
      AND C.IDSINIESTRO        = DT.VALOR1
      AND (C.IdTransaccion     = DT.IdTransaccion
       OR  C.IdTransaccionAnul = DT.IdTransaccion)
      AND DT.IdTransaccion     = nIdTransaccion
    GROUP BY S.CodEmpresa, D.IdTipoSeg, C.CodCptoTransac, S.Cod_Moneda, NULL
    UNION
   SELECT S.CodEmpresa, D.IdTipoSeg, DA.CodCptoTransac CodCpto, S.Cod_Moneda CodMoneda,
          SUM(DA.Monto_Moneda) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION DT, DETALLE_APROBACION_ASEG DA, APROBACION_ASEG A, SINIESTRO S, DETALLE_SINIESTRO_ASEG D
    WHERE S.IdSiniestro        = A.IdSiniestro
      AND S.IdSiniestro        = D.IdSiniestro
      AND A.IdSiniestro        = DA.IdSiniestro
      AND A.Num_Aprobacion     = DA.Num_Aprobacion
      AND S.CodCia             = nCodCia
      AND DT.Correlativo       = 1
      -- JICO 20160823
      AND A.IDSINIESTRO        = DT.VALOR1
      AND (A.IdTransaccion     = DT.IdTransaccion
       OR  A.IdTransaccionAnul = DT.IdTransaccion)
      AND DT.IdTransaccion = nIdTransaccion
    GROUP BY S.CodEmpresa, D.IdTipoSeg, DA.CodCptoTransac, S.Cod_Moneda, NULL
    UNION
   SELECT D.CodEmpresa, DP.IdTipoSeg, DF.CodCpto, F.Cod_Moneda CodMoneda, SUM(DF.Monto_Det_Moneda) MtoMovCuenta,
          SUM(F.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION D, DETALLE_FACTURAS DF, FACTURAS F, FZ_DETALLE_FIANZAS  DP
    WHERE DP.IdPoliza      = F.IdPoliza
      AND DP.Correlativo   = NVL(F.IDetPol,DP.Correlativo)
      AND DP.CodCia        = D.CodCia
      AND DF.IdFactura     = F.IdFactura
      AND (F.IdTransaccion = D.IdTransaccion 
      OR F.IdTransaccionAnu = D.IdTransaccion)
      AND D.Correlativo    = 1
      AND D.IdTransaccion  = nIdTransaccion
      AND D.CodCia         = nCodCia
    GROUP BY D.CodEmpresa, DP.IdTipoSeg, DF.CodCpto, F.Cod_Moneda, NULL
    UNION
   SELECT CF.CodEmpresa, DP.IdTipoSeg, CF.CodCptoMov CodCpto, CF.CodMonedaPago CodMoneda, SUM(CF.MontoMovMoneda) MtoMovCuenta,
          SUM(F.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION D, FAI_CONCENTRADORA_FONDO CF, FACTURAS F, DETALLE_POLIZA  DP
    WHERE DP.IdPoliza         = CF.IdPoliza
      AND DP.IDetPol          = CF.IDetPol
      AND DP.CodCia           = CF.CodCia
      AND CF.IdFondo          > 0
      AND CF.CodAsegurado     > 0
      AND CF.IDetPol          > 0
      AND CF.IdPoliza         > 0
      AND CF.IdFactura        = F.IdFactura(+)
      AND (CF.IdTransaccion   = D.IdTransaccion 
       OR CF.IdTransaccionAnu = D.IdTransaccion)
      AND CF.CodEmpresa       = D.CodEmpresa
      AND CF.CodCia           = D.CodCia
--      AND GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(CF.CodCia, CF.CodEmpresa, 
--                                                GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(CF.IdFondo), 
--                                                CF.CodCptoMov, 'GC') = 'S'
      AND D.Correlativo       = 1
      AND D.IdTransaccion     = nIdTransaccion
      AND D.CodCia            = nCodCia
    GROUP BY CF.CodEmpresa, DP.IdTipoSeg, CF.CodCptoMov, CF.CodMonedaPago, NULL;
BEGIN
  --
   cCodMonedaCia  := OC_EMPRESAS.MONEDA_COMPANIA(nCodCia);
   cContabilizo   := 'N';
   FOR Z IN SUBPROC_Q LOOP
DBMS_OUTPUT.PUT_LINE('Z.CodSubProceso -> '||Z.CodSubProceso);
DBMS_OUTPUT.PUT_LINE('nIdTransaccion -> '||nIdTransaccion);
      BEGIN
         SELECT DISTINCT T.IdProceso, T.FechaTransaccion, S.CodProcesoCont
           INTO nIdProceso, dFechaTransaccion, cCodProceso
           FROM TRANSACCION T, SUB_PROCESO S
          WHERE S.CodSubProceso = Z.CodSubProceso
            AND S.IdProceso     = T.IdProceso
            AND T.IdTransaccion = nIdTransaccion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR (-20100,'No de Transacción '||nIdTransaccion||' NO Encuentra el SubProceso '||Z.CodSubProceso);
         WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR (-20100,'No de Transacción '||nIdTransaccion||' Posee Más de un Proceso');
      END;
      -- 
      IF OC_SUB_PROCESO.GENERA_CONTABILIDAD(nIdProceso, Z.CodSubProceso) = 'S' THEN
         -- Lee el Tipo de Comprobante a Crear
         IF NVL(nNumComprob,0) = 0 THEN
            cTipoComprob    := OC_PROCESOS_CONTABLES.TIPO_COMPROBANTE(nCodCia, cCodProceso, cTipoComp);
            cTipoDiario     := OC_PROCESOS_CONTABLES.TIPO_DIARIO(nCodCia, cCodProceso);
            nNumComprob     := CREA_COMPROBANTE(nCodCia, cTipoComprob, nIdTransaccion, cTipoDiario, cCodMonedaCia);
            UPDATE COMPROBANTES_CONTABLES
               SET FecComprob = TRUNC(dFechaTransaccion),
                   FecSts     = TRUNC(dFechaTransaccion)
             WHERE NumComprob = nNumComprob
               AND CodCia     = nCodCia;
         END IF;
         -- Descripcin del Movimiento Contable
         cDescProceso    := OC_PROC_TAREA.NOMBRE_PROCESO(nIdProceso);
         cDescSubProceso := OC_SUB_PROCESO.NOMBRE_SUBPROCESO(nIdProceso, Z.CodSubProceso);
         cDescMovGeneral := 'Contabilización de ' || cDescProceso || ' para SubProceso ' || cDescSubProceso ||
                            ' de la Transacción No. ' || TRIM(TO_CHAR(nIdTransaccion)) || ' del ' ||
                            TO_CHAR(dFechaTransaccion,'DD/MM/YYYY');
         FOR W IN MOV_Q LOOP
            nTasaCambio    := OC_GENERALES.TASA_DE_CAMBIO(W.CodMoneda, TRUNC(dFechaTransaccion));
            nCodEmpresa    := W.CodEmpresa;
            cIdTipoSeg     := W.IdTipoSeg;
            cCodCpto       := W.CodCpto;
            IF W.CodMoneda IS NOT NULL AND cCodMoneda IS NULL THEN
               cCodMoneda     := W.CodMoneda;
            END IF;
            -- Actualiza Facturas por Tipo de Contabilidad Anticipada o Devengada
            IF W.DescripMov = 'FACTURAS CONTABILIZADAS' THEN
               OC_FACTURAS.ACTUALIZA_CONTABILIZACION(nCodCia, nIdTransaccion);
            END IF;
            FOR X IN PLANT_Q LOOP
               IF X.TipoRegistro = 'MO' THEN
                  IF X.TipoAgente IS NULL THEN
                     nMtoMovCuenta := ABS(W.MtoMovCuenta);
                  ELSIF OC_COMPROBANTES_CONTABLES.APLICA_TIPO_AGENTE(nCodCia, nIdTransaccion, cIdTipoSeg, X.TipoAgente) = 'S' THEN
                     nMtoMovCuenta := ABS(W.MtoMovCuenta);
                  ELSE
                     nMtoMovCuenta := 0;
                  END IF;
               ELSE
                  IF ABS(W.MtoComisCuenta) != 0 THEN
                     nMtoMovCuenta := ABS(OC_COMPROBANTES_CONTABLES.COMISION_TIPO_PERSONA(nCodCia, nIdTransaccion, cIdTipoSeg,
                                                                                          X.TipoPersona, X.TipoAgente));
                  ELSE
                     nMtoMovCuenta := 0;
                  END IF;
               END IF;
               IF X.CanalComisVenta IS NOT NULL THEN
                  --
                  IF OC_COMPROBANTES_CONTABLES.APLICA_CANAL_VENTA(nCodCia, nIdTransaccion, cIdTipoSeg, X.CanalComisVenta) = 'N' THEN
                     nMtoMovCuenta := 0;
                  END IF;
                  --
               END IF;
               IF NVL(nMtoMovCuenta,0) != 0 THEN
                  IF W.DescripMov IS NULL OR W.DescripMov = 'FACTURAS CONTABILIZADAS' THEN
                     cDescConcepto := OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, cCodCpto);
                     IF cDescConcepto = 'CONCEPTO NO EXISTE' THEN
                        cDescConcepto    := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('RVACONTA', cCodCpto);
                        IF cDescConcepto = 'NO EXISTE' THEN
                           cDescConcepto := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CPTOSINI', cCodCpto);
                        END IF;
                     END IF;
                     cDescMovCuenta := cDescMovGeneral || ' por el Concepto de ' || TRIM(cCodCpto) || '-' ||
                                       TRIM(cDescConcepto) || ' y un Monto de ' ||
                                       TRIM(TO_CHAR(nMtoMovCuenta,'999,999,999,990.00') || ' y Concepto MIZAR ' ||
                                       X.DescCptoGeneral);
                  ELSE
                     cDescMovCuenta := W.DescripMov;
                  END IF;
                  cContabilizo   := 'S';
                  nMtoMovCuentaLocal := nMtoMovCuenta * nTasaCambio;
                  OC_COMPROBANTES_DETALLE.INSERTA_DETALLE(nCodCia, nNumComprob, X.NivelCta1, X.NivelCta2,
                                                          X.NivelCta3, X.NivelCta4, X.NivelCta5,
                                                          X.NivelCta6, X.NivelCta7, X.NivelAux, X.RegDebCred,
                                                          nMtoMovCuenta, cDescMovCuenta, X.CodCentroCosto,
                                                          X.CodUnidadNegocio, X.DescCptoGeneral, nMtoMovCuentaLocal);
               END IF;
            END LOOP;
         END LOOP;
         IF cContabilizo = 'S' THEN
            OC_COMPROBANTES_CONTABLES.ACTUALIZA_MONEDA(nCodCia, nNumComprob, NVL(cCodMoneda,cCodMonedaCia));
            OC_COMPROBANTES_DETALLE.ACTUALIZA_FECHA(nCodCia, nNumComprob, TRUNC(dFechaTransaccion));
            OC_COMPROBANTES_CONTABLES.CUADRA_COMPROBANTE(nCodCia, nNumComprob);
         ELSE
            OC_COMPROBANTES_CONTABLES.ELIMINA_COMPROBANTE(nCodCia, nNumComprob);
         END IF;
      END IF;
   END LOOP;
END CONTABILIZAR;

PROCEDURE RECONTABILIZAR(nCodCia NUMBER, nIdTransaccion NUMBER, cTipoComp VARCHAR2 DEFAULT 'C', nNumComprob NUMBER) IS
nCodEmpresa        TIPOS_DE_SEGUROS.CodEmpresa%TYPE;
cIdTipoSeg         TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;
cCodCpto           CONCEPTOS_PLAN_DE_PAGOS.CodCpto%TYPE;
cTipoComprob       PROCESOS_CONTABLES.TipoComprob%TYPE;
cDescMovCuenta     COMPROBANTES_DETALLE.DescMovCuenta%TYPE := NULL;
cDescMovGeneral    COMPROBANTES_DETALLE.DescMovCuenta%TYPE := NULL;
nMtoMovCuenta      COMPROBANTES_DETALLE.MtoMovCuenta%TYPE;
nMtoMovCuentaLocal COMPROBANTES_DETALLE.MtoMovCuentaLocal%TYPE;
nIdProceso         TRANSACCION.IdProceso%TYPE;
cDescProceso       PROC_TAREA.Descripcion_Proceso%TYPE;
cCodSubProceso     SUB_PROCESO.CodSubProceso%TYPE;
cDescSubProceso    SUB_PROCESO.Descripcion%TYPE;
dFechaTransaccion  TRANSACCION.FechaTransaccion%TYPE;
cCodProceso        SUB_PROCESO.CodProcesoCont%TYPE;
cDescConcepto      VALORES_DE_LISTAS.DescValLst%TYPE;
nNumComprobRecont  COMPROBANTES_CONTABLES.NumComprob%TYPE;
cTipoDiario        COMPROBANTES_CONTABLES.TipoDiario%TYPE;
dFecComprob        COMPROBANTES_CONTABLES.FecComprob%TYPE;
dFecSts            COMPROBANTES_CONTABLES.FecSts%TYPE;
cCodMoneda         COMPROBANTES_CONTABLES.CodMoneda%TYPE := NULL;
cCodMonedaCia      EMPRESAS.Cod_Moneda%TYPE;
nTasaCambio        TASAS_CAMBIO.Tasa_Cambio%TYPE;

CURSOR PLANT_Q IS
   SELECT NivelCta1, NivelCta2, NivelCta3, NivelCta4, NivelCta5,
          NivelCta6, NivelCta7, NivelAux, RegDebCred, TipoRegistro,
          CodCentroCosto, CodUnidadNegocio, TipoPersona, CanalComisVenta,
          DescCptoGeneral, TipoAgente
     FROM PLANTILLAS_CONTABLES
    WHERE CodMoneda  = cCodMoneda
      AND CodCpto    = cCodCpto
      AND IdTipoSeg  = cIdTipoSeg
      AND CodEmpresa = nCodEmpresa
      AND CodProceso = cCodProceso
      AND CodCia     = nCodCia
    ORDER BY IdRegPlantilla;

CURSOR SUBPROC_Q IS
   SELECT DISTINCT CodSubProceso
     INTO cCodSubProceso
     FROM DETALLE_TRANSACCION D
    WHERE IdTransaccion = nIdTransaccion;

CURSOR MOV_Q IS
   SELECT D.CodEmpresa, DP.IdTipoSeg, DF.CodCpto, F.Cod_Moneda CodMoneda, SUM(DF.Monto_Det_Moneda) MtoMovCuenta,
          SUM(F.MtoComisi_Moneda) MtoComisCuenta, 'FACTURAS CONTABILIZADAS' DescripMov
     FROM DETALLE_FACTURAS DF, FACTURAS F, DETALLE_TRANSACCION D, TRANSACCION T, DETALLE_POLIZA DP
    WHERE DP.IdPoliza         = F.IdPoliza
      AND DP.IDetPol          = NVL(F.IDetPol,DP.IDetPol)
      AND DP.CodCia           = D.CodCia
      AND ((TRUNC(F.FecVenc) <= TRUNC(FechaTransaccion)
      AND   OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'DEVENG')
       OR OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'ANTICI')
      AND DF.IdFactura        = F.IdFactura
      AND T.IdTransaccion     = nIdTransaccion
      AND (F.IdTransaccion    = D.IdTransaccion
       OR (F.IdTransaccionAnu = D.IdTransaccion
      AND  F.IndContabilizada = 'S')
       OR F.IdTransacContab   = D.IdTransaccion)
      AND D.Correlativo       = 1
      AND D.IdTransaccion     = nIdTransaccion
      AND D.CodCia            = nCodCia
    GROUP BY D.CodEmpresa, DP.IdTipoSeg, DF.CodCpto, F.Cod_Moneda, NULL
    UNION
   SELECT D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
          SUM(N.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov
     FROM DETALLE_NOTAS_DE_CREDITO DN, DETALLE_TRANSACCION D, NOTAS_DE_CREDITO N, DETALLE_POLIZA DP
    WHERE DP.IdPoliza          = N.IdPoliza
      AND DP.IDetPol           = NVL(N.IDetPol, DP.IDetPol)
      AND DP.CodCia            = D.CodCia
      AND DN.IdNcr             = N.IdNcr
      AND (N.IdTransaccion     = D.IdTransaccion
       OR  N.IdTransaccionAnu  = D.IdTransaccion
       OR  N.IdTransacAplic    = D.IdTransaccion
       OR  N.IdTransacRevAplic = D.IdTransaccion)
      AND D.Correlativo        = 1
      AND D.IdTransaccion      = nIdTransaccion
      AND D.CodCia             = nCodCia
    GROUP BY D.CodEmpresa, DP.IdTipoSeg, DN.CodCpto, N.CodMoneda, NULL
    UNION
   SELECT D.CodEmpresa, 'GENERA' IdTipoSeg, DN.CodCpto, N.CodMoneda, SUM(Monto_Det_Moneda) MtoMovCuenta,
          SUM(N.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov
     FROM DETALLE_NOTAS_DE_CREDITO DN, DETALLE_TRANSACCION D, NOTAS_DE_CREDITO N 
    WHERE DN.IdNcr             = N.IdNcr
      AND N.IdPoliza          IS NULL
      AND (N.IdTransaccion     = D.IdTransaccion
       OR  N.IdTransaccionAnu  = D.IdTransaccion
       OR  N.IdTransacAplic    = D.IdTransaccion
       OR  N.IdTransacRevAplic = D.IdTransaccion)
      AND D.Correlativo        = 1
      AND D.IdTransaccion      = nIdTransaccion
      AND D.CodCia             = nCodCia
    GROUP BY D.CodEmpresa, 'GENERA', DN.CodCpto, N.CodMoneda, NULL
    UNION
   SELECT DISTINCT CFT.CodEmpresa, CFT.IdTipoSeg, RTC.CodCptoRva, cCodMonedaCia CodMoneda,
          SUM(RTC.MtoCptoRva) MtoMovCuenta, 0 MtoComisCuenta, RTC.DescCptoRva DescripMov
     FROM RESERVAS_TECNICAS_CONTAB RTC, RESERVAS_TECNICAS RT,
          CONFIG_RESERVAS CF, CONFIG_RESERVAS_TIPOSEG CFT
    WHERE CFT.CodCia       = CF.Codcia
      AND CFT.CodReserva   = CF.CodReserva
      AND CF.CodCia        = RT.CodCia
      AND CF.CodReserva    = RT.CodReserva
      AND RTC.IdReserva    = RT.IdReserva
      AND RT.IdTransaccion = nIdTransaccion
    GROUP BY CFT.CodEmpresa, CFT.IdTipoSeg, RTC.CodCptoRva, cCodMonedaCia, RTC.DescCptoRva
    UNION
   SELECT S.CodEmpresa, D.IdTipoSeg, C.CodCptoTransac CodCpto, S.Cod_Moneda CodMoneda,
          SUM(C.Monto_Reservado_Moneda) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION DT, COBERTURA_SINIESTRO C, SINIESTRO S, DETALLE_SINIESTRO D
    WHERE S.IdSiniestro        = C.IdSiniestro
      AND S.IdSiniestro        = D.IdSiniestro
      AND S.CodCia             = nCodCia
      AND DT.Correlativo       = 1
      AND (C.IdTransaccion     = DT.IdTransaccion
       OR  C.IdTransaccionAnul = DT.IdTransaccion)
      AND DT.IdTransaccion     = nIdTransaccion
    GROUP BY s.CodEmpresa, D.IdTipoSeg, C.CodCptoTransac, S.Cod_Moneda, NULL
    UNION
   SELECT S.CodEmpresa, D.IdTipoSeg, DA.CodCptoTransac CodCpto, S.Cod_Moneda CodMoneda,
          SUM(DA.Monto_Local) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION DT, DETALLE_APROBACION DA, APROBACIONES A, SINIESTRO S, DETALLE_SINIESTRO D
    WHERE S.IdSiniestro    = A.IdSiniestro
      AND S.IdSiniestro    = D.IdSiniestro
      AND A.IdSiniestro    = DA.IdSiniestro
      AND A.Num_Aprobacion = DA.Num_Aprobacion
      AND S.CodCia         = nCodCia
      AND DT.Correlativo   = 1
      AND (A.IdTransaccion     = DT.IdTransaccion
       OR  A.IdTransaccionAnul = DT.IdTransaccion)
      AND DT.IdTransaccion = nIdTransaccion
    GROUP BY S.CodEmpresa, D.IdTipoSeg, DA.CodCptoTransac, S.Cod_Moneda, NULL
    UNION
   SELECT D.CodEmpresa, TP.IdTipoSeg, 'PRIMDE' CodCpto, P.Cod_Moneda CodMoneda,
          SUM(Monto_Moneda) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION D, PRIMAS_DEPOSITO P, TARJETAS_PREPAGO TP
    WHERE TP.IdPrimaDeposito = P.IdPrimaDeposito
      AND (P.IdTransacEmit   = D.IdTransaccion
       OR P.IdTransacAplic   = D.IdTransaccion
       OR P.IdTransacAnul    = D.IdTransaccion)
      AND D.IdTransaccion    = nIdTransaccion
      AND D.CodCia           = nCodCia
    GROUP BY D.CodEmpresa, TP.IdTipoSeg, 'PRIMDE', P.Cod_Moneda, NULL
    UNION
   SELECT D.CodEmpresa, DP.IdTipoSeg, 'PRIMDE' CodCpto, P.Cod_Moneda CodMoneda,
          SUM(Monto_Moneda) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION D, PRIMAS_DEPOSITO P, DETALLE_POLIZA DP
    WHERE DP.IDetPol         = P.IDetPol
      AND DP.IdPoliza        = P.IdPoliza
      AND DP.CodCia          = nCodCia
      AND (P.IdTransacEmit   = D.IdTransaccion
       OR P.IdTransacAplic   = D.IdTransaccion
       OR P.IdTransacAnul    = D.IdTransaccion)
      AND D.IdTransaccion    = nIdTransaccion
      AND D.CodCia           = nCodCia
    GROUP BY D.CodEmpresa, DP.IdTipoSeg, 'PRIMDE', P.Cod_Moneda, NULL
    UNION
   SELECT DP.CodEmpresa, DP.IdTipoSeg, PD.CodCpto, P.Moneda CodMoneda,
          SUM(PD.Monto) MtoMovCuenta, SUM(F.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION D, FACTURAS F, PAGOS P, PAGO_DETALLE PD, DETALLE_POLIZA DP
    WHERE F.IdFactura     = P.IdFactura
      AND PD.IdRecibo     = P.IdRecibo
      AND (P.IdTransaccion    = D.IdTransaccion
       OR  P.IdTransaccionAnu = D.IdTransaccion)
      AND D.Correlativo   = 1
      AND D.IdTransaccion = nIdTransaccion
      AND F.IDetPol       = DP.IDetPol
      AND F.IdPoliza      = DP.IdPoliza
    GROUP BY DP.CodEmpresa, DP.IdTipoSeg, PD.CodCpto, P.Moneda, NULL
    UNION
   SELECT PD.CodEmpresa, PD.IdTipoSeg, DECODE(P.FormPago,'NCR','PAGNCR','PAGREC') CodCpto, P.Moneda CodMoneda,
          SUM(P.Monto) MtoMovCuenta, 1 MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION D, FACTURAS F, PAGOS P, DETALLE_POLIZA PD
    WHERE F.IdFactura     = P.IdFactura
      AND (P.IdTransaccion    = D.IdTransaccion
       OR  P.IdTransaccionAnu = D.IdTransaccion)
      AND D.Correlativo   = 1
      AND D.IdTransaccion = nIdTransaccion
      AND F.IdetPol       = PD.IdetPol
      AND F.IdPoliza      = PD.IdPoliza
    GROUP BY PD.CodEmpresa, PD.IdTipoSeg, DECODE(P.FormPago,'NCR','PAGNCR','PAGREC'), P.Moneda, NULL
   UNION
   SELECT S.CodEmpresa, D.IdTipoSeg, C.CodCptoTransac CodCpto, S.Cod_Moneda CodMoneda,
          SUM(C.Monto_Reservado_Moneda) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION DT, COBERTURA_SINIESTRO_ASEG C, SINIESTRO S, DETALLE_SINIESTRO_ASEG D
    WHERE S.IdSiniestro        = C.IdSiniestro
      AND S.IdSiniestro        = D.IdSiniestro
      AND S.CodCia             = nCodCia
      AND DT.Correlativo       = 1
      AND (C.IdTransaccion     = DT.IdTransaccion
       OR  C.IdTransaccionAnul = DT.IdTransaccion)
      AND DT.IdTransaccion     = nIdTransaccion
    GROUP BY s.CodEmpresa, D.IdTipoSeg, C.CodCptoTransac, S.Cod_Moneda, NULL
    UNION
   SELECT S.CodEmpresa, D.IdTipoSeg, DA.CodCptoTransac CodCpto, S.Cod_Moneda CodMoneda,
          SUM(DA.Monto_Moneda) MtoMovCuenta, 0 MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION DT, DETALLE_APROBACION_ASEG DA, APROBACION_ASEG A, SINIESTRO S, DETALLE_SINIESTRO_ASEG D
    WHERE S.IdSiniestro        = A.IdSiniestro
      AND S.IdSiniestro        = D.IdSiniestro
      AND A.IdSiniestro        = DA.IdSiniestro
      AND A.Num_Aprobacion     = DA.Num_Aprobacion
      AND S.CodCia             = nCodCia
      AND DT.Correlativo       = 1
      AND (A.IdTransaccion     = DT.IdTransaccion
       OR  A.IdTransaccionAnul = DT.IdTransaccion)
      AND DT.IdTransaccion     = nIdTransaccion
    GROUP BY S.CodEmpresa, D.IdTipoSeg, DA.CodCptoTransac, S.Cod_Moneda, NULL
    UNION
   SELECT D.CodEmpresa, DP.IdTipoSeg, DF.CodCpto, F.Cod_Moneda CodMoneda, SUM(DF.Monto_Det_Moneda) MtoMovCuenta,
          SUM(F.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION D, DETALLE_FACTURAS DF, FACTURAS F, FZ_DETALLE_FIANZAS  DP
    WHERE DP.IdPoliza      = F.IdPoliza
      AND DP.Correlativo   = NVL(F.IDetPol,DP.Correlativo)
      AND DP.CodCia        = D.CodCia
      AND DF.IdFactura     = F.IdFactura
      AND (F.IdTransaccion = D.IdTransaccion OR F.IdTransaccionAnu = D.IdTransaccion)
      AND D.Correlativo    = 1
      AND D.IdTransaccion  = nIdTransaccion
      AND D.CodCia         = nCodCia
    GROUP BY D.CodEmpresa, DP.IdTipoSeg, DF.CodCpto, F.Cod_Moneda, NULL
    UNION
   SELECT CF.CodEmpresa, DP.IdTipoSeg, CF.CodCptoMov CodCpto, CF.CodMonedaPago CodMoneda, SUM(CF.MontoMovMoneda) MtoMovCuenta,
          SUM(F.MtoComisi_Moneda) MtoComisCuenta, NULL DescripMov
     FROM DETALLE_TRANSACCION D, FAI_CONCENTRADORA_FONDO CF, FACTURAS F, DETALLE_POLIZA  DP
    WHERE DP.IdPoliza         = CF.IdPoliza
      AND DP.IDetPol          = CF.IDetPol
      AND DP.CodCia           = CF.CodCia
      AND CF.IdFondo          > 0
      AND CF.CodAsegurado     > 0
      AND CF.IDetPol          > 0
      AND CF.IdPoliza         > 0
      AND CF.IdFactura        = F.IdFactura(+)
      AND (CF.IdTransaccion   = D.IdTransaccion 
       OR CF.IdTransaccionAnu = D.IdTransaccion)
      AND CF.CodEmpresa       = D.CodEmpresa
      AND CF.CodCia           = D.CodCia
      AND GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(CF.CodCia, CF.CodEmpresa, 
                                                GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(CF.IdFondo), 
                                                CF.CodCptoMov, 'GC') = 'S'
      AND D.Correlativo       = 1
      AND D.IdTransaccion     = nIdTransaccion
      AND D.CodCia            = nCodCia
    GROUP BY CF.CodEmpresa, DP.IdTipoSeg, CF.CodCptoMov, CF.CodMonedaPago, NULL;
BEGIN
   cCodMonedaCia   := OC_EMPRESAS.MONEDA_COMPANIA(nCodCia);
   BEGIN
      SELECT FecComprob, FecSts, NVL(CodMoneda, cCodMonedaCia)
        INTO dFecComprob, dFecSts, cCodMoneda
        FROM COMPROBANTES_CONTABLES
       WHERE CodCia     = nCodCia
         AND NumComprob = nNumComprob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         dFecComprob := NULL;
         dFecSts     := NULL;
   END;
   OC_COMPROBANTES_DETALLE.ELIMINA_DETALLE(nCodCia, nNumComprob);
   OC_COMPROBANTES_CONTABLES.ELIMINA_COMPROBANTE(nCodCia, nNumComprob);

   FOR Z IN SUBPROC_Q LOOP
      BEGIN
         SELECT DISTINCT T.IdProceso, T.FechaTransaccion, S.CodProcesoCont
           INTO nIdProceso, dFechaTransaccion, cCodProceso
           FROM TRANSACCION T, SUB_PROCESO S
          WHERE S.CodSubProceso = Z.CodSubProceso
            AND S.IdProceso     = T.IdProceso
            AND T.IdTransaccion = nIdTransaccion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR (-20100,'No de Transacción '||nIdTransaccion||' NO Encuentra el SubProceso '||Z.CodSubProceso);
         WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR (-20100,'No de Transacción '||nIdTransaccion||' Posee Más de un Proceso');
      END;

      IF dFecComprob IS NULL THEN
         dFecComprob := dFechaTransaccion;
         dFecSts     := dFechaTransaccion;
      END IF;

      IF OC_SUB_PROCESO.GENERA_CONTABILIDAD(nIdProceso, Z.CodSubProceso) = 'S' THEN
         -- Lee el Tipo de Comprobante a Crear
         IF NVL(nNumComprobRecont,0) = 0 THEN
            cTipoComprob      := OC_PROCESOS_CONTABLES.TIPO_COMPROBANTE(nCodCia, cCodProceso, cTipoComp);
            cTipoDiario       := OC_PROCESOS_CONTABLES.TIPO_DIARIO(nCodCia, cCodProceso);
            nNumComprobRecont := CREA_COMPROBANTE(nCodCia, cTipoComprob, nIdTransaccion, cTipoDiario, cCodMoneda);
            UPDATE COMPROBANTES_CONTABLES
               SET NumComprob = nNumComprob,
                   FecComprob = dFecComprob,
                   CodMoneda  = cCodMoneda,
                   FecSts     = dFecSts
             WHERE NumComprob = nNumComprobRecont;
         END IF;

         -- Descripcin del Movimiento Contable
         cDescProceso    := OC_PROC_TAREA.NOMBRE_PROCESO(nIdProceso);
         cDescSubProceso := OC_SUB_PROCESO.NOMBRE_SUBPROCESO(nIdProceso, Z.CodSubProceso);
         cDescMovGeneral := 'Contabilización de ' || cDescProceso || ' para SubProceso ' || cDescSubProceso ||
                            ' de la Transacción No. ' || TRIM(TO_CHAR(nIdTransaccion)) || ' del ' ||
                            TO_CHAR(dFechaTransaccion,'DD/MM/YYYY');

         FOR W IN MOV_Q LOOP
            nTasaCambio    := OC_GENERALES.TASA_DE_CAMBIO(W.CodMoneda, TRUNC(dFechaTransaccion));
            nCodEmpresa    := W.CodEmpresa;
            cIdTipoSeg     := W.IdTipoSeg;
            cCodCpto       := W.CodCpto;
            IF W.CodMoneda IS NOT NULL AND cCodMoneda IS NULL THEN
               cCodMoneda     := W.CodMoneda;
            END IF;

            -- Actualiza Facturas por Tipo de Contabilidad Anticipada o Devengada
            IF W.DescripMov = 'FACTURAS CONTABILIZADAS' THEN
               OC_FACTURAS.ACTUALIZA_CONTABILIZACION(nCodCia, nIdTransaccion);
            END IF;

            FOR X IN PLANT_Q LOOP
               IF X.TipoRegistro = 'MO' THEN
                  IF X.TipoAgente IS NULL THEN
                     nMtoMovCuenta := ABS(W.MtoMovCuenta);
                  ELSIF OC_COMPROBANTES_CONTABLES.APLICA_TIPO_AGENTE(nCodCia, nIdTransaccion, cIdTipoSeg, X.TipoAgente) = 'S' THEN
                     nMtoMovCuenta := ABS(W.MtoMovCuenta);
                  ELSE
                     nMtoMovCuenta := 0;
                  END IF;
               ELSE
                  IF ABS(W.MtoComisCuenta) != 0 THEN
                     nMtoMovCuenta := ABS(OC_COMPROBANTES_CONTABLES.COMISION_TIPO_PERSONA(nCodCia, nIdTransaccion, cIdTipoSeg,
                                                                                          X.TipoPersona, X.TipoAgente));
                  ELSE
                     nMtoMovCuenta := 0;
                  END IF;
               END IF;
               IF X.CanalComisVenta IS NOT NULL THEN
                  IF OC_COMPROBANTES_CONTABLES.APLICA_CANAL_VENTA(nCodCia, nIdTransaccion, cIdTipoSeg, X.CanalComisVenta) = 'N' THEN
                     nMtoMovCuenta := 0;
                  END IF;
               END IF;
               IF NVL(nMtoMovCuenta,0) != 0 THEN
                  IF W.DescripMov IS NULL OR W.DescripMov = 'FACTURAS CONTABILIZADAS' THEN
                     cDescConcepto := OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, cCodCpto);
                     IF cDescConcepto = 'CONCEPTO NO EXISTE' THEN
                        cDescConcepto    := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('RVACONTA', cCodCpto);
                        IF cDescConcepto = 'NO EXISTE' THEN
                           cDescConcepto := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CPTOSINI', cCodCpto);
                        END IF;
                     END IF;
                     cDescMovCuenta := cDescMovGeneral || ' por el Concepto de ' || TRIM(cCodCpto) || '-' ||
                                       TRIM(cDescConcepto) || ' y un Monto de ' ||
                                       TRIM(TO_CHAR(nMtoMovCuenta,'999,999,999,990.00') || ' y Concepto MIZAR ' ||
                                       X.DescCptoGeneral);
                  ELSE
                     cDescMovCuenta := W.DescripMov;
                  END IF;
                  nMtoMovCuentaLocal := nMtoMovCuenta * nTasaCambio;

                  OC_COMPROBANTES_DETALLE.INSERTA_DETALLE(nCodCia, nNumComprob, X.NivelCta1, X.NivelCta2,
                                                          X.NivelCta3, X.NivelCta4, X.NivelCta5,
                                                          X.NivelCta6, X.NivelCta7, X.NivelAux, X.RegDebCred,
                                                          nMtoMovCuenta, cDescMovCuenta, X.CodCentroCosto,
                                                          X.CodUnidadNegocio, X.DescCptoGeneral, nMtoMovCuentaLocal);

               END IF;
            END LOOP;
         END LOOP;
         OC_COMPROBANTES_CONTABLES.ACTUALIZA_MONEDA(nCodCia, nNumComprob, NVL(cCodMoneda,cCodMonedaCia));
         OC_COMPROBANTES_DETALLE.ACTUALIZA_FECHA(nCodCia, nNumComprob, dFecComprob);
         OC_COMPROBANTES_CONTABLES.CUADRA_COMPROBANTE(nCodCia, nNumComprob);
      END IF;
   END LOOP;
END RECONTABILIZAR;

PROCEDURE TRASLADO(nCodCia NUMBER, dFecDesde DATE, dFecHasta DATE,  nNumComprobSC NUMBER,
                   dFecRegistro DATE, cCodUser VARCHAR2, cConcepto VARCHAR2, nDiario NUMBER,
                   cTipoComprob VARCHAR2, cTipoDiario VARCHAR2, cCodMoneda VARCHAR2,
                   cTipoTraslado VARCHAR2, nLinea IN OUT NUMBER) IS

cIdCtaContable     CATALOGO_CONTABLE.IdCtaContable%TYPE;
cCuenta            VARCHAR2(40);
cConceptoCta       VARCHAR2(1000);
cCadena            VARCHAR2(4000);
cSeparador         VARCHAR2(1) := '|';
cCodMonedaCia      EMPRESAS.Cod_Moneda%TYPE;
cCodMonedaMizar    VARCHAR2(1);
nTipoCambio        NUMBER(8,4);
nNumAsiento        NUMBER(10) := 0;

CURSOR COMP_Q IS
   SELECT NumComprob, CodMoneda
     FROM COMPROBANTES_CONTABLES
    WHERE CodCia             = nCodCia
      AND TipoComprob        = cTipoComprob
      AND ((TipoDiario       = cTipoDiario AND cTipoDiario IS NOT NULL)
       OR cTipoDiario IS NULL)
      AND StsComprob         = 'CUA'
      AND TRUNC(FecComprob) >= dFecDesde
      AND TRUNC(FecComprob) <= dFecHasta
      AND CodMoneda          = cCodMoneda
      AND NumComprobSC      IS NULL;

CURSOR DET_Q IS
   SELECT CD.NivelCta1, CD.NivelCta2, CD.NivelCta3, CD.NivelCta4,
          CD.NivelCta5, CD.NivelCta6, CD.NivelCta7, CD.NivelAux, CD.MovDebCred,
          CD.CodCentroCosto, CD.CodUnidadNegocio, CD.DescCptoGeneral, CC.CodMoneda,
          SUM(DECODE(CD.MovDebCred,'D',CD.MtoMovCuenta, 0)) TotDebitos,
          SUM(DECODE(CD.MovDebCred,'C',CD.MtoMovCuenta, 0)) TotCreditos,
          SUM(DECODE(CD.MovDebCred,'D',CD.MtoMovCuentaLocal, 0)) TotDebitosLocal,
          SUM(DECODE(CD.MovDebCred,'C',CD.MtoMovCuentaLocal, 0)) TotCreditosLocal
     FROM COMPROBANTES_DETALLE CD, COMPROBANTES_CONTABLES CC
    WHERE CD.CodCia             = CC.CodCia
      AND CD.NumComprob         = CC.NumComprob
      AND CC.CodCia             = nCodCia
      AND CC.TipoComprob        = cTipoComprob
      AND ((CC.TipoDiario       = cTipoDiario AND cTipoDiario IS NOT NULL)
       OR cTipoDiario IS NULL)
      AND CC.StsComprob         = 'CUA'
      AND TRUNC(CC.FecComprob) >= dFecDesde
      AND TRUNC(CC.FecComprob) <= dFecHasta
      AND CodMoneda             = cCodMoneda
      AND CC.NumComprobSC      IS NULL
    GROUP BY CD.NivelCta1, CD.NivelCta2, CD.NivelCta3, CD.NivelCta4,
          CD.NivelCta5, CD.NivelCta6, CD.NivelCta7, CD.NivelAux, CD.MovDebCred,
          CD.CodCentroCosto, CD.CodUnidadNegocio, CD.DescCptoGeneral, CC.CodMoneda;
BEGIN
   cCodMonedaCia   := OC_EMPRESAS.MONEDA_COMPANIA(nCodCia);
   nTipoCambio     := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, dFecHasta);
   FOR X IN DET_Q LOOP
      nNumAsiento    := NVL(nNumAsiento,0) + 1;
      cIdCtaContable := LPAD(TRIM(TO_CHAR(nCodCia)),14,'0') || X.NivelCta1 || X.NivelCta2 ||
                        X.NivelCta3 || X.NivelCta4 || X.NivelCta5 || X.NivelCta6 || X.NivelCta7 ||
                        X.NivelAux;

      cCuenta         := OC_CATALOGO_CONTABLE.FORMATO_CUENTA(cIdCtaContable);

      cCodMonedaMizar := OC_MONEDA.CODIGO_SISTEMA_CONTABLE(X.CodMoneda);

      cCadena := '5'                                       || CHR(9) ||   -- Compañía MIZAR
                 SUBSTR(cTipoDiario,1,4)                   || CHR(9) ||   -- Tipo Tran
                 TRIM(TO_CHAR(nDiario,'0'))                || CHR(9) ||   -- Póliza
                 TRIM(TO_CHAR(nNumAsiento))                || CHR(9) ||   -- No. de Asiento
                 RPAD(NVL(cConcepto,' '),100,' ')          || CHR(9) ||   -- Concepto de Póliza
                 TO_CHAR(dFecRegistro,'DD/MM/YYYY')        || CHR(9) ||   -- Fecha
                 RPAD(cCuenta,60,' ')                      || CHR(9) ||   -- Cuenta Contable
                 RPAD(NVL(X.CodCentroCosto,' '),40,' ')    || CHR(9) ||   -- Centro de Costo
                 RPAD(NVL(X.CodUnidadNegocio,' '),40,' ')  || CHR(9) ||   -- UEN
                 LPAD(X.NivelAux,6,'0')                    || CHR(9) ||   -- Auxiliar
                 '*'                                       || CHR(9) ||   -- Proyecto
                 'ME'                                      || CHR(9) ||   -- Libro
                 cCodMonedaMizar                           || CHR(9);     -- Moneda

      IF X.MovDebCred = 'D'  THEN
         cCadena := cCadena || TO_CHAR(X.TotDebitos,'0000000000.00')   || CHR(9) ||
                    TO_CHAR(X.TotDebitosLocal,'0000000000.00')         || CHR(9) ||
                    '1'                                                || CHR(9); -- Cargos
      ELSE
         cCadena := cCadena || TO_CHAR(X.TotCreditos,'0000000000.00') || CHR(9) ||
                    TO_CHAR(X.TotCreditosLocal,'0000000000.00')       || CHR(9) ||
                    '0'                                               || CHR(9); -- Créditos
      END IF;

      cCadena := cCadena || '0'                           || CHR(9) || -- Unidades
                 TO_CHAR(nTipoCambio,'000.0000')          || CHR(9) || -- Tipo de Cambio
                 RPAD(NVL(X.DescCptoGeneral,' '),64,' ')  || CHR(9) || -- Concepto Individual
                 RPAD('_',12,' ')                         || CHR(9) || -- Cheque
                 RPAD('_',12,' ')                         || CHR(9);   -- Referencia
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea  := NVL(nLinea,0) + 1;
   END LOOP;
   IF cTipoTraslado = 'SCD' THEN -- Solo para Traslado Definitivo
      FOR X IN COMP_Q LOOP
         UPDATE COMPROBANTES_CONTABLES
            SET NumComprobSC = nNumComprobSC,
                FecEnvioSC   = dFecRegistro
          WHERE CodCia       = nCodCia
            AND NumComprob   = X.NumComprob;
      END LOOP;
   END IF;
END TRASLADO;

PROCEDURE ELIMINA_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER) IS
BEGIN

    DELETE COMPROBANTES_CONTABLES
     WHERE CodCia     = nCodCia
       AND NumComprob = nNumComprob;

END ELIMINA_COMPROBANTE;

PROCEDURE TRASLADO_SUN(nCodCia NUMBER, dFecDesde DATE, dFecHasta DATE, nNumComprobSun NUMBER,
                       dFecRegistro DATE, cCodUser VARCHAR2, cTipoComprob VARCHAR2,
                       cEncabezado VARCHAR2, nLinea  IN OUT NUMBER) IS
cCuenta        VARCHAR2(16);
cCadena        VARCHAR2(4000);
cSeparador     VARCHAR2(1) := '|';
cPeriodo       VARCHAR2(8) := TRIM(TO_CHAR(dFecRegistro,'YYYY')) || '/' || TRIM(LPAD(TO_CHAR(dFecRegistro,'MM'),3,'0'));
cCentroCostos  VARCHAR2(5);
cRamo          VARCHAR2(3);

CURSOR COMP_Q IS
   SELECT NumComprob
     FROM COMPROBANTES_CONTABLES
    WHERE CodCia             = nCodCia
      AND TipoComprob        = cTipoComprob
      AND StsComprob         = 'CUA'
      AND TRUNC(FecComprob) >= dFecDesde
      AND TRUNC(FecComprob) <= dFecHasta
      AND NumComprobSun     IS NULL;

CURSOR DET_Q IS
   SELECT 'MXP' Moneda, P.TipoDiario, SUBSTR(P.NomProceso,1,30) Referencia,
          SUBSTR(S.Descripcion,1,50) Descripcion,
          CD.NivelCta1, CD.NivelCta2, CD.NivelCta3, CD.NivelCta4,
          CD.NivelCta5, CD.MovDebCred, TRUNC(CD.FecDetalle) FecDetalle,
          SUM(DECODE(CD.MovDebCred,'D', CD.MtoMovCuenta, -CD.MtoMovCuenta)) TotImporte
     FROM COMPROBANTES_DETALLE CD, DETALLE_TRANSACCION D, TRANSACCION T,
          COMPROBANTES_CONTABLES C,  PROCESOS_CONTABLES P, SUB_PROCESO S
    WHERE P.CodCia             = C.CodCia
      AND S.CodProcesoCont     = P.CodProceso
      AND S.IndGenContabilidad = 'S'
      AND S.CodSubProceso      = D.CodSubProceso
      AND S.IdProceso          = T.IdProceso
      AND T.IdTransaccion      = C.NumTransaccion
      AND T.CodCia             = C.CodCia
      AND D.IdTransaccion      = T.IdTransaccion
      AND CD.CodCia            = C.CodCia
      AND CD.NumComprob        = C.NumComprob
      AND C.CodCia             = nCodCia
      AND C.TipoComprob        = cTipoComprob
      AND C.StsComprob         = 'CUA'
      AND TRUNC(C.FecComprob) >= dFecDesde
      AND TRUNC(C.FecComprob) <= dFecHasta
      AND C.NumComprobSun     IS NULL
    GROUP BY 'MXP', P.TipoDiario, SUBSTR(P.NomProceso,1,30),
             SUBSTR(S.Descripcion,1,50), CD.NivelCta1, CD.NivelCta2,
             CD.NivelCta3, CD.NivelCta4, CD.NivelCta5, CD.MovDebCred, TRUNC(CD.FecDetalle);
BEGIN
   IF cEncabezado = 'S' THEN
      -- Escribe Encabezado de Archivo Excel
      nLinea   := 1;
      cCadena  := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                       ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                       ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                       ' <style id="libro">'||chr(10)||
                       '   <!--table'||chr(10)||
                       '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                       '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                       '        .texto'||chr(10)||
                       '          {mso-number-format:"\@";}'||chr(10)||
                       '        .numero'||chr(10)||
                       '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                       '        .fecha'||chr(10)||
                       '          {mso-number-format:"dd\\-mm\\-yyyy";}'||chr(10)||
                       '    -->'||chr(10)||
                       ' </style><div id="libro">'||chr(10);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea   := 2;
      cCadena := '<table border = 1><tr><th>ALC</th><th>A</th></tr>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea   := 3;
      cCadena := '<tr><th>1</th><th>2</th><th>3</th><th>4</th><th>5</th><th>6</th><th>7</th><th>'||
                 '8</th><th>8</th><th>10</th><th>11</th><th>12</th><th>13</th><th>14</th><th>15</th>'||
                 '<th>16</th><th>17</th><th>18</th><th>19</th><th>20</th><th>21</th><th>22</th><th>23</th><th>24</th>'||
                 '<th>25</th></tr>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea   := 4;
      cCadena := '<table border = 1><tr><th>Cuenta</th><th>Periodo</th><th>Importe</th>'||
                 '<th>Moneda</th><th>Ope</th><th>Fecha</th><th>Tipo de Diario</th><th>'||
                 'Referencia</th><th>Descripcin</th><th>Vencimiento</th><th>Activo</th>'||
                 '<th>Sub</th><th>Marcador</th><th>Asignacin</th><th>T1 CCO</th>'||
                 '<th>T2 EDO</th><th>T3 AGE</th><th>T4 RAMO</th><th>T5 REF</th>'||
                 '<th>T6 RFC</th><th>T7 IMP</th><th>T8 PYR</th><th>T9</th><th>T10</th>'||
                 '<th>LAYOUT</th></tr>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END IF;
   FOR X IN DET_Q LOOP
      nLinea  := NVL(nLinea,0) + 1;
      cCuenta := X.NivelCta1 || X.NivelCta2 || X.NivelCta3 || X.NivelCta4 || X.NivelCta5;
      IF X.NivelCta1 IN (5, 6) THEN
         cCentroCostos := '300';
         cRamo         := '333';
       ELSE
         cCentroCostos := ' ';
         cRamo         := X.NivelCta5;
      END IF;
      cCadena := '<tr>' ||OC_ARCHIVO.CAMPO_HTML(cCuenta,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(cPeriodo,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.TotImporte,'999,999,999,999,990.00'),'N') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Moneda,'C') ||
                 OC_ARCHIVO.CAMPO_HTML('AOM','C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.FecDetalle,'D') ||
                 OC_ARCHIVO.CAMPO_HTML(X.TipoDiario,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Referencia,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(X.Descripcion,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(cCentroCostos,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(cRamo,'C') ||
                 OC_ARCHIVO.CAMPO_HTML(TRIM(TO_CHAR(nNumComprobSun,'000000')),'C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML(' ','C') ||
                 OC_ARCHIVO.CAMPO_HTML('1;2','C') || '</tr>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
   FOR X IN COMP_Q LOOP
      UPDATE COMPROBANTES_CONTABLES
         SET NumComprobSun = nNumComprobSun,
             FecEnvioSun   = dFecRegistro
       WHERE CodCia      = nCodCia
         AND NumComprob  = X.NumComprob;
   END LOOP;
END TRASLADO_SUN;

PROCEDURE RECONTABILIZAR_MASIVO (cTipoComprob VARCHAR2,dFecIni DATE, dFecFin DATE) IS

CURSOR C_COMPRO IS
  SELECT NumComprob, TipoComprob, FecSts, CodCia, NumTransaccion
    FROM COMPROBANTES_CONTABLES
   WHERE TipoComprob   = cTipoComprob
     AND TRUNC(FecSts) BETWEEN dFecIni AND dFecFin
     AND NumComprobSC  IS NULL
   ORDER BY TipoComprob;
BEGIN
   FOR I IN  C_COMPRO LOOP
      UPDATE COMPROBANTES_CONTABLES
         SET StsComprob = 'DES'
       WHERE NumComprob = I.NumComprob;

       OC_COMPROBANTES_DETALLE.ELIMINA_DETALLE(I.CodCia, I.NumComprob);
       OC_COMPROBANTES_CONTABLES.ELIMINA_COMPROBANTE(I.CodCia, I.NumComprob);
       OC_COMPROBANTES_CONTABLES.RECONTABILIZAR(I.CodCia, I.NumTransaccion, 'C', I.NumComprob);
       OC_COMPROBANTES_CONTABLES.CUADRA_COMPROBANTE(I.CodCia, I.NumComprob);

       UPDATE COMPROBANTES_CONTABLES
          SET FecSts       = I.FecSts,
              FecComprob   = I.FecSts
        WHERE NumComprob   = I.NumComprob;
   END LOOP;
END RECONTABILIZAR_MASIVO;

FUNCTION COMISION_TIPO_PERSONA(nCodCia NUMBER, nIdTransaccion NUMBER, cIdTipoSeg VARCHAR2,
                               cTipoPersona VARCHAR2, cTipoAgente VARCHAR2) RETURN NUMBER IS
nComision_Moneda      COMISIONES.Comision_Moneda%TYPE;
BEGIN
   SELECT NVL(SUM(Comision_Moneda),0)
     INTO nComision_Moneda
     FROM COMISIONES C, FACTURAS F, DETALLE_TRANSACCION D,
          TRANSACCION T, DETALLE_POLIZA DP, AGENTES A,
          PERSONA_NATURAL_JURIDICA PNJ
    WHERE PNJ.Tipo_Persona            = cTipoPersona
      AND PNJ.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
      AND PNJ.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
      AND A.CodTipo                   = cTipoAgente
      AND A.Cod_Agente                = C.Cod_Agente
      AND A.CodCia                    = C.CodCia
      AND C.IdFactura                 = F.IdFactura
      AND DP.IdTipoSeg                = cIdTipoSeg
      AND DP.IdPoliza                 = F.IdPoliza
      AND DP.IDetPol                  = NVL(F.IDetPol, DP.IDetPol)
      AND DP.CodCia                   = D.CodCia
      AND (F.IdTransaccion            = D.IdTransaccion
       OR (F.IdTransaccionAnu         = D.IdTransaccion
       OR  F.IdTransacContab          = D.IdTransaccion
      AND  F.IndContabilizada         = 'S'))
      AND T.IdTransaccion             = D.IdTransaccion
      AND ((TRUNC(F.FecVenc)         <= TRUNC(T.FechaTransaccion)
      AND   OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'DEVENG')
       OR OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'ANTICI')
      AND D.Correlativo               = 1
      AND D.IdTransaccion             = nIdTransaccion
      AND D.CodCia                    = nCodCia;

   SELECT NVL(nComision_Moneda,0) + NVL(SUM(C.Comision_Moneda),0)
     INTO nComision_Moneda
     FROM COMISIONES C, NOTAS_DE_CREDITO N, DETALLE_TRANSACCION D,
          DETALLE_POLIZA DP, AGENTES A, PERSONA_NATURAL_JURIDICA PNJ
    WHERE PNJ.Tipo_Persona            = cTipoPersona
      AND PNJ.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
      AND PNJ.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
      AND A.CodTipo                   = cTipoAgente
      AND A.Cod_Agente                = C.Cod_Agente
      AND A.CodCia                    = C.CodCia
      AND C.IdNcr                     = N.IdNcr
      AND DP.IdTipoSeg                = cIdTipoSeg
      AND DP.IdPoliza                 = N.IdPoliza
      AND DP.IDetPol                  = NVL(N.IDetPol, DP.IDetPol)
      AND DP.CodCia                   = D.CodCia
      AND (N.IdTransaccion            = D.IdTransaccion
       OR  N.IdTransaccionAnu         = D.IdTransaccion
       OR  N.IdTransacAplic           = D.IdTransaccion
       OR  N.IdTransacRevAplic        = D.IdTransaccion)
      AND D.Correlativo               = 1
      AND D.IdTransaccion             = nIdTransaccion
      AND D.CodCia                    = nCodCia;

   SELECT NVL(nComision_Moneda,0) + NVL(SUM(N.MtoComisi_Moneda),0)
     INTO nComision_Moneda
     FROM NOTAS_DE_CREDITO N, DETALLE_TRANSACCION D, AGENTES A,
          PERSONA_NATURAL_JURIDICA PNJ
    WHERE PNJ.Tipo_Persona            = cTipoPersona
      AND PNJ.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
      AND PNJ.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
      AND A.CodTipo                   = cTipoAgente
      AND A.Cod_Agente                = N.Cod_Agente
      AND A.CodCia                    = D.CodCia
      AND N.IdTransaccion             = D.IdTransaccion
      AND N.IdPoliza                 IS NULL
      AND D.Correlativo               = 1
      AND D.IdTransaccion             = nIdTransaccion
      AND D.CodCia                    = nCodCia;

   SELECT NVL(nComision_Moneda,0) + NVL(SUM(Comision_Moneda),0)
     INTO nComision_Moneda
     FROM COMISIONES C, FACTURAS F, PAGOS P,
          DETALLE_TRANSACCION D, DETALLE_POLIZA DP, AGENTES A,
          PERSONA_NATURAL_JURIDICA PNJ
    WHERE PNJ.Tipo_Persona            = cTipoPersona
      AND PNJ.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
      AND PNJ.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
      AND A.CodTipo                   = cTipoAgente
      AND A.Cod_Agente                = C.Cod_Agente
      AND A.CodCia                    = C.CodCia
      AND C.IdFactura                 = F.IdFactura
      AND DP.IdTipoSeg                = cIdTipoSeg
      AND DP.IdPoliza                 = F.IdPoliza
      AND DP.IDetPol                  = NVL(F.IDetPol, DP.IDetPol)
      AND DP.CodCia                   = D.CodCia
      AND F.IdFactura                 = P.IdFactura
      AND (P.IdTransaccion    = D.IdTransaccion
       OR  P.IdTransaccionAnu = D.IdTransaccion)
      AND D.Correlativo               = 1
      AND D.IdTransaccion             = nIdTransaccion
      AND D.CodCia                    = nCodCia;

   SELECT NVL(nComision_Moneda,0) + NVL(SUM(Comision_Moneda),0)
     INTO nComision_Moneda
     FROM COMISIONES C, AGENTES A, DETALLE_TRANSACCION D, PERSONA_NATURAL_JURIDICA PNJ,
          FAI_CONCENTRADORA_FONDO CF, FACTURAS F, DETALLE_POLIZA  DP
    WHERE PNJ.Tipo_Persona            = cTipoPersona
      AND PNJ.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
      AND PNJ.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
      AND A.CodTipo                   = cTipoAgente
      AND A.Cod_Agente                = C.Cod_Agente
      AND A.CodCia                    = C.CodCia
      AND C.IdFactura                 = F.IdFactura
      AND DP.IdPoliza                 = CF.IdPoliza
      AND DP.IDetPol                  = CF.IDetPol
      AND DP.CodCia                   = CF.CodCia
      AND CF.IdFondo                  > 0
      AND CF.CodAsegurado             > 0
      AND CF.IDetPol                  > 0
      AND CF.IdPoliza                 > 0
      AND CF.IdFactura                = F.IdFactura
      AND (CF.IdTransaccion           = D.IdTransaccion 
       OR CF.IdTransaccionAnu         = D.IdTransaccion)
      AND CF.CodEmpresa               = D.CodEmpresa
      AND CF.CodCia                   = D.CodCia
      AND GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(CF.CodCia, CF.CodEmpresa, 
                                                GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(CF.IdFondo), 
                                                CF.CodCptoMov, 'GC') = 'S'
      AND GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(CF.CodCia, CF.CodEmpresa, 
                                                GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(CF.IdFondo), 
                                                CF.CodCptoMov, 'CO') = 'S'                                                
      AND D.Correlativo               = 1
      AND D.IdTransaccion             = nIdTransaccion
      AND D.CodCia                    = nCodCia;

   RETURN(nComision_Moneda);
END COMISION_TIPO_PERSONA;

FUNCTION APLICA_CANAL_VENTA(nCodCia NUMBER, nIdTransaccion NUMBER,
                            cIdTipoSeg VARCHAR2, cCanalComisVenta VARCHAR2) RETURN VARCHAR2 IS
cCanalComis     VARCHAR2(1);
--
BEGIN
  --
   BEGIN
      SELECT 'S'
        INTO cCanalComis
        FROM AGENTES_DISTRIBUCION_COMISION AG, FACTURAS F,
             DETALLE_TRANSACCION D, TRANSACCION T, DETALLE_POLIZA DP, AGENTES A
       WHERE A.CanalComisVenta    = cCanalComisVenta
         AND A.Cod_Agente         = AG.Cod_Agente_Distr
         AND A.CodEmpresa         = DP.CodEmpresa
         AND A.CodCia             = AG.CodCia
         AND AG.IDetPol           = DP.IDetPol
         AND AG.IdPoliza          = DP.IdPoliza
         AND AG.CodCia            = DP.CodCia
         AND DP.IdTipoSeg         = cIdTipoSeg
         AND DP.IdPoliza          = F.IdPoliza
         AND DP.IDetPol           = NVL(F.IDetPol, DP.IDetPol)
         AND DP.CodCia            = D.CodCia
         AND T.IdTransaccion      = D.IdTransaccion
         AND ((TRUNC(F.FecVenc)  <= TRUNC(T.FechaTransaccion)
         AND   OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'DEVENG')
          OR OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'ANTICI')
         AND F.IdFactura          > 0
         AND (F.IdTransaccion     = D.IdTransaccion
          OR (F.IdTransaccionAnu  = D.IdTransaccion
         AND  F.IndContabilizada  = 'S')
          OR  F.IdTransacContab   = D.IdTransaccion)
         AND D.Correlativo        = 1
         AND D.IdTransaccion      = nIdTransaccion
         AND D.CodCia             = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCanalComis := 'N';
      WHEN TOO_MANY_ROWS THEN
         cCanalComis := 'S';
   END;

   IF cCanalComis = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cCanalComis
           FROM NOTAS_DE_CREDITO N, DETALLE_TRANSACCION D,
                AGENTES_DISTRIBUCION_COMISION AG, DETALLE_POLIZA DP, AGENTES A
          WHERE A.CanalComisVenta   = cCanalComisVenta
            AND A.Cod_Agente        = AG.Cod_Agente_Distr
            AND A.CodCia            = AG.CodCia
            AND AG.IDetPol          = DP.IDetPol
            AND AG.IdPoliza         = DP.IdPoliza
            AND AG.CodCia           = DP.CodCia
            AND DP.IdTipoSeg        = cIdTipoSeg
            AND DP.IdPoliza         = N.IdPoliza
            AND DP.IDetPol          = NVL(N.IDetPol, DP.IDetPol)
            AND DP.CodCia           = D.CodCia
            AND (N.IdTransaccion    = D.IdTransaccion
             OR  N.IdTransaccionAnu = D.IdTransaccion
             OR  N.IdTransacAplic   = D.IdTransaccion
             OR  N.IdTransacRevAplic = D.IdTransaccion)
            AND D.Correlativo       = 1
            AND D.IdTransaccion     = nIdTransaccion
            AND D.CodCia            = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCanalComis := 'N';
         WHEN TOO_MANY_ROWS THEN
            cCanalComis := 'S';
      END;
   END IF;

   IF cCanalComis = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cCanalComis
           FROM NOTAS_DE_CREDITO N, DETALLE_TRANSACCION D, AGENTES A
          WHERE A.CanalComisVenta   = cCanalComisVenta
            AND A.Cod_Agente        = N.Cod_Agente
            AND A.CodCia            = D.CodCia
            AND (N.IdTransaccion    = D.IdTransaccion
             OR  N.IdTransaccionAnu = D.IdTransaccion
             OR  N.IdTransacAplic   = D.IdTransaccion
             OR  N.IdTransacRevAplic = D.IdTransaccion)
            AND D.Correlativo       = 1
            AND D.IdTransaccion     = nIdTransaccion
            AND D.CodCia            = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCanalComis := 'N';
         WHEN TOO_MANY_ROWS THEN
            cCanalComis := 'S';
      END;
   END IF;

   IF cCanalComis = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cCanalComis
           FROM AGENTES_DISTRIBUCION_COMISION AG, FACTURAS F, PAGOS P,
                DETALLE_TRANSACCION D, DETALLE_POLIZA DP, AGENTES A
          WHERE A.CanalComisVenta   = cCanalComisVenta
            AND A.Cod_Agente        = AG.Cod_Agente_Distr
            AND A.CodCia            = AG.CodCia
            AND AG.IDetPol          = DP.IDetPol
            AND AG.IdPoliza         = DP.IdPoliza
            AND AG.CodCia           = DP.CodCia
            AND DP.IdTipoSeg        = cIdTipoSeg
            AND DP.IdPoliza         = F.IdPoliza
            AND DP.IDetPol          = NVL(F.IDetPol, DP.IDetPol)
            AND DP.CodCia           = D.CodCia
            AND F.IdFactura         = P.IdFactura
            AND (P.IdTransaccion    = D.IdTransaccion
             OR  P.IdTransaccionAnu = D.IdTransaccion)
            AND D.Correlativo       = 1
            AND D.IdTransaccion     = nIdTransaccion
            AND D.CodCia            = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCanalComis := 'N';
         WHEN TOO_MANY_ROWS THEN
            cCanalComis := 'S';
      END;
   END IF;

   IF cCanalComis = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cCanalComis
           FROM DETALLE_TRANSACCION DT, AGENTES_DISTRIBUCION_COMISION AG,
                SINIESTRO S, COBERTURA_SINIESTRO_ASEG C, AGENTES A
          WHERE A.CanalComisVenta  = cCanalComisVenta
            AND A.Cod_Agente       = AG.Cod_Agente_Distr
            AND A.CodCia           = AG.CodCia
            AND AG.IDetPol         = S.IDetPol
            AND AG.IdPoliza        = S.IdPoliza
            AND AG.CodCia          = S.CodCia
            AND S.IdSiniestro      = C.IdSiniestro
            AND S.IdPoliza         = C.IdPoliza
            AND S.CodCia           = nCodCia
            AND DT.Correlativo     = 1
            AND (C.IdTransaccion     = DT.IdTransaccion
             OR  C.IdTransaccionAnul = DT.IdTransaccion)
            AND DT.IdTransaccion   = nIdTransaccion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCanalComis := 'N';
         WHEN TOO_MANY_ROWS THEN
            cCanalComis := 'S';
      END;
   END IF;

   IF cCanalComis = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cCanalComis
           FROM DETALLE_TRANSACCION DT, AGENTES_DISTRIBUCION_COMISION AG,
                SINIESTRO S, COBERTURA_SINIESTRO C, AGENTES A
          WHERE A.CanalComisVenta  = cCanalComisVenta
            AND A.Cod_Agente       = AG.Cod_Agente_Distr
            AND A.CodCia           = AG.CodCia
            AND AG.IDetPol         = S.IDetPol
            AND AG.IdPoliza        = S.IdPoliza
            AND AG.CodCia          = S.CodCia
            AND S.IdSiniestro      = C.IdSiniestro
            AND S.IdPoliza         = C.IdPoliza
            AND S.CodCia           = nCodCia
            AND DT.Correlativo     = 1
            AND (C.IdTransaccion     = DT.IdTransaccion
             OR  C.IdTransaccionAnul = DT.IdTransaccion)
            AND DT.IdTransaccion   = nIdTransaccion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCanalComis := 'N';
         WHEN TOO_MANY_ROWS THEN
            cCanalComis := 'S';
      END;
   END IF;

   IF cCanalComis = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cCanalComis
           FROM DETALLE_TRANSACCION DT, AGENTES_DISTRIBUCION_COMISION AG,
                SINIESTRO S, APROBACIONES C, AGENTES A
          WHERE A.CanalComisVenta  = cCanalComisVenta
            AND A.Cod_Agente       = AG.Cod_Agente_Distr
            AND A.CodCia           = AG.CodCia
            AND AG.IDetPol         = S.IDetPol
            AND AG.IdPoliza        = S.IdPoliza
            AND AG.CodCia          = S.CodCia
            AND S.IdSiniestro      = C.IdSiniestro
            AND S.IdPoliza         = C.IdPoliza
            AND S.CodCia           = nCodCia
            AND DT.Correlativo     = 1
            AND (C.IdTransaccion     = DT.IdTransaccion
             OR  C.IdTransaccionAnul = DT.IdTransaccion)
            AND DT.IdTransaccion   = nIdTransaccion
          UNION
         SELECT 'S'
           FROM DETALLE_TRANSACCION DT, AGENTES_DISTRIBUCION_COMISION AG,
                SINIESTRO S, APROBACION_ASEG C, AGENTES A
          WHERE A.CanalComisVenta  = cCanalComisVenta
            AND A.Cod_Agente       = AG.Cod_Agente_Distr
            AND A.CodCia           = AG.CodCia
            AND AG.IDetPol         = S.IDetPol
            AND AG.IdPoliza        = S.IdPoliza
            AND AG.CodCia          = S.CodCia
            AND S.IdSiniestro      = C.IdSiniestro
            AND S.IdPoliza         = C.IdPoliza
            AND S.CodCia           = nCodCia
            AND DT.Correlativo     = 1
            AND (C.IdTransaccion     = DT.IdTransaccion
             OR  C.IdTransaccionAnul = DT.IdTransaccion)
            AND DT.IdTransaccion   = nIdTransaccion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCanalComis := 'N';
         WHEN TOO_MANY_ROWS THEN
            cCanalComis := 'S';
      END;
   END IF;

   IF cCanalComis = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cCanalComis
           FROM AGENTES_DISTRIBUCION_COMISION AG, AGENTES A, DETALLE_TRANSACCION D, 
                FAI_CONCENTRADORA_FONDO CF, FACTURAS F, DETALLE_POLIZA  DP
          WHERE A.CanalComisVenta   = cCanalComisVenta
            AND A.Cod_Agente        = AG.Cod_Agente_Distr
            AND A.CodEmpresa        = DP.CodEmpresa
            AND A.CodCia            = AG.CodCia
            AND AG.IDetPol          = DP.IDetPol
            AND AG.IdPoliza         = DP.IdPoliza
            AND AG.CodCia           = DP.CodCia
            AND DP.IdPoliza         = CF.IdPoliza
            AND DP.IDetPol          = CF.IDetPol
            AND DP.CodCia           = CF.CodCia
            AND CF.IdFondo          > 0
            AND CF.CodAsegurado     > 0
            AND CF.IDetPol          > 0
            AND CF.IdPoliza         > 0
            AND CF.IdFactura        = F.IdFactura
            AND (CF.IdTransaccion   = D.IdTransaccion 
             OR CF.IdTransaccionAnu = D.IdTransaccion)
            AND CF.CodEmpresa       = D.CodEmpresa
            AND CF.CodCia           = D.CodCia
            AND GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(CF.CodCia, CF.CodEmpresa, 
                                                      GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(CF.IdFondo), 
                                                      CF.CodCptoMov, 'GC') = 'S'
            AND D.Correlativo       = 1
            AND D.IdTransaccion     = nIdTransaccion
            AND D.CodCia            = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCanalComis := 'N';
         WHEN TOO_MANY_ROWS THEN
            cCanalComis := 'S';
      END;
   END IF;
   
   RETURN(cCanalComis);
END APLICA_CANAL_VENTA;

FUNCTION APLICA_TIPO_AGENTE(nCodCia NUMBER, nIdTransaccion NUMBER, cIdTipoSeg VARCHAR2,
                            cTipoAgente VARCHAR2) RETURN VARCHAR2 IS
cAplicaTipoAgen     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cAplicaTipoAgen
        FROM AGENTES_DISTRIBUCION_COMISION AG, FACTURAS F,
             DETALLE_TRANSACCION D, TRANSACCION T, DETALLE_POLIZA DP, AGENTES A
       WHERE A.CodTipo            = cTipoAgente
         AND A.Cod_Agente         = AG.Cod_Agente_Distr
         AND A.CodEmpresa         = DP.CodEmpresa
         AND A.CodCia             = AG.CodCia
         AND AG.IDetPol           = DP.IDetPol
         AND AG.IdPoliza          = DP.IdPoliza
         AND AG.CodCia            = DP.CodCia
         AND DP.IdTipoSeg         = cIdTipoSeg
         AND DP.IdPoliza          = F.IdPoliza
         AND DP.IDetPol           = NVL(F.IDetPol, DP.IDetPol)
         AND DP.CodCia            = D.CodCia
         AND T.IdTransaccion      = D.IdTransaccion
         AND ((TRUNC(F.FecVenc)  <= TRUNC(T.FechaTransaccion)
         AND   OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'DEVENG')
          OR OC_TIPOS_DE_SEGUROS.TIPO_CONTABILIDAD(nCodCia, D.CodEmpresa, DP.IdTipoSeg) = 'ANTICI')
         AND F.IdFactura          > 0
         AND (F.IdTransaccion     = D.IdTransaccion
          OR (F.IdTransaccionAnu  = D.IdTransaccion
         AND  F.IndContabilizada  = 'S')
          OR  F.IdTransacContab   = D.IdTransaccion)
         AND D.Correlativo        = 1
         AND D.IdTransaccion      = nIdTransaccion
         AND D.CodCia             = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cAplicaTipoAgen := 'N';
      WHEN TOO_MANY_ROWS THEN
         cAplicaTipoAgen := 'S';
   END;

   IF cAplicaTipoAgen = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cAplicaTipoAgen
           FROM NOTAS_DE_CREDITO N, DETALLE_TRANSACCION D,
                AGENTES_DISTRIBUCION_COMISION AG, DETALLE_POLIZA DP, AGENTES A
          WHERE A.CodTipo           = cTipoAgente
            AND A.Cod_Agente        = AG.Cod_Agente_Distr
            AND A.CodCia            = AG.CodCia
            AND AG.IDetPol          = DP.IDetPol
            AND AG.IdPoliza         = DP.IdPoliza
            AND AG.CodCia           = DP.CodCia
            AND DP.IdTipoSeg        = cIdTipoSeg
            AND DP.IdPoliza         = N.IdPoliza
            AND DP.IDetPol          = NVL(N.IDetPol, DP.IDetPol)
            AND DP.CodCia           = D.CodCia
            AND (N.IdTransaccion    = D.IdTransaccion
             OR  N.IdTransaccionAnu = D.IdTransaccion
             OR  N.IdTransacAplic   = D.IdTransaccion
             OR  N.IdTransacRevAplic = D.IdTransaccion)
            AND D.Correlativo       = 1
            AND D.IdTransaccion     = nIdTransaccion
            AND D.CodCia            = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cAplicaTipoAgen := 'N';
         WHEN TOO_MANY_ROWS THEN
            cAplicaTipoAgen := 'S';
      END;
   END IF;

   IF cAplicaTipoAgen = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cAplicaTipoAgen
           FROM NOTAS_DE_CREDITO N, DETALLE_TRANSACCION D, AGENTES A
          WHERE A.CodTipo           = cTipoAgente
            AND A.Cod_Agente        = N.Cod_Agente
            AND A.CodCia            = D.CodCia
            AND (N.IdTransaccion    = D.IdTransaccion
             OR  N.IdTransaccionAnu = D.IdTransaccion
             OR  N.IdTransacAplic   = D.IdTransaccion
             OR  N.IdTransacRevAplic = D.IdTransaccion)
            AND D.Correlativo       = 1
            AND D.IdTransaccion     = nIdTransaccion
            AND D.CodCia            = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cAplicaTipoAgen := 'N';
         WHEN TOO_MANY_ROWS THEN
            cAplicaTipoAgen := 'S';
      END;
   END IF;

   IF cAplicaTipoAgen = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cAplicaTipoAgen
           FROM AGENTES_DISTRIBUCION_COMISION AG, FACTURAS F, PAGOS P,
                DETALLE_TRANSACCION D, DETALLE_POLIZA DP, AGENTES A
          WHERE A.CodTipo           = cTipoAgente
            AND A.Cod_Agente        = AG.Cod_Agente_Distr
            AND A.CodCia            = AG.CodCia
            AND AG.IDetPol          = DP.IDetPol
            AND AG.IdPoliza         = DP.IdPoliza
            AND AG.CodCia           = DP.CodCia
            AND DP.IdTipoSeg        = cIdTipoSeg
            AND DP.IdPoliza         = F.IdPoliza
            AND DP.IDetPol          = NVL(F.IDetPol, DP.IDetPol)
            AND DP.CodCia           = D.CodCia
            AND F.IdFactura         = P.IdFactura
            AND (P.IdTransaccion    = D.IdTransaccion
             OR  P.IdTransaccionAnu = D.IdTransaccion)
            AND D.Correlativo       = 1
            AND D.IdTransaccion     = nIdTransaccion
            AND D.CodCia            = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cAplicaTipoAgen := 'N';
         WHEN TOO_MANY_ROWS THEN
            cAplicaTipoAgen := 'S';
      END;
   END IF;

   IF cAplicaTipoAgen = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cAplicaTipoAgen
           FROM DETALLE_TRANSACCION DT, AGENTES_DISTRIBUCION_COMISION AG,
                SINIESTRO S, COBERTURA_SINIESTRO C, AGENTES A
          WHERE A.CodTipo          = cTipoAgente
            AND A.Cod_Agente       = AG.Cod_Agente_Distr
            AND A.CodCia           = AG.CodCia
            AND AG.IDetPol         = S.IDetPol
            AND AG.IdPoliza        = S.IdPoliza
            AND AG.CodCia          = S.CodCia
            AND S.IdSiniestro      = C.IdSiniestro
            AND S.IdPoliza         = C.IdPoliza
            AND S.CodCia           = nCodCia
            AND DT.Correlativo     = 1
            AND (C.IdTransaccion     = DT.IdTransaccion
             OR  C.IdTransaccionAnul = DT.IdTransaccion)
            AND DT.IdTransaccion   = nIdTransaccion
          UNION
         SELECT 'S'
           FROM DETALLE_TRANSACCION DT, AGENTES_DISTRIBUCION_COMISION AG,
                SINIESTRO S, COBERTURA_SINIESTRO_ASEG C, AGENTES A
          WHERE A.CodTipo          = cTipoAgente
            AND A.Cod_Agente       = AG.Cod_Agente_Distr
            AND A.CodCia           = AG.CodCia
            AND AG.IDetPol         = S.IDetPol
            AND AG.IdPoliza        = S.IdPoliza
            AND AG.CodCia          = S.CodCia
            AND S.IdSiniestro      = C.IdSiniestro
            AND S.IdPoliza         = C.IdPoliza
            AND S.CodCia           = nCodCia
            AND DT.Correlativo     = 1
            AND (C.IdTransaccion     = DT.IdTransaccion
             OR  C.IdTransaccionAnul = DT.IdTransaccion)
            AND DT.IdTransaccion   = nIdTransaccion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cAplicaTipoAgen := 'N';
         WHEN TOO_MANY_ROWS THEN
            cAplicaTipoAgen := 'S';
      END;
   END IF;

   IF cAplicaTipoAgen = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cAplicaTipoAgen
           FROM DETALLE_TRANSACCION DT, AGENTES_DISTRIBUCION_COMISION AG,
                SINIESTRO S, APROBACIONES C, AGENTES A
          WHERE A.CodTipo          = cTipoAgente
            AND A.Cod_Agente       = AG.Cod_Agente_Distr
            AND A.CodCia           = AG.CodCia
            AND AG.IDetPol         = S.IDetPol
            AND AG.IdPoliza        = S.IdPoliza
            AND AG.CodCia          = S.CodCia
            AND S.IdSiniestro      = C.IdSiniestro
            AND S.IdPoliza         = C.IdPoliza
            AND S.CodCia           = nCodCia
            AND DT.Correlativo     = 1
            AND (C.IdTransaccion     = DT.IdTransaccion
             OR  C.IdTransaccionAnul = DT.IdTransaccion)
            AND DT.IdTransaccion   = nIdTransaccion
          UNION
         SELECT 'S'
           FROM DETALLE_TRANSACCION DT, AGENTES_DISTRIBUCION_COMISION AG,
                SINIESTRO S, APROBACION_ASEG C, AGENTES A
          WHERE A.CodTipo          = cTipoAgente
            AND A.Cod_Agente       = AG.Cod_Agente_Distr
            AND A.CodCia           = AG.CodCia
            AND AG.IDetPol         = S.IDetPol
            AND AG.IdPoliza        = S.IdPoliza
            AND AG.CodCia          = S.CodCia
            AND S.IdSiniestro      = C.IdSiniestro
            AND S.IdPoliza         = C.IdPoliza
            AND S.CodCia           = nCodCia
            AND DT.Correlativo     = 1
            AND (C.IdTransaccion     = DT.IdTransaccion
             OR  C.IdTransaccionAnul = DT.IdTransaccion)
            AND DT.IdTransaccion   = nIdTransaccion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cAplicaTipoAgen := 'N';
         WHEN TOO_MANY_ROWS THEN
            cAplicaTipoAgen := 'S';
      END;
   END IF;

   IF cAplicaTipoAgen = 'N' THEN
      BEGIN
         SELECT 'S'
           INTO cAplicaTipoAgen
           FROM AGENTES_DISTRIBUCION_COMISION AG, AGENTES A, DETALLE_TRANSACCION D, 
                FAI_CONCENTRADORA_FONDO CF, FACTURAS F, DETALLE_POLIZA  DP
          WHERE A.CodTipo           = cTipoAgente
            AND A.Cod_Agente        = AG.Cod_Agente_Distr
            AND A.CodEmpresa        = DP.CodEmpresa
            AND A.CodCia            = AG.CodCia
            AND AG.IDetPol          = DP.IDetPol
            AND AG.IdPoliza         = DP.IdPoliza
            AND AG.CodCia           = DP.CodCia
            AND DP.IdPoliza         = CF.IdPoliza
            AND DP.IDetPol          = CF.IDetPol
            AND DP.CodCia           = CF.CodCia
            AND CF.IdFondo          > 0
            AND CF.CodAsegurado     > 0
            AND CF.IDetPol          > 0
            AND CF.IdPoliza         > 0
            AND CF.IdFactura        = F.IdFactura
            AND (CF.IdTransaccion   = D.IdTransaccion 
             OR CF.IdTransaccionAnu = D.IdTransaccion)
            AND CF.CodEmpresa       = D.CodEmpresa
            AND CF.CodCia           = D.CodCia
            AND GT_FAI_MOVIMIENTOS_FONDOS.INDICADORES(CF.CodCia, CF.CodEmpresa, 
                                                      GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(CF.IdFondo), 
                                                      CF.CodCptoMov, 'GC') = 'S'
            AND D.Correlativo       = 1
            AND D.IdTransaccion     = nIdTransaccion
            AND D.CodCia            = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cAplicaTipoAgen := 'N';
         WHEN TOO_MANY_ROWS THEN
            cAplicaTipoAgen := 'S';
      END;
   END IF;

   RETURN(cAplicaTipoAgen);
END APLICA_TIPO_AGENTE;

PROCEDURE ACTUALIZA_MONEDA(nCodCia NUMBER, nNumComprob NUMBER, cCodMoneda VARCHAR2) IS
BEGIN
   BEGIN
      UPDATE COMPROBANTES_CONTABLES
         SET CodMoneda   = cCodMoneda
       WHERE CodCia      = nCodCia
         AND NumComprob  = nNumComprob;
   END;
END ACTUALIZA_MONEDA;

FUNCTION STATUS_COMPROBANTE(nCodCia NUMBER, nNumComprob NUMBER) RETURN VARCHAR2 IS
cStsComprob    COMPROBANTES_CONTABLES.StsComprob%TYPE;
BEGIN
   BEGIN
      SELECT StsComprob
        INTO cStsComprob
        FROM COMPROBANTES_CONTABLES
       WHERE CodCia     = nCodCia
         AND NumComprob = nNumComprob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000,'No Existe Comprobante No. '||nNumComprob || ' de Compañía ' || nCodCia);
   END;
   RETURN(cStsComprob);
END STATUS_COMPROBANTE;

FUNCTION POSEE_COMPROBANTE(nCodCia NUMBER, nIdTransaccion NUMBER) RETURN VARCHAR2 IS
nExiste    NUMBER(5);
BEGIN
   BEGIN
      SELECT COUNT(*)
        INTO nExiste
        FROM COMPROBANTES_CONTABLES
       WHERE CodCia         = nCodCia
         AND NumTransaccion = nIdTransaccion;
   END;
   IF NVL(nExiste,0) != 0 THEN
      RETURN('S');
   ELSE
      RETURN('N');
   END IF;
END POSEE_COMPROBANTE;

FUNCTION ENVIADO_SISTEMA_CONTABLE(nCodCia NUMBER, nIdTransaccion NUMBER) RETURN VARCHAR2 IS
cEnviado     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cEnviado
        FROM COMPROBANTES_CONTABLES
       WHERE CodCia         = nCodCia
         AND NumTransaccion = nIdTransaccion
         AND FecEnvioSC    IS NOT NULL
         AND NumComprobSC  IS NOT NULL;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cEnviado := 'N';
      WHEN TOO_MANY_ROWS THEN
         cEnviado := 'S';         
   END;
   RETURN(cEnviado);
END ENVIADO_SISTEMA_CONTABLE;

END OC_COMPROBANTES_CONTABLES;
/

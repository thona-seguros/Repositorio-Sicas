create or replace PACKAGE          OC_ENDOSO IS
-- SE AGREGO EL CERIFICADO EN EL PROCEDIMIENTO CAMBIO_POR_LISTADO MLJS 23/10/2023

   FUNCTION CREAR (nIdPoliza NUMBER ) RETURN NUMBER;
   FUNCTION NATURALIDAD(cTipoEndoso VARCHAR2) RETURN VARCHAR2;
   PROCEDURE INSERTA (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                      nIdEndoso NUMBER, cTipoEndoso VARCHAR2, cNumEndRef VARCHAR2, dFecIniVig DATE,
                      dFecFinVig DATE, cCodPlan VARCHAR2, nSuma_Aseg_Moneda NUMBER, nPrima_Moneda NUMBER,
                      nPorcComis NUMBER, cMotivo_Endoso VARCHAR2, dFecExc DATE);
   PROCEDURE INSERTA_CP (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER,
                   cTipoEndoso VARCHAR2, cNumEndRef VARCHAR2, dFecIniVig DATE, dFecFinVig DATE,
                   cCodPlan VARCHAR2, nSuma_Aseg_Moneda NUMBER, nPrima_Moneda NUMBER, nPorcComis NUMBER,
                   cMotivo_Endoso VARCHAR2, cDesc_Endoso VARCHAR2, dFecExc DATE);
   FUNCTION EXISTE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, cTipoEndoso VARCHAR2) RETURN VARCHAR2;
   FUNCTION EXISTE_CP(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, cTipoEndoso VARCHAR2, cNumEndRef VARCHAR2) RETURN VARCHAR2;
   FUNCTION ESTATUS_CP (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, cNumEndRef VARCHAR2) RETURN VARCHAR2;
   FUNCTION MONTO_ENDOSO_BAJA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER,
                              dFecExc DATE, cCodPlanPago VARCHAR2, cIndFactPeriodo VARCHAR2 )RETURN NUMBER;
   FUNCTION NUMERO (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, cTipoEndoso VARCHAR2) RETURN NUMBER;
   FUNCTION NUMERO_CP (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, cNumEndRef VARCHAR2) RETURN NUMBER;
   PROCEDURE EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, nIdEndoso NUMBER, cTipoEndoso VARCHAR2);
   PROCEDURE EMITIR_AUMENTO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, nIdEndoso NUMBER, cTipoEndoso VARCHAR2);
   PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, nIdEndoso NUMBER, cTipoEndoso VARCHAR2);
   FUNCTION VALIDA_ENDOSO(nCodCia NUMBER, nIdPoliza NUMBER, nIdEndoso NUMBER, cNaturalidad OUT VARCHAR2) RETURN VARCHAR2;
   PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, nIdEndoso NUMBER,
                    cTipoEndoso VARCHAR2, dFecAnul DATE, cMotivAnul VARCHAR2);
   PROCEDURE ACTUALIZA_VALORES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER);
   PROCEDURE CALCULA_EXCLUSION_ASEG(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndosoExclu NUMBER);
   PROCEDURE EXCLUIR_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndosoExclu NUMBER);
   FUNCTION TOTAL_PRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) RETURN NUMBER;
   FUNCTION TOTAL_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) RETURN NUMBER;
   FUNCTION CAMBIO_POR_LISTADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nCertidicado NUMBER) RETURN VARCHAR2;
   FUNCTION VALIDA_CAMBIO_FORMA_DE_PAGO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                                        cCodPlanPagoEndo VARCHAR2, nPrimaPendiente IN OUT NUMBER, cIndCalcDerechoEmis IN OUT VARCHAR2) RETURN VARCHAR2;
   PROCEDURE REHABILITACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdEndoso NUMBER);
   PROCEDURE ENDOSO_ANULACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, dFecAnulacion DATE, cMotivAnul VARCHAR2);
   PROCEDURE ENDOSO_REHABILITACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER);
   FUNCTION MONEDA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) RETURN VARCHAR2;

   --JIBARRA_09-11-2022 <SE CREA PROCESO PARA LA ACTUALIZACION DE LAS FECHAS DE VIGENCIA DE ENDOSO, CERTIFICADO, POLIZA, FACTRUAS O NOTAS DE CREDITO
   --                SEGUN COMO CORRESPONDE A LA NECESIDAD DEL USURAIO>
   PROCEDURE ACTUALIZA_FECHAS_VIG(nCodCia IN NUMBER, nIdPoliza IN NUMBER, nIDetPol IN NUMBER, nIdEndoso IN NUMBER, nNumError OUT NUMBER, cMsjError OUT VARCHAR2);

END OC_ENDOSO;

/
create or replace PACKAGE BODY          OC_ENDOSO IS
  FUNCTION CREAR (nIdPoliza NUMBER )RETURN NUMBER IS
  nIdEndoso ENDOSOS.IdEndoso%TYPE;
  BEGIN
     BEGIN
        SELECT NVL(MAX(IdEndoso),0) + 1
    INTO nIdEndoso
    FROM ENDOSOS
         WHERE IdPoliza = nIdPoliza;
     END;
     RETURN(nIdEndoso);
  END CREAR ;

  FUNCTION NATURALIDAD (cTipoEndoso VARCHAR2) RETURN VARCHAR2 IS
  cNaturalidad   PROPIEDADES_VALORES.Valor%TYPE;
  BEGIN
     BEGIN
        SELECT A.Valor
    INTO cNaturalidad
    FROM PROPIEDADES_VALORES A
         WHERE A.CodLista  = 'TIPENDOS'
     AND A.CodValor  = cTipoEndoso
     AND A.Propiedad = 'NATURALEZA';
     EXCEPTION
       WHEN OTHERS THEN
    cNaturalidad := ' ';
     END;
     RETURN(cNaturalidad);
  END NATURALIDAD;

  PROCEDURE INSERTA (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER,
         cTipoEndoso VARCHAR2, cNumEndRef VARCHAR2, dFecIniVig DATE, dFecFinVig DATE,
         cCodPlan VARCHAR2, nSuma_Aseg_Moneda NUMBER, nPrima_Moneda NUMBER, nPorcComis NUMBER,
         cMotivo_Endoso VARCHAR2, dFecExc DATE) IS
  nTasacambio      TASAS_CAMBIO.Tasa_Cambio%TYPE;
  BEGIN
     BEGIN
        SELECT OC_GENERALES.TASA_DE_CAMBIO(Cod_Moneda, TRUNC(SYSDATE))
    INTO nTasacambio
    FROM POLIZAS
         WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdPoliza   = nIdPoliza;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-20225,'NO Existe Pólliza No.  :' || nIdPoliza);
        WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20225,SQLERRM);
     END;

     BEGIN
        INSERT INTO ENDOSOS
        (IdPoliza, IdEndoso, TipoEndoso, NumEndRef, FecIniVig, FecFinVig, FecSolicitud,
         FecEmision, StsEndoso, FecSts, CodPlanPago, Suma_Aseg_Local, Suma_Aseg_Moneda,
         Prima_Neta_Local, Prima_Neta_Moneda, PorcComis, CodEmpresa, CodCia, IdetPol,
         Motivo_Endoso, FecExc)
        VALUES(nIdPoliza, nIdEndoso, cTipoEndoso, cNumEndRef, dFecIniVig, dFecFinVig, TRUNC(SYSDATE),
         TRUNC(SYSDATE), 'SOL', TRUNC(SYSDATE), cCodPlan, nSuma_Aseg_Moneda * nTasacambio, nSuma_Aseg_Moneda,
         nPrima_Moneda * nTasacambio, nPrima_Moneda, nPorcComis, nCodEmpresa, nCodCia, nIDetPol,
         cMotivo_Endoso, dFecExc);
     EXCEPTION
        WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20225,'Error en Insertar Endoso  :'||SQLERRM);
     END;
  END INSERTA;

  PROCEDURE INSERTA_CP (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER,
         cTipoEndoso VARCHAR2, cNumEndRef VARCHAR2, dFecIniVig DATE, dFecFinVig DATE,
         cCodPlan VARCHAR2, nSuma_Aseg_Moneda NUMBER, nPrima_Moneda NUMBER, nPorcComis NUMBER,
         cMotivo_Endoso VARCHAR2, cDesc_Endoso VARCHAR2, dFecExc DATE) IS
  nTasacambio      TASAS_CAMBIO.Tasa_Cambio%TYPE;
  BEGIN
     BEGIN
        SELECT OC_GENERALES.TASA_DE_CAMBIO(Cod_Moneda, TRUNC(SYSDATE))
    INTO nTasacambio
    FROM POLIZAS
         WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdPoliza   = nIdPoliza;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-20225,'NO Existe Pólliza No.  :' || nIdPoliza);
        WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20225,SQLERRM);
     END;

     BEGIN
        INSERT INTO ENDOSOS
        (IdPoliza, IdEndoso, TipoEndoso, NumEndRef, FecIniVig, FecFinVig, FecSolicitud,
         FecEmision, StsEndoso, FecSts, CodPlanPago, Suma_Aseg_Local, Suma_Aseg_Moneda,
         Prima_Neta_Local, Prima_Neta_Moneda, PorcComis, CodEmpresa, CodCia, IdetPol,
         Motivo_Endoso, FecExc)
        VALUES(nIdPoliza, nIdEndoso, cTipoEndoso, cNumEndRef, dFecIniVig, dFecFinVig, TRUNC(SYSDATE),
         TRUNC(SYSDATE), 'SOL', TRUNC(SYSDATE), cCodPlan, nSuma_Aseg_Moneda * nTasacambio, nSuma_Aseg_Moneda,
         nPrima_Moneda * nTasacambio, nPrima_Moneda, nPorcComis, nCodEmpresa, nCodCia, nIDetPol,
         cMotivo_Endoso, dFecExc);
     EXCEPTION
        WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20225,'Error en Insertar Endoso  :'||SQLERRM);
     END;
  END INSERTA_CP;

  FUNCTION EXISTE (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, cTipoEndoso VARCHAR2) RETURN VARCHAR2 IS
  cExiste   VARCHAR2 (1);
  BEGIN
     BEGIN
        SELECT 'S'
    INTO cExiste
    FROM ENDOSOS
         WHERE TipoEndoso = cTipoEndoso
     AND CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdPoliza   = nIdPoliza
     AND IdetPol    = nIdetPol;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
     cExiste := 'N';
        WHEN TOO_MANY_ROWS  THEN
     cExiste := 'S';
     END;
     RETURN(cExiste);
  END EXISTE;

  FUNCTION EXISTE_CP (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, cTipoEndoso VARCHAR2, cNumEndRef VARCHAR2) RETURN VARCHAR2 IS
  cExiste   VARCHAR2 (1);
  BEGIN
     BEGIN
        SELECT 'S'
    INTO cExiste
    FROM ENDOSOS
         WHERE TipoEndoso = cTipoEndoso
     AND CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdPoliza   = nIdPoliza
     AND IdetPol    = nIdetPol
     AND NumEndRef  = cNumEndRef;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
     cExiste := 'N';
        WHEN TOO_MANY_ROWS  THEN
     cExiste := 'S';
     END;
     RETURN(cExiste);
  END EXISTE_CP;

  FUNCTION ESTATUS_CP(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, cNumEndRef VARCHAR2) RETURN VARCHAR2 IS
  cEstatus   VARCHAR2 (3);
  BEGIN
     BEGIN
        SELECT STSENDOSO
    INTO cEstatus
    FROM ENDOSOS
         WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdPoliza   = nIdPoliza
     AND IdetPol    = nIdetPol
     AND NumEndRef  = cNumEndRef;
     EXCEPTION
        WHEN OTHERS  THEN
     RAISE_APPLICATION_ERROR(-20225,'Error al recuperar el estatus del endoso :'||SQLERRM);
     END;
     RETURN(cEstatus);
  END ESTATUS_CP;

  FUNCTION MONTO_ENDOSO_BAJA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER,
           dFecExc DATE, cCodPlanPago VARCHAR2, cIndFactPeriodo VARCHAR2) RETURN NUMBER IS
  nFrecPagos         PLAN_DE_PAGOS.FrecPagos%TYPE;
  nMes               NUMBER (10);
  dFecPago           FACTURAS.FecPago%TYPE;
  nPrimaEnd          ENDOSOS.Prima_Neta_Local%TYPE;
  dFecUlt            FACTURAS.FecPago%TYPE;
  dFecIniVig         DETALLE_POLIZA.FecIniVig%TYPE;
  nPrima_local       DETALLE_POLIZA.Prima_local%TYPE;
  dFecFinVig         DETALLE_POLIZA.FecFinVig%TYPE;
  BEGIN
     BEGIN
        SELECT FrecPagos
    INTO nFrecPagos
    FROM PLAN_DE_PAGOS
         WHERE CodCia      = nCodCia
     AND CodEmpresa  = nCodEmpresa
     AND CodPlanPago = cCodPlanPago;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-20225,'No Existe Plan de Pagos  :'||SQLERRM);
     END;
     BEGIN
        SELECT FecIniVig,FecFinVig,Prima_local
    INTO dFecIniVig, dFecFinVig,nPrima_local
    FROM DETALLE_POLIZA
         WHERE IdPoliza = nIdPoliza
     AND CodCia   = nCodCia
     AND IdetPol  = nIdetPol;
     EXCEPTION
        WHEN OTHERS  THEN
     RAISE_APPLICATION_ERROR(-20225,'Error en Detalle de Poliza  :'||SQLERRM);
     END;

     BEGIN
        SELECT TO_DATE(TRUNC(NVL(ADD_MONTHS(MAX(FECVENC),nFrecPagos),SYSDATE)),'DD/MM/YYYY'),MAX(FECVENC)
    INTO dFecPago, dFecUlt
    FROM FACTURAS
         WHERE IdPoliza = nIdPoliza
     AND CodCia   = nCodCia;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
     dFecPago := TRUNC(SYSDATE);
     END;

     IF NVL(cIndFactPeriodo,'N') = 'S' THEN
        IF TRUNC(dFecExc) BETWEEN TRUNC(DFECPAGO,'MONTH') AND TRUNC(LAST_DAY(dFecPago))THEN   -- ENDOINA
  --    IF TRUNC(dFecExc) BETWEEN TRUNC (TO_DATE(('01'||'-'||TO_CHAR(dFecPago,'MM')||'-'||TO_CHAR(dFecPago,'YYYY')))) AND TRUNC(LAST_DAY(dFecPago))THEN

     nPrimaEnd := 0;
        ELSIF  dFecExc  > dFecUlt THEN
     nPrimaEnd := 0;
        ELSE
     nMes := OC_GENERALES.VALIDA_FECHA_FACTURA(TRUNC(dFecExc),dFecPago);
     IF NVL(nMes,0) > 0  THEN
        nPrimaEnd := (nPrima_local / 12) * nMes;
     END IF;
        END IF ;
     ELSE
        nPrimaEnd := nPrima_Local;
     END IF;
     RETURN (nPrimaEnd);
  END MONTO_ENDOSO_BAJA;

  FUNCTION NUMERO (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, cTipoEndoso VARCHAR2) RETURN NUMBER IS
  nIdEndoso   ENDOSOS.IdEndoso%TYPE;
  BEGIN
     BEGIN
        SELECT IdEndoso
    INTO nIdEndoso
    FROM ENDOSOS
         WHERE TipoEndoso = cTipoEndoso
     AND CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdPoliza   = nIdPoliza
     AND IdetPol    = nIdetPol;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
    nIdEndoso := ' ';
    END;
     RETURN(nIdEndoso);
  END NUMERO;

  FUNCTION NUMERO_CP (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, cNumEndRef VARCHAR2) RETURN NUMBER IS
  nIdEndoso   ENDOSOS.IdEndoso%TYPE;
  BEGIN
     BEGIN
        SELECT IdEndoso
    INTO nIdEndoso
    FROM ENDOSOS
         WHERE NumEndRef  = cNumEndRef
     AND CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdPoliza   = nIdPoliza
     AND IdetPol    = nIdetPol;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
    nIdEndoso := ' ';
    END;
     RETURN(nIdEndoso);
  END NUMERO_CP;

PROCEDURE EMITIR(nCodcia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER,
                  nIdEndoso NUMBER, cTipoEndoso VARCHAR2) IS
   cIndFactPeriodo      POLIZAS.IndFactPeriodo%TYPE;
   nIdFactura           FACTURAS.IdFactura%TYPE;
   nSuma_Aseg_Moneda    ENDOSOS.Suma_Aseg_Moneda%TYPE;
   nPrima_Moneda        ENDOSOS.Prima_Neta_Moneda%TYPE;
   nIdTransacAnul       TRANSACCION.IdTransaccion%TYPE;
   dFecIniVig           ENDOSOS.FecIniVig%TYPE;
   cIndFacturaPol       POLIZAS.IndFacturaPol%TYPE;
   cCodPlanPago         ENDOSOS.CodPlanPago%TYPE;
   nRegis               NUMBER(6);
   cNaturalidad         VARCHAR2(2);
   nNaturalidad         NUMBER;
   nIdTrn               NUMBER(10);
   nMontoAporteFondo    ENDOSOS.MontoAporteFondo%TYPE;
   nMtoAporteIniMoneda  FAI_FONDOS_DETALLE_POLIZA.MtoAporteIniMoneda%TYPE;
   nMtoAporteIniLocal   FAI_FONDOS_DETALLE_POLIZA.MtoAporteIniLocal%TYPE;
   nCodAsegurado        DETALLE_POLIZA.Cod_Asegurado%TYPE;
   cCodMoneda           POLIZAS.Cod_Moneda%TYPE;


   CURSOR COBERT_Q IS
      SELECT IdTipoSeg, CodCobert, SumaAseg_Local,
         SumaAseg_Moneda, Tasa, Prima_Local, Prima_Moneda
      FROM COBERT_ACT
      WHERE CodCia   = nCodCia
      AND IdPoliza = nIdPoliza
      AND IDetPol  = nIDetPol
      AND IdEndoso = nIdEndoso;

   CURSOR ASEG_Q IS
      SELECT Cod_Asegurado, IDetPol
      FROM ASEGURADO_CERTIFICADO
      WHERE CodCia   = nCodCia
      AND IdPoliza = nIdPoliza
      AND IdEndoso = nIdEndoso
      AND Estado  != 'REZ';

   CURSOR DET_Q IS
      SELECT DISTINCT IDetPol
      FROM DETALLE_POLIZA
      WHERE CodCia     = nCodCia
      AND IdPoliza   = nIdPoliza
      AND StsDetalle = 'SOL'
      AND IDetPol   IN (SELECT DISTINCT IDetPol
                  FROM ASEGURADO_CERTIFICADO
                  WHERE CodCia   = nCodCia
                  AND IdPoliza = nIdPoliza
                  AND IdEndoso = nIdEndoso);

   CURSOR FACT_Q IS
      SELECT F.IDetPol, F.IdEndoso, F.IdFactura, F.Monto_Fact_Moneda, F.CodCobrador
      FROM POLIZAS P, FACTURAS F
      WHERE P.IndFacturaPol = 'S'
      AND P.IdPoliza      = F.IdPoliza
      AND P.CodCia        = F.CodCia
      AND F.CodCia        = nCodCia
      AND F.IdPoliza      = nIdPoliza
      AND (F.IdEndoso     = 0
         OR (F.IdEndoso     > 0
            AND  EXISTS (SELECT 'S'
                     FROM ENDOSOS
                     WHERE CodCia     = nCodCia
                     AND IdPoliza   = nIdPoliza
                     AND IdEndoso   > F.IdEndoso
                     AND TipoEndoso = 'CFP')))
      AND F.StsFact       = 'EMI'
   UNION
      SELECT F.IDetPol, F.IdEndoso, F.IdFactura, F.Monto_Fact_Moneda, F.CodCobrador
      FROM POLIZAS P, FACTURAS F
      WHERE P.IndFacturaPol = 'N'
      AND P.IdPoliza      = F.IdPoliza
      AND P.CodCia        = F.CodCia
      AND F.CodCia        = nCodCia
      AND F.IdPoliza      = nIdPoliza
      AND F.IDetPol       = nIDetPol
      AND (F.IdEndoso     = 0
         OR (F.IdEndoso     > 0
            AND EXISTS (SELECT 'S'
                     FROM ENDOSOS
                     WHERE CodCia     = nCodCia
                     AND IdPoliza   = nIdPoliza
                     AND IDetPol    = nIDetPol
                     AND IdEndoso   > F.IdEndoso
                     AND TipoEndoso = 'CFP')))
      AND F.StsFact       = 'EMI';

   CURSOR FOND_Q IS
      SELECT TipoFondo, PorcFondo, IdFondo
      FROM FAI_FONDOS_DETALLE_POLIZA
      WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCodAsegurado
      AND GT_FAI_TIPOS_DE_FONDOS.INDICADORES(CodCia, CodEmpresa, TipoFondo, 'EPP') = 'N'
      ORDER BY IdFondo;

   nControl NUMBER;
BEGIN

   BEGIN
      nControl := 1;
      SELECT Cod_Asegurado
      INTO nCodAsegurado
      FROM DETALLE_POLIZA
      WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol;

    EXCEPTION WHEN OTHERS THEN
      nCodAsegurado := NULL;
    END;
   nControl := 2;
   SELECT NVL(IndFactPeriodo,'N'), Cod_Moneda
   INTO cIndFactPeriodo, cCodMoneda
   FROM POLIZAS
   WHERE CodCia   = nCodCia
   AND IdPoliza = nIdPoliza;

    BEGIN
      nControl := 3;
      SELECT Suma_Aseg_Moneda
         ,Prima_Neta_Moneda
         ,FecIniVig
         ,CodPlanPago
         ,NVL(MontoAporteFondo,0)
      INTO nSuma_Aseg_Moneda
         ,nPrima_Moneda
         ,dFecIniVig
         ,cCodPlanPago
         ,nMontoAporteFondo
      FROM ENDOSOS
      WHERE CodCia   = nCodCia
      AND IdPoliza = nIdPoliza
      AND IDetPol  = nIDetPol
      AND IdEndoso = nIdEndoso;
    EXCEPTION WHEN OTHERS THEN
        nSuma_Aseg_Moneda := 0;
        nPrima_Moneda := 0;
        dFecIniVig := NULL;
        cCodPlanPago := NULL;
        nMontoAporteFondo := 0;
    END;
   nControl := 4;
   UPDATE COBERTURAS
   SET StsCobertura = 'EMI'
   WHERE CodCia   = nCodCia
   AND IdPoliza = nIdPoliza
   AND IDetPol  = nIDetPol
   AND IdEndoso = nIdEndoso;

   --JIBARRA_28-11-2022 <SSE EXCLUYE AL TIPO DE ENDOSO CORRESPONDIENTES A LA ACTUALIZACION DE LAS FECHAS COMO FUE SOLICITADA.>
   IF cTipoEndoso NOT IN ('EXC','DIS','CFP','CFV') THEN
      nControl := 5;
      IF OC_ASEGURADO_CERTIFICADO.TIENE_ASEGURADOS(nCodCia, nIdPoliza, nIDetPol, nIdEndoso) = 'N' THEN
         nControl := 6;
         OC_COBERT_ACT.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
         nControl := 6.1;
         OC_ASISTENCIAS_DETALLE_POLIZA.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
         nControl := 6.2;
         OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIDetPol, nIdEndoso);
      ELSE
         nControl := 7;
         FOR W IN ASEG_Q LOOP
            OC_COBERT_ACT_ASEG.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol, W.Cod_Asegurado, nIdEndoso);
            OC_ASISTENCIAS_ASEGURADO.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol, W.Cod_Asegurado, nIdEndoso);
            OC_ASEGURADO_CERTIFICADO.EMITIR(nCodCia, nIdPoliza, W.IDetPol, W.Cod_Asegurado, nIdEndoso);
         END LOOP;
         nControl := 8;
         FOR Z IN DET_Q LOOP
            OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, Z.IDetPol, nIdEndoso);
            OC_DETALLE_POLIZA.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, Z.IDetPol);
         END LOOP;
      END IF;
   END IF;
   nControl := 9;
   cNaturalidad := OC_ENDOSO.NATURALIDAD(cTipoEndoso);

   IF cNaturalidad = '-' THEN
      nControl := 10;
      nNaturalidad := -1;
   ELSE
      nControl := 11;
      nNaturalidad := 1;
   END IF;

   IF cTipoEndoso = 'CFP' THEN
      nControl := 12;
      nIdTransacAnul := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 8, 'ANUFAC');

      OC_DETALLE_TRANSACCION.CREA (nIdTransacAnul, nCodCia,  nCodEmpresa, 8, 'ANUFAC', 'ENDOSOS'
                           ,nIdPoliza, nIDetPol, nIdEndoso, NULL, nPrima_Moneda);

      FOR X IN FACT_Q LOOP
         OC_FACTURAS.ANULAR(nCodCia, X.IdFactura, dFecIniVig, 'CFP', X.CodCobrador, nIdTransacAnul);
         OC_DETALLE_TRANSACCION.CREA (nIdTransacAnul, nCodCia,  nCodEmpresa, 8, 'ANUFAC', 'FACTURAS'
                              ,nIdPoliza, X.IDetPol, X.IdEndoso, X.IdFactura, NVL(X.Monto_Fact_Moneda,0));
      END LOOP;

      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacAnul, 'C');

      UPDATE POLIZAS
      SET CodPlanPago = cCodPlanPago
      WHERE CodCia   = nCodCia
      AND IdPoliza = nIdPoliza;

      UPDATE DETALLE_POLIZA
      SET CodPlanPago = cCodPlanPago
      WHERE CodCia   = nCodCia
      AND IdPoliza = nIdPoliza;
   END IF;

   --JIBARRA_28-11-2022 <SE EXCLUYE AL TIPO DE ENDOSO CORRESPONDIENTES A LA ACTUALIZACION DE LAS FECHAS COMO FUE SOLICITADA.>
   IF cTipoEndoso NOT IN ('ESV','ESVTL','CLA','EAAF','CFV') THEN
      nControl := 13;
      /*FOR X IN COBERT_Q LOOP
         SELECT NVL(COUNT(*),0)
         INTO nRegis
         FROM COBERT_ACT
         WHERE CodCia    = nCodCia
         AND IdPoliza  = nIdPoliza
         AND IDetPol   = nIDetPol
         AND CodCobert = X.CodCobert;

         IF NVL(nRegis,0) > 0 THEN
            UPDATE COBERT_ACT
            SET SumaAseg_Local  = NVL(SumaAseg_Local,0)  + (X.SumaAseg_Local  * nNaturalidad),
            SumaAseg_Moneda = NVL(SumaAseg_Moneda,0) + (X.SumaAseg_Moneda * nNaturalidad),
            Prima_Local     = NVL(Prima_Local,0)  + (X.Prima_Local  *  nNaturalidad),
            Prima_Moneda    = NVL(Prima_Moneda,0) + (X.Prima_Moneda * nNaturalidad)
            -- ,                          StsCobertura = 'CEX'
            WHERE CodCia    = nCodCia
            AND IdPoliza  = nIdPoliza
            AND IDetPol   = nIDetPol
            AND CodCobert = X.CodCobert;
         END IF;
      END LOOP;*/

      nIdTrn := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 8, cTipoEndoso);
      OC_DETALLE_TRANSACCION.CREA(nIdTrn, nCodCia, nCodEmpresa, 8, cTipoEndoso, 'ENDOSOS',
                           nIdPoliza, nIDetPol, nIdEndoso, NULL, nPrima_Moneda);
      IF NVL(cIndFactPeriodo,'N') = 'N' THEN
         IF cNaturalidad = '+' AND nPrima_Moneda != 0 THEN
            OC_FACTURAR.PROC_EMITE_FACT_END (nIdPoliza, nIDetPol, nIdEndoso, nIdTrn);
         ELSIF cNaturalidad = '-' AND nPrima_Moneda != 0 THEN
            OC_NOTAS_DE_CREDITO.EMITIR_NOTA_CREDITO(nIdPoliza, nIDetPol, nIdEndoso, nIdTrn);
         END IF;
      ELSE
         IF cNaturalidad = '+' AND nPrima_Moneda != 0 THEN
            OC_FACTURAR.PROC_EMITE_FACT_ENDO_PERIODO(nIdPoliza, 0, nCodCia, nIdTrn, 1);
         END IF;
      END IF;
      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTrn, 'C');
   ELSIF cTipoEndoso IN ('EAAF') THEN
      nControl := 14;
      UPDATE DETALLE_POLIZA
      SET MontoAporteFondo = nMontoAporteFondo
      WHERE CodCia    = nCodCia
      AND IdPoliza  = nIdPoliza
      AND IDetPol   = nIDetPol;

      FOR X IN FOND_Q LOOP
          nMtoAporteIniMoneda  := nMontoAporteFondo * (X.PorcFondo / 100);
          nMtoAporteIniLocal   := nMtoAporteIniMoneda * OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(dFecIniVig));

         UPDATE FAI_FONDOS_DETALLE_POLIZA
         SET MtoAporteIniLocal   = nMtoAporteIniLocal,
            MtoAporteIniMoneda  = nMtoAporteIniMoneda
         WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND CodAsegurado  = nCodAsegurado
         AND IdFondo       = X.IdFondo;
      END LOOP;
   ELSE
      nControl := 15;
      --JIBARRA_28-11-2022 <SE LLAMA EL PROCESO CORRESPONDIENTE AL TIPO DE ENDOSO CORRESPONDIENTES A LA ACTUALIZACION DE LAS FECHAS COMO FUE SOLICITADA.>
      IF(cTipoEndoso = 'CFV')THEN
         nControl := 15.1;
         DECLARE
            nNumError   NUMBER;
            cMsjError   VARCHAR2(4000);
         BEGIN
            nControl := 15.2;
            ACTUALIZA_FECHAS_VIG(nCodCia,nIdPoliza, nIDetPol, nIdEndoso, nNumError, cMsjError);
            IF(nNumError != 0)THEN
               nControl := 15.3;
               RAISE_APPLICATION_ERROR(-20225,'ERROR ACTUALIZA_FECHAS_VIG. [' || nNumError || ']' || cMsjError);
            END IF;
         END;
      END IF;

      --JIBARRA_28-11-2022 <NO GENERA TRANSACCION, SOLO SE ACTUALIZAN FECHAS CON EL ENDOSO [CFV].>
      IF(cTipoEndoso != 'CFV')THEN
         nControl := 16;
         nIdTrn := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 8, cTipoEndoso);
         nControl := 17;
         OC_DETALLE_TRANSACCION.CREA(nIdTrn, nCodCia, nCodEmpresa, 8, cTipoEndoso, 'ENDOSOS',
              nIdPoliza, nIDetPol, nIdEndoso, NULL, nPrima_Moneda);
      END IF;

   END IF;
   --JIBARRA_28-11-2022 <SOLO SE ACTUALIZAN FECHAS CON EL ENDOSO [CFV].>
   IF(cTipoEndoso != 'CFV')THEN
      nControl := 18;
      OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIDetPol, nIdEndoso);
      nControl := 19;
      OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIdEndoso);
   END IF;

   nControl := 20;
   UPDATE ENDOSOS
   SET StsEndoso = 'EMI',
      FecSts    = TRUNC(SYSDATE)
   WHERE CodCia    = nCodCia
   AND IdPoliza  = nIdPoliza
   AND IDetPol   = nIDetPol
   AND IdEndoso  = nIdEndoso;

   nControl := 21;
   GT_REA_DISTRIBUCION.DISTRIBUYE_REASEGURO(nCodCia, nCodEmpresa, nIdPoliza, nIdTrn, TRUNC(SYSDATE), 'ENDOSOS');
EXCEPTION WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'ERROR GENERAL Endoso.EMITIR [' || nControl || ']' || sqlerrm);
END EMITIR;

  PROCEDURE EMITIR_AUMENTO(nCodcia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER,
         nIdEndoso NUMBER, cTipoEndoso VARCHAR2) IS
  cIndFactPeriodo    POLIZAS.IndFactPeriodo%TYPE;
  nIdFactura         FACTURAS.IdFactura%TYPE;
  nSuma_Aseg_Moneda  ENDOSOS.Suma_Aseg_Moneda%TYPE;
  nRegis             NUMBER(6);
  cNaturalidad       VARCHAR2(2);
  nNaturalidad       NUMBER;
  nIdTrn             NUMBER(10);

  CURSOR COBERT_Q IS
     SELECT IdTipoSeg, CodCobert, Suma_Asegurada_local SumaAseg_Local,
      Suma_Asegurada_Moneda SumaAseg_Moneda, Tasa,
      Prima_Local, Prima_Moneda, IDetPol, IdEndoso,
      Deducible_Local, Deducible_Moneda
       FROM COBERTURAS C
      WHERE IdPoliza = nIdPoliza
        AND EXISTS (SELECT 1
          FROM ENDOSOS E
         WHERE C.IdPoliza   = E.IdPoliza
           AND E.IDetPol    = C.IDetPol
           AND E.TipoEndoso = 'AUM'
           AND E.StsEndoso  = 'SOL'
           AND E.IdEndoso   = C.IdEndoso);
  CURSOR ASEG_Q IS
     SELECT Cod_Asegurado
       FROM ASEGURADO_CERTIFICADO
      WHERE CodCia    = nCodCia
        AND IdPoliza  = nIdPoliza
        AND IDetPol   = nIDetPol
        AND Estado    = 'EMI';
  BEGIN
     SELECT NVL(IndFactPeriodo,'N')
       INTO cIndFactPeriodo
       FROM POLIZAS
      WHERE CodCia   = nCodCia
        AND IdPoliza = nIdPoliza;

     SELECT Suma_Aseg_Moneda
       INTO nSuma_Aseg_Moneda
       FROM ENDOSOS
      WHERE CodCia   = nCodCia
        AND IdPoliza = nIdPoliza
        AND IDetPol  = nIDetPol
        AND IdEndoso = nIdEndoso;

     /*IF cTipoEndoso NOT IN ('EXC','DIS') THEN
        UPDATE COBERT_ACT
     SET StsCobertura = 'EMI'
         WHERE CodCia   = nCodCia
     AND IdPoliza = nIdPoliza
     AND IDetPol  = nIDetPol
     AND IdEndoso = nIdEndoso;
     END IF;*/

     cNaturalidad := OC_ENDOSO.NATURALIDAD(cTipoEndoso);

     IF cNaturalidad = '-' THEN
        nNaturalidad := -1;
     ELSE
        nNaturalidad := 1;
     END IF;

     IF cTipoEndoso NOT IN ('ESV','ESVTL','CLA') THEN
        nIdTrn            := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 8, cTipoEndoso);
        nSuma_Aseg_Moneda := 0;
        FOR X IN COBERT_Q LOOP
     SELECT NVL(COUNT(*),0)
       INTO nRegis
       FROM COBERT_ACT
      WHERE CodCia    = nCodCia
        AND IdPoliza  = nIdPoliza
        AND IDetPol   = nIDetPol
        AND CodCobert = X.CodCobert;

     nSuma_Aseg_Moneda := NVL(nSuma_Aseg_Moneda,0) + X.SumaAseg_Moneda;
     IF NVL(nRegis,0) > 0 THEN
        UPDATE COBERT_ACT
           SET SumaAseg_Local   = NVL(SumaAseg_Local,0)  + (X.SumaAseg_Local  * nNaturalidad),
         SumaAseg_Moneda  = NVL(SumaAseg_Moneda,0) + (X.SumaAseg_Moneda * nNaturalidad),
         Prima_Local      = NVL(Prima_Local,0)  + (X.Prima_Local  *  nNaturalidad),
         Prima_Moneda     = NVL(Prima_Moneda,0) + (X.Prima_Moneda * nNaturalidad),
         Deducible_Local  = NVL(Deducible_Local,0)  + (X.Deducible_Local  *  nNaturalidad),
         Deducible_Moneda = NVL(Deducible_Moneda,0) + (X.Deducible_Moneda * nNaturalidad)
         WHERE CodCia       = nCodCia
           AND IdPoliza     = nIdPoliza
           AND IDetPol      = nIDetPol
           AND CodCobert    = X.CodCobert
           AND StsCobertura = 'EMI';
     ELSE
        UPDATE COBERT_ACT_ASEG
           SET SumaAseg_Local   = NVL(SumaAseg_Local,0)  + (X.SumaAseg_Local  * nNaturalidad),
         SumaAseg_Moneda  = NVL(SumaAseg_Moneda,0) + (X.SumaAseg_Moneda * nNaturalidad),
         Prima_Local      = NVL(Prima_Local,0)  + (X.Prima_Local  *  nNaturalidad),
         Prima_Moneda     = NVL(Prima_Moneda,0) + (X.Prima_Moneda * nNaturalidad),
         Deducible_Local  = NVL(Deducible_Local,0)  + (X.Deducible_Local  *  nNaturalidad),
         Deducible_Moneda = NVL(Deducible_Moneda,0) + (X.Deducible_Moneda * nNaturalidad)
         WHERE CodCia       = nCodCia
           AND IdPoliza     = nIdPoliza
           AND IDetPol      = nIDetPol
           AND CodCobert    = X.CodCobert
           AND StsCobertura = 'EMI';
     END IF;
        END LOOP;

        FOR W IN ASEG_Q LOOP
     OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, W.Cod_Asegurado);
     OC_ASEGURADO_CERTIFICADO.ACTUALIZA_ASISTENCIAS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, W.Cod_Asegurado);
        END LOOP;

        OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIDetPol, nIdEndoso);
        OC_DETALLE_TRANSACCION.CREA(nIdTrn, nCodCia, nCodEmpresa, 8, cTipoEndoso, 'ENDOSOS',
            nIdPoliza, nIDetPol, nIdEndoso, NULL, nSuma_Aseg_Moneda);
        OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIdEndoso);

        IF NVL(cIndFactPeriodo,'N') = 'N' THEN
     IF cNaturalidad = '+'  THEN
        OC_FACTURAR.PROC_EMITE_FACT_END (nIdPoliza, nIDetPol, nIdEndoso, nIdTrn);
     ELSIF cNaturalidad = '-' THEN
       OC_NOTAS_DE_CREDITO.EMITIR_NOTA_CREDITO(nIdPoliza, nIDetPol, nIdEndoso, nIdTrn);
     END IF;
        ELSE
     IF cNaturalidad = '+'  THEN
        OC_FACTURAR.PROC_EMITE_FACT_ENDO_PERIODO(nIdPoliza, 0, nCodCia, nIdTrn, 1);

        SELECT MIN(IdFactura)
          INTO nIdFactura
          FROM FACTURAS
         WHERE CodCia        = nCodCia
           AND IdPoliza      = nIdPoliza
           AND IdTransaccion = nIdTrn;

        UPDATE DETALLE_ENDOSO D
           SET D.IdFactura = nIdFactura
         WHERE D.IdPoliza  = nIdPoliza
           AND EXISTS (SELECT 1
             FROM ENDOSOS E
            WHERE D.IdPoliza    = E.IdPoliza
              AND E.IDetPol     = D.IDetPol
              AND E.TipoEndoso  = 'AUM'
              AND E.StsEndoso   = 'SOL'
              AND E.IdEndoso    = D.IdEndoso);
     END IF;
        END IF;
        OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTrn, 'C');
     ELSE
        nIdTrn := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 8, cTipoEndoso);
        OC_DETALLE_TRANSACCION.CREA(nIdTrn, nCodCia, nCodEmpresa, 8, cTipoEndoso, 'ENDOSOS',
            nIdPoliza, nIDetPol, nIdEndoso, NULL, nSuma_Aseg_Moneda);
     END IF;

     UPDATE COBERTURAS
        SET StsCobertura = 'EMI'
      WHERE CodCia    = nCodCia
        AND IdPoliza  = nIdPoliza
        AND IDetPol   = nIDetPol
        AND IdEndoso  = nIdEndoso
        AND StsCobertura = 'SOL';

     UPDATE ENDOSOS
        SET StsEndoso  = 'EMI',
      FecSts     = TRUNC(SYSDATE)
      WHERE CodCia     = nCodCia
        AND IdPoliza   = nIdPoliza
        AND IdEndoso   = nIdEndoso
        AND TipoEndoso = 'AUM'
        AND StsEndoso  = 'SOL';

     GT_REA_DISTRIBUCION.DISTRIBUYE_REASEGURO(nCodCia, nCodEmpresa, nIdPoliza, nIdTrn, TRUNC(SYSDATE), 'ENDOSOS');
  END EMITIR_AUMENTO;

  FUNCTION VALIDA_ENDOSO(nCodCia NUMBER, nIdPoliza NUMBER, nIdEndoso NUMBER, cNaturalidad OUT VARCHAR2) RETURN VARCHAR2 IS
  nSumaAseg          ENDOSOS.Suma_Aseg_Local%TYPE;
  nSumaAsegCob       COBERTURAS.Suma_Asegurada_Local%TYPE;
  cTipoEndoso        ENDOSOS.TipoEndoso%TYPE;
  nIDetPol           ENDOSOS.IDetPol%TYPE;
  cStsEndoso         ENDOSOS.StsEndoso%TYPE;
  nIdTransaccion     TRANSACCION.IdTransaccion%TYPE;
  dFechaTransaccion  TRANSACCION.FechaTransaccion%TYPE;
  nCodEmpresa        ENDOSOS.CodEmpresa%TYPE;
  nSumaAsegAseg      COBERTURAS.Suma_Asegurada_Moneda%TYPE;
  nPrimaMoneda       COBERTURAS.Prima_Moneda%TYPE;
  cCodListaRef       CLIENTES.CodListaRef%TYPE;
  cDescListaRef      VALORES_DE_LISTAS.DescValLst%TYPE;
  dFecIniVig         ENDOSOS.FecIniVig%TYPE;
  Dummy              NUMBER(5);
  nRegis             NUMBER(6);
  cEmite             VARCHAR2(1);
  nExiste            NUMBER(5);
  nComprobantes      NUMBER(5);
  nFacturas          NUMBER(5);
  nNotasCred         NUMBER(5);
  nCantAseg          NUMBER(10);
  nEdad              NUMBER(5);
  cMensaje           VARCHAR2(300);                          --LAVDIN
  cPldstaprobada     POLIZAS.PLDSTAPROBADA%TYPE;             --LAVDIN
  W_ACTIVA_PLD       SAI_CAT_GENERAL.CAGE_VALOR_CORTO%TYPE;  --LAVDIN
  cIdTipoSeg         DETALLE_POLIZA.IdTipoSeg%TYPE;
  cPlanCob           DETALLE_POLIZA.PlanCob%TYPE;

  CURSOR ASEG_Q IS
     SELECT AC.IDetPol, AC.Cod_Asegurado, D.CodEmpresa,
      A.Tipo_Doc_Identificacion, A.Num_Doc_IDentificacion
       FROM ASEGURADO_CERTIFICADO AC, ASEGURADO A, DETALLE_POLIZA D
      WHERE D.CodCia        = AC.CodCia
        AND D.IDetPol       = AC.IDetPol
        AND D.IdPoliza      = AC.IdPoliza
        AND A.Cod_Asegurado = AC.Cod_Asegurado
        AND AC.IdEndoso     = nIdEndoso
        AND AC.IdPoliza     = nIdPoliza
        AND AC.CodCia       = nCodCia;
  BEGIN
     cEmite := 'N';

        BEGIN
            SELECT DISTINCT IdTipoSeg,PlanCob
            INTO cIdTipoSeg,cPlanCob
            FROM DETALLE_POLIZA DP,ENDOSOS E
            WHERE DP.CodCia   = nCodCia
            AND DP.IdPoliza = nIdPoliza
            AND E.IdEndoso = nIdEndoso
            AND DP.CodCia   = E.CodCia
            AND DP.IdPoliza = E.IdPoliza;
        END;

        BEGIN
            SELECT TipoEndoso,  IDetPol,  StsEndoso,  CodEmpresa,  FecIniVig,  nvl(Pldstaprobada,'N')  --LAVDIN
            INTO cTipoEndoso, nIDetPol, cStsEndoso, nCodEmpresa, dFecIniVig, cPldstaprobada          --LAVDIN
            FROM ENDOSOS
            WHERE CodCia   = nCodCia
            AND IdPoliza = nIdPoliza
            AND IdEndoso = nIdEndoso;
        END;

     IF OC_PLAN_COBERTURAS.VALIDA_DIAS_RETROACTIVOS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, dFecIniVig) = 'N' THEN
        IF OC_PROCESO_AUTORIZA_USUARIO.PROCESO_AUTORIZADO(nCodCia, '9145', USER, 'NOAPLI',1) = 'N' THEN
            RAISE_APPLICATION_ERROR(-20225,'La Configuración del Producto Sólo Tiene '||OC_PLAN_COBERTURAS.NUMERO_DIAS_RETROACTIVOS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob)||' Días de Retroactividad Por Favor Valide su Endoso '||TRIM(TO_CHAR(nIdEndoso)));
        END IF;
     END IF;

    BEGIN
        SELECT A.Valor
        INTO cNaturalidad
        FROM PROPIEDADES_VALORES A
        WHERE A.CodLista  = 'TIPENDOS'
        AND A.CodValor  = cTipoEndoso
        AND A.Propiedad = 'NATURALEZA';
    EXCEPTION
        WHEN OTHERS THEN
            cNaturalidad := ' ';
    END;
     --
     -- INICIA LAVDIN
     --
    BEGIN
        SELECT A.CAGE_VALOR_CORTO
        INTO W_ACTIVA_PLD
        FROM SAI_CAT_GENERAL A
        WHERE A.CAGE_CD_CATALOGO = 104
        AND A.CAGE_CD_CLAVE_SEG = 1
        AND A.CAGE_CD_CLAVE_TER = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            W_ACTIVA_PLD := 'N';
        WHEN TOO_MANY_ROWS THEN
            W_ACTIVA_PLD := 'N';
        WHEN OTHERS THEN
            W_ACTIVA_PLD := 'N';
    END;
     --
     IF cStsEndoso = 'PLD'  THEN
        RAISE_APPLICATION_ERROR(-20200,'El Endoso es PLD');
     END IF;
     --
     --TERMINA LAVDIN
     --
    IF cStsEndoso = 'EMI' AND cTipoEndoso NOT IN ('ESV', 'ESVTL', 'CLA','EAAF') THEN
        BEGIN
            SELECT COUNT(*)
            INTO nComprobantes
            FROM COMPROBANTES_CONTABLES
            WHERE CodCia          = nCodCia
            AND NumTransaccion IN (SELECT IdTransaccion
                                    FROM FACTURAS
                                    WHERE IdPoliza  = nIdPoliza
                                    AND IdEndoso  = nIdEndoso
                                    AND CodCia    = nCodCia
                                UNION
                                    SELECT IdTransaccion
                                    FROM NOTAS_DE_CREDITO
                                    WHERE IdPoliza  = nIdPoliza
                                    AND IdEndoso  = nIdEndoso
                                    AND CodCia    = nCodCia)
            AND FecEnvioSC IS NOT NULL;
        END;

        IF NVL(nComprobantes,0) != 0 THEN
            RAISE_APPLICATION_ERROR(-20225,'NO puede Revertir la Emisión del Endoso No. ' || TRIM(TO_CHAR(nIdEndoso)) ||
                                    ' porque sus Datos Contables ya fueron Enviados a Otros Sistemas');
        END IF;

        IF cNaturalidad = '+' THEN
            SELECT COUNT(*)
            INTO nExiste
            FROM FACTURAS
            WHERE CodCia      = nCodCia
            AND IdPoliza    = nIdPoliza
            AND IdEndoso    = nIdEndoso
            AND StsFact    != 'EMI';

            IF NVL(nExiste,0) != 0 THEN
                RAISE_APPLICATION_ERROR(-20225,'Facturas o Recibos del Endoso ya fueron Pagados o Anulados y NO Puede Revertirlo');
            ELSE
                SELECT MIN(F.IdTransaccion), MIN(TRUNC(T.FechaTransaccion))
                INTO nIdTransaccion, dFechaTransaccion
                FROM FACTURAS F, TRANSACCION T
                WHERE F.CodCia        = nCodCia
                AND F.IdPoliza      = nIdPoliza
                AND F.IdEndoso      = nIdEndoso
                AND T.IdTransaccion = F.IdTransaccion;

                IF TO_CHAR(dFechaTransaccion,'MM/YYYY') != TO_CHAR(TRUNC(SYSDATE),'MM/YYYY') THEN
                    RAISE_APPLICATION_ERROR(-20225,'NO Puede Revertir Endosos de Periodos Diferentes al Actual '|| TO_CHAR(TRUNC(SYSDATE),'MM/YYYY'));
                ELSE

                    BEGIN
                        SELECT COUNT(*)
                        INTO nFacturas
                        FROM FACTURAS
                        WHERE IdPoliza        = nIdPoliza
                        AND IdEndoso        = nIdEndoso  -- se agrego
                        AND CodCia          = nCodCia
                        AND FecEnvFactElec IS NOT NULL;
                    END;

                    IF NVL(nFacturas,0) != 0 THEN
                        RAISE_APPLICATION_ERROR(-20225,'NO puede Revertir la Emisión porque el Endoso No. ' || nIdEndoso ||
                                                    ' de la Póliza No. ' || TRIM(TO_CHAR(nIdPoliza)) ||
                                                    ' sus Datos ya fueron Enviados a Facturación Electrónica');
                    ELSE
                        cEmite  := 'S';
                    END IF;
                END IF;
            END IF;
        ELSE
            SELECT COUNT(*)
            INTO nExiste
            FROM NOTAS_DE_CREDITO
            WHERE CodCia      = nCodCia
            AND IdPoliza    = nIdPoliza
            AND IdEndoso    = nIdEndoso
            AND StsNcr     != 'EMI';

            IF NVL(nExiste,0) != 0 THEN
                RAISE_APPLICATION_ERROR(-20225,'Notas de Crédito del Endoso ya fueron Pagadas o Anuladas y NO Puede Revertirlo');
            ELSE
                SELECT MIN(N.IdTransaccion), MIN(TRUNC(T.FechaTransaccion))
                INTO nIdTransaccion, dFechaTransaccion
                FROM NOTAS_DE_CREDITO N, TRANSACCION T
                WHERE N.CodCia        = nCodCia
                AND N.IdPoliza      = nIdPoliza
                AND N.IdEndoso      = nIdEndoso
                AND T.IdTransaccion = N.IdTransaccion;

                IF TO_CHAR(dFechaTransaccion,'MM/YYYY') != TO_CHAR(TRUNC(SYSDATE),'MM/YYYY') THEN
                    RAISE_APPLICATION_ERROR(-20225,'NO Puede Revertir Endosos de Periodos Diferentes al Actual '|| TO_CHAR(TRUNC(SYSDATE),'MM/YYYY'));
                ELSE
                    BEGIN
                        SELECT COUNT(*)
                        INTO nNotasCred
                        FROM NOTAS_DE_CREDITO
                        WHERE IdPoliza        = nIdPoliza
                        AND CodCia          = nCodCia
                        AND FecEnvFactElec IS NOT NULL;
                    END;

                    IF NVL(nNotasCred,0) != 0 THEN
                        RAISE_APPLICATION_ERROR(-20225,'NO puede Revertir la Emisión porque el Endoso No. ' || nIdEndoso ||
                                                ' de la Póliza No. ' || TRIM(TO_CHAR(nIdPoliza)) ||
                                                ' sus Datos ya fueron Enviados a Facturación Electrónica');
                    ELSE
                        cEmite  := 'S';
                    END IF;
                END IF;
            END IF;
        END IF;
    ELSE
        --JIBARRA_07-11-2022 <SE AGREGA LA EXCLUSION DE [CFV], NO TIENE AFECATCION CONTABLE, SOLO ES AJUSTE DE FECHAS>
        IF cTipoEndoso NOT IN ('ESV', 'ESVTL','EXA','RSS','NSS','EAD','CFP','EAAF','CFV') THEN
            SELECT SUM(Suma_Aseg_Moneda)
            INTO nSumaAseg
            FROM ENDOSOS
            WHERE CodCia   = nCodCia
            AND IdPoliza = nIdPoliza
            AND IdEndoso = nIdEndoso;

            SELECT COUNT(*), NVL(SUM(SumaAseg_Moneda),0)
            INTO nRegis, nSumaAsegCob
            FROM COBERT_ACT
            WHERE CodCia   = nCodCia
            AND IdPoliza = nIdPoliza
            AND IdEndoso = nIdEndoso;

            SELECT COUNT(*) + nRegis, NVL(SUM(SumaAseg_Moneda),0) + nSumaAsegCob
            INTO nRegis, nSumaAsegCob
            FROM COBERT_ACT_ASEG
            WHERE CodCia   = nCodCia
            AND IdPoliza = nIdPoliza
            AND IdEndoso = nIdEndoso;

            nCantAseg := OC_DETALLE_POLIZA.TOTAL_ASEGURADOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol);
            SELECT COUNT(*) + nRegis, (NVL(SUM(Suma_Asegurada_Moneda),0) * nCantAseg) + nSumaAsegCob
            INTO nRegis, nSumaAsegCob
            FROM COBERTURAS
            WHERE CodCia   = nCodCia
            AND IdPoliza = nIdPoliza
            AND IdEndoso = nIdEndoso;

            IF NVL(nRegis,0) > 0 THEN
                IF NVL(nSumaAsegCob,0) = NVL(nSumaAseg,0) THEN
                    cEmite := 'S';
                ELSE
                    RAISE_APPLICATION_ERROR(-20225,'Suma Asegurada de Coberturas no coincide con Suma Asegurada del Endoso');
                END IF;
            ELSE
                RAISE_APPLICATION_ERROR(-20225,'Debe grabarle Coberturas al Endoso');
            END IF;

            IF OC_ASEGURADO_CERTIFICADO.TIENE_ASEGURADOS(nCodCia, nIdPoliza, nIDetPol, nIdEndoso) = 'S' THEN
                --   --LAVDIN   INI
                /*IF cPldstaprobada = 'N' AND W_ACTIVA_PLD = 'S' THEN
                    OC_ADMON_RIESGO.VALIDA_PERSONAS_ENDOSO(nCodCia,nIdPoliza,nIdEndoso,cMensaje);
                    IF cMensaje IS NOT NULL THEN
                        RAISE_APPLICATION_ERROR(-20200,cMensaje);
                    END IF;
                    
                END IF;*/
                --  --LAVDIN   FIN
                FOR W IN ASEG_Q LOOP
                    /*
                    IF OC_PERSONA_NATURAL_JURIDICA.EN_LISTA_DE_REFERENCIA(W.Tipo_Doc_Identificacion, W.Num_Doc_Identificacion) = 'S' THEN
                    cCodListaRef  := OC_PERSONA_NATURAL_JURIDICA.CODIGO_LISTA_REFERENCIA(W.Tipo_Doc_Identificacion, W.Num_Doc_Identificacion);
                    cDescListaRef := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('LISTAREF', cCodListaRef);
                    RAISE_APPLICATION_ERROR(-20200,'Código de Asegurado ' || W.Cod_Asegurado ||
                    ' Está en Lista de Referencia por: ' || cCodListaRef || '-' ||
                    cDescListaRef || ' - NO Puede Emitirle Endoso');
                    END IF;
                    */
                    nEdad   := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, W.CodEmpresa, W.Cod_Asegurado, dFecIniVig);

                    SELECT COUNT(*)
                    INTO nRegis
                    FROM COBERT_ACT_ASEG C, COBERTURAS_DE_SEGUROS CS
                    WHERE CS.Edad_Maxima  < nEdad
                    AND CS.CodCobert    = C.CodCobert
                    AND CS.PlanCob      = C.PlanCob
                    AND CS.IdTipoSeg    = C.IdTipoSeg
                    AND CS.CodEmpresa   = C.CodEmpresa
                    AND CS.CodCia       = C.CodCia
                    AND C.IdEndoso      = nIdEndoso
                    AND C.IdPoliza      = nIdPoliza
                    AND C.IDetPol       = W.IDetPol
                    AND C.Cod_Asegurado = W.Cod_Asegurado
                    AND C.CodCia        = nCodCia;

                    IF nRegis != 0 THEN
                        RAISE_APPLICATION_ERROR(-20200,'El Asegurado No. ' || W.Cod_Asegurado || ' del Certificado No. ' || W.IDetPol ||
                                                ' en el Endoso ' || nIdEndoso || ' Posee Coberturas fuera el Rango de Aceptación para la Edad ' || nEdad);
                    END IF;

                    SELECT NVL(SUM(SumaAseg_Moneda),0)--, NVL(SUM(Prima_Moneda),0)
                    INTO nSumaAsegAseg--, nPrimaMoneda
                    FROM COBERT_ACT_ASEG C, COBERTURAS_DE_SEGUROS CS
                    WHERE CS.Cobertura_Basica = 'S'
                    AND CS.CodCobert        = C.CodCobert
                    AND CS.PlanCob          = C.PlanCob
                    AND CS.IdTipoSeg        = C.IdTipoSeg
                    AND CS.CodEmpresa       = C.CodEmpresa
                    AND CS.CodCia           = C.CodCia
                    AND C.IdEndoso          = nIdEndoso
                    AND C.IdPoliza          = nIdPoliza
                    AND C.IDetPol           = W.IDetPol
                    AND C.Cod_Asegurado     = W.Cod_Asegurado
                    AND C.CodCia            = nCodCia;

                    IF NVL(nSumaAsegAseg,0) = 0 THEN --AND NVL(nPrimaMoneda,0) = 0 THEN
                        RAISE_APPLICATION_ERROR(-20200,'El Asegurado No. ' || W.Cod_Asegurado || ' del Certificado No. ' || W.IDetPol ||
                                                ' en el Endoso ' || nIdEndoso || ' NO tiene Suma Asegurada en Cobertura Básica');
                    END IF;
                END LOOP;
            END IF;
        ELSIF cTipoEndoso = 'EXA' THEN
            IF OC_ASEGURADO_CERTIFICADO.TIENE_ASEGURADOS(nCodCia, nIdPoliza, nIDetPol, nIdEndoso) = 'N' THEN
                RAISE_APPLICATION_ERROR(-20225,'No ha Seleccionado Asegurados para Excluirlos');
            ELSE
                cEmite := 'S';
            END IF;
        ELSE
            cEmite := 'S';
        END IF;
     END IF;

     RETURN(cEmite);

  END VALIDA_ENDOSO;

  PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, nIdEndoso NUMBER,
       cTipoEndoso VARCHAR2, dFecAnul DATE, cMotivAnul VARCHAR2) IS
  nPrima_Neta_Moneda  ENDOSOS.Prima_Neta_Moneda%TYPE;
  nEndoso             ENDOSOS.IdEndoso%TYPE;
  nIdTrn              TRANSACCION.IdTransaccion%TYPE;
  cNaturalidad        PROPIEDADES_VALORES.Valor%TYPE;
  cSubProceso         SUB_PROCESO.CodSubProceso%TYPE;
  nNaturalidad        NUMBER;
  cExiste             VARCHAR2(1);
  nExisteSini         NUMBER(10);
  nAsegNoEmitidos     NUMBER(10);

  CURSOR COBERT_Q IS
     SELECT IDetPol, CodCobert, Suma_Asegurada_Local, Suma_Asegurada_Moneda,
      Tasa, Prima_Local, Prima_Moneda
       FROM COBERTURAS
      WHERE CodCia   = nCodCia
        AND IdPoliza = nIdPoliza
        AND IdEndoso = nIdEndoso;
  CURSOR NCR_Q IS
     SELECT IdNcr, Monto_Ncr_Moneda
       FROM NOTAS_DE_CREDITO
      WHERE CodCia    = nCodCia
        AND IdPoliza  = nIdPoliza
        AND IDetPol   = nIDetPol
        AND IdEndoso  = nIdEndoso
        AND StsNcr   IN ('EMI','XEM');
  CURSOR FACT_Q IS
     SELECT IdFactura, CodCobrador, Monto_Fact_Moneda
       FROM FACTURAS
      WHERE CodCia    = nCodCia
        AND IdPoliza  = nIdPoliza
        AND IDetPol   = nIDetPol
        AND IdEndoso  = nIdEndoso
        AND StsFact   IN ('EMI','XEM');
  CURSOR ASEG_EXC_Q IS
     SELECT IDetPol, Cod_Asegurado
       FROM ASEGURADO_CERTIFICADO
      WHERE CodCia        = nCodCia
        AND IdPoliza      = nIdPoliza
        AND IdEndosoExclu = nIdEndoso
        AND Estado        = 'CEX';
  CURSOR ASEG_EMI_Q IS
     SELECT DISTINCT IDetPol
       FROM ASEGURADO_CERTIFICADO
      WHERE CodCia    = nCodCia
        AND IdPoliza  = nIdPoliza
        AND IdEndoso  = nIdEndoso
        AND Estado    = 'EMI';
  BEGIN
     nIdTrn := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 8, cTipoEndoso);

     cNaturalidad := OC_ENDOSO.NATURALIDAD(cTipoEndoso);

     IF cNaturalidad = '-' THEN
        nNaturalidad := 1;
     ELSE
        nNaturalidad := -1;
     END IF;

     IF cTipoEndoso = 'NSS' THEN
        cSubProceso  := 'ANUNCR';
     ELSIF cTipoEndoso = 'RSS' THEN
        cSubProceso  := 'ANUFAC';
     ELSE
        FOR W IN FACT_Q LOOP
     cSubProceso := 'ANUFAC';
     EXIT;
        END LOOP;

        IF cSubProceso IS NULL THEN
     cSubProceso  := 'ANUNCR';
        END IF;
     END IF;

     UPDATE ENDOSOS
        SET StsEndoso = 'ANU',
      FecSts    = dFecAnul,
      FecAnul   = dFecAnul,
      MotivAnul = cMotivAnul
      WHERE CodCia    = nCodCia
        AND IdPoliza  = nIdPoliza
        AND IdEndoso  = nIdEndoso;

     UPDATE COBERTURAS
        SET StsCobertura = 'ANU'
      WHERE CodCia    = nCodCia
        AND IdPoliza  = nIdPoliza
        AND IDetPol   = nIDetPol
        AND IdEndoso  = nIdEndoso;

     SELECT NVL(SUM(Prima_Neta_Moneda),0)
       INTO nPrima_Neta_Moneda
       FROM ENDOSOS
      WHERE CodCia   = nCodCia
        AND IdPoliza = nIdPoliza
        AND IdEndoso = nIdEndoso;


     OC_DETALLE_TRANSACCION.CREA(nIdTrn, nCodCia, nCodEmpresa, 8, cSubProceso, 'ENDOSOS',
               nIdPoliza, nIDetPol, nIdEndoso, NULL, nPrima_Neta_Moneda);

     FOR W IN FACT_Q LOOP
        OC_FACTURAS.ANULAR(nCodCia, W.IdFactura, dFecAnul, cMotivAnul, W.CodCobrador, nIdTrn);
        OC_DETALLE_TRANSACCION.CREA(nIdTrn, nCodCia, nCodEmpresa, 8, 'FAC', 'FACTURAS',
            nIdPoliza, nIDetPol, nIdEndoso, W.IdFactura, W.Monto_Fact_Moneda);
     END LOOP;

     FOR X IN NCR_Q LOOP
        OC_NOTAS_DE_CREDITO.ANULAR(X.IdNcr, dFecAnul, cMotivAnul, nIdTrn);
        OC_DETALLE_TRANSACCION.CREA(nIdTrn, nCodCia, nCodEmpresa, 8, 'NCR', 'NOTAS_DE_CREDITO',
            nIdPoliza, nIDetPol, nIdEndoso, X.IdNcr, X.Monto_Ncr_Moneda);
     END LOOP;

     IF cTipoEndoso = 'EXA' THEN
        -- Deja Emitidas las Coberturas, Asistencias y Asegurados
        UPDATE COBERT_ACT_ASEG
     SET StsCobertura   = 'EMI'
         WHERE CodCia         = nCodCia
     AND IdPoliza       = nIdPoliza
     AND Cod_Asegurado IN (SELECT Cod_Asegurado
           FROM ASEGURADO_CERTIFICADO
          WHERE CodCia        = nCodCia
            AND IdPoliza      = nIdPoliza
            AND IdEndosoExclu = nIdEndoso
            AND Estado        = 'CEX');

        UPDATE ASISTENCIAS_ASEGURADO
     SET StsAsistencia  = 'EMITID',
         FecSts         = TRUNC(SYSDATE)
         WHERE CodCia         = nCodCia
     AND IdPoliza       = nIdPoliza
     AND Cod_Asegurado IN (SELECT Cod_Asegurado
           FROM ASEGURADO_CERTIFICADO
          WHERE CodCia        = nCodCia
            AND IdPoliza      = nIdPoliza
            AND IdEndosoExclu = nIdEndoso
            AND Estado        = 'CEX');

        FOR W IN ASEG_EXC_Q LOOP
     OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol, W.Cod_Asegurado);
     OC_ASEGURADO_CERTIFICADO.ACTUALIZA_ASISTENCIAS(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol, W.Cod_Asegurado);
     OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, W.IDetPol, 0);
        END LOOP;

        UPDATE ASEGURADO_CERTIFICADO
     SET Estado         = 'EMI',
         IdEndosoExclu  = 0,
         FecAnulExclu   = NULL,
         MotivAnulExclu = NULL
         WHERE CodCia        = nCodCia
     AND IdPoliza      = nIdPoliza
     AND IdEndosoExclu = nIdEndoso
     AND Estado        = 'CEX';

        OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);
     ELSIF cTipoEndoso = 'INA' THEN
        SELECT COUNT(*)
    INTO nExisteSini
    FROM SINIESTRO
         WHERE CodCia         = nCodCia
     AND IdPoliza       = nIdPoliza
     AND Cod_Asegurado IN (SELECT Cod_Asegurado
           FROM ASEGURADO_CERTIFICADO
          WHERE CodCia     = nCodCia
            AND IdPoliza   = nIdPoliza
            AND IdEndoso   = nIdEndoso
            AND Estado     = 'EMI');

        IF NVL(nExisteSini,0) > 0 THEN
     RAISE_APPLICATION_ERROR(-20225,'No se Puede Anular el Endoso de Inclusión de Asegurados No. ' || nIdEndoso ||
           ' Porque algún asegurado de este Endoso Tiene Siniestro');
        ELSE
     SELECT COUNT(*)
       INTO nAsegNoEmitidos
       FROM ASEGURADO_CERTIFICADO
      WHERE CodCia      = nCodCia
        AND IdPoliza    = nIdPoliza
        AND IdEndoso    = nIdEndoso
        AND Estado     != 'EMI';

     IF NVL(nAsegNoEmitidos,0) != 0 THEN
        RAISE_APPLICATION_ERROR(-20225,'No se Puede Anular el Endoso de Inclusión de Asegurados No. ' || nIdEndoso ||
              ' Porque algún Asegurado ya fue Excluido o Cambiado con Otro Endoso');
     ELSE
        -- Deja Emitidas las Coberturas, Asistencias y Asegurados
        -- BORRAR ESTE PARRAFO CUENDO LO DE ENDOSO DE INCLUSION ESTE YA MADURO
  /*    -- INICIO ENDOINA
        DELETE COBERT_ACT_ASEG
         WHERE CodCia         = nCodCia
           AND IdPoliza       = nIdPoliza
           AND Cod_Asegurado IN (SELECT Cod_Asegurado
                 FROM ASEGURADO_CERTIFICADO
                WHERE CodCia     = nCodCia
            AND IdPoliza   = nIdPoliza
            AND IdEndoso   = nIdEndoso
            AND Estado     = 'EMI');

        DELETE ASISTENCIAS_ASEGURADO
         WHERE CodCia         = nCodCia
           AND IdPoliza       = nIdPoliza
           AND Cod_Asegurado IN (SELECT Cod_Asegurado
                 FROM ASEGURADO_CERTIFICADO
                WHERE CodCia    = nCodCia
            AND IdPoliza  = nIdPoliza
            AND IdEndoso  = nIdEndoso
            AND Estado    = 'EMI');

        FOR W IN ASEG_EMI_Q LOOP
           OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, W.IDetPol, 0);
        END LOOP;

        DELETE ASEGURADO_CERTIFICADO
         WHERE CodCia    = nCodCia
           AND IdPoliza  = nIdPoliza
           AND IdEndoso  = nIdEndoso
           AND Estado    = 'EMI';

        OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);
  */  -- FIN ENDOINA

  -- INICIO ENDOINA
        UPDATE COBERT_ACT_ASEG
           SET StsCobertura = 'ANU'
         WHERE CodCia         = nCodCia
           AND IdPoliza       = nIdPoliza
           AND Cod_Asegurado IN (SELECT Cod_Asegurado
                 FROM ASEGURADO_CERTIFICADO
                WHERE CodCia     = nCodCia
            AND IdPoliza   = nIdPoliza
            AND IdEndoso   = nIdEndoso
            AND Estado     = 'EMI');

        UPDATE ASISTENCIAS_ASEGURADO
           SET StsAsistencia = 'ANULAD'
         WHERE CodCia         = nCodCia
           AND IdPoliza       = nIdPoliza
           AND Cod_Asegurado IN (SELECT Cod_Asegurado
                 FROM ASEGURADO_CERTIFICADO
                WHERE CodCia    = nCodCia
            AND IdPoliza  = nIdPoliza
            AND IdEndoso  = nIdEndoso
            AND Estado    = 'EMI');

        FOR W IN ASEG_EMI_Q LOOP
           OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, W.IDetPol, 0);
        END LOOP;

        UPDATE ASEGURADO_CERTIFICADO
           SET ESTADO  = 'ANU',
         CAMPO93 = 'OC_ENDOSO,'||TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS')||','||USER||','||USERENV('TERMINAL')
         WHERE CodCia    = nCodCia
           AND IdPoliza  = nIdPoliza
           AND IdEndoso  = nIdEndoso
           AND Estado    = 'EMI';

        OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);
  -- FIN ENDOINA

     END IF;
        END IF;
     END IF;

     /*FOR X IN COBERT_Q LOOP
        BEGIN
     SELECT 'S'
       INTO cExiste
       FROM COBERTURAS
      WHERE CodCia    = nCodCia
        AND IdPoliza  = nIdPoliza
        AND IdEndoso  = NVL(nEndoso,0)
        AND CodCobert = X.CodCobert;

     UPDATE COBERT_ACT
        SET SumaAseg_Local  = NVL(SumaAseg_Local,0) + (X.Suma_Asegurada_Local * nNaturalidad) ,
      SumaAseg_Moneda = NVL(SumaAseg_Moneda,0) + (X.Suma_Asegurada_Moneda * nNaturalidad),
      Tasa            = NVL(Prima_Local,0) + (X.Prima_Local* nNaturalidad) /
            NVL(SumaAseg_Local,0) + (X.Suma_Asegurada_Local * nNaturalidad),
      Prima_Local     = NVL(Prima_Local,0) + (X.Prima_Local* nNaturalidad),
      Prima_Moneda    = NVL(Prima_Moneda,0) + (X.Prima_Moneda * nNaturalidad)
      WHERE CodCia    = nCodCia
        AND IdPoliza  = nIdPoliza
        AND IDetPol   = X.IDetPol
        AND CodCobert = X.CodCobert;
        EXCEPTION
     WHEN NO_DATA_FOUND THEN
        DELETE COBERT_ACT
         WHERE CodCia    = nCodCia
           AND IdPoliza  = nIdPoliza
           AND IDetPol   = X.IDetPol
           AND CodCobert = X.CodCobert;
        END;
     END LOOP;
     OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIDetPol, 0);
     OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);*/

     OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTrn, 'C');
  END ANULAR;

  PROCEDURE ACTUALIZA_VALORES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) IS
  nSumaLocal          COBERTURAS.Suma_Asegurada_Local%TYPE;
  nSumaMoneda         COBERTURAS.Suma_Asegurada_Moneda%TYPE;
  nPrimaLocal         COBERTURAS.Prima_Local%TYPE;
  nPrimaMoneda        COBERTURAS.Prima_Moneda%TYPE;
  nMontoAsistLocal    ASISTENCIAS_ASEGURADO.MontoAsistLocal%TYPE;
  nMontoAsistMoneda   ASISTENCIAS_ASEGURADO.MontoAsistMoneda%TYPE;
  wTIPOENDOSO         ENDOSOS.TIPOENDOSO%TYPE;
  BEGIN
     SELECT NVL(SUM(SumaAseg_Local),0), NVL(SUM(SumaAseg_Moneda),0),
      NVL(SUM(Prima_Local),0), NVL(SUM(Prima_Moneda),0)
       INTO nSumaLocal, nSumaMoneda,
      nPrimaLocal, nPrimaMoneda
       FROM COBERT_ACT
      WHERE CodCia        = nCodCia
        AND IdPoliza      = nIdPoliza
        --AND IDetPol       = nIDetPol
        AND IdEndoso      = nIdEndoso
        AND StsCobertura IN ('EMI','SOL','XRE');

     SELECT NVL(SUM(MontoAsistLocal),0), NVL(SUM(MontoAsistMoneda),0)
       INTO nMontoAsistLocal, nMontoAsistMoneda
       FROM ASISTENCIAS_DETALLE_POLIZA
      WHERE CodCia          = nCodCia
        AND IdPoliza        = nIdPoliza
        AND IdEndoso        = nIdEndoso
        --AND IDetPol        = nIDetPol
        AND StsAsistencia NOT IN ('EXCLUI');

     SELECT NVL(SUM(SumaAseg_Local),0) + NVL(nSumaLocal,0), NVL(SUM(SumaAseg_Moneda),0) + NVL(nSumaMoneda,0),
      NVL(SUM(Prima_Local),0) + NVL(nPrimaLocal,0), NVL(SUM(Prima_Moneda),0) + NVL(nPrimaMoneda,0)
       INTO nSumaLocal, nSumaMoneda,
      nPrimaLocal, nPrimaMoneda
       FROM COBERT_ACT_ASEG
      WHERE CodCia        = nCodCia
        AND IdPoliza      = nIdPoliza
        --AND IDetPol       = nIDetPol
        AND IdEndoso      = nIdEndoso
        AND StsCobertura IN ('EMI','SOL','XRE');

     SELECT NVL(SUM(MontoAsistLocal),0) + NVL(nMontoAsistLocal,0),
      NVL(SUM(MontoAsistMoneda),0) + NVL(nMontoAsistMoneda,0)
       INTO nMontoAsistLocal, nMontoAsistMoneda
       FROM ASISTENCIAS_ASEGURADO
      WHERE CodCia          = nCodCia
        AND IdPoliza        = nIdPoliza
        --AND IDetPol        = nIDetPol
        AND IdEndoso        = nIdEndoso
        AND StsAsistencia NOT IN ('EXCLUI');

     SELECT L.TIPOENDOSO
       INTO wTIPOENDOSO
       FROM ENDOSOS L
      WHERE L.CodCia   = nCodCia
        AND L.IdPoliza = nIdPoliza
      --AND IDetPol   = nIDetPol
        AND L.IdEndoso   = nIdEndoso;

     IF wTIPOENDOSO NOT IN ('ESV','ESVTL') THEN
        UPDATE ENDOSOS
     SET Suma_Aseg_Local   = NVL(nSumaLocal,0),
         Suma_Aseg_Moneda  = NVL(nSumaMoneda,0),
         Prima_Neta_Local  = NVL(nPrimaLocal,0) + NVL(nMontoAsistLocal,0),
         Prima_Neta_Moneda = NVL(nPrimaMoneda,0) + NVL(nMontoAsistMoneda,0)
         WHERE CodCia    = nCodCia
     AND IdPoliza  = nIdPoliza
         --AND IDetPol   = nIDetPol
     AND IdEndoso  = nIdEndoso;
     END IF;
  EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20225,'Error general en ACTUALIZA_VALORES:   '||SQLERRM);
  END ACTUALIZA_VALORES;

   PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, nIdEndoso NUMBER, cTipoEndoso VARCHAR2) IS
      dFecHoy              DATE  := TRUNC(SYSDATE);
      nRegis               NUMBER(6);
      nSumaAseg            NUMBER(14,2);
      cNaturalidad         VARCHAR2(1);
      nPrima_Neta_Moneda   ENDOSOS.Prima_Neta_Moneda%TYPE;
      nIdTransaccion       TRANSACCION.IdTransaccion%TYPE;
      dFechaTransaccion    TRANSACCION.FechaTransaccion%TYPE;

      /*CURSOR COBERT_Q IS
       SELECT IdPoliza, CodCobert, Suma_Asegurada_Local, Suma_Asegurada_Moneda,
        Tasa, Prima_Local, Prima_Moneda
         FROM COBERTURAS
        WHERE IdPoliza = nIdPoliza
         AND IDetPol  = nIDetPol
         AND IdEndoso = nIdEndoso;*/
      CURSOR FACT_Q IS
         SELECT IdFactura
         FROM FACTURAS
         WHERE IdPoliza = nIdPoliza
         AND IDetPol  = nIDetPol
         AND IdEndoso = nIdEndoso;

      CURSOR NCR_Q IS
         SELECT IdNcr
         FROM NOTAS_DE_CREDITO
         WHERE IdPoliza = nIdPoliza
         AND IDetPol  = nIDetPol
         AND IdEndoso = nIdEndoso;

      CURSOR ASEG_Q IS
         SELECT Cod_Asegurado
         FROM ASEGURADO_CERTIFICADO
         WHERE CodCia   = nCodCia
         AND IdPoliza = nIdPoliza
         AND IDetPol  = nIDetPol
         AND IdEndoso = nIdEndoso;
   BEGIN
      IF OC_ENDOSO.VALIDA_ENDOSO(nCodCia, nIdPoliza, nIdEndoso, cNaturalidad) = 'S' THEN
         IF cNaturalidad = '+' THEN
            SELECT MIN(F.IdTransaccion), MIN(TRUNC(T.FechaTransaccion))
            INTO nIdTransaccion, dFechaTransaccion
            FROM FACTURAS F, TRANSACCION T
            WHERE F.CodCia        = nCodCia
            AND F.IdPoliza      = nIdPoliza
            AND F.IdEndoso      = nIdEndoso
            AND T.IdTransaccion = F.IdTransaccion;
         ELSE
            SELECT MIN(N.IdTransaccion), MIN(TRUNC(T.FechaTransaccion))
            INTO nIdTransaccion, dFechaTransaccion
            FROM NOTAS_DE_CREDITO N, TRANSACCION T
            WHERE N.CodCia        = nCodCia
            AND N.IdPoliza      = nIdPoliza
            AND N.IdEndoso      = nIdEndoso
            AND T.IdTransaccion = N.IdTransaccion;
         END IF;

         UPDATE ENDOSOS
         SET StsEndoso = 'SOL',
            FecSts    = dFecHoy
         WHERE IdPoliza = nIdPoliza
         AND IDetPol  = nIDetPol
         AND IdEndoso = nIdEndoso;

         IF OC_ASEGURADO_CERTIFICADO.TIENE_ASEGURADOS(nCodCia, nIdPoliza, nIDetPol, nIdEndoso) = 'N' THEN
            OC_COBERT_ACT.REVERTIR_EMISION(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
            OC_ASISTENCIAS_DETALLE_POLIZA.REVERTIR_EMISION(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdEndoso);
         ELSE
            FOR W IN ASEG_Q LOOP
               OC_COBERT_ACT_ASEG.REVERTIR_EMISION(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, W.Cod_Asegurado, nIdEndoso);
               OC_ASISTENCIAS_ASEGURADO.REVERTIR_EMISION(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, W.Cod_Asegurado, nIdEndoso);
               OC_ASEGURADO_CERTIFICADO.REVERTIR_EMISION(nCodCia, nIdPoliza, nIDetPol, W.Cod_Asegurado, nIdEndoso);
            END LOOP;
         END IF;

        /*IF cTipoEndoso NOT IN ('ESV','ESVTL','CLA') THEN
     FOR X IN COBERT_Q LOOP
        SELECT NVL(COUNT(*),0)
          INTO nRegis
          FROM COBERT_ACT
         WHERE IdPoliza  = nIdPoliza
           AND IDetPol   = nIDetPol
           AND CodCobert = X.CodCobert;

        IF NVL(nRegis,0) > 0 THEN
           SELECT NVL(SumaAseg_Local,0)
       INTO nSumaAseg
       FROM COBERT_ACT
      WHERE IdPoliza  = nIdPoliza
        AND IDetPol   = nIDetPol
        AND CodCobert = X.CodCobert;
           IF cTipoEndoso = 'EXC' THEN
        UPDATE COBERT_ACT
           SET SumaAseg_Local  = NVL(SumaAseg_Local,0) + X.Suma_Asegurada_Local,
         SumaAseg_Moneda = NVL(SumaAseg_Moneda,0) + X.Suma_Asegurada_Moneda,
         Tasa            = X.Tasa,
         Prima_Local     = NVL(Prima_Local,0)  +  X.Prima_Local,
         Prima_Moneda    = NVL(Prima_Moneda,0) + X.Prima_Moneda,
         StsCobertura    = 'EMI'
         WHERE IdPoliza   = nIdPoliza
           AND IDetPol    = nIDetPol
           AND CodCobert  = X.CodCobert;

        DELETE DETALLE_NOTAS_DE_CREDITO
         WHERE IdNcr  IN (SELECT IdNcr
                FROM NOTAS_DE_CREDITO
               WHERE IdPoliza = nIdPoliza
                 AND IDetPol  = nIDetPol
                 AND IdEndoso = nIdEndoso);

        DELETE NOTAS_DE_CREDITO
         WHERE IdPoliza = nIdPoliza
           AND IDetPol  = nIDetPol
           AND IdEndoso = nIdEndoso;
           END IF;
        END IF;
     END LOOP;*/

         OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIDetPol, nIdEndoso);
         OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIdEndoso);

         IF cNaturalidad = '+' THEN
            FOR X IN FACT_Q LOOP
               DELETE DETALLE_COMISION
               WHERE IdComision IN (SELECT IdComision
                              FROM COMISIONES
                              WHERE IdFactura = X.IdFactura);

               DELETE COMISIONES
               WHERE IdFactura = X.IdFactura;

               DELETE DETALLE_FACTURAS
               WHERE IdFactura = X.IdFactura;

               DELETE FACTURAS
               WHERE IdFactura = X.IdFactura;

               DELETE DETALLE_ENDOSO
               WHERE IdFactura = X.IdFactura;
            END LOOP;
         ELSE
            FOR X IN NCR_Q LOOP
               DELETE DETALLE_COMISION
               WHERE IdComision IN (SELECT IdComision
                              FROM COMISIONES
                              WHERE IdNcr = X.IdNcr);

               DELETE COMISIONES
               WHERE IdNcr = X.IdNcr;

               DELETE DETALLE_NOTAS_DE_CREDITO
               WHERE IdNcr = X.IdNcr;

               DELETE NOTAS_DE_CREDITO
               WHERE IdNcr = X.IdNcr;
            END LOOP;
         END IF;

         -- Elimina Comprobantes y Transacción
         DELETE COMPROBANTES_DETALLE
         WHERE NumComprob IN (SELECT NumComprob
                        FROM COMPROBANTES_CONTABLES
                        WHERE NumTransaccion = nIdTransaccion);

         DELETE COMPROBANTES_CONTABLES
         WHERE NumTransaccion = nIdTransaccion;

         DELETE DETALLE_TRANSACCION
         WHERE IdTransaccion = nIdTransaccion;

         DELETE TRANSACCION
         WHERE IdTransaccion = nIdTransaccion;
         --END IF;
      END IF;
   END REVERTIR_EMISION;

  PROCEDURE CALCULA_EXCLUSION_ASEG(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndosoExclu NUMBER) IS
  cCod_Moneda         POLIZAS.Cod_Moneda%TYPE;
  dFecFinVig          DETALLE_POLIZA.FecFinVig%TYPE;
  dFecIniVig          DETALLE_POLIZA.FecIniVig%TYPE;
  nPrima_Neta_Local   ENDOSOS.Prima_Neta_Local%TYPE;
  nPrima_Neta_Moneda  ENDOSOS.Prima_Neta_Moneda%TYPE;
  nSuma_Aseg_Local    ENDOSOS.Suma_Aseg_Local%TYPE;
  nSuma_Aseg_Moneda   ENDOSOS.Suma_Aseg_Moneda%TYPE;
  nTasaCambio         TASAS_CAMBIO.Tasa_Cambio%TYPE;
  nCod_Asegurado      ASEGURADO_CERTIFICADO.Cod_Asegurado%TYPE;
  nIDetPolAseg        ASEGURADO_CERTIFICADO.IDetPol%TYPE;
  nFactProrrata       NUMBER(11,8);
  CURSOR ASEG_Q IS
     SELECT A.Cod_Asegurado, A.PrimaNeta, A.PrimaNeta_Moneda, A.IdEndoso,
      A.FecAnulExclu, A.SumaAseg, A.SumaAseg_Moneda, D.FecIniVig, D.FecFinVig, D.IDetPol
       FROM ASEGURADO_CERTIFICADO A, DETALLE_POLIZA D
      WHERE A.CodCia        = nCodCia
        AND A.IdPoliza      = nIdPoliza
        AND A.IdEndosoExclu = nIdEndosoExclu
        AND A.FecAnulExclu IS NOT NULL
        AND D.CodCia        = A.CodCia
        AND D.IdPoliza      = A.IdPoliza
        AND D.IDetPol       = A.IDetPol;
  CURSOR COB_Q IS
     SELECT CodCia, CodEmpresa, IdPoliza, IdetPol, IdTipoSeg, CodCobert,
      SumaAseg_Local, SumaAseg_Moneda, Tasa, Prima_Local,
      Prima_Moneda, IdEndoso, StsCobertura, Plancob, Cod_Asegurado
       FROM COBERT_ACT_ASEG
      WHERE CodCia        = nCodCia
        AND CodEmpresa    = nCodEmpresa
        AND IdPoliza      = nIdPoliza
        AND IDetPol       = nIDetPolAseg
        AND Cod_Asegurado = nCod_Asegurado
        AND StsCobertura  NOT IN ('ANU', 'CEX');

  CURSOR ASIST_Q IS
     SELECT CodCia, CodEmpresa, IdPoliza, IdetPol, Cod_Asegurado, StsAsistencia,
      CodAsistencia, CodMoneda, MontoAsistLocal, MontoAsistMoneda
       FROM ASISTENCIAS_ASEGURADO
      WHERE CodCia        = nCodCia
        AND CodEmpresa    = nCodEmpresa
        AND IdPoliza      = nIdPoliza
        AND IDetPol       = nIDetPolAseg
        AND Cod_Asegurado = nCod_Asegurado
        AND StsAsistencia NOT IN ('EXCLUI','ANULAD');
  BEGIN
     BEGIN
        SELECT Cod_Moneda
    INTO cCod_Moneda
    FROM POLIZAS
         WHERE CodCia   = nCodCia
     AND IdPoliza = nIdPoliza;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-20225,'NO Existe Póliza NO. '||nIdPoliza);
     END;

     FOR W IN ASEG_Q LOOP
        nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(W.FecAnulExclu));
        IF W.IdEndoso != 0 THEN
     BEGIN
        SELECT FecIniVig, FecFinVig
          INTO dFecIniVig, dFecFinVig
          FROM ENDOSOS
         WHERE CodCia     = nCodCia
           AND IdPoliza   = nIdPoliza
           AND IdEndoso   = W.IdEndoso;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
           dFecIniVig  := W.FecIniVig;
           dFecFinVig  := W.FecFinVig;
     END;
        ELSE
     dFecIniVig  := W.FecIniVig;
     dFecFinVig  := W.FecFinVig;
        END IF;
        nFactProrrata      := OC_GENERALES.PRORRATA(dFecIniVig, dFecFinVig, W.FecAnulExclu);
        nPrima_Neta_Moneda := NVL(nPrima_Neta_Moneda,0) + (NVL(W.PrimaNeta_Moneda,0) * nFactProrrata);
        nPrima_Neta_Local  := NVL(nPrima_Neta_Local,0) + ((NVL(W.PrimaNeta_Moneda,0) * nFactProrrata) * nTasaCambio);
        nSuma_Aseg_Local   := NVL(nSuma_Aseg_Local,0) + NVL(W.SumaAseg,0);
        nSuma_Aseg_Moneda  := NVL(nSuma_Aseg_Moneda,0) + NVL(W.SumaAseg_Moneda,0);
        nCod_Asegurado     := W.Cod_Asegurado;
        nIDetPolAseg       := W.IDetPol;
        FOR Z IN COB_Q LOOP
     BEGIN
        INSERT INTO COBERTURA_ASEG
        (CodCia, CodEmpresa, IdPoliza, IdetPol, IdTipoSeg, CodCobert,
         Suma_Asegurada_Local, Suma_Asegurada_Moneda, Tasa, Prima_Local,
         Prima_Moneda, IdEndoso, StsCobertura, Plancob, Cod_Asegurado)
        VALUES(Z.CodCia, Z.CodEmpresa, Z.IdPoliza, Z.IdetPol, Z.IdTipoSeg, Z.CodCobert,
         Z.SumaAseg_Local, Z.SumaAseg_Moneda, Z.Tasa, Z.Prima_Local * nFactProrrata,
         Z.Prima_Moneda * nFactProrrata, nIdEndosoExclu, Z.StsCobertura, Z.Plancob, Z.Cod_Asegurado);
     EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
           UPDATE COBERTURA_ASEG
        SET Prima_Local  = Z.Prima_Local * nFactProrrata,
            Prima_Moneda = Z.Prima_Moneda * nFactProrrata
      WHERE CodCia        = Z.CodCia
        AND CodEmpresa    = Z.CodEmpresa
        AND IdPoliza      = Z.IdPoliza
        AND IDetPol       = Z.IDetPol
        AND Cod_Asegurado = Z.Cod_Asegurado
        AND CodCobert     = Z.CodCobert
        AND IdEndoso      = nIdEndosoExclu;
     END;
        END LOOP;
        FOR Z IN ASIST_Q LOOP
     BEGIN
        INSERT INTO ASISTENCIAS_ASEGURADO
        (CodCia, CodEmpresa, IdPoliza, IdetPol, Cod_Asegurado, CodAsistencia,
         CodMoneda, MontoAsistLocal, MontoAsistMoneda, StsAsistencia,
         FecSts, IdEndoso)
        VALUES(Z.CodCia, Z.CodEmpresa, Z.IdPoliza, Z.IdetPol, Z.Cod_Asegurado, Z.CodAsistencia,
         Z.CodMoneda, Z.MontoAsistLocal * nFactProrrata,
         Z.MontoAsistMoneda * nFactProrrata, Z.StsAsistencia,
         TRUNC(SYSDATE), nIdEndosoExclu);
     EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
           UPDATE ASISTENCIAS_ASEGURADO
        SET MontoAsistLocal  = Z.MontoAsistLocal * nFactProrrata,
            MontoAsistMoneda = Z.MontoAsistMoneda * nFactProrrata
      WHERE CodCia        = Z.CodCia
        AND CodEmpresa    = Z.CodEmpresa
        AND IdPoliza      = Z.IdPoliza
        AND IDetPol       = Z.IDetPol
        AND Cod_Asegurado = Z.Cod_Asegurado
        AND CodAsistencia = Z.CodAsistencia
        AND IdEndoso      = nIdEndosoExclu;
     END;
        END LOOP;
     END LOOP;
     UPDATE ENDOSOS
        SET Suma_Aseg_Local   = nSuma_Aseg_Local,
      Suma_Aseg_Moneda  = nSuma_Aseg_Moneda,
      Prima_Neta_Local  = nPrima_Neta_Local,
      Prima_Neta_Moneda = nPrima_Neta_Moneda
      WHERE IdPoliza   = nIdPoliza
        AND IdEndoso   = nIdEndosoExclu
        AND CodCia     = nCodCia;
  EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20225,'Error en Proceso para Calcular Exclusión de Asegurado '||SQLERRM);
  END CALCULA_EXCLUSION_ASEG;

  PROCEDURE EXCLUIR_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndosoExclu NUMBER) IS
  nSuma_Aseg_Moneda     ENDOSOS.Suma_Aseg_Moneda%TYPE;
  cTipoEndoso           ENDOSOS.TipoEndoso%TYPE;
  cNaturalidad          PROPIEDADES_VALORES.Valor%TYPE;
  nNaturalidad          NUMBER;
  nIdTrn                NUMBER(10);

  CURSOR ASEG_Q IS
     SELECT A.Cod_Asegurado, A.FecAnulExclu, A.MotivAnulExclu, D.IDetPol,
      D.FecIniVig, D.FecFinVig
       FROM ASEGURADO_CERTIFICADO A, DETALLE_POLIZA D
      WHERE A.CodCia        = nCodCia
        AND A.IdPoliza      = nIdPoliza
        AND A.IdEndosoExclu = nIdEndosoExclu
        AND A.FecAnulExclu IS NOT NULL
        AND D.CodCia        = A.CodCia
        AND D.IdPoliza      = A.IdPoliza
        AND D.IDetPol       = A.IDetPol;
  CURSOR NOTA_Q IS
     SELECT IdNcr, IdPoliza
       FROM NOTAS_DE_CREDITO
      WHERE IdPoliza   = nIdPoliza
        AND IDetPol    = nIDetPol
        AND IdEndoso   = nIdEndosoExclu;
  BEGIN
     SELECT Suma_Aseg_Moneda, TipoEndoso
       INTO nSuma_Aseg_Moneda, cTipoEndoso
       FROM ENDOSOS
      WHERE CodCia   = nCodCia
        AND IdPoliza = nIdPoliza
        AND IDetPol  = nIDetPol
        AND IdEndoso = nIdEndosoExclu;

     IF cTipoEndoso = 'EXA' THEN
        IF OC_ASEGURADO_CERTIFICADO.TIENE_ASEGURADOS(nCodCia, nIdPoliza, nIDetPol, nIdEndosoExclu) = 'N' THEN
     OC_COBERT_ACT.EXCLUIR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol);
     OC_ASISTENCIAS_DETALLE_POLIZA.EXCLUIR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol);
        ELSE
     FOR W IN ASEG_Q LOOP
        OC_COBERT_ACT_ASEG.EXCLUIR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, W.Cod_Asegurado);
        OC_ASISTENCIAS_ASEGURADO.EXCLUIR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol, W.Cod_Asegurado);
        OC_ASEGURADO_CERTIFICADO.EXCLUIR(nCodCia, nIdPoliza, W.IDetPol, W.Cod_Asegurado, W.FecAnulExclu, W.MotivAnulExclu);
     END LOOP;
        END IF;
     END IF;

     cNaturalidad := OC_ENDOSO.NATURALIDAD(cTipoEndoso);

     IF cNaturalidad = '-' THEN
        nNaturalidad := -1;
     ELSE
        nNaturalidad := 1;
     END IF;

     IF cTipoEndoso NOT IN ('ESV','ESVTL','CLA') THEN
        nIdTrn := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 8, cTipoEndoso);
        OC_DETALLE_TRANSACCION.CREA(nIdTrn, nCodCia, nCodEmpresa, 8, cTipoEndoso, 'ENDOSOS',
            nIdPoliza, nIDetPol, nIdEndosoExclu, NULL, nSuma_Aseg_Moneda);
        IF cNaturalidad = '-' THEN
     OC_NOTAS_DE_CREDITO.EMITIR_NOTA_CREDITO(nIdPoliza, nIDetPol, nIdEndosoExclu, nIdTrn);
     FOR Z IN NOTA_Q LOOP
        OC_NOTAS_DE_CREDITO.EMITIR(Z.IdNcr, NULL);
     END LOOP;
        END IF;
        OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTrn, 'C');
        FOR W IN ASEG_Q LOOP
     OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol, W.Cod_Asegurado);
     OC_ASEGURADO_CERTIFICADO.ACTUALIZA_ASISTENCIAS(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol, W.Cod_Asegurado);
        END LOOP;

     ELSE
        nIdTrn := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 8, cTipoEndoso);
        OC_DETALLE_TRANSACCION.CREA(nIdTrn, nCodCia, nCodEmpresa, 8, cTipoEndoso, 'ENDOSOS',
            nIdPoliza, nIDetPol, nIdEndosoExclu, NULL, nSuma_Aseg_Moneda);
     END IF;

     OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIDetPol, nIdEndosoExclu);
     OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, nIdEndosoExclu);

     UPDATE ENDOSOS
        SET StsEndoso = 'EMI',
      FecSts    = TRUNC(SYSDATE)
      WHERE CodCia    = nCodCia
        AND IdPoliza = nIdPoliza
        AND IDetPol  = nIDetPol
        AND IdEndoso = nIdEndosoExclu;
  END EXCLUIR_ASEGURADOS;

  FUNCTION TOTAL_PRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) RETURN NUMBER IS
  nPrimaTotal      ENDOSOS.Prima_Neta_Moneda%TYPE;
  BEGIN
     SELECT NVL(SUM(Prima_Neta_Moneda),0)
       INTO nPrimaTotal
       FROM ENDOSOS
      WHERE StsEndoso IN ('SOL','EMI')
        AND IdEndoso   = nIdEndoso
        AND IDetPol    = nIDetPol
        AND IdPoliza   = nIdPoliza
        AND CodCia     = nCodCia;
     RETURN(nPrimaTotal);
  END TOTAL_PRIMA;

  FUNCTION TOTAL_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) RETURN NUMBER IS
  nTotalAseg      NUMBER(10);
  BEGIN
     SELECT COUNT(*)
       INTO nTotalAseg
       FROM ASEGURADO_CERTIFICADO
      WHERE (IdEndoso     = nIdEndoso
         OR IdEndosoExclu = nIdEndoso)
        AND IDetPol       = nIDetPol
        AND IdPoliza      = nIdPoliza
        AND CodCia        = nCodCia;

     RETURN(nTotalAseg);
  END TOTAL_ASEGURADOS;

  FUNCTION CAMBIO_POR_LISTADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nCertidicado NUMBER) RETURN VARCHAR2 IS
  -- MLJS 23/10/2023 se agrega el certificado
  nEndoCLA      NUMBER(10);
  BEGIN
     SELECT COUNT(*)
       INTO nEndoCLA
       FROM ENDOSOS
      WHERE CodCia     = nCodCia
        AND CodEmpresa = nCodEmpresa
        AND IdPoliza   = nIdPoliza
        AND IdetPol    = nCertidicado
        AND TipoEndoso = 'CLA'
        AND StsEndoso  = 'EMI';

     IF NVL(nEndoCLA,0) > 0 THEN
        RETURN('S');
     ELSE
        RETURN('N');
     END IF;
  END CAMBIO_POR_LISTADO;

  FUNCTION VALIDA_CAMBIO_FORMA_DE_PAGO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,nIDetPol NUMBER,
               cCodPlanPagoEndo VARCHAR2, nPrimaPendiente IN OUT NUMBER, cIndCalcDerechoEmis IN OUT VARCHAR2) RETURN VARCHAR2 IS
  cCodPlanPago       POLIZAS.CodPlanPago%TYPE;
  cIndFacturaPol     POLIZAS.IndFacturaPol%TYPE;
  nNumPagosOrig      PLAN_DE_PAGOS.NumPagos%TYPE;
  nNumPagosEndo      PLAN_DE_PAGOS.NumPagos%TYPE;
  nExistePag         NUMBER(5);
  nExisteEmi         NUMBER(5);
  cValidado          VARCHAR2(1) := 'N';

  CURSOR FACT_Q IS
     SELECT F.IdFactura, F.StsFact
       FROM FACTURAS F
      WHERE F.CodCia         = nCodCia
        AND F.IdPoliza       = nIdPoliza
        AND (F.IdEndoso      = 0
         OR (F.IdEndoso      > 0
        AND  EXISTS (SELECT 'S'
           FROM ENDOSOS
          WHERE CodCia     = nCodCia
            AND IdPoliza   = nIdPoliza
            AND IdEndoso  <= F.IdEndoso
            AND TipoEndoso = 'CFP')))
        AND F.StsFact    IN ('EMI', 'PAG')
        AND cIndFacturaPol = 'S'
      UNION
     SELECT F.IdFactura, F.StsFact
       FROM FACTURAS F
      WHERE F.CodCia         = nCodCia
        AND F.IdPoliza       = nIdPoliza
        AND F.IDetPol        = nIDetPol
        AND (F.IdEndoso      = 0
         OR (F.IdEndoso      > 0
        AND  EXISTS (SELECT 'S'
           FROM ENDOSOS
          WHERE CodCia     = nCodCia
            AND IdPoliza   = nIdPoliza
            AND IDetPol    = nIDetPol
            AND IdEndoso  <= F.IdEndoso
            AND TipoEndoso = 'CFP')))
        AND F.StsFact      IN ('EMI', 'PAG')
        AND cIndFacturaPol = 'N'
      ORDER BY IdFactura;
  BEGIN
     SELECT CodPlanPago, IndFacturaPol
       INTO cCodPlanPago, cIndFacturaPol
       FROM POLIZAS
      WHERE IdPoliza = nIdPoliza
        AND CodCia   = nCodCia;

     IF cCodPlanPagoEndo != cCodPlanPago THEN
        nExisteEmi := 0;
        nExistePag := 0;
        FOR W IN FACT_Q LOOP
     IF W.StsFact = 'EMI' THEN
        IF OC_FACTURAS.EN_COBRANZA_MASIVA(nCodCia, W.IdFactura) = 'N' THEN
           nExisteEmi := NVL(nExisteEmi,0) + 1;
        ELSE
           RAISE_APPLICATION_ERROR(-20225,'NO Puede Hacer Endoso Porque Existen Facturas o Recibos en Proceso de Cobranza Masiva');
        END IF;
     ELSIF W.StsFact = 'PAG' THEN
        nExistePag := NVL(nExistePag,0) + 1;
     END IF;
        END LOOP;

        cIndCalcDerechoEmis := 'N';

        IF NVL(nExistePag,0) != 0 AND NVL(nExisteEmi,0) = 0 THEN
     RAISE_APPLICATION_ERROR(-20225,'Facturas o Recibos ya fueron Pagados y NO Puede Cambiar Forma de Pago');
        ELSIF NVL(nExistePag,0) = 0 AND NVL(nExisteEmi,0) != 0 THEN
     cIndCalcDerechoEmis := 'S';
     cValidado           := 'S';
        ELSE

     nNumPagosOrig := OC_PLAN_DE_PAGOS.CANTIDAD_PAGOS(nCodCia, nCodEmpresa, cCodPlanPago);
     nNumPagosEndo := OC_PLAN_DE_PAGOS.CANTIDAD_PAGOS(nCodCia, nCodEmpresa, cCodPlanPagoEndo);

     IF nNumPagosOrig = 12 THEN  -- Forma de Pago Mensual
        IF nNumPagosEndo = 4 AND nExistePag > 9 THEN  -- Nueva Forma de Pago Trimestral
           RAISE_APPLICATION_ERROR(-20225,'NO se puede hacer el Cambio a Trimestral porque la Cuotas Mensuales Pendientes son menos de 3');
        ELSIF nNumPagosEndo = 2 AND nExistePag > 6 THEN -- Nueva Forma de Pago Semestral
           RAISE_APPLICATION_ERROR(-20225,'NO se puede hacer el Cambio a Semestral porque la Cuotas Mensuales Pendientes son menos de 6');
        ELSE
           cValidado := 'S';
        END IF;
     ELSIF nNumPagosOrig = 4 THEN  -- Forma de Pago Trimestral
        IF nNumPagosEndo = 2 AND nExistePag > 2 THEN  -- Nueva Forma de Pago Semestral
           RAISE_APPLICATION_ERROR(-20225,'NO se puede hacer el Cambio a Semestral porque la Cuotas Trimestrales Pendientes son menos de 2');
        ELSE
           cValidado := 'S';
        END IF;
     ELSE
        cValidado := 'S';
     END IF;
        END IF;
     ELSE
        RAISE_APPLICATION_ERROR(-20225,'Para el Cambio de Forma de Pago debe Seleccionar un Plan de Pago Diferente al de la Póliza');
     END IF;

     nPrimaPendiente := 0;
     FOR W IN FACT_Q LOOP
        IF W.StsFact = 'EMI' THEN
     SELECT NVL(nPrimaPendiente,0) + NVL(SUM(D.Saldo_Det_Moneda),0)
       INTO nPrimaPendiente
       FROM DETALLE_FACTURAS D, CATALOGO_DE_CONCEPTOS C
      WHERE C.CodConcepto      = D.CodCpto
        AND C.CodCia           = nCodCia
        AND (D.IndCptoPrima    = 'S'
         OR C.IndCptoServicio  = 'S')
        AND D.IdFactura        = W.IdFactura;
        END IF;
     END LOOP;

     RETURN(cValidado);
  END VALIDA_CAMBIO_FORMA_DE_PAGO;

  PROCEDURE REHABILITACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIdEndoso NUMBER) IS

  nIdTransaccionAnu    FACTURAS.IdTransaccionAnu%TYPE;
  nIdTransaccionAnuNc  FACTURAS.IdTransaccionAnu%TYPE;
  nIdTransaccion       TRANSACCION.IdTransaccion%TYPE := 0;
  nIdTransacNcRehab    TRANSACCION.IdTransaccion%TYPE := 0;
  nPrimaNeta_Moneda    ENDOSOS.Prima_Neta_Moneda%TYPE;
  nPrimaNeta_Local     ENDOSOS.Prima_Neta_Local%TYPE;
  cStsPoliza           POLIZAS.StsPoliza%TYPE;
  cStsDetalle          DETALLE_POLIZA.StsDetalle%TYPE;
  cStsEndoso           ENDOSOS.StsEndoso%TYPE;
  cTipoEndoso          ENDOSOS.TipoEndoso%TYPE;
  cTipresendo          VARCHAR2(20);
  dFecAnul             ENDOSOS.FecAnul%TYPE;
  nTotNotaCredCanc     DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
  vRehaPol             VARCHAR2(1);
  nIDetPol             DETALLE_ENDOSO.IDetPol%TYPE;
  nIdFactura           DETALLE_ENDOSO.IdFactura%TYPE;
  nMontoEndo           DETALLE_ENDOSO.Monto%TYPE;
  cNaturalidad         VARCHAR2(2);

  CURSOR ASEG_Q IS
     SELECT IDetPol, Cod_Asegurado, IdEndoso, Estado
       FROM ASEGURADO_CERTIFICADO
      WHERE IdPoliza  = nIdPoliza
        AND CodCia    = nCodCia
        AND IdEndoso  = nIdendoso;

  CURSOR FACT_Q IS
     SELECT IdFactura
       FROM FACTURAS
      WHERE IdTransaccionAnu = nIdTransaccionAnu
        AND IdPoliza         = nIdPoliza
        AND IdEndoso         = nIdEndoso
        AND StsFact          = 'ANU'
     ORDER BY IdFactura;

  CURSOR NCR_ANU_Q IS
    SELECT IdNcr, CodCia, IdPoliza, IDetPol, IdEndoso
      FROM NOTAS_DE_CREDITO
     WHERE IdPoliza         = nIdPoliza
       AND idtransaccionanu = nIdTransaccionAnuNc;
  BEGIN
     BEGIN
        SELECT StsPoliza
    INTO cStsPoliza
    FROM POLIZAS
         WHERE CodCia   = nCodCia
     AND IdPoliza = nIdPoliza;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-20225, 'NO existe la Póliza No. ' || TRIM(TO_CHAR(nIdPoliza)) ||
          ' del Endoso que desea Rehabilitar');
     END;
     IF cStsPoliza = 'ANU' THEN
        RAISE_APPLICATION_ERROR(-20225, 'Debe Rehabilitar la Póliza No. ' || TRIM(TO_CHAR(nIdPoliza)) ||
              ' que está ANULADA y se Rehabilitarán sus Endosos.');
     END IF;

     BEGIN
        SELECT StsEndoso, TipoEndoso, Prima_Neta_moneda,
         Prima_Neta_local, FecAnul, IDetPol
    INTO cStsEndoso, cTipoEndoso, nPrimaNeta_Moneda,
         nPrimaNeta_Local, dFecAnul, nIDetPol
    FROM ENDOSOS
         WHERE CodCia    = nCodCia
     AND IdPoliza  = nIdPoliza
     AND IdEndoso  = nIdEndoso;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-20225, 'No Existe el Endoso No. ' || TRIM(TO_CHAR(nIdEndoso)) ||
           ' de la Póliza No. ' || TRIM(TO_CHAR(nIdPoliza)) || ' para Rehabilitar.');
        WHEN OTHERS THEN
     RAISE_APPLICATION_ERROR(-20225, 'Problemas para Recuperar el Endoso No. ' || TRIM(TO_CHAR(nIdEndoso)) ||
           ' de la Póliza No. ' || TRIM(TO_CHAR(nIdPoliza)) || ' ' || SQLERRM);
     END;

     BEGIN
        SELECT StsDetalle
    INTO cStsDetalle
    FROM DETALLE_POLIZA
         WHERE CodCia   = nCodCia
     AND IdPoliza = nIdPoliza
     AND IDetPol  = nIDetPol;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-20225, 'NO existe Certificado/SubGrupo No. ' || nIDetPol || ' en la Póliza No. ' || TRIM(TO_CHAR(nIdPoliza)) ||
          ' del Endoso que desea Rehabilitar');
     END;
     IF cStsDetalle = 'ANU' THEN
        RAISE_APPLICATION_ERROR(-20225, 'Debe Rehabilitar el Certificado/SubGrupo No. ' || nIDetPol || ' en la Póliza No. ' || TRIM(TO_CHAR(nIdPoliza)) ||
              ' que está ANULADO y se Rehabilitarán sus Endosos.');
     END IF;

     IF cStsEndoso = 'ANU' THEN
        IF cTipoEndoso IN ('EXA', 'EXC') THEN
     RAISE_APPLICATION_ERROR(-20225, 'NO se puede Rehabilitar el Tipo de Endoso ' || cTipoEndoso || '. Debe volver a Realizar el Endoso en la Póliza');
        ELSE
     UPDATE ENDOSOS
        SET StsEndoso  = 'EMI',
      FecAnul    = NULL,
      MotivAnul  = NULL,
      FecSts     = TRUNC(SYSDATE)
      WHERE IdPoliza = nIdPoliza
        AND IdEndoso = nIdEndoso;
        END IF;
     ELSE
        RAISE_APPLICATION_ERROR(-20225, ' El Endoso No. ' || nIdEndoso || ' de la Póliza No. ' ||
              TRIM(TO_CHAR(nIdPoliza)) || ' NO está Anulado para Rehabilitarse');
     END IF;

     cNaturalidad := OC_ENDOSO.NATURALIDAD(cTipoEndoso);

     FOR X IN ASEG_Q LOOP
        OC_ASEGURADO_CERTIFICADO.REHABILITAR(nCodCia, nIdPoliza, X.IDetPol, X.Cod_Asegurado);
        OC_COBERT_ACT_ASEG.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, X.IDetPol, X.Cod_Asegurado);
        OC_ASISTENCIAS_ASEGURADO.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, X.IDetPol, X.Cod_Asegurado);
        OC_BENEFICIARIO.REHABILITAR(nIdPoliza, X.IDetPol, X.Cod_Asegurado);
     END LOOP;

     -- Rehabilita Facturas Anuladas
     IF cNaturalidad = '+' THEN
        SELECT MAX(T.IdTransaccion)
    INTO nIdTransaccionAnu
    FROM TRANSACCION T, DETALLE_TRANSACCION D
         WHERE D.CodSubProceso     = 'FAC'
     AND D.CodCia            = nCodCia
     AND D.CodEmpresa        = nCodEmpresa
     AND TO_NUMBER(D.Valor1) = nIdPoliza
     AND TO_NUMBER(D.Valor2) = nIDetPol
     AND TO_NUMBER(D.Valor3) = nIdEndoso
     AND T.IdTransaccion     = D.IdTransaccion
     AND T.IdProceso         = 8;

        FOR W IN FACT_Q LOOP
     IF NVL(nIdTransaccion,0) = 0 THEN
        nIdTransaccion := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 18, 'REHAB');
        OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 18, 'REHAB',
            'ENDOSOS', nIdPoliza, nIDetPol, nIdEndoso, NULL, nPrimaNeta_Moneda);
     END IF;
     OC_FACTURAS.REHABILITACION(nCodCia, nCodEmpresa, W.IdFactura, nIdTransaccion);
        END LOOP;
        IF NVL(nIdTransaccion,0) > 0 THEN
     OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');
        END IF;
     ELSE
        -- Rehabilita Notas de Crédito Anuladas
        SELECT MAX(T.IdTransaccion)
    INTO nIdTransaccionAnuNc
    FROM TRANSACCION T, DETALLE_TRANSACCION D
         WHERE D.CodSubProceso     = 'NCR'
     AND D.CodCia            = nCodCia
     AND D.CodEmpresa        = nCodEmpresa
     AND TO_NUMBER(D.Valor1) = nIdPoliza
     AND TO_NUMBER(D.Valor2) = nIDetPol
     AND TO_NUMBER(D.Valor3) = nIdEndoso
     AND T.IdTransaccion     = D.IdTransaccion
     AND T.IdProceso         = 8;

        FOR W IN NCR_ANU_Q LOOP
     IF NVL(nIdTransacNcRehab, 0) = 0 THEN
         nIdTransacNcRehab := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 18, 'REHNCR');
     END IF;
     OC_NOTAS_DE_CREDITO.REHABILITACION(nCodCia, nCodEmpresa, W.IdNcr, nIdTransacNcRehab);
        END LOOP;
        IF NVL(nIdTransacNcRehab,0) > 0 THEN
     OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacNcRehab, 'C');
        END IF;
     END IF;
  END REHABILITACION;

  PROCEDURE ENDOSO_ANULACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, dFecAnulacion DATE, cMotivAnul VARCHAR2) IS    -- ENDCAN
   nIDetPol          ENDOSOS.IDETPOL%TYPE;
   cTipoEndoso       ENDOSOS.TIPOENDOSO%TYPE;
   cNumEndRef        ENDOSOS.NUMENDREF%TYPE;
   dFecIniVig        ENDOSOS.FECINIVIG%TYPE;
   dFecFinVig        ENDOSOS.FECFINVIG%TYPE;
   cCodPlan          ENDOSOS.CODPLANPAGO%TYPE;
   nSuma_Aseg_Moneda ENDOSOS.SUMA_ASEG_LOCAL%TYPE;
   nPrima_Moneda     ENDOSOS.PRIMA_NETA_LOCAL%TYPE;
   nPorcComis        ENDOSOS.PORCCOMIS%TYPE;
   cMotivo_Endoso    ENDOSOS.MOTIVO_ENDOSO%TYPE;
   dFecExc           ENDOSOS.FECEXC%TYPE;
   cUsuario          VARCHAR2(20);
   cTerminal         VARCHAR2(20);
   nIdendoso         ENDOSOS.IDENDOSO%TYPE;
         CLINEA_T          VARCHAR2(4000);
         cTexto            VARCHAR2(4000);
  BEGIN
    --
    BEGIN
      SELECT FECFINVIG,  P.CODPLANPAGO
        INTO dFecFinVig, cCodPlan
        FROM POLIZAS P
       WHERE IDPOLIZA = nCodCia
         AND CODCIA   = nIdPoliza;
    EXCEPTION
      WHEN OTHERS THEN
     dFecFinVig := dFecAnulacion;
    END;
    --
    SELECT USER,     USERENV('TERMINAL')
      INTO cUsuario, cTerminal
      FROM SYS.DUAL;
    --
    SELECT NVL(MAX(IdEndoso),0) + 1
      INTO nIdendoso
      FROM ENDOSOS
     WHERE IDPOLIZA = nIdPoliza;
    --
    cMotivo_Endoso := cMotivAnul;
    --
    IF cMotivAnul = 'CAFP' THEN
       cTipoEndoso := 'CAAFP';
    ELSE
       cTipoEndoso := 'CAP';
    END IF;
    --
    -- INICIALIZA
    --
    nIDetPol          := 0;   -- SE LIGA POR DEFAUL AL DETALLE 1
    cNumEndRef        := 'END-' ||nIdPoliza||'-'||nIDENDOSO;
    dFecIniVig        := dFecAnulacion;
    nSuma_Aseg_Moneda := 0;
    nPrima_Moneda     := 0;
    nPorcComis        := 0;
    dFecExc           := NULL;
    --
    OC_ENDOSO.INSERTA(nCodCia,            nCodEmpresa,             nIdPoliza,
          nIDetPol,           nIdendoso,               cTipoEndoso,
          cNumEndRef,         dFecIniVig,              dFecFinVig,
          cCodPlan,           nSuma_Aseg_Moneda,       nPrima_Moneda,
          nPorcComis,         cMotivo_Endoso,          dFecExc);
    --
    OC_ENDOSO.EMITIR(nCodCia,             nCodEmpresa,             nIdPoliza,
         nIDetPol,            nIdendoso,               cTipoEndoso);
    --
          cTexto   := OC_ENDOSO_TXT_ENC.DESCRIPCION_TEXTO(nCodCia,cMotivAnul) ;
          CLINEA_T := OC_ENDOSO_TXT_DET.DESCRIPCION_TEXTO(nCodCia,cMotivAnul) ;
          --
          cTexto := replace(cTexto, '', OC_GENERALES.FECHA_EN_LETRAS(dFecAnulacion));
          cTexto := replace(cTexto, '', OC_GENERALES.FECHA_EN_LETRAS(dFecFinVig));
          CLINEA_T := replace(CLINEA_T, '', OC_GENERALES.FECHA_EN_LETRAS(dFecAnulacion));
          CLINEA_T := replace(CLINEA_T, '', OC_GENERALES.FECHA_EN_LETRAS(dFecFinVig));
          --
          cTexto := replace(cTexto, ' de Valor No Valido del ', '');
          CLINEA_T := replace(CLINEA_T, ' de Valor No Valido del ', '');
          --
          UPDATE ENDOSOS E
                            SET E.DESCENDOSO = cTexto,
                                E.FECFINVIG = dFecFinVig
              WHERE E.IDPOLIZA = nIdPoliza
                AND E.IDENDOSO = nIdendoso;
          --
          /*
    IF cMotivAnul = 'CAFP' THEN
       UPDATE ENDOSOS E
    SET E.DESCENDOSO = 'Póliza cancelada de forma automática por falta de pago a partir del '||TO_CHAR(dFecAnulacion,'DD')||
           ' de '||TO_CHAR(dFecAnulacion,'MONTH')||
           ' de '||TO_CHAR(dFecAnulacion,'YYYY')
        WHERE E.IDPOLIZA = nIdPoliza
    AND E.IDENDOSO = nIdendoso;
       --
       CLINEA_T := 'Por medio del presente endoso, se hace constar que la presente póliza queda cancelada de forma automática por falta de pago a partir del '||TO_CHAR(dFecAnulacion,'DD')||
       ' de '||TO_CHAR(dFecAnulacion,'MONTH')||
       ' de '||TO_CHAR(dFecAnulacion,'YYYY');
       --
    ELSE
       UPDATE ENDOSOS E
    SET E.DESCENDOSO = 'Póliza cancelada de a partir del '||TO_CHAR(dFecAnulacion,'DD')||
           ' de '||TO_CHAR(dFecAnulacion,'MONTH')||
           ' de '||TO_CHAR(dFecAnulacion,'YYYY')
        WHERE E.IDPOLIZA = nIdPoliza
    AND E.IDENDOSO = nIdendoso;
       --
       CLINEA_T := 'Por medio del presente endoso, se hace constar que la presente póliza queda cancelada a partir del '||TO_CHAR(dFecAnulacion,'DD')||
       ' de '||TO_CHAR(dFecAnulacion,'MONTH')||
       ' de '||TO_CHAR(dFecAnulacion,'YYYY')||CHR(10)||CHR(10)||CHR(10)||
       'Usuario : '||cUsuario||'     Terminal : '||cTerminal||'     Fecha : '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss');
       --
    END IF;
    */
    --
    OC_ENDOSO_TEXTO.INSERTA(nIdPoliza, nIdendoso, CLINEA_T);
    --
  END ENDOSO_ANULACION;
  --
  PROCEDURE ENDOSO_REHABILITACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) IS    -- ENDCAN
   nIDetPol          ENDOSOS.IDETPOL%TYPE;
   cTipoEndoso       ENDOSOS.TIPOENDOSO%TYPE;
   cNumEndRef        ENDOSOS.NUMENDREF%TYPE;
   dFecIniVig        ENDOSOS.FECINIVIG%TYPE;
   dFecFinVig        ENDOSOS.FECFINVIG%TYPE;
   cCodPlan          ENDOSOS.CODPLANPAGO%TYPE;
   nSuma_Aseg_Moneda ENDOSOS.SUMA_ASEG_LOCAL%TYPE;
   nPrima_Moneda     ENDOSOS.PRIMA_NETA_LOCAL%TYPE;
   nPorcComis        ENDOSOS.PORCCOMIS%TYPE;
   cMotivo_Endoso    ENDOSOS.MOTIVO_ENDOSO%TYPE;
   dFecExc           ENDOSOS.FECEXC%TYPE;
   cUsuario          VARCHAR2(20);
   cTerminal         VARCHAR2(20);
   nIdendoso         ENDOSOS.IDENDOSO%TYPE;
   CLINEA_T          VARCHAR2(500);
  BEGIN
    --
    BEGIN
      SELECT FECFINVIG,  P.CODPLANPAGO
        INTO dFecFinVig, cCodPlan
        FROM POLIZAS P
       WHERE IDPOLIZA = nCodCia
         AND CODCIA   = nIdPoliza;
    EXCEPTION
      WHEN OTHERS THEN
     dFecFinVig := TRUNC(SYSDATE);
    END;
    --
    SELECT USER,     USERENV('TERMINAL')
      INTO cUsuario, cTerminal
      FROM SYS.DUAL;
    --
    SELECT NVL(MAX(IdEndoso),0) + 1
      INTO nIdendoso
      FROM ENDOSOS
     WHERE IDPOLIZA = nIdPoliza;
    --
    -- INICIALIZA
    --
    nIDetPol          := 0;   -- SE LIGA POR DEFAUL AL DETALLE 1
    cNumEndRef        := 'END-' ||nIdPoliza||'-'||nIDENDOSO;
    dFecIniVig        := TRUNC(SYSDATE);
    nSuma_Aseg_Moneda := 0;
    nPrima_Moneda     := 0;
    nPorcComis        := 0;
    dFecExc           := '';
    cMotivo_Endoso    := 'REHAP';
    cTipoEndoso       := 'REHAP';
    --
    OC_ENDOSO.INSERTA(nCodCia,            nCodEmpresa,             nIdPoliza,
          nIDetPol,           nIdendoso,               cTipoEndoso,
          cNumEndRef,         dFecIniVig,              dFecFinVig,
          cCodPlan,           nSuma_Aseg_Moneda,       nPrima_Moneda,
          nPorcComis,         cMotivo_Endoso,          dFecExc);
    --
    OC_ENDOSO.EMITIR(nCodCia,             nCodEmpresa,             nIdPoliza,
         nIDetPol,            nIdendoso,               cTipoEndoso);
    --
    UPDATE ENDOSOS E
       SET E.DESCENDOSO = 'Póliza rehabilitada a partir del '||TO_CHAR(dFecIniVig,'DD')||
        ' de '||TO_CHAR(dFecIniVig,'MONTH')||
        ' de '||TO_CHAR(dFecIniVig,'YYYY')
     WHERE E.IDPOLIZA = nIdPoliza
       AND E.IDENDOSO = nIdendoso;
    --
    CLINEA_T := 'Por medio del presente endoso, se hace constar que la presente póliza se rehabilita para la aplicación del pago pendiente de primas a partir del '||TO_CHAR(dFecIniVig,'DD')||
          ' de '||TO_CHAR(dFecIniVig,'MONTH')||
          ' de '||TO_CHAR(dFecIniVig,'YYYY')||CHR(10)||CHR(10)||CHR(10)||
       'Usuario : '||cUsuario||'     Terminal : '||cTerminal||'     Fecha : '||to_char(sysdate,'dd/mm/yyyy hh24:mi:ss');
    --
    OC_ENDOSO_TEXTO.INSERTA(nIdPoliza, nIdendoso, CLINEA_T);
    --
  END ENDOSO_REHABILITACION;
  --
  FUNCTION MONEDA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) RETURN VARCHAR2 IS
  /*   _______________________________________________________________________________________________________________________________
      |                                                                                                                               |
      |                                                           HISTORIA                                                            |
      | Elaboro    : J. Alberto Lopez Valle                                                                                           |
      | Para       : THONA Seguros                                                                                                    |
      | Fecha Elab.: 26/04/2021                                                                                                       |
      | Email      : alopez@thonaseguros.mx                                                                                           |
      | Nombre     : MONEDA                                                                                                           |
      | Objetivo   : Funcion que obtiene la Moneda (Cod_Moneda) en que se efectuo el Endoso asociado a la Poliza correspondiente.     |                                                                                                     |
      | Modificado : NO                                                                                                               |
      | Ult. Modif.: N/A                                                                                                              |
      | Modifico   : N/A                                                                                                              |
      | Obj. Modif.: N/A                                                                                                              |
      | Parametros:                                                                                                                   |
      |           nCodCia             Codigo de Compañia                                          (Entrada)                           |
      |           nCodEmpresa         Codigo de Empresa                                           (Entrada)                           |
      |           nIdPoliza           Numero de la Poliza a revisar                               (Entrada)                           |
      |           nIDetPol            IdetPol de la Poliza                                        (Entrada)                           |
      |           nIdEndoso           Numero del Endoso asociado.                                 (Entrada)                           |
      |_______________________________________________________________________________________________________________________________|
  */
  nCodMoneda  POLIZAS.Cod_Moneda%TYPE;
  BEGIN
      SELECT  P.Cod_Moneda
      INTO    nCodMoneda
      FROM    POLIZAS P,
        ENDOSOS E
      WHERE   P.IdPoliza   = E.IdPoliza
      AND     P.CodCia     = E.CodCia
      AND     P.CodEmpresa = E.CodEmpresa
      AND     E.StsEndoso    IN ('SOL','EMI')
      AND     E.IdEndoso     = nIdEndoso
      AND     E.IDetPol      = nIDetPol
      AND     E.IdPoliza     = nIdPoliza
      AND     E.CodCia       = nCodCia
      AND     E.CodEmpresa   = nCodEmpresa;
     RETURN(nCodMoneda);
  END MONEDA;

   --JIBARRA_09-11-2022 <SE CREA PROCESO PARA LA ACTUALIZACION DE LAS FECHAS DE VIGENCIA DE ENDOSO, CERTIFICADO, POLIZA, FACTRUAS O NOTAS DE CREDITO
   --                SEGUN COMO CORRESPONDE A LA NECESIDAD DEL USURAIO>
    PROCEDURE ACTUALIZA_FECHAS_VIG(nCodCia IN NUMBER, nIdPoliza IN NUMBER, nIDetPol IN NUMBER, nIdEndoso IN NUMBER, nNumError OUT NUMBER, cMsjError OUT VARCHAR2) AS
      cMotivo_EndosoA   SICAS_OC.ENDOSOS.MOTIVO_ENDOSO%TYPE := '027';  --VARIABLE PARA VALIDAR MOTIVO DE ENDOSO DE CAMBIO DE FECHA
      cMotivo_EndosoB   SICAS_OC.ENDOSOS.MOTIVO_ENDOSO%TYPE := '029';  --VARIABLE PARA VALIDAR MOTIVO DE ENDOSO DE CAMBIO DE FECHA
      cMotivo_EndosoC   SICAS_OC.ENDOSOS.MOTIVO_ENDOSO%TYPE := '031';  --VARIABLE PARA VALIDAR MOTIVO DE ENDOSO DE CAMBIO DE FECHA
      cTipoDocNcr    SICAS_OC.ENDOSO_SERVICIOS_WEB.TIPO_DOC_UPD%TYPE := 'NCR';
      cTipoDocRecibo SICAS_OC.ENDOSO_SERVICIOS_WEB.TIPO_DOC_UPD%TYPE := 'RECIBO';
      nParametros     VARCHAR2(2000) := 'Parametros:: ' || TRUNC(SYSDATE) || '[' || nCodCia || '|' || nIdPoliza || '|' || nIDetPol || '|' || nIdEndoso || '] ';

      nControl        NUMBER;
      vCadenaControl VARCHAR2(4000);
      nIdEndosoUpd   SICAS_OC.ENDOSO_SERVICIOS_WEB.IDENDOSOUPD%TYPE := 0;
      cTipoDoc    SICAS_OC.ENDOSO_SERVICIOS_WEB.TIPO_DOC_UPD%TYPE := NULL;
      nIdTipoDoc     SICAS_OC.ENDOSO_SERVICIOS_WEB.ID_DOC_UPD%TYPE := 0;
      cMotivo_Endoso SICAS_OC.ENDOSOS.MOTIVO_ENDOSO%TYPE := NULL;
      dNewFechaIni   SICAS_OC.ENDOSO_SERVICIOS_WEB.NEWFECHAINI%TYPE;
      dNewFechaFin   SICAS_OC.ENDOSO_SERVICIOS_WEB.NEWFECHAFIN%TYPE;
      dNewFechaIniD  SICAS_OC.ENDOSO_SERVICIOS_WEB.NEWFECHAINIDOC%TYPE;
      dNewFechaFinD  SICAS_OC.ENDOSO_SERVICIOS_WEB.NEWFECHAFINDOC%TYPE;
   BEGIN
      nNumError := 0;
      cMsjError := NULL;
      nControl := 1;
      BEGIN
         nControl := 2;
         SELECT ESW.IDENDOSOUPD,ESW.TIPO_DOC_UPD, ESW.ID_DOC_UPD, E.MOTIVO_ENDOSO,ESW.NEWFECHAINI,ESW.NEWFECHAFIN,ESW.NEWFECHAINIDOC,ESW.NEWFECHAFINDOC
         INTO nIdEndosoUpd,cTipoDoc, nIdTipoDoc,cMotivo_Endoso,dNewFechaIni,dNewFechaFin,dNewFechaIniD,dNewFechaFinD
         FROM SICAS_OC.ENDOSO_SERVICIOS_WEB ESW
            ,SICAS_OC.ENDOSOS E
         WHERE ESW.CODCIA = nCodCia
         AND ESW.IDPOLIZA = nIdPoliza
         AND ESW.IDETPOL = nIDetPol
         AND ESW.IDENDOSO = nIdEndoso
         AND ESW.ENDOSO_EMITIDO = 'N'
         AND ESW.UPD_SERVICIOS_WEB IS NULL
         AND E.IDPOLIZA = ESW.IDPOLIZA
         AND E.IDENDOSO = ESW.IDENDOSO
         ;
      EXCEPTION
         WHEN OTHERS THEN
            nNumError := SQLCODE;
            cMsjError := SQLERRM;
            cMsjError := '[' || nControl || ']' || cMsjError;
      END;

      nControl := 3;
      IF(nNumError = 0 /*AND nIdEndosoUpd != 0 AND cTipoDoc IS NOT NULL AND nIdTipoDoc != 0*/ AND nIdPoliza IS NOT NULL AND nIDetPol IS NOT NULL
         AND nIdEndoso IS NOT NULL AND cMotivo_Endoso IS NOT NULL /*AND dNewFechaIni IS NOT NULL AND dNewFechaFin IS NOT NULL*/)THEN
         nControl := 4;
         IF(cMotivo_Endoso = cMotivo_EndosoA)THEN
            nControl := 5;
            UPDATE SICAS_OC.POLIZAS
            SET    FECINIVIG = NVL(dNewFechaIni,FECINIVIG)
                  ,FECFINVIG = NVL(dNewFechaFin,FECFINVIG)
            WHERE  IDPOLIZA = nIdPoliza
            ;

            nControl := 6;
            UPDATE SICAS_OC.DETALLE_POLIZA
            SET    FECINIVIG = NVL(dNewFechaIni,FECINIVIG)
                  ,FECFINVIG = NVL(dNewFechaFin,FECFINVIG)
            WHERE  IDPOLIZA = nIdPoliza
            AND    IDETPOL  = nIDetPol
            ;
         ELSIF(cMotivo_Endoso = cMotivo_EndosoB)THEN
            nControl := 7;
            UPDATE SICAS_OC.DETALLE_POLIZA
            SET FECINIVIG = NVL(dNewFechaIni,FECINIVIG)
               ,FECFINVIG = NVL(dNewFechaFin,FECFINVIG)
            WHERE  IDPOLIZA = nIdPoliza
            AND    IDETPOL  = nIDetPol
            ;
         ELSIF(cMotivo_Endoso = cMotivo_EndosoC)THEN
            nControl := 8;
            IF(cTipoDoc = cTipoDocNcr)THEN
               BEGIN
                  nControl := 9;
                  UPDATE SICAS_OC.NOTAS_DE_CREDITO
                  SET FECDEVOL = NVL(dNewFechaIniD,FECDEVOL)
                     ,FECFINVIG = NVL(dNewFechaFinD,FECFINVIG)
                  WHERE IDPOLIZA  = nIdPoliza
                  AND IDETPOL = nIDetPol
                  AND IDENDOSO = nIdEndosoUpd
                  AND IDNCR = nIdTipoDoc
                  ;
               EXCEPTION
                  WHEN OTHERS THEN
                     nNumError := SQLCODE;
                     cMsjError := SQLERRM;
                     cMsjError := '[' || nControl || ']' || cMsjError;
               END;
            ELSIF(cTipoDoc = cTipoDocRecibo)THEN
               BEGIN
                  nControl := 10;
                  UPDATE SICAS_OC.FACTURAS
                  SET FECVENC = NVL(dNewFechaIniD,FECVENC)
                     ,FECFINVIG = NVL(dNewFechaFinD,FECFINVIG)
                  WHERE IDPOLIZA  = nIdPoliza
                  AND IDETPOL = nIDetPol
                  AND IDENDOSO = nIdEndosoUpd
                  AND IDFACTURA = nIdTipoDoc
                  ;
               EXCEPTION
                  WHEN OTHERS THEN
                     nNumError := SQLCODE;
                     cMsjError := SQLERRM;
                     cMsjError := '[' || nControl || ']' || cMsjError;
               END;
            /*ELSE
               nControl := 11;
               nNumError := nControl;
               cMsjError := '[' || nControl || '] NO SE PUEDE IDENTIFICAR EL TIPO DE DOCUMENTO ' || cTipoDoc;
            */END IF;

            IF(nNumError = 0 AND nIdEndosoUpd != 0)THEN
               BEGIN
                  nControl := 12;
                  UPDATE SICAS_OC.ENDOSOS
                  SET FECINIVIG = NVL(dNewFechaIni,FECINIVIG)
                     ,FECFINVIG = NVL(dNewFechaFin,FECFINVIG)
                  WHERE IDPOLIZA  = nIdPoliza
                  AND IDENDOSO  = nIdEndosoUpd
                  AND IDETPOL = nIDetPol
                  ;
               EXCEPTION
                  WHEN OTHERS THEN
                     nNumError := SQLCODE;
                     cMsjError := SQLERRM;
                     cMsjError := '[' || nControl || ']' || cMsjError;
               END;
            END IF;

         ELSE
            nNumError := nControl;
            cMsjError := 'MOTIVO DE ENDOSO [' || cMotivo_Endoso || '] NO VALIDO. EL VALOR DE FECHAS QUE DESEA MODIFCIAR NO ES VALIDO. ' || dNewFechaIni || ' - ' || dNewFechaFin;
         END IF;
      ELSE
         nNumError := nControl;
         cMsjError := '[' || nNumError || '] VERIFICAR LOS DATOS INGRESADOS PARA LA ACTUALIZACION SOLICITADA.';
      END IF;

      IF(nNumError = 0)THEN
         SICAS_OC.OC_ENDOSO_SERVICIOS_WEB.ACTUALIZA_ENDOSO_EMITIDO_SW(nCodCia, nIdPoliza, nIDetPol, nIdEndoso, 'S'
                           ,USER,TRUNC(SYSDATE),nNumError , cMsjError);
         IF(nNumError = 0)THEN
            COMMIT;
            nNumError := 0;
            cMsjError := 'ACTUALIZACION DE FECHAS CORRECTAS.';
         END IF;
      ELSE
         ROLLBACK;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         ROLLBACK;
         nNumError := SQLCODE;
         cMsjError := SQLERRM;
         cMsjError := 'ERROR_GENERAL SICAS_OC.OC_ENDOSO.ACTUALIZA_FECHAS_VIG [' || nControl || '] <' || cMsjError || '>';
   END ACTUALIZA_FECHAS_VIG;

END OC_ENDOSO;
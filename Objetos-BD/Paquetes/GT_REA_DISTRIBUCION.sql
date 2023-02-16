CREATE OR REPLACE PACKAGE          GT_REA_DISTRIBUCION IS

PROCEDURE DISTRIBUYE_REASEGURO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                               nIdTransaccion NUMBER, dFecTransaccion DATE, cOrigen VARCHAR2);
PROCEDURE DISTRIBUYE_SINIESTROS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSiniestro NUMBER,
                               nIdTransaccion NUMBER, dFecTransaccion DATE);
FUNCTION NUMERO_DISTRIBUCION(nCodCia NUMBER) RETURN NUMBER;

FUNCTION DISTRIB_FACULTATIVA_PEND(nCodCia NUMBER, nIdTransaccion NUMBER) RETURN VARCHAR2;

FUNCTION EXISTE_DISTRIB_POLIZA(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) RETURN VARCHAR2;

FUNCTION EXISTE_DISTRIB_TRANSACCION(nCodCia NUMBER, nIdPoliza NUMBER, nIdTransaccion NUMBER) RETURN VARCHAR2;

FUNCTION EXISTE_DISTRIB_TRANSAC_SINI(nCodCia NUMBER, nIdSiniestro NUMBER, nIdTransaccion NUMBER) RETURN VARCHAR2;

FUNCTION EXISTE_DISTRIB_SINIESTRO(nCodCia NUMBER, nIdSiniestro NUMBER) RETURN VARCHAR2;

PROCEDURE ELIMINAR_DISTRIBUCION(nCodCia NUMBER, nIdPoliza NUMBER, nIdTransaccion NUMBER);

PROCEDURE ELIMINAR_DISTRIBUCION_SINI(nCodCia NUMBER, nIdSiniestro NUMBER, nIdTransaccion NUMBER);

END GT_REA_DISTRIBUCION;

/
create or replace PACKAGE BODY          GT_REA_DISTRIBUCION IS

PROCEDURE DISTRIBUYE_REASEGURO( nCodCia          NUMBER
                              , nCodEmpresa      NUMBER
                              , nIdPoliza        NUMBER
                              , nIdTransaccion   NUMBER
                              , dFecTransaccion  DATE
                              , cOrigen VARCHAR2 ) IS
   nIDetPol             DETALLE_POLIZA.IDetPol%TYPE;
   nIdEndoso            ENDOSOS.IdEndoso%TYPE;
   cCodRiesgoRea        COBERTURAS_DE_SEGUROS.CodRiesgoRea%TYPE;
   cCod_Moneda          COBERT_ACT.Cod_Moneda%TYPE;
   nSumaAsegPendDist    COBERT_ACT.SumaAseg_Moneda%TYPE;
   nPrimaPendDist       COBERT_ACT.Prima_Moneda%TYPE;
   nPorcDistrib         REA_DISTRIBUCION.PorcDistrib%TYPE;
   nSumaAsegDistrib     REA_DISTRIBUCION.SumaAsegDistrib%TYPE;
   nPrimaDistrib        REA_DISTRIBUCION.PrimaDistrib%TYPE;
   nIdDistribRea        REA_DISTRIBUCION.IdDistribRea%TYPE;
   nNumDistrib          REA_DISTRIBUCION.NumDistrib%TYPE;
   dFecIniVig           DETALLE_POLIZA.FecIniVig%TYPE;
   dFecFinVig           DETALLE_POLIZA.FecFinVig%TYPE;
   cCodEsquema          REA_ESQUEMAS_EMPRESAS.CodEsquema%TYPE;
   cCodEsquemaPol       REA_ESQUEMAS_EMPRESAS.CodEsquema%TYPE;
   nIdEsqContrato       REA_ESQUEMAS_EMPRESAS.IdEsqContrato%TYPE;
   nIdCapaContrato      REA_ESQUEMAS_EMPRESAS.IdCapaContrato%TYPE;
   nSumaAsegDistribEmp  REA_DISTRIBUCION_EMPRESAS.SumaAsegDistrib%TYPE; 
   nPrimaDistribEmp     REA_DISTRIBUCION_EMPRESAS.PrimaDistrib%TYPE;
   nMontoComision       REA_DISTRIBUCION_EMPRESAS.MontoComision%TYPE;
   nMontoReserva        REA_DISTRIBUCION_EMPRESAS.MontoReserva%TYPE;
   nPrimaDistribTot     REA_DISTRIBUCION_EMPRESAS.PrimaDistrib%TYPE;
   nSaldoInsoluto       REA_DISTRIBUCION_EMPRESAS.PrimaDistrib%TYPE;
   nFactorCreditos      REA_ESQUEMAS_FACT_CREDITOS.FactorCreditos%TYPE;
   nSumaCobertura       COBERT_ACT.SumaAseg_Moneda%TYPE;
   nFactorTarifa        REA_TARIFAS_REASEGURO_DET.FactorTarifa%TYPE;
   nFactorTarifaDiario  REA_TARIFAS_REASEGURO_DET.FactorTarifa%TYPE;
   cIndPolizaEspec      REA_RIESGOS.IndPolizaEspec%TYPE;
   dFecIniVigPol        POLIZAS.FecIniVig%TYPE;
   dFecFinVigPol        POLIZAS.FecFinVig%TYPE;
   cNaturalidad         PROPIEDADES_VALORES.Valor%TYPE;
   cStsDetalle          DETALLE_POLIZA.StsDetalle%TYPE;
   cStsEndoso           ENDOSOS.StsEndoso%TYPE;
   nDistrib             NUMBER;
   cExisteContrato      VARCHAR2(1);
   nEdadAsegurado       NUMBER(5);
   dFechaInicioCredito  DATE;
   nPlazoCredito        NUMBER(5);
   nMesesPrima          NUMBER(5);
   nDiasVigencia        NUMBER(5);
   --
   cTextoLog            CLOB;
   nContMovtos          NUMBER;
   --
   CURSOR TRAN_Q IS
      SELECT TO_NUMBER(NVL(Valor2,0))       IDetPol
           , MAX(TO_NUMBER(NVL(Valor3,0)))  IdEndoso
           , MAX(TRUNC(FechaTransaccion))   FechaTransaccion
           , MIN(DT.Correlativo)            Correlativo
           , MAX(T.IdProceso)               IdProceso
      FROM   TRANSACCION          T
         ,   DETALLE_TRANSACCION  DT
      WHERE  DT.MtoLocal      != 0
        AND  UPPER(DT.Objeto) IN ('DETALLE_POLIZA', 'ENDOSOS')--, 'NOTAS_DE_CREDITO')
        AND  DT.CodEmpresa     = T.CodEmpresa
        AND  DT.CodCia         = T.CodCia
        AND  DT.IdTransaccion  = T.IdTransaccion
        AND  T.IdTransaccion   = nIdTransaccion
        AND  T.CodEmpresa      = nCodEmpresa
        AND  T.CodCia          = nCodCia
      GROUP BY TO_NUMBER(NVL(Valor2,0));
   --
   CURSOR COB_Q IS
      SELECT DECODE(cIndPolizaEspec,'S',cCodRiesgoRea, CS.CodRiesgoRea) CodRiesgoRea, 
             CS.CodGrupoCobert, CA.Cod_Moneda, CA.Cod_Asegurado, 
             SUM(DECODE(NVL(CS.IndAcumulaPrimaRea,'N'),'S', C.Prima_Moneda, 0)) Prima_Moneda,
             SUM(DECODE(NVL(CS.IndAcumulaSumaRea,'N'),'S', C.Suma_Asegurada_Moneda, 0)) SumaAseg_Moneda
        FROM COBERTURAS C, COBERT_ACT CA, COBERTURAS_DE_SEGUROS CS
       WHERE CS.CodCobert     = C.CodCobert
         AND CS.PlanCob       = C.PlanCob
         AND CS.IdTipoSeg     = C.IdTipoSeg
         AND CS.CodEmpresa    = C.CodEmpresa
         AND CS.CodCia        = C.CodCia
         AND CS.CodRiesgoRea IS NOT NULL
         AND C.CodCobert      = CA.CodCobert
         AND C.IdEndoso       = nIdEndoso
         AND C.IDetPol        = CA.IDetPol
         AND C.IdPoliza       = CA.IdPoliza
         AND C.CodEmpresa     = CA.CodEmpresa
         AND C.CodCia         = CA.CodCia
         AND CA.StsCobertura != 'SOL'
         AND CA.IDetPol       = nIDetPol
         AND CA.IdPoliza      = nIdPoliza
         AND CA.CodEmpresa    = nCodEmpresa
         AND CA.CodCia        = nCodCia
         AND cIndPolizaEspec  = 'N'
       GROUP BY CS.CodRiesgoRea, CS.CodGrupoCobert, CA.Cod_Moneda, CA.Cod_Asegurado
       UNION ALL
      SELECT DECODE(cIndPolizaEspec,'S',cCodRiesgoRea, CS.CodRiesgoRea) CodRiesgoRea, 
             CS.CodGrupoCobert, CA.Cod_Moneda, CA.Cod_Asegurado, 
             SUM(DECODE(NVL(CS.IndAcumulaPrimaRea,'N'),'S', C.Prima_Moneda, 0)) Prima_Moneda,
             SUM(DECODE(NVL(CS.IndAcumulaSumaRea,'N'),'S', C.Suma_Asegurada_Moneda, 0)) SumaAseg_Moneda
        FROM COBERTURA_ASEG C, COBERT_ACT_ASEG CA, COBERTURAS_DE_SEGUROS CS
       WHERE CS.CodCobert     = C.CodCobert
         AND CS.PlanCob       = C.PlanCob
         AND CS.IdTipoSeg     = C.IdTipoSeg
         AND CS.CodEmpresa    = C.CodEmpresa
         AND CS.CodCia        = C.CodCia
         AND CS.CodRiesgoRea IS NOT NULL
         AND C.CodCobert      = CA.CodCobert
         AND C.Cod_Asegurado  = CA.Cod_Asegurado
         AND C.IdEndoso       = nIdEndoso
         AND C.IDetPol        = CA.IDetPol
         AND C.IdPoliza       = CA.IdPoliza
         AND C.CodEmpresa     = CA.CodEmpresa
         AND C.CodCia         = CA.CodCia
         AND CA.StsCobertura != 'SOL'
         AND CA.Cod_Asegurado > 0 
         AND CA.IDetPol       = nIDetPol
         AND CA.IdPoliza      = nIdPoliza
         AND CA.CodEmpresa    = nCodEmpresa
         AND CA.CodCia        = nCodCia
         AND cIndPolizaEspec  = 'N'
       GROUP BY CS.CodRiesgoRea, CS.CodGrupoCobert, CA.Cod_Moneda, CA.Cod_Asegurado
       UNION ALL
      SELECT DECODE(cIndPolizaEspec,'S',cCodRiesgoRea, CS.CodRiesgoRea) CodRiesgoRea, 
             CS.CodGrupoCobert, CA.Cod_Moneda, CA.Cod_Asegurado, 
             SUM(DECODE(NVL(CS.IndAcumulaPrimaRea,'N'),'S', C.Prima_Moneda, 0)) Prima_Moneda,
             SUM(DECODE(NVL(CS.IndAcumulaSumaRea,'N'),'S', C.Suma_Asegurada_Moneda, 0)) SumaAseg_Moneda
        FROM COBERTURAS C, COBERT_ACT CA, COBERTURAS_DE_SEGUROS CS
       WHERE CS.CodCobert     = C.CodCobert
         AND CS.PlanCob       = C.PlanCob
         AND CS.IdTipoSeg     = C.IdTipoSeg
         AND CS.CodEmpresa    = C.CodEmpresa
         AND CS.CodCia        = C.CodCia
         AND CS.CodRiesgoRea IS NOT NULL
         AND C.CodCobert      = CA.CodCobert
         AND C.IdEndoso       = nIdEndoso
         AND C.IDetPol        = CA.IDetPol
         AND C.IdPoliza       = CA.IdPoliza
         AND C.CodEmpresa     = CA.CodEmpresa
         AND C.CodCia         = CA.CodCia
         AND CA.StsCobertura != 'SOL'
         AND CA.IdEndoso      = nIdEndoso
         AND CA.IDetPol       = nIDetPol
         AND CA.IdPoliza      = nIdPoliza
         AND CA.CodEmpresa    = nCodEmpresa
         AND CA.CodCia        = nCodCia
         AND cIndPolizaEspec  = 'S'
         AND EXISTS (SELECT 'S'
                       FROM REA_ESQUEMAS_POLIZA_COBERT
                      WHERE CodCia          = nCodCia
                        AND CodEsquema      = cCodEsquemaPol
                        AND IdPoliza        = nIdPoliza
                        AND CodCobert       = C.CodCobert
                        AND IndCesionPrimas = 'S')
       GROUP BY CS.CodRiesgoRea, CS.CodGrupoCobert, CA.Cod_Moneda, CA.Cod_Asegurado
       UNION ALL
      SELECT DECODE(cIndPolizaEspec,'S',cCodRiesgoRea, CS.CodRiesgoRea) CodRiesgoRea, 
             CS.CodGrupoCobert, CA.Cod_Moneda, CA.Cod_Asegurado, 
             SUM(DECODE(NVL(CS.IndAcumulaPrimaRea,'N'),'S', C.Prima_Moneda, 0)) Prima_Moneda,
             SUM(DECODE(NVL(CS.IndAcumulaSumaRea,'N'),'S', C.Suma_Asegurada_Moneda, 0)) SumaAseg_Moneda
        FROM COBERTURA_ASEG C, COBERT_ACT_ASEG CA, COBERTURAS_DE_SEGUROS CS
       WHERE CS.CodCobert     = C.CodCobert
         AND CS.PlanCob       = C.PlanCob
         AND CS.IdTipoSeg     = C.IdTipoSeg
         AND CS.CodEmpresa    = C.CodEmpresa
         AND CS.CodCia        = C.CodCia
         AND CS.CodRiesgoRea IS NOT NULL
         AND C.CodCobert      = CA.CodCobert
         AND C.Cod_Asegurado  = CA.Cod_Asegurado
         AND C.IdEndoso       = nIdEndoso
         AND C.IDetPol        = CA.IDetPol
         AND C.IdPoliza       = CA.IdPoliza
         AND C.CodEmpresa     = CA.CodEmpresa
         AND C.CodCia         = CA.CodCia
         AND CA.StsCobertura != 'SOL'
         AND CA.Cod_Asegurado > 0 
         AND CA.IdEndoso      = nIdEndoso
         AND CA.IDetPol       = nIDetPol
         AND CA.IdPoliza      = nIdPoliza
         AND CA.CodEmpresa    = nCodEmpresa
         AND CA.CodCia        = nCodCia
         AND cIndPolizaEspec  = 'S'
         AND EXISTS (SELECT 'S'
                       FROM REA_ESQUEMAS_POLIZA_COBERT
                      WHERE CodCia          = nCodCia
                        AND CodEsquema      = cCodEsquemaPol
                        AND IdPoliza        = nIdPoliza
                        AND CodCobert       = C.CodCobert
                        AND IndCesionPrimas = 'S')
       GROUP BY CS.CodRiesgoRea, CS.CodGrupoCobert, CA.Cod_Moneda, CA.Cod_Asegurado;
   --
   CURSOR DIST_Q IS
      SELECT CA.CodCia, CA.CodEsquema, CA.IdEsqContrato, CA.IdCapaContrato,
             CA.PorcEsqContrato, CA.LimiteMaxCapa, CO.CodMoneda, CO.CodRiesgo,
             CO.CodContrato, CO.CodTarifaReaseg
        FROM REA_ESQUEMAS_CONTRATOS CO, REA_ESQUEMAS_CAPAS CA
       WHERE CA.FecVigInicial  <= TO_DATE(TO_CHAR(dFecIniVigPol,'DD/MM/YYYY HH:MI:SS'), 'DD/MM/YYYY HH:MI:SS')
         AND CA.FecVigFinal    >= TO_DATE(TO_CHAR(dFecIniVigPol,'DD/MM/YYYY HH:MI:SS'), 'DD/MM/YYYY HH:MI:SS')
         AND CA.StsCapaContrato = 'ACTIVO'
         AND CA.IdEsqContrato   = CO.IdEsqContrato
         AND CA.CodEsquema      = CO.CodEsquema
         AND CA.CodCia          = CO.CodCia
         AND CO.CodCia          = nCodCia
         AND CO.CodRiesgo       = cCodRiesgoRea
         AND CO.CodMoneda       = cCod_Moneda
         AND CO.FecVigInicial  <= TO_DATE(TO_CHAR(dFecIniVigPol,'DD/MM/YYYY HH:MI:SS'), 'DD/MM/YYYY HH:MI:SS')
         AND CO.FecVigFinal    >= TO_DATE(TO_CHAR(dFecIniVigPol,'DD/MM/YYYY HH:MI:SS'), 'DD/MM/YYYY HH:MI:SS')
         AND CO.StsEsqContrato  = 'ACTIVO'
         AND EXISTS (SELECT 'S'
                       FROM REA_ESQUEMAS
                      WHERE CodCia         = CO.CodCia
                        AND CodEsquema     = CO.CodEsquema
                        AND IndPolizas     = 'N'
                        AND cCodEsquemaPol IS NULL)
       UNION 
      SELECT CA.CodCia, CA.CodEsquema, CA.IdEsqContrato, CA.IdCapaContrato,
             CA.PorcEsqContrato, CA.LimiteMaxCapa, CO.CodMoneda, CO.CodRiesgo,
             CO.CodContrato, CO.CodTarifaReaseg
        FROM REA_ESQUEMAS_CONTRATOS CO, REA_ESQUEMAS_CAPAS CA
       WHERE CA.FecVigInicial  <= TO_DATE(TO_CHAR(dFecIniVigPol,'DD/MM/YYYY HH:MI:SS'), 'DD/MM/YYYY HH:MI:SS')
         AND CA.FecVigFinal    >= TO_DATE(TO_CHAR(dFecIniVigPol,'DD/MM/YYYY HH:MI:SS'), 'DD/MM/YYYY HH:MI:SS')
         AND CA.StsCapaContrato = 'ACTIVO'
         AND CA.IdEsqContrato   = CO.IdEsqContrato
         AND CA.CodEsquema      = CO.CodEsquema
         AND CA.CodCia          = CO.CodCia
         AND CO.CodCia          = nCodCia
         AND CO.CodRiesgo       = cCodRiesgoRea
         AND CO.CodMoneda       = cCod_Moneda
         AND CO.FecVigInicial  <= TO_DATE(TO_CHAR(dFecIniVigPol,'DD/MM/YYYY HH:MI:SS'), 'DD/MM/YYYY HH:MI:SS')
         AND CO.FecVigFinal    >= TO_DATE(TO_CHAR(dFecIniVigPol,'DD/MM/YYYY HH:MI:SS'), 'DD/MM/YYYY HH:MI:SS')
         AND CO.StsEsqContrato  = 'ACTIVO'
         AND EXISTS (SELECT 'S'
                       FROM REA_ESQUEMAS
                      WHERE CodCia          = CO.CodCia
                        AND CodEsquema      = CO.CodEsquema
                        AND IndPolizas      = 'S'
                        AND CodEsquema      = cCodEsquemaPol 
                        AND cCodEsquemaPol IS NOT NULL)
       ORDER BY IdEsqContrato, IdCapaContrato;
   --
   CURSOR EMP_Q IS
      SELECT CodEmpresaGremio, CodInterReaseg, PorcEmpresa, 
             PorcComisBasica, PorcRvaPrimas, CuotaReaseg,
             PrimaReaseg, IdEsqContrato, IdCapaContrato,
             NVL(FactProrrateo,1) FactProrrateo
        FROM REA_ESQUEMAS_EMPRESAS
       WHERE CodCia         = nCodCia
         AND CodEsquema     = cCodEsquema
         AND IdEsqContrato  = nIdEsqContrato
         AND IdCapaContrato = nIdCapaContrato
         AND StsEsqEmpresa  = 'ACTIVO';
BEGIN
   SELECT COUNT(*)
   INTO   nDistrib
   FROM   REA_DISTRIBUCION
   WHERE  CodCia        = nCodCia
     AND  IdPoliza      = nIdPoliza
     AND  IdTransaccion = nIdTransaccion;
   --
   IF NVL(nDistrib,0) = 0 THEN
      nIdDistribRea   := GT_REA_DISTRIBUCION.NUMERO_DISTRIBUCION(nCodCia);
      nNumDistrib     := 0;
      cCodEsquemaPol  := GT_REA_ESQUEMAS_POLIZAS.ESQUEMA_POLIZA(nCodCia, nIdPoliza);
      cCodRiesgoRea   := OC_POLIZAS.CODIGO_RIESGO_REASEGURO(nCodCia, nCodEmpresa, nIdPoliza);
      cIndPolizaEspec := GT_REA_RIESGOS.INDICADORES(nCodCia, cCodRiesgoRea, 'POLESP');
      --
      IF (GT_REA_ESQUEMAS.APLICA_DISTRIBUCION(nCodCia, cCodEsquemaPol) = 'TODOS' OR 
         (GT_REA_ESQUEMAS.APLICA_DISTRIBUCION(nCodCia, cCodEsquemaPol) = 'INICIAL' AND
         cOrigen IN ('EMISION','ANULAPOL'))) THEN
         --
         BEGIN
            SELECT FecIniVig, FecFinVig
            INTO   dFecIniVigPol, dFecFinVigPol
            FROM   POLIZAS
            WHERE  CodCia     = nCodCia
              AND  CodEmpresa = nCodEmpresa
              AND  IdPoliza   = nIdPoliza;
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cTextoLog := 'No Existe Póliza No. '|| nIdPoliza;
            OC_DISTRIBUCION_MASIVA_LOG.INSERTA_LOG( nCodCia, nCodEmpresa, nIdPoliza, nIdTransaccion, -20100, cTextoLog );
            RAISE_APPLICATION_ERROR ( -20100, cTextoLog );
         END;
         --
         FOR X IN TRAN_Q LOOP
            nIDetPol  := X.IDetPol;
            nIdEndoso := X.IdEndoso;
            --
            -- Determina Fechas de Vigencia de Endoso o Detalle de Póliza
            IF nIdEndoso = 0 THEN
               BEGIN
                  SELECT FecIniVig, FecFinVig, StsDetalle
                  INTO   dFecIniVig, dFecFinVig, cStsDetalle
                  FROM   DETALLE_POLIZA
                  WHERE  CodCia     = nCodCia
                    AND  CodEmpresa = nCodEmpresa
                    AND  IdPoliza   = nIdPoliza
                    AND  IDetPol    = nIDetPol;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cTextoLog := 'No Existe Detalle de Póliza '|| nIDetPol || ' para la Póliza ' || nIdPoliza;
                  OC_DISTRIBUCION_MASIVA_LOG.INSERTA_LOG( nCodCia, nCodEmpresa, nIdPoliza, nIdTransaccion, -20100, cTextoLog );
                  RAISE_APPLICATION_ERROR ( -20100, cTextoLog );
               END;
               --
               IF X.IdProceso IN (3, 7, 18) THEN 
                  cNaturalidad := '+';
               ELSIF cStsDetalle NOT IN ('ANU', 'EXC') THEN
                  cNaturalidad := '+';
               ELSE
                  cNaturalidad := '-';
               END IF;
            ELSE
               BEGIN
                  SELECT FecIniVig, FecFinVig, StsEndoso, OC_ENDOSO.NATURALIDAD(TipoEndoso)
                  INTO   dFecIniVig, dFecFinVig, cStsEndoso, cNaturalidad
                  FROM   ENDOSOS
                  WHERE  CodCia     = nCodCia
                    AND  CodEmpresa = nCodEmpresa
                    AND  IdPoliza   = nIdPoliza
                    AND  IDetPol    = nIDetPol
                    AND  IdEndoso   = nIdEndoso;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cTextoLog := 'No Existe Endoso '|| nIdEndoso || ' para la Póliza ' || nIdPoliza;
                  OC_DISTRIBUCION_MASIVA_LOG.INSERTA_LOG( nCodCia, nCodEmpresa, nIdPoliza, nIdTransaccion, -20100, cTextoLog );
                  RAISE_APPLICATION_ERROR ( -20100, cTextoLog );
               END;
               --
               IF cStsEndoso = 'ANU' THEN
                  cNaturalidad := '-';
               END IF;
            END IF;
            cExisteContrato  := 'N';
            --Punto de control
            --
            nContMovtos := 0;
            FOR W IN COB_Q LOOP
               nContMovtos    := 1; --Para indicar que entró al cursor y tiene movimientos
               cCodRiesgoRea  := W.CodRiesgoRea;
               cCod_Moneda    := W.Cod_Moneda;
               nSumaCobertura := W.SumaAseg_Moneda;
               --
               IF cCodEsquemaPol IS NULL THEN
                  SELECT MAX(CodEsquema)
                  INTO   cCodEsquema
                  FROM   REA_ESQUEMAS_CONTRATOS
                  WHERE  CodCia          = nCodCia
                    AND  CodRiesgo       = cCodRiesgoRea
                    AND  CodMoneda       = cCod_Moneda
                    AND  FecVigInicial  <= dFecTransaccion
                    AND  FecVigFinal    >= dFecTransaccion
                    AND  StsEsqContrato  = 'ACTIVO';
               ELSE
                  cCodEsquema   := cCodEsquemaPol;
               END IF;
               --
               IF GT_REA_ESQUEMAS.TIPO_DISTRIBUCION(nCodCia, cCodEsquema) = 'SALINS' THEN
                  nSaldoInsoluto      := GT_REA_ESQUEMAS_DATOS_CREDITO.SALDO_INSOLUTO(nCodCia, nCodEmpresa, cCodEsquema, nIdPoliza, nIDetPol);
                  nSumaAsegPendDist   := NVL(nSaldoInsoluto,0);
                  nSumaCobertura      := NVL(nSaldoInsoluto,0);
                  dFechaInicioCredito := GT_REA_ESQUEMAS_DATOS_CREDITO.FECHA_INICIO_CREDITO(nCodCia, nCodEmpresa, cCodEsquema, nIdPoliza, nIDetPol);
                  nPlazoCredito       := GT_REA_ESQUEMAS_DATOS_CREDITO.PLAZO_DEL_CREDITO(nCodCia, nCodEmpresa, cCodEsquema, nIdPoliza, nIDetPol);
                  nMesesPrima         := NVL(nPlazoCredito,0) + GT_REA_ESQUEMAS_FACT_CREDITOS.PERIODO_VARIABLE(nCodCia, cCodEsquema, dFechaInicioCredito);
                  nFactorCreditos     := GT_REA_ESQUEMAS_FACT_CREDITOS.FACTOR_CREDITO(nCodCia, cCodEsquema, dFechaInicioCredito);
                  nPrimaPendDist      := ((NVL(nSaldoInsoluto,0) * nFactorCreditos) / 1000) * NVL(nMesesPrima,0);
               ELSE
                  nSumaAsegPendDist   := W.SumaAseg_Moneda;
                  nPrimaPendDist      := W.Prima_Moneda;
               END IF;
               --
               nEdadAsegurado    := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, W.Cod_Asegurado, dFecIniVig);
               --
               IF cNaturalidad = '-' THEN
                  nSumaAsegPendDist   := nSumaAsegPendDist * -1;
                  nPrimaPendDist      := nPrimaPendDist * -1;
                  nSumaCobertura      := nSumaCobertura * -1;
                  nSaldoInsoluto      := nSaldoInsoluto * -1;
               END IF;
               --
               FOR Z IN DIST_Q LOOP
                  cExisteContrato  := 'S';
                  nNumDistrib      := NVL(nNumDistrib,0) + 1;
                  nSumaAsegDistrib := (NVL(nSumaAsegPendDist,0) * (Z.PorcEsqContrato / 100));
                  nPrimaDistrib    := (NVL(nPrimaPendDist,0) * (Z.PorcEsqContrato / 100));
                  --
                  IF ABS(nSumaAsegDistrib) > Z.LimiteMaxCapa AND Z.LimiteMaxCapa > 0 THEN
                     nSumaAsegDistrib := Z.LimiteMaxCapa;
                     IF cNaturalidad = '-' THEN
                        nSumaAsegDistrib := nSumaAsegDistrib * -1;
                     END IF;
                     nPorcDistrib     := (ABS(nSumaAsegDistrib) / nSumaCobertura) * 100;
                     nPrimaDistrib    := (NVL(nPrimaPendDist,0) * (nPorcDistrib / 100));                
                  ELSE
                     nPorcDistrib     := (nSumaAsegDistrib / nSumaCobertura) * 100;
                  END IF;
                  --
                  INSERT INTO REA_DISTRIBUCION
                         ( CodCia, IdDistribRea, NumDistrib, IdPoliza, IDetPol, IdEndoso, IdSiniestro, IdTransaccion, CodEsquema, IdEsqContrato, IdCapaContrato,
                           CodRiesgoReaseg, FecVigInicial, FecVigFinal, FecMovDistrib, CodMoneda, PorcDistrib, SumaAsegDistrib, PrimaDistrib, MontoReserva,
                           MtoSiniDistrib, CapacidadMaxima, IndTraspaso, StsDistribucion, FecStatus, Cod_Asegurado, CodGrupoCobert )
                  VALUES ( nCodCia, nIdDistribRea, nNumDistrib, nIdPoliza, nIDetPol, nIdEndoso, 0, nIdTransaccion, Z.CodEsquema, Z.IdEsqContrato, Z.IdCapaContrato,
                           Z.CodRiesgo, dFecIniVig, dFecFinVig, dFecTransaccion, Z.CodMoneda, nPorcDistrib, nSumaAsegDistrib, nPrimaDistrib, 0,
                           0, Z.LimiteMaxCapa, 'N', 'ACTIVA', TRUNC(SYSDATE), W.Cod_Asegurado, W.CodGrupoCobert);
                  --
                  -- Distribuye por Empresa del Gremio Reaseguradora lo Cedido al Contrato
                  cCodEsquema     := Z.CodEsquema;
                  nIdEsqContrato  := Z.IdEsqContrato;
                  nIdCapaContrato := Z.IdCapaContrato;
                  --
                  FOR Y IN EMP_Q LOOP
                     nSumaAsegDistribEmp := NVL(nSumaAsegDistrib,0) * (Y.PorcEmpresa / 100);
                     IF GT_REA_ESQUEMAS.TIPO_DISTRIBUCION(nCodCia, cCodEsquema) = 'CUOTA' THEN
                        nPrimaDistribEmp    := NVL(nSumaAsegDistribEmp,0) * (Y.CuotaReaseg / 1000) * Y.FactProrrateo;
                     ELSIF GT_REA_ESQUEMAS.TIPO_DISTRIBUCION(nCodCia, cCodEsquema) = 'PRIMA' THEN
                        nPrimaDistribEmp    := Y.PrimaReaseg;
                        IF cNaturalidad = '-' THEN
                           nPrimaDistribEmp := nPrimaDistribEmp * -1;
                        END IF;
                     ELSIF GT_REA_ESQUEMAS.TIPO_DISTRIBUCION(nCodCia, cCodEsquema) = 'GRUPO' THEN
                        nPrimaDistribEmp    := (NVL(nPrimaDistrib,0) * 
                                               GT_REA_ESQUEMAS_POLIZAS.FACTOR_CESION(nCodCia, cCodEsquema, nIdPoliza)) *
                                               (Y.PorcEmpresa / 100);
                     ELSIF Z.CodTarifaReaseg IS NOT NULL AND
                        GT_REA_TARIFAS_REASEGURO.VIGENCIA_TARIFA(nCodCia, Z.CodTarifaReaseg, X.FechaTransaccion) = 'S' THEN
                        nFactorTarifa       := GT_REA_TARIFAS_REASEGURO_DET.FACTOR_TARIFA(nCodCia, Z.CodTarifaReaseg, W.CodGrupoCobert,
                                                                                          nEdadAsegurado, Y.CodEmpresaGremio);
                        nFactorTarifaDiario := nFactorTarifa / 365;
                        nDiasVigencia       := dFecFinVig - dFecIniVig;
                        nPrimaDistribEmp    := NVL(nSumaAsegDistribEmp,0) * nFactorTarifaDiario * nDiasVigencia / 1000;
                     ELSIF GT_REA_ESQUEMAS.TIPO_DISTRIBUCION(nCodCia, cCodEsquema) = 'SALINS' AND
                        GT_REA_ESQUEMAS_FACT_CREDITOS.PERIODO_POR_REASEGURADOR(nCodCia, cCodEsquema, dFechaInicioCredito) = 'S' THEN
                        nMesesPrima         := NVL(nPlazoCredito,0) + 
                                               GT_REA_ESQUEMAS_EMPRESAS.PERIODO_VARIABLE(nCodCia, cCodEsquema, Y.IdEsqContrato,
                                                                                        Y.IdCapaContrato, Y.CodEmpresaGremio, Y.CodInterReaseg);
                        nPrimaDistribEmp    := ((NVL(nSaldoInsoluto,0) * nFactorCreditos) / 1000) * NVL(nMesesPrima,0) *
                                               (nPorcDistrib / 100) * (Y.PorcEmpresa / 100);
                     ELSE
                        nPrimaDistribEmp    := NVL(nPrimaDistrib,0) * (Y.PorcEmpresa / 100);
                     END IF;
                     --
                     nMontoComision      := NVL(nPrimaDistribEmp,0) * (Y.PorcComisBasica / 100);
                     nMontoReserva       := NVL(nPrimaDistribEmp,0) * (Y.PorcRvaPrimas / 100);
                     --
                     INSERT INTO REA_DISTRIBUCION_EMPRESAS
                            ( CodCia, IdDistribRea, NumDistrib, CodEmpresaGremio, CodInterReaseg, CodMoneda, PorcDistrib, SumaAsegDistrib, PrimaDistrib, MontoComision,
                              MontoReserva, MtoSiniDistrib, IdLiquidacion, IntRvasLiberadas, ImpRvasLiberadas, FecLiberacionRvas, StsDistribEmpresa, FecStatus )
                     VALUES ( nCodCia, nIdDistribRea, nNumDistrib, Y.CodEmpresaGremio, Y.CodInterReaseg, Z.CodMoneda, Y.PorcEmpresa, nSumaAsegDistribEmp, nPrimaDistribEmp, nMontoComision,
                              nMontoReserva, 0, NULL, 0, 0, NULL, 'ACTIVA', TRUNC(SYSDATE));
                  END LOOP;
                  --
                  /* Distribución Facultativa Heredada de Transaccion Anterior para Cancelaciones o Disminuciones
                  IF GT_REA_DISTRIBUCION_EMPRESAS.POSEE_DISTRIB_EMPRESAS(nCodCia, nIdDistribRea, nNumDistrib) = 'N' AND
                     GT_REA_TIPOS_CONTRATOS.CONTRATO_FACULTATIVO(nCodCia, X.CodContrato) = 'S' THEN
                  END IF;*/
                  --
                  -- Actualiza Monto de Reserva
                  nMontoReserva    := GT_REA_DISTRIBUCION_EMPRESAS.MONTO_RESERVA(nCodCia, nIdDistribRea, nNumDistrib);
                  nPrimaDistribTot := GT_REA_DISTRIBUCION_EMPRESAS.PRIMA_DISTRIBUIDA(nCodCia, nIdDistribRea, nNumDistrib);
                  --
                  UPDATE REA_DISTRIBUCION
                  SET    MontoReserva = nMontoReserva
                    ,    PrimaDistrib = nPrimaDistribTot
                  WHERE  CodCia       = nCodCia
                    AND  IdDistribRea = nIdDistribRea
                    AND  NumDistrib   = nNumDistrib;
                  --
                  -- Controla si ya se distribuyó el 100% de la Suma Asegurada y Prima
                  nPrimaPendDist    := NVL(nPrimaPendDist,0) - NVL(nPrimaDistrib,0);
                  nSumaAsegPendDist := NVL(nSumaAsegPendDist,0) - NVL(nSumaAsegDistrib,0);
                  --
                  IF ((NVL(nSumaAsegPendDist,0) <= 0 AND cNaturalidad = '+') OR (NVL(nSumaAsegPendDist,0) >= 0 AND cNaturalidad = '-')) THEN
                     EXIT;
                  END IF;
               END LOOP;
               --
               cTextoLog := NULL;
               IF cCodEsquema IS NULL THEN
                  cTextoLog := 'cCodEsquema, ';
               END IF;
               --
               IF dFecIniVigPol IS NULL THEN
                  cTextoLog := 'dFecIniVigPol, ';
               END IF;
               --
               IF cCodRiesgoRea IS NULL THEN
                  cTextoLog := 'cCodRiesgoRea, ';
               END IF;
               --
               IF cCodEsquemaPol IS NULL THEN
                  cTextoLog := 'cCodEsquemaPol, ';
               END IF;
               --
               IF cCod_Moneda IS NULL THEN
                  cTextoLog := 'cCod_Moneda, ';
               END IF;
               --
               IF cTextoLog IS NOT NULL THEN
                  cTextoLog := W.CodGrupoCobert || ' NO se ha Distribuido la Suma Asegurada, los siguientes campos vienen nulos: ' || cTextoLog ||
                               ' Verifique la Configuración del Esquema de Reaseguro para el Riesgo ' || cCodRiesgoRea;
                  OC_DISTRIBUCION_MASIVA_LOG.INSERTA_LOG( nCodCia, nCodEmpresa, nIdPoliza, nIdTransaccion, -20100, cTextoLog );
                  RAISE_APPLICATION_ERROR ( -20100, cTextoLog );
               END IF;
               --
               IF NVL(nSumaAsegPendDist,0) != 0 AND cExisteContrato = 'S' THEN
                  cTextoLog := W.CodGrupoCobert || ' NO se ha Distribuido toda la Suma Asegurada. ' || nSumaAsegPendDist || ' - ' || nSumaAsegDistrib || ' ' ||
                               'Verifique la Configuración del Esquema de Reaseguro para el Riesgo '||cCodRiesgoRea;
                  OC_DISTRIBUCION_MASIVA_LOG.INSERTA_LOG( nCodCia, nCodEmpresa, nIdPoliza, nIdTransaccion, -20100, cTextoLog );
                  RAISE_APPLICATION_ERROR ( -20100, cTextoLog );
               END IF;
            END LOOP;
            --
            IF nContMovtos = 0 THEN
               cTextoLog := 'NO se ha Distribuido la Póliza/Transacción: ' || nIdPoliza || ' / ' || nIdTransaccion || ' No existen Asegurados/Coberturas';
               OC_DISTRIBUCION_MASIVA_LOG.INSERTA_LOG( nCodCia, nCodEmpresa, nIdPoliza, nIdTransaccion, -20100, cTextoLog );
               RAISE_APPLICATION_ERROR ( -20100, cTextoLog );
            END IF;
         END LOOP;
      END IF;
   ELSE
      cTextoLog := 'Ya existe Distribución de Reaseguro de Póliza ' || nIdPoliza || ' y Transacción No. ' || nIdTransaccion;
      OC_DISTRIBUCION_MASIVA_LOG.INSERTA_LOG( nCodCia, nCodEmpresa, nIdPoliza, nIdTransaccion, -20100, cTextoLog );
   END IF;
EXCEPTION
WHEN OTHERS THEN
   cTextoLog := 'ERROR en Distribución de Reaseguro de Póliza No. ' || nIdPoliza || ' y Certificado No. ' || nIDetPol || ' - ' || ' Transaccion ' || nIdTransaccion || ' - ' || SQLERRM;
   OC_DISTRIBUCION_MASIVA_LOG.INSERTA_LOG( nCodCia, nCodEmpresa, nIdPoliza, nIdTransaccion, -20100, cTextoLog );
END DISTRIBUYE_REASEGURO;

PROCEDURE DISTRIBUYE_SINIESTROS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSiniestro NUMBER,
                                nIdTransaccion NUMBER, dFecTransaccion DATE) IS
nIdPoliza            POLIZAS.IdPoliza%TYPE;
nIDetPol             DETALLE_POLIZA.IDetPol%TYPE;
nIdEndoso            ENDOSOS.IdEndoso%TYPE;
cCodRiesgoRea        COBERTURAS_DE_SEGUROS.CodRiesgoRea%TYPE;
cCod_Moneda          COBERT_ACT.Cod_Moneda%TYPE;
cCodGrupoCobert      REA_DISTRIBUCION.CodGrupoCobert%TYPE;
nIdDistribRea        REA_DISTRIBUCION.IdDistribRea%TYPE;
nNumDistrib          REA_DISTRIBUCION.NumDistrib%TYPE;
nNumDistribEmpPol    REA_DISTRIBUCION.NumDistrib%TYPE;
nIdDistribReaPol     REA_DISTRIBUCION.IdDistribRea%TYPE;
nNumDistribPol       REA_DISTRIBUCION.NumDistrib%TYPE;
dFecIniVig           DETALLE_POLIZA.FecIniVig%TYPE;
dFecFinVig           DETALLE_POLIZA.FecFinVig%TYPE;
nMtoSiniDistrib      REA_DISTRIBUCION_EMPRESAS.MtoSiniDistrib%TYPE;
nMtoSiniDistribEmp   REA_DISTRIBUCION_EMPRESAS.MtoSiniDistrib%TYPE;
dFec_Ocurrencia      SINIESTRO.Fec_Ocurrencia%TYPE;
cSigno_Concepto      CATALOGO_DE_CONCEPTOS.Signo_Concepto%TYPE;
nDistrib             NUMBER;
nMtoSiniDistribAcum  REA_DISTRIBUCION.MtoSiniDistrib%TYPE;
nMtoSiniPendDist     REA_DISTRIBUCION.MtoSiniDistrib%TYPE;
nPorcDistrib         REA_DISTRIBUCION.PorcDistrib%TYPE;
cCodEsquemaPol       REA_ESQUEMAS_EMPRESAS.CodEsquema%TYPE;
nCod_Asegurado       REA_DISTRIBUCION.Cod_Asegurado%TYPE;

CURSOR TRAN_Q IS
   SELECT TO_NUMBER(NVL(Valor2,0)) IdPoliza, TO_NUMBER(NVL(Valor1,0)) IdSiniestro,
          MAX(TRUNC(FechaTransaccion)) FechaTransaccion, MIN(DT.Correlativo) Correlativo
     FROM TRANSACCION T, DETALLE_TRANSACCION DT
    WHERE DT.MtoLocal      != 0
      AND UPPER(DT.Objeto) IN ('COBERTURA_SINIESTRO','COBERTURA_SINIESTRO_ASEG','APROBACIONES', 'APROBACION_ASEG')
      AND DT.CodEmpresa     = T.CodEmpresa
      AND DT.CodCia         = T.CodCia
      AND DT.IdTransaccion  = T.IdTransaccion
      AND T.IdTransaccion   = nIdTransaccion
      AND T.CodEmpresa      = nCodEmpresa
      AND T.CodCia          = nCodCia
    GROUP BY TO_NUMBER(NVL(Valor2,0)), TO_NUMBER(NVL(Valor1,0));
CURSOR COB_Q IS
   SELECT CS.CodRiesgoRea, C.CodCobert, C.CodCptoTransac, S.Cod_Moneda, S.Cod_Asegurado, 
          CS.CodGrupoCobert, 'COBERT' TipoDist, C.StsCobertura Status,
          SUM(DECODE(NVL(CS.IndAcumulaPrimaRea,'N'),'S', C.Monto_Reservado_Moneda, 0)) Monto_Reservado_Moneda
     FROM DETALLE_POLIZA D, COBERTURA_SINIESTRO C, SINIESTRO S, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert    = C.CodCobert
      AND CS.PlanCob      = D.PlanCob
      AND CS.IdTipoSeg    = D.IdTipoSeg
      AND CS.CodEmpresa   = S.CodEmpresa
      AND CS.CodCia       = S.CodCia
      AND C.IdTransaccion = nIdTransaccion
      AND C.IdSiniestro   = S.IdSiniestro
      AND D.CodEmpresa    = S.CodEmpresa
      AND D.CodCia        = S.CodCia
      AND D.IDetPol       = S.IDetPol
      AND D.IdPoliza      = S.IdPoliza
      AND S.CodEmpresa    = nCodEmpresa
      AND S.CodCia        = nCodCia
      AND S.IdSiniestro   = nIdSiniestro
    GROUP BY CS.CodRiesgoRea, C.CodCobert, C.CodCptoTransac, S.Cod_Moneda, S.Cod_Asegurado,
             CS.CodGrupoCobert, 'COBERT', C.StsCobertura
    UNION
   SELECT CS.CodRiesgoRea, C.CodCobert,C.CodCptoTransac, S.Cod_Moneda, S.Cod_Asegurado,
          CS.CodGrupoCobert, 'COBERT' TipoDist, C.StsCobertura Status,
          SUM(DECODE(NVL(CS.IndAcumulaPrimaRea,'N'),'S',C.Monto_Reservado_Moneda,0)) Monto_Reservado_Moneda
     FROM DETALLE_POLIZA D, COBERTURA_SINIESTRO_ASEG C, SINIESTRO S, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert    = C.CodCobert
      AND CS.PlanCob      = D.PlanCob
      AND CS.IdTipoSeg    = D.IdTipoSeg
      AND CS.CodEmpresa   = S.CodEmpresa
      AND CS.CodCia       = S.CodCia
      AND C.IdTransaccion = nIdTransaccion
      AND C.IdSiniestro   = S.IdSiniestro
      AND D.CodEmpresa    = S.CodEmpresa
      AND D.CodCia        = S.CodCia
      AND D.IDetPol       = S.IDetPol
      AND D.IdPoliza      = S.IdPoliza
      AND S.CodEmpresa    = nCodEmpresa
      AND S.CodCia        = nCodCia
      AND S.IdSiniestro   = nIdSiniestro
    GROUP BY CS.CodRiesgoRea, C.CodCobert, C.CodCptoTransac, S.Cod_Moneda, S.Cod_Asegurado, 
             CS.CodGrupoCobert, 'COBERT', C.StsCobertura
    UNION
   SELECT CS.CodRiesgoRea, DA.Cod_Pago CodCobert, DA.CodCptoTransac, S.Cod_Moneda, S.Cod_Asegurado, 
          CS.CodGrupoCobert, 'APROBA' TipoDist, A.StsAprobacion Status,
          SUM(DECODE(NVL(CS.IndAcumulaPrimaRea,'N'),'S', A.Monto_Moneda * ((DA.Monto_Moneda*100) / A.Monto_Moneda) / 100, 0)) Monto_Reservado_Moneda
     FROM DETALLE_POLIZA D, DETALLE_APROBACION DA, APROBACIONES A, SINIESTRO S, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert        = DA.Cod_Pago
      AND CS.PlanCob          = D.PlanCob
      AND CS.IdTipoSeg        = D.IdTipoSeg
      AND CS.CodEmpresa       = S.CodEmpresa
      AND CS.CodCia           = S.CodCia
      AND DA.Num_Aprobacion   = A.Num_Aprobacion
      AND DA.IdSiniestro      = S.IdSiniestro
      AND (A.IdTransaccion    = nIdTransaccion
       OR A.IdTransaccionAnul = nIdTransaccion)
      AND A.IdPoliza          = S.IdPoliza
      AND A.IdSiniestro       = S.IdSiniestro
      AND D.CodEmpresa        = S.CodEmpresa
      AND D.CodCia            = S.CodCia
      AND D.IDetPol           = S.IDetPol
      AND D.IdPoliza          = S.IdPoliza
      AND S.CodEmpresa        = nCodEmpresa
      AND S.CodCia            = nCodCia
      AND S.IdSiniestro       = nIdSiniestro
    GROUP BY CS.CodRiesgoRea, DA.Cod_Pago, DA.CodCptoTransac, S.Cod_Moneda, S.Cod_Asegurado, 
             CS.CodGrupoCobert, 'APROBA', A.StsAprobacion
    UNION
   SELECT CS.CodRiesgoRea, DA.Cod_Pago CodCobert, DA.CodCptoTransac, S.Cod_Moneda, S.Cod_Asegurado,
          CS.CodGrupoCobert, 'APROBA' TipoDist, A.StsAprobacion Status,
          SUM(DECODE(NVL(CS.IndAcumulaPrimaRea,'N'),'S', A.Monto_Moneda * ((DA.Monto_Moneda*100) / A.Monto_Moneda) / 100, 0)) Monto_Reservado_Moneda
     FROM DETALLE_POLIZA D, DETALLE_APROBACION_ASEG DA, APROBACION_ASEG A, SINIESTRO S, COBERTURAS_DE_SEGUROS CS
    WHERE CS.CodCobert        = DA.Cod_Pago
      AND CS.PlanCob          = D.PlanCob
      AND CS.IdTipoSeg        = D.IdTipoSeg
      AND CS.CodEmpresa       = S.CodEmpresa
      AND CS.CodCia           = S.CodCia
      AND DA.Num_Aprobacion   = A.Num_Aprobacion
      AND DA.IdSiniestro      = S.IdSiniestro
      AND (A.IdTransaccion    = nIdTransaccion
       OR A.IdTransaccionAnul = nIdTransaccion)
      AND A.IdPoliza          = S.IdPoliza
      AND A.IdSiniestro       = S.IdSiniestro
      AND D.CodEmpresa        = S.CodEmpresa
      AND D.CodCia            = S.CodCia
      AND D.IDetPol           = S.IDetPol
      AND D.IdPoliza          = S.IdPoliza
      AND S.CodEmpresa        = nCodEmpresa
      AND S.CodCia            = nCodCia
      AND S.IdSiniestro       = nIdSiniestro
    GROUP BY CS.CodRiesgoRea, DA.Cod_Pago,  DA.CodCptoTransac, S.Cod_Moneda, S.Cod_Asegurado, 
             CS.CodGrupoCobert, 'APROBA', A.StsAprobacion;

CURSOR DIST_POL_Q IS
   SELECT RD.CodEsquema, RD.IdEsqContrato, RD.IdCapaContrato, RD.CodRiesgoReaseg,
          RD.PorcDistrib, RD.CapacidadMaxima, RD.NumDistrib, CA.PorcEsqContrato, 
          CA.LimiteMaxCapa
     FROM REA_DISTRIBUCION RD, REA_ESQUEMAS_CONTRATOS CO, REA_ESQUEMAS_CAPAS CA
    WHERE CA.IdCapaContrato  = RD.IdCapaContrato
      AND CA.IdEsqContrato   = CO.IdEsqContrato
      AND CA.CodEsquema      = CO.CodEsquema
      AND CA.CodCia          = CO.CodCia
      AND CO.CodCia          = RD.CodCia
      AND CO.CodRiesgo       = RD.CodRiesgoReaseg
      AND CO.CodEsquema      = RD.CodEsquema
      AND CO.IdEsqContrato   = RD.IdEsqContrato
      AND RD.CodCia          = nCodCia
      AND RD.Cod_Asegurado   = nCod_Asegurado
      AND RD.IdDistribRea    = nIdDistribReaPol
      AND RD.NumDistrib     >= nNumDistribPol
      AND ((RD.CodGrupoCobert  = cCodGrupoCobert
      AND  cCodGrupoCobert  IS NOT NULL)
       OR (RD.CodGrupoCobert  IS NULL
      AND cCodGrupoCobert  IS NULL))
    ORDER BY RD.CodEsquema, RD.IdEsqContrato, RD.IdCapaContrato;

CURSOR EMP_POL_Q IS
   SELECT CodEmpresaGremio, CodInterReaseg, PorcDistrib
     FROM REA_DISTRIBUCION_EMPRESAS
    WHERE CodCia        = nCodCia
      AND IdDistribRea  = nIdDistribReaPol
      AND NumDistrib    = nNumDistribEmpPol;
BEGIN
   SELECT COUNT(*)
     INTO nDistrib
     FROM REA_DISTRIBUCION
    WHERE CodCia        = nCodCia
      AND IdTransaccion = nIdTransaccion
      AND IdSiniestro   = nIdSiniestro;

   IF NVL(nDistrib,0) = 0 THEN
      nIdDistribRea := GT_REA_DISTRIBUCION.NUMERO_DISTRIBUCION(nCodCia);
      nNumDistrib   := 0;
      BEGIN
         SELECT IdPoliza, IDetPol, Fec_Ocurrencia
           INTO nIdPoliza, nIDetPol, dFec_Ocurrencia
           FROM SINIESTRO
          WHERE IdSiniestro = nIdSiniestro
            AND CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'No Existe Siniestro No. '|| nIdSiniestro);
      END;

      FOR X IN TRAN_Q LOOP
         FOR W IN COB_Q LOOP
            cCodRiesgoRea     := W.CodRiesgoRea;
            cCod_Moneda       := W.Cod_Moneda;
            nCod_Asegurado    := W.Cod_Asegurado;
            cCodEsquemaPol    := GT_REA_ESQUEMAS_POLIZAS.ESQUEMA_POLIZA(nCodCia, nIdPoliza);

            IF cCodEsquemaPol IS NULL THEN
               SELECT MAX(CodEsquema)
                 INTO cCodEsquemaPol
                 FROM REA_DISTRIBUCION
                WHERE CodCia     = nCodCia
                  AND IdPoliza   = nIdPoliza;
            END IF;

            IF GT_REA_ESQUEMAS_POLIZA_COBERT.CESION_DE_PRIMA(nCodCia, cCodEsquemaPol, nIdPoliza, W.CodCobert) = 'N' AND
               GT_REA_ESQUEMAS_POLIZA_COBERT.RECUPERACION_SINIESTRO(nCodCia, cCodEsquemaPol, nIdPoliza, W.CodCobert) = 'S' THEN
               SELECT MIN(CodGrupoCobert)
                 INTO cCodGrupoCobert
                 FROM REA_DISTRIBUCION
                WHERE CodCia       = nCodCia
                  AND IdPoliza     = nIdPoliza
                  AND IdSiniestro  = 0;
            ELSE
               cCodGrupoCobert   := W.CodGrupoCobert;
            END IF;

            nMtoSiniPendDist  := W.Monto_Reservado_Moneda;
            cSigno_Concepto  := OC_CATALOGO_DE_CONCEPTOS.SIGNO_CONCEPTO(nCodCia, W.CodCptoTransac);
            IF cSigno_Concepto != '+' OR (W.TipoDist = 'APROBA' AND W.Status = 'EMI') THEN
               nMtoSiniPendDist  := nMtoSiniPendDist * -1;
            END IF;

            SELECT NVL(MIN(IdDistribRea),0), NVL(MIN(NumDistrib),0)
              INTO nIdDistribReaPol, nNumDistribPol
              FROM REA_DISTRIBUCION
             WHERE CodCia          = nCodCia
               AND IdPoliza        = nIdPoliza
               AND IDetPol         = nIDetPol
               AND CodRiesgoReaseg = cCodRiesgoRea
               AND Cod_Asegurado   = nCod_Asegurado
               AND IdSiniestro     = 0;

            FOR Z IN DIST_POL_Q LOOP
               IF W.TipoDist != 'APROBA' THEN
                  SELECT NVL(SUM(R.MtoSiniDistrib),0)
                    INTO nMtoSiniDistribAcum
                    FROM REA_DISTRIBUCION R
                   WHERE R.CodCia          = nCodCia
                     AND R.IdDistribRea    > 0
                     AND R.NumDistrib      > 0
                     AND R.MtoSiniDistrib  > 0
                     AND R.IdSiniestro     = nIdSiniestro
                     AND R.CodEsquema      = Z.CodEsquema
                     AND R.IdEsqContrato   = Z.IdEsqContrato
                     AND R.IdCapaContrato  = Z.IdCapaContrato
                     AND R.CodRiesgoReaseg = Z.CodRiesgoReaseg
                     AND R.CodGrupoCobert  = W.CodGrupoCobert
                     AND EXISTS (SELECT 'S'
                                   FROM COBERTURA_SINIESTRO
                                  WHERE IdSiniestro   = R.IdSiniestro
                                    AND IdPoliza      = nIdPoliza
                                    AND IdDetSin      = nIDetPol
                                    AND IdTransaccion = R.IdTransaccion
                                  UNION ALL
                                 SELECT 'S'
                                   FROM COBERTURA_SINIESTRO_ASEG
                                  WHERE IdSiniestro   = R.IdSiniestro
                                    AND IdPoliza      = nIdPoliza
                                    AND IdDetSin      = nIDetPol
                                    AND IdTransaccion = R.IdTransaccion);
               ELSE
                  SELECT NVL(SUM(R.MtoSiniDistrib),0)
                    INTO nMtoSiniDistribAcum
                    FROM REA_DISTRIBUCION R
                   WHERE R.CodCia          = nCodCia
                     AND R.IdDistribRea    > 0
                     AND R.NumDistrib      > 0
                     AND R.MtoSiniDistrib  < 0
                     AND R.IdSiniestro     = nIdSiniestro
                     AND R.CodEsquema      = Z.CodEsquema
                     AND R.IdEsqContrato   = Z.IdEsqContrato
                     AND R.IdCapaContrato  = Z.IdCapaContrato
                     AND R.CodRiesgoReaseg = Z.CodRiesgoReaseg
                     AND R.CodGrupoCobert  = W.CodGrupoCobert
                     AND EXISTS (SELECT 'S'
                                   FROM APROBACIONES
                                  WHERE IdSiniestro   = R.IdSiniestro
                                    AND IdPoliza      = nIdPoliza
                                    AND IdDetSin      = nIDetPol
                                    AND IdTransaccion = R.IdTransaccion
                                  UNION ALL
                                 SELECT 'S'
                                   FROM APROBACION_ASEG
                                  WHERE IdSiniestro   = R.IdSiniestro
                                    AND IdPoliza      = nIdPoliza
                                    AND IdDetSin      = nIDetPol
                                    AND IdTransaccion = R.IdTransaccion);
               END IF;

               nNumDistrib      := NVL(nNumDistrib,0) + 1;
               nMtoSiniDistrib  := (NVL(nMtoSiniPendDist,0) * (Z.PorcEsqContrato / 100));

               IF cSigno_Concepto != '+' OR (W.TipoDist = 'APROBA' AND W.Status = 'EMI') THEN
                  IF NVL(nMtoSiniDistrib,0) > 0 THEN
                     nMtoSiniDistrib  := nMtoSiniDistrib * -1;
                  END IF;
               END IF;

               IF NVL(nMtoSiniDistrib,0) + NVL(ABS(nMtoSiniDistribAcum),0) > Z.LimiteMaxCapa AND Z.LimiteMaxCapa > 0 THEN
                  IF NVL(nMtoSiniDistribAcum,0) <> 0 THEN
                     nMtoSiniDistrib  := Z.LimiteMaxCapa - NVL(ABS(nMtoSiniDistribAcum),0);
                  ELSE
                     nMtoSiniDistrib  := Z.LimiteMaxCapa;
                  END IF;
                  IF cSigno_Concepto != '+' OR (W.TipoDist = 'APROBA' AND W.Status = 'EMI') THEN
                     IF NVL(nMtoSiniDistrib,0) > 0 THEN
                        nMtoSiniDistrib  := nMtoSiniDistrib * -1;
                     END IF;
                  END IF;
               END IF;

               nPorcDistrib     := (ABS(nMtoSiniDistrib) / W.Monto_Reservado_Moneda) * 100;

               INSERT INTO REA_DISTRIBUCION
                      (CodCia, IdDistribRea, NumDistrib, IdPoliza, IDetPol,
                       IdEndoso, IdSiniestro, IdTransaccion, CodEsquema,
                       IdEsqContrato, IdCapaContrato, CodRiesgoReaseg, FecVigInicial,
                       FecVigFinal, FecMovDistrib, CodMoneda, PorcDistrib, SumaAsegDistrib,
                       PrimaDistrib, MontoReserva, MtoSiniDistrib, CapacidadMaxima,
                       IndTraspaso, StsDistribucion, FecStatus, Cod_Asegurado, CodGrupoCobert)
               VALUES (nCodCia, nIdDistribRea, nNumDistrib, nIdPoliza, nIDetPol,
                       0, nIdSiniestro, nIdTransaccion, Z.CodEsquema,
                       Z.IdEsqContrato, Z.IdCapaContrato, Z.CodRiesgoReaseg, dFecTransaccion,
                       dFecTransaccion, dFecTransaccion, cCod_Moneda, nPorcDistrib, 0,
                       0, 0, nMtoSiniDistrib, Z.LimiteMaxCapa,
                       'N', 'ACTIVA', TRUNC(SYSDATE), W.Cod_Asegurado,  W.CodGrupoCobert);

               -- Distribuye por Empresa del Gremio Reaseguradora lo Cedido al Contrato
               nNumDistribEmpPol := Z.NumDistrib;
               FOR Y IN EMP_POL_Q LOOP
                  nMtoSiniDistribEmp     := NVL(nMtoSiniDistrib,0) * 
                                           (Y.PorcDistrib / 100) *
                                           (GT_REA_ESQUEMAS_EMPRESAS.PORCENTAJE(nCodCia, Z.CodEsquema, Z.IdEsqContrato, 
                                                                                Z.IdCapaContrato, Y.CodEmpresaGremio, Y.CodInterReaseg, 'PRVS') / 100);

                  INSERT INTO REA_DISTRIBUCION_EMPRESAS
                         (CodCia, IdDistribRea, NumDistrib, CodEmpresaGremio, CodInterReaseg,
                          CodMoneda, PorcDistrib, SumaAsegDistrib, PrimaDistrib, MontoComision,
                          MontoReserva, MtoSiniDistrib, IdLiquidacion, IntRvasLiberadas,
                          ImpRvasLiberadas, FecLiberacionRvas, StsDistribEmpresa, FecStatus)
                  VALUES (nCodCia, nIdDistribRea, nNumDistrib, Y.CodEmpresaGremio, Y.CodInterReaseg,
                          cCod_Moneda, Y.PorcDistrib, 0, 0, 0,
                          0, nMtoSiniDistribEmp, NULL, 0,
                          0, NULL, 'ACTIVA', TRUNC(SYSDATE));
               END LOOP;

               -- Actualiza Monto de Reserva
               nMtoSiniDistrib := GT_REA_DISTRIBUCION_EMPRESAS.MONTO_SINIESTRO(nCodCia, nIdDistribRea, nNumDistrib);

               UPDATE REA_DISTRIBUCION
                  SET MtoSiniDistrib = nMtoSiniDistrib
                WHERE CodCia       = nCodCia
                  AND IdDistribRea = nIdDistribRea
                  AND NumDistrib   = nNumDistrib;

               -- Controla si ya se distribuyó el 100% de la Suma Asegurada y Prima
               nMtoSiniPendDist := NVL(nMtoSiniPendDist,0) - NVL(nMtoSiniDistrib,0);

               IF (W.TipoDist = 'APROBA' AND W.Status = 'EMI') THEN
                  IF NVL(nMtoSiniPendDist,0) >= 0 THEN
                     EXIT;
                  END IF;
               ELSIF (W.TipoDist = 'APROBA' AND W.Status = 'ANU') THEN
                  IF NVL(nMtoSiniPendDist,0) <= 0 THEN
                     EXIT;
                  END IF;
               ELSIF ((NVL(nMtoSiniPendDist,0) <= 0 AND cSigno_Concepto = '+') OR
                  (NVL(nMtoSiniPendDist,0) >= 0 AND cSigno_Concepto != '+' )) THEN
                  EXIT;
               END IF;
            END LOOP;
         END LOOP;
      END LOOP;
   ELSE
      RAISE_APPLICATION_ERROR (-20100,'Ya existe Distribución de Reaseguro para Siniestro No. ' || nIdSiniestro ||
                               ' y Transacción No. ' || nIdTransaccion);
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR (-20100,'ERROR en Distribución de Reaseguro de Siniestro ' || SQLERRM);
END DISTRIBUYE_SINIESTROS;

FUNCTION NUMERO_DISTRIBUCION(nCodCia NUMBER) RETURN NUMBER IS
nIdDistribRea        REA_DISTRIBUCION.IdDistribRea%TYPE;
BEGIN
   SELECT NVL(MAX(IdDistribRea),0)+1
     INTO nIdDistribRea
     FROM REA_DISTRIBUCION
    WHERE CodCia   = nCodCia;
   RETURN(nIdDistribRea);
END NUMERO_DISTRIBUCION;

FUNCTION DISTRIB_FACULTATIVA_PEND(nCodCia NUMBER, nIdTransaccion NUMBER) RETURN VARCHAR2 IS
cDistribPend    VARCHAR2(1);
CURSOR DIST_Q IS
   SELECT DISTINCT REC.CodContrato, IdDistribRea, NumDistrib
     FROM REA_DISTRIBUCION RD, REA_ESQUEMAS_CONTRATOS REC
    WHERE RD.CodCia         = nCodCia
      AND RD.IdTransaccion  = nIdTransaccion
      AND REC.CodCia        = RD.CodCia
      AND REC.IdEsqContrato = RD.IdEsqContrato;
BEGIN
   cDistribPend := 'N';
   FOR X IN DIST_Q LOOP
      IF GT_REA_TIPOS_CONTRATOS.CONTRATO_FACULTATIVO(nCodCia, X.CodContrato) = 'S' THEN
         IF GT_REA_DISTRIBUCION_EMPRESAS.POSEE_DISTRIB_EMPRESAS(nCodCia, X.IdDistribRea, X.NumDistrib) = 'N' THEN
             cDistribPend := 'S';
             EXIT;
         END IF;
      END IF;
   END LOOP;
   RETURN(cDistribPend);
END DISTRIB_FACULTATIVA_PEND;

FUNCTION EXISTE_DISTRIB_POLIZA(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nIdEndoso NUMBER) RETURN VARCHAR2 IS
cDistrib     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cDistrib
        FROM REA_DISTRIBUCION
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IDetPol      >= nIDetPol
         AND IdEndoso      = nIdEndoso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDistrib := 'N';
      WHEN TOO_MANY_ROWS THEN
         cDistrib := 'S';
   END;
   RETURN(cDistrib);
END EXISTE_DISTRIB_POLIZA;

FUNCTION EXISTE_DISTRIB_TRANSACCION(nCodCia NUMBER, nIdPoliza NUMBER, nIdTransaccion NUMBER) RETURN VARCHAR2 IS
cDistrib     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cDistrib
        FROM REA_DISTRIBUCION
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IdTransaccion = nIdTransaccion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDistrib := 'N';
      WHEN TOO_MANY_ROWS THEN
         cDistrib := 'S';
   END;
   RETURN(cDistrib);
END EXISTE_DISTRIB_TRANSACCION;

FUNCTION EXISTE_DISTRIB_TRANSAC_SINI(nCodCia NUMBER, nIdSiniestro NUMBER, nIdTransaccion NUMBER) RETURN VARCHAR2 IS
cDistrib     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cDistrib
        FROM REA_DISTRIBUCION
       WHERE CodCia        = nCodCia
         AND IdSiniestro   = nIdSiniestro
         AND IdTransaccion = nIdTransaccion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDistrib := 'N';
      WHEN TOO_MANY_ROWS THEN
         cDistrib := 'S';
   END;
   RETURN(cDistrib);
END EXISTE_DISTRIB_TRANSAC_SINI;

FUNCTION EXISTE_DISTRIB_SINIESTRO(nCodCia NUMBER, nIdSiniestro NUMBER) RETURN VARCHAR2 IS
cDistrib     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cDistrib
        FROM REA_DISTRIBUCION
       WHERE CodCia        = nCodCia
         AND IdSiniestro   = nIdSiniestro;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDistrib := 'N';
      WHEN TOO_MANY_ROWS THEN
         cDistrib := 'S';
   END;
   RETURN(cDistrib);
END EXISTE_DISTRIB_SINIESTRO;

PROCEDURE ELIMINAR_DISTRIBUCION(nCodCia NUMBER, nIdPoliza NUMBER, nIdTransaccion NUMBER) IS
cLiquidada      VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cLiquidada
        FROM REA_DISTRIBUCION D
       WHERE D.CodCia        = nCodCia
         AND D.IdPoliza      = nIdPoliza
         AND D.IdTransaccion = nIdTransaccion
         AND EXISTS (SELECT 'S'
                       FROM REA_DISTRIBUCION_EMPRESAS
                      WHERE CodCia       = D.CodCia
                        AND IdDistribRea = D.IdDistribRea
                        AND NumDistrib   = D.NumDistrib
                        AND IdLiquidacion IS NOT NULL);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cLiquidada := 'N';
      WHEN TOO_MANY_ROWS THEN
         cLiquidada := 'S';
   END;
   IF cLiquidada = 'N' THEN
      DELETE REA_DISTRIBUCION
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IdTransaccion = nIdTransaccion;
   ELSE
      RAISE_APPLICATION_ERROR (-20100,'NO Puede Eliminar la Distribución de Reaseguro porque Ya tiene Liquidación de Reaseguro ');
   END IF;
END ELIMINAR_DISTRIBUCION;

PROCEDURE ELIMINAR_DISTRIBUCION_SINI(nCodCia NUMBER, nIdSiniestro NUMBER, nIdTransaccion NUMBER) IS
cLiquidada      VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cLiquidada
        FROM REA_DISTRIBUCION D
       WHERE D.CodCia        = nCodCia
         AND D.IdSiniestro   = nIdSiniestro
         AND D.IdTransaccion = nIdTransaccion
         AND EXISTS (SELECT 'S'
                       FROM REA_DISTRIBUCION_EMPRESAS
                      WHERE CodCia       = D.CodCia
                        AND IdDistribRea = D.IdDistribRea
                        AND NumDistrib   = D.NumDistrib
                        AND IdLiquidacion IS NOT NULL);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cLiquidada := 'N';
      WHEN TOO_MANY_ROWS THEN
         cLiquidada := 'S';
   END;
   IF cLiquidada = 'N' THEN
      DELETE REA_DISTRIBUCION
       WHERE CodCia        = nCodCia
         AND IdSiniestro   = nIdSiniestro
         AND IdTransaccion = nIdTransaccion;
   ELSE
      RAISE_APPLICATION_ERROR (-20100,'NO Puede Eliminar la Distribución de Reaseguro del Siniestro porque Ya tiene Liquidación de Reaseguro ');
   END IF;
END ELIMINAR_DISTRIBUCION_SINI;

END GT_REA_DISTRIBUCION;

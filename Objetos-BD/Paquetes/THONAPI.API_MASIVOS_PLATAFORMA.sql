create or replace PACKAGE THONAPI.API_MASIVOS_PLATAFORMA IS
   --
   --MASP 03/12/2024 --> Se agregan los nodos de HorasVig y DiasVig
   PROCEDURE ACTUALIZAR_INFO_COTIZACION( nCodCia        COTIZACIONES.CodCia%TYPE
                                       , nCodEmpresa    COTIZACIONES.CodEmpresa%TYPE
                                       , nIdCotizacion  COTIZACIONES.IdCotizacion%TYPE
                                       , xInformacion   XMLTYPE );
   --
   PROCEDURE ACTUALIZAR_RIESGO_TARIFA( nCodCia      POLIZAS.CodCia%TYPE
                                     , nCodEmpresa  POLIZAS.CodEmpresa%TYPE
                                     , nIdPoliza    POLIZAS.IdPoliza%TYPE );
   --
   PROCEDURE ACTUALIZAR_NUMPOLUNICO( nCodCia      POLIZAS.CodCia%TYPE
                                   , nCodEmpresa  POLIZAS.CodEmpresa%TYPE
                                   , nIdPoliza    POLIZAS.IdPoliza%TYPE
                                   , cNumPolUnico POLIZAS.NumPolUnico%TYPE );
   --
   --MASP 21/11/2024 --> Se agrega el par¿metro cIndCalcDerechoEmis 'Indicador para determinar si se calculan los derechos de emisi¿n' desde la plataforma
   PROCEDURE ACTUALIZAR_INFO_POLIZA( nCodCia              POLIZAS.CodCia%TYPE
                                   , nCodEmpresa          POLIZAS.CodEmpresa%TYPE
                                   , nIdPoliza            POLIZAS.IdPoliza%TYPE
                                   , cCodAgrupador        POLIZAS.CodAgrupador%TYPE
                                   , cNumFolioPortal      POLIZAS.NumFolioPortal%TYPE
                                   , cCodCatego           POLIZAS.CodCatego%TYPE
                                   , cIndCalcDerechoEmis  POLIZAS.IndCalcDerechoEmis%TYPE );
   --
   PROCEDURE ACTUALIZAR_INDICADOR_WEB( nCodCia        COTIZACIONES.CodCia%TYPE
                                     , nCodEmpresa    COTIZACIONES.CodEmpresa%TYPE
                                     , nIdCotizacion  COTIZACIONES.IdCotizacion%TYPE );
   --
   PROCEDURE INSERTAR_CLAUSULAS_COTIZACION( nCodCia        COTIZACIONES_CLAUSULAS.CodCia%TYPE
                                          , nCodEmpresa    COTIZACIONES_CLAUSULAS.CodEmpresa%TYPE
                                          , nIdCotizacion  COTIZACIONES_CLAUSULAS.IdCotizacion%TYPE
                                          , xInformacion   XMLTYPE );
   --
   PROCEDURE INSERTAR_ASISTENCIAS_ASEGURADO( nCodCia       ASISTENCIAS_ASEGURADO.CodCia%TYPE
                                           , nCodEmpresa   ASISTENCIAS_ASEGURADO.CodEmpresa%TYPE
                                           , nIdPoliza     ASISTENCIAS_ASEGURADO.IdPoliza%TYPE
                                           , nIDetPol      ASISTENCIAS_ASEGURADO.IDetPol%TYPE
                                           , nIdEndoso     ASISTENCIAS_ASEGURADO.IdEndoso%TYPE
                                           , xInformacion  XMLTYPE );
   --
   PROCEDURE GENERA_COB_MASTER( nCodCia              COTIZACIONES_DETALLE.CodCia%TYPE
                              , nCodEmpresa          COTIZACIONES_DETALLE.CodEmpresa%TYPE
                              , nIdCotizacion        COTIZACIONES_DETALLE.IdCotizacion%TYPE
                              , nIDetCotizacion      COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                              , cIndSubGruposMaster  VARCHAR2
                              , cHeredar_Master      VARCHAR2
                              , cIdTipoSeg           COTIZACIONES.IdTipoSeg%TYPE
                              , cPlanCob             COTIZACIONES.PlanCob%TYPE );
   --
   PROCEDURE GENERA_COBERTURAS( nCodCia              COTIZACIONES_DETALLE.CodCia%TYPE
                              , nCodEmpresa          COTIZACIONES_DETALLE.CodEmpresa%TYPE
                              , nIdCotizacion        COTIZACIONES_DETALLE.IdCotizacion%TYPE
                              , nIDetCotizacion      COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                              , cIdTipoSeg           COTIZACIONES.IdTipoSeg%TYPE
                              , cPlanCob             COTIZACIONES.PlanCob%TYPE
                              , cIndPrimaPromedio    VARCHAR2
                              , cIndCuotaPromedio    VARCHAR2 );
   --
   --MASP 30/01/2025 --> Recuperar el 1er Detalle Cotizacion
   FUNCTION RECUPERAR_DETALLE_COTIZACION( nCodCia        COTIZACIONES_DETALLE.CodCia%TYPE
                                        , nCodEmpresa    COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                        , nIdCotizacion  COTIZACIONES_DETALLE.IdCotizacion%TYPE )  RETURN XMLTYPE;
   --
   --MASP 28/01/2025 --> Insertar un Detalle Cotizacion
   FUNCTION INSERTAR_DETALLE_COTIZACION( nCodCia        COTIZACIONES_DETALLE.CodCia%TYPE
                                        , nCodEmpresa    COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                        , nIdCotizacion  COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                        , xInformacion   XMLTYPE ) RETURN NUMBER;
   --
   -- MASP Servicios Emisión Masiva Vida   31/03/2025
   --      Servicio para Insertar el Texto de la Regla se Suma Asegurada por Cobertura
   PROCEDURE INSERTAR_REGLA_SA_COBER( nCodCia       REGLA_SA_COBER.CodCia%TYPE
                                    , nCodEmpresa   REGLA_SA_COBER.CodEmpresa%TYPE
                                    , nIdPoliza     REGLA_SA_COBER.IdPoliza%TYPE
                                    , nIDetPol      REGLA_SA_COBER.IDetPol%TYPE
                                    , xInformacion  XMLTYPE );
   --
   -- MASP Servicios Emisión Masiva Vida   07/04/2025
   --      Servicio para Recuperar las clausulas de una cotizacion
   FUNCTION CONSULTAR_CLAUSULAS_COTIZACION( nCodCia        COTIZACIONES_COBERT_WEB.CodCia%TYPE
                                          , nCodEmpresa    COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                                          , nIdCotizacion  COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE ) RETURN XMLTYPE;
   --
   -- MASP Servicios Emisión Masiva Vida   11/04/2025
   --      Servicio para recalcular una póliza
   PROCEDURE RECALCULAR_POLIZA( nCodCia      DETALLE_POLIZA.CodCia%TYPE
                              , nCodEmpresa  DETALLE_POLIZA.CodEmpresa%TYPE
                              , nIdPoliza    DETALLE_POLIZA.IdPoliza%TYPE
                              , nIDetPol     DETALLE_POLIZA.IDetPol%TYPE );
END API_MASIVOS_PLATAFORMA;
/
create or replace PACKAGE BODY THONAPI.API_MASIVOS_PLATAFORMA IS
   --
   --MASP 03/12/2024 --> Se agregan los nodos de HorasVig y DiasVig
   PROCEDURE ACTUALIZAR_INFO_COTIZACION( nCodCia        COTIZACIONES.CodCia%TYPE
                                       , nCodEmpresa    COTIZACIONES.CodEmpresa%TYPE
                                       , nIdCotizacion  COTIZACIONES.IdCotizacion%TYPE
                                       , xInformacion   XMLTYPE ) IS
      cCodTipoBono           COTIZACIONES.CodTipoBono%TYPE;
      cCodRiesgoREA          COTIZACIONES.CodRiesgoREA%TYPE;
      nFactorAjuste          COTIZACIONES.FactorAjuste%TYPE;
      cCodTipoNegocio        COTIZACIONES.CodTipoNegocio%TYPE;
      cDescElegibilidad      COTIZACIONES.DescElegibilidad%TYPE;
      cDescRiesgosCubiertos  COTIZACIONES.DescRiesgosCubiertos%TYPE;
      cCodPlanPago           COTIZACIONES.CodPlanPago%TYPE;
      nPorcComisProm         COTIZACIONES.PorcComisProm%TYPE;
      nPorcComisDir          COTIZACIONES.PorcComisDir%TYPE;
      nGastosExpedicion      COTIZACIONES.GastosExpedicion%TYPE;
      nPorcConvenciones      COTIZACIONES.PorcConvenciones%TYPE;
      cTipoAdministracion    COTIZACIONES.TipoAdministracion%TYPE;
      nPorcGtoAdmin          COTIZACIONES.PorcGtoAdmin%TYPE;
      nPorcUtilidad          COTIZACIONES.PorcUtilidad%TYPE;
      nHorasVig              COTIZACIONES.HorasVig%TYPE;
      nDiasVig               COTIZACIONES.DiasVig%TYPE;
      --
      CURSOR cActInformacion IS
         WITH
         INFORMACION_DATA AS ( SELECT INFO.*
                              FROM   XMLTABLE('/DATA'
                                 PASSING xInformacion
                                     COLUMNS 
                                     CodTipoBono           VARCHAR2(10)    PATH 'CodTipoBono',
                                     CodRiesgoREA          VARCHAR2(6)     PATH 'CodRiesgoREA',
                                     FactorAjuste          NUMBER(9,6)     PATH 'FactorAjuste',
                                     CodTipoNegocio        VARCHAR2(100)   PATH 'CodTipoNegocio',
                                     DescElegibilidad      VARCHAR2(4000)  PATH 'DescElegibilidad',
                                     DescRiesgosCubiertos  VARCHAR2(4000)  PATH 'DescRiesgosCubiertos',
                                     CodPlanPago           VARCHAR2(6)     PATH 'CodPlanPago',
                                     PorcComisProm         NUMBER(9,6)     PATH 'PorcComisProm',
                                     PorcComisDir          NUMBER(9,6)     PATH 'PorcComisDir',
                                     GastosExpedicion      NUMBER(18,2)    PATH 'GastosExpedicion',
                                     PorcConvenciones      NUMBER(9,6)     PATH 'PorcConvenciones',
                                     TipoAdministracion    VARCHAR2(6)     PATH 'TipoAdministracion',
                                     PorcGtoAdmin          NUMBER(9,6)     PATH 'PorcGtoAdmin',
                                     PorcUtilidad          NUMBER(9,6)     PATH 'PorcUtilidad',
                                     HorasVig              NUMBER(5,0)     PATH 'HorasVig',
                                     DiasVig               NUMBER(5,0)     PATH 'DiasVig' ) INFO
                            )
         SELECT * FROM INFORMACION_DATA;
   BEGIN
      FOR x IN cActInformacion LOOP
         IF x.CodTipoBono IS NOT NULL THEN
            cCodTipoBono := x.CodTipoBono;
         END IF;
         --
         IF x.CodRiesgoREA IS NOT NULL THEN
            cCodRiesgoREA := x.CodRiesgoREA;
         END IF;
         --
         IF x.FactorAjuste IS NOT NULL THEN
            nFactorAjuste := x.FactorAjuste;
         END IF;
         --
         IF x.CodTipoNegocio IS NOT NULL THEN
            cCodTipoNegocio := x.CodTipoNegocio;
         END IF;
         --
         IF x.DescElegibilidad IS NOT NULL THEN
            cDescElegibilidad := x.DescElegibilidad;
         END IF;
         --
         IF x.DescRiesgosCubiertos IS NOT NULL THEN
            cDescRiesgosCubiertos := x.DescRiesgosCubiertos;
         END IF;
         --
         IF x.CodPlanPago IS NOT NULL THEN
            cCodPlanPago := x.CodPlanPago;
         END IF;
         --
         IF x.PorcComisProm IS NOT NULL THEN
            nPorcComisProm := x.PorcComisProm;
         END IF;
         --
         IF x.PorcComisDir IS NOT NULL THEN
            nPorcComisDir := x.PorcComisDir;
         END IF;
         --
         IF x.GastosExpedicion IS NOT NULL THEN
            nGastosExpedicion := x.GastosExpedicion;
         END IF;
         --
         IF x.PorcConvenciones IS NOT NULL THEN
            nPorcConvenciones := x.PorcConvenciones;
         END IF;
         --
         IF x.TipoAdministracion IS NOT NULL THEN
            cTipoAdministracion := x.TipoAdministracion;
         END IF;
         --
         IF x.PorcGtoAdmin IS NOT NULL THEN
            nPorcGtoAdmin := x.PorcGtoAdmin;
         END IF;
         --
         IF x.PorcUtilidad IS NOT NULL THEN
            nPorcUtilidad := x.PorcUtilidad;
         END IF;
         --
         IF x.HorasVig IS NOT NULL THEN
            nHorasVig := x.HorasVig;
         END IF;
         --
         IF x.DiasVig IS NOT NULL THEN
            nDiasVig := x.DiasVig;
         END IF;
      END LOOP;
      --
      UPDATE COTIZACIONES
      SET    CodTipoBono          = NVL( cCodTipoBono, CodTipoBono )
        ,    CodRiesgoREA         = NVL( cCodRiesgoREA, CodRiesgoREA )
        ,    FactorAjuste         = NVL( nFactorAjuste, FactorAjuste )
        ,    CodTipoNegocio       = NVL( cCodTipoNegocio, CodTipoNegocio )
        ,    DescElegibilidad     = NVL( cDescElegibilidad, DescElegibilidad )
        ,    DescRiesgosCubiertos = NVL( cDescRiesgosCubiertos, DescRiesgosCubiertos )
        ,    CodPlanPago          = NVL( cCodPlanPago, CodPlanPago )
        ,    PorcComisProm        = NVL( nPorcComisProm, PorcComisProm )
        ,    PorcComisDir         = NVL( nPorcComisDir, PorcComisDir )
        ,    GastosExpedicion     = NVL( nGastosExpedicion, GastosExpedicion )
        ,    PorcConvenciones     = NVL( nPorcConvenciones, PorcConvenciones )
        ,    TipoAdministracion   = NVL( cTipoAdministracion, TipoAdministracion )
        ,    PorcGtoAdqui         = NVL( nPorcComisProm, NVL(PorcComisProm, 0) ) + NVL( nPorcComisDir, NVL(PorcComisDir, 0) ) + NVL( PorcComisAgte, 0 ) 
        ,    PorcGtoAdmin         = NVL( nPorcGtoAdmin, PorcGtoAdmin )
        ,    PorcUtilidad         = NVL( nPorcUtilidad, PorcUtilidad )
        ,    HorasVig             = NVL( nHorasVig, HorasVig )
        ,    DiasVig              = NVL( nDiasVig, DiasVig )
      WHERE  CodCia       = nCodCia
        AND  CodEmpresa   = nCodEmpresa
        AND  IdCotizacion = nIdCotizacion;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL ACTUALIZAR LA INFORMACION GENERAL DE LA COTIZACION: ' || nIdCotizacion || ' - ' || SQLERRM);
   END ACTUALIZAR_INFO_COTIZACION;
   --
   PROCEDURE ACTUALIZAR_RIESGO_TARIFA( nCodCia      POLIZAS.CodCia%TYPE
                                     , nCodEmpresa  POLIZAS.CodEmpresa%TYPE
                                     , nIdPoliza    POLIZAS.IdPoliza%TYPE ) IS
      nIdCotizacion  POLIZAS.Num_Cotizacion%TYPE;
      cRiesgoTarifa  COTIZACIONES_DETALLE.RiesgoTarifa%TYPE;
      cTipoRiesgo    POLIZAS.TipoRiesgo%TYPE;
   BEGIN
      SELECT Num_Cotizacion
      INTO   nIdCotizacion
      FROM   POLIZAS
      WHERE  IdPoliza = nIdPoliza
        AND  CodCia   = nCodCia;
      --
      BEGIN
         SELECT RiesgoTarifa
         INTO   cRiesgoTarifa
         FROM   COTIZACIONES_DETALLE
         WHERE  IdCotizacion = nIdCotizacion
         GROUP BY RiesgoTarifa;
      EXCEPTION
      WHEN OTHERS THEN
           cRiesgoTarifa := NULL;
      END;
      --
      IF cRiesgoTarifa IS NOT NULL THEN
         cTipoRiesgo := OC_VALORES_DE_LISTAS.BUSCA_VALORDESC('TIPRIESG', 'RIESGO ' || cRiesgoTarifa);
         --
         UPDATE POLIZAS
         SET    TipoRiesgo = cTipoRiesgo
         WHERE  IdPoliza = nIdPoliza
           AND  CodCia   = nCodCia;
      END IF;
      --
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL ACTUALIZAR EL RIESGO TARIFA EN LA POLIZA: ' || nIdPoliza || ' - ' || SQLERRM);
   END ACTUALIZAR_RIESGO_TARIFA;

   PROCEDURE ACTUALIZAR_NUMPOLUNICO( nCodCia      POLIZAS.CodCia%TYPE
                                   , nCodEmpresa  POLIZAS.CodEmpresa%TYPE
                                   , nIdPoliza    POLIZAS.IdPoliza%TYPE
                                   , cNumPolUnico POLIZAS.NumPolUnico%TYPE ) IS
   BEGIN
      UPDATE POLIZAS
      SET    NumPolUnico = cNumPolUnico
      WHERE  IdPoliza = nIdPoliza
        AND  CodCia   = nCodCia;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL ACTUALIZAR EL NUMERO DE POLIZA UNICO EN LA POLIZA: ' || nIdPoliza || ' - ' || SQLERRM);
   END ACTUALIZAR_NUMPOLUNICO;

   --
   --MASP 21/11/2024 --> Se agrega el par¿metro cIndCalcDerechoEmis 'Indicador para determinar si se calculan los derechos de emisi¿n' desde la plataforma
   PROCEDURE ACTUALIZAR_INFO_POLIZA( nCodCia              POLIZAS.CodCia%TYPE
                                   , nCodEmpresa          POLIZAS.CodEmpresa%TYPE
                                   , nIdPoliza            POLIZAS.IdPoliza%TYPE
                                   , cCodAgrupador        POLIZAS.CodAgrupador%TYPE
                                   , cNumFolioPortal      POLIZAS.NumFolioPortal%TYPE
                                   , cCodCatego           POLIZAS.CodCatego%TYPE
                                   , cIndCalcDerechoEmis  POLIZAS.IndCalcDerechoEmis%TYPE ) IS
   BEGIN
      UPDATE POLIZAS
      SET    CodAgrupador       = cCodAgrupador
        ,    NumFolioPortal     = cNumFolioPortal
        ,    CodCatego          = cCodCatego
        ,    IndCalcDerechoEmis = cIndCalcDerechoEmis
      WHERE  IdPoliza = nIdPoliza
        AND  CodCia   = nCodCia;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL ACTUALIZAR EL AGRUPADOR EN LA POLIZA: ' || nIdPoliza || ' - ' || SQLERRM);
   END ACTUALIZAR_INFO_POLIZA;

   PROCEDURE ACTUALIZAR_INDICADOR_WEB( nCodCia        COTIZACIONES.CodCia%TYPE
                                     , nCodEmpresa    COTIZACIONES.CodEmpresa%TYPE
                                     , nIdCotizacion  COTIZACIONES.IdCotizacion%TYPE ) IS
   BEGIN
      UPDATE COTIZACIONES
      SET    IndCotizacionWeb = 'N'
      WHERE  CodCia       = nCodCia
        AND  CodEmpresa   = nCodEmpresa
        AND  IdCotizacion = nIdCotizacion;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL ACTUALIZAR EL INDICADOR WEB DE LA COTIZACION: ' || nIdCotizacion || ' - ' || SQLERRM);
   END ACTUALIZAR_INDICADOR_WEB;
   --
   PROCEDURE INSERTAR_CLAUSULAS_COTIZACION( nCodCia        COTIZACIONES_CLAUSULAS.CodCia%TYPE
                                          , nCodEmpresa    COTIZACIONES_CLAUSULAS.CodEmpresa%TYPE
                                          , nIdCotizacion  COTIZACIONES_CLAUSULAS.IdCotizacion%TYPE
                                          , xInformacion   XMLTYPE ) IS
      cCodClausula    COTIZACIONES_CLAUSULAS.CodClausula%TYPE;
      cTextoClausula  VARCHAR2(4000);
      --
      CURSOR cInsInformacion IS
         WITH
         INFORMACION_DATA AS ( SELECT INFO.*
                               FROM   XMLTABLE('/DATA'
                                  PASSING xInformacion
                                     COLUMNS 
                                     CodClausula   VARCHAR2(6)    PATH 'CodClausula',
                                     TextoClausula VARCHAR2(4000) PATH 'TextoClausula' ) INFO
                             )
         SELECT * FROM INFORMACION_DATA;
   BEGIN
      FOR x IN cInsInformacion LOOP
          cCodClausula := x.CodClausula;
          --
          IF x.TextoClausula IS NOT NULL THEN
             cTextoClausula := x.TextoClausula;
          ELSE
             BEGIN
                SELECT TextoClausula
                INTO   cTextoClausula
                FROM   CLAUSULAS
                WHERE  CodCia      = nCodCia
                  AND  CodEmpresa  = nCodEmpresa
                  AND  CodClausula = cCodClausula;
             EXCEPTION
             WHEN NO_DATA_FOUND THEN
                  cTextoClausula := NULL;
             END;
          END IF;
      END LOOP;
      --
      INSERT INTO COTIZACIONES_CLAUSULAS
             ( CodCia , CodEmpresa , IdCotizacion , CodClausula , TextoClausula , IndicadorCoti )
      VALUES ( nCodCia, nCodEmpresa, nIdCotizacion, cCodClausula, cTextoClausula, NULL );
      --
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL INSERTAR LA CLAUSULA DE LA COTIZACION: ' || nIdCotizacion || ' - ' || SQLERRM);
   END INSERTAR_CLAUSULAS_COTIZACION;
   --
   PROCEDURE INSERTAR_ASISTENCIAS_ASEGURADO( nCodCia       ASISTENCIAS_ASEGURADO.CodCia%TYPE
                                           , nCodEmpresa   ASISTENCIAS_ASEGURADO.CodEmpresa%TYPE
                                           , nIdPoliza     ASISTENCIAS_ASEGURADO.IdPoliza%TYPE
                                           , nIDetPol      ASISTENCIAS_ASEGURADO.IDetPol%TYPE
                                           , nIdEndoso     ASISTENCIAS_ASEGURADO.IdEndoso%TYPE
                                           , xInformacion  XMLTYPE ) IS
      --
      cStsAsistencia     ASISTENCIAS_ASEGURADO.StsAsistencia%TYPE := 'EMITID';
      dFecSts            ASISTENCIAS_ASEGURADO.FecSts%TYPE := TRUNC(SYSDATE);
      --
      nCodAsistencia     ASISTENCIAS_ASEGURADO.CodAsistencia%TYPE;
      nCodMoneda         ASISTENCIAS_ASEGURADO.CodMoneda%TYPE;
      nMontoAsistLocal   ASISTENCIAS_ASEGURADO.MontoAsistLocal%TYPE;
      nMontoAsistMoneda  ASISTENCIAS_ASEGURADO.MontoAsistMoneda%TYPE;
      --
      CURSOR cAsegurados IS
             SELECT Cod_Asegurado
             FROM   ASEGURADO_CERTIFICADO
             WHERE  CodCia   = nCodCia
               AND  IdPoliza = nIdPoliza
               AND  IDetPol  = nIDetPol
               AND  IdEndoso = nIdEndoso;
      --
      CURSOR cActInformacion IS
         WITH
         INFORMACION_DATA AS ( SELECT INFO.*
                              FROM   XMLTABLE('/DATA'
                                 PASSING xInformacion
                                     COLUMNS 
                                     CodAsistencia     VARCHAR2(10 BYTE) PATH 'CodAsistencia',
                                     CodMoneda         VARCHAR2(5 BYTE)  PATH 'CodMoneda',
                                     MontoAsistLocal   NUMBER(28,2)      PATH 'MontoAsistLocal',
                                     MontoAsistMoneda  NUMBER(28,2)      PATH 'MontoAsistMoneda' ) INFO
                            )
         SELECT * FROM INFORMACION_DATA;
   BEGIN
      FOR x IN cAsegurados LOOP
          FOR y IN cActInformacion LOOP
              nCodAsistencia    := NVL(y.CodAsistencia, 0);
              nCodMoneda        := NVL(y.CodMoneda, 0);
              nMontoAsistLocal  := NVL(y.MontoAsistLocal, 0);
              nMontoAsistMoneda := NVL(y.MontoAsistMoneda, 0);
          END LOOP;
          --
          INSERT INTO ASISTENCIAS_ASEGURADO
                 ( CodCia   , CodEmpresa     , IdPoliza        , IDetPol      , Cod_Asegurado, CodAsistencia,
                   CodMoneda, MontoAsistLocal, MontoAsistMoneda, StsAsistencia, FecSts       , IdEndoso )
          VALUES ( nCodCia   , nCodEmpresa     , nIdPoliza        , nIDetPol      , x.Cod_Asegurado, nCodAsistencia,
                   nCodMoneda, nMontoAsistLocal, nMontoAsistMoneda, cStsAsistencia, dFecSts        , nIdEndoso );
      END LOOP;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL INSERTAR LAS ASISTENCIAS EN LA POLIZA: ' || nIdPoliza || ' - ' || SQLERRM);
   END INSERTAR_ASISTENCIAS_ASEGURADO;

   PROCEDURE GENERA_COB_MASTER( nCodCia              COTIZACIONES_DETALLE.CodCia%TYPE
                              , nCodEmpresa          COTIZACIONES_DETALLE.CodEmpresa%TYPE
                              , nIdCotizacion        COTIZACIONES_DETALLE.IdCotizacion%TYPE
                              , nIDetCotizacion      COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                              , cIndSubGruposMaster  VARCHAR2
                              , cHeredar_Master      VARCHAR2
                              , cIdTipoSeg           COTIZACIONES.IdTipoSeg%TYPE
                              , cPlanCob             COTIZACIONES.PlanCob%TYPE ) IS
      cTextoNivel         VARCHAR2(100);
      --nIDetCotizacion     COTIZACIONES_DETALLE.IDetCotizacion%TYPE;
      nSalarioMensual     COTIZACIONES_COBERT_MASTER.SalarioMensual%TYPE;
      nVecesSalario       COTIZACIONES_COBERT_MASTER.VecesSalario%TYPE;
      nPorcExtraPrimaDet  COTIZACIONES_COBERT_MASTER.PorcExtraPrimaDet%TYPE;
      nMontoExtraPrimaDet COTIZACIONES_COBERT_MASTER.MontoExtraPrimaDet%TYPE;
      nSumaCotizacion     COTIZACIONES_COBERT_MASTER.SumaAsegCalculada%TYPE;
      --
      CURSOR MASTER_Q IS
             SELECT CodCia            , CodEmpresa   , IdCotizacion      , IDetCotizacion   , CodCobert         , SumaAsegCobLocal, SumaAsegCobMoneda,
                    Tasa              , PrimaCobLocal, PrimaCobMoneda    , DeducibleCobLocal, DeducibleCobMoneda, SalarioMensual  , VecesSalario     ,
                    SumaAsegCalculada , Edad_Minima  , Edad_Maxima       , Edad_Exclusion   , SumaAseg_Minima   , SumaAseg_Maxima , PorcExtraPrimaDet,
                    MontoExtraPrimaDet, SumaIngresada, DeducibleIngresado, CuotaPromedio    , PrimaPromedio
             FROM   COTIZACIONES_COBERT_MASTER
             WHERE  CodCia            = nCodCia
               AND  CodEmpresa        = nCodEmpresa
               AND  IdCotizacion      = nIdCotizacion
               AND  ((IDetCotizacion  > 0 AND NVL(cIndSubGruposMaster, 'N') = 'S')
                      OR
                     (IDetCotizacion  = nIDetCotizacion AND NVL(cIndSubGruposMaster, 'N') = 'N'))
             ORDER BY IDetCotizacion, CodCobert;
      --
      CURSOR DET_Q IS
             SELECT IDetCotizacion
             FROM   COTIZACIONES_DETALLE
             WHERE  CodCia         = nCodCia
               AND  CodEmpresa     = nCodEmpresa
               AND  IdCotizacion   = nIdCotizacion
               AND  IDetCotizacion = nIDetCotizacion;
      --
      CURSOR CENSO_Q IS
             SELECT IDetCotizacion, IdAsegurado, SalarioMensual, VecesSalario
             FROM   COTIZACIONES_CENSO_ASEG
             WHERE  CodCia         = nCodCia
               AND  CodEmpresa     = nCodEmpresa
               AND  IdCotizacion   = nIdCotizacion
               AND  IDetCotizacion = nIDetCotizacion;
      --
      CURSOR ASEG_Q IS
             SELECT IDetCotizacion, IdAsegurado, SalarioMensual, VecesSalario, PorcExtraPrimaAseg, MontoExtraPrimaAseg
             FROM   COTIZACIONES_ASEG
             WHERE  CodCia         = nCodCia
               AND  CodEmpresa     = nCodEmpresa
               AND  IdCotizacion   = nIdCotizacion
               AND  IDetCotizacion = nIDetCotizacion;
      --
      CURSOR ACT_DET_Q IS
             SELECT IDetCotizacion
             FROM   COTIZACIONES_DETALLE
             WHERE  CodCia       = nCodCia
               AND  CodEmpresa   = nCodEmpresa
               AND  IdCotizacion = nIdCotizacion;
      --
      CURSOR ACT_CENSO_Q IS
             SELECT IDetCotizacion, IdAsegurado
             FROM   COTIZACIONES_CENSO_ASEG
             WHERE  CodCia       = nCodCia
               AND  CodEmpresa   = nCodEmpresa
               AND  IdCotizacion = nIdCotizacion;
      --
      CURSOR ACT_ASEG_Q IS
            SELECT IDetCotizacion, IdAsegurado
            FROM   COTIZACIONES_ASEG
            WHERE  CodCia       = nCodCia
              AND  CodEmpresa   = nCodEmpresa
              AND  IdCotizacion = nIdCotizacion;
   BEGIN
      IF NVL(cIndSubgruposMaster,'N') = 'S' THEN
         IF cHeredar_Master = 'D' THEN
            cTextoNivel := 'Todos los Subgrupos';
         ELSIF cHeredar_Master = 'C' THEN
            cTextoNivel := 'Censos de Todos los Sugrupos';
         ELSIF cHeredar_Master = 'A' THEN
            cTextoNivel := 'Listado de Asegurados de Todos los Sugrupos';
         END IF;
      ELSIF NVL(cIndSubgruposMaster,'N') = 'N' THEN
         IF cHeredar_Master = 'D' THEN
            cTextoNivel := 'Subgrupo No. ' || nIDetCotizacion;
         ELSIF cHeredar_Master = 'C' THEN
            cTextoNivel := 'Censos del Sugrupo No. ' || nIDetCotizacion;
         ELSIF cHeredar_Master = 'A' THEN
            cTextoNivel := 'Listado de Asegurados del Sugrupo No. ' || nIDetCotizacion;
         END IF;
      END IF;
      --
      DELETE COTIZACIONES_COBERTURAS
      WHERE  CodCia       = nCodCia
        AND  CodEmpresa   = nCodEmpresa
        AND  IdCotizacion = nIdCotizacion
        AND  ((IDetCotizacion  > 0 AND NVL(cIndSubGruposMaster,'N') = 'S')
              OR
              (IDetCotizacion  = nIDetCotizacion AND NVL(cIndSubGruposMaster,'N') = 'N'));
      --
      DELETE COTIZACIONES_COBERT_ASEG
      WHERE  CodCia       = nCodCia
        AND  CodEmpresa   = nCodEmpresa
        AND  IdCotizacion = nIdCotizacion
        AND ((IDetCotizacion  > 0 AND NVL(cIndSubGruposMaster,'N') = 'S')
             OR  (IDetCotizacion  = nIDetCotizacion AND NVL(cIndSubGruposMaster,'N') = 'N'));
      --
      FOR W IN MASTER_Q LOOP
      	 --nIDetCotizacion := W.IDetCotizacion;  Se quita porque va a ser solo para un IDetCotizacion y ya se trae como parametro de entrada
          IF cHeredar_Master = 'D' THEN
             --FOR X IN DET_Q LOOP  Se quita porque va a ser solo para un IDetCotizacion y ya se trae como parametro de entrada
             IF NVL(W.PorcExtraPrimaDet,0) != 0 OR NVL(W.MontoExtraPrimaDet,0) != 0 THEN
                nPorcExtraPrimaDet  := NVL(W.PorcExtraPrimaDet,0);
                nMontoExtraPrimaDet := NVL(W.MontoExtraPrimaDet,0);
             ELSE
                nPorcExtraPrimaDet  := 0;
                nMontoExtraPrimaDet := 0;
             END IF;
             --
             GT_COTIZACIONES_COBERTURAS.CARGAR_COBERTURAS( W.CodCia         , W.CodEmpresa      , cIdTipoSeg         , cPlanCob                  , W.IdCotizacion      ,
                                                           nIDetCotizacion  , NULL              , W.CodCobert        , NVL(W.SumaAsegCalculada,0), W.SalarioMensual    ,
                                                           W.VecesSalario   , W.Edad_Minima     , W.Edad_Maxima      , W.Edad_Exclusion          , W.SumaAseg_Minima   ,
                                                           W.SumaAseg_Maxima, nPorcExtraPrimaDet, nMontoExtraPrimaDet, W.SumaIngresada           , W.DeducibleIngresado,
                                                           W.CuotaPromedio  , W.PrimaPromedio   , NULL               , NULL                      , NULL );
             --END LOOP;
   	    ELSIF cHeredar_Master = 'C' THEN
             FOR X IN CENSO_Q LOOP
                 nSalarioMensual := X.SalarioMensual;
                 nVecesSalario   := X.VecesSalario;
                 nSumaCotizacion := (NVL(nSalarioMensual,0) * NVL(nVecesSalario,0)) + W.SumaIngresada;
                 --
                 IF nSumaCotizacion < W.SumaAseg_Minima THEN
                    nSumaCotizacion := W.SumaAseg_Minima;
                 ELSIF nSumaCotizacion > W.SumaAseg_Maxima THEN
                    nSumaCotizacion := W.SumaAseg_Maxima;
                END IF;
                --
                IF NVL(W.PorcExtraPrimaDet,0) != 0 OR NVL(W.MontoExtraPrimaDet,0) != 0 THEN
                   nPorcExtraPrimaDet  := NVL(W.PorcExtraPrimaDet,0);
                   nMontoExtraPrimaDet := NVL(W.MontoExtraPrimaDet,0);
                ELSE
                   nPorcExtraPrimaDet  := 0;
                   nMontoExtraPrimaDet := 0;
                END IF;
                --
                GT_COTIZACIONES_COBERTURAS.CARGAR_COBERTURAS( W.CodCia         , W.CodEmpresa      , cIdTipoSeg         , cPlanCob              , W.IdCotizacion      ,
                                                              X.IDetCotizacion , X.IdAsegurado     , W.CodCobert        , NVL(nSumaCotizacion,0), nSalarioMensual     ,
                                                              nVecesSalario    , W.Edad_Minima     , W.Edad_Maxima      , W.Edad_Exclusion      , W.SumaAseg_Minima   ,
                                                              W.SumaAseg_Maxima, nPorcExtraPrimaDet, nMontoExtraPrimaDet, W.SumaIngresada       , W.DeducibleIngresado,
                                                              W.CuotaPromedio  , W.PrimaPromedio   , NULL               , NULL                  , NULL );
             END LOOP;
   	    ELSIF cHeredar_Master = 'A' THEN
             FOR X IN ASEG_Q LOOP
                 nSalarioMensual := NVL(X.SalarioMensual,0);
                 nVecesSalario   := NVL(W.VecesSalario,0);
                 nSumaCotizacion := (NVL(nSalarioMensual,0) * NVL(nVecesSalario,0)) + W.SumaIngresada;
                 --
                 IF nSumaCotizacion < W.SumaAseg_Minima THEN
      	           nSumaCotizacion := W.SumaAseg_Minima;
                 ELSIF nSumaCotizacion > W.SumaAseg_Maxima THEN
      	           nSumaCotizacion := W.SumaAseg_Maxima;
                 END IF;
                 --
                 IF NVL(X.PorcExtraPrimaAseg,0) != 0 OR NVL(X.MontoExtraPrimaAseg,0) != 0 THEN
                    nPorcExtraPrimaDet  := NVL(X.PorcExtraPrimaAseg,0);
                    nMontoExtraPrimaDet := NVL(X.MontoExtraPrimaAseg,0);
                 ELSE
                    nPorcExtraPrimaDet  := NVL(W.PorcExtraPrimaDet,0);
                    nMontoExtraPrimaDet := NVL(W.MontoExtraPrimaDet,0);
                 END IF;
                 --
                 GT_COTIZACIONES_COBERTURAS.CARGAR_COBERTURAS( W.CodCia         , W.CodEmpresa      , cIdTipoSeg         , cPlanCob              , W.IdCotizacion      ,
                                                               X.IDetCotizacion , X.IdAsegurado     , W.CodCobert        , NVL(nSumaCotizacion,0), nSalarioMensual     ,
                                                               nVecesSalario    , W.Edad_Minima     , W.Edad_Maxima      , W.Edad_Exclusion      , W.SumaAseg_Minima   ,
                                                               W.SumaAseg_Maxima, nPorcExtraPrimaDet, nMontoExtraPrimaDet, W.SumaIngresada       , W.DeducibleIngresado,
                                                               W.CuotaPromedio  , W.PrimaPromedio   , NULL               , NULL                  , NULL );
             END LOOP;
          END IF;
      END LOOP;
      --
      IF cHeredar_Master = 'C' THEN
         FOR W IN ACT_CENSO_Q LOOP
             GT_COTIZACIONES_CENSO_ASEG.ACTUALIZAR_VALORES( nCodCia, nCodEmpresa, nIdCotizacion, W.IDetCotizacion, W.IdAsegurado );
         END LOOP;
      ELSIF cHeredar_Master = 'A' THEN
         FOR W IN ACT_ASEG_Q LOOP
             GT_COTIZACIONES_ASEG.ACTUALIZAR_VALORES( nCodCia, nCodEmpresa, nIdCotizacion, W.IDetCotizacion, W.IdAsegurado );
         END LOOP;
      END IF;
      --
      FOR W IN ACT_DET_Q LOOP
          GT_COTIZACIONES_DETALLE.ACTUALIZAR_VALORES( nCodCia, nCodEmpresa, nIdCotizacion, W.IDetCotizacion);
      END LOOP;
      --
      GT_COTIZACIONES.ACTUALIZAR_VALORES(nCodCia, nCodEmpresa, nIdCotizacion);
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR EN GENERA_COB_MASTER - ' || SQLERRM);
   END GENERA_COB_MASTER;
   --

   PROCEDURE GENERA_COBERTURAS( nCodCia              COTIZACIONES_DETALLE.CodCia%TYPE
                              , nCodEmpresa          COTIZACIONES_DETALLE.CodEmpresa%TYPE
                              , nIdCotizacion        COTIZACIONES_DETALLE.IdCotizacion%TYPE
                              , nIDetCotizacion      COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                              , cIdTipoSeg           COTIZACIONES.IdTipoSeg%TYPE
                              , cPlanCob             COTIZACIONES.PlanCob%TYPE
                              , cIndPrimaPromedio    VARCHAR2
                              , cIndCuotaPromedio    VARCHAR2 ) IS
      nCobBasica          NUMBER(5) := 0;
      nContador           NUMBER(5) := 0;
      nCuotaPromedio      NUMBER(5) := 0;
      nPrimaPromedio      NUMBER(5) := 0;
      nSalarioMensual     COTIZACIONES_COBERT_MASTER.SalarioMensual%TYPE;
      nVecesSalario       COTIZACIONES_COBERT_MASTER.VecesSalario%TYPE;
      nPorcExtraPrimaDet  COTIZACIONES_COBERT_MASTER.PorcExtraPrimaDet%TYPE;
      nMontoExtraPrimaDet COTIZACIONES_COBERT_MASTER.MontoExtraPrimaDet%TYPE;
      --
      nSumaCotizacion     NUMBER;
      nSumaAseg                NUMBER;
      --
      CURSOR cCobert_Master IS 
             SELECT A.SumaAsegurada                 , a.Cobertura_Basica          , a.CodCobert               , B.SumaAsegCalculada nSumaAsegCalculada,
                    B.SalarioMensual nSalarioMensual, B.VecesSalario nVecesSalario, B.Edad_Minima nEdad_Minima, B.Edad_Maxima       nEdad_Maxima      ,
                    NVL(B.Edad_Exclusion, B.Edad_Maxima+1) nEdad_Exclusion, B.SumaAseg_Minima nSumaAsegMinima, B.SumaAseg_Maxima nSumaAsegMaxima, B.PorcExtraPrimaDet nPorcExtraPrima,
                    B.MontoExtraPrimaDet nMontoExtraPrima, NVL(B.SumaIngresada,0) nSumaAseg, NVL(B.DeducibleIngresado,0) DeducibleIngresado, B.CuotaPromedio,
                    B.PrimaPromedio, NVL(B.FranquiciaIngresado,0) FranquiciaIngresado, B.MontoDiario, B.Dias_Cal
             FROM   COBERTURAS_DE_SEGUROS A
                ,   COTIZACIONES_COBERT_MASTER B 
             WHERE  A.CodCia         = B.CodCia
               AND  A.CodEmpresa     = B.CodEmpresa
               AND  A.CODCOBERT      = B.CODCOBERT
               AND  A.IdTipoSeg      = cIdTipoSeg 
               AND  A.PlanCob        = cPlanCob
               AND  A.StsCobertura   = 'ACT'
               AND  B.CodCia         = nCodCia
               AND  B.CodEmpresa     = nCodEmpresa
               AND  B.IdCotizacion   = nIdCotizacion
               AND  B.IDetCotizacion = nIDetCotizacion;
      --
      CURSOR DET_Q IS
             SELECT IDetCotizacion
             FROM   COTIZACIONES_DETALLE
             WHERE  CodCia         = nCodCia
               AND  CodEmpresa     = nCodEmpresa
               AND  IdCotizacion   = nIdCotizacion
               AND  IDetCotizacion = nIDetCotizacion;
   BEGIN
      FOR z IN cCobert_Master LOOP
          IF Z.Cobertura_Basica = 'S' THEN
             nCobBasica := NVL(nCobBasica,0) + 1;
          END IF;
          --
          IF cIndCuotaPromedio = 'S' AND Z.CuotaPromedio = 0 THEN
             nCuotaPromedio := NVL(nCuotaPromedio,0) + 1;
          END IF;
          --
          IF cIndPrimaPromedio = 'S' AND Z.PrimaPromedio = 0 THEN
             nPrimaPromedio := NVL(nPrimaPromedio,0) + 1;
          END IF;
      END LOOP;
      --
      IF nCobBasica = 0 THEN
         RAISE_APPLICATION_ERROR(-20205, 'NO ha Seleccionado una Cobertura B¿sica');
      ELSIF nCobBasica > 1 THEN
         RAISE_APPLICATION_ERROR(-20205, 'Seleccion¿ M¿s de una Cobertura B¿sica');
      ELSIF nCuotaPromedio > 0 THEN
         RAISE_APPLICATION_ERROR(-20205, 'Marc¿ el SubGrupo con Cuota Promedio y Existen Coberturas que a¿n NO le Ingresa su Cuota Promedio');
      ELSIF nPrimaPromedio > 0 THEN
         RAISE_APPLICATION_ERROR(-20205, 'Marc¿ el SubGrupo con Prima Promedio y Existen Coberturas que a¿n NO le Ingresa su Prima Promedio');
      ELSE
         FOR x in cCobert_Master LOOP
             IF NVL(x.nSumaAsegCalculada,0) != 0 THEN
                nSumaCotizacion := NVL(x.nSumaAsegCalculada,0);
             ELSE
   	          IF NVL(x.nSumaAseg,0) = 0 THEN
   	             nSumaAseg := x.SumaAsegurada;
   	          END IF;
                --
  	             nSumaCotizacion := (x.nSalarioMensual * x.nVecesSalario) + nSumaAseg;
                --
                IF nSumaCotizacion < x.nSumaAsegMinima THEN
      	          nSumaCotizacion := x.nSumaAsegMinima;
                ELSIF nSumaCotizacion > x.nSumaAsegMaxima THEN
      	          nSumaCotizacion := x.nSumaAsegMaxima;
                END IF;
             END IF;
             --
             nContador    := 0;
             --
             --FOR w IN DET_Q LOOP
             IF NVL(x.nPorcExtraPrima,0) != 0 OR NVL(x.nMontoExtraPrima,0) != 0 THEN
                nPorcExtraPrimaDet  := NVL(x.nPorcExtraPrima,0);
                nMontoExtraPrimaDet := NVL(x.nMontoExtraPrima,0);
             ELSE
                nPorcExtraPrimaDet  := 0;
                nMontoExtraPrimaDet := 0;
             END IF;
             --  
             DELETE COTIZACIONES_COBERT_MASTER
             WHERE  CodCia         = nCodCia
               AND  CodEmpresa     = nCodEmpresa
               AND  IdCotizacion   = nIdCotizacion
               AND  IDetCotizacion = nIDetCotizacion
               AND  CodCobert      = x.CodCobert;
             --
             GT_COTIZACIONES_COBERT_MASTER.CARGAR_COBERTURAS( nCodCia               , nCodEmpresa           , cIdTipoSeg                  , cPlanCob              , nIdCotizacion              ,
                                                             nIDetCotizacion       , NULL                  , x.CodCobert                 , NVL(nSumaCotizacion,0), x.nSalarioMensual          ,
                                                             x.nVecesSalario       , x.nEdad_Minima        , x.nEdad_Maxima              , x.nEdad_Exclusion     , x.nSumaAsegMinima          ,
                                                             x.nSumaAsegMaxima     , nPorcExtraPrimaDet    , nMontoExtraPrimaDet         , nSumaAseg             , NVL(x.DeducibleIngresado,0),
                                                             NVL(x.CuotaPromedio,0), NVL(x.PrimaPromedio,0), NVL(x.FranquiciaIngresado,0), x.MontoDiario         , x.Dias_cal );
   	        --   END LOOP;
   	        --END IF;
         END LOOP;
      END IF;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR EN GENERA_COBERTURAS - ' || SQLERRM);
END GENERA_COBERTURAS;   
   --
   --MASP 30/01/2025 --> Recuperar el 1er Detalle Cotizacion
   FUNCTION RECUPERAR_DETALLE_COTIZACION( nCodCia        COTIZACIONES_DETALLE.CodCia%TYPE
                                        , nCodEmpresa    COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                        , nIdCotizacion  COTIZACIONES_DETALLE.IdCotizacion%TYPE )  RETURN XMLTYPE IS
      xResultado  XMLTYPE;
   BEGIN
      SELECT XMLROOT(
             XMLELEMENT("DATA",
                        XMLELEMENT("CodSubgrupo"       , A.CodSubgrupo),
                        XMLELEMENT("DescSubgrupo"      , A.DescSubgrupo),
                        XMLELEMENT("EdadLimite"        , A.EdadLimite),
                        XMLELEMENT("CantAsegurados"    , A.CantAsegurados),
                        XMLELEMENT("SalarioMensual"    , A.SalarioMensual),
                        XMLELEMENT("VecesSalario"      , A.VecesSalario),
                        XMLELEMENT("PorcExtraPrimaDet" , A.PorcExtraPrimaDet),
                        XMLELEMENT("MontoExtraPrimaDet", A.MontoExtraPrimaDet),
                        XMLELEMENT("PrimaAsegurado"    , A.PrimaAsegurado),
                        XMLELEMENT("SumaAsegDetLocal"  , A.SumaAsegDetLocal),
                        XMLELEMENT("SumaAsegDetMoneda" , A.SumaAsegDetMoneda),
                        XMLELEMENT("PrimaDetLocal"     , A.PrimaDetLocal),
                        XMLELEMENT("PrimaDetMoneda"    , A.PrimaDetMoneda),
                        XMLELEMENT("RiesgoTarifa"      , A.RiesgoTarifa),
                        XMLELEMENT("HorasVig"          , A.HorasVig),
                        XMLELEMENT("DiasVig"           , A.DiasVig),
                        XMLELEMENT("FactorAjuste"      , A.FactorAjuste),
                        XMLELEMENT("FactFormulaDeduc"  , A.FactFormulaDeduc),
                        XMLELEMENT("IndEdadPromedio"   , A.IndEdadPromedio),
                        XMLELEMENT("IndCuotaPromedio"  , A.IndCuotaPromedio),
                        XMLELEMENT("IndPrimaPromedio"  , A.IndPrimaPromedio),
                        XMLELEMENT("PrimaNetaPor"      , A.PrimaNetaPor )
                       ), VERSION '1.0" encoding="UTF-8')
       INTO   xResultado
       FROM   COTIZACIONES_DETALLE A
       WHERE  A.CodCia         = nCodCia
         AND  A.CodEmpresa     = nCodEmpresa
         AND  A.IdCotizacion   = nIdCotizacion
         AND  A.IDetCotizacion = 1;
      --
      RETURN xResultado;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR EN RECUPERAR_DETALLE_COTIZACION - ' || SQLERRM);
   END RECUPERAR_DETALLE_COTIZACION;
   --
   --MASP 28/01/2025 --> Insertar un Detalle Cotizacion
   FUNCTION INSERTAR_DETALLE_COTIZACION( nCodCia        COTIZACIONES_DETALLE.CodCia%TYPE
                                       , nCodEmpresa    COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                       , nIdCotizacion  COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                       , xInformacion   XMLTYPE )  RETURN NUMBER IS
      nIDetCotizacion      COTIZACIONES_DETALLE.IDetCotizacion%TYPE;
      cCodSubgrupo         COTIZACIONES_DETALLE.CodSubgrupo%TYPE;
      cDescSubgrupo        COTIZACIONES_DETALLE.DescSubgrupo%TYPE;
      nEdadLimite          COTIZACIONES_DETALLE.EdadLimite%TYPE;
      nCantAsegurados      COTIZACIONES_DETALLE.CantAsegurados%TYPE;
      nSalarioMensual      COTIZACIONES_DETALLE.SalarioMensual%TYPE;
      nVecesSalario        COTIZACIONES_DETALLE.VecesSalario%TYPE;
      nPorcExtraPrimaDet   COTIZACIONES_DETALLE.PorcExtraPrimaDet%TYPE;
      nMontoExtraPrimaDet  COTIZACIONES_DETALLE.MontoExtraPrimaDet%TYPE;
      nPrimaAsegurado      COTIZACIONES_DETALLE.PrimaAsegurado%TYPE;
      nSumaAsegDetLocal    COTIZACIONES_DETALLE.SumaAsegDetLocal%TYPE;
      nSumaAsegDetMoneda   COTIZACIONES_DETALLE.SumaAsegDetMoneda%TYPE;
      nPrimaDetLocal       COTIZACIONES_DETALLE.PrimaDetLocal%TYPE;
      nPrimaDetMoneda      COTIZACIONES_DETALLE.PrimaDetMoneda%TYPE;
      cRiesgoTarifa        COTIZACIONES_DETALLE.RiesgoTarifa%TYPE;
      nHorasVig            COTIZACIONES_DETALLE.HorasVig%TYPE;
      nDiasVig             COTIZACIONES_DETALLE.DiasVig%TYPE;
      nFactorAjuste        COTIZACIONES_DETALLE.FactorAjuste%TYPE;
      nFactFormulaDeduc    COTIZACIONES_DETALLE.FactFormulaDeduc%TYPE;
      cIndEdadPromedio     COTIZACIONES_DETALLE.IndEdadPromedio%TYPE;
      cIndCuotaPromedio    COTIZACIONES_DETALLE.IndCuotaPromedio%TYPE;
      cIndPrimaPromedio    COTIZACIONES_DETALLE.IndPrimaPromedio%TYPE;
      cPrimaNetaPor        COTIZACIONES_DETALLE.PrimaNetaPor%TYPE;
	  nIDetCotizacionOri   COTIZACIONES_DETALLE.IDetCotizacion%TYPE := 1;
      --
      CURSOR cInformacion IS
         WITH
         INFORMACION_DATA AS ( SELECT INFO.*
                              FROM   XMLTABLE('/DATA'
                                 PASSING xInformacion
                                     COLUMNS 
                                     CodSubgrupo         VARCHAR2(20)   PATH 'CodSubgrupo',
                                     DescSubgrupo        VARCHAR2(50)   PATH 'DescSubgrupo',
                                     EdadLimite          NUMBER(5,0)    PATH 'EdadLimite',
                                     CantAsegurados      NUMBER(10,0)   PATH 'CantAsegurados',
                                     SalarioMensual      NUMBER(28,2)   PATH 'SalarioMensual',
                                     VecesSalario        NUMBER(10,0)   PATH 'VecesSalario',
                                     PorcExtraPrimaDet   NUMBER(9,6)    PATH 'PorcExtraPrimaDet',
                                     MontoExtraPrimaDet  NUMBER(18,2)   PATH 'MontoExtraPrimaDet',
                                     PrimaAsegurado      NUMBER(18,2)   PATH 'PrimaAsegurado',
                                     SumaAsegDetLocal    NUMBER(28,2)   PATH 'SumaAsegDetLocal',
                                     SumaAsegDetMoneda   NUMBER(28,2)   PATH 'SumaAsegDetMoneda',
                                     PrimaDetLocal       NUMBER(28,2)   PATH 'PrimaDetLocal',
                                     PrimaDetMoneda      NUMBER(28,2)   PATH 'PrimaDetMoneda',
                                     RiesgoTarifa        VARCHAR2(2)    PATH 'RiesgoTarifa',
                                     HorasVig            NUMBER(5,0)    PATH 'HorasVig',
                                     DiasVig             NUMBER(5,0)    PATH 'DiasVig',
                                     FactorAjuste        NUMBER(9,6)    PATH 'FactorAjuste',
                                     FactFormulaDeduc    NUMBER(12,8)   PATH 'FactFormulaDeduc',
                                     IndEdadPromedio     VARCHAR2(2)    PATH 'IndEdadPromedio',
                                     IndCuotaPromedio    VARCHAR2(1)    PATH 'IndCuotaPromedio',
                                     IndPrimaPromedio    VARCHAR2(1)    PATH 'IndPrimaPromedio',
                                     PrimaNetaPor        VARCHAR2(100)  PATH 'PrimaNetaPor' ) INFO
                            )
         SELECT * FROM INFORMACION_DATA;
   BEGIN
      FOR x IN cInformacion LOOP
          cCodSubgrupo        := x.CodSubgrupo;
          cDescSubgrupo       := x.DescSubgrupo;
          nEdadLimite         := x.EdadLimite;
          nCantAsegurados     := x.CantAsegurados;
          nSalarioMensual     := x.SalarioMensual;
          nVecesSalario       := x.VecesSalario;
          nPorcExtraPrimaDet  := x.PorcExtraPrimaDet;
          nMontoExtraPrimaDet := x.MontoExtraPrimaDet;
          nPrimaAsegurado     := x.PrimaAsegurado;
          nSumaAsegDetLocal   := x.SumaAsegDetLocal;
          nSumaAsegDetMoneda  := x.SumaAsegDetMoneda;
          nPrimaDetLocal      := x.PrimaDetLocal;
          nPrimaDetMoneda     := x.PrimaDetMoneda;
          cRiesgoTarifa       := x.RiesgoTarifa;
          nHorasVig           := x.HorasVig;
          nDiasVig            := x.DiasVig;
          nFactorAjuste       := x.FactorAjuste;
          nFactFormulaDeduc   := x.FactFormulaDeduc;
          cIndEdadPromedio    := x.IndEdadPromedio;
          cIndCuotaPromedio   := x.IndCuotaPromedio;
          cIndPrimaPromedio   := x.IndPrimaPromedio;
          cPrimaNetaPor       := x.PrimaNetaPor;
      END LOOP;
      --
      BEGIN
         SELECT MAX(IDetCotizacion) + 1
         INTO   nIDetCotizacion
         FROM   COTIZACIONES_DETALLE
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
           nIDetCotizacion := 1;
      END;
      --
      INSERT INTO COTIZACIONES_DETALLE
         ( CodCia          , CodEmpresa  , IdCotizacion     , IDetCotizacion    , CodSubgrupo   , DescSubgrupo    , EdadLimite       , CantAsegurados  ,
           SalarioMensual  , VecesSalario, PorcExtraPrimaDet, MontoExtraPrimaDet, PrimaAsegurado, SumaAsegDetLocal, SumaAsegDetMoneda, PrimaDetLocal   ,
           PrimaDetMoneda  , RiesgoTarifa, HorasVig         , DiasVig           , FactorAjuste  , FactFormulaDeduc, IndEdadPromedio  , IndCuotaPromedio,
           IndPrimaPromedio, PrimaNetaPor )
      VALUES ( nCodCia          , nCodEmpresa  , nIdCotizacion     , nIDetCotizacion    , cCodSubgrupo   , cDescSubgrupo    , nEdadLimite       , nCantAsegurados  ,
               nSalarioMensual  , nVecesSalario, nPorcExtraPrimaDet, nMontoExtraPrimaDet, nPrimaAsegurado, nSumaAsegDetLocal, nSumaAsegDetMoneda, nPrimaDetLocal   ,
               nPrimaDetMoneda  , cRiesgoTarifa, nHorasVig         , nDiasVig           , nFactorAjuste  , nFactFormulaDeduc, cIndEdadPromedio  , cIndCuotaPromedio,
               cIndPrimaPromedio, cPrimaNetaPor );
      --
	  IF nIDetCotizacion > 1 THEN
         GT_COTIZACIONES_COBERTURAS.COPIAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacionOri, nIDetCotizacion);
         GT_COTIZACIONES_COBERT_MASTER.COPIAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacionOri, nIDetCotizacion);
         GT_COTIZACIONES_CENSO_ASEG.COPIAR_CENSOS(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacionOri, nIDetCotizacion);
         GT_COTIZACIONES_ASEG.COPIAR_ASEGURADOS(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacionOri, nIDetCotizacion);
         GT_COTIZACIONES_COBERT_ASEG.COPIAR_COBERTURAS(nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacionOri, nIDetCotizacion);
	  END IF;
      --
      RETURN nIDetCotizacion;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL INSERTAR EL DETALLE DE LA COTIZACION: ' || nIdCotizacion || ' - SUBGRUPO: ' || cCodSubgrupo || '... ' || SQLERRM);
   END INSERTAR_DETALLE_COTIZACION; 
   --
   -- MASP Servicios Emisión Masiva Vida   31/03/2025
   --      Servicio para Insertar el Texto de la Regla se Suma Asegurada por Cobertura
   PROCEDURE INSERTAR_REGLA_SA_COBER( nCodCia       REGLA_SA_COBER.CodCia%TYPE
                                    , nCodEmpresa   REGLA_SA_COBER.CodEmpresa%TYPE
                                    , nIdPoliza     REGLA_SA_COBER.IdPoliza%TYPE
                                    , nIDetPol      REGLA_SA_COBER.IDetPol%TYPE
                                    , xInformacion  XMLTYPE ) IS
      cStsRegla   REGLA_SA_COBER.StRegla%TYPE         := 'ACT';
      cUsuario    REGLA_SA_COBER.Usuario%TYPE         := USER;
      dFecUltMov  REGLA_SA_COBER.Fecha_Ult_Movto%TYPE := TRUNC(SYSDATE);
      cCodCobert  REGLA_SA_COBER.CodCobert%TYPE;
      cTexto      REGLA_SA_COBER.Texto%TYPE;
      --
      CURSOR cActInformacion IS
         WITH
         PRINCIPAL_DATA AS ( SELECT XT1.*
                             FROM   XMLTABLE('/DATA/COBERTURA'
                                PASSING xInformacion
                                COLUMNS 
                                   CodCobert  VARCHAR2(6 BYTE)    PATH 'CodCobert',
                                   Texto      VARCHAR2(200 BYTE)  PATH 'Texto' ) XT1
                           )
         SELECT * FROM PRINCIPAL_DATA;
   BEGIN
      FOR y IN cActInformacion LOOP
          cCodCobert := y.CodCobert;
          cTexto     := y.Texto;
          --
          INSERT INTO REGLA_SA_COBER
                 ( CodCia , CodEmpresa , IdPoliza , IDetPol , CodCobert , Texto , StRegla  , Usuario , Fecha_Ult_Movto )
          VALUES ( nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, cCodCobert, cTexto, cStsRegla, cUsuario, dFecUltMov );
      END LOOP;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR EN API_MASIVOS_PLATAFORMA.INSERTAR_REGLA_SA_COBER, AL INSERTAR LAS REGLAS EN LA POLIZA-DETALLE: ' || nIdPoliza || '-' || nIDetPol || SQLERRM);
   END INSERTAR_REGLA_SA_COBER;
   --
   -- MASP Servicios Emisión Masiva Vida   07/04/2025
   --      Servicio para Recuperar las clausulas de una cotizacion
   FUNCTION CONSULTAR_CLAUSULAS_COTIZACION( nCodCia        COTIZACIONES_COBERT_WEB.CodCia%TYPE
                                          , nCodEmpresa    COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                                          , nIdCotizacion  COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE ) RETURN XMLTYPE IS
      --
      cResultado CLOB;
      xResultado XMLTYPE;   
      xResultado1 XMLTYPE;
      --
      CURSOR cClausulas IS
         SELECT CodClausula, TextoClausula
         FROM   COTIZACIONES_CLAUSULAS
         WHERE  CodCia          = nCodCia
           AND  CodEmpresa      = nCodEmpresa
           AND  IdCotizacion    = nIdCotizacion;
   BEGIN
      --
      cResultado := '<?xml version="1.0"?> <DATA>';
      --
      FOR x IN cClausulas LOOP
          cResultado := cResultado || '<CLAUSULAS>';
          cResultado := cResultado || '<CODCLAUSULA>'   || x.CodClausula   || '</CODCLAUSULA>';
          cResultado := cResultado || '<TEXTOCLAUSULA>' || x.TextoClausula || '</TEXTOCLAUSULA>';
          cResultado := cResultado || '</CLAUSULAS>';
      END LOOP;
      cResultado := cResultado || '</DATA>';

      xResultado1 := XMLType(cResultado);

      SELECT XMLROOT (xResultado1, VERSION '1.0" encoding="UTF-8')
      INTO   xResultado
      from   dual;

      RETURN xResultado;
   EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
   END CONSULTAR_CLAUSULAS_COTIZACION;
   --
   -- MASP Servicios Emisión Masiva Vida   11/04/2025
   --      Servicio para recalcular una póliza
   PROCEDURE RECALCULAR_POLIZA( nCodCia       DETALLE_POLIZA.CodCia%TYPE
                              , nCodEmpresa   DETALLE_POLIZA.CodEmpresa%TYPE
                              , nIdPoliza     DETALLE_POLIZA.IdPoliza%TYPE
                              , nIDetPol      DETALLE_POLIZA.IDetPol%TYPE ) IS
      nTotSubGrup  NUMBER;
      nTasaCambio  DETALLE_POLIZA.Tasa_Cambio%TYPE;
      --
      CURSOR c_SubGrupos IS
             SELECT IDetPol, IdTipoSeg, PlanCob
             FROM   DETALLE_POLIZA
             WHERE  IdPoliza   = nIdPoliza
               AND  IDetPol    = NVL(nIDetPol, IDetPol)
               AND  CodCia     = nCodCia 
               AND  CodEmpresa = nCodEmpresa
               AND  CodFilial IS NOT NULL;
   BEGIN
      SELECT OC_GENERALES.TASA_DE_CAMBIO(Cod_Moneda, TRUNC(SYSDATE))
      INTO   nTasaCambio
      FROM   POLIZAS
      WHERE  IdPoliza   = nIdPoliza
        AND  CodCia     = nCodCia 
        AND  CodEmpresa = nCodEmpresa;
      --
      SELECT COUNT(CodFilial)
      INTO   nTotSubGrup 
      FROM   DETALLE_POLIZA
      WHERE  IdPoliza   = nIdPoliza
        AND  IDetPol    = NVL(nIDetPol, IDetPol)
        AND  CodCia     = nCodCia 
        AND  CodEmpresa = nCodEmpresa;
	   --
      IF nTotSubGrup = 0 THEN
         RAISE_APPLICATION_ERROR(-20205, 'Error en API_MASIVOS_PLATAFORMA.RECALCULAR_POLIZA: No existen SubGrupos para esta Póliza: ' || nIdPoliza);
      ELSE
         FOR x IN c_SubGrupos LOOP
             IF OC_COBERT_ACT.EXISTE_COBERTURA(nCodCia, nCodEmpresa, x.IdTipoSeg, x.PlanCob, nIdPoliza, x.IDetPol) = 'N' THEN
                IF OC_ASEGURADO_CERTIFICADO.TIENE_ASEGURADOS(nCodCia, nIdPoliza, x.IDetPol, 0) = 'N' THEN
                   RAISE_APPLICATION_ERROR(-20205, 'Error en API_MASIVOS_PLATAFORMA.RECALCULAR_POLIZA: No existen Asegurados para esta Póliza: ' || nIdPoliza || '-' || x.IDetPol);
                ELSE
                   OC_DETALLE_POLIZA.RECALCULO_SUBGRUPO(nCodCia, nCodEmpresa, nIdPoliza, x.IDetPol, x.PlanCob, x.IdTipoSeg, nTasaCambio, 0);
                END IF;
             ELSE
                OC_DETALLE_POLIZA.RECALCULO_SUBGRUPO(nCodCia, nCodEmpresa, nIdPoliza, x.IDetPol, x.PlanCob, x.IdTipoSeg, nTasaCambio, 0);
             END IF;
         END LOOP;
      END IF;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR EN API_MASIVOS_PLATAFORMA.RECALCULAR_POLIZA POLIZA: ' || nIdPoliza || SQLERRM);
   END RECALCULAR_POLIZA;
END API_MASIVOS_PLATAFORMA;
/
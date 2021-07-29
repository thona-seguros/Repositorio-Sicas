CREATE OR REPLACE PACKAGE OC_COTIZACIONES_COBERT_WEB IS
    PROCEDURE INSERTAR( nCodCia              IN  COTIZACIONES_COBERT_WEB.CodCia%TYPE
                      , nCodEmpresa          IN  COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                      , nIdCotizacion        IN  COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE
                      , nIdetCotizacion      IN  COTIZACIONES_COBERT_WEB.IdetCotizacion%TYPE
                      , nCodGpoCobertWeb     IN  COTIZACIONES_COBERT_WEB.CodGpoCobertWeb%TYPE
                      , cCodCobertWeb        IN  COTIZACIONES_COBERT_WEB.CodCobertWeb%TYPE
                      , nSumaAsegCobLocal    IN  COTIZACIONES_COBERT_WEB.SumaAsegCobLocal%TYPE
                      , nSumaAsegCobMoneda   IN  COTIZACIONES_COBERT_WEB.SumaAsegCobMoneda%TYPE
                      , nTasa                IN  COTIZACIONES_COBERT_WEB.Tasa%TYPE
                      , nPrimaCobLocal       IN  COTIZACIONES_COBERT_WEB.PrimaCobLocal%TYPE
                      , nPrimaCobMoneda      IN  COTIZACIONES_COBERT_WEB.PrimaCobMoneda%TYPE
                      , nDeducibleCobLocal   IN  COTIZACIONES_COBERT_WEB.DeducibleCobLocal%TYPE
                      , nDeducibleCobMoneda  IN  COTIZACIONES_COBERT_WEB.DeducibleCobMoneda%TYPE
                      , nSalarioMensual      IN  COTIZACIONES_COBERT_WEB.SalarioMensual%TYPE
                      , nVecesSalario        IN  COTIZACIONES_COBERT_WEB.VecesSalario%TYPE
                      , nSumaAsegCalculada   IN  COTIZACIONES_COBERT_WEB.SumaAsegCalculada%TYPE
                      , nEdad_Minima         IN  COTIZACIONES_COBERT_WEB.Edad_Minima%TYPE
                      , nEdad_Maxima         IN  COTIZACIONES_COBERT_WEB.Edad_Maxima%TYPE
                      , nEdad_Exclusion      IN  COTIZACIONES_COBERT_WEB.Edad_Exclusion%TYPE
                      , nSumaAseg_Minima     IN  COTIZACIONES_COBERT_WEB.SumaAseg_Minima%TYPE
                      , nSumaAseg_Maxima     IN  COTIZACIONES_COBERT_WEB.SumaAseg_Maxima%TYPE
                      , nPorcExtraPrimaDet   IN  COTIZACIONES_COBERT_WEB.PorcExtraPrimaDet%TYPE
                      , nMontoExtraPrimaDet  IN  COTIZACIONES_COBERT_WEB.MontoExtraPrimaDet%TYPE
                      , nSumaIngresada       IN  COTIZACIONES_COBERT_WEB.SumaIngresada%TYPE
                      , nOrdenImpresion      IN  COTIZACIONES_COBERT_WEB.OrdenImpresion%TYPE
                      , nDeducibleIngresado  IN  COTIZACIONES_COBERT_WEB.DeducibleIngresado%TYPE
                      , nCuotaPromedio       IN  COTIZACIONES_COBERT_WEB.CuotaPromedio%TYPE
                      , nPrimaPromedio       IN  COTIZACIONES_COBERT_WEB.PrimaPromedio%TYPE );

    PROCEDURE ELIMINAR( nCodCia           IN  COTIZACIONES_COBERT_WEB.CodCia%TYPE
                      , nCodEmpresa       IN  COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                      , nIdCotizacion     IN  COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE
                      , nIdetCotizacion   IN  COTIZACIONES_COBERT_WEB.IdetCotizacion%TYPE
                      , nCodGpoCobertWeb  IN  COTIZACIONES_COBERT_WEB.CodGpoCobertWeb%TYPE
                      , cCodCobertWeb     IN  COTIZACIONES_COBERT_WEB.CodCobertWeb%TYPE );

    FUNCTION SERVICIO_XML( nCodCia           IN  COTIZACIONES_COBERT_WEB.CodCia%TYPE
                         , nCodEmpresa       IN  COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                         , nIdCotizacion     IN  COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE
                         , nIdetCotizacion   IN  COTIZACIONES_COBERT_WEB.IdetCotizacion%TYPE
                         , nCodGpoCobertWeb  IN  COTIZACIONES_COBERT_WEB.CodGpoCobertWeb%TYPE
                         , cCodCobertWeb     IN  COTIZACIONES_COBERT_WEB.CodCobertWeb%TYPE ) RETURN XMLTYPE;

    PROCEDURE COPIAR_COTIZACION( nCodCia            IN  COTIZACIONES_COBERT_WEB.CodCia%TYPE
                               , nCodEmpresa        IN  COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                               , nIdCotizacionOrig  IN  COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE
                               , nIdCotizacion      IN  COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE);

    FUNCTION COBERTURAS_XML( nCodCia           IN  COTIZACIONES_COBERT_WEB.CodCia%TYPE
                           , nCodEmpresa       IN  COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                           , nIdCotizacion     IN  COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE
                           , nIdetCotizacion   IN  COTIZACIONES_COBERT_WEB.IdetCotizacion%TYPE
                           , nCodGpoCobertWeb  IN  COTIZACIONES_COBERT_WEB.CodGpoCobertWeb%TYPE
                           , cCodCobertWeb     IN  COTIZACIONES_COBERT_WEB.CodCobertWeb%TYPE ) RETURN XMLTYPE;

    FUNCTION ACTUALIZAR( nCodCia        IN  COTIZACIONES_COBERT_WEB.CodCia%TYPE
                       , nCodEmpresa    IN  COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                       , xDatos         IN  XMLTYPE  
                       , xPrima         OUT XMLTYPE) RETURN XMLTYPE;
                          
    PROCEDURE ACTUALIZA_DATOS_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, xGenerales XMLTYPE);       

    PROCEDURE AGREGA_REGISTROS(nCODCIA NUMBER, nCODEMPRESA NUMBER, cCODCOTIZADOR VARCHAR2, cIDTIPOSEG VARCHAR2, cPLANCOB VARCHAR2, cCODGPOCOBERTWEB VARCHAR2, nIDCOTIZACION NUMBER, nIDETCOTIZACION NUMBER);

END OC_COTIZACIONES_COBERT_WEB;
/

CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_COTIZACIONES_COBERT_WEB IS
   PROCEDURE INSERTAR( nCodCia              IN  COTIZACIONES_COBERT_WEB.CodCia%TYPE
                     , nCodEmpresa          IN  COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                     , nIdCotizacion        IN  COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE
                     , nIdetCotizacion      IN  COTIZACIONES_COBERT_WEB.IdetCotizacion%TYPE
                     , nCodGpoCobertWeb     IN  COTIZACIONES_COBERT_WEB.CodGpoCobertWeb%TYPE
                     , cCodCobertWeb        IN  COTIZACIONES_COBERT_WEB.CodCobertWeb%TYPE
                     , nSumaAsegCobLocal    IN  COTIZACIONES_COBERT_WEB.SumaAsegCobLocal%TYPE
                     , nSumaAsegCobMoneda   IN  COTIZACIONES_COBERT_WEB.SumaAsegCobMoneda%TYPE
                     , nTasa                IN  COTIZACIONES_COBERT_WEB.Tasa%TYPE
                     , nPrimaCobLocal       IN  COTIZACIONES_COBERT_WEB.PrimaCobLocal%TYPE
                     , nPrimaCobMoneda      IN  COTIZACIONES_COBERT_WEB.PrimaCobMoneda%TYPE
                     , nDeducibleCobLocal   IN  COTIZACIONES_COBERT_WEB.DeducibleCobLocal%TYPE
                     , nDeducibleCobMoneda  IN  COTIZACIONES_COBERT_WEB.DeducibleCobMoneda%TYPE
                     , nSalarioMensual      IN  COTIZACIONES_COBERT_WEB.SalarioMensual%TYPE
                     , nVecesSalario        IN  COTIZACIONES_COBERT_WEB.VecesSalario%TYPE
                     , nSumaAsegCalculada   IN  COTIZACIONES_COBERT_WEB.SumaAsegCalculada%TYPE
                     , nEdad_Minima         IN  COTIZACIONES_COBERT_WEB.Edad_Minima%TYPE
                     , nEdad_Maxima         IN  COTIZACIONES_COBERT_WEB.Edad_Maxima%TYPE
                     , nEdad_Exclusion      IN  COTIZACIONES_COBERT_WEB.Edad_Exclusion%TYPE
                     , nSumaAseg_Minima     IN  COTIZACIONES_COBERT_WEB.SumaAseg_Minima%TYPE
                     , nSumaAseg_Maxima     IN  COTIZACIONES_COBERT_WEB.SumaAseg_Maxima%TYPE
                     , nPorcExtraPrimaDet   IN  COTIZACIONES_COBERT_WEB.PorcExtraPrimaDet%TYPE
                     , nMontoExtraPrimaDet  IN  COTIZACIONES_COBERT_WEB.MontoExtraPrimaDet%TYPE
                     , nSumaIngresada       IN  COTIZACIONES_COBERT_WEB.SumaIngresada%TYPE
                     , nOrdenImpresion      IN  COTIZACIONES_COBERT_WEB.OrdenImpresion%TYPE
                     , nDeducibleIngresado  IN  COTIZACIONES_COBERT_WEB.DeducibleIngresado%TYPE
                     , nCuotaPromedio       IN  COTIZACIONES_COBERT_WEB.CuotaPromedio%TYPE
                     , nPrimaPromedio       IN  COTIZACIONES_COBERT_WEB.PrimaPromedio%TYPE ) IS
   BEGIN
       INSERT INTO COTIZACIONES_COBERT_WEB
          ( CodCia, CodEmpresa, IdCotizacion, IdetCotizacion, CodGpoCobertWeb, CodCobertWeb, 
            SumaAsegCobLocal, SumaAsegCobMoneda, Tasa, PrimaCobLocal, PrimaCobMoneda, DeducibleCobLocal,
            DeducibleCobMoneda, SalarioMensual, VecesSalario, SumaAsegCalculada, Edad_Minima, Edad_Maxima, Edad_Exclusion,
            SumaAseg_Minima, SumaAseg_Maxima, PorcExtraPrimaDet, MontoExtraPrimaDet, SumaIngresada, OrdenImpresion,
            DeducibleIngresado, CuotaPromedio, PrimaPromedio )
       VALUES ( nCodCia, nCodEmpresa, nIdCotizacion, nIdetCotizacion, nCodGpoCobertWeb, cCodCobertWeb, 
                nSumaAsegCobLocal, nSumaAsegCobMoneda, nTasa, nPrimaCobLocal, nPrimaCobMoneda, nDeducibleCobLocal,
                nDeducibleCobMoneda, nSalarioMensual, nVecesSalario, nSumaAsegCalculada, nEdad_Minima, nEdad_Maxima, nEdad_Exclusion,
                nSumaAseg_Minima, nSumaAseg_Maxima, nPorcExtraPrimaDet, nMontoExtraPrimaDet, nSumaIngresada, nOrdenImpresion,
                nDeducibleIngresado, nCuotaPromedio, nPrimaPromedio );
   END INSERTAR;

   PROCEDURE ELIMINAR( nCodCia           IN  COTIZACIONES_COBERT_WEB.CodCia%TYPE
                     , nCodEmpresa       IN  COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                     , nIdCotizacion     IN  COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE
                     , nIdetCotizacion   IN  COTIZACIONES_COBERT_WEB.IdetCotizacion%TYPE
                     , nCodGpoCobertWeb  IN  COTIZACIONES_COBERT_WEB.CodGpoCobertWeb%TYPE
                     , cCodCobertWeb     IN  COTIZACIONES_COBERT_WEB.CodCobertWeb%TYPE ) IS
   BEGIN
       DELETE COTIZACIONES_COBERT_WEB
       WHERE  CodCia          = nCodCia
         AND  CodEmpresa      = nCodEmpresa
         AND  IdCotizacion    = nIdCotizacion
         AND  IdetCotizacion  = nIdetCotizacion
         AND  CodGpoCobertWeb = nCodGpoCobertWeb
         AND  CodCobertWeb    = cCodCobertWeb;
   END ELIMINAR;

   FUNCTION SERVICIO_XML( nCodCia           IN  COTIZACIONES_COBERT_WEB.CodCia%TYPE
                        , nCodEmpresa       IN  COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                        , nIdCotizacion     IN  COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE
                        , nIdetCotizacion   IN  COTIZACIONES_COBERT_WEB.IdetCotizacion%TYPE
                        , nCodGpoCobertWeb  IN  COTIZACIONES_COBERT_WEB.CodGpoCobertWeb%TYPE
                        , cCodCobertWeb     IN  COTIZACIONES_COBERT_WEB.CodCobertWeb%TYPE ) RETURN XMLTYPE IS
      --
      cResultado          CLOB;
      xResultado          XMLTYPE;   
      xResultado1         XMLTYPE;
      nCodGpoCobertWeb_1  COTIZACIONES_COBERT_WEB.CodGpoCobertWeb%TYPE;
      cIdTipoSeg          COTIZACIONES.IdTipoSeg%TYPE;
      cPlanCob            COTIZACIONES.PlanCob%TYPE;
      cDescCobertWeb      VARCHAR2(500);
      --
      CURSOR Grupos IS
         SELECT CodGpoCobertWeb, OC_VALORES_DE_LISTAS.BUSCA_LVALOR( 'GPOCOBWEB', CodGpoCobertWeb ) CodGpoCobertWebDesc
         FROM   COTIZACIONES_COBERT_WEB
         WHERE  CodCia          = nCodCia
           AND  CodEmpresa      = nCodEmpresa
           AND  IdCotizacion    = nIdCotizacion
           AND  IdetCotizacion  = NVL( nIdetCotizacion , IdetCotizacion)
           AND  CodGpoCobertWeb = NVL( nCodGpoCobertWeb, CodGpoCobertWeb)
           AND  CodCobertWeb    = NVL( cCodCobertWeb   , CodCobertWeb)
         GROUP BY CodGpoCobertWeb;
      --
      CURSOR Coberturas IS
         SELECT IdetCotizacion    , CodCobertWeb     , SumaAsegCobLocal  , SumaAsegCobMoneda , Tasa           , PrimaCobLocal    , 
                PrimaCobMoneda    , DeducibleCobLocal, DeducibleCobMoneda, SalarioMensual    , VecesSalario   , SumaAsegCalculada,
                Edad_Minima       , Edad_Maxima      , Edad_Exclusion    , SumaAseg_Minima   , SumaAseg_Maxima, PorcExtraPrimaDet,
                MontoExtraPrimaDet, SumaIngresada    , OrdenImpresion    , DeducibleIngresado, CuotaPromedio  , PrimaPromedio
         FROM   COTIZACIONES_COBERT_WEB
         WHERE  CodCia          = nCodCia
           AND  CodEmpresa      = nCodEmpresa
           AND  IdCotizacion    = nIdCotizacion
           AND  IdetCotizacion  = NVL( nIdetCotizacion , IdetCotizacion)
           AND  CodGpoCobertWeb = nCodGpoCobertWeb_1
           AND  CodCobertWeb    = NVL( cCodCobertWeb   , CodCobertWeb)
         ORDER BY IdetCotizacion, CodGpoCobertWeb, CodCobertWeb;
      --
   BEGIN
      SELECT IdTipoSeg, PlanCob
      INTO   cIdTipoSeg, cPlanCob
      FROM   COTIZACIONES
      WHERE  CodCia       = nCodCia
        AND  CodEmpresa   = nCodEmpresa
        AND  IdCotizacion = nIdCotizacion;
      --
      cResultado := '<?xml version="1.0"?> <DATA><IDCOTIZACION>' || nIdCotizacion || '</IDCOTIZACION>';
      --
      FOR x IN Grupos LOOP
          cResultado         := cResultado || '<GPOCOBERT>';
          cResultado         := cResultado || '<CODGPOCOBERTWEB>'  || x.CodGpoCobertWeb     || '</CODGPOCOBERTWEB>';
          cResultado         := cResultado || '<DESCGPOCOBERTWEB>' || x.CodGpoCobertWebDesc || '</DESCGPOCOBERTWEB>';
          nCodGpoCobertWeb_1 := x.CodGpoCobertWeb;
          --
          FOR y IN Coberturas LOOP
             cDescCobertWeb := OC_COBERTURAS_DE_SEGUROS.DESCRIPCION_COBERTURA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, y.CodCobertWeb);
             -- 
             cResultado := cResultado || '<COBERTURA>';
             cResultado := cResultado || '<IDETCOTIZACION>'     || y.IdetCotizacion     || '</IDETCOTIZACION>';
             cResultado := cResultado || '<CODCOBERTWEB>'       || y.CodCobertWeb       || '</CODCOBERTWEB>';
             cResultado := cResultado || '<DESCCOBERTWEB>'      || cDescCobertWeb       || '</DESCCOBERTWEB>';
             cResultado := cResultado || '<SUMAASEGCOBLOCAL>'   || y.SumaAsegCobLocal   || '</SUMAASEGCOBLOCAL>';
             cResultado := cResultado || '<SUMAASEGCOBMONEDA>'  || y.SumaAsegCobMoneda  || '</SUMAASEGCOBMONEDA>';
             cResultado := cResultado || '<TASA>'               || y.Tasa               || '</TASA>';
             cResultado := cResultado || '<PRIMACOBLOCAL>'      || y.PrimaCobLocal      || '</PRIMACOBLOCAL>';
             cResultado := cResultado || '<PRIMACOBMONEDA>'     || y.PrimaCobMoneda     || '</PRIMACOBMONEDA>';
             cResultado := cResultado || '<DEDUCIBLECOBLOCAL>'  || y.DeducibleCobLocal  || '</DEDUCIBLECOBLOCAL>';
             cResultado := cResultado || '<DEDUCIBLECOBMONEDA>' || y.DeducibleCobMoneda || '</DEDUCIBLECOBMONEDA>';
             cResultado := cResultado || '<SALARIOMENSUAL>'     || y.SalarioMensual     || '</SALARIOMENSUAL>';
             cResultado := cResultado || '<VECESSALARIO>'       || y.VecesSalario       || '</VECESSALARIO>';
             cResultado := cResultado || '<SUMAASEGCALCULADA>'  || y.SumaAsegCalculada  || '</SUMAASEGCALCULADA>';
             cResultado := cResultado || '<EDAD_MINIMA>'        || y.Edad_Minima        || '</EDAD_MINIMA>';
             cResultado := cResultado || '<EDAD_MAXIMA>'        || y.Edad_Maxima        || '</EDAD_MAXIMA>';
             cResultado := cResultado || '<EDAD_EXCLUSION>'     || y.Edad_Exclusion     || '</EDAD_EXCLUSION>';
             cResultado := cResultado || '<SUMAASEG_MINIMA>'    || y.SumaAseg_Minima    || '</SUMAASEG_MINIMA>';
             cResultado := cResultado || '<SUMAASEG_MAXIMA>'    || y.SumaAseg_Maxima    || '</SUMAASEG_MAXIMA>';
             cResultado := cResultado || '<PORCEXTRAPRIMADET>'  || y.PorcExtraPrimaDet  || '</PORCEXTRAPRIMADET>';
             cResultado := cResultado || '<MONTOEXTRAPRIMADET>' || y.MontoExtraPrimaDet || '</MONTOEXTRAPRIMADET>';
             cResultado := cResultado || '<SUMAINGRESADA>'      || y.SumaIngresada      || '</SUMAINGRESADA>';
             cResultado := cResultado || '<ORDENIMPRESION>'     || y.OrdenImpresion     || '</ORDENIMPRESION>';
             cResultado := cResultado || '<DEDUCIBLEINGRESADO>' || y.DeducibleIngresado || '</DEDUCIBLEINGRESADO>';
             cResultado := cResultado || '<CUOTAPROMEDIO>'      || y.CuotaPromedio      || '</CUOTAPROMEDIO>';
             cResultado := cResultado || '<PRIMAPROMEDIO>'      || y.PrimaPromedio      || '</PRIMAPROMEDIO>';
             cResultado := cResultado || '</COBERTURA>';
          END LOOP;
          --
          cResultado := cResultado || '</GPOCOBERT>';
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
   END SERVICIO_XML;

   PROCEDURE COPIAR_COTIZACION( nCodCia            IN  COTIZACIONES_COBERT_WEB.CodCia%TYPE
                              , nCodEmpresa        IN  COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                              , nIdCotizacionOrig  IN  COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE
                              , nIdCotizacion      IN  COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE) IS
      cCodGpoCobertWebDesc  VARCHAR2(200);
      
      CURSOR COB_WEB_Q IS
         SELECT IDetCotizacion, CodGpoCobertWeb, CodCobertWeb, SumaAsegCobLocal, SumaAsegCobMoneda,
                Tasa, PrimaCobLocal, PrimaCobMoneda, DeducibleCobLocal, DeducibleCobMoneda,
                SalarioMensual, VecesSalario, SumaAsegCalculada, Edad_Minima, Edad_Maxima,
                Edad_Exclusion, SumaAseg_Minima, SumaAseg_Maxima, PorcExtraprimaDet, MontoExtraprimaDet,
                SumaIngresada, OrdenImpresion, DeducibleIngresado, CuotaPromedio, PrimaPromedio
           FROM COTIZACIONES_COBERT_WEB
          WHERE CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa
            AND IdCotizacion  = nIdCotizacionOrig;
   BEGIN
      FOR W IN COB_WEB_Q LOOP
         --Valido que exista el Grupo Cobertura Web
         cCodGpoCobertWebDesc := OC_VALORES_DE_LISTAS.BUSCA_LVALOR( 'GPOCOBWEB', W.CodGpoCobertWeb);
         IF cCodGpoCobertWebDesc <> 'Invalida' THEN
            OC_COTIZACIONES_COBERT_WEB.INSERTAR( nCodCia             , nCodEmpresa           , nIdCotizacion       , W.IDetCotizacion   ,
                                                 W.CodGpoCobertWeb   , W.CodCobertWeb        , W.SumaAsegCobLocal  , W.SumaAsegCobMoneda,
                                                 W.Tasa              , W.PrimaCobLocal       , W.PrimaCobMoneda    , W.DeducibleCobLocal,
                                                 W.DeducibleCobMoneda, W.SalarioMensual      , W.VecesSalario      , W.SumaAsegCalculada,
                                                 W.Edad_Minima       , W.Edad_Maxima         , W.Edad_Exclusion    , W.SumaAseg_Minima  ,
                                                 W.SumaAseg_Maxima   , W.PorcExtraPrimaDet   , W.MontoExtraPrimaDet, W.SumaIngresada    ,
                                                 W.OrdenImpresion    , W.DeducibleIngresado  , W.CuotaPromedio     , W.PrimaPromedio );
         END IF;
      END LOOP;
   END COPIAR_COTIZACION;

    FUNCTION COBERTURAS_XML( nCodCia           IN  COTIZACIONES_COBERT_WEB.CodCia%TYPE
                           , nCodEmpresa       IN  COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                           , nIdCotizacion     IN  COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE
                           , nIdetCotizacion   IN  COTIZACIONES_COBERT_WEB.IdetCotizacion%TYPE
                           , nCodGpoCobertWeb  IN  COTIZACIONES_COBERT_WEB.CodGpoCobertWeb%TYPE
                           , cCodCobertWeb     IN  COTIZACIONES_COBERT_WEB.CodCobertWeb%TYPE ) RETURN XMLTYPE IS
       --
    cResultado           CLOB;
    xResultado           XMLTYPE;   
    xResultado1          XMLTYPE;
    nCodGpoCobertWeb_1   COTIZACIONES_COBERT_WEB.CodGpoCobertWeb%TYPE;
    cIdTipoSeg           COTIZACIONES.IdTipoSeg%TYPE;
    cPlanCob             COTIZACIONES.PlanCob%TYPE;
    cDescCobertWeb       VARCHAR2(500);
    cIndAsegModelo       COTIZACIONES.IndAsegModelo%TYPE;
       --
    CURSOR Grupos IS
       SELECT A.CodGpoCobertWeb, OC_VALORES_DE_LISTAS.BUSCA_LVALOR( 'GPOCOBWEB', A.CodGpoCobertWeb ) CodGpoCobertWebDesc
         FROM COTIZACIONES_COBERT_WEB    A
          ,   COTIZACIONES_COBERT_MASTER B
        WHERE A.CodCia            = B.CodCia
          AND A.CodEmpresa        = B.CodEmpresa
          AND A.IdCotizacion      = B.IdCotizacion
          AND A.IdetCotizacion    = B.IdetCotizacion
          AND A.CodCobertWeb      = B.CodCobert
          AND A.CodCia            = nCodCia
          AND A.CodEmpresa        = nCodEmpresa
          AND A.IdCotizacion      = nIdCotizacion
          AND A.IdetCotizacion    = NVL( nIdetCotizacion , A.IdetCotizacion)
          AND A.CodGpoCobertWeb   = NVL( nCodGpoCobertWeb, A.CodGpoCobertWeb)
          AND A.CodCobertWeb      = NVL( cCodCobertWeb   , A.CodCobertWeb)
        GROUP BY A.CodGpoCobertWeb;
       --
       CURSOR Coberturas IS
          SELECT C.IdetCotizacion    , C.CodCobert        , C.SumaAsegCobLocal  , C.SumaAsegCobMoneda , C.Tasa           , C.PrimaCobLocal    , 
                 C.PrimaCobMoneda    , C.DeducibleCobLocal, C.DeducibleCobMoneda, C.SalarioMensual    , C.VecesSalario   , C.SumaAsegCalculada,
                 C.Edad_Minima       , C.Edad_Maxima      , C.Edad_Exclusion    , C.SumaAseg_Minima   , C.SumaAseg_Maxima, C.PorcExtraPrimaDet,
                 C.MontoExtraPrimaDet, C.SumaIngresada    , B.OrdenImpresion    , C.DeducibleIngresado, C.CuotaPromedio  , C.PrimaPromedio
            FROM COTIZACIONES_COBERT_WEB    A
             ,   COTIZACIONES_COBERT_MASTER B
             ,   COTIZACIONES_COBERT_ASEG   C
           WHERE A.CodCia            = B.CodCia
             AND A.CodEmpresa        = B.CodEmpresa
             AND A.IdCotizacion      = B.IdCotizacion
             AND A.IdetCotizacion    = B.IdetCotizacion
             AND A.CodCobertWeb      = B.CodCobert
             AND B.CodCia            = C.CodCia
             AND B.CodEmpresa        = C.CodEmpresa
             AND B.IdCotizacion      = C.IdCotizacion
             AND B.IdetCotizacion    = C.IdetCotizacion
             AND B.CodCobert         = C.CodCobert
             AND A.CodCia            = nCodCia
             AND A.CodEmpresa        = nCodEmpresa
             AND A.IdCotizacion      = nIdCotizacion
             AND A.IdetCotizacion    = NVL( nIdetCotizacion , A.IdetCotizacion)
             AND A.CodGpoCobertWeb   = nCodGpoCobertWeb_1
             AND A.CodCobertWeb      = NVL( cCodCobertWeb   , A.CodCobertWeb)
           ORDER BY A.IdetCotizacion, A.CodGpoCobertWeb, A.CodCobertWeb;
       --
       CURSOR COBERT_SUBGPO_Q IS
          SELECT C.IdetCotizacion    , C.CodCobert        , C.SumaAsegCobLocal  , C.SumaAsegCobMoneda , C.Tasa           , C.PrimaCobLocal    , 
                 C.PrimaCobMoneda    , C.DeducibleCobLocal, C.DeducibleCobMoneda, C.SalarioMensual    , C.VecesSalario   , C.SumaAsegCalculada,
                 C.Edad_Minima       , C.Edad_Maxima      , C.Edad_Exclusion    , C.SumaAseg_Minima   , C.SumaAseg_Maxima, C.PorcExtraPrimaDet,
                 C.MontoExtraPrimaDet, C.SumaIngresada    , B.OrdenImpresion    , C.DeducibleIngresado, C.CuotaPromedio  , C.PrimaPromedio
            FROM COTIZACIONES_COBERT_WEB    A
             ,   COTIZACIONES_COBERT_MASTER B
             ,   COTIZACIONES_COBERTURAS   C
           WHERE A.CodCia            = B.CodCia
             AND A.CodEmpresa        = B.CodEmpresa
             AND A.IdCotizacion      = B.IdCotizacion
             AND A.IdetCotizacion    = B.IdetCotizacion
             AND A.CodCobertWeb      = B.CodCobert
             AND B.CodCia            = C.CodCia
             AND B.CodEmpresa        = C.CodEmpresa
             AND B.IdCotizacion      = C.IdCotizacion
             AND B.IdetCotizacion    = C.IdetCotizacion
             AND B.CodCobert         = C.CodCobert
             AND A.CodCia            = nCodCia
             AND A.CodEmpresa        = nCodEmpresa
             AND A.IdCotizacion      = nIdCotizacion
             AND A.IdetCotizacion    = NVL( nIdetCotizacion , A.IdetCotizacion)
             AND CodGpoCobertWeb     = nCodGpoCobertWeb_1
             AND A.CodCobertWeb      = NVL( cCodCobertWeb   , A.CodCobertWeb)
           ORDER BY A.IdetCotizacion, A.CodGpoCobertWeb, A.CodCobertWeb;
           
    BEGIN
       SELECT IdTipoSeg, PlanCob, IndAsegModelo
         INTO cIdTipoSeg, cPlanCob, cIndAsegModelo
         FROM COTIZACIONES
        WHERE CodCia        = nCodCia
          AND CodEmpresa    = nCodEmpresa
          AND IdCotizacion  = nIdCotizacion;
       --
       cResultado := '<?xml version="1.0"?> <DATA><IDCOTIZACION>' || nIdCotizacion || '</IDCOTIZACION>';
       
       FOR x IN Grupos LOOP
          cResultado         := cResultado || '<GPOCOBERT>';
          cResultado         := cResultado || '<CODGPOCOBERTWEB>'  || x.CodGpoCobertWeb     || '</CODGPOCOBERTWEB>';
          cResultado         := cResultado || '<DESCGPOCOBERTWEB>' || x.CodGpoCobertWebDesc || '</DESCGPOCOBERTWEB>';
          nCodGpoCobertWeb_1 := x.CodGpoCobertWeb;
          --
          IF NVL(cIndAsegModelo,'N') = 'S' THEN
             FOR y IN COBERT_SUBGPO_Q LOOP
                cDescCobertWeb := OC_COBERTURAS_DE_SEGUROS.DESCRIPCION_COBERTURA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, y.CodCobert);
                -- 
                cResultado := cResultado || '<COBERTURA>';
                cResultado := cResultado || '<IDETCOTIZACION>'     || y.IdetCotizacion     || '</IDETCOTIZACION>';
                cResultado := cResultado || '<CODCOBERTWEB>'       || y.CodCobert          || '</CODCOBERTWEB>';
                cResultado := cResultado || '<DESCCOBERTWEB>'      || cDescCobertWeb       || '</DESCCOBERTWEB>';
                cResultado := cResultado || '<SUMAASEGCOBLOCAL>'   || y.SumaAsegCobLocal   || '</SUMAASEGCOBLOCAL>';
                cResultado := cResultado || '<SUMAASEGCOBMONEDA>'  || y.SumaAsegCobMoneda  || '</SUMAASEGCOBMONEDA>';
                cResultado := cResultado || '<TASA>'               || y.Tasa               || '</TASA>';
                cResultado := cResultado || '<PRIMACOBLOCAL>'      || y.PrimaCobLocal      || '</PRIMACOBLOCAL>';
                cResultado := cResultado || '<PRIMACOBMONEDA>'     || y.PrimaCobMoneda     || '</PRIMACOBMONEDA>';
                cResultado := cResultado || '<DEDUCIBLECOBLOCAL>'  || y.DeducibleCobLocal  || '</DEDUCIBLECOBLOCAL>';
                cResultado := cResultado || '<DEDUCIBLECOBMONEDA>' || y.DeducibleCobMoneda || '</DEDUCIBLECOBMONEDA>';
                cResultado := cResultado || '<SALARIOMENSUAL>'     || y.SalarioMensual     || '</SALARIOMENSUAL>';
                cResultado := cResultado || '<VECESSALARIO>'       || y.VecesSalario       || '</VECESSALARIO>';
                cResultado := cResultado || '<SUMAASEGCALCULADA>'  || y.SumaAsegCalculada  || '</SUMAASEGCALCULADA>';
                cResultado := cResultado || '<EDAD_MINIMA>'        || y.Edad_Minima        || '</EDAD_MINIMA>';
                cResultado := cResultado || '<EDAD_MAXIMA>'        || y.Edad_Maxima        || '</EDAD_MAXIMA>';
                cResultado := cResultado || '<EDAD_EXCLUSION>'     || y.Edad_Exclusion     || '</EDAD_EXCLUSION>';
                cResultado := cResultado || '<SUMAASEG_MINIMA>'    || y.SumaAseg_Minima    || '</SUMAASEG_MINIMA>';
                cResultado := cResultado || '<SUMAASEG_MAXIMA>'    || y.SumaAseg_Maxima    || '</SUMAASEG_MAXIMA>';
                cResultado := cResultado || '<PORCEXTRAPRIMADET>'  || y.PorcExtraPrimaDet  || '</PORCEXTRAPRIMADET>';
                cResultado := cResultado || '<MONTOEXTRAPRIMADET>' || y.MontoExtraPrimaDet || '</MONTOEXTRAPRIMADET>';
                cResultado := cResultado || '<SUMAINGRESADA>'      || y.SumaIngresada      || '</SUMAINGRESADA>';
                cResultado := cResultado || '<ORDENIMPRESION>'     || y.OrdenImpresion     || '</ORDENIMPRESION>';
                cResultado := cResultado || '<DEDUCIBLEINGRESADO>' || y.DeducibleIngresado || '</DEDUCIBLEINGRESADO>';
                cResultado := cResultado || '<CUOTAPROMEDIO>'      || y.CuotaPromedio      || '</CUOTAPROMEDIO>';
                cResultado := cResultado || '<PRIMAPROMEDIO>'      || y.PrimaPromedio      || '</PRIMAPROMEDIO>';
                cResultado := cResultado || '</COBERTURA>';
             END LOOP;
          ELSE
             FOR y IN Coberturas LOOP
                cDescCobertWeb := OC_COBERTURAS_DE_SEGUROS.DESCRIPCION_COBERTURA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, y.CodCobert);
                -- 
                cResultado := cResultado || '<COBERTURA>';
                cResultado := cResultado || '<IDETCOTIZACION>'     || y.IdetCotizacion     || '</IDETCOTIZACION>';
                cResultado := cResultado || '<CODCOBERTWEB>'       || y.CodCobert          || '</CODCOBERTWEB>';
                cResultado := cResultado || '<DESCCOBERTWEB>'      || cDescCobertWeb       || '</DESCCOBERTWEB>';
                cResultado := cResultado || '<SUMAASEGCOBLOCAL>'   || y.SumaAsegCobLocal   || '</SUMAASEGCOBLOCAL>';
                cResultado := cResultado || '<SUMAASEGCOBMONEDA>'  || y.SumaAsegCobMoneda  || '</SUMAASEGCOBMONEDA>';
                cResultado := cResultado || '<TASA>'               || y.Tasa               || '</TASA>';
                cResultado := cResultado || '<PRIMACOBLOCAL>'      || y.PrimaCobLocal      || '</PRIMACOBLOCAL>';
                cResultado := cResultado || '<PRIMACOBMONEDA>'     || y.PrimaCobMoneda     || '</PRIMACOBMONEDA>';
                cResultado := cResultado || '<DEDUCIBLECOBLOCAL>'  || y.DeducibleCobLocal  || '</DEDUCIBLECOBLOCAL>';
                cResultado := cResultado || '<DEDUCIBLECOBMONEDA>' || y.DeducibleCobMoneda || '</DEDUCIBLECOBMONEDA>';
                cResultado := cResultado || '<SALARIOMENSUAL>'     || y.SalarioMensual     || '</SALARIOMENSUAL>';
                cResultado := cResultado || '<VECESSALARIO>'       || y.VecesSalario       || '</VECESSALARIO>';
                cResultado := cResultado || '<SUMAASEGCALCULADA>'  || y.SumaAsegCalculada  || '</SUMAASEGCALCULADA>';
                cResultado := cResultado || '<EDAD_MINIMA>'        || y.Edad_Minima        || '</EDAD_MINIMA>';
                cResultado := cResultado || '<EDAD_MAXIMA>'        || y.Edad_Maxima        || '</EDAD_MAXIMA>';
                cResultado := cResultado || '<EDAD_EXCLUSION>'     || y.Edad_Exclusion     || '</EDAD_EXCLUSION>';
                cResultado := cResultado || '<SUMAASEG_MINIMA>'    || y.SumaAseg_Minima    || '</SUMAASEG_MINIMA>';
                cResultado := cResultado || '<SUMAASEG_MAXIMA>'    || y.SumaAseg_Maxima    || '</SUMAASEG_MAXIMA>';
                cResultado := cResultado || '<PORCEXTRAPRIMADET>'  || y.PorcExtraPrimaDet  || '</PORCEXTRAPRIMADET>';
                cResultado := cResultado || '<MONTOEXTRAPRIMADET>' || y.MontoExtraPrimaDet || '</MONTOEXTRAPRIMADET>';
                cResultado := cResultado || '<SUMAINGRESADA>'      || y.SumaIngresada      || '</SUMAINGRESADA>';
                cResultado := cResultado || '<ORDENIMPRESION>'     || y.OrdenImpresion     || '</ORDENIMPRESION>';
                cResultado := cResultado || '<DEDUCIBLEINGRESADO>' || y.DeducibleIngresado || '</DEDUCIBLEINGRESADO>';
                cResultado := cResultado || '<CUOTAPROMEDIO>'      || y.CuotaPromedio      || '</CUOTAPROMEDIO>';
                cResultado := cResultado || '<PRIMAPROMEDIO>'      || y.PrimaPromedio      || '</PRIMAPROMEDIO>';
                cResultado := cResultado || '</COBERTURA>';
             END LOOP;
          END IF;
          --
          cResultado := cResultado || '</GPOCOBERT>';
       END LOOP;
       cResultado := cResultado || '</DATA>';

       xResultado1 := XMLType(cResultado);

       SELECT XMLROOT (xResultado1, VERSION '1.0" encoding="UTF-8')
         INTO xResultado
         FROM DUAL;

       RETURN xResultado;
    EXCEPTION
       WHEN OTHERS THEN
          RETURN NULL;
    END COBERTURAS_XML;

    FUNCTION ACTUALIZAR( nCodCia        IN  COTIZACIONES_COBERT_WEB.CodCia%TYPE
                       , nCodEmpresa    IN  COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                       , xDatos         IN  XMLTYPE  
                       , xPrima         OUT XMLTYPE) RETURN XMLTYPE IS
    --Variables para el control del XML
    xParse               XMLPARSER.PARSER;
    xDocumento           XMLDOM.DOMDOCUMENT;
    xNodosPadre          XMLDOM.DOMNODELIST;
    xElementoPadre       XMLDOM.DOMNODE;
    xNodosHijo           XMLDOM.DOMNODELIST;
    xElementoHijo        XMLDOM.DOMNODE;
    xNodosNieto          XMLDOM.DOMNODELIST;
    xElementoNieto       XMLDOM.DOMNODE;
    cXml                 CLOB;
    --
    nIdCotizacion        COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE;
    nCodGpoCobertWeb     COTIZACIONES_COBERT_WEB.CodGpoCobertWeb%TYPE;
    cDescGpoCobertWeb    VARCHAR2(1000);
    --
    nIdetCotizacion      COTIZACIONES_COBERT_WEB.IdetCotizacion%TYPE;
    cCodCobertWeb        COTIZACIONES_COBERT_WEB.CodCobertWeb%TYPE;
    nSumaAsegCobLocal    COTIZACIONES_COBERT_WEB.SumaAsegCobLocal%TYPE;
    nSumaAsegCobMoneda   COTIZACIONES_COBERT_WEB.SumaAsegCobMoneda%TYPE;
    nTasa				      COTIZACIONES_COBERT_WEB.Tasa%TYPE;	            
    nPrimaCobLocal       COTIZACIONES_COBERT_WEB.PrimaCobLocal%TYPE;	    
    nPrimaCobMoneda      COTIZACIONES_COBERT_WEB.PrimaCobMoneda%TYPE;	
    nDeducibleCobLocal	COTIZACIONES_COBERT_WEB.DeducibleCobLocal%TYPE;	
    nDeducibleCobMoneda  COTIZACIONES_COBERT_WEB.DeducibleCobMoneda%TYPE;
    nSalarioMensual	   COTIZACIONES_COBERT_WEB.SalarioMensual%TYPE;	
    nVecesSalario        COTIZACIONES_COBERT_WEB.VecesSalario %TYPE;	    
    nSumaAsegCalculada   COTIZACIONES_COBERT_WEB.SumaAsegCalculada%TYPE;	
    nEdad_Minima         COTIZACIONES_COBERT_WEB.Edad_Minima%TYPE;	    
    nEdad_Maxima	      COTIZACIONES_COBERT_WEB.Edad_Maxima%TYPE;	    
    nEdad_Exclusion      COTIZACIONES_COBERT_WEB.Edad_Exclusion%TYPE;	
    nSumaAseg_Minima	   COTIZACIONES_COBERT_WEB.SumaAseg_Minima%TYPE;	
    nSumaAseg_Maxima     COTIZACIONES_COBERT_WEB.SumaAseg_Maxima%TYPE;	
    nPorcExtraprimaDet	COTIZACIONES_COBERT_WEB.PorcExtraprimaDet%TYPE;	
    nMontoExtraprimaDet	COTIZACIONES_COBERT_WEB.MontoExtraprimaDet%TYPE;          
    nSumaIngresada       COTIZACIONES_COBERT_WEB.SumaIngresada%TYPE;	    
    nOrdenImpresion      COTIZACIONES_COBERT_WEB.OrdenImpresion%TYPE;	
    nDeducibleIngresado  COTIZACIONES_COBERT_WEB.DeducibleIngresado%TYPE;
    nCuotaPromedio       COTIZACIONES_COBERT_WEB.CuotaPromedio%TYPE;	    
    nPrimaPromedio       COTIZACIONES_COBERT_WEB.PrimaPromedio%TYPE;	 

    cExiste              VARCHAR2(1);
    --
    xResultado           XMLTYPE;   
    --
    cIdTipoSeg           SICAS_OC.COTIZACIONES.IdTipoSeg%TYPE;
    cPlanCob             SICAS_OC.COTIZACIONES.PlanCob%TYPE;
    nPrimaCotLocal       SICAS_OC.COTIZACIONES.PrimaCotLocal%TYPE;
    nPrimaCotMoneda      SICAS_OC.COTIZACIONES.PrimaCotMoneda%TYPE;
    nGastosExpedicion    SICAS_OC.COTIZACIONES.GastosExpedicion%TYPE;
    cCodPlanPago         SICAS_OC.COTIZACIONES.CodPlanPago%TYPE;
    nMontoIva            NUMBER(14,2);

    cIndAsegModelo       SICAS_OC.COTIZACIONES.IndAsegModelo%TYPE;
    cIndListadoAseg      SICAS_OC.COTIZACIONES.IndListadoAseg%TYPE;
    --
    nFactorAjuste        SICAS_OC.COTIZACIONES.FactorAjuste%TYPE;
    cEscala              FACTOR_ESCALA_PO.Escala%TYPE;
    xFactorEscalaPO      XMLTYPE;

       CURSOR Cotizaciones IS
       SELECT DISTINCT CodCia, CodEmpresa, IdCotizacion, IdetCotizacion
         FROM COTIZACIONES_COBERT_WEB_TEMP
        WHERE CodCia        = nCodCia
          AND CodEmpresa    = nCodEmpresa
          AND IdCotizacion  = nIdCotizacion;
    --
    CURSOR Cotizacion_Coberturas IS
       SELECT CodCia, CodEmpresa, IdCotizacion, IdetCotizacion, CodGpoCobertWeb, CodCobertWeb, SumaAsegCobLocal, SumaAsegCobMoneda,
              Tasa, PrimaCobLocal, PrimaCobMoneda, DeducibleCobLocal,	DeducibleCobMoneda, SalarioMensual,	VecesSalario, SumaAsegCalculada,
              Edad_Minima, Edad_Maxima,	Edad_Exclusion, Sumaaseg_Minima,	Sumaaseg_Maxima, PorcExtraprimaDet,	MontoExtraprimaDet,	
              SumaIngresada, OrdenImpresion, DeducibleIngresado, CuotaPromedio, PrimaPromedio
         FROM COTIZACIONES_COBERT_WEB_TEMP
        WHERE CodCia        = nCodCia
          AND CodEmpresa    = nCodEmpresa
          AND IdCotizacion  = nIdCotizacion;
          
    CURSOR COT_ASEG_Q IS
       SELECT CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, IdAsegurado
         FROM COTIZACIONES_ASEG
        WHERE CodCia           = nCodCia
          AND CodEmpresa       = nCodEmpresa
          AND IdCotizacion     = nIdCotizacion;
          --AND IDetCotizacion   = nIdetCotizacion;
          
    CURSOR COT_SUBGPO_Q IS
       SELECT CodCia, CodEmpresa, IdCotizacion, IDetCotizacion
         FROM COTIZACIONES_DETALLE
        WHERE CodCia        = nCodCia
          AND CodEmpresa    = nCodEmpresa
          AND IdCotizacion  = nIdCotizacion;
          
    BEGIN
       EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
       --
       DELETE COTIZACIONES_COBERT_WEB_TEMP;
       --
       cXml := xDatos.GETCLOBVAL();
       --
       --Parseo el contenido del documento xml
       xParse := XMLPARSER.NEWPARSER();
       XMLPARSER.PARSECLOB( xParse, cXml ); 
       --
       --Obtenemos el documento xml cargado en un objeto DOM
       xDocumento := XMLPARSER.GETDOCUMENT( xParse );
       XMLPARSER.FREEPARSER( xParse );
       xNodosPadre := XMLDOM.GETCHILDRENBYTAGNAME( XMLDOM.GETDOCUMENTELEMENT( xDocumento ), '*' );
       --
       --Recorremos cada nodo del arreglo, el arreglo inicio en el item 0  --- Aca devuelve 7
       FOR x IN 1..XMLDOM.GETLENGTH( xNodosPadre ) LOOP
          xElementoPadre := XMLDOM.ITEM( xNodosPadre, x - 1 );
          --
          IF x = 1 THEN 
             nIdCotizacion := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoPadre ));
          END IF;
       END LOOP;
       --
       --Empiezo en el nodo que necesitamos
       FOR x IN 2..XMLDOM.GETLENGTH( xNodosPadre ) LOOP
          --
          xElementoPadre := XMLDOM.ITEM( xNodosPadre, x - 1 );
          --
          -- obtenemos la lista d eelementos que tiene el nodo actual
          xNodosHijo := XMLDOM.GETCHILDNODES( xElementoPadre );
          --
          FOR y IN 1..XMLDOM.GETLENGTH( xNodosHijo ) LOOP
             --
             --obtenemos un elemento
             xElementoHijo := XMLDOM.ITEM( xNodosHijo, y - 1 );
             --
             IF y = 1 THEN
                nCodGpoCobertWeb := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo ));
             ELSIF y = 2 THEN
                cDescGpoCobertWeb := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoHijo ));
             END IF;
          END LOOP;
          --
          --Empiezo en el nodo que necesitamos
          FOR a IN 3..XMLDOM.GETLENGTH( xNodosHijo ) LOOP
             --
             xElementoHijo := XMLDOM.ITEM( xNodosHijo, a - 1 );
             --
             -- obtenemos la lista d eelementos que tiene el nodo actual
             xNodosNieto := XMLDOM.GETCHILDNODES( xElementoHijo );
             --
             FOR b IN 1..XMLDOM.GETLENGTH( xNodosNieto ) LOOP
                --
                --obtenemos un elemento
                xElementoNieto := XMLDOM.ITEM( xNodosNieto, b - 1 );
                --
                IF b = 1 THEN
                   nIdetCotizacion      := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));
                ELSIF b = 2 THEN
                   cCodCobertWeb        := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));
                ELSIF b = 3 THEN
                   nSumaAsegCobLocal    := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));
                ELSIF b = 4 THEN
                   nSumaAsegCobMoneda   := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));
                ELSIF b = 5 THEN   
                   nTasa	               := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));
                ELSIF b = 6 THEN
                   nPrimaCobLocal       := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));
                ELSIF b = 7 THEN
                   nPrimaCobMoneda      := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));
                ELSIF b = 8 THEN
                   nDeducibleCobLocal   := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));	
                ELSIF b = 9 THEN
                   nDeducibleCobMoneda  := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));
                ELSIF b = 10 THEN
                   nSalarioMensual	   := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));  
                ELSIF b = 11 THEN
                   nVecesSalario        := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));
                ELSIF b = 12 THEN
                   nSumaAsegCalculada   := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));
                ELSIF b = 13 THEN
                   nEdad_Minima         := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));    
                ELSIF b = 14 THEN
                   nEdad_Maxima	      := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));   
                ELSIF b = 15 THEN
                   nEdad_Exclusion      := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));  
                ELSIF b = 16 THEN
                   nSumaAseg_Minima	   := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));
                ELSIF b = 17 THEN
                   nSumaAseg_Maxima     := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));
                ELSIF b = 18 THEN 
                   nPorcExtraprimaDet   := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));	
                ELSIF b = 19 THEN
                   nMontoExtraprimaDet  := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));
                ELSIF b = 20 THEN
                   nSumaIngresada       := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));     
                ELSIF b = 21 THEN
                   nOrdenImpresion      := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));    
                ELSIF b = 22 THEN
                   nDeducibleIngresado  := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));
                ELSIF b = 23 THEN
                   nCuotaPromedio       := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));    
                ELSIF b = 24 THEN
                   nPrimaPromedio       := XMLDOM.GETNODEVALUE( XMLDOM.GETFIRSTCHILD( xElementoNieto ));    
                END IF;
             END LOOP;
             --
             INSERT INTO COTIZACIONES_COBERT_WEB_TEMP
                ( CodCia, CodEmpresa, IdCotizacion, IdetCotizacion, CodGpoCobertWeb, CodCobertWeb, SumaAsegCobLocal, SumaAsegCobMoneda, 
                  Tasa, PrimaCoblocal, PrimaCobMoneda, DeducibleCobLocal, DeducibleCobMoneda,SalarioMensual,VecesSalario,SumaAsegCalculada,
                  Edad_Minima,Edad_Maxima,Edad_Exclusion,SumaAseg_Minima,SumaAseg_Maxima,PorcExtraPrimaDet,MontoExtraPrimaDet,SumaIngresada,
                  OrdenImpresion,DeducibleIngresado,CuotaPromedio,PrimaPromedio)
             VALUES ( nCodCia, nCodEmpresa, nIdCotizacion, nIdetCotizacion, nCodGpoCobertWeb, cCodCobertWeb, nSumaAsegCobLocal, nSumaAsegCobMoneda,
                      nTasa, nPrimaCoblocal, nPrimaCobMoneda, nDeducibleCobLocal, nDeducibleCobMoneda, nSalarioMensual, nVecesSalario, nSumaAsegCalculada,
                      nEdad_Minima, nEdad_Maxima, nEdad_Exclusion, nSumaAseg_Minima, nSumaAseg_Maxima, nPorcExtraPrimaDet, nMontoExtraPrimaDet, nSumaIngresada,
                      nOrdenImpresion, nDeducibleIngresado, nCuotaPromedio, nPrimaPromedio);
          END LOOP;
       END LOOP;
       BEGIN
          SELECT IdTipoSeg, PlanCob, CodPlanPago, IndAsegModelo, IndListadoAseg
            INTO cIdTipoSeg, cPlanCob, cCodPlanPago, cIndAsegModelo, cIndListadoAseg
            FROM COTIZACIONES
           WHERE CodCia        = nCodCia
             AND CodEmpresa    = nCodEmpresa
             AND IdCotizacion  = nIdCotizacion;
       END;
       --
       FOR x IN Cotizaciones LOOP
          DELETE COTIZACIONES_COBERT_MASTER A
          WHERE  A.CodCia         = x.CodCia
            AND  A.CodEmpresa     = x.CodEmpresa
            AND  A.IdCotizacion   = x.IdCotizacion
            AND  A.IdetCotizacion = x.IdetCotizacion;
    --        AND  A.CodCobert NOT IN ( SELECT B.CodCobertWeb
    --                                  FROM   COTIZACIONES_COBERT_WEB_TEMP B
    --                                  WHERE  B.CodCia         = A.CodCia
    --                                    AND  B.CodEmpresa     = A.CodEmpresa
    --                                    AND  B.IdCotizacion   = A.IdCotizacion
    --                                    AND  B.IdetCotizacion = A.IdetCotizacion );
          --
          IF NVL(cIndAsegModelo,'N') = 'S' THEN
             DELETE COTIZACIONES_COBERTURAS A
             WHERE  A.CodCia         = x.CodCia
               AND  A.CodEmpresa     = x.CodEmpresa
               AND  A.IdCotizacion   = x.IdCotizacion
               AND  A.IdetCotizacion = x.IdetCotizacion;
    --        AND  A.CodCobert NOT IN ( SELECT B.CodCobertWeb
    --                                  FROM   COTIZACIONES_COBERT_WEB_TEMP B
    --                                  WHERE  B.CodCia         = A.CodCia
    --                                    AND  B.CodEmpresa     = A.CodEmpresa
    --                                    AND  B.IdCotizacion   = A.IdCotizacion
    --                                    AND  B.IdetCotizacion = A.IdetCotizacion );
          --
          
          ELSE
             DELETE COTIZACIONES_COBERT_ASEG A
             WHERE  A.CodCia         = x.CodCia
               AND  A.CodEmpresa     = x.CodEmpresa
               AND  A.IdCotizacion   = x.IdCotizacion
               AND  A.IdetCotizacion = x.IdetCotizacion;
       --        AND  A.CodCobert NOT IN ( SELECT B.CodCobertWeb
       --                                  FROM   COTIZACIONES_COBERT_WEB_TEMP B
       --                                  WHERE  B.CodCia         = A.CodCia
       --                                    AND  B.CodEmpresa     = A.CodEmpresa
       --                                    AND  B.IdCotizacion   = A.IdCotizacion
       --                                    AND  B.IdetCotizacion = A.IdetCotizacion );
          END IF;
       END LOOP;
       -- 
       FOR x IN Cotizacion_Coberturas LOOP --- ACTUALIZA FACTOR DE AJUSTE PO ANTES DE CARGAR COBERTURAS
          IF OC_FACTOR_ESCALA_PO.EXISTE_FACTOR_ESCALA(X.CodCia, X.CodEmpresa, cIdTipoSeg, cPlanCob , X.CodCobertWeb) = 'S' THEN
             cEscala := OC_FACTOR_ESCALA_PO.ESCALA(X.CodCia, X.CodEmpresa, cIdTipoSeg, cPlanCob , X.CodCobertWeb);
             IF cEscala != 'X' THEN 
                nFactorAjuste := OC_FACTOR_ESCALA_PO.FACTOR_ESCALA(X.CodCia, X.CodEmpresa, cIdTipoSeg, cPlanCob , X.CodCobertWeb , cEscala);
             END IF;
          END IF;
          IF nFactorAjuste != 1 THEN 
             SELECT XMLROOT(XMLELEMENT("DATA",
                         XMLELEMENT("FactorAjuste",nFactorAjuste)),
                    VERSION '1.0" encoding="UTF-8')
               INTO xFactorEscalaPO
               FROM DUAL;
             
             GENERALES_PLATAFORMA_DIGITAL.RECIBE_GENERALES_COTIZACION(nCodCia, nCodEmpresa, nIdCotizacion, xFactorEscalaPO);
          END IF;
       END LOOP;
       
       IF NVL(cIndAsegModelo,'N') = 'S' THEN
          FOR I IN COT_SUBGPO_Q LOOP
             FOR X IN Cotizacion_Coberturas LOOP
                GT_COTIZACIONES_COBERTURAS.CARGAR_COBERTURAS(I.CodCia, I.CodEmpresa, cIdTipoSeg,
                                                             cPlanCob, I.IdCotizacion,  
                                                             I.IdetCotizacion, 0, X.CodCobertWeb,
                                                             NVL(x.SumaAsegCalculada,0), NVL(x.SalarioMensual,0),
                                                             NVL(x.VecesSalario,0), NVL(x.Edad_Minima,0), 
                                                             NVL(x.Edad_Maxima,0), NVL(x.Edad_Exclusion,0),
                                                             NVL(x.SumaAseg_Minima,0), NVL(x.SumaAseg_Maxima,0),
                                                             NVL(x.PorcExtraPrimaDet,0), NVL(x.MontoExtraprimaDet,0), NVL(x.SumaIngresada,0),
                                                             NVL(x.DeducibleIngresado,0), NVL(x.CuotaPromedio,0), 
                                                             NVL(x.PrimaPromedio,0));		
             END LOOP;                                                
             GT_COTIZACIONES_DETALLE.ACTUALIZAR_VALORES(I.CodCia, I.CodEmpresa, I.IdCotizacion, I.IDetCotizacion);  
          END LOOP;   
       ELSE
          FOR I IN COT_ASEG_Q LOOP
             FOR x IN Cotizacion_Coberturas LOOP
                GT_COTIZACIONES_COBERTURAS.CARGAR_COBERTURAS(I.CodCia, I.CodEmpresa, cIdTipoSeg,
                                                             cPlanCob, I.IdCotizacion,  
                                                             I.IdetCotizacion, I.IdAsegurado, x.CodCobertWeb,
                                                             NVL(x.SumaAsegCalculada,0), NVL(x.SalarioMensual,0),
                                                             NVL(x.VecesSalario,0), NVL(x.Edad_Minima,0), 
                                                             NVL(x.Edad_Maxima,0), NVL(x.Edad_Exclusion,0),
                                                             NVL(x.SumaAseg_Minima,0), NVL(x.SumaAseg_Maxima,0),
                                                             NVL(x.PorcExtraPrimaDet,0), NVL(x.MontoExtraprimaDet,0), NVL(x.SumaIngresada,0),
                                                             NVL(x.DeducibleIngresado,0), NVL(x.CuotaPromedio,0), 
                                                             NVL(x.PrimaPromedio,0));			
             END LOOP;                                                
             GT_COTIZACIONES_ASEG.ACTUALIZAR_VALORES(I.CodCia, I.CodEmpresa, I.IdCotizacion,  
                                                     I.IDetCotizacion, I.IdAsegurado);
             GT_COTIZACIONES_DETALLE.ACTUALIZAR_VALORES(I.CodCia, I.CodEmpresa, I.IdCotizacion, I.IDetCotizacion);  
          END LOOP;   
       END IF;      
       
       FOR x IN Cotizacion_Coberturas LOOP
          GT_COTIZACIONES_COBERT_MASTER.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, cIdTipoSeg,
                                                          cPlanCob, X.IdCotizacion, 
                                                          X.IdetCotizacion, NULL, X.CodCobertWeb,
                                                          NVL(X.SumaAsegCalculada,0), NVL(X.SalarioMensual,0),
                                                          NVL(X.VecesSalario,0), NVL(X.Edad_Minima,0), 
                                                          NVL(X.Edad_Maxima,0), NVL(X.Edad_Exclusion,0),
                                                          NVL(X.SumaAseg_Minima,0), NVL(X.SumaAseg_Maxima,0),
                                                          NVL(X.PorcExtraPrimaDet,0), NVL(X.MontoExtraprimaDet,0), NVL(X.SumaIngresada,0),
                                                          NVL(X.DeducibleIngresado,0), NVL(X.CuotaPromedio,0), 
                                                          NVL(X.PrimaPromedio,0));     
       END LOOP;      
                                                             
       GENERALES_PLATAFORMA_DIGITAL.RECALCULAR_COTIZACION(nCodCia, nCodEmpresa, nIdCotizacion, cIdTipoSeg, cPlanCob, 'N', 'N', 'S');
                                      
       BEGIN
          SELECT PrimaCotLocal, PrimaCotMoneda--, GastosExpedicion
            INTO nPrimaCotLocal, nPrimaCotMoneda--, nGastosExpedicion
            FROM COTIZACIONES
           WHERE CodCia        = nCodCia
             AND CodEmpresa    = nCodEmpresa
             AND IdCotizacion  = nIdCotizacion;
       END;
       
       BEGIN
          SELECT DECODE(NVL(C.GastosExpedicion,0),0,NVL(CC.MontoConcepto,0),NVL(C.GastosExpedicion,0))
            INTO nGastosExpedicion
            FROM COTIZACIONES C,
                 PLAN_DE_PAGOS P,
                 CONCEPTOS_PLAN_DE_PAGOS CP,
                 CATALOGO_CONCEPTOS_RANGOS CC  
           WHERE C.CodCia               = nCodCia
             AND C.CodEmpresa           = nCodEmpresa
             AND C.IdCotizacion         = nIdCotizacion 
             AND C.CodCia               = P.CodCia
             AND C.CodEmpresa           = P.CodEmpresa
             AND C.CodPlanPago          = P.CodPlanPago
             AND P.CodCia               = CP.CodCia
             AND P.CodEmpresa           = CP.CodEmpresa
             AND P.CodPlanPago          = CP.CodPlanPago
             AND CP.CodCpto             = 'DEREMI'
             AND CP.CodCia              = CC.CodCia
             AND CP.CodEmpresa          = CC.CodEmpresa 
             AND CP.CodCpto             = CC.CodConcepto
             AND C.IdTipoSeg            = CC.IdTipoSeg
             AND C.Cod_Moneda           = CC.CodMoneda
             AND C.PrimaCotLocal  BETWEEN CC.RangoInicial(+) AND CC.RangoFinal(+);
       EXCEPTION
          WHEN NO_DATA_FOUND THEN 
             BEGIN
                SELECT NVL(GastosExpedicion,0)
                  INTO nGastosExpedicion
                  FROM COTIZACIONES
                 WHERE CodCia        = nCodCia
                   AND CodEmpresa    = nCodEmpresa
                   AND IdCotizacion  = nIdCotizacion;
             END;
       END;
       
       BEGIN
          SELECT 'S'
            INTO cExiste
            FROM PLAN_DE_PAGOS P, CONCEPTOS_PLAN_DE_PAGOS C, RAMOS_CONCEPTOS_PLAN R
           WHERE C.CodCia         = nCodCia
             AND C.CodEmpresa     = nCodEmpresa
             AND C.CodPlanPago    = cCodPlanPago
             AND C.CodCpto        = 'IVASIN'
             AND R.IdTipoSeg      = cIdTipoSeg
             AND P.CodCia         = C.CodCia
             AND P.CodEmpresa     = C.CodEmpresa
             AND P.CodPlanPago    = C.CodPlanPago
             AND C.CodCia         = R.CodCia
             AND C.CodEmpresa     = R.CodEmpresa
             AND C.CodPlanPago    = R.CodPlanPago
             AND C.CodCpto        = R.CodCpto;
       EXCEPTION 
          WHEN NO_DATA_FOUND THEN 
             cExiste := 'N';
          WHEN TOO_MANY_ROWS THEN
             cExiste := 'S';
       END;
       IF cExiste = 'S' THEN
          nMontoIva   := (nPrimaCotLocal + nGastosExpedicion) * 0.16;
       ELSE
          nMontoIva   := 0;
       END IF;      
       
       SELECT XMLELEMENT("DATA",   
                XMLELEMENT("PRIMALOCAL",nPrimaCotLocal),
                XMLELEMENT("PRIMAMONEDAEXT",nPrimaCotMoneda),
                XMLELEMENT("GASTOSEXPEDICION",nGastosExpedicion),
                XMLELEMENT("MONTOIVA",nMontoIva)
                         )
         INTO xPrima       
         FROM DUAL ;
       --
       
       SELECT XMLROOT (xPrima, VERSION '1.0" encoding="UTF-8')
         INTO xPrima
         FROM DUAL;
       
       xResultado := COBERTURAS_XML( nCodCia, nCodEmpresa, nIdCotizacion, NULL, NULL, NULL );
       --
      --- COMMIT;
       --
       
       RETURN xResultado;
    EXCEPTION
       WHEN OTHERS THEN
          RETURN NULL;
    END ACTUALIZAR;

    PROCEDURE ACTUALIZA_DATOS_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, xGenerales XMLTYPE) IS
    nDeducibleCobMoneda  COTIZACIONES_COBERT_MASTER.DeducibleCobMoneda%TYPE;
    nDeducibleCobLocal   COTIZACIONES_COBERT_MASTER.DeducibleCobLocal%TYPE;
    nIDetCotizacion      COTIZACIONES_COBERT_MASTER.IDetCotizacion%TYPE;
    cCodCobert           COTIZACIONES_COBERT_MASTER.CodCobert%TYPE;
    cCodMoneda           COTIZACIONES.Cod_Moneda%TYPE;
    nTasaCambio          NUMBER;
    CURSOR cGenCobert IS
       WITH
       DET_COT_DATA AS ( SELECT COT.*
                           FROM   XMLTABLE('/DATA'
                                     PASSING xGenerales
                                        COLUMNS 
                                           IDetCotizacion    NUMBER(14)   PATH 'IDetCotizacion',
                                           COBERTURAS        XMLTYPE      PATH 'COBERTURAS') COT
                         ),
       COB_DATA AS ( SELECT IDetCotizacion,
                             COB.*
                        FROM DET_COT_DATA D,
                             XMLTABLE('/COBERTURAS'
                                  PASSING D.COBERTURAS
                                     COLUMNS 
                                        CodCobert            VARCHAR2(20)   PATH 'CodCobert',
                                        DeducibleCobMoneda   NUMBER(28)     PATH 'DeducibleCobMoneda'
                                        ) COB
                         )                     
       SELECT * FROM COB_DATA;     
    BEGIN
       BEGIN
          SELECT Cod_Moneda
            INTO cCodMoneda
            FROM COTIZACIONES 
           WHERE CodCia           = nCodCia
             AND CodEmpresa       = nCodEmpresa
             AND IdCotizacion     = nIdCotizacion;
       END;
       FOR X IN cGenCobert LOOP
          nTasaCambio       := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
          cCodCobert        := X.CodCobert;
          nIDetCotizacion   := X.IDetCotizacion;
          IF X.DeducibleCobMoneda IS NOT NULL THEN
             nDeducibleCobMoneda := X.DeducibleCobMoneda;
             nDeducibleCobLocal  := nDeducibleCobMoneda * nTasaCambio;
          END IF;
       END LOOP;
       
       UPDATE COTIZACIONES_COBERT_MASTER
          SET DeducibleCobMoneda  = NVL(nDeducibleCobMoneda,DeducibleCobMoneda),
              DeducibleCobLocal   = NVL(nDeducibleCobLocal,DeducibleCobLocal),
              DeducibleIngresado  = NVL(DeducibleIngresado,DeducibleCobLocal)
        WHERE CodCia           = nCodCia
          AND CodEmpresa       = nCodEmpresa
          AND IdCotizacion     = nIdCotizacion
          AND IDetCotizacion   = nIDetCotizacion
          AND CodCobert        = cCodCobert;
          
       UPDATE COTIZACIONES_COBERTURAS
          SET DeducibleCobMoneda  = NVL(nDeducibleCobMoneda,DeducibleCobMoneda),
              DeducibleCobLocal   = NVL(nDeducibleCobLocal,DeducibleCobLocal),
              DeducibleIngresado  = NVL(DeducibleIngresado,DeducibleCobLocal)
        WHERE CodCia           = nCodCia
          AND CodEmpresa       = nCodEmpresa
          AND IdCotizacion     = nIdCotizacion
          AND IDetCotizacion   = nIDetCotizacion
          AND CodCobert        = cCodCobert;      
    END ACTUALIZA_DATOS_COBERTURA;
    --
    PROCEDURE AGREGA_REGISTROS(nCODCIA NUMBER, nCODEMPRESA NUMBER, cCODCOTIZADOR VARCHAR2, cIDTIPOSEG VARCHAR2, cPLANCOB VARCHAR2, cCODGPOCOBERTWEB VARCHAR2, nIDCOTIZACION NUMBER, nIDETCOTIZACION NUMBER) AS
    BEGIN
        FOR ENT IN (SELECT CODCIA, CODEMPRESA, CODCOTIZADOR, IDTIPOSEG, PLANCOB, CODGPOCOBERTWEB, CODCOBERTWEB, SUMAASEGCOBLOCAL, SUMAASEGCOBMONEDA, TASA, PRIMACOBLOCAL, PRIMACOBMONEDA, DEDUCIBLECOBLOCAL, DEDUCIBLECOBMONEDA, SALARIOMENSUAL, VECESSALARIO, SUMAASEGCALCULADA, EDAD_MINIMA, EDAD_MAXIMA, EDAD_EXCLUSION, SUMAASEG_MINIMA, SUMAASEG_MAXIMA, PORCEXTRAPRIMADET, MONTOEXTRAPRIMADET, SUMAINGRESADA, ORDENIMPRESION, DEDUCIBLEINGRESADO, CUOTAPROMEDIO, PRIMAPROMEDIO
                      FROM COTIZADOR_COBERT_WEB G
                     WHERE G.CODCIA        = nCODCIA
                       AND G.CODEMPRESA    = nCODEMPRESA
                       AND G.CODCOTIZADOR  = cCODCOTIZADOR
                       AND G.IDTIPOSEG     = cIDTIPOSEG
                       AND G.PLANCOB       = cPLANCOB
                       AND G.CODGPOCOBERTWEB = cCODGPOCOBERTWEB) LOOP

            INSERT INTO COTIZACIONES_COBERT_WEB  (CODCIA, CODEMPRESA, IDCOTIZACION, IDETCOTIZACION, CODGPOCOBERTWEB, CODCOBERTWEB, SUMAASEGCOBLOCAL, SUMAASEGCOBMONEDA, TASA, PRIMACOBLOCAL, PRIMACOBMONEDA, DEDUCIBLECOBLOCAL, DEDUCIBLECOBMONEDA, SALARIOMENSUAL, VECESSALARIO, SUMAASEGCALCULADA, EDAD_MINIMA, EDAD_MAXIMA, EDAD_EXCLUSION, SUMAASEG_MINIMA, SUMAASEG_MAXIMA, PORCEXTRAPRIMADET, MONTOEXTRAPRIMADET, SUMAINGRESADA, ORDENIMPRESION, DEDUCIBLEINGRESADO, CUOTAPROMEDIO, PRIMAPROMEDIO,ACTUALIZO_USUARIO, ACTUALIZO_FECHA) VALUES 
                                                 (ENT.CODCIA, ENT.CODEMPRESA, nIDCOTIZACION, nIDETCOTIZACION, ENT.CODGPOCOBERTWEB, ENT.CODCOBERTWEB, ENT.SUMAASEGCOBLOCAL, ENT.SUMAASEGCOBMONEDA, ENT.TASA, ENT.PRIMACOBLOCAL, ENT.PRIMACOBMONEDA, ENT.DEDUCIBLECOBLOCAL, ENT.DEDUCIBLECOBMONEDA, ENT.SALARIOMENSUAL, ENT.VECESSALARIO, ENT.SUMAASEGCALCULADA, ENT.EDAD_MINIMA, ENT.EDAD_MAXIMA, ENT.EDAD_EXCLUSION, ENT.SUMAASEG_MINIMA, ENT.SUMAASEG_MAXIMA, ENT.PORCEXTRAPRIMADET, ENT.MONTOEXTRAPRIMADET, ENT.SUMAINGRESADA, ENT.ORDENIMPRESION, ENT.DEDUCIBLEINGRESADO, ENT.CUOTAPROMEDIO, ENT.PRIMAPROMEDIO, USER, SYSDATE);
        END LOOP;                  
             
    END AGREGA_REGISTROS;
    --    
END OC_COTIZACIONES_COBERT_WEB;
/

CREATE OR REPLACE PUBLIC SYNONYM OC_COTIZACIONES_COBERT_WEB FOR OC_COTIZACIONES_COBERT_WEB;
/
GRANT EXECUTE ON OC_COTIZACIONES_COBERT_WEB TO PUBLIC;
/

create or replace PACKAGE          OC_COTIZADOR_COBERT_WEB IS
   PROCEDURE INSERTAR( nCodCia              IN  COTIZADOR_COBERT_WEB.CodCia%TYPE
                     , nCodEmpresa          IN  COTIZADOR_COBERT_WEB.CodEmpresa%TYPE
                     , cCodCotizador        IN  COTIZADOR_COBERT_WEB.CodCotizador%TYPE
                     , cIdTipoSeg           IN  COTIZADOR_COBERT_WEB.IdTipoSeg%TYPE
                     , cPlanCob             IN  COTIZADOR_COBERT_WEB.PlanCob%TYPE
                     , nCodGpoCobertWeb     IN  COTIZADOR_COBERT_WEB.CodGpoCobertWeb%TYPE
                     , cCodCobertWeb        IN  COTIZADOR_COBERT_WEB.CodCobertWeb%TYPE
                     , nIdCotizacion        IN  COTIZADOR_COBERT_WEB.IdCotizacion%TYPE
                     , nIdetCotizacion      IN  COTIZADOR_COBERT_WEB.IdetCotizacion%TYPE
                     , nSumaAsegCobLocal    IN  COTIZADOR_COBERT_WEB.SumaAsegCobLocal%TYPE
                     , nSumaAsegCobMoneda   IN  COTIZADOR_COBERT_WEB.SumaAsegCobMoneda%TYPE
                     , nTasa                IN  COTIZADOR_COBERT_WEB.Tasa%TYPE
                     , nPrimaCobLocal       IN  COTIZADOR_COBERT_WEB.PrimaCobLocal%TYPE
                     , nPrimaCobMoneda      IN  COTIZADOR_COBERT_WEB.PrimaCobMoneda%TYPE
                     , nDeducibleCobLocal   IN  COTIZADOR_COBERT_WEB.DeducibleCobLocal%TYPE
                     , nDeducibleCobMoneda  IN  COTIZADOR_COBERT_WEB.DeducibleCobMoneda%TYPE
                     , nSalarioMensual      IN  COTIZADOR_COBERT_WEB.SalarioMensual%TYPE
                     , nVecesSalario        IN  COTIZADOR_COBERT_WEB.VecesSalario%TYPE
                     , nSumaAsegCalculada   IN  COTIZADOR_COBERT_WEB.SumaAsegCalculada%TYPE
                     , nEdad_Minima         IN  COTIZADOR_COBERT_WEB.Edad_Minima%TYPE
                     , nEdad_Maxima         IN  COTIZADOR_COBERT_WEB.Edad_Maxima%TYPE
                     , nEdad_Exclusion      IN  COTIZADOR_COBERT_WEB.Edad_Exclusion%TYPE
                     , nSumaAseg_Minima     IN  COTIZADOR_COBERT_WEB.SumaAseg_Minima%TYPE
                     , nSumaAseg_Maxima     IN  COTIZADOR_COBERT_WEB.SumaAseg_Maxima%TYPE
                     , nPorcExtraPrimaDet   IN  COTIZADOR_COBERT_WEB.PorcExtraPrimaDet%TYPE
                     , nMontoExtraPrimaDet  IN  COTIZADOR_COBERT_WEB.MontoExtraPrimaDet%TYPE
                     , nSumaIngresada       IN  COTIZADOR_COBERT_WEB.SumaIngresada%TYPE
                     , nOrdenImpresion      IN  COTIZADOR_COBERT_WEB.OrdenImpresion%TYPE
                     , nDeducibleIngresado  IN  COTIZADOR_COBERT_WEB.DeducibleIngresado%TYPE
                     , nCuotaPromedio       IN  COTIZADOR_COBERT_WEB.CuotaPromedio%TYPE
                     , nPrimaPromedio       IN  COTIZADOR_COBERT_WEB.PrimaPromedio%TYPE );

   PROCEDURE ELIMINAR( nCodCia           IN  COTIZADOR_COBERT_WEB.CodCia%TYPE
                     , nCodEmpresa       IN  COTIZADOR_COBERT_WEB.CodEmpresa%TYPE
                     , cCodCotizador     IN  COTIZADOR_COBERT_WEB.CodCotizador%TYPE
                     , cIdTipoSeg        IN  COTIZADOR_COBERT_WEB.IdTipoSeg%TYPE
                     , cPlanCob          IN  COTIZADOR_COBERT_WEB.PlanCob%TYPE
                     , nCodGpoCobertWeb  IN  COTIZADOR_COBERT_WEB.CodGpoCobertWeb%TYPE
                     , cCodCobertWeb     IN  COTIZADOR_COBERT_WEB.CodCobertWeb%TYPE
                     , nIdCotizacion     IN  COTIZADOR_COBERT_WEB.IdCotizacion%TYPE
                     , nIdetCotizacion   IN  COTIZADOR_COBERT_WEB.IdetCotizacion%TYPE );

   FUNCTION SERVICIO_XML( nCodCia           IN  COTIZADOR_COBERT_WEB.CodCia%TYPE
                        , nCodEmpresa       IN  COTIZADOR_COBERT_WEB.CodEmpresa%TYPE
                        , cCodCotizador     IN  COTIZADOR_COBERT_WEB.CodCotizador%TYPE
                        , cIdTipoSeg        IN  COTIZADOR_COBERT_WEB.IdTipoSeg%TYPE
                        , cPlanCob          IN  COTIZADOR_COBERT_WEB.PlanCob%TYPE
                        , nCodGpoCobertWeb  IN  COTIZADOR_COBERT_WEB.CodGpoCobertWeb%TYPE
                        , cCodCobertWeb     IN  COTIZADOR_COBERT_WEB.CodCobertWeb%TYPE
                        , nIdCotizacion     IN  COTIZADOR_COBERT_WEB.IdCotizacion%TYPE
                        , nIdetCotizacion   IN  COTIZADOR_COBERT_WEB.IdetCotizacion%TYPE ) RETURN XMLTYPE;

END OC_COTIZADOR_COBERT_WEB;
/
create or replace PACKAGE BODY          OC_COTIZADOR_COBERT_WEB IS
   PROCEDURE INSERTAR( nCodCia              IN  COTIZADOR_COBERT_WEB.CodCia%TYPE
                     , nCodEmpresa          IN  COTIZADOR_COBERT_WEB.CodEmpresa%TYPE
                     , cCodCotizador        IN  COTIZADOR_COBERT_WEB.CodCotizador%TYPE
                     , cIdTipoSeg           IN  COTIZADOR_COBERT_WEB.IdTipoSeg%TYPE
                     , cPlanCob             IN  COTIZADOR_COBERT_WEB.PlanCob%TYPE
                     , nCodGpoCobertWeb     IN  COTIZADOR_COBERT_WEB.CodGpoCobertWeb%TYPE
                     , cCodCobertWeb        IN  COTIZADOR_COBERT_WEB.CodCobertWeb%TYPE
                     , nIdCotizacion        IN  COTIZADOR_COBERT_WEB.IdCotizacion%TYPE
                     , nIdetCotizacion      IN  COTIZADOR_COBERT_WEB.IdetCotizacion%TYPE
                     , nSumaAsegCobLocal    IN  COTIZADOR_COBERT_WEB.SumaAsegCobLocal%TYPE
                     , nSumaAsegCobMoneda   IN  COTIZADOR_COBERT_WEB.SumaAsegCobMoneda%TYPE
                     , nTasa                IN  COTIZADOR_COBERT_WEB.Tasa%TYPE
                     , nPrimaCobLocal       IN  COTIZADOR_COBERT_WEB.PrimaCobLocal%TYPE
                     , nPrimaCobMoneda      IN  COTIZADOR_COBERT_WEB.PrimaCobMoneda%TYPE
                     , nDeducibleCobLocal   IN  COTIZADOR_COBERT_WEB.DeducibleCobLocal%TYPE
                     , nDeducibleCobMoneda  IN  COTIZADOR_COBERT_WEB.DeducibleCobMoneda%TYPE
                     , nSalarioMensual      IN  COTIZADOR_COBERT_WEB.SalarioMensual%TYPE
                     , nVecesSalario        IN  COTIZADOR_COBERT_WEB.VecesSalario%TYPE
                     , nSumaAsegCalculada   IN  COTIZADOR_COBERT_WEB.SumaAsegCalculada%TYPE
                     , nEdad_Minima         IN  COTIZADOR_COBERT_WEB.Edad_Minima%TYPE
                     , nEdad_Maxima         IN  COTIZADOR_COBERT_WEB.Edad_Maxima%TYPE
                     , nEdad_Exclusion      IN  COTIZADOR_COBERT_WEB.Edad_Exclusion%TYPE
                     , nSumaAseg_Minima     IN  COTIZADOR_COBERT_WEB.SumaAseg_Minima%TYPE
                     , nSumaAseg_Maxima     IN  COTIZADOR_COBERT_WEB.SumaAseg_Maxima%TYPE
                     , nPorcExtraPrimaDet   IN  COTIZADOR_COBERT_WEB.PorcExtraPrimaDet%TYPE
                     , nMontoExtraPrimaDet  IN  COTIZADOR_COBERT_WEB.MontoExtraPrimaDet%TYPE
                     , nSumaIngresada       IN  COTIZADOR_COBERT_WEB.SumaIngresada%TYPE
                     , nOrdenImpresion      IN  COTIZADOR_COBERT_WEB.OrdenImpresion%TYPE
                     , nDeducibleIngresado  IN  COTIZADOR_COBERT_WEB.DeducibleIngresado%TYPE
                     , nCuotaPromedio       IN  COTIZADOR_COBERT_WEB.CuotaPromedio%TYPE
                     , nPrimaPromedio       IN  COTIZADOR_COBERT_WEB.PrimaPromedio%TYPE ) IS
   BEGIN
       INSERT INTO COTIZADOR_COBERT_WEB
          ( CodCia, CodEmpresa, CodCotizador, IdTipoSeg, PlanCob, CodGpoCobertWeb, CodCobertWeb, IdCotizacion, IdetCotizacion,
            SumaAsegCobLocal, SumaAsegCobMoneda, Tasa, PrimaCobLocal, PrimaCobMoneda, DeducibleCobLocal,
            DeducibleCobMoneda, SalarioMensual, VecesSalario, SumaAsegCalculada, Edad_Minima, Edad_Maxima, Edad_Exclusion,
            SumaAseg_Minima, SumaAseg_Maxima, PorcExtraPrimaDet, MontoExtraPrimaDet, SumaIngresada, OrdenImpresion,
            DeducibleIngresado,CuotaPromedio, PrimaPromedio )
       VALUES ( nCodCia, nCodEmpresa, cCodCotizador, cIdTipoSeg, cPlanCob, nCodGpoCobertWeb, cCodCobertWeb, nIdCotizacion, nIdetCotizacion,
                nSumaAsegCobLocal, nSumaAsegCobMoneda, nTasa, nPrimaCobLocal, nPrimaCobMoneda, nDeducibleCobLocal,
                nDeducibleCobMoneda, nSalarioMensual, nVecesSalario, nSumaAsegCalculada, nEdad_Minima, nEdad_Maxima, nEdad_Exclusion,
                nSumaAseg_Minima, nSumaAseg_Maxima, nPorcExtraPrimaDet, nMontoExtraPrimaDet, nSumaIngresada, nOrdenImpresion,
                nDeducibleIngresado, nCuotaPromedio, nPrimaPromedio );
   END INSERTAR;

   PROCEDURE ELIMINAR( nCodCia           IN  COTIZADOR_COBERT_WEB.CodCia%TYPE
                     , nCodEmpresa       IN  COTIZADOR_COBERT_WEB.CodEmpresa%TYPE
                     , cCodCotizador     IN  COTIZADOR_COBERT_WEB.CodCotizador%TYPE
                     , cIdTipoSeg        IN  COTIZADOR_COBERT_WEB.IdTipoSeg%TYPE
                     , cPlanCob          IN  COTIZADOR_COBERT_WEB.PlanCob%TYPE
                     , nCodGpoCobertWeb  IN  COTIZADOR_COBERT_WEB.CodGpoCobertWeb%TYPE
                     , cCodCobertWeb     IN  COTIZADOR_COBERT_WEB.CodCobertWeb%TYPE
                     , nIdCotizacion     IN  COTIZADOR_COBERT_WEB.IdCotizacion%TYPE
                     , nIdetCotizacion   IN  COTIZADOR_COBERT_WEB.IdetCotizacion%TYPE ) IS
   BEGIN
       DELETE COTIZADOR_COBERT_WEB
       WHERE  CodCia          = nCodCia
         AND  CodEmpresa      = nCodEmpresa
         AND  CodCotizador    = cCodCotizador
         AND  IdTipoSeg       = cIdTipoSeg
         AND  PlanCob         = cPlanCob
         AND  CodGpoCobertWeb = nCodGpoCobertWeb
         AND  CodCobertWeb    = cCodCobertWeb
         AND  IdCotizacion    = nIdCotizacion
         AND  IdetCotizacion  = nIdetCotizacion;
   END ELIMINAR;

   FUNCTION SERVICIO_XML( nCodCia           IN  COTIZADOR_COBERT_WEB.CodCia%TYPE
                        , nCodEmpresa       IN  COTIZADOR_COBERT_WEB.CodEmpresa%TYPE
                        , cCodCotizador     IN  COTIZADOR_COBERT_WEB.CodCotizador%TYPE
                        , cIdTipoSeg        IN  COTIZADOR_COBERT_WEB.IdTipoSeg%TYPE
                        , cPlanCob          IN  COTIZADOR_COBERT_WEB.PlanCob%TYPE
                        , nCodGpoCobertWeb  IN  COTIZADOR_COBERT_WEB.CodGpoCobertWeb%TYPE
                        , cCodCobertWeb     IN  COTIZADOR_COBERT_WEB.CodCobertWeb%TYPE
                        , nIdCotizacion     IN  COTIZADOR_COBERT_WEB.IdCotizacion%TYPE
                        , nIdetCotizacion   IN  COTIZADOR_COBERT_WEB.IdetCotizacion%TYPE ) RETURN XMLTYPE IS
      xResultado  XMLTYPE;   
   BEGIN
      SELECT XMLROOT (x.Resultado, VERSION '1.0" encoding="UTF-8')
      INTO   xResultado
      FROM ( SELECT XMLElement( "DATA",
                                XMLAGG(
                                        XMLCONCAT(
                                                   XMLElement( "COTIZADOR_COBERT_WEB", 
                                                               XMLElement("CodCia", CodCia),
                                                               XMLElement("CodEmpresa",CodEmpresa),
                                                               XMLElement("CodCotizador", CodCotizador),
                                                               XMLElement("IdTipoSeg", IdTipoSeg),
                                                               XMLElement("PlanCob", PlanCob),
                                                               XMLElement("CodGpoCobertWeb", CodGpoCobertWeb),
                                                               XMLElement("CodCobertWeb", CodCobertWeb),
                                                               XMLElement("IdCotizacion", IdCotizacion),
                                                               XMLElement("IdetCotizacion", IdetCotizacion),
                                                               XMLElement("SumaAsegCobLocal", SumaAsegCobLocal),
                                                               XMLElement("SumaAsegCobMoneda", SumaAsegCobMoneda),
                                                               XMLElement("Tasa", Tasa),
                                                               XMLElement("PrimaCobLocal", PrimaCobLocal),
                                                               XMLElement("PrimaCobMoneda", PrimaCobMoneda),
                                                               XMLElement("DeducibleCobLocal", DeducibleCobLocal),
                                                               XMLElement("DeducibleCobMoneda", DeducibleCobMoneda),
                                                               XMLElement("SalarioMensual", SalarioMensual),
                                                               XMLElement("VecesSalario", VecesSalario),
                                                               XMLElement("SumaAsegCalculada", SumaAsegCalculada),
                                                               XMLElement("Edad_Minima", Edad_Minima),
                                                               XMLElement("Edad_Maxima", Edad_Maxima),
                                                               XMLElement("Edad_Exclusion", Edad_Exclusion),
                                                               XMLElement("SumaAseg_Minima", SumaAseg_Minima),
                                                               XMLElement("SumaAseg_Maxima", SumaAseg_Maxima),
                                                               XMLElement("PorcExtraPrimaDet", PorcExtraPrimaDet),
                                                               XMLElement("MontoExtraPrimaDet", MontoExtraPrimaDet),
                                                               XMLElement("SumaIngresada", SumaIngresada),
                                                               XMLElement("OrdenImpresion", OrdenImpresion),
                                                               XMLElement("DeducibleIngresado", DeducibleIngresado),
                                                               XMLElement("CuotaPromedio", CuotaPromedio),
                                                               XMLElement("PrimaPromedio", PrimaPromedio)
                                                             )
                                                 )
                                      ) 
                              ) Resultado
             FROM   COTIZADOR_COBERT_WEB
             WHERE  CodCia          = NVL( nCodCia         , CodCia)
               AND  CodEmpresa      = NVL( nCodEmpresa     , CodEmpresa)
               AND  CodCotizador    = NVL( cCodCotizador   , CodCotizador)
               AND  IdTipoSeg       = NVL( cIdTipoSeg      , IdTipoSeg)
               AND  PlanCob         = NVL( cPlanCob        , PlanCob)
               AND  CodGpoCobertWeb = NVL( nCodGpoCobertWeb, CodGpoCobertWeb)
               AND  CodCobertWeb    = NVL( CodCobertWeb    , CodCobertWeb)
               AND  IdCotizacion    = NVL( IdCotizacion    , IdCotizacion)
               AND  IdetCotizacion  = NVL( IdetCotizacion  , IdetCotizacion)
           ) X;
      RETURN xResultado;
   EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
   END SERVICIO_XML;

END OC_COTIZADOR_COBERT_WEB;
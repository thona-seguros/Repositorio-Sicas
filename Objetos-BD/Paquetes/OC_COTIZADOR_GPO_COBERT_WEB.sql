create or replace PACKAGE          OC_COTIZADOR_GPO_COBERT_WEB IS
   PROCEDURE INSERTAR( nCodCia            IN  COTIZADOR_GPO_COBERT_WEB.CodCia%TYPE
                     , nCodEmpresa        IN  COTIZADOR_GPO_COBERT_WEB.CodEmpresa%TYPE
                     , cCodCotizador      IN  COTIZADOR_GPO_COBERT_WEB.CodCotizador%TYPE
                     , cIdTipoSeg         IN  COTIZADOR_GPO_COBERT_WEB.IdTipoSeg%TYPE
                     , cPlanCob           IN  COTIZADOR_GPO_COBERT_WEB.PlanCob%TYPE
                     , nCodGpoCobertWeb   IN  COTIZADOR_GPO_COBERT_WEB.CodGpoCobertWeb%TYPE );

   PROCEDURE ELIMINAR( nCodCia            IN  COTIZADOR_GPO_COBERT_WEB.CodCia%TYPE
                     , nCodEmpresa        IN  COTIZADOR_GPO_COBERT_WEB.CodEmpresa%TYPE
                     , cCodCotizador      IN  COTIZADOR_GPO_COBERT_WEB.CodCotizador%TYPE
                     , cIdTipoSeg         IN  COTIZADOR_GPO_COBERT_WEB.IdTipoSeg%TYPE
                     , cPlanCob           IN  COTIZADOR_GPO_COBERT_WEB.PlanCob%TYPE
                     , nCodGpoCobertWeb   IN  COTIZADOR_GPO_COBERT_WEB.CodGpoCobertWeb%TYPE );

   FUNCTION SERVICIO_XML( nCodCia          IN COTIZADOR_GPO_COBERT_WEB.CodCia%TYPE
                        , nCodEmpresa      IN COTIZADOR_GPO_COBERT_WEB.CodEmpresa%TYPE
                        , cCodCotizador    IN COTIZADOR_GPO_COBERT_WEB.CodCotizador%TYPE
                        , cIdTipoSeg       IN COTIZADOR_GPO_COBERT_WEB.IdTipoSeg%TYPE
                        , cPlanCob         IN COTIZADOR_GPO_COBERT_WEB.PlanCob%TYPE
                        , nCodGpoCobertWeb IN COTIZADOR_GPO_COBERT_WEB.CodGpoCobertWeb%TYPE ) RETURN XMLTYPE;

END OC_COTIZADOR_GPO_COBERT_WEB;
/
create or replace PACKAGE BODY          OC_COTIZADOR_GPO_COBERT_WEB IS
   PROCEDURE INSERTAR( nCodCia            IN  COTIZADOR_GPO_COBERT_WEB.CodCia%TYPE
                     , nCodEmpresa        IN  COTIZADOR_GPO_COBERT_WEB.CodEmpresa%TYPE
                     , cCodCotizador      IN  COTIZADOR_GPO_COBERT_WEB.CodCotizador%TYPE
                     , cIdTipoSeg         IN  COTIZADOR_GPO_COBERT_WEB.IdTipoSeg%TYPE
                     , cPlanCob           IN  COTIZADOR_GPO_COBERT_WEB.PlanCob%TYPE
                     , nCodGpoCobertWeb   IN  COTIZADOR_GPO_COBERT_WEB.CodGpoCobertWeb%TYPE ) IS
   BEGIN
       INSERT INTO COTIZADOR_GPO_COBERT_WEB
          ( CodCia, CodEmpresa, CodCotizador, IdTipoSeg, PlanCob, CodGpoCobertWeb )
       VALUES ( nCodCia, nCodEmpresa, cCodCotizador, cIdTipoSeg, cPlanCob, nCodGpoCobertWeb );
   END INSERTAR;

   PROCEDURE ELIMINAR( nCodCia            IN  COTIZADOR_GPO_COBERT_WEB.CodCia%TYPE
                     , nCodEmpresa        IN  COTIZADOR_GPO_COBERT_WEB.CodEmpresa%TYPE
                     , cCodCotizador      IN  COTIZADOR_GPO_COBERT_WEB.CodCotizador%TYPE
                     , cIdTipoSeg         IN  COTIZADOR_GPO_COBERT_WEB.IdTipoSeg%TYPE
                     , cPlanCob           IN  COTIZADOR_GPO_COBERT_WEB.PlanCob%TYPE
                     , nCodGpoCobertWeb   IN  COTIZADOR_GPO_COBERT_WEB.CodGpoCobertWeb%TYPE ) IS
   BEGIN
       DELETE COTIZADOR_GPO_COBERT_WEB
       WHERE  CodCia          = nCodCia
         AND  CodEmpresa      = nCodEmpresa
         AND  CodCotizador    = cCodCotizador
         AND  IdTipoSeg       = cIdTipoSeg
         AND  PlanCob         = cPlanCob
         AND  CodGpoCobertWeb = nCodGpoCobertWeb;
   END ELIMINAR;

   FUNCTION SERVICIO_XML( nCodCia          IN COTIZADOR_GPO_COBERT_WEB.CodCia%TYPE
                        , nCodEmpresa      IN COTIZADOR_GPO_COBERT_WEB.CodEmpresa%TYPE
                        , cCodCotizador    IN COTIZADOR_GPO_COBERT_WEB.CodCotizador%TYPE
                        , cIdTipoSeg       IN COTIZADOR_GPO_COBERT_WEB.IdTipoSeg%TYPE
                        , cPlanCob         IN COTIZADOR_GPO_COBERT_WEB.PlanCob%TYPE
                        , nCodGpoCobertWeb IN COTIZADOR_GPO_COBERT_WEB.CodGpoCobertWeb%TYPE ) RETURN XMLTYPE IS
      xResultado  XMLTYPE;   
   BEGIN
      SELECT XMLROOT (x.Resultado, VERSION '1.0" encoding="UTF-8')
      INTO   xResultado
      FROM ( SELECT XMLElement( "DATA",
                                XMLAGG(
                                        XMLCONCAT(
                                                   XMLElement( "Cotizador_Gpo_Cobert_Web", 
                                                               XMLElement("CodCia", CodCia),
                                                               XMLElement("CodEmpresa",CodEmpresa),
                                                               XMLElement("CodCotizador", CodCotizador),
                                                               XMLElement("IdTipoSeg", IdTipoSeg),
                                                               XMLElement("PlanCob", PlanCob),
                                                               XMLElement("CodGpoCobertWeb", CodGpoCobertWeb)
--                                                               XMLElement("DescGpoCobertWeb", DescGpoCobertWeb)
                                                             )
                                                 )
                                      ) 
                              ) Resultado
             FROM   COTIZADOR_GPO_COBERT_WEB
             WHERE  CodCia          = NVL( nCodCia         , CodCia)
               AND  CodEmpresa      = NVL( nCodEmpresa     , CodEmpresa)
               AND  CodCotizador    = NVL( cCodCotizador   , CodCotizador)
               AND  IdTipoSeg       = NVL( cIdTipoSeg      , IdTipoSeg)
               AND  PlanCob         = NVL( cPlanCob        , PlanCob)
               AND  CodGpoCobertWeb = NVL( nCodGpoCobertWeb, CodGpoCobertWeb)
           ) X;
      RETURN xResultado;
   EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
   END SERVICIO_XML;

END OC_COTIZADOR_GPO_COBERT_WEB;
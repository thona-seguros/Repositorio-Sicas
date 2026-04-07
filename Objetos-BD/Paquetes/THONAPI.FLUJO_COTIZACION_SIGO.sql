CREATE OR REPLACE PACKAGE THONAPI.FLUJO_COTIZACION_SIGO IS
   PROCEDURE ACTUALIZAR_AGENTE( nCodCia        COTIZACIONES.CodCia%TYPE
                              , nCodEmpresa    COTIZACIONES.CodEmpresa%TYPE
                              , nIdCotizacion  COTIZACIONES.IdCotizacion%TYPE
                              , nCodAgente     COTIZACIONES.CodAgente%TYPE );
   --
   FUNCTION INSERTAR_DETALLE( nCodCia              COTIZACIONES.CodCia%TYPE
                            , nCodEmpresa          COTIZACIONES.CodEmpresa%TYPE
                            , nIdCotizacion        COTIZACIONES.IdCotizacion%TYPE
                            , cCodSubgrupo         COTIZACIONES_DETALLE.CodSubgrupo%TYPE
                            , cDescSubgrupo        COTIZACIONES_DETALLE.DescSubgrupo%TYPE
                            , nEdadLimite          COTIZACIONES_DETALLE.EdadLimite%TYPE
                            , nCantAsegurados      COTIZACIONES_DETALLE.CantAsegurados%TYPE
                            , nSalarioMensual      COTIZACIONES_DETALLE.SalarioMensual%TYPE
                            , nVecesSalario        COTIZACIONES_DETALLE.VecesSalario%TYPE
                            , nPorcExtraPrimaDet   COTIZACIONES_DETALLE.PorcExtraPrimaDet%TYPE
                            , nMontoExtraPrimaDet  COTIZACIONES_DETALLE.MontoExtraPrimaDet%TYPE
                            , nPrimaAsegurado      COTIZACIONES_DETALLE.PrimaAsegurado%TYPE
                            , nSumaAsegDetLocal    COTIZACIONES_DETALLE.SumaAsegDetLocal%TYPE
                            , nSumaAsegDetMoneda   COTIZACIONES_DETALLE.SumaAsegDetMoneda%TYPE
                            , nPrimaDetLocal       COTIZACIONES_DETALLE.PrimaDetLocal%TYPE
                            , nPrimaDetMoneda      COTIZACIONES_DETALLE.PrimaDetMoneda%TYPE
                            , cRiesgoTarifa        COTIZACIONES_DETALLE.RiesgoTarifa%TYPE
                            , nHorasVig            COTIZACIONES_DETALLE.HorasVig%TYPE
                            , nDiasVig             COTIZACIONES_DETALLE.DiasVig%TYPE
                            , nFactorAjuste        COTIZACIONES_DETALLE.FactorAjuste%TYPE
                            , nFactFormulaDeduc    COTIZACIONES_DETALLE.FactFormulaDeduc%TYPE
                            , cIndEdadPromedio     COTIZACIONES_DETALLE.IndEdadPromedio%TYPE
                            , cIndCuotaPromedio    COTIZACIONES_DETALLE.IndCuotaPromedio%TYPE
                            , cIndPrimaPromedio    COTIZACIONES_DETALLE.IndPrimaPromedio%TYPE
                            , cPrimaNetaPor        COTIZACIONES_DETALLE.PrimaNetaPor%TYPE ) RETURN NUMBER;
   --
   FUNCTION RECIBIR_GENERALES( nCodCia          COTIZACIONES_DETALLE.CodCia%TYPE
                             , nCodEmpresa      COTIZACIONES_DETALLE.CodEmpresa%TYPE
                             , nIdCotizacion    COTIZACIONES_DETALLE.IdCotizacion%TYPE
                             , nIDetCotizacion  COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                             , nHorasVig        COTIZACIONES_DETALLE.HorasVig%TYPE
                             , nDiasVig         COTIZACIONES_DETALLE.DiasVig%TYPE
                             , nCantAsegurados  COTIZACIONES_DETALLE.CantAsegurados%TYPE
                             , nFactorAjuste    COTIZACIONES.FactorAjuste%TYPE
                             , cRiesgoTarifa    COTIZACIONES_DETALLE.RiesgoTarifa%TYPE
                             , cTiponegocio     COTIZACIONES.Tipnego_Web%TYPE
                             , cLaboral         COTIZACIONES.Ries_Labor%TYPE
                             , cRies24_365      COTIZACIONES.Ries_24365%TYPE
                             , cTraslados       COTIZACIONES.Ries_Trasla%TYPE
                             , nPorcDescuento   COTIZACIONES.PorcDescuento%TYPE
                             , nPorcGtoAdmin    COTIZACIONES.PorcGtoAdmin%TYPE ) RETURN VARCHAR2;
   --
   FUNCTION ACTUALIZAR_INFORMACION( nCodCia                COTIZACIONES.CodCia%TYPE
                                  , nCodEmpresa            COTIZACIONES.CodEmpresa%TYPE
                                  , nIdCotizacion          COTIZACIONES.IdCotizacion%TYPE
                                  , cCodTipoBono           COTIZACIONES.CodTipoBono%TYPE
                                  , cCodRiesgoREA          COTIZACIONES.CodRiesgoREA%TYPE
                                  , nFactorAjuste          COTIZACIONES.FactorAjuste%TYPE
                                  , cCodTipoNegocio        COTIZACIONES.CodTipoNegocio%TYPE
                                  , cDescElegibilidad      COTIZACIONES.DescElegibilidad%TYPE
                                  , cDescRiesgosCubiertos  COTIZACIONES.DescRiesgosCubiertos%TYPE
                                  , cCodPlanPago           COTIZACIONES.CodPlanPago%TYPE
                                  , nGastosExpedicion      COTIZACIONES.GastosExpedicion%TYPE
                                  , nPorcConvenciones      COTIZACIONES.PorcConvenciones%TYPE
                                  , cTipoAdministracion    COTIZACIONES.TipoAdministracion%TYPE
                                  , nPorcGtoAdmin          COTIZACIONES.PorcGtoAdmin%TYPE
                                  , nPorcUtilidad          COTIZACIONES.PorcUtilidad%TYPE
                                  , nHorasVig              COTIZACIONES.HorasVig%TYPE
                                  , nDiasVig               COTIZACIONES.DiasVig%TYPE ) RETURN VARCHAR2;
   --
   FUNCTION CONSULTAR_CLAUSULAS( nCodCia        COTIZACIONES_CLAUSULAS.CodCia%TYPE
                               , nCodEmpresa    COTIZACIONES_CLAUSULAS.CodEmpresa%TYPE
                               , nIdCotizacion  COTIZACIONES_CLAUSULAS.IdCotizacion%TYPE ) RETURN CLOB;
   --
   FUNCTION INSERTAR_CLAUSULAS( nCodCia         COTIZACIONES_CLAUSULAS.CodCia%TYPE
                              , nCodEmpresa     COTIZACIONES_CLAUSULAS.CodEmpresa%TYPE
                              , nIdCotizacion   COTIZACIONES_CLAUSULAS.IdCotizacion%TYPE
                              , cCodClausula    COTIZACIONES_CLAUSULAS.CodClausula%TYPE
                              , cTextoClausula  COTIZACIONES_CLAUSULAS.TextoClausula%TYPE ) RETURN VARCHAR2;
   --
   FUNCTION REGISTRAR_FACTOR_GUA( nCodCia          COTIZACIONES_DETALLE.CodCia%TYPE
                                , nCodEmpresa      COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                , nIdCotizacion    COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                , nIDetCotizacion  COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                                , cCodSubGrupo     COTIZACIONES_DETALLE.CodSubGrupo%TYPE
                                , cCodCobert       VARCHAR2
                                , cNivel           COTIZACIONES_DETALLE_FACTOR.CodFactor%TYPE
                                , nFactor          COTIZACIONES_DETALLE_FACTOR.Factor%TYPE
                                , cCodClausula     COTIZACIONES_CLAUSULAS.CodClausula%TYPE
                                , cTextoClausula   CLOB ) RETURN VARCHAR2;
   --
   FUNCTION REGISTRAR_FACTOR_PADESPE( nCodCia          COTIZACIONES_DETALLE.CodCia%TYPE
                                    , nCodEmpresa      COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                    , nIdCotizacion    COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                    , nIDetCotizacion  COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                                    , cCodSubGrupo     COTIZACIONES_DETALLE.CodSubGrupo%TYPE
                                    , cCodCobert       VARCHAR2
                                    , cIndIncluido     VARCHAR2
                                    , nFactor          COTIZACIONES_DETALLE_FACTOR.Factor%TYPE
                                    , cCodEndoso       COTIZACIONES_DETALLE_FACTOR.CodFactor%TYPE
                                    , cTextoClausula   CLOB ) RETURN VARCHAR2;
   --
   FUNCTION REGISTRAR_FACTOR_NIVHOSP( nCodCia          COTIZACIONES_DETALLE.CodCia%TYPE
                                    , nCodEmpresa      COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                    , nIdCotizacion    COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                    , nIDetCotizacion  COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                                    , cCodSubGrupo     COTIZACIONES_DETALLE.CodSubGrupo%TYPE
                                    , cCodCobert       VARCHAR2
                                    , cIndIncluido     VARCHAR2
                                    , nFactor          COTIZACIONES_DETALLE_FACTOR.Factor%TYPE
                                    , cCodEndoso       COTIZACIONES_DETALLE_FACTOR.CodFactor%TYPE
                                    , cTextoClausula   CLOB ) RETURN VARCHAR2;
   --
   FUNCTION REGISTRAR_FACTOR_EQUIREP( nCodCia          COTIZACIONES_DETALLE.CodCia%TYPE
                                    , nCodEmpresa      COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                    , nIdCotizacion    COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                    , nIDetCotizacion  COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                                    , cCodSubGrupo     COTIZACIONES_DETALLE.CodSubGrupo%TYPE
                                    , cCodPaquete      FACTOR_EQUIPOS_REPRESENTA.CodPaquete%TYPE
                                    , cIndIncluido     VARCHAR2
                                    , nFactor          FACTOR_EQUIPOS_REPRESENTA.Factor%TYPE
                                    , cCodEquipo       FACTOR_EQUIPOS_REPRESENTA.CodEquipo%TYPE
                                    , cTextoClausula   CLOB ) RETURN VARCHAR2;
   --
   FUNCTION REGISTRAR_FACTOR_REGION( nCodCia          COTIZACIONES_DETALLE.CodCia%TYPE
                                   , nCodEmpresa      COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                   , nIdCotizacion    COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                   , nIDetCotizacion  COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                                   , cCodSubGrupo     COTIZACIONES_DETALLE.CodSubGrupo%TYPE
                                   , cCodPaquete      FACTOR_REGION.CodPaquete%TYPE
                                   , nFactor          FACTOR_REGION.Factor%TYPE
                                   , cCodRegion       FACTOR_REGION.CodRegion%TYPE
                                   , cTextoClausula   CLOB ) RETURN VARCHAR2;
   --
   FUNCTION ACTUALIZAR_DATOS_COBERTURA( nCodCia               COTIZACIONES_DETALLE.CodCia%TYPE
                                      , nCodEmpresa           COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                      , nIdCotizacion         COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                      , nIDetCotizacion       COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                                      , cCodCobert            COTIZACIONES_COBERT_MASTER.CodCobert%TYPE
                                      , nDeducibleCobMoneda   COTIZACIONES_COBERT_MASTER.DeducibleCobMoneda%TYPE
                                      , nFranquiciaIngresado  COTIZACIONES_COBERT_MASTER.FranquiciaIngresado%TYPE ) RETURN VARCHAR2;
   --
   FUNCTION COBERTURAS_JSON( nCodCia           IN  COTIZACIONES_COBERT_WEB.CodCia%TYPE
                           , nCodEmpresa       IN  COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                           , nIdCotizacion     IN  COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE
                           , nIdetCotizacion   IN  COTIZACIONES_COBERT_WEB.IdetCotizacion%TYPE
                           , nCodGpoCobertWeb  IN  COTIZACIONES_COBERT_WEB.CodGpoCobertWeb%TYPE
                           , cCodCobertWeb     IN  COTIZACIONES_COBERT_WEB.CodCobertWeb%TYPE ) RETURN CLOB;
   --
   FUNCTION ACTUALIZAR_COBERTURAS( nCodCia        DOCUMENTOS_JSON.CodCia%TYPE
                                 , nCodEmpresa    DOCUMENTOS_JSON.CodEmpresa%TYPE
                                 , nIdCotizacion  DOCUMENTOS_JSON.IdCotizacion%TYPE
                                 , cJson_Data     DOCUMENTOS_JSON.Json_Data%TYPE ) RETURN CLOB;
   --
   FUNCTION CONSULTAR_COBERTURAS( nCodCia          COTIZACIONES_COBERT_WEB.CodCia%TYPE
                                , nCodEmpresa      COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                                , nIdCotizacion    COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE
                                , nIdetCotizacion  COTIZACIONES_COBERT_WEB.IdetCotizacion%TYPE ) RETURN CLOB;
   --
   PROCEDURE ACTUALIZAR_DETALLE( nCodCia              COTIZACIONES.CodCia%TYPE
                               , nCodEmpresa          COTIZACIONES.CodEmpresa%TYPE
                               , nIdCotizacion        COTIZACIONES.IdCotizacion%TYPE
                               , nIDetCotizacion      COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                               , cDescSubgrupo        COTIZACIONES_DETALLE.DescSubgrupo%TYPE
                               , nEdadLimite          COTIZACIONES_DETALLE.EdadLimite%TYPE
                               , nCantAsegurados      COTIZACIONES_DETALLE.CantAsegurados%TYPE
                               , nSalarioMensual      COTIZACIONES_DETALLE.SalarioMensual%TYPE
                               , nVecesSalario        COTIZACIONES_DETALLE.VecesSalario%TYPE
                               , nPorcExtraPrimaDet   COTIZACIONES_DETALLE.PorcExtraPrimaDet%TYPE
                               , nMontoExtraPrimaDet  COTIZACIONES_DETALLE.MontoExtraPrimaDet%TYPE
                               , nPrimaAsegurado      COTIZACIONES_DETALLE.PrimaAsegurado%TYPE
                               , nSumaAsegDetLocal    COTIZACIONES_DETALLE.SumaAsegDetLocal%TYPE
                               , nSumaAsegDetMoneda   COTIZACIONES_DETALLE.SumaAsegDetMoneda%TYPE
                               , nPrimaDetLocal       COTIZACIONES_DETALLE.PrimaDetLocal%TYPE
                               , nPrimaDetMoneda      COTIZACIONES_DETALLE.PrimaDetMoneda%TYPE
                               , cRiesgoTarifa        COTIZACIONES_DETALLE.RiesgoTarifa%TYPE
                               , nHorasVig            COTIZACIONES_DETALLE.HorasVig%TYPE
                               , nDiasVig             COTIZACIONES_DETALLE.DiasVig%TYPE
                               , nFactorAjuste        COTIZACIONES_DETALLE.FactorAjuste%TYPE
                               , nFactFormulaDeduc    COTIZACIONES_DETALLE.FactFormulaDeduc%TYPE
                               , cIndEdadPromedio     COTIZACIONES_DETALLE.IndEdadPromedio%TYPE
                               , cIndCuotaPromedio    COTIZACIONES_DETALLE.IndCuotaPromedio%TYPE
                               , cIndPrimaPromedio    COTIZACIONES_DETALLE.IndPrimaPromedio%TYPE
                               , cPrimaNetaPor        COTIZACIONES_DETALLE.PrimaNetaPor%TYPE );
   --
   PROCEDURE ACTUALIZAR_COMISIONES( nCodCia               COTIZACIONES.CodCia%TYPE
                                  , nCodEmpresa           COTIZACIONES.CodEmpresa%TYPE
                                  , nIdCotizacion         COTIZACIONES.IdCotizacion%TYPE
                                  , nPorcComisAgente      COTIZACIONES.PorcComisAgte%TYPE
                                  , nPorcComisPromot      COTIZACIONES.PorcComisProm%TYPE
                                  , nPorcComisDirecc      COTIZACIONES.PorcComisDir%TYPE
                                  , nPorcConv        OUT  NUMBER
                                  , nGastos          OUT  NUMBER );
   --
   FUNCTION CONSULTAR_LIMITE_COMISION( nCodCia        COTIZACIONES.CodCia%TYPE
                                     , nCodEmpresa    COTIZACIONES.CodEmpresa%TYPE
                                     , nIdCotizacion  COTIZACIONES.IdCotizacion%TYPE ) RETURN CLOB;
   --
   FUNCTION CONSULTAR_COMISIONES( nCodCia        COTIZACIONES.CodCia%TYPE
                                , nCodEmpresa    COTIZACIONES.CodEmpresa%TYPE
                                , nIdCotizacion  COTIZACIONES.IdCotizacion%TYPE ) RETURN CLOB;
   --
   FUNCTION CONSULTAR_COTIZACION( nCodCia        COTIZACIONES.CodCia%TYPE
                                , nCodEmpresa    COTIZACIONES.CodEmpresa%TYPE
                                , nIdCotizacion  COTIZACIONES.IdCotizacion%TYPE ) RETURN CLOB;
   --
   FUNCTION CONSULTAR_COTIZACIONES_DETALLE( nCodCia          COTIZACIONES_DETALLE.CodCia%TYPE
                                          , nCodEmpresa      COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                          , nIdCotizacion    COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                          , nIDetCotizacion  COTIZACIONES_DETALLE.IDetCotizacion%TYPE ) RETURN CLOB;
   --
   PROCEDURE ACTUALIZAR_ASEGURADO( nCodCia           COTIZACIONES_ASEG.CodCia%TYPE
                                 , nCodEmpresa       COTIZACIONES_ASEG.CodEmpresa%TYPE
                                 , nIdCotizacion     COTIZACIONES_ASEG.IdCotizacion%TYPE
                                 , nIDetCotizacion   COTIZACIONES_ASEG.IDetCotizacion%TYPE
                                 , nIdAsegurado      COTIZACIONES_ASEG.IdAsegurado%TYPE
                                 , cNombre           COTIZACIONES_ASEG.NombreAseg%TYPE
                                 , cApellidoPaterno  COTIZACIONES_ASEG.ApellidoPaternoAseg%TYPE
                                 , cApellidoMaterno  COTIZACIONES_ASEG.ApellidoMaternoAseg%TYPE
                                 , dFechaNacimiento  COTIZACIONES_ASEG.FechaNacAseg%TYPE );
   --
   PROCEDURE ELIMINAR_ASEGURADO( nCodCia           COTIZACIONES_ASEG.CodCia%TYPE
                               , nCodEmpresa       COTIZACIONES_ASEG.CodEmpresa%TYPE
                               , nIdCotizacion     COTIZACIONES_ASEG.IdCotizacion%TYPE
                               , nIDetCotizacion   COTIZACIONES_ASEG.IDetCotizacion%TYPE
                               , nIdAsegurado      COTIZACIONES_ASEG.IdAsegurado%TYPE
                               , cNombre           COTIZACIONES_ASEG.NombreAseg%TYPE
                               , cApellidoPaterno  COTIZACIONES_ASEG.ApellidoPaternoAseg%TYPE
                               , cApellidoMaterno  COTIZACIONES_ASEG.ApellidoMaternoAseg%TYPE );
   --
   FUNCTION INSERTAR_ASEGURADO( nCodCia           COTIZACIONES_ASEG.CodCia%TYPE
                              , nCodEmpresa       COTIZACIONES_ASEG.CodEmpresa%TYPE
                              , nIdCotizacion     COTIZACIONES_ASEG.IdCotizacion%TYPE
                              , nIDetCotizacion   COTIZACIONES_ASEG.IDetCotizacion%TYPE
                              , cNombre           COTIZACIONES_ASEG.NombreAseg%TYPE
                              , cApellidoPaterno  COTIZACIONES_ASEG.ApellidoPaternoAseg%TYPE
                              , cApellidoMaterno  COTIZACIONES_ASEG.ApellidoMaternoAseg%TYPE
                              , dFechaNacimiento  COTIZACIONES_ASEG.FechaNacAseg%TYPE ) RETURN NUMBER;
END FLUJO_COTIZACION_SIGO;
/

CREATE OR REPLACE PACKAGE BODY THONAPI.FLUJO_COTIZACION_SIGO IS
   --
   --MASP 20/10/2025 --> Actualiza el código del agente en la nueva cotización y la marca como cotización Web
   PROCEDURE ACTUALIZAR_AGENTE( nCodCia        COTIZACIONES.CodCia%TYPE
                              , nCodEmpresa    COTIZACIONES.CodEmpresa%TYPE
                              , nIdCotizacion  COTIZACIONES.IdCotizacion%TYPE
                              , nCodAgente     COTIZACIONES.CodAgente%TYPE ) IS
   BEGIN
      UPDATE COTIZACIONES
      SET    CodAgente            = nCodAgente
        ,    IndCotizacionWeb     = 'S'
        ,    IndCotizacionBaseWeb = 'N'
      WHERE  CodCia       = nCodCia
        AND  CodEmpresa   = nCodEmpresa
        AND  IdCotizacion = nIdCotizacion;
   EXCEPTION
   WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20205, 'ERROR AL ACTUALIZAR EL AGENTE DE LA COTIZACION: ' || nIdCotizacion || '... ' || SQLERRM);
   END ACTUALIZAR_AGENTE; 
   --
   --MASP 20/10/2025 --> Insertar un Detalle/Subgrupo nuevo en una Cotizacion. Esta versión recibe un parámetro de entrada en formato JSON con toda la información,
   --                    en lugar de la versión en THONAPI.API_MASIVOS_PLATAFORMA.INSERTAR_DETALLE_COTIZACION donde el parámetro que recibe viene en formato XML
   FUNCTION INSERTAR_DETALLE( nCodCia              COTIZACIONES.CodCia%TYPE
                            , nCodEmpresa          COTIZACIONES.CodEmpresa%TYPE
                            , nIdCotizacion        COTIZACIONES.IdCotizacion%TYPE
                            , cCodSubgrupo         COTIZACIONES_DETALLE.CodSubgrupo%TYPE
                            , cDescSubgrupo        COTIZACIONES_DETALLE.DescSubgrupo%TYPE
                            , nEdadLimite          COTIZACIONES_DETALLE.EdadLimite%TYPE
                            , nCantAsegurados      COTIZACIONES_DETALLE.CantAsegurados%TYPE
                            , nSalarioMensual      COTIZACIONES_DETALLE.SalarioMensual%TYPE
                            , nVecesSalario        COTIZACIONES_DETALLE.VecesSalario%TYPE
                            , nPorcExtraPrimaDet   COTIZACIONES_DETALLE.PorcExtraPrimaDet%TYPE
                            , nMontoExtraPrimaDet  COTIZACIONES_DETALLE.MontoExt--raPrimaDet%TYPE
                            , nPrimaAsegurado      COTIZACIONES_DETALLE.PrimaAsegurado%TYPE
                            , nSumaAsegDetLocal    COTIZACIONES_DETALLE.SumaAsegDetLocal%TYPE
                            , nSumaAsegDetMoneda   COTIZACIONES_DETALLE.SumaAsegDetMoneda%TYPE
                            , nPrimaDetLocal       COTIZACIONES_DETALLE.PrimaDetLocal%TYPE
                            , nPrimaDetMoneda      COTIZACIONES_DETALLE.PrimaDetMoneda%TYPE
                            , cRiesgoTarifa        COTIZACIONES_DETALLE.RiesgoTarifa%TYPE
                            , nHorasVig            COTIZACIONES_DETALLE.HorasVig%TYPE
                            , nDiasVig             COTIZACIONES_DETALLE.DiasVig%TYPE
                            , nFactorAjuste        COTIZACIONES_DETALLE.FactorAjuste%TYPE
                            , nFactFormulaDeduc    COTIZACIONES_DETALLE.FactFormulaDeduc%TYPE
                            , cIndEdadPromedio     COTIZACIONES_DETALLE.IndEdadPromedio%TYPE
                            , cIndCuotaPromedio    COTIZACIONES_DETALLE.IndCuotaPromedio%TYPE
                            , cIndPrimaPromedio    COTIZACIONES_DETALLE.IndPrimaPromedio%TYPE
                            , cPrimaNetaPor        COTIZACIONES_DETALLE.PrimaNetaPor%TYPE ) RETURN NUMBER IS
      nIDetCotizacion      COTIZACIONES_DETALLE.IDetCotizacion%TYPE;
      nIDetCotizacionOri   COTIZACIONES_DETALLE.IDetCotizacion%TYPE := 1;
   BEGIN
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
         ( CodCia          , CodEmpresa      , IdCotizacion     , IDetCotizacion  , CodSubgrupo      , DescSubgrupo      ,
           EdadLimite      , CantAsegurados  , SalarioMensual   , VecesSalario    , PorcExtraPrimaDet, MontoExtraPrimaDet,
           PrimaAsegurado  , SumaAsegDetLocal, SumaAsegDetMoneda, PrimaDetLocal   , PrimaDetMoneda   , RiesgoTarifa      ,
           HorasVig        , DiasVig         , FactorAjuste     , FactFormulaDeduc, IndEdadPromedio  , IndCuotaPromedio  ,
           IndPrimaPromedio, PrimaNetaPor )
      VALUES ( nCodCia          , nCodEmpresa      , nIdCotizacion     , nIDetCotizacion  , cCodSubgrupo      , cDescSubgrupo      ,
               nEdadLimite      , nCantAsegurados  , nSalarioMensual   , nVecesSalario    , nPorcExtraPrimaDet, nMontoExtraPrimaDet,
               nPrimaAsegurado  , nSumaAsegDetLocal, nSumaAsegDetMoneda, nPrimaDetLocal   , nPrimaDetMoneda   , cRiesgoTarifa      ,
               nHorasVig        , nDiasVig         , nFactorAjuste     , nFactFormulaDeduc, cIndEdadPromedio  , cIndCuotaPromedio  ,
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
   END INSERTAR_DETALLE;
   --
   --MASP 24/11/2025 --> Actualiza información de la cotización y solo para un detalle. Esta versión recibe un parámetro de entrada en formato JSON con toda la información a actualizar,
   --                    en lugar de la versión en THONAPI.GENERALES_PLATAFORMA_DIGITAL.RECIBE_GENERALES_COTIZACION donde el parámetro que recibe viene en formato XML
   FUNCTION RECIBIR_GENERALES( nCodCia          COTIZACIONES_DETALLE.CodCia%TYPE
                             , nCodEmpresa      COTIZACIONES_DETALLE.CodEmpresa%TYPE
                             , nIdCotizacion    COTIZACIONES_DETALLE.IdCotizacion%TYPE
                             , nIDetCotizacion  COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                             , nHorasVig        COTIZACIONES_DETALLE.HorasVig%TYPE
                             , nDiasVig         COTIZACIONES_DETALLE.DiasVig%TYPE
                             , nCantAsegurados  COTIZACIONES_DETALLE.CantAsegurados%TYPE
                             , nFactorAjuste    COTIZACIONES.FactorAjuste%TYPE
                             , cRiesgoTarifa    COTIZACIONES_DETALLE.RiesgoTarifa%TYPE
                             , cTiponegocio     COTIZACIONES.Tipnego_Web%TYPE
                             , cLaboral         COTIZACIONES.Ries_Labor%TYPE
                             , cRies24_365      COTIZACIONES.Ries_24365%TYPE
                             , cTraslados       COTIZACIONES.Ries_Trasla%TYPE
                             , nPorcDescuento   COTIZACIONES.PorcDescuento%TYPE
                             , nPorcGtoAdmin    COTIZACIONES.PorcGtoAdmin%TYPE ) RETURN VARCHAR2 IS
      cResultado  VARCHAR2(2) := 'OK';
   BEGIN
      UPDATE COTIZACIONES
      SET    CantAsegurados = NVL(nCantAsegurados, CantAsegurados)
        ,    FactorAjuste   = NVL(nFactorAjuste  , FactorAjuste)
        ,    RiesgoTarifa   = NVL(cRiesgoTarifa  , RiesgoTarifa)
        ,    Tipnego_Web    = NVL(cTiponegocio   , Tipnego_Web)
        ,    Ries_Labor     = NVL(cLaboral       , Ries_Labor)
        ,    Ries_24365     = NVL(cRies24_365    , Ries_24365)
        ,    Ries_Trasla    = NVL(cTraslados     , Ries_Trasla)
        ,    PorcDescuento  = NVL(nPorcDescuento , PorcDescuento)
        ,    PorcGtoAdmin   = NVL(nPorcGtoAdmin  , PorcGtoAdmin)
      WHERE  CodCia       = nCodCia
        AND  CodEmpresa   = nCodEmpresa
        AND  IdCotizacion = nIdCotizacion;     
      --
      GT_COTIZACIONES_CLAUSULAS.CREAR_TEXTORIESGOS_COTIZA(nCodCia, cTiponegocio, cLaboral, cRies24_365, cTraslados, nIdCotizacion);
      --
      UPDATE COTIZACIONES_DETALLE
      SET    CantAsegurados = NVL(nCantAsegurados, CantAsegurados)
        ,    HorasVig       = NVL(nHorasVig      , HorasVig)
        ,    DiasVig        = NVL(nDiasVig       , DiasVig)
        ,    RiesgoTarifa   = NVL(cRiesgoTarifa  , RiesgoTarifa)
      WHERE  CodCia         = nCodCia
        AND  CodEmpresa     = nCodEmpresa
        AND  IdCotizacion   = nIdCotizacion
        AND  IDetCotizacion = NVL(nIDetCotizacion, IDetCotizacion);
      --
      RETURN cResultado;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL ACTUALIZAR EL DETALLE DE LA COTIZACION: ' || nIdCotizacion || ' - SUBGRUPO: ' || nIDetCotizacion || '... ' || SQLERRM);
   END RECIBIR_GENERALES;

   FUNCTION ACTUALIZAR_INFORMACION( nCodCia                COTIZACIONES.CodCia%TYPE
                                  , nCodEmpresa            COTIZACIONES.CodEmpresa%TYPE
                                  , nIdCotizacion          COTIZACIONES.IdCotizacion%TYPE
                                  , cCodTipoBono           COTIZACIONES.CodTipoBono%TYPE
                                  , cCodRiesgoREA          COTIZACIONES.CodRiesgoREA%TYPE
                                  , nFactorAjuste          COTIZACIONES.FactorAjuste%TYPE
                                  , cCodTipoNegocio        COTIZACIONES.CodTipoNegocio%TYPE
                                  , cDescElegibilidad      COTIZACIONES.DescElegibilidad%TYPE
                                  , cDescRiesgosCubiertos  COTIZACIONES.DescRiesgosCubiertos%TYPE
                                  , cCodPlanPago           COTIZACIONES.CodPlanPago%TYPE
                                  , nGastosExpedicion      COTIZACIONES.GastosExpedicion%TYPE
                                  , nPorcConvenciones      COTIZACIONES.PorcConvenciones%TYPE
                                  , cTipoAdministracion    COTIZACIONES.TipoAdministracion%TYPE
                                  , nPorcGtoAdmin          COTIZACIONES.PorcGtoAdmin%TYPE
                                  , nPorcUtilidad          COTIZACIONES.PorcUtilidad%TYPE
                                  , nHorasVig              COTIZACIONES.HorasVig%TYPE
                                  , nDiasVig               COTIZACIONES.DiasVig%TYPE ) RETURN VARCHAR2 IS
      cResultado  VARCHAR2(2) := 'OK';
   BEGIN
      UPDATE COTIZACIONES
      SET    CodTipoBono          = NVL( cCodTipoBono, CodTipoBono )
        ,    CodRiesgoREA         = NVL( cCodRiesgoREA, CodRiesgoREA )
        ,    FactorAjuste         = NVL( nFactorAjuste, FactorAjuste )
        ,    CodTipoNegocio       = NVL( cCodTipoNegocio, CodTipoNegocio )
        ,    DescElegibilidad     = NVL( cDescElegibilidad, DescElegibilidad )
        ,    DescRiesgosCubiertos = NVL( cDescRiesgosCubiertos, DescRiesgosCubiertos )
        ,    CodPlanPago          = NVL( cCodPlanPago, CodPlanPago )
        ,    GastosExpedicion     = NVL( nGastosExpedicion, GastosExpedicion )
        ,    PorcConvenciones     = NVL( nPorcConvenciones, PorcConvenciones )
        ,    TipoAdministracion   = NVL( cTipoAdministracion, TipoAdministracion )
        ,    PorcGtoAdqui         = NVL( PorcComisProm, 0 ) + NVL( PorcComisDir, 0 ) + NVL( PorcComisAgte, 0 ) 
        ,    PorcGtoAdmin         = NVL( nPorcGtoAdmin, PorcGtoAdmin )
        ,    PorcUtilidad         = NVL( nPorcUtilidad, PorcUtilidad )
        ,    HorasVig             = NVL( nHorasVig, HorasVig )
        ,    DiasVig              = NVL( nDiasVig, DiasVig )
      WHERE  CodCia       = nCodCia
        AND  CodEmpresa   = nCodEmpresa
        AND  IdCotizacion = nIdCotizacion;
      --
      RETURN cResultado;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL ACTUALIZAR LA INFORMACION GENERAL DE LA COTIZACION: ' || nIdCotizacion || ' - ' || SQLERRM);
   END ACTUALIZAR_INFORMACION;

   FUNCTION CONSULTAR_CLAUSULAS( nCodCia        COTIZACIONES_CLAUSULAS.CodCia%TYPE
                               , nCodEmpresa    COTIZACIONES_CLAUSULAS.CodEmpresa%TYPE
                               , nIdCotizacion  COTIZACIONES_CLAUSULAS.IdCotizacion%TYPE ) RETURN CLOB IS
      cJson           CLOB;
      cTemp           CLOB;
      cCodClausula    COTIZACIONES_CLAUSULAS.CodClausula%TYPE;
      cTextoClausula  COTIZACIONES_CLAUSULAS.TextoClausula%TYPE;
      --
      CURSOR cClausulas IS
             SELECT CodClausula, TextoClausula
             FROM   COTIZACIONES_CLAUSULAS
             WHERE  CodCia          = nCodCia
               AND  CodEmpresa      = nCodEmpresa
               AND  IdCotizacion    = nIdCotizacion;
   BEGIN
      DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
      DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
      --
      OPEN cClausulas;
      LOOP
         FETCH cClausulas INTO cCodClausula, cTextoClausula;
         EXIT WHEN cClausulas%NOTFOUND;
         --
         cTemp := '{
                     "CODCLAUSULA": "' || cCodClausula || '",
                     "TEXTOCLAUSULA": "' || cTextoClausula || '"
                   }';
         IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
            DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
         END IF;
         --
         DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
      END LOOP;
      CLOSE cClausulas;
        DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
        RETURN cJson;
   END CONSULTAR_CLAUSULAS;

   FUNCTION INSERTAR_CLAUSULAS( nCodCia         COTIZACIONES_CLAUSULAS.CodCia%TYPE
                              , nCodEmpresa     COTIZACIONES_CLAUSULAS.CodEmpresa%TYPE
                              , nIdCotizacion   COTIZACIONES_CLAUSULAS.IdCotizacion%TYPE
                              , cCodClausula    COTIZACIONES_CLAUSULAS.CodClausula%TYPE
                              , cTextoClausula  COTIZACIONES_CLAUSULAS.TextoClausula%TYPE ) RETURN VARCHAR2 IS
      cTextoClausula_1  VARCHAR2(4000);
      cResultado        VARCHAR2(2) := 'OK';
   BEGIN
      IF cTextoClausula IS NOT NULL THEN
         cTextoClausula_1 := cTextoClausula;
      ELSE
         BEGIN
            SELECT TextoClausula
            INTO   cTextoClausula_1
            FROM   CLAUSULAS
            WHERE  CodCia      = nCodCia
              AND  CodEmpresa  = nCodEmpresa
              AND  CodClausula = cCodClausula;
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
              cTextoClausula_1 := NULL;
         END;
      END IF;
      --
      INSERT INTO COTIZACIONES_CLAUSULAS ( CodCia , CodEmpresa , IdCotizacion , CodClausula , TextoClausula , IndicadorCoti )
      VALUES ( nCodCia, nCodEmpresa, nIdCotizacion, cCodClausula, cTextoClausula_1, NULL );
      --
      RETURN cResultado;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL INSERTAR LA CLAUSULA DE LA COTIZACION: ' || nIdCotizacion || ' - ' || SQLERRM);
   END INSERTAR_CLAUSULAS;

   FUNCTION REGISTRAR_FACTOR_GUA( nCodCia          COTIZACIONES_DETALLE.CodCia%TYPE
                                , nCodEmpresa      COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                , nIdCotizacion    COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                , nIDetCotizacion  COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                                , cCodSubGrupo     COTIZACIONES_DETALLE.CodSubGrupo%TYPE
                                , cCodCobert       VARCHAR2
                                , cNivel           COTIZACIONES_DETALLE_FACTOR.CodFactor%TYPE
                                , nFactor          COTIZACIONES_DETALLE_FACTOR.Factor%TYPE
                                , cCodClausula     COTIZACIONES_CLAUSULAS.CodClausula%TYPE
                                , cTextoClausula   CLOB ) RETURN VARCHAR2 IS
      lTextoClausula  LONG;
      cExisteFactor   VARCHAR2(1) := 'N';
      cResultado      VARCHAR2(2) := 'OK';
   BEGIN
      --Valido si el factor existe
      BEGIN
         SELECT 'S'
         INTO   cExisteFactor
         FROM   COTIZACIONES_DETALLE_FACTOR
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion
           AND  TipoFactor     = 'GUA';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
           cExisteFactor := 'N';
      END;
      --
      --Registro el nuevo factor
      IF cExisteFactor = 'N' THEN
         INSERT INTO COTIZACIONES_DETALLE_FACTOR ( CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, TipoFactor, CodFactor, Factor )
         VALUES ( nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, 'GUA', cNivel, nFactor );
      ELSE
         UPDATE COTIZACIONES_DETALLE_FACTOR
         SET    CodFactor = cNivel
              , Factor    = nFactor
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion
           AND  TipoFactor     = 'GUA';
      END IF;
      --
      --Elimino todas las Clausulas De la Cotización que pertenezcan al GUA 
      DELETE COTIZACIONES_CLAUSULAS CC
      WHERE  CC.CodCia       = nCodCia
        AND  CC.CodEmpresa   = nCodEmpresa
        AND  CC.IdCotizacion = nIdCotizacion
        AND  CC.CodClausula IN ( SELECT CF.CodClausula
                                 FROM   CLAUSULAS_FACTORES CF
                                 WHERE  CF.TIPOFACTOR = 'GUA' );
      --
      --Determino el Texto de la Clausula
      IF LENGTH(cTextoClausula) = 0  OR cTextoClausula IS NULL THEN
         BEGIN
            SELECT TextoClausula
            INTO   lTextoClausula
            FROM   CLAUSULAS
            WHERE  CodCia      = nCodCia
              AND  CodEmpresa  = nCodEmpresa
              AND  CodClausula = cCodClausula;
         EXCEPTION
         WHEN OTHERS THEN
              lTextoClausula := cTextoClausula;
         END;
      ELSE
         lTextoClausula := cTextoClausula;
      END IF;
      --
      --Inserto las Clausulas de GUA que vengan en el XML
      BEGIN
         INSERT INTO COTIZACIONES_CLAUSULAS( CodCia, CodEmpresa, IdCotizacion, CodClausula, TextoClausula )
         VALUES ( nCodCia, nCodEmpresa, nIdCotizacion, cCodClausula, lTextoClausula );
      EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
           UPDATE COTIZACIONES_CLAUSULAS
           SET    TextoClausula = lTextoClausula
           WHERE  CodCia       = nCodCia
             AND  CodEmpresa   = nCodEmpresa
             AND  IdCotizacion = nIdCotizacion
             AND  CodClausula  = cCodClausula;
      END; 
      --
      --Actualizo el FactorAjuste en COTIZACIONES_DETALLE
      GT_COTIZACIONES_DETALLE.RECALCULA_FACTORAJUSTE( nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, cCodSubGrupo );
      --
      RETURN cResultado;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL REGISTRAR LOS FACTORES DE GUA: ' || nIdCotizacion || ' - ' || SQLERRM);
   END REGISTRAR_FACTOR_GUA;

   FUNCTION REGISTRAR_FACTOR_PADESPE( nCodCia          COTIZACIONES_DETALLE.CodCia%TYPE
                                    , nCodEmpresa      COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                    , nIdCotizacion    COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                    , nIDetCotizacion  COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                                    , cCodSubGrupo     COTIZACIONES_DETALLE.CodSubGrupo%TYPE
                                    , cCodCobert       VARCHAR2
                                    , cIndIncluido     VARCHAR2
                                    , nFactor          COTIZACIONES_DETALLE_FACTOR.Factor%TYPE
                                    , cCodEndoso       COTIZACIONES_DETALLE_FACTOR.CodFactor%TYPE
                                    , cTextoClausula   CLOB ) RETURN VARCHAR2 IS
      lTextoClausula  LONG;
      cExisteFactor   VARCHAR2(1) := 'N';
      cResultado      VARCHAR2(2) := 'OK';
   BEGIN
      --Valido si el factor existe
      BEGIN
         SELECT 'S'
         INTO   cExisteFactor
         FROM   COTIZACIONES_DETALLE_FACTOR
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion
           AND  TipoFactor     = 'PADESP';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
           cExisteFactor := 'N';
      END;
      --
      --Registro el nuevo factor
      IF cExisteFactor = 'N' THEN
         INSERT INTO COTIZACIONES_DETALLE_FACTOR( CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, TipoFactor, CodFactor, Factor )
         VALUES (nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, 'PADESP', cCodEndoso, nFactor );
      ELSE
         UPDATE COTIZACIONES_DETALLE_FACTOR
         SET    CodFactor = cCodEndoso
              , Factor    = nFactor
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion
           AND  TipoFactor     = 'PADESP';
      END IF;
      --
      --Elimino todas las Clausulas De la Cotización que pertenezcan a Padecimientos Especiales 
      DELETE COTIZACIONES_CLAUSULAS CC
      WHERE  CC.CodCia       = nCodCia
        AND  CC.CodEmpresa   = nCodEmpresa
        AND  CC.IdCotizacion = nIdCotizacion
        AND  CC.CodClausula IN ( SELECT CF.CodClausula
                                 FROM   CLAUSULAS_FACTORES CF
                                 WHERE  CF.TIPOFACTOR = 'PADESP' );
      --
      IF cIndIncluido = 'S' THEN
         --Determino el Texto de la Clausula
         IF LENGTH(cTextoClausula) = 0 OR cTextoClausula IS NULL THEN
            BEGIN
               SELECT TextoClausula
               INTO   lTextoClausula
               FROM   CLAUSULAS
               WHERE  CodCia      = nCodCia
                 AND  CodEmpresa  = nCodEmpresa
                 AND  CodClausula = cCodEndoso;
            EXCEPTION
            WHEN OTHERS THEN
                 lTextoClausula := cTextoClausula;
            END;
         ELSE
            lTextoClausula := cTextoClausula;
         END IF;
         --
         --Inserto las Clausulas de Padecimientos Especiales que vengan en el XML
         BEGIN
            INSERT INTO COTIZACIONES_CLAUSULAS( CodCia, CodEmpresa, IdCotizacion, CodClausula, TextoClausula )
            VALUES ( nCodCia, nCodEmpresa, nIdCotizacion, cCodEndoso, lTextoClausula );
         EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
              UPDATE COTIZACIONES_CLAUSULAS
              SET    TextoClausula = lTextoClausula
              WHERE  CodCia       = nCodCia
                AND  CodEmpresa   = nCodEmpresa
                AND  IdCotizacion = nIdCotizacion
                AND  CodClausula  = cCodEndoso;
         END;
      END IF;
      --
      --Actualizo el FactorAjuste en COTIZACIONES_DETALLE
      GT_COTIZACIONES_DETALLE.RECALCULA_FACTORAJUSTE( nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, cCodSubGrupo );
      --           
      RETURN cResultado;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL REGISTRAR LOS FACTORES DE PADECIMIENTOS ESPECIALES: ' || nIdCotizacion || ' - ' || SQLERRM);
   END REGISTRAR_FACTOR_PADESPE;

   FUNCTION REGISTRAR_FACTOR_NIVHOSP( nCodCia          COTIZACIONES_DETALLE.CodCia%TYPE
                                    , nCodEmpresa      COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                    , nIdCotizacion    COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                    , nIDetCotizacion  COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                                    , cCodSubGrupo     COTIZACIONES_DETALLE.CodSubGrupo%TYPE
                                    , cCodCobert       VARCHAR2
                                    , cIndIncluido     VARCHAR2
                                    , nFactor          COTIZACIONES_DETALLE_FACTOR.Factor%TYPE
                                    , cCodEndoso       COTIZACIONES_DETALLE_FACTOR.CodFactor%TYPE
                                    , cTextoClausula   CLOB ) RETURN VARCHAR2 IS
      lTextoClausula  LONG;
      cExisteFactor   VARCHAR2(1) := 'N';
      cResultado      VARCHAR2(2) := 'OK';
   BEGIN
      --Valido si el factor existe
      BEGIN
         SELECT 'S'
         INTO   cExisteFactor
         FROM   COTIZACIONES_DETALLE_FACTOR
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion
           AND  TipoFactor     = 'NIVHOS';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
           cExisteFactor := 'N';
      END;
      --
      --Registro el nuevo factor
      IF cExisteFactor = 'N' THEN
         INSERT INTO COTIZACIONES_DETALLE_FACTOR ( CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, TipoFactor, CodFactor, Factor )
         VALUES ( nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, 'NIVHOS', cCodEndoso, nFactor );
      ELSE
         UPDATE COTIZACIONES_DETALLE_FACTOR
         SET    CodFactor = cCodEndoso
           ,    Factor    = nFactor
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion
           AND  TipoFactor     = 'NIVHOS';
      END IF;
      --
      --Elimino todas las Clausulas De la Cotización que pertenezcan al Nivel Hospitalario 
      DELETE COTIZACIONES_CLAUSULAS CC
      WHERE  CC.CodCia       = nCodCia
        AND  CC.CodEmpresa   = nCodEmpresa
        AND  CC.IdCotizacion = nIdCotizacion
        AND  CC.CodClausula IN ( SELECT CF.CodClausula
                                 FROM   CLAUSULAS_FACTORES CF
                                 WHERE  CF.TIPOFACTOR = 'NIVHOS' );
      --
      IF cIndIncluido = 'S' THEN
         --Determino el Texto de la Clausula
         IF LENGTH(cTextoClausula) = 0 OR cTextoClausula IS NULL THEN
            BEGIN
               SELECT TextoClausula
               INTO   lTextoClausula
               FROM   CLAUSULAS
               WHERE  CodCia      = nCodCia
                 AND  CodEmpresa  = nCodEmpresa
                 AND  CodClausula = cCodEndoso;
            EXCEPTION
            WHEN OTHERS THEN
                 lTextoClausula := cTextoClausula;
            END;
         ELSE
            lTextoClausula := cTextoClausula;
         END IF;
         --
         --Inserto las Clausulas de Nivel Hospitalario que vengan en el XML
         BEGIN
            INSERT INTO COTIZACIONES_CLAUSULAS ( CodCia, CodEmpresa, IdCotizacion, CodClausula, TextoClausula )
            VALUES ( nCodCia, nCodEmpresa, nIdCotizacion, cCodEndoso, lTextoClausula );
         EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
              UPDATE COTIZACIONES_CLAUSULAS
              SET    TextoClausula = lTextoClausula
              WHERE  CodCia       = nCodCia
                AND  CodEmpresa   = nCodEmpresa
                AND  IdCotizacion = nIdCotizacion
                AND  CodClausula  = cCodEndoso;
         END;
      END IF;
      --
      --Actualizo el FactorAjuste en COTIZACIONES_DETALLE 
      GT_COTIZACIONES_DETALLE.RECALCULA_FACTORAJUSTE( nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, cCodSubGrupo );
      --
      RETURN cResultado;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL REGISTRAR LOS FACTORES DE NIVEL HOSPITALARIO: ' || nIdCotizacion || ' - ' || SQLERRM);
   END REGISTRAR_FACTOR_NIVHOSP;

   FUNCTION REGISTRAR_FACTOR_EQUIREP( nCodCia          COTIZACIONES_DETALLE.CodCia%TYPE
                                    , nCodEmpresa      COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                    , nIdCotizacion    COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                    , nIDetCotizacion  COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                                    , cCodSubGrupo     COTIZACIONES_DETALLE.CodSubGrupo%TYPE
                                    , cCodPaquete      FACTOR_EQUIPOS_REPRESENTA.CodPaquete%TYPE
                                    , cIndIncluido     VARCHAR2
                                    , nFactor          FACTOR_EQUIPOS_REPRESENTA.Factor%TYPE
                                    , cCodEquipo       FACTOR_EQUIPOS_REPRESENTA.CodEquipo%TYPE
                                    , cTextoClausula   CLOB ) RETURN VARCHAR2 IS
      lTextoClausula  CLOB;
      cExisteFactor   VARCHAR2(1) := 'N';
      cResultado      VARCHAR2(2) := 'OK';
      cPlanCob        COTIZACIONES.PlanCob%TYPE;
      cIdTipoSeg      COTIZACIONES.IdTipoSeg%TYPE;
   BEGIN
      -- Se busca valor del texto para agregar al riesgo a cubrir y actualizar la cotizacion
      SELECT IdTipoSeg, PlanCob
      INTO   cIdTipoSeg, cPlanCob
      FROM   COTIZACIONES 
      WHERE  CodCia        = nCodCia
        AND  CodEmpresa    = nCodEmpresa
        AND  IdCotizacion  = nIdCotizacion;
      --
      --Valido si el factor existe
      BEGIN
         SELECT 'S'
         INTO   cExisteFactor
         FROM   COTIZACIONES_DETALLE_FACTOR
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion
           AND  TipoFactor     = 'EQUREP';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
           cExisteFactor := 'N';
      END;
      --
      --Registro el nuevo factor
      IF cExisteFactor = 'N' THEN
         INSERT INTO COTIZACIONES_DETALLE_FACTOR( CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, TipoFactor, CodFactor, Factor )
         VALUES ( nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, 'EQUREP'  , cCodEquipo, nFactor );
      ELSE
         UPDATE COTIZACIONES_DETALLE_FACTOR
         SET    CodFactor = cCodEquipo
           ,    Factor    = nFactor
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion
           AND  TipoFactor     = 'EQUREP';
      END IF;
      --
      IF cIndIncluido = 'S' THEN
         --Determino el Texto de la Clausula
         IF LENGTH(cTextoClausula) = 0 OR cTextoClausula IS NULL THEN
            BEGIN
               SELECT NVL(TextoFactor, ' ')
                 INTO lTextoClausula
                 FROM FACTOR_EQUIPOS_REPRESENTA
                WHERE CodCia     = nCodCia
                  AND CodEmpresa = nCodEmpresa
                  AND IdTipoSeg  = cIdTipoSeg
                  AND PlanCob    = cPlanCob
                  AND CodPaquete = cCodPaquete
                  AND CodEquipo  = cCodEquipo;
            EXCEPTION
            WHEN OTHERS THEN
                 lTextoClausula := cTextoClausula;
            END;
         ELSE
            lTextoClausula := cTextoClausula;
         END IF;
         --
         UPDATE COTIZACIONES
         SET    DescRiesgosCubiertos = lTextoClausula
         WHERE  CodCia        = nCodCia
           AND  CodEmpresa    = nCodEmpresa
           AND  IdCotizacion  = nIdCotizacion;
      END IF;
      --
      --Actualizo el FactorAjuste en COTIZACIONES_DETALLE 
      GT_COTIZACIONES_DETALLE.RECALCULA_FACTORAJUSTE( nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, cCodSubGrupo );
      --           
      RETURN cResultado;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL REGISTRAR LOS FACTORES DE EQUIPO REPRESENTATIVO: ' || nIdCotizacion || ' - ' || SQLERRM);
   END REGISTRAR_FACTOR_EQUIREP;

   FUNCTION REGISTRAR_FACTOR_REGION( nCodCia          COTIZACIONES_DETALLE.CodCia%TYPE
                                   , nCodEmpresa      COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                   , nIdCotizacion    COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                   , nIDetCotizacion  COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                                   , cCodSubGrupo     COTIZACIONES_DETALLE.CodSubGrupo%TYPE
                                   , cCodPaquete      FACTOR_REGION.CodPaquete%TYPE
                                   , nFactor          FACTOR_REGION.Factor%TYPE
                                   , cCodRegion       FACTOR_REGION.CodRegion%TYPE
                                   , cTextoClausula   CLOB ) RETURN VARCHAR2 IS
      lTextoClausula  CLOB;
      cExisteFactor   VARCHAR2(1) := 'N';
      cResultado      VARCHAR2(2) := 'OK';
      cPlanCob        COTIZACIONES.PlanCob%TYPE;
      cIdTipoSeg      COTIZACIONES.IdTipoSeg%TYPE;
      cTextoRegion    VALORES_DE_LISTAS.DescValLst%TYPE;
   BEGIN
      -- Se busca valor del texto para agregar al riesgo a cubrir y actualizar la cotizacion
      SELECT IdTipoSeg, PlanCob
      INTO   cIdTipoSeg, cPlanCob
      FROM   COTIZACIONES 
      WHERE  CodCia        = nCodCia
        AND  CodEmpresa    = nCodEmpresa
        AND  IdCotizacion  = nIdCotizacion;
      --
      --Valido si el factor existe
      BEGIN
         SELECT 'S'
         INTO   cExisteFactor
         FROM   COTIZACIONES_DETALLE_FACTOR
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion
           AND  TipoFactor     = 'REGION';
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
           cExisteFactor := 'N';
      END;
      --
      --Registro el nuevo factor
      IF cExisteFactor = 'N' THEN
         INSERT INTO COTIZACIONES_DETALLE_FACTOR( CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, TipoFactor, CodFactor, Factor )
         VALUES ( nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, 'REGION'  , cCodRegion, nFactor );
      ELSE
         UPDATE COTIZACIONES_DETALLE_FACTOR
         SET    CodFactor = cCodRegion
           ,    Factor    = nFactor
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion
           AND  TipoFactor     = 'REGION';
      END IF;
      --
      --Determino el Texto de la Clausula
      IF LENGTH(cTextoClausula) = 0 OR cTextoClausula IS NULL THEN
         BEGIN
            SELECT NVL(TextoFactor, ' ')
            INTO   lTextoClausula
            FROM   FACTOR_REGION
            WHERE  CodCia     = nCodCia
              AND  CodEmpresa = nCodEmpresa
              AND  IdTipoSeg  = cIdTipoSeg
              AND  PlanCob    = cPlanCob
              AND  CodPaquete = cCodPaquete
              AND  CodRegion  = cCodRegion;
         EXCEPTION
         WHEN OTHERS THEN
              lTextoClausula := cTextoClausula;
         END;
      ELSE
         lTextoClausula := cTextoClausula;
      END IF;
      --
      cTextoRegion := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('REGIONFACT', cCodRegion);
      --
      UPDATE COTIZACIONES
      SET    DescElegibilidad = lTextoClausula
      WHERE  CodCia        = nCodCia
        AND  CodEmpresa    = nCodEmpresa
        AND  IdCotizacion  = nIdCotizacion;
      --
      --Actualizo el FactorAjuste en COTIZACIONES_DETALLE 
      GT_COTIZACIONES_DETALLE.RECALCULA_FACTORAJUSTE( nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, cCodSubGrupo );
      --           
      RETURN cResultado;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL REGISTRAR LOS FACTORES DE REGION: ' || nIdCotizacion || ' - ' || SQLERRM);
   END REGISTRAR_FACTOR_REGION;

   FUNCTION ACTUALIZAR_DATOS_COBERTURA( nCodCia               COTIZACIONES_DETALLE.CodCia%TYPE
                                      , nCodEmpresa           COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                      , nIdCotizacion         COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                      , nIDetCotizacion       COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                                      , cCodCobert            COTIZACIONES_COBERT_MASTER.CodCobert%TYPE
                                      , nDeducibleCobMoneda   COTIZACIONES_COBERT_MASTER.DeducibleCobMoneda%TYPE
                                      , nFranquiciaIngresado  COTIZACIONES_COBERT_MASTER.FranquiciaIngresado%TYPE ) RETURN VARCHAR2 IS
      cResultado              VARCHAR2(2) := 'OK';
      cCodMoneda              COTIZACIONES.Cod_Moneda%TYPE;
      nTasaCambio             NUMBER;
      nDeducibleCobMoneda_1   COTIZACIONES_COBERT_MASTER.DeducibleCobMoneda%TYPE;
      nDeducibleCobLocal_1    COTIZACIONES_COBERT_MASTER.DeducibleCobLocal%TYPE;
      nFranquiciaIngresado_1  COTIZACIONES_COBERT_MASTER.FranquiciaIngresado%TYPE;
   BEGIN
      SELECT Cod_Moneda
      INTO   cCodMoneda
      FROM   COTIZACIONES 
      WHERE  CodCia       = nCodCia
        AND  CodEmpresa   = nCodEmpresa
        AND  IdCotizacion = nIdCotizacion;
      --
      nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
      --
      IF nDeducibleCobMoneda IS NOT NULL THEN
         nDeducibleCobMoneda_1 := nDeducibleCobMoneda;
         nDeducibleCobLocal_1  := nDeducibleCobMoneda * nTasaCambio;
      END IF;
      --
      IF nFranquiciaIngresado IS NOT NULL THEN
         nFranquiciaIngresado_1 := nFranquiciaIngresado;
      END IF;

      UPDATE COTIZACIONES_COBERT_MASTER
          SET DeducibleCobMoneda  = NVL(nDeducibleCobMoneda_1, DeducibleCobMoneda),
              DeducibleCobLocal   = NVL(nDeducibleCobLocal_1 , DeducibleCobLocal),
              DeducibleIngresado  = NVL(DeducibleIngresado   , DeducibleCobLocal)
        WHERE CodCia           = nCodCia
          AND CodEmpresa       = nCodEmpresa
          AND IdCotizacion     = nIdCotizacion
          AND IDetCotizacion   = nIDetCotizacion
          AND CodCobert        = cCodCobert;

       UPDATE COTIZACIONES_COBERTURAS
          SET DeducibleCobMoneda  = NVL(nDeducibleCobMoneda_1, DeducibleCobMoneda),
              DeducibleCobLocal   = NVL(nDeducibleCobLocal_1 , DeducibleCobLocal),
              DeducibleIngresado  = NVL(DeducibleIngresado   , DeducibleCobLocal)
        WHERE CodCia           = nCodCia
          AND CodEmpresa       = nCodEmpresa
          AND IdCotizacion     = nIdCotizacion
          AND IDetCotizacion   = nIDetCotizacion
          AND CodCobert        = cCodCobert;      
      --           
      RETURN cResultado;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL REGISTRAR LOS FACTORES DE REGION: ' || nIdCotizacion || ' - ' || SQLERRM);
   END ACTUALIZAR_DATOS_COBERTURA;

   FUNCTION COBERTURAS_JSON( nCodCia          IN  COTIZACIONES_COBERT_WEB.CodCia%TYPE
                          , nCodEmpresa       IN  COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                          , nIdCotizacion     IN  COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE
                          , nIdetCotizacion   IN  COTIZACIONES_COBERT_WEB.IdetCotizacion%TYPE
                          , nCodGpoCobertWeb  IN  COTIZACIONES_COBERT_WEB.CodGpoCobertWeb%TYPE
                          , cCodCobertWeb     IN  COTIZACIONES_COBERT_WEB.CodCobertWeb%TYPE ) RETURN CLOB IS
      cResultado           CLOB;
      cCodGpoCobertWeb_1   COTIZACIONES_COBERT_WEB.CodGpoCobertWeb%TYPE;
      cCodCobertWeb_1      COTIZACIONES_COBERTURAS.CodCobert%TYPE;
      cIdTipoSeg           COTIZACIONES.IdTipoSeg%TYPE;
      cPlanCob             COTIZACIONES.PlanCob%TYPE;
      cDescCobertWeb       VARCHAR2(500);
      cIndAsegModelo       COTIZACIONES.IndAsegModelo%TYPE;
      cCobertloca          VARCHAR2(200);  
      --
      CURSOR Grupos IS
             SELECT A.CodGpoCobertWeb, OC_VALORES_DE_LISTAS.BUSCA_LVALOR( 'GPOCOBWEB', A.CodGpoCobertWeb ) CodGpoCobertWebDesc
             FROM   COTIZACIONES_COBERT_WEB    A
                ,   COTIZACIONES_COBERT_MASTER B
             WHERE  A.CodCia          = B.CodCia
               AND  A.CodEmpresa      = B.CodEmpresa
               AND  A.IdCotizacion    = B.IdCotizacion
               AND  A.IdetCotizacion  = B.IdetCotizacion
               AND  A.CodCobertWeb    = B.CodCobert
               AND  A.CodCia          = nCodCia
               AND  A.CodEmpresa      = nCodEmpresa
               AND  A.IdCotizacion    = nIdCotizacion
               AND  A.IdetCotizacion  = NVL( nIdetCotizacion , A.IdetCotizacion)
               AND  A.CodGpoCobertWeb = NVL( nCodGpoCobertWeb, A.CodGpoCobertWeb)
               AND  A.CodCobertWeb    = NVL( cCodCobertWeb   , A.CodCobertWeb)
             GROUP BY A.CodGpoCobertWeb;
      --
      CURSOR Coberturas IS
             SELECT C.IdetCotizacion    , C.CodCobert        , C.SumaAsegCobLocal  , C.SumaAsegCobMoneda , C.Tasa           , C.PrimaCobLocal    , 
                    C.PrimaCobMoneda    , C.DeducibleCobLocal, C.DeducibleCobMoneda, C.SalarioMensual    , C.VecesSalario   , C.SumaAsegCalculada,
                    C.Edad_Minima       , C.Edad_Maxima      , C.Edad_Exclusion    , C.SumaAseg_Minima   , C.SumaAseg_Maxima, C.PorcExtraPrimaDet,
                    C.MontoExtraPrimaDet, C.SumaIngresada    , B.OrdenImpresion    , C.DeducibleIngresado, C.CuotaPromedio  , C.PrimaPromedio    ,
                    C.FranquiciaIngresado
             FROM   COTIZACIONES_COBERT_WEB    A
                ,   COTIZACIONES_COBERT_MASTER B
                ,   COTIZACIONES_COBERT_ASEG   C
             WHERE  A.CodCia          = B.CodCia
               AND  A.CodEmpresa      = B.CodEmpresa
               AND  A.IdCotizacion    = B.IdCotizacion
               AND  A.IdetCotizacion  = B.IdetCotizacion
               AND  A.CodCobertWeb    = B.CodCobert
               AND  B.CodCia          = C.CodCia
               AND  B.CodEmpresa      = C.CodEmpresa
               AND  B.IdCotizacion    = C.IdCotizacion
               AND  B.IdetCotizacion  = C.IdetCotizacion
               AND  B.CodCobert       = C.CodCobert
               AND  A.CodCia          = nCodCia
               AND  A.CodEmpresa      = nCodEmpresa
               AND  A.IdCotizacion    = nIdCotizacion
               AND  A.IdetCotizacion  = NVL( nIdetCotizacion , A.IdetCotizacion)
               AND  A.CodGpoCobertWeb = cCodGpoCobertWeb_1
               AND  A.CodCobertWeb    = NVL( cCodCobertWeb   , A.CodCobertWeb)
             ORDER BY A.IdetCotizacion, A.CodGpoCobertWeb, A.CodCobertWeb;
      --
      CURSOR Coberturas_SubGpo IS
             SELECT C.IdetCotizacion    , C.CodCobert        , C.SumaAsegCobLocal  , C.SumaAsegCobMoneda , C.Tasa           , C.PrimaCobLocal    , 
                    C.PrimaCobMoneda    , C.DeducibleCobLocal, C.DeducibleCobMoneda, C.SalarioMensual    , C.VecesSalario   , C.SumaAsegCalculada,
                    C.Edad_Minima       , C.Edad_Maxima      , C.Edad_Exclusion    , C.SumaAseg_Minima   , C.SumaAseg_Maxima, C.PorcExtraPrimaDet,
                    C.MontoExtraPrimaDet, C.SumaIngresada    , B.OrdenImpresion    , C.DeducibleIngresado, C.CuotaPromedio  , C.PrimaPromedio,
                    C.FranquiciaIngresado ---ARH26082024 
             FROM   COTIZACIONES_COBERT_WEB    A
                ,   COTIZACIONES_COBERT_MASTER B
                ,   COTIZACIONES_COBERTURAS   C
             WHERE  A.CodCia         = B.CodCia
               AND  A.CodEmpresa     = B.CodEmpresa
               AND  A.IdCotizacion   = B.IdCotizacion
               AND  A.IdetCotizacion = B.IdetCotizacion
               AND  A.CodCobertWeb   = B.CodCobert
               AND  B.CodCia         = C.CodCia
               AND  B.CodEmpresa     = C.CodEmpresa
               AND  B.IdCotizacion   = C.IdCotizacion
               AND  B.IdetCotizacion = C.IdetCotizacion
               AND  B.CodCobert      = C.CodCobert
               AND  A.CodCia         = nCodCia
               AND  A.CodEmpresa     = nCodEmpresa
               AND  A.IdCotizacion   = nIdCotizacion
               AND  A.IdetCotizacion = NVL( nIdetCotizacion , A.IdetCotizacion)
               AND  CodGpoCobertWeb  = cCodGpoCobertWeb_1
               AND  A.CodCobertWeb   = NVL( cCodCobertWeb   , A.CodCobertWeb)
             ORDER BY A.IdetCotizacion, A.CodGpoCobertWeb, A.CodCobertWeb;
   BEGIN
      SELECT IdTipoSeg , PlanCob , IndAsegModelo
      INTO   cIdTipoSeg, cPlanCob, cIndAsegModelo
      FROM   COTIZACIONES
      WHERE  CodCia       = nCodCia
        AND  CodEmpresa   = nCodEmpresa
        AND  IdCotizacion = nIdCotizacion;
      --
      cResultado := '"xCoberturas": [ ' || CHR(13);
      FOR x IN Grupos LOOP
          IF cCodGpoCobertWeb_1 IS NOT NULL THEN
             cResultado := cResultado || '      },' || CHR(13);
          END IF;
          --
          cResultado         := cResultado || '      { "CODGPOCOBERTWEB": "' || x.CodGpoCobertWeb || '",' || CHR(13);
          cResultado         := cResultado || '        "DESCGPOCOBERTWEB": "' || x.CodGpoCobertWebDesc || '",' || CHR(13);
          cResultado         := cResultado || '        "COBERTURA": [ ' || CHR(13);
          cCodGpoCobertWeb_1 := x.CodGpoCobertWeb;
          cCodCobertWeb_1    := NULL;
          --
          IF NVL(cIndAsegModelo,'N') = 'S' THEN
             FOR y IN Coberturas_SubGpo LOOP
                 cDescCobertWeb := OC_COBERTURAS_DE_SEGUROS.DESCRIPCION_COBERTURA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, y.CodCobert);
                 IF y.CodCobert = 'GF>12' THEN
                    cCobertloca := REPLACE(y.CodCobert,'>', '&'||'gt;');
                 ELSIF y.CodCobert = 'GF<12' THEN
                    cCobertloca := REPLACE(y.CodCobert,'<', '&'||'lt;');
                 ELSE
                    cCobertloca:= y.CodCobert;
                 END IF; 
                 -- 
                 IF cCodCobertWeb_1 IS NOT NULL THEN
                    cResultado := cResultado || '             },' || CHR(13);
                 END IF;
                 cCodCobertWeb_1 := y.CodCobert;
                 --
                 cResultado   := cResultado || '             { "IDETCOTIZACION": '      || y.IdetCotizacion              || ',' || CHR(13);
                 cResultado   := cResultado || '               "CODCOBERTWEB": "'       || cCobertloca                   || '",' || CHR(13);
                 cResultado   := cResultado || '               "DESCCOBERTWEB":"'       || cDescCobertWeb                || '",' || CHR(13);
                 cResultado   := cResultado || '               "SUMAASEGCOBLOCAL": '    || NVL(y.SumaAsegCobLocal, 0)    || ',' || CHR(13);
                 cResultado   := cResultado || '               "SUMAASEGCOBMONEDA": '   || NVL(y.SumaAsegCobMoneda, 0)   || ',' || CHR(13);
                 cResultado   := cResultado || '               "TASA": '                || TO_CHAR(y.Tasa, '99990.099999') || ',' || CHR(13);
                 cResultado   := cResultado || '               "PRIMACOBLOCAL": '       || NVL(y.PrimaCobLocal, 0)       || ',' || CHR(13);
                 cResultado   := cResultado || '               "PRIMACOBMONEDA": '      || NVL(y.PrimaCobMoneda, 0)      || ',' || CHR(13);
                 cResultado   := cResultado || '               "DEDUCIBLECOBLOCAL": '   || NVL(y.DeducibleCobLocal, 0)   || ',' || CHR(13);
                 cResultado   := cResultado || '               "DEDUCIBLECOBMONEDA": '  || NVL(y.DeducibleCobMoneda, 0)  || ',' || CHR(13);
                 cResultado   := cResultado || '               "SALARIOMENSUAL": '      || NVL(y.SalarioMensual, 0)      || ',' || CHR(13);
                 cResultado   := cResultado || '               "VECESSALARIO": '        || y.VecesSalario                || ',' || CHR(13);
                 cResultado   := cResultado || '               "SUMAASEGCALCULADA": '   || NVL(y.SumaAsegCalculada, 0)   || ',' || CHR(13);
                 cResultado   := cResultado || '               "EDAD_MINIMA": '         || y.Edad_Minima                 || ',' || CHR(13);
                 cResultado   := cResultado || '               "EDAD_MAXIMA": '         || y.Edad_Maxima                 || ',' || CHR(13);
                 cResultado   := cResultado || '               "EDAD_EXCLUSION": '      || y.Edad_Exclusion              || ',' || CHR(13);
                 cResultado   := cResultado || '               "SUMAASEG_MINIMA": '     || NVL(y.SumaAseg_Minima, 0)     || ',' || CHR(13);
                 cResultado   := cResultado || '               "SUMAASEG_MAXIMA": '     || NVL(y.SumaAseg_Maxima, 0)     || ',' || CHR(13);
                 cResultado   := cResultado || '               "PORCEXTRAPRIMADET": '   || NVL(y.PorcExtraPrimaDet, 0)   || ',' || CHR(13);
                 cResultado   := cResultado || '               "MONTOEXTRAPRIMADET": '  || NVL(y.MontoExtraPrimaDet, 0)  || ',' || CHR(13);
                 cResultado   := cResultado || '               "SUMAINGRESADA": '       || NVL(y.SumaIngresada, 0)       || ',' || CHR(13);
                 cResultado   := cResultado || '               "ORDENIMPRESION": '      || NVL(y.OrdenImpresion, 0)      || ',' || CHR(13);
                 cResultado   := cResultado || '               "DEDUCIBLEINGRESADO": '  || NVL(y.DeducibleIngresado, 0)  || ',' || CHR(13);
                 cResultado   := cResultado || '               "CUOTAPROMEDIO": '       || NVL(y.CuotaPromedio, 0)       || ',' || CHR(13);
                 cResultado   := cResultado || '               "PRIMAPROMEDIO": '       || NVL(y.PrimaPromedio, 0)       || ',' || CHR(13);
                 cResultado   := cResultado || '               "FRANQUICIAINGRESADO": ' || NVL(y.FranquiciaIngresado, 0);
             END LOOP;
          ELSE
             FOR y IN Coberturas LOOP
                 cDescCobertWeb := OC_COBERTURAS_DE_SEGUROS.DESCRIPCION_COBERTURA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, y.CodCobert);
                 IF y.CodCobert = 'GF>12' THEN
                    cCobertloca := REPLACE(y.CodCobert,'>', '&'||'gt;');
                 ELSIF y.CodCobert = 'GF<12' THEN
                    cCobertloca := REPLACE(y.CodCobert,'<', '&'||'lt;');
                 ELSE
                   cCobertloca:= y.CodCobert;
                 END IF;  
                 -- 
                 IF cCodCobertWeb_1 IS NOT NULL THEN
                    cResultado := cResultado || '             },' || CHR(13);
                 END IF;
                 cCodCobertWeb_1 := y.CodCobert;
                 --
                 cResultado   := cResultado || '             { "IDETCOTIZACION": '      || y.IdetCotizacion              || ',' || CHR(13);
                 cResultado   := cResultado || '               "CODCOBERTWEB": "'       || cCobertloca                   || '",' || CHR(13);
                 cResultado   := cResultado || '               "DESCCOBERTWEB":"'       || cDescCobertWeb                || '",' || CHR(13);
                 cResultado   := cResultado || '               "SUMAASEGCOBLOCAL": '    || NVL(y.SumaAsegCobLocal, 0)    || ',' || CHR(13);
                 cResultado   := cResultado || '               "SUMAASEGCOBMONEDA": '   || NVL(y.SumaAsegCobMoneda, 0)   || ',' || CHR(13);
                 cResultado   := cResultado || '               "TASA": '                || TO_CHAR(y.Tasa, '99990.099999') || ',' || CHR(13);
                 cResultado   := cResultado || '               "PRIMACOBLOCAL": '       || NVL(y.PrimaCobLocal, 0)       || ',' || CHR(13);
                 cResultado   := cResultado || '               "PRIMACOBMONEDA": '      || NVL(y.PrimaCobMoneda, 0)      || ',' || CHR(13);
                 cResultado   := cResultado || '               "DEDUCIBLECOBLOCAL": '   || NVL(y.DeducibleCobLocal, 0)   || ',' || CHR(13);
                 cResultado   := cResultado || '               "DEDUCIBLECOBMONEDA": '  || NVL(y.DeducibleCobMoneda, 0)  || ',' || CHR(13);
                 cResultado   := cResultado || '               "SALARIOMENSUAL": '      || NVL(y.SalarioMensual, 0)      || ',' || CHR(13);
                 cResultado   := cResultado || '               "VECESSALARIO": '        || y.VecesSalario                || ',' || CHR(13);
                 cResultado   := cResultado || '               "SUMAASEGCALCULADA": '   || NVL(y.SumaAsegCalculada, 0)   || ',' || CHR(13);
                 cResultado   := cResultado || '               "EDAD_MINIMA": '         || y.Edad_Minima                 || ',' || CHR(13);
                 cResultado   := cResultado || '               "EDAD_MAXIMA": '         || y.Edad_Maxima                 || ',' || CHR(13);
                 cResultado   := cResultado || '               "EDAD_EXCLUSION": '      || y.Edad_Exclusion              || ',' || CHR(13);
                 cResultado   := cResultado || '               "SUMAASEG_MINIMA": '     || NVL(y.SumaAseg_Minima, 0)     || ',' || CHR(13);
                 cResultado   := cResultado || '               "SUMAASEG_MAXIMA": '     || NVL(y.SumaAseg_Maxima, 0)     || ',' || CHR(13);
                 cResultado   := cResultado || '               "PORCEXTRAPRIMADET": '   || NVL(y.PorcExtraPrimaDet, 0)   || ',' || CHR(13);
                 cResultado   := cResultado || '               "MONTOEXTRAPRIMADET": '  || NVL(y.MontoExtraPrimaDet, 0)  || ',' || CHR(13);
                 cResultado   := cResultado || '               "SUMAINGRESADA": '       || NVL(y.SumaIngresada, 0)       || ',' || CHR(13);
                 cResultado   := cResultado || '               "ORDENIMPRESION": '      || NVL(y.OrdenImpresion, 0)      || ',' || CHR(13);
                 cResultado   := cResultado || '               "DEDUCIBLEINGRESADO": '  || NVL(y.DeducibleIngresado, 0)  || ',' || CHR(13);
                 cResultado   := cResultado || '               "CUOTAPROMEDIO": '       || NVL(y.CuotaPromedio, 0)       || ',' || CHR(13);
                 cResultado   := cResultado || '               "PRIMAPROMEDIO": '       || NVL(y.PrimaPromedio, 0)       || ',' || CHR(13);
                 cResultado   := cResultado || '               "FRANQUICIAINGRESADO": ' || NVL(y.FranquiciaIngresado, 0);
             END LOOP;
          END IF;
          --
          cResultado := cResultado || CHR(13) || '             }' || CHR(13) || '         ]' || CHR(13);
       END LOOP;
       --
       cResultado := cResultado || '      }' || CHR(13) || '   ]';
       RETURN cResultado;
    EXCEPTION
       WHEN OTHERS THEN
          RETURN NULL;
    END COBERTURAS_JSON;

   FUNCTION ACTUALIZAR_COBERTURAS( nCodCia        DOCUMENTOS_JSON.CodCia%TYPE
                                 , nCodEmpresa    DOCUMENTOS_JSON.CodEmpresa%TYPE
                                 , nIdCotizacion  DOCUMENTOS_JSON.IdCotizacion%TYPE
                                 , cJson_Data     DOCUMENTOS_JSON.Json_Data%TYPE ) RETURN CLOB IS
      --
      TYPE RegType IS RECORD ( cCodGpoCobertWeb      VARCHAR2(6)
                             , cDescGpoCobertWeb     VARCHAR2(1000)
                             , nIDetCotizacion       NUMBER(14,0)
                             , cCodCobertWeb         VARCHAR2(6)
                             , nSumaAsegCobLocal     NUMBER(28,2)
                             , nSumaAsegCobMoneda    NUMBER(28,2)
                             , nTasa                 NUMBER(18,6)
                             , nPrimaCobLocal        NUMBER(28,2)
                             , nPrimaCobMoneda       NUMBER(28,2)
                             , nDeducibleCobLocal    NUMBER(28,2)
                             , nDeducibleCobMoneda   NUMBER(28,2)
                             , nSalarioMensual       NUMBER(28,2)
                             , nVecesSalario         NUMBER(10,0)
                             , nSumaAsegCalculada    NUMBER(28,2)
                             , nEdad_Minima          NUMBER(3,0)
                             , nEdad_Maxima          NUMBER(3,0)
                             , nEdad_Exclusion       NUMBER(3,0)
                             , nSumaAseg_Minima      NUMBER(28,2)
                             , nSumaAseg_Maxima      NUMBER(28,2)
                             , nPorcExtraPrimaDet    NUMBER(9,6)
                             , nMontoExtraPrimaDet   NUMBER(18,2)
                             , nSumaIngresada        NUMBER(28,2)
                             , nOrdenImpresion       NUMBER(4,0)
                             , nDeducibleIngresado   NUMBER(28,2)
                             , nCuotaPromedio        NUMBER(18,6)
                             , nPrimaPromedio        NUMBER(28,2)
                             , nFranquiciaIngresado  NUMBER(18,2)
                             , nMontoDiario          NUMBER(18,2)
                             , nDias_cal             NUMBER(5,0) );
      --
      rRegEnt              RegType; -- Registro de Entrada
      cJson                CLOB;
      cTempPrima           CLOB;
      cTempCobert          CLOB;
      nTotRegs             NUMBER := 0;
      nIDetCotizacion      NUMBER;
      --
      --Variables para información de la cotización
      cIdTipoSeg           SICAS_OC.COTIZACIONES.IdTipoSeg%TYPE;
      cPlanCob             SICAS_OC.COTIZACIONES.PlanCob%TYPE;
      cCodPlanPago         SICAS_OC.COTIZACIONES.CodPlanPago%TYPE;
      cIndAsegModelo       SICAS_OC.COTIZACIONES.IndAsegModelo%TYPE;
      cIndListadoAseg      SICAS_OC.COTIZACIONES.IndListadoAseg%TYPE;
      --
      --Variables para actualizar el Factor de Ajuste
      nFactorAjuste        SICAS_OC.COTIZACIONES.FactorAjuste%TYPE;
      cEscala              FACTOR_ESCALA_PO.Escala%TYPE;
      xFactorEscalaPO      XMLTYPE;
      --
      --Variables para salida de JSON de Prima
      nPrimaCotLocal       SICAS_OC.COTIZACIONES.PrimaCotLocal%TYPE;
      nPrimaCotMoneda      SICAS_OC.COTIZACIONES.PrimaCotMoneda%TYPE;
      nGastosExpedicion    SICAS_OC.COTIZACIONES.GastosExpedicion%TYPE;
      cExiste              VARCHAR2(1);
      nMontoIva            NUMBER(14,2);
      --
      CURSOR cInformacion IS
             SELECT b.*
             FROM   DOCUMENTOS_JSON a
                ,   JSON_TABLE( a.Json_Data, '$[*]'
                                COLUMNS ( NESTED PATH '$.gGpoCobert[*]'
                                          COLUMNS ( cCodGpoCobertWeb   VARCHAR2(6)     PATH '$.cCodGpoCobertWeb'
                                                  , cDescGpoCobertWeb  VARCHAR2(1000)  PATH '$.cDescGpoCobertWeb'
                                                  , NESTED PATH '$.gCobertura[*]'
                                                    COLUMNS ( nIDetCotizacion       NUMBER(14,0)  PATH '$.nIDetCotizacion'
                                                            , cCodCobertWeb         VARCHAR2(6)   PATH '$.cCodCobertWeb'
                                                            , nSumaAsegCobLocal     NUMBER(28,2)  PATH '$.nSumaAsegCobLocal'
                                                            , nSumaAsegCobMoneda    NUMBER(28,2)  PATH '$.nSumaAsegCobMoneda'
                                                            , nTasa                 NUMBER(18,6)  PATH '$.nTasa'
                                                            , nPrimaCobLocal        NUMBER(28,2)  PATH '$.nPrimaCobLocal'
                                                            , nPrimaCobMoneda       NUMBER(28,2)  PATH '$.nPrimaCobMoneda'
                                                            , nDeducibleCobLocal    NUMBER(28,2)  PATH '$.nDeducibleCobLocal'
                                                            , nDeducibleCobMoneda   NUMBER(28,2)  PATH '$.nDeducibleCobMoneda'
                                                            , nSalarioMensual       NUMBER(28,2)  PATH '$.nSalarioMensual'
                                                            , nVecesSalario         NUMBER(10,0)  PATH '$.nVecesSalario'
                                                            , nSumaAsegCalculada    NUMBER(28,2)  PATH '$.nSumaAsegCalculada'
                                                            , nEdad_Minima          NUMBER(3,0)   PATH '$.nEdad_Minima'
                                                            , nEdad_Maxima          NUMBER(3,0)   PATH '$.nEdad_Maxima'
                                                            , nEdad_Exclusion       NUMBER(3,0)   PATH '$.nEdad_Exclusion'
                                                            , nSumaAseg_Minima      NUMBER(28,2)  PATH '$.nSumaAseg_Minima'
                                                            , nSumaAseg_Maxima      NUMBER(28,2)  PATH '$.nSumaAseg_Maxima'
                                                            , nPorcExtraPrimaDet    NUMBER(9,6)   PATH '$.nPorcExtraPrimaDet'
                                                            , nMontoExtraPrimaDet   NUMBER(18,2)  PATH '$.nMontoExtraPrimaDet'
                                                            , nSumaIngresada        NUMBER(28,2)  PATH '$.nSumaIngresada'
                                                            , nOrdenImpresion       NUMBER(4,0)   PATH '$.nOrdenImpresion'
                                                            , nDeducibleIngresado   NUMBER(28,2)  PATH '$.nDeducibleIngresado'
                                                            , nCuotaPromedio        NUMBER(18,6)  PATH '$.nCuotaPromedio'
                                                            , nPrimaPromedio        NUMBER(28,2)  PATH '$.nPrimaPromedio'
                                                            , nFranquiciaIngresado  NUMBER(18,2)  PATH '$.nFranquiciaIngresado'
                                                            , nMontoDiario          NUMBER(18,2)  PATH '$.nMontoDiario'
                                                            , nDias_cal             NUMBER(5,0)   PATH '$.nDias_cal'
                                                            )
                                                  )
                                        )
                              ) b
             WHERE  CodCia       = nCodCia
               AND  CodEmpresa   = nCodEmpresa
               AND  IdCotizacion = nIdCotizacion;
      -- 
      CURSOR Cotizaciones IS
             SELECT DISTINCT IdetCotizacion
             FROM   COTIZACIONES_COBERT_WEB_TEMP
             WHERE  CodCia       = nCodCia
               AND  CodEmpresa   = nCodEmpresa
               AND  IdCotizacion = nIdCotizacion;
      --
      CURSOR Cotizacion_Coberturas IS
             SELECT IDetCotizacion   , CodGpoCobertWeb    , CodCobertWeb     , SumaAsegCobLocal  , SumaAsegCobMoneda, Tasa          , PrimaCobLocal     , PrimaCobMoneda,
                    DeducibleCobLocal, DeducibleCobMoneda , SalarioMensual   , VecesSalario      , SumaAsegCalculada, Edad_Minima   , Edad_Maxima       , Edad_Exclusion,
                    Sumaaseg_Minima  ,  Sumaaseg_Maxima   , PorcExtraprimaDet, MontoExtraprimaDet, SumaIngresada    , OrdenImpresion, DeducibleIngresado, CuotaPromedio ,
                    PrimaPromedio    , FranquiciaIngresado, MontoDiario      , Dias_cal
             FROM   COTIZACIONES_COBERT_WEB_TEMP
             WHERE  CodCia       = nCodCia
               AND  CodEmpresa   = nCodEmpresa
               AND  IdCotizacion = nIdCotizacion;
      --
      CURSOR Cotizacion_Asegurado IS
             SELECT DISTINCT CodCia, CodEmpresa, IdCotizacion, IDetCotizacion, IdAsegurado
             FROM   COTIZACIONES_ASEG
             WHERE  CodCia         = nCodCia
               AND  CodEmpresa     = nCodEmpresa
               AND  IdCotizacion   = nIdCotizacion
               AND  IDetCotizacion = nIDetCotizacion;
      --
      CURSOR Cotizacion_SubGrupo IS
             SELECT DISTINCT CodCia, CodEmpresa, IdCotizacion, IDetCotizacion
             FROM   COTIZACIONES_DETALLE
             WHERE  CodCia         = nCodCia
               AND  CodEmpresa     = nCodEmpresa
               AND  IdCotizacion   = nIdCotizacion
               AND  IDetCotizacion = nIDetCotizacion;
   BEGIN
      SELECT COUNT(*)
      INTO   nTotRegs
      FROM   DOCUMENTOS_JSON
      WHERE  CodCia       = nCodCia
        AND  CodEmpresa   = nCodEmpresa
        AND  IdCotizacion = nIdCotizacion;
      --
      IF nTotRegs > 0 THEN
         DELETE DOCUMENTOS_JSON
         WHERE  CodCia       = nCodCia
           AND  CodEmpresa   = nCodEmpresa
           AND  IdCotizacion = nIdCotizacion;
      END IF;
      --
      INSERT INTO DOCUMENTOS_JSON (CodCia, CodEmpresa, IdCotizacion, json_data)
      VALUES (nCodCia, nCodEmpresa, nIdCotizacion, cJson_Data);
      --
      DELETE COTIZACIONES_COBERT_WEB_TEMP;
      --
      OPEN cInformacion;
      LOOP
         FETCH cInformacion INTO rRegEnt;
         EXIT WHEN cInformacion%NOTFOUND;
         --
         nIDetCotizacion := rRegEnt.nIDetCotizacion;
         --
         IF rRegEnt.cCodCobertWeb = 'GF' || chr(38) || 'lt;12' THEN
            rRegEnt.cCodCobertWeb := 'GF<12';
         ELSIF rRegEnt.cCodCobertWeb = 'GF' || chr(38) || 'gt;12' THEN
            rRegEnt.cCodCobertWeb := 'GF>12';  
         END IF;
         --
         INSERT INTO COTIZACIONES_COBERT_WEB_TEMP
                ( CodCia            , CodEmpresa        , IdCotizacion   , IdetCotizacion   , CodGpoCobertWeb    , CodCobertWeb     ,
                  SumaAsegCobLocal  , SumaAsegCobMoneda , Tasa           , PrimaCoblocal    , PrimaCobMoneda     , DeducibleCobLocal,
                  DeducibleCobMoneda, SalarioMensual    , VecesSalario   , SumaAsegCalculada, Edad_Minima        , Edad_Maxima      ,
                  Edad_Exclusion    , SumaAseg_Minima   , SumaAseg_Maxima, PorcExtraPrimaDet, MontoExtraPrimaDet , SumaIngresada    ,
                  OrdenImpresion    , DeducibleIngresado, CuotaPromedio  , PrimaPromedio    , FranquiciaIngresado, MontoDiario      ,
                  Dias_cal )
         VALUES ( nCodCia                    , nCodEmpresa                , nIdCotizacion           , rRegEnt.nIdetCotizacion   , rRegEnt.cCodGpoCobertWeb    , rRegEnt.cCodCobertWeb     ,
                  rRegEnt.nSumaAsegCobLocal  , rRegEnt.nSumaAsegCobMoneda , rRegEnt.nTasa           , rRegEnt.nPrimaCoblocal    , rRegEnt.nPrimaCobMoneda     , rRegEnt.nDeducibleCobLocal,
                  rRegEnt.nDeducibleCobMoneda, rRegEnt.nSalarioMensual    , rRegEnt.nVecesSalario   , rRegEnt.nSumaAsegCalculada, rRegEnt.nEdad_Minima        , rRegEnt.nEdad_Maxima      ,
                  rRegEnt.nEdad_Exclusion    , rRegEnt.nSumaAseg_Minima   , rRegEnt.nSumaAseg_Maxima, rRegEnt.nPorcExtraPrimaDet, rRegEnt.nMontoExtraPrimaDet , rRegEnt.nSumaIngresada    ,
                  rRegEnt.nOrdenImpresion    , rRegEnt.nDeducibleIngresado, rRegEnt.nCuotaPromedio  , rRegEnt.nPrimaPromedio    , rRegEnt.nFranquiciaIngresado, rRegEnt.nMontoDiario      ,
                  rRegEnt.nDias_cal );
      END LOOP;
      CLOSE cInformacion;
      --
      BEGIN
         SELECT IdTipoSeg , PlanCob , CodPlanPago , IndAsegModelo , IndListadoAseg
         INTO   cIdTipoSeg, cPlanCob, cCodPlanPago, cIndAsegModelo, cIndListadoAseg
         FROM   COTIZACIONES
         WHERE  CodCia       = nCodCia
           AND  CodEmpresa   = nCodEmpresa
           AND  IdCotizacion = nIdCotizacion;
      END;
      --
      --Elimino las coberturas a nivel cotización
      FOR x IN Cotizaciones LOOP
          DELETE COTIZACIONES_COBERT_MASTER
          WHERE  CodCia         = nCodCia
            AND  CodEmpresa     = nCodEmpresa
            AND  IdCotizacion   = nIdCotizacion
            AND  IdetCotizacion = x.IdetCotizacion;
          --
          IF NVL(cIndAsegModelo, 'N') = 'S' THEN
             DELETE COTIZACIONES_COBERTURAS
             WHERE  CodCia         = nCodCia
               AND  CodEmpresa     = nCodEmpresa
               AND  IdCotizacion   = nIdCotizacion
               AND  IdetCotizacion = x.IdetCotizacion;
          ELSE
             DELETE COTIZACIONES_COBERT_ASEG
             WHERE  CodCia         = nCodCia
               AND  CodEmpresa     = nCodEmpresa
               AND  IdCotizacion   = nIdCotizacion
               AND  IdetCotizacion = x.IdetCotizacion;
          END IF;
      END LOOP;
      --
      -- ACTUALIZA FACTOR DE AJUSTE PO ANTES DE CARGAR COBERTURAS
      FOR x IN Cotizacion_Coberturas LOOP
          IF OC_FACTOR_ESCALA_PO.EXISTE_FACTOR_ESCALA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob , x.CodCobertWeb) = 'S' THEN
             cEscala := OC_FACTOR_ESCALA_PO.ESCALA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob , x.CodCobertWeb);
             IF cEscala != 'X' THEN 
                nFactorAjuste := OC_FACTOR_ESCALA_PO.FACTOR_ESCALA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob , x.CodCobertWeb , cEscala);
             END IF;
          END IF;
          --
          IF nFactorAjuste != 1 THEN 
             SELECT XMLROOT(XMLELEMENT("DATA",
                            XMLELEMENT("FactorAjuste",nFactorAjuste)),
                    VERSION '1.0" encoding="UTF-8')
             INTO   xFactorEscalaPO
             FROM   DUAL;
             --
             -- MASP Servicios Emisión Masiva Vida   03/04/2025
             --      Se rehabilita el parámetro de nIDetCotizacion para afectar unicamente al Subgrupo necesario y no a todos los Subgrupos,
             --      para este caso se envía NULL para que afecte a todos los Subgrupos ya que así estaba originalmente
             GENERALES_PLATAFORMA_DIGITAL.RECIBE_GENERALES_COTIZACION(nCodCia, nCodEmpresa, nIdCotizacion, NULL, xFactorEscalaPO);
          END IF;
          IF x.CodCobertWeb = 'GF<12' OR x.CodCobertWeb = 'GF>12'  THEN
              UPDATE COTIZACIONES_DETALLE
              SET    EDADLIMITE = x.Edad_Maxima
              WHERE  CodCia       = nCodCia
                AND  CodEmpresa   = nCodEmpresa
                AND  IdCotizacion = nIdCotizacion;
          END IF;
          --
          IF x.CodCobertWeb = 'RDH' OR x.CodCobertWeb = 'INCTPA'  THEN
             GT_COTIZACIONES_CLAUSULAS.COTIZACION_WEB_CLAUSULAS(nCodCia, nCodEmpresa, nIdCotizacion, x.CodCobertWeb, x.MontoDiario, x.SumaAsegCobLocal);
          END IF; 
      END LOOP;
      --
      IF NVL(cIndAsegModelo, 'N') = 'S' THEN
         FOR i IN Cotizacion_SubGrupo LOOP
             FOR x IN Cotizacion_Coberturas LOOP
                 GT_COTIZACIONES_COBERTURAS.CARGAR_COBERTURAS( i.CodCia                , i.CodEmpresa              , cIdTipoSeg                  , cPlanCob                  , i.IdCotizacion             ,  
                                                               i.IDetCotizacion        , 0                         , x.CodCobertWeb              , NVL(x.SumaAsegCalculada,0), NVL(x.SalarioMensual    ,0),
                                                               NVL(x.VecesSalario   ,0), NVL(x.Edad_Minima      ,0), NVL(x.Edad_Maxima        ,0), NVL(x.Edad_Exclusion   ,0), NVL(x.SumaAseg_Minima   ,0),
                                                               NVL(x.SumaAseg_Maxima,0), NVL(x.PorcExtraPrimaDet,0), NVL(x.MontoExtraprimaDet ,0), NVL(x.SumaIngresada    ,0), NVL(x.DeducibleIngresado,0),
                                                               NVL(x.CuotaPromedio  ,0), NVL(x.PrimaPromedio    ,0), NVL(x.FranquiciaIngresado,0), NVL(x.MontoDiario      ,0), NVL(x.Dias_cal,0));
             END LOOP;                                   
             GT_COTIZACIONES_DETALLE.ACTUALIZAR_VALORES(i.CodCia, i.CodEmpresa, i.IdCotizacion, i.IDetCotizacion);  
          END LOOP;   
      ELSE
         FOR i IN Cotizacion_Asegurado LOOP
             FOR x IN Cotizacion_Coberturas LOOP
                 GT_COTIZACIONES_COBERTURAS.CARGAR_COBERTURAS( i.CodCia                , i.CodEmpresa              , cIdTipoSeg                  , cPlanCob                  , i.IdCotizacion             ,  
                                                               i.IDetCotizacion        , i.IdAsegurado             , x.CodCobertWeb              , NVL(x.SumaAsegCalculada,0), NVL(x.SalarioMensual    ,0),
                                                               NVL(x.VecesSalario   ,0), NVL(x.Edad_Minima      ,0), NVL(x.Edad_Maxima        ,0), NVL(x.Edad_Exclusion   ,0), NVL(x.SumaAseg_Minima   ,0),
                                                               NVL(x.SumaAseg_Maxima,0), NVL(x.PorcExtraPrimaDet,0), NVL(x.MontoExtraprimaDet ,0), NVL(x.SumaIngresada    ,0), NVL(x.DeducibleIngresado,0),
                                                               NVL(x.CuotaPromedio  ,0), NVL(x.PrimaPromedio    ,0), NVL(x.FranquiciaIngresado,0), NVL(x.MontoDiario      ,0), NVL(x.Dias_cal,0));
             END LOOP;
             GT_COTIZACIONES_ASEG.ACTUALIZAR_VALORES(i.CodCia, i.CodEmpresa, i.IdCotizacion, i.IDetCotizacion, i.IdAsegurado);
             GT_COTIZACIONES_DETALLE.ACTUALIZAR_VALORES(i.CodCia, i.CodEmpresa, i.IdCotizacion, i.IDetCotizacion);  
         END LOOP;
      END IF;      
      --
      FOR x IN Cotizacion_Coberturas LOOP
          BEGIN
             GT_COTIZACIONES_COBERT_MASTER.CARGAR_COBERTURAS( nCodCia                 , nCodEmpresa               , cIdTipoSeg                  , cPlanCob                  , nIdCotizacion             ,
                                                              x.IdetCotizacion        , NULL                      , x.CodCobertWeb              , NVL(x.SumaAsegCalculada,0), NVL(x.SalarioMensual    ,0),
                                                              NVL(x.VecesSalario   ,0), NVL(x.Edad_Minima      ,0), NVL(x.Edad_Maxima        ,0), NVL(x.Edad_Exclusion   ,0), NVL(x.SumaAseg_Minima   ,0),
                                                              NVL(x.SumaAseg_Maxima,0), NVL(x.PorcExtraPrimaDet,0), NVL(x.MontoExtraprimaDet ,0), NVL(x.SumaIngresada    ,0), NVL(x.DeducibleIngresado,0),
                                                              NVL(x.CuotaPromedio  ,0), NVL(x.PrimaPromedio    ,0), NVL(x.FranquiciaIngresado,0), NVL(x.MontoDiario      ,0), NVL(x.Dias_cal          ,0));
          EXCEPTION
          WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR(-20225, 'ERROR ERROR: ' || SQLERRM);
          END;
       END LOOP;      
       --
       GENERALES_PLATAFORMA_DIGITAL.RECALCULAR_COTIZACION(nCodCia, nCodEmpresa, nIdCotizacion, cIdTipoSeg, cPlanCob, 'N', 'N', 'S');
       --
       --Preparo Información para salida JSON de Prima
       BEGIN
          SELECT PrimaCotLocal , PrimaCotMoneda
          INTO   nPrimaCotLocal, nPrimaCotMoneda
          FROM   COTIZACIONES
          WHERE  CodCia        = nCodCia
            AND  CodEmpresa    = nCodEmpresa
            AND  IdCotizacion  = nIdCotizacion;
       END;
       --
       BEGIN
          SELECT DECODE(NVL(c.GastosExpedicion,0), 0, NVL(cc.MontoConcepto,0), NVL(c.GastosExpedicion,0))
          INTO   nGastosExpedicion
          FROM   COTIZACIONES               c
             ,   PLAN_DE_PAGOS              p
             ,   CONCEPTOS_PLAN_DE_PAGOS   cp
             ,   CATALOGO_CONCEPTOS_RANGOS cc  
          WHERE  c.CodCia               = nCodCia
            AND  c.CodEmpresa           = nCodEmpresa
            AND  c.IdCotizacion         = nIdCotizacion 
            AND  c.CodCia               = p.CodCia
            AND  c.CodEmpresa           = p.CodEmpresa
            AND  c.CodPlanPago          = p.CodPlanPago
            AND  p.CodCia               = cp.CodCia
            AND  p.CodEmpresa           = cp.CodEmpresa
            AND  p.CodPlanPago          = cp.CodPlanPago
            AND  cp.CodCpto             = 'DEREMI'
            AND  CP.CodCia              = cc.CodCia
            AND  cp.CodEmpresa          = cc.CodEmpresa 
            AND  cp.CodCpto             = cc.CodConcepto
            AND  c.IdTipoSeg            = cc.IdTipoSeg
            AND  c.Cod_Moneda           = cc.CodMoneda
            AND  c.PrimaCotLocal  BETWEEN cc.RangoInicial(+) AND cc.RangoFinal(+);
       EXCEPTION
       WHEN NO_DATA_FOUND THEN 
            BEGIN
               SELECT NVL(GastosExpedicion,0)
               INTO   nGastosExpedicion
               FROM   COTIZACIONES
               WHERE  CodCia        = nCodCia
                 AND  CodEmpresa    = nCodEmpresa
                 AND  IdCotizacion  = nIdCotizacion;
            END;
       END;
       --
       BEGIN
          SELECT 'S'
          INTO   cExiste
          FROM   PLAN_DE_PAGOS           p
             ,   CONCEPTOS_PLAN_DE_PAGOS c
             ,   RAMOS_CONCEPTOS_PLAN    r
          WHERE  c.CodCia         = nCodCia
            AND  c.CodEmpresa     = nCodEmpresa
            AND  c.CodPlanPago    = cCodPlanPago
            AND  c.CodCpto        = 'IVASIN'
            AND  r.IdTipoSeg      = cIdTipoSeg
            AND  p.CodCia         = c.CodCia
            AND  p.CodEmpresa     = c.CodEmpresa
            AND  p.CodPlanPago    = c.CodPlanPago
            AND  c.CodCia         = r.CodCia
            AND  c.CodEmpresa     = r.CodEmpresa
            AND  c.CodPlanPago    = r.CodPlanPago
            AND  c.CodCpto        = r.CodCpto;
       EXCEPTION 
       WHEN NO_DATA_FOUND THEN 
            cExiste := 'N';
       WHEN TOO_MANY_ROWS THEN
            cExiste := 'S';
       END;
       --
       IF cExiste = 'S' THEN
          nMontoIva   := (nPrimaCotLocal + nGastosExpedicion) * 0.16;
       ELSE
          nMontoIva   := 0;
       END IF;      
       --
       cTempPrima := '"xPrima": { "PRIMALOCAL": ' || NVL(nPrimaCotLocal,0) || ',
                               "PRIMAMONEDAEXT": ' || NVL(nPrimaCotMoneda,0) || ',
                               "GASTOSEXPEDICION": ' || NVL(nGastosExpedicion,0) || ',
                               "MONTOIVA": ' || NVL(nMontoIva,0) || ' },';

       cTempCobert := COBERTURAS_JSON( nCodCia, nCodEmpresa, nIdCotizacion, NULL, NULL, NULL );
       --
       cJson := '{' || CHR(13) || cTempPrima || CHR(13) || cTempCobert || CHR(13) || '}';
       --
      RETURN cJson;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL REGISTRAR ACTUALIZAR_COBERTURAS: ' || nIdCotizacion || ' - ' || SQLERRM);
   END ACTUALIZAR_COBERTURAS;
   --
   FUNCTION CONSULTAR_COBERTURAS( nCodCia          COTIZACIONES_COBERT_WEB.CodCia%TYPE
                                , nCodEmpresa      COTIZACIONES_COBERT_WEB.CodEmpresa%TYPE
                                , nIdCotizacion    COTIZACIONES_COBERT_WEB.IdCotizacion%TYPE
                                , nIDetCotizacion  COTIZACIONES_COBERT_WEB.IdetCotizacion%TYPE ) RETURN CLOB IS
      cResultado           CLOB;
      cCodGpoCobertWeb_1   COTIZACIONES_COBERT_WEB.CodGpoCobertWeb%TYPE;
      cCodCobertWeb_1      COTIZACIONES_COBERTURAS.CodCobert%TYPE;
      cIdTipoSeg            COTIZACIONES.IdTipoSeg%TYPE;
      cPlanCob              COTIZACIONES.PlanCob%TYPE;
      cDescCobertWeb        VARCHAR2(500);
      cCobertwebl           VARCHAR2(200);
      nIDetCotizacion2      COTIZACIONES_COBERT_WEB.IDetCotizacion%TYPE;
      cCodCobertWeb         COTIZACIONES_COBERT_WEB.CodCobertWeb%TYPE;
      nSumaAsegCobLocal     COTIZACIONES_COBERT_WEB.SumaAsegCobLocal%TYPE;
      nSumaAsegCobMoneda    COTIZACIONES_COBERT_WEB.SumaAsegCobMoneda%TYPE;
      nTasa                 COTIZACIONES_COBERT_WEB.Tasa%TYPE;
      nPrimaCobLocal        COTIZACIONES_COBERT_WEB.PrimaCobLocal%TYPE;
      nPrimaCobMoneda       COTIZACIONES_COBERT_WEB.PrimaCobMoneda%TYPE;
      nDeducibleCobLocal    COTIZACIONES_COBERT_WEB.DeducibleCobLocal%TYPE;
      nDeducibleCobMoneda   COTIZACIONES_COBERT_WEB.DeducibleCobMoneda%TYPE;
      nSalarioMensual       COTIZACIONES_COBERT_WEB.SalarioMensual%TYPE;
      nVecesSalario         COTIZACIONES_COBERT_WEB.VecesSalario%TYPE;
      nSumaAsegCalculada    COTIZACIONES_COBERT_WEB.SumaAsegCalculada%TYPE;
      nEdad_Minima          COTIZACIONES_COBERT_WEB.Edad_Minima%TYPE;
      nEdad_Maxima          COTIZACIONES_COBERT_WEB.Edad_Maxima%TYPE;
      nEdad_Exclusion       COTIZACIONES_COBERT_WEB.Edad_Exclusion%TYPE;
      nSumaAseg_Minima      COTIZACIONES_COBERT_WEB.SumaAseg_Minima%TYPE;
      nSumaAseg_Maxima      COTIZACIONES_COBERT_WEB.SumaAseg_Maxima%TYPE;
      nPorcExtraPrimaDet    COTIZACIONES_COBERT_WEB.PorcExtraPrimaDet%TYPE;
      nMontoExtraPrimaDet   COTIZACIONES_COBERT_WEB.MontoExtraPrimaDet%TYPE;
      nSumaIngresada        COTIZACIONES_COBERT_WEB.SumaIngresada%TYPE;
      nOrdenImpresion       COTIZACIONES_COBERT_WEB.OrdenImpresion%TYPE;
      nDeducibleIngresado   COTIZACIONES_COBERT_WEB.DeducibleIngresado%TYPE;
      nCuotaPromedio        COTIZACIONES_COBERT_WEB.CuotaPromedio%TYPE;
      nPrimaPromedio        COTIZACIONES_COBERT_WEB.PrimaPromedio%TYPE;
      nFranquiciaIngresado  COTIZACIONES_COBERT_WEB.FranquiciaIngresado%TYPE;
      nCodGpoCobertWeb      COTIZACIONES_COBERT_WEB.CodGpoCobertWeb%TYPE;
      cCodGpoCobertWebDesc  VARCHAR2(500);
      --
      CURSOR c_Grupos IS
             SELECT CodGpoCobertWeb, OC_VALORES_DE_LISTAS.BUSCA_LVALOR( 'GPOCOBWEB', CodGpoCobertWeb ) CodGpoCobertWebDesc
             FROM   COTIZACIONES_COBERT_WEB
             WHERE  CodCia         = nCodCia
               AND  CodEmpresa     = nCodEmpresa
               AND  IdCotizacion   = nIdCotizacion
               AND  IdetCotizacion = NVL( nIdetCotizacion , IdetCotizacion )
         GROUP BY CodGpoCobertWeb;
      --
      CURSOR c_Coberturas IS
             SELECT IDetCotizacion    , CodCobertWeb     , SumaAsegCobLocal  , SumaAsegCobMoneda , Tasa           , PrimaCobLocal    , 
                    PrimaCobMoneda    , DeducibleCobLocal, DeducibleCobMoneda, SalarioMensual    , VecesSalario   , SumaAsegCalculada,
                    Edad_Minima       , Edad_Maxima      , Edad_Exclusion    , SumaAseg_Minima   , SumaAseg_Maxima, PorcExtraPrimaDet,
                    MontoExtraPrimaDet, SumaIngresada    , OrdenImpresion    , DeducibleIngresado, CuotaPromedio  , PrimaPromedio    , FranquiciaIngresado
             FROM   COTIZACIONES_COBERT_WEB
             WHERE  CodCia          = nCodCia
               AND  CodEmpresa      = nCodEmpresa
               AND  IdCotizacion    = nIdCotizacion
               AND  IDetCotizacion  = NVL( nIDetCotizacion , IDetCotizacion )
               AND  CodGpoCobertWeb = nCodGpoCobertWeb
             ORDER BY IdetCotizacion, CodCobertWeb;
   BEGIN
      SELECT IdTipoSeg, PlanCob
      INTO   cIdTipoSeg, cPlanCob
      FROM   COTIZACIONES
      WHERE  CodCia       = nCodCia
        AND  CodEmpresa   = nCodEmpresa
        AND  IdCotizacion = nIdCotizacion;
      --
      cResultado := '[ ' || CHR(13);
      --
      OPEN c_Grupos;
      LOOP
         FETCH c_Grupos INTO nCodGpoCobertWeb, cCodGpoCobertWebDesc;
         EXIT WHEN c_Grupos%NOTFOUND;
            IF cCodGpoCobertWeb_1 IS NOT NULL THEN
               cResultado := cResultado || '},' || CHR(13);
            END IF;
            --
            cResultado         := cResultado || '{ "CODGPOCOBERTWEB": "' || nCodGpoCobertWeb || '",' || CHR(13);
            cResultado         := cResultado || '"DESCGPOCOBERTWEB": "' || cCodGpoCobertWebDesc || '",' || CHR(13);
            cResultado         := cResultado || '"COBERTURA": [ ' || CHR(13);
            cCodGpoCobertWeb_1 := nCodGpoCobertWeb;
            cCodCobertWeb_1    := NULL;
            --
            OPEN c_Coberturas;
            LOOP
               FETCH c_Coberturas INTO nIDetCotizacion2   , cCodCobertWeb      , nSumaAsegCobLocal, nSumaAsegCobMoneda, nTasa              , nPrimaCobLocal, nPrimaCobMoneda,
                                       nDeducibleCobLocal , nDeducibleCobMoneda, nSalarioMensual  , nVecesSalario     , nSumaAsegCalculada , nEdad_Minima  , nEdad_Maxima   ,
                                       nEdad_Exclusion    , nSumaAseg_Minima   , nSumaAseg_Maxima , nPorcExtraPrimaDet, nMontoExtraPrimaDet, nSumaIngresada, nOrdenImpresion,
                                       nDeducibleIngresado, nCuotaPromedio     , nPrimaPromedio   , nFranquiciaIngresado;
               EXIT WHEN c_Coberturas%NOTFOUND;
               --
               IF cCodCobertWeb_1 IS NOT NULL THEN
                  cResultado := cResultado || '},' || CHR(13);
               END IF;
               --
               cCodCobertWeb_1 := cCodCobertWeb;
               cDescCobertWeb  := OC_COBERTURAS_DE_SEGUROS.DESCRIPCION_COBERTURA(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cCodCobertWeb);
               --
               IF cCodCobertWeb = 'GF>12' THEN
                  cCobertwebl := REPLACE(cCodCobertWeb,'>', '&'||'gt;');
               ELSIF cCodCobertWeb = 'GF<12' THEN
                  cCobertwebl := REPLACE(cCodCobertWeb,'<', '&'||'lt;');
               ELSE
                  cCobertwebl:= cCodCobertWeb;
               END IF;
               --
               cResultado   := cResultado || '{ "IDETCOTIZACION": '      || nIDetCotizacion2              || ',' || CHR(13);
               cResultado   := cResultado || '"CODCOBERTWEB": "'       || cCobertwebl                   || '",' || CHR(13);
               cResultado   := cResultado || '"DESCCOBERTWEB":"'       || cDescCobertWeb                || '",' || CHR(13);
               cResultado   := cResultado || '"SUMAASEGCOBLOCAL": '    || NVL(nSumaAsegCobLocal, 0)    || ',' || CHR(13);
               cResultado   := cResultado || '"SUMAASEGCOBMONEDA": '   || NVL(nSumaAsegCobMoneda, 0)   || ',' || CHR(13);
               cResultado   := cResultado || '"TASA": '                || TO_CHAR(nTasa, '99990.099999') || ',' || CHR(13);
               cResultado   := cResultado || '"PRIMACOBLOCAL": '       || NVL(nPrimaCobLocal, 0)       || ',' || CHR(13);
               cResultado   := cResultado || '"PRIMACOBMONEDA": '      || NVL(nPrimaCobMoneda, 0)      || ',' || CHR(13);
               cResultado   := cResultado || '"DEDUCIBLECOBLOCAL": '   || NVL(nDeducibleCobLocal, 0)   || ',' || CHR(13);
               cResultado   := cResultado || '"DEDUCIBLECOBMONEDA": '  || NVL(nDeducibleCobMoneda, 0)  || ',' || CHR(13);
               cResultado   := cResultado || '"SALARIOMENSUAL": '      || NVL(nSalarioMensual, 0)      || ',' || CHR(13);
               cResultado   := cResultado || '"VECESSALARIO": '        || nVecesSalario                || ',' || CHR(13);
               cResultado   := cResultado || '"SUMAASEGCALCULADA": '   || NVL(nSumaAsegCalculada, 0)   || ',' || CHR(13);
               cResultado   := cResultado || '"EDAD_MINIMA": '         || nEdad_Minima                 || ',' || CHR(13);
               cResultado   := cResultado || '"EDAD_MAXIMA": '         || nEdad_Maxima                 || ',' || CHR(13);
               cResultado   := cResultado || '"EDAD_EXCLUSION": '      || nEdad_Exclusion              || ',' || CHR(13);
               cResultado   := cResultado || '"SUMAASEG_MINIMA": '     || NVL(nSumaAseg_Minima, 0)     || ',' || CHR(13);
               cResultado   := cResultado || '"SUMAASEG_MAXIMA": '     || NVL(nSumaAseg_Maxima, 0)     || ',' || CHR(13);
               cResultado   := cResultado || '"PORCEXTRAPRIMADET": '   || NVL(nPorcExtraPrimaDet, 0)   || ',' || CHR(13);
               cResultado   := cResultado || '"MONTOEXTRAPRIMADET": '  || NVL(nMontoExtraPrimaDet, 0)  || ',' || CHR(13);
               cResultado   := cResultado || '"SUMAINGRESADA": '       || NVL(nSumaIngresada, 0)       || ',' || CHR(13);
               cResultado   := cResultado || '"ORDENIMPRESION": '      || NVL(nOrdenImpresion, 0)      || ',' || CHR(13);
               cResultado   := cResultado || '"DEDUCIBLEINGRESADO": '  || NVL(nDeducibleIngresado, 0)  || ',' || CHR(13);
               cResultado   := cResultado || '"CUOTAPROMEDIO": '       || NVL(nCuotaPromedio, 0)       || ',' || CHR(13);
               cResultado   := cResultado || '"PRIMAPROMEDIO": '       || NVL(nPrimaPromedio, 0)       || ',' || CHR(13);
               cResultado   := cResultado || '"FRANQUICIAINGRESADO": ' || NVL(nFranquiciaIngresado, 0);
           END LOOP;
           CLOSE c_Coberturas;
           --
           cResultado := cResultado || CHR(13) || '}' || CHR(13) || ']' || CHR(13);
       END LOOP;
       CLOSE c_Grupos;
       --
       cResultado := cResultado || '}' || CHR(13) || ']';
       --
       RETURN cResultado;
   END CONSULTAR_COBERTURAS;
   --
   PROCEDURE ACTUALIZAR_DETALLE( nCodCia              COTIZACIONES.CodCia%TYPE
                               , nCodEmpresa          COTIZACIONES.CodEmpresa%TYPE
                               , nIdCotizacion        COTIZACIONES.IdCotizacion%TYPE
                               , nIDetCotizacion      COTIZACIONES_DETALLE.IDetCotizacion%TYPE
                               , cDescSubgrupo        COTIZACIONES_DETALLE.DescSubgrupo%TYPE
                               , nEdadLimite          COTIZACIONES_DETALLE.EdadLimite%TYPE
                               , nCantAsegurados      COTIZACIONES_DETALLE.CantAsegurados%TYPE
                               , nSalarioMensual      COTIZACIONES_DETALLE.SalarioMensual%TYPE
                               , nVecesSalario        COTIZACIONES_DETALLE.VecesSalario%TYPE
                               , nPorcExtraPrimaDet   COTIZACIONES_DETALLE.PorcExtraPrimaDet%TYPE
                               , nMontoExtraPrimaDet  COTIZACIONES_DETALLE.MontoExtraPrimaDet%TYPE
                               , nPrimaAsegurado      COTIZACIONES_DETALLE.PrimaAsegurado%TYPE
                               , nSumaAsegDetLocal    COTIZACIONES_DETALLE.SumaAsegDetLocal%TYPE
                               , nSumaAsegDetMoneda   COTIZACIONES_DETALLE.SumaAsegDetMoneda%TYPE
                               , nPrimaDetLocal       COTIZACIONES_DETALLE.PrimaDetLocal%TYPE
                               , nPrimaDetMoneda      COTIZACIONES_DETALLE.PrimaDetMoneda%TYPE
                               , cRiesgoTarifa        COTIZACIONES_DETALLE.RiesgoTarifa%TYPE
                               , nHorasVig            COTIZACIONES_DETALLE.HorasVig%TYPE
                               , nDiasVig             COTIZACIONES_DETALLE.DiasVig%TYPE
                               , nFactorAjuste        COTIZACIONES_DETALLE.FactorAjuste%TYPE
                               , nFactFormulaDeduc    COTIZACIONES_DETALLE.FactFormulaDeduc%TYPE
                               , cIndEdadPromedio     COTIZACIONES_DETALLE.IndEdadPromedio%TYPE
                               , cIndCuotaPromedio    COTIZACIONES_DETALLE.IndCuotaPromedio%TYPE
                               , cIndPrimaPromedio    COTIZACIONES_DETALLE.IndPrimaPromedio%TYPE
                               , cPrimaNetaPor        COTIZACIONES_DETALLE.PrimaNetaPor%TYPE ) IS
   BEGIN
      UPDATE COTIZACIONES_DETALLE
      SET    DescSubgrupo       = NVL(cDescSubgrupo, DescSubgrupo)
        ,    EdadLimite         = NVL(nEdadLimite, EdadLimite)
        ,    CantAsegurados     = NVL(nCantAsegurados, CantAsegurados)
        ,    SalarioMensual     = NVL(nSalarioMensual, SalarioMensual)
        ,    VecesSalario       = NVL(nVecesSalario, VecesSalario)
        ,    PorcExtraPrimaDet  = NVL(nPorcExtraPrimaDet, PorcExtraPrimaDet)
        ,    MontoExtraPrimaDet = NVL(nMontoExtraPrimaDet, MontoExtraPrimaDet)
        ,    PrimaAsegurado     = NVL(nPrimaAsegurado, PrimaAsegurado)
        ,    SumaAsegDetLocal   = NVL(nSumaAsegDetLocal, SumaAsegDetLocal)
        ,    SumaAsegDetMoneda  = NVL(nSumaAsegDetMoneda, SumaAsegDetMoneda)
        ,    PrimaDetLocal      = NVL(nPrimaDetLocal, PrimaDetLocal)
        ,    PrimaDetMoneda     = NVL(nPrimaDetMoneda, PrimaDetMoneda)
        ,    RiesgoTarifa       = NVL(cRiesgoTarifa, RiesgoTarifa)
        ,    HorasVig           = NVL(nHorasVig, HorasVig)
        ,    DiasVig            = NVL(nDiasVig, DiasVig)
        ,    FactorAjuste       = NVL(nFactorAjuste, FactorAjuste)
        ,    FactFormulaDeduc   = NVL(nFactFormulaDeduc, FactFormulaDeduc)
        ,    IndEdadPromedio    = NVL(cIndEdadPromedio, IndEdadPromedio)
        ,    IndCuotaPromedio   = NVL(cIndCuotaPromedio, IndCuotaPromedio)
        ,    IndPrimaPromedio   = NVL(cIndPrimaPromedio, IndPrimaPromedio)
        ,    PrimaNetaPor       = NVL(cPrimaNetaPor, PrimaNetaPor)
      WHERE  CodCia         = nCodCia
        AND  CodEmpresa     = nCodEmpresa
        AND  IdCotizacion   = nIdCotizacion
        AND  IDetCotizacion = nIDetCotizacion;
   EXCEPTION
   WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20205, 'ERROR AL ACTUALIZAR EL DETALLE DE LA COTIZACION: ' || nIdCotizacion || ' - SUBGRUPO: ' || nIDetCotizacion || '... ' || SQLERRM);
   END ACTUALIZAR_DETALLE;
   --
   PROCEDURE ACTUALIZAR_COMISIONES( nCodCia               COTIZACIONES.CodCia%TYPE
                                  , nCodEmpresa           COTIZACIONES.CodEmpresa%TYPE
                                  , nIdCotizacion         COTIZACIONES.IdCotizacion%TYPE
                                  , nPorcComisAgente      COTIZACIONES.PorcComisAgte%TYPE
                                  , nPorcComisPromot      COTIZACIONES.PorcComisProm%TYPE
                                  , nPorcComisDirecc      COTIZACIONES.PorcComisDir%TYPE
                                  , nPorcConv        OUT  NUMBER
                                  , nGastos          OUT  NUMBER ) IS
      nCodAgente         COTIZACIONES.CodAgente%TYPE;
      nPorcComisAgte     COTIZACIONES.PorcComisAgte%TYPE;
      nPorcComisProm     COTIZACIONES.PorcComisProm%TYPE;
      nPorcComisDir      COTIZACIONES.PorcComisDir%TYPE;
      nPorcGtoAdqui      COTIZACIONES.PorcGtoAdqui%TYPE;
      nPorcGtoAdquiCalc  COTIZACIONES.PorcGtoAdqui%TYPE;
      cCodTipoBono       COTIZACIONES.CodTipoBono%TYPE;
      nPorcConvenciones  COTIZACIONES.PorcConvenciones%TYPE;
   BEGIN
      SICAS_OC.GT_COTIZACIONES_DETALLE.RESTAURA_FACTORAJUSTE(nCodCia, nCodEmpresa, nIdCotizacion, 1);
      --
      BEGIN
         SELECT CodAgente , PorcComisAgte , PorcComisProm , PorcComisDir , PorcGtoAdqui , CodTipoBono , PorcConvenciones
         INTO   nCodAgente, nPorcComisAgte, nPorcComisProm, nPorcComisDir, nPorcGtoAdqui, cCodTipoBono, nPorcConvenciones
         FROM   COTIZACIONES
         WHERE  CodCia        = nCodCia
           AND  CodEmpresa    = nCodEmpresa
           AND  IdCotizacion  = nIdCotizacion;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR(-20200,'No existe la Cotización '||nIdCotizacion);
      END;
      --
      IF nPorcComisAgente <> nPorcComisAgte THEN
         nPorcGtoAdquiCalc := NVL(nPorcComisAgente,0) + NVL(nPorcComisPromot, nPorcComisProm) + NVL(nPorcComisDirecc, nPorcComisDir);
         IF nPorcGtoAdquiCalc > 30 THEN
            cCodTipoBono      := 'CUAE';
            nPorcConvenciones := 10;
         END IF;
         --
         UPDATE COTIZACIONES
         SET PorcComisAgte = nPorcComisAgente
           , PorcComisProm = NVL(nPorcComisPromot, nPorcComisProm)
           , PorcComisDir  = NVL(nPorcComisDirecc, nPorcComisDir)
           , PorcGtoAdqui  = nPorcGtoAdquiCalc
           , CodTipoBono   = cCodTipoBono
         WHERE CodCia       = nCodCia
           AND CodEmpresa   = nCodEmpresa
           AND IdCotizacion = nIdCotizacion;
         --
         --- llamar funcion de actualizar convenciones
         GENERALES_PLATAFORMA_DIGITAL.ACTUALIZA_CONVENCIONES(nCodCia, nCodEmpresa, nIdCotizacion, nPorcConvenciones);
         --- llamar funcion de restaurar factores ajustes
         --GT_COTIZACIONES_DETALLE.RESTAURA_FACTORAJUSTE(nCodCia, nCodEmpresa, nIdCotizacion, 1);
      END IF;
      --
      BEGIN
         SELECT PorcGtoAdqui , CodTipoBono , PorcConvenciones
         INTO   nPorcGtoAdqui, cCodTipoBono, nPorcConvenciones
         FROM   COTIZACIONES
         WHERE  CodCia       = nCodCia
           AND  CodEmpresa   = nCodEmpresa
           AND  IdCotizacion = nIdCotizacion;
      END;
      --
      nGastos   := nPorcGtoAdqui;
      nPorcConv := nPorcConvenciones;
   END ACTUALIZAR_COMISIONES;

   FUNCTION CONSULTAR_LIMITE_COMISION( nCodCia        COTIZACIONES.CodCia%TYPE
                                     , nCodEmpresa    COTIZACIONES.CodEmpresa%TYPE
                                     , nIdCotizacion  COTIZACIONES.IdCotizacion%TYPE ) RETURN CLOB IS
      cJson           CLOB;
      cTemp           CLOB;
      cIdTipoSeg      COTIZACIONES.IdTipoSeg%TYPE;
      nPorcComision   CONFIG_COMISIONES.PorcComision%TYPE;
      nMontoComision  CONFIG_COMISIONES.MontoComision%TYPE;
      cLargoPlazo     TIPOS_DE_SEGUROS.Id_Largo_Plazo%TYPE;
      --
      CURSOR cComisiones IS
             SELECT a.PorcComision, a.MontoComision, b.Id_Largo_Plazo
             FROM   CONFIG_COMISIONES a
                ,   TIPOS_DE_SEGUROS  b
             WHERE  b.IdTipoSeg  = a.IdTipoSeg
               AND  b.CodEmpresa = a.CodEmpresa
               AND  b.CodCia     = a.CodCia
               AND  a.CodEmpresa = nCodEmpresa
               AND  a.IdTipoSeg  = cIdTipoSeg
               AND  a.CodCia     = nCodCia;
   BEGIN
      SELECT IdTipoSeg
      INTO   cIdTipoSeg
      FROM   COTIZACIONES
      WHERE  CodCia       = nCodCia
        AND  CodEmpresa   = nCodEmpresa
        AND  IdCotizacion = nIdCotizacion;
      --
      DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
      DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
      --
      OPEN cComisiones;
      LOOP
         FETCH cComisiones INTO nPorcComision, nMontoComision, cLargoPlazo;
         EXIT WHEN cComisiones%NOTFOUND;
         --
         cTemp := '{
                     "PorcComision": "' || nPorcComision || '",
                     "MontoComision": "' || nMontoComision || '",
                     "LargoPlazo": "' || cLargoPlazo || '"
                   }';
         IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
            DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
         END IF;
         --
         DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
      END LOOP;
      CLOSE cComisiones;
      --
      DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
      RETURN cJson;
   EXCEPTION
   WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20205, 'ERROR AL CONSULTAR LIMITE DE COMISION DE LA COTIZACION: ' || nIdCotizacion || '... ' || SQLERRM);
   END CONSULTAR_LIMITE_COMISION; 

   FUNCTION CONSULTAR_COMISIONES( nCodCia        COTIZACIONES.CodCia%TYPE
                                , nCodEmpresa    COTIZACIONES.CodEmpresa%TYPE
                                , nIdCotizacion  COTIZACIONES.IdCotizacion%TYPE ) RETURN CLOB IS
      cJson           CLOB;
      cTemp           CLOB;
      nPorcComisAgte  COTIZACIONES.PorcComisAgte%TYPE;
      nPorcComisProm  COTIZACIONES.PorcComisProm%TYPE;
      nPorcComisDir   COTIZACIONES.PorcComisDir%TYPE;
      --
      CURSOR cComisiones IS
             SELECT PorcComisAgte , PorcComisProm , PorcComisDir
             FROM   COTIZACIONES
             WHERE  CodCia       = nCodCia
               AND  CodEmpresa   = nCodEmpresa
               AND  IdCotizacion = nIdCotizacion;
   BEGIN
      DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
      DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
      --
      OPEN cComisiones;
      LOOP
         FETCH cComisiones INTO nPorcComisAgte, nPorcComisProm, nPorcComisDir;
         EXIT WHEN cComisiones%NOTFOUND;
         --
         cTemp := '{
                     "PorcComisAgte": "' || nPorcComisAgte || '",
                     "PorcComisProm": "' || nPorcComisProm || '",
                     "PorcComisDir": "'  || nPorcComisDir  || '"
                   }';
         IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
            DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
         END IF;
         --
         DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
      END LOOP;
      CLOSE cComisiones;
      --
      DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
      RETURN cJson;
   EXCEPTION
   WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20205, 'ERROR AL CONSULTAR LAS COMISIONES DE LA COTIZACION: ' || nIdCotizacion || '... ' || SQLERRM);
   END CONSULTAR_COMISIONES; 

   FUNCTION CONSULTAR_COTIZACION( nCodCia        COTIZACIONES.CodCia%TYPE
                                , nCodEmpresa    COTIZACIONES.CodEmpresa%TYPE
                                , nIdCotizacion  COTIZACIONES.IdCotizacion%TYPE ) RETURN CLOB IS
      cJson            CLOB;
      cTemp            CLOB;
      rCotizacion      COTIZACIONES%ROWTYPE;
      nIDetCotizacion  COTIZACIONES_DETALLE.IDetCotizacion%TYPE;
      cCodSubGrupo     COTIZACIONES_DETALLE.CodSubGrupo%TYPE;
      cDescSubGrupo    COTIZACIONES_DETALLE.DescSubGrupo%TYPE;
      nContador        NUMBER := 0;
      --
      CURSOR cInfoCotizacion IS
             SELECT *
             FROM   COTIZACIONES
             WHERE  CodCia       = nCodCia
               AND  CodEmpresa   = nCodEmpresa
               AND  IdCotizacion = nIdCotizacion;
      --
      CURSOR c_SubGrupos IS
             SELECT IDetCotizacion, CodSubGrupo, DescSubGrupo
             FROM   COTIZACIONES_DETALLE
             WHERE  CodCia         = nCodCia
               AND  CodEmpresa     = nCodEmpresa
               AND  IdCotizacion   = nIdCotizacion
             ORDER BY IDetCotizacion;
   BEGIN
      DBMS_LOB.CREATETEMPORARY(cJson, TRUE);
      DBMS_LOB.WRITEAPPEND(cJson, LENGTH('[ '), '[ ');
      --
      OPEN cInfoCotizacion;
      LOOP
         FETCH cInfoCotizacion INTO rCotizacion;
         EXIT WHEN cInfoCotizacion%NOTFOUND;
         --
         cTemp := '{
                     "NUMUNICOCOTIZACION": "'    || rCotizacion.NUMUNICOCOTIZACION    || '",
                     "CODCOTIZADOR": "'          || rCotizacion.CODCOTIZADOR          || '",
                     "NUMCOTIZACIONREF": "'      || rCotizacion.NUMCOTIZACIONREF      || '",
                     "NUMCOTIZACIONANT": "'      || rCotizacion.NUMCOTIZACIONANT      || '",
                     "STSCOTIZACION": "'         || rCotizacion.STSCOTIZACION         || '",
                     "FECSTATUS": "'             || rCotizacion.FECSTATUS             || '",
                     "NOMBRECONTRATANTE": "'     || rCotizacion.NOMBRECONTRATANTE     || '",
                     "FECINIVIGCOT": "'          || rCotizacion.FECINIVIGCOT          || '",
                     "FECFINVIGCOT": "'          || rCotizacion.FECFINVIGCOT          || '",
                     "FECCOTIZACION": "'         || rCotizacion.FECCOTIZACION         || '",
                     "FECVENCECOTIZACION": "'    || rCotizacion.FECVENCECOTIZACION    || '",
                     "NUMDIASRETROACTIVIDAD": "' || rCotizacion.NUMDIASRETROACTIVIDAD || '",
                     "COD_MONEDA": "'            || rCotizacion.COD_MONEDA            || '",
                     "SUMAASEGCOTLOCAL": "'      || rCotizacion.SUMAASEGCOTLOCAL      || '",
                     "SUMAASEGCOTMONEDA": "'     || rCotizacion.SUMAASEGCOTMONEDA     || '",
                     "PRIMACOTLOCAL": "'         || rCotizacion.PRIMACOTLOCAL         || '",
                     "PRIMACOTMONEDA": "'        || rCotizacion.PRIMACOTMONEDA        || '",
                     "IDTIPOSEG": "'             || rCotizacion.IDTIPOSEG             || '",
                     "PLANCOB": "'               || rCotizacion.PLANCOB               || '",
                     "CODAGENTE": "'             || rCotizacion.CODAGENTE             || '",
                     "CODPLANPAGO": "'           || rCotizacion.CODPLANPAGO           || '",
                     "IDPOLIZA": "'              || rCotizacion.IDPOLIZA              || '",
                     "PORCDESCUENTO": "'         || rCotizacion.PORCDESCUENTO         || '",
                     "PORCGTOADMIN": "'          || rCotizacion.PORCGTOADMIN          || '",
                     "PORCGTOADQUI": "'          || rCotizacion.PORCGTOADQUI          || '",
                     "PORCUTILIDAD": "'          || rCotizacion.PORCUTILIDAD          || '",
                     "FACTORAJUSTE": "'          || rCotizacion.FACTORAJUSTE          || '",
                     "MONTODEDUCIBLE": "'        || rCotizacion.MONTODEDUCIBLE        || '",
                     "FACTFORMULADEDUC": "'      || rCotizacion.FACTFORMULADEDUC      || '",
                     "PORCVARIACIONEMI": "'      || rCotizacion.PORCVARIACIONEMI      || '",
                     "INDASEGMODELO": "'         || rCotizacion.INDASEGMODELO         || '",
                     "INDLISTADOASEG": "'        || rCotizacion.INDLISTADOASEG        || '",
                     "INDCENSOSUBGRUPO": "'      || rCotizacion.INDCENSOSUBGRUPO      || '",
                     "INDEXTRAPRIMA": "'         || rCotizacion.INDEXTRAPRIMA         || '",
                     "CODRIESGOREA": "'          || rCotizacion.CODRIESGOREA          || '",
                     "CODTIPOBONO": "'           || rCotizacion.CODTIPOBONO           || '",
                     "DESCPOLITICASUMASASEG": "' || rCotizacion.DESCPOLITICASUMASASEG || '",
                     "DESCPOLITICAEDADES": "'    || rCotizacion.DESCPOLITICAEDADES    || '",
                     "DESCTIPOIDENTASEG": "'     || rCotizacion.DESCTIPOIDENTASEG     || '",
                     "TIPOADMINISTRACION": "'    || rCotizacion.TIPOADMINISTRACION    || '",
                     "CANALFORMAVENTA": "'       || rCotizacion.CANALFORMAVENTA       || '",
                     "ASEGENINCAPACIDAD": "'     || rCotizacion.ASEGENINCAPACIDAD     || '",
                     "TEXTOSUSCRIPTOR": "'       || rCotizacion.TEXTOSUSCRIPTOR       || '",
                     "HORASVIG": "'              || rCotizacion.HORASVIG              || '",
                     "DIASVIG": "'               || rCotizacion.DIASVIG               || '",
                     "CANTASEGURADOS": "'        || rCotizacion.CANTASEGURADOS        || '",
                     "FACTORSAMIASEG": "'        || rCotizacion.FACTORSAMIASEG        || '",
                     "PROMEDIOSUMAASEG": "'      || rCotizacion.PROMEDIOSUMAASEG      || '",
                     "SUMAASEGSAMI": "'          || rCotizacion.SUMAASEGSAMI          || '",
                     "SAMIAUTORIZADO": "'        || rCotizacion.SAMIAUTORIZADO        || '",
                     "DESCGIRONEGOCIO": "'       || rCotizacion.DESCGIRONEGOCIO       || '",
                     "DESCACTIVIDADASEG": "'     || rCotizacion.DESCACTIVIDADASEG     || '",
                     "DESCFORMULADIVIDENDOS": "' || rCotizacion.DESCFORMULADIVIDENDOS || '",
                     "NUMPOLRENOVACION": "'      || rCotizacion.NUMPOLRENOVACION      || '",
                     "ASEGADHERIDOSPOR": "'      || rCotizacion.ASEGADHERIDOSPOR      || '",
                     "PORCENCONTRIBUTORIO": "'   || rCotizacion.PORCENCONTRIBUTORIO   || '",
                     "FUENTERECURSOSPRIMA": "'   || rCotizacion.FUENTERECURSOSPRIMA   || '",
                     "TIPOPRORRATA": "'          || rCotizacion.TIPOPRORRATA          || '",
                     "PORCCOMISAGTE": "'         || rCotizacion.PORCCOMISAGTE         || '",
                     "PORCCOMISPROM": "'         || rCotizacion.PORCCOMISPROM         || '",
                     "PORCCOMISDIR": "'          || rCotizacion.PORCCOMISDIR          || '",
                     "INDCONVENCIONES": "'       || rCotizacion.INDCONVENCIONES       || '",
                     "PORCCONVENCIONES": "'      || rCotizacion.PORCCONVENCIONES      || '",
                     "CODUSUARIO": "'            || rCotizacion.CODUSUARIO            || '",
                     "DESCCUOTASPRIMANIV": "'    || rCotizacion.DESCCUOTASPRIMANIV    || '",
                     "DESCELEGIBILIDAD": "'      || rCotizacion.DESCELEGIBILIDAD      || '",
                     "DESCRIESGOSCUBIERTOS": "'  || rCotizacion.DESCRIESGOSCUBIERTOS  || '",
                     "FECSOLICITUD": "'          || rCotizacion.FECSOLICITUD          || '",
                     "HORASOLICITUD": "'         || rCotizacion.HORASOLICITUD         || '",
                     "HORASTATUS": "'            || rCotizacion.HORASTATUS            || '",
                     "GASTOSEXPEDICION": "'      || rCotizacion.GASTOSEXPEDICION      || '",
                     "INDCOTIZACIONWEB": "'      || rCotizacion.INDCOTIZACIONWEB      || '",
                     "INDCOTIZACIONBASEWEB": "'  || rCotizacion.INDCOTIZACIONBASEWEB  || '",
                     "CODTIPONEGOCIO": "'        || rCotizacion.CODTIPONEGOCIO        || '",
                     "CODPAQCOMERCIAL": "'       || rCotizacion.CODPAQCOMERCIAL       || '",
                     "CODOFICINA": "'            || rCotizacion.CODOFICINA            || '",
                     "CODUSUARIOMOD": "'         || rCotizacion.CODUSUARIOMOD         || '",
                     "FECULTIMAMOD": "'          || rCotizacion.FECULTIMAMOD          || '",
                     "CODCATEGO": "'             || rCotizacion.CODCATEGO             || '",
                     "STSACTUALIZA": "'          || rCotizacion.STSACTUALIZA          || '",
                     "USUARIOACTUALIZA": "'      || rCotizacion.USUARIOACTUALIZA      || '",
                     "FECHAACTUALIZA": "'        || rCotizacion.FECHAACTUALIZA        || '",
                     "CODPAQUETE": "'            || rCotizacion.CODPAQUETE            || '",
                     "FRANQUICIAINGRESADO": "'   || rCotizacion.FRANQUICIAINGRESADO   || '",
                     "RIESGOTARIFA": "'          || rCotizacion.RIESGOTARIFA          || '",
                     "TIPNEGO_WEB": "'           || rCotizacion.TIPNEGO_WEB           || '",
                     "RIES_LABOR": "'            || rCotizacion.RIES_LABOR            || '",
                     "RIES_24365": "'            || rCotizacion.RIES_24365            || '",
                     "RIES_TRASLA": "'           || rCotizacion.RIES_TRASLA           || '",
                     "INDPRIMIN": "'             || rCotizacion.INDPRIMIN             || '"';
         IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
            DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
         END IF;
         --
         DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
      END LOOP;
      CLOSE cInfoCotizacion;
      --
      cTemp := '"XSUBGRUPOS": [';
      IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
         DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
      END IF;
      DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
      --
      OPEN c_SubGrupos;
      LOOP
         FETCH c_SubGrupos INTO nIDetCotizacion, cCodSubGrupo, cDescSubGrupo;
         EXIT WHEN c_SubGrupos%NOTFOUND;
         --
         cTemp := '{
                     "IDETCOTIZACION": "' || nIDetCotizacion || '",
                     "CODSUBGRUPO": "'    || cCodSubGrupo    || '",
                     "DESCSUBGRUPO": "'   || cDescSubGrupo   || '"
                   }';
         IF nContador > 0 THEN
            IF DBMS_LOB.GETLENGTH(cJson) > 2 THEN
               DBMS_LOB.WRITEAPPEND(cJson, 2, ', ');
            END IF;
         END IF;
         --
         nContador := nContador + 1;
         --
         DBMS_LOB.WRITEAPPEND(cJson, LENGTH(cTemp), cTemp);
      END LOOP;
      CLOSE c_SubGrupos;
      --
      DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
      DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' }'), ' }');
      --
      DBMS_LOB.WRITEAPPEND(cJson, LENGTH(' ]'), ' ]');
      RETURN cJson;
   EXCEPTION
   WHEN OTHERS THEN
       RAISE_APPLICATION_ERROR(-20205, 'ERROR AL CONSULTAR LA INFORMACION DE LA COTIZACION: ' || nIdCotizacion || '... ' || SQLERRM);
   END CONSULTAR_COTIZACION; 

   FUNCTION CONSULTAR_COTIZACIONES_DETALLE( nCodCia          COTIZACIONES_DETALLE.CodCia%TYPE
                                          , nCodEmpresa      COTIZACIONES_DETALLE.CodEmpresa%TYPE
                                          , nIdCotizacion    COTIZACIONES_DETALLE.IdCotizacion%TYPE
                                          , nIDetCotizacion  COTIZACIONES_DETALLE.IDetCotizacion%TYPE ) RETURN CLOB IS
      cResultado           CLOB;
      rCotizacionDet    COTIZACIONES_DETALLE%ROWTYPE;
      nIDetCotizacion1  COTIZACIONES_DETALLE.IDetCotizacion%TYPE;
      nIDetCotizacion2  COTIZACIONES_DETALLE.IDetCotizacion%TYPE;
      cCodSubGrupo      COTIZACIONES_DETALLE.CodSubGrupo%TYPE;
      cDescSubGrupo     COTIZACIONES_DETALLE.DescSubGrupo%TYPE;
      --
      CURSOR c_SubGrupos IS
             SELECT IDetCotizacion, CodSubGrupo, DescSubGrupo
             FROM   COTIZACIONES_DETALLE
             WHERE  CodCia         = nCodCia
               AND  CodEmpresa     = nCodEmpresa
               AND  IdCotizacion   = nIdCotizacion
               AND  IDetCotizacion = NVL(nIDetCotizacion, IDetCotizacion);
      --
      CURSOR c_Informacion IS
             SELECT *
             FROM   COTIZACIONES_DETALLE
             WHERE  CodCia         = nCodCia
               AND  CodEmpresa     = nCodEmpresa
               AND  IdCotizacion   = nIdCotizacion
               AND  IDetCotizacion = nIDetCotizacion1;
   BEGIN
      cResultado := '[ ' || CHR(13);
      --
      OPEN c_SubGrupos;
      LOOP
         FETCH c_SubGrupos INTO nIDetCotizacion1, cCodSubGrupo, cDescSubGrupo;
         EXIT WHEN c_SubGrupos%NOTFOUND;
         --
         IF nIDetCotizacion2 IS NOT NULL THEN
            cResultado := cResultado || '      },' || CHR(13);
         END IF;
         --
         cResultado       := cResultado || '      { "IDETCOTIZACION": "' || nIDetCotizacion1 || '",' || CHR(13);
         cResultado       := cResultado || '        "CODSUBGRUPO": "'    || cCodSubGrupo     || '",' || CHR(13);
         cResultado       := cResultado || '        "DESCSUBGRUPO": "'   || cDescSubGrupo    || '",' || CHR(13);
         cResultado       := cResultado || '        "INFORMACION": [ '   || CHR(13);
         nIDetCotizacion2 := nIDetCotizacion1;
         --
         OPEN c_Informacion;
         LOOP
            FETCH c_Informacion INTO rCotizacionDet;
            EXIT WHEN c_Informacion%NOTFOUND;
            --
            cResultado   := cResultado || '             { "EDADLIMITE": "'          || rCotizacionDet.EDADLIMITE         || '",' || CHR(13);
            cResultado   := cResultado || '               "CANTASEGURADOS": "'      || rCotizacionDet.CANTASEGURADOS     || '",' || CHR(13);
            cResultado   := cResultado || '               "SALARIOMENSUAL":"'       || rCotizacionDet.SALARIOMENSUAL     || '",' || CHR(13);
            cResultado   := cResultado || '               "VECESSALARIO": "'        || rCotizacionDet.VECESSALARIO       || '",' || CHR(13);
            cResultado   := cResultado || '               "PORCEXTRAPRIMADET": "'   || rCotizacionDet.PORCEXTRAPRIMADET  || '",' || CHR(13);
            cResultado   := cResultado || '               "MONTOEXTRAPRIMADET": "'  || rCotizacionDet.MONTOEXTRAPRIMADET || '",' || CHR(13);
            cResultado   := cResultado || '               "PRIMAASEGURADO": "'      || rCotizacionDet.PRIMAASEGURADO     || '",' || CHR(13);
            cResultado   := cResultado || '               "SUMAASEGURADO": "'       || rCotizacionDet.SUMAASEGURADO      || '",' || CHR(13);
            cResultado   := cResultado || '               "SUMAASEGDETLOCAL": "'    || rCotizacionDet.SUMAASEGDETLOCAL   || '",' || CHR(13);
            cResultado   := cResultado || '               "SUMAASEGDETMONEDA": "'   || rCotizacionDet.SUMAASEGDETMONEDA  || '",' || CHR(13);
            cResultado   := cResultado || '               "PRIMADETLOCAL": "'       || rCotizacionDet.PRIMADETLOCAL      || '",' || CHR(13);
            cResultado   := cResultado || '               "PRIMADETMONEDA": "'      || rCotizacionDet.PRIMADETMONEDA     || '",' || CHR(13);
            cResultado   := cResultado || '               "INDMODIFREGLAS": "'      || rCotizacionDet.INDMODIFREGLAS     || '",' || CHR(13);
            cResultado   := cResultado || '               "RIESGOTARIFA": "'        || rCotizacionDet.RIESGOTARIFA       || '",' || CHR(13);
            cResultado   := cResultado || '               "HORASVIG": "'            || rCotizacionDet.HORASVIG           || '",' || CHR(13);
            cResultado   := cResultado || '               "DIASVIG": "'             || rCotizacionDet.DIASVIG            || '",' || CHR(13);
            cResultado   := cResultado || '               "FACTORAJUSTE": "'        || rCotizacionDet.FACTORAJUSTE       || '",' || CHR(13);
            cResultado   := cResultado || '               "FACTFORMULADEDUC": "'    || rCotizacionDet.FACTFORMULADEDUC   || '",' || CHR(13);
            cResultado   := cResultado || '               "INDEDADPROMEDIO": "'     || rCotizacionDet.INDEDADPROMEDIO    || '",' || CHR(13);
            cResultado   := cResultado || '               "INDCUOTAPROMEDIO": "'    || rCotizacionDet.INDCUOTAPROMEDIO   || '",' || CHR(13);
            cResultado   := cResultado || '               "INDPRIMAPROMEDIO": "'    || rCotizacionDet.INDPRIMAPROMEDIO   || '",' || CHR(13);
            cResultado   := cResultado || '               "PRIMANETAPOR": "'        || rCotizacionDet.PRIMANETAPOR       || '",' || CHR(13);
            cResultado   := cResultado || '               "FACTORAJUSTEINICIAL": "' || rCotizacionDet.FACTORAJUSTEINICIAL;
         END LOOP;
         CLOSE c_Informacion;
         --
         cResultado := cResultado || CHR(13) || '             }' || CHR(13) || '         ]' || CHR(13);
      END LOOP;
      CLOSE c_SubGrupos;
      --
      cResultado := cResultado || '      }' || CHR(13) || '   ]';
      --
      RETURN cResultado;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL CONSULTAR LA INFORMACION DEL DETALLE DE LA COTIZACION: ' || nIdCotizacion || '... ' || SQLERRM);
   END CONSULTAR_COTIZACIONES_DETALLE;

   PROCEDURE ACTUALIZAR_ASEGURADO( nCodCia           COTIZACIONES_ASEG.CodCia%TYPE
                                 , nCodEmpresa       COTIZACIONES_ASEG.CodEmpresa%TYPE
                                 , nIdCotizacion     COTIZACIONES_ASEG.IdCotizacion%TYPE
                                 , nIDetCotizacion   COTIZACIONES_ASEG.IDetCotizacion%TYPE
                                 , nIdAsegurado      COTIZACIONES_ASEG.IdAsegurado%TYPE
                                 , cNombre           COTIZACIONES_ASEG.NombreAseg%TYPE
                                 , cApellidoPaterno  COTIZACIONES_ASEG.ApellidoPaternoAseg%TYPE
                                 , cApellidoMaterno  COTIZACIONES_ASEG.ApellidoMaternoAseg%TYPE
                                 , dFechaNacimiento  COTIZACIONES_ASEG.FechaNacAseg%TYPE ) IS
      nEdad          COTIZACIONES_ASEG.EdadContratacion%TYPE;
      nIdAsegurado2  COTIZACIONES_ASEG.IdAsegurado%TYPE;
      nTotal         NUMBER;
   BEGIN
      IF nIdAsegurado IS NOT NULL THEN
         SELECT COUNT(*)
         INTO   nTotal
         FROM   COTIZACIONES_ASEG
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion
           AND  IdAsegurado    = nIdAsegurado;
      ELSE
         SELECT COUNT(*)
         INTO   nTotal
         FROM   COTIZACIONES_ASEG
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion
           AND  UPPER(TRIM(NombreAseg))          LIKE UPPER(TRIM(cNombre))
           AND  UPPER(TRIM(ApellidoPaternoAseg)) LIKE UPPER(TRIM(cApellidoPaterno))
           AND  UPPER(TRIM(ApellidoMaternoAseg)) LIKE UPPER(TRIM(cApellidoMaterno));
      END IF;
      --
      IF nTotal = 0 THEN
         RAISE_APPLICATION_ERROR(-20205, 'ERROR NO EXISTE NINGUN ASEGURADO EN LA COTIZACION CON ESA INFORMACION.' );
      ELSIF nTotal > 1 THEN
         RAISE_APPLICATION_ERROR(-20205, 'ERROR EXISTE MAS DE UN ASEGURADO EN LA COTIZACION CON ESA INFORMACION.' );
      END IF;
      --
      IF nTotal = 1 AND nIdAsegurado IS NOT NULL THEN
         nIdAsegurado2 := nIdAsegurado;
      ELSE
         SELECT IdAsegurado
         INTO   nIdAsegurado2
         FROM   COTIZACIONES_ASEG
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion
           AND  UPPER(TRIM(NombreAseg))          LIKE UPPER(TRIM(cNombre))
           AND  UPPER(TRIM(ApellidoPaternoAseg)) LIKE UPPER(TRIM(cApellidoPaterno))
           AND  UPPER(TRIM(ApellidoMaternoAseg)) LIKE UPPER(TRIM(cApellidoMaterno));
      END IF;
      --
      nEdad := GENERALES_PLATAFORMA_DIGITAL.CALCULA_EDAD(dFechaNacimiento);
      --
      UPDATE COTIZACIONES_ASEG
      SET    NombreAseg          = cNombre
        ,    ApellidoPaternoAseg = cApellidoPaterno
        ,    ApellidoMaternoAseg = cApellidoMaterno
        ,    EdadContratacion    = nEdad
        ,    FechaNacAseg        = dFechaNacimiento
      WHERE  CodCia         = nCodCia
        AND  CodEmpresa     = nCodEmpresa
        AND  IdCotizacion   = nIdCotizacion
        AND  IDetCotizacion = nIDetCotizacion
        AND  IdAsegurado    = nIdAsegurado2;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL ACTUALIZAR_ASEGURADO DE LA COTIZACION: ' || nIdCotizacion || '... ' || SQLERRM);
   END ACTUALIZAR_ASEGURADO;

   PROCEDURE ELIMINAR_ASEGURADO( nCodCia           COTIZACIONES_ASEG.CodCia%TYPE
                               , nCodEmpresa       COTIZACIONES_ASEG.CodEmpresa%TYPE
                               , nIdCotizacion     COTIZACIONES_ASEG.IdCotizacion%TYPE
                               , nIDetCotizacion   COTIZACIONES_ASEG.IDetCotizacion%TYPE
                               , nIdAsegurado      COTIZACIONES_ASEG.IdAsegurado%TYPE
                               , cNombre           COTIZACIONES_ASEG.NombreAseg%TYPE
                               , cApellidoPaterno  COTIZACIONES_ASEG.ApellidoPaternoAseg%TYPE
                               , cApellidoMaterno  COTIZACIONES_ASEG.ApellidoMaternoAseg%TYPE ) IS
      nIdAsegurado2  COTIZACIONES_ASEG.IdAsegurado%TYPE;
      nTotal         NUMBER;
   BEGIN
      IF nIdAsegurado IS NOT NULL THEN
         SELECT COUNT(*)
         INTO   nTotal
         FROM   COTIZACIONES_ASEG
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion
           AND  IdAsegurado    = nIdAsegurado;
      ELSE
         SELECT COUNT(*)
         INTO   nTotal
         FROM   COTIZACIONES_ASEG
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion
           AND  UPPER(TRIM(NombreAseg))          LIKE UPPER(TRIM(cNombre))
           AND  UPPER(TRIM(ApellidoPaternoAseg)) LIKE UPPER(TRIM(cApellidoPaterno))
           AND  UPPER(TRIM(ApellidoMaternoAseg)) LIKE UPPER(TRIM(cApellidoMaterno));
      END IF;
      --
      IF nTotal = 0 THEN
         RAISE_APPLICATION_ERROR(-20205, 'ERROR NO EXISTE NINGUN ASEGURADO EN LA COTIZACION CON ESA INFORMACION.' );
      ELSIF nTotal > 1 THEN
         RAISE_APPLICATION_ERROR(-20205, 'ERROR EXISTE MAS DE UN ASEGURADO EN LA COTIZACION CON ESA INFORMACION.' );
      END IF;
      --
      IF nTotal = 1 AND nIdAsegurado IS NOT NULL THEN
         nIdAsegurado2 := nIdAsegurado;
      ELSE
         SELECT IdAsegurado
         INTO   nIdAsegurado2
         FROM   COTIZACIONES_ASEG
         WHERE  CodCia         = nCodCia
           AND  CodEmpresa     = nCodEmpresa
           AND  IdCotizacion   = nIdCotizacion
           AND  IDetCotizacion = nIDetCotizacion
           AND  UPPER(TRIM(NombreAseg))          LIKE UPPER(TRIM(cNombre))
           AND  UPPER(TRIM(ApellidoPaternoAseg)) LIKE UPPER(TRIM(cApellidoPaterno))
           AND  UPPER(TRIM(ApellidoMaternoAseg)) LIKE UPPER(TRIM(cApellidoMaterno));
      END IF;
      --
      DELETE COTIZACIONES_COBERT_ASEG
      WHERE  CodCia         = nCodCia
        AND  CodEmpresa     = nCodEmpresa
        AND  IdCotizacion   = nIdCotizacion
        AND  IDetCotizacion = nIDetCotizacion
        AND  IdAsegurado    = nIdAsegurado2;
      --
      DELETE COTIZACIONES_ASEG
      WHERE  CodCia         = nCodCia
        AND  CodEmpresa     = nCodEmpresa
        AND  IdCotizacion   = nIdCotizacion
        AND  IDetCotizacion = nIDetCotizacion
        AND  IdAsegurado    = nIdAsegurado2;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL ELIMINAR_ASEGURADO DE LA COTIZACION: ' || nIdCotizacion || '... ' || SQLERRM);
   END ELIMINAR_ASEGURADO;

   FUNCTION INSERTAR_ASEGURADO( nCodCia           COTIZACIONES_ASEG.CodCia%TYPE
                              , nCodEmpresa       COTIZACIONES_ASEG.CodEmpresa%TYPE
                              , nIdCotizacion     COTIZACIONES_ASEG.IdCotizacion%TYPE
                              , nIDetCotizacion   COTIZACIONES_ASEG.IDetCotizacion%TYPE
                              , cNombre           COTIZACIONES_ASEG.NombreAseg%TYPE
                              , cApellidoPaterno  COTIZACIONES_ASEG.ApellidoPaternoAseg%TYPE
                              , cApellidoMaterno  COTIZACIONES_ASEG.ApellidoMaternoAseg%TYPE
                              , dFechaNacimiento  COTIZACIONES_ASEG.FechaNacAseg%TYPE ) RETURN NUMBER IS
      nEdad         COTIZACIONES_ASEG.EdadContratacion%TYPE;
      nIdAsegurado  COTIZACIONES_ASEG.IdAsegurado%TYPE;
   BEGIN
      SELECT NVL(MAX(IdAsegurado), 0) + 1
      INTO   nIdAsegurado
      FROM   COTIZACIONES_ASEG
      WHERE  CodCia         = nCodCia
        AND  CodEmpresa     = nCodEmpresa
        AND  IdCotizacion   = nIdCotizacion
        AND  IDetCotizacion = nIDetCotizacion;
      --
      nEdad := THONAPI.GENERALES_PLATAFORMA_DIGITAL.CALCULA_EDAD(dFechaNacimiento);
      --
      INSERT INTO COTIZACIONES_ASEG
             ( CodCia , CodEmpresa , IdCotizacion , IDetCotizacion , IdAsegurado , NombreAseg, ApellidoPaternoAseg, ApellidoMaternoAseg, EdadContratacion, FechaNacAseg )
      VALUES ( nCodCia, nCodEmpresa, nIdCotizacion, nIDetCotizacion, nIdAsegurado, cNombre   , cApellidoPaterno   , cApellidoMaterno   , nEdad           , dFechaNacimiento );
      --
      RETURN nIdAsegurado;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL INSERTAR_ASEGURADO EN LA COTIZACION: ' || nIdCotizacion || '... ' || SQLERRM);
   END INSERTAR_ASEGURADO;

END FLUJO_COTIZACION_SIGO;
/

CREATE OR REPLACE PUBLIC SYNONYM FLUJO_COTIZACION_SIGO FOR THONAPI.FLUJO_COTIZACION_SIGO
/

GRANT EXECUTE ON THONAPI.FLUJO_COTIZACION_SIGO TO PUBLIC
/
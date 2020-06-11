CREATE OR REPLACE PACKAGE SICAS_OC.OC_REPORTES_COTIZACIONES IS
   --
   --Variables globales para la información del reporte
   cTitulo1         VARCHAR2(4000);
   cTitulo2         VARCHAR2(4000);
   cTitulo3         VARCHAR2(4000);
   cEncabez         VARCHAR2(4000);
   cRegistro        VARCHAR2(4000);
   cError           VARCHAR2(2000);
   nFila            NUMBER := 1;
   --
   FUNCTION NOMBRE_COMPANIA( nCodCia NUMBER ) RETURN VARCHAR2;

   PROCEDURE INSERTA_ENCABEZADO( nCodCia         NUMBER
                               , nCodEmpresa     NUMBER
                               , cCodReporte     VARCHAR2
                               , cCodUser        VARCHAR2
                               , cNomDirectorio  VARCHAR2
                               , cNomArchivo     VARCHAR2 );
                               
   PROCEDURE LISTADO_COTIZACIONES( nCodCia         COTIZACIONES.CodCia%TYPE
                                 , nCodEmpresa     COTIZACIONES.CodEmpresa%TYPE
                                 , dFecDesde       DATE
                                 , dFecHasta       DATE
                                 , cCodUser        VARCHAR2
                                 , cNomArchivo     VARCHAR2
                                 , cNomArchZip     VARCHAR2
                                 , cNomDirectorio  VARCHAR2
                                 , cCodReporte     VARCHAR2 );

END OC_REPORTES_COTIZACIONES;
/

CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_REPORTES_COTIZACIONES IS

   FUNCTION NOMBRE_COMPANIA( nCodCia NUMBER ) RETURN VARCHAR2 IS
      cNomCia VARCHAR2(200);
   BEGIN
      SELECT NomCia
        INTO cNomCia
        FROM EMPRESAS
       WHERE CodCia = nCodCia;
      RETURN(cNomCia);
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      cNomCia := 'COMPA?IA - NO EXISTE!!!';
      RETURN(cNomCia);
   END NOMBRE_COMPANIA;

   PROCEDURE INSERTA_ENCABEZADO( nCodCia         NUMBER
                               , nCodEmpresa     NUMBER
                               , cCodReporte     VARCHAR2
                               , cCodUser        VARCHAR2
                               , cNomDirectorio  VARCHAR2
                               , cNomArchivo     VARCHAR2 ) IS
      --Variables globales para el manejo de los encabezados
      nColsTotales     NUMBER := 0;
      nColsLateral     NUMBER := 0;
      nColsMerge       NUMBER := 0;
      nColsCentro      NUMBER := 0;
      nJustCentro      NUMBER := 3; 
   BEGIN
      nFila := 1;
      --
      --Obtiene Número de Columnas Totales
      nColsTotales := XLSX_BUILDER_PKG.EXCEL_CUENTA_COLUMNAS(cEncabez);
      --
      IF XLSX_BUILDER_PKG.EXCEL_CREAR_LIBRO(cNomDirectorio, cNomArchivo) THEN
         IF XLSX_BUILDER_PKG.EXCEL_CREAR_HOJA(cCodReporte) THEN
            --Titulos
            nFila := XLSX_BUILDER_PKG.EXCEL_HEADER(nFila + 1, cTitulo1, nColsTotales, nJustCentro, nColsLateral, nColsCentro, nColsMerge);
            nFila := XLSX_BUILDER_PKG.EXCEL_HEADER(nFila + 1, cTitulo2, nColsTotales, nJustCentro, nColsLateral, nColsCentro, nColsMerge);
            nFila := XLSX_BUILDER_PKG.EXCEL_HEADER(nFila + 1, cTitulo3, nColsTotales, nJustCentro, nColsLateral, nColsCentro, nColsMerge);
            --Encabezado
            nFila := XLSX_BUILDER_PKG.EXCEL_ENCABEZADO(nFila + 2, cEncabez, 1);
         END IF;
      END IF;
   EXCEPTION 
   WHEN OTHERS THEN 
      cError := SQLERRM;
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20225, cError );
   END INSERTA_ENCABEZADO;

   PROCEDURE LISTADO_COTIZACIONES( nCodCia         COTIZACIONES.CodCia%TYPE
                                 , nCodEmpresa     COTIZACIONES.CodEmpresa%TYPE
                                 , dFecDesde       DATE
                                 , dFecHasta       DATE
                                 , cCodUser        VARCHAR2
                                 , cNomArchivo     VARCHAR2
                                 , cNomArchZip     VARCHAR2
                                 , cNomDirectorio  VARCHAR2
                                 , cCodReporte     VARCHAR2 ) IS
   cNumPolUnico     POLIZAS.NumPolUnico%TYPE;
   cStsPoliza       POLIZAS.StsPoliza%TYPE;
   cTipoCotizacion  VARCHAR2(30);
   nIdCotizacion    SICAS_OC.COTIZACIONES.IdCotizacion%TYPE;
   --
   CURSOR Cotizaciones IS 
      SELECT C.IdCotizacion
           , C.NumUnicoCotizacion
           , C.CodCotizador
           , C.NumCotizacionRef
           , C.NumCotizacionAnt
           , OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', C.StsCotizacion) StsCotizacion
           , C.FecStatus
           , C.NombreContratante
           , C.FecIniVigCot
           , C.FecFinVigCot
           , C.FecCotizacion
           , C.FecVenceCotizacion
           , C.NumDiasRetroactividad
           , C.Cod_Moneda
           , C.SumaAsegCotLocal
           , C.SumaAsegCotMoneda
           , C.PrimaCotLocal
           , C.PrimaCotMoneda
           , C.IdTipoSeg
           , C.PlanCob
           , C.CodAgente
           , C.CodPlanPago
           , C.IdPoliza
           , C.PorcDescuento
           , C.PorcGtoAdmin
           , C.PorcGtoAdqui
           , C.PorcUtilidad
           , C.FactorAjuste
           , C.MontoDeducible
           , C.FactFormulaDeduc
           , C.PorcVariacionEmi
           , C.IndAsegModelo
           , C.IndListadoAseg
           , C.IndCensoSubgrupo
           , C.IndExtraPrima
           , C.CodRiesgoRea
           , C.CodTipoBono
           , C.DescPoliticaSumasAseg
           , C.DescPoliticaEdades
           , C.DescTipoIdentAseg
           , C.TipoAdministracion
           , C.AsegEnIncapacidad
           , C.HorasVig
           , C.DiasVig
           , C.CodUsuario
           , GT_COTIZADOR_CONFIG.DESCRIPCION_COTIZADOR(C.CodCia, C.CodEmpresa, C.CodCotizador) DescCotizador
           , OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(C.CodCia, C.CodEmpresa, C.IdTipoSeg) DescIdTipoSeg
           , OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(C.CodCia, C.CodEmpresa, C.IdTipoSeg, C.PlanCob) DescTipoPlan
           --OC_MONEDA.DESCRIPCION_MONEDA(Cod_Moneda) DescMoneda,
           , OC_AGENTES.NOMBRE_AGENTE(C.CodCia, C.CodAgente) NombreAgente
           , OC_PLAN_DE_PAGOS.DESCRIPCION_PLAN(C.CodCia, C.CodEmpresa, C.CodPlanPago) DescPlanPago
           , OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ADMINPOL', C.TipoAdministracion) DescAdministracion
           , OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CLASEBONO', C.CodTipoBono) ClaseBono
           , GT_REA_RIESGOS.DESCRIPCION_RIESGO(C.CodCia, C.CodRiesgoRea) DescRiesgoReaseguro
           , OC_GENERALES.FUN_NOMBREUSUARIO(C.CodCia, C.CodUsuario) NombreUsuario
           -- Campos adicionales
           , GT_COTIZACIONES.IDENTIFICADOR_COTIZACION(C.CodCia, C.CodEmpresa, C.IdCotizacion) ADN
           , C.FecSolicitud
           , C.HoraSolicitud
           , C.CantAsegurados
           , DECODE(SUBSTR(C.NumUnicoCotizacion, LENGTH(C.NumUnicoCotizacion) -2, 4),'000','NUEVA','RECOTIZACIóN')  TipoCotizacion
           , C.CanalFormaVenta||' - '||OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT', C.CanalFormaVenta) CanalFormaVenta
           --DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA  ,
           , C.SAMIAutorizado
           , C.NumPolRenovacion
           , C.PromedioSumaAseg
           , C.SumaAsegSAMI
           , C.AsegAdheridosPor||' - '||OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PRESCONT', C.AsegAdheridosPor) AsegAdheridosPor
           , C.PorcenContributorio
           --NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
           , C.FuenteRecursosPrima||' - '||OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC', C.FuenteRecursosPrima) FuenteRecursosPrima
           , DECODE(C.TipoProrrata,'SPRO','Sin Prorrata','D365','Prorrata Diaria 365 Días') TipoProrrata
           , C.PorcComisDir
           , C.PorcComisProm
           , C.PorcComisAgte
           , DECODE(C.IndConvenciones,'S','SI','NO') IndConvenciones
           , C.PorcConvenciones
           , C.DescGiroNegocio
           , C.TextoSuscriptor
           , C.DescActividadAseg
           , C.DescFormulaDividendos
           , C.DescCuotasPrimaNiv
           , DECODE(NVL(C.PorcenContributorio,0),0,'N','S')            EsContributorio
           , UPPER(TXT.DescGiroNegocio)                                GiroNegocio
           --P.CODTIPONEGOCIO                                          CODTIPONEGOCIO,
           , DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',C.CodTipoNegocio),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',C.CodTipoNegocio)) TipoNegocio
           --P.FUENTERECURSOSPRIMA                                     CODFUENTERECURSOS,
           , DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',C.FuenteRecursosPrima),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',C.FuenteRecursosPrima)) FuenteRecursos        
           , C.CodPaqComercial                                         CodPaqComercial
           --P.CODCATEGO                                               CODCATEGO,
           , CGO.DescCatego                                            Categoria
           --P.FORMAVENTA                                              CODCANALFORMAVENTA,
      FROM   Cotizaciones              C
         ,   Polizas_Texto_Cotizacion  TXT
         ,   Categorias                CGO       
      WHERE  C.CodCia              = nCodCia
        AND  C.CodEmpresa          = nCodEmpresa
        AND  C.FecCotizacion      >= dFecDesde
        AND  C.FecCotizacion      <= dFecHasta
        --
        AND  TXT.CodCia(+)         = C.CodCia    
        AND  TXT.CodEmpresa(+)     = C.CodEmpresa 
        AND  TXT.IdPoliza(+)       = C.IdPoliza
        --
        AND  CGO.CodCia(+)         = C.CodCia  
        AND  CGO.CodEmpresa(+)     = C.CodEmpresa 
        AND  CGO.CodTipoNegocio(+) = C.CodTipoNegocio 
        AND  CGO.CodCatego(+)      = C.CodCatego;
   BEGIN 
      cTitulo1 := NOMBRE_COMPANIA(nCodCia);
      cTitulo2 := 'LISTADO DE COTIZACIONES DEL ' || TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' AL  '|| TO_CHAR(dFecHasta, 'DD/MM/YYYY');
      cTitulo3 := ' ';
      cEncabez := 'No. Cotización|No. Unico Cotización|Código Cotizador|Descripción Cotizador|No. Cotización Ref.|No. Cotización Ant.|Status|'        ||
                  'Fecha Status|Contratante|Fecha Cotización|Fecha Vencimiento|Inicia Vigencia|Fin Vigencia|Horas Vigencia|Dias Retroactividad|'      ||
                  'Moneda|Suma Aseg. Local|Suma Aseg. Moneda|Prima Local|Prima Moneda|Tipo de Seguro|Plan Coberturas|Código dAgente|Nombre Agente|'   ||
                  'Plan de Pagos|No. Póliza Emitida|% Descuento|% Gtos. Admin.|% Gtos. Adqui.|% Utilidad|Factor Ajuste|Monto Deducible|'              ||
                  'Factor Fórmula Ded.|% Variación Emisión|Aseg. Modelo|Censos|Asegurados|Aplica ExtraPrima|Tipo de Administración|Riesgo Reaseguro|' ||
                  'Tipo de Bono|Políticas S.A.|Texto Elegibilidad|Tipo Identif. Aseg|Aseg. en Incapacidad|Usuario que Cotizó|'                        ||
                  'Numero de Clave de cotización ADN|Fecha de Solicitud de Cotización|Hora de Solicitud de Cotización|'                               ||
                  'Número de Asegurados Totales de la Cotización|No. Único Póliza Emitida|Estatus Póliza|Tipo de Cotización|Canal de Venta|'          ||
                  'SAMI Autorizado|No. Póliza a Renovar|Suma Asegurada Promedio|SAMI Calculado|Adherido Por|% Contributorio|Fuente de Recursos|'      ||
                  'Tipo de Prorrata|% Comisión Dirección|% Comisión Promotor|% Comisión Agente|Indicador de Suma A Convenciones|'                     ||
                  '% Que aplica para Convenciones|Texto Giro del Negocio|Texto Libre Suscriptor|Texto de Actividades de los Asegurados|'              ||
                  'Texto Formula de Dividendos|Texto de Cuota de Primas Niveladas|Es Contributorio|Giro de Negocio|Tipo de Negocio|'                  ||
                  'Fuente de Recursos|Paquete Comercial|Categoría';                  
      --
      INSERTA_ENCABEZADO( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo );
      --
      FOR x IN Cotizaciones LOOP
         nIdCotizacion := x.IdCotizacion;
         IF x.IdPoliza IS NOT NULL THEN
            BEGIN
               SELECT NumPolUnico, StsPoliza 
               INTO   cNumPolUnico, cStsPoliza
               FROM   POLIZAS
               WHERE  CodCia    = nCodCia
                 AND  IdPoliza  = x.IdPoliza;
            EXCEPTION
            WHEN OTHERS THEN
               cNumPolUnico := NULL;
               cStsPoliza   := NULL;
            END;
         ELSE
            cNumPolUnico := NULL;
            cStsPoliza   := NULL;
         END IF;
         --
         cRegistro := TO_CHAR(x.IdCotizacion,'9999999990')                                     || '|' ||
                      REPLACE(x.NumUnicoCotizacion, '|', '@')                                  || '|' ||
                      REPLACE(x.CodCotizador, '|', '@')                                        || '|' ||
                      REPLACE(x.DescCotizador, '|', '@')                                       || '|' ||
                      REPLACE(x.NumCotizacionRef, '|', '@')                                    || '|' ||
                      REPLACE(x.NumCotizacionAnt, '|', '@')                                    || '|' ||
                      REPLACE(x.StsCotizacion, '|', '@')                                       || '|' ||
                      TO_CHAR(x.FecStatus,'DD/MM/YYYY')                                        || '|' ||
                      REPLACE(x.NombreContratante, '|', '@')                                   || '|' ||
                      TO_CHAR(x.FecCotizacion,'DD/MM/YYYY')                                    || '|' ||
                      TO_CHAR(x.FecVenceCotizacion,'DD/MM/YYYY')                               || '|' ||
                      TO_CHAR(x.FecIniVigCot,'DD/MM/YYYY')                                     || '|' ||
                      TO_CHAR(x.FecFinVigCot,'DD/MM/YYYY')                                     || '|' ||
                      REPLACE(x.HorasVig, '|', '@')                                            || '|' ||
                      REPLACE(x.NumDiasRetroactividad, '|', '@')                               || '|' ||
                      REPLACE(x.Cod_Moneda, '|', '@')                                          || '|' ||
                      TO_CHAR(x.SumaAsegCotLocal,'999,999,999,990.00')                         || '|' ||
                      TO_CHAR(x.SumaAsegCotMoneda,'999,999,999,990.00')                        || '|' ||
                      TO_CHAR(x.PrimaCotLocal,'999,999,999,990.00')                            || '|' ||
                      TO_CHAR(x.PrimaCotMoneda,'999,999,999,990.00')                           || '|' ||
                      REPLACE((x.IdTipoSeg || '-' || x.DescIdTipoSeg), '|', '@')               || '|' ||
                      REPLACE((x.PlanCob || '-' || x.DescTipoPlan), '|', '@')                  || '|' ||
                      TO_CHAR(x.CodAgente,'9999999990')                                        || '|' ||
                      REPLACE(x.NombreAgente, '|', '@')                                        || '|' ||
                      REPLACE((x.CodPlanPago || '-' || x.DescPlanPago), '|', '@')              || '|' ||
                      TO_CHAR(x.IdPoliza,'9999999999990')                                      || '|' ||
                      TO_CHAR(x.PorcDescuento,'990.000000')                                    || '|' ||
                      TO_CHAR(x.PorcGtoAdmin,'990.000000')                                     || '|' ||
                      TO_CHAR(x.PorcGtoAdqui,'990.000000')                                     || '|' ||
                      TO_CHAR(x.PorcUtilidad,'990.000000')                                     || '|' ||
                      TO_CHAR(x.FactorAjuste,'990.000000')                                     || '|' ||
                      TO_CHAR(x.MontoDeducible,'990.000000')                                   || '|' ||
                      TO_CHAR(x.FactFormulaDeduc,'990.000000')                                 || '|' ||
                      TO_CHAR(x.PorcVariacionEmi,'990.000000')                                 || '|' ||
                      REPLACE(x.IndAsegModelo, '|', '@')                                       || '|' ||
                      REPLACE(x.IndCensoSubgrupo, '|', '@')                                    || '|' ||
                      REPLACE(x.IndListadoAseg, '|', '@')                                      || '|' ||
                      REPLACE(x.IndExtraPrima, '|', '@')                                       || '|' ||
                      REPLACE((x.TipoAdministracion || '-' || x.DescAdministracion), '|', '@') || '|' ||
                      REPLACE((x.CodRiesgoRea || '-' || x.DescRiesgoReaseguro), '|', '@')      || '|' ||
                      REPLACE((x.CodTipoBono || '-' || x.ClaseBono), '|', '@')                 || '|' ||
                      REPLACE(x.DescPoliticaSumasAseg, '|', '@')                               || '|' ||
                      REPLACE(x.DescPoliticaEdades, '|', '@')                                  || '|' ||
                      REPLACE(x.DescTipoIdentAseg, '|', '@')                                   || '|' ||
                      REPLACE(x.AsegEnIncapacidad, '|', '@')                                   || '|' ||
                      REPLACE((x.CodUsuario || '-' || x.NombreUsuario), '|', '@')              || '|' ||
                      REPLACE(x.ADN, '|', '@')                                                 || '|' ||
                      TO_CHAR(x.FecSolicitud,'DD/MM/YYYY')                                     || '|' ||
                      REPLACE(x.HoraSolicitud, '|', '@')                                       || '|' ||
                      TO_CHAR(x.CantAsegurados,'999,999,990')                                  || '|' ||
                      REPLACE(cNumPolUnico, '|', '@')                                          || '|' ||
                      REPLACE(cStsPoliza, '|', '@')                                            || '|' ||
                      REPLACE(x.TipoCotizacion, '|', '@')                                      || '|' ||
                      REPLACE(x.CanalFormaVenta, '|', '@')                                     || '|' ||
                      TO_CHAR(x.SAMIAutorizado,'999,999,999,990.00')                           || '|' ||
                      REPLACE(x.NumPolRenovacion, '|', '@')                                    || '|' ||
                      TO_CHAR(x.PromedioSumaAseg,'999,999,999,990.00')                         || '|' ||
                      TO_CHAR(x.SumaAsegSAMI,'999,999,999,990.00')                             || '|' ||
                      REPLACE(x.AsegAdheridosPor, '|', '@')                                    || '|' ||
                      TO_CHAR(x.PorcenContributorio,'990.000000')                              || '|' ||
                      REPLACE(x.FuenteRecursosPrima, '@')                                      || '|' ||
                      REPLACE(x.TipoProrrata, '|', '@')                                        || '|' ||
                      TO_CHAR(x.PorcComisDir,'990.000000')                                     || '|' ||
                      TO_CHAR(x.PorcComisProm,'990.000000')                                    || '|' ||
                      TO_CHAR(x.PorcComisAgte,'990.000000')                                    || '|' ||
                      REPLACE(x.IndConvenciones, '|', '@')                                     || '|' ||
                      TO_CHAR(x.PorcConvenciones,'990.000000')                                 || '|' ||
                      REPLACE(x.DescGiroNegocio, '|', '@')                                     || '|' ||
                      REPLACE(x.TextoSuscriptor, '|', '@')                                     || '|' ||
                      REPLACE(x.DescActividadAseg, '|', '@')                                   || '|' ||
                      REPLACE(x.DescFormulaDividendos, '|', '@')                               || '|' ||
                      REPLACE(x.DescCuotasPrimaNiv, '|', '@')                                  || '|' ||
                      REPLACE(x.EsContributorio, '|', '@')                                     || '|' ||
                      REPLACE(x.GiroNegocio, '|', '@')                                         || '|' ||
                      REPLACE(x.TipoNegocio, '|', '@')                                         || '|' ||
                      REPLACE(x.FuenteRecursos, '|', '@')                                      || '|' ||
                      REPLACE(x.CodPaqComercial, '|', '@')                                     || '|' ||
                      REPLACE(x.Categoria, '|', '@');
         --
         nFila := XLSX_BUILDER_PKG.EXCEL_DETALLE(nFila + 1, cRegistro, 1);                                        
      END LOOP;
      --
      COMMIT;
      -- 
      IF XLSX_BUILDER_PKG.EXCEL_GUARDA_LIBRO THEN
         IF ZIP_UTIL_PKG.ZIP_ARCHIVOS(cNomDirectorio, cNomArchZip, cNomArchivo) THEN       
            dbms_output.put_line('OK');
         END IF;
         OC_REPORTES_THONA.COPIA_ARCHIVO_BLOB( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomArchZip );
      END IF;
   EXCEPTION 
   WHEN OTHERS THEN 
        cError := SQLERRM;
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20225,'Error en Generación de Reporte del Listado de Cotizaciones: ' || cError);
   END LISTADO_COTIZACIONES;
END OC_REPORTES_COTIZACIONES;
/

CREATE OR REPLACE PUBLIC SYNONYM OC_REPORTES_COTIZACIONES FOR SICAS_OC.OC_REPORTES_COTIZACIONES;
/

GRANT EXECUTE ON SICAS_OC.OC_REPORTES_COTIZACIONES TO PUBLIC;
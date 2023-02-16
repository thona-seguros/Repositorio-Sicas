CREATE OR REPLACE PACKAGE          OC_REPORTES_AREATECNICA IS
   --
   --Variables globales para la información del reporte
   cTitulo1         VARCHAR2(4000);
   cTitulo2         VARCHAR2(4000);
   cTitulo3         VARCHAR2(4000);
   cTitulo4         VARCHAR2(4000);
   cEncabez         VARCHAR2(4000);
   cRegistro        VARCHAR2(4000);
   cError           VARCHAR2(2000);
   nFila            NUMBER := 1;
   --
   FUNCTION NOMBRE_COMPANIA( nCodCia NUMBER ) RETURN VARCHAR2;

   PROCEDURE INSERTA_ENCABEZADO( cFormato        VARCHAR2
                               , nCodCia         NUMBER
                               , nCodEmpresa     NUMBER
                               , cCodReporte     VARCHAR2
                               , cCodUser        VARCHAR2
                               , cNomDirectorio  VARCHAR2
                               , cNomArchivo     VARCHAR2 );

   PROCEDURE RAMOS( nCodCia         NUMBER
                  , nCodEmpresa     NUMBER
                  , dFecDesde       DATE
                  , dFecHasta       DATE
                  , cFormato        VARCHAR2
                  , cCodUser        VARCHAR2
                  , cNomArchivo     VARCHAR2
                  , cNomArchZip     VARCHAR2
                  , cNomDirectorio  VARCHAR2
                  , cCodReporte     VARCHAR2 );

END OC_REPORTES_AREATECNICA;

/

CREATE OR REPLACE PACKAGE BODY          OC_REPORTES_AREATECNICA IS

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

   PROCEDURE INSERTA_ENCABEZADO( cFormato        VARCHAR2
                               , nCodCia         NUMBER
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
      IF cFormato = 'TEXTO' THEN 
         OC_REPORTES_THONA.INSERTAR_REGISTRO( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cEncabez );
      ELSE
         --Obtiene Número de Columnas Totales
         nColsTotales := XLSX_BUILDER_PKG.EXCEL_CUENTA_COLUMNAS(cEncabez);
         --
         IF XLSX_BUILDER_PKG.EXCEL_CREAR_LIBRO(cNomDirectorio, cNomArchivo) THEN
            IF XLSX_BUILDER_PKG.EXCEL_CREAR_HOJA(cCodReporte) THEN
               --Titulos
               nFila := XLSX_BUILDER_PKG.EXCEL_HEADER(nFila + 1, cTitulo1, nColsTotales, nJustCentro, nColsLateral, nColsCentro, nColsMerge);
               nFila := XLSX_BUILDER_PKG.EXCEL_HEADER(nFila + 1, cTitulo2, nColsTotales, nJustCentro, nColsLateral, nColsCentro, nColsMerge);
               nFila := XLSX_BUILDER_PKG.EXCEL_HEADER(nFila + 1, cTitulo3, nColsTotales, nJustCentro, nColsLateral, nColsCentro, nColsMerge);
               nFila := XLSX_BUILDER_PKG.EXCEL_HEADER(nFila + 1, cTitulo4, nColsTotales, nJustCentro, nColsLateral, nColsCentro, nColsMerge);
               --Encabezado
               nFila := XLSX_BUILDER_PKG.EXCEL_ENCABEZADO(nFila + 2, cEncabez, 1);
            END IF;
         END IF;
      END IF;
   EXCEPTION 
   WHEN OTHERS THEN 
        cError := SQLERRM;
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20225, cError );
   END INSERTA_ENCABEZADO;

   PROCEDURE RAMOS( nCodCia            NUMBER
                  , nCodEmpresa        NUMBER
                  , dFecDesde          DATE
                  , dFecHasta          DATE
                  , cFormato           VARCHAR2
                  , cCodUser           VARCHAR2
                  , cNomArchivo        VARCHAR2
                  , cNomArchZip        VARCHAR2
                  , cNomDirectorio     VARCHAR2
                  , cCodReporte        VARCHAR2 ) IS
      --Variables Locales
      cUsuarioGenero  VARCHAR2(800);
      nIdTransaccion  detalle_transaccion.IdTransaccion%TYPE;  
      --
      CURSOR Registros IS
         SELECT P.IdPoliza                Poliza
              , P.NumPolUnico             Poliza_Unica
              , P.FormaVenta              Canal_de_Venta
              , P.FecIniVig               Inicio_Vigencia
              , P.FecFinVig               Fin_Vigencia
              , NVL(P.PorcDescuento , 0)  Porcentaje_Descuento
              , NVL(P.PorcGtoAdmin  , 0)  Porcent_Gtos_Administracion
              , NVL(P.PorcGtoAdqui  , 0)  Porcent_Gtos_Adquisicion
              , NVL(P.PorcUtilidad  , 0)  Porcent_Utilidad
              , NVL(P.HorasVig      , 0)  Horas_de_Vigencia
              , NVL(P.DiasVig       , 0)  Dias_de_Vigencia
              , NVL(P.MontoDeducible, 0)  Monto_Deducible
              , NVL(P.FactorAjuste  , 0)  Factor_de_Ajuste
              , NVL(P.CodTipoBono   , 0)  Tipo_Bono
              , OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CLASEBONO', P.CodTipoBono)  Dexcrip_Tipo_Bono
              , NVL(P.CodRiesgoRea , 0)  Tipo_de_Reaseguro
              , GT_REA_RIESGOS.DESCRIPCION_RIESGO(1, P.CodRiesgoRea)           Desc_Tipo_de_Reaseguro
              , NVL(P.IndExtraPrima, ' ') Indicador_ExtraPrima
              , DP.IdTipoSeg              Tipo_Seguro
              , DP.PlanCob                Plan_Cobro
              , PC.CodTipoPlan            Tipo_de_Plan
              , P.CodAgrupador            Agrupador
              , P.TipoRiesgo              Tipo_de_Riesgo
              , OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPRIESG', P.TipoRiesgo)    Describe_Riesgo
         FROM   POLIZAS          P,
                DETALLE_POLIZA   DP,
                PLAN_COBERTURAS  PC 
         WHERE  DP.IdPoliza     = P.IdPoliza 
           AND  DP.IdetPol      = 1
           AND  DP.CodCia       = P.CodCia
           AND  PC.CodEmpresa   = DP.CodEmpresa
           AND  PC.CodCia       = DP.CodCia
           AND  PC.PlanCob      = DP.PlanCob
           AND  P.FecIniVig     BETWEEN  dFecDesde AND dFecHasta
           AND  P.CodCia        = nCodCia
           AND  P.StsPoliza     NOT IN ('SOL', 'PLD')
           AND  PC.CodTipoPlan  IN  ('011','012','031','033')
        ORDER BY P.IdPoliza, P.FecIniVig;
   --
   BEGIN
      -- Elimina Registros del Reporte
      DELETE TEMP_REPORTES_THONA
      WHERE  CodCia     = nCodCia
        AND  CodEmpresa = nCodEmpresa
        AND  CodReporte = cCodReporte
        AND  CodUsuario = cCodUser;
      --
      COMMIT;
      --
      cTitulo1 := NOMBRE_COMPANIA(nCodCia);
      cTitulo2 := 'REPORTE DE POLIZAS RAMOS 11 12 31 33_ ' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MMSS');
      cTitulo3 := ' ';
      cTitulo4 := ' ';
      cEncabez := 'Póliza|Póliza Única|Canal de Venta|Inicio de Vigencia|Fin de Vigencia|Porcentaje de Descuento|Porcentaje de Gastos de Administración|' ||
                  'Porcentaje de Gastos de Adquisición|Porcentaje de Utilidad|Horas de Vigencia|Días de Vigencia|Monto_Deducible|Factor de Ajuste|'       ||
                  'Tipo de Bono|Descripción del Tipo de Bono|Tipo de Reaseguro|Descripción de Tipo de Reaseguro|Indicador ExtraPrima|Tipo de Seguro|'     ||
                  'Plan de Cobro|Tipo de Plan|Agrupador|Tipo de Riesgo|Descripcion de Riesgo|Usuario que Generó';  
      --
      INSERTA_ENCABEZADO( cFormato, nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo );
      --
      FOR W IN Registros LOOP
         BEGIN
            SELECT MAX(IdTransaccion)  
            INTO   nIdTransaccion
            FROM   DETALLE_TRANSACCION 
            WHERE  CodSubProceso ='POL' 
              AND  TO_NUMBER(Valor1) = W.Poliza;
         EXCEPTION
         WHEN OTHERS THEN
            nIdTransaccion := NULL;
         END;
         --
         BEGIN
            SELECT OC_USUARIOS.NOMBRE_USUARIO(NVL(nCodCia, 1), UsuarioGenero) 
            INTO   cUsuarioGenero
            FROM   TRANSACCION 
            WHERE  IdTransaccion = nIdTransaccion;
         EXCEPTION
         WHEN OTHERS THEN
            cUsuarioGenero := NULL;
         END;
         --
         cRegistro := TO_CHAR(W.Poliza,'999999999')           || '|' ||
                      W.Poliza_Unica                          || '|' ||
                      W.Canal_de_Venta                        || '|' ||
                      TO_CHAR(W.Inicio_Vigencia,'DD/MM/YYYY') || '|' ||
                      TO_CHAR(W.Fin_Vigencia,'DD/MM/YYYY')    || '|' ||
                      W.Porcentaje_Descuento                  || '|' ||
                      W.Porcent_Gtos_Administracion           || '|' ||
                      W.Porcent_Gtos_Adquisicion              || '|' ||
                      W.Porcent_Utilidad                      || '|' ||
                      W.Horas_de_Vigencia                     || '|' ||
                      W.Dias_de_Vigencia                      || '|' ||
                      W.Monto_Deducible                       || '|' ||
                      W.Factor_de_Ajuste                      || '|' ||
                      W.Tipo_Bono                             || '|' ||
                      W.Dexcrip_Tipo_Bono                     || '|' ||
                      W.Tipo_de_Reaseguro                     || '|' ||
                      W.Desc_Tipo_de_Reaseguro                || '|' ||
                      W.Indicador_ExtraPrima                  || '|' ||
                      W.Tipo_Seguro                           || '|' ||
                      W.Plan_Cobro                            || '|' ||
                      W.Tipo_de_Plan                          || '|' ||
                      W.Agrupador                             || '|' ||
                      W.Tipo_de_Riesgo                        || '|' ||
                      W.Describe_Riesgo                       || '|' ||
                      cUsuarioGenero;
         -- 
         IF cFormato = 'TEXTO' THEN
            OC_REPORTES_THONA.INSERTAR_REGISTRO( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cRegistro );
         ELSE
            nFila := XLSX_BUILDER_PKG.EXCEL_DETALLE(nFila + 1, cRegistro, 1);                                        
         END IF;
      END LOOP;
      --
      COMMIT;
      -- 
      IF cFormato = 'TEXTO' THEN
         OC_REPORTES_THONA.GENERA_REPORTE( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomArchivo, cNomArchZip );
         OC_REPORTES_THONA.COPIA_ARCHIVO_BLOB( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomArchZip );
      ELSE
         IF XLSX_BUILDER_PKG.EXCEL_GUARDA_LIBRO THEN
            IF ZIP_UTIL_PKG.ZIP_ARCHIVOS(cNomDirectorio, cNomArchZip, cNomArchivo) THEN       
               dbms_output.put_line('OK');
            END IF;
            OC_REPORTES_THONA.COPIA_ARCHIVO_BLOB( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomArchZip );
         END IF;
      END IF;
   EXCEPTION 
   WHEN OTHERS THEN 
        cError := SQLERRM;
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20225,'Error en Generación del Reporte de Ramos: ' || cError);
   END RAMOS;

END OC_REPORTES_AREATECNICA;

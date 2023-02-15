CREATE OR REPLACE PACKAGE          OC_REPORTES_REASEGURO IS
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
                               
   PROCEDURE TRANSACCION_POLIZA( cIdPoliza          VARCHAR2
                               , cIDetPol           VARCHAR2
                               , cIdEndoso          VARCHAR2
                               , nIdTransaccionIni  NUMBER
                               , nIdTransaccionFin  NUMBER
                               , dFecDesde          DATE
                               , dFecHasta          DATE
                               , nCodCia            NUMBER
                               , cNumPolUnico       VARCHAR2
                               , cFormato           VARCHAR2
                               , cDescIDetPol       VARCHAR2
                               , cDescIdEndoso      VARCHAR2
                               , cDescPoliza        VARCHAR2
                               , nCodEmpresa        NUMBER
                               , cCodUser           VARCHAR2
                               , cNomArchivo        VARCHAR2
                               , cNomArchZip        VARCHAR2
                               , cNomDirectorio     VARCHAR2
                               , cCodReporte        VARCHAR2 );

   PROCEDURE REASEGURADOR_POLIZA( cIdPoliza          VARCHAR2
                                , cIDetPol           VARCHAR2
                                , cIdEndoso          VARCHAR2
                                , nIdTransaccionIni  NUMBER
                                , nIdTransaccionFin  NUMBER
                                , dFecDesde          DATE
                                , dFecHasta          DATE
                                , nCodCia            NUMBER
                                , cNumPolUnico       VARCHAR2
                                , cFormato           VARCHAR2
                                , cDescIDetPol       VARCHAR2
                                , cDescIdEndoso      VARCHAR2
                                , cDescPoliza        VARCHAR2
                                , nCodEmpresa        NUMBER
                                , cCodUser           VARCHAR2
                                , cNomArchivo        VARCHAR2
                                , cNomArchZip        VARCHAR2
                                , cNomDirectorio     VARCHAR2
                                , cCodReporte        VARCHAR2 );

   PROCEDURE TRANSACCION_SINIESTRO( cIdSiniestro       VARCHAR2
                                  , nIdTransaccionIni  NUMBER
                                  , nIdTransaccionFin  NUMBER
                                  , dFecDesde          DATE
                                  , dFecHasta          DATE
                                  , cIdPoliza          VARCHAR2
                                  , nCodCia            NUMBER
                                  , cFormato           VARCHAR2
                                  , nCodEmpresa        NUMBER
                                  , cCodUser           VARCHAR2
                                  , cNomArchivo        VARCHAR2
                                  , cNomArchZip        VARCHAR2
                                  , cNomDirectorio     VARCHAR2
                                  , cCodReporte        VARCHAR2 );

   PROCEDURE REASEGURADOR_SINIESTRO( cIdSiniestro       VARCHAR2
                                   , nIdTransaccionIni  NUMBER
                                   , nIdTransaccionFin  NUMBER
                                   , dFecDesde          DATE
                                   , dFecHasta          DATE
                                   , cIdPoliza          VARCHAR2
                                   , nCodCia            NUMBER
                                   , cFormato           VARCHAR2
                                   , nCodEmpresa        NUMBER
                                   , cCodUser           VARCHAR2
                                   , cNomArchivo        VARCHAR2
                                   , cNomArchZip        VARCHAR2
                                   , cNomDirectorio     VARCHAR2
                                   , cCodReporte        VARCHAR2 );

   PROCEDURE TRANSACCION_ESQUEMA( cIdPoliza          VARCHAR2
                                , cCodEsquema        VARCHAR2
                                , nIdTransaccionIni  NUMBER
                                , nIdTransaccionFin  NUMBER
                                , dFecDesde          DATE
                                , dFecHasta          DATE
                                , cDescPoliza        VARCHAR2
                                , cDescEsquema       VARCHAR2 
                                , nCodCia            NUMBER
                                , cFormato           VARCHAR2
                                , nCodEmpresa        NUMBER
                                , cCodUser           VARCHAR2
                                , cNomArchivo        VARCHAR2
                                , cNomArchZip        VARCHAR2
                                , cNomDirectorio     VARCHAR2
                                , cCodReporte        VARCHAR2 );

   PROCEDURE REASEGURADOR_ESQUEMA( cIdPoliza          VARCHAR2
                                 , cCodEsquema        VARCHAR2
                                 , nIdTransaccionIni  NUMBER
                                 , nIdTransaccionFin  NUMBER
                                 , dFecDesde          DATE
                                 , dFecHasta          DATE
                                 , cDescPoliza        VARCHAR2
                                 , cDescIDetPol       VARCHAR2
                                 , cDescIdEndoso      VARCHAR2
                                 , nCodCia            NUMBER
                                 , cFormato           VARCHAR2
                                 , nCodEmpresa        NUMBER
                                 , cCodUser           VARCHAR2
                                 , cNomArchivo        VARCHAR2
                                 , cNomArchZip        VARCHAR2
                                 , cNomDirectorio     VARCHAR2
                                 , cCodReporte        VARCHAR2 );

   PROCEDURE SINIESTRO_RECUPERADO( cIdPoliza           VARCHAR2
                                 , cIdSiniestro        VARCHAR2
                                 , cCodEmpGrem         VARCHAR2
                                 , cIdTipoSeg          VARCHAR2
                                 , cCodEsqema          VARCHAR2
                                 , cContrato           VARCHAR2
                                 , cStsSiniestro       VARCHAR2
                                 , dFecDesde           DATE
                                 , dFecHasta           DATE
                                 , cDescIntermediario  VARCHAR2
                                 , cDescEsquema        VARCHAR2
                                 , cDescContrato       VARCHAR2
                                 , cDescripRamo        VARCHAR2
                                 , nCodCia             NUMBER
                                 , cFormato            VARCHAR2
                                 , nCodEmpresa         NUMBER
                                 , cCodUser            VARCHAR2
                                 , cNomArchivo        VARCHAR2
                                 , cNomArchZip        VARCHAR2
                                 , cNomDirectorio     VARCHAR2
                                 , cCodReporte        VARCHAR2 );
                                 
   PROCEDURE CALENDARIOS( nCodCia       NUMBER
                        , dFecDesde     DATE
                        , dFecHasta     DATE
                        , cCodEsquema   VARCHAR2
                        , cCodContrato  VARCHAR2
                        , cFormato      VARCHAR2 );                                 

END OC_REPORTES_REASEGURO;
/

create or replace PACKAGE BODY          OC_REPORTES_REASEGURO IS

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

   PROCEDURE TRANSACCION_POLIZA( cIdPoliza          VARCHAR2
                               , cIDetPol           VARCHAR2
                               , cIdEndoso          VARCHAR2
                               , nIdTransaccionIni  NUMBER
                               , nIdTransaccionFin  NUMBER
                               , dFecDesde          DATE
                               , dFecHasta          DATE
                               , nCodCia            NUMBER
                               , cNumPolUnico       VARCHAR2
                               , cFormato           VARCHAR2
                               , cDescIDetPol       VARCHAR2
                               , cDescIdEndoso      VARCHAR2
                               , cDescPoliza        VARCHAR2
                               , nCodEmpresa        NUMBER
                               , cCodUser           VARCHAR2
                               , cNomArchivo        VARCHAR2
                               , cNomArchZip        VARCHAR2
                               , cNomDirectorio     VARCHAR2
                               , cCodReporte        VARCHAR2 ) IS
      --Variables Locales
      cNumPolUnico1     POLIZAS.NumPolUnico%TYPE;
      cCodContrato      REA_TIPOS_CONTRATOS.CodContrato%TYPE;
      cDescContrato     REA_TIPOS_CONTRATOS.NomContrato%TYPE;
      nPrimaTotal       FACTURAS.Monto_Fact_Moneda%TYPE;
      nSumaAsegDistrib  NUMBER(28,2);
      nPrimaDistrib     NUMBER(32,6);
      cIndDistFacult    VARCHAR2(2) := 'NO';
      cDatosVehiculo    VARCHAR2(100);
      --
      CURSOR DISTREA_Q IS
         SELECT /*+ INDEX(DT SYS_C0031885) */ RD.IdDistribRea
              , RD.NumDistrib
              , RD.CodGrupoCobert
              , RD.CodEsquema
              , RD.IdEsqContrato
              , RD.CapacidadMaxima
              , RD.Cod_Asegurado
              , RD.PorcDistrib
              , RD.SumaAsegDistrib
              , RD.PrimaDistrib
              , RD.MontoReserva
              , NVL(TRIM(PNJ3.Nombre) ||' ' || TRIM(PNJ3.Apellido_Paterno) || ' ' || TRIM(PNJ3.Apellido_Materno) || ' ' ||
                DECODE(PNJ3.ApeCasada, NULL, '', ' de ' || PNJ3.ApeCasada), 'Asegurado - NO EXISTE!!!') NomAsegurado
              , NVL(RE.DescEsquema, 'Esquema de Reaseguro/Coaseguro ')                    Esquema
              , RD.CodRiesgoReaseg
              , RD.FecVigInicial
              , RD.FecVigFinal
              , RD.FecMovDistrib
              , RD.IdCapaContrato
              , RD.IdPoliza
              , RD.IDetPol
              , RD.IdEndoso
              , RD.CodCia
              , RD.IdTransaccion
              , P.NumPolUnico                                                             NumPolUnico1
              , REC.CodContrato
              , GT_REA_TIPOS_CONTRATOS.NOMBRE_CONTRATO(REC.CodCia, REC.CodContrato)       DescContrato
           FROM REA_DISTRIBUCION          RD
              , DETALLE_TRANSACCION       DT
              , TRANSACCION               TR
              , REA_ESQUEMAS              RE 
              , PERSONA_NATURAL_JURIDICA  PNJ3
              , ASEGURADO                 A
              , POLIZAS                   P
              , REA_ESQUEMAS_CONTRATOS    REC
          WHERE RD.CodCia             = DT.CodCia
            AND RD.IdTransaccion      = DT.IdTransaccion
            AND RD.IdPoliza           = DT.Valor1 
            AND RD.IDetPol            = NVL(DT.Valor2,1) 
            AND RD.IdEndoso           = NVL(DT.Valor3,0)
            AND DT.Codcia             = nCodCia
            AND DT.Codempresa         = nCodEmpresa
            AND RE.CODCIA(+)          = RD.CODCIA
            AND RE.CODESQUEMA(+)      = RD.CODESQUEMA
            AND PNJ3.Tipo_Doc_Identificacion(+) = A.Tipo_Doc_Identificacion
            AND PNJ3.Num_Doc_Identificacion(+)  = A.Num_Doc_Identificacion
            AND A.CodCia(+)                     = RD.CODCIA
            AND A.CodEmpresa(+)                 = nCodEmpresa
            AND A.Cod_Asegurado(+)              = RD.COD_ASEGURADO
            AND DT.IdTransaccion BETWEEN NVL(nIdTransaccionIni,0) AND NVL(nIdTransaccionFin,99999999999999999999)
            AND DT.MtoLocal          != 0
            AND UPPER(DT.Objeto)      IN ('DETALLE_POLIZA', 'ENDOSOS')
            AND ( ( NVL(DT.Valor1,'%') LIKE cIdPoliza AND cIdPoliza IS NOT NULL )
                  OR
                  ( NVL(DT.Valor1,'%') IN ( SELECT IdPoliza
                                              FROM POLIZAS
                                             WHERE CodCia      = nCodCia
                                               AND NumPolUnico = cNumPolUnico ) AND cNumPolUnico != '%' )
                )
            AND NVL(DT.Valor2,'%') LIKE cIDetPol
            AND NVL(DT.Valor3,'%') LIKE cIdEndoso
            AND TR.CodCia              = DT.CodCia
            AND TR.Codempresa          = DT.Codempresa
            AND TR.IdTransaccion       = DT.IdTransaccion
            AND TR.Idtransaccion       = DT.Idtransaccion
            AND TR.FechaTransaccion   >= NVL(dFecDesde,TR.FechaTransaccion)
            AND TR.FechaTransaccion   <= NVL(dFecHasta,TR.FechaTransaccion)
            AND P.IdPoliza(+)         = RD.IdPoliza
            AND P.CodCia(+)           = RD.CodCia
            AND REC.CodCia            = RD.CodCia
            AND REC.CodEsquema(+)     = RD.CodEsquema
            AND REC.IdEsqContrato(+)  = RD.IdEsqContrato
          ORDER BY RD.IdTransaccion, RD.IdDistribRea, RD.NumDistrib;
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
      cTitulo2 := 'REPORTE DISTRIBUCIÓN DE REASEGURO DE LA TRANSACCION' || TO_CHAR(nIdTransaccionIni) || ' A ' || TO_CHAR(nIdTransaccionFin);
      cTitulo3 := 'DE LA PÓLIZA ' || TO_CHAR(cIdPoliza) || ' DETALLE: ' || cDescIDetPol || ' ENDOSO: ' || cDescIdEndoso;
      cTitulo4 := ' ';
      cEncabez := 'No. de Póliza Único|Consecutivo|No. Detalle de Póliza|No. Endoso|No. Distribución|Orden|Grupo Cobertura|Capacidad Máxima|% Distribución|' ||
                  'Suma Aseg. Distribuida|Prima Distribuida|Monto de Reserva|Código Asegurado|Nombre Asegurado|Esquema de Reaseguro|Contrato de Reaseguro|'  ||
                  'No. Capa Contrato|Riesgo de Reaseguro|Inicio Vigencia Transacción|Fin Vigencia Transacción|Fecha Distribución|Necesita Distribución Facultativa'; 
      --
      INSERTA_ENCABEZADO( cFormato, nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo );
      --
      FOR W IN DISTREA_Q LOOP
         cNumPolUnico1 := NVL(W.NumPolUnico1, 'NO EXISTE');
         cCodContrato  := W.CodContrato;
         cDescContrato := NVL(W.DescContrato, 'NO EXISTE CONTRATO');
         --
         IF GT_REA_TIPOS_CONTRATOS.CONTRATO_FACULTATIVO(nCodCia, cCodContrato) = 'S' THEN
            SELECT NVL(SUM(SumaAsegDistrib),0), NVL(SUM(PrimaDistrib),0)
              INTO nSumaAsegDistrib, nPrimaDistrib
              FROM REA_DISTRIBUCION_EMPRESAS
             WHERE CodCia       = W.CodCia
               AND IdDistribRea = W.IdDistribRea
               AND NumDistrib   = W.NumDistrib;
            --
            IF nSumaAsegDistrib != W.SumaAsegDistrib OR
               nPrimaDistrib    != W.PrimaDistrib THEN
               cIndDistFacult := 'SI';
            END IF;
         END IF;
         --
         cRegistro := cNumPolUnico1                                   || '|' ||
                      TO_CHAR(W.IdPoliza,'9999999999999')             || '|' ||
                      TO_CHAR(W.IDetPol,'9999999999999')              || '|' ||
                      TO_CHAR(W.IdEndoso,'9999999999999')             || '|' ||
                      TO_CHAR(W.IdDistribRea,'9999999999999')         || '|' ||
                      TO_CHAR(W.NumDistrib,'9999999999999')           || '|' ||
                      W.CodGrupoCobert                                || '|' ||
                      TO_CHAR(W.CapacidadMaxima,'99999999999990.00')  || '|' ||
                      TO_CHAR(W.PorcDistrib,'9999999990.000000')      || '|' ||
                      TO_CHAR(W.SumaAsegDistrib,'99999999999990.00')  || '|' ||
                      TO_CHAR(W.PrimaDistrib,'99999999999990.000000') || '|' ||
                      TO_CHAR(W.MontoReserva,'99999999999990.000000') || '|' ||
                      TO_CHAR(W.Cod_Asegurado,'9999999999999')        || '|' ||
                      W.NomAsegurado                                  || '|' ||
                      W.Esquema                                       || '|' ||
                      cDescContrato                                   || '|' ||
                      TO_CHAR(W.IdCapaContrato,'9999999999999')       || '|' ||
                      W.CodRiesgoReaseg                               || '|' ||
                      TO_CHAR(W.FecVigInicial,'DD/MM/YYYY')           || '|' ||
                      TO_CHAR(W.FecVigFinal,'DD/MM/YYYY')             || '|' ||
                      TO_CHAR(W.FecMovDistrib,'DD/MM/YYYY')           || '|' ||
                      cIndDistFacult;
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
        RAISE_APPLICATION_ERROR(-20225,'Error en Generación de Reporte Reaseguro Por Transacción de la Póliza: ' || cError);
   END TRANSACCION_POLIZA;

   PROCEDURE REASEGURADOR_POLIZA( cIdPoliza          VARCHAR2
                                , cIDetPol           VARCHAR2
                                , cIdEndoso          VARCHAR2
                                , nIdTransaccionIni  NUMBER
                                , nIdTransaccionFin  NUMBER
                                , dFecDesde          DATE
                                , dFecHasta          DATE
                                , nCodCia            NUMBER
                                , cNumPolUnico       VARCHAR2
                                , cFormato           VARCHAR2
                                , cDescIDetPol       VARCHAR2
                                , cDescIdEndoso      VARCHAR2
                                , cDescPoliza        VARCHAR2
                                , nCodEmpresa        NUMBER
                                , cCodUser           VARCHAR2
                                , cNomArchivo        VARCHAR2
                                , cNomArchZip        VARCHAR2
                                , cNomDirectorio     VARCHAR2
                                , cCodReporte        VARCHAR2 ) IS
      --Variables Locales
      cNumPolUnico1       POLIZAS.NumPolUnico%TYPE;
      cCodContrato        REA_TIPOS_CONTRATOS.CodContrato%TYPE;
      cDescContrato       REA_TIPOS_CONTRATOS.NomContrato%TYPE;
      nSumaAsegDistrib    NUMBER(28,2);
      nPrimaDistrib       NUMBER(32,6);
      cIndDistFacult      VARCHAR2(2) := 'NO';
      nPrimaTotal         FACTURAS.Monto_Fact_Moneda%TYPE;
      nPrimaTotalNoDev    FACTURAS.Monto_Fact_Moneda%TYPE;
      nPrimaTotalDev      FACTURAS.Monto_Fact_Moneda%TYPE;
      dFecIniVig          POLIZAS.FecIniVig%TYPE;
      dFecFinVig          POLIZAS.FecFinVig%TYPE;
      nCodCliente         POLIZAS.CodCliente%TYPE;
      cNomCliente         VARCHAR2(500);
      cNomCobert          COBERTURAS_DE_SEGUROS.DescCobert%TYPE;
      nEdadAseg           NUMBER(3);
      dFecIngreso         DATE;
      nSumaAsegCobert     COBERTURAS_DE_SEGUROS.SumaAsegMaxima%TYPE;
      nPrimaCobert        COBERTURAS_DE_SEGUROS.Prima_Cobert%TYPE;
      --
      nIdEndosoAlta       REA_DISTRIBUCION.IdEndoso%TYPE;
      nIdEndosoBaja       REA_DISTRIBUCION.IdEndoso%TYPE;
      dFecEndosAlta       DATE;
      dFecEndosBaja       DATE;
      --
      cTieneSiniestros    VARCHAR2(2);
      --
      nPrimasDirectas     REA_ESQUEMAS_POLIZAS.PrimasDirectas%TYPE;
      nFactorReaseg       REA_ESQUEMAS_POLIZAS.FactorReaseg%TYPE;
      nPrimasCedidas      REA_ESQUEMAS_POLIZAS.PrimasCedidas%TYPE;
      nTotalPrimasReaseg  REA_ESQUEMAS_POLIZAS.TotalPrimasReaseg%TYPE;
      nFactorCesion       REA_ESQUEMAS_POLIZAS.FactorCesion%TYPE;
      nPrimaDeveng        REA_ESQUEMAS_POLIZAS.PrimasDirectas%TYPE := 0;
      --
      nIdPoliza           POLIZAS.IdPoliza%TYPE;
      nIdPolizaAfin       NUMBER;
      nIDetpolAfin        NUMBER;
      nCodCiaAfin         NUMBER;
      cCodGrupoCobertAfin VARCHAR2(500);
      --
      CURSOR DISTREA_Q IS
         SELECT /*+ INDEX(DT SYS_C0031885) */ RD.IdDistribRea
              , RD.NumDistrib
              , RD.CodGrupoCobert
              , RD.CodEsquema
              , RD.IdEsqContrato
              , RD.Cod_Asegurado
              , RD.IdCapaContrato
              , NVL(TRIM(PNJ3.Nombre) ||' ' || TRIM(PNJ3.Apellido_Paterno) || ' ' || TRIM(PNJ3.Apellido_Materno) || ' ' ||
                DECODE(PNJ3.ApeCasada, NULL, '', ' de ' || PNJ3.ApeCasada), 'Asegurado - NO EXISTE!!!') NomAsegurado
              , PNJ3.FecNacimiento
              , NVL(RE.DescEsquema,'Esquema de Reaseguro/Coaseguro ') Esquema
              , RD.CodRiesgoReAseg
              , RD.IdPoliza
              , RD.IdetPol
              , RD.IdEndoso
              , RD.CodCia
              , RDE.CodEmpresaGremio
              , NVL(TRIM(PNJ2.Nombre) || ' ' || TRIM(PNJ2.Apellido) || ' ' || TRIM(PNJ2.ApeCasada), 'Empresa del Gremio - NO EXISTE!!!') NombreReAsegurador
              , RDE.CodInterReAseg
              , RD.FecVigInicial
              , RD.FecVigFinal
              , RD.FecMovDistrib
              , TRIM(PNJ.Nombre) || ' ' || TRIM(PNJ.Apellido) || ' ' || TRIM(PNJ.ApeCasada) NomInterReAseg
              , GT_REA_ESQUEMAS_EMPRESAS.PORCENTAJE(RD.CodCia, RD.CodEsquema, RD.IdEsqContrato, RD.IdCapaContrato, RDE.CodEmpresaGremio, RDE.CodInterReaseg, 'PCOB') PorcComis
              , RDE.FecLiberacionRvas
              , RDE.ImprvasLiberadas
              , RDE.IntrvasLiberadas
              , RDE.PorcDistrib
              , RDE.PrimaDistrib
              , RDE.MontoComision
              , RDE.MontoReserva
              , RDE.IdLiquidacion
              , RDE.SumaAsegDistrib
              , DT.CodEmpresa
              , RD.CapacidadMaxima
              , TR.FechaTransaccion  
              , NVL(M.Desc_Moneda, 'Código de Moneda '|| RD.Codmoneda || ' NO EXISTE')      Moneda
              , RD.IdTransaccion
              , NVL(PC.Descripcion_Proceso, 'PROCESO NO EXISTE')                            Proceso
              , PNJ3.FecIngreso                                                             FecIngreso
              , FLOOR((TRUNC(SYSDATE) - TRUNC(NVL(PNJ3.FecNacimiento, SYSDATE))) / 365.25)  EdadAseg
              , P.NumPolUnico                                                               NumPolUnico1
              , P.FecIniVig
              , P.FecFinVig
              , P.CodCliente
              , OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente)                                    NomCliente
              , P.FecEmision
              , P.FecAnul
              , REC.CodContrato
              , GT_REA_TIPOS_CONTRATOS.NOMBRE_CONTRATO(REC.CodCia, REC.CodContrato)         DescContrato
              , REP.PrimasDirectas
              , REP.FactorReaseg
              , REP.PrimasCedidas
              , REP.TotalPrimasReaseg
              , REP.FactorCesion
           FROM REA_DISTRIBUCION           RD
              , DETALLE_TRANSACCION        DT
              , REA_DISTRIBUCION_EMPRESAS  RDE
              , TRANSACCION                TR
              , REA_ESQUEMAS               RE
              , MONEDA                     M
              , PROC_TAREA                 PC
              , PERSONA_NATURAL_JURIDICA   PNJ
              , REA_EMPRESAS_GREMIO        REG
              , PERSONA_NATURAL_JURIDICA   PNJ2
              , REA_EMPRESAS_GREMIO        REG2
              , PERSONA_NATURAL_JURIDICA   PNJ3
              , ASEGURADO                  A
              , POLIZAS                    P
              , REA_ESQUEMAS_CONTRATOS     REC
              , REA_ESQUEMAS_POLIZAS       REP
          WHERE RD.Codcia                       = DT.Codcia
            AND RD.Iddistribrea                 > 0
            AND RD.Numdistrib                   > 0
            AND RD.Idtransaccion                = DT.Idtransaccion
            AND RD.Idpoliza                     = TO_NUMBER (DT.Valor1)
            AND RD.Idetpol                      = NVL(TO_NUMBER(DT.Valor2), 1)
            AND RD.Idendoso                     = NVL(DT.Valor3, 0)
            AND DT.Codcia                       = nCodCia
            AND DT.Codempresa                   = nCodEmpresa
            AND RE.Codcia(+)                    = RD.Codcia
            AND RE.Codesquema(+)                = RD.Codesquema
            AND M.Cod_Moneda(+)                 = RD.Codmoneda
            AND PC.IdProceso(+)                 = TR.Idproceso
            AND PNJ.Tipo_Doc_Identificacion(+)  = REG.Tipo_Doc_Identificacion
            AND PNJ.Num_Doc_Identificacion(+)   = REG.Num_Doc_Identificacion
            AND REG.CodCia(+)                   = RDE.Codcia
            AND REG.CodEmpresaGremio(+)         = RDE.Codinterreaseg
            AND PNJ2.Tipo_Doc_Identificacion(+) = REG2.Tipo_Doc_Identificacion
            AND PNJ2.Num_Doc_Identificacion(+)  = REG2.Num_Doc_Identificacion
            AND REG2.CodCia(+)                  = RDE.Codcia
            AND REG2.CodEmpresaGremio(+)        = RDE.Codempresagremio
            AND PNJ3.Tipo_Doc_Identificacion(+) = A.Tipo_Doc_Identificacion
            AND PNJ3.Num_Doc_Identificacion(+)  = A.Num_Doc_Identificacion
            AND A.CodCia(+)                     = RD.CODCIA
            AND A.CodEmpresa(+)                 = nCodEmpresa
            AND A.Cod_Asegurado(+)              = RD.COD_ASEGURADO
            AND DT.Idtransaccion          BETWEEN NVL (nIdTransaccionIni, 0) AND NVL (nIdTransaccionFin, 99999999999999999999)
            AND DT.Correlativo                  > 0
            AND UPPER(DT.Objeto)               IN ('DETALLE_POLIZA', 'ENDOSOS')
            AND (  ( NVL (DT.Valor1, '%') LIKE cIdPoliza AND cIdPoliza IS NOT NULL)
                OR ( NVL (DT.Valor1, '%') IN ( SELECT Idpoliza
                                                 FROM POLIZAS
                                                WHERE Codcia      = nCodCia
                                                  AND Numpolunico = cNumPolUnico ) AND cNumPolUnico != '%') )
            AND NVL (DT.Valor2, '%') LIKE cIDetPol
            AND NVL (DT.Valor3, '%') LIKE cIdEndoso
            AND TR.Codcia               = DT.Codcia
            AND TR.Idtransaccion        = DT.Idtransaccion
            AND RDE.Codcia              = RD.Codcia
            AND RDE.Iddistribrea        = RD.Iddistribrea
            AND RDE.Numdistrib          = RD.NUMDISTRIB
            AND RDE.Codempresagremio   IS NOT NULL
            AND RDE.Codinterreaseg     IS NOT NULL
            AND TR.Codcia               = DT.Codcia
            AND TR.Codempresa           = DT.Codempresa
            AND TR.Idtransaccion        = DT.Idtransaccion
            AND TR.Fechatransaccion    >= NVL (dFecDesde, TR.Fechatransaccion)
            AND TR.Fechatransaccion    <= NVL (dFecHasta, TR.Fechatransaccion)
            AND P.IdPoliza(+)           = RD.IdPoliza
            AND P.CodCia(+)             = RD.CodCia
            AND REC.CodCia              = RD.CodCia
            AND REC.CodEsquema(+)       = RD.CodEsquema
            AND REC.IdEsqContrato(+)    = RD.IdEsqContrato
            AND REP.CodCia(+)           = RD.CodCia
            AND REP.IdPoliza(+)         = RD.IdPoliza
            AND REP.CodEsquema(+)       = RD.CodEsquema
         ORDER BY RD.IDTRANSACCION
                , RD.IDDISTRIBREA
                , RD.NUMDISTRIB
                , RDE.CODEMPRESAGREMIO
                , RDE.CODINTERREASEG;
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
      cTitulo2 := 'REPORTE DISTRIBUCIÓN DE REASEGURO DETALLE POR REASEGURADOR, PÓLIZA: ' || cDescPoliza;
      cTitulo3 := ' DETALLE: ' || cDescIDetPol || ' ENDOSO: ' || cDescIdEndoso;
      cTitulo4 := ' ';
      cEncabez := 'No. de Póliza Único|No. de Póliza Consecutivo|Inicio Vigencia Póliza|Fin Vigencia Póliza|No. Detalle de Póliza|Contratante|Código Cliente|' ||
                  'No. Endoso|No. Distribución|Orden|Cobertura|Desc. Cobertura|Código Asegurado|Nombre Asegurado|Fecha de Nacimiento|Edad|Fecha Ingreso|'      ||
                  'Esquema de Reaseguro|Contrato de Reaseguro|No. Capa Contrato|Código Reasegurador|Nombre Reasegurador|Código Intermediario Reaseguro|'       ||
                  'Nombre Intermediario Reaseguro|Capacidad Máxima|% Distribución|Suma Asegurada Distribuida|Prima Distribuida|% Comisión de Reaseguro|'       ||
                  'Comisión Reaseguro|Monto 100% SA Cobertura|Monto 100% Prima Reaseguro Cobertura|No. Liquidación|Fecha de Alta|Endoso con el que se dió de Alta|' ||
                  'Fecha de Baja|Endoso con el que se dió de Baja|Tiene Siniestro|Fecha Cancelación|Prima Devengada|Riesgo de Reaseguro|Fecha Distribución|'   ||
                  'No. de Transacción|Descrip. Transacción|Año-Mes de Movimiento|Moneda|Necesita Distribución Facultativa|Primas Directas|Factor Reaseguro|'   ||
                  'Primas Cedidas|Total Primas Reaseguro|Factor Cesión'; 
      --
      INSERTA_ENCABEZADO( cFormato, nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo );
      --
      FOR W IN DISTREA_Q LOOP
         cNumPolUnico1  := NVL(W.NumPolUnico1, 'NO EXISTE');
         dFecIniVig     := W.FecIniVig;
         dFecFinVig     := W.FecFinVig;
         nCodCliente    := W.CodCliente;
         cNomCliente    := W.NomCliente;
         dFecEndosAlta  := W.FecEmision;
         dFecEndosBaja  := W.FecAnul;
         --
         IF nIdPoliza IS NULL THEN
            nIdPoliza := W.IdPoliza;
            --
            SELECT DECODE(COUNT(*), 0, 'NO', 'SI')
            INTO   cTieneSiniestros
            FROM   SINIESTRO
            WHERE  CodCia   = W.CodCia
              AND  IdPoliza = W.IdPoliza;
            --
         ELSIF nIdPoliza <> W.IdPoliza THEN
            nIdPoliza := W.IdPoliza;
            --
            SELECT DECODE(COUNT(*), 0, 'NO', 'SI')
            INTO   cTieneSiniestros
            FROM   SINIESTRO
            WHERE  CodCia   = W.CodCia
              AND  IdPoliza = W.IdPoliza;
            --
         END IF;
         --
         IF nIdPolizaAfin IS NULL AND nIDetpolAfin IS NULL AND nCodCiaAfin IS NULL AND cCodGrupoCobertAfin IS NULL THEN
            nIdPolizaAfin       := W.IdPoliza;
            nIDetpolAfin        := W.IDetPol;
            nCodCiaAfin         := W.CodCia;
            cCodGrupoCobertAfin := W.CodGrupoCobert;
            --
            BEGIN
               SELECT DescCobert, SumaAsegMaxima, Prima_Cobert
                 INTO cNomCobert, nSumaAsegCobert, nPrimaCobert
                 FROM DETALLE_POLIZA DP, COBERTURAS_DE_SEGUROS CS
                WHERE DP.IdPoliza   = W.IdPoliza
                  AND DP.IDetPol    = W.IDetPol
                  AND DP.CodCia     = W.CodCia
                  AND DP.CodCia     = CS.CodCia
                  AND DP.CodEmpresa = CS.CodEmpresa
                  AND DP.IdTipoSeg  = CS.IdTipoSeg
                  AND DP.PlanCob    = CS.PlanCob
                  AND CS.CodCobert  = W.CodGrupoCobert;
            EXCEPTION
            WHEN OTHERS THEN
               cNomCobert      := 'NO EXISTE '||W.CodGrupoCobert;
               nSumaAsegCobert := 0;
            END;
            --
         ELSIF nIdPolizaAfin <> W.IdPoliza OR nIDetpolAfin <> W.IDetPol OR nCodCiaAfin <> W.CodCia OR cCodGrupoCobertAfin <> W.CodGrupoCobert THEN
            nIdPolizaAfin       := W.IdPoliza;
            nIDetpolAfin        := W.IDetPol;
            nCodCiaAfin         := W.CodCia;
            cCodGrupoCobertAfin := W.CodGrupoCobert;
            --
            BEGIN
               SELECT DescCobert, SumaAsegMaxima, Prima_Cobert
                 INTO cNomCobert, nSumaAsegCobert, nPrimaCobert
                 FROM DETALLE_POLIZA DP, COBERTURAS_DE_SEGUROS CS
                WHERE DP.IdPoliza   = W.IdPoliza
                  AND DP.IDetPol    = W.IDetPol
                  AND DP.CodCia     = W.CodCia
                  AND DP.CodCia     = CS.CodCia
                  AND DP.CodEmpresa = CS.CodEmpresa
                  AND DP.IdTipoSeg  = CS.IdTipoSeg
                  AND DP.PlanCob    = CS.PlanCob
                  AND CS.CodCobert  = W.CodGrupoCobert;
            EXCEPTION
            WHEN OTHERS THEN
               cNomCobert      := 'NO EXISTE '||W.CodGrupoCobert;
               nSumaAsegCobert := 0;
            END;
            --
         END IF;
         --
         cCodContrato       := W.CodContrato;
         cDescContrato      := NVL(W.DescContrato, 'NO EXISTE CONTRATO');
         dFecIngreso        := W.FecIngreso;
         nEdadAseg          := W.EdadAseg;
         nPrimasDirectas    := NVL(W.PrimasDirectas, 0);
         nFactorReaseg      := NVL(W.FactorReaseg, 0);
         nPrimasCedidas     := NVL(W.PrimasCedidas, 0);
         nTotalPrimasReaseg := NVL(W.TotalPrimasReaseg, 0);
         nFactorCesion      := NVL(W.FactorCesion, 0);
         --
         IF W.IdEndoso = 0 THEN
            nIdEndosoAlta := W.IdEndoso;
            IF dFecEndosBaja IS NOT NULL THEN
               nIdEndosoBaja := W.IdEndoso;
            END IF;
         ELSE
            BEGIN
               SELECT FecEmision, NVL(FecAnul,FecExc)
                 INTO dFecEndosAlta, dFecEndosBaja
                 FROM ENDOSOS
                WHERE IdPoliza = W.IdPoliza
                  AND IdEndoso = W.IdEndoso;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               dFecEndosAlta := NULL;
               dFecEndosBaja := NULL;
            END;
            --
            nIdEndosoAlta := W.IdEndoso;
            --
            IF dFecEndosBaja IS NOT NULL THEN
               nIdEndosoBaja := W.IdEndoso;
            END IF;
         END IF;

         IF GT_REA_TIPOS_CONTRATOS.CONTRATO_FACULTATIVO(nCodCia, cCodContrato) = 'S' THEN
            SELECT NVL(SUM(SumaAsegDistrib),0), NVL(SUM(PrimaDistrib),0)
              INTO nSumaAsegDistrib, nPrimaDistrib
              FROM REA_DISTRIBUCION_EMPRESAS
             WHERE CodCia       = W.CodCia
               AND IdDistribRea = W.IdDistribRea
               AND NumDistrib   = W.NumDistrib;
           
            IF nSumaAsegDistrib != W.SumaAsegDistrib OR
               nPrimaDistrib    != W.PrimaDistrib THEN
               cIndDistFacult := 'SI';
            END IF;
         END IF;
         --
         cRegistro := cNumPolUnico1                                    || '|' ||
                      TO_CHAR(W.IdPoliza,'9999999999999')              || '|' ||
                      TO_CHAR(dFecIniVig,'DD/MM/YYYY')                 || '|' ||
                      TO_CHAR(dFecFinVig,'DD/MM/YYYY')                 || '|' ||
                      TO_CHAR(W.IDetPol,'9999999999999')               || '|' ||
                      cNomCliente                                      || '|' ||
                      TO_CHAR(nCodCliente,'9999999999999')             || '|' ||
                      TO_CHAR(W.IdEndoso,'9999999999999')              || '|' ||
                      TO_CHAR(W.IdDistribRea,'9999999999999')          || '|' ||
                      TO_CHAR(W.NumDistrib,'9999999999999')            || '|' ||
                      W.CodGrupoCobert                                 || '|' ||
                      cNomCobert                                       || '|' ||
                      TO_CHAR(W.Cod_Asegurado,'9999999999999')         || '|' ||
                      W.NomAsegurado                                   || '|' ||
                      TO_CHAR(W.FecNacimiento,'DD/MM/YYYY')            || '|' ||
                      TO_CHAR(nEdadAseg,'9999999999999')               || '|' ||
                      TO_CHAR(dFecIngreso,'DD/MM/YYYY')                || '|' ||
                      W.Esquema                                        || '|' ||
                      cDescContrato                                    || '|' ||
                      TO_CHAR(W.IdCapaContrato,'9999999999999')        || '|' ||
                      TO_CHAR(W.CodEmpresaGremio,'9999999999999')      || '|' ||
                      W.NombreReasegurador                             || '|' ||
                      TO_CHAR(W.CodInterReaseg,'9999999999999')        || '|' ||
                      W.NomInterReaseg                                 || '|' ||
                      TO_CHAR(W.CapacidadMaxima,'99999999999990.00')   || '|' ||
                      TO_CHAR(W.PorcDistrib,'9999999990.000000')       || '|' ||
                      TO_CHAR(W.SumaAsegDistrib,'99999999999990.00')   || '|' ||
                      TO_CHAR(W.PrimaDistrib,'99999999999990.000000')  || '|' ||
                      TO_CHAR(W.PorcComis,'9999999990.000000')         || '|' ||
                      TO_CHAR(W.MontoComision,'99999999999990.00')     || '|' ||
                      TO_CHAR(nSumaAsegCobert,'99999999999990.00')     || '|' ||
                      TO_CHAR(nPrimaCobert,'99999999999990.00')        || '|' ||
                      TO_CHAR(W.IdLiquidacion,'9999999999999')         || '|' ||
                      TO_CHAR(dFecEndosAlta,'DD/MM/YYYY')              || '|' ||
                      TO_CHAR(nIdEndosoAlta,'9999999999999')           || '|' ||
                      TO_CHAR(dFecEndosBaja,'DD/MM/YYYY')              || '|' ||
                      TO_CHAR(nIdEndosoBaja,'9999999999999')           || '|' ||
                      cTieneSiniestros                                 || '|' ||
                      TO_CHAR(dFecEndosAlta,'DD/MM/YYYY')              || '|' || -- Fec Cancelacion
                      TO_CHAR(nPrimaDeveng,'99999999999990.00')        || '|' || -- Prima Devengada
                      W.CodRiesgoReaseg                                || '|' ||
                      TO_CHAR(W.FecMovDistrib,'DD/MM/RRRR')            || '|' ||
                      TO_CHAR(W.IdTransaccion,'9999999999999')         || '|' ||
                      W.Proceso                                        || '|' ||
                      TO_CHAR(W.FechaTransaccion,'RRRR/MM')            || '|' ||
                      W.Moneda                                         || '|' ||
                      cIndDistFacult                                   || '|' || -- Falta Definir
                      TO_CHAR(nPrimasDirectas,'99999999999990.00')     || '|' || -- Falta Definir
                      TO_CHAR(nFactorReaseg,'99999999999990.00')       || '|' || -- Falta Definir
                      TO_CHAR(nPrimasCedidas,'99999999999990.00')      || '|' || -- Falta Definir
                      TO_CHAR(nTotalPrimasReaseg,'99999999999990.00')  || '|' || -- Falta Definir
                      TO_CHAR(nFactorCesion,'99999999999990.00');                -- Falta Definir
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
        RAISE_APPLICATION_ERROR(-20225,'Error en Generación de Reporte Detalle Por Reasegurador de la Poliza' || cError);
   END REASEGURADOR_POLIZA;

   PROCEDURE TRANSACCION_SINIESTRO( cIdSiniestro       VARCHAR2
                                  , nIdTransaccionIni  NUMBER
                                  , nIdTransaccionFin  NUMBER
                                  , dFecDesde          DATE
                                  , dFecHasta          DATE
                                  , cIdPoliza          VARCHAR2
                                  , nCodCia            NUMBER
                                  , cFormato           VARCHAR2
                                  , nCodEmpresa        NUMBER
                                  , cCodUser           VARCHAR2
                                  , cNomArchivo        VARCHAR2
                                  , cNomArchZip        VARCHAR2
                                  , cNomDirectorio     VARCHAR2
                                  , cCodReporte        VARCHAR2 ) IS
      --Variables Locales
      cNumPolUnico     POLIZAS.NumPolUnico%TYPE;
      cCodContrato     REA_TIPOS_CONTRATOS.CodContrato%TYPE;
      cDescContrato    REA_TIPOS_CONTRATOS.NomContrato%TYPE;
      dFec_Ocurrencia  SINIESTRO.Fec_Ocurrencia%TYPE;
      cSts_Siniestro   SINIESTRO.Sts_Siniestro%TYPE;
      nCod_Asegurado   SINIESTRO.Cod_Asegurado%TYPE;
      cCodCobert       COBERTURA_SINIESTRO.CodCobert%TYPE;
      nMontoReserva    COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
      nTotalGastos     PAGOS_POR_OTROS_CONCEPTOS.Monto_Reservado_Moneda%TYPE;
      nTotalReservado  SINIESTRO.Monto_Reserva_Moneda%TYPE;
      nMtoCedido       SINIESTRO.Monto_Reserva_Moneda%TYPE;
      cDescTitulo      VARCHAR(100);
      --
      CURSOR DISTREA_Q IS
         SELECT /*+ INDEX(DT SYS_C0031885) */ DISTINCT RD.IdDistribRea
              , RD.NumDistrib
              , RD.CodGrupoCobert
              , RD.CodEsquema
              , RD.IdEsqContrato
              , RD.PorcDistrib
              , RD.MontoReserva
              , GT_REA_ESQUEMAS.NOMBRE_ESQUEMA(RD.CodCia, RD.CodEsquema) Esquema
              , RD.FecMovDistrib
              , RD.IdCapaContrato
              , RD.IdPoliza
              , RD.IDetPol
              , RD.CodCia
              , RD.IdSiniestro
              , RD.IdTransaccion
              , P.NumPolUnico
              , REC.CodContrato
              , GT_REA_TIPOS_CONTRATOS.NOMBRE_CONTRATO(REC.CodCia, REC.CodContrato)  DescContrato
              , S.Fec_Ocurrencia
              , S.Sts_Siniestro
              , S.Cod_Asegurado
              , S.Monto_Reserva_Moneda
           FROM TRANSACCION             TR
              , DETALLE_TRANSACCION     DT
              , REA_DISTRIBUCION        RD 
              , POLIZAS                 P
              , REA_ESQUEMAS_CONTRATOS  REC
              , SINIESTRO               S
          WHERE TR.CodCia              = DT.CodCia
            AND TR.IdTransaccion       = DT.IdTransaccion
            AND TR.FechaTransaccion   >= NVL(dFecDesde, TR.FechaTransaccion)
            AND TR.FechaTransaccion   <= NVL(dFecHasta, TR.FechaTransaccion)
            AND DT.IdTransaccion BETWEEN NVL(nIdTransaccionIni,0) AND NVL(nIdTransaccionFin,99999999999999999999)
            AND UPPER(DT.Objeto)      IN ('SINIESTRO','COBERTURA_SINIESTRO','COBERTURA_SINIESTRO_ASEG','APROBACIONES', 'APROBACION_ASEG')
            AND NVL(DT.Valor1,'%')  LIKE cIdSiniestro
            AND RD.IdPoliza         LIKE cIdPoliza
            AND DT.MtoLocal           != 0
            AND RD.CodCia              = DT.CodCia
            AND RD.IdTransaccion       = DT.IdTransaccion
            AND P.IdPoliza(+)          = RD.IdPoliza
            AND P.CodCia(+)            = RD.CodCia
            AND REC.CodCia             = RD.CodCia
            AND REC.CodEsquema(+)      = RD.CodEsquema
            AND REC.IdEsqContrato(+)   = RD.IdEsqContrato
            AND S.CodCia(+)            = RD.CodCia
            AND S.IdSiniestro(+)       = RD.IdSiniestro
            AND S.IdPoliza(+)          = RD.IdPoliza
          ORDER BY RD.IdTransaccion, RD.IdDistribRea, RD.NumDistrib;
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
      IF cIdSiniestro = '%' THEN
         cDescTitulo := 'TODOS';
      ELSE
         cDescTitulo := cIdSiniestro;
      END IF;
      -- 
      cTitulo1 := NOMBRE_COMPANIA(nCodCia);
      cTitulo2 := 'REPORTE DISTRIBUCIÓN DE REASEGURO DE LA TRANSACCION' || TO_CHAR(nIdTransaccionIni) || ' A ' || TO_CHAR(nIdTransaccionFin);
      cTitulo3 := 'DEL SINIESTRO ' || cDescTitulo;
      cTitulo4 := ' ';
      cEncabez := 'No. de Póliza Único|Consecutivo|No. Detalle de Póliza|No. Siniestro|No. Transacción|No. Distribución|Orden|% Distribución|Monto Cedido|' ||
                  'Esquema de Reaseguro|Contrato de Reaseguro|No. Capa Contrato|Fecha Distribución|Cobertura Afectada|Fecha Ocurrencia|Monto de Gastos|'    ||
                  'Monto Daño Cobertura|Total Reservado|Status Siniestro'; 
      nFila    := 1;
      --
      INSERTA_ENCABEZADO( cFormato, nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo );
      --
      FOR W IN DISTREA_Q LOOP
         cNumPolUnico    := NVL(W.NumPolUnico, 'NO EXISTE');
         cCodContrato    := W.CodContrato;
         cDescContrato   := NVL(W.DescContrato, 'NO EXISTE CONTRATO');
         dFec_Ocurrencia := W.Fec_Ocurrencia;
         cSts_Siniestro  := W.Sts_Siniestro;
         nCod_Asegurado  := W.Cod_Asegurado;
         nTotalReservado := W.Monto_Reserva_Moneda;
         --
         IF OC_SINIESTRO.SINIESTRO_DE_ASEGURADO(W.CodCia, W.IdPoliza, W.IDetPol, W.IdSiniestro) = 'N' THEN
            BEGIN
               SELECT CodCobert , SUM(Monto_Reservado_Moneda)
                 INTO cCodCobert, nMontoReserva
                 FROM COBERTURA_SINIESTRO
                WHERE IdPoliza      = W.IdPoliza
                  AND IdSiniestro   = W.IdSiniestro
                  AND IdTransaccion = W.IdTransaccion
                GROUP BY CodCobert;
            EXCEPTION
            WHEN OTHERS THEN
               cCodCobert    := W.CodGrupoCobert;
               nMontoReserva := 0;
            END;
         ELSE
            BEGIN
               SELECT CodCobert, SUM(Monto_Reservado_Moneda) MontoReserva
                 INTO cCodCobert, nMontoReserva
                 FROM COBERTURA_SINIESTRO_ASEG
                WHERE IdPoliza      = W.IdPoliza
                  AND IdSiniestro   = W.IdSiniestro
                  AND IdTransaccion = W.IdTransaccion
                  AND Cod_Asegurado = nCod_Asegurado
                GROUP BY CodCobert;
            EXCEPTION
            WHEN OTHERS THEN
               cCodCobert    := W.CodGrupoCobert;
               nMontoReserva := 0;
            END;
         END IF;
         --
         BEGIN
            SELECT NVL(SUM(Monto_Reservado_Moneda),0)
              INTO nTotalGastos
              FROM PAGOS_POR_OTROS_CONCEPTOS
             WHERE IdPoliza      = W.IdPoliza
               AND IdSiniestro   = W.IdSiniestro;
         EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20225,'Error al Seleccionar PAGOS_POR_OTROS_CONCEPTOS: Siniestro '||W.IdSiniestro||' ' ||SQLERRM);
         END;
         -- Monto Cedido
         BEGIN
            SELECT NVL(SUM(MtoSiniDistrib),0) Monto
             INTO nMtoCedido
             FROM REA_DISTRIBUCION_EMPRESAS
            WHERE CodCia            = W.CodCia
              AND IdDistribRea      = W.IdDistribRea
              AND NumDistrib        = W.NumDistrib
              AND CodEmpresaGremio != '00001'; -- Thona Seguros.
         END;
         --
         --Armo el registro detalle
         --TO_CHAR(W.MontoReserva,'99999999999990.000000') || '|' || Se cambia temporalmente por el cálculo del MontoCedido
         cRegistro := cNumPolUnico                                 || '|' ||
                      TO_CHAR(W.IdPoliza,'9999999999999')          || '|' ||
                      TO_CHAR(W.IDetPol,'9999999999999')           || '|' ||
                      TO_CHAR(W.IdSiniestro,'9999999999999')       || '|' ||
                      TO_CHAR(W.IdTransaccion,'9999999999999')     || '|' ||
                      TO_CHAR(W.IdDistribRea,'9999999999999')      || '|' ||
                      TO_CHAR(W.NumDistrib,'9999999999999')        || '|' ||
                      TO_CHAR(W.PorcDistrib,'9999999990.000000')   || '|' ||
                      TO_CHAR(nMtoCedido,'99999999999990.000000')  || '|' ||
                      W.Esquema                                    || '|' ||
                      cDescContrato                                || '|' ||
                      TO_CHAR(W.IdCapaContrato,'9999999999999')    || '|' ||
                      TO_CHAR(W.FecMovDistrib,'DD/MM/YYYY')        || '|' ||
                      cCodCobert                                   || '|' ||
                      TO_CHAR(dFec_Ocurrencia,'DD/MM/YYYY')        || '|' ||
                      TO_CHAR(nTotalGastos,'99999999999990.00')    || '|' ||
                      TO_CHAR(nMontoReserva,'99999999999990.00')   || '|' ||
                      TO_CHAR(nTotalReservado,'99999999999990.00') || '|' ||
                      cSts_Siniestro;
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
        RAISE_APPLICATION_ERROR(-20225,'Error en Generación de Reporte Reaseguro Por Transacción del Siniestro: ' || cError);
   END TRANSACCION_SINIESTRO;

   PROCEDURE REASEGURADOR_SINIESTRO( cIdSiniestro       VARCHAR2
                                   , nIdTransaccionIni  NUMBER
                                   , nIdTransaccionFin  NUMBER
                                   , dFecDesde          DATE
                                   , dFecHasta          DATE
                                   , cIdPoliza          VARCHAR2
                                   , nCodCia            NUMBER
                                   , cFormato           VARCHAR2
                                   , nCodEmpresa        NUMBER
                                   , cCodUser           VARCHAR2
                                   , cNomArchivo        VARCHAR2
                                   , cNomArchZip        VARCHAR2
                                   , cNomDirectorio     VARCHAR2
                                   , cCodReporte        VARCHAR2 ) IS
      --Variables Locales
      cNumPolUnico        POLIZAS.NumPolUnico%TYPE;
      cCodContrato        REA_TIPOS_CONTRATOS.CodContrato%TYPE;
      cDescContrato       REA_TIPOS_CONTRATOS.NomContrato%TYPE;
      dFec_Ocurrencia     SINIESTRO.Fec_Ocurrencia%TYPE;
      cSts_Siniestro      SINIESTRO.Sts_Siniestro%TYPE;
      nCod_Asegurado      SINIESTRO.Cod_Asegurado%TYPE;
      cNomAsegurado       VARCHAR2(500);
      dFecNacAseg         DATE;
      cCodCobert          COBERTURA_SINIESTRO.CodCobert%TYPE;
      nMontoReserva       COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
      nTotalGastos        PAGOS_POR_OTROS_CONCEPTOS.Monto_Reservado_Moneda%TYPE;
      nTotalReservado     SINIESTRO.Monto_Reserva_Moneda%TYPE;
      nMtoCedido          SINIESTRO.Monto_Reserva_Moneda%TYPE;
      cDescTitulo         VARCHAR(100);
      dFecIniVig          POLIZAS.FecIniVig%TYPE;
      dFecFinVig          POLIZAS.FecFinVig%TYPE;
      nCodCliente         POLIZAS.CodCliente%TYPE;
      cNomCliente         VARCHAR2(500);
      cNomCobert          COBERTURAS_DE_SEGUROS.DescCobert%TYPE;
      dFecNotificacion    SINIESTRO.Fec_Notificacion%TYPE;
      dFecRegistro        SINIESTRO.FecSts%TYPE;
      cTipoSiniestro      SINIESTRO.Tipo_Siniestro%TYPE;
      cDescTipoSini       VARCHAR2(500);
      cCausaSiniestro     SINIESTRO.Motivo_De_Siniestro%TYPE;
      cDescCausaSini      VARCHAR2(500);
      cDesc_Siniestro     SINIESTRO.Desc_Siniestro%TYPE;
      dFecRes             COBERTURA_SINIESTRO.FecRes%TYPE;
      cCodTransac         COBERTURA_SINIESTRO.CodTransac%TYPE;
      cDescCodTransac     VARCHAR2(500);
      nMontoPagado        APROBACIONES.Monto_Moneda%TYPE;
      dFecPago            APROBACIONES.FecPago%TYPE;
      cIdTiposeg          DETALLE_POLIZA.IdTipoSeg%TYPE;
      cPlanCob            DETALLE_POLIZA.PlanCob%TYPE;
      nIdSiniestro        SINIESTRO.IdSiniestro%TYPE;
      --
      CURSOR DISTREA_Q IS
         SELECT /*+ INDEX(DT SYS_C0031885) */ DISTINCT RD.IdDistribRea
              , RD.NumDistrib
              , RD.CodGrupoCobert
              , RD.CodEsquema
              , RD.IdEsqContrato
              , RD.IdCapaContrato
              , RD.IdPoliza
              , RD.IDetPol
              , RD.CodCia
              , NVL(RE.DescEsquema, 'Esquema de Reaseguro/Coaseguro ' || RD.CodEsquema || ' - NO EXISTE!!!')  Esquema
              , RDE.CodEmpresaGremio
              , NVL(TRIM(PNJ1.Nombre) || ' ' || TRIM(PNJ1.Apellido) || ' ' || TRIM(PNJ1.ApeCasada), 'Empresa del Gremio - NO EXISTE!!!') NombreReasegurador
              , RDE.CodInterReaseg, RDE.MtoSiniDistrib
              , TRIM(PNJ2.Nombre) || ' ' || TRIM(PNJ2.Apellido) || ' ' || TRIM(PNJ2.ApeCasada) NomInterReaseg
              , RDE.PorcDistrib
              , RDE.MontoReserva
              , RDE.IdLiquidacion
              , RD.IdTransaccion
              , RD.IdSiniestro
              , TR.FechaTransaccion
              , RD.IdEndoso
              , RD.CodRiesgoReaseg
              , RD.FecMovDistrib
              , M.Desc_Moneda   Moneda
              , TR.CodEmpresa
              , NVL(P.NumPolUnico, 'NO EXISTE')  NumPolUnico
              , P.FecIniVig
              , P.FecFinVig
              , P.CodCliente
              , OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente)  NomCliente
              , REC.CodContrato
              , NVL(GT_REA_TIPOS_CONTRATOS.NOMBRE_CONTRATO(REC.CodCia, REC.CodContrato), 'NO EXISTE CONTRATO')  DescContrato
              , S.Fec_Ocurrencia
              , S.Sts_Siniestro
              , S.Cod_Asegurado
              , OC_ASEGURADO.NOMBRE_ASEGURADO(S.CodCia, S.CodEmpresa, S.Cod_Asegurado)  NomAsegurado
              , OC_ASEGURADO.FECHA_NACIMIENTO(S.CodCia, S.CodEmpresa, S.Cod_Asegurado)  FecNacAseg
              , S.Monto_Reserva_Moneda
              , S.Fec_Notificacion
              , S.FecSts
              , S.Tipo_Siniestro
              , OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPOSINI',S.Tipo_Siniestro)          DescTipoSini
              , S.Motivo_De_Siniestro
              , OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CAUSIN',S.Motivo_De_Siniestro)       DescCausaSini
              , S.Desc_Siniestro
           FROM REA_DISTRIBUCION_EMPRESAS  RDE
              , REA_DISTRIBUCION           RD
              , DETALLE_TRANSACCION        DT
              , TRANSACCION                TR
              , MONEDA                     M
              , REA_ESQUEMAS               RE
              , PERSONA_NATURAL_JURIDICA   PNJ1
              , REA_EMPRESAS_GREMIO        REG1
              , PERSONA_NATURAL_JURIDICA   PNJ2
              , REA_EMPRESAS_GREMIO        REG2
              , POLIZAS                    P
              , REA_ESQUEMAS_CONTRATOS     REC
              , SINIESTRO                  S
          WHERE RDE.CodCia                       = RD.CodCia
            AND RDE.IdDistribRea                 = RD.IdDistribRea 
            AND RDE.NumDistrib                   = RD.NumDistrib
            AND RDE.CodEmpresaGremio            IS NOT NULL
            AND RDE.CodInterReaseg              IS NOT NULL
            AND RD.CodCia                        = DT.CodCia
            AND RD.IdDistribRea                  > 0
            AND RD.NumDistrib                    > 0
            AND RD.IdTransaccion                 = DT.IdTransaccion
            AND RD.IdPoliza                   LIKE cIdPoliza
            AND DT.CodCia                        > 0
            AND DT.CodEmpresa                    > 0
            AND DT.Correlativo                   > 0
            AND DT.IdTransaccion           BETWEEN NVL(nIdTransaccionIni,0) AND NVL(nIdTransaccionFin,99999999999999999999)
            AND UPPER(DT.Objeto)                IN ('SINIESTRO','COBERTURA_SINIESTRO','COBERTURA_SINIESTRO_ASEG','APROBACIONES','APROBACION_ASEG')
            AND NVL(DT.Valor1,'%')            LIKE cIdSiniestro
            AND TR.CodCia                        = DT.CodCia
            AND TR.IdTransaccion                 = DT.IdTransaccion
            AND TR.CodEmpresa                    = DT.CodEmpresa
            AND TR.FechaTransaccion             >= NVL(dFecDesde,TR.FechaTransaccion)
            AND TR.FechaTransaccion             <= NVL(dFecHasta,TR.FechaTransaccion)
            AND M.Cod_Moneda(+)                  = RD.CodMoneda         
            AND RE.CodCia(+)                     = RD.CodCia
            AND RE.CodEsquema(+)                 = RD.CodEsquema
            --
            AND PNJ1.Tipo_Doc_Identificacion(+)  = REG1.Tipo_Doc_Identificacion
            AND PNJ1.Num_Doc_Identificacion(+)   = REG1.Num_Doc_Identificacion
            AND REG1.CodCia(+)                   = RDE.CodCia
            AND REG1.CodEmpresaGremio(+)         = RDE.CodEmpresaGremio
            --
            AND PNJ2.Tipo_Doc_Identificacion(+)  = REG2.Tipo_Doc_Identificacion
            AND PNJ2.Num_Doc_Identificacion(+)   = REG2.Num_Doc_Identificacion
            AND REG2.CodCia(+)                   = RDE.CodCia
            AND REG2.CodEmpresaGremio(+)         = RDE.CodInterReaseg
            --
            AND P.IdPoliza(+)                    = RD.IdPoliza
            AND P.CodCia(+)                      = RD.CodCia
            --
            AND REC.CodCia(+)                    = RD.CodCia
            AND REC.CodEsquema(+)                = RD.CodEsquema
            AND REC.IdEsqContrato(+)             = RD.IdEsqContrato
            --
            AND S.CodCia(+)                      = RD.CodCia
            AND S.IdSiniestro(+)                 = RD.IdSiniestro
            AND S.IdPoliza(+)                    = RD.IdPoliza
         ORDER BY RD.IdTransaccion
                , RD.IdDistribRea
                , RD.NumDistrib
                , RDE.CodEmpresaGremio
                , RDE.CodInterReaseg;
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
      IF cIdSiniestro = '%' THEN
          cDescTitulo := 'TODOS';
      ELSE
          cDescTitulo := cIdSiniestro;
      END IF;
      --
      cTitulo1 := NOMBRE_COMPANIA(nCodCia);
      cTitulo2 := 'REPORTE DISTRIBUCIÓN DE REASEGURO DETALLE POR REASEGURADOR';
      cTitulo3 := 'DEL SINIESTRO '||cDescTitulo;
      cTitulo4 := ' ';
      cEncabez := 'No. de Póliza Único|No. de Póliza Consecutivo|Inicio Vigencia Póliza|Fin Vigencia Póliza|No. Detalle de Póliza|Contratante|Código Cliente|No. Siniestro|' ||
                  'No. Transacción|No. Distribución|Orden|Esquema de Reaseguro|Contrato de Reaseguro|No. Capa Contrato|Código Reasegurador|Nombre Reasegurador|'             ||
                  'Código Intermediario Reaseguro|Nombre Intermediario Reaseguro|% Distribución|Total Cedido|No. Liquidación|Cobertura Afectada|Desc. Cobertura Afectada|'   ||
                  'Fecha Notificación|Fecha Registro|Fecha Ocurrencia|Tipo de Siniestro|Descripción Tipo de Siniestro|Código Causa Siniestro|Descripción Causa Siniestro|'   ||
                  'No. Endoso Afectado|Monto de Gastos|Monto Daño Cobertura|Total Reservado|Status Siniestro|Año-Mes de Movimiento|Monto de Reserva|Fecha Reserva|'          ||
                  'Monto Pagado|Fecha Pago|Código Asegurado|Nombre Asegurado|Fecha de Nacimiento|Certificado|Esquema de Reaseguro|Contrato de Reaseguro|No. Capa Contrato|'  ||
                  'Riesgo de Reaseguro|Fecha Distribución|Moneda|Código de la Transacción|Nombre de la Transacción'; 
      --
      INSERTA_ENCABEZADO( cFormato, nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo );
      --
      FOR W IN DISTREA_Q LOOP
         cNumPolUnico     := W.NumPolUnico;
         dFecIniVig       := W.FecIniVig;
         dFecFinVig       := W.FecFinVig;
         nCodCliente      := W.CodCliente;
         cNomCliente      := W.NomCliente;
         --
         cCodContrato     := W.CodContrato;
         cDescContrato    := W.DescContrato;
         --
         dFec_Ocurrencia  := W.Fec_Ocurrencia;
         cSts_Siniestro   := W.Sts_Siniestro;
         nCod_Asegurado   := W.Cod_Asegurado;
         cNomAsegurado    := W.NomAsegurado;
         dFecNacAseg      := W.FecNacAseg;
         nTotalReservado  := W.Monto_Reserva_Moneda;
         dFecNotificacion := W.Fec_Notificacion;
         dFecRegistro     := W.FecSts;
         cTipoSiniestro   := W.Tipo_Siniestro;
         cDescTipoSini    := W.DescTipoSini;
         cCausaSiniestro  := W.Motivo_De_Siniestro;
         cDescCausaSini   := W.DescCausaSini;
         cDesc_Siniestro  := W.Desc_Siniestro;
         --
         nIdSiniestro     := W.IdSiniestro;
         --
         BEGIN
            SELECT IdTipoSeg, PlanCob
              INTO cIdTiposeg, cPlanCob
              FROM DETALLE_POLIZA
             WHERE IdPoliza = W.IdPoliza
               AND IDetPol  = W.IDetPol
               AND CodCia   = W.CodCia;
         EXCEPTION 
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20225,'No. Existe Certificado/Subgrupo '|| W.IDetPol || ' en Póliza ' || W.IdPoliza);
         END;

         IF OC_SINIESTRO.SINIESTRO_DE_ASEGURADO(W.CodCia, W.IdPoliza, W.IDetPol, W.IdSiniestro) = 'N' THEN
            BEGIN
               SELECT CodCobert, Monto_Reservado_Moneda, FecRes, CodTransac,
                      OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(W.CodCia, CodTransac)
                 INTO cCodCobert, nMontoReserva, dFecRes, cCodTransac, cDescCodTransac
                 FROM COBERTURA_SINIESTRO
                WHERE IdPoliza      = W.IdPoliza
                  AND IdSiniestro   = W.IdSiniestro
                  AND IdTransaccion = W.IdTransaccion;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cCodCobert    := W.CodGrupoCobert;
               nMontoReserva := 0;
               dFecRes       := NULL;
            WHEN TOO_MANY_ROWS THEN
               RAISE_APPLICATION_ERROR(-20225,'Existen Varias Coberturas con Transacción '|| W.IdTransaccion || ' del Siniestro ' || W.IdSiniestro);
            END;

            BEGIN
               SELECT Monto_Moneda, FecPago
                 INTO nMontoPagado, dFecPago
                 FROM APROBACIONES
                WHERE IdPoliza      = W.IdPoliza
                  AND IdSiniestro   = W.IdSiniestro
                  AND IdTransaccion = W.IdTransaccion;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 BEGIN
                    SELECT Monto_Moneda * -1, FecPago
                    INTO nMontoPagado, dFecPago
                    FROM APROBACIONES
                    WHERE IdPoliza          = W.IdPoliza
                      AND IdSiniestro       = W.IdSiniestro
                      AND IdTransaccionAnul = W.IdTransaccion;
                 EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      nMontoPagado := 0;
                      dFecPago     := NULL;
                 WHEN TOO_MANY_ROWS THEN
                      RAISE_APPLICATION_ERROR(-20225,'Existen Varias Aprobaciones con Transacción '|| W.IdTransaccion || ' del Siniestro ' || W.IdSiniestro);
                 END;
            WHEN TOO_MANY_ROWS THEN
                 RAISE_APPLICATION_ERROR(-20225,'Existen Varias Aprobaciones con Transacción '|| W.IdTransaccion || ' del Siniestro ' || W.IdSiniestro);
            END;
            --
            cCodTransac     := 'SINTRA';
            cDescCodTransac := 'SIN TRANSACCION';
            --
            IF nMontoPagado > 0 THEN
               BEGIN
                  SELECT CodTransac, OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(W.CodCia, CodTransac)
                    INTO cCodTransac, cDescCodTransac
                    FROM DETALLE_APROBACION
                   WHERE IdSiniestro    = W.IdSiniestro
                     AND Num_Aprobacion IN (SELECT Num_Aprobacion
                                              FROM APROBACIONES
                                             WHERE IdPoliza      = W.IdPoliza
                                               AND IdSiniestro   = W.IdSiniestro
                                               AND IdTransaccion = W.IdTransaccion)
                     AND IdDetAprob     = 1;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    cCodTransac     := 'SINTRA';
                    cDescCodTransac := 'SIN TRANSACCION';
               WHEN TOO_MANY_ROWS THEN
                    RAISE_APPLICATION_ERROR(-20225,'Existen Varias Detalles de Aprobaciones con Transacción '|| W.IdTransaccion || ' del Siniestro ' || W.IdSiniestro);
               END;
            ELSIF nMontoPagado < 0 THEN
               BEGIN
                  SELECT CodTransac, OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(W.CodCia, CodTransac) || ' ANULACION'
                    INTO cCodTransac, cDescCodTransac
                    FROM DETALLE_APROBACION
                   WHERE IdSiniestro    = W.IdSiniestro
                     AND Num_Aprobacion IN (SELECT Num_Aprobacion
                                              FROM APROBACIONES
                                             WHERE IdPoliza          = W.IdPoliza
                                               AND IdSiniestro       = W.IdSiniestro
                                               AND IdTransaccionAnul = W.IdTransaccion)
                     AND IdDetAprob     = 1;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    cCodTransac     := 'SINTRA';
                    cDescCodTransac := 'SIN TRANSACCION';
               WHEN TOO_MANY_ROWS THEN
                    RAISE_APPLICATION_ERROR(-20225,'Existen Varias Detalles de Aprobaciones con Transacción '|| W.IdTransaccion || ' del Siniestro ' || W.IdSiniestro);
               END;
            END IF;
         ELSE
            BEGIN
               SELECT CodCobert, Monto_Reservado_Moneda, FecRes, CodTransac,
                      OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(W.CodCia, CodTransac)
                 INTO cCodCobert, nMontoReserva, dFecRes, cCodTransac, cDescCodTransac
                 FROM COBERTURA_SINIESTRO_ASEG
                WHERE IdPoliza      = W.IdPoliza
                  AND IdSiniestro   = W.IdSiniestro
                  AND IdTransaccion = W.IdTransaccion
                  AND Cod_Asegurado = nCod_Asegurado;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 cCodCobert    := W.CodGrupoCobert;
                 nMontoReserva := 0;
                 dFecRes       := NULL;
            WHEN TOO_MANY_ROWS THEN
               BEGIN
                  SELECT CA.CodCobert, CA.Monto_Reservado_Moneda, CA.FecRes, CA.CodTransac,
                         OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(W.CodCia, CA.CodTransac)
                    INTO cCodCobert, nMontoReserva, dFecRes, cCodTransac, cDescCodTransac
                    FROM COBERTURA_SINIESTRO_ASEG CA
                   WHERE CA.IdPoliza      = W.IdPoliza
                     AND CA.IdSiniestro   = W.IdSiniestro
                     AND CA.IdTransaccion = W.IdTransaccion
                     AND CA.Cod_Asegurado = nCod_Asegurado
                     AND EXISTS (SELECT 'S'
                                   FROM COBERTURAS_DE_SEGUROS
                                  WHERE CodCia         = W.CodCia
                                    AND CodEmpresa     = W.CodEmpresa
                                    AND IdTipoSeg      = cIdTipoSeg
                                    AND PlanCob        = cPlanCob
                                    AND CodCobert      = CA.CodCobert
                                    AND CodGrupoCobert = W.CodGrupoCobert);
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    cCodCobert    := W.CodGrupoCobert;
                    nMontoReserva := 0;
                    dFecRes       := NULL;
               WHEN TOO_MANY_ROWS THEN
                    cCodCobert    := W.CodGrupoCobert;
                    nMontoReserva := 0;
                    dFecRes       := NULL;
               END;
            END;
            --
            BEGIN
               SELECT NVL(Monto_Moneda,0), FecPago
                 INTO nMontoPagado, dFecPago
                 FROM APROBACION_ASEG
                WHERE IdPoliza      = W.IdPoliza
                  AND IdSiniestro   = W.IdSiniestro
                  AND IdTransaccion = W.IdTransaccion
                  AND Cod_Asegurado = nCod_Asegurado;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
               BEGIN
                  SELECT NVL(Monto_Moneda,0) * -1, FecPago
                    INTO nMontoPagado, dFecPago
                    FROM APROBACION_ASEG
                   WHERE IdPoliza          = W.IdPoliza
                     AND IdSiniestro       = W.IdSiniestro
                     AND IdTransaccionAnul = W.IdTransaccion
                     AND Cod_Asegurado     = nCod_Asegurado;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  nMontoPagado := 0;
                  dFecPago     := NULL;
               WHEN TOO_MANY_ROWS THEN
                  RAISE_APPLICATION_ERROR(-20225,'Existen Varias Aprobaciones con Transacción '|| W.IdTransaccion || ' del Siniestro ' || W.IdSiniestro || ' y Asegurado ' || nCod_Asegurado);
               END;
            WHEN TOO_MANY_ROWS THEN
               RAISE_APPLICATION_ERROR(-20225,'Existen Varias Aprobaciones de Asegurado con Transacción '|| W.IdTransaccion ||' del Siniestro ' || W.IdSiniestro || ' y Asegurado ' || nCod_Asegurado);
            END;
            --
            cCodTransac     := 'SINTRA';
            cDescCodTransac := 'SIN TRANSACCION';
            --
            IF nMontoPagado > 0 THEN
               BEGIN
                  SELECT CodTransac, OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(W.CodCia, CodTransac)
                    INTO cCodTransac, cDescCodTransac
                    FROM DETALLE_APROBACION_ASEG
                   WHERE IdSiniestro    = W.IdSiniestro
                     AND Num_Aprobacion IN (SELECT Num_Aprobacion
                                              FROM APROBACION_ASEG
                                             WHERE IdPoliza      = W.IdPoliza
                                               AND IdSiniestro   = W.IdSiniestro
                                               AND IdTransaccion = W.IdTransaccion
                                               AND Cod_Asegurado = nCod_Asegurado)
                     AND IdDetAprob     = 1;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cCodTransac     := 'SINTRA';
                  cDescCodTransac := 'SIN TRANSACCION';
               WHEN TOO_MANY_ROWS THEN
                  RAISE_APPLICATION_ERROR(-20225,'Existen Varias Detalles de Aprobaciones de Asegurado con Transacción '|| W.IdTransaccion ||' del Siniestro ' || W.IdSiniestro || ' y Asegurado ' || nCod_Asegurado);
               END;
            ELSIF nMontoPagado < 0 THEN
               BEGIN
                  SELECT CodTransac, OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(W.CodCia, CodTransac) || ' ANULACION'
                    INTO cCodTransac, cDescCodTransac
                    FROM DETALLE_APROBACION_ASEG
                   WHERE IdSiniestro    = W.IdSiniestro
                     AND Num_Aprobacion IN (SELECT Num_Aprobacion
                                              FROM APROBACION_ASEG
                                             WHERE IdPoliza          = W.IdPoliza
                                               AND IdSiniestro       = W.IdSiniestro
                                               AND IdTransaccionAnul = W.IdTransaccion
                                               AND Cod_Asegurado     = nCod_Asegurado)
                     AND IdDetAprob     = 1;
               EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cCodTransac     := 'SINTRA';
                  cDescCodTransac := 'SIN TRANSACCION';
               WHEN TOO_MANY_ROWS THEN
                  RAISE_APPLICATION_ERROR(-20225,'Existen Varias Detalles de Aprobaciones con Transacción '|| W.IdTransaccion ||' del Siniestro ' || W.IdSiniestro);
               END;
            END IF;
         END IF;
         --
         BEGIN
            SELECT OC_COBERTURAS_DE_SEGUROS.DESCRIPCION_COBERTURA(CodCia, CodEmpresa, IdTipoSeg, PlanCob, cCodCobert)
              INTO cNomCobert
              FROM DETALLE_POLIZA
             WHERE IdPoliza = W.IdPoliza
               AND IDetPol  = W.IDetPol
               AND CodCia   = W.CodCia;
         EXCEPTION 
         WHEN OTHERS THEN
               cNomCobert    := 'NO EXISTE '||cCodCobert;
         END;
         --
         BEGIN
            SELECT NVL(SUM(Monto_Reservado_Moneda),0)
              INTO nTotalGastos
              FROM PAGOS_POR_OTROS_CONCEPTOS
             WHERE IdPoliza      = W.IdPoliza
               AND IdSiniestro   = W.IdSiniestro;
         EXCEPTION
         WHEN OTHERS THEN
                nTotalGastos := 0;
         END;
         -- Monto Cedido Fuera
         --nMtoCedido := nTotalReservado * (W.PorcDistrib/100);
         cRegistro := cNumPolUnico                                      || '|' ||
                      TO_CHAR(W.IdPoliza,'9999999999999')               || '|' ||
                      TO_CHAR(dFecIniVig,'DD/MM/YYYY')                  || '|' ||
                      TO_CHAR(dFecFinVig,'DD/MM/YYYY')                  || '|' ||
                      TO_CHAR(W.IDetPol,'9999999999999')                || '|' ||
                      cNomCliente                                       || '|' ||
                      TO_CHAR(nCodCliente,'9999999999999')              || '|' ||
                      TO_CHAR(W.IdSiniestro,'9999999999999')            || '|' ||
                      TO_CHAR(W.IdTransaccion,'9999999999999')          || '|' ||
                      TO_CHAR(W.IdDistribRea,'9999999999999')           || '|' ||
                      TO_CHAR(W.NumDistrib,'9999999999999')             || '|' ||
                      W.Esquema                                         || '|' ||
                      cDescContrato                                     || '|' ||
                      TO_CHAR(W.IdCapaContrato,'9999999999999')         || '|' ||
                      TO_CHAR(W.CodEmpresaGremio,'9999999999999')       || '|' ||
                      W.NombreReasegurador                              || '|' ||
                      TO_CHAR(W.CodInterReaseg,'9999999999999')         || '|' ||
                      W.NomInterReaseg                                  || '|' ||
                      TO_CHAR(W.PorcDistrib,'9999999990.000000')        || '|' ||
                      --TO_CHAR(W.MontoReserva,'99999999999990.000000') || '|' || Se cambia temporalmente por el cálculo del MontoCedido
                      TO_CHAR(W.MtoSiniDistrib,'99999999999990.000000') || '|' ||
                      TO_CHAR(W.IdLiquidacion,'9999999999999')          || '|' ||
                      cCodCobert                                        || '|' ||
                      cNomCobert                                        || '|' ||
                      TO_CHAR(dFecNotificacion,'DD/MM/YYYY')            || '|' ||
                      TO_CHAR(dFecRegistro,'DD/MM/YYYY')                || '|' ||
                      TO_CHAR(dFec_Ocurrencia,'DD/MM/YYYY')             || '|' ||
                      cTipoSiniestro                                    || '|' ||
                      cDescTipoSini                                     || '|' ||
                      cCausaSiniestro                                   || '|' ||
                      cDescCausaSini                                    || '|' ||
                      cDesc_Siniestro                                   || '|' ||
                      TO_CHAR(W.IdEndoso,'99999999999999')              || '|' ||
                      TO_CHAR(nTotalGastos,'99999999999990.00')         || '|' ||
                      TO_CHAR(nMontoReserva,'99999999999990.00')        || '|' ||
                      TO_CHAR(nTotalReservado,'99999999999990.00')      || '|' ||
                      cSts_Siniestro                                    || '|' ||
                      TO_CHAR(W.FechaTransaccion,'YYYY-MM')             || '|' ||
                      TO_CHAR(nMontoReserva,'99999999999990.00')        || '|' ||
                      TO_CHAR(dFecRes,'DD/MM/YYYY')                     || '|' ||
                      TO_CHAR(nMontoPagado,'99999999999990.00')         || '|' ||
                      TO_CHAR(dFecPago,'DD/MM/YYYY')                    || '|' ||
                      TO_CHAR(nCod_Asegurado,'99999999999990')          || '|' ||
                      cNomAsegurado                                     || '|' ||
                      TO_CHAR(dFecNacAseg,'DD/MM/YYYY')                 || '|' ||
                      TO_CHAR(W.IDetPol,'9999999999999')                || '|' ||
                      W.CodRiesgoReaseg                                 || '|' ||
                      TO_CHAR(W.FecMovDistrib,'DD/MM/YYYY')             || '|' ||
                      W.Moneda                                          || '|' ||
                      cCodTransac                                       || '|' ||
                      cDescCodTransac;
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
        RAISE_APPLICATION_ERROR(-20225,'Error en Generación de Reporte Detalle Por Reasegurador del Siniestro: '|| nIdSiniestro || '-' || cError);
   END REASEGURADOR_SINIESTRO;

   PROCEDURE TRANSACCION_ESQUEMA( cIdPoliza          VARCHAR2
                                , cCodEsquema        VARCHAR2
                                , nIdTransaccionIni  NUMBER
                                , nIdTransaccionFin  NUMBER
                                , dFecDesde          DATE
                                , dFecHasta          DATE
                                , cDescPoliza        VARCHAR2
                                , cDescEsquema       VARCHAR2 
                                , nCodCia            NUMBER
                                , cFormato           VARCHAR2
                                , nCodEmpresa        NUMBER
                                , cCodUser           VARCHAR2
                                , cNomArchivo        VARCHAR2
                                , cNomArchZip        VARCHAR2
                                , cNomDirectorio     VARCHAR2
                                , cCodReporte        VARCHAR2 ) IS
      cNumPolUnico      POLIZAS.NumPolUnico%TYPE;
      cCodContrato      REA_TIPOS_CONTRATOS.CodContrato%TYPE;
      cDescContrato     REA_TIPOS_CONTRATOS.NomContrato%TYPE;
      nPrimaTotal       FACTURAS.Monto_Fact_Moneda%TYPE;
      nSumaAsegDistrib  NUMBER(28,2);
      nPrimaDistrib     NUMBER(32,6);
      cIndDistFacult    VARCHAR2(2) := 'NO';
      cDatosVehiculo    VARCHAR2(100);
      --
      CURSOR DISTREA_Q IS
         SELECT /*+ INDEX(DT SYS_C0031885) */ RD.IdDistribRea
              , RD.NumDistrib
              , RD.CodGrupoCobert
              , RD.CodEsquema
              , RD.IdEsqContrato
              , RD.CapacidadMaxima
              , RD.Cod_Asegurado
              , RD.PorcDistrib
              , RD.SumaAsegDistrib
              , RD.PrimaDistrib
              , RD.MontoReserva
              , OC_ASEGURADO.NOMBRE_ASEGURADO(RD.Codcia, DT.CodEmpresa, RD.Cod_Asegurado) NomAsegurado
              , GT_REA_ESQUEMAS.NOMBRE_ESQUEMA(RD.CodCia, RD.CodEsquema) Esquema
              , RD.CodRiesgoReaseg
              , RD.FecVigInicial
              , RD.FecVigFinal
              , RD.FecMovDistrib
              , RD.IdCapaContrato
              , RD.IdPoliza
              , RD.IDetPol
              , RD.IdEndoso
              , RD.CodCia
              , RE.PrimasDirectas
              , RE.FactorReaseg
              , RE.PrimasCedidas
              , RE.TotalPrimasReaseg
              , RE.FactorCesion
              , P.NumPolUnico
              , REC.CodContrato
              , GT_REA_TIPOS_CONTRATOS.NOMBRE_CONTRATO(REC.CodCia, REC.CodContrato)  DescContrato
           FROM TRANSACCION             TR
              , DETALLE_TRANSACCION     DT
              , REA_DISTRIBUCION        RD
              , REA_ESQUEMAS_POLIZAS    RE
              , POLIZAS                 P
              , REA_ESQUEMAS_CONTRATOS  REC
          WHERE TR.CodCia              = DT.CodCia
            AND TR.IdTransaccion       = DT.IdTransaccion
            AND TR.FechaTransaccion   >= NVL(dFecDesde,TR.FechaTransaccion)
            AND TR.FechaTransaccion   <= NVL(dFecHasta,TR.FechaTransaccion)
            AND DT.IdTransaccion BETWEEN NVL(nIdTransaccionIni,0) AND NVL(nIdTransaccionFin,99999999999999999999)
            AND UPPER(DT.Objeto)      IN ('DETALLE_POLIZA', 'ENDOSOS')
            AND NVL(DT.Valor1,'%')  LIKE cIdPoliza
            AND RD.CodCia              = RE.CodCia
            AND RD.IdPoliza            = RE.IdPoliza
            AND RD.CodEsquema          = RE.CodEsquema
            AND RE.CodEsquema       LIKE cCodEsquema
            AND DT.MtoLocal           != 0
            AND RD.CodCia              = DT.CodCia
            AND RD.IdTransaccion       = DT.IdTransaccion
            AND RD.IdPoliza            = DT.Valor1 
            AND RD.IDetPol             = NVL(DT.Valor2,1) 
            AND RD.IdEndoso            = NVL(DT.Valor3,0)
            AND P.IdPoliza(+)          = RD.IdPoliza
            AND P.CodCia(+)            = RD.CodCia
            AND REC.CodCia(+)          = RD.CodCia
            AND REC.CodEsquema(+)      = RD.CodEsquema
            AND REC.IdEsqContrato(+)   = RD.IdEsqContrato;
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
      cTitulo2 := 'REPORTE DISTRIBUCIÓN DE REASEGURO POR ESQUEMA DE LA TRANSACCION' || TO_CHAR(nIdTransaccionIni) || ' A ' || TO_CHAR(nIdTransaccionFin);
      cTitulo3 := 'DE LA PÓLIZA ' || TO_CHAR(cIdPoliza) || ' ESQUEMA: ' || cDescEsquema;
      cTitulo4 := ' ';
      cEncabez := 'No. de Póliza Único|Consecutivo|No. Detalle de Póliza|No. Endoso|No. Distribución|Orden|Grupo Cobertura|Capacidad Máxima|% Distribución|' ||
                  'Suma Aseg. Distribuida|Prima Distribuida|Monto de Reserva|Código Asegurado|Nombre Asegurado|Esquema de Reaseguro|Contrato de Reaseguro|'  ||
                  'No. Capa Contrato|Riesgo de Reaseguro|Inicio Vigencia Transacción|Fin Vigencia Transacción|Fecha Distribución|Necesita Distribución Facultativa|' ||
                  'Primas Directas|Factor Reaseguro|Primas Cedidas|Total Primas Reaseguro|Factor Cesion'; 
      --
      INSERTA_ENCABEZADO( cFormato, nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo );
      --
      FOR W IN DISTREA_Q LOOP
         cNumPolUnico  := NVL(W.NumPolUnico, 'NO EXISTE');
         cCodContrato  := W.CodContrato;
         cDescContrato := NVL(W.DescContrato, 'NO EXISTE CONTRATO');
         -- 
         IF GT_REA_TIPOS_CONTRATOS.CONTRATO_FACULTATIVO(nCodCia, cCodContrato) = 'S' THEN
            SELECT NVL(SUM(SumaAsegDistrib),0), NVL(SUM(PrimaDistrib),0)
              INTO nSumaAsegDistrib, nPrimaDistrib
              FROM REA_DISTRIBUCION_EMPRESAS
             WHERE CodCia       = W.CodCia
               AND IdDistribRea = W.IdDistribRea
               AND NumDistrib   = W.NumDistrib;
           
            IF nSumaAsegDistrib != W.SumaAsegDistrib OR
               nPrimaDistrib    != W.PrimaDistrib THEN
               cIndDistFacult := 'SI';
            END IF;
         END IF;
         --         
         cRegistro := cNumPolUnico                                     || '|' ||
                      TO_CHAR(W.IdPoliza,'9999999999999')              || '|' ||
                      TO_CHAR(W.IDetPol,'9999999999999')               || '|' ||
                      TO_CHAR(W.IdEndoso,'9999999999999')              || '|' ||
                      TO_CHAR(W.IdDistribRea,'9999999999999')          || '|' ||
                      TO_CHAR(W.NumDistrib,'9999999999999')            || '|' ||
                      W.CodGrupoCobert                                 || '|' ||
                      TO_CHAR(W.CapacidadMaxima,'99999999999990.00')   || '|' ||
                      TO_CHAR(W.PorcDistrib,'9999999990.000000')       || '|' ||
                      TO_CHAR(W.SumaAsegDistrib,'99999999999990.00')   || '|' ||
                      TO_CHAR(W.PrimaDistrib,'99999999999990.000000')  || '|' ||
                      TO_CHAR(W.MontoReserva,'99999999999990.000000')  || '|' ||
                      TO_CHAR(W.Cod_Asegurado,'9999999999999')         || '|' ||
                      W.NomAsegurado                                   || '|' ||
                      W.Esquema                                        || '|' ||
                      cDescContrato                                    || '|' ||
                      TO_CHAR(W.IdCapaContrato,'9999999999999')        || '|' ||
                      W.CodRiesgoReaseg                                || '|' ||
                      TO_CHAR(W.FecVigInicial,'DD/MM/YYYY')            || '|' ||
                      TO_CHAR(W.FecVigFinal,'DD/MM/YYYY')              || '|' ||
                      TO_CHAR(W.FecMovDistrib,'DD/MM/YYYY')            || '|' ||
                      cIndDistFacult                                   || '|' ||
                      TO_CHAR(W.PrimasDirectas,'99999999999990.00')    || '|' ||
                      TO_CHAR(W.FactorReaseg,'90.9999999999')          || '|' ||
                      TO_CHAR(W.PrimasCedidas,'99999999999990.00')     || '|' ||
                      TO_CHAR(W.TotalPrimasReaseg,'99999999999990.00') || '|' ||
                      TO_CHAR(W.FactorCesion,'90.9999999999');
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
        RAISE_APPLICATION_ERROR(-20225,'Error en Generación de Reporte Reaseguro Por Transacción de la Póliza: ' || cError);
   END TRANSACCION_ESQUEMA;

   PROCEDURE REASEGURADOR_ESQUEMA( cIdPoliza          VARCHAR2
                                 , cCodEsquema        VARCHAR2
                                 , nIdTransaccionIni  NUMBER
                                 , nIdTransaccionFin  NUMBER
                                 , dFecDesde          DATE
                                 , dFecHasta          DATE
                                 , cDescPoliza        VARCHAR2
                                 , cDescIDetPol       VARCHAR2
                                 , cDescIdEndoso      VARCHAR2
                                 , nCodCia            NUMBER
                                 , cFormato           VARCHAR2
                                 , nCodEmpresa        NUMBER
                                 , cCodUser           VARCHAR2
                                 , cNomArchivo        VARCHAR2
                                 , cNomArchZip        VARCHAR2
                                 , cNomDirectorio     VARCHAR2
                                 , cCodReporte        VARCHAR2 ) IS
      cNumPolUnico      POLIZAS.NumPolUnico%TYPE;
      cCodContrato      REA_TIPOS_CONTRATOS.CodContrato%TYPE;
      cDescContrato     REA_TIPOS_CONTRATOS.NomContrato%TYPE;
      nSumaAsegDistrib  NUMBER(28,2);
      nPrimaDistrib     NUMBER(32,6);
      cIndDistFacult    VARCHAR2(2) := 'NO';
      nPrimaTotal       FACTURAS.Monto_Fact_Moneda%TYPE;
      nPrimaTotalNoDev  FACTURAS.Monto_Fact_Moneda%TYPE;
      nPrimaTotalDev    FACTURAS.Monto_Fact_Moneda%TYPE;
      cDesc_Marca       MARCA.Desc_Marca%TYPE;
      cDesc_Modelo      MODELO.Desc_Modelo%TYPE;
      cDesc_Version     VARCHAR2(100);
      cDescUsoVehiculo  VALORES_DE_LISTAS.DescValLst%TYPE;
      cDescZonaGeo      VALORES_DE_LISTAS.DescValLst%TYPE;
      dFecAnul          DETALLE_POLIZA.FecAnul%TYPE;
      nFactorNoDev      NUMBER(12,6);
      cExisteVehiculo   VARCHAR2(1);
      --
      CURSOR DISTREA_Q IS
         SELECT /*+ INDEX(DT SYS_C0031885) */ RD.IdDistribRea
              , RD.NumDistrib
              , RD.CodGrupoCobert
              , RD.CodEsquema
              , RD.IdEsqContrato
              , RD.Cod_Asegurado
              , RD.IdCapaContrato
              , OC_ASEGURADO.NOMBRE_ASEGURADO(RD.Codcia, DT.CodEmpresa, RD.Cod_Asegurado) NomAsegurado
              , GT_REA_ESQUEMAS.NOMBRE_ESQUEMA(RD.CodCia, RD.CodEsquema) Esquema
              , RD.CodRiesgoReaseg
              , RD.IdPoliza
              , RD.IDetPol
              , RD.IdEndoso
              , RD.CodCia
              , RDE.CodEmpresaGremio
              , GT_REA_EMPRESAS_GREMIO.NOMBRE_EMPRESA(RDE.CodCia, RDE.CodEmpresaGremio) NombreReasegurador
              , RDE.CodInterReaseg
              , RD.FecVigInicial
              , RD.FecVigFinal
              , RD.FecMovDistrib
              , DECODE(GT_REA_EMPRESAS_GREMIO.NOMBRE_EMPRESA(RDE.CodCia, RDE.CodInterReaseg),'Empresa del Gremio - NO EXISTE!!!','',
                       GT_REA_EMPRESAS_GREMIO.NOMBRE_EMPRESA(RDE.CodCia, RDE.CodInterReaseg)) NomInterReaseg
              , RDE.FecLiberacionRvas
              , RDE.ImpRvasLiberadas
              , RDE.IntRvasLiberadas
              , RDE.PorcDistrib
              , RDE.PrimaDistrib
              , RDE.MontoComision
              , RDE.MontoReserva
              , RDE.IdLiquidacion
              , RDE.SumaAsegDistrib
              , RE.PrimasDirectas
              , RE.FactorReaseg
              , RE.PrimasCedidas
              , RE.TotalPrimasReaseg
              , RE.FactorCesion
              , P.NumPolUnico
              , REC.CodContrato
              , GT_REA_TIPOS_CONTRATOS.NOMBRE_CONTRATO(REC.CodCia, REC.CodContrato)  DescContrato
           FROM TRANSACCION TR
              , DETALLE_TRANSACCION        DT
              , REA_DISTRIBUCION           RD
              , REA_DISTRIBUCION_EMPRESAS  RDE
              , REA_ESQUEMAS_POLIZAS       RE
              , POLIZAS                    P
              , REA_ESQUEMAS_CONTRATOS     REC
          WHERE TR.CodCia              = DT.CodCia
            AND TR.IdTransaccion       = DT.IdTransaccion
            AND TR.FechaTransaccion   >= NVL(dFecDesde,TR.FechaTransaccion)
            AND TR.FechaTransaccion   <= NVL(dFecHasta,TR.FechaTransaccion)
            AND DT.IdTransaccion BETWEEN NVL(nIdTransaccionIni,0) AND NVL(nIdTransaccionFin,99999999999999999999)
            AND UPPER(DT.Objeto)      IN ('DETALLE_POLIZA', 'ENDOSOS')
            AND NVL(DT.Valor1,'%')  LIKE cIdPoliza
            AND DT.MtoLocal           != 0
            AND TR.CodCia              = DT.CodCia
            AND TR.IdTransaccion       = DT.IdTransaccion
            AND RD.CodCia              = RE.CodCia
            AND RD.IdPoliza            = RE.IdPoliza
            AND RD.CodEsquema          = RE.CodEsquema
            AND RE.CodEsquema       LIKE cCodEsquema
            AND RD.CodCia              = DT.CodCia
            AND RD.IdTransaccion       = DT.IdTransaccion
            AND RD.IdPoliza            = DT.Valor1 
            AND RD.IDetPol             = NVL(DT.Valor2,1) 
            AND RD.IdEndoso            = NVL(DT.Valor3,0)
            AND RD.CodCia              = RDE.CodCia 
            AND RD.IdDistribRea        = RDE.IdDistribRea 
            AND RD.NumDistrib          = RDE.NumDistrib
            AND P.IdPoliza(+)          = RD.IdPoliza
            AND P.CodCia(+)            = RD.CodCia
            AND REC.CodCia(+)          = RD.CodCia
            AND REC.CodEsquema(+)      = RD.CodEsquema
            AND REC.IdEsqContrato(+)   = RD.IdEsqContrato;
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
      cTitulo2 := 'REPORTE DISTRIBUCIÓN DE REASEGURO DETALLE POR ESQUEMA, PÓLIZA: ' || cDescPoliza;
      cTitulo3 := ' DETALLE: ' || cDescIDetPol || ' ENDOSO: ' || cDescIdEndoso;
      cTitulo4 := ' ';
      cEncabez := 'No. de Póliza Único|Consecutivo|No. Detalle de Póliza|No. Endoso|No. Distribución|Orden|Grupo Cobertura|Código Asegurado|Nombre Asegurado|'   ||
                  'Esquema de Reaseguro|Contrato de Reaseguro|No. Capa Contrato|Código Reasegurador|Nombre Reasegurador|Código Intermediario Reaseguro|'         ||
                  'Nombre Intermediario Reaseguro|% Distribución|Suma Asegurada Distribuida|Prima Distribuida|Comisión Reaseguro|Total Reserva|No. Liquidación|' ||
                  'Fecha Liberación Reservas|Impuestos Reserva Liberada|Intereses Reserva Liberada|Primas Directas|Factor de Reaseguro|Primas Cedidas|'          ||
                  'Total de Primas Reaseguro|Factor Cesión'; 
      --
      INSERTA_ENCABEZADO( cFormato, nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo );
      --
      FOR W IN DISTREA_Q LOOP
         cNumPolUnico  := NVL(W.NumPolUnico, 'NO EXISTE');
         cCodContrato  := W.CodContrato;
         cDescContrato := NVL(W.DescContrato, 'NO EXISTE CONTRATO');
         --
         cRegistro := cNumPolUnico                                     || '|' ||
                      TO_CHAR(W.IdPoliza,'9999999999999')              || '|' ||
                      TO_CHAR(W.IDetPol,'9999999999999')               || '|' ||
                      TO_CHAR(W.IdEndoso,'9999999999999')              || '|' ||
                      TO_CHAR(W.IdDistribRea,'9999999999999')          || '|' ||
                      TO_CHAR(W.NumDistrib,'9999999999999')            || '|' ||
                      W.CodGrupoCobert                                 || '|' ||
                      TO_CHAR(W.Cod_Asegurado,'9999999999999')         || '|' ||
                      W.NomAsegurado                                   || '|' ||
                      W.Esquema                                        || '|' ||
                      cDescContrato                                    || '|' ||
                      TO_CHAR(W.IdCapaContrato,'9999999999999')        || '|' ||
                      TO_CHAR(W.CodEmpresaGremio,'9999999999999')      || '|' ||
                      W.NombreReasegurador                             || '|' ||
                      TO_CHAR(W.CodInterReaseg,'9999999999999')        || '|' ||
                      W.NomInterReaseg                                 || '|' ||
                      TO_CHAR(W.PorcDistrib,'9999999990.000000')       || '|' ||
                      TO_CHAR(W.SumaAsegDistrib,'99999999999990.00')   || '|' ||
                      TO_CHAR(W.PrimaDistrib,'99999999999990.000000')  || '|' ||
                      TO_CHAR(W.MontoComision,'99999999999990.000000') || '|' ||
                      TO_CHAR(W.MontoReserva,'99999999999990.000000')  || '|' ||
                      TO_CHAR(W.IdLiquidacion,'9999999999999')         || '|' ||
                      TO_CHAR(W.FecLiberacionRvas,'DD/MM/YYYY')        || '|' ||
                      TO_CHAR(W.ImpRvasLiberadas,'99999999999990.00')  || '|' ||
                      TO_CHAR(W.IntRvasLiberadas,'99999999999990.00')  || '|' ||
                      TO_CHAR(W.PrimasDirectas,'99999999999990.00')    || '|' ||
                      TO_CHAR(W.FactorReaseg,'90.9999999999')          || '|' ||
                      TO_CHAR(W.PrimasCedidas,'99999999999990.00')     || '|' ||
                      TO_CHAR(W.TotalPrimasReaseg,'99999999999990.00') || '|' ||
                      TO_CHAR(W.FactorCesion,'90.9999999999');
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
        RAISE_APPLICATION_ERROR(-20225,'Error en Generación de Reporte Detalle Por Reasegurador' || cError);
   END REASEGURADOR_ESQUEMA;

   PROCEDURE SINIESTRO_RECUPERADO( cIdPoliza           VARCHAR2
                                 , cIdSiniestro        VARCHAR2
                                 , cCodEmpGrem         VARCHAR2
                                 , cIdTipoSeg          VARCHAR2
                                 , cCodEsqema          VARCHAR2
                                 , cContrato           VARCHAR2
                                 , cStsSiniestro       VARCHAR2
                                 , dFecDesde           DATE
                                 , dFecHasta           DATE
                                 , cDescIntermediario  VARCHAR2
                                 , cDescEsquema        VARCHAR2
                                 , cDescContrato       VARCHAR2
                                 , cDescripRamo        VARCHAR2
                                 , nCodCia             NUMBER
                                 , cFormato            VARCHAR2
                                 , nCodEmpresa         NUMBER
                                 , cCodUser            VARCHAR2
                                 , cNomArchivo         VARCHAR2
                                 , cNomArchZip         VARCHAR2
                                 , cNomDirectorio      VARCHAR2
                                 , cCodReporte         VARCHAR2 ) IS
      dFec_Resva          DATE;
      dFec_Pago           DATE;
      cDescStsSinies      VARCHAR2(50);
      nSiniestro          SINIESTRO.IdSiniestro%TYPE;
      --
      CURSOR DISTREA_Q IS
         SELECT /*+ INDEX(DT SYS_C0031885) */ DISTINCT S.CodCia
              , S.IdSiniestro
              , S.NumSinNom Nomencl
              , S.NumSiniRef                                                            Referencia
              , OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente)                                Contratante
              , P.NumPolUnico                                                           Num_Pol_Unic
              , P.IdPoliza
              , P.FecIniVig                                                             Pol_Fec_Ini_Vig
              , P.FecFinVig                                                             Pol_Fec_Fin_Vig
              , S.Fec_Notificacion                                                      Fec_Notif
              , S.FecSts                                                                Fec_Registro
              , S.Fec_Ocurrencia                                                        Fec_Ocurr
              , S.Sts_Siniestro                                                         Estatus_Sini
              , S.Motivo_De_Siniestro                                                   Cod_Caus_Sini
              , OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CAUSIN',S.Motivo_De_Siniestro)       Desc_Causa_Sini
              , D.IdEndoso
              , D.IdDistribRea                                                          No_Distrib
              , D.NumDistrib                                                            Orden
              , D.CodGrupoCobert                                                        Gpo_Cob_Afect
              , D.CapacidadMaxima                                                       Cap_Max
              , D.PorcDistrib                                                           Porc_Distrib
              , D.SumaAsegDistrib                                                       Sum_Aseg_Distr
              , TO_CHAR(D.FecMovDistrib,'YYYYMM')                                       Ano_Mes_Mov
              , S.Monto_Reserva_Moneda                                                  Mto_Resva
              , S.Monto_Pago_Moneda                                                     Mto_Pago
              , D.Cod_Asegurado                                                         Cod_Aseg
              , OC_ASEGURADO.NOMBRE_ASEGURADO(S.CodCia, S.CodEmpresa, D.Cod_Asegurado)  Asegurado
              , OC_ASEGURADO.FECHA_NACIMIENTO(S.CodCia, S.CodEmpresa, D.Cod_Asegurado)  Fec_Nac_Aseg
              , D.IdetPol                                                               Certificado
              , GT_REA_ESQUEMAS.NOMBRE_ESQUEMA(D.CodCia, D.CodEsquema)                  Esq_Reaseg
              , GT_REA_TIPOS_CONTRATOS.NOMBRE_CONTRATO(D.CodCia, C.CodContrato)         Cto_Reaseg
              , D.IdCapaContrato                                                        Capa_Cto
              , D.CodRiesgoReaseg                                                       Riesgo_Reaseg
              , D.FecMovDistrib                                                         Fec_Distrib
              , OC_MONEDA.DESCRIPCION_MONEDA(P.Cod_Moneda)                              Moneda
              , D.IdTransaccion
           FROM REA_DISTRIBUCION_EMPRESAS  E
              , REA_ESQUEMAS_CONTRATOS     C
              , REA_DISTRIBUCION           D
              , DETALLE_POLIZA             DP
              , SINIESTRO                  S
              , POLIZAS                    P
          WHERE E.CodCia              = D.CodCia
            AND E.IdDistribRea        = D.IdDistribRea
            AND C.CodCia              = D.CodCia
            AND C.CodEsquema          = D.CodEsquema
            AND C.IdEsqContrato       = D.IdEsqContrato
            AND DP.CodCia             = D.CodCia
            AND DP.IdPoliza           = D.IdPoliza
            AND DP.IDetPol            = D.IDetPol
            AND P.CodCia              = D.CodCia
            AND P.IdPoliza            = D.IdPoliza
            AND S.CodCia              = D.CodCia
            AND S.IdSiniestro         = D.IdSiniestro
            AND S.Fec_Ocurrencia     >= NVL(dFecDesde,S.Fec_Ocurrencia)
            AND S.Fec_Ocurrencia     <= NVL(dFecHasta,S.Fec_Ocurrencia)
            AND D.IdPoliza         LIKE cIdPoliza
            AND D.IdSiniestro      LIKE cIdSiniestro
            AND D.CodEsquema       LIKE cCodEsqema
            AND D.IdEsqContrato    LIKE cContrato
            AND DP.IdTipoSeg       LIKE cIdTipoSeg
            AND E.CodEmpresaGremio LIKE cCodEmpGrem
            AND S.Sts_Siniestro    LIKE cStsSiniestro;
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
      IF cStsSiniestro = '%' THEN
         cDescStsSinies := 'Todos los Siniestros';
      ELSIF cStsSiniestro = 'EMI' THEN
         cDescStsSinies := 'Siniestros Ocurridos';
      ELSIF cStsSiniestro = 'PGP' THEN
         cDescStsSinies := 'Siniestros Pendientes de Pago';
      ELSIF cStsSiniestro = 'PGT' THEN
         cDescStsSinies := 'Siniestros Totalmente Pagados';
      END IF;
      --
      cTitulo1 := NOMBRE_COMPANIA(nCodCia);
      cTitulo2 := 'REPORTE DISTRIBUCION SINIESTROS RECUPERADOS INTERMEDIARIO DE REASEGURO / SUCRIPTOR FACULTADO: ' || TO_CHAR(cDescIntermediario);
      cTitulo3 := 'TIPO DE CONTRATO: ' || TO_CHAR(cDescEsquema) || '  CONTRATO: ' || TO_CHAR(cDescContrato) || '  RAMO: '||TO_CHAR(cDescripRamo) || '  PERIODO: '||
                  TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' AL ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || '  ESTADO DEL SINIESTRO: ' || cDescStsSinies;
      cTitulo4 := ' ';
      cEncabez := 'No. de Siniestro|No. Siniestro - Nomenclatura|No. Referencia / Siniestro|Contratante|No. de Póliza Único|No. de Póliza Consecutivo|'       ||
                  'Inicio Vigencia Póliza|Fin Vigencia Póliza|Fecha Notificación|Fecha Registro|Fecha Ocurrencia|Estatus Siniestro|Codigo Causa Siniestro|'   ||
                  'Descripcion Causa Siniestro|No. Endoso Afectado|No. Distribución|Orden|Grupo Cobertura Afectada|Capacidad Máxima|% Distribución|'          ||
                  'Suma Aseg. Distribuida|Año-Mes de Movimiento|Monto de Reserva|Fecha Reserva|Monto de Pagado|Fecha Pago|Código Asegurado|Nombre Asegurado|' ||
                  'Fecha de Nacimiento|Certificado|Esquema de Reaseguro|Contrato de Reaseguro|No. Capa Contrato|Riesgo de Reaseguro|Fecha Distribución|Moneda'; 
      --
      INSERTA_ENCABEZADO( cFormato, nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo );
      --
      FOR W IN DISTREA_Q LOOP
         nSiniestro := W.IdSiniestro;
         IF OC_SINIESTRO.SINIESTRO_DE_ASEGURADO(W.CodCia, W.IdPoliza, W.Certificado, W.IdSiniestro) = 'N' THEN
            BEGIN
               SELECT MAX(FecRes)
                 INTO dFec_Resva
                 FROM COBERTURA_SINIESTRO
                WHERE IdPoliza      = W.IdPoliza
                  AND IdSiniestro   = W.IdSiniestro
                  AND IdTransaccion = W.IdTransaccion;
            EXCEPTION
            WHEN OTHERS THEN
               dFec_Resva := NULL;
            END;
            --
            BEGIN
               SELECT MAX(T.FechaTransaccion)
                 INTO dFec_Pago
                 FROM APROBACIONES  A, TRANSACCION T
                WHERE A.IdTransaccion = T.IdTransaccion
                  AND A.IdPoliza      = W.IdPoliza
                  AND A.IdSiniestro   = W.IdSiniestro
                  AND A.IdTransaccion = W.IdTransaccion;
            EXCEPTION
            WHEN OTHERS THEN
               dFec_Pago := NULL;
            END;
         ELSE
            BEGIN
               SELECT MAX(FecRes) 
                 INTO dFec_Resva
                 FROM COBERTURA_SINIESTRO_ASEG
                WHERE IdPoliza      = W.IdPoliza
                  AND IdSiniestro   = W.IdSiniestro
                  AND CodCobert     = W.IdTransaccion
                  AND Cod_Asegurado = W.Cod_Aseg;
            EXCEPTION
            WHEN OTHERS THEN
               dFec_Resva := NULL;
            END;
            --
            BEGIN
               SELECT MAX(T.FechaTransaccion)
                 INTO dFec_Pago
                 FROM APROBACION_ASEG  A, TRANSACCION T
                WHERE A.IdTransaccion = T.IdTransaccion
                  AND A.IdPoliza      = W.IdPoliza
                  AND A.IdSiniestro   = W.IdSiniestro
                  AND A.IdTransaccion = W.IdTransaccion
                  AND A.Cod_Asegurado = W.Cod_Aseg;
            EXCEPTION
            WHEN OTHERS THEN
               dFec_Pago := NULL;
            END;
         END IF;
         --
         cRegistro := TO_CHAR(W.IdSiniestro,'9999999999999')     || '|' ||
                      W.Nomencl                                  || '|' ||
                      W.Referencia                               || '|' ||
                      W.Contratante                              || '|' ||
                      W.Num_Pol_Unic                             || '|' ||
                      TO_CHAR(W.IdPoliza,'9999999999999')        || '|' ||
                      TO_CHAR(W.Pol_Fec_Ini_Vig,'DD/MM/YYYY')    || '|' ||
                      TO_CHAR(W.Pol_Fec_Fin_Vig,'DD/MM/YYYY')    || '|' ||
                      TO_CHAR(W.Fec_Notif,'DD/MM/YYYY')          || '|' ||
                      TO_CHAR(W.Fec_Registro,'DD/MM/YYYY')       || '|' ||
                      TO_CHAR(W.Fec_Ocurr,'DD/MM/YYYY')          || '|' ||
                      W.Estatus_Sini                             || '|' ||
                      TO_CHAR(W.Cod_Caus_Sini,'9999999999999')   || '|' ||
                      W.Desc_Causa_Sini                          || '|' ||
                      TO_CHAR(W.IdEndoso,'9999999999999')        || '|' ||
                      TO_CHAR(W.No_Distrib,'9999999999999')      || '|' ||
                      TO_CHAR(W.Orden,'9999999999999')           || '|' ||
                      W.Gpo_Cob_Afect                            || '|' ||
                      TO_CHAR(W.Cap_Max,'99999999990.00')        || '|' ||
                      TO_CHAR(W.Porc_Distrib,'9999990.000000')   || '|' ||
                      TO_CHAR(W.Sum_Aseg_Distr,'99999999990.00') || '|' ||
                      W.Ano_Mes_Mov                              || '|' ||
                      TO_CHAR(W.Mto_Resva,'99999999990.00')      || '|' ||
                      TO_CHAR(dFec_Resva,'DD/MM/YYYY')           || '|' ||
                      TO_CHAR(W.Mto_Pago,'99999999990.00')       || '|' ||
                      TO_CHAR(dFec_Pago,'DD/MM/YYYY')            || '|' ||
                      TO_CHAR(W.Cod_Aseg,'9999999999999')        || '|' ||
                      W.Asegurado                                || '|' ||
                      TO_CHAR(W.Fec_Nac_Aseg,'DD/MM/YYYY')       || '|' ||
                      TO_CHAR(W.Certificado,'9999999999999')     || '|' ||
                      W.Esq_Reaseg                               || '|' ||
                      W.Cto_Reaseg                               || '|' ||
                      TO_CHAR(W.Capa_Cto,'9999999999999')        || '|' ||
                      W.Riesgo_Reaseg                            || '|' ||
                      W.Fec_Distrib                              || '|' ||
                      W.Moneda;
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
        RAISE_APPLICATION_ERROR(-20225,'Error en Generación de Reporte Siniestros Recuperados: Siniestro' || nSiniestro || ' ' || cError);
   END SINIESTRO_RECUPERADO;
   
   PROCEDURE CALENDARIOS( nCodCia       NUMBER
                        , dFecDesde     DATE
                        , dFecHasta     DATE
                        , cCodEsquema   VARCHAR2
                        , cCodContrato  VARCHAR2
                        , cFormato      VARCHAR2 ) IS
   cLimitador           VARCHAR2(20);
   cLimitadorTxt        VARCHAR2(1)    :='|';
   cCampoFormatC        VARCHAR2(4000) := '<td class=texto>';
   cCampoFormatN        VARCHAR2(4000) := '<td class=numero>';
   cCampoFormatD        VARCHAR2(4000) := '<td class=fecha>';
   --
   nLinea               NUMBER := 1;
   cCadena              VARCHAR2(10000);
   cCodUser             USUARIOS.CodUsuario%TYPE;
   --
   cDescEsquema         REA_ESQUEMAS.DescEsquema%TYPE;
   cNomContrato         REA_TIPOS_CONTRATOS.NomContrato%TYPE;

   CURSOR CAL_Q IS
      SELECT E.CodEsquema, E.DescEsquema, E.TipoEsquema, E.FecIniEsquema, E.FecFinEsquema,
             C.CodContrato, GT_REA_TIPOS_CONTRATOS.NOMBRE_CONTRATO(E.CodCia, C.CodContrato) DescContrato,
             C.CodRiesgo, GT_REA_RIESGOS.DESCRIPCION_RIESGO(E.CodCia, C.CodRiesgo) DescRiesgo,
             C.FecVigInicial FecIniContrato, C.FecVigFinal FecFinContrato, EC.IdCapaContrato, 
             EC.FecVigInicial FecIniCapaContrato, EC.FecVigFinal FecFinCapaContrato, EC.PorcCapa,
             EE.CodEmpresaGremio, GT_REA_EMPRESAS_GREMIO.NOMBRE_EMPRESA(E.CodCia, EE.CodEmpresaGremio) NombreEmpresaGremio,
             EE.PorcEmpresa, EE.CodInterReaseg, GT_REA_EMPRESAS_GREMIO.NOMBRE_EMPRESA(E.CodCia, EE.CodInterReaseg) NombreInterReaseg, 
             REC.IdCalendario, REC.FecEnvioEstadoCta, REC.FechaPago, REC.FecRealEntrega, RC.IdAlerta,
             RC.Tipo TipoAlerta, RC.Dias NumDiasAlerta, RC.Repeticion Repite, RC.Correos
        FROM REA_ESQUEMAS E, REA_ESQUEMAS_CONTRATOS C, 
             REA_ESQUEMAS_CAPAS EC, REA_ESQUEMAS_EMPRESAS EE,
             REA_EMPRESAS_GREMIO EG, PERSONA_NATURAL_JURIDICA PJ,
             REA_ESQUEMAS_CALENDARIO REC, REA_CORREO_ALERTAS RC
       WHERE E.CodCia                     = nCodCia
         AND (REC.FecEnvioEstadoCta      >= NVL(dFecDesde,REC.FecEnvioEstadoCta)
         AND REC.FecEnvioEstadoCta       <= NVL(dFecHasta,REC.FecEnvioEstadoCta)
          OR REC.FechaPago               >= NVL(dFecDesde,REC.FechaPago)
         AND REC.FechaPago               <= NVL(dFecHasta,REC.FechaPago))
         AND ((E.CodEsquema               = cCodEsquema AND cCodEsquema != '%')
          OR  (E.CodEsquema            LIKE cCodEsquema AND cCodEsquema = '%'))
         AND ((C.CodContrato              = cCodContrato AND cCodContrato != '%')
          OR  (C.CodContrato           LIKE cCodContrato AND cCodContrato = '%'))
         AND E.StsEsquema                 = 'ACTIVO'
         AND E.CodCia                     = C.CodCia
         AND E.CodEsquema                 = C.CodEsquema
         AND C.CodCia                     = EC.CodCia
         AND C.CodEsquema                 = EC.CodEsquema
         AND C.IdEsqContrato              = EC.IdEsqContrato
         AND EC.CodCia                    = EE.CodCia
         AND EC.CodEsquema                = EE.CodEsquema
         AND EC.IdEsqContrato             = EE.IdEsqContrato
         AND EC.IdCapaContrato            = EE.IdCapaContrato
         AND EE.CodCia                    = EG.CodCia
         AND EE.CodEmpresaGremio          = EG.CodEmpresaGremio
         AND EG.Tipo_Doc_Identificacion   = PJ.Tipo_Doc_Identificacion
         AND EG.Num_Doc_Identificacion    = PJ.Num_Doc_Identificacion
         AND EE.CodCia                    = REC.CodCia
         AND EE.CodEsquema                = REC.CodEsquema
         AND EE.IdEsqContrato             = REC.IdEsqContrato
         AND EE.IdCapaContrato            = REC.IdCapaContrato
         AND EE.CodEmpresaGremio          = REC.CodEmpresaGremio
         AND REC.CodCia                   = RC.CodCia(+)
         AND REC.CodEsquema               = RC.CodEsquema(+)
         AND REC.IdEsqContrato            = RC.IdEsqContrato(+)
         AND REC.IdCapaContrato           = RC.IdCapaContrato(+)
         AND REC.CodEmpresaGremio         = RC.CodEmpresaGremio(+)
         AND REC.IdCalendario             = RC.IdCalendario(+)
       ORDER BY EC.IdEsqContrato, EE.CodEmpresaGremio, REC.IdCalendario;
   BEGIN
      SELECT USER INTO cCodUser FROM DUAL;
       
      IF NVL(cCodEsquema,'%') != '%' THEN
         cDescEsquema := GT_REA_ESQUEMAS.NOMBRE_ESQUEMA(nCodCia, cCodEsquema);
      END IF;
       
      IF NVL(cCodContrato,'%') != '%' THEN
         cNomContrato := GT_REA_TIPOS_CONTRATOS.NOMBRE_CONTRATO(nCodCia, cCodContrato);
      END IF;
       
      IF cFormato = 'TEXTO' THEN
         cLimitador := '|'; 
         nLinea      := 1;
         cCadena     := NOMBRE_COMPANIA(nCodCia) || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'REPORTE CALENDARIOS';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'TIPO DE CONTRATO: '||TO_CHAR(cDescEsquema);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'CONTRATO: '||TO_CHAR(cNomContrato);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'PERIODO: '||TO_CHAR(dFecDesde,'DD/MM/YYYY')||' AL '||TO_CHAR(dFecHasta,'DD/MM/YYYY');
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := ' ' || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         nLinea  := nLinea + 1;
         cCadena := 'Código Esquema'                     ||cLimitador||
                    'Descripción Esquema'                ||cLimitador||
                    'Tipo Esquema'                       ||cLimitador||
                    'Inicio Vigencia Esquema'            ||cLimitador||
                    'Fin Vigencia Esquema'               ||cLimitador||
                    'Código Contrato'                    ||cLimitador||
                    'Descripción Contrato'               ||cLimitador||
                    'Código Riesgo'                      ||cLimitador||
                    'Descripción Riesgo'                 ||cLimitador||
                    'Inicio Vigencia Contrato'           ||cLimitador||
                    'Fin Vigencia Contrato'              ||cLimitador||
                    'Número Capa Contrato'               ||cLimitador||
                    'Inicio Vigencia Capa Contrato'      ||cLimitador||
                    'Fin Vigencia Capa Contrato'         ||cLimitador||
                    '% Capa'                             ||cLimitador||
                    'Código Empresa Capa'                ||cLimitador||
                    'Nombre Empresa Capa'                ||cLimitador||
                    '% Distribución Empresa Capa'        ||cLimitador||
                    'Código Intermediario Reaseguro'     ||cLimitador||
                    'Nombre Intermediario'               ||cLimitador||
                    'Número Calendario'                  ||cLimitador||
                    'Fecha Envío Estado de Cuenta'       ||cLimitador||
                    'Fecha Pago'                         ||cLimitador||
                    'Fecha Real Entrega'                 ||cLimitador||
                    'Número Alerta'                      ||cLimitador||
                    'Tipo Alerta'                        ||cLimitador||
                    'Días Ejecución Alerta'              ||cLimitador||
                    'Indica Repite Alerta'               ||cLimitador||
                    'Correos Destinatarios Alerta'       ||CHR(13); 
      ELSE
         cLimitador  := '</td>';
         nLinea      := 1;
         cCadena     := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'                                                                       ||chr(10)||
                       ' xmlns:x="urn:schemas-microsoft-com:office:excel"'                                                                              ||chr(10)||
                       ' xmlns="http://www.w3.org/TR/REC-html40">'                                                                                      ||chr(10)||
                       ' <style id="libro">'                                                                                                            ||chr(10)||
                       '   <!--table'                                                                                                                   ||chr(10)||
                       '       {mso-displayed-decimal-separator:"\.";'                                                                                  ||chr(10)||
                       '        mso-displayed-thousand-separator:"\,";}'                                                                                ||chr(10)||
                       '        .texto'                                                                                                                 ||chr(10)||
                       '          {mso-number-format:"\@";}'                                                                                            ||chr(10)||
                       '        .numero'                                                                                                                ||chr(10)||
                       '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                       '        .fecha'                                                                                                                 ||chr(10)||
                       '          {mso-number-format:"dd\\-mmm\\-yyyy";}'                                                                               ||chr(10)||
                       '    -->'                                                                                                                        ||chr(10)||
                       ' </style><div id="libro">'                                                                                                      ||chr(10);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<table border = 0><tr><th>' || OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia) || '</th></tr>'; 
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>REPORTE CALENDARIOS </th></tr>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
               
         IF NVL(cCodEsquema,'%') != '%' THEN
            nLinea  := nLinea + 1;
            cCadena := '<tr><th>TIPO DE CONTRATO: '||TO_CHAR(cDescEsquema)||'</th></tr>';
            OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         END IF;
         --
         IF NVL(cCodContrato,'%') != '%' THEN
            nLinea  := nLinea + 1;
            cCadena := '<tr><th>CONTRATO: '||TO_CHAR(cNomContrato)||'</th></tr>';
            OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         END IF;
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>PERIODO: '||TO_CHAR(dFecDesde,'DD/MM/YYYY')||' AL '||TO_CHAR(dFecHasta,'DD/MM/YYYY')||'</th></tr>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>  </th></tr></table>'; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Esquema</font></th>'   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción Esquema</font></th>'                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Esquema</font></th>'                           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Inicio Vigencia Esquema</font></th>'                ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fin Vigencia Esquema</font></th>'                   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Contrato</font></th>'                        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción Contrato</font></th>'                   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Riesgo</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción Riesgo</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Inicio Vigencia Contrato</font></th>'               ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fin Vigencia Contrato</font></th>'                  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Número Capa Contrato</font></th>'                   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Inicio Vigencia Capa Contrato</font></th>'          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fin Vigencia Capa Contrato</font></th>'             ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Capa</font></th>'                                 ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Empresa Capa</font></th>'                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Empresa Capa</font></th>'                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Distribución Empresa Capa</font></th>'            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Intermediario Reaseguro</font></th>'         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Intermediario</font></th>'                   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Número Calendario</font></th>'                      ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Envío Estado de Cuenta</font></th>'           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Pago</font></th>'                             ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Real Entrega</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Número Alerta</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Alerta</font></th>'                            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Días Ejecución Alerta</font></th>'                  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Indica Repite Alerta</font></th>'                   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Correos Destinatarios Alerta</font></th>'                     
                    ;
      END IF;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      FOR W IN CAL_Q LOOP 
         IF cFormato = 'TEXTO' THEN
            cCadena := W.CodEsquema                               ||cLimitador||
                       W.DescEsquema                              ||cLimitador||
                       W.TipoEsquema                              ||cLimitador||
                       TO_CHAR(W.FecIniEsquema,'DD/MM/RRRR')      ||cLimitador||
                       TO_CHAR(W.FecFinEsquema,'DD/MM/RRRR')      ||cLimitador||
                       W.CodContrato                              ||cLimitador||
                       W.DescContrato                             ||cLimitador||
                       W.CodRiesgo                                ||cLimitador||
                       W.DescRiesgo                               ||cLimitador||
                       TO_CHAR(W.FecIniContrato,'DD/MM/RRRR')     ||cLimitador||
                       TO_CHAR(W.FecFinContrato,'DD/MM/RRRR')     ||cLimitador||
                       TO_CHAR(W.IdCapaContrato,'9999999999990')  ||cLimitador||
                       TO_CHAR(W.FecIniCapaContrato,'DD/MM/RRRR') ||cLimitador||
                       TO_CHAR(W.FecFinCapaContrato,'DD/MM/RRRR') ||cLimitador||
                       TO_CHAR(W.PorcCapa,'9999990.000000')       ||cLimitador||
                       W.CodEmpresaGremio                         ||cLimitador||
                       W.NombreEmpresaGremio                      ||cLimitador||
                       TO_CHAR(W.PorcEmpresa,'9999990.000000')    ||cLimitador||
                       W.CodInterReaseg                           ||cLimitador||
                       W.NombreInterReaseg                        ||cLimitador||
                       TO_CHAR(W.IdCalendario)                    ||cLimitador||
                       TO_CHAR(W.FecEnvioEstadoCta,'DD/MM/RRRR')  ||cLimitador||
                       TO_CHAR(W.FechaPago,'DD/MM/RRRR')          ||cLimitador||
                       TO_CHAR(W.FecRealEntrega,'DD/MM/RRRR')     ||cLimitador||
                       TO_CHAR(W.IdAlerta)                        ||cLimitador||
                       W.TipoAlerta                               ||cLimitador||
                       TO_CHAR(W.NumDiasAlerta)                   ||cLimitador||
                       W.Repite                                   ||cLimitador|| 
                       W.Correos                                  ||CHR(13);
         ELSE
            cCadena := '<tr>'                                                    ||cLimitador||
                       cCampoFormatC||W.CodEsquema                               ||cLimitador||
                       cCampoFormatC||W.DescEsquema                              ||cLimitador||
                       cCampoFormatC||W.TipoEsquema                              ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.FecIniEsquema,'DD/MM/RRRR')      ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.FecFinEsquema,'DD/MM/RRRR')      ||cLimitador||
                       cCampoFormatC||W.CodContrato                              ||cLimitador||
                       cCampoFormatC||W.DescContrato                             ||cLimitador||
                       cCampoFormatC||W.CodRiesgo                                ||cLimitador||
                       cCampoFormatC||W.DescRiesgo                               ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.FecIniContrato,'DD/MM/RRRR')     ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.FecFinContrato,'DD/MM/RRRR')     ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.IdCapaContrato,'9999999999990')  ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.FecIniCapaContrato,'DD/MM/RRRR') ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.FecFinCapaContrato,'DD/MM/RRRR') ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.PorcCapa,'9999990.000000')       ||cLimitador||
                       cCampoFormatC||W.CodEmpresaGremio                         ||cLimitador||
                       cCampoFormatC||W.NombreEmpresaGremio                      ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.PorcEmpresa,'9999990.000000')    ||cLimitador||
                       cCampoFormatC||W.CodInterReaseg                           ||cLimitador||
                       cCampoFormatC||W.NombreInterReaseg                        ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdCalendario)                    ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.FecEnvioEstadoCta,'DD/MM/RRRR')  ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.FechaPago,'DD/MM/RRRR')          ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.FecRealEntrega,'DD/MM/RRRR')     ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.IdAlerta)                        ||cLimitador||
                       cCampoFormatC||W.TipoAlerta                               ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.NumDiasAlerta)                   ||cLimitador||
                       cCampoFormatC||W.Repite                                   ||cLimitador|| 
                       cCampoFormatC||W.Correos                                  ||'</tr>';
         END IF;
         nLinea := nLinea + 1;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      END LOOP;
      
      IF cFormato = 'EXCEL' THEN
         OC_ARCHIVO.Escribir_Linea('</table></div></html>', cCodUser, 9999);
      END IF;
      OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
   EXCEPTION 
      WHEN OTHERS THEN 
         OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
         RAISE_APPLICATION_ERROR(-20225,'Error en Generación de Reporte Calendarios '||' '||SQLERRM);   
   END CALENDARIOS;

END OC_REPORTES_REASEGURO;
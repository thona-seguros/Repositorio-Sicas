CREATE OR REPLACE PACKAGE SICAS_OC.oc_reportes_reaseguro IS

   FUNCTION nombre_compania( nCodCia NUMBER ) RETURN VARCHAR2;

   PROCEDURE transaccion_poliza( cIdPoliza          VARCHAR2
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
                               , cCodUser           VARCHAR2 );

   PROCEDURE reasegurador_poliza( cIdPoliza          VARCHAR2
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
                                , cCodUser           VARCHAR2 );

   PROCEDURE transaccion_siniestro( cIdSiniestro       VARCHAR2
                                  , nIdTransaccionIni  NUMBER
                                  , nIdTransaccionFin  NUMBER
                                  , dFecDesde          DATE
                                  , dFecHasta          DATE
                                  , cIdPoliza          VARCHAR2
                                  , nCodCia            NUMBER
                                  , cFormato           VARCHAR2
                                  , cCodUser           VARCHAR2 );

   PROCEDURE reasegurador_siniestro( cIdSiniestro       VARCHAR2
                                   , nIdTransaccionIni  NUMBER
                                   , nIdTransaccionFin  NUMBER
                                   , dFecDesde          DATE
                                   , dFecHasta          DATE
                                   , cIdPoliza          VARCHAR2
                                   , nCodCia            NUMBER
                                   , cFormato           VARCHAR2
                                   , cCodUser           VARCHAR2 );

   PROCEDURE transaccion_esquema( cIdPoliza          VARCHAR2
                                , cCodEsquema        VARCHAR2
                                , nIdTransaccionIni  NUMBER
                                , nIdTransaccionFin  NUMBER
                                , dFecDesde          DATE
                                , dFecHasta          DATE
                                , cDescPoliza        VARCHAR2
                                , cDescEsquema       VARCHAR2 
                                , nCodCia            NUMBER
                                , cFormato           VARCHAR2
                                , cCodUser           VARCHAR2 );

   PROCEDURE reasegurador_esquema( cIdPoliza          VARCHAR2
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
                                 , cCodUser           VARCHAR2 );

   PROCEDURE siniestro_recuperado( cIdPoliza           VARCHAR2
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
                                 , cCodUser            VARCHAR2 );


END oc_reportes_reaseguro;
/

CREATE OR REPLACE PACKAGE BODY SICAS_OC.oc_reportes_reaseguro IS

   FUNCTION nombre_compania( nCodCia NUMBER ) RETURN VARCHAR2 IS
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
   END nombre_compania;

   PROCEDURE transaccion_poliza( cIdPoliza          VARCHAR2
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
                               , cCodUser           VARCHAR2 ) IS
      cLimitadorTxt     VARCHAR2(1)    :='|';
      cLimitador        VARCHAR2(20)   :='</td>';
      cCampoFormatC     VARCHAR2(4000) := '<td class=texto>';
      cCampoFormatN     VARCHAR2(4000) := '<td class=numero>';
      cCampoFormatD     VARCHAR2(4000) := '<td class=fecha>';
      --
      cEncabezado       VARCHAR2(1) := 'S';
      nLinea            NUMBER := 1;
      cCadena           VARCHAR2(4000);
      cNumPolUnico1     POLIZAS.NumPolUnico%TYPE;
      cCodContrato      REA_TIPOS_CONTRATOS.CodContrato%TYPE;
      cDescContrato     REA_TIPOS_CONTRATOS.NomContrato%TYPE;
      nPrimaTotal       FACTURAS.Monto_Fact_Moneda%TYPE;
      nSumaAsegDistrib  NUMBER(28,2);
      nPrimaDistrib     NUMBER(32,6);
      cIndDistFacult    VARCHAR2(2) := 'NO';
      cDatosVehiculo    VARCHAR2(100);
      --
      cNomCia           EMPRESAS.NOMCIA%TYPE;
      --
      CURSOR DISTREA_Q IS
         SELECT RD.IdDistribRea
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
           FROM TRANSACCION             TR
              , DETALLE_TRANSACCION     DT
              , REA_DISTRIBUCION        RD
              , REA_ESQUEMAS            RE 
              , POLIZAS                 P
              , REA_ESQUEMAS_CONTRATOS  REC
          WHERE TR.CodCia              = DT.CodCia
            AND TR.IdTransaccion       = DT.IdTransaccion
            AND RE.CODCIA(+)           = RD.CODCIA
            AND RE.CODESQUEMA(+)       = RD.CODESQUEMA
            AND TR.FechaTransaccion   >= NVL(dFecDesde,TR.FechaTransaccion)
            AND TR.FechaTransaccion   <= NVL(dFecHasta,TR.FechaTransaccion)
            AND DT.IdTransaccion BETWEEN NVL(nIdTransaccionIni,0) AND NVL(nIdTransaccionFin,99999999999999999999)
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
            AND DT.MtoLocal        != 0
            AND RD.CodCia           = DT.CodCia
            AND RD.IdTransaccion    = DT.IdTransaccion
            AND RD.IdPoliza         = DT.Valor1 
            AND RD.IDetPol          = NVL(DT.Valor2,1) 
            AND RD.IdEndoso         = NVL(DT.Valor3,0)
            AND P.IdPoliza(+)       = RD.IdPoliza
            AND P.CodCia(+)         = RD.CodCia
            AND REC.CodCia              = RD.CodCia
            AND REC.CodEsquema(+)       = RD.CodEsquema
            AND REC.IdEsqContrato(+)    = RD.IdEsqContrato
          ORDER BY RD.IdTransaccion, RD.IdDistribRea, RD.NumDistrib;
   --
   BEGIN
      IF cFormato = 'TEXTO' THEN
         nLinea  := 1;
         cCadena := nombre_compania(nCodCia) || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'REPORTE DISTRIBUCIÓN DE REASEGURO DE LA TRANSACCION'||TO_CHAR(nIdTransaccionIni)||' A '||TO_CHAR(nIdTransaccionFin)||CHR(13)||
                        'DE LA PÓLIZA '||TO_CHAR(cIdPoliza)||' DETALLE: '||cDescIDetPol||' ENDOSO: '||cDescIdEndoso;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         -- 
         nLinea  := nLinea + 1;
         cCadena := ' ' || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         -- 
         nLinea  := nLinea + 1;
         cCadena := 'No. de Póliza Único'        ||cLimitadorTxt||'Consecutivo'             ||cLimitadorTxt||'No. Detalle de Póliza'||cLimitadorTxt||
                    'No. Endoso'                 ||cLimitadorTxt||'No. Distribución'        ||cLimitadorTxt||'Orden'                ||cLimitadorTxt||
                    'Grupo Cobertura'            ||cLimitadorTxt||'Capacidad Máxima'        ||cLimitadorTxt||'% Distribución'       ||cLimitadorTxt||
                    'Suma Aseg. Distribuida'     ||cLimitadorTxt||'Prima Distribuida'       ||cLimitadorTxt||'Monto de Reserva'     ||cLimitadorTxt||
                    'Código Asegurado'           ||cLimitadorTxt||'Nombre Asegurado'        ||cLimitadorTxt||'Esquema de Reaseguro' ||cLimitadorTxt|| 
                    'Contrato de Reaseguro'      ||cLimitadorTxt||'No. Capa Contrato'       ||cLimitadorTxt||'Riesgo de Reaseguro'  ||cLimitadorTxt||
                    'Inicio Vigencia Transacción'||cLimitadorTxt||'Fin Vigencia Transacción'||cLimitadorTxt||'Fecha Distribución'   ||cLimitadorTxt|| 
                    'Necesita Distribución Facultativa' || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      ELSE  
         nLinea  := 1;
         cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'                                                                        ||chr(10)||
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
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>REPORTE DISTRIBUCIÓN DE REASEGURO DE LA TRANSACCION '||TO_CHAR(nIdTransaccionIni)||
                    ' A '||TO_CHAR(nIdTransaccionFin)||'</th></tr>'||CHR(10)||
                    '<tr><th>DE LA PÓLIZA '||TO_CHAR(cDescPoliza)||'</th></tr>'||CHR(10)|| 
                    '<tr><th>DEL DETALLE  '||TO_CHAR(cDescIDetPol)||'</th></tr>'||CHR(10)||
                    '<tr><th>DEL ENDOSO   '||TO_CHAR(cDescIdEndoso)||'</th></tr>'; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>  </th></tr></table>'; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza Único</font></th>' ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Consecutivo</font></th>'                               ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Detalle de Póliza</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Endoso</font></th>'                                ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Distribución</font></th>'                          || 
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Orden</font></th>'                                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Grupo Cobertura</font></th>'                           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Capacidad Máxima</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Distribución</font></th>'                            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Suma Aseg. Distribuida</font></th>'                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Prima Distribuida</font></th>'                         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto de Reserva</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Asegurado</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Asegurado</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Esquema de Reaseguro</font></th>'                      ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Contrato de Reaseguro</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Capa Contrato</font></th>'                         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Riesgo de Reaseguro</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Inicio Vigencia Transacción</font></th>'               ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fin Vigencia Transacción</font></th>'                  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Distribución</font></th>'                        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Necesita Distribución Facultativa</font></th><tr>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      END IF;

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
         IF cFormato = 'TEXTO' THEN
            cCadena := cNumPolUnico1                                  ||cLimitadorTxt||
                       TO_CHAR(W.IdPoliza,'9999999999999')            ||cLimitadorTxt||
                       TO_CHAR(W.IDetPol,'9999999999999')             ||cLimitadorTxt||
                       TO_CHAR(W.IdEndoso,'9999999999999')            ||cLimitadorTxt||
                       TO_CHAR(W.IdDistribRea,'9999999999999')        ||cLimitadorTxt||
                       TO_CHAR(W.NumDistrib,'9999999999999')          ||cLimitadorTxt||
                       W.CodGrupoCobert                               ||cLimitadorTxt||
                       TO_CHAR(W.CapacidadMaxima,'99999999999990.00') ||cLimitadorTxt||
                       TO_CHAR(W.PorcDistrib,'9999999990.000000')     ||cLimitadorTxt||
                       TO_CHAR(W.SumaAsegDistrib,'99999999999990.00') ||cLimitadorTxt||
                       TO_CHAR(W.PrimaDistrib,'99999999999990.000000')||cLimitadorTxt||
                       TO_CHAR(W.MontoReserva,'99999999999990.000000')||cLimitadorTxt||
                       TO_CHAR(W.Cod_Asegurado,'9999999999999')       ||cLimitadorTxt||
                       W.NomAsegurado                                 ||cLimitadorTxt||
                       W.Esquema                                      ||cLimitadorTxt||
                       cDescContrato                                  ||cLimitadorTxt||
                       TO_CHAR(W.IdCapaContrato,'9999999999999')      ||cLimitadorTxt||
                       W.CodRiesgoReaseg                              ||cLimitadorTxt||
                       TO_CHAR(W.FecVigInicial,'DD/MM/YYYY')          ||cLimitadorTxt||
                       TO_CHAR(W.FecVigFinal,'DD/MM/YYYY')            ||cLimitadorTxt||
                       TO_CHAR(W.FecMovDistrib,'DD/MM/YYYY')          ||cLimitadorTxt||
                       cIndDistFacult                                 ||CHR(13);
         ELSE
            cCadena := '<tr>'                                                         || 
                       cCampoFormatC||cNumPolUnico1                                   ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdPoliza,'9999999999999')             ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IDetPol,'9999999999999')              ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdEndoso,'9999999999999')             ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdDistribRea,'9999999999999')         ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.NumDistrib,'9999999999999')           ||cLimitador||
                       cCampoFormatC||W.CodGrupoCobert                                ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.CapacidadMaxima,'99999999999990.00')  ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.PorcDistrib,'9999999990.000000')      ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.SumaAsegDistrib,'99999999999990.00')  ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.PrimaDistrib,'99999999999990.000000') ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.MontoReserva,'99999999999990.000000') ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.Cod_Asegurado,'9999999999999')        ||cLimitador||
                       cCampoFormatC||W.NomAsegurado                                  ||cLimitador||
                       cCampoFormatC||W.Esquema                                       ||cLimitador||
                       cCampoFormatC||cDescContrato                                   ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdCapaContrato,'9999999999999')       ||cLimitador||
                       cCampoFormatC||W.CodRiesgoReaseg                               ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.FecVigInicial,'DD/MM/YYYY')           ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.FecVigFinal,'DD/MM/YYYY')             ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.FecMovDistrib,'DD/MM/YYYY')           ||cLimitador||
                       cCampoFormatC||cIndDistFacult                                  ||'</tr>';
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
      RAISE_APPLICATION_ERROR(-20225,'Error en Generación de Reporte Reaseguro Por Transacción de la Póliza: ' ||SQLERRM);
   END transaccion_poliza;

   PROCEDURE reasegurador_poliza( cIdPoliza          VARCHAR2
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
                                , cCodUser           VARCHAR2 ) IS
      cLimitadorTxt       VARCHAR2(1)    :='|';
      cLimitador          VARCHAR2(20)   :='</td>';
      cCampoFormatC       VARCHAR2(4000) := '<td class=texto>';
      cCampoFormatN       VARCHAR2(4000) := '<td class=numero>';
      cCampoFormatD       VARCHAR2(4000) := '<td class=fecha>';
      --
      cEncabezado         VARCHAR2(1) := 'S';
      nLinea              NUMBER := 1;
      cCadena             VARCHAR2(4000);
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
      CURSOR DISTREA_Q IS
         SELECT RD.IdDistribRea
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
      IF cFormato = 'TEXTO' THEN  
         nLinea := 1;
         cCadena     := NOMBRE_COMPANIA(nCodCia) || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea := nLinea + 1;
         cCadena     := 'REPORTE DISTRIBUCIÓN DE REASEGURO DETALLE POR REASEGURADOR, PÓLIZA: '||cDescPoliza||
                        ' DETALLE: '||cDescIDetPol||' ENDOSO: '||cDescIdEndoso;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea := nLinea + 1;
         cCadena     := ' ' || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'No. de Póliza Único'              ||cLimitadorTxt||'No. de Póliza Consecutivo'            ||cLimitadorTxt||'Inicio Vigencia Póliza'        ||cLimitadorTxt||
                    'Fin Vigencia Póliza'              ||cLimitadorTxt||'No. Detalle de Póliza'                ||cLimitadorTxt||'Contratante'                   ||cLimitadorTxt||
                    'Código Cliente'                   ||cLimitadorTxt||'No. Endoso'                           ||cLimitadorTxt||'No. Distribución'              ||cLimitadorTxt||
                    'Orden'                            ||cLimitadorTxt||'Cobertura'                            ||cLimitadorTxt||'Desc. Cobertura'               ||cLimitadorTxt||
                    'Código Asegurado'                 ||cLimitadorTxt||'Nombre Asegurado'                     ||cLimitadorTxt||'Fecha de Nacimiento'           ||cLimitadorTxt||
                    'Edad'                             ||cLimitadorTxt||'Fecha Ingreso'                        ||cLimitadorTxt||'Esquema de Reaseguro'          ||cLimitadorTxt||
                    'Contrato de Reaseguro'            ||cLimitadorTxt||'No. Capa Contrato'                    ||cLimitadorTxt||'Código Reasegurador'           ||cLimitadorTxt||
                    'Nombre Reasegurador'              ||cLimitadorTxt||'Código Intermediario Reaseguro'       ||cLimitadorTxt||'Nombre Intermediario Reaseguro'||cLimitadorTxt||
                    'Capacidad Máxima'                 ||cLimitadorTxt||'% Distribución'                       ||cLimitadorTxt||'Suma Asegurada Distribuida'    ||cLimitadorTxt||
                    'Prima Distribuida'                ||cLimitadorTxt||'% Comisión de Reaseguro'              ||cLimitadorTxt||'Comisión Reaseguro'            ||cLimitadorTxt||
                    'Monto 100% SA Cobertura'          ||cLimitadorTxt||'Monto 100% Prima Reaseguro Cobertura' ||cLimitadorTxt||'No. Liquidación'               ||cLimitadorTxt;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         cCadena := 'Fecha de Alta'                    ||cLimitadorTxt||'Endoso con el que se dió de Alta'     ||cLimitadorTxt||'Fecha de Baja'                 ||cLimitadorTxt||
                    'Endoso con el que se dió de Baja' ||cLimitadorTxt||'Endoso con el que se dió de Alta'     ||cLimitadorTxt||'Tiene Siniestro'               ||cLimitadorTxt||
                    'Fecha Cancelación'                ||cLimitadorTxt||'Prima Devengada'                      ||cLimitadorTxt||'Riesgo de Reaseguro'           ||cLimitadorTxt||
                    'Fecha Distribución'               ||cLimitadorTxt||'No. de Transacción'                   ||cLimitadorTxt||'Descrip. Transacción'          ||cLimitadorTxt||
                    'Año-Mes de Movimiento'            ||cLimitadorTxt||'Moneda'                               ||cLimitadorTxt||
                    'Necesita Distribución Facultativa'||cLimitadorTxt||'Primas Directas'                      ||cLimitadorTxt||'Factor Reaseguro'              ||cLimitadorTxt||
                    'Primas Cedidas'                   ||cLimitadorTxt||'Total Primas Reaseguro'               ||cLimitadorTxt||'Factor Cesión';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      ELSE
         nLinea := 1;
         cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'                                                                        ||chr(10)||
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
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>REPORTE DISTRIBUCIÓN DE REASEGURO DETALLE POR REASEGURADOR</th></tr>'||CHR(10)||
                    '<tr><th>DE LA PÓLIZA '||TO_CHAR(cDescPoliza)||'</th></tr>'||CHR(10)|| 
                    '<tr><th>DEL DETALLE  '||TO_CHAR(cDescIDetPol)||'</th></tr>'||CHR(10)||
                    '<tr><th>DEL ENDOSO   '||TO_CHAR(cDescIdEndoso)||'</th></tr>'; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>  </th></tr></table>'; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza Único</font></th>' ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza Consecutivo</font></th>'                 ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Inicio Vigencia Póliza</font></th>'                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fin Vigencia Póliza</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Detalle de Póliza</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Contratante</font></th>'                               ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Cliente</font></th>'                            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Endoso</font></th>'                                ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Distribución</font></th>'                          || 
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Orden</font></th>'                                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cobertura</font></th>'                                 ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Desc. Cobertura</font></th>'                           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Asegurado</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Asegurado</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Nacimiento</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Edad</font></th>'                                      ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Ingreso</font></th>'                             ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Esquema de Reaseguro</font></th>'                      ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Contrato de Reaseguro</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Capa Contrato</font></th>'                         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Reasegurador</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Reasegurador</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Intermediario Reaseguro</font></th>'            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Intermediario Reaseguro</font></th>'            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Capacidad Máxima</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Distribución</font></th>'                            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Suma Asegurada Distribuida</font></th>'                ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Prima Distribuida</font></th>'                         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Comisión Reaseguro</font></th>'                      ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisión Reaseguro</font></th>'                        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto 100% SA cobertura</font></th>'                   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto 100% Prima Reaseguro Cobertura</font></th>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         cCadena := '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Liquidación</font></th>'                           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Alta</font></th>'                             ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Endoso con el que se dió de Alta</font></th>'          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Baja</font></th>'                             ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Endoso con el que se dió de Baja</font></th>'          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tiene Siniestro</font></th>'                           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Cancelación</font></th>'                         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Prima Devengada</font></th>'                           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Riesgo de Reaseguro</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Distribución</font></th>'                        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Transacción</font></th>'                        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descrip. Transacción</font></th>'                      ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Año-Mes de Movimiento</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Moneda</font></th>'                                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Necesita Distribución Facultativa</font></th>'         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Primas Directas</font></th>'                           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Factor Reaseguro</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Primas Cedidas</font></th>'                            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total Primas Reaseguro</font></th>'                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Factor Cesión</font></th><tr>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      END IF;
            
      FOR W IN DISTREA_Q LOOP
         cNumPolUnico1  := NVL(W.NumPolUnico1, 'NO EXISTE');
         dFecIniVig     := W.FecIniVig;
         dFecFinVig     := W.FecFinVig;
         nCodCliente    := W.CodCliente;
         cNomCliente    := W.NomCliente;
         dFecEndosAlta  := W.FecEmision;
         dFecEndosBaja  := W.FecAnul;
               --
         BEGIN
            SELECT DECODE(COUNT(*),0,'NO','SI')
              INTO cTieneSiniestros
              FROM SINIESTRO
             WHERE CodCia   = W.CodCia
               AND IdPoliza = W.IdPoliza;
         END;
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
        
         nLinea := nLinea + 1;
         IF cFormato = 'TEXTO' THEN
            cCadena := cNumPolUnico1                                     ||cLimitadorTxt||
                       TO_CHAR(W.IdPoliza,'9999999999999')              ||cLimitadorTxt||
                       TO_CHAR(dFecIniVig,'DD/MM/YYYY')                 ||cLimitadorTxt||
                       TO_CHAR(dFecFinVig,'DD/MM/YYYY')                 ||cLimitadorTxt||
                       TO_CHAR(W.IDetPol,'9999999999999')               ||cLimitadorTxt||
                       cNomCliente                                      ||cLimitadorTxt||
                       TO_CHAR(nCodCliente,'9999999999999')             ||cLimitadorTxt||
                       TO_CHAR(W.IdEndoso,'9999999999999')              ||cLimitadorTxt||
                       TO_CHAR(W.IdDistribRea,'9999999999999')          ||cLimitadorTxt||
                       TO_CHAR(W.NumDistrib,'9999999999999')            ||cLimitadorTxt||
                       W.CodGrupoCobert                                 ||cLimitadorTxt||
                       cNomCobert                                       ||cLimitadorTxt||
                       TO_CHAR(W.Cod_Asegurado,'9999999999999')         ||cLimitadorTxt||
                       W.NomAsegurado                                   ||cLimitadorTxt||
                       TO_CHAR(W.FecNacimiento,'DD/MM/YYYY')            ||cLimitadorTxt||
                       TO_CHAR(nEdadAseg,'9999999999999')               ||cLimitadorTxt||
                       TO_CHAR(dFecIngreso,'DD/MM/YYYY')                ||cLimitadorTxt||
                       W.Esquema                                        ||cLimitadorTxt||
                       cDescContrato                                    ||cLimitadorTxt||
                       TO_CHAR(W.IdCapaContrato,'9999999999999')        ||cLimitadorTxt||
                       TO_CHAR(W.CodEmpresaGremio,'9999999999999')      ||cLimitadorTxt||
                       W.NombreReasegurador                             ||cLimitadorTxt||
                       TO_CHAR(W.CodInterReaseg,'9999999999999')        ||cLimitadorTxt||
                       W.NomInterReaseg                                 ||cLimitadorTxt||
                       TO_CHAR(W.CapacidadMaxima,'99999999999990.00')   ||cLimitadorTxt||
                       TO_CHAR(W.PorcDistrib,'9999999990.000000')       ||cLimitadorTxt||
                       TO_CHAR(W.SumaAsegDistrib,'99999999999990.00')   ||cLimitadorTxt||
                       TO_CHAR(W.PrimaDistrib,'99999999999990.000000')  ||cLimitadorTxt||
                       TO_CHAR(W.PorcComis,'9999999990.000000')         ||cLimitadorTxt||
                       TO_CHAR(W.MontoComision,'99999999999990.00')     ||cLimitadorTxt||
                       TO_CHAR(nSumaAsegCobert,'99999999999990.00')     ||cLimitadorTxt||
                       TO_CHAR(nPrimaCobert,'99999999999990.00')        ||cLimitadorTxt;
                       -- NO VA TO_CHAR(W.MontoReserva,'99999999999990.000000') ||cLimitadorTxt||

            OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

            cCadena := TO_CHAR(W.IdLiquidacion,'9999999999999')         ||cLimitadorTxt||
                       TO_CHAR(dFecEndosAlta,'DD/MM/YYYY')              ||cLimitadorTxt||
                       TO_CHAR(nIdEndosoAlta,'9999999999999')           ||cLimitadorTxt||
                       TO_CHAR(dFecEndosBaja,'DD/MM/YYYY')              ||cLimitadorTxt||
                       TO_CHAR(nIdEndosoBaja,'9999999999999')           ||cLimitadorTxt||
                       cTieneSiniestros                                 ||cLimitadorTxt||
                       --TO_CHAR(W.FecLiberacionRvas,'DD/MM/YYYY')       ||cLimitadorTxt||-- NO VA
                       --TO_CHAR(W.ImpRvasLiberadas,'99999999999990.00') ||cLimitadorTxt||-- NO VA
                       TO_CHAR(dFecEndosAlta,'DD/MM/YYYY')              ||cLimitadorTxt||-- Fec Cancelacion
                       TO_CHAR(nPrimaDeveng,'99999999999990.00')        ||cLimitadorTxt||-- Prima Devengada
                       W.CodRiesgoReaseg                                ||cLimitadorTxt||
                       TO_CHAR(W.FecMovDistrib,'DD/MM/RRRR')            ||cLimitadorTxt||
                       TO_CHAR(W.IdTransaccion,'9999999999999')         ||cLimitadorTxt||
                       W.Proceso                                        ||cLimitadorTxt||
                       TO_CHAR(W.FechaTransaccion,'RRRR/MM')            ||cLimitadorTxt||
                       W.Moneda                                         ||cLimitadorTxt||
                       cIndDistFacult                                   ||cLimitadorTxt|| -- Falta Definir
                       TO_CHAR(nPrimasDirectas,'99999999999990.00')     ||cLimitadorTxt|| -- Falta Definir
                       TO_CHAR(nFactorReaseg,'99999999999990.00')       ||cLimitadorTxt|| -- Falta Definir
                       TO_CHAR(nPrimasCedidas,'99999999999990.00')      ||cLimitadorTxt|| -- Falta Definir
                       TO_CHAR(nTotalPrimasReaseg,'99999999999990.00')  ||cLimitadorTxt|| -- Falta Definir
                       TO_CHAR(nFactorCesion,'99999999999990.00');  -- Falta Definir
               cCadena := cCadena || CHR(13);
         ELSE
            cCadena := '<tr>'                                                          || 
                       cCampoFormatC||cNumPolUnico1                                    ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdPoliza,'9999999999990')              ||cLimitador||
                       cCampoFormatC||TO_CHAR(dFecIniVig,'DD/MM/YYYY')                 ||cLimitador||
                       cCampoFormatC||TO_CHAR(dFecFinVig,'DD/MM/YYYY')                 ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IDetPol,'9999999999990')               ||cLimitador||
                       cCampoFormatC||cNomCliente                                      ||cLimitador||
                       cCampoFormatC||TO_CHAR(nCodCliente,'9999999999999')             ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdEndoso,'9999999999990')              ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdDistribRea,'9999999999990')          ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.NumDistrib,'9999999999990')            ||cLimitador||
                       cCampoFormatC||W.CodGrupoCobert                                 ||cLimitador||
                       cCampoFormatC||cNomCobert                                       ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.Cod_Asegurado,'9999999999990')         ||cLimitador||
                       cCampoFormatC||W.NomAsegurado                                   ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.FecNacimiento,'DD/MM/YYYY')            ||cLimitador||
                       cCampoFormatC||TO_CHAR(nEdadAseg,'9999999999999')               ||cLimitador||
                       cCampoFormatC||TO_CHAR(dFecIngreso,'DD/MM/YYYY')                ||cLimitador||
                       cCampoFormatC||W.Esquema                                        ||cLimitador||
                       cCampoFormatC||cDescContrato                                    ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdCapaContrato,'9999999999990')        ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.CodEmpresaGremio,'9999999999990')      ||cLimitador||
                       cCampoFormatC||W.NombreReasegurador                             ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.CodInterReaseg,'9999999999990')        ||cLimitador||
                       cCampoFormatC||W.NomInterReaseg                                 ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.CapacidadMaxima,'99999999999990.00')   ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.PorcDistrib,'9999999990.000000')       ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.SumaAsegDistrib,'99999999999990.00')   ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.PrimaDistrib,'99999999999990.000000')  ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.PorcComis,'9999999990.000000')         ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.MontoComision,'99999999999990.000000') ||cLimitador||
                       cCampoFormatN||TO_CHAR(nSumaAsegCobert,'99999999999990.00')     ||cLimitador||
                       cCampoFormatN||TO_CHAR(nPrimaCobert,'99999999999990.00')        ||cLimitador;

            OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

                       --cCampoFormatN||TO_CHAR(W.MontoReserva,'99999999999990.000000') ||cLimitador||-- NO VA
            cCadena := cCampoFormatC||TO_CHAR(W.IdLiquidacion,'9999999999990')         ||cLimitador||
                       cCampoFormatC||TO_CHAR(dFecEndosAlta,'DD/MM/YYYY')              ||cLimitador||
                       cCampoFormatC||TO_CHAR(nIdEndosoAlta,'9999999999999')           ||cLimitador||
                       cCampoFormatC||TO_CHAR(dFecEndosBaja,'DD/MM/YYYY')              ||cLimitador||
                       cCampoFormatC||TO_CHAR(nIdEndosoBaja,'9999999999999')           ||cLimitador||
                       cCampoFormatC||cTieneSiniestros                                 ||cLimitador||
                       --cCampoFormatC||TO_CHAR(W.FecLiberacionRvas,'DD/MM/YYYY')        ||cLimitador||-- NO VA
                       --cCampoFormatN||TO_CHAR(W.ImpRvasLiberadas,'99999999999990.00')  ||cLimitador||-- NO VA
                       cCampoFormatC||TO_CHAR(dFecEndosAlta,'DD/MM/YYYY')              ||cLimitador||-- Fec Cancelacion
                       cCampoFormatN||TO_CHAR(nPrimaDeveng,'99999999999990.00')        ||cLimitador||-- Prima Devengada
                       cCampoFormatC||W.CodRiesgoReaseg                                ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.FecMovDistrib,'DD/MM/RRRR')            ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdTransaccion,'9999999999990')         ||cLimitador||
                       cCampoFormatC||W.Proceso                                        ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.FechaTransaccion,'RRRR/MM')            ||cLimitador||
                       cCampoFormatC||W.Moneda                                         ||cLimitador||
                       cCampoFormatC||cIndDistFacult                                   ||cLimitador||
                       cCampoFormatN||TO_CHAR(nPrimasDirectas,'99999999999990.00')     ||cLimitador||
                       cCampoFormatN||TO_CHAR(nFactorReaseg,'99999999999990.00')       ||cLimitador||
                       cCampoFormatN||TO_CHAR(nPrimasCedidas,'99999999999990.00')      ||cLimitador||
                       cCampoFormatN||TO_CHAR(nTotalPrimasReaseg,'99999999999990.00')  ||cLimitador||
                       cCampoFormatN||TO_CHAR(nFactorCesion,'99999999999990.00')       ||cLimitador;
               cCadena := cCadena || '</tr>';
         END IF;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      END LOOP;
      IF cFormato = 'EXCEL' THEN
         OC_ARCHIVO.Escribir_Linea('</table></div></html>', cCodUser, 9999);
      END IF;
      OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
   EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      RAISE_APPLICATION_ERROR(-20225,'Error en Generación de Reporte Detalle Por Reasegurador de la Poliza' ||SQLERRM);
   END reasegurador_poliza;

   PROCEDURE transaccion_siniestro( cIdSiniestro       VARCHAR2
                                  , nIdTransaccionIni  NUMBER
                                  , nIdTransaccionFin  NUMBER
                                  , dFecDesde          DATE
                                  , dFecHasta          DATE
                                  , cIdPoliza          VARCHAR2
                                  , nCodCia            NUMBER
                                  , cFormato           VARCHAR2
                                  , cCodUser           VARCHAR2 ) IS
      cLimitadorTxt    VARCHAR2(1)    :='|';
      cLimitador       VARCHAR2(20)   :='</td>';
      cCampoFormatC    VARCHAR2(4000) := '<td class=texto>';
      cCampoFormatN    VARCHAR2(4000) := '<td class=numero>';
      cCampoFormatD    VARCHAR2(4000) := '<td class=fecha>';
      --
      cEncabezado      VARCHAR2(1) := 'S';
      nLinea           NUMBER := 1;
      cCadena          VARCHAR2(4000);
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
         SELECT DISTINCT RD.IdDistribRea
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
      IF cIdSiniestro = '%' THEN
         cDescTitulo := 'TODOS';
      ELSE
         cDescTitulo := cIdSiniestro;
      END IF;
      -- 
      IF cFormato = 'TEXTO' THEN 
         nLinea  := 1;
         cCadena := NOMBRE_COMPANIA(nCodCia) || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'REPORTE DISTRIBUCIÓN DE REASEGURO DE LA TRANSACCION'||TO_CHAR(nIdTransaccionIni)||' A '||TO_CHAR(nIdTransaccionFin)||CHR(13)||
                    'DEL SINIESTRO '||cDescTitulo;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         -- 
         nLinea  := nLinea + 1;
         cCadena := ' ' || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         -- 
         nLinea  := nLinea + 1;
         cCadena := 'No. de Póliza Único'  ||cLimitadorTxt||'Consecutivo'           ||cLimitadorTxt||'No. Detalle de Póliza'  ||cLimitadorTxt||
                    'No. Siniestro'        ||cLimitadorTxt||'No. Transacción'       ||cLimitadorTxt||'No. Distribución'       ||cLimitadorTxt||
                    'Orden'                ||cLimitadorTxt||'% Distribución'        ||cLimitadorTxt||'Monto Cedido'           ||cLimitadorTxt||
                    'Esquema de Reaseguro' ||cLimitadorTxt||'Contrato de Reaseguro' ||cLimitadorTxt||'No. Capa Contrato'      ||cLimitadorTxt||
                    'Fecha Distribución'   ||cLimitadorTxt||'Cobertura Afectada'    ||cLimitadorTxt||'Fecha Ocurrencia'       ||cLimitadorTxt||
                    'Monto de Gastos'      ||cLimitadorTxt||'Monto Daño Cobertura'  ||cLimitadorTxt||'Total Reservado'        ||cLimitadorTxt||
                    'Status Siniestro'     ||cLimitadorTxt|| CHR(13); 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      ELSE  
         cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'                                                                        ||chr(10)||
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
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         -- 
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>REPORTE DISTRIBUCIÓN DE REASEGURO DE LA TRANSACCION'||TO_CHAR(nIdTransaccionIni)||' A '||TO_CHAR(nIdTransaccionFin)||'</th></tr>'||CHR(10)||
                    '<tr><th>DEL SINIESTRO '||cDescTitulo||'</th></tr>'; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         -- 
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>  </th></tr></table>'; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         -- 
         nLinea  := nLinea + 1;
         cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza Único</font></th>' ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Consecutivo</font></th>'                               ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Detalle de Póliza</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Siniestro</font></th>'                             ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Transacción</font></th>'                           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Distribución</font></th>'                          || 
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Orden</font></th>'                                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Distribución</font></th>'                            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Cedido</font></th>'                              ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Esquema de Reaseguro</font></th>'                      ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Contrato de Reaseguro</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Capa Contrato</font></th>'                         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Distribución</font></th>'                        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cobertura Afectada</font></th>'                        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Ocurrencia</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto de Gastos</font></th>'                           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Daño Cobertura</font></th>'                      ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total Reservado</font></th>'                           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Status Siniestro</font></th>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      END IF;
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
               SELECT CodCobert, SUM(Monto_Reservado_Moneda) MontoReserva
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
         IF cFormato = 'TEXTO' THEN
            cCadena := cNumPolUnico                                    ||cLimitadorTxt||
                       TO_CHAR(W.IdPoliza,'9999999999999')             ||cLimitadorTxt||
                       TO_CHAR(W.IDetPol,'9999999999999')              ||cLimitadorTxt||
                       TO_CHAR(W.IdSiniestro,'9999999999999')          ||cLimitadorTxt||
                       TO_CHAR(W.IdTransaccion,'9999999999999')        ||cLimitadorTxt||
                       TO_CHAR(W.IdDistribRea,'9999999999999')         ||cLimitadorTxt||
                       TO_CHAR(W.NumDistrib,'9999999999999')           ||cLimitadorTxt||
                       TO_CHAR(W.PorcDistrib,'9999999990.000000')      ||cLimitadorTxt||
                       --TO_CHAR(W.MontoReserva,'99999999999990.000000') ||cLimitadorTxt|| Se cambia temporalmente por el cálculo del MontoCedido
                       TO_CHAR(nMtoCedido,'99999999999990.000000')     ||cLimitadorTxt||
                       W.Esquema                                       ||cLimitadorTxt||
                       cDescContrato                                   ||cLimitadorTxt||
                       TO_CHAR(W.IdCapaContrato,'9999999999999')       ||cLimitadorTxt||
                       TO_CHAR(W.FecMovDistrib,'DD/MM/YYYY')           ||cLimitadorTxt||
                       cCodCobert                                      ||cLimitadorTxt||
                       TO_CHAR(dFec_Ocurrencia,'DD/MM/YYYY')           ||cLimitadorTxt||
                       TO_CHAR(nTotalGastos,'99999999999990.00')       ||cLimitadorTxt||
                       TO_CHAR(nMontoReserva,'99999999999990.00')      ||cLimitadorTxt||
                       TO_CHAR(nTotalReservado,'99999999999990.00')    ||cLimitadorTxt||
                       cSts_Siniestro                                  ||CHR(13); 
         ELSE
            cCadena := '<tr>'                                                         || 
                       cCampoFormatC||cNumPolUnico                                    ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdPoliza,'9999999999990')             ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IDetPol,'9999999999990')              ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdSiniestro,'9999999999990')          ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdTransaccion,'9999999999990')        ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdDistribRea,'9999999999990')         ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.NumDistrib,'9999999999990')           ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.PorcDistrib,'9999999990.000000')      ||cLimitador||
                       --cCampoFormatN||TO_CHAR(W.MontoReserva,'99999999999990.000000') ||cLimitador|| Se cambia temporalmente por el cálculo del MontoCedido
                       cCampoFormatN||TO_CHAR(nMtoCedido,'99999999999990.000000')     ||cLimitador||
                       cCampoFormatC||W.Esquema                                       ||cLimitador||
                       cCampoFormatC||cDescContrato                                   ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdCapaContrato,'9999999999990')       ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.FecMovDistrib,'DD/MM/YYYY')           ||cLimitador||
                       cCampoFormatC||cCodCobert                                      ||cLimitador||
                       cCampoFormatD||TO_CHAR(dFec_Ocurrencia,'DD/MM/YYYY')           ||cLimitador||
                       cCampoFormatN||TO_CHAR(nTotalGastos,'99999999999990.00')       ||cLimitador||
                       cCampoFormatN||TO_CHAR(nMontoReserva,'99999999999990.00')      ||cLimitador||
                       cCampoFormatN||TO_CHAR(nTotalReservado,'99999999999990.00')    ||cLimitador||
                       cCampoFormatC||cSts_Siniestro                                  ||'</tr>';
         END IF;
         nLinea := nLinea + 1;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      END LOOP;
      --
      IF cFormato = 'EXCEL' THEN
         OC_ARCHIVO.Escribir_Linea('</table></div></html>', cCodUser, 9999);
      END IF;
      OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
   EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      RAISE_APPLICATION_ERROR(-20225,'Error en Generación de Reporte Reaseguro Por Transacción del Siniestro: ' ||SQLERRM);
   END transaccion_siniestro;

   PROCEDURE reasegurador_siniestro( cIdSiniestro       VARCHAR2
                                   , nIdTransaccionIni  NUMBER
                                   , nIdTransaccionFin  NUMBER
                                   , dFecDesde          DATE
                                   , dFecHasta          DATE
                                   , cIdPoliza          VARCHAR2
                                   , nCodCia            NUMBER
                                   , cFormato           VARCHAR2
                                   , cCodUser           VARCHAR2 ) IS
      cLimitadorTxt       VARCHAR2(1)    :='|';
      cLimitador          VARCHAR2(20)   :='</td>';
      cCampoFormatC       VARCHAR2(4000) := '<td class=texto>';
      cCampoFormatN       VARCHAR2(4000) := '<td class=numero>';
      cCampoFormatD       VARCHAR2(4000) := '<td class=fecha>';
      cEncabezado         VARCHAR2(1) := 'S';
      nLinea              NUMBER := 1;
      cCadena             VARCHAR2(4000);
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
         SELECT DISTINCT RD.IdDistribRea
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
      IF cIdSiniestro = '%' THEN
          cDescTitulo := 'TODOS';
      ELSE
          cDescTitulo := cIdSiniestro;
      END IF;
        
      IF cFormato = 'TEXTO' THEN  
         nLinea  := 1;
         cCadena := NOMBRE_COMPANIA(nCodCia) || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'REPORTE DISTRIBUCIÓN DE REASEGURO DETALLE POR REASEGURADOR'||CHR(13)||
                    'DEL SINIESTRO '||cDescTitulo;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := ' ' || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'No. de Póliza Único'           ||cLimitadorTxt||'No. de Póliza Consecutivo'      ||cLimitadorTxt||'Inicio Vigencia Póliza'         ||cLimitadorTxt||
                    'Fin Vigencia Póliza'           ||cLimitadorTxt||'No. Detalle de Póliza'          ||cLimitadorTxt||'Contratante'                    ||cLimitadorTxt||
                    'Código Cliente'                ||cLimitadorTxt||'No. Siniestro'                  ||cLimitadorTxt||'No. Transacción'                ||cLimitadorTxt||
                    'No. Distribución'              ||cLimitadorTxt||'Orden'                          ||cLimitadorTxt||'Esquema de Reaseguro'           ||cLimitadorTxt||
                    'Contrato de Reaseguro'         ||cLimitadorTxt||'No. Capa Contrato'              ||cLimitadorTxt||'Código Reasegurador'            ||cLimitadorTxt||
                    'Nombre Reasegurador'           ||cLimitadorTxt||'Código Intermediario Reaseguro' ||cLimitadorTxt||'Nombre Intermediario Reaseguro' ||cLimitadorTxt||
                    '% Distribución'                ||cLimitadorTxt||'Total Cedido'                   ||cLimitadorTxt||'No. Liquidación'                ||cLimitadorTxt||
                    'Cobertura Afectada'            ||cLimitadorTxt||'Desc. Cobertura Afectada'       ||cLimitadorTxt||'Fecha Notificación'             ||cLimitadorTxt||
                    'Fecha Registro'                ||cLimitadorTxt||'Fecha Ocurrencia'               ||cLimitadorTxt||'Tipo de Siniestro'              ||cLimitadorTxt||
                    'Descripción Tipo de Siniestro' ||cLimitadorTxt||'Código Causa Siniestro'         ||cLimitadorTxt||'Descripción Causa Siniestro'    ||cLimitadorTxt||
                    'No. Endoso Afectado'           ||cLimitadorTxt||'Monto de Gastos'                ||cLimitadorTxt||'Monto Daño Cobertura'           ||cLimitadorTxt||
                    'Total Reservado'               ||cLimitadorTxt||'Status Siniestro'               ||cLimitadorTxt||'Año-Mes de Movimiento'          ||cLimitadorTxt||
                    'Monto de Reserva'              ||cLimitadorTxt||'Fecha Reserva'                  ||cLimitadorTxt||'Monto Pagado'                   ||cLimitadorTxt||
                    'Fecha Pago'                    ||cLimitadorTxt||'Código Asegurado'               ||cLimitadorTxt||'Nombre Asegurado'               ||cLimitadorTxt||
                    'Fecha de Nacimiento'           ||cLimitadorTxt||'Certificado'                    ||cLimitadorTxt||'Esquema de Reaseguro'           ||cLimitadorTxt||
                    'Contrato de Reaseguro'         ||cLimitadorTxt||'No. Capa Contrato'              ||cLimitadorTxt||'Riesgo de Reaseguro'            ||cLimitadorTxt||
                    'Fecha Distribución'            ||cLimitadorTxt||'Moneda'                         ||cLimitadorTxt||'Código de la Transacción'       ||cLimitadorTxt||
                    'Nombre de la Transacción'      ||cLimitadorTxt||CHR(13); 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      ELSE  
         cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'                                                                        ||chr(10)||
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
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>REPORTE DISTRIBUCIÓN DE REASEGURO DETALLE POR REASEGURADOR</th></tr>'||CHR(10)||
                    '<tr><th>DEL SINIESTRO '||cDescTitulo||'</th></tr>'; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>  </th></tr></table>'; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza Único</font></th>' ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza Consecutivo</font></th>'                 ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Inicio Vigencia Póliza</font></th>'                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fin Vigencia Póliza</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Detalle de Póliza</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Contratante</font></th>'                               ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Cliente</font></th>'                            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Siniestro</font></th>'                             ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Transacción</font></th>'                           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Distribución</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Orden</font></th>'                                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Esquema de Reaseguro</font></th>'                      ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Contrato de Reaseguro</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Capa Contrato</font></th>'                         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Reasegurador</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Reasegurador</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Intermediario Reaseguro</font></th>'            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Intermediario Reaseguro</font></th>'            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Distribución</font></th>'                            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total Cedido</font></th>'                              ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Liquidación</font></th>'                           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cobertura Afectada</font></th>'                        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Desc. Cobertura Afectada</font></th>'                  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Notificación</font></th>'                        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Registro</font></th>'                            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Ocurrencia</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de Siniestro</font></th>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         cCadena := '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción Tipo de Siniestro</font></th>'             ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Causa Siniestro</font></th>'                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción Causa Siniestro</font></th>'               ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción del Siniestro</font></th>'                 ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Endoso Afectado</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto de Gastos</font></th>'                           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Daño Cobertura</font></th>'                      ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total Reservado</font></th>'                           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Status Siniestro</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Año-Mes de Movimiento</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto de Reserva</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Reserva</font></th>'                             ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Pagado</font></th>'                              ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Pago</font></th>'                                ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Asegurado</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Asegurado</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Nacimiento</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Certificado</font></th>'                               ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Riesgo de Reaseguro</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Distribución</font></th>'                        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Moneda</font></th>'                                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código de la Transacción</font></th>'                  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre de la Transacción</font></th>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      END IF;

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
         nLinea := nLinea + 1;
         IF cFormato = 'TEXTO' THEN
            cCadena := cNumPolUnico                                      ||cLimitadorTxt||
                       TO_CHAR(W.IdPoliza,'9999999999999')               ||cLimitadorTxt||
                       TO_CHAR(dFecIniVig,'DD/MM/YYYY')                  ||cLimitadorTxt||
                       TO_CHAR(dFecFinVig,'DD/MM/YYYY')                  ||cLimitadorTxt||
                       TO_CHAR(W.IDetPol,'9999999999999')                ||cLimitadorTxt||
                       cNomCliente                                       ||cLimitadorTxt||
                       TO_CHAR(nCodCliente,'9999999999999')              ||cLimitadorTxt||
                       TO_CHAR(W.IdSiniestro,'9999999999999')            ||cLimitadorTxt||
                       TO_CHAR(W.IdTransaccion,'9999999999999')          ||cLimitadorTxt||
                       TO_CHAR(W.IdDistribRea,'9999999999999')           ||cLimitadorTxt||
                       TO_CHAR(W.NumDistrib,'9999999999999')             ||cLimitadorTxt||
                       W.Esquema                                         ||cLimitadorTxt||
                       cDescContrato                                     ||cLimitadorTxt||
                       TO_CHAR(W.IdCapaContrato,'9999999999999')         ||cLimitadorTxt||
                       TO_CHAR(W.CodEmpresaGremio,'9999999999999')       ||cLimitadorTxt||
                       W.NombreReasegurador                              ||cLimitadorTxt||
                       TO_CHAR(W.CodInterReaseg,'9999999999999')         ||cLimitadorTxt||
                       W.NomInterReaseg                                  ||cLimitadorTxt||
                       TO_CHAR(W.PorcDistrib,'9999999990.000000')        ||cLimitadorTxt||
                       --TO_CHAR(W.MontoReserva,'99999999999990.000000') ||cLimitadorTxt|| Se cambia temporalmente por el cálculo del MontoCedido
                       TO_CHAR(W.MtoSiniDistrib,'99999999999990.000000') ||cLimitadorTxt||
                       TO_CHAR(W.IdLiquidacion,'9999999999999')          ||cLimitadorTxt||
                       cCodCobert                                        ||cLimitadorTxt||
                       cNomCobert                                        ||cLimitadorTxt||
                       TO_CHAR(dFecNotificacion,'DD/MM/YYYY')            ||cLimitadorTxt||
                       TO_CHAR(dFecRegistro,'DD/MM/YYYY')                ||cLimitadorTxt||
                       TO_CHAR(dFec_Ocurrencia,'DD/MM/YYYY')             ||cLimitadorTxt||
                       cTipoSiniestro                                    ||cLimitadorTxt;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

         cCadena :=    cDescTipoSini                                     ||cLimitadorTxt||
                       cCausaSiniestro                                   ||cLimitadorTxt||
                       cDescCausaSini                                    ||cLimitadorTxt||
                       cDesc_Siniestro                                   ||cLimitadorTxt||
                       TO_CHAR(W.IdEndoso,'99999999999999')              ||cLimitadorTxt||
                       TO_CHAR(nTotalGastos,'99999999999990.00')         ||cLimitadorTxt||
                       TO_CHAR(nMontoReserva,'99999999999990.00')        ||cLimitadorTxt||
                       TO_CHAR(nTotalReservado,'99999999999990.00')      ||cLimitadorTxt||
                       cSts_Siniestro                                    ||cLimitadorTxt||
                       TO_CHAR(W.FechaTransaccion,'YYYY-MM')             ||cLimitadorTxt||
                       TO_CHAR(nMontoReserva,'99999999999990.00')        ||cLimitadorTxt||
                       TO_CHAR(dFecRes,'DD/MM/YYYY')                     ||cLimitadorTxt||
                       TO_CHAR(nMontoPagado,'99999999999990.00')         ||cLimitadorTxt||
                       TO_CHAR(dFecPago,'DD/MM/YYYY')                    ||cLimitadorTxt||
                       TO_CHAR(nCod_Asegurado,'99999999999990')          ||cLimitadorTxt||
                       cNomAsegurado                                     ||cLimitadorTxt||
                       TO_CHAR(dFecNacAseg,'DD/MM/YYYY')                 ||cLimitadorTxt||
                       TO_CHAR(W.IDetPol,'9999999999999')                ||cLimitadorTxt||
                       W.CodRiesgoReaseg                                 ||cLimitadorTxt||
                       TO_CHAR(W.FecMovDistrib,'DD/MM/YYYY')             ||cLimitadorTxt||
                       W.Moneda                                          ||cLimitadorTxt||
                       cCodTransac                                       ||cLimitadorTxt||
                       cDescCodTransac                                   ||CHR(13);
         ELSE
            cCadena := '<tr>'                                                           ||cLimitador|| 
                       cCampoFormatC||cNumPolUnico                                      ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdPoliza,'9999999999990')               ||cLimitador||
                       cCampoFormatC||TO_CHAR(dFecIniVig,'DD/MM/YYYY')                  ||cLimitador||
                       cCampoFormatC||TO_CHAR(dFecFinVig,'DD/MM/YYYY')                  ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IDetPol,'9999999999990')                ||cLimitador||
                       cCampoFormatC||cNomCliente                                       ||cLimitador||
                       cCampoFormatC||TO_CHAR(nCodCliente,'99999999999990')             ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdSiniestro,'9999999999990')            ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdTransaccion,'9999999999990')          ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdDistribRea,'9999999999990')           ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.NumDistrib,'9999999999990')             ||cLimitador||
                       cCampoFormatC||W.Esquema                                         ||cLimitador||
                       cCampoFormatC||cDescContrato                                     ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdCapaContrato,'9999999999990')         ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.CodEmpresaGremio,'9999999999990')       ||cLimitador||
                       cCampoFormatC||W.NombreReasegurador                              ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.CodInterReaseg,'9999999999990')         ||cLimitador||
                       cCampoFormatC||W.NomInterReaseg                                  ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.PorcDistrib,'9999999990.000000')        ||cLimitador||
                       --cCampoFormatN||TO_CHAR(W.MontoReserva,'99999999999990.000000') ||cLimitador|| Se cambia temporalmente por el cálculo del MontoCedido
                       cCampoFormatN||TO_CHAR(W.MtoSiniDistrib,'99999999999990.000000') ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdLiquidacion,'9999999999990')          ||cLimitador||
                       cCampoFormatC||cCodCobert                                        ||cLimitador||
                       cCampoFormatC||cNomCobert                                        ||cLimitador||
                       cCampoFormatC||TO_CHAR(dFecNotificacion,'DD/MM/YYYY')            ||cLimitador||
                       cCampoFormatC||TO_CHAR(dFecRegistro,'DD/MM/YYYY')                ||cLimitador||
                       cCampoFormatC||TO_CHAR(dFec_Ocurrencia,'DD/MM/YYYY')             ||cLimitador||
                       cCampoFormatC||cTipoSiniestro                                    ||cLimitador;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);

         cCadena :=    cCampoFormatC||cDescTipoSini                                     ||cLimitador||
                       cCampoFormatC||cCausaSiniestro                                   ||cLimitador||
                       cCampoFormatC||cDescCausaSini                                    ||cLimitador||
                       cCampoFormatC||cDesc_Siniestro                                   ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdEndoso,'999999999999990')             ||cLimitador||
                       cCampoFormatN||TO_CHAR(nTotalGastos,'99999999999990.00')         ||cLimitador||
                       cCampoFormatN||TO_CHAR(nMontoReserva,'99999999999990.00')        ||cLimitador||
                       cCampoFormatN||TO_CHAR(nTotalReservado,'99999999999990.00')      ||cLimitador||
                       cCampoFormatC||cSts_Siniestro                                    ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.FechaTransaccion,'YYYY-MM')             ||cLimitador||
                       cCampoFormatN||TO_CHAR(nMontoReserva,'99999999999990.00')        ||cLimitador||
                       cCampoFormatC||TO_CHAR(dFecRes,'DD/MM/YYYY')                     ||cLimitador||
                       cCampoFormatN||TO_CHAR(nMontoPagado,'99999999999990.00')         ||cLimitador||
                       cCampoFormatC||TO_CHAR(dFecPago,'DD/MM/YYYY')                    ||cLimitador||
                       cCampoFormatC||TO_CHAR(nCod_Asegurado,'99999999999990')          ||cLimitador||
                       cCampoFormatC||cNomAsegurado                                     ||cLimitador||
                       cCampoFormatC||TO_CHAR(dFecNacAseg,'DD/MM/YYYY')                 ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IDetPol,'9999999999999')                ||cLimitador||
                       cCampoFormatC||W.CodRiesgoReaseg                                 ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.FecMovDistrib,'DD/MM/YYYY')             ||cLimitador||
                       cCampoFormatC||W.Moneda                                          ||cLimitador||
                       cCampoFormatC||cCodTransac                                       ||cLimitador||
                       cCampoFormatC||cDescCodTransac                                   ||'</tr>';
         END IF;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      END LOOP;
      IF cFormato = 'EXCEL' THEN
         OC_ARCHIVO.Escribir_Linea('</table></div></html>', cCodUser, 9999);
      END IF;
      OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
   EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      RAISE_APPLICATION_ERROR(-20225,'Error en Generación de Reporte Detalle Por Reasegurador del Siniestro: '|| nIdSiniestro || '-' ||SQLERRM);
   END reasegurador_siniestro;

   PROCEDURE transaccion_esquema( cIdPoliza          VARCHAR2
                                , cCodEsquema        VARCHAR2
                                , nIdTransaccionIni  NUMBER
                                , nIdTransaccionFin  NUMBER
                                , dFecDesde          DATE
                                , dFecHasta          DATE
                                , cDescPoliza        VARCHAR2
                                , cDescEsquema       VARCHAR2 
                                , nCodCia            NUMBER
                                , cFormato           VARCHAR2
                                , cCodUser           VARCHAR2 ) IS
      cLimitadorTxt     VARCHAR2(1)    :='|';
      cLimitador        VARCHAR2(20)   :='</td>';
      cCampoFormatC     VARCHAR2(4000) := '<td class=texto>';
      cCampoFormatN     VARCHAR2(4000) := '<td class=numero>';
      cCampoFormatD     VARCHAR2(4000) := '<td class=fecha>';
      --
      cEncabezado       VARCHAR2(1) := 'S';
      nLinea            NUMBER := 1;
      cCadena           VARCHAR2(4000);
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
         SELECT RD.IdDistribRea
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
      IF cFormato = 'TEXTO' THEN
         nLinea  := 1;
         cCadena := NOMBRE_COMPANIA(nCodCia) || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'REPORTE DISTRIBUCIÓN DE REASEGURO POR ESQUEMA DE LA TRANSACCION'||TO_CHAR(nIdTransaccionIni)||' A '||TO_CHAR(nIdTransaccionFin)||CHR(13)||
                    'DE LA PÓLIZA '||TO_CHAR(cIdPoliza)||' ESQUEMA: '||cDescEsquema;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := ' ' || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'No. de Póliza Único'              ||cLimitadorTxt||'Consecutivo'             ||cLimitadorTxt||'No. Detalle de Póliza'||cLimitadorTxt||
                    'No. Endoso'                       ||cLimitadorTxt||'No. Distribución'        ||cLimitadorTxt||'Orden'                ||cLimitadorTxt||
                    'Grupo Cobertura'                  ||cLimitadorTxt||'Capacidad Máxima'        ||cLimitadorTxt||'% Distribución'       ||cLimitadorTxt||
                    'Suma Aseg. Distribuida'           ||cLimitadorTxt||'Prima Distribuida'       ||cLimitadorTxt||'Monto de Reserva'     ||cLimitadorTxt||
                    'Código Asegurado'                 ||cLimitadorTxt||'Nombre Asegurado'        ||cLimitadorTxt||'Esquema de Reaseguro' ||cLimitadorTxt|| 
                    'Contrato de Reaseguro'            ||cLimitadorTxt||'No. Capa Contrato'       ||cLimitadorTxt||'Riesgo de Reaseguro'  ||cLimitadorTxt||
                    'Inicio Vigencia Transacción'      ||cLimitadorTxt||'Fin Vigencia Transacción'||cLimitadorTxt||'Fecha Distribución'   ||cLimitadorTxt|| 
                    'Necesita Distribución Facultativa'||cLimitadorTxt||'Primas Directas'         ||cLimitadorTxt||'Factor Reaseguro'     ||cLimitadorTxt||
                    'Primas Cedidas'                   ||cLimitadorTxt||'Total Primas Reaseguro'  ||cLimitadorTxt||'Factor Cesion'        ||CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      ELSE  
         cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'                                                                        ||chr(10)||
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
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>REPORTE DISTRIBUCIÓN DE REASEGURO POR ESQUEMA DE LA TRANSACCION '||TO_CHAR(nIdTransaccionIni)||
                    ' A '||TO_CHAR(nIdTransaccionFin)||'</th></tr>'||CHR(10)||
                    '<tr><th>DE LA PÓLIZA '||TO_CHAR(cDescPoliza)||'</th></tr>'||CHR(10)|| 
                    '<tr><th>ESQUEMA  '||TO_CHAR(cDescEsquema)||'</th></tr>'; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>  </th></tr></table>'; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza Único</font></th>' ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Consecutivo</font></th>'                               ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Detalle de Póliza</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Endoso</font></th>'                                ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Distribución</font></th>'                          || 
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Orden</font></th>'                                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Grupo Cobertura</font></th>'                           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Capacidad Máxima</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Distribución</font></th>'                            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Suma Aseg. Distribuida</font></th>'                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Prima Distribuida</font></th>'                         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto de Reserva</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Asegurado</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre asegurado</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Esquema de Reaseguro</font></th>'                      ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Contrato de Reaseguro</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Capa Contrato</font></th>'                         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Riesgo de Reaseguro</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Inicio Vigencia Transaccion</font></th>'               ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fin Vigencia Transaccion</font></th>'                  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Distribución</font></th>'                        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Necesita Distribucion Facultativa</font></th>'         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Primas Directas</font></th>'                           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Factor de Reaseguro</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Primas Cedidas</font></th>'                            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total Primas Reaseguro</font></th>'                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Factor Cesión</font></th>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      END IF;
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
         IF cFormato = 'TEXTO' THEN
            cCadena := cNumPolUnico                                     ||cLimitadorTxt||
                       TO_CHAR(W.IdPoliza,'9999999999999')              ||cLimitadorTxt||
                       TO_CHAR(W.IDetPol,'9999999999999')               ||cLimitadorTxt||
                       TO_CHAR(W.IdEndoso,'9999999999999')              ||cLimitadorTxt||
                       TO_CHAR(W.IdDistribRea,'9999999999999')          ||cLimitadorTxt||
                       TO_CHAR(W.NumDistrib,'9999999999999')            ||cLimitadorTxt||
                       W.CodGrupoCobert                                 ||cLimitadorTxt||
                       TO_CHAR(W.CapacidadMaxima,'99999999999990.00')   ||cLimitadorTxt||
                       TO_CHAR(W.PorcDistrib,'9999999990.000000')       ||cLimitadorTxt||
                       TO_CHAR(W.SumaAsegDistrib,'99999999999990.00')   ||cLimitadorTxt||
                       TO_CHAR(W.PrimaDistrib,'99999999999990.000000')  ||cLimitadorTxt||
                       TO_CHAR(W.MontoReserva,'99999999999990.000000')  ||cLimitadorTxt||
                       TO_CHAR(W.Cod_Asegurado,'9999999999999')         ||cLimitadorTxt||
                       W.NomAsegurado                                   ||cLimitadorTxt||
                       W.Esquema                                        ||cLimitadorTxt||
                       cDescContrato                                    ||cLimitadorTxt||
                       TO_CHAR(W.IdCapaContrato,'9999999999999')        ||cLimitadorTxt||
                       W.CodRiesgoReaseg                                ||cLimitadorTxt||
                       TO_CHAR(W.FecVigInicial,'DD/MM/YYYY')            ||cLimitadorTxt||
                       TO_CHAR(W.FecVigFinal,'DD/MM/YYYY')              ||cLimitadorTxt||
                       TO_CHAR(W.FecMovDistrib,'DD/MM/YYYY')            ||cLimitadorTxt||
                       cIndDistFacult                                   ||cLimitadorTxt||
                       TO_CHAR(W.PrimasDirectas,'99999999999990.00')    ||cLimitadorTxt||
                       TO_CHAR(W.FactorReaseg,'90.9999999999')          ||cLimitadorTxt||
                       TO_CHAR(W.PrimasCedidas,'99999999999990.00')     ||cLimitadorTxt||
                       TO_CHAR(W.TotalPrimasReaseg,'99999999999990.00') ||cLimitadorTxt||
                       TO_CHAR(W.FactorCesion,'90.9999999999')          ||CHR(13);
         ELSE
            cCadena    := '<tr>'                                                          || 
                          cCampoFormatC||cNumPolUnico                                     ||cLimitador||
                          cCampoFormatC||TO_CHAR(W.IdPoliza,'9999999999999')              ||cLimitador||
                          cCampoFormatC||TO_CHAR(W.IDetPol,'9999999999999')               ||cLimitador||
                          cCampoFormatC||TO_CHAR(W.IdEndoso,'9999999999999')              ||cLimitador||
                          cCampoFormatC||TO_CHAR(W.IdDistribRea,'9999999999999')          ||cLimitador||
                          cCampoFormatC||TO_CHAR(W.NumDistrib,'9999999999999')            ||cLimitador||
                          cCampoFormatC||W.CodGrupoCobert                                 ||cLimitador||
                          cCampoFormatN||TO_CHAR(W.CapacidadMaxima,'99999999999990.00')   ||cLimitador||
                          cCampoFormatN||TO_CHAR(W.PorcDistrib,'9999999990.000000')       ||cLimitador||
                          cCampoFormatN||TO_CHAR(W.SumaAsegDistrib,'99999999999990.00')   ||cLimitador||
                          cCampoFormatN||TO_CHAR(W.PrimaDistrib,'99999999999990.000000')  ||cLimitador||
                          cCampoFormatN||TO_CHAR(W.MontoReserva,'99999999999990.000000')  ||cLimitador||
                          cCampoFormatN||TO_CHAR(W.Cod_Asegurado,'9999999999999')         ||cLimitador||
                          cCampoFormatC||W.NomAsegurado                                   ||cLimitador||
                          cCampoFormatC||W.Esquema                                        ||cLimitador||
                          cCampoFormatC||cDescContrato                                    ||cLimitador||
                          cCampoFormatC||TO_CHAR(W.IdCapaContrato,'9999999999999')        ||cLimitador||
                          cCampoFormatC||W.CodRiesgoReaseg                                ||cLimitador||
                          cCampoFormatD||TO_CHAR(W.FecVigInicial,'DD/MM/YYYY')            ||cLimitador||
                          cCampoFormatD||TO_CHAR(W.FecVigFinal,'DD/MM/YYYY')              ||cLimitador||
                          cCampoFormatD||TO_CHAR(W.FecMovDistrib,'DD/MM/YYYY')            ||cLimitador||
                          cCampoFormatC||cIndDistFacult                                   ||cLimitador||
                          cCampoFormatC||TO_CHAR(W.PrimasDirectas,'99999999999990.00')    ||cLimitador||
                          cCampoFormatC||TO_CHAR(W.FactorReaseg,'90.9999999999')          ||cLimitador||
                          cCampoFormatC||TO_CHAR(W.PrimasCedidas,'99999999999990.00')     ||cLimitador||
                          cCampoFormatC||TO_CHAR(W.TotalPrimasReaseg,'99999999999990.00') ||cLimitador||
                          cCampoFormatC||TO_CHAR(W.FactorCesion,'90.9999999999')          ||'</tr>';
         END IF;
         --
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
      RAISE_APPLICATION_ERROR(-20225,'Error en Generación de Reporte Reaseguro Por Transacción de la Póliza: ' ||SQLERRM);
   END transaccion_esquema;

   PROCEDURE reasegurador_esquema( cIdPoliza          VARCHAR2
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
                                 , cCodUser           VARCHAR2 ) IS
      cLimitadorTxt     VARCHAR2(1)    :='|';
      cLimitador        VARCHAR2(20)   :='</td>';
      cCampoFormatC     VARCHAR2(4000) := '<td class=texto>';
      cCampoFormatN     VARCHAR2(4000) := '<td class=numero>';
      cCampoFormatD     VARCHAR2(4000) := '<td class=fecha>';
      --
      cEncabezado       VARCHAR2(1) := 'S';
      nLinea            NUMBER := 1;
      cCadena           VARCHAR2(4000);
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
         SELECT RD.IdDistribRea
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
      IF cFormato = 'TEXTO' THEN  
         nLinea := 1;
         cCadena     := NOMBRE_COMPANIA(nCodCia) || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'REPORTE DISTRIBUCIÓN DE REASEGURO DETALLE POR ESQUEMA, PÓLIZA: '||cDescPoliza||
                    ' DETALLE: '||cDescIDetPol||' ENDOSO: '||cDescIdEndoso;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := ' ' || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'No. de Póliza Único'           ||cLimitadorTxt||'Consecutivo'              ||cLimitadorTxt||'No. Detalle de Póliza'         ||cLimitadorTxt||
                    'No. Endoso'                    ||cLimitadorTxt||'No. Distribución'         ||cLimitadorTxt||'Orden'                         ||cLimitadorTxt||
                    'Grupo Cobertura'               ||cLimitadorTxt||'Código Asegurado'         ||cLimitadorTxt||'Nombre Asegurado'              ||cLimitadorTxt||
                    'Esquema de Reaseguro'          ||cLimitadorTxt||'Contrato de Reaseguro'    ||cLimitadorTxt||'No. Capa Contrato'             ||cLimitadorTxt||
                    'Código Reasegurador'           ||cLimitadorTxt||'Nombre Reasegurador'      ||cLimitadorTxt||'Código Intermediario Reaseguro'||cLimitadorTxt||
                    'Nombre Intermediario Reaseguro'||cLimitadorTxt||'% Distribución'           ||cLimitadorTxt||'Suma Asegurada Distribuida'    ||cLimitadorTxt||
                    'Prima Distribuida'             ||cLimitadorTxt||'Comisión Reaseguro'       ||cLimitadorTxt||'Total Reserva'                 ||cLimitadorTxt||
                    'No. Liquidación'               ||cLimitadorTxt||'Fecha Liberación Reservas'||cLimitadorTxt||'Impuestos Reserva Liberada'    ||cLimitadorTxt||
                    'Intereses Reserva Liberada'    ||cLimitadorTxt||'Primas Directas'          ||cLimitadorTxt||'Factor de Reaseguro'           ||cLimitadorTxt||
                    'Primas Cedidas'                ||cLimitadorTxt||'Total de Primas Reaseguro'||cLimitadorTxt||'Factor Cesión';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      ELSE  
         cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'                                                                        ||chr(10)||
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
          OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
          nLinea  := nLinea + 1;
          cCadena := '<tr><th>REPORTE DISTRIBUCIÓN DE REASEGURO DETALLE POR ESQUEMA</th></tr>'||CHR(10)||
                     '<tr><th>PÓLIZA '||TO_CHAR(cDescPoliza)||'</th></tr>'||CHR(10)|| 
                     '<tr><th>DETALLE  '||TO_CHAR(cDescIDetPol)||'</th></tr>'||CHR(10)||
                     '<tr><th>ENDOSO   '||TO_CHAR(cDescIdEndoso)||'</th></tr>'; 
          OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
          nLinea  := nLinea + 1;
          cCadena := '<tr><th>  </th></tr></table>'; 
          OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
          nLinea  := nLinea + 1;
          cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza Único</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Consecutivo</font></th>'                               ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Detalle de Póliza</font></th>'                     ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Endoso</font></th>'                                ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Distribución</font></th>'                          || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Orden</font></th>'                                     ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Grupo Cobertura</font></th>'                           ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Asegurado</font></th>'                          ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Asegurado</font></th>'                          ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Esquema de Reaseguro</font></th>'                      ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Contrato de Reaseguro</font></th>'                     ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Capa Contrato</font></th>'                         ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Reasegurador</font></th>'                       ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Reasegurador</font></th>'                       ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Intermediario Reaseguro</font></th>'            ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Intermediario Reaseguro</font></th>'            ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Distribución</font></th>'                            ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Suma Asegurada Distribuida</font></th>'                ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Prima Distribuida</font></th>'                         ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Comisión Reaseguro</font></th>'                        ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total Reserva</font></th>'                             ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Liquidación</font></th>'                           ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Liberación Reservas</font></th>'                 ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Impuestos Reserva Liberada</font></th>'                ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Intereses Reserva Liberada</font></th>'                ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Primas Directas</font></th>'                           ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Factor Reaseguro</font></th>'                          ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Primas Cedidas</font></th>'                            ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Total Primas Reaseguro</font></th>'                    ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Factor Cesión</font></th>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      END IF;
           
      FOR W IN DISTREA_Q LOOP
         cNumPolUnico  := NVL(W.NumPolUnico, 'NO EXISTE');
         cCodContrato  := W.CodContrato;
         cDescContrato := NVL(W.DescContrato, 'NO EXISTE CONTRATO');
         --
         IF cFormato = 'TEXTO' THEN
            cCadena := cNumPolUnico                                    ||cLimitadorTxt||
                       TO_CHAR(W.IdPoliza,'9999999999999')             ||cLimitadorTxt||
                       TO_CHAR(W.IDetPol,'9999999999999')              ||cLimitadorTxt||
                       TO_CHAR(W.IdEndoso,'9999999999999')             ||cLimitadorTxt||
                       TO_CHAR(W.IdDistribRea,'9999999999999')         ||cLimitadorTxt||
                       TO_CHAR(W.NumDistrib,'9999999999999')           ||cLimitadorTxt||
                       W.CodGrupoCobert                                ||cLimitadorTxt||
                       TO_CHAR(W.Cod_Asegurado,'9999999999999')        ||cLimitadorTxt||
                       W.NomAsegurado                                  ||cLimitadorTxt||
                       W.Esquema                                       ||cLimitadorTxt||
                       cDescContrato                                   ||cLimitadorTxt||
                       TO_CHAR(W.IdCapaContrato,'9999999999999')       ||cLimitadorTxt||
                       TO_CHAR(W.CodEmpresaGremio,'9999999999999')     ||cLimitadorTxt||
                       W.NombreReasegurador                            ||cLimitadorTxt||
                       TO_CHAR(W.CodInterReaseg,'9999999999999')       ||cLimitadorTxt||
                       W.NomInterReaseg                                ||cLimitadorTxt||
                       TO_CHAR(W.PorcDistrib,'9999999990.000000')      ||cLimitadorTxt||
                       TO_CHAR(W.SumaAsegDistrib,'99999999999990.00')  ||cLimitadorTxt||
                       TO_CHAR(W.PrimaDistrib,'99999999999990.000000') ||cLimitadorTxt||
                       TO_CHAR(W.MontoComision,'99999999999990.000000')||cLimitadorTxt||
                       TO_CHAR(W.MontoReserva,'99999999999990.000000') ||cLimitadorTxt||
                       TO_CHAR(W.IdLiquidacion,'9999999999999')        ||cLimitadorTxt||
                       TO_CHAR(W.FecLiberacionRvas,'DD/MM/YYYY')       ||cLimitadorTxt||
                       TO_CHAR(W.ImpRvasLiberadas,'99999999999990.00') ||cLimitadorTxt||
                       TO_CHAR(W.IntRvasLiberadas,'99999999999990.00') ||cLimitadorTxt||
                       TO_CHAR(W.PrimasDirectas,'99999999999990.00')   ||cLimitadorTxt||
                       TO_CHAR(W.FactorReaseg,'90.9999999999')         ||cLimitadorTxt||
                       TO_CHAR(W.PrimasCedidas,'99999999999990.00')    ||cLimitadorTxt||
                       TO_CHAR(W.TotalPrimasReaseg,'99999999999990.00')||cLimitadorTxt||
                       TO_CHAR(W.FactorCesion,'90.9999999999');
 
            cCadena := cCadena || CHR(13);
         ELSE
            cCadena := '<tr>'                                                         || 
                       cCampoFormatC||cNumPolUnico                                    ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdPoliza,'9999999999990')             ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IDetPol,'9999999999990')              ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdEndoso,'9999999999990')             ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdDistribRea,'9999999999990')         ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.NumDistrib,'9999999999990')           ||cLimitador||
                       cCampoFormatC||W.CodGrupoCobert                                ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.Cod_Asegurado,'9999999999990')        ||cLimitador||
                       cCampoFormatC||W.NomAsegurado                                  ||cLimitador||
                       cCampoFormatC||W.Esquema                                       ||cLimitador||
                       cCampoFormatC||cDescContrato                                   ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdCapaContrato,'9999999999990')       ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.CodEmpresaGremio,'9999999999990')     ||cLimitador||
                       cCampoFormatC||W.NombreReasegurador                            ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.CodInterReaseg,'9999999999990')       ||cLimitador||
                       cCampoFormatC||W.NomInterReaseg                                ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.PorcDistrib,'9999999990.000000')      ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.SumaAsegDistrib,'99999999999990.00')  ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.PrimaDistrib,'99999999999990.000000') ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.MontoComision,'99999999999990.000000')||cLimitador||
                       cCampoFormatN||TO_CHAR(W.MontoReserva,'99999999999990.000000') ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdLiquidacion,'9999999999990')        ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.FecLiberacionRvas,'DD/MM/YYYY')       ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.ImpRvasLiberadas,'99999999999990.00') ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.IntRvasLiberadas,'99999999999990.00') ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.PrimasDirectas,'99999999999990.00')   ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.FactorReaseg,'90.999999999')          ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.PrimasCedidas,'99999999999990.00')    ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.TotalPrimasReaseg,'99999999999990.00')||cLimitador||
                       cCampoFormatN||TO_CHAR(W.FactorCesion,'90.999999999')          ||cLimitador;
            cCadena := cCadena || '</tr>';
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
      RAISE_APPLICATION_ERROR(-20225,'Error en Generación de Reporte Detalle Por Reasegurador' ||SQLERRM);
   END reasegurador_esquema;

   PROCEDURE siniestro_recuperado( cIdPoliza           VARCHAR2
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
                                 , cCodUser            VARCHAR2 ) IS

      cLimitadorTxt       VARCHAR2(1)    :='|';
      cLimitador          VARCHAR2(20)   :='</td>';
      cCampoFormatC       VARCHAR2(4000) := '<td class=texto>';
      cCampoFormatN       VARCHAR2(4000) := '<td class=numero>';
      cCampoFormatD       VARCHAR2(4000) := '<td class=fecha>';
      --
      cEncabezado         VARCHAR2(1) := 'S';
      nLinea              NUMBER := 1;
      cCadena             VARCHAR2(4000);
      --
      dFec_Resva          DATE;
      dFec_Pago           DATE;
      cDescStsSinies      VARCHAR2(50);
      nSiniestro          SINIESTRO.IdSiniestro%TYPE;
      --
      CURSOR DISTREA_Q IS
         SELECT DISTINCT S.CodCia
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
      IF cFormato = 'TEXTO' THEN  
         nLinea  := 1;
         cCadena := NOMBRE_COMPANIA(nCodCia) || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'REPORTE DISTRIBUCION SINIESTROS RECUPERADOS';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'INTERMEDIARIO DE REASEGURO / SUCRIPTOR FACULTADO: '||TO_CHAR(cDescIntermediario);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'TIPO DE CONTRATO: '||TO_CHAR(cDescEsquema);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'CONTRATO: '||TO_CHAR(cDescContrato);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'RAMO: '||TO_CHAR(cDescripRamo);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'PERIODO: '||TO_CHAR(dFecDesde,'DD/MM/YYYY')||' AL '||TO_CHAR(dFecHasta,'DD/MM/YYYY');
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := 'ESTADO DEL SINIESTRO: '||cDescStsSinies;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         --
         nLinea  := nLinea + 1;
         cCadena := ' ' || CHR(13);
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
         nLinea  := nLinea + 1;
         cCadena := 'No. de Siniestro'        ||cLimitadorTxt||'No. Siniestro - Nomenclatura' ||cLimitadorTxt||'No. Referencia / Siniestro' ||cLimitadorTxt||
                    'Contratante'             ||cLimitadorTxt||'No. de Póliza Único'          ||cLimitadorTxt||'No. de Póliza Consecutivo'  ||cLimitadorTxt||
                    'Inicio Vigencia Póliza'  ||cLimitadorTxt||'Fin Vigencia Póliza'          ||cLimitadorTxt||'Fecha Notificación'         ||cLimitadorTxt||
                    'Fecha Registro'          ||cLimitadorTxt||'Fecha Ocurrencia'             ||cLimitadorTxt||'Estatus Siniestro'          ||cLimitadorTxt||
                    'Codigo Causa Siniestro'  ||cLimitadorTxt||'Descripcion Causa Siniestro'  ||cLimitadorTxt||'No. Endoso Afectado'        ||cLimitadorTxt||
                    'No. Distribución'        ||cLimitadorTxt||'Orden'                        ||cLimitadorTxt||'Grupo Cobertura Afectada'   ||cLimitadorTxt||
                    'Capacidad Máxima'        ||cLimitadorTxt||'% Distribución'               ||cLimitadorTxt||'Suma Aseg. Distribuida'     ||cLimitadorTxt||
                    'Año-Mes de Movimiento'   ||cLimitadorTxt||'Monto de Reserva'             ||cLimitadorTxt||'Fecha Reserva'              ||cLimitadorTxt||
                    'Monto de Pagado'         ||cLimitadorTxt||'Fecha Pago'                   ||cLimitadorTxt||'Código Asegurado'           ||cLimitadorTxt||
                    'Nombre Asegurado'        ||cLimitadorTxt||'Fecha de Nacimiento'          ||cLimitadorTxt||'Certificado'                ||cLimitadorTxt||
                    'Esquema de Reaseguro'    ||cLimitadorTxt||'Contrato de Reaseguro'        ||cLimitadorTxt||'No. Capa Contrato'          ||cLimitadorTxt||
                    'Riesgo de Reaseguro'     ||cLimitadorTxt||'Fecha Distribución'           ||cLimitadorTxt||'Moneda'                     ||cLimitadorTxt|| CHR(13); 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      ELSE  
         cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'                                                                        ||chr(10)||
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
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>REPORTE DISTRIBUCION SINIESTROS RECUPERADOS</th></tr>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>INTERMEDIARIO DE REASEGURO / SUCRIPTOR FACULTADO: '||TO_CHAR(cDescIntermediario)||'</th></tr>'; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>TIPO DE CONTRATO: '||TO_CHAR(cDescEsquema)||'</th></tr>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>CONTRATO: '||TO_CHAR(cDescContrato)||'</th></tr>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>RAMO: '||TO_CHAR(cDescripRamo)||'</th></tr>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>PERIODO: '||TO_CHAR(dFecDesde,'DD/MM/YYYY')||' AL '||TO_CHAR(dFecHasta,'DD/MM/YYYY')||'</th></tr>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>ESTADO DEL SINIESTRO: '||cDescStsSinies||'</th></tr>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th>  </th></tr></table>'; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         --
         nLinea  := nLinea + 1;
         cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Siniestro</font></th>' ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Siniestro - Nomenclatura</font></th>'           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Referencia / Siniestro</font></th>'             ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Contratante</font></th>'                            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza Único</font></th>'                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza Consecutivo</font></th>'              ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Inicio Vigencia Póliza</font></th>'                 ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fin Vigencia Póliza</font></th>'                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Notificacion</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Registro</font></th>'                         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Ocurrencia</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Estatus Siniestro</font></th>'                      ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Codigo Causa Siniestro</font></th>'                 ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripcion Causa Siniestro</font></th>'            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Endoso Afectado</font></th>'                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Distribución</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Orden</font></th>'                                  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Grupo Cobertura Afectada</font></th>'               ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Capacidad Máxima</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Distribución</font></th>'                         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Suma Aseg. Distribuida</font></th>'                 ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Año-Mes de Movimiento</font></th>'                  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto de Reserva</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Reserva</font></th>'                          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto de Pagado</font></th>'                        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Pago</font></th>'                             ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Asegurado</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Asegurado</font></th>'                       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Nacimiento</font></th>'                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Certificado</font></th>'                            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Esquema de Reaseguro</font></th>'                   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Contrato de Reaseguro</font></th>'                  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Capa Contrato</font></th>'                      ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Riesgo de Reaseguro</font></th>'                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Distribución</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Moneda</font></th>';
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      END IF;
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
         IF cFormato = 'TEXTO' THEN
            cCadena := TO_CHAR(W.IdSiniestro,'9999999999999')     ||cLimitadorTxt||
                       W.Nomencl                                  ||cLimitadorTxt||
                       W.Referencia                               ||cLimitadorTxt||
                       W.Contratante                              ||cLimitadorTxt||
                       W.Num_Pol_Unic                             ||cLimitadorTxt||
                       TO_CHAR(W.IdPoliza,'9999999999999')        ||cLimitadorTxt||
                       TO_CHAR(W.Pol_Fec_Ini_Vig,'DD/MM/YYYY')    ||cLimitadorTxt||
                       TO_CHAR(W.Pol_Fec_Fin_Vig,'DD/MM/YYYY')    ||cLimitadorTxt||
                       TO_CHAR(W.Fec_Notif,'DD/MM/YYYY')          ||cLimitadorTxt||
                       TO_CHAR(W.Fec_Registro,'DD/MM/YYYY')       ||cLimitadorTxt||
                       TO_CHAR(W.Fec_Ocurr,'DD/MM/YYYY')          ||cLimitadorTxt||
                       W.Estatus_Sini                             ||cLimitadorTxt||
                       TO_CHAR(W.Cod_Caus_Sini,'9999999999999')   ||cLimitadorTxt||
                       W.Desc_Causa_Sini                          ||cLimitadorTxt||
                       TO_CHAR(W.IdEndoso,'9999999999999')        ||cLimitadorTxt||
                       TO_CHAR(W.No_Distrib,'9999999999999')      ||cLimitadorTxt||
                       TO_CHAR(W.Orden,'9999999999999')           ||cLimitadorTxt||
                       W.Gpo_Cob_Afect                            ||cLimitadorTxt||
                       TO_CHAR(W.Cap_Max,'99999999990.00')        ||cLimitadorTxt||
                       TO_CHAR(W.Porc_Distrib,'9999990.000000')   ||cLimitadorTxt||
                       TO_CHAR(W.Sum_Aseg_Distr,'99999999990.00') ||cLimitadorTxt||
                       W.Ano_Mes_Mov                              ||cLimitadorTxt||
                       TO_CHAR(W.Mto_Resva,'99999999990.00')      ||cLimitadorTxt||
                       TO_CHAR(dFec_Resva,'DD/MM/YYYY')           ||cLimitadorTxt||
                       TO_CHAR(W.Mto_Pago,'99999999990.00')       ||cLimitadorTxt||
                       TO_CHAR(dFec_Pago,'DD/MM/YYYY')            ||cLimitadorTxt||
                       TO_CHAR(W.Cod_Aseg,'9999999999999')        ||cLimitadorTxt||
                       W.Asegurado                                ||cLimitadorTxt||
                       TO_CHAR(W.Fec_Nac_Aseg,'DD/MM/YYYY')       ||cLimitadorTxt||
                       TO_CHAR(W.Certificado,'9999999999999')     ||cLimitadorTxt||
                       W.Esq_Reaseg                               ||cLimitadorTxt||
                       W.Cto_Reaseg                               ||cLimitadorTxt||
                       TO_CHAR(W.Capa_Cto,'9999999999999')        ||cLimitadorTxt||
                       W.Riesgo_Reaseg                            ||cLimitadorTxt||
                       W.Fec_Distrib                              ||cLimitadorTxt||
                       W.Moneda                                   ||CHR(13);
         ELSE
            cCadena := '<tr>'                                                    ||cLimitador|| 
                       cCampoFormatC||TO_CHAR(W.IdSiniestro,'9999999999990')     ||cLimitador||
                       cCampoFormatC||W.Nomencl                                  ||cLimitador||
                       cCampoFormatC||W.Referencia                               ||cLimitador||
                       cCampoFormatC||W.Contratante                              ||cLimitador||
                       cCampoFormatC||W.Num_Pol_Unic                             ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdPoliza,'9999999999990')        ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.Pol_Fec_Ini_Vig,'DD/MM/YYYY')    ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.Pol_Fec_Fin_Vig,'DD/MM/YYYY')    ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.Fec_Notif,'DD/MM/YYYY')          ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.Fec_Registro,'DD/MM/YYYY')       ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.Fec_Ocurr,'DD/MM/YYYY')          ||cLimitador||
                       cCampoFormatC||W.Estatus_Sini                             ||cLimitador||
                       cCampoFormatC||W.Cod_Caus_Sini                            ||cLimitador||
                       cCampoFormatC||W.Desc_Causa_Sini                          ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.IdEndoso,'9999999999990')        ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.No_Distrib,'9999999999990')      ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.Orden,'9999999999990')           ||cLimitador||
                       cCampoFormatC||W.Gpo_Cob_Afect                            ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.Cap_Max,'99999999990.00')        ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.Porc_Distrib,'9999990.000000')   ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.Sum_Aseg_Distr,'99999999990.00') ||cLimitador||
                       cCampoFormatC||W.Ano_Mes_Mov                              ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.Mto_Resva,'99999999990.00')      ||cLimitador||
                       cCampoFormatD||TO_CHAR(dFec_Resva,'DD/MM/YYYY')           ||cLimitador||
                       cCampoFormatN||TO_CHAR(W.Mto_Pago,'99999999990.00')       ||cLimitador||
                       cCampoFormatD||TO_CHAR(dFec_Pago,'DD/MM/YYYY')            ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.Cod_Aseg,'9999999999990')        ||cLimitador||
                       cCampoFormatC||W.Asegurado                                ||cLimitador||
                       cCampoFormatD||TO_CHAR(W.Fec_Nac_Aseg,'DD/MM/YYYY')       ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.Certificado,'9999999999990')     ||cLimitador||
                       cCampoFormatC||W.Esq_Reaseg                               ||cLimitador||
                       cCampoFormatC||W.Cto_Reaseg                               ||cLimitador||
                       cCampoFormatC||TO_CHAR(W.Capa_Cto,'9999999999990')        ||cLimitador||
                       cCampoFormatC||W.Riesgo_Reaseg                            ||cLimitador||
                       cCampoFormatC||W.Fec_Distrib                              ||cLimitador||
                       cCampoFormatC||W.Moneda                                   ||'</tr>';
         END IF;
         nLinea := nLinea + 1;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      END LOOP;
      --
      IF cFormato = 'EXCEL' THEN
         OC_ARCHIVO.Escribir_Linea('</table></div></html>', cCodUser, 9999);
      END IF;
      OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
   EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      RAISE_APPLICATION_ERROR(-20225,'Error en Generación de Reporte Siniestros Recuperados: Siniestro'||nSiniestro||' '||SQLERRM);
   END siniestro_recuperado;
END oc_reportes_reaseguro;
/
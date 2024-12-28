CREATE OR REPLACE PACKAGE SICAS_OC.OC_REPORTES_APEX AS
--TYPE ref_cursor IS REF CURSOR;
PROCEDURE GENERA_REPORTE_FOLIOS_FACT(nCodCia NUMBER, nCodEmpresa NUMBER, cModulo VARCHAR2, cCodReporte VARCHAR2, dFecDesde DATE, dFecHasta DATE, cFormato VARCHAR2, cNombreArchivo VARCHAR2);
PROCEDURE GENERA_REPORTE_ADMINISTRATIVOS(nCodCia NUMBER, nCodEmpresa NUMBER, cModulo VARCHAR2, cOpcion VARCHAR2,
                                         cCodReporte VARCHAR2, cCodMoneda VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                                         dFecDesde DATE, dFecHasta DATE, cFormato VARCHAR2, cNombreArchivo VARCHAR2);
                                         
PROCEDURE GENERA_REPORTE_PAGOISRFONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, cModulo VARCHAR2, cOpcion VARCHAR2,
                                         cCodReporte VARCHAR2, cIdTipoSeg VARCHAR2, dFecDesde DATE, dFecHasta DATE, 
                                         cFormato VARCHAR2, cNombreArchivo VARCHAR2);
                                         
PROCEDURE GENERA_REPORTE_COMERCIAL(nCodCia NUMBER, nCodEmpresa NUMBER, cModulo VARCHAR2, cOpcion VARCHAR2,
                                   cCodReporte VARCHAR2, cCodMoneda VARCHAR2, cIdTipoSeg VARCHAR2, nCodAgente NUMBER,
                                   dFecDesde DATE, dFecHasta DATE, cFormato VARCHAR2, cNombreArchivo VARCHAR2);
                                   
PROCEDURE GENERA_RESICO(nCodCia NUMBER, nCodEmpresa NUMBER, cModulo VARCHAR2, cOpcion VARCHAR2,
                        cCodReporte VARCHAR2, nIdRegFisSat NUMBER, cFormato VARCHAR2, cNombreArchivo VARCHAR2);                        
                        
PROCEDURE GENERA_GENERALES(nCodCia NUMBER, nCodEmpresa NUMBER, cModulo VARCHAR2, cOpcion VARCHAR2,
                           cCodReporte VARCHAR2, cCodMoneda VARCHAR2, cIdTipoSeg VARCHAR2, dFecDesde DATE, 
                           dFecHasta DATE, nCodCliente NUMBER, dFecMorosidad DATE, cFormato VARCHAR2, cNombreArchivo VARCHAR2);
END OC_REPORTES_APEX;
/
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_REPORTES_APEX AS
--PROCEDURE GENERA_REPORTE_FOLIOS_FACT(nCodCia NUMBER, nCodEmpresa NUMBER, cModulo VARCHAR2, cCodReporte VARCHAR2, dFecDesde DATE, dFecHasta DATE, cResultado OUT ref_cursor) IS
PROCEDURE GENERA_REPORTE_FOLIOS_FACT(nCodCia NUMBER, nCodEmpresa NUMBER, cModulo VARCHAR2, cCodReporte VARCHAR2, dFecDesde DATE, dFecHasta DATE, cFormato VARCHAR2, cNombreArchivo VARCHAR2) IS
cAbreCelda           VARCHAR2(20)   := '<Cell>';
cCierraCelda         VARCHAR2(20)   := '</Cell>';
cAbreContenidoString VARCHAR2(40)   := '<Data ss:Type="String">'; 
cAbreContenidoNumber VARCHAR2(40)   := '<Data ss:Type="Number">';
cCierraContenido     VARCHAR2(20)   := '</Data>';
cHeader              VARCHAR2(4000) := '<?xml version="1.0" encoding="UTF-8"?>'||chr(10)||
                                       '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'||chr(10)||
                                       '          xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                                       '          xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                                       '          xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'||chr(10)||
                                       '          xmlns:html="http://www.w3.org/TR/REC-html40">'||chr(10);
cPropiedades         VARCHAR2(4000) := '    <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'||chr(10)||
                                       '        <Author>Oracle</Author>'||chr(10)||
                                       '        <LastAuthor>Oracle</LastAuthor>'||chr(10)||
                                       '        <Created>2024-10-29T00:00:00Z</Created>'||chr(10)||
                                       '        <Version>16.00</Version>'||chr(10)||
                                       '    </DocumentProperties>'||chr(10);
cEstilos             VARCHAR2(4000) := '    <Styles>'||chr(10)||
                                       '        <Style ss:ID="Default" ss:Name="Normal">'||chr(10)||
                                       '            <Alignment ss:Vertical="Bottom"/>'||chr(10)||
                                       '            <Borders/>'||chr(10)||
                                       '            <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'||chr(10)||
                                       '            <Interior/>'||chr(10)||
                                       '            <NumberFormat/>'||chr(10)||
                                       '            <Protection/>'||chr(10)||
                                       '        </Style>'||chr(10)||
                                       '    </Styles>'||chr(10);       
nLinea               NUMBER;
cCodUser             VARCHAR2(30);
cCadena              VARCHAR2(32000);
CURSOR Q_FOLIOS IS
   SELECT P.IdPoliza,P.NumPolUnico,FE.IdFactura,FE.IdNcr,OC_CLIENTES.NOMBRE_CLIENTE(NVL(F.CodCliRFCGenerico,F.CodCliente)) ClienteFacturado,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PROCFACELE',FE.CodProceso) Proceso,
          FE.UUID,FE.UUIDCancelado,FE.Serie,FE.FolioFiscal Folio,OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CATERRSAT',FE.CodRespuestaSAT) RespuestaTimbrado,
          FE.FechaUUID
     FROM FACT_ELECT_DETALLE_TIMBRE FE,FACTURAS F,POLIZAS P
    WHERE FE.CodCia           = nCodCia
      AND FE.CodEmpresa       = nCodEmpresa
      AND FE.IdFactura   IS NOT NULL
      AND FE.FechaUUID  BETWEEN dFecDesde AND dFecHasta
      AND FE.CodCia           = F.CodCia
      AND FE.IdFactura        = F.IdFactura
      AND F.CodCia            = P.CodCia
      AND F.IdPoliza          = P.IdPoliza 
    UNION 
   SELECT P.IdPoliza,P.NumPolUnico,FE.IdFactura,FE.IdNcr,OC_CLIENTES.NOMBRE_CLIENTE(N.CodCliente) ClienteFacturado,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PROCFACELE',FE.CodProceso) Proceso,
          FE.UUID,FE.UUIDCancelado,FE.Serie,FE.FolioFiscal Folio,OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CATERRSAT',FE.CodRespuestaSAT) RespuestaTimbrado,
          FE.FechaUUID
     FROM FACT_ELECT_DETALLE_TIMBRE FE,NOTAS_DE_CREDITO N,POLIZAS P
    WHERE FE.CodCia           = nCodCia
      AND FE.CodEmpresa       = nCodEmpresa
      AND FE.IdNcr       IS NOT NULL
      AND FechaUUID     BETWEEN dFecDesde AND dFecHasta
      AND FE.CodCia           = N.CodCia
      AND FE.IdNcr            = N.IdNcr
      AND N.CodCia            = P.CodCia
      AND N.IdPoliza          = P.IdPoliza;
BEGIN 
   cCodUser := COALESCE(SYS_CONTEXT('APEX$SESSION','APP_USER'),USER); 
   
   IF cFormato = 'EXCEL' THEN
      nLinea   := 1;
      cCadena  := OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia);
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := cHeader;
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      
      -- Propiedades del documento
      cCadena  := cPropiedades; 
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
   
       -- Define estilos (opcional, pero reduce errores)
      cCadena  := cEstilos;
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      
      cCadena  := '    <Worksheet ss:Name="'||cNombreArchivo||'">'||chr(10)||
                  '<Table>'||chr(10)||
                  '<Row>'||chr(10);
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := cAbreCelda||cAbreContenidoString||'No. de Poliza'              ||cCierraContenido||cCierraCelda||
                  cAbreCelda||cAbreContenidoString||'Consecutivo'                ||cCierraContenido||cCierraCelda||
                  cAbreCelda||cAbreContenidoString||'No. Factura'                ||cCierraContenido||cCierraCelda||
                  cAbreCelda||cAbreContenidoString||'Id NCR'                     ||cCierraContenido||cCierraCelda||
                  cAbreCelda||cAbreContenidoString||'Nombre Cliente / Facturado' ||cCierraContenido||cCierraCelda||
                  cAbreCelda||cAbreContenidoString||'Proceso'                    ||cCierraContenido||cCierraCelda||
                  cAbreCelda||cAbreContenidoString||'UUID'                       ||cCierraContenido||cCierraCelda||
                  cAbreCelda||cAbreContenidoString||'UUIDCancelado'              ||cCierraContenido||cCierraCelda||
                  cAbreCelda||cAbreContenidoString||'Serie'                      ||cCierraContenido||cCierraCelda||
                  cAbreCelda||cAbreContenidoString||'Folio'                      ||cCierraContenido||cCierraCelda||
                  cAbreCelda||cAbreContenidoString||'Respuesta de Timbrado'      ||cCierraContenido||cCierraCelda||
                  cAbreCelda||cAbreContenidoString||'Fecha Timbre'               ||cCierraContenido||cCierraCelda;
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := '</Row>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
   END IF;
   FOR W IN Q_FOLIOS LOOP
      IF cFormato = 'EXCEL' THEN
         nLinea := nLinea + 1;
         cCadena  := '<Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := cAbreCelda||cAbreContenidoNumber||TO_CHAR(W.IdPoliza)                ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||TO_CHAR(W.NumPolUnico)             ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoNumber||TO_CHAR(W.IdFactura)               ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoNumber||TO_CHAR(W.IdNcr)                   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(TO_CHAR(W.ClienteFacturado))||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(TO_CHAR(W.Proceso))                 ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||TO_CHAR(W.UUID)                    ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||TO_CHAR(W.UUIDCancelado)           ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||TO_CHAR(W.Serie)                   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoNumber||TO_CHAR(W.Folio)                   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(TO_CHAR(W.RespuestaTimbrado))       ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||TO_CHAR(W.FechaUUID,'DD/MM/YYYY')  ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
      END IF;
   END LOOP;
   
   cCadena  := '</Table>';
   OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
   nLinea   := nLinea + 1;
   cCadena  := '</Worksheet>';
   OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
   nLinea   := nLinea + 1;
   cCadena  := '</Workbook>';
   OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
   
   OC_ARCHIVO.ESCRIBIR_LINEA('EOF', cCodUser, 0);
   OC_ARCHIVO.ACTUALIZA_ARCHIVO(cCodUser, cFormato, cNombreArchivo);
   EXCEPTION
      WHEN OTHERS THEN
         OC_ARCHIVO.ELIMINAR_ARCHIVO(cCodUser);
END GENERA_REPORTE_FOLIOS_FACT;

PROCEDURE GENERA_REPORTE_ADMINISTRATIVOS(nCodCia NUMBER, nCodEmpresa NUMBER, cModulo VARCHAR2, cOpcion VARCHAR2,
                                         cCodReporte VARCHAR2, cCodMoneda VARCHAR2, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                                         dFecDesde DATE, dFecHasta DATE, cFormato VARCHAR2, cNombreArchivo VARCHAR2) IS
cAbreCelda           VARCHAR2(20) := '<Cell>';
cCierraCelda         VARCHAR2(20) := '</Cell>';
cAbreContenidoString VARCHAR2(40) := '<Data ss:Type="String">'; 
cAbreContenidoNumber VARCHAR2(40) := '<Data ss:Type="Number">';
cCierraContenido     VARCHAR2(20) := '</Data>';
cHeader              VARCHAR2(4000) := '<?xml version="1.0" encoding="UTF-8"?>'||chr(10)||
                                       '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'||chr(10)||
                                       '          xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                                       '          xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                                       '          xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'||chr(10)||
                                       '          xmlns:html="http://www.w3.org/TR/REC-html40">'||chr(10);
cPropiedades         VARCHAR2(4000) := '    <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'||chr(10)||
                                       '        <Author>Oracle</Author>'||chr(10)||
                                       '        <LastAuthor>Oracle</LastAuthor>'||chr(10)||
                                       '        <Created>2024-10-29T00:00:00Z</Created>'||chr(10)||
                                       '        <Version>16.00</Version>'||chr(10)||
                                       '    </DocumentProperties>'||chr(10);
cEstilos             VARCHAR2(4000) := '    <Styles>'||chr(10)||
                                       '        <Style ss:ID="Default" ss:Name="Normal">'||chr(10)||
                                       '            <Alignment ss:Vertical="Bottom"/>'||chr(10)||
                                       '            <Borders/>'||chr(10)||
                                       '            <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'||chr(10)||
                                       '            <Interior/>'||chr(10)||
                                       '            <NumberFormat/>'||chr(10)||
                                       '            <Protection/>'||chr(10)||
                                       '        </Style>'||chr(10)||
                                       '    </Styles>'||chr(10);     
nLinea               NUMBER;
cCodUser             VARCHAR2(30);
cCadena              VARCHAR2(32000);
CURSOR Q_FOLIOS IS
   SELECT P.IdPoliza,P.NumPolUnico,FE.IdFactura,FE.IdNcr,OC_CLIENTES.NOMBRE_CLIENTE(NVL(F.CodCliRFCGenerico,F.CodCliente)) ClienteFacturado,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PROCFACELE',FE.CodProceso) Proceso,
          FE.UUID,FE.UUIDCancelado,FE.Serie,FE.FolioFiscal Folio,OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CATERRSAT',FE.CodRespuestaSAT) RespuestaTimbrado,
          FE.FechaUUID
     FROM FACT_ELECT_DETALLE_TIMBRE FE,FACTURAS F,POLIZAS P
    WHERE FE.CodCia           = nCodCia
      AND FE.CodEmpresa       = nCodEmpresa
      AND FE.IdFactura   IS NOT NULL
      AND FE.FechaUUID  BETWEEN dFecDesde AND dFecHasta
      AND FE.CodCia           = F.CodCia
      AND FE.IdFactura        = F.IdFactura
      AND F.CodCia            = P.CodCia
      AND F.IdPoliza          = P.IdPoliza 
    UNION 
   SELECT P.IdPoliza,P.NumPolUnico,FE.IdFactura,FE.IdNcr,OC_CLIENTES.NOMBRE_CLIENTE(N.CodCliente) ClienteFacturado,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PROCFACELE',FE.CodProceso) Proceso,
          FE.UUID,FE.UUIDCancelado,FE.Serie,FE.FolioFiscal Folio,OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CATERRSAT',FE.CodRespuestaSAT) RespuestaTimbrado,
          FE.FechaUUID
     FROM FACT_ELECT_DETALLE_TIMBRE FE,NOTAS_DE_CREDITO N,POLIZAS P
    WHERE FE.CodCia           = nCodCia
      AND FE.CodEmpresa       = nCodEmpresa
      AND FE.IdNcr       IS NOT NULL
      AND FechaUUID     BETWEEN dFecDesde AND dFecHasta
      AND FE.CodCia           = N.CodCia
      AND FE.IdNcr            = N.IdNcr
      AND N.CodCia            = P.CodCia
      AND N.IdPoliza          = P.IdPoliza;  
      
CURSOR MEDCOB_Q IS 
   SELECT P.IdPoliza,P.NumPolUnico,P.FecIniVig,P.FecFinVig,P.IndFacturaPol FacturaPorPoliza,
          OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) NombreCliente,
          MC.IdFormaCobro,MC.IndMedioPrincipal,MC.CodFormaCobro,
          MC.CodEntidadFinan,MC.NumCuentaBancaria,MC.NumCuentaClabe,
          TO_CHAR(MC.NumTarjeta) NumTarjeta,MC.FechaVencTarjeta,MC.NombreTitular,
          D.IdTipoSeg,OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(P.CodCia, P.CodEmpresa, D.IdTipoSeg, D.PlanCob) PlanPago
     FROM POLIZAS P,DETALLE_POLIZA D,CLIENTES C,PERSONA_NATURAL_JURIDICA PN,MEDIOS_DE_COBRO MC
    WHERE P.CodCia                     = nCodCia
      AND P.CodEmpresa                 = nCodEmpresa
      AND P.StsPoliza                 IN ('EMI')
      AND D.IdTipoSeg                  = NVL(cIdTipoSeg, D.IdTipoSeg)  
      /*((D.IdTipoSeg                = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (D.IdTipoSeg             LIKE cIdTipoSeg AND cIdTipoSeg = '%'))*/
      AND D.PlanCob                    = NVL(cPlanCob, D.PlanCob)
      /*((D.PlanCob                  = cPlanCob AND cPlanCob != '%')
       OR  (D.PlanCob               LIKE cPlanCob AND cPlanCob = '%'))*/
      AND P.Cod_Moneda                 = NVL(cCodMoneda, P.Cod_Moneda)
      /*((P.Cod_Moneda               = cCodMoneda AND cCodMoneda != '%')
       OR  (P.Cod_Moneda            LIKE cCodMoneda AND cCodMoneda = '%'))*/
      AND OC_POLIZAS.FACTURA_POR_POLIZA(P.CodCia, P.CodEmpresa, P.IdPoliza) = 'S'
      AND P.CodCia                     = D.CodCia
      AND P.IdPoliza                   = D.IdPoliza
      AND P.CodCliente                 = C.CodCliente
      AND C.Num_Doc_Identificacion     = PN.Num_Doc_Identificacion
      AND C.Tipo_Doc_Identificacion    = PN.Tipo_Doc_Identificacion
      AND C.Num_Doc_Identificacion     = MC.Num_Doc_Identificacion
      AND C.Tipo_Doc_Identificacion    = MC.Tipo_Doc_Identificacion
    UNION 
   SELECT P.IdPoliza,P.NumPolUnico,P.FecIniVig,P.FecFinVig,P.IndFacturaPol FacturaPorPoliza,
          OC_ASEGURADO.NOMBRE_ASEGURADO(P.CodCia, P.CodEmpresa, A.Cod_Asegurado) NombreCliente,
          MC.IdFormaCobro,MC.IndMedioPrincipal,MC.CodFormaCobro,
          MC.CodEntidadFinan,MC.NumCuentaBancaria,MC.NumCuentaClabe,
          TO_CHAR(MC.NumTarjeta) NumTarjeta,MC.FechaVencTarjeta,MC.NombreTitular,
          D.IdTipoSeg,OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(P.CodCia, P.CodEmpresa, D.IdTipoSeg, D.PlanCob) PlanPago
     FROM POLIZAS P,DETALLE_POLIZA D,ASEGURADO A,PERSONA_NATURAL_JURIDICA PN,MEDIOS_DE_COBRO MC
    WHERE P.CodCia                     = nCodCia
      AND P.CodEmpresa                 = nCodEmpresa
      AND P.StsPoliza                 IN ('EMI')
      AND D.IdTipoSeg                  = NVL(cIdTipoSeg, D.IdTipoSeg)  
      /*((D.IdTipoSeg                = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (D.IdTipoSeg             LIKE cIdTipoSeg AND cIdTipoSeg = '%'))*/
      AND D.PlanCob                    = NVL(cPlanCob, D.PlanCob)
      /*((D.PlanCob                  = cPlanCob AND cPlanCob != '%')
       OR  (D.PlanCob               LIKE cPlanCob AND cPlanCob = '%'))*/
      AND P.Cod_Moneda                 = NVL(cCodMoneda, P.Cod_Moneda)
      /*((P.Cod_Moneda               = cCodMoneda AND cCodMoneda != '%')
       OR  (P.Cod_Moneda            LIKE cCodMoneda AND cCodMoneda = '%'))*/
      AND OC_POLIZAS.FACTURA_POR_POLIZA(P.CodCia, P.CodEmpresa, P.IdPoliza) = 'N'
      AND P.CodCia                     = D.CodCia
      AND P.IdPoliza                   = D.IdPoliza
      AND D.Cod_Asegurado              = A.Cod_Asegurado
      AND A.Num_Doc_Identificacion     = PN.Num_Doc_Identificacion
      AND A.Tipo_Doc_Identificacion    = PN.Tipo_Doc_Identificacion
      AND A.Num_Doc_Identificacion     = MC.Num_Doc_Identificacion
      AND A.Tipo_Doc_Identificacion    = MC.Tipo_Doc_Identificacion;      
BEGIN
   cCodUser := COALESCE(SYS_CONTEXT('APEX$SESSION','APP_USER'),USER); 
   IF cFormato = 'EXCEL' THEN
      nLinea   := 1;
      cCadena  := OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia);
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := cHeader;
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      
      -- Propiedades del documento
      cCadena  := cPropiedades; 
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
   
       -- Define estilos (opcional, pero reduce errores)
      cCadena  := cEstilos;
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := '    <Worksheet ss:Name="'||cNombreArchivo||'">'||chr(10)||
                  '<Table>'||chr(10)||
                  '<Row>'||chr(10);
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
   END IF;
   IF cCodReporte = 'FOLIOSFACT' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||'No. de Poliza'              ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Consecutivo'                ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'No. Factura'                ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Id NCR'                     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre Cliente / Facturado' ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Proceso'                    ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'UUID'                       ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'UUIDCancelado'              ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Serie'                      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Folio'                      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Respuesta de Timbrado'      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Fecha Timbre'               ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      END IF;
      FOR W IN Q_FOLIOS LOOP
         IF cFormato = 'EXCEL' THEN
            nLinea := nLinea + 1;
            cCadena  := '<Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena  := cAbreCelda||cAbreContenidoNumber||TO_CHAR(W.IdPoliza)                                              ||cCierraContenido||cCierraCelda||
                        cAbreCelda||cAbreContenidoString||TO_CHAR(W.NumPolUnico)                                           ||cCierraContenido||cCierraCelda||
                        cAbreCelda||cAbreContenidoNumber||TO_CHAR(W.IdFactura)                                             ||cCierraContenido||cCierraCelda||
                        cAbreCelda||cAbreContenidoNumber||TO_CHAR(W.IdNcr)                                                 ||cCierraContenido||cCierraCelda||
                        cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(TO_CHAR(W.ClienteFacturado))   ||cCierraContenido||cCierraCelda||
                        cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(TO_CHAR(W.Proceso))            ||cCierraContenido||cCierraCelda||
                        cAbreCelda||cAbreContenidoString||TO_CHAR(W.UUID)                                                  ||cCierraContenido||cCierraCelda||
                        cAbreCelda||cAbreContenidoString||TO_CHAR(W.UUIDCancelado)                                         ||cCierraContenido||cCierraCelda||
                        cAbreCelda||cAbreContenidoString||TO_CHAR(W.Serie)                                                 ||cCierraContenido||cCierraCelda||
                        cAbreCelda||cAbreContenidoNumber||TO_CHAR(W.Folio)                                                 ||cCierraContenido||cCierraCelda||
                        cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(TO_CHAR(W.RespuestaTimbrado))  ||cCierraContenido||cCierraCelda||
                        cAbreCelda||cAbreContenidoString||TO_CHAR(W.FechaUUID,'DD/MM/YYYY')                                ||cCierraContenido||cCierraCelda;
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena  := '</Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
         END IF;
      END LOOP;
   ELSIF cCodReporte = 'MEDIOSCOB' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('No. de Póliza')               ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Consecutivo'                ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Fecha Inicio Vigencia'      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Fecha Fin Vigencia'         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre Cliente / Asegurado' ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Tipo Seguro'                ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Plan de Cobertura'          ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Facturación Por Póliza')     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Id Forma Cobro'             ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Medio Principal'            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Forma Cobro')         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Código Entidad Financiera'  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Número Cuenta Bancaria'     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Número Cuenta CLABE'        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Número Tarjeta'             ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Fecha Vencimiento Tarjeta'  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre Titular'             ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         FOR Z IN MEDCOB_Q LOOP
            IF cFormato = 'EXCEL' THEN
               nLinea := nLinea + 1;
               cCadena  := '<Row>';
               OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
               nLinea   := nLinea + 1;
               cCadena := cAbreCelda||cAbreContenidoString||Z.NumPolUnico                                ||cCierraContenido||cCierraCelda||
                          cAbreCelda||cAbreContenidoNumber||Z.IdPoliza                                   ||cCierraContenido||cCierraCelda||
                          cAbreCelda||cAbreContenidoString||TO_CHAR(Z.FecIniVig,'DD/MM/RRRR')            ||cCierraContenido||cCierraCelda||
                          cAbreCelda||cAbreContenidoString||TO_CHAR(Z.FecFinVig,'DD/MM/RRRR')            ||cCierraContenido||cCierraCelda||
                          cAbreCelda||cAbreContenidoString||Z.NombreCliente                              ||cCierraContenido||cCierraCelda||
                          cAbreCelda||cAbreContenidoString||Z.IdTipoSeg                                  ||cCierraContenido||cCierraCelda||
                          cAbreCelda||cAbreContenidoString||Z.PlanPago                                   ||cCierraContenido||cCierraCelda||
                          cAbreCelda||cAbreContenidoString||Z.FacturaPorPoliza                           ||cCierraContenido||cCierraCelda||
                          cAbreCelda||cAbreContenidoNumber||Z.IdFormaCobro                               ||cCierraContenido||cCierraCelda||
                          cAbreCelda||cAbreContenidoString||Z.IndMedioPrincipal                          ||cCierraContenido||cCierraCelda||
                          cAbreCelda||cAbreContenidoString||Z.CodFormaCobro                              ||cCierraContenido||cCierraCelda||
                          cAbreCelda||cAbreContenidoString||Z.CodEntidadFinan                            ||cCierraContenido||cCierraCelda||
                          cAbreCelda||cAbreContenidoNumber||Z.NumCuentaBancaria                          ||cCierraContenido||cCierraCelda||
                          cAbreCelda||cAbreContenidoNumber||Z.NumCuentaClabe                             ||cCierraContenido||cCierraCelda||
                          cAbreCelda||cAbreContenidoNumber||Z.NumTarjeta                                 ||cCierraContenido||cCierraCelda||
                          cAbreCelda||cAbreContenidoString||TO_CHAR(Z.FechaVencTarjeta,'DD/MM/RRRR')     ||cCierraContenido||cCierraCelda||
                          cAbreCelda||cAbreContenidoString||Z.NombreTitular                              ||cCierraContenido||cCierraCelda;
               OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
               nLinea   := nLinea + 1;
               cCadena  := '</Row>';
               OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
               nLinea   := nLinea + 1;
            END IF;
         END LOOP;
      END IF;
   END IF;
   IF cFormato = 'EXCEL' THEN   
      cCadena  := '</Table>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := '</Worksheet>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := '</Workbook>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      
      OC_ARCHIVO.ESCRIBIR_LINEA('EOF', cCodUser, 0);
      OC_ARCHIVO.ACTUALIZA_ARCHIVO(cCodUser, cFormato, cNombreArchivo);
   END IF;
   EXCEPTION
      WHEN OTHERS THEN
         OC_ARCHIVO.ELIMINAR_ARCHIVO(cCodUser);
END GENERA_REPORTE_ADMINISTRATIVOS;

PROCEDURE GENERA_REPORTE_PAGOISRFONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, cModulo VARCHAR2, cOpcion VARCHAR2,
                                         cCodReporte VARCHAR2, cIdTipoSeg VARCHAR2, dFecDesde DATE, dFecHasta DATE, 
                                         cFormato VARCHAR2, cNombreArchivo VARCHAR2) IS
cAbreCelda           VARCHAR2(20) := '<Cell>';
cCierraCelda         VARCHAR2(20) := '</Cell>';
cAbreContenidoString VARCHAR2(40) := '<Data ss:Type="String">'; 
cAbreContenidoNumber VARCHAR2(40) := '<Data ss:Type="Number">';
cCierraContenido     VARCHAR2(20) := '</Data>';
cHeader              VARCHAR2(4000) := '<?xml version="1.0" encoding="UTF-8"?>'||chr(10)||
                                       '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'||chr(10)||
                                       '          xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                                       '          xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                                       '          xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'||chr(10)||
                                       '          xmlns:html="http://www.w3.org/TR/REC-html40">'||chr(10);
cPropiedades         VARCHAR2(4000) := '    <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'||chr(10)||
                                       '        <Author>Oracle</Author>'||chr(10)||
                                       '        <LastAuthor>Oracle</LastAuthor>'||chr(10)||
                                       '        <Created>2024-10-29T00:00:00Z</Created>'||chr(10)||
                                       '        <Version>16.00</Version>'||chr(10)||
                                       '    </DocumentProperties>'||chr(10);
cEstilos             VARCHAR2(4000) := '    <Styles>'||chr(10)||
                                       '        <Style ss:ID="Default" ss:Name="Normal">'||chr(10)||
                                       '            <Alignment ss:Vertical="Bottom"/>'||chr(10)||
                                       '            <Borders/>'||chr(10)||
                                       '            <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'||chr(10)||
                                       '            <Interior/>'||chr(10)||
                                       '            <NumberFormat/>'||chr(10)||
                                       '            <Protection/>'||chr(10)||
                                       '        </Style>'||chr(10)||
                                       '    </Styles>'||chr(10);     
nLinea                  NUMBER;
cCodUser                VARCHAR2(30);
cCadena                 VARCHAR2(32000);  
nSPV						   NUMBER(1) := 0;
cNombre_Impresion		   VARCHAR2(150);
nMtoAporteIniLocal      NUMBER(28,6);
nSaldoFinal             NUMBER(28,6);
nInteresNominal		   NUMBER(18,6);
nISRRet					   NUMBER(18,6);
nIntNetPagado			   NUMBER(18,6);
nInteresAcumulado		   NUMBER(18,6);
cNombreMes				   VARCHAR2(15);
cAnio						   VARCHAR2(4);
nMtoAporteIniLocal_Acum NUMBER(28,6) := 0;
nInteresNominal_Acum		NUMBER(18,6) := 0;
nISRRet_Acum				NUMBER(18,6) := 0;
nIntNetPagado_Acum		NUMBER(18,6) := 0;
nInteresAcumulado_Acum	NUMBER(18,6) := 0;
cFechaAcum					VARCHAR2(10);
nTasaPromedio				NUMBER(18,6) :=0;
nTasa							NUMBER(18,6) :=0;
--cNombreMes					VARCHAR2(15);

CURSOR C_ISRFONDOSMENS IS
   SELECT DISTINCT TRIM(TRIM(PNJ.Nombre)||' '||TRIM(PNJ.Apellido_Paterno)||' '||TRIM(PNJ.Apellido_Materno)) NombreCliente,
          PNJ.Num_Doc_Identificacion, F.FecMovimiento, F.CodAsegurado
     FROM PERSONA_NATURAL_JURIDICA PNJ, ASEGURADO A, FAI_CONCENTRADORA_FONDO F, 
          DETALLE_POLIZA D
    WHERE F.FecMovimiento              BETWEEN dFecDesde AND dFecHasta
      AND F.StsMovimiento                    = 'ACTIVO' 
      AND F.CodCptoMov                       = 'INTFON'
      AND OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(F.CodCia, F.CodEmpresa, D.IdTipoSeg) = 'S'
      --AND D.IdTipoSeg = 'VICAP'
      AND D.IdTipoSeg                        = NVL(cIdTipoSeg,D.IdTipoSeg)
      /*((D.IdTipoSeg                      = cIdTipoSeg AND cIdTipoSeg != '%')
          OR  (D.IdTipoSeg                LIKE cIdTipoSeg AND cIdTipoSeg = '%'))*/
      AND PNJ.Tipo_Doc_Identificacion        = A.Tipo_Doc_Identificacion
      AND PNJ.Num_Doc_Identificacion         = A.Num_Doc_Identificacion 
      AND A.Cod_Asegurado                    = F.CodAsegurado
      AND F.CodCia                           = D.CodCia
      AND F.IdPoliza                         = D.IdPoliza
      AND F.IDetPol                          = D.IDetPol
    ORDER BY 1,2;  
    
CURSOR C_ENCABEZADOS IS
   SELECT CodCia, CodEmpresa, Orden,  
          CodConcepto, DescriConcepto, Signo	         
     FROM CONCEPTOS_REPORTE_FONDOS 
    ORDER BY Orden;    
BEGIN
   IF cCodReporte = 'RETISRANUA' THEN
      SELECT TO_CHAR(TRUNC(dFecDesde,'mm'),'Month') 
		  INTO cNombreMes
		  FROM DUAL;

		SELECT TO_CHAR(TRUNC(TO_DATE(dFecDesde)),'YYYY') 
		  INTO cAnio 
		  FROM DUAL; 
		
		SELECT ('01/01/'||cAnio) 
		  INTO cFechaAcum 
		  FROM DUAL;
   END IF;
   cCodUser := COALESCE(SYS_CONTEXT('APEX$SESSION','APP_USER'),USER); 
   IF cFormato = 'EXCEL' THEN
      nLinea   := 1;
      cCadena  := cHeader;
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      
      -- Propiedades del documento
      cCadena  := cPropiedades; 
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
   
       -- Define estilos (opcional, pero reduce errores)
      cCadena  := cEstilos;
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := '    <Worksheet ss:Name="'||cNombreArchivo||'">'||chr(10)||
                  '<Table>'||chr(10)||
                  '<Row>'||chr(10);
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := cAbreCelda||cAbreContenidoString||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||cCierraContenido||cCierraCelda;
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := '</Row>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      IF cCodReporte = 'RETISRANUA' THEN
         cCadena  := '<Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         
         cCadena  := cAbreCelda||cAbreContenidoString||'Reporte de Retenciones de ISR por pago de Intereses '||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Mes:   '|| UPPER(cNombreMes) || ' - '||cAnio||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
      END IF;  
      cCadena  := '<Row>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
   END IF;
   IF cCodReporte = 'RETISRMENS' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||'Nombre del Cliente'                                 ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'RFC'                                                ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Monto Inversión') ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Tasa'                                               ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Plazo'                                              ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Interes Nominal'                                    ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'ISR Retenido'                                       ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Interes Neto Pagado'                                ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Interes Acumulado'                                  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Tasa Promedio'                                      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Fecha'                                              ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         -----
         FOR X IN C_ISRFONDOSMENS LOOP
            IF cFormato = 'EXCEL' THEN
               IF nSPV	 = 0 THEN
                  cNombre_Impresion := X.NombreCliente;
                  nSPV := 1;
               END IF;
	  	  
               IF cNombre_Impresion = X.NombreCliente THEN
                  nSPV := 1;
               ELSE
                  cNombre_Impresion := X.NombreCliente;	
                  nLinea := nLinea + 1;
                  cCadena  := '<Row>';
                  OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
                  nLinea   := nLinea + 1;
                  cCadena := cAbreCelda||cAbreContenidoString||'Sumas : '           ||cCierraContenido||cCierraCelda||
	                          cAbreCelda||cAbreContenidoString||' '                  ||cCierraContenido||cCierraCelda||
	                          cAbreCelda||cAbreContenidoNumber||nSaldoFinal          ||cCierraContenido||cCierraCelda||
	                          cAbreCelda||cAbreContenidoString||' '                  ||cCierraContenido||cCierraCelda||
	                          cAbreCelda||cAbreContenidoString||' '                  ||cCierraContenido||cCierraCelda||
	                          cAbreCelda||cAbreContenidoNumber||nInteresNominal_Acum ||cCierraContenido||cCierraCelda||
	                          cAbreCelda||cAbreContenidoNumber||nISRRet_Acum         ||cCierraContenido||cCierraCelda||
	                          cAbreCelda||cAbreContenidoNumber||nIntNetPagado_Acum   ||cCierraContenido||cCierraCelda||
	                          cAbreCelda||cAbreContenidoNumber||nInteresAcumulado    ||cCierraContenido||cCierraCelda||
									  cAbreCelda||cAbreContenidoString||' '                  ||cCierraContenido||cCierraCelda||
                             cAbreCelda||cAbreContenidoString||X.FecMovimiento      ||cCierraContenido||cCierraCelda;										         
                  OC_ARCHIVO.Escribir_Linea(cCadena, USER, nLinea);
                  nLinea   := nLinea + 1;
                  cCadena  := '</Row>';
                  OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
                  nLinea   := nLinea + 1;
                  
                  nMtoAporteIniLocal_Acum := 0;
                  nInteresNominal_Acum		:= 0;
                  nISRRet_Acum				:= 0;
                  nIntNetPagado_Acum		:= 0;
                  nInteresAcumulado_Acum	:= 0;						  	
               END IF;	
  	  
               --- SALDO INICIAL ---							       
		      	BEGIN
                  SELECT NVL(SUM(F.MontoMovMoneda),0)
                    INTO nMtoAporteIniLocal
                    FROM FAI_CONCENTRADORA_FONDO F
                   WHERE F.CodAsegurado          = X.CodAsegurado
                     AND TRUNC(F.FecMovimiento) <= X.FecMovimiento
                     AND F.StsMovimiento         = 'ACTIVO';
		      	END;
		
               BEGIN
                  SELECT NVL(SUM(F.MontoMovMoneda),0)
                    INTO nSaldoFinal
                    FROM FAI_CONCENTRADORA_FONDO F
                   WHERE F.CodAsegurado          = X.CodAsegurado
                     AND TRUNC(F.FecMovimiento) <= dFecHasta
                     AND F.StsMovimiento         = 'ACTIVO';
               END; 
      
               BEGIN
                  SELECT NVL(SUM(FCF.MontoMovMoneda),0) 
						  INTO nInteresNominal
						 FROM FAI_CONCENTRADORA_FONDO FCF
						WHERE FCF.FecMovimiento    = X.FecMovimiento 
                    AND FCF.CodAsegurado     = X.CodAsegurado
                    AND FCF.CodCptoMov       = 'INTFON'
                    AND FCF.StsMovimiento    = 'ACTIVO' ;
               EXCEPTION  WHEN OTHERS THEN
                  nInteresNominal := '0.00';
               END ; 		      
		       
               BEGIN
                  SELECT NVL(SUM(FCF.MontoMovMoneda),0) 
                    INTO nISRRet
                    FROM FAI_CONCENTRADORA_FONDO FCF
                   WHERE FCF.FecMovimiento   = X.FecMovimiento
                     AND FCF.CodAsegurado    = X.CodAsegurado						
                     AND FCF.CodCptoMov     IN('RETISR')
                     AND FCF.StsMovimiento   = 'ACTIVO' ;
               EXCEPTION  WHEN OTHERS THEN
                  nISRRet := '0.00';
               END ; 	
						
               BEGIN
                  SELECT NVL(SUM(FCF.MontoMovMoneda),0) 
                    INTO nInteresAcumulado
                    FROM FAI_CONCENTRADORA_FONDO FCF
                   WHERE FCF.FecMovimiento   BETWEEN TO_DATE(cFechaAcum,'DD/MM/YYYY') AND X.FecMovimiento -------ojo
                     AND FCF.CodAsegurado          = X.CodAsegurado						
                     AND FCF.CodCptoMov            = 'INTFON' 
                     AND FCF.StsMovimiento         = 'ACTIVO' ;
               EXCEPTION  WHEN OTHERS THEN
                  nInteresAcumulado := '0.00';
               END ; 		      		      

               SELECT AVG(TAI3.TasaInteres)
					  INTO nTasaPromedio
					  FROM (SELECT DISTINCT DP.IdPoliza, DP.IDetPol, DP.Cod_Asegurado, 
                              DP.PlanCob, FCF.CodCptoMov, TFP.TipoFondo, 
                              TF.TipoInteres, TAI.tasainteres 
                         FROM DETALLE_POLIZA DP, FAI_CONCENTRADORA_FONDO FCF, FAI_TIPOS_FONDOS_PRODUCTOS TFP,
                              FAI_TIPOS_DE_FONDOS TF, FAI_TIPOS_DE_INTERES TI, FAI_TASAS_DE_INTERES TAI 
                        WHERE DP.IdTipoSeg      = cIdTipoSeg
                          AND DP.Cod_Asegurado  = X.CodAsegurado
                          AND FCF.IdPoliza      = DP.IdPoliza
                          AND FCF.IDetPol       = DP.IDetPol
                          AND FCF.CodAsegurado  = DP.Cod_Asegurado
                          AND FCF.CodCptoMov    = 'INTFON'
                          AND TFP.IdTipoSeg     = DP.IdTipoSeg
                          AND TFP.PlanCob       = DP.PlanCob
                          AND TF.CodCia         = TFP.CodCia
                          AND TF.CodEmpresa     = TFP.CodEmpresa
                          AND TF.TipoFondo      = TFP.TipoFondo
                          AND TI.TipoInteres    = TF.TipoInteres
                          AND TAI.TipoInteres   = TI.TipoInteres
                          AND TO_CHAR(TO_DATE(TAI.FecIniVig,'DD/MM/YYYY')) BETWEEN TO_CHAR(TO_DATE(dFecDesde,'DD/MM/YYYY')) AND TO_CHAR(TO_DATE(dFecHasta,'DD/MM/YYYY')) 
                      ) TAI3 ;
   
               nIntNetPagado := nInteresNominal + nISRRet;
		      
               IF nMtoAporteIniLocal != 0 THEN
				      nTasa                   := nInteresNominal / nMtoAporteIniLocal;
                  nMtoAporteIniLocal_Acum := nMtoAporteIniLocal_Acum + nMtoAporteIniLocal;
                  nInteresNominal_Acum		:= nInteresNominal_Acum + nInteresNominal;
                  nISRRet_Acum				:= nISRRet_Acum + nISRRet;
                  nIntNetPagado_Acum		:= nIntNetPagado_Acum + nIntNetPagado;
                  nInteresAcumulado_Acum	:= nIntNetPagado_Acum + nIntNetPagado;
            
				      cCadena  := '<Row>';
                  OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
                  nLinea   := nLinea + 1;
                  cCadena := cAbreCelda||cAbreContenidoString||cNombre_Impresion          ||cCierraContenido||cCierraCelda||
				                 cAbreCelda||cAbreContenidoString||X.Num_Doc_Identificacion   ||cCierraContenido||cCierraCelda||
                             cAbreCelda||cAbreContenidoNumber||nMtoAporteIniLocal         ||cCierraContenido||cCierraCelda||
				                 cAbreCelda||cAbreContenidoNumber||nTasa                      ||cCierraContenido||cCierraCelda||
				                 cAbreCelda||cAbreContenidoString||'1'                        ||cCierraContenido||cCierraCelda||
				                 cAbreCelda||cAbreContenidoNumber||nInteresNominal            ||cCierraContenido||cCierraCelda||
				                 cAbreCelda||cAbreContenidoNumber||nISRRet                    ||cCierraContenido||cCierraCelda||
				                 cAbreCelda||cAbreContenidoNumber||nIntNetPagado              ||cCierraContenido||cCierraCelda||
				                 cAbreCelda||cAbreContenidoNumber||nInteresAcumulado          ||cCierraContenido||cCierraCelda||
                             cAbreCelda||cAbreContenidoNumber||nTasa                      ||cCierraContenido||cCierraCelda||
                             cAbreCelda||cAbreContenidoString||X.FecMovimiento            ||cCierraContenido||cCierraCelda;
                  OC_ARCHIVO.Escribir_Linea(cCadena, USER, nLinea);
                  cCadena  := '</Row>';
                  OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
                  nLinea   := nLinea + 1;
               END IF;
            END IF;
         END LOOP;
      END IF;
   ELSIF cCodReporte = 'RETISRANUA' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||'Nombre del Cliente'                                 ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'RFC'                                                ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Monto Inversión') ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Tasa'                                               ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Plazo'                                              ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Interes Nominal'                                    ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'ISR Retenido'                                       ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Interes Neto Pagado'                                ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Interes Acumulado'                                  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Tasa Promedio'                                      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Fecha'                                              ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         FOR X IN C_ISRFONDOSMENS LOOP
            IF cFormato = 'EXCEL' THEN
               IF nSPV	 = 0 THEN
                  cNombre_Impresion := X.NombreCliente;
                  nSPV := 1;
               END IF;
	  	  
               IF cNombre_Impresion = X.NombreCliente THEN
                  nSPV := 1;
               ELSE
                  cNombre_Impresion := X.NombreCliente;	
                  nLinea := nLinea + 1;
                  cCadena  := '<Row>';
                  OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
                  nLinea   := nLinea + 1;
                  cCadena := cAbreCelda||cAbreContenidoString||'Sumas : '           ||cCierraContenido||cCierraCelda||
	                          cAbreCelda||cAbreContenidoString||' '                  ||cCierraContenido||cCierraCelda||
	                          cAbreCelda||cAbreContenidoNumber||nSaldoFinal          ||cCierraContenido||cCierraCelda||
	                          cAbreCelda||cAbreContenidoString||' '                  ||cCierraContenido||cCierraCelda||
	                          cAbreCelda||cAbreContenidoString||' '                  ||cCierraContenido||cCierraCelda||
	                          cAbreCelda||cAbreContenidoNumber||nInteresNominal_Acum ||cCierraContenido||cCierraCelda||
	                          cAbreCelda||cAbreContenidoNumber||nISRRet_Acum         ||cCierraContenido||cCierraCelda||
	                          cAbreCelda||cAbreContenidoNumber||nIntNetPagado_Acum   ||cCierraContenido||cCierraCelda||
	                          cAbreCelda||cAbreContenidoNumber||nInteresAcumulado    ||cCierraContenido||cCierraCelda||
									  cAbreCelda||cAbreContenidoString||' '                  ||cCierraContenido||cCierraCelda||
                             cAbreCelda||cAbreContenidoString||X.FecMovimiento      ||cCierraContenido||cCierraCelda;										         
                  OC_ARCHIVO.Escribir_Linea(cCadena, USER, nLinea);
                  nLinea   := nLinea + 1;
                  cCadena  := '</Row>';
                  OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
                  nLinea   := nLinea + 1;
                  
                  nMtoAporteIniLocal_Acum := 0;
                  nInteresNominal_Acum		:= 0;
                  nISRRet_Acum				:= 0;
                  nIntNetPagado_Acum		:= 0;
                  nInteresAcumulado_Acum	:= 0;						  	
               END IF;	
  	  
               --- SALDO INICIAL ---							       
		      	BEGIN
                  SELECT NVL(SUM(F.MontoMovMoneda),0)
                    INTO nMtoAporteIniLocal
                    FROM FAI_CONCENTRADORA_FONDO F
                   WHERE F.CodAsegurado          = X.CodAsegurado
                     AND TRUNC(F.FecMovimiento) <= X.FecMovimiento
                     AND F.StsMovimiento         = 'ACTIVO';
		      	END;
		
               BEGIN
                  SELECT NVL(SUM(F.MontoMovMoneda),0)
                    INTO nSaldoFinal
                    FROM FAI_CONCENTRADORA_FONDO F
                   WHERE F.CodAsegurado          = X.CodAsegurado
                     AND TRUNC(F.FecMovimiento) <= dFecHasta
                     AND F.StsMovimiento         = 'ACTIVO';
               END; 
      
               BEGIN
                  SELECT NVL(SUM(FCF.MontoMovMoneda),0) 
						  INTO nInteresNominal
						 FROM FAI_CONCENTRADORA_FONDO FCF
						WHERE FCF.FecMovimiento    = X.FecMovimiento 
                    AND FCF.CodAsegurado     = X.CodAsegurado
                    AND FCF.CodCptoMov       = 'INTFON'
                    AND FCF.StsMovimiento    = 'ACTIVO' ;
               EXCEPTION  WHEN OTHERS THEN
                  nInteresNominal := '0.00';
               END ; 		      
		       
               BEGIN
                  SELECT NVL(SUM(FCF.MontoMovMoneda),0) 
                    INTO nISRRet
                    FROM FAI_CONCENTRADORA_FONDO FCF
                   WHERE FCF.FecMovimiento   = X.FecMovimiento
                     AND FCF.CodAsegurado    = X.CodAsegurado						
                     AND FCF.CodCptoMov     IN('RETISR')
                     AND FCF.StsMovimiento   = 'ACTIVO' ;
               EXCEPTION  WHEN OTHERS THEN
                  nISRRet := '0.00';
               END ; 	
						
               BEGIN
                  SELECT NVL(SUM(FCF.MontoMovMoneda),0) 
                    INTO nInteresAcumulado
                    FROM FAI_CONCENTRADORA_FONDO FCF
                   WHERE FCF.FecMovimiento   BETWEEN TO_DATE(cFechaAcum,'DD/MM/YYYY') AND X.FecMovimiento -------ojo
                     AND FCF.CodAsegurado          = X.CodAsegurado						
                     AND FCF.CodCptoMov            = 'INTFON' 
                     AND FCF.StsMovimiento         = 'ACTIVO' ;
               EXCEPTION  WHEN OTHERS THEN
                  nInteresAcumulado := '0.00';
               END ; 		      		      

               SELECT AVG(TAI3.TasaInteres)
					  INTO nTasaPromedio
					  FROM (SELECT DISTINCT DP.IdPoliza, DP.IDetPol, DP.Cod_Asegurado, 
                              DP.PlanCob, FCF.CodCptoMov, TFP.TipoFondo, 
                              TF.TipoInteres, TAI.tasainteres 
                         FROM DETALLE_POLIZA DP, FAI_CONCENTRADORA_FONDO FCF, FAI_TIPOS_FONDOS_PRODUCTOS TFP,
                              FAI_TIPOS_DE_FONDOS TF, FAI_TIPOS_DE_INTERES TI, FAI_TASAS_DE_INTERES TAI 
                        WHERE DP.IdTipoSeg      = cIdTipoSeg
                          AND DP.Cod_Asegurado  = X.CodAsegurado
                          AND FCF.IdPoliza      = DP.IdPoliza
                          AND FCF.IDetPol       = DP.IDetPol
                          AND FCF.CodAsegurado  = DP.Cod_Asegurado
                          AND FCF.CodCptoMov    = 'INTFON'
                          AND TFP.IdTipoSeg     = DP.IdTipoSeg
                          AND TFP.PlanCob       = DP.PlanCob
                          AND TF.CodCia         = TFP.CodCia
                          AND TF.CodEmpresa     = TFP.CodEmpresa
                          AND TF.TipoFondo      = TFP.TipoFondo
                          AND TI.TipoInteres    = TF.TipoInteres
                          AND TAI.TipoInteres   = TI.TipoInteres
                          AND TO_CHAR(TO_DATE(TAI.FecIniVig,'DD/MM/YYYY')) BETWEEN TO_CHAR(TO_DATE(dFecDesde,'DD/MM/YYYY')) AND TO_CHAR(TO_DATE(dFecHasta,'DD/MM/YYYY')) 
                      ) TAI3 ;
   
               nIntNetPagado := nInteresNominal + nISRRet;
		      
               IF nMtoAporteIniLocal != 0 THEN
				      nTasa                   := nInteresNominal / nMtoAporteIniLocal;
                  nMtoAporteIniLocal_Acum := nMtoAporteIniLocal_Acum + nMtoAporteIniLocal;
                  nInteresNominal_Acum		:= nInteresNominal_Acum + nInteresNominal;
                  nISRRet_Acum				:= nISRRet_Acum + nISRRet;
                  nIntNetPagado_Acum		:= nIntNetPagado_Acum + nIntNetPagado;
                  nInteresAcumulado_Acum	:= nIntNetPagado_Acum + nIntNetPagado;
            
				      cCadena  := '<Row>';
                  OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
                  nLinea   := nLinea + 1;
                  cCadena := cAbreCelda||cAbreContenidoString||cNombre_Impresion          ||cCierraContenido||cCierraCelda||
				                 cAbreCelda||cAbreContenidoString||X.Num_Doc_Identificacion   ||cCierraContenido||cCierraCelda||
                             cAbreCelda||cAbreContenidoNumber||nMtoAporteIniLocal         ||cCierraContenido||cCierraCelda||
				                 cAbreCelda||cAbreContenidoNumber||nTasa                      ||cCierraContenido||cCierraCelda||
				                 cAbreCelda||cAbreContenidoString||'1'                        ||cCierraContenido||cCierraCelda||
				                 cAbreCelda||cAbreContenidoNumber||nInteresNominal            ||cCierraContenido||cCierraCelda||
				                 cAbreCelda||cAbreContenidoNumber||nISRRet                    ||cCierraContenido||cCierraCelda||
				                 cAbreCelda||cAbreContenidoNumber||nIntNetPagado              ||cCierraContenido||cCierraCelda||
				                 cAbreCelda||cAbreContenidoNumber||nInteresAcumulado          ||cCierraContenido||cCierraCelda||
                             cAbreCelda||cAbreContenidoNumber||nTasa                      ||cCierraContenido||cCierraCelda||
                             cAbreCelda||cAbreContenidoString||X.FecMovimiento            ||cCierraContenido||cCierraCelda;
                  OC_ARCHIVO.Escribir_Linea(cCadena, USER, nLinea);
                  cCadena  := '</Row>';
                  OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
                  nLinea   := nLinea + 1;
               END IF;
            END IF;
         END LOOP;
      END IF;
   END IF;
   IF cFormato = 'EXCEL' THEN   
      cCadena  := '</Table>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := '</Worksheet>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := '</Workbook>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      OC_ARCHIVO.ESCRIBIR_LINEA('EOF', cCodUser, 0);
      OC_ARCHIVO.ACTUALIZA_ARCHIVO(cCodUser, cFormato, cNombreArchivo);
   END IF;
   EXCEPTION
      WHEN OTHERS THEN
         OC_ARCHIVO.ELIMINAR_ARCHIVO(cCodUser);
END GENERA_REPORTE_PAGOISRFONDOS;   

PROCEDURE GENERA_REPORTE_COMERCIAL(nCodCia NUMBER, nCodEmpresa NUMBER, cModulo VARCHAR2, cOpcion VARCHAR2,
                                   cCodReporte VARCHAR2, cCodMoneda VARCHAR2, cIdTipoSeg VARCHAR2, nCodAgente NUMBER,
                                   dFecDesde DATE, dFecHasta DATE, cFormato VARCHAR2, cNombreArchivo VARCHAR2) IS
cAbreCelda           VARCHAR2(20) := '<Cell>';
cCierraCelda         VARCHAR2(20) := '</Cell>';
cAbreContenidoString VARCHAR2(40) := '<Data ss:Type="String">'; 
cAbreContenidoNumber VARCHAR2(40) := '<Data ss:Type="Number">';
cCierraContenido     VARCHAR2(20) := '</Data>';
cHeader              VARCHAR2(4000) := '<?xml version="1.0" encoding="UTF-8"?>'||chr(10)||
                                       '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'||chr(10)||
                                       '          xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                                       '          xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                                       '          xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'||chr(10)||
                                       '          xmlns:html="http://www.w3.org/TR/REC-html40">'||chr(10);
cPropiedades         VARCHAR2(4000) := '    <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'||chr(10)||
                                       '        <Author>Oracle</Author>'||chr(10)||
                                       '        <LastAuthor>Oracle</LastAuthor>'||chr(10)||
                                       '        <Created>2024-10-29T00:00:00Z</Created>'||chr(10)||
                                       '        <Version>16.00</Version>'||chr(10)||
                                       '    </DocumentProperties>'||chr(10);
cEstilos             VARCHAR2(4000) := '    <Styles>'||chr(10)||
                                       '        <Style ss:ID="Default" ss:Name="Normal">'||chr(10)||
                                       '            <Alignment ss:Vertical="Bottom"/>'||chr(10)||
                                       '            <Borders/>'||chr(10)||
                                       '            <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'||chr(10)||
                                       '            <Interior/>'||chr(10)||
                                       '            <NumberFormat/>'||chr(10)||
                                       '            <Protection/>'||chr(10)||
                                       '        </Style>'||chr(10)||
                                       '    </Styles>'||chr(10);     
nLinea               NUMBER;
cCodUser             VARCHAR2(30);
cCadena              VARCHAR2(32000);    
----
cTipoVigencia        VARCHAR2(20);
cIdTipoSegRep        DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCobRep          DETALLE_POLIZA.PlanCob%TYPE;
cDescTipoSeg         TIPOS_DE_SEGUROS.Descripcion%TYPE;
cDescPlanCob         PLAN_COBERTURAS.Desc_Plan%TYPE;
nIdPoliza            POLIZAS.IdPoliza%TYPE;
nCodAgenteN1         AGENTES_DISTRIBUCION_POLIZA.Cod_Agente_Distr%TYPE;
nCodAgenteN2         AGENTES_DISTRIBUCION_POLIZA.Cod_Agente_Distr%TYPE;
nCodAgenteN3         AGENTES_DISTRIBUCION_POLIZA.Cod_Agente_Distr%TYPE;
nPorcComisN1         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Distribuida%TYPE;
nPorcComisN2         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Distribuida%TYPE;
nPorcComisN3         AGENTES_DISTRIBUCION_POLIZA.Porc_Com_Distribuida%TYPE;
nComisAgteN1         COMISIONES.Comision_Moneda%TYPE;
nComisAgteN2         COMISIONES.Comision_Moneda%TYPE;
nComisAgteN3         COMISIONES.Comision_Moneda%TYPE;
nPrimaNeta           DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nReducPrima          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nRecargos            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nDerechos            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nImpuesto            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nPrimaTotal          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cNomAgenteN1         VARCHAR2(300);
cNomAgenteN2         VARCHAR2(300);
cNomAgenteN3         VARCHAR2(300);

nAgente_Promotor     AGENTES.Cod_Agente_Jefe%TYPE;      
cNombre_Promotor     VARCHAR2(300); 	
cCodNivel_Promotor   AGENTES.CodNivel%TYPE;     
cNivel_Promotor      VARCHAR2(100);

nDr_Codigo           AGENTES.Cod_Agente_Jefe%TYPE;   
cDr_Nombre           VARCHAR2(300);	 
cDr_CodNivel         AGENTES.CodNivel%TYPE;  
cDR_Nivel            VARCHAR2(100); 

dFecVencimiento      AGENTES_CEDULA_AUTORIZADA.FecVencimiento%TYPE;
cTipoCedula          AGENTES_CEDULA_AUTORIZADA.TipoCedula%TYPE;
cNumCedula           AGENTES_CEDULA_AUTORIZADA.NumCedula%TYPE;
dFecVencPolRc        AGENTES_CEDULA_AUTORIZADA.FecVencPolRc%TYPE;
cNumPolRc            AGENTES_CEDULA_AUTORIZADA.NumPolRc%TYPE;
cNomAsegPolRc        AGENTES_CEDULA_AUTORIZADA.NomAsegPolRc%TYPE;
cCodFormaPago        MEDIOS_DE_PAGO.CodFormaPago%TYPE;
cCodEntidadFinan     MEDIOS_DE_PAGO.CodEntidadFinan%TYPE;
cNumCuentaBancaria   MEDIOS_DE_PAGO.NumCuentaBancaria%TYPE;
cNumCuentaClabe      MEDIOS_DE_PAGO.NumCuentaClabe%TYPE;
cNombreEntidad       VARCHAR2(300);
cDescFormaPago       VALORES_DE_LISTAS.DescValLst%TYPE;

CURSOR REN_Q IS 
   SELECT P.IdPoliza, P.NumPolUnico, P.NumPolRef, P.FecRenovacion,
          OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) Contratante, 
          P.CodCliente, P.FecIniVig, P.FecFinVig, P.NumRenov,
          P.CodCia, P.CodEmpresa, P.StsPoliza, P.Cod_Moneda
     FROM POLIZAS P
    WHERE P.CodCia             = nCodCia
      AND P.StsPoliza          = 'EMI'
      AND P.FecRenovacion     >= dFecDesde
      AND P.FecRenovacion     <= dFecHasta
      AND P.Cod_Moneda         = NVL(cCodMoneda,P.Cod_Moneda)
      /*((P.Cod_Moneda       = cCodMoneda AND cCodMoneda != '%')
       OR  (P.Cod_Moneda    LIKE cCodMoneda AND cCodMoneda = '%'))*/
      AND EXISTS (SELECT 'S'
                    FROM DETALLE_POLIZA D, AGENTES_DISTRIBUCION_COMISION A
                   WHERE A.Cod_Agente_Distr  = NVL(nCodAgente,A.Cod_Agente_Distr)
                     /*((A.Cod_Agente_Distr    = nCodAgente AND nCodAgente != '%')
                      OR  (A.Cod_Agente_Distr LIKE nCodAgente AND nCodAgente = '%'))*/
                     AND A.IDetPol               = D.IDetPol
                     AND A.IdPoliza              = D.IdPoliza
                     AND A.CodCia                = D.CodCia
                     AND D.IdTipoSeg             = NVL(D.IdTipoSeg,cIdTipoSeg)
                     /*((D.IdTipoSeg           = cIdTipoSeg AND cIdTipoSeg != '%')
                      OR  (D.IdTipoSeg        LIKE cIdTipoSeg AND cIdTipoSeg = '%'))*/
                     AND D.IdPoliza              = P.IdPoliza
                     AND D.CodCia                = P.CodCia)
    ORDER BY P.IdPoliza;

CURSOR DET_Q IS
   SELECT D.CodCpto, D.Monto_Det_Moneda, D.IndCptoPrima, C.IndCptoServicio
     FROM DETALLE_FACTURAS D, FACTURAS F, CATALOGO_DE_CONCEPTOS C
    WHERE C.CodConcepto = D.CodCpto
      AND C.CodCia      = F.CodCia
      AND D.IdFactura   = F.IdFactura
      AND F.StsFact    != 'ANU'
      AND F.IdPoliza    = nIdPoliza
      AND F.CodCia      = nCodCia;

CURSOR DET_COMIS_Q IS
   SELECT AD.Cod_Agente_Distr, AD.CodNivel, AD.Porc_Com_Distribuida, SUM(CO.Comision_Moneda) TotalComision
     FROM COMISIONES CO, FACTURAS F, AGENTES_DISTRIBUCION_POLIZA AD, AGENTES AG
    WHERE AG.CodCia           = AD.CodCia
      AND AG.Cod_Agente       = AD.Cod_Agente_Distr
      AND AD.CodCia           = F.CodCia
      AND AD.IdPoliza         = F.IdPoliza
      AND AD.Cod_Agente_Distr = CO.Cod_Agente
      AND CO.IdFactura        = F.IdFactura
      AND CO.IdPoliza         = F.IdPoliza
      AND F.CodCia            = nCodCia
      AND F.IdPoliza          = nIdPoliza
      AND F.IdEndoso          = 0
    GROUP BY AD.Cod_Agente_Distr, AD.CodNivel, AD.Porc_Com_Distribuida
    ORDER BY AD.CodNivel;
    
CURSOR Q_CARTERA IS
	SELECT CodCia, Codempresa, Consecutivo, Poliza, Agrupador, Ramo,
          Contratante, Inicio_Vig, Fin_Vig, Plan_Pago, Num_Subgrupos,
          Status, Fecha_Status, Prima_Neta, Derecho_Poliza, Recargo,
          Iva, Prima_Total, Prima_Base, Monto_Pagado, Codigo_Agente,
          Nombre_Agente, Porcentaje_Agente, Cantidad_Agente, Codigo_Promotor, Nombre_Promotor,
          Porcentaje_Promotor, Cantidad_Promotor, Codigo_Direccion, Nombre_Direccion, Porcentaje_Direccion,
          Cantidad_Direccion
	  FROM VW_REPCARTERA
	 WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa;  
      
CURSOR Q_360 IS
   SELECT Recibo, Poliza, Nombre_Contratante, Periodicidad_Pago, 
          Origen_Recibo, Subgrupo, Endoso, Vencimiento, Dias_De_Vencido, 
          Antiguedad, Prima_Neta, Prima_Total, Id_Agente, Nombre_Agente, 
          Comision_Porc_Ag, Comision_Ag, Id_Promotor, Nombre_Promotor, Comision_Porc_Pro, 
          Comision_Pro, Id_Dirreg, Nombre_Direccion, Comision_Porc_Dr, Comision_Dr, 
          Status, Ramo, Si_Siniestro, Monto_Reserva_Pendiente, Monto_Pagado, 
          Fecha_Reporte, Fec_Paramfin_Rep
     FROM VW_REPORTE360 T
    WHERE T.Fecha_Reporte = TRUNC(SYSDATE);      
    
CURSOR AGT_Q IS 
   SELECT A.Cod_Agente, OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(A.Tipo_Doc_Identificacion, A.Num_Doc_Identificacion) Nombre_Agente,
          A.Est_Agente, A.Tipo_Agente, A.CanalComisVenta, A.CodTipo, 
          A.CodNivel CodNivel, OC_NIVEL.DESCRIPCION_NIVEL(A.CodCia, A.CodNivel) Nivel_Agente,
          P.Email, TRIM(P.DirecRes)||' '||TRIM(NumExterior)||' ' ||DECODE(NumInterior, NULL, NULL, 'Interior') ||' '||TRIM(NumInterior)||' '
                 || TRIM (OC_COLONIA.DESCRIPCION_COLONIA(P.CodPaisRes, P.CodProvRes, P.CodDistRes, P.CodCorrres, P.CodPosRes, CodColRes))
                 ||', '||TRIM(OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes))
                 ||', '||TRIM(OC_CORREGIMIENTO.NOMBRE_CORREGIMIENTO(P.CodPaisRes, P.CodProvRes, P.CodDistRes, P.CodCorrRes)) 
                 ||', CP '|| TRIM(P.CodPosRes) Direccion, P.TelRes, A.CodCia, A.Tipo_Doc_Identificacion, A.Num_Doc_Identificacion,
          OC_AGENTES.EJECUTIVO_COMERCIAL(A.CodCia, A.Cod_Agente) CodEjecutivo,
          OC_EJECUTIVO_COMERCIAL.NOMBRE_EJECUTIVO(A.CodCia, OC_AGENTES.EJECUTIVO_COMERCIAL(A.CodCia, A.Cod_Agente)) NombreEjecutivo,
          A.IdFormaPago,
          TO_CHAR(B.COD_AGENTE)                              Agente_Promotor,
          OC_AGENTES.NOMBRE_AGENTE(B.CodCia, B.COD_AGENTE)   Nombre_Promotor,
          B.CodNivel                                         CodNivel_Promotor,
          OC_NIVEL.DESCRIPCION_NIVEL(A.CodCia, A.CodNivel)   Nivel_Promotor,
          TO_CHAR(C.COD_AGENTE)                              Dr_Codigo,
          OC_AGENTES.NOMBRE_AGENTE(C.CodCia, C.COD_AGENTE)   Dr_Nombre ,
          C.CodNivel                                         Dr_CodNivel,
          OC_NIVEL.DESCRIPCION_NIVEL(A.CodCia, A.CodNivel)   DR_Nivel
         , P.FECINGRESO Fecha_de_Ingreso
     FROM AGENTES A, PERSONA_NATURAL_JURIDICA P,
          AGENTES B, AGENTES C
    WHERE P.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
      AND P.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
      AND B.COD_AGENTE (+)= A.COD_AGENTE_JEFE
      AND C.COD_AGENTE (+)= B.COD_AGENTE_JEFE   
    ORDER BY 1;    

BEGIN 
   cCodUser := COALESCE(SYS_CONTEXT('APEX$SESSION','APP_USER'),USER); 
   IF cFormato = 'EXCEL' THEN
      nLinea   := 1;
      cCadena  := OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia);
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := cHeader;
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      
      -- Propiedades del documento
      cCadena  := cPropiedades; 
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
   
       -- Define estilos (opcional, pero reduce errores)
      cCadena  := cEstilos;
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := '    <Worksheet ss:Name="'||cNombreArchivo||'">'||chr(10)||
                  '<Table>'||chr(10)||
                  '<Row>'||chr(10);
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
   END IF;
   ---- AQUI VAN LOS REPORTES ----
   
   IF cCodReporte = 'POLXREN' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('No. de Póliza')               ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Consecutivo'                                                    ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'No. Referencia'                                                 ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Contratante'                                                    ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Inicio Vigencia'                                                ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Fin Vigencia'                                                   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Fecha de Renovación')         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('No. Renovación')              ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Tipo Vigencia'                                                  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Estado'                                                         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Moneda'                                                         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Tipo Seguro'                                                    ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Descripción Tipo Seguro')     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Plan Coberturas'                                                ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Descripción Plan Coberturas') ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Prima Neta'                                                     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Reducción de Prima')          ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Recargos'                                                       ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Derechos'                                                       ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Impuesto'                                                       ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Prima Total'                                                    ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Agente')               ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre del Agente'                                              ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('% Comisión Agente')           ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Monto Comisión Agente')       ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código del Promotor')         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre del Promotor'                                            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('% Comisión Promotor')         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Monto Comisión Promotor')     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Dirección Regional')   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Nombre Dirección Regional')   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('% Comisión DR')               ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Monto Comisión DR')           ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      END IF;
      FOR X IN REN_Q LOOP
         nIdPoliza   := X.IdPoliza;
         --nCodCia     := X.CodCia;
         BEGIN
            SELECT NVL(cIdTipoSeg,MIN(IdTipoSeg)), MIN(PlanCob)
              INTO cIdTipoSegRep, cPlanCobRep
              FROM DETALLE_POLIZA
             WHERE IdPoliza  = X.IdPoliza
               AND CodCia    = X.CodCia;
         END;
         
         cDescTipoSeg := OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(nCodCia, nCodEmpresa, cIdTipoSegRep);
         cDescPlanCob := OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(nCodCia, nCodEmpresa, cIdTipoSegRep, cPlanCobRep);

         IF X.NumRenov = 0 THEN
            cTipoVigencia := '1ER. AÑO';
         ELSE
            cTipoVigencia := 'RENOVACION';
         END IF;

         nCodAgenteN1   := NULL;
         nCodAgenteN2   := NULL;
         nCodAgenteN3   := NULL;
         cNomAgenteN1   := NULL;
         cNomAgenteN2   := NULL;
         cNomAgenteN3   := NULL;
         nPorcComisN1   := 0;
         nComisAgteN1   := 0;
         nPorcComisN2   := 0;
         nComisAgteN2   := 0;
         nPorcComisN3   := 0;
         nComisAgteN3   := 0;
         
         FOR C IN DET_COMIS_Q LOOP
            IF C.CodNivel = 1 THEN
               nCodAgenteN1    := C.Cod_Agente_Distr;
               cNomAgenteN1    := OC_AGENTES.NOMBRE_AGENTE(X.CodCia, C.Cod_Agente_Distr);
               nPorcComisN1    := NVL(C.Porc_Com_Distribuida,0);
               nComisAgteN1    := NVL(nComisAgteN1,0) + NVL(C.TotalComision,0);
            ELSIF C.CodNivel = 2 THEN
               nCodAgenteN2    := C.Cod_Agente_Distr;
               cNomAgenteN2    := OC_AGENTES.NOMBRE_AGENTE(X.CodCia, C.Cod_Agente_Distr);
               nPorcComisN2    := NVL(C.Porc_Com_Distribuida,0);
               nComisAgteN2    := NVL(nComisAgteN2,0) + NVL(C.TotalComision,0);
            ELSIF C.CodNivel = 3 THEN
               nCodAgenteN3    := C.Cod_Agente_Distr;
               cNomAgenteN3    := OC_AGENTES.NOMBRE_AGENTE(X.CodCia, C.Cod_Agente_Distr);
               nPorcComisN3    := NVL(C.Porc_Com_Distribuida,0);
               nComisAgteN3    := NVL(nComisAgteN3,0) + NVL(C.TotalComision,0);
            ELSE
               nCodAgenteN1    := C.Cod_Agente_Distr;
               cNomAgenteN1    := OC_AGENTES.NOMBRE_AGENTE(X.CodCia, C.Cod_Agente_Distr);
               nPorcComisN1    := NVL(C.Porc_Com_Distribuida,0);
               nComisAgteN1    := NVL(nComisAgteN1,0) + NVL(C.TotalComision,0);
            END IF;
         END LOOP;
         
         nPrimaNeta      := 0;
         nReducPrima     := 0;
         nRecargos       := 0;
         nDerechos       := 0;
         nImpuesto       := 0;
         nPrimaTotal     := 0;
         
         FOR W IN DET_Q LOOP
            IF W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S' THEN
               nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(W.Monto_Det_Moneda,0);
            ELSIF W.CodCpto = 'RECFIN' THEN
               nRecargos   := NVL(nRecargos,0) + NVL(W.Monto_Det_Moneda,0);
            ELSIF W.CodCpto = 'DEREMI' THEN
               nDerechos   := NVL(nDerechos,0) + NVL(W.Monto_Det_Moneda,0);
            ELSIF W.CodCpto = 'IVASIN' THEN
               nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
            ELSE
               nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
            END IF;
            nPrimaTotal  := NVL(nPrimaTotal,0) + NVL(W.Monto_Det_Moneda,0);
         END LOOP;
         
         IF cFormato = 'EXCEL' THEN
            nLinea := nLinea + 1;
            cCadena  := '<Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            
            cCadena := cAbreCelda||cAbreContenidoString||X.NumPolUnico                                            ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.IdPoliza                                               ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.NumPolRef                                              ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(X.Contratante)         ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.FecIniVig                                              ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.FecFinVig                                              ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.FecRenovacion                                          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.NumRenov                                               ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cTipoVigencia)         ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.StsPoliza                                              ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Cod_Moneda                                             ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||cIdTipoSegRep                                            ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cDescTipoSeg)          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||cPlanCobRep                                              ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cDescPlanCob)         ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||nPrimaNeta                                               ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||nReducPrima                                              ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||nRecargos                                                ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||nDerechos                                                ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||nImpuesto                                                ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||nPrimaTotal                                              ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||nCodAgenteN3                                             ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomAgenteN3)          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||nPorcComisN3                                             ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||nComisAgteN3                                             ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||nCodAgenteN2                                             ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomAgenteN2)          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||nPorcComisN2                                             ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||nComisAgteN2                                             ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||nCodAgenteN1                                             ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomAgenteN1)          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||nPorcComisN1                                             ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||nComisAgteN1                                             ||cCierraContenido||cCierraCelda;
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena  := '</Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
         END IF;
      END LOOP;
   ELSIF cCodReporte = 'CARTERA' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('No. de Póliza')            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Consecutivo'                                                 ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Agrupador'                                                   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Ramo'                                                        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Contratante'                                                 ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Inicio de Vigencia'                                          ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Fin Vigencia'                                                ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Plan de Pago'                                                ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'No. de Sub Grupos'                                           ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Estatus Póliza')           ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Fecha de Estatus'                                            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Prima Neta'                                                  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Derechos'                                                    ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Recargos'                                                    ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'IVA'                                                         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Prima Total'                                                 ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Prima Base'                                                  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Prima Pagada'                                                ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Agente')            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Nombre Agente')            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('% Comisión Agente')        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Monto Comisión Agente')    ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código del Promotor')      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Nombre Promotor')          ||cCierraContenido||cCierraCelda||                     
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('% Comisión Promotor')      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Monto Comisión Promotor')  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Dirección Regional')||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Nombre Dirección Regional')||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('% Comisión DR')            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Monto Comisión DR')        ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      END IF;
      FOR Z IN Q_CARTERA LOOP
         IF cFormato = 'EXCEL' THEN
            nLinea := nLinea + 1;
            cCadena  := '<Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena := cAbreCelda||cAbreContenidoString||Z.Poliza                                                                   ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||Z.Consecutivo                                                              ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||Z.Agrupador                                                                ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||Z.Ramo                                                                     ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||Z.Contratante                                                              ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||Z.Inicio_Vig                                                               ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||Z.Fin_Vig                                                                  ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||Z.Plan_Pago                                                                ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||Z.Num_Subgrupos                                                            ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||Z.Status                                                                   ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||Z.Fecha_Status                                                             ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||Z.Prima_Neta                                                               ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||Z.Derecho_Poliza                                                           ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||Z.Recargo                                                                  ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||Z.Iva                                                                      ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||Z.Prima_Total                                                              ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||Z.Prima_Base                                                               ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||Z.Monto_Pagado                                                             ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||Z.Codigo_Agente                                                            ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||Z.Nombre_Agente                                                            ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||Z.Porcentaje_Agente                                                        ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||Z.Cantidad_Agente                                                          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||Z.Codigo_Promotor                                                          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||Z.Nombre_Promotor                                                          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||Z.Porcentaje_Promotor                                                      ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||Z.Cantidad_Promotor                                                        ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||Z.Codigo_Direccion                                                         ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||Z.Nombre_Direccion                                                         ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||Z.Porcentaje_Direccion                                                     ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||Z.Cantidad_Direccion                                                       ||cCierraContenido||cCierraCelda;
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena  := '</Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
         END IF;
      END LOOP;
   ELSIF cCodReporte = 'RECIBOS360' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||'No. de Recibo'                                                  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('No. de Póliza')               ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre de Contratante'                                          ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Periodicidad de Pago'                                           ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Origen de Recibo'                                               ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Sub Grupo'                                                      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Endoso'                                                         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Fecha de Vencimiento de Recibo'                                 ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('No. Días Vencido')            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Antiguedad Recibo'                                              ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Prima Neta'                                                     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Prima Total'                                                    ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Agente')               ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Nombre Agente')               ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('% Comisión Agente')           ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Monto Comisión Agente')       ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código del Promotor')         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Nombre Promotor')             ||cCierraContenido||cCierraCelda||                     
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('% Comisión Promotor')         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Monto Comisión Promotor')     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Dirección Regional')   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Nombre Dirección Regional')   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('% Comisión DR')               ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Monto Comisión DR')           ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Estatus Recibo'                                                 ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Ramo'                                                           ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Indicador Siniestro'                                            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Monto Reserva Pendiente'                                        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Monto Pagado'                                                   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Fecha Generación Reporte')    ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Fecha Fin Parámetro Reporte') ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      END IF;
      FOR J IN Q_360 LOOP
         IF cFormato = 'EXCEL' THEN
            nLinea := nLinea + 1;
            cCadena  := '<Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena := cAbreCelda||cAbreContenidoNumber||NVL(J.Recibo,0)                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Poliza,'0')                                  ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||NVL(J.Nombre_Contratante,'X')                      ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||NVL(J.Periodicidad_Pago,'X')                       ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||NVL(J.Origen_Recibo,'X')                           ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Subgrupo,1)                                  ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Endoso,0)                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||NVL(J.Vencimiento,TRUNC(SYSDATE))                  ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Dias_De_Vencido,0)                           ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||NVL(J.Antiguedad,'X')                              ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Prima_Neta,0)                                ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Prima_Total,0)                               ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Id_Agente,0)                                 ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||NVL(J.Nombre_Agente,'X')                           ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Comision_Porc_Ag,0)                          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Comision_Ag,0)                               ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Id_Promotor,0)                               ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||NVL(J.Nombre_Promotor,'X')                         ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Comision_Porc_Pro,0)                         ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Comision_Pro,0)                              ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Id_Dirreg,0)                                 ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||NVL(J.Nombre_Direccion,' ')                        ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Comision_Porc_Dr,0)                          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Comision_Dr,0)                               ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||NVL(J.Status,'X')                                  ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||NVL(J.Ramo,'X')                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||NVL(J.Si_Siniestro,'X')                            ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Monto_Reserva_Pendiente,0)                   ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Monto_Pagado,0)                              ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||NVL(J.Fecha_Reporte,TRUNC(SYSDATE))                ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||NVL(J.Fec_Paramfin_Rep,TRUNC(SYSDATE))             ||cCierraContenido||cCierraCelda;
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena  := '</Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
         END IF;
      END LOOP;
   ELSIF cCodReporte = 'FZAVENTAS' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código de Agente')                     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre Agente'                                                           ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Nivel Jerárquico Agente')              ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Descripción Nivel Jerárquico Agente')  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Status'                                                                  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Endoso'                                                                  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Clase de Agente'                                                         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Canal de Venta'                                                          ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Clave de Promotor'                                                       ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre Promotor'                                                         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Nivel Jerárquico Promotor')            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Clave D.R')                            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Nombre  D.R')                          ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Nivel Jerárquico D.R')                 ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Descripción Nivel Jerárquico D.R')     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Tipo Doc. Identificación')             ||cCierraContenido||cCierraCelda||                     
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('No. Doc. Identificación')              ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Monto Comisión Promotor')              ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Tipo de Cédula')                       ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('No. de Cédula')                        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Vencimiento de Cédula')                ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('No. Póliza RC')                        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Aseguradora Póliza RC')                ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Vencimiento de Póliza RC')             ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Ejecutivo Comercial')           ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre Ejecutivo Comercial'                                              ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Fecha de Ingreso Agente'                                                 ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      END IF;
      nAgente_Promotor   := NULL;
      cNombre_Promotor   := NULL;
      cCodNivel_Promotor := NULL;
      cNivel_Promotor    := NULL;
      nDr_Codigo         := NULL;
      cDr_Nombre         := NULL;
      cDr_CodNivel       := NULL;
      cDR_Nivel          := NULL;	
      FOR X IN AGT_Q LOOP
         IF cFormato = 'EXCEL' THEN
            BEGIN
               SELECT TipoCedula, NumCedula, FecVencimiento
                 INTO cTipoCedula, cNumCedula, dFecVencimiento
                 FROM AGENTES_CEDULA_AUTORIZADA
                WHERE CodCia          = X.CodCia
                  AND Cod_Agente      = X.Cod_Agente
                  AND FecVencimiento IN (SELECT MAX(FecVencimiento)
                                           FROM AGENTES_CEDULA_AUTORIZADA
                                          WHERE CodCia     = X.CodCia
                                            AND Cod_Agente = X.Cod_Agente);
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cTipoCedula     := NULL;
                  cNumCedula      := NULL;
                  dFecVencimiento := NULL;
            END;

            BEGIN
               SELECT NumPolRc, NomAsegPolRc, FecVencPolRc
                 INTO cNumPolRc, cNomAsegPolRc, dFecVencPolRc
                 FROM AGENTES_CEDULA_AUTORIZADA
                WHERE CodCia        = X.CodCia
                  AND Cod_Agente    = X.Cod_Agente
                  AND FecVencPolRc IN (SELECT MAX(FecVencPolRc)
                                         FROM AGENTES_CEDULA_AUTORIZADA
                                        WHERE CodCia     = X.CodCia
                                          AND Cod_Agente = X.Cod_Agente);
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cNumPolRc     := NULL;
                  cNomAsegPolRc := NULL;
                  dFecVencPolRc := NULL;
            END;

            BEGIN
               SELECT M.CodFormaPago, M.CodEntidadFinan, M.NumCuentaBancaria, M.NumCuentaClabe,
                      OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(E.Tipo_Doc_Identificacion, E.Num_Doc_Identificacion) NombreEntidad,
                      OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMPAGO', M.CodFormaPago) DescFormaPago
                 INTO cCodFormaPago, cCodEntidadFinan, cNumCuentaBancaria, cNumCuentaClabe,
                      cNombreEntidad, cDescFormaPago
                 FROM MEDIOS_DE_PAGO M, ENTIDAD_FINANCIERA E
                WHERE E.CodEntidad(+)           = M.CodEntidadFinan
                  AND M.Tipo_Doc_Identificacion = X.Tipo_Doc_Identificacion
                  AND M.Num_Doc_Identificacion  = X.Num_Doc_Identificacion
                  AND M.IdFormaPago             = X.IdFormaPago;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cCodFormaPago      := NULL;
                  cCodEntidadFinan   := NULL;
                  cNumCuentaBancaria := NULL;
                  cNumCuentaClabe    := NULL;
                  cNombreEntidad     := NULL;
                  cDescFormaPago     := NULL;
            END;
      
            IF X.CodNivel_Promotor IN (1,3,4,5) THEN
               nDr_Codigo   := X.Agente_Promotor;		 	  
               cDr_Nombre   := X.Nombre_Promotor;	 
               cDr_CodNivel := X.CodNivel_Promotor;		 	  
               cDR_Nivel    := X.Nivel_Promotor;
            ELSIF  X.CodNivel_Promotor = 2 THEN
               nAgente_Promotor   := X.Agente_Promotor;		 	  	 	   
               cNombre_Promotor   := X.Nombre_Promotor;		 	   	 
               cCodNivel_Promotor := X.CodNivel_Promotor;		 	  	 
               cNivel_Promotor    := X.Nivel_Promotor;
               nDr_Codigo         := X.Dr_Codigo;		 	
               cDr_Nombre         := X.Dr_Nombre;		 	 
               cDr_CodNivel       := X.Dr_CodNivel;		 
               cDR_Nivel          := X.DR_Nivel;
            END IF;   
            
            nLinea := nLinea + 1;
            cCadena  := '<Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            
            cCadena := cAbreCelda||cAbreContenidoNumber||X.Cod_Agente                                             ||cCierraContenido||cCierraCelda||  
					        cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(X.Nombre_Agente)       ||cCierraContenido||cCierraCelda||     
					        cAbreCelda||cAbreContenidoString||X.CodNivel                                               ||cCierraContenido||cCierraCelda||                             
					        cAbreCelda||cAbreContenidoString||X.Nivel_Agente                                           ||cCierraContenido||cCierraCelda||			                   
		                 cAbreCelda||cAbreContenidoString||X.Est_Agente                                             ||cCierraContenido||cCierraCelda||                           
					        cAbreCelda||cAbreContenidoString||X.Tipo_Agente                                            ||cCierraContenido||cCierraCelda||                          
					        cAbreCelda||cAbreContenidoString||X.CanalComisVenta                                        ||cCierraContenido||cCierraCelda||			                 
					        cAbreCelda||cAbreContenidoString||nAgente_Promotor                                         ||cCierraContenido||cCierraCelda||                           
					        cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNombre_Promotor)      ||cCierraContenido||cCierraCelda||                    
					        cAbreCelda||cAbreContenidoString||cCodNivel_Promotor                                       ||cCierraContenido||cCierraCelda||                  
					        cAbreCelda||cAbreContenidoString||nDr_Codigo                                               ||cCierraContenido||cCierraCelda||                             
					        cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cDr_Nombre)            ||cCierraContenido||cCierraCelda||                             
					        cAbreCelda||cAbreContenidoString||cDr_CodNivel                                             ||cCierraContenido||cCierraCelda||                           
					        cAbreCelda||cAbreContenidoString||cDR_Nivel                                                ||cCierraContenido||cCierraCelda||                              
				           cAbreCelda||cAbreContenidoString||X.Tipo_Doc_Identificacion                                ||cCierraContenido||cCierraCelda||              
				           cAbreCelda||cAbreContenidoString||X.Num_Doc_Identificacion                                 ||cCierraContenido||cCierraCelda||               
				           cAbreCelda||cAbreContenidoString||cTipoCedula                                              ||cCierraContenido||cCierraCelda||                            
				           cAbreCelda||cAbreContenidoString||cNumCedula                                               ||cCierraContenido||cCierraCelda||                             
				           cAbreCelda||cAbreContenidoString||dFecVencimiento                                          ||cCierraContenido||cCierraCelda||                        
				           cAbreCelda||cAbreContenidoString||cNumPolRc                                                ||cCierraContenido||cCierraCelda||                              
				           cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomAsegPolRc)         ||cCierraContenido||cCierraCelda||                          
				           cAbreCelda||cAbreContenidoString||dFecVencPolRc                                            ||cCierraContenido||cCierraCelda||                          
				           cAbreCelda||cAbreContenidoNumber||X.CodEjecutivo                                           ||cCierraContenido||cCierraCelda||   
				           cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(X.NombreEjecutivo)     ||cCierraContenido||cCierraCelda||
				           cAbreCelda||cAbreContenidoString||X.Fecha_de_Ingreso                                       ||cCierraContenido||cCierraCelda; 
            
            ----
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena  := '</Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
         END IF;
      END LOOP;
   END IF;
   -------------------------------
   IF cFormato = 'EXCEL' THEN   
      cCadena  := '</Table>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := '</Worksheet>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := '</Workbook>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      OC_ARCHIVO.ESCRIBIR_LINEA('EOF', cCodUser, 0);
      OC_ARCHIVO.ACTUALIZA_ARCHIVO(cCodUser, cFormato, cNombreArchivo);
   END IF;
   EXCEPTION
      WHEN OTHERS THEN
         OC_ARCHIVO.ELIMINAR_ARCHIVO(cCodUser);
   
END GENERA_REPORTE_COMERCIAL; 

PROCEDURE GENERA_RESICO(nCodCia NUMBER, nCodEmpresa NUMBER, cModulo VARCHAR2, cOpcion VARCHAR2,
                        cCodReporte VARCHAR2, nIdRegFisSat NUMBER, cFormato VARCHAR2, cNombreArchivo VARCHAR2) IS
cAbreCelda           VARCHAR2(20) := '<Cell>';
cCierraCelda         VARCHAR2(20) := '</Cell>';
cAbreContenidoString VARCHAR2(40) := '<Data ss:Type="String">'; 
cAbreContenidoNumber VARCHAR2(40) := '<Data ss:Type="Number">';
cCierraContenido     VARCHAR2(20) := '</Data>';
cHeader              VARCHAR2(4000) := '<?xml version="1.0" encoding="UTF-8"?>'||chr(10)||
                                       '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'||chr(10)||
                                       '          xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                                       '          xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                                       '          xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'||chr(10)||
                                       '          xmlns:html="http://www.w3.org/TR/REC-html40">'||chr(10);
cPropiedades         VARCHAR2(4000) := '    <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'||chr(10)||
                                       '        <Author>Oracle</Author>'||chr(10)||
                                       '        <LastAuthor>Oracle</LastAuthor>'||chr(10)||
                                       '        <Created>2024-10-29T00:00:00Z</Created>'||chr(10)||
                                       '        <Version>16.00</Version>'||chr(10)||
                                       '    </DocumentProperties>'||chr(10);
cEstilos             VARCHAR2(4000) := '    <Styles>'||chr(10)||
                                       '        <Style ss:ID="Default" ss:Name="Normal">'||chr(10)||
                                       '            <Alignment ss:Vertical="Bottom"/>'||chr(10)||
                                       '            <Borders/>'||chr(10)||
                                       '            <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'||chr(10)||
                                       '            <Interior/>'||chr(10)||
                                       '            <NumberFormat/>'||chr(10)||
                                       '            <Protection/>'||chr(10)||
                                       '        </Style>'||chr(10)||
                                       '    </Styles>'||chr(10);     
nLinea               NUMBER;
cCodUser             VARCHAR2(30);
cCadena              VARCHAR2(32000);    
----
CURSOR cAgentes is
   SELECT A.Cod_Agente Agente, OC_AGENTES.NOMBRE_AGENTE(A.CodCia, A.Cod_Agente) Nombre, A.CodNivel, PNJ.Num_Tributario RFC, PNJ.IdRegFisSat
     FROM AGENTES A, PERSONA_NATURAL_JURIDICA PNJ
    WHERE A.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion
      AND A.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion
      AND PNJ.IdRegFisSat           = nIdRegFisSat 
    ORDER BY A.Cod_Agente;
BEGIN
   cCodUser := COALESCE(SYS_CONTEXT('APEX$SESSION','APP_USER'),USER); 
   IF cFormato = 'EXCEL' THEN
      nLinea   := 1;
      cCadena  := OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia);
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := cHeader;
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      
      -- Propiedades del documento
      cCadena  := cPropiedades; 
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
   
       -- Define estilos (opcional, pero reduce errores)
      cCadena  := cEstilos;
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := '    <Worksheet ss:Name="'||cNombreArchivo||'">'||chr(10)||
                  '<Table>'||chr(10)||
                  '<Row>'||chr(10);
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
   END IF;
   ----
   IF cCodReporte = 'RESICO' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||'Agente'         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre Agente'  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nivel'          ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'RFC'            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Registro Fiscal'||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      END IF;
      FOR X IN cAgentes LOOP
         IF cFormato = 'EXCEL' THEN
            nLinea := nLinea + 1;
            cCadena  := '<Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena := cAbreCelda||cAbreContenidoString||X.Agente                                     ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(X.Nombre)  ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.CodNivel                                   ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.RFC                                        ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.IdRegFisSat                                ||cCierraContenido||cCierraCelda;

            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena  := '</Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
         END IF;
      END LOOP;
   END IF;
   ----
   IF cFormato = 'EXCEL' THEN   
      cCadena  := '</Table>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := '</Worksheet>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := '</Workbook>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      
      OC_ARCHIVO.ESCRIBIR_LINEA('EOF', cCodUser, 0);
      OC_ARCHIVO.ACTUALIZA_ARCHIVO(cCodUser, cFormato, cNombreArchivo);
   END IF;
   EXCEPTION
      WHEN OTHERS THEN
         OC_ARCHIVO.ELIMINAR_ARCHIVO(cCodUser);
END GENERA_RESICO;

PROCEDURE GENERA_GENERALES(nCodCia NUMBER, nCodEmpresa NUMBER, cModulo VARCHAR2, cOpcion VARCHAR2,
                           cCodReporte VARCHAR2, cCodMoneda VARCHAR2, cIdTipoSeg VARCHAR2, dFecDesde DATE, 
                           dFecHasta DATE, nCodCliente NUMBER, dFecMorosidad DATE, cFormato VARCHAR2, cNombreArchivo VARCHAR2) IS
cAbreCelda           VARCHAR2(20) := '<Cell>';
cCierraCelda         VARCHAR2(20) := '</Cell>';
cAbreContenidoString VARCHAR2(40) := '<Data ss:Type="String">'; 
cAbreContenidoNumber VARCHAR2(40) := '<Data ss:Type="Number">';
cCierraContenido     VARCHAR2(20) := '</Data>';
cHeader              VARCHAR2(4000) := '<?xml version="1.0" encoding="UTF-8"?>'||chr(10)||
                                       '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"'||chr(10)||
                                       '          xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                                       '          xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                                       '          xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"'||chr(10)||
                                       '          xmlns:html="http://www.w3.org/TR/REC-html40">'||chr(10);
cPropiedades         VARCHAR2(4000) := '    <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">'||chr(10)||
                                       '        <Author>Oracle</Author>'||chr(10)||
                                       '        <LastAuthor>Oracle</LastAuthor>'||chr(10)||
                                       '        <Created>2024-10-29T00:00:00Z</Created>'||chr(10)||
                                       '        <Version>16.00</Version>'||chr(10)||
                                       '    </DocumentProperties>'||chr(10);
cEstilos             VARCHAR2(4000) := '    <Styles>'||chr(10)||
                                       '        <Style ss:ID="Default" ss:Name="Normal">'||chr(10)||
                                       '            <Alignment ss:Vertical="Bottom"/>'||chr(10)||
                                       '            <Borders/>'||chr(10)||
                                       '            <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'||chr(10)||
                                       '            <Interior/>'||chr(10)||
                                       '            <NumberFormat/>'||chr(10)||
                                       '            <Protection/>'||chr(10)||
                                       '        </Style>'||chr(10)||
                                       '    </Styles>'||chr(10);     
nLinea               NUMBER;
cCodUser             VARCHAR2(30);
cCadena              VARCHAR2(32000);   
---
cNomAseguradora VARCHAR2(500);
cNomAgente      VARCHAR2(500);
cNomCliente     VARCHAR2(500);
nComision       COMISIONES.Comision_Local%TYPE;
nPrimaNeta      DETALLE_FACTURAS.Monto_Det_Local%TYPE;
cMotivAnul      VARCHAR2(200);
cNomAsegurado   VARCHAR2(500);

CURSOR PROD_Q IS 
   SELECT PO.CodEmpresa,  AD.Cod_Agente, DP.IdTipoSeg Ramo,  PO.CodCliente CodCliente,
          RTRIM(LTRIM(DP.IdTipoSeg))||'-'||RTRIM(LTRIM(PO.NumPolRef))||'-'||LTRIM(TO_CHAR(PO.IdPoliza,'00000000')) NumPoliza,
          PO.SumaAseg_Local Suma_Asegurada, PO.PrimaNeta_Local Prima_Neta, 
          TRUNC(PO.FecEmision) FecEmis, PO.Cod_Moneda, PO.CodCia
     FROM POLIZAS PO, DETALLE_POLIZA DP, AGENTES_DETALLES_POLIZAS AD
    WHERE TRUNC(PO.FecEmision) >= dFecDesde
      AND TRUNC(PO.FecEmision) <= dFecHasta
      AND PO.IdPoliza           = DP.IdPoliza
      AND AD.IdPoliza           = PO.IdPoliza
      AND AD.Ind_Principal      = 'S'
GROUP BY DP.IdTipoSeg, PO.NumPolRef, PO.SumaAseg_Local, PO.PrimaNeta_Local, PO.FecEmision,
         PO.CodEmpresa, PO.CodCliente, AD.Cod_Agente, PO.IdPoliza, PO.CodCia, PO.Cod_Moneda
   UNION ALL
   SELECT PO.CodEmpresa,  AD.Cod_Agente, DP.IdTipoSeg Ramo,  PO.CodCliente CodCliente,
          RTRIM(LTRIM(DP.IdTipoSeg))||'-'||RTRIM(LTRIM(PO.NumPolRef))||'-'||LTRIM(TO_CHAR(PO.IdPoliza,'00000000')) NumPoliza,
          PO.SumaAseg_Local Suma_Asegurada, PO.PrimaNeta_Local Prima_Neta, 
          TRUNC(PO.FecEmision) FecEmis, PO.Cod_Moneda, PO.CodCia
     FROM POLIZAS PO, FZ_DETALLE_FIANZAS DP, AGENTES_DETALLES_POLIZAS AD
    WHERE TRUNC(PO.FecEmision) >= dFecDesde
      AND TRUNC(PO.FecEmision) <= dFecHasta
      AND PO.IdPoliza           = DP.IdPoliza
      AND AD.IdPoliza           = PO.IdPoliza
      AND AD.Ind_Principal      = 'S'
GROUP BY DP.IdTipoSeg, PO.NumPolRef, PO.SumaAseg_Local, PO.PrimaNeta_Local, PO.FecEmision,
         PO.CodEmpresa, PO.CodCliente, AD.Cod_Agente, PO.IdPoliza, PO.CodCia, PO.Cod_Moneda;

CURSOR COMIS_Q IS 
   SELECT P.CodEmpresa, AD.Cod_Agente, P.CodCliente, P.IdPoliza, P.CodCia,
          D.IdTipoSeg Ramo, RTRIM(LTRIM(P.NumPolRef))||'-'||LTRIM(TO_CHAR(P.IdPoliza,'00000000')) NumPoliza,
          F.IdFactura, F.ReciboPago Recibo, F.NumCuota No_Pago, NVL(F.Monto_Fact_Local,0) MontoFactura
      FROM FACTURAS F, POLIZAS P, DETALLE_POLIZA D,AGENTES_DETALLES_POLIZAS AD  
     WHERE P.IdPoliza         = D.IdPoliza
       AND P.CodCia           = nCodCia
       AND P.CodEmpresa       = nCodEmpresa
       AND F.IdPoliza         = P.IdPoliza
       AND AD.IdPoliza        = P.IdPoliza
       AND F.IdetPol          = D.IdetPol
       AND TRUNC(F.FecSts )  >= dFecDesde
       AND TRUNC(F.FecSts )  <= dFecHasta
       AND F.StsFact = 'PAG'
     UNION ALL
   SELECT P.CodEmpresa, AD.Cod_Agente, P.CodCliente, P.IdPoliza, P.CodCia,
          D.IdTipoSeg Ramo, RTRIM(LTRIM(P.NumPolRef))||'-'||LTRIM(TO_CHAR(P.IdPoliza,'00000000')) NumPoliza,
          F.IdFactura, F.ReciboPago Recibo, F.NumCuota No_Pago, NVL(F.Monto_Fact_Local,0) MontoFactura
      FROM FACTURAS F, POLIZAS P, FZ_DETALLE_FIANZAS D,AGENTES_DETALLES_POLIZAS AD  
     WHERE P.IdPoliza         = D.IdPoliza
       AND P.CodCia           = nCodCia
       AND P.CodEmpresa       = nCodEmpresa
       AND F.IdPoliza         = P.IdPoliza
       AND AD.IdPoliza        = P.IdPoliza
       AND F.IdetPol          = D.Correlativo
       AND TRUNC(F.FecSts )  >= dFecDesde
       AND TRUNC(F.FecSts )  <= dFecHasta
       AND F.StsFact          = 'PAG';
       
CURSOR COB_Q IS 
   SELECT P.CodEmpresa, AD.Cod_Agente, D.IdTipoSeg Ramo, P.CodCliente CodCliente, P.CodCia, F.IdFactura,
          RTRIM(LTRIM(D.IdTipoSeg))||'-'||RTRIM(LTRIM(P.NumPolRef))||'-'||LTRIM(TO_CHAR(P.IdPoliza,'00000000')) NumPoliza,
          TRUNC(F.FecSts) Fecha_Pago, NVL(F.Monto_Fact_Local,0) Prima_Total, F.Cod_Moneda
     FROM FACTURAS F, POLIZAS P, DETALLE_POLIZA D, AGENTES_DETALLES_POLIZAS AD  
    WHERE P.IdPoliza         = D.IdPoliza
      AND P.CodCia           = nCodCia
      AND P.CodEmpresa       = nCodEmpresa
      AND F.IdPoliza         = P.IdPoliza
      AND AD.IdPoliza        = P.IdPoliza
      AND AD.Ind_Principal   = 'S'
      AND TRUNC(F.Fecsts )  >= dFecDesde
      AND TRUNC(F.Fecsts )  <= dFecHasta
      AND F.StsFact          = 'PAG'
    GROUP BY P.IdPoliza,  D.IdTipoSeg, P.CodCia, AD.Cod_Agente, P.NumPolRef, P.CodCliente, D.IdPoliza,
             P.CodEmpresa, F.FecSts, F.FecVenc, P.Cod_Moneda, F.Monto_Fact_Local, F.IdFactura, F.Cod_Moneda
    UNION ALL
   SELECT P.CodEmpresa, AD.Cod_Agente, D.IdTipoSeg Ramo, P.CodCliente CodCliente, P.CodCia, F.IdFactura,
          RTRIM(LTRIM(D.IdTipoSeg))||'-'||RTRIM(LTRIM(P.NumPolRef))||'-'||LTRIM(TO_CHAR(P.IdPoliza,'00000000')) NumPoliza,
          TRUNC(F.FecSts) Fecha_Pago, NVL(F.Monto_Fact_Local,0) Prima_Total, F.Cod_Moneda
     FROM FACTURAS F, POLIZAS P, FZ_DETALLE_FIANZAS D, AGENTES_DETALLES_POLIZAS AD  
    WHERE P.IdPoliza         = D.IdPoliza
      AND P.CodCia           = nCodCia
      AND P.CodEmpresa       = nCodEmpresa
      AND F.IdPoliza         = P.IdPoliza
      AND AD.IdPoliza        = P.IdPoliza
      AND AD.Ind_Principal   = 'S'
      AND TRUNC(F.Fecsts )  >= dFecDesde
      AND TRUNC(F.Fecsts )  <= dFecHasta
      AND F.StsFact          = 'PAG'
    GROUP BY P.IdPoliza,  D.IdTipoSeg, P.CodCia, AD.Cod_Agente, P.NumPolRef, P.CodCliente, D.IdPoliza,
             P.CodEmpresa, F.FecSts, F.FecVenc, P.Cod_Moneda, F.Monto_Fact_Local, F.IdFactura, F.Cod_Moneda;       
             
CURSOR RENOV_Q IS 
   SELECT PO.CodEmpresa, AD.Cod_Agente, DP.IdTipoSeg Ramo, PO.CodCliente CodCliente, PO.CodCia,
          RTRIM(LTRIM(DP.IdTipoSeg))||'-'||RTRIM(LTRIM(PO.NumPolRef))||'-'||LTRIM(TO_CHAR(PO.IdPoliza,'00000000')) NumPoliza,
          PO.SumaAseg_Local Suma_Asegurada, PO.PrimaNeta_Local Prima_Neta, TRUNC(PO.FecRenovacion) FecRenovacion,
          TRUNC(PO.FecEmision) FecEmis, PO.Cod_Moneda
     FROM POLIZAS PO, DETALLE_POLIZA DP,AGENTES_DETALLES_POLIZAS AD
    WHERE PO.CodCia                 = nCodCia
      AND PO.CodEmpresa             = nCodEmpresa
      AND TRUNC(PO.FecRenovacion)  >= dFecDesde
      AND TRUNC(PO.FecRenovacion)  <= dFecHasta
      AND PO.IdPoliza               = DP.IdPoliza
      AND AD.IdPoliza               = PO.IdPoliza
      AND AD.Ind_Principal          = 'S'
    GROUP BY DP.IdTipoSeg, PO.NumPolRef, PO.SumaAseg_Local, PO.PrimaNeta_Local, PO.FecEmision,
             PO.FecRenovacion, PO.CodEmpresa, PO.CodCliente,AD.Cod_Agente,PO.IdPoliza, PO.CodCia, PO.Cod_Moneda;  
             
CURSOR COBRA_Q IS 
   SELECT D.IdTipoSeg, C.IdFactura, C.CodCobrador, C.Fecha_Pago, C.Recibo_Pago, C.Monto_Local, C.Monto_Moneda,
          F.CodCia, D.CodEmpresa, F.Cod_Moneda, F.Monto_Fact_Moneda
     FROM COMISION_COBRADOR C, FACTURAS F, DETALLE_POLIZA D
    WHERE C.IdFactura   = F.IdFactura
      AND F.Idpoliza    = D.Idpoliza
      AND C.Fecha_Pago >= dFecDesde
      AND C.Fecha_Pago <= dFecHasta
      AND F.CodCia      = nCodCia
    UNION
   SELECT D.IdTipoSeg, C.IdFactura, C.CodCobrador, C.Fecha_Pago, C.Recibo_Pago, C.Monto_Local, C.Monto_Moneda,
          F.CodCia, D.CodEmpresa, F.Cod_Moneda, F.Monto_Fact_Moneda
     FROM COMISION_COBRADOR C, FACTURAS F, FZ_DETALLE_FIANZAS D
    WHERE C.IdFactura   = F.IdFactura
      AND F.Idpoliza    = D.Idpoliza
      AND C.Fecha_Pago >= dFecDesde
      AND C.Fecha_Pago <= dFecHasta
      AND F.CodCia      = nCodCia;             
      
CURSOR POL_Q IS 
   SELECT 'NUEVAS' Tipo, PO.CodEmpresa, PO.CodCliente CodCliente, DP.IdTipoSeg Ramo,
          RTRIM(LTRIM(PO.NumPolRef))||'-'||LTRIM(TO_CHAR(PO.IdPoliza,'00000000')) NumPoliza,
          PO.PrimaNeta_Local Prima_Neta, ' ' Motivo_Anula, PO.Cod_Moneda, PO.CodCia
     FROM POLIZAS PO, DETALLE_POLIZA DP, AGENTES_DETALLES_POLIZAS AD
    WHERE PO.CodCia              = nCodCia
      AND PO.CodEmpresa          = nCodEmpresa
      /*((PO.CodEmpresa       > nCodEmpresa AND nCodEmpresa = 0)
       OR  PO.CodEmpresa       = nCodEmpresa AND nCodEmpresa != 0)*/
      AND DP.IdTiposeg           = NVL(cIdTipoSeg,DP.IdTiposeg)
      AND PO.Cod_Moneda          = NVL(cCodMoneda,PO.Cod_Moneda)
      AND TRUNC(PO.FecEmision)  >= dFecDesde
      AND TRUNC(PO.FecEmision)  <= dFecHasta
      AND PO.IdPoliza            = DP.IdPoliza
      AND PO.StsPoliza          != 'ANU'
      AND PO.NumRenov            = 0
    GROUP BY DP.IdTipoSeg, PO.NumPolRef, PO.PrimaNeta_Local, PO.FecEmision, ' ',
             PO.CodEmpresa, PO.CodCliente, PO.IdPoliza, PO.CodCia, PO.Cod_Moneda
    UNION ALL
   SELECT 'RENOVADAS' Tipo, PO.CodEmpresa, PO.CodCliente CodCliente, DP.IdTipoSeg Ramo,
          RTRIM(LTRIM(PO.NumPolRef))||'-'||LTRIM(TO_CHAR(PO.IdPoliza,'00000000')) NumPoliza,
          PO.PrimaNeta_Local Prima_Neta,' ' Motivo_Anula, PO.Cod_Moneda, PO.CodCia
     FROM POLIZAS PO, DETALLE_POLIZA DP
    WHERE PO.CodCia              = nCodCia
      AND PO.CodEmpresa          = nCodEmpresa
      /*((PO.CodEmpresa       > nCodEmpresa AND nCodEmpresa = 0)
       OR  PO.CodEmpresa       = nCodEmpresa AND nCodEmpresa != 0)*/
      AND DP.IdTiposeg           = NVL(cIdTipoSeg,DP.IdTiposeg)
      AND PO.Cod_Moneda          = NVL(cCodMoneda,PO.Cod_Moneda)
      AND TRUNC(PO.FecEmision)  >= dFecDesde
      AND TRUNC(PO.FecEmision)  <= dFecHasta
      AND PO.IdPoliza            = DP.idpoliza
      AND PO.StsPoliza          != 'ANU'
      AND PO.NumRenov           != 0
    GROUP BY DP.IdTipoSeg, PO.NumPolRef, PO.PrimaNeta_Local, PO.FecEmision, ' ',
             PO.CodEmpresa, PO.CodCliente, PO.IdPoliza, PO.CodCia, PO.Cod_Moneda
    UNION ALL 
   SELECT 'ANULADAS' Tipo, PO.CodEmpresa, PO.CodCliente CodCliente, DP.IdTipoSeg Ramo,
          RTRIM(LTRIM(PO.NumPolRef))||'-'||LTRIM(TO_CHAR(PO.IdPoliza,'00000000')) NumPoliza,
          PO.PrimaNeta_Local Prima_Neta, PO.MotivAnul Motivo_Anula, PO.Cod_Moneda, PO.CodCia
     FROM POLIZAS PO, DETALLE_POLIZA DP
    WHERE PO.CodCia              = nCodCia
      AND PO.CodEmpresa          = nCodEmpresa
      /*((PO.CodEmpresa       > nCodEmpresa AND nCodEmpresa = 0)
       OR  PO.CodEmpresa       = nCodEmpresa AND nCodEmpresa != 0)*/
      AND DP.IdTiposeg           = NVL(cIdTipoSeg,DP.IdTiposeg)
      AND PO.Cod_Moneda          = NVL(cCodMoneda,PO.Cod_Moneda)
      AND TRUNC(PO.FecAnul)     >= dFecDesde
      AND TRUNC(PO.FecAnul)     <= dFecHasta
      AND PO.IdPoliza            = DP.idpoliza
      AND PO.StsPoliza           = 'ANU'
    GROUP BY DP.IdTipoSeg, PO.NumPolRef, PO.PrimaNeta_Local, PO.FecEmision, PO.MotivAnul,
             PO.CodEmpresa, PO.CodCliente, PO.IdPoliza, PO.CodCia, PO.Cod_Moneda
    UNION ALL
   SELECT 'NUEVAS' Tipo, PO.CodEmpresa, PO.CodCliente CodCliente, DP.IdTipoSeg Ramo,
          RTRIM(LTRIM(PO.NumPolRef))||'-'||LTRIM(TO_CHAR(PO.IdPoliza,'00000000')) NumPoliza,
          PO.PrimaNeta_Local Prima_Neta, ' ' Motivo_Anula, PO.Cod_Moneda, PO.CodCia
     FROM POLIZAS PO, FZ_DETALLE_FIANZAS DP, AGENTES_DETALLES_POLIZAS AD
    WHERE PO.CodCia              = nCodCia
      AND PO.CodEmpresa          = nCodEmpresa
      /*((PO.CodEmpresa       > nCodEmpresa AND nCodEmpresa = 0)
       OR  PO.CodEmpresa       = nCodEmpresa AND nCodEmpresa != 0)*/
      AND DP.IdTiposeg           = NVL(cIdTipoSeg,DP.IdTiposeg)
      AND PO.Cod_Moneda          = NVL(cCodMoneda,PO.Cod_Moneda)
      AND TRUNC(PO.FecEmision)  >= dFecDesde
      AND TRUNC(PO.FecEmision)  <= dFecHasta
      AND PO.IdPoliza            = DP.IdPoliza
      AND PO.StsPoliza          != 'ANU'
      AND PO.NumRenov            = 0
    GROUP BY DP.IdTipoSeg, PO.NumPolRef, PO.PrimaNeta_Local, PO.FecEmision, ' ',
             PO.CodEmpresa, PO.CodCliente, PO.IdPoliza, PO.CodCia, PO.Cod_Moneda
    UNION ALL
   SELECT 'RENOVADAS' Tipo, PO.CodEmpresa, PO.CodCliente CodCliente, DP.IdTipoSeg Ramo,
          RTRIM(LTRIM(PO.NumPolRef))||'-'||LTRIM(TO_CHAR(PO.IdPoliza,'00000000')) NumPoliza,
          PO.PrimaNeta_Local Prima_Neta,' ' Motivo_Anula, PO.Cod_Moneda, PO.CodCia
     FROM POLIZAS PO, FZ_DETALLE_FIANZAS DP
    WHERE PO.CodCia              = nCodCia
      AND PO.CodEmpresa          = nCodEmpresa
      /*((PO.CodEmpresa       > nCodEmpresa AND nCodEmpresa = 0)
       OR  PO.CodEmpresa       = nCodEmpresa AND nCodEmpresa != 0)*/
      AND DP.IdTiposeg           = NVL(cIdTipoSeg,DP.IdTiposeg)
      AND PO.Cod_Moneda          = NVL(cCodMoneda,PO.Cod_Moneda)
      AND TRUNC(PO.FecEmision)  >= dFecDesde
      AND TRUNC(PO.FecEmision)  <= dFecHasta
      AND PO.IdPoliza            = DP.idpoliza
      AND PO.StsPoliza          != 'ANU'
      AND PO.NumRenov           != 0
    GROUP BY DP.IdTipoSeg, PO.NumPolRef, PO.PrimaNeta_Local, PO.FecEmision, ' ',
             PO.CodEmpresa, PO.CodCliente, PO.IdPoliza, PO.CodCia, PO.Cod_Moneda
    UNION ALL 
   SELECT 'ANULADAS' Tipo, PO.CodEmpresa, PO.CodCliente CodCliente, DP.IdTipoSeg Ramo,
          RTRIM(LTRIM(PO.NumPolRef))||'-'||LTRIM(TO_CHAR(PO.IdPoliza,'00000000')) NumPoliza,
          PO.PrimaNeta_Local Prima_Neta, PO.MotivAnul Motivo_Anula, PO.Cod_Moneda, PO.CodCia
     FROM POLIZAS PO, FZ_DETALLE_FIANZAS DP
    WHERE PO.CodCia              = nCodCia
      AND PO.CodEmpresa          = nCodEmpresa
      /*((PO.CodEmpresa       > nCodEmpresa AND nCodEmpresa = 0)
       OR  PO.CodEmpresa       = nCodEmpresa AND nCodEmpresa != 0)*/
      AND DP.IdTiposeg           = NVL(cIdTipoSeg,DP.IdTiposeg)
      AND PO.Cod_Moneda          = NVL(cCodMoneda,PO.Cod_Moneda)
      AND TRUNC(PO.FecAnul)     >= dFecDesde
      AND TRUNC(PO.FecAnul)     <= dFecHasta
      AND PO.IdPoliza            = DP.idpoliza
      AND PO.StsPoliza           = 'ANU'
    GROUP BY DP.IdTipoSeg, PO.NumPolRef, PO.PrimaNeta_Local, PO.FecEmision, PO.MotivAnul,
             PO.CodEmpresa, PO.CodCliente, PO.IdPoliza, PO.CodCia, PO.Cod_Moneda;      
         
CURSOR ESTADOS_Q IS 
   SELECT P.CodCia, P.CodEmpresa, ES.NomEmpresa, F.CodCliente, P.Cod_Moneda, M.Desc_Moneda, TO_CHAR(F.IdFactura) IdDoc,
          'FA-'||TO_CHAR(F.NumFact) NumDoc, 'FAC' TipoDoc, TRUNC(F.FecSts) FecDoc, F.FecVenc, F.StsFact StsDoc, P.IdPoliza, 
          RTRIM(LTRIM(P.NumPolRef))||'-'||LTRIM(TO_CHAR(P.IdPoliza,'00000000')) NumPoliza, P.FecIniVig, P.FecFinVig,
          F.IdEndoso, DECODE(NVL(F.IdEndoso,0),0,'EMI-1','END-'||F.IdEndoso) TipoMov, F.Monto_Fact_Moneda Cargo, 0 Abono
     FROM FACTURAS F, POLIZAS P, EMPRESAS_DE_SEGUROS ES, MONEDA M
    WHERE P.CodCia                   = nCodCia
      AND ((P.CodCliente > nCodCliente OR nCodCliente = 0)
       OR   P.CodCliente = nCodCliente OR nCodCliente != 0)
      AND TRUNC(F.FecSts)            >= TRUNC(dFecDesde)
      AND TRUNC(F.FecSts)            <= TRUNC(dFecHasta)
      AND F.StsFact                  IN ('EMI','PAG')
      AND NVL(F.Monto_Fact_Moneda,0) != 0 
      AND P.IdPoliza                  = F.IdPoliza
      AND ES.CodCia                   = P.CodCia
      AND ES.CodEmpresa               = P.CodEmpresa
      AND M.Cod_Moneda                = P.Cod_Moneda
    UNION   
   SELECT P.CodCia, P.CodEmpresa, ES.NomEmpresa, NC.CodCliente, P.Cod_Moneda, M.Desc_Moneda, TO_CHAR(NC.IdNCr) IdDoc,
          'NC-'||NC.NumNCr NumDoc, 'N/C' TipoDoc, TRUNC(NC.FecSts) FecDoc, NULL FecVenc, NC.StsNCr StsDoc, P.IdPoliza, 
          RTRIM(LTRIM(P.NumPolRef))||'-'||LTRIM(TO_CHAR(P.IdPoliza,'00000000')) NumPoliza, P.FecIniVig, P.FecFinVig,
          NC.IdEndoso, DECODE(NVL(NC.IdEndoso,0),0,NULL,'END-'||NC.IdEndoso) TipoMov, TO_NUMBER(NULL) Cargo, NC.Monto_NCr_Moneda Abono
     FROM NOTAS_DE_CREDITO NC, POLIZAS P, EMPRESAS_DE_SEGUROS ES, MONEDA M
    WHERE P.CodCia                    = nCodCia
      AND ((P.CodCliente > nCodCliente OR nCodCliente = 0)
       OR   P.CodCliente = nCodCliente OR nCodCliente != 0)
      AND TRUNC(NC.FecSts)          >= TRUNC(dFecDesde)
      AND TRUNC(NC.FecSts)          <= TRUNC(dFecHasta)
      AND NC.StsNCr                  IN ('EMI','PAG')
      AND NVL(NC.Monto_NCr_Moneda,0) != 0 
      AND P.IdPoliza                  = NC.IdPoliza
      AND ES.CodCia                   = P.CodCia
      AND ES.CodEmpresa               = P.CodEmpresa
      AND M.Cod_Moneda                = P.Cod_Moneda
    UNION
   SELECT P.CodCia, P.CodEmpresa, ES.NomEmpresa, F.CodCliente, P.Cod_Moneda, M.Desc_Moneda,  TO_CHAR(F.NumFact) IdDoc,
          'PA-'||F.ReciboPago NumDoc, 'PAG' TipoDoc, TRUNC(F.FecSts) FecDoc, NULL FecVenc, F.StsFact StsDoc, P.IdPoliza, 
          RTRIM(LTRIM(P.NumPolRef))||'-'||LTRIM(TO_CHAR(P.IdPoliza,'00000000')) NumPoliza, P.FecIniVig, P.FecFinVig,
          TO_NUMBER(NULL) IdEndoso, NULL TipoMov, TO_NUMBER(NULL) Cargo, SUM(NVL(F.Monto_Fact_Moneda,0)) Abono
     FROM FACTURAS F, POLIZAS P, EMPRESAS_DE_SEGUROS ES, MONEDA M
    WHERE P.CodCia                   = nCodCia
      AND ((P.CodCliente > nCodCliente OR nCodCliente = 0)
       OR   P.CodCliente = nCodCliente OR nCodCliente != 0)
      AND TRUNC(F.FecSts)           >= TRUNC(dFecDesde)
      AND TRUNC(F.FecSts)           <= TRUNC(dFecHasta)
      AND F.StsFact                   =  'PAG'
      AND NVL(F.Monto_Fact_Moneda,0) != 0 
      AND P.IdPoliza                  = F.IdPoliza
      AND ES.CodCia                   = P.CodCia
      AND ES.CodEmpresa               = P.CodEmpresa
      AND M.Cod_Moneda                = P.Cod_Moneda
    GROUP BY P.CodCia, P.CodEmpresa, ES.NomEmpresa, F.CodCliente, P.Cod_Moneda, M.Desc_Moneda, F.ReciboPago, F.FecSts, 
             F.StsFact, P.IdPoliza, P.NumPolRef, P.FecIniVig, P.FecFinVig, F.NumFact;
             
CURSOR MOROSIDAD_Q IS 
   SELECT P.CodEmpresa, AD.Cod_Agente, D.Cod_Asegurado, D.IdTipoSeg Ramo, P.CodCia,
          RTRIM(LTRIM(P.NumPolRef))||'-'||LTRIM(TO_CHAR(P.IdPoliza,'00000000')) NumPoliza,
          F.IdFactura, F.ReciboPago Recibo, F.NumCuota No_Pago, F.Saldo_Local Prima_Pendiente,
          TO_CHAR(F.FecVenc,'DD/MM/YYYY') Fecha_Vence,
          TRUNC(TO_NUMBER(DECODE(F.FecPago, NULL, dFecMorosidad - F.FecVenc, F.FecPago - F.FecVenc)),0) Dias_Atraso
     FROM FACTURAS F, POLIZAS P, DETALLE_POLIZA D, AGENTES_DETALLES_POLIZAS AD  
    WHERE P.IdPoliza          = D.IdPoliza
      AND P.CodCia            = nCodCia
      AND P.CodEmpresa        = nCodEmpresa
      AND F.IdPoliza          = P.IdPoliza
      AND AD.IdPoliza         = D.IdPoliza
      AND AD.Ind_Principal    = 'S'
      AND TRUNC(F.FecVenc )  <= dFecMorosidad
      AND F.Saldo_Local      != 0
      AND F.StsFact           = 'EMI'
    GROUP BY P.IdPoliza,  D.IdTipoSeg, D.Cod_Asegurado, P.CodCia, AD.Cod_Agente,
          P.NumPolRef, P.CodCliente, F.IdFactura, F.Saldo_Local, P.CodEmpresa,
          F.FecPago, F.FecVenc, P.Cod_Moneda, F.ReciboPago, F.NumCuota
    UNION ALL
   SELECT P.CodEmpresa, AD.Cod_Agente, P.CodCliente Cod_Asegurado, D.IdTipoSeg Ramo, P.CodCia,
          RTRIM(LTRIM(P.NumPolRef))||'-'||LTRIM(TO_CHAR(P.IdPoliza,'00000000')) NumPoliza,
          F.IdFactura, F.ReciboPago Recibo, F.NumCuota No_Pago, F.Saldo_Local Prima_Pendiente,
          TO_CHAR(F.FecVenc,'DD/MM/YYYY') Fecha_Vence,
          TRUNC(TO_NUMBER(DECODE(F.FecPago, NULL, dFecMorosidad - F.FecVenc, F.FecPago - F.FecVenc)),0) Dias_Atraso
     FROM FACTURAS F, POLIZAS P, FZ_DETALLE_FIANZAS D, AGENTES_DETALLES_POLIZAS AD  
    WHERE P.IdPoliza          = D.IdPoliza
      AND P.CodCia            = nCodCia
      AND P.CodEmpresa        = nCodEmpresa
      AND F.IdPoliza          = P.IdPoliza
      AND AD.IdPoliza         = D.IdPoliza
      AND AD.Ind_Principal    = 'S'
      AND TRUNC(F.FecVenc )  <= dFecMorosidad
      AND F.Saldo_Local      != 0
      AND F.StsFact           = 'EMI'
    GROUP BY P.IdPoliza,  D.IdTipoSeg, P.CodCliente, P.CodCia, AD.Cod_Agente,
          P.NumPolRef, P.CodCliente, F.IdFactura, F.Saldo_Local, P.CodEmpresa,
          F.FecPago, F.FecVenc, P.Cod_Moneda, F.ReciboPago, F.NumCuota;            
          
CURSOR CLIENTE_Q IS 
   SELECT ES.CodEmpresa, ES.NomEmpresa  Aseguradora,  P.Cod_Agente, P.CodCia,
          P.CodCliente, PJ.Nombre||' '||PJ.Apellido NomCliente,
          PJ.Email Correo_Electronico, PJ.TelRes Telefono, PJ.DirecRes Direccion
     FROM POLIZAS P, CLIENTES C, DETALLE_POLIZA D, ASEGURADO A, 
          EMPRESAS_DE_SEGUROS ES, EMPRESAS E, AGENTES_DETALLES_POLIZAS AD, PERSONA_NATURAL_JURIDICA PJ     
    WHERE ES.CodCia        = E.CodCia
      AND ES.CodEmpresa    = P.CodEmpresa
      AND P.CodCia         = E.CodCia
      AND P.IdPoliza       = D.IdPoliza
      AND P.CodCliente     = C.CodCliente
      AND A.Cod_Asegurado  = D.Cod_Asegurado
      AND AD.IdPoliza      = P.IdPoliza
      AND AD.Ind_Principal = 'S'
      AND PJ.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
      AND PJ.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
    GROUP BY ES.CodEmpresa, ES.NomEmpresa, P.Cod_Agente, P.CodCliente, AD.Cod_Agente, P.CodCia,
             PJ.Nombre, PJ.Apellido, PJ.Email, PJ.TelRes, PJ.DirecRes
    UNION ALL
   SELECT ES.CodEmpresa, ES.NomEmpresa  Aseguradora,  P.Cod_Agente, P.CodCia,
          P.CodCliente, PJ.Nombre||' '||PJ.Apellido NomCliente,
          PJ.Email Correo_Electronico, PJ.TelRes Telefono, PJ.DirecRes Direccion
     FROM POLIZAS P, CLIENTES C, FZ_DETALLE_FIANZAS D, EMPRESAS_DE_SEGUROS ES, 
          EMPRESAS E, AGENTES_DETALLES_POLIZAS AD, PERSONA_NATURAL_JURIDICA PJ     
    WHERE ES.CodCia        = E.CodCia
      AND ES.CodEmpresa    = P.CodEmpresa
      AND P.CodCia         = E.CodCia
      AND P.IdPoliza       = D.IdPoliza
      AND P.CodCliente     = C.CodCliente
      AND AD.IdPoliza      = P.IdPoliza
      AND AD.Ind_Principal = 'S'
      AND PJ.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
      AND PJ.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
    GROUP BY ES.CodEmpresa, ES.NomEmpresa, P.Cod_Agente, P.CodCliente, AD.Cod_Agente, P.CodCia,
             PJ.Nombre, PJ.Apellido, PJ.Email, PJ.TelRes, PJ.DirecRes;          
         
BEGIN
   cCodUser := COALESCE(SYS_CONTEXT('APEX$SESSION','APP_USER'),USER); 
   IF cFormato = 'EXCEL' THEN
      nLinea   := 1;
      cCadena  := OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia);
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := cHeader;
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      
      -- Propiedades del documento
      cCadena  := cPropiedades; 
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
   
       -- Define estilos (opcional, pero reduce errores)
      cCadena  := cEstilos;
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := '    <Worksheet ss:Name="'||cNombreArchivo||'">'||chr(10)||
                  '<Table>'||chr(10)||
                  '<Row>'||chr(10);
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
   END IF;
   ----
   IF cCodReporte = 'PRODUCC' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||'CodEmpresa'                                         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Aseguradora'                                        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Agente')   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre Agente'                                      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Tipo de Seguro'                                     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Cliente')  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre de Cliente'                                  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('No. de Póliza')   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Suma Asegurada'                                     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Prima Neta'                                         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Fecha de Emisión')||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Moneda'                                             ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      END IF;
      FOR X IN PROD_Q LOOP
         cNomAseguradora := OC_EMPRESAS.NOMBRE_COMPANIA(X.CodEmpresa);
         cNomAgente      := OC_AGENTES.NOMBRE_AGENTE(X.CodCia, X.Cod_Agente);
         cNomCliente     := OC_CLIENTES.NOMBRE_CLIENTE(X.CodCliente);
         IF cFormato = 'EXCEL' THEN
            nLinea := nLinea + 1;
            cCadena  := '<Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            
            cCadena := cAbreCelda||cAbreContenidoString||X.CodEmpresa                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||cNomAseguradora                                 ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Cod_Agente                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomAgente)   ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Ramo                                          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.CodCliente                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomCliente)  ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.NumPoliza                                     ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.Suma_Asegurada                                ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.Prima_Neta                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.FecEmis                                       ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Cod_Moneda                                    ||cCierraContenido||cCierraCelda;
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena  := '</Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
         END IF;
      END LOOP;         
   ELSIF cCodReporte = 'COMISIONES' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||'CodEmpresa'                                         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Aseguradora'                                        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Agente')   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre Agente'                                      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Tipo de Seguro'                                     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Cliente')  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre de Cliente'                                  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('No. de Póliza')   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'No. Factura'                                        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'No. de Recibo'                                      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'No. de Pago'                                        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Monto Factura'                                      ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      END IF;
      FOR X IN COMIS_Q LOOP
         cNomAseguradora := OC_EMPRESAS.NOMBRE_COMPANIA(X.CodEmpresa);
         cNomAgente      := OC_AGENTES.NOMBRE_AGENTE(X.CodCia, X.Cod_Agente);
         cNomCliente     := OC_CLIENTES.NOMBRE_CLIENTE(X.CodCliente);
         SELECT SUM(NVL (C.Comision_Local,0))
           INTO nComision
           FROM COMISIONES C         
          WHERE C.IdPoliza   = X.IdPoliza
            AND C.IdFactura  = X.IdFactura;
         
         IF cFormato = 'EXCEL' THEN   
            nLinea := nLinea + 1;
            cCadena  := '<Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena := cAbreCelda||cAbreContenidoNumber||X.CodEmpresa                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||cNomAseguradora                                 ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.Cod_Agente                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomAgente)   ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Ramo                                          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.CodCliente                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomCliente)  ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.NumPoliza                                     ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.IdFactura                                     ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Recibo                                        ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.No_Pago                                       ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.MontoFactura                                  ||cCierraContenido||cCierraCelda;
                       
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena  := '</Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;         
         END IF;
      END LOOP;
   ELSIF cCodReporte = 'COBRANZA' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||'CodEmpresa'                                         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Aseguradora'                                        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Agente')   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre Agente'                                      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Tipo de Seguro'                                     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Cliente')  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre de Cliente'                                  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('No. de Póliza')   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Fecha de Pago'                                      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Prima Neta'                                         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Prima Total'                                        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Moneda'                                             ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      END IF;
      FOR X IN COB_Q LOOP
         cNomAseguradora := OC_EMPRESAS.NOMBRE_COMPANIA(X.CodEmpresa);
         cNomAgente      := OC_AGENTES.NOMBRE_AGENTE(X.CodCia, X.Cod_Agente);
         cNomCliente     := OC_CLIENTES.NOMBRE_CLIENTE(X.CodCliente);
         
         SELECT SUM(NVL(D.Monto_Det_Local,0))
           INTO nPrimaNeta
           FROM DETALLE_FACTURAS D
          WHERE D.IdFactura  = X.IdFactura
            AND D.CodCpto    = 'PRIMA';
         
         IF cFormato = 'EXCEL' THEN
            nLinea := nLinea + 1;
            cCadena  := '<Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena := cAbreCelda||cAbreContenidoNumber||X.CodEmpresa                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||cNomAseguradora                                 ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.Cod_Agente                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomAgente)   ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Ramo                                          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.CodCliente                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomCliente)  ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.NumPoliza                                     ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Fecha_Pago                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||nPrimaNeta                                      ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.Prima_Total                                   ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Cod_Moneda                                    ||cCierraContenido||cCierraCelda;
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena  := '</Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;   
         END IF;
      END LOOP;
   ELSIF cCodReporte = 'RENOVACION' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||'CodEmpresa'                                            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Aseguradora'                                           ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Agente')      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre Agente'                                         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Tipo de Seguro'                                        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Cliente')     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre de Cliente'                                     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('No. de Póliza')      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Suma Asegurada'                                        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Prima Neta'                                            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Fecha de Emisión')   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Fecha de Renovación')||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Moneda'                                                ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      END IF;
      FOR X IN RENOV_Q LOOP
         cNomAseguradora := OC_EMPRESAS.NOMBRE_COMPANIA(X.CodEmpresa);
         cNomAgente      := OC_AGENTES.NOMBRE_AGENTE(X.CodCia, X.Cod_Agente);
         cNomCliente     := OC_CLIENTES.NOMBRE_CLIENTE(X.CodCliente);
         IF cFormato = 'EXCEL' THEN
            nLinea := nLinea + 1;
            cCadena  := '<Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena := cAbreCelda||cAbreContenidoNumber||X.CodEmpresa                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||cNomAseguradora                                 ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.Cod_Agente                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomAgente)   ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Ramo                                          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.CodCliente                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomCliente)  ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.NumPoliza                                     ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.Suma_Asegurada                                ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.Prima_Neta                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.FecEmis                                       ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.FecRenovacion                                 ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Cod_Moneda                                    ||cCierraContenido||cCierraCelda;
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena  := '</Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;                       
         END IF;
      END LOOP;
   ELSIF cCodReporte = 'COMCOB' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||'CodEmpresa'                                                     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Aseguradora'                                                    ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Tipo de Seguro'                                                 ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'No. de Factura'                                                 ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Cobrador')             ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Fecha de Pago'                                                  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'No. de Recibo'                                                  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Comisión Local Cobrador')     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Comisión Extranjera Cobrador')||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Monto Factura'                                                  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Moneda'                                                         ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      END IF;
      FOR X IN COBRA_Q LOOP
         cNomAseguradora := OC_EMPRESAS.NOMBRE_COMPANIA(X.CodEmpresa);
         IF cFormato = 'EXCEL' THEN
            nLinea := nLinea + 1;
            cCadena  := '<Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena := cAbreCelda||cAbreContenidoNumber||X.CodEmpresa                                          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||cNomAseguradora                                       ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.IdTipoSeg                                           ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.IdFactura                                           ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.CodCobrador                                         ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Fecha_Pago                                          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.Recibo_Pago                                         ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.Monto_Local                                         ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.Monto_Moneda                                        ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.Monto_Fact_Moneda                                   ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Cod_Moneda                                          ||cCierraContenido||cCierraCelda;
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena  := '</Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
         END IF;
      END LOOP;
   ELSIF cCodReporte = 'CONTPOL' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||'Tipo Estado'                                           ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Empresa')     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Aseguradora'                                           ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Cliente')     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre Cliente'                                        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Tipo de Seguro'                                        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('No. de Póliza')      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Prima Neta'                                            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Motivo Anulación')   ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      END IF;
      FOR X IN POL_Q LOOP
         cNomAseguradora := OC_EMPRESAS.NOMBRE_COMPANIA(X.CodEmpresa);
         cNomCliente     := OC_CLIENTES.NOMBRE_CLIENTE(X.CodCliente);
         IF X.Motivo_Anula != ' ' THEN
            cMotivAnul := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('MOTIVANU', X.Motivo_Anula);
         ELSE
            cMotivAnul := X.Motivo_Anula;
         END IF;
         IF cFormato = 'EXCEL' THEN
            nLinea := nLinea + 1;
            cCadena  := '<Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena := cAbreCelda||cAbreContenidoString||X.Tipo                                          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.CodEmpresa                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||cNomAseguradora                                 ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.CodCliente                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomCliente)  ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Ramo                                          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.NumPoliza                                     ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.Prima_Neta                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||cMotivAnul                                      ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Cod_Moneda                                    ||cCierraContenido||cCierraCelda;
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena  := '</Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
         END IF;
      END LOOP;
   ELSIF cCodReporte = 'EDOSCTA' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||'CodEmpresa'                                               ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Aseguradora'                                              ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Cliente')        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre de Cliente'                                        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Moneda')         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Descripción Moneda')    ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'No. Id Documento'                                         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'No. y Tipo Documento'                                     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Fecha Documento'                                          ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Fecha Vencimiento'                                        ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Estado Documento'                                         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('No. de Póliza')         ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Fecha Inicio Vigencia') ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Fecha Fin Vigencia')    ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('No. Endoso')            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Tipo de Movimiento')    ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Cargo')                 ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Abono')                 ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      END IF;
      FOR X IN ESTADOS_Q LOOP
         cNomCliente     := OC_CLIENTES.NOMBRE_CLIENTE(X.CodCliente);
         IF cFormato = 'EXCEL' THEN
            nLinea := nLinea + 1;
            cCadena  := '<Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena := cAbreCelda||cAbreContenidoNumber||X.CodEmpresa                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.NomEmpresa                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.CodCliente                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomCliente)  ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Cod_Moneda                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Desc_Moneda                                   ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.IdDoc                                         ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.NumDoc                                        ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.TipoDoc                                       ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.FecDoc                                        ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.FecVenc                                       ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.StsDoc                                        ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.NumPoliza                                     ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.FecIniVig                                     ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.FecFinVig                                     ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.IdEndoso                                      ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(X.TipoMov)    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.Cargo                                         ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.Abono                                         ||cCierraContenido||cCierraCelda;
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena  := '</Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
         END IF;
      END LOOP;
   ELSIF cCodReporte = 'MORCOBRA' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||'CodEmpresa'                                            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Aseguradora'                                           ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Agente')      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre de Agente'                                      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Tipo de Seguro')     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Asegurado')   ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre del Asegurado'                                  ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('No. de Póliza')      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'No. Factura'                                           ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'No. Recibo'                                            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'No. de Cuota'                                          ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Prima Pendiente'                                       ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Fecha Vencimiento'                                     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Días Atraso')        ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      END IF;
      FOR X IN MOROSIDAD_Q LOOP
         cNomAseguradora := OC_EMPRESAS.NOMBRE_COMPANIA(X.CodEmpresa);
         cNomAgente      := OC_AGENTES.NOMBRE_AGENTE(X.CodCia, X.Cod_Agente);
         cNomAsegurado   := OC_ASEGURADO.NOMBRE_ASEGURADO(X.CodCia, X.CodEmpresa, X.Cod_Asegurado);
         IF cFormato = 'EXCEL' THEN
            nLinea := nLinea + 1;
            cCadena  := '<Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena := cAbreCelda||cAbreContenidoNumber||X.CodEmpresa                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||cNomAseguradora                                 ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Cod_Agente                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomAgente)   ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Ramo                                          ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Cod_Asegurado                                 ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomAsegurado)||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.NumPoliza                                     ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.IdFactura                                     ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Recibo                                        ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.No_Pago                                       ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.Prima_Pendiente                               ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Fecha_Vence                                   ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoNumber||X.Dias_Atraso                                   ||cCierraContenido||cCierraCelda;
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena  := '</Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
         END IF;
      END LOOP;
   ELSIF cCodReporte = 'CLIENTES' THEN
      IF cFormato = 'EXCEL' THEN
         cCadena  := cAbreCelda||cAbreContenidoString||'CodEmpresa'                                            ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Aseguradora'                                           ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Agente')      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre de Agente'                                      ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Código Cliente')     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||'Nombre de Cliente'                                     ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Correo Electrónico') ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Teléfono')           ||cCierraContenido||cCierraCelda||
                     cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8('Dirección')          ||cCierraContenido||cCierraCelda;
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         nLinea   := nLinea + 1;
         cCadena  := '</Row>';
         OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      END IF;
      FOR X IN CLIENTE_Q LOOP
         cNomAseguradora := OC_EMPRESAS.NOMBRE_COMPANIA(X.CodEmpresa);
         cNomAgente      := OC_AGENTES.NOMBRE_AGENTE(X.CodCia, X.Cod_Agente);
         cNomCliente     := OC_CLIENTES.NOMBRE_CLIENTE(X.CodCliente);
         IF cFormato = 'EXCEL' THEN
            nLinea := nLinea + 1;
            cCadena  := '<Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            
            cCadena := cAbreCelda||cAbreContenidoNumber||X.CodEmpresa                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||cNomAseguradora                                 ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Cod_Agente                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomAgente)   ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.CodCliente                                    ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(cNomCliente)  ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Correo_Electronico                            ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||X.Telefono                                      ||cCierraContenido||cCierraCelda||
                       cAbreCelda||cAbreContenidoString||OC_GENERALES.CONVERTIR_TEXTO_UTF8(X.Direccion)  ||cCierraContenido||cCierraCelda;
            
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
            nLinea   := nLinea + 1;
            cCadena  := '</Row>';
            OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
         END IF;
      END LOOP;
   END IF;
   ----
   IF cFormato = 'EXCEL' THEN   
      cCadena  := '</Table>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := '</Worksheet>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      nLinea   := nLinea + 1;
      cCadena  := '</Workbook>';
      OC_ARCHIVO.ESCRIBIR_LINEA(cCadena, cCodUser, nLinea);
      
      OC_ARCHIVO.ESCRIBIR_LINEA('EOF', cCodUser, 0);
      OC_ARCHIVO.ACTUALIZA_ARCHIVO(cCodUser, cFormato, cNombreArchivo);
   END IF;
   EXCEPTION
      WHEN OTHERS THEN
         OC_ARCHIVO.ELIMINAR_ARCHIVO(cCodUser);
END GENERA_GENERALES;

END OC_REPORTES_APEX;
/
CREATE OR REPLACE PUBLIC SYNONYM OC_REPORTES_APEX FOR SICAS_OC.OC_REPORTES_APEX;
/
GRANT EXECUTE ON SICAS_OC.OC_REPORTES_APEX TO PUBLIC;
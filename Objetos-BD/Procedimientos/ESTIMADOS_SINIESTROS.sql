CREATE OR REPLACE PROCEDURE ESTIMADOS_SINIESTROS  IS
-- variables proceso --
cLimitador      VARCHAR2(1) :='|';
nLinea          NUMBER;
nLineaimp       NUMBER := 1;
cCadena         VARCHAR2(4000);
cCadenaAux      VARCHAR2(4000);
cCadenaAux1     VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;

nIdSiniestro     SINIESTRO.IDSINIESTRO%TYPE;
nTipoCambio      TASAS_CAMBIO.TASA_CAMBIO%TYPE;
nMontoRvaMon     COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc     COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;

dFecCarga1A       VARCHAR2(50);
cNomArchCarga1A   PROCESOS_MASIVOS_SEGUIMIENTO.CRGA_NOM_ARCHIVO%TYPE;
cEmiTipoProceso   PROCESOS_MASIVOS_SEGUIMIENTO.EMI_TIPOPROCESO%TYPE;
dFecCarga         DATOS_PART_SINIESTROS.FecSts%TYPE;
cRFCHospital      DATOS_PART_SINIESTROS.Campo1%TYPE;
cDescSiniestro    SINIESTRO.Desc_Siniestro%TYPE;
cNomArchCarga     PROCESOS_MASIVOS_SEGUIMIENTO.CRGA_NOM_ARCHIVO%TYPE;
--

cPolizaCont       VARCHAR(50);
cTIPODIARIO       COMPROBANTES_CONTABLES.TIPODIARIO%TYPE;
nNUMCOMPROBSC     COMPROBANTES_CONTABLES.NUMCOMPROBSC%TYPE;

W_ID_TERMINAL   VARCHAR2(100);
W_ID_USER       VARCHAR2(100);
W_ID_ENVIO      VARCHAR2(100);
--
-- variables reporte --
cCtlArchivo     UTL_FILE.FILE_TYPE;
cNomDirectorio  VARCHAR2(100) ;
cNomArchivo VARCHAR2(100) := 'ESTIMA_'||to_char(trunc(sysdate - 1),'ddmmyyyy')||'.XLSX';

cNomArchZip           VARCHAR2(100);
cIdTipoSeg            VARCHAR2(50) := '%';
cCodMoneda            VARCHAR2(25) := '%';
nCodCia               NUMBER := 1;
nCodEmpresa           NUMBER := 1;
cCodReporte           VARCHAR2(100) := 'ESTIMASINIESTROS';
cNomCia               VARCHAR2(100);
cTitulo1              VARCHAR2(200);
cTitulo2              VARCHAR2(200);
cTitulo3              VARCHAR2(200);
cTitulo4              VARCHAR2(200);
cEncabez              VARCHAR2(5000);
nColsTotales     NUMBER := 0;
nColsLateral     NUMBER := 0;
nColsMerge       NUMBER := 0;
nColsCentro      NUMBER := 0;
nJustCentro      NUMBER := 3;
dFecDesde DATE;
dFecHasta DATE;
nSPV             NUMBER := 0;
cRutaNomArchivo  varchar2(100);
      l_bfile         BFILE;
      l_blob          CLOB;

cEmail                      USUARIOS.EMAIL%TYPE;
cPwdEmail                   VARCHAR2(100);
cMiMail                     USUARIOS.EMAIL%TYPE := 'notificaciones@thonaseguros.mx';
cSaltoLinea                 VARCHAR2(5)      := '<br>';
cHTMLHeader                 VARCHAR2(2000)   := '<html>'                                                                     ||cSaltoLinea||
                                             '<head>'                                                                     ||cSaltoLinea||
                                             '<meta http-equiv="Content-Language" content="en/us"/>'                      ||cSaltoLinea||
                                             '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>'  ||cSaltoLinea||
                                             '</head><body>'                                                              ||cSaltoLinea;
 cHTMLFooter                VARCHAR2(100)    := '</body></html>';
 cTextoAlignDerecha         VARCHAR2(50)     := '<P align="CENTER">';
 cTextoAlignDerechaClose    VARCHAR2(50)     := '</P>';
 cTextoAlignjustificado      VARCHAR2(50)     := '<P align="justify">';
 cTextoAlignjustificadoClose VARCHAR2(50)     := '</P>';
 cError                      VARCHAR2(1000);
cEmail1                     CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
cEmail2                     CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
cEmail3                     CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
cTextoEnv                   ENDOSO_TXT_DET.TEXTO%TYPE;
cSubject                    VARCHAR2(1000) := 'Notificacion Archivo de Estimaciones de Siniestros: ';
cTexto1                     VARCHAR2(10000):= 'Apreciable Compañero ';
cTexto2                     varchar2(1000)   := ' Envío archivo de Estimaciones de Siniestros generado de manera automática el día de hoy. ';
cTexto3                     varchar2(10)   := '  ';
cTexto4                     varchar2(1000)   := ' Saludos. ';
----
CURSOR ESTIMADOS_Q IS
SELECT SI.IDPOLIZA,
       PP.NUMPOLUNICO POLUNIK,
       SI.IDSINIESTRO,
       CS.CODCOBERT CVCOB,
       SI.NUMSINIREF,
       T.FECHATRANSACCION FECHAMVTO,
       SI.MOTIVO_DE_SINIESTRO CVE_CIE_10,
       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CAUSIN',SI.MOTIVO_DE_SINIESTRO) DESC_CIE_10,
       'Verificar' DescCortaMov,
       CTS.SIGNO,
       PP.FECINIVIG,
       PP.FECFINVIG,
       NVL(to_number(CS.IDTRANSACCIONANUL),
       CS.IDTRANSACCION) NUMTRX,
       CS.CODTRANSAC CVETRX,
       CS.CODCPTOTRANSAC CPTOTRX,
       CDC.DESCRIPCONCEPTO DESCCPTOTRX,
       CS.MONTO_RESERVADO_MONEDA,
       CS.MONTO_RESERVADO_LOCAL,
       SI.MONTO_RESERVA_MONEDA,
       SI.MONTO_RESERVA_LOCAL,
       SI.COD_MONEDA MONEDA,
       --
       NVL(SI.MONTO_RESERVA_MONEDA,0) - NVL(SI.MONTO_PAGO_MONEDA,0) OPC_MONEDA,
       NVL(SI.MONTO_RESERVA_LOCAL,0) - NVL(SI.MONTO_PAGO_LOCAL,0) OPC_LOCAL,
       --
       SI.FEC_OCURRENCIA,
       SI.FEC_NOTIFICACION,
       CS.STSCOBERTURA,
       OC_ASEGURADO.NOMBRE_ASEGURADO(PP.CODCIA,PP.CODEMPRESA,SI.COD_ASEGURADO) NOM_ASEG,
       SI.COD_ASEGURADO  COD_ASEGURADO,
       SI.DESC_SINIESTRO DESC_SINI,
       DS.IDTIPOSEG TIPOSEGURO,
       T.USUARIOGENERO USUARIO,
       D.CODSUBPROCESO,
       --
       T.IDTRANSACCION,
       --
       DECODE(NVL(PP.PORCENCONTRIBUTORIO,0),0,'N','S')  ESCONTRIBUTORIO,
       NVL(PP.PORCENCONTRIBUTORIO,0)                    PORCENCONTRIBUTORIO,
       UPPER(TXT.DESCGIRONEGOCIO)                       GIRONEGOCIO,
--          P.CODTIPONEGOCIO                                          CODTIPONEGOCIO,
       DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',PP.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',PP.CODTIPONEGOCIO)) TIPONEGOCIO,
--          P.FUENTERECURSOSPRIMA                                     CODFUENTERECURSOS,
       DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',PP.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',PP.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
       PP.CODPAQCOMERCIAL                               CODPAQCOMERCIAL,
--          P.CODCATEGO                                               CODCATEGO,
       CGO.DESCCATEGO                                   CATEGORIA,
--          P.FORMAVENTA                                              CODCANALFORMAVENTA,
       DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',PP.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',PP.FORMAVENTA)) CANALFORMAVENTA,
       --
       OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE) NOMCONTRATANTE,
       SI.EMPRESA_LABORA,
       SI.IDETPOL CERTIFICADO,
       SI.IDCREDITO,
       OC_PERSONA_NATURAL_JURIDICA.CLAVE_RFC(ASE.TIPO_DOC_IDENTIFICACION,ASE.NUM_DOC_IDENTIFICACION) RFC_ASEGURADO,
       OC_PERSONA_NATURAL_JURIDICA.CLAVE_CURP(ASE.TIPO_DOC_IDENTIFICACION,ASE.NUM_DOC_IDENTIFICACION) CURP_ASEGURADO,
       TO_CHAR(OC_PERSONA_NATURAL_JURIDICA.FECHA_INGRESO(CLI.TIPO_DOC_IDENTIFICACION,CLI.NUM_DOC_IDENTIFICACION),'DD/MM/YYYY') FE_INGRE_CONTRA,
       TO_CHAR(OC_PERSONA_NATURAL_JURIDICA.FECHA_INGRESO(ASE.TIPO_DOC_IDENTIFICACION,ASE.NUM_DOC_IDENTIFICACION),'DD/MM/YYYY') FE_INGRE_ASEGU,
       OC_PERSONA_NATURAL_JURIDICA.SEXO(ASE.TIPO_DOC_IDENTIFICACION,ASE.NUM_DOC_IDENTIFICACION) SEXO,
       SI.TP_ASEGURADO,
       SI.CODPROVOCURR ESTADO,
       DECODE(OC_PROVINCIA.NOMBRE_PROVINCIA(SI.CODPAISOCURR,SI.CODPROVOCURR),'PROVINCIA NO EXISTE',' ',OC_PROVINCIA.NOMBRE_PROVINCIA(SI.CODPAISOCURR,SI.CODPROVOCURR)) NOMESTADO,
       SI.CODMUNICIPIO MUNICIPIO,
       DECODE(OC_MUNICIPIO.NOMBRE_MUNICIPIO(SI.CODPAISOCURR,SI.CODPROVOCURR,SI.CODMUNICIPIO),'MUNICIPIO NO EXISTE',' ',OC_MUNICIPIO.NOMBRE_MUNICIPIO(SI.CODPAISOCURR,SI.CODPROVOCURR,SI.CODMUNICIPIO)) NOMMUNICIPIO,
       SI.NOM_MEDICO_CERTIFICA,
       SI.ID_CEDULA_MEDICA
  FROM DETALLE_TRANSACCION D,
       TRANSACCION T,
       COBERTURA_SINIESTRO CS,
       SINIESTRO SI,
       DETALLE_SINIESTRO DS,
       CONFIG_TRANSAC_SINIESTROS CTS,
       POLIZAS PP,
       CATALOGO_DE_CONCEPTOS CDC,
       POLIZAS_TEXTO_COTIZACION  TXT,
       CATEGORIAS                CGO,
       CLIENTES                  CLI,
       ASEGURADO                 ASE
 WHERE PP.CODCIA     = nCodCia
   AND PP.CODEMPRESA = nCodEmpresa
   --
   AND T.IDTRANSACCION            > 0
   AND TRUNC(T.FECHATRANSACCION) >= DFECDESDE
   AND TRUNC(T.FECHATRANSACCION) <= DFECHASTA
   AND T.IDPROCESO                = 6
   --
   AND D.IDTRANSACCION = T.IDTRANSACCION
   AND D.CODCIA        = 1
   AND D.CODEMPRESA    = 1
   AND D.CORRELATIVO   > 0
   AND D.OBJETO        = 'COBERTURA_SINIESTRO'
   --
   AND TO_NUMBER(D.VALOR1) = SI.IDSINIESTRO
   AND D.CODSUBPROCESO     IN ('EMIRES','ANURES')
   --
   AND (SI.COD_MONEDA = DECODE(cCodMoneda,'%',SI.COD_MONEDA,cCodMoneda))
   AND (DS.IDTIPOSEG  = DECODE(cIdTipoSeg,'%',DS.IDTIPOSEG ,cIdTipoSeg))
   --
   AND  CS.IDSINIESTRO = TO_NUMBER(D.VALOR1)
   AND  CS.IDPOLIZA    = TO_NUMBER(D.VALOR2)
   AND  CS.CODCOBERT   = D.VALOR3
   AND  CS.NUMMOD      = TO_NUMBER(D.VALOR4)
   --
   AND CDC.CODCIA      = nCodCia
   AND CDC.CODCONCEPTO = CS.CODCPTOTRANSAC
   --
   AND DS.IDSINIESTRO = CS.IDSINIESTRO
   AND DS.IDPOLIZA    = CS.IDPOLIZA
   AND DS.IDDETSIN    = CS.IDDETSIN
   --
   AND PP.IDPOLIZA    = SI.IDPOLIZA
   AND PP.CODCIA      = SI.CODCIA
   AND PP.CODEMPRESA  = SI.CODEMPRESA
   AND SI.IDSINIESTRO = CS.IDSINIESTRO
   AND SI.IDPOLIZA    = CS.IDPOLIZA
   AND CTS.CODCIA     = nCodCia
   AND CTS.CODTRANSAC = CS.CODTRANSAC
   --
   AND TXT.CODCIA(+)     = PP.CODCIA
   AND TXT.CODEMPRESA(+) = PP.CODEMPRESA
   AND TXT.IDPOLIZA(+)   = PP.IDPOLIZA
   --
   AND CGO.CODCIA(+)         = PP.CODCIA
   AND CGO.CODEMPRESA(+)     = PP.CODEMPRESA
   AND CGO.CODTIPONEGOCIO(+) = PP.CODTIPONEGOCIO
   AND CGO.CODCATEGO(+)      = PP.CODCATEGO
   --
   AND CLI.CODCLIENTE = PP.CODCLIENTE
   --
   AND ASE.COD_ASEGURADO = SI.COD_ASEGURADO
   --
--
UNION ALL   -- MLJS 10/11/2020 DE AGREGO LA CLAUSULA ALL
--
SELECT SI.IDPOLIZA,
       PP.NUMPOLUNICO
       POLUNIK,
       SI.IDSINIESTRO,
       CS.CODCOBERT CVCOB,
       SI.NUMSINIREF,
       T.FECHATRANSACCION FECHAMVTO,
       SI.MOTIVO_DE_SINIESTRO CVE_CIE_10,
       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CAUSIN',SI.MOTIVO_DE_SINIESTRO) DESC_CIE_10,
       'Verificar' DescCortaMov,
       CTS.SIGNO,
       PP.FECINIVIG,
       PP.FECFINVIG,
       NVL(to_number(CS.IDTRANSACCIONANUL),
       CS.IDTRANSACCION) NUMTRX,
       --
       CS.CODTRANSAC CVETRX,
       CS.CODCPTOTRANSAC CPTOTRX,
       CDC.DESCRIPCONCEPTO DESCCPTOTRX,
       CS.MONTO_RESERVADO_MONEDA,
       CS.MONTO_RESERVADO_LOCAL,
       SI.MONTO_RESERVA_MONEDA,
       SI.MONTO_RESERVA_LOCAL,
       SI.COD_MONEDA MONEDA,
       --
       NVL(SI.MONTO_RESERVA_MONEDA,0) - NVL(SI.MONTO_PAGO_MONEDA,0) OPC_MONEDA,
       NVL(SI.MONTO_RESERVA_LOCAL,0) - NVL(SI.MONTO_PAGO_LOCAL,0)   OPC_LOCAL,
       --
       SI.FEC_OCURRENCIA,
       SI.FEC_NOTIFICACION,
       CS.STSCOBERTURA,
       OC_ASEGURADO.NOMBRE_ASEGURADO(PP.CODCIA,PP.CODEMPRESA,SI.COD_ASEGURADO) NOM_ASEG,
       SI.COD_ASEGURADO  COD_ASEGURADO,
       SI.DESC_SINIESTRO DESC_SINI,
       DS.IDTIPOSEG TIPOSEGURO,
       T.USUARIOGENERO USUARIO,
       D.CODSUBPROCESO,
       --
       T.IDTRANSACCION,
       --
       DECODE(NVL(PP.PORCENCONTRIBUTORIO,0),0,'N','S')   ESCONTRIBUTORIO,
       NVL(PP.PORCENCONTRIBUTORIO,0)                     PORCENCONTRIBUTORIO,
       UPPER(TXT.DESCGIRONEGOCIO)                        GIRONEGOCIO,
--          P.CODTIPONEGOCIO                                          CODTIPONEGOCIO,
       DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',PP.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',PP.CODTIPONEGOCIO)) TIPONEGOCIO,
--          P.FUENTERECURSOSPRIMA                                     CODFUENTERECURSOS,
       DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',PP.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',PP.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
       PP.CODPAQCOMERCIAL                                CODPAQCOMERCIAL,
--          P.CODCATEGO                                               CODCATEGO,
       CGO.DESCCATEGO                                    CATEGORIA,
--          P.FORMAVENTA                                              CODCANALFORMAVENTA,
       DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',PP.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',PP.FORMAVENTA)) CANALFORMAVENTA,
       --
       OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE) NOMCONTRATANTE,
       SI.EMPRESA_LABORA,
       SI.IDETPOL CERTIFICADO,
       SI.IDCREDITO,
       OC_PERSONA_NATURAL_JURIDICA.CLAVE_RFC(ASE.TIPO_DOC_IDENTIFICACION,ASE.NUM_DOC_IDENTIFICACION) RFC_ASEGURADO,
       OC_PERSONA_NATURAL_JURIDICA.CLAVE_CURP(ASE.TIPO_DOC_IDENTIFICACION,ASE.NUM_DOC_IDENTIFICACION) CURP_ASEGURADO,
       TO_CHAR(OC_PERSONA_NATURAL_JURIDICA.FECHA_INGRESO(CLI.TIPO_DOC_IDENTIFICACION,CLI.NUM_DOC_IDENTIFICACION),'DD/MM/YYYY') FE_INGRE_CONTRA,
       TO_CHAR(OC_PERSONA_NATURAL_JURIDICA.FECHA_INGRESO(ASE.TIPO_DOC_IDENTIFICACION,ASE.NUM_DOC_IDENTIFICACION),'DD/MM/YYYY') FE_INGRE_ASEGU,
       OC_PERSONA_NATURAL_JURIDICA.SEXO(ASE.TIPO_DOC_IDENTIFICACION,ASE.NUM_DOC_IDENTIFICACION) SEXO,
       SI.TP_ASEGURADO,
       SI.CODPROVOCURR ESTADO,
       DECODE(OC_PROVINCIA.NOMBRE_PROVINCIA(SI.CODPAISOCURR,SI.CODPROVOCURR),'PROVINCIA NO EXISTE',' ',OC_PROVINCIA.NOMBRE_PROVINCIA(SI.CODPAISOCURR,SI.CODPROVOCURR)) NOMESTADO,
       SI.CODMUNICIPIO MUNICIPIO,
       DECODE(OC_MUNICIPIO.NOMBRE_MUNICIPIO(SI.CODPAISOCURR,SI.CODPROVOCURR,SI.CODMUNICIPIO),'MUNICIPIO NO EXISTE',' ',OC_MUNICIPIO.NOMBRE_MUNICIPIO(SI.CODPAISOCURR,SI.CODPROVOCURR,SI.CODMUNICIPIO)) NOMMUNICIPIO,
       SI.NOM_MEDICO_CERTIFICA,
       SI.ID_CEDULA_MEDICA
  FROM TRANSACCION T,
       DETALLE_TRANSACCION D,
       COBERTURA_SINIESTRO_ASEG CS,
       CATALOGO_DE_CONCEPTOS CDC,
       SINIESTRO SI,
       POLIZAS PP,
       DETALLE_SINIESTRO_ASEG DS,
       CONFIG_TRANSAC_SINIESTROS CTS,
       POLIZAS_TEXTO_COTIZACION  TXT,
       CATEGORIAS                CGO,
       CLIENTES                  CLI,
       ASEGURADO                 ASE
 WHERE PP.CODCIA     = nCodCia
   AND PP.CODEMPRESA = nCodEmpresa
   --
   AND T.IDTRANSACCION > 0
   AND TRUNC(T.FECHATRANSACCION) >= DFECDESDE
   AND TRUNC(T.FECHATRANSACCION) <= DFECHASTA
   AND T.IDPROCESO               = 6
   --
   AND D.IDTRANSACCION     = T.IDTRANSACCION
   AND D.OBJETO            = 'COBERTURA_SINIESTRO_ASEG'
   AND D.CODSUBPROCESO     IN ('EMIRES','ANURES')
   AND TO_NUMBER(D.VALOR1) = SI.IDSINIESTRO
   --
   AND (SI.COD_MONEDA = DECODE(cCodMoneda,'%',SI.COD_MONEDA,cCodMoneda))
   AND (DS.IDTIPOSEG  = DECODE(cIdTipoSeg,'%',DS.IDTIPOSEG ,cIdTipoSeg))
   --
   AND T.IDTRANSACCION = D.IDTRANSACCION
   --
   AND CS.IDSINIESTRO = TO_NUMBER(D.VALOR1)
   AND CS.IDPOLIZA    = TO_NUMBER(D.VALOR2)
   AND CS.CODCOBERT   = D.VALOR3
   AND CS.NUMMOD      = TO_NUMBER(D.VALOR4)
   --
   AND CDC.CODCONCEPTO = CS.CODCPTOTRANSAC
   --
   AND DS.IDSINIESTRO   = CS.IDSINIESTRO
   AND DS.IDDETSIN      = CS.IDDETSIN
   AND DS.IDPOLIZA      = CS.IDPOLIZA
   AND DS.COD_ASEGURADO = CS.COD_ASEGURADO
   --
   AND PP.IDPOLIZA    = SI.IDPOLIZA
   AND PP.CODCIA      = SI.CODCIA
   AND PP.CODEMPRESA  = SI.CODEMPRESA
   AND SI.IDSINIESTRO = DS.IDSINIESTRO
   AND SI.IDPOLIZA    = DS.IDPOLIZA
   AND CTS.CODCIA     = nCodCia
   AND CTS.CODTRANSAC = CS.CODTRANSAC
   --
   AND TXT.CODCIA(+)     = PP.CODCIA
   AND TXT.CODEMPRESA(+) = PP.CODEMPRESA
   AND TXT.IDPOLIZA(+)   = PP.IDPOLIZA
   --
   AND CGO.CODCIA(+)         = PP.CODCIA
   AND CGO.CODEMPRESA(+)     = PP.CODEMPRESA
   AND CGO.CODTIPONEGOCIO(+) = PP.CODTIPONEGOCIO
   AND CGO.CODCATEGO(+)      = PP.CODCATEGO
   --
   AND CLI.CODCLIENTE = PP.CODCLIENTE
   --
   AND ASE.COD_ASEGURADO = SI.COD_ASEGURADO
 ORDER BY 3,1,4
;

----------------------------
    FUNCTION CUENTA_COLUMNAS(ENCABEZADOS_CON_SPERARDOR VARCHAR2, CHR_SEPARADOR_COLUMNAS VARCHAR2 := '|') RETURN NUMBER IS
        XCOL NUMBER :=0;
    BEGIN
        FOR ENT IN (SELECT COLUMN_VALUE TITULO
                     from table(GT_WEB_SERVICES.split(ENCABEZADOS_CON_SPERARDOR, CHR_SEPARADOR_COLUMNAS))) LOOP
            XCOL := XCOL + 1;
        END LOOP;
        RETURN XCOL;
    END;
-------------------------------
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
      nFila            NUMBER;
      cError           VARCHAR2(200);

   BEGIN
      nFila := 1;
      --
      DBMS_OUTPUT.put_line('MLJS EN INSERTA ENCABEZADO cFormato  '||cFormato||' cNomDirectorio  '||cNomDirectorio||' cNomArchivo  '||cNomArchivo  );
      IF cFormato = 'TEXTO' THEN
         OC_REPORTES_THONA.INSERTAR_REGISTRO( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cEncabez );
      ELSE
         --Obtiene Número de Columnas Totales
         nColsTotales := XLSX_BUILDER_PKG.EXCEL_CUENTA_COLUMNAS(cEncabez);
         --
         DBMS_OUTPUT.put_line('MLJS EN INSERTA ENCABEZADO nColsTotales '||nColsTotales);
         IF XLSX_BUILDER_PKG.EXCEL_CREAR_LIBRO(cNomDirectorio, cNomArchivo) THEN
           -- DBMS_OUTPUT.put_line('MLJS EN INSERTA ENCABEZADO 1');
            IF XLSX_BUILDER_PKG.EXCEL_CREAR_HOJA(cCodReporte) THEN
               --Titulos
              -- DBMS_OUTPUT.put_line('MLJS EN INSERTA ENCABEZADO 2');
               nFila := XLSX_BUILDER_PKG.EXCEL_HEADER(nFila + 1, cTitulo1, nColsTotales, nJustCentro, nColsLateral, nColsCentro, nColsMerge);
               nFila := XLSX_BUILDER_PKG.EXCEL_HEADER(nFila + 1, cTitulo2, nColsTotales, nJustCentro, nColsLateral, nColsCentro, nColsMerge);
               nFila := XLSX_BUILDER_PKG.EXCEL_HEADER(nFila + 1, cTitulo3, nColsTotales, nJustCentro, nColsLateral, nColsCentro, nColsMerge);
               nFila := XLSX_BUILDER_PKG.EXCEL_HEADER(nFila + 1, cTitulo4, nColsTotales, nJustCentro, nColsLateral, nColsCentro, nColsMerge);
               --Encabezado
               nFila := XLSX_BUILDER_PKG.EXCEL_ENCABEZADO(nFila + 1, cEncabez, 1);
               
             
            END IF;
         END IF;
      END IF;
   EXCEPTION
   WHEN OTHERS THEN
        cError := SQLERRM;
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20225, cError );
   END INSERTA_ENCABEZADO;
---------------------------

PROCEDURE ENVIA_MAIL IS
BEGIN
--------------------------

BEGIN
  SELECT LOWER(DESCVALLST)
    INTO CEMAIL1
    FROM VALORES_DE_LISTAS
   WHERE CODLISTA = 'EMAILESTSI'
     AND CODVALOR = 'EMAIL1';
EXCEPTION WHEN OTHERS THEN
   CEMAIL1      := 'LJIMENEZ@THONASEGUROS.MX';
END;
   DBMS_OUTPUT.PUT_LINE('CEMAIL1  '||CEMAIL1);

BEGIN
  SELECT  LOWER(DESCVALLST)
    INTO CEMAIL2
    FROM VALORES_DE_LISTAS
   WHERE CODLISTA = 'EMAILESTSI'
     AND CODVALOR = 'EMAIL2';
EXCEPTION WHEN OTHERS THEN
   CEMAIL2      := NULL;
END;
   DBMS_OUTPUT.PUT_LINE('CEMAIL2  '||CEMAIL2);

BEGIN
  SELECT  LOWER(DESCVALLST)
    INTO CEMAIL3
    FROM VALORES_DE_LISTAS
   WHERE CODLISTA = 'EMAILESTSI'
     AND CODVALOR = 'EMAIL3';
EXCEPTION WHEN OTHERS THEN
   CEMAIL3      := NULL;
END;
   DBMS_OUTPUT.PUT_LINE('CEMAIL3  '||CEMAIL3);

---------------------------

   cEmail       := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
   cPwdEmail    := OC_GENERALES.BUSCA_PARAMETRO(1,'022');

    -- cEmail2      := NULL;
    -- cEmail1      := 'ljimenez@thonaseguros.mx';
    -- cEmail3      := NULL;

   cTextoEnv := cHTMLHeader||cTexto1||cSaltoLinea||cSaltoLinea||cTexto2||cSaltoLinea||cSaltoLinea||
                      cTexto4||cSaltoLinea||cHTMLFooter;

     DBMS_OUTPUT.PUT_LINE('cTextoEnv  '||cTextoEnv);
------------
   OC_MAIL.INIT_PARAM;
   OC_MAIL.cCtaEnvio   := cEmail;
   OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
--
   BEGIN
      OC_MAIL.SEND_EMAIL(cNomDirectorio,cMiMail,cEmail1,cEmail2,cEmail3,cSubject,cTextoEnv,cNomArchZip,NULL,NULL,NULL,cError);
   EXCEPTION
        WHEN OTHERS THEN
             dbms_output.put_line('Error en el envío de notificacion!!! '||cEmail1||' error '||SQLERRM);
   END;


   BEGIN
     UTL_FILE.fremove (cNomDirectorio, cNomArchZip);
   END;
------------

END ENVIA_MAIL;
-------------------------------
PROCEDURE INSERTA_REGISTROS is
BEGIN

       INSERT INTO T_REPORTES_AUTOMATICOS (CODCIA, CODEMPRESA, NOMBRE_REPORTE, FECHA_PROCESO, NUMERO_REGISTRO, CODPLANTILLA,
       NOMBRE_ARCHIVO_EXCEL,CAMPO)
       VALUES(1,1,cCodReporte,trunc(sysdate),nLineaimp,'REPAUTESTSIN',cNomArchivo,
              trim(cCadena)||trim(cCadenaAux)||trim(cCadenaAux1));
       nLineaimp := nLineaimp +1;

       commit;

END INSERTA_REGISTROS;
-------------------------------

BEGIN
   SELECT SYS_CONTEXT ('USERENV','CURRENT_USERID')
     INTO cCodUser
     FROM DUAL;

   SELECT SYS_CONTEXT('userenv', 'terminal'),
          USER
     INTO W_ID_TERMINAL,
          W_ID_USER
     FROM DUAL;

   INSERT INTO CONTROL_PROCESOS_AUTOMATICOS
   VALUES('ESTIMASINIESTROS',SYSDATE,W_ID_ENVIO,W_ID_USER,W_ID_TERMINAL);
   --
   COMMIT;
   --

   cNomDirectorio := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SO_PATH', 'REPORT');

----
   SELECT TRUNC(SYSDATE - 1) FIRST, TRUNC(SYSDATE - 1) LAST
   INTO DFECDESDE, DFECHASTA
   FROM  DUAL ;

   --DFECDESDE := TO_DATE('26/07/2021','DD/MM/RRRR');
   --DFECHASTA := TO_DATE('26/07/2021','DD/MM/RRRR');


   DELETE TEMP_REPORTES_THONA
   WHERE  CodCia     = nCodCia
   AND  CodEmpresa = nCodEmpresa
   AND  CodReporte = cCodReporte
   AND  CodUsuario = cCodUser;
  --
 -- COMMIT;

   BEGIN
     SELECT NOMCIA
       INTO CNOMCIA
       FROM EMPRESAS
      WHERE CODCIA = NCODCIA;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      CNOMCIA := 'COMPAÑIA - NO EXISTE!!!';
   END ;

   --dbms_output.put_line('dPrimerDia '||dFecDesde);
  -- dbms_output.put_line('dUltimoDia '||dFecHasta);
----
    ---
   nLinea := 1;

   cTitulo1 := cNomCia;
   cTitulo2 := 'REPORTE DIARIO DE RESERVAS';
   cTitulo3 := 'PERIODO DEL '||TO_CHAR(DFECDESDE,'DD')||' DE '||TO_CHAR(DFECDESDE,'Month')||' DE '||TO_CHAR(DFECDESDE,'YYYY')||' AL '||
                               TO_CHAR(DFECHASTA,'DD')||' DE '||TO_CHAR(DFECHASTA,'Month')||' DE '||TO_CHAR(DFECHASTA,'YYYY');
   cTitulo4 := ' ';
   cEncabez    := 'NUMERO POLIZA'            ||cLimitador||
                  'NO. POLIZA UNICO'         ||cLimitador||
                  'NO. SINIESTRO'            ||cLimitador||
                  'COBERTURA'                ||cLimitador||
                  'NUMERO DE ASISTENCIA'     ||cLimitador||
                  'FECHA MOVIMIENTO'         ||cLimitador||
                  'RFC HOSPITAL'             ||cLimitador||
                  'CLAVE CIE10'              ||cLimitador||
                  'DESCRIPCION DE CIE 10 '   ||cLimitador||
                  'DESCCORTAMOV'             ||cLimitador||
                  'INICIO VIGENCIA POLIZA'   ||cLimitador||
                  'FIN VIGENCIA POLIZA'      ||cLimitador||
                  'NUMERO TRANSACCION'       ||cLimitador||
                  'TRANSACCION SINIESTROS'   ||cLimitador||
                  'CONCEPTO TRANSACCION'     ||cLimitador||
                  'DESCRIPCION CONCEPTO'     ||cLimitador||
                  'MOVTO RVA MON ORIG'       ||cLimitador||
                  'MOVTO RVA MON NAC'        ||cLimitador||
                  'SALDO RESERVA ORIGINAL'   ||cLimitador||
                  'SALDO RESERVA MN'         ||cLimitador||
                  'OPC MON ORIGINAL'         ||cLimitador||
                  'OPC MON NAIONAL'          ||cLimitador||
                  'MONEDA'                   ||cLimitador||
                  'TIPO DE CAMBIO'           ||cLimitador||
                  'FECHA OCURRENCIA'         ||cLimitador||
                  'FECHA NOTIFICACION'       ||cLimitador||
                  'ESTATUS COBERTURA'        ||cLimitador||
                  'NOMBRE ASEGURADO'         ||cLimitador||
                  'CODIGO_DEL_ASEGURADO'     ||cLimitador||
                  'DESCRIPCION DEL SINIESTRO'||cLimitador||
                  'TIPO SEGURO'              ||cLimitador||
                  'NOMBRE_ARCH_CARGA'        ||cLimitador||
                  'FECHA DE CARGA'           ||cLimitador||
                  'USUARIO'                  ||cLimitador||
                  'NOMBRE_ARCHIVO_LOGEM'     ||cLimitador||
                  'Es Contributorio'         ||cLimitador||
                  '% Contributorio'          ||cLimitador||
                  'Giro de Negocio'          ||cLimitador||
                  'Tipo de Negocio'          ||cLimitador||
                  'Fuente de Recursos'       ||cLimitador||
                  'Paquete Comercial'        ||cLimitador||
                  'Categoria'                ||cLimitador||
                  'Canal de Venta'           ||cLimitador||
                  'Poliza Contable'          ||cLimitador||
                  'Contratante'              ||cLimitador||
                  'Empresa donde labora'     ||cLimitador||
                  'Certificado'              ||cLimitador||
                  'Credito'                  ||cLimitador||
                  'RFC Asegurado'            ||cLimitador||
                  'CURP ASEGURADO'           ||cLimitador||
                  'Fecha de ingreso Asegurado'   ||cLimitador||
                  'Fecha de ingreso Contratante' ||cLimitador||
                  'Sexo'                     ||cLimitador||
                  'Tipo Asegurado'           ||cLimitador||
                  'CVE ESTADO'               ||cLimitador||
                  'NOM ESTADO'               ||cLimitador||
                  'CVE MUNICIPIO'            ||cLimitador||
                  'NOM MUNICIPIO'            ||cLimitador||
                  'MEDICO CERFICANTE'        ||cLimitador||
                  'CEDULA ' ;

   INSERTA_REGISTROS;
   INSERTA_ENCABEZADO( 'EXCEL', nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo ) ;
         --
   nLinea := 6;

   --CARGA DE INFORMACIÓN
   FOR X IN ESTIMADOS_Q LOOP
      nIdSiniestro := X.IdSiniestro;
     -- dbms_output.put_line('MLJS ENTRNADO A ESTIMADOS_Q '||nIdSiniestro);
      --
      BEGIN
         SELECT TO_CHAR(PMS.Crga_FechaComp,'DD/MM/YYYY HH24:MI:SS'),
                PMS.Crga_Nom_Archivo,
                PMS.Emi_TipoProceso,
                DPS.FecSts,
                DPS.Campo1,
                NVL(DPS.Campo4,X.Desc_Sini),
                DECODE(PMS.Crga_Nom_Archivo,NULL,'Registro Manual',NVL(DPS.Campo85,'Sin Archio LOGEM'))
           INTO dFecCarga1A,
                cNomArchCarga1A,
                cEmiTipoProceso,
                dFecCarga,
                cRFCHospital,
                cDescSiniestro,
                cNomArchCarga
           FROM PROCESOS_MASIVOS_SEGUIMIENTO PMS,
                DATOS_PART_SINIESTROS DPS
          WHERE PMS.Crga_Cod_Proceso IN('ESTSIN','AURVAD','DIRVAD')
            AND TRUNC(PMS.Crga_Fecha)  BETWEEN dFecDesde AND dFecHasta
            AND PMS.Emi_StsRegProceso  = 'EMI'
            AND PMS.IdSiniestro        = X.IdSiniestro
            AND PMS.IdPoliza  = X.IdPoliza
            AND PMS.Cod_Asegurado      = X.Cod_Asegurado
            AND PMS.IdProcMasivo       = DPS.IdProcMasivo;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
           dFecCarga1A     := NULL;
           cNomArchCarga1A := NULL;
           cEmiTipoProceso := NULL;
           dFecCarga       := NULL;
           cRFCHospital    := NULL;
           cDescSiniestro  := X.Desc_Sini;
           cNomArchCarga   := 'Registro Manual '||'Sin Archio LOGEM';
      END;
      --
      BEGIN
         SELECT TASA_CAMBIO
           INTO nTipoCambio
           FROM TASAS_CAMBIO
          WHERE FECHA_HORA_CAMBIO = X.FechaMvto
            AND COD_MONEDA        = X.moneda;
      EXCEPTION
         WHEN OTHERS THEN
             nTipoCambio := 0;
      END;
      --
      IF X.SIGNO = '-' OR X.CODSUBPROCESO = 'ANURES' THEN
         nMontoRvaMon := NVL(X.MONTO_RESERVADO_MONEDA,0) * -1;
         nMontoRvaLoc := NVL(X.MONTO_RESERVADO_LOCAL,0) * -1;
      ELSE
         nMontoRvaMon := NVL(X.MONTO_RESERVADO_MONEDA,0);
         nMontoRvaLoc := NVL(X.MONTO_RESERVADO_LOCAL,0);
      END IF;
      
      --MLJS 08/10/2020 SE OBTIENE LA PÓLIZA CONTABLE
         BEGIN
         	 SELECT TIPODIARIO,NUMCOMPROBSC
         	 INTO   cTIPODIARIO, nNUMCOMPROBSC
           FROM   COMPROBANTES_CONTABLES CC
           WHERE  NUMTRANSACCION = X.NUMTRX;
           
           cPolizaCont :=   cTIPODIARIO||'-'||nNUMCOMPROBSC; 
         EXCEPTION
         	  WHEN NO_DATA_FOUND THEN
         	     cPolizaCont := 'SIN POLIZA CONT';
         	  WHEN OTHERS THEN
         	     cPolizaCont := 'SIN POLIZA CONT';   
         END;
               
      cCadena :=  X.IDPOLIZA                               ||cLimitador||
                  X.POLUNIK                                ||cLimitador||
                  X.IDSINIESTRO                            ||cLimitador||
                  X.CVCOB                                  ||cLimitador||
                  REPLACE(X.NUMSINIREF,'|','')             ||cLimitador||
                  TO_CHAR(X.FECHAMVTO,'DD/MM/RRRR')        ||cLimitador||
                  cRFCHospital                             ||cLimitador||
                  X.CVE_CIE_10                             ||cLimitador||
                  TRIM(X.DESC_CIE_10)                      ||cLimitador||
                  TRIM(X.DESCCORTAMOV)                     ||cLimitador||
                  TO_CHAR(X.FECINIVIG,'DD/MM/RRRR')        ||cLimitador||
                  TO_CHAR(X.FECFINVIG,'DD/MM/RRRR')        ||cLimitador||
                  X.NUMTRX                                 ||cLimitador||
                  X.CVETRX                                 ||cLimitador||
                  X.CPTOTRX                                ||cLimitador||
                  X.DESCCPTOTRX                            ||cLimitador||
                  nMontoRvaMon                             ||cLimitador||
                  nMontoRvaLoc                             ||cLimitador||
                  X.MONTO_RESERVA_MONEDA                   ||cLimitador||
                  X.MONTO_RESERVA_LOCAL                    ||cLimitador||
                  X.OPC_MONEDA                             ||cLimitador||
                  X.OPC_LOCAL                              ||cLimitador||
                  X.MONEDA                                 ||cLimitador||
                  nTipoCambio                              ||cLimitador||
                  TO_CHAR(X.FEC_OCURRENCIA,'DD/MM/RRRR')   ||cLimitador||
                  TO_CHAR(X.FEC_NOTIFICACION,'DD/MM/RRRR') ||cLimitador||
                  X.STSCOBERTURA                           ||cLimitador||
                  X.NOM_ASEG                               ||cLimitador||
                  X.COD_ASEGURADO                          ||cLimitador;                  -- MLJS 21/12/2020
      cCadenaAux  := TRIM(REPLACE(REPLACE(cDescSiniestro,chr(13),' '),chr(10),' ')) ||cLimitador;     -- MLJS 21/12/2020
      cCadenaAux1 := X.TIPOSEGURO                          ||cLimitador||
                  cNomArchCarga1A                          ||cLimitador||
                  TO_CHAR(dFecCarga1A,'DD/MM/RRRR')        ||cLimitador||
                  X.USUARIO                                ||cLimitador||
                  cNomArchCarga                            ||cLimitador||
                  X.ESCONTRIBUTORIO                        ||cLimitador||
                  X.PORCENCONTRIBUTORIO                    ||cLimitador||
                  X.GIRONEGOCIO                            ||cLimitador||
                  X.TIPONEGOCIO                            ||cLimitador||
                  X.FUENTERECURSOS                         ||cLimitador||
                  X.CODPAQCOMERCIAL                        ||cLimitador||
                  X.CATEGORIA                              ||cLimitador||
                  X.CANALFORMAVENTA                        ||cLimitador||
                  cPolizaCont                              ||cLimitador||
                  TRIM(X.NOMCONTRATANTE)                   ||cLimitador||
                  X.EMPRESA_LABORA                         ||cLimitador||
                  X.CERTIFICADO                            ||cLimitador||
                  X.IDCREDITO                              ||cLimitador||
                  X.RFC_ASEGURADO                          ||cLimitador||
                  X.CURP_ASEGURADO                         ||cLimitador||
                  X.FE_INGRE_CONTRA                        ||cLimitador||
                  X.FE_INGRE_ASEGU                         ||cLimitador||
                  X.SEXO                                   ||cLimitador||
                  X.TP_ASEGURADO                           ||cLimitador||
                  X.ESTADO                                 ||cLimitador||
                  X.NOMESTADO                              ||cLimitador||
                  X.MUNICIPIO                              ||cLimitador||
                  X.NOMMUNICIPIO                           ||cLimitador||
                  X.NOM_MEDICO_CERTIFICA                   ||cLimitador||
                  REPLACE(X.ID_CEDULA_MEDICA,'|','')       ||CHR(13);
  
      nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, trim(cCadena)||trim(cCadenaAux)||trim(cCadenaAux1), 1);
     
      INSERTA_REGISTROS; 
   END LOOP;
   --dbms_output.put_line('MLJS SALIO DE LOOP');
   cNomArchZip := SUBSTR(cNomArchivo, 1, INSTR(cNomArchivo, '.')-1) || '.zip';

   IF XLSX_BUILDER_PKG.EXCEL_GUARDA_LIBRO THEN
      IF ZIP_UTIL_PKG.ZIP_ARCHIVOS(cNomDirectorio, cNomArchZip, cNomArchivo) THEN
         dbms_output.put_line('OK');
      END IF;

      OC_REPORTES_THONA.COPIA_ARCHIVO_BLOB( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomArchZip );
      OC_REPORTES_THONA.INSERTAR_REGISTRO ( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomArchZip );
      COMMIT;
   END IF;

   ENVIA_MAIL;

EXCEPTION
   WHEN OTHERS THEN
   dbms_output.put_line('me fui por el exception');
      OC_ARCHIVO.Eliminar_Archivo(cCodUser);
   RAISE_APPLICATION_ERROR(-20000, 'Error en ESTIMASINIESTROS ' || SQLERRM);
END;

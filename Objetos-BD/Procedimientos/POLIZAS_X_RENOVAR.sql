create or replace PROCEDURE POLIZAS_X_RENOVAR  IS
cLimitador      VARCHAR2(1) :='|';
nLinea          NUMBER;
nLineaimp       NUMBER := 1;

cCadena         VARCHAR2(4000);
cCadenaAux      VARCHAR2(4000);
cCadenaAux1     VARCHAR2(4000);
cCadenaxls      VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;
cDescFormaPago      VARCHAR2(100);
dFecFin             DATE;
cTipoVigencia       VARCHAR2(20);
cIdTipoSeg_loc      DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob_loc        DETALLE_POLIZA.PlanCob%TYPE;
cDescTipoSeg        TIPOS_DE_SEGUROS.Descripcion%TYPE;
cDescPlanCob        PLAN_COBERTURAS.Desc_Plan%TYPE;
nIdPoliza           POLIZAS.IdPoliza%TYPE;
--nCodCia             POLIZAS.CodCia%TYPE;
nCodAgenteN1        AGENTES_DISTRIBUCION_POLIZA.Cod_Agente_Distr%TYPE;
nCodAgenteN2        AGENTES_DISTRIBUCION_POLIZA.Cod_Agente_Distr%TYPE;
nCodAgenteN3        AGENTES_DISTRIBUCION_POLIZA.Cod_Agente_Distr%TYPE;
cNomAgenteN1        VARCHAR2(300);
cNomAgenteN2        VARCHAR2(300);
cNomAgenteN3        VARCHAR2(300);
---
MNTO_PMA_NTA        DETALLE_FACTURAS.MONTO_DET_LOCAL%TYPE;
MNTO_RECFIN         DETALLE_FACTURAS.MONTO_DET_LOCAL%TYPE;
MNTO_DEREMI         DETALLE_FACTURAS.MONTO_DET_LOCAL%TYPE;
MNTO_IVASIN         DETALLE_FACTURAS.MONTO_DET_LOCAL%TYPE;
MNTO_PMA_NTA_NC     Detalle_Notas_De_Credito.MONTO_DET_LOCAL%TYPE;
MNTO_RECFIN_NC      Detalle_Notas_De_Credito.MONTO_DET_LOCAL%TYPE;
MNTO_DEREMI_NC      Detalle_Notas_De_Credito.MONTO_DET_LOCAL%TYPE;
MNTO_IVASIN_NC      Detalle_Notas_De_Credito.MONTO_DET_LOCAL%TYPE;
--
HaySiniestro          NUMBER :=0;
HaySiniestro2         VARCHAR2(1):='N';
nMonto_Reserva_Local  SINIESTRO.MONTO_RESERVA_LOCAL%TYPE;
--                     
nComisionNetaAnual    COMISIONES.COMISION_LOCAL%TYPE;
nComisionNetaAnualFac COMISIONES.COMISION_LOCAL%TYPE;
nComisionNetaAnualNc  COMISIONES.COMISION_LOCAL%TYPE;
--                 
nPrimaTotalAnual      DETALLE_FACTURAS.MONTO_DET_LOCAL%TYPE;
nDerechosEmi          DETALLE_FACTURAS.MONTO_DET_LOCAL%TYPE;
nRecargos             DETALLE_FACTURAS.MONTO_DET_LOCAL%TYPE;
nIvaSin               DETALLE_FACTURAS.MONTO_DET_LOCAL%TYPE; 
nPrimaNeta            DETALLE_FACTURAS.MONTO_DET_LOCAL%TYPE; 
-- 
nMonto_Prima_Total    FACTURAS.MONTO_FACT_LOCAL%TYPE; 
nMonto_NdC_Total      NOTAS_DE_CREDITO.MONTO_NCR_LOCAL%TYPE; 
--
nAgente               AGENTES.COD_AGENTE%TYPE;
nNivel                AGENTES.CODNIVEL%TYPE;
cNombre               varchar2(200);
nJefeAgente           AGENTES.COD_AGENTE%TYPE;
nJefeNivel            AGENTES.CODNIVEL%TYPE;
cJefeNombre           varchar2(200);
nGfeDrAgente          AGENTES.COD_AGENTE%TYPE;
nGfeDrNivel           AGENTES.CODNIVEL%TYPE;
cGfeDrNombre          varchar2(200);
--
W_nDesde              number;
W_nHasta              number;
W_ID_TERMINAL               CONTROL_PROCESOS_AUTOMATICOS.ID_TERMINAL%TYPE;
W_ID_USER                   CONTROL_PROCESOS_AUTOMATICOS.ID_USER%TYPE;
W_ID_ENVIO                  CONTROL_PROCESOS_AUTOMATICOS.ID_ENVIO%TYPE;
--
cCtlArchivo     UTL_FILE.FILE_TYPE;

cNomDirectorio  VARCHAR2(100) ;
--cNomArchivo VARCHAR2(100) := 'RECIBOS_EMITIDOS_AUTOMATICO.XLSX';
cNomArchivo VARCHAR2(100) := 'POLIZAS_RENOVAR_'||to_char(trunc(sysdate - 1),'ddmmyyyy')||'.XLSX';
--cNomArchivo VARCHAR2(100) := 'RECIBOS_EMITIDOS.XLSX';
cNomArchZip           VARCHAR2(100);
cIdTipoSeg            VARCHAR2(50) := '%';
cPlanCob              VARCHAR2(100) := '%';
cCodMoneda            VARCHAR2(5) := '%';
cCodAgente            VARCHAR2(25) := '%';
nCodCia               NUMBER := 1;
nCodEmpresa           NUMBER := 1;
cCodReporte           VARCHAR2(100) := 'POLIXRENOV';
--cCodReporte           VARCHAR2(100) := 'PRIMANETA';
cNomCia               VARCHAR2(100);
cTitulo1              VARCHAR2(200);
cTitulo2              VARCHAR2(200);
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
----------
--  ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;   -- SPEEDFILE RSR 22042016
  LINEA_SALIDA       VARCHAR2(5000);             -- SPEEDFILE RSR 22042016
  WI_ARCHIVO_SALIDA  VARCHAR2(2000);             -- SPEEDFILE RSR 22042016
----------
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
cSubject                    VARCHAR2(1000) := 'Notificacion Archivo de Polizas por Renovar: ';
cTexto1                     VARCHAR2(10000):= 'Apreciable Compañero ';
cTexto2                     varchar2(1000)   := ' Envío archivo de Polizas por Renovar generado de manera automática el día de hoy. ';
cTexto3                     varchar2(10)   := '  ';
cTexto4                     varchar2(1000)   := ' Saludos. ';
----
CURSOR EMI_Q IS 
 SELECT P.IdPoliza,     P.NumPolUnico,    P.NumPolRef,
        P.CodCliente,   P.CodCia,         P.CodEmpresa,
        P.StsPoliza,    P.Cod_Moneda,   
        OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) Contratante, 
        TO_CHAR(P.FecRenovacion,'DD/MM/YYYY')    FecRenovacion,         
        TO_CHAR(P.FecIniVig,'DD/MM/YYYY')        FecIniVig, 
        TO_CHAR(P.FecFinVig,'DD/MM/YYYY')        FecFinVig, P.NumRenov,
        TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY')     FECHA_ELABORACION,
        ( P.FecRenovacion - TRUNC(SYSDATE) )     DIAS_PARA_RENOVACION,
        TO_CHAR(TRUNC(P.FECANUL),'DD/MM/YYYY')   FECANUL,
         --
          DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
          NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
          UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
--          P.CODTIPONEGOCIO                                          CODTIPONEGOCIO,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
--          P.FUENTERECURSOSPRIMA                                     CODFUENTERECURSOS,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,        
          P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
--          P.CODCATEGO                                               CODCATEGO,
          CGO.DESCCATEGO                                            CATEGORIA,
--          P.FORMAVENTA                                              CODCANALFORMAVENTA,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA  
          --
   FROM POLIZAS P,
          POLIZAS_TEXTO_COTIZACION  TXT,
          CATEGORIAS                CGO       
  WHERE P.CodCia             = nCodCia
    AND ( (P.StsPoliza          = 'EMI'  AND 
           P.FecRenovacion     >= dFecDesde
          )
          OR 
          (P.StsPoliza = 'ANU'                  AND 
           (P.FECANUL > ( (dFecDesde)  - 46 )) AND
            P.MOTIVANUL  IN ('FPA', 'CAFP' )    AND 
            P.FecRenovacion >= dFecDesde            
          )
        ) 
    AND P.FecRenovacion     >= dFecdESDE
    AND P.FecRenovacion     <= dFecHasta
    AND EXISTS (SELECT 'S'
                  FROM DETALLE_POLIZA D, AGENTES_DISTRIBUCION_COMISION A
                 WHERE  ((A.Cod_Agente_Distr    = cCodAgente AND cCodAgente != '%')
                    OR  (A.Cod_Agente_Distr LIKE cCodAgente AND cCodAgente = '%'))
                   AND A.IDetPol               = D.IDetPol
                   AND A.IdPoliza              = D.IdPoliza
                   AND A.CodCia                = D.CodCia
                   AND ((D.IdTipoSeg           = cIdTipoSeg AND cIdTipoSeg != '%')
                    OR  (D.IdTipoSeg        LIKE cIdTipoSeg AND cIdTipoSeg = '%'))  
                   AND D.IdPoliza              = P.IdPoliza
                   AND D.CodCia                = P.CodCia)
    --
      --
      AND TXT.CODCIA(+)              = P.CODCIA    
      AND TXT.CODEMPRESA(+)          = P.CODEMPRESA 
      AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
      --
      AND CGO.CODCIA(+)              = P.CODCIA  
      AND CGO.CODEMPRESA(+)          = P.CODEMPRESA 
      AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO 
      AND CGO.CODCATEGO(+)           = P.CODCATEGO
  ORDER BY P.IdPoliza;
--    
CURSOR DET_COMIS_Q IS
 SELECT AD.CodCia,    AD.Cod_Agente_Distr, 
        AD.CodNivel,  AD.Porc_Com_Distribuida
   FROM AGENTES_DISTRIBUCION_POLIZA AD, 
        AGENTES AG
  WHERE AG.CodCia      = AD.CodCia
    AND AG.Cod_Agente  = AD.Cod_Agente_Distr
    AND AD.IDPOLIZA    = nIdPoliza
    AND AD.CodNivel    = 3
  ORDER BY AD.CodNivel;  
--

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
      DBMS_OUTPUT.put_line('JMMD EN INSERTA ENCABEZADO cFormato  '||cFormato||' cNomDirectorio  '||cNomDirectorio||' cNomArchivo  '||cNomArchivo  );
      IF cFormato = 'TEXTO' THEN
         OC_REPORTES_THONA.INSERTAR_REGISTRO( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cEncabez );
      ELSE
         --Obtiene Número de Columnas Totales
         nColsTotales := XLSX_BUILDER_PKG.EXCEL_CUENTA_COLUMNAS(cEncabez);
         --
         DBMS_OUTPUT.put_line('JMMD EN INSERTA ENCABEZADO nColsTotales '||nColsTotales);
         IF XLSX_BUILDER_PKG.EXCEL_CREAR_LIBRO(cNomDirectorio, cNomArchivo) THEN
             DBMS_OUTPUT.put_line('JMMD EN INSERTA ENCABEZADO 1');
            IF XLSX_BUILDER_PKG.EXCEL_CREAR_HOJA(cCodReporte) THEN
               --Titulos
               DBMS_OUTPUT.put_line('JMMD EN INSERTA ENCABEZADO 2');
               nFila := XLSX_BUILDER_PKG.EXCEL_HEADER(nFila + 1, cTitulo1, nColsTotales, nJustCentro, nColsLateral, nColsCentro, nColsMerge);
               nFila := XLSX_BUILDER_PKG.EXCEL_HEADER(nFila + 1, cTitulo2, nColsTotales, nJustCentro, nColsLateral, nColsCentro, nColsMerge);
--               nFila := XLSX_BUILDER_PKG.EXCEL_HEADER(nFila + 1, cTitulo3, nColsTotales, nJustCentro, nColsLateral, nColsCentro, nColsMerge);
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
---------------------------
FUNCTION ORIGEN_RECIBO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                       nIDetPol NUMBER, nIdFactura NUMBER) RETURN VARCHAR2 IS
cOrigenRecibo VARCHAR2(200);
BEGIN
   IF GT_FAI_CONCENTRADORA_FONDO.ES_FACTURA_DE_FONDOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdFactura) = 'N' THEN
      cOrigenRecibo := 'PRIMAS';
   ELSE
      cOrigenRecibo := NULL;
      FOR W IN (SELECT DISTINCT GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(IdFondo) TipoFondo
                  FROM FAI_CONCENTRADORA_FONDO
                 WHERE CodCia           = nCodCia
                   AND CodEmpresa       = nCodEmpresa
                   AND IdPoliza         = nIdPoliza
                   AND IDetPol          = nIDetPol
                   AND CodAsegurado     > 0
                   AND IdFactura        = nIdFactura) LOOP
         IF cOrigenRecibo IS NOT NULL THEN
            cOrigenRecibo := cOrigenRecibo || ', ';
         END IF;
         cOrigenRecibo := cOrigenRecibo || W.TipoFondo;
      END LOOP;
   END IF;
   RETURN(cOrigenRecibo);
END;
PROCEDURE ENVIA_MAIL IS
BEGIN
--------------------------
BEGIN
  select  LOWER(DESCVALLST)
  INTO cEmail1
  from valores_de_listas
  where codlista = 'EMAILPOLRE'
  and codvalor = 'EMAIL1';
EXCEPTION WHEN OTHERS THEN
   cEmail1      := 'jmarquez@thonaseguros.mx';
END;
   DBMS_OUTPUT.put_line('cEmail1  '||cEmail1);

BEGIN
  select  LOWER(DESCVALLST)
  INTO cEmail2
  from valores_de_listas
  where codlista = 'EMAILPOLRE'
  and codvalor = 'EMAIL2';
EXCEPTION WHEN OTHERS THEN
   cEmail2      := NULL;
END;
   DBMS_OUTPUT.put_line('cEmail2  '||cEmail2); 

BEGIN
  select  LOWER(DESCVALLST)
  INTO cEmail3
  from valores_de_listas
  where codlista = 'EMAILPOLRE'
  and codvalor = 'EMAIL3';
EXCEPTION WHEN OTHERS THEN
   cEmail3      := NULL;
END;
   DBMS_OUTPUT.put_line('cEmail3  '||cEmail3);     
---------------------------

   cEmail       := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
   cPwdEmail    := OC_GENERALES.BUSCA_PARAMETRO(1,'022');
 --  cEmail2 := NULL; --'jmmdcbt@prodigy.net.mx';
 --  cEmail1      := 'jmarquez@thonaseguros.mx';
 --  cEmail3      := NULL; --'juanmanuelmarquezd@gmail.com';

   cTextoEnv := cHTMLHeader||cTexto1||cSaltoLinea||cSaltoLinea||cTexto2||cSaltoLinea||cSaltoLinea||
                      cTexto4||cSaltoLinea||cHTMLFooter;

      dbms_output.put_line('se envio correo '||cEmail1||'  directorio  '||cNomDirectorio);
------------
   OC_MAIL.INIT_PARAM;
--
   OC_MAIL.cCtaEnvio   := cEmail;
--
   OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
--
   BEGIN
      OC_MAIL.SEND_EMAIL(cNomDirectorio,cMiMail,cEmail1,cEmail2,cEmail3,cSubject,cTextoEnv,cNomArchZip,NULL,NULL,NULL,cError);
   EXCEPTION
        WHEN OTHERS THEN
             dbms_output.put_line('Error en el envío de notificacion '||cEmail1||' error '||SQLERRM);
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
       VALUES(1,1,cCodReporte,trunc(sysdate),nLineaimp,'REPAUTPOLREN',cNomArchivo,cCadena);
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

    SELECT DESCVALLST
      INTO W_nDesde
    FROM VALORES_DE_LISTAS
    WHERE codlista = 'DIASXRENOV'
      AND CODVALOR = 'NDESDE';

    SELECT DESCVALLST
      INTO W_nHasta
    FROM VALORES_DE_LISTAS
    WHERE codlista = 'DIASXRENOV'
      AND CODVALOR = 'NHASTA';

      INSERT INTO CONTROL_PROCESOS_AUTOMATICOS
      VALUES('POLIZAS_X_RENOVAR',SYSDATE,W_ID_ENVIO,W_ID_USER,W_ID_TERMINAL);
      --
      COMMIT;
      --

     cNomDirectorio := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SO_PATH', 'REPORT');
----
    select 
    TRUNC(sysdate + W_nDesde) first,
    TRUNC(sysdate + W_nHasta) last
  INTO dFecDesde, dFecHasta
  from  dual ;

/*
    select
--    to_date('01/'|| to_char(sysdate, 'MM') ||'/' ||to_char(sysdate, 'YYYY'), 'dd/mm/yyyy') first,
    to_date('01/'|| 01 ||'/' ||to_char(sysdate, 'YYYY'), 'dd/mm/yyyy') first,
    TRUNC(sysdate) last
--    last_day(to_date('01/'|| 8 ||'/'|| to_char(sysdate, 'YYYY'), 'dd/mm/yyyy')) last
  INTO dFecDesde, dFecHasta
  from  dual ;
*/

  DELETE TEMP_REPORTES_THONA
  WHERE  CodCia     = nCodCia
    AND  CodEmpresa = nCodEmpresa
    AND  CodReporte = cCodReporte
    AND  CodUsuario = cCodUser;
  --

   BEGIN
      SELECT NomCia
        INTO cNomCia
        FROM EMPRESAS
       WHERE CodCia = nCodCia;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
      cNomCia := 'COMPAÑIA - NO EXISTE!!!';
   END ;

  dbms_output.put_line('dPrimerDia '||dFecDesde);
  dbms_output.put_line('dUltimoDia '||dFecHasta);
----
--
      nLinea := 1;
--      nLinea := nLinea + 1;

      cTitulo1 := cNomCia;
      cTitulo2 := 'REPORTE DE POLIZAS POR RENOVAR DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY');
      cTitulo4 := ' ';
      -------------------------
      cEncabez    := 'NUMERO_POLIZA'||cLimitador||
                     'ID_NUMERO_POLIZA'||cLimitador||
                     'CONTRATANTE'||cLimitador||
                     'INICIO_VIGENCIA'||cLimitador||
                     'FIN_VIGENCIA'||cLimitador||
                     'FECHA_RENOVACION'||cLimitador|| 
                     'NUMERO_RENOVACION'||cLimitador||
                     'FECHA_ELABORACION'||cLimitador||
                     'DIAS_PARA_RENOVACION'||cLimitador||
                     'ESTATUS'||cLimitador|| 
                     'FECHA_ANULACION'||cLimitador||
                     'MONEDA'||cLimitador||
                     'PRIMA_NETA'||cLimitador|| 
                     'RECARGOS'||cLimitador|| 
                     'DERECHOS'||cLimitador|| 
                     'IVA'||cLimitador||
                     'PRIMA_TOTAL_ANUAL'||cLimitador||
                     'COMISION_AGENTE'||cLimitador||
                     'FORMA_PAGO'||cLimitador|| 
                     'TIPO_SEGURO'||cLimitador||
                     'DESCRIPCION_TIPO_SEGURO'||cLimitador||
                     'PLAN_COBERTURAS'||cLimitador||
                     'DESCRIPCION_PLAN_COBERTURAS'||cLimitador||
                     'AGENTE'||cLimitador|| 
                     'NOMBRE_AGENTE'||cLimitador||
                     'PROMOTOR'||cLimitador|| 
                     'NOMBRE_PROMOTOR'||cLimitador||
                     'DIRECCION_REGIONAL'||cLimitador|| 
                     'NOMBRE_DIRECCION_REGIONAL'||cLimitador||
                     'SINIESTROS_A_FECHA_ELABORACION'||cLimitador||
                     'RESERVA_SINIESTROS_A_FECHA_ELABORACION'||cLimitador||
                     'Es Contributorio'||cLimitador||
                     '% Contributorio'||cLimitador||
                     'Giro de Negocio'||cLimitador||
                     'Tipo de Negocio'||cLimitador||
                     'Fuente de Recursos'||cLimitador||
                     'Paquete Comercial'||cLimitador||
                     'Categoria'||cLimitador||
                     'Canal de Venta'||cLimitador;
         dbms_output.put_line('jmmd 1 NVO'||'  cCodReporte  '||cCodReporte||' cCodUser  '||cCodUser||'  cNomDirectorio  '||cNomDirectorio||' cNomArchivo  '||cNomArchivo  );
         dbms_output.put_line('jmmd 1 NVO'||cEncabez);
--         INSERTA_REGISTROS;

         INSERTA_ENCABEZADO( 'EXCEL', nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo ) ;

         dbms_output.put_line('jmmd3 cNomDirectorio '||cNomDirectorio||' cNomArchivo  '||cNomArchivo );
         --
     nLinea := 6;

      dbms_output.put_line('jmmd5 X cCadena '||cCadena||' cCodUser  '||cCodUser||' nLinea '||nLinea );
  FOR X IN EMI_Q LOOP
      nIdPoliza        := X.IdPoliza;
      nCodCia          := X.CodCia;
            nPrimaTotalAnual := 0;
            nDerechosEmi     := 0;
            nRecargos        := 0;
            nIvaSin          := 0;
      --
      BEGIN
        SELECT DP.IdTipoSeg,    DP.PlanCob
          INTO cIdTipoSeg_loc, cPlanCob_loc
          FROM POLIZAS P,
               DETALLE_POLIZA DP
         WHERE P.IdPoliza  = X.IdPoliza
           AND P.CodCia    = X.CodCia
           --
           AND DP.IDPOLIZA = P.IDPOLIZA
           AND DP.IDETPOL  = (SELECT MAX(DP1.IDETPOL)
                                FROM DETALLE_POLIZA DP1
                               WHERE DP1.IDPOLIZA = P.IDPOLIZA);
      END;
      --      
      cDescTipoSeg := OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(X.CodCia, X.CodEmpresa, cIdTipoSeg_loc);
      cDescPlanCob := OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(X.CodCia, X.CodEmpresa, cIdTipoSeg_loc, cPlanCob_loc);
      --
      IF X.NumRenov = 0 THEN
         cTipoVigencia := '1ER. AÑO';
      ELSE
         cTipoVigencia := 'RENOVACION';
      END IF;
      --
      BEGIN 
        SELECT SUM(DF.MONTO_DET_LOCAL)   
          INTO MNTO_PMA_NTA
          FROM DETALLE_FACTURAS DF, 
               FACTURAS F
         WHERE DF.IDFACTURA = F.IDFACTURA
           AND DF.CODCPTO   NOT IN ('RECFIN', 'DEREMI', 'IVASIN')
           AND DF.IDFACTURA IN (SELECT F.IDFACTURA 
                                  FROM FACTURAS F
                                 WHERE F.IDPOLIZA =  nIdPoliza   
                                   AND F.STSFACT != 'ANU');  
      EXCEPTION 
        WHEN NO_DATA_FOUND THEN
               MNTO_PMA_NTA := 0;
          WHEN OTHERS THEN
               MNTO_PMA_NTA := 0;
      END;
      --
      IF MNTO_PMA_NTA IS NULL THEN MNTO_PMA_NTA := 0; END IF;
      --
      BEGIN     
        SELECT SUM(DF.MONTO_DET_LOCAL)  
               INTO MNTO_RECFIN
          FROM DETALLE_FACTURAS DF, 
               FACTURAS F
         WHERE DF.IDFACTURA = F.IDFACTURA
           AND DF.CODCPTO   IN ('RECFIN')
           AND DF.IDFACTURA IN (SELECT F.IDFACTURA 
                                  FROM FACTURAS F
                                 WHERE F.IDPOLIZA = nIdPoliza   
                                   AND F.STSFACT != 'ANU');
      EXCEPTION 
        WHEN NO_DATA_FOUND THEN
               MNTO_RECFIN := 0;
          WHEN OTHERS THEN
               MNTO_RECFIN := 0;
      END;
      --
      IF MNTO_RECFIN IS NULL THEN MNTO_RECFIN := 0; END IF;
      BEGIN
        SELECT SUM(DF.MONTO_DET_LOCAL) 
          INTO MNTO_DEREMI
          FROM DETALLE_FACTURAS DF, 
               FACTURAS F
         WHERE DF.IDFACTURA = F.IDFACTURA
           AND DF.CODCPTO   IN ('DEREMI')
           AND DF.IDFACTURA IN (SELECT F.IDFACTURA 
                                  FROM FACTURAS F
                                 WHERE F.IDPOLIZA = nIdPoliza   
                                   AND F.STSFACT != 'ANU');
      EXCEPTION 
        WHEN NO_DATA_FOUND THEN
               MNTO_DEREMI := 0;
          WHEN OTHERS THEN
               MNTO_DEREMI := 0;
      END;
      --
      IF MNTO_DEREMI IS NULL THEN MNTO_DEREMI := 0; END IF;
      --

BEGIN
SELECT SUM(DF.MONTO_DET_LOCAL) INTO MNTO_IVASIN
FROM DETALLE_FACTURAS DF, FACTURAS F
   WHERE DF.IDFACTURA = F.IDFACTURA
     AND DF.CODCPTO  IN ('IVASIN')
     AND DF.IDFACTURA IN ( SELECT F.IDFACTURA FROM FACTURAS F
                            WHERE F.IDPOLIZA = nIdPoliza  
                               AND F.STSFACT != 'ANU'
                          ); 
 EXCEPTION WHEN NO_DATA_FOUND THEN
                  MNTO_IVASIN := 0;
             WHEN OTHERS THEN
                  MNTO_IVASIN := 0;
 END;
IF MNTO_IVASIN IS NULL THEN MNTO_IVASIN := 0; END IF;


BEGIN 
 SELECT SUM(DN.MONTO_DET_LOCAL) INTO MNTO_PMA_NTA_NC
  FROM Detalle_Notas_De_Credito DN, NOTAS_DE_CREDITO N
    WHERE  DN.CODCPTO NOT IN ('RECFIN', 'DEREMI', 'IVASIN', 'RETISR', 'RETIVA') 
       AND DN.IDNCR IN ( SELECT N.IDNCR FROM NOTAS_DE_CREDITO N
                        WHERE N.IDPOLIZA = nIdPoliza   
                           AND N.STSNCR != 'ANU'
                       )
   AND N.IDNCR = DN.IDNCR ;
 EXCEPTION WHEN NO_DATA_FOUND THEN
                  MNTO_PMA_NTA_NC := 0;
             WHEN OTHERS THEN
                  MNTO_PMA_NTA_NC := 0;
 END;
IF MNTO_PMA_NTA_NC IS NULL THEN MNTO_PMA_NTA_NC := 0; END IF; 


 BEGIN
    SELECT SUM(DN.MONTO_DET_LOCAL) INTO MNTO_DEREMI_NC
    FROM Detalle_Notas_De_Credito DN, NOTAS_DE_CREDITO N
    WHERE  DN.CODCPTO   IN ( 'DEREMI' ) 
       AND DN.IDNCR IN ( SELECT N.IDNCR FROM NOTAS_DE_CREDITO N
                          WHERE N.IDPOLIZA = nIdPoliza  
                             AND N.STSNCR != 'ANU'
                       )
   AND N.IDNCR = DN.IDNCR ; 
 EXCEPTION WHEN NO_DATA_FOUND THEN
                  MNTO_DEREMI_NC := 0;
             WHEN OTHERS THEN
                  MNTO_DEREMI_NC := 0;
 END;
IF MNTO_DEREMI_NC IS NULL THEN MNTO_DEREMI_NC := 0; END IF; 



BEGIN 
 SELECT SUM(DN.MONTO_DET_LOCAL) INTO MNTO_RECFIN_NC
 FROM Detalle_Notas_De_Credito DN, NOTAS_DE_CREDITO N
    WHERE DN.CODCPTO   IN ( 'RECFIN' ) 
       AND DN.IDNCR IN (SELECT N.IDNCR FROM NOTAS_DE_CREDITO N
                        WHERE N.IDPOLIZA = nIdPoliza   
                        AND N.STSNCR != 'ANU'
                       )
   AND N.IDNCR = DN.IDNCR ;  
 EXCEPTION WHEN NO_DATA_FOUND THEN
                  MNTO_RECFIN_NC := 0;
             WHEN OTHERS THEN
                  MNTO_RECFIN_NC := 0;
 END;
 IF MNTO_RECFIN_NC IS NULL THEN MNTO_RECFIN_NC := 0; END IF; 



BEGIN 
 SELECT SUM(DN.MONTO_DET_LOCAL) INTO MNTO_IVASIN_NC
 FROM Detalle_Notas_De_Credito DN, NOTAS_DE_CREDITO N
    WHERE  DN.CODCPTO   IN ( 'IVASIN' ) 
       AND DN.IDNCR IN (SELECT N.IDNCR FROM NOTAS_DE_CREDITO N
                        WHERE N.IDPOLIZA = nIdPoliza   
                           AND N.STSNCR != 'ANU'
                       )
   AND N.IDNCR = DN.IDNCR ;  
 EXCEPTION WHEN NO_DATA_FOUND THEN
                  MNTO_IVASIN_NC := 0;
             WHEN OTHERS THEN
                  MNTO_IVASIN_NC := 0;
 END;
 IF MNTO_IVASIN_NC IS NULL THEN MNTO_IVASIN_NC := 0; END IF; 


BEGIN
SELECT SUM(F.MONTO_FACT_LOCAL) INTO nMonto_Prima_Total
   FROM FACTURAS F
    WHERE F.IDPOLIZA =  nIdPoliza   
       AND F.STSFACT != 'ANU';
EXCEPTION WHEN NO_DATA_FOUND THEN
                  nMonto_Prima_Total := 0;
             WHEN OTHERS THEN
                  nMonto_Prima_Total := 0;
 END;       
 IF nMonto_Prima_Total IS NULL THEN nMonto_Prima_Total := 0; END IF; 

BEGIN
SELECT SUM(N.MONTO_NCR_LOCAL ) INTO nMonto_NdC_Total
   FROM NOTAS_DE_CREDITO N
  WHERE N.IDPOLIZA = nIdPoliza   
     AND N.STSNCR != 'ANU';
EXCEPTION WHEN NO_DATA_FOUND THEN
                  nMonto_NdC_Total := 0;
             WHEN OTHERS THEN
                  nMonto_NdC_Total := 0;
 END;      
  IF nMonto_NdC_Total IS NULL THEN nMonto_NdC_Total := 0; END IF; 


   nPrimaTotalAnual := nMonto_Prima_Total -  nMonto_NdC_Total;     
  nPrimaNeta        := MNTO_PMA_NTA -  MNTO_PMA_NTA_NC;

  nDerechosEmi     := MNTO_DEREMI - MNTO_DEREMI_NC;                                               
  nRecargos        := MNTO_RECFIN - MNTO_RECFIN_NC;                                                 
  nIvaSin          := MNTO_IVASIN - MNTO_IVASIN_NC;

---   Tiene Siniestro? ---
Select Count(*) INTO HaySiniestro
  FROM SINIESTRO   
 Where idpoliza = nIdPoliza
 ;

Select  SUM(MONTO_RESERVA_LOCAL) INTO nMonto_Reserva_Local
from Siniestro 
where IdPoliza = nIdPoliza
;


 IF HaySiniestro > 0 THEN HaySiniestro2 := 'S';  ELSE HaySiniestro2 := 'N'; END IF;

----------------------------------->
      nCodAgenteN1   := NULL;
      nCodAgenteN2   := NULL;
      nCodAgenteN3   := NULL;
      cNomAgenteN1   := NULL;
      cNomAgenteN2   := NULL;
      cNomAgenteN3   := NULL;
      FOR C IN DET_COMIS_Q LOOP

          BEGIN
             SELECT A1.COD_AGENTE  AGENTE , A1.CODNIVEL NIVEL, OC_AGENTES.NOMBRE_AGENTE(A1.CODCIA, A1.COD_AGENTE) NOMBRE,
                               B2.COD_AGENTE  JEFE_AGENTE , B2.CODNIVEL JEFE_NIVEL, OC_AGENTES.NOMBRE_AGENTE(B2.CODCIA, B2.COD_AGENTE) JEFE_NOMBRE,
                               C3.COD_AGENTE  GFE_JEFE_AGENTE , C3.CODNIVEL GFE_JEFE_NIVEL, OC_AGENTES.NOMBRE_AGENTE(C3.CODCIA, C3.COD_AGENTE) GFE_JEFE_NOMBRE
                        INTO nAgente , nNivel, cNombre,       
                             nJefeAgente , nJefeNivel, cJefeNombre,
                             nGfeDrAgente , nGfeDrNivel, cGfeDrNombre
                        FROM AGENTES  A1,
                             AGENTES  B2,
                             AGENTES  C3
                        WHERE A1.COD_AGENTE  = C.Cod_Agente_Distr
                        AND   B2.COD_AGENTE  = A1.COD_AGENTE_JEFE
                        AND   C3.COD_AGENTE (+) = B2.COD_AGENTE_JEFE
                        ;
          EXCEPTION WHEN NO_DATA_FOUND THEN
                      nAgente     := null;  nNivel     := null; cNombre     := null;       
                                nJefeAgente := null;  nJefeNivel := null; cJefeNombre := null;
                                nGfeDrAgente:= null;  nGfeDrNivel:= null; cGfeDrNombre:= null;                      
                    WHEN OTHERS THEN                        
                      nAgente     := null;  nNivel     := null; cNombre     := null;       
                                nJefeAgente := null;  nJefeNivel := null; cJefeNombre := null;
                                nGfeDrAgente:= null;  nGfeDrNivel:= null; cGfeDrNombre:= null;
          END;  


         IF     nJefeNivel  = 2 THEN    nCodAgenteN2 := nJefeAgente;   cNomAgenteN2 := cJefeNombre;
         ELSIF  nGfeDrNivel = 2 THEN    nCodAgenteN2 := nGfeDrAgente;  cNomAgenteN2 := cGfeDrNombre;
         END IF;            
         IF     nJefeNivel  = 1 THEN    nCodAgenteN1 := nJefeAgente;   cNomAgenteN1 := cJefeNombre;
         ELSIF  nGfeDrNivel = 1 THEN    nCodAgenteN1 := nGfeDrAgente;  cNomAgenteN1 := cGfeDrNombre;
         END IF;        

         IF  C.Codnivel IN (3,4,5) THEN
            nCodAgenteN3    := C.Cod_Agente_Distr;
            cNomAgenteN3    := OC_AGENTES.NOMBRE_AGENTE(X.CodCia, C.Cod_Agente_Distr);

             BEGIN
                     SELECT SUM(COMISION_LOCAL) INTO nComisionNetaAnualFac
                      FROM COMISIONES C,
                      FACTURAS   F
                   WHERE C.IDPOLIZA   = nIdPoliza
                      AND C.COD_AGENTE IN (SELECT COD_AGENTE FROM AGENTES 
                                                       WHERE CODNIVEL IN (3,4,5)
                                                       AND   COD_AGENTE = C.COD_AGENTE
                                                       )--= nCodAgenteN3
                  AND F.IDPOLIZA   = C.IDPOLIZA
                  AND F.IDFACTURA  = C.IDFACTURA
                  AND F.STSFACT   != 'ANU'
                      ;                       
                 EXCEPTION WHEN NO_DATA_FOUND THEN
                              nComisionNetaAnualFac := 0;
                             WHEN OTHERS THEN
                              nComisionNetaAnualFac := 0;
                 END;     
                IF nComisionNetaAnualFac IS NULL THEN nComisionNetaAnualFac:=0; END IF;

                 BEGIN
                     SELECT SUM(COMISION_LOCAL) INTO nComisionNetaAnualNc
                      FROM COMISIONES C,
                     NOTAS_DE_CREDITO   N
                            WHERE C.IDPOLIZA   = nIdPoliza
                              AND C.COD_AGENTE IN (SELECT COD_AGENTE FROM AGENTES 
                                                       WHERE CODNIVEL IN (3,4,5)
                                                       AND   COD_AGENTE = C.COD_AGENTE
                                                       )--= nCodAgenteN3
                              AND N.IDPOLIZA   = C.IDPOLIZA
                              AND N.IDNCR      = C.IDNCR
                              AND N.STSNCR != 'ANU'
                              ;
                 EXCEPTION WHEN NO_DATA_FOUND THEN
                              nComisionNetaAnualNc := 0;
                             WHEN OTHERS THEN
                              nComisionNetaAnualNc := 0;
                 END;

                 IF nComisionNetaAnualNc IS NULL THEN nComisionNetaAnualNc:=0; END IF;

                 nComisionNetaAnual := nComisionNetaAnualFac + nComisionNetaAnualNc;

         ELSE
            nCodAgenteN1    := C.Cod_Agente_Distr;
            cNomAgenteN1    := OC_AGENTES.NOMBRE_AGENTE(X.CodCia, C.Cod_Agente_Distr);
         END IF;
      END LOOP;


      cCadena := TO_CHAR(X.NumPolUnico) ||'|' ||
                           TO_CHAR(X.IdPoliza ,'9999999999999') ||'|' ||                           
                           TO_CHAR(X.Contratante) ||'|' ||
                           TO_CHAR(X.FecIniVig) ||'|' ||
                           TO_CHAR(X.FecFinVig)  ||'|' ||
                           TO_CHAR(X.FecRenovacion)||'|' ||
                           TO_CHAR(TO_CHAR(X.NumRenov)) ||  '|' ||                         
                           TO_CHAR(X.FECHA_ELABORACION) ||'|' ||
                           TO_CHAR(X.DIAS_PARA_RENOVACION,'99990') ||'|' ||                           
                           TO_CHAR(X.StsPoliza) ||'|' ||
                           TO_CHAR(X.FECANUL) ||'|' ||                           
                           TO_CHAR(X.Cod_Moneda) ||'|' ||                 
                           TO_CHAR(nPrimaNeta,'99999999999990.00') ||'|' ||
                           TO_CHAR(nRecargos,'99999999999990.00') ||'|' ||
                           TO_CHAR(nDerechosEmi,'99999999999990.00') ||'|' ||
                           TO_CHAR(nIvaSin,'99999999999990.00') ||  '|' || 
                           TO_CHAR(nPrimaTotalAnual,'99999999999990.00') || '|' ||                                                                      
                           TO_CHAR(nComisionNetaAnual,'99999999999990.00') || '|' ||
                           TO_CHAR(cPlanCob_loc) ||  '|' ||                         
                           TO_CHAR(cIdTipoSeg_loc) || '|' ||
                           TO_CHAR(cDescTipoSeg) ||'|' ||
                           TO_CHAR(cPlanCob_loc) ||'|' ||
                           TO_CHAR(cDescPlanCob) ||'|' ||
                           TO_CHAR(nCodAgenteN3) ||'|' ||
                           TO_CHAR(cNomAgenteN3) ||  '|' ||                                          
                           TO_CHAR(nCodAgenteN2) || '|' ||
                           TO_CHAR(cNomAgenteN2) || '|' ||
                           TO_CHAR(nCodAgenteN1) || '|' ||
                           TO_CHAR(cNomAgenteN1) || '|' ||    
                           TO_CHAR(HaySiniestro) || '|' ||
                           TO_CHAR(nMonto_Reserva_Local,'99999999999990.00') || '|' ||
                           TO_CHAR(X.ESCONTRIBUTORIO) || '|' ||
                           TO_CHAR(X.PORCENCONTRIBUTORIO) || '|' ||
                           TO_CHAR(X.GIRONEGOCIO) || '|' ||
                           TO_CHAR(X.TIPONEGOCIO) || '|' ||
                           TO_CHAR(X.FUENTERECURSOS) || '|' ||
                           TO_CHAR(X.CODPAQCOMERCIAL) || '|' ||
                           TO_CHAR(X.CATEGORIA) || '|' ||
                           TO_CHAR(X.CANALFORMAVENTA) ;

 --     nLinea := nLinea + 1;
 --     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);      
     INSERTA_REGISTROS;

     nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena, 1);      
  END LOOP;    

   DBMS_OUTPUT.put_line('JMMD ANTES DE ZIPEAR EL ARCHIVO ');
   cNomArchZip := SUBSTR(cNomArchivo, 1, INSTR(cNomArchivo, '.')-1) || '.zip';
      dbms_output.put_line('jmmd9 ');
         IF XLSX_BUILDER_PKG.EXCEL_GUARDA_LIBRO THEN
            IF ZIP_UTIL_PKG.ZIP_ARCHIVOS(cNomDirectorio, cNomArchZip, cNomArchivo) THEN
               dbms_output.put_line('OK');
            END IF;
            OC_REPORTES_THONA.COPIA_ARCHIVO_BLOB( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomArchZip );
            OC_REPORTES_THONA.INSERTAR_REGISTRO( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomArchZip);

            COMMIT;
         END IF; 

         ENVIA_MAIL;

EXCEPTION
   WHEN OTHERS THEN
   dbms_output.put_line('me fui por el exception');
      OC_ARCHIVO.Eliminar_Archivo(cCodUser);
   RAISE_APPLICATION_ERROR(-20000, 'Error en POLIZAS_X_RENOVAR ' || SQLERRM);
END;
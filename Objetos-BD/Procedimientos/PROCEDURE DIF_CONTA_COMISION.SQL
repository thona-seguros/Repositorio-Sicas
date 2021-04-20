CREATE OR REPLACE PROCEDURE DIF_CONTA_COMISION  IS
cLimitador      VARCHAR2(1) :='|'; 
nLinea          NUMBER;
nLineaimp       NUMBER := 1;
cCadena         VARCHAR2(4000);

cCodUser        VARCHAR2(30);

W_ID_TERMINAL   VARCHAR2(100);
W_ID_USER       VARCHAR2(100);
W_ID_ENVIO      VARCHAR2(100);
-------------------------
cNumComprob        COMPROBANTES_CONTABLES.NumComprob%TYPE;
nIdNcr            NOTAS_DE_CREDITO.IdNcr%TYPE;
nComision         DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nHonorario        DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nMtoIva           DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nRetISR           DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nRetIVA           DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nCodDirecReg      AGENTES.Cod_Agente%TYPE;
cNombreDirecReg   VARCHAR2(500);
cNumFactExt       FACTURA_EXTERNA.NumFactExt%TYPE;
nMtoComisiCon      NUMBER;
nMtoHonoraCon      NUMBER;
nMtoTotIVACon      NUMBER;
nMtoRetISRCon      NUMBER;
nMtoRetIVACon      NUMBER;
nMtoMontoPCon      NUMBER;
nDifContaPago      NUMBER;
-------------------------
nIdFactura      FACTURAS.IdFactura%TYPE;
cOrigenRecibo VARCHAR2(200);

cNomDirectorio  VARCHAR2(100) ;
cNomArchivo VARCHAR2(100) := 'DIF_CONTA_COM_'||to_char(trunc(sysdate - 1),'ddmmyyyy')||'.XLSX';
cNomArchZip           VARCHAR2(100);

cCodMoneda            VARCHAR2(5) := '%';
cCodAgente            VARCHAR2(25) := '%';
nCodCia               NUMBER := 1;
nCodEmpresa           NUMBER := 1;
cCodReporte           VARCHAR2(100) := 'DIFCONTACOMISION';
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
cSubject                    VARCHAR2(1000) := 'Notificacion Archivo de Diferencias Contables Comision ';
cTexto1                     VARCHAR2(10000):= 'Apreciable Compañero ';
cTexto2                     varchar2(1000)   := ' Envío archivo de Diferencias Contables Comisión generado de manera automática el día de hoy. ';
cTexto3                     varchar2(10)   := '  ';
cTexto4                     varchar2(1000)   := ' Saludos. ';
----

CURSOR NC_Q IS
   SELECT N.IdNcr, N.StsNcr, T.FechaTransaccion, N.FecDevol, N.CodMoneda,
          N.Cod_Agente, OC_AGENTES.NOMBRE_AGENTE(N.CodCia, N.Cod_Agente) NombreAgente,
          T.IdTransaccion, N.Monto_Ncr_Moneda, N.IdNomina, N.CodCia,
          N.CtaLiquidadora,
          OC_NIVEL.DESCRIPCION_NIVEL(N.CodCia, OC_AGENTES.NIVEL_AGENTE(N.CodCia, N.Cod_Agente)) NivelAgente,
          OC_AGENTES.TIPO_AGENTE(N.CodCia, N.Cod_Agente) TipoAgente
     FROM NOTAS_DE_CREDITO N, TRANSACCION T
    WHERE ((N.CodMoneda              = cCodMoneda AND cCodMoneda != '%')
       OR  (N.CodMoneda           LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((N.Cod_Agente             = cCodAgente AND cCodAgente != '%')
       OR  (N.Cod_Agente          LIKE cCodAgente AND cCodAgente = '%'))
      AND N.IdNomina            IS NOT NULL
      AND N.StsNcr                   = 'PAG'
      AND T.IdTransaccion            = N.IdTransacAplic
      AND T.IdProceso               IN (17)   -- Pago de Comisiones
      AND TRUNC(T.FechaTransaccion) >= dFecDesde
      AND TRUNC(T.FechaTransaccion) <= dFecHasta
    ORDER BY N.IdNcr;
--    
CURSOR DET_NC_Q IS
   SELECT D.CodCpto, D.Monto_Det_Moneda, D.IndCptoPrima, C.IndCptoServicio
     FROM DETALLE_NOTAS_DE_CREDITO D, NOTAS_DE_CREDITO N, CATALOGO_DE_CONCEPTOS C
    WHERE C.CodConcepto = D.CodCpto
      AND C.CodCia      = N.CodCia
      AND D.IdNcr       = N.IdNcr
      AND N.IdNcr       = nIdNcr;
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
  where codlista = 'EMAILDICCO'
  and codvalor = 'EMAIL1';
EXCEPTION WHEN OTHERS THEN
   cEmail1      := 'jmarquez@thonaseguros.mx';
END;
   DBMS_OUTPUT.put_line('cEmail1  '||cEmail1);
   
BEGIN
  select  LOWER(DESCVALLST)
  INTO cEmail2
  from valores_de_listas
  where codlista = 'EMAILDICCO'
  and codvalor = 'EMAIL2';
EXCEPTION WHEN OTHERS THEN
   cEmail1      := NULL;
END;
   DBMS_OUTPUT.put_line('cEmail2  '||cEmail2); 
   
BEGIN
  select  LOWER(DESCVALLST)
  INTO cEmail3
  from valores_de_listas
  where codlista = 'EMAILDICCO'
  and codvalor = 'EMAIL3';
EXCEPTION WHEN OTHERS THEN
   cEmail1      := NULL;
END;
   DBMS_OUTPUT.put_line('cEmail3  '||cEmail3);     
---------------------------

   cEmail       := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
   cPwdEmail    := OC_GENERALES.BUSCA_PARAMETRO(1,'022');
--   cEmail2 := NULL; --'jmmdcbt@prodigy.net.mx';
--   cEmail1      := 'jmarquez@thonaseguros.mx';
--   cEmail3      := NULL; --'juanmanuelmarquezd@gmail.com';

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
------------
    BEGIN
    UTL_FILE.fremove (cNomDirectorio, cNomArchZip);
    END;
    
END ENVIA_MAIL;
-------------------------------
PROCEDURE INSERTA_REGISTROS is
BEGIN
       INSERT INTO T_REPORTES_AUTOMATICOS (CODCIA, CODEMPRESA, NOMBRE_REPORTE, FECHA_PROCESO, NUMERO_REGISTRO, CODPLANTILLA,
       NOMBRE_ARCHIVO_EXCEL,CAMPO)
       VALUES(1,1,cCodReporte,trunc(sysdate),nLineaimp,'REPAUTDIFCONCOM',cNomArchivo,cCadena);
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
      VALUES('DIFERENCIA CONTABLE COMISIONES',SYSDATE,W_ID_ENVIO,W_ID_USER,W_ID_TERMINAL);
      --
      COMMIT;
      --

     cNomDirectorio := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SO_PATH', 'REPORT');
----
    select 
    TRUNC(sysdate - 1) first,
    TRUNC(sysdate - 1) last
  INTO dFecDesde, dFecHasta
  from  dual ;
  
/*
    select
--    to_date('01/'|| to_char(sysdate, 'MM') ||'/' ||to_char(sysdate, 'YYYY'), 'dd/mm/yyyy') first,
    to_date('01/'|| 01 ||'/' ||to_char(sysdate, 'YYYY'), 'dd/mm/yyyy') first,
    TRUNC(sysdate) last
--    last_day(to_date('01/'|| 8 ||'/'|| to_char(sysdate, 'YYYY'), 'dd/mm/yyyy')) last
  INTO dFecDesde, dFecHasta
  from  dual ;  */

  DELETE TEMP_REPORTES_THONA
  WHERE  CodCia     = nCodCia
    AND  CodEmpresa = nCodEmpresa
    AND  CodReporte = cCodReporte
    AND  CodUsuario = cCodUser;
  --
 -- COMMIT;

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
    ---
      nLinea := 1;
--      nLinea := nLinea + 1;

      cTitulo1 := cNomCia;
      cTitulo2 := 'REPORTE DE DIFERENCIAS DE COMISIONES DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY');
      cTitulo4 := ' ';
      cEncabez    := 'No. Nota Crédito'||cLimitador||
                    'Código Agente'||cLimitador||
                    'Nombre Agente'||cLimitador||
                    'Fecha de Pago'||cLimitador|| 
                    'Moneda'||cLimitador||
                    'No. de Control'||cLimitador|| 
                    'Cta. Liquidadora'||cLimitador||
                    'Comisiones'||cLimitador||
                    '1622.01.10  y 1622.02.10'||cLimitador||
                    'Honorarios/UDIs'||cLimitador||
                    '2408.01.10 8616 y 8617'||cLimitador||
                    'Total IVA'||cLimitador||
                    '1633.01.10'||cLimitador||
                    'Ret. ISR'||cLimitador||
                    '2605.03.10'||cLimitador||
                    'Ret. IVA'||cLimitador||
                    '2605.12.10'||cLimitador||
                    'Monto del pago'||cLimitador||
                    '2408.01.10 8602, 8606, 8607'||cLimitador||
                    'No. Comprobante'||cLimitador||
                    'Tipo Agte.' ;

         dbms_output.put_line('jmmd 1 NVO'||'  cCodReporte  '||cCodReporte||' cCodUser  '||cCodUser||'  cNomDirectorio  '||cNomDirectorio||' cNomArchivo  '||cNomArchivo  );
         dbms_output.put_line('jmmd 1 NVO'||cEncabez);
         INSERTA_REGISTROS;
--         BEGIN

         INSERTA_ENCABEZADO( 'EXCEL', nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo ) ;

         dbms_output.put_line('jmmd3 cNomDirectorio '||cNomDirectorio||' cNomArchivo  '||cNomArchivo );
         --
     nLinea := 6;
     dbms_output.put_line('jmmd5 '||cCadena);
 --    nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cEncabez, 1);
      dbms_output.put_line('jmmd X cCadena '||cCadena||' cCodUser  '||cCodUser||' nLinea '||nLinea );
   FOR X IN NC_Q LOOP
       nIdNcr          := X.IdNcr;
      nComision       := 0;
      nHonorario      := 0;
      nMtoIva         := 0;
      nRetISR         := 0;
      nRetIVA         := 0;

      BEGIN
         SELECT Cod_Agente_Distr, OC_AGENTES.NOMBRE_AGENTE(CodCia, Cod_Agente_Distr)
           INTO nCodDirecReg, cNombreDirecReg
           FROM AGENTES_DISTRIBUCION_POLIZA
          WHERE CodCia      = X.CodCia
            AND IdPoliza   IN (SELECT MAX(IdPoliza)
                                 FROM COMISIONES C, DETALLE_NOMINA D
                                WHERE C.IdComision = D.IdComision
                                  AND C.CodCia     = D.CodCia
                                  AND D.IdNomina   = X.IdNomina
                                  AND D.CodCia     = X.CodCia)
            AND CodNivel    = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            nCodDirecReg    := 0;
            cNombreDirecReg := 'SIN DIRECCION REGIONAL';
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               SELECT MAX(Cod_Agente_Distr)
                 INTO nCodDirecReg
                 FROM AGENTES_DISTRIBUCION_POLIZA
                WHERE CodCia      = X.CodCia
                  AND IdPoliza   IN (SELECT MAX(IdPoliza)
                                       FROM COMISIONES C, DETALLE_NOMINA D
                                      WHERE C.IdComision = D.IdComision
                                        AND C.CodCia     = D.CodCia
                                        AND D.IdNomina   = X.IdNomina
                                        AND D.CodCia     = X.CodCia)
                  AND CodNivel    = 1;

               cNombreDirecReg := OC_AGENTES.NOMBRE_AGENTE(X.CodCia, nCodDirecReg);
            END;
      END;

      FOR W IN DET_NC_Q LOOP
         IF W.CodCpto = 'RETISR' THEN
            nRetISR   := NVL(nRetISR,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'RETIVA' THEN
            nRetIVA   := NVL(nRetIVA,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'IVASIN' THEN
            nMtoIva   := NVL(nMtoIva,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'HONORA' THEN
             nHonorario := NVL(nHonorario,0) + NVL(W.Monto_Det_Moneda,0);
         ELSE
            nComision   := NVL(nComision,0) + NVL(W.Monto_Det_Moneda,0);
         END IF;
      END LOOP;

      nRetISR := ABS(nRetISR);
      nRetIVA := ABS(nRetIVA);
      nMtoIva := ABS(nMtoIva);

      SELECT NVL(MAX(NumFactExt),'S/F')
        INTO cNumFactExt
        FROM NCR_FACTEXT N, FACTURA_EXTERNA F
       WHERE F.IdeFactExt = N.IdeFactExt
         AND N.IdNcr      = nIdNcr;

      SELECT NVL(MIN(NumComprob),'0')
        INTO cNumComprob
        FROM COMPROBANTES_CONTABLES
       WHERE NumTransaccion = X.IdTransaccion;
       
    ---       
            
      nMtoComisiCon      := nvl(oc_comprobantes_detalle.SUMA_CUENTAS_CONTABLES(cNumComprob, '1', '6', '22', '01', '10'),0) +
                           nvl(oc_comprobantes_detalle.SUMA_CUENTAS_CONTABLES(cNumComprob, '1', '6', '22', '02', '10'),0);
      --                           
      nMtoHonoraCon      := nvl(oc_comprobantes_detalle.SUMA_CUENTAS_CONTABLES(cNumComprob, '2', '4', '08', '01', '10', '8616'),0) +
                           nvl(oc_comprobantes_detalle.SUMA_CUENTAS_CONTABLES(cNumComprob, '2', '4', '08', '01', '10', '8617'),0);
      --                           
      nMtoTotIVACon      := nvl(oc_comprobantes_detalle.SUMA_CUENTAS_CONTABLES(cNumComprob, '1', '6', '33', '01', '10'),0);
      nMtoRetISRCon      := nvl(oc_comprobantes_detalle.SUMA_CUENTAS_CONTABLES(cNumComprob, '2', '6', '05', '03', '10'),0);
      nMtoRetIVACon      := nvl(oc_comprobantes_detalle.SUMA_CUENTAS_CONTABLES(cNumComprob, '2', '6', '05', '12', '10'),0);
      --
      nMtoMontoPCon      := nvl(oc_comprobantes_detalle.SUMA_CUENTAS_CONTABLES(cNumComprob, '2', '4', '08', '01', '10', '8602'),0) +
                           nvl(oc_comprobantes_detalle.SUMA_CUENTAS_CONTABLES(cNumComprob, '2', '4', '08', '01', '10', '8606'),0) +
                           nvl(oc_comprobantes_detalle.SUMA_CUENTAS_CONTABLES(cNumComprob, '2', '4', '08', '01', '10', '8607'),0);       
                           
    ---
    nDifContaPago := (nMtoComisiCon + nMtoHonoraCon + nMtoTotIVACon )- (nMtoRetISRCon + nMtoRetIVACon);

    IF nDifContaPago = nMtoMontoPCon THEN                 
                     
      nDifContaPago := nMtoMontoPCon - nvl(X.Monto_Ncr_Moneda,0);
    
    END IF;

    IF nDifContaPago != 0 THEN
    ---   
--      IF :BK_DATOS.Formato = 'TEXTO' THEN
         cCadena := TO_CHAR(X.IdNcr,'9999999999999')               ||cLimitador||
                    TO_CHAR(X.Cod_Agente,'9999999999999')          ||cLimitador||
                    X.NombreAgente                                 ||cLimitador||
                    TO_CHAR(X.FechaTransaccion,'DD/MM/YYYY')       ||cLimitador||
                    X.CodMoneda                                    ||cLimitador||
                    TO_CHAR(X.IdNomina,'9999999999999')            ||cLimitador||
                    X.CtaLiquidadora                               ||cLimitador||
                    TO_CHAR(nComision,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nMtoComisiCon,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nHonorario,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nMtoHonoraCon,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nMtoIVA,'99999999999990.00')           ||cLimitador||
                    TO_CHAR(nMtoTotIVACon,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nRetISR,'99999999999990.00')           ||cLimitador||
                    TO_CHAR(nMtoRetISRCon,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nRetIVA,'99999999999990.00')           ||cLimitador||
                    TO_CHAR(nMtoRetIVACon,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nvl(X.Monto_Ncr_Moneda,0),'99999999999990.00')||cLimitador||
                    TO_CHAR(nvl(nMtoMontoPCon,0),'99999999999990.00')         ||cLimitador||
                    cNumComprob                                    ||cLimitador||
                    X.TipoAgente ||
                    CHR(13); 
          ----
--     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
 --     OC_REPORTES_THONA.INSERTAR_REGISTRO( 1, 1, 'RECIBOSEMITIDOS', cCodUser, cCadena );
--     dbms_output.put_line('jmmd5 '||cCadena);
     INSERTA_REGISTROS;
     nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena, 1);
     END IF;
   END LOOP;
---------------------------------- 
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
   RAISE_APPLICATION_ERROR(-20000, 'Error en Generación de Listado de Pago de Agentes' || SQLERRM);
END;
/

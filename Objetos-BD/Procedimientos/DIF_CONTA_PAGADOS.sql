PROCEDURE DIF_CONTA_PAGADOS  IS
cLimitador      VARCHAR2(1) :='|'; 
nLinea          NUMBER;
nLineaimp       NUMBER := 1;
cCadena         VARCHAR2(4000);

cCodUser        VARCHAR2(30);

W_ID_TERMINAL   VARCHAR2(100);
W_ID_USER       VARCHAR2(100);
W_ID_ENVIO      VARCHAR2(100);

nIdTransaccion     TRANSACCION.IdTransaccion%TYPE;
nPrimaNeta         DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nReducPrima        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nRecargos          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nDerechos          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nImpuesto          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nPrimaTotal        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nComisionesPEF     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nHonorariosPEF     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nComisionesPEM     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nHonorariosPEM     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nUdisPEM           DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nUdisPEF           DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nCtaRecargos       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nCtaImpuesto       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
-------------------------
nCtaPrimaTotal     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nCtaComisionesPEF  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nCtaHonorarios     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nCtaComisionesPEM  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nCtaUdis           DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nTotComisDist      DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nTotComision       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nDifComis          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
cNumComprob        COMPROBANTES_CONTABLES.NumComprob%TYPE;
cRecibos           VARCHAR2(4000);
cSubGrupos         VARCHAR2(4000);
cEndosos           VARCHAR2(4000);
nTasaIVA           CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
cCodPlanPagos      PLAN_DE_PAGOS.CodPlanPago%TYPE;
-------------------------
nIdFactura      FACTURAS.IdFactura%TYPE;

cOrigenRecibo VARCHAR2(200);

cNomDirectorio  VARCHAR2(100) ;
cNomArchivo VARCHAR2(100) := 'DIF_CONTA_PAG_'||to_char(trunc(sysdate - 1),'ddmmyyyy')||'.XLSX';
cNomArchZip           VARCHAR2(100);
cIdTipoSeg            VARCHAR2(50) := '%';
cPlanCob              VARCHAR2(100) := '%';
cCodMoneda            VARCHAR2(5) := '%';
cCodAgente            VARCHAR2(25) := '%';
nCodCia               NUMBER := 1;
nCodEmpresa           NUMBER := 1;
cCodReporte           VARCHAR2(100) := 'DIFCONTAPAGADOS';
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
cSubject                    VARCHAR2(1000) := 'Notificacion Archivo de Diferencias Contables Pagados ';
cTexto1                     VARCHAR2(10000):= 'Apreciable Compañero ';
cTexto2                     varchar2(1000)   := ' Envío archivo de Diferencias Contables Pagados generado de manera automática el día de hoy. ';
cTexto3                     varchar2(10)   := '  ';
cTexto4                     varchar2(1000)   := ' Saludos. ';
----

CURSOR PAG_Q IS 
   SELECT DISTINCT P.IdPoliza, P.NumPolUnico, /*DP.CodFilial,*/ OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
          OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
          T.FechaTransaccion, P.Cod_Moneda, DP.IdTipoSeg, DP.PlanCob, PC.CodTipoPlan, F.FecPago,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
          P.CodCliente, P.FecIniVig, P.FecFinVig, P.NumRenov, P.CodCia, P.CodEmpresa, T.IdTransaccion
     FROM FACTURAS F, PAGOS PG, TRANSACCION T, POLIZAS P, DETALLE_POLIZA DP, PLAN_COBERTURAS PC
    WHERE PC.PlanCob                 = DP.PlanCob
      AND PC.IdTipoSeg               = DP.IdTipoSeg
      AND PC.CodEmpresa              = DP.CodEmpresa
      AND PC.CodCia                  = DP.CodCia
      AND DP.CodCia                  = F.CodCia
      AND DP.IDetPol                 = F.IDetPol
      AND DP.IdPoliza                = F.IdPoliza
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob AND cPlanCob = '%'))
      AND ((F.Cod_Moneda             = cCodMoneda AND cCodMoneda != '%')
       OR  (F.Cod_Moneda          LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((F.CodGenerador           = cCodAgente AND cCodAgente != '%')
       OR  (F.CodGenerador        LIKE cCodAgente AND cCodAgente = '%'))
      AND P.CodCia                   = F.CodCia
      AND P.IdPoliza                 = F.IdPoliza
      AND T.IdTransaccion            = PG.IdTransaccion
      AND PG.IdFactura               = F.IdFactura
      AND TRUNC(PG.Fecha)           >= dFecDesde
      AND TRUNC(PG.Fecha)           <= dFecHasta
      AND F.StsFact                  = 'PAG'
    ORDER BY T.IdTransaccion;

CURSOR DET_Q IS
   SELECT D.CodCpto, SUM(D.Monto_Det_Moneda) Monto_Det_Moneda, D.IndCptoPrima, C.IndCptoServicio
     FROM DETALLE_FACTURAS D, FACTURAS F, PAGOS P, CATALOGO_DE_CONCEPTOS C
    WHERE C.CodConcepto    = D.CodCpto
      AND C.CodCia         = F.CodCia
      AND D.IdFactura      = F.IdFactura
      AND P.IdTransaccion  = nIdTransaccion
      AND P.IdFactura      = F.IdFactura
      AND TRUNC(P.Fecha)  >= dFecDesde
      AND TRUNC(P.Fecha)  <= dFecHasta
      --AND F.StsFact                 = 'PAG'
    GROUP BY D.CodCpto, D.IndCptoPrima, C.IndCptoServicio;

CURSOR FACT_Q IS
   SELECT F.IdPoliza, F.IdFactura, F.MtoComisi_Moneda
     FROM FACTURAS F, PAGOS P
    WHERE P.IdFactura      = F.IdFactura
      AND P.IdTransaccion  = nIdTransaccion
      AND TRUNC(P.Fecha)  >= dFecDesde
      AND TRUNC(P.Fecha)  <= dFecHasta;
      --AND F.StsFact        = 'PAG';

CURSOR END_Q IS
   SELECT DISTINCT IdEndoso
     FROM FACTURAS F, PAGOS P
    WHERE P.IdFactura      = F.IdFactura
      AND P.IdTransaccion  = nIdTransaccion
      AND TRUNC(P.Fecha)  >= dFecDesde
      AND TRUNC(P.Fecha)  <= dFecHasta
      --AND F.StsFact        = 'PAG'
    ORDER BY IdEndoso;

CURSOR SUBG_Q IS
   SELECT DISTINCT IDetPol
     FROM FACTURAS F, PAGOS P
    WHERE P.IdFactura      = F.IdFactura
      AND P.IdTransaccion  = nIdTransaccion
      AND TRUNC(P.Fecha)  >= dFecDesde
      AND TRUNC(P.Fecha)  <= dFecHasta
      --AND F.StsFact        = 'PAG'
    ORDER BY IDetPol;

CURSOR DET_ConC (P_IdPoliza NUMBER, P_IdFactura NUMBER) IS
   SELECT DCO.CodConcepto, DCO.Monto_Mon_Extranjera,AGE.CODTIPO
     FROM COMISIONES COM, DETALLE_COMISION DCO, AGENTES AGE
    WHERE DCO.CodConcepto IN ('COMISI','COMIPF','COMIPM','HONORA','UDI')
      AND COM.CodCia       = DCO.CodCia 
      AND COM.IdComision   = DCO.IdComision
      AND AGE.COD_AGENTE   = COM.COD_AGENTE
      AND COM.IdPoliza     = P_IdPoliza
      AND COM.IdFactura    = P_IdFactura;    
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
  where codlista = 'EMAILDICPA'
  and codvalor = 'EMAIL1';
EXCEPTION WHEN OTHERS THEN
   cEmail1      := 'jmarquez@thonaseguros.mx';
END;
   DBMS_OUTPUT.put_line('cEmail1  '||cEmail1);

BEGIN
  select  LOWER(DESCVALLST)
  INTO cEmail2
  from valores_de_listas
  where codlista = 'EMAILDICPA'
  and codvalor = 'EMAIL2';
EXCEPTION WHEN OTHERS THEN
   cEmail1      := NULL;
END;
   DBMS_OUTPUT.put_line('cEmail2  '||cEmail2); 

BEGIN
  select  LOWER(DESCVALLST)
  INTO cEmail3
  from valores_de_listas
  where codlista = 'EMAILDICPA'
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
       VALUES(1,1,cCodReporte,trunc(sysdate),nLineaimp,'REPAUTDIFCONPAG',cNomArchivo,cCadena);
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
      VALUES('DIFERENCIAS CONTABLES PAGADOS',SYSDATE,W_ID_ENVIO,W_ID_USER,W_ID_TERMINAL);
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

/*    select
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
      cTitulo2 := 'TRANSACCIONES DE PAGOS DEL  '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY');
      cTitulo4 := ' ';
      cEncabez    := 'No. de Póliza'||cLimitador||'Consecutivo'||cLimitador||'Endoso'||cLimitador||'Sub-Grupo'||cLimitador||'Contratante'||cLimitador|| 
                     'No. Transaccion'||cLimitador||'Fecha Pago'||cLimitador||'Prima Neta'||cLimitador||'Derechos'||cLimitador||
                     'Recargos'||cLimitador||'2704.00.10'||cLimitador||'Impuesto'||cLimitador||'2607.00.10'||cLimitador||
                     'Prima Total'||cLimitador||'1601.01.10/1601.02.10/1604.01.10'||cLimitador||'Comisión Sobre Prima'||cLimitador||
                     'Comisión Persona Fisica'||cLimitador||'2303.01.10'||cLimitador||
                     'Comisión Persona Moral'||cLimitador|| '2303.02.10'||cLimitador||
                     'Honorarios Persona Fisica'||cLimitador||'Honorarios Persona Moral'||cLimitador||
                     'Udis Persona Fisica'||cLimitador||'Udis Persona Moral'||cLimitador||'5309.37.10'||cLimitador||
                     'Dif. en Comisiones'||cLimitador||'Moneda'||cLimitador|| 'Tipo Seguro'||cLimitador||
                     'Plan Coberturas'||cLimitador||'Código SubRamo'||cLimitador||'Descripción SubRamo'||cLimitador||
                     'No. Comprobante'||cLimitador||'Recibos Analizados' ;

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
   FOR X IN PAG_Q LOOP
      nIdTransaccion  := X.IdTransaccion;
      nPrimaNeta      := 0;
      nReducPrima     := 0;
      nRecargos       := 0;
      nDerechos       := 0;
      nImpuesto       := 0;
      nPrimaTotal     := 0;
      nComisionesPEF  := 0;
      nHonorariosPEF  := 0;
      nComisionesPEM  := 0;
      nHonorariosPEM  := 0;
      nUdisPEF        := 0;
      nUdisPEM        := 0;
      nTotComisDist   := 0;
      nTotComision    := 0;

      FOR W IN DET_Q LOOP
         IF W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S' THEN
            nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'RECFIN' THEN
            nRecargos   := NVL(nRecargos,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'DEREMI' THEN
            nDerechos   := NVL(nDerechos,0) + NVL(W.Monto_Det_Moneda,0);
         ELSIF W.CodCpto = 'IVASIN' THEN
            nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
            nTasaIVA    := OC_CONCEPTOS_PLAN_DE_PAGOS.PORCENTAJE_CONCEPTO(X.CodCia, X.CodEmpresa, cCodPlanPagos, W.CodCpto);
         ELSE
            nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
         END IF;
         nPrimaTotal  := NVL(nPrimaTotal,0) + NVL(W.Monto_Det_Moneda,0);
      END LOOP;

      cRecibos  := NULL;
      FOR Z IN FACT_Q LOOP
         IF cRecibos IS NULL THEN
         	  cRecibos  := Z.IdFactura;
         ELSE
            cRecibos  := cRecibos || ' / ' || Z.IdFactura;
         END IF;

      	 nTotComision := NVL(nTotComision,0) + NVL(Z.MtoComisi_Moneda,0);
         FOR C IN DET_ConC (Z.IdPoliza, Z.IdFactura) LOOP
            IF C.CodTipo = 'AGTEPF' THEN --AGENTE PERSONA FISICA
               IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                  nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
               ELSIF C.CodConcepto = 'HONORA' THEN
                  nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
               ELSE
                  NULL;
               END IF;
            ELSIF C.CodTipo = 'AGTEPM' THEN -- AGENTE PERSONA MORAL 
               IF C.CodConcepto IN ('COMISI','COMIPM') THEN
                  nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
               ELSIF C.CodConcepto = 'HONORA' THEN
                  nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
               ELSE
                  NULL;
               END IF;
            ELSIF C.CodTipo = 'HONPF' THEN -- HONORARIOS PERSONA FISICA 
               IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                  nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
               ELSIF C.CodConcepto = 'HONORA' THEN
                  nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
               ELSE
                  NULL;
               END IF;
            ELSIF C.CodTipo = 'HONPM' THEN -- HONORARIOS PERSONA MORAL 
               IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                  nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
               ELSIF C.CodConcepto = 'HONORA' THEN
                  nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
               ELSE
                  NULL;
               END IF;
            ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
               IF C.CodConcepto = 'UDI' THEN
                  nUdisPEF        := NVL(nUdisPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
               ELSE
                  NULL;
               END IF;
            ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL 
               IF C.CodConcepto = 'UDI' THEN
                  nUdisPEM        := NVL(nUdisPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
               ELSE
                  NULL;
               END IF;
            END IF;
            nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
         END LOOP;
      END LOOP;

      nDifComis := NVL(nTotComision,0) - NVL(nTotComisDist,0);

      SELECT NVL(MIN(NumComprob),'0')
        INTO cNumComprob
        FROM COMPROBANTES_CONTABLES
       WHERE NumTransaccion = X.IdTransaccion;

      /*nCtaPrimaNeta      := OC_COMPROBANTES_DETALLE.SUMA_CUENTAS_CONTABLES(cNumComprob, '1', '6', '01', '01', '10') +
                            OC_COMPROBANTES_DETALLE.SUMA_CUENTAS_CONTABLES(cNumComprob, '1', '6', '01', '02', '10') +
                            OC_COMPROBANTES_DETALLE.SUMA_CUENTAS_CONTABLES(cNumComprob, '1', '6', '04', '01', '10');
      nCtaDerechos       := OC_COMPROBANTES_DETALLE.SUMA_CUENTAS_CONTABLES(cNumComprob, '6', '5', '01', '01', '10');*/
      nCtaRecargos       := OC_COMPROBANTES_DETALLE.SUMA_CUENTAS_CONTABLES(cNumComprob, '2', '7', '04', '00', '10');
      nCtaImpuesto       := OC_COMPROBANTES_DETALLE.SUMA_CUENTAS_CONTABLES(cNumComprob, '2', '6', '07', '00', '10');
      nCtaPrimaTotal     := OC_COMPROBANTES_DETALLE.SUMA_CUENTAS_CONTABLES(cNumComprob, '1', '6', '01', '01', '10') +
                            OC_COMPROBANTES_DETALLE.SUMA_CUENTAS_CONTABLES(cNumComprob, '1', '6', '01', '02', '10') +
                            OC_COMPROBANTES_DETALLE.SUMA_CUENTAS_CONTABLES(cNumComprob, '1', '6', '03', '02', '10') +  --ESA 20171218 incluir prima unica
                            OC_COMPROBANTES_DETALLE.SUMA_CUENTAS_CONTABLES(cNumComprob, '1', '6', '04', '01', '10');
      nCtaComisionesPEF  := OC_COMPROBANTES_DETALLE.SUMA_CUENTAS_CONTABLES(cNumComprob, '2', '3', '03', '01', '10');
      nCtaComisionesPEM  := OC_COMPROBANTES_DETALLE.SUMA_CUENTAS_CONTABLES(cNumComprob, '2', '3', '03', '02', '10');
      --nCtaHonorarios     := OC_COMPROBANTES_DETALLE.SUMA_CUENTAS_CONTABLES(cNumComprob, '5', '3', '09', '39', '10');
      nCtaUdis           := OC_COMPROBANTES_DETALLE.SUMA_CUENTAS_CONTABLES(cNumComprob, '5', '3', '09', '37', '10');

      IF NVL(nCtaRecargos,0) != NVL(nRecargos,0) OR NVL(nCtaImpuesto,0) != NVL(nImpuesto,0) OR
      	 NVL(nCtaPrimaTotal,0) != NVL(nPrimaTotal,0) OR NVL(nCtaComisionesPEF,0) != NVL(nComisionesPEF,0) OR
      	 NVL(nCtaComisionesPEM,0) != NVL(nComisionesPEM,0) THEN

         cSubGrupos  := NULL;
         cEndosos    := NULL;

         FOR W IN SUBG_Q LOOP
            IF cSubGrupos IS NULL THEN
               cSubGrupos  := W.IDetPol;
            ELSE
               cSubGrupos  := cSubGrupos || ' / ' || W.IDetPol;
            END IF;
         END LOOP;

         FOR W IN END_Q LOOP
            IF cEndosos IS NULL THEN
               cEndosos  := W.IdEndoso;
            ELSE
               cEndosos  := cEndosos || ' / ' || W.IdEndoso;
            END IF;
         END LOOP;

--      IF :BK_DATOS.Formato = 'TEXTO' THEN
            cCadena := X.NumPolUnico                                  ||cLimitador||
                       TO_CHAR(X.IdPoliza,'9999999999999')            ||cLimitador||
                       cEndosos                                       ||cLimitador||
                       cSubGrupos                                     ||cLimitador||
                       X.Contratante                                  ||cLimitador||
                       TO_CHAR(X.IdTransaccion,'99999999999990')      ||cLimitador||
                       TO_CHAR(X.FecPago,'DD/MM/YYYY')                ||cLimitador||
                       TO_CHAR(nPrimaNeta,'99999999999990.00')        ||cLimitador||
                       TO_CHAR(nDerechos,'99999999999990.00')         ||cLimitador||
                       TO_CHAR(nRecargos,'99999999999990.00')         ||cLimitador||
                       TO_CHAR(nCtaRecargos,'99999999999990.00')      ||cLimitador||
                       TO_CHAR(nImpuesto,'99999999999990.00')         ||cLimitador||
                       TO_CHAR(nCtaImpuesto,'99999999999990.00')      ||cLimitador||
                       TO_CHAR(nPrimaTotal,'99999999999990.00')       ||cLimitador||
                       TO_CHAR(nCtaPrimaTotal,'99999999999990.00')    ||cLimitador||
                       TO_CHAR(nTotComision,'99999999999990.00')      ||cLimitador||
                       TO_CHAR(nComisionesPEF,'99999999999990.00')    ||cLimitador||
                       TO_CHAR(nCtaComisionesPEF,'99999999999990.00') ||cLimitador||
                       TO_CHAR(nComisionesPEM,'99999999999990.00')    ||cLimitador||
                       TO_CHAR(nCtaComisionesPEM,'99999999999990.00') ||cLimitador||
                       TO_CHAR(nHonorariosPEF,'99999999999990.00')    ||cLimitador||
                       TO_CHAR(nHonorariosPEM,'99999999999990.00')    ||cLimitador||
                       TO_CHAR(nCtaHonorarios,'99999999999990.00')    ||cLimitador||
                       TO_CHAR(nUdisPEF,'99999999999990.00')          ||cLimitador||
                       TO_CHAR(nUdisPEM,'99999999999990.00')          ||cLimitador||
                       TO_CHAR(nCtaUdis,'99999999999990.00')          ||cLimitador||
                       TO_CHAR(nDifComis,'99999999999990.00')         ||cLimitador||
                       X.Cod_Moneda                                   ||cLimitador||
                       X.IdTipoSeg                                    ||cLimitador||
                       X.PlanCob                                      ||cLimitador||
                       X.CodTipoPlan                                  ||cLimitador||
                       X.DescSubRamo                                  ||cLimitador||
                       cNumComprob                                    ||cLimitador||
                       cRecibos                                       ||CHR(13);  
          ----
--     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
 --     OC_REPORTES_THONA.INSERTAR_REGISTRO( 1, 1, 'RECIBOSEMITIDOS', cCodUser, cCadena );
--     dbms_output.put_line('jmmd5 '||cCadena);
     INSERTA_REGISTROS;
     nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena, 1);
     END IF;
   END LOOP;

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
/*
      dbms_lob.createtemporary(l_blob, true);
      l_blob := cNomArchZip;
  */
         ENVIA_MAIL;

EXCEPTION
   WHEN OTHERS THEN
   dbms_output.put_line('me fui por el exception');
      OC_ARCHIVO.Eliminar_Archivo(cCodUser);
   RAISE_APPLICATION_ERROR(-20000, 'Error en Generación de Transacciones de Pagos ' || SQLERRM);
END;

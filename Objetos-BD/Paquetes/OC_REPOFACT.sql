CREATE OR REPLACE PACKAGE OC_REPOFACT IS

    PROCEDURE INSERTA_ENCABEZADO( cFormato        VARCHAR2
                               , nCodCia         NUMBER
                               , nCodEmpresa     NUMBER
                               , cCodReporte     VARCHAR2
                               , cCodUser        VARCHAR2
                               , cNomDirectorio  VARCHAR2
                               , cNomArchivo     VARCHAR2
                               , cEncabez        VARCHAR2
                               , cTitulo1        VARCHAR2
                               , cTitulo2        VARCHAR2
                               , cTitulo3        VARCHAR2
                               );
    --
    FUNCTION ORIGEN_RECIBO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                           nIDetPol NUMBER, nIdFactura NUMBER) RETURN VARCHAR2;
    --
    PROCEDURE ENVIA_MAIL (cReporte          VARCHAR2,
                          cNomDirectorio    VARCHAR2,
                          cNomArchZip       VARCHAR2,
                          W_ID_ENVIO        NUMBER,
                          cBuzones          VARCHAR2);
    --
    PROCEDURE INSERTA_REGISTROS (cCodReporte VARCHAR2, nLineaimp IN OUT NUMBER, CODPLANTILLA VARCHAR2, cNomArchivo VARCHAR2, cCadena VARCHAR2, W_ID_ENVIO NUMBER);


    ----------------
    PROCEDURE DEUDOR_X_PRIMAS_COB(nCodCia     NUMBER,
                                  nCodEmpresa NUMBER,
                                  cIdTipoSeg VARCHAR2,
                                  cPlanCob   VARCHAR2,
                                  cCodMoneda VARCHAR2,
                                  cCodAgente VARCHAR2,
                                  dFecFinal   DATE        default trunc(sysdate),
                                  cDestino    VARCHAR2    default 'CORREO',  --  'ARCHIVO', 'CORREO', 'REGISTRO' -- GENERERA EL ARCHIVO PARA DESCARGAR, CORREO, SE ENVIA SEGUN EL USUARIO CONECTADO Y REGISTRO ES PARA DESCARGAR EN TXT
                                  cBuzones      VARCHAR2,
                                  PID_ENVIO  OUT  NUMBER
                                  );
    --
    PROCEDURE PRIMA_NETA_COB (nCodCia     NUMBER,
                              nCodEmpresa NUMBER,
                              cIdTipoSeg VARCHAR2,
                              cPlanCob   VARCHAR2,
                              cCodMoneda VARCHAR2,
                              cCodAgente VARCHAR2,
                              dFecInicio  DATE        default trunc(sysdate),
                              dFecFinal   DATE        default trunc(sysdate),
                              cDestino    VARCHAR2    default 'CORREO',  --  'ARCHIVO', 'CORREO', 'REGISTRO' -- GENERERA EL ARCHIVO PARA DESCARGAR, CORREO, SE ENVIA SEGUN EL USUARIO CONECTADO Y REGISTRO ES PARA DESCARGAR EN TXT
                                  cBuzones      VARCHAR2,
                                  PID_ENVIO  OUT  NUMBER
                              );
    --
    PROCEDURE RECIBOS_ANULADOS_COB (nCodCia     NUMBER,
                                  nCodEmpresa NUMBER,
                                  cIdTipoSeg VARCHAR2,
                                  cPlanCob   VARCHAR2,
                                  cCodMoneda VARCHAR2,
                                  cCodAgente VARCHAR2,
                                  dFecInicio  DATE        default trunc(sysdate),
                                  dFecFinal   DATE        default trunc(sysdate),
                                  cDestino    VARCHAR2    default 'CORREO',  --  'ARCHIVO', 'CORREO', 'REGISTRO' -- GENERERA EL ARCHIVO PARA DESCARGAR, CORREO, SE ENVIA SEGUN EL USUARIO CONECTADO Y REGISTRO ES PARA DESCARGAR EN TXT
                                  cBuzones      VARCHAR2,
                                  PID_ENVIO  OUT  NUMBER
                                  );
    --
    PROCEDURE RECIBOS_EMITIDOS_COB(nCodCia     NUMBER,
                                  nCodEmpresa NUMBER,
                                  cIdTipoSeg VARCHAR2,
                                  cPlanCob   VARCHAR2,
                                  cCodMoneda VARCHAR2,
                                  cCodAgente VARCHAR2,
                                  dFecInicio  DATE        default trunc(sysdate),
                                  dFecFinal   DATE        default trunc(sysdate),
                                  cDestino    VARCHAR2    default 'CORREO',  --  'ARCHIVO', 'CORREO', 'REGISTRO' -- GENERERA EL ARCHIVO PARA DESCARGAR, CORREO, SE ENVIA SEGUN EL USUARIO CONECTADO Y REGISTRO ES PARA DESCARGAR EN TXT
                                  cBuzones      VARCHAR2,
                                  PID_ENVIO  OUT  NUMBER
                                  );
    --
    PROCEDURE RECIBOS_PAGADOS_COB(nCodCia     NUMBER,
                                  nCodEmpresa NUMBER,
                                  cIdTipoSeg VARCHAR2,
                                  cPlanCob   VARCHAR2,
                                  cCodMoneda VARCHAR2,
                                  cCodAgente VARCHAR2,
                                  dFecInicio  DATE        default trunc(sysdate),
                                  dFecFinal   DATE        default trunc(sysdate),
                                  cDestino    VARCHAR2    default 'CORREO',  --  'ARCHIVO', 'CORREO', 'REGISTRO' -- GENERERA EL ARCHIVO PARA DESCARGAR, CORREO, SE ENVIA SEGUN EL USUARIO CONECTADO Y REGISTRO ES PARA DESCARGAR EN TXT
                                  cBuzones      VARCHAR2,
                                  PID_ENVIO  OUT  NUMBER
                                  );
    --
    PROCEDURE EJECUTA_JOB (NOMBREJOB VARCHAR2, PROCEDURE_EXEC VARCHAR2, COMENTARIOS VARCHAR2);
    --
    PROCEDURE REVISA_JOBS (SALIDA IN OUT SYS_REFCURSOR);
    --
    FUNCTION DEVUELVE_CORREO_USUARIO RETURN VARCHAR2;
    --

END OC_REPOFACT;
/
CREATE OR REPLACE PACKAGE BODY OC_REPOFACT IS
    --
    PROCEDURE INSERTA_ENCABEZADO( cFormato        VARCHAR2
                               , nCodCia         NUMBER
                               , nCodEmpresa     NUMBER
                               , cCodReporte     VARCHAR2
                               , cCodUser        VARCHAR2
                               , cNomDirectorio  VARCHAR2
                               , cNomArchivo     VARCHAR2
                               , cEncabez        VARCHAR2
                               , cTitulo1        VARCHAR2
                               , cTitulo2        VARCHAR2
                               , cTitulo3        VARCHAR2
                               ) IS
      --Variables globales para el manejo de los encabezados
      nColsTotales     NUMBER := 0;
      nColsLateral     NUMBER := 0;
      nColsMerge       NUMBER := 0;
      nColsCentro      NUMBER := 0;
      nJustCentro      NUMBER := 3;
      nJustIzquierdo   NUMBER := 1;
      nFila            NUMBER;
      cError           VARCHAR2(200);

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
               nFila := XLSX_BUILDER_PKG.EXCEL_HEADER(nFila + 1, cTitulo1, nColsTotales, nJustIzquierdo, nColsLateral, nColsCentro, nColsMerge);
               nFila := XLSX_BUILDER_PKG.EXCEL_HEADER(nFila + 1, cTitulo2, nColsTotales, nJustIzquierdo, nColsLateral, nColsCentro, nColsMerge);
               nFila := XLSX_BUILDER_PKG.EXCEL_HEADER(nFila + 1, cTitulo3, nColsTotales, nJustIzquierdo, nColsLateral, nColsCentro, nColsMerge);
               nFila := XLSX_BUILDER_PKG.EXCEL_ENCABEZADO(nFila + 2, cEncabez, 1);
            END IF;
         END IF;
      END IF;
      --
    ---EXCEPTION WHEN OTHERS THEN
    --               RAISE_APPLICATION_ERROR(-20225, SQLERRM );
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
    END ORIGEN_RECIBO;
    -------
    PROCEDURE ENVIA_MAIL (cReporte        VARCHAR2,
                          cNomDirectorio  VARCHAR2,
                          cNomArchZip     VARCHAR2,
                          W_ID_ENVIO      NUMBER,
                          cBuzones        VARCHAR2) IS
        cEmail                      USUARIOS.EMAIL%TYPE;
        cPwdEmail                   VARCHAR2(100);
        cEmail1                     CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
        cEmail2                     CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;
        cEmail3                     CORREOS_ELECTRONICOS_PNJ.EMAIL%TYPE;

        cMiMail                     USUARIOS.EMAIL%TYPE := 'notificaciones@thonaseguros.mx';
        cSaltoLinea                 VARCHAR2(5)      := '<br>';
        cHTMLHeader                 VARCHAR2(2000)   := '<html>'                                                                     ||cSaltoLinea||
                                                         '<head>'                                                                     ||cSaltoLinea||
                                                         '<meta http-equiv="Content-Language" content="en/us"/>'                      ||cSaltoLinea||
                                                         '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>'  ||cSaltoLinea||
                                                         '</head><body>'                                                              ||cSaltoLinea;
        cHTMLFooter                VARCHAR2(100)    := '</body></html>';
        cError                      VARCHAR2(1000);
        cTextoEnv                   ENDOSO_TXT_DET.TEXTO%TYPE;
        cSubject                    VARCHAR2(1000) ;
        cTexto1                     VARCHAR2(10000):= 'A quien corresponda:';
        cTexto2                     varchar2(1000) ;
        cTexto4                     varchar2(1000)   := ' Saludos. ';
        ----

    BEGIN
    --------------------------

        IF length(cBuzones) > 0 then
            FOR ENT IN (SELECT rownum num, column_value correo FROM TABLE(SICAS_OC.GT_WEB_SERVICES.SPLIT(cBuzones, ';'))) LOOP
                CASE ENT.NUM
                    WHEN 1 THEN
                        cEmail1 := ent.correo;
                    WHEN 2 THEN
                        cEmail2 := ent.correo;
                    WHEN 3 THEN
                        cEmail3 := ent.correo;
                END CASE;
            END LOOP;
        ELSE
            BEGIN
                SELECT MAX(A),MAX(A),MAX(B)
                 INTO cEmail1,cEmail2,cEmail3
                FROM (SELECT DECODE(codvalor, 'EMAIL1', LOWER(DESCVALLST), NULL) A,
                             DECODE(codvalor, 'EMAIL2', LOWER(DESCVALLST), NULL) B,
                             DECODE(codvalor, 'EMAIL3', LOWER(DESCVALLST), NULL) C
                FROM valores_de_listas
                WHERE codlista = 'EMAILRBOEM');
            EXCEPTION WHEN OTHERS THEN
                 RAISE_APPLICATION_ERROR(-20225, 'No se encontro buzones para el envío del correo con los reportes' );
            END;
        END IF;

        cEmail       := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
        cPwdEmail    := OC_GENERALES.BUSCA_PARAMETRO(1,'022');
        cSubject      := 'Notificacion de la recepción del reporte de "' || cReporte ||'"';
        cTexto2       := '       Se ha enviado el archivo del reporte de "' || cReporte ||'".';

        --cEmail1      := 'cperez@thonaseguros.mx';
        --cEmail2 := NULL; --'jmmdcbt@prodigy.net.mx';
        --cEmail3 := NULL; --'juanmanuelmarquezd@gmail.com';

        cTextoEnv := cHTMLHeader||cTexto1||cSaltoLinea||cSaltoLinea||cTexto2||cSaltoLinea||cSaltoLinea||
                         cTexto4||cSaltoLinea||cHTMLFooter;

        dbms_output.put_line('se envio correo '||cEmail1||'  directorio  '||cNomDirectorio);
        ------------
        OC_MAIL.INIT_PARAM;
        OC_MAIL.cCtaEnvio   := cEmail;
        OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
        --
        BEGIN
           OC_MAIL.SEND_EMAIL(cNomDirectorio,cMiMail,cEmail1,cEmail2,cEmail3,cSubject || '(' || W_ID_ENVIO || ')',cTextoEnv,cNomArchZip,NULL,NULL,NULL,cError);
        EXCEPTION WHEN OTHERS THEN
            dbms_output.put_line('Error en el envío de notificacion '||cEmail1||' error '||SQLERRM);
        END;
        dbms_output.put_line('cNomDirectorio: ' || cNomDirectorio);
        dbms_output.put_line('cNomArchZip: ' || cNomArchZip);
        BEGIN
            UTL_FILE.fremove (cNomDirectorio, cNomArchZip);
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END;
    ------------

    END ENVIA_MAIL;
-------------------------------
--
    PROCEDURE INSERTA_REGISTROS (cCodReporte VARCHAR2, nLineaimp IN OUT NUMBER, CODPLANTILLA VARCHAR2, cNomArchivo VARCHAR2, cCadena VARCHAR2, W_ID_ENVIO NUMBER) is
    BEGIN

           INSERT INTO T_REPORTES_AUTOMATICOS (CODCIA,              CODEMPRESA,         NOMBRE_REPORTE,
                                               FECHA_PROCESO,       NUMERO_REGISTRO,    CODPLANTILLA,
                                               NOMBRE_ARCHIVO_EXCEL,CAMPO,              ID_ENVIO)
                                        VALUES(1,                   1,                  cCodReporte,
                                               trunc(sysdate),      nLineaimp,          CODPLANTILLA,  -- 'DEUDORXPRIMA',
                                               cNomArchivo,         cCadena,            W_ID_ENVIO);
           --
           nLineaimp := nLineaimp +1;
           IF MOD(nLineaimp, 1000) = 0 THEN
                COMMIT;
           END IF;
    END INSERTA_REGISTROS;
    -------------------------------
    PROCEDURE DEUDOR_X_PRIMAS_COB (nCodCia     NUMBER,
                                                      nCodEmpresa   NUMBER,
                                                      cIdTipoSeg    VARCHAR2,
                                                      cPlanCob      VARCHAR2,
                                                      cCodMoneda    VARCHAR2,
                                                      cCodAgente    VARCHAR2,
                                                      dFecFinal     DATE        default trunc(sysdate),
                                                      cDestino      VARCHAR2    default 'CORREO',  --  'ARCHIVO', 'CORREO', 'REGISTRO' -- GENERERA EL ARCHIVO PARA DESCARGAR, CORREO, SE ENVIA SEGUN EL USUARIO CONECTADO Y REGISTRO ES PARA DESCARGAR EN TXT
                                  cBuzones      VARCHAR2,
                                  PID_ENVIO  OUT  NUMBER
                                                      ) IS

            /* PROCEDIMIENTO QUE GENERA DOS SALIDAS, UNO A UNA TABLA Y OTRO GENERA ARCHIVO DE EXCEL*/
            cCodReporte           VARCHAR2(100) := 'DEUDORXPRIMA';
            --
            cLimitador      VARCHAR2(1) :='|';
            nLinea          NUMBER;
            nLineaimp       NUMBER := 1;
            cCadena         VARCHAR2(4000);
            cCadenaAux      VARCHAR2(4000);
            cCadenaAux1     VARCHAR2(4000);
            cCodUser        VARCHAR2(30);
            nDummy          NUMBER;
            cCopy           BOOLEAN;
            W_ID_TERMINAL   VARCHAR2(100);
            W_ID_USER       VARCHAR2(100);
            W_ID_ENVIO      VARCHAR2(100);
            cDescFormaPago  VARCHAR2(100);
            dFecFin         DATE;
            cFecFin         VARCHAR2(10);
            cTipoVigencia   VARCHAR2(20);
            nIdFactura      FACTURAS.IdFactura%TYPE;
            nPrimaNeta      DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nReducPrima     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nRecargos       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nDerechos       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nImpuesto       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nImpuestoHonoPF DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nImpuestoHonoPM DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nImpuestoHonoPFOC DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nImpuestoHonoPMOC DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nPrimaTotal     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nComisionesPEF  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nHonorariosPEF  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nUdisPEF        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nComisionesPEM  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nHonorariosPEM  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nUdisPEM        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nTotComisDist   DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nDifComis       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            cCodPlanPagos   PLAN_DE_PAGOS.CodPlanPago%TYPE;
            cCodGenerador   AGENTE_POLIZA.Cod_Agente%TYPE;
            nTasaIVA        CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
            cDescEstado     PROVINCIA.DescEstado%TYPE;
            cNumComprob     COMPROBANTES_CONTABLES.NumComprob%TYPE;
            nDiasAntiguedad NUMBER(10);
            cRangoAntig     VARCHAR2(20);
            nIdNcr          NOTAS_DE_CREDITO.IdNcr%TYPE;
            cFecEmision     VARCHAR2(10);
            nIdSiniestro    SINIESTRO.IdSiniestro%TYPE;
            cTieneSiniestro VARCHAR2(1);
            ---
            nMtoHonoAge     NUMBER(28,2);
            nMtoComiAge     NUMBER(28,2);
            cTipoAge        AGENTES.CodTipo%TYPE;
            cCodAge         AGENTES.Cod_Agente%TYPE;

            nMtoComiProm    NUMBER(28,2);
            nMtoHonoProm    NUMBER(28,2);
            cTipoProm       AGENTES.CodTipo%TYPE;
            cCodProm        AGENTES.Cod_Agente%TYPE;

            nMtoComiDR      NUMBER(28,2);
            nMtoHonoDR      NUMBER(28,2);
            cTipoDR         AGENTES.CodTipo%TYPE;
            cCodDR          AGENTES.Cod_Agente%TYPE;
            nOtrasCompPF    DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nOtrasCompPM    DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            ----
            --
            cNomDirectorio  VARCHAR2(100) ;
            cNomArchivo     VARCHAR2(100) := 'DEUDOR_PRIMA_'||to_char(trunc(sysdate - 1),'ddmmyyyy')||'.xlsx';
            cNomArchZip           VARCHAR2(100);
            cNomCia               VARCHAR2(100);
            cTitulo1              VARCHAR2(200);
            cTitulo2              VARCHAR2(200);
            cTitulo4              VARCHAR2(200);
            cEncabez              VARCHAR2(5000);
            dFecHasta DATE;
            nIdTipoSeg            DETALLE_POLIZA.IdTipoSeg%TYPE;
            cPlanCobert           PLAN_COBERTURAS.PlanCob%TYPE;
            nFactorPrimaRamo      NUMBER;
            nPrimaTotalLocal      NUMBER;
            --


            CURSOR EMI_Q IS
                SELECT    IdPoliza,
                          NumPolUnico,
                          NumPolRef,
                          CodFilial,
                          Contratante,
                          IdEndoso,
                          IdFactura,
                          FechaTransaccion,
                          FecVenc,
                          FecVenc_C,
                          Cod_Moneda,
                          IdTipoSeg,
                          PlanCob,
                          CodTipoPlan,
                          DescSubRamo,
                          CodCliente,
                          FecIniVig,
                          FecFinVig,
                          NumRenov,
                          CodCia,
                          MtoComisi_Moneda,
                          NumCuota,
                          CodEmpresa,
                          IdTransaccion,
                          StsFact,
                          IDetPol,
                          FolioFactElec,
                          COD_CIA,
                          FECFINVIG_FAC,
                          TIPO_CAMBIO,
                          ESCONTRIBUTORIO,
                          PORCENCONTRIBUTORIO,
                          GIRONEGOCIO,
                          TIPONEGOCIO,
                          FUENTERECURSOS,
                          CODPAQCOMERCIAL,
                          CATEGORIA,
                          CANALFORMAVENTA,
                          MONTOPRIMARETIROMON,
                          MONTOPRIMARETIROLOC,
                          CodRamo,
                          DescRamo,
                          IndMultiramo
                       FROM(
                   SELECT /*+RULE*/
                          DISTINCT
                          P.IdPoliza,
                          P.NumPolUnico,
                          P.NumPolRef,
                          DP.CodFilial,
                          OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
                          F.IdEndoso,
                          F.IdFactura,
                          TO_CHAR(T.FechaTransaccion,'DD/MM/YYYY') FechaTransaccion,
                          TO_CHAR(F.FecVenc,'DD/MM/YYYY') FecVenc,
                          F.FecVenc                       FecVenc_C,
                          F.Cod_Moneda,
                          DP.IdTipoSeg,
                          DP.PlanCob,
                          PC.CodTipoPlan,
                          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
                          P.CodCliente,
                          TO_CHAR(P.FecIniVig,'DD/MM/YYYY') FecIniVig,
                          TO_CHAR(P.FecFinVig,'DD/MM/YYYY') FecFinVig,
                          P.NumRenov,
                          P.CodCia,
                          F.MtoComisi_Moneda,
                          F.NumCuota,
                          P.CodEmpresa,
                          T.IdTransaccion,
                          F.StsFact,
                          F.IDetPol,
                          F.FolioFactElec,
                          P.CODCIA COD_CIA,
                          F.FECFINVIG FECFINVIG_FAC,
                          GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(T.FechaTransaccion),F.Cod_Moneda) TIPO_CAMBIO,
                          DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                          NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                          UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                          P.FUENTERECURSOSPRIMA                                     FUENTERECURSOS,
                          P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                          CGO.DESCCATEGO                                            CATEGORIA,
                          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                          F.MontoPrimaCompMoneda                                    MONTOPRIMARETIROMON,
                          F.MontoPrimaCompLocal                                     MONTOPRIMARETIROLOC,
                          CASE TS.CODTIPOPLAN
                            WHEN '099' THEN
                               OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto)
                            ELSE
                               TS.CODTIPOPLAN
                          END CodRamo,
                          CASE TS.CODTIPOPLAN
                            WHEN '099' THEN
                               OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto))
                            ELSE
                               OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',TS.CODTIPOPLAN)
                            END DescRamo,
                            TS.IndMultiramo
                     FROM
                          TRANSACCION                   T,
                          FACTURAS                      F,
                          POLIZAS                       P,
                          DETALLE_POLIZA                DP,
                          DETALLE_FACTURAS              DF,
                          CATALOGO_DE_CONCEPTOS         C,
                          TIPOS_DE_SEGUROS              TS,
                          PLAN_COBERTURAS               PC,
                          POLIZAS_TEXTO_COTIZACION      TXT,
                          CATEGORIAS                    CGO
                    WHERE T.CODCIA                   = nCodCia
                      AND T.CODEMPRESA               = nCodEmpresa
                      AND TRUNC(T.FECHATRANSACCION)  <= dFecHasta
                      AND T.IdProceso               IN (7, 8, 14, 18) -- Emision, Endosos, Contabilizacion y Rehabilitaciones
                      AND F.CodCia                   = T.CodCia
                      AND F.StsFact                  = 'EMI'
                      AND F.IndContabilizada         = 'S'
                      --
                      AND F.IdTransaccion         = T.IdTransaccion
                      AND  F.IdTransacContab IS NULL
                      AND P.CodCia                   = F.CodCia
                      AND P.IdPoliza                 = F.IdPoliza
                      AND DP.CodCia                  = F.CodCia
                      AND DP.IdPoliza                = F.IdPoliza
                      AND DP.IDetPol                 = F.IDetPol
                      AND DF.IdFactura               = F.IdFactura
                      AND C.CODCIA                   = P.CODCIA
                      AND C.CodCONCEPTO              = DF.CodCpto
                      AND (C.IndCptoPrimas           = 'S' OR C.INDCPTOFONDO = 'S')
                      AND TS.CODCIA                  = DP.CODCIA
                      AND TS.CODEMPRESA              = DP.CODEMPRESA
                      AND TS.IDTIPOSEG               = DP.IDTIPOSEG
                      AND PC.CodCia                  = DP.CodCia
                      AND PC.CodEmpresa              = DP.CodEmpresa
                      AND PC.IdTipoSeg               = DP.IdTipoSeg
                      AND PC.PlanCob                 = DP.PlanCob
                ----
                      AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
                      AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
                      AND F.Cod_Moneda              = nvl(cCodMoneda, F.Cod_Moneda)
                      AND F.CodGenerador            = nvl(cCodAgente, F.CodGenerador)
                -----
                      AND TXT.CODCIA(+)              = P.CODCIA
                      AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
                      AND CGO.CODCIA(+)              = P.CODCIA
                      AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
                      AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
                      AND CGO.CODCATEGO(+)           = P.CODCATEGO
                UNION
                   SELECT /*+RULE*/
                          DISTINCT
                          P.IdPoliza,
                          P.NumPolUnico,
                          P.NumPolRef,
                          DP.CodFilial,
                          OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
                          F.IdEndoso,
                          F.IdFactura,
                          TO_CHAR(T.FechaTransaccion,'DD/MM/YYYY') FechaTransaccion,
                          TO_CHAR(F.FecVenc,'DD/MM/YYYY') FecVenc,
                          F.FecVenc                       FecVenc_C,
                          F.Cod_Moneda,
                          DP.IdTipoSeg,
                          DP.PlanCob,
                          PC.CodTipoPlan,
                          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
                          P.CodCliente,
                          TO_CHAR(P.FecIniVig,'DD/MM/YYYY') FecIniVig,
                          TO_CHAR(P.FecFinVig,'DD/MM/YYYY') FecFinVig,
                          P.NumRenov,
                          P.CodCia,
                          F.MtoComisi_Moneda,
                          F.NumCuota,
                          P.CodEmpresa,
                          T.IdTransaccion,
                          F.StsFact,
                          F.IDetPol,
                          F.FolioFactElec,
                          P.CODCIA COD_CIA,
                          F.FECFINVIG FECFINVIG_FAC,
                          GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(T.FechaTransaccion),F.Cod_Moneda) TIPO_CAMBIO,
                          DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                          NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                          UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                          P.FUENTERECURSOSPRIMA                                     FUENTERECURSOS,
                          P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                          CGO.DESCCATEGO                                            CATEGORIA,
                          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                          F.MontoPrimaCompMoneda                                    MONTOPRIMARETIROMON,
                          F.MontoPrimaCompLocal                                     MONTOPRIMARETIROLOC,
                          CASE TS.CODTIPOPLAN
                            WHEN '099' THEN
                               OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto)
                            ELSE
                               TS.CODTIPOPLAN
                          END CodRamo,
                          CASE TS.CODTIPOPLAN
                            WHEN '099' THEN
                               OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto))
                            ELSE
                               OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',TS.CODTIPOPLAN)
                            END DescRamo,
                            TS.IndMultiramo
                     FROM
                          TRANSACCION                   T,
                          FACTURAS                      F,
                          POLIZAS                       P,
                          DETALLE_POLIZA                DP,
                          DETALLE_FACTURAS              DF,
                          CATALOGO_DE_CONCEPTOS         C,
                          TIPOS_DE_SEGUROS              TS,
                          PLAN_COBERTURAS               PC,
                          POLIZAS_TEXTO_COTIZACION      TXT,
                          CATEGORIAS                    CGO
                    WHERE T.CODCIA                   = nCodCia
                      AND T.CODEMPRESA               = nCodEmpresa
                      AND TRUNC(T.FECHATRANSACCION)  <= dFecHasta
                      AND T.IdProceso               IN (7, 8, 14, 18) -- Emision, Endosos, Contabilizacion y Rehabilitaciones
                      AND F.CodCia                   = T.CodCia
                      AND F.StsFact                  = 'EMI'
                      AND F.IndContabilizada         = 'S'
                      --
                      AND F.IdTransaccion            is not null
                      AND F.IdTransacContab          = T.IdTransaccion
                      AND P.CodCia                   = F.CodCia
                      AND P.IdPoliza                 = F.IdPoliza
                      AND DP.CodCia                  = F.CodCia
                      AND DP.IdPoliza                = F.IdPoliza
                      AND DP.IDetPol                 = F.IDetPol
                      AND DF.IdFactura               = F.IdFactura
                      AND C.CODCIA                   = P.CODCIA
                      AND C.CodCONCEPTO              = DF.CodCpto
                      AND (C.IndCptoPrimas           = 'S' OR C.INDCPTOFONDO = 'S')
                      AND TS.CODCIA                  = DP.CODCIA
                      AND TS.CODEMPRESA              = DP.CODEMPRESA
                      AND TS.IDTIPOSEG               = DP.IDTIPOSEG
                      AND PC.CodCia                  = DP.CodCia
                      AND PC.CodEmpresa              = DP.CodEmpresa
                      AND PC.IdTipoSeg               = DP.IdTipoSeg
                      AND PC.PlanCob                 = DP.PlanCob
                ----
                      AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
                      AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
                      AND F.Cod_Moneda              = nvl(cCodMoneda, F.Cod_Moneda)
                      AND F.CodGenerador            = nvl(cCodAgente, F.CodGenerador)
                -----
                      AND TXT.CODCIA(+)              = P.CODCIA
                      AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
                      AND CGO.CODCIA(+)              = P.CODCIA
                      AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
                      AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
                      AND CGO.CODCATEGO(+)           = P.CODCATEGO
                -----------------
                 UNION
                   SELECT /*+RULE*/
                          DISTINCT
                          P.IdPoliza,                    P.NumPolUnico,
                          P.NumPolRef,                   DP.CodFilial,
                          OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) ||
                             OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
                          F.IdEndoso,                    F.IdFactura,
                          TO_CHAR(T.FechaTransaccion,'DD/MM/YYYY') FechaTransaccion,
                          TO_CHAR(F.FecVenc,'DD/MM/YYYY') FecVenc,
                          F.FecVenc                       FecVenc_C,
                          F.Cod_Moneda,                  DP.IdTipoSeg,
                          DP.PlanCob,                    PC.CodTipoPlan,
                          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
                          P.CodCliente,
                          TO_CHAR(P.FecIniVig,'DD/MM/YYYY') FecIniVig,
                          TO_CHAR(P.FecFinVig,'DD/MM/YYYY') FecFinVig,
                          P.NumRenov,
                          P.CodCia,                      F.MtoComisi_Moneda,
                          F.NumCuota,                    P.CodEmpresa,
                          T.IdTransaccion,               F.StsFact,
                          F.IDetPol,                     F.FolioFactElec,
                          P.CODCIA COD_CIA,              F.FECFINVIG FECFINVIG_FAC,
                          GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(T.FechaTransaccion),F.Cod_Moneda) TIPO_CAMBIO,
                         --
                          DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                          NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                          UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                          P.FUENTERECURSOSPRIMA                                     FUENTERECURSOS,
                          P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                          CGO.DESCCATEGO                                            CATEGORIA,
                          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                          --
                          F.MontoPrimaCompMoneda                                                                        MONTOPRIMARETIROMON,    --> JALV (+) 09/11/2021
                          F.MontoPrimaCompLocal                                                                            MONTOPRIMARETIROLOC,        --> JALV (+) 09/11/2021
                          CASE TS.CODTIPOPLAN
                            WHEN '099' THEN
                               OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto)
                            ELSE
                               TS.CODTIPOPLAN
                          END CodRamo,
                          CASE TS.CODTIPOPLAN
                            WHEN '099' THEN
                               OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto))
                            ELSE
                               OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',TS.CODTIPOPLAN)
                            END DescRamo,
                            TS.IndMultiramo
                     FROM
                          TRANSACCION                   T,
                          FACTURAS                      F,
                          POLIZAS                       P,
                          DETALLE_POLIZA                DP,
                          DETALLE_FACTURAS              DF,
                          CATALOGO_DE_CONCEPTOS         C,
                          TIPOS_DE_SEGUROS              TS,
                          PLAN_COBERTURAS               PC,
                          POLIZAS_TEXTO_COTIZACION      TXT,
                          CATEGORIAS                    CGO
                    WHERE T.CODCIA                   = nCodCia
                      AND T.CODEMPRESA               = nCodEmpresa
                      AND TRUNC(T.FECHATRANSACCION)  > dFecHasta
                      AND F.IDTRANSACCIONANU         = T.IdTransaccion
                      AND F.StsFact                  IN ('ANU','SUS')
                      AND F.IndContabilizada         = 'S'
                      AND EXISTS (SELECT 'S'
                                    FROM TRANSACCION
                                   WHERE CodCia                   = F.CodCia
                                     AND CodEmpresa               = P.CodEmpresa
                                     AND IdTransaccion            = F.IdTransaccion
                                     AND TRUNC(FechaTransaccion)  <= dFecHasta
                                     AND NOT EXISTS (SELECT 'S'
                                                       FROM PAGOS
                                                      WHERE IdFactura     = F.IdFactura
                                                        AND TRUNC(Fecha) <= dFecHasta))
                ----
                      AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
                      AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
                      AND F.Cod_Moneda              = nvl(cCodMoneda, F.Cod_Moneda)
                      AND F.CodGenerador            = nvl(cCodAgente, F.CodGenerador)
                -----
                      AND P.CodCia                   = F.CodCia
                      AND P.IdPoliza                 = F.IdPoliza
                      AND DP.CodCia                  = F.CodCia
                      AND DP.IdPoliza                = F.IdPoliza
                      AND DP.IDetPol                 = F.IDetPol
                      AND DF.IdFactura               = F.IdFactura
                      AND C.CODCIA                   = P.CODCIA
                      AND C.CodCONCEPTO              = DF.CodCpto
                      AND (C.IndCptoPrimas           = 'S' OR C.INDCPTOFONDO = 'S')
                      AND TS.CODCIA                  = DP.CODCIA
                      AND TS.CODEMPRESA              = DP.CODEMPRESA
                      AND TS.IDTIPOSEG               = DP.IDTIPOSEG
                      AND PC.CodCia                  = DP.CodCia
                      AND PC.CodEmpresa              = DP.CodEmpresa
                      AND PC.IdTipoSeg               = DP.IdTipoSeg
                      AND PC.PlanCob                 = DP.PlanCob
                      AND TXT.CODCIA(+)              = P.CODCIA
                      AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
                      AND CGO.CODCIA(+)              = P.CODCIA
                      AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
                      AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
                      AND CGO.CODCATEGO(+)           = P.CODCATEGO
                -----------------
                 UNION
                   SELECT /*+RULE*/
                          DISTINCT
                          P.IdPoliza,                   P.NumPolUnico,
                          P.NumPolRef,                  DP.CodFilial,
                          OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) ||
                             OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
                          F.IdEndoso,                   F.IdFactura,
                          TO_CHAR(T.FechaTransaccion,'DD/MM/YYYY') FechaTransaccion,
                          TO_CHAR(F.FecVenc,'DD/MM/YYYY') FecVenc,
                          F.FecVenc                       FecVenc_C,
                          F.Cod_Moneda,                 DP.IdTipoSeg,
                          DP.PlanCob,                   PC.CodTipoPlan,
                          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
                          P.CodCliente,
                          TO_CHAR(P.FecIniVig,'DD/MM/YYYY') FecIniVig,
                          TO_CHAR(P.FecFinVig,'DD/MM/YYYY') FecFinVig,
                          P.NumRenov,
                          P.CodCia,                     F.MtoComisi_Moneda,
                          F.NumCuota,                   P.CodEmpresa,
                          T.IdTransaccion,              F.StsFact,
                          F.IDetPol,                    F.FolioFactElec,
                          P.CODCIA COD_CIA,             F.FECFINVIG FECFINVIG_FAC,
                          GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(T.FechaTransaccion),F.Cod_Moneda) TIPO_CAMBIO,
                         --
                          DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                          NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                          UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                          P.FUENTERECURSOSPRIMA                                     FUENTERECURSOS,
                          P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                          CGO.DESCCATEGO                                            CATEGORIA,
                          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                          --
                          F.MontoPrimaCompMoneda                                                                        MONTOPRIMARETIROMON,    --> JALV (+) 09/11/2021
                          F.MontoPrimaCompLocal                                                                            MONTOPRIMARETIROLOC,        --> JALV (+) 09/11/2021
                          CASE TS.CODTIPOPLAN
                            WHEN '099' THEN
                               OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto)
                            ELSE
                               TS.CODTIPOPLAN
                          END CodRamo,
                          CASE TS.CODTIPOPLAN
                            WHEN '099' THEN
                               OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto))
                            ELSE
                               OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',TS.CODTIPOPLAN)
                            END DescRamo,
                            TS.IndMultiramo
                     FROM
                          TRANSACCION                   T,
                          FACTURAS                      F,
                          POLIZAS                       P,
                          DETALLE_POLIZA                DP,
                          DETALLE_FACTURAS              DF,
                          CATALOGO_DE_CONCEPTOS         C,
                          TIPOS_DE_SEGUROS              TS,
                          PLAN_COBERTURAS               PC,
                          PAGOS                         PG,
                          POLIZAS_TEXTO_COTIZACION      TXT,
                          CATEGORIAS                    CGO
                    WHERE T.CODCIA                   = nCodCia
                      AND T.CODEMPRESA               = nCodEmpresa
                      AND TRUNC(T.FECHATRANSACCION)  <= dFecHasta
                      AND F.CODCIA                   = nCodCia
                      AND F.StsFact                  IN ('PAG')
                      AND F.IndContabilizada         = 'S'
                      AND F.IdTransaccion            = T.IdTransaccion
                      AND NVL(F.IDTRANSACCONTAB, 1)  = NVL(F.IDTRANSACCONTAB, 1)
                      AND TRUNC(F.FecPago)           > dFecHasta  -- MLJS INC-2271 SE AGREGO TRUNC A LA FECHA DE PAGO
                      AND EXISTS (SELECT 'S'
                                    FROM TRANSACCION
                                   WHERE CodCia                   = F.CodCia
                                     AND CodEmpresa               = P.CodEmpresa
                                     AND IdTransaccion            = F.IdTransaccion
                                     AND TRUNC(FechaTransaccion) <= dFecHasta)
                -----
                      AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
                      AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
                      AND F.Cod_Moneda              = nvl(cCodMoneda, F.Cod_Moneda)
                      AND F.CodGenerador            = nvl(cCodAgente, F.CodGenerador)
                -----
                      AND P.CodCia                   = F.CodCia
                      AND P.IdPoliza                 = F.IdPoliza
                      AND DP.CodCia                  = F.CodCia
                      AND DP.IdPoliza                = F.IdPoliza
                      AND DP.IDetPol                 = F.IDetPol
                      AND DF.IdFactura               = F.IdFactura
                      AND C.CODCIA                   = P.CODCIA
                      AND C.CodCONCEPTO              = DF.CodCpto
                      AND (C.IndCptoPrimas           = 'S' OR C.INDCPTOFONDO = 'S')
                      AND TS.CODCIA                  = DP.CODCIA
                      AND TS.CODEMPRESA              = DP.CODEMPRESA
                      AND TS.IDTIPOSEG               = DP.IDTIPOSEG
                      AND PC.CodCia                  = DP.CodCia
                      AND PC.CodEmpresa              = DP.CodEmpresa
                      AND PC.IdTipoSeg               = DP.IdTipoSeg
                      AND PC.PlanCob                 = DP.PlanCob
                      AND PG.CODCIA                  = P.CODCIA
                      AND PG.CODEMPRESA              = P.CODEMPRESA
                      AND PG.IdFactura               = F.IdFactura
                      AND TXT.CODCIA(+)              = P.CODCIA
                      AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
                      AND CGO.CODCIA(+)              = P.CODCIA
                      AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
                      AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
                      AND CGO.CODCATEGO(+)           = P.CODCATEGO);

            --
            CURSOR DET_Q IS
               SELECT D.CodCpto,              D.Monto_Det_Moneda,
                      D.IndCptoPrima,         C.IndCptoServicio,
                      C.CodTipoPlan
                 FROM DETALLE_FACTURAS      D,
                      FACTURAS              F,
                      CATALOGO_DE_CONCEPTOS C
                WHERE C.CodConcepto = D.CodCpto
                  AND C.CodCia      = F.CodCia
                  AND D.IdFactura   = F.IdFactura
                  AND F.IdFactura   = nIdFactura;
            -----
            CURSOR DET_Q_MR (nCodRamo Varchar2) IS
                     SELECT D.CodCpto,            D.Monto_Det_Moneda,
                            D.IndCptoPrima,       C.IndCptoServicio,
                            OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(nCodCia, nCodEmpresa, nIdTipoSeg, cPlanCobert, C.CodConcepto) RamoPrimas,
                            C.CodTipoPlan
                 FROM DETALLE_FACTURAS      D,
                      FACTURAS              F,
                      CATALOGO_DE_CONCEPTOS C
                WHERE C.CodConcepto = D.CodCpto
                  AND C.CodCia      = F.CodCia
                  AND D.IdFactura   = F.IdFactura
                  AND F.IdFactura   = nIdFactura
                  and nvl(CodTipoPlan, OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(nCodCia, nCodEmpresa, nIdTipoSeg, cPlanCobert, C.CodConcepto)) = nCodRamo;

            -----
            CURSOR DET_ConC (P_IdPoliza NUMBER, p_IdFactura NUMBER) IS
              SELECT DCO.CodConcepto,            DCO.Monto_Mon_Extranjera,
                     AGE.CodTipo,                AGE.CodNivel,
                     COM.Cod_Agente,
                     OC_COMISIONES.MONTO_COMISION (COM.CodCia,COM.idpoliza,AGE.CodNivel,AGE.Cod_Agente,COM.IdFactura,NULL) MtoComision   ----- se metio esta nueva linea
                FROM COMISIONES       COM,
                     DETALLE_COMISION DCO,
                     AGENTES          AGE
               WHERE DCO.CodConcepto IN ('HONORA','COMISI','COMIPF','COMIPM','UDI','IVAHON')
                 AND COM.CodCia     = DCO.CodCia
                 AND COM.IdComision = DCO.IdComision
                 AND AGE.COD_AGENTE = COM.COD_AGENTE
                 AND COM.IdPoliza   = P_IdPoliza
                 AND COM.IdFactura  = p_IdFactura;
            -----

            CURSOR DET_ConC_MR (P_IdPoliza Number, p_idFactura Number ) IS
                    SELECT DCO.CodConcepto, DCO.Monto_Mon_Extranjera,
                             AGE.CodTipo, AGE.CodNivel,
                             COM.Cod_Agente,
                             SUM(OC_COMISIONES.MONTO_COMISION (COM.CodCia,COM.idpoliza,AGE.CodNivel,AGE.Cod_Agente,COM.IdFactura,NULL)) MtoComision,
                             C.CodTipoPlan, COM.IdComision
                        FROM COMISIONES COM, DETALLE_COMISION DCO,
                             AGENTES AGE, CATALOGO_DE_CONCEPTOS C
                     WHERE DCO.CodConcepto IN ('HONORA','COMISI', 'COMIPF', 'COMIPM', 'UDI', 'IVAHON', 'IVASIN', 'COMACC', 'COMVDA', 'HONACC', 'HONVDA')
                         AND COM.CodCia       = DCO.CodCia
                         AND COM.IdComision   = DCO.IdComision
                         AND AGE.COD_AGENTE   = COM.COD_AGENTE
                         AND DCO.CodConcepto  = C.CodConcepto
                         AND COM.idpoliza     = P_IdPoliza
                         AND COM.IdFactura    = p_idFactura
                     GROUP BY DCO.CodConcepto, DCO.Monto_Mon_Extranjera,
                             AGE.CodTipo, AGE.CodNivel,
                             COM.Cod_Agente, C.CodTipoPlan, COM.IdComision
                     ORDER BY COM.IdComision;

            CURSOR NC_Q IS
               SELECT P.IdPoliza,                  P.NumPolUnico,
                      P.NumPolRef,                 DP.CodFilial,
                      OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
                          OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
                      N.IdEndoso,                  N.IdNcr,
                      TO_CHAR(T.FechaTransaccion,'DD/MM/YYYY') FechaTransaccion,
                      TO_CHAR(N.FecDevol,'DD/MM/YYYY') FecDevol,
                      N.FecDevol                       FecDevol_C,
                      N.CodMoneda,                 DP.IdTipoSeg,
                      DP.PlanCob,                  PC.CodTipoPlan,
                      DP.CodPlanPago,
                      OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
                      P.CodCliente,
                      TO_CHAR(P.FecIniVig,'DD/MM/YYYY') FecIniVig,
                      TO_CHAR(P.FecFinVig,'DD/MM/YYYY') FecFinVig,
                      P.NumRenov,
                      P.CodCia,                    N.MtoComisi_Moneda,
                      1 NumCuota,                  P.CodEmpresa,
                      TO_CHAR(N.FecDevol,'DD/MM/YYYY') FecAnul,
                      T.IdTransaccion,
                      N.IDetPol,                   N.FolioFactElec,
                      P.CODCIA COD_CIA,            N.FECFINVIG FECFINVIG_NCR,
                      N.STSNCR,                    GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(N.FecDevol),N.CodMoneda) TIPO_CAMBIO,
                     --
                      DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                      NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                      UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                      DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                      DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
                      P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                      CGO.DESCCATEGO                                            CATEGORIA,
                      DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                      OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(P.CodCia, P.CodEmpresa, PC.IdTipoSeg) CodRamo,
                      OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(P.CodCia, P.CodEmpresa, PC.IdTipoSeg)) DescRamo
                      ,0 MontoPrimaRetiroMon, 0 MontoPrimaRetiroLoc
                      --
                 FROM NOTAS_DE_CREDITO N,
                      TRANSACCION      T,
                      POLIZAS          P,
                      DETALLE_POLIZA   DP,
                      PLAN_COBERTURAS  PC,
                      POLIZAS_TEXTO_COTIZACION  TXT,
                      CATEGORIAS                CGO
                WHERE PC.PlanCob                 = DP.PlanCob
                  AND PC.IdTipoSeg               = DP.IdTipoSeg
                  AND PC.CodEmpresa              = DP.CodEmpresa
                  AND PC.CodCia                  = DP.CodCia
                  AND DP.CodCia                  = N.CodCia
                  AND DP.IDetPol                 = N.IDetPol
                  AND DP.IdPoliza                = N.IdPoliza
                -----
                      AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
                      AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
                      AND n.CodMoneda              = nvl(cCodMoneda, n.CodMoneda)
                      AND n.Cod_agente            = nvl(cCodAgente, n.Cod_agente)
                -----
                  AND P.CodCia                   = N.CodCia
                  AND P.IdPoliza                 = N.IdPoliza
                  AND N.CodCia                   = T.CodCia
                  AND N.StsNcr                   = 'EMI'
                  AND T.IdTransaccion            = N.IdTransaccion
                  AND T.IdProceso               IN (2, 8, 18)   -- Anulacione, Endoso, Rehabilitacion NC ESA 20171023
                  AND TRUNC(T.FechaTransaccion) <= dFecHasta
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
            --      AND P.IDPOLIZA = 41493
                ORDER BY N.IdNcr;

            CURSOR DET_NC_Q IS
               SELECT D.CodCpto,               D.Monto_Det_Moneda*-1 Monto_Det_Moneda,
                      D.IndCptoPrima,          C.IndCptoServicio
                 FROM DETALLE_NOTAS_DE_CREDITO D,
                      NOTAS_DE_CREDITO         N,
                      CATALOGO_DE_CONCEPTOS    C
                WHERE C.CodConcepto = D.CodCpto
                  AND C.CodCia      = N.CodCia
                  AND D.IdNcr       = N.IdNcr
                  AND N.IdNcr       = nIdNcr;

            CURSOR DET_ConC_NCR (nIdPoliza NUMBER, nIdNcr NUMBER) IS
               SELECT DCO.CodConcepto,            DCO.Monto_Mon_Extranjera Monto_Mon_Extranjera,
                      AGE.CodTipo,                AGE.CodNivel,
                      COM.Cod_Agente
                 FROM COMISIONES       COM,
                      DETALLE_COMISION DCO,
                      AGENTES          AGE
                WHERE DCO.CodConcepto IN ('HONORA','COMISI','COMIPF','COMIPM','UDI','IVAHON')
                  AND COM.CodCia     = DCO.CodCia
                  AND COM.IdComision = DCO.IdComision
                  AND AGE.Cod_Agente = COM.Cod_Agente
                  AND COM.IdPoliza   = nIdPoliza
                  AND COM.IdNcr      = nIdNcr;


            ----------------------------

    BEGIN
        --
        SELECT SYS_CONTEXT ('USERENV','CURRENT_USERID'),
               SYS_CONTEXT('userenv', 'terminal'),
               USER
          INTO cCodUser,
               W_ID_TERMINAL,
               W_ID_USER
          FROM DUAL;
        ----

        DELETE FROM T_REPORTES_AUTOMATICOS A
         WHERE A.NOMBRE_REPORTE LIKE cCodReporte || '%'
           AND A.FECHA_PROCESO <= TRUNC(ADD_MONTHS(SYSDATE,-8));
        --
        W_ID_ENVIO := OC_CONTROL_PROCESOS_AUTOMATICO.INSERTA_REGISTRO('DEUDOR_PRIMA_COB', W_ID_TERMINAL);
        DBMS_OUTPUT.PUT_LINE('ID_ENVIO: '|| w_ID_ENVIO);
        --
        PID_ENVIO := W_ID_ENVIO;
        COMMIT;
        --
        cNomDirectorio := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SO_PATH', 'REPORT');
        ----

        SELECT
           NVL(dFecFinal,  TRUNC(sysdate - 1)) last
          INTO dFecHasta
          FROM dual ;

          dbms_output.put_line('dUltimoDia '||dFecHasta);
          --

          BEGIN
             SELECT NomCia
               INTO cNomCia
               FROM EMPRESAS
              WHERE CodCia = nCodCia;
          EXCEPTION WHEN NO_DATA_FOUND THEN
                cNomCia := 'COMPANIA - NO EXISTE!!!';
          END;
          ----
          nLinea := 6;
          --
                  cTitulo1 := cNomCia;
                  cTitulo2 := 'REPORTE DE DEUDOR POR PRIMA HASTA ' || TO_CHAR(dFecHasta,'DD/MM/YYYY');
                  cTitulo4 := ' ';
                  cEncabez := 'No. de Póliza'||cLimitador||
                         'Consecutivo'||cLimitador||
                         'No. Referencia'||cLimitador||
                         'Sub-Grupo'||cLimitador||
                         'Contratante'||cLimitador||
                         'No. de Endoso'||cLimitador||
                         'Tipo'||cLimitador||
                         'No. Recibo'||cLimitador||
                         'Estatus Recibo'||cLimitador||
                         'Forma de Pago'||cLimitador||
                         'Fecha Emisión'||cLimitador||
                         'Inicio Vigencia'||cLimitador||
                         'Fin Vigencia'||cLimitador||
                         'Dias Antiguedad'||cLimitador||
                         'Antiguedad'||cLimitador||
                         'Prima Neta'||cLimitador||
                         'Reducción Prima'||cLimitador||
                         'Recargos'||cLimitador||
                         'Derechos'||cLimitador||
                         'Impuesto'||cLimitador||
                         'Prima Total'||cLimitador||
                         'Compensación Sobre Prima'||cLimitador||
                         'Comisión Persona Fisica'||cLimitador||
                         'Comisión Persona Moral'||cLimitador||
                         'Honorarios Persona Física'||cLimitador||
                         'Impuesto Honorarios P. Física'||cLimitador||
                         'Honorarios Persona Moral'||cLimitador||
                         'Impuesto Honorarios P. Moral'||cLimitador||
                         'Otras Compensaciones Fisicas'||cLimitador||
                         'Impuesto Otras Compensaciones P. Física'||cLimitador||
                         'Otras Compensaciones Morales'||cLimitador||
                         'Impuesto Otras Compensaciones P. Moral'||cLimitador||
                         'Dif. en Comisiones'||cLimitador||
                         'Comisión Agente'||cLimitador||
                         'Honorario Agente'||cLimitador||
                         'Agente'||cLimitador||
                         'Tipo Agente'||cLimitador||
                         'Comisión Promotor'||cLimitador||
                         'Honorario Promotor'||cLimitador||
                         'Promotor'||cLimitador||
                         'Tipo Promotor'||cLimitador||
                         'Comisión Dirección Regional'||cLimitador||
                         'Honorario Dirección Regional'||cLimitador||
                         'Dirección Regional'||cLimitador||
                         'Tipo Dirección Regional'||cLimitador||
                         'Tasa IVA'||cLimitador||
                         'Estado'||cLimitador||
                         'Moneda'||cLimitador||
                         'Tipo Cambio'||cLimitador||
                         'Tipo Seguro'||cLimitador||
                         'Plan Coberturas'||cLimitador||
                         'Código SubRamo'||cLimitador||
                         'Descripción SubRamo'||cLimitador||
                         'Tipo Vigencia'||cLimitador||
                         'No. Cuota'||cLimitador||
                         'Inicio Vig. Póliza'||cLimitador||
                         'Fin Vig. Póliza'||cLimitador||
                         'No. Renovacion'||cLimitador||
                         'No. Comprobante'||cLimitador||
                         'Tiene Siniestro'||cLimitador||
                         'No. 1er. Siniestro'||cLimitador||
                         'Folio Fact. Electrónica'||cLimitador ||
                       'Es Contributorio'||cLimitador ||
                       '% Contributorio'||cLimitador ||
                       'Giro de Negocio'||cLimitador ||
                       'Tipo de Negocio'||cLimitador ||
                       'Fuente de Recursos'||cLimitador ||
                       'Paquete Comercial'||cLimitador ||
                       'Categoria'||cLimitador ||
                       'Canal de Venta'||cLimitador ||
                         'Prima de Retiro Moneda'||cLimitador||
                         'Prima de Retiro Local'||cLimitador||
                         'Codigo Ramo'||cLimitador||
                         'Descripcion Ramo'||CHR(13);
            --
            dbms_output.put_line(cEncabez);
            --
            IF UPPER(cDestino) != 'REGISTRO' THEN
                INSERTA_ENCABEZADO( 'EXCEL', nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo, cEncabez, cTitulo1, cTitulo2, cTitulo4) ;
            END IF;

            dbms_output.put_line('cNomDirectorio '||cNomDirectorio||' cNomArchivo  '||cNomArchivo );

            FOR X IN EMI_Q LOOP
             nIdFactura      := X.IdFactura;
             cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
             cDescFormaPago  := OC_FACTURAS.FRECUENCIA_PAGO(X.CodCia, X.IdFactura);
             dFecFin         := X.FECFINVIG_FAC;
             cFecFin         := TO_CHAR(dFecFin,'dd/mm/yyyy');
    ----
                nIdTipoSeg            := X.IdTipoSeg;
                cPlanCobert            := X.PlanCob;
    ----
          IF X.FecVenc_C <= TRUNC(dFecHasta) THEN
             nDiasAntiguedad := dFecHasta - X.FecVenc_C;
          ELSE
             nDiasAntiguedad := 0;
          END IF;

          IF nDiasAntiguedad <= 30 THEN
             cRangoAntig   := '1 A 30';
          ELSIF nDiasAntiguedad <= 45 THEN
             cRangoAntig   := '31 A 45';
          ELSIF nDiasAntiguedad <= 60 THEN
             cRangoAntig   := '46 A 60';
          ELSIF nDiasAntiguedad <= 90 THEN
             cRangoAntig   := '61 A 90';
          ELSIF nDiasAntiguedad <= 120 THEN
             cRangoAntig   := '91 A 120';
          ELSIF nDiasAntiguedad > 120 THEN
             cRangoAntig   := 'MAS DE 120';
          ELSE
             cRangoAntig   := 'NO DEFINIDO';
          END IF;

          BEGIN
             SELECT OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes)
               INTO cDescEstado
               FROM CLIENTES C, PERSONA_NATURAL_JURIDICA P
              WHERE P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
                AND P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
                AND C.CodCliente              = X.CodCliente;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                cDescEstado := NULL;
          END;
          IF cDescEstado = 'PROVINCIA NO EXISTE' THEN
               cDescEstado := NULL;
          END IF;

          IF X.NumRenov = 0 THEN
             cTipoVigencia := '1ER. AÑO';
          ELSE
             cTipoVigencia := 'RENOVACION';
          END IF;

          nPrimaNeta      := 0;
          nReducPrima     := 0;
          nRecargos       := 0;
          nDerechos       := 0;
          nImpuesto       := 0;
          nPrimaTotal     := 0;
          nComisionesPEF  := 0;
          nHonorariosPEF  := 0;
          nUdisPEF        := 0;
          nComisionesPEM  := 0;
          nHonorariosPEM  := 0;
          nUdisPEM        := 0;
          nTotComisDist   := 0;
          nMtoComiAge     := 0;
          nMtoHonoAge     := 0;
          nMtoComiProm    := 0;
          nMtoHonoProm    := 0;
          nMtoComiDR      := 0;
          nMtoHonoDR      := 0;
          --
          cTipoAge        := 0;
          cCodAge         := 0;
          cTipoProm       := 0;
          cCodProm        := 0;
          cTipoDR         := 0;
          cCodDR          := 0;
          --
          nImpuestoHonoPF := 0;
          nImpuestoHonoPM    := 0;
          nImpuestoHonoPFOC := 0;
          nImpuestoHonoPMOC    := 0;
          nOtrasCompPF        := 0;
          nOtrasCompPM        := 0;
          --
    -----
          IF NVL(X.IndMultiramo,'N') = 'N' THEN
    -----
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
    -----
                  ELSE
    ----------------
                      FOR W IN DET_Q_MR(X.CodRamo) LOOP
                         IF (W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S')  THEN
                            nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(W.Monto_Det_Moneda,0);
                         ELSIF W.CodCpto IN ('RECVDA','RECACC')  AND W.CodTipoPlan = X.CodRamo THEN
                            nRecargos   := NVL(nRecargos,0) + NVL(W.Monto_Det_Moneda,0);
                         ELSIF W.CodCpto IN ('DEREVI', 'DEREAP') AND W.CodTipoPlan = X.CodRamo THEN
                            nDerechos   := NVL(nDerechos,0) + NVL(W.Monto_Det_Moneda,0);
                         ELSIF W.CodCpto = 'IVASIN' AND X.CodRamo =  OC_VALORES_DE_LISTAS.BUSCA_LVALOR('RAMOIVA', W.CodCpto) THEN
                            nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
                            nTasaIVA    := OC_CONCEPTOS_PLAN_DE_PAGOS.PORCENTAJE_CONCEPTO(X.CodCia, X.CodEmpresa, cCodPlanPagos, W.CodCpto);
                         ELSE
                            NULL; --nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
                         END IF;
                         --nPrimaTotal  := NVL(nPrimaTotal,0) + NVL(W.Monto_Det_Moneda,0);
                         nPrimaTotal  := NVL(nPrimaNeta,0) + NVL(nRecargos,0) + NVL(nDerechos,0) + NVL(nImpuesto,0);
                      END LOOP;
    ----------------
            END IF;
          IF NVL(X.IndMultiramo,'N') = 'N' THEN
    -----
              FOR C IN DET_ConC (X.IdPoliza,X.IdFactura) LOOP
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
    ------------------
             ELSIF C.CodTipo = 'HONPF' THEN -- HONORARIOS PERSONA FISICA
                IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                   nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSIF C.CodConcepto = 'HONORA' THEN
                   nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                       ELSIF C.CodConcepto = 'IVAHON' THEN
                    nImpuestoHonoPF   := NVL(nImpuestoHonoPF,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                ELSE
                   NULL;
                END IF;
             ELSIF C.CodTipo = 'HONPM' THEN -- HONORARIOS PERSONA MORAL
                IF C.CodConcepto IN ('COMISI','COMIPM') THEN
                   nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSIF C.CodConcepto = 'HONORA' THEN
                   nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                       ELSIF C.CodConcepto = 'IVAHON' THEN
                    nImpuestoHonoPM  := NVL(nImpuestoHonoPM,0) + NVL(C.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                ELSE
                   NULL;
                END IF;

    ------------------
             ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
                IF C.CodConcepto = 'UDI' THEN
    --               nUdisPEF        := NVL(nUdisPEF,0) + NVL(C.Monto_Mon_Extranjera,0);  jmmd20190523 se cambia por nOtrasCompPF
                   nOtrasCompPF    := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSE
                   NULL;
                END IF;
             ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL
                IF C.CodConcepto = 'UDI' THEN
    --               nUdisPEM        := NVL(nUdisPEM,0) + NVL(C.Monto_Mon_Extranjera,0);  jmmd20190523 se cambia por nOtrasCompPM
                   nOtrasCompPM    := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSE
                   NULL;
                END IF;
    ---- jmmd20190523Se incluyen los conceptos para HONORF y HONORM
             ELSIF C.CODTIPO = 'HONORF' THEN -- HONORARIOS PERSONA FISICA
                                IF C.CodConcepto = 'HONORA' THEN
                           nOtrasCompPF  := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                          ELSIF C.CodConcepto = 'IVAHON' THEN
                            nImpuestoHonoPFOC   := NVL(nImpuestoHonoPFOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                   ELSE
                     NULL;
                   END IF;
             ELSIF C.CODTIPO = 'HONORM' THEN -- HONORARIOS PERSONA MORAL
                     IF C.CodConcepto = 'HONORA' THEN
                           nOtrasCompPM  := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                          ELSIF C.CodConcepto = 'IVAHON' THEN
                            nImpuestoHonoPMOC   := NVL(nImpuestoHonoPMOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                   ELSE
                      NULL;
                   END IF;

    ------------------
             END IF;
             nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);

             --
             IF C.CodNivel in (3,4)  THEN                                                                --MLJS 27/05/2022 SE AGREGA EL NIVEL 4
                            cTipoAge            := C.CodTipo;
                            cCodAge                := C.Cod_Agente;
                            IF C.CodTipo IN ('HONPM','HONPF','HONORM') AND C.CodConcepto = 'HONORA' THEN --MLJS 27/05/2022 SE AGREGA EL TIPO HONORM
                   nMtoHonoAge        := NVL(C.Monto_Mon_Extranjera,0);
                            ELSE
                   nMtoComiAge        := NVL(C.Monto_Mon_Extranjera,0);
                          END IF;
                     ELSIF C.CodNivel = 2 THEN
                            cTipoProm            := C.CodTipo;
                            cCodProm             := C.Cod_Agente;
                            IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                                nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
                            ELSE
                  nMtoComiProm    := NVL(C.Monto_Mon_Extranjera,0);
                          END IF;
               ELSIF C.CodNivel = 1 THEN
                            cTipoDR                := C.CodTipo;
                            cCodDR                 := C.Cod_Agente;
                            IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                                nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
                ELSE
                   nMtoComiDR        := NVL(C.Monto_Mon_Extranjera,0);
                          END IF;
               END IF;
            END LOOP;
    -----
                ELSE

            FOR C IN DET_ConC_MR (X.IdPoliza,X.IdFactura) LOOP
    ------------------------
                 IF C.CodTipo = 'AGTEPF' THEN --AGENTE PERSONA FISICA
                    IF C.CodConcepto IN ('COMISI','COMIPF','COMACC', 'COMVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                       nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                    ELSE
                       NULL;
                    END IF;
                 ELSIF C.CodTipo = 'AGTEPM' THEN -- AGENTE PERSONA MORAL
                    IF C.CodConcepto IN ('COMISI','COMIPM', 'COMACC', 'COMVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                       nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                    ELSE
                       NULL;
                    END IF;

    ------------------
                 ELSIF C.CodTipo = 'HONPF' THEN -- HONORARIOS PERSONA FISICA
                    IF C.CodConcepto IN ('COMISI','COMIPF', 'HONACC', 'HONVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                       nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                           ELSIF C.CodConcepto IN ('IVAHON') THEN
                        nImpuestoHonoPF   := NVL(nImpuestoHonoPF,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                    ELSE
                       NULL;
                    END IF;
                 ELSIF C.CodTipo = 'HONPM' THEN -- HONORARIOS PERSONA MORAL
                    IF C.CodConcepto IN ('COMISI','COMIPM', 'HONACC', 'HONVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                       nHonorariosPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);   --- CAMBIAR POR VARIABLE CORRECTA
                           ELSIF C.CodConcepto IN ('IVAHON') THEN
                        nImpuestoHonoPM  := NVL(nImpuestoHonoPM,0) + NVL(C.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                    ELSE
                       NULL;
                    END IF;

    ------------------
             ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
                IF C.CodConcepto = 'UDI' THEN
    --               nUdisPEF        := NVL(nUdisPEF,0) + NVL(C.Monto_Mon_Extranjera,0);  jmmd20190523 se cambia por nOtrasCompPF
                   nOtrasCompPF    := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSE
                   NULL;
                END IF;
             ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL
                IF C.CodConcepto = 'UDI' THEN
    --               nUdisPEM        := NVL(nUdisPEM,0) + NVL(C.Monto_Mon_Extranjera,0);  jmmd20190523 se cambia por nOtrasCompPM
                   nOtrasCompPM    := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSE
                   NULL;
                END IF;
    ---- jmmd20190523Se incluyen los conceptos para HONORF y HONORM
             ELSIF C.CODTIPO = 'HONORF' THEN -- HONORARIOS PERSONA FISICA
                                IF C.CodConcepto = 'HONORA' THEN
                           nOtrasCompPF  := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                          ELSIF C.CodConcepto = 'IVAHON' THEN
                            nImpuestoHonoPFOC   := NVL(nImpuestoHonoPFOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                   ELSE
                     NULL;
                   END IF;
             ELSIF C.CODTIPO = 'HONORM' THEN -- HONORARIOS PERSONA MORAL
                     IF C.CodConcepto = 'HONORA' THEN
                           nOtrasCompPM  := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                          ELSIF C.CodConcepto = 'IVAHON' THEN
                            nImpuestoHonoPMOC   := NVL(nImpuestoHonoPMOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                   ELSE
                      NULL;
                   END IF;

    ------------------
             END IF;
     --        nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
                  IF C.CodConcepto = 'IVASIN' THEN
                       NULL;
                 ELSE
                         nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
                 END IF;
             --
    ------------------ hoy
                 IF C.CodNivel IN (3,4)  THEN                                                  --MLJS 27/05/2022 SE AGREGA EL NIVEL 4
                                cTipoAge            := C.CodTipo;
                                cCodAge                := C.Cod_Agente;
                                IF C.CodTipo IN ('HONPM','HONPF','HONORM') AND C.CodConcepto IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                      nMtoHonoAge        := NVL(C.Monto_Mon_Extranjera,0);                    --MLJS 27/05/2022 SE AGREGA EL TIPO HONORM
                                ELSIF C.CodTipo NOT IN ('HONPM','HONPF','HONORM') AND C.CodConcepto NOT IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                      nMtoComiAge        := NVL(C.Monto_Mon_Extranjera,0);                    --MLJS 27/05/2022 SE AGREGA EL TIPO HONORM
                                END IF;
                        ----
                         ELSIF C.CodNivel = 2 THEN
                                cTipoProm            := C.CodTipo;
                                cCodProm             := C.Cod_Agente;
                                IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                                    nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
                                ELSIF C.CodTipo NOT IN ('HONPM','HONPF') AND C.CodConcepto NOT IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                      nMtoComiProm    := NVL(C.Monto_Mon_Extranjera,0);
                                END IF;
                        ----
                   ELSIF C.CodNivel = 1 THEN
                                cTipoDR                := C.CodTipo;
                                cCodDR                 := C.Cod_Agente;
                                IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                                    nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
                    ELSIF C.CodTipo NOT IN ('HONPM','HONPF') AND C.CodConcepto NOT IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                       nMtoComiDR        := NVL(C.Monto_Mon_Extranjera,0);
                    END IF;    --JMMD asi estaba , se cambio por el de abajo para desglosar mas las validaciones
                        ----
                   END IF;
            END LOOP;
           END IF;

            nPrimaTotalLocal    := OC_DETALLE_FACTURAS.MONTO_PRIMAS(X.IdTransaccion);
            nFactorPrimaRamo    := OC_FACTURAR.FACTOR_PRORRATEO_RAMO(X.CodCia, X.IdPoliza, X.IDetPol, X.CodRamo, nPrimaTotalLocal);
            nDifComis := NVL(X.MtoComisi_Moneda,0) - NVL(nTotComisDist,0);

            SELECT NVL(MIN(NumComprob),'0')
            INTO cNumComprob
            FROM COMPROBANTES_CONTABLES
           WHERE CODCIA         = X.COD_CIA
             AND NumTransaccion = X.IdTransaccion;

          IF X.StsFact = 'ANU' THEN
               SELECT TO_CHAR(FechaTransaccion,'DD/MM/YYYY')
                 INTO cFecEmision
               FROM TRANSACCION
              WHERE IdTransaccion IN (SELECT IdTransaccion
                                        FROM FACTURAS
                                       WHERE IdFactura = X.IdFactura
                                         AND CodCia    = X.CodCia);
          ELSE
             cFecEmision := X.FechaTransaccion;
          END IF;

          IF OC_SINIESTRO.TIENE_SINIESTRO(X.CodCia, X.IdPoliza, X.IDetPol, dFecHasta) = 'S' THEN
             cTieneSiniestro := 'S';
             SELECT NVL(MIN(IdSiniestro),0)
               INTO nIdSiniestro
               FROM SINIESTRO
              WHERE CodCia             = X.CodCia
                AND IdPoliza           = X.IdPoliza
                AND IDetPol            = X.IDetPol
                AND Fec_Notificacion  <= dFecHasta
                AND Sts_Siniestro NOT IN ('SOL','ANU');
          ELSE
             cTieneSiniestro := 'N';
             nIdSiniestro    := 0;
          END IF;

          cCadena := X.NumPolUnico                                  ||cLimitador||
                        TO_CHAR(X.IdPoliza,'9999999999999')            ||cLimitador||
                        X.NumPolRef                                    ||cLimitador||
                        X.IDETPOL                                      ||cLimitador||
                        X.Contratante                                  ||cLimitador||
                        TO_CHAR(X.IdEndoso,'9999999999999')            ||cLimitador||
                        'RECIBO'                                       ||cLimitador||
                        TO_CHAR(X.IdFactura,'9999999999990')           ||cLimitador||
                        X.STSFACT                                      ||cLimitador||
                        cDescFormaPago                                 ||cLimitador||
                        cFecEmision                                    ||cLimitador||
                        X.FecVenc                                      ||cLimitador||
                        cFecFin                                        ||cLimitador||
                        TO_CHAR(nDiasAntiguedad,'99990')               ||cLimitador||
                        cRangoAntig                                    ||cLimitador||
                        TO_CHAR(nPrimaNeta,'99999999999990.00')        ||cLimitador||
                        TO_CHAR(nReducPrima,'99999999999990.00')       ||cLimitador||
    --                    TO_CHAR(NVL(X.MontoPrimaRetiroMon,0),'99999999999990.00')        ||cLimitador|| --> JALV (+) 09/11/2021
    --                    TO_CHAR(NVL(X.MontoPrimaRetiroLoc,0),'99999999999990.00')        ||cLimitador||    --> JALV (+) 09/11/2021
                        TO_CHAR(nRecargos,'99999999999990.00')         ||cLimitador||
                        TO_CHAR(nDerechos,'99999999999990.00')         ||cLimitador||
                        TO_CHAR(nImpuesto,'99999999999990.00')         ||cLimitador||
                        TO_CHAR(nPrimaTotal,'99999999999990.00')       ||cLimitador||
                        TO_CHAR(X.MtoComisi_Moneda * nFactorPrimaRamo,'99999999999990.00')||cLimitador||   ----- JMMD
                        TO_CHAR(nComisionesPEF,'99999999999990.00')    ||cLimitador||
                        TO_CHAR(nComisionesPEM,'99999999999990.00')    ||cLimitador||
                        TO_CHAR(nHonorariosPEF,'99999999999990.00')    ||cLimitador||
                        TO_CHAR(nImpuestoHonoPF,'99999999999990.00')   ||cLimitador||  ---- jmmd20190530 nImpuestoHono Nuevo concepto para proyecto de honorarios
                        TO_CHAR(nHonorariosPEM,'99999999999990.00')    ||cLimitador||
                        TO_CHAR(nImpuestoHonoPM,'99999999999990.00')   ||cLimitador||  ---- jmmd20190530 nImpuestoHono Nuevo concepto para proyecto de honorarios
                        TO_CHAR(nOtrasCompPF,'99999999999990.00')          ||cLimitador||
                        TO_CHAR(nImpuestoHonoPFOC,'99999999999990.00')   ||cLimitador||  ---- jmmd20190530 nImpuestoHono Nuevo concepto para proyecto de honorarios
                        TO_CHAR(nOtrasCompPM,'99999999999990.00')          ||cLimitador||
                        TO_CHAR(nImpuestoHonoPMOC,'99999999999990.00')   ||cLimitador||  ---- jmmd20190530 nImpuestoHono Nuevo concepto para proyecto de honorarios
                        TO_CHAR(nDifComis,'99999999999990.00')         ||cLimitador||
                        TO_CHAR(nMtoComiAge,'99999999999990.00')       ||cLimitador||
                        TO_CHAR(nMtoHonoAge,'99999999999990.00')       ||cLimitador||
                        LPAD(cCodAge,6,'0')                            ||cLimitador||
                        cTipoAge                                                                             ||cLimitador||
                        TO_CHAR(nMtoComiProm,'99999999999990.00')      ||cLimitador||
                        TO_CHAR(nMtoHonoProm,'99999999999990.00')      ||cLimitador||
                        LPAD(cCodProm,6,'0')                                                     ||cLimitador||
                        cTipoProm                                                                             ||cLimitador||
                        TO_CHAR(nMtoComiDR,'99999999999990.00')        ||cLimitador||
                        TO_CHAR(nMtoHonoDR,'99999999999990.00')        ||cLimitador||
                        LPAD(cCodDR,6,'0')                                                         ||cLimitador||
                        cTipoDR                                                                                 ||cLimitador||
                        TO_CHAR(nTasaIVA,'999990.00')                  ||cLimitador||
                        cDescEstado                                    ||cLimitador||
                        X.Cod_Moneda                                   ||cLimitador||
                        X.Tipo_Cambio                                  ||cLimitador||
                        X.IdTipoSeg                                    ||cLimitador||
                        X.PlanCob                                      ||cLimitador||
                        X.CodTipoPlan                                  ||cLimitador||
                        X.DescSubRamo                                  ||cLimitador||
                        cTipoVigencia                                  ||cLimitador||
                        TO_CHAR(X.NumCuota,'99990')                    ||cLimitador||
                        X.FecIniVig                                    ||cLimitador||
                        X.FecFinVig                                    ||cLimitador||
                        TO_CHAR(X.NumRenov,'99990')                    ||cLimitador||
                        cNumComprob                                    ||cLimitador||
                        cTieneSiniestro                                ||cLimitador||
                        TO_CHAR(nIdSiniestro,'9999999999990')          ||cLimitador||
                        X.FolioFactElec                                ||cLimitador||
                        X.ESCONTRIBUTORIO                              ||cLimitador||
                        X.PORCENCONTRIBUTORIO                          ||cLimitador||
                        X.GIRONEGOCIO                                  ||cLimitador||
                        X.TIPONEGOCIO                                  ||cLimitador||
                        X.FUENTERECURSOS                               ||cLimitador||
                        X.CODPAQCOMERCIAL                              ||cLimitador||
                        X.CATEGORIA                                    ||cLimitador||
                        X.CANALFORMAVENTA                              ||cLimitador||
                        TO_CHAR(NVL(X.MontoPrimaRetiroMon,0),'99999999999990.00')   ||cLimitador|| --> JALV (+) 09/11/2021
                        TO_CHAR(NVL(X.MontoPrimaRetiroLoc,0),'99999999999990.00')   ||cLimitador||
                        X.CodRamo                                                                                                                                                                                                                                                                                                                                                                                    ||cLimitador||
                        X.DescRamo                                     ||CHR(13);
                --
                IF UPPER(cDestino) != 'REGISTRO' THEN
                    nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena, 1);
                ELSE
                    INSERTA_REGISTROS(cCodReporte, nLineaimp, 'DEUDORXPRIMA', cNomArchivo, cCadena, W_ID_ENVIO);
                END IF;
                --
           END LOOP;

           FOR X IN NC_Q LOOP
             nIdNcr          := X.IdNcr;
          cDescFormaPago  := 'DIRECTO';
          cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
          dFecFin         := X.FECFINVIG_NCR;
          cFecFin         := TO_CHAR(dFecFin,'dd/mm/yyyy');


          IF X.FecDevol_C <= TRUNC(dFecHasta) THEN
             nDiasAntiguedad := dFecHasta - X.FecDevol_C;
          ELSE
             nDiasAntiguedad := 0;
          END IF;

          IF nDiasAntiguedad <= 30 THEN
             cRangoAntig   := '1 A 30';
          ELSIF nDiasAntiguedad <= 45 THEN
             cRangoAntig   := '31 A 45';
          ELSIF nDiasAntiguedad <= 60 THEN
             cRangoAntig   := '46 A 60';
          ELSIF nDiasAntiguedad <= 90 THEN
             cRangoAntig   := '61 A 90';
          ELSIF nDiasAntiguedad <= 120 THEN
             cRangoAntig   := '91 A 120';
          ELSIF nDiasAntiguedad > 120 THEN
             cRangoAntig   := 'MAS DE 120';
          ELSE
             cRangoAntig   := 'NO DEFINIDO';
          END IF;

          BEGIN
             SELECT OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes)
               INTO cDescEstado
               FROM CLIENTES C, PERSONA_NATURAL_JURIDICA P
              WHERE P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
                AND P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
                AND C.CodCliente              = X.CodCliente;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                cDescEstado := NULL;
          END;
          IF cDescEstado = 'PROVINCIA NO EXISTE' THEN
               cDescEstado := NULL;
          END IF;

          IF X.NumRenov = 0 THEN
             cTipoVigencia := '1ER. AÑO';
          ELSE
             cTipoVigencia := 'RENOVACION';
          END IF;

          nPrimaNeta      := 0;
          nReducPrima     := 0;
          nRecargos       := 0;
          nDerechos       := 0;
          nImpuesto       := 0;
          nPrimaTotal     := 0;
          nComisionesPEF  := 0;
          nHonorariosPEF  := 0;
          nUdisPEF        := 0;
          nComisionesPEM  := 0;
          nHonorariosPEM  := 0;
          nUdisPEM        := 0;
          nTotComisDist   := 0;
          nMtoComiAge     := 0;
          nMtoHonoAge     := 0;
          nMtoComiProm    := 0;
          nMtoHonoProm    := 0;
          nMtoComiDR      := 0;
          nMtoHonoDR      := 0;
          --
          cTipoAge        := 0;
          cCodAge         := 0;
          cTipoProm       := 0;
          cCodProm        := 0;
          cTipoDR         := 0;
          cCodDR          := 0;
          --
          nImpuestoHonoPF := 0;
          nImpuestoHonoPM    := 0;
          nImpuestoHonoPFOC := 0;
          nImpuestoHonoPMOC    := 0;
          nOtrasCompPF        := 0;
          nOtrasCompPM        := 0;
          --
          FOR W IN DET_NC_Q LOOP
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

          FOR C IN DET_ConC_NCR (X.IdPoliza, X.IdNcr) LOOP
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
             ----------------------
             ELSIF C.CodTipo = 'HONPF' THEN -- HONORARIOS PERSONA FISICA
                IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                   nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSIF C.CodConcepto = 'HONORA' THEN
                   nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                   ELSIF C.CodConcepto = 'IVAHON' THEN
                    nImpuestoHonoPF   := NVL(nImpuestoHonoPF,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                ELSE
                   NULL;
                END IF;
             ELSIF C.CodTipo = 'HONPM' THEN -- HONORARIOS PERSONA MORAL
                IF C.CodConcepto IN ('COMISI','COMIPM') THEN
                   nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSIF C.CodConcepto = 'HONORA' THEN
                   nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                   ELSIF C.CodConcepto = 'IVAHON' THEN
                    nImpuestoHonoPM  := NVL(nImpuestoHonoPM,0) + NVL(C.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                ELSE
                   NULL;
                END IF;

             ----------------------
             ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
                IF C.CodConcepto = 'UDI' THEN
    --               nUdisPEF        := NVL(nUdisPEF,0) + NVL(C.Monto_Mon_Extranjera,0);  jmmd20190523 se cambia por nOtrasCompPF
                   nOtrasCompPF    := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSE
                   NULL;
                END IF;
             ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL
                IF C.CodConcepto = 'UDI' THEN
    --               nUdisPEM        := NVL(nUdisPEM,0) + NVL(C.Monto_Mon_Extranjera,0);  jmmd20190523 se cambia por nOtrasCompPM
                   nOtrasCompPM    := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSE
                   NULL;
                END IF;
    ---- jmmd20190523Se incluyen los conceptos para HONORF y HONORM
             ELSIF C.CODTIPO = 'HONORF' THEN -- HONORARIOS PERSONA FISICA
                                IF C.CodConcepto = 'HONORA' THEN
                           nOtrasCompPF  := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                          ELSIF C.CodConcepto = 'IVAHON' THEN
                            nImpuestoHonoPFOC   := NVL(nImpuestoHonoPFOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                   ELSE
                     NULL;
                   END IF;
             ELSIF C.CODTIPO = 'HONORM' THEN -- HONORARIOS PERSONA MORAL
                     IF C.CodConcepto = 'HONORA' THEN
                           nOtrasCompPM  := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                          ELSIF C.CodConcepto = 'IVAHON' THEN
                            nImpuestoHonoPMOC   := NVL(nImpuestoHonoPMOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                   ELSE
                      NULL;
                   END IF;

                    -----------------------
             END IF;
             nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
             --
             IF C.CodNivel IN (3,4) THEN                                                                     --MLJS 27/05/2022 SE AGREGA EL NIVEL 4
                            cTipoAge            := C.CodTipo;
                            cCodAge                := C.Cod_Agente;
                            IF C.CodTipo IN ('HONPM','HONPF','HONORM') AND C.CodConcepto = 'HONORA' THEN    --MLJS 27/05/2022 SE AGREGA EL TIPO HONORM
                  nMtoHonoAge        := NVL(C.Monto_Mon_Extranjera,0);
                            ELSE
                  nMtoComiAge        := NVL(C.Monto_Mon_Extranjera,0);
                          END IF;
                     ELSIF C.CodNivel = 2 THEN
                            cTipoProm            := C.CodTipo;
                            cCodProm             := C.Cod_Agente;
                            IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                                nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
                            ELSE
                  nMtoComiProm    := NVL(C.Monto_Mon_Extranjera,0);
                          END IF;
               ELSIF C.CodNivel = 1 THEN
                            cTipoDR                := C.CodTipo;
                            cCodDR                 := C.Cod_Agente;
                            IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                                nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
                ELSE
                   nMtoComiDR        := NVL(C.Monto_Mon_Extranjera,0);
                          END IF;
               END IF;
          END LOOP;

          nDifComis := NVL(X.MtoComisi_Moneda,0) - NVL(nTotComisDist,0);

          SELECT NVL(MIN(NumComprob),'0')
            INTO cNumComprob
            FROM COMPROBANTES_CONTABLES
           WHERE CODCIA         = X.COD_CIA
             AND NumTransaccion = X.IdTransaccion;

          IF OC_SINIESTRO.TIENE_SINIESTRO(X.CodCia, X.IdPoliza, X.IDetPol, dFecHasta) = 'S' THEN
             cTieneSiniestro := 'S';
             SELECT NVL(MIN(IdSiniestro),0)
               INTO nIdSiniestro
               FROM SINIESTRO
              WHERE CodCia             = X.CodCia
                AND IdPoliza           = X.IdPoliza
                AND IDetPol            = X.IDetPol
                AND Fec_Notificacion  <= dFecHasta
                AND Sts_Siniestro NOT IN ('SOL','ANU');
          ELSE
             cTieneSiniestro := 'N';
             nIdSiniestro    := 0;
          END IF;

             cCadena := X.NumPolUnico                                  ||cLimitador||
                        TO_CHAR(X.IdPoliza,'9999999999999')            ||cLimitador||
                        X.NumPolRef                                    ||cLimitador||
                        X.IDETPOL                                      ||cLimitador||
                        X.Contratante                                  ||cLimitador||
                        TO_CHAR(X.IdEndoso,'9999999999999')            ||cLimitador||
                        'NCR'                                          ||cLimitador||
                        TO_CHAR(X.IdNcr,'9999999999990')               ||cLimitador||
                        X.STSNCR                                       ||cLimitador||
                        cDescFormaPago                                 ||cLimitador||
                        X.FechaTransaccion                             ||cLimitador||
                        X.FecDevol                                     ||cLimitador||
                        cFecFin                                        ||cLimitador||
                        TO_CHAR(nDiasAntiguedad,'99990')               ||cLimitador||
                        cRangoAntig                                    ||cLimitador||
                        TO_CHAR(nPrimaNeta,'99999999999990.00')        ||cLimitador||
    --                    TO_CHAR(0,'99999999999990.00')                                 ||cLimitador||    --> JALV (+) 09/11/2021
    --                    TO_CHAR(0,'99999999999990.00')                                 ||cLimitador||    --> JALV (+) 09/11/2021
                        TO_CHAR(nReducPrima,'99999999999990.00')       ||cLimitador||
                        TO_CHAR(nRecargos,'99999999999990.00')         ||cLimitador||
                        TO_CHAR(nDerechos,'99999999999990.00')         ||cLimitador||
                        TO_CHAR(nImpuesto,'99999999999990.00')         ||cLimitador||
                        TO_CHAR(nPrimaTotal,'99999999999990.00')       ||cLimitador||
                        TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00')||cLimitador||
                        TO_CHAR(nComisionesPEF,'99999999999990.00')    ||cLimitador||
                        TO_CHAR(nComisionesPEM,'99999999999990.00')    ||cLimitador||
                        TO_CHAR(nHonorariosPEF,'99999999999990.00')    ||cLimitador||
                        TO_CHAR(nImpuestoHonoPF,'99999999999990.00')   ||cLimitador||  ---- jmmd20190530 nImpuestoHono Nuevo concepto para proyecto de honorarios
                        TO_CHAR(nHonorariosPEM,'99999999999990.00')    ||cLimitador||
                        TO_CHAR(nImpuestoHonoPM,'99999999999990.00')   ||cLimitador||  ---- jmmd20190530 nImpuestoHono Nuevo concepto para proyecto de honorarios
                        TO_CHAR(nOtrasCompPF,'99999999999990.00')          ||cLimitador||
                        TO_CHAR(nImpuestoHonoPFOC,'99999999999990.00')   ||cLimitador||  ---- jmmd20190530 nImpuestoHono Nuevo concepto para proyecto de honorarios
                        TO_CHAR(nOtrasCompPM,'99999999999990.00')          ||cLimitador||
                        TO_CHAR(nImpuestoHonoPMOC,'99999999999990.00')   ||cLimitador||  ---- jmmd20190530 nImpuestoHono Nuevo concepto para proyecto de honorarios
                        TO_CHAR(nDifComis,'99999999999990.00')         ||cLimitador||
                        TO_CHAR(nMtoComiAge,'99999999999990.00')       ||cLimitador||
                        TO_CHAR(nMtoHonoAge,'99999999999990.00')       ||cLimitador||
                        LPAD(cCodAge,6,'0')                            ||cLimitador||
                        cTipoAge                                                                             ||cLimitador||
                        TO_CHAR(nMtoComiProm,'99999999999990.00')      ||cLimitador||
                        TO_CHAR(nMtoHonoProm,'99999999999990.00')      ||cLimitador||
                        LPAD(cCodProm,6,'0')                                                     ||cLimitador||
                        cTipoProm                                                                             ||cLimitador||
                        TO_CHAR(nMtoComiDR,'99999999999990.00')        ||cLimitador||
                        TO_CHAR(nMtoHonoDR,'99999999999990.00')        ||cLimitador||
                        LPAD(cCodDR,6,'0')                                                         ||cLimitador||
                        cTipoDR                                                                                 ||cLimitador||
                        TO_CHAR(nTasaIVA,'999990.00')                  ||cLimitador||
                        cDescEstado                                    ||cLimitador||
                        X.CodMoneda                                    ||cLimitador||
                        X.TIPO_CAMBIO                                  ||cLimitador||
                        X.IdTipoSeg                                    ||cLimitador||
                        X.PlanCob                                      ||cLimitador||
                        X.CodTipoPlan                                  ||cLimitador||
                        X.DescSubRamo                                  ||cLimitador||
                        cTipoVigencia                                  ||cLimitador||
                        TO_CHAR(X.NumCuota,'99990')                    ||cLimitador||
                        X.FecIniVig                                    ||cLimitador||
                        X.FecFinVig                                    ||cLimitador||
                        TO_CHAR(X.NumRenov,'99990')                    ||cLimitador||
                        cNumComprob                                    ||cLimitador||
                        cTieneSiniestro                                ||cLimitador||
                        TO_CHAR(nIdSiniestro,'9999999999990')          ||cLimitador||
                        X.FolioFactElec                                ||cLimitador||
                        X.ESCONTRIBUTORIO                              ||cLimitador||
                        X.PORCENCONTRIBUTORIO                          ||cLimitador||
                        X.GIRONEGOCIO                                  ||cLimitador||
                        X.TIPONEGOCIO                                  ||cLimitador||
                        X.FUENTERECURSOS                               ||cLimitador||
                        X.CODPAQCOMERCIAL                              ||cLimitador||
                        X.CATEGORIA                                    ||cLimitador||
                        X.CANALFORMAVENTA                              ||cLimitador||
                        TO_CHAR(0,'99999999999990.00')                 ||cLimitador||               --> JALV (+) 09/11/2021
                        TO_CHAR(0,'99999999999990.00')                 ||cLimitador||
                        X.CodRamo                                      ||cLimitador||
                        X.DescRamo
                                           ||CHR(13);
                ----
                IF UPPER(cDestino) != 'REGISTRO' THEN
                    nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena, 1);
                ELSE
                    INSERTA_REGISTROS(cCodReporte, nLineaimp, 'DEUDORXPRIMA', cNomArchivo, cCadena, W_ID_ENVIO);
                END IF;
                --
        END LOOP;
            --
        cNomArchZip := SUBSTR(cNomArchivo, 1, INSTR(cNomArchivo, '.')-1) || '.zip';
            --
        IF UPPER(cDestino) != 'REGISTRO' THEN
            IF XLSX_BUILDER_PKG.EXCEL_GUARDA_LIBRO THEN
               IF ZIP_UTIL_PKG.ZIP_ARCHIVOS(cNomDirectorio, cNomArchZip, cNomArchivo) THEN
                  dbms_output.put_line('OK');
               END IF;
               OC_REPORTES_THONA.COPIA_ARCHIVO_BLOB( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomArchZip, W_ID_ENVIO, 'N' );
            END IF;

            IF UPPER(cDestino) = 'CORREO' THEN
              ENVIA_MAIL('Deudor de prima',cNomDirectorio, cNomArchZip, W_ID_ENVIO, cBuzones) ;
            END IF;
        ELSE
              ENVIA_MAIL('Deudor de prima',NULL, NULL, W_ID_ENVIO, cBuzones);
        END IF;

    END DEUDOR_X_PRIMAS_COB;
    --
    PROCEDURE PRIMA_NETA_COB (nCodCia     NUMBER,
                                                  nCodEmpresa NUMBER,
                                                  cIdTipoSeg VARCHAR2,
                                                  cPlanCob   VARCHAR2,
                                                  cCodMoneda VARCHAR2,
                                                  cCodAgente VARCHAR2,
                                                  dFecInicio  DATE        default trunc(sysdate),
                                                  dFecFinal   DATE        default trunc(sysdate),
                                                  cDestino    VARCHAR2    default 'CORREO',  --  'ARCHIVO', 'CORREO', 'REGISTRO' -- GENERERA EL ARCHIVO PARA DESCARGAR, CORREO, SE ENVIA SEGUN EL USUARIO CONECTADO Y REGISTRO ES PARA DESCARGAR EN TXT
                                  cBuzones      VARCHAR2,
                                  PID_ENVIO  OUT  NUMBER
                                                  ) IS
        /* PROCEDIMIENTO QUE GENERA DOS SALIDAS, UNO A UNA TABLA Y OTRO GENERA ARCHIVO DE EXCEL*/
        cLimitador             VARCHAR2(1) :='|';
        nLinea                 NUMBER;
        nLineaimp              NUMBER := 1;
        cCadena                VARCHAR2(4000);
        cCodUser               VARCHAR2(30);
        cDescFormaPago         VARCHAR2(100);
        dFecFin                DATE;
        cFecFin                VARCHAR2(10);
        cTipoVigencia          VARCHAR2(20);
        nIdFactura             FACTURAS.IdFactura%TYPE;
        nPrimaNeta             DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nReducPrima            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nRecargos              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nDerechos              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nImpuesto              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nPrimaTotal            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nComisionesPEF         DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nHonorariosPEF         DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nUdisPEF               DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nComisionesPEM         DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nHonorariosPEM         DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nImpuestoHonoPF        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nImpuestoHonoPM        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nImpuestoHonoPFOC      DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nImpuestoHonoPMOC      DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nUdisPEM               DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nTotComisDist          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nDifComis              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        cCodPlanPagos          PLAN_DE_PAGOS.CodPlanPago%TYPE;
        cCodGenerador          AGENTE_POLIZA.Cod_Agente%TYPE;
        nTasaIVA               CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
        cDescEstado            PROVINCIA.DescEstado%TYPE;
        cNumComprob            COMPROBANTES_CONTABLES.NumComprob%TYPE;
        nIdNcr                 NOTAS_DE_CREDITO.IdNcr%TYPE;
        cStsNcr                NOTAS_DE_CREDITO.StsNcr%TYPE;
        nMonto_Det_Moneda      DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
        nMonto_Mon_Extranjera  DETALLE_COMISION.Monto_Mon_Extranjera%TYPE;
        ---
        nMtoComiAge            NUMBER(28,2);
        nMtoHonoAge            NUMBER(28,2);
        cTipoAge               AGENTES.CodTipo%TYPE;
        cCodAge                AGENTES.Cod_Agente%TYPE;

        nMtoComiProm           NUMBER(28,2);
        nMtoHonoProm           NUMBER(28,2);
        cTipoProm              AGENTES.CodTipo%TYPE;
        cCodProm               AGENTES.Cod_Agente%TYPE;

        nMtoComiDR             NUMBER(28,2);
        nMtoHonoDR             NUMBER(28,2);
        cTipoDR                AGENTES.CodTipo%TYPE;
        cCodDR                 AGENTES.Cod_Agente%TYPE;

        CFolioFiscal            FACT_ELECT_DETALLE_TIMBRE.FolioFiscal%TYPE;
        cSerie                  FACT_ELECT_DETALLE_TIMBRE.Serie%TYPE;
        cUUID                   FACT_ELECT_DETALLE_TIMBRE.UUID%TYPE;
        cFechaUUID          DATE;
        cVariosUUID         NUMBER;
        cOrigenRecibo       VARCHAR2(200);
        nOtrasCompPF        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nOtrasCompPM        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        ----
        cNomDirectorio      VARCHAR2(100) ;
        cNomArchivo         VARCHAR2(100) := 'PRIMA_NETA_'||to_char(trunc(sysdate - 1),'ddmmyyyy')||'.XLSX';
        cNomArchZip         VARCHAR2(100);
        --
        dPagadoHasta        DATE;
        dCubiertoHasta      DATE;
        dFecIniVig          DATE;
        nCuantosEmi         NUMBER;
        nDiasGracia         NUMBER := 0;
        nCuantosPag         NUMBER := 0;
        nMinFactura         NUMBER := 0;
        cStatuspol          VARCHAR2(3);
        cRenovacion     VARCHAR2(15);
        cRamo           VARCHAR2(50);
        nIdTipoSeg          DETALLE_POLIZA.IdTipoSeg%TYPE;
        cPlanCobert         PLAN_COBERTURAS.PlanCob%TYPE;
        nFactorPrimaRamo    NUMBER;
        nPrimaTotalLocal    NUMBER;

        ----
        dFecDesde           DATE;
        dFecHasta           DATE;
        W_ID_TERMINAL       CONTROL_PROCESOS_AUTOMATICOS.ID_TERMINAL%TYPE;
        W_ID_USER           CONTROL_PROCESOS_AUTOMATICOS.ID_USER%TYPE;
        W_ID_ENVIO          CONTROL_PROCESOS_AUTOMATICOS.ID_ENVIO%TYPE;
        cNomCia             VARCHAR2(100);
        cCodReporte         VARCHAR2(100) := 'PRIMANETA';
        ----
        cTitulo1            VARCHAR2(200);
        cTitulo2            VARCHAR2(200);
        cTitulo4            VARCHAR2(200);
        cEncabez            VARCHAR2(5000);
        ----
        cPwdEmail                   VARCHAR2(100);
        cMiMail                     USUARIOS.EMAIL%TYPE := 'notificaciones@thonaseguros.mx';
        cSaltoLinea                 VARCHAR2(5)      := '<br>';
        cHTMLHeader                 VARCHAR2(2000)   := '<html>'                                                                  ||cSaltoLinea||
                                                     '<head>'                                                                     ||cSaltoLinea||
                                                     '<meta http-equiv="Content-Language" content="en/us"/>'                      ||cSaltoLinea||
                                                     '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>'  ||cSaltoLinea||
                                                     '</head><body>'                                                              ||cSaltoLinea;
        cHTMLFooter                 VARCHAR2(100)    := '</body></html>';
        cError                      VARCHAR2(1000);
        cTextoEnv                   ENDOSO_TXT_DET.TEXTO%TYPE;
        cSubject                    VARCHAR2(1000) := 'Notificacion de recepcion del archivo de "Prima Neta"';
        cTexto1                     VARCHAR2(10000):= 'A quien corresponda ';
        cTexto2                     varchar2(1000) := ' Envio del archivo de "Prima Neta" solicitado. ';
        cTexto4                     varchar2(1000) := ' Saludos. ';
        ----

        CURSOR EMI_Q IS
           SELECT PROCESO,
                  IDPOLIZA,                      NUMPOLUNICO,
                  NUMPOLREF,                     IDETPOL,
                  CONTRATANTE,
                  IDENDOSO,                      IDFACTURA,
                  FECHATRANSACCION,
                  FECVENC,
                  COD_MONEDA,                    IDTIPOSEG,
                  PLANCOB,                       CODTIPOPLAN ,
                  DESCSUBRAMO,
                  CODCLIENTE,
                  FECINIVIG,
                  FECFINVIG,
                  NUMRENOV,
                  CODCIA,                        MTOCOMISI_MONEDA,
                  NUMCUOTA,                      CODEMPRESA,
                  FECANUL,                       MOTIVANUL,
                  IDTRANSACCION,                 FOLIOFACTELEC,
                  FECFINVIG_FAC,
                  TIPO_CAMBIO,
                  ESTATUS,
                  --
                  ESCONTRIBUTORIO,
                  PORCENCONTRIBUTORIO,
                  GIRONEGOCIO,
                  TIPONEGOCIO,
                  FUENTERECURSOS,
                  CODPAQCOMERCIAL,
                  CATEGORIA,
                  MONTOPRIMARETIROMON,
                  MONTOPRIMARETIROLOC,
                  CANALFORMAVENTA,
                  CodRamo,
                  DescRamo,
                  IndMultiramo
        from (
           SELECT /*+RULE*/
                  'EMISION'                        PROCESO,
                  P.IDPOLIZA,                      P.NUMPOLUNICO,
                  P.NUMPOLREF,                     DP.IDETPOL,
                  OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE) || ' ' ||
                  OC_FILIALES.NOMBRE_ADICIONAL(P.CODCIA, P.CODGRUPOEC, DP.CODFILIAL) CONTRATANTE,
                  F.IDENDOSO,                      F.IDFACTURA,
                  TO_CHAR(T.FECHATRANSACCION,'DD/MM/YYYY') FECHATRANSACCION,
                  TO_CHAR(F.FECVENC,'DD/MM/YYYY')  FECVENC,
                  F.COD_MONEDA,                    DP.IDTIPOSEG,
                  DP.PLANCOB,                      PC.CODTIPOPLAN ,
                  OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CODTIPOPLAN) DESCSUBRAMO,
                  P.CODCLIENTE,
                  TO_CHAR(P.FECINIVIG,'DD/MM/YYYY') FECINIVIG,
                  TO_CHAR(P.FECFINVIG,'DD/MM/YYYY') FECFINVIG,
                  P.NUMRENOV,
                  P.CODCIA,                        F.MTOCOMISI_MONEDA,
                  F.NUMCUOTA,                      P.CODEMPRESA,
                  NULL FECANUL,                    NULL MOTIVANUL,
                  T.IDTRANSACCION,                 F.FOLIOFACTELEC,
                  F.FECFINVIG                      FECFINVIG_FAC,
                  GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(T.FECHATRANSACCION),F.COD_MONEDA) TIPO_CAMBIO,
                  F.STSFACT  ESTATUS,
                  --
                  DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                  NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                  UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
                  P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                  CGO.DESCCATEGO                                            CATEGORIA,
                  F.MontoPrimaCompMoneda                                                                        MONTOPRIMARETIROMON,    --> JALV (+) 09/11/2021
                  F.MontoPrimaCompLocal                                                                            MONTOPRIMARETIROLOC,        --> JALV (+) 09/11/2021
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                  CASE TS.CODTIPOPLAN
                    WHEN '099' THEN
                       OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto)
                    ELSE
                       TS.CODTIPOPLAN
                  END CodRamo,
                  CASE TS.CODTIPOPLAN
                    WHEN '099' THEN
                       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto))
                    ELSE
                       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',TS.CODTIPOPLAN)
                    END DescRamo,
                    TS.IndMultiramo
             FROM TRANSACCION         T,
                  DETALLE_TRANSACCION DT,
                  FACTURAS        F,
                  --
                  DETALLE_FACTURAS DF,
                  CATALOGO_DE_CONCEPTOS C,
                  --
                  POLIZAS         P,
                  DETALLE_POLIZA  DP ,
                  --
                  TIPOS_DE_SEGUROS TS,
                  --
                  PLAN_COBERTURAS PC,
                  POLIZAS_TEXTO_COTIZACION  TXT,
                  CATEGORIAS                CGO
            WHERE T.CODCIA                   = NCODCIA
              AND T.CODEMPRESA               = NCODEMPRESA
              AND TRUNC(T.FECHATRANSACCION) BETWEEN DFECDESDE AND DFECHASTA
              AND T.IDPROCESO               IN (7, 8, 14, 18, 21)
              --
              AND DT.IDTRANSACCION           = T.IDTRANSACCION
              AND DT.CODEMPRESA              = T.CODEMPRESA
              AND DT.CODCIA                  = T.CODCIA
              AND F.CODCIA                   = DT.CODCIA
              AND F.IDPOLIZA                 = TO_NUMBER(DT.VALOR1)
              AND F.IDFACTURA                = TO_NUMBER(DT.VALOR4)
              AND F.STSFACT                  NOT IN ('PRE')
              AND DT.OBJETO                 IN ('FACTURAS')
              AND DT.CODSUBPROCESO          IN ('FAC','REHAB','FACFON','CONFAC')
              --
              AND T.CODCIA                   = DT.CODCIA
              AND T.CODEMPRESA               = DT.CODEMPRESA
              --
              AND EXISTS
                   (SELECT 1
                    FROM   DETALLE_TRANSACCION    DTR
                    WHERE  DTR.IDTRANSACCION     = DT.IDTRANSACCION
                    AND    DTR.CODCIA            = DT.CODCIA
                    AND    DTR.CODEMPRESA        = DT.CODEMPRESA
                    AND  ((DTR.OBJETO IN ('FACTURAS')  AND  T.IDPROCESO  IN (7, 14, 18, 21)  AND DTR.CODSUBPROCESO IN ('FAC','REHAB','FACFON','CONFAC'))
                    OR    (DTR.OBJETO IN ('ENDOSOS')   AND  T.IDPROCESO  IN (8)              AND DTR.CODSUBPROCESO IN ('CFP','AUM', 'EAD', 'INA', 'INC', 'IND', 'REHAP', 'RSS')))
                    )
              --
              AND P.CODCIA                   = F.CODCIA
              AND P.IDPOLIZA                 = F.IDPOLIZA
              AND DP.CODCIA                  = F.CODCIA
              AND DP.IDETPOL                 = F.IDETPOL
              AND DP.IDPOLIZA                = F.IDPOLIZA
              --
              AND F.IdFactura               = DF.IdFactura
              --
              AND PC.IDTIPOSEG               = DP.IDTIPOSEG
              AND PC.CODEMPRESA              = DP.CODEMPRESA
              AND PC.CODCIA                  = DP.CODCIA
              AND PC.PLANCOB                 = DP.PLANCOB
              --
              AND DP.IDTIPOSEG               = TS.IDTIPOSEG
              AND DP.CODEMPRESA              = TS.CODEMPRESA
              AND DP.CodCia                  = TS.CodCia
              --
              AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
              AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
              AND F.Cod_Moneda              = nvl(cCodMoneda, F.Cod_Moneda)
              AND F.CodGenerador            = nvl(cCodAgente, F.CodGenerador)
               --
              AND TXT.CODCIA(+)              = P.CODCIA
              AND TXT.CODEMPRESA(+)          = P.CODEMPRESA
              AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
              --
              AND CGO.CODCIA(+)              = P.CODCIA
              AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
              AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
              AND CGO.CODCATEGO(+)           = P.CODCATEGO
              AND C.CODCIA                  = F.CODCIA
              AND C.CodConcepto             = DF.CodCpto
              AND (C.IndCptoPrimas            = 'S'  OR C.INDCPTOFONDO = 'S')
           GROUP BY P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.IDetPol, P.CodCliente,
                    P.CodCia, P.CODGRUPOEC, DP.CODFILIAL, F.IdEndoso, F.IdFactura,
                    T.FECHATRANSACCION, F.FECVENC, F.Cod_Moneda, DP.IDTIPOSEG, DP.PLANCOB,
                    PC.CODTIPOPLAN, PC.CODTIPOPLAN, P.CodCliente, P.FECINIVIG, P.FECFINVIG,
                    P.NUMRENOV, P.CodCia, F.MtoComisi_Moneda, F.NUMCUOTA, P.CODEMPRESA,
                    T.IDTRANSACCION, F.FOLIOFACTELEC, F.FECFINVIG, F.Cod_Moneda, F.STSFACT,
                    P.PORCENCONTRIBUTORIO, P.PORCENCONTRIBUTORIO, TXT.DESCGIRONEGOCIO,
                    P.CODTIPONEGOCIO, P.FUENTERECURSOSPRIMA, P.CODPAQCOMERCIAL, CGO.DESCCATEGO,
                    P.FORMAVENTA, F.MontoPrimaCompMoneda, F.MontoPrimaCompLocal, P.CodEmpresa,
                    OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg,
                    DP.PlanCob, C.CodConcepto), TS.CODTIPOPLAN, TS.IndMultiramo
          UNION
          SELECT /*+RULE*/
                  'EMISION'                        PROCESO,
                  P.IDPOLIZA,                      P.NUMPOLUNICO,
                  P.NUMPOLREF,                     DP.IDETPOL,
                  OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE) || ' ' ||
                  OC_FILIALES.NOMBRE_ADICIONAL(P.CODCIA, P.CODGRUPOEC, DP.CODFILIAL) CONTRATANTE,
                  F.IDENDOSO,                      F.IDFACTURA,
                  TO_CHAR(T.FECHATRANSACCION,'DD/MM/YYYY') FECHATRANSACCION,                         -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  TO_CHAR(F.FECVENC,'DD/MM/YYYY')  FECVENC,                                          -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  F.COD_MONEDA,                    DP.IDTIPOSEG,
                  DP.PLANCOB,                      PC.CODTIPOPLAN,
                  OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CODTIPOPLAN) DESCSUBRAMO,
                  P.CODCLIENTE,
                  TO_CHAR(P.FECINIVIG,'DD/MM/YYYY') FECINIVIG,                                       -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  TO_CHAR(P.FECFINVIG,'DD/MM/YYYY') FECFINVIG,                                       -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  P.NUMRENOV,
                  P.CODCIA,                        F.MTOCOMISI_MONEDA,
                  F.NUMCUOTA,                      P.CODEMPRESA,
                  NULL FECANUL,                    NULL MOTIVANUL,
                  T.IDTRANSACCION,                 F.FOLIOFACTELEC,
                  F.FECFINVIG                      FECFINVIG_FAC,
                  GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(T.FECHATRANSACCION),F.COD_MONEDA) TIPO_CAMBIO,
                  F.STSFACT                        ESTATUS,
                  --
                  DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                  NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                  UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
                  P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                  CGO.DESCCATEGO                                            CATEGORIA,
                  F.MontoPrimaCompMoneda                                                                        MONTOPRIMARETIROMON,    --> JALV (+) 09/11/2021
                  F.MontoPrimaCompLocal                                                                            MONTOPRIMARETIROLOC,        --> JALV (+) 09/11/2021
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA ,
                  CASE TS.CODTIPOPLAN
                    WHEN '099' THEN
                       OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto)
                    ELSE
                       TS.CODTIPOPLAN
                  END CodRamo,
                  CASE TS.CODTIPOPLAN
                    WHEN '099' THEN
                       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto))
                    ELSE
                       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',TS.CODTIPOPLAN)
                    END DescRamo,
                    TS.IndMultiramo
             FROM TRANSACCION         T,
                  DETALLE_TRANSACCION DT,
                  FACTURAS        F,
                  --
                  DETALLE_FACTURAS DF,
                  CATALOGO_DE_CONCEPTOS C,
                  --
                  POLIZAS         P,
                  DETALLE_POLIZA  DP,
                  --
                  TIPOS_DE_SEGUROS TS,
                  --
                  PLAN_COBERTURAS PC,
                  POLIZAS_TEXTO_COTIZACION  TXT,
                  CATEGORIAS                CGO
            WHERE T.CODCIA                   = NCODCIA
              AND T.CODEMPRESA               = NCODEMPRESA
              AND TRUNC(T.FECHATRANSACCION) BETWEEN DFECDESDE AND DFECHASTA
              AND T.IDPROCESO  IN (7, 8, 14, 18, 21)
              AND F.STSFACT                 != 'PRE'    --PREEMI
              AND F.CODCIA                   = DT.CODCIA
              AND F.IDPOLIZA                 = TO_NUMBER(DT.VALOR1)
              AND F.IDTRANSACCION            = DT.IDTRANSACCION
              AND DT.IDTRANSACCION           = T.IDTRANSACCION
              AND DT.CODEMPRESA              = T.CODEMPRESA
              AND DT.CODCIA                  = T.CODCIA
              AND DT.OBJETO                  IN ('FACTURAS')
              AND DT.CODSUBPROCESO           IN ('FAC','REHAB','FACFON','CONFAC')
              AND T.CODCIA                   = DT.CODCIA
              AND T.CODEMPRESA               = DT.CODEMPRESA
              AND EXISTS
                   (SELECT 1
                    FROM   DETALLE_TRANSACCION    DTR
                    WHERE  DTR.IDTRANSACCION     = DT.IDTRANSACCION
                    AND    DTR.CODCIA            = DT.CODCIA
                    AND    DTR.CODEMPRESA        = DT.CODEMPRESA
                    AND  ((DTR.OBJETO IN ('FACTURAS')  AND  T.IDPROCESO  IN (7, 14, 18, 21)  AND DTR.CODSUBPROCESO IN ('FAC','REHAB','FACFON','CONFAC'))
                    OR    (DTR.OBJETO IN ('ENDOSOS')   AND  T.IDPROCESO  IN (8)              AND DTR.CODSUBPROCESO IN ('CFP','AUM', 'EAD', 'INA', 'INC', 'IND', 'REHAP', 'RSS')))
                    )
              --
              AND P.CODCIA                   = F.CODCIA
              AND P.IDPOLIZA                 = F.IDPOLIZA
              --
              AND DP.IDPOLIZA                = F.IDPOLIZA
              AND DP.IDETPOL                 = F.IDETPOL
              AND DP.CODCIA                  = F.CODCIA
              --
              AND F.IdFactura               = DF.IdFactura
              --
              AND PC.PLANCOB                 = DP.PLANCOB
              AND PC.IDTIPOSEG               = DP.IDTIPOSEG
              AND PC.CODEMPRESA              = DP.CODEMPRESA
              AND PC.CODCIA                  = DP.CODCIA
              AND DP.IDTIPOSEG               = TS.IDTIPOSEG
              AND DP.CODEMPRESA              = TS.CODEMPRESA
              AND DP.CodCia                  = TS.CodCia
              --
              AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
              AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
              AND F.Cod_Moneda              = nvl(cCodMoneda, F.Cod_Moneda)
              AND F.CodGenerador            = nvl(cCodAgente, F.CodGenerador)
               --
              AND TXT.CODCIA(+)              = P.CODCIA
              AND TXT.CODEMPRESA(+)          = P.CODEMPRESA
              AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
              --
              AND CGO.CODCIA(+)              = P.CODCIA
              AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
              AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
              AND CGO.CODCATEGO(+)           = P.CODCATEGO
              --
              AND C.CODCIA                  = F.CODCIA
              AND C.CodConcepto             = DF.CodCpto
              AND (C.IndCptoPrimas            = 'S'  OR C.INDCPTOFONDO = 'S')
           GROUP BY P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.IDetPol, P.CodCliente,
                    P.CodCia, P.CODGRUPOEC, DP.CODFILIAL, F.IdEndoso, F.IdFactura,
                    T.FECHATRANSACCION, F.FECVENC, F.Cod_Moneda, DP.IDTIPOSEG, DP.PLANCOB,
                    PC.CODTIPOPLAN, PC.CODTIPOPLAN, P.CodCliente, P.FECINIVIG, P.FECFINVIG,
                    P.NUMRENOV, P.CodCia, F.MtoComisi_Moneda, F.NUMCUOTA, P.CODEMPRESA,
                    T.IDTRANSACCION, F.FOLIOFACTELEC, F.FECFINVIG, F.Cod_Moneda, F.STSFACT,
                    P.PORCENCONTRIBUTORIO, P.PORCENCONTRIBUTORIO, TXT.DESCGIRONEGOCIO,
                    P.CODTIPONEGOCIO, P.FUENTERECURSOSPRIMA, P.CODPAQCOMERCIAL, CGO.DESCCATEGO,
                    P.FORMAVENTA, F.MontoPrimaCompMoneda, F.MontoPrimaCompLocal, P.CodEmpresa,
                    OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg,
                    DP.PlanCob, C.CodConcepto), TS.CODTIPOPLAN, TS.IndMultiramo
        UNION ALL
          SELECT  /*+RULE*/
                 'CANCELACION'                     PROCESO,
                  P.IdPoliza,                       P.NumPolUnico,
                  P.NumPolRef,                      DP.IDETPOL,
                  OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
                     OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
                  F.IdEndoso,                       F.IdFactura,
                  TO_CHAR(T.FechaTransaccion,'DD/MM/YYYY') FechaTransaccion,                      -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  TO_CHAR(F.FecVenc,'DD/MM/YYYY') FecVenc,                                        -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  F.Cod_Moneda,                     DP.IdTipoSeg,
                  DP.PlanCob,                       PC.CodTipoPlan,
                  OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
                  P.CodCliente,
                  TO_CHAR(P.FecIniVig,'DD/MM/YYYY') FecIniVig,                                -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  TO_CHAR(P.FecFinVig,'DD/MM/YYYY') FecFinVig,                                -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  P.NumRenov,
                  P.CodCia,                         F.MtoComisi_Moneda*-1 MtoComisi_Moneda,
                  F.NumCuota,                       P.CodEmpresa,
                  TO_CHAR(F.FecAnul,'DD/MM/YYYY') FecAnul,
                  F.MotivAnul,
                  T.IdTransaccion,                  F.FolioFactElec,
                  F.FECFINVIG                       FECFINVIG_FAC,
                  GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(F.FecAnul),F.Cod_Moneda) TIPO_CAMBIO,
                  F.STSFACT                         ESTATUS,
                 --
                  DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                  NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                  UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
                  P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                  CGO.DESCCATEGO                                            CATEGORIA,
                  F.MontoPrimaCompMoneda                                                                        MONTOPRIMARETIROMON,    --> JALV (+) 09/11/2021
                  F.MontoPrimaCompLocal                                                                            MONTOPRIMARETIROLOC,        --> JALV (+) 09/11/2021
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA ,
                  CASE TS.CODTIPOPLAN
                    WHEN '099' THEN
                       OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto)
                    ELSE
                       TS.CODTIPOPLAN
                  END CodRamo,
                  CASE TS.CODTIPOPLAN
                    WHEN '099' THEN
                       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto))
                    ELSE
                       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',TS.CODTIPOPLAN)
                    END DescRamo,
                    TS.IndMultiramo
             FROM TRANSACCION         T,                    -- MLJS SE CAMBIARON LAS TABLAS INICIALES DEL EXTRACCION 28/05/2020
                  DETALLE_TRANSACCION DT,                   -- MLJS SE CAMBIARON LAS TABLAS INICIALES DEL EXTRACCION 28/05/2020
                  FACTURAS        F,
                  --
                  DETALLE_FACTURAS DF,
                  CATALOGO_DE_CONCEPTOS C,
                  --
                  POLIZAS         P,
                  DETALLE_POLIZA  DP,
                  --
                  TIPOS_DE_SEGUROS TS,
                  --
                  PLAN_COBERTURAS PC,
                  POLIZAS_TEXTO_COTIZACION  TXT,
                  CATEGORIAS                CGO
            WHERE T.CODCIA                   = NCODCIA
              AND T.CODEMPRESA               = NCODEMPRESA
              AND TRUNC(T.FechaTransaccion) BETWEEN DFECDESDE AND DFECHASTA
              AND T.IdProceso               IN (2,8,11)
              AND DT.IDTRANSACCION           = T.IDTRANSACCION
              AND DT.CODEMPRESA              = T.CODEMPRESA
              AND DT.CODCIA                  = T.CODCIA
              AND DT.OBJETO                 IN ('FACTURAS')
              AND DT.CODSUBPROCESO          IN ('FAC','ANUFAC')
              AND TO_NUMBER(DT.VALOR4)      = F.IDFACTURA
              AND TO_NUMBER(DT.VALOR1)      = F.IDPOLIZA
              --
              AND T.CODCIA                   = DT.CODCIA
              AND T.CODEMPRESA               = DT.CODEMPRESA
              AND EXISTS (
                   SELECT
                          1
                   FROM   DETALLE_TRANSACCION    DTR
                   WHERE  DTR.IDTRANSACCION     = DT.IDTRANSACCION
                   AND    DTR.CODCIA            = DT.CODCIA
                   AND    DTR.CODEMPRESA        = DT.CODEMPRESA
                   AND  ((DTR.OBJETO IN ('FACTURAS')  AND  T.IDPROCESO  IN (2,11)  AND DTR.CODSUBPROCESO IN ('FAC'))
                    OR   (DTR.OBJETO IN ('ENDOSOS')   AND  T.IDPROCESO  IN (8)     AND DTR.CODSUBPROCESO IN ('ANUFAC')))
                     )
              ---- MLJS 28/05/2020 SE CAMBIARON LAS TABLAS INICIALES DEL EXTRACCION
              AND PC.PlanCob                 = DP.PlanCob
              AND PC.IdTipoSeg               = DP.IdTipoSeg
              AND PC.CodEmpresa              = DP.CodEmpresa
              AND PC.CodCia                  = DP.CodCia
              AND DP.CodCia                  = F.CodCia
              AND DP.IDetPol                 = F.IDetPol
              AND DP.IdPoliza                = F.IdPoliza
              AND F.IdFactura               = DF.IdFactura
              AND DP.IDTIPOSEG               = TS.IDTIPOSEG
              AND DP.CODEMPRESA              = TS.CODEMPRESA
              AND DP.CodCia                  = TS.CodCia
              --
              AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
              AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
              AND F.Cod_Moneda              = nvl(cCodMoneda, F.Cod_Moneda)
              AND F.CodGenerador            = nvl(cCodAgente, F.CodGenerador)
               --
              AND P.CodCia                   = F.CodCia
              AND P.IdPoliza                 = F.IDPOLIZA
              --
              AND TXT.CODCIA(+)              = P.CODCIA
              AND TXT.CODEMPRESA(+)          = P.CODEMPRESA
              AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
              --
              AND CGO.CODCIA(+)              = P.CODCIA
              AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
              AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
              AND CGO.CODCATEGO(+)           = P.CODCATEGO
              AND C.CODCIA                  = F.CODCIA
              AND C.CodConcepto             = DF.CodCpto
              AND (C.IndCptoPrimas            = 'S'  OR C.INDCPTOFONDO = 'S')
           GROUP BY P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.IDetPol, P.CodCliente,
                    P.CodCia, P.CODGRUPOEC, DP.CODFILIAL, F.IdEndoso, F.IdFactura,
                    T.FECHATRANSACCION, F.FECVENC, F.Cod_Moneda, DP.IDTIPOSEG, DP.PLANCOB,
                    PC.CODTIPOPLAN, PC.CODTIPOPLAN, P.CodCliente, P.FECINIVIG, P.FECFINVIG,
                    P.NUMRENOV, P.CodCia, F.MtoComisi_Moneda, F.NUMCUOTA, P.CODEMPRESA,
                    F.FecAnul,F.MotivAnul,
                    T.IDTRANSACCION, F.FOLIOFACTELEC, F.FECFINVIG, F.Cod_Moneda, F.STSFACT,
                    P.PORCENCONTRIBUTORIO, P.PORCENCONTRIBUTORIO, TXT.DESCGIRONEGOCIO,
                    P.CODTIPONEGOCIO, P.FUENTERECURSOSPRIMA, P.CODPAQCOMERCIAL, CGO.DESCCATEGO,
                    P.FORMAVENTA, F.MontoPrimaCompMoneda, F.MontoPrimaCompLocal, P.CodEmpresa,
                    OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg,
                    DP.PlanCob, C.CodConcepto), TS.CODTIPOPLAN, TS.IndMultiramo)
            ORDER BY PROCESO DESC, IDFACTURA;


        CURSOR DET_Q IS
           SELECT D.CodCpto,            D.Monto_Det_Moneda,
                  D.IndCptoPrima,       C.IndCptoServicio
             FROM DETALLE_FACTURAS      D,
                  FACTURAS              F,
                  CATALOGO_DE_CONCEPTOS C
            WHERE C.CodConcepto = D.CodCpto
              AND C.CodCia      = F.CodCia
              AND D.IdFactura   = F.IdFactura
              AND F.IdFactura   = nIdFactura;

            CURSOR DET_Q_MR (nCodRamo Varchar2) IS
                     SELECT D.CodCpto,            D.Monto_Det_Moneda,
                            D.IndCptoPrima,       C.IndCptoServicio,
                            OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(nCodCia, nCodEmpresa, nIdTipoSeg, cPlanCobert, C.CodConcepto) RamoPrimas,
                            C.CodTipoPlan
                 FROM DETALLE_FACTURAS      D,
                      FACTURAS              F,
                      CATALOGO_DE_CONCEPTOS C
                WHERE C.CodConcepto = D.CodCpto
                  AND C.CodCia      = F.CodCia
                  AND D.IdFactura   = F.IdFactura
                  AND F.IdFactura   = nIdFactura
                  and nvl(CodTipoPlan, OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(nCodCia, nCodEmpresa, nIdTipoSeg, cPlanCobert, C.CodConcepto)) = nCodRamo;


        CURSOR DET_ConC (P_IdPoliza Number, p_idFactura Number ) IS
           SELECT DCO.CodConcepto,            DCO.Monto_Mon_Extranjera,
                  AGE.CodTipo,                AGE.CodNivel,
                  COM.Cod_Agente,
                  OC_COMISIONES.MONTO_COMISION (COM.CodCia,COM.idpoliza,AGE.CodNivel,AGE.Cod_Agente,COM.IdFactura,NULL) MtoComision
                 FROM COMISIONES       COM,
                      DETALLE_COMISION DCO,
                      AGENTES          AGE
              WHERE DCO.CodConcepto IN ('HONORA','COMISI','COMIPF','COMIPM','UDI')
                AND COM.CodCia     = DCO.CodCia
                AND COM.IdComision = DCO.IdComision
                AND AGE.COD_AGENTE = COM.COD_AGENTE
              AND COM.idpoliza    = P_IdPoliza
              AND COM.IdFactura   = p_idFactura;

        CURSOR DET_ConC_MR (P_IdPoliza Number, p_idFactura Number ) IS
                SELECT DCO.CodConcepto, DCO.Monto_Mon_Extranjera,
                         AGE.CodTipo, AGE.CodNivel,
                         COM.Cod_Agente,
                         SUM(OC_COMISIONES.MONTO_COMISION (COM.CodCia,COM.idpoliza,AGE.CodNivel,AGE.Cod_Agente,COM.IdFactura,NULL)) MtoComision,
                         C.CodTipoPlan, COM.IdComision
                    FROM COMISIONES COM, DETALLE_COMISION DCO,
                         AGENTES AGE, CATALOGO_DE_CONCEPTOS C
                 WHERE DCO.CodConcepto IN ('HONORA','COMISI', 'COMIPF', 'COMIPM', 'UDI', 'IVAHON', 'IVASIN', 'COMACC', 'COMVDA', 'HONACC', 'HONVDA')
                     AND COM.CodCia       = DCO.CodCia
                     AND COM.IdComision   = DCO.IdComision
                     AND AGE.COD_AGENTE   = COM.COD_AGENTE
                     AND DCO.CodConcepto  = C.CodConcepto
                     AND COM.idpoliza     = P_IdPoliza
                     AND COM.IdFactura    = p_idFactura
                 GROUP BY DCO.CodConcepto, DCO.Monto_Mon_Extranjera,
                         AGE.CodTipo, AGE.CodNivel,
                         COM.Cod_Agente, C.CodTipoPlan, COM.IdComision
                 ORDER BY COM.IdComision;

        CURSOR NC_Q IS
           SELECT 'EMISION'                  PROCESO,
                  P.IdPoliza,                P.NumPolUnico,
                  P.NumPolRef,               DP.IDETPOL,
                  OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
                     OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
                  N.IdEndoso,                N.IdNcr,
                  TO_CHAR(T.FechaTransaccion,'DD/MM/YYYY') FechaTransaccion,                   -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  TO_CHAR(N.FecDevol,'DD/MM/YYYY') FecDevol,                                   -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  N.CodMoneda,               DP.IdTipoSeg,
                  DP.PlanCob,                PC.CodTipoPlan,
                  DP.CodPlanPago,
                  OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
                  P.CodCliente,
                  TO_CHAR(P.FecIniVig,'DD/MM/YYYY') FecIniVig,                                -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  TO_CHAR(P.FecFinVig,'DD/MM/YYYY') FecFinVig,                                -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  P.NumRenov,
                  P.CodCia,                  N.MtoComisi_Moneda*-1 MtoComisi_Moneda,
                  1 NumCuota,                P.CodEmpresa,
                  TO_CHAR(N.FecDevol,'DD/MM/YYYY')     FecAnul,                               -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  N.MotivAnul,
                  T.IdTransaccion,  N.IdTransaccion IdTransacEmi,
                  N.IdTransaccionAnu,
                  N.FolioFactElec,
                  N.FECFINVIG                          FECFINVIG_NCR,
                  GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(N.FecDevol ),N.CodMoneda) TIPO_CAMBIO,
                  N.STSNCR                             ESTATUS,   --PREEMI
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
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                  --
                  OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(P.CodCia, P.CodEmpresa, PC.IdTipoSeg) CodRamo,
                  OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(P.CodCia, P.CodEmpresa, PC.IdTipoSeg)) DescRamo
             FROM NOTAS_DE_CREDITO N,
                  TRANSACCION      T,
                  POLIZAS          P,
                  DETALLE_POLIZA   DP,
                  PLAN_COBERTURAS  PC,
                  POLIZAS_TEXTO_COTIZACION  TXT,
                  CATEGORIAS                CGO
            WHERE PC.PlanCob                 = DP.PlanCob
              AND PC.IdTipoSeg               = DP.IdTipoSeg
              AND PC.CodEmpresa              = DP.CodEmpresa
              AND PC.CodCia                  = DP.CodCia
              AND DP.CodCia                  = N.CodCia
              AND DP.IDetPol                 = N.IDetPol
              AND DP.IdPoliza                = N.IdPoliza
                --
              AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
              AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
              AND N.CodMoneda              = nvl(cCodMoneda, N.CODMONEDA )
              AND N.COD_AGENTE             = nvl(cCodAgente,  N.COD_AGENTE )
                --
              AND P.CodCia                   = N.CodCia
              AND P.IdPoliza                 = N.IdPoliza
              AND P.CodEmpresa               = T.CodEmpresa
              AND T.IdTransaccion            = N.IdTransaccionAnu
              AND T.IdProceso               IN (2, 8)   -- Anulaciones y Endoso
              AND TRUNC(T.FechaTransaccion) BETWEEN dFecDesde AND dFecHasta
              --
              AND TXT.CODCIA(+)              = P.CODCIA
              AND TXT.CODEMPRESA(+)          = P.CODEMPRESA
              AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
              --
              AND CGO.CODCIA(+)              = P.CODCIA
              AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
              AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
              AND CGO.CODCATEGO(+)           = P.CODCATEGO
            UNION ALL
           SELECT 'CANCELACION'                    PROCESO,
                  P.IdPoliza,                      P.NumPolUnico,
                  P.NumPolRef,                     DP.IDETPOL,
                  OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
                      OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
                  N.IdEndoso,                      N.IdNcr,
                  TO_CHAR(T.FechaTransaccion,'DD/MM/YYYY') FechaTransaccion,           -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  TO_CHAR(N.FecDevol,'DD/MM/YYYY') FecDevol,                           -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  N.CodMoneda,                     DP.IdTipoSeg,
                  DP.PlanCob,                      PC.CodTipoPlan,
                  DP.CodPlanPago,
                  OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
                  P.CodCliente,
                  TO_CHAR(P.FecIniVig,'DD/MM/YYYY') FecIniVig,                         -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  TO_CHAR(P.FecFinVig,'DD/MM/YYYY') FecFinVig,                         -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  P.NumRenov,
                  P.CodCia,                        N.MtoComisi_Moneda MtoComisi_Moneda,
                  1 NumCuota,                      P.CodEmpresa,
                  TO_CHAR(N.FecAnul,'DD/MM/YYYY')  FecAnul,                            -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  N.MotivAnul,
                  T.IdTransaccion,
                  N.IdTransaccion IdTransacEmi,    N.IdTransaccionAnu,
                  N.FolioFactElec,
                  N.FECFINVIG                      FECFINVIG_NCR,
                  GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(N.FecAnul),N.CodMoneda) TIPO_CAMBIO,
                  N.STSNCR ESTATUS,
                 --
                  DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                  NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                  UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
                  P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                  CGO.DESCCATEGO                                            CATEGORIA,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                  OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(P.CodCia, P.CodEmpresa, PC.IdTipoSeg) CodRamo,
                  OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(P.CodCia, P.CodEmpresa, PC.IdTipoSeg)) DescRamo
             FROM TRANSACCION      T,
                  DETALLE_TRANSACCION DT,
                  NOTAS_DE_CREDITO N,
                  POLIZAS          P,
                  DETALLE_POLIZA   DP,
                  PLAN_COBERTURAS  PC,
                  POLIZAS_TEXTO_COTIZACION  TXT,
                  CATEGORIAS                CGO
            WHERE DT.IDTRANSACCION           = T.IDTRANSACCION
              AND DT.CODEMPRESA              = T.CODEMPRESA
              AND DT.CODCIA                  = T.CODCIA
              AND ((DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (2)  AND DT.CODSUBPROCESO IN ('NOTACR'))
              OR   (DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (8)  AND DT.CODSUBPROCESO IN ('NCR'))
              OR   (DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (18) AND DT.CODSUBPROCESO IN ('REHNCR')))
              AND  TO_NUMBER(DT.VALOR1)  = N.IDPOLIZA
              --
              AND T.CODCIA                   = DT.CODCIA
              AND T.CODEMPRESA               = DT.CODEMPRESA
              AND TRUNC(T.FechaTransaccion) BETWEEN dFecDesde AND dFecHasta
              AND T.IDPROCESO               IN (2,8,18)
              AND (T.IDTRANSACCION  = N.IDTRANSACCION AND TO_NUMBER(DT.VALOR1)  = N.IDPOLIZA)
              AND  EXISTS (
                   SELECT
                          1
                   FROM   DETALLE_TRANSACCION    DTR
                   WHERE  DTR.IDTRANSACCION     = DT.IDTRANSACCION
                   AND    DTR.CODCIA            = DT.CODCIA
                   AND    DTR.CODEMPRESA        = DT.CODEMPRESA
                   AND  ((DTR.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (2)  AND DTR.CODSUBPROCESO IN ('NOTACR'))
                   OR    (DTR.OBJETO IN ('ENDOSOS')           AND  T.IDPROCESO  IN (8)  AND DTR.CODSUBPROCESO IN ('NSS','EXA','EXC'))
                   OR    (DTR.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (18) AND DTR.CODSUBPROCESO IN ('REHNCR')))
                    )
              AND PC.PlanCob                 = DP.PlanCob
              AND PC.IdTipoSeg               = DP.IdTipoSeg
              AND PC.CodEmpresa              = DP.CodEmpresa
              AND PC.CodCia                  = DP.CodCia
              AND DP.CodCia                  = N.CodCia
              AND DP.IDetPol                 = N.IDetPol
              AND DP.IdPoliza                = N.IdPoliza
              --
              AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
              AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
              AND N.CodMoneda              = nvl(cCodMoneda, N.CODMONEDA )
              AND N.COD_AGENTE             = nvl(cCodAgente,  N.COD_AGENTE )
              --
              AND P.CodCia                   = N.CodCia
              AND P.IdPoliza                 = N.IdPoliza
              AND P.CodEmpresa               = T.CodEmpresa
              --
              AND TXT.CODCIA(+)              = P.CODCIA
              AND TXT.CODEMPRESA(+)          = P.CODEMPRESA
              AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
              --
              AND CGO.CODCIA(+)              = P.CODCIA
              AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
              AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
              AND CGO.CODCATEGO(+)           = P.CODCATEGO
           UNION
           SELECT 'CANCELACION'                    PROCESO,
                  P.IdPoliza,                      P.NumPolUnico,
                  P.NumPolRef,                     DP.IDETPOL,
                  OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
                      OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
                  N.IdEndoso,                      N.IdNcr,
                  TO_CHAR(T.FechaTransaccion,'DD/MM/YYYY') FechaTransaccion,       -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  TO_CHAR(N.FecDevol,'DD/MM/YYYY') FecDevol,                       -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  N.CodMoneda,                     DP.IdTipoSeg,
                  DP.PlanCob,                      PC.CodTipoPlan,
                  DP.CodPlanPago,
                  OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
                  P.CodCliente,
                  TO_CHAR(P.FecIniVig,'DD/MM/YYYY') FecIniVig,                     -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  TO_CHAR(P.FecFinVig,'DD/MM/YYYY') FecFinVig,                     -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  P.NumRenov,
                  P.CodCia,                        N.MtoComisi_Moneda MtoComisi_Moneda,
                  1 NumCuota,                      P.CodEmpresa,
                  TO_CHAR(N.FecAnul,'DD/MM/YYYY')  FecAnul,                        -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA
                  N.MotivAnul,
                  T.IdTransaccion,
                  N.IdTransaccion IdTransacEmi,    N.IdTransaccionAnu,
                  N.FolioFactElec,
                  N.FECFINVIG                      FECFINVIG_NCR,
                  GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(N.FecAnul),N.CodMoneda) TIPO_CAMBIO,
                  N.STSNCR                         ESTATUS,
                 --
                  DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                  NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                  UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
                  P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                  CGO.DESCCATEGO                                            CATEGORIA,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                  OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(P.CodCia, P.CodEmpresa, PC.IdTipoSeg) CodRamo,
                  OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(P.CodCia, P.CodEmpresa, PC.IdTipoSeg)) DescRamo
             FROM TRANSACCION      T,
                  DETALLE_TRANSACCION DT,
                  NOTAS_DE_CREDITO N,
                  POLIZAS          P,
                  DETALLE_POLIZA   DP,
                  PLAN_COBERTURAS  PC,
                  POLIZAS_TEXTO_COTIZACION  TXT,
                  CATEGORIAS                CGO
            WHERE DT.IDTRANSACCION           = T.IDTRANSACCION
              AND DT.CODEMPRESA              = T.CODEMPRESA
              AND DT.CODCIA                  = T.CODCIA
              AND ((DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (2)  AND DT.CODSUBPROCESO IN ('NOTACR'))
              OR   (DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (8)  AND DT.CODSUBPROCESO IN ('NCR'))
              OR   (DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (18) AND DT.CODSUBPROCESO IN ('REHNCR')))
              AND T.CODCIA                   = DT.CODCIA
              AND T.CODEMPRESA               = DT.CODEMPRESA
              AND TRUNC(T.FechaTransaccion) BETWEEN dFecDesde AND dFecHasta
              AND T.IDPROCESO               IN (2,8,18)
              AND T.IDTRANSACCION  = N.IDTRANSACCION
              AND  EXISTS (
                   SELECT
                          1
                   FROM   DETALLE_TRANSACCION    DTR
                   WHERE  DTR.IDTRANSACCION     = DT.IDTRANSACCION
                   AND    DTR.CODCIA            = DT.CODCIA
                   AND    DTR.CODEMPRESA        = DT.CODEMPRESA
                   AND  ((DTR.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (2)  AND DTR.CODSUBPROCESO IN ('NOTACR'))
                   OR    (DTR.OBJETO IN ('ENDOSOS')           AND  T.IDPROCESO  IN (8)  AND DTR.CODSUBPROCESO IN ('NSS','EXA','EXC'))
                   OR    (DTR.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (18) AND DTR.CODSUBPROCESO IN ('REHNCR')))
                    )
              AND PC.PlanCob                 = DP.PlanCob
              AND PC.IdTipoSeg               = DP.IdTipoSeg
              AND PC.CodEmpresa              = DP.CodEmpresa
              AND PC.CodCia                  = DP.CodCia
              AND DP.CodCia                  = N.CodCia
              AND DP.IDetPol                 = N.IDetPol
              AND DP.IdPoliza                = N.IdPoliza
              --
              AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
              AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
              AND N.CodMoneda              = nvl(cCodMoneda, N.CODMONEDA )
              AND N.COD_AGENTE             = nvl(cCodAgente,  N.COD_AGENTE )
              --
              AND P.CodCia                   = N.CodCia
              AND P.IdPoliza                 = N.IdPoliza
              AND P.CodEmpresa               = T.CodEmpresa
              --
              AND TXT.CODCIA(+)              = P.CODCIA
              AND TXT.CODEMPRESA(+)          = P.CODEMPRESA
              AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
              --
              AND CGO.CODCIA(+)              = P.CODCIA
              AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
              AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
              AND CGO.CODCATEGO(+)           = P.CODCATEGO
         ORDER BY PROCESO DESC, IdNcr;

        CURSOR DET_NC_Q IS
           SELECT D.CodCpto,         D.Monto_Det_Moneda,
                  D.IndCptoPrima,    C.IndCptoServicio
             FROM DETALLE_NOTAS_DE_CREDITO D,
                  NOTAS_DE_CREDITO         N,
                  CATALOGO_DE_CONCEPTOS    C
            WHERE C.CodConcepto = D.CodCpto
              AND C.CodCia      = N.CodCia
              AND D.IdNcr       = N.IdNcr
              AND N.IdNcr       = nIdNcr;

        CURSOR DET_ConC_NCR (nIdPoliza NUMBER, nIdNcr NUMBER) IS
           SELECT DCO.CodConcepto,              DCO.Monto_Mon_Extranjera*-1 Monto_Mon_Extranjera,
                  AGE.CodTipo,                  AGE.CodNivel,
                  COM.Cod_Agente
             FROM COMISIONES COM,
                  DETALLE_COMISION DCO,
                  AGENTES AGE
            WHERE DCO.CodConcepto IN ('HONORA','COMISI','COMIPF','COMIPM','UDI')
              AND COM.CodCia     = DCO.CodCia
              AND COM.IdComision = DCO.IdComision
              AND AGE.Cod_Agente = COM.Cod_Agente
              AND COM.IdPoliza   = nIdPoliza
              AND COM.IdNcr      = nIdNcr;

        ----------------------------

        -------------------------------

    BEGIN

        --
        SELECT SYS_CONTEXT ('USERENV','CURRENT_USERID'),
               SYS_CONTEXT('userenv', 'terminal'),
               USER
          INTO cCodUser,
               W_ID_TERMINAL,
               W_ID_USER
          FROM DUAL;
        ----

        DELETE FROM T_REPORTES_AUTOMATICOS A
           WHERE A.NOMBRE_REPORTE LIKE cCodReporte || '%'
             AND A.FECHA_PROCESO <= TRUNC(ADD_MONTHS(SYSDATE,-8));
          --
          W_ID_ENVIO := OC_CONTROL_PROCESOS_AUTOMATICO.INSERTA_REGISTRO('PRIMA_NETA_COB', W_ID_TERMINAL);
          DBMS_OUTPUT.PUT_LINE('ID_ENVIO: '|| w_ID_ENVIO);
          --
          PID_ENVIO := W_ID_ENVIO;
          COMMIT;
        --
        cNomDirectorio := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SO_PATH', 'REPORT');
        --
        SELECT NVL(dFecInicio, TRUNC(sysdate - 1)) first,
               NVL(dFecFinal,  TRUNC(sysdate - 1)) last
          INTO dFecDesde, dFecHasta
          FROM DUAL;

        dbms_output.put_line('dPrimerDia '||dFecDesde);
        dbms_output.put_line('dUltimoDia '||dFecHasta);
        ----
        BEGIN
             SELECT NomCia
               INTO cNomCia
               FROM EMPRESAS
              WHERE CodCia = nCodCia;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            cNomCia := 'COMPANIA - NO EXISTE!!!';
        END;

        nLinea := 6;
        --
        cTitulo1 := cNomCia;
        cTitulo2 := 'REPORTE DE RECIBOS PRODUCCION NETA DEL  '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' AL ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || CHR(13);
        cTitulo4 := ' ';
        --
        cEncabez     := 'Proceso'||cLimitador||
                         'No. de Póliza'||cLimitador||
                         'Consecutivo'||cLimitador||
                         'No. Referencia'||cLimitador||
                         'Sub-Grupo'||cLimitador||
                         'Contratante'||cLimitador||
                         'No. de Endoso'||cLimitador||
                         'Tipo'||cLimitador||
                         'No. Recibo'||cLimitador||
                         'Forma de Pago'||cLimitador||
                         'Fecha Emisión'||cLimitador||
                         'Inicio Vigencia'||cLimitador||
                         'Fin Vigencia'||cLimitador||
                         'Fecha de Anulación'||cLimitador||
                         'Motivo Anulación'||cLimitador||
                         'Prima Neta'||cLimitador||
                         'Reducción Prima'||cLimitador||
                         'Recargos'||cLimitador||
                         'Derechos'||cLimitador||
                         'Impuesto'||cLimitador||
                         'Prima Total'||cLimitador||
                         'Comisión Sobre Prima'||cLimitador||
                         'Comisión Persona Fisica'||cLimitador||
                         'Comisión Persona Moral'||cLimitador||
                         'Honorarios Persona Fisica'||cLimitador||
                         'Honorarios Persona Moral'||cLimitador||
                         'UDIS Persona Fisica'||cLimitador||
                         'UDIS Persona Moral'||cLimitador||
                         'Dif. en Comisiones'||cLimitador||
                         'Comisión Agente'||cLimitador||
                         'Honorario Agente'||cLimitador||
                         'Agente'||cLimitador||
                         'Tipo Agente'||cLimitador||
                         'Comisión Promotor'||cLimitador||
                         'Honorario Promotor'||cLimitador||
                         'Promotor'||cLimitador||
                         'Tipo Promotor'||cLimitador||
                         'Comisión Dirección Regional'||cLimitador||
                         'Honorario Dirección Regional'||cLimitador||
                         'Dirección Regional'||cLimitador||
                         'Tipo Dirección Regional'||cLimitador||
                         'Tasa IVA'||cLimitador||
                         'Estado'||cLimitador||
                         'Moneda'||cLimitador||
                         'Tipo Cambio'||cLimitador||
                         'Tipo Seguro'||cLimitador||
                         'Plan Coberturas'||cLimitador||
                         'Código SubRamo'||cLimitador||
                         'Descripción SubRamo'||cLimitador||
                         'Ramo'||cLimitador||
                         'Tipo Vigencia'||cLimitador||
                         'No. Cuota'||cLimitador||
                         'Inicio Vig. Póliza'||cLimitador ||
                         'Fin Vig. Póliza'||cLimitador ||
                         'No. Renovacion'||cLimitador ||
                         'No. Comprobante'||cLimitador ||
                         'Folio Fact. Electrónica'||cLimitador ||
                         'Folio Fiscal'||cLimitador ||
                         'Serie'||cLimitador ||
                                   'UUID'||cLimitador ||
                                   'Fecha UUID'||cLimitador ||
                                   'Varios UUID'||cLimitador ||
                                   'Origen del Recibo'||cLimitador ||
                                   'Estatus'||cLimitador ||
                                   'Es Contributorio'||cLimitador ||
                                   '% Contributorio'||cLimitador ||
                                   'Giro de Negocio'||cLimitador ||
                                   'Tipo de Negocio'||cLimitador ||
                                   'Fuente de Recursos'||cLimitador ||
                                   'Paquete Comercial'||cLimitador ||
                                   'Categoria'||cLimitador ||
                                   'Canal de Venta'||cLimitador||
                                   'Renovacion'||cLimitador||
                         'Prima de Retiro Moneda'||cLimitador||    --> JALV (+) 09/11/2021
                         'Prima de Retiro Local'||cLimitador||--> JALV (+) 09/11/2021
                          'Código Ramo'||cLimitador||
                         'Descripción Ramo';
           --
           --dbms_output.put_line(cEncabez);
           --
            IF UPPER(cDestino) != 'REGISTRO' THEN
                INSERTA_ENCABEZADO( 'EXCEL', nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo, cEncabez, cTitulo1, cTitulo2, cTitulo4) ;
            END IF;
           --
           --dbms_output.put_line('cNomDirectorio '||cNomDirectorio||' cNomArchivo  '||cNomArchivo );
           --
              FOR X IN EMI_Q LOOP
             nIdFactura      := X.IdFactura;
             cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
          cDescFormaPago  := OC_FACTURAS.FRECUENCIA_PAGO(X.CodCia, X.IdFactura);
          dFecFin         := X.FECFINVIG_FAC;
          cFecFin         := TO_CHAR(dFecFin,'DD/MM/YYYY');

                nIdTipoSeg            := X.IdTipoSeg;
                cPlanCobert            := X.PlanCob;
          --MLJS 14/09/2020 SE OBTIENE EL RAMO
               BEGIN
                        SELECT OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS', CODTIPOPLAN)
                            INTO cRamo
                            FROM TIPOS_DE_SEGUROS
                         WHERE IDTIPOSEG = X.IdTipoSeg;
               EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                                cRamo := 'SIN DESCRIPCION';
                    WHEN OTHERS THEN
                              cRamo := 'SIN DESCRIPCION';
               END;


          BEGIN
             SELECT OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes)
               INTO cDescEstado
               FROM CLIENTES C, PERSONA_NATURAL_JURIDICA P
              WHERE P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
                AND P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
                AND C.CodCliente              = X.CodCliente;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                cDescEstado := NULL;
          END;
          IF cDescEstado = 'PROVINCIA NO EXISTE' THEN
               cDescEstado := NULL;
          END IF;

          IF X.NumRenov = 0 THEN
             cTipoVigencia := '1ER. AÑO';
             cRenovacion   := 'NUEVA';      --MLJS 22/09/2020
          ELSE
             cTipoVigencia := 'RENOVACION';
             cRenovacion   := cTipoVigencia;
          END IF;

          nPrimaNeta      := 0;
          nReducPrima     := 0;
          nRecargos       := 0;
          nDerechos       := 0;
          nImpuesto       := 0;
          nPrimaTotal     := 0;
          nComisionesPEF  := 0;
          nHonorariosPEF  := 0;
          nUdisPEF        := 0;
          nComisionesPEM  := 0;
          nHonorariosPEM  := 0;
          nUdisPEM        := 0;
          nTotComisDist   := 0;
          nMtoComiAge     := 0;
          nMtoHonoAge     := 0;
          nMtoComiProm    := 0;
          nMtoHonoProm    := 0;
          nMtoComiDR      := 0;
          nMtoHonoDR      := 0;
          --
          cTipoAge        := 0;
          cCodAge         := 0;
          cTipoProm       := 0;
          cCodProm        := 0;
          cTipoDR         := 0;
          cCodDR          := 0;

          CFolioFiscal    := NULL;
          cSerie          := NULL;
          cUUID           := NULL;
          cFechaUUID      := NULL;
          cVariosUUID     := NULL;
          --
          IF NVL(X.IndMultiramo,'N') = 'N' THEN
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
          ELSE
              FOR W IN DET_Q_MR(X.CodRamo) LOOP
                 IF (W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S') THEN
                    nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(W.Monto_Det_Moneda,0);
                 ELSIF W.CodCpto IN ('RECVDA','RECACC')  AND W.CodTipoPlan = X.CodRamo THEN
                    nRecargos   := NVL(nRecargos,0) + NVL(W.Monto_Det_Moneda,0);
                 ELSIF W.CodCpto IN ('DEREVI', 'DEREAP') AND W.CodTipoPlan = X.CodRamo THEN
                    nDerechos   := NVL(nDerechos,0) + NVL(W.Monto_Det_Moneda,0);
                 ELSIF W.CodCpto = 'IVASIN' AND X.CodRamo = OC_VALORES_DE_LISTAS.BUSCA_LVALOR('RAMOIVA', W.CodCpto) THEN
                    nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
                    nTasaIVA    := OC_CONCEPTOS_PLAN_DE_PAGOS.PORCENTAJE_CONCEPTO(X.CodCia, X.CodEmpresa, cCodPlanPagos, W.CodCpto);
                 END IF;
                 nPrimaTotal  := NVL(nPrimaNeta,0) + NVL(nRecargos,0) + NVL(nDerechos,0) + NVL(nImpuesto,0);
              END LOOP;
          END IF;
          --
          IF NVL(X.IndMultiramo,'N') = 'N' THEN
             FOR C IN DET_ConC (X.IdPoliza,X.IdFactura) LOOP
                IF C.CodTipo = 'AGTEPF' THEN --AGENTE PERSONA FISICA
                   IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                      nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                   ELSIF C.CodConcepto = 'HONORA' THEN
                      nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                   END IF;
                ELSIF C.CodTipo = 'AGTEPM' THEN -- AGENTE PERSONA MORAL
                   IF C.CodConcepto IN ('COMISI','COMIPM') THEN
                      nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                   ELSIF C.CodConcepto = 'HONORA' THEN
                      nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                   END IF;
                ELSIF C.CodTipo = 'HONPF' THEN -- HONORARIOS PERSONA FISICA
                   IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                      nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                   ELSIF C.CodConcepto = 'HONORA' THEN
                      nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                   END IF;
                ELSIF C.CodTipo = 'HONPM' THEN -- HONORARIOS PERSONA MORAL
                   IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                      nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                   ELSIF C.CodConcepto = 'HONORA' THEN
                      nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                   END IF;
                ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
                   IF C.CodConcepto = 'UDI' THEN
                      nUdisPEF        := NVL(nUdisPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                   END IF;
                ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL
                   IF C.CodConcepto = 'UDI' THEN
                      nUdisPEM        := NVL(nUdisPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                   END IF;
                END IF;
                nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
                --
                IF C.CodNivel IN (3,4) THEN                                                                 --MLJS 27/05/2022 SE AGREGO EL NIVEL 4
                              cTipoAge            := C.CodTipo;
                               cCodAge                := C.Cod_Agente;
                               IF C.CodTipo IN ('HONPM','HONPF','HONORM') AND C.CodConcepto = 'HONORA' THEN --MLJS 27/05/2022 SE AGREGO EL TIPO HONORM
                      nMtoHonoAge        := NVL(C.Monto_Mon_Extranjera,0);
                                ELSE
                      nMtoComiAge        := NVL(C.Monto_Mon_Extranjera,0);
                              END IF;
                        ELSIF C.CodNivel = 2 THEN
                               cTipoProm            := C.CodTipo;
                               cCodProm             := C.Cod_Agente;
                               IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                                    nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
                               ELSE
                      nMtoComiProm    := NVL(C.Monto_Mon_Extranjera,0);
                             END IF;
                  ELSIF C.CodNivel = 1 THEN
                               cTipoDR                := C.CodTipo;
                               cCodDR                 := C.Cod_Agente;
                               IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                                    nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
                   ELSE
                      nMtoComiDR        := NVL(C.Monto_Mon_Extranjera,0);
                             END IF;
                  END IF;
             END LOOP;
                ELSE
                    ------------------------------------------------------------------------------------------------------------------------------------------------------
                    FOR C IN DET_ConC_MR (X.IdPoliza,X.IdFactura) LOOP
                 IF C.CodTipo = 'AGTEPF' THEN --AGENTE PERSONA FISICA
                    IF C.CodConcepto IN ('COMISI','COMIPF','COMACC', 'COMVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                       nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                 ELSIF C.CodTipo = 'AGTEPM' THEN -- AGENTE PERSONA MORAL
                    IF C.CodConcepto IN ('COMISI','COMIPM', 'COMACC', 'COMVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                       nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                 ELSIF C.CodTipo = 'HONPF' THEN -- HONORARIOS PERSONA FISICA
                    IF C.CodConcepto IN ('COMISI','COMIPF', 'HONACC', 'HONVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                       nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                           ELSIF C.CodConcepto IN ('IVAHON') THEN
                        nImpuestoHonoPF   := NVL(nImpuestoHonoPF,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                    END IF;
                 ELSIF C.CodTipo = 'HONPM' THEN -- HONORARIOS PERSONA MORAL
                    IF C.CodConcepto IN ('COMISI','COMIPM', 'HONACC', 'HONVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                       nHonorariosPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);   --- CAMBIAR POR VARIABLE CORRECTA
                           ELSIF C.CodConcepto IN ('IVAHON') THEN
                        nImpuestoHonoPM  := NVL(nImpuestoHonoPM,0) + NVL(C.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                    END IF;
                 ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
                    IF C.CodConcepto = 'UDI' THEN
                       nOtrasCompPF    := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                 ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL
                    IF C.CodConcepto = 'UDI' THEN
                       nOtrasCompPM    := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                        ---- jmmd20190523Se incluyen los conceptos para HONORF y HONORM
                 ELSIF C.CODTIPO = 'HONORF' THEN -- HONORARIOS PERSONA FISICA
                                    IF C.CodConcepto = 'HONORA' THEN
                               nOtrasCompPF  := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                              ELSIF C.CodConcepto = 'IVAHON' THEN
                                nImpuestoHonoPFOC   := NVL(nImpuestoHonoPFOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                       END IF;
                 ELSIF C.CODTIPO = 'HONORM' THEN -- HONORARIOS PERSONA MORAL
                         IF C.CodConcepto = 'HONORA' THEN
                               nOtrasCompPM  := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                              ELSIF C.CodConcepto = 'IVAHON' THEN
                                nImpuestoHonoPMOC   := NVL(nImpuestoHonoPMOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                       END IF;
                        ----
                 END IF;
                 IF C.CodConcepto = 'IVASIN' THEN
                       NULL;
                 ELSE
                         nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
                 END IF;
                        --         nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
                 --
                 IF C.CodNivel IN (3,4) THEN                                                     --MLJS 27/05/2022 SE AGREGO EL NIVEL 4
                                cTipoAge            := C.CodTipo;
                                cCodAge                := C.Cod_Agente;
                                IF C.CodTipo IN ('HONPM','HONPF','HONORM') AND C.CodConcepto IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                      nMtoHonoAge        := NVL(C.Monto_Mon_Extranjera,0);                      --MLJS 27/05/2022 SE AGREGO EL TIPO HONORM
                                ELSIF C.CodTipo NOT IN ('HONPM','HONPF','HONORM') AND C.CodConcepto NOT IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                      nMtoComiAge        := NVL(C.Monto_Mon_Extranjera,0);                      --MLJS 27/05/2022 SE AGREGO EL TIPO HONORM
                                END IF;
                        ----
                         ELSIF C.CodNivel = 2 THEN
                                cTipoProm            := C.CodTipo;
                                cCodProm             := C.Cod_Agente;
                                IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                                    nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
                                ELSIF C.CodTipo NOT IN ('HONPM','HONPF') AND C.CodConcepto NOT IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                      nMtoComiProm    := NVL(C.Monto_Mon_Extranjera,0);
                                END IF;
                        ----
                   ELSIF C.CodNivel = 1 THEN
                                cTipoDR                := C.CodTipo;
                                cCodDR                 := C.Cod_Agente;
                                IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                                    nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
                    ELSIF C.CodTipo NOT IN ('HONPM','HONPF') AND C.CodConcepto NOT IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                       nMtoComiDR        := NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                   END IF;
              END LOOP;
                    ------------------------------------------------------------------------------------------------------------------------------------------------------
                END IF;

                nPrimaTotalLocal    := OC_DETALLE_FACTURAS.MONTO_PRIMAS(X.IdTransaccion);
                nFactorPrimaRamo    := OC_FACTURAR.FACTOR_PRORRATEO_RAMO(X.CodCia, X.IdPoliza, X.IDetPol, X.CodRamo, nPrimaTotalLocal);
                nDifComis := NVL(X.MtoComisi_Moneda,0) - NVL(nTotComisDist,0);

          SELECT NVL(MIN(NumComprob),'0')
            INTO cNumComprob
            FROM COMPROBANTES_CONTABLES
           WHERE CODCIA         = X.CodCia
             AND NumTransaccion = X.IdTransaccion;

          BEGIN
             SELECT FE.FOLIOFISCAL, FE.SERIE, FE.UUID, FE.FECHAUUID
               INTO cFolioFiscal, cSerie, cUUID, cFechaUUID
               FROM FACT_ELECT_DETALLE_TIMBRE FE
              WHERE FE.IDFACTURA = X.IDFACTURA
                AND FE.codproceso = 'EMI'
                AND FE.codrespuestasat = '201'
                AND FE.IDTIMBRE IN (

             SELECT MAX(FE.IDTIMBRE)
               FROM FACT_ELECT_DETALLE_TIMBRE FE
              WHERE FE.IDFACTURA = X.IDFACTURA
                AND FE.codproceso = 'EMI'
                AND FE.codrespuestasat = '201');
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                cFolioFiscal := NULL;
                      cSerie       := NULL;
                      cUUID        := NULL;
                      cFechaUUID   := NULL;
          END;

         BEGIN
             SELECT COUNT(FE.IDFACTURA)
               INTO cVariosUUID
               FROM FACT_ELECT_DETALLE_TIMBRE FE
              WHERE FE.IDFACTURA = X.IDFACTURA
                AND FE.codproceso = 'EMI'
                AND FE.codrespuestasat = '201'
              GROUP BY FE.IDFACTURA;
             EXCEPTION
             WHEN NO_DATA_FOUND THEN
                cVariosUUID := NULL;
          END;

          IF X.Proceso = 'CANCELACION' THEN
             nPrimaNeta     := nPrimaNeta*-1;
             nReducPrima    := nReducPrima*-1;
             nRecargos      := nRecargos*-1;
             nDerechos      := nDerechos*-1;
             nImpuesto      := nImpuesto*-1;
             nPrimaTotal    := nPrimaTotal*-1;
             nComisionesPEF := nComisionesPEF*-1;
             nComisionesPEM := nComisionesPEM*-1;
             nHonorariosPEF := nHonorariosPEF*-1;
             nHonorariosPEM := nHonorariosPEM*-1;
             nUdisPEF       := nUdisPEF*-1;
             nUdisPEM       := nUdisPEM*-1;
             nDifComis      := nDifComis*-1;
             nMtoComiAge    := nMtoComiAge*-1;
             nMtoHonoAge    := nMtoHonoAge*-1;
             nMtoComiProm   := nMtoComiProm*-1;
             nMtoHonoProm   := nMtoHonoProm*-1;
             nMtoComiDR     := nMtoComiDR*-1;
             nMtoHonoDR     := nMtoHonoDR*-1;
          ELSE
               nPrimaNeta     := nPrimaNeta;
             nReducPrima    := nReducPrima;
             nRecargos      := nRecargos;
             nDerechos      := nDerechos;
             nImpuesto      := nImpuesto;
             nPrimaTotal    := nPrimaTotal;
             nComisionesPEF := nComisionesPEF;
             nComisionesPEM := nComisionesPEM;
             nHonorariosPEF := nHonorariosPEF;
             nHonorariosPEM := nHonorariosPEM;
             nUdisPEF       := nUdisPEF;
             nUdisPEM       := nUdisPEM;
             nDifComis      := nDifComis;
             nMtoComiAge    := nMtoComiAge;
             nMtoHonoAge    := nMtoHonoAge;
             nMtoComiProm   := nMtoComiProm;
             nMtoHonoProm   := nMtoHonoProm;
             nMtoComiDR     := nMtoComiDR;
             nMtoHonoDR     := nMtoHonoDR;
          END IF;

          cOrigenRecibo := ORIGEN_RECIBO(X.CodCia, X.CodEmpresa, X.IdPoliza, X.IDetPol, X.IdFactura);

         cCadena := X.Proceso                                      ||cLimitador||
                    X.NumPolUnico                                  ||cLimitador||
                    TO_CHAR(X.IdPoliza,'9999999999999')            ||cLimitador||
                    X.NumPolRef                                    ||cLimitador||
                    X.IDETPOL                                      ||cLimitador||
                    X.Contratante                                  ||cLimitador||
                    TO_CHAR(X.IdEndoso,'9999999999999')            ||cLimitador||
                    'RECIBO'                                       ||cLimitador||
                    TO_CHAR(X.IdFactura,'9999999999990')           ||cLimitador||
                    cDescFormaPago                                 ||cLimitador||
                    X.FechaTransaccion                             ||cLimitador||
                    X.FecVenc                                      ||cLimitador||
                    cFecFin                                        ||cLimitador||
                    X.FecAnul                                      ||cLimitador||
                    X.MotivAnul                                    ||cLimitador||
                    TO_CHAR(nPrimaNeta,'99999999999990.00')        ||cLimitador||
                    TO_CHAR(nReducPrima,'99999999999990.00')       ||cLimitador||
                    TO_CHAR(nRecargos,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nDerechos,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nImpuesto,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nPrimaTotal,'99999999999990.00')       ||cLimitador||
                    TO_CHAR(X.MtoComisi_Moneda * nFactorPrimaRamo,'99999999999990.00')||cLimitador||
                    TO_CHAR(nComisionesPEF,'99999999999990.00')    ||cLimitador||
                    TO_CHAR(nComisionesPEM,'99999999999990.00')    ||cLimitador||
                    TO_CHAR(nHonorariosPEF,'99999999999990.00')    ||cLimitador||
                    TO_CHAR(nHonorariosPEM,'99999999999990.00')    ||cLimitador||
                    TO_CHAR(nUdisPEF,'99999999999990.00')          ||cLimitador||
                    TO_CHAR(nUdisPEM,'99999999999990.00')          ||cLimitador||
                    TO_CHAR(nDifComis,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nMtoComiAge,'99999999999990.00')       ||cLimitador||
                    TO_CHAR(nMtoHonoAge,'99999999999990.00')       ||cLimitador||
                    LPAD(cCodAge,6,'0')                            ||cLimitador||
                    cTipoAge                                       ||cLimitador||
                    TO_CHAR(nMtoComiProm,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMtoHonoProm,'99999999999990.00')      ||cLimitador||
                    LPAD(cCodProm,6,'0')                           ||cLimitador||
                    cTipoProm                                      ||cLimitador||
                    TO_CHAR(nMtoComiDR,'99999999999990.00')        ||cLimitador||
                    TO_CHAR(nMtoHonoDR,'99999999999990.00')        ||cLimitador||
                    LPAD(cCodDR,6,'0')                             ||cLimitador||
                    cTipoDR                                        ||cLimitador||
                    TO_CHAR(nTasaIVA,'999990.00')                  ||cLimitador||
                    cDescEstado                                    ||cLimitador||
                    X.Cod_Moneda                                   ||cLimitador||
                    TO_CHAR(X.TIPO_CAMBIO,'99999999999990.00')     ||cLimitador||
                    X.IdTipoSeg                                    ||cLimitador||
                    X.PlanCob                                      ||cLimitador||
                    X.CodTipoPlan                                  ||cLimitador||
                    X.DescSubRamo                                  ||cLimitador||
                    cRamo                                          ||cLimitador||
                    cTipoVigencia                                  ||cLimitador||
                    TO_CHAR(X.NumCuota,'99990')                    ||cLimitador||
                    X.FecIniVig                                    ||cLimitador||
                    X.FecFinVig                                    ||cLimitador||
                    TO_CHAR(X.NumRenov,'99990')                    ||cLimitador||
                    cNumComprob                                    ||cLimitador||
                    X.FolioFactElec                                ||cLimitador||
                    cFolioFiscal                                   ||cLimitador||
                    cSerie                                         ||cLimitador||
                    cUUID                                          ||cLimitador||
                    TO_CHAR(cFechaUUID,'DD/MM/YYYY')               ||cLimitador||
                    cVariosUUID                                    ||cLimitador||
                    cOrigenRecibo                                  ||cLimitador||
                    X.ESTATUS                                      ||cLimitador||
                    X.ESCONTRIBUTORIO                              ||cLimitador||
                    X.PORCENCONTRIBUTORIO                          ||cLimitador||
                    X.GIRONEGOCIO                                  ||cLimitador||
                    X.TIPONEGOCIO                                  ||cLimitador||
                    X.FUENTERECURSOS                               ||cLimitador||
                    X.CODPAQCOMERCIAL                              ||cLimitador||
                    X.CATEGORIA                                    ||cLimitador||
                    X.CANALFORMAVENTA                              ||cLimitador||
                    cRenovacion                                    ||cLimitador||
                    TO_CHAR(NVL(X.MontoPrimaRetiroMon,0),'99999999999990.00')   ||cLimitador||
                    TO_CHAR(NVL(X.MontoPrimaRetiroLoc,0),'99999999999990.00')   ||cLimitador||
                    X.CodRamo                                       ||cLimitador||
                    X.DescRamo                                      ||CHR(13);
                  ----
                IF UPPER(cDestino) != 'REGISTRO' THEN
                    nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena, 1);
                ELSE
                    INSERTA_REGISTROS(cCodReporte, nLineaimp, 'REPAUTPMANET', cNomArchivo, cCadena, W_ID_ENVIO);
                END IF;
                --
           END LOOP;
           --
            FOR X IN NC_Q LOOP
                nIdNcr          := X.IdNcr;
                cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
                cDescFormaPago  := 'DIRECTO';
                dFecFin         := X.FECFINVIG_NCR;
                cFecFin         := TO_CHAR(dFecFin,'DD/MM/YYYY');

          --MLJS 14/09/2020 SE OBTIENE EL RAMO
               BEGIN
                        SELECT OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS', CODTIPOPLAN)
                            INTO cRamo
                            FROM TIPOS_DE_SEGUROS
                         WHERE IDTIPOSEG = X.IdTipoSeg;
               EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                                cRamo := 'SIN DESCRIPCION';
                    WHEN OTHERS THEN
                              cRamo := 'SIN DESCRIPCION';
               END;

          BEGIN
             SELECT OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes)
               INTO cDescEstado
               FROM CLIENTES C, PERSONA_NATURAL_JURIDICA P
              WHERE P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
                AND P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
                AND C.CodCliente              = X.CodCliente;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                cDescEstado := NULL;
          END;

          IF cDescEstado = 'PROVINCIA NO EXISTE' THEN
               cDescEstado := NULL;
          END IF;

          IF X.NumRenov = 0 THEN
             cTipoVigencia := '1ER. AÑO';
             cRenovacion   := 'NUEVA';
          ELSE
             cTipoVigencia := 'RENOVACION';
             cRenovacion   := cTipoVigencia;
          END IF;

          nPrimaNeta      := 0;
          nReducPrima     := 0;
          nRecargos       := 0;
          nDerechos       := 0;
          nImpuesto       := 0;
          nPrimaTotal     := 0;
          nComisionesPEF  := 0;
          nHonorariosPEF  := 0;
          nUdisPEF        := 0;
          nComisionesPEM  := 0;
          nHonorariosPEM  := 0;
          nUdisPEM        := 0;
          nTotComisDist   := 0;
          nMtoComiAge     := 0;
          nMtoHonoAge     := 0;
          nMtoComiProm    := 0;
          nMtoHonoProm    := 0;
          nMtoComiDR      := 0;
          nMtoHonoDR      := 0;
          --
          cTipoAge        := 0;
          cCodAge         := 0;
          cTipoProm       := 0;
          cCodProm        := 0;
          cTipoDR         := 0;
          cCodDR          := 0;

          CFolioFiscal        := null;
          cSerie              := null;
          cUUID                  := null;
          cFechaUUID        := null;
          cVariosUUID     := null;
          --
          FOR W IN DET_NC_Q LOOP
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

          FOR C IN DET_ConC_NCR (X.IdPoliza, X.IdNcr) LOOP
               IF C.CODTIPO = 'AGTEPF' THEN --AGENTE PERSONA FISICA
                  IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                  nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                  ELSIF C.CodConcepto = 'HONORA' THEN
                       nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSE
                  NULL;
                END IF;
             ELSIF C.CODTIPO = 'AGTEPM' THEN -- AGENTE PERSONA MORAL
                  IF C.CodConcepto IN ('COMISI','COMIPM') THEN
                   nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                  ELSIF C.CodConcepto = 'HONORA' THEN
                        nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSE
                   NULL;
                END IF;
             ELSIF C.CODTIPO = 'HONPF' THEN -- HONORARIOS PERSONA FISICA
                IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                   nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                  ELSIF C.CodConcepto = 'HONORA' THEN
                       nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSE
                   NULL;
                END IF;
             ELSIF C.CODTIPO = 'HONPM' THEN -- HONORARIOS PERSONA MORAL
                IF C.CodConcepto IN ('COMISI','COMIPM') THEN
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
             --
             IF C.CodNivel IN (3,4) THEN                                                                 -- MLJS 27/05/2022 SE AGREGO EL NIVEL 4
                            cTipoAge            := C.CodTipo;
                            cCodAge                := C.Cod_Agente;
                            IF C.CodTipo IN ('HONPM','HONPF','HONORM') AND C.CodConcepto = 'HONORA' THEN -- MLJS 27/05/2022 SE AGREGO EL TIPO HONORM
                  nMtoHonoAge        := NVL(C.Monto_Mon_Extranjera,0);
                            ELSE
                  nMtoComiAge        := NVL(C.Monto_Mon_Extranjera,0);
                          END IF;
                     ELSIF C.CodNivel = 2 THEN
                            cTipoProm            := C.CodTipo;
                            cCodProm             := C.Cod_Agente;
                            IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                                nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
                            ELSE
                  nMtoComiProm    := NVL(C.Monto_Mon_Extranjera,0);
                          END IF;
               ELSIF C.CodNivel = 1 THEN
                            cTipoDR                := C.CodTipo;
                            cCodDR                 := C.Cod_Agente;
                            IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                                nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
                ELSE
                   nMtoComiDR        := NVL(C.Monto_Mon_Extranjera,0);
                          END IF;
               END IF;
          END LOOP;

          nDifComis := NVL(X.MtoComisi_Moneda,0) - NVL(nTotComisDist,0);

          SELECT NVL(MIN(NumComprob),'0')
            INTO cNumComprob
            FROM COMPROBANTES_CONTABLES
           WHERE CODCIA         = X.CodCia
             AND NumTransaccion = X.IdTransaccion;


    --RECUPERA FOLIO FISCAL, serie, fecha uuid anulado, cuenta de uuids NCR ESA20180620
          BEGIN
             SELECT FE.FOLIOFISCAL, FE.SERIE, FE.UUIDCANCELADO, FE.FECHAUUID
               INTO cFolioFiscal, cSerie, cUUID, cFechaUUID
               FROM FACT_ELECT_DETALLE_TIMBRE FE
              WHERE FE.IDNCR = X.IDNCR
                AND FE.codproceso= 'CAN'
                AND FE.codrespuestasat = '201'
                AND FE.IDTIMBRE IN (

            SELECT MAX(FE.IDTIMBRE)
              FROM FACT_ELECT_DETALLE_TIMBRE FE
             WHERE FE.IDNCR = X.IDNCR
               AND FE.codproceso = 'CAN'
               AND FE.codrespuestasat = '201');
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                cFolioFiscal := NULL;
                    cSerie       := NULL;
                      cUUID        := NULL;
                      cFechaUUID   := NULL;
          END;

          BEGIN
             SELECT COUNT(FE.IDNCR)
               INTO cVariosUUID
               FROM FACT_ELECT_DETALLE_TIMBRE FE
              WHERE FE.IDNCR = X.IDNCR
                AND FE.codproceso = 'CAN'
                AND FE.codrespuestasat = '201'
              GROUP BY FE.IDNCR;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                cVariosUUID := NULL;
          END;
    --    ESA20180620

          cOrigenRecibo := 'PRIMAS';

          IF X.Proceso = 'CANCELACION' THEN
             nPrimaNeta     := nPrimaNeta*-1;
             nReducPrima    := nReducPrima*-1;
             nRecargos      := nRecargos*-1;
             nDerechos      := nDerechos*-1;
             nImpuesto      := nImpuesto*-1;
             nPrimaTotal    := nPrimaTotal*-1;
             nComisionesPEF := nComisionesPEF*-1;
             nComisionesPEM := nComisionesPEM*-1;
             nHonorariosPEF := nHonorariosPEF*-1;
             nHonorariosPEM := nHonorariosPEM*-1;
             nUdisPEF       := nUdisPEF*-1;
             nUdisPEM       := nUdisPEM*-1;
             nDifComis      := nDifComis*-1;
             nMtoComiAge    := nMtoComiAge*-1;
             nMtoHonoAge    := nMtoHonoAge*-1;
             nMtoComiProm   := nMtoComiProm*-1;
             nMtoHonoProm   := nMtoHonoProm*-1;
             nMtoComiDR     := nMtoComiDR*-1;
             nMtoHonoDR     := nMtoHonoDR*-1;
          ELSE
               nPrimaNeta     := nPrimaNeta;
             nReducPrima    := nReducPrima;
             nRecargos      := nRecargos;
             nDerechos      := nDerechos;
             nImpuesto      := nImpuesto;
             nPrimaTotal    := nPrimaTotal;
             nComisionesPEF := nComisionesPEF;
             nComisionesPEM := nComisionesPEM;
             nHonorariosPEF := nHonorariosPEF;
             nHonorariosPEM := nHonorariosPEM;
             nUdisPEF       := nUdisPEF;
             nUdisPEM       := nUdisPEM;
             nDifComis      := nDifComis;
             nMtoComiAge    := nMtoComiAge;
             nMtoHonoAge    := nMtoHonoAge;
             nMtoComiProm   := nMtoComiProm;
             nMtoHonoProm   := nMtoHonoProm;
             nMtoComiDR     := nMtoComiDR;
             nMtoHonoDR     := nMtoHonoDR;
          END IF;

         cCadena := X.Proceso                                      ||cLimitador||
                    X.NumPolUnico                                  ||cLimitador||
                    TO_CHAR(X.IdPoliza,'9999999999999')            ||cLimitador||
                    X.NumPolRef                                    ||cLimitador||
                    X.IDETPOL                                      ||cLimitador||
                    X.Contratante                                  ||cLimitador||
                    TO_CHAR(X.IdEndoso,'9999999999999')            ||cLimitador||
                    'NCR'                                          ||cLimitador||
                    TO_CHAR(X.IdNcr,'9999999999990')               ||cLimitador||
                    cDescFormaPago                                 ||cLimitador||
                    X.FechaTransaccion                             ||cLimitador||
                    X.FecDevol                                     ||cLimitador||
                    cFecFin                                        ||cLimitador||
                    X.FecAnul                                      ||cLimitador||
                    X.MotivAnul                                    ||cLimitador||
                    TO_CHAR(nPrimaNeta,'99999999999990.00')        ||cLimitador||
                    TO_CHAR(nReducPrima,'99999999999990.00')       ||cLimitador||
                    TO_CHAR(nRecargos,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nDerechos,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nImpuesto,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nPrimaTotal,'99999999999990.00')       ||cLimitador||
                    TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00')||cLimitador||
                    TO_CHAR(nComisionesPEF,'99999999999990.00')    ||cLimitador||
                    TO_CHAR(nComisionesPEM,'99999999999990.00')    ||cLimitador||
                    TO_CHAR(nHonorariosPEF,'99999999999990.00')    ||cLimitador||
                    TO_CHAR(nHonorariosPEM,'99999999999990.00')    ||cLimitador||
                    TO_CHAR(nUdisPEF,'99999999999990.00')          ||cLimitador||
                    TO_CHAR(nUdisPEM,'99999999999990.00')          ||cLimitador||
                    TO_CHAR(nDifComis,'99999999999990.00')         ||cLimitador||
                    TO_CHAR(nMtoComiAge,'99999999999990.00')       ||cLimitador||
                    TO_CHAR(nMtoHonoAge,'99999999999990.00')       ||cLimitador||
                    LPAD(cCodAge,6,'0')                            ||cLimitador||
                    cTipoAge                                       ||cLimitador||
                    TO_CHAR(nMtoComiProm,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMtoHonoProm,'99999999999990.00')      ||cLimitador||
                    LPAD(cCodProm,6,'0')                           ||cLimitador||
                    cTipoProm                                      ||cLimitador||
                    TO_CHAR(nMtoComiDR,'99999999999990.00')        ||cLimitador||
                    TO_CHAR(nMtoHonoDR,'99999999999990.00')        ||cLimitador||
                    LPAD(cCodDR,6,'0')                             ||cLimitador||
                    cTipoDR                                        ||cLimitador||
                    TO_CHAR(nTasaIVA,'999990.00')                  ||cLimitador||
                    cDescEstado                                    ||cLimitador||
                    X.CodMoneda                                    ||cLimitador||
                    TO_CHAR(X.TIPO_CAMBIO,'99999999999990.00')     ||cLimitador||
                    X.IdTipoSeg                                    ||cLimitador||
                    X.PlanCob                                      ||cLimitador||
                    X.CodTipoPlan                                  ||cLimitador||
                    X.DescSubRamo                                  ||cLimitador||
                    cRamo                                          ||cLimitador||
                    cTipoVigencia                                  ||cLimitador||
                    TO_CHAR(X.NumCuota,'99990')                    ||cLimitador||
                    X.FecIniVig                                    ||cLimitador||
                    X.FecFinVig                                    ||cLimitador||
                    TO_CHAR(X.NumRenov,'99990')                    ||cLimitador||
                    cNumComprob                                    ||cLimitador||
                    X.FolioFactElec                                ||cLimitador||
                    cFolioFiscal                                   ||cLimitador||
                    cSerie                                         ||cLimitador||
                    cUUID                                          ||cLimitador||
                    TO_CHAR(cFechaUUID,'DD/MM/YYYY')               ||cLimitador||
                    cVariosUUID                                    ||cLimitador||
                    cOrigenRecibo                                  ||cLimitador||
                    X.ESTATUS                                      ||cLimitador||
                    X.ESCONTRIBUTORIO                              ||cLimitador||
                    X.PORCENCONTRIBUTORIO                          ||cLimitador||
                    X.GIRONEGOCIO                                  ||cLimitador||
                    X.TIPONEGOCIO                                  ||cLimitador||
                    X.FUENTERECURSOS                               ||cLimitador||
                    X.CODPAQCOMERCIAL                              ||cLimitador||
                    X.CATEGORIA                                    ||cLimitador||
                    X.CANALFORMAVENTA                              ||cLimitador||
                    cRenovacion                                    ||cLimitador||
                    TO_CHAR(0,'99999999999990.00')                 ||cLimitador||
                    TO_CHAR(0,'99999999999990.00')                 ||cLimitador||
                    X.CodRamo                                      ||cLimitador||
                    X.DescRamo                                     ||CHR(13);
             ----
                IF UPPER(cDestino) != 'REGISTRO' THEN
                    nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena, 1);
                ELSE
                    INSERTA_REGISTROS(cCodReporte, nLineaimp, 'REPAUTPMANET', cNomArchivo, cCadena, W_ID_ENVIO);
                END IF;
                --
           END LOOP;
            --
        cNomArchZip := SUBSTR(cNomArchivo, 1, INSTR(cNomArchivo, '.')-1) || '.zip';
            --
        IF UPPER(cDestino) != 'REGISTRO' THEN
            IF XLSX_BUILDER_PKG.EXCEL_GUARDA_LIBRO THEN
               IF ZIP_UTIL_PKG.ZIP_ARCHIVOS(cNomDirectorio, cNomArchZip, cNomArchivo) THEN
                  dbms_output.put_line('OK');
               END IF;
               OC_REPORTES_THONA.COPIA_ARCHIVO_BLOB( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomArchZip, W_ID_ENVIO, 'N' );
            END IF;

            IF UPPER(cDestino) = 'CORREO' THEN
                ENVIA_MAIL('Prima Neta',cNomDirectorio, cNomArchZip, W_ID_ENVIO, cBuzones) ;
            END IF;
        ELSE
              ENVIA_MAIL('Prima Neta',NULL, NULL, W_ID_ENVIO, cBuzones);
        END IF;

    END PRIMA_NETA_COB;
    --
    PROCEDURE RECIBOS_ANULADOS_COB (nCodCia     NUMBER,
                                      nCodEmpresa NUMBER,
                                      cIdTipoSeg VARCHAR2,
                                      cPlanCob   VARCHAR2,
                                      cCodMoneda VARCHAR2,
                                      cCodAgente VARCHAR2,
                                      dFecInicio  DATE        default trunc(sysdate),
                                      dFecFinal   DATE        default trunc(sysdate),
                                      cDestino    VARCHAR2    default 'CORREO',  --  'ARCHIVO', 'CORREO', 'REGISTRO' -- GENERERA EL ARCHIVO PARA DESCARGAR, CORREO, SE ENVIA SEGUN EL USUARIO CONECTADO Y REGISTRO ES PARA DESCARGAR EN TXT
                                  cBuzones      VARCHAR2,
                                  PID_ENVIO  OUT  NUMBER
                                      ) IS
        /* PROCEDIMIENTO QUE GENERA DOS SALIDAS, UNO A UNA TABLA Y OTRO GENERA ARCHIVO DE EXCEL*/
        cLimitador             VARCHAR2(1) :='|';
        nLinea                 NUMBER;
        nLineaimp              NUMBER := 1;
        cCadena                VARCHAR2(4000);
        cCodUser               VARCHAR2(30);
        cDescFormaPago         VARCHAR2(100);
        dFecFin                DATE;
        cFecFin                VARCHAR2(10);
        cTipoVigencia          VARCHAR2(20);
        nIdFactura             FACTURAS.IdFactura%TYPE;
        nPrimaNeta             DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nReducPrima            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nRecargos              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nDerechos              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nImpuesto              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nPrimaTotal            DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nComisionesPEF         DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nHonorariosPEF         DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nUdisPEF               DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nComisionesPEM         DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nHonorariosPEM         DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nImpuestoHonoPF        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nImpuestoHonoPM        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nImpuestoHonoPFOC      DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nImpuestoHonoPMOC      DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nUdisPEM               DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nTotComisDist          DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nDifComis              DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        cCodPlanPagos          PLAN_DE_PAGOS.CodPlanPago%TYPE;
        cCodGenerador          AGENTE_POLIZA.Cod_Agente%TYPE;
        nTasaIVA               CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
        cDescEstado            PROVINCIA.DescEstado%TYPE;
        cNumComprob            COMPROBANTES_CONTABLES.NumComprob%TYPE;
        nIdNcr                 NOTAS_DE_CREDITO.IdNcr%TYPE;
        cStsNcr                NOTAS_DE_CREDITO.StsNcr%TYPE;
        nMonto_Det_Moneda      DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
        nMonto_Mon_Extranjera  DETALLE_COMISION.Monto_Mon_Extranjera%TYPE;
        ---
        nMtoComiAge            NUMBER(28,2);
        nMtoHonoAge            NUMBER(28,2);
        cTipoAge               AGENTES.CodTipo%TYPE;
        cCodAge                AGENTES.Cod_Agente%TYPE;

        nMtoComiProm           NUMBER(28,2);
        nMtoHonoProm           NUMBER(28,2);
        cTipoProm              AGENTES.CodTipo%TYPE;
        cCodProm               AGENTES.Cod_Agente%TYPE;

        nMtoComiDR             NUMBER(28,2);
        nMtoHonoDR             NUMBER(28,2);
        cTipoDR                AGENTES.CodTipo%TYPE;
        cCodDR                 AGENTES.Cod_Agente%TYPE;

        CFolioFiscal            FACT_ELECT_DETALLE_TIMBRE.FolioFiscal%TYPE;
        cSerie                  FACT_ELECT_DETALLE_TIMBRE.Serie%TYPE;
        cUUID                   FACT_ELECT_DETALLE_TIMBRE.UUID%TYPE;
        cFechaUUID          DATE;
        cVariosUUID         NUMBER;
        cOrigenRecibo       VARCHAR2(200);
        nOtrasCompPF        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        nOtrasCompPM        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
        ----
        cNomDirectorio      VARCHAR2(100) ;
        cNomArchivo         VARCHAR2(100) := 'REC_ANU_'||to_char(trunc(sysdate - 1),'ddmmyyyy')||'.XLSX';
        cNomArchZip         VARCHAR2(100);
        --
        dPagadoHasta        DATE;
        dCubiertoHasta      DATE;
        dFecIniVig          DATE;
        nCuantosEmi         NUMBER;
        nDiasGracia         NUMBER := 0;
        nCuantosPag         NUMBER := 0;
        nMinFactura         NUMBER := 0;
        cStatuspol          VARCHAR2(3);

        nIdTipoSeg          DETALLE_POLIZA.IdTipoSeg%TYPE;
        cPlanCobert         PLAN_COBERTURAS.PlanCob%TYPE;
        nFactorPrimaRamo    NUMBER;
        nPrimaTotalLocal    NUMBER;

        ----
        dFecDesde           DATE;
        dFecHasta           DATE;
        W_ID_TERMINAL       CONTROL_PROCESOS_AUTOMATICOS.ID_TERMINAL%TYPE;
        W_ID_USER           CONTROL_PROCESOS_AUTOMATICOS.ID_USER%TYPE;
        W_ID_ENVIO          CONTROL_PROCESOS_AUTOMATICOS.ID_ENVIO%TYPE;
        cNomCia             VARCHAR2(100);
        cCodReporte         VARCHAR2(100) := 'RECIBOSANULADOS';
        ----
        cTitulo1            VARCHAR2(200);
        cTitulo2            VARCHAR2(200);
        cTitulo4            VARCHAR2(200);
        cEncabez            VARCHAR2(5000);
        ----
        cPwdEmail                   VARCHAR2(100);
        cMiMail                     USUARIOS.EMAIL%TYPE := 'notificaciones@thonaseguros.mx';
        cSaltoLinea                 VARCHAR2(5)      := '<br>';
        cHTMLHeader                 VARCHAR2(2000)   := '<html>'                                                                  ||cSaltoLinea||
                                                     '<head>'                                                                     ||cSaltoLinea||
                                                     '<meta http-equiv="Content-Language" content="en/us"/>'                      ||cSaltoLinea||
                                                     '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>'  ||cSaltoLinea||
                                                     '</head><body>'                                                              ||cSaltoLinea;
        cHTMLFooter                 VARCHAR2(100)    := '</body></html>';
        cError                      VARCHAR2(1000);
        cTextoEnv                   ENDOSO_TXT_DET.TEXTO%TYPE;
        cSubject                    VARCHAR2(1000) := 'Notificacion de recepcion del archivo de "Recibos Anulados"';
        cTexto1                     VARCHAR2(10000):= 'A quien corresponda ';
        cTexto2                     varchar2(1000) := ' Envio del archivo de "Recibos Anulados" generado en automatico de la operacion del dia anterior. ';
        cTexto4                     varchar2(1000) := ' Saludos. ';
        ----

        CURSOR ANU_Q IS
                SELECT  /*+RULE*/
                  P.IdPoliza,                       P.NumPolUnico,
                  P.NumPolRef,                      DP.IDETPOL,
                  OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
                     OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
                  F.IdEndoso,                       F.IdFactura,
                  TO_CHAR(T.FechaTransaccion,'DD/MM/YYYY') FechaTransaccion,
                  TO_CHAR(F.FecVenc,'DD/MM/YYYY')   FecVenc,
                  F.Cod_Moneda,                     DP.IdTipoSeg,
                  DP.PlanCob,                       PC.CodTipoPlan,
                  OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
                  P.CodCliente,
                  TO_CHAR(P.FecIniVig,'DD/MM/YYYY') FecIniVig,
                  TO_CHAR(P.FecFinVig,'DD/MM/YYYY') FecFinVig,
                  P.NumRenov,
                  P.CodCia,                         F.MtoComisi_Moneda,
                  F.NumCuota,                       P.CodEmpresa,
                  TO_CHAR(F.FecAnul,'DD/MM/YYYY')   FecAnul,
                  F.MotivAnul,
                  T.IdTransaccion,                  F.FolioFactElec,
                  P.CODCIA COD_CIA,                 F.FECFINVIG FECFINVIG_FAC,
                  F.STSFACT,                        GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(F.FecAnul),F.Cod_Moneda) TIPO_CAMBIO,
                 --
                  DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                  NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                  UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
                  P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                  CGO.DESCCATEGO                                            CATEGORIA,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                  F.MontoPrimaCompMoneda                                                                        MONTOPRIMARETIROMON,    --> JALV (+) 09/11/2021
                  F.MontoPrimaCompLocal                                                                            MONTOPRIMARETIROLOC,        --> JALV (+) 09/11/2021
                  CASE TS.CODTIPOPLAN
                    WHEN '099' THEN
                       OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto)
                    ELSE
                       TS.CODTIPOPLAN
                  END CodRamo,
                  CASE TS.CODTIPOPLAN
                    WHEN '099' THEN
                       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto))
                    ELSE
                       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',TS.CODTIPOPLAN)
                    END DescRamo,
                    TS.IndMultiramo
             FROM TRANSACCION         T,
                  DETALLE_TRANSACCION DT,
                  FACTURAS        F,
                  --
                  DETALLE_FACTURAS DF,
                  CATALOGO_DE_CONCEPTOS C,
                  --
                  POLIZAS         P,
                  DETALLE_POLIZA  DP,
                  --
                  TIPOS_DE_SEGUROS TS,
                  --
                  PLAN_COBERTURAS PC,
                  POLIZAS_TEXTO_COTIZACION  TXT,
                  CATEGORIAS                CGO
            WHERE DT.IDTRANSACCION           = T.IDTRANSACCION
              AND DT.CODEMPRESA              = T.CODEMPRESA
              AND DT.CODCIA                  = T.CODCIA
              AND DT.OBJETO                 IN ('FACTURAS')
              AND DT.CODSUBPROCESO          IN ('FAC','ANUFAC')
              AND TO_NUMBER(DT.VALOR4)      = F.IDFACTURA
              AND TO_NUMBER(DT.VALOR1)      = F.IDPOLIZA
              --
              AND T.CODCIA                   = DT.CODCIA
              AND T.CODEMPRESA               = DT.CODEMPRESA
              AND TRUNC(T.FechaTransaccion) between dFecDesde and dFecHasta
              AND T.IdProceso               IN (2,8,11)
              AND EXISTS (
                   SELECT
                          DISTINCT DTR.IDTRANSACCION
                   FROM   DETALLE_TRANSACCION    DTR
                   WHERE  DTR.IDTRANSACCION     = DT.IDTRANSACCION
                   AND    DTR.CODCIA            = DT.CODCIA
                   AND    DTR.CODEMPRESA        = DT.CODEMPRESA
                   AND    DTR.CORRELATIVO       > 0
                   AND  ((DTR.OBJETO IN ('FACTURAS')  AND  T.IDPROCESO  IN (2,11)  AND DTR.CODSUBPROCESO IN ('FAC'))
                    OR   (DTR.OBJETO IN ('ENDOSOS')   AND  T.IDPROCESO  IN (8)     AND DTR.CODSUBPROCESO IN ('ANUFAC')))
                     )
              AND PC.PlanCob                     = DP.PlanCob
              AND PC.IdTipoSeg                   = DP.IdTipoSeg
              AND PC.CodEmpresa                  = DP.CodEmpresa
              AND PC.CodCia                      = DP.CodCia
              AND DP.CodCia                      = F.CodCia
              AND DP.IDetPol                     = F.IDetPol
              AND DP.IdPoliza                    = F.IdPoliza
              AND F.IdFactura                   = DF.IdFactura
              AND DF.CodCpto                    = C.CodConcepto
              AND DP.IDTIPOSEG                   = TS.IDTIPOSEG
              AND DP.CODEMPRESA                  = TS.CODEMPRESA
              AND DP.CodCia                      = TS.CodCia
              AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
              AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
              AND F.Cod_Moneda              = nvl(cCodMoneda, F.Cod_Moneda)
              AND F.CodGenerador            = nvl(cCodAgente, F.CodGenerador)
              AND P.CodCia                       = F.CodCia
              AND P.IdPoliza                     = F.IDPOLIZA
              AND TXT.CODCIA(+)                  = P.CODCIA
              AND TXT.CODEMPRESA(+)              = P.CODEMPRESA
              AND TXT.IDPOLIZA(+)                = P.IDPOLIZA
              --
              AND CGO.CODCIA(+)                  = P.CODCIA
              AND CGO.CODEMPRESA(+)              = P.CODEMPRESA
              AND CGO.CODTIPONEGOCIO(+)          = P.CODTIPONEGOCIO
              AND CGO.CODCATEGO(+)               = P.CODCATEGO
              AND (C.IndCptoPrimas            = 'S'  OR C.INDCPTOFONDO = 'S')
                GROUP BY P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.IDetPol, P.CodCliente,
                    P.CodCia, P.CODGRUPOEC, DP.CODFILIAL, F.IdEndoso, F.IdFactura,
                    T.FECHATRANSACCION, F.FECVENC, F.Cod_Moneda, DP.IDTIPOSEG, DP.PLANCOB,
                    PC.CODTIPOPLAN, PC.CODTIPOPLAN, P.CodCliente, P.FECINIVIG, P.FECFINVIG,
                    P.NUMRENOV, P.CodCia, F.MtoComisi_Moneda, F.NUMCUOTA, P.CODEMPRESA, F.FecAnul, F.MotivAnul,
                    T.IDTRANSACCION, F.FOLIOFACTELEC, F.FECFINVIG, F.Cod_Moneda, F.STSFACT,
                    P.PORCENCONTRIBUTORIO, P.PORCENCONTRIBUTORIO, TXT.DESCGIRONEGOCIO,
                    P.CODTIPONEGOCIO, P.FUENTERECURSOSPRIMA, P.CODPAQCOMERCIAL, CGO.DESCCATEGO,
                    P.FORMAVENTA, F.MontoPrimaCompMoneda, F.MontoPrimaCompLocal, P.CodEmpresa,
                    OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg,
                    DP.PlanCob, C.CodConcepto), TS.CODTIPOPLAN, TS.IndMultiramo
            ORDER BY F.IdFactura;

        CURSOR DET_Q IS
           SELECT D.CodCpto,           D.Monto_Det_Moneda,
                  D.IndCptoPrima,      C.IndCptoServicio
             FROM DETALLE_FACTURAS      D,
                  FACTURAS              F,
                  CATALOGO_DE_CONCEPTOS C
            WHERE C.CodConcepto = D.CodCpto
              AND C.CodCia      = F.CodCia
              AND D.IdFactura   = F.IdFactura
              AND F.IdFactura   = nIdFactura;

            CURSOR DET_Q_MR (nCodRamo Varchar2) IS
                     SELECT D.CodCpto,            D.Monto_Det_Moneda,
                            D.IndCptoPrima,       C.IndCptoServicio,
                            OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(nCodCia, nCodEmpresa, nIdTipoSeg, cPlanCobert, C.CodConcepto) RamoPrimas,
                            C.CodTipoPlan
                 FROM DETALLE_FACTURAS      D,
                      FACTURAS              F,
                      CATALOGO_DE_CONCEPTOS C
                WHERE C.CodConcepto = D.CodCpto
                  AND C.CodCia      = F.CodCia
                  AND D.IdFactura   = F.IdFactura
                  AND F.IdFactura   = nIdFactura
                  and nvl(CodTipoPlan, OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(nCodCia, nCodEmpresa, nIdTipoSeg, cPlanCobert, C.CodConcepto)) = nCodRamo;


        CURSOR DET_ConC (P_IdPoliza Number, p_idFactura Number ) IS
           SELECT DCO.CodConcepto,             DCO.Monto_Mon_Extranjera,
                  AGE.CodTipo,                 AGE.CodNivel,
                  COM.Cod_Agente
             FROM COMISIONES       COM,
                  DETALLE_COMISION DCO,
                  AGENTES          AGE
            WHERE DCO.CodConcepto IN ('HONORA','COMISI','COMIPF','COMIPM','UDI','IVAHON')
              AND COM.CodCia     = DCO.CodCia
              AND COM.IdComision = DCO.IdComision
              AND AGE.Cod_Agente = COM.Cod_Agente
              AND COM.IdPoliza   = P_IdPoliza
              AND COM.IdFactura  = p_idFactura;

        CURSOR DET_ConC_MR (P_IdPoliza Number, p_idFactura Number ) IS
            SELECT DCO.CodConcepto, DCO.Monto_Mon_Extranjera,
                     AGE.CodTipo, AGE.CodNivel,
                     COM.Cod_Agente,
                     SUM(OC_COMISIONES.MONTO_COMISION (COM.CodCia,COM.idpoliza,AGE.CodNivel,AGE.Cod_Agente,COM.IdFactura,NULL)) MtoComision,
                     C.CodTipoPlan, COM.IdComision
                FROM COMISIONES COM, DETALLE_COMISION DCO,
                     AGENTES AGE, CATALOGO_DE_CONCEPTOS C
             WHERE DCO.CodConcepto IN ('HONORA','COMISI', 'COMIPF', 'COMIPM', 'UDI', 'IVAHON', 'IVASIN', 'COMACC', 'COMVDA', 'HONACC', 'HONVDA')
                 AND COM.CodCia       = DCO.CodCia
                 AND COM.IdComision   = DCO.IdComision
                 AND AGE.COD_AGENTE   = COM.COD_AGENTE
                 AND DCO.CodConcepto  = C.CodConcepto
                 AND COM.idpoliza     = P_IdPoliza
                 AND COM.IdFactura    = p_idFactura
             GROUP BY DCO.CodConcepto, DCO.Monto_Mon_Extranjera,
                     AGE.CodTipo, AGE.CodNivel,
                     COM.Cod_Agente, C.CodTipoPlan, COM.IdComision
             ORDER BY COM.IdComision;


        CURSOR NC_Q IS
               SELECT /*+ INDEX (NC NOTAS_DE_CREDITO_IDX_1)*/  -- MLJS 18/08/2020
                      P.IdPoliza,                      P.NumPolUnico,
                      P.NumPolRef,                     DP.IDETPOL,
                      OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
                      OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
                      N.IdEndoso,                      N.IdNcr,
                      TO_CHAR(T.FechaTransaccion,'DD/MM/YYYY') FechaTransaccion,
                      TO_CHAR(N.FecDevol,'DD/MM/YYYY') FecDevol,
                      N.CodMoneda,                     DP.IdTipoSeg,
                      DP.PlanCob,                      PC.CodTipoPlan,
                      DP.CodPlanPago,
                      OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
                      P.CodCliente,
                      TO_CHAR(P.FecIniVig,'DD/MM/YYYY') FecIniVig,
                      TO_CHAR(P.FecFinVig,'DD/MM/YYYY') FecFinVig,
                      P.NumRenov,
                      P.CodCia,                        N.MtoComisi_Moneda*-1 MtoComisi_Moneda,
                      1 NumCuota,                      P.CodEmpresa,
                      TO_CHAR(N.FecAnul,'DD/MM/YYYY')  FecAnul,
                      N.MotivAnul,
                      T.IdTransaccion,                 N.StsNcr,
                      N.IdTransaccion IdTransacEmi,    N.IdTransaccionAnu,
                      N.FolioFactElec,                 P.CODCIA COD_CIA,
                      N.FECFINVIG FECFINVIG_NCR,       GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(N.FecAnul),N.CodMoneda) TIPO_CAMBIO,
                     --
                      DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                      NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                      UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                      DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                      DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
                      P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                      CGO.DESCCATEGO                                            CATEGORIA,
                      DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                      OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(P.CodCia, P.CodEmpresa, PC.IdTipoSeg) CodRamo,
                      OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(P.CodCia, P.CodEmpresa, PC.IdTipoSeg)) DescRamo,
                      'N' IndMultiramo
                 FROM TRANSACCION      T,
                      DETALLE_TRANSACCION DT,
                      NOTAS_DE_CREDITO N,
                      POLIZAS          P,
                      DETALLE_POLIZA   DP,
                      PLAN_COBERTURAS  PC,
                      POLIZAS_TEXTO_COTIZACION  TXT,
                      CATEGORIAS                CGO
                WHERE DT.IDTRANSACCION           = T.IDTRANSACCION
                  AND DT.CODEMPRESA              = T.CODEMPRESA
                  AND DT.CODCIA                  = T.CODCIA
                  AND ((DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (2)  AND DT.CODSUBPROCESO IN ('NOTACR'))
                  OR   (DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (8)  AND DT.CODSUBPROCESO IN ('NCR'))
                  OR   (DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (18) AND DT.CODSUBPROCESO IN ('REHNCR')))
                  AND  TO_NUMBER(DT.VALOR1)  = N.IDPOLIZA
                  AND  TO_NUMBER(DT.VALOR4)  = N.IDNCR
                  --
                  AND T.CODCIA                   = DT.CODCIA
                  AND T.CODEMPRESA               = DT.CODEMPRESA
                  AND TRUNC(T.FechaTransaccion) BETWEEN dFecDesde AND dFecHasta
                  AND T.IDPROCESO               IN (2,8,18)
                  AND (T.IDTRANSACCION  = N.IDTRANSACCION AND TO_NUMBER(DT.VALOR4)  = N.IDNCR)
                  AND  EXISTS (SELECT max(1)
                               FROM   DETALLE_TRANSACCION    DTR
                               WHERE  DTR.IDTRANSACCION     = DT.IDTRANSACCION
                               AND    DTR.CODCIA            = DT.CODCIA
                               AND    DTR.CODEMPRESA        = DT.CODEMPRESA
                               AND    DTR.CORRELATIVO       > 0
                               AND  ((DTR.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (2)  AND DTR.CODSUBPROCESO IN ('NOTACR'))
                               OR    (DTR.OBJETO IN ('ENDOSOS')           AND  T.IDPROCESO  IN (8)  AND DTR.CODSUBPROCESO IN ('NSS','EXA','EXC'))
                               OR    (DTR.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (18) AND DTR.CODSUBPROCESO IN ('REHNCR')))
                               )
                  AND PC.PlanCob                 = DP.PlanCob
                  AND PC.IdTipoSeg               = DP.IdTipoSeg
                  AND PC.CodEmpresa              = DP.CodEmpresa
                  AND PC.CodCia                  = DP.CodCia
                  AND DP.CodCia                  = N.CodCia
                  AND DP.IDetPol                 = N.IDetPol
                  AND DP.IdPoliza                = N.IdPoliza
                  AND DP.IdTipoSeg               = nvl(cIdTipoSeg, DP.IdTipoSeg)
                  AND DP.PlanCob                 = nvl(cPlanCob,   DP.PlanCob)
                  AND N.CODMONEDA                = nvl(cCodMoneda, N.CODMONEDA)
                  AND N.COD_AGENTE               = nvl(cCodAgente, N.COD_AGENTE)
                  AND P.CodCia                   = N.CodCia
                  AND P.IdPoliza                 = N.IdPoliza
                  AND P.CodEmpresa               = T.CodEmpresa
                  AND TXT.CODCIA(+)              = P.CODCIA
                  AND TXT.CODEMPRESA(+)          = P.CODEMPRESA
                  AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
                  AND CGO.CODCIA(+)              = P.CODCIA
                  AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
                  AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
                  AND CGO.CODCATEGO(+)           = P.CODCATEGO
            UNION
             SELECT /*+ INDEX (NC NOTAS_DE_CREDITO_IDX_1)*/  -- MLJS 18/08/2020
                      P.IdPoliza,                      P.NumPolUnico,
                      P.NumPolRef,                     DP.IDETPOL,
                      OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
                      OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
                      N.IdEndoso,                      N.IdNcr,
                      TO_CHAR(T.FechaTransaccion,'DD/MM/YYYY') FechaTransaccion,
                      TO_CHAR(N.FecDevol,'DD/MM/YYYY') FecDevol,
                      N.CodMoneda,                     DP.IdTipoSeg,
                      DP.PlanCob,                      PC.CodTipoPlan,
                      DP.CodPlanPago,
                      OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
                      P.CodCliente,
                      TO_CHAR(P.FecIniVig,'DD/MM/YYYY') FecIniVig,
                      TO_CHAR(P.FecFinVig,'DD/MM/YYYY') FecFinVig,
                      P.NumRenov,
                      P.CodCia,                        N.MtoComisi_Moneda*-1 MtoComisi_Moneda,
                      1 NumCuota,                      P.CodEmpresa,
                      TO_CHAR(N.FecAnul,'DD/MM/YYYY')  FecAnul,
                      N.MotivAnul,
                      T.IdTransaccion,                 N.StsNcr,
                      N.IdTransaccion IdTransacEmi,    N.IdTransaccionAnu,
                      N.FolioFactElec,                 P.CODCIA COD_CIA,
                      N.FECFINVIG FECFINVIG_NCR,       GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(N.FecAnul),N.CodMoneda) TIPO_CAMBIO,
                      DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                      NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                      UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                      DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                      DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
                      P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                      CGO.DESCCATEGO                                            CATEGORIA,
                      DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                      OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(P.CodCia, P.CodEmpresa, PC.IdTipoSeg) CodRamo,
                      OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(P.CodCia, P.CodEmpresa, PC.IdTipoSeg)) DescRamo,
                      'N' IndMultiramo
                 FROM TRANSACCION      T,
                      DETALLE_TRANSACCION DT,
                      NOTAS_DE_CREDITO N,
                      POLIZAS          P,
                      DETALLE_POLIZA   DP,
                      PLAN_COBERTURAS  PC,
                      POLIZAS_TEXTO_COTIZACION  TXT,
                      CATEGORIAS                CGO
                WHERE DT.IDTRANSACCION           = T.IDTRANSACCION
                  AND DT.CODEMPRESA              = T.CODEMPRESA
                  AND DT.CODCIA                  = T.CODCIA
                  AND ((DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (2)  AND DT.CODSUBPROCESO IN ('NOTACR'))
                     OR   (DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (8)  AND DT.CODSUBPROCESO IN ('NCR'))
                     OR   (DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (18) AND DT.CODSUBPROCESO IN ('REHNCR')))
                  AND  TO_NUMBER(DT.VALOR1)  = N.IDPOLIZA
                  AND T.CODCIA                   = DT.CODCIA
                  AND T.CODEMPRESA               = DT.CODEMPRESA
                  AND TRUNC(T.FechaTransaccion) BETWEEN dFecDesde AND dFecHasta
                  AND T.IDPROCESO               IN (2,8,18)
                  AND T.IDTRANSACCION  = N.IDTRANSACCION
                  AND  EXISTS (SELECT MAX(1)
                                 FROM   DETALLE_TRANSACCION    DTR
                                WHERE  DTR.IDTRANSACCION     = DT.IDTRANSACCION
                                  AND    DTR.CODCIA            = DT.CODCIA
                                  AND    DTR.CODEMPRESA        = DT.CODEMPRESA
                                  AND    DTR.CORRELATIVO       > 0
                                  AND  ((DTR.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (2)  AND DTR.CODSUBPROCESO IN ('NOTACR'))
                                   OR    (DTR.OBJETO IN ('ENDOSOS')           AND  T.IDPROCESO  IN (8)  AND DTR.CODSUBPROCESO IN ('NSS','EXA','EXC'))
                                   OR    (DTR.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (18) AND DTR.CODSUBPROCESO IN ('REHNCR')))
                                )
                  AND PC.PlanCob                 = DP.PlanCob
                  AND PC.IdTipoSeg               = DP.IdTipoSeg
                  AND PC.CodEmpresa              = DP.CodEmpresa
                  AND PC.CodCia                  = DP.CodCia
                  AND DP.CodCia                  = N.CodCia
                  AND DP.IDetPol                 = N.IDetPol
                  AND DP.IdPoliza                = N.IdPoliza
                  AND DP.IdTipoSeg               = nvl(cIdTipoSeg, DP.IdTipoSeg)
                  AND DP.PlanCob                 = nvl(cPlanCob,   DP.PlanCob)
                  AND N.CODMONEDA                = nvl(cCodMoneda, N.CODMONEDA)
                  AND N.Cod_AGENTE               = nvl(cCodAgente, N.COD_AGENTE)
                  AND P.CodCia                   = N.CodCia
                  AND P.IdPoliza                 = N.IdPoliza
                  AND P.CodEmpresa               = T.CodEmpresa
                  --
                  AND TXT.CODCIA(+)              = P.CODCIA
                  AND TXT.CODEMPRESA(+)          = P.CODEMPRESA
                  AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
                  --
                  AND CGO.CODCIA(+)              = P.CODCIA
                  AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
                  AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
                  AND CGO.CODCATEGO(+)           = P.CODCATEGO
             ORDER BY IdNcr;

        CURSOR DET_NC_Q IS
           SELECT D.CodCpto,           D.Monto_Det_Moneda,
                  D.IndCptoPrima,      C.IndCptoServicio
             FROM DETALLE_NOTAS_DE_CREDITO D,
                  NOTAS_DE_CREDITO         N,
                  CATALOGO_DE_CONCEPTOS    C
            WHERE C.CodConcepto = D.CodCpto
              AND C.CodCia      = N.CodCia
              AND D.IdNcr       = N.IdNcr
              AND N.IdNcr       = nIdNcr;

        CURSOR DET_ConC_NCR (nIdPoliza NUMBER, nIdNcr NUMBER) IS
           SELECT DCO.CodConcepto,        DCO.Monto_Mon_Extranjera*-1 Monto_Mon_Extranjera,
                  AGE.CodTipo,            AGE.CodNivel,
                  COM.Cod_Agente
             FROM COMISIONES       COM,
                  DETALLE_COMISION DCO,
                  AGENTES          AGE
            WHERE DCO.CodConcepto IN ('HONORA','COMISI','COMIPF','COMIPM','UDI','IVAHON')
              AND COM.CodCia     = DCO.CodCia
              AND COM.IdComision = DCO.IdComision
              AND AGE.Cod_Agente = COM.Cod_Agente
              AND COM.IdPoliza   = nIdPoliza
              AND COM.IdNcr      = nIdNcr;

        ----------------------------

        -------------------------------

    BEGIN

        --
        SELECT SYS_CONTEXT ('USERENV','CURRENT_USERID'),
               SYS_CONTEXT('userenv', 'terminal'),
               USER
          INTO cCodUser,
               W_ID_TERMINAL,
               W_ID_USER
          FROM DUAL;
        ----

          DELETE FROM T_REPORTES_AUTOMATICOS A
           WHERE A.NOMBRE_REPORTE LIKE cCodReporte || '%'
             AND A.FECHA_PROCESO <= TRUNC(ADD_MONTHS(SYSDATE,-8));
          --
          W_ID_ENVIO := OC_CONTROL_PROCESOS_AUTOMATICO.INSERTA_REGISTRO('RECIBOS_ANULADOS_COB', W_ID_TERMINAL);
          DBMS_OUTPUT.PUT_LINE('ID_ENVIO: '|| w_ID_ENVIO);
          --
          PID_ENVIO := W_ID_ENVIO;
          COMMIT;
        --
        cNomDirectorio := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SO_PATH', 'REPORT');
        --
        SELECT NVL(dFecInicio, TRUNC(sysdate - 1)) first,
               NVL(dFecFinal,  TRUNC(sysdate - 1)) last
          INTO dFecDesde, dFecHasta
          FROM DUAL;

        dbms_output.put_line('dPrimerDia '||dFecDesde);
        dbms_output.put_line('dUltimoDia '||dFecHasta);
        ----
        BEGIN
             SELECT NomCia
               INTO cNomCia
               FROM EMPRESAS
              WHERE CodCia = nCodCia;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            cNomCia := 'COMPANIA - NO EXISTE!!!';
        END;

        nLinea := 6;
        --
        cTitulo1 := cNomCia;
        cTitulo2 := 'REPORTE DE RECIBOS ANULADOS DEL  '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' AL ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || CHR(13);
        cTitulo4 := ' ';
        --
        cEncabez := 'No. de Póliza'||cLimitador||
                    'Consecutivo'||cLimitador||
                    'No. Referencia'||cLimitador||
                    'Sub-Grupo'||cLimitador||
                    'Contratante'||cLimitador||
                    'No. de Endoso'||cLimitador||
                    'Tipo'||cLimitador||
                    'No. Recibo'||cLimitador||
                    'Estatus Recibo'||cLimitador||
                    'Forma de Pago'||cLimitador||
                    'Fecha Emisión/Devol.'||cLimitador||
                    'Inicio Vigencia'||cLimitador||
                    'Fin Vigencia'||cLimitador||
                    'Fecha de Anulación'||cLimitador||
                    'Motivo Anulación'||cLimitador||
                    'Prima Neta'||cLimitador||
                    'Reducción Prima'||cLimitador||
                    'Recargos'||cLimitador||
                    'Derechos'||cLimitador||
                    'Impuesto'||cLimitador||
                    'Prima Total'||cLimitador||
                    'Compensación Sobre Prima'||cLimitador||
                    'Comisión Persona Fisica'||cLimitador||
                    'Comisión Persona Moral'||cLimitador||
                    'Honorarios Persona Fisica'||cLimitador||
                    'Impuesto Honorarios P. Física'||cLimitador||
                    'Honorarios Persona Moral'||cLimitador||
                    'Impuesto Honorarios P. Moral'||cLimitador||
                    'Otras Compensaciones Físicas'||cLimitador||
                    'Impuesto Otras Compensaciones P. Física'||cLimitador||
                    'Otras Compensaciones Morales'||cLimitador||
                    'Impuesto Otras Compensaciones P. Moral'||cLimitador||
                    'Dif. en Comisiones'||cLimitador||
                    'Comisión Agente'||cLimitador||
                    'Honorario Agente'||cLimitador||
                    'Agente'||cLimitador||
                    'Tipo Agente'||cLimitador||
                    'Comisión Promotor'||cLimitador||
                    'Honorario Promotor'||cLimitador||
                    'Promotor'||cLimitador||
                    'Tipo Promotor'||cLimitador||
                    'Comisión Dirección Regional'||cLimitador||
                    'Honorario Dirección Regional'||cLimitador||
                    'Dirección Regional'||cLimitador||
                    'Tipo Dirección Regional'||cLimitador||
                    'Tasa IVA'||cLimitador||
                    'Estado'||cLimitador||
                    'Moneda'||cLimitador||
                    'Tipo Cambio'||cLimitador||
                    'Tipo Seguro'||cLimitador||
                    'Plan Coberturas'||cLimitador||
                    'Código SubRamo'||cLimitador||
                    'Descripción SubRamo'||cLimitador||
                    'Tipo Vigencia'||cLimitador||
                    'No. Cuota'||cLimitador||
                    'Inicio Vig. Póliza'||cLimitador||
                    'Fin Vig. Póliza'||cLimitador||
                    'No. Renovacion'||cLimitador||
                    'No. Comprobante'||cLimitador||
                    'Folio Fact. Electrónica'||cLimitador||
                    'Folio Fiscal'||cLimitador||
                    'Serie'||cLimitador||
                    'UUID'||cLimitador||
                    'Fecha UUID'||cLimitador||
                    'Varios UUID' ||cLimitador||
                    'Origen del Recibo' || cLimitador||
                    'Es Contributorio'||cLimitador ||
                    '% Contributorio'||cLimitador ||
                    'Giro de Negocio'||cLimitador ||
                    'Tipo de Negocio'||cLimitador ||
                    'Fuente de Recursos'||cLimitador ||
                    'Paquete Comercial'||cLimitador ||
                    'Categoria'||cLimitador ||
                    'Canal de Venta' ||cLimitador ||
                    'Estatus de Póliza'        ||cLimitador ||
                    'Fecha Pagado Hasta'       ||cLimitador ||
                    'Fecha Cobertura' ||cLimitador||
                    'Prima de Retiro Moneda'||cLimitador||
                    'Prima de Retiro Local'||cLimitador||
                    'Código Ramo'||cLimitador||
                    'Descripción Ramo'
                    ;
           --
           --dbms_output.put_line(cEncabez);
           --
            IF UPPER(cDestino) != 'REGISTRO' THEN
                INSERTA_ENCABEZADO( 'EXCEL', nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo, cEncabez, cTitulo1, cTitulo2, cTitulo4) ;
            END IF;
           --
           --dbms_output.put_line('cNomDirectorio '||cNomDirectorio||' cNomArchivo  '||cNomArchivo );
           --
           FOR X IN ANU_Q LOOP
                nIdFactura      := X.IdFactura;
                cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
                cDescFormaPago  := OC_FACTURAS.FRECUENCIA_PAGO(X.CodCia, X.IdFactura);
                dFecFin         := X.FECFINVIG_FAC;
                cFecFin         := to_char(dFecFin,'dd/mm/yyyy');

                nIdTipoSeg            := X.IdTipoSeg;
                cPlanCobert            := X.PlanCob;

                BEGIN
                 SELECT OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes)
                   INTO cDescEstado
                   FROM CLIENTES C, PERSONA_NATURAL_JURIDICA P
                  WHERE P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
                    AND P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
                    AND C.CodCliente              = X.CodCliente;
                EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    cDescEstado := NULL;
                END;
                IF cDescEstado = 'PROVINCIA NO EXISTE' THEN
                   cDescEstado := NULL;
                END IF;

                IF X.NumRenov = 0 THEN
                   cTipoVigencia := '1ER. AÑO';
                ELSE
                    cTipoVigencia := 'RENOVACION';
                END IF;

                SELECT STSPOLIZA, FECINIVIG
                  INTO cStatuspol, dFecIniVig
                  FROM POLIZAS
                 WHERE IDPOLIZA = X.IDPOLIZA;


                BEGIN
                    SELECT DIASCANCELACION
                        INTO nDiasGracia
                        FROM TIPOS_DE_SEGUROS
                     WHERE IDTIPOSEG = X.IdTipoSeg;
                EXCEPTION WHEN OTHERS THEN
                    nDiasGracia := 45;
                END;

                BEGIN
                    SELECT MAX(FECFINVIG)
                      INTO dPagadoHasta
                        FROM FACTURAS
                        WHERE IDPOLIZA = X.IdPoliza
                        AND STSFACT = 'PAG';
                EXCEPTION WHEN OTHERS THEN
                    dPagadoHasta := dFecIniVig;
                END;
                ----
                SELECT COUNT(*)
                  INTO nCuantosEmi
                  FROM FACTURAS
                WHERE IDPOLIZA = X.IdPoliza
                    AND STSFACT = 'EMI';

                SELECT COUNT(*)
                  INTO nCuantosPag
                  FROM FACTURAS
                 WHERE IDPOLIZA = X.IdPoliza
                    AND STSFACT = 'PAG';

                IF nCuantosEmi > 0 THEN
                    SELECT MIN(IDFACTURA)
                      INTO nMinFactura
                        FROM FACTURAS
                        WHERE IDPOLIZA = X.IdPoliza
                        AND STSFACT = 'EMI';

                    SELECT FECVENC + nDiasGracia
                      INTO dCubiertoHasta
                      FROM FACTURAS
                     WHERE IDPOLIZA = X.IdPoliza
                       AND IDFACTURA = nMinFactura;
                ELSIF nCuantosPag > 0 THEN
                    SELECT MAX(IDFACTURA)
                    INTO nMinFactura
                      FROM FACTURAS
                     WHERE IDPOLIZA = X.IdPoliza
                       AND STSFACT = 'PAG';

                    SELECT FECFINVIG + nDiasGracia
                      INTO dCubiertoHasta
                      FROM FACTURAS
                     WHERE IDPOLIZA = X.IdPoliza
                       AND IDFACTURA = nMinFactura;
                ELSE
                  SELECT dFecIniVig + nDiasGracia
                        INTO dCubiertoHasta
                        FROM DUAL;
                END IF;
            --
                nPrimaNeta      := 0;
                nReducPrima     := 0;
                nRecargos       := 0;
                nDerechos       := 0;
                nImpuesto       := 0;
                nPrimaTotal     := 0;
                nComisionesPEF  := 0;
                nHonorariosPEF  := 0;
                nUdisPEF        := 0;
                nComisionesPEM  := 0;
                nHonorariosPEM  := 0;
                nUdisPEM        := 0;
                nTotComisDist   := 0;
                nMtoComiAge     := 0;
                nMtoHonoAge     := 0;
                nMtoComiProm    := 0;
                nMtoHonoProm    := 0;
                nMtoComiDR      := 0;
                nMtoHonoDR      := 0;
                nImpuestoHonoPF := 0;
                nImpuestoHonoPM := 0;
                nImpuestoHonoPFOC := 0;
                nImpuestoHonoPMOC := 0;
                --
                cTipoAge        := 0;
                cCodAge         := 0;
                cTipoProm       := 0;
                cCodProm        := 0;
                cTipoDR         := 0;
                cCodDR          := 0;
                nOtrasCompPF    := 0;
                nOtrasCompPM    := 0;
                --
                IF NVL(X.IndMultiramo,'N') = 'N' THEN
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
                ELSE
                      FOR W IN DET_Q_MR(X.CodRamo) LOOP
                         IF (W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S')   THEN
                            nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(W.Monto_Det_Moneda,0);
                         ELSIF W.CodCpto IN ('RECVDA','RECACC')  AND W.CodTipoPlan = X.CodRamo THEN
                            nRecargos   := NVL(nRecargos,0) + NVL(W.Monto_Det_Moneda,0);
                         ELSIF W.CodCpto IN ('DEREVI', 'DEREAP') AND W.CodTipoPlan = X.CodRamo THEN
                            nDerechos   := NVL(nDerechos,0) + NVL(W.Monto_Det_Moneda,0);
                         ELSIF W.CodCpto = 'IVASIN' AND X.CodRamo = OC_VALORES_DE_LISTAS.BUSCA_LVALOR('RAMOIVA', W.CodCpto) THEN
                            nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
                            nTasaIVA    := OC_CONCEPTOS_PLAN_DE_PAGOS.PORCENTAJE_CONCEPTO(X.CodCia, X.CodEmpresa, cCodPlanPagos, W.CodCpto);
                         END IF;
                         nPrimaTotal  := NVL(nPrimaNeta,0) + NVL(nRecargos,0) + NVL(nDerechos,0) + NVL(nImpuesto,0);
                      END LOOP;
                END IF;

                IF NVL(X.IndMultiramo,'N') = 'N' THEN
                    FOR C IN DET_ConC (X.IdPoliza,X.IdFactura) LOOP
                        IF C.CODTIPO = 'AGTEPF' THEN --AGENTE PERSONA FISICA
                            IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                               nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                            ELSIF C.CodConcepto = 'HONORA' THEN
                               nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                            END IF;
                         ELSIF C.CODTIPO = 'AGTEPM' THEN -- AGENTE PERSONA MORAL
                            IF C.CodConcepto IN ('COMISI','COMIPM') THEN
                               nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                            ELSIF C.CodConcepto = 'HONORA' THEN
                               nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                            END IF;
                         ELSIF C.CODTIPO = 'HONPF' THEN -- HONORARIOS PERSONA FISICA
                            IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                               nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                            ELSIF C.CodConcepto = 'HONORA' THEN
                               nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                               ELSIF C.CodConcepto = 'IVAHON' THEN
                                nImpuestoHonoPF   := NVL(nImpuestoHonoPF,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd201900603 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                            END IF;
                         ELSIF C.CODTIPO = 'HONPM' THEN -- HONORARIOS PERSONA MORAL
                            IF C.CodConcepto IN ('COMISI','COMIPM') THEN
                               nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                              ELSIF C.CodConcepto = 'HONORA' THEN
                                    nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                               ELSIF C.CodConcepto = 'IVAHON' THEN
                                nImpuestoHonoPM   := NVL(nImpuestoHonoPM,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd201906003 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                            END IF;
                         ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
                            IF C.CodConcepto = 'UDI' THEN
                               nOtrasCompPF  := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                            END IF;
                         ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL
                            IF C.CodConcepto = 'UDI' THEN
                               nOtrasCompPM  := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                            END IF;
                         ELSIF C.CODTIPO = 'HONORF' THEN -- HONORARIOS PERSONA FISICA
                            IF C.CodConcepto = 'HONORA' THEN
                               nOtrasCompPF  := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                            ELSIF C.CodConcepto = 'IVAHON' THEN
                               nImpuestoHonoPFOC   := NVL(nImpuestoHonoPFOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190603 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                               END IF;
                         ELSIF C.CODTIPO = 'HONORM' THEN -- HONORARIOS PERSONA MORAL
                            IF C.CodConcepto = 'HONORA' THEN
                               nOtrasCompPM  := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                            ELSIF C.CodConcepto = 'IVAHON' THEN
                               nImpuestoHonoPMOC   := NVL(nImpuestoHonoPMOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190603 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                            END IF;
                        END IF;
                        IF C.CodConcepto != 'IVAHON' THEN
                           nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
                        END IF;
                        --
                        IF C.CodNivel in (3,4) THEN                                                      --MLJS 27/05/2022 SE AGREGO EL NIVEL 4
                            cTipoAge            := C.CodTipo;
                            cCodAge                := C.Cod_Agente;
                            IF C.CodTipo IN ('HONPM','HONPF','HONORM') AND C.CodConcepto = 'HONORA' THEN --MLJS 27/05/2022 SE AGREGO EL TIPO HONORM
                                nMtoHonoAge        := NVL(C.Monto_Mon_Extranjera,0);
                            ELSE
                              nMtoComiAge        := NVL(C.Monto_Mon_Extranjera,0);
                            END IF;
                        ELSIF C.CodNivel = 2 THEN
                            cTipoProm            := C.CodTipo;
                            cCodProm             := C.Cod_Agente;
                            IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                               nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
                            ELSE
                               nMtoComiProm    := NVL(C.Monto_Mon_Extranjera,0);
                            END IF;
                        ELSIF C.CodNivel = 1 THEN
                            cTipoDR                := C.CodTipo;
                            cCodDR                 := C.Cod_Agente;
                            IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                               nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
                            ELSE
                               nMtoComiDR        := NVL(C.Monto_Mon_Extranjera,0);
                            END IF;
                        END IF;
                    END LOOP;
                ELSE
                    ------------------------------------------------------------------------------------------------------------------------------------------------------
                    FOR C IN DET_ConC_MR (X.IdPoliza,X.IdFactura) LOOP
                        IF C.CodTipo = 'AGTEPF' THEN --AGENTE PERSONA FISICA
                            IF C.CodConcepto IN ('COMISI','COMIPF','COMACC', 'COMVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                               nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                            END IF;
                        ELSIF C.CodTipo = 'AGTEPM' THEN -- AGENTE PERSONA MORAL
                            IF C.CodConcepto IN ('COMISI','COMIPM', 'COMACC', 'COMVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                               nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                            END IF;
                        ELSIF C.CodTipo = 'HONPF' THEN -- HONORARIOS PERSONA FISICA
                            IF C.CodConcepto IN ('COMISI','COMIPF', 'HONACC', 'HONVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                               nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                            ELSIF C.CodConcepto IN ('IVAHON') THEN
                               nImpuestoHonoPF   := NVL(nImpuestoHonoPF,0) + NVL(c.Monto_Mon_Extranjera,0);
                            END IF;
                        ELSIF C.CodTipo = 'HONPM' THEN -- HONORARIOS PERSONA MORAL
                            IF C.CodConcepto IN ('COMISI','COMIPM', 'HONACC', 'HONVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                               nHonorariosPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                            ELSIF C.CodConcepto IN ('IVAHON') THEN
                                nImpuestoHonoPM  := NVL(nImpuestoHonoPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                            END IF;
                        ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
                            IF C.CodConcepto = 'UDI' THEN
                               nOtrasCompPF    := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                            END IF;
                        ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL
                            IF C.CodConcepto = 'UDI' THEN
                               nOtrasCompPM    := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                            END IF;
                        ELSIF C.CODTIPO = 'HONORF' THEN -- HONORARIOS PERSONA FISICA
                            IF C.CodConcepto = 'HONORA' THEN
                               nOtrasCompPF  := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                            ELSIF C.CodConcepto = 'IVAHON' THEN
                               nImpuestoHonoPFOC   := NVL(nImpuestoHonoPFOC,0) + NVL(c.Monto_Mon_Extranjera,0);
                            END IF;
                         ELSIF C.CODTIPO = 'HONORM' THEN -- HONORARIOS PERSONA MORAL
                            IF C.CodConcepto = 'HONORA' THEN
                               nOtrasCompPM  := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                            ELSIF C.CodConcepto = 'IVAHON' THEN
                               nImpuestoHonoPMOC   := NVL(nImpuestoHonoPMOC,0) + NVL(c.Monto_Mon_Extranjera,0);
                            END IF;
                        END IF;
                        IF C.CodConcepto != 'IVASIN' THEN
                           nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
                        END IF;
                        --
                        IF C.CodNivel IN (3,4) THEN                                                            --MLJS 27/05/2022 SE AGREGO EL NIVEL 4
                            cTipoAge            := C.CodTipo;
                            cCodAge             := C.Cod_Agente;
                            IF C.CodTipo IN ('HONPM','HONPF','HONORM') AND C.CodConcepto IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                                nMtoHonoAge        := NVL(C.Monto_Mon_Extranjera,0);                           --MLJS 27/05/2022 SE AGREGO EL TIPO HONORM
                            ELSIF C.CodTipo NOT IN ('HONPM','HONPF','HONORM') AND C.CodConcepto NOT IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                                nMtoComiAge        := NVL(C.Monto_Mon_Extranjera,0);                           --MLJS 27/05/2022 SE AGREGO EL TIPO HONORM
                            END IF;    -- ASI ESTABA SE CAMBIA POR EL DE ABAJO PARA DESGLOSAR MAS LOS CONCEPTOS
                            ----
                        ELSIF C.CodNivel = 2 THEN
                            cTipoProm            := C.CodTipo;
                            cCodProm             := C.Cod_Agente;
                            IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                               nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
                            ELSIF C.CodTipo NOT IN ('HONPM','HONPF') AND C.CodConcepto NOT IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                               nMtoComiProm    := NVL(C.Monto_Mon_Extranjera,0);
                            END IF;
                           ----
                        ELSIF C.CodNivel = 1 THEN
                            cTipoDR                := C.CodTipo;
                            cCodDR                 := C.Cod_Agente;
                            IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                               nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
                            ELSIF C.CodTipo NOT IN ('HONPM','HONPF') AND C.CodConcepto NOT IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                               nMtoComiDR        := NVL(C.Monto_Mon_Extranjera,0);
                            END IF;
                            ----
                        END IF;
                    END LOOP;
                            ------------------------------------------------------------------------------------------------------------------------------------------------------
                END IF;

                nPrimaTotalLocal    := OC_DETALLE_FACTURAS.MONTO_PRIMAS(X.IdTransaccion);
                nFactorPrimaRamo    := OC_FACTURAR.FACTOR_PRORRATEO_RAMO(X.CodCia, X.IdPoliza, X.IDetPol, X.CodRamo, nPrimaTotalLocal);
                nDifComis := NVL(X.MtoComisi_Moneda,0) - NVL(nTotComisDist,0);

                SELECT NVL(MIN(NumComprob),'0')
                  INTO cNumComprob
                  FROM COMPROBANTES_CONTABLES
                 WHERE CODCIA         = X.COD_CIA
                   AND NumTransaccion = X.IdTransaccion;

                BEGIN
                    SELECT FE.FOLIOFISCAL, FE.SERIE, FE.UUIDCANCELADO, FE.FECHAUUID
                      INTO cFolioFiscal, cSerie, cUUID, cFechaUUID
                      FROM FACT_ELECT_DETALLE_TIMBRE FE
                     WHERE FE.IDFACTURA = X.IDFACTURA
                       AND FE.codproceso = 'CAN'
                       AND FE.IDTIMBRE IN (SELECT MAX(FE.IDTIMBRE)
                                              FROM FACT_ELECT_DETALLE_TIMBRE FE
                                                WHERE FE.IDFACTURA = X.IDFACTURA
                                                  AND FE.codproceso = 'CAN'
                                                  AND FE.codrespuestasat in ('201', '2001'));
                EXCEPTION WHEN NO_DATA_FOUND THEN
                    cFolioFiscal := NULL;
                    cSerie       := NULL;
                    cUUID        := NULL;
                    cFechaUUID   := NULL;
                END;

                BEGIN
                  SELECT COUNT(FE.IDFACTURA)
                    INTO cVariosUUID
                    FROM FACT_ELECT_DETALLE_TIMBRE FE
                   WHERE FE.IDFACTURA = X.IDFACTURA
                     AND FE.codproceso = 'CAN'
                     AND FE.codrespuestasat in ('201', '2001');
                EXCEPTION WHEN NO_DATA_FOUND THEN
                     cVariosUUID := NULL;
                END;

                cOrigenRecibo := ORIGEN_RECIBO(X.CodCia, X.CodEmpresa, X.IdPoliza, X.IDetPol, X.IdFactura);
               --
                cCadena := X.NumPolUnico                                  ||cLimitador||
                            TO_CHAR(X.IdPoliza,'9999999999999')            ||cLimitador||
                            X.NumPolRef                                    ||cLimitador||
                            X.IDETPOL                                      ||cLimitador||
                            X.Contratante                                  ||cLimitador||
                            TO_CHAR(X.IdEndoso,'9999999999999')            ||cLimitador||
                            'RECIBO'                                       ||cLimitador||
                            TO_CHAR(X.IdFactura,'9999999999990')           ||cLimitador||
                            X.STSFACT                                      ||cLimitador||
                            cDescFormaPago                                 ||cLimitador||
                            X.FechaTransaccion                             ||cLimitador||
                            X.FecVenc                                      ||cLimitador||
                            cFecFin                                        ||cLimitador||
                            X.FecAnul                                      ||cLimitador||
                            X.MotivAnul                                    ||cLimitador||
                            TO_CHAR(nPrimaNeta,'99999999999990.00')        ||cLimitador||
                            TO_CHAR(nReducPrima,'99999999999990.00')       ||cLimitador||
                            TO_CHAR(nRecargos,'99999999999990.00')         ||cLimitador||
                            TO_CHAR(nDerechos,'99999999999990.00')         ||cLimitador||
                            TO_CHAR(nImpuesto,'99999999999990.00')         ||cLimitador||
                            TO_CHAR(nPrimaTotal,'99999999999990.00')       ||cLimitador||
                            TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00')||cLimitador||
                            TO_CHAR(nComisionesPEF,'99999999999990.00')    ||cLimitador||
                            TO_CHAR(nComisionesPEM,'99999999999990.00')    ||cLimitador||
                            TO_CHAR(nHonorariosPEF,'99999999999990.00')    ||cLimitador||
                            TO_CHAR(nImpuestoHonoPF,'99999999999990.00')   ||cLimitador||
                            TO_CHAR(nHonorariosPEM,'99999999999990.00')    ||cLimitador||
                            TO_CHAR(nImpuestoHonoPM,'99999999999990.00')   ||cLimitador||
                            TO_CHAR(nOtrasCompPF,'99999999999990.00')      ||cLimitador||
                            TO_CHAR(nImpuestoHonoPFOC,'99999999999990.00') ||cLimitador||
                            TO_CHAR(nOtrasCompPm,'99999999999990.00')      ||cLimitador||
                            TO_CHAR(nImpuestoHonoPMOC,'99999999999990.00') ||cLimitador||
                            TO_CHAR(nDifComis,'99999999999990.00')         ||cLimitador||
                            TO_CHAR(nMtoComiAge,'99999999999990.00')       ||cLimitador||
                            TO_CHAR(nMtoHonoAge,'99999999999990.00')       ||cLimitador||
                            LPAD(cCodAge,6,'0')                            ||cLimitador||
                            cTipoAge                                       ||cLimitador||
                            TO_CHAR(nMtoComiProm,'99999999999990.00')      ||cLimitador||
                            TO_CHAR(nMtoHonoProm,'99999999999990.00')      ||cLimitador||
                            LPAD(cCodProm,6,'0')                           ||cLimitador||
                            cTipoProm                                      ||cLimitador||
                            TO_CHAR(nMtoComiDR,'99999999999990.00')        ||cLimitador||
                            TO_CHAR(nMtoHonoDR,'99999999999990.00')        ||cLimitador||
                            LPAD(cCodDR,6,'0')                             ||cLimitador||
                            cTipoDR                                        ||cLimitador||
                            TO_CHAR(nTasaIVA,'999990.00')                  ||cLimitador||
                            cDescEstado                                    ||cLimitador||
                            X.Cod_Moneda                                   ||cLimitador||
                            TO_CHAR(X.TIPO_CAMBIO,'99999999999990.00')     ||cLimitador||
                            X.IdTipoSeg                                    ||cLimitador||
                            X.PlanCob                                      ||cLimitador||
                            X.CodTipoPlan                                  ||cLimitador||
                            X.DescSubRamo                                  ||cLimitador||
                            cTipoVigencia                                  ||cLimitador||
                            TO_CHAR(X.NumCuota,'99990')                    ||cLimitador||
                            X.FecIniVig                                    ||cLimitador||
                            X.FecFinVig                                    ||cLimitador||
                            TO_CHAR(X.NumRenov,'99990')                    ||cLimitador||
                            cNumComprob                                    ||cLimitador||
                            X.FolioFactElec                                ||cLimitador||
                            cFolioFiscal                                   ||cLimitador||
                            cSerie                                         ||cLimitador||
                            cUUID                                          ||cLimitador||
                            TO_CHAR(cFechaUUID,'DD/MM/YYYY')               ||cLimitador||
                            cVariosUUID                                    ||cLimitador||
                            cOrigenRecibo                                  ||cLimitador||
                            X.ESCONTRIBUTORIO                              ||cLimitador||
                            X.PORCENCONTRIBUTORIO                          ||cLimitador||
                            X.GIRONEGOCIO                                  ||cLimitador||
                            X.TIPONEGOCIO                                  ||cLimitador||
                            X.FUENTERECURSOS                               ||cLimitador||
                            X.CODPAQCOMERCIAL                              ||cLimitador||
                            X.CATEGORIA                                    ||cLimitador||
                            X.CANALFORMAVENTA                              ||cLimitador||
                            cStatuspol                                                                         ||cLimitador||
                            TO_CHAR(dPagadoHasta,'DD/MM/YYYY')                     ||cLimitador||
                            TO_CHAR(dCubiertoHasta,'DD/MM/YYYY')                     ||cLimitador||
                            TO_CHAR(NVL(X.MontoPrimaRetiroMon,0),'99999999999990.00')        ||cLimitador||
                            TO_CHAR(NVL(X.MontoPrimaRetiroLoc,0),'99999999999990.00')        ||cLimitador||
                            X.CodRamo        ||cLimitador||
                            X.DescRamo       ||
                            CHR(13);
                  ----
                IF UPPER(cDestino) != 'REGISTRO' THEN
                    nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena, 1);
                ELSE
                    INSERTA_REGISTROS(cCodReporte, nLineaimp, 'REPAUTRECANU', cNomArchivo, cCadena, W_ID_ENVIO);
                END IF;
                --
           END LOOP;
           --
           FOR X IN NC_Q LOOP
              nIdNcr          := X.IdNcr;
              cStsNcr         := X.StsNcr;
              cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
              cDescFormaPago  := 'DIRECTO';
              dFecFin         := X.FECFINVIG_NCR;
              cFecFin         := to_char(dFecFin,'dd/mm/yyyy');

              BEGIN
                 SELECT OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes)
                   INTO cDescEstado
                   FROM CLIENTES C, PERSONA_NATURAL_JURIDICA P
                  WHERE P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
                    AND P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
                    AND C.CodCliente              = X.CodCliente;
              EXCEPTION WHEN NO_DATA_FOUND THEN
                    cDescEstado := NULL;
              END;

              IF cDescEstado = 'ESTADO NO EXISTE' THEN
                   cDescEstado := NULL;
              END IF;

              IF X.NumRenov = 0 THEN
                 cTipoVigencia := '1ER. AÑO';
              ELSE
                 cTipoVigencia := 'RENOVACION';
              END IF;

              nPrimaNeta      := 0;
              nReducPrima     := 0;
              nRecargos       := 0;
              nDerechos       := 0;
              nImpuesto       := 0;
              nPrimaTotal     := 0;
              nComisionesPEF  := 0;
              nHonorariosPEF  := 0;
              nUdisPEF        := 0;
              nComisionesPEM  := 0;
              nHonorariosPEM  := 0;
              nUdisPEM        := 0;
              nTotComisDist   := 0;
              nMtoComiAge     := 0;
              nMtoHonoAge     := 0;
              nMtoComiProm    := 0;
              nMtoHonoProm    := 0;
              nMtoComiDR      := 0;
              nMtoHonoDR      := 0;
              nImpuestoHonoPF := 0;
              nImpuestoHonoPM := 0;
              nImpuestoHonoPFOC := 0;
              nImpuestoHonoPMOC := 0;
              --
              cTipoAge        := 0;
              cCodAge         := 0;
              cTipoProm       := 0;
              cCodProm        := 0;
              cTipoDR         := 0;
              cCodDR          := 0;
              nOtrasCompPF    := 0;
              nOtrasCompPM    := 0;
              --

              FOR W IN DET_NC_Q LOOP
                 IF X.IdTransaccionAnu = X.IdTransaccion THEN
                      nMonto_Det_Moneda := NVL(W.Monto_Det_Moneda,0) * -1;
                 ELSE
                      nMonto_Det_Moneda := NVL(W.Monto_Det_Moneda,0);
                 END IF;
                 --
                 IF W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S' THEN
                    nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(nMonto_Det_Moneda,0);
                 ELSIF W.CodCpto = 'RECFIN' THEN
                    nRecargos   := NVL(nRecargos,0) + NVL(nMonto_Det_Moneda,0);
                 ELSIF W.CodCpto = 'DEREMI' THEN
                    nDerechos   := NVL(nDerechos,0) + NVL(nMonto_Det_Moneda,0);
                 ELSIF W.CodCpto = 'IVASIN' THEN
                    nImpuesto   := NVL(nImpuesto,0) + NVL(nMonto_Det_Moneda,0);
                    nTasaIVA    := OC_CONCEPTOS_PLAN_DE_PAGOS.PORCENTAJE_CONCEPTO(X.CodCia, X.CodEmpresa, cCodPlanPagos, W.CodCpto);
                 ELSE
                    nImpuesto   := NVL(nImpuesto,0) + NVL(nMonto_Det_Moneda,0);
                 END IF;
                 nPrimaTotal  := NVL(nPrimaTotal,0) + NVL(nMonto_Det_Moneda,0);
              END LOOP;

              FOR C IN DET_ConC_NCR (X.IdPoliza, X.IdNcr) LOOP
                IF X.IdTransaccionAnu = X.IdTransaccion THEN
                      nMonto_Mon_Extranjera := NVL(C.Monto_Mon_Extranjera,0) * -1;
                ELSE
                      nMonto_Mon_Extranjera := NVL(C.Monto_Mon_Extranjera,0);
                END IF;
                --
                IF C.CODTIPO = 'AGTEPF' THEN --AGENTE PERSONA FISICA
                    IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                      nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(nMonto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'HONORA' THEN
                      nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(nMonto_Mon_Extranjera,0);
                    END IF;
                ELSIF C.CODTIPO = 'AGTEPM' THEN -- AGENTE PERSONA MORAL
                    IF C.CodConcepto IN ('COMISI','COMIPM') THEN
                       nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(nMonto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'HONORA' THEN
                            nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(nMonto_Mon_Extranjera,0);
                    END IF;
                ELSIF C.CODTIPO = 'HONPF' THEN -- HONORARIOS PERSONA FISICA
                    IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                       nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(nMonto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'HONORA' THEN
                           nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(nMonto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'IVAHON' THEN
                        nImpuestoHonoPF   := NVL(nImpuestoHonoPF,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190603 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                    END IF;
                ELSIF C.CODTIPO = 'HONPM' THEN -- HONORARIOS PERSONA MORAL
                    IF C.CodConcepto IN ('COMISI','COMIPM') THEN
                       nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(nMonto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'HONORA' THEN
                          nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(nMonto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'IVAHON' THEN
                        nImpuestoHonoPM   := NVL(nImpuestoHonoPM,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190603 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                    END IF;
                ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
                    IF C.CodConcepto = 'UDI' THEN
                       nOtrasCompPF  := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL
                    IF C.CodConcepto = 'UDI' THEN
                       nOtrasCompPM  := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                ELSIF C.CODTIPO = 'HONORF' THEN -- HONORARIOS PERSONA FISICA    --- MLJS 10/03/2021
                    IF C.CodConcepto = 'HONORA' THEN
                       nOtrasCompPF  := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'IVAHON' THEN
                          nImpuestoHonoPFOC   := NVL(nImpuestoHonoPFOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190603 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                    END IF;
                ELSIF C.CODTIPO = 'HONORM' THEN -- HONORARIOS PERSONA MORAL
                    IF C.CodConcepto = 'HONORA' THEN
                       nOtrasCompPM  := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'IVAHON' THEN
                          nImpuestoHonoPMOC   := NVL(nImpuestoHonoPMOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                    END IF;
                END IF;
                IF C.CodConcepto != 'IVAHON' THEN
                   nTotComisDist   := NVL(nTotComisDist,0) + NVL(nMonto_Mon_Extranjera,0);
                END IF;
        -------------------
                IF C.CodNivel IN (3,4) THEN                                                                --MLJS 27/05/2022 SE AGREGO EL NIVEL 4
                   cTipoAge            := C.CodTipo;
                   cCodAge            := C.Cod_Agente;
                   IF C.CodTipo IN ('HONPM','HONPF','HONORM') AND C.CodConcepto = 'HONORA' THEN            --MLJS 27/05/2022 SE AGREGO EL TIPO HONORM
                      nMtoHonoAge        := NVL(C.Monto_Mon_Extranjera,0);
                   ELSE
                      nMtoComiAge        := NVL(C.Monto_Mon_Extranjera,0);
                   END IF;
                ----
                ELSIF C.CodNivel = 2 THEN
                    cTipoProm            := C.CodTipo;
                    cCodProm             := C.Cod_Agente;
                    IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                       nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
                    ELSE
                      nMtoComiProm    := NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
               --------------------
                ELSIF C.CodNivel = 1 THEN
                    cTipoDR                := C.CodTipo;
                    cCodDR                 := C.Cod_Agente;
                    IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                       nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
                    ELSE
                       nMtoComiDR        := NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                END IF;
              END LOOP;
              --------------------

              nDifComis := NVL(X.MtoComisi_Moneda,0) - NVL(nTotComisDist,0);

              SELECT NVL(MIN(NumComprob),'0')
                INTO cNumComprob
                FROM COMPROBANTES_CONTABLES
               WHERE CODCIA         = X.COD_CIA
                 AND NumTransaccion = X.IdTransaccion;

              BEGIN
                 SELECT FE.FOLIOFISCAL, FE.SERIE, FE.UUID, FE.FECHAUUID
                   INTO cFolioFiscal, cSerie, cUUID, cFechaUUID
                   FROM FACT_ELECT_DETALLE_TIMBRE FE
                  WHERE FE.IDNCR = X.IDNCR
                    AND FE.codproceso = 'EMI'
                    AND FE.FOLIOFISCAL IN (SELECT MAX(FE.FOLIOFISCAL)
                                             FROM FACT_ELECT_DETALLE_TIMBRE FE
                                            WHERE FE.IDNCR = X.IDNCR
                                              AND FE.codproceso = 'EMI'
                                              AND FE.codrespuestasat = '201');
              EXCEPTION WHEN NO_DATA_FOUND THEN
                    cFolioFiscal := NULL;
                    cSerie       := NULL;
                    cUUID        := NULL;
                    cFechaUUID   := NULL;
              END;
              BEGIN
                 SELECT count(FE.IDNCR)
                   INTO cVariosUUID
                   FROM FACT_ELECT_DETALLE_TIMBRE FE
                  WHERE FE.IDNCR = X.IDNCR
                    AND FE.codproceso = 'EMI'
                    AND FE.codrespuestasat = '201'
                  GROUP BY FE.IDNCR;
              EXCEPTION WHEN NO_DATA_FOUND THEN
                    cVariosUUID := NULL;
              END;

              cOrigenRecibo := 'PRIMAS';

              cCadena := X.NumPolUnico                                  ||cLimitador||
                            TO_CHAR(X.IdPoliza,'9999999999999')            ||cLimitador||
                            X.NumPolRef                                    ||cLimitador||
                            X.IDETPOL                                      ||cLimitador||
                            X.Contratante                                  ||cLimitador||
                            TO_CHAR(X.IdEndoso,'9999999999999')            ||cLimitador||
                            'NCR'                                          ||cLimitador||
                            TO_CHAR(X.IdNcr,'9999999999990')               ||cLimitador||
                            X.STSNCR                                       ||cLimitador||
                            cDescFormaPago                                 ||cLimitador||
                            X.FechaTransaccion                             ||cLimitador||
                            X.FecDevol                                     ||cLimitador||
                            cFecFin                                        ||cLimitador||
                            X.FecAnul                                      ||cLimitador||
                            X.MotivAnul                                    ||cLimitador||
                            TO_CHAR(nPrimaNeta,'99999999999990.00')        ||cLimitador||
                            TO_CHAR(nReducPrima,'99999999999990.00')       ||cLimitador||
                            TO_CHAR(nRecargos,'99999999999990.00')         ||cLimitador||
                            TO_CHAR(nDerechos,'99999999999990.00')         ||cLimitador||
                            TO_CHAR(nImpuesto,'99999999999990.00')         ||cLimitador||
                            TO_CHAR(nPrimaTotal,'99999999999990.00')       ||cLimitador||
                            TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00')||cLimitador||
                            TO_CHAR(nComisionesPEF,'99999999999990.00')    ||cLimitador||
                            TO_CHAR(nComisionesPEM,'99999999999990.00')    ||cLimitador||
                            TO_CHAR(nHonorariosPEF,'99999999999990.00')    ||cLimitador||
                            TO_CHAR(nImpuestoHonoPF,'99999999999990.00')   ||cLimitador||
                            TO_CHAR(nHonorariosPEM,'99999999999990.00')    ||cLimitador||
                            TO_CHAR(nImpuestoHonoPM,'99999999999990.00')   ||cLimitador||
                            TO_CHAR(nOtrasCompPF,'99999999999990.00')      ||cLimitador||
                            TO_CHAR(nImpuestoHonoPFOC,'99999999999990.00') ||cLimitador||
                            TO_CHAR(nOtrasCompPM,'99999999999990.00')      ||cLimitador||
                            TO_CHAR(nImpuestoHonoPMOC,'99999999999990.00') ||cLimitador||
                            TO_CHAR(nDifComis,'99999999999990.00')         ||cLimitador||
                            TO_CHAR(nMtoComiAge,'99999999999990.00')       ||cLimitador||
                            TO_CHAR(nMtoHonoAge,'99999999999990.00')       ||cLimitador||
                            LPAD(cCodAge,6,'0')                            ||cLimitador||
                            cTipoAge                                       ||cLimitador||
                            TO_CHAR(nMtoComiProm,'99999999999990.00')      ||cLimitador||
                            TO_CHAR(nMtoHonoProm,'99999999999990.00')      ||cLimitador||
                            LPAD(cCodProm,6,'0')                           ||cLimitador||
                            cTipoProm                                      ||cLimitador||
                            TO_CHAR(nMtoComiDR,'99999999999990.00')        ||cLimitador||
                            TO_CHAR(nMtoHonoDR,'99999999999990.00')        ||cLimitador||
                            LPAD(cCodDR,6,'0')                             ||cLimitador||
                            cTipoDR                                        ||cLimitador||
                            TO_CHAR(nTasaIVA,'999990.00')                  ||cLimitador||
                            cDescEstado                                    ||cLimitador||
                            X.CodMoneda                                    ||cLimitador||
                            TO_CHAR(X.TIPO_CAMBIO,'99999999999990.00')     ||cLimitador||
                            X.IdTipoSeg                                    ||cLimitador||
                            X.PlanCob                                      ||cLimitador||
                            X.CodTipoPlan                                  ||cLimitador||
                            X.DescSubRamo                                  ||cLimitador||
                            cTipoVigencia                                  ||cLimitador||
                            TO_CHAR(X.NumCuota,'99990')                    ||cLimitador||
                            X.FecIniVig                                    ||cLimitador||
                            X.FecFinVig                                    ||cLimitador||
                            TO_CHAR(X.NumRenov,'99990')                    ||cLimitador||
                            cNumComprob                                    ||cLimitador||
                            X.FolioFactElec                                ||cLimitador||
                            cFolioFiscal                                   ||cLimitador||
                            cSerie                                         ||cLimitador||
                            cUUID                                          ||cLimitador||
                            TO_CHAR(cFechaUUID,'DD/MM/YYYY')               ||cLimitador||
                            cVariosUUID                                    ||cLimitador||
                            cOrigenRecibo                                  ||cLimitador||
                            X.ESCONTRIBUTORIO                              ||cLimitador||
                            X.PORCENCONTRIBUTORIO                          ||cLimitador||
                            X.GIRONEGOCIO                                  ||cLimitador||
                            X.TIPONEGOCIO                                  ||cLimitador||
                            X.FUENTERECURSOS                               ||cLimitador||
                            X.CODPAQCOMERCIAL                              ||cLimitador||
                            X.CATEGORIA                                    ||cLimitador||
                            X.CANALFORMAVENTA                              ||cLimitador||
                            cStatuspol                                     ||cLimitador||
                            TO_CHAR(dPagadoHasta,'DD/MM/YYYY')             ||cLimitador||
                            TO_CHAR(dCubiertoHasta,'DD/MM/YYYY')           ||cLimitador||
                            TO_CHAR(0,'99999999999990.00')                 ||cLimitador||
                            TO_CHAR(0,'99999999999990.00')                 ||cLimitador||
                            X.CodRamo                                      ||cLimitador||
                            X.DescRamo                                     ||
                            CHR(13);
             ----
             --DBMS_OUTPUT.PUT_LINE(cCadena);
                IF UPPER(cDestino) != 'REGISTRO' THEN
                    nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena, 1);
                ELSE
                    INSERTA_REGISTROS(cCodReporte, nLineaimp, 'REPAUTRECANU', cNomArchivo, cCadena, W_ID_ENVIO);
                END IF;
                --
           END LOOP;
            --
           cNomArchZip := SUBSTR(cNomArchivo, 1, INSTR(cNomArchivo, '.')-1) || '.zip';
            --
        IF UPPER(cDestino) != 'REGISTRO' THEN
            IF XLSX_BUILDER_PKG.EXCEL_GUARDA_LIBRO THEN
               IF ZIP_UTIL_PKG.ZIP_ARCHIVOS(cNomDirectorio, cNomArchZip, cNomArchivo) THEN
                  dbms_output.put_line('OK');
               END IF;
               OC_REPORTES_THONA.COPIA_ARCHIVO_BLOB( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomArchZip, W_ID_ENVIO, 'N' );
            END IF;

            IF UPPER(cDestino) = 'CORREO' THEN
              ENVIA_MAIL('Recibos anulados',cNomDirectorio, cNomArchZip, W_ID_ENVIO, cBuzones) ;
            END IF;
        ELSE
              ENVIA_MAIL('Recibos anulados',NULL, NULL, W_ID_ENVIO, cBuzones);
        END IF;

    END RECIBOS_ANULADOS_COB;
    --
    PROCEDURE RECIBOS_EMITIDOS_COB (nCodCia     NUMBER,
                                    nCodEmpresa NUMBER,
                                    cIdTipoSeg VARCHAR2,
                                    cPlanCob   VARCHAR2,
                                    cCodMoneda VARCHAR2,
                                    cCodAgente VARCHAR2,
                                    dFecInicio  DATE        default trunc(sysdate),
                                    dFecFinal   DATE        default trunc(sysdate),
                                    cDestino    VARCHAR2    default 'CORREO',  --  'ARCHIVO', 'CORREO', 'REGISTRO' -- GENERERA EL ARCHIVO PARA DESCARGAR, CORREO, SE ENVIA SEGUN EL USUARIO CONECTADO Y REGISTRO ES PARA DESCARGAR EN TXT
                                  cBuzones      VARCHAR2,
                                  PID_ENVIO  OUT  NUMBER
                                    ) IS

            /* PROCEDIMIENTO QUE GENERA DOS SALIDAS, UNO A UNA TABLA Y OTRO GENERA ARCHIVO DE EXCEL*/
            cLimitador      VARCHAR2(1) :='|';
            nLinea          NUMBER;
            nLineaimp       NUMBER := 1;
            cCadena         VARCHAR2(4000);
            cCadenaAux      VARCHAR2(4000);
            cCadenaAux1     VARCHAR2(4000);
            cCodUser        VARCHAR2(30);
            nDummy          NUMBER;
            cCopy           BOOLEAN;
            W_ID_TERMINAL   VARCHAR2(100);
            W_ID_USER       VARCHAR2(100);
            W_ID_ENVIO      VARCHAR2(100);
            cDescFormaPago  VARCHAR2(100);
            dFecFin         DATE;
            cFecFin         VARCHAR2(10);
            cTipoVigencia   VARCHAR2(20);
            nIdFactura      FACTURAS.IdFactura%TYPE;
            nPrimaNeta      DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nReducPrima     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nRecargos       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nDerechos       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nImpuesto       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nImpuestoHonoPF DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nImpuestoHonoPM DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nImpuestoHonoPFOC DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nImpuestoHonoPMOC DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nPrimaTotal     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nComisionesPEF  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nHonorariosPEF  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nUdisPEF        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nComisionesPEM  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nHonorariosPEM  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nUdisPEM        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nTotComisDist   DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nDifComis       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            cCodPlanPagos   PLAN_DE_PAGOS.CodPlanPago%TYPE;
            cCodGenerador   AGENTE_POLIZA.Cod_Agente%TYPE;
            nTasaIVA        CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
            cDescEstado     PROVINCIA.DescEstado%TYPE;
            nFrecPagos      PLAN_DE_PAGOS.FrecPagos%TYPE;
            nCodTipo        AGENTES.CODTIPO%TYPE;
            cNumComprob     COMPROBANTES_CONTABLES.NumComprob%TYPE;
            cTipoEndoso     ENDOSOS.TipoEndoso%TYPE;
            dFecFinVig      ENDOSOS.FecFinVig%TYPE;
            nIdNcr          NOTAS_DE_CREDITO.IdNcr%TYPE;
            ---
            nMtoHonoAge     NUMBER(28,2);
            nMtoComiAge     NUMBER(28,2);
            cTipoAge        AGENTES.CodTipo%TYPE;
            cCodAge         AGENTES.Cod_Agente%TYPE;

            nMtoComiProm    NUMBER(28,2);
            nMtoHonoProm    NUMBER(28,2);
            cTipoProm       AGENTES.CodTipo%TYPE;
            cCodProm        AGENTES.Cod_Agente%TYPE;

            nMtoComiDR      NUMBER(28,2);
            nMtoHonoDR      NUMBER(28,2);
            cTipoDR         AGENTES.CodTipo%TYPE;
            cCodDR          AGENTES.Cod_Agente%TYPE;
            CFolioFiscal    FACT_ELECT_DETALLE_TIMBRE.FolioFiscal%TYPE;
            cSerie          FACT_ELECT_DETALLE_TIMBRE.Serie%TYPE;
            cUUID           FACT_ELECT_DETALLE_TIMBRE.UUID%TYPE;
            cFechaUUID      DATE;
            cVariosUUID     NUMBER;
            cOrigenRecibo   VARCHAR2(200);
            nOtrasCompPF    DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nOtrasCompPM    DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            ----
            dPagadoHasta    DATE;
            dCubiertoHasta  DATE;
            dFecIniVig      DATE;
            nCuantosEmi            NUMBER;
            nDiasGracia            NUMBER := 0;
            nCuantosPag            NUMBER := 0;
            nMinFactura            NUMBER := 0;
            cStatuspol            VARCHAR2(3);
            --
            cCtlArchivo     UTL_FILE.FILE_TYPE;

            cNomDirectorio  VARCHAR2(100) ;
            cNomArchivo VARCHAR2(100) := 'REC_EMI_'||to_char(trunc(sysdate - 1),'ddmmyyyy')||'.XLSX';
            cNomArchZip           VARCHAR2(100);
            cCodReporte           VARCHAR2(100) := 'RECIBOSEMITIDOS';
            cNomCia               VARCHAR2(100);
            cTitulo1              VARCHAR2(200);
            cTitulo2              VARCHAR2(200);
            cTitulo4              VARCHAR2(200);
            cEncabez              VARCHAR2(5000);
            nColsTotales     NUMBER := 0;
            nColsLateral     NUMBER := 0;
            nColsMerge       NUMBER := 0;
            nColsCentro      NUMBER := 0;
            --nJustCentro      NUMBER := 3;
            nJustIzquierdo   NUMBER := 1;
            dFecDesde DATE;
            dFecHasta DATE;
            nSPV             NUMBER := 0;
            cRutaNomArchivo  varchar2(100);
            l_bfile         BFILE;
            l_blob          CLOB;

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
            cTextoEnv                   ENDOSO_TXT_DET.TEXTO%TYPE;
            cSubject                    VARCHAR2(1000) := 'Notificacion de recepcion del archivo de "Recibos Emitidos"';
            cTexto1                     VARCHAR2(10000):= 'A quien corresponda:';
            cTexto2                     varchar2(1000)   := ' Envio del archivo de "Recibos Emitidos" generado en automatico de la operacion del dia anterior';
            cTexto3                     varchar2(10)   := '  ';
            cTexto4                     varchar2(1000)   := ' Saludos. ';
            ----
            nIdTipoSeg                  DETALLE_POLIZA.IdTipoSeg%TYPE;
            cPlanCobert                 PLAN_COBERTURAS.PlanCob%TYPE;
            nCompensacionMR             DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nFactorPrimaRamo        NUMBER;
            nPrimaTotalLocal        NUMBER;
            --

            CURSOR EMI_Q  IS
                SELECT
                       IdPoliza,               NUMPOLUNICO,
                       NUMPOLREF,              IDETPOL,
                       CONTRATANTE,            IDENDOSO,
                       IDFACTURA,
                       TO_CHAR(FECHATRANSACCION,'DD/MM/YYYY') FECHATRANSACCION,
                       TO_CHAR(FECVENC,'DD/MM/YYYY')          FECVENC,
                       COD_MONEDA,
                       IDTIPOSEG,              PLANCOB,
                       CODTIPOPLAN,            DESCSUBRAMO,
                       CODCLIENTE,
                       TO_CHAR(FECINIVIG,'DD/MM/YYYY') FECINIVIG,
                       TO_CHAR(FECFINVIG,'DD/MM/YYYY') FECFINVIG,
                       NUMRENOV,
                       CODCIA,                 MTOCOMISI_MONEDA,
                       NUMCUOTA,               CODEMPRESA,
                       IDTRANSACCION,          FOLIOFACTELEC,
                       FECFINVIG_FAC,          TIPO_CAMBIO,
                       ESTATUS,
                       --
                       ESCONTRIBUTORIO,
                       PORCENCONTRIBUTORIO,
                       GIRONEGOCIO,
                       TIPONEGOCIO,
                       FUENTERECURSOS,
                       CODPAQCOMERCIAL,
                       CATEGORIA,
                       CANALFORMAVENTA,
                       MONTOPRIMARETIROMON,
                       MONTOPRIMARETIROLOC,
                       CodRamo,
                       DescRamo,
                       IndMultiramo
                FROM
                (
                   SELECT /*+RULE*/
                          P.IdPoliza,                      P.NumPolUnico,
                          P.NumPolRef,                     DP.IDetPol,
                          OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
                          OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CODGRUPOEC, DP.CODFILIAL) CONTRATANTE,
                          F.IdEndoso,                      F.IdFactura,
                          T.FECHATRANSACCION,
                          F.FECVENC,
                          F.Cod_Moneda,                    DP.IDTIPOSEG,
                          DP.PLANCOB,
                          PC.CODTIPOPLAN,
                          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS',PC.CODTIPOPLAN) DESCSUBRAMO,
                          P.CodCliente,                    P.FECINIVIG,
                          P.FECFINVIG,                     P.NUMRENOV,
                          P.CodCia,                        F.MtoComisi_Moneda,
                          F.NUMCUOTA,                      P.CODEMPRESA,
                          T.IDTRANSACCION,                 F.FOLIOFACTELEC,
                          F.FECFINVIG FecFinVig_Fac,       GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(T.FECHATRANSACCION),F.Cod_Moneda) tipo_cambio,
                          F.STSFACT  Estatus,
                          --
                          DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                          NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                          UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
                          P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                          CGO.DESCCATEGO                                            CATEGORIA,
                          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                          F.MontoPrimaCompMoneda                                                                        MONTOPRIMARETIROMON,    --> JALV (+) 09/11/2021
                          F.MontoPrimaCompLocal                                                                            MONTOPRIMARETIROLOC,        --> JALV (+) 09/11/2021
                          CASE TS.CODTIPOPLAN
                            WHEN '099' THEN
                               OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto)
                            ELSE
                               TS.CODTIPOPLAN
                          END CodRamo,
                          CASE TS.CODTIPOPLAN
                            WHEN '099' THEN
                               OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto))
                            ELSE
                               OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',TS.CODTIPOPLAN)
                            END DescRamo,
                            TS.IndMultiramo
                     FROM TRANSACCION         T,
                          DETALLE_TRANSACCION DT,
                          FACTURAS        F,
                          --
                          DETALLE_FACTURAS DF,
                          CATALOGO_DE_CONCEPTOS C,
                          --
                          POLIZAS         P,
                          DETALLE_POLIZA  DP,
                          --
                          TIPOS_DE_SEGUROS TS,
                          --
                          PLAN_COBERTURAS PC,
                          POLIZAS_TEXTO_COTIZACION  TXT,
                          CATEGORIAS                CGO
                    WHERE T.CODCIA                   = NCODCIA
                      AND T.CODEMPRESA               = NCODEMPRESA
                      AND TRUNC(T.FECHATRANSACCION) between DFECDESDE AND DFECHASTA
                      AND T.IDPROCESO  IN (7, 8, 14, 18, 21)
                      AND DT.CodCia                  = T.CodCia
                      AND DT.CODEMPRESA              = T.CODEMPRESA
                      AND DT.IDTRANSACCION           = T.IDTRANSACCION
                      AND DT.OBJETO                  IN ('FACTURAS')
                      AND DT.CODSUBPROCESO           IN ('FAC','REHAB','FACFON','CONFAC')
                      --
                      AND F.CodCia                   = DT.CodCia
                      AND F.IdPoliza                 = TO_NUMBER(DT.VALOR1)
                      AND F.IDTRANSACCION            = DT.IDTRANSACCION
                      AND F.STSFACT                 != 'PRE'
                      --
                      AND EXISTS
                           (SELECT MAX(1)
                            FROM   DETALLE_TRANSACCION    DTR
                            WHERE  DTR.IDTRANSACCION     = DT.IDTRANSACCION
                            AND    DTR.CodCia            = DT.CodCia
                            AND    DTR.CODEMPRESA        = DT.CODEMPRESA
                            AND  ((DTR.OBJETO IN ('FACTURAS')  AND  T.IDPROCESO  IN (7, 14, 18, 21) AND DTR.CODSUBPROCESO IN ('FAC','REHAB','FACFON','CONFAC'))
                            OR    (DTR.OBJETO IN ('ENDOSOS')   AND  T.IDPROCESO  IN (8)             AND DTR.CODSUBPROCESO IN ('CFP','AUM', 'EAD', 'INA', 'INC', 'IND', 'REHAP', 'RSS')))
                            )
                      AND P.CodCia                   = F.CodCia
                      AND P.CODEMPRESA               = T.CODEMPRESA
                      AND P.IdPoliza                 = F.IdPoliza
                      --
                      AND DP.CodCia                  = P.CodCia
                      AND DP.IdPoliza                = P.IdPoliza
                      AND DP.IDetPol                 = F.IDetPol
                      AND DF.IdFactura               = F.IdFactura
                      AND PC.CodCia                  = DP.CodCia
                      AND PC.CODEMPRESA              = DP.CODEMPRESA
                      AND PC.PLANCOB                 = DP.PLANCOB
                      AND PC.IDTIPOSEG               = DP.IDTIPOSEG
                      AND TS.CodCia                  = PC.CodCia
                      AND TS.CODEMPRESA              = PC.CODEMPRESA
                      AND TS.IDTIPOSEG               = PC.IDTIPOSEG
                      AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
                      AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
                      AND F.Cod_Moneda              = nvl(cCodMoneda, F.Cod_Moneda)
                      AND F.CodGenerador            = nvl(cCodAgente, F.CodGenerador)
                       --
                      AND TXT.CodCia(+)              = P.CodCia
                      AND TXT.IdPoliza(+)            = P.IdPoliza
                      --
                      AND CGO.CodCia(+)              = P.CodCia
                      AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
                      AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
                      AND CGO.CODCATEGO(+)           = P.CODCATEGO
                      AND C.CODCIA                   = P.CODCIA
                      AND C.CodConcepto              = DF.CodCpto
                      AND (C.IndCptoPrimas            = 'S'  OR C.INDCPTOFONDO = 'S')
                   GROUP BY P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.IDetPol, P.CodCliente,
                            P.CodCia, P.CODGRUPOEC, DP.CODFILIAL, F.IdEndoso, F.IdFactura,
                            T.FECHATRANSACCION, F.FECVENC, F.Cod_Moneda, DP.IDTIPOSEG, DP.PLANCOB,
                            PC.CODTIPOPLAN, PC.CODTIPOPLAN, P.CodCliente, P.FECINIVIG, P.FECFINVIG,
                            P.NUMRENOV, P.CodCia, F.MtoComisi_Moneda, F.NUMCUOTA, P.CODEMPRESA,
                            T.IDTRANSACCION, F.FOLIOFACTELEC, F.FECFINVIG, F.Cod_Moneda, F.STSFACT,
                            P.PORCENCONTRIBUTORIO, P.PORCENCONTRIBUTORIO, TXT.DESCGIRONEGOCIO,
                            P.CODTIPONEGOCIO, P.FUENTERECURSOSPRIMA, P.CODPAQCOMERCIAL, CGO.DESCCATEGO,
                            P.FORMAVENTA, F.MontoPrimaCompMoneda, F.MontoPrimaCompLocal, P.CodEmpresa,
                            OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg,
                            DP.PlanCob, C.CodConcepto), TS.CODTIPOPLAN, TS.IndMultiramo
                UNION
                   SELECT /*+RULE*/
                          P.IdPoliza,                      P.NUMPOLUNICO,
                          P.NUMPOLREF,                     DP.IDETPOL,
                          OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE) || ' ' ||
                          OC_FILIALES.NOMBRE_ADICIONAL(P.CODCIA, P.CODGRUPOEC, DP.CODFILIAL) CONTRATANTE,
                          F.IDENDOSO,                      F.IDFACTURA,
                          T.FECHATRANSACCION,
                          F.FECVENC,
                          F.COD_MONEDA,                    DP.IDTIPOSEG,
                          DP.PLANCOB,                      PC.CODTIPOPLAN,
                          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CODTIPOPLAN) DESCSUBRAMO,
                          P.CODCLIENTE,                    P.FECINIVIG,
                          P.FECFINVIG,                     P.NUMRENOV,
                          P.CODCIA,                        F.MTOCOMISI_MONEDA,
                          F.NUMCUOTA,                      P.CODEMPRESA,
                          T.IDTRANSACCION,                 F.FOLIOFACTELEC,
                          F.FECFINVIG FECFINVIG_FAC,       GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(T.FECHATRANSACCION),F.COD_MONEDA) TIPO_CAMBIO,
                          F.STSFACT  ESTATUS,
                          --
                          DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                          NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                          UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
                          P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                          CGO.DESCCATEGO                                            CATEGORIA,
                          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                          F.MontoPrimaCompMoneda                                                                        MONTOPRIMARETIROMON,    --> JALV (+) 09/11/2021
                          F.MontoPrimaCompLocal                                                                            MONTOPRIMARETIROLOC,        --> JALV (+) 09/11/2021
                          CASE TS.CODTIPOPLAN
                            WHEN '099' THEN
                               OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto)
                            ELSE
                               TS.CODTIPOPLAN
                          END CodRamo,
                          CASE TS.CODTIPOPLAN
                            WHEN '099' THEN
                               OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto))
                            ELSE
                               OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',TS.CODTIPOPLAN)
                            END DescRamo,
                            TS.IndMultiramo
                     FROM TRANSACCION         T,
                          DETALLE_TRANSACCION DT,
                          FACTURAS        F,
                          --
                          DETALLE_FACTURAS DF,
                          CATALOGO_DE_CONCEPTOS C,
                          --
                          POLIZAS         P,
                          DETALLE_POLIZA  DP,
                          --
                          TIPOS_DE_SEGUROS TS,
                          --
                          PLAN_COBERTURAS PC,
                          POLIZAS_TEXTO_COTIZACION  TXT,
                          CATEGORIAS                CGO
                    WHERE T.CODCIA                   = NCODCIA
                      AND T.CODEMPRESA               = NCODEMPRESA
                      AND TRUNC(T.FECHATRANSACCION) BETWEEN DFECDESDE AND DFECHASTA
                      AND T.IDPROCESO  IN (7, 8, 14, 18, 21)
                      AND DT.IDTRANSACCION           = T.IDTRANSACCION
                      AND DT.CODEMPRESA              = T.CODEMPRESA
                      AND DT.CODCIA                  = T.CODCIA
                      AND DT.OBJETO                  IN ('FACTURAS')
                      AND DT.CODSUBPROCESO           IN ('FAC','REHAB','FACFON','CONFAC')
                      AND F.CODCIA                   = DT.CODCIA
                      AND F.IdPoliza                 = TO_NUMBER(DT.VALOR1)
                      AND F.IDTRANSACCION            = DT.IDTRANSACCION
                      AND F.STSFACT                 != 'PRE'    --PREEMI
                      AND F.IdPoliza                 = TO_NUMBER(DT.VALOR1)
                      --
                      AND EXISTS
                           (SELECT 1
                            FROM   DETALLE_TRANSACCION    DTR
                            WHERE  DTR.IDTRANSACCION     = DT.IDTRANSACCION
                            AND    DTR.CODCIA            = DT.CODCIA
                            AND    DTR.CODEMPRESA        = DT.CODEMPRESA
                            AND  ((DTR.OBJETO IN ('FACTURAS')  AND  T.IDPROCESO  IN (7, 14, 18, 21)  AND DTR.CODSUBPROCESO IN ('FAC','REHAB','FACFON','CONFAC'))
                            OR    (DTR.OBJETO IN ('ENDOSOS')   AND  T.IDPROCESO  IN (8)              AND DTR.CODSUBPROCESO IN ('CFP','AUM', 'EAD', 'INA', 'INC', 'IND', 'REHAP', 'RSS')))
                            )
                      --
                      AND P.CODCIA                   = F.CODCIA
                      AND P.CODEMPRESA               = T.CODEMPRESA
                      AND P.IdPoliza                 = F.IdPoliza
                      --
                      AND DP.CODCIA                  = F.CODCIA
                      AND DP.IdPoliza                = F.IdPoliza
                      AND DP.IDETPOL                 = F.IDETPOL
                      AND DF.IdFactura               = F.IdFactura
                      AND DP.CodCia                  = P.CodCia
                      AND DP.IdPoliza                = P.IdPoliza
                      AND DP.IDetPol                 = F.IDetPol
                      AND PC.CodCia                  = DP.CodCia
                      AND PC.CODEMPRESA              = DP.CODEMPRESA
                      AND PC.PLANCOB                 = DP.PLANCOB
                      AND PC.IDTIPOSEG               = DP.IDTIPOSEG
                      AND TS.CodCia                  = PC.CodCia
                      AND TS.CODEMPRESA              = PC.CODEMPRESA
                      AND TS.IDTIPOSEG               = PC.IDTIPOSEG
                      AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
                      AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
                      AND F.Cod_Moneda              = nvl(cCodMoneda, F.Cod_Moneda)
                      AND F.CodGenerador            = nvl(cCodAgente, F.CodGenerador)
                       --
                      AND TXT.CODCIA(+)              = P.CODCIA
                      AND TXT.IdPoliza(+)            = P.IdPoliza
                      --
                      AND CGO.CODCIA(+)              = P.CODCIA
                      AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
                      AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
                      AND CGO.CODCATEGO(+)           = P.CODCATEGO
                      AND C.CODCIA                   = P.CODCIA
                      AND C.CodConcepto              = DF.CodCpto
                      AND (C.IndCptoPrimas            = 'S'  OR C.INDCPTOFONDO = 'S')
                   GROUP BY P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.IDetPol, P.CodCliente,
                            P.CodCia, P.CODGRUPOEC, DP.CODFILIAL, F.IdEndoso, F.IdFactura,
                            T.FECHATRANSACCION, F.FECVENC, F.Cod_Moneda, DP.IDTIPOSEG, DP.PLANCOB,
                            PC.CODTIPOPLAN, PC.CODTIPOPLAN, P.CodCliente, P.FECINIVIG, P.FECFINVIG,
                            P.NUMRENOV, P.CodCia, F.MtoComisi_Moneda, F.NUMCUOTA, P.CODEMPRESA,
                            T.IDTRANSACCION, F.FOLIOFACTELEC, F.FECFINVIG, F.Cod_Moneda, F.STSFACT,
                            P.PORCENCONTRIBUTORIO, P.PORCENCONTRIBUTORIO, TXT.DESCGIRONEGOCIO,
                            P.CODTIPONEGOCIO, P.FUENTERECURSOSPRIMA, P.CODPAQCOMERCIAL, CGO.DESCCATEGO,
                            P.FORMAVENTA, F.MontoPrimaCompMoneda, F.MontoPrimaCompLocal, P.CodEmpresa,
                            OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg,
                            DP.PlanCob, C.CodConcepto), TS.CODTIPOPLAN, TS.IndMultiramo
                )
                ORDER BY IDFACTURA;

            CURSOR DET_Q IS
               SELECT D.CodCpto,            D.Monto_Det_Moneda,
                      D.IndCptoPrima,       C.IndCptoServicio
                 FROM DETALLE_FACTURAS      D,
                      FACTURAS              F,
                      CATALOGO_DE_CONCEPTOS C
                WHERE C.CodConcepto = D.CodCpto
                  AND C.CodCia      = F.CodCia
                  AND D.IdFactura   = F.IdFactura
                  AND F.IdFactura   = nIdFactura;

            CURSOR DET_Q_MR (nCodRamo Varchar2) IS
                     SELECT D.CodCpto,            D.Monto_Det_Moneda,
                            D.IndCptoPrima,       C.IndCptoServicio,
                            OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(nCodCia, nCodEmpresa, nIdTipoSeg, cPlanCobert, C.CodConcepto) RamoPrimas,
                            C.CodTipoPlan
                 FROM DETALLE_FACTURAS      D,
                      FACTURAS              F,
                      CATALOGO_DE_CONCEPTOS C
                WHERE C.CodConcepto = D.CodCpto
                  AND C.CodCia      = F.CodCia
                  AND D.IdFactura   = F.IdFactura
                  AND F.IdFactura   = nIdFactura
                  and nvl(CodTipoPlan, OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(nCodCia, nCodEmpresa, nIdTipoSeg, cPlanCobert, C.CodConcepto)) = nCodRamo;

            CURSOR DET_ConC (P_IdPoliza Number, p_idFactura Number ) IS
               SELECT DCO.CodConcepto,            DCO.Monto_Mon_Extranjera,
                      AGE.CodTipo,                AGE.CodNivel,
                      COM.Cod_Agente,
                      OC_COMISIONES.MONTO_COMISION (COM.CodCia,COM.idpoliza,AGE.CodNivel,AGE.Cod_Agente,COM.IdFactura,NULL) MtoComision
                     FROM COMISIONES       COM,
                          DETALLE_COMISION DCO,
                          AGENTES          AGE
                  WHERE DCO.CodConcepto IN ('HONORA','COMISI','COMIPF','COMIPM','UDI','IVAHON')
                    AND COM.CodCia     = DCO.CodCia
                    AND COM.IdComision = DCO.IdComision
                    AND AGE.COD_AGENTE = COM.COD_AGENTE
                  AND COM.idpoliza    = P_IdPoliza
                  AND COM.IdFactura   = p_idFactura;



            CURSOR DET_ConC_MR (P_IdPoliza Number, p_idFactura Number ) IS
                SELECT DCO.CodConcepto, DCO.Monto_Mon_Extranjera,
                         AGE.CodTipo, AGE.CodNivel,
                         COM.Cod_Agente,
                         SUM(OC_COMISIONES.MONTO_COMISION (COM.CodCia,COM.idpoliza,AGE.CodNivel,AGE.Cod_Agente,COM.IdFactura,NULL)) MtoComision,
                         C.CodTipoPlan, COM.IdComision
                    FROM COMISIONES COM, DETALLE_COMISION DCO,
                         AGENTES AGE, CATALOGO_DE_CONCEPTOS C
                 WHERE DCO.CodConcepto IN ('HONORA','COMISI', 'COMIPF', 'COMIPM', 'UDI', 'IVAHON', 'IVASIN', 'COMACC', 'COMVDA', 'HONACC', 'HONVDA')
                     AND COM.CodCia       = DCO.CodCia
                     AND COM.IdComision   = DCO.IdComision
                     AND AGE.COD_AGENTE   = COM.COD_AGENTE
                     AND DCO.CodConcepto  = C.CodConcepto
                     AND COM.idpoliza     = P_IdPoliza
                     AND COM.IdFactura    = p_idFactura
                 GROUP BY DCO.CodConcepto, DCO.Monto_Mon_Extranjera,
                         AGE.CodTipo, AGE.CodNivel,
                         COM.Cod_Agente, C.CodTipoPlan, COM.IdComision
                 ORDER BY COM.IdComision;

            CURSOR NC_Q IS
               SELECT P.IdPoliza,                P.NumPolUnico,
                      P.NumPolRef,               DP.IDETPOL,
                      OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
                      N.IdEndoso,                N.IdNcr,
                      TO_CHAR(T.FechaTransaccion,'DD/MM/YYYY') FechaTransaccion,
                      TO_CHAR(N.FecDevol,'DD/MM/YYYY')         FecDevol,
                      N.CodMoneda,               DP.IdTipoSeg,
                      DP.PlanCob,                PC.CodTipoPlan,
                      DP.CodPlanPago,
                      OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
                      P.CodCliente,
                      TO_CHAR(P.FecIniVig,'DD/MM/YYYY') FecIniVig,
                      TO_CHAR(P.FecFinVig,'DD/MM/YYYY') FecFinVig,
                      P.NumRenov,
                      P.CodCia,                  N.MtoComisi_Moneda*-1 MtoComisi_Moneda,
                      1 NumCuota,                P.CodEmpresa,
                      N.FecDevol FecAnul,        T.IdTransaccion,
                      N.StsNcr,                  N.IdTransaccion IdTransacEmi,
                      N.IdTransaccionAnu,        N.FolioFactElec,
                      N.FECFINVIG FECFINVIG_NCR, GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(N.FecDevol ),N.CodMoneda) TIPO_CAMBIO,
                      N.STSNCR ESTATUS,   --PREEMI
                      DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                      NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                      UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                      DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                      DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
                      P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                      CGO.DESCCATEGO                                            CATEGORIA,
                      DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                      --
                      OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(P.CodCia, P.CodEmpresa, PC.IdTipoSeg) CodRamo,
                      OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(P.CodCia, P.CodEmpresa, PC.IdTipoSeg)) DescRamo
                 FROM NOTAS_DE_CREDITO N,
                      TRANSACCION      T,
                      POLIZAS          P,
                      DETALLE_POLIZA   DP,
                      PLAN_COBERTURAS  PC,
                      POLIZAS_TEXTO_COTIZACION  TXT,
                      CATEGORIAS                CGO
                WHERE PC.PlanCob                 = DP.PlanCob
                  AND PC.IdTipoSeg               = DP.IdTipoSeg
                  AND PC.CodEmpresa              = DP.CodEmpresa
                  AND PC.CodCia                  = DP.CodCia
                  AND DP.CodCia                  = N.CodCia
                  AND DP.IDetPol                 = N.IDetPol
                  AND DP.IdPoliza                = N.IdPoliza
                  --
                  AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
                  AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
                  AND N.CodMoneda              = nvl(cCodMoneda, N.CODMONEDA )
                  AND N.COD_AGENTE             = nvl(cCodAgente,  N.COD_AGENTE )
                  --
                  AND P.CodCia                   = N.CodCia
                  AND P.IdPoliza                 = N.IdPoliza
                  AND P.CodEmpresa               = T.CodEmpresa
                  AND T.IdTransaccion            = nvl(N.IdTransaccionAnu, 0)
                  AND T.IdProceso               IN (2, 8)   -- Anulaciones y Endoso
                  AND TRUNC(T.FechaTransaccion) BETWEEN dFecDesde AND dFecHasta
                  --
                  AND TXT.CODCIA(+)              = P.CODCIA
                  AND TXT.CODEMPRESA(+)          = P.CODEMPRESA
                  AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
                  --
                  AND CGO.CODCIA(+)              = P.CODCIA
                  AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
                  AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
                  AND CGO.CODCATEGO(+)           = P.CODCATEGO
                ORDER BY N.IdNcr;

            CURSOR DET_NC_Q IS
               SELECT D.CodCpto,         D.Monto_Det_Moneda,
                      D.IndCptoPrima,    C.IndCptoServicio
                 FROM DETALLE_NOTAS_DE_CREDITO D,
                      NOTAS_DE_CREDITO         N,
                      CATALOGO_DE_CONCEPTOS    C
                WHERE C.CodConcepto = D.CodCpto
                  AND C.CodCia      = N.CodCia
                  AND D.IdNcr       = N.IdNcr
                  AND N.IdNcr       = nIdNcr;

            CURSOR DET_ConC_NCR (nIdPoliza NUMBER, nIdNcr NUMBER) IS
               SELECT DCO.CodConcepto,              DCO.Monto_Mon_Extranjera*-1 Monto_Mon_Extranjera,
                      AGE.CodTipo,                  AGE.CodNivel,
                      COM.Cod_Agente
                 FROM COMISIONES COM,
                      DETALLE_COMISION DCO,
                      AGENTES AGE
                WHERE DCO.CodConcepto IN ('HONORA','COMISI','COMIPF','COMIPM','UDI','IVAHON')
                  AND COM.CodCia     = DCO.CodCia
                  AND COM.IdComision = DCO.IdComision
                  AND AGE.Cod_Agente = COM.Cod_Agente
                  AND COM.IdPoliza   = nIdPoliza
                  AND COM.IdNcr      = nIdNcr;

            ----------------------------

        -------------------------------
    BEGIN
        --
        SELECT SYS_CONTEXT ('USERENV','CURRENT_USERID'),
               SYS_CONTEXT('userenv', 'terminal'),
               USER
          INTO cCodUser,
               W_ID_TERMINAL,
               W_ID_USER
          FROM DUAL;
        ----

          DELETE FROM T_REPORTES_AUTOMATICOS A
           WHERE A.NOMBRE_REPORTE LIKE cCodReporte || '%'
             AND A.FECHA_PROCESO <= TRUNC(ADD_MONTHS(SYSDATE,-8));
          --
          W_ID_ENVIO := OC_CONTROL_PROCESOS_AUTOMATICO.INSERTA_REGISTRO('RECIBOS_EMITIDOS_COB', W_ID_TERMINAL);
          DBMS_OUTPUT.PUT_LINE('ID_ENVIO: '|| w_ID_ENVIO);
          --
          PID_ENVIO := W_ID_ENVIO;
          COMMIT;
          --
          cNomDirectorio := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SO_PATH', 'REPORT');
          ----
          SELECT
             NVL(dFecInicio, TRUNC(sysdate - 1)) first,
             NVL(dFecFinal,  TRUNC(sysdate - 1)) last
            INTO dFecDesde, dFecHasta
            FROM dual ;

          dbms_output.put_line('dPrimerDia '||dFecDesde);
          dbms_output.put_line('dUltimoDia '||dFecHasta);
          --

          BEGIN
             SELECT NomCia
               INTO cNomCia
               FROM EMPRESAS
              WHERE CodCia = nCodCia;
          EXCEPTION WHEN NO_DATA_FOUND THEN
                cNomCia := 'COMPANIA - NO EXISTE!!!';
          END;
          ----
          nLinea := 6;
          --
                  cTitulo1 := cNomCia;
                  cTitulo2 := 'REPORTE DE RECIBOS EMITIDOS DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY');
                  cTitulo4 := ' ';
                  cEncabez     := 'No. de Póliza'||cLimitador||
                                'Consecutivo'||cLimitador||
                                'No. Referencia'||cLimitador||
                                'Sub-Grupo'||cLimitador||
                                'Contratante'||cLimitador||
                                'No. de Endoso'||cLimitador||
                                'Tipo'||cLimitador||
                                'No. Recibo'||cLimitador||
                                'Forma de Pago'||cLimitador||
                                'Fecha Emisión'||cLimitador||
                                'Inicio Vigencia'||cLimitador||
                                'Fin Vigencia'||cLimitador||
                                'Prima Neta'||cLimitador||
                                'Reducción Prima'||cLimitador||
                                'Recargos'||cLimitador||
                                'Derechos'||cLimitador||
                                'Impuesto'||cLimitador||
                                'Prima Total'||cLimitador||
                                'Compensación Sobre Prima'||cLimitador||
                                'Comisión Persona Fisica'||cLimitador||
                                'Comisión Persona Moral'||cLimitador||
                                'Honorarios Persona Fisica'||cLimitador||
                                'Impuesto Honorarios P. Física'||cLimitador||
                                'Honorarios Persona Moral'||cLimitador||
                                'Impuesto Honorarios P. Moral'||cLimitador||
                                'Otras Compensaciones Físicas'||cLimitador||
                                'Impuesto Otras Compensaciones P. Física'||cLimitador||
                                'Otras compensaciones Morales'||cLimitador||
                                'Impuesto Otras Compensaciones P. Moral'||cLimitador||
                                'Dif. en Comisiones'||cLimitador||
                                'Comisión Agente'||cLimitador||
                                'Honorario Agente'||cLimitador||
                                'Agente'||cLimitador||
                                'Tipo Agente'||cLimitador||
                                'Comisión Promotor'||cLimitador||
                                'Honorario Promotor'||cLimitador||
                                'Promotor'||cLimitador||
                                'Tipo Promotor'||cLimitador||
                                'Comisión Dirección Regional'||cLimitador||
                                'Honorario Dirección Regional'||cLimitador||
                                'Dirección Regional'||cLimitador||
                                'Tipo Dirección Regional'||cLimitador||
                                'Tasa IVA'||cLimitador||
                                'Estado'||cLimitador||
                                'Moneda'||cLimitador||
                                'Tipo Cambio'||cLimitador||
                                'Tipo Seguro'||cLimitador||
                                'Plan Coberturas'||cLimitador||
                                'Código SubRamo'||cLimitador||
                                'Descripción SubRamo'||cLimitador||
                                'Tipo Vigencia'||cLimitador||
                                'No. Cuota'||cLimitador||
                                'Inicio Vig. Póliza'||cLimitador ||
                                'Fin Vig. Póliza'||cLimitador ||
                                'No. Renovacion'||cLimitador ||
                                'No. Comprobante'||cLimitador ||
                                'Folio Fact. Electrónica'||cLimitador ||
                                'Folio Fiscal'||cLimitador ||
                                'Serie'||cLimitador ||
                                'UUID'||cLimitador ||
                                'Fecha UUID'||cLimitador ||
                                'Varios UUID'||cLimitador ||
                                'Origen del Recibo'||cLimitador ||
                                'Estatus'||cLimitador ||
                                'Es Contributorio'||cLimitador ||
                                '% Contributorio'||cLimitador ||
                                'Giro de Negocio'||cLimitador ||
                                'Tipo de Negocio'||cLimitador ||
                                'Fuente de Recursos'||cLimitador ||
                                'Paquete Comercial'||cLimitador ||
                                'Categoria'||cLimitador ||
                                'Canal de Venta'                                        ||cLimitador||
                                'Estatus de Póliza'                                ||cLimitador ||
                                'Fecha Pagado Hasta'                                ||cLimitador ||
                                'Fecha Cobertura'                                     ||cLimitador||
                                'Prima de Retiro Moneda'||cLimitador||
                                'Prima de Retiro Local'||cLimitador||
                                'Código Ramo'||cLimitador||
                                'Descripción Ramo';

            --
            dbms_output.put_line(cEncabez);
            --
            IF UPPER(cDestino) != 'REGISTRO' THEN
                INSERTA_ENCABEZADO( 'EXCEL', nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo, cEncabez, cTitulo1, cTitulo2, cTitulo4) ;
            END IF;

            dbms_output.put_line('cNomDirectorio '||cNomDirectorio||' cNomArchivo  '||cNomArchivo );

            FOR X IN EMI_Q LOOP
                nIdFactura      := X.IdFactura;
                cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
                cDescFormaPago  := OC_FACTURAS.FRECUENCIA_PAGO(X.CodCia, X.IdFactura);
                dFecFin         := X.FECFINVIG_FAC;
                cFecFin         := TO_CHAR(dFecFin,'DD/MM/YYYY');

                BEGIN
                 SELECT OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes)
                   INTO cDescEstado
                   FROM CLIENTES C, PERSONA_NATURAL_JURIDICA P
                  WHERE P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
                    AND P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
                    AND C.CodCliente              = X.CodCliente;
                EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    cDescEstado := NULL;
                END;
                IF cDescEstado = 'ESTADO NO EXISTE' THEN
                   cDescEstado := NULL;
                END IF;

                IF X.NumRenov = 0 THEN
                   cTipoVigencia := '1ER. AÑO';
                ELSE
                    cTipoVigencia := 'RENOVACION';
                END IF;

                SELECT STSPOLIZA, FECINIVIG
                  INTO cStatuspol, dFecIniVig
                  FROM POLIZAS
                 WHERE IDPOLIZA = X.IDPOLIZA;


                BEGIN
                    SELECT DIASCANCELACION
                        INTO nDiasGracia
                        FROM TIPOS_DE_SEGUROS
                     WHERE IDTIPOSEG = X.IdTipoSeg;
                EXCEPTION WHEN OTHERS THEN
                    nDiasGracia := 45;
                END;

                BEGIN
                    SELECT MAX(FECFINVIG)
                      INTO dPagadoHasta
                        FROM FACTURAS
                        WHERE IDPOLIZA = X.IdPoliza
                        AND STSFACT = 'PAG';
                EXCEPTION WHEN OTHERS THEN
                    dPagadoHasta := dFecIniVig;
                END;
                ----
                SELECT COUNT(*)
                  INTO nCuantosEmi
                  FROM FACTURAS
                WHERE IDPOLIZA = X.IdPoliza
                    AND STSFACT = 'EMI';

                SELECT COUNT(*)
                  INTO nCuantosPag
                  FROM FACTURAS
                 WHERE IDPOLIZA = X.IdPoliza
                    AND STSFACT = 'PAG';

                IF nCuantosEmi > 0 THEN
                    SELECT MIN(IDFACTURA)
                      INTO nMinFactura
                        FROM FACTURAS
                        WHERE IDPOLIZA = X.IdPoliza
                        AND STSFACT = 'EMI';

                    SELECT FECVENC + nDiasGracia
                      INTO dCubiertoHasta
                      FROM FACTURAS
                     WHERE IDPOLIZA = X.IdPoliza
                       AND IDFACTURA = nMinFactura;
                ELSIF nCuantosPag > 0 THEN
                    SELECT MAX(IDFACTURA)
                    INTO nMinFactura
                      FROM FACTURAS
                     WHERE IDPOLIZA = X.IdPoliza
                       AND STSFACT = 'PAG';

                    SELECT FECFINVIG + nDiasGracia
                      INTO dCubiertoHasta
                      FROM FACTURAS
                     WHERE IDPOLIZA = X.IdPoliza
                       AND IDFACTURA = nMinFactura;
                ELSE
                  SELECT dFecIniVig + nDiasGracia
                        INTO dCubiertoHasta
                        FROM DUAL;
                END IF;
                --
              nPrimaNeta      := 0;
              nReducPrima     := 0;
              nRecargos       := 0;
              nDerechos       := 0;
              nImpuesto       := 0;
              nImpuestoHonoPF := 0;
              nImpuestoHonoPM  := 0;
              nImpuestoHonoPFOC:= 0;
              nImpuestoHonoPMOC:= 0;
              nPrimaTotal     := 0;
              nComisionesPEF  := 0;
              nHonorariosPEF  := 0;
              nUdisPEF        := 0;
              nComisionesPEM  := 0;
              nHonorariosPEM  := 0;
              nUdisPEM        := 0;
              nTotComisDist   := 0;
              nMtoComiAge     := 0;
              nMtoHonoAge     := 0;
              nMtoComiProm    := 0;
              nMtoHonoProm    := 0;
              nMtoComiDR      := 0;
              nMtoHonoDR      := 0;
              --
              cTipoAge        := 0;
              cCodAge         := 0;
              cTipoProm       := 0;
              cCodProm        := 0;
              cTipoDR         := 0;
              cCodDR          := 0;
              nOtrasCompPF    := 0;
              nOtrasCompPM    := 0;
              --
              CFolioFiscal    := NULL;
              cSerie          := NULL;
              cUUID           := NULL;
              cFechaUUID      := NULL;
              cVariosUUID     := NULL;
              --
            IF NVL(X.IndMultiramo,'N') = 'N' THEN
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
            ELSE
              FOR W IN DET_Q_MR(X.CodRamo) LOOP
                 IF (W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S') THEN
                    nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(W.Monto_Det_Moneda,0);
                 ELSIF W.CodCpto IN ('RECVDA','RECACC')  AND W.CodTipoPlan = X.CodRamo THEN
                    nRecargos   := NVL(nRecargos,0) + NVL(W.Monto_Det_Moneda,0);
                 ELSIF W.CodCpto IN ('DEREVI', 'DEREAP') AND W.CodTipoPlan = X.CodRamo THEN
                    nDerechos   := NVL(nDerechos,0) + NVL(W.Monto_Det_Moneda,0);
                 ELSIF W.CodCpto = 'IVASIN' AND X.CodRamo = OC_VALORES_DE_LISTAS.BUSCA_LVALOR('RAMOIVA', W.CodCpto) THEN
                    nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
                    nTasaIVA    := OC_CONCEPTOS_PLAN_DE_PAGOS.PORCENTAJE_CONCEPTO(X.CodCia, X.CodEmpresa, cCodPlanPagos, W.CodCpto);
                 END IF;
                 nPrimaTotal  := NVL(nPrimaNeta,0) + NVL(nRecargos,0) + NVL(nDerechos,0) + NVL(nImpuesto,0);
              END LOOP;
            END IF;

            IF NVL(X.IndMultiramo,'N') = 'N' THEN
              FOR C IN DET_ConC (X.IdPoliza,X.IdFactura) LOOP
                 IF C.CodTipo = 'AGTEPF' THEN --AGENTE PERSONA FISICA
                    IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                       nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'HONORA' THEN
                       nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                 ELSIF C.CodTipo = 'AGTEPM' THEN -- AGENTE PERSONA MORAL
                    IF C.CodConcepto IN ('COMISI','COMIPM') THEN
                       nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'HONORA' THEN
                       nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                 ELSIF C.CodTipo = 'HONPF' THEN -- HONORARIOS PERSONA FISICA
                    IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                       nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'HONORA' THEN
                       nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'IVAHON' THEN
                        nImpuestoHonoPF   := NVL(nImpuestoHonoPF,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                    END IF;
                 ELSIF C.CodTipo = 'HONPM' THEN -- HONORARIOS PERSONA MORAL
                    IF C.CodConcepto IN ('COMISI','COMIPM') THEN
                       nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'HONORA' THEN
                       nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'IVAHON' THEN
                       nImpuestoHonoPM  := NVL(nImpuestoHonoPM,0) + NVL(C.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                    END IF;
                 ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
                    IF C.CodConcepto = 'UDI' THEN
                       nOtrasCompPF    := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                 ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL
                    IF C.CodConcepto = 'UDI' THEN
                       nOtrasCompPM    := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                 ELSIF C.CODTIPO = 'HONORF' THEN -- HONORARIOS PERSONA FISICA
                    IF C.CodConcepto = 'HONORA' THEN
                        nOtrasCompPF  := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'IVAHON' THEN
                        nImpuestoHonoPFOC   := NVL(nImpuestoHonoPFOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                    END IF;
                 ELSIF C.CODTIPO = 'HONORM' THEN -- HONORARIOS PERSONA MORAL
                    IF C.CodConcepto = 'HONORA' THEN
                       nOtrasCompPM  := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'IVAHON' THEN
                       nImpuestoHonoPMOC   := NVL(nImpuestoHonoPMOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                    END IF;
                 END IF;
                 --
                 IF C.CodConcepto != 'IVAHON' THEN
                    nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
                 END IF;
                 --
                 IF C.CodNivel IN (3,4) THEN                                                           --MLJS 27/05/2022 SE AGREGO EL NIVEL 4
                    cTipoAge            := C.CodTipo;
                    cCodAge                := C.Cod_Agente;
                    IF C.CodTipo IN ('HONPM','HONPF','HONORM') AND C.CodConcepto = 'HONORA' THEN      --MLJS 27/05/2022 SE AGREGO EL TIPO HONORM
                       nMtoHonoAge        := NVL(C.Monto_Mon_Extranjera,0);
                    ELSE
                       nMtoComiAge        := NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                 ELSIF C.CodNivel = 2 THEN
                    cTipoProm            := C.CodTipo;
                    cCodProm             := C.Cod_Agente;
                    IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                        nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
                    ELSE
                        nMtoComiProm    := NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                 ELSIF C.CodNivel = 1 THEN
                    cTipoDR                := C.CodTipo;
                    cCodDR                 := C.Cod_Agente;
                    IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                       nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
                    ELSE
                       nMtoComiDR        := NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                 END IF;
              END LOOP;
            ELSE
                    ------------------------------------------------------------------------------------------------------------------------------------------------------
              FOR C IN DET_ConC_MR (X.IdPoliza,X.IdFactura) LOOP
                IF C.CodTipo = 'AGTEPF' THEN --AGENTE PERSONA FISICA
                   IF C.CodConcepto IN ('COMISI','COMIPF','COMACC', 'COMVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                       nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                   END IF;
                ELSIF C.CodTipo = 'AGTEPM' THEN -- AGENTE PERSONA MORAL
                   IF C.CodConcepto IN ('COMISI','COMIPM', 'COMACC', 'COMVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                      nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                   END IF;
                ELSIF C.CodTipo = 'HONPF' THEN -- HONORARIOS PERSONA FISICA
                   IF C.CodConcepto IN ('COMISI','COMIPF', 'HONACC', 'HONVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                      nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                   ELSIF C.CodConcepto IN ('IVAHON') THEN
                       nImpuestoHonoPF   := NVL(nImpuestoHonoPF,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                   END IF;
                ELSIF C.CodTipo = 'HONPM' THEN -- HONORARIOS PERSONA MORAL
                   IF C.CodConcepto IN ('COMISI','COMIPM', 'HONACC', 'HONVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                      nHonorariosPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);   --- CAMBIAR POR VARIABLE CORRECTA
                   ELSIF C.CodConcepto IN ('IVAHON') THEN
                       nImpuestoHonoPM  := NVL(nImpuestoHonoPM,0) + NVL(C.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                   END IF;
                ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
                    IF C.CodConcepto = 'UDI' THEN
                       nOtrasCompPF    := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL
                    IF C.CodConcepto = 'UDI' THEN
                       nOtrasCompPM    := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                ELSIF C.CODTIPO = 'HONORF' THEN -- HONORARIOS PERSONA FISICA
                    IF C.CodConcepto = 'HONORA' THEN
                       nOtrasCompPF  := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'IVAHON' THEN
                       nImpuestoHonoPFOC   := NVL(nImpuestoHonoPFOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                    END IF;
                ELSIF C.CODTIPO = 'HONORM' THEN -- HONORARIOS PERSONA MORAL
                    IF C.CodConcepto = 'HONORA' THEN
                       nOtrasCompPM  := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                    ELSIF C.CodConcepto = 'IVAHON' THEN
                       nImpuestoHonoPMOC   := NVL(nImpuestoHonoPMOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                    END IF;
                END IF;

                IF C.CodConcepto != 'IVASIN' THEN
                    nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
                END IF;
                --
                IF C.CodNivel IN (3,4) THEN                                                              --MLJS 27/05/2022 SE AGREGO EL NIVEL 4
                    cTipoAge            := C.CodTipo;
                    cCodAge                := C.Cod_Agente;
                    IF C.CodTipo IN ('HONPM','HONPF','HONORM') AND C.CodConcepto IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                       nMtoHonoAge        := NVL(C.Monto_Mon_Extranjera,0);                             --MLJS 27/05/2022 SE AGREGO EL TIPO HONORM
                    ELSIF C.CodTipo NOT IN ('HONPM','HONPF','HONORM') AND C.CodConcepto NOT IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                       nMtoComiAge        := NVL(C.Monto_Mon_Extranjera,0);                             --MLJS 27/05/2022 SE AGREGO EL TIPO HONORM
                    END IF;    -- ASI ESTABA SE CAMBIA POR EL DE ABAJO PARA DESGLOSAR MAS LOS CONCEPTOS
                ELSIF C.CodNivel = 2 THEN
                       cTipoProm            := C.CodTipo;
                       cCodProm             := C.Cod_Agente;
                       IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                          nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
                       ELSIF C.CodTipo NOT IN ('HONPM','HONPF') AND C.CodConcepto NOT IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                          nMtoComiProm    := NVL(C.Monto_Mon_Extranjera,0);
                       END IF;
                ELSIF C.CodNivel = 1 THEN
                        cTipoDR                := C.CodTipo;
                        cCodDR                 := C.Cod_Agente;
                        IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                           nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
                        ELSIF C.CodTipo NOT IN ('HONPM','HONPF') AND C.CodConcepto NOT IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                           nMtoComiDR        := NVL(C.Monto_Mon_Extranjera,0);
                        END IF;
                END IF;
              END LOOP;
                    ------------------------------------------------------------------------------------------------------------------------------------------------------
            END IF;

            nPrimaTotalLocal    := OC_DETALLE_FACTURAS.MONTO_PRIMAS(X.IdTransaccion);
            nFactorPrimaRamo    := OC_FACTURAR.FACTOR_PRORRATEO_RAMO(X.CodCia, X.IdPoliza, X.IDetPol, X.CodRamo, nPrimaTotalLocal);
            nDifComis := NVL(X.MtoComisi_Moneda,0) - NVL(nTotComisDist,0);

            SELECT NVL(MIN(NumComprob),'0')
              INTO cNumComprob
              FROM COMPROBANTES_CONTABLES
             WHERE CODCIA         = X.CodCia
                AND NumTransaccion = X.IdTransaccion;



    --RECUPERA FOLIO FISCAL RECIBO FACTURA cuenta de uuids ESA20180620
          BEGIN
             SELECT FE.FOLIOFISCAL, FE.SERIE, FE.UUID, FE.FECHAUUID
               INTO cFolioFiscal, cSerie, cUUID, cFechaUUID
               FROM FACT_ELECT_DETALLE_TIMBRE FE
              WHERE FE.IDFACTURA = X.IDFACTURA
                AND FE.codproceso = 'EMI'
                AND FE.codrespuestasat = '201'
                AND FE.IDTIMBRE IN (SELECT MAX(FE.IDTIMBRE)
                                      FROM FACT_ELECT_DETALLE_TIMBRE FE
                                     WHERE FE.IDFACTURA = X.IDFACTURA
                                       AND FE.codproceso = 'EMI'
                                       AND FE.codrespuestasat = '201');
          EXCEPTION WHEN NO_DATA_FOUND THEN
                cFolioFiscal := NULL;
                cSerie       := NULL;
                cUUID        := NULL;
                cFechaUUID   := NULL;
          END;

          BEGIN
             SELECT COUNT(FE.IDFACTURA)
               INTO cVariosUUID
               FROM FACT_ELECT_DETALLE_TIMBRE FE
              WHERE FE.IDFACTURA = X.IDFACTURA
                AND FE.codproceso = 'EMI'
                AND FE.codrespuestasat = '201'
              GROUP BY FE.IDFACTURA;
             EXCEPTION
             WHEN NO_DATA_FOUND THEN
                cVariosUUID := NULL;
          END;

          cOrigenRecibo := ORIGEN_RECIBO(X.CodCia, X.CodEmpresa, X.IdPoliza, X.IDetPol, X.IdFactura);

              cCadena := X.NumPolUnico                                  ||cLimitador||
                            TO_CHAR(X.IdPoliza,'9999999999999')            ||cLimitador||
                            X.NumPolRef                                    ||cLimitador||
                            X.IDETPOL                                      ||cLimitador||
                            X.Contratante                                  ||cLimitador||
                            TO_CHAR(X.IdEndoso,'9999999999999')            ||cLimitador||
                            'RECIBO'                                       ||cLimitador||
                            TO_CHAR(X.IdFactura,'9999999999990')           ||cLimitador||
                            cDescFormaPago                                 ||cLimitador||
                            X.FechaTransaccion                             ||cLimitador||
                            X.FecVenc                                      ||cLimitador||
                            cFecFin                                        ||cLimitador||
                            TO_CHAR(nPrimaNeta,'99999999999990.00')        ||cLimitador||
                            TO_CHAR(nReducPrima,'99999999999990.00')       ||cLimitador||
                            TO_CHAR(nRecargos,'99999999999990.00')         ||cLimitador||
                            TO_CHAR(nDerechos,'99999999999990.00')         ||cLimitador||
                            TO_CHAR(nImpuesto,'99999999999990.00')         ||cLimitador||
                            TO_CHAR(nPrimaTotal,'99999999999990.00')       ||cLimitador||
                            TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00')||cLimitador||
                            TO_CHAR(nComisionesPEF,'99999999999990.00')    ||cLimitador||
                            TO_CHAR(nComisionesPEM,'99999999999990.00')    ||cLimitador||
                            TO_CHAR(nHonorariosPEF,'99999999999990.00')    ||cLimitador||
                            TO_CHAR(nImpuestoHonoPF,'99999999999990.00')   ||cLimitador||
                            TO_CHAR(nHonorariosPEM,'99999999999990.00')    ||cLimitador||
                            TO_CHAR(nImpuestoHonoPM,'99999999999990.00')   ||cLimitador||
                            TO_CHAR(nOtrasCompPF,'99999999999990.00')      ||cLimitador||
                            TO_CHAR(nImpuestoHonoPFOC,'99999999999990.00') ||cLimitador||
                            TO_CHAR(nOtrasCompPM,'99999999999990.00')      ||cLimitador||
                            TO_CHAR(nImpuestoHonoPMOC,'99999999999990.00') ||cLimitador||
                            TO_CHAR(nDifComis,'99999999999990.00')         ||cLimitador||
                            TO_CHAR(nMtoComiAge,'99999999999990.00')       ||cLimitador||
                            TO_CHAR(nMtoHonoAge,'99999999999990.00')       ||cLimitador||
                            LPAD(cCodAge,6,'0')                            ||cLimitador||
                            cTipoAge                                       ||cLimitador||
                            TO_CHAR(nMtoComiProm,'99999999999990.00')      ||cLimitador||
                            TO_CHAR(nMtoHonoProm,'99999999999990.00')      ||cLimitador||
                            LPAD(cCodProm,6,'0')                           ||cLimitador||
                            cTipoProm                                      ||cLimitador||
                            TO_CHAR(nMtoComiDR,'99999999999990.00')        ||cLimitador||
                            TO_CHAR(nMtoHonoDR,'99999999999990.00')        ||cLimitador||
                            LPAD(cCodDR,6,'0')                             ||cLimitador||
                            cTipoDR                                        ||cLimitador||
                            TO_CHAR(nTasaIVA,'999990.00')                  ||cLimitador||
                            cDescEstado                                    ||cLimitador||
                            X.Cod_Moneda                                   ||cLimitador||
                            TO_CHAR(X.TIPO_CAMBIO,'99999999999990.00')     ||cLimitador||
                            X.IdTipoSeg                                    ||cLimitador||
                            X.PlanCob                                      ||cLimitador||
                            X.CodTipoPlan                                  ||cLimitador||
                            X.DescSubRamo                                  ||cLimitador||
                            cTipoVigencia                                  ||cLimitador||
                            TO_CHAR(X.NumCuota,'99990')                    ||cLimitador||
                            X.FecIniVig                                    ||cLimitador||
                            X.FecFinVig                                    ||cLimitador||
                            TO_CHAR(X.NumRenov,'99990')                    ||cLimitador||
                            cNumComprob                                    ||cLimitador||
                            X.FolioFactElec                                ||cLimitador||
                            cFolioFiscal                                   ||cLimitador||
                            cSerie                                         ||cLimitador||
                            cUUID                                          ||cLimitador||
                            TO_CHAR(cFechaUUID,'DD/MM/YYYY')               ||cLimitador||
                            cVariosUUID                                    ||cLimitador||
                            cOrigenRecibo                                  ||cLimitador||
                            X.ESTATUS                                      ||cLimitador||
                            X.ESCONTRIBUTORIO                              ||cLimitador||
                            X.PORCENCONTRIBUTORIO                          ||cLimitador||
                            X.GIRONEGOCIO                                  ||cLimitador||
                            X.TIPONEGOCIO                                  ||cLimitador||
                            X.FUENTERECURSOS                               ||cLimitador||
                            X.CODPAQCOMERCIAL                              ||cLimitador||
                            X.CATEGORIA                                    ||cLimitador||
                            X.CANALFORMAVENTA                              ||cLimitador||
                            cStatuspol                                     ||cLimitador||
                            TO_CHAR(dPagadoHasta,'DD/MM/YYYY')             ||cLimitador||
                            TO_CHAR(dCubiertoHasta,'DD/MM/YYYY')           ||cLimitador||
                            TO_CHAR(NVL(X.MontoPrimaRetiroMon,0),'99999999999990.00')        ||cLimitador||
                            TO_CHAR(NVL(X.MontoPrimaRetiroLoc,0),'99999999999990.00')        ||cLimitador||
                            X.CodRamo        ||cLimitador||
                            X.DescRamo       ||
                            CHR(13);
                --
                IF UPPER(cDestino) != 'REGISTRO' THEN
                    nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena, 1);
                ELSE
                    INSERTA_REGISTROS(cCodReporte, nLineaimp, 'REPAUTRECEMI', cNomArchivo, cCadena, W_ID_ENVIO);
                END IF;
                --
           END LOOP;

           FOR X IN NC_Q LOOP
              nIdNcr          := X.IdNcr;
              --
              cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
              cDescFormaPago  := 'DIRECTO';
              dFecFin         := X.FECFINVIG_NCR;
              cFecFin         := TO_CHAR(dFecFin,'DD/MM/YYYY');

              BEGIN
                 SELECT OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes)
                   INTO cDescEstado
                   FROM CLIENTES C, PERSONA_NATURAL_JURIDICA P
                  WHERE P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
                    AND P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
                    AND C.CodCliente              = X.CodCliente;
              EXCEPTION WHEN NO_DATA_FOUND THEN
                    cDescEstado := NULL;
              END;


              IF cDescEstado = 'ESTADO NO EXISTE' THEN
                   cDescEstado := NULL;
              END IF;

              IF X.NumRenov = 0 THEN
                 cTipoVigencia := '1ER. AÑO';
              ELSE
                 cTipoVigencia := 'RENOVACION';
              END IF;

              nPrimaNeta      := 0;
              nReducPrima     := 0;
              nRecargos       := 0;
              nDerechos       := 0;
              nImpuesto       := 0;
              nPrimaTotal     := 0;
              nComisionesPEF  := 0;
              nHonorariosPEF  := 0;
              nUdisPEF        := 0;
              nComisionesPEM  := 0;
              nHonorariosPEM  := 0;
              nUdisPEM        := 0;
              nTotComisDist   := 0;
              nMtoComiAge     := 0;
              nMtoHonoAge     := 0;
              nMtoComiProm    := 0;
              nMtoHonoProm    := 0;
              nMtoComiDR      := 0;
              nMtoHonoDR      := 0;
              nImpuestoHonoPF := 0;
              nImpuestoHonoPM := 0;
              nImpuestoHonoPFOC := 0;
              nImpuestoHonoPMOC := 0;
              --
              cTipoAge        := 0;
              cCodAge         := 0;
              cTipoProm       := 0;
              cCodProm        := 0;
              cTipoDR         := 0;
              cCodDR          := 0;
              nOtrasCompPF    := 0;
              nOtrasCompPM    := 0;
              --
              CFolioFiscal    := null;
              cSerie          := null;
              cUUID           := null;
              cFechaUUID      := null;
              cVariosUUID     := null;
          --
        FOR W IN DET_NC_Q LOOP
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

        FOR C IN DET_ConC_NCR (X.IdPoliza, X.IdNcr) LOOP
            IF C.CODTIPO = 'AGTEPF' THEN --AGENTE PERSONA FISICA
                IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                    nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSIF C.CodConcepto = 'HONORA' THEN
                       nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                END IF;
            ELSIF C.CODTIPO = 'AGTEPM' THEN -- AGENTE PERSONA MORAL
                IF C.CodConcepto IN ('COMISI','COMIPM') THEN
                   nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSIF C.CodConcepto = 'HONORA' THEN
                   nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                END IF;
            ELSIF C.CODTIPO = 'HONPF' THEN -- HONORARIOS PERSONA FISICA
                IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                   nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSIF C.CodConcepto = 'HONORA' THEN
                   nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSIF C.CodConcepto = 'IVAHON' THEN  ---- jmmd20190530 nImpuestoHono nuevo concepto para proyecto de honorarios
                   nImpuestoHonoPF   := NVL(nImpuestoHonoPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                END IF;
            ELSIF C.CODTIPO = 'HONPM' THEN -- HONORARIOS PERSONA MORAL
                IF C.CodConcepto IN ('COMISI','COMIPM') THEN
                   nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSIF C.CodConcepto = 'HONORA' THEN
                   nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSIF C.CodConcepto = 'IVAHON' THEN  ---- jmmd20190530 nImpuestoHono nuevo concepto para proyecto de honorarios
                   nImpuestoHonoPM   := NVL(nImpuestoHonoPM,0) + NVL(C.Monto_Mon_extranjera,0);
                END IF;
            ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
                IF C.CodConcepto = 'UDI' THEN
                   nOtrasCompPF      := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                END IF;
            ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL
                IF C.CodConcepto = 'UDI' THEN
                   nOtrasCompPM    := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                END IF;
            ELSIF C.CODTIPO = 'HONORF' THEN -- HONORARIOS PERSONA FISICA
                IF C.CodConcepto = 'HONORA' THEN
                   nOtrasCompPF  := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSIF C.CodConcepto = 'IVAHON' THEN
                    nImpuestoHonoPFOC   := NVL(nImpuestoHonoPFOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                END IF;
            ELSIF C.CODTIPO = 'HONORM' THEN -- HONORARIOS PERSONA MORAL
                IF C.CodConcepto = 'HONORA' THEN
                   nOtrasCompPM  := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                ELSIF C.CodConcepto = 'IVAHON' THEN
                    nImpuestoHonoPMOC   := NVL(nImpuestoHonoPMOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                END IF;
            END IF;

            IF C.CodConcepto != 'IVAHON' THEN
                 nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
            END IF;
             --
            IF C.CodNivel IN (3,4) THEN                                                             --MLJS 27/05/2022 SE AGREGO EL NIVEL 4
               cTipoAge            := C.CodTipo;
               cCodAge                := C.Cod_Agente;
               IF C.CodTipo IN ('HONPM','HONPF','HONORM') AND C.CodConcepto = 'HONORA' THEN         --MLJS 27/05/2022 SE AGREGO EL TIPO HONORM
                  nMtoHonoAge        := NVL(C.Monto_Mon_Extranjera,0);
               ELSE
                  nMtoComiAge        := NVL(C.Monto_Mon_Extranjera,0);
               END IF;
            ELSIF C.CodNivel = 2 THEN
                cTipoProm            := C.CodTipo;
                cCodProm             := C.Cod_Agente;
                IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                    nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
                ELSE
                    nMtoComiProm    := NVL(C.Monto_Mon_Extranjera,0);
                END IF;
            ELSIF C.CodNivel = 1 THEN
                cTipoDR                := C.CodTipo;
                cCodDR                 := C.Cod_Agente;
                IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                   nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
                ELSE
                   nMtoComiDR        := NVL(C.Monto_Mon_Extranjera,0);
                END IF;
            END IF;
        END LOOP;

        nDifComis := NVL(X.MtoComisi_Moneda,0) - NVL(nTotComisDist,0);

        SELECT NVL(MIN(NumComprob),'0')
          INTO cNumComprob
          FROM COMPROBANTES_CONTABLES
         WHERE CODCIA         = X.CodCia
           AND NumTransaccion = X.IdTransaccion;


    --RECUPERA FOLIO FISCAL, serie, fecha uuid anulado, cuenta de uuids NCR ESA20180620
        BEGIN
         SELECT FE.FOLIOFISCAL, FE.SERIE, FE.UUIDCANCELADO, FE.FECHAUUID
           INTO cFolioFiscal, cSerie, cUUID, cFechaUUID
           FROM FACT_ELECT_DETALLE_TIMBRE FE
          WHERE FE.IDNCR = X.IDNCR
            AND FE.codproceso= 'CAN'
            AND FE.codrespuestasat = '201'
            AND FE.IDTIMBRE IN (SELECT MAX(FE.IDTIMBRE)
                                  FROM FACT_ELECT_DETALLE_TIMBRE FE
                                 WHERE FE.IDNCR = X.IDNCR
                                   AND FE.codproceso = 'CAN'
                                   AND FE.codrespuestasat = '201');
        EXCEPTION WHEN NO_DATA_FOUND THEN
            cFolioFiscal := NULL;
            cSerie       := NULL;
            cUUID        := NULL;
            cFechaUUID   := NULL;
        END;

        BEGIN
             SELECT COUNT(FE.IDNCR)
               INTO cVariosUUID
               FROM FACT_ELECT_DETALLE_TIMBRE FE
              WHERE FE.IDNCR = X.IDNCR
                AND FE.codproceso = 'CAN'
                AND FE.codrespuestasat = '201'
              GROUP BY FE.IDNCR;
        EXCEPTION WHEN NO_DATA_FOUND THEN
             cVariosUUID := NULL;
        END;

        cOrigenRecibo := 'PRIMAS';

              cCadena := X.NumPolUnico                                  ||cLimitador||
                                TO_CHAR(X.IdPoliza,'9999999999999')            ||cLimitador||
                                X.NumPolRef                                    ||cLimitador||
                                X.IDETPOL                                      ||cLimitador||
                                X.Contratante                                  ||cLimitador||
                                TO_CHAR(X.IdEndoso,'9999999999999')            ||cLimitador||
                                'NCR'                                          ||cLimitador||
                                TO_CHAR(X.IdNcr,'9999999999990')               ||cLimitador||
                                cDescFormaPago                                 ||cLimitador||
                                X.FechaTransaccion                             ||cLimitador||
                                X.FecDevol                                     ||cLimitador||
                                cFecFin                                        ||cLimitador||
                                TO_CHAR(nPrimaNeta,'99999999999990.00')        ||cLimitador||
                                TO_CHAR(nReducPrima,'99999999999990.00')       ||cLimitador||
                                TO_CHAR(nRecargos,'99999999999990.00')         ||cLimitador||
                                TO_CHAR(nDerechos,'99999999999990.00')         ||cLimitador||
                                TO_CHAR(nImpuesto,'99999999999990.00')         ||cLimitador||
                                TO_CHAR(nPrimaTotal,'99999999999990.00')       ||cLimitador||
                                TO_CHAR(X.MtoComisi_Moneda,'99999999999990.00')||cLimitador||
                                TO_CHAR(nComisionesPEF,'99999999999990.00')    ||cLimitador||
                                TO_CHAR(nComisionesPEM,'99999999999990.00')    ||cLimitador||
                                TO_CHAR(nHonorariosPEF,'99999999999990.00')    ||cLimitador||
                                TO_CHAR(nImpuestoHonoPF,'99999999999990.00')   ||cLimitador||
                                TO_CHAR(nHonorariosPEM,'99999999999990.00')    ||cLimitador||
                                TO_CHAR(nImpuestoHonoPM,'99999999999990.00')   ||cLimitador||
                                TO_CHAR(nOtrasCompPF,'99999999999990.00')      ||cLimitador||
                                TO_CHAR(nImpuestoHonoPFOC,'99999999999990.00') ||cLimitador||
                                TO_CHAR(nOtrasCompPM,'99999999999990.00')      ||cLimitador||
                                TO_CHAR(nImpuestoHonoPMOC,'99999999999990.00') ||cLimitador||
                                TO_CHAR(nDifComis,'99999999999990.00')         ||cLimitador||
                                TO_CHAR(nMtoComiAge,'99999999999990.00')       ||cLimitador||
                                TO_CHAR(nMtoHonoAge,'99999999999990.00')       ||cLimitador||
                                LPAD(cCodAge,6,'0')                            ||cLimitador||
                                cTipoAge                                       ||cLimitador||
                                TO_CHAR(nMtoComiProm,'99999999999990.00')      ||cLimitador||
                                TO_CHAR(nMtoHonoProm,'99999999999990.00')      ||cLimitador||
                                LPAD(cCodProm,6,'0')                           ||cLimitador||
                                cTipoProm                                      ||cLimitador||
                                TO_CHAR(nMtoComiDR,'99999999999990.00')        ||cLimitador||
                                TO_CHAR(nMtoHonoDR,'99999999999990.00')        ||cLimitador||
                                LPAD(cCodDR,6,'0')                             ||cLimitador||
                                cTipoDR                                        ||cLimitador||
                                TO_CHAR(nTasaIVA,'999990.00')                  ||cLimitador||
                                cDescEstado                                    ||cLimitador||
                                X.CodMoneda                                    ||cLimitador||
                                TO_CHAR(X.TIPO_CAMBIO,'99999999999990.00')     ||cLimitador||
                                X.IdTipoSeg                                    ||cLimitador||
                                X.PlanCob                                      ||cLimitador||
                                X.CodTipoPlan                                  ||cLimitador||
                                X.DescSubRamo                                  ||cLimitador||
                                cTipoVigencia                                  ||cLimitador||
                                TO_CHAR(X.NumCuota,'99990')                    ||cLimitador||
                                X.FecIniVig                                    ||cLimitador||
                                X.FecFinVig                                    ||cLimitador||
                                TO_CHAR(X.NumRenov,'99990')                    ||cLimitador||
                                cNumComprob                                    ||cLimitador||
                                X.FolioFactElec                                ||cLimitador||
                                cFolioFiscal                                   ||cLimitador||
                                cSerie                                         ||cLimitador||
                                cUUID                                          ||cLimitador||
                                TO_CHAR(cFechaUUID,'DD/MM/YYYY')               ||cLimitador||
                                cVariosUUID                                    ||cLimitador||
                                cOrigenRecibo                                  ||cLimitador||
                                X.ESTATUS                                      ||cLimitador||
                                X.ESCONTRIBUTORIO                              ||cLimitador||
                                X.PORCENCONTRIBUTORIO                          ||cLimitador||
                                X.GIRONEGOCIO                                  ||cLimitador||
                                X.TIPONEGOCIO                                  ||cLimitador||
                                X.FUENTERECURSOS                               ||cLimitador||
                                X.CODPAQCOMERCIAL                              ||cLimitador||
                                X.CATEGORIA                                    ||cLimitador||
                                X.CANALFORMAVENTA                              ||cLimitador||
                                cStatuspol                                 ||cLimitador||
                                TO_CHAR(dPagadoHasta,'DD/MM/YYYY')         ||cLimitador||
                            TO_CHAR(dCubiertoHasta,'DD/MM/YYYY')           ||cLimitador||
                            TO_CHAR(0,'99999999999990.00')                 ||cLimitador||
                            TO_CHAR(0,'99999999999990.00')                 ||cLimitador||
                            X.CodRamo                                      ||cLimitador||
                            X.DescRamo                                     ||
                            CHR(13);
                 ----
                IF UPPER(cDestino) != 'REGISTRO' THEN
                    nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena, 1);
                ELSE
                    INSERTA_REGISTROS(cCodReporte, nLineaimp, 'REPAUTRECEMI', cNomArchivo, cCadena, W_ID_ENVIO);
                END IF;
                --
        END LOOP;
            --
        cNomArchZip := SUBSTR(cNomArchivo, 1, INSTR(cNomArchivo, '.')-1) || '.zip';
            --
        IF UPPER(cDestino) != 'REGISTRO' THEN
            IF XLSX_BUILDER_PKG.EXCEL_GUARDA_LIBRO THEN
               IF ZIP_UTIL_PKG.ZIP_ARCHIVOS(cNomDirectorio, cNomArchZip, cNomArchivo) THEN
                  dbms_output.put_line('OK');
               END IF;
               OC_REPORTES_THONA.COPIA_ARCHIVO_BLOB( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomArchZip, W_ID_ENVIO, 'N' );
            END IF;

            IF UPPER(cDestino) = 'CORREO' THEN
              ENVIA_MAIL('Recibos emitidos',cNomDirectorio, cNomArchZip, W_ID_ENVIO, cBuzones) ;
            END IF;
        ELSE
              ENVIA_MAIL('Recibos emitidos',NULL, NULL, W_ID_ENVIO, cBuzones);
        END IF;

    END RECIBOS_EMITIDOS_COB;
    --
    PROCEDURE RECIBOS_PAGADOS_COB (nCodCia     NUMBER,
                                  nCodEmpresa NUMBER,
                                  cIdTipoSeg VARCHAR2,
                                  cPlanCob   VARCHAR2,
                                  cCodMoneda VARCHAR2,
                                  cCodAgente VARCHAR2,
                                  dFecInicio  DATE        default trunc(sysdate),
                                  dFecFinal   DATE        default trunc(sysdate),
                                  cDestino    VARCHAR2    default 'CORREO',  --  'ARCHIVO', 'CORREO', 'REGISTRO' -- GENERERA EL ARCHIVO PARA DESCARGAR, CORREO, SE ENVIA SEGUN EL USUARIO CONECTADO Y REGISTRO ES PARA DESCARGAR EN TXT
                                  cBuzones      VARCHAR2,
                                  PID_ENVIO  OUT  NUMBER
                                                      ) IS

            /* PROCEDIMIENTO QUE GENERA DOS SALIDAS, UNO A UNA TABLA Y OTRO GENERA ARCHIVO DE EXCEL*/
            cLimitador      VARCHAR2(1) :='|';
            nLinea          NUMBER;
            nLineaimp       NUMBER := 1;
            cCadena         VARCHAR2(4000);
            cCadenaAux      VARCHAR2(4000);
            cCadenaAux1     VARCHAR2(4000);
            cCodUser        VARCHAR2(30);
            nDummy          NUMBER;
            cCopy           BOOLEAN;
            W_ID_TERMINAL   VARCHAR2(100);
            W_ID_USER       VARCHAR2(100);
            W_ID_ENVIO      VARCHAR2(100);
            cDescFormaPago  VARCHAR2(100);
            dFecFin         DATE;
            cFecFin         VARCHAR2(10);
            cTipoVigencia   VARCHAR2(20);
            cTipoTran       VARCHAR2(4);
            nIdFactura      FACTURAS.IdFactura%TYPE;
            nPrimaNeta      DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nReducPrima     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nRecargos       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nDerechos       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nImpuesto       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nImpuestoHonoPF DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nImpuestoHonoPM DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nImpuestoHonoPFOC DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nImpuestoHonoPMOC DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nPrimaTotal     DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nComisionesPEF  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nHonorariosPEF  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nUdisPEF        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nComisionesPEM  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nHonorariosPEM  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nUdisPEM        DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nTotComisDist   DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nDifComis       DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            cCodPlanPagos   PLAN_DE_PAGOS.CodPlanPago%TYPE;
            cCodGenerador   AGENTE_POLIZA.Cod_Agente%TYPE;
            nTasaIVA        CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
            cDescEstado     PROVINCIA.DescEstado%TYPE;
            nFrecPagos      PLAN_DE_PAGOS.FrecPagos%TYPE;
            nCodTipo        AGENTES.CODTIPO%TYPE;
            cNumComprob     COMPROBANTES_CONTABLES.NumComprob%TYPE;
            cTipoEndoso     ENDOSOS.TipoEndoso%TYPE;
            dFecFinVig      ENDOSOS.FecFinVig%TYPE;
            nIdNcr          NOTAS_DE_CREDITO.IdNcr%TYPE;
            ---
            nMtoHonoAge     NUMBER(28,2);
            nMtoComiAge     NUMBER(28,2);
            cTipoAge        AGENTES.CodTipo%TYPE;
            cCodAge         AGENTES.Cod_Agente%TYPE;

            nMtoComiProm    NUMBER(28,2);
            nMtoHonoProm    NUMBER(28,2);
            cTipoProm       AGENTES.CodTipo%TYPE;
            cCodProm        AGENTES.Cod_Agente%TYPE;

            nMtoComiDR      NUMBER(28,2);
            nMtoHonoDR      NUMBER(28,2);
            cTipoDR         AGENTES.CodTipo%TYPE;
            cCodDR          AGENTES.Cod_Agente%TYPE;
            CFolioFiscal    FACT_ELECT_DETALLE_TIMBRE.FolioFiscal%TYPE;
            cSerie          FACT_ELECT_DETALLE_TIMBRE.Serie%TYPE;
            cUUID           FACT_ELECT_DETALLE_TIMBRE.UUID%TYPE;
            cFechaUUID      DATE;
            cVariosUUID     NUMBER;
            cOrigenRecibo   VARCHAR2(200);
            nOtrasCompPF    DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nOtrasCompPM    DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            ----

            cNomDirectorio  VARCHAR2(100) ;
            cNomArchivo VARCHAR2(100) := 'REC_PAG_'||to_char(trunc(sysdate - 1),'ddmmyyyy')||'.XLSX';
            cNomArchZip           VARCHAR2(100);
            cCodReporte           VARCHAR2(100) := 'RECIBOSPAGADOS';
            cNomCia               VARCHAR2(100);
            cTitulo1              VARCHAR2(200);
            cTitulo2              VARCHAR2(200);
            cTitulo4              VARCHAR2(200);
            cEncabez              VARCHAR2(5000);
            dFecDesde DATE;
            dFecHasta DATE;

            cPwdEmail                   VARCHAR2(100);
            cMiMail                     USUARIOS.EMAIL%TYPE := 'notificaciones@thonaseguros.mx';
            cSaltoLinea                 VARCHAR2(5)      := '<br>';
            cHTMLHeader                 VARCHAR2(2000)   := '<html>'                                                                     ||cSaltoLinea||
                                                         '<head>'                                                                     ||cSaltoLinea||
                                                         '<meta http-equiv="Content-Language" content="en/us"/>'                      ||cSaltoLinea||
                                                         '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>'  ||cSaltoLinea||
                                                         '</head><body>'                                                              ||cSaltoLinea;
             cHTMLFooter                VARCHAR2(100)    := '</body></html>';
             cError                      VARCHAR2(1000);
            cTextoEnv                   ENDOSO_TXT_DET.TEXTO%TYPE;
            cSubject                    VARCHAR2(1000) := 'Notificacion de recepcion del archivo de "Recibos Pagados"';
            cTexto1                     VARCHAR2(10000):= 'A quien corresponda:';
            cTexto2                     varchar2(1000)   := ' Envio del archivo de "Recibos pagados" generado en automatico de la operacion del dia anterior';
            cTexto3                     varchar2(10)   := '  ';
            cTexto4                     varchar2(1000)   := ' Saludos. ';
            ----
            nIdTipoSeg                  DETALLE_POLIZA.IdTipoSeg%TYPE;
            cPlanCobert                 PLAN_COBERTURAS.PlanCob%TYPE;
            nCompensacionMR             DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
            nFactorPrimaRamo        NUMBER;
            nPrimaTotalLocal        NUMBER;
            --
            cStsNcr         NOTAS_DE_CREDITO.StsNcr%TYPE;
            W_FACTORDEVOL   NUMBER;
            W_TIPOCOMPROB   COMPROBANTES_CONTABLES.TIPOCOMPROB%TYPE;
            W_MtoComisi_Moneda   NOTAS_DE_CREDITO.MtoComisi_Moneda%TYPE;
            --
        CURSOR PAG_Q IS
            SELECT
                  P.IdPoliza,                     P.NumPolUnico,
                  P.NumPolRef,                    DP.IDETPOL,
                  OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente)|| ' ' ||
                  OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
                  F.IdEndoso,                     F.IdFactura IdRecibo,
                  TO_CHAR(T.FechaTransaccion,'DD/MM/YYYY') FechaTransaccion,
                  TO_CHAR(F.FecVenc,'DD/MM/YYYY') FecVenc,
                  F.Cod_Moneda,                   DP.IdTipoSeg,
                  DP.PlanCob,                     PC.CodTipoPlan,
                  OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
                  P.CodCliente,
                  TO_CHAR(P.FecIniVig,'DD/MM/YYYY') FecIniVig,
                  TO_CHAR(P.FecFinVig,'DD/MM/YYYY') FecFinVig,
                  P.NumRenov,
                  P.CodCia,                       F.MtoComisi_Moneda,
                  F.NumCuota,                     P.CodEmpresa,
                  TO_CHAR(TRUNC(PG.Fecha),'DD/MM/YYYY')  FecPago,
                  T.IdTransaccion,
                  'PAGO' TipoTran,                F.FolioFactElec,
                  F.FECFINVIG FECFINVIG_FAC,      GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(PG.Fecha),F.Cod_Moneda) TIPO_CAMBIO,
                 --
                  DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                  NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                  UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
                  P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                  CGO.DESCCATEGO                                            CATEGORIA,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                  --
                  F.MontoPrimaCompMoneda                                                                        MONTOPRIMARETIROMON,    --> JALV (+) 09/11/2021
                  F.MontoPrimaCompLocal                                                                            MONTOPRIMARETIROLOC,        --> JALV (+) 09/11/2021
                  CASE TS.CODTIPOPLAN
                    WHEN '099' THEN
                       OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto)
                    ELSE
                       TS.CODTIPOPLAN
                  END CodRamo,
                  CASE TS.CODTIPOPLAN
                    WHEN '099' THEN
                       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto))
                    ELSE
                       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',TS.CODTIPOPLAN)
                  END DescRamo,
                  TS.IndMultiramo
             FROM TRANSACCION          T,
                  DETALLE_TRANSACCION DT,
                  FACTURAS        F,
                  --
                  DETALLE_FACTURAS DF,
                  CATALOGO_DE_CONCEPTOS C,
                  --
                  PAGOS           PG,
                  POLIZAS         P,
                  DETALLE_POLIZA  DP,
                  --
                  TIPOS_DE_SEGUROS TS,
                  --
                  PLAN_COBERTURAS PC,
                  POLIZAS_TEXTO_COTIZACION  TXT,
                  CATEGORIAS                CGO
            WHERE T.CODCIA                   = DT.CODCIA
              AND T.CODEMPRESA               = DT.CODEMPRESA
              AND TRUNC(T.FECHATRANSACCION) BETWEEN DFECDESDE AND DFECHASTA
              AND T.IdProceso                IN (12,21)
              AND DT.IDTRANSACCION           = T.IDTRANSACCION
              AND DT.CODEMPRESA              = T.CODEMPRESA
              AND DT.CODCIA                  = T.CODCIA
              AND DT.OBJETO                  = 'FACTURAS'
              AND DT.CODSUBPROCESO          IN ('PAG','PAGPRD')
              AND TO_NUMBER(DT.VALOR1)       = F.IDPOLIZA
              --
              AND F.IDPOLIZA                 = TO_NUMBER(DT.VALOR1)
              AND F.IDFACTURA                = TO_NUMBER(DT.VALOR4)
              AND PC.PlanCob                 = DP.PlanCob
              AND PC.IdTipoSeg               = DP.IdTipoSeg
              AND PC.CodEmpresa              = DP.CodEmpresa
              AND PC.CodCia                  = DP.CodCia
              AND DP.CodCia                  = F.CodCia
              AND DP.IDetPol                 = F.IDetPol
              AND DP.IdPoliza                = F.IdPoliza
              AND F.IdFactura                = DF.IdFactura
              AND DP.IDTIPOSEG               = TS.IDTIPOSEG
              AND DP.CODEMPRESA              = TS.CODEMPRESA
              AND DP.CodCia                  = TS.CodCia
              AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
              AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
              AND F.Cod_Moneda              = nvl(cCodMoneda, F.Cod_Moneda)
              AND F.CodGenerador            = nvl(cCodAgente, F.CodGenerador)
              AND P.CodCia                   = F.CodCia
              AND P.IdPoliza                 = F.IdPoliza
              AND P.CodEmpresa               = T.CodEmpresa
              AND TRUNC(PG.FECHA)            = TRUNC(T.FECHATRANSACCION)
              AND PG.IdFactura               = F.IdFactura
              --
              AND TXT.CODCIA(+)              = P.CODCIA
              AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
              --
              AND CGO.CODCIA(+)              = P.CODCIA
              AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
              AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
              AND CGO.CODCATEGO(+)           = P.CODCATEGO
                AND C.CODCIA                   = P.CODCIA
                AND C.CodConcepto              = DF.CodCpto
                AND (C.IndCptoPrimas            = 'S'  OR C.INDCPTOFONDO = 'S')
              GROUP BY P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.IDetPol,
                        P.CODGRUPOEC, DP.CODFILIAL, F.IdEndoso, F.IdFactura,
                        T.FECHATRANSACCION, F.FECVENC, DP.IDTIPOSEG, DP.PLANCOB,
                        PC.CODTIPOPLAN, P.CodCliente, P.FECINIVIG, P.FECFINVIG,
                        P.NUMRENOV, P.CodCia, F.MtoComisi_Moneda, F.NUMCUOTA, PG.Fecha,
                        T.IDTRANSACCION, F.FOLIOFACTELEC, F.FECFINVIG, F.Cod_Moneda,
                        P.PORCENCONTRIBUTORIO, TXT.DESCGIRONEGOCIO, F.STSFACT,
                        P.CODTIPONEGOCIO, P.FUENTERECURSOSPRIMA, P.CODPAQCOMERCIAL, CGO.DESCCATEGO,
                        P.FORMAVENTA, F.MontoPrimaCompMoneda, F.MontoPrimaCompLocal, P.CodEmpresa,
                        OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg,
                        DP.PlanCob, C.CodConcepto), TS.CODTIPOPLAN, TS.IndMultiramo
        UNION
           SELECT /*+RULE*/
                  P.IdPoliza,                     P.NumPolUnico,
                  P.NumPolRef,                    DP.IDETPOL,
                  OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
                     OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
                  F.IdEndoso,                     F.IdFactura IdRecibo,
                  TO_CHAR(T.FechaTransaccion,'DD/MM/YYYY') FechaTransaccion,
                  TO_CHAR(F.FecVenc,'DD/MM/YYYY') FecVenc,
                  F.Cod_Moneda,                   DP.IdTipoSeg,
                  DP.PlanCob,                     PC.CodTipoPlan,
                  OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
                  P.CodCliente,
                  TO_CHAR(P.FecIniVig,'DD/MM/YYYY') FecIniVig,
                  TO_CHAR(P.FecFinVig,'DD/MM/YYYY') FecFinVig,
                  P.NumRenov,
                  P.CodCia,                       F.MtoComisi_Moneda * -1 MtoComisi_Moneda,
                  F.NumCuota,                     P.CodEmpresa,
                  TO_CHAR(TRUNC(T.FECHATRANSACCION),'DD/MM/YYYY')  FecPago,
                  --TO_CHAR(TRUNC(PG.FecAnulacion),'DD/MM/YYYY')  FecPago,
                  T.IdTransaccion,
                  'REVE' TipoTran,                F.FolioFactElec,
                  F.FECFINVIG FECFINVIG_FAC,      GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(T.FECHATRANSACCION),F.Cod_Moneda) TIPO_CAMBIO,
                 --
                  DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                  NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                  UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
                  P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                  CGO.DESCCATEGO                                            CATEGORIA,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                  --
                  F.MontoPrimaCompMoneda                                                                        MONTOPRIMARETIROMON,    --> JALV (+) 09/11/2021
                  F.MontoPrimaCompLocal                                                                            MONTOPRIMARETIROLOC,        --> JALV (+) 09/11/2021
                  CASE TS.CODTIPOPLAN
                    WHEN '099' THEN
                       OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto)
                    ELSE
                       TS.CODTIPOPLAN
                  END CodRamo,
                  CASE TS.CODTIPOPLAN
                    WHEN '099' THEN
                       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg, DP.PlanCob, C.CodConcepto))
                    ELSE
                       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',TS.CODTIPOPLAN)
                  END DescRamo,
                  TS.IndMultiramo
             FROM TRANSACCION          T,
                  DETALLE_TRANSACCION DT,
                  FACTURAS        F,
                  --
                  DETALLE_FACTURAS DF,
                  CATALOGO_DE_CONCEPTOS C,
                  --
                  --PAGOS           PG,
                  POLIZAS         P,
                  DETALLE_POLIZA  DP,
                  --
                  TIPOS_DE_SEGUROS TS,
                  --
                  PLAN_COBERTURAS PC,
                  POLIZAS_TEXTO_COTIZACION  TXT,
                  CATEGORIAS                CGO
            WHERE T.CODCIA                   = DT.CODCIA
              AND T.CODEMPRESA               = DT.CODEMPRESA
              AND T.IdProceso                IN (12,21)
              AND TRUNC(T.FECHATRANSACCION) BETWEEN DFECDESDE  AND DFECHASTA
              AND DT.IDTRANSACCION           = T.IDTRANSACCION
              AND DT.CODEMPRESA              = T.CODEMPRESA
              AND DT.CODCIA                  = T.CODCIA
              AND DT.OBJETO                  = 'FACTURAS'
              AND DT.CODSUBPROCESO          IN ('REVPAG','REVPPD')
              --
              AND F.IDPOLIZA                 = TO_NUMBER(DT.VALOR1)
              AND F.IDFACTURA                = TO_NUMBER(DT.VALOR4)
              AND PC.PlanCob                 = DP.PlanCob
              AND PC.IdTipoSeg               = DP.IdTipoSeg
              AND PC.CodEmpresa              = DP.CodEmpresa
              AND PC.CodCia                  = DP.CodCia
              AND DP.CodCia                  = F.CodCia
              AND DP.IDetPol                 = F.IDetPol
              AND DP.IdPoliza                = F.IdPoliza
              AND F.IdFactura               = DF.IdFactura
              AND DP.IDTIPOSEG               = TS.IDTIPOSEG
              AND DP.CODEMPRESA              = TS.CODEMPRESA
              AND DP.CodCia                  = TS.CodCia
              AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
              AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
              AND F.Cod_Moneda              = nvl(cCodMoneda, F.Cod_Moneda)
              AND F.CodGenerador            = nvl(cCodAgente, F.CodGenerador)
               --
              AND P.CodCia                   = F.CodCia
              AND P.CODEMPRESA               = T.CODEMPRESA
              AND P.IdPoliza                 = F.IdPoliza
              --
              AND TXT.CODCIA(+)              = P.CODCIA
              AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
              --
              AND CGO.CODCIA(+)              = P.CODCIA
              AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
              AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
              AND CGO.CODCATEGO(+)           = P.CODCATEGO
              AND C.CODCIA                   = P.CODCIA
              AND C.CodConcepto              = DF.CodCpto
              AND (C.IndCptoPrimas            = 'S'  OR C.INDCPTOFONDO = 'S')
                GROUP BY P.IdPoliza, P.NumPolUnico, P.NumPolRef, DP.IDetPol,
                    P.CODGRUPOEC, DP.CODFILIAL, F.IdEndoso, F.IdFactura,
                    T.FECHATRANSACCION, F.FECVENC, DP.IDTIPOSEG, DP.PLANCOB,
                    PC.CODTIPOPLAN, P.CodCliente, P.FECINIVIG, P.FECFINVIG,
                    P.NUMRENOV, P.CodCia, F.MtoComisi_Moneda, F.NUMCUOTA,
                    T.IDTRANSACCION, F.FOLIOFACTELEC, F.FECFINVIG, F.Cod_Moneda,
                    P.PORCENCONTRIBUTORIO, TXT.DESCGIRONEGOCIO, F.STSFACT,
                    P.CODTIPONEGOCIO, P.FUENTERECURSOSPRIMA, P.CODPAQCOMERCIAL, CGO.DESCCATEGO,
                    P.FORMAVENTA, F.MontoPrimaCompMoneda, F.MontoPrimaCompLocal, P.CodEmpresa,
                    OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(P.CodCia, P.CodEmpresa, DP.IdTipoSeg,
                    DP.PlanCob, C.CodConcepto), TS.CODTIPOPLAN, TS.IndMultiramo
             ORDER BY IdRecibo;


        CURSOR DET_Q IS
           SELECT D.CodCpto,      DECODE(cTipoTran,'PAGO',D.Monto_Det_Moneda,D.Monto_Det_Moneda*-1) Monto_Det_Moneda,
                  D.IndCptoPrima, C.IndCptoServicio
             FROM DETALLE_FACTURAS      D,
                  FACTURAS              F,
                  CATALOGO_DE_CONCEPTOS C
            WHERE C.CodConcepto = D.CodCpto
              AND C.CodCia      = F.CodCia
              AND D.IdFactura   = F.IdFactura
              AND F.IdFactura   = nIdFactura;

            CURSOR DET_Q_MR (nCodRamo Varchar2) IS
                     SELECT D.CodCpto,            --D.Monto_Det_Moneda,                                         --MLJS 27/05/2022
                            DECODE(cTipoTran,'PAGO',D.Monto_Det_Moneda,D.Monto_Det_Moneda*-1) Monto_Det_Moneda, --MLJS 27/05/2022
                            D.IndCptoPrima,       C.IndCptoServicio,
                            OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(nCodCia, nCodEmpresa, nIdTipoSeg, cPlanCobert, C.CodConcepto) RamoPrimas,
                            C.CodTipoPlan
                 FROM DETALLE_FACTURAS      D,
                      FACTURAS              F,
                      CATALOGO_DE_CONCEPTOS C
                WHERE C.CodConcepto = D.CodCpto
                  AND C.CodCia      = F.CodCia
                  AND D.IdFactura   = F.IdFactura
                  AND F.IdFactura   = nIdFactura
                  and nvl(CodTipoPlan, OC_COBERTURAS_DE_SEGUROS.RAMO_REAL_CPTO(nCodCia, nCodEmpresa, nIdTipoSeg, cPlanCobert, C.CodConcepto)) = nCodRamo;


        CURSOR DET_ConC (P_IdPoliza NUMBER, p_idFactura NUMBER) IS
           SELECT DCO.CodConcepto,                 AGE.CodTipo,
                  AGE.CodNivel,                    COM.Cod_Agente,
                  DECODE(cTipoTran,'PAGO',DCO.Monto_Mon_Extranjera,DCO.Monto_Mon_Extranjera*-1) Monto_Mon_Extranjera
             FROM COMISIONES       COM,
                  DETALLE_COMISION DCO,
                  AGENTES          AGE
            WHERE DCO.CodConcepto IN ('HONORA','COMISI','COMIPF','COMIPM','UDI','IVAHON')
              AND COM.CodCia     = DCO.CodCia
              AND COM.IdComision = DCO.IdComision
              AND AGE.Cod_Agente = COM.Cod_Agente
              AND COM.idpoliza   = P_IdPoliza
              AND COM.IdFactura  = p_IdFactura;

        CURSOR DET_ConC_MR (P_IdPoliza Number, p_idFactura Number ) IS
                SELECT DCO.CodConcepto, --DCO.Monto_Mon_Extranjera,                                                        --MLJS 27/05/2022
                       DECODE(cTipoTran,'PAGO',DCO.Monto_Mon_Extranjera,DCO.Monto_Mon_Extranjera*-1) Monto_Mon_Extranjera, --MLJS 27/05/2022
                         AGE.CodTipo, AGE.CodNivel,
                         COM.Cod_Agente,
                         SUM(OC_COMISIONES.MONTO_COMISION (COM.CodCia,COM.idpoliza,AGE.CodNivel,AGE.Cod_Agente,COM.IdFactura,NULL)) MtoComision,
                         C.CodTipoPlan, COM.IdComision
                    FROM COMISIONES COM, DETALLE_COMISION DCO,
                         AGENTES AGE, CATALOGO_DE_CONCEPTOS C
                 WHERE DCO.CodConcepto IN ('HONORA','COMISI', 'COMIPF', 'COMIPM', 'UDI', 'IVAHON', 'IVASIN', 'COMACC', 'COMVDA', 'HONACC', 'HONVDA')
                     AND COM.CodCia       = DCO.CodCia
                     AND COM.IdComision   = DCO.IdComision
                     AND AGE.COD_AGENTE   = COM.COD_AGENTE
                     AND DCO.CodConcepto  = C.CodConcepto
                     AND COM.idpoliza     = P_IdPoliza
                     AND COM.IdFactura    = p_idFactura
                 GROUP BY DCO.CodConcepto, DCO.Monto_Mon_Extranjera,
                         AGE.CodTipo, AGE.CodNivel,
                         COM.Cod_Agente, C.CodTipoPlan, COM.IdComision
                 ORDER BY COM.IdComision;

        CURSOR NC_Q IS
           SELECT  /*RULE*/
                  P.IdPoliza,                     P.NumPolUnico,
                  P.NumPolRef,                    DP.IDETPOL,
                  OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
                  OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
                  N.IdEndoso,                     N.IdNcr,
                  TO_CHAR(T.FechaTransaccion,'DD/MM/YYYY') FechaTransaccion,
                  TO_CHAR(N.FecDevol,'DD/MM/YYYY') FecDevol,
                  N.CodMoneda,                    DP.IdTipoSeg,
                  DP.PlanCob,                     PC.CodTipoPlan,
                  DP.CodPlanPago,
                  OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
                  P.CodCliente,
                  TO_CHAR(P.FecIniVig,'DD/MM/YYYY') FecIniVig,
                  TO_CHAR(P.FecFinVig,'DD/MM/YYYY')FecFinVig,
                  P.NumRenov,
                  P.CodCia,                       N.MtoComisi_Moneda,
                  1 NumCuota,                     P.CodEmpresa,
                  TO_CHAR(N.FecDevol,'DD/MM/YYYY')  FecAnul,
                  T.IdTransaccion,
                  N.FolioFactElec,                N.StsNcr,
                  N.IDTRANSACREVAPLIC,            N.FECFINVIG FECFINVIG_NCR,
                  GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(N.FecDevol),N.CodMoneda)  TIPO_CAMBIO,
                 --
                  DECODE(NVL(P.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
                  NVL(P.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
                  UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
                  P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
                  CGO.DESCCATEGO                                            CATEGORIA,
                  DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA,
                  --
                  OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(P.CodCia, P.CodEmpresa, PC.IdTipoSeg) CodRamo,
                  OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(P.CodCia, P.CodEmpresa, PC.IdTipoSeg)) DescRamo
             FROM TRANSACCION          T,
                  DETALLE_TRANSACCION DT,
                  NOTAS_DE_CREDITO N,
                  POLIZAS          P,
                  DETALLE_POLIZA   DP,
                  PLAN_COBERTURAS  PC,
                  POLIZAS_TEXTO_COTIZACION  TXT,
                  CATEGORIAS                CGO
            WHERE DT.IDTRANSACCION           = T.IDTRANSACCION
              AND DT.CODEMPRESA              = T.CODEMPRESA
              AND DT.CODCIA                  = T.CODCIA
              AND DT.OBJETO                  = 'NOTAS_DE_CREDITO'
              AND DT.CODSUBPROCESO IN ('PAGNCR','APLNCR','REAPNC')
              AND DT.VALOR1                  = N.IDPOLIZA
              AND T.CODCIA                   = DT.CODCIA
              AND T.CODEMPRESA               = DT.CODEMPRESA
              AND TRUNC(T.FechaTransaccion) BETWEEN dFecDesde AND dFecHasta
              AND T.IdProceso                IN (19,20)
              AND N.IDNCR                    = DT.VALOR4
              AND PC.PlanCob                 = DP.PlanCob
              AND PC.IdTipoSeg               = DP.IdTipoSeg
              AND PC.CodEmpresa              = DP.CodEmpresa
              AND PC.CodCia                  = DP.CodCia
              AND DP.CodCia                  = N.CodCia
              AND DP.IDetPol                 = N.IDetPol
              AND DP.IdPoliza                = N.IdPoliza
              --
              AND DP.IdTipoSeg              = nvl(cIdTipoSeg, DP.IdTipoSeg)
              AND DP.PlanCob                = nvl(cPlanCob,   DP.PlanCob)
              AND N.CodMoneda              = nvl(cCodMoneda, N.CODMONEDA )
              AND N.COD_AGENTE             = nvl(cCodAgente,  N.COD_AGENTE )
              --
              AND P.CodCia                   = N.CodCia
              AND P.IdPoliza                 = N.IdPoliza
              --
              AND TXT.CODCIA(+)              = P.CODCIA
              AND TXT.CODEMPRESA(+)          = P.CODEMPRESA
              AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
              --
              AND CGO.CODCIA(+)              = P.CODCIA
              AND CGO.CODEMPRESA(+)          = P.CODEMPRESA
              AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO
              AND CGO.CODCATEGO(+)           = P.CODCATEGO
            ORDER BY N.IdNcr;

        CURSOR DET_NC_Q IS
           SELECT D.CodCpto,                   D.IndCptoPrima,
                  C.IndCptoServicio,           D.Monto_Det_Moneda*-1 Monto_Det_Moneda
             FROM DETALLE_NOTAS_DE_CREDITO D,
                  NOTAS_DE_CREDITO         N,
                  CATALOGO_DE_CONCEPTOS    C
            WHERE C.CodConcepto = D.CodCpto
              AND C.CodCia      = N.CodCia
              AND D.IdNcr       = N.IdNcr
              AND N.IdNcr       = nIdNcr;

        CURSOR DET_ConC_NCR (nIdPoliza NUMBER, nIdNcr NUMBER) IS
           SELECT DCO.CodConcepto,             AGE.CodTipo,
                  AGE.CodNiVel,                COM.Cod_Agente,
                  DCO.Monto_Mon_Extranjera
             FROM COMISIONES       COM,
                  DETALLE_COMISION DCO,
                  AGENTES          AGE
            WHERE DCO.CodConcepto IN ('HONORA','COMISI','COMIPF','COMIPM','UDI','IVAHON')
              AND COM.CodCia     = DCO.CodCia
              AND COM.IdComision = DCO.IdComision
              AND AGE.Cod_Agente = COM.Cod_Agente
              AND COM.IdPoliza   = nIdPoliza
              AND COM.IdNcr      = nIdNcr;

            ----------------------------

        -------------------------------
    BEGIN
        --
        SELECT SYS_CONTEXT ('USERENV','CURRENT_USERID'),
               SYS_CONTEXT('userenv', 'terminal'),
               USER
          INTO cCodUser,
               W_ID_TERMINAL,
               W_ID_USER
          FROM DUAL;
        ----;

          DELETE FROM T_REPORTES_AUTOMATICOS A
           WHERE A.NOMBRE_REPORTE LIKE cCodReporte || '%'
             AND A.FECHA_PROCESO <= TRUNC(ADD_MONTHS(SYSDATE,-8));
          --
          W_ID_ENVIO := OC_CONTROL_PROCESOS_AUTOMATICO.INSERTA_REGISTRO('RECIBOS_PAGADOS_COB', W_ID_TERMINAL);
          DBMS_OUTPUT.PUT_LINE('ID_ENVIO: '|| w_ID_ENVIO);
          --
          PID_ENVIO := W_ID_ENVIO;
          COMMIT;
          --
          cNomDirectorio := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SO_PATH', 'REPORT');
          ----
          SELECT
             NVL(dFecInicio, TRUNC(sysdate - 1)) first,
             NVL(dFecFinal,  TRUNC(sysdate - 1)) last
            INTO dFecDesde, dFecHasta
            FROM dual ;

          dbms_output.put_line('dPrimerDia '||dFecDesde);
          dbms_output.put_line('dUltimoDia '||dFecHasta);
          --

          BEGIN
             SELECT NomCia
               INTO cNomCia
               FROM EMPRESAS
              WHERE CodCia = nCodCia;
          EXCEPTION WHEN NO_DATA_FOUND THEN
                cNomCia := 'COMPANIA - NO EXISTE!!!';
          END;
          ----
          nLinea := 6;
          --
                  cTitulo1 := cNomCia;
                  cTitulo2 := 'REPORTE DE RECIBOS PAGADOS DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY');
                  cTitulo4 := ' ';
                 cEncabez  := 'No. de Póliza'||cLimitador||
                         'Consecutivo'||cLimitador||
                         'No. Referencia'||cLimitador||
                         'Sub-Grupo'||cLimitador||
                         'Contratante'||cLimitador||
                         'No. de Endoso'||cLimitador||
                         'Tipo'||cLimitador||
                         'No. Recibo'||cLimitador||
                         'Forma de Pago'||cLimitador||
                         'Fecha Emisión'||cLimitador||
                         'Inicio Vigencia'||cLimitador||
                         'Fin Vigencia'||cLimitador||
                         'Fecha Pago/Reverso'||cLimitador||
                         'Prima Neta'||cLimitador||
                         'Reducción Prima'||cLimitador||
                         'Recargos'||cLimitador||
                         'Derechos'||cLimitador||
                         'Impuesto'||cLimitador||
                         'Prima Total'||cLimitador||
                         'Compensación Sobre Prima'||cLimitador||
                         'Comisión Persona Fisica'||cLimitador||
                         'Comisión Persona Moral'||cLimitador||
                         'Honorarios Persona Fisica'||cLimitador||
                         'Impuesto Honorarios P. Física'||cLimitador||
                         'Honorarios Persona Moral'||cLimitador||
                         'Impuesto Honorarios P. Moral'||cLimitador||
                         'Otras Compensaciones Físicas'||cLimitador||
                         'Impuesto Otras Compensaciones P. Física'||cLimitador||
                         'Otras Compensaciones Morales'||cLimitador||
                         'Impuesto Otras Compensaciones P. Morales'||cLimitador||
                         'Dif. en Comisiones'||cLimitador||
                         'Comisión Agente'||cLimitador||
                         'Honorario Agente'||cLimitador||
                         'Agente'||cLimitador||
                         'Tipo Agente'||cLimitador||
                         'Comisión Promotor'||cLimitador||
                         'Honorario Promotor'||cLimitador||
                         'Promotor'||cLimitador||
                         'Tipo Promotor'||cLimitador||
                         'Comisión Dirección Regional'||cLimitador||
                         'Honorario Dirección Regional'||cLimitador||
                         'Dirección Regional'||cLimitador||
                         'Tipo Dirección Regional'||cLimitador||
                         'Tasa IVA'||cLimitador||
                         'Estado'||cLimitador||
                         'Moneda'||cLimitador||
                         'Tipo Cambio'||cLimitador||
                         'Tipo Seguro'||cLimitador||
                         'Plan Coberturas'||cLimitador||
                         'Código SubRamo'||cLimitador||
                         'Descripción SubRamo'||cLimitador||
                         'Tipo Vigencia'||cLimitador||
                         'No. Cuota'||cLimitador||
                         'Inicio Vig. Póliza'||cLimitador||
                         'Fin Vig. Póliza'||cLimitador||
                         'No. Renovacion'||cLimitador||
                         'No. Comprobante'||cLimitador||
                         'Folio Fact. Electrónica'||cLimitador||
                         'Folio Fiscal'||cLimitador||
                         'Serie'||cLimitador||
                        'UUID'||cLimitador||
                        'Fecha UUID'||cLimitador||
                        'Varios UUID'||cLimitador||
                        'Origen del Recibo'||cLimitador||
                        'Es Contributorio'||cLimitador ||
                        '% Contributorio'||cLimitador ||
                        'Giro de Negocio'||cLimitador ||
                        'Tipo de Negocio'||cLimitador ||
                        'Fuente de Recursos'||cLimitador ||
                        'Paquete Comercial'||cLimitador ||
                        'Categoria'||cLimitador ||
                        'Canal de Venta'||cLimitador||
                        'Prima de Retiro Moneda'||cLimitador||
                         'Prima de Retiro Local'||cLimitador||
                         'Código Ramo'||cLimitador||
                         'Descripción Ramo'||CHR(13);
            --
            dbms_output.put_line(cEncabez);
            --
            IF UPPER(cDestino) != 'REGISTRO' THEN
                INSERTA_ENCABEZADO( 'EXCEL', nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo, cEncabez, cTitulo1, cTitulo2, cTitulo4) ;
            END IF;

            dbms_output.put_line('cNomDirectorio '||cNomDirectorio||' cNomArchivo  '||cNomArchivo );

           FOR X IN PAG_Q LOOP
                 cTipoTran       := X.TipoTran;
                 nIdFactura      := X.IdRecibo;
                 cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
              cDescFormaPago  := OC_FACTURAS.FRECUENCIA_PAGO(X.CodCia, X.IdRecibo);
              --dFecFin         := OC_FACTURAS.VIGENCIA_FINAL(X.CodCia, nIdFactura);
              dFecFin         := X.FECFINVIG_FAC;
              cFecFin         := TO_CHAR(dFecFin,'DD/MM/YYYY');

              nIdTipoSeg            := X.IdTipoSeg;
              cPlanCobert           := X.PlanCob;

              BEGIN
                 SELECT OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes)
                   INTO cDescEstado
                   FROM CLIENTES C, PERSONA_NATURAL_JURIDICA P
                  WHERE P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
                    AND P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
                    AND C.CodCliente              = X.CodCliente;
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    cDescEstado := NULL;
              END;
              IF cDescEstado = 'PROVINCIA NO EXISTE' THEN
                   cDescEstado := NULL;
              END IF;

              IF X.NumRenov = 0 THEN
                 cTipoVigencia := '1ER. AÑO';
              ELSE
                 cTipoVigencia := 'RENOVACION';
              END IF;

              nPrimaNeta      := 0;
              nReducPrima     := 0;
              nRecargos       := 0;
              nDerechos       := 0;
              nImpuesto       := 0;
              nPrimaTotal     := 0;
              nComisionesPEF  := 0;
              nHonorariosPEF  := 0;
              nUdisPEF        := 0;
              nComisionesPEM  := 0;
              nHonorariosPEM  := 0;
              nUdisPEM        := 0;
              nTotComisDist   := 0;
              nMtoComiAge     := 0;
              nMtoHonoAge     := 0;
              nMtoComiProm    := 0;
              nMtoHonoProm    := 0;
              nMtoComiDR      := 0;
              nMtoHonoDR      := 0;
              nImpuestoHonoPF := 0;
              nImpuestoHonoPM := 0;
              nImpuestoHonoPFOC := 0;
              nImpuestoHonoPMOC := 0;
              --
              cTipoAge        := 0;
              cCodAge         := 0;
              cTipoProm       := 0;
              cCodProm        := 0;
              cTipoDR         := 0;
              cCodDR          := 0;
              nOtrasCompPF    := 0;
              nOtrasCompPM    := 0;
              --

              IF NVL(X.IndMultiramo,'N') = 'N' THEN
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
                ELSE
                  FOR W IN DET_Q_MR(X.CodRamo) LOOP
                     IF (W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S') THEN
                        nPrimaNeta  := NVL(nPrimaNeta,0) + NVL(W.Monto_Det_Moneda,0);
                     ELSIF W.CodCpto IN ('RECVDA','RECACC')  AND W.CodTipoPlan = X.CodRamo THEN
                        nRecargos   := NVL(nRecargos,0) + NVL(W.Monto_Det_Moneda,0);
                     ELSIF W.CodCpto IN ('DEREVI', 'DEREAP') AND W.CodTipoPlan = X.CodRamo THEN
                        nDerechos   := NVL(nDerechos,0) + NVL(W.Monto_Det_Moneda,0);
                     ELSIF W.CodCpto = 'IVASIN' AND X.CodRamo = OC_VALORES_DE_LISTAS.BUSCA_LVALOR('RAMOIVA', W.CodCpto) THEN
                        nImpuesto   := NVL(nImpuesto,0) + NVL(W.Monto_Det_Moneda,0);
                        nTasaIVA    := OC_CONCEPTOS_PLAN_DE_PAGOS.PORCENTAJE_CONCEPTO(X.CodCia, X.CodEmpresa, cCodPlanPagos, W.CodCpto);
                     END IF;
                     nPrimaTotal  := NVL(nPrimaNeta,0) + NVL(nRecargos,0) + NVL(nDerechos,0) + NVL(nImpuesto,0);
                  END LOOP;
                    END IF;

                    IF NVL(X.IndMultiramo,'N') = 'N' THEN
                  FOR C IN DET_ConC (X.IdPoliza, X.IdRecibo) LOOP
                     IF C.CODTIPO = 'AGTEPF' THEN --AGENTE PERSONA FISICA
                        IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                           nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                        ELSIF C.CodConcepto = 'HONORA' THEN
                           nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                        END IF;
                     ELSIF C.CODTIPO = 'AGTEPM' THEN -- AGENTE PERSONA MORAL
                        IF C.CodConcepto IN ('COMISI','COMIPM') THEN
                           nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                        ELSIF C.CodConcepto = 'HONORA' THEN
                           nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                        END IF;
                     ELSIF C.CODTIPO = 'HONPF' THEN -- HONORARIOS PERSONA FISICA
                        IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                           nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                        ELSIF C.CodConcepto = 'HONORA' THEN
                           nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                               ELSIF C.CodConcepto = 'IVAHON' THEN
                            nImpuestoHonoPF   := NVL(nImpuestoHonoPF,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190603 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                        END IF;
                     ELSIF C.CODTIPO = 'HONPM' THEN -- HONORARIOS PERSONA MORAL
                        IF C.CodConcepto IN ('COMISI','COMIPM') THEN
                           nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                        ELSIF C.CodConcepto = 'HONORA' THEN
                           nHonorariosPEM  := NVL(nHonorariosPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                               ELSIF C.CodConcepto = 'IVAHON' THEN
                            nImpuestoHonoPM   := NVL(nImpuestoHonoPM,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190603 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                        END IF;
                     ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
                        IF C.CodConcepto = 'UDI' THEN
                                   nOtrasCompPF  := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                        END IF;
                     ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL
                        IF C.CodConcepto = 'UDI' THEN
                                   nOtrasCompPM  := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                        END IF;
                     ELSIF C.CODTIPO = 'HONORF' THEN -- HONORARIOS PERSONA FISICA
                                        IF C.CodConcepto = 'HONORA' THEN
                                   nOtrasCompPF  := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                                  ELSIF C.CodConcepto = 'IVAHON' THEN
                                    nImpuestoHonoPFOC   := NVL(nImpuestoHonoPFOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190603 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                           END IF;
                     ELSIF C.CODTIPO = 'HONORM' THEN -- HONORARIOS PERSONA MORAL
                           IF C.CodConcepto = 'HONORA' THEN
                                   nOtrasCompPM  := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                                  ELSIF C.CodConcepto = 'IVAHON' THEN
                                    nImpuestoHonoPMOC  := NVL(nImpuestoHonoPMOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190603 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                           END IF;
            ----
                     END IF;
                    IF C.CodConcepto != 'IVAHON' THEN
                       nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                     --
                    IF C.CodNivel IN (3,4) THEN                                                                     --MLJS 27/05/2022 SE AGREGO EL NIVEL 4
                                    cTipoAge            := C.CodTipo;
                                    cCodAge                := C.Cod_Agente;
                                    IF C.CodTipo IN ('HONPM','HONPF','HONORM') AND C.CodConcepto = 'HONORA' THEN    --MLJS 27/05/2022 SE AGREGO EL NIVEL 4
                                        nMtoHonoAge := NVL(C.Monto_Mon_Extranjera,0);
                                    ELSE
                          nMtoComiAge  := NVL(C.Monto_Mon_Extranjera,0);
                                    END IF;   -- asi estaba y se cambia por el de abajo para desglosar mas los conceptos
                             ELSIF C.CodNivel = 2 THEN
                                    cTipoProm            := C.CodTipo;
                                    cCodProm             := C.Cod_Agente;
                                    IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                                        nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
                                    ELSE
                          nMtoComiProm    := NVL(C.Monto_Mon_Extranjera,0);
                                    END IF;   -- asi estaba y se modifico a quedar en lo de abajo para desglosar mas los conceptos
                       ELSIF C.CodNivel = 1 THEN
                                    cTipoDR                := C.CodTipo;
                                    cCodDR                 := C.Cod_Agente;
                                    IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                                        nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
                        ELSE
                           nMtoComiDR        := NVL(C.Monto_Mon_Extranjera,0);
                        END IF;
                       END IF;
                    END LOOP;
                  ELSE
                        ------------------------------------------------------------------------------------------------------------------------------------------------------
                        FOR C IN DET_ConC_MR (X.IdPoliza, X.IdRecibo) LOOP
                     IF C.CodTipo = 'AGTEPF' THEN --AGENTE PERSONA FISICA
                        IF C.CodConcepto IN ('COMISI','COMIPF','COMACC', 'COMVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                           nComisionesPEF  := NVL(nComisionesPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                        END IF;
                     ELSIF C.CodTipo = 'AGTEPM' THEN -- AGENTE PERSONA MORAL
                        IF C.CodConcepto IN ('COMISI','COMIPM', 'COMACC', 'COMVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                           nComisionesPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);
                        END IF;
                     ELSIF C.CodTipo = 'HONPF' THEN -- HONORARIOS PERSONA FISICA
                        IF C.CodConcepto IN ('COMISI','COMIPF', 'HONACC', 'HONVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                           nHonorariosPEF  := NVL(nHonorariosPEF,0) + NVL(C.Monto_Mon_Extranjera,0);
                               ELSIF C.CodConcepto IN ('IVAHON') THEN
                            nImpuestoHonoPF   := NVL(nImpuestoHonoPF,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                        END IF;
                     ELSIF C.CodTipo = 'HONPM' THEN -- HONORARIOS PERSONA MORAL
                        IF C.CodConcepto IN ('COMISI','COMIPM', 'HONACC', 'HONVDA') AND  C.CodTipoPlan = X.CodRamo THEN
                           nHonorariosPEM  := NVL(nComisionesPEM,0) + NVL(C.Monto_Mon_Extranjera,0);   --- CAMBIAR POR VARIABLE CORRECTA
                               ELSIF C.CodConcepto IN ('IVAHON') THEN
                            nImpuestoHonoPM  := NVL(nImpuestoHonoPM,0) + NVL(C.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                        END IF;
                     ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
                        IF C.CodConcepto = 'UDI' THEN
                           nOtrasCompPF    := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                        END IF;
                     ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL
                        IF C.CodConcepto = 'UDI' THEN
                           nOtrasCompPM    := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                        END IF;
                            ---- jmmd20190523Se incluyen los conceptos para HONORF y HONORM
                     ELSIF C.CODTIPO = 'HONORF' THEN -- HONORARIOS PERSONA FISICA
                                        IF C.CodConcepto = 'HONORA' THEN
                                   nOtrasCompPF  := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                                  ELSIF C.CodConcepto = 'IVAHON' THEN
                                    nImpuestoHonoPFOC   := NVL(nImpuestoHonoPFOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                           END IF;
                     ELSIF C.CODTIPO = 'HONORM' THEN -- HONORARIOS PERSONA MORAL
                             IF C.CodConcepto = 'HONORA' THEN
                                   nOtrasCompPM  := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                                  ELSIF C.CodConcepto = 'IVAHON' THEN
                                    nImpuestoHonoPMOC   := NVL(nImpuestoHonoPMOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190530 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                           END IF;
                            ----
                     END IF;
                     IF C.CodConcepto = 'IVASIN' THEN
                           NULL;
                     ELSE
                             nTotComisDist   := NVL(nTotComisDist,0) + NVL(C.Monto_Mon_Extranjera,0);
                     END IF;
                     --
                     IF C.CodNivel IN (3,4) THEN                                                                    --MLJS 27/05/2022 SE AGREGO EL NIVEL 4
                                    cTipoAge            := C.CodTipo;
                                    cCodAge                := C.Cod_Agente;
                                    IF C.CodTipo IN ('HONPM','HONPF','HONORM') AND C.CodConcepto IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                          nMtoHonoAge        := NVL(C.Monto_Mon_Extranjera,0);                                    --MLJS 27/05/2022 SE AGREGO EL TIPO HONORM
                                    ELSIF C.CodTipo NOT IN ('HONPM','HONPF','HONORM') AND C.CodConcepto NOT IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                          nMtoComiAge        := NVL(C.Monto_Mon_Extranjera,0);                                    --MLJS 27/05/2022 SE AGREGO EL TIPO HONORM
                                    END IF;    -- ASI ESTABA SE CAMBIA POR EL DE ABAJO PARA DESGLOSAR MAS LOS CONCEPTOS
                            ----
                             ELSIF C.CodNivel = 2 THEN
                                    cTipoProm            := C.CodTipo;
                                    cCodProm             := C.Cod_Agente;
                                    IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                                        nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
                                    ELSIF C.CodTipo NOT IN ('HONPM','HONPF') AND C.CodConcepto NOT IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                          nMtoComiProm    := NVL(C.Monto_Mon_Extranjera,0);
                                    END IF;
                            ----
                       ELSIF C.CodNivel = 1 THEN
                                    cTipoDR                := C.CodTipo;
                                    cCodDR                 := C.Cod_Agente;
                                    IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                                        nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
                        ELSIF C.CodTipo NOT IN ('HONPM','HONPF') AND C.CodConcepto NOT IN ('HONORA', 'HONACC', 'HONVDA') AND C.CodTipoPlan = X.CodRamo THEN
                           nMtoComiDR        := NVL(C.Monto_Mon_Extranjera,0);
                        END IF;    --JMMD asi estaba , se cambio por el de abajo para desglosar mas las validaciones
                            ----
                       END IF;
                  END LOOP;
                        ------------------------------------------------------------------------------------------------------------------------------------------------------
                    END IF;

                    nPrimaTotalLocal    := OC_DETALLE_FACTURAS.MONTO_PRIMAS(X.IdTransaccion);
                    nFactorPrimaRamo    := OC_FACTURAR.FACTOR_PRORRATEO_RAMO(X.CodCia, X.IdPoliza, X.IDetPol, X.CodRamo, nPrimaTotalLocal);
              nDifComis := NVL(X.MtoComisi_Moneda,0) - NVL(nTotComisDist,0);

              SELECT NVL(MIN(NumComprob),'0')
                INTO cNumComprob
                FROM COMPROBANTES_CONTABLES
               WHERE CODCIA         = X.CodCia
                 AND NumTransaccion = X.IdTransaccion;

              BEGIN
                 SELECT FE.FOLIOFISCAL, FE.SERIE, FE.UUID, FE.FECHAUUID
                   INTO cFolioFiscal, cSerie, cUUID, cFechaUUID
                   FROM FACT_ELECT_DETALLE_TIMBRE FE
                  WHERE FE.IDFACTURA = nIdFactura
                    AND FE.codproceso = 'PAG'
                    AND FE.codrespuestasat = '201'
                    AND FE.FOLIOFISCAL IN (

                 SELECT MAX(FE.FOLIOFISCAL)
                   FROM FACT_ELECT_DETALLE_TIMBRE FE
                  WHERE FE.IDFACTURA = nIdFactura
                    AND FE.codproceso = 'PAG'
                    AND FE.codrespuestasat = '201');
                 EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    cFolioFiscal := NULL;
                           cSerie       := NULL;
                          cUUID        := NULL;
                          cFechaUUID   := NULL;
                END;

              BEGIN
                 SELECT count(FE.IDFACTURA)
                   INTO cVariosUUID
                   FROM FACT_ELECT_DETALLE_TIMBRE FE
                  WHERE FE.IDFACTURA = nIdFactura
                    AND FE.codproceso = 'PAG'
                    AND FE.codrespuestasat = '201'
                  GROUP BY FE.IDFACTURA;
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    cVariosUUID := NULL;
                END;

              cOrigenRecibo := ORIGEN_RECIBO(X.CodCia, X.CodEmpresa, X.IdPoliza, X.IDetPol, nIdFactura);

             cCadena := X.NumPolUnico                                  ||cLimitador||
                        TO_CHAR(X.IdPoliza,'9999999999999')            ||cLimitador||
                        X.NumPolRef                                    ||cLimitador||
                        X.IDETPOL                                      ||cLimitador||
                        X.Contratante                                  ||cLimitador||
                        TO_CHAR(X.IdEndoso,'9999999999999')            ||cLimitador||
                        'RECIBO'                                       ||cLimitador||
                        TO_CHAR(X.IdRecibo,'9999999999990')            ||cLimitador||
                        cDescFormaPago                                 ||cLimitador||
                        X.FechaTransaccion                             ||cLimitador||
                        X.FecVenc                                      ||cLimitador||
                        cFecFin                                        ||cLimitador||
                        X.FecPago                                      ||cLimitador||
                        TO_CHAR(nPrimaNeta,'99999999999990.00')        ||cLimitador||
                        TO_CHAR(nReducPrima,'99999999999990.00')       ||cLimitador||
                        TO_CHAR(nRecargos,'99999999999990.00')         ||cLimitador||
                        TO_CHAR(nDerechos,'99999999999990.00')         ||cLimitador||
                        TO_CHAR(nImpuesto,'99999999999990.00')         ||cLimitador||
                        TO_CHAR(nPrimaTotal,'99999999999990.00')       ||cLimitador||
                        TO_CHAR(X.MtoComisi_Moneda * nFactorPrimaRamo,'99999999999990.00')||cLimitador||
                        TO_CHAR(nComisionesPEF,'99999999999990.00')    ||cLimitador||
                        TO_CHAR(nComisionesPEM,'99999999999990.00')    ||cLimitador||
                        TO_CHAR(nHonorariosPEF,'99999999999990.00')    ||cLimitador||
                        TO_CHAR(nImpuestoHonoPF,'99999999999990.00')   ||cLimitador||
                        TO_CHAR(nHonorariosPEM,'99999999999990.00')    ||cLimitador||
                        TO_CHAR(nImpuestoHonoPM,'99999999999990.00')   ||cLimitador||
                        TO_CHAR(nOtrasCompPF,'99999999999990.00')      ||cLimitador||
                        TO_CHAR(nImpuestoHonoPFOC,'99999999999990.00') ||cLimitador||
                        TO_CHAR(nOtrasCompPM,'99999999999990.00')      ||cLimitador||
                        TO_CHAR(nImpuestoHonoPMOC,'99999999999990.00') ||cLimitador||
                        TO_CHAR(nDifComis,'99999999999990.00')         ||cLimitador||
                        TO_CHAR(nMtoComiAge,'99999999999990.00')       ||cLimitador||
                        TO_CHAR(nMtoHonoAge,'99999999999990.00')       ||cLimitador||
                        LPAD(cCodAge,6,'0')                            ||cLimitador||
                        cTipoAge                                       ||cLimitador||
                        TO_CHAR(nMtoComiProm,'99999999999990.00')      ||cLimitador||
                        TO_CHAR(nMtoHonoProm,'99999999999990.00')      ||cLimitador||
                        LPAD(cCodProm,6,'0')                           ||cLimitador||
                        cTipoProm                                      ||cLimitador||
                        TO_CHAR(nMtoComiDR,'99999999999990.00')        ||cLimitador||
                        TO_CHAR(nMtoHonoDR,'99999999999990.00')        ||cLimitador||
                        LPAD(cCodDR,6,'0')                             ||cLimitador||
                        cTipoDR                                        ||cLimitador||
                        TO_CHAR(nTasaIVA,'999990.00')                  ||cLimitador||
                        cDescEstado                                    ||cLimitador||
                        X.cod_moneda                                   ||cLimitador||
                        TO_CHAR(X.TIPO_CAMBIO,'99999999999990.00')     ||cLimitador||
                        X.IdTipoSeg                                    ||cLimitador||
                        X.PlanCob                                      ||cLimitador||
                        X.CodTipoPlan                                  ||cLimitador||
                        X.DescSubRamo                                  ||cLimitador||
                        cTipoVigencia                                  ||cLimitador||
                        TO_CHAR(X.NumCuota,'99990')                    ||cLimitador||
                        X.FecIniVig                                    ||cLimitador||
                        X.FecFinVig                                    ||cLimitador||
                        TO_CHAR(X.NumRenov,'99990')                    ||cLimitador||
                        cNumComprob                                    ||cLimitador||
                                  X.FolioFactElec                      ||cLimitador||
                                  cFolioFiscal                         ||cLimitador||
                                  cSerie                               ||cLimitador||
                        cUUID                                          ||cLimitador||
                        TO_CHAR(cFechaUUID,'DD/MM/YYYY')               ||cLimitador||
                                  cVariosUUID                          ||cLimitador||
                        cOrigenRecibo                                  ||cLimitador||
                        X.ESCONTRIBUTORIO                              ||cLimitador||
                        X.PORCENCONTRIBUTORIO                          ||cLimitador||
                        X.GIRONEGOCIO                                  ||cLimitador||
                        X.TIPONEGOCIO                                  ||cLimitador||
                        X.FUENTERECURSOS                               ||cLimitador||
                        X.CODPAQCOMERCIAL                              ||cLimitador||
                        X.CATEGORIA                                    ||cLimitador||
                        X.CANALFORMAVENTA                              ||cLimitador||
                        TO_CHAR(NVL(X.MontoPrimaRetiroMon,0),'99999999999990.00')   ||cLimitador||
                        TO_CHAR(NVL(X.MontoPrimaRetiroLoc,0),'99999999999990.00')   ||cLimitador||
                        X.CodRamo                                      ||cLimitador||
                        X.DescRamo                                     ||CHR(13);
                --
                IF UPPER(cDestino) != 'REGISTRO' THEN
                    nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena, 1);
                ELSE
                    INSERTA_REGISTROS(cCodReporte, nLineaimp, 'REPAUTRECPAG', cNomArchivo, cCadena, W_ID_ENVIO);
                END IF;
                --
           END LOOP;

           FOR X IN NC_Q LOOP
                nIdNcr          := X.IdNcr;
                cStsNcr         := X.StsNcr;
                W_FACTORDEVOL   := 1;
                cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
                cDescFormaPago  := 'DIRECTO';
                dFecFin         := X.FECFINVIG_NCR;
                cFecFin         := TO_CHAR(dFecFin,'DD/MM/YYYY');
              BEGIN
                 SELECT OC_PROVINCIA.NOMBRE_PROVINCIA(P.CodPaisRes, P.CodProvRes)
                   INTO cDescEstado
                   FROM CLIENTES C, PERSONA_NATURAL_JURIDICA P
                  WHERE P.Tipo_Doc_Identificacion = C.Tipo_Doc_Identificacion
                    AND P.Num_Doc_Identificacion  = C.Num_Doc_Identificacion
                    AND C.CodCliente              = X.CodCliente;
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    cDescEstado := NULL;
              END;
            --
              IF X.IDTRANSACREVAPLIC IS NOT NULL THEN
                 BEGIN
                  SELECT CC.TIPOCOMPROB
                    INTO W_TIPOCOMPROB
                    FROM COMPROBANTES_CONTABLES CC
                   WHERE CODCIA         = X.CodCia
                     AND CC.NUMTRANSACCION = X.IDTRANSACCION;
                 EXCEPTION
                      WHEN OTHERS THEN NULL;
                 END;
                 --
                IF W_TIPOCOMPROB = 330 THEN
                     W_FACTORDEVOL := -1;
                ELSE
                     W_FACTORDEVOL := 1;
                END IF;
              END IF;
              --
              IF cDescEstado = 'Estado no existe' THEN
                   cDescEstado := NULL;
              END IF;

              IF X.NumRenov = 0 THEN
                 cTipoVigencia := '1ER. AÑO';
              ELSE
                 cTipoVigencia := 'RENOVACION';
              END IF;

              nPrimaNeta      := 0;
              nReducPrima     := 0;
              nRecargos       := 0;
              nDerechos       := 0;
              nImpuesto       := 0;
              nPrimaTotal     := 0;
              nComisionesPEF  := 0;
              nHonorariosPEF  := 0;
              nUdisPEF        := 0;
              nComisionesPEM  := 0;
              nHonorariosPEM  := 0;
              nUdisPEM        := 0;
              nTotComisDist   := 0;
              nMtoComiAge     := 0;
              nMtoHonoAge     := 0;
              nMtoComiProm    := 0;
              nMtoHonoProm    := 0;
              nMtoComiDR      := 0;
              nMtoHonoDR      := 0;
              nImpuestoHonoPF := 0;
              nImpuestoHonoPM := 0;
              nImpuestoHonoPFOC := 0;
              nImpuestoHonoPMOC := 0;

              --
              cTipoAge        := 0;
              cCodAge         := 0;
              cTipoProm       := 0;
              cCodProm        := 0;
              cTipoDR         := 0;
              cCodDR          := 0;
              nOtrasCompPF    := 0;
              nOtrasCompPM    := 0;
              --

              FOR W IN DET_NC_Q LOOP
                 IF W.IndCptoPrima = 'S' OR W.IndCptoServicio = 'S' THEN
                    nPrimaNeta  := NVL(nPrimaNeta,0) + (NVL(W.Monto_Det_Moneda,0)* W_FACTORDEVOL);
                 ELSIF W.CodCpto = 'RECFIN' THEN
                    nRecargos   := NVL(nRecargos,0) + (NVL(W.Monto_Det_Moneda,0)* W_FACTORDEVOL);
                 ELSIF W.CodCpto = 'DEREMI' THEN
                    nDerechos   := NVL(nDerechos,0) + (NVL(W.Monto_Det_Moneda,0)* W_FACTORDEVOL);
                 ELSIF W.CodCpto = 'IVASIN' THEN
                    nImpuesto   := NVL(nImpuesto,0) + (NVL(W.Monto_Det_Moneda,0)* W_FACTORDEVOL);
                    nTasaIVA    := OC_CONCEPTOS_PLAN_DE_PAGOS.PORCENTAJE_CONCEPTO(X.CodCia, X.CodEmpresa, cCodPlanPagos, W.CodCpto);
                 ELSE
                    nImpuesto   := NVL(nImpuesto,0) + (NVL(W.Monto_Det_Moneda,0)* W_FACTORDEVOL);
                 END IF;
                 nPrimaTotal  := NVL(nPrimaTotal,0) + (NVL(W.Monto_Det_Moneda,0)* W_FACTORDEVOL);
              END LOOP;

              FOR C IN DET_ConC_NCR (X.IdPoliza, X.IdNcr) LOOP
                 IF C.CODTIPO = 'AGTEPF' THEN --AGENTE PERSONA FISICA
                    IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                       nComisionesPEF  := NVL(nComisionesPEF,0) + (NVL(C.Monto_Mon_Extranjera,0)* W_FACTORDEVOL);
                    ELSIF C.CodConcepto = 'HONORA' THEN
                       nHonorariosPEF  := NVL(nHonorariosPEF,0) + (NVL(C.Monto_Mon_Extranjera,0)* W_FACTORDEVOL);
                    END IF;
                 ELSIF C.CODTIPO = 'AGTEPM' THEN -- AGENTE PERSONA MORAL
                    IF C.CodConcepto IN ('COMISI','COMIPM') THEN
                       nComisionesPEM  := NVL(nComisionesPEM,0) + (NVL(C.Monto_Mon_Extranjera,0)* W_FACTORDEVOL);
                    ELSIF C.CodConcepto = 'HONORA' THEN
                       nHonorariosPEM  := NVL(nHonorariosPEM,0) + (NVL(C.Monto_Mon_Extranjera,0)* W_FACTORDEVOL);
                    END IF;
                 ELSIF C.CODTIPO = 'HONPF' THEN -- HONORARIOS PERSONA FISICA
                    IF C.CodConcepto IN ('COMISI','COMIPF') THEN
                       nComisionesPEF  := NVL(nComisionesPEF,0) + (NVL(C.Monto_Mon_Extranjera,0)* W_FACTORDEVOL);
                    ELSIF C.CodConcepto = 'HONORA' THEN
                       nHonorariosPEF  := NVL(nHonorariosPEF,0) + (NVL(C.Monto_Mon_Extranjera,0)* W_FACTORDEVOL);
                       ELSIF C.CodConcepto = 'IVAHON' THEN
                        nImpuestoHonoPF   := NVL(nImpuestoHonoPF,0) + (NVL(c.Monto_Mon_Extranjera,0)* W_FACTORDEVOL);
                    END IF;
                 ELSIF C.CODTIPO = 'HONPM' THEN -- HONORARIOS PERSONA MORAL
                    IF C.CodConcepto IN ('COMISI','COMIPM') THEN
                       nComisionesPEM  := NVL(nComisionesPEM,0) + (NVL(C.Monto_Mon_Extranjera,0)* W_FACTORDEVOL);
                    ELSIF C.CodConcepto = 'HONORA' THEN
                       nHonorariosPEM  := NVL(nHonorariosPEM,0) + (NVL(C.Monto_Mon_Extranjera,0)* W_FACTORDEVOL);
                       ELSIF C.CodConcepto = 'IVAHON' THEN
                        nImpuestoHonoPM  := NVL(nImpuestoHonoPM,0) + (NVL(c.Monto_Mon_Extranjera,0)* W_FACTORDEVOL);
                    END IF;
                 ELSIF C.CodTipo = 'UDISPF' THEN -- UDIS PERSONA FISICA
                    IF C.CodConcepto = 'UDI' THEN
                       nOtrasCompPF  := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                 ELSIF C.CodTipo = 'UDISPM' THEN -- UDIS PERSONA MORAL
                    IF C.CodConcepto = 'UDI' THEN
                       nOtrasCompPM  := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
        ---- jmmd20190523Se incluyen los conceptos para HONORF y HONORM
                 ELSIF C.CODTIPO = 'HONORF' THEN -- HONORARIOS PERSONA FISICA
                                    IF C.CodConcepto = 'HONORA' THEN
                               nOtrasCompPF  := NVL(nOtrasCompPF,0) + NVL(C.Monto_Mon_Extranjera,0);
                             ELSIF C.CodConcepto = 'IVAHON' THEN
                                nImpuestoHonoPFOC   := NVL(nImpuestoHonoPFOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190603 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                       END IF;
                 ELSIF C.CODTIPO = 'HONORM' THEN -- HONORARIOS PERSONA MORAL
                         IF C.CodConcepto = 'HONORA' THEN
                               nOtrasCompPM  := NVL(nOtrasCompPM,0) + NVL(C.Monto_Mon_Extranjera,0);
                             ELSIF C.CodConcepto = 'IVAHON' THEN
                                nImpuestoHonoPMOC   := NVL(nImpuestoHonoPMOC,0) + NVL(c.Monto_Mon_Extranjera,0);  ---- jmmd20190603 nImpuestoHono Nuevo concepto para el proyecto de honorarios
                       END IF;
        ----
                 END IF;
                 IF C.CodConcepto = 'IVAHON' THEN
                     NULL;
                 ELSE
                     nTotComisDist   := NVL(nTotComisDist,0) + (NVL(C.Monto_Mon_Extranjera,0)* W_FACTORDEVOL);
                 END IF;
                 --
                 IF C.CodNivel IN (3,4)  THEN                                                                  --MLJS 27/05/2022 SE AGREGO EL NIVEL 4
                                cTipoAge            := C.CodTipo;
                                cCodAge                := C.Cod_Agente;
                    IF C.CodTipo IN ('HONPM','HONPF','HONORM') AND C.CodConcepto = 'HONORA' THEN               --MLJS 27/05/2022 SE AGREGO EL TIPO HONORM
                       nMtoHonoAge := NVL(C.Monto_Mon_Extranjera,0);
                    ELSE
                      nMtoComiAge  := NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                 ELSIF C.CodNivel = 2 THEN
                                cTipoProm            := C.CodTipo;
                                cCodProm             := C.Cod_Agente;
                                IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                                    nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
                                ELSE
                      nMtoComiProm    := NVL(C.Monto_Mon_Extranjera,0);
                      END IF;
                   ELSIF C.CodNivel = 1 THEN
                                cTipoDR                := C.CodTipo;
                                cCodDR                 := C.Cod_Agente;
                                IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                                    nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
                    ELSE
                       nMtoComiDR        := NVL(C.Monto_Mon_Extranjera,0);
                    END IF;
                   END IF;
              END LOOP;


              W_MtoComisi_Moneda := NVL(X.MtoComisi_Moneda,0)* W_FACTORDEVOL;
              nDifComis          := W_MtoComisi_Moneda - NVL(nTotComisDist,0);

              SELECT NVL(MIN(NumComprob),'0')
                INTO cNumComprob
                FROM COMPROBANTES_CONTABLES
               WHERE CODCIA         = X.CodCia
                 AND NumTransaccion = X.IdTransaccion;

              BEGIN
                 SELECT FE.FOLIOFISCAL, FE.SERIE, FE.UUID, FE.FECHAUUID
                   INTO cFolioFiscal, cSerie, cUUID, cFechaUUID
                   FROM FACT_ELECT_DETALLE_TIMBRE FE
                  WHERE FE.IDNCR = X.IDNCR
                    AND FE.codproceso= 'PAG'
                    AND FE.codrespuestasat = '201'
                    AND FE.FOLIOFISCAL IN (

                 SELECT MAX(FE.FOLIOFISCAL)
                   FROM FACT_ELECT_DETALLE_TIMBRE FE
                  WHERE FE.IDNCR = X.IDNCR
                    AND FE.codproceso = 'PAG'
                    AND FE.codrespuestasat = '201');
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    cFolioFiscal := NULL;
                          cSerie       := NULL;
                          cUUID        := NULL;
                          cFechaUUID   := NULL;
              END;

              BEGIN
                 SELECT count(FE.IDNCR)
                   INTO cVariosUUID
                   FROM FACT_ELECT_DETALLE_TIMBRE FE
                  WHERE FE.IDNCR = X.IDNCR
                    AND FE.codproceso = 'PAG'
                    AND FE.codrespuestasat = '201'
                  GROUP BY FE.IDNCR;
                EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    cVariosUUID := NULL;
              END;

              cOrigenRecibo := 'PRIMAS';

                 cCadena := X.NumPolUnico                                  ||cLimitador||
                            TO_CHAR(X.IdPoliza,'9999999999999')            ||cLimitador||
                            X.NumPolRef                                    ||cLimitador||
                            X.IDETPOL                                      ||cLimitador||
                            X.Contratante                                  ||cLimitador||
                            TO_CHAR(X.IdEndoso,'9999999999999')            ||cLimitador||
                            'NCR'                                          ||cLimitador||
                            TO_CHAR(X.IdNcr,'9999999999990')               ||cLimitador||
                            cDescFormaPago                                 ||cLimitador||
                            X.FechaTransaccion                             ||cLimitador||
                            X.FecDevol                                     ||cLimitador||
                            cFecFin                                        ||cLimitador||
                            X.FechaTransaccion                             ||cLimitador||
                            TO_CHAR(nPrimaNeta,'99999999999990.00')        ||cLimitador||
                            TO_CHAR(nReducPrima,'99999999999990.00')       ||cLimitador||
                            TO_CHAR(nRecargos,'99999999999990.00')         ||cLimitador||
                            TO_CHAR(nDerechos,'99999999999990.00')         ||cLimitador||
                            TO_CHAR(nImpuesto,'99999999999990.00')         ||cLimitador||
                            TO_CHAR(nPrimaTotal,'99999999999990.00')       ||cLimitador||
                            TO_CHAR(W_MtoComisi_Moneda,'99999999999990.00')||cLimitador||
                            TO_CHAR(nComisionesPEF,'99999999999990.00')    ||cLimitador||
                            TO_CHAR(nComisionesPEM,'99999999999990.00')    ||cLimitador||
                            TO_CHAR(nHonorariosPEF,'99999999999990.00')    ||cLimitador||
                            TO_CHAR(nImpuestoHonoPF,'99999999999990.00')   ||cLimitador||
                            TO_CHAR(nHonorariosPEM,'99999999999990.00')    ||cLimitador||
                            TO_CHAR(nImpuestoHonoPM,'99999999999990.00')   ||cLimitador||
                            TO_CHAR(nOtrasCompPF,'99999999999990.00')      ||cLimitador||
                            TO_CHAR(nImpuestoHonoPFOC,'99999999999990.00') ||cLimitador||
                            TO_CHAR(nOtrasCompPM,'99999999999990.00')      ||cLimitador||
                            TO_CHAR(nImpuestoHonoPMOC,'99999999999990.00') ||cLimitador||
                            TO_CHAR(nDifComis,'99999999999990.00')         ||cLimitador||
                            TO_CHAR(nMtoComiAge,'99999999999990.00')       ||cLimitador||
                            TO_CHAR(nMtoHonoAge,'99999999999990.00')       ||cLimitador||
                            LPAD(cCodAge,6,'0')                            ||cLimitador||
                            cTipoAge                                       ||cLimitador||
                            TO_CHAR(nMtoComiProm,'99999999999990.00')      ||cLimitador||
                            TO_CHAR(nMtoHonoProm,'99999999999990.00')      ||cLimitador||
                            LPAD(cCodProm,6,'0')                           ||cLimitador||
                            cTipoProm                                      ||cLimitador||
                            TO_CHAR(nMtoComiDR,'99999999999990.00')        ||cLimitador||
                            TO_CHAR(nMtoHonoDR,'99999999999990.00')        ||cLimitador||
                            LPAD(cCodDR,6,'0')                             ||cLimitador||
                            cTipoDR                                        ||cLimitador||
                            TO_CHAR(nTasaIVA,'999990.00')                  ||cLimitador||
                            cDescEstado                                    ||cLimitador||
                            X.codmoneda                                    ||cLimitador||
                            TO_CHAR(X.TIPO_CAMBIO,'99999999999990.00')     ||cLimitador||
                            X.IdTipoSeg                                    ||cLimitador||
                            X.PlanCob                                      ||cLimitador||
                            X.CodTipoPlan                                  ||cLimitador||
                            X.DescSubRamo                                  ||cLimitador||
                            cTipoVigencia                                  ||cLimitador||
                            TO_CHAR(X.NumCuota,'99990')                    ||cLimitador||
                            X.FecIniVig                                    ||cLimitador||
                            X.FecFinVig                                    ||cLimitador||
                            TO_CHAR(X.NumRenov,'99990')                    ||cLimitador||
                            cNumComprob                                    ||cLimitador||
                            X.FolioFactElec                                ||cLimitador||
                            cFolioFiscal                                   ||cLimitador||
                            cSerie                                         ||cLimitador||
                            cUUID                                          ||cLimitador||
                            TO_CHAR(cFechaUUID,'DD/MM/YYYY')               ||cLimitador||
                            cVariosUUID                                    ||cLimitador||
                            cOrigenRecibo                                  ||cLimitador||
                            X.ESCONTRIBUTORIO                              ||cLimitador||
                            X.PORCENCONTRIBUTORIO                          ||cLimitador||
                            X.GIRONEGOCIO                                  ||cLimitador||
                            X.TIPONEGOCIO                                  ||cLimitador||
                            X.FUENTERECURSOS                               ||cLimitador||
                            X.CODPAQCOMERCIAL                              ||cLimitador||
                            X.CATEGORIA                                    ||cLimitador||
                            X.CANALFORMAVENTA                              ||cLimitador||
                            TO_CHAR(0,'99999999999990.00')                 ||cLimitador||
                            TO_CHAR(0,'99999999999990.00')                 ||cLimitador||
                            X.CodRamo                                      ||cLimitador||
                            X.DescRamo                                     ||CHR(13);
                --
                IF UPPER(cDestino) != 'REGISTRO' THEN
                    nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena, 1);
                ELSE
                    INSERTA_REGISTROS(cCodReporte, nLineaimp, 'REPAUTRECPAG', cNomArchivo, cCadena, W_ID_ENVIO);
                END IF;
                --
        END LOOP;
            --
        cNomArchZip := SUBSTR(cNomArchivo, 1, INSTR(cNomArchivo, '.')-1) || '.zip';
            --
        IF UPPER(cDestino) != 'REGISTRO' THEN
            IF XLSX_BUILDER_PKG.EXCEL_GUARDA_LIBRO THEN
               IF ZIP_UTIL_PKG.ZIP_ARCHIVOS(cNomDirectorio, cNomArchZip, cNomArchivo) THEN
                  dbms_output.put_line('OK');
               END IF;
               OC_REPORTES_THONA.COPIA_ARCHIVO_BLOB( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomArchZip, W_ID_ENVIO, 'N' );
            END IF;

            IF UPPER(cDestino) = 'CORREO' THEN
              ENVIA_MAIL('Recibos pagados',cNomDirectorio, cNomArchZip, W_ID_ENVIO, cBuzones);
            END IF;
        ELSE
              ENVIA_MAIL('Recibos pagados',NULL, NULL, W_ID_ENVIO, cBuzones);
        END IF;
        --
    END RECIBOS_PAGADOS_COB;
    --
    PROCEDURE EJECUTA_JOB (NOMBREJOB VARCHAR2, PROCEDURE_EXEC VARCHAR2, COMENTARIOS VARCHAR2) as
    BEGIN
      --dbms_output.put_line('Iniciando el Job');
      --dbms_output.put_line(PROCEDURE_EXEC);
      dbms_scheduler.create_job (
            job_name   =>  NOMBREJOB,
            job_type   => 'PLSQL_BLOCK',
            job_action => 'BEGIN ' || PROCEDURE_EXEC || ' END;',
            enabled   =>  TRUE,
            auto_drop =>  TRUE,
            comments  =>  COMENTARIOS);
       --
      --dbms_output.put_line('Fin del procedimiento');
    end EJECUTA_JOB;
    --
    PROCEDURE REVISA_JOBS (SALIDA IN OUT SYS_REFCURSOR) AS
    BEGIN

         OPEN SALIDA FOR SELECT NJOB, LOG_ID, LOG_DATE, JOB_NAME, STATUS, START_DATE, RUN_DURATION, ADDITIONAL_INFO
                            FROM (
                             select 1 NJOB,
                                    J.FLAGS LOG_ID,
                                    J.job_name,
                                    J.STATE STATUS,
                                    J.LAST_START_DATE START_DATE,
                                    SYSDATE - J.LAST_START_DATE RUN_DURATION,
                                    J.PROGRAM_NAME ADDITIONAL_INFO,
                                    J.LAST_START_DATE  log_date
                               from ALL_SCHEDULER_JOBS J
                              WHERE job_name like '%_COB'||TO_CHAR(SYSDATE, 'YYMMDD')
                            UNION ALL
                             SELECT 2 NJOB,
                                    LOG_ID,
                                    JOB_NAME,
                                    STATUS,
                                    REQ_START_DATE START_DATE,
                                    RUN_DURATION,
                                    ADDITIONAL_INFO,
                                    log_date
                               FROM all_scheduler_job_run_details
                              WHERE job_name like '%_COB'||TO_CHAR(SYSDATE, 'YYMMDD')
                                AND log_date > sysdate - 1/24
                            ) order by NJOB, log_date desc;
    END REVISA_JOBS;
    --
    FUNCTION DEVUELVE_CORREO_USUARIO RETURN VARCHAR2 IS
        CORREOS VARCHAR2(5000);
    BEGIN
        --
        SELECT GT_WEB_SERVICES.JOIN(cursor(
                        SELECT EMAIL
                        FROM SICAS_OC.USUARIOS U
                        WHERE upper(U.CODUSUARIO) = UPPER(CASE WHEN SYS_CONTEXT ('USERENV', 'SESSION_USER') = 'SICAS_OC' THEN
                                                        CASE WHEN SYS_CONTEXT ('USERENV', 'OS_USER') = 'Cleon' THEN
                                                             'cperez'
                                                        ELSE
                                                             SYS_CONTEXT ('USERENV', 'OS_USER')
                                                        END
                                                   ELSE
                                                        SYS_CONTEXT ('USERENV', 'SESSION_USER')
                                                   END))
                        , ';') EMAIL
                 INTO CORREOS
                 FROM Dual;
        RETURN CORREOS;
        --
    EXCEPTION WHEN OTHERS THEN
        RETURN NULL;
    END DEVUELVE_CORREO_USUARIO;
    --
END OC_REPOFACT;
/

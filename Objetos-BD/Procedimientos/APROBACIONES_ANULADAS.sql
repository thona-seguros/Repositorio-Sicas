create or replace PROCEDURE          APROBACIONES_ANULADAS  IS
------------------------
-- variables proceso --

nIdSiniestro       SINIESTRO.IdSiniestro%TYPE;
dFecRes            COBERTURA_SINIESTRO_ASEG.FecRes%TYPE;
nTipoCambio        TASAS_CAMBIO.Tasa_Cambio%TYPE;
cRFCHospital       DATOS_PART_SINIESTROS.Campo1%TYPE;
nMontoRvaMon       COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
nMontoRvaLoc       COBERTURA_SINIESTRO.Monto_Reservado_Local%TYPE;
cNumDocTributario  BENEF_SIN.Num_Doc_Tributario%TYPE;
cEntidadFinanc     BENEF_SIN_PAGOS.Entidad_Financiera%TYPE;
cCuentaCheque      BENEF_SIN_PAGOS.Nro_Cheque%TYPE;
nIVAPorcentaje     CATALOGO_DE_CONCEPTOS.PorcConcepto%TYPE;
cCodPlantilla      CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE := 'EMITESINIESTRO';
W_TRANSAC          TRANSACCION.IdTransaccion%TYPE;
cDescBanco         VARCHAR2(200);
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);
cNombreBenef       VARCHAR2(2000);
cLimitador         VARCHAR2(1) :='|';
nLinea             NUMBER;
cCadena            VARCHAR2(6000);
cCadenaAux         VARCHAR2(4000);
cCadenaAux1        VARCHAR2(4000);
cCodUser           VARCHAR2(30);
nDummy             NUMBER;
cCopy              BOOLEAN;
cQueryIVA          VARCHAR2(4000) := NULL;
cQueryISR          VARCHAR2(4000) := NULL;
cValorCampoIVA     VARCHAR2(4000) := NULL;
cValorCampoISR     VARCHAR2(4000) := NULL;
MuestrAlerta       NUMBER;
---
cNomArchCarga       VARCHAR2(100);
cNomArchLogem       VARCHAR2(100);
dFecCarga           DATE;
CFecCarga           VARCHAR2(10);
cUUID               FACTURA_EXTERNA.UUID%TYPE;
nIdProcMasivo       PROCESOS_MASIVOS_SEGUIMIENTO.IDPROCMASIVO%TYPE;
nMontoNetoLocal     NUMBER(28,2);
nMontoNetoMoneda   NUMBER(28,2);
nMontoHonoLocal     NUMBER(28,2);
nMontoHonoMoneda   NUMBER(28,2);
nMontoHospLocal     NUMBER(28,2);
nMontoHospMoneda   NUMBER(28,2);
nMontoOtrGtoLocal   NUMBER(28,2);
nMontoOtrGtoMoneda NUMBER(28,2);
nMontoDctoLocal     NUMBER(28,2);
nMontoDctoMoneda   NUMBER(28,2);
nMontoDeducLocal   NUMBER(28,2);
nMontoDeducMoneda   NUMBER(28,2);
--
cPolizaCont        VARCHAR2(50);

W_ID_TERMINAL   VARCHAR2(100);
W_ID_USER       VARCHAR2(100);
W_ID_ENVIO      VARCHAR2(100);

WIDSINIESTRO      APROBACIONES.IDSINIESTRO%TYPE;
WNUM_APROBACION   APROBACIONES.NUM_APROBACION%TYPE;
--
W_PAGO_NETO_MON_LOC NUMBER(28,2);
W_PAGO_NETO_MON_MON NUMBER(28,2);
NVO_MNTO_PAGADO_LOC NUMBER(28,2);
NVO_MNTO_PAGADO_MON NUMBER(28,2);
nIVA_RET_MONEDA     NUMBER(28,2);
nIVA_RET_LOCAL      NUMBER(28,2);
nImpLoc_Ret_Local   NUMBER(28,2);
nImpLoc_Ret_Moneda  NUMBER(28,2);

--

cTIPODIARIO         COMPROBANTES_CONTABLES.TIPODIARIO%TYPE;
nNUMCOMPROBSC       COMPROBANTES_CONTABLES.NUMCOMPROBSC%TYPE;

-----------------------
-- variables reporte --
cCtlArchivo     UTL_FILE.FILE_TYPE;
cNomDirectorio  VARCHAR2(100) ;
cNomArchivo VARCHAR2(100) := 'PAGOS_ANUL_'||to_char(trunc(sysdate - 1),'ddmmyyyy')||'.XLSX';

nLineaimp       NUMBER := 1;

cNomArchZip           VARCHAR2(100);
cIdTipoSeg            VARCHAR2(50) := '%';
cCodMoneda            SINIESTRO.COD_MONEDA%TYPE := '%';
cTipoPago             APROBACION_ASEG.TIPO_APROBACION%TYPE := 'ANU';
cUsuario              VARCHAR2(8) := '%';
nCodCia               NUMBER := 1;
nCodEmpresa           NUMBER := 1;
cCodReporte           VARCHAR2(100) := 'APROBACIONESANULADAS';
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
cSubject                    VARCHAR2(1000) := 'Notificacion Archivo de Aprobaciones Anuladas de Siniestros: ';
cTexto1                     VARCHAR2(10000):= 'Apreciable Compañero ';
cTexto2                     varchar2(1000)   := ' Envío archivo de Aprobaciones Anuladas de Siniestros generado de manera automática el día de hoy. ';
cTexto3                     varchar2(10)   := '  ';
cTexto4                     varchar2(1000)   := ' Saludos. ';
----

CURSOR PAGOSSIN_Q IS
  SELECT /*+ RULE +*/ UNIQUE(T.IdTransaccion),
         SI.IdPoliza,
         OC_POLIZAS.NUMERO_UNICO(SI.CodCia, SI.IdPoliza) PolUnik,
         SI.IdSiniestro,
         DAA.COD_PAGO,  --JICO
         TRUNC(T.FechaTransaccion) FechaMvto,
         TO_CHAR(TRUNC(T.FechaTransaccion),'DD/MM/YYYY') cFechaMvto,
         A.Num_Aprobacion,
         A.Tipo_Aprobacion,
         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', cTipoPago) Estatus,
         OC_DETALLE_APROBACION.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1) CodTransac,
         OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(SI.CodCia, OC_DETALLE_APROBACION.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)) DescTransac,
         OC_DETALLE_APROBACION.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1) CodCptoTransac,
         OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(SI.CodCia, OC_DETALLE_APROBACION.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)) DescripConcepto,
         T.IdTransaccion NumTrx,
         SI.Cod_Moneda,
         SUM(DAA.MONTO_LOCAL) Pgo_Mon_Orig,  --JICO
         SUM(DAA.MONTO_MONEDA) Pgo_Mon_Nac,  --JICO
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'GTOHON') Gto_Hon_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'GTOHON') Gto_Hon_Local,
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'GTOHOS') Gto_Hos_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'GTOHOS') Gto_Hos_Local,
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'GTOOTR') Gto_Otr_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'GTOOTR') Gto_Otr_Local,
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'DESCUE') Dcto_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'DESCUE') Dcto_Local,
         DECODE(OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUBA'),0,
                OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUAD'),
                OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUBA')) Deduc_Moneda,
         DECODE(OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUBA'),0,
                OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUAD'),
                OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUBA')) Deduc_Local,
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'IVASIN') IVA_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'IVASIN') IVA_Local,
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'ISRSIN') ISR_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'ISRSIN') ISR_Local,
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'RETIVA') IVA_Ret_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'RETIVA') IVA_Ret_Local,
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'RETISR') ISR_Ret_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'RETISR') ISR_Ret_Local,
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'IMPLOC') ImpLoc_Ret_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'IMPLOC') ImpLoc_Ret_Local,
         SUM(DAA.Monto_Moneda) Pgo_Neto_Mon_Orig,  --JICO
         SUM(DAA.Monto_Local) Pago_Neto_Mon_Loc,  --JICO
         NVL(SI.Monto_Reserva_Moneda,0) - NVL(SI.Monto_Pago_Moneda,0) OPC_Moneda,
         NVL(SI.Monto_Reserva_Local,0) - NVL(SI.Monto_Pago_Local,0) OPC_Local,
         T.UsuarioGenero Usuario,
         DS.IdTipoSeg TipoSeguro,
         DS.IdDetSin,
         0 Asegurado,
         SI.NumSiniRef,
         A.Benef,
         SI.CodCia,
         SI.CodEmpresa,
         NULL FecCarga,
         NULL NomArchCarga,
         NULL MontoIVA,
         NULL MontoISR,
         NULL Numero_Factura,
         NULL Archivo_Logem,
         NULL IdProcMasivo,
         NULL PolConta_GG,
         NULL Fecha_Pago,
         NULL Import_Pago,
         NULL Archivo_GG,
         NULL PgoGG_Usuario,
         NULL PgoGG_FechaComp,
         NULL Observacion_GG,
         SUM(DAA.Monto_Moneda) WMonto, --JICO
         --
         DECODE(NVL(PP.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
         NVL(PP.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
         UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
         DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',PP.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',PP.CODTIPONEGOCIO)) TIPONEGOCIO,
         DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',PP.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',PP.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
         PP.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
         CGO.DESCCATEGO                                            CATEGORIA,
         DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',PP.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',PP.FORMAVENTA)) CANALFORMAVENTA,
         --
         DAA.IDDETAPROB
    FROM TRANSACCION T,
         DETALLE_TRANSACCION D,
         APROBACIONES A,
         SINIESTRO SI,
         DETALLE_SINIESTRO DS,
         POLIZAS_TEXTO_COTIZACION  TXT,
         CATEGORIAS                CGO,
         POLIZAS                   PP,
         DETALLE_APROBACION        DAA   --JICO AGREGADO
   WHERE T.CodCia                  = nCodCia
     AND T.CodEmpresa              = nCodEmpresa
     AND T.IdTransaccion           > 0
     AND TRUNC(T.FechaTransaccion) BETWEEN dFecDesde
                                   AND     dFecHasta
     AND T.IdProceso               = 6
     AND T.UsuarioGenero          = DECODE(cUsuario,'%',T.UsuarioGenero, cUsuario)  --JICO RECOLOCAR
     --
     AND D.Valor2                  IS NOT NULL
     AND D.IdTransaccion           =  T.IdTransaccion
     AND D.Correlativo             = 1
     AND D.OBJETO                 IN ('APROBACIONES')
     AND D.CodSubProceso          IN ('APRSIN','ANUAPR','ANUDEU','REVANU')
     AND DECODE(cTipoPago,'PAG',A.IdTransaccion, A.IdTransaccionAnul) = D.IdTransaccion
     AND A.IdSiniestro             = D.Valor1
     AND A.IdPoliza                = D.Valor2
     AND A.IdDetSin                = D.Valor3
     AND A.StsAprobacion          IN ('PAG','ANU')
     AND A.Num_Aprobacion          > 0
     AND SI.IdSiniestro            = A.IdSiniestro
     AND DS.IdSiniestro            = SI.IdSiniestro
     AND DS.IdDetSin               = A.IdDetSin
     --
     AND PP.IDPOLIZA               = SI.IDPOLIZA
     --
     AND TXT.CODCIA(+)              = PP.CODCIA
     AND TXT.CODEMPRESA(+)          = PP.CODEMPRESA
     AND TXT.IDPOLIZA(+)            = PP.IDPOLIZA
     --
     AND CGO.CODCIA(+)              = PP.CODCIA
     AND CGO.CODEMPRESA(+)          = PP.CODEMPRESA
     AND CGO.CODTIPONEGOCIO(+)      = PP.CODTIPONEGOCIO
     AND CGO.CODCATEGO(+)           = PP.CODCATEGO
     --  JICO AGREGAD0
     AND DAA.IDSINIESTRO    = A.IdSiniestro     --JICO
     AND DAA.NUM_APROBACION = A.NUM_APROBACION  --JICO
     AND DAA.COD_PAGO       NOT IN ('DEDUC','IMPTO','RETENC') --JICO
  GROUP BY
         SI.IdPoliza,
         OC_POLIZAS.NUMERO_UNICO(SI.CodCia, SI.IdPoliza),-- PolUnik,
         SI.IdSiniestro,
         DAA.COD_PAGO,
         TRUNC(T.FechaTransaccion),-- FechaMvto,
         TO_CHAR(TRUNC(T.FechaTransaccion),'DD/MM/YYYY'),-- cFechaMvto,
         A.Num_Aprobacion,
         A.Tipo_Aprobacion,
         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', cTipoPago),-- Estatus, --JICO
         OC_DETALLE_APROBACION.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1),-- CodTransac,
         OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(SI.CodCia, OC_DETALLE_APROBACION.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)),-- DescTransac,
         OC_DETALLE_APROBACION.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1),-- CodCptoTransac,
         OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(SI.CodCia, OC_DETALLE_APROBACION.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)),-- DescripConcepto,
         T.IdTransaccion,-- NumTrx,
         SI.Cod_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'GTOHON'),-- Gto_Hon_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'GTOHON'),-- Gto_Hon_Local,
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'GTOHOS'),--Gto_Hos_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'GTOHOS'),-- Gto_Hos_Local,
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'GTOOTR'),-- Gto_Otr_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'GTOOTR'),-- Gto_Otr_Local,
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'DESCUE'),-- Dcto_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'DESCUE'),-- Dcto_Local,
         DECODE(OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUBA'),0,
                OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUAD'),
                OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUBA')),-- Deduc_Moneda,
         DECODE(OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUBA'),0,
                OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUAD'),
                OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUBA')),-- Deduc_Local,
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'IVASIN'),-- IVA_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'IVASIN'),-- IVA_Local,
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'ISRSIN'),-- ISR_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'ISRSIN'),-- ISR_Local,
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'RETIVA'),-- IVA_Ret_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'RETIVA'),-- IVA_Ret_Local,
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'RETISR'),-- ISR_Ret_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'RETISR'),-- ISR_Ret_Local,
         OC_DETALLE_APROBACION.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'IMPLOC'),-- ImpLoc_Ret_Moneda,
         OC_DETALLE_APROBACION.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'IMPLOC'),-- ImpLoc_Ret_Local,
         NVL(SI.Monto_Reserva_Moneda,0) - NVL(SI.Monto_Pago_Moneda,0),-- OPC_Moneda,
         NVL(SI.Monto_Reserva_Local,0) - NVL(SI.Monto_Pago_Local,0),-- OPC_Local,
         T.UsuarioGenero,-- Usuario,
         DS.IdTipoSeg ,--TipoSeguro,
         DS.IdDetSin,
         0 ,--Asegurado,
         SI.NumSiniRef,
         A.Benef,
         SI.CodCia,
         SI.CodEmpresa,
         NULL,-- FecCarga,
         NULL,-- NomArchCarga,
         NULL,-- MontoIVA,
         NULL,-- MontoISR,
         NULL,-- Numero_Factura,
         NULL,-- Archivo_Logem,
         NULL,-- IdProcMasivo,
         NULL,-- PolConta_GG,
         NULL,-- Fecha_Pago,
         NULL,-- Import_Pago,
         NULL,-- Archivo_GG,
         NULL ,--PgoGG_Usuario,
         NULL,-- PgoGG_FechaComp,
         NULL,-- Observacion_GG,
         --
         DECODE(NVL(PP.PORCENCONTRIBUTORIO,0),0,'N','S'),--            ESCONTRIBUTORIO,
         NVL(PP.PORCENCONTRIBUTORIO,0),--                              PORCENCONTRIBUTORIO,
         UPPER(TXT.DESCGIRONEGOCIO),--                                GIRONEGOCIO,
         DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',PP.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',PP.CODTIPONEGOCIO)),-- TIPONEGOCIO,
         DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',PP.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',PP.FUENTERECURSOSPRIMA)),-- FUENTERECURSOS,
         PP.CODPAQCOMERCIAL,--                                         CODPAQCOMERCIAL,
         CGO.DESCCATEGO,--                                            CATEGORIA,
         DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',PP.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',PP.FORMAVENTA)),-- CANALFORMAVENTA
         DAA.IDDETAPROB
--
UNION
--

  SELECT /*+ RULE +*/
         T.IdTransaccion,
         SI.IdPoliza,
         OC_POLIZAS.NUMERO_UNICO(SI.CodCia, SI.IdPoliza) PolUnik,
         SI.IdSiniestro,
         DAA.COD_PAGO,   --JICO
         TRUNC(T.FechaTransaccion) FechaMvto,
         TO_CHAR(TRUNC(T.FechaTransaccion),'DD/MM/YYYY') cFechaMvto,
         A.Num_Aprobacion,
         A.Tipo_Aprobacion,
         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', cTipoPago) Estatus,
         OC_DETALLE_APROBACION_ASEG.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1) CodTransac,
         OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(SI.CodCia, OC_DETALLE_APROBACION_ASEG.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)) DescTransac,
         OC_DETALLE_APROBACION_ASEG.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1) CodCptoTransac,
         OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(SI.CodCia, OC_DETALLE_APROBACION_ASEG.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)) DescripConcepto,
         T.IdTransaccion NumTrx,
         SI.Cod_Moneda,
         SUM(DAA.MONTO_LOCAL) Pgo_Mon_Orig,  --JICO
         SUM(DAA.MONTO_MONEDA) Pgo_Mon_Nac,  --JICO
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'GTOHON') Gto_Hon_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'GTOHON') Gto_Hon_Local,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'GTOHOS') Gto_Hos_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'GTOHOS') Gto_Hos_Local,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'GTOOTR') Gto_Otr_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'GTOOTR') Gto_Otr_Local,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'DESCUE') Dcto_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'DESCUE') Dcto_Local,
         DECODE(OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUBA'),0,
                OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUAD'),
                OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUBA')) Deduc_Moneda,
         DECODE(OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUBA'),0,
                OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUAD'),
                OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUBA')) Deduc_Local,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'IVASIN') IVA_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'IVASIN') IVA_Local,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'ISRSIN') ISR_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'ISRSIN') ISR_Local,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'RETIVA') IVA_Ret_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'RETIVA') IVA_Ret_Local,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'RETISR') ISR_Ret_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'RETISR') ISR_Ret_Local,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'IMPLOC') ImpLoc_Ret_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'IMPLOC') ImpLoc_Ret_Local,
         SUM(DAA.Monto_Moneda) Pgo_Neto_Mon_Orig,  --JICO
          SUM(DAA.Monto_Local) Pago_Neto_Mon_Loc,  --JICO
          NVL(SI.Monto_Reserva_Moneda,0) - NVL(SI.Monto_Pago_Moneda,0) OPC_Moneda,
          NVL(SI.Monto_Reserva_Local,0) - NVL(SI.Monto_Pago_Local,0) OPC_Local,
          T.UsuarioGenero Usuario,
          DS.IdTipoSeg TipoSeguro,
          DS.IdDetSin,
          0 Asegurado,
          SI.NumSiniRef,
          A.Benef,
          SI.CodCia,
          SI.CodEmpresa,
          --TO_CHAR(PMS.Crga_FechaComp,'DD/MM/YYYY HH24:MI:SS') FecCarga,
          TO_CHAR(PMS.Crga_FechaComp,'DD/MM/YYYY') FecCarga,
          PMS.CRGA_NOM_ARCHIVO NomArchCarga,
          PMS.MontoIva MontoIva,
          PMS.MontoISR MontoISR,
          PMS.NumFactura Numero_Factura,
          PMS.Archivo_LOGEM Archivo_LOGEM,
          PMS.IdProcMasivo IdProcMasivo,
          PMS.PolConta_GG PolConta_GG,
          TO_CHAR(PMS.Fecha_Pago,'DD/MM/YYYY') Fecha_Pago,
          PMS.Import_Pago Import_Pago,
          PMS.Archivo_GG Archivo_GG,
          PMS.PgoGG_Usuario PgoGG_Usuario,
          TO_CHAR(PMS.PgoGG_FechaComp,'DD/MM/YYYY HH24:MI:SS') PgoGG_FechaComp,
          PMS.Observacion_GG  Observacion_GG,
          SUM(DAA.Monto_Moneda) WMonto,  --  JICO AGREGAD0
         --
          DECODE(NVL(PP.PORCENCONTRIBUTORIO,0),0,'N','S')            ESCONTRIBUTORIO,
          NVL(PP.PORCENCONTRIBUTORIO,0)                              PORCENCONTRIBUTORIO,
          UPPER(TXT.DESCGIRONEGOCIO)                                GIRONEGOCIO,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',PP.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',PP.CODTIPONEGOCIO)) TIPONEGOCIO,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',PP.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',PP.FUENTERECURSOSPRIMA)) FUENTERECURSOS,
          PP.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
          CGO.DESCCATEGO                                            CATEGORIA,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',PP.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',PP.FORMAVENTA)) CANALFORMAVENTA,
          --
          DAA.IDDETAPROB
     FROM TRANSACCION T,
          DETALLE_TRANSACCION D,
          APROBACION_ASEG A,
          SINIESTRO SI,
          DETALLE_SINIESTRO_ASEG DS,
          PROCESOS_MASIVOS_SEGUIMIENTO PMS,
          POLIZAS_TEXTO_COTIZACION  TXT,
          CATEGORIAS                CGO,
          POLIZAS                   PP,
          DETALLE_APROBACION_ASEG   DAA  --JICO AGREGADO
    WHERE T.CodCia                  = nCodCia
      AND T.CodEmpresa              = nCodEmpresa
      AND T.IdTransaccion           > 0
      AND TRUNC(T.FechaTransaccion) BETWEEN dFecDesde
                                    AND     dFecHasta
      AND T.IdProceso               = 6
      AND T.UsuarioGenero          = DECODE(cUsuario,'%',T.UsuarioGenero, cUsuario)
     --
      AND D.Valor2                  IS NOT NULL
      AND D.IdTransaccion           =  T.IdTransaccion
      AND D.Correlativo             = 1
      AND D.OBJETO                  IN ('APROBACION_ASEG')
      AND D.CodSubProceso           IN ('APRSIN','ANUAPR','ANUDEU','REVANU')
      AND DECODE(cTipoPago,'PAG',A.IdTransaccion,a.IdTransaccionAnul) = d.IdTransaccion
      AND A.IdSiniestro             = D.Valor1
      AND A.IdPoliza                = D.Valor2
      AND A.IdDetSin                = D.Valor3
      AND A.StsAprobacion          IN ('PAG','ANU')
      AND A.Num_Aprobacion          > 0
      AND SI.IdSiniestro            = A.IdSiniestro
      AND DS.IdSiniestro            = SI.IdSiniestro
      AND DS.IdDetSin               = A.IdDetSin
      AND DS.Cod_Asegurado          = SI.Cod_Asegurado
      AND PMS.CodCia           (+) = nCodCia
      AND PMS.CodEmpresa       (+) = nCodEmpresa
      AND PMS.IdPoliza         (+) = A.IdPoliza
      AND PMS.Num_Aprobacion   (+) = A.Num_Aprobacion
      AND PMS.IdSiniestro      (+) = A.IdSiniestro
      AND PMS.Cod_Asegurado    (+) = A.Cod_Asegurado
      AND PMS.IdTransaccion    (+) = A.IdTransaccion
      AND PMS.Emi_TipoProceso  (+) = 'PAGSIN'
      --
      AND PP.IDPOLIZA               = SI.IDPOLIZA
      --
      AND TXT.CODCIA(+)              = PP.CODCIA
      AND TXT.CODEMPRESA(+)          = PP.CODEMPRESA
      AND TXT.IDPOLIZA(+)            = PP.IDPOLIZA
      --
      AND CGO.CODCIA(+)              = PP.CODCIA
      AND CGO.CODEMPRESA(+)          = PP.CODEMPRESA
      AND CGO.CODTIPONEGOCIO(+)      = PP.CODTIPONEGOCIO
      AND CGO.CODCATEGO(+)           = PP.CODCATEGO
      --  JICO AGREGAD0
      AND DAA.IDSINIESTRO    = A.IdSiniestro
      AND DAA.NUM_APROBACION = A.NUM_APROBACION
      AND DAA.COD_PAGO       NOT IN ('DEDUC','IMPTO','RETENC')
     GROUP BY   --  JICO AGREGAD0
         T.IdTransaccion,
         SI.IdPoliza,
         OC_POLIZAS.NUMERO_UNICO(SI.CodCia, SI.IdPoliza),-- PolUnik,
         SI.IdSiniestro,
         DAA.COD_PAGO,
         TRUNC(T.FechaTransaccion),-- FechaMvto,
         TO_CHAR(TRUNC(T.FechaTransaccion),'DD/MM/YYYY'),-- cFechaMvto,
         A.Num_Aprobacion,
         A.Tipo_Aprobacion,
         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', cTipoPago),-- Estatus,
         OC_DETALLE_APROBACION_ASEG.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1),-- CodTransac,
         OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(SI.CodCia, OC_DETALLE_APROBACION_ASEG.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)),-- DescTransac,
         OC_DETALLE_APROBACION_ASEG.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1),-- CodCptoTransac,
         OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(SI.CodCia, OC_DETALLE_APROBACION_ASEG.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)),-- DescripConcepto,
         T.IdTransaccion,-- NumTrx,
         SI.Cod_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'GTOHON'),-- Gto_Hon_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'GTOHON'),-- Gto_Hon_Local,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'GTOHOS'),-- Gto_Hos_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'GTOHOS'),-- Gto_Hos_Local,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'GTOOTR'),-- Gto_Otr_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'GTOOTR'),-- Gto_Otr_Local,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'DESCUE'),-- Dcto_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'DESCUE'),-- Dcto_Local,
         DECODE(OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUBA'),0,
                OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUAD'),
                OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUBA')),-- Deduc_Moneda,
         DECODE(OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUBA'),0,
                OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUAD'),
                OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'DEDUBA')),-- Deduc_Local,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'IVASIN'),-- IVA_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'IVASIN'),-- IVA_Local,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'ISRSIN'),-- ISR_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'ISRSIN'),-- ISR_Local,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'RETIVA'),-- IVA_Ret_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'RETIVA'),-- IVA_Ret_Local,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'RETISR'),-- ISR_Ret_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'RETISR'),-- ISR_Ret_Local,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_MONEDA(SI.IdSiniestro, A.Num_Aprobacion, 'IMPLOC'),-- ImpLoc_Ret_Moneda,
         OC_DETALLE_APROBACION_ASEG.MONTO_DETALLE_LOCAL(SI.IdSiniestro, A.Num_Aprobacion, 'IMPLOC'),-- ImpLoc_Ret_Local,
          NVL(SI.Monto_Reserva_Moneda,0) - NVL(SI.Monto_Pago_Moneda,0),-- OPC_Moneda,
          NVL(SI.Monto_Reserva_Local,0) - NVL(SI.Monto_Pago_Local,0),-- OPC_Local,
          T.UsuarioGenero,-- Usuario,
          DS.IdTipoSeg,-- TipoSeguro,
          DS.IdDetSin,
          0 ,--Asegurado,
          SI.NumSiniRef,
          A.Benef,
          SI.CodCia,
          SI.CodEmpresa,
          --TO_CHAR(PMS.Crga_FechaComp,'DD/MM/YYYY HH24:MI:SS'),-- FecCarga,
          TO_CHAR(PMS.Crga_FechaComp,'DD/MM/YYYY'),-- FecCarga,
          PMS.CRGA_NOM_ARCHIVO,-- NomArchCarga,
          PMS.MontoIva,--MontoIva,
          PMS.MontoISR,--MontoISR,
          PMS.NumFactura,-- Numero_Factura,
          PMS.Archivo_LOGEM,-- Archivo_LOGEM,
          PMS.IdProcMasivo,-- IdProcMasivo,
          PMS.PolConta_GG,-- PolConta_GG,
          TO_CHAR(PMS.Fecha_Pago,'DD/MM/YYYY'),-- Fecha_Pago,
          PMS.Import_Pago,-- Import_Pago,
          PMS.Archivo_GG,-- Archivo_GG,
          PMS.PgoGG_Usuario,-- PgoGG_Usuario,
          TO_CHAR(PMS.PgoGG_FechaComp,'DD/MM/YYYY HH24:MI:SS'),-- PgoGG_FechaComp,
          PMS.Observacion_GG,--  Observacion_GG,
         --
          DECODE(NVL(PP.PORCENCONTRIBUTORIO,0),0,'N','S'),--            ESCONTRIBUTORIO,
          NVL(PP.PORCENCONTRIBUTORIO,0),--                              PORCENCONTRIBUTORIO,
          UPPER(TXT.DESCGIRONEGOCIO),--                                GIRONEGOCIO,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',PP.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',PP.CODTIPONEGOCIO)),-- TIPONEGOCIO,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',PP.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',PP.FUENTERECURSOSPRIMA)),-- FUENTERECURSOS,
          PP.CODPAQCOMERCIAL,--                                         CODPAQCOMERCIAL,
          CGO.DESCCATEGO,--                                            CATEGORIA,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',PP.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',PP.FORMAVENTA)),-- CANALFORMAVENTA
          --
          DAA.IDDETAPROB
     ORDER BY 6, 4, 8, 7, 74  --  JICO AGREGAD0
;

CURSOR PAGO_Q  IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.CodCia       = nCodCia
      AND C.NomTabla     = 'DATOS_PART_SINIESTROS'
      AND C.IndDatoPart  = 'S'
    ORDER BY OrdenDatoPart,OrdenCampo;

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
         SICAS_OC.OC_REPORTES_THONA.INSERTAR_REGISTRO( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cEncabez );
      ELSE
         --Obtiene Número de Columnas Totales
         nColsTotales := XLSX_BUILDER_PKG.EXCEL_CUENTA_COLUMNAS(cEncabez);
         --
         DBMS_OUTPUT.put_line('MLJS EN INSERTA ENCABEZADO nColsTotales '||nColsTotales);
         IF XLSX_BUILDER_PKG.EXCEL_CREAR_LIBRO(cNomDirectorio, cNomArchivo) THEN
            DBMS_OUTPUT.put_line('MLJS EN INSERTA ENCABEZADO 1');
            IF XLSX_BUILDER_PKG.EXCEL_CREAR_HOJA(cCodReporte) THEN
               --Titulos
               DBMS_OUTPUT.put_line('MLJS EN INSERTA ENCABEZADO 2');
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

   --CEMAIL1 := 'ljimenez@thonaseguros.mx';
   --CEMAIL2 := null;
   --CEMAIL3 := null;

   cEmail       := OC_GENERALES.BUSCA_PARAMETRO(1,'021');
   cPwdEmail    := OC_GENERALES.BUSCA_PARAMETRO(1,'022');

   cTextoEnv := cHTMLHeader||cTexto1||cSaltoLinea||cSaltoLinea||cTexto2||cSaltoLinea||cSaltoLinea||
                      cTexto4||cSaltoLinea||cHTMLFooter;

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
       VALUES(1,1,cCodReporte,trunc(sysdate),nLineaimp,'REPAUTPAGSIN',cNomArchivo,cCadena);
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
   VALUES('APROBACIONESANULADAS',SYSDATE,W_ID_ENVIO,W_ID_USER,W_ID_TERMINAL);
   --
   COMMIT;
   --

   cNomDirectorio := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SO_PATH', 'REPORT');

----
   SELECT TRUNC(SYSDATE - 1) FIRST, TRUNC(SYSDATE - 1) LAST
   INTO DFECDESDE, DFECHASTA
   FROM  DUAL ;

   --DFECDESDE := TO_DATE('30/07/2021','DD/MM/RRRR');
  -- DFECHASTA := TO_DATE('30/07/2021','DD/MM/RRRR');


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
--      nLinea := nLinea + 1;

   cTitulo1 := cNomCia;
   cTitulo2 := 'REPORTE DIARIO DE PAGOS' ;
   cTitulo3 := 'PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' AL ' || TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecDesde,'Month') ||
                 ' DE ' || TO_CHAR(dFecDesde,'YYYY');
   cTitulo4 := ' ';
   cEncabez    := 'NUMERO POLIZA' ||cLimitador||
                  'NO. POLIZA UNICO' ||cLimitador||
                  'NÚMERO DE REFERENCIA' ||cLimitador||
                  'NO. SINIESTRO' ||cLimitador||
                  'COBERTURA' ||cLimitador||
                  'FECHA MOVIMIENTO' ||cLimitador||
                  'NO. APROB.' ||cLimitador||
                  'TIPO APROBACION' ||cLimitador||
                  'ESTATUS' ||cLimitador||
                  'TRANSACCION' ||cLimitador||
                  'DESCRIPCION TRANSACCION' ||cLimitador||
                  'CONCEPTO' ||cLimitador||
                  'NUMERO DE TRANSACCION' ||cLimitador||
                  'FECHA ESTIMACION' ||cLimitador||
                  'MONEDA' ||cLimitador||
                  'TIPO DE CAMBIO' ||cLimitador||
                  'PAGO MON ORIGINAL' ||cLimitador||
                  'PAGO MON NACIONAL' ||cLimitador||
                  'GASTOS HONORARIOS ORIGINAL' ||cLimitador||
                  'GASTOS HONORARIOS NACIONAL' ||cLimitador||
                  'GASTOS HOSPITALARIOS ORIGINAL' ||cLimitador||
                  'GASTOS HOSPITALARIOS NACIONAL' ||cLimitador||
                  'OTROS GASTOS ORIGINAL' ||cLimitador||
                  'OTROS GASTOS NACIONAL' ||cLimitador||
                  'DESCUENTO ORIGINAL' ||cLimitador||
                  'DESCUENTO NACIONAL' ||cLimitador||
                  'DEDUCIBLE ORIGINAL' ||cLimitador||
                  'DEDUCIBLE NACIONAL' ||cLimitador||
                  'IVA MON ORIGINAL' ||cLimitador||
                  'IVA MON NACIONAL' ||cLimitador||
                  'ISR RET MON ORIGINAL' ||cLimitador||
                  'ISR RET MON NACIONAL' ||cLimitador||
                  'IVA RET MON ORIGINAL' ||cLimitador||
                  'IVA RET MON NACIONAL' ||cLimitador||
                  'IMP LOCAL RET ORIGINAL' ||cLimitador||
                  'IMP LOCAL RET NACIONAL' ||cLimitador||
                  'PAGO NETO MON ORIGINAL' ||cLimitador||
                  'PAGO NETO MON NACIONAL' ||cLimitador||
                  'OPC MON ORIGINAL' ||cLimitador||
                  'OPC MON NACIONAL' ||cLimitador||
                  'BANCO' ||cLimitador||
                  'NUM CHEQUE O CUENTA CLABE' ||cLimitador||
                  'OPERO' ||cLimitador||
                  'TASA IVA' ||cLimitador||
                  'COD ASEGURADO' ||cLimitador||
                  'BENEFICIARIO' ||cLimitador||
                  'RFC BENEFICIARIO' ||cLimitador||
                  'NOMBRE_ARCH_CARGA' ||cLimitador||
                  'NOMBRE ARCHIVO LOGEM' ||cLimitador||
                  'FECHA DE CARGA' ||cLimitador||
                  'TIPO DE SEGURO' ||cLimitador||
                  'NUMERO DE FACTURA' ||cLimitador||
                  'ID CARGA MASIVA' ||cLimitador||
                  'POLIZA CONTABLE PGO GG' ||cLimitador||
                  'FECHA DE PAGO GG' ||cLimitador||
                  'IMPORTE DEL PAGO' ||cLimitador||
                  'ARCHIVO PGO-GG' ||cLimitador||
                  'USUARIO CARGA PGO-GG' ||cLimitador||
                  'FECHA - HORA DE CARGA' ||cLimitador||
                  'OBSERVACIONES POLIZA GG' ||cLimitador||
                  'MONTO DE PAGO' ||cLimitador||
                  'Es Contributorio 1' ||cLimitador||
                  '% Contributorio' ||cLimitador||
                  'Giro de Negocio' ||cLimitador||
                  'Tipo de Negocio' ||cLimitador||
                  'Fuente de Recursos' ||cLimitador||
                  'Paquete Comercial' ||cLimitador||
                  'Categoria' ||cLimitador||
                  'Canal de Venta' ||cLimitador||
                  'POLIZA_CONT';

   --dbms_output.put_line('MLJS 1 '||'  cCodReporte  '||cCodReporte||' cCodUser  '||cCodUser||'  cNomDirectorio  '||cNomDirectorio||' cNomArchivo  '||cNomArchivo  );
   --dbms_output.put_line('MLJS 2 cEncabez'||cEncabez);

   --INSERTA_REGISTROS;
   INSERTA_ENCABEZADO( 'EXCEL', nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo ) ;

   --dbms_output.put_line('MLJS 3 cNomDirectorio '||cNomDirectorio||' cNomArchivo  '||cNomArchivo );
         --
   nLinea := 6;

   WIDSINIESTRO         := 0; --  JICO AGREGAD0
   WNUM_APROBACION      := 0; --  JICO AGREGAD0
   W_PAGO_NETO_MON_LOC  := 0; --  JICO AGREGAD0
   W_PAGO_NETO_MON_MON  := 0; --  JICO AGREGAD0
   --CARGA DE INFORMACIÓN
   FOR X IN PAGOSSIN_Q LOOP
      nIdSiniestro := X.IdSiniestro;
      IF X.Asegurado > 0 THEN
         BEGIN
            SELECT MIN(FecRes)
              INTO dFecRes
              FROM COBERTURA_SINIESTRO_ASEG
             WHERE IdPoliza      = X.IdPoliza
               AND IdSiniestro   = X.IdSiniestro
               AND IdDetSin      = X.IdDetSin
               AND CodCobert     = X.Cod_Pago
               AND Cod_Asegurado = X.Asegurado;
         EXCEPTION
            WHEN OTHERS THEN
               dFecRes := NULL;
         END;
      ELSE
         BEGIN
            SELECT MIN(FecRes)
              INTO dFecRes
              FROM COBERTURA_SINIESTRO
             WHERE IdPoliza    = X.IdPoliza
               AND IdSiniestro = X.IdSiniestro
               AND IdDetSin    = X.IdDetSin
               AND CodCobert   = X.Cod_Pago;
         EXCEPTION
            WHEN OTHERS THEN
               dFecRes := NULL;
         END;
      END IF;
      --
      BEGIN
         SELECT Tasa_Cambio
           INTO nTipoCambio
           FROM TASAS_CAMBIO
          WHERE Fecha_Hora_Cambio = X.FechaMvto
            AND Cod_Moneda        = X.Cod_Moneda;
      EXCEPTION
         WHEN OTHERS THEN
            nTipoCambio := 0;
      END;
      --
      BEGIN
         SELECT TRIM(Nombre)||' '||TRIM(Apellido_Paterno)||' '||TRIM(Apellido_Materno) Nombre,
                Num_Doc_Tributario
           INTO cNombreBenef,
                cNumDocTributario
           FROM BENEF_SIN
          WHERE IdSiniestro = X.IdSiniestro
            AND IdPoliza    = X.IdPoliza
            AND Benef       = X.Benef;
      EXCEPTION
         WHEN OTHERS THEN
            cNombreBenef      := NULL;
            cNumDocTributario := NULL;
      END;
      --
      BEGIN
         SELECT Entidad_Financiera,
                DECODE(Tipo_de_Pago,'PGOCHQ',Nro_Cheque,'TRFBCO',Nro_Cta_Bancaria_CLABE,'ORDPGO',Nro_Orden_Pago,NULL)
           INTO cEntidadFinanc,
                cCuentaCheque
           FROM BENEF_SIN_PAGOS
          WHERE IdSiniestro    = X.IdSiniestro
            AND IdPoliza       = X.IdPoliza
            AND Benef          = X.Benef
            AND Num_Aprobacion = X.Num_Aprobacion;
      EXCEPTION
         WHEN OTHERS THEN
            cEntidadFinanc := NULL;
            cCuentaCheque  := NULL;
      END;
      --
      IF cEntidadFinanc IS NOT NULL THEN
         BEGIN
            SELECT PNJ.Nombre
              INTO cDescBanco
              FROM ENTIDAD_FINANCIERA EF,
                   PERSONA_NATURAL_JURIDICA PNJ
             WHERE EF.CodEntidad               = cEntidadFinanc
               AND PNJ.Num_Doc_Identificacion  = EF.Num_Doc_Identificacion
               AND PNJ.Tipo_Doc_Identificacion = EF.Tipo_Doc_Identificacion;
         EXCEPTION
             WHEN OTHERS THEN
                cDescBanco := NULL;
         END;
      ELSE
         cDescBanco := NULL;
      END IF;
      --
      cQueryIVA      := NULL;
      cQueryISR      := NULL;
      nCodCia        := X.CodCia;
      nCodEmpresa    := X.CodEmpresa;
      cValorCampoIVA := 0;
      cValorCampoISR := 0;
      --
      IF X.TIPOSEGURO = 'FONACO' THEN
         cValorCampoIVA := 0;
         cValorCampoISR := 0;
      ELSE
         cValorCampoIVA := X.IVA_MONEDA;
         cValorCampoISR := X.ISR_MONEDA;
      END IF;
      --
      BEGIN
        SELECT NVL(PorcConcepto,0) / 100
          INTO nIVAPorcentaje
          FROM CATALOGO_DE_CONCEPTOS
         WHERE CodConcepto = 'IVASIN';
      END;
      --
      IF X.ESTATUS = 'ANULADA' THEN
         --
         NVO_MNTO_PAGADO_LOC := X.PGO_MON_ORIG      * - 1;
         NVO_MNTO_PAGADO_MON := X.PGO_MON_NAC        * - 1;
         cValorCampoIVA      := X.IVA_MONEDA         * - 1;
         cValorCampoISR      := X.ISR_MONEDA         * - 1;
         nMontoNetoLocal     := X.PAGO_NETO_MON_LOC * - 1;
         nMontoNetoMoneda    := X.PGO_NETO_MON_ORIG * - 1;
         nMontoHonoLocal     := X.Gto_Hon_Local     * - 1;
         nMontoHonoMoneda    := X.Gto_Hon_Moneda     * - 1;
         nMontoHospLocal     := X.Gto_Hos_Local     * - 1;
         nMontoHospMoneda    := X.Gto_Hos_Moneda    * - 1;
         nMontoOtrGtoLocal   := X.Gto_Otr_Local     * - 1;
         nMontoOtrGtoMoneda  := X.Gto_Otr_Moneda     * - 1;
         nMontoDctoLocal     := X.Dcto_Local        * - 1;
         nMontoDctoMoneda    := X.Dcto_Moneda        * - 1;
         nMontoDeducLocal    := X.Deduc_Local        * - 1;
         nMontoDeducMoneda   := X.Deduc_Moneda      * - 1;
         nIVA_RET_MONEDA     := X.IVA_RET_MONEDA    * - 1;
         nIVA_RET_LOCAL      := X.IVA_RET_LOCAL      * - 1;
         nImpLoc_Ret_Local   := X.ImpLoc_Ret_Local  * - 1;
         nImpLoc_Ret_Moneda  := X.ImpLoc_Ret_Moneda * - 1;
      ELSE
         NVO_MNTO_PAGADO_LOC := X.PGO_MON_ORIG;
         NVO_MNTO_PAGADO_MON := X.PGO_MON_NAC;
         cValorCampoIVA      := X.IVA_MONEDA;
         cValorCampoISR      := X.ISR_MONEDA;
         nMontoNetoLocal     := X.PAGO_NETO_MON_LOC;
         nMontoNetoMoneda    := X.PGO_NETO_MON_ORIG;
         nMontoHonoLocal     := X.Gto_Hon_Local;
         nMontoHonoMoneda    := X.Gto_Hon_Moneda;
         nMontoHospLocal     := X.Gto_Hos_Local;
         nMontoHospMoneda    := X.Gto_Hos_Moneda;
         nMontoOtrGtoLocal   := X.Gto_Otr_Local;
         nMontoOtrGtoMoneda  := X.Gto_Otr_Moneda;
         nMontoDctoLocal     := X.Dcto_Local;
         nMontoDctoMoneda    := X.Dcto_Moneda;
         nMontoDeducLocal    := X.Deduc_Local;
         nMontoDeducMoneda   := X.Deduc_Moneda;
         nIVA_RET_MONEDA     := X.IVA_RET_MONEDA;
         nIVA_RET_LOCAL      := X.IVA_RET_LOCAL;
         nImpLoc_Ret_Local   := X.ImpLoc_Ret_Local;
         nImpLoc_Ret_Moneda  := X.ImpLoc_Ret_Moneda;
      END IF;
      ----
      BEGIN
        SELECT IdProcMasivo,Crga_Nom_Archivo,
               RTRIM(LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(Crga_RegDatosProc,27,','))),Crga_Fecha,
               LTRIM(OC_PROCESOS_MASIVOS.VALOR_CAMPO(Crga_RegDatosProc,9,','))
          INTO nIdProcMasivo,cNomArchCarga,
               cNomArchLogem,dFecCarga,cUUID
          FROM PROCESOS_MASIVOS_SEGUIMIENTO PMS
         WHERE IdSiniestro       = X.IdSiniestro
           AND IdPoliza          = X.IdPoliza
           AND Crga_Cod_Proceso = 'PAGSIN'
           AND Num_Aprobacion   = X.Num_Aprobacion;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          nIdProcMasivo := NULL;
          cNomArchCarga := NULL;
          cNomArchLogem := NULL;
          dFecCarga      := NULL;
          cUUID          := NULL;
        WHEN TOO_MANY_ROWS THEN
          nIdProcMasivo := NULL;
          cNomArchCarga := NULL;
          cNomArchLogem := NULL;
          dFecCarga      := NULL;
          cUUID          := NULL;
      END;
      --MLJS 08/10/2020 SE OBTIENE LA PÓLIZA CONTABLE
      BEGIN
        SELECT TIPODIARIO, NUMCOMPROBSC
          INTO cTIPODIARIO, nNUMCOMPROBSC
          FROM COMPROBANTES_CONTABLES CC
         WHERE NUMTRANSACCION = X.NUMTRX;

         cPolizaCont := cTIPODIARIO||'-'||nNUMCOMPROBSC;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
              cPolizaCont := 'SIN POLIZA CONT';
        WHEN OTHERS THEN
              cPolizaCont := 'SIN POLIZA CONT';
      END;

      cFecCarga := NVL(X.FecCarga,TO_CHAR(dFecCarga,'DD/MM/RRRR'));

      --MLJS 08/10/2020 SE OBTIENE LA PÓLIZA CONTABLE
      ----
      --
      -- FILTRAR PARA QUE LOS COMPONENTES APAREZCAN UNA SOLO VEZ SI HAY MAS DE UNA COBERTURA
      --
      IF WIDSINIESTRO    = X.IdSiniestro    AND    --  JICO AGREGAD0
         WNUM_APROBACION = X.Num_Aprobacion THEN
         nMontoHonoMoneda    := 0;
         nMontoHonoLocal     := 0;
         nMontoHospMoneda    := 0;
         nMontoHospLocal     := 0;
         nMontoOtrGtoMoneda  := 0;
         nMontoOtrGtoLocal   := 0;
         nMontoDctoMoneda    := 0;
         nMontoDctoLocal     := 0;
         nMontoDeducLocal    := 0;
         nMontoDeducMoneda   := 0;
         cValorCampoIVA      := 0;
         cValorCampoISR      := 0;
         nIVA_RET_MONEDA     := 0;
         nIVA_RET_LOCAL      := 0;
         nImpLoc_Ret_Local   := 0;
         nImpLoc_Ret_Moneda  := 0;

         IF X.COD_PAGO IN ('DEDUC','IMPTO','RETENC') THEN
            W_PAGO_NETO_MON_LOC := 0;
            W_PAGO_NETO_MON_MON := 0;
         ELSIF X.CODTRANSAC IN ('GTOHON','GTOHOS','GTOOTR') THEN
            W_PAGO_NETO_MON_LOC  := NVO_MNTO_PAGADO_LOC;
            W_PAGO_NETO_MON_MON  := NVO_MNTO_PAGADO_MON;
         ELSE
            W_PAGO_NETO_MON_LOC  := NVO_MNTO_PAGADO_LOC;
            W_PAGO_NETO_MON_MON  := NVO_MNTO_PAGADO_MON;
         END IF;
      ELSE
/*         --
         IF X.CODTRANSAC IN ('GTOHON','GTOHOS','GTOOTR') THEN
            W_PAGO_NETO_MON_LOC  := NVO_MNTO_PAGADO_LOC                                                           + X.Dcto_Local     + X.Deduc_Local  +
                                    X.IVA_Local          + X.ISR_Local      + X.IVA_Ret_Local  + X.ISR_Ret_Local  + X.ImpLoc_Ret_Local;
            W_PAGO_NETO_MON_MON  := NVO_MNTO_PAGADO_MON                                                           + X.Dcto_Moneda    + X.Deduc_Moneda +
                                    X.IVA_Moneda         + X.ISR_Moneda     + X.IVA_Ret_Moneda + X.ISR_Ret_Moneda + X.ImpLoc_Ret_Moneda;
         ELSE
            W_PAGO_NETO_MON_LOC  := NVO_MNTO_PAGADO_LOC  + X.Gto_Hon_Local  + X.Gto_Hos_Local  + X.Gto_Otr_Local  + X.Dcto_Local     + X.Deduc_Local  +
                                    X.IVA_Local          + X.ISR_Local      + X.IVA_Ret_Local  + X.ISR_Ret_Local  + X.ImpLoc_Ret_Local;
            W_PAGO_NETO_MON_MON  := NVO_MNTO_PAGADO_MON  + X.Gto_Hon_Moneda + X.Gto_Hos_Moneda + X.Gto_Otr_Moneda + X.Dcto_Moneda    + X.Deduc_Moneda +
                                    X.IVA_Moneda         + X.ISR_Moneda     + X.IVA_Ret_Moneda + X.ISR_Ret_Moneda + X.ImpLoc_Ret_Moneda;
         END IF;
         --*/
         W_PAGO_NETO_MON_LOC  := NVO_MNTO_PAGADO_LOC  + nMontoDctoLocal  + nMontoDeducLocal  +
                                 cValorCampoIVA       + cValorCampoISR   + nIVA_Ret_Local    +  nImpLoc_Ret_Local;
         W_PAGO_NETO_MON_MON  := NVO_MNTO_PAGADO_MON  + nMontoDctoMoneda + nMontoDeducMoneda +
                                 cValorCampoIVA       + cValorCampoISR   + nIVA_Ret_Moneda   +  nImpLoc_Ret_Moneda;
         --
          WIDSINIESTRO    := X.IdSiniestro;
         WNUM_APROBACION := X.Num_Aprobacion;
      END IF;
       --
         cCadena := X.IDPOLIZA||cLimitador||
                    X.POLUNIK||cLimitador||
                    REPLACE(X.NUMSINIREF,'|','')||cLimitador||
                    X.IDSINIESTRO||cLimitador||
                    X.COD_PAGO||cLimitador||
                    X.cFechaMvto||cLimitador||
                    X.NUM_APROBACION||cLimitador||
                    X.TIPO_APROBACION||cLimitador||
                    X.ESTATUS||cLimitador||
                    X.CODTRANSAC||cLimitador||
                    X.DESCTRANSAC||cLimitador||
                    X.CODCPTOTRANSAC||cLimitador||
                    X.NUMTRX||cLimitador||
                    TO_CHAR(dFecRes,'DD/MM/RRRR')||cLimitador||
                    X.COD_MONEDA||cLimitador||
                    nTipoCambio||cLimitador||
                    NVO_MNTO_PAGADO_MON||cLimitador||
                    NVO_MNTO_PAGADO_LOC||cLimitador||
                    nMontoHonoMoneda||cLimitador||
                    nMontoHonoLocal||cLimitador||
                    nMontoHospMoneda||cLimitador||
                    nMontoHospLocal||cLimitador||
                    nMontoOtrGtoMoneda||cLimitador||
                    nMontoOtrGtoLocal||cLimitador||
                    nMontoDctoMoneda||cLimitador||
                    nMontoDctoLocal||cLimitador||
                    nMontoDeducLocal||cLimitador||
                    nMontoDeducMoneda||cLimitador||
                    cValorCampoIVA||cLimitador||
                    cValorCampoIVA||cLimitador||
                    cValorCampoISR||cLimitador||
                    cValorCampoISR||cLimitador||
                    nIVA_RET_MONEDA||cLimitador||
                    nIVA_RET_LOCAL||cLimitador||
                    nImpLoc_Ret_Local||cLimitador||
                    nImpLoc_Ret_Moneda||cLimitador||
                    W_PAGO_NETO_MON_MON||cLimitador||
                    W_PAGO_NETO_MON_LOC||cLimitador||
                    X.OPC_MONEDA||cLimitador||
                    X.OPC_LOCAL||cLimitador||
                    cDescBanco||cLimitador||
                    cCuentaCheque||cLimitador||
                    X.USUARIO||cLimitador||
                    nIVAPorcentaje||cLimitador||
                    X.ASEGURADO||cLimitador||
                    cNombreBenef||cLimitador||
                    cNumDocTributario||cLimitador||
                    NVL(X.NomArchCarga,cNomArchCarga)||cLimitador||
                    NVL(X.ARCHIVO_LOGEM,cNomArchLogem)||cLimitador||
                    cFecCarga||cLimitador||
                    X.TIPOSEGURO||cLimitador||
                    NVL(X.NUMERO_FACTURA,cUUID)||cLimitador||
                    NVL(X.IDPROCMASIVO,nIdProcMasivo)||cLimitador||
                    X.POLCONTA_GG||cLimitador||
                    X.FECHA_PAGO||cLimitador||
                    X.IMPORT_PAGO||cLimitador||
                    X.ARCHIVO_GG||cLimitador||
                    X.PGOGG_USUARIO||cLimitador||
                    X.PGOGG_FECHACOMP||cLimitador||
                    X.OBSERVACION_GG||cLimitador||
                    X.WMONTO||cLimitador||
                    X.ESCONTRIBUTORIO||cLimitador||
                    X.PORCENCONTRIBUTORIO||cLimitador||
                    X.GIRONEGOCIO||cLimitador||
                    X.TIPONEGOCIO||cLimitador||
                    X.FUENTERECURSOS||cLimitador||
                    X.CODPAQCOMERCIAL||cLimitador||
                    X.CATEGORIA||cLimitador||
                    X.CANALFORMAVENTA||cLimitador||
                    cPolizaCont||CHR(13);


      nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena||cCadenaAux||cCadenaAux1, 1);
      INSERTA_REGISTROS;

   END LOOP;
   --dbms_output.put_line('MLJS SALIO DE LOOP');
   cNomArchZip := SUBSTR(cNomArchivo, 1, INSTR(cNomArchivo, '.')-1) || '.zip';
   dbms_output.put_line('MLJS cNomArchZip-'||cNomArchZip);

   IF XLSX_BUILDER_PKG.EXCEL_GUARDA_LIBRO THEN
      IF ZIP_UTIL_PKG.ZIP_ARCHIVOS(cNomDirectorio, cNomArchZip, cNomArchivo) THEN
         dbms_output.put_line('OK');
      END IF;

       SICAS_OC.OC_REPORTES_THONA.COPIA_ARCHIVO_BLOB( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomArchZip );
       SICAS_OC.OC_REPORTES_THONA.INSERTAR_REGISTRO ( nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomArchZip );
      COMMIT;
   END IF;

   ENVIA_MAIL;

EXCEPTION
   WHEN OTHERS THEN
   dbms_output.put_line('me fui por el exception');
      OC_ARCHIVO.Eliminar_Archivo(cCodUser);
   RAISE_APPLICATION_ERROR(-20000, 'Error en APROBACIONES ANULADAS DE SINIESTROS ' || SQLERRM);
END;
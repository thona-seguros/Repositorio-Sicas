CREATE OR REPLACE PROCEDURE DEUDOR_X_PRIMAS_COB  IS
----- ESTABA INSERTANDO UNA LINEA EN BLANCO EN EL ARCHIVO Y FALTABA EL ENCABEZADO DE TASA_IVA     JMMD20210729 
cLimitador      VARCHAR2(1) :='|'; 
nLinea          NUMBER;
nLineaimp       NUMBER := 1;
cCadena         VARCHAR2(4000);
--cCadenaAux      VARCHAR2(4000);
--cCadenaAux1     VARCHAR2(4000);
cCodUser        VARCHAR2(30);
--nDummy          NUMBER;
--cCopy           BOOLEAN;
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
----------------
nDiasAntiguedad NUMBER(10);
cRangoAntig     VARCHAR2(20);
dFecEmision     ENDOSOS.FecFinVig%TYPE;
cFecEmision     VARCHAR2(10);
nIdSiniestro    SINIESTRO.IdSiniestro%TYPE;
cTieneSiniestro VARCHAR2(1);
----------------
--nFrecPagos      PLAN_DE_PAGOS.FrecPagos%TYPE;
--nCodTipo        AGENTES.CODTIPO%TYPE;
cNumComprob     COMPROBANTES_CONTABLES.NumComprob%TYPE;
--cTipoEndoso     ENDOSOS.TipoEndoso%TYPE;
--dFecFinVig      ENDOSOS.FecFinVig%TYPE;
nIdNcr          NOTAS_DE_CREDITO.IdNcr%TYPE;
---
nMtoHonoAge    NUMBER(28,2);
nMtoComiAge    NUMBER(28,2);
cTipoAge      AGENTES.CodTipo%TYPE;
cCodAge        AGENTES.Cod_Agente%TYPE;

nMtoComiProm  NUMBER(28,2);
nMtoHonoProm  NUMBER(28,2);
cTipoProm      AGENTES.CodTipo%TYPE;
cCodProm       AGENTES.Cod_Agente%TYPE;

nMtoComiDR    NUMBER(28,2);
nMtoHonoDR    NUMBER(28,2);
cTipoDR        AGENTES.CodTipo%TYPE;
cCodDR         AGENTES.Cod_Agente%TYPE;
-- 
--CFolioFiscal  FACT_ELECT_DETALLE_TIMBRE.FolioFiscal%TYPE;
--cSerie        FACT_ELECT_DETALLE_TIMBRE.Serie%TYPE;
--cUUID          FACT_ELECT_DETALLE_TIMBRE.UUID%TYPE;
--cFechaUUID    DATE;
--cVariosUUID    NUMBER;
cOrigenRecibo VARCHAR2(200);
nOtrasCompPF  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nOtrasCompPM  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
----
--dPagadoHasta    DATE;
--dCubiertoHasta  DATE;
--dFecIniVig      DATE;
--nCuantosEmi      NUMBER;
--nDiasGracia      NUMBER := 0;
--nCuantosPag      NUMBER := 0;
--nMinFactura      NUMBER := 0;
--cStatuspol      VARCHAR2(3);
--
cCtlArchivo     UTL_FILE.FILE_TYPE;

cNomDirectorio  VARCHAR2(100) ;
--cNomArchivo VARCHAR2(100) := 'REC_EMI_'||to_char(trunc(sysdate - 1),'ddmmyyyy')||'.XLSX';
cNomArchivo VARCHAR2(100) := 'DEUD_PRIM_'||to_char(trunc(sysdate - 1),'ddmmyyyy')||'.XLSX';
cNomArchZip           VARCHAR2(100);
cIdTipoSeg            VARCHAR2(50) := '%';
cPlanCob              VARCHAR2(100) := '%';
cCodMoneda            VARCHAR2(5) := '%';
cCodAgente            VARCHAR2(25) := '%';
nCodCia               NUMBER := 1;
nCodEmpresa           NUMBER := 1;
cCodReporte           VARCHAR2(100) := 'DEUDORPORPRIMAS';
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
cSubject                    VARCHAR2(1000) := 'Notificacion Archivo de Deudor por primas: ';
cTexto1                     VARCHAR2(10000):= 'Apreciable Compañero ';
cTexto2                     varchar2(1000)   := ' Envío archivo de Deudor por primas generado de manera automática el día de hoy. ';
cTexto3                     varchar2(10)   := '  ';
cTexto4                     varchar2(1000)   := ' Saludos. ';
----

CURSOR EMI_Q IS 
   SELECT P.IdPoliza,                     P.NumPolUnico,
          P.NumPolRef,                    DP.CodFilial,
          OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) || ' ' ||
            OC_FILIALES.NOMBRE_ADICIONAL(P.CodCia, P.CodGrupoEc, DP.CodFilial) Contratante,
          F.IdEndoso,                     F.IdFactura,
          TO_CHAR(T.FechaTransaccion,'DD/MM/YYYY') FechaTransaccion,
          TO_CHAR(F.FecVenc,'DD/MM/YYYY') FecVenc,
          F.FecVenc                       FecVenc_C,
          F.Cod_Moneda,                   DP.IdTipoSeg,
          DP.PlanCob,                     PC.CodTipoPlan,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CodTipoPlan) DescSubRamo,
          P.CodCliente,                   
          TO_CHAR(P.FecIniVig,'DD/MM/YYYY') FecIniVig,
          TO_CHAR(P.FecFinVig,'DD/MM/YYYY') FecFinVig,
          P.NumRenov,
          P.CodCia,                       F.MtoComisi_Moneda,
          F.NumCuota,                     P.CodEmpresa, 
          T.IdTransaccion,                F.StsFact, 
          F.IDetPol,                      F.FolioFactElec,
          P.CODCIA COD_CIA,               F.FECFINVIG FECFINVIG_FAC,
          GT_TASAS_CAMBIO.CONSULTA_TASA_CAMBIO(TRUNC(T.FechaTransaccion),F.Cod_Moneda) TIPO_CAMBIO,
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
     FROM FACTURAS        F, 
          TRANSACCION     T, 
          POLIZAS         P, 
          DETALLE_POLIZA  DP, 
          PLAN_COBERTURAS PC,
          POLIZAS_TEXTO_COTIZACION  TXT,
          CATEGORIAS                CGO       
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
      AND P.CodEmpresa               = T.CodEmpresa
      AND F.IndContabilizada         = 'S'
      AND TRUNC(T.FechaTransaccion) <= dFecHasta
      AND T.IdProceso               IN (7, 8, 14, 18) -- EmisiÃ³n, Endosos, Contabilizacion y Rehabilitaciones
      AND ((T.IdTransaccion          = F.IdTransaccion AND F.IdTransacContab IS NULL)
       OR  T.IdTransaccion           = F.IdTransacContab)
      AND T.CodEmpresa               = P.CodEmpresa
      AND T.CodCia                   = F.CodCia
      AND F.StsFact                  = 'EMI'
      AND F.IdFactura                > 0
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
   SELECT P.IdPoliza,                    P.NumPolUnico, 
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
     FROM FACTURAS        F,  
          TRANSACCION     T, 
          POLIZAS         P, 
          DETALLE_POLIZA  DP, 
          PLAN_COBERTURAS PC,
          POLIZAS_TEXTO_COTIZACION  TXT,
          CATEGORIAS                CGO       
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
      AND P.CodEmpresa               = T.CodEmpresa
      AND F.IndContabilizada         = 'S'
      AND T.IdTransaccion            = F.IdTransaccionAnu
      AND TRUNC(T.FechaTransaccion)  > dFecHasta
      AND F.StsFact                  IN ('ANU','SUS')
      AND F.IdFactura                > 0
      AND EXISTS (SELECT 'S'
                    FROM TRANSACCION
                   WHERE CodCia                   = F.CodCia
                     AND CodEmpresa               = P.CodEmpresa
                     AND IdTransaccion            = F.IdTransaccion
                     AND TRUNC(FechaTransaccion) <= dFecHasta
                     AND NOT EXISTS (SELECT 'S'
                                       FROM PAGOS
                                      WHERE IdFactura     = F.IdFactura
                                        AND IdRecibo      > 0
                                        AND TRUNC(Fecha) <= dFecHasta))
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
   SELECT P.IdPoliza,                   P.NumPolUnico, 
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
     FROM FACTURAS        F, 
          PAGOS           PG, 
          TRANSACCION     T, 
          POLIZAS         P, 
          DETALLE_POLIZA  DP, 
          PLAN_COBERTURAS PC,
          POLIZAS_TEXTO_COTIZACION  TXT,
          CATEGORIAS                CGO       
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
      AND P.CodEmpresa               = T.CodEmpresa
      AND F.IndContabilizada         = 'S'
      AND TRUNC(T.FechaTransaccion) <= dFecHasta
      AND T.IdTransaccion            = F.IdTransaccion
      AND PG.IdFactura               = F.IdFactura
      AND TRUNC(F.FecPago)           > dFecHasta  -- MLJS INC-2271 SE AGREGO TRUNC A LA FECHA DE PAGO 
      AND F.StsFact                  = 'PAG'
      AND F.IdFactura                > 0
      AND EXISTS (SELECT 'S'
                    FROM TRANSACCION
                   WHERE CodCia                   = F.CodCia
                     AND CodEmpresa               = P.CodEmpresa
                     AND IdTransaccion            = F.IdTransaccion
                     AND TRUNC(FechaTransaccion) <= dFecHasta)
      --
      AND TXT.CODCIA(+)              = P.CODCIA    
      AND TXT.CODEMPRESA(+)          = P.CODEMPRESA 
      AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
      --
      AND CGO.CODCIA(+)              = P.CODCIA  
      AND CGO.CODEMPRESA(+)          = P.CODEMPRESA 
      AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO 
      AND CGO.CODCATEGO(+)           = P.CODCATEGO
    ORDER BY IdFactura;

CURSOR DET_Q IS
   SELECT D.CodCpto,              D.Monto_Det_Moneda, 
          D.IndCptoPrima,         C.IndCptoServicio
     FROM DETALLE_FACTURAS      D, 
          FACTURAS              F, 
          CATALOGO_DE_CONCEPTOS C
    WHERE C.CodConcepto = D.CodCpto
      AND C.CodCia      = F.CodCia
      AND D.IdFactura   = F.IdFactura
      AND F.IdFactura   = nIdFactura;

CURSOR DET_ConC (P_IdPoliza NUMBER, p_IdFactura NUMBER) IS
  SELECT DCO.CodConcepto,            DCO.Monto_Mon_Extranjera, 
         AGE.CodTipo,                AGE.CodNivel, 
         COM.Cod_Agente
    FROM COMISIONES       COM, 
         DETALLE_COMISION DCO, 
         AGENTES          AGE
   WHERE DCO.CodConcepto IN ('HONORA','COMISI','COMIPF','COMIPM','UDI','IVAHON')
     AND COM.CodCia     = DCO.CodCia 
     AND COM.IdComision = DCO.IdComision
     AND AGE.COD_AGENTE = COM.COD_AGENTE
     AND COM.IdPoliza   = P_IdPoliza
     AND COM.IdFactura  = p_IdFactura;    

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
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob AND cPlanCob = '%'))
      AND ((N.CodMoneda              = cCodMoneda AND cCodMoneda != '%')
       OR  (N.CodMoneda           LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((N.Cod_Agente             = cCodAgente AND cCodAgente != '%')
       OR  (N.Cod_Agente          LIKE cCodAgente AND cCodAgente = '%'))
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
  where codlista = 'EMAILDEUDO'
  and codvalor = 'EMAIL1';
EXCEPTION WHEN OTHERS THEN
   cEmail1      := 'jmarquez@thonaseguros.mx';
END;
   DBMS_OUTPUT.put_line('cEmail1  '||cEmail1);

BEGIN
  select  LOWER(DESCVALLST)
  INTO cEmail2
  from valores_de_listas
  where codlista = 'EMAILDEUDO'
  and codvalor = 'EMAIL2';
EXCEPTION WHEN OTHERS THEN
   cEmail1      := NULL;
END;
   DBMS_OUTPUT.put_line('cEmail2  '||cEmail2); 

BEGIN
  select  LOWER(DESCVALLST)
  INTO cEmail3
  from valores_de_listas
  where codlista = 'EMAILDEUDO'
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
       VALUES(1,1,cCodReporte,trunc(sysdate),nLineaimp,'REPAUTDEUDXPMA',cNomArchivo,cCadena);
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
      VALUES('DEUDOR_POR_PRIMAS',SYSDATE,W_ID_ENVIO,W_ID_USER,W_ID_TERMINAL);
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
      cTitulo2 := 'REPORTE DEL DEUDOR POR PRIMA DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY');
      cTitulo4 := ' ';

      cEncabez    := 'No. de Póliza'||cLimitador||
                     'Consecutivo'||cLimitador||
                     'No. Referencia'||cLimitador||
                     'Sub-Grupo'||cLimitador||
                     'Contratante'||cLimitador|| 
                     'No. de Endoso'||cLimitador||
                     'Tipo'||cLimitador||
                     'No. Recibo'||cLimitador||
                     'Status Recibo'||cLimitador||
                     'Forma de Pago'||cLimitador|| 
                     'Fecha Emisión'||cLimitador||
                     'Inicio Vigencia'||cLimitador||
                     'Fin Vigencia'||cLimitador||
                     'Dias Antiguedad'||cLimitador||
                     'Antiguedad'||cLimitador||
                     'Prima Neta'||cLimitador||
                     'Reducción de Prima'||cLimitador||
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
                     'Tasa Iva' ||cLimitador||
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
					           'Canal de Venta' ;

         dbms_output.put_line('jmmd 1 NVO'||'  cCodReporte  '||cCodReporte||' cCodUser  '||cCodUser||'  cNomDirectorio  '||cNomDirectorio||' cNomArchivo  '||cNomArchivo  );
         dbms_output.put_line('jmmd 1 NVO'||cEncabez);
--         INSERTA_REGISTROS;
--         BEGIN

         INSERTA_ENCABEZADO( 'EXCEL', nCodCia, nCodEmpresa, cCodReporte, cCodUser, cNomDirectorio, cNomArchivo ) ;

         dbms_output.put_line('jmmd3 cNomDirectorio '||cNomDirectorio||' cNomArchivo  '||cNomArchivo );
         --
     nLinea := 6;
     dbms_output.put_line('jmmd5 '||cCadena);
 --    nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cEncabez, 1);
      dbms_output.put_line('jmmd X cCadena '||cCadena||' cCodUser  '||cCodUser||' nLinea '||nLinea );
   FOR X IN EMI_Q LOOP
   	  nIdFactura      := X.IdFactura;
   	  cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
      cDescFormaPago  := OC_FACTURAS.FRECUENCIA_PAGO(X.CodCia, X.IdFactura);
      dFecFin         := X.FECFINVIG_FAC;
      cFecFin         := TO_CHAR(dFecFin,'dd/mm/yyyy');

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
      nImpuestoHonoPM	:= 0;  
      nImpuestoHonoPFOC := 0;
      nImpuestoHonoPMOC	:= 0;  
      nOtrasCompPF		:= 0;
      nOtrasCompPM		:= 0;
      --      
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
         IF C.CodNivel = 3 THEN
						cTipoAge			:= C.CodTipo;
						cCodAge				:= C.Cod_Agente;
						IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
               nMtoHonoAge		:= NVL(C.Monto_Mon_Extranjera,0);
						ELSE
               nMtoComiAge		:= NVL(C.Monto_Mon_Extranjera,0);
					  END IF;
				 ELSIF C.CodNivel = 2 THEN
						cTipoProm			:= C.CodTipo;
						cCodProm 			:= C.Cod_Agente;
						IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
							nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
						ELSE
              nMtoComiProm	:= NVL(C.Monto_Mon_Extranjera,0);
					  END IF;
      	 ELSIF C.CodNivel = 1 THEN
						cTipoDR				:= C.CodTipo;
						cCodDR 				:= C.Cod_Agente;
						IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
							nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               nMtoComiDR		:= NVL(C.Monto_Mon_Extranjera,0);
					  END IF;
      	 END IF;
      END LOOP;

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
 --     cOrigenRecibo := ORIGEN_RECIBO(X.CodCia, X.CodEmpresa, X.IdPoliza, X.IDetPol, X.IdFactura);

--      IF :BK_DATOS.Formato = 'TEXTO' THEN
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
                    cTipoAge																			 ||cLimitador||
                    TO_CHAR(nMtoComiProm,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMtoHonoProm,'99999999999990.00')      ||cLimitador||
                    LPAD(cCodProm,6,'0')													 ||cLimitador||
                    cTipoProm																			 ||cLimitador||                    
                    TO_CHAR(nMtoComiDR,'99999999999990.00')        ||cLimitador||
                    TO_CHAR(nMtoHonoDR,'99999999999990.00')        ||cLimitador||
                    LPAD(cCodDR,6,'0')														 ||cLimitador||
                    cTipoDR																				 ||cLimitador||
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
                    X.CANALFORMAVENTA                              ||CHR(13);
          ----
--     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
 --     OC_REPORTES_THONA.INSERTAR_REGISTRO( 1, 1, 'RECIBOSEMITIDOS', cCodUser, cCadena );
--     dbms_output.put_line('jmmd5 '||cCadena);
     INSERTA_REGISTROS;
     nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena, 1);
   END LOOP;
----------------------------------------------------------------------------------
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
      nImpuestoHonoPM	:= 0;  
      nImpuestoHonoPFOC := 0;
      nImpuestoHonoPMOC	:= 0;  
      nOtrasCompPF		:= 0;
      nOtrasCompPM		:= 0;      
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
         IF C.CodNivel = 3 THEN
						cTipoAge			:= C.CodTipo;
						cCodAge				:= C.Cod_Agente;
						IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
              nMtoHonoAge		:= NVL(C.Monto_Mon_Extranjera,0);
						ELSE
              nMtoComiAge		:= NVL(C.Monto_Mon_Extranjera,0);
					  END IF;
				 ELSIF C.CodNivel = 2 THEN
						cTipoProm			:= C.CodTipo;
						cCodProm 			:= C.Cod_Agente;
						IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
							nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
						ELSE
              nMtoComiProm	:= NVL(C.Monto_Mon_Extranjera,0);
					  END IF;
      	 ELSIF C.CodNivel = 1 THEN
						cTipoDR				:= C.CodTipo;
						cCodDR 				:= C.Cod_Agente;
						IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
							nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               nMtoComiDR		:= NVL(C.Monto_Mon_Extranjera,0);
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
                    cTipoAge																			 ||cLimitador||
                    TO_CHAR(nMtoComiProm,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMtoHonoProm,'99999999999990.00')      ||cLimitador||
                    LPAD(cCodProm,6,'0')													 ||cLimitador||
                    cTipoProm																			 ||cLimitador||
                    TO_CHAR(nMtoComiDR,'99999999999990.00')        ||cLimitador||
                    TO_CHAR(nMtoHonoDR,'99999999999990.00')        ||cLimitador||
                    LPAD(cCodDR,6,'0')														 ||cLimitador||
                    cTipoDR																				 ||cLimitador||
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
                    X.CANALFORMAVENTA                              ||CHR(13);

     INSERTA_REGISTROS;
     nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena, 1);
   END LOOP;
---------------------------------------------------------------------------------- 
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
   RAISE_APPLICATION_ERROR(-20000, 'Error en DEUDOR_X_PRIMAS_COB ' || SQLERRM);
END;
/

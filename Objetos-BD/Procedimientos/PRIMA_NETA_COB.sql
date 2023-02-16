create or replace PROCEDURE PRIMA_NETA_COB  IS
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
cCodAge           AGENTES.Cod_Agente%TYPE;

nMtoComiProm    NUMBER(28,2);
nMtoHonoProm    NUMBER(28,2);
cTipoProm       AGENTES.CodTipo%TYPE;
cCodProm        AGENTES.Cod_Agente%TYPE;

nMtoComiDR      NUMBER(28,2);
nMtoHonoDR      NUMBER(28,2);
cTipoDR         AGENTES.CodTipo%TYPE;
cCodDR          AGENTES.Cod_Agente%TYPE;
-- ESA 20180620
CFolioFiscal    FACT_ELECT_DETALLE_TIMBRE.FolioFiscal%TYPE;
cSerie            FACT_ELECT_DETALLE_TIMBRE.Serie%TYPE;
cUUID               FACT_ELECT_DETALLE_TIMBRE.UUID%TYPE;
cFechaUUID      DATE;
cVariosUUID     NUMBER;
cOrigenRecibo VARCHAR2(200);

----
dPagadoHasta    DATE;
dCubiertoHasta  DATE;
dFecIniVig        DATE;
nCuantosEmi         NUMBER;
nDiasGracia         NUMBER := 0;
nCuantosPag         NUMBER := 0;
nMinFactura         NUMBER := 0;
cStatuspol          VARCHAR2(3);
--
cRenovacion     VARCHAR2(15);
cRamo           VARCHAR2(50);
--
W_ID_TERMINAL               CONTROL_PROCESOS_AUTOMATICOS.ID_TERMINAL%TYPE;
W_ID_USER                   CONTROL_PROCESOS_AUTOMATICOS.ID_USER%TYPE;
W_ID_ENVIO                  CONTROL_PROCESOS_AUTOMATICOS.ID_ENVIO%TYPE;
--
cCtlArchivo     UTL_FILE.FILE_TYPE;

cNomDirectorio  VARCHAR2(100) ;

cNomArchivo VARCHAR2(100) := 'PRIMA_NETA_'||to_char(trunc(sysdate - 1),'ddmmyyyy')||'.XLSX';

cNomArchZip           VARCHAR2(100);
cIdTipoSeg            VARCHAR2(50) := '%';
cPlanCob              VARCHAR2(100) := '%';
cCodMoneda            VARCHAR2(5) := '%';
cCodAgente            VARCHAR2(25) := '%';
nCodCia               NUMBER := 1;
nCodEmpresa           NUMBER := 1;
cCodReporte           VARCHAR2(100) := 'PRIMANETA';
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
cSubject                    VARCHAR2(1000) := 'Notificacion Archivo de Prima Neta: ';
cTexto1                     VARCHAR2(10000):= 'Apreciable Compañero ';
cTexto2                     varchar2(1000)   := ' Envío archivo de Prima Neta generado de manera automática el día de hoy. ';
cTexto3                     varchar2(10)   := '  ';
cTexto4                     varchar2(1000)   := ' Saludos. ';
----
CURSOR EMI_Q IS 
   SELECT /*+RULE*/
          'EMISION'                        PROCESO,
          P.IDPOLIZA,                      P.NUMPOLUNICO, 
          P.NUMPOLREF,                     DP.IDETPOL, 
          OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE) || ' ' ||
          OC_FILIALES.NOMBRE_ADICIONAL(P.CODCIA, P.CODGRUPOEC, DP.CODFILIAL) CONTRATANTE,
          F.IDENDOSO,                      F.IDFACTURA, 
          TO_CHAR(T.FECHATRANSACCION,'DD/MM/YYYY') FECHATRANSACCION,                        -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA           
          TO_CHAR(F.FECVENC,'DD/MM/YYYY')  FECVENC,                                         -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA  
          F.COD_MONEDA,                    DP.IDTIPOSEG, 
          DP.PLANCOB,                      PC.CODTIPOPLAN ,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CODTIPOPLAN) DESCSUBRAMO,
          P.CODCLIENTE,                    
          TO_CHAR(P.FECINIVIG,'DD/MM/YYYY') FECINIVIG,                                      -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA  
          TO_CHAR(P.FECFINVIG,'DD/MM/YYYY') FECFINVIG,                                      -- MLJS 12/04/2021 SE DIO FORMATO A LA FECHA                 
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
--          P.CODTIPONEGOCIO                                          CODTIPONEGOCIO,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
--          P.FUENTERECURSOSPRIMA                                     CODFUENTERECURSOS,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,        
          P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
--          P.CODCATEGO                                               CODCATEGO,
          CGO.DESCCATEGO                                            CATEGORIA,
--          P.FORMAVENTA                                              CODCANALFORMAVENTA,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA
     FROM TRANSACCION         T,
          DETALLE_TRANSACCION DT,
          FACTURAS        F,           
          POLIZAS         P, 
          DETALLE_POLIZA  DP , 
          PLAN_COBERTURAS PC,
          POLIZAS_TEXTO_COTIZACION  TXT,
          CATEGORIAS                CGO 
    WHERE DT.IDTRANSACCION           = T.IDTRANSACCION
      AND DT.CODEMPRESA              = T.CODEMPRESA
      AND DT.CODCIA                  = T.CODCIA            
      AND DT.CORRELATIVO             > 0    
      AND TO_NUMBER(DT.VALOR1)       = F.IDPOLIZA  
      AND DT.OBJETO                 IN ('FACTURAS') 
      AND DT.CODSUBPROCESO          IN ('FAC','REHAB','FACFON','CONFAC')    
      --
      AND T.CODCIA                   = DT.CODCIA
      AND T.CODEMPRESA               = DT.CODEMPRESA
      AND T.IDTRANSACCION            > 0               
      AND TRUNC(T.FECHATRANSACCION) >= DFECDESDE
      AND TRUNC(T.FECHATRANSACCION) <= DFECHASTA
      AND T.IDPROCESO               IN (7, 8, 14, 18, 21)       
      --
      AND EXISTS
           (SELECT *
            FROM   DETALLE_TRANSACCION    DTR
            WHERE  DTR.IDTRANSACCION     = DT.IDTRANSACCION
            AND    DTR.CODCIA            = DT.CODCIA
            AND    DTR.CODEMPRESA        = DT.CODEMPRESA            
            AND    DTR.CORRELATIVO       > 0  
            AND  ((DTR.OBJETO IN ('FACTURAS')  AND  T.IDPROCESO  IN (7, 14, 18, 21)  AND DTR.CODSUBPROCESO IN ('FAC','REHAB','FACFON','CONFAC'))
            OR    (DTR.OBJETO IN ('ENDOSOS')   AND  T.IDPROCESO  IN (8)              AND DTR.CODSUBPROCESO IN ('CFP','AUM', 'EAD', 'INA', 'INC', 'IND', 'REHAP', 'RSS')))
            )      
      AND F.CODCIA                   = DT.CODCIA
      AND F.IDPOLIZA                 = TO_NUMBER(DT.VALOR1)      
      AND F.IDFACTURA                = TO_NUMBER(DT.VALOR4)
      AND F.STSFACT                 NOT IN ('PRE')    --PREEMI
      --
      AND P.CODCIA                   = F.CODCIA
      AND P.IDPOLIZA                 = F.IDPOLIZA 
      AND DP.CODCIA                  = F.CODCIA   
      AND DP.IDETPOL                 = F.IDETPOL
      AND DP.IDPOLIZA                = F.IDPOLIZA   
      --
      AND PC.IDTIPOSEG               = DP.IDTIPOSEG
      AND PC.CODEMPRESA              = DP.CODEMPRESA
      AND PC.CODCIA                  = DP.CODCIA                     
      AND PC.PLANCOB                 = DP.PLANCOB                  
      --
      AND ((DP.IDTIPOSEG             = CIDTIPOSEG AND CIDTIPOSEG != '%')
       OR  (DP.IDTIPOSEG          LIKE CIDTIPOSEG AND CIDTIPOSEG = '%'))
      AND ((DP.PLANCOB               = CPLANCOB   AND CPLANCOB != '%')
       OR  (DP.PLANCOB            LIKE CPLANCOB   AND CPLANCOB = '%'))
      AND ((F.COD_MONEDA             = CCODMONEDA AND CCODMONEDA != '%')
       OR  (F.COD_MONEDA          LIKE CCODMONEDA AND CCODMONEDA = '%'))
      AND ((F.CODGENERADOR           = CCODAGENTE AND CCODAGENTE != '%')
       OR  (F.CODGENERADOR        LIKE CCODAGENTE AND CCODAGENTE = '%'))
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
--          P.CODTIPONEGOCIO                                          CODTIPONEGOCIO,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
--          P.FUENTERECURSOSPRIMA                                     CODFUENTERECURSOS,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,        
          P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
--          P.CODCATEGO                                               CODCATEGO,
          CGO.DESCCATEGO                                            CATEGORIA,
--          P.FORMAVENTA                                              CODCANALFORMAVENTA,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'INVALIDA','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA          
     FROM TRANSACCION         T,
          DETALLE_TRANSACCION DT,
          FACTURAS        F, 
          POLIZAS         P, 
          DETALLE_POLIZA  DP, 
          PLAN_COBERTURAS PC,
          POLIZAS_TEXTO_COTIZACION  TXT,
          CATEGORIAS                CGO 
    WHERE DT.IDTRANSACCION           = T.IDTRANSACCION
      AND DT.CODEMPRESA              = T.CODEMPRESA
      AND DT.CODCIA                  = T.CODCIA            
      AND DT.CORRELATIVO             > 0    
      AND TO_NUMBER(DT.VALOR1)       = F.IDPOLIZA
      AND DT.OBJETO                  IN ('FACTURAS') 
      AND DT.CODSUBPROCESO           IN ('FAC','REHAB','FACFON','CONFAC')
      --
      AND T.CODCIA                   = DT.CODCIA
      AND T.CODEMPRESA               = DT.CODEMPRESA
      AND T.IDTRANSACCION            > 0               
      AND TRUNC(T.FECHATRANSACCION) >= DFECDESDE
      AND TRUNC(T.FECHATRANSACCION) <= DFECHASTA
      AND T.IDPROCESO  IN (7, 8, 14, 18, 21)       
      --
      AND EXISTS
           (SELECT *
            FROM   DETALLE_TRANSACCION    DTR
            WHERE  DTR.IDTRANSACCION     = DT.IDTRANSACCION
            AND    DTR.CODCIA            = DT.CODCIA
            AND    DTR.CODEMPRESA        = DT.CODEMPRESA   
            AND  ((DTR.OBJETO IN ('FACTURAS')  AND  T.IDPROCESO  IN (7, 14, 18, 21)  AND DTR.CODSUBPROCESO IN ('FAC','REHAB','FACFON','CONFAC'))
            OR    (DTR.OBJETO IN ('ENDOSOS')   AND  T.IDPROCESO  IN (8)              AND DTR.CODSUBPROCESO IN ('CFP','AUM', 'EAD', 'INA', 'INC', 'IND', 'REHAP', 'RSS')))
            )
      AND F.STSFACT                 != 'PRE'    --PREEMI
      AND F.CODCIA                   = DT.CODCIA
      AND F.IDPOLIZA                 = TO_NUMBER(DT.VALOR1) 
      AND F.IDTRANSACCION            = DT.IDTRANSACCION              
      --
      AND P.CODCIA                   = F.CODCIA
      AND P.IDPOLIZA                 = F.IDPOLIZA 
      --
      AND DP.IDPOLIZA                = F.IDPOLIZA 
      AND DP.IDETPOL                 = F.IDETPOL
      AND DP.CODCIA                  = F.CODCIA                                     
      AND PC.PLANCOB                 = DP.PLANCOB
      AND PC.IDTIPOSEG               = DP.IDTIPOSEG
      AND PC.CODEMPRESA              = DP.CODEMPRESA
      AND PC.CODCIA                  = DP.CODCIA 
      AND ((DP.IDTIPOSEG             = CIDTIPOSEG AND CIDTIPOSEG != '%')
       OR  (DP.IDTIPOSEG          LIKE CIDTIPOSEG AND CIDTIPOSEG = '%'))
      AND ((DP.PLANCOB               = CPLANCOB   AND CPLANCOB != '%')
       OR  (DP.PLANCOB            LIKE CPLANCOB   AND CPLANCOB = '%'))
      AND ((F.COD_MONEDA             = CCODMONEDA AND CCODMONEDA != '%')
       OR  (F.COD_MONEDA          LIKE CCODMONEDA AND CCODMONEDA = '%'))
      AND ((F.CODGENERADOR           = CCODAGENTE AND CCODAGENTE != '%')
       OR  (F.CODGENERADOR        LIKE CCODAGENTE AND CCODAGENTE = '%'))
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
--          P.CODTIPONEGOCIO                                          CODTIPONEGOCIO,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',P.CODTIPONEGOCIO)) TIPONEGOCIO,
--          P.FUENTERECURSOSPRIMA                                     CODFUENTERECURSOS,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',P.FUENTERECURSOSPRIMA)) FUENTERECURSOS,        
          P.CODPAQCOMERCIAL                                         CODPAQCOMERCIAL,
--          P.CODCATEGO                                               CODCATEGO,
          CGO.DESCCATEGO                                            CATEGORIA,
--          P.FORMAVENTA                                              CODCANALFORMAVENTA,
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA 
     FROM TRANSACCION         T,                    -- MLJS SE CAMBIARON LAS TABLAS INICIALES DEL EXTRACCION 28/05/2020
          DETALLE_TRANSACCION DT,                   -- MLJS SE CAMBIARON LAS TABLAS INICIALES DEL EXTRACCION 28/05/2020
          FACTURAS        F,
          POLIZAS         P, 
          DETALLE_POLIZA  DP, 
          PLAN_COBERTURAS PC,
          POLIZAS_TEXTO_COTIZACION  TXT,
          CATEGORIAS                CGO
    -- MLJS 28/05/2020 SE CAMBIARON LAS TABLAS INICIALES DEL EXTRACCION      
    -- SE ASEGURA LA OBTENCIÓN DE LAS TRANSACCIONES DEL PERIODO ESPECIFICO       
    WHERE DT.IDTRANSACCION           = T.IDTRANSACCION
      AND DT.CODEMPRESA              = T.CODEMPRESA
      AND DT.CODCIA                  = T.CODCIA            
      AND DT.CORRELATIVO             > 0 
      AND DT.OBJETO                 IN ('FACTURAS')                             
      AND DT.CODSUBPROCESO          IN ('FAC','ANUFAC')                    
      AND TO_NUMBER(DT.VALOR4)      = F.IDFACTURA   
      AND TO_NUMBER(DT.VALOR1)      = F.IDPOLIZA  
      --
      AND T.CODCIA                   = DT.CODCIA
      AND T.CODEMPRESA               = DT.CODEMPRESA
      AND T.IDTRANSACCION            > 0               
      AND TRUNC(T.FechaTransaccion) >= dFecDesde      
      AND TRUNC(T.FechaTransaccion) <= dFecHasta
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
      ---- MLJS 28/05/2020 SE CAMBIARON LAS TABLAS INICIALES DEL EXTRACCION  
      AND PC.PlanCob                 = DP.PlanCob
      AND PC.IdTipoSeg               = DP.IdTipoSeg
      AND PC.CodEmpresa              = DP.CodEmpresa
      AND PC.CodCia                  = DP.CodCia
      AND DP.CodCia                  = F.CodCia
      AND DP.IDetPol                 = F.IDetPol
      AND DP.IdPoliza                = F.IdPoliza
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob   AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob   AND cPlanCob = '%'))
      AND ((F.Cod_Moneda             = cCodMoneda AND cCodMoneda != '%')
       OR  (F.Cod_Moneda          LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((F.CodGenerador           = cCodAgente AND cCodAgente != '%')
       OR  (F.CodGenerador        LIKE cCodAgente AND cCodAgente = '%'))
      AND P.CodCia                   = F.CodCia
      AND P.IdPoliza                 = F.IDPOLIZA
     -- AND P.CodEmpresa               = DT.CodEmpresa 
      --
      AND TXT.CODCIA(+)              = P.CODCIA    
      AND TXT.CODEMPRESA(+)          = P.CODEMPRESA 
      AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
      --
      AND CGO.CODCIA(+)              = P.CODCIA  
      AND CGO.CODEMPRESA(+)          = P.CODEMPRESA 
      AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO 
      AND CGO.CODCATEGO(+)           = P.CODCATEGO
    ORDER BY PROCESO DESC, IDFACTURA
    ;     

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
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg  = '%'))
      AND ((DP.PlanCob               = cPlanCob   AND cPlanCob   != '%')
       OR  (DP.PlanCob            LIKE cPlanCob   AND cPlanCob    = '%'))
      AND ((N.CodMoneda              = cCodMoneda AND cCodMoneda != '%')
       OR  (N.CodMoneda           LIKE cCodMoneda AND cCodMoneda  = '%'))
      AND ((N.Cod_Agente             = cCodAgente AND cCodAgente != '%')
       OR  (N.Cod_Agente          LIKE cCodAgente AND cCodAgente  = '%'))
      AND P.CodCia                   = N.CodCia
      AND P.IdPoliza                 = N.IdPoliza
      AND P.CodEmpresa               = T.CodEmpresa
      AND T.IdTransaccion            = N.IdTransaccionAnu
      AND T.IdProceso               IN (2, 8)   -- Anulaciones y Endoso
      AND TRUNC(T.FechaTransaccion) >= dFecDesde
      AND TRUNC(T.FechaTransaccion) <= dFecHasta
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
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA       
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
      AND DT.CORRELATIVO             > 0 
      AND ((DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (2)  AND DT.CODSUBPROCESO IN ('NOTACR'))
      OR   (DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (8)  AND DT.CODSUBPROCESO IN ('NCR'))
      OR   (DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (18) AND DT.CODSUBPROCESO IN ('REHNCR')))
      AND  TO_NUMBER(DT.VALOR1)  = N.IDPOLIZA
      --
      AND T.CODCIA                   = DT.CODCIA
      AND T.CODEMPRESA               = DT.CODEMPRESA
      AND T.IDTRANSACCION            > 0               
      AND TRUNC(T.FechaTransaccion) >= dFecDesde
      AND TRUNC(T.FechaTransaccion) <= dFecHasta
      AND T.IDPROCESO               IN (2,8,18)
      AND (T.IDTRANSACCION  = N.IDTRANSACCION AND TO_NUMBER(DT.VALOR1)  = N.IDPOLIZA) 
     -- OR   (T.IDTRANSACCION  = N.IDTRANSACCION))
      AND  EXISTS (
           SELECT 
                  DISTINCT DTR.IDTRANSACCION
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
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob   AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob   AND cPlanCob = '%'))
      AND ((N.CodMoneda              = cCodMoneda AND cCodMoneda != '%')
       OR  (N.CodMoneda           LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((N.Cod_Agente             = cCodAgente AND cCodAgente != '%')
       OR  (N.Cod_Agente          LIKE cCodAgente AND cCodAgente = '%'))
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
          DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FORMAVENTA)) CANALFORMAVENTA       
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
      AND DT.CORRELATIVO             > 0 
      AND ((DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (2)  AND DT.CODSUBPROCESO IN ('NOTACR'))
      OR   (DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (8)  AND DT.CODSUBPROCESO IN ('NCR'))
      OR   (DT.OBJETO IN ('NOTAS_DE_CREDITO')  AND  T.IDPROCESO  IN (18) AND DT.CODSUBPROCESO IN ('REHNCR')))
      --AND  TO_NUMBER(DT.VALOR1)  = N.IDPOLIZA
      --
      AND T.CODCIA                   = DT.CODCIA
      AND T.CODEMPRESA               = DT.CODEMPRESA
      AND T.IDTRANSACCION            > 0               
      AND TRUNC(T.FechaTransaccion) >= dFecDesde
      AND TRUNC(T.FechaTransaccion) <= dFecHasta
      AND T.IDPROCESO               IN (2,8,18)
      AND T.IDTRANSACCION  = N.IDTRANSACCION  --AND TO_NUMBER(DT.VALOR1)  = N.IDPOLIZA) 
     -- OR   (T.IDTRANSACCION  = N.IDTRANSACCION))
      AND  EXISTS (
           SELECT 
                  DISTINCT DTR.IDTRANSACCION
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
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob   AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob   AND cPlanCob = '%'))
      AND ((N.CodMoneda              = cCodMoneda AND cCodMoneda != '%')
       OR  (N.CodMoneda           LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((N.Cod_Agente             = cCodAgente AND cCodAgente != '%')
       OR  (N.Cod_Agente          LIKE cCodAgente AND cCodAgente = '%'))
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
  where codlista = 'EMAILPMANE'
  and codvalor = 'EMAIL1';
EXCEPTION WHEN OTHERS THEN
   cEmail1      := 'jmarquez@thonaseguros.mx';
END;
   DBMS_OUTPUT.put_line('cEmail1  '||cEmail1);

BEGIN
  select  LOWER(DESCVALLST)
  INTO cEmail2
  from valores_de_listas
  where codlista = 'EMAILPMANE'
  and codvalor = 'EMAIL2';
EXCEPTION WHEN OTHERS THEN
   cEmail2      := NULL;
END;
   DBMS_OUTPUT.put_line('cEmail2  '||cEmail2); 

BEGIN
  select  LOWER(DESCVALLST)
  INTO cEmail3
  from valores_de_listas
  where codlista = 'EMAILPMANE'
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
       VALUES(1,1,cCodReporte,trunc(sysdate),nLineaimp,'REPAUTPMANET',cNomArchivo,cCadena);
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
      VALUES('PRIMA_NETA_COB',SYSDATE,W_ID_ENVIO,W_ID_USER,W_ID_TERMINAL);
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
  from  dual ;
*/

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
--
      nLinea := 1;
--      nLinea := nLinea + 1;

      cTitulo1 := cNomCia;
      cTitulo2 := 'REPORTE DE RECIBOS PRODUCCION NETA DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY');
      cTitulo4 := ' ';
      cEncabez    := 'Proceso'||cLimitador||
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
                     'Reducción de Prima'||cLimitador||
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
                               'Renovacion'||cLimitador;
         dbms_output.put_line('jmmd 1 NVO'||'  cCodReporte  '||cCodReporte||' cCodUser  '||cCodUser||'  cNomDirectorio  '||cNomDirectorio||' cNomArchivo  '||cNomArchivo  );
         dbms_output.put_line('jmmd 1 NVO'||cEncabez);
--         INSERTA_REGISTROS;


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
         --
         IF C.CodNivel = 3 THEN
                        cTipoAge            := C.CodTipo;
                        cCodAge             := C.Cod_Agente;
                        IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
              nMtoHonoAge       := NVL(C.Monto_Mon_Extranjera,0);
                        ELSE
              nMtoComiAge       := NVL(C.Monto_Mon_Extranjera,0);
                      END IF;
                 ELSIF C.CodNivel = 2 THEN
                        cTipoProm           := C.CodTipo;
                        cCodProm            := C.Cod_Agente;
                        IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                            nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
                        ELSE
              nMtoComiProm  := NVL(C.Monto_Mon_Extranjera,0);
                      END IF;
         ELSIF C.CodNivel = 1 THEN
                        cTipoDR             := C.CodTipo;
                        cCodDR              := C.Cod_Agente;
                        IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                            nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               nMtoComiDR       := NVL(C.Monto_Mon_Extranjera,0);
                      END IF;
         END IF;
      END LOOP;

      nDifComis := NVL(X.MtoComisi_Moneda,0) - NVL(nTotComisDist,0);

      SELECT NVL(MIN(NumComprob),'0')
        INTO cNumComprob
        FROM COMPROBANTES_CONTABLES
       WHERE CODCIA         = X.CodCia
         AND NumTransaccion = X.IdTransaccion;
      -- rmerida FIN --


--RECUPERA FOLIO FISCAL RECIBO FACTURA cuenta de uuids ESA20180620
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
--    ESA20180620  

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
                    nPrimaNeta                                     ||cLimitador||
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
                    cTipoAge                                                     ||cLimitador||                  
                    TO_CHAR(nMtoComiProm,'99999999999990.00')      ||cLimitador||
                    TO_CHAR(nMtoHonoProm,'99999999999990.00')      ||cLimitador||                  
                    LPAD(cCodProm,6,'0')                           ||cLimitador||
                    cTipoProm                                      ||cLimitador||                  
                    TO_CHAR(nMtoComiDR,'99999999999990.00')        ||cLimitador||
                    TO_CHAR(nMtoHonoDR,'99999999999990.00')        ||cLimitador||                  
                    LPAD(cCodDR,6,'0')                             ||cLimitador||
                    cTipoDR                                        ||cLimitador||
                    TO_CHAR(nTasaIVA,'999,990.00')                  ||cLimitador||
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
                    cUUID                                              ||cLimitador||
                    TO_CHAR(cFechaUUID,'DD/MM/YYYY')               ||cLimitador|| -- MLJS 06/04/2021 SE DIO FORMATO A LA FECHA
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
                    cRenovacion                                                                  ||CHR(13);
--                    DBMS_OUTPUT.put_line('JMMD ANTES DE INSERTA_REGISTRO '||cCadena);
         INSERTA_REGISTROS;

 --      nLinea := nLinea + 1;
--      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena, 1);      
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;    
   END LOOP;

   FOR X IN NC_Q LOOP         
      nIdNcr          := X.IdNcr;
      cCodGenerador   := OC_AGENTE_POLIZA.AGENTE_PRINCIPAL(X.CodCia, X.IdPoliza);
      cDescFormaPago  := 'DIRECTO';
      --dFecFin         := OC_NOTAS_DE_CREDITO.VIGENCIA_FINAL(X.CodCia, X.IdNcr);
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
         cRenovacion   := 'NUEVA';       --MLJS 22/09/2020
      ELSE
         cTipoVigencia := 'RENOVACION';
         cRenovacion   := cTipoVigencia;   --MLJS 22/09/2020
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

      CFolioFiscal      := null;
      cSerie              := null;
      cUUID               := null;
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
         IF C.CodNivel = 3 THEN
                        cTipoAge            := C.CodTipo;
                        cCodAge             := C.Cod_Agente;
                        IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
              nMtoHonoAge       := NVL(C.Monto_Mon_Extranjera,0);
                        ELSE
              nMtoComiAge       := NVL(C.Monto_Mon_Extranjera,0);
                      END IF;
                 ELSIF C.CodNivel = 2 THEN
                        cTipoProm           := C.CodTipo;
                        cCodProm            := C.Cod_Agente;
                        IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                            nMtoHonoProm := NVL(C.Monto_Mon_Extranjera,0);
                        ELSE
              nMtoComiProm  := NVL(C.Monto_Mon_Extranjera,0);
                      END IF;
         ELSIF C.CodNivel = 1 THEN
                        cTipoDR             := C.CodTipo;
                        cCodDR              := C.Cod_Agente;
                        IF C.CodTipo IN ('HONPM','HONPF') AND C.CodConcepto = 'HONORA' THEN
                            nMtoHonoDR := NVL(C.Monto_Mon_Extranjera,0);
            ELSE
               nMtoComiDR       := NVL(C.Monto_Mon_Extranjera,0);
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
                    trim(TO_CHAR(nPrimaNeta,'99999999999990.00'))        ||cLimitador||
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
                    cRamo                                            ||cLimitador||
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
                    TO_CHAR(cFechaUUID,'DD/MM/YYYY')               ||cLimitador|| -- MLJS 06/04/2021 SE DIO FORMATO A LA FECHA
                    cVariosUUID                                                    ||cLimitador||
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
                    cRenovacion                                                                  ; --||CHR(13);
                     DBMS_OUTPUT.put_line('JMMD ANTES DE INSERTA_REGISTRO ');
         INSERTA_REGISTROS;

     nLinea := XLSX_BUILDER_PKG.EXCEL_DETALLE(nLinea + 1, cCadena, 1);
--      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);         
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

/*
      dbms_lob.createtemporary(l_blob, true);
      l_blob := cNomArchZip;
  */
         ENVIA_MAIL;

EXCEPTION
   WHEN OTHERS THEN
   dbms_output.put_line('me fui por el exception');
      OC_ARCHIVO.Eliminar_Archivo(cCodUser);
   RAISE_APPLICATION_ERROR(-20000, 'Error en PRIMA_NETA_COB ' || SQLERRM);
END;
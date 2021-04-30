CREATE OR REPLACE PACKAGE SICAS_OC.OC_RENOVACION IS

   FUNCTION MIGRA_A_AUTOFACIL( P_POLIZA  IN  NUMBER
                             , MENSAJE  OUT VARCHAR2 ) RETURN NUMBER;

   PROCEDURE RENOVAR( NCODCIA               IN NUMBER
                    , NIDPOLIZAREN          IN NUMBER
                    , CID_GENERA_SUBGRUPOS  IN VARCHAR2
                    , CID_GENERA_ASEGURADOS IN VARCHAR2
                    , CTP_MOVTO             IN VARCHAR
                    , NPOLIZA_SALIDA        OUT NUMBER );

   PROCEDURE SELECCIONAR_POLIZAS( nCodCia        NUMBER
                                , nCodEmpresa    NUMBER
                                , dFecEjecucion  DATE );

   FUNCTION POLIZAS_A_RENOVAR( nCodCia      RENOVACIONES.CodCia%TYPE
                             , nCodEmpresa  RENOVACIONES.CodEmpresa%TYPE
                             , dFecProceso  RENOVACIONES.FecProceso%TYPE ) RETURN XMLTYPE;

   PROCEDURE ACTUALIZAR_INFORMACION( nCodCia       RENOVACIONES.CodCia%TYPE
                                   , nCodEmpresa   RENOVACIONES.CodEmpresa%TYPE
                                   , nIdPoliza     RENOVACIONES.IdPoliza%TYPE
                                   , nNumRenov     RENOVACIONES.NumRenov%TYPE
                                   , xGenerales    XMLTYPE );

   PROCEDURE APLICAR_CRITERIOS_RENOVACION( nCodCia      RENOVACIONES.CodCia%TYPE
                                         , nCodEmpresa  RENOVACIONES.CodEmpresa%TYPE
                                         , dFecProceso  RENOVACIONES.FecProceso%TYPE );

END OC_RENOVACION;
/

CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_RENOVACION IS
--
-- CREADO 20/06/2016
-- BITACORA DE CAMBIOS
--
-- SE COLOCO EL PROCEDIMIENTO RENOVAR       01/12/2019  RENOV   JICO
--
 W_CODCIA                   POLIZAS.CODCIA%TYPE;
 W_CODEMPRESA               POLIZAS.CODEMPRESA%TYPE;
 W_IDPOLIZA                 POLIZAS.IDPOLIZA%TYPE;
 W_PLANCOB                  DETALLE_POLIZA.PLANCOB%TYPE;
 W_COD_MONEDA               POLIZAS.COD_MONEDA%TYPE;
 W_IDTIPOSEG                DETALLE_POLIZA.IDTIPOSEG%TYPE;
 W_TIPO_DOC_CONTR           CLIENTES.TIPO_DOC_IDENTIFICACION%TYPE;
 W_NUM_DOC_CONTR            CLIENTES.NUM_DOC_IDENTIFICACION%TYPE;
 W_FECINIVIG                POLIZAS.FECINIVIG%TYPE;
 W_FECFINVIG                POLIZAS.FECFINVIG%TYPE;
 W_CODPLANPAGO              POLIZAS.CODPLANPAGO%TYPE;
 W_TIPOADMINISTRACION       POLIZAS.TIPOADMINISTRACION%TYPE;
 W_CODAGRUPADOR             POLIZAS.CODAGRUPADOR%TYPE;
 W_INDFACTURAPOL            POLIZAS.INDFACTURAPOL%TYPE;
 W_NUMPOLUNICO              POLIZAS.NUMPOLUNICO%TYPE;
 W_INDASEGMODELO            DETALLE_POLIZA.INDASEGMODELO%TYPE;
 W_PRIMANETA_LOCAL          POLIZAS.PRIMANETA_LOCAL%TYPE;
 W_DESCPOLIZA               POLIZAS.DESCPOLIZA%TYPE;
 W_INDFACTELECTRONICA       POLIZAS.INDFACTELECTRONICA%TYPE;
 W_INDCALCDERECHOEMIS       POLIZAS.INDCALCDERECHOEMIS%TYPE;
 W_CODDIRECREGIONAL         POLIZAS.CODDIRECREGIONAL%TYPE;
 W_NUMFOLIOPORTAL           POLIZAS.NUMFOLIOPORTAL%TYPE;
 W_TIPO_DOC_ASEG            ASEGURADO.TIPO_DOC_IDENTIFICACION%TYPE;
 W_NUM_DOC_ASEG             ASEGURADO.NUM_DOC_IDENTIFICACION%TYPE;
 W_CODUSUARIO               SOLICITUD_EMISION.CODUSUARIO%TYPE; 
 W_IDSOLICITUD              SOLICITUD_EMISION.IDSOLICITUD%TYPE;
 W_TASACAMBIO               SOLICITUD_EMISION.TASACAMBIO%TYPE;
 W_CODGRUPOEC               POLIZAS.CODGRUPOEC%TYPE;
  --
 MENSAJE                    VARCHAR2(2000);
--
-- MIGRA POLIZAS DE BASES DE EMISION A SOLICITUD
--
CURSOR DETALLE IS
  SELECT DP.IDETPOL,
         DP.PRIMA_LOCAL,
         DP.CANTASEGMODELO,
         DP.CODFILIAL CODSUBGRUPO,
         SUBSTR(OC_FILIALES.NOMBRE_FILIAL(W_CODCIA,W_CODGRUPOEC,DP.CODFILIAL),1,48) DS_SUBGRUPO
    FROM DETALLE_POLIZA DP
   WHERE DP.IDPOLIZA = W_IDPOLIZA
  ;
--
-- MIGRA CLAUSULAS DE BASES DE EMISION A SOLICITUD
--
CURSOR CLAUSULA IS
  SELECT CODCIA,
         IDPOLIZA,
         COD_CLAUSULA,
         TIPO_CLAUSULA,
         SUBSTR(EXTRAE_CLAUSULA_POL(ROWID),1,3998) TEXTO,
         INICIO_VIGENCIA,
         FIN_VIGENCIA,
         ESTADO
    FROM CLAUSULAS_POLIZA CP
   WHERE CP.IDPOLIZA = W_IDPOLIZA
  ;  
--
--
FUNCTION MIGRA_A_AUTOFACIL(P_POLIZA IN  NUMBER,
                           MENSAJE  OUT VARCHAR2) RETURN NUMBER IS
--
BEGIN
  --
  -- ACTUALIZA TABLAS DE SOLICITUD
  --
  SELECT P.CODCIA,        
         P.CODEMPRESA,
         P.IDPOLIZA,        
         P.COD_MONEDA,
         ADD_MONTHS(P.FECINIVIG,12),
         ADD_MONTHS(P.FECFINVIG,12),
         --
         P.CODPLANPAGO,
         P.TIPOADMINISTRACION,
         P.CODAGRUPADOR,
         P.INDFACTURAPOL,
         P.NUMPOLUNICO,
         P.PRIMANETA_LOCAL,
         --
         P.DESCPOLIZA,
         P.INDFACTELECTRONICA,
         P.INDCALCDERECHOEMIS,
         P.CODDIRECREGIONAL,
         P.NUMFOLIOPORTAL,
         P.CODGRUPOEC,
         --
         DP.IDTIPOSEG,
         DP.PLANCOB,
         DP.INDASEGMODELO,
         --
         C.TIPO_DOC_IDENTIFICACION,
         C.NUM_DOC_IDENTIFICACION,
         --
         A.TIPO_DOC_IDENTIFICACION,
         A.NUM_DOC_IDENTIFICACION
    INTO W_CODCIA,    
         W_CODEMPRESA,
         W_IDPOLIZA, 
         W_COD_MONEDA, 
         W_FECINIVIG,
         W_FECFINVIG,
         --
         W_CODPLANPAGO,
         W_TIPOADMINISTRACION,
         W_CODAGRUPADOR,
         W_INDFACTURAPOL,
         W_NUMPOLUNICO,
         W_PRIMANETA_LOCAL,
         --
         W_DESCPOLIZA,
         W_INDFACTELECTRONICA,
         W_INDCALCDERECHOEMIS,
         W_CODDIRECREGIONAL,
         W_NUMFOLIOPORTAL,
         W_CODGRUPOEC,
         --
         W_IDTIPOSEG,
         W_PLANCOB,
         W_INDASEGMODELO,
         --
         W_TIPO_DOC_CONTR,
         W_NUM_DOC_CONTR,
         --
         W_TIPO_DOC_ASEG,
         W_NUM_DOC_ASEG
    FROM POLIZAS        P,    
         DETALLE_POLIZA DP,    
         CLIENTES       C,
         ASEGURADO      A,
         AGENTE_POLIZA  AP
   WHERE P.IDPOLIZA = P_POLIZA     
     --
     AND DP.IDPOLIZA = P.IDPOLIZA
     AND DP.IDETPOL  = (SELECT MIN(DPI.IDETPOL)          
                          FROM DETALLE_POLIZA DPI
                         WHERE DPI.IDPOLIZA = P.IDPOLIZA)
     --
     AND C.CODCLIENTE = P.CODCLIENTE        
     --
     AND A.COD_ASEGURADO = DP.COD_ASEGURADO  
     --
     AND AP.IDPOLIZA = P.IDPOLIZA            
  ;
  --
  --  EXTRAE EL USUARIO
  --
  BEGIN
    SELECT T.USUARIOGENERO
      INTO W_CODUSUARIO
      FROM POLIZAS     P,
           FACTURAS    F,
           TRANSACCION T
     WHERE P.IDPOLIZA = P_POLIZA
       --
       AND F.CODCIA    = P.CODCIA
       AND F.IDPOLIZA  = P.IDPOLIZA
       AND F.IDFACTURA = (SELECT MIN(F.IDFACTURA)
                            FROM FACTURAS F
                           WHERE F.IDPOLIZA = P.IDPOLIZA)
       --
      AND T.IDTRANSACCION = F.IDTRANSACCION
      ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         W_CODUSUARIO := 0;
    WHEN OTHERS THEN
         W_CODUSUARIO := 0;
  END;
  --
  W_IDSOLICITUD := OC_SOLICITUD_EMISION.NUMERO_SOLICITUD(W_CODCIA, W_CODEMPRESA);
  W_TASACAMBIO  := OC_GENERALES.TASA_DE_CAMBIO(W_COD_MONEDA, TRUNC(SYSDATE));
  --
  -- INSERTA SOLICITUD_EMISION
  --
  INSERT INTO SOLICITUD_EMISION
   (CODCIA,
    CODEMPRESA,
    IDSOLICITUD,
    NUMCOTIZACION,
    IDPOLIZA,
    IDTIPOSEG,
    PLANCOB,
    COD_MONEDA,
    TASACAMBIO,
    TIPO_DOC_IDENTIFICACION,
    NUM_DOC_IDENTIFICACION,
    FECINIVIG,
    FECFINVIG,
    CODPLANPAGO,
    TIPOADMINISTRACION,
    CODAGRUPADOR,
    INDFACTURAPOL,
    INDFACTSUBGRUPO,
    STSSOLICITUD,
    FECSTSSOL,
    CODUSUARIO,
    NUMPOLUNICOASIG,
    INDASEGMODELO,
    PRIMANETAPOL,
    DESCSOLICITUD,
    INDFACTELECTRONICA,
    INDCALCDERECHOEMIS,
    CODDIRECREGIONAL,
    NUMFOLIOPORTAL,
    TIPODOCIDENTIFASEG,
    NUMDOCIDENTIFASEG
   )
   VALUES
   (W_CODCIA,              -- CODCIA,
    W_CODEMPRESA,          -- CODEMPRESA,
    W_IDSOLICITUD,         -- IDSOLICITUD,
    W_IDPOLIZA,            -- NUMCOTIZACION,
    0,                     -- IDPOLIZA,
    W_IDTIPOSEG,           -- IDTIPOSEG,
    W_PLANCOB,             -- PLANCOB,
    W_COD_MONEDA,          -- COD_MONEDA,
    W_TASACAMBIO,          -- TASACAMBIO,
    W_TIPO_DOC_CONTR,      -- TIPO_DOC_IDENTIFICACION,
    W_NUM_DOC_CONTR,       -- NUM_DOC_IDENTIFICACION,
    W_FECINIVIG,           -- FECINIVIG,
    W_FECFINVIG,           -- FECFINVIG,
    W_CODPLANPAGO,         -- CODPLANPAGO,
    W_TIPOADMINISTRACION,  -- TIPOADMINISTRACION,
    W_CODAGRUPADOR,        -- CODAGRUPADOR,
    W_INDFACTURAPOL,       -- INDFACTURAPOL,
    'N',                   -- INDFACTSUBGRUPO,
    'XENVIA',              -- STSSOLICITUD,
    TRUNC(SYSDATE),        -- FECSTSSOL,
    W_CODUSUARIO,          -- CODUSUARIO,
    W_NUMPOLUNICO,         -- NUMPOLUNICOASIG,
    W_INDASEGMODELO,       -- INDASEGMODELO,
    W_PRIMANETA_LOCAL,     -- PRIMANETAPOL,
    W_DESCPOLIZA,          -- DESCSOLICITUD,
    W_INDFACTELECTRONICA,  -- INDFACTELECTRONICA,
    W_INDCALCDERECHOEMIS,  -- INDCALCDERECHOEMIS,
    W_CODDIRECREGIONAL,    -- CODDIRECREGIONAL,
    'RENOVACION',          -- NUMFOLIOPORTAL,
    W_TIPO_DOC_ASEG,       -- TIPODOCIDENTIFASEG,
    W_NUM_DOC_ASEG         -- NUMDOCIDENTIFASEG
   )
  ;
  --
  --INSERTA DETALLE
  --
  FOR D IN DETALLE LOOP 
      --
      INSERT INTO SOLICITUD_DETALLE 
       (CODCIA,
        CODEMPRESA,
        IDSOLICITUD,
        IDETSOL,
        CODSUBGRUPO,
        DESCSUBGRUPO,
        EDADLIMITE,
        PRIMAASEGURADO,
        CANTASEGMODELO
       )
      VALUES
       (W_CODCIA,
        W_CODEMPRESA,
        W_IDSOLICITUD,
        D.IDETPOL,
        D.CODSUBGRUPO,
        D.DS_SUBGRUPO,
        69,
        D.PRIMA_LOCAL,
        D.CANTASEGMODELO
       );
      --
  END LOOP;
  --
  --INSERTA SOLICITUDES
  --
  FOR C IN CLAUSULA LOOP 
      --
      INSERT INTO SOLICITUDES_CLAUSULAS 
       (CODCIA,
        IDPOLIZA,
        COD_CLAUSULA,
        TIPO_CLAUSULA,
        TEXTO,
        INICIO_VIGENCIA,
        FIN_VIGENCIA,
        ESTADO
       )
      VALUES
       (C.CODCIA,
        W_IDSOLICITUD,
        C.COD_CLAUSULA,
        C.TIPO_CLAUSULA,
        C.TEXTO,
        W_FECINIVIG,
        W_FECFINVIG,
        'SOL'
       );
      --
  END LOOP;
  --
  RETURN W_IDSOLICITUD;
  --
--      COMMIT;
  --
EXCEPTION
 WHEN OTHERS THEN
      MENSAJE := 'ERROR AL MIGRAR LA POLIZA : '||P_POLIZA;    
      RETURN 0;  
END;

PROCEDURE RENOVAR(NCODCIA               IN NUMBER,       --01/12/2019  RENOV
                  NIDPOLIZAREN          IN NUMBER, 
                  CID_GENERA_SUBGRUPOS  IN VARCHAR2,
                  CID_GENERA_ASEGURADOS IN VARCHAR2,
                  CTP_MOVTO             IN VARCHAR,
                  NPOLIZA_SALIDA        OUT NUMBER) IS
--                 
dFecHoy            DATE;
dFecFin            DATE;
dFecIni            DATE;
nIdPoliza          POLIZAS.IdPoliza%TYPE;
nTasaCambio        DETALLE_POLIZA.Tasa_Cambio%TYPE;
cNumPolUnico       POLIZAS.NumPolUnico%TYPE;
nCodEmpresa        POLIZAS.CodEmpresa%TYPE;
p_msg_regreso      VARCHAR2(50);
cIdTipoSeg         DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob           DETALLE_POLIZA.PlanCob%TYPE;
nDuracionPlan      PLAN_COBERTURAS.DuracionPlan%TYPE;
NNUMRENOV          POLIZAS.NUMRENOV%TYPE;
CCOD_MONEDA        POLIZAS.COD_MONEDA%TYPE;
NPRIMANETA_MONEDA  POLIZAS.PRIMANETA_MONEDA%TYPE;
CNUMPOLUNICO_ACT   POLIZAS.NUMPOLUNICO%TYPE;
NSUMAASEG_MONEDA   POLIZAS.SUMAASEG_MONEDA%TYPE;
nIDETPOL           DETALLE_POLIZA.IDETPOL%TYPE;
CCALCULADO         POLIZAS.NUMPOLUNICO%TYPE;
CCADENA_FINAL      POLIZAS.NUMPOLUNICO%TYPE;
CMENSAJE_SALIDA    VARCHAR2(4000);
--
CURSOR POL_REN_Q IS
 SELECT *
   FROM POLIZAS
  WHERE IdPoliza = nIdPolizaRen
    AND CodCia   = nCodCia;
--      
CURSOR DET_POL_RENOVAR_Q IS
 SELECT *
   FROM DETALLE_POLIZA DP
  WHERE IdPoliza   = nIdPolizaRen
    AND CodCia     = nCodCia;
--
CURSOR BENEF_Q IS
 SELECT *
   FROM BENEFICIARIO
  WHERE IdPoliza = nIdPolizaRen
    AND Estado   = 'ACTIVO';
--
CURSOR AGE_POL IS
 SELECT *
   FROM AGENTE_POLIZA
  WHERE CodCia  = nCodCia
   AND IdPoliza = nIdPolizaRen;
--
CURSOR AGE_POL_D IS
 SELECT *
   FROM AGENTES_DISTRIBUCION_POLIZA
  WHERE CodCia   = nCodCia
    AND IdPoliza = nIdPolizaRen;
--
CURSOR REGLAS IS
 SELECT *
   FROM REGLA_SA_COBER R
  WHERE R.CODCIA   = nCodCia
    AND R.IDPOLIZA = nIdPolizaRen
    AND R.IDETPOL  = nIDETPOL;
--
CURSOR AGE_DET IS
 SELECT *
   FROM AGENTES_DETALLES_POLIZAS ADP
  WHERE IdPoliza = nIdPolizaRen
    AND CodCia   = nCodCia
    AND IDETPOL  = nIDETPOL;
--
CURSOR AGE_DIS_COM IS
 SELECT *  
   FROM AGENTES_DISTRIBUCION_COMISION A
  WHERE A.CODCIA   = nCodCia
    AND A.IDPOLIZA = nIdPolizaRen
    AND A.IDETPOL  = nIDETPOL;
--
CURSOR COB_REN_Q IS
 SELECT *
   FROM COBERT_ACT CA
  WHERE CA.IdPoliza     = nIdPolizaRen
    AND CA.CodCia       = nCodCia
    AND CA.STSCOBERTURA = 'EMI'
    AND CA.IDETPOL      = nIDETPOL;
--
CURSOR COBASEGCERT_Q IS
 SELECT *
   FROM COBERT_ACT_ASEG AC
  WHERE IdPoliza     = nIdPolizaRen
    AND CodCia       = nCodCia
    AND STSCOBERTURA = 'EMI'
    AND IDETPOL      = nIDETPOL;
--
CURSOR ASEG_CERTIF_Q IS
 SELECT *
   FROM ASEGURADO_CERTIFICADO A
  WHERE IdPoliza = nIdPolizaRen
    AND CodCia   = nCodCia
    AND ESTADO   = 'EMI'
    AND IDETPOL  = nIDETPOL;
--
CURSOR DET_REN_Q IS
 SELECT CodCia, CodEmpresa, IDetPol, Cod_Asegurado
   FROM DETALLE_POLIZA
  WHERE IdPoliza = nIdPolizaRen
    AND CodCia   = nCodCia;
--
CURSOR ASIST_DET IS
   SELECT *
     FROM ASISTENCIAS_DETALLE_POLIZA
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;
--      
CURSOR ASIST_CER IS
   SELECT *
     FROM ASISTENCIAS_ASEGURADO
    WHERE IdPoliza = nIdPolizaRen
      AND CodCia   = nCodCia;      
--      
BEGIN
  --
  nIdPoliza := OC_POLIZAS.F_GET_NUMPOL(p_msg_regreso);
  NPOLIZA_SALIDA  := 0;
  CMENSAJE_SALIDA := '';
  --
  BEGIN  
    SELECT TRUNC(SYSDATE),     P.CODEMPRESA,      ADD_MONTHS(FECRENOVACION,12),  
           P.FECRENOVACION,    P.NUMRENOV,        P.COD_MONEDA,
           P.PRIMANETA_MONEDA, P.NUMPOLUNICO,     P.SUMAASEG_MONEDA, 
           --
           SUBSTR(P.NUMPOLUNICO,1,INSTR(P.NUMPOLUNICO,'-',-1,1)-1)||'-'||TRIM(TO_CHAR(NVL(P.NUMRENOV,0)+1,'00')),
           SUBSTR(P.NUMPOLUNICO,TRIM(INSTR(P.NUMPOLUNICO,'-',-1,1)+1),100)
      INTO dFecHoy,            nCodEmpresa,       dFecFin,
           dFecIni,            NNUMRENOV,         CCOD_MONEDA,
           NPRIMANETA_MONEDA,  CNUMPOLUNICO_ACT,  NSUMAASEG_MONEDA,
           --
           CCALCULADO,
           CCADENA_FINAL   
      FROM POLIZAS P 
     WHERE IdPoliza = nIdPolizaRen
       AND CodCia   = nCodCia;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         CMENSAJE_SALIDA := ' - POLIZA NO EXISTENTE ';
         RAISE_APPLICATION_ERROR(-20201,' POLIZA NO EXISTENTE ');
    WHEN TOO_MANY_ROWS THEN
         CMENSAJE_SALIDA := ' - POLIZA DUPLICADA ';
         RAISE_APPLICATION_ERROR(-20202,' POLIZA DUPLICADA ');
    WHEN OTHERS THEN
         CMENSAJE_SALIDA := ' - POLIZA CON PROBLEMAS ';
         RAISE_APPLICATION_ERROR(-20203,' POLIZA CON PROBLEMAS ');
  END; 
  --
  BEGIN  
    SELECT MAX(P.IDTIPOSEG), MAX(P.PLANCOB)
      INTO cIdTipoSeg,  cPlanCob
      FROM DETALLE_POLIZA P
     WHERE IdPoliza = nIdPolizaRen
       AND CodCia   = nCodCia;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         CMENSAJE_SALIDA := ' - DETALLE DE POLIZA NO EXISTENTE ';
         RAISE_APPLICATION_ERROR(-20201,' DETALLE DE POLIZA NO EXISTENTE ');
    WHEN TOO_MANY_ROWS THEN
         CMENSAJE_SALIDA := ' - DETALLE DE POLIZA DUPLICADA ';
         RAISE_APPLICATION_ERROR(-20202,' POLIZA DUPLICADA ');
    WHEN OTHERS THEN
         CMENSAJE_SALIDA := ' - DETALLE DE POLIZA CON PROBLEMAS ';
         RAISE_APPLICATION_ERROR(-20203,' POLIZA CON PROBLEMAS ');
  END; 
  --  
  nDuracionPlan := OC_PLAN_COBERTURAS.DURACION_PLAN(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob);
  -- Renovación de Póliza
  IF nDuracionPlan > 1 AND
     NNUMRENOV + 2 > nDuracionPlan THEN
     CMENSAJE_SALIDA := ' - POLIZA CON PROBLEMAS ';
     RAISE_APPLICATION_ERROR(-20204,' La Renovación Supera la Duración del Plan de Coberturas ');
  END IF;
  --
  nTasaCambio  := OC_GENERALES.TASA_DE_CAMBIO(CCOD_MONEDA, TRUNC(SYSDATE));
  --
  -- NUMERO DE POLIZA UNICO
  --
  cNumPolUnico := CCALCULADO;
  --
  IF CCALCULADO IN ('-01','-02','-03','-04','-05') THEN
     cNumPolUnico := TRIM(TO_CHAR(CNUMPOLUNICO_ACT))||'-'||TRIM(TO_CHAR(NVL(NNUMRENOV,0)+1,'00'));
  END IF;
  --
  IF CCADENA_FINAL IN ('AP','VD') THEN
     cNumPolUnico := TRIM(TO_CHAR(CNUMPOLUNICO_ACT))||'-'||TRIM(TO_CHAR(NVL(NNUMRENOV,0)+1,'00'));
  END IF;
  --
  NNUMRENOV := NNUMRENOV + 1;
  --
  FOR P IN POL_REN_Q LOOP  
      --
      BEGIN
       INSERT INTO POLIZAS P  --VERSION DE TABLA 20191113
        (IDPOLIZA,                  CODEMPRESA,                 CODCIA,
         TIPOPOL,                   NUMPOLREF,                  FECINIVIG,
         FECFINVIG,                 FECSOLICITUD,               FECEMISION,
         FECRENOVACION,             STSPOLIZA,                  FECSTS,
         FECANUL,                   MOTIVANUL,                  SUMAASEG_LOCAL,
         --
         SUMAASEG_MONEDA,           PRIMANETA_LOCAL,            PRIMANETA_MONEDA,
         DESCPOLIZA,                PORCCOMIS,                  NUMRENOV,
         INDEXAINSP,                COD_MONEDA,                 NUM_COTIZACION,
         CODCLIENTE,                COD_AGENTE,                 CODPLANPAGO,
         MEDIO_PAGO,                NUMPOLUNICO,                INDPOLCOL,
         --
         INDPROCFACT,               CARACTERISTICA,             INDFACTPERIODO,
         FORMAVENTA,                TIPORIESGO,                 INDCONCENTRADA,
         TIPODIVIDENDO,             CODGRUPOEC,                 INDAPLICOSAMI,
         SAMIPOLIZA,                TIPOADMINISTRACION,         CODAGRUPADOR,
         HORAVIGFIN,                HORAVIGINI,                 INDFACTURAPOL,
         --
         INDFACTELECTRONICA,        INDCALCDERECHOEMIS,         CODDIRECREGIONAL,
         NUMFOLIOPORTAL,            PLDSTBLOQUEADA,             PLDSTAPROBADA,
         PLDUSUARIOAPROB,           PORCDESCUENTO,              PORCGTOADMIN,
         PORCGTOADQUI,              PORCUTILIDAD,               FACTORAJUSTE,
         FACTFORMULADEDUC,          CODRIESGOREA,               CODTIPOBONO,
         --
         MONTODEDUCIBLE,            HORASVIG,                   DIASVIG,
         INDEXTRAPRIMA,             ASEGADHERIDOSPOR,           PORCENCONTRIBUTORIO,
         FUENTERECURSOSPRIMA,       IDFORMACOBRO,               DIACOBROAUTOMATICO,
         NUMINTENTOSCOBRANZA,       PORCEXTRAPRIMA,             MONTOEXTRAPRIMA,
         INDMANEJAFONDOS,           INDCONVENCIONES,            TIPOPRORRATA,
         --
         CODTIPONEGOCIO,            CODPAQCOMERCIAL,            CODOFICINA,
         CODCATEGO)
       VALUES
        (nIdPoliza,                 P.CODEMPRESA,               P.CODCIA,
         P.TIPOPOL,                 P.NUMPOLREF,                dFecIni,
         dFecFin,                   dFecHoy,                    dFecHoy,
         dFecFin,                   'SOL',                      dFecHoy,
         '',                        '',                         P.SUMAASEG_LOCAL * nTasaCambio,
         --
         P.SUMAASEG_MONEDA,         P.PRIMANETA_LOCAL * nTasaCambio, P.PRIMANETA_MONEDA,
         P.DESCPOLIZA,              P.PORCCOMIS,                NNUMRENOV,
         P.INDEXAINSP,              P.COD_MONEDA,               '',
         P.CODCLIENTE,              P.COD_AGENTE,               P.CODPLANPAGO,
         P.MEDIO_PAGO,              cNumPolUnico,               P.INDPOLCOL,
         --
         P.INDPROCFACT,             P.CARACTERISTICA,           P.INDFACTPERIODO,
         P.FORMAVENTA,              P.TIPORIESGO,               P.INDCONCENTRADA,
         P.TIPODIVIDENDO,           P.CODGRUPOEC,               'N',
         '',                        P.TIPOADMINISTRACION,       P.CODAGRUPADOR,
         P.HORAVIGFIN,              P.HORAVIGINI,               P.INDFACTURAPOL,
         --
         P.INDFACTELECTRONICA,      P.INDCALCDERECHOEMIS,       P.CODDIRECREGIONAL,
         P.NUMFOLIOPORTAL,          '',                         '',
         '',                        P.PORCDESCUENTO,            P.PORCGTOADMIN,
         P.PORCGTOADQUI,            P.PORCUTILIDAD,             P.FACTORAJUSTE,
         P.FACTFORMULADEDUC,        P.CODRIESGOREA,             P.CODTIPOBONO,
         --
         '',                        '',                         '',
         '',                        '',                         '',
         '',                        P.IDFORMACOBRO,             P.DIACOBROAUTOMATICO,
         P.NUMINTENTOSCOBRANZA,     P.PORCEXTRAPRIMA,           P.MONTOEXTRAPRIMA,
         P.INDMANEJAFONDOS,         P.INDCONVENCIONES,          P.TIPOPRORRATA,
         --
         P.CODTIPONEGOCIO,          P.CODPAQCOMERCIAL,          P.CODOFICINA,
         P.CODCATEGO);
      EXCEPTION
        WHEN OTHERS THEN
             CMENSAJE_SALIDA := ' - T_POLIZAS ';
             RAISE_APPLICATION_ERROR(-20206,' T_POLIZAS ');
      END;
      -- Inserta Agentes de la Póliza
      FOR A IN AGE_POL LOOP 
          BEGIN
            INSERT INTO AGENTE_POLIZA
              (IDPOLIZA,             CODCIA,             COD_AGENTE,
               PORC_COMISION,        IND_PRINCIPAL,      ORIGEN)
            VALUES
              (nIdPoliza,            A.CODCIA,           A.COD_AGENTE,
               A.PORC_COMISION,      A.IND_PRINCIPAL,    A.ORIGEN);
          EXCEPTION
            WHEN OTHERS THEN
                CMENSAJE_SALIDA := ' - T_AGENTE_POLIZA ';
                RAISE_APPLICATION_ERROR(-20206,' T_AGENTE_POLIZA ');
          END;
      END LOOP;
      -- Inserta Distribución de Agentes de la Póliza
      FOR AP IN AGE_POL_D LOOP 
          BEGIN
            INSERT INTO AGENTES_DISTRIBUCION_POLIZA
              (CODCIA,                   IDPOLIZA,                COD_AGENTE,              CODNIVEL,
               COD_AGENTE_DISTR,         PORC_COMISION_AGENTE,    PORC_COM_DISTRIBUIDA,    PORC_COMISION_PLAN,
               PORC_COM_PROPORCIONAL,    COD_AGENTE_JEFE,         PORC_COM_POLIZA,         ORIGEN)
            VALUES
              (AP.CODCIA,                nIdPoliza,               AP.COD_AGENTE,           AP.CODNIVEL,
               AP.COD_AGENTE_DISTR,      AP.PORC_COMISION_AGENTE, AP.PORC_COM_DISTRIBUIDA, AP.PORC_COMISION_PLAN,
               AP.PORC_COM_PROPORCIONAL, AP.COD_AGENTE_JEFE,      AP.PORC_COM_POLIZA,      AP.ORIGEN);
          EXCEPTION
            WHEN OTHERS THEN
                 CMENSAJE_SALIDA := ' - T_AGENTES_DISTRIBUCION_POLIZA ';
                 RAISE_APPLICATION_ERROR(-20206,' T_AGENTES_DISTRIBUCION_POLIZA ');
          END;  
      END LOOP;
      -- Claúsulas de Póliza
      BEGIN
         OC_CLAUSULAS_POLIZA.RENOVAR(nCodCia, nIdPolizaRen, nIdPoliza);
      EXCEPTION
        WHEN OTHERS THEN
             CMENSAJE_SALIDA := ' - P_OC_CLAUSULAS_POLIZA ';
             RAISE_APPLICATION_ERROR(-20206,' P_OC_CLAUSULAS_POLIZA ');
      END;    
      -- 
  END LOOP;
  --
  -- Renovación de Detalles de Póliza
  --
  IF CID_GENERA_SUBGRUPOS = 'S' THEN
     FOR D IN DET_POL_RENOVAR_Q LOOP
         --
         nIDETPOL := D.IDETPOL;
         --
         BEGIN
           INSERT INTO DETALLE_POLIZA DP
             (IDPOLIZA,            IDETPOL,              CODCIA,
              COD_ASEGURADO,        CODEMPRESA,           CODPLANPAGO,
              SUMA_ASEG_LOCAL,      SUMA_ASEG_MONEDA,     PRIMA_LOCAL,
              PRIMA_MONEDA,         FECINIVIG,            FECFINVIG,
              IDTIPOSEG,            TASA_CAMBIO,          PORCCOMIS,
              --
              PLANCOB,              MONTOCOMIS,           NUMDETREF,
              STSDETALLE,           FECANUL,              MOTIVANUL,
              CODPROMOTOR,          INDDECLARA,           INDSINASEG,
              CODFILIAL,            CODCATEGORIA,         INDFACTELECTRONICA,
              INDASEGMODELO,        CANTASEGMODELO,       MONTOCOMISH,
              --
              PORCCOMISH,           IDDIRECAVICOB,        IDFORMACOBRO,
              MONTOAPORTEFONDO,     HABITOTARIFA)
           VALUES
             (nIdPoliza,            D.IDETPOL,            D.CODCIA,
              D.COD_ASEGURADO,      D.CODEMPRESA,         D.CODPLANPAGO,
              D.SUMA_ASEG_MONEDA * nTasaCambio,    D.SUMA_ASEG_MONEDA,   D.PRIMA_MONEDA * nTasaCambio,
              D.PRIMA_MONEDA,       dFecIni,              dFecFin,
              D.IDTIPOSEG,          nTasaCambio,         D.PORCCOMIS,
              --
               D.PLANCOB,            D.MONTOCOMIS,         D.NUMDETREF,
              'SOL',                '',                   '',
              D.CODPROMOTOR,        D.INDDECLARA,         D.INDSINASEG,
              D.CODFILIAL,          D.CODCATEGORIA,       D.INDFACTELECTRONICA,
              D.INDASEGMODELO,      D.CANTASEGMODELO,     D.MONTOCOMISH,
              --
              D.PORCCOMISH,         D.IDDIRECAVICOB,      D.IDFORMACOBRO,
              D.MONTOAPORTEFONDO,   D.HABITOTARIFA); 
         EXCEPTION
           WHEN OTHERS THEN
                CMENSAJE_SALIDA := ' - T_DETALLE_POLIZA ';
                RAISE_APPLICATION_ERROR(-20206,' T_DETALLE_POLIZA ');
         END;    
         --
         IF OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(nCodCia, D.CodEmpresa, D.IdTipoSeg) = 'S' THEN 
           IF GT_FAI_TIPOS_FONDOS_PRODUCTOS.FONDOS_COLECTIVOS(nCodCia, D.CodEmpresa, cIdTipoSeg, cPlanCob) = 'N' THEN  
              GT_FAI_FONDOS_DETALLE_POLIZA.RENOVAR(D.CodCia, D.CodEmpresa, nIdPolizaRen, nIDETPOL, D.Cod_Asegurado, nIdPoliza);
           END IF;
         END IF;
         --
         BEGIN
           FOR R IN REGLAS LOOP
               INSERT INTO REGLA_SA_COBER 
                 (CODCIA,       CODEMPRESA,      IDPOLIZA,
                  IDETPOL,      CODCOBERT,       TEXTO,
                  STREGLA,      USUARIO,         FECHA_ULT_MOVTO)
               VALUES
                 (R.CODCIA,     R.CODEMPRESA,    nIdPoliza,
                  R.IDETPOL,    R.CODCOBERT,     R.TEXTO,
                  R.STREGLA,    USER,            dFecHoy);
           END LOOP;
         EXCEPTION
           WHEN OTHERS THEN
                CMENSAJE_SALIDA := ' - T_REGLA_SA_COBER ';
                RAISE_APPLICATION_ERROR(-20206,' T_REGLA_SA_COBER ');
         END;    
         --
         -- COMISIONES POR DETALLE DE POLIZA
         --
         FOR AD IN AGE_DET LOOP
             BEGIN
               INSERT INTO AGENTES_DETALLES_POLIZAS
                 (IDPOLIZA,           IDETPOL,            IDTIPOSEG,       COD_AGENTE,
                  PORC_COMISION,      IND_PRINCIPAL,      CODCIA,          ORIGEN)
               VALUES
                 (nIdPoliza,          AD.IDETPOL,         AD.IDTIPOSEG,    AD.COD_AGENTE,
                  AD.PORC_COMISION,   AD.IND_PRINCIPAL,   AD.CODCIA,       AD.ORIGEN);
             --
             FOR ADC IN AGE_DIS_COM LOOP
                 BEGIN
                   INSERT INTO AGENTES_DISTRIBUCION_COMISION
                     (CODCIA,                      IDPOLIZA,                   IDETPOL,
                      CODNIVEL,                    COD_AGENTE,                 COD_AGENTE_DISTR,
                      PORC_COMISION_PLAN,          PORC_COMISION_AGENTE,       PORC_COM_DISTRIBUIDA,
                      PORC_COM_PROPORCIONAL,       COD_AGENTE_JEFE,            ORIGEN)
                   VALUES
                     (ADC.CODCIA,                  nIdPoliza,                  ADC.IDETPOL,
                      ADC.CODNIVEL,                ADC.COD_AGENTE,             ADC.COD_AGENTE_DISTR,
                      ADC.PORC_COMISION_PLAN,      ADC.PORC_COMISION_AGENTE,   ADC.PORC_COM_DISTRIBUIDA,
                      ADC.PORC_COM_PROPORCIONAL,   ADC.COD_AGENTE_JEFE,        ADC.ORIGEN);
                 EXCEPTION
                   WHEN OTHERS THEN
                        CMENSAJE_SALIDA := ' - T_AGENTES_DISTRIBUCION_COMISION ';
                        RAISE_APPLICATION_ERROR(-20206,' T_AGENTES_DISTRIBUCION_COMISION ');
                 END;    
               END LOOP;
             EXCEPTION
                WHEN OTHERS THEN
                     CMENSAJE_SALIDA := ' - T_AGENTES_DETALLES_POLIZAS ';
                     RAISE_APPLICATION_ERROR(-20206,' T_AGENTES_DETALLES_POLIZAS ');
             END;    
         END LOOP;
         --
         -- Asegurados del Detalle
         --
         IF CID_GENERA_ASEGURADOS = 'S' THEN
            -- INSERTA COLECTIVO
            FOR Y IN COB_REN_Q LOOP
                BEGIN
                  INSERT INTO COBERT_ACT
                    (CODEMPRESA,            CODCIA,                IDPOLIZA,              IDETPOL,
                     IDTIPOSEG,             TIPOREF,               NUMREF,                CODCOBERT,
                     SUMAASEG_LOCAL,                               SUMAASEG_MONEDA,       TASA,                  PRIMA_MONEDA,
                     --
                     PRIMA_LOCAL,                                  IDENDOSO,              STSCOBERTURA,          PLANCOB,
                     COD_MONEDA,            DEDUCIBLE_LOCAL,                              DEDUCIBLE_MONEDA,      COD_ASEGURADO,
                     INDCAMBIOSAMI,         SUMAASEGORIGEN,        PRIMANIVMONEDA,        PRIMANIVLOCAL,
                     --
                     SALARIOMENSUAL,        VECESSALARIO,          SUMAASEGCALCULADA,     EDAD_MINIMA,
                     EDAD_MAXIMA,           EDAD_EXCLUSION,        SUMAASEG_MINIMA,       SUMAASEG_MAXIMA,
                     PORCEXTRAPRIMADET,     MONTOEXTRAPRIMADET,    SUMAINGRESADA)
                  VALUES
                    (Y.CODEMPRESA,          Y.CODCIA,              nIdPoliza,             Y.IDETPOL,
                     Y.IDTIPOSEG,           Y.TIPOREF,             Y.NUMREF,              Y.CODCOBERT,
                     Y.SUMAASEG_LOCAL * nTasaCambio,               Y.SUMAASEG_MONEDA,     Y.TASA,                Y.PRIMA_MONEDA,
                     --
                     Y.PRIMA_LOCAL * nTasaCambio,                  Y.IDENDOSO,            'SOL',                 Y.PLANCOB,
                     Y.COD_MONEDA,          Y.DEDUCIBLE_LOCAL * nTasaCambio,              Y.DEDUCIBLE_MONEDA,    Y.COD_ASEGURADO,
                     Y.INDCAMBIOSAMI,       Y.SUMAASEGORIGEN,      Y.PRIMANIVMONEDA,      Y.PRIMANIVLOCAL * nTasaCambio,
                     --
                     Y.SALARIOMENSUAL,      Y.VECESSALARIO,        Y.SUMAASEGCALCULADA,   Y.EDAD_MINIMA,
                     Y.EDAD_MAXIMA,         Y.EDAD_EXCLUSION,      Y.SUMAASEG_MINIMA,     Y.SUMAASEG_MAXIMA,
                     Y.PORCEXTRAPRIMADET,   Y.MONTOEXTRAPRIMADET,  Y.SUMAINGRESADA);
                EXCEPTION
                  WHEN OTHERS THEN
                       CMENSAJE_SALIDA := ' - T_COBERT_ACT ';
                       RAISE_APPLICATION_ERROR(-20206,' T_COBERT_ACT ');
                END;    
            END LOOP;
            -- 
            -- INSERTA COLECTIVO
            --
            FOR P IN ASEG_CERTIF_Q LOOP
                BEGIN
                  INSERT INTO ASEGURADO_CERTIFICADO
                    (CODCIA,               IDPOLIZA,             IDETPOL,              COD_ASEGURADO,         ESTADO,
                     SUMAASEG,                        PRIMANETA,
                     CAMPO1,    CAMPO2,    CAMPO3,    CAMPO4,    CAMPO5,    CAMPO6,    CAMPO7,    CAMPO8,    CAMPO9,    CAMPO10,
                     CAMPO11,   CAMPO12,   CAMPO13,   CAMPO14,   CAMPO15,   CAMPO16,   CAMPO17,   CAMPO18,   CAMPO19,   CAMPO20,
                     CAMPO21,   CAMPO22,   CAMPO23,   CAMPO24,   CAMPO25,   CAMPO26,   CAMPO27,   CAMPO28,   CAMPO29,   CAMPO30,
                     CAMPO31,   CAMPO32,   CAMPO33,   CAMPO34,   CAMPO35,   CAMPO36,   CAMPO37,   CAMPO38,   CAMPO39,   CAMPO40,
                     CAMPO41,   CAMPO42,   CAMPO43,   CAMPO44,   CAMPO45,   CAMPO46,   CAMPO47,   CAMPO48,   CAMPO49,   CAMPO50,
                     CAMPO51,   CAMPO52,   CAMPO53,   CAMPO54,   CAMPO55,   CAMPO56,   CAMPO57,   CAMPO58,   CAMPO59,   CAMPO60,
                     CAMPO61,   CAMPO62,   CAMPO63,   CAMPO64,   CAMPO65,   CAMPO66,   CAMPO67,   CAMPO68,   CAMPO69,   CAMPO70,
                     CAMPO71,   CAMPO72,   CAMPO73,   CAMPO74,   CAMPO75,   CAMPO76,   CAMPO77,   CAMPO78,   CAMPO79,   CAMPO80,
                     CAMPO81,   CAMPO82,   CAMPO83,   CAMPO84,   CAMPO85,   CAMPO86,   CAMPO87,   CAMPO88,   CAMPO89,   CAMPO90,
                     CAMPO91,   CAMPO92,   CAMPO93,   CAMPO94,   CAMPO95,   CAMPO96,   CAMPO97,   CAMPO98,   CAMPO99,   CAMPO100,
                     IDENDOSO,             FECANULEXCLU,         MOTIVANULEXCLU,       SUMAASEG_MONEDA,
                     PRIMANETA_MONEDA,     IDENDOSOEXCLU,        MONTOAPORTEASEG,      INDAJUSUMAASEGDECL)
                  VALUES
                    (P.CODCIA,             nIdPoliza,            P.IDETPOL,            P.COD_ASEGURADO,      'SOL',         
                     P.SUMAASEG * nTasaCambio,        P.PRIMANETA * nTasaCambio,
                     P.CAMPO1,  P.CAMPO2,  P.CAMPO3,  P.CAMPO4,  P.CAMPO5,  P.CAMPO6,  P.CAMPO7,  P.CAMPO8,  P.CAMPO9,  P.CAMPO10,
                     P.CAMPO11, P.CAMPO12, P.CAMPO13, P.CAMPO14, P.CAMPO15, P.CAMPO16, P.CAMPO17, P.CAMPO18, P.CAMPO19, P.CAMPO20,
                     P.CAMPO21, P.CAMPO22, P.CAMPO23, P.CAMPO24, P.CAMPO25, P.CAMPO26, P.CAMPO27, P.CAMPO28, P.CAMPO29, P.CAMPO30,
                     P.CAMPO31, P.CAMPO32, P.CAMPO33, P.CAMPO34, P.CAMPO35, P.CAMPO36, P.CAMPO37, P.CAMPO38, P.CAMPO39, P.CAMPO40,
                     P.CAMPO41, P.CAMPO42, P.CAMPO43, P.CAMPO44, P.CAMPO45, P.CAMPO46, P.CAMPO47, P.CAMPO48, P.CAMPO49, P.CAMPO50,
                     P.CAMPO51, P.CAMPO52, P.CAMPO53, P.CAMPO54, P.CAMPO55, P.CAMPO56, P.CAMPO57, P.CAMPO58, P.CAMPO59, P.CAMPO60,
                     P.CAMPO61, P.CAMPO62, P.CAMPO63, P.CAMPO64, P.CAMPO65, P.CAMPO66, P.CAMPO67, P.CAMPO68, P.CAMPO69, P.CAMPO70,
                     P.CAMPO71, P.CAMPO72, P.CAMPO73, P.CAMPO74, P.CAMPO75, P.CAMPO76, P.CAMPO77, P.CAMPO78, P.CAMPO79, P.CAMPO80,
                     P.CAMPO81, P.CAMPO82, P.CAMPO83, P.CAMPO84, P.CAMPO85, P.CAMPO86, P.CAMPO87, P.CAMPO88, P.CAMPO89, P.CAMPO90,
                     P.CAMPO91, P.CAMPO92, P.CAMPO93, P.CAMPO94, P.CAMPO95, P.CAMPO96, P.CAMPO97, P.CAMPO98, P.CAMPO99, P.CAMPO100,
                     0,                    '',                   '',                   P.SUMAASEG_MONEDA,
                     P.PRIMANETA_MONEDA,   0,                    '',                   '');
                EXCEPTION
                  WHEN OTHERS THEN
                       CMENSAJE_SALIDA := ' - T_ASEGURADO_CERTIFICADO ';
                       RAISE_APPLICATION_ERROR(-20206,' T_ASEGURADO_CERTIFICADO ');
                END;    
                --
                IF OC_TIPOS_DE_SEGUROS.MANEJA_FONDOS(nCodCia, nCodEmpresa, CIDTIPOSEG) = 'S' THEN  
                   IF GT_FAI_TIPOS_FONDOS_PRODUCTOS.FONDOS_COLECTIVOS(nCodCia, nCodEmpresa, CIDTIPOSEG, cPlanCob) = 'N' THEN  
                      GT_FAI_FONDOS_DETALLE_POLIZA.RENOVAR(nCodCia, nCodEmpresa, nIdPolizaRen, P.IDetPol, P.Cod_Asegurado, nIdPoliza);
                   END IF;
                END IF;              
                --     
            END LOOP;
            --
            -- INSERTA INDIVIDUAL
            --
            FOR Z IN COBASEGCERT_Q LOOP
                BEGIN
                  INSERT INTO COBERT_ACT_ASEG            
                    (CODEMPRESA,            CODCIA,                IDPOLIZA,              IDETPOL,
                     IDTIPOSEG,             TIPOREF,               NUMREF,                CODCOBERT,
                     SUMAASEG_LOCAL,                               SUMAASEG_MONEDA,       TASA,                  PRIMA_MONEDA,
                     --
                     PRIMA_LOCAL,                                  IDENDOSO,              STSCOBERTURA,          PLANCOB,
                     COD_MONEDA,            DEDUCIBLE_LOCAL,       DEDUCIBLE_MONEDA,      COD_ASEGURADO,
                     INDCAMBIOSAMI,         SUMAASEGORIGEN,        PRIMANIVMONEDA,        PRIMANIVLOCAL,
                     --
                     SALARIOMENSUAL,        VECESSALARIO,          SUMAASEGCALCULADA,     EDAD_MINIMA,
                     EDAD_MAXIMA,           EDAD_EXCLUSION,        SUMAASEG_MINIMA,       SUMAASEG_MAXIMA,
                     PORCEXTRAPRIMADET,     MONTOEXTRAPRIMADET,    SUMAINGRESADA)
                  VALUES
                    (Z.CODEMPRESA,          Z.CODCIA,              nIdPoliza,             Z.IDETPOL,
                     Z.IDTIPOSEG,           Z.TIPOREF,             Z.NUMREF,              Z.CODCOBERT,
                     Z.SUMAASEG_LOCAL * nTasaCambio,               Z.SUMAASEG_MONEDA,     Z.TASA,                Z.PRIMA_MONEDA,
                     --
                     Z.PRIMA_LOCAL * nTasaCambio,                  Z.IDENDOSO,            'SOL',                 Z.PLANCOB,
                     Z.COD_MONEDA,          Z.DEDUCIBLE_LOCAL * nTasaCambio,              Z.DEDUCIBLE_MONEDA,    Z.COD_ASEGURADO,
                     Z.INDCAMBIOSAMI,       Z.SUMAASEGORIGEN,      Z.PRIMANIVMONEDA,      Z.PRIMANIVLOCAL * nTasaCambio,
                     --
                     Z.SALARIOMENSUAL,      Z.VECESSALARIO,        Z.SUMAASEGCALCULADA,   Z.EDAD_MINIMA,
                     Z.EDAD_MAXIMA,         Z.EDAD_EXCLUSION,      Z.SUMAASEG_MINIMA,     Z.SUMAASEG_MAXIMA,
                     Z.PORCEXTRAPRIMADET,   Z.MONTOEXTRAPRIMADET,  Z.SUMAINGRESADA);
                EXCEPTION
                  WHEN OTHERS THEN
                       CMENSAJE_SALIDA := ' - T_COBERT_ACT_ASEG ';
                       RAISE_APPLICATION_ERROR(-20206,' T_COBERT_ACT_ASEG ');
                END;    
            END LOOP;
         END IF;
     END LOOP;
  END IF;
  --
  -- Beneficiarios de Detalles de Póliza
  --
  FOR B IN BENEF_Q LOOP
      BEGIN
        INSERT INTO BENEFICIARIO
          (IDPOLIZA,      IDETPOL,         COD_ASEGURADO,     BENEF,
           NOMBRE,        PORCEPART,       CODPARENT,         ESTADO, 
           SEXO,          FECESTADO,       FECALTA,           FECBAJA, 
           MOTBAJA,       OBERVACIONES,    FECNAC,            INDIRREVOCABLE)
        VALUES
          (nIdPoliza,     B.IDETPOL,       B.COD_ASEGURADO,   B.BENEF,
           B.NOMBRE,      B.PORCEPART,     B.CODPARENT,       'ACTIVO', 
           B.SEXO,        dFecHoy,         dFecIni,           '', 
           '',            B.OBERVACIONES,  B.FECNAC,          B.INDIRREVOCABLE);
      EXCEPTION
        WHEN OTHERS THEN
             CMENSAJE_SALIDA := ' - T_BENEFICIARIO ';
             RAISE_APPLICATION_ERROR(-20206,' T_BENEFICIARIO ');
      END;    
      --
  END LOOP;
  --
  FOR AD IN ASIST_DET LOOP
      BEGIN
        INSERT INTO ASISTENCIAS_DETALLE_POLIZA
          (CODCIA,                  CODEMPRESA,             IDPOLIZA,
           IDETPOL,                 CODASISTENCIA,          CODMONEDA,
           MONTOASISTLOCAL,                                 MONTOASISTMONEDA,
           STSASISTENCIA,           FECSTS,                 IDENDOSO)
        VALUES
          (AD.CODCIA,               AD.CODEMPRESA,          nIdPoliza,
           AD.IDETPOL,              AD.CODASISTENCIA,       AD.CODMONEDA,
           AD.MONTOASISTLOCAL * nTasaCambio,                AD.MONTOASISTMONEDA,
           'SOLICI',                TRUNC(SYSDATE),         0);
      EXCEPTION
        WHEN OTHERS THEN
             CMENSAJE_SALIDA := ' - T_OC_ASISTENCIAS_DETALLE_POLIZA ';
             RAISE_APPLICATION_ERROR(-20206,' T_OC_ASISTENCIAS_DETALLE_POLIZA ');
      END;    
  END LOOP;
/*  FOR AC IN ASIST_CER LOOP
      BEGIN
        INSERT INTO ASISTENCIAS_ASEGURADO
          (CODCIA,                CODEMPRESA,          IDPOLIZA,        IDETPOL,
           COD_ASEGURADO,         CODASISTENCIA,       CODMONEDA,       MONTOASISTLOCAL,
           MONTOASISTMONEDA,      STSASISTENCIA,       FECSTS,          IDENDOSO)
         VALUES
          (AC.CODCIA,             AC.CODEMPRESA,       nIdPoliza,       AC.IDETPOL,
           AC.COD_ASEGURADO,      AC.CODASISTENCIA,    AC.CODMONEDA,    AC.MONTOASISTLOCAL,
           AC.MONTOASISTMONEDA,   'XRENOV',            TRUNC(SYSDATE),  0);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             CMENSAJE_SALIDA := ' - 9.2 T_OC_ASISTENCIAS_ASEGURADO ';
             RAISE_APPLICATION_ERROR(-20206,' T_OC_ASISTENCIAS_ASEGURADO ');
        WHEN TOO_MANY_ROWS THEN
             CMENSAJE_SALIDA := ' - 9.3 T_OC_ASISTENCIAS_ASEGURADO ';
             RAISE_APPLICATION_ERROR(-20206,' T_OC_ASISTENCIAS_ASEGURADO ');
        WHEN OTHERS THEN
             CMENSAJE_SALIDA := ' - 9.5 T_OC_ASISTENCIAS_ASEGURADO ';
             RAISE_APPLICATION_ERROR(-20206,' T_OC_ASISTENCIAS_ASEGURADO ');
      END;
  END LOOP;
*/  --
  FOR W IN DET_REN_Q LOOP
      BEGIN
        OC_DETALLE_POLIZA.ACTUALIZA_VALORES(nCodCia, nIdPoliza, W.IDetPol, 0);
      EXCEPTION
        WHEN OTHERS THEN
             CMENSAJE_SALIDA := ' - P_OC_DETALLE_POLIZA ';
             RAISE_APPLICATION_ERROR(-20206,' P_OC_DETALLE_POLIZA ');   
      END;    
  END LOOP;
  --
  BEGIN
    OC_POLIZAS.ACTUALIZA_VALORES(nCodCia, nIdPoliza, 0);
  EXCEPTION
    WHEN OTHERS THEN
         CMENSAJE_SALIDA := ' - P_OC_POLIZAS ';
         RAISE_APPLICATION_ERROR(-20206,' P_OC_POLIZAS ');   
  END;    
  --
  -- REGISTRA MOVIMIENTO DE RENOVACION
  --
  BEGIN
    INSERT INTO RENOVACIONES
      (CODCIA,          CODEMPRESA, IDPOLIZA,       /*NUMPOLUNICO,*/       NUMRENOV,
       FECRENOVACION,      IDPOLIZAREN,  --NUMPOLUNICO_REN,   NUMRENOV_REN,
       FECRENOVACIONREN,  TIPOMOVTO,        FECPROCESO,        USUARIOPROCESO)
    VALUES
      (nCodCia,            1, nIdPolizaRen,    /*CNUMPOLUNICO_ACT,*/  NNUMRENOV - 1,
       dFecIni,            nIdPoliza,       --cNumPolUnico,      NNUMRENOV,
       dFecFin,            CTP_MOVTO,       dFecHoy,           USER);
  EXCEPTION
    WHEN OTHERS THEN
         CMENSAJE_SALIDA := ' - T_RENOVACIONES ';
         RAISE_APPLICATION_ERROR(-20206,' T_RENOVACIONES ');   
  END;    
  --
  -- ACTUALIZA POLIZA QUE SE RENOVA
  --
  BEGIN
    UPDATE POLIZAS
       SET StsPoliza = 'REN',
           FecSts    = dFecHoy
     WHERE IdPoliza  = nIdPolizaRen
       AND CodCia    = nCodCia;
    --
    UPDATE DETALLE_POLIZA
       SET StsDetalle = 'REN'
     WHERE IdPoliza  = nIdPolizaRen
       AND CodCia    = nCodCia;
    --
    UPDATE COBERT_ACT
       SET StsCobertura = 'REN'
     WHERE IdPoliza     = nIdPolizaRen
       AND CodCia       = nCodCia;
    --
    UPDATE COBERTURAS
       SET StsCobertura = 'REN'
     WHERE IdPoliza     = nIdPolizaRen
       AND CodCia       = nCodCia;
    --
    UPDATE ASISTENCIAS_DETALLE_POLIZA
       SET StsAsistencia = 'RENOVA'
     WHERE IdPoliza     = nIdPolizaRen
      AND CodCia       = nCodCia;
    --
    UPDATE COBERT_ACT_ASEG
       SET StsCobertura = 'REN'
     WHERE IdPoliza     = nIdPolizaRen
       AND CodCia       = nCodCia;
    --
    UPDATE COBERTURA_ASEG
       SET StsCobertura = 'REN'
     WHERE IdPoliza     = nIdPolizaRen
       AND CodCia       = nCodCia;
    --
    UPDATE ASISTENCIAS_ASEGURADO
       SET StsAsistencia = 'RENOVA'
     WHERE IdPoliza     = nIdPolizaRen
       AND CodCia       = nCodCia;
    --
    UPDATE ASEGURADO_CERTIFICADO
       SET Estado = 'REN'
     WHERE IdPoliza     = nIdPolizaRen
       AND CodCia       = nCodCia;
    --
    UPDATE CLAUSULAS_POLIZA
       SET Estado = 'RENOVA'
     WHERE IdPoliza     = nIdPolizaRen
       AND CodCia       = nCodCia;
    --
    UPDATE CLAUSULAS_DETALLE
       SET Estado = 'RENOVA'
     WHERE IdPoliza     = nIdPolizaRen
       AND CodCia       = nCodCia;
    --
    UPDATE BENEFICIARIO 
       SET Estado = 'RENOVA'
     WHERE IdPoliza     = nIdPolizaRen;
    --
  EXCEPTION
    WHEN OTHERS THEN
         CMENSAJE_SALIDA := ' - T_UPDATES ';
         RAISE_APPLICATION_ERROR(-20206,' T_UPDATES ');   
  END;    
  NPOLIZA_SALIDA  := nIdPoliza;
  --
EXCEPTION
   WHEN OTHERS THEN
        CMENSAJE_SALIDA := CMENSAJE_SALIDA||' - LA POLIZA NO SE PROCESO DE MANERA CORRECTA';
        RAISE_APPLICATION_ERROR(-20205,CMENSAJE_SALIDA);
END RENOVAR;          --01/12/2019  RENOV

   PROCEDURE SELECCIONAR_POLIZAS( nCodCia        NUMBER
                                , nCodEmpresa    NUMBER
                                , dFecEjecucion  DATE ) IS
      nDiaEjecucion  NUMBER(2) := TO_NUMBER(TO_CHAR(dFecEjecucion, 'DD'));
      nMesEjecucion  NUMBER(2) := TO_NUMBER(TO_CHAR(dFecEjecucion, 'MM'));
      nAnoEjecucion  NUMBER(4) := TO_NUMBER(TO_CHAR(dFecEjecucion, 'YYYY'));
      nMesSeleccion  NUMBER(2);
      nAnoSeleccion  NUMBER(4);
      dFechaDesde    DATE;
      dFechaHasta    DATE;
   BEGIN
      IF nMesEjecucion = 12 THEN
         nMesSeleccion := 1;
         nAnoSeleccion := nAnoEjecucion + 1;
      ELSE
         nMesSeleccion := nMesEjecucion + 1;
         nAnoSeleccion := nAnoEjecucion;
      END IF;
      --
      --El día 1 se libera reporte con las pólizas a renovar entre el 1 y el 14 del siguiente mes
      --El día 15 se libera reporte con las pólizas a renovar entre el 15 y el 31 del siguiente mes
      --
      IF nDiaEjecucion = 1 THEN
         dFechaDesde := TO_DATE('01-'|| TRIM(TO_CHAR(nMesSeleccion, '00')) || '-' || TRIM(TO_CHAR(nAnoSeleccion, '0000')), 'DD-MM-YYYY');
         dFechaHasta := TO_DATE('14-'|| TRIM(TO_CHAR(nMesSeleccion, '00')) || '-' || TRIM(TO_CHAR(nAnoSeleccion, '0000')), 'DD-MM-YYYY');
      ELSE
         dFechaDesde := TO_DATE('15-'|| TRIM(TO_CHAR(nMesSeleccion, '00')) || '-' || TRIM(TO_CHAR(nAnoSeleccion, '0000')), 'DD-MM-YYYY');
         dFechaHasta := LAST_DAY(TO_DATE('15-'|| TRIM(TO_CHAR(nMesSeleccion, '00')) || '-' || TRIM(TO_CHAR(nAnoSeleccion, '0000')), 'DD-MM-YYYY'));
      END IF;
      --
      INSERT INTO RENOVACIONES
      SELECT p.CodCia
           , p.CodEmpresa
           , p.IdPoliza
           , p.NumRenov
           , p.FecRenovacion
           , p.StsPoliza
           , p.Num_Cotizacion
           , p.Cod_Agente
           , SYSDATE    FechaProceso
           , NULL       IndRenovable
           , NULL       CodMotivoRechazo
           , NULL       IdPolizaRen
           , NULL       FecRenovacionRen
           , NULL       IdCotizacionRen
           , NULL       FecProcWeb
           , NULL       StsProcWeb
           , NULL       FecRespWeb
           , NULL       IndRespCte
           , NULL       FecRenPag
           , 'RENWEB'   TipoMovto
           , USER       UsuarioProceso
      FROM   POLIZAS       p
         ,   COTIZACIONES  c
      WHERE  p.CodCia           = nCodCia 
        AND  p.CodEmpresa       = nCodEmpresa
        AND  p.FecRenovacion   >= dFechaDesde
        AND  p.FecRenovacion   <= dFechaHasta
        AND  c.IdCotizacion     = p.Num_Cotizacion
        AND  c.IndCotizacionWeb = 'S'
        AND  ( ( p.StsPoliza = 'EMI' )
               OR
               ( p.StsPoliza = 'ANU' AND ( p.FecAnul > ( dFechaDesde - 46 )) AND p.MotivAnul IN ('FPA', 'CAFP' ))
             ) 
        AND  EXISTS ( SELECT 'S'
                      FROM   DETALLE_POLIZA                 d
                         ,   AGENTES_DISTRIBUCION_COMISION  a
                      WHERE  a.IDetPol  = d.IDetPol
                        AND  a.IdPoliza = d.IdPoliza
                        AND  a.CodCia   = d.CodCia
                        AND  d.IdPoliza = p.IdPoliza
                        AND  d.CodCia   = p.CodCia )
      ORDER BY p.FecRenovacion;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL SELECCIONAR LAS POLIZAS A RENOVAR: ' || SQLERRM);
   END SELECCIONAR_POLIZAS;

   FUNCTION POLIZAS_A_RENOVAR( nCodCia      RENOVACIONES.CodCia%TYPE
                             , nCodEmpresa  RENOVACIONES.CodEmpresa%TYPE
                             , dFecProceso  RENOVACIONES.FecProceso%TYPE ) RETURN XMLTYPE IS
      xResultado  XMLTYPE;
   BEGIN
      SELECT XMLROOT(
                XMLELEMENT( "DATA",
                   XMLAGG(
                      XMLELEMENT( "POLIZA", 
                         XMLELEMENT("CodCia"          , CodCia),
                         XMLELEMENT("CodEmpresa"      , CodEmpresa),
                         XMLELEMENT("IdPoliza"        , IdPoliza),
                         XMLELEMENT("NumRenov"        , NumRenov),
                         XMLELEMENT("FecRenovacion"   , TO_CHAR(FecRenovacion, 'DD-MM-YYYY')),
                         XMLELEMENT("StsPoliza"       , StsPoliza),
                         XMLELEMENT("Num_Cotizacion"  , Num_Cotizacion),
                         XMLELEMENT("Cod_Agente"      , Cod_Agente),
                         XMLELEMENT("FecProceso"      , TO_CHAR(FecProceso, 'DD-MM-YYYY')),
                         XMLELEMENT("IndRenovable"    , IndRenovable),
                         XMLELEMENT("CodMotivoRechazo", CodMotivoRechazo),
                         XMLELEMENT("IdPolizaRen"     , IdPolizaRen),
                         XMLELEMENT("FecRenovacionRen", TO_CHAR(FecRenovacionRen, 'DD-MM-YYYY')),
                         XMLELEMENT("IdCotizacionRen" , IdCotizacionRen),
                         XMLELEMENT("FecProcWeb"      , TO_CHAR(FecProcWeb, 'DD-MM-YYYY')),
                         XMLELEMENT("StsProcWeb"      , StsProcWeb),
                         XMLELEMENT("FecRespWeb"      , TO_CHAR(FecRespWeb, 'DD-MM-YYYY')),
                         XMLELEMENT("IndRespcte"      , IndRespcte),
                         XMLELEMENT("FecRenPag"       , TO_CHAR(FecRenPag, 'DD-MM-YYYY')),
                         XMLELEMENT("TipoMovto"       , TipoMovto),
                         XMLELEMENT("UsuarioProceso"  , UsuarioProceso)
                                )
                         ) 
                    ), VERSION '1.0" encoding="UTF-8')
      INTO   xResultado
      FROM   RENOVACIONES
      WHERE  CodCia            = nCodCia
        AND  CodEmpresa        = nCodEmpresa
        AND  TRUNC(FecProceso) = TRUNC(dFecProceso);
      --
      RETURN xResultado;
   EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
   END POLIZAS_A_RENOVAR;

   PROCEDURE ACTUALIZAR_INFORMACION( nCodCia       RENOVACIONES.CodCia%TYPE
                                   , nCodEmpresa   RENOVACIONES.CodEmpresa%TYPE
                                   , nIdPoliza     RENOVACIONES.IdPoliza%TYPE
                                   , nNumRenov     RENOVACIONES.NumRenov%TYPE
                                   , xGenerales    XMLTYPE ) IS
      nIdPolizaRen       RENOVACIONES.IdPolizaRen%TYPE;
      dFecRenovacionRen  RENOVACIONES.FecRenovacionRen%TYPE;
      nIdCotizacionRen   RENOVACIONES.IdCotizacionRen%TYPE;
      dFecProcWeb        RENOVACIONES.FecProcWeb%TYPE;
      cStsProcWeb        RENOVACIONES.StsProcWeb%TYPE;
      dFecRespWeb        RENOVACIONES.FecRespWeb%TYPE;
      cIndRespCte        RENOVACIONES.IndRespCte%TYPE;
      dFecRenPag         RENOVACIONES.FecRenPag%TYPE;
      --
      CURSOR cGenRenovacion IS
         WITH
         RENOVACION_DATA AS ( SELECT GEN.*
                              FROM   XMLTABLE('/DATA'
                                 PASSING xGenerales
                                     COLUMNS 
                                     IdPolizaRen       NUMBER(14,0)  PATH 'IdPolizaRen',
                                     FecRenovacionRen  VARCHAR2(19)  PATH 'FecRenovacionRen',
                                     IdCotizacionRen   NUMBER(14,0)  PATH 'IdCotizacionRen',
                                     FecProcWeb        VARCHAR2(19)  PATH 'FecProcWeb',
                                     StsProcWeb        VARCHAR2(3)   PATH 'StsProcWeb',
                                     FecRespWeb        VARCHAR2(19)  PATH 'FecRespWeb',
                                     IndRespCte        VARCHAR2(1)   PATH 'IndRespCte',
                                     FecRenPag         VARCHAR2(19)  PATH 'FecRenPag') GEN
                            )
         SELECT * FROM RENOVACION_DATA;
   BEGIN
      FOR x IN cGenRenovacion LOOP
         IF x.IdPolizaRen IS NOT NULL THEN
            nIdPolizaRen := x.IdPolizaRen;
         END IF;
         --
         IF x.FecRenovacionRen IS NOT NULL THEN
            dFecRenovacionRen := TO_DATE(x.FecRenovacionRen, 'DD-MM-RRRR HH24:MI:SS');
         END IF;
         --
         IF x.IdCotizacionRen IS NOT NULL THEN
            nIdCotizacionRen := x.IdCotizacionRen;
         END IF;
         --
         IF x.FecProcWeb IS NOT NULL THEN
            dFecProcWeb := TO_DATE(x.FecProcWeb, 'DD-MM-RRRR HH24:MI:SS');
         END IF;
         --
         IF x.StsProcWeb IS NOT NULL THEN
            cStsProcWeb := x.StsProcWeb;
         END IF;
         --
         IF x.FecRespWeb IS NOT NULL THEN
            dFecRespWeb := TO_DATE(x.FecRespWeb, 'DD-MM-RRRR HH24:MI:SS');
         END IF;
         --
         IF x.IndRespCte IS NOT NULL THEN
            cIndRespCte := x.IndRespCte;
         END IF;
         --
         IF x.FecRenPag IS NOT NULL THEN
            dFecRenPag := TO_DATE(x.FecRenPag, 'DD-MM-RRRR HH24:MI:SS');
         END IF;
         --
      END LOOP;
      --
      UPDATE RENOVACIONES
      SET    IdPolizaRen      = NVL( nIdPolizaRen, IdPolizaRen )
        ,    FecRenovacionRen = NVL( dFecRenovacionRen, FecRenovacionRen )
        ,    IdCotizacionRen  = NVL( nIdCotizacionRen, IdCotizacionRen )
        ,    FecProcWeb       = NVL( dFecProcWeb, FecProcWeb )
        ,    StsProcWeb       = NVL( cStsProcWeb, StsProcWeb )
        ,    FecRespWeb       = NVL( dFecRespWeb, FecRespWeb )
        ,    IndRespCte       = NVL( cIndRespCte, IndRespCte )
        ,    FecRenPag        = NVL( dFecRenPag, FecRenPag )
      WHERE  CodCia     = nCodCia
        AND  CodEmpresa = nCodEmpresa
        AND  IdPoliza   = nIdPoliza
        AND  NumRenov   = nNumRenov;
      --
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20205, 'ERROR AL ACTUZALIZAR INFORMACION GENERAL DE LA POLIZA A RENOVAR: ' || SQLERRM);
   END ACTUALIZAR_INFORMACION;

   PROCEDURE APLICAR_CRITERIOS_RENOVACION( nCodCia      RENOVACIONES.CodCia%TYPE
                                         , nCodEmpresa  RENOVACIONES.CodEmpresa%TYPE
                                         , dFecProceso  RENOVACIONES.FecProceso%TYPE ) IS
      nIDetPol                  DETALLE_POLIZA.IDetPol%TYPE;
      nIdTipoSeg                DETALLE_POLIZA.IdTipoSeg%TYPE;
      cPlanCob                  DETALLE_POLIZA.PlanCob%TYPE;
      nCodAsegurado             DETALLE_POLIZA.Cod_Asegurado%TYPE;
      cCodRamo                  VARCHAR2(500);
      cDescRamo                 VARCHAR2(500);
      cDescPaquete              PAQUETE_COMERCIAL.DescPaquete%TYPE;
      nCodPaquete               PAQUETE_COMERCIAL.CodPaquete%TYPE;
      nEdadLimite               CRITERIOS_RENOVACION.EdadLimite%TYPE;
      cSujetoEdadLimite         CRITERIOS_RENOVACION.SujetoEdadLimite%TYPE;
      cTipoSiniestro            CRITERIOS_RENOVACION.TipoSiniestro%TYPE;
      cCodMotivoRechazo         RENOVACIONES.CodMotivoRechazo%TYPE;
      cIndRenovable             RENOVACIONES.IndRenovable%TYPE;
      nEdadAsegurado            NUMBER;
      nEdadDependiente          NUMBER;
      nTotSiniestros            NUMBER;
      nTocCodCobert             NUMBER;
      cHayIdTipoSeg             VARCHAR2(1) := 'N';
      cHayCodRamo               VARCHAR2(1) := 'N';
      cHayCodPaquete            VARCHAR2(1) := 'N';
      cHayCodCobert             VARCHAR2(1) := 'N';
      cSuperaEdad               VARCHAR2(1) := 'N';
      cContinuo                 VARCHAR2(1) := 'S';
      --
      CURSOR c_Polizas IS
         SELECT IdPoliza
              , NumRenov
              , FecRenovacion
         FROM   RENOVACIONES
         WHERE  CodCia            = nCodCia 
           AND  CodEmpresa        = nCodEmpresa
           AND  TRUNC(FecProceso) = TRUNC(dFecProceso)
         ORDER BY FecRenovacion;
      --
      CURSOR c_TipoSeguro( pIdTipoSeg  CRITERIOS_RENOVACION.IdTipoSeg%TYPE ) IS
         SELECT 'S'
         FROM   CRITERIOS_RENOVACION
         WHERE  IdTipoSeg = pIdTipoSeg;
      --
      CURSOR c_Ramo( pIdTipoSeg  CRITERIOS_RENOVACION.IdTipoSeg%TYPE
                   , pCodRamo   CRITERIOS_RENOVACION.CodRamo%TYPE ) IS
         SELECT 'S'
         FROM   CRITERIOS_RENOVACION
         WHERE  IdTipoSeg = pIdTipoSeg
           AND  CodRamo   = pCodRamo;
      --
      CURSOR c_Paquete( pIdTipoSeg   CRITERIOS_RENOVACION.IdTipoSeg%TYPE
                      , pCodRamo     CRITERIOS_RENOVACION.CodRamo%TYPE
                      , pCodPaquete  CRITERIOS_RENOVACION.Codpaquete%TYPE ) IS
         SELECT 'S'
         FROM   CRITERIOS_RENOVACION
         WHERE  IdTipoSeg  = pIdTipoSeg
           AND  CodRamo    = pCodRamo
           AND  CodPaquete = pCodPaquete;
      --
      CURSOR c_Edad( pIdTipoSeg   CRITERIOS_RENOVACION.IdTipoSeg%TYPE
                   , pCodRamo     CRITERIOS_RENOVACION.CodRamo%TYPE
                   , pCodPaquete  CRITERIOS_RENOVACION.Codpaquete%TYPE ) IS
         SELECT DISTINCT EdadLimite, SujetoEdadLimite
         FROM   CRITERIOS_RENOVACION
         WHERE  IdTipoSeg  = pIdTipoSeg
           AND  CodRamo    = pCodRamo
           AND  CodPaquete = pCodPaquete;
      --
      CURSOR c_Siniestros( pIdPoliza  POLIZAS.IdPoliza%TYPE ) IS
         SELECT COUNT(*)
         FROM   SINIESTRO
         WHERE  IdPoliza = pIdPoliza;
      --
      CURSOR c_TipoSiniestro( pIdTipoSeg   CRITERIOS_RENOVACION.IdTipoSeg%TYPE
                            , pCodRamo     CRITERIOS_RENOVACION.CodRamo%TYPE
                            , pCodPaquete  CRITERIOS_RENOVACION.Codpaquete%TYPE ) IS
         SELECT TipoSiniestro
         FROM   CRITERIOS_RENOVACION
         WHERE  IdTipoSeg  = pIdTipoSeg
           AND  CodRamo    = pCodRamo
           AND  CodPaquete = pCodPaquete;
      --
      CURSOR c_CodCobert( pTipoSiniestro  TIPOS_SINIESTRO_RENOVACION.TipoSiniestro%TYPE ) IS
         SELECT 'S'
         FROM   TIPOS_SINIESTRO_RENOVACION
         WHERE  TipoSiniestro = pTipoSiniestro;
      --
      CURSOR c_SiniestroCoberturas( pTipoSiniestro  TIPOS_SINIESTRO_RENOVACION.TipoSiniestro%TYPE
                                  , pIdPoliza       COBERTURA_SINIESTRO.IdPoliza%TYPE
                                  , pIDetPol        COBERTURA_SINIESTRO.IdDetSin%TYPE ) IS
         SELECT COUNT(*)
         FROM   TIPOS_SINIESTRO_RENOVACION TPR
            ,   COBERTURA_SINIESTRO        CS
         WHERE  TPR.TipoSiniestro = pTipoSiniestro
           AND  TPR.CodCobert     = CS.CodCObert
           AND  CS.IdPoliza       = pIdPoliza
           AND  CS.IdDetSin       = pIDetPol;
   BEGIN
      FOR x IN c_Polizas LOOP
         --Inicializo Varriables de Trabajo
         cContinuo         := 'S';
         cIndRenovable     := 'S';
         cCodMotivoRechazo := NULL;
         cHayIdTipoSeg     := 'N';
         cHayCodRamo       := 'N';
         cHayCodPaquete    := 'N';
         cHayCodCobert     := 'N';
         cSuperaEdad       := 'N';
         nEdadasegurado    := 0;
         nEdadDependiente  := 0;
         nTotSiniestros    := 0;
         nTocCodCobert     := 0;
         cTipoSiniestro    := NULL;
         --
         SELECT MAX(IDetPol)
         INTO   nIDetPol
         FROM   DETALLE_POLIZA
         WHERE  CodCia     = nCodCia
           AND  CodEmpresa = nCodEmpresa
           AND  IdPoliza   = x.IdPoliza;
         --
         SELECT IdTipoSeg , PlanCob , Cod_Asegurado, OC_PLAN_COBERTURAS.CODIGO_SUBRAMO(nCodCia, nCodEmpresa, IdTipoSeg, PlanCob)
         INTO   nIdTipoSeg, cPlanCob, nCodAsegurado, cCodRamo
         FROM   DETALLE_POLIZA
         WHERE  CodCia     = nCodCia
           AND  CodEmpresa = nCodEmpresa
           AND  IdPoliza   = x.IdPoliza
           AND  IDetPol    = nIDetPol;
         --
         SELECT pc.DescPaquete, p.CodPaqComercial
         INTO   cDescPaquete  , nCodPaquete
         FROM   POLIZAS            p
            ,   PAQUETE_COMERCIAL  pc
         WHERE  p.CodCia         = nCodCia
           AND  p.CodEmpresa     = nCodEmpresa
           AND  p.IdPoliza       = x.IdPoliza
           AND  p.NumRenov       = x.NumRenov
           AND  pc.CodCia(+)     = p.CodCia
           AND  pc.CodEmpresa(+) = p.CodEmpresa
           AND  pc.CodPaquete(+) = p.CodPaqComercial
           AND  pc.IdTipoSeg(+)  = nIdTipoSeg
           AND  pc.PlanCob(+)    = cPlanCob;
         --
         IF cContinuo = 'S' THEN
            OPEN c_TipoSeguro( nIdTipoSeg );
            FETCH c_TipoSeguro INTO cHayIdTipoSeg;
            CLOSE c_TipoSeguro;
            --
            IF cHayIdTipoSeg = 'N' THEN
               cContinuo         := 'N';
               cCodMotivoRechazo := '001'; --ESTE TIPO DE SEGURO NO ESTA CONFIGURADO EN LA TABLA CRITERIOS_RENOVACION
            END IF;
         END IF;
         --
         IF cContinuo = 'S' THEN
            OPEN c_Ramo( nIdTipoSeg, cCodRamo );
            FETCH c_Ramo INTO cHayCodRamo;
            CLOSE c_Ramo;
            --
            IF cHayCodRamo = 'N' THEN
               cContinuo         := 'N';
               cCodMotivoRechazo := '002'; --ESTE RAMO NO ESTA CONFIGURADO EN LA TABLA CRITERIOS_RENOVACION
            END IF;
         END IF;
         --
         IF cContinuo = 'S' THEN
            OPEN c_Paquete( nIdTipoSeg, cCodRamo, nCodPaquete );
            FETCH c_Paquete INTO cHayCodPaquete;
            CLOSE c_Paquete;
            --
            IF cHayCodPaquete = 'N' THEN
               cContinuo         := 'N';
               cCodMotivoRechazo := '003'; --ESTE PAQUETE COMERCIAL NO ESTA CONFIGURADO EN LA TABLA CRITERIOS_RENOVACION
            END IF;
         END IF;
         --
         IF cContinuo = 'S' THEN
            OPEN c_Edad( nIdTipoSeg, cCodRamo, nCodPaquete );
            LOOP
               FETCH c_Edad INTO nEdadLimite, cSujetoEdadLimite;
               EXIT WHEN c_Edad%NOTFOUND;
               --
               IF cContinuo = 'S' THEN
                  IF cSujetoEdadLimite = 'A' THEN
                     nEdadAsegurado   := OC_ASEGURADO.EDAD_ASEGURADO( nCodCia, nCodEmpresa, nCodAsegurado, TRUNC(x.FecRenovacion) );
                     IF nEdadAsegurado > nEdadLimite THEN
                        cContinuo         := 'N';
                        cCodMotivoRechazo := '004'; --EDAD DEL ASEGURADO FUERA DEL LIMITE
                     END IF;
                  ELSIF cSujetoEdadLimite = 'D' THEN
                     nEdadDependiente := OC_ASEGURADO.EDAD_ASEGURADO( nCodCia, nCodEmpresa, nCodAsegurado, TRUNC(x.FecRenovacion) );
                     IF nEdadDependiente > nEdadLimite THEN
                        cContinuo         := 'N';
                        cCodMotivoRechazo := '005'; --EDAD DEL DEPENDIENTE FUERA DEL LIMITE
                     END IF;
                  END IF;
               END IF;
               --
            END LOOP;
            CLOSE c_Edad;
         END IF;
         --
         IF cContinuo = 'S' THEN
            OPEN c_Siniestros( x.IdPoliza );
            FETCH c_Siniestros INTO nTotSiniestros;
            CLOSE c_Siniestros;
            --
            IF nTotSiniestros > 0 THEN
               OPEN c_TipoSiniestro( nIdTipoSeg, cCodRamo, nCodPaquete );
               LOOP
                  FETCH c_TipoSiniestro INTO cTipoSiniestro;
                  EXIT WHEN c_TipoSiniestro%NOTFOUND;
                  --
                  IF cContinuo = 'S' THEN
                     IF cTipoSiniestro = '999' THEN
                        cContinuo         := 'N';
                        cCodMotivoRechazo := '006'; --NO RENOVABLE POR SINIESTRO
                     ELSE
                        IF cContinuo = 'S' THEN
                           OPEN c_CodCobert( cTipoSiniestro );
                           FETCH c_CodCobert INTO cHayCodCobert;
                           CLOSE c_CodCobert;
                           --
                           IF cHayCodCobert = 'N' THEN
                              cContinuo         := 'N';
                              cCodMotivoRechazo := '007'; --ESTE PAQUETE COMERCIAL NO ESTA CONFIGURADO EN LA TABLA TIPOS_SINIESTRO_RENOVACION
                           END IF;
                           --
                           IF cContinuo = 'S' THEN
                              OPEN c_SiniestroCoberturas( cTipoSiniestro, x.IdPoliza, nIDetPol );
                              FETCH c_SiniestroCoberturas INTO nTocCodCobert;
                              CLOSE c_SiniestroCoberturas;
                              --
                              IF nTocCodCobert > 0 THEN
                                 cContinuo         := 'N';
                                 cCodMotivoRechazo := '006'; --NO RENOVABLE POR SINIESTRO
                              END IF;
                           END IF;
                        END IF;
                     END IF;
                  END IF;
               END LOOP;
               CLOSE c_TipoSiniestro;
            END IF;
         END IF;
         --
         IF cContinuo = 'S' THEN
            IF OC_FACTURAS.EXISTE_SALDO(nCodCia, x.IdPoliza) = 'S' THEN
               cContinuo         := 'N';
               cCodMotivoRechazo := '008'; --NO RENOVABLE POR FALTA DE PAGO
            END IF;
         END IF;
         --
         IF cContinuo = 'N' THEN
            cIndRenovable := 'N';
         END IF;
         --
         UPDATE RENOVACIONES
         SET    IndRenovable     = cIndRenovable
           ,    CodMotivoRechazo = cCodMotivoRechazo
         WHERE  CodCia     = nCodCia 
           AND  CodEmpresa = nCodEmpresa
           AND  IdPoliza   = x.IdPoliza
           AND  NumRenov   = x.NumRenov;
         --
         COMMIT;
      END LOOP;
   END APLICAR_CRITERIOS_RENOVACION;
   
END OC_RENOVACION;

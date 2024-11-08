create or replace PACKAGE SICAS_OC.REPORTE_SINIESTROS AS
/******************************************************************************
   NAME:       SICAS_OC.REPORTE_SINIESTROS
   PURPOSE:
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        27/03/2023      Usuario       1. Created this package.
******************************************************************************/
PROCEDURE REPORTE_PAGOS_INDIVIDUAL(cNomArchivo VARCHAR2, 
                                   cIdTipoSeg  VARCHAR2, 
                                   cCodMoneda  VARCHAR2, 
                                   dFecDesde   DATE    ,
                                   dFecHasta   DATE    ,
								   cFormato    VARCHAR2,
								   cCODCIA	   NUMBER,
								   cCODEMPRESA NUMBER,
								   cautoriza VARCHAR2,
								   nIdReporte   NUMBER);
PROCEDURE REPORTE_POLIZA  (cNomArchivo VARCHAR2, nIdPoliza   VARCHAR2,cFormato    VARCHAR2,nIdReporte   NUMBER);
PROCEDURE SINIESTROS_DEL_MES (cNomArchivo VARCHAR2, 
                              cIdTipoSeg  VARCHAR2, 
                              cCodMoneda  VARCHAR2, 
                              dFecDesde   DATE    ,
                              dFecHasta   DATE    ,
                              cFormato    VARCHAR2,
                              nIdReporte   NUMBER);
FUNCTION FUNC_CODPOSTAL(p_Postal VARCHAR2) RETURN  VARCHAR2;
FUNCTION FUNC_PAIS(p_Pais VARCHAR2) RETURN  VARCHAR2;
FUNCTION FUNC_Provincia(p_Pais VARCHAR2, p_Estado VARCHAR2) RETURN VARCHAR2;
FUNCTION Func_Distrito(p_Pais VARCHAR2, p_Estado VARCHAR2, p_Ciudad VARCHAR2) RETURN  VARCHAR2;
FUNCTION Func_Corregimiento(p_pais varchar2, p_estado varchar2,
                            p_ciudad varchar2, p_municipio varchar2) return VARCHAR2;
FUNCTION  FUNC_COLONIA(p_Postal VARCHAR2, p_Colonia VARCHAR2 , p_Codpais varchar2,
								 p_CodEstado varchar2, p_CodCiudad varchar2, p_Codmunicipio varchar2) RETURN  VARCHAR2;
FUNCTION NOMBRE_EMPRESA(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2;
PROCEDURE REPORTE_PAGOS_GG_ALL (cNomArchivo VARCHAR2,cFormato    VARCHAR2,nIdReporte   NUMBER);
PROCEDURE REPORTE_PAGOS_GG (cNomArchivo VARCHAR2,                            
                            dFecDesde   DATE    ,
                            dFecHasta   DATE    ,
                            cFormato    VARCHAR2,
                            nIdReporte   NUMBER) ;
PROCEDURE REPORTE_BUSCA_POLIZAGG  (cNomArchivo VARCHAR2,
                            PolizaGG    VARCHAR2,
                            cFormato    VARCHAR2,
                            nIdReporte   NUMBER);
PROCEDURE REPORTE_FACTURAS(cNomArchivo VARCHAR2, nIdPoliza   NUMBER,cFormato    VARCHAR2,nIdReporte   NUMBER);
PROCEDURE REPORTE_FACTURA_2(cNomArchivo VARCHAR2,nIdFactura   VARCHAR2,cFormato    VARCHAR2,nIdReporte   NUMBER);
PROCEDURE CONCIL_MANPAL(cNomArchivo VARCHAR2,cFormato    VARCHAR2,nIdReporte   NUMBER);
PROCEDURE REPORTE_ASISTENCIADORA(cNomArchivo VARCHAR2,nAsistencia   VARCHAR2,cFormato    VARCHAR2,nIdReporte   NUMBER);
PROCEDURE REPORTE_HOSPITAL(cNomArchivo VARCHAR2,nRFC_HOSPITAL   VARCHAR2,cFormato    VARCHAR2,nIdReporte   NUMBER);
PROCEDURE GENERAR_SINIESTROS (cNomArchivo VARCHAR2, 
                              cIdTipoSeg  VARCHAR2, 
                              cCodMoneda  VARCHAR2,
                              dFecDesde   DATE    ,
                              dFecHasta   DATE    ,
                              cFormato    VARCHAR2,
                              nIdReporte   NUMBER);
PROCEDURE GENERAR_ASEGCSIN (cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cCodMoneda VARCHAR2, 
                            dFecDesde DATE, dFecHasta DATE,cFormato    VARCHAR2,nIdReporte   NUMBER);
PROCEDURE GENERAR_ESTIMADOS_CIERRE(cNomArchivo VARCHAR2, 
                                   cIdTipoSeg  VARCHAR2, 
                                   cCodMoneda  VARCHAR2, 
                                   dFecDesde   DATE    ,
                                   dFecHasta   DATE    ,
                                   cUsuario    VARCHAR2,
                                   cFormato    VARCHAR2,
                                   nIdReporte  NUMBER);
PROCEDURE GENERAR_ESTIMADOS_CIERRE_SOL(cNomArchivo VARCHAR2, 
                                       cIdTipoSeg  VARCHAR2, 
                                       cCodMoneda  VARCHAR2, 
                                       dFecDesde   DATE    ,
                                       dFecHasta   DATE    ,
                                   cUsuario    VARCHAR2,
                                   cFormato    VARCHAR2,
                                   nIdReporte  NUMBER);
PROCEDURE GENERAR_LAYOUT_RES_SOLICITUD(cNomArchivo VARCHAR2, 
                                            DFECDESDE DATE,
                                            DFECHASTA DATE,
                                            CTIPO_MOVTO VARCHAR2,
                                   cFormat    VARCHAR2,
                                   nIdReporte  NUMBER);
PROCEDURE GENERAR_PAGOSSIN_CIERRE(cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cCodMoneda VARCHAR2, 
                                  dFecDesde DATE, dFecHasta DATE, cTipoPago IN VARCHAR2,
                                  cusuario varchar2,cFormato    VARCHAR2,nIdReporte  NUMBER);
PROCEDURE GENERA_GENERICO(cNomArchivo                 VARCHAR2,
                          PFEC_FONDEO_DESDE           DATE,
                          PFEC_FONDEO_HASTA           DATE,
                          PFEC_PAGO_PROGRAMADA_DESDE  DATE,
                          PFEC_PAGO_PROGRAMADA_HASTA  DATE,
                          cFormato    VARCHAR2,nIdReporte  NUMBER);
PROCEDURE GENERA_FONDEO(cNomArchivo      VARCHAR2,
                        FFEC_PROGRAMADA  DATE,
                        PST_FONDEO       VARCHAR2,
                        PUSUARIO_FONDEO  VARCHAR2,
                        PID_GRUPO_FONDEO NUMBER,
                        cFormato    VARCHAR2,nIdReporte  NUMBER);
PROCEDURE GENERA_GENERICO_FIN(cNomArchivo                 VARCHAR2,
                          PFEC_FINIQUITO_DESDE           DATE,
                          PFEC_FINIQUITO_HASTA           DATE,
                          PFEC_PAGO_PROGRAMADA_DESDE  DATE,
                          PFEC_PAGO_PROGRAMADA_HASTA  DATE,
                          cFormato    VARCHAR2,nIdReporte  NUMBER);
PROCEDURE REPORTE_PAGOS_COLECTIVOS (cNomArchivo VARCHAR2, 
                                    cIdTipoSeg  VARCHAR2, 
                                    cCodMoneda  VARCHAR2, 
                                    dFecDesde   DATE    ,
                                    dFecHasta   DATE    ,
                                    cAutoriza varchar2,cFormato    VARCHAR2,nIdReporte  NUMBER);
PROCEDURE DETALLES_MASIVOS (cNomArchivo VARCHAR2, 
                            cRutaCarga  VARCHAR2,
                            cRFC        VARCHAR2,
                            cAutoriza VARCHAR2,cFormato    VARCHAR2,nIdReporte  NUMBER);
PROCEDURE CARGA_MASIVOS (cNomArchivo VARCHAR2, 
                         cRFC        VARCHAR2,
                         cAutoriza VARCHAR2,cFormato    VARCHAR2,nIdReporte  NUMBER);
PROCEDURE GENERAR_PAGOSSIN_CIERRE_SOL (cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cCodMoneda VARCHAR2, 
                                       dFecDesde DATE, dFecHasta DATE, cTipoPago IN VARCHAR2,
                                       cFormato    VARCHAR2,nIdReporte  NUMBER);
FUNCTION VALOR_CAMPO(cCadena  VARCHAR2, nIndice NUMBER, cDelim VARCHAR2) RETURN VARCHAR2;
PROCEDURE GENERAR_LAYOUT_PAG_SOLICITUD(cNomArchivo VARCHAR2, 
                                       DFECDESDE   DATE,
                                       DFECHASTA   DATE,
                                       CTIPO_MOVTO VARCHAR2,
                                       nIdReporte  NUMBER);
PROCEDURE GENERAR_VAL_PROC_MASIVO(cNomArchivo VARCHAR2, 
                                  cIdTipoSeg  VARCHAR2, 
                                  cCodMoneda  VARCHAR2, 
                                  dFecDesde   DATE    ,
                                  dFecHasta   DATE     ,
                                  cFormato    VARCHAR2,
                                  nIdReporte   NUMBER);
PROCEDURE GENERAR_OPC_SINIESTROS(cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cCodMoneda VARCHAR2, 
                                 dFecDesde DATE, dFecHasta DATE,cFormato    VARCHAR2,
                              nIdReporte   NUMBER);
PROCEDURE SINIESTROS_PLD_REPORTADOS(cNomArchivo VARCHAR2, 
                             cIdTipoSeg  VARCHAR2, 
                             cCodMoneda  VARCHAR2, 
                             dFecDesde DATE,    
                             dFecHasta DATE,
                             cFormato    VARCHAR2,
                             nIdReporte   NUMBER);
PROCEDURE GENERAR_SINIESTROS_X_CAUSA (cNomArchivo VARCHAR2, 
                             dFecDesde DATE,    
                             dFecHasta DATE,
                             cFormato Varchar2,
                             nIdReporte NUMBER,
                             cCAUSASIN1 Varchar2,
                             cCAUSASIN2 Varchar2,
                             cCAUSASIN3 Varchar2,
                             cCAUSASIN4 Varchar2,
                             cCAUSASIN5 Varchar2,
                             cCAUSASIN6 Varchar2,
                             cCAUSASIN7 Varchar2,
                             cCAUSASIN8 Varchar2,
                             cCAUSASIN9 Varchar2,
                             cCAUSASIN10 Varchar2);
PROCEDURE PROC_CREA_ARCH_ERRORES(cCadena  VARCHAR2, cFin VARCHAR2, cCodUser IN OUT VARCHAR2, nLinea  IN OUT NUMBER, NIDREPORTE NUMBER);                             
function agente(cTipo_Doc_Identificacion varchar2,cNum_Doc_Identificacion varchar2,nidpoliza number,nidetpol number) return varchar2;

END REPORTE_SINIESTROS;

/

create or replace PACKAGE BODY SICAS_OC.REPORTE_SINIESTROS AS
/******************************************************************************
   NAME:       SICAS_OC.REPORTE_AREA_TECNICA
   PURPOSE:
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        27/03/2023      Usuario       1. Created this package.
******************************************************************************/
FUNCTION VALOR_CAMPO(cCadena  VARCHAR2, nIndice NUMBER, cDelim VARCHAR2) RETURN VARCHAR2 IS
   nPos_Ini   NUMBER;
   nPos_Fin   NUMBER;
BEGIN
   IF nIndice = 1 THEN
      nPos_Ini := 1;
   ELSE
      nPos_Ini := INSTR(cCadena, cDelim, 1, nIndice - 1);
      IF nPos_Ini = 0 THEN
         RETURN NULL;
      ELSE
         nPos_Ini := nPos_Ini + LENGTH(cDelim);
      END IF;
   END IF;
   nPos_Fin := INSTR(cCadena, cDelim, nPos_Ini, 1);
   IF nPos_Fin = 0 THEN
      RETURN SUBSTR(cCadena, nPos_Ini);
   ELSE
      RETURN SUBSTR(cCadena, nPos_Ini, nPos_Fin - nPos_Ini);
   END IF;
END VALOR_CAMPO;
PROCEDURE REPORTE_PAGOS_INDIVIDUAL(cNomArchivo VARCHAR2, 
                                   cIdTipoSeg  VARCHAR2, 
                                   cCodMoneda  VARCHAR2, 
                                   dFecDesde   DATE    ,
                                   dFecHasta   DATE    ,
								   cFormato    VARCHAR2,
								   cCODCIA	   NUMBER,
								   cCODEMPRESA NUMBER,
								   cautoriza VARCHAR2,
								   nIdReporte   NUMBER) IS
--
-- REINGE
-- CAMPOS NUEVOS Y CAMBIO A GRABADO EN TABLA
--
cLimitador      VARCHAR2(1) :='|';
nLinea          NUMBER;
cCadena         VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;
cDESCNOMBRE     VARCHAR2(1000);
--
nIdSiniestro      SINIESTRO.IdSiniestro%TYPE;
dFecRes           COBERTURA_SINIESTRO_ASEG.FecRes%TYPE;
nTipoCambio       TASAS_CAMBIO.Tasa_Cambio%TYPE;
--dFecCarga         DATOS_PART_SINIESTROS.FecSts%TYPE;
cRFCHospital      DATOS_PART_SINIESTROS.Campo1%TYPE;
--cNomArchCarga     DATOS_PART_SINIESTROS.Campo85%TYPE;
nMontoRvaMon      COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc      COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;
cNombreBenef      VARCHAR2(2000);
cNumDocTributario BENEF_SIN.Num_Doc_Tributario%TYPE;
cEntidadFinanc    BENEF_SIN_PAGOS.Entidad_Financiera%TYPE;
cCuentaCheque     BENEF_SIN_PAGOS.Nro_Cheque%TYPE;
cDescBanco        VARCHAR2(200);
nIVAPorcentaje    CATALOGO_DE_CONCEPTOS.PorcConcepto%TYPE;
nCodCia           POLIZAS.codcia%TYPE;
nCodEmpresa       DETALLE_POLIZA.CODEMPRESA%TYPE;
cCodPlantilla     CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE := 'EMITESINIESTRO';
cQueryIVA         VARCHAR2(4000) := NULL;
cQueryISR         VARCHAR2(4000) := NULL;
cValorCampoIVA    VARCHAR2(4000) := NULL;
cValorCampoISR    VARCHAR2(4000) := NULL;
--
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);    
muestralerta number;
USUSARIO            VARCHAR2(50);
TERMINAL            VARCHAR2(50);
FIRMAS              VARCHAR2(70); 
cUsuario            VARCHAR2(50); 
--
	CURSOR PAGOSSIN_Q IS
  SELECT --/*+ RULE +*/ -- T.IDTRANSACCION NUM_TRANSACCION, ,
         '1'                                                                            POSICION ,
         TO_CHAR(T.FECHATRANSACCION,'DD/MM/YYYY')                                       FECHA, 
         DECODE(TS.CODTIPOPLAN,10,'VIDA','AP')                                          RAMO,                           
         SI.IDSINIESTRO                                                                 NUM_SINIESTRO,
         BES.NOMBRE||'  '||BES.APELLIDO_PATERNO||'  '||BES.APELLIDO_MATERNO             NOMBRE_BENEFICIARIO,
         A.MONTO_MONEDA                                                                 MONTO_PAGO,         
         DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PAGOBENEF',BES.IDTIPO_PAGO),'Invalida','',
                OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PAGOBENEF',BES.IDTIPO_PAGO))         TIPO_PAGO,
         OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE)                                      NOMBRE_CONTRATANTE,                   
         T.USUARIOGENERO                                                                USUARIO ,
         --- Datos para Actualizar Fondeo  ---
         A.NUM_APROBACION,
         A.IDSINIESTRO   ,
         A.IDPOLIZA      ,
         A.IDDETSIN      ,
         OC_ENTIDAD_FINANCIERA.NOMBRE_COMERCIAL(PP.CODCIA,BES.ENT_FINANCIERA)    BANCO,  --BANCO INCUSION DE ESTE CAMPO Y SU DESPLIEGUE
         BES.CUENTA_CLAVE,
         BES.NUMCUENTABANCARIA CUENTA_BANCARIA,
         BES.TELEFONO,
         DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TDOCIDEN',BES.TP_IDENTIFICACION),'Invalida','',
                OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TDOCIDEN',BES.TP_IDENTIFICACION))          TIPO_IDENTIFICACION,
         BES.NUM_IDENTIFICACION,
         BES.COD_CONVENIO,
         BES.EMAIL,
         BES.NUM_DOC_TRIBUTARIO  
    FROM  TRANSACCION T
         ,APROBACION_ASEG A 
         ,SINIESTRO SI
         ,DETALLE_SINIESTRO_ASEG DS
         ,BENEF_SIN                 BES   
         ,POLIZAS                   PP
         ,TIPOS_DE_SEGUROS          TS
    WHERE TRUNC(T.FECHATRANSACCION) >= dFecDesde  
     AND TRUNC(T.FECHATRANSACCION) <=  dFecHasta  
     ---
     AND T.USUARIOGENERO IN (  SELECT CODUSUARIO 
                                 FROM PROCESO_AUTORIZA_USUARIO
                                WHERE CodCia               = T.CODCIA
                                  AND CodProceso           = 9040
                                  AND IdTipoSeg            = 'NOAPLI')
     ---
     AND T.CODCIA           = NVL(cCODCIA,1)
     AND T.CODEMPRESA       = NVL(cCODEMPRESA,1)
     AND T.IDPROCESO        = 6
     --
     AND A.IDTRANSACCION    = T.IDTRANSACCION
     AND A.STSAPROBACION    = 'PAG'
     --
     AND NOT EXISTS (SELECT F.IDSINIESTRO                      
                     FROM PROCESOS_MASIVOS_SEGUIMIENTO F
                     WHERE F.NUM_APROBACION  = A.NUM_APROBACION  
                     AND   F.IDSINIESTRO     = A.IDSINIESTRO
                     AND   F.IDPOLIZA        = A.IDPOLIZA                                
                     AND   F.COD_ASEGURADO   = A.COD_ASEGURADO
                     AND   F.EMI_TIPOPROCESO = 'PAGSIN'
                     AND   F.IDTRANSACCION   = A.IDTRANSACCION
                    )
     --
     AND  SI.IDSINIESTRO    = A.IDSINIESTRO
     AND  SI.IDPOLIZA       = A.IDPOLIZA
     AND  SI.COD_ASEGURADO  = A.COD_ASEGURADO
     --
     AND DS.IDSINIESTRO     = SI.IDSINIESTRO
     AND DS.IDPOLIZA        = SI.IDPOLIZA
     AND DS.IDDETSIN        = 1
     AND DS.COD_ASEGURADO   = SI.COD_ASEGURADO
     --
     AND BES.IDSINIESTRO    = A.IDSINIESTRO
     AND BES.IDPOLIZA       = A.IDPOLIZA
     AND BES.BENEF          = A.BENEF 
     --
     AND PP.IDPOLIZA        = a.idpoliza
     AND PP.CODCIA          = T.CODCIA 
     AND PP.CODEMPRESA      = T.CODEMPRESA 
     --
     AND TS.IDTIPOSEG       = DS.IDTIPOSEG
     AND TS.CODEMPRESA      = T.CODEMPRESA
     AND TS.CODCIA          = T.CODCIA
     --
  UNION
     --
  SELECT --/*+ RULE +*/ -- T.IDTRANSACCION NUM_TRANSACCION, ,
         '2' POSICION,
         TO_CHAR(T.FECHATRANSACCION,'DD/MM/YYYY')                                       FECHA, 
         DECODE(TS.CODTIPOPLAN,10,'VIDA','AP')                                          RAMO,                            
         SI.IDSINIESTRO                                                                 NUM_SINIESTRO,
         BES.NOMBRE||'  '||BES.APELLIDO_PATERNO||'  '||BES.APELLIDO_MATERNO             NOMBRE_BENEFICIARIO,
         A.MONTO_MONEDA                                                                 MONTO_PAGO, 
         DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PAGOBENEF',BES.IDTIPO_PAGO),'Invalida','',
                OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PAGOBENEF',BES.IDTIPO_PAGO))         TIPO_PAGO,
         OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE)                                       NOMBRE_CONTRATANTE,                      
         T.USUARIOGENERO                                                                  USUARIO,
         --- Datos para Actualizar Fondeo  ---
         A.NUM_APROBACION,
         A.IDSINIESTRO   ,
         A.IDPOLIZA      ,
         A.IDDETSIN      ,                          
         OC_ENTIDAD_FINANCIERA.NOMBRE_COMERCIAL(PP.CODCIA,BES.ENT_FINANCIERA)    BANCO,
         BES.CUENTA_CLAVE,
         BES.NUMCUENTABANCARIA CUENTA_BANCARIA,
         BES.TELEFONO,
         DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TDOCIDEN',BES.TP_IDENTIFICACION),'Invalida','',
                OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TDOCIDEN',BES.TP_IDENTIFICACION))          TIPO_IDENTIFICACION,
         BES.NUM_IDENTIFICACION,
         BES.COD_CONVENIO,
         BES.EMAIL,
         BES.NUM_DOC_TRIBUTARIO  
    FROM TRANSACCION          T  ,  
         APROBACIONES         A  , 
         SINIESTRO            SI , 
         DETALLE_SINIESTRO    DS ,
         BENEF_SIN            BES, 
         POLIZAS              PP ,
         TIPOS_DE_SEGUROS     TS
   WHERE TRUNC(T.FECHATRANSACCION) >= dFecDesde  
     AND TRUNC(T.FECHATRANSACCION) <= dFecHasta  
     AND T.USUARIOGENERO IN (  SELECT CODUSUARIO 
                                 FROM PROCESO_AUTORIZA_USUARIO
                                WHERE CodCia               = T.CODCIA
                                  AND CodProceso           = 9040
                                  AND IdTipoSeg            = 'NOAPLI')
     AND T.CODCIA           = NVL(cCODCIA,1)
     AND T.CODEMPRESA       = NVL(cCODEMPRESA,1)
     AND T.IDPROCESO        = 6
     --
     AND A.IDTRANSACCION    = T.IDTRANSACCION
     AND A.STSAPROBACION    = 'PAG'
     --
     AND SI.IDSINIESTRO    = A.IDSINIESTRO
     AND SI.IDPOLIZA       = A.IDPOLIZA
     --
     AND DS.IDSINIESTRO     = SI.IDSINIESTRO
     AND DS.IDPOLIZA        = SI.IDPOLIZA
     AND DS.IDDETSIN        = 1
     AND DS.IDTIPOSEG   NOT IN ('FONACO')
     --
     AND BES.IDSINIESTRO    = A.IDSINIESTRO
     AND BES.IDPOLIZA       = A.IDPOLIZA
     AND BES.BENEF          = A.BENEF 
     --
     AND PP.IDPOLIZA        = a.idpoliza
     AND PP.CODCIA          = T.CODCIA
     AND PP.CODEMPRESA      = T.CODEMPRESA 
     --
     AND TS.IDTIPOSEG       = DS.IDTIPOSEG
     AND TS.CODEMPRESA      = T.CODEMPRESA
     AND TS.CODCIA          = T.CODCIA
   -- 
 UNION 
   --
  SELECT --/*+ RULE +*/ -- T.IDTRANSACCION NUM_TRANSACCION, ,
         '3' POSICION,
         TO_CHAR(T.FECHATRANSACCION,'DD/MM/YYYY')                     FECHA, 
         'VIDA COLECTIVO'                                             RAMO,                           
         0                                                            NUM_SINIESTRO,
         OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE)                    NOMBRE_BENEFICIARIO,
         sum(A.MONTO_MONEDA)                                          MONTO_PAGO, 
         'TRANSFERENCIA'                                              TIPO_PAGO,
         OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE)                    NOMBRE_CONTRATANTE,                   
         T.USUARIOGENERO                                              USUARIO,
         --- Datos para Actualizar Fondeo  ---
         null,--A.NUM_APROBACION,
         null,--A.IDSINIESTRO   ,
         null,--A.IDPOLIZA      ,
         null,--A.IDDETSIN             
         OC_ENTIDAD_FINANCIERA.NOMBRE_COMERCIAL(PP.CODCIA,BES.ENT_FINANCIERA)    BANCO,
         BES.CUENTA_CLAVE,
         BES.NUMCUENTABANCARIA CUENTA_BANCARIA,
         BES.TELEFONO,
         DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TDOCIDEN',BES.TP_IDENTIFICACION),'Invalida','',
                OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TDOCIDEN',BES.TP_IDENTIFICACION))          TIPO_IDENTIFICACION,
         BES.NUM_IDENTIFICACION,
         BES.COD_CONVENIO,
         BES.EMAIL,
         BES.NUM_DOC_TRIBUTARIO  
    FROM TRANSACCION          T  , 
         APROBACIONES         A  , 
         SINIESTRO            SI , 
         DETALLE_SINIESTRO    DS ,
         BENEF_SIN            BES,   
         POLIZAS              PP ,
         TIPOS_DE_SEGUROS     TS
   WHERE TRUNC(T.FECHATRANSACCION) >= dFecDesde  
     AND TRUNC(T.FECHATRANSACCION) <= dFecHasta  
     AND T.USUARIOGENERO IN (  SELECT CODUSUARIO 
                                 FROM PROCESO_AUTORIZA_USUARIO
                                WHERE CodCia               = T.CODCIA
                                  AND CodProceso           = 9040
                                  AND IdTipoSeg            = 'NOAPLI')
     AND T.CODCIA           = NVL(cCODCIA,1)
     AND T.CODEMPRESA       = NVL(cCODEMPRESA,1)
     AND T.IDPROCESO        = 6
     --
     AND A.IDTRANSACCION    = T.IDTRANSACCION
     AND A.STSAPROBACION    = 'PAG'
     --
     AND  SI.IDSINIESTRO    = A.IDSINIESTRO
     AND  SI.IDPOLIZA       = A.IDPOLIZA
     --
     AND DS.IDSINIESTRO     = SI.IDSINIESTRO
     AND DS.IDPOLIZA        = SI.IDPOLIZA
     AND DS.IDDETSIN        = 1
     AND DS.IDTIPOSEG      IN ('FONACO')
     --
     AND BES.IDSINIESTRO    = A.IDSINIESTRO
     AND BES.IDPOLIZA       = A.IDPOLIZA
     AND BES.BENEF          = A.BENEF 
     --
     AND PP.IDPOLIZA        = a.idpoliza
     AND PP.CODCIA          = T.CODCIA
     AND PP.CODEMPRESA      = T.CODEMPRESA 
     --
     AND TS.IDTIPOSEG       = DS.IDTIPOSEG
     AND TS.CODEMPRESA      = T.CODEMPRESA
     AND TS.CODCIA          = T.CODCIA
  GROUP BY TO_CHAR(T.FECHATRANSACCION,'DD/MM/YYYY'), 
        'VIDA COLECTIVO',  
         DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PAGOBENEF',BES.IDTIPO_PAGO),'Invalida','',
                OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PAGOBENEF',BES.IDTIPO_PAGO)),
        OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE), 
        T.USUARIOGENERO,
        OC_ENTIDAD_FINANCIERA.NOMBRE_COMERCIAL(PP.CODCIA,BES.ENT_FINANCIERA),
        BES.CUENTA_CLAVE,
        BES.NUMCUENTABANCARIA,
        BES.TELEFONO,
        DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TDOCIDEN',BES.TP_IDENTIFICACION),'Invalida','',
               OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TDOCIDEN',BES.TP_IDENTIFICACION)),
        BES.NUM_IDENTIFICACION,
        BES.COD_CONVENIO,
        BES.EMAIL,
        BES.NUM_DOC_TRIBUTARIO  
  ORDER BY 2,9; 
-- 
  CURSOR INFONACOT IS
  SELECT --/*+ RULE +*/ 
         --- Datos para Actualizar Fondeo  ---
         A.NUM_APROBACION,
         A.IDSINIESTRO   ,
         A.IDPOLIZA      ,
         A.IDDETSIN      
         ,T.USUARIOGENERO       
    FROM TRANSACCION          T  , 
         APROBACIONES         A  , 
         SINIESTRO            SI , 
         DETALLE_SINIESTRO    DS ,
         BENEF_SIN            BES,   
         POLIZAS              PP ,
         TIPOS_DE_SEGUROS     TS
   WHERE TRUNC(T.FECHATRANSACCION) >= dFecDesde  
     AND TRUNC(T.FECHATRANSACCION) <= dFecHasta  
     AND T.USUARIOGENERO IN (  SELECT CODUSUARIO 
                                 FROM PROCESO_AUTORIZA_USUARIO
                                WHERE CodCia               = T.CODCIA
                                  AND CodProceso           = 9040
                                  AND IdTipoSeg            = 'NOAPLI')
     AND T.CODCIA           = NVL(cCODCIA,1)
     AND T.CODEMPRESA       = NVL(cCODEMPRESA,1)
     AND T.IDPROCESO        = 6
     --
     AND A.IDTRANSACCION    = T.IDTRANSACCION
     AND A.STSAPROBACION    = 'PAG'
     AND A.INDFONDOSINI     = 'N'     
     --
     AND  SI.IDSINIESTRO    = A.IDSINIESTRO
     AND  SI.IDPOLIZA       = A.IDPOLIZA
     --
     AND DS.IDSINIESTRO     = SI.IDSINIESTRO
     AND DS.IDPOLIZA        = SI.IDPOLIZA
     AND DS.IDDETSIN        = 1
     AND DS.IDTIPOSEG      IN ('FONACO')
     --
     AND BES.IDSINIESTRO    = A.IDSINIESTRO
     AND BES.IDPOLIZA       = A.IDPOLIZA
     AND BES.BENEF          = A.BENEF 
     --
     AND PP.IDPOLIZA        = a.idpoliza
     AND PP.CODCIA          = NVL(cCODCIA,1)
     AND PP.CODEMPRESA      = NVL(cCODEMPRESA,1) 
     --
     AND TS.IDTIPOSEG       = DS.IDTIPOSEG
     AND TS.CODEMPRESA      = NVL(cCODEMPRESA,1)
     AND TS.CODCIA          = 1;       
		
--
BEGIN
BEGIN 
  Update APROBACION_ASEG
  Set INDFONDOSINI = 'N'
  where INDFONDOSINI is null;	
END;
Select Substr(OC_USUARIOS.NOMBRE_USUARIO(CCodCia, CODUSUARIO),1,1999)
INTO CDESCNOMBRE
from Proceso_Autoriza_Usuario
Where CodProceso = 9150
AND CODUSUARIO = CAUTORIZA;
  ---- // INICIO //
   SELECT  USER ,USERENV('TERMINAL')                   ---  SIGUECARGA
          INTO    USUSARIO , TERMINAL
          FROM    SYS.DUAL;   
          	    
--   cUsuario	          := Get_Application_Property(Username);  	      
          
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
--    ARCHIVO_SALIDA    := CLIENT_TEXT_IO.FOPEN(cNomArchivo,'W');         synchronize;	     
    ---- // FORMATO TEXTO //
  IF cFormato = 'TEXTO' THEN    
     ---- // TITULOS //
     nLinea  := 1; 
     cCadena := 'THONA SEGUROS, S.A. de C.V.' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     --
     nLinea := nLinea + 1;
     cCadena     := 'FONDEO DE PAGOS' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; 
     --
     nLinea  := nLinea + 1;
     cCadena := 'PERIODO DEL ' || TO_CHAR(dFecDesde,'DD/MM/YYYY') ||' AL ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     --
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := 'FECHA'                  ||cLimitador||
                'RAMO'                   ||cLimitador||
                'NUMERO DE SINIESTRO'    ||cLimitador||
                'NOMBRE_BENEFICIARIO'    ||cLimitador||
                'MONTO DE PAGO '         ||cLimitador||
                'TIPO DE PAGO'           ||cLimitador||
                'NOMBRE DEL CONTRATANTE' ||cLimitador||
                'USUARIO'                ||cLimitador||
                'BANCO'                  ||cLimitador||
                'CUENTA CLABE'           ||cLimitador||
                'CUENTA BANCARIA'        ||cLimitador||
                'TELEFONO'               ||cLimitador||
                'TIPO_IDENTIFICACION'    ||cLimitador||
                'NUM_IDENTIFICACION'     ||cLimitador||
                'COD_CONVENIO'           ||cLimitador||
                'EMAIL'                  ||cLimitador||
                'NUM_DOC_TRIBUTARIO  ';--||chr(13);}
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
  ELSE
     ---- // FORMATO EXCEL //
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                ' <style id="libro">'||chr(10)||
                '   <!--table'||chr(10)||
                '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                '        .texto'||chr(10)||
                '          {mso-number-format:"\@";}'||chr(10)||
                '        .numero'||chr(10)||
                '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                '        .fecha'||chr(10)||
                '          {mso-number-format:"dd\\-mm\\-yy";}'||chr(10)||
                '    -->'||chr(10)||
                ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     ---- // TITULOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DIARIO DE PAGOS'||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     --
     nLinea  := nLinea + 1;
     cCadena := 'PERIODO DEL ' || TO_CHAR(dFecDesde,'DD/MM/YYYY') ||' AL ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RAMO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE SINIESTRO</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE DEL BENEFICIARIO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DEL PAGO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE PAGO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE DEL CONTRATANTE</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">BANCO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CUENTA CLABE</font></th>'||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CUENTA BANCARIA</font></th>'||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TELEFONO</font></th>'||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO_IDENTIFICACION</font></th>'||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUM_IDENTIFICACION</font></th>'||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COD_CONVENIO</font></th>'||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EMAIL</font></th>'||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUM_DOC_TRIBUTARIO</font></th></tr>';
   
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
  END IF;
  	
  ---- // CARGA DE INFORMACIÓN //
  FOR X IN PAGOSSIN_Q LOOP
    --
  	--
    IF cFormato = 'TEXTO' THEN
       cCadena := X.FECHA 				   	  ||cLimitador||						
                  X.RAMO						    ||cLimitador||
                  X.NUM_SINIESTRO       ||cLimitador||
                  X.NOMBRE_BENEFICIARIO	||cLimitador||
                  X.MONTO_PAGO					||cLimitador||
                  X.TIPO_PAGO				    ||cLimitador||
                  X.NOMBRE_CONTRATANTE	||cLimitador||
                  X.USUARIO		          ||cLimitador||
                  X.BANCO               ||cLimitador||
                  X.CUENTA_CLAVE        ||cLimitador||
                  X.CUENTA_BANCARIA     ||cLimitador||
                  X.TELEFONO            ||cLimitador||
                  X.TIPO_IDENTIFICACION ||cLimitador||
                  X.NUM_IDENTIFICACION  ||cLimitador||
                  X.COD_CONVENIO        ||cLimitador||
                  X.EMAIL               ||cLimitador||
                  X.NUM_DOC_TRIBUTARIO;--||chr(13);  synchronize;	
    ELSE
       cCadena := '<tr>' ||
                  OC_ARCHIVO.CAMPO_HTML(X.FECHA,'C')              ||
                  OC_ARCHIVO.CAMPO_HTML(X.RAMO,'C')               ||
                  OC_ARCHIVO.CAMPO_HTML(X.NUM_SINIESTRO,'C')      ||
                  OC_ARCHIVO.CAMPO_HTML(X.NOMBRE_BENEFICIARIO,'C')||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTO_PAGO,'C')         ||
                  OC_ARCHIVO.CAMPO_HTML(X.TIPO_PAGO,'D')          ||
                  OC_ARCHIVO.CAMPO_HTML(X.NOMBRE_CONTRATANTE,'C') ||
                  OC_ARCHIVO.CAMPO_HTML(X.USUARIO,'C')            || 
                  OC_ARCHIVO.CAMPO_HTML(X.BANCO,'C')              ||
                  OC_ARCHIVO.CAMPO_HTML(X.CUENTA_CLAVE,'C')       ||
                  OC_ARCHIVO.CAMPO_HTML(X.CUENTA_BANCARIA,'C')    ||
                  OC_ARCHIVO.CAMPO_HTML(X.TELEFONO,'C')           ||
                  OC_ARCHIVO.CAMPO_HTML(X.TIPO_IDENTIFICACION,'C')||
                  OC_ARCHIVO.CAMPO_HTML(X.NUM_IDENTIFICACION,'C') ||
                  OC_ARCHIVO.CAMPO_HTML(X.COD_CONVENIO,'C')       ||
                  OC_ARCHIVO.CAMPO_HTML(X.EMAIL,'C')              ||
                  OC_ARCHIVO.CAMPO_HTML(X.NUM_DOC_TRIBUTARIO,'C') || '</tr>';
                                        
    END IF;
    nLinea := nLinea + 1;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --    CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
    
    
 
  END LOOP; 
   
     nLinea  := nLinea + 1;
     cCadena := '<tr>                         
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     
     nLinea  := nLinea + 1;
     cCadena := '<tr>                 
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     
     nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     
     nLinea  := nLinea + 1;
     cCadena := '<tr>
     <th colspan=3>  ELABORÓ    </th>
     <th colspan=2>  AUTORIZÓ    </th>
     <th colspan=3>  REGISTRÓ    </th>                
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     
     nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     
     nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     
      nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --    CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     
     nLinea  := nLinea + 1;
     cCadena := '<tr>
     <th style="border:none;" colspan=3>  ________________    </th>
     <th style="border:none;" colspan=2>  ________________    </th>
     <th style="border:none;" colspan=3>  ________________    </th>                
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     
         nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
       
      IF USUSARIO = 'JMERINO'  THEN
     	     cCadena := '<tr>
									     <th colspan=3> Jimena Merino Galán</th>
									     <th colspan=2> '||CDESCNOMBRE||'
									     </th>
									     <th colspan=3>Alipio Hernández García</th>                
									     </tr>';      
                       OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --									     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; 
     	     
          
     ELSIF USUSARIO = 'NINLOPEZ'  THEN
         	 cCadena := '<tr>
									     <th colspan=3> Ninfa Manuela López Martínez</th>
									     <th colspan=2> '||CDESCNOMBRE||'
									     </th>
									     <th colspan=3>Alipio Hernández García</th>                
									     </tr>';      
                      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --									     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; 
         	 
       
     ELSIF USUSARIO = 'JARRIETA'  THEN	
     	    cCadena := '<tr>
			     <th colspan=3>Josue Emmanuel Arrieta Rivera</th>
			     <th colspan=2>Jocelyn Vizuet Rayón</th>
			     <th colspan=3>Alipio Hernández García</th>                
			     </tr>';      
           OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --			     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; 
     	    
     	        	  
     ELSIF USUSARIO = 'HMACIEL'  THEN	
    	      cCadena := '<tr>
									     <th colspan=3> Heidi Maciel Cruz </th>
									     <th colspan=2> '||CDESCNOMBRE||'
									     </th>
									     <th colspan=3>Alipio Hernández García</th>                
									     </tr>';      
                        OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --									     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; 
    	     
     ELSE     	
    	
     cCadena := '<tr>
     <th colspan=3> Jimena Merino Galán</th>
     <th colspan=2> '||CDESCNOMBRE||'
     </th>
     <th colspan=3>Alipio Hernández García</th>                
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; 
     END IF; 	
     
     nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     
     nLinea  := nLinea + 1;
     cCadena := '<tr>
     <th colspan=3>       ANALISTA    </th>
     <th colspan=2>  SINIESTROS VIDA Y ACCIDENTES PERSONALES  </th>
     <th colspan=3>       CONTABILIDAD </th>                
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     
     
     
  ---- // CIERRE DEL ARCHIVO  //    
  IF cFormato = 'EXCEL' THEN
     cCadena := '</table></div></html>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);     SYNCHRONIZE;
  END IF;
OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0);
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
OC_ARCHIVO.Eliminar_Archivo(cCodUser);
END;
PROCEDURE REPORTE_POLIZA  (cNomArchivo VARCHAR2, nIdPoliza   VARCHAR2,cFormato    VARCHAR2,nIdReporte   NUMBER) IS
--
cLimitador      VARCHAR2(1) :='|';
nLinea          NUMBER;
cCadena         VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;
--
nIdSiniestro       SINIESTRO.IdSiniestro%TYPE;
dFecRes            COBERTURA_SINIESTRO_ASEG.FecRes%TYPE;
nTipoCambio        TASAS_CAMBIO.Tasa_Cambio%TYPE;
cRFCHospital       DATOS_PART_SINIESTROS.Campo1%TYPE;
nMontoRvaMon       COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc       COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;
cNombreBenef       VARCHAR2(2000);
cNumDocTributario  BENEF_SIN.Num_Doc_Tributario%TYPE;
cEntidadFinanc     BENEF_SIN_PAGOS.Entidad_Financiera%TYPE;
cCuentaCheque      BENEF_SIN_PAGOS.Nro_Cheque%TYPE;
cDescBanco         VARCHAR2(200);
nIVAPorcentaje     CATALOGO_DE_CONCEPTOS.PorcConcepto%TYPE;
nCodCia            POLIZAS.codcia%TYPE;
nCodEmpresa        DETALLE_POLIZA.CODEMPRESA%TYPE;
cCodPlantilla      CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE := 'EMITESINIESTRO';
cQueryIVA          VARCHAR2(4000) := NULL;
cQueryISR          VARCHAR2(4000) := NULL;
cValorCampoIVA     VARCHAR2(4000) := NULL;
cValorCampoISR     VARCHAR2(4000) := NULL;
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);    
muestralerta       number;
MNTO_PAGOS         COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE; 
nMtoCobertMoneda   COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
nNumPolUnico       VARCHAR2(200); 
NomAsegurado       VARCHAR2(200); 
nOcurrido          Siniestro.monto_reserva_local%TYPE;  
nPagado            Siniestro.MONTO_PAGO_LOCAL%TYPE;
nOPC               Siniestro.MONTO_PAGO_LOCAL%TYPE;
nCod_Agente        NUMBER; 
nCodCliente        NUMBER;
cNombreAgente      VARCHAR2(200); 
cNombreCliente     VARCHAR2(200); 
DFEC_OCURRENCIA    VARCHAR2(15); 
DFEC_NOTIFICACION  VARCHAR2(15); 
DFECSTS            VARCHAR2(15); 
CCVE_CAUSA_SINIESTRO SAI_CAT_GENERAL.CAGE_ID_CONCEP_ALF%TYPE;
CNOM_CAUSA_SINIESTRO SAI_CAT_GENERAL.CAGE_VALOR_LARGO%TYPE;
NSUBGRUPO          SINIESTRO.IDETPOL%TYPE;
--
CURSOR PAGOSSIN_Q(WPOLIZA IN VARCHAR2 ) IS
/*+ rule */
SELECT '1'                       INDCOL,
        A.IDPOLIZA               POLIZA,
        A.IDSINIESTRO            SINIESTRO,
        A.CODCOBERT              COBERTURA,
        A.COD_ASEGURADO          ASEGURADO ,
        OC_ASEGURADO.NOMBRE_ASEGURADO(1,1,A.COD_ASEGURADO) NomAsegurado,
        A.NUMMOD                 NUMMOD
   FROM COBERTURA_SINIESTRO_ASEG  A
  WHERE A.IDPOLIZA     IN (SELECT P.IDPOLIZA 
                             FROM POLIZAS P
                            WHERE P.NUMPOLUNICO = WPOLIZA ) --=  '11344-00'
    AND A.IDSINIESTRO  > 0
    AND A.STSCOBERTURA = 'EMI'
    AND A.NUMMOD       IN  (SELECT MAX(NUMMOD) 
                              FROM COBERTURA_SINIESTRO_ASEG CC
                             WHERE CC.IdSiniestro   = A.IdSiniestro
                               AND CC.IdPoliza      = A.IdPoliza  
                               AND CC.Cod_Asegurado = A.Cod_Asegurado
                               AND CC.StsCobertura  = 'EMI'
                               AND CC.CodCobert     = A.CodCobert)
--                             
UNION   
--
SELECT '2'                        INDCOL,
       A21.IDPOLIZA               POLIZA,
       A21.IDSINIESTRO            SINIESTRO,
       A21.CODCOBERT              COBERTURA,
       NULL                       ASEGURADO,
       '  '                       NomAsegurado,
       A21.NUMMOD                 NUMMOD
  FROM COBERTURA_SINIESTRO   A21
  WHERE A21.IDPOLIZA      IN (SELECT P.IDPOLIZA 
                                FROM POLIZAS P
                               WHERE P.NUMPOLUNICO = WPOLIZA ) --=  '11344-00'
    AND A21.IDSINIESTRO   > 0
    AND A21.STSCOBERTURA = 'EMI'
    AND A21.NUMMOD       IN (SELECT MAX(NUMMOD) 
                               FROM COBERTURA_SINIESTRO  CC
                              WHERE CC.IdPoliza      = A21.IdPoliza
                                AND CC.IdSiniestro   = A21.IdSiniestro
                                AND CC.IDDETSIN      = A21.IDDETSIN
                                AND CC.CodCobert     = A21.CodCobert
                                AND CC.StsCobertura   = 'EMI'
                            )                         
ORDER BY 1,2,3,4;
--
BEGIN
  --
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
    --ARCHIVO_SALIDA    := CLIENT_CLIENT_TEXT_IO.FOPEN(cNomArchivo,'W');
    --ARCHIVO_SALIDA    := CLIENT_TEXT_IO.FOPEN(cNomArchivo,'W');         synchronize;	     
    ---- // FORMATO TEXTO //
  IF cFormato = 'TEXTO' THEN    
     ---- // TITULOS //
     nLinea := 1; 
     cCadena     := 'THONA SEGUROS, S.A. de C.V.' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     --
     nLinea := nLinea + 1;
     cCadena     := 'SINIESTRALIDAD' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; 
     --
     nLinea  := nLinea + 1;
     cCadena := ' PERIODO DE VIGENCIA DE LA POLIZA '|| CHR(13); ---PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE '|| TO_CHAR(dFecDesde,'Month') || ' AL ' || TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecHasta,'Month') ||' DE ' || TO_CHAR(dFecHasta,'YYYY') || CHR(13);
          OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     --
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
          OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     
          OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
  ELSE
     ---- // FORMATO EXCEL //
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                ' <style id="libro">'||chr(10)||
                '   <!--table'||chr(10)||
                '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                '        .texto'||chr(10)||
                '          {mso-number-format:"\@";}'||chr(10)||
                '        .numero'||chr(10)||
                '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                '        .fecha'||chr(10)||
                '          {mso-number-format:"dd\\-mm\\-yy";}'||chr(10)||
                '    -->'||chr(10)||
                ' </style><div id="libro">'||chr(10);
          OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     ---- // TITULOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
          OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DE SINIESTRALIDAD'||'</th></tr>'; 
          OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>PERIODO DE VIGENCIA DE LA POLIZA ' ||'</th></tr>';
          OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --     CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF"> AGENTE </font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CLIENTE  </font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA UNICA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA CONSECUTIVO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">SUBGRUPO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE SINIESTRO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE OCURRIDO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE REGISTRO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE NOTIFICACION</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COBERTURA</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE DEL ASEGURADO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CLAVE CAUSA</font></th></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DECRIPCION</font></th></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE OCURRIDO/RESERVADO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE PAGO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO OPC </font></th></tr>';
    
                
          OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
  END IF;
  
  ---- // CARGA DE INFORMACIÓN //
  FOR X IN PAGOSSIN_Q(nIdPoliza) LOOP
    --
  	    IF X.INDCOL = 1  THEN
							BEGIN	
								SELECT SUM(F.MONTO_PAGADO_MONEDA)  INTO  MNTO_PAGOS
								FROM COBERTURA_SINIESTRO_ASEG F
								WHERE F.IDSINIESTRO   = X.SINIESTRO
								AND   F.IDPOLIZA      = X.POLIZA
								AND   F.CODCOBERT     = X.COBERTURA
								AND   F.COD_ASEGURADO = X.ASEGURADO
								;
							EXCEPTION  WHEN NO_DATA_FOUND THEN
								       MNTO_PAGOS := 0;
--								       nDummy := STOPALERT(('Colectivos NDF MNTO_PAGOS : '|| ' ' ||SQLERRM));  
								         WHEN OTHERS THEN
								       MNTO_PAGOS := 0; 
--								       nDummy := STOPALERT(('Colectivos OTHERS MNTO_PAGOS : '|| ' ' ||SQLERRM));  
							END;
							IF MNTO_PAGOS IS  NULL THEN MNTO_PAGOS:= 0; END IF;
							
							BEGIN
					      SELECT SUM(DECODE (CN.SIGNO,'-',CS.Monto_Reservado_Moneda * -1,CS.Monto_Reservado_Moneda))
					   	    INTO nMtoCobertMoneda
					        FROM COBERTURA_SINIESTRO_ASEG CS,CONFIG_TRANSAC_SINIESTROS CN 
					       WHERE CS.CodTransac   = CN.CodTransac
					         AND CS.StsCobertura = 'EMI'
					         AND CS.CodCobert     = X.COBERTURA
					         AND CS.IdPoliza      = X.POLIZA
					         AND CS.IdSiniestro   = X.SINIESTRO  
					         AND CS.Cod_Asegurado = X.ASEGURADO                   
					         ;					     
					    EXCEPTION  WHEN NO_DATA_FOUND THEN
								       nMtoCobertMoneda := 0;
--								       nDummy := STOPALERT(('Colectivos NDF nMtoCobertMoneda : '|| ' ' ||SQLERRM));  
								         WHEN OTHERS THEN
								       nMtoCobertMoneda := 0;
--								       nDummy := STOPALERT(('Colectivos OTHERS nMtoCobertMoneda : '|| ' ' ||SQLERRM));   
							END;  
					    IF nMtoCobertMoneda IS  NULL THEN nMtoCobertMoneda:= 0; END IF;
					
					    nOPC := 	(nMtoCobertMoneda - MNTO_PAGOS);
			ELSIF X.INDCOL = 2  THEN 		 
		        BEGIN 
		          SELECT SUM(F.MONTO_PAGADO_MONEDA)  INTO  MNTO_PAGOS
							FROM COBERTURA_SINIESTRO  F
							WHERE F.IDSINIESTRO   = X.SINIESTRO
							AND   F.IDPOLIZA      = X.POLIZA
							AND   F.CODCOBERT     = X.COBERTURA					
							;
						EXCEPTION  WHEN NO_DATA_FOUND THEN
										       MNTO_PAGOS := 0;
--										       nDummy := STOPALERT(('Individuales NDF MNTO_PAGOS : '|| ' ' ||SQLERRM));   
										         WHEN OTHERS THEN
										       MNTO_PAGOS := 0; 
--										       nDummy := STOPALERT(('Individuales OTHERS MNTO_PAGOS : '|| ' ' ||SQLERRM));   
					  END;
						IF MNTO_PAGOS IS  NULL THEN MNTO_PAGOS:= 0; END IF;	
						
						BEGIN
				        SELECT   SUM(c.MONTO_RESERVADO_MONEDA) ---C.Saldo_Reserva 
					      INTO   nMtoCobertMoneda
					      FROM COBERTURA_SINIESTRO  C
					      WHERE C.IdSiniestro = X.SINIESTRO  
					      AND C.IdPoliza      = X.POLIZA
					      AND c.codcobert     = X.COBERTURA		
					      AND C.StsCobertura  = 'EMI'
					      --AND C.NumMod  = X.NUMMOD
					      ;
					   EXCEPTION  WHEN NO_DATA_FOUND THEN
								       nMtoCobertMoneda := 0;
--								       nDummy := STOPALERT(('Individuales NDF nMtoCobertMoneda : '|| ' ' ||SQLERRM));   
								         WHEN OTHERS THEN
								       nMtoCobertMoneda := 0; 
--								       nDummy := STOPALERT(('Individuales OTHERS nMtoCobertMoneda : '|| ' ' ||SQLERRM));   
							END;    
					    IF nMtoCobertMoneda IS  NULL THEN nMtoCobertMoneda:= 0; END IF;                         
					
					
				  nOPC := 	(nMtoCobertMoneda - MNTO_PAGOS);
					
  	  END IF; 
  	   
  	   
  	  BEGIN 
        Select NumPolUnico,  COD_AGENTE,  CODCLIENTE
          INTO nNumPolUnico, nCod_Agente, nCodCliente
          from Polizas
         Where IdPoliza = X.POLIZA 
  	   ;
  	  EXCEPTION  WHEN OTHERS THEN
  	  	 nNumPolUnico := null;    
  	  	 nCod_Agente  := null; 
  	  	 nCodCliente  := null;
  	  END;
      --
    	BEGIN 
        SELECT TO_CHAR(S.FEC_OCURRENCIA,'DD/MM/YYYY'),
               TO_CHAR(S.FEC_NOTIFICACION,'DD/MM/YYYY'),
               TO_CHAR(S.FECSTS,'DD/MM/YYYY'),
               SA.CAGE_ID_CONCEP_ALF,
               SA.CAGE_VALOR_LARGO,
               S.IDETPOL 
          INTO DFEC_OCURRENCIA,
               DFEC_NOTIFICACION,
               DFECSTS,
               CCVE_CAUSA_SINIESTRO,
               CNOM_CAUSA_SINIESTRO,
               NSUBGRUPO
          FROM SINIESTRO S,
               SAI_CAT_GENERAL SA
         WHERE S.IDSINIESTRO = X.SINIESTRO
           --
           AND SA.CAGE_CD_CATALOGO   = 1
           AND SA.CAGE_ID_CONCEP_ALF = S.MOTIVO_DE_SINIESTRO
           AND SA.CAGE_NOM_CONCEP    IS NULL;
    	EXCEPTION  
    		WHEN OTHERS THEN
  	 	       DFEC_OCURRENCIA   := NULL;
             DFEC_NOTIFICACION := NULL;
             DFECSTS           := NULL;
  	  END;
  	  --
  	  IF nCod_Agente IS NULL THEN  	  	 
				BEGIN	
					Select CodGenerador into nCod_Agente from Facturas
					where IdPoliza = X.POLIZA 
					and   IdFactura in (Select MAX(IdFactura) from Facturas
					                    Where IdPoliza = X.POLIZA 
					                      and STSFACT not in ('SOL')
					                      and CodGenerador is not null); 
				EXCEPTION  WHEN OTHERS THEN
					nCod_Agente := NULL;
			  END;		
  	  END IF;	
  	  
  	  BEGIN
  	     SELECT nCod_Agente||'  -  '||Nombre||' '||Apellido_paterno||' '||Apellido_Materno
           INTO cNombreAgente
           FROM PERSONA_NATURAL_JURIDICA PNJ, AGENTES AG
          WHERE PNJ.TIPO_DOC_IDENTIFICACION = AG.TIPO_DOC_IDENTIFICACION
            AND PNJ.NUM_DOC_IDENTIFICACION = AG.NUM_DOC_IDENTIFICACION
            AND AG.CODCIA = 1  
            AND AG.COD_AGENTE = nCod_Agente
         ;
  	  EXCEPTION  WHEN OTHERS THEN
  	  	 cNombreAgente := '   ';
  	  END;	
     BEGIN	     
      SELECT TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) || ' ' || 
             DECODE(PNJ.ApeCasada,NULL,'', ' de ' ||PNJ.ApeCasada)
        INTO cNombreCliente
        FROM CLIENTES CLI, PERSONA_NATURAL_JURIDICA PNJ
       WHERE CLI.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion
         AND CLI.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion
         AND CLI.CodCliente = nCodCliente;
  	 EXCEPTION  WHEN OTHERS THEN
  	  	 cNombreCliente := '   ';
  	  END;   	
    
    IF cFormato = 'TEXTO' THEN
       cCadena := cNombreAgente        ||cLimitador||
                  cNombreCliente       ||cLimitador||       	          
                  nNumPolUnico 		     ||cLimitador||						
                  X.POLIZA    		     ||cLimitador||						
                  NSUBGRUPO    		     ||cLimitador||						
                  X.SINIESTRO		       ||cLimitador||
                  DFEC_OCURRENCIA      ||cLimitador||
                  DFECSTS              ||cLimitador||
                  DFEC_NOTIFICACION    ||cLimitador||
                  X.COBERTURA          ||cLimitador||
                  X.NomAsegurado    	 ||cLimitador||
                  CCVE_CAUSA_SINIESTRO ||cLimitador||
                  CNOM_CAUSA_SINIESTRO ||cLimitador||
                  nMtoCobertMoneda     ||cLimitador||   -- MLJS 07/04/2020 SE INVIERTIÓ LA POSICION DEL CAMPO MNTO_PAGOS 
                  MNTO_PAGOS           ||cLimitador||   -- MLJS 07/04/2020 Y nMtoCobertMoneda
                  nOPC  ;--||chr(13); 
       
    ELSE
       cCadena := '<tr>'                                          ||
                  OC_ARCHIVO.CAMPO_HTML(cNombreAgente,'C')        ||
                  OC_ARCHIVO.CAMPO_HTML(cNombreCliente,'C')       ||
                  OC_ARCHIVO.CAMPO_HTML(nNumPolUnico,'C')         ||
                  OC_ARCHIVO.CAMPO_HTML(X.POLIZA,'C')             ||
                  OC_ARCHIVO.CAMPO_HTML(NSUBGRUPO,'C')            ||
                  OC_ARCHIVO.CAMPO_HTML(X.SINIESTRO,'C')          ||
                  OC_ARCHIVO.CAMPO_HTML(DFEC_OCURRENCIA,'C')      ||
                  OC_ARCHIVO.CAMPO_HTML(DFECSTS,'C')              ||
                  OC_ARCHIVO.CAMPO_HTML(DFEC_NOTIFICACION,'C')    ||
                  OC_ARCHIVO.CAMPO_HTML(X.COBERTURA,'C')          ||
                  OC_ARCHIVO.CAMPO_HTML(X.NomAsegurado,'C')       ||
                  OC_ARCHIVO.CAMPO_HTML(CCVE_CAUSA_SINIESTRO,'C') ||
                  OC_ARCHIVO.CAMPO_HTML(CNOM_CAUSA_SINIESTRO,'C') ||
                  OC_ARCHIVO.CAMPO_HTML(nMtoCobertMoneda,'C')     ||  -- MLJS 07/04/2020 SE INVIERTIÓ LA POSICION DEL CAMPO MNTO_PAGOS 
                  OC_ARCHIVO.CAMPO_HTML(MNTO_PAGOS,'C')           ||  -- MLJS 07/04/2020 Y nMtoCobertMoneda
                  OC_ARCHIVO.CAMPO_HTML(nOPC,'C')                 ||
                   '</tr>'; 
                  
        
    END IF;
    nLinea := nLinea + 1;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
  END LOOP;
  ---- // CIERRE DEL ARCHIVO  //    
  IF cFormato = 'EXCEL' THEN
     OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
     cCadena := '</table></div></html>';
     --OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);     SYNCHRONIZE;
  END IF;
  
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
   
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
   --CLIENT_TEXT_IO.fCLOSE(ARCHIVO_SALIDA);    
  --
END;
PROCEDURE SINIESTROS_DEL_MES (cNomArchivo VARCHAR2, 
                              cIdTipoSeg  VARCHAR2, 
                              cCodMoneda  VARCHAR2, 
                              dFecDesde   DATE    ,
                              dFecHasta   DATE    ,
                              cFormato    VARCHAR2,
                              nIdReporte   NUMBER) IS
                              
                          
--
cLimitador      VARCHAR2(1) :='|';
nLinea          NUMBER;
cCadena         VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;
--
nIdSiniestro      SINIESTRO.IdSiniestro%TYPE;
dFecRes           COBERTURA_SINIESTRO_ASEG.FecRes%TYPE;
nTipoCambio       TASAS_CAMBIO.Tasa_Cambio%TYPE;
--dFecCarga         DATOS_PART_SINIESTROS.FecSts%TYPE;
cRFCHospital      DATOS_PART_SINIESTROS.Campo1%TYPE;
--cNomArchCarga     DATOS_PART_SINIESTROS.Campo85%TYPE;
nMontoRvaMon      COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc      COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;
cNombreBenef      VARCHAR2(2000);
cNumDocTributario BENEF_SIN.Num_Doc_Tributario%TYPE;
cEntidadFinanc    BENEF_SIN_PAGOS.Entidad_Financiera%TYPE;
cCuentaCheque     BENEF_SIN_PAGOS.Nro_Cheque%TYPE;
cDescBanco        VARCHAR2(200);
nIVAPorcentaje    CATALOGO_DE_CONCEPTOS.PorcConcepto%TYPE;
nCodCia           POLIZAS.codcia%TYPE;
nCodEmpresa       DETALLE_POLIZA.CODEMPRESA%TYPE;
cCodPlantilla     CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE := 'EMITESINIESTRO';
cQueryIVA         VARCHAR2(4000) := NULL;
cQueryISR         VARCHAR2(4000) := NULL;
cValorCampoIVA    VARCHAR2(4000) := NULL;
cValorCampoISR    VARCHAR2(4000) := NULL;
--
--ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;
--ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);    
muestralerta number;
tiposeg  detalle_poliza.idtiposeg%type;
--
CURSOR PAGOSSIN_Q IS
  select  a.IDSINIESTRO
       ,a.IDPOLIZA
       ,a.NUMSINIREF
       ,a.TIPO_SINIESTRO
       ,a.FEC_OCURRENCIA
       ,a.FEC_NOTIFICACION
       ,a.STS_SINIESTRO
       ,a.FECSTS
       ,a.FECANUL
       ,a.MOTIV_ANUL
       ,a.DESC_SINIESTRO
       ,a.MONTO_RESERVA_LOCAL
       ,a.MONTO_RESERVA_MONEDA
       ,a.MONTO_PAGO_LOCAL
       ,a.MONTO_PAGO_MONEDA
       ,a.COD_MONEDA
       ,a.IDETPOL
       ,a.NUM_BIEN
       ,a.MONTO_INDEMINZACION
       ,a.DEDUCIBLE
       ,a.TIPO_INDEMNIZACION
       ,a.AJUSTADOR
       ,a.CODCIA
       ,a.MOTIVO_DE_SINIESTRO
       ,a.CODEMPRESA
       ,a.NUMSINNOM
       ,a.NUMSEMANA
       ,a.CODPAISOCURR
       ,a.CODPROVOCURR
       ,a.CODPROVEEDOR
       ,a.COD_ASEGURADO      
from siniestro a
     --detalle_poliza   b
where a.fecsts between dFecDesde --to_date('01/12/2016','dd/mm/yyyy') 
               and     dFecHasta --to_date('31/12/2016','dd/mm/yyyy')
--
--and b.idpoliza = a.idpoliza
order by  a.idsiniestro;
				 
--
BEGIN
	--message('REPORTE_PAGOS_INDIVIDUAL  Begin ...  '); synchronize;
	
	--message('   :BK_DATOS.Formato    '||:BK_DATOS.Formato); synchronize;	
  ---- // INICIO //
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
    --ARCHIVO_SALIDA    := CLIENT_CLIENT_TEXT_IO.FOPEN(cNomArchivo,'W');
    --ARCHIVO_SALIDA    := CLIENT_TEXT_IO.FOPEN(cNomArchivo,'W');         synchronize;	     
    ---- // FORMATO TEXTO //
  IF cFormato = 'TEXTO' THEN    
     ---- // TITULOS //
     nLinea := 1; 
     cCadena     := 'THONA SEGUROS, S.A. de C.V.' || CHR(13);
     --Se reemplazaran las lineas de oc_archivo.Escribir_linea por:
     -- CLIENT_TEXT_IO.putf. Debe ser mas rapido para escribir.
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     
     --
     nLinea := nLinea + 1;
     cCadena     := 'SINIESTRALIDAD DEL MES' || CHR(13);
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := 'PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE '|| TO_CHAR(dFecDesde,'Month') || ' AL ' || TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecHasta,'Month') ||' DE ' || TO_CHAR(dFecHasta,'YYYY') || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     --
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := 'SINIESTRO'          ||cLimitador||'POLIZA'           ||cLimitador||'NUMERO DE REFERENCIA' ||cLimitador||
                'TIPO DE SEGMENTO'   ||cLimitador||'MONTO DE OCURRIDO'||cLimitador||'MONTO DE PAGO'         ;--||chr(13);
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  ELSE
     ---- // FORMATO EXCEL //
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                ' <style id="libro">'||chr(10)||
                '   <!--table'||chr(10)||
                '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                '        .texto'||chr(10)||
                '          {mso-number-format:"\@";}'||chr(10)||
                '        .numero'||chr(10)||
                '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                '        .fecha'||chr(10)||
                '          {mso-number-format:"dd\\-mm\\-yy";}'||chr(10)||
                '    -->'||chr(10)||
                ' </style><div id="libro">'||chr(10);
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // TITULOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DE SINIESTRALIDAD DEL MES'||'</th></tr>'; 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE ' || TO_CHAR(dFecDesde,'MONTH') || ' AL ' ||
                TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecDesde,'MONTH') || ' DE ' || TO_CHAR(dFecDesde,'YYYY') || '</th></tr>'; 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">SINIESTRO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE REFERENCIA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE SEGMENTO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE OCURRIDO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE PAGO</font></th></tr>';
     
    
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
  
  --	message('   Llama al Cursor   '); synchronize;	
  ---- // CARGA DE INFORMACIÓN //
  FOR X IN PAGOSSIN_Q LOOP
    --
    --	message('   Dentro del Cursor    '||X.USUARIO); synchronize;	    
  	--'IDSINIESTRO '||' - IDPOLIZA '||' -  NUMSINIREF  '||' -  tiposeg  '||' -  MONTO_RESERVA_MONEDA  '||' -  MONTO_PAGO_MONEDA ' 
        
        Begin
         select unique(s.idtiposeg) into tiposeg
			   from  detalle_poliza s
			   where s.idpoliza = X.IDPOLIZA
			   ;
        Exception When No_Data_Found THEN
        	    tiposeg := ' ';
        	 When Others Then  
        	     tiposeg := ' ';
        End;
   
    IF cFormato = 'TEXTO' THEN
       cCadena := X.IDSINIESTRO 	   	  ||cLimitador||						
                  X.IDPOLIZA				    ||cLimitador||
                  X.NUMSINIREF          ||cLimitador||
                    tiposeg             ||cLimitador||
                  X.MONTO_RESERVA_MONEDA||cLimitador||
                  X.MONTO_PAGO_MONEDA   ;--||chr(13);  synchronize;	
       
       
              
    ELSE
       cCadena := '<tr>'                                           ||
                  OC_ARCHIVO.CAMPO_HTML(X.IDSINIESTRO,'C')         ||
                  OC_ARCHIVO.CAMPO_HTML(X.IDPOLIZA,'C')            ||
                  OC_ARCHIVO.CAMPO_HTML(X.NUMSINIREF,'C')          ||
                  OC_ARCHIVO.CAMPO_HTML(tiposeg,'C')             ||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTO_RESERVA_MONEDA,'C')||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTO_PAGO_MONEDA,'C')   || '</tr>';
       
        
              
                                    
    END IF;
    nLinea := nLinea + 1;
    --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END LOOP;
  ---- // CIERRE DEL ARCHIVO  //    
  IF cFormato = 'EXCEL' THEN
--     OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
     cCadena := '</table></div></html>';
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);     SYNCHRONIZE;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
   
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
  --CLIENT_TEXT_IO.fCLOSE(ARCHIVO_SALIDA);  
EXCEPTION 
  WHEN OTHERS THEN 
    --OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
    RAISE_APPLICATION_ERROR(-20102,'Error en Generación Reporte PAGOS APROBADOS  de Siniestros: '|| ' ' ||SQLERRM);  
    
END;
FUNCTION FUNC_CODPOSTAL(p_Postal VARCHAR2) RETURN  VARCHAR2 IS
   cPostal  VARCHAR2(100);
BEGIN
   SELECT Descripcion_Postal
     INTO cPostal
     FROM APARTADO_POSTAL
    WHERE Codigo_Postal = p_Postal;
   RETURN(cPostal);
EXCEPTION 
   WHEN NO_DATA_FOUND THEN
      RETURN('NO EXISTE');
END;
FUNCTION FUNC_PAIS(p_Pais VARCHAR2) RETURN  VARCHAR2 IS
   cPais  VARCHAR2(50);
BEGIN
   SELECT DescPais
     INTO cPais
     FROM PAIS
    WHERE CodPais  = p_Pais;
   RETURN(cPais);
EXCEPTION 
   WHEN NO_DATA_FOUND THEN
      RETURN('NO EXISTE');
END;
FUNCTION FUNC_Provincia(p_Pais VARCHAR2, p_Estado VARCHAR2) RETURN VARCHAR2 IS
   cProvincia  VARCHAR2(50);
BEGIN
   SELECT DescEstado
     INTO cProvincia
     FROM PROVINCIA
    WHERE CodPais  = p_Pais
      AND CodEstado = p_Estado;
   RETURN(cProvincia);
EXCEPTION 
   WHEN NO_DATA_FOUND THEN
      RETURN('NO EXISTE');
END;
FUNCTION Func_Distrito(p_Pais VARCHAR2, p_Estado VARCHAR2, p_Ciudad VARCHAR2) RETURN  VARCHAR2 IS
   cDistrito  VARCHAR2(50);
BEGIN
   SELECT DescCiudad
     INTO cDistrito
     FROM DISTRITO
    WHERE CodPais  = p_Pais
      AND CodEstado = p_Estado
      AND CodCiudad = p_Ciudad;
   RETURN(cDistrito);
EXCEPTION 
   WHEN NO_DATA_FOUND THEN
      RETURN('NO EXISTE');
END;
FUNCTION Func_Corregimiento(p_pais varchar2, p_estado varchar2,
                            p_ciudad varchar2, p_municipio varchar2) return VARCHAR2 is
   cCorregi VARCHAR2(50) := 'No Existe';
BEGIN
   SELECT DescMunicipio
     INTO cCorregi
     FROM CORREGIMIENTO
    WHERE CodPais       = p_Pais
      AND CodEstado     = p_Estado
      AND CodCiudad     = p_Ciudad
      AND CodMunicipio  = p_Municipio;
   RETURN(cCorregi);
EXCEPTION 
   WHEN NO_DATA_FOUND THEN
      RETURN('NO EXISTE');
END;
FUNCTION  FUNC_COLONIA(p_Postal VARCHAR2, p_Colonia VARCHAR2 , p_Codpais varchar2,
								 p_CodEstado varchar2, p_CodCiudad varchar2, p_Codmunicipio varchar2) RETURN  VARCHAR2 IS
   cColonia  VARCHAR2(100);
BEGIN
   SELECT Descripcion_colonia
     INTO cColonia
    FROM COLONIA
    WHERE Codigo_Colonia  = p_Colonia
    AND Codigo_Postal = p_Postal
    AND CODPAIS=p_CodPais
    and CodEstado=p_CodEstado
    and CodCiudad=p_CodCiudad
    and CodMunicipio=p_CodMunicipio;
   RETURN(cColonia);
EXCEPTION 
   WHEN NO_DATA_FOUND THEN
      RETURN('NO EXISTE');
END;
FUNCTION NOMBRE_EMPRESA(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN VARCHAR2 IS
  cNombre  VARCHAR2(200);
BEGIN
   SELECT RTRIM(LTRIM(NomEmpresa))
     INTO cNombre
     FROM EMPRESAS_DE_SEGUROS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa;
   RETURN(cNombre);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      cNombre := 'EMPRESA - NO EXISTE!!!';
      RETURN(cNombre);
END;
PROCEDURE REPORTE_PAGOS_GG_ALL (cNomArchivo VARCHAR2,cFormato    VARCHAR2,nIdReporte   NUMBER) IS
--
cLimitador      VARCHAR2(1) :='|';
nLinea          NUMBER;
cCadena         VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;
--
nIdSiniestro      SINIESTRO.IdSiniestro%TYPE;
dFecRes           COBERTURA_SINIESTRO_ASEG.FecRes%TYPE;
nTipoCambio       TASAS_CAMBIO.Tasa_Cambio%TYPE;
--dFecCarga         DATOS_PART_SINIESTROS.FecSts%TYPE;
cRFCHospital      DATOS_PART_SINIESTROS.Campo1%TYPE;
--cNomArchCarga     DATOS_PART_SINIESTROS.Campo85%TYPE;
nMontoRvaMon      COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc      COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;
cNombreBenef      VARCHAR2(2000);
cNumDocTributario BENEF_SIN.Num_Doc_Tributario%TYPE;
cEntidadFinanc    BENEF_SIN_PAGOS.Entidad_Financiera%TYPE;
cCuentaCheque     BENEF_SIN_PAGOS.Nro_Cheque%TYPE;
cDescBanco        VARCHAR2(200);
nIVAPorcentaje    CATALOGO_DE_CONCEPTOS.PorcConcepto%TYPE;
nCodCia           POLIZAS.codcia%TYPE;
nCodEmpresa       DETALLE_POLIZA.CODEMPRESA%TYPE;
cCodPlantilla     CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE := 'EMITESINIESTRO';
cQueryIVA         VARCHAR2(4000) := NULL;
cQueryISR         VARCHAR2(4000) := NULL;
cValorCampoIVA    VARCHAR2(4000) := NULL;
cValorCampoISR    VARCHAR2(4000) := NULL;
--
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);    
muestralerta number;
--
					CURSOR PAGOSSIN_Q IS
            SELECT SI.IDPOLIZA                                              IDPOLIZA, 
                   PP.NUMPOLUNICO                                           POLUNIK, 
                   SI.IDSINIESTRO                                           IDSINIESTRO, 
                   DA.COD_PAGO                                              COD_PAGO,
                   PMS.EMI_USUARIO                                          EMI_USUARIO,
                   PMS.EMI_FECHACOMP                                        EMI_FECHACOMP, 
                   PMS.EMI_FECHA                                            FECHAMVTO, 
                   A.NUM_APROBACION                                         NUM_APROBACION,
                   A.TIPO_APROBACION                                        TIPO_APROBACION, 
                   OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', A.STSAPROBACION) ESTATUS, 
                   DA.CODTRANSAC                                            CODTRANSAC, 
                   DA.CODCPTOTRANSAC                                        CODCPTOTRANSAC, 
                   SI.COD_MONEDA                                            COD_MONEDA, 
                   DA.MONTO_MONEDA                                          PGO_MON_ORIG,
                   DA.MONTO_LOCAL                                           PGO_MON_NAC , 
                   A.MONTO_MONEDA                                           PGO_NETO_MON_ORIG, 
                   A.MONTO_LOCAL                                            PAGO_NETO_MON_LOC,
                   --
                   NVL(SI.MONTO_RESERVA_MONEDA,0)- NVL(SI.MONTO_PAGO_MONEDA,0) OPC_MONEDA,
                   NVL(SI.MONTO_RESERVA_LOCAL,0) - NVL(SI.MONTO_PAGO_LOCAL,0) OPC_LOCAL,
                   --
                   DS.IDTIPOSEG                                             TIPOSEGURO, 
                   DS.IDDETSIN                                              IDDETSIN, 
                   DS.COD_ASEGURADO                                         ASEGURADO, 
                   SI.NUMSINIREF                                            NUMSINIREF, 
                   A.BENEF                                                  BENEF,
                   PP.CodCia                                                CodCia, 
                   PP.CodEmpresa                                            CodEmpresa  
                   --
                   ,TO_CHAR(PMS.CRGA_FECHACOMP,'DD/MM/YYYY HH24:MI:SS')     FecCarga   
                   ,PMS.CRGA_NOM_ARCHIVO                                    NomArchCarga 
                   ,PMS.MONTOPAGAR                                          MONTO_DE_PAGO
                   ,PMS.MONTOIVA                                            MONTOIVA 
                   ,PMS.MONTOISR                                            MONTOISR-- cNomArchCarga  MONTOIVA  MONTOISR
                   ,PMS.NUMFACTURA                                          NUMERO_FACTURA  
                   ,PMS.ARCHIVO_LOGEM                                       ARCHIVO_LOGEM 
                   ,TO_CHAR(PMS.IDPROCMASIVO)                               IDPROCMASIVO
                   ,PMS.POLCONTA_GG                                         POLCONTA_GG  
                   ,TO_CHAR(PMS.FECHA_PAGO,'DD/MM/YYYY')                    FECHA_PAGO    
                   ,PMS.IMPORT_PAGO                                         IMPORT_PAGO 
                   ,PMS.ARCHIVO_GG                                          ARCHIVO_GG
                   ,PMS.PGOGG_USUARIO                                       PGOGG_USUARIO
                   ,TO_CHAR(PMS.PGOGG_FECHACOMP,'DD/MM/YYYY HH24:MI:SS')    PGOGG_FECHACOMP
                   ,PMS.OBSERVACION_GG                                      OBSERVACION_GG
                   ,PMS.MONTOPAGAR                                          WMONTO
              FROM PROCESOS_MASIVOS_SEGUIMIENTO   PMS
                  ,SINIESTRO                       SI
                  ,APROBACION_ASEG                  A
                  ,DETALLE_APROBACION_ASEG         DA
                  ,DETALLE_SINIESTRO_ASEG DS,
                   POLIZAS PP 
             WHERE PMS.IDPROCMASIVO > 0 
               AND  PMS.EMI_TIPOPROCESO = 'PAGSIN'  
               AND  PMS.POLCONTA_GG    IS NOT NULL
               --AND  PMS.EMI_FECHA      >=  dFecDesde--to_date('01/11/2016','dd/mm/yyyy')--dFecDesde
               --AND  PMS.EMI_FECHA      <=  dFecHasta--to_date('26/12/2016','dd/mm/yyyy')--dFecHasta
             -----
               AND SI.IDSINIESTRO      = PMS.IDSINIESTRO
               AND SI.IDPOLIZA         = PMS.IDPOLIZA
             -----  
               AND DS.IDSINIESTRO      = SI.IDSINIESTRO
               AND DS.IDPOLIZA         = SI.IDPOLIZA
               and ds.iddetsin         = 1
               and ds.cod_asegurado    = si.cod_asegurado
               --add primary key (NUM_APROBACION, IDSINIESTRO, IDPOLIZA, IDDETSIN, COD_ASEGURADO)
               AND a.num_aprobacion           > 0 
              --- 
               AND a.num_aprobacion    > 0 
               AND A.IDSINIESTRO       = SI.IDSINIESTRO
               and a.idpoliza          = SI.IDPOLIZA
               AND a.iddetsin          = 1
               AND a.cod_asegurado     = si.cod_asegurado
               AND DA.NUM_APROBACION   = A.NUM_APROBACION
               AND DA.IDSINIESTRO      = A.IDSINIESTRO   
               --
               AND PP.IDPOLIZA         = PMS.IDPOLIZA 
               AND PP.CODCIA           = 1       
             ORDER BY 1,2,4,6   ;
             
--
BEGIN
	--message('REPORTE_PAGOS_INDIVIDUAL  Begin ...  '); synchronize;
	
	--message('   :BK_DATOS.Formato    '||:BK_DATOS.Formato); synchronize;	
  ---- // INICIO //
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
    --ARCHIVO_SALIDA    := CLIENT_CLIENT_TEXT_IO.FOPEN(cNomArchivo,'W');
    ---- // FORMATO TEXTO //
  IF cFormato = 'TEXTO' THEN    
     ---- // TITULOS //
     nLinea := 1; 
     cCadena     := 'THONA SEGUROS, S.A. de C.V.' || CHR(13);
     --Se reemplazaran las lineas de oc_archivo.Escribir_linea por:
     -- CLIENT_TEXT_IO.putf. Debe ser mas rapido para escribir.
     --OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea := nLinea + 1;
     cCadena     := 'PAGOS POLIZA GG' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     --cCadena := 'PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE '|| TO_CHAR(dFecDesde,'Month') || ' AL ' || TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecHasta,'Month') ||' DE ' || TO_CHAR(dFecHasta,'YYYY') || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := 'NUMERO POLIZA'          ||cLimitador||'NO. POLIZA UNICO'       ||cLimitador||'NÚMERO DE REFERENCIA'   ||cLimitador||'NO. SINIESTRO'          ||cLimitador||
                'COBERTURA'              ||cLimitador||'FECHA MOVIMIENTO'       ||cLimitador||'NO. APROB.'             ||cLimitador||'TIPO APROBACION'        ||cLimitador||
                'ESTATUS'                ||cLimitador||'DESCRIPCION TRANSACCION'||cLimitador||'CONCEPTO'               ||cLimitador||
                'MONEDA'                 ||cLimitador||'TIPO DE CAMBIO'         ||cLimitador||
                'PAGO MON ORIGINAL'      ||cLimitador||'PAGO MON NACIONAL'      ||cLimitador||'PAGO NETO MON ORIGINAL' ||cLimitador||'PAGO NETO MON NACIONAL' ||cLimitador||                
                'PAGO MON ORIGINAL'      ||cLimitador||'PAGO MON NACIONAL'      ||cLimitador||'IVA MON ORIGINAL'       ||cLimitador||'IVA MON NACIONAL'       ||cLimitador||
                'ISR RET MON ORIGINAL'   ||cLimitador||'ISR RET MON ORIGINAL'   ||cLimitador||        
                'OPC MON ORIGINAL'       ||cLimitador||'OPC MON NACIONAL'       ||cLimitador||'OPERO'                  ||cLimitador||            
                'BENEFICIARIO'           ||cLimitador||'NOMBRE_ARCH_CARGA'      ||cLimitador||'NOMBRE ARCHIVO LOGEM'   ||cLimitador||'FECHA DE CARGA'         ||cLimitador||                                
                'TIPO DE SEGURO'         ||cLimitador||'NUMERO DE FACTURA'      ||cLimitador||
                'ID CARGA MASIVA'        ||cLimitador||'POLIZA CONTABLE PGO GG' ||cLimitador||'FECHA DE PAGO GG'       ||cLimitador||'IMPORTE DEL PAGO'       ||cLimitador|| 
                'ARCHIVO PGO-GG'         ||cLimitador||'USUARIO CARGA PGO-GG'   ||cLimitador||'FECHA - HORA DE CARGA'  ||cLimitador||	'OBSERVACIONES POLIZA GG'||cLimitador||
                'MONTO DE PAGO'
                ;--||chr(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  ELSE
     ---- // FORMATO EXCEL //
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                ' <style id="libro">'||chr(10)||
                '   <!--table'||chr(10)||
                '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                '        .texto'||chr(10)||
                '          {mso-number-format:"\@";}'||chr(10)||
                '        .numero'||chr(10)||
                '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                '        .fecha'||chr(10)||
                '          {mso-number-format:"dd\\-mm\\-yy";}'||chr(10)||
                '    -->'||chr(10)||
                ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // TITULOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DE PAGOS POLIZAS GG'||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     --cCadena := '<tr><th>PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE ' || TO_CHAR(dFecDesde,'MONTH') || ' AL ' ||
     --           TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecDesde,'MONTH') || ' DE ' || TO_CHAR(dFecDesde,'YYYY') || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     --<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA</font></th>
     cCadena := '<table border = 1><tr>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO POLIZA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. POLIZA UNICO</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NÚMERO DE REFERENCIA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. SINIESTRO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COBERTURA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA MOVIMIENTO.</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. APROB.</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO APROBACION.</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ESTATUS.</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCRIPCION TRANSACCION.</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CONCEPTO.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONEDA.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE CAMBIO.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO MON NACIONAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO NETO MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO NETO MON NACIONAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO MON NACIONAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA MON NACIONAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ISR RET MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ISR RET MON ORIGINAL.</font></th>' ||  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPC MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPC MON NACIONAL.</font></th>' ||  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPERO.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">BENEFICIARIO.</font></th>' ||  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE_ARCH_CARGA.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE ARCHIVO LOGEM.</font></th>' ||  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE CARGA.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE SEGURO.</font></th>' ||   
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE FACTURA.</font></th>' || 
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ID CARGA MASIVA.</font></th>' || 
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA CONTABLE PGO GG.</font></th>' || 
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE PAGO GG.</font></th>' ||       
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO CARGA PGO-GG.</font></th>' ||                   
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA - HORA DE CARGA.</font></th>' ||                   
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OBSERVACIONES POLIZA GG.</font></th>' ||   
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE PAGO</font></th></tr>';
     
     
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
  
  --	message('   Llama al Cursor   '); synchronize;	
  ---- // CARGA DE INFORMACIÓN //
  FOR X IN PAGOSSIN_Q LOOP
    --
    --	message('   Dentro del Cursor    '||X.USUARIO); synchronize;	    
  	--
    IF cFormato = 'TEXTO' THEN
       cCadena := X.IDPOLIZA           ||cLimitador||
                  X.POLUNIK            ||cLimitador||
                  X.NUMSINIREF         ||cLimitador||
                  X.IDSINIESTRO        ||cLimitador||
                  X.COD_PAGO           ||cLimitador||
                  X.EMI_FECHACOMP      ||cLimitador||
                  X.NUM_APROBACION     ||cLimitador||
                  X.TIPO_APROBACION    ||cLimitador||
                  X.ESTATUS            ||cLimitador||
                  X.CODTRANSAC         ||cLimitador||                     
                  X.CODCPTOTRANSAC     ||cLimitador||
                  X.COD_MONEDA         ||cLimitador||
                  X.PGO_MON_ORIG       ||cLimitador||                
                  X.PGO_MON_NAC        ||cLimitador||
                  X.PGO_NETO_MON_ORIG  ||cLimitador||              
                  X.PAGO_NETO_MON_LOC  ||cLimitador||
                  X.MONTO_DE_PAGO      ||cLimitador||
                  X.MONTO_DE_PAGO      ||cLimitador||                 
                  X.MONTOIVA           ||cLimitador||
                  X.MONTOIVA           ||cLimitador||                      
                  X.MONTOISR           ||cLimitador||
                  X.MONTOISR           ||cLimitador||
                  X.OPC_MONEDA         ||cLimitador||               
                  X.OPC_LOCAL          ||cLimitador||
                  X.EMI_USUARIO        ||cLimitador||              
                  X.BENEF              ||cLimitador||
                  X.NOMARCHCARGA       ||cLimitador||
                  X.ARCHIVO_LOGEM      ||cLimitador||
                  X.FecCarga           ||cLimitador||
                  X.TIPOSEGURO         ||cLimitador||
                  X.NUMERO_FACTURA     ||cLimitador||
                  X.IDPROCMASIVO       ||cLimitador||                
                  X.POLCONTA_GG        ||cLimitador||
                  X.FECHA_PAGO         ||cLimitador||
                  X.IMPORT_PAGO        ||cLimitador||
                  X.ARCHIVO_GG         ||cLimitador||                 
                  X.PGOGG_USUARIO      ||cLimitador||                                
                  X.PGOGG_FECHACOMP    ||cLimitador||                               
                  X.OBSERVACION_GG     ||cLimitador||                                 
                  X.WMONTO ;
       
    ELSE
       cCadena := '<tr>' ||                  
                  OC_ARCHIVO.CAMPO_HTML(X.IDPOLIZA,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.POLUNIK,'C')          ||          
                  OC_ARCHIVO.CAMPO_HTML(X.NUMSINIREF,'C')       ||       
                  OC_ARCHIVO.CAMPO_HTML(X.IDSINIESTRO,'C')      ||      
                  OC_ARCHIVO.CAMPO_HTML(X.COD_PAGO,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.EMI_FECHACOMP,'C')    ||    
                  OC_ARCHIVO.CAMPO_HTML(X.NUM_APROBACION,'C')   ||   
                  OC_ARCHIVO.CAMPO_HTML(X.TIPO_APROBACION,'C')  ||  
                  OC_ARCHIVO.CAMPO_HTML(X.ESTATUS,'C')          ||          
                  OC_ARCHIVO.CAMPO_HTML(X.CODTRANSAC,'C')       ||       
                  OC_ARCHIVO.CAMPO_HTML(X.CODCPTOTRANSAC,'C')   ||   
                  OC_ARCHIVO.CAMPO_HTML(X.COD_MONEDA,'C')       ||       
                  OC_ARCHIVO.CAMPO_HTML(X.PGO_MON_ORIG,'C')     ||     
                  OC_ARCHIVO.CAMPO_HTML(X.PGO_MON_NAC,'C')      ||      
                  OC_ARCHIVO.CAMPO_HTML(X.PGO_NETO_MON_ORIG,'C')||
                  OC_ARCHIVO.CAMPO_HTML(X.PAGO_NETO_MON_LOC,'C')||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTO_DE_PAGO,'C')    ||    
                  OC_ARCHIVO.CAMPO_HTML(X.MONTO_DE_PAGO,'C')    ||    
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOIVA,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOIVA,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOISR,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOISR,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.OPC_MONEDA,'C')       ||       
                  OC_ARCHIVO.CAMPO_HTML(X.OPC_LOCAL,'C')        ||        
                  OC_ARCHIVO.CAMPO_HTML(X.EMI_USUARIO,'C')      ||      
                  OC_ARCHIVO.CAMPO_HTML(X.BENEF,'C')            ||            
                  OC_ARCHIVO.CAMPO_HTML(X.NOMARCHCARGA,'C')     ||     
                  OC_ARCHIVO.CAMPO_HTML(X.ARCHIVO_LOGEM,'C')    ||    
                  OC_ARCHIVO.CAMPO_HTML(X.FecCarga,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.TIPOSEGURO,'C')       ||       
                  OC_ARCHIVO.CAMPO_HTML(X.NUMERO_FACTURA,'C')   ||   
                  OC_ARCHIVO.CAMPO_HTML(X.IDPROCMASIVO,'C')     ||     
                  OC_ARCHIVO.CAMPO_HTML(X.POLCONTA_GG,'C')      ||      
                  OC_ARCHIVO.CAMPO_HTML(X.FECHA_PAGO,'C')       ||            
                  OC_ARCHIVO.CAMPO_HTML(X.IMPORT_PAGO,'C')      ||        
                  OC_ARCHIVO.CAMPO_HTML(X.ARCHIVO_GG,'C')       ||         
                  OC_ARCHIVO.CAMPO_HTML(X.PGOGG_USUARIO,'C')    ||      
                  OC_ARCHIVO.CAMPO_HTML(X.PGOGG_FECHACOMP,'C')  ||    
                  OC_ARCHIVO.CAMPO_HTML(X.OBSERVACION_GG,'C')   ||     
                  OC_ARCHIVO.CAMPO_HTML(X.WMONTO,'C')           || '</tr>';           
        
              
    END IF;
    nLinea := nLinea + 1;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END LOOP;
  ---- // CIERRE DEL ARCHIVO  //    
  IF cFormato = 'EXCEL' THEN
     cCadena := '</table></div></html>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
  
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
   
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
EXCEPTION 
  WHEN OTHERS THEN 
    --OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
    raise_application_error(-20102,'Error en Generación Reporte PAGOS APROBADOS  de Siniestros: '|| ' ' ||SQLERRM);  
    
END;
PROCEDURE REPORTE_PAGOS_GG (cNomArchivo VARCHAR2,                            
                            dFecDesde   DATE    ,
                            dFecHasta   DATE    ,
                            cFormato    VARCHAR2,
                            nIdReporte   NUMBER) IS
--
cLimitador      VARCHAR2(1) :='|';
nLinea          NUMBER;
cCadena         VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;
--
nIdSiniestro      SINIESTRO.IdSiniestro%TYPE;
dFecRes           COBERTURA_SINIESTRO_ASEG.FecRes%TYPE;
nTipoCambio       TASAS_CAMBIO.Tasa_Cambio%TYPE;
--dFecCarga         DATOS_PART_SINIESTROS.FecSts%TYPE;
cRFCHospital      DATOS_PART_SINIESTROS.Campo1%TYPE;
--cNomArchCarga     DATOS_PART_SINIESTROS.Campo85%TYPE;
nMontoRvaMon      COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc      COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;
cNombreBenef      VARCHAR2(2000);
cNumDocTributario BENEF_SIN.Num_Doc_Tributario%TYPE;
cEntidadFinanc    BENEF_SIN_PAGOS.Entidad_Financiera%TYPE;
cCuentaCheque     BENEF_SIN_PAGOS.Nro_Cheque%TYPE;
cDescBanco        VARCHAR2(200);
nIVAPorcentaje    CATALOGO_DE_CONCEPTOS.PorcConcepto%TYPE;
nCodCia           POLIZAS.codcia%TYPE;
nCodEmpresa       DETALLE_POLIZA.CODEMPRESA%TYPE;
cCodPlantilla     CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE := 'EMITESINIESTRO';
cQueryIVA         VARCHAR2(4000) := NULL;
cQueryISR         VARCHAR2(4000) := NULL;
cValorCampoIVA    VARCHAR2(4000) := NULL;
cValorCampoISR    VARCHAR2(4000) := NULL;
--
--ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);    
muestralerta number;
--
					CURSOR PAGOSSIN_Q IS
            SELECT SI.IDPOLIZA                                              IDPOLIZA, 
                   PP.NUMPOLUNICO                                           POLUNIK, 
                   SI.IDSINIESTRO                                           IDSINIESTRO, 
                   DA.COD_PAGO                                              COD_PAGO,
                   PMS.EMI_USUARIO                                          EMI_USUARIO,
                   PMS.EMI_FECHACOMP                                        EMI_FECHACOMP, 
                   PMS.EMI_FECHA                                            FECHAMVTO, 
                   A.NUM_APROBACION                                         NUM_APROBACION,
                   A.TIPO_APROBACION                                        TIPO_APROBACION, 
                   OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', A.STSAPROBACION) ESTATUS, 
                   DA.CODTRANSAC                                            CODTRANSAC, 
                   DA.CODCPTOTRANSAC                                        CODCPTOTRANSAC, 
                   SI.COD_MONEDA                                            COD_MONEDA, 
                   DA.MONTO_MONEDA                                          PGO_MON_ORIG,
                   DA.MONTO_LOCAL                                           PGO_MON_NAC , 
                   A.MONTO_MONEDA                                           PGO_NETO_MON_ORIG, 
                   A.MONTO_LOCAL                                            PAGO_NETO_MON_LOC,
                   --
                   NVL(SI.MONTO_RESERVA_MONEDA,0)- NVL(SI.MONTO_PAGO_MONEDA,0) OPC_MONEDA,
                   NVL(SI.MONTO_RESERVA_LOCAL,0) - NVL(SI.MONTO_PAGO_LOCAL,0) OPC_LOCAL,
                   --
                   DS.IDTIPOSEG                                             TIPOSEGURO, 
                   DS.IDDETSIN                                              IDDETSIN, 
                   DS.COD_ASEGURADO                                         ASEGURADO, 
                   SI.NUMSINIREF                                            NUMSINIREF, 
                   A.BENEF                                                  BENEF,
                   PP.CodCia                                                CodCia, 
                   PP.CodEmpresa                                            CodEmpresa  
                   --
                   ,TO_CHAR(PMS.CRGA_FECHACOMP,'DD/MM/YYYY HH24:MI:SS')     FecCarga   
                   ,PMS.CRGA_NOM_ARCHIVO                                    NomArchCarga 
                   ,PMS.MONTOPAGAR                                          MONTO_DE_PAGO
                   ,PMS.MONTOIVA                                            MONTOIVA 
                   ,PMS.MONTOISR                                            MONTOISR-- cNomArchCarga  MONTOIVA  MONTOISR
                   ,PMS.NUMFACTURA                                          NUMERO_FACTURA  
                   ,PMS.ARCHIVO_LOGEM                                       ARCHIVO_LOGEM 
                   ,TO_CHAR(PMS.IDPROCMASIVO)                               IDPROCMASIVO
                   ,PMS.POLCONTA_GG                                         POLCONTA_GG  
                   ,TO_CHAR(PMS.FECHA_PAGO,'DD/MM/YYYY')                    FECHA_PAGO    
                   ,PMS.IMPORT_PAGO                                         IMPORT_PAGO 
                   ,PMS.ARCHIVO_GG                                          ARCHIVO_GG
                   ,PMS.PGOGG_USUARIO                                       PGOGG_USUARIO
                   ,TO_CHAR(PMS.PGOGG_FECHACOMP,'DD/MM/YYYY HH24:MI:SS')    PGOGG_FECHACOMP
                   ,PMS.OBSERVACION_GG                                      OBSERVACION_GG
                   ,PMS.MONTOPAGAR                                          WMONTO
              FROM PROCESOS_MASIVOS_SEGUIMIENTO   PMS
                  ,SINIESTRO                       SI
                  ,APROBACION_ASEG                  A
                  ,DETALLE_APROBACION_ASEG         DA
                  ,DETALLE_SINIESTRO_ASEG DS,
                   POLIZAS PP 
             WHERE PMS.IDPROCMASIVO > 0 
               AND  PMS.EMI_TIPOPROCESO = 'PAGSIN'  
               AND  PMS.POLCONTA_GG    IS NOT NULL
               AND  PMS.EMI_FECHA      >=  dFecDesde--to_date('01/11/2016','dd/mm/yyyy')--dFecDesde
               AND  PMS.EMI_FECHA      <=  dFecHasta--to_date('26/12/2016','dd/mm/yyyy')--dFecHasta
             -----
               AND SI.IDSINIESTRO      = PMS.IDSINIESTRO
               AND SI.IDPOLIZA         = PMS.IDPOLIZA
             -----  
               AND DS.IDSINIESTRO      = SI.IDSINIESTRO
               AND DS.IDPOLIZA         = SI.IDPOLIZA
               and ds.iddetsin         = 1
               and ds.cod_asegurado    = si.cod_asegurado
               --add primary key (NUM_APROBACION, IDSINIESTRO, IDPOLIZA, IDDETSIN, COD_ASEGURADO)
               AND a.num_aprobacion           > 0 
              --- 
               AND a.num_aprobacion    > 0 
               AND A.IDSINIESTRO       = SI.IDSINIESTRO
               and a.idpoliza          = SI.IDPOLIZA
               AND a.iddetsin          = 1
               AND a.cod_asegurado     = si.cod_asegurado
               AND DA.NUM_APROBACION   = A.NUM_APROBACION
               AND DA.IDSINIESTRO      = A.IDSINIESTRO   
               --
               AND PP.IDPOLIZA         = PMS.IDPOLIZA 
               AND PP.CODCIA           = 1       
             ORDER BY 1,2,4,6   ;
             
--
BEGIN
	--message('REPORTE_PAGOS_INDIVIDUAL  Begin ...  '); synchronize;
	
	--message('   :BK_DATOS.Formato    '||:BK_DATOS.Formato); synchronize;	
  ---- // INICIO //
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
    --ARCHIVO_SALIDA    := CLIENT_CLIENT_TEXT_IO.FOPEN(cNomArchivo,'W');
    
    ---- // FORMATO TEXTO //
  IF cFormato = 'TEXTO' THEN    
     ---- // TITULOS //
     nLinea := 1; 
     cCadena     := 'THONA SEGUROS, S.A. de C.V.' || CHR(13);
     --Se reemplazaran las lineas de oc_archivo.Escribir_linea por:
     -- CLIENT_TEXT_IO.putf. Debe ser mas rapido para escribir.
     --OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea := nLinea + 1;
     cCadena     := 'PAGOS POLIZA GG' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := 'PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE '|| TO_CHAR(dFecDesde,'Month') || ' AL ' || TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecHasta,'Month') ||' DE ' || TO_CHAR(dFecHasta,'YYYY') || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := 'NUMERO POLIZA'          ||cLimitador||'NO. POLIZA UNICO'       ||cLimitador||'NÚMERO DE REFERENCIA'   ||cLimitador||'NO. SINIESTRO'          ||cLimitador||
                'COBERTURA'              ||cLimitador||'FECHA MOVIMIENTO'       ||cLimitador||'NO. APROB.'             ||cLimitador||'TIPO APROBACION'        ||cLimitador||
                'ESTATUS'                ||cLimitador||'DESCRIPCION TRANSACCION'||cLimitador||'CONCEPTO'               ||cLimitador||
                'MONEDA'                 ||cLimitador||'TIPO DE CAMBIO'         ||cLimitador||
                'PAGO MON ORIGINAL'      ||cLimitador||'PAGO MON NACIONAL'      ||cLimitador||'PAGO NETO MON ORIGINAL' ||cLimitador||'PAGO NETO MON NACIONAL' ||cLimitador||                
                'PAGO MON ORIGINAL'      ||cLimitador||'PAGO MON NACIONAL'      ||cLimitador||'IVA MON ORIGINAL'       ||cLimitador||'IVA MON NACIONAL'       ||cLimitador||
                'ISR RET MON ORIGINAL'   ||cLimitador||'ISR RET MON ORIGINAL'   ||cLimitador||        
                'OPC MON ORIGINAL'       ||cLimitador||'OPC MON NACIONAL'       ||cLimitador||'OPERO'                  ||cLimitador||            
                'BENEFICIARIO'           ||cLimitador||'NOMBRE_ARCH_CARGA'      ||cLimitador||'NOMBRE ARCHIVO LOGEM'   ||cLimitador||'FECHA DE CARGA'         ||cLimitador||                                
                'TIPO DE SEGURO'         ||cLimitador||'NUMERO DE FACTURA'      ||cLimitador||
                'ID CARGA MASIVA'        ||cLimitador||'POLIZA CONTABLE PGO GG' ||cLimitador||'FECHA DE PAGO GG'       ||cLimitador||'IMPORTE DEL PAGO'       ||cLimitador|| 
                'ARCHIVO PGO-GG'         ||cLimitador||'USUARIO CARGA PGO-GG'   ||cLimitador||'FECHA - HORA DE CARGA'  ||cLimitador||	'OBSERVACIONES POLIZA GG'||cLimitador||
                'MONTO DE PAGO'
                ;--||chr(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  ELSE
     ---- // FORMATO EXCEL //
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                ' <style id="libro">'||chr(10)||
                '   <!--table'||chr(10)||
                '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                '        .texto'||chr(10)||
                '          {mso-number-format:"\@";}'||chr(10)||
                '        .numero'||chr(10)||
                '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                '        .fecha'||chr(10)||
                '          {mso-number-format:"dd\\-mm\\-yy";}'||chr(10)||
                '    -->'||chr(10)||
                ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // TITULOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DE PAGOS POLIZAS GG'||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE ' || TO_CHAR(dFecDesde,'MONTH') || ' AL ' ||
                TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecDesde,'MONTH') || ' DE ' || TO_CHAR(dFecDesde,'YYYY') || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     --<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA</font></th>
     cCadena := '<table border = 1><tr>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO POLIZA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. POLIZA UNICO</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NÚMERO DE REFERENCIA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. SINIESTRO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COBERTURA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA MOVIMIENTO.</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. APROB.</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO APROBACION.</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ESTATUS.</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCRIPCION TRANSACCION.</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CONCEPTO.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONEDA.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE CAMBIO.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO MON NACIONAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO NETO MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO NETO MON NACIONAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO MON NACIONAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA MON NACIONAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ISR RET MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ISR RET MON ORIGINAL.</font></th>' ||  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPC MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPC MON NACIONAL.</font></th>' ||  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPERO.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">BENEFICIARIO.</font></th>' ||  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE_ARCH_CARGA.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE ARCHIVO LOGEM.</font></th>' ||  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE CARGA.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE SEGURO.</font></th>' ||   
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE FACTURA.</font></th>' || 
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ID CARGA MASIVA.</font></th>' || 
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA CONTABLE PGO GG.</font></th>' || 
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE PAGO GG.</font></th>' ||       
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO CARGA PGO-GG.</font></th>' ||                   
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA - HORA DE CARGA.</font></th>' ||                   
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OBSERVACIONES POLIZA GG.</font></th>' ||   
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE PAGO</font></th></tr>';
     
     
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
  
  --	message('   Llama al Cursor   '); synchronize;	
  ---- // CARGA DE INFORMACIÓN //
  FOR X IN PAGOSSIN_Q LOOP
    --
    --	message('   Dentro del Cursor    '||X.USUARIO); synchronize;	    
  	--
    IF cFormato = 'TEXTO' THEN
       cCadena := X.IDPOLIZA           ||cLimitador||
                  X.POLUNIK            ||cLimitador||
                  X.NUMSINIREF         ||cLimitador||
                  X.IDSINIESTRO        ||cLimitador||
                  X.COD_PAGO           ||cLimitador||
                  X.EMI_FECHACOMP      ||cLimitador||
                  X.NUM_APROBACION     ||cLimitador||
                  X.TIPO_APROBACION    ||cLimitador||
                  X.ESTATUS            ||cLimitador||
                  X.CODTRANSAC         ||cLimitador||                     
                  X.CODCPTOTRANSAC     ||cLimitador||
                  X.COD_MONEDA         ||cLimitador||
                  X.PGO_MON_ORIG       ||cLimitador||                
                  X.PGO_MON_NAC        ||cLimitador||
                  X.PGO_NETO_MON_ORIG  ||cLimitador||              
                  X.PAGO_NETO_MON_LOC  ||cLimitador||
                  X.MONTO_DE_PAGO      ||cLimitador||
                  X.MONTO_DE_PAGO      ||cLimitador||                 
                  X.MONTOIVA           ||cLimitador||
                  X.MONTOIVA           ||cLimitador||                      
                  X.MONTOISR           ||cLimitador||
                  X.MONTOISR           ||cLimitador||
                  X.OPC_MONEDA         ||cLimitador||               
                  X.OPC_LOCAL          ||cLimitador||
                  X.EMI_USUARIO        ||cLimitador||              
                  X.BENEF              ||cLimitador||
                  X.NOMARCHCARGA       ||cLimitador||
                  X.ARCHIVO_LOGEM      ||cLimitador||
                  X.FecCarga           ||cLimitador||
                  X.TIPOSEGURO         ||cLimitador||
                  X.NUMERO_FACTURA     ||cLimitador||
                  X.IDPROCMASIVO       ||cLimitador||                
                  X.POLCONTA_GG        ||cLimitador||
                  X.FECHA_PAGO         ||cLimitador||
                  X.IMPORT_PAGO        ||cLimitador||
                  X.ARCHIVO_GG         ||cLimitador||                 
                  X.PGOGG_USUARIO      ||cLimitador||                                
                  X.PGOGG_FECHACOMP    ||cLimitador||                               
                  X.OBSERVACION_GG     ||cLimitador||                                 
                  X.WMONTO ;
       
    ELSE
       cCadena := '<tr>' ||                  
                  OC_ARCHIVO.CAMPO_HTML(X.IDPOLIZA,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.POLUNIK,'C')          ||          
                  OC_ARCHIVO.CAMPO_HTML(X.NUMSINIREF,'C')       ||       
                  OC_ARCHIVO.CAMPO_HTML(X.IDSINIESTRO,'C')      ||      
                  OC_ARCHIVO.CAMPO_HTML(X.COD_PAGO,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.EMI_FECHACOMP,'C')    ||    
                  OC_ARCHIVO.CAMPO_HTML(X.NUM_APROBACION,'C')   ||   
                  OC_ARCHIVO.CAMPO_HTML(X.TIPO_APROBACION,'C')  ||  
                  OC_ARCHIVO.CAMPO_HTML(X.ESTATUS,'C')          ||          
                  OC_ARCHIVO.CAMPO_HTML(X.CODTRANSAC,'C')       ||       
                  OC_ARCHIVO.CAMPO_HTML(X.CODCPTOTRANSAC,'C')   ||   
                  OC_ARCHIVO.CAMPO_HTML(X.COD_MONEDA,'C')       ||       
                  OC_ARCHIVO.CAMPO_HTML(X.PGO_MON_ORIG,'C')     ||     
                  OC_ARCHIVO.CAMPO_HTML(X.PGO_MON_NAC,'C')      ||      
                  OC_ARCHIVO.CAMPO_HTML(X.PGO_NETO_MON_ORIG,'C')||
                  OC_ARCHIVO.CAMPO_HTML(X.PAGO_NETO_MON_LOC,'C')||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTO_DE_PAGO,'C')    ||    
                  OC_ARCHIVO.CAMPO_HTML(X.MONTO_DE_PAGO,'C')    ||    
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOIVA,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOIVA,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOISR,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOISR,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.OPC_MONEDA,'C')       ||       
                  OC_ARCHIVO.CAMPO_HTML(X.OPC_LOCAL,'C')        ||        
                  OC_ARCHIVO.CAMPO_HTML(X.EMI_USUARIO,'C')      ||      
                  OC_ARCHIVO.CAMPO_HTML(X.BENEF,'C')            ||            
                  OC_ARCHIVO.CAMPO_HTML(X.NOMARCHCARGA,'C')     ||     
                  OC_ARCHIVO.CAMPO_HTML(X.ARCHIVO_LOGEM,'C')    ||    
                  OC_ARCHIVO.CAMPO_HTML(X.FecCarga,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.TIPOSEGURO,'C')       ||       
                  OC_ARCHIVO.CAMPO_HTML(X.NUMERO_FACTURA,'C')   ||   
                  OC_ARCHIVO.CAMPO_HTML(X.IDPROCMASIVO,'C')     ||     
                  OC_ARCHIVO.CAMPO_HTML(X.POLCONTA_GG,'C')      ||      
                  OC_ARCHIVO.CAMPO_HTML(X.FECHA_PAGO,'C')       ||            
                  OC_ARCHIVO.CAMPO_HTML(X.IMPORT_PAGO,'C')      ||        
                  OC_ARCHIVO.CAMPO_HTML(X.ARCHIVO_GG,'C')       ||         
                  OC_ARCHIVO.CAMPO_HTML(X.PGOGG_USUARIO,'C')    ||      
                  OC_ARCHIVO.CAMPO_HTML(X.PGOGG_FECHACOMP,'C')  ||    
                  OC_ARCHIVO.CAMPO_HTML(X.OBSERVACION_GG,'C')   ||     
                  OC_ARCHIVO.CAMPO_HTML(X.WMONTO,'C')           || '</tr>';           
        
              
    END IF;
    nLinea := nLinea + 1;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END LOOP;
  ---- // CIERRE DEL ARCHIVO  //    
  IF cFormato = 'EXCEL' THEN
--     OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
     cCadena := '</table></div></html>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
   
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
EXCEPTION 
  WHEN OTHERS THEN 
    raise_application_error(-20102,'Error en Generación Reporte PAGOS APROBADOS  de Siniestros: '|| ' ' ||SQLERRM);  
END;
PROCEDURE REPORTE_BUSCA_POLIZAGG  (cNomArchivo VARCHAR2,
                            PolizaGG    VARCHAR2,
                            cFormato    VARCHAR2,
                            nIdReporte   NUMBER) IS
--
cLimitador      VARCHAR2(1) :='|';
nLinea          NUMBER;
cCadena         VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;
--
nIdSiniestro      SINIESTRO.IdSiniestro%TYPE;
dFecRes           COBERTURA_SINIESTRO_ASEG.FecRes%TYPE;
nTipoCambio       TASAS_CAMBIO.Tasa_Cambio%TYPE;
--dFecCarga         DATOS_PART_SINIESTROS.FecSts%TYPE;
cRFCHospital      DATOS_PART_SINIESTROS.Campo1%TYPE;
--cNomArchCarga     DATOS_PART_SINIESTROS.Campo85%TYPE;
nMontoRvaMon      COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc      COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;
cNombreBenef      VARCHAR2(2000);
cNumDocTributario BENEF_SIN.Num_Doc_Tributario%TYPE;
cEntidadFinanc    BENEF_SIN_PAGOS.Entidad_Financiera%TYPE;
cCuentaCheque     BENEF_SIN_PAGOS.Nro_Cheque%TYPE;
cDescBanco        VARCHAR2(200);
nIVAPorcentaje    CATALOGO_DE_CONCEPTOS.PorcConcepto%TYPE;
nCodCia           POLIZAS.codcia%TYPE;
nCodEmpresa       DETALLE_POLIZA.CODEMPRESA%TYPE;
cCodPlantilla     CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE := 'EMITESINIESTRO';
cQueryIVA         VARCHAR2(4000) := NULL;
cQueryISR         VARCHAR2(4000) := NULL;
cValorCampoIVA    VARCHAR2(4000) := NULL;
cValorCampoISR    VARCHAR2(4000) := NULL;
--
--ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);    
muestralerta number;
--
					CURSOR PAGOSSIN_Q IS
            SELECT
                   SI.IDPOLIZA                                              IDPOLIZA, 
                   PP.NUMPOLUNICO                                           POLUNIK, 
                   SI.IDSINIESTRO                                           IDSINIESTRO, 
                   DA.COD_PAGO                                              COD_PAGO,
                   PMS.EMI_USUARIO                                          EMI_USUARIO,
                   PMS.EMI_FECHACOMP                                        EMI_FECHACOMP, 
                   PMS.EMI_FECHA                                            FECHAMVTO, 
                   A.NUM_APROBACION                                         NUM_APROBACION,
                   A.TIPO_APROBACION                                        TIPO_APROBACION, 
                   OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', A.STSAPROBACION) ESTATUS, 
                   DA.CODTRANSAC                                            CODTRANSAC, 
                   DA.CODCPTOTRANSAC                                        CODCPTOTRANSAC, 
                   SI.COD_MONEDA                                            COD_MONEDA, 
                   DA.MONTO_MONEDA                                          PGO_MON_ORIG,
                   DA.MONTO_LOCAL                                           PGO_MON_NAC , 
                   A.MONTO_MONEDA                                           PGO_NETO_MON_ORIG, 
                   A.MONTO_LOCAL                                            PAGO_NETO_MON_LOC,
                   --
                   NVL(SI.MONTO_RESERVA_MONEDA,0)- NVL(SI.MONTO_PAGO_MONEDA,0) OPC_MONEDA,
                   NVL(SI.MONTO_RESERVA_LOCAL,0) - NVL(SI.MONTO_PAGO_LOCAL,0) OPC_LOCAL,
                   --
                   DS.IDTIPOSEG                                             TIPOSEGURO, 
                   DS.IDDETSIN                                              IDDETSIN, 
                   DS.COD_ASEGURADO                                         ASEGURADO, 
                   SI.NUMSINIREF                                            NUMSINIREF, 
                   A.BENEF                                                  BENEF,
                   PP.CodCia                                                CodCia, 
                   PP.CodEmpresa                                            CodEmpresa  
                   --
                   ,TO_CHAR(PMS.CRGA_FECHACOMP,'DD/MM/YYYY HH24:MI:SS')     FecCarga   
                   ,PMS.CRGA_NOM_ARCHIVO                                    NomArchCarga 
                   ,PMS.MONTOPAGAR                                          MONTO_DE_PAGO
                   ,PMS.MONTOIVA                                            MONTOIVA 
                   ,PMS.MONTOISR                                            MONTOISR-- cNomArchCarga  MONTOIVA  MONTOISR
                   ,PMS.NUMFACTURA                                          NUMERO_FACTURA  
                   ,PMS.ARCHIVO_LOGEM                                       ARCHIVO_LOGEM 
                   ,TO_CHAR(PMS.IDPROCMASIVO)                               IDPROCMASIVO
                   ,PMS.POLCONTA_GG                                         POLCONTA_GG  
                   ,TO_CHAR(PMS.FECHA_PAGO,'DD/MM/YYYY')                    FECHA_PAGO    
                   ,PMS.IMPORT_PAGO                                         IMPORT_PAGO 
                   ,PMS.ARCHIVO_GG                                          ARCHIVO_GG
                   ,PMS.PGOGG_USUARIO                                       PGOGG_USUARIO
                   ,TO_CHAR(PMS.PGOGG_FECHACOMP,'DD/MM/YYYY HH24:MI:SS')    PGOGG_FECHACOMP
                   ,PMS.OBSERVACION_GG                                      OBSERVACION_GG
                   ,PMS.MONTOPAGAR                                          WMONTO
              FROM PROCESOS_MASIVOS_SEGUIMIENTO   PMS
                  ,SINIESTRO                       SI
                  ,APROBACION_ASEG                  A
                  ,DETALLE_APROBACION_ASEG         DA
                  ,DETALLE_SINIESTRO_ASEG DS,
                   POLIZAS PP 
             WHERE PMS.IDPROCMASIVO > 0 
               AND  PMS.EMI_TIPOPROCESO = 'PAGSIN'  
               AND  PMS.POLCONTA_GG    IS NOT NULL
               AND  PMS.POLCONTA_GG LIKE   '%'||PolizaGG||'%'---'%GG-16100252%'
             -----
               AND SI.IDSINIESTRO      = PMS.IDSINIESTRO
               AND SI.IDPOLIZA         = PMS.IDPOLIZA
             -----  
               AND DS.IDSINIESTRO      = SI.IDSINIESTRO
               AND DS.IDPOLIZA         = SI.IDPOLIZA
               and ds.iddetsin         = 1
               and ds.cod_asegurado    = si.cod_asegurado
               --add primary key (NUM_APROBACION, IDSINIESTRO, IDPOLIZA, IDDETSIN, COD_ASEGURADO)
               AND a.num_aprobacion           > 0 
              --- 
               AND a.num_aprobacion    > 0 
               AND A.IDSINIESTRO       = SI.IDSINIESTRO
               and a.idpoliza          = SI.IDPOLIZA
               AND a.iddetsin          = 1
               AND a.cod_asegurado     = si.cod_asegurado
               AND DA.NUM_APROBACION   = A.NUM_APROBACION
               AND DA.IDSINIESTRO      = A.IDSINIESTRO   
               --
               AND PP.IDPOLIZA         = PMS.IDPOLIZA 
               AND PP.CODCIA           = 1       
             ORDER BY 1,2,4,6   ;
             
--
BEGIN
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
    ---- // FORMATO TEXTO //
  IF cFormato = 'TEXTO' THEN    
     ---- // TITULOS //
     nLinea := 1; 
     cCadena     := 'THONA SEGUROS, S.A. de C.V.' || CHR(13);
     --Se reemplazaran las lineas de oc_archivo.Escribir_linea por:
     -- CLIENT_TEXT_IO.putf. Debe ser mas rapido para escribir.
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea := nLinea + 1;
     cCadena     := 'PAGOS DE LA POLIZA GG' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     --nLinea  := nLinea + 1;
     --cCadena := 'PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE '|| TO_CHAR(dFecDesde,'Month') || ' AL ' || TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecHasta,'Month') ||' DE ' || TO_CHAR(dFecHasta,'YYYY') || CHR(13);
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     --
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := 'NUMERO POLIZA'          ||cLimitador||'NO. POLIZA UNICO'       ||cLimitador||'NÚMERO DE REFERENCIA'   ||cLimitador||'NO. SINIESTRO'          ||cLimitador||
                'COBERTURA'              ||cLimitador||'FECHA MOVIMIENTO'       ||cLimitador||'NO. APROB.'             ||cLimitador||'TIPO APROBACION'        ||cLimitador||
                'ESTATUS'                ||cLimitador||'DESCRIPCION TRANSACCION'||cLimitador||'CONCEPTO'               ||cLimitador||
                'MONEDA'                 ||cLimitador||'TIPO DE CAMBIO'         ||cLimitador||
                'PAGO MON ORIGINAL'      ||cLimitador||'PAGO MON NACIONAL'      ||cLimitador||'PAGO NETO MON ORIGINAL' ||cLimitador||'PAGO NETO MON NACIONAL' ||cLimitador||                
                'PAGO MON ORIGINAL'      ||cLimitador||'PAGO MON NACIONAL'      ||cLimitador||'IVA MON ORIGINAL'       ||cLimitador||'IVA MON NACIONAL'       ||cLimitador||
                'ISR RET MON ORIGINAL'   ||cLimitador||'ISR RET MON ORIGINAL'   ||cLimitador||        
                'OPC MON ORIGINAL'       ||cLimitador||'OPC MON NACIONAL'       ||cLimitador||'OPERO'                  ||cLimitador||            
                'BENEFICIARIO'           ||cLimitador||'NOMBRE_ARCH_CARGA'      ||cLimitador||'NOMBRE ARCHIVO LOGEM'   ||cLimitador||'FECHA DE CARGA'         ||cLimitador||                                
                'TIPO DE SEGURO'         ||cLimitador||'NUMERO DE FACTURA'      ||cLimitador||
                'ID CARGA MASIVA'        ||cLimitador||'POLIZA CONTABLE PGO GG' ||cLimitador||'FECHA DE PAGO GG'       ||cLimitador||'IMPORTE DEL PAGO'       ||cLimitador|| 
                'ARCHIVO PGO-GG'         ||cLimitador||'USUARIO CARGA PGO-GG'   ||cLimitador||'FECHA - HORA DE CARGA'  ||cLimitador||	'OBSERVACIONES POLIZA GG'||cLimitador||
                'MONTO DE PAGO'
                ;--||chr(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  ELSE
     ---- // FORMATO EXCEL //
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                ' <style id="libro">'||chr(10)||
                '   <!--table'||chr(10)||
                '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                '        .texto'||chr(10)||
                '          {mso-number-format:"\@";}'||chr(10)||
                '        .numero'||chr(10)||
                '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                '        .fecha'||chr(10)||
                '          {mso-number-format:"dd\\-mm\\-yy";}'||chr(10)||
                '    -->'||chr(10)||
                ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // TITULOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DE PAGOS POLIZA GG'||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     --nLinea  := nLinea + 1;
     --cCadena := '<tr><th>PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE ' || TO_CHAR(dFecDesde,'MONTH') || ' AL ' ||
     --           TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecDesde,'MONTH') || ' DE ' || TO_CHAR(dFecDesde,'YYYY') || '</th></tr>'; 
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
--                 <th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA</font></th>' ||
                      cCadena := '<table border = 1><tr>'||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO POLIZA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. POLIZA UNICO</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NÚMERO DE REFERENCIA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. SINIESTRO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COBERTURA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA MOVIMIENTO.</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. APROB.</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO APROBACION.</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ESTATUS.</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCRIPCION TRANSACCION.</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CONCEPTO.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONEDA.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE CAMBIO.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO MON NACIONAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO NETO MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO NETO MON NACIONAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO MON NACIONAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA MON NACIONAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ISR RET MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ISR RET MON ORIGINAL.</font></th>' ||  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPC MON ORIGINAL.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPC MON NACIONAL.</font></th>' ||  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPERO.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">BENEFICIARIO.</font></th>' ||  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE_ARCH_CARGA.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE ARCHIVO LOGEM.</font></th>' ||  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE CARGA.</font></th>' ||                  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE SEGURO.</font></th>' ||   
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE FACTURA.</font></th>' || 
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ID CARGA MASIVA.</font></th>' || 
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA CONTABLE PGO GG.</font></th>' || 
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE PAGO GG.</font></th>' ||       
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO CARGA PGO-GG.</font></th>' ||                   
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA - HORA DE CARGA.</font></th>' ||                   
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OBSERVACIONES POLIZA GG.</font></th>' ||   
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE PAGO</font></th></tr>';
     
     
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
  
  --	message('   Llama al Cursor   '); synchronize;	
  ---- // CARGA DE INFORMACIÓN //
  FOR X IN PAGOSSIN_Q LOOP
    --
    --	message('   Dentro del Cursor    '||X.USUARIO); synchronize;	    
  	--
    IF cFormato = 'TEXTO' THEN
       cCadena := X.IDPOLIZA           ||cLimitador||
                  X.POLUNIK            ||cLimitador||
                  X.NUMSINIREF         ||cLimitador||
                  X.IDSINIESTRO        ||cLimitador||
                  X.COD_PAGO           ||cLimitador||
                  X.EMI_FECHACOMP      ||cLimitador||
                  X.NUM_APROBACION     ||cLimitador||
                  X.TIPO_APROBACION    ||cLimitador||
                  X.ESTATUS            ||cLimitador||
                  X.CODTRANSAC         ||cLimitador||                     
                  X.CODCPTOTRANSAC     ||cLimitador||
                  X.COD_MONEDA         ||cLimitador||
                  X.PGO_MON_ORIG       ||cLimitador||                
                  X.PGO_MON_NAC        ||cLimitador||
                  X.PGO_NETO_MON_ORIG  ||cLimitador||              
                  X.PAGO_NETO_MON_LOC  ||cLimitador||
                  X.MONTO_DE_PAGO      ||cLimitador||
                  X.MONTO_DE_PAGO      ||cLimitador||                 
                  X.MONTOIVA           ||cLimitador||
                  X.MONTOIVA           ||cLimitador||                      
                  X.MONTOISR           ||cLimitador||
                  X.MONTOISR           ||cLimitador||
                  X.OPC_MONEDA         ||cLimitador||               
                  X.OPC_LOCAL          ||cLimitador||
                  X.EMI_USUARIO        ||cLimitador||              
                  X.BENEF              ||cLimitador||
                  X.NOMARCHCARGA       ||cLimitador||
                  X.ARCHIVO_LOGEM      ||cLimitador||
                  X.FecCarga           ||cLimitador||
                  X.TIPOSEGURO         ||cLimitador||
                  X.NUMERO_FACTURA     ||cLimitador||
                  X.IDPROCMASIVO       ||cLimitador||                
                  X.POLCONTA_GG        ||cLimitador||
                  X.FECHA_PAGO         ||cLimitador||
                  X.IMPORT_PAGO        ||cLimitador||
                  X.ARCHIVO_GG         ||cLimitador||                 
                  X.PGOGG_USUARIO      ||cLimitador||                                
                  X.PGOGG_FECHACOMP    ||cLimitador||                               
                  X.OBSERVACION_GG     ||cLimitador||                                 
                  X.WMONTO ;
       
    ELSE
       cCadena := '<tr>' ||                  
                  OC_ARCHIVO.CAMPO_HTML(X.IDPOLIZA,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.POLUNIK,'C')          ||          
                  OC_ARCHIVO.CAMPO_HTML(X.NUMSINIREF,'C')       ||       
                  OC_ARCHIVO.CAMPO_HTML(X.IDSINIESTRO,'C')      ||      
                  OC_ARCHIVO.CAMPO_HTML(X.COD_PAGO,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.EMI_FECHACOMP,'C')    ||    
                  OC_ARCHIVO.CAMPO_HTML(X.NUM_APROBACION,'C')   ||   
                  OC_ARCHIVO.CAMPO_HTML(X.TIPO_APROBACION,'C')  ||  
                  OC_ARCHIVO.CAMPO_HTML(X.ESTATUS,'C')          ||          
                  OC_ARCHIVO.CAMPO_HTML(X.CODTRANSAC,'C')       ||       
                  OC_ARCHIVO.CAMPO_HTML(X.CODCPTOTRANSAC,'C')   ||   
                  OC_ARCHIVO.CAMPO_HTML(X.COD_MONEDA,'C')       ||       
                  OC_ARCHIVO.CAMPO_HTML(X.PGO_MON_ORIG,'C')     ||     
                  OC_ARCHIVO.CAMPO_HTML(X.PGO_MON_NAC,'C')      ||      
                  OC_ARCHIVO.CAMPO_HTML(X.PGO_NETO_MON_ORIG,'C')||
                  OC_ARCHIVO.CAMPO_HTML(X.PAGO_NETO_MON_LOC,'C')||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTO_DE_PAGO,'C')    ||    
                  OC_ARCHIVO.CAMPO_HTML(X.MONTO_DE_PAGO,'C')    ||    
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOIVA,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOIVA,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOISR,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOISR,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.OPC_MONEDA,'C')       ||       
                  OC_ARCHIVO.CAMPO_HTML(X.OPC_LOCAL,'C')        ||        
                  OC_ARCHIVO.CAMPO_HTML(X.EMI_USUARIO,'C')      ||      
                  OC_ARCHIVO.CAMPO_HTML(X.BENEF,'C')            ||            
                  OC_ARCHIVO.CAMPO_HTML(X.NOMARCHCARGA,'C')     ||     
                  OC_ARCHIVO.CAMPO_HTML(X.ARCHIVO_LOGEM,'C')    ||    
                  OC_ARCHIVO.CAMPO_HTML(X.FecCarga,'C')         ||         
                  OC_ARCHIVO.CAMPO_HTML(X.TIPOSEGURO,'C')       ||       
                  OC_ARCHIVO.CAMPO_HTML(X.NUMERO_FACTURA,'C')   ||   
                  OC_ARCHIVO.CAMPO_HTML(X.IDPROCMASIVO,'C')     ||     
                  OC_ARCHIVO.CAMPO_HTML(X.POLCONTA_GG,'C')      ||      
                  OC_ARCHIVO.CAMPO_HTML(X.FECHA_PAGO,'C')       ||            
                  OC_ARCHIVO.CAMPO_HTML(X.IMPORT_PAGO,'C')      ||        
                  OC_ARCHIVO.CAMPO_HTML(X.ARCHIVO_GG,'C')       ||         
                  OC_ARCHIVO.CAMPO_HTML(X.PGOGG_USUARIO,'C')    ||      
                  OC_ARCHIVO.CAMPO_HTML(X.PGOGG_FECHACOMP,'C')  ||    
                  OC_ARCHIVO.CAMPO_HTML(X.OBSERVACION_GG,'C')   ||     
                  OC_ARCHIVO.CAMPO_HTML(X.WMONTO,'C')           || '</tr>';           
        
              
    END IF;
    nLinea := nLinea + 1;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END LOOP;
  ---- // CIERRE DEL ARCHIVO  //    
  IF cFormato = 'EXCEL' THEN
--     OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
     cCadena := '</table></div></html>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
   
    INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
    SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
    FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
    WHERE A.CODUSER = B.CODUSR
    AND B.IDEXTRACCION = nIdReporte ;
    DELETE SICAS_OC.EXTRACCION_DE_REPORTES
    WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
EXCEPTION 
  WHEN OTHERS THEN 
    raise_application_error(-20105,'Error en Generación Reporte PAGOS APROBADOS  de Siniestros: '|| ' ' ||SQLERRM);  
    
END;
PROCEDURE REPORTE_FACTURAS(cNomArchivo VARCHAR2, nIdPoliza   NUMBER,cFormato    VARCHAR2,nIdReporte   NUMBER) IS
--
cLimitador      VARCHAR2(1) :='|';
nLinea          NUMBER;
cCadena         VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;
--
nIdSiniestro      SINIESTRO.IdSiniestro%TYPE;
dFecRes           COBERTURA_SINIESTRO_ASEG.FecRes%TYPE;
nTipoCambio       TASAS_CAMBIO.Tasa_Cambio%TYPE;
--dFecCarga         DATOS_PART_SINIESTROS.FecSts%TYPE;
cRFCHospital      DATOS_PART_SINIESTROS.Campo1%TYPE;
--cNomArchCarga     DATOS_PART_SINIESTROS.Campo85%TYPE;
nMontoRvaMon      COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc      COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;
cNombreBenef      VARCHAR2(2000);
cNumDocTributario BENEF_SIN.Num_Doc_Tributario%TYPE;
cEntidadFinanc    BENEF_SIN_PAGOS.Entidad_Financiera%TYPE;
cCuentaCheque     BENEF_SIN_PAGOS.Nro_Cheque%TYPE;
cDescBanco        VARCHAR2(200);
nIVAPorcentaje    CATALOGO_DE_CONCEPTOS.PorcConcepto%TYPE;
nCodCia           POLIZAS.codcia%TYPE;
nCodEmpresa       DETALLE_POLIZA.CODEMPRESA%TYPE;
cCodPlantilla     CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE := 'EMITESINIESTRO';
cQueryIVA         VARCHAR2(4000) := NULL;
cQueryISR         VARCHAR2(4000) := NULL;
cValorCampoIVA    VARCHAR2(4000) := NULL;
cValorCampoISR    VARCHAR2(4000) := NULL;
--
--ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);    
muestralerta       number;
--
MNTO_PAGOS         COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE; 
nMtoCobertMoneda   COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
--
CURSOR PAGOSSIN_Q(WPOLIZA IN NUMBER ) IS
SELECT A.IDPOLIZA IDPOLIZA, A.IDSINIESTRO IDSINIESTRO, A.COD_ASEGURADO COD_ASEGURADO, A.MONTOIVA MONTOIVA, A.MONTOPAGAR MONTOPAGAR, A.MONTOISR MONTOISR, 
       A.CODCOBERT CODCOBERT, A.NUMFACTURA NUMFACTURA,  A.EMI_REGDATOSPROC EMI_REGDATOSPROC,A.ARCHIVO_LOGEM ARCHIVO_LOGEM, TO_CHAR(A.EMI_FECHACOMP,'YYYYMMDDHH24MMSS')   EMI_FECHACOMP
FROM PROCESOS_MASIVOS_SEGUIMIENTO  A
WHERE A.EMI_TIPOPROCESO = 'PAGSIN'
AND A.IDPOLIZA = nIdPoliza--10558
AND A.NUMFACTURA IS NOT NULL
ORDER BY A.EMI_FECHACOMP
;
      
				 
--
BEGIN
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
    ---- // FORMATO TEXTO //
  IF cFormato = 'TEXTO' THEN    
     ---- // TITULOS //
     nLinea := 1; 
     cCadena     := 'THONA SEGUROS, S.A. de C.V.' || CHR(13);
     --Se reemplazaran las lineas de oc_archivo.Escribir_linea por:
     -- CLIENT_TEXT_IO.putf. Debe ser mas rapido para escribir.
     --OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea := nLinea + 1;
     cCadena     := 'FACTURAS' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := ' PERIODO DE VIGENCIA DE LA POLIZA '|| CHR(13); ---PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE '|| TO_CHAR(dFecDesde,'Month') || ' AL ' || TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecHasta,'Month') ||' DE ' || TO_CHAR(dFecHasta,'YYYY') || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  ELSE
     ---- // FORMATO EXCEL //
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                ' <style id="libro">'||chr(10)||
                '   <!--table'||chr(10)||
                '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                '        .texto'||chr(10)||
                '          {mso-number-format:"\@";}'||chr(10)||
                '        .numero'||chr(10)||
                '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                '        .fecha'||chr(10)||
                '          {mso-number-format:"dd\\-mm\\-yy";}'||chr(10)||
                '    -->'||chr(10)||
                ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // TITULOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DE FACTURAS'||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>PERIODO DE VIGENCIA DE LA POLIZA ' ||'</th></tr>';  -- TO_CHAR(dFecDesde,'DD') || ' DE ' || TO_CHAR(dFecDesde,'MONTH') || ' AL ' ||
                --TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecDesde,'MONTH') || ' DE ' || TO_CHAR(dFecDesde,'YYYY') || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE SINIESTRO</font></th>'   ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ASEGURADO</font></th>'             ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COBERTURA</font></th>'             ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE PAGO</font></th>'         ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE IVA</font></th>'          ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE ISR</font></th>'          ||  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FACTURA</font></th>'               ||                               
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF"> ARCHIVO LOGEM </font></th>'       ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE PROCESO</font></th></tr>' ;
    
                
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
  
  --	message('   Llama al Cursor   '); synchronize;	
  ---- // CARGA DE INFORMACIÓN //
  FOR X IN PAGOSSIN_Q(nIdPoliza) LOOP
    --
    --	message('   Dentro del Cursor    '||X.USUARIO); synchronize;	    
  	--
 
    IF cFormato = 'TEXTO' THEN
       cCadena := X.IDPOLIZA     ||cLimitador||	       
									X.IDSINIESTRO  ||cLimitador||	   
									X.COD_ASEGURADO||cLimitador||	  
									X.CODCOBERT    ||cLimitador||	
									X.MONTOPAGAR   ||cLimitador||	
									X.MONTOIVA     ||cLimitador||	 
									X.MONTOISR     ||cLimitador||	   
									X.NUMFACTURA   ||cLimitador||	
								  X.ARCHIVO_LOGEM||cLimitador||	   
									X.EMI_FECHACOMP;
       
        
       
    ELSE
       cCadena := '<tr>'                                      ||
                  OC_ARCHIVO.CAMPO_HTML(X.IDPOLIZA,'C')       ||
                  OC_ARCHIVO.CAMPO_HTML(X.IDSINIESTRO,'C')    ||
                  OC_ARCHIVO.CAMPO_HTML(X.COD_ASEGURADO,'C')  ||
                  OC_ARCHIVO.CAMPO_HTML(X.CODCOBERT,'C')      ||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOPAGAR,'C')     ||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOIVA,'C')       ||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOISR,'C')       ||
                  OC_ARCHIVO.CAMPO_HTML(X.NUMFACTURA,'C')     ||   
                  OC_ARCHIVO.CAMPO_HTML(X.ARCHIVO_LOGEM,'C')  ||                
                  OC_ARCHIVO.CAMPO_HTML(X.EMI_FECHACOMP,'C')  || '</tr>';       
        
    END IF;
    nLinea := nLinea + 1;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END LOOP;
  ---- // CIERRE DEL ARCHIVO  //    
  IF cFormato = 'EXCEL' THEN
--     OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
     cCadena := '</table></div></html>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
  
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
   
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
  --
EXCEPTION 
  WHEN OTHERS THEN 
    
    raise_application_error(-20102,'Error en Generación Reporte SINIESTRALIDAD: '|| ' ' ||SQLERRM);  
    
END;
PROCEDURE REPORTE_FACTURA_2(cNomArchivo VARCHAR2,nIdFactura   VARCHAR2,cFormato    VARCHAR2,nIdReporte   NUMBER) IS
--
cLimitador      VARCHAR2(1) :='|';
nLinea          NUMBER;
cCadena         VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;
--
nIdSiniestro      SINIESTRO.IdSiniestro%TYPE;
dFecRes           COBERTURA_SINIESTRO_ASEG.FecRes%TYPE;
nTipoCambio       TASAS_CAMBIO.Tasa_Cambio%TYPE;
--dFecCarga         DATOS_PART_SINIESTROS.FecSts%TYPE;
cRFCHospital      DATOS_PART_SINIESTROS.Campo1%TYPE;
--cNomArchCarga     DATOS_PART_SINIESTROS.Campo85%TYPE;
nMontoRvaMon      COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc      COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;
cNombreBenef      VARCHAR2(2000);
cNumDocTributario BENEF_SIN.Num_Doc_Tributario%TYPE;
cEntidadFinanc    BENEF_SIN_PAGOS.Entidad_Financiera%TYPE;
cCuentaCheque     BENEF_SIN_PAGOS.Nro_Cheque%TYPE;
cDescBanco        VARCHAR2(200);
nIVAPorcentaje    CATALOGO_DE_CONCEPTOS.PorcConcepto%TYPE;
nCodCia           POLIZAS.codcia%TYPE;
nCodEmpresa       DETALLE_POLIZA.CODEMPRESA%TYPE;
cCodPlantilla     CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE := 'EMITESINIESTRO';
cQueryIVA         VARCHAR2(4000) := NULL;
cQueryISR         VARCHAR2(4000) := NULL;
cValorCampoIVA    VARCHAR2(4000) := NULL;
cValorCampoISR    VARCHAR2(4000) := NULL;
--
--ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);    
muestralerta       number;
--
MNTO_PAGOS         COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE; 
nMtoCobertMoneda   COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
--
CURSOR PAGOSSIN_Q(WnIdFactura IN VARCHAR2 ) IS
SELECT A.IDPOLIZA IDPOLIZA, A.IDSINIESTRO IDSINIESTRO, A.COD_ASEGURADO COD_ASEGURADO, A.MONTOIVA MONTOIVA, A.MONTOPAGAR MONTOPAGAR, A.MONTOISR MONTOISR, 
       A.CODCOBERT CODCOBERT, A.NUMFACTURA NUMFACTURA,  A.EMI_REGDATOSPROC EMI_REGDATOSPROC,A.ARCHIVO_LOGEM ARCHIVO_LOGEM, TO_CHAR(A.EMI_FECHACOMP,'YYYY-MM-DD HH24:MM:SS')   EMI_FECHACOMP
      ,A.NUM_ASISTENCIA NUM_ASISTENCIA,A.RFC_HOSPITAL RFC_HOSPITAL,A.RFC_ASISTENCIADORA  RFC_ASISTENCIADORA,A.IDPROCMASIVO  IDPROCESOMASIVO
FROM PROCESOS_MASIVOS_SEGUIMIENTO  A
WHERE A.EMI_TIPOPROCESO = 'PAGSIN'
AND A.IDPOLIZA > 0 -- nIdPoliza--10558
AND A.NUMFACTURA LIKE '%'||WnIdFactura||'%'
ORDER BY A.EMI_FECHACOMP
;
      
				 
--
BEGIN
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
    ---- // FORMATO TEXTO //
  IF cFormato = 'TEXTO' THEN    
     ---- // TITULOS //
     nLinea := 1; 
     cCadena     := 'THONA SEGUROS, S.A. de C.V.' || CHR(13);
     --Se reemplazaran las lineas de oc_archivo.Escribir_linea por:
     -- CLIENT_TEXT_IO.putf. Debe ser mas rapido para escribir.
     --OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea := nLinea + 1;
     cCadena     := 'FACTURAS' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := ' PERIODO DE VIGENCIA DE LA POLIZA '|| CHR(13); ---PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE '|| TO_CHAR(dFecDesde,'Month') || ' AL ' || TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecHasta,'Month') ||' DE ' || TO_CHAR(dFecHasta,'YYYY') || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  ELSE
     ---- // FORMATO EXCEL //
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                ' <style id="libro">'||chr(10)||
                '   <!--table'||chr(10)||
                '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                '        .texto'||chr(10)||
                '          {mso-number-format:"\@";}'||chr(10)||
                '        .numero'||chr(10)||
                '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                '        .fecha'||chr(10)||
                '          {mso-number-format:"dd\\-mm\\-yy";}'||chr(10)||
                '    -->'||chr(10)||
                ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // TITULOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DE FACTURAS'||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>PERIODO DE VIGENCIA DE LA POLIZA ' ||'</th></tr>';  -- TO_CHAR(dFecDesde,'DD') || ' DE ' || TO_CHAR(dFecDesde,'MONTH') || ' AL ' ||
                --TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecDesde,'MONTH') || ' DE ' || TO_CHAR(dFecDesde,'YYYY') || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE SINIESTRO</font></th>'   ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ASEGURADO</font></th>'             ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COBERTURA</font></th>'             ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE PAGO</font></th>'         ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE IVA</font></th>'          ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE ISR</font></th>'          ||  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FACTURA</font></th>'               ||                               
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF"> ARCHIVO LOGEM </font></th>'       ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE PROCESO</font></th>'      || 
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUM ASISTENCIA</font></th>'        || 
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC_HOSPITAL</font></th>'          ||    
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC_ASISTENCIADORA</font></th>'    ||                                              
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IDPROCESO_MASIVO</font></th></tr>' ; 
    
                
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
  
  	--message('   Llama al Cursor   '); synchronize;	
  ---- // CARGA DE INFORMACIÓN //
  FOR X IN PAGOSSIN_Q(nIdFactura) LOOP
    --
    --	message('   Dentro del Cursor    '); synchronize;	    
  	--
 
    IF cFormato = 'TEXTO' THEN
       cCadena := X.IDPOLIZA          ||cLimitador||	       
									X.IDSINIESTRO       ||cLimitador||	   
									X.COD_ASEGURADO     ||cLimitador||	  
									X.CODCOBERT         ||cLimitador||	
									X.MONTOPAGAR        ||cLimitador||	
									X.MONTOIVA          ||cLimitador||	 
									X.MONTOISR          ||cLimitador||	   
									X.NUMFACTURA        ||cLimitador||	
								  X.ARCHIVO_LOGEM     ||cLimitador||	   
									X.EMI_FECHACOMP     ||cLimitador||
									X.NUM_ASISTENCIA    ||cLimitador||
									X.RFC_HOSPITAL      ||cLimitador||
									X.RFC_ASISTENCIADORA||cLimitador||
									X.IDPROCESOMASIVO   
									;
       
        
       
    ELSE
       cCadena := '<tr>'                                          ||
                  OC_ARCHIVO.CAMPO_HTML(X.IDPOLIZA,'C')           ||
                  OC_ARCHIVO.CAMPO_HTML(X.IDSINIESTRO,'C')        ||
                  OC_ARCHIVO.CAMPO_HTML(X.COD_ASEGURADO,'C')      ||
                  OC_ARCHIVO.CAMPO_HTML(X.CODCOBERT,'C')          ||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOPAGAR,'C')         ||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOIVA,'C')           ||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOISR,'C')           ||
                  OC_ARCHIVO.CAMPO_HTML(X.NUMFACTURA,'C')         ||   
                  OC_ARCHIVO.CAMPO_HTML(X.ARCHIVO_LOGEM,'C')      ||                
                  OC_ARCHIVO.CAMPO_HTML(X.EMI_FECHACOMP,'C')      ||  
                  OC_ARCHIVO.CAMPO_HTML(X.NUM_ASISTENCIA,'C')     ||
                  OC_ARCHIVO.CAMPO_HTML(X.RFC_HOSPITAL,'C')       ||   
                  OC_ARCHIVO.CAMPO_HTML(X.RFC_ASISTENCIADORA,'C') ||                
                  OC_ARCHIVO.CAMPO_HTML(X.IDPROCESOMASIVO,'C')    || '</tr>';             
        
    END IF;
    nLinea := nLinea + 1;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END LOOP;
  
  --message('  Sale del Cursor ');  synchronize;
  
  ---- // CIERRE DEL ARCHIVO  //    
  IF cFormato = 'EXCEL' THEN
--     OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
     cCadena := '</table></div></html>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
  
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
   
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
  --
EXCEPTION 
  WHEN OTHERS THEN 
    
    raise_application_error(-20105,'Error en Generación Reporte SINIESTRALIDAD: '|| ' ' ||SQLERRM);  
    
END;
PROCEDURE CONCIL_MANPAL(cNomArchivo VARCHAR2,cFormato    VARCHAR2,nIdReporte   NUMBER) IS
--
cLimitador      VARCHAR2(1) :='|';
nLinea          NUMBER;
cCadena         VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;
--
nIdSiniestro      SINIESTRO.IdSiniestro%TYPE;
dFecRes           COBERTURA_SINIESTRO_ASEG.FecRes%TYPE;
nTipoCambio       TASAS_CAMBIO.Tasa_Cambio%TYPE;
--dFecCarga         DATOS_PART_SINIESTROS.FecSts%TYPE;
cRFCHospital      DATOS_PART_SINIESTROS.Campo1%TYPE;
--cNomArchCarga     DATOS_PART_SINIESTROS.Campo85%TYPE;
nMontoRvaMon      COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc      COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;
cNombreBenef      VARCHAR2(2000);
cNumDocTributario BENEF_SIN.Num_Doc_Tributario%TYPE;
cEntidadFinanc    BENEF_SIN_PAGOS.Entidad_Financiera%TYPE;
cCuentaCheque     BENEF_SIN_PAGOS.Nro_Cheque%TYPE;
cDescBanco        VARCHAR2(200);
nIVAPorcentaje    CATALOGO_DE_CONCEPTOS.PorcConcepto%TYPE;
nCodCia           POLIZAS.codcia%TYPE;
nCodEmpresa       DETALLE_POLIZA.CODEMPRESA%TYPE;
cCodPlantilla     CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE := 'EMITESINIESTRO';
cQueryIVA         VARCHAR2(4000) := NULL;
cQueryISR         VARCHAR2(4000) := NULL;
cValorCampoIVA    VARCHAR2(4000) := NULL;
cValorCampoISR    VARCHAR2(4000) := NULL;
--
--ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);    
muestralerta       number;
--
MNTO_PAGOS         COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE; 
nMtoCobertMoneda   COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
--
CURSOR PAGOSSIN_Q IS
select s2.valor1          IDPOLIZA
      ,s2.valor2          IDSINIESTRO 
      ,s2.valor3          COBERTURA
      ,s2.valor4          NUMMOD
      ,s2.mtolocal        MntoAjusPgo 
      ,s.idtransaccion    TRANSACCION 
      ,s.idproceso        idproceso
      ,s.fechatransaccion FECH_TRANSACCION
      ,s.usuariogenero    USUSARIO_QUE_GENERO
      ,s2.correlativo     correlativo
      ,s2.codsubproceso   COD_SUBPROCESO
      ,s2.objeto          OBJETO
from transaccion  s
    ,detalle_transaccion s2
where s.idproceso = 6
and s2.idtransaccion = s.idtransaccion
order by 1,2,4,8 --1,2,8,9,11;
;
      
				 
--
BEGIN
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
    ---- // FORMATO TEXTO //
  IF cFormato = 'TEXTO' THEN    
     ---- // TITULOS //
     nLinea := 1; 
     cCadena     := 'THONA SEGUROS, S.A. de C.V.' || CHR(13);
     --Se reemplazaran las lineas de oc_archivo.Escribir_linea por:
     -- CLIENT_TEXT_IO.putf. Debe ser mas rapido para escribir.
     --OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea := nLinea + 1;
     cCadena     := 'TRANSACCIONES' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := ' PERIODO DE VIGENCIA DE LA POLIZA '|| CHR(13); ---PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE '|| TO_CHAR(dFecDesde,'Month') || ' AL ' || TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecHasta,'Month') ||' DE ' || TO_CHAR(dFecHasta,'YYYY') || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  ELSE
     ---- // FORMATO EXCEL //
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                ' <style id="libro">'||chr(10)||
                '   <!--table'||chr(10)||
                '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                '        .texto'||chr(10)||
                '          {mso-number-format:"\@";}'||chr(10)||
                '        .numero'||chr(10)||
                '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                '        .fecha'||chr(10)||
                '          {mso-number-format:"dd\\-mm\\-yy";}'||chr(10)||
                '    -->'||chr(10)||
                ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // TITULOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DE FACTURAS'||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>PERIODO DE VIGENCIA DE LA POLIZA ' ||'</th></tr>';  -- TO_CHAR(dFecDesde,'DD') || ' DE ' || TO_CHAR(dFecDesde,'MONTH') || ' AL ' ||
                --TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecDesde,'MONTH') || ' DE ' || TO_CHAR(dFecDesde,'YYYY') || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     
       
     cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE SINIESTRO</font></th>'   ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COBERTURA</font></th>'             ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE MOVIMIENTO</font></th>'             ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE PAGO</font></th>'         ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TRANSACCION</font></th>'          ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ID PROCESO</font></th>'          ||  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE TRANSACCION</font></th>'               ||                               
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO QUE LO GENERO</font></th>'       ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CORRELATIVO</font></th>'      || 
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUM ASISTENCIA</font></th>'        || 
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COD SUBPROCESO</font></th>'          ||    
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC_ASISTENCIADORA</font></th>'    ||                                              
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OBJETO</font></th></tr>' ; 
    
                
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
  
  	--message('   Llama al Cursor   '); synchronize;	
  ---- // CARGA DE INFORMACIÓN //
  FOR X IN PAGOSSIN_Q LOOP
    --
    --	message('   Dentro del Cursor    '); synchronize;	    
  	--
 
    IF cFormato = 'TEXTO' THEN
       cCadena := X.IDPOLIZA            ||cLimitador||	       
									X.IDSINIESTRO         ||cLimitador||	   
									X.COBERTURA           ||cLimitador||	  
									X.NUMMOD              ||cLimitador||	
									X.MntoAjusPgo         ||cLimitador||	
									X.TRANSACCION         ||cLimitador||	 
									X.idproceso           ||cLimitador||	   
									X.FECH_TRANSACCION    ||cLimitador||	
								  X.USUSARIO_QUE_GENERO ||cLimitador||	   
									X.correlativo         ||cLimitador||
									X.COD_SUBPROCESO      ||cLimitador||
									X.OBJETO      ;--||cLimitador||
									--X.RFC_ASISTENCIADORA||cLimitador||
									--X.IDPROCESOMASIVO   
									--;
          
    ELSE
       cCadena := '<tr>'                                          ||
                  OC_ARCHIVO.CAMPO_HTML(X.IDPOLIZA,'C')           ||
                  OC_ARCHIVO.CAMPO_HTML(X.IDSINIESTRO,'C')        ||
                  OC_ARCHIVO.CAMPO_HTML(X.COBERTURA,'C')          ||
                  OC_ARCHIVO.CAMPO_HTML(X.NUMMOD,'C')             ||
                  OC_ARCHIVO.CAMPO_HTML(X.MntoAjusPgo,'C')        ||
                  OC_ARCHIVO.CAMPO_HTML(X.TRANSACCION,'C')        ||
                  OC_ARCHIVO.CAMPO_HTML(X.idproceso,'C')          ||
                  OC_ARCHIVO.CAMPO_HTML(X.FECH_TRANSACCION,'C')   ||   
                  OC_ARCHIVO.CAMPO_HTML(X.USUSARIO_QUE_GENERO,'C')||                
                  OC_ARCHIVO.CAMPO_HTML(X.correlativo,'C')        ||  
                  OC_ARCHIVO.CAMPO_HTML(X.COD_SUBPROCESO,'C')     ||
                  OC_ARCHIVO.CAMPO_HTML(X.OBJETO,'C')             || '</tr>';   
                  --OC_ARCHIVO.CAMPO_HTML(X.RFC_ASISTENCIADORA,'C') ||                
                  --OC_ARCHIVO.CAMPO_HTML(X.IDPROCESOMASIVO,'C')    || '</tr>';       
        
    END IF;
    nLinea := nLinea + 1;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END LOOP;
  
  --message('  Sale del Cursor ');  synchronize;
  
  ---- // CIERRE DEL ARCHIVO  //    
  IF cFormato = 'EXCEL' THEN
--     OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
     cCadena := '</table></div></html>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
   
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
  --
EXCEPTION 
  WHEN OTHERS THEN 
    raise_application_error(-20102,'Error en Generación Reporte FACTURAS POR ASISTENCIADORA: '|| ' ' ||SQLERRM);  
    
END;
PROCEDURE REPORTE_ASISTENCIADORA(cNomArchivo VARCHAR2,nAsistencia   VARCHAR2,cFormato    VARCHAR2,nIdReporte   NUMBER) IS
--
cLimitador      VARCHAR2(1) :='|';
nLinea          NUMBER;
cCadena         VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;
--
nIdSiniestro      SINIESTRO.IdSiniestro%TYPE;
dFecRes           COBERTURA_SINIESTRO_ASEG.FecRes%TYPE;
nTipoCambio       TASAS_CAMBIO.Tasa_Cambio%TYPE;
--dFecCarga         DATOS_PART_SINIESTROS.FecSts%TYPE;
cRFCHospital      DATOS_PART_SINIESTROS.Campo1%TYPE;
--cNomArchCarga     DATOS_PART_SINIESTROS.Campo85%TYPE;
nMontoRvaMon      COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc      COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;
cNombreBenef      VARCHAR2(2000);
cNumDocTributario BENEF_SIN.Num_Doc_Tributario%TYPE;
cEntidadFinanc    BENEF_SIN_PAGOS.Entidad_Financiera%TYPE;
cCuentaCheque     BENEF_SIN_PAGOS.Nro_Cheque%TYPE;
cDescBanco        VARCHAR2(200);
nIVAPorcentaje    CATALOGO_DE_CONCEPTOS.PorcConcepto%TYPE;
nCodCia           POLIZAS.codcia%TYPE;
nCodEmpresa       DETALLE_POLIZA.CODEMPRESA%TYPE;
cCodPlantilla     CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE := 'EMITESINIESTRO';
cQueryIVA         VARCHAR2(4000) := NULL;
cQueryISR         VARCHAR2(4000) := NULL;
cValorCampoIVA    VARCHAR2(4000) := NULL;
cValorCampoISR    VARCHAR2(4000) := NULL;
--
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);    
muestralerta       number;
--
MNTO_PAGOS         COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE; 
nMtoCobertMoneda   COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
--
CURSOR PAGOSSIN_Q(WnAsistencia IN VARCHAR2 ) IS
SELECT A.IDPOLIZA IDPOLIZA, A.IDSINIESTRO IDSINIESTRO, A.COD_ASEGURADO COD_ASEGURADO, A.MONTOIVA MONTOIVA, A.MONTOPAGAR MONTOPAGAR, A.MONTOISR MONTOISR, 
       A.CODCOBERT CODCOBERT, A.NUMFACTURA NUMFACTURA,  A.EMI_REGDATOSPROC EMI_REGDATOSPROC,A.ARCHIVO_LOGEM ARCHIVO_LOGEM, TO_CHAR(A.EMI_FECHACOMP,'YYYY-MM-DD HH24:MM:SS')   EMI_FECHACOMP
      ,A.NUM_ASISTENCIA NUM_ASISTENCIA,A.RFC_HOSPITAL RFC_HOSPITAL,A.RFC_ASISTENCIADORA  RFC_ASISTENCIADORA,A.IDPROCMASIVO  IDPROCESOMASIVO
FROM PROCESOS_MASIVOS_SEGUIMIENTO  A
WHERE A.EMI_TIPOPROCESO = 'PAGSIN'
AND A.IDPOLIZA > 0 -- nIdPoliza--10558
AND A.RFC_ASISTENCIADORA LIKE '%'||WnAsistencia||'%'
ORDER BY A.EMI_FECHACOMP
;
      
				 
--
BEGIN
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
    
    ---- // FORMATO TEXTO //
  IF cFormato = 'TEXTO' THEN    
     ---- // TITULOS //
     nLinea := 1; 
     cCadena     := 'THONA SEGUROS, S.A. de C.V.' || CHR(13);
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea := nLinea + 1;
     cCadena     := 'FACTURAS' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := ' PERIODO DE VIGENCIA DE LA POLIZA '|| CHR(13); ---PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE '|| TO_CHAR(dFecDesde,'Month') || ' AL ' || TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecHasta,'Month') ||' DE ' || TO_CHAR(dFecHasta,'YYYY') || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  ELSE
     ---- // FORMATO EXCEL //
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                ' <style id="libro">'||chr(10)||
                '   <!--table'||chr(10)||
                '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                '        .texto'||chr(10)||
                '          {mso-number-format:"\@";}'||chr(10)||
                '        .numero'||chr(10)||
                '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                '        .fecha'||chr(10)||
                '          {mso-number-format:"dd\\-mm\\-yy";}'||chr(10)||
                '    -->'||chr(10)||
                ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // TITULOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DE FACTURAS'||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>PERIODO DE VIGENCIA DE LA POLIZA ' ||'</th></tr>';  -- TO_CHAR(dFecDesde,'DD') || ' DE ' || TO_CHAR(dFecDesde,'MONTH') || ' AL ' ||
                --TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecDesde,'MONTH') || ' DE ' || TO_CHAR(dFecDesde,'YYYY') || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE SINIESTRO</font></th>'   ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ASEGURADO</font></th>'             ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COBERTURA</font></th>'             ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE PAGO</font></th>'         ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE IVA</font></th>'          ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE ISR</font></th>'          ||  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FACTURA</font></th>'               ||                               
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF"> ARCHIVO LOGEM </font></th>'       ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE PROCESO</font></th>'      || 
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUM ASISTENCIA</font></th>'        || 
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC_HOSPITAL</font></th>'          ||    
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC_ASISTENCIADORA</font></th>'    ||                                              
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IDPROCESO_MASIVO</font></th></tr>' ; 
    
                
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
  
  	--message('   Llama al Cursor   '); synchronize;	
  ---- // CARGA DE INFORMACIÓN //
  FOR X IN PAGOSSIN_Q(nAsistencia) LOOP
    --
    --	message('   Dentro del Cursor    '); synchronize;	    
  	--
 
    IF cFormato = 'TEXTO' THEN
       cCadena := X.IDPOLIZA          ||cLimitador||	       
									X.IDSINIESTRO       ||cLimitador||	   
									X.COD_ASEGURADO     ||cLimitador||	  
									X.CODCOBERT         ||cLimitador||	
									X.MONTOPAGAR        ||cLimitador||	
									X.MONTOIVA          ||cLimitador||	 
									X.MONTOISR          ||cLimitador||	   
									X.NUMFACTURA        ||cLimitador||	
								  X.ARCHIVO_LOGEM     ||cLimitador||	   
									X.EMI_FECHACOMP     ||cLimitador||
									X.NUM_ASISTENCIA    ||cLimitador||
									X.RFC_HOSPITAL      ||cLimitador||
									X.RFC_ASISTENCIADORA||cLimitador||
									X.IDPROCESOMASIVO   
									;
       
        
       
    ELSE
       cCadena := '<tr>'                                          ||
                  OC_ARCHIVO.CAMPO_HTML(X.IDPOLIZA,'C')           ||
                  OC_ARCHIVO.CAMPO_HTML(X.IDSINIESTRO,'C')        ||
                  OC_ARCHIVO.CAMPO_HTML(X.COD_ASEGURADO,'C')      ||
                  OC_ARCHIVO.CAMPO_HTML(X.CODCOBERT,'C')          ||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOPAGAR,'C')         ||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOIVA,'C')           ||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOISR,'C')           ||
                  OC_ARCHIVO.CAMPO_HTML(X.NUMFACTURA,'C')         ||   
                  OC_ARCHIVO.CAMPO_HTML(X.ARCHIVO_LOGEM,'C')      ||                
                  OC_ARCHIVO.CAMPO_HTML(X.EMI_FECHACOMP,'C')      ||  
                  OC_ARCHIVO.CAMPO_HTML(X.NUM_ASISTENCIA,'C')     ||
                  OC_ARCHIVO.CAMPO_HTML(X.RFC_HOSPITAL,'C')       ||   
                  OC_ARCHIVO.CAMPO_HTML(X.RFC_ASISTENCIADORA,'C') ||                
                  OC_ARCHIVO.CAMPO_HTML(X.IDPROCESOMASIVO,'C')    || '</tr>';       
        
    END IF;
    nLinea := nLinea + 1;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END LOOP;
  
  --message('  Sale del Cursor ');  synchronize;
  
  ---- // CIERRE DEL ARCHIVO  //    
  IF cFormato = 'EXCEL' THEN
--     OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
     cCadena := '</table></div></html>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
   
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
  --
EXCEPTION 
  WHEN OTHERS THEN 
    
    raise_application_error(-20105,'Error en Generación Reporte FACTURAS POR ASISTENCIADORA: '|| ' ' ||SQLERRM);  
    
END;
PROCEDURE REPORTE_HOSPITAL(cNomArchivo VARCHAR2,nRFC_HOSPITAL   VARCHAR2,cFormato    VARCHAR2,nIdReporte   NUMBER) IS
--
cLimitador      VARCHAR2(1) :='|';
nLinea          NUMBER;
cCadena         VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;
--
nIdSiniestro      SINIESTRO.IdSiniestro%TYPE;
dFecRes           COBERTURA_SINIESTRO_ASEG.FecRes%TYPE;
nTipoCambio       TASAS_CAMBIO.Tasa_Cambio%TYPE;
--dFecCarga         DATOS_PART_SINIESTROS.FecSts%TYPE;
cRFCHospital      DATOS_PART_SINIESTROS.Campo1%TYPE;
--cNomArchCarga     DATOS_PART_SINIESTROS.Campo85%TYPE;
nMontoRvaMon      COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc      COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;
cNombreBenef      VARCHAR2(2000);
cNumDocTributario BENEF_SIN.Num_Doc_Tributario%TYPE;
cEntidadFinanc    BENEF_SIN_PAGOS.Entidad_Financiera%TYPE;
cCuentaCheque     BENEF_SIN_PAGOS.Nro_Cheque%TYPE;
cDescBanco        VARCHAR2(200);
nIVAPorcentaje    CATALOGO_DE_CONCEPTOS.PorcConcepto%TYPE;
nCodCia           POLIZAS.codcia%TYPE;
nCodEmpresa       DETALLE_POLIZA.CODEMPRESA%TYPE;
cCodPlantilla     CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE := 'EMITESINIESTRO';
cQueryIVA         VARCHAR2(4000) := NULL;
cQueryISR         VARCHAR2(4000) := NULL;
cValorCampoIVA    VARCHAR2(4000) := NULL;
cValorCampoISR    VARCHAR2(4000) := NULL;
--
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);    
muestralerta       number;
--
MNTO_PAGOS         COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE; 
nMtoCobertMoneda   COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
--
CURSOR PAGOSSIN_Q(WnRFC_HOSPITAL IN VARCHAR2 ) IS
SELECT A.IDPOLIZA IDPOLIZA, A.IDSINIESTRO IDSINIESTRO, A.COD_ASEGURADO COD_ASEGURADO, A.MONTOIVA MONTOIVA, A.MONTOPAGAR MONTOPAGAR, A.MONTOISR MONTOISR, 
       A.CODCOBERT CODCOBERT, A.NUMFACTURA NUMFACTURA,  A.EMI_REGDATOSPROC EMI_REGDATOSPROC,A.ARCHIVO_LOGEM ARCHIVO_LOGEM, TO_CHAR(A.EMI_FECHACOMP,'YYYY-MM-DD HH24:MM:SS')   EMI_FECHACOMP
      ,A.NUM_ASISTENCIA NUM_ASISTENCIA,A.RFC_HOSPITAL RFC_HOSPITAL,A.RFC_ASISTENCIADORA  RFC_ASISTENCIADORA,A.IDPROCMASIVO  IDPROCESOMASIVO
FROM PROCESOS_MASIVOS_SEGUIMIENTO  A
WHERE A.EMI_TIPOPROCESO = 'PAGSIN'
AND A.IDPOLIZA > 0 -- nIdPoliza--10558
AND A.RFC_HOSPITAL LIKE '%'||WnRFC_HOSPITAL||'%'
ORDER BY A.EMI_FECHACOMP
;
      
				 
--
BEGIN
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
    
    
    ---- // FORMATO TEXTO //
  IF cFormato = 'TEXTO' THEN    
     ---- // TITULOS //
     nLinea := 1; 
     cCadena     := 'THONA SEGUROS, S.A. de C.V.' || CHR(13);
     --Se reemplazaran las lineas de oc_archivo.Escribir_linea por:
     -- CLIENT_TEXT_IO.putf. Debe ser mas rapido para escribir.
     --OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea := nLinea + 1;
     cCadena     := 'RFC_HOSPITAL' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := ' PERIODO DE VIGENCIA DE LA POLIZA '|| CHR(13); ---PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE '|| TO_CHAR(dFecDesde,'Month') || ' AL ' || TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecHasta,'Month') ||' DE ' || TO_CHAR(dFecHasta,'YYYY') || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  ELSE
     ---- // FORMATO EXCEL //
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                ' <style id="libro">'||chr(10)||
                '   <!--table'||chr(10)||
                '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                '        .texto'||chr(10)||
                '          {mso-number-format:"\@";}'||chr(10)||
                '        .numero'||chr(10)||
                '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                '        .fecha'||chr(10)||
                '          {mso-number-format:"dd\\-mm\\-yy";}'||chr(10)||
                '    -->'||chr(10)||
                ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // TITULOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DE FACTURAS RFC_HOSPITAL '||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>PERIODO DE VIGENCIA DE LA POLIZA ' ||'</th></tr>';  -- TO_CHAR(dFecDesde,'DD') || ' DE ' || TO_CHAR(dFecDesde,'MONTH') || ' AL ' ||
                --TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecDesde,'MONTH') || ' DE ' || TO_CHAR(dFecDesde,'YYYY') || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE SINIESTRO</font></th>'   ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ASEGURADO</font></th>'             ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COBERTURA</font></th>'             ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE PAGO</font></th>'         ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE IVA</font></th>'          ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE ISR</font></th>'          ||  
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FACTURA</font></th>'               ||                               
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF"> ARCHIVO LOGEM </font></th>'       ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE PROCESO</font></th>'      || 
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUM ASISTENCIA</font></th>'        || 
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC_HOSPITAL</font></th>'          ||    
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC_ASISTENCIADORA</font></th>'    ||                                              
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IDPROCESO_MASIVO</font></th></tr>' ; 
    
                
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
  
  	--message('   Llama al Cursor   '); synchronize;	
  ---- // CARGA DE INFORMACIÓN //
  FOR X IN PAGOSSIN_Q(nRFC_HOSPITAL) LOOP
    --
    --	message('   Dentro del Cursor    '); synchronize;	    
  	--
 
    IF cFormato = 'TEXTO' THEN
       cCadena := X.IDPOLIZA          ||cLimitador||	       
									X.IDSINIESTRO       ||cLimitador||	   
									X.COD_ASEGURADO     ||cLimitador||	  
									X.CODCOBERT         ||cLimitador||	
									X.MONTOPAGAR        ||cLimitador||	
									X.MONTOIVA          ||cLimitador||	 
									X.MONTOISR          ||cLimitador||	   
									X.NUMFACTURA        ||cLimitador||	
								  X.ARCHIVO_LOGEM     ||cLimitador||	   
									X.EMI_FECHACOMP     ||cLimitador||
									X.NUM_ASISTENCIA    ||cLimitador||
									X.RFC_HOSPITAL      ||cLimitador||
									X.RFC_ASISTENCIADORA||cLimitador||
									X.IDPROCESOMASIVO   
									;
       
        
       
    ELSE
       cCadena := '<tr>'                                          ||
                  OC_ARCHIVO.CAMPO_HTML(X.IDPOLIZA,'C')           ||
                  OC_ARCHIVO.CAMPO_HTML(X.IDSINIESTRO,'C')        ||
                  OC_ARCHIVO.CAMPO_HTML(X.COD_ASEGURADO,'C')      ||
                  OC_ARCHIVO.CAMPO_HTML(X.CODCOBERT,'C')          ||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOPAGAR,'C')         ||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOIVA,'C')           ||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTOISR,'C')           ||
                  OC_ARCHIVO.CAMPO_HTML(X.NUMFACTURA,'C')         ||   
                  OC_ARCHIVO.CAMPO_HTML(X.ARCHIVO_LOGEM,'C')      ||                
                  OC_ARCHIVO.CAMPO_HTML(X.EMI_FECHACOMP,'C')      ||  
                  OC_ARCHIVO.CAMPO_HTML(X.NUM_ASISTENCIA,'C')     ||
                  OC_ARCHIVO.CAMPO_HTML(X.RFC_HOSPITAL,'C')       ||   
                  OC_ARCHIVO.CAMPO_HTML(X.RFC_ASISTENCIADORA,'C') ||                
                  OC_ARCHIVO.CAMPO_HTML(X.IDPROCESOMASIVO,'C')    || '</tr>';       
        
    END IF;
    nLinea := nLinea + 1;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END LOOP;
  
  --message('  Sale del Cursor ');  synchronize;
  
  ---- // CIERRE DEL ARCHIVO  //    
  IF cFormato = 'EXCEL' THEN
--     OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
     cCadena := '</table></div></html>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  END IF;
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
   
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
  --
EXCEPTION 
  WHEN OTHERS THEN 
    raise_application_error(-20102,'Error en Generación Reporte FACTURAS POR HOSPITAL: '|| ' ' ||SQLERRM);  
END;
PROCEDURE GENERAR_SINIESTROS (cNomArchivo VARCHAR2, 
                              cIdTipoSeg  VARCHAR2, 
                              cCodMoneda  VARCHAR2,
                              dFecDesde   DATE    ,
                              dFecHasta   DATE    ,
                              cFormato    VARCHAR2,
                              nIdReporte   NUMBER) IS
				cLimitador      VARCHAR2(1) :='|';
				nLinea          NUMBER;
				cCadena         VARCHAR2(4000);
				cCadenaAux      VARCHAR2(4000);
				cCadenaAux1     VARCHAR2(4000);
				cCodUser        VARCHAR2(30);
				nDummy          NUMBER;
				cCopy           BOOLEAN;
        --
        
        LINEA_SALIDA       VARCHAR2(5000);           -- SPEEDFILE
        WI_ARCHIVO_SALIDA  VARCHAR2(2000);           -- SPEEDFILE 
	      muestralerta number;                         -- SPEEDFILE
        --
   CURSOR SINIESTROS_Q IS 
   SELECT DISTINCT S.IDSINIESTRO NSINIEST, S.STS_SINIESTRO STSIN,
          OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(DPP.CODCIA, DPP.CODEMPRESA, DPP.IDTIPOSEG )||
          OC_PLAN_COBERTURAS.CODIGO_SUBRAMO(DPP.CODCIA, DPP.CODEMPRESA,DPP.IDTIPOSEG,DPP.PLANCOB ) RAMOSUBRAMO,
          PP.NumPolUnico POLUNIK, S.IDPOLIZA NPOLIZA, DPP.COD_ASEGURADO NASEG, '' NDEPEND,
          PP.CODCLIENTE COD_NOMBCONT, OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE) ncontr,
          DPP.COD_ASEGURADO COD_TITULAR, OC_ASEGURADO.NOMBRE_ASEGURADO(PP.CodCia, PP.CodEmpresa, DPP.Cod_Asegurado) DASEG,
          '-' TELEFONO1, '-' TELEFONO2, '' EXTTEL_1, '' EXTTEL_2, 
          TO_CHAR(S.Fec_Ocurrencia,'DD/MM/RRRR') FECHASIN,   --JISL 20200127 FORMATO DE FECHA
          S.TIPO_SINIESTRO,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPOSINI', S.TIPO_SINIESTRO) dtiposin, S.MOTIVO_DE_SINIESTRO CVE_CAUSIN,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CAUSIN',  S.MOTIVO_DE_SINIESTRO) DMOTSIN, S.Desc_Siniestro DESC_SINI,
          PP.StsPoliza STPOLIZA, '' DSTSIN, 
          TO_CHAR(PP.FecSts,'DD/MM/RRRR') FSTAT,             --JISL 20200127 FORMATO DE FECHA
          PP.CodPlanPago NESQFPAGO,
          OC_PLAN_DE_PAGOS.Descripcion_plan(PP.CODCIA , PP.CODEMPRESA,PP.CODPLANPAGO) DNESQFPAGO,
          TIPOADMINISTRACION FMAADMVA, OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ADMINPOL', TIPOADMINISTRACION) FMAADMVA_i,
          S.COD_MONEDA MONEDA, OC_MONEDA.Descripcion_Moneda(S.COD_MONEDA) MONEDA_i, 
          TO_CHAR(pp.fecinivig,'DD/MM/RRRR') FINIVIG, TO_CHAR(pp.fecfinvig,'DD/MM/RRRR') FTERVIG,    --JISL 20200127 FORMATO DE FECHA
          PP.NumRenov AAVIG, 'Pendiente'  FPAGHAST, PP.TipoDividendo BASEDIV,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPDIV', pp.tipodividendo) BASEDIV_i, PP.CodAgrupador NPOOL,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('AGRUPA', NVL(pp.codagrupador,'0000')) DNPOOL,
          PP.Indfacturapol CRITEMISR, 'Descripcion indFac' CRITEMIS_i, 'DATO PEND' FULTCOB,
          PP.COD_AGENTE NAGENTE, 
          TO_CHAR(S.FEC_NOTIFICACION,'DD/MM/RRRR') FEC_NOTIFICACION,  --JISL 20200127 FORMATO DE FECHA
          DP.IdTipoSeg
     FROM SINIESTRO S, DETALLE_POLIZA DPP, POLIZAS PP, DETALLE_SINIESTRO DP
    WHERE DP.IDPOLIZA                = S.IDPOLIZA
      AND PP.IdPoliza                = S.idpoliza
      AND DPP.IDPOLIZA               = PP.IDPOLIZA
      AND DPP.CODCIA                 = PP.CODCIA
      AND DPP.CODEMPRESA             = PP.CODEMPRESA
      AND DP.IDDETSIN                = DPP.IDETPOL
      AND DP.IDSINIESTRO             = S.IDSINIESTRO
      AND DP.IDPOLIZA                = S.IDPOLIZA
      AND TRUNC(S.FEC_NOTIFICACION) >= dFecDesde
      AND TRUNC(S.FEC_NOTIFICACION) <= dFecHasta 
      AND (S.COD_MONEDA              = DECODE(cCodMoneda,'%',S.COD_MONEDA,cCodMoneda))
      AND (DPP.IDTIPOSEG             = DECODE(cIdTipoSeg,'%',DPP.IDTIPOSEG,cIdTipoSeg))
    UNION
   SELECT DISTINCT S.IDSINIESTRO NSINIEST, S.STS_SINIESTRO STSIN,
          OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(DPP.CODCIA, DPP.CODEMPRESA, DPP.IDTIPOSEG )||
          OC_PLAN_COBERTURAS.CODIGO_SUBRAMO(DPP.CODCIA, DPP.CODEMPRESA,DPP.IDTIPOSEG,DPP.PLANCOB ) RAMOSUBRAMO,
          PP.NumPolUnico POLUNIK, S.IDPOLIZA NPOLIZA, DPP.COD_ASEGURADO NASEG, '' NDEPEND,
          PP.CODCLIENTE COD_NOMBCONT, OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE) ncontr,
          DP.COD_ASEGURADO COD_TITULAR, OC_ASEGURADO.NOMBRE_ASEGURADO(PP.CodCia, PP.CodEmpresa, DP.Cod_Asegurado) DASEG,
          '-' TELEFONO1, '-' TELEFONO2, '' EXTTEL_1, '' EXTTEL_2, 
          TO_CHAR(S.Fec_Ocurrencia,'DD/MM/RRRR') FECHASIN,     --- JISL 20200127
          S.TIPO_SINIESTRO,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPOSINI', S.TIPO_SINIESTRO) dtiposin, S.MOTIVO_DE_SINIESTRO CVE_CAUSIN,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CAUSIN',  S.MOTIVO_DE_SINIESTRO) DMOTSIN, S.Desc_Siniestro DESC_SINI,
          PP.StsPoliza STPOLIZA, '' DSTSIN,
          TO_CHAR(PP.FecSts,'DD/MM/RRRR') FSTAT,     --- JISL 20200127
          PP.CodPlanPago NESQFPAGO,
          OC_PLAN_DE_PAGOS.Descripcion_plan(PP.CODCIA , PP.CODEMPRESA,PP.CODPLANPAGO) DNESQFPAGO,
          TIPOADMINISTRACION FMAADMVA, OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ADMINPOL', TIPOADMINISTRACION) FMAADMVA_i,
          S.COD_MONEDA MONEDA, OC_MONEDA.Descripcion_Moneda(S.COD_MONEDA) MONEDA_i, 
          TO_CHAR(pp.fecinivig,'DD/MM/RRRR') FINIVIG,  TO_CHAR(pp.fecfinvig,'DD/MM/RRRR') FTERVIG,    --- JISL 20200127
          PP.NumRenov AAVIG, 'Pendiente'  FPAGHAST, PP.TipoDividendo BASEDIV,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPDIV', pp.tipodividendo) BASEDIV_i, PP.CodAgrupador NPOOL,
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('AGRUPA', NVL(pp.codagrupador,'0000')) DNPOOL,
          PP.Indfacturapol CRITEMISR, 'Descripcion indFac' CRITEMIS_i, 'DATO PEND' FULTCOB,
          PP.COD_AGENTE NAGENTE, 
          TO_CHAR(S.FEC_NOTIFICACION,'DD/MM/RRRR') FEC_NOTIFICACION,  --- JISL 20200127
          DP.IdTipoSeg
     FROM SINIESTRO S, DETALLE_POLIZA DPP, POLIZAS PP, DETALLE_SINIESTRO_ASEG DP
    WHERE DP.IDPOLIZA                = S.IDPOLIZA
      AND PP.IdPoliza                = S.idpoliza
      AND DPP.IDPOLIZA               = PP.IDPOLIZA
      AND DPP.CODCIA                 = PP.CODCIA
      AND DPP.CODEMPRESA             = PP.CODEMPRESA
      AND DP.IDDETSIN                = DPP.IDETPOL
      AND DP.IDSINIESTRO             = S.IDSINIESTRO
      AND DP.IDPOLIZA                = S.IDPOLIZA
      AND TRUNC(S.FEC_NOTIFICACION) >= dFecDesde
      AND TRUNC(S.FEC_NOTIFICACION) <= dFecHasta 
      AND (S.COD_MONEDA              = DECODE(cCodMoneda,'%',S.COD_MONEDA,cCodMoneda))
      AND (DPP.IDTIPOSEG             = DECODE(cIdTipoSeg,'%',DPP.IDTIPOSEG,cIdTipoSeg))
    ORDER BY 1 ;
BEGIN 
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
    
   IF cFormato = 'TEXTO' THEN
      nLinea := 1;
      cCadena     := 'THONA SEGUROS, S.A. de C.V.' ; --|| chr(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE	
      nLinea := nLinea + 1;
      cCadena     := 'REPORTE DE SINIESTROS  '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY')||' Moneda sol '||cCodMoneda; --; --|| chr(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE	      
      nLinea := nLinea + 1;
      cCadena     := ' ' ; --|| chr(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE	
---- // TITULOS //
      nLinea := nLinea + 1;
      cCadena     := 'NSINIEST'       ||cLimitador||'STSIN'          ||cLimitador||'RAMOSUBRAMO' ||cLimitador||'NPOLIZA'       ||cLimitador||
                     'NASEG'          ||cLimitador||'NDEPEND'        ||cLimitador||'COD_NOMBCONT'||cLimitador||'NCONTR'        ||cLimitador||
                     'COD_TITULAR'    ||cLimitador||'DASEG'          ||cLimitador||'TELEFONO1'   ||cLimitador||'TELEFONO2'     ||cLimitador||
                     'EXTTEL_1'       ||cLimitador||'EXTTEL_2'       ||cLimitador||'FECHASIN'    ||cLimitador||'TIPO_SINIESTRO'||cLimitador||
                     'DTIPOSIN'       ||cLimitador||'CVE_CAUSIN'     ||cLimitador||'DMOTSIN'     ||cLimitador||'DESC_SINI'     ||cLimitador||
                     'STPOLIZA'       ||cLimitador||'DSTSIN'         ||cLimitador||'FSTAT'       ||cLimitador||'NESQFPAGO'     ||cLimitador||
                     'DNESQFPAGO'     ||cLimitador||'FMAADMVA'       ||cLimitador||'FMAADMVA_I'  ||cLimitador||'MONEDA'        ||cLimitador||
                     'MONEDA_I'       ||cLimitador||'FINIVIG'        ||cLimitador||'FTERVIG'     ||cLimitador||'AAVIG'         ||cLimitador||
                     'FPAGHAST'       ||cLimitador||'BASEDIV'        ||cLimitador||'BASEDIV_I'   ||cLimitador||'NPOOL'         ||cLimitador||
                     'DNPOOL'         ||cLimitador||'CRITEMISR'      ||cLimitador||'CRITEMIS_I'  ||cLimitador||'FULTCOB'       ||cLimitador||
                     'NAGENTE'        ||cLimitador||'FECNOTIFICACION'||cLimitador||'IDTIPOSEG'   ; --||chr(13);--SPEEDFILE
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE	
   ELSE
      nLinea := 1;
      cCadena  := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                       ' xmlns:x="urn:schemas-microsoft-com:office:excel"' ||chr(10)||
                       ' xmlns="http://www.w3.org/TR/REC-html40">'         ||chr(10)||
                       ' <style id="libro">'                               ||chr(10)||
                       '   <!--table'                                      ||chr(10)||
                       '       {mso-displayed-decimal-separator:"\.";'     ||chr(10)||
                       '        mso-displayed-thousand-separator:"\,";}'   ||chr(10)||
                       '        .texto'                                    ||chr(10)||
                       '          {mso-number-format:"\@";}'               ||chr(10)||
                       '        .numero'                                   ||chr(10)||
                       '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                       '        .fecha'                                    ||chr(10)||
                       '          {mso-number-format:"dd\\-mmm\\-yyyy";}'  ||chr(10)||
                       '    -->'                                           ||chr(10)||
                       ' </style><div id="libro">'                         ||chr(10);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE	
      nLinea := nLinea + 1;
      cCadena     := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE	      
      nLinea := nLinea + 1;
      cCadena     := '<tr><th>REPORTE LISTA SINIESTROS  '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' ||
                      TO_CHAR(dFecHasta,'DD/MM/YYYY')  ||' Moneda sol '||  cCodMoneda   || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE	      
      nLinea := nLinea + 1;
      cCadena     := '<tr><th>  </th></tr></table>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE	      
      nLinea := nLinea + 1;
      cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NSINIEST</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">STSIN</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RAMOSUBRAMO</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NPOLIZA</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NASEG</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NDEPEND</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COD_NOMBCONT</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NCONTR</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COD_TITULAR</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DASEG</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TELEFONO1</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TELEFONO2</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EXTTEL_1</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EXTTEL_2</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHASIN</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO_SINIESTRO</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DTIPOSIN</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CVE_CAUSIN</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DMOTSIN</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESC_SINI</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">STPOLIZA</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DSTSIN</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FSTAT</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NESQFPAGO</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DNESQFPAGO</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FMAADMVA</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FMAADMVA_I</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONEDA</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONEDA_I</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FINIVIG</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FTERVIG</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">AAVIG</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FPAGHASTA</font></th>' ||                      
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">BASEDIV</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">BASEDIV_I</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NPOOL</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DNPOOL</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CRITEMISR</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CRITEMIS_I</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FULTCOB</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NAGENTE</font></th>' ||                      
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECNOTIFICACION</font></th>' ||                      
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IDTIPOSEG</font></th></tr>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);                       
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE	     -- JISL 20190517
   END IF;
   FOR X IN SINIESTROS_Q LOOP
      IF cFormato = 'TEXTO' THEN
         cCadena :=  X.NSINIEST					  ||cLimitador||
                     X.STSIN							||cLimitador||
                     X.RAMOSUBRAMO				||cLimitador||
                     X.POLUNIK 					  ||cLimitador||   --- X.NPOLIZA						
                     X.NASEG							||cLimitador||
                     X.NDEPEND						||cLimitador||
                     X.COD_NOMBCONT	  		||cLimitador||
                     X.NCONTR				  		||cLimitador||
                     X.COD_TITULAR				||cLimitador||
                     X.DASEG							||cLimitador||
                     X.TELEFONO1					||cLimitador||
                     X.TELEFONO2					||cLimitador||
                     X.EXTTEL_1	  				||cLimitador||
                     X.EXTTEL_2		  			||cLimitador||
                     X.FECHASIN			  		||cLimitador||
                     X.TIPO_SINIESTRO	  	||cLimitador||
                     X.DTIPOSIN			  		||cLimitador||
                     X.CVE_CAUSIN		  		||cLimitador||
                     X.DMOTSIN						||cLimitador;    -- MLJS 23/12/2020
       cCadenaAux := X.DESC_SINI					||cLimitador;    -- MLJS 23/12/2020 VARIABLE SOLO PARA LA DECRIPCION DEL SINIESTRO
       cCadenaAux1:= X.STPOLIZA				  	||cLimitador||   -- MLS 23/12/2020
                     X.DSTSIN					  	||cLimitador||
                     X.FSTAT							||cLimitador||
                     X.NESQFPAGO					||cLimitador||
                     X.DNESQFPAGO	  			||cLimitador||	
                     X.FMAADMVA			  		||cLimitador||
                     X.FMAADMVA_I			  	||cLimitador||
                     X.MONEDA					  	||cLimitador||
                     X.MONEDA_I				  	||cLimitador||
                     X.FINIVIG						||cLimitador||
                     X.FTERVIG						||cLimitador||
                     X.AAVIG							||cLimitador||
                     X.FPAGHAST					  ||cLimitador||
                     X.BASEDIV						||cLimitador||
                     X.BASEDIV_I					||cLimitador||	
                     X.NPOOL							||cLimitador||
                     X.DNPOOL						  ||cLimitador||
                     X.CRITEMISR					||cLimitador||
                     X.CRITEMIS_I				  ||cLimitador||	
                     X.FULTCOB						||cLimitador||
                     X.NAGENTE						||cLimitador||
                     X.FEC_NOTIFICACION   ||cLimitador||
                     X.IDTIPOSEG  				; --||chr(13);
     ELSE
         cCadena := '<tr>' || 
         						OC_ARCHIVO.CAMPO_HTML(X.NSINIEST ,'C')       ||
         						OC_ARCHIVO.CAMPO_HTML(X.STSIN ,'C')          ||
                    OC_ARCHIVO.CAMPO_HTML(X.RAMOSUBRAMO,'C')     ||
                    OC_ARCHIVO.CAMPO_HTML(X.POLUNIK ,'C')        ||                      --- X.NPOLIZA
                    OC_ARCHIVO.CAMPO_HTML(X.NASEG,'C')           ||      
                    OC_ARCHIVO.CAMPO_HTML(X.NDEPEND,'C')         ||        
                    OC_ARCHIVO.CAMPO_HTML(X.COD_NOMBCONT,'C')    ||         
                    OC_ARCHIVO.CAMPO_HTML(X.NCONTR,'C')          ||     
                    OC_ARCHIVO.CAMPO_HTML(X.COD_TITULAR,'C')     ||      
                    OC_ARCHIVO.CAMPO_HTML(X.DASEG,'C')           ||      
                    OC_ARCHIVO.CAMPO_HTML(X.TELEFONO1,'C')       ||      
                    OC_ARCHIVO.CAMPO_HTML(X.TELEFONO2,'C')       ||      
                    OC_ARCHIVO.CAMPO_HTML(X.EXTTEL_1,'C')        ||      
                    OC_ARCHIVO.CAMPO_HTML(X.EXTTEL_2,'C')        ||   
                    OC_ARCHIVO.CAMPO_HTML(X.FECHASIN,'D')        ||                       
                    OC_ARCHIVO.CAMPO_HTML(X.TIPO_SINIESTRO,'C')  ||      
                    OC_ARCHIVO.CAMPO_HTML(X.DTIPOSIN,'C')        ||      
                    OC_ARCHIVO.CAMPO_HTML(X.CVE_CAUSIN,'C')      ||      
                    OC_ARCHIVO.CAMPO_HTML(X.DMOTSIN,'C')         ;     --MLJS 23/12/2020      
      cCadenaAux := OC_ARCHIVO.CAMPO_HTML(X.DESC_SINI,'C')       ;     --MLJS 23/12/2020 VARIABLE SOLO PARA LA DECRIPCION DEL SINIESTRO   
     cCadenaAux1 := OC_ARCHIVO.CAMPO_HTML(X.STPOLIZA,'C')        ||    --MLJS 23/12/2020
                    OC_ARCHIVO.CAMPO_HTML(X.DSTSIN,'C')          ||      
                    OC_ARCHIVO.CAMPO_HTML(X.FSTAT,'C')           ||      
                    OC_ARCHIVO.CAMPO_HTML(X.NESQFPAGO,'C')       ||      
                    OC_ARCHIVO.CAMPO_HTML(X.DNESQFPAGO,'C')      ||      
                    OC_ARCHIVO.CAMPO_HTML(X.FMAADMVA,'C')        ||      
                    OC_ARCHIVO.CAMPO_HTML(X.FMAADMVA_I,'C')      ||      
                    OC_ARCHIVO.CAMPO_HTML(X.MONEDA,'C')          ||      
                    OC_ARCHIVO.CAMPO_HTML(X.MONEDA_I,'C')        ||      
                    OC_ARCHIVO.CAMPO_HTML(X.FINIVIG,'D')         ||      
                    OC_ARCHIVO.CAMPO_HTML(X.FTERVIG,'D')         ||      
                    OC_ARCHIVO.CAMPO_HTML(X.AAVIG,'C')           ||      
                    OC_ARCHIVO.CAMPO_HTML(X.FPAGHAST,'D')        ||      
                    OC_ARCHIVO.CAMPO_HTML(X.BASEDIV,'C')         ||      
                    OC_ARCHIVO.CAMPO_HTML(X.BASEDIV_I,'C')       ||      
                    OC_ARCHIVO.CAMPO_HTML(X.NPOOL,'C')           ||      
                    OC_ARCHIVO.CAMPO_HTML(X.DNPOOL,'C')          ||      
                    OC_ARCHIVO.CAMPO_HTML(X.CRITEMISR,'C')       ||      
                    OC_ARCHIVO.CAMPO_HTML(X.CRITEMIS_I,'C')      ||      
                    OC_ARCHIVO.CAMPO_HTML(X.FULTCOB,'D')         ||      
                    OC_ARCHIVO.CAMPO_HTML(X.NAGENTE,'C')         ||                
                    OC_ARCHIVO.CAMPO_HTML(X.FEC_NOTIFICACION,'D')||                
                    OC_ARCHIVO.CAMPO_HTML(X.IDTIPOSEG,'C')              
                    || '</tr>';
     END IF;
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      OC_ARCHIVO.Escribir_Linea(cCadenaAux, cCodUser, nLinea);    --MLJS 23/12/2020
      OC_ARCHIVO.Escribir_Linea(cCadenaAux1, cCodUser, nLinea);   --MLJS 23/12/2020
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE	-- JISL 20190517      
   END LOOP;
   IF cFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
   	  --cCadena := '</table></div></html>';                                           -- JISL 20190517
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE	-- JISL 20190517      
   END IF;
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
   
   
EXCEPTION 
     WHEN OTHERS THEN 
          OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
          raise_application_error(-20105,'Error en Generación de Reporte De Siniestros: '|| ' ' ||SQLERRM);
          
END;
PROCEDURE GENERAR_ASEGCSIN (cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cCodMoneda VARCHAR2, 
                            dFecDesde DATE, dFecHasta DATE,cFormato    VARCHAR2,nIdReporte   NUMBER) IS
					cLimitador      VARCHAR2(1) :='|';
					nLinea          NUMBER;
					cCadena         VARCHAR2(4000);
					cCodUser        VARCHAR2(30);
					nDummy          NUMBER;
					cCopy           BOOLEAN;
					driesgo_imp     VARCHAR2(30);
					Dcodestado_imp	VARCHAR2(10);
					Ddescciudad_imp VARCHAR2(200);  
					DEDAD_ASEG_IMP  VARCHAR2(5);
					nCodCia         POLIZAS.codcia%TYPE;
					nIdPoliza       POLIZAS.IDPOLIZA%TYPE;
					nCod_Asegurado  DETALLE_POLIZA.COD_ASEGURADO%TYPE;
		    --ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;   -- SPEEDFILE RSR 22042016
        LINEA_SALIDA       VARCHAR2(5000);             -- SPEEDFILE RSR 22042016
        WI_ARCHIVO_SALIDA  VARCHAR2(2000);             -- SPEEDFILE RSR 22042016
	      muestralerta number;                           -- SPEEDFILE RSR 22042016
   CURSOR ASEGCSIN IS
   SELECT DISTINCT S.IDSINIESTRO NSINIEST, PNJ.APELLIDO_PATERNO APPAT,
          PNJ.APELLIDO_MATERNO APMAT, PNJ.NOMBRE NOMBRE,
          (OC_TIPOS_DE_SEGUROS.Codigo_Ramo(DP.CODCIA, DP.CODEMPRESA, DP.IDTIPOSEG )||
          OC_PLAN_COBERTURAS.Codigo_Subramo(DP.CODCIA, DP.CODEMPRESA,DP.IDTIPOSEG,DP.PLANCOB)) RAMOSUBRAMO,
          PP.NumPolUnico POLUNIK, PP.IdPoliza POL, A.COD_ASEGURADO NASEG, '' NDEPEND, 
          A.TIPO_DOC_IDENTIFICACION NDOC, A.NUM_DOC_IDENTIFICACION INIDE, A.CODPARENT,
          A.COD_ASEGURADO CVASEG, PNJ.FECNACIMIENTO  FNAC,
          '' HCVASEG, DP.CodFilial NSUBGPO,
          DP.CodCategoria NCATEG, A.CodParent CVPARENT, 
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PARENT', A.CodParent) CVPARENT_i,
          DP.STSDETALLE STALTA, OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPPROC',  DP.STSDETALLE) STALTA_i,
          DP.FECINIVIG  FSTALTA,  DP.MOTIVANUL STBAJA,  
          DECODE(DP.MOTIVANUL,NULL,'', OC_VALORES_DE_LISTAS.BUSCA_LVALOR('MOTIVANU', DP.MOTIVANUL)) STBAJA_i,
          DP.FECANUL FSTBAJA, PNJ.SEXO CVSEXO,
          DECODE(PNJ.SEXO, 'F','FEMENINO', 'M', 'MASCULINO','N','NO APLICA','NO APLICA') CVSEXO_i,
          '-' CVNFUMA, '-' CVNFUMA_i,
          OC_ASEGURADO.EDAD_ASEGURADO(DP.CodCia, DP.CodEmpresa, A.Cod_Asegurado, S.Fec_Ocurrencia) EdadReal,
          OC_ASEGURADO.EDAD_ASEGURADO(DP.CodCia, DP.CodEmpresa, A.Cod_Asegurado, S.Fec_Ocurrencia) EdadCalc,
          A.COD_ASEGURADO RIESGOCUP, '' RIESGOCUP_i, '-' ADSCRIP, '-' PUESTO, PNJ.ESTADOCIVIL CVEDOCIV,
          DECODE (PNJ.ESTADOCIVIL,'A','ARREJUNTADO','C','CASADO','D', 'DIVORCIADO','N','NO APLICA','S','SOLTERO',
                  'U','UNIDO','V','VIUDO','') CVEDOCIV_i, 
          DP.FECINIVIG FINGEMP,  PP.FECINIVIG FINISEG,
           '-' SUELDO, '' ZONA, '' ZONA_i, '-' TPUBIC, '-' TPUBIC_i,
          PP.CODCIA, PP.IDPOLIZA, S.IDETPOL, DP.COD_ASEGURADO, S.FEC_NOTIFICACION, DSA.IdTipoSeg, S.Cod_Moneda
     FROM POLIZAS PP, DETALLE_POLIZA DP, ASEGURADO A,
          PERSONA_NATURAL_JURIDICA PNJ, SINIESTRO S, DETALLE_SINIESTRO_ASEG DSA
    WHERE PP.CODCIA           = 1
			AND PP.CODEMPRESA       = 1
			AND pp.codcia           = dp.codcia
      AND pp.codempresa       = dp.codempresa
      AND pp.idpoliza         = dp.idpoliza
      AND s.idetpol  = dp.idetpol 
      AND a.codcia = pp.codcia
      AND a.codempresa = pp.codempresa
      AND a.cod_asegurado = DSA.cod_asegurado 
      AND pnj.tipo_doc_identificacion = a.tipo_doc_identificacion
      AND pnj.num_doc_identificacion = a.num_doc_identificacion
      AND s.idpoliza = pp.idpoliza
      AND DSA.IDSINIESTRO = S.IDSINIESTRO
      AND DSA.IDPOLIZA = S.IDPOLIZA
      AND DSA.IDDETSIN = S.IDETPOL
      AND DSA.COD_ASEGURADO = S.COD_ASEGURADO                         -- JISL 21/05/2019      
      AND TRUNC(S.FEC_NOTIFICACION) >= dFecDesde
      AND TRUNC(S.FEC_NOTIFICACION) <= dFecHasta 
      AND (S.COD_MONEDA = DECODE(cCodMoneda,'%',S.COD_MONEDA,cCodMoneda))
      AND (DSA.IDTIPOSEG  = DECODE(cIdTipoSeg,'%',DSA.IDTIPOSEG,cIdTipoSeg))
    UNION
   SELECT DISTINCT S.IDSINIESTRO NSINIEST, PNJ.APELLIDO_PATERNO APPAT,
          PNJ.APELLIDO_MATERNO APMAT, PNJ.NOMBRE NOMBRE,
          (OC_TIPOS_DE_SEGUROS.Codigo_Ramo(DP.CODCIA, DP.CODEMPRESA, DP.IDTIPOSEG )||
          OC_PLAN_COBERTURAS.Codigo_Subramo(DP.CODCIA, DP.CODEMPRESA,DP.IDTIPOSEG,DP.PLANCOB)) RAMOSUBRAMO,
          PP.NumPolUnico POLUNIK, PP.IdPoliza POL, A.COD_ASEGURADO NASEG, '' NDEPEND, 
          A.TIPO_DOC_IDENTIFICACION NDOC, A.NUM_DOC_IDENTIFICACION INIDE, A.CODPARENT,
          A.COD_ASEGURADO CVASEG,  PNJ.FECNACIMIENTO FNAC, '' HCVASEG, DP.CodFilial NSUBGPO,
          DP.CodCategoria NCATEG, A.CodParent CVPARENT, 
          OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PARENT', A.CodParent) CVPARENT_i,
          DP.STSDETALLE STALTA, OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPPROC',  DP.STSDETALLE) STALTA_i,
          DP.FECINIVIG FSTALTA, DP.MOTIVANUL STBAJA,
          DECODE(DP.MOTIVANUL,NULL,'', OC_VALORES_DE_LISTAS.BUSCA_LVALOR('MOTIVANU', DP.MOTIVANUL)) STBAJA_i,
          DP.FECANUL FSTBAJA, PNJ.SEXO CVSEXO,
          DECODE(PNJ.SEXO, 'F','FEMENINO', 'M', 'MASCULINO','N','NO APLICA','NO APLICA') CVSEXO_i,
          '-' CVNFUMA, '-' CVNFUMA_i,
          OC_ASEGURADO.EDAD_ASEGURADO(DP.CodCia, DP.CodEmpresa, A.Cod_Asegurado, S.Fec_Ocurrencia) EdadReal,
          OC_ASEGURADO.EDAD_ASEGURADO(DP.CodCia, DP.CodEmpresa, A.Cod_Asegurado, S.Fec_Ocurrencia) EdadCalc,
          A.COD_ASEGURADO RIESGOCUP, '' RIESGOCUP_i, '-' ADSCRIP, '-' PUESTO, PNJ.ESTADOCIVIL CVEDOCIV,
          DECODE (PNJ.ESTADOCIVIL,'A','ARREJUNTADO','C','CASADO','D', 'DIVORCIADO','N','NO APLICA','S','SOLTERO',
                  'U','UNIDO','V','VIUDO','') CVEDOCIV_i, 
          DP.FECINIVIG FINGEMP, PP.FECINIVIG FINISEG,
          '-' SUELDO, '' ZONA, '' ZONA_i, '-' TPUBIC, '-' TPUBIC_i,
          PP.CODCIA, PP.IDPOLIZA, S.IDETPOL, DP.COD_ASEGURADO, S.FEC_NOTIFICACION,
          DS.IdTipoSeg, S.Cod_Moneda
     FROM POLIZAS PP, DETALLE_POLIZA DP, ASEGURADO A,
          PERSONA_NATURAL_JURIDICA PNJ, SINIESTRO S, DETALLE_SINIESTRO DS
    WHERE pp.codcia = dp.codcia
      AND pp.codempresa = dp.codempresa
      AND pp.idpoliza = dp.idpoliza
      AND s.idetpol  = dp.idetpol 
      AND a.codcia = pp.codcia
      AND a.codempresa = pp.codempresa
      AND a.cod_asegurado = DP.cod_asegurado 
      AND pnj.tipo_doc_identificacion = a.tipo_doc_identificacion
      AND pnj.num_doc_identificacion = a.num_doc_identificacion
      AND s.idpoliza = pp.idpoliza
      AND DS.IDSINIESTRO = S.IDSINIESTRO
      AND DS.IDPOLIZA = S.IDPOLIZA
      AND DS.IDDETSIN = S.IDETPOL      
      AND TRUNC(S.FEC_NOTIFICACION) >= dFecDesde
      AND TRUNC(S.FEC_NOTIFICACION) <= dFecHasta 
      AND (S.COD_MONEDA = DECODE(cCodMoneda,'%',S.COD_MONEDA,cCodMoneda))
      AND (DS.IDTIPOSEG  = DECODE(cIdTipoSeg,'%',DS.IDTIPOSEG,cIdTipoSeg))
    ORDER BY 1;
CURSOR DATOS_ASEG IS 
SELECT
       PO.IDPOLIZA, 
       DP.IDETPOL, ASE.COD_ASEGURADO,
       PN.FECINGRESO  FALTA,  
       OC_ASEGURADO.EDAD_ASEGURADO(DP.CodCia, DP.CodEmpresa, ASE.Cod_Asegurado, TRUNC(SYSDATE)) EDAD_ASEG,
       PN.FECNACIMIENTO FNACASEG, 
       PN.SEXO , OC_PERSONA_NATURAL_JURIDICA.NOMBRE_PERSONA(ASE.COD_ASEGURADO) NOMASEG,
			 DP.STSDETALLE, DP.FECANUL 
FROM ASEGURADO ASE, DETALLE_POLIZA DP, POLIZAS PO, PERSONA_NATURAL_JURIDICA PN
WHERE DP.IdPoliza              		= PO.IdPoliza
  AND DP.CodCia                   = PO.CodCia 
  AND PO.CodCia                   = nCodCia   -- 1  --:P_CODCIA
  AND PO.IdPoliza                 = nIdPoliza --6  --59 -- :P_POLIZA
  AND ASE.CodCia                 	= DP.CodCia
  AND ASE.CodEmpresa        		 	= DP.CodEmpresa
  AND ASE.Cod_Asegurado   				= nCod_Asegurado --5  --- DP.Cod_Asegurado  --- DATO OJO 
  AND ASE.Tipo_Doc_Identificacion = PN.Tipo_Doc_Identificacion
  AND ASE.Num_Doc_Identificacion  = PN.Num_Doc_Identificacion
ORDER BY DP.IDetPol, ASE.Cod_Asegurado;
CURSOR ZONA_ASEGURADO IS
SELECT d.codestado, d.descciudad  --- ZONA, ZONA_I
FROM ASEGURADO ASE, DETALLE_POLIZA DP, POLIZAS PO, PERSONA_NATURAL_JURIDICA PN, DISTRITO D
WHERE DP.IdPoliza                 = PO.IdPoliza
  AND DP.CodCia                   = PO.CodCia 
  AND PO.CodCia                   = nCodCia   --1 --:P_CODCIA
  AND PO.IdPoliza                 = nIdPoliza --6 --59 -- :P_POLIZA
  AND ASE.CodCia                  = DP.CodCia
  AND ASE.CodEmpresa              = DP.CodEmpresa
  AND ASE.Cod_Asegurado           = nCod_Asegurado --DP.Cod_Asegurado  COD_ASEG
  AND ASE.Tipo_Doc_Identificacion = PN.Tipo_Doc_Identificacion
  AND ASE.Num_Doc_Identificacion  = PN.Num_Doc_Identificacion
  AND d.CodPais      = PN.CODPAISRES
  AND d.CodEstado    = PN.CODPROVRES
  AND d.CodCiudad    = PN.CODDISTRES;
CURSOR RIESGO_ASEGURADO IS 
select  'RIESGO '||AA.RIESGOACTIVIDAD  RIESGOZ      
     from  persona_natural_juridica pnj,
           asegurado ase,
           ACTIVIDADES_ECONOMICAS AA
    where  ase.cod_asegurado           =    nCod_Asegurado -- 5 -- (A.COD_ASEGURADO)
      and ase.tipo_doc_identificacion  = pnj.tipo_doc_identificacion
      and ase.num_doc_identificacion   = pnj.num_doc_identificacion
      AND AA.CODACTIVIDAD = PNJ.CODACTIVIDAD;  --RIESGOCUP_i
BEGIN 
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
   IF cFormato = 'TEXTO' THEN
      nLinea := 1;
      cCadena     := 'THONA SEGUROS, S.A. de C.V.';-- || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;	-- SPEEDFILE
      nLinea := nLinea + 1;
      cCadena     := 'REPORTE DE ASEGURADOS CON SINIESTRO  '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY');-- || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;	-- SPEEDFILE
      
      nLinea := nLinea + 1;
      cCadena     := ' ';-- || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;	      -- SPEEDFILE
---- // TITULOS //
      nLinea := nLinea + 1;
      cCadena     := 'NSINIEST' ||cLimitador||'APPAT'           ||cLimitador||'APMAT'     ||cLimitador||'NOMBRE'     ||cLimitador||'RAMOSUBRAMO'||cLimitador||'POL'     ||cLimitador||'NASEG'
      ||cLimitador||'NDEPEND'   ||cLimitador||'NDOC'            ||cLimitador||'INIDE'     ||cLimitador||'CODPARENT'  ||cLimitador||'CVASEG'     ||cLimitador||'FNAC'    ||cLimitador||'HCVASEG'
      ||cLimitador||'NSUBGPO'   ||cLimitador||'NCATEG'          ||cLimitador||'CVPARENT'  ||cLimitador||'CVPARENT_I' ||cLimitador||'STALTA'     ||cLimitador||'STALTA_I'||cLimitador||'FSTALTA'
      ||cLimitador||'STBAJA'    ||cLimitador||'STBAJA_I'        ||cLimitador||'FSTBAJA'   ||cLimitador||'CVSEXO'     ||cLimitador||'CVSEXO_I'   ||cLimitador||'CVNFUMA' ||cLimitador||'CVNFUMA_I'
      ||cLimitador||'EDADREAL'  ||cLimitador||'EDADCALC'        ||cLimitador||'RIESGOCUP' ||cLimitador||'RIESGOCUP_I'||cLimitador||'ADSCRIP'    ||cLimitador||'PUESTO'  ||cLimitador||'CVEDOCIV'
      ||cLimitador||'CVEDOCIV_I'||cLimitador||'FINGEMP'         ||cLimitador||'FINISEG'   ||cLimitador||'SUELDO'     ||cLimitador||'ZONA'       ||cLimitador||'ZONA_I'  ||cLimitador||'TPUBIC'    
      ||cLimitador||'TPUBIC_I'  ||cLimitador||'FEC_NOTIFICACION'||cLimitador||'idtiposeg' ||cLimitador||'cod_moneda' ;--||CHR(13);
--      'NSINIEST'||cLimitador||'NPOLIZA'||cLimitador||'COD_NOMBCONT'||cLimitador||'NCONTR'||cLimitador;
---- /* ||CHR(13); */
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);                     -- SPEEDFILE
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;	-- SPEEDFILE
   ELSE
      nLinea := 1;
      cCadena  := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                       ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                       ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                       ' <style id="libro">'||chr(10)||
                       '   <!--table'||chr(10)||
                       '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                       '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                       '        .texto'||chr(10)||
                       '          {mso-number-format:"\@";}'||chr(10)||
                       '        .numero'||chr(10)||
                       '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                       '        .fecha'||chr(10)||
                       '          {mso-number-format:"dd\\-mmm\\-yyyy";}'||chr(10)||
                       '    -->'||chr(10)||
                       ' </style><div id="libro">'||chr(10);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;	-- SPEEDFILE
      nLinea := nLinea + 1;
      cCadena     := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;	-- SPEEDFILE
      
      nLinea := nLinea + 1;
      cCadena     := '<tr><th>REPORTE ASEGURADOS CON SINIESTROS  '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' ||
                      TO_CHAR(dFecHasta,'DD/MM/YYYY') || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;	-- SPEEDFILE
      
      nLinea := nLinea + 1;
      cCadena     := '<tr><th>  </th></tr></table>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;	-- SPEEDFILE
      nLinea := nLinea + 1;
      cCadena     := '<table border = 1><tr> '||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NSINIEST</font></th>'    ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">APPAT</font></th>'       ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">APMAT</font></th>'       ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE</font></th>'      ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RAMOSUBRAMO</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POL</font></th>'         ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NASEG</font></th>'       ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NDEPEND</font></th>'     ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NDOC</font></th>'        ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">INIDE</font></th>'       ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CODPARENT</font></th>'   ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CVASEG</font></th>'      ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FNAC</font></th>'        ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">HCVASEG</font></th>'     ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NSUBGPO</font></th>'     ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NCATEG</font></th>'      ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CVPARENT</font></th>'    ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CVPARENT_I</font></th>'  ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">STALTA</font></th>'      ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">STALTA_I</font></th>'    ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FSTALTA</font></th>'     ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">STBAJA</font></th>'      ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">STBAJA_I</font></th>'    ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FSTBAJA</font></th>'     ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CVSEXO</font></th>'      ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CVSEXO_I</font></th>'    ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CVNFUMA</font></th>'     ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CVNFUMA_I</font></th>'   ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EDADREAL</font></th>'    ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EDADCALC</font></th>'    ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RIESGOCUP</font></th>'   ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RIESGOCUP_I</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ADSCRIP</font></th>'     ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PUESTO</font></th>'      ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CVEDOCIV</font></th>'    ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CVEDOCIV_I</font></th>'  ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FINGEMP</font></th>'     ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FINISEG</font></th>'     ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">SUELDO</font></th>'      ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ZONA</font></th>'        ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ZONA_I</font></th>'      ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TPUBIC</font></th>'      ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TPUBIC_I</font></th>'    ||    
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TPUBIC_X</font></th>'    ||    
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FEC_NOTIFICACION</font></th>' ||    
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">idtiposeg</font></th>'   ||    
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">cod_moneda</font></th></tr>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;	-- SPEEDFILE
   END IF;
   FOR X IN ASEGCSIN LOOP
    	 nCodCia         := X.codcia;
    	 nIdPoliza       := X.IDPOLIZA;
    	 nCod_Asegurado  := X.COD_ASEGURADO;
   	   FOR Z IN  RIESGO_ASEGURADO LOOP
   	   	   driesgo_imp :=  z.RIESGOZ;
   	   END LOOP;
   	   FOR ZA IN   ZONA_ASEGURADO  LOOP
   	   	   Dcodestado_imp  	:= ZA.codestado;
   	   	   Ddescciudad_imp  := ZA.descciudad;  
   	   END LOOP;
   	   FOR ZDA IN  DATOS_ASEG  LOOP
           DEDAD_ASEG_IMP  :=  ZDA.EDAD_ASEG;
   	   END LOOP;
      IF cFormato = 'TEXTO' THEN
         cCadena :=  X.NSINIEST		     ||cLimitador||
                     X.APPAT					 ||cLimitador||
                     X.APMAT					 ||cLimitador||
                     X.NOMBRE				   ||cLimitador||
                     X.RAMOSUBRAMO		 ||cLimitador||
                     X.POLUNIK			   ||cLimitador||   
                     X.NASEG					 ||cLimitador||
                     X.NDEPEND				 ||cLimitador||
                     X.NDOC					   ||cLimitador||
                     X.INIDE					 ||cLimitador||
                     X.CODPARENT			 ||cLimitador||
                     X.CVASEG				   ||cLimitador||
                     X.FNAC					   ||cLimitador||
                     X.HCVASEG				 ||cLimitador||
                     X.NSUBGPO				 ||cLimitador||
                     X.NCATEG				   ||cLimitador||
                     X.CVPARENT			   ||cLimitador||
                     X.CVPARENT_I		   ||cLimitador||
                     X.STALTA				   ||cLimitador||
                     X.STALTA_I			   ||cLimitador||
                     X.FSTALTA				 ||cLimitador||
                     X.STBAJA				   ||cLimitador||
                     X.STBAJA_I			   ||cLimitador||
                     X.FSTBAJA				 ||cLimitador||
                     X.CVSEXO				   ||cLimitador||
                     X.CVSEXO_I			   ||cLimitador||
                     X.CVNFUMA				 ||cLimitador||
                     X.CVNFUMA_I			 ||cLimitador||
                     DEDAD_ASEG_IMP    ||cLimitador||   
                     DEDAD_ASEG_IMP    ||cLimitador||   
                     X.RIESGOCUP			 ||cLimitador||
                     driesgo_imp  		 ||cLimitador||
                     X.ADSCRIP				 ||cLimitador||
                     X.PUESTO				   ||cLimitador||
                     X.CVEDOCIV			   ||cLimitador||
                     X.CVEDOCIV_I 		 ||cLimitador||
                     X.FINGEMP		 	   ||cLimitador||
                     X.FINISEG			   ||cLimitador||
                     X.SUELDO				   ||cLimitador||
                     Dcodestado_imp	   ||cLimitador||   
                     Ddescciudad_imp   ||cLimitador||   
                     X.TPUBIC				   ||cLimitador||
                     X.TPUBIC_I			   ||cLimitador||
                     x.FEC_NOTIFICACION||cLimitador||  
                     x.idtiposeg 	     ||cLimitador||  
                     x.cod_moneda      ||cLimitador;    -- ||CHR(13); - SPEEDFILE
     ELSE
         cCadena := '<tr>'                                   || 
                OC_ARCHIVO.CAMPO_HTML(X.NSINIEST     ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.APPAT        ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.APMAT        ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.NOMBRE       ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.RAMOSUBRAMO  ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.POLUNIK      ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.NASEG        ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.NDEPEND      ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.NDOC         ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.INIDE        ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.CODPARENT    ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.CVASEG       ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FNAC,'dd/mm/RRRR')         ,'D')   ||
                OC_ARCHIVO.CAMPO_HTML(X.HCVASEG      ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.NSUBGPO      ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.NCATEG       ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.CVPARENT     ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.CVPARENT_I   ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.STALTA       ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.STALTA_I     ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FSTALTA,'DD/MM/RRRR')      ,'D')   ||
                OC_ARCHIVO.CAMPO_HTML(X.STBAJA       ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.STBAJA_I     ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FSTBAJA,'DD/MM/RRRR')      ,'D')   ||
                OC_ARCHIVO.CAMPO_HTML(X.CVSEXO       ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.CVSEXO_I     ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.CVNFUMA      ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.CVNFUMA_I    ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(DEDAD_ASEG_IMP ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(DEDAD_ASEG_IMP ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.RIESGOCUP    ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(driesgo_imp    ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.ADSCRIP      ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.PUESTO       ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.CVEDOCIV     ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.CVEDOCIV_I   ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FINGEMP,'DD/MM/RRRR')      ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FINISEG,'DD/MM/RRRR')      ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.SUELDO       ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(Dcodestado_imp ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(Ddescciudad_imp,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.TPUBIC       ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(X.TPUBIC_I     ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(driesgo_imp    ,'C')   || 
                OC_ARCHIVO.CAMPO_HTML(TO_CHAR(x.FEC_NOTIFICACION,'DD/MM/RRRR'),'D')||
                OC_ARCHIVO.CAMPO_HTML(x.idtiposeg    ,'C')   ||
                OC_ARCHIVO.CAMPO_HTML(x.cod_moneda   ,'C')   || 
                '</tr>';
     END IF;
     
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);           -- SPEEDFILE
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;	-- SPEEDFILE
   END LOOP;
   IF cFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999); -- SPEEDFILE
      --cCadena := '</table></div></html>';	                              -- SPEEDFILE
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;	-- SPEEDFILE
   END IF;
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
   
EXCEPTION 
     WHEN OTHERS THEN 
          OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
          raise_application_error(-20102,'Error en Generación Reporte Asegurados con  Siniestro: '|| ' ' ||SQLERRM);   
          
END;
PROCEDURE GENERAR_ESTIMADOS_CIERRE(cNomArchivo VARCHAR2, 
                                   cIdTipoSeg  VARCHAR2, 
                                   cCodMoneda  VARCHAR2, 
                                   dFecDesde   DATE    ,
                                   dFecHasta   DATE    ,
                                   cUsuario    VARCHAR2,
                                   cFormato    VARCHAR2,
                                   nIdReporte  NUMBER) IS
cLimitador   VARCHAR2(1) :='|';
nLinea       NUMBER;
cCadena      VARCHAR2(4000);
cCadenaAux   VARCHAR2(4000);
cCadenaAux1  VARCHAR2(4000);
cCodUser     VARCHAR2(30);
nDummy       NUMBER;
cCopy        BOOLEAN;
--
nIdSiniestro     SINIESTRO.IDSINIESTRO%TYPE;
nTipoCambio      TASAS_CAMBIO.TASA_CAMBIO%TYPE; 
nMontoRvaMon     COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc     COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;
--
--ARCHIVO_SALIDA    CLIENT_TEXT_IO.FILE_TYPE; -- SPEEDFILE
LINEA_SALIDA      VARCHAR2(5000);  -- SPEEDFILE
WI_ARCHIVO_SALIDA VARCHAR2(2000);  -- SPEEDFILE 
--
dFecCarga1A       VARCHAR2(50);
cNomArchCarga1A   PROCESOS_MASIVOS_SEGUIMIENTO.CRGA_NOM_ARCHIVO%TYPE;
cEmiTipoProceso   PROCESOS_MASIVOS_SEGUIMIENTO.EMI_TIPOPROCESO%TYPE;
dFecCarga         DATOS_PART_SINIESTROS.FecSts%TYPE;
cRFCHospital      DATOS_PART_SINIESTROS.Campo1%TYPE;
cDescSiniestro    SINIESTRO.Desc_Siniestro%TYPE;
cNomArchCarga     PROCESOS_MASIVOS_SEGUIMIENTO.CRGA_NOM_ARCHIVO%TYPE;
--
cPolizaCont       VARCHAR(50);
--
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
 WHERE PP.CODCIA     = 1
   AND PP.CODEMPRESA = 1
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
   AND CDC.CODCIA      = 1
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
   AND CTS.CODCIA     = 1
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
ORDER BY 3,1,4;
--UNION ALL   -- MLJS 10/11/2020 DE AGREGO LA CLAUSULA ALL
--
CURSOR ESTIMADOS_QA IS
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
 WHERE PP.CODCIA     = 1
   AND PP.CODEMPRESA = 1
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
   AND CTS.CODCIA     = 1
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
--
--
--
BEGIN 
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
  -- 
  IF cFormato = 'TEXTO' THEN
     ---- // ENCABEZADO //
     nLinea := 1;
     cCadena     := 'THONA SEGUROS, S.A. de C.V.'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     
     nLinea := nLinea + 1;
     cCadena     := 'REPORTE DIARIO DE RESERVAS';   
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
       
     nLinea  := nLinea + 1;
     cCadena := 'PERIODO DEL '||TO_CHAR(DFECDESDE,'DD')||' DE '||TO_CHAR(DFECDESDE,'Month')||' DE '||TO_CHAR(DFECDESDE,'YYYY')||' AL '||
                                TO_CHAR(DFECHASTA,'DD')||' DE '||TO_CHAR(DFECHASTA,'Month')||' DE '||TO_CHAR(DFECHASTA,'YYYY');
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
       
     nLinea  := nLinea + 1;
     cCadena := ' ';     
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // TITULOS //
     nLinea := nLinea + 1;
     cCadena     :=  'NUMERO POLIZA'            ||cLimitador||
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
                     'Estatus'                  ||cLimitador||
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
                     'CEDULA '                     ;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  ELSE
     ---- // CADENA INICIAL DE HOJA //
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"' ||chr(10)||
       ' xmlns:x="urn:schemas-microsoft-com:office:excel"'       ||chr(10)||
       ' xmlns="http://www.w3.org/TR/REC-html40">'      ||chr(10)||
       ' <style id="libro">' ||chr(10)||
       '   <!--table'        ||chr(10)||
       '       {mso-displayed-decimal-separator:"\.";'  ||chr(10)||
       '        mso-displayed-thousand-separator:"\,";}'         ||chr(10)||
       '        .texto'      ||chr(10)||
       ' {mso-number-format:"\@";}'   ||chr(10)||
       '        .numero'     ||chr(10)||
       ' {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
       '        .fecha'      ||chr(10)||
       ' {mso-number-format:"dd\\/mm\\/yyyy";}'  ||chr(10)||
       '    -->'    ||chr(10)||
       ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); -- SPEEDFILE
     --  ENCABEZADOS
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. DE C.V.</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DIARIO DE RESERVAS'|| '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>PERIODO DEL '||TO_CHAR(DFECDESDE,'DD')||' DE '||TO_CHAR(DFECDESDE,'MONTH')||' DE '||TO_CHAR(DFECDESDE,'YYYY')||' AL '||
                                        TO_CHAR(DFECHASTA,'DD')||' DE '||TO_CHAR(DFECHASTA,'MONTH')||' DE '||TO_CHAR(DFECHASTA,'YYYY')||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
           
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
    
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1><tr>'  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO POLIZA</font></th>'            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. POLIZA UNICO</font></th>'         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. SINIESTRO</font></th>'            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COBERTURA</font></th>'                ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE ASISTENCIA</font></th>'     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA MOVIMIENTO</font></th>'         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC HOSPITAL</font></th>'             ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CLAVE CIE10</font></th>'              ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCRIPCION DE CIE 10 </font></th>'   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCCORTAMOV</font></th>'             ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">INICIO VIGENCIA POLIZA</font></th>'   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FIN VIGENCIA POLIZA</font></th>'      ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO TRANSACCION</font></th>'       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TRANSACCION SINIESTROS</font></th>'   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CONCEPTO TRANSACCION</font></th>'     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCRIPCION CONCEPTO</font></th>'     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MOVTO RVA MON ORIG</font></th>'       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MOVTO RVA MON NAC</font></th>'        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">SALDO_RESERVA_ORIGINAL</font></th>'   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">SALDO_RESERVA_MN</font></th>'         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPC MON ORIGINAL</font></th>'         || 
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPC MON NAIONAL</font></th>'          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONEDA</font></th>'                   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE CAMBIO</font></th>'           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA OCURRENCIA</font></th>'         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA NOTIFICACION</font></th>'       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ESTATUS COBERTURA</font></th>'        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE ASEGURADO</font></th>'         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CODIGO DEL ASEGURADO</font></th>'     ;    --MLJS 21/12/2020       
     cCadenaAux  := '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCRIPCION DEL SINIESTRO</font></th>';    --MLJS 21/12/2020
     cCadenaAux1 := '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO SEGURO</font></th></th>'         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE_ARCH_CARGA</font></th>'        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE CARGA</font></th>'           ||      
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO</font></th>'                  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE DE ARCHIVO LOGEM</font></th>'  ||    -- ; MLJS 21/12/2020
     --cCadenaAux1 := '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Es Contributorio</font></th>'         ||  -- MLJS 21/12/2020
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Es Contributorio</font></th>'         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Contributorio</font></th>'          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Giro de Negocio</font></th>'          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de Negocio</font></th>'          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fuente de Recursos</font></th>'       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Paquete Comercial</font></th>'        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Categoria</font></th>'                ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Canal de Venta</font></th>'           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA CONTABLE</font></th>'          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CONTRATANTE</font></th>'              ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EMPRESA LABORA</font></th>'           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CERTIFICADO</font></th>'              ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CREDITO</font></th>'                  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC ASEGURADO</font></th>'            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CURP ASEGURADO</font></th>'           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA INGRESO ASEGURADO</font></th>'  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA INGRESO CONTRATANTE</font></th>'||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">SEXO</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO ASEGURADO</font></th>'           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CVE ESTADO</font></th>'               ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOM ESTADO</font></th>'               ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CVE MUNICIPIO</font></th>'            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOM MUNICIPIO</font></th>'            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MEDICO CERFICANTE</font></th>'        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CEDULA</font></th>';
     -- 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     OC_ARCHIVO.Escribir_Linea(cCadenaAux, cCodUser, nLinea); --MLJS 21/12/2020
     OC_ARCHIVO.Escribir_Linea(cCadenaAux1, cCodUser, nLinea);
  END IF;
  -- CARGA DE INFORMACIÓN 
  FOR X IN ESTIMADOS_Q LOOP
      IF cUsuario = '%' THEN
         --
         nIdSiniestro := X.IdSiniestro;
         --
         BEGIN
           SELECT TO_CHAR(PMS.Crga_FechaComp,'DD/MM/YYYY HH24:MI:SS'), 
                  PMS.Crga_Nom_Archivo,
                  PMS.Emi_TipoProceso, 
                  DPS.FecSts, 
                  DPS.Campo1,
                  NVL(DPS.Campo4,X.Desc_Sini),
                  DECODE(PMS.Crga_Nom_Archivo,NULL,'Registro Manual',
                         NVL(DPS.Campo85,'Sin Archio LOGEM'))  
             INTO dFecCarga1A, 
                  cNomArchCarga1A, 
                  cEmiTipoProceso, 
                  dFecCarga, 
                  cRFCHospital,
                  cDescSiniestro, 
                  cNomArchCarga
             FROM PROCESOS_MASIVOS_SEGUIMIENTO PMS,DATOS_PART_SINIESTROS DPS
            WHERE PMS.Crga_Cod_Proceso IN('ESTSIN','AURVAD','DIRVAD')
              AND TRUNC(PMS.Crga_Fecha)  BETWEEN dFecDesde AND dFecHasta 
              AND PMS.Emi_StsRegProceso  = 'EMI'
              AND PMS.IdSiniestro        = X.IdSiniestro
              AND PMS.IdPoliza  = X.IdPoliza
              AND PMS.Cod_Asegurado      = X.Cod_Asegurado
              AND PMS.IdProcMasivo       = DPS.IdProcMasivo
              AND PMS.IDSINIESTRO = DPS.IdsINIESTRO --pst
              AND PMS.IDPOLIZA = DPS.IDPOLIZA --PST
              AND PMS.CODCIA = DPS.CODCIA --pst
              AND PMS.IDTRANSACCION      = X.IDTRANSACCION;
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
         	 SELECT TIPODIARIO||'-'||NUMCOMPROBSC
         	 INTO   cPolizaCont
           FROM   COMPROBANTES_CONTABLES CC
           WHERE  NUMTRANSACCION = X.NUMTRX;
         EXCEPTION
         	  WHEN NO_DATA_FOUND THEN
         	     cPolizaCont := 'SIN POLIZA CONT';
         	  WHEN OTHERS THEN
         	     cPolizaCont := 'SIN POLIZA CONT';   
         END;
         
         --MLJS 08/10/2020 SE OBTIENE LA PÓLIZA CONTABLE
         --
         IF cFormato = 'TEXTO' THEN
            cCadena :=  X.IDPOLIZA                   ||cLimitador||
            X.POLUNIK                                ||cLimitador||     
            X.IDSINIESTRO                            ||cLimitador||
            X.CVCOB                                  ||cLimitador||
            X.NUMSINIREF                             ||cLimitador||
            TO_CHAR(X.FECHAMVTO,'DD/MM/RRRR')        ||cLimitador||  
            cRFCHospital                             ||cLimitador||
            X.CVE_CIE_10                             ||cLimitador||
            X.DESC_CIE_10                            ||cLimitador||
            X.DESCCORTAMOV                           ||cLimitador||
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
            X.COD_ASEGURADO                          ||cLimitador;     -- MLJS 21/12/2020
cCadenaAux  := cDescSiniestro                        ||cLimitador;     -- MLJS 21/12/2020
cCadenaAux1 := X.TIPOSEGURO                          ||cLimitador||
            cNomArchCarga1A                          ||cLimitador||
            dFecCarga1A                              ||cLimitador||
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
            X.NOMCONTRATANTE                         ||cLimitador|| 
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
            X.ID_CEDULA_MEDICA                       ||CHR(13);
         ELSE
            cCadena := '<tr>'                                || 
            OC_ARCHIVO.CAMPO_HTML(X.IDPOLIZA           ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.POLUNIK            ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.IDSINIESTRO        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CVCOB              ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NUMSINIREF         ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FECHAMVTO,'DD/MM/RRRR'),'D') ||
            OC_ARCHIVO.CAMPO_HTML(cRFCHospital         ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CVE_CIE_10         ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.DESC_CIE_10        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.DESCCORTAMOV       ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FECINIVIG,'DD/MM/RRRR'),'D') ||
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FECFINVIG,'DD/MM/RRRR'),'D') ||
            OC_ARCHIVO.CAMPO_HTML(X.NUMTRX             ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CVETRX             ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CPTOTRX            ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.DESCCPTOTRX        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(nMontoRvaMon         ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(nMontoRvaLoc         ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(X.MONTO_RESERVA_MONEDA ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(X.MONTO_RESERVA_LOCAL  ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(X.OPC_MONEDA         ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(X.OPC_LOCAL          ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(X.MONEDA             ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nTipoCambio,'999.000000') ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_OCURRENCIA,'DD/MM/RRRR'),'D') ||    
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_NOTIFICACION,'DD/MM/RRRR'),'D') ||
            OC_ARCHIVO.CAMPO_HTML(X.STSCOBERTURA       ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOM_ASEG           ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.COD_ASEGURADO      ,'C') ;  -- MLJS 21/12/2020
   cCadenaAux := OC_ARCHIVO.CAMPO_HTML(cDescSiniestro  ,'C') ;  -- MLJS 21/12/2020
  cCadenaAux1 := OC_ARCHIVO.CAMPO_HTML(X.TIPOSEGURO    ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(cNomArchCarga1A      ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(dFecCarga1A          ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.USUARIO            ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(cNomArchCarga        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.ESCONTRIBUTORIO    ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.PORCENCONTRIBUTORIO,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.GIRONEGOCIO        ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.TIPONEGOCIO        ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.FUENTERECURSOS     ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CODPAQCOMERCIAL    ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CATEGORIA          ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CANALFORMAVENTA    ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(cPolizaCont          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOMCONTRATANTE     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.EMPRESA_LABORA     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CERTIFICADO        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.IDCREDITO          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.RFC_ASEGURADO      ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CURP_ASEGURADO     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.FE_INGRE_CONTRA    ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.FE_INGRE_ASEGU     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.SEXO               ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.TP_ASEGURADO       ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.ESTADO             ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOMESTADO          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.MUNICIPIO          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOMMUNICIPIO       ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOM_MEDICO_CERTIFICA,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.ID_CEDULA_MEDICA    ,'C') ||
            '</tr>';
         END IF;
         --  
         nLinea := nLinea + 1;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);   
         OC_ARCHIVO.Escribir_Linea(cCadenaAux , cCodUser, nLinea); -- MLJS 21/12/2020
         OC_ARCHIVO.Escribir_Linea(cCadenaAux1, cCodUser, nLinea); -- MLJS 21/12/2020
      ELSIF cUsuario != '%' AND X.USUARIO = cUsuario THEN
         nIdSiniestro := X.IdSiniestro;
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
         --
         IF cFormato = 'TEXTO' THEN
            cCadena :=  X.IDPOLIZA ||cLimitador||
            X.POLUNIK              ||cLimitador||     
            X.IDSINIESTRO          ||cLimitador||
            X.CVCOB                ||cLimitador||
            X.NUMSINIREF           ||cLimitador||
            X.FECHAMVTO            ||cLimitador||
            cRFCHospital           ||cLimitador||
            X.CVE_CIE_10           ||cLimitador||
            X.DESC_CIE_10          ||cLimitador||
            X.DESCCORTAMOV         ||cLimitador||
            X.FECINIVIG            ||cLimitador||
            X.FECFINVIG            ||cLimitador||
            X.NUMTRX               ||cLimitador||
            X.CVETRX               ||cLimitador||
            X.CPTOTRX              ||cLimitador||
            X.DESCCPTOTRX          ||cLimitador||
            nMontoRvaMon           ||cLimitador||
            nMontoRvaLoc           ||cLimitador||
            X.MONTO_RESERVA_MONEDA ||cLimitador||
            X.MONTO_RESERVA_LOCAL  ||cLimitador||
            X.OPC_MONEDA           ||cLimitador||
            X.OPC_LOCAL            ||cLimitador||
            X.MONEDA               ||cLimitador||
            nTipoCambio            ||cLimitador||
            X.FEC_OCURRENCIA       ||cLimitador||
            X.FEC_NOTIFICACION     ||cLimitador||
            X.STSCOBERTURA         ||cLimitador||
            X.NOM_ASEG             ||cLimitador||
            X.COD_ASEGURADO        ||cLimitador;       -- MLJS 21/12/2020
 cCadenaAux := cDescSiniestro      ||cLimitador;       -- MLJS 21/12/2020
 cCadenaAux1:= X.TIPOSEGURO        ||cLimitador||      -- MLJS 21/12/2020
            cNomArchCarga1A        ||cLimitador||
            dFecCarga1A            ||cLimitador||
            X.USUARIO              ||cLimitador||
            cNomArchCarga          ||cLimitador||
            X.ESCONTRIBUTORIO      ||cLimitador||
            X.PORCENCONTRIBUTORIO  ||cLimitador||
            X.GIRONEGOCIO          ||cLimitador||
            X.TIPONEGOCIO          ||cLimitador||
            X.FUENTERECURSOS       ||cLimitador||
            X.CODPAQCOMERCIAL      ||cLimitador||
            X.CATEGORIA            ||cLimitador||
            X.CANALFORMAVENTA      ||cLimitador||
            cPolizaCont                              ||cLimitador|| 
            X.NOMCONTRATANTE                         ||cLimitador|| 
            X.EMPRESA_LABORA                         ||cLimitador|| 
            X.CERTIFICADO                            ||cLimitador|| 
            X.IDCREDITO                              ||cLimitador|| 
            X.RFC_ASEGURADO                          ||cLimitador|| 
            X.FE_INGRE_CONTRA                        ||cLimitador|| 
            X.FE_INGRE_ASEGU                         ||cLimitador|| 
            X.SEXO                                   ||cLimitador|| 
            X.TP_ASEGURADO                           ||cLimitador||
            X.ESTADO                                 ||cLimitador||
            X.NOMESTADO                              ||cLimitador||
            X.MUNICIPIO                              ||cLimitador||
            X.NOMMUNICIPIO                           ||cLimitador||
            X.NOM_MEDICO_CERTIFICA                   ||cLimitador||
            X.ID_CEDULA_MEDICA                       ||CHR(13);
          
     ELSE
        cCadena := '<tr>'                                  || 
          OC_ARCHIVO.CAMPO_HTML(X.IDPOLIZA           ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.POLUNIK            ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.IDSINIESTRO        ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.CVCOB              ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.NUMSINIREF         ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.FECHAMVTO          ,'D') ||
          OC_ARCHIVO.CAMPO_HTML(cRFCHospital         ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.CVE_CIE_10         ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.DESC_CIE_10        ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.DESCCORTAMOV       ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.FECINIVIG          ,'D') ||
          OC_ARCHIVO.CAMPO_HTML(X.FECFINVIG          ,'D') ||
          OC_ARCHIVO.CAMPO_HTML(X.NUMTRX             ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.CVETRX             ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.CPTOTRX            ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.DESCCPTOTRX        ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(nMontoRvaMon         ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(nMontoRvaLoc         ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(X.MONTO_RESERVA_MONEDA ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(X.MONTO_RESERVA_LOCAL  ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(X.OPC_MONEDA         ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(X.OPC_LOCAL          ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(X.MONEDA             ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nTipoCambio,'999.000000') ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.FEC_OCURRENCIA     ,'D') ||    
          OC_ARCHIVO.CAMPO_HTML(X.FEC_NOTIFICACION   ,'D') ||
          OC_ARCHIVO.CAMPO_HTML(X.STSCOBERTURA       ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.NOM_ASEG           ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.COD_ASEGURADO      ,'C') ;       -- MLJS 21/12/2020
 cCadenaAux := OC_ARCHIVO.CAMPO_HTML(cDescSiniestro    ,'C');   -- MLJS 21/12/2020
 cCadenaAux1:= OC_ARCHIVO.CAMPO_HTML(X.TIPOSEGURO      ,'C') || -- MLJS 21/12/2020
            OC_ARCHIVO.CAMPO_HTML(cNomArchCarga1A      ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(dFecCarga1A          ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.USUARIO            ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(cNomArchCarga        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.ESCONTRIBUTORIO    ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.PORCENCONTRIBUTORIO,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.GIRONEGOCIO        ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.TIPONEGOCIO        ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.FUENTERECURSOS     ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CODPAQCOMERCIAL    ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CATEGORIA          ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CANALFORMAVENTA    ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(cPolizaCont          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOMCONTRATANTE     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.EMPRESA_LABORA     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CERTIFICADO        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.IDCREDITO          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.RFC_ASEGURADO      ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.FE_INGRE_CONTRA    ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.FE_INGRE_ASEGU     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.SEXO               ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.TP_ASEGURADO       ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.ESTADO             ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOMESTADO          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.MUNICIPIO          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOMMUNICIPIO       ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOM_MEDICO_CERTIFICA,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.ID_CEDULA_MEDICA    ,'C') ||
            '</tr>';     END IF;
     nLinea := nLinea + 1;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     OC_ARCHIVO.Escribir_Linea(cCadenaAux, cCodUser, nLinea);    -- MLJS 21/12/2020  
     OC_ARCHIVO.Escribir_Linea(cCadenaAux1, cCodUser, nLinea);   -- MLJS 21/12/2020  
   END IF;
  END LOOP;
  FOR X IN ESTIMADOS_QA LOOP
      IF cUsuario = '%' THEN
         --
         nIdSiniestro := X.IdSiniestro;
         --
         BEGIN
           SELECT TO_CHAR(PMS.Crga_FechaComp,'DD/MM/YYYY HH24:MI:SS'), 
                  PMS.Crga_Nom_Archivo,
                  PMS.Emi_TipoProceso, 
                  DPS.FecSts, 
                  DPS.Campo1,
                  NVL(DPS.Campo4,X.Desc_Sini),
                  DECODE(PMS.Crga_Nom_Archivo,NULL,'Registro Manual',
                         NVL(DPS.Campo85,'Sin Archio LOGEM'))  
             INTO dFecCarga1A, 
                  cNomArchCarga1A, 
                  cEmiTipoProceso, 
                  dFecCarga, 
                  cRFCHospital,
                  cDescSiniestro, 
                  cNomArchCarga
             FROM PROCESOS_MASIVOS_SEGUIMIENTO PMS,DATOS_PART_SINIESTROS DPS
            WHERE PMS.Crga_Cod_Proceso IN('ESTSIN','AURVAD','DIRVAD')
              AND TRUNC(PMS.Crga_Fecha)  BETWEEN dFecDesde AND dFecHasta 
              AND PMS.Emi_StsRegProceso  = 'EMI'
              AND PMS.IdSiniestro        = X.IdSiniestro
              AND PMS.IdPoliza  = X.IdPoliza
              AND PMS.Cod_Asegurado      = X.Cod_Asegurado
              AND PMS.IdProcMasivo       = DPS.IdProcMasivo
              AND PMS.IDTRANSACCION      = X.IDTRANSACCION;
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
         	 SELECT TIPODIARIO||'-'||NUMCOMPROBSC
         	 INTO   cPolizaCont
           FROM   COMPROBANTES_CONTABLES CC
           WHERE  NUMTRANSACCION = X.NUMTRX;
         EXCEPTION
         	  WHEN NO_DATA_FOUND THEN
         	     cPolizaCont := 'SIN POLIZA CONT';
         	  WHEN OTHERS THEN
         	     cPolizaCont := 'SIN POLIZA CONT';   
         END;
         
         --MLJS 08/10/2020 SE OBTIENE LA PÓLIZA CONTABLE
         --
         IF cFormato = 'TEXTO' THEN
            cCadena :=  X.IDPOLIZA                   ||cLimitador||
            X.POLUNIK                                ||cLimitador||     
            X.IDSINIESTRO                            ||cLimitador||
            X.CVCOB                                  ||cLimitador||
            X.NUMSINIREF                             ||cLimitador||
            TO_CHAR(X.FECHAMVTO,'DD/MM/RRRR')        ||cLimitador||  
            cRFCHospital                             ||cLimitador||
            X.CVE_CIE_10                             ||cLimitador||
            X.DESC_CIE_10                            ||cLimitador||
            X.DESCCORTAMOV                           ||cLimitador||
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
            X.COD_ASEGURADO                          ||cLimitador;     -- MLJS 21/12/2020
cCadenaAux  := cDescSiniestro                        ||cLimitador;     -- MLJS 21/12/2020
cCadenaAux1 := X.TIPOSEGURO                          ||cLimitador||
            cNomArchCarga1A                          ||cLimitador||
            dFecCarga1A                              ||cLimitador||
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
            X.NOMCONTRATANTE                         ||cLimitador|| 
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
            X.ID_CEDULA_MEDICA                       ||CHR(13);
         ELSE
            cCadena := '<tr>'                                || 
            OC_ARCHIVO.CAMPO_HTML(X.IDPOLIZA           ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.POLUNIK            ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.IDSINIESTRO        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CVCOB              ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NUMSINIREF         ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FECHAMVTO,'DD/MM/RRRR'),'D') ||
            OC_ARCHIVO.CAMPO_HTML(cRFCHospital         ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CVE_CIE_10         ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.DESC_CIE_10        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.DESCCORTAMOV       ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FECINIVIG,'DD/MM/RRRR'),'D') ||
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FECFINVIG,'DD/MM/RRRR'),'D') ||
            OC_ARCHIVO.CAMPO_HTML(X.NUMTRX             ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CVETRX             ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CPTOTRX            ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.DESCCPTOTRX        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(nMontoRvaMon         ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(nMontoRvaLoc         ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(X.MONTO_RESERVA_MONEDA ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(X.MONTO_RESERVA_LOCAL  ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(X.OPC_MONEDA         ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(X.OPC_LOCAL          ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(X.MONEDA             ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nTipoCambio,'999.000000') ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_OCURRENCIA,'DD/MM/RRRR'),'D') ||    
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_NOTIFICACION,'DD/MM/RRRR'),'D') ||
            OC_ARCHIVO.CAMPO_HTML(X.STSCOBERTURA       ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOM_ASEG           ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.COD_ASEGURADO      ,'C') ;  -- MLJS 21/12/2020
   cCadenaAux := OC_ARCHIVO.CAMPO_HTML(cDescSiniestro  ,'C') ;  -- MLJS 21/12/2020
  cCadenaAux1 := OC_ARCHIVO.CAMPO_HTML(X.TIPOSEGURO    ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(cNomArchCarga1A      ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(dFecCarga1A          ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.USUARIO            ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(cNomArchCarga        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.ESCONTRIBUTORIO    ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.PORCENCONTRIBUTORIO,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.GIRONEGOCIO        ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.TIPONEGOCIO        ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.FUENTERECURSOS     ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CODPAQCOMERCIAL    ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CATEGORIA          ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CANALFORMAVENTA    ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(cPolizaCont          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOMCONTRATANTE     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.EMPRESA_LABORA     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CERTIFICADO        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.IDCREDITO          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.RFC_ASEGURADO      ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CURP_ASEGURADO     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.FE_INGRE_CONTRA    ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.FE_INGRE_ASEGU     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.SEXO               ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.TP_ASEGURADO       ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.ESTADO             ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOMESTADO          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.MUNICIPIO          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOMMUNICIPIO       ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOM_MEDICO_CERTIFICA,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.ID_CEDULA_MEDICA    ,'C') ||
            '</tr>';
         END IF;
         --  
         nLinea := nLinea + 1;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);   
         OC_ARCHIVO.Escribir_Linea(cCadenaAux , cCodUser, nLinea); -- MLJS 21/12/2020
         OC_ARCHIVO.Escribir_Linea(cCadenaAux1, cCodUser, nLinea); -- MLJS 21/12/2020
      ELSIF cUsuario != '%' AND X.USUARIO = cUsuario THEN
         nIdSiniestro := X.IdSiniestro;
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
              AND PMS.IDSINIESTRO = DPS.IdsINIESTRO --pst
              AND PMS.IDPOLIZA = DPS.IDPOLIZA --PST
              AND PMS.CODCIA = DPS.CODCIA --pst
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
         --
         IF cFormato = 'TEXTO' THEN
            cCadena :=  X.IDPOLIZA ||cLimitador||
            X.POLUNIK              ||cLimitador||     
            X.IDSINIESTRO          ||cLimitador||
            X.CVCOB                ||cLimitador||
            X.NUMSINIREF           ||cLimitador||
            X.FECHAMVTO            ||cLimitador||
            cRFCHospital           ||cLimitador||
            X.CVE_CIE_10           ||cLimitador||
            X.DESC_CIE_10          ||cLimitador||
            X.DESCCORTAMOV         ||cLimitador||
            X.FECINIVIG            ||cLimitador||
            X.FECFINVIG            ||cLimitador||
            X.NUMTRX               ||cLimitador||
            X.CVETRX               ||cLimitador||
            X.CPTOTRX              ||cLimitador||
            X.DESCCPTOTRX          ||cLimitador||
            nMontoRvaMon           ||cLimitador||
            nMontoRvaLoc           ||cLimitador||
            X.MONTO_RESERVA_MONEDA ||cLimitador||
            X.MONTO_RESERVA_LOCAL  ||cLimitador||
            X.OPC_MONEDA           ||cLimitador||
            X.OPC_LOCAL            ||cLimitador||
            X.MONEDA               ||cLimitador||
            nTipoCambio            ||cLimitador||
            X.FEC_OCURRENCIA       ||cLimitador||
            X.FEC_NOTIFICACION     ||cLimitador||
            X.STSCOBERTURA         ||cLimitador||
            X.NOM_ASEG             ||cLimitador||
            X.COD_ASEGURADO        ||cLimitador;       -- MLJS 21/12/2020
 cCadenaAux := cDescSiniestro      ||cLimitador;       -- MLJS 21/12/2020
 cCadenaAux1:= X.TIPOSEGURO        ||cLimitador||      -- MLJS 21/12/2020
            cNomArchCarga1A        ||cLimitador||
            dFecCarga1A            ||cLimitador||
            X.USUARIO              ||cLimitador||
            cNomArchCarga          ||cLimitador||
            X.ESCONTRIBUTORIO      ||cLimitador||
            X.PORCENCONTRIBUTORIO  ||cLimitador||
            X.GIRONEGOCIO          ||cLimitador||
            X.TIPONEGOCIO          ||cLimitador||
            X.FUENTERECURSOS       ||cLimitador||
            X.CODPAQCOMERCIAL      ||cLimitador||
            X.CATEGORIA            ||cLimitador||
            X.CANALFORMAVENTA      ||cLimitador||
            cPolizaCont                              ||cLimitador|| 
            X.NOMCONTRATANTE                         ||cLimitador|| 
            X.EMPRESA_LABORA                         ||cLimitador|| 
            X.CERTIFICADO                            ||cLimitador|| 
            X.IDCREDITO                              ||cLimitador|| 
            X.RFC_ASEGURADO                          ||cLimitador|| 
            X.FE_INGRE_CONTRA                        ||cLimitador|| 
            X.FE_INGRE_ASEGU                         ||cLimitador|| 
            X.SEXO                                   ||cLimitador|| 
            X.TP_ASEGURADO                           ||cLimitador||
            X.ESTADO                                 ||cLimitador||
            X.NOMESTADO                              ||cLimitador||
            X.MUNICIPIO                              ||cLimitador||
            X.NOMMUNICIPIO                           ||cLimitador||
            X.NOM_MEDICO_CERTIFICA                   ||cLimitador||
            X.ID_CEDULA_MEDICA                       ||CHR(13);
          
     ELSE
        cCadena := '<tr>'                                  || 
          OC_ARCHIVO.CAMPO_HTML(X.IDPOLIZA           ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.POLUNIK            ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.IDSINIESTRO        ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.CVCOB              ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.NUMSINIREF         ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.FECHAMVTO          ,'D') ||
          OC_ARCHIVO.CAMPO_HTML(cRFCHospital         ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.CVE_CIE_10         ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.DESC_CIE_10        ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.DESCCORTAMOV       ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.FECINIVIG          ,'D') ||
          OC_ARCHIVO.CAMPO_HTML(X.FECFINVIG          ,'D') ||
          OC_ARCHIVO.CAMPO_HTML(X.NUMTRX             ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.CVETRX             ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.CPTOTRX            ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.DESCCPTOTRX        ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(nMontoRvaMon         ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(nMontoRvaLoc         ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(X.MONTO_RESERVA_MONEDA ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(X.MONTO_RESERVA_LOCAL  ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(X.OPC_MONEDA         ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(X.OPC_LOCAL          ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(X.MONEDA             ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nTipoCambio,'999.000000') ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.FEC_OCURRENCIA     ,'D') ||    
          OC_ARCHIVO.CAMPO_HTML(X.FEC_NOTIFICACION   ,'D') ||
          OC_ARCHIVO.CAMPO_HTML(X.STSCOBERTURA       ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.NOM_ASEG           ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.COD_ASEGURADO      ,'C') ;       -- MLJS 21/12/2020
 cCadenaAux := OC_ARCHIVO.CAMPO_HTML(cDescSiniestro    ,'C');   -- MLJS 21/12/2020
 cCadenaAux1:= OC_ARCHIVO.CAMPO_HTML(X.TIPOSEGURO      ,'C') || -- MLJS 21/12/2020
            OC_ARCHIVO.CAMPO_HTML(cNomArchCarga1A      ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(dFecCarga1A          ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.USUARIO            ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(cNomArchCarga        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.ESCONTRIBUTORIO    ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.PORCENCONTRIBUTORIO,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.GIRONEGOCIO        ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.TIPONEGOCIO        ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.FUENTERECURSOS     ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CODPAQCOMERCIAL    ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CATEGORIA          ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CANALFORMAVENTA    ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(cPolizaCont          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOMCONTRATANTE     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.EMPRESA_LABORA     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CERTIFICADO        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.IDCREDITO          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.RFC_ASEGURADO      ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.FE_INGRE_CONTRA    ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.FE_INGRE_ASEGU     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.SEXO               ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.TP_ASEGURADO       ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.ESTADO             ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOMESTADO          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.MUNICIPIO          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOMMUNICIPIO       ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOM_MEDICO_CERTIFICA,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.ID_CEDULA_MEDICA    ,'C') ||
            '</tr>';     END IF;
     nLinea := nLinea + 1;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     OC_ARCHIVO.Escribir_Linea(cCadenaAux, cCodUser, nLinea);    -- MLJS 21/12/2020  
     OC_ARCHIVO.Escribir_Linea(cCadenaAux1, cCodUser, nLinea);   -- MLJS 21/12/2020  
   END IF;
  END LOOP;  
  IF cFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
      --cCadena := '</table></div></html>';
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE   
  END IF;
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
 
  
EXCEPTION 
     WHEN OTHERS THEN 
 OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
 raise_application_error(-20105,'Error en Generación Reporte Estimados de Siniestros: '|| SQLERRM||' Siniestro: '||nIdSiniestro);  
 
END;
PROCEDURE GENERAR_ESTIMADOS_CIERRE_SOL(cNomArchivo VARCHAR2, 
                                       cIdTipoSeg  VARCHAR2, 
                                       cCodMoneda  VARCHAR2, 
                                       dFecDesde   DATE    ,
                                       dFecHasta   DATE    ,
                                   cUsuario    VARCHAR2,
                                   cFormato    VARCHAR2,
                                   nIdReporte  NUMBER) IS
cLimitador   VARCHAR2(1) :='|';
nLinea       NUMBER;
cCadena      VARCHAR2(4000);
cCadenaAux   VARCHAR2(4000);
cCadenaAux1  VARCHAR2(4000);
cCodUser     VARCHAR2(30);
nDummy       NUMBER;
cCopy        BOOLEAN;
--
nIdSiniestro     SINIESTRO.IDSINIESTRO%TYPE;
nTipoCambio      TASAS_CAMBIO.TASA_CAMBIO%TYPE; 
nMontoRvaMon     COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc     COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;
--
--ARCHIVO_SALIDA    CLIENT_TEXT_IO.FILE_TYPE; -- SPEEDFILE
LINEA_SALIDA      VARCHAR2(5000);  -- SPEEDFILE
WI_ARCHIVO_SALIDA VARCHAR2(2000);  -- SPEEDFILE 
--
dFecCarga1A       VARCHAR2(50);
cNomArchCarga1A   PROCESOS_MASIVOS_SEGUIMIENTO.CRGA_NOM_ARCHIVO%TYPE;
cEmiTipoProceso   PROCESOS_MASIVOS_SEGUIMIENTO.EMI_TIPOPROCESO%TYPE;
dFecCarga         DATOS_PART_SINIESTROS.FecSts%TYPE;
cRFCHospital      DATOS_PART_SINIESTROS.Campo1%TYPE;
cDescSiniestro    SINIESTRO.Desc_Siniestro%TYPE;
cNomArchCarga     PROCESOS_MASIVOS_SEGUIMIENTO.CRGA_NOM_ARCHIVO%TYPE;
--
cPolizaCont       VARCHAR(50);
--
CURSOR ESTIMADOS_Q IS
SELECT SI.IDPOLIZA, 
       PP.NUMPOLUNICO POLUNIK, 
       SI.IDSINIESTRO, 
       CS.CODCOBERT CVCOB,
       SI.NUMSINIREF,          
       CS.FECRES FECHAMVTO, 
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
       SI.CODUSUARIO USUARIO, 
       '' CODSUBPROCESO, --D.CODSUBPROCESO, 
       --
       '' IDTRANSACCION,--T.IDTRANSACCION,
       --
       DECODE(NVL(PP.PORCENCONTRIBUTORIO,0),0,'N','S')  ESCONTRIBUTORIO,
       NVL(PP.PORCENCONTRIBUTORIO,0)                    PORCENCONTRIBUTORIO,
       UPPER(TXT.DESCGIRONEGOCIO)                       GIRONEGOCIO,
       DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',PP.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',PP.CODTIPONEGOCIO)) TIPONEGOCIO,
       DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',PP.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',PP.FUENTERECURSOSPRIMA)) FUENTERECURSOS,        
       PP.CODPAQCOMERCIAL                               CODPAQCOMERCIAL,
       CGO.DESCCATEGO                                   CATEGORIA,
       DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',PP.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',PP.FORMAVENTA)) CANALFORMAVENTA,  
       --
       OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE) NOMCONTRATANTE,
       SI.EMPRESA_LABORA,
       SI.IDETPOL CERTIFICADO,
       SI.IDCREDITO,
       SI.RFC_ASEGURADO,
       TO_CHAR(OC_PERSONA_NATURAL_JURIDICA.FECHA_INGRESO(CLI.TIPO_DOC_IDENTIFICACION,CLI.NUM_DOC_IDENTIFICACION),'DD/MM/YYYY') FE_INGRE_CONTRA,
       TO_CHAR(OC_PERSONA_NATURAL_JURIDICA.FECHA_INGRESO(ASE.TIPO_DOC_IDENTIFICACION,ASE.NUM_DOC_IDENTIFICACION),'DD/MM/YYYY') FE_INGRE_ASEGU,
       OC_PERSONA_NATURAL_JURIDICA.SEXO(ASE.TIPO_DOC_IDENTIFICACION,ASE.NUM_DOC_IDENTIFICACION) SEXO,
       SI.TP_ASEGURADO
  FROM COBERTURA_SINIESTRO_ASEG CS,
       SINIESTRO SI,
       DETALLE_SINIESTRO_ASEG DS,
       CONFIG_TRANSAC_SINIESTROS CTS,
       POLIZAS PP, 
       CATALOGO_DE_CONCEPTOS CDC,
       POLIZAS_TEXTO_COTIZACION  TXT,
       CATEGORIAS                CGO,
       CLIENTES                  CLI,
       ASEGURADO                 ASE
 WHERE CS.STSCOBERTURA = 'SOL'
   AND CS.FECRES >= DFECDESDE
   AND CS.FECRES <= DFECHASTA
  --
   AND SI.IDSINIESTRO = CS.IDSINIESTRO
   AND SI.CODCIA      = 1
   AND (SI.COD_MONEDA = DECODE(cCodMoneda,'%',SI.COD_MONEDA,cCodMoneda))
   --
   AND DS.IDSINIESTRO = CS.IDSINIESTRO
   AND (DS.IDTIPOSEG  = DECODE(cIdTipoSeg,'%',DS.IDTIPOSEG ,cIdTipoSeg))
   --
   AND CDC.CODCIA(+)      = 1
   AND CDC.CODCONCEPTO(+) = CS.CODCPTOTRANSAC
   --
   AND PP.IDPOLIZA    = SI.IDPOLIZA
   AND PP.CODCIA      = SI.CODCIA
   AND PP.CODEMPRESA  = SI.CODEMPRESA
   --
   AND CTS.CODCIA     = 1
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
UNION ALL
--
SELECT SI.IDPOLIZA, 
       PP.NUMPOLUNICO POLUNIK, 
       SI.IDSINIESTRO, 
       CS.CODCOBERT CVCOB,
       SI.NUMSINIREF,          
       CS.FECRES FECHAMVTO, 
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
       SI.CODUSUARIO USUARIO, 
       '' CODSUBPROCESO, --D.CODSUBPROCESO, 
       --
       '' IDTRANSACCION,--T.IDTRANSACCION,
       --
       DECODE(NVL(PP.PORCENCONTRIBUTORIO,0),0,'N','S')  ESCONTRIBUTORIO,
       NVL(PP.PORCENCONTRIBUTORIO,0)                    PORCENCONTRIBUTORIO,
       UPPER(TXT.DESCGIRONEGOCIO)                       GIRONEGOCIO,
       DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',PP.CODTIPONEGOCIO),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',PP.CODTIPONEGOCIO)) TIPONEGOCIO,
       DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',PP.FUENTERECURSOSPRIMA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',PP.FUENTERECURSOSPRIMA)) FUENTERECURSOS,        
       PP.CODPAQCOMERCIAL                               CODPAQCOMERCIAL,
       CGO.DESCCATEGO                                   CATEGORIA,
       DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',PP.FORMAVENTA),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',PP.FORMAVENTA)) CANALFORMAVENTA,  
       --
       OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE) NOMCONTRATANTE,
       SI.EMPRESA_LABORA,
       SI.IDETPOL CERTIFICADO,
       SI.IDCREDITO,
       SI.RFC_ASEGURADO,
       TO_CHAR(OC_PERSONA_NATURAL_JURIDICA.FECHA_INGRESO(CLI.TIPO_DOC_IDENTIFICACION,CLI.NUM_DOC_IDENTIFICACION),'DD/MM/YYYY') FE_INGRE_CONTRA,
       TO_CHAR(OC_PERSONA_NATURAL_JURIDICA.FECHA_INGRESO(ASE.TIPO_DOC_IDENTIFICACION,ASE.NUM_DOC_IDENTIFICACION),'DD/MM/YYYY') FE_INGRE_ASEGU,
       OC_PERSONA_NATURAL_JURIDICA.SEXO(ASE.TIPO_DOC_IDENTIFICACION,ASE.NUM_DOC_IDENTIFICACION) SEXO,
       SI.TP_ASEGURADO
  FROM COBERTURA_SINIESTRO CS,
       SINIESTRO SI,
       DETALLE_SINIESTRO DS,
       CONFIG_TRANSAC_SINIESTROS CTS,
       POLIZAS PP, 
       CATALOGO_DE_CONCEPTOS CDC,
       POLIZAS_TEXTO_COTIZACION  TXT,
       CATEGORIAS                CGO,
       CLIENTES                  CLI,
       ASEGURADO                 ASE
 WHERE CS.STSCOBERTURA = 'SOL'
   AND CS.FECRES >= DFECDESDE
   AND CS.FECRES <= DFECHASTA
  --
   AND SI.IDSINIESTRO = CS.IDSINIESTRO
   AND SI.CODCIA      = 1
   AND (SI.COD_MONEDA = DECODE(cCodMoneda,'%',SI.COD_MONEDA,cCodMoneda))
   --
   AND DS.IDSINIESTRO = CS.IDSINIESTRO
   AND (DS.IDTIPOSEG  = DECODE(cIdTipoSeg,'%',DS.IDTIPOSEG ,cIdTipoSeg))
   --
   AND CDC.CODCIA(+)      = 1
   AND CDC.CODCONCEPTO(+) = CS.CODCPTOTRANSAC
   --
   AND PP.IDPOLIZA    = SI.IDPOLIZA
   AND PP.CODCIA      = SI.CODCIA
   AND PP.CODEMPRESA  = SI.CODEMPRESA
   --
   AND CTS.CODCIA     = 1
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
--
--
--
BEGIN 
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
  -- 
  IF cFormato = 'TEXTO' THEN
     ---- // ENCABEZADO //
     nLinea := 1;
     cCadena     := 'THONA SEGUROS, S.A. de C.V.'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     
     nLinea := nLinea + 1;
     cCadena     := 'REPORTE DIARIO DE RESERVAS EN SOLICITUD';   
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
       
     nLinea  := nLinea + 1;
     cCadena := 'PERIODO DEL '||TO_CHAR(DFECDESDE,'DD')||' DE '||TO_CHAR(DFECDESDE,'Month')||' DE '||TO_CHAR(DFECDESDE,'YYYY')||' AL '||
                                TO_CHAR(DFECHASTA,'DD')||' DE '||TO_CHAR(DFECHASTA,'Month')||' DE '||TO_CHAR(DFECHASTA,'YYYY');
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
       
     nLinea  := nLinea + 1;
     cCadena := ' ';     
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     ---- // TITULOS //
     nLinea := nLinea + 1;
     cCadena     :=  'NUMERO POLIZA'            ||cLimitador||
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
                     'Estatus'                  ||cLimitador||
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
                     'Fecha de ingreso Asegurado'   ||cLimitador||
                     'Fecha de ingreso Contratante' ||cLimitador||
                     'Sexo'                     ||cLimitador||
                     'Tipo Asegurado';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  ELSE
     ---- // CADENA INICIAL DE HOJA //
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"' ||chr(10)||
       ' xmlns:x="urn:schemas-microsoft-com:office:excel"'       ||chr(10)||
       ' xmlns="http://www.w3.org/TR/REC-html40">'      ||chr(10)||
       ' <style id="libro">' ||chr(10)||
       '   <!--table'        ||chr(10)||
       '       {mso-displayed-decimal-separator:"\.";'  ||chr(10)||
       '        mso-displayed-thousand-separator:"\,";}'         ||chr(10)||
       '        .texto'      ||chr(10)||
       ' {mso-number-format:"\@";}'   ||chr(10)||
       '        .numero'     ||chr(10)||
       ' {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
       '        .fecha'      ||chr(10)||
       ' {mso-number-format:"dd\\/mm\\/yyyy";}'  ||chr(10)||
       '    -->'    ||chr(10)||
       ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); -- SPEEDFILE
     --  ENCABEZADOS
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. DE C.V.</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DIARIO DE RESERVAS EN SOLICITUD'|| '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>PERIODO DEL '||TO_CHAR(DFECDESDE,'DD')||' DE '||TO_CHAR(DFECDESDE,'MONTH')||' DE '||TO_CHAR(DFECDESDE,'YYYY')||' AL '||
                                        TO_CHAR(DFECHASTA,'DD')||' DE '||TO_CHAR(DFECHASTA,'MONTH')||' DE '||TO_CHAR(DFECHASTA,'YYYY')||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
           
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
    
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1><tr>'  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO POLIZA</font></th>'            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. POLIZA UNICO</font></th>'         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. SINIESTRO</font></th>'            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COBERTURA</font></th>'                ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE ASISTENCIA</font></th>'     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA MOVIMIENTO</font></th>'         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC HOSPITAL</font></th>'             ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CLAVE CIE10</font></th>'              ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCRIPCION DE CIE 10 </font></th>'   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCCORTAMOV</font></th>'             ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">INICIO VIGENCIA POLIZA</font></th>'   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FIN VIGENCIA POLIZA</font></th>'      ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO TRANSACCION</font></th>'       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TRANSACCION SINIESTROS</font></th>'   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CONCEPTO TRANSACCION</font></th>'     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCRIPCION CONCEPTO</font></th>'     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MOVTO RVA MON ORIG</font></th>'       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MOVTO RVA MON NAC</font></th>'        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">SALDO_RESERVA_ORIGINAL</font></th>'   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">SALDO_RESERVA_MN</font></th>'         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPC MON ORIGINAL</font></th>'         || 
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPC MON NAIONAL</font></th>'          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONEDA</font></th>'                   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE CAMBIO</font></th>'           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA OCURRENCIA</font></th>'         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA NOTIFICACION</font></th>'       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ESTATUS COBERTURA</font></th>'        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE ASEGURADO</font></th>'         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CODIGO DEL ASEGURADO</font></th>'     ;    --MLJS 21/12/2020       
     cCadenaAux  := '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCRIPCION DEL SINIESTRO</font></th>';    --MLJS 21/12/2020
     cCadenaAux1 := '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO SEGURO</font></th></th>'         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE_ARCH_CARGA</font></th>'        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE CARGA</font></th>'           ||      
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO</font></th>'                  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE DE ARCHIVO LOGEM</font></th>'  ||    -- ; MLJS 21/12/2020
     --cCadenaAux1 := '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Es Contributorio</font></th>'         ||  -- MLJS 21/12/2020
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Es Contributorio</font></th>'         ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Contributorio</font></th>'          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Giro de Negocio</font></th>'          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de Negocio</font></th>'          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fuente de Recursos</font></th>'       ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Paquete Comercial</font></th>'        ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Categoria</font></th>'                ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Canal de Venta</font></th>'           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA CONTABLE</font></th>'          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CONTRATANTE</font></th>'              ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">EMPRESA LABORA</font></th>'           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CERTIFICADO</font></th>'              ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CREDITO</font></th>'                  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC ASEGURADO</font></th>'            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA INGRESO ASEGURADO</font></th>'   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA INGRESO CONTRATANTE</font></th>' ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">SEXO</font></th>'                     ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO ASEGURADO</font></th>';
     -- 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     OC_ARCHIVO.Escribir_Linea(cCadenaAux, cCodUser, nLinea); --MLJS 21/12/2020
     OC_ARCHIVO.Escribir_Linea(cCadenaAux1, cCodUser, nLinea);
  END IF;
  -- CARGA DE INFORMACIÓN 
  FOR X IN ESTIMADOS_Q LOOP
      IF cUsuario = '%' THEN
         --
         nIdSiniestro := X.IdSiniestro;
         --
         BEGIN
           SELECT TO_CHAR(PMS.Crga_FechaComp,'DD/MM/YYYY HH24:MI:SS'), 
                  PMS.Crga_Nom_Archivo,
                  PMS.Emi_TipoProceso, 
                  DPS.FecSts, 
                  DPS.Campo1,
                  NVL(DPS.Campo4,X.Desc_Sini),
                  DECODE(PMS.Crga_Nom_Archivo,NULL,'Registro Manual',
                         NVL(DPS.Campo85,'Sin Archio LOGEM'))  
             INTO dFecCarga1A, 
                  cNomArchCarga1A, 
                  cEmiTipoProceso, 
                  dFecCarga, 
                  cRFCHospital,
                  cDescSiniestro, 
                  cNomArchCarga
             FROM PROCESOS_MASIVOS_SEGUIMIENTO PMS,DATOS_PART_SINIESTROS DPS
            WHERE PMS.Crga_Cod_Proceso IN('ESTSIN','AURVAD','DIRVAD')
              AND TRUNC(PMS.Crga_Fecha)  BETWEEN dFecDesde AND dFecHasta 
              AND PMS.Emi_StsRegProceso  = 'EMI'
              AND PMS.IdSiniestro        = X.IdSiniestro
              AND PMS.IdPoliza  = X.IdPoliza
              AND PMS.Cod_Asegurado      = X.Cod_Asegurado
              AND PMS.IdProcMasivo       = DPS.IdProcMasivo
              AND PMS.IDTRANSACCION      = X.IDTRANSACCION;
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
         	 SELECT TIPODIARIO||'-'||NUMCOMPROBSC
         	 INTO   cPolizaCont
           FROM   COMPROBANTES_CONTABLES CC
           WHERE  NUMTRANSACCION = X.NUMTRX;
         EXCEPTION
         	  WHEN NO_DATA_FOUND THEN
         	     cPolizaCont := 'SIN POLIZA CONT';
         	  WHEN OTHERS THEN
         	     cPolizaCont := 'SIN POLIZA CONT';   
         END;
         
         --MLJS 08/10/2020 SE OBTIENE LA PÓLIZA CONTABLE
         --
         IF cFormato = 'TEXTO' THEN
            cCadena :=  X.IDPOLIZA                   ||cLimitador||
            X.POLUNIK                                ||cLimitador||     
            X.IDSINIESTRO                            ||cLimitador||
            X.CVCOB                                  ||cLimitador||
            X.NUMSINIREF                             ||cLimitador||
            TO_CHAR(X.FECHAMVTO,'DD/MM/RRRR')        ||cLimitador||  
            cRFCHospital                             ||cLimitador||
            X.CVE_CIE_10                             ||cLimitador||
            X.DESC_CIE_10                            ||cLimitador||
            X.DESCCORTAMOV                           ||cLimitador||
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
            X.COD_ASEGURADO                          ||cLimitador;     -- MLJS 21/12/2020
cCadenaAux  := cDescSiniestro                        ||cLimitador;     -- MLJS 21/12/2020
cCadenaAux1 := X.TIPOSEGURO                          ||cLimitador||
            cNomArchCarga1A                          ||cLimitador||
            dFecCarga1A                              ||cLimitador||
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
            X.NOMCONTRATANTE                         ||cLimitador|| 
            X.EMPRESA_LABORA                         ||cLimitador|| 
            X.CERTIFICADO                            ||cLimitador|| 
            X.IDCREDITO                              ||cLimitador|| 
            X.RFC_ASEGURADO                          ||cLimitador|| 
            X.FE_INGRE_CONTRA                        ||cLimitador|| 
            X.FE_INGRE_ASEGU                         ||cLimitador|| 
            X.SEXO                                   ||cLimitador|| 
            X.TP_ASEGURADO                           ||CHR(13);
         ELSE
            cCadena := '<tr>'                                || 
            OC_ARCHIVO.CAMPO_HTML(X.IDPOLIZA           ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.POLUNIK            ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.IDSINIESTRO        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CVCOB              ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NUMSINIREF         ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FECHAMVTO,'DD/MM/RRRR'),'D') ||
            OC_ARCHIVO.CAMPO_HTML(cRFCHospital         ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CVE_CIE_10         ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.DESC_CIE_10        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.DESCCORTAMOV       ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FECINIVIG,'DD/MM/RRRR'),'D') ||
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FECFINVIG,'DD/MM/RRRR'),'D') ||
            OC_ARCHIVO.CAMPO_HTML(X.NUMTRX             ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CVETRX             ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CPTOTRX            ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.DESCCPTOTRX        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(nMontoRvaMon         ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(nMontoRvaLoc         ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(X.MONTO_RESERVA_MONEDA ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(X.MONTO_RESERVA_LOCAL  ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(X.OPC_MONEDA         ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(X.OPC_LOCAL          ,'N') ||
            OC_ARCHIVO.CAMPO_HTML(X.MONEDA             ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nTipoCambio,'999.000000') ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_OCURRENCIA,'DD/MM/RRRR'),'D') ||    
            OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_NOTIFICACION,'DD/MM/RRRR'),'D') ||
            OC_ARCHIVO.CAMPO_HTML(X.STSCOBERTURA       ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOM_ASEG           ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.COD_ASEGURADO      ,'C') ;  -- MLJS 21/12/2020
   cCadenaAux := OC_ARCHIVO.CAMPO_HTML(cDescSiniestro  ,'C') ;  -- MLJS 21/12/2020
  cCadenaAux1 := OC_ARCHIVO.CAMPO_HTML(X.TIPOSEGURO    ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(cNomArchCarga1A      ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(dFecCarga1A          ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.USUARIO            ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(cNomArchCarga        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.ESCONTRIBUTORIO    ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.PORCENCONTRIBUTORIO,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.GIRONEGOCIO        ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.TIPONEGOCIO        ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.FUENTERECURSOS     ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CODPAQCOMERCIAL    ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CATEGORIA          ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CANALFORMAVENTA    ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(cPolizaCont          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOMCONTRATANTE     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.EMPRESA_LABORA     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CERTIFICADO        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.IDCREDITO          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.RFC_ASEGURADO      ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.FE_INGRE_CONTRA    ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.FE_INGRE_ASEGU     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.SEXO               ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.TP_ASEGURADO       ,'C') ||
            '</tr>';
         END IF;
         --  
         nLinea := nLinea + 1;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);   
         OC_ARCHIVO.Escribir_Linea(cCadenaAux , cCodUser, nLinea); -- MLJS 21/12/2020
         OC_ARCHIVO.Escribir_Linea(cCadenaAux1, cCodUser, nLinea); -- MLJS 21/12/2020
      ELSIF cUsuario != '%' AND X.USUARIO = cUsuario THEN
         nIdSiniestro := X.IdSiniestro;
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
         --
         IF cFormato = 'TEXTO' THEN
            cCadena :=  X.IDPOLIZA ||cLimitador||
            X.POLUNIK              ||cLimitador||     
            X.IDSINIESTRO          ||cLimitador||
            X.CVCOB                ||cLimitador||
            X.NUMSINIREF           ||cLimitador||
            X.FECHAMVTO            ||cLimitador||
            cRFCHospital           ||cLimitador||
            X.CVE_CIE_10           ||cLimitador||
            X.DESC_CIE_10          ||cLimitador||
            X.DESCCORTAMOV         ||cLimitador||
            X.FECINIVIG            ||cLimitador||
            X.FECFINVIG            ||cLimitador||
            X.NUMTRX               ||cLimitador||
            X.CVETRX               ||cLimitador||
            X.CPTOTRX              ||cLimitador||
            X.DESCCPTOTRX          ||cLimitador||
            nMontoRvaMon           ||cLimitador||
            nMontoRvaLoc           ||cLimitador||
            X.MONTO_RESERVA_MONEDA ||cLimitador||
            X.MONTO_RESERVA_LOCAL  ||cLimitador||
            X.OPC_MONEDA           ||cLimitador||
            X.OPC_LOCAL            ||cLimitador||
            X.MONEDA               ||cLimitador||
            nTipoCambio            ||cLimitador||
            X.FEC_OCURRENCIA       ||cLimitador||
            X.FEC_NOTIFICACION     ||cLimitador||
            X.STSCOBERTURA         ||cLimitador||
            X.NOM_ASEG             ||cLimitador||
            X.COD_ASEGURADO        ||cLimitador;       -- MLJS 21/12/2020
 cCadenaAux := cDescSiniestro      ||cLimitador;       -- MLJS 21/12/2020
 cCadenaAux1:= X.TIPOSEGURO        ||cLimitador||      -- MLJS 21/12/2020
            cNomArchCarga1A        ||cLimitador||
            dFecCarga1A            ||cLimitador||
            X.USUARIO              ||cLimitador||
            cNomArchCarga          ||cLimitador||
            X.ESCONTRIBUTORIO      ||cLimitador||
            X.PORCENCONTRIBUTORIO  ||cLimitador||
            X.GIRONEGOCIO          ||cLimitador||
            X.TIPONEGOCIO          ||cLimitador||
            X.FUENTERECURSOS       ||cLimitador||
            X.CODPAQCOMERCIAL      ||cLimitador||
            X.CATEGORIA            ||cLimitador||
            X.CANALFORMAVENTA      ||cLimitador||
            cPolizaCont                              ||cLimitador|| 
            X.NOMCONTRATANTE                         ||cLimitador|| 
            X.EMPRESA_LABORA                         ||cLimitador|| 
            X.CERTIFICADO                            ||cLimitador|| 
            X.IDCREDITO                              ||cLimitador|| 
            X.RFC_ASEGURADO                          ||cLimitador|| 
            X.FE_INGRE_CONTRA                        ||cLimitador|| 
            X.FE_INGRE_ASEGU                         ||cLimitador|| 
            X.SEXO                                   ||cLimitador|| 
            X.TP_ASEGURADO                           ||CHR(13);
          
     ELSE
        cCadena := '<tr>'                                  || 
          OC_ARCHIVO.CAMPO_HTML(X.IDPOLIZA           ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.POLUNIK            ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.IDSINIESTRO        ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.CVCOB              ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.NUMSINIREF         ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.FECHAMVTO          ,'D') ||
          OC_ARCHIVO.CAMPO_HTML(cRFCHospital         ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.CVE_CIE_10         ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.DESC_CIE_10        ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.DESCCORTAMOV       ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.FECINIVIG          ,'D') ||
          OC_ARCHIVO.CAMPO_HTML(X.FECFINVIG          ,'D') ||
          OC_ARCHIVO.CAMPO_HTML(X.NUMTRX             ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.CVETRX             ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.CPTOTRX            ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.DESCCPTOTRX        ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(nMontoRvaMon         ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(nMontoRvaLoc         ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(X.MONTO_RESERVA_MONEDA ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(X.MONTO_RESERVA_LOCAL  ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(X.OPC_MONEDA         ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(X.OPC_LOCAL          ,'N') ||
          OC_ARCHIVO.CAMPO_HTML(X.MONEDA             ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nTipoCambio,'999.000000') ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.FEC_OCURRENCIA     ,'D') ||    
          OC_ARCHIVO.CAMPO_HTML(X.FEC_NOTIFICACION   ,'D') ||
          OC_ARCHIVO.CAMPO_HTML(X.STSCOBERTURA       ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.NOM_ASEG           ,'C') ||
          OC_ARCHIVO.CAMPO_HTML(X.COD_ASEGURADO      ,'C') ;       -- MLJS 21/12/2020
 cCadenaAux := OC_ARCHIVO.CAMPO_HTML(cDescSiniestro    ,'C');   -- MLJS 21/12/2020
 cCadenaAux1:= OC_ARCHIVO.CAMPO_HTML(X.TIPOSEGURO      ,'C') || -- MLJS 21/12/2020
            OC_ARCHIVO.CAMPO_HTML(cNomArchCarga1A      ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(dFecCarga1A          ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.USUARIO            ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(cNomArchCarga        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.ESCONTRIBUTORIO    ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.PORCENCONTRIBUTORIO,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.GIRONEGOCIO        ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.TIPONEGOCIO        ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.FUENTERECURSOS     ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CODPAQCOMERCIAL    ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CATEGORIA          ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(X.CANALFORMAVENTA    ,'C') || 
            OC_ARCHIVO.CAMPO_HTML(cPolizaCont          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.NOMCONTRATANTE     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.EMPRESA_LABORA     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.CERTIFICADO        ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.IDCREDITO          ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.RFC_ASEGURADO      ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.FE_INGRE_CONTRA    ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.FE_INGRE_ASEGU     ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.SEXO               ,'C') ||
            OC_ARCHIVO.CAMPO_HTML(X.TP_ASEGURADO       ,'C') ||
            '</tr>';     END IF;
     nLinea := nLinea + 1;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     OC_ARCHIVO.Escribir_Linea(cCadenaAux, cCodUser, nLinea);    -- MLJS 21/12/2020  
     OC_ARCHIVO.Escribir_Linea(cCadenaAux1, cCodUser, nLinea);   -- MLJS 21/12/2020  
   END IF;
  END LOOP;
  IF cFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
      --cCadena := '</table></div></html>';
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE   
  END IF;
   OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
  
EXCEPTION 
     WHEN OTHERS THEN 
 OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
 raise_application_error(-20105,'Error en Generación Reporte Estimados de Siniestros: '|| SQLERRM|| ' Siniestro: '||nIdSiniestro);  
 
END;
PROCEDURE GENERAR_LAYOUT_RES_SOLICITUD(cNomArchivo VARCHAR2, 
                                            DFECDESDE DATE,
                                            DFECHASTA DATE,
                                            CTIPO_MOVTO VARCHAR2,
                                   cFormat    VARCHAR2,
                                   nIdReporte  NUMBER) IS
cLimitador   VARCHAR2(1) :=',';
nLinea       NUMBER;
cCadena      VARCHAR2(4000);
cCadenaAux   VARCHAR2(4000);
cCadenaAux1  VARCHAR2(4000);
cCodUser     VARCHAR2(30);
nDummy       NUMBER;
cCopy        BOOLEAN;
cFormato     VARCHAR2(30);
--
nIdSiniestro     SINIESTRO.IDSINIESTRO%TYPE;
nTipoCambio      TASAS_CAMBIO.TASA_CAMBIO%TYPE; 
nMontoRvaMon     COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc     COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;
--
--ARCHIVO_SALIDA    CLIENT_TEXT_IO.FILE_TYPE; -- SPEEDFILE
LINEA_SALIDA      VARCHAR2(5000);  -- SPEEDFILE
WI_ARCHIVO_SALIDA VARCHAR2(2000);  -- SPEEDFILE 
--
dFecCarga1A       VARCHAR2(50);
cNomArchCarga1A   PROCESOS_MASIVOS_SEGUIMIENTO.CRGA_NOM_ARCHIVO%TYPE;
cEmiTipoProceso   PROCESOS_MASIVOS_SEGUIMIENTO.EMI_TIPOPROCESO%TYPE;
dFecCarga         DATOS_PART_SINIESTROS.FecSts%TYPE;
cRFCHospital      DATOS_PART_SINIESTROS.Campo1%TYPE;
cDescSiniestro    SINIESTRO.Desc_Siniestro%TYPE;
cNomArchCarga     PROCESOS_MASIVOS_SEGUIMIENTO.CRGA_NOM_ARCHIVO%TYPE;
--
cPolizaCont       VARCHAR(50);
--
CURSOR LAYOUT IS
SELECT A.IDSINIESTRO,
       DSA.IDDETSIN,
       CS.CODCOBERT,
       CS.CODCPTOTRANSAC,
       CS.MONTO_RESERVADO_MONEDA,
       'C' COLIND,
       CTIPO_MOVTO,
       CS.NUMMOD,
       'MASIVOS SOLICITUD RESER,' DESCRIPCION
  FROM SINIESTRO A,  --13
       DETALLE_SINIESTRO_ASEG DSA,
       COBERTURA_SINIESTRO_ASEG CS,
       COBERT_ACT_ASEG CA
  WHERE A.IDSINIESTRO > 0
    --
    AND DSA.IDSINIESTRO = A.IDSINIESTRO
    --
    AND CS.IDSINIESTRO   = A.IDSINIESTRO
    AND CS.COD_ASEGURADO = A.COD_ASEGURADO
    AND CS.IDPOLIZA      = A.IDPOLIZA
    AND CS.STSCOBERTURA  = 'SOL'
    AND CS.FECRES        BETWEEN DFECDESDE AND DFECHASTA
    --
    AND CA.IDPOLIZA = A.IDPOLIZA
    AND CA.IDETPOL  = A.IDETPOL
    AND CA.COD_ASEGURADO = A.COD_ASEGURADO
    AND CA.CODCOBERT = CS.CODCOBERT
--
UNION
--
SELECT A.IDSINIESTRO,
       DSA.IDDETSIN,
       CS.CODCOBERT,
       CS.CODCPTOTRANSAC,
       CS.MONTO_RESERVADO_MONEDA,
       'I' COLIND,
       CTIPO_MOVTO,
       CS.NUMMOD,
       'MASIVOS SOLICITUD RESER,' DESCRIPCION
  FROM SINIESTRO A,  
       DETALLE_SINIESTRO DSA,
       COBERTURA_SINIESTRO CS,
       COBERT_ACT CA
  WHERE A.IDSINIESTRO > 0
    --
    AND DSA.IDSINIESTRO = A.IDSINIESTRO
    --
    AND CS.IDSINIESTRO   = A.IDSINIESTRO
    AND CS.COD_ASEGURADO = A.COD_ASEGURADO
    AND CS.IDPOLIZA      = A.IDPOLIZA
    AND CS.STSCOBERTURA  = 'SOL'
    AND CS.FECRES        BETWEEN DFECDESDE AND DFECHASTA
    --
    AND CA.IDPOLIZA = A.IDPOLIZA
    AND CA.IDETPOL  = A.IDETPOL
    AND CA.COD_ASEGURADO = A.COD_ASEGURADO
    AND CA.CODCOBERT = CS.CODCOBERT
  ORDER BY 1
;
--
--
--
BEGIN 
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
  -- 
  -- CARGA DE INFORMACIÓN 
  --
  cFORMATO := 'TEXTO';
  nLinea := 0;
  FOR X IN LAYOUT LOOP
         IF cFormato = 'TEXTO' THEN
            cCadena := X.IDSINIESTRO             ||cLimitador||
                       X.IDDETSIN                ||cLimitador|| 
                       X.CODCOBERT               ||cLimitador|| 
                       X.CODCPTOTRANSAC          ||cLimitador|| 
                       X.MONTO_RESERVADO_MONEDA  ||cLimitador|| 
                       X.COLIND                  ||cLimitador|| 
                       X.CTIPO_MOVTO             ||cLimitador|| 
                       X.NUMMOD                  ||cLimitador|| 
                       X.DESCRIPCION             ||CHR(13);
         END IF;
         --  
         nLinea := nLinea + 1;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);   
  END LOOP;
  OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
 EXCEPTION 
     WHEN OTHERS THEN 
 OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
 raise_application_error(-20105,'Error en Generación Reporte Estimados de Siniestros: '|| SQLERRM|| ' Siniestro: '||nIdSiniestro);  
 
END;
PROCEDURE GENERAR_PAGOSSIN_CIERRE(cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cCodMoneda VARCHAR2, 
                                  dFecDesde DATE, dFecHasta DATE, cTipoPago IN VARCHAR2,
                                  cusuario varchar2,cFormato    VARCHAR2,nIdReporte  NUMBER) IS
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
nCodCia            POLIZAS.codcia%TYPE;
nCodEmpresa        DETALLE_POLIZA.CodEmpresa%TYPE;
cCodPlantilla      CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE := 'EMITESINIESTRO';
--ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;
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
cNomArchCarga			 VARCHAR2(100);
cNomArchLogem			 VARCHAR2(100);
dFecCarga					 DATE;
cUUID						   FACTURA_EXTERNA.UUID%TYPE;
nIdProcMasivo			 PROCESOS_MASIVOS_SEGUIMIENTO.IDPROCMASIVO%TYPE;	
nMontoNetoLocal		 NUMBER(28,2);
nMontoNetoMoneda	 NUMBER(28,2);	 			 	 			 
nMontoHonoLocal		 NUMBER(28,2);
nMontoHonoMoneda	 NUMBER(28,2);
nMontoHospLocal		 NUMBER(28,2);
nMontoHospMoneda	 NUMBER(28,2);
nMontoOtrGtoLocal	 NUMBER(28,2);
nMontoOtrGtoMoneda NUMBER(28,2);
nMontoDctoLocal		 NUMBER(28,2);
nMontoDctoMoneda	 NUMBER(28,2);
nMontoDeducLocal	 NUMBER(28,2);
nMontoDeducMoneda	 NUMBER(28,2);
--
cPolizaCont        VARCHAR2(50);
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
CURSOR PAGOSSIN_Q IS
  SELECT  UNIQUE(T.IdTransaccion), 
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
   WHERE T.CodCia                  = 1
     AND T.CodEmpresa              = 1
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
UNION all
--
  SELECT
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
          TO_CHAR(PMS.Crga_FechaComp,'DD/MM/YYYY HH24:MI:SS') FecCarga,
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
    WHERE T.CodCia                  = 1
      AND T.CodEmpresa              = 1
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
      AND PMS.CodCia           (+) = 1
      AND PMS.CodEmpresa       (+) = 1
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
          TO_CHAR(PMS.Crga_FechaComp,'DD/MM/YYYY HH24:MI:SS'),-- FecCarga,
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
          DAA.IDDETAPROB;
/*     ORDER BY 6, 4, 8, 7, 74  --  JICO AGREGAD0
;*/
--
CURSOR PAGO_Q  IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.CodCia       = nCodCia
      AND C.NomTabla     = 'DATOS_PART_SINIESTROS'
      AND C.IndDatoPart  = 'S'
    ORDER BY OrdenDatoPart,OrdenCampo;
BEGIN
	--
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
  --
  IF cFormato = 'TEXTO' THEN
      nLinea := 1;
      cCadena     := 'THONA SEGUROS, S.A. de C.V.' || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);          
      nLinea := nLinea + 1;
      cCadena     := 'REPORTE DIARIO DE PAGOS' || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);       
      nLinea  := nLinea + 1;
      cCadena := 'PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' AL ' || TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecDesde,'Month') ||
                 ' DE ' || TO_CHAR(dFecDesde,'YYYY') || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);         
      nLinea  := nLinea + 1;
      cCadena := ' ' || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);         
      nLinea  := nLinea + 1;
      cCadena := 'NUMERO POLIZA'          ||cLimitador||
                 'NO. POLIZA UNICO'       ||cLimitador||
                 'NÚMERO DE REFERENCIA'   ||cLimitador||
                 'NO. SINIESTRO'          ||cLimitador||
                 'COBERTURA'              ||cLimitador||
                 'FECHA MOVIMIENTO'       ||cLimitador||
                 'NO. APROB.'             ||cLimitador||
                 'TIPO APROBACION'        ||cLimitador||
                 'ESTATUS'                ||cLimitador||
                 'TRANSACCION'            ||cLimitador||
                 'DESCRIPCION TRANSACCION'||cLimitador||
                 'CONCEPTO'               ||cLimitador||
                 'NUMERO DE TRANSACCION'  ||cLimitador||
                 'FECHA ESTIMACION'       ||cLimitador||
                 'MONEDA'                 ||cLimitador||
                 'TIPO DE CAMBIO'         ||cLimitador||
                 'PAGO MON ORIGINAL'      ||cLimitador||
                 'PAGO MON NACIONAL'      ||cLimitador||
                 'IVA MON ORIGINAL'       ||cLimitador||
                 'IVA MON NACIONAL'       ||cLimitador||
                 'ISR RET MON ORIGINAL'   ||cLimitador||
                 'ISR RET MON NACIONAL'   ||cLimitador||
                 'IVA RET MON ORIGINAL'   ||cLimitador||
                 'IVA RET MON NACIONAL'   ||cLimitador||
                 'PAGO NETO MON ORIGINAL' ||cLimitador||
                 'PAGO NETO MON NACIONAL' ||cLimitador||
                 'OPC MON ORIGINAL'       ||cLimitador||
                 'OPC MON NACIONAL'       ||cLimitador||
                 'BANCO'                  ||cLimitador||
                 'NUM CHEQUE O CUENTA CLABE'||cLimitador||
                 'OPERO'                  ||cLimitador||
                 'TASA IVA'               ||cLimitador||
                 'COD. ASEGURADO'         ||cLimitador||
                 'BENEFICIARIO'           ||cLimitador||
                 'RFC BENEFICIARIO'       ||cLimitador||
                 'NOMBRE_ARCH_CARGA'      ||cLimitador|| 
                 'NOMBRE ARCHIVO LOGEM'   ||cLimitador||
                 'FECHA DE CARGA'         ||cLimitador||
                 'TIPO DE SEGURO'         ||cLimitador|| 
                 'NUMERO DE FACTURA'      ||cLimitador||
                 'ID CARGA MASIVA'        ||cLimitador||
                 'POLIZA CONTABLE PGO GG' ||cLimitador||
                 'FECHA DE PAGO GG'       ||cLimitador||
                 'IMPORTE DEL PAGO'       ||cLimitador|| 
                 'ARCHIVO PGO-GG'         ||cLimitador|| 
                 'USUARIO CARGA PGO-GG'   ||cLimitador|| 
                 'FECHA - HORA DE CARGA'  ||cLimitador||
                 'OBSERVACIONES POLIZA GG'||cLimitador||
                 'MONTO DE PAGO'          ||cLimitador||
					       'Es Contributorio'       ||cLimitador||
					       '% Contributorio'        ||cLimitador||
					       'Giro de Negocio'        ||cLimitador||
					       'Tipo de Negocio'        ||cLimitador||
					       'Fuente de Recursos'     ||cLimitador||
					       'Paquete Comercial'      ||cLimitador||
					       'Categoria'              ||cLimitador||
					       'Canal de Venta'         ||cLimitador||
					       'POLIZA_CONT';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);         
  ELSE
      nLinea  := 1;
      cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                 ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                 ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                 ' <style id="libro">'||chr(10)||
                 '   <!--table'||chr(10)||
                 '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                 '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                 '        .texto'||chr(10)||
                 '          {mso-number-format:"\@";}'||chr(10)||
                 '        .numero'||chr(10)||
                 '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                 '        .fecha'||chr(10)||
                 '          {mso-number-format:"dd\\/mm\\/yyyy";}'||chr(10)||
                 '    -->'||chr(10)||
                 ' </style><div id="libro">'||chr(10);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);         
      nLinea  := nLinea + 1;
      cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);          
      nLinea  := nLinea + 1;
      cCadena := '<tr><th>REPORTE DIARIO DE PAGOS'||'</th></tr>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);        
      nLinea  := nLinea + 1;
      cCadena := '<tr><th>PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE ' || TO_CHAR(dFecDesde,'MONTH') || ' AL ' ||
                 TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecDesde,'MONTH') || ' DE ' || TO_CHAR(dFecDesde,'YYYY') || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);                   
      nLinea  := nLinea + 1;
      cCadena := '<tr><th>  </th></tr></table>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);         
      nLinea  := nLinea + 1;
      cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO POLIZA</font></th>' ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. POLIZA UNICO</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NÚMERO DE REFERENCIA</font></th>'		 						||                
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. SINIESTRO</font></th>' 											||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COBERTURA</font></th>' 													||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA MOVIMIENTO</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. APROB.</font></th>' 													||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO APROBACION</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ESTATUS</font></th>' 														||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TRANSACCION</font></th>' 												||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCRIPCION TRANSACCION</font></th>' 						||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CONCEPTO</font></th>' 														||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE TRANSACCION</font></th>' 							||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA ESTIMACION</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONEDA</font></th>' 															||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE CAMBIO</font></th>' 											||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO MON ORIGINAL</font></th>' 									||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO MON NACIONAL</font></th>' 									||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">GASTOS HONORARIOS ORIGINAL</font></th>' 					||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">GASTOS HONORARIOS NACIONAL</font></th>' 					||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">GASTOS HOSPITALARIOS ORIGINAL</font></th>' 			||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">GASTOS HOSPITALARIOS NACIONAL</font></th>' 			||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OTROS GASTOS ORIGINAL</font></th>' 							||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OTROS GASTOS NACIONAL</font></th>' 							||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCUENTO ORIGINAL</font></th>' 									||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCUENTO NACIONAL</font></th>' 									||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DEDUCIBLE ORIGINAL</font></th>' 									||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DEDUCIBLE NACIONAL</font></th>' 									||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA MON ORIGINAL</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA MON NACIONAL</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ISR RET MON ORIGINAL</font></th>' 								||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ISR RET MON NACIONAL</font></th>' 								||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA RET MON ORIGINAL</font></th>' 								||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA RET MON NACIONAL</font></th>' 								||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IMP LOCAL RET ORIGINAL</font></th>' 							||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IMP LOCAL RET NACIONAL</font></th>' 							||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO NETO MON ORIGINAL</font></th>' 							||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO NETO MON NACIONAL</font></th>' 							||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPC MON ORIGINAL</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPC MON NACIONAL</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">BANCO</font></th>' 															||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUM CHEQUE O CUENTA CLABE</font></th>' 					||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPERO</font></th>' 															||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TASA IVA</font></th>' 														||                 
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COD ASEGURADO</font></th>'; 
      cCadenaAux:= 
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">BENEFICIARIO</font></th>' 												||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC BENEFICIARIO</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE_ARCH_CARGA</font></th>' 									||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE ARCHIVO LOGEM</font></th>' 								||                
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE CARGA</font></th>' 											||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE SEGURO</font></th>' 											||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE FACTURA</font></th>' 									||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ID CARGA MASIVA</font></th>'											||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA CONTABLE PGO GG</font></th>'							||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE PAGO GG</font></th>'										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IMPORTE DEL PAGO</font></th>'										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ARCHIVO PGO-GG</font></th>'											||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO CARGA PGO-GG</font></th>'								||                
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA - HORA DE CARGA</font></th>'								||               
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OBSERVACIONES POLIZA GG</font></th>'							||                 
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE PAGO</font></th></th>'                  ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Es Contributorio 1</font></th>'                  ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Contributorio</font></th>'                     ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Giro de Negocio</font></th>'                     ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de Negocio</font></th>'                     ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fuente de Recursos</font></th>'                  ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Paquete Comercial</font></th>'                   ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Categoria</font></th>'                           ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Canal de Venta</font></th>'                      ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA_CONT</font></th>';
      --
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);        
      OC_ARCHIVO.Escribir_Linea(cCadenaAux, cCodUser, nLinea);
      --        
  END IF;
  -- 
  WIDSINIESTRO         := 0; --  JICO AGREGAD0
  WNUM_APROBACION      := 0; --  JICO AGREGAD0
  W_PAGO_NETO_MON_LOC  := 0; --  JICO AGREGAD0
  W_PAGO_NETO_MON_MON  := 0; --  JICO AGREGAD0
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
         NVO_MNTO_PAGADO_LOC := X.PGO_MON_ORIG	    * - 1;
         NVO_MNTO_PAGADO_MON := X.PGO_MON_NAC	      * - 1;
		     cValorCampoIVA      := X.IVA_MONEDA 		  	* - 1;
         cValorCampoISR      := X.ISR_MONEDA 	  		* - 1;
         nMontoNetoLocal     := X.PAGO_NETO_MON_LOC * - 1;
         nMontoNetoMoneda    := X.PGO_NETO_MON_ORIG * - 1;
         nMontoHonoLocal     := X.Gto_Hon_Local 		* - 1;
		     nMontoHonoMoneda    := X.Gto_Hon_Moneda   	* - 1;
		     nMontoHospLocal     := X.Gto_Hos_Local 		* - 1;
		     nMontoHospMoneda    := X.Gto_Hos_Moneda  	* - 1;
		     nMontoOtrGtoLocal   := X.Gto_Otr_Local 		* - 1;
		     nMontoOtrGtoMoneda  := X.Gto_Otr_Moneda	 	* - 1;
		     nMontoDctoLocal     := X.Dcto_Local				* - 1;
		     nMontoDctoMoneda    := X.Dcto_Moneda	  		* - 1;
		     nMontoDeducLocal    := X.Deduc_Local		  	* - 1;
		     nMontoDeducMoneda   := X.Deduc_Moneda			* - 1;
         nIVA_RET_MONEDA     := X.IVA_RET_MONEDA		* - 1;
         nIVA_RET_LOCAL      := X.IVA_RET_LOCAL			* - 1;
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
      				 RTRIM(LTRIM(reporte_siniestros.VALOR_CAMPO(Crga_RegDatosProc,27,','))),Crga_Fecha,
      				 LTRIM(reporte_siniestros.VALOR_CAMPO(Crga_RegDatosProc,9,','))
					INTO nIdProcMasivo,cNomArchCarga,
							 cNomArchLogem,dFecCarga,cUUID
		      FROM PROCESOS_MASIVOS_SEGUIMIENTO PMS
			   WHERE IdSiniestro 		  = X.IdSiniestro
			     AND IdPoliza    			= X.IdPoliza
			     AND Crga_Cod_Proceso = 'PAGSIN'
			     AND Num_Aprobacion   = X.Num_Aprobacion;
      EXCEPTION
      	WHEN NO_DATA_FOUND THEN
      		nIdProcMasivo := NULL;
      		cNomArchCarga := NULL;
				  cNomArchLogem := NULL;
				  dFecCarga			:= NULL;
				  cUUID					:= NULL;
        WHEN TOO_MANY_ROWS THEN
        	nIdProcMasivo := NULL;
      		cNomArchCarga := NULL;
				  cNomArchLogem := NULL;
				  dFecCarga			:= NULL;
				  cUUID					:= NULL;
      END;
      --MLJS 08/10/2020 SE OBTIENE LA PÓLIZA CONTABLE
      BEGIN
      	SELECT TIPODIARIO||'-'||NUMCOMPROBSC
          INTO cPolizaCont
          FROM COMPROBANTES_CONTABLES CC
         WHERE NUMTRANSACCION = X.NUMTRX;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
       	     cPolizaCont := 'SIN POLIZA CONT';
        WHEN OTHERS THEN
       	     cPolizaCont := 'SIN POLIZA CONT';   
      END;
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
  	  END IF;    --  JICO AGREGAD0
  	  --      
      IF cFormato = 'TEXTO' THEN
         cCadena := X.IDPOLIZA 													||cLimitador||						
                    X.POLUNIK														||cLimitador||
                    X.NUMSINIREF        								||cLimitador||
                    X.IDSINIESTRO												||cLimitador||
                    X.COD_PAGO													||cLimitador||
                    X.cFechaMvto				  							||cLimitador||
                    X.NUM_APROBACION										||cLimitador||
                    X.TIPO_APROBACION										||cLimitador||
                    X.ESTATUS					  								||cLimitador||
                    X.CODTRANSAC												||cLimitador||
                    X.DESCTRANSAC			  								||cLimitador||
                    X.CODCPTOTRANSAC										||cLimitador||
                    X.NUMTRX														||cLimitador||
                    dFecRes             								||cLimitador||
                    X.COD_MONEDA												||cLimitador||
                    nTipoCambio 												||cLimitador||
                    NVO_MNTO_PAGADO_MON     						||cLimitador||
                    NVO_MNTO_PAGADO_LOC     						||cLimitador||
                    X.IVA_Moneda												||cLimitador||
                    X.IVA_Local													||cLimitador||
                    X.ISR_Moneda												||cLimitador||
                    X.ISR_Local													||cLimitador||
                    X.IVA_RET_MONEDA    								||cLimitador||
                    X.IVA_RET_LOCAL											||cLimitador||
                    W_PAGO_NETO_MON_MON 								||cLimitador||
                    W_PAGO_NETO_MON_LOC									||cLimitador||
                    X.OPC_MONEDA												||cLimitador||						
                    X.OPC_LOCAL													||cLimitador||
                    cDescBanco													||cLimitador||
                    cCuentaCheque   										||cLimitador||
                    X.USUARIO														||cLimitador||
                    nIVAPorcentaje											||cLimitador||
                    X.ASEGURADO         								||cLimitador||
                    cNombreBenef   											||cLimitador||
                    cNumDocTributario										||cLimitador||
                    NVL(X.NomArchCarga,cNomArchCarga)   ||cLimitador||
                    NVL(X.ARCHIVO_LOGEM,cNomArchLogem)  ||cLimitador||
                    NVL(X.FecCarga,dFecCarga)  					||cLimitador||
                    X.TIPOSEGURO        								||cLimitador||
                    NVL(X.NUMERO_FACTURA,cUUID)    			||cLimitador||
                    NVL(X.IDPROCMASIVO,nIdProcMasivo)   ||cLimitador||
                    X.POLCONTA_GG       								||cLimitador||
                    X.FECHA_PAGO        								||cLimitador||
                    X.IMPORT_PAGO       								||cLimitador||
                    X.ARCHIVO_GG        								||cLimitador||
                    X.PGOGG_USUARIO     								||cLimitador||
                    X.PGOGG_FECHACOMP   								||cLimitador||
                    X.OBSERVACION_GG    								||cLimitador||
                    X.WMONTO                            ||cLimitador||
                    X.ESCONTRIBUTORIO                   ||cLimitador||
                    X.PORCENCONTRIBUTORIO               ||cLimitador||
                    X.GIRONEGOCIO                       ||cLimitador||
                    X.TIPONEGOCIO                       ||cLimitador||
                    X.FUENTERECURSOS                    ||cLimitador||
                    X.CODPAQCOMERCIAL                   ||cLimitador||
                    X.CATEGORIA                         ||cLimitador||
                    X.CANALFORMAVENTA                   ||cLimitador||
                    cPolizaCont                         ||CHR(13);
      ELSE
         cCadena := '<tr>' || 
                    OC_ARCHIVO.CAMPO_HTML(X.IDPOLIZA,'C')         								||
                    OC_ARCHIVO.CAMPO_HTML(X.POLUNIK,'C')          								||
                    OC_ARCHIVO.CAMPO_HTML(X.NUMSINIREF,'C')       								||             
                    OC_ARCHIVO.CAMPO_HTML(X.IDSINIESTRO,'C')      								||
                    OC_ARCHIVO.CAMPO_HTML(X.COD_PAGO,'C')         								||
                    OC_ARCHIVO.CAMPO_HTML(X.cFechaMvto,'C')        								||
                    OC_ARCHIVO.CAMPO_HTML(X.NUM_APROBACION,'C')   								||
                    OC_ARCHIVO.CAMPO_HTML(X.TIPO_APROBACION,'C')  								||
                    OC_ARCHIVO.CAMPO_HTML(X.ESTATUS,'C')          								||
                    OC_ARCHIVO.CAMPO_HTML(X.CODTRANSAC,'C')       								||
                    OC_ARCHIVO.CAMPO_HTML(X.DESCTRANSAC,'C')      								||
                    OC_ARCHIVO.CAMPO_HTML(X.CODCPTOTRANSAC,'C')   								||
                    OC_ARCHIVO.CAMPO_HTML(X.NUMTRX,'C')           								||
                    OC_ARCHIVO.CAMPO_HTML(dFecRes,'D')            								||
                    OC_ARCHIVO.CAMPO_HTML(X.COD_MONEDA,'C')       								||
                    OC_ARCHIVO.CAMPO_HTML(nTipoCambio,'C')        								||
                    OC_ARCHIVO.CAMPO_HTML(NVO_MNTO_PAGADO_MON,'N')   							||
                    OC_ARCHIVO.CAMPO_HTML(NVO_MNTO_PAGADO_LOC,'N')    						||
                    OC_ARCHIVO.CAMPO_HTML(nMontoHonoMoneda,'N')   								||
                    OC_ARCHIVO.CAMPO_HTML(nMontoHonoLocal,'N')   									||
                    OC_ARCHIVO.CAMPO_HTML(nMontoHospMoneda,'N')   								||
                    OC_ARCHIVO.CAMPO_HTML(nMontoHospLocal,'N')   									||
                    OC_ARCHIVO.CAMPO_HTML(nMontoOtrGtoMoneda,'N')   							||
                    OC_ARCHIVO.CAMPO_HTML(nMontoOtrGtoLocal,'N')   								||
                    OC_ARCHIVO.CAMPO_HTML(nMontoDctoMoneda,'N')   								||
                    OC_ARCHIVO.CAMPO_HTML(nMontoDctoLocal,'N')   									||
                    OC_ARCHIVO.CAMPO_HTML(nMontoDeducLocal,'N')   								||
                    OC_ARCHIVO.CAMPO_HTML(nMontoDeducMoneda,'N')   								||
                    OC_ARCHIVO.CAMPO_HTML(cValorCampoIVA ,'N')    								||
                    OC_ARCHIVO.CAMPO_HTML(cValorCampoIVA ,'N')    								||
                    OC_ARCHIVO.CAMPO_HTML(cValorCampoISR ,'N')    								||
                    OC_ARCHIVO.CAMPO_HTML(cValorCampoISR ,'N')    								||
                    OC_ARCHIVO.CAMPO_HTML(nIVA_RET_MONEDA,'N')   								||
                    OC_ARCHIVO.CAMPO_HTML(nIVA_RET_LOCAL,'N')    								||
                    OC_ARCHIVO.CAMPO_HTML(nImpLoc_Ret_Local,'N')   							||
                    OC_ARCHIVO.CAMPO_HTML(nImpLoc_Ret_Moneda,'N')   							||
                    OC_ARCHIVO.CAMPO_HTML(W_PAGO_NETO_MON_MON,'N')	 							||
                    OC_ARCHIVO.CAMPO_HTML(W_PAGO_NETO_MON_LOC,'N')		  			  	||
                    OC_ARCHIVO.CAMPO_HTML(X.OPC_MONEDA,'N')       								||
                    OC_ARCHIVO.CAMPO_HTML(X.OPC_LOCAL,'N')        								||
                    OC_ARCHIVO.CAMPO_HTML(cDescBanco,'C')         								||
                    OC_ARCHIVO.CAMPO_HTML(cCuentaCheque,'C')      								||
                    OC_ARCHIVO.CAMPO_HTML(X.USUARIO,'C')          								||
                    OC_ARCHIVO.CAMPO_HTML(nIVAPorcentaje,'C')     								||
                    OC_ARCHIVO.CAMPO_HTML(X.ASEGURADO,'C')        								||
                    OC_ARCHIVO.CAMPO_HTML(cNombreBenef,'C')       								||
                    OC_ARCHIVO.CAMPO_HTML(cNumDocTributario,'C')  								||
                    OC_ARCHIVO.CAMPO_HTML(NVL(X.NomArchCarga,cNomArchCarga),'C')  ||
                    OC_ARCHIVO.CAMPO_HTML(NVL(X.ARCHIVO_LOGEM,cNomArchLogem),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(NVL(X.FecCarga,dFecCarga),'D')          ||
                    OC_ARCHIVO.CAMPO_HTML(X.TIPOSEGURO,'C')       								||  
                    OC_ARCHIVO.CAMPO_HTML(NVL(X.NUMERO_FACTURA,cUUID),'C')   			||  
                    OC_ARCHIVO.CAMPO_HTML(NVL(X.IDPROCMASIVO,nIdProcMasivo),'C')  ||  
                    OC_ARCHIVO.CAMPO_HTML(X.POLCONTA_GG,'C')      								||  
                    OC_ARCHIVO.CAMPO_HTML(X.FECHA_PAGO,'C')       								||  
                    OC_ARCHIVO.CAMPO_HTML(X.IMPORT_PAGO,'C')      								|| 
                    OC_ARCHIVO.CAMPO_HTML(X.ARCHIVO_GG,'C')       								|| 
                    OC_ARCHIVO.CAMPO_HTML(X.PGOGG_USUARIO,'C')    								|| 
                    OC_ARCHIVO.CAMPO_HTML(X.PGOGG_FECHACOMP,'C')  								|| 
                    OC_ARCHIVO.CAMPO_HTML(X.OBSERVACION_GG,'C')   								||                  
                    OC_ARCHIVO.CAMPO_HTML(X.WMONTO,'C')               						||
                    OC_ARCHIVO.CAMPO_HTML(X.ESCONTRIBUTORIO,'C')                  || 
                    OC_ARCHIVO.CAMPO_HTML(X.PORCENCONTRIBUTORIO,'C')              || 
                    OC_ARCHIVO.CAMPO_HTML(X.GIRONEGOCIO,'C')                      || 
                    OC_ARCHIVO.CAMPO_HTML(X.TIPONEGOCIO,'C')                      || 
                    OC_ARCHIVO.CAMPO_HTML(X.FUENTERECURSOS,'C')                   || 
                    OC_ARCHIVO.CAMPO_HTML(X.CODPAQCOMERCIAL,'C')                  || 
                    OC_ARCHIVO.CAMPO_HTML(X.CATEGORIA,'C')                        || 
                    OC_ARCHIVO.CAMPO_HTML(X.CANALFORMAVENTA,'C')                  ||
                    OC_ARCHIVO.CAMPO_HTML(cPolizaCont,'C')                        || '</tr>';
      END IF;
      nLinea := nLinea + 1;
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);          --20190517 JISL
   END LOOP;
   --
   IF cFormato = 'EXCEL' THEN
      --cCadena := '</table></div></html>';
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);     SYNCHRONIZE;      
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999); --20190517 JISL
   END IF;
   --CLIENT_TEXT_IO.fCLOSE(ARCHIVO_SALIDA);
  OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
--EXCEPTION 
--   WHEN OTHERS THEN 
        --RAISE_APPLICATION_ERROR(-20105,'Error en Generación Reporte PAGOS APROBADOS  de Siniestros: '|| ' ' ||SQLERRM);  
        
END;
  
PROCEDURE GENERA_GENERICO(cNomArchivo                 VARCHAR2,
                          PFEC_FONDEO_DESDE           DATE,
                          PFEC_FONDEO_HASTA           DATE,
                          PFEC_PAGO_PROGRAMADA_DESDE  DATE,
                          PFEC_PAGO_PROGRAMADA_HASTA  DATE,
                          cFormato    VARCHAR2,nIdReporte  NUMBER) IS
                         
cLimitador         		VARCHAR2(1) :='|';
nLinea             		NUMBER;
cCadena            		VARCHAR2(4000);
cCodUser           		VARCHAR2(30);
nDummy             		NUMBER;
cCopy              		BOOLEAN;
CSTSAPROBACION        APROBACIONES.STSAPROBACION%TYPE;
CSTSAPROBACION_ASEG   APROBACIONES.STSAPROBACION%TYPE;
WSTSAPROBACION        APROBACIONES.STSAPROBACION%TYPE;
----
--ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;
LINEA_SALIDA       VARCHAR2(5000); 
WI_ARCHIVO_SALIDA  VARCHAR2(2000); 
---- 
CURSOR SINCAUS_Q IS 
SELECT IDSINIESTRO,
       IDDETSIN,
       NUM_APROBACION,
       BENEF,
       NUM_CHEQUE,
       NUM_REFERENCIA,
       IDTIPO_PAGO,
       FEC_PAGO_MOVTO,
       FEC_PAGO_REAL,
       ID_GRUPO_FONDEO,
       ST_FONDEO,
       FEC_FONDEO,
       USUARIO_FONDEO,
       MONTO_MONEDA,
       ST_FINIQUITO,
       FEC_REGISTRO,
       USUARIO_REGISTRO,
       FEC_IMPRESION,
       USUARIO_IMPRESION,
       MOTIVO_RECHAZO,
       FEC_PAGO_PROGRAMADA,
       IDPROC,
       CODCIA
  FROM FONDEO F
 WHERE F.FEC_PAGO_PROGRAMADA BETWEEN PFEC_PAGO_PROGRAMADA_DESDE 
                                 AND PFEC_PAGO_PROGRAMADA_HASTA
   AND F.FEC_FONDEO          BETWEEN PFEC_FONDEO_DESDE
                                 AND PFEC_FONDEO_HASTA
   --
 ORDER BY IDSINIESTRO,
          IDDETSIN,
          NUM_APROBACION
       ;
--
BEGIN 
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
  --
  IF cFormato = 'TEXTO' THEN
     nLinea  := 1;
     cCadena := oc_empresas.NOMBRE_COMPANIA(1) || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     nLinea  := nLinea + 1;
     cCadena := 'REPORTE DE FONDEO';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     nLinea  := nLinea + 1;
     cCadena := TO_CHAR(PFEC_FONDEO_DESDE,'DD/MM/YYYY') || ' AL ' || TO_CHAR(PFEC_FONDEO_HASTA,'DD/MM/YYYY') || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     nLinea  := nLinea + 1;
     cCadena := 'IDSINIESTRO'        ||cLimitador||
                'IDDETSIN'           ||cLimitador||
                'NUM_APROBACION'     ||cLimitador||
                'BENEF'              ||cLimitador||
                'NUM_CHEQUE'         ||cLimitador||
                'NUM_REFERENCIA'     ||cLimitador||
                'IDTIPO_PAGO'        ||cLimitador||
                'FEC_PAGO_MOVTO'     ||cLimitador||
                'FEC_PAGO_REAL'      ||cLimitador||
                'ID_GRUPO_FONDEO'    ||cLimitador||
                'ST_FONDEO'          ||cLimitador||
                'FEC_FONDEO'         ||cLimitador||
                'USUARIO_FONDEO'     ||cLimitador||
                'MONTO_MONEDA'       ||cLimitador||
                'ST_FINIQUITO'       ||cLimitador||
                'FEC_REGISTRO'       ||cLimitador||
                'USUARIO_REGISTRO'   ||cLimitador||
                'FEC_IMPRESION'      ||cLimitador||
                'USUARIO_IMPRESION'  ||cLimitador||
                'MOTIVO_RECHAZO'     ||cLimitador||
                'FEC_PAGO_PROGRAMADA'||cLimitador||
                'IDPROC'             ||cLimitador||
                'ST_APROBACION'      ||cLimitador||
                CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  ELSE
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                      ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                       ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                       ' <style id="libro">'||chr(10)||
                       '   <!--table'||chr(10)||
                       '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                       '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                       '        .texto'||chr(10)||
                       '          {mso-number-format:"\@";}'||chr(10)||
                       '        .numero'||chr(10)||
                       '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                       '        .fecha'||chr(10)||
                       '          {mso-number-format:"dd\\/mm\\/yyyy";}'||chr(10)||
                       '    -->'||chr(10)||
                       ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>' || oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DE FONDEO'|| '</th></tr>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>'||TO_CHAR(PFEC_FONDEO_DESDE,'DD/MM/YYYY') || ' AL ' ||
                 TO_CHAR(PFEC_FONDEO_HASTA,'DD/MM/YYYY') || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1> <tr>'||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IDSINIESTRO</font></th>'        ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IDDETSIN</font></th>'           ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUM_APROBACION</font></th>'     ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">BENEF</font></th>'              ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUM_CHEQUE</font></th>'         ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUM_REFERENCIA</font></th>'     ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IDTIPO_PAGO</font></th>'        ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FEC_PAGO_MOVTO</font></th>'     ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FEC_PAGO_REAL</font></th>'      ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ID_GRUPO_FONDEO</font></th>'    ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ST_FONDEO</font></th>'          ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FEC_FONDEO</font></th>'         ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO_FONDEO</font></th>'     ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO_MONEDA</font></th>'       ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ST_FINIQUITO</font></th>'       ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FEC_REGISTRO</font></th>'       ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO_REGISTRO</font></th>'   ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FEC_IMPRESION</font></th>'      ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO_IMPRESION</font></th>'  ||									 									
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MOTIVO_RECHAZO</font></th>'     ||									 									
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FEC_PAGO_PROGRAMADA</font></th>'||								 									
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IDPROC</font></th>'||									 									
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ST_APROBACION</font></th>';										 									
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END IF;
 --
  FOR X IN SINCAUS_Q LOOP
      CSTSAPROBACION      := '';
      CSTSAPROBACION_ASEG := '';
      WSTSAPROBACION      := '';
      --
      -- INDIVIDUAL
      --
      BEGIN
        SELECT A.STSAPROBACION
          INTO CSTSAPROBACION
          FROM APROBACIONES A
         WHERE A.IDSINIESTRO    = X.IDSINIESTRO
           AND A.NUM_APROBACION = X.NUM_APROBACION
           AND A.CODCIA         = X.CODCIA;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             CSTSAPROBACION := '';            	
             --
             -- COLECTIVO
             --
             BEGIN
               SELECT A.STSAPROBACION
                 INTO CSTSAPROBACION_ASEG
                 FROM APROBACION_ASEG A
                WHERE A.IDSINIESTRO    = X.IDSINIESTRO
                  AND A.NUM_APROBACION = X.NUM_APROBACION
                  AND A.CODCIA         = X.CODCIA;
             EXCEPTION
       	       WHEN NO_DATA_FOUND THEN
                    CSTSAPROBACION_ASEG := '';            	
       	       WHEN OTHERS THEN
                    CSTSAPROBACION_ASEG := '';            	
             END;
         	
      WHEN OTHERS THEN
           CSTSAPROBACION := '';            	
      END;
      --
      IF CSTSAPROBACION IS NOT NULL THEN
         WSTSAPROBACION := CSTSAPROBACION;
      END IF;
      --
      IF CSTSAPROBACION_ASEG IS NOT NULL THEN
         WSTSAPROBACION := CSTSAPROBACION;
      END IF;
      --
      IF cFormato = 'TEXTO' THEN  
         cCadena := TO_CHAR(X.IDSINIESTRO,'99999999999990')    ||cLimitador||
                    TO_CHAR(X.IDDETSIN,'99999999999990')       ||cLimitador||
                    TO_CHAR(X.NUM_APROBACION,'99999999999990') ||cLimitador||
                    TO_CHAR(X.BENEF,'99999999999990')          ||cLimitador||
                    TO_CHAR(X.NUM_CHEQUE,'99999999999990')     ||cLimitador||
                    X.NUM_REFERENCIA                           ||cLimitador||
                    X.IDTIPO_PAGO                              ||cLimitador||
                    TO_CHAR(X.FEC_PAGO_MOVTO,'dd/mm/yyyy')     ||cLimitador||
                    TO_CHAR(X.FEC_PAGO_REAL,'dd/mm/yyyy')      ||cLimitador||
                    TO_CHAR(X.ID_GRUPO_FONDEO,'9999999999990') ||cLimitador||
                    X.ST_FONDEO                                ||cLimitador||
                    TO_CHAR(X.FEC_FONDEO,'dd/mm/yyyy')         ||cLimitador||
                    X.USUARIO_FONDEO                           ||cLimitador||
                    TO_CHAR(X.MONTO_MONEDA,'99999999999990')   ||cLimitador||
                    X.ST_FINIQUITO                             ||cLimitador||
                    TO_CHAR(X.FEC_REGISTRO,'dd/mm/yyyy')       ||cLimitador||
                    X.USUARIO_REGISTRO                         ||cLimitador||
                    TO_CHAR(X.FEC_IMPRESION,'dd/mm/yyyy')      ||cLimitador||
                    X.USUARIO_IMPRESION                        ||cLimitador||
                    X.MOTIVO_RECHAZO                           ||cLimitador||
                    TO_CHAR(X.FEC_PAGO_PROGRAMADA,'dd/mm/yyyy')||cLimitador||
                    WSTSAPROBACION                             ||cLimitador||
                    X.IDPROC                                   ||CHR(13); 
      ELSE
        cCadena := '<tr>' || 
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IDSINIESTRO,'999999999999999990'),'C')     ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IDDETSIN,'999999999999999990'),'C')        ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.NUM_APROBACION,'999999999999999990'),'C')  ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.BENEF,'999999999999999990'),'C')           ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.NUM_CHEQUE,'999999999999999990'),'C')      ||
                    OC_ARCHIVO.CAMPO_HTML(X.NUM_REFERENCIA,'C')                                ||
                    OC_ARCHIVO.CAMPO_HTML(X.IDTIPO_PAGO,'C')                                   ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_PAGO_MOVTO,'dd/mm/yyyy'),'C')          ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_PAGO_REAL,'dd/mm/yyyy'),'C')           ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.ID_GRUPO_FONDEO,'999999999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.ST_FONDEO,'C')                                     ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_FONDEO,'dd/mm/yyyy'),'C')              ||
                    OC_ARCHIVO.CAMPO_HTML(X.USUARIO_FONDEO,'C')                                ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MONTO_MONEDA,'999999999999999990'),'C')    ||
                    OC_ARCHIVO.CAMPO_HTML(X.ST_FINIQUITO,'C')                                  ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_REGISTRO,'dd/mm/yyyy'),'C')            ||
                    OC_ARCHIVO.CAMPO_HTML(X.USUARIO_REGISTRO,'C')                              ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_IMPRESION,'dd/mm/yyyy'),'C')           ||
                    OC_ARCHIVO.CAMPO_HTML(X.USUARIO_IMPRESION,'C')                             ||
                    OC_ARCHIVO.CAMPO_HTML(X.MOTIVO_RECHAZO,'C')                                ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_PAGO_PROGRAMADA,'dd/mm/yyyy'),'C')     ||
                    OC_ARCHIVO.CAMPO_HTML(X.IDPROC,'C')                                        ||
                    OC_ARCHIVO.CAMPO_HTML(WSTSAPROBACION,'C')                                  ||
                    '</tr>';
       END IF;
       nLinea := nLinea + 1;
       OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
   --	 
   IF cFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
   END IF;
  OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      raise_application_error(-20105,'Error en Generación de Reporte ' ||SQLERRM); 
END;
PROCEDURE GENERA_FONDEO(cNomArchivo      VARCHAR2,
                        FFEC_PROGRAMADA  DATE,
                        PST_FONDEO       VARCHAR2,
                        PUSUARIO_FONDEO  VARCHAR2,
                        PID_GRUPO_FONDEO NUMBER,
                        cFormato    VARCHAR2,nIdReporte  NUMBER) IS
--                                     
nLinea       NUMBER;
cCadena      VARCHAR2(4000);
cCodUser     VARCHAR2(30);
nDummy       NUMBER;
cCopy        BOOLEAN;
--
NMONTO_PAGO_TIPPAG_SUB   APROBACIONES.MONTO_MONEDA%TYPE;
NMONTO_PAGO_TIPPAG_TOT   APROBACIONES.MONTO_MONEDA%TYPE;
CIDTIPO_PAGO_ANT         VARCHAR2(6);
CNOM_USUARIO_REG         VARCHAR2(100);
--
CURSOR FONDEO IS
SELECT TO_CHAR(F.FEC_PAGO_MOVTO,'DD/MM/YYYY') FECHA_MOVTO,
       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',TS.CODTIPOPLAN) RAMO,
       TO_CHAR(F.IDSINIESTRO) SINIESTRO,
       B.NOMBRE||' '||B.APELLIDO_PATERNO||' '||B.APELLIDO_MATERNO NOM_BENEFICIARIO,
       AA.MONTO_MONEDA MONTO_PAGO,
       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PAGOBENEF',F.IDTIPO_PAGO) TIPO_PAGO,
       OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE) NOM_CONTRATANTE,
       AA.CODUSUARIO USUARIO_MOVTO,
       OC_ENTIDAD_FINANCIERA.NOMBRE_COMERCIAL(F.CODCIA,B.ENT_FINANCIERA) BANCO,
       B.CUENTA_CLAVE CUENTA_CLABE,
       B.NUMCUENTABANCARIA CUENTA_BANCARIA,
       B.IDTIPO_PAGO,
       B.NUM_DOC_TRIBUTARIO
  FROM FONDEO F,
       BENEF_SIN B,
       SINIESTRO S,
       DETALLE_POLIZA DP,
       TIPOS_DE_SEGUROS TS,
       APROBACION_ASEG AA,
       POLIZAS P
 WHERE F.FEC_PAGO_PROGRAMADA  = FFEC_PROGRAMADA
   AND F.ST_FONDEO       = PST_FONDEO
   AND F.USUARIO_FONDEO  = PUSUARIO_FONDEO
   AND F.ID_GRUPO_FONDEO = PID_GRUPO_FONDEO
   --
   AND B.IDSINIESTRO = F.IDSINIESTRO
   AND B.BENEF       = F.BENEF
   AND B.CODCIA      = F.CODCIA
   --
   AND S.IDSINIESTRO = F.IDSINIESTRO
   AND S.CODCIA      = F.CODCIA
   --
   AND DP.IDPOLIZA = S.IDPOLIZA
   AND DP.IDETPOL  = S.IDETPOL
   --
   AND TS.IDTIPOSEG = DP.IDTIPOSEG
   --
   AND AA.IDSINIESTRO    = F.IDSINIESTRO
   AND AA.NUM_APROBACION = F.NUM_APROBACION
   AND AA.CODCIA         = F.CODCIA
   --
   AND P.IDPOLIZA = S.IDPOLIZA
--
UNION
--
SELECT TO_CHAR(F.FEC_PAGO_MOVTO,'DD/MM/YYYY') FECHA_MOVTO,
       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CODRAMOS',TS.CODTIPOPLAN) RAMO,
       TO_CHAR(F.IDSINIESTRO) SINIESTRO,
       B.NOMBRE||' '||B.APELLIDO_PATERNO||' '||B.APELLIDO_MATERNO NOM_BENEFICIARIO,
       AA.MONTO_MONEDA MONTO_PAGO,
       OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PAGOBENEF',F.IDTIPO_PAGO) TIPO_PAGO,
       OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE) NOM_CONTRATANTE,
       AA.CODUSUARIO USUARIO_MOVTO,
       OC_ENTIDAD_FINANCIERA.NOMBRE_COMERCIAL(F.CODCIA,B.ENT_FINANCIERA) BANCO,
       B.CUENTA_CLAVE CUENTA_CLABE,
       B.NUMCUENTABANCARIA CUENTA_BANCARIA,
       B.IDTIPO_PAGO,
       B.NUM_DOC_TRIBUTARIO
  FROM FONDEO F,
       BENEF_SIN B,
       SINIESTRO S,
       DETALLE_POLIZA DP,
       TIPOS_DE_SEGUROS TS,
       APROBACIONES AA,
       POLIZAS P
 WHERE F.FEC_PAGO_PROGRAMADA  = FFEC_PROGRAMADA
   AND F.ST_FONDEO       = PST_FONDEO
   AND F.USUARIO_FONDEO  = PUSUARIO_FONDEO
   AND F.ID_GRUPO_FONDEO = PID_GRUPO_FONDEO
   --
   AND B.IDSINIESTRO = F.IDSINIESTRO
   AND B.BENEF       = F.BENEF
   AND B.CODCIA      = F.CODCIA
   --
   AND S.IDSINIESTRO = F.IDSINIESTRO
   AND S.CODCIA      = F.CODCIA
   --
   AND DP.IDPOLIZA = S.IDPOLIZA
   AND DP.IDETPOL  = S.IDETPOL
   --
   AND TS.IDTIPOSEG = DP.IDTIPOSEG
   --
   AND AA.IDSINIESTRO    = F.IDSINIESTRO
   AND AA.NUM_APROBACION = F.NUM_APROBACION
   AND AA.CODCIA         = F.CODCIA
   --
   AND P.IDPOLIZA = S.IDPOLIZA
 ORDER BY 12, --IDTIPO_PAGO,
          5   --MONTO_MONEDA
;
--
--
--
BEGIN 
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
  --
  BEGIN
   SELECT SUBSTR(A.CAGE_VALOR_LARGO,1,100)
     INTO CNOM_USUARIO_REG
     FROM SAI_CAT_GENERAL A
    WHERE A.CAGE_CD_CATALOGO = 1006
      AND A.CAGE_CD_ESTATUS  = 'ACT'
      AND A.CAGE_NOM_CONCEP  = USER;
  EXCEPTION
  	WHEN NO_DATA_FOUND THEN
  	     CNOM_USUARIO_REG := '';
  	WHEN OTHERS THEN
  	     CNOM_USUARIO_REG := '';
  END;  	
  -- 
  -- CADENA INICIAL DE HOJA
  -- 
  nLinea  := 1;
  cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"' ||chr(10)||
       ' xmlns:x="urn:schemas-microsoft-com:office:excel"' ||chr(10)||
       ' xmlns="http://www.w3.org/TR/REC-html40">'         ||chr(10)||
       ' <style id="libro">'                               ||chr(10)||
       '   <!--table'                                      ||chr(10)||
       '       {mso-displayed-decimal-separator:"\.";'     ||chr(10)||
       '        mso-displayed-thousand-separator:"\,";}'   ||chr(10)||
       '        .texto'                                    ||chr(10)||
       ' {mso-number-format:"\@";}'                        ||chr(10)||
       '        .numero'                                   ||chr(10)||
       ' {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
       '        .fecha'                                    ||chr(10)||
       ' {mso-number-format:"dd\\/mm\\/yyyy";}'            ||chr(10)||
       '    -->'                                           ||chr(10)||
       ' </style><div id="libro">'                         ||chr(10);
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
  --  ENCABEZADOS
  nLinea  := nLinea + 1;
--  cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. DE C.V.</th></tr>'; 
  cCadena := '<table border = 0><tr>'||'<th> </th>'||'<th> </th>'||'<th> </th>'||'<th> </th>'||'<th> </th>'||
             '<th>THONA SEGUROS, S.A. DE C.V.</th></tr>';
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  nLinea  := nLinea + 1;
  cCadena := '<tr>'||'<th> </th>'||'<th> </th>'||'<th> </th>'||'<th> </th>'||'<th> </th>'||
             '<th>REPORTE DIARIO DE PAGOS </th></tr>'; 
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
  nLinea  := nLinea + 1;
  cCadena := '<tr>'||'<th> </th>'||'<th> </th>'||'<th> </th>'||'<th> </th>'||'<th> </th>'||
             '<th>PERIODO DEL '||TO_CHAR(FFEC_PROGRAMADA,'DD')||' DE '||TO_CHAR(FFEC_PROGRAMADA,'MONTH')||' DE '||TO_CHAR(FFEC_PROGRAMADA,'YYYY')||'</th></tr>'; 
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
           
  nLinea  := nLinea + 1;
  cCadena := '<tr><th>  </th></tr></table>'; 
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
    
  nLinea  := nLinea + 1;
  cCadena := '<table border = 1><tr>'  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA</font></th>'                   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RAMO</font></th>'                    ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. SINIESTRO</font></th>'           ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE DEL BENEFICIARIO</font></th>' ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DEL PAGO</font></th>'          ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE PAGO</font></th>'            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE DEL CONTRATANTE</font></th>'  ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO</font></th>'                 ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">BANCO</font></th>'                   ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CUENTA CLABE</font></th>'            ||
                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CUENTA BANCARIA</font></th>'
              ||'</tr></table>'    
                    
                    
                    ;
  -- 
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  -- 
  CIDTIPO_PAGO_ANT := 'PRIMER'; 
  --
  NMONTO_PAGO_TIPPAG_SUB := 0;
  NMONTO_PAGO_TIPPAG_TOT := 0;
  --
  FOR X IN FONDEO LOOP
  	  --
      IF CIDTIPO_PAGO_ANT = 'PRIMER' THEN
       	 CIDTIPO_PAGO_ANT   := X.IDTIPO_PAGO;
      END IF;	 
      --
      NMONTO_PAGO_TIPPAG_SUB := NMONTO_PAGO_TIPPAG_SUB + X.MONTO_PAGO;
      NMONTO_PAGO_TIPPAG_TOT := NMONTO_PAGO_TIPPAG_TOT + X.MONTO_PAGO;
       -- 
      -- IMPRIME SUBTOTAL
      --
      IF CIDTIPO_PAGO_ANT != X.IDTIPO_PAGO THEN
         nLinea  := nLinea + 1;
         cCadena := '<table border = 0>'||
                      '<tr>'||
                        '<th> </th>'||'<th> </th>'||'<th> </th>'||
                        '<th>SUBTOTAL POR TIPO DE PAGO</th>'||
                        OC_ARCHIVO.CAMPO_HTML(NMONTO_PAGO_TIPPAG_SUB,'N')||
                      '</tr>';  
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);           
         --
         nLinea  := nLinea + 1;
         cCadena := '<tr><th> </th></tr></table>'; 
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);           
         --
         NMONTO_PAGO_TIPPAG_SUB := 0;
      END IF;
      --
      cCadena := '<table border = 1>'||
                   '<tr>'|| 
                     OC_ARCHIVO.CAMPO_HTML(X.FECHA_MOVTO      ,'C') ||
                     OC_ARCHIVO.CAMPO_HTML(X.RAMO             ,'C') ||
                     OC_ARCHIVO.CAMPO_HTML(X.SINIESTRO        ,'C') ||
                     OC_ARCHIVO.CAMPO_HTML(X.NOM_BENEFICIARIO ,'C') ||
                     OC_ARCHIVO.CAMPO_HTML(X.MONTO_PAGO       ,'N') ||
                     OC_ARCHIVO.CAMPO_HTML(X.TIPO_PAGO        ,'C') ||
                     OC_ARCHIVO.CAMPO_HTML(X.NOM_CONTRATANTE  ,'C') ||
                     OC_ARCHIVO.CAMPO_HTML(X.USUARIO_MOVTO    ,'C') ||
                     OC_ARCHIVO.CAMPO_HTML(X.BANCO            ,'C') ||
                     OC_ARCHIVO.CAMPO_HTML(X.CUENTA_CLABE     ,'C') ||
                     OC_ARCHIVO.CAMPO_HTML(X.CUENTA_BANCARIA  ,'C') ||
                   '</tr>'||
                 '</table>';   
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      --
      CIDTIPO_PAGO_ANT   := X.IDTIPO_PAGO;
      --
  END LOOP;
  -- 
  -- IMPRIME SUBTOTAL FINAL
  --
  nLinea  := nLinea + 1;
  cCadena := '<table border = 0>'||
               '<tr>'||
                 '<th> </th>'||'<th> </th>'||'<th> </th>'||
                 '<th>SUBTOTAL POR TIPO DE PAGO</th>'||
                 OC_ARCHIVO.CAMPO_HTML(NMONTO_PAGO_TIPPAG_SUB,'N')||
              '</tr>';  
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);           
  --
  nLinea  := nLinea + 1;
  cCadena := '<tr><th> </th></tr></table>'; 
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);           
  --
  -- IMPRIME TOTAL GENERAL
  --
  nLinea  := nLinea + 1;
  cCadena := '<table border = 0>'||
               '<tr>'||
                 '<th> </th>'||'<th> </th>'||'<th> </th>'||
                 '<th>TOTAL POR TIPO DE PAGO</th>'||
                 OC_ARCHIVO.CAMPO_HTML(NMONTO_PAGO_TIPPAG_TOT,'N')||
               '</tr>';  
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);           
  --
  nLinea  := nLinea + 1;
  cCadena := '<tr><th> </th><th> </th><th> </th></tr></table>'; 
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);           
  --
  -- Firmas
  --
  nLinea  := nLinea + 1;
  cCadena := '<table border = 0>'||
               '<tr>'||
                 '<th> </th>'||'<th> </th>'||
                 '<th>ELABORÓ</th>'||
                 '<th> </th>'||
                 '<th>AUTORIZÓ</th>'||
                 '<th> </th>'||
                 '<th>REGISTRÓ</th>'||
               '</tr>';  
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);         
  --
  nLinea  := nLinea + 1;
  cCadena := '<tr><th> </th><th></tr>'; 
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);           
  --
  nLinea  := nLinea + 1;
  cCadena := '<tr><th>'||'<th> </th>'||'</th><th></tr>'; 
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);           
  --
  nLinea  := nLinea + 1;
  cCadena := '<tr><th>'||'<th> </th>'||'</th><th></tr>'; 
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);           
  --
  nLinea  := nLinea + 1;
  cCadena :=   '<tr>'||
                 '<th> </th>'||'<th> </th>'||
                 '<th>-----------------------------------</th>'||
                 '<th> </th>'||
                 '<th>-----------------------------------</th>'||
                 '<th> </th>'||
                 '<th>-----------------------------------</th>'||
               '</tr>';  
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);         
  --
  nLinea  := nLinea + 1;
  cCadena := '<tr>'||
                 '<th> </th>'||'<th> </th>'||
                 OC_ARCHIVO.CAMPO_HTML(CNOM_USUARIO_REG,'C')||
             '</tr>'; 
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);           
  --
  nLinea  := nLinea + 1;
  cCadena :=   '<tr>'||
                 '<th> </th>'||'<th> </th>'||
                 '<th>ANALISTA</th>'||
                 '<th> </th>'||
                 '<th>SINIESTROS VIDA Y ACCIDENTES PERSONALES</th>'||
                 '<th> </th>'||
                 '<th>CONTABILIDAD</th>'||
               '</tr>';  
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);         
  --
  IF cFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
  END IF;
  --
  OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
  --
EXCEPTION 
  WHEN OTHERS THEN 
       OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
       raise_application_error(-20105,'Error en Generación Reporte Fondeo: '|| SQLERRM);  
END;
PROCEDURE GENERA_GENERICO_FIN(cNomArchivo                 VARCHAR2,
                          PFEC_FINIQUITO_DESDE           DATE,
                          PFEC_FINIQUITO_HASTA           DATE,
                          PFEC_PAGO_PROGRAMADA_DESDE  DATE,
                          PFEC_PAGO_PROGRAMADA_HASTA  DATE,
                          cFormato    VARCHAR2,nIdReporte  NUMBER) IS
                         
cLimitador         		VARCHAR2(1) :='|';
nLinea             		NUMBER;
cCadena            		VARCHAR2(4000);
cCodUser           		VARCHAR2(30);
nDummy             		NUMBER;
cCopy              		BOOLEAN;
----
--ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;
LINEA_SALIDA       VARCHAR2(5000); 
WI_ARCHIVO_SALIDA  VARCHAR2(2000); 
---- 
CURSOR SINCAUS_Q IS 
SELECT IDSINIESTRO,
       IDDETSIN,
       NUM_APROBACION,
       BENEF,
       NUM_CHEQUE,
       NUM_REFERENCIA,
       IDTIPO_PAGO,
       FEC_PAGO_MOVTO,
       FEC_PAGO_REAL,
       ID_GRUPO_FONDEO,
       ST_FONDEO,
       FEC_FONDEO,
       USUARIO_FONDEO,
       MONTO_MONEDA,
       ST_FINIQUITO,
       FEC_REGISTRO,
       USUARIO_REGISTRO,
       FEC_IMPRESION,
       USUARIO_IMPRESION,
       MOTIVO_RECHAZO,
       FEC_PAGO_PROGRAMADA,
       IDPROC
  FROM FONDEO F
 WHERE F.FEC_PAGO_PROGRAMADA BETWEEN PFEC_PAGO_PROGRAMADA_DESDE 
                                 AND PFEC_PAGO_PROGRAMADA_HASTA
   AND NVL(F.FEC_IMPRESION,PFEC_FINIQUITO_DESDE)
                             BETWEEN PFEC_FINIQUITO_DESDE
                                 AND PFEC_FINIQUITO_HASTA
   --
 ORDER BY IDSINIESTRO,
          IDDETSIN,
          NUM_APROBACION
       ;
--
BEGIN 
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
  --
  IF    cFormato = 'TEXTO' THEN
     nLinea  := 1;
     cCadena := oc_empresas.NOMBRE_COMPANIA(1) || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     nLinea  := nLinea + 1;
     cCadena := 'REPORTE DE FONDEO';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     nLinea  := nLinea + 1;
     cCadena := TO_CHAR(PFEC_FINIQUITO_DESDE,'DD/MM/YYYY') || ' AL ' || TO_CHAR(PFEC_FINIQUITO_HASTA,'DD/MM/YYYY') || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
     nLinea  := nLinea + 1;
     cCadena := 'IDSINIESTRO'        ||cLimitador||
                'IDDETSIN'           ||cLimitador||
                'NUM_APROBACION'     ||cLimitador||
                'BENEF'              ||cLimitador||
                'NUM_CHEQUE'         ||cLimitador||
                'NUM_REFERENCIA'     ||cLimitador||
                'IDTIPO_PAGO'        ||cLimitador||
                'FEC_PAGO_MOVTO'     ||cLimitador||
                'FEC_PAGO_REAL'      ||cLimitador||
                'ID_GRUPO_FONDEO'    ||cLimitador||
                'ST_FONDEO'          ||cLimitador||
                'FEC_FONDEO'         ||cLimitador||
                'USUARIO_FONDEO'     ||cLimitador||
                'MONTO_MONEDA'       ||cLimitador||
                'ST_FINIQUITO'       ||cLimitador||
                'FEC_REGISTRO'       ||cLimitador||
                'USUARIO_REGISTRO'   ||cLimitador||
                'FEC_IMPRESION'      ||cLimitador||
                'USUARIO_IMPRESION'  ||cLimitador||
                'MOTIVO_RECHAZO'     ||cLimitador||
                'FEC_PAGO_PROGRAMADA'||cLimitador||
                'IDPROC'             ||cLimitador||
                CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  ELSE
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                      ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                       ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                       ' <style id="libro">'||chr(10)||
                       '   <!--table'||chr(10)||
                       '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                       '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                       '        .texto'||chr(10)||
                       '          {mso-number-format:"\@";}'||chr(10)||
                       '        .numero'||chr(10)||
                       '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                       '        .fecha'||chr(10)||
                       '          {mso-number-format:"dd\\/mm\\/yyyy";}'||chr(10)||
                       '    -->'||chr(10)||
                       ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>' || oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DE FONDEO'|| '</th></tr>';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>'||TO_CHAR(PFEC_FINIQUITO_DESDE,'DD/MM/YYYY') || ' AL ' ||
                 TO_CHAR(PFEC_FINIQUITO_HASTA,'DD/MM/YYYY') || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1> <tr>'||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IDSINIESTRO</font></th>'        ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IDDETSIN</font></th>'           ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUM_APROBACION</font></th>'     ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">BENEF</font></th>'              ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUM_CHEQUE</font></th>'         ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUM_REFERENCIA</font></th>'     ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IDTIPO_PAGO</font></th>'        ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FEC_PAGO_MOVTO</font></th>'     ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FEC_PAGO_REAL</font></th>'      ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ID_GRUPO_FONDEO</font></th>'    ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ST_FONDEO</font></th>'          ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FEC_FONDEO</font></th>'         ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO_FONDEO</font></th>'     ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO_MONEDA</font></th>'       ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ST_FINIQUITO</font></th>'       ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FEC_REGISTRO</font></th>'       ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO_REGISTRO</font></th>'   ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FEC_IMPRESION</font></th>'      ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO_IMPRESION</font></th>'  ||									 									
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MOTIVO_RECHAZO</font></th>'     ||									 									
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FEC_PAGO_PROGRAMADA</font></th>'||								 									
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IDPROC</font></th>';										 									
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END IF;
  --
  FOR X IN SINCAUS_Q LOOP
      --
      IF cFormato = 'TEXTO' THEN  
         cCadena := TO_CHAR(X.IDSINIESTRO,'99999999999990')    ||cLimitador||
                    TO_CHAR(X.IDDETSIN,'99999999999990')       ||cLimitador||
                    TO_CHAR(X.NUM_APROBACION,'99999999999990') ||cLimitador||
                    TO_CHAR(X.BENEF,'99999999999990')          ||cLimitador||
                    TO_CHAR(X.NUM_CHEQUE,'99999999999990')     ||cLimitador||
                    X.NUM_REFERENCIA                           ||cLimitador||
                    X.IDTIPO_PAGO                              ||cLimitador||
                    TO_CHAR(X.FEC_PAGO_MOVTO,'dd/mm/yyyy')     ||cLimitador||
                    TO_CHAR(X.FEC_PAGO_REAL,'dd/mm/yyyy')      ||cLimitador||
                    TO_CHAR(X.ID_GRUPO_FONDEO,'9999999999990') ||cLimitador||
                    X.ST_FONDEO                                ||cLimitador||
                    TO_CHAR(X.FEC_FONDEO,'dd/mm/yyyy')         ||cLimitador||
                    X.USUARIO_FONDEO                           ||cLimitador||
                    TO_CHAR(X.MONTO_MONEDA,'99999999999990')   ||cLimitador||
                    X.ST_FINIQUITO                             ||cLimitador||
                    TO_CHAR(X.FEC_REGISTRO,'dd/mm/yyyy')       ||cLimitador||
                    X.USUARIO_REGISTRO                         ||cLimitador||
                    TO_CHAR(X.FEC_IMPRESION,'dd/mm/yyyy')      ||cLimitador||
                    X.USUARIO_IMPRESION                        ||cLimitador||
                    X.MOTIVO_RECHAZO                           ||cLimitador||
                    TO_CHAR(X.FEC_PAGO_PROGRAMADA,'dd/mm/yyyy')||cLimitador||
                    X.IDPROC                                   ||CHR(13); 
      ELSE
        cCadena := '<tr>' || 
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IDSINIESTRO,'999999999999999990'),'C')     ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IDDETSIN,'999999999999999990'),'C')        ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.NUM_APROBACION,'999999999999999990'),'C')  ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.BENEF,'999999999999999990'),'C')           ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.NUM_CHEQUE,'999999999999999990'),'C')      ||
                    OC_ARCHIVO.CAMPO_HTML(X.NUM_REFERENCIA,'C')                                ||
                    OC_ARCHIVO.CAMPO_HTML(X.IDTIPO_PAGO,'C')                                   ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_PAGO_MOVTO,'dd/mm/yyyy'),'C')          ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_PAGO_REAL,'dd/mm/yyyy'),'C')           ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.ID_GRUPO_FONDEO,'999999999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.ST_FONDEO,'C')                                     ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_FONDEO,'dd/mm/yyyy'),'C')              ||
                    OC_ARCHIVO.CAMPO_HTML(X.USUARIO_FONDEO,'C')                                ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MONTO_MONEDA,'999999999999999990'),'C')    ||
                    OC_ARCHIVO.CAMPO_HTML(X.ST_FINIQUITO,'C')                                  ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_REGISTRO,'dd/mm/yyyy'),'C')            ||
                    OC_ARCHIVO.CAMPO_HTML(X.USUARIO_REGISTRO,'C')                              ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_IMPRESION,'dd/mm/yyyy'),'C')           ||
                    OC_ARCHIVO.CAMPO_HTML(X.USUARIO_IMPRESION,'C')                             ||
                    OC_ARCHIVO.CAMPO_HTML(X.MOTIVO_RECHAZO,'C')                                ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_PAGO_PROGRAMADA,'dd/mm/yyyy'),'C')     ||
                    OC_ARCHIVO.CAMPO_HTML(X.IDPROC,'C')                                        ||
                    '</tr>';
       END IF;
       nLinea := nLinea + 1;
       OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
   --	 
   IF cFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
   END IF;
  OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      raise_application_error(-20105,'Error en Generación de Reporte ' ||SQLERRM); 
END;
PROCEDURE REPORTE_PAGOS_COLECTIVOS (cNomArchivo VARCHAR2, 
                                    cIdTipoSeg  VARCHAR2, 
                                    cCodMoneda  VARCHAR2, 
                                    dFecDesde   DATE    ,
                                    dFecHasta   DATE    ,
                                    cAutoriza VARCHAR2,cFormato    VARCHAR2,nIdReporte  NUMBER) IS
--
cLimitador      VARCHAR2(1) :='|';
nLinea          NUMBER;
cCadena         VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;
--
nIdSiniestro      SINIESTRO.IdSiniestro%TYPE;
dFecRes           COBERTURA_SINIESTRO_ASEG.FecRes%TYPE;
nTipoCambio       TASAS_CAMBIO.Tasa_Cambio%TYPE;
--dFecCarga         DATOS_PART_SINIESTROS.FecSts%TYPE;
cRFCHospital      DATOS_PART_SINIESTROS.Campo1%TYPE;
--cNomArchCarga     DATOS_PART_SINIESTROS.Campo85%TYPE;
nMontoRvaMon      COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc      COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;
cNombreBenef      VARCHAR2(2000);
cNumDocTributario BENEF_SIN.Num_Doc_Tributario%TYPE;
cEntidadFinanc    BENEF_SIN_PAGOS.Entidad_Financiera%TYPE;
cCuentaCheque     BENEF_SIN_PAGOS.Nro_Cheque%TYPE;
cDescBanco        VARCHAR2(200);
nIVAPorcentaje    CATALOGO_DE_CONCEPTOS.PorcConcepto%TYPE;
nCodCia           POLIZAS.codcia%TYPE;
nCodEmpresa       DETALLE_POLIZA.CODEMPRESA%TYPE;
cCodPlantilla     CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE := 'EMITESINIESTRO';
cQueryIVA         VARCHAR2(4000) := NULL;
cQueryISR         VARCHAR2(4000) := NULL;
cValorCampoIVA    VARCHAR2(4000) := NULL;
cValorCampoISR    VARCHAR2(4000) := NULL;
--
--ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;
--ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);    
muestralerta number;
USUSARIO            VARCHAR2(50);
TERMINAL            VARCHAR2(50);
FIRMAS              VARCHAR2(70); 
cUsuario            VARCHAR2(50); 
--
	CURSOR PAGOSSIN_Q IS
    SELECT 
         '1'                                                                            POSICION ,
         TO_CHAR(T.FECHATRANSACCION,'DD/MM/YYYY')                                       FECHA, 
         DECODE(TS.CODTIPOPLAN,10,'VIDA','AP')                                          RAMO,                           
         SI.IDSINIESTRO                                                                 NUM_SINIESTRO,
         BES.NOMBRE||'  '||BES.APELLIDO_PATERNO||'  '||BES.APELLIDO_MATERNO             NOMBRE_BENEFICIARIO,
         A.MONTO_MONEDA                                                                 MONTO_PAGO,         
         BES.TIPO_PAGO                                                                  TIPO_PAGO,           
         OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE)                                      NOMBRE_CONTRATANTE,                   
         T.USUARIOGENERO                                                                USUARIO,
          --- Datos para Actualizar Fondeo  ---
         A.NUM_APROBACION,
				 A.IDSINIESTRO   ,
				 A.IDPOLIZA      ,
				 A.IDDETSIN                                 
    FROM  TRANSACCION T
         ,APROBACION_ASEG A 
         ,SINIESTRO SI
         ,DETALLE_SINIESTRO_ASEG DS
         ,BENEF_SIN                 BES   
         ,POLIZAS                   PP
         ,TIPOS_DE_SEGUROS          TS
    WHERE TRUNC(T.FECHATRANSACCION) >= dFecDesde  
     AND TRUNC(T.FECHATRANSACCION)  <=  dFecHasta  
     ---
     AND T.USUARIOGENERO IN (SELECT CODUSUARIO 
                             FROM PROCESO_AUTORIZA_USUARIO
                             WHERE CodCia               = T.CODCIA
                             AND CodProceso           = 9045
                             AND IdTipoSeg            = 'NOAPLI'
                            )
     ---
     AND T.CODCIA           = 1 --NVL(:BK_DATOS.CODCIA,1)
     AND T.CODEMPRESA       = 1 --NVL(:BK_DATOS.CODEMPRESA,1)
     AND T.IDPROCESO        = 6
     --
     AND A.IDTRANSACCION    = T.IDTRANSACCION
     AND A.STSAPROBACION    = 'PAG'
      AND A.INDFONDOSINI    = 'N'
     AND NOT EXISTS (SELECT SI.IDSINIESTRO                      
                     FROM PROCESOS_MASIVOS_SEGUIMIENTO F
                     WHERE F.NUM_APROBACION  = A.NUM_APROBACION  
                     AND   F.IDSINIESTRO     = A.IDSINIESTRO
                     AND   F.IDPOLIZA        = A.IDPOLIZA                                
                     AND   F.COD_ASEGURADO   = A.COD_ASEGURADO
                     AND   F.EMI_TIPOPROCESO = 'PAGSIN'
                     AND   F.IDTRANSACCION   = A.IDTRANSACCION
                    )
     --
     AND BES.IDSINIESTRO    = A.IDSINIESTRO
     AND BES.IDPOLIZA       = A.IDPOLIZA
     AND BES.COD_ASEGURADO  = A.COD_ASEGURADO
     AND BES.BENEF          = A.BENEF 
     --
     AND  SI.IDSINIESTRO    = A.IDSINIESTRO
     AND  SI.IDPOLIZA       = A.IDPOLIZA
     AND  SI.COD_ASEGURADO  = A.COD_ASEGURADO
     --
     AND DS.IDSINIESTRO     = SI.IDSINIESTRO
     AND DS.IDPOLIZA        = SI.IDPOLIZA
     AND DS.IDDETSIN        = 1
     AND DS.COD_ASEGURADO   = SI.COD_ASEGURADO
     --
     AND PP.IDPOLIZA        = a.idpoliza
     AND PP.CODCIA          = 1--NVL(:BK_DATOS.CODCIA,1)
     AND PP.CODEMPRESA      = 1 --NVL(:BK_DATOS.CODEMPRESA,1) 
     --
     AND TS.IDTIPOSEG       = DS.IDTIPOSEG
     AND TS.CODEMPRESA      = 1 --NVL(:BK_DATOS.CODEMPRESA,1)
     AND TS.CODCIA          = 1 --NVL(:BK_DATOS.CODCIA,1)
     --             
  ORDER BY 2,9; 
         
		
--
BEGIN
  ---- // INICIO //
   SELECT  USER ,USERENV('TERMINAL')                   ---  SIGUECARGA
          INTO    USUSARIO , TERMINAL
          FROM    SYS.DUAL;   
          	    
   --cUsuario	          := Get_Application_Property(Username);  	      
          
   SELECT CODUSR,codusr,CODUSR
   INTO cCodUser,USUSARIO,cUsuario
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
    --ARCHIVO_SALIDA    := CLIENT_TEXT_IO.FOPEN(cNomArchivo,'W');         synchronize;	     
    ---- // FORMATO TEXTO //
  IF cFormato = 'TEXTO' THEN    
     ---- // TITULOS //
     nLinea := 1; 
     cCadena     := 'THONA SEGUROS, S.A. de C.V.' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea := nLinea + 1;
     cCadena     := 'FONDEO DE PAGOS COLECTIVOS' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := 'PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE '|| TO_CHAR(dFecDesde,'Month') || ' AL ' || TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecHasta,'Month') ||' DE ' || TO_CHAR(dFecHasta,'YYYY') || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := 'FECHA'                 ||cLimitador||'RAMO'          ||cLimitador||'NUMERO DE SINIESTRO'     || cLimitador ||
                'NOMBRE_BENEFICIARIO'   ||cLimitador||'MONTO DE PAGO '||cLimitador||'TIPO DE PAGO'||cLimitador||'NOMBRE DEL CONTRATANTE'||cLimitador  ||'USUARIO ';--||chr(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  ELSE
     ---- // FORMATO EXCEL //
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                ' <style id="libro">'||chr(10)||
                '   <!--table'||chr(10)||
                '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                '        .texto'||chr(10)||
                '          {mso-number-format:"\@";}'||chr(10)||
                '        .numero'||chr(10)||
                '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                '        .fecha'||chr(10)||
                '          {mso-number-format:"dd\\-mm\\-yy";}'||chr(10)||
                '    -->'||chr(10)||
                ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     ---- // TITULOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DIARIO DE PAGOS COLECTIVOS '||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE ' || TO_CHAR(dFecDesde,'MONTH') || ' AL ' ||
                TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecHasta,'MONTH') || ' DE ' || TO_CHAR(dFecHasta,'YYYY') || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RAMO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE SINIESTRO</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE DEL BENEFICIARIO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DEL PAGO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE PAGO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE DEL CONTRATANTE.</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO</font></th></tr>';
   
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END IF;
  	
  ---- // CARGA DE INFORMACIÓN //
  FOR X IN PAGOSSIN_Q LOOP
    --
  	--
    IF cFormato = 'TEXTO' THEN
       cCadena := X.FECHA 				   	  ||cLimitador||						
                  X.RAMO						    ||cLimitador||
                  X.NUM_SINIESTRO       ||cLimitador||
                  X.NOMBRE_BENEFICIARIO	||cLimitador||
                  X.MONTO_PAGO					||cLimitador||
                  X.TIPO_PAGO				    ||cLimitador||
                  X.NOMBRE_CONTRATANTE	||cLimitador||
                  X.USUARIO		       ;--||chr(13);  synchronize;	
               
    ELSE
       cCadena := '<tr>' ||
                  OC_ARCHIVO.CAMPO_HTML(X.FECHA,'C')              ||
                  OC_ARCHIVO.CAMPO_HTML(X.RAMO,'C')               ||
                  OC_ARCHIVO.CAMPO_HTML(X.NUM_SINIESTRO,'C')      ||
                  OC_ARCHIVO.CAMPO_HTML(X.NOMBRE_BENEFICIARIO,'C')||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTO_PAGO,'C')         ||
                  OC_ARCHIVO.CAMPO_HTML(X.TIPO_PAGO,'D')          ||
                  OC_ARCHIVO.CAMPO_HTML(X.NOMBRE_CONTRATANTE,'C') ||
                  OC_ARCHIVO.CAMPO_HTML(X.USUARIO,'C')            || '</tr>';
                                   
    END IF;
    nLinea := nLinea + 1;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
    
    
     --- Llama a Procedure para Marcar el Fondeo de los pagos ---
     IF x.POSICION  = '1' THEN
       OC_APROBACION_ASEG.ACTUALIZA_FONDEO(x.NUM_APROBACION, x.IDSINIESTRO, x.IDPOLIZA, x.IDDETSIN);
     END IF;      
     Standard.commit;
  END LOOP; 
  
     nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     
       nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
      nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     
     
      
     nLinea  := nLinea + 1;
     cCadena := '<tr>
     <th colspan=3>  ELABORÓ    </th>
     <th colspan=2>  AUTORIZÓ    </th>
     <th colspan=3>  REGISTRÓ    </th>                
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     
       nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
      nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     nLinea  := nLinea + 1;
     cCadena := '<tr>
     <th style="border:none;" colspan=3>  ________________    </th>
     <th style="border:none;" colspan=2>  ________________    </th>
     <th style="border:none;" colspan=3>  ________________    </th>                
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
       
       IF USUSARIO = 'EVALENCI'  THEN
     	     cCadena := '<tr>
			     <th colspan=3> EDUARDO VALENCIA</th>
			     <th colspan=2>Jocelyn Vizuet Rayón</th>
			     <th colspan=3>Alipio Hernández García</th>                
			     </tr>';      
			    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
          
     ELSIF USUSARIO = 'EESTRADA'  THEN
         	 cCadena := '<tr>
			     <th colspan=3> ERIKA ESTRADA</th>
			     <th colspan=2>Jocelyn Vizuet Rayón</th>
			     <th colspan=3>Alipio Hernández García</th>                
			     </tr>';      
			     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         	
         
     ELSIF USUSARIO = 'JACEMAN'  THEN	
     	    cCadena := '<tr>
			     <th colspan=3>JACQUELINNE ESCOBAR MANCILLA</th>
			     <th colspan=2>Jocelyn Vizuet Rayón</th>
			     <th colspan=3>Alipio Hernández García</th>                
			     </tr>';      
			     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     	    
     
     ELSE    	
    	
     cCadena := '<tr>
     <th colspan=3> JACQUELINNE ESCOBAR MANCILLA </th>
     <th colspan=2> '||cAutoriza/*:TB_CONTROL.DESCNOMBRE*/||'
     </th>
     <th colspan=3>Alipio Hernández García</th>                
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
    END IF; 	
     
         
         
      nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     nLinea  := nLinea + 1;
     cCadena := '<tr>
     <th colspan=3>       ANALISTA    </th>
     <th colspan=2>  SINIESTROS VIDA Y ACCIDENTES PERSONALES  </th>
     <th colspan=3>       CONTABILIDAD </th>                
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     
     
  ---- // CIERRE DEL ARCHIVO  //    
  IF cFormato = 'EXCEL' THEN
--     OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
     cCadena := '</table></div></html>';
     nLinea := nLinea + 1;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END IF;
  OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
EXCEPTION 
  WHEN OTHERS THEN 
    raise_application_error(-20105,'Error en Generación Reporte PAGOS APROBADOS  de Siniestros: '|| ' ' ||SQLERRM);  
END;
PROCEDURE DETALLES_MASIVOS (cNomArchivo VARCHAR2, 
                            cRutaCarga  VARCHAR2,
                            cRFC        VARCHAR2,
                            cAutoriza VARCHAR2,cFormato    VARCHAR2,nIdReporte  NUMBER) IS
--
cLimitador      VARCHAR2(1) :='|';
nLinea          NUMBER;
cCadena         VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;
--
nIdSiniestro      SINIESTRO.IdSiniestro%TYPE;
dFecRes           COBERTURA_SINIESTRO_ASEG.FecRes%TYPE;
nTipoCambio       TASAS_CAMBIO.Tasa_Cambio%TYPE;
--dFecCarga         DATOS_PART_SINIESTROS.FecSts%TYPE;
cRFCHospital      DATOS_PART_SINIESTROS.Campo1%TYPE;
--cNomArchCarga     DATOS_PART_SINIESTROS.Campo85%TYPE;
nMontoRvaMon      COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc      COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;
cNombreBenef      VARCHAR2(2000);
cNumDocTributario BENEF_SIN.Num_Doc_Tributario%TYPE;
cEntidadFinanc    BENEF_SIN_PAGOS.Entidad_Financiera%TYPE;
cCuentaCheque     BENEF_SIN_PAGOS.Nro_Cheque%TYPE;
cDescBanco        VARCHAR2(200);
nIVAPorcentaje    CATALOGO_DE_CONCEPTOS.PorcConcepto%TYPE;
nCodCia           POLIZAS.codcia%TYPE;
nCodEmpresa       DETALLE_POLIZA.CODEMPRESA%TYPE;
cCodPlantilla     CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE := 'EMITESINIESTRO';
cQueryIVA         VARCHAR2(4000) := NULL;
cQueryISR         VARCHAR2(4000) := NULL;
cValorCampoIVA    VARCHAR2(4000) := NULL;
cValorCampoISR    VARCHAR2(4000) := NULL;
--
--ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;
--ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);    
muestralerta number;
USUSARIO            VARCHAR2(50);
TERMINAL            VARCHAR2(50);
FIRMAS              VARCHAR2(70); 
cUsuario            VARCHAR2(50); 
--
	CURSOR PAGOSSIN_Q IS
    select   ROWNUM              REGISTRO, 
             A1.IDPOLIZA         POLIZA, 
             P.NUMPOLUNICO       NUMPOLUNICO, 
             A1.NUM_ASISTENCIA   ASISTENCIA, 
             A1.IDSINIESTRO      SINIESTRO, 
             A1.MONTOPAGAR       MONTO,
             A1.CRGA_NOM_ARCHIVO ARCHIVO, 
             A1.NUMFACTURA       FACTURA, 
             A1.IDPROCMASIVO     ID_CARGA 
    from procesos_masivos_seguimiento a1
        ,POLIZAS                      P
    where a1.INDFONDOSINI    = 'S'
    and   a1.Emi_Tipoproceso = 'PAGSIN'
    and   a1.FOND_RFC        = cRFC ---'OHA051017KE7'
    and   trunc(a1.fond_fec) = trunc(sysdate)
    --
    AND P.IDPOLIZA = A1.IDPOLIZA
    AND P.CODCIA   = 1 ;
		
--
BEGIN
  ---- // INICIO //
   SELECT  USER ,USERENV('TERMINAL')                   ---  SIGUECARGA
          INTO    USUSARIO , TERMINAL
          FROM    SYS.DUAL;   
          	    
   --cUsuario	          := Get_Application_Property(Username);  	      
          
  SELECT SYS_CONTEXT ('USERENV','CURRENT_USERID')
    INTO cCodUser
    FROM DUAL;
   SELECT CODUSR,codusr,CODUSR
   INTO cCodUser,USUSARIO,cUsuario
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
--    ARCHIVO_SALIDA    := CLIENT_TEXT_IO.FOPEN(cNomArchivo,'W');         synchronize;	     
    ---- // FORMATO TEXTO //
  IF cFormato = 'TEXTO' THEN    
     ---- // TITULOS //
     nLinea := 1; 
     cCadena     := 'THONA SEGUROS, S.A. de C.V.' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea := nLinea + 1;
     cCadena     := 'DETALLE DE FONDEO DE CARGA MASIVO' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     --nLinea  := nLinea + 1;
     --cCadena := 'PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE '|| TO_CHAR(dFecDesde,'Month') || ' AL ' || TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecHasta,'Month') ||' DE ' || TO_CHAR(dFecHasta,'YYYY') || CHR(13);
     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
     --
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := 'REGISTRO'                 ||cLimitador||'NUMERO DE POLIZA'          ||cLimitador||'NUMERO DE POLIZA UNICO'     || cLimitador ||
                'NUMERO DE ASISTENCIA'   ||cLimitador||'NUMERO DE SINIESTRO'||cLimitador||'MONTO ORIGINAL'||cLimitador||'NOMBRE DE CARGA'||cLimitador  ||'NUMERO DE FACTURA '||cLimitador  ||'ID DE CARGA';--||chr(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  ELSE
     ---- // FORMATO EXCEL //
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                ' <style id="libro">'||chr(10)||
                '   <!--table'||chr(10)||
                '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                '        .texto'||chr(10)||
                '          {mso-number-format:"\@";}'||chr(10)||
                '        .numero'||chr(10)||
                '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                '        .fecha'||chr(10)||
                '          {mso-number-format:"dd\\-mm\\-yy";}'||chr(10)||
                '    -->'||chr(10)||
                ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     ---- // TITULOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>REPORTE DETALLADO DE FONDEO MASIVO POR CARGA'||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">REGISTRO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE POLIZA</font></th>'      ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE POLIZA UNICO</font></th>'||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE ASISTENCIA</font></th>'  ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE SINIESTRO</font></th>'   ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO ORIGINAL</font></th>'        ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE DE CARGA</font></th>'       ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE FACTURA</font></th>'     ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ID DE CARGA</font></th></tr>'      ; 
   
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END IF;
  	
  ---- // CARGA DE INFORMACIÓN //
  FOR X IN PAGOSSIN_Q LOOP
    --
  	--
    IF cFormato = 'TEXTO' THEN
       cCadena := X.REGISTRO 		||cLimitador||						
                  X.POLIZA			||cLimitador||
                  X.NUMPOLUNICO ||cLimitador||
                  X.ASISTENCIA	||cLimitador||
                  X.SINIESTRO		||cLimitador||
                  X.MONTO				||cLimitador||
                  X.ARCHIVO	    ||cLimitador||
                  X.FACTURA		  ||cLimitador||
                  X.ID_CARGA		;--||chr(13);  synchronize;	
             
    ELSE
       cCadena := '<tr>' ||
                  OC_ARCHIVO.CAMPO_HTML(X.REGISTRO,'C')    ||
                  OC_ARCHIVO.CAMPO_HTML(X.POLIZA,'C')      ||
                  OC_ARCHIVO.CAMPO_HTML(X.NUMPOLUNICO,'C') ||
                  OC_ARCHIVO.CAMPO_HTML(X.ASISTENCIA,'C')  ||
                  OC_ARCHIVO.CAMPO_HTML(X.SINIESTRO,'C')   ||
                  OC_ARCHIVO.CAMPO_HTML(X.MONTO,'C')       ||
                  OC_ARCHIVO.CAMPO_HTML(X.ARCHIVO,'C')     ||
                  OC_ARCHIVO.CAMPO_HTML(X.FACTURA,'C')     || 
                  OC_ARCHIVO.CAMPO_HTML(X.ID_CARGA,'C')    || '</tr>';                 
    END IF;
    nLinea := nLinea + 1;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END LOOP; 
   
     nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     
       nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
      nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     
     
      
     nLinea  := nLinea + 1;
     cCadena := '<tr>
     <th colspan=3>  ELABORÓ    </th>
     <th colspan=2>  AUTORIZÓ    </th>
     <th colspan=3>  REGISTRÓ    </th>                
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     
       nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
      nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
      
    
      
     nLinea  := nLinea + 1;
     cCadena := '<tr>
     <th style="border:none;" colspan=3>  ________________    </th>
     <th style="border:none;" colspan=2>  ________________    </th>
     <th style="border:none;" colspan=3>  ________________    </th>                
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
         nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
       
     IF USUSARIO = 'EVALENCI'  THEN
     	     cCadena := '<tr>
			     <th colspan=3> EDUARDO VALENCIA</th>
			     <th colspan=2>Jocelyn Vizuet Rayón</th>
			     <th colspan=3>Alipio Hernández García</th>                
			     </tr>';      
			     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
          
     ELSIF USUSARIO = 'EESTRADA'  THEN
         	 cCadena := '<tr>
			     <th colspan=3> ERIKA ESTRADA</th>
			     <th colspan=2>Jocelyn Vizuet Rayón</th>
			     <th colspan=3>Alipio Hernández García</th>                
			     </tr>';      
			     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         	
         
     ELSIF USUSARIO = 'JACEMAN'  THEN	
     	    cCadena := '<tr>
			     <th colspan=3>JACQUELINNE ESCOBAR MANCILLA</th>
			     <th colspan=2>Jocelyn Vizuet Rayón</th>
			     <th colspan=3>Alipio Hernández García</th>                
			     </tr>';      
			     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
 	    
     ELSE     	
    	
     cCadena := '<tr>
     <th colspan=3> JACQUELINNE ESCOBAR MANCILLA</th>
     <th colspan=2> '||cAutoriza||'
     </th>
     <th colspan=3>Alipio Hernández García</th>                
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     END IF; 	
     
     
         
         
      nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     nLinea  := nLinea + 1;
     cCadena := '<tr>
     <th colspan=3>       ANALISTA    </th>
     <th colspan=2>  SINIESTROS VIDA Y ACCIDENTES PERSONALES  </th>
     <th colspan=3>       CONTABILIDAD </th>                
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     
     
  ---- // CIERRE DEL ARCHIVO  //    
  IF cFormato = 'EXCEL' THEN
--     OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
     cCadena := '</table></div></html>';
     nLinea:= nLinea + 1;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END IF;
  OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
EXCEPTION 
  WHEN OTHERS THEN 
    OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
    raise_application_error(-20105,'Error en Generación Reporte PAGOS APROBADOS  de Siniestros: '|| ' ' ||SQLERRM);  
    
END;
PROCEDURE CARGA_MASIVOS (cNomArchivo VARCHAR2, 
                         cRFC        VARCHAR2,
                         cAutoriza VARCHAR2,cFormato    VARCHAR2,nIdReporte  NUMBER) IS
cLimitador      VARCHAR2(1) :='|';
--nLinea          NUMBER;
cCadena         VARCHAR2(4000);
cCodUser        VARCHAR2(30);
nDummy          NUMBER;
cCopy           BOOLEAN;
--
--vFile            CLIENT_TEXT_IO.FILE_TYPE;
cLinea           VARCHAR2(4000);
nIdProcMasivo    PROCESOS_MASIVOS.IdProcMasivo%TYPE;
Dummy            NUMBER;
cRegDatosProc    VARCHAR2(4000);
cCodEmpresa      VARCHAR2(15);
cIdTipoSeg       DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob         DETALLE_POLIZA.PlanCob%TYPE;
cNumDetUnico     PROCESOS_MASIVOS.NumDetUnico%TYPE;
cNumPolUnico     PROCESOS_MASIVOS.NumPolUnico%TYPE;
nNumDetUnico     DETALLE_POLIZA.IDetPol%TYPE;
nIdPoliza        POLIZAS.IdPoliza%TYPE;
nCod_Asegurado   ASEGURADO.Cod_Asegurado%TYPE;
nCodCliente      POLIZAS.CodCliente%TYPE;
cCargaRegistro   VARCHAR2(1);
cConteoCarga     NUMBER(10)    := 0;
nLinea           NUMBER        := 0;
cArchError       VARCHAR2(100) := NULL;
cMotivAnul       POLIZAS.MOTIVANUL%TYPE;
cStsPoliza       POLIZAS.StsPoliza%TYPE;
cMsgArchErr      VARCHAR2(100);
cTipoEvento      VARCHAR2(40);
cNumReferencia   VARCHAR2(40);
cNumSiniRef      SINIESTRO.NumSiniRef%TYPE;
nIdCredito       INFO_ALTBAJ.Id_Credito%TYPE;
nIdTrabaj        INFO_ALTBAJ.Id_Trabajador%TYPE;
cIdCredThona     INFO_ALTBAJ.Id_Credito_Thona%TYPE;
W_ID_ENVIO       INFO_SINIESTRO.ID_ENVIO%TYPE;
WC_CARGA         NUMBER;
--
-------  AEVS   -----
WI_ARCHIVO_REPORTE VARCHAR2(1000);
--ARCHIVO_REPORTE    CLIENT_TEXT_IO.FILE_TYPE;
W_LINEA_REPORTE    VARCHAR2(1000);
INICIO             VARCHAR2(50);
W_IDSINIESTRO      SINIESTRO.IDSINIESTRO%TYPE;    --  AEVS  NUEVO FLUJO LAYOUT CORTO
--ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;
LINEA_SALIDA       VARCHAR2(5000);
WI_ARCHIVO_SALIDA  VARCHAR2(2000);    
muestralerta       number;
DESC_TPO_PROCESO   VARCHAR2(80);
USUSARIO           varchar2(50);
TERMINAL           varchar2(50);
TIPO               VARCHAR2(20):= 'CARGA';
RutaMagica         VARCHAR2(200);  
W_PROCESOS         varchar2(6);
W_MONTO            COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
PasasManito        Number;
nNombreArchivo     VARCHAR2(200);  
W_POLIZA           POLIZAS.IdPoliza%TYPE; 
W_MOVIMIENTO       VARCHAR2(6);
W_CODASEG          ASEGURADO.Cod_Asegurado%TYPE;
W_NUMAPROB         NUMBER;
PlanDeCobro        VARCHAR2(20);
nINDPOLCOL         VARCHAR2(10);
NumRegistro        NUMBER := 0;    
---
W_IDCARGA          PROCESOS_MASIVOS_SEGUIMIENTO.IDPROCMASIVO%TYPE; 
W_POLCONTA_GG      PROCESOS_MASIVOS_SEGUIMIENTO.POLCONTA_GG%TYPE; 
W_FECHA_PAGO       PROCESOS_MASIVOS_SEGUIMIENTO.FECHA_PAGO%TYPE;   
W_IMPORT_PAGO      PROCESOS_MASIVOS_SEGUIMIENTO.IMPORT_PAGO%TYPE;
HABEMUSPAGUS       NUMBER := 0; 
existes            NUMBER := 0; 
Error              NUMBER := 0; 
WNUM_APROBACION    PROCESOS_MASIVOS_SEGUIMIENTO.NUM_APROBACION%TYPE; 
WIDSINIESTRO       PROCESOS_MASIVOS_SEGUIMIENTO.IDSINIESTRO%TYPE; 
WIDPOLIZA          PROCESOS_MASIVOS_SEGUIMIENTO.IDPOLIZA%TYPE; 
            
Proveedor          SAI_CAT_GENERAL.cage_nom_reg%TYPE;
cMontoTotal        PROCESOS_MASIVOS_SEGUIMIENTO.MONTOPAGAR%TYPE;
   
WFECHA             DATE ;   
BEGIN
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	

  
   IF cFormato = 'TEXTO' THEN    
     ---- // TITULOS //
     nLinea := 1; 
     cCadena     := 'THONA SEGUROS, S.A. de C.V.' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea := nLinea + 1;
     cCadena     := 'FONDEO DE PAGOS COLECTIVOS' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     --
     nLinea  := nLinea + 1;
     cCadena := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := 'FECHA'                 ||cLimitador||'RAMO'          ||cLimitador||'NUMERO DE SINIESTRO'     || cLimitador ||
                'NOMBRE_BENEFICIARIO'   ||cLimitador||'MONTO DE PAGO '||cLimitador||'TIPO DE PAGO'||cLimitador||'NOMBRE DEL CONTRATANTE'||cLimitador  ||'USUARIO ';--||chr(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  ELSE
     ---- // FORMATO EXCEL //
     nLinea  := 1;
     cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                ' <style id="libro">'||chr(10)||
                '   <!--table'||chr(10)||
                '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                '        .texto'||chr(10)||
                '          {mso-number-format:"\@";}'||chr(10)||
                '        .numero'||chr(10)||
                '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                '        .fecha'||chr(10)||
                '          {mso-number-format:"dd\\-mm\\-yy";}'||chr(10)||
                '    -->'||chr(10)||
                ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     ---- // TITULOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
     nLinea  := nLinea + 1;
     cCadena := '<tr><th>FONDEO DIARIO DE PAGOS DE CARGAS MASIVAS'||'</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     --
      ---- // ENCABEZADOS //
     nLinea  := nLinea + 1;
     cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RAMO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE SINIESTRO</font></th>' ||                
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE DEL BENEFICIARIO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DEL PAGO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE PAGO</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE DEL CONTRATANTE.</font></th>' ||
                '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO</font></th></tr>';
   
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END IF;
 
       cCadena := '<tr>' ||
                  OC_ARCHIVO.CAMPO_HTML(WFECHA,'C')                   ||
                  OC_ARCHIVO.CAMPO_HTML('AP','C')                     ||
                  OC_ARCHIVO.CAMPO_HTML(' ','C')                      ||
                  OC_ARCHIVO.CAMPO_HTML(Proveedor,'C')                ||
                  OC_ARCHIVO.CAMPO_HTML(cMontoTotal,'C')              ||
                  OC_ARCHIVO.CAMPO_HTML('TRANSFERENCIA BANCARIA','D') ||
                  OC_ARCHIVO.CAMPO_HTML(Proveedor,'C')                ||
                  OC_ARCHIVO.CAMPO_HTML(USUSARIO,'C')       || '</tr>';
                                   
 
    nLinea := nLinea + 1;
    OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
    
  
   nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     
       nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
      nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      
     nLinea  := nLinea + 1;
     cCadena := '<tr>
     <th colspan=3>  ELABORÓ    </th>
     <th colspan=2>  AUTORIZÓ    </th>
     <th colspan=3>  REGISTRÓ    </th>                
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     
       nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
      nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      
     nLinea  := nLinea + 1;
     cCadena := '<tr>
     <th style="border:none;" colspan=3>  ________________    </th>
     <th style="border:none;" colspan=2>  ________________    </th>
     <th style="border:none;" colspan=3>  ________________    </th>                
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
         nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
          
         IF USUSARIO = 'EVALENCI'  THEN
     	     cCadena := '<tr>
			     <th colspan=3> EDUARDO VALENCIA</th>
			     <th colspan=2>Jocelyn Vizuet Rayón</th>
			     <th colspan=3>Alipio Hernández García</th>                
			     </tr>';      
			     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
          
     ELSIF USUSARIO = 'EESTRADA'  THEN
         	 cCadena := '<tr>
			     <th colspan=3> ERIKA ESTRADA</th>
			     <th colspan=2>Jocelyn Vizuet Rayón</th>
			     <th colspan=3>Alipio Hernández García</th>                
			     </tr>';      
			     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
         	
         
     ELSIF USUSARIO = 'JACEMAN'  THEN	
     	    cCadena := '<tr>
			     <th colspan=3>JACQUELINNE ESCOBAR MANCILLA</th>
			     <th colspan=2>Jocelyn Vizuet Rayón</th>
			     <th colspan=3>Alipio Hernández García</th>                
			     </tr>';      
			     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
 	    
     ELSE     	
    	
     cCadena := '<tr>
     <th colspan=3> JACQUELINNE ESCOBAR MANCILLA</th>
     <th colspan=2> '||cAutoriza||'
     </th>
     <th colspan=3>Alipio Hernández García</th>                
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     END IF; 	
     
         
         
      nLinea  := nLinea + 1;
     cCadena := '<tr>                    
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     nLinea  := nLinea + 1;
     cCadena := '<tr>
     <th colspan=3>       ANALISTA    </th>
     <th colspan=2>  SINIESTROS VIDA Y ACCIDENTES PERSONALES  </th>
     <th colspan=3>       CONTABILIDAD </th>                
     </tr>';      
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     
     
     
  ---- // CIERRE DEL ARCHIVO  //    
  IF cFormato = 'EXCEL' THEN
--     OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
     cCadena := '</table></div></html>';
     nlinea:=nlinea + 1;
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  END IF;
  OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
EXCEPTION 
  WHEN OTHERS THEN 
  OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
  raise_application_error(-20105,'Error General  Proceso: CARGA_MASIVOS '||SQLERRM);
END; 
PROCEDURE GENERAR_PAGOSSIN_CIERRE_SOL (cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cCodMoneda VARCHAR2, 
                                       dFecDesde DATE, dFecHasta DATE, cTipoPago IN VARCHAR2,
                                       cFormato    VARCHAR2,nIdReporte  NUMBER) IS
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
nCodCia            POLIZAS.codcia%TYPE;
nCodEmpresa        DETALLE_POLIZA.CodEmpresa%TYPE;
cCodPlantilla      CONFIG_PLANTILLAS_PLANCOB.CodPlantilla%TYPE := 'EMITESINIESTRO';
--ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE;
NVO_MNTO_PAGADO    COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
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
cNomArchCarga			 VARCHAR2(100);
cNomArchLogem			 VARCHAR2(100);
dFecCarga					 DATE;
cUUID						   FACTURA_EXTERNA.UUID%TYPE;
nIdProcMasivo			 PROCESOS_MASIVOS_SEGUIMIENTO.IDPROCMASIVO%TYPE;	
nMontoNetoLocal		 NUMBER(28,2);
nMontoNetoMoneda	 NUMBER(28,2);	 			 	 			 
nMontoHonoLocal		 NUMBER(28,2);
nMontoHonoMoneda	 NUMBER(28,2);
nMontoHospLocal		 NUMBER(28,2);
nMontoHospMoneda	 NUMBER(28,2);
nMontoOtrGtoLocal	 NUMBER(28,2);
nMontoOtrGtoMoneda NUMBER(28,2);
nMontoDctoLocal		 NUMBER(28,2);
nMontoDctoMoneda	 NUMBER(28,2);
nMontoDeducLocal	 NUMBER(28,2);
nMontoDeducMoneda	 NUMBER(28,2);
--
cPolizaCont        VARCHAR2(50);
--
CURSOR PAGOSSIN_Q IS
  SELECT /*+ RULE +*/ 
         '' IdTransaccion,
         SI.IdPoliza, 
         OC_POLIZAS.NUMERO_UNICO(SI.CodCia, SI.IdPoliza) PolUnik, 
         SI.IdSiniestro,
         DAA.COD_PAGO,  
         TRUNC(A.FECPAGO) FechaMvto, 
         TO_CHAR(TRUNC(A.FECPAGO),'DD/MM/YYYY') cFechaMvto, 
         A.Num_Aprobacion, 
         A.Tipo_Aprobacion, 
         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', cTipoPago) Estatus, --JICO
         --OC_DETALLE_APROBACION.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1) CodTransac,
         --OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(SI.CodCia, OC_DETALLE_APROBACION.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)) DescTransac,
         --OC_DETALLE_APROBACION.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1) CodCptoTransac,
         --OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(SI.CodCia, OC_DETALLE_APROBACION.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)) DescripConcepto,
         -- MLJS 20/07/2021 SE MODIFICO PARA QUE SE DSPLIEGUEN LOS PAGOS EN SOL SIN DETALLE 
         DECODE(NVL(DAA.Num_Aprobacion,0),0,NULL,OC_DETALLE_APROBACION.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)) CodTransac,
         DECODE(NVL(DAA.Num_Aprobacion,0),0,NULL,OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(SI.CodCia, OC_DETALLE_APROBACION.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1))) DescTransac,
         DECODE(NVL(DAA.Num_Aprobacion,0),0,NULL,OC_DETALLE_APROBACION.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)) CodCptoTransac,
         DECODE(NVL(DAA.Num_Aprobacion,0),0,NULL,OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(SI.CodCia, OC_DETALLE_APROBACION.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1))) DescripConcepto,
         -- MLJS 20/07/2021
         '' NumTrx, 
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
         SUM(A.Monto_Moneda) Pgo_Neto_Mon_Orig,  --JICO
         SUM(A.Monto_Local) Pago_Neto_Mon_Loc,  --JICO
         NVL(SI.Monto_Reserva_Moneda,0) - NVL(SI.Monto_Pago_Moneda,0) OPC_Moneda,
         NVL(SI.Monto_Reserva_Local,0) - NVL(SI.Monto_Pago_Local,0) OPC_Local,
         '' Usuario, 
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
         SUM(A.Monto_Moneda) WMonto,
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
         OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE) NOMCONTRA,
         PP.CODAGRUPADOR
    FROM --TRANSACCION T,           --MLJS 20/07/2021
         --DETALLE_TRANSACCION D,   --MLJS 20/07/2021
         APROBACIONES A,   
         SINIESTRO SI, 
         DETALLE_SINIESTRO DS,
         POLIZAS_TEXTO_COTIZACION  TXT,
         CATEGORIAS                CGO,
         POLIZAS                   PP,
         DETALLE_APROBACION        DAA   --JICO AGREGADO        
   WHERE TRUNC(A.FECPAGO) BETWEEN dFecDesde
                              AND dFecHasta         
     AND A.StsAprobacion  = cTipoPago
     AND A.Num_Aprobacion > 0
     --
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
     --AND DAA.IDSINIESTRO    = A.IdSiniestro  --JICO
     --AND DAA.NUM_APROBACION = A.NUM_APROBACION  --JICO
     --AND DAA.COD_PAGO       NOT IN ('DEDUC','IMPTO','RETENC') --JICO      
     -- MLJS 20/07/2021 MODIFICADO PARA QUE SE DESPLIEGUE LOS PAGOS QUE NO TIENEN DETALLE
     AND DAA.IDSINIESTRO   (+) = A.IdSiniestro  
     AND DAA.NUM_APROBACION(+) = A.NUM_APROBACION  
     AND DAA.COD_PAGO      (+) NOT IN ('DEDUC','IMPTO','RETENC') 
     -- MLJS 20/07/2021 
  GROUP BY
         '', 
         SI.IdPoliza, 
         OC_POLIZAS.NUMERO_UNICO(SI.CodCia, SI.IdPoliza),-- PolUnik, 
         SI.IdSiniestro,
         DAA.COD_PAGO,  
         TRUNC(A.FECPAGO),-- FechaMvto, 
         TO_CHAR(TRUNC(A.FECPAGO),'DD/MM/YYYY'),-- cFechaMvto, 
         A.Num_Aprobacion, 
         A.Tipo_Aprobacion, 
         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', cTipoPago),-- Estatus, --JICO
         --OC_DETALLE_APROBACION.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1),-- CodTransac,
         --OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(SI.CodCia, OC_DETALLE_APROBACION.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)),-- DescTransac,
         --OC_DETALLE_APROBACION.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1),-- CodCptoTransac,
         --OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(SI.CodCia, OC_DETALLE_APROBACION.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)),-- DescripConcepto,
         -- MLJS 20/07/2021 SE MODIFICO PARA QUE SE DSPLIEGUEN LOS PAGOS EN SOL SIN DETALLE 
         DECODE(NVL(DAA.Num_Aprobacion,0),0,NULL,OC_DETALLE_APROBACION.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)),-- CodTransac,
         DECODE(NVL(DAA.Num_Aprobacion,0),0,NULL,OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(SI.CodCia, OC_DETALLE_APROBACION.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1))),-- DescTransac,
         DECODE(NVL(DAA.Num_Aprobacion,0),0,NULL,OC_DETALLE_APROBACION.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)),-- CodCptoTransac,
         DECODE(NVL(DAA.Num_Aprobacion,0),0,NULL,OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(SI.CodCia, OC_DETALLE_APROBACION.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1))),-- DescripConcepto,
         -- MLJS 20/07/2021
         '',-- NumTrx, 
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
         '',-- Usuario, 
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
         --
         OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE),
         PP.CODAGRUPADOR
--
UNION
--
  SELECT /*+ RULE +*/ 
         '' IdTransaccion,
         SI.IdPoliza, 
         OC_POLIZAS.NUMERO_UNICO(SI.CodCia, SI.IdPoliza) PolUnik, 
         SI.IdSiniestro,
         DAA.COD_PAGO,   --JICO
         TRUNC(A.FECPAGO) FechaMvto, 
         TO_CHAR(TRUNC(A.FECPAGO),'DD/MM/YYYY') cFechaMvto,  
         A.Num_Aprobacion, 
         A.Tipo_Aprobacion, 
         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', cTipoPago) Estatus, --JICO
         --OC_DETALLE_APROBACION_ASEG.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1) CodTransac,
         --OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(SI.CodCia, OC_DETALLE_APROBACION_ASEG.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)) DescTransac,
         --OC_DETALLE_APROBACION_ASEG.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1) CodCptoTransac,
         --OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(SI.CodCia, OC_DETALLE_APROBACION_ASEG.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)) DescripConcepto,
         -- MLJS 20/07/2021 SE MODIFICO PARA QUE SE DSPLIEGUEN LOS PAGOS EN SOL SIN DETALLE 
         DECODE(NVL(DAA.Num_Aprobacion,0),0,NULL,OC_DETALLE_APROBACION_ASEG.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)) CodTransac,
         DECODE(NVL(DAA.Num_Aprobacion,0),0,NULL,OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(SI.CodCia, OC_DETALLE_APROBACION_ASEG.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1))) DescTransac,
         DECODE(NVL(DAA.Num_Aprobacion,0),0,NULL,OC_DETALLE_APROBACION_ASEG.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)) CodCptoTransac,
         DECODE(NVL(DAA.Num_Aprobacion,0),0,NULL,OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(SI.CodCia, OC_DETALLE_APROBACION_ASEG.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1))) DescripConcepto,
         -- MLJS 20/07/2021 SE MODIFICO PARA QUE SE DSPLIEGUEN LOS PAGOS EN SOL SIN DETALLE
         '' NumTrx, 
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
          SUM(A.Monto_Moneda) Pgo_Neto_Mon_Orig,  --JICO
          SUM(A.Monto_Local) Pago_Neto_Mon_Loc,  --JICO
          NVL(SI.Monto_Reserva_Moneda,0) - NVL(SI.Monto_Pago_Moneda,0) OPC_Moneda,
          NVL(SI.Monto_Reserva_Local,0) - NVL(SI.Monto_Pago_Local,0) OPC_Local,
          '' Usuario, 
          DS.IdTipoSeg TipoSeguro, 
          DS.IdDetSin, 
          0 Asegurado, 
          SI.NumSiniRef, 
          A.Benef,
          SI.CodCia, 
          SI.CodEmpresa, 
          TO_CHAR(PMS.Crga_FechaComp,'DD/MM/YYYY HH24:MI:SS') FecCarga,
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
          SUM(A.Monto_Moneda) WMonto,
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
          OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE) NOMCONTRA,
          PP.CODAGRUPADOR
     FROM APROBACION_ASEG A,   
          SINIESTRO SI, 
          DETALLE_SINIESTRO_ASEG DS, 
          PROCESOS_MASIVOS_SEGUIMIENTO PMS,
          POLIZAS_TEXTO_COTIZACION  TXT,
          CATEGORIAS                CGO,
          POLIZAS                   PP,
          DETALLE_APROBACION_ASEG   DAA
    WHERE TRUNC(A.FECPAGO) BETWEEN dFecDesde
                               AND dFecHasta         
      AND A.StsAprobacion  = cTipoPago
      AND A.Num_Aprobacion > 0
      --      
      AND SI.IdSiniestro            = A.IdSiniestro
      AND DS.IdSiniestro            = SI.IdSiniestro
      AND DS.IdDetSin               = A.IdDetSin
      AND DS.Cod_Asegurado          = SI.Cod_Asegurado
      AND PMS.CodCia           (+) = 1 --:PARAMETER.nCodCia  --JICO
      AND PMS.CodEmpresa       (+) = 1 --:PARAMETER.nCodEmpresa   --JICO
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
      --AND DAA.IDSINIESTRO    = A.IdSiniestro  --JICO
      --AND DAA.NUM_APROBACION = A.NUM_APROBACION  --JICO
      --AND DAA.COD_PAGO       NOT IN ('DEDUC','IMPTO','RETENC') --JICO  
      -- MLJS 20/07/2021 MODIFICADO PARA QUE SE DESPLIEGUE LOS PAGOS QUE NO TIENEN DETALLE
      AND DAA.IDSINIESTRO   (+) = A.IdSiniestro  
      AND DAA.NUM_APROBACION(+) = A.NUM_APROBACION  
      AND DAA.COD_PAGO      (+) NOT IN ('DEDUC','IMPTO','RETENC') 
      -- MLJS 20/07/2021  
     GROUP BY 
         '' ,
         SI.IdPoliza, 
         OC_POLIZAS.NUMERO_UNICO(SI.CodCia, SI.IdPoliza),-- PolUnik, 
         SI.IdSiniestro,
         DAA.COD_PAGO,   --JICO
         TRUNC(A.FECPAGO),-- FechaMvto, 
         TO_CHAR(TRUNC(A.FECPAGO),'DD/MM/YYYY'),-- cFechaMvto,  
         A.Num_Aprobacion, 
         A.Tipo_Aprobacion, 
         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', cTipoPago),-- Estatus, --JICO
         --OC_DETALLE_APROBACION_ASEG.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1),-- CodTransac,
         --OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(SI.CodCia, OC_DETALLE_APROBACION_ASEG.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)),-- DescTransac,
         --OC_DETALLE_APROBACION_ASEG.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1),-- CodCptoTransac,
         --OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(SI.CodCia, OC_DETALLE_APROBACION_ASEG.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)),-- DescripConcepto,
         -- MLJS 20/07/2021 SE MODIFICO PARA QUE SE DSPLIEGUEN LOS PAGOS EN SOL SIN DETALLE 
         DECODE(NVL(DAA.Num_Aprobacion,0),0,NULL,OC_DETALLE_APROBACION_ASEG.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)), -- CodTransac,
         DECODE(NVL(DAA.Num_Aprobacion,0),0,NULL,OC_CONFIG_TRANSAC_SINIESTROS.DESCRIPCION_TRANSACCION(SI.CodCia, OC_DETALLE_APROBACION_ASEG.CODIGO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1))),-- DescTransac,
         DECODE(NVL(DAA.Num_Aprobacion,0),0,NULL,OC_DETALLE_APROBACION_ASEG.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1)),-- CodCptoTransac,
         DECODE(NVL(DAA.Num_Aprobacion,0),0,NULL,OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(SI.CodCia, OC_DETALLE_APROBACION_ASEG.CONCEPTO_TRANSACCCION(SI.IdSiniestro, A.Num_Aprobacion, 1))),-- DescripConcepto,
         -- MLJS 20/07/2021
         '',-- NumTrx, 
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
          '',-- Usuario, 
          DS.IdTipoSeg,-- TipoSeguro, 
          DS.IdDetSin, 
          0,-- Asegurado, 
          SI.NumSiniRef, 
          A.Benef,
          SI.CodCia, 
          SI.CodEmpresa, 
          TO_CHAR(PMS.Crga_FechaComp,'DD/MM/YYYY HH24:MI:SS'),-- FecCarga,
          PMS.CRGA_NOM_ARCHIVO,-- NomArchCarga, 
          PMS.MontoIva,-- MontoIva, 
          PMS.MontoISR,-- MontoISR,
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
          OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE),
          PP.CODAGRUPADOR
     ORDER BY 5, 3, 6, 4
;
--
CURSOR PAGO_Q  IS
   SELECT C.NomCampo, C.OrdenCampo, C.OrdenProceso, C.OrdenDatoPart
     FROM CONFIG_PLANTILLAS_CAMPOS C
    WHERE C.CodPlantilla = cCodPlantilla
      AND C.CodEmpresa   = nCodEmpresa
      AND C.CodCia       = nCodCia
      AND C.NomTabla     = 'DATOS_PART_SINIESTROS'
      AND C.IndDatoPart  = 'S'
    ORDER BY OrdenDatoPart,OrdenCampo;
BEGIN
	--
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
  --
  IF cFormato = 'TEXTO' THEN
      nLinea := 1;
      cCadena     := 'THONA SEGUROS, S.A. de C.V.' || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);          
      nLinea := nLinea + 1;
      cCadena     := 'REPORTE DIARIO DE PAGOS' || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);       
      nLinea  := nLinea + 1;
      cCadena := 'PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' AL ' || TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecDesde,'Month') ||
                 ' DE ' || TO_CHAR(dFecDesde,'YYYY') || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);         
      nLinea  := nLinea + 1;
      cCadena := ' ' || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);         
      nLinea  := nLinea + 1;
      cCadena := 'NUMERO POLIZA'          ||cLimitador||
                 'NO. POLIZA UNICO'       ||cLimitador||
                 'NÚMERO DE REFERENCIA'   ||cLimitador||
                 'NO. SINIESTRO'          ||cLimitador||
                 'COBERTURA'              ||cLimitador||
                 'FECHA MOVIMIENTO'       ||cLimitador||
                 'NO. APROB.'             ||cLimitador||
                 'TIPO APROBACION'        ||cLimitador||
                 'ESTATUS'                ||cLimitador||
                 'TRANSACCION'            ||cLimitador||
                 'DESCRIPCION TRANSACCION'||cLimitador||
                 'CONCEPTO'               ||cLimitador||
                 'NUMERO DE TRANSACCION'  ||cLimitador||
                 'FECHA ESTIMACION'       ||cLimitador||
                 'MONEDA'                 ||cLimitador||
                 'TIPO DE CAMBIO'         ||cLimitador||
                 'PAGO MON ORIGINAL'      ||cLimitador||
                 'PAGO MON NACIONAL'      ||cLimitador||
                 'IVA MON ORIGINAL'       ||cLimitador||
                 'IVA MON NACIONAL'       ||cLimitador||
                 'ISR RET MON ORIGINAL'   ||cLimitador||
                 'ISR RET MON NACIONAL'   ||cLimitador||
                 'IVA RET MON ORIGINAL'   ||cLimitador||
                 'IVA RET MON NACIONAL'   ||cLimitador||
                 'PAGO NETO MON ORIGINAL' ||cLimitador||
                 'PAGO NETO MON NACIONAL' ||cLimitador||
                 'OPC MON ORIGINAL'       ||cLimitador||
                 'OPC MON NACIONAL'       ||cLimitador||
                 'BANCO'                  ||cLimitador||
                 'NUM CHEQUE O CUENTA CLABE'||cLimitador||
                 'OPERO'                  ||cLimitador||
                 'TASA IVA'               ||cLimitador||
                 'COD. ASEGURADO'         ||cLimitador||
                 'BENEFICIARIO'           ||cLimitador||
                 'RFC BENEFICIARIO'       ||cLimitador||
                 'NOMBRE_ARCH_CARGA'      ||cLimitador|| 
                 'NOMBRE ARCHIVO LOGEM'   ||cLimitador||
                 'FECHA DE CARGA'         ||cLimitador||
                 'TIPO DE SEGURO'         ||cLimitador|| 
                 'NUMERO DE FACTURA'      ||cLimitador||
                 'ID CARGA MASIVA'        ||cLimitador||
                 'POLIZA CONTABLE PGO GG' ||cLimitador||
                 'FECHA DE PAGO GG'       ||cLimitador||
                 'IMPORTE DEL PAGO'       ||cLimitador|| 
                 'ARCHIVO PGO-GG'         ||cLimitador|| 
                 'USUARIO CARGA PGO-GG'   ||cLimitador|| 
                 'FECHA - HORA DE CARGA'  ||cLimitador||
                 'OBSERVACIONES POLIZA GG'||cLimitador||
                 'MONTO DE PAGO'          ||cLimitador||
					       'Es Contributorio'       ||cLimitador||
					       '% Contributorio'        ||cLimitador||
					       'Giro de Negocio'        ||cLimitador||
					       'Tipo de Negocio'        ||cLimitador||
					       'Fuente de Recursos'     ||cLimitador||
					       'Paquete Comercial'      ||cLimitador||
					       'Categoria'              ||cLimitador||
					       'Canal de Venta'         ||cLimitador||
					       'POLIZA CONTABLE'        ||cLimitador||
					       'CONTRATANTE'            ||cLimitador||
					       'AGRUPADOR';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);         
  ELSE
      nLinea  := 1;
      cCadena := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                 ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                 ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                 ' <style id="libro">'||chr(10)||
                 '   <!--table'||chr(10)||
                 '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                 '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                 '        .texto'||chr(10)||
                 '          {mso-number-format:"\@";}'||chr(10)||
                 '        .numero'||chr(10)||
                 '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                 '        .fecha'||chr(10)||
                 '          {mso-number-format:"dd\\/mm\\/yyyy";}'||chr(10)||
                 '    -->'||chr(10)||
                 ' </style><div id="libro">'||chr(10);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);         
      nLinea  := nLinea + 1;
      cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);          
      nLinea  := nLinea + 1;
      cCadena := '<tr><th>REPORTE DIARIO DE PAGOS'||'</th></tr>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);        
      nLinea  := nLinea + 1;
      cCadena := '<tr><th>PERIODO DEL ' || TO_CHAR(dFecDesde,'DD') || ' DE ' || TO_CHAR(dFecDesde,'MONTH') || ' AL ' ||
                 TO_CHAR(dFecHasta,'DD') || ' DE '|| TO_CHAR(dFecDesde,'MONTH') || ' DE ' || TO_CHAR(dFecDesde,'YYYY') || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);                   
      nLinea  := nLinea + 1;
      cCadena := '<tr><th>  </th></tr></table>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);         
      nLinea  := nLinea + 1;
      cCadena := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO POLIZA</font></th>' ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. POLIZA UNICO</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NÚMERO DE REFERENCIA</font></th>'		 						||                
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. SINIESTRO</font></th>' 											||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COBERTURA</font></th>' 													||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA MOVIMIENTO</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO. APROB.</font></th>' 													||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO APROBACION</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ESTATUS</font></th>' 														||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TRANSACCION</font></th>' 												||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCRIPCION TRANSACCION</font></th>' 						||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CONCEPTO</font></th>' 														||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE TRANSACCION</font></th>' 							||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA ESTIMACION</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONEDA</font></th>' 															||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE CAMBIO</font></th>' 											||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO MON ORIGINAL</font></th>' 									||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO MON NACIONAL</font></th>' 									||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">GASTOS HONORARIOS ORIGINAL</font></th>' 					||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">GASTOS HONORARIOS NACIONAL</font></th>' 					||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">GASTOS HOSPITALARIOS ORIGINAL</font></th>' 			||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">GASTOS HOSPITALARIOS NACIONAL</font></th>' 			||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OTROS GASTOS ORIGINAL</font></th>' 							||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OTROS GASTOS NACIONAL</font></th>' 							||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCUENTO ORIGINAL</font></th>' 									||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCUENTO NACIONAL</font></th>' 									||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DEDUCIBLE ORIGINAL</font></th>' 									||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DEDUCIBLE NACIONAL</font></th>' 									||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA MON ORIGINAL</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA MON NACIONAL</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ISR RET MON ORIGINAL</font></th>' 								||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ISR RET MON NACIONAL</font></th>' 								||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA RET MON ORIGINAL</font></th>' 								||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IVA RET MON NACIONAL</font></th>' 								||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IMP LOCAL RET ORIGINAL</font></th>' 							||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IMP LOCAL RET NACIONAL</font></th>' 							||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO NETO MON ORIGINAL</font></th>' 							||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO NETO MON NACIONAL</font></th>' 							||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPC MON ORIGINAL</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPC MON NACIONAL</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">BANCO</font></th>' 															||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUM CHEQUE O CUENTA CLABE</font></th>' 					||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPERO</font></th>' 															||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TASA IVA</font></th>' 														||                 
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COD ASEGURADO</font></th>'; 
      cCadenaAux:= 
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">BENEFICIARIO</font></th>' 												||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RFC BENEFICIARIO</font></th>' 										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE_ARCH_CARGA</font></th>' 									||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE ARCHIVO LOGEM</font></th>' 								||                
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE CARGA</font></th>' 											||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">TIPO DE SEGURO</font></th>' 											||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMERO DE FACTURA</font></th>' 									||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ID CARGA MASIVA</font></th>'											||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA CONTABLE PGO GG</font></th>'							||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA DE PAGO GG</font></th>'										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">IMPORTE DEL PAGO</font></th>'										||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ARCHIVO PGO-GG</font></th>'											||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">USUARIO CARGA PGO-GG</font></th>'								||                
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FECHA - HORA DE CARGA</font></th>'								||               
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OBSERVACIONES POLIZA GG</font></th>'							||                 
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">MONTO DE PAGO</font></th></th>'                  ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Es Contributorio 1</font></th>'                  ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Contributorio</font></th>'                     ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Giro de Negocio</font></th>'                     ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de Negocio</font></th>'                     ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fuente de Recursos</font></th>'                  ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Paquete Comercial</font></th>'                   ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Categoria</font></th>'                           ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Canal de Venta</font></th>'                      ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">POLIZA CONTABLE</font></th>'                     ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CONTRATANTE</font></th>'                         ||
                 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">AGRUPADOR</font></th>';
      --
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);        
      OC_ARCHIVO.Escribir_Linea(cCadenaAux, cCodUser, nLinea);
      --        
  END IF;
  -- 
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
         SELECT	( X.PGO_MON_ORIG * -1)
           INTO NVO_MNTO_PAGADO
           FROM DUAL; 
         --
		     cValorCampoIVA     := X.IVA_MONEDA 			* - 1;
         cValorCampoISR     := X.ISR_MONEDA 			* - 1;
         nMontoNetoLocal    := X.PAGO_NETO_MON_LOC * -1;
         nMontoNetoMoneda   := X.PGO_NETO_MON_ORIG * -1;
         nMontoHonoLocal    := X.Gto_Hon_Local 		* -1;
			   nMontoHonoMoneda   := X.Gto_Hon_Moneda 	* -1;
		 		 nMontoHospLocal    := X.Gto_Hos_Local 		* -1;
				 nMontoHospMoneda   := X.Gto_Hos_Moneda 	* -1;
				 nMontoOtrGtoLocal  := X.Gto_Otr_Local		* -1;
				 nMontoOtrGtoMoneda := X.Gto_Otr_Moneda		* -1;
				 nMontoDctoLocal    := X.Dcto_Local				* -1;
				 nMontoDctoMoneda   := X.Dcto_Moneda			* -1;
				 nMontoDeducLocal   := X.Deduc_Local			* -1;
				 nMontoDeducMoneda  := X.Deduc_Moneda			* -1;
      ELSE
         NVO_MNTO_PAGADO    := X.PGO_MON_ORIG;
         nMontoNetoLocal    := X.PAGO_NETO_MON_LOC;
         nMontoNetoMoneda   := X.PGO_NETO_MON_ORIG;
         nMontoHonoLocal    := X.Gto_Hon_Local;
				 nMontoHonoMoneda   := X.Gto_Hon_Moneda;
				 nMontoHospLocal    := X.Gto_Hos_Local;
				 nMontoHospMoneda   := X.Gto_Hos_Moneda;
				 nMontoOtrGtoLocal  := X.Gto_Otr_Local;
				 nMontoOtrGtoMoneda := X.Gto_Otr_Moneda;
				 nMontoDctoLocal    := X.Dcto_Local;
				 nMontoDctoMoneda   := X.Dcto_Moneda;
				 nMontoDeducLocal   := X.Deduc_Local;
				 nMontoDeducMoneda  := X.Deduc_Moneda;
      END IF;	
      ----
      BEGIN
      	SELECT IdProcMasivo,Crga_Nom_Archivo,
      				 RTRIM(LTRIM(reporte_siniestros.VALOR_CAMPO(Crga_RegDatosProc,27,','))),Crga_Fecha,
      				 LTRIM(reporte_siniestros.VALOR_CAMPO(Crga_RegDatosProc,9,','))
					INTO nIdProcMasivo,cNomArchCarga,
							 cNomArchLogem,dFecCarga,cUUID
		      FROM PROCESOS_MASIVOS_SEGUIMIENTO PMS
			   WHERE IdSiniestro 		  = X.IdSiniestro
			     AND IdPoliza    			= X.IdPoliza
			     AND Crga_Cod_Proceso = 'PAGSIN'
			     AND Num_Aprobacion   = X.Num_Aprobacion;
      EXCEPTION
      	WHEN NO_DATA_FOUND THEN
      		nIdProcMasivo := NULL;
      		cNomArchCarga := NULL;
				  cNomArchLogem := NULL;
				  dFecCarga			:= NULL;
				  cUUID					:= NULL;
        WHEN TOO_MANY_ROWS THEN
        	nIdProcMasivo := NULL;
      		cNomArchCarga := NULL;
				  cNomArchLogem := NULL;
				  dFecCarga			:= NULL;
				  cUUID					:= NULL;
      END;
      
      --MLJS 08/10/2020 SE OBTIENE LA PÓLIZA CONTABLE
         BEGIN
         	 SELECT TIPODIARIO||'-'||NUMCOMPROBSC
         	 INTO   cPolizaCont
           FROM   COMPROBANTES_CONTABLES CC
           WHERE  NUMTRANSACCION = X.NUMTRX;
         EXCEPTION
         	  WHEN NO_DATA_FOUND THEN
         	     cPolizaCont := 'SIN POLIZA CONT';
         	  WHEN OTHERS THEN
         	     cPolizaCont := 'SIN POLIZA CONT';   
         END;
         
         --MLJS 08/10/2020 SE OBTIENE LA PÓLIZA CONTABLE
      ----
      IF cFormato = 'TEXTO' THEN
         cCadena := X.IDPOLIZA 													||cLimitador||						
                    X.POLUNIK														||cLimitador||
                    X.NUMSINIREF        								||cLimitador||
                    X.IDSINIESTRO												||cLimitador||
                    X.COD_PAGO													||cLimitador||
                    X.cFechaMvto				  							||cLimitador||
                    X.NUM_APROBACION										||cLimitador||
                    X.TIPO_APROBACION										||cLimitador||
                    X.ESTATUS					  								||cLimitador||
                    X.CODTRANSAC												||cLimitador||
                    X.DESCTRANSAC			  								||cLimitador||
                    X.CODCPTOTRANSAC										||cLimitador||
                    X.NUMTRX														||cLimitador||
                    dFecRes             								||cLimitador||
                    X.COD_MONEDA												||cLimitador||
                    nTipoCambio 												||cLimitador||
                    NVO_MNTO_PAGADO     								||cLimitador||
                    NVO_MNTO_PAGADO     								||cLimitador||
                    X.IVA_Moneda												||cLimitador||
                    X.IVA_Local													||cLimitador||
                    X.ISR_Moneda												||cLimitador||
                    X.ISR_Local													||cLimitador||
                    X.IVA_RET_MONEDA    								||cLimitador||
                    X.IVA_RET_LOCAL											||cLimitador||
                    X.PGO_NETO_MON_ORIG									||cLimitador||
                    X.PAGO_NETO_MON_LOC									||cLimitador||
                    X.OPC_MONEDA												||cLimitador||						
                    X.OPC_LOCAL													||cLimitador||
                    cDescBanco													||cLimitador||
                    cCuentaCheque   										||cLimitador||
                    X.USUARIO														||cLimitador||
                    nIVAPorcentaje											||cLimitador||
                    X.ASEGURADO         								||cLimitador||
                    cNombreBenef   											||cLimitador||
                    cNumDocTributario										||cLimitador||
                    NVL(X.NomArchCarga,cNomArchCarga)   ||cLimitador||
                    NVL(X.ARCHIVO_LOGEM,cNomArchLogem)  ||cLimitador||
                    NVL(X.FecCarga,dFecCarga)  					||cLimitador||
                    X.TIPOSEGURO        								||cLimitador||
                    NVL(X.NUMERO_FACTURA,cUUID)    			||cLimitador||
                    NVL(X.IDPROCMASIVO,nIdProcMasivo)   ||cLimitador||
                    X.POLCONTA_GG       								||cLimitador||
                    X.FECHA_PAGO        								||cLimitador||
                    X.IMPORT_PAGO       								||cLimitador||
                    X.ARCHIVO_GG        								||cLimitador||
                    X.PGOGG_USUARIO     								||cLimitador||
                    X.PGOGG_FECHACOMP   								||cLimitador||
                    X.OBSERVACION_GG    								||cLimitador||
                    X.WMONTO                            ||cLimitador||
                    X.ESCONTRIBUTORIO                   ||cLimitador||
                    X.PORCENCONTRIBUTORIO               ||cLimitador||
                    X.GIRONEGOCIO                       ||cLimitador||
                    X.TIPONEGOCIO                       ||cLimitador||
                    X.FUENTERECURSOS                    ||cLimitador||
                    X.CODPAQCOMERCIAL                   ||cLimitador||
                    X.CATEGORIA                         ||cLimitador||
                    X.CANALFORMAVENTA                   ||cLimitador||
                    cPolizaCont                         ||cLimitador||
                    X.NOMCONTRA                         ||cLimitador||
                    X.CODAGRUPADOR                      ||CHR(13);
      ELSE
         cCadena := '<tr>' || 
                    OC_ARCHIVO.CAMPO_HTML(X.IDPOLIZA,'C')         								||
                    OC_ARCHIVO.CAMPO_HTML(X.POLUNIK,'C')          								||
                    OC_ARCHIVO.CAMPO_HTML(X.NUMSINIREF,'C')       								||             
                    OC_ARCHIVO.CAMPO_HTML(X.IDSINIESTRO,'C')      								||
                    OC_ARCHIVO.CAMPO_HTML(X.COD_PAGO,'C')         								||
                    OC_ARCHIVO.CAMPO_HTML(X.cFechaMvto,'C')        								||
                    OC_ARCHIVO.CAMPO_HTML(X.NUM_APROBACION,'C')   								||
                    OC_ARCHIVO.CAMPO_HTML(X.TIPO_APROBACION,'C')  								||
                    OC_ARCHIVO.CAMPO_HTML(X.ESTATUS,'C')          								||
                    OC_ARCHIVO.CAMPO_HTML(X.CODTRANSAC,'C')       								||
                    OC_ARCHIVO.CAMPO_HTML(X.DESCTRANSAC,'C')      								||
                    OC_ARCHIVO.CAMPO_HTML(X.CODCPTOTRANSAC,'C')   								||
                    OC_ARCHIVO.CAMPO_HTML(X.NUMTRX,'C')           								||
                    OC_ARCHIVO.CAMPO_HTML(dFecRes,'D')            								||
                    OC_ARCHIVO.CAMPO_HTML(X.COD_MONEDA,'C')       								||
                    OC_ARCHIVO.CAMPO_HTML(nTipoCambio,'C')        								||
                    OC_ARCHIVO.CAMPO_HTML(NVO_MNTO_PAGADO,'N')    								||
                    OC_ARCHIVO.CAMPO_HTML(NVO_MNTO_PAGADO,'N')    								||
                    OC_ARCHIVO.CAMPO_HTML(nMontoHonoMoneda,'N')   								||
                    OC_ARCHIVO.CAMPO_HTML(nMontoHonoLocal,'N')   									||
                    OC_ARCHIVO.CAMPO_HTML(nMontoHospMoneda,'N')   								||
                    OC_ARCHIVO.CAMPO_HTML(nMontoHospLocal,'N')   									||
                    OC_ARCHIVO.CAMPO_HTML(nMontoOtrGtoMoneda,'N')   							||
                    OC_ARCHIVO.CAMPO_HTML(nMontoOtrGtoLocal,'N')   								||
                    OC_ARCHIVO.CAMPO_HTML(nMontoDctoMoneda,'N')   								||
                    OC_ARCHIVO.CAMPO_HTML(nMontoDctoLocal,'N')   									||
                    OC_ARCHIVO.CAMPO_HTML(nMontoDeducLocal,'N')   								||
                    OC_ARCHIVO.CAMPO_HTML(nMontoDeducMoneda,'N')   								||
                    OC_ARCHIVO.CAMPO_HTML(cValorCampoIVA ,'N')    								||
                    OC_ARCHIVO.CAMPO_HTML(cValorCampoIVA ,'N')    								||
                    OC_ARCHIVO.CAMPO_HTML(cValorCampoISR ,'N')    								||
                    OC_ARCHIVO.CAMPO_HTML(cValorCampoISR ,'N')    								||
                    OC_ARCHIVO.CAMPO_HTML(X.IVA_RET_MONEDA,'N')   								||
                    OC_ARCHIVO.CAMPO_HTML(X.IVA_RET_LOCAL,'N')    								||
                    OC_ARCHIVO.CAMPO_HTML(X.ImpLoc_Ret_Local,'N')   							||
                    OC_ARCHIVO.CAMPO_HTML(X.ImpLoc_Ret_Moneda,'N')   							||
                    OC_ARCHIVO.CAMPO_HTML(nMontoNetoMoneda,'N')										||
                    OC_ARCHIVO.CAMPO_HTML(nMontoNetoLocal,'N')								  	||
                    OC_ARCHIVO.CAMPO_HTML(X.OPC_MONEDA,'N')       								||
                    OC_ARCHIVO.CAMPO_HTML(X.OPC_LOCAL,'N')        								||
                    OC_ARCHIVO.CAMPO_HTML(cDescBanco,'C')         								||
                    OC_ARCHIVO.CAMPO_HTML(cCuentaCheque,'C')      								||
                    OC_ARCHIVO.CAMPO_HTML(X.USUARIO,'C')          								||
                    OC_ARCHIVO.CAMPO_HTML(nIVAPorcentaje,'C')     								||
                    OC_ARCHIVO.CAMPO_HTML(X.ASEGURADO,'C')        								||
                    OC_ARCHIVO.CAMPO_HTML(cNombreBenef,'C')       								||
                    OC_ARCHIVO.CAMPO_HTML(cNumDocTributario,'C')  								||
                    OC_ARCHIVO.CAMPO_HTML(NVL(X.NomArchCarga,cNomArchCarga),'C')  ||
                    OC_ARCHIVO.CAMPO_HTML(NVL(X.ARCHIVO_LOGEM,cNomArchLogem),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(NVL(X.FecCarga,dFecCarga),'D')          ||
                    OC_ARCHIVO.CAMPO_HTML(X.TIPOSEGURO,'C')       								||  
                    OC_ARCHIVO.CAMPO_HTML(NVL(X.NUMERO_FACTURA,cUUID),'C')   			||  
                    OC_ARCHIVO.CAMPO_HTML(NVL(X.IDPROCMASIVO,nIdProcMasivo),'C')  ||  
                    OC_ARCHIVO.CAMPO_HTML(X.POLCONTA_GG,'C')      								||  
                    OC_ARCHIVO.CAMPO_HTML(X.FECHA_PAGO,'C')       								||  
                    OC_ARCHIVO.CAMPO_HTML(X.IMPORT_PAGO,'C')      								|| 
                    OC_ARCHIVO.CAMPO_HTML(X.ARCHIVO_GG,'C')       								|| 
                    OC_ARCHIVO.CAMPO_HTML(X.PGOGG_USUARIO,'C')    								|| 
                    OC_ARCHIVO.CAMPO_HTML(X.PGOGG_FECHACOMP,'C')  								|| 
                    OC_ARCHIVO.CAMPO_HTML(X.OBSERVACION_GG,'C')   								||                  
                    OC_ARCHIVO.CAMPO_HTML(X.WMONTO,'C')               						||
                    OC_ARCHIVO.CAMPO_HTML(X.ESCONTRIBUTORIO,'C')                  || 
                    OC_ARCHIVO.CAMPO_HTML(X.PORCENCONTRIBUTORIO,'C')              || 
                    OC_ARCHIVO.CAMPO_HTML(X.GIRONEGOCIO,'C')                      || 
                    OC_ARCHIVO.CAMPO_HTML(X.TIPONEGOCIO,'C')                      || 
                    OC_ARCHIVO.CAMPO_HTML(X.FUENTERECURSOS,'C')                   || 
                    OC_ARCHIVO.CAMPO_HTML(X.CODPAQCOMERCIAL,'C')                  || 
                    OC_ARCHIVO.CAMPO_HTML(X.CATEGORIA,'C')                        || 
                    OC_ARCHIVO.CAMPO_HTML(X.CANALFORMAVENTA,'C')                  ||
                    OC_ARCHIVO.CAMPO_HTML(cPolizaCont,'C')                        ||
                    OC_ARCHIVO.CAMPO_HTML(X.NOMCONTRA,'C')                        ||
                    OC_ARCHIVO.CAMPO_HTML(X.CODAGRUPADOR,'C')                     ||
                    '</tr>';
      END IF;
      nLinea := nLinea + 1;
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);          --20190517 JISL
   END LOOP;
   --
   IF cFormato = 'EXCEL' THEN
      --cCadena := '</table></div></html>';
      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);     SYNCHRONIZE;      
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999); --20190517 JISL
   END IF;
   --CLIENT_TEXT_IO.fCLOSE(ARCHIVO_SALIDA);
  OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
EXCEPTION 
   WHEN OTHERS THEN 
        OC_ARCHIVO.Eliminar_Archivo(cCodUser);       
        raise_application_error(-20105,'Error en Generación Reporte PAGOS APROBADOS  de Siniestros: '|| ' ' ||SQLERRM);  
        
END;
  
PROCEDURE GENERAR_LAYOUT_PAG_SOLICITUD(cNomArchivo VARCHAR2, 
                                       DFECDESDE   DATE,
                                       DFECHASTA   DATE,
                                       CTIPO_MOVTO VARCHAR2,
                                       nIdReporte  NUMBER) IS
cLimitador   VARCHAR2(1) :=',';
nLinea       NUMBER;
cCadena      VARCHAR2(4000);
cCadenaAux   VARCHAR2(4000);
cCadenaAux1  VARCHAR2(4000);
cCodUser     VARCHAR2(30);
nDummy       NUMBER;
cCopy        BOOLEAN;
CFORMATO VARCHAR2(30);
--
nIdSiniestro     SINIESTRO.IDSINIESTRO%TYPE;
nTipoCambio      TASAS_CAMBIO.TASA_CAMBIO%TYPE; 
nMontoRvaMon     COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
nMontoRvaLoc     COBERTURA_SINIESTRO.MONTO_RESERVADO_LOCAL%TYPE;
--
--ARCHIVO_SALIDA    CLIENT_TEXT_IO.FILE_TYPE; -- SPEEDFILE
LINEA_SALIDA      VARCHAR2(5000);  -- SPEEDFILE
WI_ARCHIVO_SALIDA VARCHAR2(2000);  -- SPEEDFILE 
--
dFecCarga1A       VARCHAR2(50);
cNomArchCarga1A   PROCESOS_MASIVOS_SEGUIMIENTO.CRGA_NOM_ARCHIVO%TYPE;
cEmiTipoProceso   PROCESOS_MASIVOS_SEGUIMIENTO.EMI_TIPOPROCESO%TYPE;
dFecCarga         DATOS_PART_SINIESTROS.FecSts%TYPE;
cRFCHospital      DATOS_PART_SINIESTROS.Campo1%TYPE;
cDescSiniestro    SINIESTRO.Desc_Siniestro%TYPE;
cNomArchCarga     PROCESOS_MASIVOS_SEGUIMIENTO.CRGA_NOM_ARCHIVO%TYPE;
--
cPolizaCont       VARCHAR(50);
--
CURSOR LAYOUT IS
--
SELECT A.IDSINIESTRO,
       A.IDDETSIN,
       A.NUM_APROBACION,
       'C' COLIND,
       CTIPO_MOVTO,
       DA.CODCPTOTRANSAC,
       'MASIVOS SOLICITUD PAGOS,' DESCRIPCION
  FROM APROBACION_ASEG A,
       DETALLE_APROBACION_ASEG DA
 WHERE A.IDSINIESTRO    > 0
   AND A.STSAPROBACION  = 'SOL'
   AND A.FECPAGO        BETWEEN DFECDESDE AND DFECHASTA 
   --
   AND DA.IDSINIESTRO    = A.IDSINIESTRO
   AND DA.NUM_APROBACION = A.NUM_APROBACION
   AND DA.COD_PAGO       NOT IN ('IMPTO','DEDUC','RETENC')
   AND DA.IDDETAPROB     = (SELECT MIN(D1.IDDETAPROB)
                              FROM DETALLE_APROBACION_ASEG D1
                             WHERE D1.IDSINIESTRO    = DA.IDSINIESTRO
                               AND D1.NUM_APROBACION = DA.NUM_APROBACION
                               AND D1.COD_PAGO       NOT IN ('IMPTO','DEDUC','RETENC'))
--
UNION
--
SELECT A.IDSINIESTRO,
       A.IDDETSIN,
       A.NUM_APROBACION,
       'I' COLIND,
       CTIPO_MOVTO,
       DA.CODCPTOTRANSAC,
       'MASIVOS SOLICITUD PAGOS,' DESCRIPCION
  FROM APROBACIONES A,
       DETALLE_APROBACION DA
 WHERE A.IDSINIESTRO > 0
   AND A.STSAPROBACION  = 'SOL'
   AND A.FECPAGO        BETWEEN DFECDESDE AND DFECHASTA  
   --
   AND DA.IDSINIESTRO    = A.IDSINIESTRO
   AND DA.NUM_APROBACION = A.NUM_APROBACION
   AND DA.COD_PAGO       NOT IN ('IMPTO','DEDUC','RETENC')
   AND DA.IDDETAPROB     = (SELECT MIN(D1.IDDETAPROB)
                              FROM DETALLE_APROBACION D1
                             WHERE D1.IDSINIESTRO    = DA.IDSINIESTRO
                               AND D1.NUM_APROBACION = DA.NUM_APROBACION
                               AND D1.COD_PAGO       NOT IN ('IMPTO','DEDUC','RETENC'))
 ORDER BY 1
;
--
--
--
BEGIN 
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
  -- 
  -- CARGA DE INFORMACIÓN 
  --
  CFORMATO := 'TEXTO';
  nLinea := 0;
  FOR X IN LAYOUT LOOP
         IF CFormato = 'TEXTO' THEN
            cCadena := X.IDSINIESTRO          ||cLimitador||
                       X.IDDETSIN             ||cLimitador|| 
                       X.NUM_APROBACION       ||cLimitador|| 
                       X.COLIND               ||cLimitador|| 
                       X.CTIPO_MOVTO          ||cLimitador|| 
                       X.CODCPTOTRANSAC       ||cLimitador||
                       X.DESCRIPCION          ||CHR(13);
         END IF;
         --  
         nLinea := nLinea + 1;
         OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);   
  END LOOP;
  OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);
EXCEPTION 
  WHEN OTHERS THEN 
       OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
       RAISE_APPLICATION_ERROR(-20105,'Error en Generación Reporte pagos de Siniestros: '|| SQLERRM|| ' Siniestro: '||nIdSiniestro);  
       
END;
PROCEDURE GENERAR_VAL_PROC_MASIVO(cNomArchivo VARCHAR2, 
                                  cIdTipoSeg  VARCHAR2, 
                                  cCodMoneda  VARCHAR2, 
                                  dFecDesde   DATE    ,
                                  dFecHasta   DATE     ,
                                  cFormato    VARCHAR2,
                                  nIdReporte   NUMBER) IS
						cLimitador      VARCHAR2(1) :='|';
						nLinea          NUMBER;
						cCadena         VARCHAR2(4000);
						cCodUser        VARCHAR2(30);
						nDummy          NUMBER;
						cCopy           BOOLEAN;
						nsubrammo_imp   VARCHAR2(30);
						ntasacambio_imp TASAS_CAMBIO.TASA_CAMBIO%TYPE;
						
						nCodCia         POLIZAS.codcia%TYPE;
						nIdPoliza       POLIZAS.IDPOLIZA%TYPE;
						ncodempresa     DETALLE_POLIZA.CODEMPRESA%TYPE;
						nplancob 				DETALLE_POLIZA.PLANCOB%TYPE;
						nfechaest       SINIESTRO.FEC_NOTIFICACION%TYPE;
						ncod_moneda     SINIESTRO.COD_MONEDA%TYPE;
						cRamo           TIPOS_DE_SEGUROS.CODTIPOPLAN%TYPE;
						cDescRamo       VALORES_DE_LISTAS.DESCVALLST%TYPE;
						cNomProducto    TIPOS_DE_SEGUROS.DESCRIPCION%TYPE;
						cNomArchCarga   DATOS_PART_SINIESTROS.Campo85%TYPE;
		        --
		        LINEA_SALIDA       VARCHAR2(5000);           -- SPEEDFILE
		        WI_ARCHIVO_SALIDA  VARCHAR2(2000);           -- SPEEDFILE 
			      muestralerta       NUMBER        ;           -- SPEEDFILE
		        --
					  CURSOR SINIESTROS_Q IS 
            Select Si.NumSiniRef No_Referencia, 
            	     Si.IdPoliza Consecutivo, 
            	     Po.NumPolUnico, 
                   OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(Dp.CodCia, Dp.CodEmpresa, Dp.IdTipoSeg )||
                   OC_PLAN_COBERTURAS.CODIGO_SUBRAMO(Dp.CodCia, Dp.CodEmpresa,Dp.IdTipoSeg,Dp.PlanCob ) RamoSubRamo,
                   Po.CodCliente Contratante, 
                   OC_CLIENTES.NOMBRE_CLIENTE(Po.CodCliente) NomContratante,
                   Si.Cod_Asegurado Asegurado,
                   OC_ASEGURADO.Nombre_Asegurado(Si.CodCia, Si.CodEmpresa, Si.Cod_Asegurado) Nombre,
                   Si.Sts_Siniestro Estatus, 
                   Si.Fec_Ocurrencia Fec_Ocurrencia, 
                   Si.Desc_Siniestro Descripcion, 
                   Si.Monto_Reserva_Moneda Reserva,
                   Si.Monto_Pago_Moneda Pagado, 
                   Cs.CodCobert Cobertura, 
                   Fe.NumFactExt Factura,
                   SUM(Cs.Monto_Pagado_Moneda) Reserva_Monto_Pagado, 
                   SUM(Cs.Saldo_Reserva) Reserva_Saldo,
                   SUM(Da.Monto_Moneda) Pago_Monto
              From Siniestro Si, Polizas Po, Detalle_Poliza Dp,
                   Cobertura_Siniestro_Aseg Cs,
                   Detalle_Aprobacion_Aseg Da,
                   Factura_Externa Fe             
             Where si.idsiniestro   > 0 
               and si.idpoliza      > 0 
               And Si.NumSiniRef    Is Not Null
               AND Po.IdPoliza      = Si.IdPoliza 
               And Cs.IdPoliza      = Si.IdPoliza 
               And Cs.IdSiniestro   = Si.IdSiniestro
               and cs.iddetsin      = 1
               AND Cs.Cod_Asegurado = Si.Cod_Asegurado 
               And Da.IdSiniestro(+) = Si.IdSiniestro  
               And Fe.IdSiniestro(+) = Si.IdSiniestro
               And Dp.IDPOLIZA      = Po.IDPOLIZA
               And Dp.CODCIA        = Po.CODCIA
               And Dp.CODEMPRESA    = Po.CODEMPRESA
             Group by Si.NumSiniRef, Si.IdPoliza, Po.NumPolUnico,
                      OC_TIPOS_DE_SEGUROS.CODIGO_RAMO(Dp.CodCia, Dp.CodEmpresa, Dp.IdTipoSeg )||
                         OC_PLAN_COBERTURAS.CODIGO_SUBRAMO(Dp.CodCia, Dp.CodEmpresa,Dp.IdTipoSeg,Dp.PlanCob ),
                      Po.CodCliente, OC_CLIENTES.NOMBRE_CLIENTE(Po.CodCliente),
                      Si.Cod_Asegurado, OC_ASEGURADO.Nombre_Asegurado(Si.CodCia, Si.CodEmpresa, Si.Cod_Asegurado),
                      Si.Sts_Siniestro, Si.Fec_Ocurrencia, Si.Desc_Siniestro, Si.Monto_Reserva_Moneda,
                      Si.Monto_Pago_Moneda, Cs.CodCobert, Fe.NumFactExt;
BEGIN 
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
      --ARCHIVO_SALIDA    := CLIENT_TEXT_IO.FOPEN(cNomArchivo,'W');    --SPEEDFILE	        
				  IF cFormato = 'TEXTO' THEN
						      nLinea := 1;
						      cCadena     := 'THONA SEGUROS, S.A. de C.V.';--  || CHR(13);
						      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);          --SPEEDFILE			      
				          --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE			      
						  
						      nLinea := nLinea + 1;
						      cCadena     := 'REPORTE PARA VALIDAR CARGA MASIVA DE SINIESTROS  '||TO_CHAR(dFecDesde,'DD/MM/YYYY')||' Al '||TO_CHAR(dFecHasta,'DD/MM/YYYY');-- || CHR(13); 
						      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);          --SPEEDFILE			      
				          --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE			      
				          		  
						      nLinea := nLinea + 1;
						      cCadena     := ' ';-- || CHR(13); --SPEEDFILE			      
						      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
				          --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE			      						      
						  ---- // TITULOS //
						      nLinea := nLinea + 1;
						      cCadena     :=  'NO_REFERENCIA'  ||cLimitador||'CONSECUTIVO'       ||cLimitador||'NUMPOLUNICO'||cLimitador||'SUB_GRUPO'           ||cLimitador||
						                      'NUM_CONTRATANTE'||cLimitador||'NOMBRE CONTRATANTE'||cLimitador||'ASEGURADO'  ||cLimitador||'NOMBRE'              ||cLimitador||
						                      'ESTATUS'        ||cLimitador||'FEC_OCURRENCIA'    ||cLimitador||'DESCRIPCION'||cLimitador||'RESERVA'             ||cLimitador||
						                      'PAGADO'         ||cLimitador||'COBERTURA'         ||cLimitador||'FACTURA'    ||cLimitador||'RESERVA_MONTO_PAGADO'||cLimitador||
						                      'RESERVA_SALDO'  ||cLimitador||'PAGO_MONTO'        ;--||CHR(13);
						
						      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);          --SPEEDFILE			       
						      --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE			      
				  ELSE
							     nLinea := 1;
							     cCadena  := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
							                 ' xmlns:x="urn:schemas-microsoft-com:office:excel"'      ||chr(10)||
							                 ' xmlns="http://www.w3.org/TR/REC-html40">'              ||chr(10)||
							                 ' <style id="libro">'                                    ||chr(10)||
							                 '   <!--table'                                           ||chr(10)||
							                 '       {mso-displayed-decimal-separator:"\.";'          ||chr(10)||
							                 '        mso-displayed-thousand-separator:"\,";}'        ||chr(10)||
							                 '        .texto'                                         ||chr(10)||
							                 '          {mso-number-format:"\@";}'                    ||chr(10)||
							                 '        .numero'                                        ||chr(10)||
							                 '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
							                 '        .fecha'                                         ||chr(10)||
							                 '          {mso-number-format:"dd\\-mmm\\-yyyy";}'       ||chr(10)||
							                 '    -->'                                                ||chr(10)||
							                 ' </style><div id="libro">'                              ||chr(10);
							     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);          --SPEEDFILE			      
							     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE			      
							
							     nLinea  := nLinea + 1;
							     cCadena := '<table border = 0><tr><th>THONA SEGUROS, S.A. de C.V.</th></tr>'; 
							     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);          --SPEEDFILE			      
							     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE			      
							
							     nLinea  := nLinea + 1;
							     cCadena := '<tr><th>REPORTE PARA VALIDAR CARGA MASIVA DE SINIESTROS  '||TO_CHAR(dFecDesde,'DD/MM/YYYY')||' Al '||TO_CHAR(dFecHasta,'DD/MM/YYYY') || '</th></tr>'; 
							     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);		      --SPEEDFILE			      
							     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE			      
							     		
							     nLinea := nLinea + 1;
							     cCadena     := '<tr><th>  </th></tr></table>'; 
							     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);          --SPEEDFILE
							     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE			      		
					
							     nLinea := nLinea + 1;
							     cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NO_REFERENCIA</font></th>' ||
							                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">CONSECUTIVO</font></th>' ||
							                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUMPOLUNICO</font></th>' ||
							                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">SUB_GRUPO</font></th>' ||
							                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NUM_CONTRATANTE</font></th>' ||
							                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE_CONTRATANTE</font></th>' ||
							                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ASEGURADO</font></th>' ||
							                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">NOMBRE</font></th>' ||
							                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">ESTATUS</font></th>' ||
							                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FEC_OCURRENCIA</font></th>' ||
							                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">DESCRIPCION</font></th>' ||
							                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RESERVA</font></th>' ||
							                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGADO</font></th>' ||
							                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">COBERTURA</font></th>' ||
							                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">FACTURA</font></th>' ||
							                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RESERVA_MONTO_PAGADO</font></th>' ||
							                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">RESERVA_SALDO</font></th>' ||
							                    '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">PAGO_MONTO</font></th>';
							     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);          --SPEEDFILE
							     --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE			      		
				  END IF;
          FOR X IN SINIESTROS_Q LOOP
							    IF cFormato = 'TEXTO' THEN
							       cCadena :=  X.No_Referencia				||cLimitador||				
							                   X.Consecutivo					||cLimitador||					
							                   X.NumPolUnico				  ||cLimitador||
							                   X.RamoSubRamo					||cLimitador||
							                   X.Contratante				  ||cLimitador||
							                   X.NomContratante			  ||cLimitador||
							                   X.Asegurado					  ||cLimitador||
							                   X.Nombre						    ||cLimitador||
							                   X.Estatus			        ||cLimitador||
							                   TO_CHAR(X.Fec_Ocurrencia,'DD/MM/RRRR')			  ||cLimitador||
							                   X.Descripcion				  ||cLimitador||
							                   X.Reserva						  ||cLimitador||
							                   X.Pagado					      ||cLimitador||
							                   X.Cobertura				    ||cLimitador||
							                   X.Factura						  ||cLimitador||
							                   X.Reserva_Monto_Pagado	||cLimitador||
							                   X.Reserva_Saldo 	      ||cLimitador||					
							                   X.Pago_Monto   			  ;-- ||CHR(13);
							    ELSE
							       cCadena := '<tr>' || 
							                  OC_ARCHIVO.CAMPO_HTML(X.No_Referencia       ,'C') ||
							                  OC_ARCHIVO.CAMPO_HTML(X.Consecutivo         ,'C') ||
							                  OC_ARCHIVO.CAMPO_HTML(X.NumPolUnico         ,'C') ||
							                  OC_ARCHIVO.CAMPO_HTML(X.RamoSubRamo         ,'C') ||
							                  OC_ARCHIVO.CAMPO_HTML(X.Contratante         ,'C') ||
							                  OC_ARCHIVO.CAMPO_HTML(X.NomContratante      ,'C') ||
							                  OC_ARCHIVO.CAMPO_HTML(X.Asegurado           ,'C') ||
							                  OC_ARCHIVO.CAMPO_HTML(X.Nombre              ,'C') ||
							                  OC_ARCHIVO.CAMPO_HTML(X.Estatus             ,'C') ||
							                  OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Fec_Ocurrencia,'DD/MM/RRRR')      ,'C') ||
							                  OC_ARCHIVO.CAMPO_HTML(X.Descripcion         ,'C') ||
							                  OC_ARCHIVO.CAMPO_HTML(X.Reserva             ,'C') ||
							                  OC_ARCHIVO.CAMPO_HTML(X.Pagado              ,'C') ||
							                  OC_ARCHIVO.CAMPO_HTML(X.Cobertura           ,'C') ||
							                  OC_ARCHIVO.CAMPO_HTML(X.Factura             ,'C') ||
							                  OC_ARCHIVO.CAMPO_HTML(X.Reserva_Monto_Pagado,'C') ||
							                  OC_ARCHIVO.CAMPO_HTML(X.Reserva_Saldo       ,'C') ||
							                  OC_ARCHIVO.CAMPO_HTML(X.Pago_Monto          ,'C') || '</tr>';
							    END IF;
                  nLinea := nLinea + 1;
                  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);          --SPEEDFILE
		              --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE; --SPEEDFILE			      		
          END LOOP;
          IF cFormato = 'EXCEL' THEN
               OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);  --SPEEDFILE
               --cCadena := '</table></div></html>';                                  --SPEEDFILE
		           --CLIENT_TEXT_IO.PUTF(ARCHIVO_SALIDA, '%s\n',cCadena);SYNCHRONIZE;     --SPEEDFILE			      		
          END IF;
OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);          
EXCEPTION 
     WHEN OTHERS THEN 
          OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
          RAISE_APPLICATION_ERROR(-20105,'Error en Generación Reporte Estimados de Siniestros: '|| ' ' ||SQLERRM);  
          
END;
PROCEDURE GENERAR_OPC_SINIESTROS(cNomArchivo VARCHAR2, cIdTipoSeg VARCHAR2, cCodMoneda VARCHAR2, 
                                 dFecDesde DATE, dFecHasta DATE,cFormato    VARCHAR2,
                              nIdReporte   NUMBER) IS
cLimitador                VARCHAR2(1) :='|';
nLinea                    NUMBER;
cCadena                   VARCHAR2(4000);
cCadenaAux1               VARCHAR2(4000);
cCodUser                  VARCHAR2(30);
nDummy                    NUMBER;
cCopy                     BOOLEAN;
cTipo_Doc_Identificacion  ASEGURADO.Tipo_Doc_Identificacion%TYPE;
cNum_Doc_Identificacion   ASEGURADO.Num_Doc_Identificacion%TYPE;
cSexo                     ASEGURADO.Num_Doc_Identificacion%TYPE;
dFecNacimiento            APROBACIONES.FecPago%TYPE;
nEdad                     ASEGURADO.Num_Doc_Identificacion%TYPE;
nMonto_Pagado             DETALLE_APROBACION.Monto_Moneda%TYPE;
dFecMaxPago               APROBACIONES.FecPago%TYPE;
nOPCIniRva                COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
nOPCIniPago               DETALLE_APROBACION.Monto_Moneda%TYPE;
nOPCInicial               COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
nOcurrido_Periodo         COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
nOPCFinal                 COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
cSubRamo                  PLAN_COBERTURAS.CodTipoPlan%TYPE;
cIdTipoSegSini            DETALLE_POLIZA.IdTipoSeg%TYPE;
cNombreAseg               VARCHAR2(500);
--                                       
CFecNacimiento            VARCHAR2(10);
CFecMaxPago               VARCHAR2(10);
--
CURSOR SINI_Q IS 
  SELECT DISTINCT 'SICAS' Sistema, 
         'INDIVIDUAL' Nivel, 
         P.IdPoliza, 
         P.NumPolUnico, 
         S.IdSiniestro, 
         TO_CHAR(S.Fec_Ocurrencia,'DD/MM/RRRR') Fec_Ocurrencia,
         TO_CHAR(S.Fec_Notificacion,'DD/MM/RRRR') Fec_Notificacion,
         S.Motivo_de_Siniestro,
         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CAUSIN',S.Motivo_de_Siniestro) DescTipoSini,
         TO_CHAR(P.FecIniVig,'DD/MM/RRRR') FecIniVig,
         TO_CHAR(P.FecFinVig,'DD/MM/RRRR') FecFinVig,
         S.CodCia, 
         P.CodEmpresa, 
         S.IDetPol,
         OC_ASEGURADO.NOMBRE_ASEGURADO(P.CodCia, P.CodEmpresa, S.Cod_Asegurado) NombreAsegurado,
         NVL(S.Monto_Reserva_Moneda,0) Monto_Reserva_Moneda, 
         NVL(S.Monto_Pago_Moneda,0) Monto_Pago_Moneda,
         (NVL(S.Monto_Reserva_Moneda,0) - NVL(S.Monto_Pago_Moneda,0)) Saldo_Reserva,
         S.Cod_Asegurado, 
         S.CodProvOcurr, 
         OC_PROVINCIA.NOMBRE_PROVINCIA(S.CodPaisOcurr, S.CodProvOcurr) DescProvincia,
         OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) Contratante,
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
    FROM SINIESTRO S, 
         POLIZAS P, 
         DETALLE_SINIESTRO D,
          POLIZAS_TEXTO_COTIZACION  TXT,
          CATEGORIAS                CGO       
   WHERE S.MONTO_RESERVA_LOCAL - S.MONTO_PAGO_LOCAL != 0
     AND ((S.Cod_Moneda    = cCodMoneda AND cCodMoneda != '%')
      OR  (S.Cod_Moneda LIKE cCodMoneda AND cCodMoneda = '%'))
     --
     AND D.IdSiniestro     = S.IdSiniestro
     AND D.IdPoliza        = S.IdPoliza
     AND D.IdDetSin        = 1
     AND ((D.IdTipoSeg     = cIdTipoSeg AND cIdTipoSeg != '%')
      OR  (D.IdTipoSeg  LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
     --
     AND P.CodCia          = S.CodCia
     AND P.IdPoliza        = S.IdPoliza
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
  UNION
  --
  SELECT DISTINCT 'SICAS' Sistema, 
         'COLECTIVO' Nivel, 
         P.IdPoliza, 
         P.NumPolUnico, 
         S.IdSiniestro, 
         TO_CHAR(S.Fec_Ocurrencia,'DD/MM/RRRR') Fec_Ocurrencia, 
         TO_CHAR(S.Fec_Notificacion,'DD/MM/RRRR') Fec_Notificacion, 
         S.Motivo_de_Siniestro,
         OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CAUSIN',S.Motivo_de_Siniestro) DescTipoSini,
         TO_CHAR(P.FecIniVig,'DD/MM/RRRR') FecIniVig, 
         TO_CHAR(P.FecFinVig,'DD/MM/RRRR') FecFinVig, 
         S.CodCia, 
         P.CodEmpresa, 
         S.IDetPol,
         OC_ASEGURADO.NOMBRE_ASEGURADO(P.CodCia, P.CodEmpresa, S.Cod_Asegurado) NombreAsegurado,
         NVL(S.Monto_Reserva_Moneda,0) Monto_Reserva_Moneda, 
         NVL(S.Monto_Pago_Moneda,0) Monto_Pago_Moneda,
         (NVL(S.Monto_Reserva_Moneda,0) - NVL(S.Monto_Pago_Moneda,0)) Saldo_Reserva,
         S.Cod_Asegurado, 
         S.CodProvOcurr, 
         OC_PROVINCIA.NOMBRE_PROVINCIA(S.CodPaisOcurr, S.CodProvOcurr) DescProvincia,
         OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) Contratante,
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
    FROM SINIESTRO S, 
         POLIZAS P, 
         DETALLE_SINIESTRO_ASEG D,
          POLIZAS_TEXTO_COTIZACION  TXT,
          CATEGORIAS                CGO
   WHERE S.MONTO_RESERVA_LOCAL - S.MONTO_PAGO_LOCAL != 0
     AND ((S.Cod_Moneda    = cCodMoneda AND cCodMoneda != '%')
      OR  (S.Cod_Moneda LIKE cCodMoneda AND cCodMoneda = '%'))
     --
     AND D.IdSiniestro     = S.IdSiniestro
     AND D.IdPoliza        = S.IdPoliza
     AND D.IdDetSin        = 1
     AND ((D.IdTipoSeg     = cIdTipoSeg AND cIdTipoSeg != '%')
      OR  (D.IdTipoSeg  LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
     --
     AND P.CodCia          = S.CodCia
     AND P.IdPoliza        = S.IdPoliza
      --
      AND TXT.CODCIA(+)              = P.CODCIA    
      AND TXT.CODEMPRESA(+)          = P.CODEMPRESA 
      AND TXT.IDPOLIZA(+)            = P.IDPOLIZA
      --
      AND CGO.CODCIA(+)              = P.CODCIA  
      AND CGO.CODEMPRESA(+)          = P.CODEMPRESA 
      AND CGO.CODTIPONEGOCIO(+)      = P.CODTIPONEGOCIO 
      AND CGO.CODCATEGO(+)           = P.CODCATEGO
  ORDER BY 1,2,5;
--     
BEGIN 
	--
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
  --
  IF cFormato = 'TEXTO' THEN
     nLinea := 1;
     cCadena     := oc_empresas.NOMBRE_COMPANIA(1)  || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      
     nLinea := nLinea + 1;
     cCadena     := 'REPORTE OPC DE SINIESTROS DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      
     nLinea := nLinea + 1;
     cCadena     := ' ' || CHR(13);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      
     nLinea := nLinea + 1;
     cCadena      := 'Sistema'              ||cLimitador||
                     'SubRamo'              ||cLimitador||
                     'No. Póliza'           ||cLimitador||
                     'No. Unico de Póliza'  ||cLimitador||
                     'No. de Siniestro'     ||cLimitador||
                     'Fecha Ocurrencia'     ||cLimitador||
                     'Fecha Notificación'   ||cLimitador||
                     'Motivo del Siniestro' ||cLimitador||
                     'Descrip. Tipo Sini.'  ||cLimitador||
                     'Fec. Inicio Vig.'     ||cLimitador||
                     'Fec. Fin Vig.'        ||cLimitador|| 
                     'Nombre Asegurado'     ||cLimitador||
                     'OPC Inicial'          ||cLimitador||
                     'Ocurrido Periodo'     ||cLimitador||
                     'Monto Pagado'         ||cLimitador||
                     'OPC Final'            ||cLimitador||
                     'Monto Reserva Moneda' ||cLimitador||
                     'Monto Pago Moneda'    ||cLimitador||
                     'Saldo Reserva'        ||cLimitador||
                     'Cod. Asegurado'       ||cLimitador||
                     'Tipo Doc. Identif.'   ||cLimitador||
                     'Num. Doc. Identif.'   ||cLimitador||
                     'Fecha Nacimiento'     ||cLimitador||
                     'Edad'                 ||cLimitador||
                     'Sexo'                 ||cLimitador||
                     'Fecha Ultimo Pago'    ||cLimitador||
                     'Código Provincia'     ||cLimitador||
                     'Nombre Provincia'     ||cLimitador||
                     'Contratante'          ||cLimitador||
                     'Tipo Producto'        ||cLimitador||
					           'Es Contributorio'     ||cLimitador||
					           '% Contributorio'      ||cLimitador||
					           'Giro de Negocio'      ||cLimitador||
					           'Tipo de Negocio'      ||cLimitador||
					           'Fuente de Recursos'   ||cLimitador||
					           'Paquete Comercial'    ||cLimitador||
					           'Categoria'            ||cLimitador||
					           'Canal de Venta';
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  ELSE
     nLinea := 1;
     cCadena  := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                       ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                       ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                       ' <style id="libro">'||chr(10)||
                       '   <!--table'||chr(10)||
                       '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                       '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                       '        .texto'||chr(10)||
                       '          {mso-number-format:"\@";}'||chr(10)||
                       '        .numero'||chr(10)||
                       '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                       '        .fecha'||chr(10)||
                       '          {mso-number-format:"dd\\/mm\\/yyyy";}'||chr(10)||
                       '    -->'||chr(10)||
                       ' </style><div id="libro">'||chr(10);
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     nLinea := nLinea + 1;
     cCadena     := '<table border = 0><tr><th>' || oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     nLinea := nLinea + 1;
     cCadena     := '<tr><th>REPORTE OPC DE SINIESTROS DEL '|| TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' Al ' ||
                     TO_CHAR(dFecHasta,'DD/MM/YYYY') || '</th></tr>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      
     nLinea := nLinea + 1;
     cCadena     := '<tr><th>  </th></tr></table>'; 
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     nLinea := nLinea + 1;
     cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Sistema</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">SubRamo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Póliza</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. Unico de Póliza</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Siniestro</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Ocurrencia</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Notificación</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Motivo del Siniestro</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descrip. Tipo Sini.</font></th>' || 
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fec. Inicio Vig.</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fec. Fin Vig.</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Asegurado</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPC Inicial</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Ocurrido Periodo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Pagado</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">OPC Final</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Reserva Moneda</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Pago Moneda</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Saldo Reserva</font></th>' ||                     
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Cod. Asegurado</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Doc. Identif.</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Num. Doc. Identif.</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Nacimiento</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Edad</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Sexo</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Ultimo Pago</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Código Provincia</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre Provincia</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Contratante</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Producto</font></th>';
     cCadenaAux1 :=  '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Es Contributorio</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">% Contributorio</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Giro de Negocio</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de Negocio</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fuente de Recursos</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Paquete Comercial</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Categoria</font></th>' ||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Canal de Venta</font></th>';
                     
     OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
     OC_ARCHIVO.Escribir_Linea(cCadenaAux1, cCodUser, nLinea);
  END IF;
  --
  FOR X IN SINI_Q LOOP
      BEGIN
        SELECT Tipo_Doc_Identificacion, 
               Num_Doc_Identificacion, 
               Sexo,
               FecNacimiento, 
               FLOOR((TRUNC(TO_DATE(X.FecIniVig,'DD/MM/RRRR')) - TRUNC(FecNacimiento)) / 365.25),
               TRIM(Nombre) ||' ' || TRIM(Apellido_Paterno) || ' ' || TRIM(Apellido_Materno) || ' ' || 
               DECODE(ApeCasada,NULL,'', ' de ' ||ApeCasada)
          INTO cTipo_Doc_Identificacion, 
               cNum_Doc_Identificacion, 
               cSexo,
               dFecNacimiento, 
               nEdad, 
               cNombreAseg
          FROM PERSONA_NATURAL_JURIDICA
         WHERE (Tipo_Doc_Identificacion, 
                Num_Doc_Identificacion) IN (SELECT Tipo_Doc_Identificacion, 
                                                   Num_Doc_Identificacion
                                              FROM ASEGURADO
                                             WHERE CodCia        = X.CodCia
                                               AND CodEmpresa    = X.CodEmpresa
                                               AND Cod_Asegurado = X.Cod_Asegurado);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
      	     cTipo_Doc_Identificacion := NULL;
      	     cNum_Doc_Identificacion  := NULL;
      	     cSexo                    := NULL;
             dFecNacimiento           := NULL;
             nEdad                    := 0;
             cNombreAseg              := NULL;
      END;
      --
      BEGIN
        SELECT OC_PLAN_COBERTURAS.CODIGO_SUBRAMO(CodCia, CodEmpresa, IdTipoSeg, PlanCob), 
               IdTipoSeg
          INTO cSubRamo, 
               cIdTipoSegSini
          FROM DETALLE_POLIZA
         WHERE CodCia    = X.CodCia
           AND IdPoliza  = X.IdPoliza
           AND IDetPol   = X.IDetPol;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cSubRamo := NULL;
      END;
      --
      IF X.Nivel = 'INDIVIDUAL' THEN
         SELECT NVL(SUM(CS.Monto_Reservado_Moneda * Decode(CTS.Signo,'-',-1,1)),0)
           INTO nOPCIniRva
           FROM TRANSACCION T, 
                COBERTURA_SINIESTRO CS, 
                CONFIG_TRANSAC_SINIESTROS CTS 
          WHERE CS.IdSiniestro            = X.IdSiniestro 
            AND CS.IdPoliza               = X.IdPoliza
            AND CS.CodTransac             = CTS.CodTransac
            AND T.IdTransaccion           = CS.IdTransaccion
            AND TRUNC(T.FechaTransaccion) < dFecDesde;
         --  
         SELECT NVL(SUM(Monto_Moneda),0)
           INTO nOPCIniPago
           FROM DETALLE_APROBACION D, 
                CPTOS_TRANSAC_SINIESTROS J
          WHERE EXISTS (SELECT 1 
                         FROM TRANSACCION T, 
                              APROBACIONES A
                        WHERE A.IdSiniestro             = D.IdSiniestro
                          AND D.Num_Aprobacion          = A.Num_Aprobacion
                          AND A.IdPoliza                = X.IdPoliza
                          AND A.IdSiniestro             = X.IdSiniestro
                          AND A.IdDetSin                > 0
                          AND ((A.StsAprobacion        IN ('PAG','ANU')
                          AND T.IdTransaccion           = A.IdTransaccion
                          AND TRUNC(T.FechaTransaccion) < dFecDesde)
                           OR (A.StsAprobacion           = 'ANU'
                          AND T.IdTransaccion           = A.IdTransaccionAnul
                          AND TRUNC(T.FechaTransaccion) > dFecDesde)))
            AND D.IdSiniestro    = X.IdSiniestro
            AND D.CodTransac     = J.CodTransac
            AND D.CodCptoTransac = J.CodCptoTransac
            AND J.IndDisminRva   = 'S';
         -- 
         nOPCInicial := NVL(nOPCIniRva,0) - NVL(nOPCIniPago,0);
         --
         SELECT NVL(SUM(CS.Monto_Reservado_Moneda * Decode(CTS.Signo,'-',-1,1)),0)
           INTO nOcurrido_Periodo
           FROM TRANSACCION T, 
                COBERTURA_SINIESTRO CS,
                CONFIG_TRANSAC_SINIESTROS CTS 
          WHERE CS.IdSiniestro             = X.IdSiniestro 
            AND CS.IdPoliza                = X.IdPoliza
            AND CS.CodTransac              = CTS.CodTransac
            AND T.IdTransaccion            = CS.IdTransaccion
            AND TRUNC(T.FechaTransaccion) >= dFecDesde
            AND TRUNC(T.FechaTransaccion) <= dFecHasta;
         --
         SELECT NVL(SUM(Monto_Moneda),0)
           INTO nMonto_Pagado
           FROM DETALLE_APROBACION D, 
                CPTOS_TRANSAC_SINIESTROS J
          WHERE EXISTS (SELECT 1 
                          FROM TRANSACCION T, 
                               APROBACIONES A
                         WHERE A.IdSiniestro              = D.IdSiniestro
                           AND D.Num_Aprobacion           = A.Num_Aprobacion
                           AND A.IdPoliza                 = X.IdPoliza
                           AND A.IdSiniestro              = X.IdSiniestro
                           AND A.IdDetSin                 > 0
                           AND ((A.StsAprobacion         IN ('PAG','ANU')
                           AND T.IdTransaccion            = A.IdTransaccion
                           AND TRUNC(T.FechaTransaccion) >= dFecDesde
                           AND TRUNC(T.FechaTransaccion) <= dFecHasta)
                           AND (A.StsAprobacion           = 'ANU'
                           AND T.IdTransaccion            = A.IdTransaccionAnul
                           AND TRUNC(T.FechaTransaccion)  > dFecHasta)))
            AND D.IdSiniestro    = X.IdSiniestro
            AND D.CodTransac     = J.CodTransac
            AND D.CodCptoTransac = J.CodCptoTransac
            AND J.IndDisminRva   = 'S';
         --
         nOPCFinal := nOPCInicial + nOcurrido_Periodo - nMonto_Pagado;
         --
         SELECT MAX(FecPago)
           INTO dFecMaxPago
           FROM APROBACIONES
          WHERE IdSiniestro    = X.IdSiniestro
            AND IdPoliza       = X.IdPoliza
            AND Num_Aprobacion > 0
            AND IdDetSIn       > 0
            AND StsAprobacion  = 'PAG';
      ELSE
         SELECT NVL(SUM(CS.Monto_Reservado_Moneda * Decode(CTS.Signo,'-',-1,1)),0)
           INTO nOPCIniRva
           FROM TRANSACCION T, 
                COBERTURA_SINIESTRO_ASEG CS, 
                CONFIG_TRANSAC_SINIESTROS CTS 
          WHERE CS.IdSiniestro            = X.IdSiniestro 
            AND CS.IdPoliza               = X.IdPoliza
            AND CS.CodTransac             = CTS.CodTransac
            AND T.IdTransaccion           = CS.IdTransaccion
            AND TRUNC(T.FechaTransaccion) < dFecDesde;
         --
         SELECT NVL(SUM(Monto_Moneda),0)
           INTO nOPCIniPago
           FROM DETALLE_APROBACION_ASEG D, 
                CPTOS_TRANSAC_SINIESTROS J
          WHERE EXISTS (SELECT 1 
                         FROM TRANSACCION T, 
                              APROBACION_ASEG A
                        WHERE A.IdSiniestro             = D.IdSiniestro
                          AND D.Num_Aprobacion          = A.Num_Aprobacion
                          AND A.IdPoliza                = X.IdPoliza
                          AND A.IdSiniestro             = X.IdSiniestro
                          AND A.IdDetSin                > 0
                          AND ((A.StsAprobacion        IN ('PAG','ANU')
                          AND T.IdTransaccion           = A.IdTransaccion
                          AND TRUNC(T.FechaTransaccion) < dFecDesde)
                           OR (A.StsAprobacion           = 'ANU'
                          AND T.IdTransaccion           = A.IdTransaccionAnul
                          AND TRUNC(T.FechaTransaccion) > dFecDesde)))
            AND D.IdSiniestro    = X.IdSiniestro
            AND D.CodTransac     = J.CodTransac
            AND D.CodCptoTransac = J.CodCptoTransac
            AND J.IndDisminRva   = 'S';
         --
         nOPCInicial := NVL(nOPCIniRva,0) - NVL(nOPCIniPago,0);
         --
         SELECT NVL(SUM(CS.Monto_Reservado_Moneda * Decode(CTS.Signo,'-',-1,1)),0)
           INTO nOcurrido_Periodo
           FROM TRANSACCION T, 
                COBERTURA_SINIESTRO_ASEG CS,
                CONFIG_TRANSAC_SINIESTROS CTS 
          WHERE CS.IdSiniestro             = X.IdSiniestro 
            AND CS.IdPoliza                = X.IdPoliza
            AND CS.CodTransac              = CTS.CodTransac
            AND T.IdTransaccion            = CS.IdTransaccion
            AND TRUNC(T.FechaTransaccion) >= dFecDesde
            AND TRUNC(T.FechaTransaccion) <= dFecHasta;
         --         
         SELECT NVL(SUM(Monto_Moneda),0)
           INTO nMonto_Pagado
           FROM DETALLE_APROBACION_ASEG D, 
                CPTOS_TRANSAC_SINIESTROS J
          WHERE EXISTS (SELECT 1 
                          FROM TRANSACCION T, 
                               APROBACION_ASEG A
                         WHERE A.IdSiniestro              = D.IdSiniestro
                           AND D.Num_Aprobacion           = A.Num_Aprobacion
                           AND A.IdPoliza                 = X.IdPoliza
                           AND A.IdSiniestro              = X.IdSiniestro
                           AND A.IdDetSin                 > 0
                           AND ((A.StsAprobacion         IN ('PAG','ANU')
                           AND T.IdTransaccion            = A.IdTransaccion
                           AND TRUNC(T.FechaTransaccion) >= dFecDesde
                           AND TRUNC(T.FechaTransaccion) <= dFecHasta)
                           AND (A.StsAprobacion           = 'ANU'
                           AND T.IdTransaccion            = A.IdTransaccionAnul
                           AND TRUNC(T.FechaTransaccion)  > dFecHasta)))
            AND D.IdSiniestro    = X.IdSiniestro
            AND D.CodTransac     = J.CodTransac
            AND D.CodCptoTransac = J.CodCptoTransac
            AND J.IndDisminRva   = 'S';
         --
         nOPCFinal := nOPCInicial + nOcurrido_Periodo - nMonto_Pagado;
         --
         SELECT MAX(FecPago)
           INTO dFecMaxPago
           FROM APROBACION_ASEG
          WHERE IdSiniestro    = X.IdSiniestro
            AND IdPoliza       = X.IdPoliza
            AND Cod_Asegurado  = X.Cod_Asegurado
            AND Num_Aprobacion > 0
            AND IdDetSIn       > 0
            AND StsAprobacion  = 'PAG';
      END IF;
      --
      CFecNacimiento := TO_CHAR(dFecNacimiento,'DD/MM/YYYY');
      CFecMaxPago    := TO_CHAR(dFecMaxPago,'DD/MM/YYYY');
      --
      IF cFormato = 'TEXTO' THEN
         cCadena := X.Sistema                                          ||cLimitador||
                    cSubRamo                                           ||cLimitador||
                    TO_CHAR(X.IdPoliza,'9999999999990')                ||cLimitador||
                    X.NumPolUnico                                      ||cLimitador||
                    TO_CHAR(X.IdSiniestro,'9999999999999')             ||cLimitador||
                    TO_CHAR(X.Fec_Ocurrencia,'DD/MM/RRRR')             ||cLimitador||
                    TO_CHAR(X.Fec_Notificacion,'DD/MM/RRRR')           ||cLimitador||
                    X.Motivo_de_Siniestro                              ||cLimitador||
                    X.DescTipoSini                                     ||cLimitador||
                    TO_CHAR(X.FecIniVig,'DD/MM/RRRR')                  ||cLimitador||
                    TO_CHAR(X.FecFinVig,'DD/MM/RRRR')                  ||cLimitador||
                    cNombreAseg                                        ||cLimitador||
                    TO_CHAR(nOPCInicial,'9999999999990.00')            ||cLimitador||
                    TO_CHAR(nOcurrido_Periodo,'9999999999990.00')      ||cLimitador||
                    TO_CHAR(nMonto_Pagado,'9999999999990.00')          ||cLimitador||
                    TO_CHAR(nOPCFinal,'9999999999990.00')              ||cLimitador||
                    TO_CHAR(X.Monto_Reserva_Moneda,'9999999999990.00') ||cLimitador||
                    TO_CHAR(X.Monto_Pago_Moneda,'9999999999990.00')    ||cLimitador||
                    TO_CHAR(X.Saldo_Reserva,'9999999999990.00')        ||cLimitador||
                    TO_CHAR(X.Cod_Asegurado,'99999999999990')          ||cLimitador||
                    cTipo_Doc_Identificacion                           ||cLimitador||
                    cNum_Doc_Identificacion                            ||cLimitador||
                    TO_CHAR(dFecNacimiento,'DD/MM/RRRR')               ||cLimitador||
                    TO_CHAR(nEdad,'99990')                             ||cLimitador||
                    cSexo                                              ||cLimitador||
                    TO_CHAR(dFecMaxPago,'DD/MM/RRRR')                  ||cLimitador||
                    X.CodProvOcurr                                     ||cLimitador||
                    X.DescProvincia                                    ||cLimitador||
                    X.Contratante                                      ||cLimitador||
                    cIdTipoSegSini                                     ||cLimitador||
                    X.ESCONTRIBUTORIO                                  ||cLimitador||
                    X.PORCENCONTRIBUTORIO                              ||cLimitador||
                    X.GIRONEGOCIO                                      ||cLimitador||
                    X.TIPONEGOCIO                                      ||cLimitador||
                    X.FUENTERECURSOS                                   ||cLimitador||
                    X.CODPAQCOMERCIAL                                  ||cLimitador||
                    X.CATEGORIA                                        ||cLimitador||
                    X.CANALFORMAVENTA                                  ||CHR(13);
      ELSE
         cCadena := '<tr>' || 
                    OC_ARCHIVO.CAMPO_HTML(X.Sistema,'C')             ||
                    OC_ARCHIVO.CAMPO_HTML(cSubRamo,'C')              ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdPoliza,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.NumPolUnico,'C')         ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdSiniestro,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.Fec_Ocurrencia,'D')      ||
                    OC_ARCHIVO.CAMPO_HTML(X.Fec_Notificacion,'D')    ||
                    OC_ARCHIVO.CAMPO_HTML(X.Motivo_de_Siniestro,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(X.DescTipoSini,'C')        ||
                    OC_ARCHIVO.CAMPO_HTML(X.FecIniVig,'D')           ||
                    OC_ARCHIVO.CAMPO_HTML(X.FecFinVig,'D')           ||
                    OC_ARCHIVO.CAMPO_HTML(cNombreAseg,'C')           ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nOPCInicial,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nOcurrido_Periodo,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nMonto_Pagado,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nOPCFinal,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Monto_Reserva_Moneda,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Monto_Pago_Moneda,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Saldo_Reserva,'99999999999990.00'),'N') ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.Cod_Asegurado,'9999999999990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(cTipo_Doc_Identificacion,'C') ||
                    OC_ARCHIVO.CAMPO_HTML(cNum_Doc_Identificacion,'C')  ||
                    OC_ARCHIVO.CAMPO_HTML(CFecNacimiento,'C')         ||
                    OC_ARCHIVO.CAMPO_HTML(TO_CHAR(nEdad,'99990'),'C') ||
                    OC_ARCHIVO.CAMPO_HTML(cSexo,'C')                  ||
                    OC_ARCHIVO.CAMPO_HTML(CFecMaxPago,'C')            ||
                    OC_ARCHIVO.CAMPO_HTML(X.CodProvOcurr,'C')         ||
                    OC_ARCHIVO.CAMPO_HTML(X.DescProvincia,'C')        ||
                    OC_ARCHIVO.CAMPO_HTML(X.Contratante,'C')          ||
                    OC_ARCHIVO.CAMPO_HTML(cIdTipoSegSini,'C')         ||
                    OC_ARCHIVO.CAMPO_HTML(X.ESCONTRIBUTORIO,'C')      || 
                    OC_ARCHIVO.CAMPO_HTML(X.PORCENCONTRIBUTORIO,'C')  || 
                    OC_ARCHIVO.CAMPO_HTML(X.GIRONEGOCIO,'C')          || 
                    OC_ARCHIVO.CAMPO_HTML(X.TIPONEGOCIO,'C')          || 
                    OC_ARCHIVO.CAMPO_HTML(X.FUENTERECURSOS,'C')       || 
                    OC_ARCHIVO.CAMPO_HTML(X.CODPAQCOMERCIAL,'C')      || 
                    OC_ARCHIVO.CAMPO_HTML(X.CATEGORIA,'C')            || 
                    OC_ARCHIVO.CAMPO_HTML(X.CANALFORMAVENTA,'C')      || '</tr>';
      END IF;
      nLinea := nLinea + 1;
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
   IF cFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
   END IF;
OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);          
EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      RAISE_APPLICATION_ERROR(-20102,'Error en Generación de Reporte OPC de Siniestros: ' || SQLERRM); 
      
END;
PROCEDURE SINIESTROS_PLD_REPORTADOS(cNomArchivo VARCHAR2, 
                             cIdTipoSeg  VARCHAR2, 
                             cCodMoneda  VARCHAR2, 
                             dFecDesde DATE,    
                             dFecHasta DATE,
                             cFormato    VARCHAR2,
                             nIdReporte   NUMBER) IS
                          
cLimitador         		VARCHAR2(1) :='|';
nLinea             		NUMBER;
cCadena            		VARCHAR2(4000);
cCodUser           		VARCHAR2(30);
nDummy             		NUMBER;
cCopy              		BOOLEAN;
--
W_FECHA_CIERRE     		VARCHAR2(30) := ' ';
W_QEQFECHANACIMIENTO 	VARCHAR2(30) := ' ';
W_QEQLISTA						VARCHAR2(30) := ' ';
W_CGCAGE_VALOR_LARGO  VARCHAR2(150) := ' ';
W_QEQNOMCOMP					VARCHAR2(150) := ' ';
W_QEQRFC							VARCHAR2(25) := ' ';
V_NOMCOMP							VARCHAR2(150) := ' ';	
CURSOR POL_Q IS 
SELECT --ARS.CODCLIENTE,SYSDATE, 
ARS.FECHA_PROCESO,ARS.IDPOLIZA, P.NUMPOLUNICO, ARS.NUMSINIESTRO, APR.MONTO_MONEDA,APR.NUM_APROBACION, 
ARS.ST_RESOLUCION,ARS.FE_ESTATUS FECHASTATUS , OC_ASEGURADO.NOMBRE_ASEGURADO(ARS.CODCIA, ARS.CODEMPRESA, ARS.CODCLIENTE)NOMBREASEGURADO , --pnj.nombre ||' '||pnj.apellido_paterno ||' '||pnj.apellido_materno NOMBREASEGURADO,
ARS.NOMBRE_BENEFICIARIO, DP.IDTIPOSEG, ts.descripcion, OC_CLIENTES.NOMBRE_CLIENTE(p.codcliente) NOMBRECLIENTE , --pnjCL.nombre||' '||pnjCL.apellido_paterno||' '||pnjCL.apellido_materno NOMBRECLIENTE
ARS.OBSERVACIONES, ARS.USUARIO
FROM ADMON_RIESGO_SINIESTROS ARS ,
     POLIZAS P,
     DETALLE_POLIZA DP,
     tipos_de_seguros ts,
     APROBACIONES APR ,
     ASEGURADO c ,
     persona_natural_juridica pnj,
     CLIENTES CL,
     persona_natural_juridica pnjCL     
WHERE ARS.FECHA_PROCESO BETWEEN dFECDESDE
                           AND dFECHASTA
AND APR.IDSINIESTRO = ARS.NUMSINIESTRO
AND P.IDPOLIZA = ARS.IDPOLIZA
AND DP.IDPOLIZA = P.IDPOLIZA
and ts.idtiposeg = dp.idtiposeg
AND C.COD_ASEGURADO = ARS.CODCLIENTE
AND PNJ.TIPO_DOC_IDENTIFICACION = C.TIPO_DOC_IDENTIFICACION
AND PNJ.NUM_DOC_IDENTIFICACION = C.NUM_DOC_IDENTIFICACION 
AND CL.CODCLIENTE = P.CODCLIENTE
AND PNJCL.TIPO_DOC_IDENTIFICACION = CL.TIPO_DOC_IDENTIFICACION
AND PNJCL.NUM_DOC_IDENTIFICACION = CL.NUM_DOC_IDENTIFICACION 
AND (P.COD_MONEDA              = DECODE(cCodMoneda,'%',P.COD_MONEDA,cCodMoneda))
AND (DP.IDTIPOSEG             = DECODE(cIdTipoSeg,'%',DP.IDTIPOSEG,cIdTipoSeg))
UNION 
SELECT --ARS.CODCLIENTE,SYSDATE, 
ARS.FECHA_PROCESO,ARS.IDPOLIZA, P.NUMPOLUNICO, ARS.NUMSINIESTRO, APR.MONTO_MONEDA,APR.NUM_APROBACION, 
ARS.ST_RESOLUCION, ARS.FE_ESTATUS FECHASTATUS , OC_ASEGURADO.NOMBRE_ASEGURADO(ARS.CODCIA, ARS.CODEMPRESA, ARS.CODCLIENTE)NOMBREASEGURADO , --pnj.nombre||' '||pnj.apellido_paterno||' '||pnj.apellido_materno NOMBREASEGURADO,
ARS.NOMBRE_BENEFICIARIO, DP.IDTIPOSEG, ts.descripcion, OC_CLIENTES.NOMBRE_CLIENTE(p.codcliente) NOMBRECLIENTE , --pnjCL.nombre||' '||pnjCL.apellido_paterno||' '||pnjCL.apellido_materno NOMBRECLIENTE
ARS.OBSERVACIONES, ARS.USUARIO
FROM ADMON_RIESGO_SINIESTROS ARS ,
     POLIZAS P,
     DETALLE_POLIZA DP,
     tipos_de_seguros ts,
     APROBACION_ASEG APR ,
     ASEGURADO c ,
     persona_natural_juridica pnj,
     CLIENTES CL,
     persona_natural_juridica pnjCL     
WHERE ARS.FECHA_PROCESO BETWEEN dFECDESDE
                           AND dFECHASTA
AND APR.IDSINIESTRO = ARS.NUMSINIESTRO
AND P.IDPOLIZA = ARS.IDPOLIZA
AND DP.IDPOLIZA = P.IDPOLIZA
and ts.idtiposeg = dp.idtiposeg
AND C.COD_ASEGURADO = ARS.CODCLIENTE
AND PNJ.TIPO_DOC_IDENTIFICACION = C.TIPO_DOC_IDENTIFICACION
AND PNJ.NUM_DOC_IDENTIFICACION = C.NUM_DOC_IDENTIFICACION 
AND CL.CODCLIENTE(+) = P.CODCLIENTE
AND PNJCL.TIPO_DOC_IDENTIFICACION = CL.TIPO_DOC_IDENTIFICACION
AND PNJCL.NUM_DOC_IDENTIFICACION = CL.NUM_DOC_IDENTIFICACION 
AND (P.COD_MONEDA              = DECODE(cCodMoneda,'%',P.COD_MONEDA,cCodMoneda))
AND (DP.IDTIPOSEG             = DECODE(cIdTipoSeg,'%',DP.IDTIPOSEG,cIdTipoSeg))
ORDER BY 3,5   ;
BEGIN 
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
   IF cFormato = 'TEXTO' THEN
      nLinea := 1;
      cCadena     := oc_empresas.NOMBRE_COMPANIA(1) || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      nLinea := nLinea + 1;
      cCadena     := 'REPORTE DE MOVIMIENTOS DEL MODULO DE ADMINISTRACION DE RIESGOS';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      nLinea := nLinea + 1;
      cCadena     := TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' AL ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      
      nLinea := nLinea + 1;
      cCadena     := ' ' || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      nLinea := nLinea + 1;
      cCadena     := 'Fecha de Proceso'  								||cLimitador||
      							 'No. de Póliza'     								||cLimitador||
      							 'No. de Póliza Unico'     					||cLimitador||
                     'No. de Siniestro'  								||cLimitador||
                     'Nombre del Cliente Contratante'  	||cLimitador||                           
                     'Nombre del Asegurado'  						||cLimitador||
                     'Nombre del Beneficiario'   				||cLimitador||
                     'Número de Aprobacion' 						||cLimitador||
                     'Monto Moneda		 ' 								||cLimitador||    
                     'Status Resolucion'   							||cLimitador||
                     'Fecha Status' 		  							||cLimitador||                                                                                                                                                                      
                     'Observaciones'		   							||cLimitador||  
                     'Operador del Pago'   							||cLimitador||                                                                                                                  
                     'Tipo Seguro'		 									||cLimitador|| 
                     'Descripcion' 											||CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   ELSE
      nLinea := 1;
      cCadena  := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                       ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                       ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                       ' <style id="libro">'||chr(10)||
                       '   <!--table'||chr(10)||
                       '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                       '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                       '        .texto'||chr(10)||
                       '          {mso-number-format:"\@";}'||chr(10)||
                       '        .numero'||chr(10)||
                       '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                       '        .fecha'||chr(10)||
                       '          {mso-number-format:"dd\\/mm\\/yyyy";}'||chr(10)||
                       '    -->'||chr(10)||
                       ' </style><div id="libro">'||chr(10);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea := nLinea + 1;
      cCadena     := '<table border = 0><tr><th>' || oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea := nLinea + 1;
      cCadena     := '<tr><th>MOVIMIENTOS APROBADOS Y PENDIENTES REPORTADOS DE SINIESTROS AL OFICIAL DE CUMPLIMIENTO'|| '</th></tr>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      
      nLinea := nLinea + 1;
      cCadena     := '<tr><th>'||TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' AL ' ||
                      TO_CHAR(dFecHasta,'DD/MM/YYYY') || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea := nLinea + 1;
      cCadena     := '<tr><th>  </th></tr></table>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea := nLinea + 1;
  
      cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Proceso</font></th>' 	||
      							 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza</font></th>' 													||
      							 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza Unico</font></th>' 										||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Siniestro</font></th>'   											||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del Cliente Contratante</font></th>'      		||                           
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del Asegurado</font></th>'      							||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del Beneficiario</font></th>'        					||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Número de Aprobación</font></th>' 										||                      
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Moneda</font></th>'   													||   
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Status Resolución</font></th>'   										||  
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha Status</font></th>'   													||                       
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Observaciones</font></th>'   												||    
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Operador del Pago</font></th>'   										||                                                                                                     
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo Seguro</font></th>' 														||                    
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Descripción</font></th>'  ;
										 									
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END IF;
   FOR X IN POL_Q LOOP
       --
       
       --
        --
       IF cFormato = 'TEXTO' THEN  
          cCadena := TO_CHAR(X.FECHA_PROCESO,'dd/mm/yyyy')      ||cLimitador||
          					 TO_CHAR(X.IdPoliza,'99999999999990')       ||cLimitador||
          					 X.NUMPOLUNICO												      ||cLimitador||   
                     TO_CHAR(X.NUMSINIESTRO,'99999999999990')   ||cLimitador||          					        					           
                     X.NOMBRECLIENTE                						||cLimitador||          
                     X.NOMBREASEGURADO               						||cLimitador||
                     X.NOMBRE_BENEFICIARIO   										||cLimitador||
                     TO_CHAR(X.NUM_APROBACION,'99999999999990') ||cLimitador||
                     X.MONTO_MONEDA    													||cLimitador||                     
                     X.ST_RESOLUCION                    			  ||cLimitador||
                     X.FECHASTATUS															||cLimitador||
                     X.OBSERVACIONES														||cLimitador||
										 X.USUARIO																	||cLimitador||	                     
         						 X.IDTIPOSEG			 													||cLimitador|| 
         						 X.descripcion															||CHR(13); 
       ELSE
          cCadena := '<tr>' || 
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FECHA_PROCESO,'dd/mm/yyyy'),'C')				||  
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdPoliza,'999999999999999990'),'C')		||
                     OC_ARCHIVO.CAMPO_HTML(X.NUMPOLUNICO,'C')																||                     
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.NUMSINIESTRO,'9999999999990'),'C')   	||
                     OC_ARCHIVO.CAMPO_HTML(X.NOMBRECLIENTE,'C')               							||                                                  
                     OC_ARCHIVO.CAMPO_HTML(X.NOMBREASEGURADO,'C')               						||
                     OC_ARCHIVO.CAMPO_HTML(X.NOMBRE_BENEFICIARIO ,'C')  										||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.NUM_APROBACION,'9999999999990'),'C') 	||                     
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.MONTO_MONEDA,'9999999999990.00'),'N')  ||                     
                     OC_ARCHIVO.CAMPO_HTML(X.ST_RESOLUCION ,'C')                   					||
                     OC_ARCHIVO.CAMPO_HTML(X.FECHASTATUS ,'C')                   						||    
                     OC_ARCHIVO.CAMPO_HTML(X.OBSERVACIONES ,'C')                   					|| 
                     OC_ARCHIVO.CAMPO_HTML(X.USUARIO ,'C')                   								||                                                          
         						 OC_ARCHIVO.CAMPO_HTML(X.IDTIPOSEG,'C')        													||
         						 OC_ARCHIVO.CAMPO_HTML(X.DESCRIPCION,'C') 															||                                                                                        
                     '</tr>';
       END IF;
       nLinea := nLinea + 1;
       OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
   IF cFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
   END IF;
OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);          
EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      raise_application_error(-20105,'Error en Generación de Clientes Reportados al Oficial de Cumplimiento ' ||SQLERRM); 
END;
PROCEDURE GENERAR_SINIESTROS_X_CAUSA (cNomArchivo VARCHAR2, 
                             dFecDesde DATE,    
                             dFecHasta DATE,
                             cFormato Varchar2,
                             nIdReporte NUMBER,
                             cCAUSASIN1 Varchar2,
                             cCAUSASIN2 Varchar2,
                             cCAUSASIN3 Varchar2,
                             cCAUSASIN4 Varchar2,
                             cCAUSASIN5 Varchar2,
                             cCAUSASIN6 Varchar2,
                             cCAUSASIN7 Varchar2,
                             cCAUSASIN8 Varchar2,
                             cCAUSASIN9 Varchar2,
                             cCAUSASIN10 Varchar2)IS
                         
cLimitador         		VARCHAR2(1) :='|';
nLinea             		NUMBER;
cCadena            		VARCHAR2(4000);
cCodUser           		VARCHAR2(30);
nDummy             		NUMBER;
cCopy              		BOOLEAN;
----
--ARCHIVO_SALIDA     CLIENT_TEXT_IO.FILE_TYPE; -- SPEEDFILE
LINEA_SALIDA       VARCHAR2(5000);           -- SPEEDFILE
WI_ARCHIVO_SALIDA  VARCHAR2(2000);           -- SPEEDFILE 
---- 
--
CURSOR SINCAUS_Q IS 
SELECT S.IDSINIESTRO,
       DECODE(P.INDPOLCOL,'N','INDIVIDUAL','COLECTIVO') TIPO_SINI,
       S.IDPOLIZA,
       S.IDETPOL,
       P.NUMPOLUNICO,
       S.FEC_OCURRENCIA,
       S.FEC_NOTIFICACION,
       DP.IDTIPOSEG,
       P.CODCLIENTE,
       OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE) NOM_CLIENTE,
       S.COD_ASEGURADO,
       OC_ASEGURADO.NOMBRE_ASEGURADO(S.CODCIA,S.CODEMPRESA,S.COD_ASEGURADO) NOM_ASEGURADO,
       S.MOTIVO_DE_SINIESTRO CAUSA,
       S.MONTO_RESERVA_MONEDA RESERVADO,
       S.MONTO_PAGO_MONEDA PAGADO,
       S.MONTO_RESERVA_MONEDA - S.MONTO_PAGO_MONEDA RESERVA_PENDIENTE,
       PNJ.FECNACIMIENTO,
       TRUNC(MONTHS_BETWEEN(TRUNC(S.FEC_OCURRENCIA),PNJ.FECNACIMIENTO) / 12) EDAD
  FROM SINIESTRO S,   --1022
       POLIZAS P,
       DETALLE_POLIZA DP,
       ASEGURADO A,
       PERSONA_NATURAL_JURIDICA PNJ
 WHERE S.FEC_OCURRENCIA BETWEEN dFecDesde AND dFecHasta
   --
   AND P.IDPOLIZA = S.IDPOLIZA 
   --
   AND DP.IDPOLIZA = S.IDPOLIZA
   AND DP.IDETPOL  = S.IDETPOL
   --
--   AND S.MOTIVO_DE_SINIESTRO IN ('J15','J96','B33','S82','A00','L02','999')
   AND S.MOTIVO_DE_SINIESTRO IN (cCAUSASIN1,cCAUSASIN2,cCAUSASIN3,cCAUSASIN4,cCAUSASIN5,cCAUSASIN6,cCAUSASIN7,cCAUSASIN8,cCAUSASIN9,cCAUSASIN10)
   --
   AND A.COD_ASEGURADO = S.COD_ASEGURADO
   --
   AND PNJ.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION
   AND PNJ.NUM_DOC_IDENTIFICACION  = A.NUM_DOC_IDENTIFICACION
   --
 ORDER BY 3,5;
--
BEGIN 
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
   IF cFormato = 'TEXTO' THEN
      nLinea := 1;
      cCadena     := oc_empresas.NOMBRE_COMPANIA(1) || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      nLinea := nLinea + 1;
      cCadena     := 'REPORTE DE SINIESTROS POR CAUSA O MOTIVO';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      nLinea := nLinea + 1;
      cCadena     := TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' AL ' || TO_CHAR(dFecHasta,'DD/MM/YYYY') || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      
      nLinea := nLinea + 1;
      cCadena     := ' ' || CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea); 
      nLinea := nLinea + 1;
      cCadena     := 'No. de Siniestro'  								||cLimitador||
      							 'Tipo de Siniestro'     								||cLimitador||
      							 'No. de Póliza'     					||cLimitador||
                     'No. de Detalle de Poliza'  								||cLimitador||
                     'No. único de Póliza '  	||cLimitador||                           
                     'Fecha de Ocurrencia'  						||cLimitador||
                     'Fecha de Notificación'   				||cLimitador||
                     'Tipo de seguro' 						||cLimitador||
                     'Codigo de cliente		 ' 								||cLimitador||    
                     'Nombre del cliente'   							||cLimitador||
                     'Codigo de asegurado' 		  							||cLimitador||                                                                                                                                                                      
                     'Nombre de Asegurado'		   							||cLimitador||  
                     'Causa de Siniestro'   							||cLimitador||                                                                                                                  
                     'Monto Reservado'		 									||cLimitador||
                     'Monto Pagado'		 									||cLimitador|| 
                     'Reserva Pendiente'		 									||cLimitador||
                     'Fecha de Nacimiento'		 									||cLimitador||                                                                                                             
                     'Edad' 											||CHR(13);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   ELSE
   	  --nDummy := alerta('jmmd entre por formato excel');
      nLinea := 1;
      cCadena  := '<html xmlns:o="urn:schemas-microsoft-com:office:office"'||chr(10)||
                       ' xmlns:x="urn:schemas-microsoft-com:office:excel"'||chr(10)||
                       ' xmlns="http://www.w3.org/TR/REC-html40">'||chr(10)||
                       ' <style id="libro">'||chr(10)||
                       '   <!--table'||chr(10)||
                       '       {mso-displayed-decimal-separator:"\.";'||chr(10)||
                       '        mso-displayed-thousand-separator:"\,";}'||chr(10)||
                       '        .texto'||chr(10)||
                       '          {mso-number-format:"\@";}'||chr(10)||
                       '        .numero'||chr(10)||
                       '          {mso-style-parent:texto; mso-number-format:"_-* \#\,\#\#0\.00_-\;\\-* \#\,\#\#0\.00_-\;_-* \0022-\0022??_-\;_-\@_-";}'||chr(10)||
                       '        .fecha'||chr(10)||
                       '          {mso-number-format:"dd\\/mm\\/yyyy";}'||chr(10)||
                       '    -->'||chr(10)||
                       ' </style><div id="libro">'||chr(10);
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea := nLinea + 1;
      cCadena     := '<table border = 0><tr><th>' || oc_empresas.NOMBRE_COMPANIA(1) || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea := nLinea + 1;
      cCadena     := '<tr><th>REPORTE DE SINIESTROS POR CAUSA O MOTIVO'|| '</th></tr>';
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      
      nLinea := nLinea + 1;
      cCadena     := '<tr><th>'||TO_CHAR(dFecDesde,'DD/MM/YYYY') || ' AL ' ||
                      TO_CHAR(dFecHasta,'DD/MM/YYYY') || '</th></tr>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea := nLinea + 1;
      cCadena     := '<tr><th>  </th></tr></table>'; 
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
      nLinea := nLinea + 1;
 
      cCadena     := '<table border = 1><tr><th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Siniestro</font></th>' 	||
      							 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de Siniestro</font></th>' 													||
      							 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Póliza</font></th>' 										||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. de Detalle de Poliza</font></th>'   											||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">No. único de Póliza</font></th>'      		||                           
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Ocurrencia</font></th>'      							||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Notificación</font></th>'        					||
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Tipo de seguro</font></th>' 										||                      
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Codigo de cliente	</font></th>'   													||   
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre del cliente</font></th>'   										||  
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Codigo de asegurado</font></th>'   													||                       
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Nombre de Asegurado</font></th>'   												||    
                     '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Causa de Siniestro</font></th>'   										||                                                                                                     
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Reservado</font></th>' 														||
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Monto Pagado</font></th>' 														||                    
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Reserva Pendiente</font></th>' 														||                    
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Fecha de Nacimiento</font></th>' 														||                    										 										 										                     
										 '<th align=center bgcolor = "#0B2161"><font color="#FFFFFF">Edad</font></th>'  ;
										 									
      OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END IF;
   	--  nDummy := alerta('jmmd antes del for ');   
   FOR X IN SINCAUS_Q LOOP
       --
        --
       IF cFormato = 'TEXTO' THEN  
          cCadena := TO_CHAR(X.IdSINIESTRO,'99999999999990')       ||cLimitador||
          					 X.TIPO_SINI												      ||cLimitador||   
          					 TO_CHAR(X.IdPoliza,'99999999999990')       ||cLimitador||
          					 TO_CHAR(X.IdetPol,'99999999999990')       ||cLimitador||
          					 X.NUMPOLUNICO												      ||cLimitador||  
                     TO_CHAR(X.FEC_OCURRENCIA,'dd/mm/yyyy')      ||cLimitador||
                     TO_CHAR(X.FEC_NOTIFICACION,'dd/mm/yyyy')      ||cLimitador||
          					 X.IDTIPOSEG												      ||cLimitador||   
                     X.CODCLIENTE                						||cLimitador||          
                     X.NOM_CLIENTE               						||cLimitador||
                     X.COD_ASEGURADO   										||cLimitador||
                     X.NOM_ASEGURADO   										||cLimitador||
                     X.CAUSA															||cLimitador||
                     TO_CHAR(X.RESERVADO,'99999999999990') ||cLimitador||
                     X.PAGADO    													||cLimitador||                     
                     X.RESERVA_PENDIENTE                    			  ||cLimitador||
										 TO_CHAR(X.FECNACIMIENTO,'dd/mm/yyyy')      ||cLimitador||         						 
         						 X.edad															||CHR(13); 
       ELSE
          cCadena := '<tr>' || 
                     
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdSiniestro,'999999999999999990'),'C')		||
                     OC_ARCHIVO.CAMPO_HTML(X.TIPO_SINI,'C')		||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdPoliza,'9999999999990'),'C')   	||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.IdetPol,'9999999999990'),'C')   	||
                     OC_ARCHIVO.CAMPO_HTML(X.NUMPOLUNICO,'C')																||                     
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_OCURRENCIA,'dd/mm/yyyy'),'C')				||  
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FEC_NOTIFICACION,'dd/mm/yyyy'),'C')				||  
                     OC_ARCHIVO.CAMPO_HTML(X.IDTIPOSEG,'C')               							||                                                                       
                     OC_ARCHIVO.CAMPO_HTML(X.CODCLIENTE,'C')               						||
                     OC_ARCHIVO.CAMPO_HTML(X.NOM_CLIENTE ,'C')  										||
                     OC_ARCHIVO.CAMPO_HTML(X.COD_ASEGURADO ,'C')  										||
                     OC_ARCHIVO.CAMPO_HTML(X.NOM_ASEGURADO ,'C')  										||
                     OC_ARCHIVO.CAMPO_HTML(X.CAUSA ,'C')  										||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.RESERVADO,'9999999999990.00'),'N') 	||                     
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.PAGADO,'9999999999990.00'),'N')  ||
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.RESERVA_PENDIENTE,'9999999999990.00'),'N')  ||                                          
                     OC_ARCHIVO.CAMPO_HTML(TO_CHAR(X.FECNACIMIENTO,'dd/mm/yyyy'),'C')				||  
         						 OC_ARCHIVO.CAMPO_HTML(X.Edad,'C') 															||                                                                                        
                     '</tr>';
       END IF;
       nLinea := nLinea + 1;
       OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
   END LOOP;
   --	  nDummy := alerta('jmmd despues del loop');   
   IF cFormato = 'EXCEL' THEN
      OC_ARCHIVO.Escribir_Linea('</table></div></html>', USER, 9999);
   END IF;
OC_ARCHIVO.Escribir_Linea('EOF', cCodUser, 0); 
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);          
EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      RAISE_APPLICATION_ERROR(-20105,'Error en Generación de Reporte ' ||SQLERRM);
END;


PROCEDURE PROC_CREA_ARCH_ERRORES(cCadena  VARCHAR2, cFin VARCHAR2, cCodUser IN OUT VARCHAR2, nLinea  IN OUT NUMBER, NIDREPORTE NUMBER) IS
nDummy           NUMBER;
cCopy            BOOLEAN;
cArchivo         VARCHAR2(400) := NULL;
BEGIN
   SELECT CODUSR
   INTO cCodUser
   FROM SICAS_OC.EXTRACCION_DE_REPORTES
   WHERE IDEXTRACCION = nIdReporte ;	
    
  IF cFin <> 'EOF' THEN
  nLinea := nLinea + 1;
  end if;
  OC_ARCHIVO.Escribir_Linea(cCadena, cCodUser, nLinea);
  IF cFin = 'EOF' THEN
INSERT INTO SICAS_OC.EXTRACCION_DE_REPORTES
SELECT nIdReporte +1, B.TIPO_REPORTE, B.CODUSR, SYSDATE, 'GEN', A.DATA , B.FILE_NAME
FROM  SICAS_OC.TEMP_GEN_ARCHIVO A, SICAS_OC.EXTRACCION_DE_REPORTES B
WHERE A.CODUSER = B.CODUSR
AND B.IDEXTRACCION = nIdReporte ;
COMMIT;
DELETE SICAS_OC.EXTRACCION_DE_REPORTES
WHERE IDEXTRACCION = nIdReporte ;
   
   OC_ARCHIVO.Eliminar_Archivo(cCodUser);          
  END IF;
EXCEPTION 
   WHEN OTHERS THEN 
      OC_ARCHIVO.Eliminar_Archivo(cCodUser); 
      RAISE_APPLICATION_ERROR(-20102,'Problemas en Generación del Archivo de Errores: ' || SQLERRM); 
      
END;

function agente(cTipo_Doc_Identificacion varchar2,cNum_Doc_Identificacion varchar2,nidpoliza number,nidetpol number) return varchar2 is
ccod_asegurado varchar2(50);
nidendoso number;
cestatusAseg varchar2(50);
nCAMPO3 number;
begin
    BEGIN
      SELECT   A.Cod_Asegurado, AC.IdEndoso, AC.CAMPO3, AC.Estado
        INTO cCod_Asegurado, nIdEndoso, nCAMPO3, cEstatusAseg
        FROM ASEGURADO A, ASEGURADO_CERTIFICADO AC, POLIZAS P
       WHERE P.IdPoliza                = nIdPoliza
         AND P.IdPoliza                = AC.IdPoliza
         AND P.CodCia                  = A.CodCia
         AND AC.CodCia                 = A.CodCia
         AND AC.Cod_Asegurado          = A.Cod_Asegurado
         AND AC.IDetPol                = nIDetPol 
         AND A.Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND A.Num_Doc_Identificacion  = cNum_Doc_Identificacion
      UNION
      SELECT  A.Cod_Asegurado,  0 , NULL, NULL
        FROM ASEGURADO A, ASEGURADO_CERT AC, POLIZAS P
       WHERE P.IdPoliza                = nIdPoliza
         AND P.IdPoliza                = AC.IdPoliza
         AND P.CodCia                  = A.CodCia
         AND AC.CodCia                 = A.CodCia
         AND AC.Cod_Asegurado          = A.Cod_Asegurado
         AND AC.IDETPOL                = nIDetPol 
         AND A.Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND A.Num_Doc_Identificacion  = cNum_Doc_Identificacion
      UNION
      SELECT  A.Cod_Asegurado, 0 , NULL, NULL
        FROM ASEGURADO A, DETALLE_POLIZA D
       WHERE OC_ASEGURADO_CERTIFICADO.TIENE_ASEGURADOS(D.CodCia, D.IdPoliza, D.IDetPol, 0) = 'N'
         AND D.IdPoliza                = nIdPoliza
         AND D.CodCia                  = A.CodCia
         AND D.Cod_Asegurado           = A.Cod_Asegurado
         AND A.Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND A.Num_Doc_Identificacion  = cNum_Doc_Identificacion;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        cCod_Asegurado := NULL;
      WHEN TOO_MANY_ROWS THEN
        cCod_Asegurado := NULL;
    END;
return ccod_asegurado;    
end;
END REPORTE_SINIESTROS;

/

GRANT EXECUTE ON SICAS_OC.REPORTE_SINIESTROS TO PUBLIC;

/

CREATE PUBLIC SYNONYM REPORTE_SINIESTROS FOR SICAS_OC.REPORTE_SINIESTROS;
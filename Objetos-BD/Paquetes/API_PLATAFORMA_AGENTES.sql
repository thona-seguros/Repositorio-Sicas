CREATE OR REPLACE PACKAGE THONAPI.API_PLATAFORMA_AGENTES AS
/******************************************************************************
   NOMBRE:       API_PLATAFORMA_AGENTES
   Desarrollado por Darbrain: 05-01-2021
******************************************************************************/

    PROCEDURE API_REPORTES_PRUEBA(dFechaInicio IN varchar, dFechaFin IN varchar, resultado OUT clob );
    PROCEDURE API_REPORTES_PRUEBA2(dFechaInicio IN varchar, dFechaFin IN varchar, resultado OUT SYS_REFCURSOR );

    PROCEDURE BI_CONSULTA_PAGOS_POL_COTI(dFechaIni in DATE, dFechaFin in DATE,nOpcion IN NUMBER,xResultado OUT SYS_REFCURSOR) ;

    PROCEDURE UNAM_POLIZAS(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, cCodAgrupador IN VARCHAR2, cPassword IN VARCHAR2, xResultado OUT XMLTYPE);
    PROCEDURE UNAM_ASEGURADO(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, cNombre IN VARCHAR2, cApePaterno IN VARCHAR2, cApeMaterno IN VARCHAR2, cFecNac IN VARCHAR2, cEmail IN VARCHAR2, cCodAgrupador IN VARCHAR2, xResultado OUT CLOB);
    PROCEDURE PA_CONSULTAR_POLIZAS(nCodCia in NUMBER, nCodEmpresa in NUMBER, nIdPoliza in NUMBER, nCodAgente in NUMBER, dFecIni in DATE,dFecFin in DATE, nIdCotizacion in NUMBER,cStsPoliza in VARCHAR2, cApePaternoCli in VARCHAR2,cApeMaternoCli in VARCHAR2, cNombreCli in VARCHAR2, pRegistrosPorPagina IN NUMBER, pNumPagina IN NUMBER,nCoDCliente IN NUMBER, resultado OUT CLOB);
    PROCEDURE PA_CONSULTAR_POLIZAS_TOTAL(nCodCia in NUMBER, nCodEmpresa in NUMBER, nIdPoliza in NUMBER, nCodAgente in NUMBER, dFecIni in DATE,dFecFin in DATE, nIdCotizacion in NUMBER, 
                                  cStsPoliza in VARCHAR2, cApePaternoCli in VARCHAR2,cApeMaternoCli in VARCHAR2, cNombreCli in VARCHAR2, pRegistrosPorPagina IN NUMBER, pNumPagina IN NUMBER, resultado OUT SYS_REFCURSOR);
    
    PROCEDURE PA_DETALLE_POLIZA(nCodCia in NUMBER, nCodEmpresa in NUMBER, nIdPoliza in NUMBER, xResultado out XMLTYPE);
    
    
    PROCEDURE PA_DETALLE_RECIBO(nNoRecibo IN NUMBER, nIdPoliza IN NUMBER, nCodCia IN NUMBER, nCodEmpresa IN NUMBER,xRespuesta OUT XMLTYPE );
    PROCEDURE PA_CATALOGO_ESTATUS_RECIBO(nCodCia IN NUMBER, xRespuesta OUT XMLTYPE);
    PROCEDURE PA_CATALOGO_PLAN_PAGO_RECIBO(nCodCia IN NUMBER,nCodEmpresa IN NUMBER, xRespuesta OUT XMLTYPE);
    PROCEDURE PA_LISTA_CLIENTES(nNoContratante IN NUMBER, cApePatContratante IN VARCHAR2,cApeMatContratante IN VARCHAR2,cNombreContratante IN VARCHAR2,cTipoPersona IN VARCHAR2,cIdentificadorFiscal IN VARCHAR2,nCodEmpresa IN NUMBER, nCodCia  IN NUMBER, nCodAgente IN NUMBER, numRegistros IN NUMBER, numPagina IN NUMBER, nTotRegs OUT NUMBER,nCodAgenteSesion IN NUMBER, nNivel IN NUMBER, xRespuesta OUT XMLTYPE);
    PROCEDURE PA_LISTA_CLIENTES_DETALLE(nNoContratante IN NUMBER,nCodEmpresa IN NUMBER, nCodCia IN NUMBER, nCodAgente IN NUMBER, xRespuesta OUT XMLTYPE);
    PROCEDURE PA_LISTA_TASA_CAMBIO(cFecha IN VARCHAR2,opcion IN NUMBER, xResultado OUT SYS_REFCURSOR);
    PROCEDURE PA_AGENTE_ESTRUCTURA(nCodAgente IN NUMBER,nCodCia IN NUMBER,nCodEmpresa IN NUMBER, xResultado OUT XMLTYPE);
    PROCEDURE PA_LISTA_ASEGURADO(nCodCia IN NUMBER,nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER, nCodAgente IN NUMBER,numRegistros IN NUMBER, numPagina IN NUMBER, nTotRegs OUT NUMBER, nCodAgenteSesion IN NUMBER, nNivel IN NUMBER, cNombreContratante IN VARCHAR2, cApePatContratante IN VARCHAR2, cApeMatContratante IN VARCHAR2, cNumPolUnico IN VARCHAR2,xRespuesta OUT XMLTYPE );
    PROCEDURE PA_DETALLE_ASEGURADO(nCodCia IN NUMBER, nCodEmpresa IN NUMBER,nNoAsegurado IN NUMBER,xRespuesta OUT XMLTYPE );
    
    PROCEDURE PA_CONSULTAR_L_POLIZAS(noContratante in NUMBER,nombreContratante in VARCHAR2, estatusPoliza in VARCHAR2, fechaEmisionDesde in DATE,fechaEmisionHasta in DATE,fechaVigenciaDesde in DATE, fechaVigenciaHasta in DATE, 
                                  codigoAgente  in varchar2, codAgenteSesion IN NUMBER, nivel IN NUMBER,  cantidaRegistros  IN NUMBER, numeroPagina  IN NUMBER,consecutivo IN NUMBER, noPoliza IN VARCHAR2, resultado OUT clob);
    PROCEDURE PA_CONSULTAR_POLIZAS_CSV(noContratante in NUMBER,nombreContratante in VARCHAR2, estatusPoliza in VARCHAR2, fechaEmisionDesde in DATE,fechaEmisionHasta in DATE,fechaVigenciaDesde in DATE, fechaVigenciaHasta in DATE, 
                                      codigoAgente  in varchar2,  cantidaRegistros  IN NUMBER, numeroPagina  IN NUMBER,consecutivo IN NUMBER, codAgenteSesion IN NUMBER, nivel IN NUMBER, noPoliza IN VARCHAR2, resultado OUT SYS_REFCURSOR);                              
    PROCEDURE PA_LISTA_BENEFICICARIOS(nCodAsegurado IN NUMBER,nIdPoliza IN NUMBER,nIdetPol IN NUMBER,nLimInferior IN NUMBER,nLimSuperior IN NUMBER,nTotRegs OUT NUMBER,xRespuesta OUT XMLTYPE);
    PROCEDURE PA_DETALLE_BENEFICIARIO(nCodAsegurado IN NUMBER, nIdPoliza IN NUMBER, nIdetPol IN NUMBER, nBenef IN NUMBER, xRespuesta OUT XMLTYPE);
    PROCEDURE PA_LISTA_RECIBOS(nNoRecibo IN NUMBER, cReciboEstatus IN VARCHAR2, nCodCliente IN NUMBER, nIdPoliza IN NUMBER,cNoPago IN VARCHAR2, cPlanPago IN VARCHAR2, nCodCia IN NUMBER,  dFecStsIni IN DATE, dFecStsFin IN DATE, dFechaInicio IN DATE, dFechaFin IN DATE,numRegistros IN NUMBER, numPagina IN NUMBER, nTotRegs OUT NUMBER,  nCodAgente IN NUMBER, nCodAgenteSesion IN NUMBER, nNivel IN NUMBER,nIdetPol IN NUMBER, cNumPolUnico IN VARCHAR2, cCodAgrupador IN VARCHAR2, xRespuesta OUT XMLTYPE );
    PROCEDURE PA_CONSULTAR_L_POLIZAS_REN(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, dFechaProceso IN DATE, nIdPoliza IN NUMBER, cStsProcWeb IN VARCHAR, cIndRespCte IN VARCHAR, nCodCliente IN NUMBER,cContratante in VARCHAR, dFecIniVig IN DATE, dFecFinVig IN DATE,cNumPolUnico IN VARCHAR, cCodAgente IN NUMBER,cCodPromotor IN NUMBER,cCodRegional IN NUMBER, nLimInferior IN NUMBER, nLimSuperior IN NUMBER, nTotRegs OUT NUMBER, xReporte OUT XMLTYPE);

    PROCEDURE API_CONSULTA_SICAS_FLUJOS(xConsultaServicioSicas XMLTYPE, SetSalidaXml OUT CLOB);
    PROCEDURE LISTADO_EJEC_COMERCIAL(nCodCia IN NUMBER, nLimInferior IN NUMBER, nLimSuperior IN NUMBER, nTotRegs OUT NUMBER, xRespuesta OUT XMLTYPE);
    
    PROCEDURE LISTADO_AGENTES_ASOCOCIADOS(nCodCia IN NUMBER, nCodEjecutivo IN NUMBER, nLimInferior IN NUMBER, nLimSuperior IN NUMBER, nTotRegs OUT NUMBER, xRespuesta OUT XMLTYPE);
    --PROCEDURE CATALOGO_LISTA_TRAMITES(nCodCia IN NUMBER,nCodEmpresa IN NUMBER, xRespuesta OUT XMLTYPE);
    FUNCTION LISTA_FESTIVOS (nCodCia  IN NUMBER,  nCodEmpresa IN NUMBER)RETURN XMLTYPE;
END API_PLATAFORMA_AGENTES;
/
CREATE OR REPLACE PACKAGE BODY THONAPI.API_PLATAFORMA_AGENTES AS

  PROCEDURE API_REPORTES_PRUEBA(dFechaInicio IN varchar, dFechaFin IN varchar, resultado OUT clob ) IS
    cRespuesta      varchar(100);
     cursor cursorPolizas is 
            --select POL.IDPOLIZA from polizas POL 
            --INNER JOIN COTIZACIONES COT ON POL.NUM_COTIZACION = COT.IDCOTIZACION 
            --where COT.CODCOTIZADOR LIKE '%WEB%' AND  POL.FECSOLICITUD < SYSDATE - nNumDias AND STSPOLIZA = 'PRE' ORDER BY POL.IDPOLIZA DESC;

    select idopenpay,idpoliza,idfactura from openpay_pagos; 
    BEGIN
    FOR p IN cursorPolizas LOOP
      resultado:= resultado || p.idopenpay ||','|| p.idpoliza || ',' || p.idfactura || '|';
      END LOOP; 

    END API_REPORTES_PRUEBA;
    --
    PROCEDURE API_REPORTES_PRUEBA2(dFechaInicio IN varchar, dFechaFin IN varchar, resultado OUT SYS_REFCURSOR ) IS
    BEGIN
        OPEN resultado FOR
            SELECT 
                IdOpenPay,
                IdPoliza,
                IdFactura,
                Cod_Moneda,					
                OC_MONEDA.DESCRIPCION_MONEDA(Cod_Moneda) Moneda, 				
                MontoPago_Local, 
                MontoPago_Moneda,
                StsPago,				
                Referencia_Thona,
                Referencia_OpenPay,				
                NumApprob_Openpay,
                FechaReg,
                FechaPag,
                FechAct				
            FROM OPENPAY_PAGOS  
            WHERE FechaReg >= TO_DATE(dFechaInicio,'DD/MM/YYYY') AND FechaReg < TO_DATE(dFechaFin,'DD/MM/YYYY')			
            ORDER BY IdOpenPay;  
    END API_REPORTES_PRUEBA2;
    --
   
    --
    PROCEDURE BI_CONSULTA_PAGOS_POL_COTI(dFechaIni in DATE, dFechaFin in DATE,nOpcion IN NUMBER,xResultado OUT SYS_REFCURSOR )IS
    cIdTipoSeg                  VARCHAR2(2):='%';
    cPlanCob                    VARCHAR2(2):='%';
    cDescPaqueteComercial       VARCHAR2(2):='%';
    nCodCia                     NUMBER:=1;
    nCodEmpresa                 NUMBER:=1;
    BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';

    IF(nOpcion = 1) THEN
        OPEN xResultado FOR
            SELECT IdOpenPay,IdPoliza,IdFactura,Cod_Moneda,					
                OC_MONEDA.DESCRIPCION_MONEDA(Cod_Moneda) Moneda, 				
                MontoPago_Local, MontoPago_Moneda,StsPago,				
                Referencia_Thona,Referencia_OpenPay,				
                NumApprob_Openpay,FechaReg,FechaPag,FechAct				
            FROM OPENPAY_PAGOS OP			             
            WHERE OP.FechaReg <= TO_DATE(dFechaFin,'DD-MM-YYYY') AND FechaReg >= TO_DATE(dFechaIni,'DD-MM-YYYY')
            --WHERE FechaReg BETWEEN :dFechaIni AND :dFechaFin			
            ORDER BY IdOpenPay;    	
    END IF;

    IF(nOpcion = 2) THEN
    OPEN xResultado FOR
    SELECT P.NumPolUnico,P.IdPoliza,P.Num_Cotizacion IdCotizacion,P.CodPaqComercial,   
                      DP.IdTipoSeg, OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(P.CodCia, P.CodEmpresa , DP.IdTipoSeg)DescTipoSeg,                                                                                                             
                      P.StsPoliza,P.FecEmision,OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) Cliente,                                                                                                             
                      OC_ASEGURADO.NOMBRE_ASEGURADO(P.CodCia, P.CodEmpresa, DP.Cod_Asegurado) Asegurado,                                                                                                       
                      P.Cod_Agente,OC_AGENTES.NOMBRE_AGENTE(P.CodCia,P.Cod_Agente) Agente                                                                                                              
                 FROM POLIZAS P, DETALLE_POLIZA DP                                                                                                        
               WHERE P.CodCia                                                                                    = nCodCia
                  AND P.CodEmpresa                                                                               = nCodEmpresa                             
                              AND P.StsPoliza           IN ('EMI','PRE')                                                                                              
                  AND ((DP.IdTipoSeg         = cIdTipoSeg AND cIdTipoSeg != '%')                                                                                                        
                   OR  (DP.IdTipoSeg      LIKE cIdTipoSeg AND cIdTipoSeg  = '%'))                                                                                                       
                  AND ((DP.PlanCob           = cPlanCob AND cPlanCob != '%')                                                                                                               
                   OR  (DP.PlanCob        LIKE cPlanCob AND cPlanCob  = '%'))                                                                                                              
                  AND ((P.CodPaqComercial    = cDescPaqueteComercial AND cDescPaqueteComercial != '%')                                                                                                          
                   OR  (P.CodPaqComercial LIKE cDescPaqueteComercial AND cDescPaqueteComercial  = '%'))                                                                                                          
                  AND P.FecEmision     BETWEEN dFechaIni AND dFechaFin                                                                                                         
                  AND P.CodCia                              = DP.CodCia                                                                                
                  AND P.IdPoliza                             = DP.IdPoliza;      
    END IF;
    IF(nOpcion = 3) THEN
        OPEN xResultado FOR
        SELECT C.IdCotizacion
           , C.NumUnicoCotizacion
           , C.CodCotizador
           , C.NumCotizacionRef
           , C.NumCotizacionAnt
           , OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', C.StsCotizacion) StsCotizacion
           , C.FecStatus
           , C.NombreContratante
           , C.FecIniVigCot
           , C.FecFinVigCot
           , C.FecCotizacion
           , C.FecVenceCotizacion
           , C.NumDiasRetroactividad
           , C.Cod_Moneda
           , C.SumaAsegCotLocal
           , C.SumaAsegCotMoneda
           , C.PrimaCotLocal
           , C.PrimaCotMoneda
           , C.IdTipoSeg
           , C.PlanCob
           , C.CodAgente
           , C.CodPlanPago
           , C.IdPoliza
           , C.PorcDescuento
           , C.PorcGtoAdmin
           , C.PorcGtoAdqui
           , C.PorcUtilidad
           , C.FactorAjuste
           , C.MontoDeducible
           , C.FactFormulaDeduc
           , C.PorcVariacionEmi
           , C.IndAsegModelo
           , C.IndListadoAseg
           , C.IndCensoSubgrupo
           , C.IndExtraPrima
           , C.CodRiesgoRea
           , C.CodTipoBono
           , C.DescPoliticaSumasAseg
           , C.DescPoliticaEdades
           , C.DescTipoIdentAseg
           , C.TipoAdministracion
           , C.AsegEnIncapacidad
           , C.HorasVig
           , C.DiasVig
           , C.CodUsuario
           , GT_COTIZADOR_CONFIG.DESCRIPCION_COTIZADOR(C.CodCia, C.CodEmpresa, C.CodCotizador) DescCotizador
           , OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(C.CodCia, C.CodEmpresa, C.IdTipoSeg) DescIdTipoSeg
           , OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(C.CodCia, C.CodEmpresa, C.IdTipoSeg, C.PlanCob) DescTipoPlan
           , OC_AGENTES.NOMBRE_AGENTE(C.CodCia, C.CodAgente) NombreAgente
           , OC_PLAN_DE_PAGOS.DESCRIPCION_PLAN(C.CodCia, C.CodEmpresa, C.CodPlanPago) DescPlanPago
           , OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ADMINPOL', C.TipoAdministracion) DescAdministracion
           , OC_VALORES_DE_LISTAS.BUSCA_LVALOR('CLASEBONO', C.CodTipoBono) ClaseBono
           , GT_REA_RIESGOS.DESCRIPCION_RIESGO(C.CodCia, C.CodRiesgoRea) DescRiesgoReaseguro
           , OC_GENERALES.FUN_NOMBREUSUARIO(C.CodCia, C.CodUsuario) NombreUsuario
           , GT_COTIZACIONES.IDENTIFICADOR_COTIZACION(C.CodCia, C.CodEmpresa, C.IdCotizacion) ADN
           , C.FecSolicitud
           , C.HoraSolicitud
           , C.CantAsegurados
           , DECODE(SUBSTR(C.NumUnicoCotizacion, LENGTH(C.NumUnicoCotizacion) -2, 4),'000','NUEVA','RECOTIZACIóN')  TipoCotizacion
           , C.CanalFormaVenta||' - '||OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT', C.CanalFormaVenta) CanalFormaVenta
           , C.SAMIAutorizado
           , C.NumPolRenovacion
           , C.PromedioSumaAseg
           , C.SumaAsegSAMI
           , C.AsegAdheridosPor||' - '||OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PRESCONT', C.AsegAdheridosPor) AsegAdheridosPor
           , C.PorcenContributorio
           , C.FuenteRecursosPrima||' - '||OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC', C.FuenteRecursosPrima) FuenteRecursosPrima
           , DECODE(C.TipoProrrata,'SPRO','Sin Prorrata','D365','Prorrata Diaria 365 Días') TipoProrrata
           , C.PorcComisDir
           , C.PorcComisProm
           , C.PorcComisAgte
           , DECODE(C.IndConvenciones,'S','SI','NO') IndConvenciones
           , C.PorcConvenciones
           , C.DescGiroNegocio
           , C.TextoSuscriptor
           , C.DescActividadAseg
           , C.DescFormulaDividendos
           , C.DescCuotasPrimaNiv
           , DECODE(NVL(C.PorcenContributorio,0),0,'N','S')            EsContributorio
           , UPPER(TXT.DescGiroNegocio)                                GiroNegocio
           , DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',C.CodTipoNegocio),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO',C.CodTipoNegocio)) TipoNegocio
           , DECODE(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',C.FuenteRecursosPrima),'Invalida','',OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FUENTEREC',C.FuenteRecursosPrima)) FuenteRecursos       
           , C.CodPaqComercial                                         CodPaqComercial
           , CGO.DescCatego                                            Categoria
           , C.IndCotizacionWeb
           , C.IndCotizacionBaseWeb
           , DECODE(sign(instr(C.CODCOTIZADOR,'V')),1,'VIDA','ACCIDENTES') AS RAMO
           , C.CodPaqComercial                                         NOMBRE_PRODUCTO
      FROM   Cotizaciones              C
         ,   Polizas_Texto_Cotizacion  TXT
         ,   Categorias                CGO      
      WHERE  C.CodCia              = nCodCia
        AND  C.CodEmpresa          = nCodEmpresa
        AND  C.FecCotizacion      >= dFechaIni
        AND  C.FecCotizacion      <= dFechaFin
        AND  TXT.CodCia(+)         = C.CodCia   
        AND  TXT.CodEmpresa(+)     = C.CodEmpresa
        AND  TXT.IdPoliza(+)       = C.IdPoliza
        AND  CGO.CodCia(+)         = C.CodCia 
        AND  CGO.CodEmpresa(+)     = C.CodEmpresa
        AND  CGO.CodTipoNegocio(+) = C.CodTipoNegocio
        AND  CGO.CodCatego(+)      = C.CodCatego;
    END IF;

    END BI_CONSULTA_PAGOS_POL_COTI;

    --
    PROCEDURE UNAM_POLIZAS(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, cCodAgrupador IN VARCHAR2, cPassword IN VARCHAR2, xResultado OUT XMLTYPE) IS
    BEGIN    
        xResultado:= OC_ASEGURADO_SERVICIOS_WEB. CONSULTA_POLIZA_UNAM (nCodCia,nCodEmpresa,cCodAgrupador,cPassword);
    END UNAM_POLIZAS;
    
    --
    PROCEDURE UNAM_ASEGURADO(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, cNombre IN VARCHAR2, cApePaterno IN VARCHAR2, cApeMaterno IN VARCHAR2, cFecNac IN VARCHAR2, cEmail IN VARCHAR2, cCodAgrupador IN VARCHAR2, xResultado OUT CLOB) IS
    xValor      boolean;
    BEGIN
        xResultado := OC_ASEGURADO_SERVICIOS_WEB.VALIDA_ASEG_UNAM(nCodCia,nCodEmpresa,cNombre,cApePaterno,cApeMaterno,cFecNac,cEmail,cCodAgrupador);       
    END UNAM_ASEGURADO;
    --

    --
    PROCEDURE PA_CONSULTAR_POLIZAS(nCodCia in NUMBER, nCodEmpresa in NUMBER, nIdPoliza in NUMBER, nCodAgente in NUMBER, dFecIni in DATE,dFecFin in DATE, nIdCotizacion in NUMBER, 
                                  cStsPoliza in VARCHAR2, cApePaternoCli in VARCHAR2,cApeMaternoCli in VARCHAR2, cNombreCli in VARCHAR2, pRegistrosPorPagina IN NUMBER, pNumPagina IN NUMBER, nCodCliente IN NUMBER, resultado OUT clob) IS
        cadenaRespuesta         CLOB;
        NUMREG                  NUMBER;     
        nNumRegIni              NUMBER := 1;
        nNumRegFin              NUMBER := 0;
        nNumeroTotalRegistros   NUMBER(5) := 0;
        nNumeroPaginas          NUMBER(5) :=0;
        
        CURSOR CUR_POLIZAS IS
    
            SELECT XMLELEMENT("Poliza",             
                   XMLELEMENT("IdPoliza",           IDPOLIZA),
                   XMLELEMENT("Producto",           PRODUCTO),
                   XMLELEMENT("NumPolUnico",        NUMPOLUNICO),
                   XMLELEMENT("CodigoContratante",  CODIGOCONTRATANTE),
                   XMLELEMENT("NombreContratante",  NOMBRECONTRATANTE),
                   XMLELEMENT("Estatus",            ESTATUS),
                   XMLELEMENT("FecEmision",         FECEMISION),
                   XMLELEMENT("InicioVigencia",     FECINIVIG),
                   XMLELEMENT("FinVigencia",        FECFINVIG),
                   XMLELEMENT("FecRenovacion",      FECRENOVACION),
                   XMLELEMENT("FecAnul",            FECANUL)) XMLDATOS,
                   IDPOLIZA
            FROM (
            SELECT 
                P.IDPOLIZA,
                P.CodPaqComercial AS PRODUCTO,
                P.NumPolUnico AS NUMPOLUNICO,
                P.CodCliente AS CODIGOCONTRATANTE,
                OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) AS NOMBRECONTRATANTE,
                OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', P.StsPoliza) AS ESTATUS,
                P.FECEMISION,
                P.FECINIVIG,
                P.FECFINVIG,
                P.FECRENOVACION,
                P.FecAnul AS FecAnul
            FROM POLIZAS P, AGENTE_POLIZA A, AGENTES AG, AGENTES AGP
            WHERE P.CodCia            = nCodCia
            AND P.CodEmpresa        = nCodEmpresa
            
            --AND A.Cod_Agente        = nCodAgente
            
            AND A.COD_AGENTE = AG.COD_AGENTE
            AND AG.cod_agente_jefe =  AGP.COD_AGENTE        
            AND ((AGP.cod_agente_jefe=nCodAgente OR AG.cod_agente_jefe = nCodAgente) or (AGP.cod_Agente = nCodAgente or AG.cod_agente=nCodAgente))
            
            AND P.StsPoliza        IN ('EMI','ANU','REN')
            AND P.FecEmision  BETWEEN NVL(dFecIni, P.FecEmision) AND NVL(dFecFin, P.FecEmision)
            --AND C.IdCotizacion      = NVL(nIdCotizacion, C.IdCotizacion)
            AND P.IdPoliza          = NVL(nIdPoliza,P.IdPoliza)
            --AND P.StsPoliza        IN NVL(:cStsPoliza, P.StsPoliza)
            --AND P.CodCia            = C.CodCia
            --AND P.CodEmpresa        = C.CodEmpresa
            --AND P.Num_Cotizacion    = C.IdCotizacion
            AND P.CodCliente        = NVL(nCodCliente,P.CodCliente)
            AND P.CodCia            = A.CodCia
            AND P.IdPoliza          = A.IdPoliza);
            L_ENACA CUR_POLIZAS%ROWTYPE;
            
            BEGIN
                EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
            
                SELECT COUNT(P.IdPoliza) INTO nNumeroTotalRegistros
                FROM POLIZAS P, AGENTE_POLIZA A, AGENTES AG, AGENTES AGP
                WHERE P.CodCia            = nCodCia
                AND P.CodEmpresa        = nCodEmpresa
                
                --AND A.Cod_Agente        = nCodAgente
                
                AND A.COD_AGENTE = AG.COD_AGENTE
                AND AG.cod_agente_jefe =  AGP.COD_AGENTE        
                AND ((AGP.cod_agente_jefe=nCodAgente OR AG.cod_agente_jefe = nCodAgente) or (AGP.cod_Agente = nCodAgente or AG.cod_agente=nCodAgente))
           
                AND P.StsPoliza        IN ('EMI','ANU','REN')
                AND P.FecEmision        BETWEEN NVL(dFecIni, P.FecEmision) AND NVL(dFecFin, P.FecEmision)
               -- AND C.IdCotizacion      = NVL(nIdCotizacion, C.IdCotizacion)
                AND P.IdPoliza          = NVL(nIdPoliza,P.IdPoliza)
                --AND P.StsPoliza        IN NVL(:cStsPoliza, P.StsPoliza)
                --AND P.CodCia            = C.CodCia
                --AND P.CodEmpresa        = C.CodEmpresa
                --AND P.Num_Cotizacion    = C.IdCotizacion
                AND P.CodCliente        = NVL(nCodCliente,P.CodCliente)
                AND P.CodCia            = A.CodCia
                AND P.IdPoliza          = A.IdPoliza;
                IF(nNumeroTotalRegistros>pRegistrosPorPagina) THEN
                    nNumeroPaginas := ceil(nNumeroTotalRegistros/pRegistrosPorPagina);
                ELSE
                    nNumeroPaginas:=1;
                END IF;
                
                NUMREG := 0;
                cadenaRespuesta := '<?xml version="1.0" encoding="UTF-8" ?><POLIZAS>';
                
                IF(pNumPagina <= nNumeroPaginas AND pNumPagina > 0) THEN 
                    nNumRegIni := pRegistrosPorPagina *(pNumPagina - 1) + 1;
                    IF(nNumeroTotalRegistros>pRegistrosPorPagina) THEN
                        nNumRegFin := nNumRegIni + (pRegistrosPorPagina - 1);
                    ELSE
                        nNumRegFin :=nNumeroTotalRegistros;
                    END IF;
                    dbms_output.put_line(nNumeroPaginas);   
                    dbms_output.put_line(nNumeroTotalRegistros);   
                    OPEN CUR_POLIZAS;
                        LOOP
                            FETCH CUR_POLIZAS INTO L_ENACA;
                            EXIT WHEN CUR_POLIZAS%NOTFOUND;
                            --
                            NUMREG := NUMREG + 1;
                            IF NUMREG BETWEEN nNumRegIni AND nNumRegFin THEN
                                cadenaRespuesta := cadenaRespuesta || L_ENACA.XMLDATOS.getclobval();
                            END IF;
                            IF NUMREG = nNumRegFin THEN
                                EXIT;
                            END IF;
                        END LOOP;
                    CLOSE CUR_POLIZAS;
                
                    IF(nIdPoliza > 0 ) THEN 
                        cadenaRespuesta :=  cadenaRespuesta || '<CONTROL><RESPONSE>TRUE</RESPONSE><TOTAL_PAGINAS>1</TOTAL_PAGINAS><TOTAL_POLIZAS>1</TOTAL_POLIZAS></CONTROL></POLIZAS>';
                        resultado:= cadenaRespuesta;
                    ELSE
                        cadenaRespuesta :=  cadenaRespuesta || '<CONTROL><RESPONSE>TRUE</RESPONSE><TOTAL_PAGINAS>'||nNumeroPaginas||'</TOTAL_PAGINAS><TOTAL_POLIZAS>'||nNumeroTotalRegistros||'</TOTAL_POLIZAS></CONTROL></POLIZAS>';
                        resultado:= cadenaRespuesta;
                    END IF;
				ELSE
				    	cadenaRespuesta:= '<POLIZAS><CONTROL><RESPONSE>FALSE</RESPONSE><TOTAL_PAGINAS>'||nNumeroPaginas||'</TOTAL_PAGINAS><TOTAL_POLIZAS>'||nNumeroTotalRegistros||'</TOTAL_POLIZAS></CONTROL></POLIZAS>';
						resultado := cadenaRespuesta;
                END IF;
        END PA_CONSULTAR_POLIZAS;
        ---
    PROCEDURE PA_CONSULTAR_POLIZAS_TOTAL(nCodCia in NUMBER, nCodEmpresa in NUMBER, nIdPoliza in NUMBER, nCodAgente in NUMBER, dFecIni in DATE,dFecFin in DATE, nIdCotizacion in NUMBER, 
                                  cStsPoliza in VARCHAR2, cApePaternoCli in VARCHAR2,cApeMaternoCli in VARCHAR2, cNombreCli in VARCHAR2, pRegistrosPorPagina IN NUMBER, pNumPagina IN NUMBER, resultado OUT SYS_REFCURSOR) IS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
        OPEN resultado FOR
        SELECT
            P.IDPOLIZA,
            P.CodPaqComercial AS PRODUCTO,
            P.NumPolUnico AS NUMPOLUNICO,
            P.CodCliente AS CODIGOCONTRATANTE,
            OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) AS NOMBRECONTRATANTE,
            OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', P.StsPoliza) AS ESTATUS,
            P.FECEMISION,
            P.FECINIVIG,
            P.FECFINVIG,
            P.FECRENOVACION,
            P.FecAnul AS FecAnul
        FROM POLIZAS P, COTIZACIONES C, AGENTE_POLIZA A
            WHERE P.CodCia            = nCodCia
            AND P.CodEmpresa        = nCodEmpresa
            AND A.Cod_Agente        = nCodAgente
            AND P.StsPoliza        IN ('EMI','ANU','REN')
            AND P.FecEmision  BETWEEN NVL(dFecIni, P.FecEmision) AND NVL(dFecFin, P.FecEmision)
            AND C.IdCotizacion      = NVL(nIdCotizacion, C.IdCotizacion)
            AND P.IdPoliza          = NVL(nIdPoliza,P.IdPoliza)
            --AND P.StsPoliza        IN NVL(:cStsPoliza, P.StsPoliza)
            AND P.CodCia            = C.CodCia
            AND P.CodEmpresa        = C.CodEmpresa
            AND P.Num_Cotizacion    = C.IdCotizacion
            AND P.CodCia            = A.CodCia
            AND P.IdPoliza          = A.IdPoliza;
    END PA_CONSULTAR_POLIZAS_TOTAL;

        PROCEDURE PA_DETALLE_POLIZA(nCodCia in NUMBER, nCodEmpresa in NUMBER, nIdPoliza in NUMBER, xResultado out XMLTYPE) IS
    
    BEGIN
        xResultado:= OC_POLIZAS_SERVICIOS_WEB.CONSULTA_POLIZA(nCodCia, nCodEmpresa, nIdPoliza);
    END PA_DETALLE_POLIZA;

    PROCEDURE PA_DETALLE_RECIBO(nNoRecibo IN NUMBER, nIdPoliza IN NUMBER, nCodCia IN NUMBER, nCodEmpresa IN NUMBER,xRespuesta OUT XMLTYPE ) IS
    BEGIN
        xRespuesta := SICAS_OC.OC_FACTURAS_SERVICIOS_WEB.CONSULTA_FACTURA(nNoRecibo, nIdPoliza,  nCodCia, nCodEmpresa);
    END PA_DETALLE_RECIBO;
    --
    PROCEDURE PA_CATALOGO_ESTATUS_RECIBO(nCodCia IN NUMBER, xRespuesta OUT XMLTYPE) IS
    BEGIN
        xRespuesta := SICAS_OC.OC_FACTURAS_SERVICIOS_WEB.ESTADO_FACTURA(nCodCia); 
    END PA_CATALOGO_ESTATUS_RECIBO;
    --
    PROCEDURE PA_CATALOGO_PLAN_PAGO_RECIBO(nCodCia IN NUMBER,nCodEmpresa IN NUMBER, xRespuesta OUT XMLTYPE) IS
    BEGIN
        xRespuesta := SICAS_OC.OC_FACTURAS_SERVICIOS_WEB.PLAN_PAGO_FACTURA(nCodCia,nCodEmpresa); 
    END PA_CATALOGO_PLAN_PAGO_RECIBO;
    --
    PROCEDURE PA_LISTA_CLIENTES(nNoContratante IN NUMBER, cApePatContratante IN VARCHAR2,cApeMatContratante IN VARCHAR2,cNombreContratante IN VARCHAR2,cTipoPersona IN VARCHAR2,cIdentificadorFiscal IN VARCHAR2,nCodEmpresa IN NUMBER, nCodCia  IN NUMBER, nCodAgente IN NUMBER, numRegistros IN NUMBER, numPagina IN NUMBER, nTotRegs OUT NUMBER,nCodAgenteSesion IN NUMBER, nNivel IN NUMBER, xRespuesta OUT XMLTYPE) IS
    nLimInferior            NUMBER:=0;
    nLimSuperior            NUMBER:=0;
    BEGIN
        nLimInferior := numRegistros *(numPagina - 1) + 1;
        
        nLimSuperior := nLimInferior + (numRegistros - 1);
        DBMS_OUTPUT.PUT_LINE(nLimInferior);
        DBMS_OUTPUT.PUT_LINE(nLimSuperior);
        
        xRespuesta := OC_CLIENTES_SERVICIOS_WEB.LISTADO_CLIENTE(nNoContratante,cApePatContratante,cApeMatContratante,cNombreContratante,cTipoPersona,cIdentificadorFiscal,nCodEmpresa,nCodCia,nCodAgente,nLimInferior,nLimSuperior,nTotRegs,nCodAgenteSesion,nNivel);
    END PA_LISTA_CLIENTES;
    --
    PROCEDURE PA_LISTA_CLIENTES_DETALLE(nNoContratante IN NUMBER,nCodEmpresa IN NUMBER, nCodCia IN NUMBER, nCodAgente IN NUMBER, xRespuesta OUT XMLTYPE) IS
    BEGIN
        xRespuesta := OC_CLIENTES_SERVICIOS_WEB.CONSULTA_CLIENTE(nNoContratante,nCodEmpresa,nCodCia,nCodAgente);
    END PA_LISTA_CLIENTES_DETALLE;
    --

        PROCEDURE PA_LISTA_TASA_CAMBIO(cFecha IN VARCHAR2, opcion IN NUMBER, xResultado OUT SYS_REFCURSOR) IS
    BEGIN
        
        IF (opcion = 1) THEN
            OPEN xResultado FOR
            SELECT FECHA_HORA_CAMBIO,TASA_CAMBIO FROM TASAS_CAMBIO WHERE COD_MONEDA = 'USD' ORDER BY FECHA_HORA_CAMBIO DESC;
        ELSE
            OPEN xResultado FOR
            
            SELECT FECHA_HORA_CAMBIO,TASA_CAMBIO FROM TASAS_CAMBIO WHERE COD_MONEDA = 'USD' AND fecha_hora_cambio = ''||cFecha||'' ORDER BY FECHA_HORA_CAMBIO DESC;
        END IF;
    END PA_LISTA_TASA_CAMBIO;
    --
    PROCEDURE PA_AGENTE_ESTRUCTURA(nCodAgente IN NUMBER,nCodCia IN NUMBER,nCodEmpresa IN NUMBER, xResultado OUT XMLTYPE) IS
    BEGIN
        xResultado := OC_AGENTES_SEVICIOS_WEB.JERARQ_AGENTE(nCodAgente,nCodCia,nCodEmpresa); 
    END PA_AGENTE_ESTRUCTURA;
    
    
    
    PROCEDURE PA_LISTA_ASEGURADO(nCodCia IN NUMBER,nCodEmpresa IN NUMBER, nIdPoliza IN NUMBER, nCodAgente IN NUMBER,numRegistros IN NUMBER, numPagina IN NUMBER, nTotRegs OUT NUMBER, nCodAgenteSesion IN NUMBER, nNivel IN NUMBER, cNombreContratante IN VARCHAR2, cApePatContratante IN VARCHAR2, cApeMatContratante IN VARCHAR2, cNumPolUnico IN VARCHAR2,xRespuesta OUT XMLTYPE ) IS
    nLimInferior            NUMBER:=0;
    nLimSuperior            NUMBER:=0;
    BEGIN
        nLimInferior := numRegistros *(numPagina - 1) + 1;
        nLimSuperior := nLimInferior + (numRegistros - 1);
        
        xRespuesta := OC_ASEGURADO_SERVICIOS_WEB.LISTADO_ASEGURADO (nCodCia,nCodEmpresa,nIdPoliza,nCodAgente,nLimInferior,nLimSuperior,nTotRegs,nCodAgenteSesion,nNivel,cNombreContratante,cApePatContratante,cApeMatContratante,cNumPolUnico);
    END PA_LISTA_ASEGURADO;
    
    
    PROCEDURE PA_DETALLE_ASEGURADO(nCodCia IN NUMBER, nCodEmpresa IN NUMBER,nNoAsegurado IN NUMBER,xRespuesta OUT XMLTYPE ) IS
    BEGIN
        xRespuesta := OC_ASEGURADO_SERVICIOS_WEB.CONSULTA_ASEGURADO (nCodCia,nCodEmpresa,nNoAsegurado);
    END PA_DETALLE_ASEGURADO;
    --

    PROCEDURE PA_CONSULTAR_L_POLIZAS(noContratante in NUMBER,nombreContratante in VARCHAR2, estatusPoliza in VARCHAR2, fechaEmisionDesde in DATE,fechaEmisionHasta in DATE,fechaVigenciaDesde in DATE, fechaVigenciaHasta in DATE, 
                                  codigoAgente  in varchar2, codAgenteSesion IN NUMBER, nivel IN NUMBER,  cantidaRegistros  IN NUMBER, numeroPagina  IN NUMBER,consecutivo IN NUMBER, noPoliza IN VARCHAR2, resultado OUT clob) IS
        cadenaRespuesta         CLOB;
        totalRegistros  NUMBER := 0;
        nombre_contratante varchar2(250) := nombreContratante;
		CURSOR polizas_cur
        IS
            SELECT t1.numpolunico AS IDPOLIZA,
            t1.CODPAQCOMERCIAL,
            t1.IDPOLIZA AS CONSECUTIVO,
            t1.CODCLIENTE,
            t1.NOMBRECONTRATANTE,
            t1.ESTATUS,
            t1.fecsts AS FECHASTATUS,
            t1.fecinivig,
            t1.fecfinvig,
            ROWNUM AS numberRow
            FROM(
                SELECT P.IDPOLIZA,
                P.CODPAQCOMERCIAL,
                P.IDPOLIZA AS CONSECUTIVO,
                P.CODCLIENTE,
                OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) AS NOMBRECONTRATANTE,
                OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', P.StsPoliza) AS ESTATUS,
                p.fecsts,
                p.fecinivig,
                p.fecfinvig,
                p.numpolunico,
                A.cod_agente,
                p.fecemision
                FROM polizas P
                INNER JOIN agente_poliza AP ON AP.idpoliza = P.idpoliza
                INNER JOIN agentes A ON A.cod_agente = AP.cod_agente
                WHERE P.CodCia = 1
                AND P.CodEmpresa = 1
                AND P.StsPoliza NOT IN ('SOL','PRE')
                AND (noContratante IS NULL OR P.CODCLIENTE = noContratante)
                AND (fechaEmisionDesde IS NULL OR P.fecemision >= fechaEmisionDesde)
                AND (fechaEmisionHasta IS NULL OR P.fecemision <= fechaEmisionHasta)
                AND (fechaVigenciaDesde IS NULL OR P.fecinivig >= fechaVigenciaDesde)
                AND (fechaVigenciaHasta IS NULL OR P.fecinivig <= fechaVigenciaHasta)
                AND (consecutivo IS NULL OR p.idpoliza = consecutivo)
                AND (estatusPoliza IS NULL OR p.StsPoliza = estatusPoliza)
                AND (noPoliza IS NULL OR p.numpolunico = noPoliza)
                AND P.idpoliza in (select idpoliza
                    from AGENTES_DISTRIBUCION_POLIZA
                    where codnivel = nivel
                    and cod_agente_distr = codAgenteSesion
                    and cod_agente in (select regexp_substr(codigoAgente,'[^,]+', 1, level) from dual connect by regexp_substr(codigoAgente, '[^,]+', 1, level) is not null))
                --AND A.COD_AGENTE in (select regexp_substr(codigoAgente,'[^,]+', 1, level) from dual connect by regexp_substr(codigoAgente, '[^,]+', 1, level) is not null)
            ) t1
            WHERE (nombre_contratante IS NULL OR t1.NOMBRECONTRATANTE LIKE '%'|| nombre_contratante ||'%')
            AND (estatusPoliza IS NULL OR t1.ESTATUS LIKE '%'|| estatusPoliza ||'%');
            --AND ROWNUM BETWEEN inicioPaginador AND finPaginador;            
            fila_poliza   polizas_cur%ROWTYPE;
            --numRegistrosFin NUMBER := numeroPagina * cantidaRegistros;
            --numRegistrosInicio NUMBER := ((numeroPagina * cantidaRegistros) - cantidaRegistros) + 1;
BEGIN
     OPEN polizas_cur;
     cadenaRespuesta := '<?xml version="1.0" encoding="UTF-8" ?><DATA>';
     LOOP
        FETCH polizas_cur INTO fila_poliza;
        EXIT WHEN polizas_cur%NOTFOUND;
        IF(fila_poliza.numberRow >= ((numeroPagina * cantidaRegistros) - cantidaRegistros) + 1 AND fila_poliza.numberRow <= numeroPagina * cantidaRegistros) THEN
        cadenaRespuesta := cadenaRespuesta || '<POLIZA>';
        cadenaRespuesta := cadenaRespuesta || '<IDPOLIZA>' || fila_poliza.idpoliza || '</IDPOLIZA>';
        cadenaRespuesta := cadenaRespuesta || '<CODPAQUETECOMERCIAL>' || fila_poliza.CODPAQCOMERCIAL || '</CODPAQUETECOMERCIAL>';
        cadenaRespuesta := cadenaRespuesta || '<CONSECUTIVO>' || fila_poliza.CONSECUTIVO || '</CONSECUTIVO>';
        cadenaRespuesta := cadenaRespuesta || '<CODCLIENTE>' || fila_poliza.CODCLIENTE || '</CODCLIENTE>';
        cadenaRespuesta := cadenaRespuesta || '<NOMBRECONTRATANTE>' || fila_poliza.NOMBRECONTRATANTE || '</NOMBRECONTRATANTE>';
        cadenaRespuesta := cadenaRespuesta || '<ESTATUS>' || fila_poliza.ESTATUS || '</ESTATUS>';
        cadenaRespuesta := cadenaRespuesta || '<FECSTS>' || fila_poliza.FECHASTATUS || '</FECSTS>';
        cadenaRespuesta := cadenaRespuesta || '<FECINIVIG>' || fila_poliza.fecinivig || '</FECINIVIG>';
        cadenaRespuesta := cadenaRespuesta || '<FECFINVIG>' || fila_poliza.fecfinvig || '</FECFINVIG>';
        cadenaRespuesta := cadenaRespuesta || '</POLIZA>';
        --totalRegistros := totalRegistros + 1;
        END IF;
        totalRegistros := totalRegistros +1 ;
     END LOOP;
     --cadenaRespuesta := cadenaRespuesta || '</POLIZAS>';
     -- FIN DEL LOOP
     --numeroPaginas := totalregistros/finPaginador;
     --if(ROUND(numeroPaginas) < numeroPaginas) then
     --   numeroPaginas := ROUND(numeroPaginas) + 1;
     --end if;
     cadenaRespuesta := cadenaRespuesta || '<CONTROL>';
     cadenaRespuesta := cadenaRespuesta || '<TOTALREGISTROS>'|| totalRegistros ||'</TOTALREGISTROS>';
     cadenaRespuesta := cadenaRespuesta || '</CONTROL>';
     cadenaRespuesta := cadenaRespuesta || '</DATA>';
     DBMS_OUTPUT.PUT_LINE(TO_CHAR(cadenaRespuesta));
     resultado := cadenaRespuesta;
     CLOSE polizas_cur;
END PA_CONSULTAR_L_POLIZAS;


    PROCEDURE PA_CONSULTAR_POLIZAS_CSV(noContratante in NUMBER,nombreContratante in VARCHAR2, estatusPoliza in VARCHAR2, fechaEmisionDesde in DATE,fechaEmisionHasta in DATE,fechaVigenciaDesde in DATE, fechaVigenciaHasta in DATE, 
                                      codigoAgente  in varchar2,  cantidaRegistros  IN NUMBER, numeroPagina  IN NUMBER,consecutivo IN NUMBER, codAgenteSesion IN NUMBER, nivel IN NUMBER, noPoliza IN VARCHAR2, resultado OUT SYS_REFCURSOR) IS
    nombre_contratante varchar2(250) := nombreContratante;
    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';
		OPEN resultado FOR
            SELECT t1.numpolunico AS IDPOLIZA,
            t1.CODPAQCOMERCIAL,
            t1.IDPOLIZA AS CONSECUTIVO,
            t1.CODCLIENTE,
            t1.NOMBRECONTRATANTE,
            t1.ESTATUS,
            TO_CHAR(t1.fecsts,'DD/MM/YYYY') AS FECHASTATUS,
            TO_CHAR(t1.fecinivig,'DD/MM/YYYY') AS fecinivig,
            TO_CHAR(t1.fecfinvig,'DD/MM/YYYY') AS fecfinvig
            FROM(
                SELECT P.IDPOLIZA,
                P.CODPAQCOMERCIAL,
                P.IDPOLIZA AS CONSECUTIVO,
                P.CODCLIENTE,
                OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente) AS NOMBRECONTRATANTE,
                OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', P.StsPoliza) AS ESTATUS,
                p.fecsts,
                p.fecinivig,
                p.fecfinvig,
                p.numpolunico,
                A.cod_agente,
                p.fecemision
                FROM polizas P
                INNER JOIN agente_poliza AP ON AP.idpoliza = P.idpoliza
                INNER JOIN agentes A ON A.cod_agente = AP.cod_agente
                WHERE P.CodCia = 1
                AND P.CodEmpresa = 1
                AND P.StsPoliza NOT IN ('SOL','PRE')
                AND (noContratante IS NULL OR P.CODCLIENTE = noContratante)
                AND (fechaEmisionDesde IS NULL OR P.fecemision >= fechaEmisionDesde)
                AND (fechaEmisionHasta IS NULL OR P.fecemision <= fechaEmisionHasta)
                AND (fechaVigenciaDesde IS NULL OR P.fecinivig >= fechaVigenciaDesde)
                AND (fechaVigenciaHasta IS NULL OR P.fecinivig <= fechaVigenciaHasta)
                AND (consecutivo IS NULL OR p.idpoliza = consecutivo)
                AND (noPoliza IS NULL OR p.numpolunico = noPoliza)
                AND P.idpoliza in (select idpoliza
                    from AGENTES_DISTRIBUCION_POLIZA
                    where codnivel = nivel
                    and cod_agente_distr = codAgenteSesion
                    and cod_agente in (select regexp_substr(codigoAgente,'[^,]+', 1, level) from dual connect by regexp_substr(codigoAgente, '[^,]+', 1, level) is not null))
                --AND A.COD_AGENTE in (select regexp_substr(codigoAgente,'[^,]+', 1, level) from dual connect by regexp_substr(codigoAgente, '[^,]+', 1, level) is not null)
            ) t1
            WHERE (nombre_contratante IS NULL OR t1.NOMBRECONTRATANTE LIKE '%'|| nombre_contratante ||'%')
            AND (estatusPoliza IS NULL OR t1.ESTATUS LIKE '%'|| estatusPoliza ||'%');
    END PA_CONSULTAR_POLIZAS_CSV;



    PROCEDURE PA_LISTA_BENEFICICARIOS(nCodAsegurado IN NUMBER,nIdPoliza IN NUMBER,nIdetPol IN NUMBER,nLimInferior IN NUMBER,nLimSuperior IN NUMBER,nTotRegs OUT NUMBER,xRespuesta OUT XMLTYPE)IS
    BEGIN
        xRespuesta := SICAS_OC.OC_BENEFICIARIOS_SERVICIOS_WEB.LISTADO_BENEFICIARIO( nCodAsegurado,nIdPoliza,nIdetPol,nLimInferior,nLimSuperior,nTotRegs);
    END PA_LISTA_BENEFICICARIOS;
    
    PROCEDURE PA_DETALLE_BENEFICIARIO(nCodAsegurado IN NUMBER, nIdPoliza IN NUMBER, nIdetPol IN NUMBER, nBenef IN NUMBER, xRespuesta OUT XMLTYPE)IS
    BEGIN
        xRespuesta := SICAS_OC.OC_BENEFICIARIOS_SERVICIOS_WEB.CONSULTA_BENEFICIARIO (nCodAsegurado,nIdPoliza,nIdetPol,nBenef);
    END PA_DETALLE_BENEFICIARIO;
    
    PROCEDURE PA_LISTA_RECIBOS(nNoRecibo IN NUMBER, cReciboEstatus IN VARCHAR2, nCodCliente IN NUMBER, nIdPoliza IN NUMBER,cNoPago IN VARCHAR2, cPlanPago IN VARCHAR2, nCodCia IN NUMBER,  dFecStsIni IN DATE, dFecStsFin IN DATE, dFechaInicio IN DATE, dFechaFin IN DATE,numRegistros IN NUMBER, numPagina IN NUMBER, nTotRegs OUT NUMBER,  nCodAgente IN NUMBER, nCodAgenteSesion IN NUMBER, nNivel IN NUMBER,nIdetPol IN NUMBER, cNumPolUnico IN VARCHAR2, cCodAgrupador IN VARCHAR2, xRespuesta OUT XMLTYPE ) IS
    nLimInferior            NUMBER:=0;
    nLimSuperior            NUMBER:=0;
    BEGIN
        nLimInferior := numRegistros *(numPagina - 1) + 1;
        nLimSuperior := nLimInferior + (numRegistros - 1);
        
        xRespuesta := SICAS_OC.OC_FACTURAS_SERVICIOS_WEB.LISTADO_FACTURA(nNoRecibo,cReciboEstatus,nCodCliente,nIdPoliza,cNoPago,cPlanPago,nCodCia,dFecStsIni,dFecStsFin,dFechaInicio,dFechaFin,nLimInferior,nLimSuperior,nTotRegs,nCodAgente,nCodAgenteSesion,nNivel,nIdetPol,cNumPolUnico,cCodAgrupador);
    END PA_LISTA_RECIBOS;

    
    PROCEDURE PA_CONSULTAR_L_POLIZAS_REN(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, dFechaProceso IN DATE, nIdPoliza IN NUMBER, cStsProcWeb IN VARCHAR, cIndRespCte IN VARCHAR, nCodCliente IN NUMBER,cContratante in VARCHAR, dFecIniVig IN DATE, dFecFinVig IN DATE,cNumPolUnico IN VARCHAR, cCodAgente IN NUMBER,cCodPromotor IN NUMBER,cCodRegional IN NUMBER, nLimInferior IN NUMBER, nLimSuperior IN NUMBER, nTotRegs OUT NUMBER, xReporte OUT XMLTYPE) IS
    BEGIN
        xReporte := OC_RENOVACION.REPORTE_POLIZASRENOVAR(nCodCia, nCodEmpresa, dFechaProceso, nIdPoliza, cStsProcWeb, cIndRespCte, nCodCliente, cContratante, dFecIniVig, dFecFinVig, cNumPolUnico, cCodAgente, cCodPromotor, cCodRegional, nLimInferior, nLimSuperior, nTotRegs);
    END PA_CONSULTAR_L_POLIZAS_REN;

    PROCEDURE API_CONSULTA_SICAS_FLUJOS(xConsultaServicioSicas XMLTYPE, SetSalidaXml OUT CLOB) IS
        cNombreServicio VARCHAR2(100);
        cNumPolUnico VARCHAR2(50);
        nCodigoAgente NUMBER(5);
        nIdPoliza  NUMBER(5);
        nCodCia  NUMBER(5);
        nCodEmpresa NUMBER(5);
        nIdTramite  NUMBER(5);
        nIdFlujo  NUMBER(5);
        nTempIdPoliza NUMBER(5);
        nIdSiniestro NUMBER(5);
        tipoSolicitud VARCHAR2(20);
        tipoTramite VARCHAR2(20);
        area VARCHAR2(20);
        xRespuesta  XMLTYPE;
        vRespuesta VARCHAR(20);
        CURSOR cGenCotiza IS
           WITH
           COTIZA_DATA AS ( SELECT GEN.*
                               FROM   XMLTABLE('/DATA'
                                         PASSING xConsultaServicioSicas
                                            COLUMNS 
                                               NombreSer       VARCHAR2(100)   PATH 'Nombre',
                                               Parametros         XMLTYPE      PATH 'PARAMETROS') GEN
                             ),
                 SERVICIO_DATA   AS ( SELECT  NombreSer,XT2.*
                                    FROM   COTIZA_DATA P
                                       ,   XMLTABLE('/PARAMETROS'
                                              PASSING P.Parametros
                                                 COLUMNS 
                                                    CodAgente NUMBER(5) PATH 'CodAgente',
                                                    CodCia NUMBER(5) PATH 'CodCia',
                                                    CodEmpresa NUMBER(5) PATH 'CodEmpresa',
                                                    IdFlujo NUMBER(5) PATH 'IdFlujo',
                                                    IdTramite NUMBER(5) PATH 'IdTramite',
                                                    NumPolUnico VARCHAR2(50) PATH 'NumPolUnico',
                                                    IdSiniestro NUMBER(5) PATH 'IdSiniestro',
                                                    vTipoSolicitud VARCHAR2(20) PATH 'PTIPO_SOL',
                                                    vTipoTramite VARCHAR2(20) PATH 'PTIPO_TRAMITE',
                                                    vArea VARCHAR2(10) PATH 'PAREA',
                                                    IdPoliza NUMBER(5) PATH 'IdPoliza') XT2
                                  )
           SELECT * FROM SERVICIO_DATA;
        BEGIN
           FOR X IN cGenCotiza LOOP
              IF X.NombreSer IS NOT NULL THEN
                 cNombreServicio         := X.NombreSer;
              END IF;
              IF X.CodAgente IS NOT NULL THEN
                 nCodigoAgente         := X.CodAgente;
              END IF;
              IF X.CodCia IS NOT NULL THEN
                 nCodCia         := X.CodCia;
              END IF;
              IF X.CodEmpresa IS NOT NULL THEN
                 nCodEmpresa         := X.CodEmpresa;
              END IF;
              IF X.IdPoliza IS NOT NULL THEN
                 nIdPoliza         := X.IdPoliza;
              END IF;
              IF X.IdFlujo IS NOT NULL THEN
                 nIdFlujo         := X.IdFlujo;
              END IF;
              IF X.IdTramite IS NOT NULL THEN
                 nIdTramite         := X.IdTramite;
              END IF;
              IF X.NumPolUnico IS NOT NULL THEN
                 cNumPolUnico         := X.NumPolUnico;
              END IF;
              IF X.IdSiniestro IS NOT NULL THEN
                 nIdSiniestro         := X.IdSiniestro;
              END IF;
              IF X.vTipoSolicitud IS NOT NULL THEN
                 tipoSolicitud         := X.vTipoSolicitud;
              END IF;
              IF X.vTipoTramite IS NOT NULL THEN
                 tipoTramite         := X.vTipoTramite;
              END IF;
              IF X.vArea IS NOT NULL THEN
                 area         := X.vArea;
              END IF;
              
           END LOOP;
           
           IF cNombreServicio ='GENERALES_PLATAFORMA_DIGITAL.CONSULTA_AGENTE' THEN
                SetSalidaXml := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_AGENTE(nCodCia, nCodEmpresa, nCodigoAgente);          
           END IF;
           IF cNombreServicio ='OC_SINIESTROS_SERVICIOS_WEB.OBTIENE_FOLIO' THEN
                --SetSalidaXml := '<DATA><TRAMITE><Folio>SV-260821-0001</Folio></TRAMITE><CONTROL><RespuestaServicio>True</RespuestaServicio><TextoRespuestaServicio>Ejemplo de respuesta de servicio</TextoRespuestaServicio></CONTROL></DATA>';  
                xRespuesta := OC_SINIESTROS_SERVICIOS_WEB.OBTIENE_FOLIO(nCodCia,nCodEmpresa,nIdFlujo,nIdTramite);
                SetSalidaXml := xRespuesta.getClobVal();
           END IF; 
           IF cNombreServicio ='OC_SINIESTROS_SERVICIOS_WEB.LISTA_TRAMITES' THEN                
                --SetSalidaXml := '<?xml version="1.0" encoding="UTF-8"?><DATA><TIPOS_TRAMITE_SINI><IdTramite>1</IdTramite><CodigoRamo>AP</CodigoRamo><Ramo>Accidentes Personales</Ramo></TIPOS_TRAMITE_SINI><TIPOS_TRAMITE_SINI><IdTramite>2</IdTramite><CodigoRamo>VD</CodigoRamo><Ramo>Vida Grupo</Ramo></TIPOS_TRAMITE_SINI><TIPOS_TRAMITE_SINI><IdTramite>3</IdTramite><CodigoRamo>GF</CodigoRamo><Ramo>Gastos Funerarios</Ramo></TIPOS_TRAMITE_SINI><TIPOS_TRAMITE_SINI><IdTramite>4</IdTramite><CodigoRamo>GM</CodigoRamo><Ramo>Gastos Medicos Mayores</Ramo></TIPOS_TRAMITE_SINI></DATA>';                                  
                xRespuesta := OC_SINIESTROS_SERVICIOS_WEB.LISTA_TRAMITES(nCodCia,nCodEmpresa,nIdFlujo);
                SetSalidaXml := xRespuesta.getClobVal();
           END IF;
           IF cNombreServicio ='OC_SINIESTROS_SERVICIOS_WEB.POLIZA_SINIESTRO' THEN
                SELECT idpoliza INTO nTempIdPoliza from(
                    SELECT idpoliza FROM polizas WHERE numpolunico=cNumPolUnico AND motivanul IS NULL ORDER BY idpoliza DESC)
                WHERE ROWNUM = 1;
                nIdPoliza := nTempIdPoliza;
                xRespuesta := SICAS_OC.OC_SINIESTROS_SERVICIOS_WEB.POLIZA_SINIESTRO(nCodCia,nCodEmpresa,nIdPoliza,nCodigoAgente);                  
                SetSalidaXml := xRespuesta.getClobVal();
                 --SetSalidaXml:= TO_CHAR(nIdPoliza);
           END IF;
           IF cNombreServicio ='OC_SINIESTROS_SERVICIOS_WEB.EXISTE_POLIZA' THEN
                SetSalidaXml := SICAS_OC.OC_SINIESTROS_SERVICIOS_WEB.EXISTE_POLIZA(nCodCia,nCodEmpresa,cNumPolUnico);
           END IF; 
           IF cNombreServicio ='OC_SINIESTROS_SERVICIOS_WEB.EXISTE_AGENTE' THEN                                
                SetSalidaXml := SICAS_OC.OC_SINIESTROS_SERVICIOS_WEB.EXISTE_AGENTE(nCodCia,nCodigoAgente,cNumPolUnico);                 
                --SetSalidaXml := xRespuesta.getClobVal();
           END IF;
           IF cNombreServicio ='OC_SINIESTROS_SERVICIOS_WEB.OBTIENE_ROL' THEN             
                SELECT idpoliza INTO nTempIdPoliza FROM polizas WHERE numpolunico=cNumPolUnico AND ROWNUM <= 1;
                nIdPoliza := nTempIdPoliza;
                xRespuesta := SICAS_OC.OC_SINIESTROS_SERVICIOS_WEB.OBTIENE_ROL(nCodCia, nCodEmpresa, nIdPoliza);                  
                SetSalidaXml := xRespuesta.getClobVal();
           END IF;
           IF cNombreServicio ='OC_SINIESTROS_SERVICIOS_WEB.OBTIENE_DICTAMEN' THEN             
                xRespuesta := SICAS_OC.OC_SINIESTROS_SERVICIOS_WEB.OBTIENE_DICTAMEN(nCodCia, nIdSiniestro);                  
                SetSalidaXml := xRespuesta.getClobVal();
           END IF;
           IF cNombreServicio ='API_PLATAFORMA_AGENTES.LISTA_FESTIVOS' THEN             
                xRespuesta := API_PLATAFORMA_AGENTES.LISTA_FESTIVOS(nCodCia, nCodEmpresa);                  
                SetSalidaXml := xRespuesta.getClobVal();
           END IF;
           IF cNombreServicio ='SICAS_OC.OC_SINIESTROS_SERVICIOS_WEB.OBTIENE_DIAS_GARANTIA' THEN
                xRespuesta := SICAS_OC.OC_SINIESTROS_SERVICIOS_WEB.OBTIENE_DIAS_GARANTIA(nCodCia, nCodEmpresa, nIdPoliza, tipoSolicitud, tipoTramite, area);
                SetSalidaXml := xRespuesta.getClobVal();
                --SetSalidaXml := TO_CLOB(nCodCia || nCodEmpresa || nIdPoliza || tipoSolicitud || tipoTramite || area || xRespuesta.getClobVal());
           END IF;
           
    END API_CONSULTA_SICAS_FLUJOS;    
    
    PROCEDURE LISTADO_EJEC_COMERCIAL(nCodCia IN NUMBER, nLimInferior IN NUMBER, nLimSuperior IN NUMBER, nTotRegs OUT NUMBER, xRespuesta OUT XMLTYPE)IS
	BEGIN
		xRespuesta :=  SICAS_OC.oc_ejecut_comer_servicios_web.LISTADO_EJEC_COMERCIAL(nCodCia, nLimInferior, nLimSuperior, nTotRegs);
	END LISTADO_EJEC_COMERCIAL;
        
    PROCEDURE LISTADO_AGENTES_ASOCOCIADOS(nCodCia IN NUMBER, nCodEjecutivo IN NUMBER, nLimInferior IN NUMBER, nLimSuperior IN NUMBER, nTotRegs OUT NUMBER, xRespuesta OUT XMLTYPE) IS
	BEGIN
	xRespuesta := SICAS_OC.OC_EJECUT_COMER_SERVICIOS_WEB.LISTADO_AGENTES_ASOCOCIADOS(nCodCia, nCodEjecutivo, nLimInferior, nLimSuperior, nTotRegs);
    END LISTADO_AGENTES_ASOCOCIADOS;
    
    --PROCEDURE CATALOGO_LISTA_TRAMITES(nCodCia IN NUMBER,nCodEmpresa IN NUMBER, xRespuesta OUT XMLTYPE) IS
    --BEGIN         
         --xRespuesta := OC_SINIESTROS_SERVICIOS_WEB.LISTA_TRAMITES_SINI(nCodCia,nCodEmpresa);
    --END CATALOGO_LISTA_TRAMITES;
    
    FUNCTION LISTA_FESTIVOS (nCodCia  IN NUMBER,  nCodEmpresa IN NUMBER)
    RETURN XMLTYPE IS
    xFestivos    XMLTYPE; 
    xPrevFestivos XMLTYPE;
    
    BEGIN
        BEGIN
            SELECT  XMLELEMENT("DATA",
            --XMLELEMENT("DIAS_FESTIVOS",
                               XMLAGG(XMLELEMENT("DIA_FESTIVOS",  
                                                    XMLELEMENT("Fecha", F.FECHA),
                                                    XMLELEMENT("Descripcion", F.DESCRIPCION)                                                                    
                                                )
                                     )
                                     --)
                              )
    INTO    xPrevFestivos
    FROM    DIAS_FESTIVOS F;
    
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE_APPLICATION_ERROR(-20200,'No se encontro informacion existente en Base de Datos.');
                WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR(-20225,'Error detectado en LISTA_FESTIVOS'||SQLERRM); 
       END;
    
       SELECT 	XMLROOT (xPrevFestivos, VERSION '1.0" encoding="UTF-8')
       INTO		xFestivos
       FROM 	DUAL;
    
       RETURN xFestivos;
    
    END LISTA_FESTIVOS;
    
        
END API_PLATAFORMA_AGENTES;
/
GRANT EXECUTE, DEBUG ON THONAPI.API_PLATAFORMA_AGENTES TO "PUBLIC";
/
CREATE OR REPLACE PUBLIC SYNONYM OC_DIAS_ATENCION_SINI FOR THONAPI.API_PLATAFORMA_AGENTES;
/

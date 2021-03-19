create or replace PACKAGE OC_FACTURAS_SERVICIOS_WEB AS

FUNCTION CONSULTA_FACTURA(  nNoRecibo	NUMBER,	nIdPoliza	NUMBER, 
                            nCodCia	    NUMBER,	nCodEmpresa	NUMBER
							)
RETURN XMLTYPE;

FUNCTION LISTADO_FACTURA (	nNoRecibo       IN NUMBER,      cReciboEstatus  IN VARCHAR2,    nCodCliente      IN NUMBER, nIdPoliza       IN NUMBER,	 
                           	cNoPago         IN VARCHAR2,    cPlanPago       IN VARCHAR2,    nCodCia          IN NUMBER,	dFecStsIni      IN DATE,    dFecStsFin 	IN DATE,
                           	dFechaInicio    IN DATE,        dFechaFin       IN DATE,        nLimInferior     IN NUMBER, nLimSuperior    IN NUMBER, --> 22/12/2020   (JALV)
                            nTotRegs        OUT NUMBER,     nCodAgente      IN NUMBER,      nCodAgenteSesion IN NUMBER, nNivel          IN NUMBER, --> 22/02/2021   (HGF)
                            nIdetPol        IN NUMBER,      cNumPolUnico    IN VARCHAR2 --> 22/02/2021   (JALV)
							)
RETURN XMLTYPE;

FUNCTION ESTADO_FACTURA (nCodCia NUMBER)
RETURN XMLTYPE;

FUNCTION PLAN_PAGO_FACTURA (nCodCia NUMBER,	nCodEmpresa	NUMBER)
RETURN XMLTYPE;

END OC_FACTURAS_SERVICIOS_WEB;
/
create or replace PACKAGE BODY OC_FACTURAS_SERVICIOS_WEB AS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 07/12/2020                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : OC_FACTURAS_SERVICIOS_WEB                                                                                        |
    | Objetivo   : Package obtiene informacion de los Recibos o Facturas que cumplen con los criterios dados en los Servicios WEB   |
    |              de la Plataforma Digital, los resultados son generados en formato XML.                                           |
    | Modificado : Si                                                                                                               |
    | Ult. Modif.: 22/12/2020                                                                                                       |
    | Modifico   : J. Alberto Lopez Valle   ( JALV )                                                                                |
    | Obj. Modif.: Se agrega funcionalidad de paginacion en el listado de recibos.                                                  |
    |   10/12/2020  Se agregan Funciones para obtener Catalogo de Estados y Plan de Pago de los Recibos o Facturas.                 |
    |_______________________________________________________________________________________________________________________________|
*/ 

FUNCTION CONSULTA_FACTURA(  nNoRecibo	NUMBER,	nIdPoliza	NUMBER,
                            nCodCia	    NUMBER,	nCodEmpresa	NUMBER
							)
	RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 07/12/2020                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : CONSULTA_FACTURA                                                                                                 |
    | Objetivo   : Funcion que consulta y obtiene informacion detallada de los Recibos o Facturas que cumplen con los criterios     |
    |              dados desdela Plataforma Digital y genera la salida en formato XML.                                              |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    |                                                                                                                               |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nNoRecibo			Numero de la Factura	        (Entrada)                                                       |
    |			nIdPoliza			ID de la Poliza			        (Entrada)                                                       |
    |			nCodCia				Codigo de la Compañia	        (Entrada)                                                       |
    |			nCodEmpresa			Codigo de la Empresa	        (Entrada)                                                       |    
    |_______________________________________________________________________________________________________________________________|
*/ 
xFactura  XMLTYPE;
xPrevFact XMLTYPE; 
BEGIN
   BEGIN
      SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("FACTURAS",  
                                     XMLELEMENT("NoRecibo", F.IdFactura),
                                     XMLELEMENT("NumPoliza", F.IdPoliza),
                                     XMLELEMENT("Producto", P.CodPaqComercial),
                                     XMLELEMENT("SubGrupo", F.IDetPol), 
                                     XMLELEMENT("ReciboEstatus",OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS',F.stsfact)), 
                                     XMLELEMENT("NoContratante", F.CodCliente),
                                     XMLELEMENT("Cliente", OC_CLIENTES.NOMBRE_CLIENTE(F.CodCliente)),                         
                                     XMLELEMENT("InicioVigencia", F.fecvenc),
                                     XMLELEMENT("FinVigencia", F.fecfinvig),
                                     XMLELEMENT("MontoFactura", F.monto_fact_local), 
                                     XMLELEMENT("MontoFactMoneda", F.monto_fact_moneda),
                                     XMLELEMENT("FechaEstatus", F.fecsts), 
                                     XMLELEMENT("TasaCambio", F.tasa_cambio), 
                                     XMLELEMENT("NoPago", F.recibopago), 
                                     XMLELEMENT("FechaAnualacion", F.fecanul),				 
                                     XMLELEMENT("MotivoAnulacion", OC_VALORES_DE_LISTAS.BUSCA_LVALOR('MOTIVANU', F.motivanul)),
                                     XMLELEMENT("IdEndoso", F.idendoso), 
                                     XMLELEMENT("ComisionFactura", F.mtocomisi_local), 
                                     XMLELEMENT("ComisionFactMoneda",F.mtocomisi_moneda), 
                                     XMLELEMENT("NumCuota", F.numcuota),
                                     XMLELEMENT("CodGenerador", F.codgenerador), 
                                     XMLELEMENT("FormaPago", F.formpago), 
                                     XMLELEMENT("IndPagoProd", F.indpagprod), 
                                     XMLELEMENT("EntPago", F.entpago),
                                     XMLELEMENT("CodCia", F.CodCia), 
                                     XMLELEMENT("SaldoLocal", F.saldo_local), 
                                     XMLELEMENT("Moneda", OC_MONEDA.DESCRIPCION_MONEDA(F.cod_moneda)),
                                     XMLELEMENT("SaldoMoneda", F.saldo_moneda),
                                     XMLELEMENT("NumTransaccion", F.idtransaccion), 
                                     XMLELEMENT("NumTransacAnual", F.idtransaccionanu), 
                                     XMLELEMENT("FecPago", F.fecpago), 
                                     XMLELEMENT("FecEnvioFactElectronica", F.fecenvfactelec), 
                                     XMLELEMENT("UsuarioEnvioAnulFactElec", F.codusuarioenvfact), 
                                     XMLELEMENT("Contabilizada", DECODE(F.indcontabilizada,'S','Si','No')), 
                                     XMLELEMENT("FecContabilizada", F.feccontabilizada), 
                                     XMLELEMENT("IdTransaccContable", F.idtransaccontab),
                                     XMLELEMENT("IdFactElectronica", DECODE(F.indfactelectronica,'S','Si','No')), 
                                     XMLELEMENT("GeneroAvisoCobro", DECODE(F.indgenavicob,'S','Si','No')), 
                                     XMLELEMENT("FecGenAvisoCobro", F.fecgenavicob), 
                                     XMLELEMENT("FolioFacturaElec", F.foliofactelec), 
                                     XMLELEMENT("FecEnvAnulaFactElec", F.fecenvfactelecanu), 
                                     XMLELEMENT("UsuarioEnvAnulFactElec", F.codusuarioenvfactanu), 
                                     XMLELEMENT("LogRespProcFactElec", F.logprocesofactelec), 
                                     XMLELEMENT("IdProceso", F.idproceso), 
                                     XMLELEMENT("IndDomiciliado", F.inddomiciliado),
                                     XMLELEMENT("TimbroRFCGenerico", DECODE(F.indfactcterfcgenerico,'S','Si','No')), 
                                     XMLELEMENT("CteRFCGenerico", F.codclirfcgenerico), 
                                     XMLELEMENT("PlanDePagos", OC_PLAN_DE_PAGOS.DESCRIPCION_PLAN(nCodCia, nCodEmpresa, F.codplanpago)),
                                     XMLELEMENT("IdAñoPoliza", F.Id_Año_Poliza),
                                     XMLAGG(XMLFOREST(  ( SELECT XMLAGG(XMLELEMENT("TIMBRE", 
                                                                                 XMLFOREST( D.IdTimbre "IdTimbre",
                                                                                            D.CodProceso       "CodProceso",
                                                                                            D.UUID             "UUID",
                                                                                            D.FechaUUID        "FechaUUID",  
                                                                                            D.Serie            "SERIE",   
                                                                                            D.CodRespuestaSAT  "CODRESPUESTASAT",   
                                                                                            D.StsTimbre        "STSTIMBRE")
                                                                                 ) 
                                                                     )
                                                           FROM FACT_ELECT_DETALLE_TIMBRE d
                                                          WHERE D.CodCia           = P.CodCia
                                                            AND D.CodEmpresa       = P.CodEmpresa
                                                            AND D.IdFactura        = F.IdFactura   
                                                            AND CodRespuestaSat IN ('201','2001')
                                                            AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_UUID_CANCELADO(D.CodCia, D.CodEmpresa, D.IdFactura, D.IDNCR, D.UUID) = 'N'
                                                       ) "CFDI"
                                                   )
                                          )                                                
                                       )
                                  )
                         )
      INTO xPrevFact
      FROM FACTURAS F, POLIZAS  P
     WHERE F.IdPoliza    = P.IdPoliza
       AND F.CodCia      = P.CodCia
       AND F.IdFactura   = NVL(nNoRecibo, F.IdFactura)
       AND F.CodCia      = nCodCia
     GROUP BY F.IdFactura, F.IdPoliza, P.CodPaqComercial, F.IDetPol, F.CodCliente, F.stsfact,F.indgenavicob, F.fecvenc, 
           F.fecfinvig, F.monto_fact_local, F.monto_fact_moneda, F.fecsts, F.tasa_cambio, F.recibopago, F.fecanul, 
           F.motivanul, F.idendoso, F.mtocomisi_local, F.mtocomisi_moneda, F.numcuota, F.codgenerador, F.formpago, 
           F.cod_moneda, F.indpagprod, F.entpago, F.CodCia, F.saldo_local, F.saldo_moneda, F.idtransaccion, 
           F.idtransaccionanu, F.fecpago, F.fecenvfactelec, F.codusuarioenvfact, F.indcontabilizada, F.feccontabilizada, 
           F.idtransaccontab, F.fecgenavicob, F.foliofactelec, F.fecenvfactelecanu, F.codusuarioenvfactanu, 
           F.logprocesofactelec, F.idproceso, F.indfactelectronica, F.inddomiciliado, F.codclirfcgenerico, 
           F.Id_Año_Poliza, F.indfactcterfcgenerico, F.codplanpago; 
        /*SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("FACTURAS",  
                                                 XMLELEMENT("NoRecibo", F.IdFactura),
                                                 XMLELEMENT("NumPoliza", F.IdPoliza),
                                                 XMLELEMENT("Producto", P.CodPaqComercial),
                                                 XMLELEMENT("SubGrupo", F.IDetPol), 
                                                 XMLELEMENT("ReciboEstatus",OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS',F.stsfact)), 
                                                 XMLELEMENT("NoContratante", F.CodCliente),
                                                 XMLELEMENT("Cliente", OC_CLIENTES.NOMBRE_CLIENTE(F.CodCliente)),                         
                                                 XMLELEMENT("InicioVigencia", F.fecvenc),
                                                 XMLELEMENT("FinVigencia", F.fecfinvig),
                                                 XMLELEMENT("MontoFactura", F.monto_fact_local), 
                                                 XMLELEMENT("MontoFactMoneda", F.monto_fact_moneda),
                                                 XMLELEMENT("FechaEstatus", F.fecsts), 
                                                 XMLELEMENT("TasaCambio", F.tasa_cambio), 
                                                 XMLELEMENT("NoPago", F.recibopago), 
                                                 XMLELEMENT("FechaAnualacion", F.fecanul),				 
                                                 XMLELEMENT("MotivoAnulacion", OC_VALORES_DE_LISTAS.BUSCA_LVALOR('MOTIVANU', F.motivanul)),
                                                 XMLELEMENT("IdEndoso", F.idendoso), 
                                                 XMLELEMENT("ComisionFactura", F.mtocomisi_local), 
                                                 XMLELEMENT("ComisionFactMoneda",F.mtocomisi_moneda), 
                                                 XMLELEMENT("NumCuota", F.numcuota),
                                                 XMLELEMENT("CodGenerador", F.codgenerador), 
                                                 XMLELEMENT("FormaPago", F.formpago), 
                                                 XMLELEMENT("IndPagoProd", F.indpagprod), 
                                                 XMLELEMENT("EntPago", F.entpago),
                                                 XMLELEMENT("CodCia", F.codcia), 
                                                 XMLELEMENT("SaldoLocal", F.saldo_local), 
                                                 XMLELEMENT("Moneda", OC_MONEDA.DESCRIPCION_MONEDA(F.cod_moneda)),
                                                 XMLELEMENT("SaldoMoneda", F.saldo_moneda),
                                                 XMLELEMENT("NumTransaccion", F.idtransaccion), 
                                                 XMLELEMENT("NumTransacAnual", F.idtransaccionanu), 
                                                 XMLELEMENT("FecPago", F.fecpago), 
                                                 XMLELEMENT("FecEnvioFactElectronica", F.fecenvfactelec), 
                                                 XMLELEMENT("UsuarioEnvioAnulFactElec", F.codusuarioenvfact), 
                                                 XMLELEMENT("Contabilizada", DECODE(F.indcontabilizada,'S','Si','No')), 
                                                 XMLELEMENT("FecContabilizada", F.feccontabilizada), 
                                                 XMLELEMENT("IdTransaccContable", F.idtransaccontab),
                                                 XMLELEMENT("IdFactElectronica", DECODE(F.indfactelectronica,'S','Si','No')), 
                                                 XMLELEMENT("GeneroAvisoCobro", DECODE(F.indgenavicob,'S','Si','No')), 
                                                 XMLELEMENT("FecGenAvisoCobro", F.fecgenavicob), 
                                                 XMLELEMENT("FolioFacturaElec", F.foliofactelec), 
                                                 XMLELEMENT("FecEnvAnulaFactElec", F.fecenvfactelecanu), 
                                                 XMLELEMENT("UsuarioEnvAnulFactElec", F.codusuarioenvfactanu), 
                                                 XMLELEMENT("LogRespProcFactElec", F.logprocesofactelec), 
                                                 XMLELEMENT("IdProceso", F.idproceso), 
                                                 XMLELEMENT("IndDomiciliado", F.inddomiciliado),
                                                 XMLELEMENT("TimbroRFCGenerico", DECODE(F.indfactcterfcgenerico,'S','Si','No')), 
                                                 XMLELEMENT("CteRFCGenerico", F.codclirfcgenerico), 
                                                 XMLELEMENT("PlanDePagos", OC_PLAN_DE_PAGOS.DESCRIPCION_PLAN(nCodCia, nCodEmpresa, F.codplanpago)),
                                                 XMLELEMENT("IdAñoPoliza", F.Id_Año_Poliza)
                                              )
                                  )
                         )
        INTO	xPrevFact
		FROM    FACTURAS F,
                POLIZAS  P
        WHERE   F.IdPoliza    = P.IdPoliza
        AND     F.codcia      = P.codcia
        AND     F.IdFactura = NVL(nNoRecibo, F.IdFactura)
        AND     F.codcia    = nCodCia
		ORDER BY 1 DESC;*/

      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'El Recibo '||nNoRecibo||' no existente en Base de Datos.'); 
   END;

   SELECT 	XMLROOT (xPrevFact, VERSION '1.0" encoding="UTF-8')
   INTO		xFactura
   FROM 	DUAL;

   RETURN xFactura;

END CONSULTA_FACTURA;


FUNCTION LISTADO_FACTURA (  nNoRecibo       IN NUMBER,      cReciboEstatus  IN VARCHAR2,    nCodCliente      IN NUMBER, nIdPoliza       IN NUMBER,	 
                           	cNoPago         IN VARCHAR2,    cPlanPago       IN VARCHAR2,    nCodCia          IN NUMBER,	dFecStsIni      IN DATE,    dFecStsFin 	IN DATE,
                           	dFechaInicio    IN DATE,        dFechaFin       IN DATE,        nLimInferior     IN NUMBER, nLimSuperior    IN NUMBER, --> 22/12/2020   (JALV)
                            nTotRegs        OUT NUMBER,     nCodAgente      IN NUMBER,      nCodAgenteSesion IN NUMBER, nNivel          IN NUMBER, --> 22/02/2021   (HGF)
                            nIdetPol        IN NUMBER,      cNumPolUnico    IN VARCHAR2 --> 22/02/2021   (JALV)
							)
	RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 07/12/2020                                                                                                       |
    | Email		 : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : LISTADO_FACTURA                                                                                                  |
    | Objetivo   : Funcion que obtiene un listado general de los Recibos o Facturas que cumplen con los criterios dados desde la    |
    |              Plataforma Digital y tranforma la salida en formato XML.                                                         |
    | Modificado : Si                                                                                                               |
    | Ult. modif.: 03/03/2021                                                                                                       |
    | Modifico	 : J. Alberto Lopez Valle   (JALV)                                                                                  |
    |                                                                                                                               |
    | Obj. Modif.: Se modifico el filtro de Fecha de estatus a rango de fechas. No se considera el Status Permitido (PRE).          |
    |   22/02/2021  Se agrego:                                                                                                      |
    |               1) Filtrado por Agente y Nivel. (HGF)                                                                           |
    |               2) Filtrado por los campos CodPaqComercial y numpolunico asi como su visualizacion en el XML. (JALV)            |
    |   22/12/2020  Se agrega funcionalidad de paginacion.                                                                          |
    |   10/12/2020  Se modifico la condicion del Recibo de Pago ( cNoPago) porque no respetaba el NVL al recibir perametro en Nulo  |
    |               como el resto de los demas parametros. Se uso una alternativa distinta.                                         |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |			nNoRecibo			Numero de la Factura	        (Entrada)                                                       |
    |			cReciboEstatus		Estatus del Recibo		        (Entrada)                                                       |    
    |			nCodCliente			Codigo del Cliente		        (Entrada)                                                       |
    |			nIdPoliza			ID de la Poliza			        (Entrada)                                                       |
    |			nNoPago				Numero de Pago			        (Entrada)                                                       |
    |			cPlanPago			Plan de Pago			        (Entrada)                                                       |
    |			nCodCia 			Codigo de la Compañia	        (Entrada)                                                       |
    |			dFecStsIni  		Fecha Inicial del Estatus       (Entrada)                                                       |
    |			dFecStsFin  		Fecha Final del Estatus         (Entrada)                                                       |
    |			dFechaInicio		Fecha de Inicio de Vig.	        (Entrada)                                                       |
    |			dFechaFin			Fecha de Fin de Vig.	        (Entrada)                                                       |
    |           nIdetPol            ID de la Poliza                 (Entrada)                                                       |
    |           cNumPolUnico        Numero Unico de la Poliza       (Entrada)                                                       |
    |           nLimInferior        Limite inferior de pagina       (Entrada)                                                       |
    |           nLimSuperior        Limite superior de pagina       (Entrada)                                                       |
    |           nTotRegs            Total de registros obtenidos    (Salida)                                                        |
    |           nCodAgente          Codigo del Agente               (Entrada)                                                       |
    |           nCodAgenteSesion    Codigo de Sesion del agente     (Entrada)                                                       |
    |           nNivel              Nivel del Agente                (Entrada)                                                       |
    |_______________________________________________________________________________________________________________________________|
*/

xListadoFactura   XMLTYPE;
xPrevFact         XMLTYPE;

BEGIN
   BEGIN
	    SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("FACTURAS",  
                                                 XMLELEMENT("NoRecibo", R.IdFactura),
                                                 XMLELEMENT("ReciboEstatus", R.ReciboEstatus),          --> 22/12/2020   (JALV +)
                                                 XMLELEMENT("NumPoliza", R.IdPoliza),
                                                 XMLELEMENT("NumPolUnico", R.numpolunico),              --> 22/02/2021   (JALV +)
                                                 XMLELEMENT("Producto", R.CodPaqComercial),             --> 22/02/2021   (JALV +)
                                                 XMLELEMENT("SubGrupo", R.IDetPol),
                                                 XMLELEMENT("IdAñoPoliza", R.Id_Año_Poliza),						  						 
                                                 XMLELEMENT("NoContratante", R.CodCliente),
                                                 XMLELEMENT("Cliente", R.Cliente),                      --> 22/12/2020   (JALV +)
                                                 XMLELEMENT("InicioVigencia", R.fecvenc),
                                                 XMLELEMENT("FinVigencia", R.fecfinvig),
                                                 XMLELEMENT("FechaAnualacion", R.fecanul),						  
                                                 XMLELEMENT("FecPago", R.fecpago),
                                                 XMLELEMENT("GeneroAvisoCobro", R.GeneroAvisoCobro),    --> 22/12/2020   (JALV)
                                                 XMLELEMENT("FolioFacturaElec", R.foliofactelec),
                                                 XMLELEMENT("FecEnvioFactElectronica", R.fecenvfactelec),
                                                 XMLELEMENT("Cuota", R.numcuota),                       --> 22/02/2021   (JALV +)
                                                 XMLELEMENT("Prima", R.monto_fact_local),               --> 22/02/2021   (JALV +)
                                                 XMLELEMENT("PrimaMoneda", R.monto_fact_moneda),        --> 22/02/2021   (JALV +)
                                                 XMLELEMENT("Comision", R.comispagada_local),           --> 22/02/2021   (JALV +)
                                                 XMLELEMENT("CodCia", R.codcia)
                                             )
                                  )
                        )
        INTO	xPrevFact
        FROM    (   SELECT  F.IdFactura,            --> Inicia 22/12/2020   (JALV)
                            OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', F.stsfact) ReciboEstatus, 
                            F.IdPoliza,
                            P.CodPaqComercial,                                  --> 22/02/2021   (JALV +)
                            F.IDetPol,
                            P.numpolunico,                                      --> 22/02/2021   (JALV +)
                            F.Id_Año_Poliza,						  						 
                            F.CodCliente,
                            OC_CLIENTES.NOMBRE_CLIENTE(F.CodCliente) Cliente,                        
                            F.fecvenc,
                            F.fecfinvig,
                            F.fecanul,						  
                            F.fecpago,
                            DECODE(F.indgenavicob,'S','Si','No') GeneroAvisoCobro,
                            --F.fecgenavicob,
                            F.foliofactelec,
                            F.fecenvfactelec,
                            F.numcuota,                                         --> 22/02/2021   (JALV +)
                            F.monto_fact_local,                                 --> 22/02/2021   (JALV +)
                            F.monto_fact_moneda,                                --> 22/02/2021   (JALV +)
                            F.comispagada_local,                                --> 22/02/2021   (JALV +)
                            F.codcia, 
                            ROW_NUMBER() OVER (ORDER BY F.IdFactura) registro
                    FROM    FACTURAS F,
                            POLIZAS  P,
                            AGENTE_POLIZA AP,
                            ( SELECT DISTINCT C.CodCia, C.Cod_Agente, C.IdPoliza, D.Cod_Agente_Distr,   --> Inicia 22/02/2021   (HGF +) 
                                     OC_AGENTES.NIVEL_AGENTE(C.CodCia, C.Cod_Agente ) NIVEL
                                FROM COMISIONES                     C,
                                     AGENTES_DISTRIBUCION_POLIZA    D,
                                     AGENTE_POLIZA                  P
                               WHERE C.CodCia         = nCodCia
                                 AND C.Cod_Agente     = D.Cod_Agente_Distr
                                 AND C.IdPoliza       = D.IdPoliza
                                 AND D.Cod_Agente     = P.Cod_Agente
                                 AND C.IdPoliza       = P.IdPoliza
                                 AND P.Ind_Principal  = 'S') D   --> Fin 22/02/2021   (HGF +) 
                    WHERE   F.IdPoliza    = P.IdPoliza
                    AND     F.codcia      = P.codcia
                    AND     P.IdPoliza       = AP.IdPoliza
                    AND     P.codcia         = AP.codcia
                    AND     AP.IdPoliza      = F.IdPoliza
                    AND     AP.codcia        = F.codcia
                    AND     AP.Ind_Principal = 'S'        --> Inicia 22/02/2021   (HGF +) 
                    AND     AP.cod_agente IN (SELECT   A.cod_agente
                                                FROM   AGENTES A
                                                CONNECT BY PRIOR A.cod_agente = A.cod_agente_jefe
                                                AND     A.est_agente    = 'ACT'
                                                AND     A.codcia        = nCodCia
                                                START WITH A.cod_agente = nCodAgente
                                                )    
                    AND     AP.IdPoliza   = D.IdPoliza
                    AND     AP.CodCia     = D.CodCia
                    AND     D.Cod_Agente  = nCodAgenteSesion
                    AND     D.Nivel       = nNivel          --> Fin 22/02/2021   (HGF +) 
                    AND     F.IdPoliza    = NVL(nIdPoliza, F.IdPoliza)
                    AND     F.CodCliente  = NVL(nCodCliente, F.CodCliente)
                    AND     F.IdFactura   = NVL(nNoRecibo, F.IdFactura)
                    AND    ( NVL(recibopago,'NULO')= NVL2(cNoPago, recibopago, 'NULO') OR NVL2(recibopago,recibopago,'NULO')= NVL2(cNoPago, 'NULO', recibopago))  -- ( JALV ) 10/12/2020 --> Antes: AND recibopago = NVL(:nNoPago, recibopago)
                    --AND   F.foliofactelec	= NVL(nFolioFacturaE, F.foliofactelec)  -->	folio_factura: POR DEFINIR (Facturacion electronica?) 
                    AND     F.codplanpago = NVL(cPlanPago, F.codplanpago)
                    AND     F.stsfact     <> 'PRE'                              --> 03/03/2021 (JALV +)
                    AND     F.stsfact     = NVL(cReciboEstatus, F.stsfact)
                    AND     F.fecsts      BETWEEN NVL(dFecStsIni, F.fecsts) AND NVL(dFecStsFin, F.fecsts)-- = NVL(dFechaEstatus, F.fecsts)  --> 03/03/2021 (JALV +)
                    AND     F.fecvenc     BETWEEN NVL(dFechaInicio, F.fecvenc) AND NVL(dFechaFin, F.fecfinvig)
                    AND     F.IDetPol     = NVL(nIDetPol, F.IDetPol)            --> 22/02/2021   (JALV +)
                    AND     P.numpolunico = NVL(cNumPolUnico, P.numpolunico)    --> 22/02/2021   (JALV +)
                    AND     F.codcia	  = nCodCia
                ) R
        WHERE   R.registro BETWEEN nLimInferior AND nLimSuperior;

        SELECT  NVL(COUNT(*),0)
        INTO    nTotRegs
        FROM    FACTURAS F,
                POLIZAS  P,
                AGENTE_POLIZA AP,
                (SELECT DISTINCT C.CodCia, C.Cod_Agente, C.IdPoliza, D.Cod_Agente_Distr,    --> Inicia 22/02/2021   (HGF +) 
                     OC_AGENTES.NIVEL_AGENTE(C.CodCia, c.Cod_Agente ) NIVEL
                FROM COMISIONES C, AGENTES_DISTRIBUCION_POLIZA D,
                     AGENTE_POLIZA P
               WHERE C.CodCia         = nCodCia
                 AND C.Cod_Agente     = D.Cod_Agente_Distr
                 AND C.IdPoliza       = D.IdPoliza
                 AND D.Cod_Agente     = P.Cod_Agente
                 AND C.IdPoliza       = P.IdPoliza
                 AND P.Ind_Principal  = 'S') D                                              --> Fin 22/02/2021   (HGF +) 
        WHERE   F.IdPoliza    = P.IdPoliza
        AND     F.codcia      = P.codcia
        AND     P.IdPoliza    = AP.IdPoliza
        AND     P.codcia      = AP.codcia
        AND     AP.IdPoliza   = F.IdPoliza
        AND     AP.codcia     = F.codcia 
        AND     AP.Ind_Principal = 'S'        --> Inicia 22/02/2021   (HGF +) 
        AND     AP.cod_agente IN (SELECT   A.cod_agente
                                    FROM   AGENTES A
                                    CONNECT BY PRIOR A.cod_agente = A.cod_agente_jefe
                                    AND     A.est_agente    = 'ACT'
                                    AND     A.codcia        = nCodCia
                                    START WITH A.cod_agente = nCodAgente
                                    )      
        AND     AP.IdPoliza   = D.IdPoliza
        AND     AP.CodCia     = D.CodCia
        AND     D.Cod_Agente  = nCodAgenteSesion
        AND     D.Nivel       = nNivel              --> fin 22/02/2021   (HGF +) 
        AND     F.IdPoliza    = NVL(nIdPoliza, F.IdPoliza)
        AND     F.CodCliente  = NVL(nCodCliente, F.CodCliente)
        AND     F.IdFactura   = NVL(nNoRecibo, F.IdFactura)
        AND    ( NVL(recibopago,'NULO')= NVL2(cNoPago, recibopago, 'NULO') OR NVL2(recibopago,recibopago,'NULO')= NVL2(cNoPago, 'NULO', recibopago))  -- ( JALV ) 10/12/2020 --> Antes: AND recibopago = NVL(:nNoPago, recibopago)
        --AND   F.foliofactelec	= NVL(nFolioFacturaE, F.foliofactelec)  -->	folio_factura: POR DEFINIR (Facturacion electronica?) 
        AND     F.codplanpago = NVL(cPlanPago, F.codplanpago)
        AND     F.stsfact     <> 'PRE'                              --> 03/03/2021 (JALV +)
        AND     F.stsfact     = NVL(cReciboEstatus, F.stsfact)
        AND     F.fecsts      BETWEEN NVL(dFecStsIni, F.fecsts) AND NVL(dFecStsFin, F.fecsts)--= NVL(dFechaEstatus, F.fecsts)   --> 03/03/2021 (JALV +)
        AND     F.fecvenc     BETWEEN NVL(dFechaInicio, F.fecvenc) AND NVL(dFechaFin, F.fecfinvig)
        AND     F.IDetPol     = NVL(nIDetPol, F.IDetPol)
        AND     P.numpolunico = NVL(cNumPolUnico, P.numpolunico)
        AND     F.codcia	  = nCodCia;

   END;

   SELECT XMLROOT (xPrevFact, VERSION '1.0" encoding="UTF-8')
     INTO xListadoFactura
     FROM DUAL;
   RETURN xListadoFactura;

END LISTADO_FACTURA;

-- Inicio   ( JALV ) 10/12/2020
FUNCTION ESTADO_FACTURA (nCodCia NUMBER)
	RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 10/12/2020                                                                                                       |
    | Email		 : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : ESTADO_FACTURA                                                                                                   | 
    | Objetivo   : Funcion que obtiene los Estados (Catalogos) de Recibos o Facturas que cumplen con los criterios dados desde la   |
    |              Plataforma Digital y tranforma la salida en formato XML.                                                         |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico	 : N/A                                                                                                              |
    |                                                                                                                               |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |			nCodCia 			Codigo de la Compañia	(Entrada)                                                               |
    |_______________________________________________________________________________________________________________________________|
*/


xEstadoFactura  XMLTYPE;
xPrevStsFact    XMLTYPE; 

BEGIN
   BEGIN  
      SELECT XMLELEMENT("DATA",
                         XMLAGG(XMLELEMENT("ESTADOSFACT",  
                                              XMLELEMENT("CodEstado", E.codvalor),
                                              XMLELEMENT("Descripcion", E.descvallst)
                                           )
                                 )
                        )
        INTO xPrevStsFact
        FROM VALORES_DE_LISTAS E
       WHERE codlista = 'ESTADOS'
         AND codvalor IN (SELECT  DISTINCT F.stsfact
                       FROM    FACTURAS F
                       WHERE   F.codcia = nCodCia);

        EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'No se encontraron Estados de Factura en Base de Datos.'); 

   END;

   SELECT XMLROOT (xPrevStsFact, VERSION '1.0" encoding="UTF-8')
     INTO xEstadoFactura
     FROM DUAL;

   RETURN xEstadoFactura;

END ESTADO_FACTURA;


FUNCTION PLAN_PAGO_FACTURA (nCodCia NUMBER,	nCodEmpresa	NUMBER)
	RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 10/12/2020                                                                                                       |
    | Email		 : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : PLAN_PAGO_FACTURA                                                                                                |    
    | Objetivo   : Funcion que obtiene los Planes de Pago (Catalogos) de Recibos o Facturas que cumplen con los criterios dados     |
    |              desde la Plataforma Digital y tranforma la salida en formato XML.                                                |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico	 : N/A                                                                                                              |
    |                                                                                                                               |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |			nCodCia 			Codigo de la Compañia	        (Entrada)                                                       |
    |			nCodEmpresa			Codigo de la Empresa	        (Entrada)                                                       | 
    |_______________________________________________________________________________________________________________________________|
*/


xPlanPagoFactura    XMLTYPE;
xPrevPlanPagoFact   XMLTYPE; 

BEGIN
   BEGIN  
        SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("PLANDEPAGOFACT",  
                                                 XMLELEMENT("CodPlanDePago", PP.codplanpago),
                                                 XMLELEMENT("Descripcion", PP.descplan)
                                              )
                                   )
                          )
		INTO	xPrevPlanPagoFact
        FROM    PLAN_DE_PAGOS PP
        WHERE   PP.codplanpago IN ( SELECT  DISTINCT F.codplanpago
                                    FROM    FACTURAS F
                                    WHERE   F.codcia = nCodCia )
        AND     PP.codcia       = nCodCia
        AND     PP.codempresa   = nCodEmpresa;

        EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'No se encontraron Planes de Pago de Factura en Base de Datos.'); 

   END;

   SELECT XMLROOT (xPrevPlanPagoFact, VERSION '1.0" encoding="UTF-8')
     INTO xPlanPagoFactura
     FROM DUAL;

   RETURN xPlanPagoFactura;

END PLAN_PAGO_FACTURA;
-- Fin  ( JALV ) 10/12/2020

END OC_FACTURAS_SERVICIOS_WEB;

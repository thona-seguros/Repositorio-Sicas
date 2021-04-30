create or replace PACKAGE OC_POLIZAS_SERVICIOS_WEB AS
   FUNCTION CONSULTA_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN XMLTYPE;

    FUNCTION LISTADO_POLIZA(nCodCia         NUMBER,     nCodEmpresa     NUMBER,     nIdPoliza       NUMBER,     nCodAgente      NUMBER,
                            dFecIni         DATE,       dFecFin         DATE,       nIdCotizacion   NUMBER,     cStsPoliza      VARCHAR2,   
                            cApePaternoCli  VARCHAR2,   cApeMaternoCli  VARCHAR2,   cNombreCli      VARCHAR2,   
                            nLimInferior    NUMBER,     nLimSuperior    NUMBER,     nTotRegs        OUT NUMBER  --> 23/12/2020   (JALV)
                            ) 
    RETURN XMLTYPE;

   FUNCTION GENERA_POLIZA( nCodCia        NUMBER
                         , nCodEmpresa    NUMBER
                         , nIdCotizacion  NUMBER
                         , xDatosCli      XMLTYPE ) RETURN NUMBER;

   FUNCTION PRE_EMITE_POLIZA( nCodCia           POLIZAS.CODCIA%TYPE
                            , nCodEmpresa       POLIZAS.CODEMPRESA%TYPE
                            , nIdPoliza         POLIZAS.IDPOLIZA%TYPE
                            , cIndRequierePago  VARCHAR2) RETURN CLOB;

    FUNCTION ESTADO_POLIZA(nCodCia  NUMBER, nCodEmpresa NUMBER, nCodAgente  NUMBER,  nCodAgenteSesion IN NUMBER, nNivel IN NUMBER) 
    RETURN XMLTYPE;
    
    FUNCTION RENOVAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPolizaRen NUMBER, cEmitePoliza VARCHAR2, cPreEmitePoliza VARCHAR2, nIdCotizacion NUMBER, cFacturas OUT CLOB) RETURN NUMBER;

END OC_POLIZAS_SERVICIOS_WEB;
/
create or replace PACKAGE BODY OC_POLIZAS_SERVICIOS_WEB IS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : ??                                                                                                               |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: ??                                                                                                               |    
    | Nombre     : OC_POLIZAS_SERVICIOS_WEB                                                                                         |
    | Objetivo   : Package obtiene informacion de las Polizas que cumplen con los criterios dados en los Servicios WEB de la        |
    |              Plataforma Digital, los resultados son generados en formato XML.                                                 |
    | Modificado : Si                                                                                                               |
    | Ult. Modif.: 23/12/2020                                                                                                       |
    | Modifico   : J. Alberto Lopez Valle   ( JALV )                                                                                |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Obj. Modif.: Se Agregan condiciones o filtros de Nombre y Apellisod Paterno y Materno al Listado de Polizas.                  |
    |       23/12/2020  Se agrega funcionalidad de paginacion en el listado de Polizas.                                             |
    |_______________________________________________________________________________________________________________________________|
*/
FUNCTION CONSULTA_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN XMLTYPE IS
xPoliza  XMLTYPE;
xPrevPol XMLTYPE; 
BEGIN
   BEGIN
      SELECT XMLELEMENT("DATA",
               XMLAGG(XMLELEMENT("POLIZAS",  
                        XMLELEMENT("Consecutivo",P.IdPoliza),
                        XMLELEMENT("Producto",CodPaqComercial),
                        XMLELEMENT("NumPolUnico",P.NumPolUnico),
                        XMLELEMENT("Estatus",OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', P.StsPoliza)),
                        XMLELEMENT("FechaEstatus",P.FecSts),
                        XMLELEMENT("CodigoContratante",P.CodCliente),
                        XMLELEMENT("NombreContratante",OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente)),
                        XMLELEMENT("CodAgente",A.Cod_Agente),
                        XMLELEMENT("NombreAgente", OC_AGENTES.NOMBRE_AGENTE(P.CodCia, A.Cod_Agente)),
                        XMLELEMENT("InicioVigencia",P.FecIniVig),
                        XMLELEMENT("FinVigencia",P.FecFinVig),
                        XMLELEMENT("Periodicidad",OC_PLAN_DE_PAGOS.DESCRIPCION_PLAN(P.CodCia, P.CodEmpresa, P.CodPlanPago)),
                        XMLELEMENT("TipoAdministracion",OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ADMINPOL', P.TipoAdministracion)),
                        XMLELEMENT("TipoNegocio",OC_VALORES_DE_LISTAS.BUSCA_LVALOR('TIPNEGO', P.CodTipoNegocio)),
                        XMLELEMENT("Categoria",GT_CATEGORIAS.CONSULTA_DESCRIP(P.CodCia, P.CodEmpresa, P.CodTipoNegocio,P.CodCatego)),
                        XMLELEMENT("CanalVenta",OC_VALORES_DE_LISTAS.BUSCA_LVALOR('FORMVENT',P.FormaVenta)),
                        XMLELEMENT("Descripcion",P.DescPoliza),
                        XMLELEMENT("TotalAsegurados",OC_POLIZAS.TOTAL_ASEGURADOS(P.CodCia, P.CodEmpresa, P.IdPoliza)),
                        XMLELEMENT("SumaAsegurada",P.SumaAseg_Local),
                        XMLELEMENT("PrimaNeta",P.PrimaNeta_Local),
                           (SELECT XMLAGG(XMLELEMENT("COBERTURAS",
                                                         XMLELEMENT("CodCobertura", CodCobert), 
                                                         XMLELEMENT("DescripcionCobertura", DescCobert)
                                                      )
                                          )
                                FROM (
                                       SELECT C.CodCobert, OC_COBERTURAS_DE_SEGUROS.DESCRIPCION_COBERTURA(nCodCia, nCodEmpresa, D.IdTipoSeg, D.PlanCob, C.CodCobert) DescCobert
                                         FROM COBERT_ACT C, DETALLE_POLIZA D
                                        WHERE C.IdPoliza      = nIdPoliza 
                                          AND C.CodCia        = nCodCia 
                                          AND C.StsCobertura  = 'EMI'
                                          AND C.CodCia         = D.CodCia
                                          AND C.CodEmpresa     = D.CodEmpresa
                                          AND C.IdPoliza       = D.IdPoliza
                                        GROUP BY C.CodCobert, D.IdTipoSeg, D.PlanCob, C.CodCobert
                                        UNION 
                                       SELECT C.CodCobert, OC_COBERTURAS_DE_SEGUROS.DESCRIPCION_COBERTURA(nCodCia, nCodEmpresa, D.IdTipoSeg, D.PlanCob, C.CodCobert) DescCobert
                                         FROM COBERT_ACT_ASEG C, DETALLE_POLIZA D 
                                        WHERE C.IdPoliza      = nIdPoliza 
                                          AND C.CodCia        = nCodCia 
                                          AND C.StsCobertura  = 'EMI'
                                          AND C.CodCia         = D.CodCia
                                          AND C.CodEmpresa     = D.CodEmpresa
                                          AND C.IdPoliza       = D.IdPoliza
                                        GROUP BY C.CodCobert, D.IdTipoSeg, D.PlanCob, C.CodCobert)
                                 )                            
                     )
                        )
                           )
        INTO xPrevPol
        FROM POLIZAS P, AGENTE_POLIZA A
       WHERE P.CodCia      = nCodCia
         AND P.CodEmpresa  = nCodEmpresa
         AND P.IdPoliza    = nIdPoliza
         AND P.CodCia      = A.CodCia
         AND P.IdPoliza    = A.IdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'Póliza '||nIdPoliza||' no existente en Base de Datos'); 
   END;
   SELECT XMLROOT (xPrevPol, VERSION '1.0" encoding="UTF-8')
     INTO xPoliza
     FROM DUAL;
   RETURN xPoliza;
END CONSULTA_POLIZA;

FUNCTION LISTADO_POLIZA(nCodCia         IN NUMBER,     nCodEmpresa     IN NUMBER,     nIdPoliza       IN  NUMBER,     nCodAgente IN NUMBER,
                        dFecIni         IN DATE,       dFecFin         IN DATE,       nIdCotizacion   IN  NUMBER,     cStsPoliza IN VARCHAR2,   
                        cApePaternoCli  IN VARCHAR2,   cApeMaternoCli  IN VARCHAR2,   cNombreCli      IN  VARCHAR2,   
                        nLimInferior    IN NUMBER,     nLimSuperior    IN NUMBER,     nTotRegs        OUT NUMBER  --> 23/12/2020   (JALV)
                        )
RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : ??                                                                                                               |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: ??                                                                                                               |
    | Nombre     : LISTADO_POLIZA                                                                                                   |
    | Objetivo   : Funcion que obtiene un listado general de las Polizas que cumplen con los criterios dados desde la Plataforma    |
    |              Digital y tranforma la salida en formato XML.                                                                    |
    | Modificado : Si                                                                                                               |
    | Ult. modif.: 22/02/2021                                                                                                       |
    | Modifico	 : J. Alberto Lopez Valle   (JALV)                                                                                  |
    | Email		 : alopez@thonaseguros.mx                                                                                           |
    | Obj. Modif.: Se agregan criterios de rangos de fechas dependiendo del Estado (solo para EMI, REN y ANU) de la Poliza:         |
    |                I) Status y  Fecha dados.      Rango de fechas sobre el status indicado.                                       |
    |               II) Sin Status pero con Fechas. Aplica rango de fechas para todos y cada uno de los Status.                     |
    |              III) Status sin Fecha.           Solo se obtiene informacion del Status proporcionado sin rango de fechas.       |
    |   22/01/2021  Se agregan Filtros o condicioneas adicionales para que se puedan realiar consultas por Nombre, Apellido Paterno |
    |               y Apellido Materno del cliente.                                                                                 |
    |   23/12/2020  Se agrega funcionalidad de paginacion a este listado de Polizas.                                                |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |			nCodCia 			Codigo de la Compañia	        (Entrada)                                                       |
    |			nCodEmpresa			Codigo de la Empresa	        (Entrada)                                                       |
    |			nIdPoliza			ID de la Poliza			        (Entrada)                                                       |
    |			nCodAgente			Codigo del Agente		        (Entrada)                                                       |
    |			dFecIni             Fecha de Inicio de Vig.	        (Entrada)                                                       |
    |			dFecFin             Fecha de Fin de Vig.	        (Entrada)                                                       |
    |           nIdCotizacion       ID de Cotizacion                (Entrada)                                                       |
    |           cStsPoliza          Estado de la Poliza             (Entrada)                                                       |
    |           cApePaternoCli      Apellido Paterno del Cliente    (Entrada)                                                       |
    |           cApeMaternoCli      Apellido Materno del Cliente    (Entrada)                                                       |
    |           cNombreCli          Nombre(s) del Cliente           (Entrada)                                                       |
    |           nLimInferior        Limite inferior de pagina       (Entrada)                                                       |
    |           nLimSuperior        Limite superior de pagina       (Entrada)                                                       |
    |           nTotRegs            Total de registros obtenidos    (Salida)                                                        |
    |_______________________________________________________________________________________________________________________________|
*/
xListadoPoliza    XMLTYPE;
xPrevPol          XMLTYPE;

BEGIN
    IF cStsPoliza IS NULL AND dFecIni IS NOT NULL AND dFecFin IS NOT NULL THEN   --> Inicia 22/02/2021   (JALV +)
        BEGIN
            SELECT  XMLELEMENT("DATA",
                                   XMLAGG(XMLELEMENT("POLIZAS",  
                                                        XMLELEMENT("Poliza",PP.IdPoliza),
                                                        XMLELEMENT("Producto",PP.CodPaqComercial),
                                                        XMLELEMENT("NumPolUnico",PP.NumPolUnico),
                                                        XMLELEMENT("CodigoContratante",PP.CodigoContratante),
                                                        XMLELEMENT("NombreContratante", PP.NombreContratante),
                                                        XMLELEMENT("Estatus", PP.Estatus),
                                                        XMLELEMENT("FecEmision",PP.FecEmision),
                                                        XMLELEMENT("InicioVigencia",PP.InicioVigencia),
                                                        XMLELEMENT("FinVigencia",PP.FinVigencia),
                                                        XMLELEMENT("FecRenovacion",PP.FecRenovacion),
                                                        XMLELEMENT("FecAnul",PP.FecAnul)
                                                     )
                                            )
                               )
            INTO    xPrevPol
            FROM    (SELECT ST.*,
                            ROW_NUMBER() OVER (ORDER BY ST.IdPoliza) registro
                     FROM   (SELECT P.StsPoliza,
                                    P.IdPoliza,
                                    P.CodPaqComercial,
                                    P.NumPolUnico,
                                    P.CodCliente                                                CodigoContratante,
                                    OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente)                    NombreContratante,
                                    OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', P.StsPoliza)   Estatus,                            
                                    P.FecEmision,                            
                                    P.FecRenovacion,
                                    P.FecAnul,
                                    P.FecIniVig                                                 InicioVigencia,
                                    P.FecFinVig                                                 FinVigencia
                             FROM   POLIZAS         P,
                                    COTIZACIONES    C,
                                    AGENTE_POLIZA   A,
                                    PERSONA_NATURAL_JURIDICA    PNJ,
                                    CLIENTES                    CTE
                             WHERE  P.CodCia            = C.CodCia
                             AND    P.CodEmpresa        = C.CodEmpresa
                             AND    P.Num_Cotizacion    = C.IdCotizacion
                             AND    P.CodCia            = A.CodCia
                             AND    P.IdPoliza          = A.IdPoliza
                             AND    P.codcliente                = CTE.codcliente
                             AND    PNJ.tipo_doc_identificacion = CTE.tipo_doc_identificacion
                             AND    PNJ.num_doc_identificacion  = CTE.num_doc_identificacion
                             AND    P.StsPoliza         = 'EMI'
                             AND    P.CodCia            = nCodCia
                             AND    P.CodEmpresa        = nCodEmpresa
                             AND    A.Cod_Agente        = nCodAgente                    
                             AND    C.IdCotizacion      = NVL(nIdCotizacion, C.IdCotizacion)
                             AND    P.IdPoliza          = NVL(nIdPoliza,P.IdPoliza)
                             AND    UPPER(PNJ.nombre)   LIKE '%'||UPPER(NVL(cNombreCli, PNJ.nombre))||'%'
                             AND    ( UPPER( NVL(PNJ.apellido_paterno,'NULO')) LIKE '%'||UPPER(NVL2(cApePaternoCli, PNJ.apellido_paterno, 'NULO'))||'%' OR UPPER( NVL2(PNJ.apellido_paterno, PNJ.apellido_paterno, 'NULO') ) LIKE '%'||UPPER( NVL2(cApePaternoCli, 'NULO', PNJ.apellido_paterno))||'%' )
                             AND    ( UPPER( NVL(PNJ.apellido_materno,'NULO')) LIKE '%'||UPPER(NVL2(cApeMaternoCli, PNJ.apellido_materno, 'NULO'))||'%' OR UPPER( NVL2(PNJ.apellido_materno, PNJ.apellido_materno, 'NULO') ) LIKE '%'||UPPER( NVL2(cApeMaternoCli, 'NULO', PNJ.apellido_materno))||'%' )
                             AND    P.FecEmision  BETWEEN NVL(dFecIni, P.FecEmision) AND NVL(dFecFin, P.FecEmision)
                     UNION
                            SELECT  P.StsPoliza,
                                    P.IdPoliza,
                                    P.CodPaqComercial,
                                    P.NumPolUnico,
                                    P.CodCliente                                                CodigoContratante,
                                    OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente)                    NombreContratante,
                                    OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', P.StsPoliza)   Estatus,                            
                                    P.FecEmision,                            
                                    P.FecRenovacion,
                                    P.FecAnul,
                                    P.FecIniVig                                                 InicioVigencia,
                                    P.FecFinVig                                                 FinVigencia
                            FROM    POLIZAS         P,
                                    COTIZACIONES    C,
                                    AGENTE_POLIZA   A,
                                    PERSONA_NATURAL_JURIDICA    PNJ,
                                    CLIENTES                    CTE
                            WHERE   P.CodCia            = C.CodCia
                            AND     P.CodEmpresa        = C.CodEmpresa
                            AND     P.Num_Cotizacion    = C.IdCotizacion
                            AND     P.CodCia            = A.CodCia
                            AND     P.IdPoliza          = A.IdPoliza
                            AND     P.codcliente                = CTE.codcliente
                            AND     PNJ.tipo_doc_identificacion = CTE.tipo_doc_identificacion
                            AND     PNJ.num_doc_identificacion  = CTE.num_doc_identificacion
                            AND     P.StsPoliza         = 'REN'
                            AND     P.CodCia            = nCodCia
                            AND     P.CodEmpresa        = nCodEmpresa
                            AND     A.Cod_Agente        = nCodAgente                    
                            AND     C.IdCotizacion      = NVL(nIdCotizacion, C.IdCotizacion)
                            AND     P.IdPoliza          = NVL(nIdPoliza,P.IdPoliza)
                            AND     UPPER(PNJ.nombre)   LIKE '%'||UPPER(NVL(cNombreCli, PNJ.nombre))||'%'
                            AND     ( UPPER( NVL(PNJ.apellido_paterno,'NULO')) LIKE '%'||UPPER(NVL2(cApePaternoCli, PNJ.apellido_paterno, 'NULO'))||'%' OR UPPER( NVL2(PNJ.apellido_paterno, PNJ.apellido_paterno, 'NULO') ) LIKE '%'||UPPER( NVL2(cApePaternoCli, 'NULO', PNJ.apellido_paterno))||'%' )
                            AND     ( UPPER( NVL(PNJ.apellido_materno,'NULO')) LIKE '%'||UPPER(NVL2(cApeMaternoCli, PNJ.apellido_materno, 'NULO'))||'%' OR UPPER( NVL2(PNJ.apellido_materno, PNJ.apellido_materno, 'NULO') ) LIKE '%'||UPPER( NVL2(cApeMaternoCli, 'NULO', PNJ.apellido_materno))||'%' )
                            AND     P.FecRenovacion  BETWEEN NVL(dFecIni, P.FecRenovacion) AND NVL(dFecFin, P.FecRenovacion)
                     UNION
                            SELECT  P.StsPoliza,
                                    P.IdPoliza,
                                    P.CodPaqComercial,
                                    P.NumPolUnico,
                                    P.CodCliente                                                CodigoContratante,
                                    OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente)                    NombreContratante,
                                    OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', P.StsPoliza)   Estatus,                            
                                    P.FecEmision,                            
                                    P.FecRenovacion,
                                    P.FecAnul,
                                    P.FecIniVig                                                 InicioVigencia,
                                    P.FecFinVig                                                 FinVigencia                           
                            FROM    POLIZAS         P,
                                    COTIZACIONES    C,
                                    AGENTE_POLIZA   A,
                                    PERSONA_NATURAL_JURIDICA    PNJ,
                                    CLIENTES                    CTE
                            WHERE   P.CodCia            = C.CodCia
                            AND     P.CodEmpresa        = C.CodEmpresa
                            AND     P.Num_Cotizacion    = C.IdCotizacion
                            AND     P.CodCia            = A.CodCia
                            AND     P.IdPoliza          = A.IdPoliza
                            AND     P.codcliente                = CTE.codcliente
                            AND     PNJ.tipo_doc_identificacion = CTE.tipo_doc_identificacion
                            AND     PNJ.num_doc_identificacion  = CTE.num_doc_identificacion
                            AND     P.StsPoliza         = 'ANU'
                            AND     P.CodCia            = nCodCia
                            AND     P.CodEmpresa        = nCodEmpresa
                            AND     A.Cod_Agente        = nCodAgente                    
                            AND     C.IdCotizacion      = NVL(nIdCotizacion, C.IdCotizacion)
                            AND     P.IdPoliza          = NVL(nIdPoliza,P.IdPoliza)
                            AND     UPPER(PNJ.nombre)   LIKE '%'||UPPER(NVL(cNombreCli, PNJ.nombre))||'%'
                            AND     ( UPPER( NVL(PNJ.apellido_paterno,'NULO')) LIKE '%'||UPPER(NVL2(cApePaternoCli, PNJ.apellido_paterno, 'NULO'))||'%' OR UPPER( NVL2(PNJ.apellido_paterno, PNJ.apellido_paterno, 'NULO') ) LIKE '%'||UPPER( NVL2(cApePaternoCli, 'NULO', PNJ.apellido_paterno))||'%' )
                            AND     ( UPPER( NVL(PNJ.apellido_materno,'NULO')) LIKE '%'||UPPER(NVL2(cApeMaternoCli, PNJ.apellido_materno, 'NULO'))||'%' OR UPPER( NVL2(PNJ.apellido_materno, PNJ.apellido_materno, 'NULO') ) LIKE '%'||UPPER( NVL2(cApeMaternoCli, 'NULO', PNJ.apellido_materno))||'%' )
                            AND     P.FecAnul  BETWEEN NVL(dFecIni, P.FecAnul) AND NVL(dFecFin, P.FecAnul)
                            ) ST
                    ) PP
            WHERE   PP.registro BETWEEN nLimInferior AND nLimSuperior;

            SELECT  NVL(COUNT(*),0) TOT_REGS
            INTO    nTotRegs
            FROM    (SELECT P.StsPoliza,
                            P.IdPoliza,
                            P.CodPaqComercial,
                            P.NumPolUnico,
                            P.CodCliente                                                CodigoContratante,
                            OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente)                    NombreContratante,
                            OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', P.StsPoliza)   Estatus,                            
                            P.FecEmision,                            
                            P.FecRenovacion,
                            P.FecAnul,
                            P.FecIniVig                                                 InicioVigencia,
                            P.FecFinVig                                                 FinVigencia
                     FROM   POLIZAS         P,
                            COTIZACIONES    C,
                            AGENTE_POLIZA   A,
                            PERSONA_NATURAL_JURIDICA    PNJ,
                            CLIENTES                    CTE
                     WHERE  P.CodCia            = C.CodCia
                     AND    P.CodEmpresa        = C.CodEmpresa
                     AND    P.Num_Cotizacion    = C.IdCotizacion
                     AND    P.CodCia            = A.CodCia
                     AND    P.IdPoliza          = A.IdPoliza
                     AND    P.codcliente                = CTE.codcliente
                     AND    PNJ.tipo_doc_identificacion = CTE.tipo_doc_identificacion
                     AND    PNJ.num_doc_identificacion  = CTE.num_doc_identificacion
                     AND    P.StsPoliza         = 'EMI'
                     AND    P.CodCia            = nCodCia
                     AND    P.CodEmpresa        = nCodEmpresa
                     AND    A.Cod_Agente        = nCodAgente                    
                     AND    C.IdCotizacion      = NVL(nIdCotizacion, C.IdCotizacion)
                     AND    P.IdPoliza          = NVL(nIdPoliza,P.IdPoliza)
                     AND    UPPER(PNJ.nombre)   LIKE '%'||UPPER(NVL(cNombreCli, PNJ.nombre))||'%'
                     AND    ( UPPER( NVL(PNJ.apellido_paterno,'NULO')) LIKE '%'||UPPER(NVL2(cApePaternoCli, PNJ.apellido_paterno, 'NULO'))||'%' OR UPPER( NVL2(PNJ.apellido_paterno, PNJ.apellido_paterno, 'NULO') ) LIKE '%'||UPPER( NVL2(cApePaternoCli, 'NULO', PNJ.apellido_paterno))||'%' )
                     AND    ( UPPER( NVL(PNJ.apellido_materno,'NULO')) LIKE '%'||UPPER(NVL2(cApeMaternoCli, PNJ.apellido_materno, 'NULO'))||'%' OR UPPER( NVL2(PNJ.apellido_materno, PNJ.apellido_materno, 'NULO') ) LIKE '%'||UPPER( NVL2(cApeMaternoCli, 'NULO', PNJ.apellido_materno))||'%' )
                     AND    P.FecEmision  BETWEEN NVL(dFecIni, P.FecEmision) AND NVL(dFecFin, P.FecEmision)
             UNION
                    SELECT  P.StsPoliza,
                            P.IdPoliza,
                            P.CodPaqComercial,
                            P.NumPolUnico,
                            P.CodCliente                                                CodigoContratante,
                            OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente)                    NombreContratante,
                            OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', P.StsPoliza)   Estatus,                            
                            P.FecEmision,                            
                            P.FecRenovacion,
                            P.FecAnul,
                            P.FecIniVig                                                 InicioVigencia,
                            P.FecFinVig                                                 FinVigencia
                    FROM    POLIZAS         P,
                            COTIZACIONES    C,
                            AGENTE_POLIZA   A,
                            PERSONA_NATURAL_JURIDICA    PNJ,
                            CLIENTES                    CTE
                    WHERE   P.CodCia            = C.CodCia
                    AND     P.CodEmpresa        = C.CodEmpresa
                    AND     P.Num_Cotizacion    = C.IdCotizacion
                    AND     P.CodCia            = A.CodCia
                    AND     P.IdPoliza          = A.IdPoliza
                    AND     P.codcliente                = CTE.codcliente
                    AND     PNJ.tipo_doc_identificacion = CTE.tipo_doc_identificacion
                    AND     PNJ.num_doc_identificacion  = CTE.num_doc_identificacion
                    AND     P.StsPoliza         = 'REN'
                    AND     P.CodCia            = nCodCia
                    AND     P.CodEmpresa        = nCodEmpresa
                    AND     A.Cod_Agente        = nCodAgente                    
                    AND     C.IdCotizacion      = NVL(nIdCotizacion, C.IdCotizacion)
                    AND     P.IdPoliza          = NVL(nIdPoliza,P.IdPoliza)
                    AND     UPPER(PNJ.nombre)   LIKE '%'||UPPER(NVL(cNombreCli, PNJ.nombre))||'%'
                    AND     ( UPPER( NVL(PNJ.apellido_paterno,'NULO')) LIKE '%'||UPPER(NVL2(cApePaternoCli, PNJ.apellido_paterno, 'NULO'))||'%' OR UPPER( NVL2(PNJ.apellido_paterno, PNJ.apellido_paterno, 'NULO') ) LIKE '%'||UPPER( NVL2(cApePaternoCli, 'NULO', PNJ.apellido_paterno))||'%' )
                    AND     ( UPPER( NVL(PNJ.apellido_materno,'NULO')) LIKE '%'||UPPER(NVL2(cApeMaternoCli, PNJ.apellido_materno, 'NULO'))||'%' OR UPPER( NVL2(PNJ.apellido_materno, PNJ.apellido_materno, 'NULO') ) LIKE '%'||UPPER( NVL2(cApeMaternoCli, 'NULO', PNJ.apellido_materno))||'%' )
                    AND     P.FecRenovacion  BETWEEN NVL(dFecIni, P.FecRenovacion) AND NVL(dFecFin, P.FecRenovacion)
             UNION
                    SELECT  P.StsPoliza,
                            P.IdPoliza,
                            P.CodPaqComercial,
                            P.NumPolUnico,
                            P.CodCliente                                                CodigoContratante,
                            OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente)                    NombreContratante,
                            OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', P.StsPoliza)   Estatus,                            
                            P.FecEmision,
                            P.FecRenovacion,
                            P.FecAnul,
                            P.FecIniVig                                                 InicioVigencia,
                            P.FecFinVig                                                 FinVigencia
                    FROM    POLIZAS         P,
                            COTIZACIONES    C,
                            AGENTE_POLIZA   A,
                            PERSONA_NATURAL_JURIDICA    PNJ,
                            CLIENTES                    CTE
                    WHERE   P.CodCia            = C.CodCia
                    AND     P.CodEmpresa        = C.CodEmpresa
                    AND     P.Num_Cotizacion    = C.IdCotizacion
                    AND     P.CodCia            = A.CodCia
                    AND     P.IdPoliza          = A.IdPoliza
                    AND     P.codcliente                = CTE.codcliente
                    AND     PNJ.tipo_doc_identificacion = CTE.tipo_doc_identificacion
                    AND     PNJ.num_doc_identificacion  = CTE.num_doc_identificacion
                    AND     P.StsPoliza         = 'ANU'
                    AND     P.CodCia            = nCodCia
                    AND     P.CodEmpresa        = nCodEmpresa
                    AND     A.Cod_Agente        = nCodAgente                    
                    AND     C.IdCotizacion      = NVL(nIdCotizacion, C.IdCotizacion)
                    AND     P.IdPoliza          = NVL(nIdPoliza,P.IdPoliza)
                    AND     UPPER(PNJ.nombre)   LIKE '%'||UPPER(NVL(cNombreCli, PNJ.nombre))||'%'
                    AND     ( UPPER( NVL(PNJ.apellido_paterno,'NULO')) LIKE '%'||UPPER(NVL2(cApePaternoCli, PNJ.apellido_paterno, 'NULO'))||'%' OR UPPER( NVL2(PNJ.apellido_paterno, PNJ.apellido_paterno, 'NULO') ) LIKE '%'||UPPER( NVL2(cApePaternoCli, 'NULO', PNJ.apellido_paterno))||'%' )
                    AND     ( UPPER( NVL(PNJ.apellido_materno,'NULO')) LIKE '%'||UPPER(NVL2(cApeMaternoCli, PNJ.apellido_materno, 'NULO'))||'%' OR UPPER( NVL2(PNJ.apellido_materno, PNJ.apellido_materno, 'NULO') ) LIKE '%'||UPPER( NVL2(cApeMaternoCli, 'NULO', PNJ.apellido_materno))||'%' )
                    AND     P.FecAnul  BETWEEN NVL(dFecIni, P.FecAnul) AND NVL(dFecFin, P.FecAnul) 
            );
        END;
    ELSE                                                                        --> Fin 22/02/2021   (JALV +)
       BEGIN
            SELECT  XMLELEMENT("DATA",
                                   XMLAGG(XMLELEMENT("POLIZAS",  
                                                        XMLELEMENT("Poliza",PP.IdPoliza),
                                                        XMLELEMENT("Producto",PP.CodPaqComercial),
                                                        XMLELEMENT("NumPolUnico",PP.NumPolUnico),
                                                        XMLELEMENT("CodigoContratante",PP.CodigoContratante),   --> 23/12/2020   (JALV)
                                                        XMLELEMENT("NombreContratante", PP.NombreContratante),  --> 23/12/2020   (JALV)
                                                        XMLELEMENT("Estatus", PP.Estatus),                      --> 23/12/2020   (JALV)
                                                        XMLELEMENT("FecEmision",PP.FecEmision),
                                                        XMLELEMENT("InicioVigencia",PP.InicioVigencia),         --> 23/12/2020   (JALV)
                                                        XMLELEMENT("FinVigencia",PP.FinVigencia),               --> 23/12/2020   (JALV)
                                                        XMLELEMENT("FecRenovacion",PP.FecRenovacion),
                                                        XMLELEMENT("FecAnul",PP.FecAnul)
                                                     )
                                            )
                               )
            INTO    xPrevPol
            FROM    (SELECT P.IdPoliza,                                                 --> Inicio  23/12/2020   (JALV)
                            P.CodPaqComercial,
                            P.NumPolUnico,
                            P.CodCliente                                                CodigoContratante,
                            OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente)                    NombreContratante,
                            OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', P.StsPoliza)   Estatus,                            
                            P.FecEmision,                            
                            P.FecRenovacion,
                            P.FecAnul,
                            P.FecIniVig                                                 InicioVigencia,
                            P.FecFinVig                                                 FinVigencia,                            
                            ROW_NUMBER() OVER (ORDER BY P.IdPoliza)                     Registro    --> Fin 23/12/2020   (JALV +)                            
                    FROM    POLIZAS                     P,
                            COTIZACIONES                C,
                            AGENTE_POLIZA               A,
                            PERSONA_NATURAL_JURIDICA    PNJ,                            --> 22/01/2021   (JALV +)
                            CLIENTES                    CTE                             --> 22/01/2021   (JALV +)
                    WHERE   P.CodCia            = C.CodCia
                    AND     P.CodEmpresa        = C.CodEmpresa
                    AND     P.Num_Cotizacion    = C.IdCotizacion
                    AND     P.CodCia            = A.CodCia
                    AND     P.IdPoliza          = A.IdPoliza
                    AND     P.codcliente                = CTE.codcliente                --> 22/01/2021   (JALV +)
                    AND     PNJ.tipo_doc_identificacion = CTE.tipo_doc_identificacion   --> 22/01/2021   (JALV +)
                    AND     PNJ.num_doc_identificacion  = CTE.num_doc_identificacion    --> 22/01/2021   (JALV +)
                    AND     P.StsPoliza         IN ('EMI','ANU','REN')
                    AND     P.StsPoliza         = NVL(cStsPoliza, P.StsPoliza)          --> 22/02/2021   (JALV +)
                    AND     P.CodCia            = nCodCia
                    AND     P.CodEmpresa        = nCodEmpresa
                    AND     A.Cod_Agente        = nCodAgente                    
                    AND     C.IdCotizacion      = NVL(nIdCotizacion, C.IdCotizacion)
                    AND     P.IdPoliza          = NVL(nIdPoliza,P.IdPoliza)
                    AND     UPPER(PNJ.nombre)   LIKE '%'||UPPER(NVL(cNombreCli, PNJ.nombre))||'%'   --> 22/01/2021   (JALV +)
                    AND     ( UPPER( NVL(PNJ.apellido_paterno,'NULO')) LIKE '%'||UPPER(NVL2(cApePaternoCli, PNJ.apellido_paterno, 'NULO'))||'%' OR UPPER( NVL2(PNJ.apellido_paterno, PNJ.apellido_paterno, 'NULO') ) LIKE '%'||UPPER( NVL2(cApePaternoCli, 'NULO', PNJ.apellido_paterno))||'%' )    --> 22/01/2021   (JALV +)
                    AND     ( UPPER( NVL(PNJ.apellido_materno,'NULO')) LIKE '%'||UPPER(NVL2(cApeMaternoCli, PNJ.apellido_materno, 'NULO'))||'%' OR UPPER( NVL2(PNJ.apellido_materno, PNJ.apellido_materno, 'NULO') ) LIKE '%'||UPPER( NVL2(cApeMaternoCli, 'NULO', PNJ.apellido_materno))||'%' )    --> 22/01/2021   (JALV +)
                    --AND     DECODE(:cStsPoliza, 'EMI', P.FecEmision, DECODE(:cStsPoliza,'REN', P.FecRenovacion, P.FecAnul))  BETWEEN NVL(:dFecIni, DECODE(:cStsPoliza, 'EMI', 'P.FecEmision', DECODE(:cStsPoliza,'REN', P.FecRenovacion, P.FecAnul))) AND NVL(:dFecFin, DECODE(:cStsPoliza, 'EMI', P.FecEmision, DECODE(:cStsPoliza,'REN', P.FecRenovacion, P.FecAnul)))   -- ok para Status Not Null                 
                    AND     DECODE(cStsPoliza, 'EMI', P.FecEmision, DECODE(cStsPoliza, 'REN', P.FecRenovacion, DECODE(cStsPoliza, 'ANU', P.FecAnul,TO_DATE(1,'D')))) BETWEEN NVL2(cStsPoliza, NVL(dFecIni, DECODE(cStsPoliza, 'EMI', P.FecEmision, DECODE(cStsPoliza, 'REN', P.FecRenovacion, P.FecAnul)) ), TO_DATE(1,'D') ) AND NVL2(cStsPoliza, NVL(dFecFin, DECODE(cStsPoliza, 'EMI', P.FecEmision, DECODE(cStsPoliza, 'REN', P.FecRenovacion, P.FecAnul)) ), TO_DATE(1,'D') )  --> 22/02/2021   (JALV +)
                    ) PP                                                            --> 23/12/2020   (JALV +)
            WHERE   PP.registro BETWEEN nLimInferior AND nLimSuperior;              --> 23/12/2020   (JALV +)

            SELECT  NVL(COUNT(*),0) TOT_REGS
            INTO    nTotRegs
            FROM    POLIZAS                     P,
                    COTIZACIONES                C,
                    AGENTE_POLIZA               A,
                    PERSONA_NATURAL_JURIDICA    PNJ,                            --> 22/01/2021   (JALV +)
                    CLIENTES                    CTE                             --> 22/01/2021   (JALV +)
            WHERE   P.CodCia            = C.CodCia
            AND     P.CodEmpresa        = C.CodEmpresa
            AND     P.Num_Cotizacion    = C.IdCotizacion
            AND     P.CodCia            = A.CodCia
            AND     P.IdPoliza          = A.IdPoliza
            AND     P.codcliente                = CTE.codcliente                --> 22/01/2021   (JALV +)
            AND     PNJ.tipo_doc_identificacion = CTE.tipo_doc_identificacion   --> 22/01/2021   (JALV +)
            AND     PNJ.num_doc_identificacion  = CTE.num_doc_identificacion    --> 22/01/2021   (JALV +)
            AND     P.StsPoliza         IN ('EMI','ANU','REN')
            AND     P.StsPoliza         = NVL(cStsPoliza, P.StsPoliza)          --> 22/02/2021   (JALV +)
            AND     P.CodCia            = nCodCia
            AND     P.CodEmpresa        = nCodEmpresa
            AND     A.Cod_Agente        = nCodAgente                    
            AND     C.IdCotizacion      = NVL(nIdCotizacion, C.IdCotizacion)
            AND     P.IdPoliza          = NVL(nIdPoliza,P.IdPoliza)
            AND     UPPER(PNJ.nombre)   LIKE '%'||UPPER(NVL(cNombreCli, PNJ.nombre))||'%'   --> 22/01/2021   (JALV +)
            AND     ( UPPER( NVL(PNJ.apellido_paterno,'NULO')) LIKE '%'||UPPER(NVL2(cApePaternoCli, PNJ.apellido_paterno, 'NULO'))||'%' OR UPPER( NVL2(PNJ.apellido_paterno, PNJ.apellido_paterno, 'NULO') ) LIKE '%'||UPPER( NVL2(cApePaternoCli, 'NULO', PNJ.apellido_paterno))||'%' )    --> 22/01/2021   (JALV +)
            AND     ( UPPER( NVL(PNJ.apellido_materno,'NULO')) LIKE '%'||UPPER(NVL2(cApeMaternoCli, PNJ.apellido_materno, 'NULO'))||'%' OR UPPER( NVL2(PNJ.apellido_materno, PNJ.apellido_materno, 'NULO') ) LIKE '%'||UPPER( NVL2(cApeMaternoCli, 'NULO', PNJ.apellido_materno))||'%' )    --> 22/01/2021   (JALV +)
            --AND     DECODE(:cStsPoliza, 'EMI', P.FecEmision, DECODE(:cStsPoliza,'REN', P.FecRenovacion, P.FecAnul))  BETWEEN NVL(:dFecIni, DECODE(:cStsPoliza, 'EMI', 'P.FecEmision', DECODE(:cStsPoliza,'REN', P.FecRenovacion, P.FecAnul))) AND NVL(:dFecFin, DECODE(:cStsPoliza, 'EMI', P.FecEmision, DECODE(:cStsPoliza,'REN', P.FecRenovacion, P.FecAnul)))   -- ok para Status Not Null                 
            AND     DECODE(cStsPoliza, 'EMI', P.FecEmision, DECODE(cStsPoliza, 'REN', P.FecRenovacion, DECODE(cStsPoliza, 'ANU', P.FecAnul,TO_DATE(1,'D')))) BETWEEN NVL2(cStsPoliza, NVL(dFecIni, DECODE(cStsPoliza, 'EMI', P.FecEmision, DECODE(cStsPoliza, 'REN', P.FecRenovacion, P.FecAnul)) ), TO_DATE(1,'D') ) AND NVL2(cStsPoliza, NVL(dFecFin, DECODE(cStsPoliza, 'EMI', P.FecEmision, DECODE(cStsPoliza, 'REN', P.FecRenovacion, P.FecAnul)) ), TO_DATE(1,'D') )  --> 22/02/2021   (JALV +)
            ;            
       END;
   END IF;  --> 22/02/2021   (JALV +)

   SELECT XMLROOT (xPrevPol, VERSION '1.0" encoding="UTF-8')
     INTO xListadoPoliza
     FROM DUAL;
   RETURN xListadoPoliza;
END LISTADO_POLIZA;


      FUNCTION GENERA_POLIZA( nCodCia        NUMBER
                         , nCodEmpresa    NUMBER
                         , nIdCotizacion  NUMBER
                         , xDatosCli      XMLTYPE ) RETURN NUMBER IS
      nIdPoliza               POLIZAS.IdPoliza%TYPE;
      cTipoDocIdentificacion  PERSONA_NATURAL_JURIDICA.Tipo_Doc_Identificacion%TYPE;
      cNumDocIdentificacion   PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE;
      cTipoPersona            PERSONA_NATURAL_JURIDICA.Tipo_Persona%TYPE;
      nCodCliente             CLIENTES.CodCliente%TYPE;
      cCodPais                PAIS.CodPais%TYPE;
      cCodEstado              CORREGIMIENTO.CodEstado%TYPE;
      cCodCiudad              DISTRITO.CodCiudad%TYPE;
      cCodMunicipio           COLONIA.CodMunicipio%TYPE;
      nIdFormaCobro           MEDIOS_DE_COBRO.IdFormaCobro%TYPE;
      nCodAsegurado           ASEGURADO.Cod_Asegurado%TYPE;
      nIdTransac              TRANSACCION.IDTRANSACCION%TYPE;
      cPrima                  NUMBER;
   BEGIN
      --
      IF GT_COTIZACIONES.EXISTE_COTIZACION_EMITIDA(nCodCia, nCodEmpresa, nIdCotizacion) = 'N' THEN
         NULL; --RETURN 'Esta cotización no esta emitida: ' || NIDCOTIZACION;
      END IF;
      --
      FOR X IN ( SELECT * 
                 FROM   XMLTABLE( '/DATA'
                                  PASSING xDatosCli
                                  COLUMNS 
                                  TipoDocIdentificacion    VARCHAR2(10)   PATH 'TipoDocIdentificacion',
                                  NumDocIdentificacion     VARCHAR2(300)  PATH 'NumDocIdentificacion',
                                  NombreCliente            VARCHAR2(200)  PATH 'NombreCliente',
                                  ApellidoPaternoCliente   VARCHAR2(50)   PATH 'ApellidoPaternoCliente',
                                  ApellidoMaternoCliente   VARCHAR2(50)   PATH 'ApellidoMaternoCliente',
                                  Sexo                     VARCHAR2(1)    PATH 'Sexo',
                                  FecNacimiento            VARCHAR2(10)   PATH 'FecNacimiento',
                                  TipoPersona              VARCHAR2(6)    PATH 'TipoPersona',
                                  TipoIdTributario         VARCHAR2(5)    PATH 'TipoIdTributario',
                                  NumTributario            VARCHAR2(20)   PATH 'NumTributario',
                                  DirecRes                 VARCHAR2(250)  PATH 'DirecRes',
                                  NumInterior              VARCHAR2(20)   PATH 'NumInterior',
                                  NumExterior              VARCHAR2(20)   PATH 'NumExterior',
                                  CodColonia               VARCHAR2(6)    PATH 'CodColonia',
                                  CodProvRes               VARCHAR2(3)    PATH 'CodProvRes',
                                  CodPosRes                VARCHAR2(30)   PATH 'CodPosRes',
                                  TelRes                   VARCHAR2(30)   PATH 'TelRes',
                                  Email                    VARCHAR2(150)  PATH 'Email',
                                  Nacionalidad             VARCHAR2(6)    PATH 'Nacionalidad',
                                  CodFormaCobro            VARCHAR2(6)    PATH 'CodFormaCobro',
                                  CodEntidadFinan          VARCHAR2(6)    PATH 'CodEntidadFinan',
                                  NumCuentaBancaria        VARCHAR2(20)   PATH 'NumCuentaBancaria',
                                  NumCuentaClabe           VARCHAR2(20)   PATH 'NumCuentaClabe',
                                  NumTarjeta               VARCHAR2(20)   PATH 'NumTarjeta',
                                  FechaVencTarjeta         VARCHAR2(10)   PATH 'FechaVencTarjeta',
                                  NombreTitular            VARCHAR2(300)  PATH 'NombreTitular',
                                  FecIniVig                VARCHAR2(10)   PATH 'FecIniVig',
                                  FecFinVig                VARCHAR2(10)   PATH 'FecFinVig',
                                  CodPlanPago              VARCHAR2(6)    PATH 'CodPlanPago',
                                  IndAsegModelo            VARCHAR2(1)    PATH 'IndAsegModelo',
                                  CodActividad             VARCHAR2(10)   PATH 'CodActividad'
                                ) CLI
               )
      LOOP
         IF X.IndAsegModelo = 'N' THEN
            UPDATE COTIZACIONES
            SET    IndAsegModelo = X.IndAsegModelo
            WHERE  IdCotizacion = nIdCotizacion;
         END IF;
         --
         cTipoPersona := X.TipoPersona;
         IF X.TipoDocIdentificacion IS NOT NULL AND X.NumDocIdentificacion IS NOT NULL THEN
            cTipoDocIdentificacion  := X.TipoDocIdentificacion;
            cNumDocIdentificacion   := X.NumDocIdentificacion;
         ELSE
            cTipoDocIdentificacion  := 'RFC';
            cNumDocIdentificacion   := OC_PERSONA_NATURAL_JURIDICA.NUMERO_TRIBUTARIO_RFC(CAMBIA_ACENTOS(X.NombreCliente),
                                                                                         CAMBIA_ACENTOS(X.ApellidoPaternoCliente),
                                                                                         CAMBIA_ACENTOS(X.ApellidoMaternoCliente),
                                                                                         TO_DATE(X.FecNacimiento,'DD/MM/YYYY'),
                                                                                         cTipoPersona);
         END IF; 
         --
         BEGIN
            SELECT DISTINCT PA.CodPais, M.CodEstado, D.CodCiudad, C.CodMunicipio    
            INTO   cCodPais, cCodEstado, cCodCiudad, cCodMunicipio
            FROM   APARTADO_POSTAL CP  INNER JOIN CORREGIMIENTO M ON  M.CodMunicipio   = CP.CodMunicipio 
                                                                  AND M.CodPais        = CP.CodPais 
                                                                  AND M.CodEstado      = CP.CodEstado 
                                                                  AND M.CodCiudad      = CP.CodCiudad 
                                       INNER JOIN COLONIA C       ON  C.CodPais        = CP.CodPais 
                                                                  AND C.CodEstado      = CP.CodEstado 
                                                                  AND C.CodCiudad      = CP.CodCiudad 
                                                                  AND C.CodMunicipio   = M.CodMunicipio 
                                                                  AND C.Codigo_Postal  = CP.Codigo_Postal
                                       INNER JOIN PROVINCIA P     ON  P.CodPais        = CP.CodPais 
                                                                  AND P.CodEstado      = CP.CodEstado
                                       INNER JOIN DISTRITO D      ON  D.CodPais        = CP.CodPais 
                                                                  AND D.CodEstado      = CP.CodEstado 
                                                                  AND D.CodCiudad      = C.CodCiudad 
                                       INNER JOIN PAIS PA         ON  PA.CodPais       = CP.CodPais                                   
            WHERE CP.Codigo_Postal = X.CodPosRes
              AND C.Codigo_Colonia = X.CodColonia;
         END;
         --
         IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentificacion, cNumDocIdentificacion) = 'N' THEN
            --             
            OC_PERSONA_NATURAL_JURIDICA.INSERTAR_PERSONA( cTipoDocIdentificacion,                 --cTipo_Doc_Identificacion
                                                          cNumDocIdentificacion,                  --cNum_Doc_Identificacion
                                                          X.NombreCliente,                        --cNombre
                                                          X.ApellidoPaternoCliente,               --cApellidoPat
                                                          X.ApellidoMaternoCliente,               --cApellidoMat
                                                          NULL,                                   --cApeCasada
                                                          NVL(X.Sexo,'U'),                        --cSexo
                                                          NULL,                                   --cEstadoCivil
                                                          TO_DATE(X.FecNacimiento,'DD/MM/YYYY'),  --dFecNacimiento
                                                          X.DirecRes,                             --cDirecRes
                                                          X.NumInterior,                          --cNumInterior
                                                          X.NumExterior,                          --cNumExterior
                                                          cCodPais,                               --cCodPaisRes
                                                          cCodEstado,                             --OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,16,','),  --cCodProvRes
                                                          cCodCiudad,                             --cCodDistRes       
                                                          cCodMunicipio,                          --cCodCorrRes
                                                          X.CodPosRes,                            --cCodPosRes
                                                          X.CodColonia,                           --cCodColonia
                                                          X.TelRes,                               --cTelRes
                                                          X.Email,                                --cEmail
                                                          NULL );                                 --cLadaTelRes
            --
            UPDATE PERSONA_NATURAL_JURIDICA J 
            SET    Tipo_Persona       = cTipoPersona,
                   Tipo_Id_Tributaria = X.TipoIdTributario,
                   Num_Tributario     = NVL(X.NumTributario, 'XAXX010101000'),
                   Nacionalidad       = X.Nacionalidad,
                   CodActividad       = X.CodActividad
            WHERE  Tipo_Doc_Identificacion = cTipoDocIdentificacion
              AND  Num_Doc_Identificacion  = cNumDocIdentificacion;
         ELSE 
            UPDATE PERSONA_NATURAL_JURIDICA
            SET    CodPaisRes      = cCodPais,
                   CodProvRes      = cCodEstado,
                   CodDistRes      = cCodCiudad,
                   CodCorrRes      = cCodMunicipio,
                   CodPosRes       = X.CodPosRes,
                   ZipRes          = X.CodPosRes,
                   CodColRes       = X.CodColonia,
                   DirecRes        = X.DirecRes,      --cDirecRes
                   NumInterior     = X.NumInterior,   --cNumInterior
                   NumExterior     = X.NumExterior,   --cNumExterior
                   Nacionalidad    = X.Nacionalidad,  -- nacionalidad
                   Num_Tributario  = NVL(X.NumTributario, 'XAXX010101000'),
                   CodActividad    = X.CodActividad
            WHERE  Tipo_Doc_Identificacion = cTipoDocIdentificacion
              AND  Num_Doc_Identificacion  = cNumDocIdentificacion;
         END IF;
         --
         IF X.CodFormaCobro IS NOT NULL THEN
            BEGIN
               SELECT NVL(MAX(IdFormaCobro),0)
               INTO   nIdFormaCobro
               FROM   MEDIOS_DE_COBRO
               WHERE  Tipo_Doc_Identificacion = cTipoDocIdentificacion
                 AND  Num_Doc_Identificacion  = cNumDocIdentificacion;
            END;
            --
            IF nIdFormaCobro = 0 THEN 
               nIdFormaCobro := 1;
            ELSE
               nIdFormaCobro := nIdFormaCobro + 1;
            END IF;
            --
            OC_MEDIOS_DE_COBRO.INSERTAR(cTipoDocIdentificacion, cNumDocIdentificacion, nIdFormaCobro, 'S', 'CTC');
            --
            UPDATE MEDIOS_DE_COBRO
            SET    CodFormaCobro       = X.CodFormaCobro,
                   CodEntidadFinan     = X.CodEntidadFinan,
                   NumCuentaBancaria   = X.NumCuentaBancaria,
                   NumCuentaClabe      = X.NumCuentaClabe,
                   NumTarjeta          = X.NumTarjeta,
                   FechaVencTarjeta    = TO_DATE(X.FechaVencTarjeta, 'DD/MM/YYYY'),
                   NombreTitular       = X.NombreTitular
            WHERE  Tipo_Doc_Identificacion   = cTipoDocIdentificacion
              AND  Num_Doc_Identificacion    = cNumDocIdentificacion
              AND  IdFormaCobro              = nIdFormaCobro;
         END IF;
         --
         nCodCliente := OC_CLIENTES.CODIGO_CLIENTE(cTipoDocIdentificacion, cNumDocIdentificacion);
         --
         IF nCodCliente = 0 THEN
            nCodCliente := OC_CLIENTES.INSERTAR_CLIENTE(cTipoDocIdentificacion,cNumDocIdentificacion);
         END IF;
         --
         nCodAsegurado := OC_ASEGURADO.CODIGO_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentificacion, cNumDocIdentificacion);
         --
         IF nCodAsegurado = 0 THEN
            nCodAsegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentificacion, cNumDocIdentificacion);
         END IF;                                      
         --     
         nIdPoliza := GT_COTIZACIONES.CREAR_POLIZA(nCodCia, nCodEmpresa, nIdCotizacion, nCodCliente, nCodAsegurado);
         --
         IF X.IndAsegModelo = 'N' THEN
            UPDATE COTIZACIONES
            SET    IndAsegModelo = 'S'
            WHERE  IdCotizacion = nIdCotizacion;
         END IF;
      END LOOP;
      --
      SELECT SUM(PrimaNeta_Local)
      INTO   cPrima
      FROM   POLIZAS
      WHERE  IdPoliza = nIdPoliza;
      --
      RETURN nIdPoliza;
   END GENERA_POLIZA;

   FUNCTION PRE_EMITE_POLIZA( nCodCia           POLIZAS.CODCIA%TYPE
                            , nCodEmpresa       POLIZAS.CODEMPRESA%TYPE
                            , nIdPoliza         POLIZAS.IDPOLIZA%TYPE
                            , cIndRequierePago  VARCHAR2) RETURN CLOB IS
      CURSOR cTransaccion IS
             SELECT IdTransaccion
             FROM   DETALLE_TRANSACCION
             WHERE  CodCia        = nCodCia
               AND  CodEmpresa    = nCodEmpresa
               AND  CodSubProceso = 'POL'
               AND  Objeto        ='POLIZAS'
               AND  Valor1        = nIdPoliza;
      cFacturas      CLOB;
      nIdTransaccion TRANSACCION.IDTRANSACCION%TYPE;
     -- cIdTiposeg  VARCHAR2(50) := 'ESTACA';
   BEGIN
      OC_POLIZAS.EMITIR_POLIZA(nCodCia, nIdPoliza, nCodEmpresa);
      --
      OPEN  cTransaccion;
      FETCH cTransaccion INTO nIdTransaccion;
      CLOSE cTransaccion;                       
      --
      IF cIndRequierePago = 'S' THEN
        OC_POLIZAS.PRE_EMITE_POLIZA(nCodCia, nCodEmpresa, nIdPoliza, nIdTransaccion);
      END IF;
      
      --
      cFacturas := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_FACTURA(nCodCia, nIdPoliza);       
      --      
      RETURN cFacturas;                          
   END PRE_EMITE_POLIZA;

FUNCTION ESTADO_POLIZA(nCodCia  NUMBER, nCodEmpresa NUMBER, nCodAgente  NUMBER,  nCodAgenteSesion IN NUMBER, nNivel IN NUMBER) 
RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Email      : alopez@thonaseguros.mx                                                                                           |    
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 25/02/2021                                                                                                       |    
    | Nombre     : ESTADO_POLIZA                                                                                                    |
    | Objetivo   : Funcion que obtiene los distintos Estados de las Polizas y su descripcion por Agente dado en los Servicios WEB   |
    |              de la Plataforma Digital, los resultados son generados en formato XML.                                           |
    | Modificado : No                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Email      : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |_______________________________________________________________________________________________________________________________|
*/
xStatus     XMLTYPE;
xPrevSts    XMLTYPE; 
BEGIN
   BEGIN
      SELECT XMLELEMENT("DATA",
                           XMLAGG(XMLELEMENT("POLIZAS",  
                                                XMLELEMENT("StsPoliza", PP.StPoliza),
                                                XMLELEMENT("Descripcion", PP.descripcion                         
                                             )
                                    )
                           )
                        )
        INTO xPrevSts
        FROM (SELECT P.StsPoliza STPOLIZA, OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', P.StsPoliza) DESCRIPCION
                FROM POLIZAS    P
               WHERE P.CodCia      = nCodCia
                 AND P.CodEmpresa  = nCodEmpresa
                 AND P.cod_agente  = nCodAgente
         ) PP;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'Agente '||nCodAgente||' no existente en Base de Datos'); 
   END;
   SELECT XMLROOT (xPrevSts, VERSION '1.0" encoding="UTF-8')
     INTO xStatus
     FROM DUAL;

   RETURN xStatus;

END ESTADO_POLIZA;

FUNCTION RENOVAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPolizaRen NUMBER, cEmitePoliza VARCHAR2, cPreEmitePoliza VARCHAR2, nIdCotizacion NUMBER, cFacturas OUT CLOB) RETURN NUMBER IS
nIdPoliza         POLIZAS.IdPoliza%TYPE;
--cFacturas         CLOB;
nIdTransaccion    TRANSACCION.IdTransaccion%TYPE;
CURSOR cTransaccion IS
   SELECT IdTransaccion
     FROM   DETALLE_TRANSACCION
    WHERE  CodCia        = nCodCia
      AND  CodEmpresa    = nCodEmpresa
      AND  CodSubProceso = 'POL'
      AND  Objeto        ='POLIZAS'
      AND  Valor1        = nIdPoliza;
BEGIN
   IF NVL(cEmitePoliza,'N') = 'N' AND NVL(cPreEmitePoliza,'N') = 'S' THEN
      RAISE_APPLICATION_ERROR(-20200,'No es posible Pre Emitir cuando se indica NO emitir'); 
   ELSE
      nIdPoliza := OC_POLIZAS.RENOVAR(nCodCia, nIdPolizaRen, cEmitePoliza, 'S', 'S', nIdCotizacion);
      IF NVL(cEmitePoliza,'N') = 'S' THEN
         IF NVL(cPreEmitePoliza,'N') = 'S' THEN
            OPEN  cTransaccion;
            FETCH cTransaccion INTO nIdTransaccion;
            CLOSE cTransaccion;                       
            --
            IF NVL(cPreEmitePoliza,'N') = 'S' THEN
              OC_POLIZAS.PRE_EMITE_POLIZA(nCodCia, nCodEmpresa, nIdPoliza, nIdTransaccion);
            END IF;
            --
         END IF;
         cFacturas := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_FACTURA(nCodCia, nIdPoliza);  
      END IF;
   END IF;
   RETURN nIdPoliza; 
END RENOVAR;

END OC_POLIZAS_SERVICIOS_WEB;
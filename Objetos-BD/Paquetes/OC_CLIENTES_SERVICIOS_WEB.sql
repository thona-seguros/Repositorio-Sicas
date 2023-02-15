CREATE OR REPLACE PACKAGE OC_CLIENTES_SERVICIOS_WEB AS

FUNCTION LISTADO_CLIENTE (	nNoContratante 		    IN NUMBER,		cApePatContratante 	IN VARCHAR2,    cApeMatContratante 	    IN VARCHAR2,		 
							cNombreContratante 		IN VARCHAR2,    cTipoPersona 		IN VARCHAR2, 	cIdentificadorFiscal    IN VARCHAR2,
                            nCodEmpresa             IN NUMBER,      nCodCia             IN NUMBER,      nCodAgente              IN NUMBER,
                            nLimInferior            IN NUMBER,      nLimSuperior        IN NUMBER,      nTotRegs                OUT NUMBER,
                            nCodAgenteSesion        IN NUMBER,       nNivel             IN NUMBER
							)
RETURN XMLTYPE;

FUNCTION CONSULTA_CLIENTE ( nNoContratante  NUMBER, nCodEmpresa NUMBER, nCodCia  NUMBER,    nCodAgente  NUMBER )
RETURN XMLTYPE;

END OC_CLIENTES_SERVICIOS_WEB;

/
create or replace PACKAGE BODY OC_CLIENTES_SERVICIOS_WEB AS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 30/12/2020                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : OC_CLIENTES_SERVICIOS_WEB                                                                                        |
    | Objetivo   : Package obtiene informacion de los Clientes que cumplen con los criterios dados en los Servicios WEB de la       |
    |              Plataforma Digital, los resultados son generados en formato XML.                                                 |
    | Modificado : NO                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |_______________________________________________________________________________________________________________________________|
*/ 

FUNCTION LISTADO_CLIENTE (  nNoContratante          IN NUMBER,      cApePatContratante  IN VARCHAR2,    cApeMatContratante      IN VARCHAR2,         
                            cNombreContratante      IN VARCHAR2,    cTipoPersona        IN VARCHAR2,    cIdentificadorFiscal    IN VARCHAR2,
                            nCodEmpresa             IN NUMBER,      nCodCia             IN NUMBER,      nCodAgente              IN NUMBER,
                            nLimInferior            IN NUMBER,      nLimSuperior        IN NUMBER,      nTotRegs                OUT NUMBER,
                            nCodAgenteSesion        IN NUMBER,       nNivel             IN NUMBER
                            )
RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________    
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 30/12/2020                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : LISTADO_CLIENTE                                                                                                  |
    | Objetivo   : Funcion que obtiene un listado general de los Clientes que cumplen con los criterios dados desde la Plataforma   |
    |              Digital, con resultados paginados y tranforma la salida en formato XML.                                          |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nNoContratante          Codigo del Cliente              (Entrada)                                                   |
    |           cApePatContratante      Apellido Paterno del Cliente    (Entrada)                                                   |
    |           cApePatContratante      Apellido Paterno del Cliente    (Entrada)                                                   |
    |           cNombreContratante      Nombre del Cliente              (Entrada)                                                   |
    |           cTipoPersona            Tipo de Persona Fiscal          (Entrada)                                                   |
    |           cIdentificadorFiscal    Numero Tributario               (Entrada)                                                   |
    |           nCodEmpresa             Codigo de Empresa               (Entrada)                                                   |
    |           nCodCia                 Codigo de Compañia              (Entrada)                                                   |
    |           nCodAgente              Codigo de Empresa               (Entrada)                                                   |
    |           nLimInferior            Limite inferior de pagina       (Entrada)                                                   |
    |           nLimSuperior            Limite superior de pagina       (Entrada)                                                   |
    |           nTotRegs                Total de registros obtenidos    (Salida)                                                    |
    |_______________________________________________________________________________________________________________________________|
*/

xListadoClientes    XMLTYPE;
xPrevCtes           XMLTYPE; 

BEGIN
   BEGIN
        SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("CLIENTES",  
                                                XMLELEMENT("NoContratante",  CTE.cliente),
                                                XMLELEMENT("CodAgente", CTE.cod_agente),
                                                XMLELEMENT("Nombre", CTE.nombre),
                                                XMLELEMENT("ApePaterno", CTE.apellido_paterno),
                                                XMLELEMENT("ApeMaterno", CTE.apellido_materno),
                                                XMLELEMENT("Sexo", CTE.sexo),
                                                XMLELEMENT("EdoCivil", CTE.estadocivil),
                                                XMLELEMENT("FechaNac", CTE.fecnacimiento),
                                                XMLELEMENT("Curp", CTE.curp),
                                                XMLELEMENT("FecIngreso", CTE.fecingreso),
                                                XMLELEMENT("TipoDocIdent", CTE.tipo_doc_identificacion),
                                                XMLELEMENT("NumDocIdent", CTE.num_doc_identificacion),
                                                XMLELEMENT("TipoPersona", CTE.tipo_persona),
                                                XMLELEMENT("IdentiFiscal", CTE.num_tributario), 
                                                XMLELEMENT("TipoIdentiFiscal", CTE.tipo_id_tributaria),
                                                XMLELEMENT("Email", CTE.email),
                                                XMLELEMENT("TelMovil", CTE.telmovil),
                                                XMLELEMENT("Pais", CTE.pais),
                                                XMLELEMENT("Estado", CTE.estado),
                                                XMLELEMENT("Ciudad", CTE.ciudad),
                                                XMLELEMENT("MunicAlcandia", CTE.Municipio_Alcaldia),
                                                XMLELEMENT("Colonia", CTE.colonia),        
                                                XMLELEMENT("CodPostal", CTE.codigo_postal),
                                                XMLELEMENT("Nacionalidad", CTE.nacionalidad)
                                              )
                                  )
                         )
        INTO    xPrevCtes                         
        FROM    (SELECT CCC.codcliente CLIENTE,
                        CCC.cod_agente,
                        CCC.nombre,
                        CCC.apellido_paterno,
                        CCC.apellido_materno,
                        CCC.sexo,
                        CCC.estadocivil,
                        CCC.fecnacimiento,
                        CCC.curp,
                        CCC.fecingreso,
                        CCC.tipo_doc_identificacion,
                        CCC.num_doc_identificacion,
                        CCC.tipo_persona,
                        CCC.num_tributario, 
                        CCC.tipo_id_tributaria,
                        --PNJ.codpaisres, 
                        CCC.email,
                        CCC.telmovil,
                        CCC.PAIS,
                        --PNJ.codprovres,
                        CCC.ESTADO,
                        --PNJ.coddistres,
                        CCC.CIUDAD,                
                        --PNJ.codcorrres, -- Municipio y/o Alcaldia
                        CCC.MUNICIPIO_ALCALDIA,
                       -- PNJ.codcolres,
                        CCC.COLONIA,        
                        --PNJ.zipres, 
                        CCC.CODIGO_POSTAL,
                        CCC.nacionalidad
                        ,CCC.registro
            FROM       (SELECT  CC.*,
                                ROWNUM AS Registro
                        FROM    (SELECT DISTINCT C.codcliente,
                                        AP.cod_agente,
                                        PNJ.nombre,
                                        PNJ.apellido_paterno,
                                        PNJ.apellido_materno,
                                        PNJ.sexo,           --> Descripcion? ... Hay 12 valores diferentes (Sin incluir Nulos) !!!
                                        PNJ.estadocivil,    --> Descripcion? ... Hay  6 valores diferentes (Sin incluir Nulos) !!!
                                        PNJ.fecnacimiento,
                                        PNJ.curp,
                                        PNJ.fecingreso,
                                        PNJ.tipo_doc_identificacion,
                                        PNJ.num_doc_identificacion,
                                        PNJ.tipo_persona,
                                        PNJ.num_tributario, 
                                        PNJ.tipo_id_tributaria,
                                        --PNJ.codpaisres, 
                                        PNJ.email,
                                        PNJ.telmovil,
                                        OC_PAIS.NOMBRE_PAIS(PNJ.codpaisres) PAIS,
                                        --PNJ.codprovres,
                                         oc_provincia.nombre_provincia(PNJ.codpaisres, PNJ.codprovres) ESTADO,
                                        --PNJ.coddistres,
                                        OC_DISTRITO.NOMBRE_DISTRITO(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres) CIUDAD,
                                        --PNJ.codcorrres, -- Municipio y/o Alcaldia
                                        OC_CORREGIMIENTO.nombre_corregimiento(PNJ.codpaisres,PNJ.codprovres,PNJ.coddistres,PNJ.codcorrres) MUNICIPIO_ALCALDIA,
                                       -- PNJ.codcolres,
                                        OC_COLONIA.DESCRIPCION_COLONIA(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres, PNJ.codcorrres, PNJ.codposres, PNJ.codcolres) COLONIA,        
                                        --PNJ.zipres, 
                                        PNJ.codposres CODIGO_POSTAL,
                                        PNJ.nacionalidad
                                FROM    AGENTE_POLIZA               AP,
                                        POLIZAS                     P,
                                        PERSONA_NATURAL_JURIDICA    PNJ,
                                        CLIENTES                    C,
                                        (SELECT DISTINCT C.CodCia, C.Cod_Agente, C.IdPoliza, D.Cod_Agente_Distr,
                                                OC_AGENTES.NIVEL_AGENTE(C.CodCia, c.Cod_Agente ) Nivel
                                           FROM COMISIONES C, AGENTES_DISTRIBUCION_POLIZA D,
                                                AGENTE_POLIZA P
                                          WHERE C.CodCia         = nCodCia
                                            AND C.Cod_Agente     = D.Cod_Agente_Distr
                                            AND C.IdPoliza       = D.IdPoliza
                                            AND D.Cod_Agente     = P.Cod_Agente
                                            AND C.IdPoliza       = P.IdPoliza
                                            AND P.Ind_Principal  = 'S') D
                                WHERE   AP.idpoliza  = P.idpoliza
                                AND     AP.codcia    = P.codcia
                                AND     P.codcliente = C.codcliente
                                AND     C.tipo_doc_identificacion   = PNJ.tipo_doc_identificacion
                                AND     C.num_doc_identificacion    = PNJ.num_doc_identificacion
                                AND     C.codcliente                = NVL(nNoContratante, C.codcliente)
                                --AND     PNJ.tipo_persona            = NVL(cTipoPersona, PNJ.tipo_persona)
                                AND     (cTipoPersona IS NULL OR PNJ.tipo_persona = cTipoPersona)
                                AND     PNJ.num_tributario          = NVL(cIdentificadorFiscal,PNJ.num_tributario)
                                AND     (cApePatContratante IS NULL OR PNJ.apellido_paterno = cApePatContratante)
                                AND     (cApeMatContratante IS NULL OR PNJ.apellido_materno = cApeMatContratante)
                                --AND     ( PNJ.apellido_paterno = NVL(cApePatContratante, PNJ.apellido_paterno) OR NVL(PNJ.apellido_paterno,'NULO') = NVL2(cApePatContratante, PNJ.apellido_paterno, 'NULO') )
                                --AND     ( PNJ.apellido_materno = NVL(cApeMatContratante, PNJ.apellido_materno) OR NVL(PNJ.apellido_materno,'NULO') = NVL2(cApeMatContratante, PNJ.apellido_materno, 'NULO') )
                                AND     (cNombreContratante IS NULL OR PNJ.nombre = cNombreContratante)
                                --AND     PNJ.nombre = NVL(cNombreContratante, PNJ.nombre)
                                AND     P.codempresa = nCodEmpresa
                                AND     AP.codcia    = nCodCia         
                                AND     AP.Ind_Principal   = 'S'
                                AND     AP.cod_agente IN (SELECT   A.cod_agente
                                                            FROM    AGENTES A
                                                            CONNECT BY PRIOR A.cod_agente = A.cod_agente_jefe
                                                            AND     A.est_agente  = 'ACT'
                                                            AND     A.codcia      = nCodCia
                                                            AND     A.codempresa  = nCodEmpresa
                                                            START WITH A.cod_agente  = nCodAgente
                                                            )
                                 AND AP.IdPoliza   = D.IdPoliza
                                 AND AP.CodCia     = D.CodCia
                                 AND D.Cod_Agente  = nCodAgenteSesion
                                 AND D.Nivel       = nNivel
                                ORDER BY AP.cod_agente, C.codcliente
                                ) CC
                        ) CCC
                WHERE   CCC.registro BETWEEN nLimInferior AND nLimSuperior
                ORDER BY CCC.registro                
                ) CTE ;

        --> Total registros obtenidos
        SELECT  NVL(COUNT(*),0) TOTAL  --DISTINCT CC.codcliente CLIENTE,                            
        INTO    nTotRegs 
        FROM    (SELECT CCC.codcliente CLIENTE,
                        CCC.cod_agente,
                        CCC.nombre,
                        CCC.apellido_paterno,
                        CCC.apellido_materno,
                        CCC.sexo,
                        CCC.estadocivil,
                        CCC.fecnacimiento,
                        CCC.curp,
                        CCC.fecingreso,
                        CCC.tipo_doc_identificacion,
                        CCC.num_doc_identificacion,
                        CCC.tipo_persona,
                        CCC.num_tributario, 
                        CCC.tipo_id_tributaria,
                        --PNJ.codpaisres, 
                        CCC.email,
                        CCC.telmovil,
                        CCC.PAIS,
                        --PNJ.codprovres,
                        CCC.ESTADO,
                        --PNJ.coddistres,
                        CCC.CIUDAD,                
                        --PNJ.codcorrres, -- Municipio y/o Alcaldia
                        CCC.MUNICIPIO_ALCALDIA,
                       -- PNJ.codcolres,
                        CCC.COLONIA,        
                        --PNJ.zipres, 
                        CCC.CODIGO_POSTAL,
                        CCC.nacionalidad
                        ,CCC.registro
            FROM       (SELECT  CC.*,
                                ROWNUM AS Registro
                        FROM    (SELECT DISTINCT C.codcliente,
                                        AP.cod_agente,
                                        PNJ.nombre,
                                        PNJ.apellido_paterno,
                                        PNJ.apellido_materno,
                                        PNJ.sexo,           --> Descripcion? ... Hay 12 valores diferentes (Sin incluir Nulos) !!!
                                        PNJ.estadocivil,    --> Descripcion? ... Hay  6 valores diferentes (Sin incluir Nulos) !!!
                                        PNJ.fecnacimiento,
                                        PNJ.curp,
                                        PNJ.fecingreso,
                                        PNJ.tipo_doc_identificacion,
                                        PNJ.num_doc_identificacion,
                                        PNJ.tipo_persona,
                                        PNJ.num_tributario, 
                                        PNJ.tipo_id_tributaria,
                                        --PNJ.codpaisres, 
                                        PNJ.email,
                                        PNJ.telmovil,
                                        OC_PAIS.NOMBRE_PAIS(PNJ.codpaisres) PAIS,
                                        --PNJ.codprovres,
                                         oc_provincia.nombre_provincia(PNJ.codpaisres, PNJ.codprovres) ESTADO,
                                        --PNJ.coddistres,
                                        OC_DISTRITO.NOMBRE_DISTRITO(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres) CIUDAD,
                                        --PNJ.codcorrres, -- Municipio y/o Alcaldia
                                        OC_CORREGIMIENTO.nombre_corregimiento(PNJ.codpaisres,PNJ.codprovres,PNJ.coddistres,PNJ.codcorrres) MUNICIPIO_ALCALDIA,
                                       -- PNJ.codcolres,
                                        OC_COLONIA.DESCRIPCION_COLONIA(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres, PNJ.codcorrres, PNJ.codposres, PNJ.codcolres) COLONIA,        
                                        --PNJ.zipres, 
                                        PNJ.codposres CODIGO_POSTAL,
                                        PNJ.nacionalidad
                                FROM    AGENTE_POLIZA               AP,
                                        POLIZAS                     P,
                                        PERSONA_NATURAL_JURIDICA    PNJ,
                                        CLIENTES                    C,
                                        (SELECT DISTINCT C.CodCia, C.Cod_Agente, C.IdPoliza, D.Cod_Agente_Distr,
                                                OC_AGENTES.NIVEL_AGENTE(C.CodCia, c.Cod_Agente ) Nivel
                                           FROM COMISIONES C, AGENTES_DISTRIBUCION_POLIZA D,
                                                AGENTE_POLIZA P
                                          WHERE C.CodCia         = nCodCia
                                            AND C.Cod_Agente     = D.Cod_Agente_Distr
                                            AND C.IdPoliza       = D.IdPoliza
                                            AND D.Cod_Agente     = P.Cod_Agente
                                            AND C.IdPoliza       = P.IdPoliza
                                            AND P.Ind_Principal  = 'S') D
                                WHERE   AP.idpoliza  = P.idpoliza
                                AND     AP.codcia    = P.codcia
                                AND     P.codcliente = C.codcliente
                                AND     C.tipo_doc_identificacion   = PNJ.tipo_doc_identificacion
                                AND     C.num_doc_identificacion    = PNJ.num_doc_identificacion
                                AND     C.codcliente                = NVL(nNoContratante, C.codcliente)
                                --AND     PNJ.tipo_persona            = NVL(:cTipoPersona, PNJ.tipo_persona)
                                AND     (cTipoPersona IS NULL OR PNJ.tipo_persona = cTipoPersona)
                                AND     PNJ.num_tributario          = NVL(cIdentificadorFiscal,PNJ.num_tributario)                                
                                AND     (cApePatContratante IS NULL OR PNJ.apellido_paterno = cApePatContratante)
                                AND     (cApeMatContratante IS NULL OR PNJ.apellido_materno = cApeMatContratante)
                                --AND     (PNJ.apellido_paterno = NVL(cApePatContratante, PNJ.apellido_paterno) OR NVL(PNJ.apellido_paterno,'NULO') = NVL2(cApePatContratante, PNJ.apellido_paterno, 'NULO'))
                                --AND     (PNJ.apellido_materno = NVL(cApeMatContratante, PNJ.apellido_materno) OR NVL(PNJ.apellido_materno,'NULO') = NVL2(cApeMatContratante, PNJ.apellido_materno, 'NULO'))
                                AND     (cNombreContratante IS NULL OR PNJ.nombre = cNombreContratante)
                                --AND     PNJ.nombre = NVL(cNombreContratante, PNJ.nombre)
                                AND     P.codempresa = nCodEmpresa
                                AND     AP.codcia    = nCodCia         
                                AND     AP.Ind_Principal   = 'S'
                                AND     AP.cod_agente IN (SELECT   A.cod_agente
                                                            FROM    AGENTES A
                                                            CONNECT BY PRIOR A.cod_agente = A.cod_agente_jefe
                                                            AND     A.est_agente  = 'ACT'
                                                            AND     A.codcia      = nCodCia
                                                            AND     A.codempresa  = nCodEmpresa
                                                            START WITH A.cod_agente  = nCodAgente
                                                            )
                                 AND AP.IdPoliza   = D.IdPoliza
                                 AND AP.CodCia     = D.CodCia
                                 AND D.Cod_Agente  = nCodAgenteSesion
                                 AND D.Nivel       = nNivel
                                ORDER BY AP.cod_agente, C.codcliente
                                ) CC
                        ) CCC
                --WHERE   CCC.registro BETWEEN nLimInferior AND nLimSuperior
                ORDER BY CCC.registro                
                ); 
   END;

   SELECT XMLROOT (xPrevCtes, VERSION '1.0" encoding="UTF-8')
     INTO xListadoClientes
     FROM DUAL;
   RETURN xListadoClientes;

END LISTADO_CLIENTE;


FUNCTION CONSULTA_CLIENTE ( nNoContratante  NUMBER,     nCodEmpresa NUMBER,     nCodCia  NUMBER,     nCodAgente  NUMBER )
    RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________    
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 11/12/2020                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : CONSULTA_CLIENTE                                                                                                 |
    | Objetivo   : Funcion que obtiene la informacion detallada del Cliente dado desde la Plataforma Digital y tranforma la salida  |
    |              en formato XML.                                                                                                  |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nNoContratante          Codigo del Cliente              (Entrada)                                                   |
    |           nCodEmpresa             Codigo de Empresa               (Entrada)                                                   |
    |           nodCia                  Codigo de Compañia              (Entrada)                                                   |
    |           nCodAgente              Codigo de Empresa               (Entrada)                                                   |
    |_______________________________________________________________________________________________________________________________|
*/
xCliente    XMLTYPE;
xPrevCte    XMLTYPE; 
BEGIN
   BEGIN
        SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("CLIENTES",  
                                                XMLELEMENT("NoContratante", C.codcliente),
                                                XMLELEMENT("CodAgente", AP.cod_agente),
                                                XMLELEMENT("Principal", DECODE(AP.ind_principal,'S','Si','No')),
                                                XMLELEMENT("Nombre", PNJ.nombre),
                                                XMLELEMENT("ApePaterno", PNJ.apellido_paterno),
                                                XMLELEMENT("ApeMaterno", PNJ.apellido_materno),
                                                XMLELEMENT("Sexo",PNJ. sexo),               --> Descripcion? ... Hay 12 valores diferentes (Sin incluir Nulos) !!!
                                                XMLELEMENT("EdoCivil", PNJ.estadocivil),    --> Descripcion? ... Hay  6 valores diferentes (Sin incluir Nulos) !!!
                                                XMLELEMENT("FechaNac", PNJ.fecnacimiento),
                                                XMLELEMENT("Curp", PNJ.curp),
                                                XMLELEMENT("FecIngreso", PNJ.fecingreso),
                                                XMLELEMENT("TipoDocIdent", PNJ.tipo_doc_identificacion),
                                                XMLELEMENT("NumDocIdent", PNJ.num_doc_identificacion),
                                                XMLELEMENT("TipoPersona", PNJ.tipo_persona),
                                                XMLELEMENT("IdentiFiscal", PNJ.num_tributario), 
                                                XMLELEMENT("TipoIdentiFiscal", PNJ.tipo_id_tributaria), 
                                                XMLELEMENT("DirecRes", PNJ.DirecRes),
                                                XMLELEMENT("Pais", OC_PAIS.NOMBRE_PAIS(PNJ.codpaisres)),
                                                XMLELEMENT("Estado", OC_PROVINCIA.NOMBRE_PROVINCIA(PNJ.codpaisres, PNJ.codprovres)),
                                                XMLELEMENT("Ciudad", OC_DISTRITO.NOMBRE_DISTRITO(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres)),
                                                XMLELEMENT("MunicAlcandia", OC_CORREGIMIENTO.NOMBRE_CORREGIMIENTO(PNJ.codpaisres,PNJ.codprovres,PNJ.coddistres,PNJ.codcorrres)),
                                                XMLELEMENT("Colonia", OC_COLONIA.DESCRIPCION_COLONIA(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres, PNJ.codcorrres, PNJ.codposres, PNJ.codcolres)),     
                                                XMLELEMENT("CodPostal", PNJ.codposres),
                                                XMLELEMENT("ZipRes", PNJ.zipres),
                                                XMLELEMENT("TelRes", PNJ.telres),
                                                XMLELEMENT("DirecOfi", PNJ.direcofi),
                                                XMLELEMENT("CodPaisOfi", PNJ.codpaisofi),
                                                XMLELEMENT("CodProvOfi", PNJ.codprovofi),
                                                XMLELEMENT("CodDistOfi", PNJ.coddistofi),
                                                XMLELEMENT("CodCorrOfi", PNJ.codcorrofi),
                                                XMLELEMENT("ZipOfi", PNJ.zipofi),
                                                XMLELEMENT("TelOfi", PNJ.telofi),
                                                XMLELEMENT("Email", PNJ.email),
                                                XMLELEMENT("FecSts", PNJ.fecsts),
                                                XMLELEMENT("Cedula", PNJ.cedula),
                                                XMLELEMENT("CodigoZip", PNJ.codigozip),
                                                XMLELEMENT("CodPosOfi", PNJ.codposofi),
                                                XMLELEMENT("TelMovil", PNJ.telmovil),
                                                XMLELEMENT("CodColRes", PNJ.codcolres),
                                                XMLELEMENT("LadaTelRes", PNJ.ladatelres),
                                                XMLELEMENT("LadaTelMovil", PNJ.ladatelmovil),
                                                XMLELEMENT("CodActividad", PNJ.codactividad),
                                                XMLELEMENT("NumInterior", PNJ.numinterior),
                                                XMLELEMENT("NumExterior", PNJ.numexterior),
                                                XMLELEMENT("AuxContable", PNJ.auxcontable),
                                                XMLELEMENT("NombreComercial", PNJ.nombrecomercial),
                                                XMLELEMENT("CodListaRef", PNJ.codlistaref),
                                                XMLELEMENT("FecListaRef", PNJ.feclistaref),
                                                XMLELEMENT("Nacionalidad", PNJ.nacionalidad)
                                              )
                                  )
                         )
        INTO    xPrevCte
        FROM    AGENTE_POLIZA               AP,
                POLIZAS                     P,
                PERSONA_NATURAL_JURIDICA    PNJ,
                CLIENTES                    C    
        WHERE   AP.idpoliza  = P.idpoliza
        AND     AP.codcia    = P.codcia
        AND     P.codcliente = C.codcliente
        AND     PNJ.tipo_doc_identificacion = C.tipo_doc_identificacion
        AND     PNJ.num_doc_identificacion  = C.num_doc_identificacion
        AND     P.codempresa = nCodEmpresa
        AND     AP.codcia    = nCodCia
        AND     C.codcliente = nNoContratante
        AND     AP.cod_agente IN (  SELECT  A.cod_agente
                                    FROM    AGENTES A
                                    CONNECT BY PRIOR A.cod_agente = A.cod_agente_jefe
                                    AND     A.est_agente    = 'ACT'
                                    AND     A.codcia        = nCodCia
                                    AND     A.codempresa    = nCodEmpresa
                                    START WITH A.cod_agente = nCodAgente  --> Origen de Jerarquia (desde donde empiezo)
                                    );

      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'El Cliente '||nNoContratante||' no existente en Base de Datos.'); 
   END;

   SELECT   XMLROOT (xPrevCte, VERSION '1.0" encoding="UTF-8')
   INTO     xCliente
   FROM     DUAL;

   RETURN xCliente;

END CONSULTA_CLIENTE;

END OC_CLIENTES_SERVICIOS_WEB;
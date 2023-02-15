CREATE OR REPLACE PACKAGE          OC_ASEGURADOS_SERVICIOS_WEB AS

FUNCTION LISTADO_ASEGURADO (nCodCia         IN NUMBER,  nCodEmpresa     IN NUMBER, nIdPoliza    IN NUMBER,  nCodAgente  IN NUMBER,
                            nLimInferior    IN NUMBER,  nLimSuperior    IN NUMBER, nTotRegs     OUT NUMBER
							)
RETURN XMLTYPE;

FUNCTION CONSULTA_ASEGURADO (nCodCia  NUMBER,  nCodEmpresa NUMBER, nNoAsegurado  NUMBER)
RETURN XMLTYPE;


END OC_ASEGURADOS_SERVICIOS_WEB;
/
create or replace PACKAGE BODY          OC_ASEGURADOS_SERVICIOS_WEB AS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 10/01/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : OC_ASEGURADOS_SERVICIOS_WEB                                                                                      |
    | Objetivo   : Package obtiene informacion de los Asegurados que cumplen con los criterios dados en los Servicios WEB de la     |
    |              Plataforma Digital, los resultados son generados en formato XML.                                                 |
    | Modificado : NO                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |_______________________________________________________________________________________________________________________________|
*/ 

FUNCTION LISTADO_ASEGURADO (nCodCia         IN NUMBER,  nCodEmpresa     IN NUMBER, nIdPoliza  IN NUMBER,  nCodAgente  IN NUMBER,
                            nLimInferior    IN NUMBER,  nLimSuperior    IN NUMBER, nTotRegs OUT NUMBER
                            )
    RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________    
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 10/01/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : LISTADO_ASEGURADO                                                                                                |
    | Objetivo   : Funcion que obtiene un listado general de los Asegurados que cumplen con los criterios dados desde la Plataforma |
    |              Digital, con resultados paginados y tranforma la salida en formato XML.                                          |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia                 Codigo de Compañia              (Entrada)                                                   |
    |           nCodEmpresa             Codigo de Empresa               (Entrada)                                                   |
    |           nIdPoliza               ID de la Póliza                 (Entrada)                                                   |
    |           nCodAgente              Codigo de Empresa               (Entrada)                                                   |
    |           nLimInferior            Limite inferior de pagina       (Entrada)                                                   |
    |           nLimSuperior            Limite superior de pagina       (Entrada)                                                   |
    |           nTotRegs                Total de registros obtenidos    (Salida)                                                    |
    |_______________________________________________________________________________________________________________________________|
*/

xListadoAsegurados  XMLTYPE;
xPrevAsegs          XMLTYPE; 

BEGIN
   BEGIN
        SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("ASEGURADOS",
                                                XMLELEMENT("Asegurado", asegurado),
                                                XMLELEMENT("Agente", agente),
                                                XMLELEMENT("Principal", principal),
                                                XMLELEMENT("IDPoliza", idpoliza),
                                                XMLELEMENT("FecIniVig", fecinivig),
                                                XMLELEMENT("FecFinVig", fecfinvig),
                                                XMLELEMENT("Nombre", nombre),
                                                XMLELEMENT("ApellidoPaterno", apellido_paterno),
                                                XMLELEMENT("ApellidoMaterno", apellido_materno),
                                                XMLELEMENT("Edad", edad),
                                                XMLELEMENT("Sexo", sexo),
                                                XMLELEMENT("EdoCivil", estadocivil),
                                                XMLELEMENT("FecNacimiento", fecnacimiento),
                                                XMLELEMENT("Curp", curp),
                                                XMLELEMENT("FecIngreso", fecingreso),
                                                XMLELEMENT("TipoDocIdentificacion", tipo_doc_identificacion),
                                                XMLELEMENT("NumDocIdentificacion", num_doc_identificacion),
                                                XMLELEMENT("TipoPersona", tipo_persona),
                                                XMLELEMENT("NumTributario", num_tributario),
                                                XMLELEMENT("TipoIDTributaria", tipo_id_tributaria),
                                                XMLELEMENT("TipoSeguro", tipo_seguro),
                                                XMLELEMENT("NomTipoSeguro", desc_tipo_seguro),
                                                XMLELEMENT("TipoPoliza", tipo_poliza),
                                                XMLELEMENT("Pais", pais),
                                                XMLELEMENT("Estado", estado),
                                                XMLELEMENT("Ciudad", ciudad),
                                                XMLELEMENT("Municipio_alcaldia", municipio_alcaldia),
                                                XMLELEMENT("Colonia", colonia),
                                                XMLELEMENT("C.P.", codposres),
                                                XMLELEMENT("Nacionalidad", nacionalidad),
                                                XMLELEMENT("SumaAsegurada", SumaAsegurada),
                                                XMLELEMENT("PrimaNeta", PrimaNeta)
                                              )
                                  )
                         )
        INTO    xPrevAsegs                
        FROM    (SELECT asegurado,
                        agente,
                        principal,
                        idpoliza,
                        fecinivig,
                        fecfinvig,
                        nombre,
                        apellido_paterno,
                        apellido_materno,
                        edad,
                        sexo,
                        estadocivil,
                        fecnacimiento,
                        curp,
                        fecingreso,
                        tipo_doc_identificacion,
                        num_doc_identificacion,
                        tipo_persona,
                        num_tributario,
                        tipo_id_tributaria,
                        tipo_seguro,
                        desc_tipo_seguro,
                        tipo_poliza,
                        pais,
                        estado,
                        ciudad,
                        municipio_alcaldia,
                        colonia,
                        codposres,
                        nacionalidad,
                        SumaAsegurada,
                        PrimaNeta
                FROM    (SELECT     AA.asegurado,
                                    AA.agente,
                                    AA.principal,
                                    AA.idpoliza,
                                    AA.fecinivig,
                                    AA.fecfinvig,
                                    AA.nombre,
                                    AA.apellido_paterno,
                                    AA.apellido_materno,
                                    AA.edad,
                                    AA.sexo,
                                    AA.estadocivil,
                                    AA.fecnacimiento,
                                    AA.curp,
                                    AA.fecingreso,
                                    AA.tipo_doc_identificacion,
                                    AA.num_doc_identificacion,
                                    AA.tipo_persona,
                                    AA.num_tributario,
                                    AA.tipo_id_tributaria,
                                    AA.tipo_seguro,
                                    AA.desc_tipo_seguro,
                                    AA.tipo_poliza,
                                    AA.pais,
                                    AA.estado,
                                    AA.ciudad,
                                    AA.municipio_alcaldia,
                                    AA.colonia,
                                    AA.codposres,
                                    AA.nacionalidad,
                                    AA.SumaAsegurada,
                                    AA.PrimaNeta,
                                    ROW_NUMBER() OVER (ORDER BY idpoliza) REGISTRO
                        FROM        (   SELECT  A.cod_asegurado                         ASEGURADO, 
                                                AP.cod_agente                           AGENTE, 
                                                DECODE(AP.ind_principal,'S','Si','No')  PRINCIPAL, 
                                                P.idpoliza,
                                                DP.fecinivig, 
                                                DP.fecfinvig, 
                                                PNJ.nombre, 
                                                PNJ.apellido_paterno, 
                                                PNJ.apellido_materno,
                                                OC_ASEGURADO.EDAD_ASEGURADO(A.codcia, A.codempresa, A.cod_asegurado, TRUNC(SYSDATE)) EDAD,
                                                PNJ.sexo, 
                                                PNJ.estadocivil, 
                                                PNJ.fecnacimiento,
                                                PNJ.curp,
                                                PNJ.fecingreso,        
                                                PNJ.tipo_doc_identificacion,
                                                PNJ.num_doc_identificacion,
                                                PNJ.tipo_persona,
                                                PNJ.num_tributario, 
                                                PNJ.tipo_id_tributaria,
                                                DP.idtiposeg                        TIPO_SEGURO,
                                                OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(A.codcia, A.codempresa, DP.idtiposeg) DESC_TIPO_SEGURO,
                                                'Individual'                        TIPO_POLIZA,
                                                OC_PAIS.NOMBRE_PAIS(PNJ.codpaisres) PAIS,
                                                OC_PROVINCIA.NOMBRE_PROVINCIA(PNJ.codpaisres, PNJ.codprovres) ESTADO,
                                                OC_DISTRITO.NOMBRE_DISTRITO(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres) CIUDAD,
                                                OC_CORREGIMIENTO.nombre_corregimiento(PNJ.codpaisres,PNJ.codprovres,PNJ.coddistres,PNJ.codcorrres) MUNICIPIO_ALCALDIA,
                                                OC_COLONIA.DESCRIPCION_COLONIA(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres, PNJ.codcorrres, PNJ.codposres, PNJ.codcolres) COLONIA,        
                                                PNJ.codposres,
                                                PNJ.nacionalidad,
                                                DP.Suma_Aseg_Local SumaAsegurada,
                                                DP.Prima_Local PrimaNeta
                                         FROM   ASEGURADO                   A,
                                                PERSONA_NATURAL_JURIDICA    PNJ,
                                                AGENTE_POLIZA               AP,
                                                POLIZAS                     P,
                                                DETALLE_POLIZA              DP   
                                         WHERE  P.idpoliza      = DP.idpoliza
                                         AND    P.codcia        = DP.codcia
                                         AND    P.codempresa    = DP.codempresa
                                         AND    A.cod_asegurado = DP.cod_asegurado
                                         AND    A.codcia        = DP.codcia
                                         AND    A.codempresa    = DP.codempresa
                                         AND    A.codcia        = P.codcia
                                         AND    A.codempresa    = P.codempresa
                                         AND    A.tipo_doc_identificacion   = PNJ.tipo_doc_identificacion
                                         AND    A.num_doc_identificacion    = PNJ.num_doc_identificacion  
                                         AND    A.codcia        = AP.codcia
                                         AND    P.idpoliza      = AP.idpoliza
                                         AND    P.codcia        = AP.codcia
                                         AND    AP.idpoliza     = DP.idpoliza
                                         AND    AP.codcia       = DP.codcia
                                         AND    OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(A.codcia, P.idpoliza, DP.idetpol, A.cod_asegurado) = 'N'
                                         AND    P.codcia         = nCodCia
                                         AND    P.codempresa     = nCodEmpresa
                                         AND    P.idpoliza       = nIdPoliza
                                         AND    AP.cod_agente    = nCodAgente
                                         --AND    A.cod_asegurado  = NVL(:nContratante, A.cod_asegurado)
                                         --AND    P.fecinivig >= :dFechaIni
                                         --AND    P.fecfinvig <= :dFechaFin
                                        UNION
                                        -- Colectiva
                                         SELECT AC.cod_asegurado                        ASEGURADO, 
                                                AP.cod_agente                           AGENTE, 
                                                DECODE(AP.ind_principal,'S','Si','No')  PRINCIPAL, 
                                                P.idpoliza,
                                                DP.fecinivig, 
                                                DP.fecfinvig, 
                                                PNJ.nombre, 
                                                PNJ.apellido_paterno, 
                                                PNJ.apellido_materno,
                                                OC_ASEGURADO.EDAD_ASEGURADO(P.codcia, P.codempresa, AC.cod_asegurado, TRUNC(SYSDATE)) EDAD,
                                                PNJ.sexo, 
                                                PNJ.estadocivil, 
                                                PNJ.fecnacimiento,
                                                PNJ.curp,
                                                PNJ.fecingreso,        
                                                PNJ.tipo_doc_identificacion,
                                                PNJ.num_doc_identificacion,
                                                PNJ.tipo_persona,
                                                PNJ.num_tributario, 
                                                PNJ.tipo_id_tributaria,
                                                DP.idtiposeg                            TIPO_SEGURO,
                                                OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(P.codcia, P.codempresa, DP.idtiposeg) DESC_TIPO_SEGURO,
                                                'Colectiva'                             TIPO_POLIZA,
                                                OC_PAIS.NOMBRE_PAIS(PNJ.codpaisres)     PAIS,
                                                OC_PROVINCIA.NOMBRE_PROVINCIA(PNJ.codpaisres, PNJ.codprovres) ESTADO,
                                                OC_DISTRITO.NOMBRE_DISTRITO(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres) CIUDAD,
                                                OC_CORREGIMIENTO.nombre_corregimiento(PNJ.codpaisres,PNJ.codprovres,PNJ.coddistres,PNJ.codcorrres) MUNICIPIO_ALCALDIA,
                                                OC_COLONIA.DESCRIPCION_COLONIA(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres, PNJ.codcorrres, PNJ.codposres, PNJ.codcolres) COLONIA,        
                                                PNJ.codposres,
                                                PNJ.nacionalidad,
                                                AC.SumaAseg SumaAsegurada,
                                                AC.PrimaNeta
                                         FROM   ASEGURADO_CERTIFICADO       AC,
                                                ASEGURADO                   A,
                                                PERSONA_NATURAL_JURIDICA    PNJ,
                                                AGENTE_POLIZA               AP,
                                                POLIZAS                     P,
                                                DETALLE_POLIZA              DP   
                                         WHERE   P.idpoliza       = DP.idpoliza
                                         AND     P.codcia         = DP.codcia
                                         AND     P.codempresa     = DP.codempresa
                                         AND     AC.idpoliza      = P.idpoliza
                                         AND     AC.cod_asegurado = DP.cod_asegurado
                                         AND     AC.codcia        = DP.codcia
                                         AND     AC.idetpol       = DP.idetpol
                                         AND     A.cod_asegurado  = DP.cod_asegurado
                                         AND     A.codcia         = DP.codcia
                                         AND     A.codempresa     = DP.codempresa
                                         AND     A.codcia         = P.codcia
                                         AND     A.codempresa     = P.codempresa
                                         AND     A.tipo_doc_identificacion   = PNJ.tipo_doc_identificacion
                                         AND     A.num_doc_identificacion    = PNJ.num_doc_identificacion  
                                         AND     A.codcia         = AP.codcia
                                         AND     AC.codcia        = AP.codcia
                                         AND     AC.idpoliza      = AP.idpoliza
                                         AND     P.idpoliza       = AP.idpoliza
                                         AND     P.codcia         = AP.codcia
                                         AND     AP.idpoliza      = DP.idpoliza
                                         AND     AP.codcia        = DP.codcia
                                         AND     P.codcia         = nCodCia
                                         AND     P.codempresa     = nCodEmpresa
                                         AND     P.idpoliza       = nIdPoliza
                                         AND     AP.cod_agente    = nCodAgente      -- NVL(:nCodAgente, AP.cod_agente)
                                         --AND     AC.cod_asegurado =  :nContratante  -- NVL(:nContratante, AC.cod_asegurado) --
                                         --AND     P.fecinivig >= :dFechaIni
                                         --AND     P.fecfinvig <= :dFechaFin
                                    ) AA
                        ORDER BY idpoliza
                        ) ASEG
        WHERE   ASEG.registro BETWEEN nLimInferior AND nLimSuperior);

        --> Total registros obtenidos
        SELECT  NVL(COUNT(*),0) TOTAL                            
        INTO    nTotRegs 
        FROM    (SELECT A.cod_asegurado                                 ASEGURADO, 
                        AP.cod_agente                           AGENTE, 
                        DECODE(AP.ind_principal,'S','Si','No')  PRINCIPAL, 
                        P.idpoliza,
                        DP.fecinivig, 
                        DP.fecfinvig, 
                        PNJ.nombre, 
                        PNJ.apellido_paterno, 
                        PNJ.apellido_materno,
                        OC_ASEGURADO.EDAD_ASEGURADO(A.codcia, A.codempresa, A.cod_asegurado, TRUNC(SYSDATE)) EDAD,
                        PNJ.sexo, 
                        PNJ.estadocivil, 
                        PNJ.fecnacimiento,
                        PNJ.curp,
                        PNJ.fecingreso,        
                        PNJ.tipo_doc_identificacion,
                        PNJ.num_doc_identificacion,
                        PNJ.tipo_persona,
                        PNJ.num_tributario, 
                        PNJ.tipo_id_tributaria,
                        DP.idtiposeg                            TIPO_SEGURO,
                        OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(A.codcia, A.codempresa, DP.idtiposeg) DESC_TIPO_SEGURO,
                        'Individual'                            TIPO_POLIZA,
                        OC_PAIS.NOMBRE_PAIS(PNJ.codpaisres)     PAIS,
                        OC_PROVINCIA.NOMBRE_PROVINCIA(PNJ.codpaisres, PNJ.codprovres) ESTADO,
                        OC_DISTRITO.NOMBRE_DISTRITO(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres) CIUDAD,
                        OC_CORREGIMIENTO.nombre_corregimiento(PNJ.codpaisres,PNJ.codprovres,PNJ.coddistres,PNJ.codcorrres) MUNICIPIO_ALCALDIA,
                        OC_COLONIA.DESCRIPCION_COLONIA(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres, PNJ.codcorrres, PNJ.codposres, PNJ.codcolres) COLONIA,        
                        PNJ.codposres,
                        PNJ.nacionalidad
                 FROM   ASEGURADO                   A,
                        PERSONA_NATURAL_JURIDICA    PNJ,
                        AGENTE_POLIZA               AP,
                        POLIZAS                     P,
                        DETALLE_POLIZA              DP   
                 WHERE  P.idpoliza      = DP.idpoliza
                 AND    P.codcia        = DP.codcia
                 AND    P.codempresa    = DP.codempresa
                 AND    A.cod_asegurado = DP.cod_asegurado
                 AND    A.codcia        = DP.codcia
                 AND    A.codempresa    = DP.codempresa
                 AND    A.codcia        = P.codcia
                 AND    A.codempresa    = P.codempresa
                 AND    A.tipo_doc_identificacion   = PNJ.tipo_doc_identificacion
                 AND    A.num_doc_identificacion    = PNJ.num_doc_identificacion  
                 AND    A.codcia        = AP.codcia
                 AND    P.idpoliza      = AP.idpoliza
                 AND    P.codcia        = AP.codcia
                 AND    AP.idpoliza     = DP.idpoliza
                 AND    AP.codcia       = DP.codcia
                 AND    OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(A.codcia, P.idpoliza, DP.idetpol, A.cod_asegurado) = 'N'
                 AND    P.codcia        = nCodCia
                 AND    P.codempresa    = nCodEmpresa
                 AND    P.idpoliza      = nIdPoliza
                 AND    AP.cod_agente   = nCodAgente
                 --AND    A.cod_asegurado  = NVL(:nContratante, A.cod_asegurado)
                 --AND    P.fecinivig >= :dFechaIni
                 --AND    P.fecfinvig <= :dFechaFin
                UNION
                -- Colectiva
                 SELECT AC.cod_asegurado                        ASEGURADO, 
                        AP.cod_agente                           AGENTE, 
                        DECODE(AP.ind_principal,'S','Si','No')  PRINCIPAL, 
                        P.idpoliza,
                        DP.fecinivig, 
                        DP.fecfinvig, 
                        PNJ.nombre, 
                        PNJ.apellido_paterno, 
                        PNJ.apellido_materno,
                        OC_ASEGURADO.EDAD_ASEGURADO(P.codcia, P.codempresa, AC.cod_asegurado, TRUNC(SYSDATE)) EDAD,
                        PNJ.sexo, 
                        PNJ.estadocivil, 
                        PNJ.fecnacimiento,
                        PNJ.curp,
                        PNJ.fecingreso,        
                        PNJ.tipo_doc_identificacion,
                        PNJ.num_doc_identificacion,
                        PNJ.tipo_persona,
                        PNJ.num_tributario, 
                        PNJ.tipo_id_tributaria,
                        DP.idtiposeg                            TIPO_SEGURO,
                        OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(P.codcia, P.codempresa, DP.idtiposeg) DESC_TIPO_SEGURO,
                        'Colectiva'                             TIPO_POLIZA,
                        OC_PAIS.NOMBRE_PAIS(PNJ.codpaisres)     PAIS,
                        OC_PROVINCIA.NOMBRE_PROVINCIA(PNJ.codpaisres, PNJ.codprovres) ESTADO,
                        OC_DISTRITO.NOMBRE_DISTRITO(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres) CIUDAD,
                        OC_CORREGIMIENTO.nombre_corregimiento(PNJ.codpaisres,PNJ.codprovres,PNJ.coddistres,PNJ.codcorrres) MUNICIPIO_ALCALDIA,
                        OC_COLONIA.DESCRIPCION_COLONIA(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres, PNJ.codcorrres, PNJ.codposres, PNJ.codcolres) COLONIA,        
                        PNJ.codposres,
                        PNJ.nacionalidad
                 FROM   ASEGURADO_CERTIFICADO       AC,
                        ASEGURADO                   A,
                        PERSONA_NATURAL_JURIDICA    PNJ,
                        AGENTE_POLIZA               AP,
                        POLIZAS                     P,
                        DETALLE_POLIZA              DP   
                 WHERE   P.idpoliza       = DP.idpoliza
                 AND     P.codcia         = DP.codcia
                 AND     P.codempresa     = DP.codempresa
                 AND     AC.idpoliza      = P.idpoliza
                 AND     AC.cod_asegurado = DP.cod_asegurado
                 AND     AC.codcia        = DP.codcia
                 AND     AC.idetpol       = DP.idetpol
                 AND     A.cod_asegurado  = DP.cod_asegurado
                 AND     A.codcia         = DP.codcia
                 AND     A.codempresa     = DP.codempresa
                 AND     A.codcia         = P.codcia
                 AND     A.codempresa     = P.codempresa
                 AND     A.tipo_doc_identificacion   = PNJ.tipo_doc_identificacion
                 AND     A.num_doc_identificacion    = PNJ.num_doc_identificacion  
                 AND     A.codcia         = AP.codcia
                 AND     AC.codcia        = AP.codcia
                 AND     AC.idpoliza      = AP.idpoliza
                 AND     P.idpoliza       = AP.idpoliza
                 AND     P.codcia         = AP.codcia
                 AND     AP.idpoliza      = DP.idpoliza
                 AND     AP.codcia        = DP.codcia
                 AND     P.codcia         = nCodCia
                 AND     P.codempresa     = nCodEmpresa
                 AND     P.idpoliza       = nIdPoliza
                 AND     AP.cod_agente    = nCodAgente      -- NVL(:nCodAgente, AP.cod_agente)
                 --AND     AC.cod_asegurado =  :nContratante  -- NVL(:nContratante, AC.cod_asegurado) --
                 --AND     P.fecinivig >= :dFechaIni
                 --AND     P.fecfinvig <= :dFechaFin
                ); 

   END;

   SELECT XMLROOT (xPrevAsegs, VERSION '1.0" encoding="UTF-8')
     INTO xListadoAsegurados
     FROM DUAL;
   RETURN xListadoAsegurados;

END LISTADO_ASEGURADO;


FUNCTION CONSULTA_ASEGURADO (nCodCia  NUMBER,  nCodEmpresa NUMBER, nNoAsegurado  NUMBER)
    RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________    
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 10/01/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : CONSULTA_ASEGURADO                                                                                               |
    | Objetivo   : Funcion que obtiene la informacion detallada del Asegurado dado desde la Plataforma Digital y tranforma la       |
    |              salida en formato XML.                                                                                           |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nodCia                  Codigo de Compañia              (Entrada)                                                   |    
    |           nNoAsegurado            Codigo del Asegurado            (Entrada)                                                   |
    |           nCodEmpresa             Codigo de Empresa               (Entrada)                                                   |
    |_______________________________________________________________________________________________________________________________|
*/
xAsegurado   XMLTYPE;
xPrevAseg    XMLTYPE; 
BEGIN
   BEGIN
        SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("ASEGURADOS",
                                                XMLELEMENT("Asegurado", asegurado),
                                                XMLELEMENT("Agente", agente),
                                                XMLELEMENT("Principal", principal),
                                                XMLELEMENT("IDPoliza", idpoliza),
                                                XMLELEMENT("NumPolUnico", numpolunico),
                                                XMLELEMENT("IdetPol", idetpol),
                                                XMLELEMENT("FecIniVig", fecinivig),
                                                XMLELEMENT("FecFinVig", fecfinvig),
                                                XMLELEMENT("FecSolicitud", fecsolicitud),
                                                XMLELEMENT("FecEmision", fecemision),
                                                XMLELEMENT("FecRenovacion", fecrenovacion),
                                                XMLELEMENT("Nombre", nombre),
                                                XMLELEMENT("ApellidoPaterno", apellido_paterno),
                                                XMLELEMENT("ApellidoMaterno", apellido_materno),
                                                XMLELEMENT("Edad", edad),
                                                XMLELEMENT("Sexo", sexo),
                                                XMLELEMENT("EdoCivil", estadocivil),
                                                XMLELEMENT("FecNacimiento", fecnacimiento),
                                                XMLELEMENT("Curp", curp),
                                                XMLELEMENT("FecIngreso", fecingreso),
                                                XMLELEMENT("TipoDocIdentificacion", tipo_doc_identificacion),
                                                XMLELEMENT("NumDocIdentificacion", num_doc_identificacion),
                                                XMLELEMENT("TipoPersona", tipo_persona),
                                                XMLELEMENT("NumTributario", num_tributario),
                                                XMLELEMENT("TipoIdTtributaria", tipo_id_tributaria),
                                                XMLELEMENT("TipoSeguro", tipo_seguro),
                                                XMLELEMENT("NomTipoSeguro", des_tipo_seguro),
                                                XMLELEMENT("TipoPoliza", tipo_poliza),
                                                XMLELEMENT("Pais", pais),
                                                XMLELEMENT("Estado", estado),
                                                XMLELEMENT("Ciudad", ciudad),
                                                XMLELEMENT("MunicipioAlcaldia", municipio_alcaldia),
                                                XMLELEMENT("Colonia", colonia),
                                                XMLELEMENT("C.P.", codposres),
                                                XMLELEMENT("Nacionalidad", nacionalidad),
                                                XMLELEMENT("CodPlanPago", codplanpago),
                                                XMLELEMENT("StsDetalle", stsdetalle),
                                                XMLELEMENT("SumaAsegLocal", suma_aseg_local),
                                                XMLELEMENT("PrimaLocal", prima_local),
                                                XMLELEMENT("PrimaNetaLocal", primaneta_local),
                                                XMLELEMENT("NumDetRef", numdetref),
                                                XMLELEMENT("FecAnula", fecanul),
                                                XMLELEMENT("MotivAnula", motivanul)
                                              )
                                  )
                         )                                                
        INTO    xPrevAseg
        FROM    (SELECT A.cod_asegurado                         ASEGURADO, 
                        AP.cod_agente                           AGENTE, 
                        DECODE(AP.ind_principal,'S','Si','No')  PRINCIPAL, 
                        P.idpoliza,
                        P.numpolunico,
                        DP.idetpol,
                        DP.fecinivig, 
                        DP.fecfinvig,
                        P.fecsolicitud, 
                        P.fecemision, 
                        P.fecrenovacion, 
                        PNJ.nombre, 
                        PNJ.apellido_paterno, 
                        PNJ.apellido_materno,
                        OC_ASEGURADO.EDAD_ASEGURADO(A.codcia, A.codempresa, A.cod_asegurado, TRUNC(SYSDATE)) EDAD,
                        PNJ.sexo, 
                        PNJ.estadocivil, 
                        PNJ.fecnacimiento,
                        PNJ.curp,
                        PNJ.fecingreso,        
                        PNJ.tipo_doc_identificacion,
                        PNJ.num_doc_identificacion,
                        PNJ.tipo_persona,
                        PNJ.num_tributario, 
                        PNJ.tipo_id_tributaria,
                        DP.idtiposeg                            TIPO_SEGURO,
                        OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(A.codcia, A.codempresa, DP.idtiposeg) DES_TIPO_SEGURO,
                        'Individual'                            TIPO_POLIZA,
                        OC_PAIS.NOMBRE_PAIS(PNJ.codpaisres)     PAIS,
                        OC_PROVINCIA.NOMBRE_PROVINCIA(PNJ.codpaisres, PNJ.codprovres) ESTADO,
                        OC_DISTRITO.NOMBRE_DISTRITO(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres) CIUDAD,
                        OC_CORREGIMIENTO.nombre_corregimiento(PNJ.codpaisres,PNJ.codprovres,PNJ.coddistres,PNJ.codcorrres) MUNICIPIO_ALCALDIA,
                        OC_COLONIA.DESCRIPCION_COLONIA(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres, PNJ.codcorrres, PNJ.codposres, PNJ.codcolres) COLONIA,        
                        PNJ.codposres,
                        PNJ.nacionalidad,
                        DP.codplanpago, 
                        DP.stsdetalle, 
                        DP.suma_aseg_local, 
                        DP.prima_local,
                        P.primaneta_local,
                        DP.numdetref,
                        DP.fecanul,
                        DP.motivanul
                 FROM   ASEGURADO                   A,
                        PERSONA_NATURAL_JURIDICA    PNJ,
                        AGENTE_POLIZA               AP,
                        POLIZAS                     P,
                        DETALLE_POLIZA              DP 
                 WHERE  P.idpoliza      = DP.idpoliza
                 AND    P.codcia        = DP.codcia
                 AND    P.codempresa    = DP.codempresa
                 AND    A.cod_asegurado = DP.cod_asegurado
                 AND    A.codcia        = DP.codcia
                 AND    A.codempresa    = DP.codempresa
                 AND    A.codcia        = P.codcia
                 AND    A.codempresa    = P.codempresa
                 AND    A.tipo_doc_identificacion   = PNJ.tipo_doc_identificacion
                 AND    A.num_doc_identificacion    = PNJ.num_doc_identificacion  
                 AND    A.codcia        = AP.codcia
                 AND    P.idpoliza      = AP.idpoliza
                 AND    P.codcia        = AP.codcia
                 AND    AP.idpoliza     = DP.idpoliza
                 AND    AP.codcia       = DP.codcia
                 AND    OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(A.codcia, P.idpoliza, DP.idetpol, A.cod_asegurado) = 'N'
                 AND    P.codcia         = nCodCia
                 AND    P.codempresa     = nCodEmpresa
                 --AND    P.idpoliza       = :nPoliza
                 --AND    AP.cod_agente    = :nCodAgente
                 AND    A.cod_asegurado  = nNoAsegurado    --NVL(:nNoAsegurado, A.cod_asegurado)
                 --AND    P.fecinivig >= :dFechaIni
                 --AND    P.fecfinvig <= :dFechaFin
                UNION
                -- Colectiva
                 SELECT A.cod_asegurado, 
                        AP.cod_agente, 
                        DECODE(AP.ind_principal,'S','Si','No') PRINCIPAL, 
                        P.idpoliza,
                        P.numpolunico,
                        DP.idetpol,
                        DP.fecinivig, 
                        DP.fecfinvig,
                        P.fecsolicitud, 
                        P.fecemision, 
                        P.fecrenovacion, 
                        PNJ.nombre, 
                        PNJ.apellido_paterno, 
                        PNJ.apellido_materno,
                        OC_ASEGURADO.EDAD_ASEGURADO(p.codcia, p.codempresa, AC.cod_asegurado, TRUNC(SYSDATE)) EDAD,
                        PNJ.sexo, 
                        PNJ.estadocivil, 
                        PNJ.fecnacimiento,
                        PNJ.curp,
                        PNJ.fecingreso,        
                        PNJ.tipo_doc_identificacion,
                        PNJ.num_doc_identificacion,
                        PNJ.tipo_persona,
                        PNJ.num_tributario, 
                        PNJ.tipo_id_tributaria,
                        DP.idtiposeg TIPO_SEGURO,
                        OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(p.codcia, P.codempresa, DP.idtiposeg) DESC_TIPO_SEGURO,
                        'Colectiva' TIPO_POLIZA,
                        OC_PAIS.NOMBRE_PAIS(PNJ.codpaisres) PAIS,
                        OC_PROVINCIA.NOMBRE_PROVINCIA(PNJ.codpaisres, PNJ.codprovres) ESTADO,
                        OC_DISTRITO.NOMBRE_DISTRITO(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres) CIUDAD,
                        OC_CORREGIMIENTO.nombre_corregimiento(PNJ.codpaisres,PNJ.codprovres,PNJ.coddistres,PNJ.codcorrres) MUNICIPIO_ALCALDIA,
                        OC_COLONIA.DESCRIPCION_COLONIA(PNJ.codpaisres, PNJ.codprovres, PNJ.coddistres, PNJ.codcorrres, PNJ.codposres, PNJ.codcolres) COLONIA,        
                        PNJ.codposres,
                        PNJ.nacionalidad,
                        DP.codplanpago, 
                        DP.stsdetalle, 
                        DP.suma_aseg_local, 
                        DP.prima_local,
                        P.primaneta_local,
                        DP.numdetref,
                        DP.fecanul,
                        DP.motivanul
                 FROM   ASEGURADO_CERTIFICADO       AC,
                        ASEGURADO                   A,
                        PERSONA_NATURAL_JURIDICA    PNJ,
                        AGENTE_POLIZA               AP,
                        POLIZAS                     P,
                        DETALLE_POLIZA              DP  
                 WHERE  P.idpoliza       = DP.idpoliza
                 AND    P.codcia         = DP.codcia
                 AND    P.codempresa     = DP.codempresa
                 AND    AC.idpoliza      = P.idpoliza
                 AND    AC.cod_asegurado = DP.cod_asegurado
                 AND    AC.codcia        = DP.codcia
                 AND    AC.idetpol       = DP.idetpol
                 AND    A.cod_asegurado  = DP.cod_asegurado
                 AND    A.codcia         = DP.codcia
                 AND    A.codempresa     = DP.codempresa
                 AND    A.codcia         = P.codcia
                 AND    A.codempresa     = P.codempresa
                 AND    A.tipo_doc_identificacion   = PNJ.tipo_doc_identificacion
                 AND    A.num_doc_identificacion    = PNJ.num_doc_identificacion  
                 AND    A.codcia         = AP.codcia
                 AND    AC.codcia        = AP.codcia
                 AND    AC.idpoliza      = AP.idpoliza
                 AND    P.idpoliza       = AP.idpoliza
                 AND    P.codcia         = AP.codcia
                 AND    AP.idpoliza      = DP.idpoliza
                 AND    AP.codcia        = DP.codcia
                 AND    P.codcia         = nCodCia
                 AND    P.codempresa     = nCodEmpresa
                 --AND    P.idpoliza       = :nPoliza
                 --AND    AP.cod_agente    = :nCodAgente
                 AND    AC.cod_asegurado = nNoAsegurado    -- NVL(:nNoAsegurado, AC.cod_asegurado) -- 
                 --AND    P.fecinivig >= :dFechaIni
                 --AND    P.fecfinvig <= :dFechaFin
                );

      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'El Asegurado '||nNoAsegurado||' no existente en Base de Datos.'); 
   END;

   SELECT   XMLROOT (xPrevAseg, VERSION '1.0" encoding="UTF-8')
   INTO     xAsegurado
   FROM     DUAL;

   RETURN xAsegurado;

END CONSULTA_ASEGURADO;

END OC_ASEGURADOS_SERVICIOS_WEB;
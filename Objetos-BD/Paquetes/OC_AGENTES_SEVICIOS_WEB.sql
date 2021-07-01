CREATE OR REPLACE PACKAGE SICAS_OC.OC_AGENTES_SEVICIOS_WEB AS

FUNCTION JERARQ_AGENTE( nCodAgente  NUMBER, nCodCia NUMBER, nCodEmpresa NUMBER ) RETURN XMLTYPE;
            
FUNCTION AGREGAR_USUARIO_WS ( nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente	NUMBER )  RETURN VARCHAR2;

FUNCTION ACTUALIZAR_USUARIO_WS ( nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente	NUMBER) RETURN VARCHAR2;

END OC_AGENTES_SEVICIOS_WEB;
/

CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_AGENTES_SEVICIOS_WEB AS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 21/12/2020                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : OC_AGENTES_SEVICIOS_WEB                                                                                          |
    | Versión    : v2 [ Jun 2021 ]                                                                                                  |
    | Objetivo   : Package obtiene la jerarquia y detalles de los Agentes que cumplen con los criterios dados en los Servicios WEB  |
    |              de la Plataforma Digital, los resultados son generados en formato XML.                                           |
    | Modificado : Si                                                                                                               |
    | Ult. Modif.: 04/06/2021                                                                                                       |
    | Modifico   : J. Alberto Lopez Valle (JALV)                                                                                    |
    | Obj. Modif.: Se agregaron 2 funciones de Agregar y Actualizar usuario de Agente por medio del llamado de WS:                  |
    |               - AGREGAR_USUARIO_WS                                                                                            |
    |               - ACTUALIZAR_USUARIO_WS                                                                                         |
    |                                                                                                                               |
    |   07/01/2021  Se quita restriccion del Status del agente a solo activo (ACT) y se agrega Nombre del ejecutivo segun su codigo.|
    |_______________________________________________________________________________________________________________________________|
*/ 

FUNCTION JERARQ_AGENTE( nCodAgente  NUMBER,	nCodCia NUMBER, nCodEmpresa NUMBER)
RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 21/12/2020                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : JERARQ_AGENTE                                                                                                    |
    | Objetivo   : Funcion que obtiene la Jerarquia de un Agente dado que cumple con los criterios dados desde la Plataforma        |
    |              Digital y genera la salida en formato XML.                                                                       |
    | Modificado : Si                                                                                                               |
    | Ult. Modif.: 07/01/2021                                                                                                       |
    | Modifico   : J. Alberto Lopez Valle (JALV)                                                                                    |
    | Obj. Modif.: Se quita restriccion del Status del agente a solo activo (ACT) y se agrega Nombre del ejecutivo segun su codigo. |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodAgente			Numero o Codigo del Agente  (Entrada)                                                           |
    |			cStsAgnte			Estado del Agente			(Entrada)                                                           |
    |			nCodCia				Codigo de la Compañia	    (Entrada)                                                           |
    |			nCodEmpresa			Codigo de la Empresa	    (Entrada)                                                           |
    |           dFechaAlta          Fecha de Alta del Agente    (Entrada)                                                           |
    |_______________________________________________________________________________________________________________________________|
*/ 
xJerarquia  XMLTYPE;
xPrevJerarq XMLTYPE; 
BEGIN
   BEGIN
    SELECT XMLELEMENT("DATA",
                    XMLAGG(XMLELEMENT("JERARQUIA",  
                            XMLELEMENT("Puesto", (SELECT descripcion FROM NIVEL N WHERE N.codnivel = A.codnivel AND N.codcia = nCodCia)),
                            XMLELEMENT("Jerarquia",SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'),2)),
                            XMLELEMENT("Dir_Regional", DECODE( (SELECT codnivel FROM AGENTES WHERE cod_agente  = nCodAgente), 1, nCodAgente,'')),
                            XMLELEMENT("Promotoria",NVL(DECODE( A.codnivel,
                                                                    1, (SUBSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'), 2),   ( (INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'),2), '/', 1, 1))+1), ( (INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'),2), '/', 1, 2)) - ((INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'),2), '/', 1, 1))+1)) )), 
                                                                    2, (SUBSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'), 2),   ( (INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'), 2), '/', 1, 1) ) +1), ( ( LENGTH(SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'),2)) )         - (INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'),2), '/', 1, 1)) )   )),
                                                                    (DECODE( (SELECT codnivel FROM AGENTES WHERE cod_agente  = nCodAgente), 
                                                                                1, (SUBSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'), 2),   ( (INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'),2), '/', 1, 1))+1), ( (INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'),2), '/', 1, 2)) - ((INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'),2), '/', 1, 1))+1)) )), 
                                                                                2, (SUBSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'), 2),   ( (INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'), 2), '/', 1, 1) ) +1), ( ( LENGTH(SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'),2)) )         - (INSTR(SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'),2), '/', 1, 1)) )   )),
                                                                            '')) 
                                                                ),
                                                        '')
                                        ),
                            XMLELEMENT("Codigo",DECODE( A.codnivel,
                                                    1, ' ',
                                                    2, ' ',
                                                    3, A.cod_agente,
                                                    '')),
                            XMLELEMENT("TipoAgente",A.tipo_agente),
                            XMLELEMENT("FechaAlta",A.fecalta),
                            XMLELEMENT("StsAgente",DECODE(A.est_agente,'ACT','Activo','SUS','Suspendido','SOL','Solicitud','INA','Inactico',est_agente)),        
                            XMLELEMENT("CanalComisVenta",A.canalcomisventa),
                            XMLELEMENT("ExcluirHonorarios",DECODE(A.indexcluirhonorario, 'S','Si','No')),
                            XMLELEMENT("PagoAutom",DECODE(A.indpagosautom, 'S','Si','No')),
                            XMLELEMENT("Ejecutivo",A.codejecutivo),
                            XMLELEMENT("NomEjecutivo", OC_EJECUTIVO_COMERCIAL.NOMBRE_EJECUTIVO(nCodCia, A.codejecutivo)),   --> 07/01/2021  (JALV +)
                            XMLELEMENT("Compañia",A.codcia),
                            XMLELEMENT("Empresa",A.codempresa)

							)
						)
					)
		INTO	xPrevJerarq
        FROM    AGENTES A
        CONNECT BY PRIOR A.cod_agente = A.cod_agente_jefe
        --AND     A.est_agente  = 'ACT'   --NVL(cStsAgnte, cStsAgnte)   --> 07/01/2021  (JALV -)
        AND     A.codcia      = nCodCia
        AND     A.codempresa  = nCodEmpresa        
        START WITH A.cod_agente  = nCodAgente
        ORDER SIBLINGS BY A.cod_agente;

      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'El Agente '||TO_CHAR(nCodAgente)||' no existente en Base de Datos.'); 
   END;
   
   SELECT 	XMLROOT (xPrevJerarq, VERSION '1.0" encoding="UTF-8')
   INTO		xJerarquia
   FROM 	DUAL;
   
   RETURN xJerarquia;
   
END JERARQ_AGENTE;

FUNCTION AGREGAR_USUARIO_WS ( nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente   NUMBER )
RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 04/06/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : AGREGAR_USUARIO_WS                                                                                               |
    | Objetivo   : Funcion que Agrega Usuario de un Agente en Plataforma Digital mediante el uso del Web Service correspondiente.   |
    | Modificado : No                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |			nCodCia				Codigo de la Compañia	    (Entrada)                                                           |
    |			nCodEmpresa			Codigo de la Empresa	    (Entrada)                                                           |
    |           nCodAgente			Numero o Codigo del Agente  (Entrada)                                                           |
    |_______________________________________________________________________________________________________________________________|
*/ 
cSoapRequest        VARCHAR2(30000);
eHttpReq            UTL_HTTP.req;
eHttpResp           UTL_HTTP.resp;
BreqLength          BINARY_INTEGER;
cRespWS             VARCHAR2(1000);
cClobXml            XMLType;
cStrTxt             VARCHAR2(30000);
cWSDLPortal         PARAMETROS_GLOBALES.Descripcion%TYPE;            
nClaveAgente        AGENTES.Cod_Agente%TYPE;
cNombre             PERSONA_NATURAL_JURIDICA.nombre%TYPE;
cApe_Paterno        PERSONA_NATURAL_JURIDICA.apellido_paterno%TYPE;
cApe_Materno        PERSONA_NATURAL_JURIDICA.apellido_materno%TYPE;
cUsuario            AGENTES.Clave_Portal%TYPE;
cCorreoElectron     PERSONA_NATURAL_JURIDICA.email%TYPE;
nTelefono           PERSONA_NATURAL_JURIDICA.telres%TYPE;
nClaveSubAlterno    AGENTES.Cod_Agente%TYPE;
cRFC                PERSONA_NATURAL_JURIDICA.num_tributario%TYPE;

cPathWallet         VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'017');      --> Herber 03/06/2021
cPwdWallet          VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'018');      --> Herber 03/06/2021
NodosList           DBMS_XMLDOM.DOMNodeList;

BEGIN
    SELECT  A.Cod_Agente,
            PNJ.nombre,
            PNJ.apellido_paterno,
            PNJ.apellido_materno,
            A.Clave_Portal,
            PNJ.email,
            NVL(PNJ.telres, NVL(PNJ.telmovil, PNJ.telofi)) Telefono, 
            (SELECT  Cod_Agente
             FROM    (  SELECT  A2.codnivel NIVEL,
                                A2.cod_agente
                        FROM    AGENTES A2
                        CONNECT BY PRIOR A2.cod_agente = A2.cod_agente_jefe
                        AND     A2.est_agente  = 'ACT'
                        AND     A2.codcia      = nCodCia
                        AND     A2.codempresa  = nCodEmpresa
                        START WITH A2.cod_agente  = nCodAgente
                        )
             WHERE   NIVEL = A.CodNivel + 1
             AND     ROWNUM = 1
             ) ClaveSubAlterno,
            DECODE(PNJ.tipo_id_tributaria, 'RFC', PNJ.num_tributario) RFC
    INTO    nClaveAgente, cNombre, cApe_Paterno, cApe_Materno, cUsuario, cCorreoElectron, nTelefono, nClaveSubAlterno, cRFC
    FROM    AGENTES                     A,
            PERSONA_NATURAL_JURIDICA    PNJ
    WHERE   PNJ.tipo_doc_identificacion = A.tipo_doc_identificacion
    AND     PNJ.num_doc_identificacion  = A.Num_Doc_Identificacion
    AND     A.CodCia      = nCodCia
    AND     A.CodEmpresa  = nCodEmpresa
    AND     A.Cod_Agente  = nCodAgente --> 10003
    AND     A.Est_Agente  = 'ACT';
        
    cWSDLPortal := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'A01');
    
    cSoapRequest := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:thon="https://thona01.azurewebsites.net/">
                       <soapenv:Header/>
                       <soapenv:Body>
                          <thon:AgregarUsuario>
                             <thon:ClaveAgente>'||nClaveAgente||'</thon:ClaveAgente>
                             <!--Optional:-->
                             <thon:Nombre>'||cNombre||'</thon:Nombre>
                             <!--Optional:-->
                             <thon:ApellidoPaterno>'||cApe_Paterno||'</thon:ApellidoPaterno>
                             <!--Optional:-->
                             <thon:ApellidoMaterno>'||cApe_Materno||'</thon:ApellidoMaterno>
                             <!--Optional:-->
                             <thon:Usuario>'||cUsuario||'</thon:Usuario>
                             <!--Optional:-->
                             <thon:CorreoElectronico>'||cCorreoElectron||'</thon:CorreoElectronico>
                             <!--Optional:-->
                             <thon:Telefono>'||nTelefono||'</thon:Telefono>
                             <!--Optional:-->
                             <thon:ClaveSubAlterno>'||nClaveSubAlterno||'</thon:ClaveSubAlterno>
                             <!--Optional:-->
                             <thon:RFC>'||cRFC||'</thon:RFC>
                          </thon:AgregarUsuario>
                       </soapenv:Body>
                    </soapenv:Envelope>';        
    
    UTL_HTTP.set_wallet('file:'||cPathWallet,cPwdWallet);
    
    eHttpReq := UTL_HTTP.BEGIN_REQUEST (cWSDLPortal, 'POST', 'HTTP/1.1');
    --UTL_HTTP.SET_BODY_CHARSET (eHttpReq, 'UTF8'); --> Comentado para que funcione en Produccion JALV(-) 29/06/2021
    UTL_HTTP.SET_HEADER (eHttpReq, 'Content-Type', 'text/xml');
    BreqLength := DBMS_LOB.GETLENGTH(cSoapRequest);        
    UTL_HTTP.SET_HEADER (eHttpReq, 'Content-Length', BreqLength);
    UTL_HTTP.WRITE_TEXT (eHttpReq, cSoapRequest);
    
    eHttpResp := UTL_HTTP.GET_RESPONSE (eHttpReq);
    UTL_HTTP.READ_TEXT(eHttpResp,cStrTxt,32767);
    UTL_HTTP.END_RESPONSE(eHttpResp);
    cClobXml := XMLType.CREATEXML(cStrTxt);
  
    -- Captar el resultado del Response en cRespWS
    BEGIN        
        SELECT NVL(AgregarUsuario, 'SIN VALOR')
        INTO cRespWS
        FROM XMLTABLE(XMLNAMESPACES('http://schemas.xmlsoap.org/soap/envelope/' AS "SOAPENV",
                                    'http://www.w3.org/2001/XMLSchema-instance' AS "XMLSchemainstance",
                                    'http://www.w3.org/2001/XMLSchema' AS "XMLSchema"--,
                                     ),'/'
                 PASSING cClobXml
                 COLUMNS AgregarUsuario VARCHAR2(100) PATH '/');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20200,'No se obtuvo ningun valor para el Agente '||nClaveAgente||' en el response de Agregar Usuario.'); 
            cRespWS := 'SIN DATOS';
    END;
        
    -- Actualiza indicador de Alta en plataforma Digital:
    IF cRespWS = 'true' THEN
        UPDATE  AGENTES
        SET     IndAltaPlataforma = 'S' 
        WHERE   CodCia      = nCodCia
        AND     CodEmpresa  = nCodEmpresa
        AND     Cod_Agente  = nCodAgente --> 10003
        AND     Est_Agente  = 'ACT';
        
        cRespWS := 'Alta exitosa del Agente '||nClaveAgente||' en Plataforma digital';
    ELSE
        cRespWS := 'Se detecto un error en el Agente '||nClaveAgente||' al intentar Agregar Usuario en Plataforma Digital:'|| SQLCODE || '('|| SQLERRM || ')';
    END IF;
        
    RETURN cRespWS;

        EXCEPTION
            WHEN UTL_HTTP.TOO_MANY_REQUESTS THEN
              UTL_HTTP.END_RESPONSE(eHttpResp);
              cRespWS := 'Mas de un valor en el Request al intentar Agregar Usuario en Plataforma Digital.';
            WHEN OTHERS THEN
              UTL_HTTP.END_RESPONSE(eHttpResp);
              cRespWS := 'Error al intentar Agregar Usuario en Plataforma Digital: ' || SQLCODE || '('|| SQLERRM || ')'; 
              
END AGREGAR_USUARIO_WS;

FUNCTION ACTUALIZAR_USUARIO_WS ( nCodCia NUMBER, nCodEmpresa NUMBER, nCodAgente	NUMBER)
RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 04/06/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : ACTUALIZAR_USUARIO_WS                                                                                            |
    | Objetivo   : Funcion que actualiza el Usuario del Agente dado en Plataforma Digital.                                          |
    |                                                                                                                               |
    | Modificado : No                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |			nCodCia				Codigo de la Compañia	    (Entrada)                                                           |
    |			nCodEmpresa			Codigo de la Empresa	    (Entrada)                                                           |
    |           nCodAgente			Numero o Codigo del Agente  (Entrada)                                                           |
    |_______________________________________________________________________________________________________________________________|
*/ 
cSoapRequest        VARCHAR2(30000);
eHttpReq            UTL_HTTP.req;
eHttpResp           UTL_HTTP.resp;
BreqLength          BINARY_INTEGER;
cRespWS             VARCHAR2(1000);
cClobXml            XMLType;
cStrTxt             VARCHAR2(30000);
cWSDLPortal         PARAMETROS_GLOBALES.Descripcion%TYPE;
                
nClaveAgente        AGENTES.Cod_Agente%TYPE;
cNombre             PERSONA_NATURAL_JURIDICA.nombre%TYPE;
cApe_Paterno        PERSONA_NATURAL_JURIDICA.apellido_paterno%TYPE;
cApe_Materno        PERSONA_NATURAL_JURIDICA.apellido_materno%TYPE;
cUsuario            AGENTES.Clave_Portal%TYPE;
cCorreoElectron     PERSONA_NATURAL_JURIDICA.email%TYPE;
nTelefono           PERSONA_NATURAL_JURIDICA.telres%TYPE;
nClaveSubAlterno    AGENTES.Cod_Agente%TYPE;
cRFC                PERSONA_NATURAL_JURIDICA.num_tributario%TYPE;

cPathWallet         VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'017');      --> Herber 03/06/2021
cPwdWallet          VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'018');      --> Herber 03/06/2021
NodosList           DBMS_XMLDOM.DOMNodeList;

BEGIN
    SELECT  A.Cod_Agente,
            PNJ.nombre,
            PNJ.apellido_paterno,
            PNJ.apellido_materno,
            A.Clave_Portal,
            PNJ.email,
            NVL(PNJ.telres, NVL(PNJ.telmovil, PNJ.telofi)) Telefono,
            (SELECT  Cod_Agente
             FROM    (  SELECT  A2.codnivel NIVEL,
                                A2.cod_agente
                        FROM    AGENTES A2
                        CONNECT BY PRIOR A2.cod_agente = A2.cod_agente_jefe
                        AND     A2.est_agente  = 'ACT'
                        AND     A2.codcia      = nCodCia
                        AND     A2.codempresa  = nCodEmpresa
                        START WITH A2.cod_agente  = nCodAgente
                        )
             WHERE   NIVEL = A.CodNivel + 1
             AND     ROWNUM = 1
             ) ClaveSubAlterno,
            DECODE(PNJ.tipo_id_tributaria, 'RFC', PNJ.num_tributario) RFC
    INTO    nClaveAgente, cNombre, cApe_Paterno, cApe_Materno, cUsuario, cCorreoElectron, nTelefono, nClaveSubAlterno, cRFC
    FROM    AGENTES                     A,
            PERSONA_NATURAL_JURIDICA    PNJ
    WHERE   PNJ.tipo_doc_identificacion = A.tipo_doc_identificacion
    AND     PNJ.num_doc_identificacion  = A.Num_Doc_Identificacion
    AND     A.CodCia      = nCodCia
    AND     A.CodEmpresa  = nCodEmpresa
    AND     A.Cod_Agente  = nCodAgente --> 10003
    AND     A.Est_Agente  = 'ACT';
        
    cWSDLPortal := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'A01');

    cSoapRequest := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:thon="https://thona01.azurewebsites.net/">
                       <soapenv:Header/>
                       <soapenv:Body>
                          <thon:ActualizarUsuario>
                             <thon:ClaveAgente>'||nClaveAgente||'</thon:ClaveAgente>
                             <!--Optional:-->
                             <thon:Nombre>'||cNombre||'</thon:Nombre>
                             <!--Optional:-->
                             <thon:ApellidoPaterno>'||cApe_Paterno||'</thon:ApellidoPaterno>
                             <!--Optional:-->
                             <thon:ApellidoMaterno>'||cApe_Materno||'</thon:ApellidoMaterno>
                             <!--Optional:-->
                             <thon:Usuario>'||cUsuario||'</thon:Usuario>
                             <!--Optional:-->
                             <thon:CorreoElectronico>'||cCorreoElectron||'</thon:CorreoElectronico>
                             <!--Optional:-->
                             <thon:Telefono>'||nTelefono||'</thon:Telefono>
                             <!--Optional:-->
                             <thon:ClaveSubAlterno>'||nClaveSubAlterno||'</thon:ClaveSubAlterno>
                             <!--Optional:-->
                             <thon:RFC>'||cRFC||'</thon:RFC>
                          </thon:ActualizarUsuario>
                       </soapenv:Body>
                    </soapenv:Envelope>';        
    
    UTL_HTTP.set_wallet('file:'||cPathWallet,cPwdWallet);
    
    eHttpReq := UTL_HTTP.BEGIN_REQUEST (cWSDLPortal, 'POST', 'HTTP/1.1');
    -- UTL_HTTP.SET_BODY_CHARSET (eHttpReq, 'UTF8');    --> Comentado para que funcione en Produccion JALV(-) 29/06/2021
    UTL_HTTP.SET_HEADER (eHttpReq, 'Content-Type', 'text/xml');
    BreqLength := DBMS_LOB.GETLENGTH(cSoapRequest);        
    UTL_HTTP.SET_HEADER (eHttpReq, 'Content-Length', BreqLength);
    UTL_HTTP.WRITE_TEXT (eHttpReq, cSoapRequest);
    
    eHttpResp := UTL_HTTP.GET_RESPONSE (eHttpReq);
    UTL_HTTP.READ_TEXT(eHttpResp,cStrTxt,32767);
    UTL_HTTP.END_RESPONSE(eHttpResp);
    cClobXml := XMLType.CREATEXML(cStrTxt);
  
    -- Captar el resultado del Response en cRespWS
    BEGIN        
        SELECT NVL(ActualizarUsuario, 'SIN VALOR')
        INTO cRespWS
        FROM XMLTABLE(XMLNAMESPACES('http://schemas.xmlsoap.org/soap/envelope/' AS "SOAPENV",
                                    'http://www.w3.org/2001/XMLSchema-instance' AS "XMLSchemainstance",
                                    'http://www.w3.org/2001/XMLSchema' AS "XMLSchema"--,
                                     ),'/'
                 PASSING cClobXml
                 COLUMNS ActualizarUsuario VARCHAR2(100) PATH '/');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20200,'No se obtuvo ningun valor para el Agente '||nClaveAgente||' en el response de Actualizar Usuario.'); 
            cRespWS := 'SIN DATOS';
        
    END;
        
    IF UPPER(cRespWS) != 'TRUE' THEN
        cRespWS := 'Se detecto un error en el Agente '||nClaveAgente||' al intentar Actualizar su Usuario en Plataforma Digital.';
    ELSE
        cRespWS := 'Actualizacion exitosa de datos del Agente '||nClaveAgente||' en Plataforma digital';
    END IF;
        
    RETURN cRespWS;

        EXCEPTION
            WHEN UTL_HTTP.TOO_MANY_REQUESTS THEN
              UTL_HTTP.END_RESPONSE(eHttpResp);
              cRespWS := 'Mas de un valor en el Request al intentar Actualizar su Usuario en Plataforma Digital.';
            WHEN OTHERS THEN
              UTL_HTTP.END_RESPONSE(eHttpResp);
              IF INSTR(SQLERRM, 'end-of-body reached') > 0 THEN
                RAISE_APPLICATION_ERROR(-20200,'El codigo de Pagina o CHARSET es Erroneo');
              ELSE
                cRespWS := 'Error al intentar Actualizar su Usuario en Plataforma Digital: ' || SQLCODE || '('|| SQLERRM || ')';
              END IF;

END ACTUALIZAR_USUARIO_WS;


END OC_AGENTES_SEVICIOS_WEB;
/
CREATE OR REPLACE PUBLIC SYNONYM OC_AGENTES_SEVICIOS_WEB FOR SICAS_OC.OC_AGENTES_SEVICIOS_WEB;
/
GRANT EXECUTE ON OC_AGENTES_SEVICIOS_WEB TO PUBLIC;
/

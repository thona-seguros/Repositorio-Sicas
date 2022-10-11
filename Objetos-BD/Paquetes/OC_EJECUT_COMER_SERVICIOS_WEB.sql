DROP PACKAGE OC_EJECUT_COMER_SERVICIOS_WEB
/

--
-- OC_EJECUT_COMER_SERVICIOS_WEB  (Package) 
--
CREATE OR REPLACE PACKAGE          OC_EJECUT_COMER_SERVICIOS_WEB AS

FUNCTION LISTADO_EJEC_COMERCIAL ( nCodCia NUMBER, nLimInferior IN NUMBER, nLimSuperior IN NUMBER, nTotRegs OUT NUMBER  )
RETURN XMLTYPE;

FUNCTION LISTADO_AGENTES_ASOCOCIADOS ( nCodCia NUMBER, nCodEjecutivo NUMBER, nLimInferior IN NUMBER, nLimSuperior IN NUMBER, nTotRegs OUT NUMBER)
RETURN XMLTYPE;

END OC_EJECUT_COMER_SERVICIOS_WEB;

/

--
-- OC_EJECUT_COMER_SERVICIOS_WEB  (Synonym) 
--
CREATE OR REPLACE PUBLIC SYNONYM OC_EJECUT_COMER_SERVICIOS_WEB FOR OC_EJECUT_COMER_SERVICIOS_WEB
/


GRANT EXECUTE ON OC_EJECUT_COMER_SERVICIOS_WEB TO PUBLIC
/
DROP PACKAGE BODY OC_EJECUT_COMER_SERVICIOS_WEB
/

--
-- OC_EJECUT_COMER_SERVICIOS_WEB  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY          OC_EJECUT_COMER_SERVICIOS_WEB AS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle [ JALV ]                                                                                  |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 30/07/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx / alvalle007@hotmail.com                                                                  |
    | Nombre     : OC_EJECUT_COMER_SERVICIOS_WEB                                                                                    |
    | Objetivo   : Package obtiene informacion de los Ejecutivos Comerciales y sus Agentes asociados que cumplen con los criterios  |
    |              dados en los Servicios WEB de la Plataforma Digital, los resultados son generados en formato XML.                |
    | Modificado : No                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |_______________________________________________________________________________________________________________________________|
*/ 

FUNCTION LISTADO_EJEC_COMERCIAL (  nCodCia NUMBER, nLimInferior IN NUMBER, nLimSuperior IN NUMBER, nTotRegs OUT NUMBER  )
RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle [ JALV ]                                                                                  |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 30/07/2021                                                                                                       |
    | Email		 : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : LISTADO_EJEC_COMERCIAL                                                                                           |
    | Objetivo   : Funcion que obtiene un listado general de los Ejecutivos Comerciales que cumplen con los criterios dados desde   |
    |              la Plataforma Digital y tranforma la salida en formato XML. Los resultados estan paginados.                      |
    | Modificado : No                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |			nCodCia     		Código de Compañia              (Entrada)                                                       |
    |           nLimInferior        Limite inferior de pagina       (Entrada)                                                       |
    |           nLimSuperior        Limite superior de pagina       (Entrada)                                                       |
    |           nTotRegs            Total de registros obtenidos    (Salida)                                                        |
    |_______________________________________________________________________________________________________________________________|
*/

xListadoEjecComercial    XMLTYPE;
xPrevEjecComercial       XMLTYPE;

BEGIN
   BEGIN
        --> Listado
	    SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("EJECUTIVOS_COMERCIALES",  
                                                XMLELEMENT("CodEjecutivo", CodEjecutivo),
                                                XMLELEMENT("TipoDocIdentificacion", Tipo_Doc_Identificacion),
                                                XMLELEMENT("Num_Doc_Identificacion", Num_Doc_Identificacion),
                                                XMLELEMENT("NombreEjecutivo", NOMBRE),
                                                XMLELEMENT("FechaIngreso", FecIngreso)
                                            )
                                  )
                        )
        INTO	xPrevEjecComercial
        FROM    (   SELECT  E.CodEjecutivo,
                            P.Tipo_Doc_Identificacion,
                            P.Num_Doc_Identificacion,
                            P.Nombre||' '||P.Apellido_Paterno||' '||P.Apellido_Materno NOMBRE,
                            E.FecIngreso,
                            ROW_NUMBER() OVER (ORDER BY E.CodEjecutivo) REGISTRO
                    FROM    EJECUTIVO_COMERCIAL         E,
                            PERSONA_NATURAL_JURIDICA    P
                    WHERE   E.TipoDocIdentEjec  = P.Tipo_Doc_Identificacion
                    AND     E.NumDocIdentEjec   = P.Num_Doc_Identificacion
                    AND     E.CodCia            = nCodCia
                    AND     E.StsEjecutivo      = 'ACTIV'
                    ORDER BY E.CodEjecutivo
                ) 
        WHERE   registro BETWEEN nLimInferior AND nLimSuperior;

         EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 RAISE_APPLICATION_ERROR(-20200,'No se encontraron Agentes en Base de Datos.'); 

        -- Total de regs. obtenidos
        SELECT  NVL(COUNT(*),0)
        INTO    nTotRegs
        FROM    EJECUTIVO_COMERCIAL         E,
                PERSONA_NATURAL_JURIDICA    P
        WHERE   E.TipoDocIdentEjec  = P.Tipo_Doc_Identificacion
        AND     E.NumDocIdentEjec   = P.Num_Doc_Identificacion
        AND     E.CodCia            = nCodCia
        AND     E.StsEjecutivo      = 'ACTIV';
   END;

    SELECT  XMLROOT (xPrevEjecComercial, VERSION '1.0" encoding="UTF-8')
    INTO    xListadoEjecComercial
    FROM    DUAL;

   RETURN xListadoEjecComercial;

END LISTADO_EJEC_COMERCIAL;        

FUNCTION LISTADO_AGENTES_ASOCOCIADOS ( nCodCia NUMBER, nCodEjecutivo NUMBER, nLimInferior IN NUMBER, nLimSuperior IN NUMBER, nTotRegs OUT NUMBER)
RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle [ JALV ]                                                                                  |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 30/07/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : CONSULTA_BENEFICIARIO                                                                                            |
    | Objetivo   : Funcion que consulta y obtiene el listado de Agentes asociados al Ejecutivo dado que cumplen con los criterios   |
    |              desde la Plataforma Digital y genera la salida en formato XML.                                                   |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |			nCodCia     		Código de Compañia                          (Entrada)                                           |
    |           nCodEjecutivo       Codigo del Ejecutivo                        (Entrada)                                           |
    |           nLimInferior        Limite inferior de pagina                   (Entrada)                                           |
    |           nLimSuperior        Limite superior de pagina                   (Entrada)                                           |
    |           nTotRegs            Total de registros obtenidos                (Salida)                                            |    
    |_______________________________________________________________________________________________________________________________|
*/ 
xListadoAgenteAsoc  XMLTYPE;
xPrevAgenteAsoc     XMLTYPE;

BEGIN
   BEGIN
        --> Listado
	    SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("AGENTES_ASOCIADOS",  
                                                XMLELEMENT("CodAgente", Cod_Agente),
                                                XMLELEMENT("CodNivel", CodNivel),
                                                XMLELEMENT("Nivel", Nivel),
                                                XMLELEMENT("NombreAgenteAsociado", NombreAgente)
                                            )
                                  )
                        )
        INTO	xPrevAgenteAsoc
        FROM    (   SELECT  A.Cod_Agente,
                            A.CodNivel,
                            OC_NIVEL.DESCRIPCION_NIVEL(A.CodCia, A.CodNivel)            NIVEL,
                            P.Nombre||' '||P.Apellido_Paterno||' '||P.Apellido_Materno  NOMBREAGENTE,
                            ROW_NUMBER() OVER (ORDER BY A.Cod_Agente)                   REGISTRO
                    FROM    AGENTES                     A,
                            PERSONA_NATURAL_JURIDICA    P
                    WHERE   A.Tipo_Doc_Identificacion = P.Tipo_Doc_Identificacion
                    AND     A.Num_Doc_Identificacion  = P.Num_Doc_Identificacion
                    AND     A.Est_Agente              = 'ACT'
                    AND     A.CodCia                  = nCodCia
                    AND     A.CodEjecutivo            = nCodEjecutivo                    
                ORDER BY A.CodNivel, A.Cod_Agente
                ) 
        WHERE   registro BETWEEN nLimInferior AND nLimSuperior;

        EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 RAISE_APPLICATION_ERROR(-20200,'El Ejecutivo '||TO_CHAR(nCodEjecutivo)||' no tiene Agentes asociados en Base de Datos.'); 

        -- Total de regs. obtenidos
        SELECT  NVL(COUNT(*),0)
        INTO    nTotRegs
        FROM    AGENTES                     A,
                PERSONA_NATURAL_JURIDICA    P
        WHERE   A.Tipo_Doc_Identificacion = P.Tipo_Doc_Identificacion
        AND     A.Num_Doc_Identificacion  = P.Num_Doc_Identificacion
        AND     A.Est_Agente              = 'ACT'
        AND     A.CodCia                  = nCodCia
        AND     A.CodEjecutivo            = nCodEjecutivo;
   END;

    SELECT  XMLROOT (xPrevAgenteAsoc, VERSION '1.0" encoding="UTF-8')
    INTO    xListadoAgenteAsoc
    FROM    DUAL;

   RETURN xListadoAgenteAsoc;

END LISTADO_AGENTES_ASOCOCIADOS;

END OC_EJECUT_COMER_SERVICIOS_WEB;

/

--
-- OC_EJECUT_COMER_SERVICIOS_WEB  (Synonym) 
--
CREATE OR REPLACE PUBLIC SYNONYM OC_EJECUT_COMER_SERVICIOS_WEB FOR OC_EJECUT_COMER_SERVICIOS_WEB
/


GRANT EXECUTE ON OC_EJECUT_COMER_SERVICIOS_WEB TO PUBLIC
/

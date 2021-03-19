create or replace PACKAGE          OC_BENEFICIARIOS_SERVICIOS_WEB AS

FUNCTION LISTADO_BENEFICIARIO(  nCodAsegurado   IN NUMBER,  nIdPoliza       IN NUMBER,  nIdetPol    IN NUMBER,  
                                nLimInferior    IN NUMBER,  nLimSuperior    IN NUMBER,  nTotRegs    OUT NUMBER  )
RETURN XMLTYPE;

FUNCTION CONSULTA_BENEFICIARIO(  nCodAsegurado  NUMBER,     nIdPoliza  NUMBER,  nIdetPol    NUMBER,     nBenef  NUMBER  )
RETURN XMLTYPE;

END OC_BENEFICIARIOS_SERVICIOS_WEB;
/
create or replace PACKAGE BODY          OC_BENEFICIARIOS_SERVICIOS_WEB AS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 13/01/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx / alvalle007@hotmail.com                                                                  |
    | Nombre     : OC_BENEFICIARIOS_SERVICIOS_WEB                                                                                   |
    | Objetivo   : Package obtiene informacion de los Beneficiarios que cumplen con los criterios dados en los Servicios WEB de la  |
    |              Plataforma Digital, los resultados son generados en formato XML.                                                 |
    | Modificado : No                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |_______________________________________________________________________________________________________________________________|
*/ 

FUNCTION LISTADO_BENEFICIARIO(  nCodAsegurado   IN NUMBER,  nIdPoliza       IN NUMBER,  nIdetPol    IN NUMBER,  
                                nLimInferior    IN NUMBER,  nLimSuperior    IN NUMBER,  nTotRegs    OUT NUMBER  )
RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 13/01/2021                                                                                                       |
    | Email		 : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : LISTADO_BENEFICIARIO                                                                                             |
    | Objetivo   : Funcion que obtiene un listado general de los Beneficiarios que cumplen con los criterios dados desde la         |
    |              Plataforma Digital y tranforma la salida en formato XML. Los resultados estan paginados.                         |
    | Modificado : No                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |			nCodAsegurado		Numero de Asegurado 	        (Entrada)                                                       |
    |			nIdPoliza			ID de la Poliza			        (Entrada)                                                       |
    |			nIdetPol			ID del Detalle de la Pólia      (Entrada)                                                       |
    |           nLimInferior        Limite inferior de pagina       (Entrada)                                                       |
    |           nLimSuperior        Limite superior de pagina       (Entrada)                                                       |
    |           nTotRegs            Total de registros obtenidos    (Salida)                                                        |
    |_______________________________________________________________________________________________________________________________|
*/

xListadoBeneficiario    XMLTYPE;
xPrevBenef              XMLTYPE;

BEGIN
   BEGIN
        --> Listado
	    SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("BENEFICIARIOS",  
                                                XMLELEMENT("IdPoliza", IdPoliza),
                                                XMLELEMENT("IDetPol", IDetPol),
                                                XMLELEMENT("CodAsegurado", Cod_Asegurado),
                                                XMLELEMENT("Benef", benef),
                                                XMLELEMENT("Nombre", nombre),
                                                XMLELEMENT("Parentesco", parentesco),
                                                XMLELEMENT("PorcParticipacion", porcepart),
                                                XMLELEMENT("Estado", estado),
                                                XMLELEMENT("IndIrrevocable", indirrevocable)
                                            )
                                  )
                        )
        INTO	xPrevBenef
        FROM    (   SELECT  idpoliza,
                            idetpol,
                            cod_asegurado,
                            benef,
                            nombre,
                            OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PARENT', codparent) PARENTESCO,
                            porcepart,
                            OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', estado) ESTADO,
                            indirrevocable,
                            ROW_NUMBER() OVER (ORDER BY cod_asegurado) registro
                    FROM    BENEFICIARIO
                    WHERE   cod_asegurado   = nCodAsegurado
                    AND     idpoliza        = nIdPoliza
                    AND     idetpol         = nIdetPol
                ) 
        WHERE   registro BETWEEN nLimInferior AND nLimSuperior;

        -- Total de regs. obtenidos
        SELECT  NVL(COUNT(*),0)
        INTO    nTotRegs
        FROM    BENEFICIARIO
        WHERE   cod_asegurado   = nCodAsegurado
        AND     idpoliza        = nIdPoliza
        AND     idetpol         = nIdetPol;

   END;

   SELECT XMLROOT (xPrevBenef, VERSION '1.0" encoding="UTF-8')
     INTO xListadoBeneficiario
     FROM DUAL;
   RETURN xListadoBeneficiario;

END LISTADO_BENEFICIARIO;        

FUNCTION CONSULTA_BENEFICIARIO(  nCodAsegurado  NUMBER, nIdPoliza  NUMBER,	nIdetPol    NUMBER,  nBenef  NUMBER  )
RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 13/01/2021                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : CONSULTA_BENEFICIARIO                                                                                            |
    | Objetivo   : Funcion que consulta y obtiene informacion detallada de los Beneficiarios que cumplen con los criterios dados    |
    |               desdela Plataforma Digital y genera la salida en formato XML.                                                   |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodAsegurado		Numero de la Factura	            (Entrada)                                                   |
    |			nIdPoliza           ID de la Poliza                     (Entrada)                                                   |
    |			nIdetPol			Codigo de la Compañia	            (Entrada)                                                   |
    |			nBenef              Numero de beneficiarios de interes  (Entrada)                                                   |    
    |_______________________________________________________________________________________________________________________________|
*/ 
xBeneficiario   XMLTYPE;
xPrevBenef      XMLTYPE; 
BEGIN
   BEGIN
        --> Consulta
	    SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("BENEFICIARIOS",  
                                                XMLELEMENT("IdPoliza", IdPoliza),
                                                XMLELEMENT("IDetPol", IDetPol),
                                                XMLELEMENT("CodAsegurado", Cod_Asegurado),
                                                XMLELEMENT("Benef", benef),
                                                XMLELEMENT("Nombre", nombre),
                                                XMLELEMENT("PorcParticipacion", porcepart),
                                                XMLELEMENT("CodParent", codparent),                                                
                                                XMLELEMENT("Parentesco", parentesco),
                                                XMLELEMENT("Estado", estado),
                                                XMLELEMENT("DescEstado", desc_estado),
                                                XMLELEMENT("Sexo", sexo),
                                                XMLELEMENT("FecNac", fecnac),
                                                XMLELEMENT("FecEstado", fecestado),
                                                XMLELEMENT("FecAlta", fecalta),
                                                XMLELEMENT("FecBaja", fecbaja),
                                                XMLELEMENT("MotivoBaja", motbaja),
                                                XMLELEMENT("DesMotivoBaja", Desc_Motivo_Baja),
                                                XMLELEMENT("Observaciones", obervaciones),
                                                XMLELEMENT("IndIrrevocable", indirrevocable)
                                            )
                                  )
                        )
        INTO	xPrevBenef
        FROM    (   SELECT  idpoliza,
                            idetpol,
                            cod_asegurado,
                            benef,
                            nombre,
                            porcepart,
                            codparent,
                            OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PARENT', codparent) PARENTESCO,
                            estado,
                            OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', estado) DESC_ESTADO,
                            sexo,
                            fecnac,
                            fecestado,
                            fecalta,
                            fecbaja,
                            motbaja,
                            OC_VALORES_DE_LISTAS.BUSCA_LVALOR('MOTBAJA', motbaja) DESC_MOTIVO_BAJA,
                            obervaciones,
                            indirrevocable
                    FROM    BENEFICIARIO
                    WHERE   cod_asegurado   = nCodAsegurado
                    AND     idpoliza        = nIdPoliza
                    AND     idetpol         = nIdetPol
                    AND     benef           = nBenef
                );

      EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'El Asegurado '||nCodAsegurado||' no existente en Base de Datos.'); 
   END;

   SELECT 	XMLROOT (xPrevBenef, VERSION '1.0" encoding="UTF-8')
   INTO		xBeneficiario
   FROM 	DUAL;

   RETURN xBeneficiario;

END CONSULTA_BENEFICIARIO;

END OC_BENEFICIARIOS_SERVICIOS_WEB;

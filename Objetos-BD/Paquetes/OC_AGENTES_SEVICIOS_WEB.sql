create or replace PACKAGE          OC_AGENTES_SEVICIOS_WEB AS

FUNCTION JERARQ_AGENTE( nCodAgente	NUMBER,	nCodCia	NUMBER,	nCodEmpresa	NUMBER--, cStsAgnte	VARCHAR2, dFechaAlta  DATE
                        )
RETURN XMLTYPE;

END OC_AGENTES_SEVICIOS_WEB;
/
create or replace PACKAGE BODY          OC_AGENTES_SEVICIOS_WEB AS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 21/12/2020                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    | Nombre     : OC_AGENTES_SEVICIOS_WEB                                                                                          |
    | Objetivo   : Package obtiene la jerarquia y detalles de los Agentes que cumplen con los criterios dados en los Servicios WEB  |
    |              de la Plataforma Digital, los resultados son generados en formato XML.                                           |
    | Modificado : Si                                                                                                               |
    | Ult. Modif.: 07/01/2021                                                                                                       |
    | Modifico   : J. Alberto Lopez Valle (JALV)                                                                                    |
    | Obj. Modif.: Se quita restriccion del Status del agente a solo activo (ACT) y se agrega Nombre del ejecutivo segun su codigo. |
    |_______________________________________________________________________________________________________________________________|
*/ 

FUNCTION JERARQ_AGENTE( nCodAgente	NUMBER,	nCodCia	NUMBER,	nCodEmpresa	NUMBER--, cStsAgnte	VARCHAR2, dFechaAlta  DATE 
							)
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
                            XMLELEMENT("Jerarquia",SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, '/'),2)),         -- SUBSTR(SYS_CONNECT_BY_PATH(A.cod_agente, ' --> '),6) RECORRIDO, 
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
        --AND     A.fecalta     = TO_DATE (dFechaAlta, 'DD/MM/YY')
        AND     A.codcia      = nCodCia
        AND     A.codempresa  = nCodEmpresa        
        START WITH A.cod_agente  = nCodAgente  --> Origen de Jerarquia (desde donde empiezo)
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


END OC_AGENTES_SEVICIOS_WEB;

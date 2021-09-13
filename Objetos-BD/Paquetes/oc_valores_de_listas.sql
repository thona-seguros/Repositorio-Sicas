CREATE OR REPLACE PACKAGE SICAS_OC.OC_VALORES_DE_LISTAS IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : N/A                                                                                                              |    
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: ???                                                                                                              | 
	| Nombre     : OC_VALORES_DE_LISTAS                                                                                             |
    | Objetivo   : Package que obtiene los valores o descripciones de los Valores de Lista segun sea el caso o funcion invocada     |
    |              desde Plataforma Digital.                                                                                        |
    | Modificado : Si                                                                                                               |
    | Ult. modif.: 23/08/2021                                                                                                       |
    | Modifico   : J. Alberto Lopez Valle   [ JALV ]                                                                                |
    | Email      : alopez@thonaseguros.mx                                                                                           |
    |                                                                                                                               |
    | Obj. Modif.: Se agrego funcion que genera Catalogo de Valores segun CodLista solicitado.                                      |
    |                                                                                                                               |
    | Dependencias:                                                                                                                 |
    |			STANDARD			(Package)                                                                                       |
    |			VALORES_DE_LISTAS   (Table)                                                                                         |
    |_______________________________________________________________________________________________________________________________|
	
*/  

  FUNCTION BUSCA_LVALOR(cCodLista VARCHAR2, cCodValor VARCHAR2) RETURN VARCHAR2;

  FUNCTION BUSCA_VALORDESC(cCodLista VARCHAR2, cDescValLst VARCHAR2) RETURN VARCHAR2;
  
  FUNCTION BUSCA_CAT_VALOR(cCodLista VARCHAR2) RETURN XMLTYPE;  --> JALV(+) 23/08/2021

END OC_VALORES_DE_LISTAS;
/

--
-- OC_VALORES_DE_LISTAS  (Package Body) 
--
--  Dependencies: 
--   OC_VALORES_DE_LISTAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_VALORES_DE_LISTAS IS


FUNCTION BUSCA_LVALOR(cCodLista VARCHAR2, cCodValor VARCHAR2) RETURN VARCHAR2 IS
cDescripcion    VALORES_DE_LISTAS.DescValLst%TYPE;
BEGIN
   BEGIN
      SELECT DescValLst
        INTO cDescripcion
        FROM VALORES_DE_LISTAS
       WHERE CodLista = cCodLista
         AND CodValor = cCodValor;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescripcion := 'Invalida';
   END;
   RETURN(cDescripcion);
END BUSCA_LVALOR;

FUNCTION BUSCA_VALORDESC(cCodLista VARCHAR2, cDescValLst VARCHAR2) RETURN VARCHAR2 IS
cCodValor    VALORES_DE_LISTAS.CodValor%TYPE;
BEGIN
   BEGIN
      SELECT CodValor
        INTO cCodValor
        FROM VALORES_DE_LISTAS
       WHERE CodLista   = cCodLista
         AND DescValLst = cDescValLst;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodValor := 'NO EXISTE';
   END;
   RETURN(cCodValor);
END BUSCA_VALORDESC;

FUNCTION BUSCA_CAT_VALOR(cCodLista VARCHAR2) RETURN XMLTYPE IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 23/08/2020                                                                                                       |
    | Email      : alopez@thonaseguros.mx                                                                                           |
	| Nombre     : BUSCA_CAT_VALOR	                                                                                                |
    | Objetivo   : Funcion que consulta, obtiene informacion del Catalogo de Valores que coincidan con el criterio dado de CodLista |
    |              desde la Plataforma Digital y genera la salida en formato XML.                                                   |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    |                                                                                                                               |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
	|           cCodLista			Codigo de Lista                 (Entrada)                                                       | 
    |_______________________________________________________________________________________________________________________________|
	
*/ 
xCat_Valores    XMLTYPE;
xPrevValores    XMLTYPE;

BEGIN
   BEGIN
      SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("CAT_VALORES",  
                                                XMLELEMENT("CodValor", CodValor),
                                                XMLELEMENT("DescValLst", DescValLst)
                                            )
                                  )
                        )
        INTO xPrevValores
        FROM VALORES_DE_LISTAS
       WHERE CodLista   = cCodLista;
       
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'No existen valores coincidentes para el codigo de Lista '||cCodLista); 
   END;
   SELECT XMLROOT (xPrevValores, VERSION '1.0" encoding="UTF-8')
     INTO xCat_Valores
     FROM DUAL;
   
   RETURN xCat_Valores;
   
END BUSCA_CAT_VALOR;

END OC_VALORES_DE_LISTAS;
/

--
-- OC_VALORES_DE_LISTAS  (Synonym) 
--
--  Dependencies: 
--   OC_VALORES_DE_LISTAS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_VALORES_DE_LISTAS FOR SICAS_OC.OC_VALORES_DE_LISTAS
/


GRANT EXECUTE ON SICAS_OC.OC_VALORES_DE_LISTAS TO PUBLIC
/

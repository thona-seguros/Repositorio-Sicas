DROP PACKAGE OC_FLUJOS_OPERACION
/

--
-- OC_FLUJOS_OPERACION  (Package) 
--
CREATE OR REPLACE PACKAGE OC_FLUJOS_OPERACION AS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |    
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 17/Feb/2022                                                                                                      |    
	| Nombre     : OC_FLUJOS_OPERACION                                                                                              |
    | Objetivo   : Paquete que realiza las diferentes acciones para el uso de los Flujo validos para Siniestros.                    |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    |_______________________________________________________________________________________________________________________________|
*/
FUNCTION EXISTE_FLUJO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFlujo NUMBER) RETURN VARCHAR2;
FUNCTION DESCRIPCION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFlujo NUMBER) RETURN VARCHAR2;
PROCEDURE ACTUALIZA_ESTATUS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFlujo NUMBER, cSts VARCHAR2);

END OC_FLUJOS_OPERACION;

/

--
-- OC_FLUJOS_OPERACION  (Synonym) 
--
CREATE OR REPLACE PUBLIC SYNONYM OC_FLUJOS_OPERACION FOR OC_FLUJOS_OPERACION
/


GRANT EXECUTE ON OC_FLUJOS_OPERACION TO PUBLIC
/
DROP PACKAGE BODY OC_FLUJOS_OPERACION
/

--
-- OC_FLUJOS_OPERACION  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY OC_FLUJOS_OPERACION AS
FUNCTION EXISTE_FLUJO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFlujo NUMBER)
RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |    
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 17/Feb/2022                                                                                                      |    
	| Nombre     : EXISTE_FLUJO                                                                                                     |
    | Objetivo   : Funcion que valida la existencia del Flujo dado en el catalogo de Tipos de tipos de trámite aplicable a la       |
    |              operacion de Siniestros que corresponda.                                                                         |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia				Codigo de la Compañia	    (Entrada)                                                           |
    |			nCodEmpresa			Codigo de la Empresa	    (Entrada)                                                           |
    |           cCodFlujo           Codigo de Tramite o Ramo    (Entrada)                                                           |
    |_______________________________________________________________________________________________________________________________|
*/
cExiste  VARCHAR2(1);
BEGIN
  BEGIN
        SELECT  'S'
        INTO    cExiste
        FROM    FLUJOS_OPERACION
        WHERE   CodCia      = nCodCia
        AND     CodEmpresa  = nCodEmpresa
        --AND     CodFlujo    = cCodFlujo
        AND     IdFlujo    = nIdFlujo;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
        cExiste := 'N';
     WHEN TOO_MANY_ROWS THEN
        cExiste := 'S';
  END;
  RETURN(cExiste);
END EXISTE_FLUJO;

FUNCTION DESCRIPCION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFlujo NUMBER)
RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 17/Feb/2022                                                                                                      |
	| Nombre     : DESCRIPCION                                                                                                      |
    | Objetivo   : Funcion que obtiene la descripcion del Flujo aplicable a la operacion de Siniestros que corresponda.             |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia				Codigo de la Compañia	    (Entrada)                                                           |
    |			nCodEmpresa			Codigo de la Empresa	    (Entrada)                                                           |
    |           cCodFlujo           Codigo de Tramite o Ramo    (Entrada)                                                           |
    |_______________________________________________________________________________________________________________________________|
*/
cNomFlujo FLUJOS_OPERACION.NomFlujo%TYPE;
BEGIN
   BEGIN
        SELECT  NVL(NomFlujo,'NO EXISTE')
        INTO    cNomFlujo
        FROM    FLUJOS_OPERACION
        WHERE   CodCia      = nCodCia
        AND     CodEmpresa  = nCodEmpresa
        --AND     CodFlujo    = cCodFlujo
        AND     IdFlujo    = nIdFlujo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         cNomFlujo := 'NO EXISTE';
   END; 
   RETURN cNomFlujo;
END DESCRIPCION;

PROCEDURE ACTUALIZA_ESTATUS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFlujo NUMBER, cSts VARCHAR2) IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |    
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 17/Feb/2022                                                                                                      |    
	| Nombre     : ACTUALIZA_ESTATUS                                                                                                |
    | Objetivo   : Procedimiento que actualiza el Estado del Flujo aplicable a la operacion de Siniestros que corresponda.          |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia				Codigo de la Compañia	                (Entrada)                                               |
    |			nCodEmpresa			Codigo de la Empresa	                (Entrada)                                               |
    |           cCodFlujo           Codigo de Tramite o Ramo                (Entrada)                                               |
    |           cSts                Valor del Estado actual a Modificar     (Entrada)                                               |
    |_______________________________________________________________________________________________________________________________|
*/
BEGIN
    UPDATE  FLUJOS_OPERACION
    SET     StsFlujo          = cSts,
            FecUltActualiza   = TRUNC(SYSDATE),
            userultactualiza  = USER
    WHERE   CodCia      = nCodCia
    AND     CodEmpresa  = nCodEmpresa
    --AND     CodFlujo    = cCodFlujo
    AND     IdFlujo     = nIdFlujo;
    --AND     StsFlujo    = cStsIni;
END ACTUALIZA_ESTATUS;

END OC_FLUJOS_OPERACION;

/

--
-- OC_FLUJOS_OPERACION  (Synonym) 
--
CREATE OR REPLACE PUBLIC SYNONYM OC_FLUJOS_OPERACION FOR OC_FLUJOS_OPERACION
/


GRANT EXECUTE ON OC_FLUJOS_OPERACION TO PUBLIC
/

CREATE OR REPLACE PACKAGE OC_TIPOS_TRAMITE AS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |    
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 17/Feb/2022                                                                                                      |    
	| Nombre     : OC_TIPOS_TRAMITE                                                                                                 |
    | Objetivo   : Paquete que realiza las diferentes acciones para el uso de los tipos de Trámites validos para Siniestros.        |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    |_______________________________________________________________________________________________________________________________|
*/
FUNCTION EXISTE_TRAMITE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdFlujo NUMBER, nIdTramite NUMBER) RETURN VARCHAR2;
FUNCTION DESCRIPCION(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdFlujo NUMBER, nIdTramite NUMBER) RETURN VARCHAR2;
PROCEDURE ACTUALIZA_ESTATUS(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdFlujo NUMBER, nIdTramite NUMBER, cSts IN VARCHAR2);
FUNCTION GENERA_FOLIO (nCodCia  IN NUMBER,  nCodEmpresa IN NUMBER, nIdFlujo IN NUMBER, nIdTramite IN NUMBER) RETURN VARCHAR2;
END OC_TIPOS_TRAMITE;


/

CREATE OR REPLACE PACKAGE BODY OC_TIPOS_TRAMITE AS
FUNCTION EXISTE_TRAMITE(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdFlujo NUMBER, nIdTramite NUMBER)
RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |    
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 17/Feb/2022                                                                                                      |    
	| Nombre     : EXISTE_TRAMITE                                                                                                   |
    | Objetivo   : Funcion que valida la existencia del Tramite dado en el catalogo de Tipos de tipos de trámite aplicable a la     |
    |              operacion de Siniestros que corresponda.                                                                         |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia				Codigo de la Compañia	    (Entrada)                                                           |
    |			nCodEmpresa			Codigo de la Empresa	    (Entrada)                                                           |
    |           cCodTramite         Codigo de Tramite o Ramo    (Entrada)                                                           |
    |_______________________________________________________________________________________________________________________________|
*/
cExiste  VARCHAR2(1);
BEGIN
  BEGIN
        SELECT  'S'
        INTO    cExiste
        FROM    TIPOS_TRAMITE
        WHERE   CodCia      = nCodCia
        AND     CodEmpresa  = nCodEmpresa
        --AND     CodFlujo    = cCodFlujo
        --AND     CodTramite  = cCodTramite
        AND     IdFlujo    = nIdFlujo
        AND     IdTramite  = nIdTramite;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
        cExiste := 'N';
     WHEN TOO_MANY_ROWS THEN
        cExiste := 'S';
  END;
  RETURN(cExiste);
END EXISTE_TRAMITE;

FUNCTION DESCRIPCION(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdFlujo NUMBER, nIdTramite NUMBER)
RETURN VARCHAR2 IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 17/Feb/2022                                                                                                      |
	| Nombre     : DESCRIPCION                                                                                                      |
    | Objetivo   : Funcion que obtiene la descripcion del tipo de trámite aplicable a la operacion de Siniestros que corresponda.   |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia				Codigo de la Compañia	    (Entrada)                                                           |
    |			nCodEmpresa			Codigo de la Empresa	    (Entrada)                                                           |
    |           cCodTramite         Codigo de Tramite o Ramo    (Entrada)                                                           |
    |_______________________________________________________________________________________________________________________________|
*/
cNomTramite TIPOS_TRAMITE.NomTramite%TYPE;
BEGIN
   BEGIN
        SELECT  NVL(NomTramite,'NO EXISTE')
        INTO    cNomTramite
        FROM    TIPOS_TRAMITE
        WHERE   CodCia      = nCodCia
        AND     CodEmpresa  = nCodEmpresa
        --AND     CodFlujo    = cCodFlujo
        --AND     CodTramite  = cCodTramite
        AND     IdFlujo     = nIdFlujo
        AND     IdTramite   = nIdTramite;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         cNomTramite := 'NO EXISTE';
   END; 
   RETURN cNomTramite;
END DESCRIPCION;

PROCEDURE ACTUALIZA_ESTATUS(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdFlujo NUMBER, nIdTramite NUMBER, cSts IN VARCHAR2) IS
/*   _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |    
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 17/Feb/2022                                                                                                      |    
	| Nombre     : ACTUALIZA_ESTATUS                                                                                                |
    | Objetivo   : Procedimiento que actualiza el Estado del Tipo de Trámite aplicable a la operacion de Siniestros que corresponda.|
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia				Codigo de la Compañia	                (Entrada)                                               |
    |			nCodEmpresa			Codigo de la Empresa	                (Entrada)                                               |
    |           cCodTramite         Codigo de Tramite o Ramo                (Entrada)                                               |
    |           cSts                Valor del Estado actual a Modificar     (Entrada)                                               |
    |_______________________________________________________________________________________________________________________________|
*/
BEGIN
   UPDATE TIPOS_TRAMITE
      SET StsTipTram        = cSts,
          FecUltActualiza   = TRUNC(SYSDATE),
          userultactualiza  = USER
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      --AND     CodFlujo    = cCodFlujo
      --AND     CodTramite  = cCodTramite
      AND IdFlujo    = nIdFlujo
      AND IdTramite  = nIdTramite;
      --AND StsTipTram = cStsIni
END ACTUALIZA_ESTATUS;

FUNCTION GENERA_FOLIO (nCodCia  IN NUMBER,  nCodEmpresa IN NUMBER, nIdFlujo IN NUMBER, nIdTramite IN NUMBER)
RETURN VARCHAR2 IS
 /*  _______________________________________________________________________________________________________________________________	
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle   [ JALV ]                                                                                |
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 17/02/2022                                                                                                       |    
	| Nombre     : GENERA_FOLIO                                                                                                     |
    | Objetivo   : Funcion que construye el Folio usado en la operación de flujos varios para Plataforma Digital.                   |
    | Modificado : No                                                                                                               |
    | Ult. modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |			nCodCia				Codigo de la Compañia	        (Entrada)                                                       |
    |           nCodEmpresa         Codigo de Empresa               (Entrada)                                                       |
    |           cCodTramite         Codigo de Tramite o Ramo        (Entrada)                                                       |
    |_______________________________________________________________________________________________________________________________|
*/
cFolioOper      VARCHAR2(100);
cCodFlujo       FLUJOS_OPERACION.CodFlujo%TYPE;
cCodTramite     TIPOS_TRAMITE.CodTramite%TYPE;
cFolio          NUMBER;

BEGIN
    -- Obtencion Codigo Abreviado del Flujo
    IF OC_FLUJOS_OPERACION.EXISTE_FLUJO(nCodCia, nCodEmpresa, nIdFlujo) = 'S' THEN
        SELECT  CodFlujo
        INTO    cCodFlujo
        FROM    FLUJOS_OPERACION
        WHERE   StsFlujo   = 'ACT'
        and     CodCia     = nCodCia
        AND     CodEmpresa = nCodEmpresa
        AND     IdFlujo    = nIdFlujo;
    ELSE
        --cFolioOper := 'Error: El Flujo No Existe o no esta Activo. Por Favor Valide.';
        RAISE_APPLICATION_ERROR (-20100,'Error: El Flujo No Existe o no esta Activo. Por Favor Valide.');
    END IF;

    -- Obtencion Codigo Abreviado del Trámite
    IF OC_TIPOS_TRAMITE.EXISTE_TRAMITE(nCodCia, nCodEmpresa, nIdFlujo, nIdTramite) = 'S' THEN        
        SELECT  CodTramite
        INTO    cCodTramite
        FROM    TIPOS_TRAMITE
        WHERE   StsTipTram = 'ACT'
        and     CodCia     = nCodCia
        AND     CodEmpresa = nCodEmpresa
        AND     IdFlujo    = nIdFlujo
        AND     IdTramite  = nIdTramite;
    ELSE
        RAISE_APPLICATION_ERROR (-20100,'Error: No Existe Trámite asociado con este Flujo o no esta Activo. Por Favor Valide.');
    END IF;

    -- Obtengo Consecutivo de Folio        
    --cFolio := OC_FLUJOS_FOLIOS.FOLIO(nCodCia, nCodempresa, cCodFlujo, cCodTramite);
    cFolio := OC_FLUJOS_FOLIOS.FOLIO(nCodCia, nCodempresa, nIdFlujo, cCodFlujo, nIdTramite, cCodTramite);
    -- Construyo Folio para Siniestro
    cFolioOper := cCodFlujo||'-'||cCodTramite||'-'||TO_CHAR(TRUNC(SYSDATE),'RRRRMMDD')||'-'||LPAD(cFolio,5,0);

   RETURN cFolioOper;   
END GENERA_FOLIO;

END OC_TIPOS_TRAMITE;

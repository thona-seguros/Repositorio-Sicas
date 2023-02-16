CREATE OR REPLACE PACKAGE OC_FLUJOS_FOLIOS IS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle                                                                                           |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 16/02/2022                                                                                                       |
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Nombre     : OC_FLUJOS_FOLIOS                                                                                             |
    | Version    : 1.0                                                                                                              |
    | Objetivo   : Package que realiza las acciones relacionadas con los Folios de operación de Siniestros.                         |
    | Modificado : No                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |_______________________________________________________________________________________________________________________________|
*/ 
   --FUNCTION FOLIO(nCodCia IN NUMBER, nCodempresa IN NUMBER,                   cCodFlujo IN VARCHAR2,                       cCodTramite IN VARCHAR2) RETURN NUMBER;
   FUNCTION FOLIO(nCodCia IN NUMBER, nCodempresa IN NUMBER, nIdFlujo IN NUMBER, cCodFlujo IN VARCHAR2, nIdTramite IN NUMBER, cCodTramite IN VARCHAR2) RETURN NUMBER;
   FUNCTION ULTIMO_FOLIO (nCodCia IN NUMBER, nCodempresa IN NUMBER, cCodFlujo IN VARCHAR2, cCodTramite IN VARCHAR2) RETURN NUMBER;
   PROCEDURE ACTUALIZA_FOLIO (nCodCia IN NUMBER, nCodempresa IN NUMBER, cCodFlujo IN VARCHAR2, cCodTramite IN VARCHAR2, nFolio IN NUMBER);
   FUNCTION FECHA_INICIO_VIGENCIA (nCodCia IN NUMBER, nCodempresa IN NUMBER, cCodFlujo IN VARCHAR2, cCodTramite IN VARCHAR2) RETURN DATE;
   FUNCTION FECHA_FIN_VIGENCIA (nCodCia IN NUMBER, nCodempresa IN NUMBER, cCodFlujo IN VARCHAR2, cCodTramite IN VARCHAR2) RETURN DATE;
--   FUNCTION EMPALMA_VIGENCIAS(nCodCia IN NUMBER, nCodempresa IN NUMBER, cCodFlujo IN VARCHAR2, cCodTramite IN VARCHAR2, dFecIniVig IN DATE, dFecFinVig IN DATE) RETURN VARCHAR2; 
END OC_FLUJOS_FOLIOS;


/

CREATE OR REPLACE PACKAGE BODY OC_FLUJOS_FOLIOS AS
FUNCTION FOLIO(nCodCia IN NUMBER, nCodEmpresa IN NUMBER, nIdFlujo IN NUMBER, cCodFlujo IN VARCHAR2, nIdTramite IN NUMBER, cCodTramite IN VARCHAR2) RETURN NUMBER IS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 16/02/2022                                                                                                       |
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Nombre     : FOLIO                                                                                                            |
    | Objetivo   : Funcion que obtiene el folio unico para cada Tipo de tramite o Ramo. Los folios son asignados de forma separada  |
    |              (independiente) para cada Tipo de tramite o Ramo. Cuando es cambio de año de forma automatica reinicia           |
    |              contadores de folio para cada tipo de tramite o Ramo. Genera la salida numerica.                                 |
    | Modificado : No                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia				Codigo de la Compañia	    (Entrada)                                                           |
    |			nCodEmpresa			Codigo de la Empresa	    (Entrada)                                                           |
    |           nIdTramite          Codigo de Tramite o Ramo    (Entrada)                                                           |
    |_______________________________________________________________________________________________________________________________|
*/
PRAGMA AUTONOMOUS_TRANSACTION;
nFolio  FLUJOS_FOLIOS.ConsecFolio%TYPE;
BEGIN  
  IF OC_FLUJOS_OPERACION.EXISTE_FLUJO(nCodCia, nCodEmpresa, nIdFlujo) = 'S' AND OC_TIPOS_TRAMITE.EXISTE_TRAMITE(nCodCia, nCodEmpresa, nIdFlujo, nIdTramite) = 'S' THEN 
      BEGIN
          SELECT NVL(MAX(ConsecFolio),0) + 1
            INTO nFolio
            FROM FLUJOS_FOLIOS
           WHERE CodCia     = nCodCia
             AND CodEmpresa = nCodEmpresa
             AND IdFlujo    = nIdFlujo
             AND CodFlujo   = cCodFlujo
             AND IdTramite  = nIdTramite
             AND CodTramite = cCodTramite
             AND TRUNC(SYSDATE) BETWEEN FecIniVig AND FecFinVig;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR (-20100,'Error: No es posible determinar el Folio para el flujo '''||cCodFlujo||''' y Tramite o Ramo: '''||cCodTramite||''' Por Favor Valide.');
      END;
      IF nFolio = 1 THEN
        INSERT INTO FLUJOS_FOLIOS (CodCia, CodEmpresa, IdFlujo, CodFlujo, IdTramite, CodTramite, ConsecFolio, FecIniVig, FecFinVig, FecRegistro, UserRegistro)
                            VALUES(nCodCia, nCodEmpresa, nIdFlujo, cCodFlujo, nIdTramite, cCodTramite, nFolio, TRUNC(SYSDATE, 'Year'), (ADD_MONTHS(TRUNC(SYSDATE,'Year'),+11))+30, TRUNC(SYSDATE), USER);
        ELSE
          UPDATE FLUJOS_FOLIOS
             SET ConsecFolio       = nFolio,
                FecUltActualiza    = TRUNC(SYSDATE),
                UserUltActualiza   = USER
           WHERE CodCia     = nCodCia
             AND CodEmpresa = nCodEmpresa
             AND IdFlujo    = nIdFlujo
             AND CodFlujo   = cCodFlujo
             AND IdTramite  = nIdTramite
             AND CodTramite = cCodTramite
             AND TRUNC(SYSDATE) BETWEEN FecIniVig AND FecFinVig;
        END IF;
      COMMIT;
  ELSE
        RAISE_APPLICATION_ERROR (-20100,'Error: No es posible determinar un Folio para el Flujo '''||cCodFlujo||''' y Tipo de Trámite o Ramo: '''||cCodTramite||''' porque no existe. Por favor valide.');
  END IF;
  RETURN nFolio;
END FOLIO;

FUNCTION ULTIMO_FOLIO(nCodCia IN NUMBER, nCodempresa IN NUMBER, cCodFlujo IN VARCHAR2, cCodTramite IN VARCHAR2) RETURN NUMBER IS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 16/02/2022                                                                                                       |
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Nombre     : ULTIMO_FOLIO                                                                                                     |
    | Objetivo   : Funcion que obtiene el ultimo folio existente del Tipo de tramite o Ramo solicitado.                             |
    | Modificado : No                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia				Codigo de la Compañia	    (Entrada)                                                           |
    |			nCodEmpresa			Codigo de la Empresa	    (Entrada)                                                           |
    |           nIdTramite          Codigo de Tramite o Ramo    (Entrada)                                                           |
    |_______________________________________________________________________________________________________________________________|
*/
nFolio  FLUJOS_FOLIOS.ConsecFolio%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MAX(ConsecFolio),0)
        INTO nFolio
        FROM FLUJOS_FOLIOS
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND CodFlujo       = cCodFlujo
         AND CodTramite     = cCodTramite
         AND TRUNC(SYSDATE) BETWEEN FecIniVig AND FecFinVig;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR (-20100,'Error: No es posible determinar el folio, por favor valide.');
   END;
   RETURN nFolio;
END ULTIMO_FOLIO;

PROCEDURE ACTUALIZA_FOLIO (nCodCia IN NUMBER, nCodempresa IN NUMBER, cCodFlujo IN VARCHAR2, cCodTramite IN VARCHAR2, nFolio IN NUMBER) IS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 16/02/2022                                                                                                       |
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Nombre     : ACTUALIZA_FOLIO                                                                                                  |
    | Objetivo   : Funcion que actualiza el folio existente para el Tipo de tramite o Ramo solicitados.                             |
    | Modificado : No                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia				Codigo de la Compañia	    (Entrada)                                                           |
    |			nCodEmpresa			Codigo de la Empresa	    (Entrada)                                                           |
    |           nIdTramite          Codigo de Tramite o Ramo    (Entrada)                                                           |
    |           nFolio              Nuevo Valor del Folio       (Entrada)                                                           |
    |_______________________________________________________________________________________________________________________________|
*/
BEGIN
   UPDATE FLUJOS_FOLIOS
      SET ConsecFolio = nFolio
    WHERE CodCia        = nCodCia
     AND  CodEmpresa    = nCodEmpresa
     AND  CodFlujo      = cCodFlujo
     AND  CodTramite    = cCodTramite;

     EXCEPTION
      WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR (-20100,'Error: No es posible actualizar el folio, por favor valide.');
END ACTUALIZA_FOLIO;

FUNCTION FECHA_INICIO_VIGENCIA (nCodCia IN NUMBER, nCodempresa IN NUMBER, cCodFlujo IN VARCHAR2, cCodTramite IN VARCHAR2) RETURN DATE IS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 16/02/2022                                                                                                       |
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Nombre     : FECHA_INICIO_VIGENCIA                                                                                            |
    | Objetivo   : Funcion que obtiene el la fecha de inicia de Vigencia del Tipo de tramite o Ramo solicitado.                     |
    | Modificado : No                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia				Codigo de la Compañia	    (Entrada)                                                           |
    |			nCodEmpresa			Codigo de la Empresa	    (Entrada)                                                           |
    |           nIdTramite          Codigo de Tramite o Ramo    (Entrada)                                                           |
    |_______________________________________________________________________________________________________________________________|
*/
dFecIniVig FLUJOS_FOLIOS.FecIniVig%TYPE;
BEGIN
   BEGIN
        SELECT  FecIniVig
        INTO    dFecIniVig
        FROM    FLUJOS_FOLIOS
        WHERE   CodCia      = nCodCia
        AND     CodEmpresa  = nCodEmpresa
        AND     CodFlujo    = cCodFlujo
        AND     CodTramite  = cCodTramite;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR (-20100,'Error: No es posible determinar la Fecha de Inicio de Vigencia del folio, por favor valide.');
   END;
   RETURN dFecIniVig;
END FECHA_INICIO_VIGENCIA;

FUNCTION FECHA_FIN_VIGENCIA (nCodCia IN NUMBER, nCodempresa IN NUMBER, cCodFlujo IN VARCHAR2, cCodTramite IN VARCHAR2) RETURN DATE IS
/*   _______________________________________________________________________________________________________________________________
    |                                                                                                                               |
    |                                                           HISTORIA                                                            |
    | Elaboro    : J. Alberto Lopez Valle									                                                        |
    | Para       : THONA Seguros                                                                                                    |
    | Fecha Elab.: 16/02/2022                                                                                                       |
    | Email      : alopez@thonaseguros.mx  / alvalle007@hotmail.com / alvalle007@gmail.com                                          |
    | Nombre     : FECHA_INICIO_VIGENCIA                                                                                            |
    | Objetivo   : Funcion que obtiene el la fecha de fin de Vigencia del Tipo de tramite o Ramo solicitado.                        |
    | Modificado : No                                                                                                               |
    | Ult. Modif.: N/A                                                                                                              |
    | Modifico   : N/A                                                                                                              |
    | Obj. Modif.: N/A                                                                                                              |
    |                                                                                                                               |
    | Parametros:                                                                                                                   |
    |           nCodCia				Codigo de la Compañia	    (Entrada)                                                           |
    |			nCodEmpresa			Codigo de la Empresa	    (Entrada)                                                           |
    |           nIdTramite          Codigo de Tramite o Ramo    (Entrada)                                                           |
    |_______________________________________________________________________________________________________________________________|
*/
dFecFinVig FLUJOS_FOLIOS.FecFinVig%TYPE;
BEGIN
   BEGIN
        SELECT  FecFinVig
        INTO    dFecFinVig
        FROM    FLUJOS_FOLIOS
        WHERE   CodCia      = nCodCia
        AND     CodEmpresa  = nCodEmpresa
        AND     CodFlujo    = cCodFlujo
        AND     CodTramite  = cCodTramite;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR (-20100,'Error: No es posible determinar la Fecha de Fin de Vigencia del folio, por favor valide.');
   END;
   RETURN dFecFinVig;
END FECHA_FIN_VIGENCIA;

END OC_FLUJOS_FOLIOS;

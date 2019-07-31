--
-- GT_REA_ESQUEMAS_POLIZAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   GT_REA_ESQUEMAS_POLIZA_COBERT (Package)
--   REA_ESQUEMAS_POLIZAS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_REA_ESQUEMAS_POLIZAS IS

  FUNCTION EXISTEN_POLIZAS_EN_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2;
  FUNCTION ESQUEMA_POLIZA(nCodCia NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;
  FUNCTION POLIZA_EN_OTRO_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdPoliza NUMBER) RETURN VARCHAR2;
  PROCEDURE ELIMINAR_POLIZAS_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2);
  FUNCTION FACTOR_CESION(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdPoliza NUMBER) RETURN NUMBER;
  PROCEDURE COPIAR_POLIZAS(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2);

END GT_REA_ESQUEMAS_POLIZAS;
/

--
-- GT_REA_ESQUEMAS_POLIZAS  (Package Body) 
--
--  Dependencies: 
--   GT_REA_ESQUEMAS_POLIZAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_REA_ESQUEMAS_POLIZAS IS

FUNCTION EXISTEN_POLIZAS_EN_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2 IS
cExistenPolizas      VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExistenPolizas
        FROM REA_ESQUEMAS_POLIZAS
       WHERE CodCia      = nCodCia
         AND CodEsquema  = cCodEsquema;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExistenPolizas := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExistenPolizas := 'S';
   END;
   RETURN(cExistenPolizas);
END EXISTEN_POLIZAS_EN_ESQUEMA;

FUNCTION ESQUEMA_POLIZA(nCodCia NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
cCodEsquema      REA_ESQUEMAS_POLIZAS.CodEsquema%TYPE;
BEGIN
   BEGIN
      SELECT CodEsquema
        INTO cCodEsquema
        FROM REA_ESQUEMAS_POLIZAS
       WHERE CodCia      = nCodCia
         AND IdPoliza    = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodEsquema := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'Póliza No. ' || nIdPoliza || ' está Asignada en más de un Esquema');
   END;
   RETURN(cCodEsquema);
END ESQUEMA_POLIZA;

FUNCTION POLIZA_EN_OTRO_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdPoliza NUMBER) RETURN VARCHAR2 IS
cExiste      VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM REA_ESQUEMAS_POLIZAS
       WHERE CodCia       = nCodCia
         AND CodEsquema  != cCodEsquema
         AND IdPoliza     = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END POLIZA_EN_OTRO_ESQUEMA;

PROCEDURE ELIMINAR_POLIZAS_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2) IS
BEGIN
    DELETE REA_ESQUEMAS_POLIZAS
     WHERE CodCia      = nCodCia
       AND CodEsquema  = cCodEsquema;
END ELIMINAR_POLIZAS_ESQUEMA;

FUNCTION FACTOR_CESION(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdPoliza NUMBER) RETURN NUMBER IS
nFactorCesion      REA_ESQUEMAS_POLIZAS.FactorCesion%TYPE;
BEGIN
   BEGIN
      SELECT FactorCesion
        INTO nFactorCesion
        FROM REA_ESQUEMAS_POLIZAS
       WHERE CodCia      = nCodCia
         AND CodEsquema  = cCodEsquema
         AND IdPoliza    = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFactorCesion := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'Póliza No. ' || nIdPoliza || ' NO Existe en Esquema ' || cCodEsquema);
   END;
   RETURN(nFactorCesion);
END FACTOR_CESION;

PROCEDURE COPIAR_POLIZAS(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2) IS
CURSOR POL_Q IS
   SELECT IdPoliza, PrimasDirectas, FactorReaseg, PrimasCedidas,
          TotalPrimasReaseg, FactorCesion, FecIngreso
     FROM REA_ESQUEMAS_POLIZAS
    WHERE CodCia     = nCodCia
      AND CodEsquema = cCodEsquemaOrig;
BEGIN
   FOR W IN POL_Q LOOP
      INSERT INTO REA_ESQUEMAS_POLIZAS
             (CodCia, CodEsquema, IdPoliza, PrimasDirectas, FactorReaseg, PrimasCedidas,
              TotalPrimasReaseg, FactorCesion, FecIngreso, CodUsuario)
      VALUES (nCodCia, cCodEsquemaDest, W.IdPoliza, W.PrimasDirectas, W.FactorReaseg, 
              W.PrimasCedidas, W.TotalPrimasReaseg, W.FactorCesion, W.FecIngreso, USER);
   END LOOP;

   GT_REA_ESQUEMAS_POLIZA_COBERT.COPIAR_COBERTURAS(nCodCia, cCodEsquemaOrig, cCodEsquemaDest);
END COPIAR_POLIZAS;

END GT_REA_ESQUEMAS_POLIZAS;
/

--
-- GT_REA_ESQUEMAS_POLIZA_COBERT  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   REA_ESQUEMAS_POLIZA_COBERT (Table)
--   COBERT_ACT (Table)
--   COBERT_ACT_ASEG (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_REA_ESQUEMAS_POLIZA_COBERT IS

  FUNCTION EXISTEN_COBERTURAS_POLIZA(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdPoliza NUMBER) RETURN VARCHAR2;
  FUNCTION CESION_DE_PRIMA(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdPoliza NUMBER, cCodCobert VARCHAR2) RETURN VARCHAR2;
  FUNCTION RECUPERACION_SINIESTRO(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdPoliza NUMBER, cCodCobert VARCHAR2) RETURN VARCHAR2;
  PROCEDURE INSERTAR_COBERTURAS_POLIZA(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdPoliza NUMBER);
  PROCEDURE ELIMINAR_COBERTURAS_POLIZA(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdPoliza NUMBER);
  PROCEDURE COPIAR_COBERTURAS(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2);

END GT_REA_ESQUEMAS_POLIZA_COBERT;
/

--
-- GT_REA_ESQUEMAS_POLIZA_COBERT  (Package Body) 
--
--  Dependencies: 
--   GT_REA_ESQUEMAS_POLIZA_COBERT (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_REA_ESQUEMAS_POLIZA_COBERT IS

FUNCTION EXISTEN_COBERTURAS_POLIZA(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdPoliza NUMBER) RETURN VARCHAR2 IS
cExistenCobert     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExistenCobert
        FROM REA_ESQUEMAS_POLIZA_COBERT
       WHERE CodCia      = nCodCia
         AND CodEsquema  = cCodEsquema
         AND IdPoliza    = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExistenCobert := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExistenCobert := 'S';
   END;
   RETURN(cExistenCobert);
END EXISTEN_COBERTURAS_POLIZA;

FUNCTION CESION_DE_PRIMA(nCodCia NUMBER, cCodEsquema VARCHAR2, 
                         nIdPoliza NUMBER, cCodCobert VARCHAR2) RETURN VARCHAR2 IS
cIndCesionPrimas      REA_ESQUEMAS_POLIZA_COBERT.IndCesionPrimas%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndCesionPrimas,'N')
        INTO cIndCesionPrimas
        FROM REA_ESQUEMAS_POLIZA_COBERT
       WHERE CodCia      = nCodCia
         AND CodEsquema  = cCodEsquema
         AND IdPoliza    = nIdPoliza
         AND CodCobert   = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndCesionPrimas := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'Cobertura ' || cCodCobert || ' Duplicada en Póliza No. ' || nIdPoliza || 
                                 ' en Esquema ' || cCodEsquema || ' para Cesión de Primas');
   END;
   RETURN(cIndCesionPrimas);
END CESION_DE_PRIMA;

FUNCTION RECUPERACION_SINIESTRO(nCodCia NUMBER, cCodEsquema VARCHAR2, 
                                nIdPoliza NUMBER, cCodCobert VARCHAR2) RETURN VARCHAR2 IS
cIndRecuperaSini      REA_ESQUEMAS_POLIZA_COBERT.IndRecuperaSini%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndRecuperaSini,'N')
        INTO cIndRecuperaSini
        FROM REA_ESQUEMAS_POLIZA_COBERT
       WHERE CodCia      = nCodCia
         AND CodEsquema  = cCodEsquema
         AND IdPoliza    = nIdPoliza
         AND CodCobert   = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndRecuperaSini := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'Cobertura ' || cCodCobert || ' Duplicada en Póliza No. ' || nIdPoliza || 
                                 ' en Esquema '|| cCodEsquema || ' para Recuperación en Siniestro');
   END;
   RETURN(cIndRecuperaSini);
END RECUPERACION_SINIESTRO;

PROCEDURE INSERTAR_COBERTURAS_POLIZA(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdPoliza NUMBER) IS
CURSOR COB_Q IS
SELECT DISTINCT CodCobert
     FROM COBERT_ACT
    WHERE StsCobertura  != 'SOL'
      AND IdPoliza       = nIdPoliza
      AND CodCia         = nCodCia
    UNION ALL
   SELECT DISTINCT CodCobert
     FROM COBERT_ACT_ASEG
    WHERE StsCobertura  != 'SOL'
      AND IdPoliza       = nIdPoliza
      AND CodCia         = nCodCia;
BEGIN
   FOR W IN COB_Q LOOP
      INSERT INTO REA_ESQUEMAS_POLIZA_COBERT
             (CodCia, CodEsquema, IdPoliza, CodCobert, IndCesionPrimas, IndRecuperaSini)
      VALUES (nCodCia, cCodEsquema, nIdPoliza, W.CodCobert, 'N', 'N');
   END LOOP;
END INSERTAR_COBERTURAS_POLIZA;

PROCEDURE ELIMINAR_COBERTURAS_POLIZA(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdPoliza NUMBER) IS
BEGIN
    DELETE REA_ESQUEMAS_POLIZA_COBERT
     WHERE CodCia      = nCodCia
       AND CodEsquema  = cCodEsquema
       AND IdPoliza    = nIdPoliza;
END ELIMINAR_COBERTURAS_POLIZA;

PROCEDURE COPIAR_COBERTURAS(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2) IS
CURSOR POL_Q IS
   SELECT IdPoliza, CodCobert, IndCesionPrimas, IndRecuperaSini
     FROM REA_ESQUEMAS_POLIZA_COBERT
    WHERE CodCia     = nCodCia
      AND CodEsquema = cCodEsquemaOrig;
BEGIN
   FOR W IN POL_Q LOOP
      INSERT INTO REA_ESQUEMAS_POLIZA_COBERT
             (CodCia, CodEsquema, IdPoliza, CodCobert, IndCesionPrimas, IndRecuperaSini)
      VALUES (nCodCia, cCodEsquemaDest, W.IdPoliza, W.CodCobert, W.IndCesionPrimas, W.IndRecuperaSini);
   END LOOP;
END COPIAR_COBERTURAS;

END GT_REA_ESQUEMAS_POLIZA_COBERT;
/

--
-- GT_REA_ESQUEMAS_POLIZA_COBERT  (Synonym) 
--
--  Dependencies: 
--   GT_REA_ESQUEMAS_POLIZA_COBERT (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_REA_ESQUEMAS_POLIZA_COBERT FOR SICAS_OC.GT_REA_ESQUEMAS_POLIZA_COBERT
/


GRANT EXECUTE ON SICAS_OC.GT_REA_ESQUEMAS_POLIZA_COBERT TO PUBLIC
/

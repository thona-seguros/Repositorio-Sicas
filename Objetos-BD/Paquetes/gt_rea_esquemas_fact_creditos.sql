--
-- GT_REA_ESQUEMAS_FACT_CREDITOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   REA_ESQUEMAS_FACT_CREDITOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_REA_ESQUEMAS_FACT_CREDITOS IS

  FUNCTION EXISTEN_FACTORES_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2;
  FUNCTION FACTOR_CREDITO(nCodCia NUMBER, cCodEsquema VARCHAR2, dFecCredito DATE) RETURN NUMBER;
  FUNCTION PERIODO_VARIABLE(nCodCia NUMBER, cCodEsquema VARCHAR2, dFecCredito DATE) RETURN NUMBER;
  PROCEDURE ELIMINAR_FACT_CREDITOS(nCodCia NUMBER, cCodEsquema VARCHAR2);
  FUNCTION PERIODO_POR_REASEGURADOR(nCodCia NUMBER, cCodEsquema VARCHAR2, dFecCredito DATE) RETURN VARCHAR2;
  PROCEDURE COPIAR_FACTORES_CREDITOS(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2);

END GT_REA_ESQUEMAS_FACT_CREDITOS;
/

--
-- GT_REA_ESQUEMAS_FACT_CREDITOS  (Package Body) 
--
--  Dependencies: 
--   GT_REA_ESQUEMAS_FACT_CREDITOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_REA_ESQUEMAS_FACT_CREDITOS IS

FUNCTION EXISTEN_FACTORES_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2 IS
cExistenFactores      VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExistenFactores
        FROM REA_ESQUEMAS_FACT_CREDITOS
       WHERE CodCia      = nCodCia
         AND CodEsquema  = cCodEsquema;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExistenFactores := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExistenFactores := 'S';
   END;
   RETURN(cExistenFactores);
END EXISTEN_FACTORES_ESQUEMA;

FUNCTION FACTOR_CREDITO(nCodCia NUMBER, cCodEsquema VARCHAR2, dFecCredito DATE) RETURN NUMBER IS
nFactorCreditos      REA_ESQUEMAS_FACT_CREDITOS.FactorCreditos%TYPE;
BEGIN
   BEGIN
      SELECT FactorCreditos
        INTO nFactorCreditos
        FROM REA_ESQUEMAS_FACT_CREDITOS
       WHERE CodCia         = nCodCia
         AND CodEsquema     = cCodEsquema
         AND FecIniCredito <= dFecCredito
         AND FecFinCredito >= dFecCredito;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFactorCreditos := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'No Existe Factor para Crédito de Fecha ' || dFecCredito || ' en Esquema ' || cCodEsquema);
   END;
   RETURN(nFactorCreditos);
END FACTOR_CREDITO;

FUNCTION PERIODO_VARIABLE(nCodCia NUMBER, cCodEsquema VARCHAR2, dFecCredito DATE) RETURN NUMBER IS
nPeriodoVariable      REA_ESQUEMAS_FACT_CREDITOS.PeriodoVariable%TYPE;
BEGIN
   BEGIN
      SELECT PeriodoVariable
        INTO nPeriodoVariable
        FROM REA_ESQUEMAS_FACT_CREDITOS
       WHERE CodCia         = nCodCia
         AND CodEsquema     = cCodEsquema
         AND FecIniCredito <= dFecCredito
         AND FecFinCredito >= dFecCredito;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPeriodoVariable := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'No Existe Periodo Variable para Crédito de Fecha ' || dFecCredito || ' en Esquema ' || cCodEsquema);
   END;
   RETURN(nPeriodoVariable);
END PERIODO_VARIABLE;

PROCEDURE ELIMINAR_FACT_CREDITOS(nCodCia NUMBER, cCodEsquema VARCHAR2) IS
BEGIN
    DELETE REA_ESQUEMAS_FACT_CREDITOS
     WHERE CodCia      = nCodCia
       AND CodEsquema  = cCodEsquema;
END ELIMINAR_FACT_CREDITOS;

FUNCTION PERIODO_POR_REASEGURADOR(nCodCia NUMBER, cCodEsquema VARCHAR2, dFecCredito DATE) RETURN VARCHAR2 IS
cIndPeriodoVarReaseg      REA_ESQUEMAS_FACT_CREDITOS.IndPeriodoVarReaseg%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndPeriodoVarReaseg,'N')
        INTO cIndPeriodoVarReaseg
        FROM REA_ESQUEMAS_FACT_CREDITOS
       WHERE CodCia         = nCodCia
         AND CodEsquema     = cCodEsquema
         AND FecIniCredito <= dFecCredito
         AND FecFinCredito >= dFecCredito;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndPeriodoVarReaseg := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'No Existe Periodo Variable para Crédito de Fecha ' || dFecCredito || ' en Esquema ' || cCodEsquema);
   END;
   RETURN(cIndPeriodoVarReaseg);
END PERIODO_POR_REASEGURADOR;

PROCEDURE COPIAR_FACTORES_CREDITOS(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2) IS
CURSOR FACT_Q IS
   SELECT FecIniCredito, FecFinCredito, FactorCreditos,
          PeriodoVariable, IndPeriodoVarReaseg, CodUsuario
     FROM REA_ESQUEMAS_FACT_CREDITOS
    WHERE CodCia     = nCodCia
      AND CodEsquema = cCodEsquemaOrig;
BEGIN
   FOR W IN FACT_Q LOOP
      INSERT INTO REA_ESQUEMAS_FACT_CREDITOS
             (CodCia, CodEsquema, FecIniCredito, FecFinCredito, FactorCreditos,
              PeriodoVariable, IndPeriodoVarReaseg, CodUsuario)
      VALUES (nCodCia, cCodEsquemaDest, W.FecIniCredito, W.FecFinCredito, W.FactorCreditos,
              W.PeriodoVariable, W.IndPeriodoVarReaseg, USER);
   END LOOP;
END COPIAR_FACTORES_CREDITOS;

END GT_REA_ESQUEMAS_FACT_CREDITOS;
/

--
-- GT_REA_ESQUEMAS_FACT_CREDITOS  (Synonym) 
--
--  Dependencies: 
--   GT_REA_ESQUEMAS_FACT_CREDITOS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_REA_ESQUEMAS_FACT_CREDITOS FOR SICAS_OC.GT_REA_ESQUEMAS_FACT_CREDITOS
/


GRANT EXECUTE ON SICAS_OC.GT_REA_ESQUEMAS_FACT_CREDITOS TO PUBLIC
/

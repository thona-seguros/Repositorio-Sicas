--
-- OC_PLAN_DE_PAGOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   PLAN_DE_PAGOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_PLAN_DE_PAGOS IS

  FUNCTION DESCRIPCION_PLAN(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlanPago VARCHAR2) RETURN VARCHAR2;
  FUNCTION FRECUENCIA_PAGOS(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlanPago VARCHAR2) RETURN NUMBER;
  FUNCTION CANTIDAD_PAGOS(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlanPago VARCHAR2) RETURN NUMBER;
  FUNCTION CUOTA_INI_DINAMICA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlanPago VARCHAR2) RETURN VARCHAR2;

END OC_PLAN_DE_PAGOS;
/

--
-- OC_PLAN_DE_PAGOS  (Package Body) 
--
--  Dependencies: 
--   OC_PLAN_DE_PAGOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_PLAN_DE_PAGOS IS

FUNCTION DESCRIPCION_PLAN(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlanPago VARCHAR2) RETURN VARCHAR2 IS
cDescPlan   PLAN_DE_PAGOS.DescPlan%TYPE;
BEGIN
   BEGIN
      SELECT DescPlan
        INTO cDescPlan
        FROM PLAN_DE_PAGOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodPlanPago = cCodPlanPago;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescPlan := 'NO EXISTE PLAN DE PAGOS';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Plan de Pagos ' || cCodPlanPago || ' Duplicado');
   END;
   RETURN(cDescPlan);
END DESCRIPCION_PLAN;

FUNCTION FRECUENCIA_PAGOS(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlanPago VARCHAR2) RETURN NUMBER IS
nFrecPagos   PLAN_DE_PAGOS.FrecPagos%TYPE;
BEGIN
   BEGIN
      SELECT FrecPagos
        INTO nFrecPagos
        FROM PLAN_DE_PAGOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodPlanPago = cCodPlanPago;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFrecPagos := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Plan de Pagos ' || cCodPlanPago || ' Duplicado');
   END;
   RETURN(nFrecPagos);
END FRECUENCIA_PAGOS;

FUNCTION CANTIDAD_PAGOS(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlanPago VARCHAR2) RETURN NUMBER IS
nNumPagos   PLAN_DE_PAGOS.NumPagos%TYPE;
BEGIN
   BEGIN
      SELECT NumPagos
        INTO nNumPagos
        FROM PLAN_DE_PAGOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodPlanPago = cCodPlanPago;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nNumPagos := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Plan de Pagos ' || cCodPlanPago || ' Duplicado');
   END;
   RETURN(nNumPagos);
END CANTIDAD_PAGOS;

FUNCTION CUOTA_INI_DINAMICA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlanPago VARCHAR2) RETURN VARCHAR2 IS
cIndPorcIniDinamico PLAN_DE_PAGOS.IndPorcIniDinamico%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndPorcIniDinamico,'N')
        INTO cIndPorcIniDinamico
        FROM PLAN_DE_PAGOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodPlanPago = cCodPlanPago;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20220,'Plan de Pagos ' || cCodPlanPago || ' Inexistente');
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Plan de Pagos ' || cCodPlanPago || ' Duplicado');
   END;
   RETURN cIndPorcIniDinamico;
END CUOTA_INI_DINAMICA;

END OC_PLAN_DE_PAGOS;
/

--
-- OC_PLAN_DE_PAGOS  (Synonym) 
--
--  Dependencies: 
--   OC_PLAN_DE_PAGOS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_PLAN_DE_PAGOS FOR SICAS_OC.OC_PLAN_DE_PAGOS
/


GRANT EXECUTE ON SICAS_OC.OC_PLAN_DE_PAGOS TO PUBLIC
/

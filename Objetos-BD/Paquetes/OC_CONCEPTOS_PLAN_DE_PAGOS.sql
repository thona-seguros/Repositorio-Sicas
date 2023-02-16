CREATE OR REPLACE PACKAGE OC_CONCEPTOS_PLAN_DE_PAGOS IS
   FUNCTION MONTO_CONCEPTO(nCodCia NUMBER, nIdPoliza NUMBER,nIdetPol NUMBER,nMonto NUMBER) RETURN NUMBER;
   FUNCTION PORCENTAJE_CONCEPTO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlanPago VARCHAR2, cCodCpto VARCHAR2) RETURN NUMBER;

END OC_CONCEPTOS_PLAN_DE_PAGOS;
 
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_CONCEPTOS_PLAN_DE_PAGOS IS

FUNCTION MONTO_CONCEPTO(nCodCia NUMBER, nIdPoliza NUMBER,nIdetPol NUMBER,nMonto NUMBER) RETURN NUMBER IS
nNumAseg    NUMBER(10);
nMontoCpto  FACTURAS.Monto_Fact_Local%TYPE;
BEGIN
   BEGIN
      SELECT Campo1
        INTO nNumAseg
        FROM DATOS_PART_EMISION
       WHERE CodCia   = nCodCia
         AND IdPoliza = nIdPoliza
         AND IdetPol  = nIdetPol;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'No Existe Cantidad Asegurado en Dato Particular para el Cert.No.'||nIdetPol);
   END;
   nMontoCpto := TO_NUMBER(nNumAseg) * nMonto;
   RETURN (nMontoCpto);
END MONTO_CONCEPTO;

FUNCTION PORCENTAJE_CONCEPTO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlanPago VARCHAR2, cCodCpto VARCHAR2) RETURN NUMBER IS
nPorcCpto      CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;
BEGIN
   BEGIN
      SELECT PorcCpto
        INTO nPorcCpto
        FROM CONCEPTOS_PLAN_DE_PAGOS
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND CodPlanPago = cCodPlanPago
         AND CodCpto     = cCodCpto;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcCpto := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR (-20100,'Error en Configuración del Concepto '||cCodCpto|| ' en Plan de Pagos ' || cCodPlanPago);
   END;
   RETURN(nPorcCpto);
END PORCENTAJE_CONCEPTO;

END OC_CONCEPTOS_PLAN_DE_PAGOS;

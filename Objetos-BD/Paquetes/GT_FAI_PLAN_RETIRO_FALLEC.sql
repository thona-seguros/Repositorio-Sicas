CREATE OR REPLACE PACKAGE GT_FAI_PLAN_RETIRO_FALLEC AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodPlanRet VARCHAR2);

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodPlanRet VARCHAR2);

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodPlanRet VARCHAR2);

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodPlanRet VARCHAR2);

FUNCTION DESCRIPCION(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodPlanRet VARCHAR2) RETURN VARCHAR2;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodPlanRetOrig VARCHAR2, cCodPlanRetDest VARCHAR2, cDescPlanDest VARCHAR2);

FUNCTION EXISTEN_PLANES_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2;

END GT_FAI_PLAN_RETIRO_FALLEC;
/

CREATE OR REPLACE PACKAGE BODY GT_FAI_PLAN_RETIRO_FALLEC AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodPlanRet VARCHAR2) IS
BEGIN
   UPDATE FAI_PLAN_RETIRO_FALLEC
      SET StsPlanRet = 'ACTIVO',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondo
      AND CodPlanRet = cCodPlanRet;
END ACTIVAR;

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodPlanRet VARCHAR2) IS
BEGIN
   UPDATE FAI_PLAN_RETIRO_FALLEC
      SET StsPlanRet = 'CONFIG',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondo
      AND CodPlanRet = cCodPlanRet;
END CONFIGURAR;

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodPlanRet VARCHAR2) IS
BEGIN
   UPDATE FAI_PLAN_RETIRO_FALLEC
      SET StsPlanRet = 'ACTIVO',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondo
      AND CodPlanRet = cCodPlanRet;
END REACTIVAR;

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodPlanRet VARCHAR2) IS
BEGIN
   UPDATE FAI_PLAN_RETIRO_FALLEC
      SET StsPlanRet = 'SUSPEN',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondo
      AND CodPlanRet = cCodPlanRet;
END SUSPENDER;

FUNCTION DESCRIPCION (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodPlanRet VARCHAR2) RETURN VARCHAR2 IS
cDescPlanRet   FAI_PLAN_RETIRO_FALLEC.DescPlanRet%TYPE;
BEGIN
   BEGIN
      SELECT DescPlanRet
        INTO cDescPlanRet
        FROM FAI_PLAN_RETIRO_FALLEC
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND TipoFondo  = cTipoFondo
	      AND CodPlanRet = cCodPlanRet;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescPlanRet := 'NO EXISTE';
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR (-20100, 'Error en GT_FAI_PLAN_RETIRO_FALLEC.DESCRIPCION '|| SQLERRM);
   END;
   RETURN(cDescPlanRet);
END DESCRIPCION;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodPlanRetOrig VARCHAR2, cCodPlanRetDest VARCHAR2,
                 cDescPlanDest VARCHAR2) IS
CURSOR PLAN_RET_Q IS
   SELECT CodPlanRet, DescPlanRet, TipoPlan, StsPlanRet,
          FecStatus, TipoPago, CantPagos,  CodPlanPago,
          PorcPagos, PorcFondo, IndAplicaRet,
          PorcRetencion, IndPolVida
     FROM FAI_PLAN_RETIRO_FALLEC
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondoOrig
      AND CodPlanRet = cCodPlanRetOrig;
BEGIN
   FOR X IN PLAN_RET_Q LOOP
      INSERT INTO FAI_PLAN_RETIRO_FALLEC
             (CodCia, CodEmpresa, TipoFondo, CodPlanRet, DescPlanRet, 
              TipoPlan, StsPlanRet, FecStatus, TipoPago, CantPagos, CodPlanPago,
              PorcPagos, PorcFondo, IndAplicaRet, PorcRetencion, IndPolVida)
      VALUES (nCodCia, nCodEmpresa, cTipoFondoDest, cCodPlanRetDest, cDescPlanDest,
              X.TipoPlan, 'CONFIG', TRUNC(SYSDATE), X.TipoPago, X.CantPagos, X.CodPlanPago,
              X.PorcPagos, X.PorcFondo, X.IndAplicaRet, X.PorcRetencion, X.IndPolVida);
   END LOOP;
END COPIAR;

FUNCTION EXISTEN_PLANES_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2) RETURN VARCHAR2 IS
cExiste        VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM FAI_PLAN_RETIRO_FALLEC
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND TipoFondo     = cTipoFondo
         AND StsPlanRet    = 'ACTIVO';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTEN_PLANES_FONDO;

END GT_FAI_PLAN_RETIRO_FALLEC;

CREATE OR REPLACE PACKAGE GT_FAI_PLAN_PAGO_RETIRO_FALLEC AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, cCodPlanRet VARCHAR2,
                   cTipoPlan VARCHAR2, dFecIniVig DATE, dFecFinVig DATE);

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, cCodPlanRet VARCHAR2,
                     cTipoPlan VARCHAR2, dFecIniVig DATE, dFecFinVig DATE);

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, cCodPlanRet VARCHAR2,
                     cTipoPlan VARCHAR2, dFecIniVig DATE, dFecFinVig DATE);

FUNCTION PLAN_ACTIVO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER) RETURN VARCHAR2;

FUNCTION TIPO_PLAN(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, cCodPlanRet VARCHAR2) RETURN VARCHAR2;

FUNCTION FECHAS_VIGENCIA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, cCodPlanRet VARCHAR2, cTipoPlan VARCHAR2, cTipoFecVig VARCHAR2) RETURN DATE;

END GT_FAI_PLAN_PAGO_RETIRO_FALLEC;
/

CREATE OR REPLACE PACKAGE BODY GT_FAI_PLAN_PAGO_RETIRO_FALLEC AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, cCodPlanRet VARCHAR2,
                   cTipoPlan VARCHAR2, dFecIniVig DATE, dFecFinVig DATE) IS
BEGIN
   UPDATE FAI_PLAN_PAGO_RETIRO_FALLEC
      SET StsPlanPago  = 'ACTIVO',
          FecStatus    = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdFondo     = nIdFondo
      AND CodPlanRet  = cCodPlanRet
      AND TipoPlan    = cTipoPlan
      AND FecIniVig   = dFecIniVig
      AND FecFinVig   = dFecFinVig;
END ACTIVAR;

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, cCodPlanRet VARCHAR2,
                     cTipoPlan VARCHAR2, dFecIniVig DATE, dFecFinVig DATE) IS
BEGIN
   UPDATE FAI_PLAN_PAGO_RETIRO_FALLEC
      SET StsPlanPago  = 'ACTIVO',
          FecStatus    = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND IdFondo     = nIdFondo
      AND CodPlanRet  = cCodPlanRet
      AND TipoPlan    = cTipoPlan
      AND FecIniVig   = dFecIniVig
      AND FecFinVig   = dFecFinVig;
END REACTIVAR;

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, cCodPlanRet VARCHAR2,
                     cTipoPlan VARCHAR2, dFecIniVig DATE, dFecFinVig DATE) IS
BEGIN
   UPDATE FAI_PLAN_PAGO_RETIRO_FALLEC
      SET StsPlanPago  = 'SUSPEN',
          FecStatus    = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdFondo    = nIdFondo;
END SUSPENDER;

FUNCTION PLAN_ACTIVO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER) RETURN VARCHAR2 IS
cCodPlanRet    FAI_PLAN_PAGO_RETIRO_FALLEC.CodPlanRet%TYPE;
BEGIN
   BEGIN
      SELECT CodPlanRet
        INTO cCodPlanRet
        FROM FAI_PLAN_PAGO_RETIRO_FALLEC
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdFondo     = nIdFondo
         AND StsPlanPago = 'ACTIVO';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodPlanRet := NULL;
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error Existen Varios Planes de Pago ACTIVOS para Fondo: '||nIdFondo);
   END;
   RETURN(cCodPlanRet);   
END PLAN_ACTIVO;

FUNCTION TIPO_PLAN(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, cCodPlanRet VARCHAR2) RETURN VARCHAR2 IS
cTipoPlan      FAI_PLAN_PAGO_RETIRO_FALLEC.TipoPlan%TYPE;
BEGIN
   BEGIN
      SELECT TipoPlan
        INTO cTipoPlan
        FROM FAI_PLAN_PAGO_RETIRO_FALLEC
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdFondo     = nIdFondo
         AND CodPlanRet  = cCodPlanRet
         AND StsPlanPago = 'ACTIVO';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoPlan := NULL;
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20200,'Error Existen Varios Planes de Pago ' || cCodPlanRet || ' para Fondo '||nIdFondo);
   END;
   RETURN(cTipoPlan);
END TIPO_PLAN;

FUNCTION FECHAS_VIGENCIA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, cCodPlanRet VARCHAR2, cTipoPlan VARCHAR2, cTipoFecVig VARCHAR2) RETURN DATE IS
    dFecVig    FAI_PLAN_PAGO_RETIRO_FALLEC.FecIniVig%TYPE;
BEGIN
    IF cTipoFecVig = 'I' THEN
        BEGIN
           SELECT FecIniVig
             INTO dFecVig
             FROM FAI_PLAN_PAGO_RETIRO_FALLEC
            WHERE CodCia      = nCodCia
              AND CodEmpresa  = nCodEmpresa
              AND IdFondo     = nIdFondo
              AND CodPlanRet  = cCodPlanRet
              AND TipoPlan    = cTipoPlan;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20200,'Error NO Es Posible Determinar La Fecha Inicio De Vigencia Del Plan ' || cCodPlanRet || ' para Fondo '||nIdFondo);
        END;
    ELSIF cTipoFecVig = 'F' THEN
        BEGIN
           SELECT FecFinVig
             INTO dFecVig
             FROM FAI_PLAN_PAGO_RETIRO_FALLEC
            WHERE CodCia      = nCodCia
              AND CodEmpresa  = nCodEmpresa
              AND IdFondo     = nIdFondo
              AND CodPlanRet  = cCodPlanRet
              AND TipoPlan    = cTipoPlan;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20200,'Error NO Es Posible Determinar La Fecha Fin De Vigencia Del Plan ' || cCodPlanRet || ' para Fondo '||nIdFondo);
        END;
    END IF;
    RETURN dFecVig;
END FECHAS_VIGENCIA;

END GT_FAI_PLAN_PAGO_RETIRO_FALLEC;

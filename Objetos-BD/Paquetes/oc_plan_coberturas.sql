--
-- OC_PLAN_COBERTURAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   PLAN_COBERTURAS (Table)
--   OC_FACTOR_COASEGURO (Package)
--   OC_FACTOR_DEDUCIBLE (Package)
--   OC_FACTOR_SUMA_ASEGURADA (Package)
--   OC_CONFIG_ASISTENCIAS_PLANCOB (Package)
--   OC_CONFIG_PLANTILLAS_PLANCOB (Package)
--   OC_CONFIG_RESERVAS_PLANCOB (Package)
--   OC_GASTO_USUAL_ACOSTUMBRADO (Package)
--   OC_NIVEL_PLAN_COBERTURA (Package)
--   OC_COBERTURAS_DE_SEGUROS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_PLAN_COBERTURAS IS

  FUNCTION NOMBRE_PLANCOB(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2;
  FUNCTION MONEDA_PLANCOB(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2;
  FUNCTION CODIGO_SUBRAMO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2;
  PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                   cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2, cDescPlanCobDest VARCHAR2,
                   cIndReservas VARCHAR2, cCodReservaDest VARCHAR2);
  FUNCTION EXISTE_PLANCOB(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2;
  FUNCTION VALIDA_DIAS_RETROACTIVOS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,dFecIniVig DATE) RETURN VARCHAR2;
  FUNCTION TEMPORALIDAD(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2;
  FUNCTION PLAN_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2;
  FUNCTION GASTOS_ADMINISTRACION(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER;
  FUNCTION GASTOS_ADQUISICION(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER;
  FUNCTION UTILIDAD(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER;
  FUNCTION CODIGO_AGENTE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER;
  FUNCTION NUMERO_DIAS_RETROACTIVOS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER;
  FUNCTION VALIDA_DIAS_RETROACTIVOS_REN(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,dFecIniVig DATE) RETURN VARCHAR2;
  FUNCTION NUMERO_DIAS_RETROACTIVOS_REN(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER;
  FUNCTION DURACION_PLAN(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER;
  FUNCTION PORCENTAJE_DESCUENTO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER;
  FUNCTION PORCENTAJE_EXTRAPRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER;
  FUNCTION MONTO_EXTRAPRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER;
  FUNCTION FACTOR_AJUSTE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER;
  FUNCTION MONTO_DEDUCIBLE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER;
  FUNCTION PREFIJO_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2;
  FUNCTION DIAS_EXTRAS_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER;
  FUNCTION DIAS_SIN_PAGO_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER;

END OC_PLAN_COBERTURAS;
/

--
-- OC_PLAN_COBERTURAS  (Package Body) 
--
--  Dependencies: 
--   OC_PLAN_COBERTURAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_PLAN_COBERTURAS IS

FUNCTION NOMBRE_PLANCOB(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2 IS
cDesc_Plan    PLAN_COBERTURAS.Desc_Plan%TYPE;
BEGIN
   BEGIN
      SELECT Desc_Plan
        INTO cDesc_Plan
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDesc_Plan := 'PLAN NO EXISTE';
   END;
   RETURN(cDesc_Plan);
END NOMBRE_PLANCOB;

FUNCTION MONEDA_PLANCOB(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2 IS
cCodMoneda    PLAN_COBERTURAS.CodMoneda%TYPE;
BEGIN
   BEGIN
      SELECT CodMoneda
        INTO cCodMoneda
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodMoneda := NULL;
   END;
   RETURN(cCodMoneda);
END MONEDA_PLANCOB;

FUNCTION CODIGO_SUBRAMO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2 IS
cCodTipoPlan    PLAN_COBERTURAS.CodTipoPlan%TYPE;
BEGIN
   BEGIN
      SELECT CodTipoPlan
        INTO cCodTipoPlan
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodTipoPlan := NULL;
   END;
   RETURN(cCodTipoPlan);
END CODIGO_SUBRAMO;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2, cDescPlanCobDest VARCHAR2,
                 cIndReservas VARCHAR2, cCodReservaDest VARCHAR2) IS
CURSOR PLANCOB_Q IS
  SELECT TipPlanCob, CodMoneda, CodTipoPlan, Cod_Agente, DiasRetroactivos, 
         Modalidad, PlanPoliza, Indisputabilidad, CodTemporalidad, IndAplicaSAMI, 
         ComMinima, ComMaxima, PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad, DuracionPlan, 
         PorcDescuento, PorcExtraPrima, MontoExtraPrima, FactorAjuste,
         MontoDeducible, FactFormulaDeduc, PrefijoPol, DiasExtrasCancel,
         DiasSinPagoFondos
    FROM PLAN_COBERTURAS
   WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdTipoSeg  = cIdTipoSegOrig
     AND PlanCob    = cPlanCobOrig;
BEGIN
   FOR X IN PLANCOB_Q LOOP
      INSERT INTO PLAN_COBERTURAS
             (CodCia, CodEmpresa, IdTipoSeg, PlanCob, Desc_Plan, UltModPlan,
              Estado_Plan, CodUsuario, TipPlanCob, CodMoneda, CodTipoPlan,
              Cod_Agente, DiasRetroactivos, Modalidad, PlanPoliza,
              Indisputabilidad, CodTemporalidad, IndAplicaSAMI, ComMinima, ComMaxima,
              PorcGtoAdmin, PorcGtoAdqui, PorcUtilidad, DuracionPlan, 
              PorcDescuento, PorcExtraPrima, MontoExtraPrima, FactorAjuste,
              MontoDeducible, FactFormulaDeduc, PrefijoPol, DiasExtrasCancel,
              DiasSinPagoFondos)
      VALUES (nCodCia, nCodEmpresa, cIdTipoSegDest, cPlanCobDest, cDescPlanCobDest, TRUNC(SYSDATE),
              'SOL', USER, X.TipPlanCob, X.CodMoneda, X.CodTipoPlan,
              X.Cod_Agente, X.DiasRetroactivos, X.Modalidad, X.PlanPoliza,
              X.Indisputabilidad, X.CodTemporalidad, X.IndAplicaSAMI, X.ComMinima, X.ComMaxima,
              X.PorcGtoAdmin, X.PorcGtoAdqui, X.PorcUtilidad, X.DuracionPlan, 
              X.PorcDescuento, X.PorcExtraPrima, X.MontoExtraPrima, X.FactorAjuste,
              X.MontoDeducible, X.FactFormulaDeduc, X.PrefijoPol, X.DiasExtrasCancel,
              X.DiasSinPagoFondos);

      OC_COBERTURAS_DE_SEGUROS.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig,
                                      cPlanCobOrig, cIdTipoSegDest, cPlanCobDest);

      OC_CONFIG_ASISTENCIAS_PLANCOB.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig, cPlanCobOrig,
                                           cIdTipoSegDest, cPlanCobDest);
      OC_NIVEL_PLAN_COBERTURA.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig, cPlanCobOrig,
                                     cIdTipoSegDest, cPlanCobDest);
      OC_CONFIG_PLANTILLAS_PLANCOB.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig,
                                          cPlanCobOrig, cIdTipoSegDest, cPlanCobDest);
      IF cIndReservas = 'S' THEN
         OC_CONFIG_RESERVAS_PLANCOB.AGREGAR(nCodCia, cCodReservaDest, nCodEmpresa, cIdTipoSegOrig,
                                            cPlanCobOrig, cIdTipoSegDest, cPlanCobDest);
      END IF;

      OC_GASTO_USUAL_ACOSTUMBRADO.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig,
                                         cPlanCobOrig, cIdTipoSegDest, cPlanCobDest);
      OC_FACTOR_DEDUCIBLE.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig,
                                 cPlanCobOrig, cIdTipoSegDest, cPlanCobDest);
      OC_FACTOR_SUMA_ASEGURADA.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig,
                                      cPlanCobOrig, cIdTipoSegDest, cPlanCobDest);
      OC_FACTOR_COASEGURO.COPIAR(nCodCia, nCodEmpresa, cIdTipoSegOrig,
                                 cPlanCobOrig, cIdTipoSegDest, cPlanCobDest);

   END LOOP;
END COPIAR;

FUNCTION EXISTE_PLANCOB(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2 IS
cExiste    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob ;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTE_PLANCOB;

FUNCTION VALIDA_DIAS_RETROACTIVOS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,dFecIniVig DATE) RETURN VARCHAR2 IS
cExiste    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM PLAN_COBERTURAS
       WHERE CodCia            = nCodCia
         AND CodEmpresa        = nCodEmpresa
         AND IdTipoSeg         = cIdTipoSeg
         AND PlanCob           = cPlanCob
         AND DiasRetroActivos >=  TRUNC(SYSDATE) - dFecIniVig;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END VALIDA_DIAS_RETROACTIVOS;

FUNCTION TEMPORALIDAD(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2 IS
cCodTemporalidad    PLAN_COBERTURAS.CodTemporalidad%TYPE;
BEGIN
   BEGIN
      SELECT CodTemporalidad
        INTO cCodTemporalidad
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodTemporalidad := 'NO EXISTE';
   END;
   RETURN(cCodTemporalidad);
END TEMPORALIDAD;

FUNCTION PLAN_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2 IS
cPlanPoliza    PLAN_COBERTURAS.PlanPoliza%TYPE;
BEGIN
   BEGIN
      SELECT PlanPoliza
        INTO cPlanPoliza
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cPlanPoliza := '9';
   END;
   RETURN(cPlanPoliza);
END PLAN_POLIZA;

FUNCTION GASTOS_ADMINISTRACION(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER IS
nPorcGtoAdmin    PLAN_COBERTURAS.PorcGtoAdmin%TYPE;
BEGIN
   BEGIN
      SELECT PorcGtoAdmin
        INTO nPorcGtoAdmin
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcGtoAdmin := 0;
   END;
   RETURN(nPorcGtoAdmin);
END GASTOS_ADMINISTRACION;

FUNCTION GASTOS_ADQUISICION(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER IS
nPorcGtoAdqui    PLAN_COBERTURAS.PorcGtoAdqui%TYPE;
BEGIN
   BEGIN
      SELECT PorcGtoAdqui
        INTO nPorcGtoAdqui
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcGtoAdqui := 0;
   END;
   RETURN(nPorcGtoAdqui);
END GASTOS_ADQUISICION;

FUNCTION UTILIDAD(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER IS
nPorcUtilidad    PLAN_COBERTURAS.PorcUtilidad%TYPE;
BEGIN
   BEGIN
      SELECT PorcUtilidad
        INTO nPorcUtilidad
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcUtilidad := 0;
   END;
   RETURN(nPorcUtilidad);
END UTILIDAD;

FUNCTION CODIGO_AGENTE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER IS
nCod_Agente    PLAN_COBERTURAS.Cod_Agente%TYPE;
BEGIN
   BEGIN
      SELECT Cod_Agente
        INTO nCod_Agente
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nCod_Agente := 0;
   END;
   RETURN(nCod_Agente);
END CODIGO_AGENTE;

FUNCTION NUMERO_DIAS_RETROACTIVOS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER IS
    nDiasRetroactivos PLAN_COBERTURAS.DiasRetroactivos%TYPE;
BEGIN
    BEGIN
        SELECT NVL(DiasRetroactivos,0)
          INTO nDiasRetroactivos
          FROM PLAN_COBERTURAS
         WHERE CodCia     = nCodCia
           AND CodEmpresa = nCodEmpresa
           AND IdTipoSeg  = cIdTipoSeg
           AND PlanCob    = cPlanCob;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nDiasRetroactivos := 0;
    END;
    RETURN (nDiasRetroactivos);
END NUMERO_DIAS_RETROACTIVOS;

FUNCTION VALIDA_DIAS_RETROACTIVOS_REN(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,dFecIniVig DATE) RETURN VARCHAR2 IS
cExiste    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM PLAN_COBERTURAS
       WHERE CodCia            = nCodCia
         AND CodEmpresa        = nCodEmpresa
         AND IdTipoSeg         = cIdTipoSeg
         AND PlanCob           = cPlanCob
         AND DiasRetroRen     >=  trunc(SYSDATE) - dFecIniVig;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END VALIDA_DIAS_RETROACTIVOS_REN;

FUNCTION NUMERO_DIAS_RETROACTIVOS_REN(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER IS
    nDiasRetroRen PLAN_COBERTURAS.DiasRetroRen%TYPE;
BEGIN
    BEGIN
        SELECT NVL(DiasRetroRen,0)
          INTO nDiasRetroRen
          FROM PLAN_COBERTURAS
         WHERE CodCia     = nCodCia
           AND CodEmpresa = nCodEmpresa
           AND IdTipoSeg  = cIdTipoSeg
           AND PlanCob    = cPlanCob;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nDiasRetroRen := 0;
    END;
    RETURN (nDiasRetroRen);
END NUMERO_DIAS_RETROACTIVOS_REN;

FUNCTION DURACION_PLAN(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER IS
nDuracionPlan    PLAN_COBERTURAS.DuracionPlan%TYPE;
BEGIN
   BEGIN
      SELECT NVL(DuracionPlan,1)
        INTO nDuracionPlan
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nDuracionPlan := 1;
   END;
   RETURN(nDuracionPlan);
END DURACION_PLAN;

FUNCTION PORCENTAJE_DESCUENTO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER IS
nPorcDescuento    PLAN_COBERTURAS.PorcDescuento%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcDescuento,0)
        INTO nPorcDescuento
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcDescuento := 0;
   END;
   RETURN(nPorcDescuento);
END PORCENTAJE_DESCUENTO;

FUNCTION PORCENTAJE_EXTRAPRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER IS
nPorcExtraPrima   PLAN_COBERTURAS.PorcExtraPrima%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcExtraPrima,0)
        INTO nPorcExtraPrima
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcExtraPrima := 0;
   END;
   RETURN(nPorcExtraPrima);
END PORCENTAJE_EXTRAPRIMA;

FUNCTION MONTO_EXTRAPRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER IS
nMontoExtraPrima   PLAN_COBERTURAS.MontoExtraPrima%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MontoExtraPrima,0)
        INTO nMontoExtraPrima
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMontoExtraPrima := 0;
   END;
   RETURN(nMontoExtraPrima);
END MONTO_EXTRAPRIMA;

FUNCTION FACTOR_AJUSTE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER IS
nFactorAjuste   PLAN_COBERTURAS.FactorAjuste%TYPE;
BEGIN
   BEGIN
      SELECT NVL(FactorAjuste,0)
        INTO nFactorAjuste
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFactorAjuste := 0;
   END;
   RETURN(nFactorAjuste);
END FACTOR_AJUSTE;

FUNCTION MONTO_DEDUCIBLE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER IS
nMontoDeducible   PLAN_COBERTURAS.MontoDeducible%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MontoDeducible,0)
        INTO nMontoDeducible
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMontoDeducible := 0;
   END;
   RETURN(nMontoDeducible);
END MONTO_DEDUCIBLE;

FUNCTION FACTOR_FORMULA_DEDUCIBLE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER IS
nFactFormulaDeduc   PLAN_COBERTURAS.FactFormulaDeduc%TYPE;
BEGIN
   BEGIN
      SELECT NVL(FactFormulaDeduc,0)
        INTO nFactFormulaDeduc
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFactFormulaDeduc := 0;
   END;
   RETURN(nFactFormulaDeduc);
END FACTOR_FORMULA_DEDUCIBLE;

FUNCTION PREFIJO_POLIZA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2 IS
cPrefijoPol   PLAN_COBERTURAS.PrefijoPol%TYPE;
BEGIN
   BEGIN
      SELECT PrefijoPol
        INTO cPrefijoPol
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cPrefijoPol := NULL;
   END;
   RETURN(cPrefijoPol);
END PREFIJO_POLIZA;

FUNCTION DIAS_EXTRAS_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER IS
nDiasExtrasCancel   PLAN_COBERTURAS.DiasExtrasCancel%TYPE;
BEGIN
   BEGIN
      SELECT NVL(DiasExtrasCancel,0)
        INTO nDiasExtrasCancel
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nDiasExtrasCancel := 0;
   END;
   RETURN(nDiasExtrasCancel);
END DIAS_EXTRAS_FONDOS;

FUNCTION DIAS_SIN_PAGO_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN NUMBER IS
nDiasSinPagoFondos   PLAN_COBERTURAS.DiasSinPagoFondos%TYPE;
BEGIN
   BEGIN
      SELECT NVL(DiasSinPagoFondos,0)
        INTO nDiasSinPagoFondos
        FROM PLAN_COBERTURAS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND PlanCob    = cPlanCob;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nDiasSinPagoFondos := 0;
   END;
   RETURN(nDiasSinPagoFondos);
END DIAS_SIN_PAGO_FONDOS;

END OC_PLAN_COBERTURAS;
/

--
-- OC_PLAN_COBERTURAS  (Synonym) 
--
--  Dependencies: 
--   OC_PLAN_COBERTURAS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_PLAN_COBERTURAS FOR SICAS_OC.OC_PLAN_COBERTURAS
/


GRANT EXECUTE ON SICAS_OC.OC_PLAN_COBERTURAS TO PUBLIC
/

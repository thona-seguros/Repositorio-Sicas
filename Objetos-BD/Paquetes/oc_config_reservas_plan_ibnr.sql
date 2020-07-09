--
-- OC_CONFIG_RESERVAS_PLAN_IBNR  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CONFIG_RESERVAS_PLAN_IBNR (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONFIG_RESERVAS_PLAN_IBNR IS

  PROCEDURE ELIMINAR (nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2);
  PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, cCodReservaDest VARCHAR2);
  FUNCTION FACTOR_LIMITE_IBNR(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                              cPlanCob VARCHAR2, dFecReserva DATE) RETURN NUMBER;
  FUNCTION FACTOR_LIMITE_GAAS(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                              cPlanCob VARCHAR2, dFecReserva DATE) RETURN NUMBER;
  FUNCTION FACTOR_RVA_IBNR(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                           cPlanCob VARCHAR2, dFecReserva DATE) RETURN NUMBER;
  FUNCTION FACTOR_RVA_GAAS(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                           cPlanCob VARCHAR2, dFecReserva DATE) RETURN NUMBER;

END OC_CONFIG_RESERVAS_PLAN_IBNR;
/

--
-- OC_CONFIG_RESERVAS_PLAN_IBNR  (Package Body) 
--
--  Dependencies: 
--   OC_CONFIG_RESERVAS_PLAN_IBNR (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CONFIG_RESERVAS_PLAN_IBNR IS

PROCEDURE ELIMINAR (nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) IS
BEGIN
   BEGIN
      DELETE CONFIG_RESERVAS_PLAN_IBNR
       WHERE CodCia     = nCodCia
         AND CodReserva = cCodReserva
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
                   AND PlanCob    = cPlanCob;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error al Eliminar CONFIG_RESERVAS_PLAN_IBNR,  '|| SQLERRM );
   END;
END ELIMINAR;

PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, cCodReservaDest VARCHAR2) IS
BEGIN
   BEGIN
      INSERT INTO CONFIG_RESERVAS_PLAN_IBNR
                 (CodCia, CodReserva, CodEmpresa, IdTipoSeg, PlanCob, FactLimiteIBNR,
                  FactLimiteGAAS, FactReservaIBNR, FactReservaGAAS)
           SELECT nCodCia, cCodReservaDest, CodEmpresa, IdTipoSeg, PlanCob, FactLimiteIBNR,
                  FactLimiteGAAS, FactReservaIBNR, FactReservaGAAS
             FROM CONFIG_RESERVAS_PLAN_IBNR
            WHERE CodCia     = nCodCia
              AND CodReserva = cCodReservaOrig;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar la Copia de CONFIG_RESERVAS_PLAN_IBNR,  '|| SQLERRM );
   END;
END COPIAR;

FUNCTION FACTOR_LIMITE_IBNR(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                            cPlanCob VARCHAR2, dFecReserva DATE) RETURN NUMBER IS
nFactLimiteIBNR     CONFIG_RESERVAS_PLAN_IBNR.FactLimiteIBNR%TYPE;
BEGIN
   SELECT NVL(FactLimiteIBNR,0) / 100 
     INTO nFactLimiteIBNR
     FROM CONFIG_RESERVAS_PLAN_IBNR
    WHERE CodCia     = nCodCia
      AND CodReserva = cCodReserva
      AND CodEmpresa = nCodEmpresa
      AND IdTipoSeg  = cIdTipoSeg
      AND PlanCob    = cPlanCob
      AND FecIniVig <= dFecReserva
      AND FecFinVig >= dFecReserva;

   RETURN(nFactLimiteIBNR);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN(0);
   WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Factores IBNR y GAAS '|| SQLERRM );
END FACTOR_LIMITE_IBNR;

FUNCTION FACTOR_LIMITE_GAAS(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                            cPlanCob VARCHAR2, dFecReserva DATE) RETURN NUMBER IS
nFactLimiteGAAS     CONFIG_RESERVAS_PLAN_IBNR.FactLimiteGAAS%TYPE;
BEGIN
   SELECT NVL(FactLimiteGAAS,0) / 100 
     INTO nFactLimiteGAAS
     FROM CONFIG_RESERVAS_PLAN_IBNR
    WHERE CodCia     = nCodCia
      AND CodReserva = cCodReserva
      AND CodEmpresa = nCodEmpresa
      AND IdTipoSeg  = cIdTipoSeg
      AND PlanCob    = cPlanCob
      AND FecIniVig <= dFecReserva
      AND FecFinVig >= dFecReserva;

   RETURN(nFactLimiteGAAS);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN(0);
   WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Factores IBNR y GAAS '|| SQLERRM );
END FACTOR_LIMITE_GAAS;

FUNCTION FACTOR_RVA_IBNR(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                         cPlanCob VARCHAR2, dFecReserva DATE) RETURN NUMBER IS
nFactReservaIBNR    CONFIG_RESERVAS_PLAN_IBNR.FactReservaIBNR%TYPE;
BEGIN
   SELECT NVL(FactReservaIBNR,0) / 100 
     INTO nFactReservaIBNR
     FROM CONFIG_RESERVAS_PLAN_IBNR
    WHERE CodCia     = nCodCia
      AND CodReserva = cCodReserva
      AND CodEmpresa = nCodEmpresa
      AND IdTipoSeg  = cIdTipoSeg
      AND PlanCob    = cPlanCob
      AND FecIniVig <= dFecReserva
      AND FecFinVig >= dFecReserva;

   RETURN(nFactReservaIBNR);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN(0);
   WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Factores IBNR y GAAS '|| SQLERRM );
END FACTOR_RVA_IBNR;

FUNCTION FACTOR_RVA_GAAS(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                         cPlanCob VARCHAR2, dFecReserva DATE) RETURN NUMBER IS
nFactReservaGAAS    CONFIG_RESERVAS_PLAN_IBNR.FactReservaGAAS%TYPE;
BEGIN
   SELECT NVL(FactReservaGAAS,0) / 100 
     INTO nFactReservaGAAS
     FROM CONFIG_RESERVAS_PLAN_IBNR
    WHERE CodCia     = nCodCia
      AND CodReserva = cCodReserva
      AND CodEmpresa = nCodEmpresa
      AND IdTipoSeg  = cIdTipoSeg
      AND PlanCob    = cPlanCob
      AND FecIniVig <= dFecReserva
      AND FecFinVig >= dFecReserva;

   RETURN(nFactReservaGAAS);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN(0);
   WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Factores IBNR y GAAS '|| SQLERRM );
END FACTOR_RVA_GAAS;

END OC_CONFIG_RESERVAS_PLAN_IBNR;
/

--
-- OC_CONFIG_RESERVAS_PLAN_IBNR  (Synonym) 
--
--  Dependencies: 
--   OC_CONFIG_RESERVAS_PLAN_IBNR (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_CONFIG_RESERVAS_PLAN_IBNR FOR SICAS_OC.OC_CONFIG_RESERVAS_PLAN_IBNR
/


GRANT EXECUTE ON SICAS_OC.OC_CONFIG_RESERVAS_PLAN_IBNR TO PUBLIC
/

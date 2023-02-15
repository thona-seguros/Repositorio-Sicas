CREATE OR REPLACE PACKAGE OC_CONFIG_RESERVAS_TARIFAS IS

  PROCEDURE ELIMINAR(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2);
  PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, cCodReservaDest VARCHAR2);
  FUNCTION VALOR_PRIMA(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                       cPlanCob VARCHAR2, cTipoPrima VARCHAR2, dFecInicio DATE) RETURN NUMBER;
  PROCEDURE AGREGAR(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                    cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);

END OC_CONFIG_RESERVAS_TARIFAS;
/

CREATE OR REPLACE PACKAGE BODY OC_CONFIG_RESERVAS_TARIFAS AS

PROCEDURE ELIMINAR(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) IS
BEGIN
   BEGIN
      DELETE CONFIG_RESERVAS_TARIFAS
       WHERE CodCia     = nCodCia
         AND CodReserva = cCodReserva
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
                   AND PlanCob    = cPlanCob;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar Eliminar CONFIG_RESERVAS_TARIFAS,  '|| SQLERRM );
   END;
END ELIMINAR;

PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, cCodReservaDest VARCHAR2) IS
BEGIN
   BEGIN
      INSERT INTO CONFIG_RESERVAS_TARIFAS
            (CodCia, CodReserva, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, FecFinVig, 
             PrimaTarifaBasica, PrimaTarifaAdic, PrimaRiesgoBasica, PrimaRiesgoAdic)
      SELECT CodCia, cCodReservaDest, CodEmpresa, IdTipoSeg, PlanCob, FecIniVig, FecFinVig, 
             PrimaTarifaBasica, PrimaTarifaAdic, PrimaRiesgoBasica, PrimaRiesgoAdic
        FROM CONFIG_RESERVAS_TARIFAS
       WHERE CodCia     = nCodCia
         AND CodReserva = cCodReservaOrig;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar la Copia CONFIG_RESERVAS_TARIFAS,  '|| SQLERRM);
   END;
END COPIAR;

FUNCTION VALOR_PRIMA(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                     cPlanCob VARCHAR2, cTipoPrima VARCHAR2, dFecInicio DATE) RETURN NUMBER IS
nPrimaTarifaBasica  CONFIG_RESERVAS_TARIFAS.PrimaTarifaBasica%TYPE;
nPrimaTarifaAdic    CONFIG_RESERVAS_TARIFAS.PrimaTarifaAdic%TYPE;
nPrimaRiesgoBasica  CONFIG_RESERVAS_TARIFAS.PrimaRiesgoBasica%TYPE;
nPrimaRiesgoAdic    CONFIG_RESERVAS_TARIFAS.PrimaRiesgoAdic%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PrimaTarifaBasica,0), NVL(PrimaTarifaAdic,0),
             NVL(PrimaRiesgoBasica,0), NVL(PrimaRiesgoAdic,0)
        INTO nPrimaTarifaBasica, 
             nPrimaTarifaAdic, nPrimaRiesgoBasica, 
             nPrimaRiesgoAdic
        FROM CONFIG_RESERVAS_TARIFAS
       WHERE CodCia      = nCodCia
         AND CodReserva  = cCodReserva
         AND CodEmpresa  = nCodEmpresa
         AND IdTipoSeg   = cIdTipoSeg
                   AND PlanCob     = cPlanCob
         AND FecIniVig  <= dFecInicio
         AND FecFinVig  >= dFecInicio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPrimaTarifaBasica  := 0;
         nPrimaTarifaAdic    := 0;
         nPrimaRiesgoBasica  := 0;
         nPrimaRiesgoAdic    := 0;
   END;
   IF cTipoPrima = 'PTB' THEN
      RETURN(nPrimaTarifaBasica);
   ELSIF cTipoPrima = 'PTA' THEN
      RETURN(nPrimaTarifaAdic);
   ELSIF cTipoPrima = 'PRB' THEN
      RETURN(nPrimaRiesgoBasica);
   ELSIF cTipoPrima = 'PRA' THEN
      RETURN(nPrimaRiesgoAdic);
   ELSE
      RETURN(0);
   END IF;
END VALOR_PRIMA;

PROCEDURE AGREGAR(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                  cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2) IS
CURSOR GTO_Q IS
   SELECT FecIniVig, FecFinVig, PrimaTarifaBasica, PrimaTarifaAdic,
          PrimaRiesgoBasica, PrimaRiesgoAdic
     FROM CONFIG_RESERVAS_TARIFAS
    WHERE CodCia     = nCodCia
      AND CodReserva = cCodReserva
      AND CodEmpresa = nCodEmpresa
      AND IdTipoSeg  = cIdTipoSegOrig
      AND PlanCob    = cPlanCobOrig;
BEGIN
   FOR X IN GTO_Q LOOP
      INSERT INTO CONFIG_RESERVAS_TARIFAS
             (CodCia, CodReserva, CodEmpresa, IdTipoSeg, PlanCob,
              FecIniVig, FecFinVig, PrimaTarifaBasica, PrimaTarifaAdic,
              PrimaRiesgoBasica, PrimaRiesgoAdic)
      VALUES (nCodCia, cCodReserva, nCodEmpresa, cIdTipoSegDest, cPlanCobDest,
              X.FecIniVig, X.FecFinVig, X.PrimaTarifaBasica, X.PrimaTarifaAdic,
              X.PrimaRiesgoBasica, X.PrimaRiesgoAdic);
   END LOOP;
END AGREGAR;

END OC_CONFIG_RESERVAS_TARIFAS;

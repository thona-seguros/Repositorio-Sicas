CREATE OR REPLACE PACKAGE OC_CONFIG_RESERVAS_PLANCOB IS

  PROCEDURE ACTIVAR (nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2);
  PROCEDURE CONFIGURAR (nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2);
  PROCEDURE SUSPENDER (nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2);
  PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, cCodReservaDest VARCHAR2);
  PROCEDURE AGREGAR(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                    cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);

END OC_CONFIG_RESERVAS_PLANCOB;
 
 
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_CONFIG_RESERVAS_PLANCOB IS

PROCEDURE CONFIGURAR(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) IS
BEGIN
   UPDATE CONFIG_RESERVAS_PLANCOB
      SET StsPlanRva = 'CFG'
    WHERE CodCia     = nCodCia
           AND CodReserva = cCodReserva
      AND CodEmpresa = nCodEmpresa
      AND IdTipoSeg  = cIdTipoSeg
                AND PlanCob    = cPlanCob;
END CONFIGURAR;

PROCEDURE SUSPENDER(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) IS
BEGIN
   UPDATE CONFIG_RESERVAS_PLANCOB
      SET StsPlanRva = 'SUS'
    WHERE CodCia     = nCodCia
           AND CodReserva = cCodReserva
      AND CodEmpresa = nCodEmpresa
      AND IdTipoSeg  = cIdTipoSeg
                AND PlanCob    = cPlanCob;
END SUSPENDER;

PROCEDURE ACTIVAR (nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) IS
BEGIN
   UPDATE CONFIG_RESERVAS_PLANCOB
      SET StsPlanRva = 'ACT'
    WHERE CodCia     = nCodCia
           AND CodReserva = cCodReserva
      AND CodEmpresa = nCodEmpresa
      AND IdTipoSeg  = cIdTipoSeg
                AND PlanCob    = cPlanCob;
END ACTIVAR;

PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, cCodReservaDest VARCHAR2) IS
BEGIN
   BEGIN
      INSERT INTO CONFIG_RESERVAS_PLANCOB
                 (CodCia, CodReserva, CodEmpresa, IdTipoSeg, PlanCob,
                  FecAltaPlan, StsPlanRva, FecSts, CodUsuario)
           SELECT nCodCia, cCodReservaDest, CodEmpresa, IdTipoSeg, PlanCob,
                  FecAltaPlan, 'CFG', SYSDATE, USER
             FROM CONFIG_RESERVAS_PLANCOB
            WHERE CodCia     = nCodCia
                                  AND CodReserva = cCodReservaOrig;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar la Copia de CONFIG_RESERVAS_PLANCOB,  '|| SQLERRM);
   END;
END COPIAR;

PROCEDURE AGREGAR(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                  cPlanCobOrig VARCHAR2, cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2) IS
cStsReserva   CONFIG_RESERVAS.StsReserva%TYPE;
BEGIN
   BEGIN
      SELECT StsReserva
        INTO cStsReserva
        FROM CONFIG_RESERVAS
       WHERE CodCia     = nCodCia
                   AND CodReserva = cCodReserva;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20220,'No existe la Reserva '|| cCodReserva);
   END;
   BEGIN
      INSERT INTO CONFIG_RESERVAS_PLANCOB
             (CodCia, CodReserva, CodEmpresa, IdTipoSeg, PlanCob,
              FecAltaPlan, StsPlanRva, FecSts, CodUsuario)
      VALUES (nCodCia, cCodReserva, nCodEmpresa, cIdTipoSegDest, cPlanCobDest,
              TRUNC(SYSDATE), cStsReserva, TRUNC(SYSDATE), USER);
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar Insert en CONFIG_RESERVAS_PLANCOB,  '|| SQLERRM);
   END;
   OC_CONFIG_RESERVAS_PLANCOB_GTO.AGREGAR(nCodCia, cCodReserva, nCodEmpresa, cIdTipoSegOrig,
                                          cPlanCobOrig, cIdTipoSegDest, cPlanCobDest);
   OC_CONFIG_RESERVAS_TARIFAS.AGREGAR(nCodCia, cCodReserva, nCodEmpresa, cIdTipoSegOrig,
                                      cPlanCobOrig, cIdTipoSegDest, cPlanCobDest);
END AGREGAR;

END OC_CONFIG_RESERVAS_PLANCOB;

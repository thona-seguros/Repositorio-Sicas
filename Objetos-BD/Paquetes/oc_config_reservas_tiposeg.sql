--
-- OC_CONFIG_RESERVAS_TIPOSEG  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   OC_CONFIG_RESERVAS_FACTORSUF (Package)
--   OC_CONFIG_RESERVAS_PLANCOB (Package)
--   CONFIG_RESERVAS (Table)
--   CONFIG_RESERVAS_PLANCOB (Table)
--   CONFIG_RESERVAS_TIPOSEG (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONFIG_RESERVAS_TIPOSEG IS

  PROCEDURE ACTIVAR (nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2);
  PROCEDURE CONFIGURAR (nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2);
  PROCEDURE SUSPENDER (nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2);
  PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, cCodReservaDest VARCHAR2);
  PROCEDURE AGREGAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodReserva VARCHAR2,
                    cIdTipoSegOrig VARCHAR2, cIdTipoSegDest VARCHAR2);

END OC_CONFIG_RESERVAS_TIPOSEG;
/

--
-- OC_CONFIG_RESERVAS_TIPOSEG  (Package Body) 
--
--  Dependencies: 
--   OC_CONFIG_RESERVAS_TIPOSEG (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CONFIG_RESERVAS_TIPOSEG IS

PROCEDURE CONFIGURAR (nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) IS
CURSOR PLAN_Q IS
   SELECT PlanCob
     FROM CONFIG_RESERVAS_PLANCOB
    WHERE CodCia       = nCodCia
           AND CodReserva   = cCodReserva
      AND CodEmpresa   = nCodEmpresa
      AND IdTipoSeg    = cIdTipoSeg
      AND StsPlanRva   = 'ACT';
BEGIN
   FOR X IN PLAN_Q LOOP
      OC_CONFIG_RESERVAS_PLANCOB.CONFIGURAR(nCodCia, cCodReserva, nCodEmpresa, cIdTipoSeg, X.PlanCob);
   END LOOP;

   UPDATE CONFIG_RESERVAS_TIPOSEG
      SET StsTipoSegRva = 'CFG'
    WHERE CodCia       = nCodCia
           AND CodReserva   = cCodReserva
      AND CodEmpresa   = nCodEmpresa
      AND IdTipoSeg    = cIdTipoSeg;
END CONFIGURAR;

PROCEDURE SUSPENDER(nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) IS
CURSOR PLAN_Q IS
   SELECT PlanCob
     FROM CONFIG_RESERVAS_PLANCOB
    WHERE CodCia       = nCodCia
           AND CodReserva   = cCodReserva
      AND CodEmpresa   = nCodEmpresa
      AND IdTipoSeg    = cIdTipoSeg
      AND StsPlanRva   = 'ACT';
BEGIN
   FOR X IN PLAN_Q LOOP
      OC_CONFIG_RESERVAS_PLANCOB.SUSPENDER(nCodCia, cCodReserva, nCodEmpresa, cIdTipoSeg, X.PlanCob);
   END LOOP;

   UPDATE CONFIG_RESERVAS_TIPOSEG
      SET StsTipoSegRva = 'SUS'
    WHERE CodCia       = nCodCia
           AND CodReserva   = cCodReserva
      AND CodEmpresa   = nCodEmpresa
      AND IdTipoSeg    = cIdTipoSeg;
END SUSPENDER;

PROCEDURE ACTIVAR (nCodCia NUMBER, cCodReserva VARCHAR2, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) IS
cStsTipoSegRva  CONFIG_RESERVAS_TIPOSEG.StsTipoSegRva%TYPE;
cStsPlan        CONFIG_RESERVAS_PLANCOB.StsPlanRva%TYPE;
CURSOR PLAN_Q IS
   SELECT PlanCob
     FROM CONFIG_RESERVAS_PLANCOB
    WHERE CodCia       = nCodCia
           AND CodReserva   = cCodReserva
      AND CodEmpresa   = nCodEmpresa
      AND IdTipoSeg    = cIdTipoSeg
      AND StsPlanRva   = cStsPlan;
BEGIN
   BEGIN
      SELECT StsTipoSegRva
        INTO cStsTipoSegRva
        FROM CONFIG_RESERVAS_TIPOSEG
       WHERE CodCia       = nCodCia
         AND CodReserva   = cCodReserva
         AND CodEmpresa   = nCodEmpresa
         AND IdTipoSeg    = cIdTipoSeg;
   END;
   IF cStsTipoSegRva = 'CFG' THEN
      cStsPlan := 'CFG';
      FOR X IN PLAN_Q LOOP
         OC_CONFIG_RESERVAS_PLANCOB.ACTIVAR(nCodCia, cCodReserva, nCodEmpresa, cIdTipoSeg, X.PlanCob);
      END LOOP;
   ELSE
      cStsPlan := 'SUS';
      FOR X IN PLAN_Q LOOP
         OC_CONFIG_RESERVAS_PLANCOB.ACTIVAR(nCodCia, cCodReserva, nCodEmpresa, cIdTipoSeg, X.PlanCob);
      END LOOP;
   END IF;
   UPDATE CONFIG_RESERVAS_TIPOSEG
      SET StsTipoSegRva = 'ACT'
    WHERE CodCia       = nCodCia
           AND CodReserva   = cCodReserva
      AND CodEmpresa   = nCodEmpresa
      AND IdTipoSeg    = cIdTipoSeg;
END ACTIVAR;

PROCEDURE COPIAR (nCodCia NUMBER, cCodReservaOrig VARCHAR2, cCodReservaDest VARCHAR2) IS
BEGIN
   BEGIN
      INSERT INTO CONFIG_RESERVAS_TIPOSEG
                 (CodCia, CodReserva, CodEmpresa, IdTipoSeg,
                  FecAlta, StsTipoSegRva, FecSts, CodUsuario)
           SELECT nCodCia, cCodReservaDest, CodEmpresa, IdTipoSeg,
                  FecAlta, 'CFG', SYSDATE, USER
             FROM CONFIG_RESERVAS_TIPOSEG
            WHERE CodCia     = nCodCia
                                  AND CodReserva = cCodReservaOrig;
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar la Copia de CONFIG_RESREVAS_TIPOSEG  '|| SQLERRM );
   END;
END COPIAR;

PROCEDURE AGREGAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodReserva VARCHAR2,
                  cIdTipoSegOrig VARCHAR2, cIdTipoSegDest VARCHAR2) IS
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
      INSERT INTO CONFIG_RESERVAS_TIPOSEG
             (CodCia, CodReserva, CodEmpresa, IdTipoSeg,
              FecAlta, StsTipoSegRva, FecSts, CodUsuario)
      VALUES (nCodCia, cCodReserva, nCodEmpresa, cIdTipoSegDest,
              TRUNC(SYSDATE), cStsReserva, TRUNC(SYSDATE), USER);
   EXCEPTION
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20220,'Error en Realizar el Insert en CONFIG_RESREVAS_TIPOSEG  '|| SQLERRM );
   END;
   OC_CONFIG_RESERVAS_FACTORSUF.AGREGAR(nCodCia, cCodReserva, nCodEmpresa,
                                        cIdTipoSegOrig, cIdTipoSegDest);

END AGREGAR;

END OC_CONFIG_RESERVAS_TIPOSEG;
/

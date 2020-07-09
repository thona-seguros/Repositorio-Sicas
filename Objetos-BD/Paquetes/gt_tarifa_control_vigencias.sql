--
-- GT_TARIFA_CONTROL_VIGENCIAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   OC_TARIFA_SEXO_EDAD_RIESGO (Package)
--   TARIFA_CONTROL_VIGENCIAS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_TARIFA_CONTROL_VIGENCIAS IS

  FUNCTION NUMERO_TARIFA RETURN NUMBER;
  PROCEDURE CONFIGURAR (nIdTarifa NUMBER);
  PROCEDURE ACTIVAR (nIdTarifa NUMBER);
  PROCEDURE SUSPENDER (nIdTarifa NUMBER);
  PROCEDURE COPIAR (nIdTarifaOrig NUMBER, nIdTarifaDest NUMBER);
  FUNCTION TARIFA_VIGENTE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                           cPlanCob VARCHAR2, dFecTarifa DATE) RETURN NUMBER;
  PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                     cPlanCob VARCHAR2, nIdTarifa NUMBER, dFecIniTarifa DATE,
                     dFecFinTarifa DATE, cObservTarifa VARCHAR2);

END GT_TARIFA_CONTROL_VIGENCIAS;
/

--
-- GT_TARIFA_CONTROL_VIGENCIAS  (Package Body) 
--
--  Dependencies: 
--   GT_TARIFA_CONTROL_VIGENCIAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_TARIFA_CONTROL_VIGENCIAS IS

FUNCTION NUMERO_TARIFA RETURN NUMBER IS
nIdTarifa     TARIFA_CONTROL_VIGENCIAS.IdTarifa%TYPE;
BEGIN
   SELECT NVL(MAX(IdTarifa),0)+1
     INTO nIdTarifa
     FROM TARIFA_CONTROL_VIGENCIAS;
   RETURN(nIdTarifa);
END NUMERO_TARIFA;

PROCEDURE CONFIGURAR (nIdTarifa NUMBER) IS
BEGIN
   UPDATE TARIFA_CONTROL_VIGENCIAS
      SET StsTarifa    = 'CONFIG',
          FecSts       = TRUNC(SYSDATE),
          CodUsuario   = USER,
          FecUltCambio = TRUNC(SYSDATE)
    WHERE IdTarifa     = nIdTarifa;
END CONFIGURAR;

PROCEDURE SUSPENDER (nIdTarifa NUMBER) IS
BEGIN
   UPDATE TARIFA_CONTROL_VIGENCIAS
      SET StsTarifa    = 'SUSPEN',
          FecSts       = TRUNC(SYSDATE),
          CodUsuario   = USER,
          FecUltCambio = TRUNC(SYSDATE)
    WHERE IdTarifa     = nIdTarifa;
END SUSPENDER;

PROCEDURE ACTIVAR (nIdTarifa NUMBER) IS
BEGIN
   UPDATE TARIFA_CONTROL_VIGENCIAS
      SET StsTarifa    = 'ACTIVA',
          FecSts       = TRUNC(SYSDATE),
          CodUsuario   = USER,
          FecUltCambio = TRUNC(SYSDATE)
    WHERE IdTarifa     = nIdTarifa;
END ACTIVAR;

PROCEDURE COPIAR (nIdTarifaOrig NUMBER, nIdTarifaDest NUMBER) IS
CURSOR TARIF_Q IS
   SELECT nIdTarifaDest, CodCia, CodEmpresa, IdTipoSeg, PlanCob,
          FecIniTarifa, FecFinTarifa, ObservTarifa
     FROM TARIFA_CONTROL_VIGENCIAS
    WHERE IdTarifa   = nIdTarifaOrig;
BEGIN
   FOR W IN TARIF_Q LOOP
      BEGIN
         INSERT INTO TARIFA_CONTROL_VIGENCIAS
               (IdTarifa, CodCia, CodEmpresa, IdTipoSeg, PlanCob,
                FecIniTarifa, FecFinTarifa, ObservTarifa, StsTarifa,
                FecSts, CodUsuario, FecUltCambio)
         VALUES(nIdTarifaDest, W.CodCia, W.CodEmpresa, W.IdTipoSeg, W.PlanCob,
                W.FecIniTarifa, W.FecFinTarifa, W.ObservTarifa, 'CONFIG',
                TRUNC(SYSDATE), USER, TRUNC(SYSDATE));

         OC_TARIFA_SEXO_EDAD_RIESGO.COPIAR(W.CodCia, W.CodEmpresa, W.IdTipoSeg, W.PlanCob,
                                           W.IdTipoSeg, W.PlanCob, nIdTarifaOrig, nIdTarifaDest);
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20220,'Error en Realizar la Copia de TARIFA_CONTROL_VIGENCIAS,  '|| SQLERRM);
      END;
   END LOOP;
END COPIAR;

FUNCTION TARIFA_VIGENTE(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                        cPlanCob VARCHAR2, dFecTarifa DATE) RETURN NUMBER IS
nIdTarifa   TARIFA_CONTROL_VIGENCIAS.IdTarifa%TYPE;
BEGIN
   SELECT NVL(MAX(IdTarifa),0)
     INTO nIdTarifa
     FROM TARIFA_CONTROL_VIGENCIAS
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdTipoSeg     = cIdTipoSeg
      AND PlanCob       = cPlanCob
      AND FecIniTarifa <= dFecTarifa
      AND FecFinTarifa >= dFecTarifa
      AND StsTarifa     = 'ACTIVA';

   RETURN(nIdTarifa);
END TARIFA_VIGENTE;

PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, 
                   cPlanCob VARCHAR2, nIdTarifa NUMBER, dFecIniTarifa DATE,
                   dFecFinTarifa DATE, cObservTarifa VARCHAR2) IS
BEGIN
   BEGIN
      INSERT INTO TARIFA_CONTROL_VIGENCIAS
            (IdTarifa, CodCia, CodEmpresa, IdTipoSeg, PlanCob,
             FecIniTarifa, FecFinTarifa, ObservTarifa, StsTarifa,
             FecSts, CodUsuario, FecUltCambio)
      VALUES(nIdTarifa, nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob,
             dFecIniTarifa, dFecFinTarifa, cObservTarifa, 'CONFIG',
             TRUNC(SYSDATE), USER, TRUNC(SYSDATE));
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20220,'Error en Realizar el INSERT de TARIFA_CONTROL_VIGENCIAS:  '|| SQLERRM);
   END;
END INSERTAR;

END GT_TARIFA_CONTROL_VIGENCIAS;
/

--
-- GT_TARIFA_CONTROL_VIGENCIAS  (Synonym) 
--
--  Dependencies: 
--   GT_TARIFA_CONTROL_VIGENCIAS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_TARIFA_CONTROL_VIGENCIAS FOR SICAS_OC.GT_TARIFA_CONTROL_VIGENCIAS
/


GRANT EXECUTE ON SICAS_OC.GT_TARIFA_CONTROL_VIGENCIAS TO PUBLIC
/

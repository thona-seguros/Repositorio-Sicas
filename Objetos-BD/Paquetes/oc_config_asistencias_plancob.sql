--
-- OC_CONFIG_ASISTENCIAS_PLANCOB  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   CONFIG_ASISTENCIAS_PLANCOB (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONFIG_ASISTENCIAS_PLANCOB IS

  PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                   cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2);
  PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                    cCodAsistencia VARCHAR2);
  PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                      cCodAsistencia VARCHAR2);
  FUNCTION TIENE_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2;

END OC_CONFIG_ASISTENCIAS_PLANCOB;
/

--
-- OC_CONFIG_ASISTENCIAS_PLANCOB  (Package Body) 
--
--  Dependencies: 
--   OC_CONFIG_ASISTENCIAS_PLANCOB (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CONFIG_ASISTENCIAS_PLANCOB IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2, cPlanCobOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2, cPlanCobDest VARCHAR2) IS
CURSOR ASIST_Q IS
  SELECT CodAsistencia, IndAsistOblig
    FROM CONFIG_ASISTENCIAS_PLANCOB
   WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdTipoSeg  = cIdTipoSegOrig
     AND PlanCob    = cPlanCobOrig;
BEGIN
   FOR X IN ASIST_Q LOOP
      INSERT INTO CONFIG_ASISTENCIAS_PLANCOB
             (CodCia, CodEmpresa, IdTipoSeg, PlanCob, CodAsistencia, IndAsistOblig,
              StsPlanCobAsist, FecSts, CodUsuario, FecUltCambio)
      VALUES (nCodCia, nCodEmpresa, cIdTipoSegDest, cPlanCobDest, X.CodAsistencia, X.IndAsistOblig,
              'SOLICI', TRUNC(SYSDATE), USER, TRUNC(SYSDATE));
   END LOOP;
END COPIAR;

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                  cCodAsistencia VARCHAR2) IS
BEGIN
   UPDATE CONFIG_ASISTENCIAS_PLANCOB
      SET StsPlanCobAsist = 'ACTIVA',
          FecSts          = TRUNC(SYSDATE),
          CodUsuario      = USER,
          FecUltCambio    = TRUNC(SYSDATE)
   WHERE CodCia        = nCodCia
     AND CodEmpresa    = nCodEmpresa
     AND IdTipoSeg     = cIdTipoSeg
     AND PlanCob       = cPlanCob
     AND CodAsistencia = cCodAsistencia;
END ACTIVAR;

PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                    cCodAsistencia VARCHAR2) IS
BEGIN
   UPDATE CONFIG_ASISTENCIAS_PLANCOB
      SET StsPlanCobAsist = 'SUSPEN',
          FecSts          = TRUNC(SYSDATE),
          CodUsuario      = USER,
          FecUltCambio    = TRUNC(SYSDATE)
   WHERE CodCia        = nCodCia
     AND CodEmpresa    = nCodEmpresa
     AND IdTipoSeg     = cIdTipoSeg
     AND PlanCob       = cPlanCob
     AND CodAsistencia = cCodAsistencia;
END SUSPENDER;

FUNCTION TIENE_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM CONFIG_ASISTENCIAS_PLANCOB
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND IdTipoSeg       = cIdTipoSeg
         AND PlanCob         = cPlanCob
         AND StsPlanCobAsist = 'ACTIVA';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste  := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste  := 'S';
   END;
   RETURN(cExiste);
END TIENE_ASISTENCIAS;

END OC_CONFIG_ASISTENCIAS_PLANCOB;
/

--
-- OC_CONFIG_ASISTENCIAS_PLANCOB  (Synonym) 
--
--  Dependencies: 
--   OC_CONFIG_ASISTENCIAS_PLANCOB (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_CONFIG_ASISTENCIAS_PLANCOB FOR SICAS_OC.OC_CONFIG_ASISTENCIAS_PLANCOB
/


GRANT EXECUTE ON SICAS_OC.OC_CONFIG_ASISTENCIAS_PLANCOB TO PUBLIC
/

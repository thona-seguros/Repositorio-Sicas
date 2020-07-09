--
-- OC_SOLICITUD_ASISTENCIAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   SOLICITUD_ASISTENCIAS (Table)
--   SOLICITUD_DETALLE (Table)
--   SOLICITUD_EMISION (Table)
--   CONFIG_ASISTENCIAS_PLANCOB (Table)
--   ASISTENCIAS_ASEGURADO (Table)
--   OC_ASISTENCIAS (Package)
--   OC_SOLICITUD_DETALLE (Package)
--   OC_SOLICITUD_EMISION (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_SOLICITUD_ASISTENCIAS IS

PROCEDURE CARGAR_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                             nIdSolicitud NUMBER, nIDetSol NUMBER, nTasaCambio NUMBER, cCodMoneda VARCHAR2,
                             dFecIniVig DATE, dFecFinVig DATE);

PROCEDURE ACTUALIZA_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                                nIdSolicitud NUMBER, nIDetSol NUMBER, nTasaCambio NUMBER, cCodMoneda VARCHAR2, 
                                dFecIniVig DATE, dFecFinVig DATE);

FUNCTION TOTAL_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN NUMBER;

FUNCTION TIENE_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN VARCHAR2;

PROCEDURE TRASLADA_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, 
                               nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);

PROCEDURE ELIMINAR_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER);

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitudOrig NUMBER, nIdSolicitudDest NUMBER);

END OC_SOLICITUD_ASISTENCIAS;
/

--
-- OC_SOLICITUD_ASISTENCIAS  (Package Body) 
--
--  Dependencies: 
--   OC_SOLICITUD_ASISTENCIAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_SOLICITUD_ASISTENCIAS IS
PROCEDURE CARGAR_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                             nIdSolicitud NUMBER, nIDetSol NUMBER, nTasaCambio NUMBER, cCodMoneda VARCHAR2,
                             dFecIniVig DATE, dFecFinVig DATE) IS
nMontoAsistLocal     ASISTENCIAS_ASEGURADO.MontoAsistLocal%TYPE;
nMontoAsistMoneda    ASISTENCIAS_ASEGURADO.MontoAsistMoneda%TYPE;
nCantAsegModelo      SOLICITUD_DETALLE.CantAsegModelo%TYPE;
nCantAsist           NUMBER(5);

CURSOR ASIST_Q IS
  SELECT CodAsistencia
    FROM CONFIG_ASISTENCIAS_PLANCOB
   WHERE CodCia          = nCodCia
     AND CodEmpresa      = nCodEmpresa
     AND IdTipoSeg       = cIdTipoSeg
     AND PlanCob         = cPlanCob
     AND StsPlanCobAsist = 'ACTIVA'
     AND IndAsistOblig   = 'S';
BEGIN
   SELECT COUNT(*)
     INTO nCantAsist
     FROM SOLICITUD_ASISTENCIAS
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdSolicitud   = nIdSolicitud
      AND IDetSol       = nIDetSol;

   IF NVL(nCantAsist,0) = 0 THEN
      IF OC_SOLICITUD_EMISION.ASEGURADO_MODELO(nCodCia, nCodEmpresa, nIdSolicitud) = 'S' THEN
         nCantAsegModelo := OC_SOLICITUD_DETALLE.CANTIDAD_ASEGURADOS(nCodCia, nCodEmpresa, nIdSolicitud, nIDetSol);
      ELSE
         nCantAsegModelo := 1;
      END IF;

      FOR X IN ASIST_Q LOOP
         nMontoAsistMoneda := OC_ASISTENCIAS.CALCULA_ASISTENCIA(nCodCia, nCodEmpresa, X.CodAsistencia,
                                                               dFecIniVig, dFecFinVig);
         nMontoAsistLocal  := nMontoAsistMoneda * nTasaCambio;
         INSERT INTO SOLICITUD_ASISTENCIAS
                (CodCia, CodEmpresa, IdSolicitud, IDetSol, CodAsistencia,
                 MontoAsistLocal, MontoAsistMoneda)
         VALUES (nCodCia, nCodEmpresa, nIdSolicitud, nIDetSol, X.CodAsistencia,
                 nMontoAsistLocal * nCantAsegModelo, nMontoAsistMoneda * nCantAsegModelo);
      END LOOP;
   END IF;
END CARGAR_ASISTENCIAS;

PROCEDURE ACTUALIZA_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                                nIdSolicitud NUMBER, nIDetSol NUMBER, nTasaCambio NUMBER, cCodMoneda VARCHAR2, 
                                dFecIniVig DATE, dFecFinVig DATE) IS
nMontoAsistLocal     ASISTENCIAS_ASEGURADO.MontoAsistLocal%TYPE;
nMontoAsistMoneda    ASISTENCIAS_ASEGURADO.MontoAsistMoneda%TYPE;
nCantAsegModelo      SOLICITUD_DETALLE.CantAsegModelo%TYPE;

CURSOR ASIST_Q IS
  SELECT CodAsistencia
    FROM CONFIG_ASISTENCIAS_PLANCOB
   WHERE CodCia          = nCodCia
     AND CodEmpresa      = nCodEmpresa
     AND IdTipoSeg       = cIdTipoSeg
     AND PlanCob         = cPlanCob
     AND StsPlanCobAsist = 'ACTIVA'
     AND IndAsistOblig   = 'S';
BEGIN
   IF OC_SOLICITUD_EMISION.ASEGURADO_MODELO(nCodCia, nCodEmpresa, nIdSolicitud) = 'S' THEN
      nCantAsegModelo := OC_SOLICITUD_DETALLE.CANTIDAD_ASEGURADOS(nCodCia, nCodEmpresa, nIdSolicitud, nIDetSol);
   ELSE
      nCantAsegModelo := 1;
   END IF;

   FOR X IN ASIST_Q LOOP
      nMontoAsistMoneda := OC_ASISTENCIAS.CALCULA_ASISTENCIA(nCodCia, nCodEmpresa, X.CodAsistencia,
                                                             dFecIniVig, dFecFinVig);
      nMontoAsistLocal  := nMontoAsistMoneda * nTasaCambio;
      UPDATE SOLICITUD_ASISTENCIAS
         SET MontoAsistLocal  = nMontoAsistLocal * nCantAsegModelo,
             MontoAsistMoneda = nMontoAsistMoneda * nCantAsegModelo
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdSolicitud   = nIdSolicitud
         AND IDetSol       = nIDetSol
         AND CodAsistencia = X.CodAsistencia;
   END LOOP;
END ACTUALIZA_ASISTENCIAS;

FUNCTION TOTAL_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN NUMBER IS
nMontoAsistMoneda    SOLICITUD_ASISTENCIAS.MontoAsistMoneda%TYPE;
BEGIN
   SELECT NVL(SUM(MontoAsistMoneda),0)
     INTO nMontoAsistMoneda
     FROM SOLICITUD_ASISTENCIAS
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdSolicitud   = nIdSolicitud
      AND IDetSol       = nIDetSol;

   RETURN(nMontoAsistMoneda);
END TOTAL_ASISTENCIAS;

FUNCTION TIENE_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM SOLICITUD_ASISTENCIAS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdSolicitud   = nIdSolicitud
         AND IDetSol       = nIDetSol;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          cExiste := 'N';
       WHEN TOO_MANY_ROWS THEN
          cExiste := 'S';
    END;
    RETURN(cExiste);
END TIENE_ASISTENCIAS;

PROCEDURE TRASLADA_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, 
                               nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
CURSOR COB_Q IS
   SELECT SA.CodAsistencia, SA.MontoAsistLocal, SA.MontoAsistMoneda,
          SE.IdTipoSeg, SE.PlanCob, SE.Cod_Moneda
     FROM SOLICITUD_ASISTENCIAS SA, SOLICITUD_EMISION SE
    WHERE SA.CodCia        = SE.CodCia
      AND SA.CodEmpresa    = SE.CodEmpresa
      AND SA.IDetSol       = nIDetPol
      AND SA.IdSolicitud   = SE.IdSolicitud
      AND SE.CodCia        = nCodCia
      AND SE.CodEmpresa    = nCodEmpresa
      AND SE.IdSolicitud   = nIdSolicitud;
BEGIN
   FOR W IN COB_Q LOOP
      BEGIN
         INSERT INTO ASISTENCIAS_ASEGURADO
                (CodCia, CodEmpresa, IdPoliza, IDetPol, Cod_Asegurado, CodAsistencia,
                 CodMoneda, MontoAsistLocal, MontoAsistMoneda, StsAsistencia,
                 FecSts, IdEndoso)
         VALUES (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCod_Asegurado, W.CodAsistencia,
                 W.Cod_Moneda, W.MontoAsistLocal, W.MontoAsistMoneda, 'SOLICI',
                 TRUNC(SYSDATE), 0);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20225,'Existen Asistencias Duplicadas para Detalle de la Póliza: '||
                                    TRIM(TO_CHAR(nIdPoliza))||' - '||TO_CHAR(nIDetPol) || ' y Asegurado '||
                                    nCod_Asegurado);
      END;
   END LOOP;
END TRASLADA_ASISTENCIAS;

PROCEDURE ELIMINAR_ASISTENCIAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) IS
BEGIN
   DELETE SOLICITUD_ASISTENCIAS
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdSolicitud   = nIdSolicitud
      AND IDetSol       = nIDetSol;
END ELIMINAR_ASISTENCIAS;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitudOrig NUMBER, nIdSolicitudDest NUMBER) IS
BEGIN
   INSERT INTO SOLICITUD_ASISTENCIAS
         (CodCia, CodEmpresa, IdSolicitud, IDetSol, CodAsistencia, MontoAsistLocal, MontoAsistMoneda)
   SELECT CodCia, CodEmpresa, nIdSolicitudDest, IDetSol, CodAsistencia, MontoAsistLocal, MontoAsistMoneda
     FROM SOLICITUD_ASISTENCIAS
    WHERE CodCia      = nCodCia 
      AND CodEmpresa  = nCodEmpresa
      AND IdSolicitud = nIdSolicitudOrig;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Asistencias en Solicitud No. ' || nIdSolicitudDest);
END COPIAR;

END OC_SOLICITUD_ASISTENCIAS;
/

--
-- OC_SOLICITUD_ASISTENCIAS  (Synonym) 
--
--  Dependencies: 
--   OC_SOLICITUD_ASISTENCIAS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_SOLICITUD_ASISTENCIAS FOR SICAS_OC.OC_SOLICITUD_ASISTENCIAS
/


GRANT EXECUTE ON SICAS_OC.OC_SOLICITUD_ASISTENCIAS TO PUBLIC
/

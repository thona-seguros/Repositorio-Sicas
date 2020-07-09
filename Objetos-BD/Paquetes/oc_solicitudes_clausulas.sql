--
-- OC_SOLICITUDES_CLAUSULAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   SOLICITUDES_CLAUSULAS (Table)
--   CLAUSULAS (Table)
--   CLAUSULAS_DETALLE (Table)
--   CLAUSULAS_PLAN_COBERTURAS (Table)
--   CLAUSULAS_POLIZA (Table)
--   CLAUSULAS_TIPOS_SEGUROS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_SOLICITUDES_CLAUSULAS IS

PROCEDURE CARGAR_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                           nIdSolicitud NUMBER, dFecIniVig DATE, dFecFinVig DATE);

FUNCTION TIENE_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2;

PROCEDURE TRASLADA_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER,
                             nIdPoliza NUMBER);

PROCEDURE ELIMINAR_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER);

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitudOrig NUMBER, nIdSolicitudDest NUMBER);

END OC_SOLICITUDES_CLAUSULAS;
/

--
-- OC_SOLICITUDES_CLAUSULAS  (Package Body) 
--
--  Dependencies: 
--   OC_SOLICITUDES_CLAUSULAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_SOLICITUDES_CLAUSULAS IS
--
-- BITACORA DE CAMBIOS
-- SE AGREGO LA FUNCIONALIDAD PARA RENOVACION DE CLAUSULAS 10/08/2017  CLAUREN
--
PROCEDURE CARGAR_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                             nIdSolicitud NUMBER, dFecIniVig DATE, dFecFinVig DATE) IS
cTextoClausula  CLAUSULAS.TextoClausula%TYPE;
nCod_Clausula   CLAUSULAS_DETALLE.Cod_Clausula%TYPE;

CURSOR CLAU_Q IS
   SELECT C.CodClausula
     FROM CLAUSULAS_TIPOS_SEGUROS CTS, CLAUSULAS C
    WHERE CTS.IdTipoSeg   = cIdTipoSeg
      AND CTS.CodCia      = nCodCia
      AND CTS.CodEmpresa  = nCodEmpresa
      AND CTS.IDRENOVACION = 'N'  --CLAUREN
      AND C.CodClausula   = CTS.CodClausula
      AND C.CodCia        = CTS.CodCia
      AND C.CodEmpresa    = CTS.CodEmpresa
      AND C.StsClausula   = 'ACTIVA'
      AND C.IndOblig      = 'S'
    UNION
   SELECT C.CodClausula
     FROM CLAUSULAS_PLAN_COBERTURAS CTS, CLAUSULAS C
    WHERE CTS.PlanCob     = cPlanCOb
      AND CTS.IdTipoSeg   = cIdTipoSeg
      AND CTS.CodCia      = nCodCia
      AND CTS.CodEmpresa  = nCodEmpresa
      AND CTS.IDRENOVACION = 'N'  --CLAUREN
      AND C.CodClausula   = CTS.CodClausula
      AND C.CodCia        = CTS.CodCia
      AND C.CodEmpresa    = CTS.CodEmpresa
      AND C.StsClausula   = 'ACTIVA'
      AND C.IndOblig      = 'S'
    MINUS
   SELECT SC.Tipo_Clausula
     FROM SOLICITUDES_CLAUSULAS SC
    WHERE SC.IdPoliza  = nIdSolicitud
      AND SC.CodCia    = nCodCia;
BEGIN
   FOR X IN CLAU_Q LOOP
      SELECT NVL(MAX(Cod_Clausula),0) + 1
        INTO nCod_Clausula
        FROM SOLICITUDES_CLAUSULAS
       WHERE CodCia    = nCodCia
         AND IdPoliza  = nIdSolicitud;

      BEGIN
         SELECT TextoClausula
           INTO cTextoClausula
           FROM CLAUSULAS
          WHERE CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND CodClausula = X.CodClausula;
      EXCEPTION
           WHEN NO_DATA_FOUND THEN
              cTextoClausula := NULL;
      END;

      INSERT INTO SOLICITUDES_CLAUSULAS
             (CodCia, IdPoliza, Cod_Clausula, Tipo_Clausula,
              Texto, Inicio_Vigencia, Fin_Vigencia, Estado)
      VALUES (nCodCia, nIdSolicitud, nCod_Clausula, X.CodClausula,
              cTextoClausula, dFecIniVig, dFecFinVig, 'SOLICI');
  END LOOP;
END CARGAR_CLAUSULAS;

FUNCTION TIENE_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM SOLICITUDES_CLAUSULAS
       WHERE CodCia     = nCodCia
         AND IdPoliza   = nIdSolicitud;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          cExiste := 'N';
       WHEN TOO_MANY_ROWS THEN
          cExiste := 'S';
    END;
    RETURN(cExiste);
END TIENE_CLAUSULAS;

PROCEDURE TRASLADA_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER,
                             nIdPoliza NUMBER) IS
cTexto     SOLICITUDES_CLAUSULAS.Texto%TYPE;
CURSOR CLAU_Q IS
   SELECT CodCia, IdPoliza, Cod_Clausula, Tipo_Clausula,
          Inicio_Vigencia, Fin_Vigencia, Estado
     FROM SOLICITUDES_CLAUSULAS
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdSolicitud;
BEGIN
   FOR W IN CLAU_Q LOOP
      BEGIN
         SELECT Texto
           INTO cTexto
           FROM SOLICITUDES_CLAUSULAS
          WHERE CodCia       = W.CodCia
            AND IdPoliza     = W.IdPoliza
            AND Cod_Clausula = W.Cod_Clausula;
      EXCEPTION
           WHEN NO_DATA_FOUND THEN
              cTexto := NULL;
      END;
      BEGIN
         INSERT INTO CLAUSULAS_POLIZA
                (CodCia, IdPoliza, Cod_Clausula, Tipo_Clausula,
                 Texto, Inicio_Vigencia, Fin_Vigencia, Estado)
         VALUES (nCodCia, nIdPoliza, W.Cod_Clausula, W.Tipo_Clausula,
                 cTexto, W.Inicio_Vigencia, W.Fin_Vigencia, 'EMITID');
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20225,'Existen Cláusulas Duplicadas para la Póliza: '||
                                    TRIM(TO_CHAR(nIdPoliza)));
      END;
   END LOOP;
END TRASLADA_CLAUSULAS;

PROCEDURE ELIMINAR_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) IS
BEGIN
   DELETE SOLICITUDES_CLAUSULAS
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdSolicitud;
END ELIMINAR_CLAUSULAS;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitudOrig NUMBER, nIdSolicitudDest NUMBER) IS
cTexto     SOLICITUDES_CLAUSULAS.Texto%TYPE;
CURSOR CLAU_Q IS
   SELECT CodCia, IdPoliza, Cod_Clausula, Tipo_Clausula,
          Inicio_Vigencia, Fin_Vigencia
     FROM SOLICITUDES_CLAUSULAS
    WHERE CodCia      = nCodCia
      AND IdPoliza    = nIdSolicitudOrig;
BEGIN
   FOR W IN CLAU_Q LOOP
      BEGIN
         SELECT Texto
           INTO cTexto
           FROM SOLICITUDES_CLAUSULAS
          WHERE CodCia       = W.CodCia
            AND IdPoliza     = W.IdPoliza
            AND Cod_Clausula = W.Cod_Clausula;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cTexto := NULL;
      END;
      BEGIN
         INSERT INTO SOLICITUDES_CLAUSULAS
               (CodCia, IdPoliza, Cod_Clausula, Tipo_Clausula,
                Texto, Inicio_Vigencia, Fin_Vigencia, Estado)
         VALUES(nCodCia, nIdSolicitudDest, W.Cod_Clausula, W.Tipo_Clausula,
                cTexto, W.Inicio_Vigencia, W.Fin_Vigencia, 'SOLICI');
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Cláusulas en Solicitud No. ' || nIdSolicitudDest);
      END;
   END LOOP;
END COPIAR;

END OC_SOLICITUDES_CLAUSULAS;
/

--
-- OC_SOLICITUDES_CLAUSULAS  (Synonym) 
--
--  Dependencies: 
--   OC_SOLICITUDES_CLAUSULAS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_SOLICITUDES_CLAUSULAS FOR SICAS_OC.OC_SOLICITUDES_CLAUSULAS
/


GRANT EXECUTE ON SICAS_OC.OC_SOLICITUDES_CLAUSULAS TO PUBLIC
/

--
-- OC_SOLICITUD_AGENTES_DISTRIB  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   SOLICITUD_AGENTES_DISTRIB (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_SOLICITUD_AGENTES_DISTRIB IS

PROCEDURE ELIMINAR(nCodCia NUMBER, nIdSolicitud NUMBER);

FUNCTION TIENE_DISTRIBUCION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2;

FUNCTION PORCENTAJE_COMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN NUMBER;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitudOrig NUMBER, nIdSolicitudDest NUMBER);

END OC_SOLICITUD_AGENTES_DISTRIB;
/

--
-- OC_SOLICITUD_AGENTES_DISTRIB  (Package Body) 
--
--  Dependencies: 
--   OC_SOLICITUD_AGENTES_DISTRIB (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_SOLICITUD_AGENTES_DISTRIB IS
PROCEDURE ELIMINAR(nCodCia NUMBER, nIdSolicitud NUMBER) IS
BEGIN
    DELETE SOLICITUD_AGENTES_DISTRIB
     WHERE CodCia      = nCodCia 
       AND IdSolicitud = nIdSolicitud;
END ELIMINAR;

FUNCTION TIENE_DISTRIBUCION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM SOLICITUD_AGENTES_DISTRIB
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdSolicitud   = nIdSolicitud;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          cExiste := 'N';
       WHEN TOO_MANY_ROWS THEN
          cExiste := 'S';
    END;
    RETURN(cExiste);
END TIENE_DISTRIBUCION;

FUNCTION PORCENTAJE_COMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN NUMBER IS
nPorc_Com_Distribuida    SOLICITUD_AGENTES_DISTRIB.Porc_Com_Distribuida%TYPE;
BEGIN
   SELECT NVL(SUM(Porc_Com_Distribuida),0)
     INTO nPorc_Com_Distribuida
     FROM SOLICITUD_AGENTES_DISTRIB
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdSolicitud   = nIdSolicitud;

    RETURN(nPorc_Com_Distribuida);
END PORCENTAJE_COMISION;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitudOrig NUMBER, nIdSolicitudDest NUMBER) IS
BEGIN
   INSERT INTO SOLICITUD_AGENTES_DISTRIB
         (CodCia, CodEmpresa, IdSolicitud, Cod_Agente, CodNivel, Cod_Agente_Distr, 
          Porc_Comision_Agente, Porc_Com_Distribuida, Porc_Comision_Plan,
          Porc_Com_Proporcional, Cod_Agente_Jefe, Porc_Com_Solicitud, Origen)
   SELECT CodCia, CodEmpresa, nIdSolicitudDest, Cod_Agente, CodNivel, Cod_Agente_Distr, 
          Porc_Comision_Agente, Porc_Com_Distribuida, Porc_Comision_Plan,
          Porc_Com_Proporcional, Cod_Agente_Jefe, Porc_Com_Solicitud, Origen
     FROM SOLICITUD_AGENTES_DISTRIB
    WHERE CodCia      = nCodCia 
      AND CodEmpresa  = nCodEmpresa
      AND IdSolicitud = nIdSolicitudOrig;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Distribución de Agentes en Solicitud No. ' || nIdSolicitudDest);
END COPIAR;

END OC_SOLICITUD_AGENTES_DISTRIB;
/

--
-- OC_SOLICITUD_AGENTES_DISTRIB  (Synonym) 
--
--  Dependencies: 
--   OC_SOLICITUD_AGENTES_DISTRIB (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_SOLICITUD_AGENTES_DISTRIB FOR SICAS_OC.OC_SOLICITUD_AGENTES_DISTRIB
/


GRANT EXECUTE ON SICAS_OC.OC_SOLICITUD_AGENTES_DISTRIB TO PUBLIC
/

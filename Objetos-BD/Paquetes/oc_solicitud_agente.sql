--
-- OC_SOLICITUD_AGENTE  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   SOLICITUD_AGENTE (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_SOLICITUD_AGENTE IS

PROCEDURE ELIMINAR(nCodCia NUMBER, nIdSolicitud NUMBER);

FUNCTION AGENTE_PRINCIPAL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN NUMBER;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitudOrig NUMBER, nIdSolicitudDest NUMBER);

END OC_SOLICITUD_AGENTE;
/

--
-- OC_SOLICITUD_AGENTE  (Package Body) 
--
--  Dependencies: 
--   OC_SOLICITUD_AGENTE (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_SOLICITUD_AGENTE IS
PROCEDURE ELIMINAR(nCodCia NUMBER, nIdSolicitud NUMBER) IS
BEGIN
    DELETE SOLICITUD_AGENTE
     WHERE CodCia      = nCodCia 
       AND IdSolicitud = nIdSolicitud;
END ELIMINAR;

FUNCTION AGENTE_PRINCIPAL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN NUMBER IS
nCod_Agente     SOLICITUD_AGENTE.Cod_Agente%TYPE;
BEGIN
   BEGIN
      SELECT Cod_Agente
        INTO nCod_Agente
        FROM SOLICITUD_AGENTE
       WHERE CodCia      = nCodCia 
         AND CodEmpresa  = nCodEmpresa
         AND IdSolicitud = nIdSolicitud
         AND Ind_Principal = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nCod_Agente := 0;
   END;
   RETURN(nCod_Agente);
END AGENTE_PRINCIPAL;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitudOrig NUMBER, nIdSolicitudDest NUMBER) IS
BEGIN
   INSERT INTO SOLICITUD_AGENTE
         (CodCia, CodEmpresa, IdSolicitud, Cod_Agente, Porc_Comision, Ind_Principal, Origen)
   SELECT CodCia, CodEmpresa, nIdSolicitudDest, Cod_Agente, Porc_Comision, Ind_Principal, Origen
     FROM SOLICITUD_AGENTE
    WHERE CodCia      = nCodCia 
      AND CodEmpresa  = nCodEmpresa
      AND IdSolicitud = nIdSolicitudOrig;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Agentes en Solicitud No. ' || nIdSolicitudDest);
END COPIAR;

END OC_SOLICITUD_AGENTE;
/

--
-- OC_SOLICITUD_AGENTE  (Synonym) 
--
--  Dependencies: 
--   OC_SOLICITUD_AGENTE (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_SOLICITUD_AGENTE FOR SICAS_OC.OC_SOLICITUD_AGENTE
/


GRANT EXECUTE ON SICAS_OC.OC_SOLICITUD_AGENTE TO PUBLIC
/

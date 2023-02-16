CREATE OR REPLACE PACKAGE OC_SOLICITUD_DETALLE IS

FUNCTION TIENE_DETALLES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2;

FUNCTION CANTIDAD_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN VARCHAR2;

FUNCTION EXISTE_DETALLE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN VARCHAR2;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitudOrig NUMBER, nIdSolicitudDest NUMBER);

END OC_SOLICITUD_DETALLE;
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_SOLICITUD_DETALLE IS

FUNCTION TIENE_DETALLES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM SOLICITUD_DETALLE
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
END TIENE_DETALLES;

FUNCTION CANTIDAD_ASEGURADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN VARCHAR2 IS
nCantAsegModelo     SOLICITUD_DETALLE.CantAsegModelo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(CantAsegModelo,0)
        INTO nCantAsegModelo
        FROM SOLICITUD_DETALLE
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdSolicitud   = nIdSolicitud
         AND IDetSol       = nIDetSol;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          nCantAsegModelo := 0;
       WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros con el Detalle No. ' || nIDetSol || ' de la Solicitud No. ' || nIdSolicitud);
    END;
    RETURN(nCantAsegModelo);
END CANTIDAD_ASEGURADOS;

FUNCTION EXISTE_DETALLE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitud NUMBER, nIDetSol NUMBER) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM SOLICITUD_DETALLE
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
END EXISTE_DETALLE;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSolicitudOrig NUMBER, nIdSolicitudDest NUMBER) IS
BEGIN
   INSERT INTO SOLICITUD_DETALLE
         (CodCia, CodEmpresa, IdSolicitud, IDetSol, CodSubGrupo, 
          DescSubGrupo, EdadLimite, PrimaAsegurado, CantAsegModelo)
   SELECT CodCia, CodEmpresa, nIdSolicitudDest, IDetSol, CodSubGrupo, 
          DescSubGrupo, EdadLimite, PrimaAsegurado, CantAsegModelo
     FROM SOLICITUD_DETALLE
    WHERE CodCia      = nCodCia 
      AND CodEmpresa  = nCodEmpresa
      AND IdSolicitud = nIdSolicitudOrig;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Detalles/Subgrupos en Solicitud No. ' || nIdSolicitudDest);
END COPIAR;

END OC_SOLICITUD_DETALLE;

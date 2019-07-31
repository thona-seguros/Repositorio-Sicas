--
-- OC_CONFIGURACION_DOMICILIACION  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CONFIGURACION_DOMICILIACION (Table)
--   CONFIGURACION_DOMICILIACION (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONFIGURACION_DOMICILIACION IS
  FUNCTION DESCRIPCION(nCodCia      CONFIGURACION_DOMICILIACION.CodCia%TYPE,
                       nCodEntidad  CONFIGURACION_DOMICILIACION.CodEntidad%TYPE,
                       nCorrelativo CONFIGURACION_DOMICILIACION.Correlativo%TYPE) RETURN VARCHAR2;

  FUNCTION NUMERO_REINTENTOS(nCodCia      CONFIGURACION_DOMICILIACION.CodCia%TYPE,
                             nCodEntidad  CONFIGURACION_DOMICILIACION.CodEntidad%TYPE,
                             nCorrelativo CONFIGURACION_DOMICILIACION.Correlativo%TYPE) RETURN NUMBER;

  FUNCTION DIAS_REINTENTOS(nCodCia      CONFIGURACION_DOMICILIACION.CodCia%TYPE,
                           nCodEntidad  CONFIGURACION_DOMICILIACION.CodEntidad%TYPE,
                           nCorrelativo CONFIGURACION_DOMICILIACION.Correlativo%TYPE) RETURN NUMBER;

  FUNCTION CODIGO_PLANTILLA(nCodCia      CONFIGURACION_DOMICILIACION.CodCia%TYPE,
                            nCodEntidad  CONFIGURACION_DOMICILIACION.CodEntidad%TYPE,
                            nCorrelativo CONFIGURACION_DOMICILIACION.Correlativo%TYPE) RETURN VARCHAR2;

  FUNCTION CORRELATIVO(nCodCia             CONFIGURACION_DOMICILIACION.CodCia%TYPE,
                       nCodEntidad         CONFIGURACION_DOMICILIACION.CodEntidad%TYPE,
                       cTipo_Configuracion CONFIGURACION_DOMICILIACION.Tipo_Configuracion%TYPE) RETURN NUMBER;

  FUNCTION RUTA_ARCHIVOS(nCodCia             CONFIGURACION_DOMICILIACION.CodCia%TYPE,
                         nCodEntidad         CONFIGURACION_DOMICILIACION.CodEntidad%TYPE,
                         cTipo_Configuracion CONFIGURACION_DOMICILIACION.Tipo_Configuracion%TYPE) RETURN VARCHAR2;

  FUNCTION ARCHIVO_ENVIO(nCodCia             CONFIGURACION_DOMICILIACION.CodCia%TYPE,
                         nCodEntidad         CONFIGURACION_DOMICILIACION.CodEntidad%TYPE,
                         cTipo_Configuracion CONFIGURACION_DOMICILIACION.Tipo_Configuracion%TYPE) RETURN VARCHAR2;

  FUNCTION ARCHIVO_RESPUESTA(nCodCia             CONFIGURACION_DOMICILIACION.CodCia%TYPE,
                             nCodEntidad         CONFIGURACION_DOMICILIACION.CodEntidad%TYPE,
                             cTipo_Configuracion CONFIGURACION_DOMICILIACION.Tipo_Configuracion%TYPE) RETURN VARCHAR2;

END OC_CONFIGURACION_DOMICILIACION;
/

--
-- OC_CONFIGURACION_DOMICILIACION  (Package Body) 
--
--  Dependencies: 
--   OC_CONFIGURACION_DOMICILIACION (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CONFIGURACION_DOMICILIACION IS
FUNCTION DESCRIPCION(nCodCia      CONFIGURACION_DOMICILIACION.CodCia%TYPE,
                     nCodEntidad  CONFIGURACION_DOMICILIACION.CodEntidad%TYPE,
                     nCorrelativo CONFIGURACION_DOMICILIACION.Correlativo%TYPE) RETURN VARCHAR2 IS
cDescripcion       CONFIGURACION_DOMICILIACION.Descripcion%TYPE;
BEGIN
   SELECT Descripcion
     INTO cDescripcion
     FROM CONFIGURACION_DOMICILIACION
    WHERE CodCia      = nCodCia
      AND CodEntidad  = nCodEntidad
      AND Correlativo = nCorrelativo;
   RETURN(cDescripcion);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20200,'NO Existe Configuración de Domiciliación No '|| nCorrelativo || 
                              ' en la Entidad Bancaria No. ' || nCodEntidad || ' para Obtener la Descripción');
END DESCRIPCION;

FUNCTION NUMERO_REINTENTOS(nCodCia      CONFIGURACION_DOMICILIACION.CodCia%TYPE,
                           nCodEntidad  CONFIGURACION_DOMICILIACION.CodEntidad%TYPE,
                           nCorrelativo CONFIGURACION_DOMICILIACION.Correlativo%TYPE) RETURN NUMBER IS
nNroReintentos    CONFIGURACION_DOMICILIACION.NroReintentos%TYPE;
BEGIN
   SELECT NVL(NroReintentos,0)
     INTO nNroReintentos
     FROM CONFIGURACION_DOMICILIACION
    WHERE CodCia      = nCodCia
      AND CodEntidad  = nCodEntidad
      AND Correlativo = nCorrelativo;
   RETURN(nNroReintentos);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20200,'NO Existe Configuración de Domiciliación No '|| nCorrelativo || 
                              ' en la Entidad Bancaria No. ' || nCodEntidad || ' para Leer el No. de Reintentos');
END NUMERO_REINTENTOS;

FUNCTION DIAS_REINTENTOS(nCodCia      CONFIGURACION_DOMICILIACION.CodCia%TYPE,
                         nCodEntidad  CONFIGURACION_DOMICILIACION.CodEntidad%TYPE,
                         nCorrelativo CONFIGURACION_DOMICILIACION.Correlativo%TYPE) RETURN NUMBER IS
nDiasReintentos    CONFIGURACION_DOMICILIACION.DiasReintentos%TYPE;
BEGIN
   SELECT NVL(DiasReintentos,0)
     INTO nDiasReintentos
     FROM CONFIGURACION_DOMICILIACION
    WHERE CodCia      = nCodCia
      AND CodEntidad  = nCodEntidad
      AND Correlativo = nCorrelativo;
   RETURN(nDiasReintentos);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20200,'NO Existe Configuración de Domiciliación No '|| nCorrelativo || 
                              ' en la Entidad Bancaria No. ' || nCodEntidad || ' para Determinar los Días de Reintentos');
END DIAS_REINTENTOS;

FUNCTION CODIGO_PLANTILLA(nCodCia      CONFIGURACION_DOMICILIACION.CodCia%TYPE,
                          nCodEntidad  CONFIGURACION_DOMICILIACION.CodEntidad%TYPE,
                          nCorrelativo CONFIGURACION_DOMICILIACION.Correlativo%TYPE) RETURN VARCHAR2 IS
cCodPlantilla       CONFIGURACION_DOMICILIACION.CodPlantilla%TYPE;
BEGIN
   SELECT CodPlantilla
     INTO cCodPlantilla
     FROM CONFIGURACION_DOMICILIACION
    WHERE CodCia      = nCodCia
      AND CodEntidad  = nCodEntidad
      AND Correlativo = nCorrelativo;
   RETURN(cCodPlantilla);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20200,'NO Existe Configuración de Domiciliación No '|| nCorrelativo || 
                              ' en la Entidad Bancaria No. ' || nCodEntidad || ' para Obtener el Código de Plantilla');
END CODIGO_PLANTILLA;

FUNCTION CORRELATIVO(nCodCia              CONFIGURACION_DOMICILIACION.CodCia%TYPE,
                     nCodEntidad          CONFIGURACION_DOMICILIACION.CodEntidad%TYPE,
                     cTipo_Configuracion  CONFIGURACION_DOMICILIACION.Tipo_Configuracion%TYPE) RETURN NUMBER IS
nCorrelativo       CONFIGURACION_DOMICILIACION.Correlativo%TYPE;
BEGIN
   SELECT Correlativo
     INTO nCorrelativo
     FROM CONFIGURACION_DOMICILIACION
    WHERE CodCia             = nCodCia
      AND CodEntidad         = nCodEntidad
      AND Tipo_Configuracion = cTipo_Configuracion;
   RETURN(nCorrelativo);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20200,'NO Existe Configuración de Domiciliación Tipo '|| cTipo_Configuracion || 
                              ' en la Entidad Bancaria No. ' || nCodEntidad  || ' para Obtener el Correlativo');
END CORRELATIVO;

FUNCTION RUTA_ARCHIVOS(nCodCia             CONFIGURACION_DOMICILIACION.CodCia%TYPE,
                       nCodEntidad         CONFIGURACION_DOMICILIACION.CodEntidad%TYPE,
                       cTipo_Configuracion CONFIGURACION_DOMICILIACION.Tipo_Configuracion%TYPE) RETURN VARCHAR2 IS
cUbicacion_Archivo     CONFIGURACION_DOMICILIACION.Ubicacion_Archivo%TYPE;
BEGIN
   SELECT Ubicacion_Archivo
     INTO cUbicacion_Archivo
     FROM CONFIGURACION_DOMICILIACION
    WHERE CodCia              = nCodCia
      AND CodEntidad          = nCodEntidad
      AND Tipo_Configuracion  = cTipo_Configuracion;
   RETURN(cUbicacion_Archivo);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20200,'NO Existe Configuración de Domiciliación Tipo '|| cTipo_Configuracion || 
                              ' en la Entidad Bancaria No. ' || nCodEntidad || ' para Devolver Ruta de Archivo');
END RUTA_ARCHIVOS;

FUNCTION ARCHIVO_ENVIO(nCodCia             CONFIGURACION_DOMICILIACION.CodCia%TYPE,
                       nCodEntidad         CONFIGURACION_DOMICILIACION.CodEntidad%TYPE,
                       cTipo_Configuracion CONFIGURACION_DOMICILIACION.Tipo_Configuracion%TYPE) RETURN VARCHAR2 IS
cNomArchEnvio     CONFIGURACION_DOMICILIACION.NomArchEnvio%TYPE;
BEGIN
   SELECT NomArchEnvio
     INTO cNomArchEnvio
     FROM CONFIGURACION_DOMICILIACION
    WHERE CodCia              = nCodCia
      AND CodEntidad          = nCodEntidad
      AND Tipo_Configuracion  = cTipo_Configuracion;
   RETURN(cNomArchEnvio);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20200,'NO Existe Configuración de Domiciliación Tipo '|| cTipo_Configuracion || 
                              ' en la Entidad Bancaria No. ' || nCodEntidad || ' para leer Archivo de Envío');
END ARCHIVO_ENVIO;

FUNCTION ARCHIVO_RESPUESTA(nCodCia             CONFIGURACION_DOMICILIACION.CodCia%TYPE,
                           nCodEntidad         CONFIGURACION_DOMICILIACION.CodEntidad%TYPE,
                           cTipo_Configuracion CONFIGURACION_DOMICILIACION.Tipo_Configuracion%TYPE) RETURN VARCHAR2 IS
cNomArchRespuesta     CONFIGURACION_DOMICILIACION.NomArchRespuesta%TYPE;
BEGIN
   SELECT NomArchRespuesta
     INTO cNomArchRespuesta
     FROM CONFIGURACION_DOMICILIACION
    WHERE CodCia              = nCodCia
      AND CodEntidad          = nCodEntidad
      AND Tipo_Configuracion  = cTipo_Configuracion;
   RETURN(cNomArchRespuesta);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20200,'NO Existe Configuración de Domiciliación Tipo '|| cTipo_Configuracion || 
                              ' en la Entidad Bancaria No. ' || nCodEntidad || ' para leer Archivo de Respuesta');
END ARCHIVO_RESPUESTA;

END OC_CONFIGURACION_DOMICILIACION;
/

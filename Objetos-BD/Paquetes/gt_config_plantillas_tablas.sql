--
-- GT_CONFIG_PLANTILLAS_TABLAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CONFIG_PLANTILLAS_TABLAS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_CONFIG_PLANTILLAS_TABLAS AS

   FUNCTION ORDEN_PROCESO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlantilla VARCHAR2, cNomTabla VARCHAR2) RETURN NUMBER;

END GT_CONFIG_PLANTILLAS_TABLAS;
/

--
-- GT_CONFIG_PLANTILLAS_TABLAS  (Package Body) 
--
--  Dependencies: 
--   GT_CONFIG_PLANTILLAS_TABLAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_CONFIG_PLANTILLAS_TABLAS AS

FUNCTION ORDEN_PROCESO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlantilla VARCHAR2, cNomTabla VARCHAR2) RETURN NUMBER IS
nOrdenProceso  CONFIG_PLANTILLAS_TABLAS.OrdenProceso%TYPE;
BEGIN
   BEGIN  
      SELECT NVL(OrdenProceso,0)
        INTO nOrdenProceso
        FROM CONFIG_PLANTILLAS_TABLAS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodPlantilla  = cCodPlantilla
         AND NomTabla      = cNomTabla;
   EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
         RAISE_APPLICATION_ERROR(-20220,'NO Existe Tabla ' || cNomTabla ||' en Configuración de Plantilla '||cCodPlantilla);
   END;
   RETURN nOrdenProceso;
END ORDEN_PROCESO;

END GT_CONFIG_PLANTILLAS_TABLAS;
/

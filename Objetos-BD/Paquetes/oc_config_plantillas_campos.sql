--
-- OC_CONFIG_PLANTILLAS_CAMPOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CONFIG_PLANTILLAS_CAMPOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONFIG_PLANTILLAS_CAMPOS IS

FUNCTION TIPO_CAMPO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlantilla VARCHAR2,
                    nOrdenCampo NUMBER,nOrdenProceso NUMBER, cNomCampo VARCHAR2) RETURN VARCHAR2;

FUNCTION CAMPO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlantilla VARCHAR2,
               nOrdenCampo NUMBER) RETURN VARCHAR2;
               
FUNCTION ORDEN_CAMPO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlantilla VARCHAR2,nOrdenProceso NUMBER, cNomCampo VARCHAR2) RETURN NUMBER;           

END OC_CONFIG_PLANTILLAS_CAMPOS;
/

--
-- OC_CONFIG_PLANTILLAS_CAMPOS  (Package Body) 
--
--  Dependencies: 
--   OC_CONFIG_PLANTILLAS_CAMPOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CONFIG_PLANTILLAS_CAMPOS IS

FUNCTION TIPO_CAMPO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlantilla VARCHAR2,
                    nOrdenCampo NUMBER, nOrdenProceso NUMBER, cNomCampo VARCHAR2) RETURN VARCHAR2 IS
cTipoCampo   CONFIG_PLANTILLAS_CAMPOS.TipoCampo%TYPE;
BEGIN
   BEGIN
      SELECT TipoCampo
        INTO cTipoCampo
        FROM CONFIG_PLANTILLAS_CAMPOS
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND CodPlantilla = cCodPlantilla
         AND OrdenCampo   = nOrdenCampo
         AND OrdenProceso = nOrdenProceso
         AND NomCampo     = cNomCampo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20220,'NO Existe Campo ' || cNomCampo || ' OrdenCampo ' || nOrdenCampo ||
                               ' OrdenProceso '||nOrdenProceso||' en Configuración de Plantilla '||cCodPlantilla);
   END;
   RETURN(cTipoCampo);
END TIPO_CAMPO;

FUNCTION CAMPO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlantilla VARCHAR2,
               nOrdenCampo NUMBER) RETURN VARCHAR2 IS
cNomCampo   CONFIG_PLANTILLAS_CAMPOS.NomCampo%TYPE;
BEGIN
   BEGIN
      SELECT NomCampo
        INTO cNomCampo
        FROM CONFIG_PLANTILLAS_CAMPOS
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND CodPlantilla = cCodPlantilla
         AND OrdenCampo   = nOrdenCampo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNomCampo := NULL;
   END;
   RETURN(cNomCampo);
END CAMPO;

FUNCTION ORDEN_CAMPO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlantilla VARCHAR2,nOrdenProceso NUMBER, cNomCampo VARCHAR2) RETURN NUMBER IS
nOrdenCampo CONFIG_PLANTILLAS_CAMPOS.OrdenCampo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(OrdenCampo,0)
        INTO nOrdenCampo
        FROM CONFIG_PLANTILLAS_CAMPOS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodPlantilla  = cCodPlantilla
         AND OrdenProceso  = nOrdenProceso
         AND NomCampo      = cNomCampo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nOrdenCampo := 0;
   END;
   RETURN nOrdenCampo;
END ORDEN_CAMPO;

END OC_CONFIG_PLANTILLAS_CAMPOS;
/

--
-- OC_CONFIG_PLANTILLAS_CAMPOS  (Synonym) 
--
--  Dependencies: 
--   OC_CONFIG_PLANTILLAS_CAMPOS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_CONFIG_PLANTILLAS_CAMPOS FOR SICAS_OC.OC_CONFIG_PLANTILLAS_CAMPOS
/


GRANT EXECUTE ON SICAS_OC.OC_CONFIG_PLANTILLAS_CAMPOS TO PUBLIC
/

--
-- OC_CONFIG_PLANTILLAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   CONFIG_PLANTILLAS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONFIG_PLANTILLAS IS

  FUNCTION DESCRIPCION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlantilla VARCHAR2) RETURN VARCHAR2;
  FUNCTION TIPO_SEPARADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlantilla VARCHAR2) RETURN VARCHAR2;

END OC_CONFIG_PLANTILLAS;
/

--
-- OC_CONFIG_PLANTILLAS  (Package Body) 
--
--  Dependencies: 
--   OC_CONFIG_PLANTILLAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CONFIG_PLANTILLAS IS

FUNCTION DESCRIPCION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlantilla VARCHAR2) RETURN VARCHAR2 IS
cDescPlantilla   CONFIG_PLANTILLAS.DescPlantilla%TYPE;
BEGIN
   BEGIN
      SELECT DescPlantilla
        INTO cDescPlantilla
        FROM CONFIG_PLANTILLAS
       WHERE CodCia       = nCodCia
                   AND CodEmpresa   = nCodEmpresa
                        AND CodPlantilla = cCodPlantilla;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescPlantilla := 'NO EXISTE';
   END;
   RETURN(cDescPlantilla);
END DESCRIPCION;

FUNCTION TIPO_SEPARADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlantilla VARCHAR2) RETURN VARCHAR2 IS
cTipoSeparador   CONFIG_PLANTILLAS.TipoSeparador%TYPE;
BEGIN
   BEGIN
      SELECT TipoSeparador
        INTO cTipoSeparador
        FROM CONFIG_PLANTILLAS
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND CodPlantilla = cCodPlantilla;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoSeparador := 'NO EXISTE';
   END;
   RETURN(cTipoSeparador);
END TIPO_SEPARADOR;

END OC_CONFIG_PLANTILLAS;
/

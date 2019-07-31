--
-- OC_SUBESPECIALIDAD_MEDICA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   SUBESPECIALIDAD_MEDICA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_SUBESPECIALIDAD_MEDICA IS

  FUNCTION DESCRIPCION_SUBESPECIALIDAD(nCodCia NUMBER, cCodEspecialidad VARCHAR2, cCodSubEspecialidad VARCHAR2) RETURN VARCHAR2;

END OC_SUBESPECIALIDAD_MEDICA;
/

--
-- OC_SUBESPECIALIDAD_MEDICA  (Package Body) 
--
--  Dependencies: 
--   OC_SUBESPECIALIDAD_MEDICA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_SUBESPECIALIDAD_MEDICA IS

FUNCTION DESCRIPCION_SUBESPECIALIDAD(nCodCia NUMBER, cCodEspecialidad VARCHAR2, cCodSubEspecialidad VARCHAR2) RETURN VARCHAR2 IS
cDescSubEspecialidad       SUBESPECIALIDAD_MEDICA.DescSubEspecialidad%TYPE;
BEGIN
   BEGIN
      SELECT DescSubEspecialidad
        INTO cDescSubEspecialidad
        FROM SUBESPECIALIDAD_MEDICA
       WHERE CodCia             = nCodCia
         AND CodEspecialidad    = cCodEspecialidad
         AND CodSubEspecialidad = cCodSubEspecialidad;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescSubEspecialidad := 'Sub-Especialidad Médica con Código ' || cCodEspecialidad || ' NO Existe';
   END;
   RETURN(cDescSubEspecialidad);
END DESCRIPCION_SUBESPECIALIDAD;

END OC_SUBESPECIALIDAD_MEDICA;
/

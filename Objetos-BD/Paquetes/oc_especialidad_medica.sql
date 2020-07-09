--
-- OC_ESPECIALIDAD_MEDICA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   ESPECIALIDAD_MEDICA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_ESPECIALIDAD_MEDICA IS

  FUNCTION DESCRIPCION_ESPECIALIDAD(nCodCia NUMBER, cCodEspecialidad VARCHAR2) RETURN VARCHAR2;
  FUNCTION TIPO_ESPECIALIDAD(nCodCia NUMBER, cCodEspecialidad VARCHAR2) RETURN VARCHAR2;

END OC_ESPECIALIDAD_MEDICA;
/

--
-- OC_ESPECIALIDAD_MEDICA  (Package Body) 
--
--  Dependencies: 
--   OC_ESPECIALIDAD_MEDICA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_ESPECIALIDAD_MEDICA IS

FUNCTION DESCRIPCION_ESPECIALIDAD(nCodCia NUMBER, cCodEspecialidad VARCHAR2) RETURN VARCHAR2 IS
cDescEspecialidad       ESPECIALIDAD_MEDICA.DescEspecialidad%TYPE;
BEGIN
   BEGIN
      SELECT DescEspecialidad
        INTO cDescEspecialidad
        FROM ESPECIALIDAD_MEDICA
       WHERE CodCia           = nCodCia
         AND CodEspecialidad  = cCodEspecialidad;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescEspecialidad := 'Especialidad Médica con Código ' || cCodEspecialidad || ' NO Existe';
   END;
   RETURN(cDescEspecialidad);
END DESCRIPCION_ESPECIALIDAD;

FUNCTION TIPO_ESPECIALIDAD(nCodCia NUMBER, cCodEspecialidad VARCHAR2) RETURN VARCHAR2 IS
cTipoEspecialidad       ESPECIALIDAD_MEDICA.TipoEspecialidad%TYPE;
BEGIN
   BEGIN
      SELECT TipoEspecialidad
        INTO cTipoEspecialidad
        FROM ESPECIALIDAD_MEDICA
       WHERE CodCia           = nCodCia
         AND CodEspecialidad  = cCodEspecialidad;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoEspecialidad := 'Especialidad Médica con Código ' || cCodEspecialidad || ' NO Existe para Obtener su Tipo';
   END;
   RETURN(cTipoEspecialidad);
END TIPO_ESPECIALIDAD;

END OC_ESPECIALIDAD_MEDICA;
/

--
-- OC_ESPECIALIDAD_MEDICA  (Synonym) 
--
--  Dependencies: 
--   OC_ESPECIALIDAD_MEDICA (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_ESPECIALIDAD_MEDICA FOR SICAS_OC.OC_ESPECIALIDAD_MEDICA
/


GRANT EXECUTE ON SICAS_OC.OC_ESPECIALIDAD_MEDICA TO PUBLIC
/

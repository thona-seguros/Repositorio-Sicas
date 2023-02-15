CREATE OR REPLACE PACKAGE OC_ESPECIALIDAD_MEDICA IS

  FUNCTION DESCRIPCION_ESPECIALIDAD(nCodCia NUMBER, cCodEspecialidad VARCHAR2) RETURN VARCHAR2;
  FUNCTION TIPO_ESPECIALIDAD(nCodCia NUMBER, cCodEspecialidad VARCHAR2) RETURN VARCHAR2;

END OC_ESPECIALIDAD_MEDICA;
/

CREATE OR REPLACE PACKAGE BODY OC_ESPECIALIDAD_MEDICA IS

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

--
-- OC_EMPLEADOS_FUNCIONARIOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   EMPLEADOS_FUNCIONARIOS (Table)
--   OC_CORREOS_ELECTRONICOS_PNJ (Package)
--   CORREOS_ELECTRONICOS_PNJ (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_EMPLEADOS_FUNCIONARIOS IS

  PROCEDURE ACTIVAR(nCodCia NUMBER, cCodEmpleadoFunc VARCHAR2);
  PROCEDURE BAJA_EMPLEADO(nCodCia NUMBER, cCodEmpleadoFunc VARCHAR2, dFechaBaja DATE, cCodMotivoBaja VARCHAR2);
  FUNCTION NOMBRE_EMPLEADO(nCodCia NUMBER, cCodEmpleadoFunc VARCHAR2) RETURN VARCHAR2;
  FUNCTION EMAIL_EMPLEADO(nCodCia NUMBER, cCodEmpleadoFunc VARCHAR2) RETURN VARCHAR2;
  FUNCTION ES_EMPLEADO_FUNCIONARIO(nCodCia NUMBER, cTipoDocIdentEmp VARCHAR2, cNumDocIdentEmp VARCHAR2) RETURN VARCHAR2;

END OC_EMPLEADOS_FUNCIONARIOS;
/

--
-- OC_EMPLEADOS_FUNCIONARIOS  (Package Body) 
--
--  Dependencies: 
--   OC_EMPLEADOS_FUNCIONARIOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_EMPLEADOS_FUNCIONARIOS IS

PROCEDURE ACTIVAR(nCodCia NUMBER, cCodEmpleadoFunc VARCHAR2) IS
BEGIN
   UPDATE EMPLEADOS_FUNCIONARIOS
      SET StsEmpleadoFunc  = 'ACTIVO',
          FecSts           = TRUNC(SYSDATE),
          FechaBaja        = NULL,
          CodMotivoBaja    = NULL
    WHERE CodCia           = nCodCia
      AND CodEmpleadoFunc  = cCodEmpleadoFunc;
END ACTIVAR;

PROCEDURE BAJA_EMPLEADO(nCodCia NUMBER, cCodEmpleadoFunc VARCHAR2, dFechaBaja DATE, cCodMotivoBaja VARCHAR2) IS
BEGIN
   UPDATE EMPLEADOS_FUNCIONARIOS
      SET StsEmpleadoFunc  = 'BAJA',
          FecSts           = TRUNC(SYSDATE),
          FechaBaja        = dFechaBaja,
          CodMotivoBaja    = cCodMotivoBaja
    WHERE CodCia           = nCodCia
      AND CodEmpleadoFunc  = cCodEmpleadoFunc;
END BAJA_EMPLEADO;

FUNCTION NOMBRE_EMPLEADO(nCodCia NUMBER, cCodEmpleadoFunc VARCHAR2) RETURN VARCHAR2 IS
cNombre       VARCHAR2(500);
BEGIN
   BEGIN
      SELECT TRIM(Nombre) || ' ' || TRIM(Apellido_Paterno) || ' ' || TRIM(Apellido_Materno) || ' ' || TRIM(ApeCasada)
        INTO cNombre
        FROM PERSONA_NATURAL_JURIDICA
       WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
             (SELECT TipoDocIdentEmp, NumDocIdentEmp
                FROM EMPLEADOS_FUNCIONARIOS
               WHERE CodCia            = nCodCia
                 AND CodEmpleadoFunc   = cCodEmpleadoFunc);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNombre := 'Empleado o Funcionario Código ' || cCodEmpleadoFunc || ' NO Existe';
   END;
   RETURN(cNombre);
END NOMBRE_EMPLEADO;

FUNCTION EMAIL_EMPLEADO(nCodCia NUMBER, cCodEmpleadoFunc VARCHAR2) RETURN VARCHAR2 IS
cTipoDocIdentEmp        EMPLEADOS_FUNCIONARIOS.TipoDocIdentEmp%TYPE;
cNumDocIdentEmp         EMPLEADOS_FUNCIONARIOS.NumDocIdentEmp%TYPE;
cEmailEmpleado          CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
BEGIN
   BEGIN
      SELECT TipoDocIdentEmp, NumDocIdentEmp
        INTO cTipoDocIdentEmp, cNumDocIdentEmp
        FROM EMPLEADOS_FUNCIONARIOS
       WHERE CodCia            = nCodCia
         AND CodEmpleadoFunc   = cCodEmpleadoFunc;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'Empleado o Funcionario Código ' || cCodEmpleadoFunc || ' NO Existe');
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Configurados Varios Empleados o Funcionarios con el Código ' || cCodEmpleadoFunc);
   END;
   
   cEmailEmpleado := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(cTipoDocIdentEmp, cNumDocIdentEmp);

   RETURN(cEmailEmpleado);
END EMAIL_EMPLEADO;

FUNCTION ES_EMPLEADO_FUNCIONARIO(nCodCia NUMBER, cTipoDocIdentEmp VARCHAR2, cNumDocIdentEmp VARCHAR2) RETURN VARCHAR2 IS
cEsEmpleado     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cEsEmpleado
        FROM EMPLEADOS_FUNCIONARIOS
       WHERE CodCia            = nCodCia
         AND TipoDocIdentEmp   = cTipoDocIdentEmp
         AND NumDocIdentEmp    = cNumDocIdentEmp
         AND StsEmpleadoFunc   = 'ACTIVO';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cEsEmpleado := 'N';
      WHEN TOO_MANY_ROWS THEN
         cEsEmpleado := 'S';
   END;
   
   RETURN(cEsEmpleado);
END ES_EMPLEADO_FUNCIONARIO;

END OC_EMPLEADOS_FUNCIONARIOS;
/

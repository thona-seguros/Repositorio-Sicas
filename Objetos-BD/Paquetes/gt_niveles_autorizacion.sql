--
-- GT_NIVELES_AUTORIZACION  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   USUARIOS (Table)
--   NIVELES_AUTORIZACION (Table)
--   NIVELES_AUTORIZACION_GRUPO (Table)
--   OC_USUARIOS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_NIVELES_AUTORIZACION AS
    FUNCTION USUARIO_BD(nCodCia NUMBER, nIdEmpleado NUMBER) RETURN VARCHAR2;
    FUNCTION AUTORIZA_PROCESOS(nCodCia NUMBER, nIdEmpleado NUMBER) RETURN VARCHAR2;
    FUNCTION EMPLEADO_SUPERIOR(nCodCia NUMBER, nIdEmpleado NUMBER) RETURN NUMBER;
    FUNCTION ESTATUS_EMPLEADO(nCodCia NUMBER, nIdEmpleado NUMBER) RETURN VARCHAR2;
    FUNCTION NUMERO_EMPLEADO(nCodCia NUMBER,cCodUsuarioBD VARCHAR2) RETURN NUMBER;
    
    PROCEDURE CONFIGURAR_NIVEL(nCodCia NUMBER, nIdEmpleado NUMBER);
    PROCEDURE ACTIVAR_NIVEL(nCodCia NUMBER, nIdEmpleado NUMBER);
    PROCEDURE SUSPENDER_NIVEL(nCodCia NUMBER, nIdEmpleado NUMBER);
    PROCEDURE FUERA_OFICINA_NIVEL(nCodCia NUMBER, nIdEmpleado NUMBER);

    FUNCTION SUPERIOR_QUE_AUTORIZA(nCodCia NUMBER, nIdEmpleado NUMBER, nMontoAutorizacion NUMBER) RETURN NUMBER;

END GT_NIVELES_AUTORIZACION;
/

--
-- GT_NIVELES_AUTORIZACION  (Package Body) 
--
--  Dependencies: 
--   GT_NIVELES_AUTORIZACION (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_NIVELES_AUTORIZACION AS
FUNCTION USUARIO_BD(nCodCia NUMBER, nIdEmpleado NUMBER) RETURN VARCHAR2 IS
cCodUsuarioBD      NIVELES_AUTORIZACION.CodUsuarioBD%TYPE;
BEGIN
   BEGIN
      SELECT CodUsuarioBD 
        INTO cCodUsuarioBD
        FROM NIVELES_AUTORIZACION
       WHERE CodCia     = nCodCia
         AND IdEmpleado = nIdEmpleado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodUsuarioBD := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error en Niveles de Autorización USUARIO BD del Empleado ' || nIdEmpleado ||' - Existe en Varios Registros');
   END;
   RETURN(cCodUsuarioBD);
END USUARIO_BD;
    
FUNCTION AUTORIZA_PROCESOS(nCodCia NUMBER, nIdEmpleado NUMBER) RETURN VARCHAR2 IS
cIndAutoriza      NIVELES_AUTORIZACION.IndAutoriza%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndAutoriza,'N')
        INTO cIndAutoriza
        FROM NIVELES_AUTORIZACION
       WHERE CodCia     = nCodCia
         AND IdEmpleado = nIdEmpleado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndAutoriza := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error en Niveles de Autorización AUTORIZA PROCESOS para Empleado ' || nIdEmpleado ||' - Existe en Varios Registros');
   END;
   RETURN(cIndAutoriza);
END AUTORIZA_PROCESOS;

FUNCTION EMPLEADO_SUPERIOR(nCodCia NUMBER, nIdEmpleado NUMBER) RETURN NUMBER IS
nIdEmpleadoSuperior      NIVELES_AUTORIZACION.IdEmpleadoSuperior%TYPE;
BEGIN
   BEGIN
      SELECT MAX(N.IdEmpleadoSuperior)
        INTO nIdEmpleadoSuperior
        FROM NIVELES_AUTORIZACION N
       WHERE N.CodCia             = nCodCia
         AND N.IdEmpleadoSuperior IS NOT NULL
         AND EXISTS (SELECT 'S'
                       FROM NIVELES_AUTORIZACION
                      WHERE CodCIa      = N.CodCia
                        AND IdEmpleado  = N.IdEmpleadoSuperior
                        AND StsEmpleado = 'ACTIVO')
       START WITH IdEmpleado              = nIdEmpleado
      CONNECT BY PRIOR IdEmpleadoSuperior = IdEmpleado;
         
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nIdEmpleadoSuperior := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error en Niveles de Autorización EMPLEADO SUPERIOR para Empleado ' || nIdEmpleado ||' - Existe en Varios Registros');
   END;
   RETURN(nIdEmpleadoSuperior);
END EMPLEADO_SUPERIOR;

FUNCTION ESTATUS_EMPLEADO(nCodCia NUMBER, nIdEmpleado NUMBER) RETURN VARCHAR2 IS
   cStsEmpleado NIVELES_AUTORIZACION.StsEmpleado%TYPE;
BEGIN
   SELECT NVL(StsEmpleado,'SUSPENDIDO')
     INTO cStsEmpleado
     FROM NIVELES_AUTORIZACION
    WHERE CodCia     = nCodCia 
      AND IdEmpleado = nIdEmpleado;
      
   RETURN cStsEmpleado;
END ESTATUS_EMPLEADO;

FUNCTION NUMERO_EMPLEADO(nCodCia NUMBER,cCodUsuarioBD VARCHAR2) RETURN NUMBER IS
nIdEmpleado      NIVELES_AUTORIZACION.IdEmpleado%TYPE;
BEGIN
    BEGIN
      SELECT IdEmpleado
        INTO nIdEmpleado
        FROM NIVELES_AUTORIZACION
       WHERE CodCia       = nCodCia
         AND CodUsuarioBD = cCodUsuarioBD;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nIdEmpleado := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error en Niveles de Autorización OBTENER  Empleado ' || nIdEmpleado ||' - Existe en Varios Registros');
   END;
   RETURN(nIdEmpleado);
END NUMERO_EMPLEADO;

PROCEDURE CONFIGURAR_NIVEL(nCodCia NUMBER, nIdEmpleado NUMBER) IS
BEGIN
   UPDATE NIVELES_AUTORIZACION
      SET StsEmpleado      = 'CONFIG',
          FecStsEmpleado   = TRUNC(SYSDATE)
    WHERE CodCia       = nCodCia
      AND IdEmpleado   = nIdEmpleado;
END CONFIGURAR_NIVEL;

PROCEDURE ACTIVAR_NIVEL(nCodCia NUMBER, nIdEmpleado NUMBER) IS
BEGIN
   UPDATE NIVELES_AUTORIZACION
      SET StsEmpleado      = 'ACTIVO',
          FecStsEmpleado   = TRUNC(SYSDATE)
    WHERE CodCia       = nCodCia
      AND IdEmpleado   = nIdEmpleado;
END ACTIVAR_NIVEL;

PROCEDURE SUSPENDER_NIVEL(nCodCia NUMBER, nIdEmpleado NUMBER) IS
BEGIN
   UPDATE NIVELES_AUTORIZACION
      SET StsEmpleado      = 'SUSPEN',
          FecStsEmpleado   = TRUNC(SYSDATE)
    WHERE CodCia       = nCodCia
      AND IdEmpleado   = nIdEmpleado;
END SUSPENDER_NIVEL;

PROCEDURE FUERA_OFICINA_NIVEL(nCodCia NUMBER, nIdEmpleado NUMBER) IS
BEGIN
   UPDATE NIVELES_AUTORIZACION
      SET StsEmpleado      = 'FUERAO',
          FecStsEmpleado   = TRUNC(SYSDATE)
    WHERE CodCia       = nCodCia
      AND IdEmpleado   = nIdEmpleado;
END FUERA_OFICINA_NIVEL;

FUNCTION SUPERIOR_QUE_AUTORIZA(nCodCia NUMBER, nIdEmpleado NUMBER, nMontoAutorizacion NUMBER) RETURN NUMBER IS
cCodUsuarioBD         NIVELES_AUTORIZACION.CodUsuarioBD%TYPE;
nIdEmpleadoSuperior   NIVELES_AUTORIZACION.IdEmpleadoSuperior%TYPE;
cCodGrupo             USUARIOS.CodGrupo%TYPE;
cAutoriza             VARCHAR2(1);
CURSOR NIVEL_Q IS
   SELECT N.IdEmpleadoSuperior
     FROM NIVELES_AUTORIZACION N
    WHERE N.CodCia             = nCodCia
      AND N.IdEmpleadoSuperior IS NOT NULL
      AND EXISTS (SELECT 'S'
                    FROM NIVELES_AUTORIZACION
                   WHERE CodCIa      = N.CodCia
                     AND IdEmpleado  = N.IdEmpleadoSuperior
                     AND StsEmpleado = 'ACTIVO')
START WITH IdEmpleado        = nIdEmpleado
  CONNECT BY PRIOR IdEmpleadoSuperior = IdEmpleado;
CURSOR GRUPO_Q IS
   SELECT 'S'
     FROM NIVELES_AUTORIZACION_GRUPO
    WHERE CodCia     = nCodCia
      AND IdEmpleado = nIdEmpleadoSuperior
      AND CodGrupo   = cCodGrupo;
BEGIN
   cCodUsuarioBD := GT_NIVELES_AUTORIZACION.USUARIO_BD(nCodCia, nIdEmpleado);
   cCodGrupo     := OC_USUARIOS.GRUPO_USUARIO(nCodCia, cCodUsuarioBD);
   FOR W IN NIVEL_Q LOOP
      nIdEmpleadoSuperior := W.IdEmpleadoSuperior;
      BEGIN
         SELECT 'S'
           INTO cAutoriza
           FROM NIVELES_AUTORIZACION_GRUPO
          WHERE CodCia                 = nCodCia
            AND IdEmpleado             = nIdEmpleadoSuperior
            AND CodGrupo               = cCodGrupo
            --AND MontoMinimoAutorizado <= nMontoAutorizacion
            AND MontoMaximoAutorizado >= nMontoAutorizacion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cAutoriza := 'N';
         WHEN TOO_MANY_ROWS THEN
            cAutoriza := 'S';
      END;
      IF cAutoriza = 'S' THEN
         RETURN(nIdEmpleadoSuperior);
      END IF;
   END LOOP;
   IF cAutoriza = 'N' THEN
      RAISE_APPLICATION_ERROR(-20225,'No existe Nivel de Autorización del Empleado ' || nIdEmpleado ||' para el Monto ' || nMontoAutorizacion);
   END IF;
END SUPERIOR_QUE_AUTORIZA;

END GT_NIVELES_AUTORIZACION;
/

--
-- GT_NIVELES_AUTORIZACION  (Synonym) 
--
--  Dependencies: 
--   GT_NIVELES_AUTORIZACION (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_NIVELES_AUTORIZACION FOR SICAS_OC.GT_NIVELES_AUTORIZACION
/


GRANT EXECUTE ON SICAS_OC.GT_NIVELES_AUTORIZACION TO PUBLIC
/

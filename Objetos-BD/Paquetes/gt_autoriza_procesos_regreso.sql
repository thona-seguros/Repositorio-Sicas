--
-- GT_AUTORIZA_PROCESOS_REGRESO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   AUTORIZA_PROCESOS (Table)
--   AUTORIZA_PROCESOS_LOG (Table)
--   AUTORIZA_PROCESOS_REGRESO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_AUTORIZA_PROCESOS_REGRESO AS
   FUNCTION NUMERO_REGRESO(nCodCia NUMBER, nIdAutorizacion NUMBER) RETURN NUMBER;
   PROCEDURE CREAR(nCodCia IN NUMBER, nIdAutorizacion IN NUMBER, nIdEmpleadoRegresa IN NUMBER, dFechaRegresa IN DATE,
                   cHoraRegresa IN VARCHAR2, nIdEmpleadoRegresado IN NUMBER, cObservaciones IN VARCHAR2);
   FUNCTION EMPLEADO_A_REGRESAR(nCodCia NUMBER, nIdAutorizacion NUMBER,nIdEmpeadoRegresa NUMBER) RETURN NUMBER;
   FUNCTION EMPLEADO_REGRESADO(nCodCia NUMBER, nIdAutorizacion NUMBER,nIdRegreso NUMBER) RETURN NUMBER;
   FUNCTION EMPLEADO_REGRESA(nCodCia NUMBER, nIdAutorizacion NUMBER,nIdRegreso NUMBER) RETURN NUMBER;
   FUNCTION EMPLEADO_ULTIMO_REGRESA(nCodCia NUMBER, nIdAutorizacion NUMBER) RETURN NUMBER;
   FUNCTION EMPLEADO_ULTIMO_REGRESADO(nCodCia NUMBER, nIdAutorizacion NUMBER) RETURN NUMBER;
   FUNCTION EXISTE_REGRESO(nCodCia NUMBER, nIdAutorizacion NUMBER) RETURN VARCHAR2;
END GT_AUTORIZA_PROCESOS_REGRESO;
/

--
-- GT_AUTORIZA_PROCESOS_REGRESO  (Package Body) 
--
--  Dependencies: 
--   GT_AUTORIZA_PROCESOS_REGRESO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_AUTORIZA_PROCESOS_REGRESO AS
   FUNCTION NUMERO_REGRESO(nCodCia NUMBER, nIdAutorizacion NUMBER) RETURN NUMBER IS
      nIdRegreso AUTORIZA_PROCESOS_REGRESO.IdRegreso%TYPE;
   BEGIN
      SELECT NVL(MAX(IdRegreso),0) + 1
          INTO nIdRegreso
          FROM AUTORIZA_PROCESOS_REGRESO
         WHERE CodCia         = nCodCia
           AND IdAutorizacion = nIdAutorizacion;
        RETURN nIdRegreso;
   END NUMERO_REGRESO;
   --
   PROCEDURE CREAR(nCodCia IN NUMBER, nIdAutorizacion IN NUMBER, nIdEmpleadoRegresa IN NUMBER, dFechaRegresa IN DATE,
                    cHoraRegresa IN VARCHAR2, nIdEmpleadoRegresado IN NUMBER, cObservaciones IN VARCHAR2) IS
      nIdRegreso AUTORIZA_PROCESOS_REGRESO.IdRegreso%TYPE;
   BEGIN
      nIdRegreso := GT_AUTORIZA_PROCESOS_REGRESO.NUMERO_REGRESO(nCodCia, nIdAutorizacion);
      INSERT INTO AUTORIZA_PROCESOS_REGRESO (CodCia,     IdAutorizacion,     IdRegreso,  IdEmpleadoRegresa, FechaRegresa, 
                                             HoraRegresa,IdEmpleadoRegresado, StsRegreso, FechaStatus,      Observaciones)
                                 VALUES (nCodCia,     nIdAutorizacion,     nIdRegreso, nIdEmpleadoRegresa,dFechaRegresa,
                                         cHoraRegresa,nIdEmpleadoRegresado,'REGRESADO',TRUNC(SYSDATE),    cObservaciones);
   END CREAR;
    --
   FUNCTION EMPLEADO_A_REGRESAR(nCodCia NUMBER, nIdAutorizacion NUMBER,nIdEmpeadoRegresa NUMBER) RETURN NUMBER IS
      nIdEmpleadoRegresado AUTORIZA_PROCESOS_REGRESO.IdEmpleadoRegresado%TYPE;
   BEGIN
      BEGIN
         SELECT AL.IdEmpleadoRevisa
           INTO nIdEmpleadoRegresado
           FROM AUTORIZA_PROCESOS_LOG AL
          WHERE AL.CodCia              = nCodCia 
            AND AL.IdAutorizacion      = nIdAutorizacion
            AND AL.IdEmpleadoSuperior  = nIdEmpeadoRegresa;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               SELECT IdEmpleadoProcesa
                 INTO nIdEmpleadoRegresado
                 FROM AUTORIZA_PROCESOS
                WHERE CodCia              = nCodCia 
                  AND IdAutorizacion      = nIdAutorizacion;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20225,'Error en el Regreso de la Autorización, NO es Posible Determinar el Empleado a Quien se Debe Regresar');
            END;
      END;
      RETURN nIdEmpleadoRegresado;     
   END EMPLEADO_A_REGRESAR;
   --
   FUNCTION EMPLEADO_REGRESADO(nCodCia NUMBER, nIdAutorizacion NUMBER,nIdRegreso NUMBER) RETURN NUMBER IS
      nIdEmpleadoRegresado AUTORIZA_PROCESOS_REGRESO.IdEmpleadoRegresado%TYPE;
   BEGIN
      SELECT NVL(IdEmpleadoRegresado,0)
        INTO nIdEmpleadoRegresado
        FROM AUTORIZA_PROCESOS_REGRESO
       WHERE CodCia              = nCodCia 
         AND IdAutorizacion      = nIdAutorizacion
         AND IdRegreso           = nIdRegreso;
      RETURN nIdEmpleadoRegresado;
   END EMPLEADO_REGRESADO;
   --
   FUNCTION EMPLEADO_REGRESA(nCodCia NUMBER, nIdAutorizacion NUMBER,nIdRegreso NUMBER) RETURN NUMBER IS
      nIdEmpleadoRegresa AUTORIZA_PROCESOS_REGRESO.IdEmpleadoRegresa%TYPE;
   BEGIN
      SELECT NVL(IdEmpleadoRegresa,0)
        INTO nIdEmpleadoRegresa
        FROM AUTORIZA_PROCESOS_REGRESO
       WHERE CodCia              = nCodCia 
         AND IdAutorizacion      = nIdAutorizacion
         AND IdRegreso           = nIdRegreso;
      RETURN nIdEmpleadoRegresa;
   END EMPLEADO_REGRESA;
   --
   FUNCTION EMPLEADO_ULTIMO_REGRESA(nCodCia NUMBER, nIdAutorizacion NUMBER) RETURN NUMBER IS
      nIdEmpleadoRegresa AUTORIZA_PROCESOS_REGRESO.IdEmpleadoRegresa%TYPE;
   BEGIN
      BEGIN
         SELECT APR.IdEmpleadoRegresa
           INTO nIdEmpleadoRegresa
           FROM AUTORIZA_PROCESOS_REGRESO APR,AUTORIZA_PROCESOS AP
          WHERE AP.CodCia          = nCodCia
            AND APR.IdAutorizacion = nIdAutorizacion
            AND APR.IdAutorizacion = AP.IdAutorizacion
            AND APR.IdRegreso      = (SELECT NVL(MAX(IdRegreso),1)
                                        FROM AUTORIZA_PROCESOS_REGRESO APR1
                                       WHERE APR1.CodCia         = nCodCia
                                         AND APR1.IdAutorizacion = AP.IdAutorizacion); 
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            SELECT IdEmpleadoRegresa
              INTO nIdEmpleadoRegresa
              FROM AUTORIZA_PROCESOS
             WHERE CodCia         = nCodCia
               AND IdAutorizacion = nIdAutorizacion;
      END;                    
      RETURN nIdEmpleadoRegresa;
   END EMPLEADO_ULTIMO_REGRESA;
   --
   FUNCTION EMPLEADO_ULTIMO_REGRESADO(nCodCia NUMBER, nIdAutorizacion NUMBER) RETURN NUMBER IS
      nIdEmpleadoRegresado AUTORIZA_PROCESOS_REGRESO.IdEmpleadoRegresado%TYPE;
   BEGIN
      BEGIN
         SELECT APR.IdEmpleadoRegresado
           INTO nIdEmpleadoRegresado
           FROM AUTORIZA_PROCESOS_REGRESO APR,AUTORIZA_PROCESOS AP
          WHERE AP.CodCia          = nCodCia
            AND APR.IdAutorizacion = nIdAutorizacion
            AND APR.IdAutorizacion = AP.IdAutorizacion
            AND APR.IdRegreso      = (SELECT NVL(MAX(IdRegreso),1)
                                        FROM AUTORIZA_PROCESOS_REGRESO APR1
                                       WHERE APR1.CodCia         = nCodCia
                                         AND APR1.IdAutorizacion = AP.IdAutorizacion); 
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            SELECT IdEmpleadoProcesa
              INTO nIdEmpleadoRegresado
              FROM AUTORIZA_PROCESOS
             WHERE CodCia         = nCodCia
               AND IdAutorizacion = nIdAutorizacion;
      END;      
      RETURN nIdEmpleadoRegresado;
   END EMPLEADO_ULTIMO_REGRESADO;
   --
   FUNCTION EXISTE_REGRESO(nCodCia NUMBER, nIdAutorizacion NUMBER) RETURN VARCHAR2 IS
      cExiste  VARCHAR2(1);
   BEGIN
      BEGIN
         SELECT 'S'
           INTO cExiste
           FROM AUTORIZA_PROCESOS_REGRESO
          WHERE CodCia         = nCodCia
            AND IdAutorizacion = nIdAutorizacion;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cExiste := 'N';
         WHEN TOO_MANY_ROWS THEN
            cExiste := 'S';
      END;
      RETURN cExiste;
   END EXISTE_REGRESO;
   
END GT_AUTORIZA_PROCESOS_REGRESO;
/

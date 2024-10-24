--
-- OC_USUARIO_CONFIG  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   USUARIO_CONFG (Table)
--   USUARIO_HORARIO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_USUARIO_CONFIG 
  IS

   FUNCTION CONEXION_USUARIO ( PIDCODIGO NUMBER, PCODIGO VARCHAR2) RETURN  VARCHAR2;
   FUNCTION VERIFICA_USUARIO ( PIDCODIGO NUMBER, PCODIGO VARCHAR2, PCLAVE VARCHAR2) RETURN  VARCHAR2;
   
END; -- Package spec
/

--
-- OC_USUARIO_CONFIG  (Package Body) 
--
--  Dependencies: 
--   OC_USUARIO_CONFIG (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_USUARIO_CONFIG 
IS

   FUNCTION VERIFICA_USUARIO ( PIDCODIGO NUMBER, PCODIGO VARCHAR2, PCLAVE VARCHAR2) RETURN  VARCHAR2 IS
      CPASSWORD     USUARIO_CONFG.password %TYPE;
      CSUPERVISOR   USUARIO_CONFG.supervisor %TYPE;
   BEGIN
      BEGIN
         SELECT PASSWORD, SUPERVISOR
           INTO CPASSWORD, CSUPERVISOR
           FROM USUARIO_CONFG A
          WHERE IDCODIGO = PIDCODIGO
            AND CODIGO = PCODIGO;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
           RAISE_APPLICATION_ERROR (-20100,'El usuario no corresponde al codigo, Verifique ');
      END;
      
      IF CPASSWORD != PCLAVE THEN
        RAISE_APPLICATION_ERROR (-20100,'El usuario SI corresponde al codigo pero no corresponde a la palabra CLAVE, Verifique ');
      END IF;
      
      IF OC_USUARIO_CONFIG.CONEXION_USUARIO(PIDCODIGO,PCODIGO) = 'OK' THEN
           RETURN ('OK');
      END IF;

   END VERIFICA_USUARIO;


   FUNCTION CONEXION_USUARIO ( PIDCODIGO NUMBER, PCODIGO VARCHAR2) RETURN  VARCHAR2 IS
     CSUPERVISOR   USUARIO_CONFG.supervisor %TYPE;
     NEXISTE       NUMBER;
   BEGIN
      BEGIN
         SELECT SUPERVISOR
           INTO CSUPERVISOR
           FROM USUARIO_CONFG A
          WHERE IDCODIGO = PIDCODIGO
            AND CODIGO = PCODIGO;
      END;

      IF CSUPERVISOR = 'N' THEN
         BEGIN
            SELECT 1
              INTO NEXISTE
              FROM USUARIO_HORARIO A
             WHERE IDCODIGO = PIDCODIGO
               AND UPPER(TO_CHAR(SYSDATE,'DAY')) = DIA
               AND TO_CHAR(SYSDATE,'HH:MM') BETWEEN TO_CHAR(a.hora_ingreso,'HH:MM') AND TO_CHAR(a.hora_EGRESO,'HH:MM');
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR (-20100,'El usuario ya no corresponde en este horario, Verifique ');
         END;
      END IF;
      
      RETURN ('OK');
   END CONEXION_USUARIO;

END;
/

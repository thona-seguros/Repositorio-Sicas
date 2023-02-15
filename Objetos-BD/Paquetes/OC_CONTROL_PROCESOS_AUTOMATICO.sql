CREATE OR REPLACE PACKAGE OC_CONTROL_PROCESOS_AUTOMATICO AS
/******************************************************************************
   NAME:       OC_CONTROL_PROCESOS_AUTOMATICO
   PURPOSE:
   ---------  ----------  ---------------  ------------------------------------
   1.0        19/04/2022      CPEREZ       1. Created this package.
******************************************************************************/
    --
    FUNCTION INSERTA_REGISTRO(pNOMBREPROCESO VARCHAR2,
                              pID_TERMINAL VARCHAR2) RETURN NUMBER;
    --
END OC_CONTROL_PROCESOS_AUTOMATICO;
/

CREATE OR REPLACE PACKAGE BODY OC_CONTROL_PROCESOS_AUTOMATICO AS
    --
    FUNCTION INSERTA_REGISTRO (pNOMBREPROCESO VARCHAR2,
                               pID_TERMINAL VARCHAR2)
                               RETURN NUMBER IS
        tmpVar NUMBER;
    BEGIN
        tmpVar := 0;
        SELECT SQ_CONTROL_PROCESOS_AUTOMATI.NEXTVAL INTO tmpVar FROM dual;
        INSERT INTO CONTROL_PROCESOS_AUTOMATICOS 
               (NOMBREPROCESO, FECHAEJECUCION, ID_ENVIO, ID_USER, ID_TERMINAL)
        VALUES 
               (pNOMBREPROCESO, sysdate, tmpVar, USER, pID_TERMINAL);
        return tmpVar;                 
    EXCEPTION WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
    END INSERTA_REGISTRO;
    --
END OC_CONTROL_PROCESOS_AUTOMATICO;

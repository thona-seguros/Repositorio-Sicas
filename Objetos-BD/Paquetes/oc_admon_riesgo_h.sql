--
-- OC_ADMON_RIESGO_H  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   ADMON_RIESGO_H (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_ADMON_RIESGO_H IS

PROCEDURE INSERTA(P_CODCIA         NUMBER,
                  P_CODEMPRESA     NUMBER,
                  P_ID_PROCESO     NUMBER,
                  P_IDPOLIZA       NUMBER,
                  P_CLIENTE        NUMBER,
                  P_ASEGURADO      NUMBER,
                  P_ORIGEN         VARCHAR2,
                  P_ST_RESOLUCION  VARCHAR2,
                  p_TP_RESOLUCION  VARCHAR2);  

END OC_ADMON_RIESGO_H;
/

--
-- OC_ADMON_RIESGO_H  (Package Body) 
--
--  Dependencies: 
--   OC_ADMON_RIESGO_H (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_ADMON_RIESGO_H IS
--
-- BITACORA DE CAMBIO
-- ALTA   JICO 20170518
--
PROCEDURE INSERTA(P_CODCIA         NUMBER,
                  P_CODEMPRESA     NUMBER,
                  P_ID_PROCESO     NUMBER,
                  P_IDPOLIZA       NUMBER,
                  P_CLIENTE        NUMBER,
                  P_ASEGURADO      NUMBER,
                  P_ORIGEN         VARCHAR2,
                  P_ST_RESOLUCION  VARCHAR2,
                  p_TP_RESOLUCION  VARCHAR2) IS  
--
 W_USUARIO VARCHAR2(15);
--
BEGIN  
  --
  SELECT USER 
    INTO W_USUARIO
    FROM DUAL;
  --
  --INSERTA ADMON_RIESGO_H
  --
  INSERT INTO ADMON_RIESGO_H
    (CODEMPRESA,                          CODCIA,		
     ID_PROCESO,                          IDPOLIZA,
     CODCLIENTE,                          CODASEGURADO,
     ORIGEN,
     ST_RESOLUCION,                       FE_ESTATUS,
     TP_RESOLUCION,                       FECHA_PROCESO,
     USUARIO
    )
    VALUES
    (P_CODEMPRESA,                        P_CODCIA,		
     P_ID_PROCESO,                        P_IDPOLIZA,
     P_CLIENTE,                           P_ASEGURADO,
     P_ORIGEN,
     P_ST_RESOLUCION,                     SYSDATE,
     p_TP_RESOLUCION,                     TRUNC(SYSDATE),
     W_USUARIO
    );
  --
END INSERTA;

END OC_ADMON_RIESGO_H;
/

--
-- OC_ADMON_RIESGO_H  (Synonym) 
--
--  Dependencies: 
--   OC_ADMON_RIESGO_H (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_ADMON_RIESGO_H FOR SICAS_OC.OC_ADMON_RIESGO_H
/


GRANT EXECUTE ON SICAS_OC.OC_ADMON_RIESGO_H TO PUBLIC
/

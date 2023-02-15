CREATE OR REPLACE PACKAGE OC_ADMON_ACTIVI IS

PROCEDURE VALIDA_ASEGURADO(P_CODCIA     NUMBER,
                           P_IDPOLIZA   NUMBER,
                           P_IDETPOL    NUMBER,
                           P_MENSAJE    IN OUT VARCHAR2
                           );

PROCEDURE VALIDA_SUMA_ASEG(P_CODCIA     NUMBER,
                           P_IDPOLIZA   NUMBER,
                           P_IDETPOL    NUMBER,
                           P_MENSAJE    IN OUT VARCHAR2
                           );

PROCEDURE INSERTA(P_CODCIA          NUMBER,
                  P_ID_PROCESO      NUMBER,
                  P_IDPOLIZA        NUMBER,
                  P_IDETPOL         NUMBER,
                  P_TP_PERSONA      VARCHAR2,
                  P_ORIGEN          VARCHAR2,
                  P_CODCLIENTE      NUMBER,
                  P_CODASEGURADO    NUMBER,
                  P_IDFACTURA       NUMBER,
                  P_IDTIPOSEG       VARCHAR2,
                  P_COD_MONEDA      VARCHAR2,
                  P_FORMPAGO        VARCHAR2,
                  P_TIPO_PERSONA    VARCHAR2,
                  P_CODACTIVIDAD    VARCHAR2,
                  P_ASEGURADOS_EMI  NUMBER,
                  P_ASEGURADOS_END  NUMBER,
                  P_SUMAASEG_EMI    NUMBER,
                  P_SUMAASEG_END    NUMBER,
                  P_OBSERVACIONES   VARCHAR2,
                  P_IDENDOSO        NUMBER,    
                  P_TIPO_DOC_IDENTIFICACION  VARCHAR2,    
                  P_NUM_DOC_IDENTIFICACION	VARCHAR2	                  
                  );


                  
END OC_ADMON_ACTIVI;
/

CREATE OR REPLACE PACKAGE BODY OC_ADMON_ACTIVI IS
--
-- BITACORA DE CAMBIO
-- ALTA   JICO 20170814
PROCEDURE VALIDA_ASEGURADO(P_CODCIA     NUMBER,
                           P_IDPOLIZA   NUMBER,
                           P_IDETPOL    NUMBER,
                           P_MENSAJE    IN OUT VARCHAR2
                           ) IS  
--
  W_MENSAJE        VARCHAR2(300);                 
  W_ASEGURADOS_EMI NUMBER(10);
  W_ASEGURADOS_END NUMBER(10); 
--
BEGIN
  --
  W_MENSAJE        := '';
  W_ASEGURADOS_EMI := 0;
  W_ASEGURADOS_END := 0;
  --
  -- ASEGURADOS DE EMISION 
  --
  SELECT COUNT(*)
    INTO W_ASEGURADOS_EMI 
    FROM ASEGURADO_CERTIFICADO AC
   WHERE AC.CODCIA   = P_CODCIA
     AND AC.IDPOLIZA = P_IDPOLIZA
     AND AC.IDETPOL  = 1
     AND AC.IDENDOSO = 0
     AND AC.ESTADO   = 'EMI';
  -- 
  -- ASEGURADOS ENDOSOS
  --
  SELECT COUNT(*)
    INTO W_ASEGURADOS_END
    FROM ASEGURADO_CERTIFICADO AC,
         ENDOSOS               E
   WHERE AC.CODCIA   = P_CODCIA
     AND AC.IDPOLIZA = P_IDPOLIZA
     AND AC.IDETPOL  > 0
     AND AC.IDENDOSO > 0
     AND AC.ESTADO   = 'EMI'
     --
     AND E.CODCIA     = AC.CODCIA
     AND E.IDPOLIZA   = AC.IDPOLIZA
     AND E.IDETPOL    = AC.IDETPOL
     AND E.IDENDOSO   = AC.IDENDOSO          
     AND E.TIPOENDOSO IN ('INA','IND','CLA','ESV')  
     AND E.STSENDOSO  = AC.ESTADO;
     --
  IF W_ASEGURADOS_END > (W_ASEGURADOS_EMI / 2) THEN
  	 INSERTA(P_CODCIA,
             1,
             P_IDPOLIZA,
             P_IDETPOL,
             'ASECOL',
             'LIMASE',
             0,
             --
             '',
             '',
             '',
             '',
             '',
             '',
             '',
             --
             W_ASEGURADOS_EMI,
             W_ASEGURADOS_END,
             0,
             0,
             '',
             '',
             '',
             '');
     W_MENSAJE := '!!! Alerta Se activo la regla de Numero de asegurados. Se genero una aviso al Oficial de cumplimiento';         
     P_MENSAJE := W_MENSAJE;
     --
     COMMIT;
     --
   END IF;
   --
END VALIDA_ASEGURADO;

PROCEDURE VALIDA_SUMA_ASEG(P_CODCIA     NUMBER,
                           P_IDPOLIZA   NUMBER,
                           P_IDETPOL    NUMBER,
                           P_MENSAJE    IN OUT VARCHAR2
                           ) IS  
--
  W_MENSAJE         VARCHAR2(300);                 
  W_SUMA_ASEG_EMI   NUMBER;
  W_SUMA_ASEG_END   NUMBER; 
--
BEGIN
  --
  W_MENSAJE        := '';
  W_SUMA_ASEG_EMI := 0;
  W_SUMA_ASEG_END := 0;
  --
  -- SUMA ASEGURADA DE EMISION 
  --
  SELECT SUM(NVL(AC.SUMAASEG,0))
    INTO W_SUMA_ASEG_EMI 
    FROM ASEGURADO_CERTIFICADO AC
   WHERE AC.CODCIA   = P_CODCIA
     AND AC.IDPOLIZA = P_IDPOLIZA
     AND AC.IDETPOL  = 1
     AND AC.IDENDOSO = 0
     AND AC.ESTADO   = 'EMI';
  -- 
  -- SUMA ASEGURADA DE ENDOSOS
  --
  SELECT SUM(NVL(AC.SUMAASEG,0))
    INTO W_SUMA_ASEG_END
    FROM ASEGURADO_CERTIFICADO AC,
         ENDOSOS               E
   WHERE AC.CODCIA   = P_CODCIA
     AND AC.IDPOLIZA = P_IDPOLIZA
     AND AC.IDETPOL  > 0
     AND AC.IDENDOSO > 0
     AND AC.ESTADO   = 'EMI'
     --
     AND E.CODCIA     = AC.CODCIA
     AND E.IDPOLIZA   = AC.IDPOLIZA
     AND E.IDETPOL    = AC.IDETPOL
     AND E.IDENDOSO   = AC.IDENDOSO          
     AND E.TIPOENDOSO IN ('AUM','INA','INC','IND','ESV')  
     AND E.STSENDOSO  = AC.ESTADO;
     --
  IF W_SUMA_ASEG_END > (W_SUMA_ASEG_EMI / 2) THEN
  	 INSERTA(P_CODCIA,
             1,
             P_IDPOLIZA,
             P_IDETPOL,
             'PRODUC',
             'LIMDOL',
             0,
             --
             '',
             '',
             '',
             '',
             '',
             '',
             '',
             --
             '',
             '',
             W_SUMA_ASEG_END,
             W_SUMA_ASEG_EMI,
             '',
             '',
             '',
             '');
     W_MENSAJE := '!!! Alerta Se activo la regla de Suma Asegurada. Se genero una aviso al Oficial de cumplimiento';         
     P_MENSAJE := W_MENSAJE;
     --
     COMMIT;
     --
   END IF;
   --
END VALIDA_SUMA_ASEG;

PROCEDURE INSERTA(P_CODCIA          NUMBER,
                  P_ID_PROCESO      NUMBER,
                  P_IDPOLIZA        NUMBER,
                  P_IDETPOL         NUMBER,
                  P_TP_PERSONA      VARCHAR2,
                  P_ORIGEN          VARCHAR2,
                  P_CODCLIENTE      NUMBER,
                  P_CODASEGURADO    NUMBER,
                  P_IDFACTURA       NUMBER,
                  P_IDTIPOSEG       VARCHAR2,
                  P_COD_MONEDA      VARCHAR2,
                  P_FORMPAGO        VARCHAR2,
                  P_TIPO_PERSONA    VARCHAR2,
                  P_CODACTIVIDAD    VARCHAR2,
                  P_ASEGURADOS_EMI  NUMBER,
                  P_ASEGURADOS_END  NUMBER,
                  P_SUMAASEG_EMI    NUMBER,
                  P_SUMAASEG_END    NUMBER,
                  P_OBSERVACIONES   VARCHAR2,
                  P_IDENDOSO        NUMBER,    
                  P_TIPO_DOC_IDENTIFICACION VARCHAR2,    
                  P_NUM_DOC_IDENTIFICACION	VARCHAR2	                  
                 ) IS
--
 W_USUARIO VARCHAR2(15);
--
BEGIN  
  --
  SELECT USER 
    INTO W_USUARIO
    FROM DUAL;
  --
  --INSERTA ADMON_ACTIVI
  --
  INSERT INTO ADMON_ACTIVI 
    (CODCIA,                              ID_PROCESO,
     IDPOLIZA,                            IDETPOL,
     TP_PERSONA,                          ORIGEN,
     CODCLIENTE,                          CODASEGURADO,
     IDFACTURA,                           IDTIPOSEG,
     COD_MONEDA,                          FORMPAGO,
     TIPO_PERSONA,                        CODACTIVIDAD,
     ASEGURADOS_EMI,                      ASEGURADOS_END,
     SUMAASEG_EMI,                        SUMAASEG_END,
     ST_RIESGO,                           OBSERVACIONES,
     FE_PROCESO,                          FE_HORA_PROCESO,
     FE_ACTUALIZACION,                    USUARIO_ACTUA,
     IMPTE_MOVTO_REG,                     FE_ALTA_REG,
     HISTORICO_MOVTOS_REG,                IDENDOSO,    
     TIPO_DOC_IDENTIFICACION,             NUM_DOC_IDENTIFICACION
    )
    VALUES
    (P_CODCIA,                            P_ID_PROCESO,
     P_IDPOLIZA,                          P_IDETPOL,
     P_TP_PERSONA,                        P_ORIGEN,
     P_CODCLIENTE,                        P_CODASEGURADO,
     P_IDFACTURA,                         P_IDTIPOSEG,
     P_COD_MONEDA,                        P_FORMPAGO,
     P_TIPO_PERSONA,                      P_CODACTIVIDAD,
     P_ASEGURADOS_EMI,                    P_ASEGURADOS_END,
     P_SUMAASEG_EMI,                      P_SUMAASEG_END,
     'PEND',                              P_OBSERVACIONES,
     TRUNC(SYSDATE),                      SYSDATE,
     '',                                  W_USUARIO,
     '',                                  '',
     '',                                  P_IDENDOSO,    
     P_TIPO_DOC_IDENTIFICACION,           P_NUM_DOC_IDENTIFICACION
    );
  --
END INSERTA;
--


END OC_ADMON_ACTIVI;

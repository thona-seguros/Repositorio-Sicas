create or replace PROCEDURE ENVIO_PLD IS
  nIdPoliza   NUMBER;
  nIdEndoso   NUMBER;
  cMensaje    VARCHAR2(300);

    CURSOR POLIZA_Q IS
    SELECT IDPOLIZA 
    FROM POLIZAS
    WHERE FECEMISION = TRUNC(SYSDATE) 
    AND STSPOLIZA = 'EMI';
    
    CURSOR ENDOSO_Q IS
    SELECT IDPOLIZA, IDENDOSO FROM ENDOSOS
    WHERE TIPOENDOSO IN ('INA','CLA')
    AND FECEMISION = TRUNC(SYSDATE)
    AND STSENDOSO='EMI';

BEGIN
  FOR X  IN POLIZA_Q LOOP
     nIdPoliza := X.Idpoliza;
     IF nIdPoliza != 0 THEN
        OC_ADMON_RIESGO.VALIDA_PERSONAS_POLIZA(nIdPoliza,cMensaje);
     END IF;
  END LOOP;
  
  FOR Y IN ENDOSO_Q LOOP
     nIdPoliza := Y.IdPoliza;
     nIdEndoso := Y.IdEndoso;
     IF nIdPoliza != 0 THEN
        OC_ADMON_RIESGO.VALIDA_PERSONAS_ENDOSO(1,nIdPoliza,nIdEndoso,cMensaje);
     END IF;
  END LOOP;
  
END ENVIO_PLD;
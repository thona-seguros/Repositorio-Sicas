
  CREATE OR REPLACE TRIGGER "SICAS_OC"."TRG_ACTUALIZA_COBERT_ACT_ASEG" 
 BEFORE UPDATE ON COBERT_ACT_ASEG
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
nMaxTransaccion     LOG_TRANSACCION.Id_Transaccion%TYPE;
cCodCia             POLIZAS.CodCia%TYPE;
cIP                 VARCHAR2(20);
cUsuario            VARCHAR2(30);
cTexto              VARCHAR2(4000) := 'DATOS MODIFICADOS: ';
cOsUser             VARCHAR2(100);
cHost               VARCHAR2(100);
cOrigenTransaccion  LOG_TRANSACCION.Origen_Transaccion%type;
BEGIN
  --
  SELECT SQ_LOGTRANSACC.NEXTVAL
    INTO nMaxTransaccion
    FROM DUAL;
  --
  SELECT USER
    INTO cUsuario
    FROM DUAL;
  --
  SELECT SYS_CONTEXT ('USERENV', 'IP_ADDRESS')
    INTO cIP
    FROM DUAL;

    SELECT SYS_CONTEXT ('USERENV', 'OS_USER')
    INTO cOsUser
    FROM DUAL;

    SELECT SYS_CONTEXT ('USERENV', 'HOST')
    INTO cHost
    FROM DUAL;
  --
  cOrigenTransaccion := SUBSTR(cHost||' - '||cOsUser,1,150);
  --dbms_output.put_line('STSCOBERTURA '|| :NEW.STSCOBERTURA);
  IF :NEW.STSCOBERTURA IN ('EMI','REN','ANU','REN','SUS','CEX','EXA') THEN
     IF :NEW.CODCOBERT != :OLD.CODCOBERT THEN
        cTexto := cTexto||' - '||' CODCOBERT ANTES: '||:OLD.CODCOBERT||' DESPUES: '||:NEW.CODCOBERT;
     END IF;
     IF :NEW.SUMAASEG_LOCAL != :OLD.SUMAASEG_LOCAL THEN
        cTexto := cTexto||' - '||' SUMAASEG_LOCAL ANTES: '||:OLD.SUMAASEG_LOCAL||' DESPUES: '||:NEW.SUMAASEG_LOCAL;
     END IF;
     IF :NEW.SUMAASEG_MONEDA != :OLD.SUMAASEG_MONEDA THEN
        cTexto := cTexto||' - '||' SUMAASEG_MONEDA ANTES: '||:OLD.SUMAASEG_MONEDA||' DESPUES: '||:NEW.SUMAASEG_MONEDA;
     END IF;
     IF :NEW.PRIMA_MONEDA != :OLD.PRIMA_MONEDA THEN
        cTexto := cTexto||' - '||' PRIMA_MONEDA ANTES: '||:OLD.PRIMA_MONEDA||' DESPUES: '||:NEW.PRIMA_MONEDA;
     END IF;
     IF :NEW.PRIMA_LOCAL != :OLD.PRIMA_LOCAL THEN
        cTexto := cTexto||' - '||' PRIMA_LOCAL ANTES: '||:OLD.PRIMA_LOCAL||' DESPUES: '||:NEW.PRIMA_LOCAL;
     END IF;
     IF :NEW.STSCOBERTURA != :OLD.STSCOBERTURA THEN
        cTexto := cTexto||' - '||' STSCOBERTURA ANTES: '||:OLD.STSCOBERTURA||' DESPUES: '||:NEW.STSCOBERTURA;
     END IF;
     IF :NEW.IDETPOL != :OLD.IDETPOL THEN
        cTexto := cTexto||' - '||' IDETPOL ANTES: '||:OLD.IDETPOL||' DESPUES: '||:NEW.IDETPOL;
     END IF;

     --
     INSERT INTO LOG_TRANSACCION
           (Id_Transaccion, CodCia, Id_Referencia, Fecha_Transaccion, Direccion_IP,
            Num_Referencia, Origen_Transaccion, Desc_Movimiento, CodUsuario)
     VALUES(nMaxtransaccion, 1, 'COBERT_ACT_ASEG ' || :NEW.IDPOLIZA, SYSDATE, cIP,
           :NEW.IdPoliza||'-'||:NEW.IDETPOL||'-'||:OLD.COD_ASEGURADO||'-'||:NEW.codcobert, cOrigenTransaccion,
           SUBSTR(cTexto,1,1000), cUsuario);
  END IF;
END;

ALTER TRIGGER "SICAS_OC"."TRG_ACTUALIZA_COBERT_ACT_ASEG" ENABLE

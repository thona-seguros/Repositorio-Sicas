CREATE OR REPLACE TRIGGER "TRG_ACTUALIZA_COBERT_ACT"
 BEFORE UPDATE ON COBERT_ACT
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
nMaxTransaccion     LOG_TRANSACCION.Id_Transaccion%TYPE;
cCodCia             POLIZAS.CodCia%TYPE;
cIP                 VARCHAR2(20);
cUsuario            VARCHAR2(30);
cTexto              VARCHAR2(4000) := 'DATOS MODIFICADOS: ';
cOsUser             VARCHAR2(20);
cHost               VARCHAR2(20);
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
  cOrigenTransaccion := cHost||' - '||cOsUser;
  dbms_output.put_line('STSCOBERTURA '|| :NEW.STSCOBERTURA);
  IF :NEW.STSCOBERTURA IN ('EMI','REN','ANU','REN','SUS','CEX','EXA') THEN
     IF :NEW.CODCOBERT != :OLD.CODCOBERT THEN
        cTexto := cTexto||' - '|| 'ANTES CODCOBERT: '||:OLD.CODCOBERT||' DESPUES CODCOBERT: '||:NEW.CODCOBERT;
     END IF;
     IF :NEW.SUMAASEG_LOCAL != :OLD.SUMAASEG_LOCAL THEN
        cTexto := cTexto||' - '|| 'ANTES SUMAASEG_LOCAL: '||:OLD.SUMAASEG_LOCAL||' DESPUES SUMAASEG_LOCAL: '||:NEW.SUMAASEG_LOCAL;
     END IF;
     IF :NEW.SUMAASEG_MONEDA != :OLD.SUMAASEG_MONEDA THEN
        cTexto := cTexto||' - '|| 'ANTES SUMAASEG_MONEDA: '||:OLD.SUMAASEG_MONEDA||' DESPUES SUMAASEG_MONEDA: '||:NEW.SUMAASEG_MONEDA;
     END IF;
     IF :NEW.PRIMA_MONEDA != :OLD.PRIMA_MONEDA THEN
        cTexto := cTexto||' - '|| 'ANTES PRIMA_MONEDA: '||:OLD.PRIMA_MONEDA||' DESPUES PRIMA_MONEDA: '||:NEW.PRIMA_MONEDA;
     END IF;
     IF :NEW.PRIMA_LOCAL != :OLD.PRIMA_LOCAL THEN
        cTexto := cTexto||' - '|| 'ANTES PRIMA_MONEDA: '||:OLD.PRIMA_LOCAL||' DESPUES PRIMA_MONEDA: '||:NEW.PRIMA_LOCAL;
     END IF;
     IF :NEW.STSCOBERTURA != :OLD.STSCOBERTURA THEN
        cTexto := cTexto||' - '|| 'ANTES STSCOBERTURA: '||:OLD.STSCOBERTURA||' DESPUES STSCOBERTURA: '||:NEW.STSCOBERTURA;
     END IF;
     IF :NEW.IDETPOL != :OLD.IDETPOL THEN
        cTexto := cTexto||' - '|| 'ANTES IDETPOL: '||:OLD.IDETPOL||' DESPUES IDETPOL: '||:NEW.IDETPOL;
     END IF;

  END IF;
  --
  INSERT INTO LOG_TRANSACCION
        (Id_Transaccion, CodCia, Id_Referencia, Fecha_Transaccion, Direccion_IP,
         Num_Referencia, Origen_Transaccion, Desc_Movimiento, CodUsuario)
  VALUES(nMaxtransaccion, 1, 'COBERT_ACT ' || :NEW.IDPOLIZA, SYSDATE, cIP,
         :NEW.IdPoliza||'-'||:NEW.IDETPOL||'-'||:NEW.codcobert, cOrigenTransaccion, SUBSTR(cTexto,1,1000), cUsuario);
END;
/

CREATE OR REPLACE TRIGGER SICAS_OC.TRG_CLAUSULAS
  BEFORE INSERT OR UPDATE OR DELETE ON CLAUSULAS
  FOR EACH ROW 
DECLARE
    vl_Texto    VARCHAR2(4000);
    vl_Primary  VARCHAR2(2000);
    vl_ErrorN   NUMBER;
    vl_ErrorC   VARCHAR2(4000);
BEGIN
  /*TRIGGER PARA MONITOREO DE LA TABLA CLAUSULAS
    FECHA CREACI�N: 12/06/2023
    MODIFICO: LUIS ARGENIS REYNOSO ALVAREZ
  */
  IF DELETING THEN 
      vl_Texto := TO_CHAR(:OLD.CODCIA)||' - '||TO_CHAR(:OLD.CODEMPRESA)||' - '||TO_CHAR(:OLD.CODCLAUSULA)||' - '||TO_CHAR(:OLD.DESCCLAUSULA)||' - '||TO_CHAR(:OLD.INDOBLIG)||' - '||TO_CHAR(:OLD.INDTIPOCLAUSULA)||' - '||
                  TO_CHAR('LONG')||' - '||TO_CHAR(:OLD.STSCLAUSULA)||' - '||TO_CHAR(:OLD.FECSTATUS)||' - '||TO_CHAR(:OLD.INDPLANCOB)||' - '||TO_CHAR(:OLD.INDCOBERTURA)||' - '||TO_CHAR(:OLD.TIPOADMINISTRACION)||' - '||TO_CHAR(:OLD.APLICATIPOADMINISTRACION);
      vl_Primary  := 'CODCIA: '||:OLD.CODCIA||' CODEMPRESA: '||:OLD.CODEMPRESA ||' CODCLAUSULA: '||:OLD.CODCLAUSULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'CLAUSULAS', 'SE ELIMINA TODO EL REGISTRO', vl_Texto, 'REGISTRO ELIMINADO', 'DELETE',vl_Primary);
  END IF;
 
  IF INSERTING THEN 
      vl_Texto := TO_CHAR(:NEW.CODCIA)||' - '||TO_CHAR(:NEW.CODEMPRESA)||' - '||TO_CHAR(:NEW.CODCLAUSULA)||' - '||TO_CHAR(:NEW.DESCCLAUSULA)||' - '||TO_CHAR(:NEW.INDOBLIG)||' - '||TO_CHAR(:NEW.INDTIPOCLAUSULA)||' - '||
                  TO_CHAR('LONG')||' - '||TO_CHAR(:NEW.STSCLAUSULA)||' - '||TO_CHAR(:NEW.FECSTATUS)||' - '||TO_CHAR(:NEW.INDPLANCOB)||' - '||TO_CHAR(:NEW.INDCOBERTURA)||' - '||TO_CHAR(:NEW.TIPOADMINISTRACION)||' - '||TO_CHAR(:NEW.APLICATIPOADMINISTRACION);
      vl_Primary  := 'CODCIA: '||:NEW.CODCIA||' CODEMPRESA: '||:NEW.CODEMPRESA ||' CODCLAUSULA: '||:NEW.CODCLAUSULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:NEW.CODCIA, 'CLAUSULAS', 'SE AGREGA NUEVO REGISTRO', vl_Texto, 'NUEVO REGISTRO', 'INSERT',vl_Primary);
  END IF;
  
  IF UPDATING THEN 
    IF (:NEW.CODCIA <> :OLD.CODCIA) THEN
      vl_Primary  := 'CODCIA: '||:OLD.CODCIA||' CODEMPRESA: '||:OLD.CODEMPRESA ||' CODCLAUSULA: '||:OLD.CODCLAUSULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'CLAUSULAS', 'CODCIA', TO_CHAR(:OLD.CODCIA), TO_CHAR(:NEW.CODCIA), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.CODEMPRESA <> :OLD.CODEMPRESA) THEN
      vl_Primary  := 'CODCIA: '||:OLD.CODCIA||' CODEMPRESA: '||:OLD.CODEMPRESA ||' CODCLAUSULA: '||:OLD.CODCLAUSULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'CLAUSULAS', 'CODEMPRESA', TO_CHAR(:OLD.CODEMPRESA), TO_CHAR(:NEW.CODEMPRESA), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.CODCLAUSULA <> :OLD.CODCLAUSULA) THEN
      vl_Primary  := 'CODCIA: '||:OLD.CODCIA||' CODEMPRESA: '||:OLD.CODEMPRESA ||' CODCLAUSULA: '||:OLD.CODCLAUSULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'CLAUSULAS', 'CODCLAUSULA', TO_CHAR(:OLD.CODCLAUSULA), TO_CHAR(:NEW.CODCLAUSULA), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.DESCCLAUSULA <> :OLD.DESCCLAUSULA) THEN
      vl_Primary  := 'CODCIA: '||:OLD.CODCIA||' CODEMPRESA: '||:OLD.CODEMPRESA ||' CODCLAUSULA: '||:OLD.CODCLAUSULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'CLAUSULAS', 'DESCCLAUSULA', TO_CHAR(:OLD.DESCCLAUSULA), TO_CHAR(:NEW.DESCCLAUSULA), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.INDOBLIG <> :OLD.INDOBLIG) THEN
      vl_Primary  := 'CODCIA: '||:OLD.CODCIA||' CODEMPRESA: '||:OLD.CODEMPRESA ||' CODCLAUSULA: '||:OLD.CODCLAUSULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'CLAUSULAS', 'INDOBLIG', TO_CHAR(:OLD.INDOBLIG), TO_CHAR(:NEW.INDOBLIG), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.INDTIPOCLAUSULA <> :OLD.INDTIPOCLAUSULA) THEN
      vl_Primary  := 'CODCIA: '||:OLD.CODCIA||' CODEMPRESA: '||:OLD.CODEMPRESA ||' CODCLAUSULA: '||:OLD.CODCLAUSULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'CLAUSULAS', 'INDTIPOCLAUSULA', TO_CHAR(:OLD.INDTIPOCLAUSULA), TO_CHAR(:NEW.INDTIPOCLAUSULA), 'UPDATE',vl_Primary);
    END IF;
/*
    IF dbms_lob.getlength(:NEW.TEXTOCLAUSULA) <> dbms_lob.getlength(:OLD.TEXTOCLAUSULA) THEN
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'CLAUSULAS', 'TEXTOCLAUSULA', TO_CHAR(:OLD.TEXTOCLAUSULA), TO_CHAR(:NEW.TEXTOCLAUSULA), 'UPDATE',vl_Primary);
    END IF;
*/
    IF (NVL(:NEW.STSCLAUSULA,-20000) <> NVL(:OLD.STSCLAUSULA,-20000)) THEN
      vl_Primary  := 'CODCIA: '||:OLD.CODCIA||' CODEMPRESA: '||:OLD.CODEMPRESA ||' CODCLAUSULA: '||:OLD.CODCLAUSULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'CLAUSULAS', 'STSCLAUSULA', TO_CHAR(:OLD.STSCLAUSULA), TO_CHAR(:NEW.STSCLAUSULA), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.FECSTATUS,SYSDATE) <> NVL(:OLD.FECSTATUS,SYSDATE)) THEN
      vl_Primary  := 'CODCIA: '||:OLD.CODCIA||' CODEMPRESA: '||:OLD.CODEMPRESA ||' CODCLAUSULA: '||:OLD.CODCLAUSULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'CLAUSULAS', 'FECSTATUS', TO_CHAR(:OLD.FECSTATUS), TO_CHAR(:NEW.FECSTATUS), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.INDPLANCOB,-20000) <> NVL(:OLD.INDPLANCOB,-20000)) THEN
      vl_Primary  := 'CODCIA: '||:OLD.CODCIA||' CODEMPRESA: '||:OLD.CODEMPRESA ||' CODCLAUSULA: '||:OLD.CODCLAUSULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'CLAUSULAS', 'INDPLANCOB', TO_CHAR(:OLD.INDPLANCOB), TO_CHAR(:NEW.INDPLANCOB), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.INDCOBERTURA,-20000) <> NVL(:OLD.INDCOBERTURA,-20000)) THEN
      vl_Primary  := 'CODCIA: '||:OLD.CODCIA||' CODEMPRESA: '||:OLD.CODEMPRESA ||' CODCLAUSULA: '||:OLD.CODCLAUSULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'CLAUSULAS', 'INDCOBERTURA', TO_CHAR(:OLD.INDCOBERTURA), TO_CHAR(:NEW.INDCOBERTURA), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.TIPOADMINISTRACION,-20000) <> NVL(:OLD.TIPOADMINISTRACION,-20000)) THEN
      vl_Primary  := 'CODCIA: '||:OLD.CODCIA||' CODEMPRESA: '||:OLD.CODEMPRESA ||' CODCLAUSULA: '||:OLD.CODCLAUSULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'CLAUSULAS', 'TIPOADMINISTRACION', TO_CHAR(:OLD.TIPOADMINISTRACION), TO_CHAR(:NEW.TIPOADMINISTRACION), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.APLICATIPOADMINISTRACION,-20000) <> NVL(:OLD.APLICATIPOADMINISTRACION,-20000)) THEN
      vl_Primary  := 'CODCIA: '||:OLD.CODCIA||' CODEMPRESA: '||:OLD.CODEMPRESA ||' CODCLAUSULA: '||:OLD.CODCLAUSULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'CLAUSULAS', 'APLICATIPOADMINISTRACION', TO_CHAR(:OLD.APLICATIPOADMINISTRACION), TO_CHAR(:NEW.APLICATIPOADMINISTRACION), 'UPDATE',vl_Primary);
    END IF;
  END IF;    

EXCEPTION
    WHEN OTHERS THEN 
      vl_ErrorN := SQLCODE;
      vl_ErrorC := 'Error con el disparador de CLAUSULAS, Contacte al administrador. '||SQLERRM;
      raise_application_error( -20000,vl_ErrorC);
END;
/

CREATE OR REPLACE PUBLIC SYNONYM TRG_CLAUSULAS FOR SICAS_OC.TRG_CLAUSULAS;
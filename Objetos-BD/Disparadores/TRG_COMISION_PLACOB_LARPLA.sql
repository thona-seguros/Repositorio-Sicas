CREATE OR REPLACE TRIGGER SICAS_OC.TRG_COMISION_PLACOB_LARPLA
  BEFORE INSERT OR UPDATE OR DELETE ON COMISION_PLACOB_LARPLA
  FOR EACH ROW 
DECLARE
    vl_Texto    VARCHAR2(4000);
    vl_Primary  VARCHAR2(2000);
    vl_ErrorN   NUMBER;
    vl_ErrorC   VARCHAR2(4000);
BEGIN
  /*TRIGGER PARA MONITOREO DE LA TABLA COMISION_PLACOB_LARPLA
    FECHA CREACI�N: 12/06/2023
    MODIFICO: LUIS ARGENIS REYNOSO ALVAREZ
  */
  IF DELETING THEN 
      vl_Texto := TO_CHAR(:OLD.CODEMPRESA)||' - '||TO_CHAR(:OLD.CODCIA)||' - '||TO_CHAR(:OLD.IDTIPOSEG)||' - '||TO_CHAR(:OLD.PLANCOB)||' - '||TO_CHAR(:OLD.ID_A�O)||' - '||TO_CHAR(:OLD.CODNIVEL)||' - '||TO_CHAR(:OLD.PORCCOMISION)
                  ||' - '||TO_CHAR(:OLD.ORIGEN)||' - '||TO_CHAR(:OLD.ST_COMISION)||' - '||TO_CHAR(:OLD.ID_USUARIO)||' - '||TO_CHAR(:OLD.FE_ESTATUS);
      vl_Primary := 'CODEMPRESA: '||:OLD.CODEMPRESA||' CODCIA: '||:OLD.CODCIA||' IDTIPOSEG: '||:OLD.IDTIPOSEG||' PLANCOB: '||:OLD.PLANCOB||' ID_A�O: '||:OLD.ID_A�O||' CODNIVEL: '||:OLD.CODNIVEL||' ST_COMISION: '||:OLD.ST_COMISION;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'COMISION_PLACOB_LARPLA', 'SE ELIMINA TODO EL REGISTRO', vl_Texto, 'REGISTRO ELIMINADO', 'DELETE',vl_Primary);
  END IF;
 
  IF INSERTING THEN 
      vl_Texto := TO_CHAR(:NEW.CODEMPRESA)||' - '||TO_CHAR(:NEW.CODCIA)||' - '||TO_CHAR(:NEW.IDTIPOSEG)||' - '||TO_CHAR(:NEW.PLANCOB)||' - '||TO_CHAR(:NEW.ID_A�O)||' - '||TO_CHAR(:NEW.CODNIVEL)||' - '||TO_CHAR(:NEW.PORCCOMISION)
                  ||' - '||TO_CHAR(:NEW.ORIGEN)||' - '||TO_CHAR(:NEW.ST_COMISION)||' - '||TO_CHAR(:NEW.ID_USUARIO)||' - '||TO_CHAR(:NEW.FE_ESTATUS);
      vl_Primary := 'CODEMPRESA: '||:NEW.CODEMPRESA||' CODCIA: '||:NEW.CODCIA||' IDTIPOSEG: '||:NEW.IDTIPOSEG||' PLANCOB: '||:NEW.PLANCOB||' ID_A�O: '||:NEW.ID_A�O||' CODNIVEL: '||:NEW.CODNIVEL||' ST_COMISION: '||:NEW.ST_COMISION;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:NEW.CODCIA, 'COMISION_PLACOB_LARPLA', 'SE AGREGA NUEVO REGISTRO', vl_Texto, 'NUEVO REGISTRO', 'INSERT',vl_Primary);
  END IF;

  IF UPDATING THEN 
    IF (:NEW.CODEMPRESA <> :OLD.CODEMPRESA) THEN
      vl_Primary := 'CODEMPRESA: '||:NEW.CODEMPRESA||' CODCIA: '||:NEW.CODCIA||' IDTIPOSEG: '||:NEW.IDTIPOSEG||' PLANCOB: '||:NEW.PLANCOB||' ID_A�O: '||:NEW.ID_A�O||' CODNIVEL: '||:NEW.CODNIVEL||' ST_COMISION: '||:NEW.ST_COMISION;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'COMISION_PLACOB_LARPLA', 'CODEMPRESA', TO_CHAR(:OLD.CODEMPRESA), TO_CHAR(:NEW.CODEMPRESA), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.CODCIA <> :OLD.CODCIA) THEN
      vl_Primary := 'CODEMPRESA: '||:NEW.CODEMPRESA||' CODCIA: '||:NEW.CODCIA||' IDTIPOSEG: '||:NEW.IDTIPOSEG||' PLANCOB: '||:NEW.PLANCOB||' ID_A�O: '||:NEW.ID_A�O||' CODNIVEL: '||:NEW.CODNIVEL||' ST_COMISION: '||:NEW.ST_COMISION;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'COMISION_PLACOB_LARPLA', 'CODCIA', TO_CHAR(:OLD.CODCIA), TO_CHAR(:NEW.CODCIA), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.IDTIPOSEG <> :OLD.IDTIPOSEG) THEN
      vl_Primary := 'CODEMPRESA: '||:NEW.CODEMPRESA||' CODCIA: '||:NEW.CODCIA||' IDTIPOSEG: '||:NEW.IDTIPOSEG||' PLANCOB: '||:NEW.PLANCOB||' ID_A�O: '||:NEW.ID_A�O||' CODNIVEL: '||:NEW.CODNIVEL||' ST_COMISION: '||:NEW.ST_COMISION;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'COMISION_PLACOB_LARPLA', 'IDTIPOSEG', TO_CHAR(:OLD.IDTIPOSEG), TO_CHAR(:NEW.IDTIPOSEG), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.PLANCOB <> :OLD.PLANCOB) THEN
      vl_Primary := 'CODEMPRESA: '||:NEW.CODEMPRESA||' CODCIA: '||:NEW.CODCIA||' IDTIPOSEG: '||:NEW.IDTIPOSEG||' PLANCOB: '||:NEW.PLANCOB||' ID_A�O: '||:NEW.ID_A�O||' CODNIVEL: '||:NEW.CODNIVEL||' ST_COMISION: '||:NEW.ST_COMISION;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'COMISION_PLACOB_LARPLA', 'PLANCOB', TO_CHAR(:OLD.PLANCOB), TO_CHAR(:NEW.PLANCOB), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.ID_A�O <> :OLD.ID_A�O) THEN
      vl_Primary := 'CODEMPRESA: '||:NEW.CODEMPRESA||' CODCIA: '||:NEW.CODCIA||' IDTIPOSEG: '||:NEW.IDTIPOSEG||' PLANCOB: '||:NEW.PLANCOB||' ID_A�O: '||:NEW.ID_A�O||' CODNIVEL: '||:NEW.CODNIVEL||' ST_COMISION: '||:NEW.ST_COMISION;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'COMISION_PLACOB_LARPLA', 'ID_A�O', TO_CHAR(:OLD.ID_A�O), TO_CHAR(:NEW.ID_A�O), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.CODNIVEL <> :OLD.CODNIVEL) THEN
      vl_Primary := 'CODEMPRESA: '||:NEW.CODEMPRESA||' CODCIA: '||:NEW.CODCIA||' IDTIPOSEG: '||:NEW.IDTIPOSEG||' PLANCOB: '||:NEW.PLANCOB||' ID_A�O: '||:NEW.ID_A�O||' CODNIVEL: '||:NEW.CODNIVEL||' ST_COMISION: '||:NEW.ST_COMISION;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'COMISION_PLACOB_LARPLA', 'CODNIVEL', TO_CHAR(:OLD.CODNIVEL), TO_CHAR(:NEW.CODNIVEL), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.PORCCOMISION,-20000) <> NVL(:OLD.PORCCOMISION,-20000)) THEN
      vl_Primary := 'CODEMPRESA: '||:NEW.CODEMPRESA||' CODCIA: '||:NEW.CODCIA||' IDTIPOSEG: '||:NEW.IDTIPOSEG||' PLANCOB: '||:NEW.PLANCOB||' ID_A�O: '||:NEW.ID_A�O||' CODNIVEL: '||:NEW.CODNIVEL||' ST_COMISION: '||:NEW.ST_COMISION;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'COMISION_PLACOB_LARPLA', 'PORCCOMISION', TO_CHAR(:OLD.PORCCOMISION), TO_CHAR(:NEW.PORCCOMISION), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.ORIGEN,-20000) <> NVL(:OLD.ORIGEN,-20000)) THEN
      vl_Primary := 'CODEMPRESA: '||:NEW.CODEMPRESA||' CODCIA: '||:NEW.CODCIA||' IDTIPOSEG: '||:NEW.IDTIPOSEG||' PLANCOB: '||:NEW.PLANCOB||' ID_A�O: '||:NEW.ID_A�O||' CODNIVEL: '||:NEW.CODNIVEL||' ST_COMISION: '||:NEW.ST_COMISION;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'COMISION_PLACOB_LARPLA', 'ORIGEN', TO_CHAR(:OLD.ORIGEN), TO_CHAR(:NEW.ORIGEN), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.ST_COMISION <> :OLD.ST_COMISION) THEN
      vl_Primary := 'CODEMPRESA: '||:NEW.CODEMPRESA||' CODCIA: '||:NEW.CODCIA||' IDTIPOSEG: '||:NEW.IDTIPOSEG||' PLANCOB: '||:NEW.PLANCOB||' ID_A�O: '||:NEW.ID_A�O||' CODNIVEL: '||:NEW.CODNIVEL||' ST_COMISION: '||:NEW.ST_COMISION;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'COMISION_PLACOB_LARPLA', 'ST_COMISION', TO_CHAR(:OLD.ST_COMISION), TO_CHAR(:NEW.ST_COMISION), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.ID_USUARIO,-20000) <> NVL(:OLD.ID_USUARIO,-20000)) THEN
      vl_Primary := 'CODEMPRESA: '||:NEW.CODEMPRESA||' CODCIA: '||:NEW.CODCIA||' IDTIPOSEG: '||:NEW.IDTIPOSEG||' PLANCOB: '||:NEW.PLANCOB||' ID_A�O: '||:NEW.ID_A�O||' CODNIVEL: '||:NEW.CODNIVEL||' ST_COMISION: '||:NEW.ST_COMISION;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'COMISION_PLACOB_LARPLA', 'ID_USUARIO', TO_CHAR(:OLD.ID_USUARIO), TO_CHAR(:NEW.ID_USUARIO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.FE_ESTATUS,SYSDATE) <> NVL(:OLD.FE_ESTATUS,SYSDATE)) THEN
      vl_Primary := 'CODEMPRESA: '||:NEW.CODEMPRESA||' CODCIA: '||:NEW.CODCIA||' IDTIPOSEG: '||:NEW.IDTIPOSEG||' PLANCOB: '||:NEW.PLANCOB||' ID_A�O: '||:NEW.ID_A�O||' CODNIVEL: '||:NEW.CODNIVEL||' ST_COMISION: '||:NEW.ST_COMISION;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'COMISION_PLACOB_LARPLA', 'FE_ESTATUS', TO_CHAR(:OLD.FE_ESTATUS), TO_CHAR(:NEW.FE_ESTATUS), 'UPDATE',vl_Primary);
    END IF;
  END IF;    

EXCEPTION
    WHEN OTHERS THEN 
      vl_ErrorN := SQLCODE;
      vl_ErrorC := 'Error con el disparador de COMISION_PLACOB_LARPLA, Contacte al administrador. '||SQLERRM;
      raise_application_error( -20000,vl_ErrorC);
END;
/

CREATE OR REPLACE PUBLIC SYNONYM TRG_COMISION_PLACOB_LARPLA FOR SICAS_OC.TRG_COMISION_PLACOB_LARPLA;
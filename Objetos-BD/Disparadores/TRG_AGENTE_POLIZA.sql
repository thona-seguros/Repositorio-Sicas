CREATE OR REPLACE TRIGGER SICAS_OC.TRG_AGENTE_POLIZA
  BEFORE DELETE ON AGENTE_POLIZA
  FOR EACH ROW 
DECLARE
    vl_Texto    VARCHAR2(4000);
    vl_Primary  VARCHAR2(2000);
    vl_ErrorN   NUMBER;
    vl_ErrorC   VARCHAR2(4000);
BEGIN
  /*TRIGGER PARA MONITOREO DE LA TABLA AGENTE_POLIZA
    FECHA CREACI�N: 22/06/2023
    MODIFICO: LUIS ARGENIS REYNOSO ALVAREZ
  */
  IF DELETING THEN 
      vl_Texto := TO_CHAR(:OLD.IDPOLIZA)||' - '||TO_CHAR(:OLD.CODCIA)||' - '||TO_CHAR(:OLD.COD_AGENTE)||' - '||TO_CHAR(:OLD.PORC_COMISION)||' - '||TO_CHAR(:OLD.IND_PRINCIPAL)||' - '||TO_CHAR(:OLD.ORIGEN);  
      vl_Primary := 'IDPOLIZA: '||:OLD.IDPOLIZA||' CODCIA: '||:OLD.CODCIA||' COD_AGENTE: '||:OLD.COD_AGENTE;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'AGENTE_POLIZA', 'SE ELIMINA TODO EL REGISTRO', vl_Texto, 'REGISTRO ELIMINADO', 'DELETE',vl_Primary);
  END IF;
 
EXCEPTION
    WHEN OTHERS THEN 
      vl_ErrorN := SQLCODE;
      vl_ErrorC := 'Error con el disparador de AGENTE_POLIZA, Contacte al administrador. '||SQLERRM;
      raise_application_error( -20000,vl_ErrorC);
END;
/

CREATE OR REPLACE PUBLIC SYNONYM TRG_AGENTE_POLIZA FOR SICAS_OC.TRG_AGENTE_POLIZA;
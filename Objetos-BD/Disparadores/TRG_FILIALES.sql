CREATE OR REPLACE TRIGGER SICAS_OC.TRG_FILIALES
  BEFORE INSERT OR UPDATE OR DELETE ON FILIALES
  FOR EACH ROW 
DECLARE
    vl_ErrorN   NUMBER;
    vl_ErrorC   VARCHAR2(4000);
BEGIN
  /*TRIGGER PARA MONITOREO DE LA TABLA FILIALES
    FECHA CREACIÓN: 21/01/2026
    MODIFICO: LUIS ARGENIS REYNOSO ALVAREZ
  */
  IF INSERTING THEN 
  
      IF (INSTR(:NEW.NomAdicFilial, '|') > 0) THEN
        :NEW.NomAdicFilial := REPLACE(:NEW.NomAdicFilial,'|','');
      END IF;
      
      IF (INSTR(:NEW.NomAdicFilial, CHR(13)) > 0) THEN
        :NEW.NomAdicFilial := REPLACE(:NEW.NomAdicFilial,CHR(13),' ');
      END IF;
      
  END IF;

  IF UPDATING THEN 
  
    IF (:NEW.NomAdicFilial <> :OLD.NomAdicFilial) THEN
      IF (INSTR(:NEW.NomAdicFilial, '|') > 0) THEN
        :NEW.NomAdicFilial := REPLACE(:NEW.NomAdicFilial,'|','');
      END IF;
      
      IF (INSTR(:NEW.NomAdicFilial, '|') > 0) THEN
        :NEW.NomAdicFilial := REPLACE(:NEW.NomAdicFilial,CHR(13),' ');
      END IF;
      
    END IF;
      
  END IF;    

EXCEPTION
    WHEN OTHERS THEN 
      vl_ErrorN := SQLCODE;
      vl_ErrorC := 'Error con el disparador de FILIALES, Contacte al administrador. '||SQLERRM;
      raise_application_error( -20000,vl_ErrorC);
END;
/

CREATE OR REPLACE PUBLIC SYNONYM TRG_FILIALES FOR SICAS_OC.TRG_FILIALES;

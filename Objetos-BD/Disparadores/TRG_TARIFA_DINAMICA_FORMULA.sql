CREATE OR REPLACE TRIGGER SICAS_OC.TRG_TARIFA_DINAMICA_FORMULA
  BEFORE INSERT OR UPDATE OR DELETE ON TARIFA_DINAMICA_FORMULA
  FOR EACH ROW 
DECLARE
    vl_Texto    VARCHAR2(4000);
    vl_Primary  VARCHAR2(2000);
    vl_ErrorN   NUMBER;
    vl_ErrorC   VARCHAR2(4000);
BEGIN
  /*TRIGGER PARA MONITOREO DE LA TABLA TARIFA_DINAMICA_FORMULA
    FECHA CREACI�N: 12/06/2023
    MODIFICO: LUIS ARGENIS REYNOSO ALVAREZ
  */
  IF DELETING THEN 
      vl_Texto := TO_CHAR(:OLD.IDTARIFA)||' - '||TO_CHAR(:OLD.CODCOBERT)||' - '||TO_CHAR(:OLD.TIPOTARIFA)||' - '||TO_CHAR(:OLD.IDORDENFORMULA)||' - '||TO_CHAR(:OLD.TIPOOPERACION)||' - '||
                  TO_CHAR(:OLD.VALOROPERACION)||' - '||TO_CHAR(:OLD.VALORCAMPO)||' - '||TO_CHAR(:OLD.ORDENPROCVALCAMPO)||' - '||TO_CHAR(:OLD.CODUSUARIO)||' - '||
                  TO_CHAR(:OLD.FECULTCAMBIO)||' - '||TO_CHAR(:OLD.ORDENCAMPO)||' - '||TO_CHAR(:OLD.IDCAMPO);
      vl_Primary := 'IDTARIFA: '||:OLD.IDTARIFA ||' CODCOBERT: '||:OLD.CODCOBERT ||' TIPOTARIFA: '||:OLD.TIPOTARIFA ||' IDCAMPO: '||:OLD.IDCAMPO ||' IDORDENFORMULA: '||:OLD.IDORDENFORMULA;      
      OC_LOG_CONF_FACT_ELECT.INSERTA(1, 'TARIFA_DINAMICA_FORMULA', 'SE ELIMINA TODO EL REGISTRO', vl_Texto, 'REGISTRO ELIMINADO', 'DELETE',vl_Primary);
  END IF;
 
  IF INSERTING THEN 
      vl_Texto := TO_CHAR(:NEW.IDTARIFA)||' - '||TO_CHAR(:NEW.CODCOBERT)||' - '||TO_CHAR(:NEW.TIPOTARIFA)||' - '||TO_CHAR(:NEW.IDORDENFORMULA)||' - '||TO_CHAR(:NEW.TIPOOPERACION)||' - '||
                  TO_CHAR(:NEW.VALOROPERACION)||' - '||TO_CHAR(:NEW.VALORCAMPO)||' - '||TO_CHAR(:NEW.ORDENPROCVALCAMPO)||' - '||TO_CHAR(:NEW.CODUSUARIO)||' - '||
                  TO_CHAR(:NEW.FECULTCAMBIO)||' - '||TO_CHAR(:NEW.ORDENCAMPO)||' - '||TO_CHAR(:NEW.IDCAMPO);
      vl_Primary := 'IDTARIFA: '||:NEW.IDTARIFA ||' CODCOBERT: '||:NEW.CODCOBERT ||' TIPOTARIFA: '||:NEW.TIPOTARIFA ||' IDCAMPO: '||:NEW.IDCAMPO ||' IDORDENFORMULA: '||:NEW.IDORDENFORMULA;               
      OC_LOG_CONF_FACT_ELECT.INSERTA(1, 'TARIFA_DINAMICA_FORMULA', 'SE AGREGA NUEVO REGISTRO', vl_Texto, 'NUEVO REGISTRO', 'INSERT',vl_Primary);
  END IF;

  IF UPDATING THEN 
    IF (:NEW.IDTARIFA <> :OLD.IDTARIFA) THEN
      vl_Primary := 'IDTARIFA: '||:OLD.IDTARIFA ||' CODCOBERT: '||:OLD.CODCOBERT ||' TIPOTARIFA: '||:OLD.TIPOTARIFA ||' IDCAMPO: '||:OLD.IDCAMPO ||' IDORDENFORMULA: '||:OLD.IDORDENFORMULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(1, 'TARIFA_DINAMICA_FORMULA', 'IDTARIFA', TO_CHAR(:OLD.IDTARIFA), TO_CHAR(:NEW.IDTARIFA), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.CODCOBERT <> :OLD.CODCOBERT) THEN
      vl_Primary := 'IDTARIFA: '||:OLD.IDTARIFA ||' CODCOBERT: '||:OLD.CODCOBERT ||' TIPOTARIFA: '||:OLD.TIPOTARIFA ||' IDCAMPO: '||:OLD.IDCAMPO ||' IDORDENFORMULA: '||:OLD.IDORDENFORMULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(1, 'TARIFA_DINAMICA_FORMULA', 'CODCOBERT', TO_CHAR(:OLD.CODCOBERT), TO_CHAR(:NEW.CODCOBERT), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.TIPOTARIFA <> :OLD.TIPOTARIFA) THEN
      vl_Primary := 'IDTARIFA: '||:OLD.IDTARIFA ||' CODCOBERT: '||:OLD.CODCOBERT ||' TIPOTARIFA: '||:OLD.TIPOTARIFA ||' IDCAMPO: '||:OLD.IDCAMPO ||' IDORDENFORMULA: '||:OLD.IDORDENFORMULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(1, 'TARIFA_DINAMICA_FORMULA', 'TIPOTARIFA', TO_CHAR(:OLD.TIPOTARIFA), TO_CHAR(:NEW.TIPOTARIFA), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.IDORDENFORMULA <> :OLD.IDORDENFORMULA) THEN
      vl_Primary := 'IDTARIFA: '||:OLD.IDTARIFA ||' CODCOBERT: '||:OLD.CODCOBERT ||' TIPOTARIFA: '||:OLD.TIPOTARIFA ||' IDCAMPO: '||:OLD.IDCAMPO ||' IDORDENFORMULA: '||:OLD.IDORDENFORMULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(1, 'TARIFA_DINAMICA_FORMULA', 'IDORDENFORMULA', TO_CHAR(:OLD.IDORDENFORMULA), TO_CHAR(:NEW.IDORDENFORMULA), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.TIPOOPERACION <> :OLD.TIPOOPERACION) THEN
      vl_Primary := 'IDTARIFA: '||:OLD.IDTARIFA ||' CODCOBERT: '||:OLD.CODCOBERT ||' TIPOTARIFA: '||:OLD.TIPOTARIFA ||' IDCAMPO: '||:OLD.IDCAMPO ||' IDORDENFORMULA: '||:OLD.IDORDENFORMULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(1, 'TARIFA_DINAMICA_FORMULA', 'TIPOOPERACION', TO_CHAR(:OLD.TIPOOPERACION), TO_CHAR(:NEW.TIPOOPERACION), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.VALOROPERACION,-20000) <> NVL(:OLD.VALOROPERACION,-20000)) THEN
      vl_Primary := 'IDTARIFA: '||:OLD.IDTARIFA ||' CODCOBERT: '||:OLD.CODCOBERT ||' TIPOTARIFA: '||:OLD.TIPOTARIFA ||' IDCAMPO: '||:OLD.IDCAMPO ||' IDORDENFORMULA: '||:OLD.IDORDENFORMULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(1, 'TARIFA_DINAMICA_FORMULA', 'VALOROPERACION', TO_CHAR(:OLD.VALOROPERACION), TO_CHAR(:NEW.VALOROPERACION), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.VALORCAMPO,-20000) <> NVL(:OLD.VALORCAMPO,-20000)) THEN
      vl_Primary := 'IDTARIFA: '||:OLD.IDTARIFA ||' CODCOBERT: '||:OLD.CODCOBERT ||' TIPOTARIFA: '||:OLD.TIPOTARIFA ||' IDCAMPO: '||:OLD.IDCAMPO ||' IDORDENFORMULA: '||:OLD.IDORDENFORMULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(1, 'TARIFA_DINAMICA_FORMULA', 'VALORCAMPO', TO_CHAR(:OLD.VALORCAMPO), TO_CHAR(:NEW.VALORCAMPO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.ORDENPROCVALCAMPO,-20000) <> NVL(:OLD.ORDENPROCVALCAMPO,-20000)) THEN
      vl_Primary := 'IDTARIFA: '||:OLD.IDTARIFA ||' CODCOBERT: '||:OLD.CODCOBERT ||' TIPOTARIFA: '||:OLD.TIPOTARIFA ||' IDCAMPO: '||:OLD.IDCAMPO ||' IDORDENFORMULA: '||:OLD.IDORDENFORMULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(1, 'TARIFA_DINAMICA_FORMULA', 'ORDENPROCVALCAMPO', TO_CHAR(:OLD.ORDENPROCVALCAMPO), TO_CHAR(:NEW.ORDENPROCVALCAMPO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.CODUSUARIO,-20000) <> NVL(:OLD.CODUSUARIO,-20000)) THEN
      vl_Primary := 'IDTARIFA: '||:OLD.IDTARIFA ||' CODCOBERT: '||:OLD.CODCOBERT ||' TIPOTARIFA: '||:OLD.TIPOTARIFA ||' IDCAMPO: '||:OLD.IDCAMPO ||' IDORDENFORMULA: '||:OLD.IDORDENFORMULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(1, 'TARIFA_DINAMICA_FORMULA', 'CODUSUARIO', TO_CHAR(:OLD.CODUSUARIO), TO_CHAR(:NEW.CODUSUARIO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.FECULTCAMBIO,SYSDATE) <> NVL(:OLD.FECULTCAMBIO,SYSDATE)) THEN
      vl_Primary := 'IDTARIFA: '||:OLD.IDTARIFA ||' CODCOBERT: '||:OLD.CODCOBERT ||' TIPOTARIFA: '||:OLD.TIPOTARIFA ||' IDCAMPO: '||:OLD.IDCAMPO ||' IDORDENFORMULA: '||:OLD.IDORDENFORMULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(1, 'TARIFA_DINAMICA_FORMULA', 'FECULTCAMBIO', TO_CHAR(:OLD.FECULTCAMBIO), TO_CHAR(:NEW.FECULTCAMBIO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.ORDENCAMPO,-20000) <> NVL(:OLD.ORDENCAMPO,-20000)) THEN
      vl_Primary := 'IDTARIFA: '||:OLD.IDTARIFA ||' CODCOBERT: '||:OLD.CODCOBERT ||' TIPOTARIFA: '||:OLD.TIPOTARIFA ||' IDCAMPO: '||:OLD.IDCAMPO ||' IDORDENFORMULA: '||:OLD.IDORDENFORMULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(1, 'TARIFA_DINAMICA_FORMULA', 'ORDENCAMPO', TO_CHAR(:OLD.ORDENCAMPO), TO_CHAR(:NEW.ORDENCAMPO), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.IDCAMPO <> :OLD.IDCAMPO) THEN
      vl_Primary := 'IDTARIFA: '||:OLD.IDTARIFA ||' CODCOBERT: '||:OLD.CODCOBERT ||' TIPOTARIFA: '||:OLD.TIPOTARIFA ||' IDCAMPO: '||:OLD.IDCAMPO ||' IDORDENFORMULA: '||:OLD.IDORDENFORMULA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(1, 'TARIFA_DINAMICA_FORMULA', 'IDCAMPO', TO_CHAR(:OLD.IDCAMPO), TO_CHAR(:NEW.IDCAMPO), 'UPDATE',vl_Primary);
    END IF;
  END IF;  
EXCEPTION
    WHEN OTHERS THEN 
      vl_ErrorN := SQLCODE;
      vl_ErrorC := 'Error con el disparador de TARIFA_DINAMICA_FORMULA, Contacte al administrador. '||SQLERRM;
      raise_application_error( -20000,vl_ErrorC);
END;
/

CREATE OR REPLACE PUBLIC SYNONYM TRG_TARIFA_DINAMICA_FORMULA FOR SICAS_OC.TRG_TARIFA_DINAMICA_FORMULA;
CREATE OR REPLACE TRIGGER TRG_U_FACT_ELECT_SERIES_FOLIOS
BEFORE UPDATE
ON FACT_ELECT_SERIES_FOLIOS
FOR EACH ROW

 BEGIN

  IF :NEW.TIPOCFDI != :OLD.TIPOCFDI THEN

     OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.codcia, 'FACT_ELECT_SERIES_FOLIOS', 'TIPOCFDI', :OLD.TIPOCFDI, :NEW.TIPOCFDI, 'UPDATE');

  END IF;

  IF :NEW.TIPODOCUMENTO != :OLD.TIPODOCUMENTO THEN

     OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.codcia, 'FACT_ELECT_SERIES_FOLIOS', 'TIPODOCUMENTO', :OLD.TIPODOCUMENTO, :NEW.TIPODOCUMENTO, 'UPDATE');

  END IF;

  IF :NEW.SERIE != :OLD.SERIE THEN

     OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.codcia, 'FACT_ELECT_SERIES_FOLIOS', 'SERIE', :OLD.SERIE, :NEW.SERIE, 'UPDATE');

  END IF;

  IF :NEW.FOLIO != :OLD.FOLIO THEN

     OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.codcia, 'FACT_ELECT_SERIES_FOLIOS', 'FOLIO', TO_CHAR(:OLD.FOLIO), TO_CHAR(:NEW.FOLIO), 'UPDATE');

  END IF;

  IF :NEW.FECINIVIG != :OLD.FECINIVIG THEN

     OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.codcia, 'FACT_ELECT_SERIES_FOLIOS', 'FECINIVIG', TO_CHAR(:OLD.FECINIVIG), TO_CHAR(:NEW.FECINIVIG), 'UPDATE');

  END IF;

  IF :NEW.FECFINVIG != :OLD.FECFINVIG THEN

     OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.codcia, 'FACT_ELECT_SERIES_FOLIOS', 'FECFINVIG', TO_CHAR(:OLD.FECFINVIG), TO_CHAR(:NEW.FECFINVIG), 'UPDATE');

  END IF;

  IF :NEW.CODUSUARIO != :OLD.CODUSUARIO THEN

     OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.codcia, 'FACT_ELECT_SERIES_FOLIOS', 'CODUSUARIO', :OLD.CODUSUARIO, :NEW.CODUSUARIO, 'UPDATE');

  END IF;

  IF :NEW.FECCONFIG != :OLD.FECCONFIG THEN

     OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.codcia, 'FACT_ELECT_SERIES_FOLIOS', 'FECCONFIG', TO_CHAR(:OLD.FECCONFIG), TO_CHAR(:NEW.FECCONFIG), 'UPDATE');

  END IF;

 END TRG_U_FACT_ELECT_SERIES_FOLIOS;
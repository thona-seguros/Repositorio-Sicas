CREATE OR REPLACE TRIGGER TRG_D_FACT_ELECT_FORMA_PAGO
BEFORE DELETE
ON FACT_ELECT_FORMA_PAGO
FOR EACH ROW
  DECLARE
    cTexto     VARCHAR2(4000);

 BEGIN

    cTexto := TO_CHAR(:OLD.CODCIA)||' - '||TO_CHAR(:OLD.IDFORMAPAGO)||' - '||:OLD.CODFORMAPAGO||' - '||:OLD.CODFORMAPAGOFE||' - '||TO_CHAR(:OLD.FECINIVIG)||' - '||TO_CHAR(:OLD.FECFINVIG)||' - '||:OLD.CODUSUARIO||' - '||:OLD.STSFORMAPAGO||' - '||TO_CHAR(:OLD.FECSTS);
 
    OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.codcia, 'FACT_ELECT_FORMA_PAGO', 'TODOS LOS CAMPOS', cTexto, 'Null', 'DELETE');
			
END TRG_D_FACT_ELECT_FORMA_PAGO;
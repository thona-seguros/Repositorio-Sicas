CREATE OR REPLACE TRIGGER TRG_D_FACT_ELECT_MVTO_CANCELA
BEFORE DELETE
ON FACT_ELECT_MOTIVO_CANCELA
FOR EACH ROW
  DECLARE
    cTexto     VARCHAR2(4000);

 BEGIN

    cTexto := TO_CHAR(:OLD.CODCIA)||' - '||:OLD.CVEMOTIVCANCFACT||' - '||:OLD.DESCMOTIVOCANC||' - '||:OLD.STSMOTIVCANC||' - '||TO_CHAR(:OLD.FECSTSMOTIVCANC)||' - '||:OLD.CODUSUARIO;
 
    OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.codcia, 'FACT_ELECT_MOTIVO_CANCELA', 'TODOS LOS CAMPOS', cTexto, 'Null', 'DELETE');
			
END TRG_D_FACT_ELECT_MVTO_CANCELA;
CREATE OR REPLACE TRIGGER SICAS_OC.TRG_ASEGURADO_CERTIFICADO
  BEFORE DELETE ON ASEGURADO_CERTIFICADO
  FOR EACH ROW 
DECLARE
    vl_Texto    VARCHAR2(4000);
    vl_Primary  VARCHAR2(2000);
    vl_ErrorN   NUMBER;
    vl_ErrorC   VARCHAR2(4000);
BEGIN
  /*TRIGGER PARA MONITOREO DE LA TABLA ASEGURADO_CERTIFICADO
    FECHA CREACIÓN: 22/06/2023
    MODIFICO: LUIS ARGENIS REYNOSO ALVAREZ
  */

  IF DELETING THEN 
      vl_Texto := TO_CHAR(:OLD.CODCIA)||' - '||TO_CHAR(:OLD.IDPOLIZA)||' - '||TO_CHAR(:OLD.IDETPOL)||' - '||TO_CHAR(:OLD.COD_ASEGURADO)||' - '||
                  
                  TO_CHAR(:OLD.CAMPO1)||' - '||TO_CHAR(:OLD.CAMPO2)||' - '||TO_CHAR(:OLD.CAMPO3)||' - '||TO_CHAR(:OLD.CAMPO4)||' - '||TO_CHAR(:OLD.CAMPO5)||' - '||
                  TO_CHAR(:OLD.CAMPO6)||' - '||TO_CHAR(:OLD.CAMPO7)||' - '||TO_CHAR(:OLD.CAMPO8)||' - '||TO_CHAR(:OLD.CAMPO9)||' - '||TO_CHAR(:OLD.CAMPO10)||' - '||
                  
                  TO_CHAR(:OLD.ESTADO)||' - '||TO_CHAR(:OLD.SUMAASEG)||' - '||TO_CHAR(:OLD.PRIMANETA)||' - '||  
                  
                  TO_CHAR(:OLD.CAMPO11)||' - '||TO_CHAR(:OLD.CAMPO12)||' - '||TO_CHAR(:OLD.CAMPO13)||' - '||TO_CHAR(:OLD.CAMPO14)||' - '||TO_CHAR(:OLD.CAMPO15)||' - '||
                  TO_CHAR(:OLD.CAMPO16)||' - '||TO_CHAR(:OLD.CAMPO17)||' - '||TO_CHAR(:OLD.CAMPO18)||' - '||TO_CHAR(:OLD.CAMPO19)||' - '||TO_CHAR(:OLD.CAMPO20)||' - '||
                  
                  TO_CHAR(:OLD.CAMPO21)||' - '||TO_CHAR(:OLD.CAMPO22)||' - '||TO_CHAR(:OLD.CAMPO23)||' - '||TO_CHAR(:OLD.CAMPO24)||' - '||TO_CHAR(:OLD.CAMPO25)||' - '||
                  TO_CHAR(:OLD.CAMPO26)||' - '||TO_CHAR(:OLD.CAMPO27)||' - '||TO_CHAR(:OLD.CAMPO28)||' - '||TO_CHAR(:OLD.CAMPO29)||' - '||TO_CHAR(:OLD.CAMPO30)||' - '||
                  
                  TO_CHAR(:OLD.CAMPO31)||' - '||TO_CHAR(:OLD.CAMPO32)||' - '||TO_CHAR(:OLD.CAMPO33)||' - '||TO_CHAR(:OLD.CAMPO34)||' - '||TO_CHAR(:OLD.CAMPO35)||' - '||
                  TO_CHAR(:OLD.CAMPO36)||' - '||TO_CHAR(:OLD.CAMPO37)||' - '||TO_CHAR(:OLD.CAMPO38)||' - '||TO_CHAR(:OLD.CAMPO39)||' - '||TO_CHAR(:OLD.CAMPO40)||' - '||
                  
                  TO_CHAR(:OLD.CAMPO41)||' - '||TO_CHAR(:OLD.CAMPO42)||' - '||TO_CHAR(:OLD.CAMPO43)||' - '||TO_CHAR(:OLD.CAMPO44)||' - '||TO_CHAR(:OLD.CAMPO45)||' - '||
                  TO_CHAR(:OLD.CAMPO46)||' - '||TO_CHAR(:OLD.CAMPO47)||' - '||TO_CHAR(:OLD.CAMPO48)||' - '||TO_CHAR(:OLD.CAMPO49)||' - '||TO_CHAR(:OLD.CAMPO50)||' - '||
                  
                  TO_CHAR(:OLD.CAMPO51)||' - '||TO_CHAR(:OLD.CAMPO52)||' - '||TO_CHAR(:OLD.CAMPO53)||' - '||TO_CHAR(:OLD.CAMPO54)||' - '||TO_CHAR(:OLD.CAMPO55)||' - '||
                  TO_CHAR(:OLD.CAMPO56)||' - '||TO_CHAR(:OLD.CAMPO57)||' - '||TO_CHAR(:OLD.CAMPO58)||' - '||TO_CHAR(:OLD.CAMPO59)||' - '||TO_CHAR(:OLD.CAMPO60)||' - '||
                  
                  TO_CHAR(:OLD.CAMPO61)||' - '||TO_CHAR(:OLD.CAMPO62)||' - '||TO_CHAR(:OLD.CAMPO63)||' - '||TO_CHAR(:OLD.CAMPO64)||' - '||TO_CHAR(:OLD.CAMPO65)||' - '||
                  TO_CHAR(:OLD.CAMPO66)||' - '||TO_CHAR(:OLD.CAMPO67)||' - '||TO_CHAR(:OLD.CAMPO68)||' - '||TO_CHAR(:OLD.CAMPO69)||' - '||TO_CHAR(:OLD.CAMPO70)||' - '||
                  
                  TO_CHAR(:OLD.CAMPO71)||' - '||TO_CHAR(:OLD.CAMPO72)||' - '||TO_CHAR(:OLD.CAMPO73)||' - '||TO_CHAR(:OLD.CAMPO74)||' - '||TO_CHAR(:OLD.CAMPO75)||' - '||
                  TO_CHAR(:OLD.CAMPO76)||' - '||TO_CHAR(:OLD.CAMPO77)||' - '||TO_CHAR(:OLD.CAMPO78)||' - '||TO_CHAR(:OLD.CAMPO79)||' - '||TO_CHAR(:OLD.CAMPO80)||' - '||
                  
                  TO_CHAR(:OLD.CAMPO81)||' - '||TO_CHAR(:OLD.CAMPO82)||' - '||TO_CHAR(:OLD.CAMPO83)||' - '||TO_CHAR(:OLD.CAMPO84)||' - '||TO_CHAR(:OLD.CAMPO85)||' - '||
                  TO_CHAR(:OLD.CAMPO86)||' - '||TO_CHAR(:OLD.CAMPO87)||' - '||TO_CHAR(:OLD.CAMPO88)||' - '||TO_CHAR(:OLD.CAMPO89)||' - '||TO_CHAR(:OLD.CAMPO90)||' - '||
                  
                  TO_CHAR(:OLD.CAMPO91)||' - '||TO_CHAR(:OLD.CAMPO92)||' - '||TO_CHAR(:OLD.CAMPO93)||' - '||TO_CHAR(:OLD.CAMPO94)||' - '||TO_CHAR(:OLD.CAMPO95)||' - '||
                  TO_CHAR(:OLD.CAMPO96)||' - '||TO_CHAR(:OLD.CAMPO97)||' - '||TO_CHAR(:OLD.CAMPO98)||' - '||TO_CHAR(:OLD.CAMPO99)||' - '||TO_CHAR(:OLD.CAMPO100)||' - '||
                  
                  TO_CHAR(:OLD.IDENDOSO)||' - '||TO_CHAR(:OLD.FECANULEXCLU)||' - '||TO_CHAR(:OLD.MOTIVANULEXCLU)||' - '||TO_CHAR(:OLD.SUMAASEG_MONEDA)||' - '||
                  TO_CHAR(:OLD.PRIMANETA_MONEDA)||' - '||TO_CHAR(:OLD.IDENDOSOEXCLU)||' - '||TO_CHAR(:OLD.MONTOAPORTEASEG)||' - '||TO_CHAR(:OLD.INDAJUSUMAASEGDECL);
      vl_Primary := 'CODCIA: '||:OLD.CODCIA ||' IDPOLIZA: '||:OLD.IDPOLIZA ||' IDETPOL: '||:OLD.IDETPOL ||' COD_ASEGURADO: '||:OLD.COD_ASEGURADO;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'ASEGURADO_CERTIFICADO', 'SE ELIMINA TODO EL REGISTRO', vl_Texto, 'REGISTRO ELIMINADO', 'DELETE',vl_Primary);
  END IF;
 
EXCEPTION
    WHEN OTHERS THEN 
      vl_ErrorN := SQLCODE;
      vl_ErrorC := 'Error con el disparador de ASEGURADO_CERTIFICADO, Contacte al administrador. '||SQLERRM;
      raise_application_error( -20000,vl_ErrorC);
END;
/

CREATE OR REPLACE PUBLIC SYNONYM TRG_ASEGURADO_CERTIFICADO FOR SICAS_OC.TRG_ASEGURADO_CERTIFICADO;

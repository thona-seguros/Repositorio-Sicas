CREATE OR REPLACE TRIGGER SICAS_OC.TRG_BENEF_SIN
  BEFORE UPDATE OR DELETE ON BENEF_SIN
  FOR EACH ROW 
DECLARE
    vl_Texto    VARCHAR2(4000);
    vl_Primary  VARCHAR2(2000);
    vl_ErrorN   NUMBER;
    vl_ErrorC   VARCHAR2(4000);
BEGIN
  /*TRIGGER PARA MONITOREO DE LA TABLA BENEF_SIN
    FECHA CREACI�N: 22/06/2023
    MODIFICO: LUIS ARGENIS REYNOSO ALVAREZ
  */  

  IF DELETING THEN 
      vl_Texto := TO_CHAR(:OLD.IDSINIESTRO)||' - '||TO_CHAR(:OLD.IDPOLIZA)||' - '||TO_CHAR(:OLD.COD_ASEGURADO)||' - '||TO_CHAR(:OLD.BENEF)||' - '||TO_CHAR(:OLD.NOMBRE)||' - '||TO_CHAR(:OLD.PORCEPART)||' - '||TO_CHAR(:OLD.CODPARENT)||' - '||
                  TO_CHAR(:OLD.ESTADO)||' - '||TO_CHAR(:OLD.SEXO)||' - '||TO_CHAR(:OLD.FECESTADO)||' - '||TO_CHAR(:OLD.FECALTA)||' - '||TO_CHAR(:OLD.FECBAJA)||' - '||TO_CHAR(:OLD.MOTBAJA)||' - '||TO_CHAR(:OLD.OBERVACIONES)||' - '||                 
                  TO_CHAR(:OLD.DIRECCION)||' - '||TO_CHAR(:OLD.EMAIL)||' - '||TO_CHAR(:OLD.TELEFONO)||' - '||TO_CHAR(:OLD.CUENTA_CLAVE)||' - '||TO_CHAR(:OLD.ENT_FINANCIERA)||' - '||TO_CHAR(:OLD.INDPAGO)||' - '||TO_CHAR(:OLD.PORCEAPL)||' - '||
                  TO_CHAR(:OLD.FECNAC)||' - '||TO_CHAR(:OLD.NUMCUENTABANCARIA)||' - '||TO_CHAR(:OLD.INDAPLICAISR)||' - '||TO_CHAR(:OLD.PORCENTISR)||' - '||TO_CHAR(:OLD.TIPO_ID_TRIBUTARIO)||' - '||TO_CHAR(:OLD.NUM_DOC_TRIBUTARIO)||' - '||
                  TO_CHAR(:OLD.APELLIDO_PATERNO)||' - '||TO_CHAR(:OLD.APELLIDO_MATERNO)||' - '||TO_CHAR(:OLD.TIPO_PAGO)||' - '||TO_CHAR(:OLD.FECFIRMARECLAMACION)||' - '||TO_CHAR(:OLD.TELEFONO_LOCAL)||' - '||TO_CHAR(:OLD.CODCIA)||' - '||
                  TO_CHAR(:OLD.CODEMPRESA)||' - '||TO_CHAR(:OLD.CODUSUARIO)||' - '||TO_CHAR(:OLD.FECREGISTRO)||' - '||TO_CHAR(:OLD.IDTIPO_PAGO)||' - '||TO_CHAR(:OLD.TP_IDENTIFICACION)||' - '||TO_CHAR(:OLD.NUM_IDENTIFICACION)||' - '||
                  TO_CHAR(:OLD.COD_CONVENIO)||' - '||TO_CHAR(:OLD.ID_EDAD_MINORIA)||' - '||TO_CHAR(:OLD.NOMBRE_MINORIA)||' - '||TO_CHAR(:OLD.PORC_MINORIA)||' - '||TO_CHAR(:OLD.SIT_CLIENTE)||' - '||TO_CHAR(:OLD.SIT_REFERENCIA)||' - '||
                  TO_CHAR(:OLD.SIT_CONCEPTO)||' - '||TO_CHAR(:OLD.IDREGFISSAT);
                  
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'SE ELIMINA TODO EL REGISTRO', vl_Texto, 'REGISTRO ELIMINADO', 'DELETE',vl_Primary);
  END IF;
 
  IF UPDATING THEN 
    IF (:NEW.IDSINIESTRO <> :OLD.IDSINIESTRO) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'IDSINIESTRO', TO_CHAR(:OLD.IDSINIESTRO), TO_CHAR(:NEW.IDSINIESTRO), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.IDPOLIZA <> :OLD.IDPOLIZA) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'IDPOLIZA', TO_CHAR(:OLD.IDPOLIZA), TO_CHAR(:NEW.IDPOLIZA), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.COD_ASEGURADO,-20000) <> NVL(:OLD.COD_ASEGURADO,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'COD_ASEGURADO', TO_CHAR(:OLD.COD_ASEGURADO), TO_CHAR(:NEW.COD_ASEGURADO), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.BENEF <> :OLD.BENEF) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'BENEF', TO_CHAR(:OLD.BENEF), TO_CHAR(:NEW.BENEF), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.NOMBRE <> :OLD.NOMBRE) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'NOMBRE', TO_CHAR(:OLD.NOMBRE), TO_CHAR(:NEW.NOMBRE), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.PORCEPART <> :OLD.PORCEPART) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'PORCEPART', TO_CHAR(:OLD.PORCEPART), TO_CHAR(:NEW.PORCEPART), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.CODPARENT,-20000) <> NVL(:OLD.CODPARENT,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'CODPARENT', TO_CHAR(:OLD.CODPARENT), TO_CHAR(:NEW.CODPARENT), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.ESTADO,-20000) <> NVL(:OLD.ESTADO,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'ESTADO', TO_CHAR(:OLD.ESTADO), TO_CHAR(:NEW.ESTADO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.SEXO,-20000) <> NVL(:OLD.SEXO,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'SEXO', TO_CHAR(:OLD.SEXO), TO_CHAR(:NEW.SEXO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.FECESTADO,SYSDATE) <> NVL(:OLD.FECESTADO,SYSDATE)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'FECESTADO', TO_CHAR(:OLD.FECESTADO), TO_CHAR(:NEW.FECESTADO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.FECALTA,SYSDATE) <> NVL(:OLD.FECALTA,SYSDATE)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'FECALTA', TO_CHAR(:OLD.FECALTA), TO_CHAR(:NEW.FECALTA), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.FECBAJA,SYSDATE) <> NVL(:OLD.FECBAJA,SYSDATE)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'FECBAJA', TO_CHAR(:OLD.FECBAJA), TO_CHAR(:NEW.FECBAJA), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.MOTBAJA,-20000) <> NVL(:OLD.MOTBAJA,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'MOTBAJA', TO_CHAR(:OLD.MOTBAJA), TO_CHAR(:NEW.MOTBAJA), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.OBERVACIONES,-20000) <> NVL(:OLD.OBERVACIONES,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'OBERVACIONES', TO_CHAR(:OLD.OBERVACIONES), TO_CHAR(:NEW.OBERVACIONES), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.DIRECCION,-20000) <> NVL(:OLD.DIRECCION,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'DIRECCION', TO_CHAR(:OLD.DIRECCION), TO_CHAR(:NEW.DIRECCION), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.EMAIL,-20000) <> NVL(:OLD.EMAIL,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'EMAIL', TO_CHAR(:OLD.EMAIL), TO_CHAR(:NEW.EMAIL), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.TELEFONO,-20000) <> NVL(:OLD.TELEFONO,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'TELEFONO', TO_CHAR(:OLD.TELEFONO), TO_CHAR(:NEW.TELEFONO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.CUENTA_CLAVE,-20000) <> NVL(:OLD.CUENTA_CLAVE,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'CUENTA_CLAVE', TO_CHAR(:OLD.CUENTA_CLAVE), TO_CHAR(:NEW.CUENTA_CLAVE), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.ENT_FINANCIERA,-20000) <> NVL(:OLD.ENT_FINANCIERA,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'ENT_FINANCIERA', TO_CHAR(:OLD.ENT_FINANCIERA), TO_CHAR(:NEW.ENT_FINANCIERA), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.INDPAGO,-20000) <> NVL(:OLD.INDPAGO,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'INDPAGO', TO_CHAR(:OLD.INDPAGO), TO_CHAR(:NEW.INDPAGO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.PORCEAPL,-20000) <> NVL(:OLD.PORCEAPL,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'PORCEAPL', TO_CHAR(:OLD.PORCEAPL), TO_CHAR(:NEW.PORCEAPL), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.FECNAC,SYSDATE) <> NVL(:OLD.FECNAC,SYSDATE)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'FECNAC', TO_CHAR(:OLD.FECNAC), TO_CHAR(:NEW.FECNAC), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.NUMCUENTABANCARIA,-20000) <> NVL(:OLD.NUMCUENTABANCARIA,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'NUMCUENTABANCARIA', TO_CHAR(:OLD.NUMCUENTABANCARIA), TO_CHAR(:NEW.NUMCUENTABANCARIA), 'UPDATE',vl_Primary);
    END IF;
    IF (:NEW.INDAPLICAISR <> :OLD.INDAPLICAISR) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'INDAPLICAISR', TO_CHAR(:OLD.INDAPLICAISR), TO_CHAR(:NEW.INDAPLICAISR), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.PORCENTISR,-20000) <> NVL(:OLD.PORCENTISR,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'PORCENTISR', TO_CHAR(:OLD.PORCENTISR), TO_CHAR(:NEW.PORCENTISR), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.TIPO_ID_TRIBUTARIO,-20000) <> NVL(:OLD.TIPO_ID_TRIBUTARIO,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'TIPO_ID_TRIBUTARIO', TO_CHAR(:OLD.TIPO_ID_TRIBUTARIO), TO_CHAR(:NEW.TIPO_ID_TRIBUTARIO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.NUM_DOC_TRIBUTARIO,-20000) <> NVL(:OLD.NUM_DOC_TRIBUTARIO,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'NUMCUENTABANCARIA', TO_CHAR(:OLD.NUM_DOC_TRIBUTARIO), TO_CHAR(:NEW.NUM_DOC_TRIBUTARIO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.APELLIDO_PATERNO,-20000) <> NVL(:OLD.APELLIDO_PATERNO,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'APELLIDO_PATERNO', TO_CHAR(:OLD.APELLIDO_PATERNO), TO_CHAR(:NEW.APELLIDO_PATERNO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.APELLIDO_MATERNO,-20000) <> NVL(:OLD.APELLIDO_MATERNO,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'APELLIDO_MATERNO', TO_CHAR(:OLD.APELLIDO_MATERNO), TO_CHAR(:NEW.APELLIDO_MATERNO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.TIPO_PAGO,-20000) <> NVL(:OLD.TIPO_PAGO,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'TIPO_PAGO', TO_CHAR(:OLD.TIPO_PAGO), TO_CHAR(:NEW.TIPO_PAGO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.FECFIRMARECLAMACION,SYSDATE) <> NVL(:OLD.FECFIRMARECLAMACION,SYSDATE)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'FECFIRMARECLAMACION', TO_CHAR(:OLD.FECFIRMARECLAMACION), TO_CHAR(:NEW.FECFIRMARECLAMACION), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.TELEFONO_LOCAL,-20000) <> NVL(:OLD.TELEFONO_LOCAL,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'TELEFONO_LOCAL', TO_CHAR(:OLD.TELEFONO_LOCAL), TO_CHAR(:NEW.TELEFONO_LOCAL), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.CODCIA,-20000) <> NVL(:OLD.CODCIA,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'CODCIA', TO_CHAR(:OLD.CODCIA), TO_CHAR(:NEW.CODCIA), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.CODEMPRESA,-20000) <> NVL(:OLD.CODEMPRESA,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'CODEMPRESA', TO_CHAR(:OLD.CODEMPRESA), TO_CHAR(:NEW.CODEMPRESA), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.CODUSUARIO,-20000) <> NVL(:OLD.CODUSUARIO,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'CODUSUARIO', TO_CHAR(:OLD.CODUSUARIO), TO_CHAR(:NEW.CODUSUARIO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.FECREGISTRO,SYSDATE) <> NVL(:OLD.FECREGISTRO,SYSDATE)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'FECREGISTRO', TO_CHAR(:OLD.FECREGISTRO), TO_CHAR(:NEW.FECREGISTRO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.IDTIPO_PAGO,-20000) <> NVL(:OLD.IDTIPO_PAGO,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'IDTIPO_PAGO', TO_CHAR(:OLD.IDTIPO_PAGO), TO_CHAR(:NEW.IDTIPO_PAGO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.TP_IDENTIFICACION,-20000) <> NVL(:OLD.TP_IDENTIFICACION,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'TP_IDENTIFICACION', TO_CHAR(:OLD.TP_IDENTIFICACION), TO_CHAR(:NEW.TP_IDENTIFICACION), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.NUM_IDENTIFICACION,-20000) <> NVL(:OLD.NUM_IDENTIFICACION,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'NUM_IDENTIFICACION', TO_CHAR(:OLD.NUM_IDENTIFICACION), TO_CHAR(:NEW.NUM_IDENTIFICACION), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.COD_CONVENIO,-20000) <> NVL(:OLD.COD_CONVENIO,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'COD_CONVENIO', TO_CHAR(:OLD.COD_CONVENIO), TO_CHAR(:NEW.COD_CONVENIO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.ID_EDAD_MINORIA,-20000) <> NVL(:OLD.ID_EDAD_MINORIA,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'ID_EDAD_MINORIA', TO_CHAR(:OLD.ID_EDAD_MINORIA), TO_CHAR(:NEW.ID_EDAD_MINORIA), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.NOMBRE_MINORIA,-20000) <> NVL(:OLD.NOMBRE_MINORIA,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'NOMBRE_MINORIA', TO_CHAR(:OLD.NOMBRE_MINORIA), TO_CHAR(:NEW.NOMBRE_MINORIA), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.PORC_MINORIA,-20000) <> NVL(:OLD.PORC_MINORIA,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'PORC_MINORIA', TO_CHAR(:OLD.PORC_MINORIA), TO_CHAR(:NEW.PORC_MINORIA), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.SIT_CLIENTE,-20000) <> NVL(:OLD.SIT_CLIENTE,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'SIT_CLIENTE', TO_CHAR(:OLD.SIT_CLIENTE), TO_CHAR(:NEW.SIT_CLIENTE), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.SIT_REFERENCIA,-20000) <> NVL(:OLD.SIT_REFERENCIA,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'SIT_REFERENCIA', TO_CHAR(:OLD.SIT_REFERENCIA), TO_CHAR(:NEW.SIT_REFERENCIA), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.SIT_CONCEPTO,-20000) <> NVL(:OLD.SIT_CONCEPTO,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'SIT_CONCEPTO', TO_CHAR(:OLD.SIT_CONCEPTO), TO_CHAR(:NEW.SIT_CONCEPTO), 'UPDATE',vl_Primary);
    END IF;
    IF (NVL(:NEW.IDREGFISSAT,-20000) <> NVL(:OLD.IDREGFISSAT,-20000)) THEN
      vl_Primary := 'IDSINIESTRO: '||:OLD.IDSINIESTRO||' BENEF: '||:OLD.BENEF||' CODCIA: '||:OLD.CODCIA;
      OC_LOG_CONF_FACT_ELECT.INSERTA(:OLD.CODCIA, 'BENEF_SIN', 'SIT_REFERENCIA', TO_CHAR(:OLD.IDREGFISSAT), TO_CHAR(:NEW.IDREGFISSAT), 'UPDATE',vl_Primary);
    END IF;
  END IF;    
EXCEPTION
    WHEN OTHERS THEN 
      vl_ErrorN := SQLCODE;
      vl_ErrorC := 'Error con el disparador de BENEF_SIN, Contacte al administrador. '||SQLERRM;
      raise_application_error( -20000,vl_ErrorC);
END;
/

CREATE OR REPLACE PUBLIC SYNONYM TRG_BENEF_SIN FOR SICAS_OC.TRG_BENEF_SIN;
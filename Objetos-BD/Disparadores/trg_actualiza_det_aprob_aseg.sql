--
-- TRG_ACTUALIZA_DET_APROB_ASEG  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   POLIZAS (Table)
--   DETALLE_APROBACION_ASEG (Table)
--   LOG_TRANSACCION (Table)
--   SQ_LOGTRANSACC (Sequence)
--
CREATE OR REPLACE TRIGGER SICAS_OC.TRG_ACTUALIZA_DET_APROB_ASEG 
 BEFORE UPDATE ON SICAS_OC.DETALLE_APROBACION_ASEG
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
DECLARE
nMaxTransaccion   LOG_TRANSACCION.Id_Transaccion%TYPE;
cCodCia           POLIZAS.CodCia%TYPE;
cIP               VARCHAR2(20);
cUsuario          VARCHAR2(30);
cTexto            VARCHAR2(4000) := 'DATOS MODIFICADOS: ';
BEGIN
   --  
   SELECT SQ_LOGTRANSACC.NEXTVAL
     INTO nMaxTransaccion
     FROM DUAL;
   --           
  SELECT USER
    INTO cUsuario
    FROM DUAL;
  --
  SELECT SYS_CONTEXT ('USERENV', 'IP_ADDRESS')
    INTO cIP
    FROM DUAL;
  --
  IF :NEW.NUM_APROBACION != :OLD.NUM_APROBACION THEN
     cTexto := cTexto||' - '|| 'NUM_APROBACION: '||:NEW.NUM_APROBACION;
  END IF;
  IF :NEW.IDDETAPROB != :OLD.IDDETAPROB THEN
     cTexto := cTexto||' - '|| 'IDDETAPROB: '||:NEW.IDDETAPROB;
  END IF;
  IF :NEW.COD_PAGO != :OLD.COD_PAGO THEN
     cTexto := cTexto||' - '|| 'COD_PAGO: '||:NEW.COD_PAGO;
  END IF;
  IF :NEW.MONTO_LOCAL != :OLD.MONTO_LOCAL THEN
     cTexto := cTexto||' - '|| 'MONTO_LOCAL: '||:NEW.MONTO_LOCAL;
  END IF;
  IF :NEW.MONTO_MONEDA != :OLD.MONTO_MONEDA THEN
     cTexto := cTexto||' - '|| 'MONTO_MONEDA: '||:NEW.MONTO_MONEDA;
  END IF;
  IF :NEW.IDSINIESTRO != :OLD.IDSINIESTRO THEN
     cTexto := cTexto||' - '|| 'IDSINIESTRO: '||:NEW.IDSINIESTRO;
  END IF;
  IF :NEW.CODTRANSAC != :OLD.CODTRANSAC THEN
     cTexto := cTexto||' - '|| 'CODTRANSAC: '||:NEW.CODTRANSAC;
  END IF;
  IF :NEW.CODCPTOTRANSAC != :OLD.CODCPTOTRANSAC THEN
     cTexto := cTexto||' - '|| 'CODCPTOTRANSAC: '||:NEW.CODCPTOTRANSAC;
  END IF;
  --
  INSERT INTO LOG_TRANSACCION
        (Id_Transaccion, CodCia, Id_Referencia, Fecha_Transaccion, Direccion_IP,
         Num_Referencia, Origen_Transaccion, Desc_Movimiento, CodUsuario)
  VALUES(nMaxtransaccion, 1, 'DETALLE_APROBACION_ASEG ' || :NEW.IdSiniestro, SYSDATE, cIP,
         :NEW.IdSiniestro||'-'||:NEW.Num_Aprobacion||'-'||:NEW.IdDetAprob||'-'||:NEW.Cod_Pago, 'MODIFICA DETALLE_APROBACION_ASEG', SUBSTR(cTexto,1,1000), cUsuario);
END;
/

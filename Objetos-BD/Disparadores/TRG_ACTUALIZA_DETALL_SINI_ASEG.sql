
  CREATE OR REPLACE TRIGGER "SICAS_OC"."TRG_ACTUALIZA_DETALL_SINI_ASEG" 
 BEFORE UPDATE ON DETALLE_SINIESTRO_ASEG
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
  IF :NEW.IDSINIESTRO != :OLD.IDSINIESTRO THEN
     cTexto := cTexto||' - '|| 'IDSINIESTRO: '||:NEW.IDSINIESTRO;
  END IF;
  IF :NEW.IDPOLIZA != :OLD.IDPOLIZA THEN
     cTexto := cTexto||' - '|| 'IDPOLIZA: '||:NEW.IDPOLIZA;
  END IF;
  IF :NEW.IDDETSIN != :OLD.IDDETSIN THEN
     cTexto := cTexto||' - '|| 'IDDETSIN: '||:NEW.IDDETSIN;
  END IF;
  IF :NEW.COD_ASEGURADO != :OLD.COD_ASEGURADO THEN
     cTexto := cTexto||' - '|| 'COD_ASEGURADO: '||:NEW.COD_ASEGURADO;
  END IF;
  IF :NEW.MONTO_PAGADO_MONEDA != :OLD.MONTO_PAGADO_MONEDA THEN
     cTexto := cTexto||' - '|| 'MONTO_PAGADO_MONEDA: '||:NEW.MONTO_PAGADO_MONEDA;
  END IF;
  IF :NEW.MONTO_PAGADO_LOCAL != :OLD.MONTO_PAGADO_LOCAL THEN
     cTexto := cTexto||' - '|| 'MONTO_PAGADO_LOCAL: '||:NEW.MONTO_PAGADO_LOCAL;
  END IF;
  IF :NEW.MONTO_RESERVADO_MONEDA != :OLD.MONTO_RESERVADO_MONEDA THEN
     cTexto := cTexto||' - '|| 'MONTO_RESERVADO_MONEDA: '||:NEW.MONTO_RESERVADO_MONEDA;
  END IF;
  IF :NEW.MONTO_RESERVADO_LOCAL != :OLD.MONTO_RESERVADO_LOCAL THEN
     cTexto := cTexto||' - '|| 'MONTO_RESERVADO_LOCAL: '||:NEW.MONTO_RESERVADO_LOCAL;
  END IF;
  IF :NEW.IDTIPOSEG != :OLD.IDTIPOSEG THEN
     cTexto := cTexto||' - '|| 'IDTIPOSEG: '||:NEW.IDTIPOSEG;
  END IF;
  --
  INSERT INTO LOG_TRANSACCION
        (Id_Transaccion, CodCia, Id_Referencia, Fecha_Transaccion, Direccion_IP,
         Num_Referencia, Origen_Transaccion, Desc_Movimiento, CodUsuario)
  VALUES(nMaxtransaccion, 1, 'DETALLE_SINI_ASEG ' ||:NEW.IdSiniestro, SYSDATE, cIP,
         :NEW.IdSiniestro||'-'||:NEW.IdDetSin, 'MODIFICA DETALLE_SINIESTRO_ASEG', SUBSTR(cTexto,1,1000), cUsuario);
END;






ALTER TRIGGER "SICAS_OC"."TRG_ACTUALIZA_DETALL_SINI_ASEG" ENABLE
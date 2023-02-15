
  CREATE OR REPLACE TRIGGER "SICAS_OC"."ACTUALIZA_FECHALIQ" 
  AFTER UPDATE OF fec_liquidacion ON comisiones  
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
BEGIN
          UPDATE saldos_comisiones_detalle
             SET fe_pago  = :new.fec_liquidacion
           WHERE id_comision  = :old.idcomision;    
END Actualiza_FechaLiq;




ALTER TRIGGER "SICAS_OC"."ACTUALIZA_FECHALIQ" ENABLE

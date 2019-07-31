--
-- ACTUALIZA_FECHALIQ  (Trigger) 
--
--  Dependencies: 
--   STANDARD (Package)
--   SALDOS_COMISIONES_DETALLE (Table)
--   COMISIONES (Table)
--
CREATE OR REPLACE TRIGGER SICAS_OC.ACTUALIZA_FECHALIQ 
  AFTER UPDATE OF fec_liquidacion ON SICAS_OC.COMISIONES  
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
BEGIN
          UPDATE saldos_comisiones_detalle
             SET fe_pago  = :new.fec_liquidacion
           WHERE id_comision  = :old.idcomision;    
END Actualiza_FechaLiq;
/

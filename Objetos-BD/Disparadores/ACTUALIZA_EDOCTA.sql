
  CREATE OR REPLACE TRIGGER "SICAS_OC"."ACTUALIZA_EDOCTA" 
 AFTER UPDATE OF estado ON comisiones
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW

BEGIN
          UPDATE saldos_comisiones_detalle
             SET st_comision  = :new.estado      
           WHERE id_comision  = :old.idcomision;    
END;




ALTER TRIGGER "SICAS_OC"."ACTUALIZA_EDOCTA" ENABLE

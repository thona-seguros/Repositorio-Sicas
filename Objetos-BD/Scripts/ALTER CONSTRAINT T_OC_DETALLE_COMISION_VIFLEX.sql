-- =============================
-- Elimina llave primaria
-- =============================
-- 
ALTER TABLE T_OC_DETALLE_COMISION_VIFLEX drop constraint DETALLE_COMISION_VIFLEX_PK cascade;
DROP INDEX DETALLE_COMISION_VIFLEX_PK;


alter table T_OC_DETALLE_COMISION_VIFLEX
  add constraint DETALLE_COMISION_VIFLEX_PK primary key (COD_AGENTE, IDPOLIZA, NUMDOCTO, IDETPOL,TIPORAMO)
; 
 

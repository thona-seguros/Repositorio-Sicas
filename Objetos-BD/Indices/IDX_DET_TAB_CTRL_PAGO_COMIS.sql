
  CREATE INDEX "SICAS_OC"."IDX_DET_TAB_CTRL_PAGO_COMIS" ON "SICAS_OC"."DETALLE_TABLERO_CTRL_PAGO" ("CODCIA", "COD_AGENTE", "IDNOMINA") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC" 
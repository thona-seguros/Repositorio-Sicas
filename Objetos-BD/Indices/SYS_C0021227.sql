
  CREATE UNIQUE INDEX "SICAS_OC"."SYS_C0021227" ON "SICAS_OC"."AGENTES_DISTRIBUCION_COMISION" ("CODCIA", "IDPOLIZA", "IDETPOL", "COD_AGENTE", "COD_AGENTE_DISTR") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC" 
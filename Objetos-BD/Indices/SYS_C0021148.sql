
  CREATE UNIQUE INDEX "SICAS_OC"."SYS_C0021148" ON "SICAS_OC"."COBERT_ACT_ASEG_1" ("CODEMPRESA", "CODCIA", "IDPOLIZA", "IDETPOL", "IDTIPOSEG", "TIPOREF", "NUMREF", "CODCOBERT", "COD_ASEGURADO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC" 
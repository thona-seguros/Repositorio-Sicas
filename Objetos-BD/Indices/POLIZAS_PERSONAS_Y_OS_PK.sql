
  CREATE UNIQUE INDEX "SICAS_OC"."POLIZAS_PERSONAS_Y_OS_PK" ON "SICAS_OC"."POLIZAS_PERSONAS_Y_OS" ("IDPOLIZA", "IDETPOL", "TIPO_DOC_IDENTIFICACION", "NUM_DOC_IDENTIFICACION", "NUM_CONSECUTIVO_YO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
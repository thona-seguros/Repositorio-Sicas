
  CREATE UNIQUE INDEX "SICAS_OC"."PK_FAI_BENEFICIARIOS_FONDO" ON "SICAS_OC"."FAI_BENEFICIARIOS_FONDO" ("CODCIA", "CODEMPRESA", "IDFONDO", "TIPO_DOC_IDENTIFICACION", "NUM_DOC_IDENTIFICACION", "NUMBENEF") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC" 
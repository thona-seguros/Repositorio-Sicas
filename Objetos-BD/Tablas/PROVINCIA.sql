
  CREATE TABLE "SICAS_OC"."PROVINCIA" 
   (	"CODPAIS" VARCHAR2(3) CONSTRAINT "SYS_C007187" NOT NULL ENABLE, 
	"CODESTADO" VARCHAR2(3) CONSTRAINT "SYS_C007188" NOT NULL ENABLE, 
	"DESCESTADO" VARCHAR2(50) CONSTRAINT "SYS_C007189" NOT NULL ENABLE, 
	"CODPROVALTERNO" VARCHAR2(3), 
	 PRIMARY KEY ("CODPAIS", "CODESTADO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE, 
	 FOREIGN KEY ("CODPAIS")
	  REFERENCES "SICAS_OC"."PAIS" ("CODPAIS") ON DELETE CASCADE ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
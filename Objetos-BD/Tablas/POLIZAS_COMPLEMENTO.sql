
  CREATE TABLE "SICAS_OC"."POLIZAS_COMPLEMENTO" 
   (	"CODCIA" NUMBER(14,0), 
	"CODEMPRESA" NUMBER(14,0), 
	"IDPOLIZA" NUMBER(14,0), 
	"INDFACTPERSONALIZADA" VARCHAR2(1), 
	"FORMAIMPRIMENOMBRE" VARCHAR2(1), 
	 CONSTRAINT "POLIZAS_COMPLEMENTO_PK" PRIMARY KEY ("CODCIA", "CODEMPRESA", "IDPOLIZA")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
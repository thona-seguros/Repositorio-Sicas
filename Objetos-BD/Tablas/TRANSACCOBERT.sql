
  CREATE TABLE "SICAS_OC"."TRANSACCOBERT" 
   (	"TRANIDTRANSACCION" NUMBER(18,0), 
	"FECHATRANSACCION" DATE, 
	"COBIDTRANSACCION" NUMBER(18,0), 
	"FECRES" DATE, 
	"IDSINIESTRO" NUMBER(14,0), 
	"IDPOLIZA" NUMBER(14,0), 
	"CODCOBERT" VARCHAR2(6), 
	"NUMMOD" NUMBER(2,0), 
	"INDV_COLECT" VARCHAR2(12), 
	 CONSTRAINT "TRANSACCOBERT_PK" PRIMARY KEY ("TRANIDTRANSACCION")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
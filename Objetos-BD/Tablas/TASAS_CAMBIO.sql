
  CREATE TABLE "SICAS_OC"."TASAS_CAMBIO" 
   (	"FECHA_HORA_CAMBIO" DATE CONSTRAINT "SYS_C007206" NOT NULL ENABLE, 
	"COD_MONEDA" VARCHAR2(5) CONSTRAINT "SYS_C007207" NOT NULL ENABLE, 
	"TASA_CAMBIO" NUMBER(18,8), 
	 PRIMARY KEY ("FECHA_HORA_CAMBIO", "COD_MONEDA")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 38797312 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE, 
	 FOREIGN KEY ("COD_MONEDA")
	  REFERENCES "SICAS_OC"."MONEDA" ("COD_MONEDA") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 38797312 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
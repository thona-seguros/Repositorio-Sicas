
  CREATE TABLE "SICAS_OC"."ENDOSOS_SEGUIMIENTO" 
   (	"IDPOLIZA" NUMBER(14,0) NOT NULL ENABLE, 
	"IDENDOSO" NUMBER(14,0) NOT NULL ENABLE, 
	"TIPOENDOSO" VARCHAR2(6), 
	"NUMENDREF" VARCHAR2(30), 
	"STSENDOSO" VARCHAR2(3), 
	"FECSTS" DATE, 
	"IDETPOL" NUMBER(14,0), 
	"USUARIO" VARCHAR2(50), 
	"TERMINAL" VARCHAR2(50), 
	"FECH_ALTA" DATE, 
	 CONSTRAINT "END_SEGUIM_PK" PRIMARY KEY ("IDPOLIZA", "IDENDOSO")
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
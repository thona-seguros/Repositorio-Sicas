
  CREATE TABLE "SICAS_OC"."CONFIG_TRANSAC_SINIESTROS" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODTRANSAC" VARCHAR2(6) NOT NULL ENABLE, 
	"DESCTRANSAC" VARCHAR2(100) NOT NULL ENABLE, 
	"INDAPLICTRANSAC" VARCHAR2(2) NOT NULL ENABLE, 
	"STSTRANSAC" VARCHAR2(6), 
	"FECSTS" DATE, 
	"CODPROCCONTABLE" VARCHAR2(6) NOT NULL ENABLE, 
	"CODUSUARIO" VARCHAR2(30), 
	"SIGNO" VARCHAR2(1), 
	"INDPAGO" VARCHAR2(1), 
	 CONSTRAINT "PK_CONFIG_TRANSAC_SINIESTROS" PRIMARY KEY ("CODCIA", "CODTRANSAC")
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
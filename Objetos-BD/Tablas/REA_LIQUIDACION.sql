
  CREATE TABLE "SICAS_OC"."REA_LIQUIDACION" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"IDLIQUIDACION" NUMBER(14,0) NOT NULL ENABLE, 
	"FECINILIQUIDA" DATE NOT NULL ENABLE, 
	"FECFINLIQUIDA" DATE NOT NULL ENABLE, 
	"IDTRANSACCION" NUMBER(14,0) NOT NULL ENABLE, 
	"STSLIQUIDA" VARCHAR2(6), 
	"FECSTATUS" DATE, 
	"CODUSUARIO" VARCHAR2(30), 
	"FECGENERADA" DATE, 
	"FECANULADA" DATE, 
	"FECCONTABILIZADA" DATE, 
	"IDTRANSACCIONCIERRE" NUMBER(14,0), 
	"FECCONTACIERRE" DATE, 
	 CONSTRAINT "PK_REA_LIQUIDACION" PRIMARY KEY ("CODCIA", "IDLIQUIDACION")
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
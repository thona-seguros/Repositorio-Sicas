
  CREATE TABLE "SICAS_OC"."FAI_CONFIG_TASAS_FONDOS" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODEMPRESA" NUMBER(14,0) NOT NULL ENABLE, 
	"TIPOFONDO" VARCHAR2(10) NOT NULL ENABLE, 
	"TIPOINTERES" VARCHAR2(10) NOT NULL ENABLE, 
	"FECINICONF" DATE, 
	"FECFINCONF" DATE, 
	"TIPOCONFIG" VARCHAR2(6), 
	"FACTORAJUSTE" NUMBER(28,6), 
	 CONSTRAINT "PK_FAI_CONFIG_TASAS_FONDOS" PRIMARY KEY ("CODCIA", "CODEMPRESA", "TIPOFONDO", "TIPOINTERES", "FECINICONF", "FECFINCONF", "TIPOCONFIG")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE, 
	 CONSTRAINT "FK_CONFIG_TASAS_INT_FONDOS" FOREIGN KEY ("CODCIA", "CODEMPRESA", "TIPOFONDO")
	  REFERENCES "SICAS_OC"."FAI_TIPOS_DE_FONDOS" ("CODCIA", "CODEMPRESA", "TIPOFONDO") ON DELETE CASCADE ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
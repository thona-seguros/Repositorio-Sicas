
  CREATE TABLE "SICAS_OC"."FAI_TIPOS_FONDOS_PRODUCTOS" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODEMPRESA" NUMBER(14,0) NOT NULL ENABLE, 
	"IDTIPOSEG" VARCHAR2(6) NOT NULL ENABLE, 
	"PLANCOB" VARCHAR2(15) NOT NULL ENABLE, 
	"TIPOFONDO" VARCHAR2(10) NOT NULL ENABLE, 
	"PORCFONDO" NUMBER(9,6) NOT NULL ENABLE, 
	"INDFONDOOBLIG" VARCHAR2(1), 
	"ORDENFONDO" NUMBER(5,0) DEFAULT 1, 
	 CONSTRAINT "PK_FAI_TIPOS_FONDOS_PRODUCTOS" PRIMARY KEY ("CODCIA", "CODEMPRESA", "IDTIPOSEG", "PLANCOB", "TIPOFONDO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE, 
	 CONSTRAINT "FK_FAI_TIPOS_FONDOS_PROD_EMP" FOREIGN KEY ("CODEMPRESA", "CODCIA")
	  REFERENCES "SICAS_OC"."EMPRESAS_DE_SEGUROS" ("CODEMPRESA", "CODCIA") ON DELETE CASCADE ENABLE, 
	 CONSTRAINT "FK_FAI_TIPOS_FONDOS_PLANCOB" FOREIGN KEY ("IDTIPOSEG", "CODEMPRESA", "CODCIA", "PLANCOB")
	  REFERENCES "SICAS_OC"."PLAN_COBERTURAS" ("IDTIPOSEG", "CODEMPRESA", "CODCIA", "PLANCOB") ON DELETE CASCADE ENABLE, 
	 CONSTRAINT "FK_FAI_TIPOS_FONDOS_CONFIG" FOREIGN KEY ("CODCIA", "CODEMPRESA", "TIPOFONDO")
	  REFERENCES "SICAS_OC"."FAI_TIPOS_DE_FONDOS" ("CODCIA", "CODEMPRESA", "TIPOFONDO") ON DELETE CASCADE ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
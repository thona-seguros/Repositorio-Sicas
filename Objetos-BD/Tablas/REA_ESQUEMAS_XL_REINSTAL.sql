
  CREATE TABLE "SICAS_OC"."REA_ESQUEMAS_XL_REINSTAL" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODESQUEMA" VARCHAR2(10) NOT NULL ENABLE, 
	"IDESQCONTRATO" NUMBER(14,0) NOT NULL ENABLE, 
	"IDCAPACONTRATO" NUMBER(5,0) NOT NULL ENABLE, 
	"CODEMPRESAGREMIO" VARCHAR2(10) NOT NULL ENABLE, 
	"IDREINSTALAMENTO" NUMBER(10,0), 
	"PORCREINSTAL" NUMBER(14,6), 
	"STSREINSTAL" VARCHAR2(10), 
	"FECSTATUS" DATE, 
	"CODINTERREASEG" VARCHAR2(10) DEFAULT NULL NOT NULL ENABLE, 
	 CONSTRAINT "PK_REA_ESQUEMAS_XL_REINSTAL" PRIMARY KEY ("CODCIA", "CODESQUEMA", "IDESQCONTRATO", "IDCAPACONTRATO", "CODEMPRESAGREMIO", "CODINTERREASEG", "IDREINSTALAMENTO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE, 
	 CONSTRAINT "FK_REA_ESQUEMAS_XL_REINSTAL" FOREIGN KEY ("CODCIA", "CODESQUEMA", "IDESQCONTRATO", "IDCAPACONTRATO", "CODEMPRESAGREMIO", "CODINTERREASEG")
	  REFERENCES "SICAS_OC"."REA_ESQUEMAS_XL" ("CODCIA", "CODESQUEMA", "IDESQCONTRATO", "IDCAPACONTRATO", "CODEMPRESAGREMIO", "CODINTERREASEG") ON DELETE CASCADE ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
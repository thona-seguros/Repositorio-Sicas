
  CREATE TABLE "SICAS_OC"."REA_TARIFAS_REASEGURO_DET" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODTARIFAREASEG" VARCHAR2(30) NOT NULL ENABLE, 
	"CODGRUPOCOBERT" VARCHAR2(10) NOT NULL ENABLE, 
	"EDADINICIAL" NUMBER(5,0) NOT NULL ENABLE, 
	"EDADFINAL" NUMBER(5,0) NOT NULL ENABLE, 
	"FACTORTARIFA" NUMBER(12,6), 
	"CODUSUARIO" VARCHAR2(30), 
	"FECULTMODIF" DATE, 
	"CODEMPRESAGREMIO" VARCHAR2(10), 
	 CONSTRAINT "PK_REA_TARIFAS_REASEGURO_DET" PRIMARY KEY ("CODCIA", "CODTARIFAREASEG", "CODGRUPOCOBERT", "EDADINICIAL", "EDADFINAL", "CODEMPRESAGREMIO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE, 
	 CONSTRAINT "FK_REA_TARIFAS_REASEG_DET" FOREIGN KEY ("CODCIA", "CODTARIFAREASEG")
	  REFERENCES "SICAS_OC"."REA_TARIFAS_REASEGURO" ("CODCIA", "CODTARIFAREASEG") ON DELETE CASCADE ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
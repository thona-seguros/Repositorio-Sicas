
  CREATE TABLE "SICAS_OC"."FAI_DESCANSO_APORTACIONES" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODEMPRESA" NUMBER(14,0) NOT NULL ENABLE, 
	"IDPOLIZA" NUMBER(14,0) NOT NULL ENABLE, 
	"IDETPOL" NUMBER(14,0) NOT NULL ENABLE, 
	"CODASEGURADO" NUMBER(14,0) NOT NULL ENABLE, 
	"NUMPERIODODESC" NUMBER(5,0) NOT NULL ENABLE, 
	"FECINIDESCANSO" DATE NOT NULL ENABLE, 
	"FECFINDESCANSO" DATE NOT NULL ENABLE, 
	"STSPERDESCANSO" VARCHAR2(6) NOT NULL ENABLE, 
	"FECSTATUS" DATE, 
	"CODUSUARIO" VARCHAR2(30), 
	"OBSERVACIONES" VARCHAR2(4000), 
	 CONSTRAINT "PK_FAI_DESCANSO_APORTACIONES" PRIMARY KEY ("CODCIA", "CODEMPRESA", "IDPOLIZA", "IDETPOL", "CODASEGURADO", "NUMPERIODODESC")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
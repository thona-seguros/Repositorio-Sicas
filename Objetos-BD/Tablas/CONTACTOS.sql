
  CREATE TABLE "SICAS_OC"."CONTACTOS" 
   (	"CODEMPRESA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CORR_CONTACTO" NUMBER(14,0) NOT NULL ENABLE, 
	"CONTACTO" VARCHAR2(200), 
	"DEPARTAMENTO" VARCHAR2(75), 
	"TELCONTACTO" VARCHAR2(30), 
	"FAXCONTACTO" VARCHAR2(20), 
	"EMAIL" VARCHAR2(150), 
	"PUESTO" VARCHAR2(6), 
	 CONSTRAINT "PK_CONTACTOS" PRIMARY KEY ("CODEMPRESA", "CODCIA", "CORR_CONTACTO")
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

  CREATE TABLE "SICAS_OC"."AGENTES_DETALLES_POLIZAS" 
   (	"IDPOLIZA" NUMBER(14,0) NOT NULL ENABLE, 
	"IDETPOL" NUMBER(14,0) NOT NULL ENABLE, 
	"IDTIPOSEG" VARCHAR2(6) NOT NULL ENABLE, 
	"COD_AGENTE" NUMBER(18,0) NOT NULL ENABLE, 
	"PORC_COMISION" NUMBER(9,6), 
	"IND_PRINCIPAL" VARCHAR2(1), 
	"CODCIA" NUMBER(14,0), 
	"ORIGEN" VARCHAR2(1), 
	 CONSTRAINT "PK_AGENTES_DETALLES_POLIZAS" PRIMARY KEY ("IDPOLIZA", "IDETPOL", "IDTIPOSEG", "COD_AGENTE")
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
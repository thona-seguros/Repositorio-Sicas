
  CREATE TABLE "SICAS_OC"."CLAUSULAS_POLIZA" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"IDPOLIZA" NUMBER(14,0) NOT NULL ENABLE, 
	"COD_CLAUSULA" NUMBER(15,0) NOT NULL ENABLE, 
	"TIPO_CLAUSULA" VARCHAR2(6), 
	"TEXTO" LONG, 
	"INICIO_VIGENCIA" DATE, 
	"FIN_VIGENCIA" DATE, 
	"ESTADO" VARCHAR2(6), 
	 PRIMARY KEY ("CODCIA", "IDPOLIZA", "COD_CLAUSULA")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE, 
	 FOREIGN KEY ("CODCIA", "IDPOLIZA")
	  REFERENCES "SICAS_OC"."POLIZAS" ("CODCIA", "IDPOLIZA") ON DELETE CASCADE ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
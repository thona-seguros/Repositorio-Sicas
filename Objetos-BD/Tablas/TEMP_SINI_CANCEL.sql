
  CREATE TABLE "SICAS_OC"."TEMP_SINI_CANCEL" 
   (	"IDSINIESTRO" NUMBER, 
	"IDDETSIN" NUMBER, 
	"IDPOLIZA" NUMBER, 
	"COD_ASEGURADO" NUMBER, 
	"NUM_APROBACION" NUMBER, 
	"TIPOAPROBACION" VARCHAR2(1), 
	"MONTOPROCESADO" NUMBER(28,2), 
	"PROCESO" VARCHAR2(20), 
	"STSPROCESO" VARCHAR2(10), 
	"CODCOBERT" VARCHAR2(20), 
	"CODTRANSAC" VARCHAR2(20), 
	"FECHAMOVIMIENTO" DATE, 
	"ST_PROCESO" VARCHAR2(2)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
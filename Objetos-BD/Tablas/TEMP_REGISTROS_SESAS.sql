
  CREATE TABLE "SICAS_OC"."TEMP_REGISTROS_SESAS" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODSESA" VARCHAR2(30) NOT NULL ENABLE, 
	"CODUSUARIO" VARCHAR2(30) NOT NULL ENABLE, 
	"REGISTROSESA" VARCHAR2(4000)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
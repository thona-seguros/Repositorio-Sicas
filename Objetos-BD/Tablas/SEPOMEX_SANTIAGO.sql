
  CREATE TABLE "SICAS_OC"."SEPOMEX_SANTIAGO" 
   (	"EDO_CVE" NUMBER(2,0), 
	"DEL_CVE" NUMBER(3,0), 
	"CONS" NUMBER(4,0), 
	"ESTADO" VARCHAR2(200), 
	"DELEGACION" VARCHAR2(200), 
	"COLONIA" VARCHAR2(200), 
	"CP" NUMBER(5,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
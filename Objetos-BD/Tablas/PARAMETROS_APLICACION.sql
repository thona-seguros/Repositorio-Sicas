
  CREATE TABLE "SICAS_OC"."PARAMETROS_APLICACION" 
   (	"CODAPLICA" VARCHAR2(8) CONSTRAINT "SYS_C0033753" NOT NULL ENABLE, 
	"IDPARAM" NUMBER(3,0) CONSTRAINT "SYS_C0033754" NOT NULL ENABLE, 
	"TIPOPARAM" VARCHAR2(1), 
	"NOMPARAM" VARCHAR2(50), 
	"VALORPARAM" VARCHAR2(50)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
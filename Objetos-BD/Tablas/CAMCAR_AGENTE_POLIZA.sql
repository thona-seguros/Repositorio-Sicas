
  CREATE TABLE "SICAS_OC"."CAMCAR_AGENTE_POLIZA" 
   (	"CODCIA" NUMBER(14,0), 
	"CODEMPRESA" NUMBER(14,0), 
	"IDPOLIZA" NUMBER(14,0), 
	"COD_AGENTE" NUMBER(18,0), 
	"PORC_COMISION" NUMBER(9,6), 
	"IND_PRINCIPAL" VARCHAR2(1), 
	"ORIGEN" VARCHAR2(10), 
	"ID_TP_AGENTES" VARCHAR2(3), 
	"FE_CAMBIO" DATE, 
	"HR_CAMBIO" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
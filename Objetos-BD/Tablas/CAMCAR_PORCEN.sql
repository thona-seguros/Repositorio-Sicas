
  CREATE TABLE "SICAS_OC"."CAMCAR_PORCEN" 
   (	"CODCIA" NUMBER(14,0), 
	"CODEMPRESA" NUMBER(14,0), 
	"IDPOLIZA" NUMBER(14,0), 
	"COD_AGENTE" NUMBER(18,0), 
	"CODNIVEL" NUMBER(10,0), 
	"COD_AGENTE_DISTR" NUMBER(18,0), 
	"PORC_COMISION_AGENTE" NUMBER(9,6), 
	"PORC_COM_DISTRIBUIDA" NUMBER(9,6), 
	"PORC_COMISION_PLAN" NUMBER(9,6), 
	"PORC_COM_PROPORCIONAL" NUMBER(9,6), 
	"COD_AGENTE_JEFE" NUMBER(18,0), 
	"PORC_COM_POLIZA" NUMBER(9,6), 
	"ORIGEN" VARCHAR2(1), 
	"ID_TP_AGENTES" VARCHAR2(3), 
	"FE_CAMBIO" DATE, 
	"HR_CAMBIO" DATE, 
	"ID_A�O" NUMBER(5,0), 
	"TP_MOVTO" VARCHAR2(6) DEFAULT 'CAMCAR'
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
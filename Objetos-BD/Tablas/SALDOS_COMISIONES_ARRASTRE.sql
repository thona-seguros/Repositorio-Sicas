
  CREATE TABLE "SICAS_OC"."SALDOS_COMISIONES_ARRASTRE" 
   (	"CD_CIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CD_AGENTE" NUMBER(18,0) NOT NULL ENABLE, 
	"CD_TIPO_RAMO" VARCHAR2(30), 
	"FE_INI_SALDO" DATE, 
	"FE_FIN_SALDO" DATE, 
	"FE_PROC_SALDO" DATE, 
	"CD_MONEDA" VARCHAR2(5) NOT NULL ENABLE, 
	"MT_SALDO_INICIAL" NUMBER(18,2), 
	"MT_SALDO_FINAL" NUMBER(18,2), 
	"DS_OBSERVACION" VARCHAR2(300)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
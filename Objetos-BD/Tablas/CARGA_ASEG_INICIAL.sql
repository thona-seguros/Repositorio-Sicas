
  CREATE TABLE "SICAS_OC"."CARGA_ASEG_INICIAL" 
   (	"CODCIA" NUMBER(5,0), 
	"PROCESO" NUMBER(5,0), 
	"USUARIO_REGISTRO" VARCHAR2(30), 
	"FECHA_REGISTRO" DATE, 
	"ID_PROCESADO" VARCHAR2(2), 
	"CAMPO_GENERICO" VARCHAR2(4000)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
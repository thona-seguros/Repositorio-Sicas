
  CREATE TABLE "SICAS_OC"."RENO_CTRL" 
   (	"ID_CODCIA" NUMBER(14,0), 
	"NU_REMESA" VARCHAR2(15), 
	"ID_POLIZA" NUMBER(14,0), 
	"ID_DETPOL" NUMBER(14,0), 
	"NUMPOLUNICO" VARCHAR2(30), 
	"IDTIPOSEG" VARCHAR2(6), 
	"FE_RENOVACION" DATE, 
	"ID_POLIZA_REN" NUMBER(14,0), 
	"ID_DETPOL_REN" NUMBER(14,0), 
	"FE_RENOVACION_REN" DATE, 
	"ST_RENOVA" VARCHAR2(6), 
	"FE_CARGA" DATE, 
	"FE_PROCESO" DATE, 
	"USUARIO_PROCESO" VARCHAR2(15), 
	"PLDSTBLOQUEADA" VARCHAR2(2), 
	"PLDSTAPROBADA" VARCHAR2(2), 
	"PLDUSUARIOAPROB" VARCHAR2(15)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 

  CREATE TABLE "SICAS_OC"."PARAM_PROCESOS_MASIVOS" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODEMPRESA" NUMBER(14,0) NOT NULL ENABLE, 
	"TIPOPROCESO" VARCHAR2(30) NOT NULL ENABLE, 
	"STSPROCESO" VARCHAR2(6) NOT NULL ENABLE, 
	"FECSTS" DATE NOT NULL ENABLE, 
	"NOM_JOB" VARCHAR2(100), 
	"FECHA_INICIO" DATE, 
	"REPETIR" VARCHAR2(100), 
	"NOMBRE_PROCESO" VARCHAR2(100), 
	"FRECUENCIA" VARCHAR2(100), 
	 CONSTRAINT "PK_PARAM_PROCESOS_MASIVOS" PRIMARY KEY ("CODCIA", "CODEMPRESA", "TIPOPROCESO", "NOM_JOB")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
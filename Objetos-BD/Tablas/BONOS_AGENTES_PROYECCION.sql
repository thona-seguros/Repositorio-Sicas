
  CREATE TABLE "SICAS_OC"."BONOS_AGENTES_PROYECCION" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODEMPRESA" NUMBER(14,0) NOT NULL ENABLE, 
	"IDCALCULOPROY" NUMBER(14,0) NOT NULL ENABLE, 
	"IDBONOVENTAS" NUMBER(14,0) NOT NULL ENABLE, 
	"CODNIVEL" NUMBER(10,0) NOT NULL ENABLE, 
	"CODAGENTE" VARCHAR2(18) NOT NULL ENABLE, 
	"FECINICALCBONO" DATE NOT NULL ENABLE, 
	"FECFINCALCBONO" DATE NOT NULL ENABLE, 
	"PRODPRIMANETA" NUMBER(28,2), 
	"CANTPOLIZAS" NUMBER(10,0), 
	"MESESPROD" NUMBER(10,0), 
	"CANTAGENTESPROD" NUMBER(10,0), 
	"PORCENSINIEST" NUMBER(12,6), 
	"PORCENBONOACTUAL" NUMBER(12,6), 
	"MONTONIVEL1" NUMBER(28,2), 
	"PORCENNIVEL1" NUMBER(12,6), 
	"MONTONIVEL2" NUMBER(28,2), 
	"PORCENNIVEL2" NUMBER(12,6), 
	"MONTONIVEL3" NUMBER(28,2), 
	"PORCENNIVEL3" NUMBER(12,6), 
	"MONTONIVEL4" NUMBER(28,2), 
	"PORCENNIVEL4" NUMBER(12,6), 
	"MONTONIVELSUP" NUMBER(28,2), 
	"PORCENNIVELSUP" NUMBER(12,6), 
	"FECCALCULOPROY" DATE, 
	"CODUSUARIO" VARCHAR2(30), 
	 CONSTRAINT "PK_BONOS_AGENTES_PROYECCION" PRIMARY KEY ("CODCIA", "CODEMPRESA", "IDCALCULOPROY", "IDBONOVENTAS", "CODNIVEL", "CODAGENTE", "FECINICALCBONO", "FECFINCALCBONO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
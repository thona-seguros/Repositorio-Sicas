
  CREATE TABLE "SICAS_OC"."DISPERSION" 
   (	"IDDISPERSION" NUMBER(14,0) NOT NULL ENABLE, 
	"IDSINIESTRO" NUMBER(14,0) NOT NULL ENABLE, 
	"NUM_APROBACION" NUMBER(14,0) NOT NULL ENABLE, 
	"BENEF" NUMBER(10,0) NOT NULL ENABLE, 
	"NOMASEGURADO" VARCHAR2(200), 
	"CODENTFINAN" VARCHAR2(6), 
	"NOMBANCO" VARCHAR2(100), 
	"CUENTACLABE" VARCHAR2(50), 
	"MONTODISPERSION" NUMBER(28,2), 
	"NOMBENEFPAGO" VARCHAR2(200), 
	"IDETPOL" NUMBER(14,0), 
	"OBSERVACION" VARCHAR2(300), 
	"ESTADO" VARCHAR2(3), 
	"FECSTS" DATE, 
	 CONSTRAINT "PK_DISPERSION" PRIMARY KEY ("IDDISPERSION", "IDSINIESTRO", "NUM_APROBACION", "BENEF")
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
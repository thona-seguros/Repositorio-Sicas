
  CREATE TABLE "SICAS_OC"."FZ_CONTRATO" 
   (	"CODCONTRATO" VARCHAR2(50) NOT NULL ENABLE, 
	"COD_MONEDA" VARCHAR2(5) NOT NULL ENABLE, 
	"NUMREF" VARCHAR2(100), 
	"CODBENEFICIARIOFZ" NUMBER(10,0) NOT NULL ENABLE, 
	"INICIO" DATE, 
	"FINAL" DATE, 
	"MONTO_LOCAL" NUMBER(18,2), 
	"MONTO_MONEDA" NUMBER(18,2), 
	"OBJETO" LONG, 
	"CODPAIS" VARCHAR2(3), 
	"CODESTADO" VARCHAR2(3), 
	"CODCIUDAD" VARCHAR2(3), 
	"CODMUNICIPIO" VARCHAR2(3), 
	"ESTADO" VARCHAR2(3), 
	"CODPROYECTO" VARCHAR2(50), 
	 PRIMARY KEY ("CODCONTRATO")
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
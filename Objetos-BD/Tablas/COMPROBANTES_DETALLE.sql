
  CREATE TABLE "SICAS_OC"."COMPROBANTES_DETALLE" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"NUMCOMPROB" NUMBER(28,0) NOT NULL ENABLE, 
	"IDDETCUENTA" NUMBER(14,0) NOT NULL ENABLE, 
	"FECDETALLE" DATE, 
	"NIVELCTA1" VARCHAR2(1), 
	"NIVELCTA2" VARCHAR2(1), 
	"NIVELCTA3" VARCHAR2(2), 
	"NIVELCTA4" VARCHAR2(2), 
	"NIVELCTA5" VARCHAR2(3), 
	"NIVELCTA6" VARCHAR2(1), 
	"NIVELCTA7" VARCHAR2(3), 
	"NIVELAUX" VARCHAR2(5), 
	"MOVDEBCRED" VARCHAR2(1), 
	"MTOMOVCUENTA" NUMBER(28,2), 
	"DESCMOVCUENTA" VARCHAR2(3000), 
	"CODCENTROCOSTO" VARCHAR2(40), 
	"CODUNIDADNEGOCIO" VARCHAR2(40), 
	"DESCCPTOGENERAL" VARCHAR2(64), 
	"MTOMOVCUENTALOCAL" NUMBER(28,2), 
	 CONSTRAINT "PK_COMPROBANTES_DETALLE" PRIMARY KEY ("CODCIA", "NUMCOMPROB", "IDDETCUENTA")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE, 
	 CONSTRAINT "RF_COMPROBANTES_DET_COMPROB" FOREIGN KEY ("CODCIA", "NUMCOMPROB")
	  REFERENCES "SICAS_OC"."COMPROBANTES_CONTABLES" ("CODCIA", "NUMCOMPROB") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 262144 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
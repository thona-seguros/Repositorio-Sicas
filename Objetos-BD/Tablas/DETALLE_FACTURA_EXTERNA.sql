
  CREATE TABLE "SICAS_OC"."DETALLE_FACTURA_EXTERNA" 
   (	"IDEFACTEXT" NUMBER(14,0) NOT NULL ENABLE, 
	"NUMFACTEXT" VARCHAR2(20) NOT NULL ENABLE, 
	"RFCPROVATIENDE" VARCHAR2(20), 
	"NOMPROVATIENDE" VARCHAR2(200), 
	"REGIMENFIS" VARCHAR2(70), 
	"RFCBENEFPAGO" VARCHAR2(20), 
	"NOMBENEFPAGO" VARCHAR2(200), 
	"MTOGTOHONORARIO" NUMBER(18,2), 
	"MTOGTOHOSPITAL" NUMBER(18,2), 
	"MTOOTROGASTO" NUMBER(18,2), 
	"MTODESCUENTO" NUMBER(18,2), 
	"MTODEDUCIBLE" NUMBER(18,2), 
	"MTOIVA" NUMBER(18,2), 
	"MTOISR" NUMBER(18,2), 
	"MTOIVARET" NUMBER(18,2), 
	"MTOIMPCEDULAR" NUMBER(18,2), 
	"MTOTOTAL" NUMBER(28,2), 
	"FECFACTEXT" DATE, 
	"CODUSUARIO" VARCHAR2(30), 
	 CONSTRAINT "PK_DET_FACTURA_EXTERNA" PRIMARY KEY ("IDEFACTEXT", "NUMFACTEXT")
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
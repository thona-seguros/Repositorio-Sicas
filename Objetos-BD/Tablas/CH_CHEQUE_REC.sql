
  CREATE TABLE "SICAS_OC"."CH_CHEQUE_REC" 
   (	"IDPOLIZA" NUMBER(14,0), 
	"COD_MONEDA" VARCHAR2(5) NOT NULL ENABLE, 
	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODEMPRESA" NUMBER(14,0) NOT NULL ENABLE, 
	"IDCHQREC" NUMBER(10,0) NOT NULL ENABLE, 
	"NUMDOC" VARCHAR2(20) NOT NULL ENABLE, 
	"FECRECHAZO" DATE, 
	"FECRECUPERADO" DATE, 
	"NOTIFICADO" VARCHAR2(200), 
	"ULTFECEESTADO" DATE, 
	"USUARIOULTESTADO" VARCHAR2(30), 
	"USUARIOGRABAREC" VARCHAR2(30), 
	"BANCO" VARCHAR2(200), 
	"MONTO" NUMBER(14,2), 
	"ESTADO" VARCHAR2(6), 
	"OBSERVA" VARCHAR2(300), 
	"IDTIPOSEG" VARCHAR2(6), 
	"MOT_RECHAZO" VARCHAR2(6), 
	"CODENTFINAN" VARCHAR2(6), 
	 PRIMARY KEY ("IDCHQREC")
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

  CREATE TABLE "SICAS_OC"."TMP_DOCUMENTO_POLIZA" 
   (	"ID_DOCUMENTO_POLIZA" NUMBER(22,0) NOT NULL ENABLE, 
	"ID_DOCUMENTO" NUMBER(22,0) NOT NULL ENABLE, 
	"ID_POLIZA" NUMBER(14,0) NOT NULL ENABLE, 
	"DESCRIPCION" VARCHAR2(100) NOT NULL ENABLE, 
	"TEXTO" VARCHAR2(1000) NOT NULL ENABLE, 
	"PATHIMAGEN" VARCHAR2(100), 
	"PATHFIRMA" VARCHAR2(100), 
	"DESCFIRMA" VARCHAR2(300), 
	"SESION" NUMBER(22,0), 
	 CONSTRAINT "PK_TMP_DOCUMENTO_POLIZA" PRIMARY KEY ("ID_DOCUMENTO_POLIZA")
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

  CREATE TABLE "SICAS_OC"."FACTURA_EXTERNA" 
   (	"IDEFACTEXT" NUMBER(14,0) NOT NULL ENABLE, 
	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"IDNCR" NUMBER(14,0) NOT NULL ENABLE, 
	"NUM_APROBACION" NUMBER(14,0), 
	"TIPO_DOC_IDENTIFICACION" VARCHAR2(6) NOT NULL ENABLE, 
	"NUM_DOC_IDENTIFICACION" VARCHAR2(20) NOT NULL ENABLE, 
	"CODUSUARIO" VARCHAR2(30), 
	"NUMFACTEXT" VARCHAR2(20) NOT NULL ENABLE, 
	"FECFACTEXT" DATE, 
	"MTOTOTFACTEXT" NUMBER(14,2), 
	"TIPOFACTEXT" VARCHAR2(2), 
	"FECRECEPCION" DATE, 
	"OBSERVACIONES" VARCHAR2(2000), 
	"FECSTSFACTEXT" DATE, 
	"STSFACTEXT" VARCHAR2(6), 
	"IDSINIESTRO" NUMBER(14,0), 
	"IVA" NUMBER(18,2), 
	"UUID" VARCHAR2(40) DEFAULT 'eeeeeeee-0000-eeee-0000-eeeeee000000' NOT NULL ENABLE, 
	"INDPREVFIS" VARCHAR2(1) DEFAULT 'N', 
	"COD_AGENTE" NUMBER(18,0), 
	 CONSTRAINT "PK_FACTURA_EXTERNA" PRIMARY KEY ("IDEFACTEXT", "TIPO_DOC_IDENTIFICACION", "NUM_DOC_IDENTIFICACION", "UUID")
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

  CREATE TABLE "SICAS_OC"."RESPONSABLE_PAGO_DET" 
   (	"IDPOLIZA" NUMBER(14,0), 
	"TIPO_DOC_IDENTIFICACION" VARCHAR2(6) NOT NULL ENABLE, 
	"NUM_DOC_IDENTIFICACION" VARCHAR2(20) NOT NULL ENABLE, 
	"IDETPOL" NUMBER(14,0) NOT NULL ENABLE, 
	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODRESPAGO" NUMBER(5,0) NOT NULL ENABLE, 
	"FECALTA" DATE, 
	"FECBAJA" DATE, 
	"STSRESPAGO" VARCHAR2(3), 
	"PORCRESPAGO" NUMBER(9,6), 
	"CODEMPRESA" NUMBER(14,0) NOT NULL ENABLE, 
	 PRIMARY KEY ("IDPOLIZA", "IDETPOL", "CODCIA", "CODRESPAGO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE, 
	 FOREIGN KEY ("TIPO_DOC_IDENTIFICACION", "NUM_DOC_IDENTIFICACION")
	  REFERENCES "SICAS_OC"."PERSONA_NATURAL_JURIDICA" ("TIPO_DOC_IDENTIFICACION", "NUM_DOC_IDENTIFICACION") ENABLE, 
	 FOREIGN KEY ("IDPOLIZA", "IDETPOL", "CODCIA")
	  REFERENCES "SICAS_OC"."DETALLE_POLIZA" ("IDPOLIZA", "IDETPOL", "CODCIA") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 

  CREATE TABLE "SICAS_OC"."MEDICO_HOSPITAL" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODMEDICO" NUMBER(10,0) NOT NULL ENABLE, 
	"TIPODOCIDENTHOSP" VARCHAR2(6) NOT NULL ENABLE, 
	"NUMDOCIDENTHOSP" VARCHAR2(20) NOT NULL ENABLE, 
	"INDHOSPITALPRIMARIO" VARCHAR2(1) DEFAULT 'N', 
	"FECINGRESO" DATE, 
	"STSHOSPITAL" VARCHAR2(10), 
	"FECSTS" DATE, 
	 CONSTRAINT "PK_MEDICO_HOSPITAL" PRIMARY KEY ("CODCIA", "CODMEDICO", "TIPODOCIDENTHOSP", "NUMDOCIDENTHOSP")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE, 
	 CONSTRAINT "FK_MEDICO_HOSPITAL" FOREIGN KEY ("CODCIA", "CODMEDICO")
	  REFERENCES "SICAS_OC"."MEDICO" ("CODCIA", "CODMEDICO") ON DELETE CASCADE ENABLE, 
	 CONSTRAINT "FK_MED_HOSP_PNJ" FOREIGN KEY ("TIPODOCIDENTHOSP", "NUMDOCIDENTHOSP")
	  REFERENCES "SICAS_OC"."PERSONA_NATURAL_JURIDICA" ("TIPO_DOC_IDENTIFICACION", "NUM_DOC_IDENTIFICACION") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 

  CREATE TABLE "SICAS_OC"."REPORTE_PARAMETRO" 
   (	"IDPARAMETRO" NUMBER(14,0) NOT NULL ENABLE, 
	"IDREPORTE" NUMBER(14,0) NOT NULL ENABLE, 
	"NUMORDEN" NUMBER(3,0) NOT NULL ENABLE, 
	"NOM_PARAM" VARCHAR2(50), 
	"TIPO_PARAM" VARCHAR2(7), 
	"DESC_PARAM" VARCHAR2(30), 
	"VALINI_PARAM" VARCHAR2(50), 
	"LISTVAL_PARAM" VARCHAR2(2000), 
	 CONSTRAINT "PK_REPORTEPARAMETRO" PRIMARY KEY ("IDPARAMETRO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE, 
	 CONSTRAINT "CHK_PARAMETRO_TIPO" CHECK (TIPO_PARAM IN ('NUMBER','DATE','VARCHAR')
) ENABLE, 
	 CONSTRAINT "UK_REPORTEPARAMETRO" UNIQUE ("IDREPORTE", "NUMORDEN")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE, 
	 CONSTRAINT "FK_PARAMETRO_REPORTE" FOREIGN KEY ("IDREPORTE")
	  REFERENCES "SICAS_OC"."REPORTE" ("IDREPORTE") ON DELETE CASCADE ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
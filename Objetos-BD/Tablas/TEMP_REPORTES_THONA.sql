
  CREATE TABLE "SICAS_OC"."TEMP_REPORTES_THONA" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODEMPRESA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODREPORTE" VARCHAR2(30) NOT NULL ENABLE, 
	"CODUSUARIO" VARCHAR2(30) NOT NULL ENABLE, 
	"IDSECUENCIA" NUMBER NOT NULL ENABLE, 
	"LINEA" VARCHAR2(4000), 
	 CONSTRAINT "TEMP_REPORTES_THONA_PK" PRIMARY KEY ("CODCIA", "CODEMPRESA", "CODREPORTE", "CODUSUARIO", "IDSECUENCIA")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
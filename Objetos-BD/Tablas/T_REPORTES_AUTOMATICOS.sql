
  CREATE TABLE "SICAS_OC"."T_REPORTES_AUTOMATICOS" 
   (	"CODCIA" NUMBER(14,0), 
	"CODEMPRESA" NUMBER(14,0), 
	"NOMBRE_REPORTE" VARCHAR2(30), 
	"FECHA_PROCESO" DATE, 
	"NUMERO_REGISTRO" NUMBER(18,0), 
	"CODPLANTILLA" VARCHAR2(20), 
	"NOMBRE_ARCHIVO_EXCEL" VARCHAR2(50), 
	"CAMPO" CLOB, 
	"ID_ENVIO" NUMBER DEFAULT 0, 
	 CONSTRAINT "T_REPORTES_AUTOMATICOS_PK" PRIMARY KEY ("CODCIA", "CODEMPRESA", "ID_ENVIO", "NOMBRE_REPORTE", "FECHA_PROCESO", "NUMERO_REGISTRO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
 LOB ("CAMPO") STORE AS BASICFILE (
  TABLESPACE "TS_SICASOC" ENABLE STORAGE IN ROW CHUNK 8192 RETENTION 
  NOCACHE LOGGING 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) 
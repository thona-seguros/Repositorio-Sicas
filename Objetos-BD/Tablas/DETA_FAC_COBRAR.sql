
  CREATE TABLE "SICAS_OC"."DETA_FAC_COBRAR" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"IDFACOBRAR" NUMBER NOT NULL ENABLE, 
	"IDFACTURA" NUMBER(14,0) NOT NULL ENABLE, 
	"MONTO_LOCAL" NUMBER(14,0) NOT NULL ENABLE, 
	"COD_MONEDA" VARCHAR2(5) NOT NULL ENABLE, 
	"TIPO_DOCUMENTO" VARCHAR2(2) NOT NULL ENABLE, 
	"ORIGEN_DOCUMENTO" VARCHAR2(3) NOT NULL ENABLE, 
	"DATOS_INCOMPLETOS" VARCHAR2(1) NOT NULL ENABLE, 
	"STSDETPROV" VARCHAR2(3) NOT NULL ENABLE, 
	 CONSTRAINT "PK_DETA_FAC_COBRAR" PRIMARY KEY ("CODCIA", "IDFACOBRAR", "IDFACTURA")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE, 
	 CONSTRAINT "FK_DETA_ENCA_FAC_COBRAR" FOREIGN KEY ("CODCIA", "IDFACOBRAR")
	  REFERENCES "SICAS_OC"."ENCA_FAC_COBRAR" ("CODCIA", "IDFACOBRAR") ENABLE, 
	 CONSTRAINT "FK_DETA_FAC_COBRAR" FOREIGN KEY ("COD_MONEDA")
	  REFERENCES "SICAS_OC"."MONEDA" ("COD_MONEDA") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
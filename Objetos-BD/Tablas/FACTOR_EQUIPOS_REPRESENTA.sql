
  CREATE TABLE "SICAS_OC"."FACTOR_EQUIPOS_REPRESENTA" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODEMPRESA" NUMBER(14,0) NOT NULL ENABLE, 
	"IDTIPOSEG" VARCHAR2(6) NOT NULL ENABLE, 
	"PLANCOB" VARCHAR2(15) NOT NULL ENABLE, 
	"CODPAQUETE" NUMBER(14,0) NOT NULL ENABLE, 
	"CODEQUIPO" VARCHAR2(10) NOT NULL ENABLE, 
	"INDINCLUIDO" VARCHAR2(1) NOT NULL ENABLE, 
	"FACTOR" NUMBER(9,6) NOT NULL ENABLE, 
	"TEXTOFACTOR" VARCHAR2(4000), 
	"ACTUALIZO_USUARIO" VARCHAR2(30 CHAR) DEFAULT USER, 
	"ACTUALIZO_FECHA" DATE DEFAULT sysdate, 
	 CONSTRAINT "FACTOR_EQUIPOS_REPRESENTA_PK" PRIMARY KEY ("CODCIA", "CODEMPRESA", "IDTIPOSEG", "PLANCOB", "CODPAQUETE", "CODEQUIPO")
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

  CREATE TABLE "SICAS_OC"."TAREA" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"IDTAREA" NUMBER(10,0) NOT NULL ENABLE, 
	"CODUSUARIO" VARCHAR2(30) NOT NULL ENABLE, 
	"TIPOTAREA" VARCHAR2(6), 
	"SUBTIPOTAREA" VARCHAR2(6), 
	"NOMBRETAREA" VARCHAR2(100), 
	"FECHAASIGANCION" DATE, 
	"USUARIOASIGNO" VARCHAR2(30), 
	"USUARIOASIGNADO" VARCHAR2(30), 
	"FECHADEREALIZADO" DATE, 
	"USUARIOREALIZO" VARCHAR2(30), 
	"DESCRIPCION" LONG, 
	"IDPOLIZA" NUMBER(14,0), 
	"IDSINIESTRO" NUMBER(14,0), 
	"ESTADO_INICIAL" VARCHAR2(6), 
	"ESTADO_FINAL" VARCHAR2(6), 
	"CODCLIENTE" NUMBER(14,0), 
	"ESTADO" VARCHAR2(6), 
	"FECHAGRABA" DATE, 
	"FECHAESPERADA" DATE, 
	"FECREASEG" DATE, 
	"NUMTARREASEG" NUMBER(10,0), 
	"IDPROCESO" NUMBER(10,0), 
	"CODSUBPROCESO" VARCHAR2(6), 
	 PRIMARY KEY ("CODCIA", "IDTAREA")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 131072 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
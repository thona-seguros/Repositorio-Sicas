
  CREATE TABLE "SICAS_OC"."DOMICILIACION" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"IDPROCESO" NUMBER NOT NULL ENABLE, 
	"USUARIOCREA" VARCHAR2(30), 
	"FECHACREA" DATE, 
	"USUARIOGEN" VARCHAR2(30), 
	"FECHAGEN" DATE, 
	"OBSERVACION" VARCHAR2(200), 
	"CODENTIDAD" VARCHAR2(6), 
	"FECPROCESO" DATE, 
	"CODUSUARIOENVIO" VARCHAR2(15), 
	"HORAENVIO" DATE, 
	"ESTADO" VARCHAR2(6), 
	"CORRELATIVO" VARCHAR2(3), 
	"TIPO_CONFIGURACION" VARCHAR2(6), 
	"INDDOMICILIADO" VARCHAR2(1), 
	"FECMAXVENC" DATE, 
	"CANTRESPBCO" NUMBER(5,0) DEFAULT 0, 
	 CONSTRAINT "PK_DOMICI" PRIMARY KEY ("CODCIA", "IDPROCESO")
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
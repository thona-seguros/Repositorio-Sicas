
  CREATE TABLE "SICAS_OC"."PLD_OPE_PREOCUPANTES" 
   (	"CODCIA" NUMBER(14,0), 
	"CODEMPRESA" NUMBER(14,0), 
	"IDDENUNCIA" NUMBER(14,0), 
	"FOLIO_DENUNCIA" VARCHAR2(20), 
	"CODTIPOREPORTE" VARCHAR2(6), 
	"CODCANALDENUNCIA" VARCHAR2(6), 
	"FEC_REPORTE" DATE, 
	"CODCOMPORTAMIENTO" VARCHAR2(6), 
	"NUMPOLUNICO" VARCHAR2(30), 
	"MONTO_DENUNCIA" NUMBER(18,2), 
	"FEC_DETECCION" DATE, 
	"NOM_REPORTA" VARCHAR2(250), 
	"CORREO_ELECTRONICO" VARCHAR2(250), 
	"NOMBRE_PERSONA_REPORTADA" VARCHAR2(200), 
	"APELLIDO_PATERNO" VARCHAR2(50), 
	"APELLIDO_MATERNO" VARCHAR2(50), 
	"DESCRIPCION_DENUNCIA" VARCHAR2(4000), 
	"CODUSUARIO_ALTA" VARCHAR2(30) DEFAULT USER, 
	"FEC_ALTA" DATE DEFAULT TRUNC(SYSDATE), 
	"CODUSUARIO_MOD" VARCHAR2(30), 
	"FEC_MODIFICACION" DATE, 
	 CONSTRAINT "PK_PLD_OPE_PREOCUPANTES" PRIMARY KEY ("CODCIA", "CODEMPRESA", "IDDENUNCIA", "FOLIO_DENUNCIA", "CODTIPOREPORTE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
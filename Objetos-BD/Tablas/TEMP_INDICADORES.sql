
  CREATE TABLE "SICAS_OC"."TEMP_INDICADORES" 
   (	"IDCARGA" NUMBER(10,0) NOT NULL ENABLE, 
	"IDCONSECUTIVO" NUMBER(10,0) NOT NULL ENABLE, 
	"ANIO" NUMBER(4,0) NOT NULL ENABLE, 
	"MES" NUMBER(2,0) NOT NULL ENABLE, 
	"CONSECUTIVO" NUMBER(14,0), 
	"NUMPOLUNICO" VARCHAR2(30), 
	"STSPOLIZA" VARCHAR2(3), 
	"FECINIVIG" DATE, 
	"FECFINVIG" DATE, 
	"FECEMISION" DATE, 
	"CONTRATANTE" VARCHAR2(500), 
	"PRIMANETA_LOCAL" NUMBER(18,2), 
	"SUMAASEG_LOCAL" NUMBER(18,2), 
	"RAMO" VARCHAR2(100), 
	"IDTIPOSEG" VARCHAR2(6), 
	"NUM_COTIZACION" NUMBER(14,0), 
	"NUMFOLIOPORTAL" VARCHAR2(30), 
	"NUMPOLREF" VARCHAR2(30), 
	"TIPO_VIGENCIA" VARCHAR2(15), 
	"NUMERO_RENOVACION" NUMBER(5,0), 
	"AGRUPADOR" VARCHAR2(6), 
	"GRUPO_ECONOMICO" VARCHAR2(20), 
	"ESCONTRIBUTORIO_ACTUAL" VARCHAR2(2), 
	"ESCONTRIBUTORIO_NUEVO" VARCHAR2(2), 
	"PORCENCONTRIBUTORIO_ACTUAL" NUMBER(12,6), 
	"PORCENCONTRIBUTORIO_NUEVO" NUMBER(12,6), 
	"GIRONEGOCIO_ACTUAL" VARCHAR2(4000), 
	"GIRONEGOCIO_NUEVO" VARCHAR2(4000), 
	"CODTIPONEGOCIO_ACTUAL" VARCHAR2(10), 
	"CODTIPONEGOCIO_NUEVO" VARCHAR2(10), 
	"TIPONEGOCIO_ACTUAL" VARCHAR2(30), 
	"TIPONEGOCIO_NUEVO" VARCHAR2(30), 
	"CODFUENTERECURSOS_ACTUAL" VARCHAR2(6), 
	"CODFUENTERECURSOS_NUEVO" VARCHAR2(6), 
	"FUENTERECURSOS_ACTUAL" VARCHAR2(30), 
	"FUENTERECURSOS_NUEVO" VARCHAR2(30), 
	"CODPAQCOMERCIAL_ACTUAL" VARCHAR2(200), 
	"CODPAQCOMERCIAL_NUEVO" VARCHAR2(250), 
	"CODCATEGO_ACTUAL" VARCHAR2(14), 
	"CODCATEGO_NUEVO" VARCHAR2(14), 
	"CATEGORIA_ACTUAL" VARCHAR2(200), 
	"CATEGORIA_NUEVO" VARCHAR2(200), 
	"CODCANALFORMAVENTA_ACTUAL" VARCHAR2(50), 
	"CODCANALFORMAVENTA_NUEVO" VARCHAR2(50), 
	"CANALFORMAVENTA_ACTUAL" VARCHAR2(50), 
	"CANALFORMAVENTA_NUEVO" VARCHAR2(50), 
	"AGENTE" NUMBER(18,0), 
	"PROMOTOR" NUMBER(18,0), 
	"REGIONAL" NUMBER(18,0), 
	"TIPO_VIGENCIA_ACTUAL" VARCHAR2(15), 
	"TIPO_VIGENCIA_NUEVO" VARCHAR2(15), 
	"NUMAGRUPADOR_ACTUAL" VARCHAR2(10), 
	"NUMAGRUPADOR_NUEVO" VARCHAR2(10), 
	"AGRUPADOR_ACTUAL" VARCHAR2(200), 
	"AGRUPADOR_NUEVO" VARCHAR2(200), 
	"PREVIO" VARCHAR2(50), 
	"IDRENTDIC" VARCHAR2(50), 
	"AGRUPADORDIC" VARCHAR2(50), 
	"SUBRAMO" VARCHAR2(50), 
	"NOM_AGENTE" VARCHAR2(500), 
	"NOM_DR" VARCHAR2(500), 
	"FECCARGA" DATE DEFAULT SYSDATE, 
	"STSCARGA" VARCHAR2(20) DEFAULT 'XPR', 
	"CODUSUARIO" VARCHAR2(8) DEFAULT 'SICAS_OC', 
	"FECACTUALIZACION" DATE, 
	"CODUSUARIOACT" VARCHAR2(8), 
	 PRIMARY KEY ("IDCARGA", "IDCONSECUTIVO")
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
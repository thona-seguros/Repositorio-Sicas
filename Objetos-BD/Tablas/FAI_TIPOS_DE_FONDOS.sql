
  CREATE TABLE "SICAS_OC"."FAI_TIPOS_DE_FONDOS" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODEMPRESA" NUMBER(14,0) NOT NULL ENABLE, 
	"TIPOFONDO" VARCHAR2(10) NOT NULL ENABLE, 
	"DESCFONDO" VARCHAR2(200) NOT NULL ENABLE, 
	"CODMONEDA" VARCHAR2(6) NOT NULL ENABLE, 
	"PORCFONDO" NUMBER(9,6) NOT NULL ENABLE, 
	"STSFONDO" VARCHAR2(6) NOT NULL ENABLE, 
	"FECSTATUS" DATE, 
	"EDADMIN" NUMBER(3,0), 
	"EDADMAX" NUMBER(3,0), 
	"EDADRETIRO" NUMBER(3,0), 
	"MTOAPORTEMIN" NUMBER(22,2), 
	"MTOAPORTEMAX" NUMBER(22,2), 
	"MTOAPORTEINI" NUMBER(22,2), 
	"INDAPORTES" VARCHAR2(1), 
	"INDGENAPORTEINI" VARCHAR2(1), 
	"CODAPORTINI" VARCHAR2(10), 
	"INDRETPARCIALES" VARCHAR2(1), 
	"INDRETTOTALES" VARCHAR2(1), 
	"INDAJUSTES" VARCHAR2(1), 
	"INDTRASPASO" VARCHAR2(1), 
	"INDPRESTAMOS" VARCHAR2(1), 
	"PORCPRESTAMOS" NUMBER(9,6), 
	"CALCINTPRESTAMOS" VARCHAR2(1), 
	"TIPOINTPRESTAMOS" VARCHAR2(10), 
	"INDDESCINTFONDO" VARCHAR2(1), 
	"INDDESCPTMOFONDO" VARCHAR2(1), 
	"INDCOMISION" VARCHAR2(1), 
	"INDINCENTIVOS" VARCHAR2(1), 
	"TIPOINTERES" VARCHAR2(10), 
	"TIEMPOMINIMO" NUMBER(5,0), 
	"NUMDIASANUL" NUMBER(5,0), 
	"ANOINDISPUT" NUMBER(3,0), 
	"INDAVM" VARCHAR2(1), 
	"NOMREPESTCTA" VARCHAR2(20), 
	"NOMREPCERTIF" VARCHAR2(20), 
	"NOMREPFINIQUITO" VARCHAR2(20), 
	"TIPOINTERESGAR" VARCHAR2(10), 
	"INDRETANIOINI" VARCHAR2(1), 
	"TIPOINFLACION" VARCHAR2(10), 
	"MTOMINCONCENTRADORA" NUMBER(22,2), 
	"INDRESCATEAUTOMATICO" VARCHAR2(1), 
	"NOMREPRESCAUTOMATICO" VARCHAR2(30), 
	"NOMREPCARTBIEN" VARCHAR2(30), 
	"NOMREPTABVAL" VARCHAR2(30), 
	"INDMANEJOMONEDALOC" VARCHAR2(1) DEFAULT 'N', 
	"INDGENINTERESES" VARCHAR2(1) DEFAULT 'S', 
	"CODRUTINACALCINT" VARCHAR2(30), 
	"INDPLAZOOBLGCOMP" VARCHAR2(1), 
	"CLASEFONDO" VARCHAR2(2) DEFAULT 'UN', 
	"TIPOFONDOASOC" VARCHAR2(10), 
	"CODTIPOINVERSION" VARCHAR2(10), 
	"INDBENEFICIARIOS" VARCHAR2(1), 
	"INDDCTOCOBFONDO" VARCHAR2(1), 
	"CODRUTINAMINIMOS" VARCHAR2(30), 
	"INDUNIDADES" VARCHAR2(1), 
	"CODCPTORESAUTOM" VARCHAR2(10), 
	"TIPORANGOAPORTES" VARCHAR2(10), 
	"CODARTICULO" VARCHAR2(10), 
	"CODRUTINATOPES" VARCHAR2(30), 
	"TASACAMBIOTOPES" NUMBER(16,6), 
	"NOMREPRECIBO" VARCHAR2(30), 
	"CODCOBERTPAF" VARCHAR2(6), 
	"MESESPREFERENCIAL" NUMBER(3,0) DEFAULT 0, 
	"INDCONFAPORTES" VARCHAR2(1), 
	"PERIODOLIQUIDEZ" VARCHAR2(1), 
	"INDCOBCOBERTOPCDIF" VARCHAR2(1) DEFAULT 'N', 
	"ANIOPERIODORETIRO" NUMBER(6,0), 
	"INDCOMFONDOPOL" VARCHAR2(1), 
	"INDAPLICAIR" VARCHAR2(1), 
	"INDINTERESESDIARIOS" VARCHAR2(1), 
	"INDCONSULTAWEB" VARCHAR2(1), 
	"INDEXCLUSIVOPAGOPRIMA" VARCHAR2(1), 
	"INDFONDOCOLECTIVOS" VARCHAR2(1), 
	 CONSTRAINT "PK_FAI_TIPOS_DE_FONDOS" PRIMARY KEY ("CODCIA", "CODEMPRESA", "TIPOFONDO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE, 
	 CONSTRAINT "FK_FAI_TIPOS_DE_FONDOS_CODCIA" FOREIGN KEY ("CODEMPRESA", "CODCIA")
	  REFERENCES "SICAS_OC"."EMPRESAS_DE_SEGUROS" ("CODEMPRESA", "CODCIA") ON DELETE CASCADE ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
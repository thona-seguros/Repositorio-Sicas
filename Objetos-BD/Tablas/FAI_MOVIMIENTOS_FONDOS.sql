
  CREATE TABLE "SICAS_OC"."FAI_MOVIMIENTOS_FONDOS" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODEMPRESA" NUMBER(14,0) NOT NULL ENABLE, 
	"TIPOFONDO" VARCHAR2(10) NOT NULL ENABLE, 
	"CODCPTOMOV" VARCHAR2(10) NOT NULL ENABLE, 
	"TIPOMOV" VARCHAR2(6) NOT NULL ENABLE, 
	"INDAUTOMATICO" VARCHAR2(1), 
	"STSMOVFONDO" VARCHAR2(6), 
	"FECSTATUS" DATE, 
	"CANTTRANSAC" NUMBER(5,0), 
	"MTOMINIMO" NUMBER(22,2), 
	"MTOMAXIMO" NUMBER(22,2), 
	"PORCCPTOMOV" NUMBER(9,6), 
	"INDAPLICACARGO" VARCHAR2(1), 
	"CODCARGO" VARCHAR2(10), 
	"INDAPLICABONO" VARCHAR2(1), 
	"CODBONO" VARCHAR2(10), 
	"INDCOMISION" VARCHAR2(1), 
	"INDINCENTIVO" VARCHAR2(1), 
	"INDGENCONTAB" VARCHAR2(1), 
	"NOMREPMOV" VARCHAR2(30), 
	"CODRUTINACALC" VARCHAR2(30), 
	"INDAPLICARET" VARCHAR2(1), 
	"CODCPTORET" VARCHAR2(10), 
	"INDACUMMOVASOC" VARCHAR2(1), 
	"INDREVERSO" VARCHAR2(1), 
	"CPTOMOVREV" VARCHAR2(10), 
	"INDNOAPLICASALDO" VARCHAR2(1) DEFAULT 'N', 
	"INDAPLICAAJUSTE" VARCHAR2(1), 
	"CODCPTOAJU" VARCHAR2(10), 
	"INDENVIAEMAIL" VARCHAR2(1) DEFAULT 'N', 
	"INDIMPUESTO" VARCHAR2(1), 
	"CODIMPUESTO" VARCHAR2(10), 
	 CONSTRAINT "PK_FAI_MOVIMIENTOS_FONDOS" PRIMARY KEY ("CODCIA", "CODEMPRESA", "TIPOFONDO", "CODCPTOMOV")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE, 
	 CONSTRAINT "FK_FAI_MOV_FONDOS_CONF" FOREIGN KEY ("CODCIA", "CODEMPRESA", "CODCPTOMOV")
	  REFERENCES "SICAS_OC"."FAI_CONF_MOVIMIENTOS_FONDO" ("CODCIA", "CODEMPRESA", "CODCPTOMOV") ON DELETE CASCADE ENABLE, 
	 CONSTRAINT "FK_FAI_MOV_FONDOS_TIPOS" FOREIGN KEY ("CODCIA", "CODEMPRESA", "TIPOFONDO")
	  REFERENCES "SICAS_OC"."FAI_TIPOS_DE_FONDOS" ("CODCIA", "CODEMPRESA", "TIPOFONDO") ON DELETE CASCADE ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 

  CREATE TABLE "SICAS_OC"."AUTORIZA_PROCESOS_ORIGEN" 
   (	"CODCIA" NUMBER NOT NULL ENABLE, 
	"IDORIGEN" NUMBER(14,0) NOT NULL ENABLE, 
	"IDOBJETO" VARCHAR2(35) NOT NULL ENABLE, 
	"IDOBJETOPRINCIPAL" VARCHAR2(35), 
	"CAMPOLLAVE" VARCHAR2(35), 
	"CODAPLICA" VARCHAR2(8), 
	 CONSTRAINT "PK_AUTORIZA_PROCESOS_ORIGEN" PRIMARY KEY ("CODCIA", "IDORIGEN")
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

  CREATE TABLE "SICAS_OC"."COTIZACIONES_CENSO_ASEG" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODEMPRESA" NUMBER(14,0) NOT NULL ENABLE, 
	"IDCOTIZACION" NUMBER(14,0) NOT NULL ENABLE, 
	"IDETCOTIZACION" NUMBER(14,0) NOT NULL ENABLE, 
	"IDASEGURADO" NUMBER(10,0) NOT NULL ENABLE, 
	"EDADASEGURADOS" NUMBER(5,0), 
	"CANTASEGURADOS" NUMBER(10,0), 
	"SALARIOMENSUAL" NUMBER(28,2), 
	"VECESSALARIO" NUMBER(10,0), 
	"SUMAASEGLOCALCENSO" NUMBER(28,2), 
	"SUMAASEGMONEDACENSO" NUMBER(28,2), 
	"PRIMALOCALCENSO" NUMBER(28,2), 
	"PRIMAMONEDACENSO" NUMBER(28,2), 
	 CONSTRAINT "PK_COTIZACIONES_CENSO_ASEG" PRIMARY KEY ("CODCIA", "CODEMPRESA", "IDCOTIZACION", "IDETCOTIZACION", "IDASEGURADO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "IDX_SICASOC"  ENABLE, 
	 CONSTRAINT "FK_DETALLE_COTIZACIONES_CENSO" FOREIGN KEY ("CODCIA", "CODEMPRESA", "IDCOTIZACION", "IDETCOTIZACION")
	  REFERENCES "SICAS_OC"."COTIZACIONES_DETALLE" ("CODCIA", "CODEMPRESA", "IDCOTIZACION", "IDETCOTIZACION") ON DELETE CASCADE ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_SICASOC" 
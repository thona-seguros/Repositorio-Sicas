
  CREATE TABLE "SICAS_OC"."COTIZACIONES_COBERT_WEB_TEMP" 
   (	"CODCIA" NUMBER(14,0) NOT NULL ENABLE, 
	"CODEMPRESA" NUMBER(14,0) NOT NULL ENABLE, 
	"IDCOTIZACION" NUMBER(14,0) NOT NULL ENABLE, 
	"IDETCOTIZACION" NUMBER(14,0) NOT NULL ENABLE, 
	"CODGPOCOBERTWEB" VARCHAR2(6) NOT NULL ENABLE, 
	"CODCOBERTWEB" VARCHAR2(6) NOT NULL ENABLE, 
	"SUMAASEGCOBLOCAL" NUMBER(28,2), 
	"SUMAASEGCOBMONEDA" NUMBER(28,2), 
	"TASA" NUMBER(18,6), 
	"PRIMACOBLOCAL" NUMBER(28,2), 
	"PRIMACOBMONEDA" NUMBER(28,2), 
	"DEDUCIBLECOBLOCAL" NUMBER(28,2), 
	"DEDUCIBLECOBMONEDA" NUMBER(28,2), 
	"SALARIOMENSUAL" NUMBER(28,2), 
	"VECESSALARIO" NUMBER(10,0), 
	"SUMAASEGCALCULADA" NUMBER(28,2), 
	"EDAD_MINIMA" NUMBER(3,0), 
	"EDAD_MAXIMA" NUMBER(3,0), 
	"EDAD_EXCLUSION" NUMBER(3,0), 
	"SUMAASEG_MINIMA" NUMBER(28,2), 
	"SUMAASEG_MAXIMA" NUMBER(28,2), 
	"PORCEXTRAPRIMADET" NUMBER(9,6), 
	"MONTOEXTRAPRIMADET" NUMBER(18,2), 
	"SUMAINGRESADA" NUMBER(28,2), 
	"ORDENIMPRESION" NUMBER(4,0), 
	"DEDUCIBLEINGRESADO" NUMBER(28,2), 
	"CUOTAPROMEDIO" NUMBER(18,6), 
	"PRIMAPROMEDIO" NUMBER(28,2), 
	 CONSTRAINT "COTIZA_COBERT_WEB_TEMP_PK" PRIMARY KEY ("CODCIA", "CODEMPRESA", "IDCOTIZACION", "IDETCOTIZACION", "CODGPOCOBERTWEB", "CODCOBERTWEB")
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
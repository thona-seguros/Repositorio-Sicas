
  CREATE GLOBAL TEMPORARY TABLE "SICAS_OC"."TEM_DERIVA" 
   (	"FUENTE" VARCHAR2(100), 
	"COMPANIA" VARCHAR2(100), 
	"TIPO_TRAN" VARCHAR2(100), 
	"POLIZA" VARCHAR2(100), 
	"CONCEPTO" VARCHAR2(100), 
	"FECHA" VARCHAR2(100), 
	"CUENTA" VARCHAR2(100), 
	"CENTRO_COSTO" VARCHAR2(100), 
	"UEN" VARCHAR2(100), 
	"AUXILIAR" VARCHAR2(100), 
	"PROYECTO" VARCHAR2(100), 
	"LIBRO" VARCHAR2(100), 
	"MONEDA" VARCHAR2(100), 
	"IMPORTE_CAPTURADO" VARCHAR2(100), 
	"IMPORTE_CONVERTIDO" VARCHAR2(100), 
	"CARGO_CREDITO" VARCHAR2(100), 
	"UNIDADES" VARCHAR2(100), 
	"TIPO_CAMBIO" VARCHAR2(100), 
	"CONCEPTO_MOV" VARCHAR2(100), 
	"NUM_CHEQUE" VARCHAR2(100), 
	"NUM_POLIZA_MIZAR" VARCHAR2(100), 
	"COMENTARIO" VARCHAR2(100), 
	"REFERENCIA" VARCHAR2(100), 
	"RFC_EMISOR" VARCHAR2(100), 
	"RFC_RECEPTOR" VARCHAR2(100), 
	"SERIE_FAC" VARCHAR2(100), 
	"FOLIO" VARCHAR2(100), 
	"UUID" VARCHAR2(100), 
	"CFD_MONEDA" VARCHAR2(100), 
	"CFD_TIPOCAMBIO" VARCHAR2(100)
   ) ON COMMIT DELETE ROWS 
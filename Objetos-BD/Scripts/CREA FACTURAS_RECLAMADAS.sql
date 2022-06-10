-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM FACTURAS_RECLAMADAS
;
DROP TABLE FACTURAS_RECLAMADAS
;

CREATE TABLE FACTURAS_RECLAMADAS
(
CODCIA				NUMBER(14)	,
CODEMPRESA			NUMBER(14)	,
IDSINIESTRO			NUMBER(14)	,
IDDETSIN				NUMBER(14)	,
IDPOLIZA				NUMBER(14)	,
COD_ASEGURADO			NUMBER(14)	,
ID_CONSECUTIVO			NUMBER(3)	,
NUM_COMPROBANTE		VARCHAR2(15)	,
FOLIO_FISCAL			VARCHAR2(40)	,
FEC_EMISION_COMPROB		DATE		,
RFC_PROVEEDOR			VARCHAR2(16)	,
NOM_PROVEEDOR			VARCHAR2(100)	,
TP_PROCEDIMIENTO		VARCHAR2(6)	,
MONTO_RECLAMADO		NUMBER(18,2)	,
MONTO_AUTORIZADO		NUMBER(18,2)	,
TP_CONCEPTO_NO_CUBIERTO	VARCHAR2(6)	,
OBSERVACIONES			VARCHAR2(300)
)
;

-- =============================
-- Genera Primaty key
-- =============================
 
alter table FACTURAS_RECLAMADAS
  add constraint FACTURAS_RECLAMADAS_PK PRIMARY KEY (CODCIA, CODEMPRESA, IDSINIESTRO, IDDETSIN, IDPOLIZA , COD_ASEGURADO, ID_CONSECUTIVO)
; 
 
-- =============================
-- Genera Indice
-- =============================
create  index FACTURAS_RECLAMADAS_IDX_1 on FACTURAS_RECLAMADAS(IDPOLIZA, IDSINIESTRO)
;
-- =============================
-- Crea Comentarios
-- =============================

-- =============================
-- Genera los permisos
-- =============================
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER, INDEX ON FACTURAS_RECLAMADAS to PUBLIC
;
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or REPLACE PUBLIC SYNONYM FACTURAS_RECLAMADAS FOR FACTURAS_RECLAMADAS
;
COMMENT ON TABLE FACTURAS_RECLAMADAS IS 'Tabla  para FACTURAS_RECLAMADAS'
comment on column FACTURAS_RECLAMADAS.CODCIA 			is 'Clave de Compania';
comment on column FACTURAS_RECLAMADAS.CODEMPRESA 		is 'Clave de Empresa';
comment on column FACTURAS_RECLAMADAS.IDSINIESTRO 			is 'Identificador de siniestro';
comment on column FACTURAS_RECLAMADAS.IDDETSIN 			is 'Identificador de detalle de siniestro';
comment on column FACTURAS_RECLAMADAS.IDPOLIZA 			is 'Numero de Poliza';
comment on column FACTURAS_RECLAMADAS.COD_ASEGURADO 		is 'Codigo de Asegurado';
comment on column FACTURAS_RECLAMADAS.ID_CONSECUTIVO 		is 'Secuencia de comprobantes';
comment on column FACTURAS_RECLAMADAS.NUM_COMPROBANTE 		is 'Numero factura o recibo';
comment on column FACTURAS_RECLAMADAS.FOLIO_FISCAL 		is 'Folio Fiscal';
comment on column FACTURAS_RECLAMADAS.FEC_EMISION_COMPROB 	is 'Fecha Emision Comprobante';
comment on column FACTURAS_RECLAMADAS.RFC_PROVEEDOR 		is 'RFC Proveedor';
comment on column FACTURAS_RECLAMADAS.NOM_PROVEEDOR 		is 'Nombre del Proveedor';
comment on column FACTURAS_RECLAMADAS.TP_PROCEDIMIENTO 		is 'Tipo de Procedimiento';
comment on column FACTURAS_RECLAMADAS.MONTO_RECLAMADO 		is 'Monto Reclamado';
comment on column FACTURAS_RECLAMADAS.MONTO_AUTORIZADO 		is 'Monto Autorizado';
comment on column FACTURAS_RECLAMADAS.TP_CONCEPTO_NO_CUBIERTO 	is 'Tipo de concepto no cubierto';
comment on column FACTURAS_RECLAMADAS.OBSERVACIONES 		is 'Observaciones';

/

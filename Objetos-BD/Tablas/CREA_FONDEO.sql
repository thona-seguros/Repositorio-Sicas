-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM FONDEO
; 
DROP TABLE FONDEO
;

CREATE TABLE FONDEO
(
CODCIA	NUMBER(14)	,
CODEMPRESA	NUMBER(14)	,
IDSINIESTRO	NUMBER(14)	,
IDDETSIN	NUMBER(14)	,
NUM_APROBACION	NUMBER(14)	,
BENEF	NUMBER(5)	,
NUM_CHEQUE	NUMBER(14)	,
NUM_REFERENCIA	VARCHAR2(40)	,
IDTIPO_PAGO	VARCHAR2(6)	,
FEC_PAGO_MOVTO	DATE	,
FEC_PAGO_REAL	DATE	,
ID_GRUPO_FONDEO	NUMBER(5)	,
ST_FONDEO	VARCHAR2(6)	,
FEC_FONDEO	DATE	,
USUARIO_FONDEO	VARCHAR2(30)	,
MONTO_MONEDA	NUMBER(18,2)	,
ST_FINIQUITO	VARCHAR2(6)	,
FEC_REGISTRO	DATE	,
USUARIO_REGISTRO	VARCHAR2(30)	,
FEC_IMPRESION	DATE	,
USUARIO_IMPRESION	VARCHAR2(30)	,
MOTIVO_RECHAZO	VARCHAR2(100)	,
FEC_PAGO_PROGRAMADA	DATE	,
IDPROC	NUMBER(14),
IDRAMO	VARCHAR2(6)
)
;

-- =============================
-- Genera Primaty key
-- =============================
 
--alter table FONDEO
--  add constraint PK_FONDEO primary key (XXXXXXXX); 
 
-- =============================
-- Genera Indice
-- =============================
create  index FONDEO_IDX_1 on FONDEO(IDSINIESTRO,NUM_APROBACION,CODCIA)
;
create  index FONDEO_IDX_2 on FONDEO(FEC_FONDEO,USUARIO_FONDEO,ID_GRUPO_FONDEO)
;
create  index FONDEO_IDX_3 on FONDEO(FEC_PAGO_PROGRAMADA)
;
-- =============================
-- Genera los permisos
-- =============================
grant select, insert, update, delete, alter, index on FONDEO to PUBLIC
;
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM FONDEO FOR FONDEO
;
-- =============================
-- Crea Comentarios
-- =============================
comment on column FONDEO.CODCIA is 'Clave de Compania';
comment on column FONDEO.CODEMPRESA is 'Clave de Empresa';
comment on column FONDEO.IDSINIESTRO is 'Identificador de siniestro';
comment on column FONDEO.IDDETSIN is 'Identificador de detalle de siniestro';
comment on column FONDEO.NUM_APROBACION is 'Identificador de aprobacion';
comment on column FONDEO.BENEF is 'Identificador de beneficiario';
comment on column FONDEO.NUM_CHEQUE is 'Identificador del cheque';
comment on column FONDEO.NUM_REFERENCIA is 'Identificador de Nro de transferencia u otro';
comment on column FONDEO.IDTIPO_PAGO is 'Identificador de tipo de pago';
comment on column FONDEO.FEC_PAGO_MOVTO is 'Fecha de pago de generacion de movimiento';
comment on column FONDEO.FEC_PAGO_REAL is 'Fecha de pago real';
comment on column FONDEO.ID_GRUPO_FONDEO is 'identificado de grupo de fondeo';
comment on column FONDEO.ST_FONDEO is 'Estatus de fondeo';
comment on column FONDEO.FEC_FONDEO is 'Fecha de fondeo';
comment on column FONDEO.USUARIO_FONDEO is 'Usuario que genero el fondeo';
comment on column FONDEO.MONTO_MONEDA is 'Importe del pago';
comment on column FONDEO.ST_FINIQUITO is 'Estatus de finiquito';
comment on column FONDEO.FEC_REGISTRO is 'Fecha de registro de datos de finiquito';
comment on column FONDEO.USUARIO_REGISTRO is 'Usuario que registro datos de finiquito';
comment on column FONDEO.FEC_IMPRESION is 'Fecha de impresión del finiquito';
comment on column FONDEO.USUARIO_IMPRESION is 'Usuario que imprimio el finiquito';
comment on column FONDEO.MOTIVO_RECHAZO is 'Descripcion de motivo de rechazo';
comment on column FONDEO.FEC_PAGO_PROGRAMADA is 'Fecha de pago programada';
comment on column FONDEO.IDPROC is 'Identificador de proceso en tableros';
comment on column FONDEO.IDRAMO is 'Identificador de Ramo';




/

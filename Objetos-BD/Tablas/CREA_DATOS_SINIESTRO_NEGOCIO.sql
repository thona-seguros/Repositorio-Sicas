-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM DATOS_SINIESTRO_NEGOCIO
; 
DROP TABLE DATOS_SINIESTRO_NEGOCIO
;

CREATE TABLE DATOS_SINIESTRO_NEGOCIO
(
CODCIA	NUMBER(14)	,
CODEMPRESA	NUMBER(14)	,
IDSINIESTRO	NUMBER(14)	,
CODAGRUPADOR	VARCHAR2(6)	,
CODPLANTEL	VARCHAR2(6)	,
ST_SINIESTRO_DOCTO	VARCHAR2(6)	,
ID_MOTIVO_RECHAZO	VARCHAR2(6)	,
MONTO_RECHAZO_NOCUM	NUMBER(18,2)	,
FECHA_REGISTRO	DATE	,
USUARIO_REGISTRO	VARCHAR2(30)
)
;

-- =============================
-- Genera Primaty key
-- =============================
 
--alter table DATOS_SINIESTRO_NEGOCIO
--  add constraint PK_BENEF_SIN_ESP primary key (XXXXXXXX); 
 
-- =============================
-- Genera Indice
-- =============================
create  index DATOS_SINIESTRO_NEGOCIO_IDX_1 on DATOS_SINIESTRO_NEGOCIO(IDSINIESTRO,CODCIA)
;
-- =============================
-- Genera los permisos
-- =============================
grant select, insert, update, delete, alter, index on DATOS_SINIESTRO_NEGOCIO to PUBLIC
;
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM DATOS_SINIESTRO_NEGOCIO FOR DATOS_SINIESTRO_NEGOCIO
;
-- =============================
-- Crea Comentarios
-- =============================
comment on column DATOS_SINIESTRO_NEGOCIO.CODCIA is 'Clave de Compañia';
comment on column DATOS_SINIESTRO_NEGOCIO.CODEMPRESA is 'Clave de Empresa';
comment on column DATOS_SINIESTRO_NEGOCIO.IDSINIESTRO is 'Identificador de siniestro';
comment on column DATOS_SINIESTRO_NEGOCIO.CODAGRUPADOR is 'Codigo de agrupador';
comment on column DATOS_SINIESTRO_NEGOCIO.CODPLANTEL is 'Codigo de plantel';
comment on column DATOS_SINIESTRO_NEGOCIO.ST_SINIESTRO_DOCTO is 'Status del siniestro';
comment on column DATOS_SINIESTRO_NEGOCIO.ID_MOTIVO_RECHAZO is 'Motivo del rechazo';
comment on column DATOS_SINIESTRO_NEGOCIO.MONTO_RECHAZO_NOCUM is 'Monto de rechazo no cubierto ';
comment on column DATOS_SINIESTRO_NEGOCIO.FECHA_REGISTRO is 'Fecha de registro';
comment on column DATOS_SINIESTRO_NEGOCIO.USUARIO_REGISTRO is 'Usuario que registro';



/

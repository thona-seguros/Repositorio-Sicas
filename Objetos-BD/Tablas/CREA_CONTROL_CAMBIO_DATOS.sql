-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM CONTROL_CAMBIO_DATOS
; 
DROP TABLE CONTROL_CAMBIO_DATOS
;

CREATE TABLE CONTROL_CAMBIO_DATOS
(
CODCIA	NUMBER(14)	,
CODEMPRESA	NUMBER(14)	,
IDPOLIZA	NUMBER(14)	,
IDSINIESTRO	NUMBER(14)	,
IDCAMPO	VARCHAR2(50)	,
IDTABLA	VARCHAR2(50)	,
VALORANTERIOR	VARCHAR2(100)	,
VALORNUEVO	VARCHAR2(100)	,
USUARIO_SOLICITANTE	VARCHAR2(30)	,
USUARIO_REGISTRO	VARCHAR2(30)	,
FECHAREGISTRO	DATE,
MOTIVO  VARCHAR2(6)
)
;

-- =============================
-- Genera Primaty key
-- =============================
 
--alter table CONTROL_CAMBIO_DATOS
--  add constraint PK_RENOVACIONES primary key (XXXXXXXX); 
 
-- =============================
-- Genera Indice
-- =============================
create  index CONTROL_CAMBIO_DATOS_IDX_1 on CONTROL_CAMBIO_DATOS(IDSINIESTRO,CODCIA,IDCAMPO)
;
create  index CONTROL_CAMBIO_DATOS_IDX_2 on CONTROL_CAMBIO_DATOS(IDPOLIZA,CODCIA,IDCAMPO)
;
-- =============================
-- Genera los permisos
-- =============================
grant select, insert, update, delete, alter, index on CONTROL_CAMBIO_DATOS to PUBLIC
;
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM CONTROL_CAMBIO_DATOS FOR CONTROL_CAMBIO_DATOS
;
-- =============================
-- Crea Comentarios
-- =============================
comment on column CONTROL_CAMBIO_DATOS.CODCIA is 'Clave de Compañía';
comment on column CONTROL_CAMBIO_DATOS.CODEMPRESA is 'Clave de Empresa';
comment on column CONTROL_CAMBIO_DATOS.IDPOLIZA is 'Identificador de poliza';
comment on column CONTROL_CAMBIO_DATOS.IDSINIESTRO is 'identificador de siniestro';
comment on column CONTROL_CAMBIO_DATOS.IDCAMPO is 'Campo cmbiado';
comment on column CONTROL_CAMBIO_DATOS.IDTABLA is 'Tabla cambiada';
comment on column CONTROL_CAMBIO_DATOS.VALORANTERIOR is 'Valor anterior';
comment on column CONTROL_CAMBIO_DATOS.VALORNUEVO is 'Valor nuevo';
comment on column CONTROL_CAMBIO_DATOS.USUARIO_SOLICITANTE is 'Usuario que solicito el cambio';
comment on column CONTROL_CAMBIO_DATOS.USUARIO_REGISTRO is 'Usuario que hizo el cambio';
comment on column CONTROL_CAMBIO_DATOS.FECHAREGISTRO is 'Fecha de cambio';
comment on column CONTROL_CAMBIO_DATOS.MOTIVO is 'Motivo del cambio';



/

-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM RENO_CTRL
;
DROP TABLE RENO_CTRL
;

CREATE TABLE RENO_CTRL
(
ID_CODCIA	NUMBER(14)	,
NU_REMESA	VARCHAR2(15)	,
ID_POLIZA	NUMBER(14)	,
ID_DETPOL	NUMBER(14)	,
NUMPOLUNICO	VARCHAR2(30)	,
IDTIPOSEG	VARCHAR2(6)	,
FE_RENOVACION	DATE	,
ID_POLIZA_REN	NUMBER(14)	,
ID_DETPOL_REN	NUMBER(14)	,
FE_RENOVACION_REN	DATE	,
ST_RENOVA	VARCHAR2(6)	,
FE_CARGA	DATE	,
FE_PROCESO	DATE	,
USUARIO_PROCESO	VARCHAR2(15)	,
PLDSTBLOQUEADA	VARCHAR2(2)	,
PLDSTAPROBADA	VARCHAR2(2)	,
PLDUSUARIOAPROB	VARCHAR2(15)	
)
;

-- =============================
-- Genera Indice
-- =============================
create  index RENO_CTRL_IDX_1 on RENO_CTRL (ID_CODCIA,NU_REMESA,ID_POLIZA,ST_RENOVA)
;
create  index RENO_CTRL_IDX_2 on RENO_CTRL (ID_POLIZA,ST_RENOVA)
;

-- =============================
-- Genera los permisos
-- =============================
grant select, insert, update, delete, alter, index on RENO_CTRL to PUBLIC
;
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM RENO_CTRL FOR RENO_CTRL
;
-- =============================
-- Crea Comentarios
-- =============================
comment on column RENO_CTRL.ID_CODCIA is 'Código de empresa';
comment on column RENO_CTRL.NU_REMESA is 'Numero de remesa';
comment on column RENO_CTRL.ID_POLIZA is 'Numero de poliza';
comment on column RENO_CTRL.ID_DETPOL is 'Numero de detalle de poliza';
comment on column RENO_CTRL.NUMPOLUNICO is 'Numero de poliza unico';
comment on column RENO_CTRL.IDTIPOSEG is 'Tipo de Seguro';
comment on column RENO_CTRL.FE_RENOVACION is 'Fecha de renovacion emision';
comment on column RENO_CTRL.ID_POLIZA_REN is 'Numero de poliza';
comment on column RENO_CTRL.ID_DETPOL_REN is 'Numero de detalle de poliza';
comment on column RENO_CTRL.FE_RENOVACION_REN is 'Fecha de renovacion nueva';
comment on column RENO_CTRL.ST_RENOVA is 'Estatus de renovacion';
comment on column RENO_CTRL.FE_CARGA is 'Fecha de carga';
comment on column RENO_CTRL.FE_PROCESO is 'Fecha de proceso de renovacion';
comment on column RENO_CTRL.USUARIO_PROCESO is 'Ultimo usuario con movimiento';
comment on column RENO_CTRL.PLDSTBLOQUEADA is 'Estatus de si entre a PLD';
comment on column RENO_CTRL.PLDSTAPROBADA is 'Estatus de si fue aprobada en PLD';
comment on column RENO_CTRL.PLDUSUARIOAPROB is 'Usuario que auorizo el PLD';




/

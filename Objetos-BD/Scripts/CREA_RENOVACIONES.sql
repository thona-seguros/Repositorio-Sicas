-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM RENOVACIONES
;
DROP TABLE RENOVACIONES
;

CREATE TABLE RENOVACIONES
(
ID_CODCIA	NUMBER(14)	,
ID_POLIZA	NUMBER(14)	,
NUMPOLUNICO	VARCHAR2(30)	,
NUMRENOV	NUMBER(5)	,
FE_RENOVACION	DATE	,
ID_POLIZA_REN	NUMBER(14)	,
NUMPOLUNICO_REN	VARCHAR2(30)	,
NUMRENOV_REN	NUMBER(5)	,
FE_RENOVACION_REN	DATE	,
TP_MOVTO	VARCHAR2(6)	,
FE_PROCESO	DATE	,
USUARIO_PROCESO	VARCHAR2(15)	
)
;
 
-- =============================
-- Genera Indice
-- =============================
create  index RENOVACIONES_CTRL_IDX_1 on RENOVACIONES(ID_POLIZA)
;
create  index RENOVACIONES_CTRL_IDX_2 on RENOVACIONES(ID_POLIZA_REN)
;

-- =============================
-- Genera los permisos
-- =============================
grant select, insert, update, delete, alter, index on RENOVACIONES to PUBLIC
;
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM RENOVACIONES FOR RENOVACIONES
;
-- =============================
-- Crea Comentarios
-- =============================
comment on column RENOVACIONES.ID_CODCIA is 'Código de empresa';
comment on column RENOVACIONES.ID_POLIZA is 'Numero de poliza origen';
comment on column RENOVACIONES.NUMPOLUNICO is 'Numero de poliza unico origen';
comment on column RENOVACIONES.NUMRENOV is 'Numero de renovacion origen';
comment on column RENOVACIONES.FE_RENOVACION is 'Fecha de renovacion emision  origen';
comment on column RENOVACIONES.ID_POLIZA_REN is 'Numero de poliza renovada';
comment on column RENOVACIONES.NUMPOLUNICO_REN is 'Numero de poliza unico renovada';
comment on column RENOVACIONES.NUMRENOV_REN is 'Numero de renovacion renovada';
comment on column RENOVACIONES.FE_RENOVACION_REN is 'Fecha de renovacion emision renovada';
comment on column RENOVACIONES.TP_MOVTO is 'Tipo de movimiento';
comment on column RENOVACIONES.FE_PROCESO is 'Fecha de proceso de renovacion';
comment on column RENOVACIONES.USUARIO_PROCESO is 'Usuario que proceso';


/

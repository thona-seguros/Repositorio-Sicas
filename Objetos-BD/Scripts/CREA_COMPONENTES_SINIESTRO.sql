-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM COMPONENTES_SINIESTRO
; 
DROP TABLE COMPONENTES_SINIESTRO
;

CREATE TABLE COMPONENTES_SINIESTRO
(
CODCIA	NUMBER(14)	,
CODEMPRESA	NUMBER(14)	,
IDSINIESTRO	NUMBER(14)	,
IDPOLIZA	NUMBER(14)	,
ID_CONSECUTIVO	NUMBER(6)	,
ID_COMPONENTE	VARCHAR2(6)	,
MONTO_COMPONENTE	NUMBER(18,2)	,
FEC_REGISTRO	DATE	,
USUARIO_REGISTRO	VARCHAR2(30)
)
;

-- =============================
-- Genera Primaty key
-- =============================
 
alter table COMPONENTES_SINIESTRO
  add constraint COMPONENTES_SINIESTRO_PK primary key (CODCIA,CODEMPRESA,IDSINIESTRO,IDPOLIZA,ID_CONSECUTIVO)
; 
 
-- =============================
-- Genera Indice
-- =============================
create  index COMPONENTES_SINIESTRO_IDX_1 on COMPONENTES_SINIESTRO(IDPOLIZA,ID_COMPONENTE)
;
create  index COMPONENTES_SINIESTRO_IDX_2 on COMPONENTES_SINIESTRO(IDSINIESTRO,ID_COMPONENTE)
;

-- =============================
-- Genera los permisos
-- =============================
grant select, insert, update, delete, alter, index on COMPONENTES_SINIESTRO to PUBLIC
;
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM COMPONENTES_SINIESTRO FOR COMPONENTES_SINIESTRO
;
-- =============================
-- Crea Comentarios
-- =============================
comment on column COMPONENTES_SINIESTRO.CODCIA is 'Codigo de compañía';
comment on column COMPONENTES_SINIESTRO.CODEMPRESA is 'Codigo de empresa';
comment on column COMPONENTES_SINIESTRO.IDSINIESTRO is 'identificador de siniestro';
comment on column COMPONENTES_SINIESTRO.IDPOLIZA is 'identificador de poliza';
comment on column COMPONENTES_SINIESTRO.ID_CONSECUTIVO is 'Consecutivo de componentes';
comment on column COMPONENTES_SINIESTRO.ID_COMPONENTE is 'identificador de componentes';
comment on column COMPONENTES_SINIESTRO.MONTO_COMPONENTE is 'Monto de componente';
comment on column COMPONENTES_SINIESTRO.FEC_REGISTRO is 'Fecha de registro';
comment on column COMPONENTES_SINIESTRO.USUARIO_REGISTRO is 'Usuario que registra';


/

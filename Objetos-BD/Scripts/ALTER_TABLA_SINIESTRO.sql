-- =============================
-- Modifica tabla
-- =============================
--  
ALTER TABLE SINIESTRO
ADD
(
IDCOLEINDI	VARCHAR2(6)	,
IDTPORIGEN	VARCHAR2(6)	,
CODUSUARIO	VARCHAR2(30)	,
FECREGISTRO	DATE	,
SUBMOTIVO_SINIESTRO	VARCHAR2(6)	,
IDAUTORIZACION_FLUJO	VARCHAR2(6)	,
USUARIO_AUTORIZA_FLUJO	VARCHAR2(30)	,
FEAUTORIZACION_FLUJO	DATE	,
CODRIESGOREA	VARCHAR2(6)	,
IDCONTRIBUTORIO	VARCHAR2(6)
)
;

comment on column SINIESTRO.IDCOLEINDI is 'Indicador de Poliza Colectiva';
comment on column SINIESTRO.IDTPORIGEN is 'Tipo de origen';
comment on column SINIESTRO.CODUSUARIO is 'Usuario de alta';
comment on column SINIESTRO.FECREGISTRO is 'Fecha de alta';
comment on column SINIESTRO.SUBMOTIVO_SINIESTRO is 'Submotivos del Siniestro';
comment on column SINIESTRO.IDAUTORIZACION_FLUJO is 'Identificador de autorizacion';
comment on column SINIESTRO.USUARIO_AUTORIZA_FLUJO is 'Usuario que autorizo';
comment on column SINIESTRO.FEAUTORIZACION_FLUJO is 'Fecha de autorizacion';
comment on column SINIESTRO.CODRIESGOREA is 'Código de Riesgo para Reaseguro';
comment on column SINIESTRO.IDCONTRIBUTORIO is 'Identificador si es contributorio';



ALTER TABLE SINIESTRO
MODIFY
(
DESC_SINIESTRO	VARCHAR2(4000)
)
;

-- =============================
-- Borra Primaty key
-- =============================
--ALTER TABLE SINIESTRO drop constraint SYS_C0021356 cascade;  --DESARROLLO
--ALTER TABLE SINIESTRO drop constraint SYS_C0032150 cascade;  --PRUEBAS
--ALTER TABLE SINIESTRO drop constraint SYS_C0020915 cascade;  --ALTERNO
ALTER TABLE SINIESTRO drop constraint SYS_C0021356 cascade;  --PRODUCCION
 
-- =============================
-- Borra Indice
-- =============================

DROP INDEX IN_DX1_SINIESTRO;
DROP INDEX SINIESTRO_IDX_1;
DROP INDEX SINIESTRO_IDX_2;
--DROP INDEX SINIESTRO_IDX_3;  --PRUEBAS

-- =============================
-- Genera Primaty key
-- =============================
 
alter table SINIESTRO
  add constraint SINIESTRO_PK primary key (IDSINIESTRO, CODCIA)
   using index 
  tablespace TS_SICASOC
; 

-- =============================
-- Genera Indice
-- =============================
create  index SINIESTRO_IDX_1 on SINIESTRO(NUMSINIREF, CODCIA)
  tablespace TS_SICASOC
;
create  index SINIESTRO_IDX_2 on SINIESTRO(IDPOLIZA, IDETPOL, CODCIA)
  tablespace TS_SICASOC
;


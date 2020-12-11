-- =============================
-- Modifica tabla 
-- =============================
--   
ALTER TABLE BENEF_SIN_PAGOS
ADD
(
CODCIA	NUMBER(14)	,
CODEMPRESA	NUMBER(14)	,
CODUSUARIO	VARCHAR2(30)	,
FECREGISTRO	DATE
)
;

comment on column BENEF_SIN_PAGOS.CODCIA is 'Codigo de la compañia de seguros';
comment on column BENEF_SIN_PAGOS.CODEMPRESA is 'Codigo de la empresa de seguros';
comment on column BENEF_SIN_PAGOS.CODUSUARIO is 'Usuario de alta';
comment on column BENEF_SIN_PAGOS.FECREGISTRO is 'Fecha de alta';

-- =============================
-- Borra Primaty key
-- =============================
ALTER TABLE BENEF_SIN_PAGOS drop constraint PK_BENEF_SIN_PAGOS cascade;
 
 
-- =============================
-- Borra Indice
-- =============================

--

-- =============================
-- Genera Indice
-- =============================
create  index BENEF_SIN_PAGOS_IDX_1 on BENEF_SIN_PAGOS(IDSINIESTRO,  BENEF,  NUM_APROBACION, CODCIA)
  tablespace TS_SICASOC
;


-- =============================
-- Modifica tabla
-- =============================
--
ALTER TABLE BENEF_SIN
ADD
(
TELEFONO_LOCAL	VARCHAR2(50)	,
CODCIA	NUMBER(14)	,
CODEMPRESA	NUMBER(14)	,
CODUSUARIO	VARCHAR2(30)	,
FECREGISTRO	DATE,
IDTIPO_PAGO	VARCHAR2(6),
TP_IDENTIFICACION	VARCHAR2(6)	,
NUM_IDENTIFICACION	VARCHAR2(30)	,
COD_CONVENIO	VARCHAR2(20)
)
;

comment on column BENEF_SIN.TELEFONO_LOCAL is 'Telefono Local';
comment on column BENEF_SIN.CODCIA is 'Codigo de la compania de seguros';
comment on column BENEF_SIN.CODEMPRESA is 'Codigo de la empresa de seguros';
comment on column BENEF_SIN.CODUSUARIO is 'Usuario de alta';
comment on column BENEF_SIN.FECREGISTRO is 'Fecha de alta';
comment on column BENEF_SIN.IDTIPO_PAGO is 'Identificador de tipo de pago';
comment on column BENEF_SIN.TP_IDENTIFICACION is 'Tipo de identificacion';
comment on column BENEF_SIN.NUM_IDENTIFICACION is 'Numero de identificacion';
comment on column BENEF_SIN.COD_CONVENIO is 'Numero de Convenio';


-- =============================
-- Borra Primaty key
-- =============================
--ALTER TABLE BENEF_SIN drop constraint SYS_C0017406 cascade; --DESARROLLO
--ALTER TABLE BENEF_SIN drop constraint SYS_C0032009 cascade; --PRUEBAS
--ALTER TABLE BENEF_SIN drop constraint SYS_C0021059 cascade; --ALTERNO 
ALTER TABLE BENEF_SIN drop constraint SYS_C0021501 cascade; --PRODUCCION 
 
-- =============================
-- Borra Indice
-- =============================

--

-- =============================
-- Genera Indice
-- =============================
create  index BENEF_SIN_IDX_1 on BENEF_SIN(IDSINIESTRO,  BENEF, CODCIA)
  tablespace TS_SICASOC
;


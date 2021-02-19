-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM BENEF_SIN_ESP
; 
DROP TABLE BENEF_SIN_ESP
;

CREATE TABLE BENEF_SIN_ESP
(
CODCIA	NUMBER(14)	,
CODEMPRESA	NUMBER(14)	,
IDNEGOCIO	VARCHAR2(6)	,
IDBENEFICIARIO	NUMBER(14)	,
NOMBRE	VARCHAR2(300)	,
APELLIDO_PATERNO	VARCHAR2(50)	,
APELLIDO_MATERNO	VARCHAR2(50)	,
CODPARENT	VARCHAR2(6)	,
PORCEPART	NUMBER(9,6)	,
FECNAC	DATE	,
TIPO_ID_TRIBUTARIO	VARCHAR2(6)	,
NUM_DOC_TRIBUTARIO	VARCHAR2(20)	,
SEXO	VARCHAR2(6)	,
ENT_FINANCIERA	VARCHAR2(6)	,
NUMCUENTABANCARIA	VARCHAR2(20)	,
CUENTA_CLABE	VARCHAR2(50)
)
;

-- =============================
-- Genera Primaty key
-- =============================
 
--alter table BENEF_SIN_ESP
--  add constraint PK_BENEF_SIN_ESP primary key (XXXXXXXX); 
 
-- =============================
-- Genera Indice
-- =============================
create  index BENEF_SIN_ESP_IDX_1 on BENEF_SIN_ESP(IDNEGOCIO,IDBENEFICIARIO)
;
-- =============================
-- Genera los permisos
-- =============================
grant select, insert, update, delete, alter, index on BENEF_SIN_ESP to PUBLIC
;
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM BENEF_SIN_ESP FOR BENEF_SIN_ESP
;
-- =============================
-- Crea Comentarios
-- =============================
comment on column BENEF_SIN_ESP.CODCIA is 'Clave de Compañía';
comment on column BENEF_SIN_ESP.CODEMPRESA is 'Clave de Empresa';
comment on column BENEF_SIN_ESP.IDNEGOCIO is 'Tipo de negocio';
comment on column BENEF_SIN_ESP.IDBENEFICIARIO is 'Numero de benficiario';
comment on column BENEF_SIN_ESP.NOMBRE is 'Nombre del beneficiario';
comment on column BENEF_SIN_ESP.APELLIDO_PATERNO is 'Apellido Paterno';
comment on column BENEF_SIN_ESP.APELLIDO_MATERNO is 'Apellido Materno';
comment on column BENEF_SIN_ESP.CODPARENT is 'Codigo de parentesco';
comment on column BENEF_SIN_ESP.PORCEPART is 'Porcentaje de participacion';
comment on column BENEF_SIN_ESP.FECNAC is 'Fecha de nacimiento';
comment on column BENEF_SIN_ESP.TIPO_ID_TRIBUTARIO is 'Tipo de identificador';
comment on column BENEF_SIN_ESP.NUM_DOC_TRIBUTARIO is 'Valor de identificador';
comment on column BENEF_SIN_ESP.SEXO is 'Sexo';
comment on column BENEF_SIN_ESP.ENT_FINANCIERA is 'Entidad Financiera';
comment on column BENEF_SIN_ESP.NUMCUENTABANCARIA is 'Numero de Cuenta Bancaria';
comment on column BENEF_SIN_ESP.CUENTA_CLABE is 'Cuenta Clave';




/

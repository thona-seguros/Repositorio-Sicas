-- =============================
-- Crea Tabla
-- =============================
--DROP PUBLIC SYNONYM PLD_REGLAS
--;
--DROP TABLE PLD_REGLAS
--;

CREATE TABLE PLD_REGLAS
(
CODCIA	NUMBER(14)	,
TABLA	VARCHAR2(50)	,
CAMPO	VARCHAR2(50)	,
ST_CAMPO	VARCHAR2(6)	,
COD_MONEDA	VARCHAR2(6)	,
FORMPAGO	VARCHAR2(6)	,
TIPO_PERSONA	VARCHAR2(6)	,
MONTO_DESDE	NUMBER(20,2)	,
MONTO_HASTA	NUMBER(20,2)	,
MONTO_MAX_MENSUAL	NUMBER(20,2)	,
ID_ALERTA	VARCHAR2(2)	,
LISTA_ORIGEN	VARCHAR2(6)	,
DESC_ALERTA	VARCHAR2(500)	,
CODUSUARIO_ALTA	VARCHAR2(30)	,
FEC_ALTA	DATE
)
tablespace TS_SICASOC
;

-- =============================
-- Genera Primaty key
-- =============================
 
alter table PLD_REGLAS
  add constraint PK_PLD_REGLAS primary key (CODCIA,TABLA,CAMPO,ST_CAMPO,COD_MONEDA,FORMPAGO,TIPO_PERSONA
)
   using index 
  tablespace TS_SICASOC
; 
/*
-- =============================
-- Genera Indice
-- =============================
create  index PLD_REGLAS_IDX_1 on PLD_REGLAS(ID_PERIODO,CODCIA)
  tablespace TS_SICASOC
;
*/
-- =============================
-- Genera los permisos
-- =============================
grant select, insert, update, delete, alter, index on PLD_REGLAS to PUBLIC
;

-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM PLD_REGLAS FOR PLD_REGLAS
;

-- =============================
-- Crea Comentarios
-- =============================
comment on column PLD_REGLAS.CODCIA is 'Clave de Compania';
comment on column PLD_REGLAS.TABLA is 'Tabla ';
comment on column PLD_REGLAS.CAMPO is 'Campo';
comment on column PLD_REGLAS.ST_CAMPO is 'Estatus  del campo';
comment on column PLD_REGLAS.COD_MONEDA is 'Codigo Moneda';
comment on column PLD_REGLAS.FORMPAGO is 'Forma de pago';
comment on column PLD_REGLAS.TIPO_PERSONA is 'Tipo de persona';
comment on column PLD_REGLAS.MONTO_DESDE is 'Monto desde ';
comment on column PLD_REGLAS.MONTO_HASTA is 'Monto hasta';
comment on column PLD_REGLAS.MONTO_MAX_MENSUAL is 'Monto maximo mensual';
comment on column PLD_REGLAS.ID_ALERTA is 'Indicador de si requiere alerta';
comment on column PLD_REGLAS.LISTA_ORIGEN is 'Listas de origen de la regla';
comment on column PLD_REGLAS.DESC_ALERTA is 'Descripcion de la regla';
comment on column PLD_REGLAS.CODUSUARIO_ALTA is 'Usuario que registra';
comment on column PLD_REGLAS.FEC_ALTA is 'Fecha de registro';


/

-- =============================
-- Crea Tabla 
-- =============================
--DROP PUBLIC SYNONYM PLD_LISTAS_CNSF
--;
--DROP TABLE PLD_LISTAS_CNSF
--;

CREATE TABLE PLD_LISTAS_CNSF
(
CODCIA	NUMBER(14)	,
ID_LISTA	NUMBER(20)	,
TP_MOVIMIENTO	VARCHAR2(6)	,
DESCR_TP_MOVIMIENTO	VARCHAR2(200)	,
FEC_MOVIMIENTO	DATE	,
LISTA_ORIGEN	VARCHAR2(6)	,
FEC_COMUNICADO	DATE	,
TIPO_PERSONA_CNSF	VARCHAR2(6)	,
NOMBRE_1	VARCHAR2(200)	,
NOMBRE_2	VARCHAR2(200)	,
NOMBRE_3	VARCHAR2(200)	,
NOMBRE_4	VARCHAR2(200)	,
NOMBRE_5	VARCHAR2(200)	,
FEC_NACIMIENTO	VARCHAR2(100)	,
PAIS_PROCEDENCIA	VARCHAR2(100)	,
ALIAS_1	VARCHAR2(100)	,
ALIAS_2	VARCHAR2(100)	,
ALIAS_3	VARCHAR2(100)	,
ALIAS_4	VARCHAR2(100)	,
ALIAS_5	VARCHAR2(100)	,
ALIAS_6	VARCHAR2(100)	,
ALIAS_7	VARCHAR2(100)	,
ALIAS_8	VARCHAR2(100)	,
ALIAS_9	VARCHAR2(100)	,
ALIAS_10	VARCHAR2(100)	,
COD_NACIONALIDAD	VARCHAR2(30)	,
ID_PASAPORTE	VARCHAR2(50)	,
ID_NACIONAL	VARCHAR2(50)	,
DIRECCION	VARCHAR2(500)	,
FEC_ADHESION	VARCHAR2(100)	,
OBSERVACIONES	VARCHAR2(500)	,
CODUSUARIO_ALTA	VARCHAR2(30)	,
FEC_ALTA	DATE
)
tablespace TS_SICASOC
;

-- =============================
-- Genera Primaty key
-- =============================
 
alter table PLD_LISTAS_CNSF
  add constraint PK_PLD_LISTAS_CNSF primary key (CODCIA,ID_LISTA)
   using index 
  tablespace TS_SICASOC
; 

-- =============================
-- Genera Indice
-- =============================
create  index PLD_LISTAS_CNSF_IDX_1 on PLD_LISTAS_CNSF(NOMBRE_1,CODCIA)
  tablespace TS_SICASOC
;
create  index PLD_LISTAS_CNSF_IDX_2 on PLD_LISTAS_CNSF(NOMBRE_2,CODCIA)
  tablespace TS_SICASOC
;
create  index PLD_LISTAS_CNSF_IDX_3 on PLD_LISTAS_CNSF(NOMBRE_3,CODCIA)
  tablespace TS_SICASOC
;
create  index PLD_LISTAS_CNSF_IDX_4 on PLD_LISTAS_CNSF(NOMBRE_4,CODCIA)
  tablespace TS_SICASOC
;
create  index PLD_LISTAS_CNSF_IDX_5 on PLD_LISTAS_CNSF(NOMBRE_5,CODCIA)
  tablespace TS_SICASOC
;

-- =============================
-- Genera los permisos
-- =============================
grant select, insert, update, delete, alter, index on PLD_LISTAS_CNSF to PUBLIC
;

-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM PLD_LISTAS_CNSF FOR PLD_LISTAS_CNSF
;

-- =============================
-- Crea Comentarios
-- =============================
comment on column PLD_LISTAS_CNSF.CODCIA is 'Clave de Compania';
comment on column PLD_LISTAS_CNSF.ID_LISTA is 'Identificador de lista';
comment on column PLD_LISTAS_CNSF.TP_MOVIMIENTO is 'Tipo de movimiento (TIPMOV)';
comment on column PLD_LISTAS_CNSF.DESCR_TP_MOVIMIENTO is 'Descripcion del tipo de movimiento (CAMBIO)';
comment on column PLD_LISTAS_CNSF.FEC_MOVIMIENTO is 'Fecha de movimiento';
comment on column PLD_LISTAS_CNSF.LISTA_ORIGEN is 'Lista de origen del reporte';
comment on column PLD_LISTAS_CNSF.FEC_COMUNICADO is 'Fecha de comunicado recibido';
comment on column PLD_LISTAS_CNSF.TIPO_PERSONA_CNSF is 'Tipo de persona CNSF (TIPPCN)';
comment on column PLD_LISTAS_CNSF.NOMBRE_1 is 'Nombre 1';
comment on column PLD_LISTAS_CNSF.NOMBRE_2 is 'Nombre 2';
comment on column PLD_LISTAS_CNSF.NOMBRE_3 is 'Nombre 3';
comment on column PLD_LISTAS_CNSF.NOMBRE_4 is 'Nombre 4';
comment on column PLD_LISTAS_CNSF.NOMBRE_5 is 'Nombre 5';
comment on column PLD_LISTAS_CNSF.FEC_NACIMIENTO is 'Fecha de nacimiento o lo que envien';
comment on column PLD_LISTAS_CNSF.PAIS_PROCEDENCIA is 'País de Procedencia';
comment on column PLD_LISTAS_CNSF.ALIAS_1 is 'Seudonimo 1';
comment on column PLD_LISTAS_CNSF.ALIAS_2 is 'Seudonimo 2';
comment on column PLD_LISTAS_CNSF.ALIAS_3 is 'Seudonimo 3';
comment on column PLD_LISTAS_CNSF.ALIAS_4 is 'Seudonimo 4';
comment on column PLD_LISTAS_CNSF.ALIAS_5 is 'Seudonimo 5';
comment on column PLD_LISTAS_CNSF.ALIAS_6 is 'Seudonimo 6';
comment on column PLD_LISTAS_CNSF.ALIAS_7 is 'Seudonimo 7';
comment on column PLD_LISTAS_CNSF.ALIAS_8 is 'Seudonimo 8';
comment on column PLD_LISTAS_CNSF.ALIAS_9 is 'Seudonimo 9';
comment on column PLD_LISTAS_CNSF.ALIAS_10 is 'Seudonimo 10';
comment on column PLD_LISTAS_CNSF.COD_NACIONALIDAD is 'Nacionalidad';
comment on column PLD_LISTAS_CNSF.ID_PASAPORTE is 'Numero de pasaporte';
comment on column PLD_LISTAS_CNSF.ID_NACIONAL is 'Identificador Nacional';
comment on column PLD_LISTAS_CNSF.DIRECCION is 'Direccion del reportado';
comment on column PLD_LISTAS_CNSF.FEC_ADHESION is 'Fecha de Adhesión a la lista';
comment on column PLD_LISTAS_CNSF.OBSERVACIONES is 'Observaciones ';
comment on column PLD_LISTAS_CNSF.CODUSUARIO_ALTA is 'Usuario que registra';
comment on column PLD_LISTAS_CNSF.FEC_ALTA is 'Fecha de registro';



/

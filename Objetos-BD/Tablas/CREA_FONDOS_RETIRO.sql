-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM FONDOS_RETIRO
; 
DROP TABLE FONDOS_RETIRO
;

CREATE TABLE FONDOS_RETIRO
(
CODCIA	NUMBER(14)	,
CODEMPRESA	NUMBER(14)	,
IDNEGOCIO	VARCHAR2(6)	,
IDSINIESTRO	NUMBER(14)	,
NOM_JUBILADO	VARCHAR2(300)	,
ID_RFC	VARCHAR2(20)	,
ID_EMPLEADO	VARCHAR2(20)	,
FEC_PAGO_FINIQUITO	DATE	,
FEC_NOTIFICACION	DATE	,
FEC_BAJA	DATE	,
IMPTE_PAGO	NUMBER(18,2)	,
USUARIO_REGISTRO	VARCHAR2(30)	,
FECHAREGISTRO	DATE
)
;

-- =============================
-- Genera Primaty key
-- =============================
 
--alter table FONDOS_RETIRO
--  add constraint PK_FONDOS_RETIRO primary key (XXXXXXXX); 
 
-- =============================
-- Genera Indice
-- =============================
create  index FONDOS_RETIRO_IDX_1 on FONDOS_RETIRO(IDSINIESTRO,IDNEGOCIO,CODCIA)
;
create  index FONDOS_RETIRO_IDX_2 on FONDOS_RETIRO(FEC_PAGO_FINIQUITO,IDNEGOCIO,CODCIA)
;
-- =============================
-- Genera los permisos
-- =============================
grant select, insert, update, delete, alter, index on FONDOS_RETIRO to PUBLIC
;
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM FONDOS_RETIRO FOR FONDOS_RETIRO
;
-- =============================
-- Crea Comentarios
-- =============================
comment on column FONDOS_RETIRO.CODCIA is 'Clave de Compañía';
comment on column FONDOS_RETIRO.CODEMPRESA is 'Clave de Empresa';
comment on column FONDOS_RETIRO.IDNEGOCIO is 'Tipo de negocio';
comment on column FONDOS_RETIRO.IDSINIESTRO is 'identificador de siniestro';
comment on column FONDOS_RETIRO.NOM_JUBILADO is 'Nombre del jubilado';
comment on column FONDOS_RETIRO.ID_RFC is 'RFC';
comment on column FONDOS_RETIRO.ID_EMPLEADO is 'Numero de empleado';
comment on column FONDOS_RETIRO.FEC_PAGO_FINIQUITO is 'Fecha de pago del finiquito';
comment on column FONDOS_RETIRO.FEC_NOTIFICACION is 'Fecha de notificación';
comment on column FONDOS_RETIRO.FEC_BAJA is 'Fecha de baja';
comment on column FONDOS_RETIRO.IMPTE_PAGO is 'Monto pagado';
comment on column FONDOS_RETIRO.USUARIO_REGISTRO is 'Usuario que registro';
comment on column FONDOS_RETIRO.FECHAREGISTRO is 'Fecha de registro';



/

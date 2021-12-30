-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM TEMP_CASTIGA_COMISIONES
;
DROP TABLE TEMP_CASTIGA_COMISIONES
;

CREATE TABLE TEMP_CASTIGA_COMISIONES
(
TIPO_DOCUMENTO 		VARCHAR2(6)  ,
NUM_DOCUMENTO		NUMBER(18),
ESTATUS_DOCUMENTO	VARCHAR2(5),
IDPOLIZA			NUMBER(14),
COD_AGENTE 		NUMBER(18),
IDCOMISION      		NUMBER(14),
ESTATUS_COMISION	VARCHAR2(5),
FEC_GENERACION		DATE,
FEC_ESTADO		DATE,
FEC_PROCESO		DATE,
APLICADO		VARCHAR2(1),
CAMPO_GENERAL		VARCHAR2(20),

CONSTRAINT CASTIGA_COMIS_PK PRIMARY KEY(TIPO_DOCUMENTO , NUM_DOCUMENTO, IDPOLIZA, COD_AGENTE, IDCOMISION)
)

TABLESPACE TS_SICASOC
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING
;
-- =============================
-- Genera los permisos
-- =============================
grant select, insert, update, delete, alter, index on TEMP_CASTIGA_COMISIONES to PUBLIC
;
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM TEMP_CASTIGA_COMISIONES FOR TEMP_CASTIGA_COMISIONES
;
-- =============================
-- Crea Comentarios
-- =============================
comment on column TEMP_CASTIGA_COMISIONES.TIPO_DOCUMENTO  			is 'Tipo de documento';
comment on column TEMP_CASTIGA_COMISIONES.NUM_DOCUMENTO  			is 'Numero de documento';
comment on column TEMP_CASTIGA_COMISIONES.ESTATUS_DOCUMENTO       		is 'Estatus Documento';
comment on column TEMP_CASTIGA_COMISIONES.IDPOLIZA	 			is 'NUmero de Poliza';
comment on column TEMP_CASTIGA_COMISIONES.COD_AGENTE	 		is 'Codigo Agente';
comment on column TEMP_CASTIGA_COMISIONES.IDCOMISION			is 'IDCOMISION';
comment on column TEMP_CASTIGA_COMISIONES.ESTATUS_COMISION	 		is 'Estatus Comision';
comment on column TEMP_CASTIGA_COMISIONES.FEC_GENERACION			is 'Fecha Generacion';
comment on column TEMP_CASTIGA_COMISIONES.FEC_ESTADO			is 'Fecha Estado';
comment on column TEMP_CASTIGA_COMISIONES.FEC_PROCESO			is 'Fecha Proceso';
comment on column TEMP_CASTIGA_COMISIONES.APLICADO				is 'Aplicado';
comment on column TEMP_CASTIGA_COMISIONES.CAMPO_GENERAL			is 'Campo General';
-----
/

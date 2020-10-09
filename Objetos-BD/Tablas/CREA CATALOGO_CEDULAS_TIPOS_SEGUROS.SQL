-- =============================
-- Crea Tabla
-- =============================
DROP PUBLIC SYNONYM CATALOGO_CEDULAS_TIPOS_SEGUROS
;
DROP TABLE CATALOGO_CEDULAS_TIPOS_SEGUROS
;

CREATE TABLE CATALOGO_CEDULAS_TIPOS_SEGUROS
(
CODEMPRESA      NUMBER(14)  ,
CODCIA        NUMBER(14)  ,
TIPO_CEDULA      VARCHAR2(20)  ,
IDTIPOSEG      VARCHAR2(6)  ,
STSREGISTRO      VARCHAR2(5) ,
FECHASTATUS  DATE,

CONSTRAINT cedulas_pk PRIMARY KEY(CODEMPRESA, CODCIA,TIPO_CEDULA,IDTIPOSEG )
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
grant select, insert, update, delete, alter, index on CATALOGO_CEDULAS_TIPOS_SEGUROS to PUBLIC
;
-- =============================
-- Crea el Sinónimo
-- =============================
CREATE or replace PUBLIC SYNONYM CATALOGO_CEDULAS_TIPOS_SEGUROS FOR CATALOGO_CEDULAS_TIPOS_SEGUROS
;
-- =============================
-- Crea Comentarios
-- =============================
comment on column CATALOGO_CEDULAS_TIPOS_SEGUROS.CODEMPRESA is 'Numero de empresa';
comment on column CATALOGO_CEDULAS_TIPOS_SEGUROS.CODCIA is 'Numero de compañía';
comment on column CATALOGO_CEDULAS_TIPOS_SEGUROS.TIPO_CEDULA is 'Tipo de Cedula';
comment on column CATALOGO_CEDULAS_TIPOS_SEGUROS.FECHASTATUS is 'Fecha Status';
comment on column CATALOGO_CEDULAS_TIPOS_SEGUROS.IDTIPOSEG is 'Tipo de Seguro';
comment on column CATALOGO_CEDULAS_TIPOS_SEGUROS.STSREGISTRO is 'Status de Registro';
/

-- =============================
-- Crea Tabla
-- =============================
DROP TABLE CONCEPTOS_ADICIONALES
;

CREATE TABLE CONCEPTOS_ADICIONALES
(
CODCONCEPTO			VARCHAR2(06)	,
CODCIA				NUMBER(14)	,
ESTADO				VARCHAR(06)	,
ORIGEN				VARCHAR(01)	)

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
/

-- =============================
-- Crea Comentarios
-- =============================
comment on column CONCEPTOS_ADICIONALES.CODCONCEPTO is 'Codigo de Concepto';
comment on column CONCEPTOS_ADICIONALES.CODCIA is 'Codigo de compañía';
comment on column CONCEPTOS_ADICIONALES.ESTADO is 'Estado';
comment on column CONCEPTOS_ADICIONALES.ORIGEN is 'Origen';

/

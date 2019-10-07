-- =============================
-- Crea Tabla
-- =============================
DROP TABLE PROVEEDOR_SAT_EVALCOMP
;

CREATE TABLE PROVEEDOR_SAT_EVALCOMP
(
CODCIA				NUMBER(14)	,
CONSECUTIVO			NUMBER(10)	,
ID_RFC				VARCHAR(30)	,
FECHA_EVALUACION		DATE,
NOM_CONTRIB			VARCHAR(500)	,
SIT_CONTRIB			VARCHAR(500)	,
OFI_PRESUNCION_1		VARCHAR(500)	,
PUB_SAT_PRESUNTOS		VARCHAR(500)	,
OFI_PRESUNCION_2		VARCHAR(500)	,
PUB_DOF_PRESUNTOS		VARCHAR(500)	,
PUB_SAT_DESVIRTUADOS		VARCHAR(500)	,
OFI_CONTRIB_DESVIRTUADOS	VARCHAR(500)	,
PUB_DOF_DESVIRTUADOS		VARCHAR(500)	,
OFI_DEFINITIVOS			VARCHAR(500)	,
PUB_SAT_DEFINITIVOS		VARCHAR(500)	,
PUB_DOF_DEFINITIVOS		VARCHAR(500)	,
OFI_SENTECIA_FAV		VARCHAR(500)	,
PUB_SAT_SENTENCIA_FAV		VARCHAR(500)	,
OFI_DOF_SENTENCIA_FAV		VARCHAR(500)	,
PUB_DOF_SENTENCIA_FAV		VARCHAR(500)	,
ENCONTRADO_EN	VARCHAR(500)	

)
;
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
comment on column PROVEEDOR_SAT_EVALCOMP.CODCIA is 'Numero de compa��a';
comment on column PROVEEDOR_SAT_EVALCOMP.CONSECUTIVO is 'No';
comment on column PROVEEDOR_SAT_EVALCOMP.ID_RFC is 'RFC';
comment on column PROVEEDOR_SAT_EVALCOMP.NOM_CONTRIB is 'Nombre del Contribuyente';
comment on column PROVEEDOR_SAT_EVALCOMP.SIT_CONTRIB is 'Situaci�n del contribuyente';
comment on column PROVEEDOR_SAT_EVALCOMP.OFI_PRESUNCION_1 is 'N�mero y fecha de oficio global de presunci�n';
comment on column PROVEEDOR_SAT_EVALCOMP.PUB_SAT_PRESUNTOS is 'Publicaci�n p�gina SAT presuntos';
comment on column PROVEEDOR_SAT_EVALCOMP.OFI_PRESUNCION_2 is 'N�mero y fecha de oficio global de presunci�n';
comment on column PROVEEDOR_SAT_EVALCOMP.PUB_DOF_PRESUNTOS is 'Publicaci�n DOF presuntos';
comment on column PROVEEDOR_SAT_EVALCOMP.PUB_SAT_DESVIRTUADOS is 'Publicaci�n p�gina SAT desvirtuados';
comment on column PROVEEDOR_SAT_EVALCOMP.OFI_CONTRIB_DESVIRTUADOS is 'N�mero y fecha de oficio global de contribuyentes que desvirtuaron';
comment on column PROVEEDOR_SAT_EVALCOMP.PUB_DOF_DESVIRTUADOS is 'Publicaci�n DOF desvirtuados';
comment on column PROVEEDOR_SAT_EVALCOMP.OFI_DEFINITIVOS is 'N�mero y fecha de oficio global de definitivos';
comment on column PROVEEDOR_SAT_EVALCOMP.PUB_SAT_DEFINITIVOS is 'Publicaci�n p�gina SAT definitivos';
comment on column PROVEEDOR_SAT_EVALCOMP.PUB_DOF_DEFINITIVOS is 'Publicaci�n DOF definitivos';
comment on column PROVEEDOR_SAT_EVALCOMP.OFI_SENTECIA_FAV is 'N�mero y fecha de oficio global de sentencia favorable';
comment on column PROVEEDOR_SAT_EVALCOMP.PUB_SAT_SENTENCIA_FAV is 'Publicaci�n p�gina SAT sentencia favorable';
comment on column PROVEEDOR_SAT_EVALCOMP.OFI_DOF_SENTENCIA_FAV is 'N�mero y fecha de oficio DOF global de sentencia favorable';
comment on column PROVEEDOR_SAT_EVALCOMP.PUB_DOF_SENTENCIA_FAV is 'Publicaci�n DOF sentencia favorable';
comment on column PROVEEDOR_SAT_EVALCOMP.FECHA_EVALUACION is 'Fecha de evaluacion';
comment on column PROVEEDOR_SAT_EVALCOMP.ENCONTRADO_EN	is 'Encontrado en';


/

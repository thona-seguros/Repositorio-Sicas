ALTER TABLE SINIESTRO
ADD
(
EMPRESA_LABORA	VARCHAR2(300)	,
IDCREDITO	VARCHAR2(30)	,
RFC_ASEGURADO	VARCHAR2(20)	,
TP_ASEGURADO	VARCHAR2(6)	
)
;

-- =============================
-- Crea Comentarios
-- =============================
comment on column SINIESTRO.EMPRESA_LABORA is 'Empresa en la que labora';
comment on column SINIESTRO.IDCREDITO is 'Numero de credito';
comment on column SINIESTRO.RFC_ASEGURADO is 'RFC del asegurado';
comment on column SINIESTRO.TP_ASEGURADO is 'Tipo de asegurado';

/

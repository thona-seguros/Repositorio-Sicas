-- =============================
-- Modifica tabla
-- =============================
--  
ALTER TABLE REP_LEGAL_PNJ
ADD
(
CODUSUARIO_ALTA	VARCHAR2(30) DEFAULT USER	,
FEC_ALTA	DATE	DEFAULT TRUNC(SYSDATE)
)
;

comment on column REP_LEGAL_PNJ.CODUSUARIO_ALTA is 'Usuario que registra';
comment on column REP_LEGAL_PNJ.FEC_ALTA is 'Fecha de registro';

-- =============================
-- Genera Indice
-- =============================
create  index REP_LEGAL_PNJ_IDX_1 on REP_LEGAL_PNJ(TIPO_DOC_REP_LEGAL,NUM_DOC_REP_LEGAL)
  tablespace TS_SICASOC
;

/



-- =============================
-- Genera secuencia
-- =============================
create sequence SICAS_OC.SQ_LOGCONFFACT
minvalue 1
maxvalue 99999999999999
start with 1
increment by 1
 NOCACHE
 NOCYCLE;
/

CREATE OR REPLACE PUBLIC SYNONYM  SQ_LOGCONFFACT FOR SICAS_OC.SQ_LOGCONFFACT;
/

GRANT SELECT ON SQ_LOGCONFFACT TO PUBLIC;
/
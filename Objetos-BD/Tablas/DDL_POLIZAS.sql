ALTER TABLE sicas_oc.polizas ADD (CODTIPONEGOCIO VARCHAR2(100 CHAR));
COMMENT ON COLUMN sicas_oc.polizas.CODTIPONEGOCIO IS 'Código tipo de negocio';
/
ALTER TABLE sicas_oc.polizas ADD (CODPAQCOMERCIAL VARCHAR2(250 CHAR));
COMMENT ON COLUMN sicas_oc.polizas.CODPAQCOMERCIAL IS 'Código paquete comercial';
/
ALTER TABLE sicas_oc.polizas ADD (CODOFICINA VARCHAR2(8 CHAR));
COMMENT ON COLUMN sicas_oc.polizas.CODOFICINA IS 'Código de oficina comercial';
/
ALTER TABLE sicas_oc.polizas add (CODCATEGO VARCHAR2(14 CHAR));
COMMENT ON COLUMN sicas_oc.polizas.CODCATEGO IS 'Sub nivel del tipo de negocio';
/



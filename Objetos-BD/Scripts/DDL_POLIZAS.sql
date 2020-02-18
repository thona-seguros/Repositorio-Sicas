ALTER TABLE sicas_oc.polizas ADD (CODTIPONEGOCIO VARCHAR2(100 CHAR));
COMMENT ON COLUMN sicas_oc.polizas.CODTIPONEGOCIO IS 'C�digo tipo de negocio';
/
ALTER TABLE sicas_oc.polizas ADD (CODPAQCOMERCIAL VARCHAR2(250 CHAR));
COMMENT ON COLUMN sicas_oc.polizas.CODPAQCOMERCIAL IS 'C�digo paquete comercial';
/
ALTER TABLE sicas_oc.polizas ADD (CODOFICINA VARCHAR2(8 CHAR));
COMMENT ON COLUMN sicas_oc.polizas.CODOFICINA IS 'C�digo de oficina comercial';
/
ALTER TABLE sicas_oc.polizas add (CODCATEGO VARCHAR2(14 CHAR));
COMMENT ON COLUMN sicas_oc.polizas.CODCATEGO IS 'Sub nivel del tipo de negocio';
/



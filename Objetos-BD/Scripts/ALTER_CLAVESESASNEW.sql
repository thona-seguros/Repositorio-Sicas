/*ALTER TABLE SICAS_OC.COBERTURAS_DE_SEGUROS ADD NUMDIASRENTA NUMBER(3);
/

alter table COBERTURAS_DE_SEGUROS drop column  NUMDIASRENTA
*/
ALTER TABLE SICAS_OC.COBERTURAS_DE_SEGUROS ADD CLAVESESASNEW VARCHAR2(3);
/

--COMMENT ON COLUMN SICAS_OC.COBERTURAS_DE_SEGUROS.NUMDIASRENTA IS 'N�mero de d�as de renta';
COMMENT ON COLUMN SICAS_OC.COBERTURAS_DE_SEGUROS.CLAVESESASNEW IS 'Nueva clave de coberturas al cat�logo 239 ramos 11 y12, cat 9.2 ramo 31 y 33, cat 255 ramo 34 y 36';
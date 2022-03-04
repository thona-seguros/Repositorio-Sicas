ALTER TABLE COBERTURAS_DE_SEGUROS ADD (IDRAMOREAL VARCHAR2(6 CHAR));
/
COMMENT ON COLUMN COBERTURAS_DE_SEGUROS.IDRAMOREAL IS 'Si el indicador de la poliza es multiramo, se define cual es el ramo real en la cobertura';
/


ALTER TABLE SICAS_OC.COBERTURAS ADD (IDRAMOREAL VARCHAR2(6 CHAR));
/
COMMENT ON COLUMN SICAS_OC.COBERTURAS.IDRAMOREAL IS 'Si el indicador de la poliza es multiramo, se define cual es el ramo real en la cobertura';
/

ALTER TABLE COBERT_ACT_ASEG ADD (IDRAMOREAL VARCHAR2(6 CHAR));
/
COMMENT ON COLUMN COBERT_ACT_ASEG.IDRAMOREAL IS 'Si el indicador de la poliza es multiramo, se define cual es el ramo real en la cobertura';
/


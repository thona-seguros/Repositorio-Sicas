Insert into FACT_ELECT_OBJETO_IMPUESTO (CODCIA,CODOBJETOIMP,DESCOBJETOIMP,FECINIVIG,FECFINVIG,CODUSUARIO,FECMOD) values (1,'04','S� OBJETO DEL IMPUESTO Y NO CAUSA IMPUESTO.',to_date('01/01/2022','DD/MM/RRRR'),to_date('31/12/9999','DD/MM/RRRR'),'SICAS_OC',to_date('03/03/2023','DD/MM/RRRR'));
/

UPDATE CAT_REGIMEN_FISCAL SET TIPOPERSONA = 'F' WHERE IDREGFISSAT = 607;
UPDATE CAT_REGIMEN_FISCAL SET TIPOPERSONA = 'M' WHERE IDREGFISSAT = 622;
UPDATE CAT_REGIMEN_FISCAL SET STSTIPREGFISC = 'INA' WHERE IDREGFISSAT IN (628,629,630,640);
--610 Y 626 SE DEJAN COMO ESTAN AUNQUE DEBEN SER F Y M
/
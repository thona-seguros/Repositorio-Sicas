Insert into ENDOSO_TXT_ENC (CODCIA,CODENDOSO,DESCRIPCION,ESTADO,INDUSOTEXTO,TIPOTEXTO,TIPONOTI,FECHAINICIO,FECHAFINAL) 
values (1,'AJUAPORTE','AJUSTE APORTE DE AHORRO FONDOS','ACTIVO','ENDOSO','END',null,to_date('01/01/2021','DD/MM/RRRR'),to_date('31/12/9999','DD/MM/RRRR'));
/
Insert into ENDOSO_TXT_DET (CODCIA,CODENDOSO,TEXTO) 
values (1,'AJUAPORTE','Se emite el endoso por cambio en el monto de ahorro a fondos de ahorro, esto generara un ajuste en el monto realizado en el cargo automatico a su tarjeta de credito...');

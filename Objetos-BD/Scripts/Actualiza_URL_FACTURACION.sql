UPDATE PARAMETROS_GLOBALES
SET    DESCRIPCION = 'http://sicascloud:8082/FactThonaIISNew/FactThonaIIS40.asmx/EnviaFacturemosYa'
WHERE  CODIGO = '023';
/
UPDATE PARAMETROS_GLOBALES
SET    DESCRIPCION = 'http://sicascloud:8082/FactThonaIISNew/FactThonaIISCancelar.asmx/CancelarCFDI'
WHERE  CODIGO = '027';
/
UPDATE WEB_SERVICES SET URL = 'http://sicascloud:8082/FactThonaIISNew/FactThonaIISCancelar.asmx?WSDL'
WHERE IDWEB IN (4000,5000);
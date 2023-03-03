INSERT INTO FACT_ELECT_CONF_DOCTO
   VALUES (SQ_IDIDNTFACELEC.NEXTVAL, 1, '4.0', 'IGL', 'EMI', 3, 'N', 'N', NULL, NULL, 'N', 'N');  
/
INSERT INTO FACT_ELECT_CONF_DOCTO
   VALUES (SQ_IDIDNTFACELEC.NEXTVAL, 1, '4.0', 'IGL', 'PAG', 3, NULL, NULL, NULL, NULL, 'N', NULL);   
/
UPDATE FACT_ELECT_CONF_DOCTO
   SET CODIDENTIFICADOR = 'EMI'
 WHERE CODIDENTIFICADOR = 'REF';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET CODIDENTIFICADOR = 'EMI'
 WHERE CODIDENTIFICADOR = 'REF';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET CODRUTINACALC = 'EMIVAL01'
 WHERE CODIDENTIFICADOR = 'EMI';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET CODATRIBUTO = 'País'
 WHERE CODIDENTIFICADOR = 'DOR' 
   AND CODATRIBUTO = 'pais';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET CONDICIONATRIBUTO = 'R'
 WHERE CODIDENTIFICADOR = 'DOR'
   AND CODATRIBUTO = 'codigoPostal';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET CONDICIONATRIBUTO = 'R',
       INDENVIACIA = NULL
 WHERE CODIDENTIFICADOR = 'COM'
   AND CODATRIBUTO = 'folio';   
/
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO 
     VALUES (1, 18, 'CON', 'ObjetoImp', 10, 'R', 'D', NULL, NULL, 'N', 'CONVAL10'); --- CONVAL10: habra que cambiarlo en el proceso a CONVAL11
/
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO 
     VALUES (1, 125, 'CON', 'ObjetoImp', 10, 'R', 'F', '01', NULL, 'N', 'CONVAL10'); --- CONVAL10: habra que cambiarlo en el proceso a CONVAL11
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET ORDENATRIB = 11,
       CODRUTINACALC = 'CONVAL11'
 WHERE IDIDENTIFICADOR = 18
   AND CODIDENTIFICADOR = 'CON'
   AND CODATRIBUTO = 'observaciones';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET ORDENATRIB = 11,
       CODRUTINACALC = 'CONVAL11'
 WHERE IDIDENTIFICADOR = 125
   AND CODIDENTIFICADOR = 'CON'
   AND CODATRIBUTO = 'observaciones';
/
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO 
     VALUES (1, 18, 'CON', 'codIntProd', 12, 'O', 'D', NULL, NULL, 'S', 'CONVAL12'); 
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET CONDICIONATRIBUTO = 'C'
 WHERE CODIDENTIFICADOR = 'TRA'
   AND CODATRIBUTO IN ('TasaOCuota','importe');
/

DELETE DETALLE_FACT_ELECT_CONF_DOCTO
 WHERE CODIDENTIFICADOR = 'ADI'
   AND CODATRIBUTO = 'webSucursal';
/   
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET VALORATRIBUTO = '4.0'
 WHERE CODIDENTIFICADOR = 'COM'
   AND CODATRIBUTO = 'version';
/
UPDATE FACT_ELECT_CONF_DOCTO
   SET INDVENTAPUBLICOGENERAL = 'S'
 WHERE CODIDENTIFICADOR = 'IGL';
/
INSERT INTO Fact_Elect_Cat_Gpo_Linea
     VALUES (1, 'IGL', '(Condicional) Línea para precisar la información relacionada con el comprobante global. Si el valor registrado en el Rfc del Receptor contiene XAXX010101000 y el valor registrado en el nombre del Receptor contiene el valor “PUBLICO EN GENERAL” esta línea debe existir', '4.0', USER, TRUNC(SYSDATE));
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'IGL', 'Periodicidad', 'Atributo para expresar el período al que corresponde la
información del comprobante global.
Si el valor de este atributo contiene la clave “05” el campo “Regimen” de la línea “EMI” debe contener el valor “621”.', 'IGLVAL01');
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'IGL', 'Meses', 'Atributo para expresar el mes o los meses al que corresponde la información del comprobante global.
• Si el atributo Periodicidad contiene el valor “05”, este atributo debe contener alguno de los valores “13”, “14”, “15”, “16”, “17” o “18”.
• Si el atributo Periodicidad contiene un valor diferente de “05”, este atributo debe contener alguno de los valores “01”, “02”, “03”, “04”, “05”, “06”, “07”, “08”, “09”, “10”, “11” o “12”.', 'IGLVAL02');
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'IGL', 'Año', 'Atributo para expresar el año al que corresponde la información del comprobante global.
El valor de este atributo debe ser igual al año en curso o al año inmediato anterior. Para validar el año en curso o el año inmediato anterior se debe considerar el registrado en el
atributo Fecha.', 'IGLVAL03');
/
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 100, 'IGL', 'Periodicidad', 1, 'R', 'F', '01', NULL, NULL, 'IGLVAL01');
/
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 100, 'IGL', 'Meses', 2, 'R', 'D', NULL, NULL, NULL, 'IGLVAL02');      
/     
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 100, 'IGL', 'Año', 3, 'R', 'D', NULL, 'SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL', NULL, 'IGLVAL03');  
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET CONDICIONATRIBUTO = 'R',
       INDENVIACIA = 'N'
 WHERE CODIDENTIFICADOR = 'REC'
   AND CODATRIBUTO = 'nombre';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET CONDICIONATRIBUTO = 'C',
       INDENVIACIA = 'N'
 WHERE CODIDENTIFICADOR = 'REC'
   AND CODATRIBUTO = 'NumRegIdTrib';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET TIPOVALORATRIBUTO = 'D',
       VALORATRIBUTO = NULL
 WHERE CODIDENTIFICADOR = 'REC'
   AND CODATRIBUTO = 'UsoCFDI'
   AND IDIDENTIFICADOR = 16;
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET ORDENATRIB = 14,
       CODRUTINACALC = 'COMVAL14'
 WHERE CODIDENTIFICADOR = 'COM'
   AND CODATRIBUTO = 'MetodoPago';
/
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 14, 'COM', 'Exportacion', 13, 'R', 'D', NULL, NULL, NULL, 'COMVAL13');  
/
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 102, 'COM', 'Exportacion', 13, 'R', 'F', '01', NULL, NULL, 'COMVAL13');       
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET TIPOVALORATRIBUTO = 'F',
       VALORATRIBUTO = '01'
 WHERE CODIDENTIFICADOR = 'COM'
   AND CODATRIBUTO = 'Exportacion';
/

UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET ORDENATRIB = 6,
       CODRUTINACALC = 'RECVAL06'
 WHERE CODIDENTIFICADOR = 'REC'
   AND CODATRIBUTO = 'clave';
/
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 16, 'REC', 'RegimenFiscalReceptor', 5, 'R', 'D', NULL, NULL, NULL, 'RECVAL05');  
/
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 123, 'REC', 'RegimenFiscalReceptor', 5, 'R', 'D', NULL, NULL, NULL, 'RECVAL05');  
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET ORDENATRIB = 2,
       CODRUTINACALC = 'TRAVAL02'
WHERE CODIDENTIFICADOR = 'TRA'   
AND CODATRIBUTO = 'impuesto';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET ORDENATRIB = 2,
       CODRUTINACALC = 'TRAVAL02'
WHERE CODIDENTIFICADOR = 'TRA'   
AND CODATRIBUTO = 'impuesto';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET ORDENATRIB = 2,
       CODRUTINACALC = 'TRAVAL02'
WHERE CODIDENTIFICADOR = 'TRA'   
AND CODATRIBUTO = 'impuesto';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET ORDENATRIB = 2,
       CODRUTINACALC = 'TRAVAL02'
WHERE CODIDENTIFICADOR = 'TRA'   
AND CODATRIBUTO = 'impuesto';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET ORDENATRIB = 2,
       CODRUTINACALC = 'TRAVAL02'
WHERE CODIDENTIFICADOR = 'TRA'   
AND CODATRIBUTO = 'impuesto';
/
Insert into DETALLE_FACT_ELECT_CONF_DOCTO (CODCIA,IDIDENTIFICADOR,CODIDENTIFICADOR,CODATRIBUTO,ORDENATRIB,CONDICIONATRIBUTO,TIPOVALORATRIBUTO,VALORATRIBUTO,CONSULTA,INDENVIACIA,CODRUTINACALC) 
values (1,20,'TRA','Base',1,'R','D',null, EMPTY_CLOB(),'N','TRAVAL01');
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET INDENVIACIA = 'S'
 WHERE CODIDENTIFICADOR = 'CON'
   AND CODATRIBUTO = 'noIdentificacion';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET TIPOVALORATRIBUTO = 'D',
       VALORATRIBUTO = NULL
 WHERE CODIDENTIFICADOR = 'COM'
   AND CODATRIBUTO = 'condicionesDePago';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET TIPOVALORATRIBUTO = 'D',
       VALORATRIBUTO = NULL
 WHERE CODIDENTIFICADOR = 'COM'
   AND CODATRIBUTO = 'MetodoPago';
/
DELETE FACT_ELECT_CONF_DOCTO
WHERE PROCESO = 'PAG'
AND CODIDENTIFICADOR = 'IGL';
/
INSERT INTO Fact_Elect_Cat_Gpo_Linea
     VALUES (1, 'PAGST', 'Línea requerida para especificar el monto total de los pagos y el total de los impuestos, deben ser expresados en MXN. (Esta línea no se debe de repetir)', '4.0', USER, TRUNC(SYSDATE));
/
INSERT INTO Fact_Elect_Cat_Gpo_Linea
     VALUES (1, 'PAGSPIMTRA', 'Línea condicional para señalar los impuestos trasladados aplicables conforme al monto del pago recibido. Es requerido cuando en los documentos relacionados se registre algún impuesto trasladado. (Esta línea deberá de ir después del pago correspondiente)', '4.0', USER, TRUNC(SYSDATE));     
/
INSERT INTO Fact_Elect_Cat_Gpo_Linea
     VALUES (1, 'PAGSPDOCIMTRA', 'Línea opcional para capturar los impuestos trasladados aplicables conforme al monto del pago recibido. Por cada impuesto trasladado que aplique al documento relacionado se debe generar una línea PAGSPDOCIMTRA. (Esta línea deberá de ir después de la línea PAGSPDOC)', '4.0', USER, TRUNC(SYSDATE));     
/
INSERT INTO FACT_ELECT_CONF_DOCTO 
   VALUES (SQ_IDIDNTFACELEC.NEXTVAL, 1, '4.0', 'PAGST', 'PAG', 15, 'N', 'N', NULL, NULL, 'N', 'N');  
/
INSERT INTO FACT_ELECT_CONF_DOCTO 
   VALUES (SQ_IDIDNTFACELEC.NEXTVAL, 1, '4.0', 'PAGSPIMTRA', 'PAG', 19, 'S', 'N', NULL, NULL, 'N', 'N');  
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET CONDICIONATRIBUTO = 'O',
       INDENVIACIA = 'N'
 WHERE CODIDENTIFICADOR = 'PAGS'  
   AND CODATRIBUTO = 'Version';
/
UPDATE FACT_ELECT_CONF_DOCTO 
   SET CODIDENTIFICADOR = 'PAGSP'
 WHERE IDIDENTIFICADOR = 126
   AND CODIDENTIFICADOR = 'PAGS'
   AND PROCESO = 'PAG';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET CODIDENTIFICADOR = 'PAGSP',
       CODRUTINACALC = REPLACE(CODRUTINACALC,'PAGS','PAGSP')
 WHERE IDIDENTIFICADOR = 126
   AND CODIDENTIFICADOR = 'PAGS';
/
UPDATE FACT_ELECT_CONF_DOCTO 
   SET CODIDENTIFICADOR = 'PAGSPDOC'
 WHERE IDIDENTIFICADOR = 127
   AND CODIDENTIFICADOR = 'PAGSDOCREL'
   AND PROCESO = 'PAG';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET CODIDENTIFICADOR = 'PAGSPDOC',
       CODRUTINACALC = REPLACE(CODRUTINACALC,'PAGSDOCREL','PAGSPDOC')
 WHERE IDIDENTIFICADOR = 127
   AND CODIDENTIFICADOR = 'PAGSDOCREL';
/
UPDATE Fact_Elect_Cat_Campos_Cfdi
   SET CODIDENTIFICADOR = 'PAGSP'
 WHERE CODIDENTIFICADOR = 'PAGS';
/
UPDATE Fact_Elect_Cat_Campos_Cfdi
   SET CODIDENTIFICADOR = 'PAGSPDOC'
 WHERE CODIDENTIFICADOR = 'PAGSDOCREL';
/
UPDATE Fact_Elect_Cat_Campos_Cfdi
   SET CODRUTINACALC = REPLACE(CODRUTINACALC,'PAGS','PAGSP')
 WHERE CODIDENTIFICADOR = 'PAGSP';
/
UPDATE Fact_Elect_Cat_Campos_Cfdi
   SET CODRUTINACALC = REPLACE(CODRUTINACALC, 'PAGSDOCREL', 'PAGSPDOC')
 WHERE CODIDENTIFICADOR = 'PAGSPDOC';
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGST', 'TotalRetencionesIVA', 'Campo para expresar el total de los impuestos retenidos de IVA que se desprenden de los pagos. No se permiten valores negativos.
• Debe ser igual al redondeo de la suma del resultado de multiplicar cada uno de los importes de los campos ImporteP de los impuestos retenidos registrados en el elemento RetencionP donde el campo ImpuestoP contenga el valor IVA por el valor registrado en el campo TipoCambioP de cada nodo Pago.', 'PAGSTVAL01'); 
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGST', 'TotalRetencionesISR', 'Campo para expresar el total de los impuestos retenidos de ISR que se desprenden de los pagos. No se permiten valores negativos.
• Debe ser igual al redondeo de la suma del resultado de multiplicar cada uno de los importes de los campos ImporteP de los impuestos retenidos registrados en el elemento RetencionP donde el campo ImpuestoP contenga el valor ISR por el valor registrado en el campo TipoCambioP de cada nodo Pago.', 'PAGSTVAL02'); 
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGST', 'TotalRetencionesIEPS', 'Campo para expresar el total de los impuestos retenidos de IEPS que se desprenden de los pagos. No se permiten valores negativos.
• Debe ser igual al redondeo de la suma del resultado de multiplicar cada uno de los importes de los campos ImporteP de los impuestos retenidos registrados en el elemento RetencionP donde el campo ImpuestoP contenga el valor IEPS por el valor registrado en el campo TipoCambioP de cada nodo Pago.', 'PAGSTVAL03');
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGST', 'TotalTrasladosBaseIVA16', 'Campo para expresar el total de la base de IVA trasladado a la tasa del 16% que se desprende de los pagos. No se permiten valores negativos.
• Debe ser igual al redondeo de la suma del resultado de multiplicar cada uno de los importes de los campos BaseP de los impuestos trasladados registrados en el elemento TrasladoP donde los campos contengan en ImpuestoP el valor IVA, en 23 TipoFactorP el valor Tasa y en TasaOCuotaP el valor 0.160000, por el valor registrado en el campo TipoCambioP de cada nodo Pago.', 'PAGSTVAL04');
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGST', 'TotalTrasladosImpuestoIVA16', 'Campo para expresar el total de los impuestos de IVA trasladado a la tasa del 16% que se desprenden de los pagos. No se permiten valores negativos.
• Debe ser igual al redondeo de la suma del resultado de multiplicar cada uno de los importes de los campos ImporteP de los impuestos trasladados registrados en el elemento TrasladoP donde los campos contengan en ImpuestoP el valor IVA, en TipoFactorP el valor Tasa y enTasaOCuotaP el valor 0.160000, por el valor registrado en el campo TipoCambioP de cada nodo Pago.', 'PAGSTVAL05');
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGST', 'TotalTrasladosBaseIVA8', 'Campo para expresar el total de la base de IVA trasladado a la tasa del 8% que se desprende de los pagos. No se permiten valores negativos.
• Debe ser igual al redondeo de la suma del resultado de multiplicar cada uno de los importes de los campos BaseP de los impuestos trasladados registrados en el elemento TrasladoP donde los campos contengan en ImpuestoP el valor IVA, en TipoFactorpP el valor Tasa y en TasaOCuotaP el valor 0.080000, por el valor registrado en el campo TipoCambioP de cada nodo Pago.', 'PAGSTVAL06');
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGST', 'TotalTrasladosImpuestoIVA8', 'Campo para expresar el total de los impuestos de IVA trasladado a la tasa del 8% que se desprenden de los pagos. No se permiten valores negativos.
• Debe ser igual al redondeo de la suma del resultado de multiplicar cada uno de los importes de los campos ImporteP de los impuestos trasladados registrados en el elemento TrasladoP donde los campos contengan en ImpuestoP el valor IVA, en TipoFactorP el valor Tasa y enTasaOCuotaP el valor 0.080000, por el valor registrado en el campo TipoCambioP de cada nodo Pago.', 'PAGSTVAL07');
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGST', 'TotalTrasladosBaseIVA0', 'Campo para expresar el total de la base de IVA trasladado a la tasa del 0% que se desprende de los pagos. No se permiten valores negativos.
• Debe ser igual al redondeo de la suma del resultado de multiplicar cada uno de los importes de los campos BaseP de los impuestos trasladados registrados en el elemento TrasladoP donde los campos contengan en ImpuestoP el valor IVA, en TipoFactorP el valor Tasa y en TasaOCuotaP el valor 0.000000, por el valor registrado en el campo TipoCambioP de cada nodo Pago.', 'PAGSTVAL08');
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGST', 'TotalTrasladosImpuestoIVA0', 'Campo para expresar el total de los impuestos de IVA trasladado a la tasa del 0% que se desprenden de los pagos. No se permiten valores negativos.
• Debe ser igual al redondeo de la suma del resultado de multiplicar cada uno de los importes de los campos ImporteP de los impuestos trasladados registrados en el elemento TrasladoP donde los campos contengan en ImpuestoP el valor IVA, en TipoFactorP el valor Tasa y en TasaOCuotaP el valor 0.000000, por el valor registrado en el campo TipoCambioP de cada nodo Pago.', 'PAGSTVAL09');
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGST', 'TotalTrasladosBaseIVAExento', 'Campo para expresar el total de la base de IVA trasladado exento que se desprende de los pagos. No se permiten valores negativos.
• Debe ser igual al redondeo de la suma del resultado de multiplicar cada uno de los importes de los campos BaseP de los impuestos trasladados registrados en el elemento TrasladoP donde los campos contengan en ImpuestoP el valor IVA y en TipoFactorP el valor Exento, por el valor registrado en el campo TipoCambioP de cada nodo Pago.', 'PAGSTVAL10');
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGST', 'MontoTotalPagos', 'Campo para expresar el total de los pagos que se desprenden de los nodos Pago. No se permiten valores negativos.
• El valor de este campo debe ser igual al redondeo de la suma del resultado de multiplicar cada uno de los campos Monto por el valor registrado en el campo TipoCambioP de cada nodo Pago.', 'PAGSTVAL11');
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGSPIMTRA', 'BaseP', 'Debe existir al menos uno de los atributos TotalTrasladadosBaseIVA16, TotalTrasladadosBaseIVA8, TotalTrasladadosBaseIVA0, TotalTrasladosBaseIVAExento
Debe ser igual a la suma de los importes de los atributos BaseDR registrados en los documentos relacionados donde el impuesto del documento relacionado sea igual al atributo ImpuestoP de este elemento y la TasaOCuotaDR del documento relacionado sea igual al atributo TasaOCuotaP de este elemento.
En caso de que solo existan documentos relacionados con TipoFactorDR Exento, la suma de este atributo debe ser igual a la suma de los importes de los atributos BaseDR registrados en los documentos relacionados. La suma debe considerar todos los importes de los atributos BaseDR de cada uno de los documentos relacionados que existan:
Calcular la suma como: (BaseDR/EquivalenciaDR) + (BaseDR/EquivalenciaDR) + N…
Ejemplo: Moneda: USD, importe: 100,000.00 EquivalenciaDR: 1.329310
Moneda: MXN, importe: 1,773,309.77
EquivalenciaDR: 23.5728
Resultado se expresa a la moneda de pago, para este ejemplo son Euros: (100,000.00/1.329310) + (1,773,309.770000/23.5728) = 150,453.9442.', 'PAGSPIMTRAVAL01'); 
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGSPIMTRA', 'ImpuestoP', 'Se debe registrar la clave del tipo de impuesto trasladado conforme al monto del pago, mismas que se encuentran incluidas en el catálogo c_Impuesto publicado en el Portal del SAT Debe existir sólo un registro con la misma combinación de impuesto, factor y tasa por cada traslado.', 'PAGSPIMTRAVAL02'); 
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGSPIMTRA', 'TipoFactorP', 'Se debe registrar la clave del tipo de factor que se aplica a la base del impuesto, mismas que se encuentran incluidas en el catálogo c_TipoFactor publicado en el Portal del SAT.', 'PAGSPIMTRAVAL03'); 
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGSPIMTRA', 'TasaOCuotaP', 'Se puede registrar el valor de la tasa o cuota del impuesto que se traslada en los documentos relacionados. El valor seleccionado debe corresponder a un valor del catálogo c_TasaOCuota donde la columna impuesto corresponda con el campo ImpuestoP y la columna factor corresponda con el campo TipoFactorP.', 'PAGSPIMTRAVAL04'); 
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGSPIMTRA', 'ImporteP', 'Se puede registrar la suma del impuesto trasladado, agrupado por ImpuestoP, TipoFactorP y TasaOCuotaP. No se permiten valores negativos.
Debe existir al menos uno de los campos TotalTrasladadosImpuestoIVA16, TotalTrasladadosImpuestoIVA8, TotalTrasladadosImpuestoIVA0.
Debe ser igual a la suma de los importes de los atributos ImporteDR registrados en los documentos relacionados donde el impuesto del documento relacionado sea igual al atributo ImpuestoP de este elemento y la TasaOCuotaDR del documento relacionado sea igual al atributo TasaOCuotaP de este elemento.
La suma debe considerar todos los importes de los atributos ImporteDR de cada uno de los documentos relacionados que existan:
Calcular la suma como: (ImporteDR/EquivalenciaDR) + (ImporteDR/EquivalenciaDR) + N…
Ejemplo: Moneda: USD, importe: 100,000.00 EquivalenciaDR: 1.329310
Moneda: MXN, importe: 1,773,309.77
EquivalenciaDR: 23.5728
Resultado se expresa a la moneda de pago, para este ejemplo son Euros: (100,000.00/1.329310) + (1,773,309.770000/23.5728) = 150,453.9442.', 'PAGSPIMTRAVAL05'); 
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGSPDOCIMTRA', 'BaseDR', 'Se debe registrar el valor de la base para el cálculo del impuesto trasladado conforme al monto del pago, aplicable al documento relacionado, la determinación de la base se realiza de acuerdo con las disposiciones fiscales vigentes. No se permiten valores negativos.
El valor de este campo debe ser mayor que cero.', 'PAGSPDOCIMTRAVAL01'); 
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGSPDOCIMTRA', 'ImpuestoDR', 'Se debe registrar la clave del tipo de impuesto trasladado conforme al monto del pago aplicable al documento relacionado.', 'PAGSPDOCIMTRAVAL02'); 
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGSPDOCIMTRA', 'TipoFactorDR', 'Se debe registrar la clave del tipo de factor que se aplica a la base del impuesto, el cual se encuentra incluido en el catálogo c_TipoFactor publicado en el Portal del SAT.', 'PAGSPDOCIMTRAVAL03');       
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGSPDOCIMTRA', 'TasaOCuotaDR', 'Se puede registrar el valor de la tasa o cuota del impuesto que se traslada. Es requerido cuando el campo TipoFactorDR contenga una clave que corresponda a Tasa o Cuota.
• Si el valor registrado es fijo debe corresponder a un valor del catálogo c_TasaOCuota, coincidir con el tipo de impuesto registrado en el campo ImpuestoDR y el factor debe corresponder con el campo TipoFactorDR.
• Si el valor registrado es variable, debe corresponder al rango entre el valor mínimo y el valor máximo señalado en el catálogo.', 'PAGSPDOCIMTRAVAL04');       
/
INSERT INTO Fact_Elect_Cat_Campos_Cfdi
      VALUES (1, 'PAGSPDOCIMTRA', 'ImporteDR', 'Se puede registrar el importe del impuesto trasladado conforme al monto del pago, aplicable al documento relacionado. No se permiten valores negativos. Es requerido cuando el tipo factor sea Tasa o Cuota.
• Calcular el límite inferior como: (BaseDR - 10-NumDecimalesBaseDR /2)*(TasaOCuotaDR) y este resultado truncado con la cantidad de decimales que tenga registrado este atributo.
• Calcular el límite superior como: (BaseDR + 10-NumDecimalesBaseDR/2 - 10-12) *(TasaOCuotaDR) y este resultado redondearlo hacia arriba con la cantidad de decimales que tenga registrado este atributo.
• El valor de este atributo debe ser mayor o igual que el límite inferior y menor o igual que el límite superior.', 'PAGSPDOCIMTRAVAL05');       
/
INSERT INTO FACT_ELECT_CONF_DOCTO
   VALUES (SQ_IDIDNTFACELEC.NEXTVAL, 1, '4.0', 'PAGSPDOCIMTRA', 'PAG', 18, NULL, NULL, NULL, NULL, 'N', NULL);   
/   
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 128, 'PAGSPDOCIMTRA', 'BaseDR', 1, 'R', 'D', NULL, NULL, NULL, 'PAGSPDOCIMTRAVAL01');
/   
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 128, 'PAGSPDOCIMTRA', 'ImpuestoDR', 2, 'R', 'D', NULL, NULL, NULL, 'PAGSPDOCIMTRAVAL02');   
/   
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 128, 'PAGSPDOCIMTRA', 'TipoFactorDR', 3, 'R', 'D', NULL, NULL, NULL, 'PAGSPDOCIMTRAVAL03');      
/   
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 128, 'PAGSPDOCIMTRA', 'TasaOCuotaDR', 4, 'R', 'D', NULL, NULL, NULL, 'PAGSPDOCIMTRAVAL04');      
/   
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 128, 'PAGSPDOCIMTRA', 'ImporteDR', 5, 'R', 'D', NULL, NULL, NULL, 'PAGSPDOCIMTRAVAL05');        
/   
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 120, 'PAGST', 'TotalRetencionesIVA', 1, 'C', 'D', NULL, NULL, NULL, 'PAGSTVAL01');
/      
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 120, 'PAGST', 'TotalRetencionesISR', 2, 'C', 'D', NULL, NULL, NULL, 'PAGSTVAL02');
/      
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 120, 'PAGST', 'TotalRetencionesIEPS', 3, 'C', 'D', NULL, NULL, NULL, 'PAGSTVAL03');
/      
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 120, 'PAGST', 'TotalTrasladosBaseIVA16', 4, 'C', 'D', NULL, NULL, NULL, 'PAGSTVAL04');
/      
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 120, 'PAGST', 'TotalTrasladosImpuestoIVA16', 5, 'C', 'D', NULL, NULL, NULL, 'PAGSTVAL05');      
/      
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 120, 'PAGST', 'TotalTrasladosBaseIVA8', 6, 'C', 'D', NULL, NULL, NULL, 'PAGSTVAL06'); 
/      
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 120, 'PAGST', 'TotalTrasladosImpuestoIVA8', 7, 'C', 'D', NULL, NULL, NULL, 'PAGSTVAL07');
/      
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 120, 'PAGST', 'TotalTrasladosBaseIVA0', 8, 'C', 'D', NULL, NULL, NULL, 'PAGSTVAL08');      
/      
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 120, 'PAGST', 'TotalTrasladosImpuestoIVA0', 9, 'C', 'D', NULL, NULL, NULL, 'PAGSTVAL09');
/      
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 120, 'PAGST', 'TotalTrasladosBaseIVAExento', 10, 'C', 'D', NULL, NULL, NULL, 'PAGSTVAL10');
/      
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 120, 'PAGST', 'MontoTotalPagos', 11, 'R', 'D', NULL, NULL, NULL, 'PAGSTVAL11');      
/
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 121, 'PAGSPIMTRA', 'BaseP', 1, 'R', 'D', NULL, NULL, NULL, 'PAGSPIMTRAVAL01');
/
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 121, 'PAGSPIMTRA', 'ImpuestoP', 2, 'R', 'D', NULL, NULL, NULL, 'PAGSPIMTRAVAL02');
/
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 121, 'PAGSPIMTRA', 'TipoFactorP', 3, 'R', 'D', NULL, NULL, NULL, 'PAGSPIMTRAVAL03');
/
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 121, 'PAGSPIMTRA', 'TasaOCuotaP', 4, 'C', 'D', NULL, NULL, NULL, 'PAGSPIMTRAVAL04');
/
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 121, 'PAGSPIMTRA', 'ImporteP', 5, 'C', 'D', NULL, NULL, NULL, 'PAGSPIMTRAVAL05');      
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET CODATRIBUTO = 'EquivalenciaDR',
       CONDICIONATRIBUTO = 'C'
   WHERE CODATRIBUTO = 'TipoCambioDR';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET CONDICIONATRIBUTO = 'O',
       INDENVIACIA = 'N'
 WHERE CODATRIBUTO = 'MetodoDePagoDR'
 AND IDIDENTIFICADOR = 127;
/
INSERT INTO DETALLE_FACT_ELECT_CONF_DOCTO
      VALUES(1, 127, 'PAGSPDOC', 'ObjetoImpDR', 11, 'R', 'D', NULL, NULL, NULL, 'PAGSPDOCVAL11');  
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET VALORATRIBUTO = 'CP01'
 WHERE IDIDENTIFICADOR = 123
   AND CODATRIBUTO = 'UsoCFDI';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET TIPOVALORATRIBUTO = 'F',
       VALORATRIBUTO = '002'
WHERE CODIDENTIFICADOR = 'PAGSPIMTRA'
AND CODATRIBUTO = 'ImpuestoP';
/
UPDATE FACT_ELECT_CONF_DOCTO
   SET INDRECURSIVO = 'N'
 WHERE CODIDENTIFICADOR = 'PAGSPIMTRA'
 AND Proceso = 'PAG';
/
UPDATE DETALLE_FACT_ELECT_CONF_DOCTO
   SET TIPOVALORATRIBUTO = 'F',
       VALORATRIBUTO = '002'
WHERE CODIDENTIFICADOR = 'PAGSPDOCIMTRA'
AND CODATRIBUTO = 'ImpuestoDR'; 
/
UPDATE FACT_ELECT_CONF_DOCTO
   SET CODCPTOIMPTO  = 'IVASIN',
       IndImpuesto   = 'S',
       ImptoTraRet   = 'T',
       IndRecursivo  = 'N'
 WHERE CodIdentificador = 'PAGSPDOCIMTRA';
/ 
UPDATE FACT_ELECT_CONF_DOCTO
   SET CODCPTOIMPTO  = 'IVASIN',
       IndImpuesto   = 'S',
       ImptoTraRet   = 'T',
       IndRecursivo  = 'N'
 WHERE CodIdentificador = 'PAGSPIMTRA'; 
 /
 UPDATE EMPRESAS
   SET REGIMENFISFACTELECT = 626
WHERE CODCIA = 1;
/
UPDATE Fact_Elect_Cat_Gpo_Linea
   SET VERSIONCFDI = '4.0'
WHERE VERSIONCFDI = '3.3';
/
UPDATE FACT_ELECT_CONF_DOCTO
   SET VERSIONCFDI = '4.0'
WHERE VERSIONCFDI = '3.3';
/

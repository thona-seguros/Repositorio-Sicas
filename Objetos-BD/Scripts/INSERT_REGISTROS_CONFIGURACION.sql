--SE CREA EL REGISTRO PARA UN NUEVO TIPO DE ENDOSO. CFV  CAMBIO FECHAS DE VIGENCIA.
INSERT INTO SICAS_OC.VALORES_DE_LISTAS(CODLISTA,CODVALOR,DESCVALLST)
                            VALUES('TIPENDOS','CFV','CAMBIO DE FECHAS DE VIGENCIA');

/
--SE CREA EL REGISTRO PARA LOS SUBPROCESOS ASOCIADOS EL NUEVO TIPO DE ENDOSO.
INSERT INTO SICAS_OC.SUB_PROCESO(IDPROCESO,CODSUBPROCESO,DESCRIPCION,STSSUBPROC)
                    VALUES(8,'CFV','CAMBIO DE FECHAS DE VIGENCIA','EMI');

/
--SE CREAN LOS REGISTROS QUE HACEN REFERENCIA A LA JUSTIFICACION DEL NUEVO ENDOSO [CFV CAMBIO DE FECHAS DE VIGENCIA], ESTA JUSTIFICACION SE TOMARA COMO TEXTO DEL ENDOSO
INSERT INTO SICAS_OC.ENDOSO_TXT_ENC (CODCIA,CODENDOSO,DESCRIPCION,ESTADO,INDUSOTEXTO,TIPOTEXTO,TIPONOTI,FECHAINICIO,FECHAFINAL) 
					VALUES (1,'AJUFECHBYUSR','AJUSTE DE FECHA DE VIGENCIA POR SOLICITUD DE USUARIO','ACTIVO','ENDOSO','E','FECHAS',NULL,NULL);
INSERT INTO SICAS_OC.ENDOSO_TXT_ENC (CODCIA,CODENDOSO,DESCRIPCION,ESTADO,INDUSOTEXTO,TIPOTEXTO,TIPONOTI,FECHAINICIO,FECHAFINAL) 
					VALUES (1,'AJUFECHERR','AJUSTE DE FECHA DE VIGENCIA POR ERROR DE CAPTURA','ACTIVO','ENDOSO','E','FECHAS',NULL,NULL);
INSERT INTO SICAS_OC.ENDOSO_TXT_ENC (CODCIA,CODENDOSO,DESCRIPCION,ESTADO,INDUSOTEXTO,TIPOTEXTO,TIPONOTI,FECHAINICIO,FECHAFINAL) 
					VALUES (1,'AJUFECHERRC','AJUSTE DE FECHA DE VIGENCIA POR ERROR CALCULO DE FECHAS','ACTIVO','ENDOSO','E','FECHAS',NULL,NULL);
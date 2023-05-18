CREATE OR REPLACE PACKAGE SICAS_OC.OC_ENDOSO_SERVICIOS_WEB AS
	/** ----------------------------------------------------------------------------------	***
	***   Nombre:: SICAS_OC.OC_ENDOSO_SERVICIOS_WEB                                      	***
	***   Tipo:: PACKAGE Specification														***
	***   Autor:: Jose de Jesus Ibarra Benitez                          					***
	***   Fecha:: 23-Nov-2022                                                    			***
	***                                                                          			***
	***   Historial                                                              			***
	***   | Nombre/Usuario               					| Version	| Fecha      	|	***
	***   ------------------------------------------------------------------------------	***
	***   | Jose de Jesus Ibarra Benitez	/	jibarra		| 1.0		| 23-11-2022	|  	***
	*** ----------------------------------------------------------------------------------	**/
	
	--JIBARRA_23-11-2022 <SE CREA FUNCION PARA CONSULTAR LA INFORMACION DE LOS ELEMENTOS INSERTADOS Y QUE NO HAN SIDO ACTUALIZADOS POR SERVICIOS WEB PARA DWH.>
	FUNCTION CONSULTA_ENDOSO_SERVICIOS_WEB(cMotivo_Endoso IN VARCHAR2) RETURN XMLTYPE;
	
	--JIBARRA_13-12-2022 <SE CREA FUNCION PARA CONSULTAR LAS FECHAS DE VIGENCIA DE DOCUMENTOS. LOS DOCUEMNTOS PERMITIDOS HASTA EL MOMENTO SON:: POLIZA,[01] CERITIFCADO DE POLIZA[02]
	--						ENDOSO[03], FACTURAS(RECIBO)[03] Y NOTA DE CREDITO(NCR)[05].>
	FUNCTION CONSULTA_FECHAS_VIGENCIA_DOCS(nIdDocumento IN NUMBER, nIdSubDocumento IN NUMBER, cTipoDoc IN VARCHAR2) RETURN SICAS_OC.fechasDeVigencia;
	
	--JIBARRA_23-11-2022 <SE CREA PROCESO PARA INSERTAR EN LA TABLA [SICAS_OC.ENDOSO_SERVICIOS_WEB] LA INFORMACION DE SEGUIMIENTO PARA LOS ENDOSOS CREADOS
	--						PARA LA ACTUALIZACION DE ELEMENTOS EN POLIZAS, CERTIFICADOS, ENDOSOS Y/O FACTURAS/NOTAS DE CREDITO.>
	PROCEDURE INSERTA_ENDOSO_SERVICIOS_WEB(nCodCia IN NUMBER,nIdPoliza IN NUMBER,nIDetPol IN NUMBER,nIdEndoso IN NUMBER,cMotivo_Endoso IN VARCHAR2
									,nIdEndosoUpd IN NUMBER,nIdDocUpd IN NUMBER,dNewFecIni IN DATE,dNewFecFin IN DATE,dNewFecIniD IN DATE,dNewFecFinD IN DATE
									,cEmitido IN VARCHAR2,cUser IN VARCHAR2,dFecContol IN DATE
									,nNumError OUT NUMBER,cMsjError OUT VARCHAR2 --PARAMETROS DE SALIDA PARA CONTROL Y VALIDACION DE EXCEPCIONES
									);
	
	--JIBARRA_23-11-2022 <PROCESO PARA ACTUALIZAR [ENDOSO_EMITIDO] CUANDO SE APLICARON LAS ACTUALZIACIONES DEL AJUSTE SOLICITADO.>
	PROCEDURE ACTUALIZA_ENDOSO_EMITIDO_SW(nCodCia IN NUMBER,nIdPoliza IN NUMBER,nIDetPol IN NUMBER,nIdEndoso IN NUMBER, cEstatusEmitido IN VARCHAR2
									,cUser IN VARCHAR2,dFecContol IN DATE
									,nNumError OUT NUMBER, cMsjError OUT VARCHAR2 --PARAMETROS DE SALIDA PARA CONTROL Y VALIDACION DE EXCEPCIONES
									);

	--JIBARRA_28-11-2022 <PROCESO PARA ACTUALIZAR LA BANDERA DE CONTROL DE LOS RECIBOS QUE SE ACTUALICEN EN DWH.>
	PROCEDURE ACTUALIZA_ENDOSO_UPD_SW(xmlUpdEndososDWH IN XMLTYPE
									,nNumError OUT NUMBER, cMsjError OUT VARCHAR2 --PARAMETROS DE SALIDA PARA CONTROL Y VALIDACION DE EXCEPCIONES
									);
	
END OC_ENDOSO_SERVICIOS_WEB;

/

CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_ENDOSO_SERVICIOS_WEB AS
	/** ----------------------------------------------------------------------------------	***
	***   Nombre:: SICAS_OC.OC_ENDOSO_SERVICIOS_WEB                                      	***
	***   Tipo:: PACKAGE Body																***
	***   Autor:: Jose de Jesus Ibarra Benitez                          					***
	***   Fecha:: 23-Nov-2022                                                    			***
	***                                                                          			***
	***   Historial                                                              			***
	***   | Nombre/Usuario               					| Version	| Fecha      	|	***
	***   ------------------------------------------------------------------------------	***
	***   | Jose de Jesus Ibarra Benitez	/	jibarra		| 1.0		| 23-11-2022	|  	***
	*** ----------------------------------------------------------------------------------	**/
	
	--JIBARRA_23-11-2022 <SE CREA FUNCION PARA CONSULTAR LA INFORMACION DE LOS ELEMENTOS INSERTADOS YQ UE NO HAN SIDO ACTUALIZADOS POR SERVICIOS WEB PARA DWH.>
	FUNCTION CONSULTA_ENDOSO_SERVICIOS_WEB(cMotivo_Endoso IN VARCHAR2) RETURN XMLTYPE
	AS
		xmlHeader   XMLTYPE := NULL;
		xmlBody     XMLTYPE := NULL;
		
		cParametros	VARCHAR2(200) := 'Parametros:: ' || TRUNC(SYSDATE) || '[' || cMotivo_Endoso ||']';
        nVarCero    NUMBER := 0;
		nControl	NUMBER;
		nNumError	NUMBER;
		cMsjError	VARCHAR2(4000);
	BEGIN
		nControl := 1;
		SELECT XMLELEMENT("DATA",
							XMLAGG(XMLELEMENT("POLIZA",XMLAttributes(ESW.IDPOLIZA AS "ID_POLIZA",ESW.IDENDOSO AS "ID_ENDOSO",ESW.IDETPOL AS "SUBGRUPO",ESW.CODCIA AS "CODCIA",E.MOTIVO_ENDOSO AS "COD_MOTIVO_ENDOSO",TO_CHAR(ESW.FECINIVIGP,'DD/MM/YYYY') AS "FECINIVIG",TO_CHAR(ESW.FECFINVIGP,'DD/MM/YYYY') AS "FECFINVIG")
											,CASE
												WHEN(E.MOTIVO_ENDOSO != '027')THEN
													(SELECT XMLAGG(XMLELEMENT("POLIZA_UPD",XMLELEMENT("IDPOLIZA",XMLAttributes(NULL AS "FECINIVIG",NULL AS "FECFINVIG"),NULL)
																						,XMLELEMENT("FECHAINI_UPD",NULL)
																						,XMLELEMENT("FECHAFIN_UPD",NULL)
																			)
																	)
													FROM DUAL
													GROUP BY 1
													)
												ELSE
													(SELECT XMLAGG(XMLELEMENT("POLIZA_UPD",XMLELEMENT("IDPOLIZA",XMLAttributes(TO_CHAR(ESW.FECINIVIGP,'DD/MM/YYYY') AS "FECINIVIG",TO_CHAR(ESW.FECFINVIGP,'DD/MM/YYYY') AS "FECFINVIG"),ESW.IDPOLIZA)
																						,XMLELEMENT("FECHAINI_UPD",TO_CHAR(ESW.NEWFECHAINI,'DD/MM/YYYY'))
																						,XMLELEMENT("FECHAFIN_UPD",TO_CHAR(ESW.NEWFECHAFIN,'DD/MM/YYYY'))
																			)
																	)
													FROM DUAL
													GROUP BY 1
													)
											END
											,CASE
												WHEN(E.MOTIVO_ENDOSO = '031')THEN
													(SELECT XMLAGG(XMLELEMENT("CERTIFICADO_UPD",XMLELEMENT("IDETPOL",XMLAttributes(NULL AS "FECINIVIG",NULL AS "FECFINVIG"),NULL)
																						,XMLELEMENT("FECHAINI_UPD",NULL)
																						,XMLELEMENT("FECHAFIN_UPD",NULL)
																			)
																	)
													FROM DUAL
													GROUP BY 1
													)
												ELSE
													(SELECT XMLAGG(XMLELEMENT("CERTIFICADO_UPD",XMLELEMENT("IDETPOL",XMLAttributes(TO_CHAR(ESW.FECINIVIGD,'DD/MM/YYYY') AS "FECINIVIG",TO_CHAR(ESW.FECFINVIGD,'DD/MM/YYYY') AS "FECFINVIG"),ESW.IDETPOL)
																						,XMLELEMENT("FECHAINI_UPD",TO_CHAR(ESW.NEWFECHAINI,'DD/MM/YYYY'))
																						,XMLELEMENT("FECHAFIN_UPD",TO_CHAR(ESW.NEWFECHAFIN,'DD/MM/YYYY'))
																			)
																	)
													FROM DUAL
													GROUP BY 1
													)
											END
											,CASE
												WHEN(E.MOTIVO_ENDOSO != '031')THEN
													(SELECT XMLAGG(XMLELEMENT("ENDOSO_UPD",XMLELEMENT("IDENDOSOUPD",XMLAttributes(NULL AS "FECINIVIG",NULL AS "FECFINVIG"),NULL)
																						,XMLELEMENT("FECHAINI_UPD",NULL)
																						,XMLELEMENT("FECHAFIN_UPD",NULL)
																			)
																	)
													FROM DUAL
													GROUP BY 1
													)
												ELSE
													(SELECT XMLAGG(XMLELEMENT("ENDOSO_UPD",XMLELEMENT("IDENDOSOUPD",XMLAttributes(TO_CHAR(ESW.FECINIVIGE,'DD/MM/YYYY') AS "FECINIVIG",TO_CHAR(ESW.FECFINVIGE,'DD/MM/YYYY') AS "FECFINVIG"),DECODE(ESW.IDENDOSOUPD,'0',NULL,ESW.IDENDOSOUPD))
																						,XMLELEMENT("FECHAINI_UPD",TO_CHAR(ESW.NEWFECHAINI,'DD/MM/YYYY'))
																						,XMLELEMENT("FECHAFIN_UPD",TO_CHAR(ESW.NEWFECHAFIN,'DD/MM/YYYY'))
																			)
																	)
													FROM DUAL
													GROUP BY 1
													)
											END
											,CASE
												WHEN(E.MOTIVO_ENDOSO != '031')THEN
													(SELECT XMLAGG(XMLELEMENT("DOCUMENTO_UPD",XMLELEMENT("ID_DOC_UPD",XMLAttributes(NULL AS "TIPO_DOCUMENTO",NULL AS "FECHAINI_DOC",NULL AS "FECHAFIN_DOC"),NULL)
																						,XMLELEMENT("FECHAINI_UPD",NULL)
																						,XMLELEMENT("FECHAFIN_UPD",NULL)
																			)
																	)
													FROM DUAL
													GROUP BY 1)
												ELSE
													(SELECT XMLAGG(XMLELEMENT("DOCUMENTO_UPD",XMLELEMENT("ID_DOC_UPD",XMLAttributes(ESW.TIPO_DOC_UPD AS "TIPO_DOCUMENTO",TO_CHAR(ESW.FECINI_DOC,'DD/MM/YYYY') AS "FECHAINI_DOC",TO_CHAR(ESW.FECFIN_DOC,'DD/MM/YYYY') AS "FECHAFIN_DOC"),ESW.ID_DOC_UPD)
																						,XMLELEMENT("FECHAINI_UPD",TO_CHAR(ESW.NEWFECHAINIDOC,'DD/MM/YYYY'))
																						,XMLELEMENT("FECHAFIN_UPD",TO_CHAR(ESW.NEWFECHAFINDOC,'DD/MM/YYYY'))
																			)
																	)
													FROM DUAL
													GROUP BY 1
													)
											END
											)
							)
						)
		INTO xmlBody
		FROM SICAS_OC.ENDOSO_SERVICIOS_WEB ESW
			,SICAS_OC.ENDOSOS E
		WHERE NVL(ESW.UPD_SERVICIOS_WEB,'N') != 'S'
		AND ESW.ENDOSO_EMITIDO != 'N'
		AND ESW.CODCIA >= nVarCero
		AND ESW.IDPOLIZA >= nVarCero
		AND ESW.IDETPOL >= nVarCero
		AND ESW.IDENDOSO >= nVarCero
		AND E.IDPOLIZA = ESW.IDPOLIZA
		AND E.IDENDOSO = ESW.IDENDOSO
		AND E.MOTIVO_ENDOSO = NVL(cMotivo_Endoso,E.MOTIVO_ENDOSO)
		ORDER BY ESW.IDPOLIZA,ESW.IDENDOSO ASC
		;
		
		--DBMS_OUTPUT.PUT_LINE('XXX');
		--DBMS_OUTPUT.PUT_LINE('TAMANIO::' || LENGTH(xmlBody.getstringval()));
		
		nControl := 2;
		SELECT XMLROOT(xmlBody, VERSION '1.0" encoding="UTF-8')
		INTO xmlHeader
		FROM DUAL;
		
		RETURN xmlHeader;
	EXCEPTION
		WHEN OTHERS THEN
			nNumError := SQLCODE;
			cMsjError := SQLERRM;
			cMsjError := 'ERROR_GENERAL SICAS_OC.OC_ENDOSO_SERVICIOS_WEB.CONSULTA_ENDOSO_SERVICIOS_WEB [' || nControl || '] <' || cMsjError || '>' || cParametros;
			
			SELECT XMLELEMENT("DATA",
                        XMLAGG(XMLELEMENT("ERROR",XMLELEMENT("NumError",nNumError),XMLELEMENT("MsjError",cMsjError))
							)
						)
			INTO xmlBody
			FROM DUAL
			;
			
			SELECT XMLROOT(xmlBody, VERSION '1.0" encoding="UTF-8')
			INTO xmlHeader
			FROM DUAL;
			
			RETURN xmlHeader;
			
			RAISE_APPLICATION_ERROR(-20225,'Error en OC_ENDOSO_SERVICIOS_WEB.CONSULTA_ENDOSO_SERVICIOS_WEB:'||cMsjError);
	END CONSULTA_ENDOSO_SERVICIOS_WEB;
	
	--JIBARRA_13-12-2022 <SE CREA FUNCION PARA CONSULTAR LAS FECHAS DE VIGENCIA DE DOCUMENTOS. LOS DOCUEMNTOS PERMITIDOS HASTA EL MOMENTO SON:: POLIZA,[01] CERITIFCADO DE POLIZA[02]
	--						ENDOSO[03], FACTURAS(RECIBO)[04] Y NOTA DE CREDITO(NCR)[05].>
	--					<EL RESULTADO SE DEBE CONSIDERAR COMO [tipo VARCHAR2(1000), fechaIniVig DATE, fechaFinVig DATE]>
	FUNCTION CONSULTA_FECHAS_VIGENCIA_DOCS(nIdDocumento IN NUMBER, nIdSubDocumento IN NUMBER, cTipoDoc IN VARCHAR2) RETURN SICAS_OC.fechasDeVigencia
	AS
		cTipoDocReturn		VARCHAR2(1000);
		dFechaIniVigReturn	DATE 			:= NULL;
		dFechaFinVigReturn	DATE 			:= NULL;
		
		--VARABLES PARA DECOTIFICAR EL PARAMETRO [cTipoDoc]
		cTipoDoc01			VARCHAR2(1000) := 'POLIZA';
		cTipoDoc02			VARCHAR2(1000) := 'CERTIFICADO_DE_POLIZA';
		cTipoDoc03			VARCHAR2(1000) := 'ENDOSO_DE_POLIZA';
		cTipoDoc04			VARCHAR2(1000) := 'RECIBO_NCR';
		
		cParametros			VARCHAR2(1000) := 'Parametros:: ' || TRUNC(SYSDATE) || '[' || nIdDocumento || '|' || nIdSubDocumento || '|' || nIdSubDocumento ||']';
		nControl        	NUMBER;
		nNumError			NUMBER;
		cMsjError			VARCHAR2(4000);
	BEGIN
		nControl := 1;
		IF(nIdDocumento IS NOT NULL AND cTipoDoc IS NOT NULL)THEN
			nControl := 2;
			SELECT CASE
						WHEN(cTipoDoc = '01')THEN
							cTipoDoc01
						WHEN(cTipoDoc = '02')THEN
							cTipoDoc02
						WHEN(cTipoDoc = '03')THEN
							cTipoDoc03
						WHEN(cTipoDoc = '04')THEN
							cTipoDoc04
						ELSE
							'NO_ESPECIFICADO'
					END
			INTO cTipoDocReturn
			FROM DUAL
			;
			
			nControl := 3;
			IF(cTipoDocReturn != 'NO_ESPECIFICADO')THEN
				nControl := 4;
				IF(cTipoDocReturn = cTipoDoc01)THEN
					nControl := 5;
					SELECT FECINIVIG, FECFINVIG
					INTO dFechaIniVigReturn, dFechaFinVigReturn
					FROM SICAS_OC.POLIZAS
					WHERE IDPOLIZA = nIdDocumento
					;
				ELSIF(cTipoDocReturn = cTipoDoc02)THEN
					nControl := 6;
					SELECT FECINIVIG, FECFINVIG
					INTO dFechaIniVigReturn, dFechaFinVigReturn
					FROM SICAS_OC.DETALLE_POLIZA
					WHERE IDPOLIZA = nIdDocumento
					AND IDETPOL = nIdSubDocumento
					;
				ELSIF(cTipoDocReturn = cTipoDoc03)THEN
					nControl := 7;
					SELECT FECINIVIG, FECFINVIG
					INTO dFechaIniVigReturn, dFechaFinVigReturn
					FROM SICAS_OC.ENDOSOS
					WHERE IDPOLIZA = nIdDocumento
					AND IDENDOSO = nIdSubDocumento
					;
				ELSIF(cTipoDocReturn = cTipoDoc04)THEN
					nControl := 8;
					BEGIN
						nControl := 8.1;
						SELECT 'RECIBO' TIPO_DOC,FECVENC, FECFINVIG
						INTO cTipoDocReturn,dFechaIniVigReturn, dFechaFinVigReturn
						FROM SICAS_OC.FACTURAS
						WHERE IDPOLIZA = nIdDocumento
						AND IDFACTURA = nIdSubDocumento
						;
					EXCEPTION
						WHEN NO_DATA_FOUND THEN
							nControl := 8.2;
							cTipoDocReturn := NULL;
						WHEN OTHERS THEN
							nControl := 8.3;
							cMsjError := SQLERRM;
							cMsjError := '[' || nControl || ']' || cMsjError;
							cTipoDocReturn := cMsjError;
					END;
					
					IF(cTipoDocReturn IS NULL)THEN
						nControl := 9;
						BEGIN
							nControl := 9.1;
							SELECT 'NCR' TIPO_DOC,FECDEVOL,FECFINVIG
							INTO cTipoDocReturn,dFechaIniVigReturn, dFechaFinVigReturn
							FROM SICAS_OC.NOTAS_DE_CREDITO
							WHERE IDPOLIZA = nIdDocumento
							AND IDNCR = nIdSubDocumento
							;
						EXCEPTION
							WHEN OTHERS THEN
								nControl := 9.2;
								cMsjError := SQLERRM;
								cMsjError := '[' || nControl || ']' || cMsjError;
								cTipoDocReturn := cMsjError;
						END;
					END IF;
				ELSE
					nControl := 10;
					cTipoDocReturn := nControl || '_VALIDAR EL CUERPO DE CONDICIONES DE ESCENARIOS EN LA FUNCION <SICAS_OC.OC_ENDOSO_SERVICIOS_WEB.CONSULTA_FECHAS_VIGENCIA_DOCS>';
				END IF;
			ELSE
				cTipoDocReturn := nControl || '_EL VALOR DEL PARAMETRO cTipoDoc [' || cTipoDoc || '] NO ESTA ESPEFICICADO EN LA FUNICON <SICAS_OC.OC_ENDOSO_SERVICIOS_WEB.CONSULTA_FECHAS_VIGENCIA_DOCS>';
			END IF;
		ELSE
			cTipoDocReturn := nControl || '_VALIDAR LOS VALORES INGRESADOS PARA LA FUNCION <SICAS_OC.OC_ENDOSO_SERVICIOS_WEB.CONSULTA_FECHAS_VIGENCIA_DOCS>';
		END IF;
		
		RETURN SICAS_OC.fechasDeVigencia(cTipoDocReturn, TO_CHAR(dFechaIniVigReturn,'DD/MM/RRRR'), TO_CHAR(dFechaFinVigReturn,'DD/MM/RRRR'));
	EXCEPTION
		WHEN OTHERS THEN
			nNumError := SQLCODE;
			cMsjError := SQLERRM;
			cMsjError := '[' || nControl || ']' || cMsjError;
			
			cTipoDocReturn := cMsjError;
			
			RETURN SICAS_OC.fechasDeVigencia(cTipoDocReturn, dFechaIniVigReturn, dFechaFinVigReturn);
	END CONSULTA_FECHAS_VIGENCIA_DOCS;
	
	--JIBARRA_23-11-2022 <SE CREA PROCESO PARA INSERTAR EN LA TABLA [SICAS_OC.ENDOSO_SERVICIOS_WEB] LA INFORMACION DE SEGUIMIENTO PARA LOS ENDOSOS CREADOS
	--						PARA LA ACTUALIZACION DE ELEMENTOS EN POLIZAS, CERTIFICADOS, ENDOSOS Y/O FACTURAS/NOTAS DE CREDITO.>
	PROCEDURE INSERTA_ENDOSO_SERVICIOS_WEB(nCodCia IN NUMBER,nIdPoliza IN NUMBER,nIDetPol IN NUMBER,nIdEndoso IN NUMBER,cMotivo_Endoso IN VARCHAR2
									,nIdEndosoUpd IN NUMBER,nIdDocUpd IN NUMBER,dNewFecIni IN DATE,dNewFecFin IN DATE,dNewFecIniD IN DATE,dNewFecFinD IN DATE
									,cEmitido IN VARCHAR2,cUser IN VARCHAR2,dFecContol IN DATE
									,nNumError OUT NUMBER, cMsjError OUT VARCHAR2 --PARAMETROS DE SALIDA PARA CONTROL Y VALIDACION DE EXCEPCIONES
									)
	AS
		cParametros     VARCHAR2(2000) := 'Parametros:: ' || TRUNC(SYSDATE) || '[' || nCodCia || '|' || nIdPoliza || '|' || nIDetPol || '|' || nIdEndoso || '|' || cMotivo_Endoso
										|| '|' || nIdEndosoUpd || '|' || nIdDocUpd || '|' || dNewFecIni || '|' || dNewFecFin || '|' || dNewFecIniD || '|' || dNewFecFinD
										|| '|' || cEmitido || '|' || cUser || '|' || dFecContol ||']';
		
		cMotivo_EndosoA  SICAS_OC.ENDOSOS.MOTIVO_ENDOSO%TYPE := '027';  --VARIABLE PARA VALIDAR MOTIVO DE ENDOSO DE CAMBIO DE FECHA
		cMotivo_EndosoB  SICAS_OC.ENDOSOS.MOTIVO_ENDOSO%TYPE := '029';  --VARIABLE PARA VALIDAR MOTIVO DE ENDOSO DE CAMBIO DE FECHA
		cMotivo_EndosoC  SICAS_OC.ENDOSOS.MOTIVO_ENDOSO%TYPE := '031';  --VARIABLE PARA VALIDAR MOTIVO DE ENDOSO DE CAMBIO DE FECHA
		
		dFechaVigIniP   SICAS_OC.ENDOSO_SERVICIOS_WEB.FECINIVIGP%TYPE;
		dFechaVigFinP   SICAS_OC.ENDOSO_SERVICIOS_WEB.FECFINVIGP%TYPE;
		dFechaVigIniD   SICAS_OC.ENDOSO_SERVICIOS_WEB.FECINIVIGD%TYPE;
		dFechaVigFinD   SICAS_OC.ENDOSO_SERVICIOS_WEB.FECFINVIGD%TYPE;
		dFechaVigIniE   SICAS_OC.ENDOSO_SERVICIOS_WEB.FECINIVIGE%TYPE := NULL;
		dFechaVigFinE   SICAS_OC.ENDOSO_SERVICIOS_WEB.FECFINVIGE%TYPE := NULL;
		dFechaIniDoc   	SICAS_OC.ENDOSO_SERVICIOS_WEB.FECINI_DOC%TYPE;
		dFechaFinDoc   	SICAS_OC.ENDOSO_SERVICIOS_WEB.FECFIN_DOC%TYPE;
		dFechaVigIniV   SICAS_OC.ENDOSO_SERVICIOS_WEB.NEWFECHAINI%TYPE;
		dFechaVigFinV   SICAS_OC.ENDOSO_SERVICIOS_WEB.NEWFECHAFIN%TYPE;
		nIdDocUpdCtrl	SICAS_OC.ENDOSO_SERVICIOS_WEB.ID_DOC_UPD%TYPE := 0;
		cTipoDoc		SICAS_OC.ENDOSO_SERVICIOS_WEB.TIPO_DOC_UPD%TYPE;
		
		nControl        NUMBER;
	BEGIN
		nControl := 0.5;
		nNumError := 0;
		cMsjError := NULL;
		
		nControl := 1;
		IF(nCodCia IS NOT NULL AND nIdPoliza IS NOT NULL AND nIDetPol IS NOT NULL AND nIdEndoso IS NOT NULL AND cMotivo_Endoso IS NOT NULL 
			/*AND dNewFecIni IS NOT NULL AND dNewFecFin IS NOT NULL*/ AND cEmitido IS NOT NULL AND cUser IS NOT NULL AND dFecContol IS NOT NULL)THEN
			nControl := 2;
			BEGIN
				nControl := 3;
				SELECT MIN(P.FECINIVIG),MAX(P.FECFINVIG)
				INTO dFechaVigIniP, dFechaVigFinP
				FROM SICAS_OC.POLIZAS P
				WHERE P.IDPOLIZA = nIdPoliza
				;
				
				nControl := 4;
				SELECT MIN(DP.FECINIVIG),MAX(DP.FECFINVIG)
				INTO dFechaVigIniD, dFechaVigFinD
				FROM SICAS_OC.DETALLE_POLIZA DP
				WHERE DP.IDPOLIZA = nIdPoliza
				AND DP.IDETPOL  = nIDetPol
				;
				
				nControl := 5;
				IF(dFechaVigIniD IS NULL OR dFechaVigIniP >= dFechaVigIniD)THEN
					dFechaVigIniV := dFechaVigIniP;
				ELSE
					dFechaVigIniV := dFechaVigIniD;
				END IF;
				
				nControl := 5.5;
				IF(dFechaVigFinD IS NULL OR dFechaVigFinP >= dFechaVigFinD)THEN
					dFechaVigFinV := dFechaVigFinP;
				ELSE
					dFechaVigFinV := dFechaVigFinD;
				END IF;
				/*
				nControl := 6;
				IF(cMotivo_Endoso != cMotivo_EndosoA AND(dNewFecIni > dFechaVigFinV OR dNewFecFin < dFechaVigIniV OR dNewFecIni >= dNewFecFin))THEN
					nControl := 6.1;
					nNumError := nControl;
					cMsjError := 'LAS FECHAS QUE DESEA ACTUALIZAR NO ESTAN DENTRO DEL RANGO DE FECHAS DE LA POLIZA.';
				END IF;
				*/
				nControl := 6.5;
				IF(nNumError = 0 AND nIdEndosoUpd IS NOT NULL /*AND nIdDocUpd IS NOT NULL*/)THEN
					IF(nIdDocUpd IS NOT NULL AND nIdDocUpd != 0)THEN
						BEGIN
							nControl := 7;
							SELECT IDNCR, FECDEVOL, FECFINVIG
							INTO nIdDocUpdCtrl, dFechaIniDoc, dFechaFinDoc
							FROM SICAS_OC.NOTAS_DE_CREDITO
							WHERE IDPOLIZA = nIdPoliza
							AND IDETPOL = nIDetPol
							AND IDENDOSO = nIdEndosoUpd
							AND IDNCR = nIdDocUpd
							;
							
							cTipoDoc := 'NCR';	--NOTAS DE CREDITO
						EXCEPTION
							WHEN NO_DATA_FOUND THEN
								nNumError := -1;
								cMsjError := 'NO EXISTE NOTA DE CREDITO SOLICITADA.';
							WHEN OTHERS THEN
								nNumError := SQLCODE;
								cMsjError := SQLERRM;
						END;
						
						IF(nIdDocUpdCtrl = 0 AND nNumError = -1)THEN
							nNumError := 0;
							cMsjError := NULL;
							BEGIN
								nControl := 8;
								SELECT IDFACTURA, FECVENC, FECFINVIG
								INTO nIdDocUpdCtrl, dFechaIniDoc, dFechaFinDoc
								FROM SICAS_OC.FACTURAS
								WHERE IDPOLIZA = nIdPoliza
								AND IDETPOL = nIDetPol
								AND IDENDOSO = nIdEndosoUpd
								AND IDFACTURA = nIdDocUpd
								;
								
								cTipoDoc := 'RECIBO';		--FACTURA/RECIBO
							EXCEPTION
								WHEN NO_DATA_FOUND THEN
									nNumError := SQLCODE;
									cMsjError := 'NO EXISTE RECIBO ASOCIADA A LA POLIZA ' || nIdPoliza;
								WHEN OTHERS THEN
									nNumError := SQLCODE;
									cMsjError := SQLERRM;
							END;
						END IF;
					END IF;
					
					IF(nNumError = 0 AND nIdEndosoUpd != 0)THEN
						BEGIN
							nControl := 9;
							SELECT FECINIVIG, FECFINVIG
							INTO dFechaVigIniE, dFechaVigFinE
							FROM SICAS_OC.ENDOSOS
							WHERE IDPOLIZA  = nIdPoliza
							AND IDENDOSO  = nIdEndosoUpd
							AND IDETPOL = nIDetPol
							;
						EXCEPTION
							WHEN NO_DATA_FOUND THEN
								nNumError := SQLCODE;
								cMsjError := 'NO EXISTE EL ENDOSO QUE DESEA ACTUALIZAR PARA LA POLIZA ' || nIdPoliza;
							WHEN OTHERS THEN
								nNumError := SQLCODE;
								cMsjError := SQLERRM;
								
						END;
					END IF;
				ELSE
					dFechaVigIniE := NULL;
					dFechaVigFinE := NULL;
					cTipoDoc := NULL;
					dFechaIniDoc := NULL;
					dFechaFinDoc := NULL;
				END IF;
				
				
			EXCEPTION
				WHEN OTHERS THEN
					nNumError := nControl;
					cMsjError := 'VALIDADION DE FECHAS ERRONEA.';
			END;
			
		ELSE
			nNumError := nControl;
			cMsjError := 'VALIDAR LOS VALORES DE LOS PARAMETROS OBLIGATORIOS.';
		END IF;
		
		IF(nNumError = 0)THEN
			nControl := 10;
			INSERT INTO SICAS_OC.ENDOSO_SERVICIOS_WEB (CODCIA,IDPOLIZA,IDETPOL,IDENDOSO,FECINIVIGP,FECFINVIGP,FECINIVIGD,FECFINVIGD
								,IDENDOSOUPD,FECINIVIGE,FECFINVIGE,TIPO_DOC_UPD,ID_DOC_UPD,FECINI_DOC,FECFIN_DOC,NEWFECHAINI,NEWFECHAFIN,NEWFECHAINIDOC,NEWFECHAFINDOC
								,ENDOSO_EMITIDO,USUARIO_ALTA,FECHA_ALTA,USUARIO_MOD,FECHA_MOD)
								VALUES(nCodCia,nIdPoliza,nIDetPol,nIdEndoso,dFechaVigIniP,dFechaVigFinP,dFechaVigIniD,dFechaVigFinD
									,nIdEndosoUpd,dFechaVigIniE,dFechaVigFinE,cTipoDoc,nIdDocUpd,dFechaIniDoc,dFechaFinDoc,dNewFecIni,dNewFecFin,dNewFecIniD,dNewFecFinD
									,cEmitido,cUser,dFecContol,cUser,dFecContol);
			
			COMMIT;
			nNumError := 0;
			cMsjError := 'INSERT CORRECTO PARA SICAS_OC.ENDOSO_SERVICIOS_WEB.';
		ELSE
			ROLLBACK;
			cMsjError := '[' || nControl || ']' || cMsjError;
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			nNumError := SQLCODE;
			cMsjError := SQLERRM;
			cMsjError := 'ERROR_GENERAL SICAS_OC.OC_ENDOSO_SERVICIOS_WEB.INSERTA_ENDOSO_SERVICIOS_WEB [' || nControl || '] <' || cMsjError || '>' || cParametros;
			RAISE_APPLICATION_ERROR(-20225,'Error en OC_ENDOSO_SERVICIOS_WEB.INSERTA_ENDOSO_SERVICIOS_WEB:'||cMsjError);
	END INSERTA_ENDOSO_SERVICIOS_WEB;
	
	--JIBARRA_23-11-2022 <PROCESO PARA ACTUALIZAR [ENDOSO_EMITIDO] CUANDO SE APLICARON LAS ACTUALZIACIONES DEL AJUSTE SOLICITADO.>
	PROCEDURE ACTUALIZA_ENDOSO_EMITIDO_SW(nCodCia IN NUMBER,nIdPoliza IN NUMBER,nIDetPol IN NUMBER,nIdEndoso IN NUMBER, cEstatusEmitido IN VARCHAR2
									,cUser IN VARCHAR2,dFecContol IN DATE
									,nNumError OUT NUMBER, cMsjError OUT VARCHAR2 --PARAMETROS DE SALIDA PARA CONTROL Y VALIDACION DE EXCEPCIONES
									)
	AS
        cParametros     VARCHAR2(2000) := 'Parametros:: ' || TRUNC(SYSDATE) || '[' || nCodCia || '|' || nIdPoliza || '|' || nIDetPol || '|' || nIdEndoso || ']';
		nControl        NUMBER;
	BEGIN
		nNumError := 0;
		cMsjError := NULL;
		
		nControl := 1;
		IF(nCodCia IS NULL OR nIdPoliza IS NULL OR nIDetPol IS NULL OR nIdEndoso IS NULL OR cEstatusEmitido IS NULL)THEN
			nControl := 2;
			nNumError := nControl;
			cMsjError := 'LOS PARAMETROS NO PUEDEN SER NULL. VALIDAR LOS VALORES ENVIADOS.';
		ELSE
			nControl := 3;
			UPDATE SICAS_OC.ENDOSO_SERVICIOS_WEB
			SET ENDOSO_EMITIDO = cEstatusEmitido
				,USUARIO_MOD = cUser
				,FECHA_MOD = dFecContol
			WHERE CODCIA = nCodCia
			AND IDPOLIZA = nIdPoliza
			AND IDETPOL = nIDetPol
			AND IDENDOSO = nIdEndoso
			;
			
			COMMIT;
			nNumError := 0;
			cMsjError := 'ACTUALIZACION CORRECTA.';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			ROLLBACK;
			nNumError := SQLCODE;
			cMsjError := SQLERRM;
			cMsjError := 'ERROR_GENERAL SICAS_OC.OC_ENDOSO_SERVICIOS_WEB.ACTUALIZA_ENDOSO_EMITIDO_SW [' || nControl || '] <' || cMsjError || '>' || cParametros;
			RAISE_APPLICATION_ERROR(-20225,'Error OC_ENDOSO_SERVICIOS_WEB.ACTUALIZA_ENDOSO_EMITIDO_SW:'||cMsjError);
	END ACTUALIZA_ENDOSO_EMITIDO_SW;

	--JIBARRA_28-11-2022 <PROCESO PARA ACTUALIZAR LA BANDERA DE CONTROL DE LOS RECIBOS QUE SE ACTUALICEN EN DWH.>
	PROCEDURE ACTUALIZA_ENDOSO_UPD_SW(xmlUpdEndososDWH IN XMLTYPE
									,nNumError OUT NUMBER, cMsjError OUT VARCHAR2 --PARAMETROS DE SALIDA PARA CONTROL Y VALIDACION DE EXCEPCIONES
									) AS
		CURSOR INFO_UPD IS
            SELECT VALUE(XML_DATA).EXTRACT('/POLIZA/@ID_POLIZA').getStringVal() nIdPoliza
                ,VALUE(XML_DATA).EXTRACT('/POLIZA/@SUBGRUPO').getNumberVal() nIDetPol
                ,VALUE(XML_DATA).EXTRACT('/POLIZA/@ID_ENDOSO').getNumberVal() nIdEndoso
                ,VALUE(XML_DATA).EXTRACT('/POLIZA/@CODCIA').getNumberVal() nCodCia
                ,VALUE(XML_DATA).EXTRACT('/POLIZA/@COD_MOTIVO_ENDOSO').getStringVal() cMoticoEndoso
                ,VALUE(XML_DATA).EXTRACT('/POLIZA/FLAG_UPDATE/text()').getStringVal() cFlagUpdate
				,VALUE(XML_DATA).EXTRACT('/POLIZA/NOTA/text()').getStringVal() cNota
            FROM TABLE(XMLSEQUENCE(xmlUpdEndososDWH.EXTRACT('//POLIZA')))XML_DATA
			WHERE EXISTSNODE(xmlUpdEndososDWH.EXTRACT('//POLIZA'),'/POLIZA/FLAG_UPDATE') = 1
            ;
		nControlLoop	NUMBER := 0;
		nControlNoUpd	NUMBER := 0;
		nControlUpd		NUMBER := 0;
	BEGIN
		FOR n IN INFO_UPD LOOP
			
			IF(nControlLoop = 0)THEN
				nControlLoop := 1;
			END IF;
            
			IF(n.cFlagUpdate IS NOT NULL)THEN
				nControlUpd := nControlUpd + 1;
				
				UPDATE SICAS_OC.ENDOSO_SERVICIOS_WEB
				SET UPD_SERVICIOS_WEB = NVL(n.cFlagUpdate,UPD_SERVICIOS_WEB)
					,NOTA_SERVICIOS_WEB = NVL(n.cNota,NOTA_SERVICIOS_WEB)
					,USUARIO_MOD = USER
					,FECHA_MOD = TRUNC(SYSDATE)
				WHERE CODCIA = n.nCodCia
				AND IDPOLIZA = n.nIdPoliza
				AND IDETPOL = n.nIDetPol
				AND IDENDOSO = n.nIdEndoso
				;
				
				COMMIT;
			ELSE
				nControlNoUpd := nControlNoUpd + 1;
			END IF;
			
		END LOOP;
		
		IF(nControlLoop = 0)THEN
			nNumError := 9999;
			cMsjError := 'LA ESTRUCTURA DEL PARAMETRO DE ENTRADA NO CONTIENE LOS ELEMENTOS CORRESPONDIENTES PARA PROCESAR LA INFORMACION.';
		ELSE
			nNumError := 0;
			cMsjError := 'PROCESAMIENTO DE DATOS. TOTAL DE REGISTROS: ' || (nControlUpd + nControlNoUpd) || '. ACTUALIZACIONES: .' || nControlUpd || '. NO ACTUALIZACIONES: ' || nControlNoUpd || '.';
		END IF;
	EXCEPTION
		WHEN OTHERS THEN
			nNumError := SQLCODE;
			cMsjError := SQLERRM;
			cMsjError := 'ERROR GENERAL EN OC_ENDOSO_SERVICIOS_WEB.ACTUALIZA_ENDOSO_UPD_SW' || cMsjError;
	END ACTUALIZA_ENDOSO_UPD_SW;
									
END OC_ENDOSO_SERVICIOS_WEB;

/

GRANT EXECUTE ON SICAS_OC.OC_ENDOSO_SERVICIOS_WEB TO PUBLIC;

/

CREATE OR REPLACE PUBLIC SYNONYM OC_ENDOSO_SERVICIOS_WEB FOR SICAS_OC.OC_ENDOSO_SERVICIOS_WEB;

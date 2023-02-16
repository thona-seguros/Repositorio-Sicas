CREATE OR REPLACE PACKAGE OC_POLIZAS_PERSONAS_Y_OS IS
-- CREACION     05/10/2021

PROCEDURE INSERTA_REGISTROS(nIDPOLIZA                            	NUMBER,
                            		         nIDETPOL                             	NUMBER,
                            		         cTIPO_DOC_IDENTIFICACION          VARCHAR2,
                            		         cNUM_DOC_IDENTIFICACION          VARCHAR2,
                           		         nNUM_CONSECUTIVO_YO              NUMBER,
                            		         cNOMBRE_COMERCIAL                  VARCHAR2,
                            		         cDIRECCION_CALLE                        VARCHAR2,
                            		         cNUM_EXTERIOR                        	VARCHAR2,
                            		         cNUM_INTERIOR                        	VARCHAR2,
                            		         cCODIGO_POSTAL                       	VARCHAR2,
                            		         cCODCOLONIA                          	VARCHAR2,
                            		         cCODESTADO                           	VARCHAR2,
                            		         cCODCIUDAD                           	VARCHAR2,
                            		         cCODMUNICIPIO                        	VARCHAR2,
                            		         cCODPAIS                             	VARCHAR2,
                            		         cTELEFONO                            	VARCHAR2,
                            		         cEMAIL                               	VARCHAR2);

--
PROCEDURE BORRA_MOVIMIENTO (nIDPOLIZA                            	NUMBER,
                            		         nIDETPOL                             	NUMBER,
                            		         cTIPO_DOC_IDENTIFICACION          VARCHAR2,
                            		         cNUM_DOC_IDENTIFICACION          VARCHAR2,
                            		         nNUM_CONSECUTIVO_YO              NUMBER );

END OC_POLIZAS_PERSONAS_Y_OS;

/

CREATE OR REPLACE PACKAGE BODY OC_POLIZAS_PERSONAS_Y_OS IS
---
--- CREACION     05/10/2021
PROCEDURE INSERTA_REGISTROS(nIDPOLIZA                            	NUMBER,
                            		         nIDETPOL                             	NUMBER,
                            		         cTIPO_DOC_IDENTIFICACION          VARCHAR2,
                            		         cNUM_DOC_IDENTIFICACION          VARCHAR2,
                            		         nNUM_CONSECUTIVO_YO              NUMBER,
                            		         cNOMBRE_COMERCIAL                  VARCHAR2,
                            		         cDIRECCION_CALLE                     	VARCHAR2,
                            		         cNUM_EXTERIOR                        	VARCHAR2,
                            		         cNUM_INTERIOR                        	VARCHAR2,
                           		         cCODIGO_POSTAL                       	VARCHAR2,
                            		         cCODCOLONIA                          	VARCHAR2,
                            		         cCODESTADO                           	VARCHAR2,
                            		         cCODCIUDAD                           	VARCHAR2,
                            		         cCODMUNICIPIO                        	VARCHAR2,
                            		         cCODPAIS                             	VARCHAR2,
                           		         cTELEFONO                            	VARCHAR2,
                            		         cEMAIL                               	VARCHAR2) IS
BEGIN

       INSERT INTO POLIZAS_PERSONAS_Y_OS (IDPOLIZA, IDETPOL, TIPO_DOC_IDENTIFICACION, NUM_DOC_IDENTIFICACION, NUM_CONSECUTIVO_YO,
                                          NOMBRE_COMERCIAL, DIRECCION_CALLE, NUM_EXTERIOR, NUM_INTERIOR, CODIGO_POSTAL, CODCOLONIA,
                                          CODESTADO, CODCIUDAD, CODMUNICIPIO, CODPAIS, TELEFONO, EMAIL )
       VALUES(nIDPOLIZA, nIDETPOL, cTIPO_DOC_IDENTIFICACION, cNUM_DOC_IDENTIFICACION, nNUM_CONSECUTIVO_YO, cNOMBRE_COMERCIAL, cDIRECCION_CALLE,
              cNUM_EXTERIOR, cNUM_INTERIOR, cCODIGO_POSTAL, cCODCOLONIA, cCODESTADO, cCODCIUDAD, cCODMUNICIPIO, cCODPAIS, cTELEFONO, cEMAIL );

-----       COMMIT;

END INSERTA_REGISTROS;
--
PROCEDURE BORRA_MOVIMIENTO(nIDPOLIZA                            	NUMBER,
                            		        nIDETPOL                             	NUMBER,
                            		        cTIPO_DOC_IDENTIFICACION           VARCHAR2,
                            		        cNUM_DOC_IDENTIFICACION           VARCHAR2,
                            		        nNUM_CONSECUTIVO_YO               NUMBER ) IS
--
BEGIN
  --
  DELETE POLIZAS_PERSONAS_Y_OS
    WHERE IDPOLIZA                		= nIDPOLIZA
      AND IDETPOL                 		= nIDETPOL
      AND TIPO_DOC_IDENTIFICACION 	= cTIPO_DOC_IDENTIFICACION
      AND NUM_DOC_IDENTIFICACION  	= cNUM_DOC_IDENTIFICACION
      AND nNUM_CONSECUTIVO_YO    	= nNUM_CONSECUTIVO_YO ;
  --
-----  COMMIT;
  --
END BORRA_MOVIMIENTO;
--
END OC_POLIZAS_PERSONAS_Y_OS;

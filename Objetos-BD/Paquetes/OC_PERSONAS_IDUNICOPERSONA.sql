CREATE OR REPLACE PACKAGE OC_PERSONAS_IDUNICOPERSONA IS
-- CREACION     05/10/2021
--
PROCEDURE INSERTA_REGISTROS(cIDUNICOPERSONA                      	VARCHAR2,
                            		         cTIPO_DOC_IDENTIFICACION           VARCHAR2,
                            		         cNUM_DOC_IDENTIFICACION           VARCHAR2,
                            		         cTIPO_ID_TRIBUTARIA                  	VARCHAR2,
                            		         cNUM_TRIBUTARIO                      	VARCHAR2,
                            		         cCURP                                	VARCHAR2 ) ;

--
PROCEDURE BORRA_MOVIMIENTO(cIDUNICOPERSONA                      	VARCHAR2,
                           		        cTIPO_DOC_IDENTIFICACION            VARCHAR2,
                           		        cNUM_DOC_IDENTIFICACION            VARCHAR2 );

END OC_PERSONAS_IDUNICOPERSONA;

/

CREATE OR REPLACE PACKAGE BODY OC_PERSONAS_IDUNICOPERSONA IS
---
--- CREACION     05/10/2021
PROCEDURE INSERTA_REGISTROS(cIDUNICOPERSONA                      	VARCHAR2,
                            		         cTIPO_DOC_IDENTIFICACION          VARCHAR2,
                            		         cNUM_DOC_IDENTIFICACION          VARCHAR2,
                            		         cTIPO_ID_TRIBUTARIA                  	VARCHAR2,
                            		         cNUM_TRIBUTARIO                      	VARCHAR2,
                            		         cCURP                                	VARCHAR2 ) IS
BEGIN

       INSERT INTO PERSONAS_IDUNICOPERSONA (IDUNICOPERSONA, TIPO_DOC_IDENTIFICACION, NUM_DOC_IDENTIFICACION, TIPO_ID_TRIBUTARIA,
                                            NUM_TRIBUTARIO, CURP )
       VALUES(cIDUNICOPERSONA, cTIPO_DOC_IDENTIFICACION, cNUM_DOC_IDENTIFICACION, cTIPO_ID_TRIBUTARIA, cNUM_TRIBUTARIO, cCURP );

------       COMMIT;

END INSERTA_REGISTROS;
--
PROCEDURE BORRA_MOVIMIENTO(cIDUNICOPERSONA                      	VARCHAR2,
                           		        cTIPO_DOC_IDENTIFICACION            VARCHAR2,
                           		        cNUM_DOC_IDENTIFICACION            VARCHAR2 ) IS
--
BEGIN
  --
  DELETE PERSONAS_IDUNICOPERSONA
    WHERE IDUNICOPERSONA           	= cIDUNICOPERSONA
      AND TIPO_DOC_IDENTIFICACION  	= cTIPO_DOC_IDENTIFICACION
      AND NUM_DOC_IDENTIFICACION   	= cNUM_DOC_IDENTIFICACION ;
  --
------  COMMIT;
  --
END BORRA_MOVIMIENTO;
--
END OC_PERSONAS_IDUNICOPERSONA;

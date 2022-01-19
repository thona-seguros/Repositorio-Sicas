CREATE OR REPLACE PACKAGE OC_POLIZAS_COMPLEMENTO IS
-- CREACION     05/10/2021

--
PROCEDURE INSERTA_REGISTROS(nCODCIA                                NUMBER,
                            nCODEMPRESA                            NUMBER,
                            nIDPOLIZA                              NUMBER,
                            cINDFACTPERSONALIZADA                  VARCHAR2,
                            cFORMAIMPRIMENOMBRE                    VARCHAR2 ) ;

--
PROCEDURE BORRA_MOVIMIENTO(nCODCIA                              NUMBER,
                           nCODEMPRESA                          NUMBER,
                           nIDPOLIZA                            NUMBER );

END OC_POLIZAS_COMPLEMENTO;
/
CREATE OR REPLACE PACKAGE BODY OC_POLIZAS_COMPLEMENTO IS
---
-- CREACION     05/10/2021
PROCEDURE INSERTA_REGISTROS(nCODCIA                                NUMBER,
                            nCODEMPRESA                            NUMBER,
                            nIDPOLIZA                              NUMBER,
                            cINDFACTPERSONALIZADA                  VARCHAR2,
                            cFORMAIMPRIMENOMBRE                    VARCHAR2) IS
BEGIN

       INSERT INTO POLIZAS_COMPLEMENTO (CODCIA, CODEMPRESA, IDPOLIZA , INDFACTPERSONALIZADA, FORMAIMPRIMENOMBRE)
       VALUES(nCODCIA, nCODEMPRESA, nIDPOLIZA, cINDFACTPERSONALIZADA, cFORMAIMPRIMENOMBRE);

------       COMMIT;

END INSERTA_REGISTROS;
--
PROCEDURE BORRA_MOVIMIENTO(nCODCIA                              NUMBER,
                           nCODEMPRESA                          NUMBER,
                           nIDPOLIZA                            NUMBER ) IS
--
BEGIN
  --
  DELETE POLIZAS_COMPLEMENTO
    WHERE CODCIA      = nCODCIA
      AND CODEMPRESA  = nCODEMPRESA
      AND IDPOLIZA      = nIDPOLIZA ;
  --
------  COMMIT;
  --
END BORRA_MOVIMIENTO;
--
END OC_POLIZAS_COMPLEMENTO;
/

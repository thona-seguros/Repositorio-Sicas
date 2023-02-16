CREATE OR REPLACE PACKAGE OC_ENDOSO_TXT_DET IS

  FUNCTION DESCRIPCION_TEXTO(nCodCia NUMBER, cCodEndoso VARCHAR2) RETURN VARCHAR2;

END OC_ENDOSO_TXT_DET;

/

CREATE OR REPLACE PACKAGE BODY OC_ENDOSO_TXT_DET IS

    FUNCTION DESCRIPCION_TEXTO(nCodCia NUMBER, cCodEndoso VARCHAR2) RETURN VARCHAR2 IS
         cDescripcion   ENDOSO_TXT_DET.TEXTO%TYPE;
    BEGIN
       BEGIN
          SELECT D.TEXTO
            INTO cDescripcion
            FROM ENDOSO_TXT_DET D
           WHERE D.CodCia     = nCodCia
             AND D.CodEndoso  = cCodEndoso;             
       EXCEPTION WHEN OTHERS THEN
             NULL;          
       END;
       --
       RETURN(cDescripcion);
       --
    END DESCRIPCION_TEXTO;

END OC_ENDOSO_TXT_DET;

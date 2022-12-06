CREATE OR REPLACE PACKAGE OC_VALORES_DE_LISTAS IS
--
-- MODIFICACIONES
-- 23/08/2021 Se agrego funcion BUSCA_CAT_VALOR  JALV      
-- 24/11/2022 Se agrega funcion BUSCA_CLAVE_CNSF  JICO                                                                          |
-- 

FUNCTION BUSCA_LVALOR(cCodLista VARCHAR2, cCodValor VARCHAR2) RETURN VARCHAR2;

FUNCTION BUSCA_VALORDESC(cCodLista VARCHAR2, cDescValLst VARCHAR2) RETURN VARCHAR2;

FUNCTION BUSCA_CAT_VALOR(cCodLista VARCHAR2) RETURN XMLTYPE;  

FUNCTION BUSCA_CLAVE_CNSF(cCodLista VARCHAR2, cCodValor VARCHAR2) RETURN VARCHAR2;

END OC_VALORES_DE_LISTAS;
/
CREATE OR REPLACE PACKAGE BODY OC_VALORES_DE_LISTAS IS
--
-- MODIFICACIONES
-- 23/08/2021 Se agrego funcion BUSCA_CAT_VALOR  JALV                                                                                |
-- 24/11/2022 Se agrega funcion BUSCA_CLAVE_CNSF  JICO                                                                          |
-- 

FUNCTION BUSCA_LVALOR(cCodLista VARCHAR2, cCodValor VARCHAR2) RETURN VARCHAR2 IS
cDescripcion    VALORES_DE_LISTAS.DescValLst%TYPE;
BEGIN
   BEGIN
      SELECT DescValLst
        INTO cDescripcion
        FROM VALORES_DE_LISTAS
       WHERE CodLista = cCodLista
         AND CodValor = cCodValor;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescripcion := 'Invalida';
   END;
   RETURN(cDescripcion);
END BUSCA_LVALOR;

FUNCTION BUSCA_VALORDESC(cCodLista VARCHAR2, cDescValLst VARCHAR2) RETURN VARCHAR2 IS
cCodValor    VALORES_DE_LISTAS.CodValor%TYPE;
BEGIN
   BEGIN
      SELECT CodValor
        INTO cCodValor
        FROM VALORES_DE_LISTAS
       WHERE CodLista   = cCodLista
         AND DescValLst = cDescValLst;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodValor := 'NO EXISTE';
   END;
   RETURN(cCodValor);
END BUSCA_VALORDESC;

FUNCTION BUSCA_CAT_VALOR(cCodLista VARCHAR2) RETURN XMLTYPE IS
xCat_Valores    XMLTYPE;
xPrevValores    XMLTYPE;

BEGIN
   BEGIN
      SELECT XMLELEMENT("DATA",
                            XMLAGG(XMLELEMENT("CAT_VALORES",  
                                                XMLELEMENT("CodValor", CodValor),
                                                XMLELEMENT("DescValLst", DescValLst)
                                            )
                                  )
                        )
        INTO xPrevValores
        FROM VALORES_DE_LISTAS
       WHERE CodLista   = cCodLista;

   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'No existen valores coincidentes para el codigo de Lista '||cCodLista); 
   END;
   SELECT XMLROOT (xPrevValores, VERSION '1.0" encoding="UTF-8')
     INTO xCat_Valores
     FROM DUAL;

   RETURN xCat_Valores;

END BUSCA_CAT_VALOR;

FUNCTION BUSCA_CLAVE_CNSF(cCodLista VARCHAR2, cCodValor VARCHAR2) RETURN VARCHAR2 IS
cCLAVE_CNSF    VALORES_DE_LISTAS.CVE_CNSF%TYPE;
BEGIN
   BEGIN
      SELECT A.CVE_CNSF
        INTO cCLAVE_CNSF
        FROM VALORES_DE_LISTAS A
       WHERE CodLista = cCodLista
         AND CodValor = cCodValor;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCLAVE_CNSF := NULL;
   END;
   RETURN(cCLAVE_CNSF);
   
END BUSCA_CLAVE_CNSF;

END OC_VALORES_DE_LISTAS;
/

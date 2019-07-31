--
-- GT_CAT_RESPUESTA_DOMICI  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   CAT_RESPUESTA_DOMICI (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_CAT_RESPUESTA_DOMICI AS
    FUNCTION NOTIFICA_CLIENTE(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER, cCodRespuesta VARCHAR2, cDescRespuesta IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION NOTIFICA_OPERACION(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER, cCodRespuesta VARCHAR2, cDescRespuesta IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION NOTIFICA_SOPORTE(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER, cCodRespuesta VARCHAR2, cDescRespuesta IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION PERMITE_REINTENTOS(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER , cCodRespuesta VARCHAR2, cDescRespuesta IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION DIAS_REINTENTOS(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER , cCodRespuesta VARCHAR2, cDescRespuesta IN VARCHAR2) RETURN NUMBER;    
    FUNCTION MAXIMO_REINTENTOS(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER , cCodRespuesta VARCHAR2, cDescRespuesta IN VARCHAR2) RETURN NUMBER;  
    FUNCTION COMENTARIOS(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER , cCodRespuesta VARCHAR2, cDescRespuesta IN VARCHAR2) RETURN VARCHAR2;  
    FUNCTION EXISTE_CONFIG(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER) RETURN VARCHAR2;    
    FUNCTION RESPUESTA_CORRECTA(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, cCodRespuesta VARCHAR2, cDescRespuesta IN VARCHAR2) RETURN VARCHAR2;
END GT_CAT_RESPUESTA_DOMICI;
/

--
-- GT_CAT_RESPUESTA_DOMICI  (Package Body) 
--
--  Dependencies: 
--   GT_CAT_RESPUESTA_DOMICI (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_CAT_RESPUESTA_DOMICI AS
FUNCTION NOTIFICA_CLIENTE(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER, cCodRespuesta VARCHAR2, cDescRespuesta IN VARCHAR2) RETURN VARCHAR2 IS
cIndMailCliente CAT_RESPUESTA_DOMICI.IndMailCliente%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndMailCliente,'N')
        INTO cIndMailCliente 
        FROM CAT_RESPUESTA_DOMICI
       WHERE CodCia           = nCodCia 
         AND CodEntidad       = cCodEntidad 
         AND Correlativo      = nCorrelativo
         AND CodRespuesta     = cCodRespuesta
         AND DescRespuesta    = cDescRespuesta;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         cIndMailCliente := 'N';
      WHEN TOO_MANY_ROWS THEN
         cIndMailCliente := 'S';
   END;
   RETURN cIndMailCliente;
END NOTIFICA_CLIENTE;
    
FUNCTION NOTIFICA_OPERACION(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER, cCodRespuesta VARCHAR2, cDescRespuesta IN VARCHAR2) RETURN VARCHAR2 IS
cIndMailOperacion CAT_RESPUESTA_DOMICI.IndMailOperacion%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndMailOperacion,'N')
        INTO cIndMailOperacion 
        FROM CAT_RESPUESTA_DOMICI
       WHERE CodCia           = nCodCia 
         AND CodEntidad       = cCodEntidad 
         AND Correlativo      = nCorrelativo
         AND CodRespuesta     = cCodRespuesta
         AND DescRespuesta    = cDescRespuesta;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         cIndMailOperacion := 'N';
      WHEN TOO_MANY_ROWS THEN
         cIndMailOperacion := 'S';
   END;
   RETURN cIndMailOperacion;
END NOTIFICA_OPERACION;
    
FUNCTION NOTIFICA_SOPORTE(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER, cCodRespuesta VARCHAR2, cDescRespuesta IN VARCHAR2) RETURN VARCHAR2 IS
cIndMailSoporte CAT_RESPUESTA_DOMICI.IndMailSoporte%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndMailSoporte,'N')
        INTO cIndMailSoporte 
        FROM CAT_RESPUESTA_DOMICI
       WHERE CodCia           = nCodCia 
         AND CodEntidad       = cCodEntidad 
         AND Correlativo      = nCorrelativo
         AND CodRespuesta     = cCodRespuesta
         AND DescRespuesta    = cDescRespuesta;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         cIndMailSoporte := 'N';
      WHEN TOO_MANY_ROWS THEN
         cIndMailSoporte := 'S';
   END;
   RETURN cIndMailSoporte;
END NOTIFICA_SOPORTE;
    
FUNCTION PERMITE_REINTENTOS (nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER , cCodRespuesta VARCHAR2, cDescRespuesta IN VARCHAR2) RETURN VARCHAR2 IS
cIndPermiteReenvio CAT_RESPUESTA_DOMICI.IndPermiteReenvio%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndPermiteReenvio,'N')
        INTO cIndPermiteReenvio 
        FROM CAT_RESPUESTA_DOMICI
       WHERE CodCia           = nCodCia 
         AND CodEntidad       = cCodEntidad 
         AND Correlativo      = nCorrelativo
         AND CodRespuesta     = cCodRespuesta
         AND DescRespuesta    = cDescRespuesta;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN 
      cIndPermiteReenvio := 'N';
   WHEN TOO_MANY_ROWS THEN
      cIndPermiteReenvio := 'S';
   END;
   RETURN cIndPermiteReenvio;
END PERMITE_REINTENTOS;
    
FUNCTION DIAS_REINTENTOS(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER , cCodRespuesta VARCHAR2, cDescRespuesta IN VARCHAR2) RETURN NUMBER IS
nNumDiasReenvio CAT_RESPUESTA_DOMICI.NumDiasReenvio%TYPE;
BEGIN
   BEGIN
      SELECT NVL(NumDiasReenvio,0)
        INTO nNumDiasReenvio 
        FROM CAT_RESPUESTA_DOMICI
       WHERE CodCia           = nCodCia 
         AND CodEntidad       = cCodEntidad 
         AND Correlativo      = nCorrelativo
         AND CodRespuesta     = cCodRespuesta
         AND DescRespuesta    = cDescRespuesta;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN 
      nNumDiasReenvio := 0;
   END;
   RETURN nNumDiasReenvio;
END DIAS_REINTENTOS;
    
FUNCTION MAXIMO_REINTENTOS(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER , cCodRespuesta VARCHAR2, cDescRespuesta IN VARCHAR2) RETURN NUMBER IS
nNumMaxReenvios CAT_RESPUESTA_DOMICI.NumMaxReenvios%TYPE;
BEGIN
   BEGIN
      SELECT NVL(NumMaxReenvios,0)
        INTO nNumMaxReenvios 
        FROM CAT_RESPUESTA_DOMICI
       WHERE CodCia           = nCodCia 
         AND CodEntidad       = cCodEntidad 
         AND Correlativo      = nCorrelativo
         AND CodRespuesta     = cCodRespuesta
         AND DescRespuesta    = cDescRespuesta;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         nNumMaxReenvios := 0;
   END;
   RETURN nNumMaxReenvios;
END MAXIMO_REINTENTOS;
    
FUNCTION COMENTARIOS(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER , cCodRespuesta VARCHAR2, cDescRespuesta IN VARCHAR2) RETURN VARCHAR2 IS
cComentarios CAT_RESPUESTA_DOMICI.Comentarios%TYPE;
BEGIN
   BEGIN
      SELECT NVL(Comentarios,'NA')
        INTO cComentarios
        FROM CAT_RESPUESTA_DOMICI
       WHERE CodCia           = nCodCia 
         AND CodEntidad       = cCodEntidad 
         AND Correlativo      = nCorrelativo
         AND CodRespuesta     = cCodRespuesta
         AND DescRespuesta    = cDescRespuesta;
   EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
         cComentarios := 'NA';
   END;
   RETURN cComentarios;
END COMENTARIOS;
    
FUNCTION EXISTE_CONFIG(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, nCorrelativo IN NUMBER) RETURN VARCHAR2 IS
cExiste VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM CAT_RESPUESTA_DOMICI
       WHERE CodCia           = nCodCia 
         AND CodEntidad       = cCodEntidad 
         AND Correlativo      = nCorrelativo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN 
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN 
         cExiste := 'S';
   END;
   RETURN cExiste;
END EXISTE_CONFIG;
    
FUNCTION RESPUESTA_CORRECTA(nCodCia IN NUMBER, cCodEntidad IN VARCHAR2, cCodRespuesta VARCHAR2, cDescRespuesta IN VARCHAR2) RETURN VARCHAR2 IS
cExiste VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM CAT_RESPUESTA_DOMICI
       WHERE CodCia         = nCodCia 
         AND CodEntidad     = cCodEntidad 
         AND CodRespuesta   = cCodRespuesta
         AND DescRespuesta  = cDescRespuesta
         AND DescRespuesta IN ('OPERADO','ENVIADO');
   END;
   RETURN cExiste;
END RESPUESTA_CORRECTA;
    
END GT_CAT_RESPUESTA_DOMICI;
/

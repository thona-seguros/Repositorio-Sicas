--
-- OC_CORREOS_ELECTRONICOS_PNJ  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CORREOS_ELECTRONICOS_PNJ (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CORREOS_ELECTRONICOS_PNJ IS

FUNCTION EMAIL_PRINCIPAL(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2;
FUNCTION EMAIL_ESPECIFICO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2, nCorrelativo NUMBER) RETURN VARCHAR2;
FUNCTION EXISTE_EMAIL(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                               nIdCuentaCorreo NUMBER) RETURN VARCHAR2;

END OC_CORREOS_ELECTRONICOS_PNJ;
/

--
-- OC_CORREOS_ELECTRONICOS_PNJ  (Package Body) 
--
--  Dependencies: 
--   OC_CORREOS_ELECTRONICOS_PNJ (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CORREOS_ELECTRONICOS_PNJ IS

FUNCTION EMAIL_PRINCIPAL(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2) RETURN VARCHAR2 IS
cEmail     CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
BEGIN
   SELECT Email
     INTO cEmail
     FROM CORREOS_ELECTRONICOS_PNJ
    WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion 
      AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
      AND Email_Principal         = 'S';
   RETURN(cEmail);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR (-20100,'No se Encuentra Correo Principal para Identificación ' || 
                               cTipo_Doc_Identificacion || ' - ' || cNum_Doc_Identificacion);
END EMAIL_PRINCIPAL;

FUNCTION EMAIL_ESPECIFICO(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2, nCorrelativo NUMBER) RETURN VARCHAR2 IS
cEmail     CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
BEGIN
   SELECT Email
     INTO cEmail
     FROM CORREOS_ELECTRONICOS_PNJ
    WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion 
      AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
      AND Correlativo_Email       = nCorrelativo;
   RETURN(cEmail);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR (-20100,'Correlativo de Correo No. ' || nCorrelativo ||' No existe para Identificación ' || 
                               cTipo_Doc_Identificacion || ' - ' || cNum_Doc_Identificacion);
END EMAIL_ESPECIFICO;

FUNCTION EXISTE_EMAIL(cTipo_Doc_Identificacion VARCHAR2, cNum_Doc_Identificacion VARCHAR2,
                               nIdCuentaCorreo NUMBER) RETURN VARCHAR2 IS
cExiste    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM correos_electronicos_pnj
       WHERE Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion
         AND correlativo_email       = nIdcuentaCorreo         ;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTE_EMAIL;

END OC_CORREOS_ELECTRONICOS_PNJ;
/

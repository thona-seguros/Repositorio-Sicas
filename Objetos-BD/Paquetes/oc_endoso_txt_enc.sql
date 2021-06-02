--
-- OC_ENDOSO_TXT_ENC  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   ENDOSO_TXT_ENC (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_ENDOSO_TXT_ENC IS

  FUNCTION DESCRIPCION_TEXTO(nCodCia NUMBER, cCodEndoso VARCHAR2) RETURN VARCHAR2;

  FUNCTION USO_TEXTO(nCodCia NUMBER, cCodEndoso VARCHAR2, cIndUsoTexto VARCHAR2) RETURN VARCHAR2;

  PROCEDURE ACTIVAR(nCodCia NUMBER, cCodEndoso VARCHAR2);

  PROCEDURE ANULAR(nCodCia NUMBER, cCodEndoso VARCHAR2);

END OC_ENDOSO_TXT_ENC;
/

--
-- OC_ENDOSO_TXT_ENC  (Package Body) 
--
--  Dependencies: 
--   OC_ENDOSO_TXT_ENC (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_ENDOSO_TXT_ENC IS

FUNCTION DESCRIPCION_TEXTO(nCodCia NUMBER, cCodEndoso VARCHAR2) RETURN VARCHAR2 IS
cDescripcion   ENDOSO_TXT_ENC.Descripcion%TYPE;
BEGIN
   BEGIN
      SELECT Descripcion
        INTO cDescripcion
        FROM ENDOSO_TXT_ENC
       WHERE CodCia     = nCodCia
         AND CodEndoso  = cCodEndoso;
   EXCEPTION
      WHEN OTHERS THEN
      NULL;
      /*
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Configuración de Texto de Endoso Código '|| cCodEndoso);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros de Texto de Endoso Código '|| cCodEndoso);
      */
   END;
   RETURN(cDescripcion);
END DESCRIPCION_TEXTO;

FUNCTION USO_TEXTO(nCodCia NUMBER, cCodEndoso VARCHAR2, cIndUsoTexto VARCHAR2) RETURN VARCHAR2 IS
cUso    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cUso
        FROM ENDOSO_TXT_ENC
       WHERE CodCia      = nCodCia
         AND CodEndoso   = cCodEndoso
         AND IndUsoTexto = cIndusoTexto;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cUso  := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros de Texto de Endoso Código '|| cCodEndoso);
   END;
   RETURN(cUso);
END USO_TEXTO;

PROCEDURE ACTIVAR(nCodCia NUMBER, cCodEndoso VARCHAR2) IS
BEGIN
   BEGIN
      UPDATE ENDOSO_TXT_ENC
         SET Estado = 'ACTIVO'
       WHERE CodCia      = nCodCia
         AND CodEndoso   = cCodEndoso;
   END;
END ACTIVAR;

PROCEDURE ANULAR(nCodCia NUMBER, cCodEndoso VARCHAR2) IS
BEGIN
   BEGIN
      UPDATE ENDOSO_TXT_ENC
         SET Estado = 'ANULAD'
       WHERE CodCia      = nCodCia
         AND CodEndoso   = cCodEndoso;
   END;
END ANULAR;

END OC_ENDOSO_TXT_ENC;
/

--
-- OC_ENDOSO_TXT_ENC  (Synonym) 
--
--  Dependencies: 
--   OC_ENDOSO_TXT_ENC (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_ENDOSO_TXT_ENC FOR SICAS_OC.OC_ENDOSO_TXT_ENC
/


GRANT EXECUTE ON SICAS_OC.OC_ENDOSO_TXT_ENC TO PUBLIC
/

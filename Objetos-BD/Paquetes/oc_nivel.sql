--
-- OC_NIVEL  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   NIVEL (Table)
--   CAMBIOS_NIVEL (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.oc_nivel  IS
   FUNCTION DESCRIPCION_NIVEL  (nCodCia NUMBER, nCodNivel NUMBER) RETURN VARCHAR2 ;
   PROCEDURE ACTIVAR(nCodCia NUMBER, nCodNivel NUMBER);
   PROCEDURE ACTIVAR_MOD(nCodCia NUMBER, nCodNivel NUMBER, nNUMCAMBIO NUMBER);
   PROCEDURE SUSPENDER(nCodCia NUMBER, nCodNivel NUMBER);
   FUNCTION  PREFIJO_USUARIO_WEB(nCodCia NUMBER, nCodNivel NUMBER) RETURN VARCHAR2;
END OC_NIVEL;
/

--
-- OC_NIVEL  (Package Body) 
--
--  Dependencies: 
--   OC_NIVEL (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.oc_nivel IS

FUNCTION DESCRIPCION_NIVEL (nCodCia NUMBER, nCodNivel NUMBER) RETURN  VARCHAR2 IS
cDescripcion VARCHAR2(200);
BEGIN
   BEGIN
      SELECT Descripcion
        INTO cDescripcion
        FROM NIVEL
       WHERE CodCia     = nCodCia
         AND CodNivel   = nCodNivel;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescripcion := 'NO EXISTE';
   END;
   RETURN(cDescripcion)  ;
END DESCRIPCION_NIVEL;

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodNivel NUMBER) IS
BEGIN
   UPDATE NIVEL
      SET ESTADO   = 'ACTIVO'
   WHERE CodCia    = nCodCia
     AND CodNivel = nCodNivel;
END ACTIVAR;

PROCEDURE ACTIVAR_MOD(nCodCia NUMBER, nCodNivel NUMBER, nNumCambio NUMBER) IS
BEGIN
   UPDATE CAMBIOS_NIVEL
      SET ESTADO   = 'ACTIVO'
   WHERE CodCia    = nCodCia
     AND CodNivel = nCodNivel
     AND NUMCAMBIO = nNumCambio;
END ACTIVAR_MOD;

PROCEDURE SUSPENDER(nCodCia NUMBER, nCodNivel NUMBER) IS
BEGIN
   UPDATE NIVEL
      SET ESTADO   = 'VALID'
   WHERE CodCia    = nCodCia
     AND CodNivel = nCodNivel;
END SUSPENDER;

FUNCTION  PREFIJO_USUARIO_WEB(nCodCia NUMBER, nCodNivel NUMBER) RETURN VARCHAR2 IS
cPrefijoUsuarioWeb NIVEL.PrefijoUsuarioWeb%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PrefijoUsuarioWeb,'SINPREFIJO')
        INTO cPrefijoUsuarioWeb
        FROM NIVEL
       WHERE CodCia     = nCodCia
         AND CodNivel   = nCodNivel;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cPrefijoUsuarioWeb := 'NO EXISTE';
   END;
   RETURN cPrefijoUsuarioWeb;
END PREFIJO_USUARIO_WEB;
END OC_NIVEL;
/

--
-- OC_NIVEL  (Synonym) 
--
--  Dependencies: 
--   OC_NIVEL (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_NIVEL FOR SICAS_OC.OC_NIVEL
/


GRANT EXECUTE ON SICAS_OC.OC_NIVEL TO PUBLIC
/

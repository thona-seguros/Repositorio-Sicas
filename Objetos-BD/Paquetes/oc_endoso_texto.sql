--
-- OC_ENDOSO_TEXTO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   ENDOSO_TEXTO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_ENDOSO_TEXTO IS

  PROCEDURE INSERTA(nIdPoliza NUMBER, nIdEndoso NUMBER, cTextoEndoso VARCHAR2);
  PROCEDURE AGREGA_TEXTO(nIdPoliza NUMBER, nIdEndoso NUMBER, cTextoEndoso VARCHAR2);

END OC_ENDOSO_TEXTO;
/

--
-- OC_ENDOSO_TEXTO  (Package Body) 
--
--  Dependencies: 
--   OC_ENDOSO_TEXTO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_ENDOSO_TEXTO IS

PROCEDURE INSERTA(nIdPoliza NUMBER, nIdEndoso NUMBER, cTextoEndoso VARCHAR2) IS
BEGIN
   BEGIN
      INSERT INTO ENDOSO_TEXTO
            (IdPoliza, IdEndoso, Texto)
      VALUES(nIdPoliza, nIdEndoso, cTextoEndoso);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         UPDATE ENDOSO_TEXTO
            SET Texto = cTextoEndoso
          WHERE IdPoliza  = nIdPoliza
            AND IdEndoso  = nIdEndoso;
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error al Insertar ENDOSO_TEXTO '||SQLERRM);
   END;
END INSERTA;
--
PROCEDURE AGREGA_TEXTO(nIdPoliza NUMBER, nIdEndoso NUMBER, cTextoEndoso VARCHAR2) IS
    cTexto ENDOSO_TEXTO.Texto%TYPE;
BEGIN
   BEGIN
      SELECT Texto
        INTO cTexto
        FROM ENDOSO_TEXTO
       WHERE IdPoliza   = nIdPoliza
         AND IdEndoso   = nIdEndoso;
   
   EXCEPTION
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error al Obtener el Texto en ENDOSO_TEXTO '||SQLERRM);
   END;
   cTexto := cTexto||cTextoEndoso;
   UPDATE ENDOSO_TEXTO
      SET Texto = cTexto
    WHERE IdPoliza  = nIdPoliza
      AND IdEndoso  = nIdEndoso;
END AGREGA_TEXTO;
END OC_ENDOSO_TEXTO;
/

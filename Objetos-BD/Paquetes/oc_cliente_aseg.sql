--
-- OC_CLIENTE_ASEG  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CLIENTE_ASEG (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CLIENTE_ASEG IS

  PROCEDURE INSERTA(nCodCliente NUMBER, nCod_Asegurado NUMBER);

END OC_CLIENTE_ASEG;
/

--
-- OC_CLIENTE_ASEG  (Package Body) 
--
--  Dependencies: 
--   OC_CLIENTE_ASEG (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CLIENTE_ASEG IS

PROCEDURE INSERTA(nCodCliente NUMBER, nCod_Asegurado NUMBER) IS
BEGIN
   BEGIN
      INSERT INTO CLIENTE_ASEG
            (CodCliente, Cod_Asegurado)
      VALUES(nCodCliente, nCod_Asegurado);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         NULL;
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error al Insertar CLIENTE_ASEG '||SQLERRM);
   END;
END INSERTA;

END OC_CLIENTE_ASEG;
/

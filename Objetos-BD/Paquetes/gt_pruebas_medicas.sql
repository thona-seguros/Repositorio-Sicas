--
-- GT_PRUEBAS_MEDICAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   PRUEBAS_MEDICAS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_PRUEBAS_MEDICAS IS

  FUNCTION DESCRIPCION_PRUEBA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPrueba VARCHAR2) RETURN VARCHAR2;
  FUNCTION TEXTO_PRUEBA_MEDICA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPrueba VARCHAR2) RETURN VARCHAR2;

END GT_PRUEBAS_MEDICAS;
/

--
-- GT_PRUEBAS_MEDICAS  (Package Body) 
--
--  Dependencies: 
--   GT_PRUEBAS_MEDICAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_PRUEBAS_MEDICAS IS

FUNCTION DESCRIPCION_PRUEBA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPrueba VARCHAR2) RETURN VARCHAR2 IS
cDescripcion      PRUEBAS_MEDICAS.Descripcion%TYPE;
BEGIN
   BEGIN
      SELECT Descripcion
        INTO cDescripcion
        FROM PRUEBAS_MEDICAS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodPrueba     = cCodPrueba;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescripcion  := 'NO EXISTE';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Prueba Médica ' || cCodPrueba || ' ' || SQLERRM);
   END;
   RETURN(cDescripcion);
END DESCRIPCION_PRUEBA;

FUNCTION TEXTO_PRUEBA_MEDICA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPrueba VARCHAR2) RETURN VARCHAR2 IS
cTextoPrueba      PRUEBAS_MEDICAS.TextoPrueba%TYPE;
BEGIN
   BEGIN
      SELECT TextoPrueba
        INTO cTextoPrueba
        FROM PRUEBAS_MEDICAS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodPrueba     = cCodPrueba;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTextoPrueba  := 'NO EXISTE';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20220,'Error en Configuración de Prueba Médica ' || cCodPrueba || ' ' || SQLERRM);
   END;
   RETURN(cTextoPrueba);
END TEXTO_PRUEBA_MEDICA;

END GT_PRUEBAS_MEDICAS;
/

--
-- GT_PRUEBAS_MEDICAS  (Synonym) 
--
--  Dependencies: 
--   GT_PRUEBAS_MEDICAS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_PRUEBAS_MEDICAS FOR SICAS_OC.GT_PRUEBAS_MEDICAS
/


GRANT EXECUTE ON SICAS_OC.GT_PRUEBAS_MEDICAS TO PUBLIC
/

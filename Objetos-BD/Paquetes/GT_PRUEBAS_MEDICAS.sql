CREATE OR REPLACE PACKAGE GT_PRUEBAS_MEDICAS IS

  FUNCTION DESCRIPCION_PRUEBA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPrueba VARCHAR2) RETURN VARCHAR2;
  FUNCTION TEXTO_PRUEBA_MEDICA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPrueba VARCHAR2) RETURN VARCHAR2;

END GT_PRUEBAS_MEDICAS;
/

CREATE OR REPLACE PACKAGE BODY GT_PRUEBAS_MEDICAS IS

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
         RAISE_APPLICATION_ERROR(-20220,'Error en Configuraci�n de Prueba M�dica ' || cCodPrueba || ' ' || SQLERRM);
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
         RAISE_APPLICATION_ERROR(-20220,'Error en Configuraci�n de Prueba M�dica ' || cCodPrueba || ' ' || SQLERRM);
   END;
   RETURN(cTextoPrueba);
END TEXTO_PRUEBA_MEDICA;

END GT_PRUEBAS_MEDICAS;
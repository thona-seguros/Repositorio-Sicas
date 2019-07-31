--
-- OC_FILIALES_CATEGORIAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FILIALES_CATEGORIAS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_FILIALES_CATEGORIAS  IS
   FUNCTION DESCRIPCION_CATEGORIA (nCodCia NUMBER, cCodGrupoEc VARCHAR2, 
                                   cCodFilial VARCHAR2, cCodCategoria VARCHAR2) RETURN VARCHAR2 ;
   PROCEDURE VALIDA_CREA(nCodCia NUMBER, cCodGrupoEc VARCHAR2, cCodFilial VARCHAR2, 
                         cCodCategoria VARCHAR2, cDescripcion VARCHAR2);

END OC_FILIALES_CATEGORIAS;
/

--
-- OC_FILIALES_CATEGORIAS  (Package Body) 
--
--  Dependencies: 
--   OC_FILIALES_CATEGORIAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_FILIALES_CATEGORIAS IS
FUNCTION DESCRIPCION_CATEGORIA (nCodCia NUMBER, cCodGrupoEc VARCHAR2, 
                                cCodFilial VARCHAR2, cCodCategoria VARCHAR2) RETURN  VARCHAR2 IS
cDescripcion  FILIALES_CATEGORIAS.Descripcion%TYPE;
BEGIN
   BEGIN
      SELECT Descripcion
        INTO cDescripcion
        FROM FILIALES_CATEGORIAS
       WHERE CodCia     = nCodCia
         AND CodGrupoEc = cCodgrupoEc
         AND CodFilial  = cCodFilial
         AND CodCategoria = cCodCategoria;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescripcion := 'NO EXISTE';
   END;
   RETURN(cDescripcion);
END DESCRIPCION_CATEGORIA;

PROCEDURE VALIDA_CREA(nCodCia NUMBER, cCodGrupoEc VARCHAR2, cCodFilial VARCHAR2, 
                      cCodCategoria VARCHAR2, cDescripcion VARCHAR2) IS
cExiste   VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM FILIALES_CATEGORIAS
       WHERE CodCia       = nCodCia
         AND CodGrupoEc   = cCodGrupoEc
         AND CodFilial    = cCodFilial
         AND CodCategoria = cCodCategoria;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         INSERT INTO FILIALES_CATEGORIAS
                (CodCategoria, CodCia, CodGrupoEc, CodFilial,
                 Descripcion, Estado)
         VALUES (cCodCategoria, nCodCia, cCodGrupoEc, cCodFilial,
                 cDescripcion, 'ACTIVO');
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existe Varias Categorías para Filial o SubGrupos : ' || 
                                 cCodFilial || ' del Grupo Económico ' || cCodGrupoEc);
   END;
END VALIDA_CREA;

END OC_FILIALES_CATEGORIAS;
/

--
-- OC_FILIALES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FILIALES (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_FILIALES  IS
   FUNCTION NOMBRE_FILIAL (nCodCia NUMBER, cCodGrupoEc VARCHAR2, cCodFilial VARCHAR2) RETURN VARCHAR2;
   FUNCTION NOMBRE_ADICIONAL(nCodCia NUMBER, cCodGrupoEc VARCHAR2, cCodFilial VARCHAR2) RETURN VARCHAR2;
   PROCEDURE VALIDA_CREA(nCodCia NUMBER, cCodGrupoEc VARCHAR2, cTipo_Doc_Identificacion VARCHAR2, 
                         cNum_Doc_Identificacion VARCHAR2, cCodFilial VARCHAR2, cDescripcion VARCHAR2);
END OC_FILIALES;
/

--
-- OC_FILIALES  (Package Body) 
--
--  Dependencies: 
--   OC_FILIALES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_FILIALES IS
FUNCTION NOMBRE_FILIAL (nCodCia NUMBER, cCodGrupoEc VARCHAR2, cCodFilial VARCHAR2) RETURN  VARCHAR2 IS
cNombre VARCHAR2(200);
BEGIN
   BEGIN
      SELECT TRIM(Nombre) || ' ' || TRIM(Apellido_Paterno) || ' ' ||
             TRIM(Apellido_Materno) || ' ' || DECODE(ApeCasada, NULL, ' ', ' de ' ||ApeCasada)
        INTO cNombre
        FROM PERSONA_NATURAL_JURIDICA
       WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
             (SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                FROM FILIALES
               WHERE CodCia     = nCodCia
                 AND CodGrupoEc = cCodgrupoEc
                 AND CodFilial  = cCodFilial);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNombre := 'NO EXISTE';
   END;
   RETURN(cNombre)  ;
END NOMBRE_FILIAL;

FUNCTION NOMBRE_ADICIONAL(nCodCia NUMBER, cCodGrupoEc VARCHAR2, cCodFilial VARCHAR2) RETURN VARCHAR2 IS
cNomAdicFilial    FILIALES.NomAdicFilial%TYPE;
BEGIN
   BEGIN
      SELECT NomAdicFilial
        INTO cNomAdicFilial
        FROM FILIALES
       WHERE CodCia     = nCodCia
         AND CodGrupoEc = cCodgrupoEc
         AND CodFilial  = cCodFilial;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNomAdicFilial := NULL;
   END;
   RETURN(cNomAdicFilial);
END NOMBRE_ADICIONAL;

PROCEDURE VALIDA_CREA(nCodCia NUMBER, cCodGrupoEc VARCHAR2, cTipo_Doc_Identificacion VARCHAR2, 
                      cNum_Doc_Identificacion VARCHAR2, cCodFilial VARCHAR2, cDescripcion VARCHAR2) IS
cExiste   VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM FILIALES
       WHERE CodCia                  = nCodCia
         AND CodGrupoEc              = cCodGrupoEc
         AND CodFilial               = cCodFilial
         AND Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         INSERT INTO FILIALES
                (CodFilial, CodCia, CodGrupoEc, Tipo_Doc_Identificacion, Num_Doc_Identificacion,
                 Descripcion, Estado, NomAdicFilial)
         VALUES (cCodFilial, nCodCia, cCodGrupoEc, cTipo_Doc_Identificacion, cNum_Doc_Identificacion,
                 cDescripcion, 'ACTIVO', NULL);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existe Varias Filiales o SubGrupos para Tipo Doc. de Identificación : ' || 
                                 cTipo_Doc_Identificacion || ' No. ' || cNum_Doc_Identificacion);
   END;
END VALIDA_CREA;

END OC_FILIALES;
/

--
-- OC_FILIALES  (Synonym) 
--
--  Dependencies: 
--   OC_FILIALES (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_FILIALES FOR SICAS_OC.OC_FILIALES
/


GRANT EXECUTE ON SICAS_OC.OC_FILIALES TO PUBLIC
/

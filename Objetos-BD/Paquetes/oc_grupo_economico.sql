--
-- OC_GRUPO_ECONOMICO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   PERSONA_NATURAL_JURIDICA (Table)
--   GRUPO_ECONOMICO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_GRUPO_ECONOMICO  IS
   FUNCTION NOMBRE_GRUPO_ECONOMICO(nCodCia NUMBER, cCodGrupoEc VARCHAR2) RETURN VARCHAR2;

   FUNCTION VALIDA_CREA(nCodCia NUMBER, cTipo_Doc_Identificacion VARCHAR2, 
                        cNum_Doc_Identificacion VARCHAR2, nIdSolicitud NUMBER) RETURN VARCHAR2;

END OC_GRUPO_ECONOMICO;
/

--
-- OC_GRUPO_ECONOMICO  (Package Body) 
--
--  Dependencies: 
--   OC_GRUPO_ECONOMICO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_GRUPO_ECONOMICO IS
FUNCTION NOMBRE_GRUPO_ECONOMICO(nCodCia NUMBER, cCodGrupoEc VARCHAR2) RETURN  VARCHAR2 IS
cNombre VARCHAR2(200);
BEGIN
   BEGIN
      SELECT TRIM(Nombre) || ' ' || TRIM(Apellido_Paterno) || ' ' ||
             TRIM(Apellido_Materno) || ' ' || DECODE(ApeCasada, NULL, ' ', ' de ' ||ApeCasada)
        INTO cNombre
        FROM PERSONA_NATURAL_JURIDICA
       WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
             (SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                FROM GRUPO_ECONOMICO
               WHERE CodCia     = nCodCia
                 AND CodGrupoEc = cCodgrupoEc);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNombre := 'NO EXISTE';
   END;
   RETURN(cNombre);
END NOMBRE_GRUPO_ECONOMICO;

FUNCTION VALIDA_CREA(nCodCia NUMBER, cTipo_Doc_Identificacion VARCHAR2,
                     cNum_Doc_Identificacion VARCHAR2, nIdSolicitud NUMBER) RETURN VARCHAR2 IS
cCodGrupoEc       GRUPO_ECONOMICO.CodGrupoEc%TYPE;
BEGIN
   BEGIN
      SELECT CodGrupoEc
        INTO cCodGrupoEc
        FROM GRUPO_ECONOMICO
       WHERE CodCia                  = nCodCia
         AND Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
         AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodGrupoEc := 'GEDR-'||TRIM(TO_CHAR(nIdSolicitud,'00000000'));
         INSERT INTO GRUPO_ECONOMICO
                (CodGrupoEc, Tipo_Doc_Identificacion, Num_Doc_Identificacion,
                 CodCia, Observaciones, Estado)
         VALUES (cCodGrupoEc, cTipo_Doc_Identificacion, cNum_Doc_Identificacion,
                 nCodCia, 'GRUPO ECONOMICO X DIRECCION REGIONAL', 'ACTIVO');
      WHEN TOO_MANY_ROWS THEN
         SELECT MAX(CodGrupoEc)
           INTO cCodGrupoEc
           FROM GRUPO_ECONOMICO
          WHERE CodCia                  = nCodCia
            AND Tipo_Doc_Identificacion = cTipo_Doc_Identificacion
            AND Num_Doc_Identificacion  = cNum_Doc_Identificacion;
   END;
   RETURN(cCodGrupoEc);
END VALIDA_CREA;

END OC_GRUPO_ECONOMICO;
/

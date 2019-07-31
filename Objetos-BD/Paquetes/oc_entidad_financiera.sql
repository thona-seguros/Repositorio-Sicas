--
-- OC_ENTIDAD_FINANCIERA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   ENTIDAD_FINANCIERA (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_ENTIDAD_FINANCIERA IS

  FUNCTION DESCRIPCION(nCodCia NUMBER, cCodEntidad VARCHAR2) RETURN VARCHAR2;
  PROCEDURE ACTIVAR(nCodCia NUMBER, cCodEntidad VARCHAR2);
  PROCEDURE SUSPENDER(nCodCia NUMBER, cCodEntidad VARCHAR2);

END OC_ENTIDAD_FINANCIERA;
/

--
-- OC_ENTIDAD_FINANCIERA  (Package Body) 
--
--  Dependencies: 
--   OC_ENTIDAD_FINANCIERA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_ENTIDAD_FINANCIERA IS

FUNCTION DESCRIPCION(nCodCia NUMBER, cCodEntidad VARCHAR2) RETURN VARCHAR2 IS
cDescEntidad    VARCHAR2(500);
cTipoDocId      PERSONA_NATURAL_JURIDICA.Tipo_Doc_Identificacion%TYPE;
cNumDocId       PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE;
BEGIN
   BEGIN
      SELECT TRIM(Nombre) || ' ' || TRIM(Apellido_Paterno) || ' ' ||
             TRIM(Apellido_Materno) || ' ' || DECODE(ApeCasada, NULL, ' ', ' de ' ||ApeCasada)
        INTO cDescEntidad
        FROM PERSONA_NATURAL_JURIDICA P
       WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
             (SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                FROM ENTIDAD_FINANCIERA E
               WHERE E.CodCia     = nCodCia
                 AND E.CodEntidad = cCodEntidad);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescEntidad := 'ENTIDAD FINANCIERA NO EXISTE';
   END;
   --
   RETURN(cDescEntidad);
   --
END DESCRIPCION;
--
PROCEDURE ACTIVAR(nCodCia NUMBER, cCodEntidad VARCHAR2) IS
BEGIN
   UPDATE ENTIDAD_FINANCIERA
      SET Estado       = 'ACTIVA',
          Fecha_Estado = TRUNC(SYSDATE),          
          CodUsuario   = USER
    WHERE CodCia     = nCodCia
      AND CodEntidad = cCodEntidad;
    --   
END ACTIVAR;
--
PROCEDURE SUSPENDER(nCodCia NUMBER, cCodEntidad VARCHAR2) IS

BEGIN
   UPDATE ENTIDAD_FINANCIERA
      SET Estado       = 'SUSPEN',
          Fecha_Estado = TRUNC(SYSDATE),          
          CodUsuario   = USER
    WHERE CodCia     = nCodCia
      AND CodEntidad = cCodEntidad;
   --   
END SUSPENDER;
--
END OC_ENTIDAD_FINANCIERA;
/

CREATE OR REPLACE PACKAGE SICAS_OC.OC_ENTIDAD_FINANCIERA IS

  FUNCTION DESCRIPCION(nCodCia NUMBER, cCodEntidad VARCHAR2) RETURN VARCHAR2;
  
  FUNCTION NOMBRE_COMERCIAL(nCodCia NUMBER, cCodEntidad VARCHAR2) RETURN VARCHAR2; -- BANCO
  
  PROCEDURE ACTIVAR(nCodCia NUMBER, cCodEntidad VARCHAR2);
  
  PROCEDURE SUSPENDER(nCodCia NUMBER, cCodEntidad VARCHAR2);

END OC_ENTIDAD_FINANCIERA;
/
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_ENTIDAD_FINANCIERA IS
--
-- 25/03/2020  SE AGRGO LA UNCIONALIDA DE NOMBRE COMERCIAL  ICO -- BANCO
--
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
FUNCTION NOMBRE_COMERCIAL(nCodCia NUMBER, cCodEntidad VARCHAR2) RETURN VARCHAR2 IS  -- BANCO
cDescEntidad    VARCHAR2(500);
cTipoDocId      PERSONA_NATURAL_JURIDICA.Tipo_Doc_Identificacion%TYPE;
cNumDocId       PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE;
BEGIN
   BEGIN
      SELECT P.NOMBRECOMERCIAL
        INTO cDescEntidad
        FROM PERSONA_NATURAL_JURIDICA P
       WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
             (SELECT Tipo_Doc_Identificacion, Num_Doc_Identificacion
                FROM ENTIDAD_FINANCIERA E
               WHERE E.CodCia     = nCodCia
                 AND E.CodEntidad = cCodEntidad);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescEntidad := '';
   END;
   --
   RETURN(cDescEntidad);
   --
END NOMBRE_COMERCIAL;           -- BANCO
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

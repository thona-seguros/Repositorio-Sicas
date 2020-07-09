--
-- OC_EJECUTIVO_COMERCIAL  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CORREOS_ELECTRONICOS_PNJ (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--   OC_CORREOS_ELECTRONICOS_PNJ (Package)
--   EJECUTIVO_COMERCIAL (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_EJECUTIVO_COMERCIAL IS

  PROCEDURE ACTIVAR_EJECUTIVO(nCodCia NUMBER, nCodEjecutivo NUMBER);
  PROCEDURE SUSPENDER_EJECUTIVO(nCodCia NUMBER, nCodEjecutivo NUMBER);
  FUNCTION NOMBRE_EJECUTIVO(nCodCia NUMBER, nCodEjecutivo NUMBER) RETURN VARCHAR2;
  FUNCTION EMAIL_EJECUTIVO(nCodCia NUMBER, nCodEjecutivo NUMBER) RETURN VARCHAR2;

END OC_EJECUTIVO_COMERCIAL;
/

--
-- OC_EJECUTIVO_COMERCIAL  (Package Body) 
--
--  Dependencies: 
--   OC_EJECUTIVO_COMERCIAL (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_EJECUTIVO_COMERCIAL IS

PROCEDURE ACTIVAR_EJECUTIVO(nCodCia NUMBER, nCodEjecutivo NUMBER) IS
BEGIN
   UPDATE EJECUTIVO_COMERCIAL
      SET StsEjecutivo = 'ACTIV',
          FecSts       = TRUNC(SYSDATE)
    WHERE CodCia       = nCodCia
      AND CodEjecutivo = nCodEjecutivo;
END ACTIVAR_EJECUTIVO;

PROCEDURE SUSPENDER_EJECUTIVO(nCodCia NUMBER, nCodEjecutivo NUMBER) IS
BEGIN
   UPDATE EJECUTIVO_COMERCIAL
      SET StsEjecutivo = 'SUSPE',
          FecSts       = TRUNC(SYSDATE)
    WHERE CodCia       = nCodCia
      AND CodEjecutivo = nCodEjecutivo;
END SUSPENDER_EJECUTIVO;

FUNCTION NOMBRE_EJECUTIVO(nCodCia NUMBER, nCodEjecutivo NUMBER) RETURN VARCHAR2 IS
cNombre       VARCHAR2(500);
BEGIN
   BEGIN
      SELECT TRIM(Nombre) || ' ' || TRIM(Apellido_Paterno) || ' ' || TRIM(Apellido_Materno) || ' ' || TRIM(ApeCasada)
        INTO cNombre
        FROM PERSONA_NATURAL_JURIDICA
       WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
             (SELECT TipoDocIdentEjec, NumDocIdentEjec
                FROM EJECUTIVO_COMERCIAL
               WHERE CodCia        = nCodCia
                 AND CodEjecutivo  = nCodEjecutivo);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNombre := 'Ejecutivo Comercial Código ' || nCodEjecutivo || ' NO Existe';
   END;
   RETURN(cNombre);
END NOMBRE_EJECUTIVO;

FUNCTION EMAIL_EJECUTIVO(nCodCia NUMBER, nCodEjecutivo NUMBER) RETURN VARCHAR2 IS
cTipoDocIdentEjec          EJECUTIVO_COMERCIAL.TipoDocIdentEjec%TYPE;
cNumDocIdentEjec           EJECUTIVO_COMERCIAL.NumDocIdentEjec%TYPE;
cEmailEjecutivo            CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
BEGIN
   BEGIN
      SELECT TipoDocIdentEjec, NumDocIdentEjec
        INTO cTipoDocIdentEjec, cNumDocIdentEjec
        FROM EJECUTIVO_COMERCIAL
       WHERE CodCia        = nCodCia
         AND CodEjecutivo  = nCodEjecutivo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'Ejecutivo Comercial Código ' || nCodEjecutivo || ' NO Existe');
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existe Configurados Varios Ejecutivos Comerciales con el Código ' || nCodEjecutivo);
   END;
   cEmailEjecutivo := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(cTipoDocIdentEjec, cNumDocIdentEjec);

   RETURN(cEmailEjecutivo);
END EMAIL_EJECUTIVO;

END OC_EJECUTIVO_COMERCIAL;
/

--
-- OC_EJECUTIVO_COMERCIAL  (Synonym) 
--
--  Dependencies: 
--   OC_EJECUTIVO_COMERCIAL (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_EJECUTIVO_COMERCIAL FOR SICAS_OC.OC_EJECUTIVO_COMERCIAL
/


GRANT EXECUTE ON SICAS_OC.OC_EJECUTIVO_COMERCIAL TO PUBLIC
/

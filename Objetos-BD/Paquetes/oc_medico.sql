--
-- OC_MEDICO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   OC_CORREOS_ELECTRONICOS_PNJ (Package)
--   MEDICO (Table)
--   CORREOS_ELECTRONICOS_PNJ (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_MEDICO IS

  PROCEDURE ACTIVAR_MEDICO(nCodCia NUMBER, nCodMedico NUMBER);
  PROCEDURE SUSPENDER_MEDICO(nCodCia NUMBER, nCodMedico NUMBER);
  FUNCTION NOMBRE_MEDICO(nCodCia NUMBER, nCodMedico NUMBER) RETURN VARCHAR2;
  FUNCTION EMAIL_MEDICO(nCodCia NUMBER, nCodMedico NUMBER) RETURN VARCHAR2;

END OC_MEDICO;
/

--
-- OC_MEDICO  (Package Body) 
--
--  Dependencies: 
--   OC_MEDICO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_MEDICO IS

PROCEDURE ACTIVAR_MEDICO(nCodCia NUMBER, nCodMedico NUMBER) IS
BEGIN
   UPDATE MEDICO
      SET StsMedico    = 'ACTIV',
          FecSts       = TRUNC(SYSDATE)
    WHERE CodCia       = nCodCia
      AND CodMedico    = nCodMedico;
END ACTIVAR_MEDICO;

PROCEDURE SUSPENDER_MEDICO(nCodCia NUMBER, nCodMedico NUMBER) IS
BEGIN
   UPDATE MEDICO
      SET StsMedico    = 'SUSPEN',
          FecSts       = TRUNC(SYSDATE)
    WHERE CodCia       = nCodCia
      AND CodMedico    = nCodMedico;
END SUSPENDER_MEDICO;

FUNCTION NOMBRE_MEDICO(nCodCia NUMBER, nCodMedico NUMBER) RETURN VARCHAR2 IS
cNombre       VARCHAR2(500);
BEGIN
   BEGIN
      SELECT TRIM(Nombre) || ' ' || TRIM(Apellido_Paterno) || ' ' || TRIM(Apellido_Materno) || ' ' || TRIM(ApeCasada)
        INTO cNombre
        FROM PERSONA_NATURAL_JURIDICA
       WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
             (SELECT TipoDocIdentMed, NumDocIdentMed
                FROM MEDICO
               WHERE CodCia     = nCodCia
                 AND CodMedico  = nCodMedico);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNombre := 'Médico con Código ' || nCodMedico || ' NO Existe';
   END;
   RETURN(cNombre);
END NOMBRE_MEDICO;

FUNCTION EMAIL_MEDICO(nCodCia NUMBER, nCodMedico NUMBER) RETURN VARCHAR2 IS
cTipoDocIdentMed          MEDICO.TipoDocIdentMed%TYPE;
cNumDocIdentMed           MEDICO.NumDocIdentMed%TYPE;
cEmailMedico              CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
BEGIN
   BEGIN
      SELECT TipoDocIdentMed, NumDocIdentMed
        INTO cTipoDocIdentMed, cNumDocIdentMed
        FROM MEDICO
       WHERE CodCia     = nCodCia
         AND CodMedico  = nCodMedico;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'Médico con Código ' || nCodMedico || ' NO Existe');
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existe Configurados Varios Médicos con el Código ' || nCodMedico);
   END;
   cEmailMedico := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(cTipoDocIdentMed, cNumDocIdentMed);

   RETURN(cEmailMedico);
END EMAIL_MEDICO;

END OC_MEDICO;
/

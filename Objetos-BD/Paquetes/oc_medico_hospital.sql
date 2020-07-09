--
-- OC_MEDICO_HOSPITAL  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   MEDICO_HOSPITAL (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_MEDICO_HOSPITAL IS

  PROCEDURE ACTIVAR_HOSPITAL(nCodCia NUMBER, nCodMedico NUMBER, 
                             cTipoDocIdentHosp VARCHAR2, cNumDocIdentHosp VARCHAR2);
  PROCEDURE SUSPENDER_HOSPITAL(nCodCia NUMBER, nCodMedico NUMBER, 
                             cTipoDocIdentHosp VARCHAR2, cNumDocIdentHosp VARCHAR2);
  FUNCTION HOSPITAL_PRIMARIO(nCodCia NUMBER, nCodMedico VARCHAR2) RETURN VARCHAR2;

  FUNCTION HOSPITAL_SECUNDARIO(nCodCia NUMBER, nCodMedico VARCHAR2) RETURN VARCHAR2;

END OC_MEDICO_HOSPITAL;
/

--
-- OC_MEDICO_HOSPITAL  (Package Body) 
--
--  Dependencies: 
--   OC_MEDICO_HOSPITAL (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_MEDICO_HOSPITAL IS

PROCEDURE ACTIVAR_HOSPITAL(nCodCia NUMBER, nCodMedico NUMBER, 
                           cTipoDocIdentHosp VARCHAR2, cNumDocIdentHosp VARCHAR2) IS
BEGIN
   UPDATE MEDICO_HOSPITAL
      SET StsHospital  = 'ACTIV',
          FecSts       = TRUNC(SYSDATE)
    WHERE CodCia           = nCodCia
      AND CodMedico        = nCodMedico
      AND TipoDocIdentHosp = cTipoDocIdentHosp
      AND NumDocIdentHosp  = cNumDocIdentHosp;
END ACTIVAR_HOSPITAL;

PROCEDURE SUSPENDER_HOSPITAL(nCodCia NUMBER, nCodMedico NUMBER, 
                             cTipoDocIdentHosp VARCHAR2, cNumDocIdentHosp VARCHAR2) IS
BEGIN
   UPDATE MEDICO_HOSPITAL
      SET StsHospital  = 'SUSPEN',
          FecSts       = TRUNC(SYSDATE)
    WHERE CodCia           = nCodCia
      AND CodMedico        = nCodMedico
      AND TipoDocIdentHosp = cTipoDocIdentHosp
      AND NumDocIdentHosp  = cNumDocIdentHosp;
END SUSPENDER_HOSPITAL;

FUNCTION HOSPITAL_PRIMARIO(nCodCia NUMBER, nCodMedico VARCHAR2) RETURN VARCHAR2 IS
cNombre       VARCHAR2(500);
BEGIN
   BEGIN
      SELECT TRIM(Nombre) || ' ' || TRIM(Apellido_Paterno) || ' ' || TRIM(Apellido_Materno) || ' ' || TRIM(ApeCasada)
        INTO cNombre
        FROM PERSONA_NATURAL_JURIDICA
       WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
             (SELECT TipoDocIdentHosp, NumDocIdentHosp
                FROM MEDICO_HOSPITAL
               WHERE CodCia              = nCodCia
                 AND CodMedico           = nCodMedico
                 AND IndHospitalPrimario = 'S');
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNombre := 'Médico con Código ' || nCodMedico || ' NO Existe';
   END;
   RETURN(cNombre);
END HOSPITAL_PRIMARIO;

FUNCTION HOSPITAL_SECUNDARIO(nCodCia NUMBER, nCodMedico VARCHAR2) RETURN VARCHAR2 IS
cNombre       VARCHAR2(4000);
CURSOR HOSP_Q IS
   SELECT TRIM(Nombre) || ' ' || TRIM(Apellido_Paterno) || ' ' || TRIM(Apellido_Materno) || ' ' || TRIM(ApeCasada) NombreHospital
     INTO cNombre
     FROM PERSONA_NATURAL_JURIDICA
    WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
          (SELECT TipoDocIdentHosp, NumDocIdentHosp
             FROM MEDICO_HOSPITAL
            WHERE CodCia              = nCodCia
              AND CodMedico           = nCodMedico
              AND IndHospitalPrimario = 'N');
BEGIN
   FOR W IN HOSP_Q LOOP
      IF cNombre IS NOT NULL THEN
         cNombre := cNombre || ', ' || W.NombreHospital;
      ELSE
         cNombre := cNombre || W.NombreHospital;
      END IF;
   END LOOP;
   RETURN(cNombre);
END HOSPITAL_SECUNDARIO;

END OC_MEDICO_HOSPITAL;
/

--
-- OC_MEDICO_HOSPITAL  (Synonym) 
--
--  Dependencies: 
--   OC_MEDICO_HOSPITAL (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_MEDICO_HOSPITAL FOR SICAS_OC.OC_MEDICO_HOSPITAL
/


GRANT EXECUTE ON SICAS_OC.OC_MEDICO_HOSPITAL TO PUBLIC
/

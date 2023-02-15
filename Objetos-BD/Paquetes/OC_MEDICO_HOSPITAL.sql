CREATE OR REPLACE PACKAGE OC_MEDICO_HOSPITAL IS

  PROCEDURE ACTIVAR_HOSPITAL(nCodCia NUMBER, nCodMedico NUMBER, 
                             cTipoDocIdentHosp VARCHAR2, cNumDocIdentHosp VARCHAR2);
  PROCEDURE SUSPENDER_HOSPITAL(nCodCia NUMBER, nCodMedico NUMBER, 
                             cTipoDocIdentHosp VARCHAR2, cNumDocIdentHosp VARCHAR2);
  FUNCTION HOSPITAL_PRIMARIO(nCodCia NUMBER, nCodMedico VARCHAR2) RETURN VARCHAR2;

  FUNCTION HOSPITAL_SECUNDARIO(nCodCia NUMBER, nCodMedico VARCHAR2) RETURN VARCHAR2;

END OC_MEDICO_HOSPITAL;
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_MEDICO_HOSPITAL IS

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

--
-- OC_DIRECCION_REGIONAL  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CORREOS_ELECTRONICOS_PNJ (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--   OC_CORREOS_ELECTRONICOS_PNJ (Package)
--   DIRECCION_REGIONAL (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_DIRECCION_REGIONAL IS

  PROCEDURE ACTIVAR_DIRECCION(nCodCia NUMBER, nCodDirecRegional NUMBER);
  PROCEDURE SUSPENDER_DIRECCION(nCodCia NUMBER, nCodDirecRegional NUMBER);
  FUNCTION NOMBRE_DIRECCION(nCodCia NUMBER, nCodDirecRegional NUMBER) RETURN VARCHAR2;
  FUNCTION EMAIL_DIRECCION(nCodCia NUMBER, nCodDirecRegional NUMBER) RETURN VARCHAR2;

END OC_DIRECCION_REGIONAL;
/

--
-- OC_DIRECCION_REGIONAL  (Package Body) 
--
--  Dependencies: 
--   OC_DIRECCION_REGIONAL (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_DIRECCION_REGIONAL IS

PROCEDURE ACTIVAR_DIRECCION(nCodCia NUMBER, nCodDirecRegional NUMBER) IS
BEGIN
   UPDATE DIRECCION_REGIONAL
      SET StsDirecRegional = 'ACTIV',
          FecSts           = TRUNC(SYSDATE)
    WHERE CodCia           = nCodCia
      AND CodDirecRegional = nCodDirecRegional;
END ACTIVAR_DIRECCION;

PROCEDURE SUSPENDER_DIRECCION(nCodCia NUMBER, nCodDirecRegional NUMBER) IS
BEGIN
   UPDATE DIRECCION_REGIONAL
      SET StsDirecRegional = 'SUSPEN',
          FecSts           = TRUNC(SYSDATE)
    WHERE CodCia           = nCodCia
      AND CodDirecRegional = nCodDirecRegional;
END SUSPENDER_DIRECCION;

FUNCTION NOMBRE_DIRECCION(nCodCia NUMBER, nCodDirecRegional NUMBER) RETURN VARCHAR2 IS
cNombre       VARCHAR2(500);
BEGIN
   BEGIN
      SELECT TRIM(Nombre) || ' ' || TRIM(Apellido_Paterno) || ' ' || TRIM(Apellido_Materno) || ' ' || TRIM(ApeCasada)
        INTO cNombre
        FROM PERSONA_NATURAL_JURIDICA
       WHERE (Tipo_Doc_Identificacion, Num_Doc_Identificacion) IN
             (SELECT TipoDocIdentDirec, NumDocIdentDirec
                FROM DIRECCION_REGIONAL
               WHERE CodCia            = nCodCia
                 AND CodDirecRegional  = nCodDirecRegional);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNombre := 'Dirección Regional Código ' || nCodDirecRegional || ' NO Existe';
   END;
   RETURN(cNombre);
END NOMBRE_DIRECCION;

FUNCTION EMAIL_DIRECCION(nCodCia NUMBER, nCodDirecRegional NUMBER) RETURN VARCHAR2 IS
cTipoDocIdentDirec          DIRECCION_REGIONAL.TipoDocIdentDirec%TYPE;
cNumDocIdentDirec           DIRECCION_REGIONAL.NumDocIdentDirec%TYPE;
cEmailDirecRegional         CORREOS_ELECTRONICOS_PNJ.Email%TYPE;
BEGIN
   BEGIN
      SELECT TipoDocIdentDirec, NumDocIdentDirec
        INTO cTipoDocIdentDirec, cNumDocIdentDirec
        FROM DIRECCION_REGIONAL
       WHERE CodCia            = nCodCia
         AND CodDirecRegional  = nCodDirecRegional;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'Ejecutivo Comercial Código ' || nCodDirecRegional || ' NO Existe');
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existe Configuradas Varias Direcciones Regionales con el Código ' || nCodDirecRegional);
   END;
   cEmailDirecRegional := OC_CORREOS_ELECTRONICOS_PNJ.EMAIL_PRINCIPAL(cTipoDocIdentDirec, cNumDocIdentDirec);

   RETURN(cEmailDirecRegional);
END EMAIL_DIRECCION;

END OC_DIRECCION_REGIONAL;
/

--
-- OC_DIRECCION_REGIONAL  (Synonym) 
--
--  Dependencies: 
--   OC_DIRECCION_REGIONAL (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_DIRECCION_REGIONAL FOR SICAS_OC.OC_DIRECCION_REGIONAL
/


GRANT EXECUTE ON SICAS_OC.OC_DIRECCION_REGIONAL TO PUBLIC
/

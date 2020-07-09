--
-- OC_TARJETAS_PREPAGO_ACTIV  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   PERSONA_NATURAL_JURIDICA (Table)
--   APARTADO_POSTAL (Table)
--   TARJETAS_PREPAGO_ACTIV (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_TARJETAS_PREPAGO_ACTIV IS

  FUNCTION POLIZA_TARJETA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2;
  PROCEDURE INSERTA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                 cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,cTipoDocIdentAseg VARCHAR2,nNumDocIdentAseg NUMBER) ;
  FUNCTION EXISTE (nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                 cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,cTipoDocIdentAseg VARCHAR2,nNumDocIdentAseg NUMBER) RETURN VARCHAR2;
END OC_TARJETAS_PREPAGO_ACTIV;
/

--
-- OC_TARJETAS_PREPAGO_ACTIV  (Package Body) 
--
--  Dependencies: 
--   OC_TARJETAS_PREPAGO_ACTIV (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_TARJETAS_PREPAGO_ACTIV IS

FUNCTION POLIZA_TARJETA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN VARCHAR2 IS
cExiste       VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM TARJETAS_PREPAGO_ACTIV
       WHERE CodCia     = nCodCia
           AND CodEmpresa = nCodEmpresa
            AND IdPoliza   = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END POLIZA_TARJETA;
  PROCEDURE INSERTA(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                 cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,cTipoDocIdentAseg VARCHAR2,nNumDocIdentAseg NUMBER) IS
  cNombre            PERSONA_NATURAL_JURIDICA.Nombre%TYPE;
  cApellido_Paterno  PERSONA_NATURAL_JURIDICA.Apellido_Paterno%TYPE;
  cApellido_Materno  PERSONA_NATURAL_JURIDICA.Apellido_Materno%TYPE;
  dFecNacimiento     PERSONA_NATURAL_JURIDICA.FecNacimiento%TYPE;
  cSexo              PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
  cDirecRes          PERSONA_NATURAL_JURIDICA.DirecRes%TYPE;
  cCodPosRes         PERSONA_NATURAL_JURIDICA.CodPosRes%TYPE;
  cCodPaisRes        PERSONA_NATURAL_JURIDICA.CodPaisRes%TYPE;
  cCodEstado         PERSONA_NATURAL_JURIDICA.CodProvRes%TYPE;
  cCodCiudad         PERSONA_NATURAL_JURIDICA.CodDistRes%TYPE;
  cCodMunicipio      PERSONA_NATURAL_JURIDICA.CodCorrRes%TYPE;
  cCodColRes         PERSONA_NATURAL_JURIDICA.CodColRes%TYPE;
  cTelRes            PERSONA_NATURAL_JURIDICA.TelRes%TYPE;
  cEmail             PERSONA_NATURAL_JURIDICA.Email%TYPE;
  BEGIN
    BEGIN
      SELECT Nombre,Apellido_Paterno, Apellido_Materno, FecNacimiento, Sexo, DirecRes,
             CodPosRes, CodPaisRes, CodProvRes CodEstado,CodDistRes CodCiudad,CodCorrRes  CodMunicipio,
             CodColRes, TelRes, Email
        INTO cNombre,cApellido_Paterno, cApellido_Materno, dFecNacimiento, cSexo, cDirecRes,
             cCodPosRes, cCodPaisRes,  cCodEstado, cCodCiudad,   cCodMunicipio,
             cCodColRes, cTelRes, cEmail
        FROM PERSONA_NATURAL_JURIDICA
       WHERE Tipo_Doc_Identificacion = cTipoDocIdentAseg
         AND Num_Doc_Identificacion  = nNumDocIdentAseg ;
    END;
    IF cCodPosRes IS NOT NULL THEN
    BEGIN
       SELECT  CodPais, CodEstado, CodCiudad, CodMunicipio
         INTO cCodPaisRes,  cCodEstado, cCodCiudad,   cCodMunicipio
         FROM APARTADO_POSTAL
        WHERE Codigo_Postal = cCodPosRes
       ORDER BY Codigo_Postal;
           EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20225,'No Existe  Apartado Postal:'||cCodPosRes);
    END;
       UPDATE PERSONA_NATURAL_JURIDICA
          SET CodPaisRes = cCodPaisRes,
              CodProvRes = cCodEstado,
              CodDistRes = cCodCiudad,
              CodCorrRes = cCodMunicipio
       WHERE Tipo_Doc_Identificacion = cTipoDocIdentAseg
         AND Num_Doc_Identificacion  = nNumDocIdentAseg ;
    END IF;
    BEGIN
       INSERT INTO TARJETAS_PREPAGO_ACTIV(CodCia, CodEmpresa, IdTipoSeg, PlanCob, TipoTarjeta, NumTarjeta, TipoDocIdentAseg, NumDocIdentAseg,
                                          NombresAseg,ApePaternoAseg,ApeMaternoAseg,FecNacimiento,SexoAseg,DirecAseg,
                                          CodPostalAseg,CodPaisAseg,CodEstadoAseg,CodciudadAseg,CodMunicipAseg,CodColoniaAseg,
                                          TelefonoAseg, EmailAseg)
                                VALUES   (nCodCia,nCodEmpresa,cIdTipoSeg,cPlanCob,cTipoTarjeta,nNumTarjeta,cTipoDocIdentAseg,nNumDocIdentAseg,
                                          cNombre,cApellido_Paterno, cApellido_Materno, dFecNacimiento, cSexo, cDirecRes,
                                          cCodPosRes, cCodPaisRes,  cCodEstado, cCodCiudad,   cCodMunicipio,
                                          cCodColRes, cTelRes, cEmail);
    END;
  END INSERTA;
  FUNCTION EXISTE (nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2,
                                 cPlanCob VARCHAR2, cTipoTarjeta VARCHAR2, nNumTarjeta NUMBER,cTipoDocIdentAseg VARCHAR2,nNumDocIdentAseg NUMBER) RETURN VARCHAR2 IS
  cExiste       VARCHAR2(1);
  BEGIN
     BEGIN
        SELECT 'S'
          INTO cExiste
          FROM TARJETAS_PREPAGO_ACTIV
         WHERE CodCia           = nCodCia
           AND CodEmpresa       = nCodEmpresa
           AND IdTipoSeg        = cIdTipoSeg
           AND PlanCob          = cPlanCob
           AND TipoTarjeta      = cTipoTarjeta
           AND NumTarjeta       = nNumTarjeta
           AND TipoDocIdentAseg = cTipoDocIdentAseg
           AND NumDocIdentAseg  = nNumDocIdentAseg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
   END ;
END OC_TARJETAS_PREPAGO_ACTIV;
/

--
-- OC_TARJETAS_PREPAGO_ACTIV  (Synonym) 
--
--  Dependencies: 
--   OC_TARJETAS_PREPAGO_ACTIV (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_TARJETAS_PREPAGO_ACTIV FOR SICAS_OC.OC_TARJETAS_PREPAGO_ACTIV
/


GRANT EXECUTE ON SICAS_OC.OC_TARJETAS_PREPAGO_ACTIV TO PUBLIC
/

--
-- GT_EAD_CONTROL_ASEGURADOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   EAD_CONTROL_ASEGURADOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_EAD_CONTROL_ASEGURADOS AS
   FUNCTION NUMERO_DECLARACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER;
   FUNCTION EXISTE_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, nIdEndoso NUMBER) RETURN VARCHAR2;
   PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, nNumDeclaracion NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, nIdEndoso NUMBER,
                      dFecNacimiento DATE, nEdad NUMBER, cNutraCertificado VARCHAR2, dFecIniVig DATE, dFecFinVig DATE, nMtoSumaAsegLocal NUMBER, 
                      nMtoSumaAsegMoneda NUMBER, nMtoPrimaLocal NUMBER, nMtoPrimaMoneda NUMBER, cStsDeclaracion VARCHAR2);
   FUNCTION EXISTE_HISTORICO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN VARCHAR2;
   FUNCTION EXISTE_ENDOSO_INICIAL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN VARCHAR2;   
   FUNCTION EXISTE_ASEGURADO_HIST(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, nIdEndoso NUMBER) RETURN VARCHAR2;                
END GT_EAD_CONTROL_ASEGURADOS;
/

--
-- GT_EAD_CONTROL_ASEGURADOS  (Package Body) 
--
--  Dependencies: 
--   GT_EAD_CONTROL_ASEGURADOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_EAD_CONTROL_ASEGURADOS AS
FUNCTION NUMERO_DECLARACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER IS
nNumDeclaracion EAD_CONTROL_ASEGURADOS.NumDeclaracion%TYPE;
BEGIN
   SELECT NVL(MAX(NumDeclaracion),0) + 1
     INTO nNumDeclaracion
     FROM EAD_CONTROL_ASEGURADOS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdPoliza   = nIdPoliza
      AND IDetPol    = nIDetPol;
   RETURN nNumDeclaracion;
END NUMERO_DECLARACION;

FUNCTION EXISTE_ASEGURADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, nIdEndoso NUMBER) RETURN VARCHAR2 IS
cExiste VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM EAD_CONTROL_ASEGURADOS
       WHERE CodCia        = nCodCia 
         AND CodEmpresa    = nCodEmpresa 
         AND IdPoliza      = nIdPoliza 
         AND IDetPol       = nIDetPol 
         AND CodAsegurado  = nCodAsegurado
         AND IdEndoso      = nIdEndoso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
          cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
          cExiste := 'S';
   END;
   RETURN cExiste;
END EXISTE_ASEGURADO;
   
PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, nNumDeclaracion NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, nIdEndoso NUMBER,
                   dFecNacimiento DATE, nEdad NUMBER, cNutraCertificado VARCHAR2, dFecIniVig DATE, dFecFinVig DATE, nMtoSumaAsegLocal NUMBER, 
                   nMtoSumaAsegMoneda NUMBER, nMtoPrimaLocal NUMBER, nMtoPrimaMoneda NUMBER, cStsDeclaracion VARCHAR2) IS
BEGIN
   INSERT INTO EAD_CONTROL_ASEGURADOS (CodCia, CodEmpresa, NumDeclaracion, IdPoliza, IDetPol, CodAsegurado, IdEndoso,
                                       FecNacimiento, Edad, NutraCertificado, FecIniVig, FecFinVig, 
                                       MtoSumaAsegLocal, MtoSumaAsegMoneda, MtoPrimaLocal, MtoPrimaMoneda, 
                                       StsDeclaracion, FechaEstatus)
                               VALUES (nCodCia, nCodEmpresa, nNumDeclaracion, nIdPoliza, nIDetPol, nCodAsegurado, nIdEndoso,
                                       dFecNacimiento, nEdad, cNutraCertificado, dFecIniVig, dFecFinVig, 
                                       nMtoSumaAsegLocal, nMtoSumaAsegMoneda, nMtoPrimaLocal, nMtoPrimaMoneda, 
                                       NVL(cStsDeclaracion,'ACTIVA'), TRUNC(SYSDATE));
END INSERTAR;

FUNCTION EXISTE_HISTORICO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM EAD_CONTROL_ASEGURADOS
       WHERE CodCia        = nCodCia 
         AND CodEmpresa    = nCodEmpresa 
         AND IdPoliza      = nIdPoliza 
         AND IDetPol       = nIDetPol;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN cExiste;
END EXISTE_HISTORICO;

FUNCTION EXISTE_ENDOSO_INICIAL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM EAD_CONTROL_ASEGURADOS
       WHERE CodCia        = nCodCia 
         AND CodEmpresa    = nCodEmpresa 
         AND IdPoliza      = nIdPoliza 
         AND IDetPol       = nIDetPol
         AND IdEndoso      = 0;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN cExiste;
END EXISTE_ENDOSO_INICIAL;

FUNCTION EXISTE_ASEGURADO_HIST(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, nIdEndoso NUMBER) RETURN VARCHAR2 IS
cExiste VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM EAD_CONTROL_ASEGURADOS
       WHERE CodCia        = nCodCia 
         AND CodEmpresa    = nCodEmpresa 
         AND IdPoliza      = nIdPoliza 
         AND IDetPol       = nIDetPol 
         AND CodAsegurado  = nCodAsegurado
         AND IdEndoso     != nIdEndoso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
          cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
          cExiste := 'S';
   END;
   RETURN cExiste;
END EXISTE_ASEGURADO_HIST;

END GT_EAD_CONTROL_ASEGURADOS;
/

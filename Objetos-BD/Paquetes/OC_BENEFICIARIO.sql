CREATE OR REPLACE PACKAGE SICAS_OC.OC_BENEFICIARIO IS

  PROCEDURE INSERTA_BENEFICIARIO(nIdPoliza  NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER,
                                 nBenef NUMBER, cNombre VARCHAR2, nPorcePart NUMBER, 
                                 cCodParent VARCHAR2, cSexo VARCHAR2, dFecNac DATE,
                                 cIndIrrevocable VARCHAR2);

  PROCEDURE ACTIVAR(nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);

  PROCEDURE REVERTIR_ACTIVACION(nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);

  PROCEDURE ANULAR(nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);

  PROCEDURE REHABILITAR(nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);

  PROCEDURE COPIAR(nIdPolizaOrig NUMBER, nIDetPolOrig NUMBER, nCod_AseguradoOrig NUMBER,
                   nIdPolizaDest NUMBER, nIDetPolDest NUMBER, nCod_AseguradoDest NUMBER);

  FUNCTION NOMBRE_BENEFICIARIO(nIdPoliza  NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER,
                               nBenef NUMBER) RETURN VARCHAR2;

  FUNCTION PORCENTAJE_BENEFICIARIO(nIdPoliza  NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER,
                                   nBenef NUMBER) RETURN NUMBER;

  FUNCTION TIENE_BENEFICIARIOS(nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) RETURN VARCHAR2;
  
  PROCEDURE COPIAR_REN(nIdPolizaOrig NUMBER, nIDetPolOrig NUMBER, nCod_AseguradoOrig NUMBER,
                 nIdPolizaDest NUMBER, nIDetPolDest NUMBER, nCod_AseguradoDest NUMBER);

END OC_BENEFICIARIO;
/
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_BENEFICIARIO IS

PROCEDURE INSERTA_BENEFICIARIO(nIdPoliza  NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER,
                               nBenef NUMBER, cNombre VARCHAR2, nPorcePart NUMBER, 
                               cCodParent VARCHAR2, cSexo VARCHAR2, dFecNac DATE,
                               cIndIrrevocable VARCHAR2) IS
BEGIN
   INSERT INTO BENEFICIARIO
          (IdPoliza, IDetPol, Cod_Asegurado, Benef, Nombre, PorcePart, CodParent, Estado,
           Sexo, FecEstado, FecAlta, FecBaja, MotBaja, Obervaciones, FecNac,
           IndIrrevocable)
   VALUES (nIdPoliza, nIDetPol, nCod_Asegurado, nBenef, cNombre, nPorcePart, cCodParent, 'SOLICI',
           cSexo, TRUNC(SYSDATE), TRUNC(SYSDATE), NULL, NULL, NULL, dFecNac,
           cIndIrrevocable);
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20225,'YA Existe Beneficiario No. ' || nBenef || ' en la Póliza No. ' || nIdPoliza || 
                              ' y Certificado/Subgrupo No. ' || nIDetPol || ' para el Asegurado No. ' || nCod_Asegurado);
END INSERTA_BENEFICIARIO;

PROCEDURE ACTIVAR(nIdPoliza  NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
BEGIN
   UPDATE BENEFICIARIO
      SET Estado = 'ACTIVO'
    WHERE IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado
      AND Estado        = 'SOLICI';
END ACTIVAR;

PROCEDURE REVERTIR_ACTIVACION(nIdPoliza  NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
BEGIN
   UPDATE BENEFICIARIO
      SET Estado = 'SOLICI'
    WHERE IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado
      AND Estado        = 'ACTIVO';
END REVERTIR_ACTIVACION;

PROCEDURE ANULAR(nIdPoliza  NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
BEGIN
   UPDATE BENEFICIARIO
      SET Estado = 'ANULAD'
    WHERE IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado
      AND Estado        = 'ACTIVO';
END ANULAR;

PROCEDURE REHABILITAR(nIdPoliza  NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
BEGIN
   UPDATE BENEFICIARIO
      SET Estado = 'ACTIVO'
    WHERE IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado
      AND Estado        = 'ANULAD';
END REHABILITAR;

PROCEDURE COPIAR(nIdPolizaOrig NUMBER, nIDetPolOrig NUMBER, nCod_AseguradoOrig NUMBER,
                 nIdPolizaDest NUMBER, nIDetPolDest NUMBER, nCod_AseguradoDest NUMBER) IS
CURSOR BENEF_Q IS
   SELECT IdPoliza, IDetPol, Cod_Asegurado, Benef, Nombre, PorcePart, CodParent, Estado,
          Sexo, FecEstado, FecAlta, FecBaja, MotBaja, Obervaciones, FecNac,
          IndIrrevocable
     FROM BENEFICIARIO
    WHERE IdPoliza      = nIdPolizaOrig
      AND IDetPol       = nIDetPolOrig
      AND Cod_Asegurado = nCod_AseguradoOrig;
BEGIN
   FOR W IN BENEF_Q LOOP
      OC_BENEFICIARIO.INSERTA_BENEFICIARIO(nIdPolizaDest, nIDetPolDest, nCod_AseguradoDest,
                                           W.Benef, W.Nombre, W.PorcePart, W.CodParent,
                                           W.Sexo, W.FecNac, W.IndIrrevocable);
   END LOOP;
END COPIAR;

FUNCTION NOMBRE_BENEFICIARIO(nIdPoliza  NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER,
                             nBenef NUMBER) RETURN VARCHAR2 IS
cNomBenef        VARCHAR2(300);
BEGIN
   BEGIN
      SELECT Nombre
        INTO cNomBenef
        FROM BENEFICIARIO
       WHERE IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND Cod_Asegurado = nCod_Asegurado
         AND Benef         = nBenef;
      RETURN(cNomBenef);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Beneficiario No. ' || nBenef || ' en la Póliza No. ' || nIdPoliza || 
                                 ' y Certificado/Subgrupo No. ' || nIDetPol || ' para el Asegurado No. ' || nCod_Asegurado);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Beneficiarios No. ' || nBenef || ' en la Póliza No. ' || nIdPoliza || 
                                 ' y Certificado/Subgrupo No. ' || nIDetPol || ' para el Asegurado No. ' || nCod_Asegurado);
   END;
END NOMBRE_BENEFICIARIO;

FUNCTION PORCENTAJE_BENEFICIARIO(nIdPoliza  NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER,
                                 nBenef NUMBER) RETURN NUMBER IS
nPorcePart            BENEFICIARIO.PorcePart%TYPE;
BEGIN
   BEGIN
      SELECT PorcePart
        INTO nPorcePart
        FROM BENEFICIARIO
       WHERE IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND Cod_Asegurado = nCod_Asegurado
         AND Benef         = nBenef;
      RETURN(nPorcePart);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Beneficiario No. ' || nBenef || ' en la Póliza No. ' || nIdPoliza || 
                                 ' y Certificado/Subgrupo No. ' || nIDetPol || ' para el Asegurado No. ' || nCod_Asegurado);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Beneficiarios No. ' || nBenef || ' en la Póliza No. ' || nIdPoliza || 
                                 ' y Certificado/Subgrupo No. ' || nIDetPol || ' para el Asegurado No. ' || nCod_Asegurado);
   END;
END PORCENTAJE_BENEFICIARIO;

FUNCTION TIENE_BENEFICIARIOS(nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) RETURN VARCHAR2 IS
cTieneBenef            VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cTieneBenef
        FROM BENEFICIARIO
       WHERE IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND Cod_Asegurado = nCod_Asegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTieneBenef := 'N';
      WHEN TOO_MANY_ROWS THEN
         cTieneBenef := 'S';
   END;
   RETURN(cTieneBenef);
END TIENE_BENEFICIARIOS;

PROCEDURE COPIAR_REN(nIdPolizaOrig NUMBER, nIDetPolOrig NUMBER, nCod_AseguradoOrig NUMBER,
                 nIdPolizaDest NUMBER, nIDetPolDest NUMBER, nCod_AseguradoDest NUMBER) IS
CURSOR BENEF_Q IS
   SELECT IdPoliza, IDetPol, Cod_Asegurado, Benef, Nombre, PorcePart, CodParent, Estado,
          Sexo, FecEstado, FecAlta, FecBaja, MotBaja, Obervaciones, FecNac,
          IndIrrevocable
     FROM BENEFICIARIO
    WHERE IdPoliza      = nIdPolizaOrig
      AND IDetPol       = nIDetPolOrig
      AND Cod_Asegurado = nCod_AseguradoOrig;
BEGIN
   FOR W IN BENEF_Q LOOP
      OC_BENEFICIARIO.INSERTA_BENEFICIARIO(nIdPolizaDest, nIDetPolDest, nCod_AseguradoDest,
                                           W.Benef, W.Nombre, W.PorcePart, W.CodParent,
                                           W.Sexo, W.FecNac, W.IndIrrevocable);
   END LOOP;
END COPIAR_REN;

END OC_BENEFICIARIO;
/

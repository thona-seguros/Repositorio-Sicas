--
-- GT_REA_TIPOS_CONTRATOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   REA_TIPOS_CONTRATOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_REA_TIPOS_CONTRATOS IS

  PROCEDURE ACTIVAR_CONTRATO(nCodCia NUMBER, cCodContrato VARCHAR2);
  PROCEDURE SUSPENDER_CONTRATO(nCodCia NUMBER, cCodContrato VARCHAR2);
  FUNCTION NOMBRE_CONTRATO(nCodCia NUMBER, cCodContrato VARCHAR2) RETURN VARCHAR2;
  FUNCTION TIPO_CONTRATO(nCodCia NUMBER, cCodContrato VARCHAR2) RETURN VARCHAR2;
  FUNCTION CLASE_CONTRATO(nCodCia NUMBER, cCodContrato VARCHAR2) RETURN VARCHAR2;
  FUNCTION CODIGO_OFICIAL(nCodCia NUMBER, cCodContrato VARCHAR2) RETURN VARCHAR2;
  FUNCTION CONTRATO_RETENCION(nCodCia NUMBER, cCodContrato VARCHAR2) RETURN VARCHAR2;
  FUNCTION CONTRATO_FACULTATIVO(nCodCia NUMBER, cCodContrato VARCHAR2) RETURN VARCHAR2;
END GT_REA_TIPOS_CONTRATOS;
/

--
-- GT_REA_TIPOS_CONTRATOS  (Package Body) 
--
--  Dependencies: 
--   GT_REA_TIPOS_CONTRATOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_REA_TIPOS_CONTRATOS IS

PROCEDURE ACTIVAR_CONTRATO(nCodCia NUMBER, cCodContrato VARCHAR2) IS
BEGIN
   UPDATE REA_TIPOS_CONTRATOS
      SET StsContrato = 'ACTIVO',
          FecStatus   = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodContrato = cCodContrato;
END ACTIVAR_CONTRATO;

PROCEDURE SUSPENDER_CONTRATO(nCodCia NUMBER, cCodContrato VARCHAR2) IS
BEGIN
   UPDATE REA_TIPOS_CONTRATOS
      SET StsContrato = 'SUSPEN',
          FecStatus   = TRUNC(SYSDATE)
    WHERE CodCia      = nCodCia
      AND CodContrato = cCodContrato;
END SUSPENDER_CONTRATO;

FUNCTION NOMBRE_CONTRATO(nCodCia NUMBER, cCodContrato VARCHAR2) RETURN VARCHAR2 IS
cNomContrato       REA_TIPOS_CONTRATOS.NomContrato%TYPE;
BEGIN
   BEGIN
      SELECT NomContrato
        INTO cNomContrato
        FROM REA_TIPOS_CONTRATOS
       WHERE CodCia      = nCodCia
         AND CodContrato = cCodContrato;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNomContrato := 'Contrato - NO EXISTE';
   END;
   RETURN(cNomContrato);
END NOMBRE_CONTRATO;

FUNCTION TIPO_CONTRATO(nCodCia NUMBER, cCodContrato VARCHAR2) RETURN VARCHAR2 IS
cTipoContrato       REA_TIPOS_CONTRATOS.TipoContrato%TYPE;
BEGIN
   BEGIN
      SELECT TipoContrato
        INTO cTipoContrato
        FROM REA_TIPOS_CONTRATOS
       WHERE CodCia      = nCodCia
         AND CodContrato = cCodContrato;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoContrato := NULL;
   END;
   RETURN(cTipoContrato);
END TIPO_CONTRATO;

FUNCTION CLASE_CONTRATO(nCodCia NUMBER, cCodContrato VARCHAR2) RETURN VARCHAR2 IS
cClaseContrato       REA_TIPOS_CONTRATOS.ClaseContrato%TYPE;
BEGIN
   BEGIN
      SELECT ClaseContrato
        INTO cClaseContrato
        FROM REA_TIPOS_CONTRATOS
       WHERE CodCia      = nCodCia
         AND CodContrato = cCodContrato;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cClaseContrato := NULL;
   END;
   RETURN(cClaseContrato);
END CLASE_CONTRATO;

FUNCTION CODIGO_OFICIAL(nCodCia NUMBER, cCodContrato VARCHAR2) RETURN VARCHAR2 IS
cCodOficial       REA_TIPOS_CONTRATOS.CodOficial%TYPE;
BEGIN
   BEGIN
      SELECT CodOficial
        INTO cCodOficial
        FROM REA_TIPOS_CONTRATOS
       WHERE CodCia      = nCodCia
         AND CodContrato = cCodContrato;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodOficial := NULL;
   END;
   RETURN(cCodOficial);
END CODIGO_OFICIAL;

FUNCTION CONTRATO_RETENCION(nCodCia NUMBER, cCodContrato VARCHAR2) RETURN VARCHAR2 IS
cIndRetencion       REA_TIPOS_CONTRATOS.IndRetencion%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndRetencion,'N')
        INTO cIndRetencion
        FROM REA_TIPOS_CONTRATOS
       WHERE CodCia      = nCodCia
         AND CodContrato = cCodContrato;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndRetencion := 'N';
   END;
   RETURN(cIndRetencion);
END CONTRATO_RETENCION;

FUNCTION CONTRATO_FACULTATIVO(nCodCia NUMBER, cCodContrato VARCHAR2) RETURN VARCHAR2 IS
cIndFacultativo       REA_TIPOS_CONTRATOS.IndFacultativo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndFacultativo,'N')
        INTO cIndFacultativo
        FROM REA_TIPOS_CONTRATOS
       WHERE CodCia      = nCodCia
         AND CodContrato = cCodContrato;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndFacultativo := 'N';
   END;
   RETURN(cIndFacultativo);
END CONTRATO_FACULTATIVO;

END GT_REA_TIPOS_CONTRATOS;
/

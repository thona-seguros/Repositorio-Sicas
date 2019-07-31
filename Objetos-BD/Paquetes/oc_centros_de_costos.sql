--
-- OC_CENTROS_DE_COSTOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   CENTROS_DE_COSTOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CENTROS_DE_COSTOS IS

  FUNCTION DESCRIPCION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCentroCosto VARCHAR2) RETURN VARCHAR2;
  PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCentroCosto VARCHAR2);
  PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCentroCosto VARCHAR2);
  FUNCTION TIPO_CENTRO_COSTO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCentroCosto VARCHAR2) RETURN VARCHAR2;

END OC_CENTROS_DE_COSTOS;
/

--
-- OC_CENTROS_DE_COSTOS  (Package Body) 
--
--  Dependencies: 
--   OC_CENTROS_DE_COSTOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CENTROS_DE_COSTOS IS

FUNCTION DESCRIPCION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCentroCosto  VARCHAR2) RETURN VARCHAR2 IS
cDescCentroCosto   CENTROS_DE_COSTOS.DescCentroCosto%TYPE;
BEGIN
   BEGIN
      SELECT DescCentroCosto
        INTO cDescCentroCosto
        FROM CENTROS_DE_COSTOS
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND CodCentroCosto = cCodCentroCosto;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescCentroCosto := 'CENTRO DE COSTO NO EXISTE';
   END;
   RETURN(cDescCentroCosto);
END DESCRIPCION;

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCentroCosto  VARCHAR2) IS
BEGIN
   UPDATE CENTROS_DE_COSTOS
      SET StsCentroCosto  = 'ACTIVO',
          FecSts          = TRUNC(SYSDATE),
          CodUsuario      = USER
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND CodCentroCosto = cCodCentroCosto;
END ACTIVAR;

PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCentroCosto  VARCHAR2) IS
BEGIN
   UPDATE CENTROS_DE_COSTOS
      SET StsCentroCosto  = 'SUSPEN',
          FecSts          = TRUNC(SYSDATE),
          CodUsuario      = USER
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND CodCentroCosto = cCodCentroCosto;
END SUSPENDER;

FUNCTION TIPO_CENTRO_COSTO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCentroCosto  VARCHAR2) RETURN VARCHAR2 IS
cTipoCentroCosto   CENTROS_DE_COSTOS.TipoCentroCosto%TYPE;
BEGIN
   BEGIN
      SELECT TipoCentroCosto
        INTO cTipoCentroCosto
        FROM CENTROS_DE_COSTOS
       WHERE CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND CodCentroCosto = cCodCentroCosto;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoCentroCosto := NULL;
   END;
   RETURN(cTipoCentroCosto);
END TIPO_CENTRO_COSTO;

END OC_CENTROS_DE_COSTOS;
/

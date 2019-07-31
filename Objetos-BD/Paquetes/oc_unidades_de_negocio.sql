--
-- OC_UNIDADES_DE_NEGOCIO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   UNIDADES_DE_NEGOCIO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_UNIDADES_DE_NEGOCIO IS

  FUNCTION DESCRIPCION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodUnidadNegocio VARCHAR2) RETURN VARCHAR2;
  PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodUnidadNegocio VARCHAR2);
  PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, cCodUnidadNegocio VARCHAR2);

END OC_UNIDADES_DE_NEGOCIO;
/

--
-- OC_UNIDADES_DE_NEGOCIO  (Package Body) 
--
--  Dependencies: 
--   OC_UNIDADES_DE_NEGOCIO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_UNIDADES_DE_NEGOCIO IS

FUNCTION DESCRIPCION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodUnidadNegocio VARCHAR2) RETURN VARCHAR2 IS
cDescUnidadNegocio   UNIDADES_DE_NEGOCIO.DescUnidadNegocio%TYPE;
BEGIN
   BEGIN
      SELECT DescUnidadNegocio
        INTO cDescUnidadNegocio
        FROM UNIDADES_DE_NEGOCIO
       WHERE CodCia           = nCodCia
         AND CodEmpresa       = nCodEmpresa
         AND CodUnidadNegocio = cCodUnidadNegocio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescUnidadNegocio := 'UNIDAD DE NEGOCIO NO EXISTE';
   END;
   RETURN(cDescUnidadNegocio);
END DESCRIPCION;

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodUnidadNegocio VARCHAR2) IS
BEGIN
   UPDATE UNIDADES_DE_NEGOCIO
      SET StsUnidadNegocio  = 'ACTIVO',
          FecSts            = TRUNC(SYSDATE),
          CodUsuario        = USER
    WHERE CodCia           = nCodCia
      AND CodEmpresa       = nCodEmpresa
      AND CodUnidadNegocio = cCodUnidadNegocio;
END ACTIVAR;

PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, cCodUnidadNegocio VARCHAR2) IS
BEGIN
   UPDATE UNIDADES_DE_NEGOCIO
      SET StsUnidadNegocio  = 'SUSPEN',
          FecSts            = TRUNC(SYSDATE),
          CodUsuario        = USER
    WHERE CodCia           = nCodCia
      AND CodEmpresa       = nCodEmpresa
      AND CodUnidadNegocio = cCodUnidadNegocio;
END SUSPENDER;

END OC_UNIDADES_DE_NEGOCIO;
/

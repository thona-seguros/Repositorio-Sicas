--
-- OC_POLIZAS_RESUMEN_ENDOSO_CLA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   POLIZAS_RESUMEN_ENDOSO_CLA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_POLIZAS_RESUMEN_ENDOSO_CLA IS

  PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                    nIDetPol NUMBER, nCantAsegModelo NUMBER, nCantAsegListado NUMBER,
                    nCantAsegIncluidos NUMBER, nPrimaAsegIncluidos NUMBER,
                    nCantAsegExcluidos NUMBER, nPrimaAsegExcluidos NUMBER);
  PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER);
  FUNCTION EXISTE_LISTADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER;

END OC_POLIZAS_RESUMEN_ENDOSO_CLA;
/

--
-- OC_POLIZAS_RESUMEN_ENDOSO_CLA  (Package Body) 
--
--  Dependencies: 
--   OC_POLIZAS_RESUMEN_ENDOSO_CLA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_POLIZAS_RESUMEN_ENDOSO_CLA IS


PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                   nIDetPol NUMBER, nCantAsegModelo NUMBER, nCantAsegListado NUMBER,
                   nCantAsegIncluidos NUMBER, nPrimaAsegIncluidos NUMBER,
                   nCantAsegExcluidos NUMBER, nPrimaAsegExcluidos NUMBER) IS
BEGIN
   BEGIN
      INSERT INTO POLIZAS_RESUMEN_ENDOSO_CLA
             (CodCia, CodEmpresa, IdPoliza, IDetPol, CantAsegModelo,
              CantAsegListado, CantAsegIncluidos, PrimaAsegIncluidos,
              CantAsegExcluidos, PrimaAsegExcluidos, CodUsuario, FechaCambio)
      VALUES (nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCantAsegModelo,
              nCantAsegListado, nCantAsegIncluidos, nPrimaAsegIncluidos,
              nCantAsegExcluidos, nPrimaAsegExcluidos, USER, TRUNC(SYSDATE));
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         BEGIN
             UPDATE POLIZAS_RESUMEN_ENDOSO_CLA
                SET CantAsegModelo     = nCantAsegModelo,
                    CantAsegListado    = nCantAsegListado,
                    CantAsegIncluidos  = nCantAsegIncluidos,
                    PrimaAsegIncluidos = nPrimaAsegIncluidos,
                    CantAsegExcluidos  = nCantAsegExcluidos,
                    PrimaAsegExcluidos = nPrimaAsegExcluidos,
                    CodUsuario         = USER,
                    FechaCambio        = TRUNC(SYSDATE)
              WHERE CodCia     = nCodCia
                AND CodEmpresa = nCodEmpresa
                AND IdPoliza   = nIdPoliza
                AND IDetPol    = nIDetPol;
         END;
   END;
END INSERTAR;

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) IS
BEGIN
   DELETE POLIZAS_RESUMEN_ENDOSO_CLA
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza;
END;

FUNCTION EXISTE_LISTADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER IS
nCantAsegListado    POLIZAS_RESUMEN_ENDOSO_CLA.CantAsegListado%TYPE;
BEGIN
   SELECT SUM(CantAsegListado)
     INTO nCantAsegListado
     FROM POLIZAS_RESUMEN_ENDOSO_CLA
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol;

   RETURN(nCantAsegListado);
END EXISTE_LISTADO;


END OC_POLIZAS_RESUMEN_ENDOSO_CLA;
/

--
-- OC_CLAUSULAS_TIPOS_SEGUROS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   CLAUSULAS_TIPOS_SEGUROS (Table)
--   OC_CLAUSULAS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CLAUSULAS_TIPOS_SEGUROS IS

  PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                   cIdTipoSegDest VARCHAR2);

  FUNCTION EXISTEN_OBLIGATORIAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2;

END OC_CLAUSULAS_TIPOS_SEGUROS;
/

--
-- OC_CLAUSULAS_TIPOS_SEGUROS  (Package Body) 
--
--  Dependencies: 
--   OC_CLAUSULAS_TIPOS_SEGUROS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CLAUSULAS_TIPOS_SEGUROS IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2) IS
CURSOR CLAU_Q IS
  SELECT CodClausula
    FROM CLAUSULAS_TIPOS_SEGUROS
   WHERE CodCia     = nCodCia
     AND CodEmpresa = nCodEmpresa
     AND IdTipoSeg  = cIdTipoSegOrig;
BEGIN
   FOR X IN CLAU_Q LOOP
      INSERT INTO CLAUSULAS_TIPOS_SEGUROS
             (CodCia, CodEmpresa, IdTipoSeg, CodClausula)
      VALUES (nCodCia, nCodEmpresa, cIdTipoSegDest, X.CodClausula);

   END LOOP;
END COPIAR;

FUNCTION EXISTEN_OBLIGATORIAS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM CLAUSULAS_TIPOS_SEGUROS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND IdTipoSeg  = cIdTipoSeg
         AND OC_CLAUSULAS.OBLIGATORIA(CodCia, CodEmpresa, CodClausula) = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTEN_OBLIGATORIAS;

END OC_CLAUSULAS_TIPOS_SEGUROS;
/

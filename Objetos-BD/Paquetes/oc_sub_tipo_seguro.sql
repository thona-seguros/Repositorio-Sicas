--
-- OC_SUB_TIPO_SEGURO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   SUB_TIPO_SEGURO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_SUB_TIPO_SEGURO IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2);

END OC_SUB_TIPO_SEGURO;
/

--
-- OC_SUB_TIPO_SEGURO  (Package Body) 
--
--  Dependencies: 
--   OC_SUB_TIPO_SEGURO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_SUB_TIPO_SEGURO IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2) IS
CURSOR SUB_Q IS
   SELECT Cod_Sub_Tipo, Descripcion
     FROM SUB_TIPO_SEGURO
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa      
      AND IdTipoSeg  = cIdTipoSegOrig;
BEGIN
   FOR X IN SUB_Q  LOOP
      INSERT INTO SUB_TIPO_SEGURO
             (IdTipoSeg, CodCia, CodEmpresa, Cod_Sub_Tipo, Descripcion)
      VALUES (cIdTipoSegDest, nCodCia, nCodEmpresa, X.Cod_Sub_Tipo, X.Descripcion);
   END LOOP;
END COPIAR;

END OC_SUB_TIPO_SEGURO;
/

--
-- OC_CONF_DATPART_EMISION  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   CONF_DATPART_EMISION (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONF_DATPART_EMISION IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2);

END OC_CONF_DATPART_EMISION;
/

--
-- OC_CONF_DATPART_EMISION  (Package Body) 
--
--  Dependencies: 
--   OC_CONF_DATPART_EMISION (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CONF_DATPART_EMISION IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2) IS
CURSOR EMI_Q IS
   SELECT IdCampo, TipoDato, Longitud, Decimales, IndOblig, DescCampo,
          CatalogVal, IndUnico, IndImpresion, OrdenImpresion, DatCampoUnico
     FROM CONF_DATPART_EMISION
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa      
      AND IdTipoSeg  = cIdTipoSegOrig;
BEGIN
   FOR X IN EMI_Q  LOOP
      INSERT INTO CONF_DATPART_EMISION
             (IdTipoSeg, CodCia, CodEmpresa, IdCampo, TipoDato, Longitud, 
                                  Decimales, IndOblig, DescCampo, CatalogVal, IndUnico, 
                                  IndImpresion, OrdenImpresion, DatCampoUnico)
      VALUES (cIdTipoSegDest, nCodCia, nCodEmpresa, X.IdCampo, X.TipoDato, X.Longitud, 
                                  X.Decimales, X.IndOblig, X.DescCampo, X.CatalogVal, X.IndUnico, 
                                  X.IndImpresion, X.OrdenImpresion, X.DatCampoUnico);
   END LOOP;
END COPIAR;

END OC_CONF_DATPART_EMISION;
/

--
-- OC_CONF_DATPART_EMISION  (Synonym) 
--
--  Dependencies: 
--   OC_CONF_DATPART_EMISION (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_CONF_DATPART_EMISION FOR SICAS_OC.OC_CONF_DATPART_EMISION
/


GRANT EXECUTE ON SICAS_OC.OC_CONF_DATPART_EMISION TO PUBLIC
/

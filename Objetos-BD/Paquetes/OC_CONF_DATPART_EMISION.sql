CREATE OR REPLACE PACKAGE OC_CONF_DATPART_EMISION IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2);

END OC_CONF_DATPART_EMISION;
 
 
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_CONF_DATPART_EMISION IS

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
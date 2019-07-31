--
-- OC_CONF_DATPART_SINIESTROS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   CONF_DATPART_SINIESTROS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CONF_DATPART_SINIESTROS IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2);

END OC_CONF_DATPART_SINIESTROS;
/

--
-- OC_CONF_DATPART_SINIESTROS  (Package Body) 
--
--  Dependencies: 
--   OC_CONF_DATPART_SINIESTROS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CONF_DATPART_SINIESTROS IS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSegOrig VARCHAR2,
                 cIdTipoSegDest VARCHAR2) IS
CURSOR SIN_Q IS
   SELECT IdCampo, TipoDato, Longitud, Decimales, IndOblig, DescCampo,
          CatalogVal, IndUnico, DatCampoUnico
     FROM CONF_DATPART_SINIESTROS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa      
      AND IdTipoSeg  = cIdTipoSegOrig;
BEGIN
   FOR X IN SIN_Q  LOOP
      INSERT INTO CONF_DATPART_SINIESTROS
             (IdTipoSeg, CodCia, CodEmpresa, IdCampo, TipoDato, Longitud, 
                                  Decimales, IndOblig, DescCampo, CatalogVal, IndUnico, 
                                  DatCampoUnico)
      VALUES (cIdTipoSegDest, nCodCia, nCodEmpresa, X.IdCampo, X.TipoDato, X.Longitud, 
                                  X.Decimales, X.IndOblig, X.DescCampo, X.CatalogVal, X.IndUnico, 
                                  X.DatCampoUnico);
   END LOOP;
END COPIAR;

END OC_CONF_DATPART_SINIESTROS;
/

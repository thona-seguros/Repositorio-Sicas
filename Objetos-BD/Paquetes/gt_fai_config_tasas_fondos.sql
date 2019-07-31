--
-- GT_FAI_CONFIG_TASAS_FONDOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   FAI_CONFIG_TASAS_FONDOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_CONFIG_TASAS_FONDOS AS

PROCEDURE  COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, 
                   cTipoFondoDest VARCHAR2,  cTipoInteresOrig VARCHAR2, cTipoInteresDest VARCHAR2);

END GT_FAI_CONFIG_TASAS_FONDOS;
/

--
-- GT_FAI_CONFIG_TASAS_FONDOS  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_CONFIG_TASAS_FONDOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_CONFIG_TASAS_FONDOS AS 

PROCEDURE  COPIAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, 
                   cTipoFondoDest VARCHAR2, cTipoInteresOrig VARCHAR2, cTipoInteresDest VARCHAR2) IS

CURSOR  C_TASAS_FONDOS IS 
   SELECT TipoFondo, TipoInteres, FecIniConf, FecFinConf, 
          TipoConfig, FactorAjuste
     FROM FAI_CONFIG_TASAS_FONDOS
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND TipoFondo   = cTipoFondoOrig
      AND TipoInteres = cTipoInteresOrig;
BEGIN
   FOR R IN  C_TASAS_FONDOS LOOP
      INSERT INTO  FAI_CONFIG_TASAS_FONDOS
            (CodCia, CodEmpresa, TipoFondo, TipoInteres, 
             FecIniConf, FecFinConf, TipoConfig, FactorAjuste)
      VALUES(nCodCia, nCodEmpresa, cTipoFondoDest, cTipoInteresDest, 
             R.FecIniConf, R.FecFinConf, R.TipoConfig, R.FactorAjuste);
   END LOOP;
END COPIAR;

END GT_FAI_CONFIG_TASAS_FONDOS;
/

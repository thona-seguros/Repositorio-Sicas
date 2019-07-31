--
-- GT_FAI_CONF_TIPO_INCENTIVO_DET  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_CONF_TIPO_INCENTIVO_DET (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_CONF_TIPO_INCENTIVO_DET AS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodIncentivoOrig VARCHAR2, cCodIncentivoDest VARCHAR2);

FUNCTION MONTO_INCENTIVO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                         cCodIncentivo VARCHAR2, nMontoLogrado NUMBER) RETURN NUMBER;

FUNCTION CANTIDAD_INCENTIVOS(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                             cCodIncentivo VARCHAR2, nMontoLogrado NUMBER) RETURN NUMBER;

END GT_FAI_CONF_TIPO_INCENTIVO_DET;
/

--
-- GT_FAI_CONF_TIPO_INCENTIVO_DET  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_CONF_TIPO_INCENTIVO_DET (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_CONF_TIPO_INCENTIVO_DET AS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodIncentivoOrig VARCHAR2, cCodIncentivoDest VARCHAR2) IS
CURSOR INCEN_Q IS
   SELECT CodIncentivo, MetaMinima, MetaMaxima, RangoMonto, CantIncentivo
     FROM FAI_CONF_TIPO_INCENTIVO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND TipoFondo    = cTipoFondoOrig
      AND CodIncentivo = cCodIncentivoOrig;
BEGIN
   FOR X IN INCEN_Q LOOP
      BEGIN
         INSERT INTO FAI_CONF_TIPO_INCENTIVO_DET
                (CodCia, CodEmpresa, TipoFondo, CodIncentivo, 
                 MetaMinima, MetaMaxima, RangoMonto, CantIncentivo)
         VALUES (nCodCia, nCodEmpresa, cTipoFondoDest, cCodIncentivoDest, 
                 X.MetaMinima, X.MetaMaxima, X.RangoMonto, X.CantIncentivo);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20100,'Error Copiando Rangos de Incentivo para Fondo: '||cTipoFondoDest||' e Incentivo: '||cCodIncentivoDest);
      END;
   END LOOP;
END COPIAR;

FUNCTION MONTO_INCENTIVO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                         cCodIncentivo VARCHAR2, nMontoLogrado NUMBER) RETURN NUMBER IS
nRangoMonto    FAI_CONF_TIPO_INCENTIVO_DET.RangoMonto%TYPE;
BEGIN
   SELECT NVL(RangoMonto,0)
     INTO nRangoMonto
     FROM FAI_CONF_TIPO_INCENTIVO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND TipoFondo    = cTipoFondo
      AND CodIncentivo = cCodIncentivo
      AND MetaMinima  >= nMontoLogrado
      AND MetaMaxima  <= nMontoLogrado;
   RETURN(nRangoMonto);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN(0);
   WHEN OTHERS THEN
      RETURN(0);
END MONTO_INCENTIVO;

FUNCTION CANTIDAD_INCENTIVOS(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                         cCodIncentivo VARCHAR2, nMontoLogrado NUMBER) RETURN NUMBER IS
nCantIncentivo    FAI_CONF_TIPO_INCENTIVO_DET.CantIncentivo%TYPE;
BEGIN
   SELECT NVL(CantIncentivo,0)
     INTO nCantIncentivo
     FROM FAI_CONF_TIPO_INCENTIVO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND TipoFondo    = cTipoFondo
      AND CodIncentivo = cCodIncentivo
      AND MetaMinima  >= nMontoLogrado
      AND MetaMaxima  <= nMontoLogrado;
   RETURN(nCantIncentivo);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN(0);
   WHEN OTHERS THEN
      RETURN(0);
END CANTIDAD_INCENTIVOS;

END GT_FAI_CONF_TIPO_INCENTIVO_DET;
/

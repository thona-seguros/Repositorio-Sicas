--
-- GT_FAI_RANGOS_APORTE_RENDIM  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_RANGOS_APORTE_RENDIM (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_RANGOS_APORTE_RENDIM AS

FUNCTION PORCENTAJE_TASA(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoRango VARCHAR2, cCodMoneda VARCHAR2,
                         nAnioPoliza NUMBER, nMontoFondo NUMBER) RETURN NUMBER;

FUNCTION MONEDA_RANGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoRango VARCHAR2) RETURN VARCHAR2;

END GT_FAI_RANGOS_APORTE_RENDIM;
/

--
-- GT_FAI_RANGOS_APORTE_RENDIM  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_RANGOS_APORTE_RENDIM (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_RANGOS_APORTE_RENDIM AS

FUNCTION PORCENTAJE_TASA(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoRango VARCHAR2, cCodMoneda VARCHAR2,
                         nAnioPoliza NUMBER, nMontoFondo NUMBER) RETURN NUMBER IS
nPorcTasaInt     FAI_RANGOS_APORTE_RENDIM.PorcTasaInt%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcTasaInt,1)
        INTO nPorcTasaInt
        FROM FAI_RANGOS_APORTE_RENDIM
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND TipoRango       = cTipoRango
         AND CodMoneda       = cCodMoneda
         AND AnoRangoIni    >= nAnioPoliza
         AND AnoRangoFin    <= nAnioPoliza
         AND RangoIni       >= nMontoFondo
         AND RangoFin       <= nMontoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcTasaInt := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Porcentaje del Tasa de Interes para Rango: ' || cTipoRango ||
                                 ' y Moneda ' || cCodMoneda || ' Año Póliza ' || nAnioPoliza || ' y Monto ' || nMontoFondo);
   END;
   RETURN(nPorcTasaInt);
END PORCENTAJE_TASA;

FUNCTION MONEDA_RANGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoRango VARCHAR2) RETURN VARCHAR2 IS
cCodMoneda     FAI_RANGOS_APORTE_RENDIM.CodMoneda%TYPE;
BEGIN
   BEGIN
      SELECT DISTINCT CodMoneda
        INTO cCodMoneda
        FROM FAI_RANGOS_APORTE_RENDIM
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND TipoRango       = cTipoRango;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodMoneda := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Moneda para Rango: ' || cTipoRango);
   END;
   RETURN(cCodMoneda);
END MONEDA_RANGO;

END GT_FAI_RANGOS_APORTE_RENDIM;
/

--
-- GT_FAI_RANGOS_APORTE_RENDIM  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_RANGOS_APORTE_RENDIM (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_RANGOS_APORTE_RENDIM FOR SICAS_OC.GT_FAI_RANGOS_APORTE_RENDIM
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_FAI_RANGOS_APORTE_RENDIM TO PUBLIC
/

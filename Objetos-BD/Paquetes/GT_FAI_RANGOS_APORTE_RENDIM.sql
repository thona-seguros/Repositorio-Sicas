CREATE OR REPLACE PACKAGE GT_FAI_RANGOS_APORTE_RENDIM AS

FUNCTION PORCENTAJE_TASA(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoRango VARCHAR2, cCodMoneda VARCHAR2,
                         nAnioPoliza NUMBER, nMontoFondo NUMBER) RETURN NUMBER;

FUNCTION MONEDA_RANGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoRango VARCHAR2) RETURN VARCHAR2;

END GT_FAI_RANGOS_APORTE_RENDIM;
/

CREATE OR REPLACE PACKAGE BODY GT_FAI_RANGOS_APORTE_RENDIM AS

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

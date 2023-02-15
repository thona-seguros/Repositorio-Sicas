CREATE OR REPLACE PACKAGE GT_FAI_BONOS_FONDOS_RANGOS AS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodBonoOrig VARCHAR2, cCodBonoDest VARCHAR2);

FUNCTION RUTINA_CALCULO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2,
                        dFecBono DATE, nAnioBono NUMBER, nMontoFondo NUMBER) RETURN VARCHAR2;

FUNCTION PORCENTAJE_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2,
                          dFecBono DATE, nAnioBono NUMBER, nMontoFondo NUMBER) RETURN NUMBER;

FUNCTION MONTO_BONO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2,
                     dFecBono DATE, nAnioBono NUMBER, nMontoFondo NUMBER) RETURN NUMBER;

END GT_FAI_BONOS_FONDOS_RANGOS;
/

CREATE OR REPLACE PACKAGE BODY GT_FAI_BONOS_FONDOS_RANGOS AS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodBonoOrig VARCHAR2, cCodBonoDest VARCHAR2) IS 

CURSOR RANGOS_BONO_Q IS
   SELECT CodBono, FecIniBono, FecFinBono, AnoIniRango,
          AnoFinRango, RangoIni, RangoFin, PorcBono, MontoBono,
          CodRutinaCalc
     FROM FAI_BONOS_FONDOS_RANGOS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondoOrig
      AND CodBono    = cCodBonoOrig;
BEGIN
   -- Inserta Rangos del Bono
   FOR Z IN RANGOS_BONO_Q LOOP
      BEGIN
         INSERT INTO FAI_BONOS_FONDOS_RANGOS
                (CodCia, CodEmpresa, TipoFondo, CodBono, FecIniBono, FecFinBono,
                 AnoIniRango, AnoFinRango, RangoIni, RangoFin, PorcBono, MontoBono,
                 CodRutinaCalc)
         VALUES (nCodCia, nCodEmpresa, cTipoFondoDest, cCodBonoDest, Z.FecIniBono, Z.FecFinBono,
                 Z.AnoIniRango, Z.AnoFinRango, Z.RangoIni, Z.RangoFin, Z.PorcBono, Z.MontoBono,
                 Z.CodRutinaCalc);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20100,'Error Copiando Rangos de Bono para Fondo: '||cTipoFondoDest||' y Bono: '||cCodBonoDest);
      END;
   END LOOP;
END COPIAR;

FUNCTION RUTINA_CALCULO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2,
                        dFecBono DATE, nAnioBono NUMBER, nMontoFondo NUMBER) RETURN VARCHAR2 IS
cCodRutinaCalc   FAI_BONOS_FONDOS_RANGOS.CodRutinaCalc%TYPE;
BEGIN
   BEGIN
      SELECT CodRutinaCalc
        INTO cCodRutinaCalc
        FROM FAI_BONOS_FONDOS_RANGOS
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND TipoFondo       = cTipoFondo
         AND CodBono         = cCodBono
         AND AnoIniRango    >= nAnioBono
         AND AnoFinRango    <= nAnioBono
         AND FecIniBono     >= dFecBono
         AND FecFinBono     <= dFecBono
         AND RangoIni       >= nMontoFondo
         AND RangoFin       <= nMontoFOndo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodRutinaCalc := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Rutina de Cálculo del Bono por Rangos para Fondo: ' ||
                                 cTipoFondo || ' Bono ' || cCodBono);
   END;
   RETURN(cCodRutinaCalc);
END RUTINA_CALCULO;

FUNCTION PORCENTAJE_Bono(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2,
                          dFecBono DATE, nAnioBono NUMBER, nMontoFondo NUMBER) RETURN NUMBER IS
nPorcBono     FAI_BONOS_FONDOS_RANGOS.PorcBono%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcBono,0)
        INTO nPorcBono
        FROM FAI_BONOS_FONDOS_RANGOS
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND TipoFondo       = cTipoFondo
         AND CodBono         = cCodBono
         AND AnoIniRango    >= nAnioBono
         AND AnoFinRango    <= nAnioBono
         AND FecIniBono     >= dFecBono
         AND FecFinBono     <= dFecBono
         AND RangoIni       >= nMontoFondo
         AND RangoFin       <= nMontoFOndo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcBono := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Porcentaje del Bono por Rangos para Fondo: '||cTipoFondo || ' y Bono ' || cCodBono);
   END;
   RETURN(nPorcBono);
END PORCENTAJE_Bono;

FUNCTION MONTO_Bono(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodBono VARCHAR2,
                     dFecBono DATE, nAnioBono NUMBER, nMontoFondo NUMBER) RETURN NUMBER IS
nMontoBono     FAI_BONOS_FONDOS_RANGOS.MontoBono%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MontoBono,0)
        INTO nMontoBono
        FROM FAI_BONOS_FONDOS_RANGOS
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND TipoFondo       = cTipoFondo
         AND CodBono         = cCodBono
         AND AnoIniRango    >= nAnioBono
         AND AnoFinRango    <= nAnioBono
         AND FecIniBono     >= dFecBono
         AND FecFinBono     <= dFecBono
         AND RangoIni       >= nMontoFondo
         AND RangoFin       <= nMontoFOndo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMontoBono := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Monto del Bono por Rangos para Fondo: '||cTipoFondo || ' y Bono ' || cCodBono);
   END;
   RETURN(nMontoBono);
END MONTO_Bono;

END GT_FAI_BONOS_FONDOS_RANGOS;

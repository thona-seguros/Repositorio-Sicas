--
-- GT_FAI_CARGOS_FONDOS_RANGOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_CARGOS_FONDOS_RANGOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_CARGOS_FONDOS_RANGOS AS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodCargoOrig VARCHAR2, cCodCargoDest VARCHAR2);

FUNCTION RUTINA_CALCULO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2,
                        dFecCargo DATE, nAnioCargo NUMBER, nMontoFondo NUMBER) RETURN VARCHAR2;

FUNCTION PORCENTAJE_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2,
                          dFecCargo DATE, nAnioCargo NUMBER, nMontoFondo NUMBER) RETURN NUMBER;

FUNCTION MONTO_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2,
                     dFecCargo DATE, nAnioCargo NUMBER, nMontoFondo NUMBER) RETURN NUMBER;

END GT_FAI_CARGOS_FONDOS_RANGOS;
/

--
-- GT_FAI_CARGOS_FONDOS_RANGOS  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_CARGOS_FONDOS_RANGOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_CARGOS_FONDOS_RANGOS AS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodCargoOrig VARCHAR2, cCodCargoDest VARCHAR2) IS 

CURSOR RANGOS_CARGO_Q IS
   SELECT CodCargo, FecIniCargo, FecFinCargo, AnoIniRango,
          AnoFinRango, RangoIni, RangoFin, PorcCargo, MontoCargo,
          CodRutinaCalc
     FROM FAI_CARGOS_FONDOS_RANGOS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondoOrig
      AND CodCargo   = cCodCargoOrig;
BEGIN
   -- Inserta Rangos del Cargo
   FOR Z IN RANGOS_CARGO_Q LOOP
      BEGIN
         INSERT INTO FAI_CARGOS_FONDOS_RANGOS
                (CodCia, CodEmpresa, TipoFondo, CodCargo, FecIniCargo, FecFinCargo,
                 AnoIniRango, AnoFinRango, RangoIni, RangoFin, PorcCargo, MontoCargo,
                 CodRutinaCalc)
         VALUES (nCodCia, nCodEmpresa, cTipoFondoDest, cCodCargoDest, Z.FecIniCargo, Z.FecFinCargo,
                 Z.AnoIniRango, Z.AnoFinRango, Z.RangoIni, Z.RangoFin, Z.PorcCargo, Z.MontoCargo,
                 Z.CodRutinaCalc);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20100,'Error Copiando Rangos de Cargo para Fondo: '||cTipoFondoDest||' y Cargo: '||cCodCargoDest);
      END;
   END LOOP;
END COPIAR;

FUNCTION RUTINA_CALCULO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2,
                        dFecCargo DATE, nAnioCargo NUMBER, nMontoFondo NUMBER) RETURN VARCHAR2 IS
cCodRutinaCalc   FAI_CARGOS_FONDOS_RANGOS.CodRutinaCalc%TYPE;
BEGIN
   BEGIN
      SELECT CodRutinaCalc
        INTO cCodRutinaCalc
        FROM FAI_CARGOS_FONDOS_RANGOS
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND TipoFondo       = cTipoFondo
         AND CodCargo        = cCodCargo
         AND AnoIniRango    >= nAnioCargo
         AND AnoFinRango    <= nAnioCargo
         AND FecIniCargo    >= dFecCargo
         AND FecFinCargo    <= dFecCargo
         AND RangoIni       >= nMontoFondo
         AND RangoFin       >= nMontoFOndo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodRutinaCalc := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Rutina de Cálculo del Cargo por Rangos para Fondo: ' ||
                                 cTipoFondo || ' Cargo ' || cCodCargo);
   END;
   RETURN(cCodRutinaCalc);
END RUTINA_CALCULO;

FUNCTION PORCENTAJE_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2,
                          dFecCargo DATE, nAnioCargo NUMBER, nMontoFondo NUMBER) RETURN NUMBER IS
nPorcCargo     FAI_CARGOS_FONDOS_RANGOS.PorcCargo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcCargo,0)
        INTO nPorcCargo
        FROM FAI_CARGOS_FONDOS_RANGOS
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND TipoFondo       = cTipoFondo
         AND CodCargo        = cCodCargo
         AND AnoIniRango    >= nAnioCargo
         AND AnoFinRango    <= nAnioCargo
         AND FecIniCargo    >= dFecCargo
         AND FecFinCargo    <= dFecCargo
         AND RangoIni       >= nMontoFondo
         AND RangoFin       >= nMontoFOndo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcCargo := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Porcentaje del Cargo por Rangos para Fondo: '||cTipoFondo || ' y Cargo ' || cCodCargo);
   END;
   RETURN(nPorcCargo);
END PORCENTAJE_CARGO;

FUNCTION MONTO_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2,
                     dFecCargo DATE, nAnioCargo NUMBER, nMontoFondo NUMBER) RETURN NUMBER IS
nMontoCargo     FAI_CARGOS_FONDOS_RANGOS.MontoCargo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MontoCargo,0)
        INTO nMontoCargo
        FROM FAI_CARGOS_FONDOS_RANGOS
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND TipoFondo       = cTipoFondo
         AND CodCargo        = cCodCargo
         AND AnoIniRango    >= nAnioCargo
         AND AnoFinRango    <= nAnioCargo
         AND FecIniCargo    >= dFecCargo
         AND FecFinCargo    <= dFecCargo
         AND RangoIni       >= nMontoFondo
         AND RangoFin       >= nMontoFOndo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMontoCargo := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Monto del Cargo por Rangos para Fondo: '||cTipoFondo || ' y Cargo ' || cCodCargo);
   END;
   RETURN(nMontoCargo);
END MONTO_CARGO;

END GT_FAI_CARGOS_FONDOS_RANGOS;
/

--
-- GT_FAI_CARGOS_FONDOS_RANGOS  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_CARGOS_FONDOS_RANGOS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_CARGOS_FONDOS_RANGOS FOR SICAS_OC.GT_FAI_CARGOS_FONDOS_RANGOS
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_FAI_CARGOS_FONDOS_RANGOS TO PUBLIC
/

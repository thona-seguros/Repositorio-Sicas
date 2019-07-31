--
-- GT_FAI_CARGOS_FONDOS_DET  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_CARGOS_FONDOS_DET (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_CARGOS_FONDOS_DET AS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodCargoOrig VARCHAR2, cCodCargoDest VARCHAR2);

FUNCTION TIPO_INTERES(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                      cCodCargo VARCHAR2, nAnioCargo NUMBER, dFecCargo DATE) RETURN VARCHAR2;

FUNCTION RUTINA_CALCULO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                        cCodCargo VARCHAR2, nAnioCargo NUMBER, dFecCargo DATE) RETURN VARCHAR2;

FUNCTION PORCENTAJE_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                          cCodCargo VARCHAR2, nAnioCargo NUMBER, dFecCargo DATE) RETURN NUMBER;

FUNCTION MONTO_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                     cCodCargo VARCHAR2, nAnioCargo NUMBER, dFecCargo DATE) RETURN NUMBER;

END GT_FAI_CARGOS_FONDOS_DET;
/

--
-- GT_FAI_CARGOS_FONDOS_DET  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_CARGOS_FONDOS_DET (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_CARGOS_FONDOS_DET AS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodCargoOrig VARCHAR2, cCodCargoDest VARCHAR2) IS 

CURSOR DET_CARGO_Q IS
   SELECT CodCargo, FecIniCargo, FecFinCargo, AnioCargo,
          PorcCargo, TipoInteres, CodRutinaCalc
     FROM FAI_CARGOS_FONDOS_DET
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondoOrig
      AND CodCargo   = cCodCargoOrig;
BEGIN
   -- Inserta Detalles del Cargo
   FOR Y IN DET_CARGO_Q LOOP
      BEGIN
         INSERT INTO FAI_CARGOS_FONDOS_DET
                (CodCia, CodEmpresa, TipoFondo, CodCargo, FecIniCargo, FecFinCargo,
                 AnioCargo, PorcCargo, TipoInteres, CodRutinaCalc)
         VALUES (nCodCia, nCodEmpresa, cTipoFondoDest, cCodCargoDest, Y.FecIniCargo, Y.FecFinCargo,
                 Y.AnioCargo, Y.PorcCargo, Y.TipoInteres, Y.CodRutinaCalc);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20100,'Error Copiando Detalle de Cargo para Fondo: '||cTipoFondoDest||' y Cargo: '||cCodCargoDest);
      END;
   END LOOP;
END COPIAR;

FUNCTION TIPO_INTERES(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                      cCodCargo VARCHAR2, nAnioCargo NUMBER, dFecCargo DATE) RETURN VARCHAR2 IS
cTipoInteres   FAI_CARGOS_FONDOS_DET.TipoInteres%TYPE;
BEGIN
   BEGIN
      SELECT TipoInteres
        INTO cTipoInteres
        FROM FAI_CARGOS_FONDOS_DET
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND TipoFondo     = cTipoFondo
         AND CodCargo      = cCodCargo
         AND AnioCargo     = nAnioCargo
         AND FecIniCargo  >= dFecCargo
         AND FecFinCargo  <= dFecCargo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoInteres := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Tipo de Interes del Cargo para Fondo: '||cTipoFondo || ' y Cargo ' || cCodCargo);
   END;
   RETURN(cTipoInteres);
END TIPO_INTERES;

FUNCTION RUTINA_CALCULO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                        cCodCargo VARCHAR2, nAnioCargo NUMBER, dFecCargo DATE) RETURN VARCHAR2 IS
cCodRutinaCalc   FAI_CARGOS_FONDOS_DET.CodRutinaCalc%TYPE;
BEGIN
   BEGIN
      SELECT CodRutinaCalc
        INTO cCodRutinaCalc
        FROM FAI_CARGOS_FONDOS_DET
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND TipoFondo     = cTipoFondo
         AND CodCargo      = cCodCargo
         AND AnioCargo     = nAnioCargo
         AND FecIniCargo  >= dFecCargo
         AND FecFinCargo  <= dFecCargo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodRutinaCalc := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Rutina de Cálculo del Cargo para Fondo: '||cTipoFondo || ' y Cargo ' || cCodCargo);
   END;
   RETURN(cCodRutinaCalc);
END RUTINA_CALCULO;

FUNCTION PORCENTAJE_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                          cCodCargo VARCHAR2, nAnioCargo NUMBER, dFecCargo DATE) RETURN NUMBER IS
nPorcCargo     FAI_CARGOS_FONDOS_DET.PorcCargo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcCargo,0)
        INTO nPorcCargo
        FROM FAI_CARGOS_FONDOS_DET
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND TipoFondo     = cTipoFondo
         AND CodCargo      = cCodCargo
         AND AnioCargo     = nAnioCargo
         AND FecIniCargo  >= dFecCargo
         AND FecFinCargo  <= dFecCargo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcCargo := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Porcentaje del Cargo para Fondo: '||cTipoFondo || ' y Cargo ' || cCodCargo);
   END;
   RETURN(nPorcCargo);
END PORCENTAJE_CARGO;

FUNCTION MONTO_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2,
                     cCodCargo VARCHAR2, nAnioCargo NUMBER, dFecCargo DATE) RETURN NUMBER IS
nMontoCargo     FAI_CARGOS_FONDOS_DET.MontoCargo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MontoCargo,0)
        INTO nMontoCargo
        FROM FAI_CARGOS_FONDOS_DET
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND TipoFondo     = cTipoFondo
         AND CodCargo      = cCodCargo
         AND AnioCargo     = nAnioCargo
         AND FecIniCargo  >= dFecCargo
         AND FecFinCargo  <= dFecCargo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMontoCargo := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Monto del Cargo para Fondo: '||cTipoFondo || ' y Cargo ' || cCodCargo);
   END;
   RETURN(nMontoCargo);
END MONTO_CARGO;

END GT_FAI_CARGOS_FONDOS_DET;
/

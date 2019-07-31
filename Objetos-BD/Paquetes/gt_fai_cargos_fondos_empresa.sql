--
-- GT_FAI_CARGOS_FONDOS_EMPRESA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_CARGOS_FONDOS_EMPRESA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_CARGOS_FONDOS_EMPRESA AS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodCargoOrig VARCHAR2, cCodCargoDest VARCHAR2);

FUNCTION RUTINA_CALCULO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2,
                        cCodGrupoPol VARCHAR2, cIndTipoEmpleado VARCHAR2, dFecCargo DATE) RETURN VARCHAR2;

FUNCTION PORCENTAJE_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2,
                          cCodGrupoPol VARCHAR2, cIndTipoEmpleado VARCHAR2, dFecCargo DATE) RETURN NUMBER;

FUNCTION MONTO_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2,
                     cCodGrupoPol VARCHAR2, cIndTipoEmpleado VARCHAR2, dFecCargo DATE) RETURN NUMBER;

END GT_FAI_CARGOS_FONDOS_EMPRESA;
/

--
-- GT_FAI_CARGOS_FONDOS_EMPRESA  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_CARGOS_FONDOS_EMPRESA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_CARGOS_FONDOS_EMPRESA AS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodCargoOrig VARCHAR2, cCodCargoDest VARCHAR2) IS 

CURSOR EMPRESAS_CARGO_Q IS
   SELECT CodCargo, CodGrupoPol, IndTipoEmpleado, FecIniCargo, 
	       FecFinCargo, PorcCargo, MontoCargo, CodRutinaCalc
     FROM FAI_CARGOS_FONDOS_EMPRESA
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondoOrig
      AND CodCargo   = cCodCargoOrig;
BEGIN
   FOR W IN EMPRESAS_CARGO_Q LOOP
      BEGIN
         INSERT INTO FAI_CARGOS_FONDOS_EMPRESA
                (CodCia, CodEmpresa, TipoFondo, CodCargo, CodGrupoPol, IndTipoEmpleado,
                 FecIniCargo, FecFinCargo, PorcCargo, MontoCargo, CodRutinaCalc)
         VALUES (nCodCia, nCodEmpresa, cTipoFondoDest, cCodCargoDest, W.CodGrupoPol, W.IndTipoEmpleado,
                 W.FecIniCargo, W.FecFinCargo, W.PorcCargo, W.MontoCargo, W.CodRutinaCalc);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20100,'Error Copiando Empresas de Cargo para Fondo: '||cTipoFondoDest||' y Cargo: '||cCodCargoDest);
      END;
   END LOOP;
END COPIAR;


FUNCTION RUTINA_CALCULO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2,
                        cCodGrupoPol VARCHAR2, cIndTipoEmpleado VARCHAR2, dFecCargo DATE) RETURN VARCHAR2 IS
cCodRutinaCalc   FAI_CARGOS_FONDOS_EMPRESA.CodRutinaCalc%TYPE;
BEGIN
   BEGIN
      SELECT CodRutinaCalc
        INTO cCodRutinaCalc
        FROM FAI_CARGOS_FONDOS_EMPRESA
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND TipoFondo       = cTipoFondo
         AND CodCargo        = cCodCargo
         AND CodGrupoPol     = cCodGrupoPol
         AND IndTipoEmpleado = cIndTipoEmpleado
         AND FecIniCargo    >= dFecCargo
         AND FecFinCargo    <= dFecCargo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodRutinaCalc := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Rutina de Cálculo del Cargo por Empresa para Fondo: ' ||
                                 cTipoFondo || ' Cargo ' || cCodCargo || ' y Empresa ' || cCodGrupoPol);
   END;
   RETURN(cCodRutinaCalc);
END RUTINA_CALCULO;

FUNCTION PORCENTAJE_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2,
                          cCodGrupoPol VARCHAR2, cIndTipoEmpleado VARCHAR2, dFecCargo DATE) RETURN NUMBER IS
nPorcCargo     FAI_CARGOS_FONDOS_EMPRESA.PorcCargo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcCargo,0)
        INTO nPorcCargo
        FROM FAI_CARGOS_FONDOS_EMPRESA
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND TipoFondo       = cTipoFondo
         AND CodCargo        = cCodCargo
         AND CodGrupoPol     = cCodGrupoPol
         AND IndTipoEmpleado = cIndTipoEmpleado
         AND FecIniCargo    >= dFecCargo
         AND FecFinCargo    <= dFecCargo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcCargo := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Porcentaje del Cargo para Fondo: '||cTipoFondo || ' y Cargo ' || cCodCargo);
   END;
   RETURN(nPorcCargo);
END PORCENTAJE_CARGO;

FUNCTION MONTO_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2,
                     cCodGrupoPol VARCHAR2, cIndTipoEmpleado VARCHAR2, dFecCargo DATE) RETURN NUMBER IS
nMontoCargo     FAI_CARGOS_FONDOS_EMPRESA.MontoCargo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MontoCargo,0)
        INTO nMontoCargo
        FROM FAI_CARGOS_FONDOS_EMPRESA
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND TipoFondo       = cTipoFondo
         AND CodCargo        = cCodCargo
         AND CodGrupoPol     = cCodGrupoPol
         AND IndTipoEmpleado = cIndTipoEmpleado
         AND FecIniCargo    >= dFecCargo
         AND FecFinCargo    <= dFecCargo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nMontoCargo := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Función de Monto del Cargo para Fondo: '||cTipoFondo || ' y Cargo ' || cCodCargo);
   END;
   RETURN(nMontoCargo);
END MONTO_CARGO;

END GT_FAI_CARGOS_FONDOS_EMPRESA;
/

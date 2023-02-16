CREATE OR REPLACE PACKAGE GT_FAI_CARGOS_FONDOS AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2);

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2);

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2);

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2);

FUNCTION DESCRIPCION_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2) RETURN VARCHAR2;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodCargoOrig VARCHAR2, cCodCargoDest VARCHAR2, cDescCargoDest VARCHAR2);

FUNCTION CONCEPTO_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2) RETURN VARCHAR2;

END GT_FAI_CARGOS_FONDOS;
/

CREATE OR REPLACE PACKAGE BODY GT_FAI_CARGOS_FONDOS AS

PROCEDURE ACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2) IS
BEGIN
   UPDATE FAI_CARGOS_FONDOS
      SET StsCargo   = 'ACTIVO',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondo
      AND CodCargo   = cCodCargo;
END ACTIVAR;

PROCEDURE CONFIGURAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2) IS
BEGIN
   UPDATE FAI_CARGOS_FONDOS
      SET StsCargo   = 'CONFIG',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondo
      AND CodCargo   = cCodCargo;
END CONFIGURAR;

PROCEDURE REACTIVAR (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2) IS
BEGIN
   UPDATE FAI_CARGOS_FONDOS
      SET StsCargo  = 'ACTIVO',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondo
      AND CodCargo   = cCodCargo;
END REACTIVAR;

PROCEDURE SUSPENDER (nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2) IS
BEGIN
   UPDATE FAI_CARGOS_FONDOS
      SET StsCargo   = 'SUSPEN',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondo
      AND CodCargo   = cCodCargo;
END SUSPENDER;

FUNCTION DESCRIPCION_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2) RETURN VARCHAR2 IS
cDescCargo    FAI_CARGOS_FONDOS.DescCargo%TYPE;
BEGIN
   BEGIN
      SELECT DescCargo
        INTO cDescCargo
        FROM FAI_CARGOS_FONDOS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND TipoFondo  = cTipoFondo
         AND CodCargo   = cCodCargo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescCargo := 'NO EXISTE';
      WHEN OTHERS THEN
         cDescCargo := 'ERROR';
   END;

   RETURN(cDescCargo);
END DESCRIPCION_CARGO;

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondoOrig VARCHAR2, cTipoFondoDest VARCHAR2, 
                 cCodCargoOrig VARCHAR2, cCodCargoDest VARCHAR2, cDescCargoDest VARCHAR2) IS
CURSOR CARGO_Q IS
   SELECT CodCargo, DescCargo, TipoCargo, CptoMovFondo,
          PeriodoCargo, StsCargo, FecStatus, 
          TipoAplic, IndDescuentoRetTot
     FROM FAI_CARGOS_FONDOS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondoOrig
	   AND CodCargo   = cCodCargoOrig;
BEGIN
   -- Inserta Cargos del Fondo
   FOR X IN CARGO_Q LOOP
      BEGIN
         INSERT INTO FAI_CARGOS_FONDOS
                (CodCia, CodEmpresa, TipoFondo, CodCargo, DescCargo, TipoCargo, 
                 CptoMovFondo, PeriodoCargo, StsCargo, FecStatus,
                 TipoAplic, IndDescuentoRetTot)
         VALUES (nCodCia, nCodEmpresa, cTipoFondoDest, cCodCargoDest, cDescCargoDest, X.TipoCargo, X.CptoMovFondo,
                 X.PeriodoCargo, 'CONFIG', TRUNC(SYSDATE), 
                 X.TipoAplic, X.IndDescuentoRetTot);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20100,'Error Copiando Fondo: '||cTipoFondoDest||' y Cargo: '||cCodCargoDest);
      END;
   END LOOP;
   
   GT_FAI_CARGOS_FONDOS_DET.COPIAR(nCodCia, nCodEmpresa, cTipoFondoOrig, cTipoFondoDest, cCodCargoOrig, cCodCargoDest);

   GT_FAI_CARGOS_FONDOS_EMPRESA.COPIAR(nCodCia, nCodEmpresa, cTipoFondoOrig, cTipoFondoDest, cCodCargoOrig, cCodCargoDest);

   GT_FAI_CARGOS_FONDOS_RANGOS.COPIAR(nCodCia, nCodEmpresa, cTipoFondoOrig, cTipoFondoDest, cCodCargoOrig, cCodCargoDest);

END COPIAR;

FUNCTION CONCEPTO_CARGO(nCodCia NUMBER, nCodEmpresa NUMBER, cTipoFondo VARCHAR2, cCodCargo VARCHAR2) RETURN VARCHAR2 IS
cCptoMovFondo    FAI_CARGOS_FONDOS.CptoMovFondo%TYPE;
BEGIN
   BEGIN
      SELECT CptoMovFondo
        INTO cCptoMovFondo
        FROM FAI_CARGOS_FONDOS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND TipoFondo  = cTipoFondo
         AND CodCargo   = cCodCargo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCptoMovFondo := NULL;
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20100,'Error en Configuración Existen Varios Cargos ' || cCodCargo || ' en Fondo: '||cTipoFondo);
   END;

   RETURN(cCptoMovFondo);
END CONCEPTO_CARGO;

END GT_FAI_CARGOS_FONDOS;

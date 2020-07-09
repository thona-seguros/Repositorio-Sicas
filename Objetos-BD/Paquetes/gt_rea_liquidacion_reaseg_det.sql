--
-- GT_REA_LIQUIDACION_REASEG_DET  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   REA_LIQUIDACION_REASEG_DET (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_REA_LIQUIDACION_REASEG_DET IS
  PROCEDURE INSERTAR(nCodCia NUMBER, nIdLiquidacion NUMBER, nIdDetLiqReaseg NUMBER,
                     cCodCptoLiquida VARCHAR2, nTotCptoLiquida NUMBER, cDescMovimiento VARCHAR2);
  FUNCTION TOTAL_LIQUIDACION(nCodCia NUMBER, nIdLiquidacion NUMBER, nIdDetLiqReaseg NUMBER) RETURN NUMBER;
END GT_REA_LIQUIDACION_REASEG_DET;
/

--
-- GT_REA_LIQUIDACION_REASEG_DET  (Package Body) 
--
--  Dependencies: 
--   GT_REA_LIQUIDACION_REASEG_DET (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_REA_LIQUIDACION_REASEG_DET IS

PROCEDURE INSERTAR(nCodCia NUMBER, nIdLiquidacion NUMBER, nIdDetLiqReaseg NUMBER,
                   cCodCptoLiquida VARCHAR2, nTotCptoLiquida NUMBER, cDescMovimiento VARCHAR2) IS
BEGIN
   INSERT INTO REA_LIQUIDACION_REASEG_DET
          (CodCia, IdLiquidacion, IdDetLiqReaseg, CodCptoLiquida,
           TotCptoLiquida, DescMovimiento)
   VALUES (nCodCia, nIdLiquidacion, nIdDetLiqReaseg, cCodCptoLiquida,
           nTotCptoLiquida, cDescMovimiento);
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20000,'Registro Duplicado en Detalle de Conceptos de Liquidación No. '||
                              nIdLiquidacion || ' Concepto: ' || cCodCptoLiquida);
END INSERTAR;

FUNCTION TOTAL_LIQUIDACION(nCodCia NUMBER, nIdLiquidacion NUMBER, nIdDetLiqReaseg NUMBER) RETURN NUMBER IS
nTotCptoLiquida       REA_LIQUIDACION_REASEG_DET.TotCptoLiquida%TYPE;
BEGIN
   SELECT NVL(SUM(TotCptoLiquida),0)
     INTO nTotCptoLiquida
     FROM REA_LIQUIDACION_REASEG_DET
    WHERE CodCia         = nCodCia
      AND IdLiquidacion  = nIdLiquidacion
      AND IdDetLiqReaseg = nIdDetLiqReaseg;
   RETURN(nTotCptoLiquida);
END TOTAL_LIQUIDACION;

END GT_REA_LIQUIDACION_REASEG_DET;
/

--
-- GT_REA_LIQUIDACION_REASEG_DET  (Synonym) 
--
--  Dependencies: 
--   GT_REA_LIQUIDACION_REASEG_DET (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_REA_LIQUIDACION_REASEG_DET FOR SICAS_OC.GT_REA_LIQUIDACION_REASEG_DET
/


GRANT EXECUTE ON SICAS_OC.GT_REA_LIQUIDACION_REASEG_DET TO PUBLIC
/

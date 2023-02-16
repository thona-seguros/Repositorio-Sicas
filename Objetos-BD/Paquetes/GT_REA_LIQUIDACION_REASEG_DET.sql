CREATE OR REPLACE PACKAGE GT_REA_LIQUIDACION_REASEG_DET IS
  PROCEDURE INSERTAR(nCodCia NUMBER, nIdLiquidacion NUMBER, nIdDetLiqReaseg NUMBER,
                     cCodCptoLiquida VARCHAR2, nTotCptoLiquida NUMBER, cDescMovimiento VARCHAR2);
  FUNCTION TOTAL_LIQUIDACION(nCodCia NUMBER, nIdLiquidacion NUMBER, nIdDetLiqReaseg NUMBER) RETURN NUMBER;
END GT_REA_LIQUIDACION_REASEG_DET;
/

CREATE OR REPLACE PACKAGE BODY GT_REA_LIQUIDACION_REASEG_DET IS

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

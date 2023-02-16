CREATE OR REPLACE PACKAGE GT_REA_CONCEPTOS_LIQUIDACION IS

  PROCEDURE ACTIVAR_CONCEPTO(nCodCia NUMBER, cCodCptoLiquida VARCHAR2);
  PROCEDURE SUSPENDER_CONCEPTO(nCodCia NUMBER, cCodCptoLiquida VARCHAR2);
  FUNCTION DESCRIPCION_CONCEPTO(nCodCia NUMBER, cCodCptoLiquida VARCHAR2) RETURN VARCHAR2;
  FUNCTION CONCEPTO_CONTABLE(nCodCia NUMBER, cTipoRegLiquidacion VARCHAR2) RETURN VARCHAR2;

END GT_REA_CONCEPTOS_LIQUIDACION;
/

CREATE OR REPLACE PACKAGE BODY GT_REA_CONCEPTOS_LIQUIDACION IS

PROCEDURE ACTIVAR_CONCEPTO(nCodCia NUMBER, cCodCptoLiquida VARCHAR2) IS
BEGIN
   UPDATE REA_CONCEPTOS_LIQUIDACION
      SET StsConcepto = 'ACTIVO',
          FecStatus   = TRUNC(SYSDATE)
    WHERE CodCia         = nCodCia
      AND CodCptoLiquida = cCodCptoLiquida;
END ACTIVAR_CONCEPTO;

PROCEDURE SUSPENDER_CONCEPTO(nCodCia NUMBER, cCodCptoLiquida VARCHAR2) IS
BEGIN
   UPDATE REA_CONCEPTOS_LIQUIDACION
      SET StsConcepto = 'SUSPEN',
          FecStatus   = TRUNC(SYSDATE)
    WHERE CodCia         = nCodCia
      AND CodCptoLiquida = cCodCptoLiquida;
END SUSPENDER_CONCEPTO;

FUNCTION DESCRIPCION_CONCEPTO(nCodCia NUMBER, cCodCptoLiquida VARCHAR2) RETURN VARCHAR2 IS
cDescCptoLiquida       REA_CONCEPTOS_LIQUIDACION.DescCptoLiquida%TYPE;
BEGIN
   BEGIN
      SELECT DescCptoLiquida
        INTO cDescCptoLiquida
        FROM REA_CONCEPTOS_LIQUIDACION
       WHERE CodCia         = nCodCia
         AND CodCptoLiquida = cCodCptoLiquida;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescCptoLiquida := 'Concepto - NO EXISTE';
   END;
   RETURN(cDescCptoLiquida);
END DESCRIPCION_CONCEPTO;

FUNCTION CONCEPTO_CONTABLE(nCodCia NUMBER, cTipoRegLiquidacion VARCHAR2) RETURN VARCHAR2 IS
cCodCptoContable       REA_CONCEPTOS_LIQUIDACION.CodCptoContable%TYPE;
BEGIN
   BEGIN
      SELECT CodCptoContable
        INTO cCodCptoContable
        FROM REA_CONCEPTOS_LIQUIDACION
       WHERE CodCia             = nCodCia
         AND StsConcepto        = 'ACTIVO'
         AND TipoRegLiquidacion = cTipoRegLiquidacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Registros de Liquidación para el Tipo de Liquidación ' || cTipoRegLiquidacion); 
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error Existen Varios Registros para el Tipo de Liquidación ' || cTipoRegLiquidacion); 
   END;
   RETURN(cCodCptoContable);
END CONCEPTO_CONTABLE;

END GT_REA_CONCEPTOS_LIQUIDACION;

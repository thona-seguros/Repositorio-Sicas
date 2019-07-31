--
-- GT_REA_LIQUIDACION_REASEG  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   GT_REA_LIQUIDACION_REASEG_DET (Package)
--   REA_LIQUIDACION_REASEG (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_REA_LIQUIDACION_REASEG IS
  PROCEDURE INSERTAR(nCodCia NUMBER, nIdLiquidacion NUMBER, cCodEmpresaGremio VARCHAR2,
                     cCodInterReaseg VARCHAR2, cCodMoneda VARCHAR2);
  PROCEDURE ACTUALIZAR_MONTO(nCodCia NUMBER, nIdLiquidacion NUMBER, nIdDetLiqReaseg NUMBER);
  FUNCTION NUMERO_DETALLE(nCodCia NUMBER, nIdLiquidacion NUMBER) RETURN NUMBER;
END GT_REA_LIQUIDACION_REASEG;
/

--
-- GT_REA_LIQUIDACION_REASEG  (Package Body) 
--
--  Dependencies: 
--   GT_REA_LIQUIDACION_REASEG (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_REA_LIQUIDACION_REASEG IS

PROCEDURE INSERTAR(nCodCia NUMBER, nIdLiquidacion NUMBER, cCodEmpresaGremio VARCHAR2,
                   cCodInterReaseg VARCHAR2, cCodMoneda VARCHAR2) IS
nIdDetLiqReaseg       REA_LIQUIDACION_REASEG.IdDetLiqReaseg%TYPE;
BEGIN
   nIdDetLiqReaseg := GT_REA_LIQUIDACION_REASEG.NUMERO_DETALLE(nCodCia, nIdLiquidacion);
   INSERT INTO REA_LIQUIDACION_REASEG
          (CodCia, IdLiquidacion, IdDetLiqReaseg, CodEmpresaGremio, CodInterReaseg,
           CodMoneda, MontoNetoLiq, IdFactura, IdNcr, StsDetLiqReaseg, FecStatus)
   VALUES (nCodCia, nIdLiquidacion, nIdDetLiqReaseg, cCodEmpresaGremio, cCodInterReaseg,
           cCodMoneda, 0, NULL, NULL, 'ACTIVA', TRUNC(SYSDATE));
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20000,'Registro Duplicado en Detalle de Reaseguradores de Liquidación No. '||nIdLiquidacion);
END INSERTAR;

PROCEDURE ACTUALIZAR_MONTO(nCodCia NUMBER, nIdLiquidacion NUMBER, nIdDetLiqReaseg NUMBER) IS
nMontoNetoLiq       REA_LIQUIDACION_REASEG.MontoNetoLiq%TYPE;
BEGIN
   nMontoNetoLiq := GT_REA_LIQUIDACION_REASEG_DET.TOTAL_LIQUIDACION(nCodCia, nIdLiquidacion, nIdDetLiqReaseg);
   UPDATE REA_LIQUIDACION_REASEG
      SET MontoNetoLiq   = nMontoNetoLiq
    WHERE CodCia         = nCodCia
      AND IdLiquidacion  = nIdLiquidacion
      AND IdDetLiqReaseg = nIdDetLiqReaseg;
END ACTUALIZAR_MONTO;

FUNCTION NUMERO_DETALLE(nCodCia NUMBER, nIdLiquidacion NUMBER) RETURN NUMBER IS
nIdDetLiqReaseg       REA_LIQUIDACION_REASEG.IdDetLiqReaseg%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MAX(IdDetLiqReaseg),0)+1
        INTO nIdDetLiqReaseg
        FROM REA_LIQUIDACION_REASEG
       WHERE CodCia          = nCodCia
         AND IdLiquidacion   = nIdLiquidacion;
   END;
   RETURN(nIdDetLiqReaseg);
END NUMERO_DETALLE;

END GT_REA_LIQUIDACION_REASEG;
/

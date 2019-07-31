--
-- GT_BONOS_AGENTES_PROY_FACT  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   BONOS_AGENTES_PROYECCION_FACT (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_BONOS_AGENTES_PROY_FACT AS

PROCEDURE INSERTAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nIdCalculoProy NUMBER, 
                    nCodNivel NUMBER, cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, 
                    nIdPoliza NUMBER, nNumRenov NUMBER, nIdFactura NUMBER, dFechaEmiFact DATE, 
                    nMontoFactMoneda NUMBER, cAplicaTitular VARCHAR2, nPorcenAsegTit NUMBER);

PROCEDURE ELIMINAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, 
                    cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE);

END GT_BONOS_AGENTES_PROY_FACT;
/

--
-- GT_BONOS_AGENTES_PROY_FACT  (Package Body) 
--
--  Dependencies: 
--   GT_BONOS_AGENTES_PROY_FACT (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_BONOS_AGENTES_PROY_FACT AS

PROCEDURE INSERTAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nIdCalculoProy NUMBER, 
                    nCodNivel NUMBER, cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, 
                    nIdPoliza NUMBER, nNumRenov NUMBER, nIdFactura NUMBER, dFechaEmiFact DATE, 
                    nMontoFactMoneda NUMBER, cAplicaTitular VARCHAR2, nPorcenAsegTit NUMBER) IS
BEGIN
   BEGIN
      INSERT INTO BONOS_AGENTES_PROYECCION_FACT
            (CodCia, CodEmpresa, IdBonoVentas, IdCalculoProy, CodNivel, 
             CodAgente, FecIniCalcBono, FecFinCalcBono, IdPoliza, NumRenov,
             IdFactura, FechaEmiFact, MontoFactMoneda, AplicaTitular, 
             PorcenAsegTit)
      VALUES(nCodCia, nCodEmpresa, nIdBonoVentas, nIdCalculoProy, nCodNivel, 
             cCodAgente, dFecIniCalcBono, dFecFinCalcBono, nIdPoliza, nNumRenov, 
             nIdFactura, dFechaEmiFact, nMontoFactMoneda, cAplicaTitular, 
             nPorcenAsegTit);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20100,'Error al Insertar Factura ' || nIdFactura || ' para Bono No. ' || nIdBonoVentas);
   END;
END INSERTAR;

PROCEDURE ELIMINAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, 
                    cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE) IS
BEGIN
   DELETE BONOS_AGENTES_PROYECCION_FACT
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdBonoVentas   = nIdBonoVentas
      AND CodNivel       = nCodNivel
      AND CodAgente      = cCodAgente
      AND FecIniCalcBono = dFecIniCalcBono
      AND FecFinCalcBono = dFecFinCalcBono;
END ELIMINAR;

END GT_BONOS_AGENTES_PROY_FACT;
/

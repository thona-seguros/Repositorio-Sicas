--
-- GT_BONOS_AGENTES_FACTURAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   BONOS_AGENTES_FACTURAS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_BONOS_AGENTES_FACTURAS AS

PROCEDURE INSERTAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, 
                    cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, nIdPoliza NUMBER,
                    nNumRenov NUMBER, nIdFactura NUMBER, dFechaPagoFact DATE, nMontoFactMoneda NUMBER, 
                    cAplicaTitular VARCHAR2, nPorcenAsegTit NUMBER);

PROCEDURE ELIMINAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, 
                    cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE);

END GT_BONOS_AGENTES_FACTURAS;
/

--
-- GT_BONOS_AGENTES_FACTURAS  (Package Body) 
--
--  Dependencies: 
--   GT_BONOS_AGENTES_FACTURAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_BONOS_AGENTES_FACTURAS AS

PROCEDURE INSERTAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, 
                    cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE, nIdPoliza NUMBER,
                    nNumRenov NUMBER, nIdFactura NUMBER, dFechaPagoFact DATE, nMontoFactMoneda NUMBER, 
                    cAplicaTitular VARCHAR2, nPorcenAsegTit NUMBER) IS
BEGIN
   BEGIN
      INSERT INTO BONOS_AGENTES_FACTURAS
            (CodCia, CodEmpresa, IdBonoVentas, CodNivel, CodAgente, 
             FecIniCalcBono, FecFinCalcBono, IdPoliza, NumRenov,
             IdFactura, FechaPagoFact, MontoFactMoneda, AplicaTitular, 
             PorcenAsegTit)
      VALUES(nCodCia, nCodEmpresa, nIdBonoVentas, nCodNivel, cCodAgente,
             dFecIniCalcBono, dFecFinCalcBono, nIdPoliza, nNumRenov, 
             nIdFactura, dFechaPagoFact, nMontoFactMoneda, cAplicaTitular, 
             nPorcenAsegTit);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20100,'Error al Insertar Factura ' || nIdFactura || ' para Bono No. ' || nIdBonoVentas);
   END;
END INSERTAR;

PROCEDURE ELIMINAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdBonoVentas NUMBER, nCodNivel NUMBER, 
                    cCodAgente VARCHAR2, dFecIniCalcBono DATE, dFecFinCalcBono DATE) IS
BEGIN
   DELETE BONOS_AGENTES_FACTURAS
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND IdBonoVentas   = nIdBonoVentas
      AND CodNivel       = nCodNivel
      AND CodAgente      = cCodAgente
      AND FecIniCalcBono = dFecIniCalcBono
      AND FecFinCalcBono = dFecFinCalcBono;
END ELIMINAR;

END GT_BONOS_AGENTES_FACTURAS;
/

--
-- GT_BONOS_AGENTES_FACTURAS  (Synonym) 
--
--  Dependencies: 
--   GT_BONOS_AGENTES_FACTURAS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_BONOS_AGENTES_FACTURAS FOR SICAS_OC.GT_BONOS_AGENTES_FACTURAS
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_BONOS_AGENTES_FACTURAS TO PUBLIC
/

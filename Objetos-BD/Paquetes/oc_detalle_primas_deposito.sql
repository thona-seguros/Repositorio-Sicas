--
-- OC_DETALLE_PRIMAS_DEPOSITO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   DETALLE_PRIMAS_DEPOSITO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_DETALLE_PRIMAS_DEPOSITO IS

PROCEDURE INSERTAR(nCodCliente NUMBER, nIdRecibo NUMBER, nIdPrimaDeposito NUMBER,
                   nIdFactura NUMBER, nIdPoliza NUMBER, nMontoAplicado NUMBER,
                   cTipoMov VARCHAR2);

FUNCTION CORRELATIVO(nIdPrimaDeposito NUMBER) RETURN NUMBER;

END OC_DETALLE_PRIMAS_DEPOSITO;
/

--
-- OC_DETALLE_PRIMAS_DEPOSITO  (Package Body) 
--
--  Dependencies: 
--   OC_DETALLE_PRIMAS_DEPOSITO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_DETALLE_PRIMAS_DEPOSITO IS

PROCEDURE INSERTAR(nCodCliente NUMBER, nIdRecibo NUMBER, nIdPrimaDeposito NUMBER,
                   nIdFactura NUMBER, nIdPoliza NUMBER, nMontoAplicado NUMBER,
                   cTipoMov VARCHAR2) IS
nCorrelativo     DETALLE_PRIMAS_DEPOSITO.Correlativo%TYPE;
BEGIN
   nCorrelativo := OC_DETALLE_PRIMAS_DEPOSITO.CORRELATIVO(nIdPrimaDeposito);

   BEGIN
      INSERT INTO DETALLE_PRIMAS_DEPOSITO
             (CodCliente, IdRecibo, IdPrimaDeposito, Correlativo, IdFactura,
              IdPoliza, Tip_Mov, Monto_Aplicado_Moneda, Estado)
      VALUES (nCodCliente, nIdRecibo, nIdPrimaDeposito, nCorrelativo, nIdFactura,
              nIdPoliza, cTipoMov, nMontoAplicado, 'APLICA');
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20100,'No. de Detalle ' || nCorrelativo || ', Ya existe en Prima en Depósito ');
   END;
END INSERTAR;

FUNCTION CORRELATIVO(nIdPrimaDeposito NUMBER) RETURN NUMBER IS
nCorrelativo     DETALLE_PRIMAS_DEPOSITO.Correlativo%TYPE;
BEGIN
   SELECT NVL(MAX(Correlativo),0)+1
     INTO nCorrelativo
     FROM DETALLE_PRIMAS_DEPOSITO
    WHERE IdPrimaDeposito = nIdPrimaDeposito;

   RETURN(nCorrelativo);
END CORRELATIVO;

END OC_DETALLE_PRIMAS_DEPOSITO;
/

CREATE OR REPLACE PACKAGE OC_PAGOS IS

FUNCTION CORRELATIVO_PAGO(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER;

PROCEDURE INGRESA_PAGOS (nCodCia NUMBER, nCodEmpresa NUMBER, cCodMoneda VARCHAR2, 
                         nIdFactura NUMBER, nMonto NUMBER, nIdTransaccion NUMBER,
                         cFormPago VARCHAR2, nIdRecibo NUMBER, cNumDoc VARCHAR2);
PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdRecibo NUMBER,
                 nIdFactura NUMBER, dFecAnul DATE, nIdTransaccion NUMBER);

FUNCTION EXISTE_DEPOSITO(nCodCia NUMBER, nCodEmpresa NUMBER, cNumDeposito VARCHAR2) RETURN VARCHAR2;

END OC_PAGOS;
/

CREATE OR REPLACE PACKAGE BODY OC_PAGOS IS

FUNCTION CORRELATIVO_PAGO(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER IS
nIdRecibo                PAGOS.IdRecibo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MAX(IdRecibo),0) + 1
        INTO nIdRecibo
        FROM PAGOS
       WHERE CodEmpresa = nCodEmpresa
         AND CodCia     = nCodCia;
   END;
   RETURN(nIdRecibo);
END CORRELATIVO_PAGO;

PROCEDURE INGRESA_PAGOS (nCodCia NUMBER, nCodEmpresa NUMBER, cCodMoneda VARCHAR2, 
                         nIdFactura NUMBER, nMonto NUMBER, nIdTransaccion NUMBER, 
                         cFormPago VARCHAR2, nIdRecibo NUMBER, cNumDoc VARCHAR2) IS
nDummy    NUMBER;
BEGIN
   INSERT INTO PAGOS
          (IdRecibo, CodEmpresa, CodCia,  Fecha, Operado, Monto,
           Moneda, Idfactura, IdTransaccion, FormPago, NumDoc, Num_Recibo_Ref)
   VALUES (nIdRecibo, nCodEmpresa, nCodCia, TRUNC(SYSDATE), USER, nMonto, 
           cCodMoneda, nIdFactura, nIdTransaccion, cFormPago, cNumDoc, cNumDoc);

/*   OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 12, 'PAG', 'PAGOS',
                               nIdRecibo, nIdFactura, NULL, NULL, nMonto);*/

EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR (-20100,'Error al Insertar Pagos de Factura ' || SQLERRM);
END INGRESA_PAGOS;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdRecibo NUMBER, nIdFactura NUMBER, 
                 dFecAnul DATE, nIdTransaccion NUMBER) IS
nMontoPago    PAGOS.Monto%TYPE;
BEGIN
   SELECT NVL(Monto,0) MontoPago
     INTO nMontoPago
     FROM PAGOS
    WHERE IdRecibo   = nIdrecibo
      AND IdFactura  = nIdFactura
      AND CodCia     = nCodCia;
    
/*   OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 12, 'REVPAG', 'PAGOS',
                               nIdRecibo, nIdFactura, NULL, NULL, nMontoPago);*/

   UPDATE PAGOS
      SET FecAnulacion     = dFecAnul,
          IdTransaccionAnu = nIdTransaccion
    WHERE IdRecibo   = nIdrecibo
      AND IdFactura  = nIdFactura
      AND CodCia     = nCodCia;
END ANULAR;

FUNCTION EXISTE_DEPOSITO(nCodCia NUMBER, nCodEmpresa NUMBER, cNumDeposito VARCHAR2) RETURN VARCHAR2 IS
cExisteDep     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExisteDep
        FROM PAGOS
       WHERE IdRecibo   > 0
         AND CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND FormPago   = 'DEP'
         AND NumDoc     = cNumDeposito;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExisteDep := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExisteDep := 'S';
   END;
   RETURN(cExisteDep);
END;

END OC_PAGOS;

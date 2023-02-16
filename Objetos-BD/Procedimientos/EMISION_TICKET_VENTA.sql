PROCEDURE EMISION_TICKET_VENTA IS
nCodCliente    TICKET_VENTA.CodCliente%TYPE;
nCodCia        TICKET_VENTA.CodCia%TYPE;
nCodEmpresa    TICKET_VENTA.CodEmpresa %TYPE;
dFecRegistro   TICKET_VENTA.FecRegistro%TYPE := TRUNC(SYSDATE - 1);
CURSOR TICKET_VENTA_Q IS
   SELECT A.CodCia, A.CodEmpresa, A.CodCliente, T.FecRegistro
     FROM TICKET_VENTA T, TICKET_POLIZA_ASEGURADO A
    WHERE TO_DATE(T.FecRegistro,'DD/MM/YYYY')   = TO_DATE(dFecRegistro,'DD/MM/YYYY')
      AND T.CodCia                              = A.CodCia
      AND T.CodEmpresa                          = A.CodEmpresa
      AND T.CodCliente                          = A.CodCliente
      AND T.CodSucursal                         = A.CodSucursal
      AND T.NumeroCelular                       = A.NumeroCelular
      AND TO_DATE(T.FechaCompra,'DD/MM/YYYY')   = TO_DATE(A.FechaCompra,'DD/MM/YYYY')
      AND TO_DATE(T.FecRegistro,'DD/MM/YYYY')   = TO_DATE(A.FechaRegistro,'DD/MM/YYYY')
      AND OC_TICKET_POLIZA.POLIZA_EMITIDA(T.CodCia, T.CodEmpresa, T.CodCliente, A.IdPoliza, TRUNC(SYSDATE)) = 'N'
    GROUP BY A.CodCia, A.CodEmpresa, A.CodCliente, T.FecRegistro;
BEGIN
   FOR W IN TICKET_VENTA_Q LOOP
      nCodCia     := W.CodCia;
      nCodEmpresa := W.CodEmpresa;
      nCodCliente := W.CodCliente;
      OC_TICKET_VENTA.GENERA_POLIZA(nCodCia, nCodEmpresa, nCodCliente, dFecRegistro);
   END LOOP;
END EMISION_TICKET_VENTA;

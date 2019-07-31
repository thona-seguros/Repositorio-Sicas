--
-- GT_FAI_PRESTAMOS_MOV  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_FONDOS_DETALLE_POLIZA (Table)
--   FAI_PRESTAMOS (Table)
--   FAI_PRESTAMOS_MOV (Table)
--   FAI_TIPOS_DE_FONDOS (Table)
--   GT_FAI_TASAS_DE_INTERES (Package)
--   OC_DETALLE_FACTURAS (Package)
--   OC_DETALLE_NOTAS_DE_CREDITO (Package)
--   OC_DETALLE_TRANSACCION (Package)
--   ASEGURADO (Table)
--   NOTAS_DE_CREDITO (Table)
--   CLIENTES (Table)
--   OC_CATALOGO_DE_CONCEPTOS (Package)
--   OC_GENERALES (Package)
--   OC_NOTAS_DE_CREDITO (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_PRESTAMOS_MOV AS

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER, nIdPro NUMBER, cIdSProc VARCHAR2, nIdTransaccion NUMBER);

PROCEDURE INSERTAR_MOV(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER, cTipoMov VARCHAR2, nMontoMovLocal NUMBER,
                       nMtoMovMoneda NUMBER, nIdFactura NUMBER, nIdNcr NUMBER, cDescMovimiento VARCHAR2, nTasaCambio NUMBER,
                       dFecTasaCambio DATE, dFecRegistro DATE, nIdTransaccion NUMBER, nIdTransacAnu NUMBER);

FUNCTION MONTO_MOVIMIENTO(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER, cTipoMov VARCHAR2) RETURN NUMBER;

FUNCTION MONTO_ABONOS(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER, cTipoAbono VARCHAR2) RETURN NUMBER;

PROCEDURE PAGOS(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER, nIdPoliza NUMBER, nNumMov NUMBER, cTipoMov VARCHAR2,
                nIdPro VARCHAR2, cIdSProc VARCHAR2, nMtoAbonoMoneda NUMBER, nMtoAbonoLocal NUMBER, dFecTasaCambio DATE,
                nTasaCambio NUMBER, nIdTransaccion NUMBER, nIdFactura NUMBER);

FUNCTION CORRESP_SALDO(cTipoMov VARCHAR2) RETURN VARCHAR2;

END GT_FAI_PRESTAMOS_MOV;
/

--
-- GT_FAI_PRESTAMOS_MOV  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_PRESTAMOS_MOV (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_PRESTAMOS_MOV AS

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER, nIdPro NUMBER, cIdSProc VARCHAR2, nIdTransaccion NUMBER) AS
nIdPoliza         FAI_PRESTAMOS.IdPoliza%TYPE;
nIDetPol          FAI_PRESTAMOS.IDetPol%TYPE;
nCodCliente       CLIENTES.CodCliente%TYPE;
nCodAsegurado     FAI_PRESTAMOS.CodAsegurado%TYPE;
cCodMoneda        FAI_PRESTAMOS.CodMoneda%TYPE;
nMontoMovLocal    FAI_PRESTAMOS.MtoPrestamoLocal%TYPE;
nMontoMovMoneda   FAI_PRESTAMOS.MtoPrestamoMoneda%TYPE;
dFecTasaCambio    FAI_PRESTAMOS.FecTasaCambio%TYPE;
nTasaCambio       FAI_PRESTAMOS.TasaCambio%TYPE;
dFecEfectiva      FAI_PRESTAMOS.FecEfectiva%TYPE;

cCalcIntPrestamos VARCHAR2(1);
nIdNcr            NOTAS_DE_CREDITO.IdNcr%TYPE;
cTipoTasa         FAI_PRESTAMOS.TipoTasa%TYPE;
nSpread           FAI_PRESTAMOS.Spread%TYPE;
cTipoFondo        FAI_TIPOS_DE_FONDOS.TipoFondo%TYPE;

--cIndIntAntic      VARCHAR2(1) := 'S';
nInteresMovLocal  FAI_PRESTAMOS.MtoPrestamoLocal%TYPE;
nInteresMovMoneda FAI_PRESTAMOS.MtoPrestamoMoneda%TYPE;
nMontoNCRLocal    FAI_PRESTAMOS.MtoPrestamoLocal%TYPE;
nMontoNCRMoneda   FAI_PRESTAMOS.MtoPrestamoMoneda%TYPE;

BEGIN
  BEGIN
    SELECT P.IdPoliza, P.IDetPol, C.CodCliente, P.CodAsegurado, P.CodMoneda,
           P.MtoPrestamoLocal, P.MtoPrestamoMoneda, P.FecTasaCambio, P.TasaCambio,
           P.FecEfectiva, P.TipoTasa, P.Spread
      INTO nIdPoliza, nIDetPol, nCodCliente, nCodAsegurado, cCodMoneda,
           nMontoMovLocal, nMontoMovMoneda, dFecTasaCambio, nTasaCambio,
           dFecEfectiva, cTipoTasa, nSpread
      FROM CLIENTES C, ASEGURADO A, FAI_PRESTAMOS P
     WHERE A.Cod_Asegurado           = P.CodAsegurado
       AND C.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
       AND C.Num_Doc_Identificacion  = A.Num_Doc_Identificacion
       AND P.CodCia                  = nCodCia
       AND P.CodEmpresa              = nCodEmpresa
       AND P.NumPrestamo             = nNumPrestamo;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20100,'Error en Datos del Préstamo '||TO_CHAR(nNumPrestamo));
  END;

  BEGIN
    SELECT DISTINCT T.CalcIntPrestamos, T.TipoFondo
      INTO cCalcIntPrestamos, cTipoFondo
      FROM FAI_TIPOS_DE_FONDOS T, FAI_FONDOS_DETALLE_POLIZA F, FAI_PRESTAMOS P
     WHERE T.IndPrestamos = 'S'
       AND T.TipoFondo    = F.TipoFondo
       AND F.IdPoliza     = P.IdPoliza
       AND P.NumPrestamo  = nNumPrestamo;
  EXCEPTION
    WHEN TOO_MANY_ROWS THEN
      cCalcIntPrestamos := 'V';
  END;

  IF cCalcIntPrestamos = 'A' THEN
     nInteresMovMoneda := NVL(nMontoMovMoneda,0) * (NVL(GT_FAI_TASAS_DE_INTERES.TASA_INTERES(cTipoTasa, cTipoFondo, dFecEfectiva),0) + NVL(nSpread,0));
     nInteresMovLocal  := NVL(nInteresMovMoneda,0) * NVL(OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda,dFecEfectiva),0);
     IF OC_CATALOGO_DE_CONCEPTOS.SIGNO_CONCEPTO(nCodCia, 'INTANT') = '-' THEN
        nMontoNCRLocal  := NVL(nInteresMovLocal,0) * -1;
        nMontoNCRMoneda := NVL(nInteresMovMoneda,0) * -1;
     END IF;
     nMontoNCRLocal  := NVL(nMontoMovLocal,0)  + NVL(nInteresMovLocal,0);
     nMontoNCRMoneda := NVL(nMontoMovMoneda,0) + NVL(nInteresMovMoneda,0);
  ELSE
     nMontoNCRLocal  := NVL(nMontoMovLocal,0);
     nMontoNCRMoneda := NVL(nMontoMovMoneda,0);
  END IF;

  nIdNcr := OC_NOTAS_DE_CREDITO.INSERTA_NOTA_CREDITO(nCodCia, nIdPoliza, nIDetPol, NULL, nCodCliente, dFecEfectiva, nMontoNCRLocal,
                                                     nMontoNCRMoneda, NULL, NULL, NULL, cCodMoneda, nTasaCambio, nIdTransaccion, NULL);
  BEGIN
    UPDATE NOTAS_DE_CREDITO
       SET NumPrestamo = nNumPrestamo
     WHERE IdNcr = nIdNcr;
  END;

  -- Capital de Préstamo
  -- Inserta Movimientos del Préstamo
  GT_FAI_PRESTAMOS_MOV.INSERTAR_MOV(nCodCia, nCodEmpresa, nNumPrestamo, 'CAPITA', nMontoMovLocal,
                                    nMontoMovMoneda, NULL /*nIdFactura*/, nIdNcr,
                                    'Capital del Préstamo No. '||TO_CHAR(nNumPrestamo), nTasaCambio, dFecTasaCambio,
                                    dFecEfectiva /*dFecRegistro*/, nIdTransaccion, NULL);

  OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, nIdPro, cIdSProc, 'FAI_PRESTAMOS',
                              nCodCia, nCodEmpresa, nNumPrestamo, nIdPoliza, nMontoMovMoneda);

  OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, 'CAPITA', 'N',nMontoMovLocal, nMontoMovMoneda);

  IF cCalcIntPrestamos = 'A' THEN
     GT_FAI_PRESTAMOS_MOV.INSERTAR_MOV(nCodCia, nCodEmpresa, nNumPrestamo, 'INTANT', nInteresMovLocal,
                                       nInteresMovMoneda, NULL, nIdNcr,
                                       'Intereses Anticipados del Préstamo No. '||TO_CHAR(nNumPrestamo), nTasaCambio, dFecTasaCambio,
                                       TRUNC(SYSDATE), nIdTransaccion, NULL);

     OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, nIdPro, cIdSProc, 'FAI_PRESTAMOS',
                                 nCodCia, nCodEmpresa, nNumPrestamo, nIdPoliza, nInteresMovMoneda);

     OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, 'INTANT', 'N', nInteresMovLocal, nInteresMovMoneda);
  END IF;
END ACTIVAR;

PROCEDURE PAGOS(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER, nIdPoliza NUMBER, nNumMov NUMBER, cTipoMov VARCHAR2,
                nIdPro VARCHAR2, cIdSProc VARCHAR2, nMtoAbonoMoneda NUMBER, nMtoAbonoLocal NUMBER, dFecTasaCambio DATE,
                nTasaCambio NUMBER, nIdTransaccion NUMBER, nIdFactura NUMBER) AS

cDescripcion      FAI_PRESTAMOS_MOV.DescMovimiento%TYPE;
cTipoMovDest      FAI_PRESTAMOS_MOV.TipoMov%TYPE;

BEGIN
  cTipoMovDest := GT_FAI_PRESTAMOS_MOV.CORRESP_SALDO(cTipoMov);
  IF cTipoMov = 'CAPITA' THEN
     cDescripcion := 'Pago a Capital del Préstamo No. ';
  ELSIF cTipoMov = 'INTANT' THEN
        cDescripcion := 'Pago a Intereses Anticipados del Préstamo No. ';
  ELSIF cTipoMov = 'INTVEN' THEN
        cDescripcion := 'Pago a Intereses Vencidos del Préstamo No. ';
  END IF;

  GT_FAI_PRESTAMOS_MOV.INSERTAR_MOV(nCodCia, nCodEmpresa, nNumPrestamo, cTipoMovDest, nMtoAbonoLocal,
                                    nMtoAbonoMoneda, nIdFactura, NULL,
                                    cDescripcion||TO_CHAR(nNumPrestamo), nTasaCambio, dFecTasaCambio,
                                    TRUNC(SYSDATE) /*dFecRegistro*/, nIdTransaccion, NULL);
  
  OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, nIdPro, cIdSProc, 'FAI_PRESTAMOS',
                              nCodCia, nCodEmpresa, nNumPrestamo, nIdPoliza, nMtoAbonoMoneda);

  OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, 'ABINVE', 'N', nMtoAbonoLocal, nMtoAbonoMoneda);
END PAGOS;

PROCEDURE INSERTAR_MOV(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER, cTipoMov VARCHAR2, nMontoMovLocal NUMBER,
                       nMtoMovMoneda NUMBER, nIdFactura NUMBER, nIdNcr NUMBER, cDescMovimiento VARCHAR2, nTasaCambio NUMBER,
                       dFecTasaCambio DATE, dFecRegistro DATE, nIdTransaccion NUMBER, nIdTransacAnu NUMBER) AS
nNumMov      FAI_PRESTAMOS_MOV.NumMov%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MAX(NumMov),0)+1
        INTO nNumMov
        FROM FAI_PRESTAMOS_MOV
       WHERE NumPrestamo = nNumPrestamo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nNumMov := 1;
   END;
   BEGIN
      INSERT INTO FAI_PRESTAMOS_MOV
            (CodCia, CodEmpresa, NumPrestamo, NumMov, TipoMov, MontoMovLocal, MontoMovMoneda, TasaCambio, FecTasaCambio,
             FecMov, FecRegistro, StsMov, FecStatus, IdFactura, IdNcr, DescMovimiento, IdTransaccion, IdTransacAnu)
      VALUES(nCodCia, nCodEmpresa, nNumPrestamo, nNumMov, cTipomov, nMontoMovLocal, nMtoMovMoneda, nTasaCambio, dFecTasaCambio,
             SYSDATE, SYSDATE, 'ACT', SYSDATE, nIdFactura, nIdNcr, cDescMovimiento, nIdTransaccion, nIdTransacAnu);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20204,'FAI_PRESTAMOS_MOV');
   END;
END INSERTAR_MOV;

FUNCTION MONTO_MOVIMIENTO(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER, cTipoMov VARCHAR2) RETURN NUMBER IS
nMontoMov     FAI_PRESTAMOS_MOV.MontoMovLocal%TYPE;
BEGIN
   -- Intereses Vencidos de Préstamos
   BEGIN
      SELECT NVL(SUM(MontoMovLocal),0)
        INTO nMontoMov
        FROM FAI_PRESTAMOS_MOV
       WHERE TipoMov     = cTipoMov
         AND StsMov      != 'ANU'
         AND CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND NumPrestamo = nNumPrestamo;
   END;
   RETURN(NVL(nMontoMov,0));
END MONTO_MOVIMIENTO;

FUNCTION MONTO_ABONOS(nCodCia NUMBER, nCodEmpresa NUMBER, nNumPrestamo NUMBER, cTipoAbono VARCHAR2) RETURN NUMBER IS
nMontoAbono   FAI_PRESTAMOS_MOV.MontoMovMoneda%TYPE;
--cTipoMovCurs  FAI_PRESTAMOS_MOV.TipoMov%TYPE;

CURSOR MOV_Q IS
   SELECT TipoMov, MontoMovMoneda
     FROM FAI_PRESTAMOS_MOV
    WHERE CodCia      = nCodCia
      AND CodEmpresa  = nCodEmpresa
      AND NumPrestamo = nNumPrestamo;
--      AND TipoMov     = cuTipoMov;
BEGIN
  FOR X IN MOV_Q LOOP
    IF cTipoAbono = 'C' AND X.TipoMov = 'ABCAPI' THEN
       nMontoAbono := NVL(nMontoAbono,0) + X.MontoMovMoneda;
    ELSIF cTipoAbono = 'I' AND X.TipoMov = 'ABINVE' THEN
          nMontoAbono := NVL(nMontoAbono,0) + X.MontoMovMoneda;
    ELSE
       nMontoAbono := NVL(nMontoAbono,0) + X.MontoMovMoneda;
    END IF;
  END LOOP;
/*
  IF cTipoMov = 'T' THEN
     cTipoMovCurs := NULL;
  ELSE
     cTipoMovCurs := GT_FAI_PRESTAMOS_MOV.CORRESP_SALDO(cTipoMov);
  FOR X IN MOV_Q(cTipoMovCurs) LOOP
    nMontoAbono := NVL(nMontoAbono,0) + X.MontoMovMoneda;
  END LOOP;*/
  RETURN(NVL(nMontoAbono,0));
END MONTO_ABONOS;

FUNCTION CORRESP_SALDO(cTipoMov VARCHAR2) RETURN VARCHAR2 IS
cTipoMovDest  VARCHAR2(10);
BEGIN
  IF cTipoMov = 'CAPITA' THEN
     cTipoMovDest := 'ABCAPI';
  ELSIF cTipoMov = 'INTANT' THEN
        cTipoMovDest := 'ABINAN';
  ELSIF cTipoMov = 'INTVEN' THEN
        cTipoMovDest := 'ABINVE';
  ELSIF cTipoMov = 'ABCAPI' THEN
        cTipoMovDest := 'CAPITA';
  ELSIF cTipoMov = 'ABINAN' THEN
        cTipoMovDest := 'INTANT';
  ELSIF cTipoMov = 'ABINVE' THEN
        cTipoMovDest := 'INTVEN';
  END IF;
  RETURN(NVL(cTipoMovDest,0));
END CORRESP_SALDO;

END GT_FAI_PRESTAMOS_MOV;
/

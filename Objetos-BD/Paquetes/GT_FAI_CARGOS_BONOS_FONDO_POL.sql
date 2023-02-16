CREATE OR REPLACE PACKAGE GT_FAI_CARGOS_BONOS_FONDO_POL AS

PROCEDURE APLICAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                  nIDetPol NUMBER, nCodAsegurado NUMBER, nIdCargoBono NUMBER);

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                 nIDetPol NUMBER, nCodAsegurado NUMBER, nIdCargoBono NUMBER,
                 cCodMotvAnul VARCHAR2, dFecAnulacion DATE, cDescAnulacion VARCHAR2);

PROCEDURE REVERTIR_ANULACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                             nIDetPol NUMBER, nCodAsegurado NUMBER, nIdCargoBono NUMBER);

PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                   nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoCargoBono VARCHAR2,
                   cCodCargoBono VARCHAR2, nIdTransaccion NUMBER, 
                   dFecMovimiento DATE, nMontoMov NUMBER, cDescMovimiento VARCHAR2);

FUNCTION POSEE_MOV_PENDIENTES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                              nIDetPol NUMBER) RETURN VARCHAR2;

FUNCTION SALDO_MOV_PENDIENTES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                              nIDetPol NUMBER, cTipoCargoBono VARCHAR2) RETURN NUMBER;

FUNCTION EXISTE_BONO_CARGO_FONDO_POL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                     nIDetPol NUMBER, cCptoMovFondo VARCHAR2,
                                     dFecCargoBono DATE) RETURN VARCHAR2;

END GT_FAI_CARGOS_BONOS_FONDO_POL;
/

CREATE OR REPLACE PACKAGE BODY GT_FAI_CARGOS_BONOS_FONDO_POL AS

PROCEDURE APLICAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                  nIDetPol NUMBER, nCodAsegurado NUMBER, nIdCargoBono NUMBER) IS
nIdMovimiento         FAI_CONCENTRADORA_FONDO.IdMovimiento%TYPE;
nMontoCargoBono       FAI_CARGOS_BONOS_FONDO_POL.MontoCargoBono%TYPE;
nMontoCargoBonoLocal  FAI_CARGOS_BONOS_FONDO_POL.MontoCargoBono%TYPE;
nIdTransaccion        TRANSACCION.IdTransaccion%TYPE;
cCodMoneda            FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
nTasaCambioMov        TASAS_CAMBIO.Tasa_Cambio%TYPE;

-- Cursor para Leer Fondos por Orden de Aplicación
-- Solamente se lee el primero
CURSOR MOV_Q IS
   SELECT C.CodCargoBono, C.MontoCargoBono, C.DescMovimiento, F.IdFondo, F.TipoFondo
     FROM FAI_CARGOS_BONOS_FONDO_POL C, FAI_FONDOS_DETALLE_POLIZA F
    WHERE F.CodAsegurado = nCodAsegurado
      AND F.IDetPol      = C.IDetPol
      AND F.IdPoliza     = C.IdPoliza
      AND F.CodEmpresa   = C.CodEmpresa
      AND F.CodCia       = C.CodCia
      AND C.IdCargoBono  = nIdCargoBono
      AND C.IDetPol      = nIDetPol
      AND C.IdPoliza     = nIdPoliza
      AND C.CodEmpresa   = nCodEmpresa
      AND C.CodCia       = nCodCia
      AND RowNum         = 1
    ORDER BY F.IdFondo;
BEGIN
   FOR W IN MOV_Q LOOP
      cCodMoneda             := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, W.TipoFondo);
      nMontoCargoBono        := W.MontoCargoBono;
      nTasaCambioMov         := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));
      nMontoCargoBonoLocal   := W.MontoCargoBono * nTasaCambioMov;
      nIdTransaccion         := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');

      OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia,  nCodEmpresa, 21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                  nIdPoliza, nIDetPol, W.IdFondo, W.CodCargoBono, nMontoCargoBono);

      GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado,
                                                           W.IdFondo, W.CodCargoBono, nIdTransaccion, cCodMoneda,
                                                           nMontoCargoBono, nMontoCargoBonoLocal, 'D', nTasaCambioMov,
                                                           TRUNC(SYSDATE), TRUNC(SYSDATE), W.DescMovimiento);

      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');

      BEGIN
         UPDATE FAI_CARGOS_BONOS_FONDO_POL
            SET IdTransaccionEfec = nIdTransaccion,
                FecEfectiva       = TRUNC(SYSDATE),
                StsCargoBono      = 'APLICA',
                FecStatus         = TRUNC(SYSDATE)
          WHERE IdCargoBono  = nIdCargoBono
            AND IDetPol      = nIDetPol
            AND IdPoliza     = nIdPoliza
            AND CodEmpresa   = nCodEmpresa
            AND CodCia       = nCodCia;
      END;
   END LOOP;
END APLICAR;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                 nIDetPol NUMBER, nCodAsegurado NUMBER, nIdCargoBono NUMBER,
                 cCodMotvAnul VARCHAR2, dFecAnulacion DATE, cDescAnulacion VARCHAR2) IS
BEGIN
   BEGIN
      UPDATE FAI_CARGOS_BONOS_FONDO_POL
         SET CodMotvAnul     = cCodMotvAnul,
             FecAnulacion    = dFecAnulacion,
             DescAnulacion   = cDescAnulacion,
             StsCargoBono    = 'ANULAD',
             FecStatus       = TRUNC(SYSDATE)
       WHERE IdCargoBono  = nIdCargoBono
         AND IDetPol      = nIDetPol
         AND IdPoliza     = nIdPoliza
         AND CodEmpresa   = nCodEmpresa
         AND CodCia       = nCodCia;
   END;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20200,'Error al Anular Cargo/Bono de la Póliza: ' || TO_CHAR(nIdPoliza) ||
                              ' Movimiento No.: '||TO_CHAR(nIdCargoBono));
END ANULAR;

PROCEDURE REVERTIR_ANULACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                             nIDetPol NUMBER, nCodAsegurado NUMBER, nIdCargoBono NUMBER) IS
BEGIN
   BEGIN
      UPDATE FAI_CARGOS_BONOS_FONDO_POL
         SET CodMotvAnul     = NULL,
             FecAnulacion    = NULL,
             DescAnulacion   = NULL,
             StsCargoBono    = 'ACTIVO',
             FecStatus       = TRUNC(SYSDATE)
       WHERE IdCargoBono  = nIdCargoBono
         AND IDetPol      = nIDetPol
         AND IdPoliza     = nIdPoliza
         AND CodEmpresa   = nCodEmpresa
         AND CodCia       = nCodCia;
   END;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20200,'Error al Revertir Anulación del Cargo/Bono de la Póliza: ' || TO_CHAR(nIdPoliza) ||
                              ' Movimiento No.: ' || TO_CHAR(nIdCargoBono));
END REVERTIR_ANULACION;

PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                   nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoCargoBono VARCHAR2,
                   cCodCargoBono VARCHAR2, nIdTransaccion NUMBER, 
                   dFecMovimiento DATE, nMontoMov NUMBER, cDescMovimiento VARCHAR2) IS
nIdCargoBono    FAI_CARGOS_BONOS_FONDO_POL.IdCargoBono%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MAX(IdCargoBono),0)+1
        INTO nIdCargoBono
        FROM FAI_CARGOS_BONOS_FONDO_POL
       WHERE IDetPol      = nIDetPol
         AND IdPoliza     = nIdPoliza
         AND CodEmpresa   = nCodEmpresa
         AND CodCia       = nCodCia;
   END;
   INSERT INTO FAI_CARGOS_BONOS_FONDO_POL
         (CodCia, CodEmpresa, IdPoliza, IDetPol, IdCargoBono,
          IdTransaccionOrig, TipoCargoBono, CodCargoBono,
          FecCargoBono, MontoCargoBono, DescMovimiento,
          FecEfectiva, IdTransaccionEfec, StsCargoBono,
          FecStatus, CodMotvAnul, FecAnulacion, DescAnulacion)
   VALUES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nIdCargoBono,
          nIdTransaccion, cTipoCargoBono, cCodCargoBono,
          dFecMovimiento, DECODE(cTipoCargoBono,'C',nMontoMov*-1,nMontoMov),
          cDescMovimiento, NULL, NULL, 'ACTIVO', 
          TRUNC(SYSDATE), NULL, NULL, NULL);
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20200,'Ya Existe Movimiento de Cargo o Bono ' || cCodCargoBono || ' en la Póliza No. ' || nIdPoliza);
END INSERTAR;

FUNCTION POSEE_MOV_PENDIENTES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                              nIDetPol NUMBER) RETURN VARCHAR2 IS
cExiste    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM FAI_CARGOS_BONOS_FONDO_POL
       WHERE StsCargoBono   = 'ACTIVO'
         AND IDetPol        = nIDetPol
         AND IdPoliza       = nIdPoliza
         AND CodEmpresa     = nCodEmpresa
         AND CodCia         = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END POSEE_MOV_PENDIENTES;

FUNCTION SALDO_MOV_PENDIENTES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                              nIDetPol NUMBER, cTipoCargoBono VARCHAR2) RETURN NUMBER IS
nSaldoCargosBonos        FAI_CARGOS_BONOS_FONDO_POL.MontoCargoBono%TYPE;
BEGIN
   IF cTipoCargoBono != 'T' THEN
      SELECT NVL(SUM(MontoCargoBono),0)
        INTO nSaldoCargosBonos
        FROM FAI_CARGOS_BONOS_FONDO_POL
       WHERE StsCargoBono   = 'ACTIVO'
         AND IDetPol        = nIDetPol
         AND IdPoliza       = nIdPoliza
         AND CodEmpresa     = nCodEmpresa
         AND CodCia         = nCodCia
         AND TipoCargoBono  = cTipoCargoBono;
   ELSE
      SELECT NVL(SUM(DECODE(TipoCargoBono,'B',MontoCargoBono,-MontoCargoBono)),0)
        INTO nSaldoCargosBonos
        FROM FAI_CARGOS_BONOS_FONDO_POL
       WHERE StsCargoBono   = 'ACTIVO'
         AND IDetPol        = nIDetPol
         AND IdPoliza       = nIdPoliza
         AND CodEmpresa     = nCodEmpresa
         AND CodCia         = nCodCia;
   END IF;
   RETURN(nSaldoCargosBonos);
END SALDO_MOV_PENDIENTES;

FUNCTION EXISTE_BONO_CARGO_FONDO_POL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                     nIDetPol NUMBER, cCptoMovFondo VARCHAR2,
                                     dFecCargoBono DATE) RETURN VARCHAR2 IS
cExiste    VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM FAI_CARGOS_BONOS_FONDO_POL
       WHERE FecCargoBono   = dFecCargoBono
         AND CodCargoBono   = cCptoMovFondo
         AND IDetPol        = nIDetPol
         AND IdPoliza       = nIdPoliza
         AND CodEmpresa     = nCodEmpresa
         AND CodCia         = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'N';
   END;
   RETURN(cExiste);
END EXISTE_BONO_CARGO_FONDO_POL;

END GT_FAI_CARGOS_BONOS_FONDO_POL;

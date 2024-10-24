--
-- GT_REA_DISTRIBUCION_PAGO_FACUL  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   REA_DISTRIBUCION_PAGO_FACUL (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_REA_DISTRIBUCION_PAGO_FACUL IS
  PROCEDURE PAGO_PENDIENTE(nCodCia NUMBER, nIdDistribRea NUMBER, nNumDistrib NUMBER,
                         cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2, nNumPagoFacult NUMBER);
  PROCEDURE ANULAR_PAGO(nCodCia NUMBER, nIdDistribRea NUMBER, nNumDistrib NUMBER,
                        cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2, nNumPagoFacult NUMBER);
  PROCEDURE PAGO_FACULTATIVO(nCodCia NUMBER, nIdDistribRea NUMBER, nNumDistrib NUMBER,
                             cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2, nNumPagoFacult NUMBER);
END GT_REA_DISTRIBUCION_PAGO_FACUL;
/

--
-- GT_REA_DISTRIBUCION_PAGO_FACUL  (Package Body) 
--
--  Dependencies: 
--   GT_REA_DISTRIBUCION_PAGO_FACUL (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_REA_DISTRIBUCION_PAGO_FACUL IS

PROCEDURE PAGO_PENDIENTE(nCodCia NUMBER, nIdDistribRea NUMBER, nNumDistrib NUMBER,
                       cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2, nNumPagoFacult NUMBER) IS
BEGIN
   UPDATE REA_DISTRIBUCION_PAGO_FACUL
      SET StsPagoFacult    = 'PENPAG',
          FecStatus        = TRUNC(SYSDATE),
          FecAnulPago      = NULL
    WHERE CodCia           = nCodCia
      AND IdDistribRea     = nIdDistribRea
      AND NumDistrib       = nNumDistrib
      AND CodEmpresaGremio = cCodEmpresaGremio
      AND CodInterReaseg   = cCodInterReaseg
      AND NumPagoFacult    = nNumPagoFacult;
END PAGO_PENDIENTE;

PROCEDURE ANULAR_PAGO(nCodCia NUMBER, nIdDistribRea NUMBER, nNumDistrib NUMBER,
                      cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2, nNumPagoFacult NUMBER) IS
BEGIN
   UPDATE REA_DISTRIBUCION_PAGO_FACUL
      SET StsPagoFacult    = 'ANULAD',
          FecStatus        = TRUNC(SYSDATE),
          FecAnulPago      = TRUNC(SYSDATE)
    WHERE CodCia           = nCodCia
      AND IdDistribRea     = nIdDistribRea
      AND NumDistrib       = nNumDistrib
      AND CodEmpresaGremio = cCodEmpresaGremio
      AND CodInterReaseg   = cCodInterReaseg
      AND NumPagoFacult    = nNumPagoFacult;
END ANULAR_PAGO;

PROCEDURE PAGO_FACULTATIVO(nCodCia NUMBER, nIdDistribRea NUMBER, nNumDistrib NUMBER,
                           cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2, nNumPagoFacult NUMBER) IS
BEGIN
   NULL;
END PAGO_FACULTATIVO;

END GT_REA_DISTRIBUCION_PAGO_FACUL;
/

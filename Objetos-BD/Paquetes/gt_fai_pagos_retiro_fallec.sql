--
-- GT_FAI_PAGOS_RETIRO_FALLEC  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   NOTAS_DE_CREDITO (Table)
--   POLIZAS (Table)
--   FAI_ESQUEMA_COMIS_FONDO (Table)
--   FAI_FONDOS_DETALLE_POLIZA (Table)
--   FAI_PAGOS_RETIRO_FALLEC (Table)
--   FAI_PLAN_PAGO_RETIRO_FALLEC (Table)
--   FAI_PLAN_RETIRO_FALLEC (Table)
--   OC_DETALLE_TRANSACCION (Package)
--   GT_FAI_CONCENTRADORA_FONDO (Package)
--   GT_FAI_TIPOS_DE_FONDOS (Package)
--   OC_TRANSACCION (Package)
--   AGENTE_POLIZA (Table)
--   ASEGURADO (Table)
--   OC_DETALLE_NOTAS_DE_CREDITO (Package)
--   TASAS_CAMBIO (Table)
--   OC_GENERALES (Package)
--   OC_NOTAS_DE_CREDITO (Package)
--   OC_PLAN_DE_PAGOS (Package)
--   TRANSACCION (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_PAGOS_RETIRO_FALLEC AS

PROCEDURE GENERAR_PAGOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, 
                        cCodPlanRet VARCHAR2, cTipoPlan VARCHAR2);

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, 
                 cCodPlanRet VARCHAR2, cTipoPlan VARCHAR2, dFecAnulacion DATE);

PROCEDURE PAGAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, 
                cCodPlanRet VARCHAR2, cTipoPlan VARCHAR2, nNumPago NUMBER);
                
FUNCTION EXISTE_PAGO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, 
                        cCodPlanRet VARCHAR2, cTipoPlan VARCHAR2) RETURN NUMBER;             
                
END GT_FAI_PAGOS_RETIRO_FALLEC;
/

--
-- GT_FAI_PAGOS_RETIRO_FALLEC  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_PAGOS_RETIRO_FALLEC (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_PAGOS_RETIRO_FALLEC AS

PROCEDURE GENERAR_PAGOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, cCodPlanRet VARCHAR2, cTipoPlan VARCHAR2) IS

dFecPago        FAI_PAGOS_RETIRO_FALLEC.FecPago%TYPE;
nMontoPago      FAI_PAGOS_RETIRO_FALLEC.MontoPagoLocal%TYPE;
nMontoRet       FAI_PAGOS_RETIRO_FALLEC.MontoRetLocal%TYPE;

CURSOR PLAN_Q IS
   SELECT FP.IdPoliza, FP.IDetPol, FP.CodAsegurado, FP.TipoFondo, 
          PR.CantPagos, PR.PorcPagos, PR.PorcFondo, PR.IndAplicaRet,
          PR.PorcRetencion, PR.CodPlanPago
     FROM FAI_PLAN_PAGO_RETIRO_FALLEC PP, FAI_FONDOS_DETALLE_POLIZA FP, FAI_PLAN_RETIRO_FALLEC PR
    WHERE PP.CodCia     = PR.CodCia
      AND PP.CodEmpresa = PR.CodEmpresa
      AND PR.TipoPlan   = PR.TipoPlan
      AND PR.CodPlanRet = PP.CodPlanRet
      AND PR.Tipofondo  = FP.TipoFondo
      AND FP.CodCia     = PP.CodCia
      AND FP.CodEmpresa = PP.CodEmpresa
      AND FP.IdFondo    = PP.IdFondo
      AND PP.CodCia     = nCodCia
      AND PP.CodEmpresa = nCodEmpresa
      AND PP.IdFondo    = nIdFondo
      AND PP.CodPlanRet = cCodPlanRet
      AND PP.TipoPlan   = cTipoPlan;
BEGIN
   FOR W IN PLAN_Q LOOP
      nMontoPago := (GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, W.IdPoliza, W.IDetPol, W.CodAsegurado, 
                                                                    nIdFondo, TRUNC(SYSDATE)) * (W.PorcFondo / 100)) * (W.PorcPagos / 100);
      IF W.IndAplicaRet = 'S' THEN
         nMontoRet := NVL(nMontoPago,0) * (W.PorcRetencion / 100);
      ELSE
         nMontoRet := 0;
      END IF;
      FOR Y IN 1..W.CantPagos LOOP
         IF Y = 1 THEN
            dFecPago := TRUNC(SYSDATE);
         ELSE
            dFecPago := ADD_MONTHS(dFecPago,OC_PLAN_DE_PAGOS.FRECUENCIA_PAGOS(nCodCia, nCodEmpresa, W.CodPlanPago));
         END IF;
         INSERT INTO FAI_PAGOS_RETIRO_FALLEC
                (CodCia, CodEmpresa, IdPoliza, IDetPol, CodAsegurado, IdFondo, 
                 CodPlanRet, TipoPlan, NumPago, FecPago, MontoPagoLocal, 
                 IndAplicaRet, PorcRetencion, MontoRetLocal, StsPago, FecStatus, 
                 IdNcr)
         VALUES (nCodCia, nCodEmpresa, W.IdPoliza, W.IDetPol, W.CodAsegurado, nIdFondo, 
                 cCodPlanRet, cTipoPlan, Y, dFecPago, NVL(nMontoPago,0), 
                 W.IndAplicaRet, W.PorcRetencion, NVL(nMontoRet,0), 'ACTIVO', TRUNC(SYSDATE), 
                 NULL);
      END LOOP;
   END LOOP;
END GENERAR_PAGOS;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, cCodPlanRet VARCHAR2, cTipoPlan VARCHAR2, dFecAnulacion DATE) IS
CURSOR DET_Q IS
   SELECT NumPago
     FROM FAI_PAGOS_RETIRO_FALLEC
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdFondo    = nIdFondo
      AND CodPlanRet = cCodPlanRet
      AND TipoPlan   = cTipoPlan;
BEGIN
   FOR X IN DET_Q LOOP
      BEGIN
         UPDATE FAI_PAGOS_RETIRO_FALLEC
            SET StsPago    = 'ANULAD',
                FecStatus  = dFecAnulacion
          WHERE CodCia     = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND IdFondo    = nIdFondo
            AND CodPlanRet = cCodPlanRet
            AND TipoPlan   = cTipoPlan
            AND NumPago    = X.NumPago;
      END;
   END LOOP;
END ANULAR;

PROCEDURE PAGAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER,
                cCodPlanRet VARCHAR2, cTipoPlan VARCHAR2, nNumPago NUMBER) IS
cCod_Agente         FAI_ESQUEMA_COMIS_FONDO.Cod_Agente%TYPE;
nIdNcr              NOTAS_DE_CREDITO.IdNcr%TYPE;
nMontoPagoLocal     FAI_PAGOS_RETIRO_FALLEC.MontoPagoLocal%TYPE;
nTasaCambio         TASAS_CAMBIO.Tasa_Cambio%TYPE;
nIdTransaccion      TRANSACCION.IdTransaccion%TYPE;

CURSOR DET_Q IS
   SELECT (D.MontoPagoMoneda - D.MontoRetMoneda) MontoPagoNeto, FP.TipoFondo, 
           GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(FP.CodCia, FP.CodEmpresa, FP.Tipofondo) CodMoneda,
          A.Tipo_Doc_Identificacion, A.Num_Doc_Identificacion, P.IdPoliza, FP.IDetPol,
          P.CodCliente
     FROM FAI_PAGOS_RETIRO_FALLEC D, FAI_FONDOS_DETALLE_POLIZA FP, ASEGURADO A, POLIZAS P
    WHERE P.CodCia      = FP.CodCia
      AND P.IdPoliza    = FP.IdPoliza
      AND A.Cod_Asegurado    = FP.CodAsegurado
      AND FP.CodCia     = D.CodCia
      AND FP.CodEmpresa = D.CodEmpresa
      AND FP.IdFondo    = D.IdFondo
      AND D.CodCia      = nCodCia
      AND D.CodEmpresa  = nCodEmpresa
      AND D.IdFondo     = nIdFondo
      AND D.CodPlanRet  = cCodPlanRet
      AND D.TipoPlan    = cTipoPlan
      AND D.NumPago     = nNumPago;
BEGIN
-- Busca Intermediario Líder
   BEGIN
      SELECT DISTINCT Cod_Agente
        INTO cCod_Agente
        FROM FAI_ESQUEMA_COMIS_FONDO
       WHERE IndPrincipal  = 'S'
         AND CodCia         = nCodCia
         AND CodEmpresa     = nCodEmpresa
         AND IdFondo        = nIdFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         BEGIN
            SELECT Cod_Agente
              INTO cCod_Agente
              FROM AGENTE_POLIZA A, FAI_FONDOS_DETALLE_POLIZA F
             WHERE A.CodCia       = F.CodCia
               AND A.IdPoliza     = F.IdPoliza
               AND A.Ind_Principal  = 'S'
               AND F.CodCia         = nCodCia
               AND F.CodEmpresa     = nCodEmpresa
               AND F.IdFondo        = nIdFondo;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20200,'No Existe Agente Principal - PAGAR FAI_PAGOS_RETIRO_FALLEC');
            WHEN TOO_MANY_ROWS THEN
               RAISE_APPLICATION_ERROR(-20200,'Existe más de un Agente Principal - PAGAR FAI_PAGOS_RETIRO_FALLEC');
         END;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20100,'Existe más de un Agente Principal - PAGAR FAI_PAGOS_RETIRO_FALLEC');
   END;

   FOR X IN DET_Q LOOP
      nTasaCambio     := OC_GENERALES.TASA_DE_CAMBIO(X.CodMoneda, 
                                                     TRUNC(SYSDATE)--OC_FECHA_CONTABLE_EQUIVALENTE.FECHA_CONTABLE(nCodCia, nCodEmpresa, TRUNC(SYSDATE))
                                                     );
      nMontoPagoLocal := X.MontoPagoNeto * nTasaCambio;
      nIdTransaccion  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'FONDOS');

      nIdNcr          := OC_NOTAS_DE_CREDITO.INSERTA_NOTA_CREDITO(nCodCia, X.IdPoliza, X.IDetPol, 0, X.CodCliente,
                                                                   TRUNC(SYSDATE),--OC_FECHA_CONTABLE_EQUIVALENTE.FECHA_CONTABLE(nCodCia, nCodEmpresa, TRUNC(SYSDATE)),
                                                                  nMontoPagoLocal, X.MontoPagoNeto, 0, 0, cCod_Agente, X.CodMoneda, 
                                                                  nTasaCambio, nIdTransaccion, 'S');

      -- Crear Detalle de NC
      OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, 'RETIRO', 'S', nMontoPagoLocal, X.MontoPagoNeto);
      OC_DETALLE_NOTAS_DE_CREDITO.AJUSTAR(nCodCia, nIdNcr, 'RETIRO', 'S', nMontoPagoLocal, X.MontoPagoNeto);

      OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 21, 'PAGRFA', 'FAI_PAGOS_RETIRO_FALLEC',
                                  X.IdPoliza, X.IDetPol, nIdFondo, nIdNcr, X.MontoPagoNeto);

      OC_NOTAS_DE_CREDITO.EMITIR(nIdNcr, NULL);

      OC_NOTAS_DE_CREDITO.PAGAR(nCodCia, nIdNcr, TRUNC(SYSDATE));--OC_FECHA_CONTABLE_EQUIVALENTE.FECHA_CONTABLE(nCodCia, nCodEmpresa, TRUNC(SYSDATE)));

      BEGIN
         UPDATE FAI_PAGOS_RETIRO_FALLEC
            SET StsPago    = 'PAGADO',
                FecStatus  = TRUNC(SYSDATE),
                IdNcr      = nIdNcr
          WHERE CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa
            AND IdFondo       = nIdFondo
            AND CodPlanRet    = cCodPlanRet
            AND TipoPlan      = cTipoPlan
            AND NumPago       = nNumPago;
      END;
   END LOOP;
END PAGAR;

FUNCTION EXISTE_PAGO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, 
                        cCodPlanRet VARCHAR2, cTipoPlan VARCHAR2) RETURN NUMBER IS
    nCuentaPago NUMBER;
BEGIN
    BEGIN
        SELECT NVL(COUNT(NUMPAGO),0)
          INTO nCuentaPago
          FROM FAI_PAGOS_RETIRO_FALLEC
         WHERE CodCia     = nCodCia 
           AND CodEmpresa = nCodEmpresa 
           AND IdFondo    = nIdFondo
           AND CodPlanRet = cCodPlanRet 
           AND TipoPlan   = cTipoPlan
           AND IdNcr      IS NOT NULL;
    END;
    RETURN nCuentaPago;
END EXISTE_PAGO; 

END GT_FAI_PAGOS_RETIRO_FALLEC;
/

--
-- GT_FAI_PAGOS_RETIRO_FALLEC  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_PAGOS_RETIRO_FALLEC (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_PAGOS_RETIRO_FALLEC FOR SICAS_OC.GT_FAI_PAGOS_RETIRO_FALLEC
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_FAI_PAGOS_RETIRO_FALLEC TO PUBLIC
/

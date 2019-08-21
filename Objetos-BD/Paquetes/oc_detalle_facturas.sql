--
-- OC_DETALLE_FACTURAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FACTURAS (Table)
--   DETALLE_FACTURAS (Table)
--   DETALLE_NOTAS_DE_CREDITO (Table)
--   NOTAS_DE_CREDITO (Table)
--   TRANSACCION (Table)
--   CATALOGO_DE_CONCEPTOS (Table)
--   PAGO_DETALLE (Table)
--   OC_CATALOGO_DE_CONCEPTOS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_DETALLE_FACTURAS IS

PROCEDURE PAGO_ABONO_DETALLE(nIdFactura NUMBER, nPagoM NUMBER, nPagoL NUMBER,nIdRecibo NUMBER);

PROCEDURE INSERTAR(nIdFactura NUMBER, cCodCpto VARCHAR2, cIndCptoPrima VARCHAR2, nMtoPagoLocal NUMBER, nMtoPagoMoneda NUMBER);

PROCEDURE ACTUALIZA_DIFERENCIA(nIdFactura NUMBER, nMtoDifLocal NUMBER, nMtoDifMoneda NUMBER);

FUNCTION MONTO_PRIMAS(nIdTransaccion NUMBER) RETURN NUMBER;

FUNCTION MONTO_CONCEPTO(nIdTransaccion NUMBER, cCodCpto VARCHAR2) RETURN NUMBER;

FUNCTION MONTO_PRIMAS_MOROSA(nIdTransaccion NUMBER, dFecMorosidad DATE,
                             nRangoIni NUMBER, nRangoFin NUMBER) RETURN NUMBER;

FUNCTION MONTO_CONCEPTO_MOROSO(nIdTransaccion NUMBER, cCodCpto VARCHAR2, dFecMorosidad DATE,
                               nRangoIni NUMBER, nRangoFin NUMBER) RETURN NUMBER;

PROCEDURE AJUSTAR(nCodCia NUMBER, nIdFactura NUMBER, cCodCpto VARCHAR2,
                  cIndCptoPrima VARCHAR2, nMtoPagoLocal NUMBER, nMtoPagoMoneda NUMBER);

PROCEDURE INSERTAR_DETALLE_PAGO(nIdRecibo NUMBER,nIdFactura NUMBER, cCodCpto VARCHAR2, nMtoPagoMoneda NUMBER);

PROCEDURE PAGAR_SERVICIOS(nCodCia NUMBER, cCodCpto VARCHAR2, dFecDesde DATE, dFecHasta DATE,
                          dFecPago DATE, nCodProveedor NUMBER);
FUNCTION MONTO_SERVICIOS(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER;

FUNCTION EXISTE_CONCEPTO(nCodCia NUMBER, nIdPoliza NUMBER, nIdTransaccion NUMBER, cCodCpto VARCHAR2) RETURN VARCHAR2;

PROCEDURE REVERTIR_PAGO(nIdRecibo NUMBER, nIdFactura NUMBER);

FUNCTION MONTO_NETO_CONCEPTO(nCodCia NUMBER, nIdPoliza NUMBER, cCodCpto VARCHAR2) RETURN NUMBER;

FUNCTION MONTO_PAGADO_CONCEPTO(nCodCia NUMBER, nIdPoliza NUMBER, cCodCpto VARCHAR2 DEFAULT NULL) RETURN NUMBER;

PROCEDURE GENERA_IMPUESTO_FACT_ELECT(nCodCia NUMBER, nIdFactura NUMBER, cCodCptoImpto VARCHAR2);

FUNCTION MONTO_IMPUESTO_FACT_ELECT(nIdFactura NUMBER, cCodCpto VARCHAR2) RETURN NUMBER;

FUNCTION MONTO_CONCEPTO_FACT_ELECT(nIdFactura NUMBER, cCodCpto VARCHAR2) RETURN NUMBER;

END OC_DETALLE_FACTURAS;
/

--
-- OC_DETALLE_FACTURAS  (Package Body) 
--
--  Dependencies: 
--   OC_DETALLE_FACTURAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_DETALLE_FACTURAS IS

PROCEDURE PAGO_ABONO_DETALLE(nIdFactura NUMBER, nPagoM NUMBER, nPagoL NUMBER,nIdRecibo NUMBER) IS

nPagoMoneda          DETALLE_FACTURAS.Saldo_Det_Local%TYPE;
nPagoLocal           DETALLE_FACTURAS.Saldo_Det_Local%TYPE;
cCodCpto             DETALLE_FACTURAS.CodCpto%TYPE;
cIndContabRedondeo   CATALOGO_DE_CONCEPTOS.IndContabRedondeo%TYPE;
cCodCptoDeudor       CATALOGO_DE_CONCEPTOS.CodCptoDeudor%TYPE;
cCodCptoAcreedor     CATALOGO_DE_CONCEPTOS.CodCptoAcreedor%TYPE;
CURSOR C_DET_FACT IS
   SELECT CodCpto, Saldo_Det_Moneda, Saldo_Det_Local
     FROM DETALLE_FACTURAS D
    WHERE IdFactura         = nIdFactura
      AND Saldo_Det_Moneda != 0
   UNION
   SELECT CodCpto, Saldo_Det_Moneda, Saldo_Det_Local
     FROM DETALLE_FACTURAS
    WHERE IdFactura         = nIdFactura
      AND Saldo_Det_Moneda != 0
    ORDER BY CodCpto;
BEGIN
   nPagoMoneda := nPagoM;
   nPagoLocal  := nPagoL;
   FOR I IN C_DET_FACT LOOP
      IF I.CodCpto IN ('AJIVAA','AJIVAD')    THEN
         IF   I.CodCpto = 'AJIVAA' THEN
            cCodCpto := 'AJURDD';
         ELSE
            cCodCpto := 'AJURDA';
         END IF;
         OC_DETALLE_FACTURAS.INSERTAR_DETALLE_PAGO(nIdRecibo, nIdFactura, cCodCpto, I.Saldo_Det_Moneda);
         OC_DETALLE_FACTURAS.INSERTAR_DETALLE_PAGO(nIdRecibo, nIdFactura, I.CodCpto, I.Saldo_Det_Moneda);
         UPDATE DETALLE_FACTURAS
            SET Saldo_Det_Moneda = 0,
                Saldo_Det_Local  = 0
          WHERE IdFactura = nIdFactura
            AND CodCpto   = I.CodCpto;
      ELSE
         IF nPagoMoneda >= I.Saldo_Det_Moneda THEN
            OC_DETALLE_FACTURAS.INSERTAR_DETALLE_PAGO (nIdRecibo, nIdFactura, I.CodCpto, I.Saldo_Det_Moneda);
/*         INSERT INTO PAGO_DETALLE(IdRecibo,IdFactura,CodCpto,Monto)
                VALUES (nIdRecibo,nIdFactura,I.CodCpto,I.Saldo_Det_Local);*/
            nPagoMoneda := nPagoMoneda - I.Saldo_Det_Moneda;
            nPagoLocal  := nPagoLocal - I.Saldo_Det_Local;

            UPDATE DETALLE_FACTURAS
               SET Saldo_Det_Moneda = 0,
                   Saldo_Det_Local  = 0
             WHERE IdFactura = nIdFactura
               AND CodCpto   = I.CodCpto;
         ELSE
            OC_DETALLE_FACTURAS.INSERTAR_DETALLE_PAGO(nIdRecibo, nIdFactura, I.CodCpto, nPagoMoneda);
/*         INSERT INTO PAGO_DETALLE(IdRecibo,IdFactura,CodCpto,Monto)
                VALUES (nIdRecibo,nIdFactura,I.CodCpto,nPagoLocal);*/
            UPDATE DETALLE_FACTURAS
               SET Saldo_Det_Moneda = I.Saldo_Det_Moneda - nPagoMoneda,
                   Saldo_Det_Local  = I.Saldo_Det_Local - nPagoLocal
             WHERE IdFactura = nIdFactura
               AND CodCpto   = I.CodCpto;
            nPagoMoneda := 0;
            EXIT;
         END IF;
      END IF;
   END LOOP;
END PAGO_ABONO_DETALLE;

PROCEDURE INSERTAR(nIdFactura NUMBER, cCodCpto VARCHAR2, cIndCptoPrima VARCHAR2,
                   nMtoPagoLocal NUMBER, nMtoPagoMoneda NUMBER) IS
    nCodCia FACTURAS.CodCia%TYPE;
BEGIN
   BEGIN
      INSERT INTO DETALLE_FACTURAS
             (IdFactura, CodCpto, Monto_Det_Local, Monto_Det_Moneda,
              Saldo_Det_Local, Saldo_Det_Moneda, IndCptoPrima,
              MtoOrigDetLocal, MtoOrigDetMoneda)
      VALUES (nIdFactura, cCodCpto, nMtoPagoLocal, nMtoPagoMoneda,
              nMtoPagoLocal, nMtoPagoMoneda, cIndCptoPrima,
              nMtoPagoLocal, nMtoPagoMoneda);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         UPDATE DETALLE_FACTURAS
            SET Monto_Det_Local  = Monto_Det_Local + nMtoPagoLocal,
                Monto_Det_Moneda = Monto_Det_Moneda + nMtoPagoMoneda,
                Saldo_Det_Local  = Saldo_Det_Local + nMtoPagoLocal,
                Saldo_Det_Moneda = Saldo_Det_Moneda + nMtoPagoMoneda,
                MtoOrigDetLocal  = MtoOrigDetLocal + nMtoPagoLocal,
                MtoOrigDetMoneda = MtoOrigDetMoneda + nMtoPagoMoneda
          WHERE IdFactura = nIdFactura
            AND CodCpto   = cCodCpto;
   END;
   BEGIN
       SELECT CodCia
         INTO nCodCia
         FROM FACTURAS
        WHERE IdFactura = nIdFactura;
   END;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR (-20100,'Error al Insertar el Detalle de Factura '||cCodCpto|| ' ' || SQLERRM);
END INSERTAR;

PROCEDURE ACTUALIZA_DIFERENCIA(nIdFactura NUMBER, nMtoDifLocal NUMBER, nMtoDifMoneda NUMBER) IS
    nTasaIVA            CATALOGO_DE_CONCEPTOS.PorcConcepto %TYPE;
    nMtoIVA             DETALLE_FACTURAS.Monto_Det_Local%TYPE := 0;
    cExisteIVA          VARCHAR2(1);
    nCodCia             FACTURAS.CodCia%TYPE;
BEGIN
   UPDATE DETALLE_FACTURAS
      SET Monto_Det_Local  = Monto_Det_Local  + NVL(nMtoDifLocal,0),
          Monto_Det_Moneda = Monto_Det_Moneda + NVL(nMtoDifMoneda,0),
          MtoOrigDetLocal  = MtoOrigDetLocal + NVL(nMtoDifLocal,0),
          MtoOrigDetMoneda = MtoOrigDetMoneda + NVL(nMtoDifMoneda,0),
          Saldo_Det_Local  = Monto_Det_Local  + NVL(nMtoDifLocal,0),
          Saldo_Det_Moneda = Monto_Det_Moneda + NVL(nMtoDifMoneda,0)
    WHERE IdFactura = nIdFactura
      AND IndCptoPrima = 'S'
      AND RowNum       = 1;
      
   ---Actualiza Monto de Impuesto sobre diferencia generada
   BEGIN
    SELECT 'S',F.CodCia
      INTO cExisteIVA,nCodCia
      FROM DETALLE_FACTURAS DF, FACTURAS F
     WHERE F.IdFactura  = nIdFactura
       AND df.CodCpto   = 'IVASIN'
       AND DF.IdFactura = F.IdFactura;
   EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        cExisteIVA := 'N';
   END;
   IF cExisteIVA = 'S' THEN
       nTasaIVA := OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(nCodCia, 'IVASIN');
       SELECT NVL(NVL(SUM(Monto_Det_Local),0) * nTasaIVA / 100,0)
         INTO nMtoIVA
         FROM DETALLE_FACTURAS
        WHERE IdFactura = nIdFactura
          AND CodCpto  != 'IVASIN';
        
       UPDATE DETALLE_FACTURAS
          SET Monto_Det_Local  = nMtoIVA,
              Monto_Det_Moneda = nMtoIVA,
              MtoOrigDetLocal  = nMtoIVA,
              MtoOrigDetMoneda = nMtoIVA,
              Saldo_Det_Local  = nMtoIVA,
              Saldo_Det_Moneda = nMtoIVA
        WHERE IdFactura = nIdFactura
          AND CodCpto   = 'IVASIN';
   END IF;
END ACTUALIZA_DIFERENCIA;

FUNCTION MONTO_PRIMAS(nIdTransaccion NUMBER) RETURN NUMBER IS
nMonto_Det_Local    DETALLE_FACTURAS.Monto_Det_Local%TYPE;
BEGIN
   SELECT NVL(SUM(Monto_Det_Local),0)
     INTO nMonto_Det_Local
     FROM DETALLE_FACTURAS D, FACTURAS F
    WHERE D.IndCptoPrima      = 'S'
      AND D.IdFactura         = F.IdFactura
      AND (F.IdTransaccion    = nIdTransaccion
       OR  F.IdTransaccionAnu = nIdTransaccion);
   RETURN(nMonto_Det_Local);
END MONTO_PRIMAS;

FUNCTION MONTO_CONCEPTO(nIdTransaccion NUMBER, cCodCpto VARCHAR2) RETURN NUMBER IS
nMonto_Det_Local    DETALLE_FACTURAS.Monto_Det_Local%TYPE;
BEGIN
   SELECT NVL(SUM(Monto_Det_Local),0)
     INTO nMonto_Det_Local
     FROM DETALLE_FACTURAS D, FACTURAS F
    WHERE D.CodCpto           = cCodCpto
      AND D.IdFactura         = F.IdFactura
      AND (F.IdTransaccion    = nIdTransaccion
       OR  F.IdTransaccionAnu = nIdTransaccion);
   RETURN(nMonto_Det_Local);
END MONTO_CONCEPTO;

FUNCTION MONTO_PRIMAS_MOROSA(nIdTransaccion NUMBER, dFecMorosidad DATE,
                             nRangoIni NUMBER, nRangoFin NUMBER) RETURN NUMBER IS
nMonto_Det_Local    DETALLE_FACTURAS.Monto_Det_Local%TYPE;
BEGIN
   SELECT NVL(SUM(Monto_Det_Local),0)
     INTO nMonto_Det_Local
     FROM DETALLE_FACTURAS D, FACTURAS F
    WHERE D.IndCptoPrima      = 'S'
      AND D.IdFactura         = F.IdFactura
      AND F.IdTransaccion    = nIdTransaccion
      AND TRUNC(TO_NUMBER(dFecMorosidad - TRUNC(F.FecVenc)),0) BETWEEN nRangoIni AND nRangoFin;
   RETURN(nMonto_Det_Local);
END MONTO_PRIMAS_MOROSA;

FUNCTION MONTO_CONCEPTO_MOROSO(nIdTransaccion NUMBER, cCodCpto VARCHAR2, dFecMorosidad DATE,
                               nRangoIni NUMBER, nRangoFin NUMBER) RETURN NUMBER IS
nMonto_Det_Local    DETALLE_FACTURAS.Monto_Det_Local%TYPE;
BEGIN
   SELECT NVL(SUM(Monto_Det_Local),0)
     INTO nMonto_Det_Local
     FROM DETALLE_FACTURAS D, FACTURAS F
    WHERE D.CodCpto           = cCodCpto
      AND D.IdFactura         = F.IdFactura
      AND F.IdTransaccion    = nIdTransaccion
      AND TRUNC(TO_NUMBER(dFecMorosidad - TRUNC(F.FecVenc)),0) BETWEEN nRangoIni AND nRangoFin;
   RETURN(nMonto_Det_Local);
END MONTO_CONCEPTO_MOROSO;

PROCEDURE AJUSTAR(nCodCia NUMBER, nIdFactura NUMBER, cCodCpto VARCHAR2,
                  cIndCptoPrima VARCHAR2, nMtoPagoLocal NUMBER, nMtoPagoMoneda NUMBER) IS

nMtoDetLocal   DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nMtoDetMoneda  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nDifMtoLocal   DETALLE_FACTURAS.Monto_Det_Local%TYPE;
nDifMtoMoneda  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;

CURSOR CPTO_Q IS
   SELECT IndRedondeo, IndContabRedondeo, CodCptoDeudor, CodCptoAcreedor
     FROM CATALOGO_DE_CONCEPTOS
    WHERE CodCia        = nCodCia
      AND CodConcepto   = cCodCpto;
BEGIN
   FOR X IN CPTO_Q LOOP
      IF X.IndRedondeo = 'S' THEN
         nMtoDetLocal  := ROUND(nMtoPagoLocal,0);
         nMtoDetMoneda := ROUND(nMtoPagoMoneda,0);
         nDifMtoLocal  := NVL(nMtoPagoLocal,0) - NVL(nMtoDetLocal,0);
         nDifMtoMoneda := NVL(nMtoPagoMoneda,0) - NVL(nMtoDetMoneda,0);

         IF nDifMtoLocal != 0 THEN
            BEGIN
               UPDATE DETALLE_FACTURAS
                  SET Monto_Det_Local  = nMtoDetLocal,
                      Monto_Det_Moneda = nMtoDetMoneda,
                      Saldo_Det_Local  = nMtoDetLocal,
                      Saldo_Det_Moneda = nMtoDetMoneda
                WHERE IdFactura = nIdFactura
                  AND CodCpto   = cCodCpto;
            END;
            IF X.IndContabRedondeo = 'S' THEN
               IF nDifMtoLocal < 0 THEN
                  OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, X.CodCptoAcreedor, cIndCptoPrima, nDifMtoLocal, nDifMtoMoneda);
               ELSE
                  OC_DETALLE_FACTURAS.INSERTAR(nIdFactura, X.CodCptoDeudor, cIndCptoPrima, nDifMtoLocal, nDifMtoMoneda);
               END IF;
            END IF;
         END IF;
      END IF;
   END LOOP;
END AJUSTAR;

PROCEDURE INSERTAR_DETALLE_PAGO(nIdRecibo NUMBER,nIdFactura NUMBER, cCodCpto VARCHAR2, nMtoPagoMoneda NUMBER) IS
BEGIN
   INSERT INTO PAGO_DETALLE 
          (IdRecibo, IdFactura, CodCpto, Monto)
   VALUES (nIdRecibo, nIdFactura, cCodCpto, nMtoPagoMoneda);
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR (-20100,'Error al Insertar el Pago Detalle de Factura '||cCodCpto|| ' ' || SQLERRM);
END INSERTAR_DETALLE_PAGO;

PROCEDURE PAGAR_SERVICIOS(nCodCia NUMBER, cCodCpto VARCHAR2, dFecDesde DATE, dFecHasta DATE,
                          dFecPago DATE, nCodProveedor NUMBER) IS
CURSOR CPTOSERV_Q IS
   SELECT D.IdFactura, D.CodCpto
     FROM TRANSACCION T, DETALLE_FACTURAS D, FACTURAS F, CATALOGO_DE_CONCEPTOS C
    WHERE T.CodCia                   = nCodCia
      AND TRUNC(T.FechaTransaccion) >= dFecDesde
      AND TRUNC(T.FechaTransaccion) <= dFecHasta
      AND D.FecPagoServicio         IS NULL
      AND D.IndPagoServicio          = 'N'
      AND D.IdFactura                = F.IdFactura
      AND F.IdTransaccion            = T.IdTransaccion
      AND F.StsFact             NOT IN ('ANU','XEM')
      AND F.CodCia                   = T.CodCia
      AND C.CodCia                   = T.CodCia
      AND C.CodConcepto              = D.CodCpto
      AND C.IndCptoServicio          = 'S';
BEGIN
   FOR X IN CPTOSERV_Q LOOP
      UPDATE DETALLE_FACTURAS
         SET IndPagoServicio = 'S',
             FecPagoServicio = dFecPago,
             CodProveedor    = nCodProveedor
       WHERE IdFactura  = X.IdFactura
         AND CodCpto    = X.CodCpto;
   END LOOP;
END PAGAR_SERVICIOS;

FUNCTION MONTO_SERVICIOS(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER IS
nMonto_Det_Local    DETALLE_FACTURAS.Monto_Det_Local%TYPE;
BEGIN
   SELECT NVL(SUM(Monto_Det_Local),0)
     INTO nMonto_Det_Local
     FROM DETALLE_FACTURAS D, FACTURAS F, CATALOGO_DE_CONCEPTOS C
    WHERE D.IdFactura                = F.IdFactura
      AND F.IDetPol                  = nIDetPol
      AND F.IdPoliza                 = nIdPoliza
      AND F.StsFact             NOT IN ('ANU','XEM')
      AND F.CodCia                   = nCodCia
      AND C.CodCia                   = F.CodCia
      AND C.CodConcepto              = D.CodCpto
      AND C.IndCptoServicio          = 'S'
                AND C.IndCalcReserva           = 'S';
   RETURN(nMonto_Det_Local);
END MONTO_SERVICIOS;

FUNCTION EXISTE_CONCEPTO(nCodCia NUMBER, nIdPoliza NUMBER, nIdTransaccion NUMBER, cCodCpto VARCHAR2) RETURN VARCHAR2 IS
cExiste   VARCHAR(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM DETALLE_FACTURAS D, FACTURAS F
       WHERE D.CodCpto       = cCodCpto
         AND D.IdFactura     = F.IdFactura
         AND F.CodCia        = nCodCia
         AND F.IdPoliza      = nIdPoliza
         AND F.IdTransaccion = nIdTransaccion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTE_CONCEPTO;

PROCEDURE REVERTIR_PAGO(nIdRecibo NUMBER, nIdFactura NUMBER) IS
nTasa_Cambio   FACTURAS.Tasa_Cambio%TYPE;
CURSOR DET_Q IS
   SELECT CodCpto, Monto
     FROM PAGO_DETALLE
    WHERE IdRecibo  = nIdRecibo
      AND IdFactura = nIdFactura;
BEGIN
   FOR W IN DET_Q LOOP
      BEGIN
         SELECT Tasa_Cambio
           INTO nTasa_Cambio
           FROM FACTURAS
          WHERE IdFactura = nIdFactura;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            nTasa_Cambio := 1;
      END;
      UPDATE DETALLE_FACTURAS
         SET Saldo_Det_Moneda = W.Monto,
             Saldo_Det_Local  = W.Monto * nTasa_Cambio
       WHERE IdFactura = nIdFactura
         AND CodCpto   = W.CodCpto;
   END LOOP;
END REVERTIR_PAGO;

FUNCTION MONTO_NETO_CONCEPTO(nCodCia NUMBER, nIdPoliza NUMBER, cCodCpto VARCHAR2) RETURN NUMBER IS
    nMontoCptoMoneda    DETALLE_FACTURAS.MONTO_DET_MONEDA%TYPE;
    nMtoCptoFactMoneda  DETALLE_FACTURAS.MONTO_DET_MONEDA%TYPE;
    nMtoCptoNcrMoneda   DETALLE_NOTAS_DE_CREDITO.MONTO_DET_MONEDA%TYPE;
BEGIN
    IF cCodCpto = 'PRIMAS' THEN
        ---TODOS LOS CONCEPTOS DE PRIMA
        SELECT NVL(SUM(DF.Monto_Det_Moneda), 0) 
          INTO nMtoCptoFactMoneda
          FROM DETALLE_FACTURAS DF, 
               FACTURAS F 
         WHERE F.CodCia     = nCodCia
           AND F.IdPoliza   = nIdPoliza
           AND DF.CodCpto   IN (SELECT CodConcepto 
                                  FROM CATALOGO_DE_CONCEPTOS 
                                 WHERE IndCptoPrimas   = 'S' 
                                    OR IndCptoServicio = 'S')
           AND F.Stsfact    IN ('PAG', 'EMI') 
           AND DF.IdFactura = F.IdFactura;
         
         
        SELECT NVL(SUM(DNC.Monto_Det_Moneda),0) 
          INTO nMtoCptoNcrMoneda
          FROM DETALLE_NOTAS_DE_CREDITO DNC,
               NOTAS_DE_CREDITO NC 
         WHERE NC.CodCia    = nCodCia
           AND NC.IdPoliza  = nIdPoliza
           AND DNC.CodCpto  IN (SELECT CodConcepto 
                                   FROM CATALOGO_DE_CONCEPTOS 
                                  WHERE IndCptoPrimas   = 'S' 
                                     OR IndCptoServicio = 'S')
           AND NC.STSNCR    IN ('PAG', 'EMI') 
           AND NC.IdNcr     = DNC.IdNcr;
    ELSE
        ---POR CONCEPTO DIFERENTE A PRIMA
        SELECT NVL(SUM(DF.Monto_Det_Moneda), 0) 
          INTO nMtoCptoFactMoneda
          FROM DETALLE_FACTURAS DF, 
               FACTURAS F
         WHERE F.CodCia     = nCodCia
           AND F.IdPoliza   = nIdPoliza
           AND CodCpto      = cCodCpto
           AND F.Stsfact    IN ('PAG', 'EMI') 
           AND DF.IdFactura = F.IdFactura;
        
        SELECT NVL(SUM(DNC.Monto_Det_Moneda),0) 
          INTO nMtoCptoNcrMoneda
          FROM DETALLE_NOTAS_DE_CREDITO DNC,
               NOTAS_DE_CREDITO NC 
         WHERE NC.CodCia    = nCodCia
           AND NC.IdPoliza  = nIdPoliza
           AND CodCpto      = cCodCpto
           AND NC.STSNCR    IN ('PAG', 'EMI') 
           AND NC.IdNcr     = DNC.IdNcr ;
    END IF;
    
    nMontoCptoMoneda := nMtoCptoFactMoneda - nMtoCptoNcrMoneda;
    
    RETURN nMontoCptoMoneda;
END MONTO_NETO_CONCEPTO;

FUNCTION MONTO_PAGADO_CONCEPTO(nCodCia NUMBER, nIdPoliza NUMBER, cCodCpto VARCHAR2 DEFAULT NULL) RETURN NUMBER IS
    nMontoCptoMoneda    DETALLE_FACTURAS.MONTO_DET_MONEDA%TYPE;
    nMtoCptoFactMoneda  DETALLE_FACTURAS.MONTO_DET_MONEDA%TYPE;
    nMtoCptoNcrMoneda   DETALLE_NOTAS_DE_CREDITO.MONTO_DET_MONEDA%TYPE;
BEGIN
    IF cCodCpto IS NULL THEN
        SELECT NVL(SUM(DF.Monto_Det_Moneda), 0) 
          INTO nMtoCptoFactMoneda
          FROM DETALLE_FACTURAS DF, 
               FACTURAS F 
         WHERE F.CodCia     = nCodCia
           AND F.IdPoliza   = nIdPoliza
           AND F.Stsfact    IN ('PAG') 
           AND DF.IdFactura = F.IdFactura;
         
         
        SELECT NVL(SUM(DNC.Monto_Det_Moneda),0) 
          INTO nMtoCptoNcrMoneda
          FROM DETALLE_NOTAS_DE_CREDITO DNC,
               NOTAS_DE_CREDITO NC 
         WHERE NC.CodCia    = nCodCia
           AND NC.IdPoliza  = nIdPoliza
           AND NC.STSNCR    IN ('PAG') 
           AND NC.IdNcr     = DNC.IdNcr;
    ELSIF cCodCpto = 'PRIMAS' THEN
        ---TODOS LOS CONCEPTOS DE PRIMA
        SELECT NVL(SUM(DF.Monto_Det_Moneda), 0) 
          INTO nMtoCptoFactMoneda
          FROM DETALLE_FACTURAS DF, 
               FACTURAS F 
         WHERE F.CodCia     = nCodCia
           AND F.IdPoliza   = nIdPoliza
           AND DF.CodCpto   IN (SELECT CodConcepto 
                                  FROM CATALOGO_DE_CONCEPTOS 
                                 WHERE IndCptoPrimas   = 'S' 
                                    OR IndCptoServicio = 'S')
           AND F.Stsfact    IN ('PAG') 
           AND DF.IdFactura = F.IdFactura;
         
         
        SELECT NVL(SUM(DNC.Monto_Det_Moneda),0) 
          INTO nMtoCptoNcrMoneda
          FROM DETALLE_NOTAS_DE_CREDITO DNC,
               NOTAS_DE_CREDITO NC 
         WHERE NC.CodCia    = nCodCia
           AND NC.IdPoliza  = nIdPoliza
           AND DNC.CodCpto  IN (SELECT CodConcepto 
                                   FROM CATALOGO_DE_CONCEPTOS 
                                  WHERE IndCptoPrimas   = 'S' 
                                     OR IndCptoServicio = 'S')
           AND NC.STSNCR    IN ('PAG') 
           AND NC.IdNcr     = DNC.IdNcr;
    ELSE
        ---POR CONCEPTO DIFERENTE A PRIMA
        SELECT NVL(SUM(DF.Monto_Det_Moneda), 0) 
          INTO nMtoCptoFactMoneda
          FROM DETALLE_FACTURAS DF, 
               FACTURAS F
         WHERE F.CodCia     = nCodCia
           AND F.IdPoliza   = nIdPoliza
           AND CodCpto      = cCodCpto
           AND F.Stsfact    IN ('PAG') 
           AND DF.IdFactura = F.IdFactura;
        
        SELECT NVL(SUM(DNC.Monto_Det_Moneda),0) 
          INTO nMtoCptoNcrMoneda
          FROM DETALLE_NOTAS_DE_CREDITO DNC,
               NOTAS_DE_CREDITO NC 
         WHERE NC.CodCia    = nCodCia
           AND NC.IdPoliza  = nIdPoliza
           AND CodCpto      = cCodCpto
           AND NC.STSNCR    IN ('PAG') 
           AND NC.IdNcr     = DNC.IdNcr ;
    END IF;
    
    nMontoCptoMoneda := nMtoCptoFactMoneda - nMtoCptoNcrMoneda;
    
    RETURN nMontoCptoMoneda;
END MONTO_PAGADO_CONCEPTO;

PROCEDURE GENERA_IMPUESTO_FACT_ELECT(nCodCia NUMBER, nIdFactura NUMBER, cCodCptoImpto VARCHAR2) IS
    cExiste             VARCHAR2(1);
    nTasaIVA            CATALOGO_DE_CONCEPTOS.PorcConcepto %TYPE;
    nMtoIVA             DETALLE_FACTURAS.Monto_Det_Local%TYPE := 0;
    nMtoIVAFactElect    DETALLE_FACTURAS.MtoImptoFactElect%TYPE := 0;
    nMtoIVAFact         NUMBER(28,2) := 0;
    nMtoDifIva          NUMBER(12,2);
    cCodConceptoAjuste  CATALOGO_DE_CONCEPTOS.CodConcepto%TYPE;
    
    CURSOR FACT_Q IS
        SELECT DF.CodCpto,Monto_Det_Local,CC.Orden_Impresion,CC.IndCptoPrimas
          FROM DETALLE_FACTURAS DF,CATALOGO_DE_CONCEPTOS CC
         WHERE IdFactura                 = nIdFactura
           AND NVL(CC.IndEsImpuesto,'N') != 'S' 
           AND DF.CodCpto                = CC.CodConcepto
         ORDER BY NVL(CC.Orden_Impresion,0);
BEGIN
    BEGIN
        SELECT 'S',DF.Monto_Det_Local
          INTO cExiste,nMtoIVAFact
          FROM DETALLE_FACTURAS DF,CATALOGO_DE_CONCEPTOS CC
         WHERE DF.IdFactura     = nIdFactura
           AND DF.CodCpto       = cCodCptoImpto
           AND CC.IndEsImpuesto = 'S'
           AND DF.CodCpto       = CC.CodConcepto;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN 
            cExiste := 'N';
    END;
    
    IF cExiste = 'N' THEN --- FACTURACION SIN IVA, POR TANTO PARA ENVIO A FACTURACION ELECTRONICA ES CERO
        UPDATE DETALLE_FACTURAS
           SET MtoImptoFactElect = nMtoIVA
         WHERE IdFactura         = nIdFactura;
    ELSE --- SE ACTUALIZA EL MONTO DE IVA POR CONCEPTO PARA FACTURACION ELECTRONICA
        nTasaIVA := OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(nCodCia, cCodCptoImpto);
        FOR X IN FACT_Q LOOP
            nMtoIVA  := NVL(NVL(X.Monto_Det_Local,0) * nTasaIVA / 100,0);
            
            UPDATE DETALLE_FACTURAS
               SET MtoImptoFactElect = nMtoIVA
             WHERE IdFactura         = nIdFactura
               AND CodCpto           = X.CodCpto; 
            --- DETERMINAMOS CONCEPTO PARA AJUSTE SI ES QUE LLEGA A APLICAR
            IF NVL(X.Orden_Impresion,0) = 0 AND X.IndCptoPrimas = 'S' THEN
                cCodConceptoAjuste := X.CodCpto;
            END IF;
        END LOOP;
        --- SE SUMA IVA CALCULADO POR CONCEPTO Y SE COMPARA Vs EL ESTABLECIDO EN LA FATURA PARA AJUSTAR EN CASO DE DIFERENCIA
        SELECT SUM(MtoImptoFactElect)
          INTO nMtoIVAFactElect
          FROM DETALLE_FACTURAS
         WHERE IdFactura = nIdFactura
           AND CodCpto   != cCodCptoImpto;
        
        nMtoDifIva := nMtoIVAFact - nMtoIVAFactElect;
        IF nMtoDifIva <> 0 THEN
            UPDATE DETALLE_FACTURAS
               SET MtoImptoFactElect = MtoImptoFactElect + nMtoDifIva
             WHERE IdFactura         = nIdFactura
               AND CodCpto           = cCodConceptoAjuste;
        END IF;
    END IF;
END GENERA_IMPUESTO_FACT_ELECT;

FUNCTION MONTO_IMPUESTO_FACT_ELECT(nIdFactura NUMBER, cCodCpto VARCHAR2) RETURN NUMBER IS
    nMtoImptoFactElect DETALLE_FACTURAS.MtoImptoFactElect%TYPE;
BEGIN
    BEGIN
        SELECT NVL(SUM(MtoImptoFactElect),0)
          INTO nMtoImptoFactElect
          FROM DETALLE_FACTURAS DF,CATALOGO_DE_CONCEPTOS CC
         WHERE DF.IdFactura              = nIdFactura
           AND CC.CodCptoPrimasFactElect = cCodCpto
           AND DF.CodCpto                = CC.CodConcepto
         GROUP BY CC.CodCptoPrimasFactElect;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            nMtoImptoFactElect := 0;
    END;
    RETURN nMtoImptoFactElect;
END MONTO_IMPUESTO_FACT_ELECT;

FUNCTION MONTO_CONCEPTO_FACT_ELECT(nIdFactura NUMBER, cCodCpto VARCHAR2) RETURN NUMBER IS
nMonto_Det_Moneda    DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
BEGIN
   SELECT NVL(SUM(Monto_Det_Moneda),0)
     INTO nMonto_Det_Moneda
     FROM DETALLE_FACTURAS D, FACTURAS F,
          CATALOGO_DE_CONCEPTOS CC       
    WHERE F.IdFactura                = nIdFactura
      AND CC.CodCptoPrimasFactElect  = cCodCpto
      AND D.IdFactura                = F.IdFactura
      AND D.CodCpto                  = CC.CodConcepto;
   RETURN(nMonto_Det_Moneda);
END MONTO_CONCEPTO_FACT_ELECT;

END OC_DETALLE_FACTURAS;
/

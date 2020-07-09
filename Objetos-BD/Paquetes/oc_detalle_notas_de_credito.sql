--
-- OC_DETALLE_NOTAS_DE_CREDITO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   NOTAS_DE_CREDITO (Table)
--   MODIFICACION_CONCEPTO_COMISION (Table)
--   CONCEPTOS_PLAN_DE_PAGOS (Table)
--   CONCEPTO_COMISION (Table)
--   CONFIG_RETEN_CANCELACION (Table)
--   DETALLE_NOMINA_COMISION (Table)
--   DETALLE_NOTAS_DE_CREDITO (Table)
--   RAMOS_CONCEPTOS_PLAN (Table)
--   OC_CONFIG_RETEN_CANCELACION (Package)
--   OC_CONFIG_RETEN_CANCEL_MOTIV (Package)
--   CATALOGO_DE_CONCEPTOS (Table)
--   OC_CATALOGO_DE_CONCEPTOS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.oc_detalle_notas_de_credito IS

  PROCEDURE INSERTA_DETALLE_NOTA(nIdNcr NUMBER, cCodCpto VARCHAR2, cIndCptoPrima VARCHAR2,
                                 nMtoDetNcrLocal NUMBER, nMtoDetNcrMoneda NUMBER);
  PROCEDURE GENERA_CONCEPTOS(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlanPago VARCHAR2, cIdTipoSeg VARCHAR2,
                             nIdNcr NUMBER, nTasaCambio NUMBER);

  PROCEDURE ACTUALIZA_DIFERENCIA(nIdNcr NUMBER, nMtoDifLocal NUMBER, nMtoDifMoneda NUMBER);

  PROCEDURE AJUSTAR(nCodCia NUMBER, nIdNcr NUMBER, cCodCpto VARCHAR2, cIndCptoPrima VARCHAR2,
                    nMtoDetNcrLocal NUMBER, nMtoDetNcrMoneda NUMBER);

  PROCEDURE APLICAR_RETENCION(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, dFecAnul DATE,
                              nDiasAnul NUMBER, cMotivAnul VARCHAR2, nIdNcr NUMBER, cCodCpto VARCHAR2);

  PROCEDURE GENERA_CONCEPTOS_COMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdNcr NUMBER, nTasaCambio NUMBER, 
                                      nMtoDetNcrLocal NUMBER, nMtoDetNcrMoneda NUMBER, cCodTipo VARCHAR2);

  PROCEDURE GENERA_CONCEPTOS_NOTA(nCodCia NUMBER, nIdNcr NUMBER, nIdNomina NUMBER);    
  
  PROCEDURE GENERA_IMPUESTO_FACT_ELECT(nCodCia NUMBER, nIdNcr NUMBER, cCodCptoImpto VARCHAR2);   
  
  FUNCTION MONTO_IMPUESTO_FACT_ELECT(nIdNcr NUMBER, cCodCpto VARCHAR2) RETURN NUMBER;
  
  FUNCTION MONTO_CONCEPTO_FACT_ELECT(nIdNcr NUMBER, cCodCpto VARCHAR2) RETURN NUMBER;

END OC_DETALLE_NOTAS_DE_CREDITO;
/

--
-- OC_DETALLE_NOTAS_DE_CREDITO  (Package Body) 
--
--  Dependencies: 
--   OC_DETALLE_NOTAS_DE_CREDITO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.oc_detalle_notas_de_credito IS

PROCEDURE INSERTA_DETALLE_NOTA(nIdNcr NUMBER, cCodCpto VARCHAR2, cIndCptoPrima VARCHAR2,
                               nMtoDetNcrLocal NUMBER, nMtoDetNcrMoneda NUMBER) IS
    nCodCia NOTAS_DE_CREDITO.CodCia%TYPE;
BEGIN
   BEGIN
      INSERT INTO DETALLE_NOTAS_DE_CREDITO
             (IdNcr, CodCpto, Monto_Det_Local, Monto_Det_Moneda, IndCptoPrima,
              MtoOrigDetLocal, MtoOrigDetMoneda)
      VALUES (nIdNcr, cCodCpto, nMtoDetNcrLocal, nMtoDetNcrMoneda, cIndCptoPrima,
              nMtoDetNcrLocal, nMtoDetNcrMoneda);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         BEGIN
            UPDATE DETALLE_NOTAS_DE_CREDITO
               SET Monto_Det_Local   = nMtoDetNcrLocal,
                   Monto_Det_Moneda  = nMtoDetNcrMoneda,
                   MtoOrigDetLocal   = nMtoDetNcrLocal,
                   MtoOrigDetMoneda  = nMtoDetNcrMoneda
             WHERE IdNcr    = nIdNcr
               AND CodCpto  = cCodCpto;
         END;
      WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR(-20225,'Error al Insertar Detalle Nota de Crédito No.: '||TRIM(TO_CHAR(nIdNcr))|| ' ' ||SQLERRM);
   END ;
   BEGIN
       SELECT CodCia
         INTO nCodCia 
         FROM NOTAS_DE_CREDITO
        WHERE IdNcr = nIdNcr;
   END;
   OC_DETALLE_NOTAS_DE_CREDITO.GENERA_IMPUESTO_FACT_ELECT(nCodCia, nIdNcr, 'IVASIN');
END INSERTA_DETALLE_NOTA;

PROCEDURE  GENERA_CONCEPTOS_NOTA(nCodCia NUMBER, nIdNcr NUMBER, nIdNomina NUMBER) IS
CURSOR C_GENERA_CONCEPTO IS
   SELECT CodCia, IdNomina, CodConcepto, Cod_Agente, 
          MontoNetoLocal, MontoNetoMoneda, CodMoneda
     FROM DETALLE_NOMINA_COMISION
    WHERE CodCia   = nCodCia
      AND IdNomina = nIdNomina;
BEGIN
   FOR I IN C_GENERA_CONCEPTO LOOP
      IF I.CodConcepto in ('PRIMA','COMISI', 'BONO', 'HONORA', 'AJUCOM', 'AJUHON') THEN
         OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, I.CodConcepto, 'S', I.MontoNetoLocal, I.MontoNetoMoneda);
         OC_DETALLE_NOTAS_DE_CREDITO.AJUSTAR(nCodCia, nIdNcr, I.CodConcepto, 'S', I.MontoNetoLocal, I.MontoNetoMoneda);
      ELSE
         OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, I.CodConcepto, 'N', I.MontoNetoLocal, I.MontoNetoMoneda);
         OC_DETALLE_NOTAS_DE_CREDITO.AJUSTAR(nCodCia, nIdNcr, I.CodConcepto, 'N', I.MontoNetoLocal, I.MontoNetoMoneda);
      END IF; 
   END LOOP;
END GENERA_CONCEPTOS_NOTA;

PROCEDURE GENERA_CONCEPTOS(nCodCia NUMBER, nCodEmpresa NUMBER, cCodPlanPago VARCHAR2, cIdTipoSeg VARCHAR2,
                           nIdNcr NUMBER, nTasaCambio NUMBER) IS

cGraba            VARCHAR2(1);
nMtoTotal         DETALLE_NOTAS_DE_CREDITO.Monto_Det_Local%TYPE;
nMtoTotalMoneda   DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nMtoDet           DETALLE_NOTAS_DE_CREDITO.Monto_Det_Local%TYPE;
nMtoDetMoneda     DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nMtoDetNcrLocal   DETALLE_NOTAS_DE_CREDITO.Monto_Det_Local%TYPE;
nMtoDetNcrMoneda  DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nMtoCpto          CONCEPTOS_PLAN_DE_PAGOS.MtoCpto%TYPE;
nPorcCpto         CONCEPTOS_PLAN_DE_PAGOS.PorcCpto%TYPE;

CURSOR CPTO_PLAN_Q IS
   SELECT CP.CodCpto, CP.PorcCpto, CP.Aplica, CP.MtoCpto, CC.IndRangosTipseg
     FROM CONCEPTOS_PLAN_DE_PAGOS CP, CATALOGO_DE_CONCEPTOS CC
    WHERE CC.IndCptoAjuste = 'N'
      AND CC.IndCptoPrimas = 'N'
      AND CC.CodConcepto   = CP.CodCpto
      AND CC.CodCia        = CP.CodCia
      AND CP.CodCia        = nCodCia
      AND CP.CodEmpresa    = nCodEmpresa
      AND CP.CodPlanPago   = cCodPlanPago
      AND EXISTS (SELECT 'S'
                    FROM RAMOS_CONCEPTOS_PLAN
                   WHERE CodCia      = CP.CodCia
                     AND CodEmpresa  = CP.CodEmpresa
                     AND IdTipoSeg   = cIdTipoSeg
                     AND CodCpto     = CP.CodCpto
                     AND CodPlanPago = CP.CodPlanPago)
    ORDER BY CP.Prioridad;
BEGIN
   -- Actualiza la Base de Prima por si Aplico Retención
   SELECT NVL(SUM(Monto_Det_Local),0), NVL(SUM(Monto_Det_Moneda),0)
     INTO nMtoDetNcrLocal, nMtoDetNcrMoneda
     FROM DETALLE_NOTAS_DE_CREDITO
    WHERE IdNcr   = nIdNcr;

   FOR Y IN CPTO_PLAN_Q LOOP
      BEGIN
         SELECT 'S'
           INTO cGraba
           FROM RAMOS_CONCEPTOS_PLAN
          WHERE CodPlanPago = cCodPlanPago
            AND CodCpto     = Y.CodCpto
            AND CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdTipoSeg   = cIdTipoSeg;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cGraba := 'N';
         WHEN TOO_MANY_ROWS THEN
            cGraba := 'S';
      END;
      IF cGraba = 'S' THEN
         IF Y.IndRangosTipseg = 'S' THEN
            nMtoCpto  := 0;
            nPorcCpto := 0;
         ELSE
            nMtoCpto  := Y.MtoCpto;
            nPorcCpto := Y.PorcCpto;
         END IF;

         IF Y.Aplica = 'P' THEN
            IF NVL(Y.MtoCpto,0) <> 0 THEN
               nMtoDet       := NVL(nMtoCpto,0);
               nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;
            ELSE
               nMtoDet       := NVL(nMtoDetNcrLocal,0) * nPorcCpto / 100;
               nMtoDetMoneda := NVL(nMtoDetNcrMoneda,0) * nPorcCpto / 100;
            END IF;
            IF NVL(nMtoDet,0) != 0 THEN
               OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
               OC_DETALLE_NOTAS_DE_CREDITO.AJUSTAR(nCodCia, nIdNcr, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
            END IF;
         ELSIF Y.Aplica = 'T' THEN
            IF NVL(Y.MtoCpto,0) <> 0 THEN
               nMtoDet       := NVL(nMtoCpto,0);
               nMtoDetMoneda := NVL(nMtoCpto,0) * nTasaCambio;
            ELSE
               nMtoDet       := NVL(nMtoDetNcrLocal,0) * nPorcCpto / 100;
               nMtoDetMoneda := NVL(nMtoDetNcrMoneda,0) * nPorcCpto / 100;
            END IF;
            IF NVL(nMtoDet,0) != 0 THEN
               OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
               OC_DETALLE_NOTAS_DE_CREDITO.AJUSTAR(nCodCia, nIdNcr, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
            END IF;
         END IF;
         nMtoDetNcrLocal  := nMtoDetNcrLocal + nMtoDet;
         nMtoDetNcrMoneda := nMtoDetNcrMoneda + nMtoDetMoneda;
      END IF;
   END LOOP;
END GENERA_CONCEPTOS;

PROCEDURE ACTUALIZA_DIFERENCIA(nIdNcr NUMBER, nMtoDifLocal NUMBER, nMtoDifMoneda NUMBER) IS
BEGIN
   UPDATE DETALLE_NOTAS_DE_CREDITO
      SET Monto_Det_Local  = Monto_Det_Local  + NVL(nMtoDifLocal,0),
          Monto_Det_Moneda = Monto_Det_Moneda + NVL(nMtoDifMoneda,0),
          MtoOrigDetLocal  = MtoOrigDetLocal  + NVL(nMtoDifLocal,0),
          MtoOrigDetMoneda = MtoOrigDetMoneda + NVL(nMtoDifMoneda,0)
    WHERE IdNcr        = nIdNcr
      AND IndCptoPrima = 'S'
      AND RowNum       = 1;
END ACTUALIZA_DIFERENCIA;

PROCEDURE AJUSTAR(nCodCia NUMBER, nIdNcr NUMBER, cCodCpto VARCHAR2,
                  cIndCptoPrima VARCHAR2, nMtoDetNcrLocal NUMBER, nMtoDetNcrMoneda NUMBER) IS

nMtoDetLocal   DETALLE_NOTAS_DE_CREDITO.Monto_Det_Local%TYPE;
nMtoDetMoneda  DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nDifMtoLocal   DETALLE_NOTAS_DE_CREDITO.Monto_Det_Local%TYPE;
nDifMtoMoneda  DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;

CURSOR CPTO_Q IS
   SELECT IndRedondeo, IndContabRedondeo, IndCptoPrimas,
          CodCptoDeudor, CodCptoAcreedor
     FROM CATALOGO_DE_CONCEPTOS
    WHERE CodCia        = nCodCia
      AND CodConcepto   = cCodCpto;
BEGIN
   FOR X IN CPTO_Q LOOP
      IF X.IndRedondeo = 'S' THEN
         nMtoDetLocal  := ROUND(nMtoDetNcrLocal,0);
         nMtoDetMoneda := ROUND(nMtoDetNcrMoneda,0);
         nDifMtoLocal  := NVL(nMtoDetNcrLocal,0) - NVL(nMtoDetLocal,0);
         nDifMtoMoneda := NVL(nMtoDetNcrMoneda,0) - NVL(nMtoDetMoneda,0);
         IF nDifMtoLocal != 0 THEN
            BEGIN
               UPDATE DETALLE_NOTAS_DE_CREDITO
                  SET Monto_Det_Local  = nMtoDetLocal,
                      Monto_Det_Moneda = nMtoDetMoneda
                WHERE IdNcr   = nIdNcr
                  AND CodCpto = cCodCpto;
            END;
            IF X.IndContabRedondeo = 'S' THEN
               IF nDifMtoLocal < 0 THEN
                  OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, X.CodCptoDeudor, cIndCptoPrima, nDifMtoLocal, nDifMtoMoneda);
               ELSE
                  OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, X.CodCptoAcreedor, cIndCptoPrima, nDifMtoLocal, nDifMtoMoneda);
               END IF;
            END IF;
         END IF;
      END IF;
   END LOOP;
END AJUSTAR;

PROCEDURE APLICAR_RETENCION(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, dFecAnul DATE,
                            nDiasAnul NUMBER, cMotivAnul VARCHAR2, nIdNcr NUMBER, cCodCpto VARCHAR2) IS
nPorcReten         CONFIG_RETEN_CANCELACION.PorcReten%TYPE;
nMtoDetNcrLocal    DETALLE_NOTAS_DE_CREDITO.Monto_Det_Local%TYPE;
nMtoDetNcrMoneda   DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nMtoDetLocal       DETALLE_NOTAS_DE_CREDITO.Monto_Det_Local%TYPE;
nMtoDetMoneda      DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;

BEGIN
   IF OC_CONFIG_RETEN_CANCEL_MOTIV.APLICA_MOTIVO(nCodCia, nCodEmpresa, cIdTipoSeg, dFecAnul, nDiasAnul, cMotivAnul) = 'S' THEN
      nPorcReten := OC_CONFIG_RETEN_CANCELACION.PROCENTAJE_RETENCION(nCodCia, nCodEmpresa, cIdTipoSeg, dFecAnul, nDiasAnul);
      IF NVL(nPorcReten,0) != 0 THEN

         SELECT NVL(SUM(Monto_Det_Local),0), NVL(SUM(Monto_Det_Moneda),0)
           INTO nMtoDetNcrLocal, nMtoDetNcrMoneda
           FROM DETALLE_NOTAS_DE_CREDITO
          WHERE IdNcr   = nIdNcr
            AND CodCpto = cCodCpto;

         nMtoDetLocal  := nMtoDetNcrLocal - (nMtoDetNcrLocal * nPorcReten);
         nMtoDetMoneda := nMtoDetNcrMoneda - (nMtoDetNcrMoneda * nPorcReten);

         UPDATE DETALLE_NOTAS_DE_CREDITO
            SET Monto_Det_Local  = nMtoDetLocal,
                Monto_Det_Moneda = nMtoDetMoneda
          WHERE IdNcr   = nIdNcr
            AND CodCpto = cCodCpto;
      END IF;
   END IF;
END APLICAR_RETENCION;

PROCEDURE GENERA_CONCEPTOS_COMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdNcr NUMBER, nTasaCambio NUMBER, 
                                    nMtoDetNcrLocal NUMBER, nMtoDetNcrMoneda NUMBER, cCodTipo VARCHAR2) IS
cGraba            VARCHAR2(1):='S';
nMtoTotal         DETALLE_NOTAS_DE_CREDITO.Monto_Det_Local%TYPE;
nMtoTotalMoneda   DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nMtoDet           DETALLE_NOTAS_DE_CREDITO.Monto_Det_Local%TYPE;
nMtoDetMoneda     DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;

CURSOR C_CPTO_COMISION IS
   SELECT C.CodConcepto CodCpto, C.PorcCpto, C.MtoCpto
      FROM CONCEPTO_COMISION C, MODIFICACION_CONCEPTO_COMISION M
      WHERE C.CodCia     = nCodCia
      AND C.CodTipo = cCodTipo
      AND Estado = 'ACTIVA'
      AND C.CodCia = M.CodCia
      AND C.CodConcepto = M.CodConcepto
      AND TRUNC(SYSDATE) BETWEEN M.FecIniValid AND M.FecFinValid;
BEGIN
   FOR Y IN C_CPTO_COMISION LOOP
      /*
      BEGIN
         SELECT 'S'
           INTO cGraba
           FROM RAMOS_CONCEPTOS_COMISION
          WHERE CodCpto     = Y.CodCpto
            AND CodCia      = nCodCia
            AND CodEmpresa  = nCodEmpresa
            AND IdTipoSeg   = cIdTipoSeg;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cGraba := 'N';
         WHEN TOO_MANY_ROWS THEN
            cGraba := 'S';
      END;
      */ 
      IF cGraba = 'S' THEN

            IF NVL(Y.MtoCpto,0) <> 0 THEN
               nMtoDet       := NVL(Y.MtoCpto,0);
               nMtoDetMoneda := NVL(Y.MtoCpto,0) * nTasaCambio;
            ELSE
               nMtoDet       := NVL(nMtoDetNcrLocal,0) * Y.PorcCpto / 100;
               nMtoDetMoneda := NVL(nMtoDetNcrMoneda,0) * Y.PorcCpto / 100;
            END IF;
            OC_DETALLE_NOTAS_DE_CREDITO.INSERTA_DETALLE_NOTA(nIdNcr, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
            OC_DETALLE_NOTAS_DE_CREDITO.AJUSTAR(nCodCia, nIdNcr, Y.CodCpto, 'N', nMtoDet, nMtoDetMoneda);
      END IF;
   END LOOP;
END GENERA_CONCEPTOS_COMISION;
--
--
PROCEDURE GENERA_IMPUESTO_FACT_ELECT(nCodCia NUMBER, nIdNcr NUMBER, cCodCptoImpto VARCHAR2) IS
    cExiste             VARCHAR2(1);
    nTasaIVA            CATALOGO_DE_CONCEPTOS.PorcConcepto %TYPE;
    nMtoIVA             DETALLE_NOTAS_DE_CREDITO.Monto_Det_Local%TYPE := 0;
    nMtoIVAFactElect    DETALLE_NOTAS_DE_CREDITO.MtoImptoFactElect%TYPE := 0;
    nMtoIVAFact         NUMBER(28,2) := 0;
    nMtoDifIva          NUMBER(12,2);
    cCodConceptoAjuste  CATALOGO_DE_CONCEPTOS.CodConcepto%TYPE;
    
    CURSOR NCR_Q IS
        SELECT DN.CodCpto,Monto_Det_Local,CC.Orden_Impresion,CC.IndCptoPrimas
          FROM DETALLE_NOTAS_DE_CREDITO DN,CATALOGO_DE_CONCEPTOS CC
         WHERE IdNcr                     = nIdNcr
           AND NVL(CC.IndEsImpuesto,'N') != 'S' 
           AND DN.CodCpto                = CC.CodConcepto
         ORDER BY NVL(CC.Orden_Impresion,0);
BEGIN
    BEGIN
        SELECT 'S',DN.Monto_Det_Local
          INTO cExiste,nMtoIVAFact
          FROM DETALLE_NOTAS_DE_CREDITO DN,CATALOGO_DE_CONCEPTOS CC
         WHERE DN.IdNcr         = nIdNcr
           AND DN.CodCpto       = cCodCptoImpto
           AND CC.IndEsImpuesto = 'S'
           AND DN.CodCpto       = CC.CodConcepto;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN 
            cExiste := 'N';
    END;
    
    IF cExiste = 'N' THEN --- FACTURACION SIN IVA, POR TANTO PARA ENVIO A FACTURACION ELECTRONICA ES CERO
        UPDATE DETALLE_NOTAS_DE_CREDITO
           SET MtoImptoFactElect = nMtoIVA
         WHERE IdNcr             = nIdNcr;
    ELSE --- SE ACTUALIZA EL MONTO DE IVA POR CONCEPTO PARA FACTURACION ELECTRONICA
        nTasaIVA := OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(nCodCia, cCodCptoImpto);
        FOR X IN NCR_Q LOOP
            nMtoIVA  := NVL(NVL(X.Monto_Det_Local,0) * nTasaIVA / 100,0);
            
            UPDATE DETALLE_NOTAS_DE_CREDITO
               SET MtoImptoFactElect = nMtoIVA
             WHERE IdNcr             = nIdNcr
               AND CodCpto           = X.CodCpto; 
            --- DETERMINAMOS CONCEPTO PARA AJUSTE SI ES QUE LLEGA A APLICAR
            IF NVL(X.Orden_Impresion,0) = 0 AND X.IndCptoPrimas = 'S' THEN
                cCodConceptoAjuste := X.CodCpto;
            END IF;
        END LOOP;
        --- SE SUMA IVA CALCULADO POR CONCEPTO Y SE COMPARA Vs EL ESTABLECIDO EN LA FATURA PARA AJUSTAR EN CASO DE DIFERENCIA
        SELECT SUM(MtoImptoFactElect)
          INTO nMtoIVAFactElect
          FROM DETALLE_NOTAS_DE_CREDITO
         WHERE IdNcr     = nIdNcr
           AND CodCpto   != cCodCptoImpto;
        
        nMtoDifIva := nMtoIVAFact - nMtoIVAFactElect;
        IF nMtoDifIva <> 0 THEN
            UPDATE DETALLE_NOTAS_DE_CREDITO
               SET MtoImptoFactElect = MtoImptoFactElect + nMtoDifIva
             WHERE IdNcr             = nIdNcr
               AND CodCpto           = cCodConceptoAjuste;
        END IF;
    END IF;
END GENERA_IMPUESTO_FACT_ELECT;

FUNCTION MONTO_IMPUESTO_FACT_ELECT(nIdNcr NUMBER, cCodCpto VARCHAR2) RETURN NUMBER IS
    nMtoImptoFactElect DETALLE_NOTAS_DE_CREDITO.MtoImptoFactElect%TYPE;
BEGIN
    BEGIN
        SELECT NVL(SUM(MtoImptoFactElect),0)
          INTO nMtoImptoFactElect
          FROM DETALLE_NOTAS_DE_CREDITO DN,CATALOGO_DE_CONCEPTOS CC
         WHERE DN.IdNcr                  = nIdNcr
           AND CC.CodCptoPrimasFactElect = cCodCpto
           AND DN.CodCpto                = CC.CodConcepto
         GROUP BY CC.CodCptoPrimasFactElect;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            nMtoImptoFactElect := 0;
    END;
    RETURN nMtoImptoFactElect;
    
END MONTO_IMPUESTO_FACT_ELECT;

FUNCTION MONTO_CONCEPTO_FACT_ELECT(nIdNcr NUMBER, cCodCpto VARCHAR2) RETURN NUMBER IS
nMonto_Det_Moneda    DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
BEGIN
   SELECT NVL(SUM(Monto_Det_Moneda),0)
     INTO nMonto_Det_Moneda
     FROM DETALLE_NOTAS_DE_CREDITO D, NOTAS_DE_CREDITO F,
          CATALOGO_DE_CONCEPTOS CC
    WHERE F.IdNcr                   = nIdNcr
      AND CC.CodCptoPrimasFactElect = cCodCpto
      AND D.IdNcr                   = F.IdNcr
      AND D.CodCpto                 = CC.CodConcepto;
   RETURN(nMonto_Det_Moneda);
END MONTO_CONCEPTO_FACT_ELECT;

END OC_DETALLE_NOTAS_DE_CREDITO;
/

--
-- OC_DETALLE_NOTAS_DE_CREDITO  (Synonym) 
--
--  Dependencies: 
--   OC_DETALLE_NOTAS_DE_CREDITO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_DETALLE_NOTAS_DE_CREDITO FOR SICAS_OC.OC_DETALLE_NOTAS_DE_CREDITO
/


GRANT EXECUTE ON SICAS_OC.OC_DETALLE_NOTAS_DE_CREDITO TO PUBLIC
/

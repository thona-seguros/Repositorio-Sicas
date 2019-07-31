--
-- OC_PROCESA_COMISIONES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Table)
--   POLIZAS (Table)
--   FACTURAS (Table)
--   DETALLE_COMISION (Table)
--   DETALLE_FACTURAS (Table)
--   DETALLE_NOTAS_DE_CREDITO (Table)
--   DETALLE_POLIZA (Table)
--   ENDOSOS (Table)
--   ENDOSO_TEXTO (Table)
--   OC_DETALLE_COMISION (Package)
--   OC_DETALLE_FACTURAS (Package)
--   OC_DETALLE_TRANSACCION (Package)
--   AGENTES (Table)
--   AGENTES_DISTRIBUCION_COMISION (Table)
--   AGENTES_DISTRIBUCION_POLIZA (Table)
--   AGENTES_DISTRIBUCION_POLIZA_T (Table)
--   AGENTE_POLIZA (Table)
--   AGENTE_POLIZA_T (Table)
--   NOTAS_DE_CREDITO (Table)
--   TRANSACCION (Table)
--   VALORES_DE_LISTAS (Table)
--   COMISIONES (Table)
--   CAMCAR_AGENTE_POLIZA (Table)
--   CAMCAR_POLIZA (Table)
--   CAMCAR_PORCEN (Table)
--   CATALOGO_DE_CONCEPTOS (Table)
--   OC_ENDOSO (Package)
--   OC_ENDOSO_TEXTO (Package)
--   OC_FACTURAS (Package)
--   OC_TRANSACCION (Package)
--   OC_VALORES_DE_LISTAS (Package)
--   OC_AGENTE_POLIZA_T (Package)
--   OC_COMISIONES (Package)
--   OC_COMPROBANTES_CONTABLES (Package)
--   OC_NOTAS_DE_CREDITO (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_PROCESA_COMISIONES IS

PROCEDURE CAMBIO_COMISIONES(NCODCIA            NUMBER, 
                            NCODEMPRESA        NUMBER, 
                            NIDPOLIZA          NUMBER,
                            NAGENTE_ORIGEN     NUMBER);
                             
PROCEDURE INSERTA_POLIZA(PCODCIA            NUMBER,
                         PCODEMPRESA        NUMBER, 
                         PIDPOLIZA          NUMBER,
                         PAGENTE_ORIGEN     NUMBER,
                         PAGENTE_DESTINO    NUMBER,
                         PPROMOTOR_ORIGEN   NUMBER,
                         PPROMOTOR_DESTINO  NUMBER,
                         PPARTICIPANTE      VARCHAR2) ;

PROCEDURE ACTUALIZA_POLIZA(PCODCIA            NUMBER,
                           PCODEMPRESA        NUMBER, 
                           PIDPOLIZA          NUMBER,
                           PAGENTE_ORIGEN     NUMBER,
                           PAGENTE_DESTINO    NUMBER);
                         
PROCEDURE INSERTA_ORIGEN(PCODCIA            NUMBER, 
                         PCODEMPRESA        NUMBER, 
                         PIDPOLIZA          NUMBER,
                         PAGENTE_ORIGEN     NUMBER,
                         PAGENTE_DESTINO    NUMBER,
                         PPARTICIPANTE      VARCHAR2);
                              
PROCEDURE INSERTA_DESTINO(PCODCIA            NUMBER, 
                          PCODEMPRESA        NUMBER, 
                          PIDPOLIZA          NUMBER,
                          PAGENTE_ORIGEN     NUMBER,
                          PAGENTE_DESTINO    NUMBER,
                         PPARTICIPANTE      VARCHAR2);

PROCEDURE ENVIA_ENDOSO_SIN_VALOR(PCODCIA            NUMBER,
                                 PCODEMPRESA        NUMBER, 
                                 PIDPOLIZA          NUMBER,
                                 PAGENTE_ORIGEN     NUMBER,
                                 PAGENTE_DESTINO    NUMBER,
                                 PPROMOTOR_ORIGEN   NUMBER,
                                 PPROMOTOR_DESTINO  NUMBER,
                                 PPARTICIPANTE      VARCHAR2);
                                 
END OC_PROCESA_COMISIONES;
/

--
-- OC_PROCESA_COMISIONES  (Package Body) 
--
--  Dependencies: 
--   OC_PROCESA_COMISIONES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_PROCESA_COMISIONES IS
--
-- MODIFICACIONES
-- CALCULO DEL AÑO POLIZA DE RECIBOS Y NOTAS DE CREDITO                      2019/03/27  ICO LARPLA
--
PROCEDURE CAMBIO_COMISIONES(NCODCIA            NUMBER, 
                            NCODEMPRESA        NUMBER, 
                            NIDPOLIZA          NUMBER,
                            NAGENTE_ORIGEN     NUMBER) IS   
nIdTransacAnul     TRANSACCION.IdTransaccion%TYPE;
nIdTransacAnulNC   TRANSACCION.IdTransaccion%TYPE;
nIdTransacPagos    TRANSACCION.IdTransaccion%TYPE;
nIdTransacEmis     TRANSACCION.IdTransaccion%TYPE;
nIdTransacEmisNC   TRANSACCION.IdTransaccion%TYPE;
nIdFactura         FACTURAS.IdFactura%TYPE;
nIdFacturaAnt      FACTURAS.IdFactura%TYPE;
nComision_Local    COMISIONES.Comision_Local%TYPE;
nComision_Moneda   COMISIONES.Comision_Moneda%TYPE;
nMonto_Det_Moneda  DETALLE_FACTURAS.Monto_Det_Moneda%TYPE;
nMonto_Det_Local   DETALLE_FACTURAS.Monto_Det_Local%TYPE;
cIndFacturaPol     POLIZAS.IndFacturaPol%TYPE;
nIDetPol           FACTURAS.IDetPol%TYPE;
nPorcComisiones    DETALLE_POLIZA.PorcComis%TYPE;
nMontoComisiones   DETALLE_POLIZA.MontoComis%TYPE;
cIdTipoSeg         DETALLE_POLIZA.IdTipoSeg%TYPE;
nMontoComiLocal    COMISIONES.Comision_Local%TYPE;
nMontoComiMoneda   COMISIONES.Comision_Moneda%TYPE;
nIdComision        COMISIONES.IdComision%TYPE;
nTotNotaCredCanc   DETALLE_NOTAS_DE_CREDITO.Monto_Det_Moneda%TYPE;
nCod_Agente        AGENTE_POLIZA.Cod_Agente%TYPE;
nIdNcr             NOTAS_DE_CREDITO.IdNcr%TYPE;
nIdNcrAnt          NOTAS_DE_CREDITO.IdNcr%TYPE;
cExiste            VARCHAR2(1);

CURSOR FACT_Q IS
   SELECT IdFactura, CodCobrador, IDetPol, Saldo_Moneda
     FROM FACTURAS
    WHERE CodCia   = nCodCia
      AND IdPoliza = nIdPoliza
      AND StsFact  = 'EMI'
    ORDER BY IdFactura;
CURSOR NCR_Q IS
   SELECT IdNcr, IDetPol, IdEndoso, Saldo_Ncr_Moneda
     FROM NOTAS_DE_CREDITO 
    WHERE CodCia     = nCodCia
      AND IdPoliza   = nIdPoliza
      AND StsNcr     = 'EMI'
    ORDER BY IdNcr;
CURSOR FACT_ANU_Q IS
   SELECT F.IdPoliza,            F.IDetPol,              F.CodCliente,         F.FecVenc, 
          F.Monto_Fact_Local,    F.Monto_Fact_Moneda,    F.IdEndoso,           F.MtoComisi_Local, 
          F.MtoComisi_Moneda,    F.NumCuota,             F.Tasa_Cambio,        F.CodGenerador, 
          F.CodTipoDoc,          F.Cod_Moneda,           F.CodResPago,         F.IndFactElectronica, 
          F.IndGenAviCob,        F.FecGenAviCob,         D.IdTipoSeg,          F.IdFactura,
          F.FECFINVIG,           F.CODPLANPAGO          
     FROM FACTURAS F, DETALLE_POLIZA D
    WHERE F.CodCia           = nCodCia
      AND F.IdPoliza         = nIdPoliza
      AND F.IdTransaccionAnu = nIdTransacAnul
      AND F.StsFact          = 'ANU'
      AND D.CodCia           = F.CodCia
      AND D.IdPoliza         = F.IdPoliza
      AND D.IDetPol          = F.IDetPol
    ORDER BY F.IdFactura;
CURSOR DET_Q IS
   SELECT CodCpto, Monto_Det_Local, Monto_Det_Moneda,
          Saldo_Det_Moneda, Saldo_Det_Local, IndCptoPrima,
          MtoOrigDetLocal, MtoOrigDetMoneda, IndPagoServicio,
          FecPagoServicio, CodProveedor
     FROM DETALLE_FACTURAS
    WHERE IdFactura = nIdFacturaAnt;
CURSOR NCR_ANU_Q IS
   SELECT N.IdPoliza,             N.IDetPol,               N.CodCliente,     N.FecDevol, 
          N.Monto_Ncr_Local,      N.Monto_Ncr_Moneda,      N.IdEndoso,       N.MtoComisi_Local, 
          N.MtoComisi_Moneda,     N.Tasa_Cambio,           N.Cod_Agente,     N.CodTipoDoc,
          N.CodMoneda,            N.IndFactElectronica,    D.IdTipoSeg,      N.IdNcr,
          N.FECFINVIG,            N.CODPLANPAGO
     FROM NOTAS_DE_CREDITO N, DETALLE_POLIZA D
    WHERE N.CodCia           = nCodCia
      AND N.IdPoliza         = nIdPoliza
      AND N.IdTransaccionAnu = nIdTransacAnulNC
      AND N.StsNcr           = 'ANU'
      AND D.CodCia           = N.CodCia
      AND D.IdPoliza         = N.IdPoliza
      AND D.IDetPol          = N.IDetPol
    ORDER BY N.IdNcr;
CURSOR DET_NCR_Q IS
   SELECT CodCpto, Monto_Det_Local, Monto_Det_Moneda,
          IndCptoPrima, MtoOrigDetLocal, MtoOrigDetMoneda
     FROM DETALLE_NOTAS_DE_CREDITO
    WHERE IdNcr  = nIdNcrAnt;
    
CURSOR C_AGENTES_D IS
  SELECT Cod_Agente_Distr Cod_Agente, Porc_Com_Proporcional Porc_Comision,
         Porc_Com_Distribuida, Origen
    FROM AGENTES_DISTRIBUCION_COMISION
   WHERE IdPoliza   = nIdPoliza
     AND IDetPol    = nIdetPol;
BEGIN
   SELECT IndFacturaPol
     INTO cIndFacturaPol
     FROM POLIZAS
    WHERE CodCia    = nCodCia
      AND IdPoliza  = nIdPoliza;

   nIdTransacPagos := 0;
   
   -- Anulación de Facturas Emitidas
   nIdTransacAnul := 0;
   FOR W IN FACT_Q LOOP
      IF NVL(nIdTransacAnul,0) = 0 THEN
         nIdTransacAnul := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 2, 'FAC');
      END IF;
      OC_FACTURAS.ANULAR(nCodCia, W.IdFactura, TRUNC(SYSDATE), 'CCO', W.CodCobrador, nIdTransacAnul);
      OC_DETALLE_TRANSACCION.CREA(nIdTransacAnul, nCodCia, nCodEmpresa, 2, 'FAC', 'FACTURAS',
                                  nIdPoliza, W.IDetPol, NULL, W.IdFactura, W.Saldo_Moneda);
   END LOOP;
   IF NVL(nIdTransacAnul,0) > 0 THEN
      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacAnul, 'C');
   END IF;

   -- Anulación de Notas de Crédito
   nIdTransacAnulNC := 0;
   FOR W IN NCR_Q LOOP
      IF NVL(nIdTransacAnulNC,0) = 0 THEN
         nIdTransacAnulNC := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 8, 'ANUNCR');
      END IF;
      -- Acumula Prima Devuelta
      SELECT NVL(SUM(Monto_Det_Moneda),0)
        INTO nTotNotaCredCanc
        FROM DETALLE_NOTAS_DE_CREDITO D, NOTAS_DE_CREDITO N, CATALOGO_DE_CONCEPTOS C
       WHERE C.CodConcepto      = D.CodCpto
         AND C.CodCia           = N.CodCia
         AND (D.IndCptoPrima    = 'S'
          OR C.IndCptoServicio  = 'S')
         AND D.IdNcr            = N.IdNcr
         AND N.IdNcr            = W.IdNcr;

      OC_NOTAS_DE_CREDITO.ANULAR(W.IdNcr, TRUNC(SYSDATE), 'CCO', nIdTransacAnulNC);

      OC_DETALLE_TRANSACCION.CREA(nIdTransacAnulNC, nCodCia,  nCodEmpresa, 8, 'ANUNCR', 'NOTAS_DE_CREDITO',
                                  nIdPoliza, W.IDetPol, W.IdEndoso, W.IdNcr, nTotNotaCredCanc);
   END LOOP;
   IF NVL(nIdTransacAnulNC,0) > 0 THEN
      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacAnulNC, 'C');
   END IF;

   -- Cambia Distribución de Comisiones
   OC_AGENTE_POLIZA_T.CAMBIAR_DISTRIBUCION(nCodCia, nIdPoliza);

   SELECT MAX(Cod_Agente)
     INTO nCod_Agente
     FROM AGENTE_POLIZA
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND Ind_Principal = 'S';

   -- Reemite las Facturas Anulada por el Cambio de Comisiones
   IF NVL(nIdTransacAnul,0) > 0 THEN
      FOR W IN FACT_ANU_Q LOOP
         IF NVL(nIdTransacEmis,0) = 0 THEN
            nIdTransacEmis := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 7, 'FAC');
         END IF;
         --LARPLA
         nIdFactura := OC_FACTURAS.INSERTAR(W.IdPoliza,          W.IDetPol,           W.CodCliente,      W.FecVenc,  
                                            W.Monto_Fact_Local,  W.Monto_Fact_Moneda, W.IdEndoso,        W.MtoComisi_Local, 
                                            W.MtoComisi_Moneda,  W.NumCuota,          W.Tasa_Cambio,     nCod_Agente, 
                                            W.CodTipoDoc,        nCodCia,             W.Cod_Moneda,      W.CodResPago, 
                                            nIdTransacEmis,      W.IndFactElectronica);
         UPDATE FACTURAS F
            SET IndGenAviCob = W.IndGenAviCob,
                FecGenAviCob = W.FecGenAviCob  
          WHERE CodCia    = nCodCia
            AND IdFactura = nIdFactura;

         OC_DETALLE_TRANSACCION.CREA(nIdTransacEmis, nCodCia, nCodEmpresa, 7, 'FAC', 'FACTURAS',
                                     W.IdPoliza, W.IDetPol, NULL, nIdFactura, W.Monto_Fact_Moneda);

         nIdFacturaAnt := W.IdFactura;
         FOR Z IN DET_Q LOOP
            INSERT INTO DETALLE_FACTURAS
                   (IdFactura, CodCpto, Monto_Det_Local, Monto_Det_Moneda,
                    Saldo_Det_Moneda, Saldo_Det_Local, IndCptoPrima,
                    MtoOrigDetLocal, MtoOrigDetMoneda, IndPagoServicio,
                    FecPagoServicio, CodProveedor)
            VALUES (nIdFactura, Z.CodCpto, Z.Monto_Det_Local, Z.Monto_Det_Moneda,
                    Z.Saldo_Det_Moneda, Z.Saldo_Det_Local, Z.IndCptoPrima,
                    Z.MtoOrigDetLocal, Z.MtoOrigDetMoneda, Z.IndPagoServicio,
                    Z.FecPagoServicio, Z.CodProveedor);
         END LOOP;
         
       OC_DETALLE_FACTURAS.GENERA_IMPUESTO_FACT_ELECT(nCodCia, nIdFactura, 'IVASIN');
      --------------------------------------------------

         SELECT NVL(SUM(Monto_Det_Moneda),0), NVL(SUM(Monto_Det_Moneda),0)
           INTO nMonto_Det_Moneda, nMonto_Det_Local
           FROM DETALLE_FACTURAS D, FACTURAS F, CATALOGO_DE_CONCEPTOS C
          WHERE C.CodConcepto      = D.CodCpto
            AND C.CodCia           = F.CodCia
            AND (D.IndCptoPrima    = 'S'
             OR C.IndCptoServicio  = 'S')
            AND D.IdFactura        = F.IdFactura
            AND F.IdFactura        = nIdFactura;

         nIDetPol  := W.IDetPol;
         FOR R IN C_AGENTES_D LOOP
            SELECT NVL(PorcComis,0), NVL(MontoComis,0), IdTipoSeg
              INTO nPorcComisiones, nMontoComisiones, cIdTipoSeg
              FROM DETALLE_POLIZA
             WHERE IdPoliza  = nIdPoliza
               AND IDetPol   = nIDetPol
               AND CodCia    = nCodCia;

            IF NVL(nMontoComisiones,0) = 0 THEN
               nMontoComiLocal  := nMonto_Det_Local * (R.Porc_Com_Distribuida/100);
               nMontoComiMoneda := nMonto_Det_Moneda * (R.Porc_Com_Distribuida/100);
            ELSE
               nMontoComiLocal  := nMontoComisiones * (R.Porc_Comision/100);
               nMontoComiMoneda := nMontoComisiones / W.Tasa_Cambio * (R.Porc_Comision/100);
            END IF;

            BEGIN
               SELECT 'S'
                 INTO cExiste
                 FROM COMISIONES
                WHERE IdPoliza  = nIdPoliza
                  AND IdFactura = nIdFactura
                  AND Cod_Agente = R.Cod_Agente;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cExiste :='N';
              WHEN TOO_MANY_ROWS THEN
                  cExiste :='S';
            END;

            IF cExiste = 'N' THEN
               OC_COMISIONES.INSERTAR_COMISION_FACT(nIdFactura, nIdPoliza, W.IdetPol, W.Cod_Moneda, R.Cod_Agente,
                                                    nCodCia, nCodEmpresa, nMontoComiLocal, nMontoComiMoneda,
                                                    W.Tasa_Cambio, R.Origen, cIdTipoSeg);
            ELSIF cExiste = 'S' THEN
               UPDATE COMISIONES
                  SET Comision_Moneda  = Comision_Moneda + nMontoComiMoneda,
                      Comision_Local   = Comision_Local   + nMontoComiLocal,
                      Com_Saldo_Local  = Com_Saldo_Local  + nMontoComiLocal,
                      Com_Saldo_Moneda = Com_Saldo_Moneda + nMontoComiMoneda
                WHERE IdPoliza   = IdPoliza
                  AND IdFactura  = nIdFactura
                  AND Cod_Agente = R.Cod_Agente;

               nMontoComiLocal  := 0;
               nMontoComiMoneda := 0;

               SELECT IdComision
                 INTO nIdComision
                 FROM COMISIONES
                WHERE IdPoliza   = nIdPoliza
                  AND IdFactura  = nIdFactura
                  AND Cod_Agente = R.Cod_Agente;

               -- Elimina para Recalcular los Conceptos del Detale
               DELETE DETALLE_COMISION
                WHERE IdComision = nIdComision;

               OC_DETALLE_COMISION.INSERTA_DETALLE_COMISION(nCodCia, nIdPoliza, nIdComision, R.Origen, cIdTipoSeg);
            END IF;
            nMontoComiLocal  := 0;
            nMontoComiMoneda := 0;
         END LOOP;

         SELECT NVL(SUM(Comision_Local),0), NVL(SUM(Comision_Moneda),0)
           INTO nComision_Local, nComision_Moneda
           FROM COMISIONES
          WHERE IdFactura = nIdFactura;

         UPDATE FACTURAS
            SET MtoComisi_Local  = nComision_Local,
                MtoComisi_Moneda = nComision_Moneda
          WHERE IdFactura = nIdFactura;
      END LOOP;
      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacEmis, 'C');
   END IF;

   -- Reemite las Notas de Crédito Anulada por el Cambio de Comisiones
   IF NVL(nIdTransacAnulNC,0) > 0 THEN
      FOR W IN NCR_ANU_Q LOOP
         IF NVL(nIdTransacEmisNC,0) = 0 THEN
            nIdTransacEmisNC := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 2, 'NOTACR');
         END IF;
         -- LARPLA
         nIdNcr := OC_NOTAS_DE_CREDITO.INSERTA_NOTA_CREDITO(nCodCia,            W.IdPoliza,          W.IDetPol,         W.IdEndoso, 
                                                            W.CodCliente,       W.FecDevol,          W.Monto_Ncr_Local, W.Monto_Ncr_Moneda,
                                                            W.MtoComisi_Local,  W.MtoComisi_Moneda,  nCod_Agente,       W.CodMoneda, 
                                                            W.Tasa_Cambio,      nIdTransacEmisNC,    W.IndFactElectronica);

         OC_DETALLE_TRANSACCION.CREA (nIdTransacEmisNC, nCodCia,  nCodEmpresa, 2, 'NOTACR', 'NOTAS_DE_CREDITO',
                                      W.IdPoliza, W.IDetPol, W.IdEndoso, nIdNcr, W.Monto_Ncr_Moneda);

         nIdNcrAnt := W.IdNcr;
         FOR Z IN DET_NCR_Q LOOP
            INSERT INTO DETALLE_NOTAS_DE_CREDITO
                   (IdNcr, CodCpto, Monto_Det_Local, Monto_Det_Moneda,
                    IndCptoPrima, MtoOrigDetLocal, MtoOrigDetMoneda)
            VALUES (nIdNcr, Z.CodCpto, Z.Monto_Det_Local, Z.Monto_Det_Moneda,
                    Z.IndCptoPrima, Z.MtoOrigDetLocal, Z.MtoOrigDetMoneda);
         END LOOP;

         OC_NOTAS_DE_CREDITO.ACTUALIZA_NOTA(nIdNcr);
         OC_COMISIONES.INSERTA_COMISION_NC(nIdNcr);
         OC_NOTAS_DE_CREDITO.EMITIR(nIdNcr, NULL);
      END LOOP;
      IF NVL(nIdTransacEmisNC,0) != 0 THEN
         OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacEmisNC, 'C');
      END IF;
   END IF;

   IF NVL(nIdTransacAnul,0)   > 0 OR
      NVL(nIdTransacAnulNC,0) > 0 THEN
      UPDATE CAMCAR_POLIZA C
         SET C.ST_ACTUALIZADA        = 'PROCE',
             C.IDTRANSACCION_FACT    = nIdTransacEmis,
             C.IDTRANSACCIONANU_FACT = nIdTransacAnul,
             C.IDTRANSACCION_NCR     = nIdTransacEmisNC,
             C.IDTRANSACCIONANU_NCR  = nIdTransacAnulNC
       WHERE C.COD_AGENTE_ANT = NAGENTE_ORIGEN
         AND C.IDPOLIZA       = NIDPOLIZA
         AND C.ST_ACTUALIZADA = 'PEN';
      --
      --BORRA TABLAS DE CALCULO
      --
      DELETE AGENTES_DISTRIBUCION_POLIZA_T
       WHERE CODCIA     = nCodCia
         AND IDPOLIZA   = NIDPOLIZA;
      --
      DELETE AGENTE_POLIZA_T
       WHERE CODCIA     = nCodCia
         AND IDPOLIZA   = NIDPOLIZA;
      --      
      COMMIT; 
      --
   END IF;
END CAMBIO_COMISIONES;

PROCEDURE INSERTA_POLIZA(PCODCIA            NUMBER,
                         PCODEMPRESA        NUMBER, 
                         PIDPOLIZA          NUMBER,
                         PAGENTE_ORIGEN     NUMBER,
                         PAGENTE_DESTINO    NUMBER,
                         PPROMOTOR_ORIGEN   NUMBER,
                         PPROMOTOR_DESTINO  NUMBER,
                         PPARTICIPANTE      VARCHAR2) IS   
--                        
NCODTIPO_AGE_ORI   AGENTES.CODTIPO%TYPE;
NCODTIPO_AGE_DES   AGENTES.CODTIPO%TYPE;
NCODTIPO_PRO_ORI   AGENTES.CODTIPO%TYPE;    
NCODTIPO_PRO_DES   AGENTES.CODTIPO%TYPE;
--
BEGIN
 --
 BEGIN 
    SELECT A.CODTIPO
    INTO NCODTIPO_AGE_ORI
    FROM AGENTES A
   WHERE A.COD_AGENTE = PAGENTE_ORIGEN;
 EXCEPTION
     WHEN NO_DATA_FOUND THEN
          NCODTIPO_AGE_ORI := '';
     WHEN OTHERS THEN
          NCODTIPO_AGE_ORI := '';
 END;
 --
 BEGIN 
    SELECT A.CODTIPO
    INTO NCODTIPO_AGE_DES
    FROM AGENTES A
   WHERE A.COD_AGENTE = PAGENTE_DESTINO;
 EXCEPTION
     WHEN NO_DATA_FOUND THEN
          NCODTIPO_AGE_DES := '';
     WHEN OTHERS THEN
          NCODTIPO_AGE_DES := '';
 END;
 --
 BEGIN 
    SELECT A.CODTIPO
    INTO NCODTIPO_PRO_ORI
    FROM AGENTES A
   WHERE A.COD_AGENTE = PPROMOTOR_ORIGEN;
 EXCEPTION
     WHEN NO_DATA_FOUND THEN
          NCODTIPO_PRO_ORI := '';
     WHEN OTHERS THEN
          NCODTIPO_PRO_ORI := '';
 END;
 --
 BEGIN 
    SELECT A.CODTIPO
    INTO NCODTIPO_PRO_DES
    FROM AGENTES A
   WHERE A.COD_AGENTE = PPROMOTOR_DESTINO;
 EXCEPTION
     WHEN NO_DATA_FOUND THEN
          NCODTIPO_PRO_DES := '';
     WHEN OTHERS THEN
          NCODTIPO_PRO_DES := '';
 END;
 --
 INSERT INTO CAMCAR_POLIZA
  (CODCIA,             CODEMPRESA,
   IDPOLIZA,           CODUSUARIO,
   COD_AGENTE_ANT,     COD_AGENTE_ACT,
   COD_PROMOTOR_ANT,   COD_PROMOTOR_ACT,
   CODTIPO_AGE_ANT,    CODTIPO_AGE_ACT,
   CODTIPO_PRO_ANT,    CODTIPO_PRO_ACT,
   FE_CAMBIO,          HR_CAMBIO,
   ST_ACTUALIZADA,     ID_TP_AGENTES)
 VALUES
  (PCODCIA,            PCODEMPRESA,
   PIDPOLIZA,          USER,
   PAGENTE_ORIGEN,     PAGENTE_DESTINO,
   PPROMOTOR_ORIGEN,   PPROMOTOR_DESTINO,
   NCODTIPO_AGE_ORI,   NCODTIPO_AGE_DES,
   NCODTIPO_PRO_ORI,   NCODTIPO_PRO_DES,
   TRUNC(SYSDATE),     SYSDATE,
   'PEN',              PPARTICIPANTE)  
 ;
 COMMIT;
 --
 ACTUALIZA_POLIZA(PCODCIA, PCODEMPRESA, PIDPOLIZA, PAGENTE_ORIGEN, PAGENTE_DESTINO);
 --
END INSERTA_POLIZA;

PROCEDURE ACTUALIZA_POLIZA(PCODCIA            NUMBER,
                           PCODEMPRESA        NUMBER, 
                           PIDPOLIZA          NUMBER,
                           PAGENTE_ORIGEN     NUMBER,
                           PAGENTE_DESTINO    NUMBER) IS   

NNIVEL_1_ORI  AGENTES.CODNIVEL%TYPE;
NNIVEL_2_ORI  AGENTES.CODNIVEL%TYPE;
NNIVEL_3_ORI  AGENTES.CODNIVEL%TYPE;
NNIVEL_1_DES  AGENTES.CODNIVEL%TYPE;
NNIVEL_2_DES  AGENTES.CODNIVEL%TYPE;
NNIVEL_3_DES  AGENTES.CODNIVEL%TYPE;
NERRORESTRUCTURA NUMBER;
--                        
BEGIN
 --
 NERRORESTRUCTURA := 0;
 --
 -- DATOS ORIGEN
 --
 BEGIN
  SELECT NVL(A.CODNIVEL,0),
         NVL(B.CODNIVEL,0),
         NVL(C.CODNIVEL,0)
    INTO NNIVEL_1_ORI,
         NNIVEL_2_ORI,
         NNIVEL_3_ORI
    FROM AGENTES_DISTRIBUCION_POLIZA A,
         AGENTES_DISTRIBUCION_POLIZA B,
         AGENTES_DISTRIBUCION_POLIZA C
   WHERE A.CODCIA           = PCODCIA
     AND A.IDPOLIZA         = PIDPOLIZA
     AND A.COD_AGENTE       = PAGENTE_ORIGEN
     AND A.COD_AGENTE_DISTR = PAGENTE_ORIGEN
     --
     AND B.CODCIA(+)           = A.CODCIA
     AND B.IDPOLIZA(+)         = A.IDPOLIZA
     AND B.COD_AGENTE(+)       = A.COD_AGENTE
     AND B.COD_AGENTE_DISTR(+) = A.COD_AGENTE_JEFE
     --
     AND C.CODCIA(+)           = B.CODCIA
     AND C.IDPOLIZA(+)         = B.IDPOLIZA
     AND C.COD_AGENTE(+)       = B.COD_AGENTE
     AND C.COD_AGENTE_DISTR(+) = B.COD_AGENTE_JEFE;
 EXCEPTION
     WHEN OTHERS THEN
          NNIVEL_1_ORI := 0;
        NNIVEL_2_ORI := 0;
        NNIVEL_3_ORI := 0;
 END;
 --
 -- DATOS DESTINO
 --
 BEGIN
  SELECT NVL(A.CODNIVEL,0),
         NVL(B.CODNIVEL,0),
         NVL(C.CODNIVEL,0)
    INTO NNIVEL_1_DES,
         NNIVEL_2_DES,
         NNIVEL_3_DES
    FROM AGENTES A,
         AGENTES B,
         AGENTES C
   WHERE A.COD_AGENTE = PAGENTE_DESTINO
     --
     AND B.COD_AGENTE(+) = A.COD_AGENTE_JEFE
     --
     AND C.COD_AGENTE(+) = B.COD_AGENTE_JEFE;      
 EXCEPTION
     WHEN OTHERS THEN
          NNIVEL_1_ORI := 999;
        NNIVEL_2_ORI := 999;
        NNIVEL_3_ORI := 999;
 END;
 --
 IF NNIVEL_1_ORI != NNIVEL_1_DES THEN
      NERRORESTRUCTURA := 1;
 ELSIF NNIVEL_2_ORI != NNIVEL_2_DES THEN
      NERRORESTRUCTURA := 1; 
 ELSIF NNIVEL_3_ORI != NNIVEL_3_DES THEN
      NERRORESTRUCTURA := 1; 
 END IF;
 --
 IF NERRORESTRUCTURA != 0 THEN
      UPDATE CAMCAR_POLIZA CP
       SET ST_ACTUALIZADA = 'ERROR'
     WHERE CP.CODCIA         = PCODCIA
       AND CP.CODEMPRESA     = PCODEMPRESA
       AND CP.IDPOLIZA       = PIDPOLIZA
       AND CP.COD_AGENTE_ANT = PAGENTE_ORIGEN
       AND CP.COD_AGENTE_ACT = PAGENTE_DESTINO
       AND CP.ST_ACTUALIZADA = 'PEN';
    --
    --BORRA TABLAS DE CALCULO
    --
    DELETE AGENTES_DISTRIBUCION_POLIZA_T
     WHERE CODCIA     = PCODCIA
       AND IDPOLIZA   = PIDPOLIZA;
    --
    DELETE AGENTE_POLIZA_T
     WHERE CODCIA     = PCODCIA
       AND IDPOLIZA   = PIDPOLIZA;
    --
    COMMIT;
    --
 END IF;
 --
END ACTUALIZA_POLIZA;


PROCEDURE INSERTA_ORIGEN(PCODCIA            NUMBER, 
                         PCODEMPRESA        NUMBER, 
                         PIDPOLIZA          NUMBER,
                         PAGENTE_ORIGEN     NUMBER,
                         PAGENTE_DESTINO    NUMBER,
                         PPARTICIPANTE      VARCHAR2) IS   
BEGIN
 --
 INSERT INTO CAMCAR_PORCEN
  SELECT PCODCIA,
         PCODEMPRESA,
         PIDPOLIZA,
         ADP.COD_AGENTE,
         ADP.CODNIVEL,
         ADP.COD_AGENTE_DISTR,
         ADP.PORC_COMISION_AGENTE,
         ADP.PORC_COM_DISTRIBUIDA,
         ADP.PORC_COMISION_PLAN,
         ADP.PORC_COM_PROPORCIONAL,
         ADP.COD_AGENTE_JEFE,
         ADP.PORC_COM_POLIZA,
         ADP.ORIGEN,
         PPARTICIPANTE,
         TRUNC(SYSDATE),
         SYSDATE
    FROM AGENTES_DISTRIBUCION_POLIZA ADP 
   WHERE ADP.CODCIA     = PCODCIA
     AND ADP.IDPOLIZA   = PIDPOLIZA
 ;
 --
END INSERTA_ORIGEN;

PROCEDURE INSERTA_DESTINO(PCODCIA            NUMBER, 
                          PCODEMPRESA        NUMBER, 
                          PIDPOLIZA          NUMBER,
                          PAGENTE_ORIGEN     NUMBER,
                          PAGENTE_DESTINO    NUMBER,
                          PPARTICIPANTE      VARCHAR2) IS   
CJEFE      VARCHAR2(1);                        
NNJEFE     AGENTES.COD_AGENTE%TYPE;
NJEFE      AGENTES.COD_AGENTE%TYPE;
NCODAGENTE AGENTES.COD_AGENTE%TYPE;
NCODNIVEL  AGENTES.CODNIVEL%TYPE;
NORDEN     NUMBER;
--
BEGIN
 --
 -- INSERTA TABLAS DE CAMBIO DE PROCESO TEMPORAL
 --
 INSERT INTO AGENTES_DISTRIBUCION_POLIZA_T
  SELECT CODCIA,
         IDPOLIZA,
         COD_AGENTE,
         CODNIVEL,
         COD_AGENTE_DISTR,
         PORC_COMISION_AGENTE,
         PORC_COM_DISTRIBUIDA,
         PORC_COMISION_PLAN,
         PORC_COM_PROPORCIONAL,
         COD_AGENTE_JEFE,
         PORC_COM_POLIZA,
         ORIGEN
    FROM AGENTES_DISTRIBUCION_POLIZA ADP 
   WHERE ADP.CODCIA     = PCODCIA
     AND ADP.IDPOLIZA   = PIDPOLIZA
 ;
 INSERT INTO AGENTE_POLIZA_T
  SELECT IDPOLIZA,
         CODCIA,
         COD_AGENTE,
         PORC_COMISION,
         IND_PRINCIPAL,
         ORIGEN
    FROM AGENTE_POLIZA ADP 
   WHERE ADP.CODCIA     = PCODCIA
     AND ADP.IDPOLIZA   = PIDPOLIZA
 ;
 --
 COMMIT;
 --
 -- ACTUALIZA ESTRUCTURA TOMANDO EN CUENTA QUE NO HAY CAMBIO DE PORCENTAJES
 --
 CJEFE  := 'S';
 NJEFE  := PAGENTE_DESTINO;
 NORDEN := 1;
 --
 WHILE CJEFE = 'S' LOOP
       --
       BEGIN
         SELECT AG.COD_AGENTE,     AG.COD_AGENTE_JEFE,  AG.CODNIVEL
           INTO NCODAGENTE,        NNJEFE,              NCODNIVEL
           FROM AGENTES AG
          WHERE AG.COD_AGENTE = NJEFE;
          -- 
          IF NORDEN = 1 THEN 
             UPDATE AGENTES_DISTRIBUCION_POLIZA_T ADP 
                SET ADP.COD_AGENTE       = PAGENTE_DESTINO,
                    ADP.COD_AGENTE_DISTR = PAGENTE_DESTINO,
                    ADP.COD_AGENTE_JEFE  = NNJEFE
              WHERE ADP.CODCIA           = PCODCIA
                AND ADP.IDPOLIZA         = PIDPOLIZA
                AND ADP.COD_AGENTE       = PAGENTE_ORIGEN
                AND ADP.COD_AGENTE_DISTR = PAGENTE_ORIGEN;
          ELSE
             UPDATE AGENTES_DISTRIBUCION_POLIZA_T ADP 
                SET ADP.COD_AGENTE       = PAGENTE_DESTINO,
                    ADP.COD_AGENTE_DISTR = NJEFE,
                    ADP.COD_AGENTE_JEFE  = NNJEFE
              WHERE ADP.CODCIA           = PCODCIA
                AND ADP.IDPOLIZA         = PIDPOLIZA
                AND ADP.COD_AGENTE       = PAGENTE_ORIGEN
                AND ADP.CODNIVEL         = NCODNIVEL;
          END IF;
       EXCEPTION 
         WHEN NO_DATA_FOUND THEN
              CJEFE    := 'N';
       END;
       --
       COMMIT;
       --
       NORDEN := NORDEN + 1;
       IF NJEFE IS NULL OR CJEFE = 'N' THEN                                                       
          EXIT;
       END IF;
       --
       IF NNJEFE IS NOT NULL THEN
          NJEFE := NNJEFE;
       ELSE
          EXIT;
       END IF;
 END LOOP;
  --
 UPDATE AGENTE_POLIZA_T AP 
    SET AP.COD_AGENTE  = PAGENTE_DESTINO
  WHERE AP.CODCIA     = PCODCIA
    AND AP.IDPOLIZA   = PIDPOLIZA
    AND AP.COD_AGENTE = PAGENTE_ORIGEN;
 --
 COMMIT;
 --
 -- INSERTA TABLAS HISTORICAS
 --
 INSERT INTO CAMCAR_PORCEN
  SELECT CODCIA,
         PCODEMPRESA,
         IDPOLIZA,
         COD_AGENTE,
         CODNIVEL,
         COD_AGENTE_DISTR,
         PORC_COMISION_AGENTE,
         PORC_COM_DISTRIBUIDA,
         PORC_COMISION_PLAN,
         PORC_COM_PROPORCIONAL,
         COD_AGENTE_JEFE,
         PORC_COM_POLIZA,
         ORIGEN,
         PPARTICIPANTE,
         TRUNC(SYSDATE),
         SYSDATE
    FROM AGENTES_DISTRIBUCION_POLIZA_T ADP 
   WHERE ADP.CODCIA     = PCODCIA
     AND ADP.IDPOLIZA   = PIDPOLIZA
 ;
 INSERT INTO CAMCAR_AGENTE_POLIZA
  SELECT CODCIA,
         PCODEMPRESA,
         IDPOLIZA,
         COD_AGENTE,
         PORC_COMISION,
         IND_PRINCIPAL,
         ORIGEN,
         PPARTICIPANTE,
         TRUNC(SYSDATE),
         SYSDATE
    FROM AGENTE_POLIZA_T ADP 
   WHERE ADP.CODCIA     = PCODCIA
     AND ADP.IDPOLIZA   = PIDPOLIZA
 ;
 --
 COMMIT;
 --
END INSERTA_DESTINO;


PROCEDURE ENVIA_ENDOSO_SIN_VALOR(PCODCIA            NUMBER,
                                 PCODEMPRESA        NUMBER, 
                                 PIDPOLIZA          NUMBER,
                                 PAGENTE_ORIGEN     NUMBER,
                                 PAGENTE_DESTINO    NUMBER,
                                 PPROMOTOR_ORIGEN   NUMBER,
                                 PPROMOTOR_DESTINO  NUMBER,
                                 PPARTICIPANTE      VARCHAR2) IS   
 nCodCia           ENDOSOS.CODCIA%TYPE;         
 nCodEmpresa       ENDOSOS.CODEMPRESA%TYPE;
 nIdPoliza         ENDOSOS.IDPOLIZA%TYPE;         
 nIDetPol          ENDOSOS.IDETPOL%TYPE;
 cTipoEndoso       ENDOSOS.TIPOENDOSO%TYPE;       
 cNumEndRef        ENDOSOS.NUMENDREF%TYPE;
 dFecIniVig        ENDOSOS.FECINIVIG%TYPE;
 dFecFinVig        ENDOSOS.FECFINVIG%TYPE;
 cCodPlan          ENDOSOS.CODPLANPAGO%TYPE;
 nSuma_Aseg_Moneda ENDOSOS.SUMA_ASEG_LOCAL%TYPE;
 nPrima_Moneda     ENDOSOS.PRIMA_NETA_LOCAL%TYPE;
 nPorcComis        ENDOSOS.PORCCOMIS%TYPE;
 cMotivo_Endoso    ENDOSOS.MOTIVO_ENDOSO%TYPE;
 dFecExc           ENDOSOS.FECEXC%TYPE;
 cTextoEndoso      ENDOSO_TEXTO.TEXTO%TYPE;
 cUsuario          VARCHAR2(20);
 cTerminal         VARCHAR2(20);
 nIdendoso         ENDOSOS.IDENDOSO%TYPE;
 cnomendoso        VALORES_DE_LISTAS.DESCVALLST%TYPE;
 CAGENTE               AGENTE_POLIZA.COD_AGENTE%TYPE;
 CCOD_AGENTE_DISTR     AGENTES_DISTRIBUCION_POLIZA.COD_AGENTE_DISTR%TYPE;
 CCODNIVEL             AGENTES_DISTRIBUCION_POLIZA.CODNIVEL%TYPE;
 CPORC_COM_DISTRIBUIDA AGENTES_DISTRIBUCION_POLIZA.PORC_COM_DISTRIBUIDA%TYPE;
 CCOD_AGENTE_JEFE      AGENTES_DISTRIBUCION_POLIZA.COD_AGENTE_JEFE%TYPE;
 CLINEA                VARCHAR2(500);
 CLINEA_T              VARCHAR2(2000);
 CTEXTO_INICIAL        VARCHAR2(2000);
BEGIN
   --
  cMotivo_Endoso := '009';  -- EN CATALOGO 'CAMBIO DE COMISIONES'
  --
  BEGIN
     SELECT FECFINVIG
       INTO dFecFinVig
      FROM POLIZAS P
     WHERE IDPOLIZA = PCODCIA
       AND CODCIA   = PIDPOLIZA;
   EXCEPTION
     WHEN OTHERS THEN 
          dFecFinVig := TRUNC(SYSDATE);
   END;
   --
  SELECT USER,     USERENV('TERMINAL') 
    INTO cUsuario, cTerminal 
    FROM SYS.DUAL;
  --
  SELECT NVL(MAX(IdEndoso),0) + 1
    INTO nIdendoso
    FROM ENDOSOS
   WHERE IDPOLIZA = PIDPOLIZA;
  --
  cnomendoso := OC_VALORES_DE_LISTAS.BUSCA_LVALOR('MTOENDSV', cMotivo_Endoso);
  --
  nCodCia           := PCODCIA;
  nCodEmpresa       := PCODEMPRESA;
  nIdPoliza         := PIDPOLIZA;
  nIDetPol          := 1;   -- SE LIGA POR DEFAUL AL DETALLE 1
  cTipoEndoso       := 'ESV';
  cNumEndRef        := 'END-' ||nIdPoliza||'-'||nIDENDOSO;
  dFecIniVig        := TRUNC(SYSDATE);
  cCodPlan          := '';
  nSuma_Aseg_Moneda := 0;
  nPrima_Moneda     := 0;
  nPorcComis        := 0;
  dFecExc           := TRUNC(SYSDATE);
  --
  OC_ENDOSO.INSERTA(nCodCia,            nCodEmpresa,             nIdPoliza, 
                    nIDetPol,           nIdendoso,               cTipoEndoso,    
                    cNumEndRef,         dFecIniVig,              dFecFinVig,
                    cCodPlan,           nSuma_Aseg_Moneda,       nPrima_Moneda,      
                    nPorcComis,         cMotivo_Endoso,          dFecExc);
  --
  OC_ENDOSO.EMITIR(nCodCia,             nCodEmpresa,             nIdPoliza,
                   nIDetPol,            nIdendoso,               cTipoEndoso); 
  --    
  IF PPARTICIPANTE = 'A' THEN
     CTEXTO_INICIAL := 'Por medio del presente endoso, se hace constar que para la póliza en mención se realiza cambio de cartera, del agente '||
                        PAGENTE_ORIGEN||' al agente '||PAGENTE_DESTINO||' POR EL USUARIO, '||cUsuario||', EN LA TERMINAL - '||cTerminal;
  ELSE 
     CTEXTO_INICIAL := 'Por medio del presente endoso, se hace constar que para la póliza en mención se realiza cambio de cartera, del agente '||
                       PAGENTE_ORIGEN||' al agente '||PAGENTE_DESTINO||' del promotor '||PPROMOTOR_ORIGEN||' al Promotor '||PPROMOTOR_DESTINO||
                      ' POR EL USUARIO, '||cUsuario||', EN LA TERMINAL - '||cTerminal;
  END IF;
  --
  UPDATE ENDOSOS E
     SET E.DESCENDOSO = CTEXTO_INICIAL
   WHERE E.IDPOLIZA = nIdPoliza
     AND E.IDENDOSO = nIdendoso;
  --            
  -- COMPLEMENTA TEXTO
  --
  BEGIN
    SELECT AP.COD_AGENTE,  AP.COD_AGENTE   
      INTO CAGENTE,        CCOD_AGENTE_JEFE
      FROM AGENTE_POLIZA_T AP
     WHERE AP.IDPOLIZA = nIdPoliza;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         CCOD_AGENTE_JEFE := 0;   
    WHEN OTHERS THEN
         CCOD_AGENTE_JEFE := 0;   
  END;
  --  
  CLINEA_T := CHR(10)||CTEXTO_INICIAL||CHR(10)||'Despues      Apartir del '||dFecFinVig||CHR(10);
  --
  WHILE CCOD_AGENTE_JEFE > 0 LOOP
        BEGIN
          SELECT RPAD(ADP.COD_AGENTE_DISTR,5,' ')||
                 LPAD(ADP.PORC_COM_DISTRIBUIDA,3,' ')||'%'
                 ||CHR(10),
                 ADP.COD_AGENTE_JEFE
            INTO CLINEA,
                 CCOD_AGENTE_JEFE
            FROM AGENTES_DISTRIBUCION_POLIZA_T ADP  
           WHERE ADP.IDPOLIZA         = nIdPoliza    
             AND ADP.COD_AGENTE       = CAGENTE
             AND ADP.COD_AGENTE_DISTR = CCOD_AGENTE_JEFE;       
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
               CCOD_AGENTE_JEFE := 0;
          WHEN OTHERS THEN
               CCOD_AGENTE_JEFE := 0;
        END;
        --
        CLINEA_T := CLINEA_T||CLINEA;
        --        
  END LOOP;
  --
  OC_ENDOSO_TEXTO.INSERTA(nIdPoliza, nIdendoso, CLINEA_T);                               
  --
END;




END OC_PROCESA_COMISIONES;
/

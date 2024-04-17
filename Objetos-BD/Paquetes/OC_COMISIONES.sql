create or replace PACKAGE OC_COMISIONES IS
---- SE ADICIONO UN JOIN CATALOGO_DE_CONCEPTOS PARA RECUPERAR EL SIGNO    JMMD20220125
  PROCEDURE DISTRIBUCION(nCodCia NUMBER, nIdPoliza NUMBER,cCod_Agente VARCHAR2, nPorcApl NUMBER);
  PROCEDURE PAGA_ABONA_COMISION(nIdFactura NUMBER, cReciboPago VARCHAR2, dFecSts DATE, 
                                nPorcApl NUMBER, cIndPago VARCHAR2);
  PROCEDURE REVERSA_COMISION(nCodCia NUMBER, nIdPoliza NUMBER);
  PROCEDURE INSERTA_COMISION_NC(nIdNcr NUMBER);
  PROCEDURE INSERTAR_COMISION_FACT(nIdFactura NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, cCodMoneda VARCHAR,
                                   cCod_Agente VARCHAR2, nCodCia NUMBER, nCodEmpresa NUMBER,
                                   nMontoComiLocal NUMBER, nMontoComiMoneda NUMBER, nTasaCambio NUMBER,cOrigen varchar2,cIdTipoSeg VARCHAR2);
  PROCEDURE REVERSA_PAGO(nCodCia NUMBER, nIdFactura NUMBER);
  PROCEDURE REVERSA_DEVOLUCION(nCodCia NUMBER, nIdNcr NUMBER);
  PROCEDURE PAGA_ABONA_COMISION_NC(nIdNcr NUMBER, cReciboPago VARCHAR2, dFecSts DATE, 
                                   nPorcApl NUMBER, cIndPago VARCHAR2);
  FUNCTION  MONTO_COMISION(nCodCia NUMBER, nIdPoliza NUMBER, nCodNivel NUMBER, nCodAgente NUMBER, nIdFactura NUMBER DEFAULT NULL, nIdNcr NUMBER DEFAULT NULL) RETURN NUMBER;      
  PROCEDURE DISTRIBUCION_WEB(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,cCod_Agente VARCHAR2, nPorcApl NUMBER, nIdCotizacion NUMBER);

END OC_COMISIONES;
/
create or replace PACKAGE BODY oc_comisiones IS
    --
    -- MODIFICACION JICO  20160310  AJUSTE A COMISION POR ERROR AL 100 %   AJUS100
    -- SE ADICIONO UN JOIN CATALOGO_DE_CONCEPTOS PARA RECUPERAR EL SIGNO    JMMD20220125    
    --
    PROCEDURE DISTRIBUCION(nCodCia NUMBER, nIdPoliza NUMBER,cCod_Agente VARCHAR2, nPorcApl NUMBER) IS
    nDummy              NUMBER;
    cTipo_Agente        AGENTES.Tipo_Agente%TYPE;
    cJefe               VARCHAR2(1);
    nJefe               AGENTES.COD_AGENTE_JEFE%TYPE;
    nnJefe              AGENTES.COD_AGENTE_JEFE%TYPE;
    nAgente             AGENTES.COD_AGENTE_JEFE%TYPE;
    nNivel              NIVEL.CodNivel%TYPE;
    nSaldo              AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
    nComAgenteNivel     AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
    nComAgenteNivel1    AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
    nCodAgente          AGENTES.COD_AGENTE_JEFE%TYPE;
    cPlanCob            NIVEL_PLAN_COBERTURA.PLANCOB%TYPE;
    cIdTipoSeg          DETALLE_POLIZA.IdTipoSeg%TYPE;
    nComisionTotalPlan  AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
    nSumaComTotAge      AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
    nSumaComTotAge1     AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
    nProporcional       NUMBER(5,2);  
    --
    nCountPoliza        NUMBER(2);
    nComPoliza          AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
    cOrigen             AGENTES_DETALLES_POLIZAS.Origen%TYPE;
    nPorc_Comision      AGENTE_POLIZA.Porc_Comision%TYPE;
    WPORC_COM_PROPORCIONAL   AGENTES_DISTRIBUCION_POLIZA.PORC_COM_PROPORCIONAL%TYPE;    --AJUS100
    --
    BEGIN
       DECLARE
       eDist_Realizada EXCEPTION;
       BEGIN
          SELECT COUNT(*)
            INTO nCountPoliza
            FROM AGENTES_DISTRIBUCION_POLIZA
           WHERE CodCia   = nCodCia
             AND IdPoliza = nIdPoliza;
          IF nCountPoliza > 0 THEN
             RAISE eDist_Realizada;
          END IF;
       EXCEPTION
          WHEN eDist_Realizada THEN
             RAISE_APPLICATION_ERROR (-20100,'Distribución Realizada con anterioridad, debera elimiar la distribución actual para generar una nueva!'|| SQLERRM);
       END;

       BEGIN
          SELECT Origen, Porc_Comision
            INTO cOrigen, nPorc_Comision
            FROM AGENTE_POLIZA
           WHERE IdPoliza   = nIdPoliza
             AND Cod_Agente = cCod_Agente
             AND CodCia     = nCodCia;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'NO Existe el Origen del Agente Póliza '|| SQLERRM);
       END;

       DECLARE
       ePorcentaje EXCEPTION;
       BEGIN
          SELECT DISTINCT(DECODE(cOrigen,'H',PorcComisH, PorcComis))
            INTO nComPoliza
            FROM DETALLE_POLIZA
           WHERE CodCia   = nCodCia
             AND IdPoliza =  nIdPoliza;
          IF  nComPoliza IS NULL THEN
             RAISE ePorcentaje;
          END IF;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'Debe asignar un porcentaje en el Detalle de la Póliza...!!!'|| SQLERRM);
       END;
       BEGIN
          SELECT DISTINCT PlanCob, IdTipoSeg
            INTO cPlanCob, cIdTipoSeg
            FROM DETALLE_POLIZA
           WHERE IDPOLIZA = nIdPoliza;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'Favor Revise Certificados'|| SQLERRM);
       END;
       DECLARE
       eNivel EXCEPTION;
       BEGIN
          SELECT CodNivel
            INTO nNivel
            FROM AGENTES
           WHERE Cod_Agente = cCod_Agente;
          IF nNivel IS NULL THEN
             RAISE eNivel;
          END IF;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'Favor Revise Certificados!'|| SQLERRM);
       END;

       DECLARE
       eSumaComTotAge EXCEPTION;
       BEGIN
          SELECT SUM(ComAgeNivel)
            INTO nSumaComTotAge
            FROM NIVEL_PLAN_COBERTURA
           WHERE CodNivel <= nNivel
             AND Origen    = cOrigen
             AND IdTipoSeg = cIdTipoSeg
             AND PlanCob   = cPlanCob;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'Nivel Agente Invalido favor revisar Configuración!'|| SQLERRM);
       END;

       BEGIN
          SELECT 'S', AG.Cod_Agente, AG.Cod_Agente_Jefe JEFE, NPC.CodNivel, NPC.ComAgeNivel, NPC.PlanCob
            INTO cJefe,nCodagente, nJefe, nNivel, nComAgenteNivel, cPlanCob
            FROM AGENTES AG, AGENTES JF,  NIVEL_PLAN_COBERTURA NPC
           WHERE AG.Cod_Agente = JF.Cod_Agente
             AND AG.CodNivel   = NPC.CodNivel
             AND AG.Cod_Agente = cCod_Agente
             AND NPC.Origen    = cOrigen
             AND NPC.IdTipoSeg = cIdTipoSeg
             AND NPC.PlanCob   = cPlanCob;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'Nivel Agente Inválido favor revisar Configuración'|| SQLERRM);
       END;

       BEGIN
          SELECT NVL(SUM(ComAgeNivel),0)
            INTO nComisionTotalPlan
            FROM NIVEL_PLAN_COBERTURA
           WHERE PlanCob   = cPlanCob
             AND IdTipoSeg = cIdTipoSeg
             AND Origen    = cOrigen;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             nComisionTotalPlan := 0;
       END;
       --
       WPORC_COM_PROPORCIONAL := 0;      --AJUS100
       --
       IF NVL(nComPoliza,0) != 0 THEN
          IF cOrigen != 'H' THEN
             nProporcional := TRUNC(ROUND((nComAgenteNivel*100)/nComPoliza,2),2);
          ELSIF cOrigen = 'H' THEN
             nProporcional := TRUNC(ROUND((nPorc_Comision*100)/nComPoliza,2),2);
          END IF;
       ELSE
          nProporcional := 100;
       END IF;

       INSERT INTO AGENTES_DISTRIBUCION_POLIZA
              (CodCia, IdPoliza, Cod_Agente, CodNivel,
               Cod_Agente_Distr, Porc_Comision_Agente, Porc_Com_Distribuida, Porc_Comision_Plan,
               Porc_Com_Proporcional, Cod_Agente_Jefe, Porc_Com_Poliza, Origen)
       VALUES (nCodCia, nIdPoliza, cCod_Agente, nNivel,
               nCodAgente, nPorcApl, nComAgenteNivel, nComisionTotalPlan,
               nProporcional, nJefe, nComPoliza, cOrigen);
       --
       WPORC_COM_PROPORCIONAL := nProporcional;    -- AJUS100
       --
       WHILE cJefe = 'S' LOOP
          BEGIN
             SELECT AG.Cod_Agente, AG.Cod_Agente_Jefe JEFE, NPC.CodNivel, NPC.ComAgeNivel
               INTO nCodAgente, nnJefe,  nNivel, nComAgenteNivel
               FROM AGENTES AG, AGENTES JF,  NIVEL_PLAN_COBERTURA NPC
              WHERE AG.Cod_Agente = JF.Cod_Agente
                AND AG.CodNivel   = NPC.CodNivel
                AND AG.Cod_Agente = nJefe
                AND NPC.Origen    = cOrigen
                AND NPC.IdTipoSeg = cIdTipoSeg
                AND NPC.PlanCob   = cPlanCob;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                cJefe           := 'N';
                nComAgenteNivel := 0;
                nJefe           := NULL;
          END;
          IF NVL(nComPoliza,0) != 0 THEN
             nProporcional := nComAgenteNivel*100/nComPoliza;
          ELSE
             nProporcional := 0;
          END IF;

          IF nJefe IS NULL THEN
             EXIT;
          END IF;
          -- AJUS100 I
          WPORC_COM_PROPORCIONAL := WPORC_COM_PROPORCIONAL + nProporcional; 
          --
          IF (WPORC_COM_PROPORCIONAL > 100 AND WPORC_COM_PROPORCIONAL <= 100.01) THEN
             DBMS_OUTPUT.PUT_LINE('AJUSTADO -> '||WPORC_COM_PROPORCIONAL);
             WPORC_COM_PROPORCIONAL := WPORC_COM_PROPORCIONAL - 100;
             nProporcional := nProporcional - WPORC_COM_PROPORCIONAL;
          ELSIF
             (WPORC_COM_PROPORCIONAL < 100 AND WPORC_COM_PROPORCIONAL >= 99.99)  THEN
             DBMS_OUTPUT.PUT_LINE('AJUSTADO -> '||WPORC_COM_PROPORCIONAL);
             WPORC_COM_PROPORCIONAL := WPORC_COM_PROPORCIONAL - 100;
             nProporcional := nProporcional + WPORC_COM_PROPORCIONAL;
          END IF;
          -- AJUS100 F      
          INSERT INTO AGENTES_DISTRIBUCION_POLIZA
                 (codcia, idpoliza, cod_agente, codnivel,
                  cod_agente_distr, porc_comision_agente, porc_com_distribuida, porc_comision_plan,
                  porc_com_proporcional, cod_agente_jefe, porc_com_poliza, Origen)
          VALUES (nCodCia,nIdPoliza,cCod_Agente,nNivel,
                  nJefe,nPorcApl,nComAgenteNivel,nComisionTotalPlan,
                  ROUND(nProporcional,5),nnJefe,nComPoliza, cOrigen);
          nJefe := nnJefe;
       END LOOP;
    EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR (-20100,'Error en Distribución de Comisiones de Póliza '|| ' ' || SQLERRM);
    END DISTRIBUCION;

    PROCEDURE PAGA_ABONA_COMISION(nIdFactura NUMBER, cReciboPago VARCHAR2, dFecSts DATE,
                                  nPorcApl NUMBER, cIndPago VARCHAR2) IS
    BEGIN
       IF cIndPago = 'T' THEN
          UPDATE COMISIONES
             SET Num_Recibo       = cReciboPago,
                 Fec_Estado       = TRUNC(SYSDATE),
                 Estado           = 'REC',
                 Com_Saldo_Moneda = 0,
                 Com_Saldo_Local  = 0
           WHERE IdFactura = nIdFactura
             AND Estado   != 'LIQ';
       ELSE
            UPDATE COMISIONES
             SET Num_Recibo       = cReciboPago,
                 Fec_Estado       = TRUNC(SYSDATE),
                 Estado           = 'ABO',
                 Com_Saldo_Moneda = Com_Saldo_Moneda - ((Com_Saldo_Moneda * nPorcApl)/100),
                 Com_Saldo_Local  = Com_Saldo_Local - ((Com_Saldo_Local * nPorcApl)/100)
           WHERE IdFactura = nIdFactura
             AND Estado   != 'LIQ';
       END IF;

       FOR ENT IN (SELECT M.CODCIA, 
                       M.IDCOMISION, 
                       --M.IDPOLIZA, M.IDFACTURA, COUNT(*) NUM 
                       --A.NUM_DOC_IDENTIFICACION,
                       A.COD_AGENTE,
                       D.ORIGEN,
                       --ABS(ROUND(M.COMISION_LOCAL/D.MONTO_MON_LOCAL)) PORCANT,
                       --M.COMISION_LOCAL,
                       --D.MONTO_MON_LOCAL,
                       C.IdRegFisSAT, 

-----                       ROUND(M.COMISION_LOCAL   * (C.PORCCONCEPTO/100),2)    MONTO_MON_LOCAL_NEW,  
-----                       ROUND(M.COMISION_MONEDA  * (C.PORCCONCEPTO/100),2)    MONTO_MON_MONEDA_NEW
----- JMMD 20220125                       
                       DECODE(CC.Signo_Concepto,'+',(ROUND(M.COMISION_LOCAL   * (C.PORCCONCEPTO/100),2)*1),(ROUND(M.COMISION_LOCAL   * (C.PORCCONCEPTO/100),2)*-1))    MONTO_MON_LOCAL_NEW,  
                       DECODE(CC.Signo_Concepto,'+',(ROUND(M.COMISION_MONEDA  * (C.PORCCONCEPTO/100),2)*1),(ROUND(M.COMISION_MONEDA  * (C.PORCCONCEPTO/100),2)*-1))    MONTO_MON_MONEDA_NEW
----- JMMD 20220125 
                       --C.NIVELAUX
            FROM COMISIONES M  INNER JOIN DETALLE_COMISION           D ON D.CODCIA = M.CODCIA 
                                                                      AND D.IDCOMISION = M.IDCOMISION 
                                                                      AND CODCONCEPTO IN ('RETISR')
                               INNER JOIN AGENTES                    A ON A.COD_AGENTE = M.COD_AGENTE 
                                                                      AND A.CODCIA = M.CODCIA 
                                                                      AND A.CODEMPRESA = M.CODEMPRESA 
                               INNER JOIN PERSONA_NATURAL_JURIDICA   P ON P.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION
                                                                      AND P.NUM_DOC_IDENTIFICACION  = A.NUM_DOC_IDENTIFICACION
                               INNER JOIN CAT_REGIMEN_FISCAL         C ON C.IdRegFisSAT = P.IdRegFisSAT 
                                                                      AND NVL(C.PORCCONCEPTO,0) != 0   
                                                                      --AND ABS(ROUND(M.COMISION_LOCAL/D.MONTO_MON_LOCAL)) != NVL(C.PORCCONCEPTO,0)
                                                                      -- GRCA -Se pone el valor en duro, porque la columna sólo almacena dos dígitos y por ende se genera una división entre cero.
                                                                      AND DECODE(D.MONTO_MON_LOCAL,0,ABS(ROUND(M.COMISION_LOCAL/0.0016)),ABS(ROUND(M.COMISION_LOCAL/D.MONTO_MON_LOCAL))) != NVL(C.PORCCONCEPTO,0)                           
----- JMMD JMMD20220125
                               INNER JOIN CATALOGO_DE_CONCEPTOS      CC ON CC.CODCONCEPTO = 'RETISR' 
                                                                        AND CC.CODCIA = M.CODCIA                               
----- JMMD 20220125                                                                     
            WHERE M.COMISION_LOCAL > 0 
              AND M.Estado   != 'LIQ'
              --AND    M.IDPOLIZA = 41098
              AND M.IDFACTURA = nIdFactura) LOOP

            UPDATE DETALLE_COMISION D SET D.MONTO_MON_LOCAL =  ENT.MONTO_MON_LOCAL_NEW,
                                          D.MONTO_MON_EXTRANJERA =  ENT.MONTO_MON_MONEDA_NEW,
                                          D.IdRegFisSAT   = ENT.IdRegFisSAT
            WHERE D.CODCIA     = ENT.CODCIA
              AND D.IDCOMISION = ENT.IDCOMISION                                          
              AND D.CODCONCEPTO IN ('RETISR')
              AND D.ORIGEN = ENT.ORIGEN;

        END LOOP;              

    EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR (-20100,'Error en Abono de Comisiones de Factura ' ||nIdFactura || ' ' || SQLERRM);
    END PAGA_ABONA_COMISION;

    PROCEDURE REVERSA_COMISION(nCodCia NUMBER, nIdPoliza NUMBER) IS
    BEGIN
      DELETE DETALLE_COMISION
        WHERE CodCia = nCodCia
          AND IdComision IN(SELECT IdComision
                              FROM COMISIONES
                                WHERE CodCia   = nCodCia
                                  AND IdPoliza = nIdPoliza);
      DELETE FROM COMISIONES
        WHERE CodCia   = nCodCia
          AND IdPoliza = nIdPoliza;
    EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR (-20100,'Error al Reversar Comision ' || SQLERRM);
    END REVERSA_COMISION;

    PROCEDURE INSERTA_COMISION_NC(nIdNcr NUMBER) IS
    nIdComision        COMISIONES.IdComision%TYPE;
    nIdPoliza          DETALLE_POLIZA.IdPoliza%TYPE;
    nIDetPol           DETALLE_POLIZA.IDetPol%TYPE;
    nCodCia            DETALLE_POLIZA.CodCia%TYPE;
    nMtoComisi_Moneda  NOTAS_DE_CREDITO.MtoComisi_Moneda%TYPE;
    nMtoComisi_Local   NOTAS_DE_CREDITO.MtoComisi_Local%TYPE;
    nMonto_NCR_Local   NOTAS_DE_CREDITO.Monto_NCR_Local%TYPE;
    nMonto_NCR_Moneda  NOTAS_DE_CREDITO.Monto_NCR_Moneda%TYPE;

    CURSOR NOTA_Q IS
       SELECT N.IdPoliza, PO.Cod_Moneda, N.Cod_Agente, PO.CodCia, PO.CodEmpresa, N.IdetPol, N.MtoComisi_Local,
              N.MtoComisi_Moneda, N.Tasa_Cambio, N.IdNcr, N.Monto_NCR_Local, N.Monto_NCR_Moneda, DP.IdTipoSeg
         FROM NOTAS_DE_CREDITO N, POLIZAS PO, DETALLE_POLIZA DP
        WHERE DP.IDetPol  = N.IDetPol
          AND DP.IdPoliza = N.IdPoliza
          AND N.IdPoliza  = PO.IdPoliza
          AND N.IdNCr     = nIdNcr;

    CURSOR DIST_Q IS
      SELECT Cod_Agente_Distr Cod_Agente, Porc_Com_Proporcional Porc_Comision, Porc_Com_Distribuida, Origen
        FROM AGENTES_DISTRIBUCION_COMISION
       WHERE IdPoliza  = nIdPoliza
         AND IDetPol   = nIdetPol
         AND CodCia    = nCodCia;
    BEGIN
       FOR X IN NOTA_Q LOOP
          nIdPoliza   := X.IdPoliza;
          nIDetPol    := X.IDetPol;
          nCodCia     := X.CodCia;

          SELECT NVL(SUM(Monto_Det_Moneda),0), NVL(SUM(Monto_Det_Local),0)
            INTO nMonto_NCR_Moneda, nMonto_NCR_Local
            FROM DETALLE_NOTAS_DE_CREDITO D, NOTAS_DE_CREDITO N, CATALOGO_DE_CONCEPTOS C
           WHERE C.CodConcepto      = D.CodCpto
             AND C.CodCia           = N.CodCia
             AND (D.IndCptoPrima    = 'S'
              OR C.IndCptoServicio  = 'S')
             AND D.IdNcr            = N.IdNcr
             AND N.IdNcr            = X.IdNcr;

          FOR W IN DIST_Q LOOP
             nMtoComisi_Moneda := NVL(nMonto_NCR_Moneda,0) * (W.Porc_Com_Distribuida/100) * -1;
             nMtoComisi_Local  := NVL(nMonto_NCR_Local,0) * (W.Porc_Com_Distribuida/100) * -1;

             /*SELECT NVL(MAX(IdComision),0) + 1
               INTO nIdComision
               FROM COMISIONES;
               */
               /**  Cambio a Sequecia  XDS 20160719**/
                 SELECT SQ_IDCOMISION.NEXTVAL     
                 INTO nIDComision
                 FROM DUAL;

             INSERT INTO COMISIONES
                    (IdComision, IdPoliza, Cod_Moneda, Cod_Agente, CodCia, CodEmpresa, IdetPol,
                     Comision_Local, Comision_Moneda, Tasa_Cambio, IdNcr, Fec_Generacion,
                     Usuario_Genero, Estado, Fec_Estado, Origen)
             VALUES (nIdComision, X.IdPoliza, X.Cod_Moneda, W.Cod_Agente, X.CodCia, X.CodEmpresa, X.IdetPol,
                     nMtoComisi_Local, nMtoComisi_Moneda, X.Tasa_Cambio, X.IdNcr, SYSDATE,
                     USER, 'PRY', SYSDATE, W.Origen);
             OC_DETALLE_COMISION.INSERTA_DETALLE_COMISION(nCodCia, nIdPoliza, nIdComision, W.Origen, X.IdTipoSeg);
          END LOOP;

          SELECT NVL(SUM(Comision_Local),0), NVL(SUM(Comision_Moneda),0)
            INTO nMtoComisi_Local, nMtoComisi_Moneda
            FROM COMISIONES
           WHERE IdNcr = nIdNcr;

          UPDATE NOTAS_DE_CREDITO
             SET MtoComisi_Local  = nMtoComisi_Local,
                 MtoComisi_Moneda = nMtoComisi_Moneda
           WHERE IdNcr = nIdNcr;
       END LOOP;
    EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR (-20100,'Error al Insertar Comision de Nota de Credito '||nIdNcr|| ' ' || SQLERRM);
    END INSERTA_COMISION_NC;

    PROCEDURE INSERTAR_COMISION_FACT(nIdFactura NUMBER, nIdPoliza NUMBER, nIdetPol NUMBER, cCodMoneda VARCHAR,
                                     cCod_Agente VARCHAR2, nCodCia NUMBER, nCodEmpresa NUMBER,
                                     nMontoComiLocal NUMBER, nMontoComiMoneda NUMBER, nTasaCambio NUMBER, cOrigen VARCHAR2, cIdTipoSeg VARCHAR2) IS
    nIdComision   COMISIONES.IdComision%TYPE;
    cEstado       COMISIONES.Estado%TYPE;
    BEGIN

        /*SELECT NVL(MAX(IdComision),0) + 1
         INTO nIdComision
         FROM COMISIONES;*/
         /**  Cambio a Sequecia  XDS 20160719**/
            SELECT SQ_IDCOMISION.NEXTVAL     
            INTO nIDComision
            FROM DUAL;

       IF NVL(cOrigen,'C') IN ('C','U','H') THEN
         cEstado  := 'PRY';
       ELSE
         cEstado  := 'REC';
       END IF;
       INSERT INTO COMISIONES
             (IdPoliza, Cod_Moneda, IdFactura, Cod_Agente, CodCia, CodEmpresa,
              IdetPol, IdComision, Comision_Local, Comision_Moneda, Tasa_Cambio,
              Estado, Fec_Generacion, Usuario_Genero, Fec_Estado,
              Com_Saldo_Local, Com_Saldo_Moneda,Origen)
       VALUES(nIdPoliza, cCodMoneda, nIdFactura, cCod_Agente, nCodCia, nCodEmpresa,
              nIdetPol, nIdComision, nMontoComiLocal, nMontoComiMoneda, nTasaCambio,
              cEstado, SYSDATE, USER, SYSDATE, nMontoComiLocal, nMontoComiMoneda, NVL(cOrigen,'C'));
       OC_DETALLE_COMISION.INSERTA_DETALLE_COMISION(nCodCia, nIdPoliza, nIdComision, NVL(cOrigen,'C'), cIdTipoSeg);
    EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR (-20100,'Error al Insertar Comision de Factura '||nIdFactura|| ' ' || SQLERRM);
    END INSERTAR_COMISION_FACT;

    PROCEDURE REVERSA_PAGO(nCodCia NUMBER, nIdFactura NUMBER) IS
    BEGIN
       UPDATE COMISIONES
          SET Num_Recibo       = NULL,
              Fec_Estado       = TRUNC(SYSDATE),
              Estado           = 'PRY',
              Com_Saldo_Moneda = Comision_Moneda,
              Com_Saldo_Local  = Comision_Local
        WHERE IdFactura = nIdFactura
          AND CodCia    = nCodCia;
    END REVERSA_PAGO;

    PROCEDURE PAGA_ABONA_COMISION_NC(nIdNcr NUMBER, cReciboPago VARCHAR2, dFecSts DATE,
                                     nPorcApl NUMBER, cIndPago VARCHAR2) IS
    BEGIN
       IF cIndPago = 'T' THEN
          UPDATE COMISIONES
             SET Num_Recibo       = cReciboPago,
                 Fec_Estado       = TRUNC(SYSDATE),
                 Estado           = 'REC',
                 Com_Saldo_Moneda = 0,
                 Com_Saldo_Local  = 0
           WHERE IdNcr     = nIdNcr
             AND Estado   != 'LIQ';
       ELSE
            UPDATE COMISIONES
             SET Num_Recibo       = cReciboPago,
                 Fec_Estado       = TRUNC(SYSDATE),
                 Estado           = 'ABO',
                 Com_Saldo_Moneda = Com_Saldo_Moneda - ((Com_Saldo_Moneda * nPorcApl)/100),
                 Com_Saldo_Local  = Com_Saldo_Local - ((Com_Saldo_Local * nPorcApl)/100)
           WHERE IdNcr     = nIdNcr
             AND Estado   != 'LIQ';
       END IF;
    EXCEPTION
       WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR (-20100,'Error en Abono de Comisiones de Nota de Crédito ' ||nIdNcr || ' ' || SQLERRM);
    END PAGA_ABONA_COMISION_NC;

    PROCEDURE REVERSA_DEVOLUCION(nCodCia NUMBER, nIdNcr NUMBER) IS
    BEGIN
       UPDATE COMISIONES
          SET Num_Recibo       = NULL,
              Fec_Estado       = TRUNC(SYSDATE),
              Estado           = 'PRY',
              Com_Saldo_Moneda = Comision_Moneda,
              Com_Saldo_Local  = Comision_Local
        WHERE IdFactura = nIdNcr
          AND CodCia    = nCodCia;
    END REVERSA_DEVOLUCION;



    FUNCTION ID_COMISION RETURN NUMBER IS -- --IN SEQ XDS 19/07/2016
    nIDComisiones   COMISIONES.IDCOMISION%TYPE;
    BEGIN
        BEGIN
            SELECT SQ_IDCOMISION.NEXTVAL     
            INTO nIDComisiones
            FROM DUAL;

         EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN
             RAISE_APPLICATION_ERROR(-20225,'YA Existe la Secuencia ID_COMISION');
        END;
       RETURN(nIDComisiones);
    END ID_COMISION;                            --FIN SEQ XDS 19/07/2016                  

    FUNCTION  MONTO_COMISION(nCodCia NUMBER, nIdPoliza NUMBER, nCodNivel NUMBER, nCodAgente NUMBER, nIdFactura NUMBER DEFAULT NULL, nIdNcr NUMBER DEFAULT NULL) RETURN NUMBER IS
        nMontoComisionMoneda COMISIONES.COMISION_MONEDA%TYPE;
        nMtoComMonedaFact    COMISIONES.COMISION_MONEDA%TYPE;
        nMtoComMonedaNcr     COMISIONES.COMISION_MONEDA%TYPE;
    BEGIN
        IF nIdFactura IS NULL THEN
            SELECT NVL(SUM(C.Comision_Moneda),0) 
              INTO nMtoComMonedaFact
              FROM COMISIONES C, 
                   AGENTES_DISTRIBUCION_COMISION ADC 
             WHERE C.Cod_Agente   = nCodAgente
               AND C.CodCia       = nCodCia
               AND C.IdPoliza     = nIdPoliza
               AND ADC.CODNIVEL   = nCodNivel
               AND C.IdFactura    IS NOT NULL
               AND C.IdFactura    IN (SELECT IdFactura 
                                        FROM FACTURAS
                                       WHERE IdPoliza = nIdPoliza
                                         AND CodCia   = nCodCia)
               AND C.Cod_Agente   = ADC.Cod_Agente_Distr 
               AND C.IdPoliza     = ADC.IdPoliza 
               AND C.ESTADO       <> 'ANU';
        ELSE
            SELECT NVL(SUM(C.Comision_Moneda),0) 
              INTO nMtoComMonedaFact
              FROM COMISIONES C, 
                   AGENTES_DISTRIBUCION_COMISION ADC 
             WHERE C.Cod_Agente   = nCodAgente
               AND C.CodCia       = nCodCia
               AND C.IdPoliza     = nIdPoliza
               AND ADC.CODNIVEL   = nCodNivel
               AND C.IdFactura    = nIdFactura
               AND C.IdFactura    IN (SELECT IdFactura 
                                        FROM FACTURAS
                                       WHERE IdPoliza = nIdPoliza
                                         AND CodCia   = nCodCia)
               AND C.Cod_Agente   = ADC.Cod_Agente_Distr 
               AND C.IdPoliza     = ADC.IdPoliza 
               AND C.ESTADO       <> 'ANU';
        END IF;

        IF nIdNcr IS NULL THEN
            SELECT NVL(SUM(C.Comision_Moneda),0) 
              INTO nMtoComMonedaNcr
              FROM COMISIONES C, 
                   AGENTES_DISTRIBUCION_COMISION ADC 
             WHERE C.Cod_Agente   = nCodAgente
               AND C.CodCia       = nCodCia
               AND C.IdPoliza     = nIdPoliza
               AND ADC.CODNIVEL   = nCodNivel
               AND C.IdNcr        IS NOT NULL
               AND C.IdNcr        IN (SELECT IdFactura 
                                        FROM NOTAS_DE_CREDITO
                                       WHERE IdPoliza = nIdPoliza
                                         AND CodCia   = nCodCia)
               AND C.Cod_Agente   = ADC.Cod_Agente_Distr 
               AND C.IdPoliza     = ADC.IdPoliza 
               AND C.ESTADO       <> 'ANU';
        ELSE
             SELECT NVL(SUM(C.Comision_Moneda),0) 
              INTO nMtoComMonedaNcr
              FROM COMISIONES C, 
                   AGENTES_DISTRIBUCION_COMISION ADC 
             WHERE C.Cod_Agente   = nCodAgente
               AND C.CodCia       = nCodCia
               AND C.IdPoliza     = nIdPoliza
               AND ADC.CODNIVEL   = nCodNivel
               AND C.IdNcr        IS NOT NULL
               AND C.IdNcr        = nIdNcr
               AND C.Cod_Agente   = ADC.Cod_Agente_Distr 
               AND C.IdPoliza     = ADC.IdPoliza 
               AND C.ESTADO       <> 'ANU';
        END IF;

        nMontoComisionMoneda := nMtoComMonedaFact - nMtoComMonedaNcr;

        RETURN nMontoComisionMoneda;
    END MONTO_COMISION;

    PROCEDURE DISTRIBUCION_WEB(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,cCod_Agente VARCHAR2, nPorcApl NUMBER, nIdCotizacion NUMBER) IS 
    nDummy              NUMBER;
    cTipo_Agente        AGENTES.Tipo_Agente%TYPE;
    cJefe               VARCHAR2(1);
    nJefe               AGENTES.COD_AGENTE_JEFE%TYPE;
    nnJefe              AGENTES.COD_AGENTE_JEFE%TYPE;
    nAgente             AGENTES.COD_AGENTE_JEFE%TYPE;
    nNivel              NIVEL.CodNivel%TYPE;
    nSaldo              AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
    nComAgenteNivel     AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
    nComAgenteNivel1    AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
    nCodAgente          AGENTES.COD_AGENTE_JEFE%TYPE;
    cPlanCob            NIVEL_PLAN_COBERTURA.PLANCOB%TYPE;
    cIdTipoSeg          DETALLE_POLIZA.IdTipoSeg%TYPE;
    nComisionTotalPlan  AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
    nSumaComTotAge      AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
    nSumaComTotAge1     AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
    nProporcional       NUMBER(5,2);
    nCountPoliza        NUMBER(2);
    nComPoliza          AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
    cOrigen             AGENTES_DETALLES_POLIZAS.Origen%TYPE;
    nPorc_Comision      AGENTE_POLIZA.Porc_Comision%TYPE;
    WPORC_COM_PROPORCIONAL   AGENTES_DISTRIBUCION_POLIZA.PORC_COM_PROPORCIONAL%TYPE;    --AJUS100

    nPorcComisNivel1     COTIZACIONES.PorcComisDir%TYPE;
    nPorcComisNivel2     COTIZACIONES.PorcComisProm%TYPE;       
    nPorcComisNivel3     COTIZACIONES.PorcComisAgte%TYPE;
    --
    BEGIN
    
    INSERT INTO LOGS_REVISION VALUES('LOS VALORES RECIBIDOS EN EL PROCEDURE SICAS_OC.OC_COMISIONES.DISTRIBUCION_WEB ->  POLIZA: ' || nIdPoliza ||' AGENTE: ' ||cCod_Agente ||' PORCENTAJEAPLI: ' || nPorcApl ||' COTIZACION: ' ||nIdCotizacion);
    COMMIT;
    
       BEGIN
          SELECT COUNT(*)
            INTO nCountPoliza
            FROM AGENTES_DISTRIBUCION_POLIZA
           WHERE CodCia   = nCodCia
             AND IdPoliza = nIdPoliza;

          IF nCountPoliza > 0 THEN
             RAISE_APPLICATION_ERROR (-20100,'Distribución Realizada con anterioridad, debera elimiar la distribución actual para generar una nueva!'|| SQLERRM);
          END IF;
       END;

       BEGIN
          SELECT Origen, Porc_Comision
            INTO cOrigen, nPorc_Comision
            FROM AGENTE_POLIZA
           WHERE IdPoliza   = nIdPoliza
             AND Cod_Agente = cCod_Agente
             AND CodCia     = nCodCia;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'NO Existe el Origen del Agente Póliza '|| SQLERRM);
       END;

       BEGIN
          SELECT DISTINCT(DECODE(cOrigen,'H',PorcComisH, PorcComis))
            INTO nComPoliza
            FROM DETALLE_POLIZA
           WHERE CodCia     = nCodCia
             AND CodEmpresa = nCodEmpresa
             AND IdPoliza   = nIdPoliza;

          IF  nComPoliza IS NULL THEN
             RAISE_APPLICATION_ERROR (-20100,'Debe asignar un porcentaje en el Detalle de la Póliza...!!!'|| SQLERRM);
          END IF;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'Debe asignar un porcentaje en el Detalle de la Póliza...!!!'|| SQLERRM); 
       END;

       BEGIN
          SELECT PlanCob, IdTipoSeg
            INTO cPlanCob, cIdTipoSeg
            FROM COTIZACIONES
           WHERE CodCia        = nCodCia
             AND CodEmpresa = nCodEmpresa
             AND IdCotizacion  = nIdCotizacion;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'No se puede obtener el Tipo De Seguro y Plan de COberturas de la Cotizacion '|| nIdCotizacion);
       END;

       BEGIN    
          SELECT CodNivel
            INTO nNivel
            FROM AGENTES
           WHERE CodCia     = nCodCia
             AND CodEmpresa = nCodEmpresa
             AND Cod_Agente = cCod_Agente;
       EXCEPTION 
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'Agente '||cCod_Agente||' NO válido, por favor valide');
       END;

       BEGIN
          SELECT 'S', AG.Cod_Agente, AG.Cod_Agente_Jefe JEFE, NPC.CodNivel, NPC.ComAgeNivel, NPC.PlanCob
            INTO cJefe,nCodagente, nJefe, nNivel, nComAgenteNivel, cPlanCob
            FROM AGENTES AG, AGENTES JF,  NIVEL_PLAN_COBERTURA NPC
           WHERE AG.Cod_Agente = JF.Cod_Agente
             AND AG.CodNivel   = NPC.CodNivel
             AND AG.Cod_Agente = cCod_Agente
             AND NPC.Origen    = cOrigen
             AND NPC.IdTipoSeg = cIdTipoSeg
             AND NPC.PlanCob   = cPlanCob;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20100,'Nivel Agente Inválido favor revisar Configuración'|| SQLERRM);
       END;

       SELECT C.PorcComisDir, C.PorcComisProm, C.PorcComisAgte                                                       
         INTO nPorcComisNivel1, nPorcComisNivel2, nPorcComisNivel3
         FROM COTIZACIONES C
        WHERE C.CodCia          =   nCodCia
          AND C.CodEmpresa      =   nCodEmpresa
          AND C.IdCotizacion    =   nIdCotizacion;

       BEGIN
          SELECT NVL(SUM(ComAgeNivel),0)
            INTO nComisionTotalPlan
            FROM NIVEL_PLAN_COBERTURA
           WHERE CodCia     = nCodCia
             AND CodEmpresa = nCodEmpresa
             AND PlanCob    = cPlanCob
             AND IdTipoSeg  = cIdTipoSeg
             AND Origen     = cOrigen;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             nComisionTotalPlan := 0;
       END;
       --
       WPORC_COM_PROPORCIONAL := 0;      --AJUS100
       --
       IF NVL(nComPoliza,0) != 0 THEN
          IF cOrigen != 'H' THEN
            nProporcional := TRUNC(ROUND((nPorcComisNivel3*100)/nComPoliza,2),2);         
          ELSIF cOrigen = 'H' THEN
             nProporcional := TRUNC(ROUND((nPorc_Comision*100)/nComPoliza,2),2);
          END IF;
       ELSE
          nProporcional := 100;
       END IF;

       INSERT INTO AGENTES_DISTRIBUCION_POLIZA
              (CodCia, IdPoliza, Cod_Agente, CodNivel,
               Cod_Agente_Distr, Porc_Comision_Agente, Porc_Com_Distribuida, Porc_Comision_Plan,
               Porc_Com_Proporcional, Cod_Agente_Jefe, Porc_Com_Poliza, Origen)
       VALUES (nCodCia, nIdPoliza, cCod_Agente, nNivel,
               nCodAgente, nPorcApl, nComAgenteNivel, nComisionTotalPlan,
               nProporcional, nJefe, nComPoliza, cOrigen);
       --
       WPORC_COM_PROPORCIONAL := nProporcional;    -- AJUS100
       --
       WHILE cJefe = 'S' LOOP
          BEGIN
             SELECT AG.Cod_Agente, AG.Cod_Agente_Jefe JEFE, NPC.CodNivel, NPC.ComAgeNivel
               INTO nCodAgente, nnJefe,  nNivel, nComAgenteNivel
               FROM AGENTES AG, AGENTES JF,  NIVEL_PLAN_COBERTURA NPC
              WHERE AG.Cod_Agente = JF.Cod_Agente
                AND AG.CodNivel   = NPC.CodNivel
                AND AG.Cod_Agente = nJefe
                AND NPC.Origen    = cOrigen
                AND NPC.IdTipoSeg = cIdTipoSeg
                AND NPC.PlanCob   = cPlanCob;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                cJefe           := 'N';
                nComAgenteNivel := 0;
                nJefe           := NULL;
          END;

          IF NVL(nComPoliza,0) != 0 THEN
             IF nNivel = 2 THEN
                nProporcional := TRUNC(ROUND((nPorcComisNivel2*100)/nComPoliza,2),2); ---nPorcComisNivel2*100/nComPoliza;
             ELSIF nNivel = 1 THEN
                nProporcional := TRUNC(ROUND((nPorcComisNivel1*100)/nComPoliza,2),2); ---nPorcComisNivel2*100/nComPoliza;
             END IF;
          ELSE
             nProporcional := 0;
          END IF;

          IF nJefe IS NULL THEN
             EXIT;
          END IF;
          -- AJUS100 I
          BEGIN
            WPORC_COM_PROPORCIONAL := WPORC_COM_PROPORCIONAL + nProporcional; 
          EXCEPTION
            WHEN OTHERS THEN
               RAISE_APPLICATION_ERROR (-20100,'WPORC_COM_PROPORCIONAL--'||WPORC_COM_PROPORCIONAL);
          END;  
          --
     --     DBMS_OUTPUT.PUT_LINE('WPORC_COM_PROPORCIONAL '||WPORC_COM_PROPORCIONAL);
          IF (WPORC_COM_PROPORCIONAL > 100 AND WPORC_COM_PROPORCIONAL <= 100.01) THEN
          --   DBMS_OUTPUT.PUT_LINE('AJUSTADO -> '||WPORC_COM_PROPORCIONAL);
             WPORC_COM_PROPORCIONAL := WPORC_COM_PROPORCIONAL - 100;
             nProporcional := nProporcional - WPORC_COM_PROPORCIONAL;
          ELSIF
             (WPORC_COM_PROPORCIONAL < 100 AND WPORC_COM_PROPORCIONAL >= 99.99)  THEN
    --         DBMS_OUTPUT.PUT_LINE('AJUSTADO -> '||WPORC_COM_PROPORCIONAL);
             WPORC_COM_PROPORCIONAL := WPORC_COM_PROPORCIONAL - 100;
             nProporcional := nProporcional + WPORC_COM_PROPORCIONAL;
          END IF;

          -- AJUS100 F
          INSERT INTO AGENTES_DISTRIBUCION_POLIZA
                 (codcia, idpoliza, cod_agente, codnivel,
                  cod_agente_distr, porc_comision_agente, porc_com_distribuida, porc_comision_plan,
                  porc_com_proporcional, cod_agente_jefe, porc_com_poliza, Origen)
          VALUES (nCodCia,nIdPoliza,cCod_Agente,nNivel,
                  nJefe,nPorcApl,nComAgenteNivel,nComisionTotalPlan,
                  ROUND(nProporcional,5),nnJefe,nComPoliza, cOrigen);
          nJefe := nnJefe;
       END LOOP;
    EXCEPTION
       WHEN OTHERS THEN
        INSERT INTO LOGS_REVISION VALUES('LOS VALORES QUE SE IBAN A INSERTAR EN PROCEDURE SICAS_OC.OC_COMISIONES.DISTRIBUCION_WEB ->  nIdPoliza: ' || nIdPoliza ||' cCod_Agente: ' ||cCod_Agente ||' nNivel: ' || nNivel || 'nProporcional' || nProporcional);
        INSERT INTO LOGS_REVISION VALUES('LOS VALORES QUE SE IBAN A INSERTAR EN PROCEDURE SICAS_OC.OC_COMISIONES.DISTRIBUCION_WEB ->  nJefe: ' || nJefe ||' nPorcApl: ' ||nPorcApl ||' nComAgenteNivel: ' || nComAgenteNivel ||' nComisionTotalPlan: ' ||nComisionTotalPlan||' ROUND(nProporcional,5): ' || ROUND(nProporcional,5) ||' nnJefe: ' ||nnJefe||nComisionTotalPlan||' nComPoliza: ' || nComPoliza ||' cOrigen: ' ||cOrigen);
        COMMIT;
        RAISE_APPLICATION_ERROR (-20100,'Error en Distribución de Comisiones de Póliza '|| ' ' || SQLERRM);

    END DISTRIBUCION_WEB;

END OC_COMISIONES;
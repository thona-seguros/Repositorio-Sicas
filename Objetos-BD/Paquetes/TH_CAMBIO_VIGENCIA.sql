CREATE OR REPLACE PACKAGE TH_CAMBIO_VIGENCIA IS

FUNCTION VALIDA_POLIZA(nCODCIA NUMBER, nCODEMPRESA NUMBER, nIDPOLIZA NUMBER, cNUREMESA VARCHAR2, PMENSAJE OUT VARCHAR2, nIdendoso OUT NUMBER) RETURN VARCHAR2;

PROCEDURE EMITIR_VIGENCIA_POLIZA(nCODCIA NUMBER, nCODEMPRESA NUMBER, nIDPOLIZA NUMBER, cNUREMESA VARCHAR2, PMENSAJE OUT VARCHAR2);

PROCEDURE GENERA_COMISIONES_LARPLA(nCODCIA NUMBER, nCODEMPRESA NUMBER, nIDPOLIZA NUMBER, cCod_Agente NUMBER, NPORCAPL NUMBER, nAÑO_POLIZA NUMBER, nIdendoso OUT NUMBER);

PROCEDURE ENDOSO_CAMBIO_VIGENCIA (nCODCIA NUMBER, nCODEMPRESA NUMBER, nIDPOLIZA NUMBER, nAÑO_POLIZA NUMBER, nIdendoso OUT NUMBER);
    
END TH_CAMBIO_VIGENCIA;
/
CREATE OR REPLACE PACKAGE BODY TH_CAMBIO_VIGENCIA IS
--
-- BITACORA DE CAMBIO
-- 
FUNCTION VALIDA_POLIZA(nCODCIA NUMBER, nCODEMPRESA NUMBER, nIDPOLIZA NUMBER, cNUREMESA VARCHAR2, PMENSAJE OUT VARCHAR2,nIdendoso OUT NUMBER) RETURN VARCHAR2 IS
--
nPorc_Com_Proporcional      AGENTES_DISTRIBUCION_COMISION.Porc_Com_Proporcional%TYPE;
nPorc_Com_Distribuida       AGENTES_DISTRIBUCION_COMISION.Porc_Com_Distribuida%TYPE;
nEmite                      VARCHAR2(1);
cMensaje                    VARCHAR2(300);                   
--
cPLDSTAPROBADA              RENO_CTRL.PLDSTAPROBADA%TYPE;
cST_RENOVA                  RENO_CTRL.ST_RENOVA%TYPE; 
nCODCLIENTE                 POLIZAS.CodCliente%TYPE;
nAÑO_POLIZA_SIGUENTE        NUMBER := 0;
dFECRENOVACION              POLIZAS.FECRENOVACION%TYPE;
nCOD_AGENTE                 AGENTES_DISTRIBUCION_POLIZA.COD_AGENTE%TYPE;
nPORC_COMISION              AGENTES_DISTRIBUCION_POLIZA.PORC_COMISION_AGENTE%TYPE;
--
CURSOR DET_Q IS
   SELECT D.CodEmpresa,               D.Cod_Asegurado, 
          D.IDetPol,                  D.PorcComis,
          D.IndFactElectronica,       D.FecIniVig, 
          D.FecFinVig,                A.Tipo_Doc_Identificacion, 
          A.Num_Doc_IDentificacion,   D.IdTipoSeg, 
          D.PlanCob,                  D.IdFormaCobro
     FROM DETALLE_POLIZA D, ASEGURADO A
    WHERE A.Cod_Asegurado = D.Cod_Asegurado
      AND D.CodCia        = nCodCia
      AND D.IdPoliza      = nIdPoliza
      AND D.StsDetalle   IN ('EMI');  --POR SER CAMBIO DE VIGENCIA
--      
CURSOR AGT_Q IS
   SELECT DISTINCT Cod_Agente,  
          Cod_Agente_Distr, 
          Porc_Comision_Agente,
          Porc_Com_Distribuida,  
          Porc_Com_Proporcional,
          CODNIVEL,
          PORC_COM_POLIZA,
          ORIGEN
     FROM AGENTES_DISTRIBUCION_POLIZA
    WHERE IdPoliza = nIdPoliza
      AND CodCia   = nCodCia;
BEGIN
  --
  nEmite := 'N';
  --  
  SELECT P.CodCliente,
         NVL(P.Pldstaprobada,'N'),
         P.StsPoliza,
         (TO_NUMBER(TO_CHAR(P.FECRENOVACION,'YYYY')) - TO_NUMBER(TO_CHAR(P.FECINIVIG,'YYYY'))) + 1,
         P.FECRENOVACION,
         AP.COD_AGENTE,
         AP.PORC_COMISION
    INTO nCODCLIENTE,
         cPLDSTAPROBADA,
         cST_RENOVA,
         nAÑO_POLIZA_SIGUENTE,
         dFECRENOVACION,
         NCOD_AGENTE,
         NPORC_COMISION
    FROM RENO_CTRL R,
         POLIZAS   P,
         AGENTE_POLIZA AP
   WHERE R.ID_CODCIA = nCODCIA
     AND R.NU_REMESA = cNUREMESA
     AND R.ID_POLIZA  = nIDPOLIZA
     --
     AND P.IDPOLIZA = R.ID_POLIZA
     AND P.CODCIA   = R.ID_CODCIA
     --
     AND AP.IDPOLIZA = P.IDPOLIZA
     AND AP.CODCIA   = P.CODCIA;
  --
  IF cST_RENOVA = 'PLD'  THEN                             
     PMENSAJE := 'La poliza es PLD';
     RAISE_APPLICATION_ERROR(-20200,PMENSAJE); 
  ELSIF cST_RENOVA = 'ANU'  THEN                         
     PMENSAJE := 'La poliza esta anulada';
     RAISE_APPLICATION_ERROR(-20200,PMENSAJE); 
  END IF;                                                  
  -- LAVDIN
  IF NVL(nCODCLIENTE,0) != 0 THEN
     IF cPLDSTAPROBADA = 'N'  THEN
        OC_ADMON_RIESGO.VALIDA_PERSONAS_LARGO_PLAZO(nIDPOLIZA,cMensaje);
        IF cMensaje IS NOT NULL THEN
           PMENSAJE := cMensaje;
        END IF;
     END IF;
  ELSE
     PMENSAJE := 'Póliza No. '||nIDPOLIZA||' NO tiene Código de Cliente o Contratante - NO Puede Emitir la Póliza';
  END IF;
  --
  -- RECALCULA LAS COMISIONES
  --
  IF PMENSAJE IS NULL THEN 
     GENERA_COMISIONES_LARPLA(nCODCIA, nCODEMPRESA, nIDPOLIZA, NCOD_AGENTE, NPORC_COMISION, nAÑO_POLIZA_SIGUENTE,nIdendoso);
     --
     FOR W IN DET_Q LOOP
         FOR R IN AGT_Q LOOP
             --
             SELECT NVL(SUM(Porc_Com_Proporcional),0)
               INTO nPorc_Com_Proporcional
               FROM AGENTES_DISTRIBUCION_COMISION
              WHERE IdPoliza   = nIDPOLIZA
                AND IDetPol    = W.IDetPol
                AND CodCia     = nCodCia
                AND Cod_Agente = R.Cod_Agente;
             --
             IF NVL(nPorc_Com_Proporcional,0) != 100 THEN
                PMENSAJE := 'La Distribución del Agente '||R.Cod_Agente||' en el Detalle No. '||W.IDetPol||
                            ' Porc.com.propor - '||nPorc_Com_Proporcional||
                            ' NO tiene el 100% de Distribución para Comisiones';
             END IF;
             --
             SELECT NVL(SUM(Porc_Com_Distribuida),0)
               INTO nPorc_Com_Distribuida
               FROM AGENTES_DISTRIBUCION_COMISION
              WHERE IdPoliza = nIDPOLIZA
                AND IDetPol  = W.IDetPol
                AND CodCia   = nCodCia;
             --
             IF NVL(nPorc_Com_Distribuida,0) != W.PorcComis THEN
                PMENSAJE := 'La Distribución de Agentes en el Detalle No. ' || W.IDetPol ||
                            ' NO Corresponde con el % de Comisión del Detalle/Subgrupo del ' || W.PorcComis || '%';
             END IF;
             --
         END LOOP;
     END LOOP;
  END IF;
  --
  nEmite := 'S';
  RETURN(nEmite);
END VALIDA_POLIZA;


PROCEDURE EMITIR_VIGENCIA_POLIZA(nCODCIA NUMBER, nCODEMPRESA NUMBER, nIDPOLIZA NUMBER, cNUREMESA VARCHAR2, PMENSAJE OUT VARCHAR2) IS
nPorcAgtes       NUMBER;
cPrima           POLIZAS.PrimaNeta_Local%TYPE;
nIdTransac       TRANSACCION.IdTransaccion%TYPE;
cTipoPol         POLIZAS.TipoPol%TYPE;
cCodPlanPago     POLIZAS.CodPlanPago%TYPE;
cNumPolRef       POLIZAS.NumPolRef%TYPE;
cIndPolCol       POLIZAS.IndPolCol%TYPE;
cIndFactPeriodo  POLIZAS.IndFactPeriodo%TYPE;
cIndFacturaPol   POLIZAS.IndFacturaPol%TYPE;
nNum_Cotizacion  POLIZAS.Num_Cotizacion%TYPE;
NIDENDOSO        ENDOSOS.IDENDOSO%TYPE;  
--
CURSOR DET_Q IS
   SELECT IDetPol, IndDeclara, Cod_Asegurado, HabitoTarifa
     FROM DETALLE_POLIZA
    WHERE IdPoliza = nIdPoliza
      AND CodCia   = nCodCia;
      
--      
BEGIN
   SELECT TipoPol,         CodPlanPago,      NumPolRef,   IndPolCol,
          IndFactPeriodo,  IndFacturaPol,    Num_Cotizacion
     INTO cTipoPol,        cCodPlanPago,     cNumPolRef,  cIndPolCol,
          cIndFactPeriodo, cIndFacturaPol,   nNum_Cotizacion
     FROM POLIZAS
    WHERE IdPoliza = nIdPoliza
      AND CodCia   = nCodCia;
   --
   IF TH_CAMBIO_VIGENCIA.VALIDA_POLIZA(nCODCIA , nCODEMPRESA , nIDPOLIZA , cNUREMESA, PMENSAJE, NIDENDOSO) = 'S' THEN
DBMS_OUTPUT.PUT_LINE('SI EMITE ');          
      FOR X IN DET_Q LOOP
         nPorcAgtes := 0;
         BEGIN
             SELECT SUM(Porc_Comision)
               INTO nPorcAgtes
               FROM AGENTES_DETALLES_POLIZAS
              WHERE IdPoliza = nIdPoliza
                AND IdetPol  = X.IDetPol
                AND CodCia   = nCodCia;
         END;
         --
         IF NVL(nPorcAgtes,0) != 100 THEN
             PMENSAJE := 'No puede Emitir la Póliza porque el Detalle de Póliza No. '|| X.IdetPol ||
                                     ', Suma ' || NVL(nPorcAgtes,0) ||' en los Agentes Participantes';
         END IF;
      END LOOP;
      --
      SELECT SUM(PrimaNeta_Local)
        INTO cPrima
        FROM POLIZAS
       WHERE IdPoliza = nIdPoliza;
      --
--      IF cIndFacturaPol = 'S' THEN
         nIdTransac := OC_TRANSACCION.CREA(nCodCia,  nCodEmpresa, 7, 'POL');
         OC_DETALLE_TRANSACCION.CREA (nIdTransac, nCodCia, nCodEmpresa, 7, 'POL', 'POLIZAS',
                                      nIdPoliza, NULL, NULL, NULL, cPrima);
         --
         OC_FACTURAR.PROC_EMITE_FACT_CAM(nIdPoliza, NIDENDOSO, nCodCia, nIdTransac);
--      ELSE
--         IF cCodPlanPago IS NOT NULL AND cTipoPol != 'F' THEN
--            nIdTransac :=  OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 7, 'POL');
--            OC_DETALLE_TRANSACCION.CREA (nIdTransac, nCodCia, nCodEmpresa, 7, 'POL', 'POLIZAS',
--                                         nIdPoliza, NULL, NULL, NULL, cPrima);
--            --
--            IF NVL(cIndFactPeriodo,'N') = 'N' THEN
--               IF cIndDeclara = 'S' THEN
--                  OC_FACTURAR.PROC_EMITE_FACT_MENSUAL(nIdPoliza, NIDENDOSO, nCodCia, nIdTransac,1);
--               ELSE
--                 OC_FACTURAR.PROC_EMITE_FACTURAS(nIdPoliza, NIDENDOSO, nCodCia, nIdTransac);
--               END IF;
--            ELSE
--               OC_FACTURAR.PROC_EMITE_FACT_PERIODO(nIdPoliza, NIDENDOSO, nCodCia, nIdTransac,1);
--            END IF;
--         END IF;
--      END IF;
      -- 
      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransac, 'C');
      --
      -- ACTUALIZA DETALLE DE POLIZA
      --
      UPDATE POLIZAS P
         SET P.STSPOLIZA = 'EMI'
       WHERE P.IdPoliza = nIdPoliza
         AND P.CodCia   = nCodCia;
      --
   END IF;
END EMITIR_VIGENCIA_POLIZA;


PROCEDURE GENERA_COMISIONES_LARPLA(nCODCIA NUMBER, nCODEMPRESA NUMBER, nIDPOLIZA NUMBER, cCod_Agente NUMBER, NPORCAPL NUMBER, nAÑO_POLIZA NUMBER, nIdendoso OUT NUMBER) IS
--
cJefe               VARCHAR2(1);
nJefe               AGENTES.COD_AGENTE_JEFE%TYPE;
nnJefe              AGENTES.COD_AGENTE_JEFE%TYPE;
nNivel              NIVEL.CodNivel%TYPE;
nComAgenteNivel     AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
nCodAgente          AGENTES.COD_AGENTE_JEFE%TYPE;
cPlanCob            NIVEL_PLAN_COBERTURA.PLANCOB%TYPE;
cIdTipoSeg          DETALLE_POLIZA.IdTipoSeg%TYPE;
nComisionTotalPlan  AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
nProporcional       AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
nComPoliza          AGENTES_DETALLES_POLIZAS.PORC_COMISION%TYPE;
cOrigen             AGENTES_DETALLES_POLIZAS.Origen%TYPE;
nPorc_Comision      AGENTE_POLIZA.Porc_Comision%TYPE;
WPORC_COM_PROPORCIONAL   AGENTES_DISTRIBUCION_POLIZA.PORC_COM_PROPORCIONAL%TYPE;
WPORC_COM_DISTRIBUIDA    AGENTES_DISTRIBUCION_POLIZA.PORC_COM_DISTRIBUIDA%TYPE;
--
CURSOR RESPALDO IS
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
  WHERE CODCIA     = nCodCia
    AND IDPOLIZA   = nIdPoliza
    AND COD_AGENTE = cCod_Agente;
--
CURSOR DET_Q IS
 SELECT IDetPol
   FROM DETALLE_POLIZA
  WHERE IdPoliza = nIdPoliza
    AND CodCia   = nCodCia;
--
BEGIN
  --
  BEGIN
    SELECT Origen,  
           Porc_Comision
      INTO cOrigen, 
           nPorc_Comision
      FROM AGENTE_POLIZA
     WHERE IdPoliza   = nIdPoliza
       AND Cod_Agente = cCod_Agente
       AND CodCia     = nCodCia;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'NO Existe el Origen del Agente Póliza '|| SQLERRM);
  END;
  --
  BEGIN
    SELECT DISTINCT IdTipoSeg, 
           PlanCob
      INTO cIdTipoSeg,         
           cPlanCob
      FROM DETALLE_POLIZA
     WHERE IDPOLIZA = nIdPoliza;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'Certificados en DETALLE_POLIZA no existentes'|| SQLERRM);
  END;
  --
  BEGIN
    SELECT SUM(NVL(L.PORCCOMISION,0)),
           SUM(NVL(L.PORCCOMISION,0))
      INTO nComPoliza,
           nComisionTotalPlan
      FROM COMISION_PLACOB_LARPLA L
     WHERE IDTIPOSEG = cIdTipoSeg 
       AND PLANCOB   = cPlanCob
       AND ID_AÑO    = nAÑO_POLIZA;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'Porcentaje en COMISION_PLACOB_LARPLA no definido'|| SQLERRM);
  END;
  --
  BEGIN
    SELECT CodNivel
      INTO nNivel
      FROM AGENTES
     WHERE Cod_Agente = cCod_Agente;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'Nivel de agente no definido!'|| SQLERRM);
  END;
  --
  BEGIN
    SELECT 'S',                 AG.Cod_Agente, 
           AG.Cod_Agente_Jefe,  CPL.CODNIVEL, 
           CPL.PORCCOMISION,    CPL.PLANCOB
      INTO cJefe,               nCodagente, 
           nJefe,               nNivel, 
           nComAgenteNivel,     cPlanCob
      FROM AGENTES AG,  
           AGENTES JF,  
           COMISION_PLACOB_LARPLA CPL
     WHERE AG.Cod_Agente = JF.Cod_Agente
       AND AG.CodNivel   = CPL.CODNIVEL
       AND AG.Cod_Agente = cCod_Agente
       AND CPL.ORIGEN    = cOrigen
       AND CPL.IDTIPOSEG = cIdTipoSeg
       AND CPL.PLANCOB   = cPlanCob
       AND CPL.ID_AÑO    = nAÑO_POLIZA;       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'Nivel Agente Inválido favor revisar Configuración'|| SQLERRM);
  END;
  --
  WPORC_COM_PROPORCIONAL := 0;
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
  --
  -- RESPALDO DE INFORMACION 
  --
  FOR R IN RESPALDO LOOP
     INSERT INTO CAMCAR_PORCEN
       (CODCIA,                 CODEMPRESA,            IDPOLIZA,
        COD_AGENTE,             CODNIVEL,              COD_AGENTE_DISTR,
        PORC_COMISION_AGENTE,   PORC_COM_DISTRIBUIDA,  PORC_COMISION_PLAN,
        PORC_COM_PROPORCIONAL,  COD_AGENTE_JEFE,       PORC_COM_POLIZA,
        ORIGEN,                 ID_TP_AGENTES,         FE_CAMBIO,
        HR_CAMBIO,              ID_AÑO,                TP_MOVTO)
     VALUES
       (R.CODCIA,                nCodEMPRESA,             R.IDPOLIZA,
        R.COD_AGENTE,            R.CODNIVEL,              R.COD_AGENTE_DISTR,
        R.PORC_COMISION_AGENTE,  R.PORC_COM_DISTRIBUIDA,  R.PORC_COMISION_PLAN,
        R.PORC_COM_PROPORCIONAL, R.COD_AGENTE_JEFE,       R.PORC_COM_POLIZA,
        R.ORIGEN,                'A',                     TRUNC(SYSDATE),
        SYSDATE,                 nAÑO_POLIZA,             'LARPLA');
  END LOOP;
  --
  -- BORRADO DE CALCULO ACTUAL
  --
  DELETE AGENTES_DISTRIBUCION_POLIZA ADP
   WHERE CODCIA     = nCodCia
     AND IDPOLIZA   = nIdPoliza
     AND COD_AGENTE = cCod_Agente;
  -- 
  DELETE AGENTES_DISTRIBUCION_COMISION ADC
   WHERE CODCIA     = nCodCia
     AND IDPOLIZA   = nIdPoliza
     AND COD_AGENTE = cCod_Agente;
  --
  -- CALCULO DE COMISIONES SIGUIENTE AÑO
  --
  INSERT INTO AGENTES_DISTRIBUCION_POLIZA
    (CodCia,               IdPoliza,           Cod_Agente, 
     CodNivel,             Cod_Agente_Distr,   Porc_Comision_Agente,
     Porc_Com_Distribuida, Porc_Comision_Plan, Porc_Com_Proporcional, 
     Cod_Agente_Jefe,      Porc_Com_Poliza,    Origen)
  VALUES 
    (nCodCia,              nIdPoliza,          cCod_Agente,
     nNivel,               nCodAgente,         nPorcApl,
     nComAgenteNivel,      nComisionTotalPlan, nProporcional,
     nJefe,                nComPoliza,         cOrigen);
  --
  WPORC_COM_PROPORCIONAL := nProporcional;
  --
  WHILE cJefe = 'S' LOOP
    BEGIN
      SELECT AG.Cod_Agente,    AG.Cod_Agente_Jefe,  
             CPL.CODNIVEL,     CPL.PORCCOMISION
        INTO nCodAgente,       nnJefe,  
             nNivel,           nComAgenteNivel
        FROM AGENTES AG,  
             AGENTES JF,  
             COMISION_PLACOB_LARPLA CPL
       WHERE AG.Cod_Agente = JF.Cod_Agente
         AND AG.CodNivel   = CPL.CODNIVEL
         AND AG.Cod_Agente = nJefe
         AND CPL.ORIGEN    = cOrigen
         AND CPL.IDTIPOSEG = cIdTipoSeg
         AND CPL.PLANCOB   = cPlanCob
         AND CPL.ID_AÑO    = nAÑO_POLIZA;     
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           cJefe           := 'N';
           nComAgenteNivel := 0;
           nJefe           := NULL;
    END;
    --
    IF NVL(nComPoliza,0) != 0 THEN
       nProporcional := nComAgenteNivel*100/nComPoliza;
    ELSE
       nProporcional := 0;
    END IF;
    --
    IF nJefe IS NULL THEN
       EXIT;
    END IF;
    --
    WPORC_COM_PROPORCIONAL := WPORC_COM_PROPORCIONAL + nProporcional; 
    --
    IF (WPORC_COM_PROPORCIONAL > 100 AND WPORC_COM_PROPORCIONAL <= 100.01) THEN
        WPORC_COM_PROPORCIONAL := WPORC_COM_PROPORCIONAL - 100;
        nProporcional := nProporcional - WPORC_COM_PROPORCIONAL;
    ELSIF
       (WPORC_COM_PROPORCIONAL < 100 AND WPORC_COM_PROPORCIONAL >= 99.99)  THEN
        WPORC_COM_PROPORCIONAL := WPORC_COM_PROPORCIONAL - 100;
        nProporcional := nProporcional + WPORC_COM_PROPORCIONAL;
    END IF;
    --
    INSERT INTO AGENTES_DISTRIBUCION_POLIZA
      (codcia,               idpoliza,           cod_agente,           
       codnivel,             cod_agente_distr,   porc_comision_agente, 
       porc_com_distribuida, porc_comision_plan, porc_com_proporcional,
       cod_agente_jefe,      porc_com_poliza,    Origen)
    VALUES 
      (nCodCia,              nIdPoliza,          cCod_Agente,
       nNivel,               nJefe,              nPorcApl,
       nComAgenteNivel,      nComisionTotalPlan, nProporcional,
       nnJefe,               nComPoliza,         cOrigen);
    --
    nJefe := nnJefe;
    --
  END LOOP;
  -- 
  -- AGENTES_DISTRIBUCION_COMISION
  --
  --
  FOR D IN DET_Q LOOP  
      --
      WPORC_COM_DISTRIBUIDA := 0;
      --
      FOR R IN RESPALDO LOOP
          INSERT INTO AGENTES_DISTRIBUCION_COMISION
           (CODCIA,                 IDPOLIZA,              IDETPOL,
            CODNIVEL,               COD_AGENTE,            COD_AGENTE_DISTR,
            PORC_COMISION_PLAN,     PORC_COMISION_AGENTE,  PORC_COM_DISTRIBUIDA,
            PORC_COM_PROPORCIONAL,  COD_AGENTE_JEFE,       ORIGEN)
          VALUES
           (R.CODCIA,                R.IDPOLIZA,              D.IDETPOL,
            R.CODNIVEL,              R.COD_AGENTE,            R.COD_AGENTE_DISTR,
            R.PORC_COMISION_PLAN,    R.PORC_COMISION_AGENTE,  R.PORC_COM_DISTRIBUIDA, 
            R.PORC_COM_PROPORCIONAL, R.COD_AGENTE_JEFE,       R.ORIGEN);
          --
          WPORC_COM_DISTRIBUIDA := WPORC_COM_DISTRIBUIDA + R.PORC_COM_DISTRIBUIDA;
      END LOOP;
      --
      -- ACTUALIZA DETALLE DE POLIZA
      --
      UPDATE DETALLE_POLIZA DP
         SET DP.PORCCOMIS = WPORC_COM_DISTRIBUIDA
       WHERE DP.IdPoliza = nIdPoliza
         AND DP.CodCia   = nCodCia
         AND DP.IDETPOL  = D.IDETPOL;
      --
      -- ACTUALIZA DETALLE DE POLIZA
      --
      UPDATE POLIZAS P
         SET P.STSPOLIZA = 'XRE'   --OJO VER RESULTADO
       WHERE P.IdPoliza = nIdPoliza
         AND P.CodCia   = nCodCia;
      --
      -- CREA ENDOSO
      --
      ENDOSO_CAMBIO_VIGENCIA(nCODCIA, nCODEMPRESA, nIDPOLIZA, nAÑO_POLIZA, nIdendoso);
      --
  END LOOP;
  --
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR (-20100,'Error en Distribución de Comisiones de Póliza '|| ' ' || SQLERRM);
END GENERA_COMISIONES_LARPLA;
--
--
--
PROCEDURE ENDOSO_CAMBIO_VIGENCIA (nCODCIA NUMBER, nCODEMPRESA NUMBER, nIDPOLIZA NUMBER, nAÑO_POLIZA NUMBER, nIdendoso OUT NUMBER) IS
      
 nIDetPol          ENDOSOS.IDETPOL%TYPE;
 cTipoEndoso       ENDOSOS.TIPOENDOSO%TYPE;       
 cNumEndRef        ENDOSOS.NUMENDREF%TYPE;
 dFecIniVig        ENDOSOS.FECINIVIG%TYPE;
 dFecFinVig        ENDOSOS.FECFINVIG%TYPE;
 cCodPlan          ENDOSOS.CODPLANPAGO%TYPE;
 nSuma_Aseg_Moneda ENDOSOS.SUMA_ASEG_LOCAL%TYPE;
 nPrima_Moneda     ENDOSOS.PRIMA_NETA_LOCAL%TYPE;
 nPorcComis        ENDOSOS.PORCCOMIS%TYPE;
 CMOTIVO_ENDOSO    ENDOSOS.MOTIVO_ENDOSO%TYPE;
 dFecExc           ENDOSOS.FECEXC%TYPE;
 cUsuario          VARCHAR2(20);
 cTerminal         VARCHAR2(20);
 CAGENTE           AGENTE_POLIZA.COD_AGENTE%TYPE;
 CCOD_AGENTE_JEFE  AGENTES_DISTRIBUCION_POLIZA.COD_AGENTE_JEFE%TYPE;
 CLINEA            VARCHAR2(20);
 CLINEA_T          VARCHAR2(500);
BEGIN
	--
  CMOTIVO_ENDOSO := '034';  -- EN CATALOGO 'CAMBIO DE VIGENCIA POR AÑOS SUBSECUENTES'
  --
  BEGIN
	  SELECT P.FECRENOVACION,
           ADD_MONTHS(P.FECRENOVACION,12)
	    INTO dFecIniVig,
           dFecFinVig
      FROM POLIZAS P
     WHERE IDPOLIZA = nIDPOLIZA
       AND CODCIA   = nCODCIA;
	EXCEPTION
	  WHEN OTHERS THEN 
	       NULL;
	END;
	--
  SELECT USER,     USERENV('TERMINAL') 
    INTO cUsuario, cTerminal 
    FROM SYS.DUAL;
  --
  SELECT NVL(MAX(IdEndoso),0) + 1
    INTO nIdendoso
    FROM ENDOSOS
   WHERE IDPOLIZA = nIDPOLIZA;
  --
  nIDetPol          := 1;   -- SE LIGA POR DEFAUL AL DETALLE 1
  cTipoEndoso       := 'CAM';
  cNumEndRef        := 'END-' ||nIdPoliza||'-'||nIDENDOSO;
  cCodPlan          := '';
  nSuma_Aseg_Moneda := 0;
  nPrima_Moneda     := 0;
  nPorcComis        := 0;
  dFecExc           := '';
  --
  OC_ENDOSO.INSERTA(nCodCia,            nCodEmpresa,             nIdPoliza, 
                    nIDetPol,           nIdendoso,               cTipoEndoso,    
                    cNumEndRef,         dFecIniVig,              dFecFinVig,
                    cCodPlan,           nSuma_Aseg_Moneda,       nPrima_Moneda,      
                    nPorcComis,         CMOTIVO_ENDOSO,          dFecExc);
  --
  UPDATE ENDOSOS E
     SET E.DESCENDOSO = 'SE CREO ENDOSO DE CAMBIO DE VIGENCIA POR AÑOS SUBSECUENTES EL DIA, '||TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI:SS')||
                       ' POR EL USUARIO, '||cUsuario||', EN LA TERMINAL - '||cTerminal,
         StsEndoso = 'EMI',
         FecSts    = TRUNC(SYSDATE)
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
  CLINEA_T := CHR(10)||'Comisiones a partir del '||dFecIniVig||' para el año poliza '||nAÑO_POLIZA||CHR(10);
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
--
--
END TH_CAMBIO_VIGENCIA;
/

--
-- GT_FAI_CONFIG_APORTE_FONDO_DET  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   POLIZAS (Table)
--   FAI_CONFIG_APORTE_FONDO (Table)
--   FAI_CONFIG_APORTE_FONDO_DET (Table)
--   FAI_EXCEDENTE_APORTE_FONDO (Table)
--   FAI_FONDOS_DETALLE_POLIZA (Table)
--   GT_FAI_EXCEDENTE_APORTE_FONDO (Package)
--   GT_FAI_TIPOS_DE_FONDOS (Package)
--   OC_VALORES_DE_LISTAS (Package)
--   COBERT_ACT (Table)
--   COBERT_ACT_ASEG (Table)
--   OC_GENERALES (Package)
--   OC_PLAN_DE_PAGOS (Package)
--   OC_POLIZAS (Package)
--   DETALLE_POLIZA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_CONFIG_APORTE_FONDO_DET AS

FUNCTION SALDO_APORTES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                       nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER;

FUNCTION ALTURA_APORTE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                       nCodAsegurado NUMBER, nIdFondo NUMBER, dFecAporte DATE) RETURN NUMBER;

FUNCTION ULTIMO_APORTE_PAG(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                           nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER;

FUNCTION FECHA_ULTIMO_PAGO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                           nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN DATE;

FUNCTION APORTES_PENDIENTES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                            nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER;

FUNCTION MONTO_APORTES_PENDIENTES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                                  nCodAsegurado NUMBER, nIdFondo NUMBER, cTipoMoneda VARCHAR2) RETURN NUMBER;

FUNCTION APORTES_PAGADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                         nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER;

FUNCTION MONTO_APORTES_PAGADOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                               nCodAsegurado NUMBER, nIdFondo NUMBER, cTipoMoneda VARCHAR2) RETURN NUMBER;

FUNCTION APORTES_POR_PAGAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                           nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER;

FUNCTION MONTO_APORTES_POR_PAGAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                                 nCodAsegurado NUMBER, nIdFondo NUMBER, cTipoMoneda VARCHAR2) RETURN NUMBER;

FUNCTION MONTO_APORTE_ESPECIFICO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                                 nCodAsegurado NUMBER, nIdFondo NUMBER, nNumAporte NUMBER) RETURN NUMBER;

FUNCTION DIAS_ATRASO_1ER_APORTE_ACT(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                                    nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER;

PROCEDURE GENERAR_APORTACIONES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                               nCodAsegurado NUMBER, nIdFondo NUMBER, cPeriodicidad VARCHAR2, 
                               nMontoAporte NUMBER, cProceso VARCHAR2);

PROCEDURE ACTUALIZAR_APORTACIONES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                                  nCodAsegurado NUMBER, nIdFondo NUMBER, cPeriodicidad VARCHAR2, 
                                  nMontoAporte NUMBER, cProceso VARCHAR2, dFecAporte DATE);

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                 nCodAsegurado NUMBER, nIdFondoOrig NUMBER, nIdFondoDest NUMBER);

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                  nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER);

PROCEDURE REVERTIR_ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                           nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER);

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                 nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER);

PROCEDURE REVERTIR_ANULACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                             nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER);

PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                    nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER);

PROCEDURE REVERTIR_SUSPENSION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                              nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER);

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                   nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER);

PROCEDURE PAGAR_APORTES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                        nCodAsegurado NUMBER, nIdFondo NUMBER, dFecMov DATE, 
                        nMontoAporteLocal NUMBER, nIdTransaccion NUMBER);

PROCEDURE REVERTIR_PAGO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                        nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                        nIdTransaccion NUMBER);

PROCEDURE REPROGRAMAR_APORTACIONES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                                   nCodAsegurado NUMBER, nIdFondo NUMBER, nDiaAntCargo NUMBER, 
                                   nDiaCargo NUMBER);

END GT_FAI_CONFIG_APORTE_FONDO_DET;
/

--
-- GT_FAI_CONFIG_APORTE_FONDO_DET  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_CONFIG_APORTE_FONDO_DET (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_CONFIG_APORTE_FONDO_DET AS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                 nCodAsegurado NUMBER, nIdFondoOrig NUMBER, nIdFondoDest NUMBER) IS
CURSOR DET_APORTES_Q IS
   SELECT NumAporte, FecAporte, MontoAporteMoneda, StsAporte,
          MontoAporteLocal, FecTasaCambio, TasaCambio
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondoOrig
      AND StsAporte IN ('ACTIVO','SOLICI');
BEGIN
   FOR X IN DET_APORTES_Q LOOP
      INSERT INTO FAI_CONFIG_APORTE_FONDO_DET
            (CodCia, CodEmpresa, IdPoliza, IDetPol, CodAsegurado,
             IdFondo, NumAporte, FecAporte, MontoAporteMoneda, StsAporte,
             FecStatus, MontoAporteLocal, FecTasaCambio, TasaCambio)
      VALUES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado,
             nIdFondoDest, X.NumAporte, X.FecAporte, X.MontoAporteMoneda, X.StsAporte,
             TRUNC(SYSDATE), X.MontoAporteLocal, X.FecTasaCambio, X.TasaCambio);
   END LOOP;
END COPIAR;

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                  nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
CURSOR APORTES_Q IS
   SELECT NumAporte
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo
      AND StsAporte    = 'SOLICI';
BEGIN
   FOR X IN APORTES_Q LOOP
      UPDATE FAI_CONFIG_APORTE_FONDO_DET
         SET StsAporte = 'ACTIVO',
             FecStatus = TRUNC(SYSDATE)
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
         AND IdFondo      = nIdFondo
         AND NumAporte    = X.NumAporte;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Activar Aportes de Fondo No. '||
                               nCodCia||'-'||nCodEmpresa||'-'||nIdPoliza||'-'||nIDetPol||'-'||nCodAsegurado||'-'||nIdFondo);
END ACTIVAR;

PROCEDURE REVERTIR_ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                           nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS

CURSOR APORTES_Q IS
   SELECT NumAporte
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo
      AND StsAporte    = 'ACTIVO';
BEGIN
   FOR X IN APORTES_Q LOOP
      UPDATE FAI_CONFIG_APORTE_FONDO_DET
         SET StsAporte = 'SOLICI',
             FecStatus = TRUNC(SYSDATE)
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
         AND IdFondo      = nIdFondo
         AND NumAporte    = X.NumAporte;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Revertir Activación de Aportes de Fondo No. '||
                               nCodCia||'-'||nCodEmpresa||'-'||nIdPoliza||'-'||nIDetPol||'-'||nCodAsegurado||'-'||nIdFondo);
END REVERTIR_ACTIVAR;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                 nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
CURSOR APORTES_Q IS
   SELECT NumAporte
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo
      AND StsAporte    = 'ACTIVO';
BEGIN
   FOR X IN APORTES_Q LOOP
      UPDATE FAI_CONFIG_APORTE_FONDO_DET
         SET StsAporte = 'ANULAD',
             FecStatus = TRUNC(SYSDATE)
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
         AND IdFondo      = nIdFondo
         AND NumAporte    = X.NumAporte;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Anular Aportes de Fondo No. '||
                              nCodCia||'-'||nCodEmpresa||'-'||nIdPoliza||'-'||nIDetPol||'-'||nCodAsegurado||'-'||nIdFondo);
END ANULAR;

PROCEDURE REVERTIR_ANULACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                             nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
CURSOR APORTES_Q IS
   SELECT NumAporte
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo
      AND StsAporte    = 'ANULAD';
BEGIN
   FOR X IN APORTES_Q LOOP
      UPDATE FAI_CONFIG_APORTE_FONDO_DET
         SET StsAporte = 'ACTIVO',
             FecStatus = TRUNC(SYSDATE)
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
         AND IdFondo      = nIdFondo
         AND NumAporte    = X.NumAporte;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Revertir Anulación de Aportes de Fondo No. '||
                              nCodCia||'-'||nCodEmpresa||'-'||nIdPoliza||'-'||nIDetPol||'-'||nCodAsegurado||'-'||nIdFondo);
END REVERTIR_ANULACION;

PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                    nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
CURSOR APORTES_Q IS
   SELECT NumAporte
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo
      AND StsAporte    = 'ACTIVO';
BEGIN
   FOR X IN APORTES_Q LOOP
      UPDATE FAI_CONFIG_APORTE_FONDO_DET
         SET StsAporte = 'SUSPEN',
             FecStatus = TRUNC(SYSDATE)
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
         AND IdFondo      = nIdFondo
         AND NumAporte    = X.NumAporte;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Suspender Aportes de Fondo No. '||
                              nCodCia||'-'||nCodEmpresa||'-'||nIdPoliza||'-'||nIDetPol||'-'||nCodAsegurado||'-'||nIdFondo);
END SUSPENDER;

PROCEDURE REVERTIR_SUSPENSION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                              nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
CURSOR APORTES_Q IS
   SELECT NumAporte
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo
      AND StsAporte    = 'SUSPEN';
BEGIN
   FOR X IN APORTES_Q LOOP
      UPDATE FAI_CONFIG_APORTE_FONDO_DET
         SET StsAporte = 'ACTIVO',
             FecStatus = TRUNC(SYSDATE)
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
         AND IdFondo      = nIdFondo
         AND NumAporte    = X.NumAporte;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Revertir Suspensión de Aportes de Fondo No. '||
                              nCodCia||'-'||nCodEmpresa||'-'||nIdPoliza||'-'||nIDetPol||'-'||nCodAsegurado||'-'||nIdFondo);
END REVERTIR_SUSPENSION;

PROCEDURE GENERAR_APORTACIONES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                               nCodAsegurado NUMBER, nIdFondo NUMBER, cPeriodicidad VARCHAR2, 
                               nMontoAporte NUMBER, cProceso VARCHAR2) IS
nPlazoObligado      FAI_FONDOS_DETALLE_POLIZA.PlazoObligado%TYPE;
nPlazoComprometido  FAI_FONDOS_DETALLE_POLIZA.PlazoComprometido%TYPE;
cTipoFondo          FAI_FONDOS_DETALLE_POLIZA.TipoFondo%TYPE;
dFecTasaCambio      FAI_CONFIG_APORTE_FONDO_DET.FecTasaCambio%TYPE;
nTasaCambio         FAI_CONFIG_APORTE_FONDO_DET.TasaCambio%TYPE;
dFecAporte          FAI_CONFIG_APORTE_FONDO_DET.FecAporte%TYPE;
nNumAporte          FAI_CONFIG_APORTE_FONDO_DET.NumAporte%TYPE := 0;
nMontoAporteLocal   FAI_CONFIG_APORTE_FONDO_DET.MontoAporteLocal%TYPE;
nMontoAporteMoneda  FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;
nMontoAporteOrig    FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;
nMontoAporteLocOrig FAI_CONFIG_APORTE_FONDO_DET.MontoAporteLocal%TYPE;
cCodTipoAporte      FAI_CONFIG_APORTE_FONDO_DET.CodTipoAporte%TYPE;
cCodPlanPago        POLIZAS.CodPlanPago%TYPE;
dFec1aQuin          DATE;
dFec2aQuin          DATE;
nMeses              NUMBER := 0;
dFecQuincena1       DATE;
dFecQuincena2       DATE;
dFecPago            DATE;
nCantReg            NUMBER := 0;
--nDiaCargo           NUMBER := 0; --FAI_CONFIG_APORTE_FONDO.DIACARGO%TYPE := 0;
--cIndDiaCargoFijo    VARCHAR2(1) := 'N'; --FAI_CONFIG_APORTE_FONDO.INDDIACARGOFIJO%TYPE;
BEGIN
   BEGIN
      SELECT NVL(F.PlazoObligado,0), NVL(F.PlazoComprometido,0),
             NVL(TRUNC(F.FecTasaCambio),TRUNC(SYSDATE)), F.TipoFondo,
             --NVL(A.Inddiacargofijo,'N'),NVL(A.DiaCargo,0),
             A.CodTipoAporte, A.MontoAporte, A.MontoAporteLocal
        INTO nPlazoObligado, nPlazoComprometido, dFecAporte, cTipoFondo,
             --cIndDiaCargoFijo,nDiaCargo,
             cCodTipoAporte, nMontoAporteOrig, nMontoAporteLocOrig
        FROM FAI_FONDOS_DETALLE_POLIZA F, FAI_CONFIG_APORTE_FONDO A
       WHERE A.IdFondo      = F.IdFondo
         AND F.CodCia       = nCodCia
         AND F.CodEmpresa   = nCodEmpresa
         AND F.IdPoliza     = nIdPoliza
         AND F.IDetPol      = nIDetPol
         AND F.CodAsegurado = nCodAsegurado
         AND F.IdFondo      = nIdFondo;
   EXCEPTION
      WHEN OTHERS THEN
         nPlazoObligado     := 0;
         nPlazoComprometido := 0;
         dFecAporte         := TRUNC(SYSDATE);
   END;

   --IF cIndDiaCargoFijo = 'S' THEN
   --   dFecAporte := TO_DATE(LPAD(nDiaCargo,2,'0')||TO_CHAR(SYSDATE,'MMYYYY'),'DDMMYYYY');
   --END IF;

   IF OC_VALORES_DE_LISTAS.BUSCA_LVALOR('MESESFREC',cPeriodicidad) <> 'Invalida' THEN
      nMeses := TO_NUMBER(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('MESESFREC',cPeriodicidad),'99999.999');
   ELSE
      nMeses := 1;
   END IF;

  --BEGIN
  --  SELECT DISTINCT DiaVencQuincena1, DiaVencQuincena2
  --    INTO dFec1aQuin, dFec2aQuin
  --    FROM POLIZAS P, FAI_FONDOS_DETALLE_POLIZA FP, GRUPO_POLIZA GP
  --   WHERE P.IdPoliza   = FP.IdPoliza
  --     AND FP.IdFondo   = nIdFondo
  --     AND GP.CodGrpPol = NVL(P.CodGrpDep,P.CodGrpPol);
  --EXCEPTION
  --  WHEN NO_DATA_FOUND THEN
  --    dFec1aQuin := NULL;
  --    dFec2aQuin := NULL;
  --END;
   dFec1aQuin := NULL;
   dFec2aQuin := NULL;

   IF cProceso = 'CO' THEN
      nPlazoComprometido := nPlazoComprometido * 12;
      IF nPlazoComprometido > nPlazoObligado THEN
         nCantReg  := nPlazoComprometido - nPlazoObligado;
      ELSE
         nCantReg  := 0;
      END IF;
   ELSIF cProceso = 'OB' THEN
      nCantReg  := nPlazoObligado;
   ELSIF cProceso = 'DX' THEN
      nCantReg  := 12;
   ELSIF cProceso = 'PLANPAGOS' THEN
      cCodPlanPago := OC_POLIZAS.PLAN_DE_PAGOS(nCodCia, nCodEmpresa, nIdPoliza);
      nCantReg     := OC_PLAN_DE_PAGOS.CANTIDAD_PAGOS(nCodCia, nCodEmpresa, cCodPlanPago);
   END IF;
   nCantReg       := CEIL(nCantReg/nMeses);
   nTasaCambio    := OC_GENERALES.TASA_DE_CAMBIO(GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondo), dFecAporte);
   dFecTasaCambio := dFecAporte;
   WHILE(nNumAporte < nCantReg) LOOP
      nNumAporte := nNumAporte + 1;

      IF GT_FAI_TIPOS_DE_FONDOS.INDICADORES(nCodCia, nCodEmpresa, cTipoFondo, 'ML') = 'S' THEN
         nMontoAporteMoneda := nMontoAporteLocOrig * nTasaCambio;
         nMontoAporteLocal  := nMontoAporteLocOrig;
      ELSE
         nMontoAporteMoneda := nMontoAporteOrig;
         nMontoAporteLocal  := nMontoAporteOrig * nTasaCambio;
      END IF;

      IF nMeses = 0.5 THEN
         IF dFec1aQuin IS NULL THEN
            dFecQuincena1 := dFecAporte;
            dFecQuincena2 := dFecAporte + 15;
            IF MOD(nNumAporte,2) = 0 THEN
               dFecPago := ADD_MONTHS(dFecQuincena2,TRUNC((nNumAporte+1)/2)-1);
            ELSE
               dFecPago := ADD_MONTHS(dFecQuincena1,TRUNC((nNumAporte+1)/2)-1);
            END IF;
            IF cProceso = 'CO' THEN
               IF MOD(nNumAporte,2) = 0 THEN
                  dFecPago := ADD_MONTHS(dFecQuincena1,(TRUNC((nNumAporte+1)/2))+NVL(nPlazoObligado,0));
               ELSE
                  dFecPago := ADD_MONTHS(dFecQuincena2,(TRUNC((nNumAporte+1)/2)-1)+NVL(nPlazoObligado,0));
               END IF;
            END IF;
         ELSE
            dFecPago:= TRUNC(SYSDATE); --PR_CALENDARIO_EVENTOS_GRUPO.DIA_FECVCT_GIRO(nIdPoliza,nNumAporte);
         END IF;

         INSERT INTO FAI_CONFIG_APORTE_FONDO_DET
               (CodCia, CodEmpresa, IdPoliza, IDetPol, CodAsegurado,
                IdFondo, CodTipoAporte, NumAporte, FecAporte, MontoAporteMoneda, 
                StsAporte, FecStatus, MontoAporteLocal, FecTasaCambio, TasaCambio)
         VALUES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado,
                nIdFondo, cCodTipoAporte, nNumAporte, dFecPago, nMontoAporteMoneda, 
                'SOLICI', TRUNC(SYSDATE), nMontoAporteLocal, dFecTasaCambio, nTasaCambio);
      ELSE
         IF nNumAporte = 1 THEN
            dFecPago := dFecAporte;
            IF cProceso = 'CO' THEN
               dFecPago := ADD_MONTHS(dFecPago,NVL(nPlazoObligado,0));
            ELSIF cProceso = 'DX' THEN
               dFecPago := TRUNC(SYSDATE); --pr_calendario_eventos_grupo.DIA_FECVCT_GIRO(nIdPoliza,nNumAporte);
            ELSIF cProceso = 'PLANPAGOS' THEN
               dFecPago := TRUNC(SYSDATE);
            END IF;
         ELSE
            dFecPago := ADD_MONTHS(dFecPago,nMeses);
         END IF;

         INSERT INTO FAI_CONFIG_APORTE_FONDO_DET
               (CodCia, CodEmpresa, IdPoliza, IDetPol, CodAsegurado,
                IdFondo, CodTipoAporte, NumAporte, FecAporte, MontoAporteMoneda,
                StsAporte, FecStatus, MontoAporteLocal, FecTasaCambio, TasaCambio)
         VALUES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado,
                nIdFondo, cCodTipoAporte, nNumAporte, dFecPago, nMontoAporteMoneda,
                'SOLICI', TRUNC(SYSDATE), nMontoAporteLocal, dFecTasaCambio, nTasaCambio);
      END IF;
   END LOOP;
END GENERAR_APORTACIONES;

PROCEDURE ACTUALIZAR_APORTACIONES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                                  nCodAsegurado NUMBER, nIdFondo NUMBER, cPeriodicidad VARCHAR2, 
                                  nMontoAporte NUMBER, cProceso VARCHAR2, dFecAporte DATE) IS
nPlazoObligado      FAI_FONDOS_DETALLE_POLIZA.PlazoObligado%TYPE;
nPlazoComprometido  FAI_FONDOS_DETALLE_POLIZA.PlazoComprometido%TYPE;
cTipoFondo          FAI_FONDOS_DETALLE_POLIZA.TipoFondo%TYPE;
dFecTasaCambio      FAI_CONFIG_APORTE_FONDO_DET.FecAporte%TYPE;
nTasaCambio         FAI_CONFIG_APORTE_FONDO_DET.TasaCambio%TYPE;
nMeses              NUMBER:=0;
dFecQuincena1       DATE;
dFecQuincena2       DATE;
dFecPago            DATE;
nCantReg            NUMBER := 0;
dFec1aQuin          DATE; --GRUPO_POLIZA.DIAVENCQUINCENA1%TYPE;  -- FALTA JROD
dFec2aQuin          DATE; --GRUPO_POLIZA.DIAVENCQUINCENA2%TYPE;  -- FALTA JROD
nMontoAporteLocal   FAI_CONFIG_APORTE_FONDO_DET.MontoAporteLocal%TYPE;
nMontoAporteMoneda  FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;
nDiaCargo           NUMBER := 0; --FAI_CONFIG_APORTE_FONDO.DIACARGO%TYPE := 0;
cIndDiaCargoFijo    VARCHAR2(1):= 'N'; --FAI_CONFIG_APORTE_FONDO.INDDIACARGOFIJO%TYPE;
dFecAporte2         DATE := dFecAporte;
cCodPlanPago        POLIZAS.CodPlanPago%TYPE;

CURSOR C_DET_APORTES IS
   SELECT NumAporte, MontoAporteMoneda, MontoAporteLocal
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo
    ORDER BY 1;
BEGIN
   BEGIN
      SELECT NVL(F.PlazoObligado,0), NVL(F.PlazoComprometido,0), F.TipoFondo,
             'N' /*NVL(A.Inddiacargofijo,'N')*/, 0 /*,NVL(A.DiaCargo,0)*/
        INTO nPlazoObligado, nPlazoComprometido, cTipoFondo,
             cIndDiaCargoFijo,nDiaCargo
        FROM FAI_FONDOS_DETALLE_POLIZA F, FAI_CONFIG_APORTE_FONDO A
       WHERE F.IdFondo      = A.IdFondo
         AND F.CodCia       = nCodCia
         AND F.CodEmpresa   = nCodEmpresa
         AND F.IdPoliza     = nIdPoliza
         AND F.IDetPol      = nIDetPol
         AND F.CodAsegurado = nCodAsegurado
         AND F.IdFondo      = nIdFondo;
   EXCEPTION
      WHEN OTHERS THEN
         nPlazoObligado     := 0;
         nPlazoComprometido := 0;
   END;
  
   IF cIndDiaCargoFijo = 'S' THEN
      dFecAporte2 := TO_DATE(LPAD(nDiaCargo,2,'0')||TO_CHAR(SYSDATE,'MMYYYY'),'DDMMYYYY');
   END IF;

  /*BEGIN
    SELECT DISTINCT DiaVencQuincena1, DiaVencQuincena2
      INTO dFec1aQuin, dFec2aQuin
      FROM POLIZAS P, FAI_FONDOS_DETALLE_POLIZA FP, GRUPO_POLIZA GP
     WHERE P.IdPoliza     = FP.IdPoliza
       AND FP.IdFondo  = nIdFondo
       AND GP.CodGrpPol = NVL(P.CodGrpDep,P.CodGrpPol);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      dFec1aQuin := NULL;
      dFec2aQuin := NULL;
  END;*/
   dFec1aQuin := NULL;
   dFec2aQuin := NULL;

  /*IF PR.BUSCA_LVAL('MESPERIO',cPeriodicidad) <> 'INVALIDO' THEN  -- FALTA JROD
     nMeses :=  TO_NUMBER(PR.BUSCA_LVAL('MESPERIO',cPeriodicidad),'9999.999');
  END IF;*/
   nMeses := 0.5;
  
   IF cProceso = 'CO' THEN
      nPlazoComprometido := nPlazoComprometido * 12;
      nCantReg           := nPlazoComprometido;
   ELSIF cProceso = 'OB' THEN
      nCantReg           := nPlazoObligado;
   ELSIF cProceso = 'DX' THEN
      nCantReg           := 12; --ANUAL
   ELSIF cProceso = 'PLANPAGOS' THEN
      cCodPlanPago := OC_POLIZAS.PLAN_DE_PAGOS(nCodCia, nCodEmpresa, nIdPoliza);
      nCantReg     := OC_PLAN_DE_PAGOS.CANTIDAD_PAGOS(nCodCia, nCodEmpresa, cCodPlanPago);
   END IF;

   nTasaCambio    := OC_GENERALES.TASA_DE_CAMBIO(GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondo), dFecAporte2);
   dFecTasaCambio := dFecAporte2;
   FOR X IN C_DET_APORTES LOOP
      -- Si el Manejo es por Moneda Local se Calcula la Moneda del Fondo 
      IF GT_FAI_TIPOS_DE_FONDOS.INDICADORES(nCodCia, nCodEmpresa, cTipoFondo,'ML') = 'S' THEN
         nMontoAporteMoneda := X.MontoAporteLocal / nTasaCambio;
         nMontoAporteLocal  := X.MontoAporteLocal;
      ELSE
         nMontoAporteMoneda := X.MontoAporteMoneda;
         nMontoAporteLocal  := X.MontoAporteMoneda * nTasaCambio;
      END IF;
      IF nMeses = 0.5 THEN
         IF dFec1aQuin IS NULL THEN
            dFecQuincena1 := dFecAporte2;
            dFecQuincena2 := dFecAporte2 + 15;
         ELSE
            dFecQuincena1 := TO_DATE(LPAD(dFec1aQuin,2,'0')||TO_CHAR(dFecAporte2,'MMYYYY'),'DDMMYYYY');
            dFecQuincena2 := TO_DATE(LPAD(dFec2aQuin,2,'0')||TO_CHAR(dFecAporte2,'MMYYYY'),'DDMMYYYY');
         END IF;
         IF MOD(X.NumAporte,2) = 0 THEN
            dFecPago := ADD_MONTHS(dFecQuincena2,TRUNC((X.NumAporte+1)/2)-1);
         ELSE
            dFecPago := ADD_MONTHS(dFecQuincena1,TRUNC((X.NumAporte+1)/2)-1);
         END IF;
         IF cProceso = 'CO' THEN
            IF MOD(X.NumAporte,2) = 0 THEN
               dFecPago := ADD_MONTHS(dFecQuincena1,(TRUNC((X.NumAporte+1)/2))+NVL(nPlazoObligado,0));
            ELSE
               dFecPago := ADD_MONTHS(dFecQuincena2,(TRUNC((X.NumAporte+1)/2)-1)+NVL(nPlazoObligado,0));
            END IF;
         END IF;
       
         UPDATE FAI_CONFIG_APORTE_FONDO_DET
            SET MontoAporteMoneda = nMontoAporteMoneda,
                MontoAporteLocal  = nMontoAporteLocal,
                FecAporte         = dFecPago,
                FecTasaCambio     = dFecTasaCambio,
                TasaCambio        = nTasaCambio
          WHERE NumAporte    = X.NumAporte
            AND CodCia       = nCodCia
            AND CodEmpresa   = nCodEmpresa
            AND IdPoliza     = nIdPoliza
            AND IDetPol      = nIDetPol
            AND CodAsegurado = nCodAsegurado
            AND IdFondo      = nIdFondo;
      ELSE
         IF X.NumAporte = 1 THEN
            dFecPago := dFecAporte2;
            IF cProceso = 'CO' THEN
               dFecPago := ADD_MONTHS(dFecPago,NVL(nPlazoObligado,0)+NVL(nMeses,0));
            ELSIF cProceso = 'DX' THEN
               dFecPago := TRUNC(SYSDATE); --pr_calendario_eventos_grupo.DIA_FECVCT_GIRO(nIdPoliza,x.NumAporte); --FALTA JROD
            END IF;
         ELSE
            dFecPago := ADD_MONTHS(dFecPago,nMeses);
         END IF;
       
         UPDATE FAI_CONFIG_APORTE_FONDO_DET
            SET MontoAporteMoneda = nMontoAporteMoneda,
                MontoAporteLocal  = nMontoAporteLocal,
                FecAporte         = dFecPago,
                FecTasaCambio     = dFecTasaCambio,
                TasaCambio        = nTasaCambio
          WHERE NumAporte = X.NumAporte
            AND CodCia       = nCodCia
            AND CodEmpresa   = nCodEmpresa
            AND IdPoliza     = nIdPoliza
            AND IDetPol      = nIDetPol
            AND CodAsegurado = nCodAsegurado
            AND IdFondo      = nIdFondo;
      END IF;
   END LOOP;
END ACTUALIZAR_APORTACIONES;

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                   nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
BEGIN
   DELETE FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo
      AND StsAporte    = 'SOLICI';
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error Al Eliminar Aportes de Fondo No. '||nIdFondo);
END ELIMINAR;

PROCEDURE PAGAR_APORTES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                        nCodAsegurado NUMBER, nIdFondo NUMBER, dFecMov DATE, 
                        nMontoAporteLocal NUMBER, nIdTransaccion NUMBER) IS

nSaldoMonto        FAI_CONFIG_APORTE_FONDO_DET.MontoAporteLocal%TYPE;
nTasaCambio        FAI_CONFIG_APORTE_FONDO_DET.TasaCambio%TYPE;
cTipoFondo         FAI_FONDOS_DETALLE_POLIZA.TipoFondo%TYPE;
nMontoCober        COBERT_ACT.Prima_Moneda%TYPE;
cIndDescPrimaCob   FAI_FONDOS_DETALLE_POLIZA.IndDescPrimaCob%TYPE;
nSaldoExcedente    FAI_CONFIG_APORTE_FONDO_DET.MontoAporteLocal%TYPE;
nNumAporte         FAI_CONFIG_APORTE_FONDO_DET.NumAporte %TYPE;
cExistenAportes    VARCHAR2(1) := 'N';

CURSOR APORTES_Q IS
   SELECT NumAporte, ROUND(MontoAporteLocal,2) MontoAporteLocal, FecAporte
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo
      AND StsAporte    = 'ACTIVO'
    ORDER BY NumAporte;

CURSOR EXCEDENTES_Q IS
   SELECT NumAporte, NumExcedente, Excedente, FecUltMov
     FROM FAI_EXCEDENTE_APORTE_FONDO A
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCodAsegurado
      AND IdFondo       = nIdFondo
      AND StsExcedente  = 'ACTIVO'
    ORDER BY NumAporte, NumExcedente;
BEGIN
   nSaldoMonto := nMontoAporteLocal;
   BEGIN
      SELECT TipoFondo, IndDescPrimaCob
        INTO cTipoFondo, cIndDescPrimaCob
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
         AND IdFondo      = nIdFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'No. Existe el Fondo No. '||nIdFondo);
   END;

   nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondo), dFecMov);

   FOR X IN APORTES_Q LOOP
      cExistenAportes := 'S';
      nNumAporte      := X.NumAporte;
      IF X.NumAporte = 1 AND
         GT_FAI_TIPOS_DE_FONDOS.INDICADORES(nCodCia, nCodEmpresa, cTipoFondo, 'DC') = 'N' AND
         cIndDescPrimaCob = 'S' THEN
         BEGIN
            SELECT NVL(SUM(Prima_Local),0)
              INTO nMontoCober
              FROM COBERT_ACT
             WHERE CodCia        = nCodCia
               AND CodEmpresa    = nCodEmpresa
               AND IdPoliza      = nIdPoliza
               AND IDetPol       = nIDetPol
               AND Cod_Asegurado = nCodAsegurado
               AND StsCobertura  = 'EMI';
            SELECT NVL(SUM(Prima_Local),0) + NVL(nMontoCober,0)
              INTO nMontoCober
              FROM COBERT_ACT_ASEG
             WHERE CodCia        = nCodCia
               AND CodEmpresa    = nCodEmpresa
               AND IdPoliza      = nIdPoliza
               AND IDetPol       = nIDetPol
               AND Cod_Asegurado = nCodAsegurado
               AND StsCobertura  = 'EMI';

            nSaldoMonto := NVL(nSaldoMonto,0) + NVL(nMontoCober,0);
         END;
      END IF;
      
      IF NVL(nSaldoMonto,0) > 0 AND (X.NumAporte = 1 OR (nSaldoMonto >= X.MontoAporteLocal))THEN
         BEGIN
            UPDATE FAI_CONFIG_APORTE_FONDO_DET
               SET MontoAporteMoneda = X.MontoAporteLocal * nTasaCambio,
                   FecTasaCambio     = dFecMov,
                   TasaCambio        = nTasaCambio
             WHERE CodCia       = nCodCia
               AND CodEmpresa   = nCodEmpresa
               AND IdPoliza     = nIdPoliza
               AND IDetPol      = nIDetPol
               AND CodAsegurado = nCodAsegurado
               AND IdFondo      = nIdFondo
               AND NumAporte    = X.Numaporte;
         END;
         nSaldoMonto := NVL(nSaldoMonto,0) - NVL(X.MontoAporteLocal,0);
      ELSE
         EXIT;
      END IF;
   END LOOP;

   IF NVL(nSaldoMonto,0) > 0 AND cExistenAportes = 'S' THEN
      GT_FAI_EXCEDENTE_APORTE_FONDO.CREAR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, 
                                          nIdFondo, nNumAporte, nSaldoMonto, 'ACTIVO', TRUNC(SYSDATE), 'EXCVOL');
   END IF;

   FOR X IN APORTES_Q LOOP
      nSaldoExcedente := GT_FAI_EXCEDENTE_APORTE_FONDO.VERIFICA_SALDO(nCodCia, nCodEmpresa, nIdPoliza, 
                                                                      nIDetPol, nCodAsegurado, nIdFondo);
      IF nSaldoExcedente >= X.MontoAporteLocal THEN
         FOR Y IN EXCEDENTES_Q LOOP --FALTA JROD
            nSaldoExcedente := nSaldoExcedente + (nSaldoMonto + Y.Excedente);
            GT_FAI_EXCEDENTE_APORTE_FONDO.APLICAR(nCodCia, nCodEmpresa, nIdPoliza, 
                                                  nIDetPol, nCodAsegurado, nIdFondo,
                                                  Y.NumAporte, Y.NumExcedente, nIdTransaccion);
            IF nSaldoExcedente > X.MontoAporteLocal Then
               GT_FAI_EXCEDENTE_APORTE_FONDO.CREAR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, 
                                                   nCodAsegurado, nIdFondo, X.NumAporte,
                                                   nSaldoExcedente - X.MontoAporteLocal,
                                                   'MAPLEX', TRUNC(SYSDATE), 'EXCAPL');
               EXIT;
            END IF;
          END LOOP;
          UPDATE FAI_CONFIG_APORTE_FONDO_DET
              SET StsAporte = 'PAGADO',
                  FecStatus = TRUNC(SYSDATE)
            WHERE CodCia       = nCodCia
              AND CodEmpresa   = nCodEmpresa
              AND IdPoliza     = nIdPoliza
              AND IDetPol      = nIDetPol
              AND CodAsegurado = nCodAsegurado
              AND IdFondo      = nIdFondo
              AND NumAporte    = X.NumAporte;
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Pagar Aportes de Fondo No. '||nIdFondo||' '||SQLERRM);
END PAGAR_APORTES;

PROCEDURE REVERTIR_PAGO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                        nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                        nIdTransaccion NUMBER) IS
CURSOR APORTES_Q IS
   SELECT NumAporte
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo
      AND StsAporte    = 'PAGADO';
BEGIN
   FOR X IN APORTES_Q LOOP
      UPDATE FAI_CONFIG_APORTE_FONDO_DET
         SET StsAporte = 'ACTIVO',
             FecStatus = TRUNC(SYSDATE)
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
         AND IdFondo      = nIdFondo
         AND NumAporte    = X.NumAporte;
   END LOOP;
   GT_FAI_EXCEDENTE_APORTE_FONDO.REVERTIR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, 
                                          nCodAsegurado, nIdFondo, nIdTransaccion);
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Revertir el Pago del Aporte de Fondo No. '||nIdFondo);
END REVERTIR_PAGO;

FUNCTION SALDO_APORTES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                       nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER IS
nMontoAporte   FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;
BEGIN
   SELECT NVL(SUM(MontoAporteMoneda),0)
     INTO nMontoAporte
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo
      AND StsAporte     = 'ACTIVO';
   RETURN(nMontoAporte);
END SALDO_APORTES;

PROCEDURE REPROGRAMAR_APORTACIONES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                                   nCodAsegurado NUMBER, nIdFondo NUMBER, nDiaAntCargo NUMBER,
                                   nDiaCargo NUMBER) IS
dFecAporte DATE;
cTextoEnd  VARCHAR2(4000);
nIdeMovPr  NUMBER;
cursorID   NUMBER;
Dummy      NUMBER;
cDetAport  VARCHAR2(4000);
CURSOR C_DET_APORTES IS
   SELECT NumAporte, FecAporte
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo
      AND StsAporte    = 'ACTIVO' ;
/*CURSOR C_RAMOS_POLIZA IS
   SELECT CODRAMOCERT,CODPLAN,REVPLAN,FECINIVALID,FECFINVALID
     FROM CERT_RAMO
    WHERE IdPoliza  = nIdPoliza
      AND NUMCERT = nNumCert
      AND STSCERTRAMO = 'ACT';*/
BEGIN
   cTextoEnd := 'El usuario '|| USER||' ha realizado la operacion REPROGRAMACION DE APORTACIONES del fondo No. '||
                 nIdFondo||' Dia Anterior de Cargo: '||nDiaAntCargo||' Dia Actual de Cargo: '||nDiaCargo||
                 ' Todas las aportaciones pendientes han sido reprogramadas con el dia indicado por el usuario';
   FOR X IN C_DET_APORTES LOOP
      IF nDiaCargo > TO_NUMBER(TO_CHAR(LAST_DAY(X.FECAPORTE),'dd')) THEN
         dFecAporte := LAST_DAY(X.FecAporte);
      ELSE
         dFecAporte := TO_DATE(LPAD(nDiaCargo,2,'0')||TO_CHAR(X.FecAporte,'MMYYYY'),'DDMMYYYY');
      END IF;
      BEGIN
         UPDATE FAI_CONFIG_APORTE_FONDO_DET
            SET FecAporte = dFecAporte
          WHERE CodCia    = nCodCia
            AND CodEmpresa   = nCodEmpresa
            AND IdPoliza     = nIdPoliza
            AND IDetPol      = nIDetPol
            AND CodAsegurado = nCodAsegurado
            AND IdFondo      = nIdFondo
            AND NumAporte    = X.NumAporte;
      END;
   END LOOP;
END REPROGRAMAR_APORTACIONES;

FUNCTION ALTURA_APORTE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                       nCodAsegurado NUMBER, nIdFondo NUMBER, dFecAporte DATE) RETURN NUMBER IS
dFecIniVig   POLIZAS.FecIniVig%TYPE;
nAltura      NUMBER(5);
nRestoAlt    NUMBER(10,6);
BEGIN
   BEGIN
      SELECT FecIniVig
        INTO dFecIniVig
        FROM DETALLE_POLIZA
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND Cod_Asegurado = nCodAsegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20052,'No existe Detalle de Póliza de la Concentradora de Fondos');
   END;
   nAltura   := FLOOR(((MONTHS_BETWEEN(TRUNC(dFecAporte), dFecIniVig)+1) / 12));
   nRestoAlt := ((MONTHS_BETWEEN(TRUNC(dFecAporte), dFecIniVig)+1) / 12) - nAltura;
   IF NVL(nRestoAlt,0) <> 0 THEN
      nAltura := NVL(nAltura,0) + 1;
   ELSIF nAltura = 0 THEN
      nAltura := 1;
   END IF;
   RETURN(nAltura);
END ALTURA_APORTE;

FUNCTION ULTIMO_APORTE_PAG(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                           nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER IS
  nUltAportePag FAI_CONFIG_APORTE_FONDO_DET.Numaporte%TYPE := 0;
BEGIN
   BEGIN
      SELECT MAX(NumAporte)
        INTO nUltAportePag
        FROM FAI_CONFIG_APORTE_FONDO_DET
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
         AND IdFondo      = nIdFondo
         AND StsAporte    = 'PAGADO';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nUltAportePag := NULL;
   END;
   RETURN(NVL(nUltAportePag,0));
END ULTIMO_APORTE_PAG;

FUNCTION FECHA_ULTIMO_PAGO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                           nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN DATE IS
dFecUltimoPago FAI_CONFIG_APORTE_FONDO_DET.FecStatus%TYPE;
BEGIN
   SELECT MAX(FecStatus)
     INTO dFecUltimoPago
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo
      AND StsAporte    = 'PAGADO';
   RETURN(dFecUltimoPago);
END FECHA_ULTIMO_PAGO;

FUNCTION APORTES_PENDIENTES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                            nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER IS
nCantidad NUMBER:=0;
BEGIN
   SELECT COUNT(1)
     INTO nCantidad
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = NVL(nIdFondo,IdFondo)
      AND StsAporte    = 'ACTIVO';
   RETURN(NVL(nCantidad,0));
END APORTES_PENDIENTES;

FUNCTION MONTO_APORTES_PENDIENTES(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                                  nCodAsegurado NUMBER, nIdFondo NUMBER, cTipoMoneda VARCHAR2) RETURN NUMBER IS
nMontoAportePendLocal FAI_CONFIG_APORTE_FONDO.Montoaportelocal%TYPE;
nMontoAportePend      FAI_CONFIG_APORTE_FONDO.Montoaportelocal%TYPE;
BEGIN
   SELECT NVL(SUM(MontoAporteLocal),0), NVL(SUM(MontoAporteMoneda),0)
     INTO nMontoAportePendLocal, nMontoAportePend
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = NVL(nIdFondo,IdFondo)
      AND StsAporte    = 'ACTIVO';

   IF cTipoMoneda  = 'L' THEN
      RETURN(NVL(nMontoAportePendLocal,0));
   ELSIF cTipoMoneda  = 'E' THEN
      RETURN(NVL(nMontoAportePend,0));
   END IF;
END MONTO_APORTES_PENDIENTES;

FUNCTION APORTES_PAGADOS (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                          nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER IS
nCantidad NUMBER:=0;
BEGIN
   SELECT COUNT(1)
     INTO nCantidad
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = NVL(nIdFondo,IdFondo)
      AND StsAporte    = 'PAGADO';
   RETURN(NVL(nCantidad,0));
END APORTES_PAGADOS;

FUNCTION MONTO_APORTES_PAGADOS (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                                nCodAsegurado NUMBER, nIdFondo NUMBER, cTipoMoneda VARCHAR2) RETURN NUMBER IS
nMontoAportePagLocal FAI_CONFIG_APORTE_FONDO.Montoaportelocal%TYPE;
nMontoAportePag      FAI_CONFIG_APORTE_FONDO.Montoaportelocal%TYPE;
BEGIN
   SELECT NVL(SUM(MontoAporteLocal),0), NVL(SUM(MontoAporteMoneda),0)
     INTO nMontoAportePagLocal, nMontoAportePag
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = NVL(nIdFondo,IdFondo)
      AND StsAporte    = 'PAGADO';
   IF cTipoMoneda  = 'L' THEN
      RETURN(NVL(nMontoAportePagLocal,0));
   ELSIF cTipoMoneda  = 'E' THEN
      RETURN(NVL(nMontoAportePag,0));
   END IF;
END MONTO_APORTES_PAGADOS;

FUNCTION APORTES_POR_PAGAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                           nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER IS
nCantidad NUMBER:=0;
BEGIN
   SELECT COUNT(1) 
     INTO nCantidad
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = NVL(nIdFondo,IdFondo)
      AND StsAporte    = 'ACTIVO'
      AND Fecaporte   <= TRUNC(SYSDATE);
   RETURN(NVL(nCantidad,0));
END APORTES_POR_PAGAR;

FUNCTION MONTO_APORTES_POR_PAGAR (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                                  nCodAsegurado NUMBER, nIdFondo NUMBER, cTipoMoneda VARCHAR2) RETURN NUMBER IS
nMontoAportePendLocal FAI_CONFIG_APORTE_FONDO.Montoaportelocal%TYPE;
nMontoAportePend FAI_CONFIG_APORTE_FONDO.Montoaportelocal%TYPE;
BEGIN
   SELECT NVL(SUM(MontoAporteLocal),0), NVL(SUM(MontoAporteMoneda),0)
     INTO nMontoAportePendLocal, nMontoAportePend
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = NVL(nIdFondo,IdFondo)
      AND StsAporte    = 'ACTIVO'
      AND Fecaporte   <= TRUNC(SYSDATE);
   IF cTipoMoneda  = 'L' THEN -- LOCAL
      RETURN(NVL(nMontoAportePendLocal,0));
   ELSIF cTipoMoneda  = 'E' THEN   -- EXTRANJERO
      RETURN(NVL(nMontoAportePend,0));  
   END IF;  
END MONTO_APORTES_POR_PAGAR;

FUNCTION DIAS_ATRASO_1ER_APORTE_ACT(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                                    nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER IS
nDiasAtraso NUMBER := 0;
BEGIN
   SELECT TRUNC(SYSDATE) - MIN(FecAporte)
     INTO nDiasAtraso
     FROM FAI_CONFIG_APORTE_FONDO_DET 
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = NVL(nIdFondo,IdFondo)
      AND StsAporte    = 'ACTIVO';
   IF nDiasAtraso <= 0 THEN
      nDiasAtraso := 0;
   END IF;            
  --
   RETURN (NVL(nDiasAtraso,0));    
END DIAS_ATRASO_1ER_APORTE_ACT;

FUNCTION MONTO_APORTE_ESPECIFICO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                                 nCodAsegurado NUMBER, nIdFondo NUMBER, nNumAporte NUMBER) RETURN NUMBER IS
nMontoAportePend      FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;
BEGIN
   SELECT NVL(SUM(MontoAporteMoneda),0)
     INTO nMontoAportePend
     FROM FAI_CONFIG_APORTE_FONDO_DET
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = NVL(nIdFondo,IdFondo)
      AND StsAporte    = 'ACTIVO'
      AND NumAporte    = nNumAporte;

   RETURN(NVL(nMontoAportePend,0));
END MONTO_APORTE_ESPECIFICO;

END GT_FAI_CONFIG_APORTE_FONDO_DET;
/

--
-- GT_FAI_CONFIG_APORTE_FONDO_DET  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_CONFIG_APORTE_FONDO_DET (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_CONFIG_APORTE_FONDO_DET FOR SICAS_OC.GT_FAI_CONFIG_APORTE_FONDO_DET
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_FAI_CONFIG_APORTE_FONDO_DET TO PUBLIC
/

CREATE OR REPLACE PACKAGE          GT_FAI_CONFIG_APORTE_FONDO AS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, 
                 nIdFondoOrig NUMBER, nIdFondoDest NUMBER, nMontoAporte NUMBER,
                 nMontoAporteLocal NUMBER, cPeriodicidad VARCHAR2, dFecTasaCambio DATE,
                 nTasaCambio NUMBER);
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

PROCEDURE ACTUALIZAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                     nCodAsegurado NUMBER, nIdFondo NUMBER, dFechaConf DATE, cTipoFondo VARCHAR2);

PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                   nCodAsegurado NUMBER, nIdFondo NUMBER, cCodTipoAporte VARCHAR2, 
                   nMontoAporteMoneda NUMBER, nMontoAporteLocal NUMBER, cPeriodicidad VARCHAR2,
                   cIndRecordatorio VARCHAR2);

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                   nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER);

END GT_FAI_CONFIG_APORTE_FONDO;

/

CREATE OR REPLACE PACKAGE BODY          GT_FAI_CONFIG_APORTE_FONDO AS

PROCEDURE COPIAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER, 
                 nIdFondoOrig NUMBER, nIdFondoDest NUMBER, nMontoAporte NUMBER,
                 nMontoAporteLocal NUMBER, cPeriodicidad VARCHAR2, dFecTasaCambio DATE,
                 nTasaCambio NUMBER) IS
cTipoFondoDest          FAI_TIPOS_DE_FONDOS.TipoFondo%TYPE;
nTasaCambioDest         FAI_TIPOS_DE_FONDOS.TasaCambioTopes%TYPE;
nMontoAporteLocalDest   FAI_CONFIG_APORTE_FONDO_DET.MontoAporteLocal%TYPE;
nMontoAporteMonedaDest  FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;

CURSOR APORTES_Q IS
   SELECT CodTipoAporte, IndRecordatorio
     FROM FAI_CONFIG_APORTE_FONDO A, FAI_FONDOS_DETALLE_POLIZA F
    WHERE F.IdFondo      = A.IdFondo
      AND A.CodCia       = nCodCia
      AND A.CodEmpresa   = nCodEmpresa
      AND A.IdPoliza     = nIdPoliza
      AND A.IDetPol      = nIDetPol
      AND A.CodAsegurado = nCodAsegurado
      AND A.IdFondo      = nIdFondoOrig;
BEGIN
  FOR X IN APORTES_Q LOOP
    BEGIN
      SELECT TipoFondo
        INTO cTipoFondoDest
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
         AND IdFondo      = nIdFondoDest;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20100,'No Existe Fondo Destino No. '||nIdFondoDest);
    END;
    nTasaCambioDest := OC_GENERALES.TASA_DE_CAMBIO(GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondoDest), dFecTasaCambio);
    IF GT_FAI_TIPOS_DE_FONDOS.INDICADORES(nCodCia, nCodEmpresa, cTipoFondoDest,'ML') = 'S' THEN
       nMontoAporteMonedaDest := nMontoAporteLocal * nTasaCambio;
       nMontoAporteLocalDest  := nMontoAporteLocal;
    ELSE
       nMontoAporteMonedaDest := nMontoAporte;
       nMontoAporteLocalDest  := nMontoAporte * nTasaCambio;
    END IF;
    INSERT INTO FAI_CONFIG_APORTE_FONDO
          (CodCia, CodEmpresa, IdPoliza, IDetPol, CodAsegurado,
           IdFondo, CodTipoAporte, MontoAporte, MontoAporteLocal, Periodicidad,
           IndRecordatorio, StsConfAportes, FecStatus)
    VALUES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado,
           nIdFondoDest, X.CodTipoAporte, nMontoAporteMonedaDest, nMontoAporteLocalDest,
           cPeriodicidad, X.IndRecordatorio, 'SOLICI', TRUNC(SYSDATE));
  END LOOP;
END COPIAR;

PROCEDURE ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                  nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
BEGIN
  UPDATE FAI_CONFIG_APORTE_FONDO
     SET StsConfAportes = 'ACTIVO',
         FecStatus      = TRUNC(SYSDATE)
   WHERE CodCia       = nCodCia
     AND CodEmpresa   = nCodEmpresa
     AND IdPoliza     = nIdPoliza
     AND IDetPol      = nIDetPol
     AND CodAsegurado = nCodAsegurado
     AND IdFondo      = nIdFondo;
  GT_FAI_CONFIG_APORTE_FONDO_DET.ACTIVAR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo);
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Activar Configuración de Aportes de Fondo No. '||
                              nCodCia||'-'||nCodEmpresa||'-'||nIdPoliza||'-'||nIDetPol||'-'||nCodAsegurado||'-'||nIdFondo);
END ACTIVAR;

PROCEDURE REVERTIR_ACTIVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                           nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
BEGIN
  UPDATE FAI_CONFIG_APORTE_FONDO
     SET StsConfAportes = 'SOLICI',
         FecStatus      = TRUNC(SYSDATE)
   WHERE CodCia       = nCodCia
     AND CodEmpresa   = nCodEmpresa
     AND IdPoliza     = nIdPoliza
     AND IDetPol      = nIDetPol
     AND CodAsegurado = nCodAsegurado
     AND IdFondo      = nIdFondo;
  GT_FAI_CONFIG_APORTE_FONDO_DET.REVERTIR_ACTIVAR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo);
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Revertir Activación Configuración de Aportes de Fondo No. '||
                              nCodCia||'-'||nCodEmpresa||'-'||nIdPoliza||'-'||nIDetPol||'-'||nCodAsegurado||'-'||nIdFondo);
END REVERTIR_ACTIVAR;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                 nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
BEGIN
   UPDATE FAI_CONFIG_APORTE_FONDO
      SET StsConfAportes = 'ANULAD',
          FecStatus      = TRUNC(SYSDATE)
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo;
   GT_FAI_CONFIG_APORTE_FONDO_DET.ANULAR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo);
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Anular Configuración de Aportes de Fondo No. '||
                              nCodCia||'-'||nCodEmpresa||'-'||nIdPoliza||'-'||nIDetPol||'-'||nCodAsegurado||'-'||nIdFondo);
END ANULAR;

PROCEDURE REVERTIR_ANULACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                             nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
BEGIN
  UPDATE FAI_CONFIG_APORTE_FONDO
     SET StsConfAportes = 'ACTIVO',
         FecStatus      = TRUNC(SYSDATE)
   WHERE CodCia         = nCodCia
     AND CodEmpresa     = nCodEmpresa
     AND IdPoliza       = nIdPoliza
     AND IDetPol        = nIDetPol
     AND CodAsegurado   = nCodAsegurado
     AND IdFondo        = nIdFondo
     AND StsConfAportes = 'ANULAD';
  GT_FAI_CONFIG_APORTE_FONDO_DET.REVERTIR_ANULACION(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo);
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Revertir Anulación Configuración de Aportes de Fondos '||
                              nCodCia||'-'||nCodEmpresa||'-'||nIdPoliza||'-'||nIDetPol||'-'||nCodAsegurado||'-'||nIdFondo);
END REVERTIR_ANULACION;

PROCEDURE SUSPENDER(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                    nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
BEGIN
  UPDATE FAI_CONFIG_APORTE_FONDO
     SET StsConfAportes = 'SUSPEN',
         FecStatus      = TRUNC(SYSDATE)
   WHERE CodCia       = nCodCia
     AND CodEmpresa   = nCodEmpresa
     AND IdPoliza     = nIdPoliza
     AND IDetPol      = nIDetPol
     AND CodAsegurado = nCodAsegurado
     AND IdFondo      = nIdFondo;
  GT_FAI_CONFIG_APORTE_FONDO_DET.SUSPENDER(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo);
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Suspender Configuración de Aportes de Fondo No. '||
                              nCodCia||'-'||nCodEmpresa||'-'||nIdPoliza||'-'||nIDetPol||'-'||nCodAsegurado||'-'||nIdFondo);
END SUSPENDER;

PROCEDURE REVERTIR_SUSPENSION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                              nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
BEGIN
  UPDATE FAI_CONFIG_APORTE_FONDO
     SET StsConfAportes = 'ACTIVO',
         FecStatus      = TRUNC(SYSDATE)
   WHERE CodCia       = nCodCia
     AND CodEmpresa   = nCodEmpresa
     AND IdPoliza     = nIdPoliza
     AND IDetPol      = nIDetPol
     AND CodAsegurado = nCodAsegurado
     AND IdFondo      = nIdFondo;
  GT_FAI_CONFIG_APORTE_FONDO_DET.REVERTIR_SUSPENSION(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo);
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Revertir Suspensión de Configuración de Aportes de Fondo No. '||
                              nCodCia||'-'||nCodEmpresa||'-'||nIdPoliza||'-'||nIDetPol||'-'||nCodAsegurado||'-'||nIdFondo);
END REVERTIR_SUSPENSION;

PROCEDURE ACTUALIZAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                     nCodAsegurado NUMBER, nIdFondo NUMBER, dFechaConf DATE, cTipoFondo VARCHAR2) IS
dFecTasaCambio      FAI_CONFIG_APORTE_FONDO_DET.FecTasaCambio%TYPE;
nTasaCambio         FAI_CONFIG_APORTE_FONDO_DET.TasaCambio%TYPE;
BEGIN
   nTasaCambio := OC_GENERALES.TASA_DE_CAMBIO(GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondo), dFechaConf);
   IF GT_FAI_TIPOS_DE_FONDOS.INDICADORES(nCodCia, nCodEmpresa, cTipoFondo,'ML') = 'S' THEN
      BEGIN
         UPDATE FAI_CONFIG_APORTE_FONDO
            SET MontoAporte   = MontoAporteLocal * nTasaCambio
          WHERE CodCia       = nCodCia
            AND CodEmpresa   = nCodEmpresa
            AND IdPoliza     = nIdPoliza
            AND IDetPol      = nIDetPol
            AND CodAsegurado = nCodAsegurado
            AND IdFondo      = nIdFondo;
      END;
   ELSE
      BEGIN -- FAI_fondos_detalle_poliza
         UPDATE FAI_CONFIG_APORTE_FONDO
            SET MontoAporteLocal = MontoAporte * nTasaCambio
          WHERE CodCia       = nCodCia
            AND CodEmpresa   = nCodEmpresa
            AND IdPoliza     = nIdPoliza
            AND IDetPol      = nIDetPol
            AND CodAsegurado = nCodAsegurado
            AND IdFondo      = nIdFondo;
      END;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20100,'Error al Actualizar Configuración de Aportes de Fondo No. '||
                              nCodCia||'-'||nCodEmpresa||'-'||nIdPoliza||'-'||nIDetPol||'-'||nCodAsegurado||'-'||nIdFondo);
END ACTUALIZAR;

PROCEDURE INSERTAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, 
                   nCodAsegurado NUMBER, nIdFondo NUMBER, cCodTipoAporte VARCHAR2, 
                   nMontoAporteMoneda NUMBER, nMontoAporteLocal NUMBER, cPeriodicidad VARCHAR2,
                   cIndRecordatorio VARCHAR2) IS
BEGIN
   BEGIN
      INSERT INTO FAI_CONFIG_APORTE_FONDO
            (CodCia, CodEmpresa, IdPoliza, IDetPol, CodAsegurado,
             IdFondo, CodTipoAporte, MontoAporte, MontoAporteLocal, 
             Periodicidad, IndRecordatorio, StsConfAportes, FecStatus)
      VALUES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado,
             nIdFondo, cCodTipoAporte, nMontoAporteMoneda, nMontoAporteLocal, 
             cPeriodicidad, cIndRecordatorio, 'SOLICI', TRUNC(SYSDATE));
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20100,'Error al Insertar Configuración de Aportes de Fondo No. '||
                                 nCodCia||'-'||nCodEmpresa||'-'||nIdPoliza||'-'||nIDetPol||'-'||nCodAsegurado||'-'||nIdFondo);
   END;
END INSERTAR;

PROCEDURE ELIMINAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, 
                   nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
BEGIN
   GT_FAI_CONFIG_APORTE_FONDO_DET.ELIMINAR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo);

   DELETE FAI_CONFIG_APORTE_FONDO
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo;
END ELIMINAR;

END GT_FAI_CONFIG_APORTE_FONDO;

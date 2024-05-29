CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_FONDOS_DETALLE_POLIZA AS

FUNCTION NUMERO_FONDO RETURN NUMBER;

FUNCTION EXISTEN_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2;

FUNCTION VALIDA_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2;

FUNCTION TIPO_FONDO (nIdFondo NUMBER) RETURN VARCHAR2;

PROCEDURE INSERTA_NUEVO_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER,
                              cTipoFondo VARCHAR2, dFecEmision DATE, cStsFondo VARCHAR2, dFecStatus DATE, cEnvioEstCta VARCHAR2,
                              cNumSolicitud VARCHAR2, nMtoAporteIniLocal NUMBER, cTipoTasa VARCHAR2, nTasaCambioMov NUMBER,
                              dFecTasaCambio DATE, nNumNIP NUMBER, cCodEmpleado VARCHAR2, cNumRefer VARCHAR2, dFechaConf DATE,
                              cIndAplicaCobDiferido VARCHAR2, cIndAplicCobOpcional VARCHAR2, cReglaRetiros VARCHAR2,
                              cIndBonoPolizaEmp VARCHAR2, nPorcBonoEmp NUMBER, dFecFinAplicBono DATE, nPlazoObligado NUMBER,
                              nPlazoComprometido NUMBER, cIndRevaluaAportComp VARCHAR2, nEdadBeneficios NUMBER, nEdadJubilacion NUMBER,
                              cIndDescPrimaCob VARCHAR2, nMesesPreferencial NUMBER, dFecFinPreferencial DATE,
                              nTasaPreferencial NUMBER, nIdFondo OUT NUMBER, cIndTraspaso VARCHAR2, nIdFondoDest NUMBER,
                              nPorcenFondo NUMBER);

PROCEDURE EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                 nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER);

PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                            nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER);

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                 nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                 dFecAnulacion DATE);

PROCEDURE ANULAR_POR_REEXPEDICION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                  nIDetPol NUMBER, nCodAsegurado NUMBER, dFecAnulacion DATE);

FUNCTION VALIDA_ASIGNA_FECHAFIN_VIG(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER,
                                    cTipoFondo VARCHAR2, nPlazoComprometido NUMBER, nEdadJubilacion NUMBER) RETURN BOOLEAN;

PROCEDURE VALIDA_SOLICITUD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER,
                           cTipoFondo VARCHAR2, cNumSolicitud VARCHAR2);

PROCEDURE INSERTA_FONDO_ASOCIADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, cTipoFondo VARCHAR2);

PROCEDURE ELIMINA_FONDO(nIdFondo NUMBER);

PROCEDURE CREA_FONDOS_AUTOMATICOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                  nIDetPol NUMBER, nCodAsegurado NUMBER);

FUNCTION ALTURA_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                      nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER;

PROCEDURE FONDO_RESCATADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                          nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER);

FUNCTION STATUS_FONDO_DETALLE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                              nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN VARCHAR2;

FUNCTION DESCUENTA_PRIMA_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                   nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN VARCHAR2;

FUNCTION FONDO_ASOCIADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                        nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2) RETURN NUMBER;

FUNCTION EXISTEN_TASAS_PRECIOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                               nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                               dFechaIni DATE, dFechaFin DATE, cReferencia IN OUT VARCHAR) RETURN VARCHAR2;

PROCEDURE COPIAR_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPolizaOrig NUMBER,
                        nIDetPol NUMBER, nCodAsegurado NUMBER, nIdPolizaDest NUMBER);

PROCEDURE ACTUALIZA_APORTE_INICIAL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                   nIDetPol NUMBER, nCodAsegurado NUMBER);

FUNCTION PORCENTAJE_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                          nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER;

FUNCTION FONDO_PAGO_PRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                          nIDetPol NUMBER, nCodAsegurado NUMBER) RETURN NUMBER;

FUNCTION NUMERO_SOLICITUD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                          nIDetPol NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2;

PROCEDURE RENOVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPolizaOrig NUMBER,
                  nIDetPolOrig NUMBER, nCodAseguradoOrig NUMBER, nIdPolizaRen NUMBER);

PROCEDURE TRASLADA_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPolizaOrig NUMBER,
                          nIDetPolOrig NUMBER, nCodAseguradoOrig NUMBER, nIDetPolDest NUMBER);

PROCEDURE COPIAR_FONDOS_CERTIFICADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPolizaOrig NUMBER,
                                    nIDetPolOrig NUMBER, nCodAsegurado NUMBER, nIdPolizaDest NUMBER,
                                    nIDetPolDest NUMBER);

FUNCTION FONDO_CONTRATANTE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER;

PROCEDURE APORTACION_COLECTIVA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                               nIDetPol NUMBER, nCodAsegurado NUMBER, nMontoAporte NUMBER);
                               
PROCEDURE COPIAR_FONDOS_REN(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPolizaOrig NUMBER,
                        nIDetPol NUMBER, nCodAsegurado NUMBER, nIdPolizaDest NUMBER);

END GT_FAI_FONDOS_DETALLE_POLIZA;
/
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_FONDOS_DETALLE_POLIZA AS

FUNCTION NUMERO_FONDO RETURN NUMBER IS
nIdFondo    FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
BEGIN
   SELECT SQ_FONDOS.NEXTVAL
     INTO nIdFondo
     FROM DUAL;
   RETURN(nIdFondo);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20200,'No Existe Secuencia para Asignar Número a la Concentradora de Fondos '||
                              'FAI_FONDOS_DETALLE_POLIZA.IDFONDO');
END NUMERO_FONDO;

FUNCTION EXISTEN_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2 IS
cExiste      VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND CodAsegurado  = nCodAsegurado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste  := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste  := 'S';
   END;
   RETURN(cExiste);
END EXISTEN_FONDOS;

FUNCTION VALIDA_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2 IS
nPorcFondoPagoPrima   FAI_FONDOS_DETALLE_POLIZA.PorcFondo%TYPE;
nPorcFondoOtros       FAI_FONDOS_DETALLE_POLIZA.PorcFondo%TYPE;
cFondoPagoPrima       VARCHAR2(1);
cOtrosFondos          VARCHAR2(1);
cValida               VARCHAR2(1);

CURSOR FOND_Q IS
    SELECT TipoFondo, NumSolicitud, PorcFondo
      FROM FAI_FONDOS_DETALLE_POLIZA
     WHERE CodCia        = nCodCia
       AND CodEmpresa    = nCodEmpresa
       AND IdPoliza      = nIdPoliza
       AND IDetPol       = nIDetPol
       AND CodAsegurado  = nCodAsegurado;
BEGIN
   cValida  := 'N';
   IF GT_FAI_FONDOS_DETALLE_POLIZA.EXISTEN_FONDOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado) = 'S' THEN
      cFondoPagoPrima   := 'N';
      cOtrosFondos      := 'N';
      FOR W IN FOND_Q LOOP
         GT_FAI_FONDOS_DETALLE_POLIZA.VALIDA_SOLICITUD(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                       nCodAsegurado, W.TipoFondo, W.NumSolicitud);
         IF GT_FAI_TIPOS_DE_FONDOS.INDICADORES(nCodCia, nCodEmpresa, W.TipoFondo, 'EPP') = 'S' THEN
            cFondoPagoPrima     := 'S';
            nPorcFondoPagoPrima := NVL(nPorcFondoPagoPrima,0) + W.PorcFondo;
         ELSE
            cOtrosFondos        := 'S';
            nPorcFondoOtros     := NVL(nPorcFondoOtros,0) + W.PorcFondo;
         END IF;
      END LOOP;
      IF cFondoPagoPrima = 'S' AND NVL(nPorcFondoPagoPrima,0) <> 100 THEN
         RAISE_APPLICATION_ERROR(-20200,'Debe Asignar el 100% para Fondos Exclusivos para Pago de Primas en Fondos del Asegurado No. ' ||
                                 nCodAsegurado || ' del Certificado/Subgrupo No. ' || nIDetPol);
      END IF;

      IF cOtrosFondos = 'S' AND NVL(nPorcFondoOtros,0) <> 100 THEN
         RAISE_APPLICATION_ERROR(-20200,'Debe Asignar el 100% para los Fondos de Ahorro y/o Jubilación en Fondos del Asegurado No. ' ||
                                 nCodAsegurado || ' del Certificado/Subgrupo No. ' || nIDetPol);
      END IF;
      cValida  := 'S';
   ELSE
      RAISE_APPLICATION_ERROR(-20200,'Debe Asignar los Fondos de Ahorro e Inversión al SubGrupo No. ' || nIDetPol ||
                              ' y Asegurado No. ' || nCodAsegurado);
   END IF;
   RETURN(cValida);
END VALIDA_FONDOS;

FUNCTION TIPO_FONDO (nIdFondo NUMBER) RETURN VARCHAR2 IS
cTipoFondo    FAI_FONDOS_DETALLE_POLIZA.TipoFondo%TYPE;
BEGIN
   SELECT TipoFondo
     INTO cTipoFondo
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE IdFondo    = nIdFondo;
   RETURN(cTipoFondo);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20200,'No Existe No. de Concentradora de Fondos '||TO_CHAR(nIdFondo)||
                              ' FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO');
END TIPO_FONDO;

PROCEDURE INSERTA_NUEVO_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER,
                              cTipoFondo VARCHAR2, dFecEmision DATE, cStsFondo VARCHAR2, dFecStatus DATE, cEnvioEstCta VARCHAR2,
                              cNumSolicitud VARCHAR2, nMtoAporteIniLocal NUMBER, cTipoTasa VARCHAR2, nTasaCambioMov NUMBER,
                              dFecTasaCambio DATE, nNumNIP NUMBER, cCodEmpleado VARCHAR2, cNumRefer VARCHAR2, dFechaConf DATE,
                              cIndAplicaCobDiferido VARCHAR2, cIndAplicCobOpcional VARCHAR2, cReglaRetiros VARCHAR2,
                              cIndBonoPolizaEmp VARCHAR2, nPorcBonoEmp NUMBER, dFecFinAplicBono DATE, nPlazoObligado NUMBER,
                              nPlazoComprometido NUMBER, cIndRevaluaAportComp VARCHAR2, nEdadBeneficios NUMBER, nEdadJubilacion NUMBER,
                              cIndDescPrimaCob VARCHAR2, nMesesPreferencial NUMBER, dFecFinPreferencial DATE,
                              nTasaPreferencial NUMBER, nIdFondo OUT NUMBER, cIndTraspaso VARCHAR2, nIdFondoDest NUMBER,
                              nPorcenFondo NUMBER) IS
nPorcFondo           FAI_TIPOS_DE_FONDOS.PorcFondo%TYPE;
cCodMoneda           FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
cTipoRangoAportes    FAI_TIPOS_DE_FONDOS.TipoRangoAportes%TYPE;
nTasaIntGar          FAI_FONDOS_DETALLE_POLIZA.TasaIntGar%TYPE;
nMtoAporteIniMoneda  FAI_FONDOS_DETALLE_POLIZA.MtoAporteIniMoneda%TYPE;
cNumSolicitudDef     FAI_FONDOS_DETALLE_POLIZA.NumSolicitud%TYPE;
BEGIN
   BEGIN
      SELECT PorcFondo, CodMoneda, TipoRangoAportes,
             NVL(DECODE(NVL(TipoInteresGar,' '),' ',0, GT_FAI_TASAS_DE_INTERES.TASA_INTERES(TipoInteresGar, TipoFondo, TRUNC(SYSDATE))),0) TasaIntGar
        INTO nPorcFondo, cCodMoneda, cTipoRangoAportes, nTasaIntGar
        FROM FAI_TIPOS_DE_FONDOS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND TipoFondo  = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR( -20200, 'Tipo de Fondo No Existe ' || cTipoFondo);
   END;

   IF NVL(nPorcenFondo,0) > 0 THEN
      nPorcFondo := NVL(nPorcenFondo,0);
   END IF;

   BEGIN
      nMtoAporteIniMoneda := nMtoAporteIniLocal * OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, dFecTasaCambio);
      IF cIndTraspaso = 'N' THEN
         nIdFondo  := GT_FAI_FONDOS_DETALLE_POLIZA.NUMERO_FONDO;
      ELSE
         nIdFondo  := nIdFondoDest;
      END IF;

      IF cNumSolicitud IS NULL THEN
         cNumSolicitudDef := GT_FAI_FONDOS_DETALLE_POLIZA.NUMERO_SOLICITUD(nCodCia, nCodEmpresa, nIdPoliza,
                                                                           nIDetPol, nCodAsegurado);
      ELSE
         cNumSolicitudDef := cNumSolicitud;
      END IF;

      INSERT INTO FAI_FONDOS_DETALLE_POLIZA
            (CodCia, CodEmpresa, IdPoliza, IDetPol, CodAsegurado, IdFondo, TipoFondo, FecEmision, StsFondo,
             FecStatus, PorcFondo, EnvioEstCta, NumSolicitud, MtoAporteIniLocal, MtoAporteIniMoneda, TipoTasa,
             TasaCambioMov, FecTasaCambio, TasaIntGar, TipoRangoAportes, NumNIP, CodEmpleado, NumRefer, FechaConf,
             IndAplicCobOpcional, IndAplicaCobDiferido, ReglaRetiros, IndBonoPolizaEmp, PorcBonoEmp, FecFinAplicBono,
             PlazoObligado, PlazoComprometido, IndRevaluaAportComp, EdadBeneficios, EdadJubilacion, IndDescPrimaCob,
             MesesPreferencial, FecFinPreferencial, TasaPreferencial, IndFondoContrat)
      VALUES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo, cTipoFondo, dFecEmision, cStsFondo,
             dFecStatus, nPorcFondo, cEnvioEstCta, cNumSolicitudDef, nMtoAporteIniLocal, nMtoAporteIniMoneda, cTipoTasa,
             nTasaCambioMov, dFecTasaCambio, nTasaIntGar, cTipoRangoAportes, nNumNIP, cCodEmpleado, cNumRefer, dFechaConf,
             cIndAplicCobOpcional, cIndAplicaCobDiferido, cReglaRetiros, cIndBonoPolizaEmp, nPorcBonoEmp, dFecFinAplicBono,
             nPlazoObligado, nPlazoComprometido, cIndRevaluaAportComp, nEdadBeneficios, nEdadJubilacion, cIndDescPrimaCob,
             nMesesPreferencial, dFecFinPreferencial, nTasaPreferencial, 'N');
   END;
END INSERTA_NUEVO_FONDO;

PROCEDURE EMITIR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                 nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
cTipoFondo              FAI_FONDOS_DETALLE_POLIZA.TipoFondo%TYPE;
cStsPoliza              POLIZAS.StsPoliza%TYPE;
nPrimaNivMoneda         COBERT_ACT.PrimaNivMoneda%TYPE;
nPrimaNivLocal          COBERT_ACT.PrimaNivLocal%TYPE;
cCodPlanPago            POLIZAS.CodPlanPago%TYPE;
cCodAportIni            FAI_TIPOS_DE_FONDOS.CodAportIni%TYPE;
nPorcFondo              FAI_FONDOS_DETALLE_POLIZA.PorcFondo%TYPE;
cCodMoneda              FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
nMontoMovMoneda         FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nMontoMovLocal          FAI_CONCENTRADORA_FONDO.MontoMovLocal%TYPE;
nMontoAporteFondo       DETALLE_POLIZA.MontoAporteFondo%TYPE;
cPeriodicidad           FAI_CONFIG_APORTE_FONDO.Periodicidad%TYPE;
nTasaCambioMov          TASAS_CAMBIO.Tasa_Cambio%TYPE;
nNumPagos               PLAN_DE_PAGOS.NumPagos%TYPE;
nIdTransaccion          TRANSACCION.IdTransaccion%TYPE := 0;
nMeses                  NUMBER(5) := 0;

CURSOR CONCEN_Q IS
    SELECT IdFondo, IdMovimiento, CodCptoMov, MontoMovMoneda
      FROM FAI_CONCENTRADORA_FONDO
     WHERE CodCia        = nCodCia
       AND CodEmpresa    = nCodEmpresa
       AND IdPoliza      = nIdPoliza
       AND IDetPol       = nIDetPol
       AND CodAsegurado  = nCodAsegurado
       AND IdFondo       = nIdFondo
       AND StsMovimiento = 'SOLICI'
       AND GT_FAI_MOVIMIENTOS_FONDOS.TIPO_MOVIMIENTO(CodCia, CodEmpresa, cTipoFondo, CodCptoMov) IN ('TR');
BEGIN
   BEGIN
      SELECT StsPoliza, CodPlanPago
        INTO cStsPoliza, cCodPlanPago
        FROM POLIZAS
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR( -20200, 'NO Existe Póliza No. ' || nIdPoliza);
   END;
   IF cStsPoliza IN ('SOL','XRE') THEN
      -- Activa y Contabiliza los Movimientos para Fondos de Renovación
      cTipoFondo     := GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(nIdFondo);
      IF cStsPoliza = 'XRE' THEN
         FOR W IN CONCEN_Q LOOP
            IF NVL(nIdTransaccion,0) = 0 THEN
               nIdTransaccion  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');
            END IF;

            OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa,  21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                        nIdPoliza, nIDetPol, nIdFondo, W.CodCptoMov, NVL(W.MontoMovMoneda,0));

            UPDATE FAI_CONCENTRADORA_FONDO
               SET IdTransaccion   = nIdTransaccion,
                   FecMovimiento   = TRUNC(SYSDATE),
                   FecRealRegistro = TRUNC(SYSDATE)
             WHERE CodCia        = nCodCia
               AND CodEmpresa    = nCodEmpresa
               AND IdPoliza      = nIdPoliza
               AND IDetPol       = nIDetPol
               AND CodAsegurado  = nCodAsegurado
               AND IdFondo       = W.IdFondo
               AND IdMovimiento  = W.IdMovimiento;
         END LOOP;

         IF NVL(nIdTransaccion,0) > 0 THEN
            GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                          nCodAsegurado, nIdFondo, nIdTransaccion);
            GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOV_INFORMATIVOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                               nCodAsegurado, nIdFondo, nIdTransaccion);
            OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');
         END IF;
      END IF;

      cCodMoneda     := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondo);
      nTasaCambioMov := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));

      IF GT_FAI_TIPOS_DE_FONDOS.INDICADORES(nCodCia, nCodEmpresa, cTipoFondo, 'EPP') = 'S' THEN
         nPrimaNivMoneda := OC_COBERT_ACT.TOTAL_PRIMA_NIVELADA(nCodCia, nIdPoliza, nIDetPol, nCodAsegurado, 0) +
                            OC_COBERT_ACT_ASEG.TOTAL_PRIMA_NIVELADA(nCodCia, nIdPoliza, nIDetPol, nCodAsegurado, 0);
         IF NVL(nPrimaNivMoneda,0) <> 0 THEN
            nPrimaNivLocal := NVL(nPrimaNivMoneda,0) * nTasaCambioMov;
            cCodPlanPago  := OC_POLIZAS.PLAN_DE_PAGOS(nCodCia, nCodEmpresa, nIdPoliza);
            nMeses        := OC_PLAN_DE_PAGOS.FRECUENCIA_PAGOS(nCodCia, nCodEmpresa, cCodPlanPago);
            nNumPagos     := OC_PLAN_DE_PAGOS.CANTIDAD_PAGOS(nCodCia, nCodEmpresa, cCodPlanPago);
            cPeriodicidad := OC_VALORES_DE_LISTAS.BUSCA_VALORDESC('MESESFREC',TRIM(TO_CHAR(nMeses)));
            IF cPeriodicidad = 'NO EXISTE' THEN
               cPeriodicidad := 'ANUAL';
            END IF;
            GT_FAI_CONFIG_APORTE_FONDO.INSERTAR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado,
                                                nIdFondo, 'PROGRA', NVL(nPrimaNivMoneda,0) / nNumPagos,
                                                NVL(nPrimaNivLocal,0) / nNumPagos,  cPeriodicidad, 'N');
            GT_FAI_CONFIG_APORTE_FONDO_DET.GENERAR_APORTACIONES(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                nCodAsegurado, nIdFondo, cPeriodicidad,
                                                                NVL(nPrimaNivMoneda,0), 'PLANPAGOS');
         END IF;
      ELSIF GT_FAI_TIPOS_DE_FONDOS.INDICADORES(nCodCia, nCodEmpresa, cTipoFondo, 'FCOL') = 'N' THEN
         cCodAportIni      := GT_FAI_TIPOS_DE_FONDOS.CODIGO_APORTE_INICIAL(nCodCia, nCodEmpresa, cTipoFondo);
         nPorcFondo        := GT_FAI_FONDOS_DETALLE_POLIZA.PORCENTAJE_FONDO(nCodCia, nCodEmpresa, nIdPoliza,
                                                                            nIDetPol, nCodAsegurado, nIdFondo);
         nMontoAporteFondo := OC_DETALLE_POLIZA.MONTO_APORTE_FONDOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol);
         nMontoMovMoneda   := NVL(nMontoAporteFondo,0) * nPorcFondo / 100;
         nMontoMovLocal    := NVL(nMontoMovMoneda,0) * nTasaCambioMov;
         GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                              nCodAsegurado, nIdFondo,  cCodAportIni,
                                                              0, cCodMoneda, nMontoMovMoneda, nMontoMovLocal,
                                                              'D', nTasaCambioMov, TRUNC(SYSDATE), TRUNC(SYSDATE),
                                                              OC_CATALOGO_DE_CONCEPTOS.DESCRIPCION_CONCEPTO(nCodCia, cCodAportIni));
      END IF;
   END IF;
   GT_FAI_BENEFICIARIOS_FONDO.ACTIVAR(nCodCia, nCodEmpresa, nIdPoliza,
                                      nIDetPol, nCodAsegurado, nIdFondo);
   GT_FAI_CONFIG_APORTE_FONDO.ACTIVAR(nCodCia, nCodEmpresa, nIdPoliza,
                                      nIDetPol, nCodAsegurado, nIdFondo);

   UPDATE FAI_FONDOS_DETALLE_POLIZA
      SET FecEmision   = NVL(FechaConf, TRUNC(SYSDATE)),
          StsFondo     = 'EMITID',
          FecStatus    = TRUNC(SYSDATE)
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo;
END EMITIR;

PROCEDURE REVERTIR_EMISION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                            nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS

nIdTransaccion          TRANSACCION.IdTransaccion%TYPE := 0;
nNumRenov               POLIZAS.NumRenov%TYPE;
cStsFondo               FAI_FONDOS_DETALLE_POLIZA.StsFondo%TYPE;
cTipoFondo              FAI_FONDOS_DETALLE_POLIZA.TipoFondo%TYPE;

CURSOR CONCEN_Q IS
    SELECT DISTINCT IdTransaccion
      FROM FAI_CONCENTRADORA_FONDO
     WHERE CodCia        = nCodCia
       AND CodEmpresa    = nCodEmpresa
       AND IdPoliza      = nIdPoliza
       AND IDetPol       = nIDetPol
       AND CodAsegurado  = nCodAsegurado
       AND IdFondo       = nIdFondo
       AND StsMovimiento = 'EMITID'
       AND GT_FAI_MOVIMIENTOS_FONDOS.TIPO_MOVIMIENTO(CodCia, CodEmpresa, cTipoFondo, CodCptoMov) IN ('TR');

CURSOR COMP_Q IS
   SELECT NumComprob
     FROM COMPROBANTES_CONTABLES
    WHERE CodCia    = nCodCia
      AND NumTransaccion = nIdTransaccion;
BEGIN
   BEGIN
      SELECT NumRenov
        INTO nNumRenov
        FROM POLIZAS
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR( -20200, 'NO Existe Póliza No. ' || nIdPoliza);
   END;

   IF nNumRenov = 0 THEN
      cStsFondo := 'SOLICI';
   ELSE
      cStsFondo := 'XRENOV';
   END IF;

   UPDATE FAI_FONDOS_DETALLE_POLIZA
      SET FecEmision   = NULL,
          StsFondo     = cStsFondo,
          FecStatus    = TRUNC(SYSDATE)
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND CodAsegurado = nCodAsegurado
      AND IdFondo      = nIdFondo;

   GT_FAI_BENEFICIARIOS_FONDO.SOLICITUD(nCodCia, nCodEmpresa, nIdPoliza,
                                        nIDetPol, nCodAsegurado, nIdFondo, nNumRenov);
   GT_FAI_CONFIG_APORTE_FONDO.ELIMINAR(nCodCia, nCodEmpresa, nIdPoliza,
                                       nIDetPol, nCodAsegurado, nIdFondo);

   DELETE FAI_CONCENTRADORA_FONDO
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCodAsegurado
      AND IdFondo       = nIdFondo
      AND IdTransaccion = 0;

   -- Revierte los Movimientos si es una Renovación
   cTipoFondo     := GT_FAI_FONDOS_DETALLE_POLIZA.TIPO_FONDO(nIdFondo);

   FOR W IN CONCEN_Q LOOP
      nIdTransaccion := W.IdTransaccion;
      FOR Y IN COMP_Q LOOP
         OC_COMPROBANTES_DETALLE.ELIMINA_DETALLE(nCodCia, Y.NumComprob);
         OC_COMPROBANTES_CONTABLES.ELIMINA_COMPROBANTE(nCodCia, Y.NumComprob);
      END LOOP;
      OC_DETALLE_TRANSACCION.ELIMINAR(nCodCia, nCodEmpresa, W.IdTransaccion);
      OC_TRANSACCION.ELIMINAR(nCodCia, nCodEmpresa, W.IdTransaccion);

      UPDATE FAI_CONCENTRADORA_FONDO
         SET IdTransaccion   = 0,
             FecMovimiento   = TRUNC(SYSDATE),
             FecRealRegistro = TRUNC(SYSDATE),
             StsMovimiento   = 'SOLICI',
             FecStatus       = TRUNC(SYSDATE)
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND IdPoliza        = nIdPoliza
         AND IDetPol         = nIDetPol
         AND CodAsegurado    = nCodAsegurado
         AND IdFondo         = nIdFondo
         AND IdTransaccion   = W.IdTransaccion;
   END LOOP;
END REVERTIR_EMISION;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                 nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER, dFecAnulacion DATE) IS
BEGIN
   IF GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                     nCodAsegurado, nIdFondo, dFecAnulacion) > 0 THEN
      RAISE_APPLICATION_ERROR(-20200,'Fondo No. ' || nIdFondo || ' del Asegurado No. ' || nCodAsegurado ||
                              ' Tiene Saldo NO Puede Anularlo');
   ELSE
      -- Elimina Movimiento Con Transaccion 0 que estan en Solicitud
      GT_FAI_CONCENTRADORA_FONDO.ELIMINA_MOV_SOLICITUD(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                       nCodAsegurado, nIdFondo);
      GT_FAI_BENEFICIARIOS_FONDO.ANULAR(nCodCia, nCodEmpresa, nIdPoliza,
                                        nIDetPol, nCodAsegurado, nIdFondo);

      GT_FAI_CONFIG_APORTE_FONDO.ANULAR(nCodCia, nCodEmpresa, nIdPoliza,
                                        nIDetPol, nCodAsegurado, nIdFondo);

      UPDATE FAI_FONDOS_DETALLE_POLIZA
         SET StsFondo     = 'ANULAD',
             FecStatus    = dFecAnulacion
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND CodAsegurado = nCodAsegurado
         AND IdFondo      = nIdFondo;
   END IF;
END ANULAR;

PROCEDURE ANULAR_POR_REEXPEDICION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                  nIDetPol NUMBER, nCodAsegurado NUMBER, dFecAnulacion DATE) IS

nIdTransacPagos      TRANSACCION.IdTransaccion%TYPE;
nCodCliente          POLIZAS.CodCliente%TYPE;
cCod_Moneda          POLIZAS.Cod_Moneda%TYPE;
nIdPrimaDeposito     PRIMAS_DEPOSITO.IdPrimaDeposito%TYPE;
nIdFactura           FACTURAS.IdFactura%TYPE;
nTotPagos            DETALLE_FACTURAS.Saldo_Det_Local%TYPE;
nSaldoMoneda         FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nSaldoLocal          FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nMontoAportesMoneda  FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nMontoAportesLocal   FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
cCodCptoMov          FAI_MOVIMIENTOS_FONDOS.CodCptoMov%TYPE;
nIdTransaccion       TRANSACCION.IdTransaccion%TYPE;
nTasaCambioMov       TASAS_CAMBIO.Tasa_Cambio%TYPE;
dFechaContable       DATE;

CURSOR FONDOS_Q IS -- GTC - 17-12-2018
   SELECT TipoFondo, IdFondo,
          GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(CodCia, CodEmpresa, TipoFondo) CodMoneda
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE StsFondo      = 'EMITID'
      AND CodAsegurado  = nCodAsegurado
      AND IDetPol       = nIDetPol
      AND IdPoliza      = nIdPoliza
      AND CodCia        = nCodCia;

CURSOR FACT_PAG_Q IS
   SELECT IdFactura, CodCobrador
     FROM FACTURAS
    WHERE CodCia       = nCodCia
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND StsFact     IN ('PAG','ABO')
    ORDER BY IdFactura;

CURSOR PAG_Q IS
   SELECT IdRecibo, IdTransaccion, Num_Recibo_Ref,
          NVL(Monto,0) MontoPago, FormPago
     FROM PAGOS
    WHERE CodCia       = nCodCia
      AND IdFactura    = nIdFactura
      AND IdRecibo     > 0
    ORDER BY IdTransaccion DESC;
BEGIN
   dFechaContable  := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_CONTABLE(nCodCia, nCodEmpresa);
   FOR F IN FACT_PAG_Q LOOP
      nIdFactura       := F.IdFactura;
      nTotPagos        := 0;
      IF GT_FAI_CONCENTRADORA_FONDO.ES_FACTURA_DE_FONDOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, F.IdFactura) = 'N' THEN
         nIdTransacPagos  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 12, 'REVPAG');
      ELSE
         nIdTransacPagos  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'REVPAG');
      END IF;
      FOR W IN PAG_Q LOOP
         OC_FACTURAS.REVERTIR_PAGO(nCodCia, nCodEmpresa, F.IdFactura, W.IdRecibo, dFechaContable, F.CodCobrador, W.IdTransaccion);
         nTotPagos  := NVL(nTotPagos,0) + W.MontoPago;
      END LOOP;
      OC_COMISIONES.REVERSA_PAGO(nCodCia, F.IdFactura);
      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacPagos, 'C');

      BEGIN
         SELECT CodCliente, Cod_Moneda
           INTO nCodCliente, cCod_Moneda
           FROM POLIZAS
          WHERE IdPoliza = nIdPoliza
            AND CodCia   = nCodCia;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR( -20200, 'NO Existe Póliza No. ' || nIdPoliza);
      END;

      -- Revierte Aplicación de Primas en Depósito
      FOR W IN PAG_Q LOOP
         IF W.FormPago = 'PRD' THEN
            OC_PRIMAS_DEPOSITO.REVERTIR_APLICACION(nCodCia, nCodEmpresa, TO_NUMBER(W.Num_Recibo_Ref));
         END IF;
      END LOOP;

      nIdPrimaDeposito := OC_PRIMAS_DEPOSITO.INSERTAR(nCodCliente, nTotPagos, cCod_Moneda,
                                                      'Prima en Depósito por Reverso de Pagos realizados al Recibo No. ' ||
                                                      nIdFactura || ' de la Póliza No. ' || nIdPoliza, nIdPoliza, nIDetPol);
      OC_PRIMAS_DEPOSITO.EMITIR(nCodCia, nCodEmpresa, nIdPrimaDeposito, dFechaContable);
   END LOOP;

   nMontoAportesMoneda := 0;
   FOR F IN FONDOS_Q LOOP
      nTasaCambioMov       := OC_GENERALES.TASA_DE_CAMBIO(F.CodMoneda, dFechaContable);
      nSaldoMoneda         := GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza,
                                                                             nIDetPol, nCodAsegurado, F.IdFondo, dFechaContable) * -1;
      nSaldoLocal          := NVL(nSaldoMoneda,0) * nTasaCambioMov;
      cCodCptoMov          := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, F.TipoFondo, 'AJ');
      nIdTransaccion       := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 21, 'MOVFON');

      GT_FAI_CONCENTRADORA_FONDO.INSERTA_MOV_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, F.IdFondo,
                                                           cCodCptoMov, nIdTransaccion, F.CodMoneda, nSaldoMoneda,  nSaldoLocal,
                                                           'D', nTasaCambioMov, dFechaContable, dFechaContable,
                                                           'Cancelación del Fondo por Reexpedición de la Póliza');
      OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa,  21, 'MOVFON', 'FAI_CONCENTRADORA_FONDO',
                                  nIdPoliza, nIDetPol, F.IdFondo, cCodCptoMov, NVL(nSaldoMoneda,0));
      GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, F.IdFondo, nIdTransaccion);
      OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');

      /*SELECT NVL(SUM(MontoMovMoneda),0) + NVL(nMontoAportesMoneda,0)
        INTO nMontoAportesMoneda
        FROM FAI_CONCENTRADORA_FONDO
       WHERE CodCia                = nCodCia
         AND CodEmpresa            = nCodEmpresa
         AND IdPoliza              = nIdPoliza
         AND IDetPol               = nIDetPol
         AND CodAsegurado          = nCodAsegurado
         AND IdFondo               = F.IdFondo
         AND TRUNC(FecMovimiento) <= dFechaContable
         AND StsMovimiento         = 'ACTIVO'
         AND GT_FAI_MOVIMIENTOS_FONDOS.TIPO_MOVIMIENTO(nCodCia, nCodEmpresa, F.TipoFondo, CodCptoMov) IN ('AA', 'AI', 'AE');*/

      GT_FAI_FONDOS_DETALLE_POLIZA.ANULAR(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, F.IdFondo, dFecAnulacion);
   END LOOP;

   /*IF NVL(nMontoAportesMoneda,0) > 0 THEN
      nIdPrimaDeposito := OC_PRIMAS_DEPOSITO.INSERTAR(nCodCliente, NVL(nMontoAportesMoneda,0), cCod_Moneda,
                                                      'Prima en Depósito por Reverso de Aportaciones a Fondos de la Póliza No. ' || nIdPoliza,
                                                      nIdPoliza, nIDetPol);
      OC_PRIMAS_DEPOSITO.EMITIR(nCodCia, nCodEmpresa, nIdPrimaDeposito, dFechaContable);
   END IF;*/
END ANULAR_POR_REEXPEDICION;

FUNCTION VALIDA_ASIGNA_FECHAFIN_VIG(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER,
                                    cTipoFondo VARCHAR2, nPlazoComprometido NUMBER, nEdadJubilacion NUMBER/*
                                    nIdePol NUMBER, pcCodProd VARCHAR, pcCodPlan VARCHAR, pcRevPlan VARCHAR,
                                    pcCodRamo VARCHAR, pdFechaNac DATE, pdFechaIng DATE,
                                    pdFechaFin IN OUT DATE, pnCodError IN OUT NUMBER*/ ) RETURN BOOLEAN IS
nEdad               FAI_TIPOS_DE_FONDOS.EdadMin%TYPE;
nEdadMin            FAI_TIPOS_DE_FONDOS.EdadMin%TYPE;
nEdadMax            FAI_TIPOS_DE_FONDOS.EdadMax%TYPE;
nEdadRetiro         FAI_TIPOS_DE_FONDOS.EdadRetiro%TYPE;
--
bValido             BOOLEAN := FALSE;
--
/*nEdadMaxConfig      NUMBER(5);
nEdadMaxRetiro      NUMBER(8);
dFechaIni           DATE;
nAniosExcedente     NUMBER(8) := 0;
nAniosCalc          NUMBER(8);
nAniosHoy           NUMBER(8);
nAniosDifer         NUMBER(8);
nAniosRetiro        NUMBER(8);
cTipoVig            PRODUCTO.Ind_Tipovig_Forma%TYPE;
nPlazoComprometido  FAI_FONDOS_DETALLE_POLIZA.PlazoComprometido%TYPE;
nEdadJubilacion     FAI_FONDOS_DETALLE_POLIZA.EdadJubilacion%TYPE;*/
BEGIN
  --
  nEdad := OC_ASEGURADO.EDAD_ASEGURADO(nCodCia, nCodEmpresa, nCodAsegurado, TRUNC(SYSDATE));
  -- VALIDAR EDAD ESTE EN LOS RANGOS DE EDAD EDAD RETIRO EN TIPOS DE FONDOS LE DOY O NO LE DOY EL FONDO NO INSERTA FONDO
  -- LEER FUNCION DE PLAZO COMPROMETIDO
  --QUITAR
   BEGIN
      SELECT EdadMin, EdadMax, EdadRetiro
        INTO nEdadMin, nEdadMax, nEdadRetiro
        FROM FAI_TIPOS_DE_FONDOS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND TipoFondo  = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR( -20200, 'Tipo de Fondo No Existe ' || cTipoFondo);
   END;

   IF nEdad < nEdadMin THEN
      bValido := FALSE;
   ELSIF nEdad > nEdadMax THEN
         bValido := FALSE;
   ELSIF nEdad = nEdadRetiro THEN
         bValido := FALSE;
   ELSE
      bValido := TRUE;
   END IF;
/*         SELECT NVL( MAX( T.EdadRetiro ), 1 )
           INTO nEdadMaxRetiro
           FROM FAI_TIPOS_DE_FONDOS T, TIPOS_FONDOS_PLAN_PROD TP
          WHERE TP.CodProd  = pcCodProd
            AND TP.CodPlan  = pcCodPlan
            AND TP.RevPlan  = pcRevPlan
            AND TP.CodRamo  = pcCodRamo
            AND T.TipoFondo = TP.TipoFondo;
-- AÑO DE VIG PARA RETIRAR EL FONDO
-- FAI_TIPOS_FONDOS   ANIO PERIODO RETIRO
         BEGIN
            SELECT Descrip
              INTO nAniosExcedente
              FROM LVAL
             WHERE TipoLval = 'EXCRETF'
               AND CodLval  = TO_CHAR(pdFechaIng, 'RRRR');
         EXCEPTION
            WHEN OTHERS THEN
                nAniosExcedente := 5;
         END;

         IF nEdadMaxRetiro = 1 THEN
            pnCodError := 3;
         ELSE
            BEGIN
               SELECT Ind_TipoVig_Forma
                 INTO cTipoVig
                 FROM PRODUCTO
                WHERE CodProd = pcCodProd;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  cTipoVig := 'R';
            END;
            BEGIN
               SELECT NVL(MAX(PlazoComprometido),0), NVL(MAX(EdadJubilacion),pnEdad)
                 INTO nPlazoComprometido, nEdadJubilacion
                 FROM FAI_FONDOS_DETALLE_POLIZA
                WHERE IdePol = nIdePol;
            END;*/
            -- AQUI SI LOS AÑOS PARA EL RETIRO FAI_TIPO_DE_RETIRO ****NO ENTIENDO FALTA TABLA***
            /*IF cTipoVig = 'R' THEN
               -- Se Condiciona Plazo Comprometido para Fondos EC - 16/06/2008
               IF NVL(nPlazoComprometido,0) = 0 THEN
                  nAniosHoy    := TO_NUMBER(TO_CHAR( pdFechaIng,'RRRR'));
                  nAniosRetiro := TO_NUMBER(TO_CHAR( pdFechaNac,'RRRR')) + nEdadMaxRetiro;
                  nAniosDifer  := nAniosRetiro - nAniosHoy;
                  IF nAniosDifer < nAniosExcedente THEN
                     nAniosCalc := nAniosExcedente; -- TIEMPOMINIMO SON AÑOS EXCEDENTE
                     dFechaIni  := pdFechaIng;
                  ELSE
                     nAniosCalc := nEdadMaxRetiro;
                     dFechaIni  := pdFechaNac;
                  END IF;
               ELSE
                  -- Se considera el Plazo Mayor entre el Plazo Comprometido
                  -- y la Diferencia de Años entre la Edad del Asegurado
                  -- y la Edad Maxima de Retiro del Fondo EC - 16/06/2008
                  dFechaIni  := pdFechaIng;
                  IF NVL(nEdadJubilacion,0) > 0 THEN --VIENE TIPO DE FONDO
                     IF (pnEdad - nEdadJubilacion) > NVL(nPlazoComprometido,0) THEN
                        nAniosCalc := (pnEdad - nEdadJubilacion);
                     ELSE
                        nAniosCalc := NVL(nPlazoComprometido,0);
                     END IF;
                  ELSE
                     nAniosCalc := NVL(nPlazoComprometido,0);
                  END IF;
               END IF;
               nAniosCalc := TO_NUMBER( TO_CHAR( dFechaIni, 'RRRR' ) ) + nAniosCalc;
               BEGIN
 -- DE LA POLIZA--     pdFechaFin  := TO_DATE( TO_CHAR( pdFechaIng, 'DD' ) || '/' || TO_CHAR( pdFechaIng, 'MM' ) || '/' || TO_CHAR( nAniosCalc ), 'DD/MM/RRRR' );
               EXCEPTION
                  WHEN OTHERS THEN
                      IF TO_CHAR( pdFechaIng, 'MM' ) = '02' THEN
                            IF TO_CHAR( pdFechaIng, 'DD' ) = '29' THEN
                               pdFechaFin := TO_DATE( '01/03/' || TO_CHAR( nAniosCalc ), 'DD/MM/RRRR' );
                          END IF;
                     END IF;
               END;
            ELSE
               dFechaIni   := pdFechaIng;
               pdFechaFin  := TRUNC(PR_POLIZA_DETALLE.BUSCA_FEC_FIN_VIG(cTipoVig,dFechaIni,'2'));
            END IF;

            IF TRUNC(NVL(pdFechaFin,TRUNC(SYSDATE))) <= TRUNC(SYSDATE) THEN
               pnCodError := 5;
            ELSE
               bValido := TRUE;
            END IF;
         END IF;
      END IF;
   END IF;*/
   RETURN( bValido );
END VALIDA_ASIGNA_FECHAFIN_VIG;

PROCEDURE VALIDA_SOLICITUD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER,
                           cTipoFondo VARCHAR2, cNumSolicitud VARCHAR2) IS

cCodArt            FAI_TIPOS_DE_FONDOS.CodArticulo%TYPE;
cNumSolicitudPol   FAI_FONDOS_DETALLE_POLIZA.NumSolicitud%TYPE;
nNumRenov          POLIZAS.NumRenov%TYPE;
cIdTipoSeg         DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob           DETALLE_POLIZA.PlanCob%TYPE;
cExiste            VARCHAR2(1);
nRegs              NUMBER(8);
cTipo              VARCHAR(2);
BEGIN
   BEGIN
      SELECT NumRenov
        INTO nNumRenov
        FROM POLIZAS
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR( -20200, 'NO Existe Póliza No. ' || nIdPoliza);
   END;

   BEGIN
      SELECT IdTipoSeg, PlanCob
        INTO cIdTipoSeg, cPlanCob
        FROM DETALLE_POLIZA
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR( -20200, 'NO Existe Detalle de No. ' || nIDetPol || ' en Póliza No. ' || nIdPoliza);
   END;

   BEGIN
      SELECT NVL(CodArticulo,'999')
        INTO cCodArt
        FROM FAI_TIPOS_DE_FONDOS
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND TipoFondo     = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'El Tipo de Fondo no Existe, Favor de Verificar');
   END;
   --
   IF nNumRenov = 0 THEN
      IF GT_FAI_TIPOS_FONDOS_PRODUCTOS.FONDOS_COLECTIVOS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob ) = 'N' THEN
         BEGIN
            SELECT 'S'
              INTO cExiste
              FROM FAI_FONDOS_DETALLE_POLIZA
             WHERE NumSolicitud  = cNumSolicitud
               AND CodCia        = nCodCia
               AND CodEmpresa    = nCodEmpresa
               AND IdPoliza     != nIdPoliza; -- Solo Fondos de Pólizas Nuevas NO Renovaciones
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                cExiste := 'N';
            WHEN TOO_MANY_ROWS THEN
                cExiste := 'S';
         END;
      ELSE
         BEGIN
            SELECT 'S'
              INTO cExiste
              FROM FAI_FONDOS_DETALLE_POLIZA
             WHERE NumSolicitud  = cNumSolicitud
               AND CodCia        = nCodCia
               AND CodEmpresa    = nCodEmpresa
               AND IdPoliza      = nIdPoliza
               AND CodAsegurado != nCodAsegurado; -- Solo Fondos de Pólizas Nuevas NO Renovaciones
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cExiste := 'N';
            WHEN TOO_MANY_ROWS THEN
               RAISE_APPLICATION_ERROR(-20200,'No. de Solicitud del Fondo ya Existe para otro Asegurado en la Misma Póliza');
         END;

         BEGIN
            SELECT 'S'
              INTO cExiste
              FROM FAI_FONDOS_DETALLE_POLIZA
             WHERE NumSolicitud  = cNumSolicitud
               AND CodCia        = nCodCia
               AND CodEmpresa    = nCodEmpresa
               AND IdPoliza     != nIdPoliza
               AND CodAsegurado != nCodAsegurado; -- Solo Fondos de Pólizas Nuevas NO Renovaciones
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cExiste := 'N';
            WHEN TOO_MANY_ROWS THEN
               cExiste := 'S';
         END;
      END IF;
   ELSE
      cExiste := 'N';
   END IF;

   IF NVL(cExiste,'N') = 'S' THEN
      RAISE_APPLICATION_ERROR(-20200,'No. de Solicitud del Fondo ya Existe en el Sistema para otra Póliza y/o Asegurado');
   END IF;

   IF GT_FAI_TIPOS_FONDOS_PRODUCTOS.FONDOS_COLECTIVOS(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob ) = 'N' THEN
      SELECT COUNT(*)
        INTO nRegs
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa
         AND IdPoliza    = nIdPoliza
         AND IDetPol     = nIDetPol
         AND StsFondo   != 'SOLICI';

      IF nRegs > 0 THEN
         IF cCodArt = '999' THEN
            SELECT NVL(MAX(F.NumSolicitud),0)
              INTO cNumSolicitudPol
              FROM FAI_FONDOS_DETALLE_POLIZA F
             WHERE F.CodCia      = nCodCia
               AND F.CodEmpresa  = nCodEmpresa
               AND F.IdPoliza    = nIdPoliza
               AND F.IDetPol     = nIDetPol
               AND F.StsFondo   != 'SOLICI';

            IF cNumSolicitudPol > 0 THEN
               IF cNumSolicitud != cNumSolicitudPol THEN
                  RAISE_APPLICATION_ERROR(-20200,'No. de Solicitud debe ser la Misma que se Ingreso en la Póliza No. ' || nIdPoliza);
               END IF;
            END IF;
         ELSE
            FOR rDatos IN (SELECT F.NumSolicitud
                             FROM FAI_FONDOS_DETALLE_POLIZA F
                            WHERE F.CodCia     = nCodCia
                              AND F.CodEmpresa = nCodEmpresa
                              AND F.IdPoliza   = nIdPoliza
                              AND F.IDetPol    = nIDetPol
                              AND F.TipoFondo  = cTipoFondo) LOOP
                IF cNumSolicitud != rDatos.NumSolicitud THEN
                   RAISE_APPLICATION_ERROR(-20200,'No. de Solicitud debe ser la Misma que se Ingreso en este Tipo de Fondo '||cTipoFondo);
                END IF;
            END LOOP;
         END IF;
      END IF;
   END IF;
END VALIDA_SOLICITUD;

PROCEDURE INSERTA_FONDO_ASOCIADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFondo NUMBER, cTipoFondo VARCHAR2) IS
cTipoFondoAsoc     FAI_TIPOS_DE_FONDOS.TipoFondoAsoc%TYPE;
nIdFondoAsoc       FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
nTasaCambio        FAI_FONDOS_DETALLE_POLIZA.TasaCambioMov%TYPE;
nMtoAporteIni      FAI_FONDOS_DETALLE_POLIZA.MtoAporteIniMoneda%TYPE;
nFondos            NUMBER(5);

CURSOR FONDO_Q IS --casi mismo query anterior
  SELECT PorcFondo, CodMoneda, TipoRangoAportes, TipoFondoAsoc,
         NVL(DECODE(NVL(TipoInteresGar,' '),' ',0, GT_FAI_TASAS_DE_INTERES.TASA_INTERES(TipoInteresGar, TipoFondo, TRUNC(SYSDATE))),0) TasaIntGar
    FROM FAI_TIPOS_DE_FONDOS
   WHERE CodCia        = nCodCia
     AND CodEmpresa    = nCodEmpresa
     AND TipoFondo     = cTipoFondoAsoc;

CURSOR FONDO_OBL_Q IS -- igual
   SELECT F.CodCia, F.CodEmpresa, F.IdPoliza, F.IDetPol, F.CodAsegurado, F.TipoFondo, F.FecEmision, F.StsFondo,
          F.FecStatus, F.PorcFondo, F.EnvioEstCta, F.NumSolicitud, F.MtoAporteIniLocal, F.MtoAporteIniMoneda, F.TipoTasa,
          F.TasaCambioMov, F.FecTasaCambio, F.TasaIntGar, F.TipoRangoAportes, F.NumNIP, F.CodEmpleado, F.NumRefer, F.FechaConf,
          F.IndAplicCobOpcional, F.IndAplicaCobDiferido, F.ReglaRetiros, F.IndBonoPolizaEmp, F.PorcBonoEmp, F.FecFinAplicBono,
          F.PlazoObligado, F.PlazoComprometido, F.IndRevaluaAportComp, F.EdadBeneficios, F.EdadJubilacion, F.IndDescPrimaCob,
          F.MesesPreferencial, F.FecFinPreferencial, F.TasaPreferencial, D.MontoAporteFondo
     FROM FAI_FONDOS_DETALLE_POLIZA F, DETALLE_POLIZA D
    WHERE F.CodCia        = nCodCia
      AND F.CodEmpresa    = nCodEmpresa
      AND F.IdFondo       = nIdFondo
      AND D.CodCia        = F.CodCia
      AND D.CodEmpresa    = F.CodEmpresa
      AND D.IdPoliza      = F.IdPoliza
      AND D.IDetPol       = F.IDetPol;
BEGIN
   BEGIN
      SELECT TipoFondoAsoc
        INTO cTipoFondoAsoc
        FROM FAI_TIPOS_DE_FONDOS
       WHERE CodCia     = nCodCia
         AND CodEmpresa = nCodEmpresa
         AND TipoFondo  = cTipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'No Existe Configuración del Fondo ' || cTipoFondo || ' para leer Fondo Asociado');
   END;

   FOR X IN FONDO_Q LOOP
      FOR Y IN FONDO_OBL_Q LOOP
         BEGIN
            SELECT COUNT(*)
              INTO nFondos
              FROM FAI_FONDOS_DETALLE_POLIZA
             WHERE CodCia        = nCodCia
               AND CodEmpresa    = nCodEmpresa
               AND IdPoliza      = Y.IdPoliza
               AND TipoFondo     = cTipoFondoAsoc;
         END;
         -- Verifica que no Exista.
         IF NVL(nFondos,0) = 0 THEN
            IF NVL(Y.MtoAporteIniLocal,0) != 0 THEN
               nMtoAporteIni := NVL(Y.MtoAporteIniLocal,0);
            ELSE
               nMtoAporteIni := NVL(Y.MontoAporteFondo,0) * (X.PorcFondo / 100);
            END IF;
            GT_FAI_FONDOS_DETALLE_POLIZA.INSERTA_NUEVO_FONDO(Y.CodCia, Y.CodEmpresa, Y.IdPoliza, Y.IDetPol,
                                                             Y.CodAsegurado, cTipoFondoAsoc, Y.FecEmision, Y.StsFondo,
                                                             Y.FecStatus, Y.EnvioEstCta, Y.NumSolicitud, nMtoAporteIni,
                                                             Y.TipoTasa, Y.TasaCambioMov, Y.FecTasaCambio, Y.NumNIP,
                                                             Y.CodEmpleado, Y.NumRefer, Y.FechaConf, Y.IndAplicaCobDiferido,
                                                             Y.IndAplicCobOpcional, Y.ReglaRetiros, Y.IndBonoPolizaEmp,
                                                             Y.PorcBonoEmp, Y.FecFinAplicBono, Y.PlazoObligado, Y.PlazoComprometido,
                                                             Y.IndRevaluaAportComp, Y.EdadBeneficios, Y.EdadJubilacion,
                                                             Y.IndDescPrimaCob, Y.MesesPreferencial, Y.FecFinPreferencial,
                                                             Y.TasaPreferencial, nIdFondoAsoc, 'N', NULL, X.PorcFondo);
         END IF;
      END LOOP;
   END LOOP;
END INSERTA_FONDO_ASOCIADO;

PROCEDURE ELIMINA_FONDO(nIdFondo NUMBER) IS
BEGIN
   -- Elimina Fondo Asociado EC - 20/06/2008
   DELETE FAI_FONDOS_DETALLE_POLIZA
    WHERE IdFondo IN
          (SELECT IdFondo
             FROM FAI_FONDOS_DETALLE_POLIZA
            WHERE (IdPoliza, TipoFondo) IN
                  (SELECT F.IdPoliza, T.TipoFondoAsoc
                     FROM FAI_TIPOS_DE_FONDOS T, FAI_FONDOS_DETALLE_POLIZA F
                    WHERE T.CodCia      = F.CodCia
                      AND T.CodEmpresa  = F.CodEmpresa
                      AND T.TipoFondo   = F.TipoFondo
                      AND F.IdFondo     = nIdFondo));

   -- Elimina Fondo Solicitado
   DELETE FAI_FONDOS_DETALLE_POLIZA
    WHERE IdFondo = nIdFondo;
END ELIMINA_FONDO;

PROCEDURE CREA_FONDOS_AUTOMATICOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCodAsegurado NUMBER) IS

cIdTipoSeg         DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob           DETALLE_POLIZA.PlanCob%TYPE;
nTasa_Cambio       TASAS_CAMBIO.Tasa_Cambio%TYPE;
nIdFondo           FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
cTipoFondo         FAI_TIPOS_DE_FONDOS.TipoFondo%TYPE;
nMtoAporteIni      FAI_FONDOS_DETALLE_POLIZA.MtoAporteIniMoneda%TYPE;

CURSOR DET_Q IS
   SELECT D.IdTipoSeg, D.PlanCob, D.Tasa_Cambio,
          D.MontoAporteFondo, 'DETALLE' Nivel
     FROM DETALLE_POLIZA D
    WHERE D.CodCia        = nCodCia
      AND D.CodEmpresa    = nCodEmpresa
      AND D.IdPoliza      = nIdPoliza
      AND D.IDetPol       = nIDetPol
      AND D.Cod_Asegurado = nCodAsegurado
      AND D.StsDetalle  IN ('SOL','XRE')
    UNION ALL
   SELECT D.IdTipoSeg, D.PlanCob, D.Tasa_Cambio,
          A.MontoAporteAseg MontoAporteFondo, 'ASEGURADO' Nivel
     FROM ASEGURADO_CERTIFICADO A, DETALLE_POLIZA D
    WHERE A.CodCia        = nCodCia
      AND A.IdPoliza      = nIdPoliza
      AND A.IDetPol       = nIDetPol
      AND A.Cod_Asegurado = nCodAsegurado
      --AND D.StsDetalle   IN ('SOL','XRE')
      AND (D.StsDetalle   IN ('SOL','XRE') 
       OR  A.Estado   IN ('SOL','XRE'))
      AND D.CodCia        = A.CodCia
      AND D.CodEmpresa    = nCodEmpresa
      AND D.IdPoliza      = A.IdPoliza
      AND D.IDetPol       = A.IDetPol;

CURSOR FONDOS_Q IS
   SELECT TipoFondo, PorcFondo, NVL(IndFondoOblig,'N')
     FROM FAI_TIPOS_FONDOS_PRODUCTOS
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdTipoSeg     = cIdTipoSeg
      AND PlanCob       = cPlanCob
      AND IndFondoOblig = 'S'
    ORDER BY OrdenFondo;

CURSOR TIPOFON_Q IS
   SELECT TipoFondo, MtoAporteIni, CodMoneda, IndCobCobertOpcDif,
          TipoFondoAsoc, EdadMax, EdadRetiro, IndDctoCobFondo,
          NVL(IndFondoColectivos,'N') IndFondoColectivos
     FROM FAI_TIPOS_DE_FONDOS
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND TipoFondo  = cTipoFondo;
BEGIN
   IF GT_FAI_FONDOS_DETALLE_POLIZA.EXISTEN_FONDOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado) = 'N' THEN
      FOR X IN DET_Q LOOP
         cIdTipoSeg  := X.IdTipoSeg;
         cPlanCob    := X.PlanCob;
         FOR W IN FONDOS_Q LOOP
            cTipoFondo := W.TipoFondo;
            FOR T IN TIPOFON_Q LOOP
               nTasa_Cambio := OC_GENERALES.TASA_DE_CAMBIO(T.CodMoneda, TRUNC(SYSDATE));
               IF NVL(T.MtoAporteIni,0) != 0 THEN
                  nMtoAporteIni := NVL(T.MtoAporteIni,0);
               ELSE
                  nMtoAporteIni := NVL(X.MontoAporteFondo,0) * (W.PorcFondo / 100);
               END IF;

               IF (X.Nivel = 'DETALLE' AND T.IndFondoColectivos = 'N') OR
                  (X.Nivel = 'ASEGURADO' AND T.IndFondoColectivos = 'S') THEN -- GTC - 06/02/2019
                  GT_FAI_FONDOS_DETALLE_POLIZA.INSERTA_NUEVO_FONDO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol,
                                                                   nCodAsegurado, T.TipoFondo, TRUNC(SYSDATE), 'SOLICI',
                                                                   TRUNC(SYSDATE), 'A', NULL, NVL(nMtoAporteIni,0),
                                                                   'D', X.Tasa_Cambio, TRUNC(SYSDATE), NULL,
                                                                   NULL, NULL, NULL, T.IndCobCobertOpcDif,
                                                                   'N', NULL, NULL, NULL, NULL, NULL, NULL,
                                                                   NULL, T.EdadMax, T.EdadRetiro,
                                                                   T.IndDctoCobFondo, NULL, NULL, NULL, nIdFondo, 'N', NULL, W.PorcFondo);
                  IF T.TipoFondoAsoc IS NOT NULL THEN
                     GT_FAI_FONDOS_DETALLE_POLIZA.INSERTA_FONDO_ASOCIADO(nCodCia, nCodEmpresa, nIdFondo, T.TipoFondoAsoc);
                  END IF;
               END IF;
            END LOOP;
         END LOOP;
      END LOOP;
   END IF;
END CREA_FONDOS_AUTOMATICOS;

FUNCTION ALTURA_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                      nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER IS
dFecIniVig   POLIZAS.FecIniVig%TYPE;
nIdEndoso    ENDOSOS.IdEndoso%TYPE;
nAltura      NUMBER(5);
nRestoAlt    NUMBER(10,6);
BEGIN
   SELECT NVL(MAX(IdEndoso),0)
     INTO nIdEndoso
     FROM ASEGURADO_CERTIFICADO
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCodAsegurado; -- GTC - 06/02/2019

   IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(nCodCia, nIdPoliza, nIDetPol, nCodAsegurado) = 'N' OR nIdEndoso = 0 THEN -- GTC - 06/02/2019
      BEGIN
         SELECT D.FecIniVig
           INTO dFecIniVig
           FROM DETALLE_POLIZA D, FAI_FONDOS_DETALLE_POLIZA F
          WHERE D.IdPoliza     = F.IdPoliza
            AND D.IDetPol      = F.IDetPol
            AND D.CodEmpresa   = F.CodEmpresa
            AND D.CodCia       = F.CodCia
            AND F.CodCia       = nCodCia
            AND F.CodEmpresa   = nCodEmpresa
            AND F.IdPoliza     = nIdPoliza
            AND F.IDetPol      = nIDetPol
            AND F.CodAsegurado = nCodAsegurado
            AND F.IdFondo      = nIdFondo;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20200,'No existe Póliza de Fondo No. ' || nIdFondo);
      END;
   ELSE -- GTC - 06/02/2019
      BEGIN
         SELECT E.FecIniVig
           INTO dFecIniVig
           FROM ENDOSOS E, FAI_FONDOS_DETALLE_POLIZA F
          WHERE E.IdEndoso     = nIdEndoso
            AND E.IdPoliza     = F.IdPoliza
            AND E.IDetPol      = F.IDetPol
            AND E.CodEmpresa   = nCodEmpresa
            AND E.CodCia       = F.CodCia
            AND F.CodCia       = nCodCia
            AND F.CodEmpresa   = nCodEmpresa
            AND F.IdPoliza     = nIdPoliza
            AND F.IDetPol      = nIDetPol
            AND F.CodAsegurado = nCodAsegurado
            AND F.IdFondo      = nIdFondo;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20200,'No existe Endoso de Fondo No. ' || nIdFondo);
      END;
   END IF;
   nAltura   := FLOOR((MONTHS_BETWEEN(TRUNC(SYSDATE), dFecIniVig) / 12));
   nRestoAlt := (MONTHS_BETWEEN(TRUNC(SYSDATE), dFecIniVig) / 12) - nAltura;
   IF NVL(nRestoAlt,0) <> 0 THEN
      nAltura := NVL(nAltura,0) + 1;
   END IF;
   RETURN(nAltura);
END ALTURA_FONDO;

PROCEDURE FONDO_RESCATADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                          nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) IS
BEGIN
   UPDATE FAI_FONDOS_DETALLE_POLIZA
      SET StsFondo   = 'RESCAT',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCodAsegurado
      AND IdFondo       = nIdFondo;
END FONDO_RESCATADO;

FUNCTION STATUS_FONDO_DETALLE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                              nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN VARCHAR2 IS
cStsFondo      FAI_FONDOS_DETALLE_POLIZA.StsFondo%TYPE;
BEGIN
   BEGIN
      SELECT StsFondo
        INTO cStsFondo
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND CodAsegurado  = nCodAsegurado
         AND IdFondo       = nIdFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cStsFondo  := 'NULL';
      WHEN TOO_MANY_ROWS THEN
         cStsFondo  := 'NULL';
   END;
   RETURN(cStsFondo);
END STATUS_FONDO_DETALLE;

FUNCTION DESCUENTA_PRIMA_COBERTURA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                   nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN VARCHAR2 IS
cIndDescPrimaCob      FAI_FONDOS_DETALLE_POLIZA.IndDescPrimaCob%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndDescPrimaCob,'N')
        INTO cIndDescPrimaCob
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND CodAsegurado  = nCodAsegurado
         AND IdFondo       = nIdFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndDescPrimaCob  := 'N';
      WHEN TOO_MANY_ROWS THEN
         cIndDescPrimaCob  := 'S';
   END;
   RETURN(cIndDescPrimaCob);
END DESCUENTA_PRIMA_COBERTURA;

FUNCTION FONDO_ASOCIADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                        nIDetPol NUMBER, nCodAsegurado NUMBER, cTipoFondo VARCHAR2) RETURN NUMBER IS
nIdFondo            FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
BEGIN
   BEGIN
      SELECT IdFondo
        INTO nIdFondo
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND CodAsegurado  = nCodAsegurado
         AND TipoFondo IN (SELECT TipoFondo
                             FROM FAI_TIPOS_DE_FONDOS
                            WHERE CodCia        = nCodCia
                              AND CodEmpresa    = nCodEmpresa
                              AND TipoFondoAsoc = cTipoFondo);
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'No se encuentra Fondo Inicial del Fondo Comprometido ' || cTipoFondo);
   END;
   RETURN(nIdFondo);
END FONDO_ASOCIADO;

FUNCTION EXISTEN_TASAS_PRECIOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                               nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER,
                               dFechaIni DATE, dFechaFin DATE, cReferencia IN OUT VARCHAR) RETURN VARCHAR2 IS
cTipoInteres    FAI_TIPOS_DE_FONDOS.TipoInteres%TYPE;
dFecha          DATE;
cFaltaTasas     VARCHAR2(1) := 'S';
nRegs           NUMBER(8);
dFecMaxInt      DATE;
BEGIN
   BEGIN
      SELECT T.TipoInteres
        INTO cTipoInteres
        FROM FAI_TIPOS_DE_FONDOS T, FAI_FONDOS_DETALLE_POLIZA F
       WHERE F.CodCia        = nCodCia
         AND F.CodEmpresa    = nCodEmpresa
         AND F.IdPoliza      = nIdPoliza
         AND F.IDetPol       = nIDetPol
         AND F.CodAsegurado  = nCodAsegurado
         AND F.IdFondo       = nIdFondo
         AND T.CodCia        = F.CodCia
         AND T.CodEmpresa    = F.CodEmpresa
         AND T.TipoFondo     = F.TipoFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20200,'No Existe el Fondo No. ' || nIdFondo);
   END;

   --  Debe Valuar que estén las Tasas a la Ultima Fecha Calculada
   BEGIN
      SELECT NVL(TRUNC(MAX(FecMovimiento)-1),TRUNC(SYSDATE))
        INTO dFecMaxInt
        FROM FAI_CONCENTRADORA_FONDO
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      > 0
         AND IDetPol       > 0
         AND CodAsegurado  > 0
         AND IdFondo       > 0
         AND CodCptoMov   IN (SELECT DISTINCT CodCptoMov
                                FROM FAI_CONF_MOVIMIENTOS_FONDO
                               WHERE CodCia      = nCodCia
                                 AND CodEmpresa  = nCodEmpresa
                                 AND CodCptoMov IS NOT NULL
                                 AND TipoMov     = 'IN');
   END;

   dFecha := TRUNC(dFechaIni);
   IF dFecha <= dFecMaxInt THEN
      LOOP
         cReferencia := '';

         SELECT COUNT(*)
           INTO nRegs
           FROM FAI_TASAS_DE_INTERES
          WHERE TipoInteres = cTipoInteres
            AND (FecIniVig, FecFinVig) IN (SELECT MAX(FecIniVig), MAX(FecFinVig)
                                             FROM FAI_TASAS_DE_INTERES
                                            WHERE TipoInteres  = cTipoInteres
                                              AND FecIniVig   <= TRUNC(dFecha)
                                              AND FecFinVig   >= TRUNC(dFecha) );
         IF nRegs = 0 THEN
            SELECT COUNT(*)
              INTO nRegs
              FROM FAI_PRECIOS_DIARIOS
             WHERE TipoPrecio = cTipoInteres
               AND FecPrecio  = TRUNC(dFecha);
         END IF;

         IF nRegs = 0 THEN
            cFaltaTasas := 'N';
            IF LENGTH( cReferencia ) = 0 THEN
               cReferencia := cTipoInteres;
            ELSE
               cReferencia := cReferencia || ' - (' || cTipoInteres || '-' || TO_CHAR( dFecha, 'DD/MM/RRRR' ) || ')';
            END IF;
         END IF;

         dFecha := dFecha + 1;
         IF dFecha > dFecMaxInt THEN
            EXIT;
         END IF;
      END LOOP;
   END IF;
   RETURN(cFaltaTasas);
END EXISTEN_TASAS_PRECIOS;

PROCEDURE COPIAR_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPolizaOrig NUMBER,
                        nIDetPol NUMBER, nCodAsegurado NUMBER, nIdPolizaDest NUMBER) IS

nTasaCambioMov   FAI_FONDOS_DETALLE_POLIZA.TasaCambioMov%TYPE;
cCodMoneda       FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
nIdFondo         FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;

CURSOR FONDOS_Q IS
   SELECT TipoFondo, PorcFondo, EnvioEstCta, NumSolicitud, MtoAporteIniLocal,
          MtoAporteIniMoneda, TipoTasa, TasaIntGar, TipoRangoAportes,
          NumNIP, CodEmpleado, NumRefer, FechaConf, IndAplicCobOpcional,
          IndAplicaCobDiferido, ReglaRetiros, IndBonoPolizaEmp, PorcBonoEmp,
          FecFinAplicBono, PlazoObligado, PlazoComprometido, IndRevaluaAportComp,
          EdadBeneficios, EdadJubilacion, IndDescPrimaCob, MesesPreferencial,
          FecFinPreferencial, TasaPreferencial, IndFondoContrat
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPolizaOrig
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCodAsegurado
      AND IdFondo       > 0;
BEGIN
   FOR W IN FONDOS_Q LOOP
      cCodMoneda      := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, W.TipoFondo);
      nTasaCambioMov  := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));

      GT_FAI_FONDOS_DETALLE_POLIZA.INSERTA_NUEVO_FONDO(nCodCia, nCodEmpresa, nIdPolizaDest, nIDetPol, nCodAsegurado,
                                                       W.TipoFondo, TRUNC(SYSDATE), 'SOLICI', TRUNC(SYSDATE), W.EnvioEstCta,
                                                       NULL, W.MtoAporteIniLocal, W.TipoTasa, nTasaCambioMov,
                                                       TRUNC(SYSDATE), W.NumNIP, W.CodEmpleado, NULL, NULL, W.IndAplicaCobDiferido,
                                                       W.IndAplicCobOpcional, W.ReglaRetiros, W.IndBonoPolizaEmp, W.PorcBonoEmp,
                                                       W.FecFinAplicBono, W.PlazoObligado, W.PlazoComprometido, W.IndRevaluaAportComp,
                                                       W.EdadBeneficios, W.EdadJubilacion, W.IndDescPrimaCob, W.MesesPreferencial,
                                                       W.FecFinPreferencial, W.TasaPreferencial, nIdFondo, 'N', NULL, W.PorcFondo);
      UPDATE FAI_FONDOS_DETALLE_POLIZA
         SET IndFondoContrat  = W.IndFondoContrat
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPolizaDest
         AND IDetPol       = nIDetPol
         AND CodAsegurado  = nCodAsegurado
         AND IdFondo       = nIdFondo;
   END LOOP;
END COPIAR_FONDOS;

PROCEDURE ACTUALIZA_APORTE_INICIAL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                   nIDetPol NUMBER, nCodAsegurado NUMBER) IS

nMontoAporteFondo      DETALLE_POLIZA.MontoAporteFondo%TYPE;
nTasa_Cambio           DETALLE_POLIZA.Tasa_Cambio%TYPE;
nMtoAporteIniMoneda    FAI_FONDOS_DETALLE_POLIZA.MtoAporteIniMoneda%TYPE;
nMtoAporteIniLocal     FAI_FONDOS_DETALLE_POLIZA.MtoAporteIniLocal%TYPE;

CURSOR FONDOS_Q IS
   SELECT IdFondo, PorcFondo, TipoFondo
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCodAsegurado
      AND IdFondo       > 0;
BEGIN
   SELECT NVL(MontoAporteFondo,0), Tasa_Cambio
     INTO nMontoAporteFondo, nTasa_Cambio
     FROM DETALLE_POLIZA
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol;

   IF NVL(nMontoAporteFondo,0) = 0 THEN
      SELECT NVL(MontoAporteAseg,0)
        INTO nMontoAporteFondo
        FROM ASEGURADO_CERTIFICADO
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND Cod_Asegurado = nCodAsegurado;
   END IF;

   FOR W IN FONDOS_Q LOOP
      -- Solo Actualiza Aportes a Fondos que NO son Exclusivos para Pago de Prima
      IF GT_FAI_TIPOS_DE_FONDOS.INDICADORES(nCodCia, nCodEmpresa, W.TipoFondo, 'EPP') = 'N' THEN
         nMtoAporteIniMoneda := NVL(nMontoAporteFondo,0) * (W.PorcFondo / 100);
         nMtoAporteIniLocal  := NVL(nMtoAporteIniMoneda,0) * nTasa_Cambio;
      ELSE
         nMtoAporteIniMoneda := 0;
         nMtoAporteIniLocal  := 0;
      END IF;

      UPDATE FAI_FONDOS_DETALLE_POLIZA
         SET MtoAporteIniMoneda = NVL(nMtoAporteIniMoneda,0),
             MtoAporteIniLocal  = NVL(nMtoAporteIniLocal,0)
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND CodAsegurado  = nCodAsegurado
         AND IdFondo       = W.IdFondo;
   END LOOP;
END ACTUALIZA_APORTE_INICIAL;

FUNCTION PORCENTAJE_FONDO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                          nIDetPol NUMBER, nCodAsegurado NUMBER, nIdFondo NUMBER) RETURN NUMBER IS
nPorcFondo     FAI_FONDOS_DETALLE_POLIZA.PorcFondo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcFondo,0)
        INTO nPorcFondo
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND CodAsegurado  = nCodAsegurado
         AND IdFondo       = nIdFondo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcFondo  := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Existen Varios Fondo No. ' || nIdFondo);
   END;
   RETURN(nPorcFondo);
END PORCENTAJE_FONDO;

FUNCTION FONDO_PAGO_PRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                          nIDetPol NUMBER, nCodAsegurado NUMBER) RETURN NUMBER IS
nIdFondo     FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MIN(IdFondo),0)
        INTO nIdFondo
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND CodAsegurado  = nCodAsegurado
         AND GT_FAI_TIPOS_DE_FONDOS.INDICADORES(nCodCia, nCodEmpresa, TipoFondo, 'EPP') = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nIdFondo  := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Existen Varios Fondo para Pago de Prima en Póliza No. ' || nIdPoliza ||
                                 ' y Certificado/Subgrupo No. ' || nIDetPol);
   END;
   RETURN(nIdFondo);
END FONDO_PAGO_PRIMA;

FUNCTION NUMERO_SOLICITUD(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                          nIDetPol NUMBER, nCodAsegurado NUMBER) RETURN VARCHAR2 IS
nNumSolicitud     FAI_FONDOS_DETALLE_POLIZA.NumSolicitud%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MAX(TO_NUMBER(NumSolicitud)),0)
        INTO nNumSolicitud
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND CodAsegurado  = nCodAsegurado;
   EXCEPTION
      WHEN OTHERS THEN
         nNumSolicitud := 0;
   END;

   IF NVL(nNumSolicitud,0) = 0 THEN
      BEGIN
         SELECT NVL(MAX(TO_NUMBER(NumSolicitud)),0)+1
           INTO nNumSolicitud
           FROM FAI_FONDOS_DETALLE_POLIZA
          WHERE CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa
            AND IdPoliza      > 0
            AND IDetPol       > 0
            AND CodAsegurado  > 0;
      EXCEPTION
         WHEN OTHERS THEN
            nNumSolicitud := 0;
      END;
   END IF;
   RETURN(TRIM(TO_CHAR(nNumSolicitud)));
END NUMERO_SOLICITUD;

PROCEDURE RENOVAR(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPolizaOrig NUMBER,
                  nIDetPolOrig NUMBER, nCodAseguradoOrig NUMBER, nIdPolizaRen NUMBER) IS
cCodMoneda              FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
nTasaCambioMov          TASAS_CAMBIO.Tasa_Cambio%TYPE;
cStsPoliza              POLIZAS.StsPoliza%TYPE;
cCodPlanPago            POLIZAS.CodPlanPago%TYPE;
nSaldoFondo             FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
cCodCptoMov             FAI_MOVIMIENTOS_FONDOS.CodCptoMov%TYPE;
nIdFondoOrig            FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
nIdFondoDest            FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;

CURSOR FONDOS_Q IS
   SELECT IdFondo, TipoFondo, PorcFondo, EnvioEstCta, NumSolicitud, MtoAporteIniLocal,
          MtoAporteIniMoneda, TipoTasa, TasaIntGar, TipoRangoAportes,
          NumNIP, CodEmpleado, NumRefer, FechaConf, IndAplicCobOpcional,
          IndAplicaCobDiferido, ReglaRetiros, IndBonoPolizaEmp, PorcBonoEmp,
          FecFinAplicBono, PlazoObligado, PlazoComprometido, IndRevaluaAportComp,
          EdadBeneficios, EdadJubilacion, IndDescPrimaCob, MesesPreferencial,
          FecFinPreferencial, TasaPreferencial, IndFondoContrat
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPolizaOrig
      AND IDetPol       = nIDetPolOrig
      AND CodAsegurado  = nCodAseguradoOrig
      AND StsFondo      = 'EMITID'
      AND IdFondo       > 0;

BEGIN
   BEGIN
      SELECT StsPoliza, CodPlanPago
        INTO cStsPoliza, cCodPlanPago
        FROM POLIZAS
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND IdPoliza     = nIdPolizaRen;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR( -20200, 'NO Existe Póliza No. ' || nIdPolizaOrig);
   END;
   IF cStsPoliza IN ('XRE','SOL') THEN
      FOR W IN FONDOS_Q LOOP
         nIdFondoOrig    := W.IdFondo;
         nSaldoFondo     := GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPolizaOrig, nIDetPolOrig,
                                                                           nCodAseguradoOrig, W.IdFondo, TRUNC(SYSDATE));

         cCodMoneda       := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, W.TipoFondo);
         nTasaCambioMov   := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));

         IF NVL(nSaldoFondo,0) > 0 THEN
            cCodCptoMov      := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, W.TipoFondo, 'TR');
            nIdFondoDest     := 0;
            GT_FAI_CONCENTRADORA_FONDO.TRASPASO_FONDOS(nCodCia, nCodEmpresa, nIdPolizaOrig, nIDetPolOrig, nCodAseguradoOrig,
                                                       W.TipoFondo, nIdFondoOrig, cCodCptoMov, nIdPolizaRen, nIDetPolOrig,
                                                       nCodAseguradoOrig, nIdFondoDest, W.TipoFondo, cCodCptoMov, 'NFO',
                                                       TRUNC(SYSDATE), nSaldoFondo * -1, 'D', TRUNC(SYSDATE), nTasaCambioMov, 'RENOVACION');
         ELSE
            GT_FAI_FONDOS_DETALLE_POLIZA.INSERTA_NUEVO_FONDO(nCodCia, nCodEmpresa, nIdPolizaRen, nIDetPolOrig, nCodAseguradoOrig,
                                                             W.TipoFondo, TRUNC(SYSDATE), 'XRENOV', TRUNC(SYSDATE), W.EnvioEstCta,
                                                             NULL, W.MtoAporteIniLocal, W.TipoTasa, nTasaCambioMov,
                                                             TRUNC(SYSDATE), W.NumNIP, W.CodEmpleado, NULL, NULL, W.IndAplicaCobDiferido,
                                                             W.IndAplicCobOpcional, W.ReglaRetiros, W.IndBonoPolizaEmp, W.PorcBonoEmp,
                                                             W.FecFinAplicBono, W.PlazoObligado, W.PlazoComprometido, W.IndRevaluaAportComp,
                                                             W.EdadBeneficios, W.EdadJubilacion, W.IndDescPrimaCob, W.MesesPreferencial,
                                                             W.FecFinPreferencial, W.TasaPreferencial, nIdFondoDest, 'N', NULL, W.PorcFondo);

            UPDATE FAI_FONDOS_DETALLE_POLIZA
               SET IndFondoContrat  = W.IndFondoContrat
             WHERE CodCia        = nCodCia
               AND CodEmpresa    = nCodEmpresa
               AND IdPoliza      = nIdPolizaRen
               AND IDetPol       = nIDetPolOrig
               AND CodAsegurado  = nCodAseguradoOrig
               AND IdFondo       = nIdFondoDest;
         END IF;

         GT_FAI_BENEFICIARIOS_FONDO.RENOVAR(nCodCia, nCodEmpresa, nIdPolizaOrig, nIDetPolOrig, nCodAseguradoOrig, nIdFondoOrig, nIdPolizaRen, nIdFondoDest);

         UPDATE FAI_FONDOS_DETALLE_POLIZA
            SET StsFondo     = 'RENOVA',
                FecStatus    = TRUNC(SYSDATE)
          WHERE CodCia       = nCodCia
            AND CodEmpresa   = nCodEmpresa
            AND IdPoliza     = nIdPolizaOrig
            AND IDetPol      = nIDetPolOrig
            AND CodAsegurado = nCodAseguradoOrig
            AND IdFondo      = nIdFondoOrig;
      END LOOP;
   END IF;
END RENOVAR;

PROCEDURE TRASLADA_FONDOS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPolizaOrig NUMBER,
                          nIDetPolOrig NUMBER, nCodAseguradoOrig NUMBER, nIDetPolDest NUMBER) IS
BEGIN
   UPDATE FAI_FONDOS_DETALLE_POLIZA
      SET IDetPol      = nIDetPolDest -- Certificado / SubGrupo Destino
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdPoliza     = nIdPolizaOrig
      AND IDetPol      = nIDetPolOrig
      AND CodAsegurado = nCodAseguradoOrig;
END TRASLADA_FONDOS;

PROCEDURE COPIAR_FONDOS_CERTIFICADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPolizaOrig NUMBER,
                                   nIDetPolOrig NUMBER, nCodAsegurado NUMBER, nIdPolizaDest NUMBER,
                                   nIDetPolDest NUMBER) IS
nTasaCambioMov   FAI_FONDOS_DETALLE_POLIZA.TasaCambioMov%TYPE;
cCodMoneda       FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
nIdFondo         FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;

CURSOR FONDOS_Q IS
   SELECT TipoFondo, PorcFondo, EnvioEstCta, NumSolicitud, MtoAporteIniLocal,
          MtoAporteIniMoneda, TipoTasa, TasaIntGar, TipoRangoAportes,
          NumNIP, CodEmpleado, NumRefer, FechaConf, IndAplicCobOpcional,
          IndAplicaCobDiferido, ReglaRetiros, IndBonoPolizaEmp, PorcBonoEmp,
          FecFinAplicBono, PlazoObligado, PlazoComprometido, IndRevaluaAportComp,
          EdadBeneficios, EdadJubilacion, IndDescPrimaCob, MesesPreferencial,
          FecFinPreferencial, TasaPreferencial, IndFondoContrat
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPolizaOrig
      AND IDetPol       = nIDetPolOrig
      AND CodAsegurado  = nCodAsegurado
      AND IdFondo       > 0;
BEGIN
   FOR W IN FONDOS_Q LOOP
      cCodMoneda      := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, W.TipoFondo);
      nTasaCambioMov  := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));

      GT_FAI_FONDOS_DETALLE_POLIZA.INSERTA_NUEVO_FONDO(nCodCia, nCodEmpresa, nIdPolizaDest, nIDetPolDest, nCodAsegurado,
                                                       W.TipoFondo, TRUNC(SYSDATE), 'SOLICI', TRUNC(SYSDATE), W.EnvioEstCta,
                                                       NULL, W.MtoAporteIniLocal, W.TipoTasa, nTasaCambioMov,
                                                       TRUNC(SYSDATE), W.NumNIP, W.CodEmpleado, NULL, NULL, W.IndAplicaCobDiferido,
                                                       W.IndAplicCobOpcional, W.ReglaRetiros, W.IndBonoPolizaEmp, W.PorcBonoEmp,
                                                       W.FecFinAplicBono, W.PlazoObligado, W.PlazoComprometido, W.IndRevaluaAportComp,
                                                       W.EdadBeneficios, W.EdadJubilacion, W.IndDescPrimaCob, W.MesesPreferencial,
                                                       W.FecFinPreferencial, W.TasaPreferencial, nIdFondo, 'N', NULL, W.PorcFondo);

      UPDATE FAI_FONDOS_DETALLE_POLIZA
         SET IndFondoContrat  = W.IndFondoContrat
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPolizaDest
         AND IDetPol       = nIDetPolDest
         AND CodAsegurado  = nCodAsegurado
         AND IdFondo       = nIdFondo;
   END LOOP;
END COPIAR_FONDOS_CERTIFICADO;

FUNCTION FONDO_CONTRATANTE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN NUMBER IS
nIdFondo          FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
BEGIN
   BEGIN
      SELECT IdFondo
        INTO nIdFondo
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND IdPoliza        = nIdPoliza
         AND StsFondo       != 'ANULAD'
         AND IndFondoContrat = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR( -20200, 'NO Existe Fondo del Contrante para Aportes Colectivos en Póliza No. ' || nIdPoliza);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR( -20200, 'Existen Varios Fondos del Contrante para Aportes Colectivos en Póliza No. ' || nIdPoliza);
   END;
   RETURN(nIdFondo);
END FONDO_CONTRATANTE;

PROCEDURE APORTACION_COLECTIVA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                               nIDetPol NUMBER, nCodAsegurado NUMBER, nMontoAporte NUMBER) IS
nIdFondoContrat          FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
nAporteDistrib           FAI_FONDOS_DETALLE_POLIZA.MtoAporteIniMoneda%TYPE;
nAporteFondoAseg         FAI_FONDOS_DETALLE_POLIZA.MtoAporteIniMoneda%TYPE;
nIDetPolOrig             FAI_FONDOS_DETALLE_POLIZA.IDetPol%TYPE;
nCodAseguradoOrig        FAI_FONDOS_DETALLE_POLIZA.CodAsegurado%TYPE;
cTipoFondoOrig           FAI_FONDOS_DETALLE_POLIZA.TipoFondo%TYPE;
nIdFondoDest             FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
cCodCptoMovOrig          FAI_MOVIMIENTOS_FONDOS.CodCptoMov%TYPE;
cCodCptoMovDest          FAI_MOVIMIENTOS_FONDOS.CodCptoMov%TYPE;
nSaldoFondo              FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
cCodMoneda               FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
nTasaCambioMov           TASAS_CAMBIO.Tasa_Cambio%TYPE;

CURSOR FOND_Q IS
   SELECT IdFondo, PorcFondo, TipoFondo
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE CodCia          = nCodCia
      AND CodEmpresa      = nCodEmpresa
      AND IdPoliza        = nIdPoliza
      AND IDetPol         = nIDetPol
      AND CodAsegurado    = nCodAsegurado
      AND StsFondo        = 'EMITID';
BEGIN
   nIdFondoContrat := GT_FAI_FONDOS_DETALLE_POLIZA.FONDO_CONTRATANTE(nCodCia, nCodEmpresa, nIdPoliza);
   BEGIN
      SELECT IDetPol, CodAsegurado, TipoFondo
        INTO nIDetPolOrig, nCodAseguradoOrig, cTipoFondoOrig
        FROM FAI_FONDOS_DETALLE_POLIZA
       WHERE CodCia          = nCodCia
         AND CodEmpresa      = nCodEmpresa
         AND IdPoliza        = nIdPoliza
         AND IdFondo         = nIdFondoContrat;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR( -20200, 'NO Existe Fondo de Contratante en Póliza No. ' || nIdPoliza);
   END;

   nSaldoFondo     := GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPolOrig,
                                                                     nCodAseguradoOrig, nIdFondoContrat, TRUNC(SYSDATE));

   cCodMoneda       := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, cTipoFondoOrig);
   nTasaCambioMov   := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));

   IF NVL(nSaldoFondo,0) >= NVL(nMontoAporte,0) THEN
      cCodCptoMovOrig  := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, cTipoFondoOrig, 'TR');
      nAporteDistrib   := nMontoAporte;
      FOR W IN FOND_Q LOOP
         nAporteFondoAseg := NVL(nAporteDistrib,0) * (W.PorcFondo / 100);
         nIdFondoDest     := W.IdFondo;
         IF NVL(nAporteFondoAseg,0) > 0 THEN
            cCodCptoMovDest  := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(nCodCia, nCodEmpresa, W.TipoFondo, 'TR');
            GT_FAI_CONCENTRADORA_FONDO.TRASPASO_FONDOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPolOrig, nCodAseguradoOrig,
                                                       cTipoFondoOrig, nIdFondoContrat, cCodCptoMovOrig, nIdPoliza, nIDetPol,
                                                       nCodAsegurado,  nIdFondoDest, W.TipoFondo, cCodCptoMovDest,
                                                       'FMP', TRUNC(SYSDATE), NVL(nAporteFondoAseg,0), 'D', TRUNC(SYSDATE),
                                                       nTasaCambioMov, 'APORTECONTRAT');
         END IF;
         nAporteDistrib  := NVL(nAporteDistrib,0) - NVL(nAporteFondoAseg,0);
         IF NVL(nAporteDistrib,0) <= 0 THEN
            EXIT;
         END IF;
      END LOOP;
   ELSE
      RAISE_APPLICATION_ERROR(-20200,'Fondo No. ' || nIdFondoContrat || ' del Contratante NO Posee Saldo para Aporte Asegurado ' ||
                              nCodAsegurado || ' por un Monto de ' || NVL(nMontoAporte,0));
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR( -20200, 'Error en Aporación Colectiva en Póliza No. ' || nIdPoliza ||
                              ' para Asegurado No. ' || nCodAsegurado);
END APORTACION_COLECTIVA;

PROCEDURE COPIAR_FONDOS_REN(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPolizaOrig NUMBER,
                        nIDetPol NUMBER, nCodAsegurado NUMBER, nIdPolizaDest NUMBER) IS

nTasaCambioMov   FAI_FONDOS_DETALLE_POLIZA.TasaCambioMov%TYPE;
cCodMoneda       FAI_TIPOS_DE_FONDOS.CodMoneda%TYPE;
nIdFondo         FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;

CURSOR FONDOS_Q IS
   SELECT TipoFondo, PorcFondo, EnvioEstCta, NumSolicitud, MtoAporteIniLocal,
          MtoAporteIniMoneda, TipoTasa, TasaIntGar, TipoRangoAportes,
          NumNIP, CodEmpleado, NumRefer, FechaConf, IndAplicCobOpcional,
          IndAplicaCobDiferido, ReglaRetiros, IndBonoPolizaEmp, PorcBonoEmp,
          FecFinAplicBono, PlazoObligado, PlazoComprometido, IndRevaluaAportComp,
          EdadBeneficios, EdadJubilacion, IndDescPrimaCob, MesesPreferencial,
          FecFinPreferencial, TasaPreferencial, IndFondoContrat
     FROM FAI_FONDOS_DETALLE_POLIZA
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND IdPoliza      = nIdPolizaOrig
      AND IDetPol       = nIDetPol
      AND CodAsegurado  = nCodAsegurado
      AND IdFondo       > 0
      AND  STSFONDO= 'EMITID';
BEGIN
   FOR W IN FONDOS_Q LOOP
      cCodMoneda      := GT_FAI_TIPOS_DE_FONDOS.MONEDA_FONDO(nCodCia, nCodEmpresa, W.TipoFondo);
      nTasaCambioMov  := OC_GENERALES.TASA_DE_CAMBIO(cCodMoneda, TRUNC(SYSDATE));

      GT_FAI_FONDOS_DETALLE_POLIZA.INSERTA_NUEVO_FONDO(nCodCia, nCodEmpresa, nIdPolizaDest, nIDetPol, nCodAsegurado,
                                                       W.TipoFondo, TRUNC(SYSDATE), 'SOLICI', TRUNC(SYSDATE), W.EnvioEstCta,
                                                       NULL, W.MtoAporteIniLocal, W.TipoTasa, nTasaCambioMov,
                                                       TRUNC(SYSDATE), W.NumNIP, W.CodEmpleado, NULL, NULL, W.IndAplicaCobDiferido,
                                                       W.IndAplicCobOpcional, W.ReglaRetiros, W.IndBonoPolizaEmp, W.PorcBonoEmp,
                                                       W.FecFinAplicBono, W.PlazoObligado, W.PlazoComprometido, W.IndRevaluaAportComp,
                                                       W.EdadBeneficios, W.EdadJubilacion, W.IndDescPrimaCob, W.MesesPreferencial,
                                                       W.FecFinPreferencial, W.TasaPreferencial, nIdFondo, 'N', NULL, W.PorcFondo);
      UPDATE FAI_FONDOS_DETALLE_POLIZA
         SET IndFondoContrat  = W.IndFondoContrat
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND IdPoliza      = nIdPolizaDest
         AND IDetPol       = nIDetPol
         AND CodAsegurado  = nCodAsegurado
         AND IdFondo       = nIdFondo;
   END LOOP;
END COPIAR_FONDOS_REN;

END GT_FAI_FONDOS_DETALLE_POLIZA;
/

CREATE OR REPLACE PACKAGE          OC_ASISTENCIAS_SINIESTROS IS
PROCEDURE CREA_ASEG_ESTIM_SINI(nIdAsistencia VARCHAR2, nIdPoliza NUMBER, nCodCliente NUMBER, nIDetPol NUMBER, nNumAtencion NUMBER,
                               cMsjError OUT VARCHAR2);
PROCEDURE EMITIR_POLIZA_ESTIM_SINI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                   nIDetPol NUMBER, nCodAsegurado NUMBER, cMsjError OUT VARCHAR2);
PROCEDURE ESTIMACION_SINIESTROS(nIdAsistencia VARCHAR2, nIdPoliza NUMBER, nCodCliente NUMBER, nIDetPol NUMBER,
                                nNumAtencion NUMBER, nIdSiniestro IN OUT NUMBER, cMsjError OUT VARCHAR2);
END OC_ASISTENCIAS_SINIESTROS;
/

CREATE OR REPLACE PACKAGE BODY          OC_ASISTENCIAS_SINIESTROS IS
--
--
--
PROCEDURE CREA_ASEG_ESTIM_SINI(nIdAsistencia VARCHAR2, nIdPoliza NUMBER, nCodCliente NUMBER,
                               nIDetPol NUMBER, nNumAtencion NUMBER, cMsjError OUT VARCHAR2) IS
cStsPoliza         POLIZAS.StsPoliza%TYPE;
dFecIniVig         POLIZAS.FecIniVig%TYPE;
dFecFinVig         POLIZAS.FecFinVig%TYPE;
cCodPlanPago       POLIZAS.CodPlanPago%TYPE;
cStsDetalle        DETALLE_POLIZA.StsDetalle%TYPE;
cIndSinAseg        DETALLE_POLIZA.IndSinAseg%TYPE;
nTasaCambio        DETALLE_POLIZA.Tasa_Cambio%TYPE;
cIdTipoSeg         DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob           DETALLE_POLIZA.PlanCob%TYPE;
nIdEndoso          ENDOSOS.IdEndoso%TYPE;
nCodAsegurado      ASEGURADO.Cod_Asegurado%TYPE;
cNumDocIdentif     PERSONA_NATURAL_JURIDICA.Num_Doc_Identificacion%TYPE;
cTipoPersona       PERSONA_NATURAL_JURIDICA.Tipo_Persona%TYPE := 'FISICA';
cTipoDocIdentif    PERSONA_NATURAL_JURIDICA.Tipo_Doc_Identificacion%TYPE := 'RFC';
nIdSolicitud       SOLICITUD_EMISION.IdSolicitud%TYPE;
cCodPlantilla      CONFIG_PLANTILLAS.CodPlantilla%TYPE := 'EMITESINIESTRO';
cTipoSeparador     VARCHAR2(1);

CURSOR ASIS_Q IS
  SELECT CodCia, CodEmpresa, IdAsistencia, IdPoliza, CodCliente, IDetPol, NumAtencion, NombreAseg,
         ApellidoPaternoAseg, ApellidoMaternoAseg, FecNacimientoAseg, SexoAsegurado, TelefonoAseg, DomicilioAseg,
         'Endoso creado por la Asistenciadora, Ususario: '||CodUsuario||' NIP del Capturista '||NIPCaptura DescEndoso,
         TipoDocIdentEsc, NumDocIdentEsc, NombreEscuela, DomicilioEscuela, EntidadEscuela, DelegacionEscuela
    FROM ASISTENCIAS_SINIESTROS
   WHERE IdAsistencia   = nIdAsistencia
     AND IdPoliza       = nIdPoliza
     AND CodCliente     = nCodCliente
     AND IDetPol        = nIDetPol
     AND NumAtencion    = nNumAtencion;
BEGIN
  FOR X IN ASIS_Q LOOP
    --
    cMsjError := NULL;
    --
    BEGIN
      SELECT P.FecIniVig, P.FecFinVig, P.CodPlanPago, P.StsPoliza, DP.StsDetalle,
             DP.IndSinAseg, DP.Tasa_Cambio, DP.IdTipoSeg, DP.PlanCob
        INTO dFecIniVig, dFecFinVig, cCodPlanPago, cStsPoliza, cStsDetalle,
             cIndSinAseg, nTasaCambio, cIdTipoSeg, cPlanCob
        FROM POLIZAS P, DETALLE_POLIZA DP
       WHERE P.IdPoliza    = X.IdPoliza
         AND P.CodCia      = X.CodCia
         AND P.CodEmpresa  = X.CodEmpresa
         AND P.StsPoliza   IN ('SOL','EMI')
         AND P.CodCliente  = X.CodCliente
         AND P.IdPoliza    = DP.IdPoliza
         AND DP.IDetPol    = X.IDetPol;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        dFecIniVig := NULL;
    END;

    IF OC_POLIZAS.EXISTE_POLIZA(X.CodCia, X.CodEmpresa, nIdPoliza) = 'S' THEN
       -- Calcula el RFC.
       cNumDocIdentif := OC_PERSONA_NATURAL_JURIDICA.NUMERO_TRIBUTARIO_RFC(X.NombreAseg, X.ApellidoPaternoAseg, X.ApellidoMaternoAseg, X.FecNacimientoAseg, cTipoPersona);
       -- Si Existe Persona
       IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(cTipoDocIdentif, cNumDocIdentif) = 'N' THEN 
          OC_PERSONA_NATURAL_JURIDICA.INSERTAR_PERSONA(cTipoDocIdentif, cNumDocIdentif, X.NombreAseg, X.ApellidoPaternoAseg,
                                                       X.ApellidoMaternoAseg, NULL, X.SexoAsegurado, 'N', X.FecNacimientoAseg,
                                                       X.DomicilioAseg, NULL, NULL, '001', X.EntidadEscuela, X.EntidadEscuela,
                                                       X.DelegacionEscuela, NULL, NULL, X.TelefonoAseg, NULL, NULL);
          BEGIN
            UPDATE PERSONA_NATURAL_JURIDICA
               SET TIPO_PERSONA = 'FISICA'
             WHERE Tipo_Doc_Identificacion = cTipoDocIdentif
               AND Num_Doc_Identificacion  = cNumDocIdentif;
          EXCEPTION
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR(-20225,'Error al Actualizar Persona Natural Jurídica al Crear el Asegurado');
          END;
       END IF;
       -- Valida si la Edad corrsponde con el Plan Contratado
       IF OC_PERSONA_NATURAL_JURIDICA.FUNC_VALIDA_EDAD(cTipoDocIdentif, cNumDocIdentif, X.CodCia, X.CodEmpresa ,cIdTipoSeg ,cPlanCob)= 'N' THEN
          RAISE_APPLICATION_ERROR(-20225,'Edad del Asegurado Fuera del Rango de Aceptación de Coberturas');
       END IF;
       -- Obtiene el Número de Asegurado
       nCodAsegurado := OC_ASEGURADO.CODIGO_ASEGURADO(X.CodCia, X.CodEmpresa, cTipoDocIdentif, cNumDocIdentif);
       -- Inserta el Asegurado.
       IF nCodAsegurado = 0 THEN
          nCodAsegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(X.CodCia, X.CodEmpresa,cTipoDocIdentif, cNumDocIdentif);
       END IF;
       -- Inserta el Asegurado ligado al Contratante
       BEGIN
         INSERT INTO CLIENTE_ASEG
               (CodCliente, Cod_Asegurado)
         VALUES(nCodCliente, nCodAsegurado);
       EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
           cMsjError := 'Asegurado: ' || nCodAsegurado || ' Duplicado en Cliente_Aseg.';
       END;
       -- Valida el Status Poliza para Crear Endoso
       IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(X.CodCia, nIdpoliza, nIDetPol, nCodAsegurado) = 'N' THEN
          IF cStsPoliza = 'SOL' OR cStsDetalle = 'SOL' THEN
             OC_ASEGURADO_CERTIFICADO.INSERTA(X.CodCia, nIdpoliza, nIDetPol, nCodAsegurado, 0);
          ELSE
             SELECT NVL(MAX(IdEndoso),0)
               INTO nIdEndoso
               FROM ENDOSOS
              WHERE CodCia     = X.CodCia
                AND IdPoliza   = nIdPoliza
                AND StsEndoso  = 'SOL';
             --
             IF NVL(nIdEndoso,0) = 0 THEN
                nIdEndoso := OC_ENDOSO.CREAR(nIdPoliza);
                OC_ENDOSO.INSERTA (X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol, nIdEndoso,
                                   'ESV', 'ENDO-' || TRIM(TO_CHAR(nIdPoliza)) || '-' || TRIM(TO_CHAR(nIdEndoso)),
                                   dFecIniVig, dFecFinVig, cCodPlanPago, 0, 0, 0, '010', NULL);
                BEGIN
                  UPDATE ENDOSOS
                     SET DESCENDOSO = X.DescEndoso
                   WHERE CodCia    = X.CodCia
                     AND IdPoliza  = nIdPoliza
                     AND IDetPol   = nIDetPol
                     AND IdEndoso  = nIdEndoso;
                EXCEPTION
                  WHEN OTHERS THEN
                    cMsjError := 'Error al Actualizar el Endoso: ' || nIdEndoso || ' Error: ' || SQLERRM;
                END;
             END IF;
             OC_ASEGURADO_CERTIFICADO.INSERTA(X.CodCia, nIdpoliza, nIDetPol, nCodAsegurado, nIdEndoso);
          END IF;
       ELSE
          cMsjError := 'Asegurado No. : ' || nCodAsegurado || ' Duplicado en Certificado No. ' || nIDetPol;
       END IF;
       -- Validar Coberturas
       IF OC_COBERT_ACT_ASEG.EXISTE_COBERTURA(X.CodCia, X.CodEmpresa, cIdTipoSeg, cPlanCob, 
                                              nIdPoliza, nIDetPol, nCodAsegurado) = 'N' THEN
          --
          nIdSolicitud := OC_SOLICITUD_EMISION.SOLICITUD_POLIZA(X.CodCia, X.CodEmpresa, nIdPoliza);
          --
          IF NVL(cIndSinAseg,'N') = 'N' THEN
             IF NVL(nIdSolicitud,0) = 0 THEN
                OC_COBERT_ACT_ASEG.CARGAR_COBERTURAS(X.CodCia, X.CodEmpresa, cIdTipoSeg, cPlanCob, 
                                                     nIdPoliza, nIDetPol, nTasaCambio, nCodAsegurado,
                                                     NULL, 0, 0, 0, 0, 99, 0, 0, 0, 0, 0, 0);
             ELSE
                OC_SOLICITUD_COBERTURAS.TRASLADA_COBERTURAS(X.CodCia, X.CodEmpresa, nIdSolicitud, nIdPoliza, nIDetPol, nCodAsegurado);
                OC_SOLICITUD_ASISTENCIAS.TRASLADA_ASISTENCIAS(X.CodCia, X.CodEmpresa, nIdSolicitud, nIdPoliza, nIDetPol, nCodAsegurado);
             END IF;
          END IF;
       END IF;
       -- Asignar Endoso a COBERTURAS y deja en Ceros las Primas de TODAS las coberturas Creadas.
       BEGIN
         IF NVL(nIdEndoso,0) != 0 THEN
            UPDATE COBERT_ACT_ASEG
               SET IdEndoso = nIdEndoso,
                   Prima_Moneda = 0,
                   Prima_Local  = 0
             WHERE CodCia        = X.CodCia
               AND IdPoliza      = nIdPoliza
               AND IDetPol       = nIDetPol
               AND Cod_Asegurado = nCodAsegurado;
         ELSE
            UPDATE COBERT_ACT_ASEG
               SET Prima_Moneda = 0,
                   Prima_Local  = 0
             WHERE CodCia        = X.CodCia
               AND IdPoliza      = nIdPoliza
               AND IDetPol       = nIDetPol
               AND Cod_Asegurado = nCodAsegurado;
         END IF;
       EXCEPTION
         WHEN OTHERS THEN
           cMsjError := 'Error al actualizar las Coberturas. ' || SQLERRM;
       END;
       -- Actualizar valores del Asegurado
       OC_ASEGURADO_CERTIFICADO.ACTUALIZA_VALORES(X.CodCia, X.CodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado);
       -- Asignar Código de Asegurado al registro Original.
       BEGIN
         UPDATE ASISTENCIAS_SINIESTROS
            SET CodAsegurado  = nCodAsegurado,
                StsAsistencia = 'ASEGUR'
          WHERE IdAsistencia  = nIdAsistencia
            AND IdPoliza      = nIdPoliza
            AND CodCliente    = nCodCliente
            AND IDetPol       = nIDetPol
            AND NumAtencion   = nNumAtencion;
       EXCEPTION
         WHEN OTHERS THEN
           cMsjError := 'Error al Actualizar PROCESOS_MASIVOS: '|| SQLERRM;
       END;
       -- Inserta Escuela
       IF X.NumDocIdentEsc IS NOT NULL THEN
          IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(X.TipoDocIdentEsc, X.NumDocIdentEsc) = 'N' THEN
             -- Si Existe Persona
             OC_PERSONA_NATURAL_JURIDICA.INSERTAR_PERSONA(X.TipoDocIdentEsc, X.NumDocIdentEsc, X.NombreEscuela, NULL, NULL, NULL, 'N', 'N', 
                                                          NULL, X.DomicilioEscuela, NULL, NULL, '001', X.EntidadEscuela, X.EntidadEscuela,
                                                          X.DelegacionEscuela, NULL, NULL, NULL, NULL, NULL);
             BEGIN --NombreEscuela, DomicilioEscuela, EntidadEscuela, DelegacionEscuela
               UPDATE PERSONA_NATURAL_JURIDICA
                  SET TIPO_PERSONA = 'MORAL',
                      CODACTIVIDAD = 'ESCGDF'
                WHERE Tipo_Doc_Identificacion = X.TipoDocIdentEsc
                  AND Num_Doc_Identificacion  = X.NumDocIdentEsc;
             EXCEPTION
               WHEN OTHERS THEN
                 RAISE_APPLICATION_ERROR(-20225,'Error al Actualizar Persona Natural Jurídica al Crear la Escuela');
             END;
          END IF;
       END IF;
       --
    ELSE
       cMsjError := 'No Existe la Póliza No. ' || X.IdPoliza || ' con el Subgrupo ' || X.IDetPol;
    END IF;
    --
    IF cMsjError IS NULL THEN
       cMsjError := NULL;
       OC_ASISTENCIAS_SINIESTROS.EMITIR_POLIZA_ESTIM_SINI(X.CodCia, X.CodEmpresa, /*nIdAsistencia,*/ nIdPoliza, /*nCodCliente,*/
                                                          nIDetPol, /*nNumAtencion,*/ nCodAsegurado, cMsjError);
    ELSE
       cMsjError := 'AUTOMATICO, 20225, No se puede Crear el Asegurado para el Siniestro: '||cMsjError;
    END IF;
    --
  END LOOP;
  --
EXCEPTION
  WHEN OTHERS THEN
    cMsjError := 'AUTOMATICO, 20226, No se puede Crear el Asegurado para el Siniestro: '||SQLERRM;
END CREA_ASEG_ESTIM_SINI;
--
--
--
PROCEDURE EMITIR_POLIZA_ESTIM_SINI(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER,
                                   nIDetPol NUMBER, nCodAsegurado NUMBER, cMsjError OUT VARCHAR2) IS
--
nIdEndoso              ENDOSOS.IdEndoso%TYPE;
cStsEndoso             ENDOSOS.StsEndoso%TYPE;
cTipoEndoso            ENDOSOS.TipoEndoso%TYPE;
--
BEGIN
  --
  IF nCodAsegurado > 0 AND
     nIdPoliza > 0 THEN
     -- Obtiene el IdEndoso
     BEGIN
       SELECT IdEndoso
         INTO nIdEndoso
         FROM ASEGURADO_CERTIFICADO
        WHERE CodCia         = nCodCia
          AND IdPoliza       = nIdpoliza
          AND IdetPol        = nIDetPol
          AND Cod_Asegurado  = nCodAsegurado;
     EXCEPTION
       WHEN OTHERS THEN
         cMsjError := 'No Existe Asegurado Certificado para la Póliza No. ' || nIdpoliza || ' con el Subgrupo ' || nIDetPol;
     END;
     -- Valida Estatus de ENDOSO
     IF NVL(nIdEndoso,0) > 0 THEN
        BEGIN
          SELECT StsEndoso, TipoEndoso
            INTO cStsEndoso, cTipoEndoso
            FROM ENDOSOS
           WHERE CodCia     = nCodCia
             AND CodEmpresa = nCodEmpresa
             AND IdPoliza   = nIdPoliza
             AND IdetPol    = nIdetPol
             AND IdEndoso   = nIdEndoso;
        EXCEPTION
          WHEN OTHERS THEN
            cMsjError := 'No Existe Endoso para la Póliza No. ' || nIdPoliza || ' con el Subgrupo ' || nIdetPol;
        END;
        -- Actualiza Estatus de ENDOSO
        IF cStsEndoso = 'SOL' THEN
           OC_ENDOSO.EMITIR(nCodCia, nCodEmpresa, nIdPoliza, nIdetPol, nIdEndoso, cTipoEndoso);
        END IF;
     END IF;
  ELSE 
     cMsjError := 'No Existe la Póliza No. ' || nIdPoliza || ' con el Subgrupo ' || nIdetPol || ' y Asegurado ' || nCodAsegurado;
  END IF;
  --
  IF cMsjError IS NOT NULL THEN
     cMsjError := 'AUTOMATICO, 20225, No se puede Crear el Asegurado para el Siniestro: '||cMsjError;
  END IF;
  --
EXCEPTION
  WHEN OTHERS THEN
    cMsjError := 'AUTOMATICO, 20225, Error - No se puede Emitir el Endoso '|| SQLERRM;
END EMITIR_POLIZA_ESTIM_SINI;
--
--
--
PROCEDURE ESTIMACION_SINIESTROS(nIdAsistencia VARCHAR2, nIdPoliza NUMBER, nCodCliente NUMBER, nIDetPol NUMBER,
                                nNumAtencion NUMBER, nIdSiniestro IN OUT NUMBER, cMsjError OUT VARCHAR2) IS
--
nEstimacionMoneda      SINIESTRO.Monto_Reserva_Moneda%TYPE;
cCod_Moneda            POLIZAS.Cod_Moneda%TYPE;
cIdTipoSeg             DETALLE_POLIZA.IdTipoSeg%TYPE;
nTasaCambio            DETALLE_POLIZA.Tasa_Cambio%TYPE;
cCodCobert             COBERT_ACT_ASEG.CodCobert%TYPE := 'GMXA';
cCodTransac            COBERTURA_SINIESTRO.CodTransac%TYPE      := 'APRVAD';
cCodCptoTransac        COBERTURA_SINIESTRO.CodCptoTransac%TYPE  := 'APRVAD';
nNumMod                COBERTURA_SINIESTRO.NumMod%TYPE;
nMonto_Reserva_Local   SINIESTRO.Monto_Reserva_Local%TYPE;
nMonto_Reserva_Moneda  SINIESTRO.Monto_Reserva_Moneda%TYPE;
nTotAjusteLocal        SINIESTRO.Monto_Reserva_Local%TYPE;
nTotAjusteMoneda       SINIESTRO.Monto_Reserva_Moneda%TYPE;
cMotivoSiniestro       SINIESTRO.Motivo_De_Siniestro%TYPE;
nOrden                 NUMBER(10):= 1;
nOrdenInc              NUMBER(10);
cUpdate                VARCHAR2(4000);
nCantSini              NUMBER(5);
cExisteDatPart         VARCHAR2(1);
cExisteCob             VARCHAR2(1);
cAjusteReserva         VARCHAR2(1) := 'N';
cTotSiniAseg           NUMBER := 0;
dFecIniVig             POLIZAS.FECINIVIG%TYPE;
dFecFinVig             POLIZAS.FECFINVIG%TYPE;
dFecAnul               POLIZAS.FECANUL%TYPE;
cValue                 VARCHAR2(4000);
--
CURSOR C_CAMPOS_PART(nCodCia NUMBER, nCodEmpresa NUMBER)  IS
  SELECT NomCampo, OrdenCampo, OrdenProceso, OrdenDatoPart
    FROM CONFIG_PLANTILLAS_CAMPOS C
   WHERE CodPlantilla = 'EMITESINIESTRO'
     AND CodEmpresa   = nCodEmpresa
     AND CodCia       = nCodCia
     AND NomTabla     = 'DATOS_PART_SINIESTROS'
     AND IndDatoPart  = 'S'
   ORDER BY OrdenDatoPart,OrdenCampo;
--
CURSOR ASIST_Q IS
   SELECT CodCia, CodEmpresa, IdAsistencia, IdPoliza, CodCliente, IDetPol, NumAtencion, IdSiniestro,
          CodAsegurado, MotivoSiniestro, EntidadFedOcurr, LocalidadMpioOcurr, FecOcurrencia, FecNotificacion,
          RFCHospital, FecIngresoHosp, FecEgresoHosp, Atencion, DescSiniestro, Estimacion, NIPCaptura, TipoProceso
     FROM ASISTENCIAS_SINIESTROS
    WHERE IdAsistencia   = nIdAsistencia
      AND IdPoliza       = nIdPoliza
      AND CodCliente     = nCodCliente
      AND IDetPol        = nIDetPol
      AND NumAtencion    = nNumAtencion;
--
BEGIN
  --
  FOR X IN ASIST_Q LOOP
    --
    cMsjError := NULL;
    --
    BEGIN
      SELECT P.Cod_Moneda, P.FecIniVig, P.FecFinVig, P.FecAnul
        INTO cCod_Moneda, dFecIniVig, dFecFinVig, dFecAnul
        FROM POLIZAS P, DETALLE_POLIZA DP
       WHERE P.IdPoliza   = X.IdPoliza
         AND P.CodCia     = X.CodCia
         AND P.CodEmpresa = X.CodEmpresa
         AND P.StsPoliza  IN ('SOL','EMI')
         AND P.CodCliente = X.CodCliente
         AND P.IdPoliza   = DP.IdPoliza
         AND DP.IDetPol   = X.IDetPol;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        cCod_Moneda := 0;
    END;
    --
    IF OC_POLIZAS.EXISTE_POLIZA(X.CodCia, X.CodEmpresa, X.IdPoliza) = 'S' THEN
       --
       SELECT COUNT(*)
         INTO nCantSini
         FROM SINIESTRO
        WHERE NumSiniRef = X.IdAsistencia
          AND CodCia     = X.CodCia;
       --
       IF nCantSini = 0 THEN
          --
          cAjusteReserva := 'N';
          --
          nTasaCambio       := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(SYSDATE));
          nEstimacionMoneda := X.Estimacion * nTasaCambio;
          IF X.MotivoSiniestro = 'PEND' THEN
             cMotivoSiniestro := NULL;
          ELSE
             cMotivoSiniestro := X.MotivoSiniestro;
          END IF;
          --
          nIdSiniestro := OC_SINIESTRO.INSERTA_SINIESTRO(X.CodCia, X.CodEmpresa, X.IdPoliza, X.IDetPol, X.IdAsistencia, X.FecOcurrencia, X.FecNotificacion, 
                                                         'Captura de la Asistenciadora el ' || TO_DATE(SYSDATE,'DD/MM/YYYY')|| ' Motivo: ' || X.DescSiniestro, '001',
                                                         cMotivoSiniestro, X.EntidadFedOcurr, X.LocalidadMpioOcurr);
          --
          BEGIN
            UPDATE SINIESTRO
               SET Cod_Asegurado = X.CodAsegurado
             WHERE CodCia      = X.CodCia
               AND IdSiniestro = nIdSiniestro;
          EXCEPTION
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR(-20225,'Error al Actualizar el Asegurado al SINIESTRO: '||SQLERRM);
          END;
          --
          OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, X.IdPoliza, 'Captura de la Asistenciadora el ' ||
                                                       TO_CHAR(TRUNC(SYSDATE),'DD/MM/YYYY')||' Motivo: '||X.DescSiniestro);
          --
          BEGIN
            INSERT INTO DATOS_PART_SINIESTROS
                  (CodCia, IdSiniestro, IdPoliza, FecSts)
            VALUES(X.CodCia, nIdSiniestro, X.IdPoliza, TRUNC(SYSDATE));
          EXCEPTION
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR(-20225,'Error al Insertar DATOS_PART_SINIESTROS: '||SQLERRM);
          END;
          --
          FOR I IN C_CAMPOS_PART(X.CodCia, X.CodEmpresa) LOOP
            --
            IF I.NomCampo = 'RFC HOSPITAL' THEN
               cValue := X.RFCHospital;
            ELSIF I.NomCampo = 'FECHA INGRESO HOSPITAL' THEN
                  cValue := X.FecIngresoHosp;
            ELSIF I.NomCampo = 'FECHA EGRESO HOSPITAL' THEN
                  cValue := X.FecEgresoHosp;
            ELSIF I.NomCampo = 'DESCRIPCION MEDICA' THEN
                  cValue := X.DescSiniestro;
            ELSIF I.NomCampo = 'EXPEDIENTE' THEN
                  cValue := X.Atencion;
            ELSIF I.NomCampo = 'ESTIMACION' THEN
                  cValue := X.Estimacion;
            ELSE
              cValue := NULL;
            END IF;
            --
            cUpdate   := 'UPDATE '||'DATOS_PART_SINIESTROS' || ' ' ||
                         'SET'||' ' || 'CAMPO' || I.OrdenDatoPart || '=' || '''' ||
                         cValue || '''' || ' ' ||
                         'WHERE IdPoliza  = ' || X.IdPoliza    ||' '||
                         'AND IdSiniestro = ' || nIdSiniestro ||' '||
                         'AND CodCia      = ' || X.CodCia;
            OC_DDL_OBJETOS.EJECUTAR_SQL(cUpdate);
            nOrden := nOrden + 1;
          END LOOP;
          --
          BEGIN
            SELECT IdTipoSeg
              INTO cIdTipoSeg
              FROM DETALLE_POLIZA
             WHERE CodCia      = X.CodCia
               AND CodEmpresa  = X.CodEmpresa
               AND IdPoliza    = X.IdPoliza
               AND IdetPol     = X.IDetPol;
          EXCEPTION 
            WHEN NO_DATA_FOUND THEN
              cIdTipoSeg := NULL;
          END;
          --
          IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(X.CodCia, X.IdPoliza, X.IDetPol, X.CodAsegurado) = 'N' THEN
             BEGIN
               INSERT INTO DETALLE_SINIESTRO
                     (IdSiniestro, IdPoliza, IdDetSin, Monto_Pagado_Moneda, Monto_Pagado_Local,
                      Monto_Reservado_Moneda, Monto_Reservado_Local, IdTipoSeg)
               VALUES(nIdSiniestro, X.IdPoliza, 1, 0, 0, nEstimacionMoneda, X.Estimacion, cIdTipoSeg);
             EXCEPTION
               WHEN OTHERS THEN
                 RAISE_APPLICATION_ERROR(-20225,'DETALLE SINIESTRO (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
             END;
             --
             BEGIN
               SELECT 'S'
                 INTO cExisteCob
                 FROM COBERT_ACT
                WHERE CodCia      = X.CodCia
                  AND CodEmpresa  = X.CodEmpresa
                  AND IdPoliza    = X.IdPoliza
                  AND IdetPol     = X.IDetPol
                  AND CodCobert   = cCodCobert;
             EXCEPTION 
               WHEN NO_DATA_FOUND THEn 
                 RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura de Gastos Médicos por Accidente (GMXA)');
             END;
             --
             IF cExisteCob = 'S' THEN
                BEGIN
                  INSERT INTO COBERTURA_SINIESTRO
                        (IdDetSin, CodCobert, IdSiniestro, IdPoliza, Doc_Ref_Pago, Monto_Pagado_Moneda, 
                         Monto_Pagado_Local, Monto_Reservado_Moneda, Monto_Reservado_Local,
                         StsCobertura, NumMod, CodTransac, CodCptoTransac, IdTransaccion, 
                         Saldo_Reserva, IndOrigen, FecRes, Saldo_Reserva_Local)
                  VALUES(1, cCodCobert, nIdSiniestro, X.IdPoliza, NULL, 0, 
                         0, nEstimacionMoneda, X.Estimacion, 
                         'SOL', 1, cCodTransac, cCodCptoTransac, NULL,
                         nEstimacionMoneda, 'D', TRUNC(SYSDATE), X.Estimacion);
                EXCEPTION
                  WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
                END;
             END IF;
          ELSE
             --
             BEGIN
               INSERT INTO DETALLE_SINIESTRO_ASEG
                     (IdSiniestro, IdPoliza, IdDetSin, Cod_Asegurado, Monto_Pagado_Moneda, Monto_Pagado_Local,
                      Monto_Reservado_Moneda, Monto_Reservado_Local, IdTipoSeg)
               VALUES(nIdSiniestro, X.IdPoliza, 1, X.CodAsegurado, 0, 0, nEstimacionMoneda, X.Estimacion, cIdTipoSeg);
             EXCEPTION
               WHEN OTHERS THEN
                 RAISE_APPLICATION_ERROR(-20225,'DETALLE SINIESTRO ASEG (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
             END;
             --
             BEGIN
               SELECT 'S'
                 INTO cExisteCob
                 FROM COBERT_ACT_ASEG
                WHERE CodCia        = X.CodCia
                  AND CodEmpresa    = X.CodEmpresa
                  AND IdPoliza      = nIdPoliza
                  AND IdetPol       = nIDetPol
                  AND Cod_Asegurado = X.CodAsegurado
                  AND CodCobert     = cCodCobert;
             EXCEPTION 
               WHEN NO_DATA_FOUND THEn 
                 RAISE_APPLICATION_ERROR(-20225,'NO Existe Cobertura de Gastos Médicos por Accidente (GMXA)');
             END;
             --
             BEGIN
               INSERT INTO COBERTURA_SINIESTRO_ASEG
                     (IdDetSin, CodCobert, IdSiniestro, IdPoliza, Cod_Asegurado, Doc_Ref_Pago, Monto_Pagado_Moneda, Monto_Pagado_Local,
                      Monto_Reservado_Moneda, Monto_Reservado_Local, StsCobertura, NumMod, CodTransac, CodCptoTransac, IdTransaccion, 
                      Saldo_Reserva, IndOrigen, FecRes, Saldo_Reserva_Local)
               VALUES(1, cCodCobert, nIdSiniestro, X.IdPoliza, X.CodAsegurado, NULL, 0,  0, nEstimacionMoneda, X.Estimacion, 'SOL',
                      1, cCodTransac, cCodCptoTransac, NULL, nEstimacionMoneda, 'A', TRUNC(SYSDATE), X.Estimacion);
             EXCEPTION
               WHEN OTHERS THEN
                 RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO ASEG (Cero Sini) - Ocurrió el siguiente error: '||SQLERRM);
             END;
          END IF;
		  --
       ELSIF X.TipoProceso = 'DISMINUIR' AND nCantSini > 0 THEN -- Se Aplica un Ajuste al Siniestro
          --
          cAjusteReserva    := 'S';
          --
          BEGIN
            SELECT Monto_Reserva_Local, Monto_Reserva_Moneda
              INTO nMonto_Reserva_Local, nMonto_Reserva_Moneda
              FROM SINIESTRO
             WHERE IdSiniestro = X.IdSiniestro
               AND NumSiniRef  = X.IdAsistencia
               AND CodCia      = X.CodCia;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20225,'No procede el Ajuste, NO Existe Siniestro No.: '||X.IdSiniestro);
            WHEN TOO_MANY_ROWS THEN
              RAISE_APPLICATION_ERROR(-20225,'Existen Varios Siniestros con Referencia No.: '||X.IdAsistencia);
          END;
          --
          nTasaCambio       := OC_GENERALES.TASA_DE_CAMBIO(cCod_Moneda, TRUNC(SYSDATE));
          nEstimacionMoneda := ABS(X.Estimacion) * nTasaCambio;
          --
          IF NVL(X.Estimacion,0) > 0 THEN
             cCodTransac     := 'AURVAD';
             cCodCptoTransac := 'AURVAD';
          ELSE
             cCodTransac     := 'DIRVAD';
             cCodCptoTransac := 'DIRVAD';
          END IF;
          --
          IF OC_ASEGURADO_CERTIFICADO.EXISTE_ASEGURADO(X.CodCia, X.IdPoliza, X.IDetPol, X.CodAsegurado) = 'N' THEN
             BEGIN
               SELECT NVL(MAX(NumMod),0) + 1
                 INTO nNumMod
                 FROM COBERTURA_SINIESTRO
                WHERE IdSiniestro = X.IdSiniestro
                  AND CodCobert   = cCodCobert
                  AND IdPoliza    = X.IdPoliza;
             END;
             --
             BEGIN
               INSERT INTO COBERTURA_SINIESTRO
                     (IdDetSin, CodCobert, IdSiniestro, IdPoliza, Doc_Ref_Pago, Monto_Pagado_Moneda, Monto_Pagado_Local,
                      Monto_Reservado_Moneda, Monto_Reservado_Local, StsCobertura, NumMod, CodTransac, CodCptoTransac, IdTransaccion, 
                      Saldo_Reserva, IndOrigen, FecRes, Saldo_Reserva_Local)
               VALUES(1, cCodCobert, X.IdSiniestro, X.IdPoliza, NULL, 0, 0, nEstimacionMoneda , ABS(X.Estimacion), 
                      'SOL', nNumMod, cCodTransac, cCodCptoTransac, NULL, nEstimacionMoneda, 'D', TRUNC(SYSDATE), ABS(X.Estimacion));
             EXCEPTION
               WHEN OTHERS THEN
                 RAISE_APPLICATION_ERROR(-20225,'COBERTURA SINIESTRO (Un Sini) - Ocurrió el siguiente error: '||SQLERRM);
             END;
             --
             OC_COBERTURA_SINIESTRO.EMITE_RESERVA(X.CodCia, X.CodEmpresa, X.IdSiniestro, X.IdPoliza, 1, cCodCobert, nNumMod, NULL);
          ELSE
             --
             SELECT NVL(MAX(NumMod),0) + 1
               INTO nNumMod
               FROM COBERTURA_SINIESTRO_ASEG
              WHERE IdSiniestro   = X.IdSiniestro
                AND CodCobert     = cCodCobert
                AND Cod_Asegurado = X.CodAsegurado
                AND IdPoliza      = X.IdPoliza;
             --
             BEGIN
               INSERT INTO COBERTURA_SINIESTRO_ASEG
                     (IdDetSin, CodCobert, IdSiniestro, IdPoliza, Cod_Asegurado, Doc_Ref_Pago, Monto_Pagado_Moneda, 
                      Monto_Pagado_Local, Monto_Reservado_Moneda, Monto_Reservado_Local, StsCobertura, NumMod, CodTransac,
                      CodCptoTransac, IdTransaccion, Saldo_Reserva, IndOrigen, FecRes, Saldo_Reserva_Local)
               VALUES(1, cCodCobert, X.IdSiniestro, X.IdPoliza, X.CodAsegurado, NULL, 0, 0, nEstimacionMoneda , ABS(X.Estimacion), 
                      'SOL', nNumMod, cCodTransac, cCodCptoTransac, NULL, nEstimacionMoneda, 'D', TRUNC(SYSDATE), ABS(X.Estimacion));
             EXCEPTION
               WHEN OTHERS THEN
                 RAISE_APPLICATION_ERROR(-20225,'COBERTURA_SINIESTRO_ASEG (Un Sini) - Ocurrió el siguiente error: '||SQLERRM);
             END;
             --
             OC_COBERTURA_SINIESTRO_ASEG.EMITE_RESERVA(X.CodCia, X.CodEmpresa, X.IdSiniestro, X.IdPoliza, 1, X.CodAsegurado, cCodCobert, nNumMod, NULL);
             --
          END IF;
          --
       ELSE
	      cMsjError := 'La acción que desea ejecutar no es válida';
       END IF;
       --
    ELSE 
       cMsjError := 'No Existe la Póliza No. ' || X.IdPoliza;
    END IF;
    --
    IF cMsjError IS NULL THEN
       IF cAjusteReserva = 'N' THEN
          OC_SINIESTRO.ACTIVAR(X.CodCia, X.CodEmpresa, nIdSiniestro, X.IdPoliza, X.IDetPol);
       END IF;
       --
       BEGIN
         UPDATE ASISTENCIAS_SINIESTROS
            SET IdSiniestro   = nIdSiniestro,
                StsAsistencia = 'EMITID'
          WHERE IdAsistencia  = nIdAsistencia
            AND IdPoliza      = nIdPoliza
            AND CodCliente    = nCodCliente
            AND IDetPol       = nIDetPol
            AND NumAtencion   = nNumAtencion;
       EXCEPTION
         WHEN OTHERS THEN
           RAISE_APPLICATION_ERROR(-20225,'Error al Actualizar el IdSiniestro en ASISTENCIAS_SINIESTROS: '||SQLERRM);
       END;
       --
    ELSE
       cMsjError := 'No se puede Cargar el Siniestro: '||cMsjError;
    END IF;
    --
  END LOOP;
  --
EXCEPTION
   WHEN OTHERS THEN
     cMsjError := 'No se puede Crear el Siniestro: '||SQLERRM;
END ESTIMACION_SINIESTROS;

END OC_ASISTENCIAS_SINIESTROS;

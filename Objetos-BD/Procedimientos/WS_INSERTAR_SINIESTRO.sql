create or replace PROCEDURE SICAS_OC.WS_INSERTAR_SINIESTRO (
    p_IdPoliza           IN SINIESTRO.IDPOLIZA%TYPE,
    p_IdetPol            IN DETALLE_POLIZA.IdetPol%TYPE,
    p_CodCia             IN SINIESTRO.CODCIA%TYPE,
    p_CodEmpresa         IN SINIESTRO.CODEMPRESA%TYPE,
    p_TipoSiniestro      IN SINIESTRO.TIPO_SINIESTRO%TYPE,
    p_RefSiniestro       IN SINIESTRO.NUMSINIREF%TYPE,
    p_FecOcurrencia      IN DATE,
    p_FecNotificacion    IN DATE,
    p_DescSiniestro      IN VARCHAR2,
    p_MontoReserva       IN NUMBER,
    p_MontoPago          IN NUMBER,
    p_CodMoneda          IN SINIESTRO.COD_MONEDA%TYPE,
    p_CodAsegurado       IN SINIESTRO.COD_ASEGURADO%TYPE,
    p_CodUsuario         IN SINIESTRO.CODUSUARIO%TYPE,
    p_Submotivo          IN SINIESTRO.SUBMOTIVO_SINIESTRO%TYPE,
    p_CodRiesgoRea       IN SINIESTRO.CODRIESGOREA%TYPE,
    p_IdContribuyente    IN SINIESTRO.IDCONTRIBUTORIO%TYPE,
    p_NumTributario      IN SINIESTRO.RFC_ASEGURADO%TYPE,
    p_Curp               IN PERSONA_NATURAL_JURIDICA.CURP%TYPE,
    p_CodPais             IN SINIESTRO.CODPAISOCURR%TYPE,
    p_CodProv             IN SINIESTRO.CODPROVOCURR%TYPE,
    p_CodMunicipio       IN SINIESTRO.CODMUNICIPIO%TYPE,
    p_EmpresaLabora      IN SINIESTRO.EMPRESA_LABORA%TYPE,
    p_MotivoSiniestro    IN SINIESTRO.MOTIVO_DE_SINIESTRO%TYPE,
    p_CodProveedor       IN SINIESTRO.CODPROVEEDOR%TYPE,
    p_NomMedico          IN SINIESTRO.NOM_MEDICO_CERTIFICA%TYPE,
    p_IdCedulaMedica     IN SINIESTRO.ID_CEDULA_MEDICA%TYPE,
    p_TipoAsegurado      IN SINIESTRO.TP_ASEGURADO%TYPE,
    p_IdCredito          IN SINIESTRO.IDCREDITO%TYPE,
    p_IdSiniestro        IN OUT NUMBER,
    p_Mensaje            OUT VARCHAR2
) AS
    --v_IdSiniestro        SINIESTRO.IDSINIESTRO%TYPE;
    v_IdTipoSeg          TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;
    v_PlanCob            PLAN_COBERTURAS.PlanCob%TYPE;
    v_CodMoneda          POLIZAS.Cod_Moneda%TYPE;
    v_FechaRegistro      DATE := TRUNC(SYSDATE);
    v_Tasa              NUMBER := 1;
    v_TipoDocId         ASEGURADO.TIPO_DOC_IDENTIFICACION%TYPE;
    v_NumDocId          ASEGURADO.NUM_DOC_IDENTIFICACION%TYPE;
    v_Curp              PERSONA_NATURAL_JURIDICA.CURP%TYPE;
BEGIN
    -- Obtener Tipo de Seguro y Plan de Cobertura
    BEGIN
        SELECT IdTipoSeg, PlanCob
        INTO v_IdTipoSeg, v_PlanCob
        FROM DETALLE_POLIZA
        WHERE IdPoliza = p_IdPoliza
          AND CodCia = p_CodCia
          AND CodEmpresa = p_CodEmpresa
          AND IdetPol = p_IdetPol;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_Mensaje := 'No Existen Pólizas Asociadas o No Seleccionó el Subgrupo';
            RETURN;
    END;
    -- Obtener la moneda de la póliza
    BEGIN
        SELECT Cod_Moneda INTO v_CodMoneda FROM POLIZAS WHERE IdPoliza = p_IdPoliza;
    END;
    -- Obtener nuevo ID de siniestro
    p_IdSiniestro := OC_SINIESTRO.F_GET_SIN(p_Mensaje);
    -- Insertar en Observaciones de Siniestro
    INSERT INTO OBSERVACION_SINIESTRO (idsiniestro, idpoliza, idobserva, fecobserv, codusuario, descripcion, codcia, codempresa)
    VALUES (p_IdSiniestro, p_IdPoliza, 1, v_FechaRegistro, p_CodUsuario, 'Creación de Siniestro', p_CodCia, p_CodEmpresa);
    -- Insertar en Datos de Siniestro Negocio si aplica
    IF p_CodMunicipio IS NOT NULL THEN
        INSERT INTO DATOS_SINIESTRO_NEGOCIO (CODCIA, CODEMPRESA, IDSINIESTRO, CODAGRUPADOR, CODPLANTEL, 
                                             ST_SINIESTRO_DOCTO, ID_MOTIVO_RECHAZO, MONTO_RECHAZO_NOCUM, 
                                             FECHA_REGISTRO, USUARIO_REGISTRO)
        VALUES (p_CodCia, p_CodEmpresa, p_IdSiniestro, '1053', p_CodMunicipio, 
                NULL, NULL, NULL, v_FechaRegistro, p_CodUsuario);
    END IF;
     -- Obtener información del asegurado
    BEGIN
        SELECT TIPO_DOC_IDENTIFICACION, NUM_DOC_IDENTIFICACION
        INTO v_TipoDocId, v_NumDocId
        FROM ASEGURADO
        WHERE COD_ASEGURADO = p_CodAsegurado;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL; -- No se encontró asegurado, no se interrumpe el proceso
    END;
    -- Validar y actualizar RFC si cambió
    IF p_NumTributario IS NOT NULL AND p_NumTributario <> v_NumDocId THEN
        UPDATE PERSONA_NATURAL_JURIDICA
        SET NUM_TRIBUTARIO = p_NumTributario
        WHERE TIPO_DOC_IDENTIFICACION = v_TipoDocId
          AND NUM_DOC_IDENTIFICACION = v_NumDocId;
        -- Insertar cambio en el historial
        TH_CONTROL_CAMBIO_DATOS.INSERTA_CAMBIO(p_CodCia, p_CodEmpresa, p_IdPoliza, p_IdSiniestro,
                                               'NUM_TRIBUTARIO', 'PERSONA_NATURAL_JURIDICA', v_NumDocId, p_NumTributario,
                                               USER, 'MODOPE', p_Mensaje);
    END IF;
    -- Validar y actualizar CURP si cambió (solo si p_Curp está declarado)
    IF p_Curp IS NOT NULL THEN
        -- Obtener CURP actual desde PERSONA_NATURAL_JURIDICA
        BEGIN
            SELECT CURP INTO v_Curp
            FROM PERSONA_NATURAL_JURIDICA
            WHERE TIPO_DOC_IDENTIFICACION = v_TipoDocId
              AND NUM_DOC_IDENTIFICACION = v_NumDocId;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_Curp := NULL;
        END;
       
        IF (p_Curp IS NULL AND v_Curp IS NOT NULL) OR
           (p_Curp IS NOT NULL AND v_Curp IS NULL) OR
           (p_Curp IS NOT NULL AND v_Curp IS NOT NULL AND p_Curp <> v_Curp) THEN
            UPDATE PERSONA_NATURAL_JURIDICA
            SET CURP = p_Curp
            WHERE TIPO_DOC_IDENTIFICACION = v_TipoDocId
              AND NUM_DOC_IDENTIFICACION = v_NumDocId;
            -- Insertar cambio en el historial
            TH_CONTROL_CAMBIO_DATOS.INSERTA_CAMBIO(p_CodCia, p_CodEmpresa, p_IdPoliza, p_IdSiniestro,
                                                   'CURP', 'PERSONA_NATURAL_JURIDICA', v_Curp, p_Curp,
                                                   USER, 'MODOPE', p_Mensaje);
        END IF;
    END IF;
    -- Insertar en tabla SINIESTRO
    INSERT INTO SINIESTRO (CODCIA, IDSINIESTRO, IDPOLIZA, NUMSINIREF, TIPO_SINIESTRO, 
                           FEC_OCURRENCIA, FEC_NOTIFICACION, STS_SINIESTRO, 
                           FECSTS, DESC_SINIESTRO, MONTO_RESERVA_LOCAL, MONTO_RESERVA_MONEDA, 
                           MONTO_PAGO_LOCAL, MONTO_PAGO_MONEDA, COD_MONEDA, 
                           IDETPOL, CODEMPRESA, CODPAISOCURR, CODPROVOCURR, COD_ASEGURADO, 
                           IDCOLEINDI, IDTPORIGEN, CODUSUARIO, FECREGISTRO, SUBMOTIVO_SINIESTRO, 
                           CODRIESGOREA, IDCONTRIBUTORIO, RFC_ASEGURADO, CODMUNICIPIO, EMPRESA_LABORA, 
                           MOTIVO_DE_SINIESTRO, CODPROVEEDOR, NOM_MEDICO_CERTIFICA, ID_CEDULA_MEDICA, 
                           TP_ASEGURADO, IDCREDITO)
    VALUES (p_CodCia, p_IdSiniestro, p_IdPoliza, p_RefSiniestro, p_TipoSiniestro, 
            p_FecOcurrencia, p_FecNotificacion, 'SOL', 
            v_FechaRegistro, UPPER(p_DescSiniestro), p_MontoReserva / v_Tasa, p_MontoReserva, 
            p_MontoPago / v_Tasa, p_MontoPago, p_CodMoneda, 
            p_IdetPol, p_CodEmpresa, p_CodPais, p_CodProv, p_CodAsegurado, 
            NULL, NULL, p_CodUsuario, v_FechaRegistro, p_Submotivo, 
            p_CodRiesgoRea, p_IdContribuyente, p_NumTributario, p_CodMunicipio, p_EmpresaLabora, 
            p_MotivoSiniestro, p_CodProveedor, p_NomMedico, p_IdCedulaMedica, 
            p_TipoAsegurado, p_IdCredito);
    -- Confirmar la transacción
    COMMIT;
    --p_Mensaje := 'Siniestro insertado con éxito. ID: ' || p_IdSiniestro;
    p_Mensaje := '';
EXCEPTION
    WHEN OTHERS THEN
        p_Mensaje := 'Error al insertar siniestro: ' || SQLERRM;
        ROLLBACK;
END WS_INSERTAR_SINIESTRO;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_INSERTAR_SINIESTRO FOR SICAS_OC.WS_INSERTAR_SINIESTRO
/

GRANT EXECUTE ON SICAS_OC.WS_INSERTAR_SINIESTRO TO PUBLIC
/
create or replace PROCEDURE SICAS_OC.WS_MODIFICA_BENEFICIARIO (
    p_benef               IN NUMBER,
    p_idsiniestro         IN NUMBER DEFAULT NULL,
    p_idpoliza            IN NUMBER,
    p_certificado         IN NUMBER DEFAULT NULL,
    p_codasegurado        IN NUMBER,    
    p_nombre              IN VARCHAR2,
    p_apellidopaterno     IN VARCHAR2,
    p_apellidomaterno     IN VARCHAR2,
    p_fecnac              IN DATE,
    p_tipoidtributario    IN VARCHAR2,
    p_numdoctributario    IN VARCHAR2,
    p_sexo                IN VARCHAR2,
    p_direccion           IN VARCHAR2,
    p_email               IN VARCHAR2,
    p_entfinanciera       IN VARCHAR2,
    p_numcuentabancaria   IN VARCHAR2,
    p_cuentaclave          IN VARCHAR2,
    p_telefonolocal       IN VARCHAR2,
    p_telefono            IN VARCHAR2,
    p_indaplicaisr        IN VARCHAR2,
    p_indirrevocable      IN VARCHAR2 DEFAULT NULL,
    p_mensaje             OUT VARCHAR2
) AS
    v_count NUMBER;
BEGIN
    IF p_idpoliza IS NULL OR p_codasegurado IS NULL OR p_benef IS NULL THEN
        p_mensaje := 'Debe proporcionar IDPOLIZA, COD_ASEGURADO y BENEF.';
        RAISE_APPLICATION_ERROR(-20500, p_mensaje);
    END IF;
    IF p_idsiniestro IS NOT NULL AND p_certificado IS NOT NULL THEN
        p_mensaje := 'No debe proporcionar ambos: IDSINIESTRO y CERTIFICADO.';
        RAISE_APPLICATION_ERROR(-20501, p_mensaje);
    END IF;
    IF p_idsiniestro IS NULL AND p_certificado IS NULL THEN
        p_mensaje := 'Debe proporcionar IDSINIESTRO o CERTIFICADO.';
        RAISE_APPLICATION_ERROR(-20502, p_mensaje);
    END IF;
    IF p_idsiniestro IS NOT NULL THEN
        -- Validar existencia en BENEF_SIN
        SELECT COUNT(*) INTO v_count
        FROM BENEF_SIN
        WHERE IDSINIESTRO = p_idsiniestro
          AND IDPOLIZA = p_idpoliza
          AND COD_ASEGURADO = p_codasegurado
          AND BENEF = p_benef;
        IF v_count = 0 THEN
            p_mensaje := 'No se encontró el beneficiario en BENEF_SIN.';
            RAISE_APPLICATION_ERROR(-20503, p_mensaje);
        END IF;
        -- Actualizar BENEF_SIN
        UPDATE BENEF_SIN
        SET
            NOMBRE              = p_nombre,
            APELLIDO_PATERNO    = p_apellidopaterno,
            APELLIDO_MATERNO    = p_apellidomaterno,
            FECNAC              = p_fecnac,
            TIPO_ID_TRIBUTARIO  = p_tipoidtributario,
            NUM_DOC_TRIBUTARIO  = p_numdoctributario,
            SEXO                = p_sexo,
            DIRECCION           = p_direccion,
            EMAIL               = p_email,
            ENT_FINANCIERA      = p_entfinanciera,
            NUMCUENTABANCARIA   = p_numcuentabancaria,
            CUENTA_CLAVE        = p_cuentaclave,
            TELEFONO_LOCAL      = p_telefonolocal,
            TELEFONO            = p_telefono,
            INDAPLICAISR        = p_indaplicaisr,
            FECESTADO           = SYSDATE
        WHERE IDSINIESTRO = p_idsiniestro
          AND IDPOLIZA = p_idpoliza
          AND COD_ASEGURADO = p_codasegurado
          AND BENEF = p_benef;
    ELSIF p_certificado IS NOT NULL THEN
        -- Validar existencia en BENEFICIARIO
        SELECT COUNT(*) INTO v_count
        FROM BENEFICIARIO
        WHERE IDPOLIZA = p_idpoliza
          AND IDETPOL = p_certificado
          AND COD_ASEGURADO = p_codasegurado
          AND BENEF = p_benef;
        IF v_count = 0 THEN
            p_mensaje := 'No se encontró el beneficiario en BENEFICIARIO.';
            RAISE_APPLICATION_ERROR(-20504, p_mensaje);
        END IF;
        -- Actualizar BENEFICIARIO
        UPDATE BENEFICIARIO
        SET
            NOMBRE          = p_nombre || ' ' || p_apellidopaterno || ' ' || p_apellidomaterno,
            FECNAC          = p_fecnac,
            SEXO            = p_sexo,
            INDIRREVOCABLE  = NVL(p_indirrevocable, INDIRREVOCABLE),
            FECESTADO       = SYSDATE
        WHERE IDPOLIZA = p_idpoliza
          AND IDETPOL = p_certificado
          AND COD_ASEGURADO = p_codasegurado
          AND BENEF = p_benef;
    END IF;
    COMMIT;
    p_mensaje := '';
EXCEPTION
    WHEN OTHERS THEN
        p_mensaje := 'Error al modificar beneficiario: ' || SQLERRM;
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20599, p_mensaje);
END WS_MODIFICA_BENEFICIARIO;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_MODIFICA_BENEFICIARIO FOR SICAS_OC.WS_MODIFICA_BENEFICIARIO
/

GRANT EXECUTE ON SICAS_OC.WS_MODIFICA_BENEFICIARIO TO PUBLIC
/
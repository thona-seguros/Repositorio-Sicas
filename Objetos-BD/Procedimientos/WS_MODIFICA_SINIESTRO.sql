create or replace PROCEDURE SICAS_OC.WS_MODIFICA_SINIESTRO (
    p_idsiniestro        IN SINIESTRO.IDSINIESTRO%TYPE,
    p_refsiniestro       IN SINIESTRO.NUMSINIREF%TYPE,
    p_tiposiniestro      IN SINIESTRO.TIPO_SINIESTRO%TYPE,
    p_fechaocurrencia    IN DATE,
    p_fechanotificacion  IN DATE,
    p_descsiniestro      IN VARCHAR2,
    p_montoreserva       IN NUMBER,
    p_montopago          IN NUMBER,
    p_codmoneda          IN SINIESTRO.COD_MONEDA%TYPE,
    p_codasegurado       IN SINIESTRO.COD_ASEGURADO%TYPE,
    p_codusuario         IN SINIESTRO.CODUSUARIO%TYPE,
    p_submotivo          IN SINIESTRO.SUBMOTIVO_SINIESTRO%TYPE,
    p_codriesgorea       IN SINIESTRO.CODRIESGOREA%TYPE,
    p_idcontributorio    IN SINIESTRO.IDCONTRIBUTORIO%TYPE,
    p_numtributario      IN SINIESTRO.RFC_ASEGURADO%TYPE,
    p_codmunicipio       IN SINIESTRO.CODMUNICIPIO%TYPE,
    p_empresalabora      IN SINIESTRO.EMPRESA_LABORA%TYPE,
    p_motivosiniestro    IN SINIESTRO.MOTIVO_DE_SINIESTRO%TYPE,
    p_codproveedor       IN SINIESTRO.CODPROVEEDOR%TYPE,
    p_nommedicocertifica IN SINIESTRO.NOM_MEDICO_CERTIFICA%TYPE,
    p_idcedulamedica     IN SINIESTRO.ID_CEDULA_MEDICA%TYPE,
    p_tipoasegurado      IN SINIESTRO.TP_ASEGURADO%TYPE,
    p_idcredito          IN SINIESTRO.IDCREDITO%TYPE
) AS
v_Tasa    NUMBER := 1;
BEGIN
    -- Actualizar los valores solo si no son nulos
    UPDATE SINIESTRO
    SET 
        NUMSINIREF        = COALESCE(p_refsiniestro, NUMSINIREF),
        TIPO_SINIESTRO    = COALESCE(p_tiposiniestro, TIPO_SINIESTRO),
        FEC_OCURRENCIA    = COALESCE(p_fechaocurrencia, FEC_OCURRENCIA),
        FEC_NOTIFICACION  = COALESCE(p_fechanotificacion, FEC_NOTIFICACION),
        DESC_SINIESTRO    = COALESCE(p_descsiniestro, DESC_SINIESTRO),
        MONTO_RESERVA_LOCAL = COALESCE(p_montoreserva / v_Tasa, MONTO_RESERVA_LOCAL),
        MONTO_RESERVA_MONEDA = COALESCE(p_montoreserva, MONTO_RESERVA_MONEDA),
        MONTO_PAGO_LOCAL  = COALESCE(p_montopago / v_Tasa, MONTO_PAGO_LOCAL),
        MONTO_PAGO_MONEDA = COALESCE(p_montopago, MONTO_PAGO_MONEDA),
        COD_MONEDA        = COALESCE(p_codmoneda, COD_MONEDA),
        COD_ASEGURADO     = COALESCE(p_codasegurado, COD_ASEGURADO),
        CODUSUARIO        = COALESCE(p_codusuario, CODUSUARIO),
        SUBMOTIVO_SINIESTRO = COALESCE(p_submotivo, SUBMOTIVO_SINIESTRO),
        CODRIESGOREA      = COALESCE(p_codriesgorea, CODRIESGOREA),
        IDCONTRIBUTORIO    = COALESCE(p_idcontributorio, IDCONTRIBUTORIO),
        RFC_ASEGURADO     = COALESCE(p_numtributario, RFC_ASEGURADO),
        CODMUNICIPIO       = COALESCE(p_codmunicipio, CODMUNICIPIO),
        EMPRESA_LABORA     = COALESCE(p_empresalabora, EMPRESA_LABORA),
        MOTIVO_DE_SINIESTRO = COALESCE(p_motivosiniestro, MOTIVO_DE_SINIESTRO),
        CODPROVEEDOR       = COALESCE(p_codproveedor, CODPROVEEDOR),
        NOM_MEDICO_CERTIFICA = COALESCE(p_nommedicocertifica, NOM_MEDICO_CERTIFICA),
        ID_CEDULA_MEDICA   = COALESCE(p_idcedulamedica, ID_CEDULA_MEDICA),
        TP_ASEGURADO       = COALESCE(p_tipoasegurado, TP_ASEGURADO),
        IDCREDITO          = COALESCE(p_idcredito, IDCREDITO)
    WHERE IDSINIESTRO = p_idsiniestro;
    COMMIT;
END WS_MODIFICA_SINIESTRO;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_MODIFICA_SINIESTRO FOR SICAS_OC.WS_MODIFICA_SINIESTRO
/

GRANT EXECUTE ON SICAS_OC.WS_MODIFICA_SINIESTRO TO PUBLIC
/
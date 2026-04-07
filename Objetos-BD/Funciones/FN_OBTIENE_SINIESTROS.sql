create or replace FUNCTION SICAS_OC.FN_OBTIENE_SINIESTROS (
    p_id_poliza     IN NUMBER,
    p_cod_asegurado IN NUMBER,
    p_cod_subgrupo  IN NUMBER,
    p_cod_cia       IN NUMBER DEFAULT NULL,
    p_cod_empresa   IN NUMBER DEFAULT NULL
) RETURN CLOB 
AS
    v_resultado SYS_REFCURSOR;
    v_json CLOB;
    v_temp CLOB;
    
    -- Variables para cada columna del resultado
    v_id_siniestro SINIESTRO.IdSiniestro%TYPE;
    v_fec_ocurrencia SINIESTRO.Fec_Ocurrencia%TYPE;
    v_fec_notificacion SINIESTRO.Fec_Notificacion%TYPE;
    v_sts_siniestro SINIESTRO.Sts_Siniestro%TYPE;
    v_monto_reserva_local DETALLE_SINIESTRO_ASEG.MONTO_RESERVADO_LOCAL%TYPE;
    v_monto_reserva_moneda DETALLE_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
    v_monto_pago_local DETALLE_SINIESTRO_ASEG.MONTO_PAGADO_LOCAL%TYPE;
    v_monto_pago_moneda DETALLE_SINIESTRO_ASEG.MONTO_PAGADO_MONEDA%TYPE;
    v_cod_asegurado SINIESTRO.Cod_Asegurado%TYPE;
    v_desc_cod_asegurado VARCHAR2(500);
    v_motivo_siniestro SINIESTRO.Motivo_de_Siniestro%TYPE;
    v_desc_motivo VARCHAR2(500);
    v_desc_status VARCHAR2(500);
    v_num_sini_ref SINIESTRO.NumSiniRef%TYPE;
    v_idet_pol SINIESTRO.IDetPol%TYPE;
    v_id_poliza SINIESTRO.IdPoliza%TYPE;
    v_ult_fec_pago DATE;
    
BEGIN
    -- Crear un CLOB temporal para almacenar el JSON
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH('[ '), '[ ');
    
    -- Llamar al procedimiento para obtener el cursor con los datos
    WS_OBTIENE_SINIESTROS(
        P_IDPOLIZA     => p_id_poliza,
        P_CODASEGURADO => p_cod_asegurado,
        P_CODSUBGRUPO  => p_cod_subgrupo,
        P_CODCIA       => p_cod_cia,
        P_CODEMPRESA   => p_cod_empresa,
        P_RESULTADO    => v_resultado
    );
    
    -- Recorrer el cursor y construir el JSON manualmente
    LOOP
        FETCH v_resultado INTO 
            v_id_siniestro,
            v_fec_ocurrencia,
            v_fec_notificacion,
            v_sts_siniestro,
            v_monto_reserva_local,
            v_monto_reserva_moneda,
            v_monto_pago_local,
            v_monto_pago_moneda,
            v_cod_asegurado,
            v_desc_cod_asegurado,
            v_motivo_siniestro,
            v_desc_motivo,
            v_desc_status,
            v_num_sini_ref,
            v_idet_pol,
            v_id_poliza,
            v_ult_fec_pago;
        EXIT WHEN v_resultado%NOTFOUND;
        
        v_temp := '{
            "IdSiniestro": ' || v_id_siniestro || ',
            "Fec_Ocurrencia": "' || TO_CHAR(v_fec_ocurrencia, 'YYYY-MM-DD') || '",
            "Fec_Notificacion": "' || TO_CHAR(v_fec_notificacion, 'YYYY-MM-DD') || '",
            "Sts_Siniestro": "' || v_sts_siniestro || '",
            "Monto_Reserva_Local": ' || v_monto_reserva_local || ',
            "Monto_Reserva_Moneda": ' || v_monto_reserva_moneda || ',
            "Monto_Pago_Local": ' || v_monto_pago_local || ',
            "Monto_Pago_Moneda": ' || v_monto_pago_moneda || ',
            "Cod_Asegurado": "' || v_cod_asegurado || '",
            "cDescCodAsegurado": "' || v_desc_cod_asegurado || '",
            "Motivo_de_Siniestro": "' || v_motivo_siniestro || '",
            "DescMotivo": "' || v_desc_motivo || '",
            "DescStatus": "' || v_desc_status || '",
            "NumSiniRef": "' || v_num_sini_ref || '",
            "IDetPol": ' || v_idet_pol || ',
            "IdPoliza": ' || v_id_poliza || ',
            "ultfecpago": "' || TO_CHAR(v_ult_fec_pago, 'YYYY-MM-DD') || '"
        }';
        
        -- Agregar coma si no es la primera fila
        IF DBMS_LOB.GETLENGTH(v_json) > 2 THEN
            DBMS_LOB.WRITEAPPEND(v_json, LENGTH(', '), ', ');
        END IF;
        
        DBMS_LOB.WRITEAPPEND(v_json, LENGTH(v_temp), v_temp);
    END LOOP;
    
    -- Cerrar el cursor
    CLOSE v_resultado;
    
    -- Cerrar JSON array
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH(' ]'), ' ]');
    
    -- Retornar el JSON generado
    RETURN v_json;
EXCEPTION
    WHEN OTHERS THEN
        RETURN '{ "error": "' || SQLERRM || '" }';
END FN_OBTIENE_SINIESTROS;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_OBTIENE_SINIESTROS FOR SICAS_OC.FN_OBTIENE_SINIESTROS
/

GRANT EXECUTE ON SICAS_OC.FN_OBTIENE_SINIESTROS TO PUBLIC
/
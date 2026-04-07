create or replace FUNCTION SICAS_OC.FN_OBTIENE_POLIZAS_POR_ID (  
    p_id_poliza     IN NUMBER,
    p_num_pol_unico IN VARCHAR2,
    p_codcia        IN NUMBER DEFAULT NULL,
    p_codempresa    IN NUMBER DEFAULT NULL
) RETURN CLOB 
AS
    v_resultado SYS_REFCURSOR;
    v_json      CLOB;
    v_temp      CLOB;
    -- Variables para cada columna del resultado
    v_cod_asegurado        VARCHAR2(10);
    v_nom_asegurado        VARCHAR2(300);
    v_cod_cliente          POLIZAS.CodCliente%TYPE;
    v_nom_contratante      VARCHAR2(300);
    v_num_pol_unico        POLIZAS.NumPolUnico%TYPE;
    v_id_poliza            DETALLE_POLIZA.IdPoliza%TYPE;
    v_idet_pol             DETALLE_POLIZA.IDetPol%TYPE;
    v_fec_pago             DATE;
    v_fec_ini_vig          DETALLE_POLIZA.FecIniVig%TYPE;
    v_fec_fin_vig          DETALLE_POLIZA.FecFinVig%TYPE;
    v_id_tipo_seg          DETALLE_POLIZA.IdTipoSeg%TYPE;
    v_plan_cob             DETALLE_POLIZA.PlanCob%TYPE;
    v_sts_detalle          DETALLE_POLIZA.StsDetalle%TYPE;
    v_cod_empresa          DETALLE_POLIZA.CodEmpresa%TYPE;
    v_ind_pol_col          POLIZAS.IndPolCol%TYPE;
    v_desc_tipo_seg        VARCHAR2(100);
    v_desc_plan_cob        VARCHAR2(100);
    v_desc_status          VARCHAR2(100);
    v_num_pol_ref          POLIZAS.NUMPOLREF%TYPE;
    v_cod_cia              POLIZAS.CodCia%TYPE;
    v_tipo_admon           VARCHAR2(100);
    v_desc_admon           VARCHAR2(100);
    v_plan_pago            VARCHAR2(100);
    v_frec_pago            VARCHAR2(100);
    v_cod_grupo_ec         POLIZAS.CodGrupoEc%TYPE;
    v_cod_filial           DETALLE_POLIZA.CodFilial%TYPE;
    v_cod_categoria        DETALLE_POLIZA.CodCategoria%TYPE;
    v_desc_poliza          POLIZAS.DescPoliza%TYPE;
    v_cod_agente           AGENTE_POLIZA.Cod_Agente%TYPE;
    v_nom_agente           VARCHAR2(300);
    v_fec_renovacion       POLIZAS.FecRenovacion%TYPE;
    v_sts_poliza           VARCHAR2(100);
    v_ind_factura_pol      POLIZAS.IndFacturaPol%TYPE;
    v_cod_agrupador        POLIZAS.CodAgrupador%TYPE;
    v_desc_agrupador       VARCHAR2(200);
    v_desc_subgrupo        VARCHAR2(200);
    v_desc_categoria       VARCHAR2(300);
    v_asegadherdidos       VARCHAR2(200);
    v_descasegadherdidos   VARCHAR2(300);
    v_id_ramo              VARCHAR2(500);
    v_desc_ramo            VARCHAR2(500);
    -- Función auxiliar para limpiar texto JSON
    FUNCTION limpia_json(p_valor VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN REPLACE(REPLACE(REPLACE(p_valor, '"', '\"'), CHR(10), ''), CHR(13), '');
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH('[ '), '[ ');
    WS_OBTIENE_POLIZAS_POR_ID(
        p_id_poliza     => p_id_poliza,
        p_num_pol_unico => p_num_pol_unico,
        p_codcia        => p_codcia,
        p_codempresa    => p_codempresa,
        p_resultado     => v_resultado
    );
    LOOP
        FETCH v_resultado INTO 
            v_cod_asegurado, v_nom_asegurado, v_cod_cliente, v_nom_contratante,
            v_num_pol_unico, v_id_poliza, v_idet_pol, v_fec_pago, v_fec_ini_vig,
            v_fec_fin_vig, v_id_tipo_seg, v_plan_cob, v_sts_detalle, v_cod_empresa,
            v_ind_pol_col, v_desc_tipo_seg, v_desc_plan_cob, v_desc_status,
            v_num_pol_ref, v_cod_cia, v_tipo_admon, v_desc_admon, v_plan_pago,
            v_frec_pago, v_cod_grupo_ec, v_cod_filial, v_cod_categoria, v_desc_poliza,
            v_cod_agente, v_nom_agente, v_fec_renovacion, v_sts_poliza,
            v_ind_factura_pol, v_cod_agrupador, v_desc_agrupador, v_desc_subgrupo,
            v_desc_categoria, v_asegadherdidos, v_descasegadherdidos,
            v_id_ramo,
            v_desc_ramo;
        EXIT WHEN v_resultado%NOTFOUND;
        v_temp := '{' ||
            '"COD_ASEGURADO": "' || limpia_json(v_cod_asegurado) || '",' ||
            '"NOM_ASEGURADO": "' || limpia_json(v_nom_asegurado) || '",' ||
            '"COD_CLIENTE": "' || v_cod_cliente || '",' ||
            '"NOM_CONTRATANTE": "' || limpia_json(v_nom_contratante) || '",' ||
            '"NUM_POL_UNICO": "' || limpia_json(v_num_pol_unico) || '",' ||
            '"ID_POLIZA": "' || v_id_poliza || '",' ||
            '"IDET_POL": "' || v_idet_pol || '",' ||
            '"NUM_POL_REF": "' || limpia_json(v_num_pol_ref) || '",' ||
            '"FEC_INI_VIG": "' || TO_CHAR(v_fec_ini_vig, 'YYYY-MM-DD') || '",' ||
            '"FEC_FIN_VIG": "' || TO_CHAR(v_fec_fin_vig, 'YYYY-MM-DD') || '",' ||
            '"FEC_RENOVACION": "' || TO_CHAR(v_fec_renovacion, 'YYYY-MM-DD') || '",' ||
            '"ID_TIPO_SEG": "' || limpia_json(v_id_tipo_seg) || '",' ||
            '"DESC_TIPO_SEG": "' || limpia_json(v_desc_tipo_seg) || '",' ||
            '"PLAN_COB": "' || limpia_json(v_plan_cob) || '",' ||
            '"DESC_PLAN_COB": "' || limpia_json(v_desc_plan_cob) || '",' ||
            '"STS_POLIZA": "' || limpia_json(v_sts_poliza) || '",' ||
            '"DESC_STATUS": "' || limpia_json(v_desc_status) || '",' ||
            '"STS_DETALLE": "' || limpia_json(v_sts_detalle) || '",' ||
            '"COD_EMPRESA": "' || v_cod_empresa || '",' ||
            '"IND_POL_COL": "' || limpia_json(v_ind_pol_col) || '",' ||
            '"COD_CIA": "' || v_cod_cia || '",' ||
            '"TIPO_ADMON": "' || limpia_json(v_tipo_admon) || '",' ||
            '"DESC_ADMON": "' || limpia_json(v_desc_admon) || '",' ||
            '"FEC_PAGO": "' || TO_CHAR(v_fec_pago, 'YYYY-MM-DD') || '",' ||
            '"PLAN_PAGO": "' || limpia_json(v_plan_pago) || '",' ||
            '"FREC_PAGO": "' || limpia_json(v_frec_pago) || '",' ||
            '"COD_GRUPO_EC": "' || limpia_json(v_cod_grupo_ec) || '",' ||
            '"DESC_POLIZA": "' || limpia_json(v_desc_poliza) || '",' ||
            '"COD_AGENTE": "' || limpia_json(v_cod_agente) || '",' ||
            '"NOM_AGENTE": "' || limpia_json(v_nom_agente) || '",' ||
            '"IND_FACTURA_POL": "' || limpia_json(v_ind_factura_pol) || '",' ||
            '"COD_AGRUPADOR": "' || v_cod_agrupador || '",' ||
            '"DESC_AGRUPADOR": "' || limpia_json(v_desc_agrupador) || '",' ||
            '"COD_FILIAL": "' || limpia_json(v_cod_filial) || '",' ||
            '"DESC_SUBGRUPO": "' || limpia_json(v_desc_subgrupo) || '",' ||
            '"COD_CATEGORIA": "' || limpia_json(v_cod_categoria) || '",' ||
            '"DESC_CATEGORIA": "' || limpia_json(v_desc_categoria) || '",' ||
            '"ASEGADHERIDOSPOR": "' || limpia_json(v_asegadherdidos) || '",' ||
            '"DESC_ASEGADHERIDOSPOR": "' || limpia_json(v_descasegadherdidos) || '",' ||
            '"COD_RAMO": "' || limpia_json(v_id_ramo) || '",' ||
            '"DESC_RAMO": "' || limpia_json(v_desc_ramo) || '"'  ||            
        '}';
        IF DBMS_LOB.GETLENGTH(v_json) > 2 THEN
            DBMS_LOB.WRITEAPPEND(v_json, LENGTH(', '), ', ');
        END IF;
        DBMS_LOB.WRITEAPPEND(v_json, LENGTH(v_temp), v_temp);
    END LOOP;
    CLOSE v_resultado;
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH(' ]'), ' ]');
    RETURN v_json;
EXCEPTION
    WHEN OTHERS THEN
        RETURN '{ "error": "' || REPLACE(SQLERRM, '"', '\"') || '" }';
END FN_OBTIENE_POLIZAS_POR_ID;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_OBTIENE_POLIZAS_POR_ID FOR SICAS_OC.FN_OBTIENE_POLIZAS_POR_ID
/

GRANT EXECUTE ON SICAS_OC.FN_OBTIENE_POLIZAS_POR_ID TO PUBLIC
/
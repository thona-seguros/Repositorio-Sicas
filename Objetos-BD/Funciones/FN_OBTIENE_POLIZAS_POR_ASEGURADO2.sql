create or replace FUNCTION SICAS_OC.FN_OBTIENE_POLIZAS_POR_ASEGURADO2 (
    p_codasegurado IN NUMBER,
    p_codcia       IN NUMBER DEFAULT NULL,
    p_codempresa   IN NUMBER DEFAULT NULL
) RETURN CLOB 
AS
    v_resultado SYS_REFCURSOR;
    v_json CLOB;
    v_temp CLOB;
    
    -- Variables para cada columna del resultado
    v_cod_asegurado        VARCHAR2(100);
    v_cod_cliente          POLIZAS.CodCliente%TYPE;
    v_nom_contratante      VARCHAR2(500);
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
    v_desc_tipo_seg        VARCHAR2(500);
    v_desc_plan_cob        VARCHAR2(500);
    v_desc_status          VARCHAR2(500);
    v_num_pol_ref          POLIZAS.NUMPOLREF%TYPE;
    v_cod_cia              POLIZAS.CodCia%TYPE;
    v_tipo_admon           VARCHAR2(500);
    v_desc_admon           VARCHAR2(500);
    v_plan_pago            VARCHAR2(500);
    v_frec_pago            VARCHAR2(500);
    v_cod_grupo_ec         POLIZAS.CodGrupoEc%TYPE;
    v_cod_filial           VARCHAR2(500);
    v_cod_categoria        DETALLE_POLIZA.CodCategoria%TYPE;
    v_desc_poliza          POLIZAS.DescPoliza%TYPE;
    v_cod_agente           AGENTE_POLIZA.Cod_Agente%TYPE;
    v_nom_agente           VARCHAR2(500);
    v_fec_renovacion       POLIZAS.FecRenovacion%TYPE;
    v_sts_poliza           VARCHAR2(500);
    v_ind_factura_pol      POLIZAS.IndFacturaPol%TYPE;
    v_cod_agrupador        POLIZAS.CodAgrupador%TYPE;
    v_desc_agrupador       VARCHAR2(500);
    v_desc_subgrupo        VARCHAR2(500);
    v_desc_categoria       VARCHAR2(500);
    v_asegadherdidos       VARCHAR2(500);
    v_descasegadherdidos   VARCHAR2(500);
    v_id_ramo              VARCHAR2(500);
    v_desc_ramo            VARCHAR2(500);
    
BEGIN
    -- Crear un CLOB temporal para almacenar el JSON
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH('[ '), '[ ');
    
    -- Llamar al procedimiento para obtener el cursor con los datos
    WS_OBTIENE_POLIZAS_ASEGURADO2(
        p_codasegurado => p_codasegurado,
        p_codcia      => p_codcia,
        p_codempresa  => p_codempresa,
        p_resultado => v_resultado
    );
    
    -- Recorrer el cursor y construir el JSON manualmente
    LOOP
        FETCH v_resultado INTO 
            v_cod_asegurado,
            v_cod_cliente,
            v_nom_contratante,
            v_num_pol_unico,
            v_id_poliza,
            v_idet_pol,
            v_fec_pago,
            v_fec_ini_vig,
            v_fec_fin_vig,
            v_id_tipo_seg,
            v_plan_cob,
            v_sts_detalle,
            v_cod_empresa,
            v_ind_pol_col,
            v_desc_tipo_seg,
            v_desc_plan_cob,
            v_desc_status,
            v_num_pol_ref,
            v_cod_cia,
            v_tipo_admon,
            v_desc_admon,
            v_plan_pago,
            v_frec_pago,
            v_cod_grupo_ec,
            v_cod_filial,
            v_cod_categoria,
            v_desc_poliza,
            v_cod_agente,
            v_nom_agente,
            v_fec_renovacion,
            v_sts_poliza,
            v_ind_factura_pol,
            v_cod_agrupador,
            v_desc_agrupador,
            v_desc_subgrupo,
            v_desc_categoria,
            v_asegadherdidos,
            v_descasegadherdidos,
            v_id_ramo,
            v_desc_ramo;
        EXIT WHEN v_resultado%NOTFOUND;
        
        v_temp := '{"COD_ASEGURADO": ' || COALESCE('"' || REPLACE(REPLACE(v_cod_asegurado, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"COD_CLIENTE": ' || COALESCE(v_cod_cliente, 'null') ||
          ',"NOM_CONTRATANTE": ' || COALESCE('"' || REPLACE(REPLACE(v_nom_contratante, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"NUM_POL_UNICO": ' || COALESCE('"' || REPLACE(REPLACE(v_num_pol_unico, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"ID_POLIZA": ' || COALESCE(v_id_poliza, 'null') ||
          ',"IDET_POL": ' || COALESCE(v_idet_pol, 'null') ||
          ',"NUM_POL_REF": ' || COALESCE('"' || REPLACE(REPLACE(v_num_pol_ref, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"FEC_INI_VIG": ' || COALESCE('"' || TO_CHAR(v_fec_ini_vig, 'YYYY-MM-DD') || '"', 'null') ||
          ',"FEC_FIN_VIG": ' || COALESCE('"' || TO_CHAR(v_fec_fin_vig, 'YYYY-MM-DD') || '"', 'null') ||
          ',"FEC_RENOVACION": ' || COALESCE('"' || TO_CHAR(v_fec_renovacion, 'YYYY-MM-DD') || '"', 'null') ||
          ',"ID_TIPO_SEG": ' || COALESCE('"' || REPLACE(REPLACE(v_id_tipo_seg, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"DESC_TIPO_SEG": ' || COALESCE('"' || REPLACE(REPLACE(v_desc_tipo_seg, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"PLAN_COB": ' || COALESCE('"' || REPLACE(REPLACE(v_plan_cob, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"DESC_PLAN_COB": ' || COALESCE('"' || REPLACE(REPLACE(v_desc_plan_cob, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"STS_POLIZA": ' || COALESCE('"' || REPLACE(REPLACE(v_sts_poliza, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"DESC_STATUS": ' || COALESCE('"' || REPLACE(REPLACE(v_desc_status, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"STS_DETALLE": ' || COALESCE('"' || REPLACE(REPLACE(v_sts_detalle, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"COD_EMPRESA": ' || COALESCE(v_cod_empresa, 'null') ||
          ',"IND_POL_COL": ' || COALESCE('"' || REPLACE(REPLACE(v_ind_pol_col, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"COD_CIA": ' || COALESCE(v_cod_cia, 'null') ||
          ',"TIPO_ADMON": ' || COALESCE('"' || REPLACE(REPLACE(v_tipo_admon, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"DESC_ADMON": ' || COALESCE('"' || REPLACE(REPLACE(v_desc_admon, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"FEC_PAGO": ' || COALESCE('"' || TO_CHAR(v_fec_pago, 'YYYY-MM-DD') || '"', 'null') ||
          ',"PLAN_PAGO": ' || COALESCE('"' || REPLACE(REPLACE(v_plan_pago, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"FREC_PAGO": ' || COALESCE('"' || REPLACE(REPLACE(v_frec_pago, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"COD_GRUPO_EC": ' || COALESCE('"' || REPLACE(REPLACE(v_cod_grupo_ec, CHR(10), ''), CHR(13), '') || '"', 'null') ||                
          ',"DESC_POLIZA": ' || COALESCE('"' || REPLACE(REPLACE(v_desc_poliza, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"COD_AGENTE": ' || COALESCE('"' || REPLACE(REPLACE(v_cod_agente, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"NOM_AGENTE": ' || COALESCE('"' || REPLACE(REPLACE(v_nom_agente, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"IND_FACTURA_POL": ' || COALESCE('"' || REPLACE(REPLACE(v_ind_factura_pol, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"COD_AGRUPADOR": ' || COALESCE('"' || REPLACE(REPLACE(v_cod_agrupador, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"DESC_AGRUPADOR": ' || COALESCE('"' || REPLACE(REPLACE(v_desc_agrupador, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"COD_FILIAL": ' || COALESCE('"' || REPLACE(REPLACE(v_cod_filial, CHR(10), ''), CHR(13), '') || '"', 'null') ||          
          ',"DESC_SUBGRUPO": ' || COALESCE('"' || REPLACE(REPLACE(v_desc_subgrupo, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"COD_CATEGORIA": ' || COALESCE('"' || REPLACE(REPLACE(v_cod_categoria, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"DESC_CATEGORIA": ' || COALESCE('"' || REPLACE(REPLACE(v_desc_categoria, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"ASEGADHERIDOSPOR": ' || COALESCE('"' || REPLACE(REPLACE(v_asegadherdidos, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"DESC_ASEGADHERIDOSPOR": ' || COALESCE('"' || REPLACE(REPLACE(v_descasegadherdidos, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"COD_RAMO": ' || COALESCE('"' || REPLACE(REPLACE(v_id_ramo, CHR(10), ''), CHR(13), '') || '"', 'null') ||
          ',"DESC_RAMO": ' || COALESCE('"' || REPLACE(REPLACE(v_desc_ramo, CHR(10), ''), CHR(13), '') || '"', 'null') 
       || '}'; 
        
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
END FN_OBTIENE_POLIZAS_POR_ASEGURADO2;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_OBTIENE_POLIZAS_POR_ASEGURADO2 FOR SICAS_OC.FN_OBTIENE_POLIZAS_POR_ASEGURADO2
/

GRANT EXECUTE ON SICAS_OC.FN_OBTIENE_POLIZAS_POR_ASEGURADO2 TO PUBLIC
/
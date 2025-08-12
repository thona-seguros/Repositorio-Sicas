prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_release=>'23.2.0'
,p_default_workspace_id=>1600423834333804
,p_default_application_id=>125
,p_default_id_offset=>35097571442794718
,p_default_owner=>'SICAS_OC'
);
end;
/
 
prompt APPLICATION 125 - Siniestros
--
-- Application Export:
--   Application:     125
--   Name:            Siniestros
--   Date and Time:   16:41 Wednesday August 6, 2025
--   Exported By:     OCOLMENARES
--   Flashback:       0
--   Export Type:     Page Export
--   Manifest
--     PAGE: 1031
--   Manifest End
--   Version:         23.2.0
--   Instance ID:     709450366953385
--

begin
null;
end;
/
prompt --application/pages/delete_01031
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>1031);
end;
/
prompt --application/pages/page_01031
begin
wwv_flow_imp_page.create_page(
 p_id=>1031
,p_name=>'InfoSiniestroDeAsegurado'
,p_alias=>'INFOSINIESTRODEASEGURADO'
,p_page_mode=>'MODAL'
,p_step_title=>unistr('Información de Siniestros')
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#APP_FILES#thona_style_css.css'
,p_step_template=>wwv_flow_imp.id(162591094572056034)
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'03'
,p_last_updated_by=>'OCOLMENARES'
,p_last_upd_yyyymmddhh24miss=>'20250806161411'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(53167653967504632)
,p_name=>'SiniestrosAsegurado'
,p_template=>wwv_flow_imp.id(162621525695056100)
,p_display_sequence=>60
,p_region_css_classes=>'full-width-report'
,p_region_template_options=>'#DEFAULT#:t-Form--stretchInputs'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'FUNC_BODY_RETURNING_SQL'
,p_function_body_language=>'PLSQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_sql CLOB;',
'BEGIN',
'    IF :P1031_TIPO_CONSULTA = ''COD_ASEGURADO'' THEN',
'        v_sql := ''',
'            SELECT ',
'                TO_CHAR(S.IdSiniestro) AS SINIESTRO,',
'                S.COD_ASEGURADO AS COD_ASEGURADO,',
'                TO_CHAR(S.Fec_Ocurrencia, ''''DD/MM/YYYY'''') AS FECHA,',
'                S.MOTIVO_DE_SINIESTRO || '''' - '''' || SCG.CAGE_VALOR_LARGO AS MOTIVO',
'            FROM ',
'                SINIESTRO S',
'            LEFT JOIN ',
'                SAI_CAT_GENERAL SCG',
'                ON SCG.CAGE_ID_CONCEP_ALF = S.MOTIVO_DE_SINIESTRO',
'                AND SCG.CAGE_CD_CATALOGO = 1',
'                AND SCG.CAGE_CD_CLAVE_SEG > 0',
'                AND SCG.CAGE_CD_CLAVE_TER = 1',
'                AND SCG.CAGE_NOM_CATALOGO = ''''CAUSA DE SINIESTRO''''',
'                AND SCG.CAGE_VALOR_CORTO = ''''CAUSIN''''',
'            WHERE ',
'                S.IDPOLIZA = ''||:P1031_IDPOLIZA||''',
'                AND S.COD_ASEGURADO = TO_NUMBER(''||:P1031_COD_ASEGURADO||'')',
'                AND S.STS_SINIESTRO IN (''''EMI'''', ''''PGP'''', ''''PGT'''')',
'                AND S.FEC_OCURRENCIA >= ADD_MONTHS(SYSDATE, -60)',
'            ORDER BY ',
'                S.IDSINIESTRO'';',
'',
'    ELSIF :P1031_TIPO_CONSULTA = ''CURP'' THEN',
'        v_sql := ''',
'            SELECT ',
'                TO_CHAR(S.IdSiniestro) AS SINIESTRO,',
'                S.COD_ASEGURADO AS COD_ASEGURADO,',
'                TO_CHAR(S.Fec_Ocurrencia, ''''DD/MM/YYYY'''') AS FECHA,',
'                S.MOTIVO_DE_SINIESTRO || '''' - '''' || SCG.CAGE_VALOR_LARGO AS MOTIVO',
'            FROM ',
'                SINIESTRO S',
'            LEFT JOIN ',
'                SAI_CAT_GENERAL SCG',
'                ON SCG.CAGE_ID_CONCEP_ALF = S.MOTIVO_DE_SINIESTRO',
'                AND SCG.CAGE_CD_CATALOGO = 1',
'                AND SCG.CAGE_CD_CLAVE_SEG > 0',
'                AND SCG.CAGE_CD_CLAVE_TER = 1',
'                AND SCG.CAGE_NOM_CATALOGO = ''''CAUSA DE SINIESTRO''''',
'                AND SCG.CAGE_VALOR_CORTO = ''''CAUSIN''''',
'            JOIN ',
'                ASEGURADO A',
'                ON A.COD_ASEGURADO = S.COD_ASEGURADO',
'            JOIN ',
'                PERSONA_NATURAL_JURIDICA PNJ',
'                ON PNJ.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION',
'                AND PNJ.NUM_DOC_IDENTIFICACION = A.NUM_DOC_IDENTIFICACION',
'            WHERE ',
'                S.IDPOLIZA = ''||:P1031_IDPOLIZA||''',
'                AND PNJ.CURP LIKE ''''%''||:P1031_CURP||''%'''' ',
'                AND S.STS_SINIESTRO IN (''''EMI'''', ''''PGP'''', ''''PGT'''')',
'                AND S.FEC_OCURRENCIA >= ADD_MONTHS(SYSDATE, -60)',
'            ORDER BY ',
'                S.IDSINIESTRO'';',
'',
'    ELSIF :P1031_TIPO_CONSULTA = ''RFC'' THEN',
'        v_sql := ''',
'            SELECT ',
'                TO_CHAR(S.IdSiniestro) AS SINIESTRO,',
'                S.COD_ASEGURADO AS COD_ASEGURADO,',
'                TO_CHAR(S.Fec_Ocurrencia, ''''DD/MM/YYYY'''') AS FECHA,',
'                S.MOTIVO_DE_SINIESTRO || '''' - '''' || SCG.CAGE_VALOR_LARGO AS MOTIVO',
'            FROM ',
'                SINIESTRO S',
'            LEFT JOIN ',
'                SAI_CAT_GENERAL SCG',
'                ON SCG.CAGE_ID_CONCEP_ALF = S.MOTIVO_DE_SINIESTRO',
'                AND SCG.CAGE_CD_CATALOGO = 1',
'                AND SCG.CAGE_CD_CLAVE_SEG > 0',
'                AND SCG.CAGE_CD_CLAVE_TER = 1',
'                AND SCG.CAGE_NOM_CATALOGO = ''''CAUSA DE SINIESTRO''''',
'                AND SCG.CAGE_VALOR_CORTO = ''''CAUSIN''''',
'            WHERE ',
'                S.IDPOLIZA = ''||:P1031_IDPOLIZA||''',
'                AND S.RFC_ASEGURADO LIKE ''''%''||:P1031_RFC||''%'''' ',
'                AND S.STS_SINIESTRO IN (''''EMI'''', ''''PGP'''', ''''PGT'''')',
'                AND S.FEC_OCURRENCIA >= ADD_MONTHS(SYSDATE, -60)',
'            ORDER BY ',
'                S.IDSINIESTRO'';',
'',
'    ELSE',
unistr('        v_sql := ''SELECT ''''Tipo de consulta no válido'''' AS SINIESTRO,'),
'        NULL AS COD_ASEGURADO,',
'        NULL AS FECHA,',
'        NULL AS MOTIVO',
'        FROM DUAL'';',
'    END IF;',
'',
'    RETURN v_sql;',
'END;',
''))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P1031_TIPO_CONSULTA,P1031_IDPOLIZA,P1031_COD_ASEGURADO,P1031_CURP,P1031_RFC'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(162709754967056251)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(53168909562504645)
,p_query_column_id=>1
,p_column_alias=>'SINIESTRO'
,p_column_display_sequence=>10
,p_column_heading=>'Siniestro'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(53904194861257805)
,p_query_column_id=>2
,p_column_alias=>'COD_ASEGURADO'
,p_column_display_sequence=>20
,p_column_heading=>unistr('Código Asegurado')
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(53169096984504646)
,p_query_column_id=>3
,p_column_alias=>'FECHA'
,p_column_display_sequence=>30
,p_column_heading=>'Fecha de Siniestro'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(53169151578504647)
,p_query_column_id=>4
,p_column_alias=>'MOTIVO'
,p_column_display_sequence=>40
,p_column_heading=>'Motivo'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(53904290498257806)
,p_plug_name=>'Mensaje'
,p_plug_display_sequence=>40
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'    <span class="title-thona">&P1031_ASEGURADO.</span><br>',
'    <span class="desc-thona">&P1031_SINIESTROS_PAS.</span>',
'</p>',
'<br>'))
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P1031_SINIESTROS_PAS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(53905534710257819)
,p_name=>'CoincidenciaFonetica'
,p_template=>wwv_flow_imp.id(162621525695056100)
,p_display_sequence=>80
,p_region_css_classes=>'full-width-report'
,p_region_template_options=>'#DEFAULT#:t-Form--stretchInputs'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT  TO_CHAR(S.IdSiniestro) AS SINIESTRO,',
'        S.COD_ASEGURADO AS COD_ASEGURADO,',
'        TO_CHAR(S.Fec_Ocurrencia, ''DD/MM/YYYY'') AS FECHA,',
'        S.MOTIVO_DE_SINIESTRO||''-''||SCG.CAGE_VALOR_LARGO AS MOTIVO',
'    FROM ',
'        SINIESTRO S',
'    JOIN ',
'        SAI_CAT_GENERAL SCG',
'        ON SCG.CAGE_ID_CONCEP_ALF = S.MOTIVO_DE_SINIESTRO',
'    JOIN ASEGURADO A',
'        ON A.COD_ASEGURADO = S.COD_ASEGURADO',
'    JOIN PERSONA_NATURAL_JURIDICA PNJ',
'        ON PNJ.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION',
'        AND PNJ.NUM_DOC_IDENTIFICACION = A.NUM_DOC_IDENTIFICACION',
'    WHERE UTL_MATCH.JARO_WINKLER_SIMILARITY(',
'              OC_ASEGURADO.NOMBRE_ASEGURADO(1, 1, :P1031_COD_ASEGURADO),',
'              PNJ.NOMBRE || '' '' || PNJ.APELLIDO_PATERNO || '' '' || PNJ.APELLIDO_MATERNO',
'          ) >= 80',
'      AND PNJ.FECNACIMIENTO = OC_ASEGURADO.FECHA_NACIMIENTO(1, 1,:P1031_COD_ASEGURADO)',
'      AND S.STS_SINIESTRO IN (''EMI'', ''PGP'', ''PGT'')',
'      AND S.IDPOLIZA = :P1031_IDPOLIZA',
'      AND A.COD_ASEGURADO != :P1031_COD_ASEGURADO',
'      AND S.FEC_OCURRENCIA >= ADD_MONTHS(SYSDATE, -60);'))
,p_display_when_condition=>'P1031_UNDERAGE'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P1031_TIPO_CONSULTA,P1031_IDPOLIZA,P1031_COD_ASEGURADO,P1031_CURP,P1031_RFC'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(162709754967056251)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(53905674024257820)
,p_query_column_id=>1
,p_column_alias=>'SINIESTRO'
,p_column_display_sequence=>10
,p_column_heading=>'Siniestro'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(53905759588257821)
,p_query_column_id=>2
,p_column_alias=>'COD_ASEGURADO'
,p_column_display_sequence=>20
,p_column_heading=>unistr('Código Asegurado')
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(53905820044257822)
,p_query_column_id=>3
,p_column_alias=>'FECHA'
,p_column_display_sequence=>30
,p_column_heading=>'Fecha'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(53905978922257823)
,p_query_column_id=>4
,p_column_alias=>'MOTIVO'
,p_column_display_sequence=>40
,p_column_heading=>'Motivo'
,p_use_as_row_header=>'N'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(53906201883257826)
,p_plug_name=>'Mensaje_UNDERAGE'
,p_plug_display_sequence=>70
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'    <span class="title-thona">&P1031_UNDERAGE.</span>',
'</p>',
'<br>'))
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P1031_UNDERAGE'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53167443229504630)
,p_name=>'P1031_TIPO_CONSULTA'
,p_item_sequence=>10
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53167522268504631)
,p_name=>'P1031_SINIESTROS_PAS'
,p_item_sequence=>20
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53168243541504638)
,p_name=>'P1031_IDPOLIZA'
,p_item_sequence=>90
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53168321821504639)
,p_name=>'P1031_COD_ASEGURADO'
,p_item_sequence=>100
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53168646463504642)
,p_name=>'P1031_CURP'
,p_item_sequence=>120
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53168761172504643)
,p_name=>'P1031_RFC'
,p_item_sequence=>130
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53904353281257807)
,p_name=>'P1031_ASEGURADO'
,p_item_sequence=>110
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ''ASEGURADO ''||:P1031_COD_ASEGURADO||'' - ''||OC_ASEGURADO.NOMBRE_ASEGURADO(1,1,:P1031_COD_ASEGURADO)',
'    FROM DUAL;'))
,p_item_default_type=>'SQL_QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_display_when=>'P1031_TIPO_CONSULTA'
,p_display_when2=>'COD_ASEGURADO'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53906184393257825)
,p_name=>'P1031_UNDERAGE'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done

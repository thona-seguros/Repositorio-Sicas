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
,p_default_application_id=>112
,p_default_id_offset=>92206444216103496
,p_default_owner=>'SICAS_OC'
);
end;
/
 
prompt APPLICATION - Personas - Sicas
--
-- Application Export:
--   Application:     112
--   Name:            Personas - Sicas
--   Date and Time:   10:21 Monday July 27, 2026
--   Exported By:     LREYNOSO
--   Flashback:       0
--   Export Type:     Page Export
--   Manifest
--     PAGE: 51
--   Manifest End
--   Version:         23.2.0
--   Instance ID:     709450366953385
--

begin
null;
end;
/
prompt --application/pages/delete_00051
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>51);
end;
/
prompt --application/pages/page_00051
begin
wwv_flow_imp_page.create_page(
 p_id=>51
,p_name=>unistr('Persona Natural Jur\00EDdica')
,p_alias=>unistr('PERSONA-NATURAL-JUR\00CDDICA')
,p_step_title=>unistr('Persona Natural Jur\00EDdica')
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'02'
,p_last_updated_by=>'LREYNOSO'
,p_last_upd_yyyymmddhh24miss=>'20260710132917'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(403708520904860542)
,p_plug_name=>unistr('Persona Natural Jur\00EDdica')
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(136252151508393174)
,p_plug_display_sequence=>10
,p_query_type=>'TABLE'
,p_query_table=>'PERSONA_NATURAL_JURIDICA'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128726423289357467)
,p_button_sequence=>110
,p_button_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_button_name=>'P50_GENRFC'
,p_button_static_id=>'btn_rfc'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--pillEnd:t-Button--gapRight:t-Button--gapTop'
,p_button_template_id=>wwv_flow_imp.id(136325082878393340)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Genera RFC'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'N'
,p_grid_column_span=>2
,p_grid_column=>11
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128726893204357478)
,p_button_sequence=>260
,p_button_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_button_name=>'P51_BTNCOLRES'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(136325146319393340)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'CP y Colonias'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>2
,p_button_comment=>'Consulta y Captura de CP y Colonias'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128727270736357478)
,p_button_sequence=>270
,p_button_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_button_name=>'BTNRefreshColonias'
,p_button_static_id=>'BTNRefreshColonias'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(136324421051393332)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Btnrefreshcolonias'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
,p_grid_new_row=>'N'
,p_grid_new_column=>'N'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128727630714357478)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(136325082878393340)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Aplicar Cambios'
,p_button_position=>'CHANGE'
,p_button_condition=>'P51_TIPO_DOC_IDENTIFICACION'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128728003704357478)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(136325082878393340)
,p_button_image_alt=>'Cancelar'
,p_button_position=>'CLOSE'
,p_button_redirect_url=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.:::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128728448915357479)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(136325082878393340)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Crear'
,p_button_position=>'CREATE'
,p_button_condition=>'P51_TIPO_DOC_IDENTIFICACION'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128728866108357479)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_button_name=>'DELETE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(136325082878393340)
,p_button_image_alt=>'Eliminar'
,p_button_position=>'DELETE'
,p_button_execute_validations=>'N'
,p_confirm_message=>'&APP_TEXT$DELETE_MSG!RAW.'
,p_confirm_style=>'danger'
,p_button_condition=>'P51_TIPO_DOC_IDENTIFICACION'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(128798149719357606)
,p_branch_action=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(128797713152357606)
,p_branch_name=>'PageLoad28_CrearColonias'
,p_branch_action=>'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::P28_CODPAIS,P28_CODCIUDAD,P28_CODESTADO,P28_CODMUNICIPIO,P28_CODIGO_POSTAL:&P51_CODPAISRES.,&P51_CODDISTRES.,&P51_CODPROVRES.,&P51_CODCORRRES.,&P51_CODPOSRES.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'BEFORE_COMPUTATION'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(128726893204357478)
,p_branch_sequence=>11
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(356330186929625365)
,p_name=>'P51_RFCGENERADO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'RFC Generado'
,p_source=>'RFCGENERADO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_grid_column_css_classes=>'u-textCenter'
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>unistr('RFC Generado de forma autom\00E1tica, en caso de no coincidir, solicitar la correcci\00F3n al Oficial de Cumplimiento')
,p_inline_help_text=>unistr('RFC Generado de forma autom\00E1tica')
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(356330263259625366)
,p_name=>'P51_ISVALIDPLD'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>710
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'ISVALIDPLD'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(356330407199625367)
,p_name=>'P51_FECINSERT'
,p_source_data_type=>'DATE'
,p_item_sequence=>720
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'FECINSERT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(356330486188625368)
,p_name=>'P51_FECVALIDPLD'
,p_source_data_type=>'DATE'
,p_item_sequence=>730
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'FECVALIDPLD'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(394248953346623489)
,p_name=>'P51_REPLEGAL'
,p_item_sequence=>400
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'Es Representante Legal?'
,p_display_as=>'NATIVE_SINGLE_CHECKBOX'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(394349793905820954)
,p_name=>'P51_RFCDEPASO'
,p_item_sequence=>410
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Rfcdepaso'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403463266484837478)
,p_name=>'P51_C_IDCLIENTEUNICO'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'   	SELECT MAX(IDUNICOPERSONA)',
'   	FROM PERSONAS_IDUNICOPERSONA',
'   WHERE TIPO_DOC_IDENTIFICACION =  :P51_TIPO_DOC_IDENTIFICACION',
'     AND NUM_DOC_IDENTIFICACION = :P51_NUM_DOC_IDENTIFICACION',
'     AND TIPO_ID_TRIBUTARIA = :P51_TIPO_ID_TRIBUTARIA',
'     AND NUM_TRIBUTARIO = :P51_NUM_TRIBUTARIO;',
''))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>unistr('ID Cliente \00DAnico')
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403463380613837479)
,p_name=>'P51_CDESCREGIMENFISC'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_default=>'SELECT OC_CAT_REGIMEN_FISCAL.FUN_NOMBRE_REGFIS(:P51_IDREGFISSAT) FROM DUAL;'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>unistr('Descripci\00F3n')
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403712687204860616)
,p_name=>'P51_TIPO_DOC_IDENTIFICACION'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'Tipo Documento '
,p_source=>'TIPO_DOC_IDENTIFICACION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'LOV_TIPO_IDENTIFICACION1'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CODVALOR, CODVALOR || ''-'' || DESCVALLST DESCRIPCION',
'FROM VALORES_DE_LISTAS',
'WHERE 1 = 1',
'AND CODLISTA = ''TIPODOCU''',
'ORDER BY DESCVALLST ASC'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_cMaxlength=>6
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'Y'
,p_attribute_06=>'0'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403713172442860630)
,p_name=>'P51_NUM_DOC_IDENTIFICACION'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_is_primary_key=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>unistr('N\00FAmero de Documento')
,p_source=>'NUM_DOC_IDENTIFICACION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>20
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
,p_attribute_06=>'UPPER'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403713523978860635)
,p_name=>'P51_NOMBRE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>unistr('Nombres / Raz\00F3n Social')
,p_source=>'NOMBRE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>200
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
,p_attribute_06=>'UPPER'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403713880116860640)
,p_name=>'P51_APELLIDO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>590
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'APELLIDO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403714240047860640)
,p_name=>'P51_APECASADA'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>600
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'APECASADA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403714630161860641)
,p_name=>'P51_SEXO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_default=>'N'
,p_prompt=>'Sexo'
,p_source=>'SEXO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'LOV_SEXO1'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--ESTA LOV SE CREA ASI YA QUE EL SEXO EN PERSONA_NATURAL_JURIDICA ES VARCHAR2(1)',
'--Y EN LAS LISTAS DE VALORES EL CODIGO ES DE 3 CARACTERES',
'SELECT ''M'' CODIGO, ''M - MASCULINO'' TIPO_SEXO',
'FROM DUAL',
'UNION',
'SELECT ''F'' CODIGO, ''F - FEMENINO'' TIPO_SEXO',
'FROM DUAL',
'UNION',
'SELECT ''N'' CODIGO, ''N - NO APLICA'' TIPO_SEXO',
'FROM DUAL',
';'))
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>1
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403715079873860641)
,p_name=>'P51_ESTADOCIVIL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_default=>'N'
,p_prompt=>'Estado Civil'
,p_source=>'ESTADOCIVIL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'LOV_ESTADO_CIVIL1'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--ESTA LOV SE CONSTRUYE ASI, YA QUE EL CAMPO DE ESTADO CIVIL EN PERSONA_NATURAL_JURIDICA ES SOLO DE VARCHAR2(1)',
'--Y LOS DATOS QUE SE TIENEN EN LISTAS DE VALRES SON CODIGOS DE 3 CARACTERES',
'/*',
'SELECT CODVALOR, CODVALOR || '' - '' || DESCVALLST ESTADO_CIVIL',
'FROM VALORES_DE_LISTAS',
'WHERE 1 = 1',
'AND CODLISTA = ''EDOCIVIL''',
';',
'*/',
'SELECT ''S'' CODIGO, ''S - SOLTERO'' ESTADO_CIVIL',
'FROM DUAL',
'UNION',
'SELECT ''C'' CODIGO, ''C - CASADO'' ESTADO_CIVIL',
'FROM DUAL',
'UNION',
'SELECT ''V'' CODIGO, ''V - VIUDO'' ESTADO_CIVIL',
'FROM DUAL',
'UNION',
'SELECT ''D'' CODIGO, ''D - DIVORCIADO'' ESTADO_CIVIL',
'FROM DUAL',
'UNION',
'SELECT ''U'' CODIGO, ''U - UNIDO'' ESTADO_CIVIL',
'FROM DUAL',
'UNION',
'SELECT ''N'' CODIGO, ''N - NO APLICA'' ESTADO_CIVIL',
'FROM DUAL',
';'))
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>1
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403715446130860643)
,p_name=>'P51_FECNACIMIENTO'
,p_source_data_type=>'DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>unistr('Fecha Nacimiento/Fecha Constituci\00F3n')
,p_format_mask=>'DD/MM/YYYY'
,p_source=>'FECNACIMIENTO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'POPUP'
,p_attribute_03=>'NONE'
,p_attribute_06=>'NONE'
,p_attribute_09=>'N'
,p_attribute_11=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403715848117860643)
,p_name=>'P51_DIRECRES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>unistr('Direcci\00F3n')
,p_source=>'DIRECRES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>250
,p_cHeight=>4
,p_tag_attributes=>'style="text-transform:uppercase"'
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403716259313860644)
,p_name=>'P51_CODPAISRES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CodPais',
'FROM APARTADO_POSTAL',
'WHERE Codigo_Postal = :P51_CODCORRRES;'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>unistr('Pa\00EDs')
,p_source=>'CODPAISRES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CODPAIS||'' - ''||DESCPAIS  PAIS,CODPAIS',
'FROM PAIS',
'WHERE CODPAIS = (SELECT CodPais',
'FROM APARTADO_POSTAL',
'WHERE Codigo_Postal = :P51_CODPOSRES)'))
,p_lov_cascade_parent_items=>'P51_CODPOSRES'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403716614839860644)
,p_name=>'P51_CODPROVRES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'Estado o Provincia'
,p_source=>'CODPROVRES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CODESTADO||'' - ''||DESCESTADO ESTADO,CODESTADO',
'     FROM PROVINCIA',
'    WHERE CODESTADO = (SELECT CODESTADO',
'FROM APARTADO_POSTAL',
'WHERE Codigo_Postal = :P51_CODPOSRES)'))
,p_lov_cascade_parent_items=>'P51_CODPAISRES,P51_CODPOSRES'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403717042953860646)
,p_name=>'P51_CODDISTRES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'Ciudad o Distrito'
,p_source=>'CODDISTRES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  SELECT CodCiudad || '' - ''||DescCiudad as DescCiudad, CodCiudad',
'    FROM DISTRITO',
'    WHERE CodPais  = REPLACE(SUBSTR(:P51_CODPAISRES,0,3),'' '','''')',
'      AND CodEstado = REPLACE(SUBSTR(:P51_CODPROVRES,0,3),'' '','''')',
'      AND CODCIUDAD = (SELECT CODCIUDAD',
'FROM APARTADO_POSTAL',
'WHERE Codigo_Postal = :P51_CODPOSRES);'))
,p_lov_cascade_parent_items=>'P51_CODPAISRES,P51_CODPROVRES,P51_CODPOSRES'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403717435461860646)
,p_name=>'P51_CODCORRRES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>unistr('Municipio o Delegaci\00F3n')
,p_source=>'CODCORRRES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' SELECT CodMunicipio || '' - ''|| DescMunicipio as DescMunicipio , CodMunicipio',
'   FROM CORREGIMIENTO',
'  WHERE CodPais       = SUBSTR(:P51_CODPAISRES,0,3)',
'      AND CodEstado     = SUBSTR(:P51_CODPROVRES,0,3)',
'      AND CodCiudad     = SUBSTR(:p51_CODDISTRES,0,3)',
'      AND CodMunicipio = (SELECT CodMunicipio',
'FROM APARTADO_POSTAL',
'WHERE Codigo_Postal = :P51_CODPOSRES);'))
,p_lov_cascade_parent_items=>'P51_CODPOSRES,P51_CODPAISRES,P51_CODPROVRES,P51_CODDISTRES'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403717811500860647)
,p_name=>'P51_ZIPRES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>440
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'ZIPRES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403718285361860647)
,p_name=>'P51_TELRES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>unistr('No. Tel\00E9fonos')
,p_source=>'TELRES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>30
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEL'
,p_attribute_05=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403718676406860649)
,p_name=>'P51_EMPRESATRAB'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>460
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'EMPRESATRAB'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403719014826860649)
,p_name=>'P51_DIRECOFI'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>470
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'DIRECOFI'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403719433243860650)
,p_name=>'P51_CODPAISOFI'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>500
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'CODPAISOFI'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403719827700860652)
,p_name=>'P51_CODPROVOFI'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>510
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'CODPROVOFI'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403720194270860654)
,p_name=>'P51_CODDISTOFI'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>520
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'CODDISTOFI'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403720635835860654)
,p_name=>'P51_CODCORROFI'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>530
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'CODCORROFI'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403721025481860655)
,p_name=>'P51_ZIPOFI'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>580
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'ZIPOFI'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403721452609860657)
,p_name=>'P51_TELOFI'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>550
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'TELOFI'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403721810166860657)
,p_name=>'P51_FAXOFI'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>570
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'FAXOFI'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403722281239860658)
,p_name=>'P51_EMAIL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>340
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'E-mail'
,p_source=>'EMAIL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>150
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403722628771860658)
,p_name=>'P51_FECSTS'
,p_source_data_type=>'DATE'
,p_item_sequence=>610
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_default=>'TRUNC(SYSDATE)'
,p_item_default_type=>'EXPRESSION'
,p_item_default_language=>'PLSQL'
,p_prompt=>'Fecha Alta'
,p_source=>'FECSTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'POPUP'
,p_attribute_03=>'NONE'
,p_attribute_06=>'NONE'
,p_attribute_09=>'N'
,p_attribute_11=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403723018183860663)
,p_name=>'P51_FECINGRESO'
,p_source_data_type=>'DATE'
,p_item_sequence=>380
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_default=>'TRUNC(SYSDATE)'
,p_item_default_type=>'EXPRESSION'
,p_item_default_language=>'PLSQL'
,p_prompt=>'Fecha Ingreso'
,p_source=>'FECINGRESO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403723398888860665)
,p_name=>'P51_CEDULA'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>450
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'CEDULA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403723787923860666)
,p_name=>'P51_TIPO_ID_TRIBUTARIA'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_default=>'RFC'
,p_prompt=>'Tipo Documento Fiscal'
,p_source=>'TIPO_ID_TRIBUTARIA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'LOV_TIPO_IDENTIFICACION1'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CODVALOR, CODVALOR || ''-'' || DESCVALLST DESCRIPCION',
'FROM VALORES_DE_LISTAS',
'WHERE 1 = 1',
'AND CODLISTA = ''TIPODOCU''',
'ORDER BY DESCVALLST ASC'))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'Y'
,p_attribute_06=>'0'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403724216037860668)
,p_name=>'P51_NUM_TRIBUTARIO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'No. Documento Fiscal'
,p_source=>'NUM_TRIBUTARIO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>20
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403724618152860668)
,p_name=>'P51_CODIGOZIP'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>620
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'CODIGOZIP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403725021948860669)
,p_name=>'P51_CODPOSRES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>unistr('C\00F3digo Postal')
,p_format_mask=>'999G999G999G999G999G999G990'
,p_source=>'CODPOSRES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_AUTO_COMPLETE'
,p_named_lov=>'LOV_CODIGOPOSTAL1'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT Codigo_Postal, Codigo_Postal || '' - '' || Descripcion_Postal CodPostalDesc',
'FROM APARTADO_POSTAL',
'ORDER BY Codigo_Postal;'))
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'CONTAINS_IGNORE'
,p_attribute_04=>'Y'
,p_attribute_05=>'10'
,p_attribute_09=>'1'
,p_attribute_10=>'Y'
);
end;
/
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403725403309860671)
,p_name=>'P51_CODASENRES'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>630
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'CODASENRES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403725802753860671)
,p_name=>'P51_CODPOSOFI'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>480
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'CODPOSOFI'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403726188106860672)
,p_name=>'P51_CODASENOFI'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>490
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'CODASENOFI'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403726647338860672)
,p_name=>'P51_TIPO_PERSONA'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'Tipo Persona'
,p_source=>'TIPO_PERSONA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'LOV_TIPOPER1'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CodValor, DescValLst',
'  FROM VALORES_DE_LISTAS',
'WHERE CodLista = ''TIPPER'''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403727010969860674)
,p_name=>'P51_TIP_DOCIDE_MATRIZ'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>640
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'TIP_DOCIDE_MATRIZ'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403727481082860674)
,p_name=>'P51_NUM_DOCIDE_MATRIZ'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>650
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'NUM_DOCIDE_MATRIZ'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403727814130860675)
,p_name=>'P51_TELMOVIL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>660
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'TELMOVIL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403728192360860675)
,p_name=>'P51_APELLIDO_MATERNO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'Apellido Materno'
,p_source=>'APELLIDO_MATERNO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
,p_attribute_06=>'UPPER'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403728663667860677)
,p_name=>'P51_APELLIDO_PATERNO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'Apellido Paterno'
,p_source=>'APELLIDO_PATERNO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
,p_attribute_06=>'UPPER'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403729010066860677)
,p_name=>'P51_CODCOLRES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT Codigo_Colonia, Codigo_Colonia||''-''||Descripcion_Colonia  Descripcion_Colonia',
'  FROM COLONIA',
'WHERE Codigo_Postal = :P51_CODPOSRES',
'  --AND codpais       =  SUBSTR(:P51_CODPAISRES,0,3)',
'  --AND codestado     = SUBSTR(:P51_CODPROVRES,0,INSTR(:P51_CODPROVRES,''-'')-2)',
'  --AND codciudad     = SUBSTR(:P51_CODDISTRES,0,3)',
'  --AND codmunicipio  = SUBSTR(:P51_CODCORRRES,0,3)',
'ORDER BY Codigo_Colonia'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Colonia Residencia'
,p_source=>'CODCOLRES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT Codigo_Colonia||''-''||Descripcion_Colonia  Descripcion_Colonia,Codigo_Colonia',
'  FROM COLONIA',
'WHERE Codigo_Postal = :P51_CODPOSRES',
'  AND codpais       =  SUBSTR(:P51_CODPAISRES,0,3)',
'  AND codestado     = REPLACE(SUBSTR(:P51_CODPROVRES,0,3),'' '','''')',
'  AND codciudad     = SUBSTR(:P51_CODDISTRES,0,3)',
'  AND codmunicipio  = SUBSTR(:P51_CODCORRRES,0,3)',
'ORDER BY Codigo_Colonia'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P51_CODPOSRES,P51_CODPAISRES,P51_CODPROVRES,P51_CODDISTRES,P51_CODCORRRES'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403729431017860679)
,p_name=>'P51_LADATELRES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'LADA'
,p_source=>'LADATELRES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>5
,p_colspan=>1
,p_grid_column=>1
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403729845715860679)
,p_name=>'P51_LADATELOFI'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>540
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'LADATELOFI'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403730191161860680)
,p_name=>'P51_LADAFAXOFI'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>560
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'LADAFAXOFI'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403730657831860680)
,p_name=>'P51_LADATELMOVIL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>680
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'LADATELMOVIL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403731008818860680)
,p_name=>'P51_CODACTIVIDAD'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>350
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>unistr('Actividad Econ\00F3mica')
,p_source=>'CODACTIVIDAD'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'LOV_ACTIVIDAD_ECONOMICA1'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CODACTIVIDAD, CODACTIVIDAD  || '' - '' || DESCACTIVIDAD ACTIVIDAD_ECONOMICA',
'FROM ACTIVIDADES_ECONOMICAS ',
'ORDER BY CODACTIVIDAD;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403731451774860682)
,p_name=>'P51_NUMINTERIOR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'No. Interior'
,p_source=>'NUMINTERIOR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>10
,p_cMaxlength=>20
,p_begin_on_new_line=>'N'
,p_colspan=>1
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403731799300860682)
,p_name=>'P51_NUMEXTERIOR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'No. Exterior'
,p_source=>'NUMEXTERIOR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>10
,p_cMaxlength=>20
,p_colspan=>1
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403732266450860683)
,p_name=>'P51_AUXCONTABLE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'Auxiliar Contable'
,p_source=>'AUXCONTABLE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>30
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
,p_attribute_06=>'UPPER'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403732664216860685)
,p_name=>'P51_NOMBRECOMERCIAL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'Nombre Comercial'
,p_source=>'NOMBRECOMERCIAL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>300
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
,p_attribute_06=>'UPPER'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403733021687860685)
,p_name=>'P51_CURP'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>390
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'Clave CURP'
,p_source=>'CURP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>30
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
,p_attribute_06=>'UPPER'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403733444381860685)
,p_name=>'P51_CODLISTAREF'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>430
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'Lista Referencia'
,p_source=>'CODLISTAREF'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'LOV_LISTA_REFERENCIAS1'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CODVALOR, CODVALOR || '' - '' || DESCVALLST LIST_REF',
'FROM VALORES_DE_LISTAS',
'WHERE 1 = 1',
'AND CODLISTA = ''LISTAREF'''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403733869703860686)
,p_name=>'P51_FECLISTAREF'
,p_source_data_type=>'DATE'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'Fecha Lista Referencia'
,p_source=>'FECLISTAREF'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'POPUP'
,p_attribute_03=>'NONE'
,p_attribute_06=>'NONE'
,p_attribute_09=>'N'
,p_attribute_11=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403734219908860688)
,p_name=>'P51_NACIONALIDAD'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>360
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'Nacionalidad'
,p_source=>'NACIONALIDAD'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT DESCVALLST,CODVALOR',
'FROM VALORES_DE_LISTAS ',
'WHERE CODLISTA = ''NACION''',
'    AND CODVALOR =  (SELECT CODPAISALTERNO',
'    FROM PAIS WHERE CODPAIS = SUBSTR(:P51_CODPAISRES,0,3));'))
,p_lov_cascade_parent_items=>'P51_CODPAISRES'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403734602144860688)
,p_name=>'P51_IDCLIENTEUNICO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>670
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_source=>'IDCLIENTEUNICO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(403734998726860690)
,p_name=>'P51_IDREGFISSAT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>unistr('R\00E9gimen Fiscal')
,p_source=>'IDREGFISSAT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'LOV_TIPO_REGIMEN1'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT IDREGFISSAT',
'    ,IDREGFISSAT || '' - '' || DESCTIPOREGIMEN',
'FROM CAT_REGIMEN_FISCAL;'))
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'Y'
,p_attribute_05=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(484967402600189791)
,p_name=>'P51_RAZONSOCIALFACT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>unistr('Raz\00F3n Social Fact.')
,p_source=>'RAZONSOCIALFACT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>300
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
,p_attribute_06=>'UPPER'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(484967494591189792)
,p_name=>'P51_FECMOVTOSICAS'
,p_source_data_type=>'DATE'
,p_item_sequence=>690
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'Fecha Movimiento SICAS'
,p_source=>'FECMOVTOSICAS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'POPUP'
,p_attribute_03=>'NONE'
,p_attribute_06=>'NONE'
,p_attribute_09=>'N'
,p_attribute_11=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(484967633646189793)
,p_name=>'P51_FECAPLICASAT'
,p_source_data_type=>'DATE'
,p_item_sequence=>700
,p_item_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_item_source_plug_id=>wwv_flow_imp.id(403708520904860542)
,p_prompt=>'Fecha Aplica SAT'
,p_source=>'FECAPLICASAT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(136322578632393326)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'POPUP'
,p_attribute_03=>'NONE'
,p_attribute_06=>'NONE'
,p_attribute_09=>'N'
,p_attribute_11=>'Y'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(128770771993357568)
,p_validation_name=>'Obligatorios_Fisica_U'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE ',
'    es_vacio boolean;',
'   BEGIN',
'        IF :P51_NOMBRE IS NULL OR :P51_FECNACIMIENTO IS NULL OR :P51_APELLIDO_PATERNO IS NULL THEN',
'            es_vacio := FALSE;',
'        END IF;',
'        return es_vacio;',
'   END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Hacen falta campos obligatorios para personas F\00EDsicas'),
'    NOMBRE, APELLIDO PATERNO,FECHA NACIMIENTO'))
,p_validation_condition=>'P51_TIPO_PERSONA'
,p_validation_condition2=>'FISICA'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(128771904961357570)
,p_validation_name=>'Obligatorios_Fisica_C'
,p_validation_sequence=>20
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE ',
'    es_vacio boolean;',
'   BEGIN',
'        IF :P51_NOMBRE IS NULL OR :P51_FECNACIMIENTO IS NULL OR :P51_APELLIDO_PATERNO IS NULL THEN',
'            es_vacio := FALSE;',
'        END IF;',
'        return es_vacio;',
'   END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Hacen falta campos obligatorios para personas F\00EDsicas'),
'    NOMBRE, APELLIDO PATERNO,FECHA NACIMIENTO'))
,p_validation_condition=>'P51_TIPO_PERSONA'
,p_validation_condition2=>'FISICA'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_when_button_pressed=>wwv_flow_imp.id(128728448915357479)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(128771144606357568)
,p_validation_name=>'Obligatorios_Moral_U'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE ',
'    es_vacio boolean;',
'   BEGIN',
'        IF :P51_NOMBRE IS NULL OR :P51_FECNACIMIENTO IS NULL THEN',
'            es_vacio := FALSE;',
'        END IF;',
'        return es_vacio;',
'   END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Hacen falta campos obligatorios para personas F\00EDsicas'),
unistr('    NOMBRE, FECHA CONSTITUCI\00D3N')))
,p_validation_condition=>'P51_TIPO_PERSONA'
,p_validation_condition2=>'MORAL'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(128771518375357570)
,p_validation_name=>'Obligatorios_Moral_C'
,p_validation_sequence=>40
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE ',
'    es_vacio boolean;',
'   BEGIN',
'        IF :P51_NOMBRE IS NULL OR :P51_FECNACIMIENTO IS NULL THEN',
'            es_vacio := FALSE;',
'        END IF;',
'        return es_vacio;',
'   END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Hacen falta campos obligatorios para personas F\00EDsicas'),
unistr('    NOMBRE, FECHA CONSTITUCI\00D3N')))
,p_validation_condition=>'P51_TIPO_PERSONA'
,p_validation_condition2=>'MORAL'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_when_button_pressed=>wwv_flow_imp.id(128728448915357479)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128773480743357571)
,p_name=>'DA_CODPOSRES'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_CODPOSRES'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128773974266357573)
,p_event_id=>wwv_flow_imp.id(128773480743357571)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'   SELECT CodPais, CodEstado, CodCiudad, CodMunicipio',
'           INTO :P51_CodPaisRes, :P51_CodProvres, ',
'                :P51_CodDistRes, :P51_CodCorrRes',
'           FROM APARTADO_POSTAL',
'          WHERE Codigo_Postal = :P51_CodPosRes;',
'          /*',
'EXCEPTION',
'WHEN OTHERS THEN ',
':P51_CodPaisRes := NULL; ',
':P51_CodProvres := NULL; ',
':P51_CodDistRes := NULL;',
'*/',
'END ;'))
,p_attribute_02=>'P51_CODPOSRES'
,p_attribute_03=>'P51_CODPAISRES,P51_CODPROVRES,P51_CODDISTRES,P51_CODCORRRES'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128774317270357575)
,p_event_id=>wwv_flow_imp.id(128773480743357571)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_CODPAISRES,P51_CODPROVRES,P51_CODDISTRES,P51_CODCORRRES'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128774746813357575)
,p_name=>'HiddenItems'
,p_event_sequence=>50
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128775298220357575)
,p_event_id=>wwv_flow_imp.id(128774746813357575)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_RFCDEPASO,P51_FECSTS'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128775605649357575)
,p_name=>'NoEditableItems'
,p_event_sequence=>60
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128776129778357578)
,p_event_id=>wwv_flow_imp.id(128775605649357575)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var vFechaIngreso = document.getElementById(''P51_FECINGRESO'');',
'var vIdClienteUnicp = document.getElementById(''P51_IDCLIENTEUNICO'');',
'var vNoDocumento = document.getElementById(''P51_NUM_DOC_IDENTIFICACION'');',
'var vClienteUnico = document.getElementById(''P51_C_IDCLIENTEUNICO'');',
'/*',
'var vNombre = document.getElementById(''P114_NOMBRE'');',
'*/',
'',
'vFechaIngreso.readOnly = true;',
'vIdClienteUnicp.readOnly = true;',
'if(apex.item("P51_NUM_DOC_IDENTIFICACION").isEmpty()){',
'    vNoDocumento.readOnly = false;',
'}else{',
'    vNoDocumento.readOnly = true;',
'}',
'',
'vClienteUnico.readOnly = true;',
'/*vNoDocumento.readOnly = true;',
'',
'/*apex.item(''P114_FECSTS'').disable();*/',
'',
'/*',
'apex.item(''P1_IDBG'').hide();',
'*/',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128776595760357578)
,p_name=>'HideButtons'
,p_event_sequence=>70
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128777092920357579)
,p_event_id=>wwv_flow_imp.id(128776595760357578)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_imp.id(128728866108357479)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128777425603357579)
,p_name=>'SetValueDocFiscal'
,p_event_sequence=>80
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_NUM_DOC_IDENTIFICACION'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128777956445357579)
,p_event_id=>wwv_flow_imp.id(128777425603357579)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_NUM_TRIBUTARIO'
,p_attribute_01=>'FUNCTION_BODY'
,p_attribute_06=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    vDocumento VARCHAR2(30) := NULL;',
'BEGIN',
'    IF(:P51_TIPO_DOC_IDENTIFICACION = ''RFC'')THEN',
'        SELECT :P51_NUM_DOC_IDENTIFICACION',
'        INTO vDocumento ',
'        FROM DUAL;',
'    END IF;',
'    ',
'   RETURN vDocumento;',
'END;'))
,p_attribute_07=>'P51_TIPO_DOC_IDENTIFICACION,P51_NUM_DOC_IDENTIFICACION'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128778327846357579)
,p_name=>'SetClienteUnico'
,p_event_sequence=>90
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_NUM_DOC_IDENTIFICACION'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128778880679357581)
,p_event_id=>wwv_flow_imp.id(128778327846357579)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_C_IDCLIENTEUNICO'
,p_attribute_01=>'FUNCTION_BODY'
,p_attribute_06=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    cIDUNICOPERSONA PERSONAS_IDUNICOPERSONA.IDUNICOPERSONA%type;',
'BEGIN',
'    BEGIN',
'    	SELECT MAX(IDUNICOPERSONA)',
'        INTO cIDUNICOPERSONA',
'        FROM PERSONAS_IDUNICOPERSONA',
'        WHERE TIPO_ID_TRIBUTARIA = :P51_TIPO_DOC_IDENTIFICACION',
'        AND NUM_TRIBUTARIO  = :P51_NUM_DOC_IDENTIFICACION',
'        ;',
'',
'    EXCEPTION WHEN NO_DATA_FOUND 	THEN',
'    	cIDUNICOPERSONA := NULL;',
'    END;',
'',
'    IF cIDUNICOPERSONA IS NULL THEN',
'        SELECT IDUNICOPERSONA_SEQ.nextval ',
'        INTO cIDUNICOPERSONA',
'        FROM dual',
'        ;',
'    END IF;',
'    ',
'    RETURN cIDUNICOPERSONA;',
'',
'END;'))
,p_attribute_07=>'P51_TIPO_DOC_IDENTIFICACION, P51_NUM_DOC_IDENTIFICACION'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128779298913357581)
,p_name=>'Reporte_Colonias'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(128727270736357478)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128779778177357581)
,p_event_id=>wwv_flow_imp.id(128779298913357581)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_CODCOLRES'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128780119105357581)
,p_name=>'Reporte_Colonias002'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(128726893204357478)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128780626108357581)
,p_event_id=>wwv_flow_imp.id(128780119105357581)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'document.getElementById(''BTNRefreshColonias'').click();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128781088965357582)
,p_name=>'SetDescripcion'
,p_event_sequence=>120
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_IDREGFISSAT'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128781573334357582)
,p_event_id=>wwv_flow_imp.id(128781088965357582)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_CDESCREGIMENFISC'
,p_attribute_01=>'FUNCTION_BODY'
,p_attribute_06=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    vIDREGFISSAT VARCHAR2(100);',
'BEGIN',
'    SELECT DESCTIPOREGIMEN',
'    INTO vIDREGFISSAT',
'    FROM CAT_REGIMEN_FISCAL',
'    WHERE 1 = 1',
'    AND IDREGFISSAT = :P51_IDREGFISSAT',
'    ;',
'',
'    RETURN vIDREGFISSAT;',
'END;'))
,p_attribute_07=>'P51_IDREGFISSAT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128781914202357582)
,p_name=>'Tab_FecNac'
,p_event_sequence=>130
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_FECNACIMIENTO'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === 9'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keydown'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128782433230357582)
,p_event_id=>wwv_flow_imp.id(128781914202357582)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Ejec_Tab'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.jQuery(''#btn_rfc'').click();'
);
end;
/
begin
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128782816748357582)
,p_name=>'Refresh_FecNac'
,p_event_sequence=>140
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_FECNACIMIENTO'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128783336934357589)
,p_event_id=>wwv_flow_imp.id(128782816748357582)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_NUM_TRIBUTARIO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128783798358357589)
,p_name=>'GeneraRFC'
,p_event_sequence=>150
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(128726423289357467)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128784242892357590)
,p_event_id=>wwv_flow_imp.id(128783798358357589)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    cNum_Tributario  PERSONA_NATURAL_JURIDICA.Num_Tributario%TYPE;',
'    vl_Total        NUMBER := 0;',
'BEGIN ',
'    --:P51_RFCDEPASO := ''A'';',
'    IF (:P51_TIPO_DOC_IDENTIFICACION = ''RFC'' OR :P51_TIPO_ID_TRIBUTARIA = ''RFC'') AND (:P51_TIPO_PERSONA = ''FISICA'') THEN',
'        cNum_Tributario := SICAS_OC.OC_GENERARFC.GENERAPRINCIPAL(:P51_NOMBRE,:P51_APELLIDO_PATERNO,:P51_APELLIDO_MATERNO,:P51_FECNACIMIENTO);',
'        --:P51_NUM_TRIBUTARIO := ''''||cNum_Tributario; ',
'        --:P51_RFCDEPASO :=''A''|| cNum_Tributario;',
'  /*  ELSIF :P51_TIPO_PERSONA IS NULL  THEN',
unistr('            apex_error.add_error(p_message => ''Solamente se Genera el RFC para Personas F\00EDsicas.'',p_display_location => apex_error.c_inline_in_notification);'),
'            */',
'        IF :P51_TIPO_DOC_IDENTIFICACION = ''RFC'' OR :P51_TIPO_ID_TRIBUTARIA = ''RFC'' THEN',
'            --:P51_RFCDEPASO := cNum_Tributario;',
'',
'            SELECT COUNT(1)',
'            INTO vl_Total',
'         	FROM SICAS_OC.PERSONA_NATURAL_JURIDICA ',
'         	WHERE TIPO_DOC_IDENTIFICACION = :P51_TIPO_DOC_IDENTIFICACION AND NUM_DOC_IDENTIFICACION = :P51_NUM_DOC_IDENTIFICACION AND ROWNUM <= 1;',
'',
'            IF (NVL(:P51_NUM_DOC_IDENTIFICACION,''NO_DATA'') != cNum_Tributario AND vl_Total = 0) THEN',
'                :P51_RFCDEPASO := ''C''||cNum_Tributario;',
'                :P51_NUM_TRIBUTARIO  := cNum_Tributario;',
'                apex_error.add_error(p_message => cNum_Tributario||'' ''||:P51_NUM_DOC_IDENTIFICACION ,p_display_location => apex_error.c_inline_in_notification);',
unistr('                raise_application_error(-20201,''El N\00FAmero Generado es Id\00E9ntico al Capturado en Documento de Identificaci\00F3n.'');   	 '),
'            ELSIF (vl_Total >= 1) THEN',
'                :P51_NUM_TRIBUTARIO := cNum_Tributario;',
'                apex_error.add_error(p_message => cNum_Tributario||'' ''||:P51_NUM_DOC_IDENTIFICACION ,p_display_location => apex_error.c_inline_in_notification);',
unistr('                raise_application_error(-20201,''El N\00FAmero Generado es Id\00E9ntico al Capturado en Documento de Identificaci\00F3n.'');   	  '),
'            ELSE',
'                :P51_RFCDEPASO := ''C''||cNum_Tributario;',
'                :P51_NUM_TRIBUTARIO := cNum_Tributario;',
unistr('                apex_error.add_error(p_message => cNum_Tributario||''  El N\00FAmero Generado es Id\00E9ntico al Capturado en Documento de Identificaci\00F3n.'' ,p_display_location => apex_error.c_inline_in_notification);'),
unistr('  	    	    raise_application_error(-20201,''El N\00FAmero Generado es Id\00E9ntico al Capturado en Documento de Identificaci\00F3n.'');   	  		 	          '),
'	        END IF;',
'        END IF;',
'    ELSE',
unistr('        apex_error.add_error(p_message => ''Esta funci\00F3n solo aplica para personas Morales.'' ,p_display_location => apex_error.c_inline_in_notification);'),
unistr('  	    raise_application_error(-20201,''Esta funci\00F3n solo aplica para personas Morales.'');   '),
'    END IF;',
'EXCEPTION',
'    WHEN OTHERS THEN ',
unistr('        apex_error.add_error(p_message => ''Ocurri\00F3 un error: ''||SQLERRM,p_display_location => apex_error.c_inline_in_notification);'),
'END;'))
,p_attribute_02=>'P51_RFCDEPASO,P51_TIPO_DOC_IDENTIFICACION,P51_TIPO_ID_TRIBUTARIA,P51_FECNACIMIENTO,P51_TIPO_PERSONA,P51_NOMBRE,P51_APELLIDO_PATERNO,P51_APELLIDO_MATERNO,P51_NUM_TRIBUTARIO'
,p_attribute_03=>'P51_NUM_TRIBUTARIO'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128784751139357590)
,p_event_id=>wwv_flow_imp.id(128783798358357589)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(403708520904860542)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128785141141357590)
,p_name=>'Refresh_Nombre'
,p_event_sequence=>160
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_NOMBRE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128785600720357592)
,p_event_id=>wwv_flow_imp.id(128785141141357590)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_NOMBRE'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128786107973357592)
,p_event_id=>wwv_flow_imp.id(128785141141357590)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'HOKA'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128786566707357592)
,p_name=>'Tab_Nombre'
,p_event_sequence=>180
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_NOMBRE'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === 9'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keydown'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128787066921357592)
,p_event_id=>wwv_flow_imp.id(128786566707357592)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Ejec_Tab_Nombre'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.jQuery(''#btn_rfc'').click();',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128787415328357592)
,p_name=>'Deshabilita_TipoPerson'
,p_event_sequence=>190
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_TIPO_PERSONA'
,p_condition_element=>'P51_TIPO_PERSONA'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'MORAL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128787904754357595)
,p_event_id=>wwv_flow_imp.id(128787415328357592)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_APELLIDO_PATERNO,P51_APELLIDO_MATERNO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128788442658357595)
,p_event_id=>wwv_flow_imp.id(128787415328357592)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_APELLIDO_PATERNO,P51_APELLIDO_MATERNO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128788993094357595)
,p_event_id=>wwv_flow_imp.id(128787415328357592)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_APELLIDO_PATERNO,P51_APELLIDO_MATERNO'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    SELECT APELLIDO_PATERNO,APELLIDO_MATERNO',
'    FROM SICAS_OC.PERSONA_NATURAL_JURIDICA',
'    WHERE NUM_DOC_IDENTIFICACION =  :P51_NUM_DOC_IDENTIFICACION',
'        AND TIPO_DOC_IDENTIFICACION = :P51_TIPO_DOC_IDENTIFICACION',
'        AND ROWNUM <= 1;'))
,p_attribute_07=>'P51_NUM_DOC_IDENTIFICACION,P51_TIPO_DOC_IDENTIFICACION'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128789412271357595)
,p_event_id=>wwv_flow_imp.id(128787415328357592)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_APELLIDO_PATERNO,P51_APELLIDO_MATERNO'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128789952692357595)
,p_event_id=>wwv_flow_imp.id(128787415328357592)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$(''P51_APELLIDO_PATERNO'').removeClass(''is-required'');',
'$(''P51_APELLIDO_MATERNO'').removeClass(''is-required'');'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128790460804357596)
,p_event_id=>wwv_flow_imp.id(128787415328357592)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$(''P51_APELLIDO_PATERNO'').addClass(''is-required'');',
'$(''P51_APELLIDO_MATERNO'').addClass(''is-required'');'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128790811127357596)
,p_name=>'Refresh_Paterno'
,p_event_sequence=>200
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_APELLIDO_PATERNO'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128791331374357596)
,p_event_id=>wwv_flow_imp.id(128790811127357596)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_APELLIDO_PATERNO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128791774172357596)
,p_name=>'Refresh_Materno'
,p_event_sequence=>210
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_APELLIDO_MATERNO'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128792280717357600)
,p_event_id=>wwv_flow_imp.id(128791774172357596)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_APELLIDO_MATERNO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128792689834357600)
,p_name=>'Tab_Paterno'
,p_event_sequence=>220
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_APELLIDO_PATERNO'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === 9'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keydown'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128793109325357600)
,p_event_id=>wwv_flow_imp.id(128792689834357600)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Ejec_Tab_Paterno'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.jQuery(''#btn_rfc'').click();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128793587964357600)
,p_name=>'Ejec_Tab_Materno'
,p_event_sequence=>230
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_APELLIDO_MATERNO'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === 9'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keydown'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128794028265357600)
,p_event_id=>wwv_flow_imp.id(128793587964357600)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.jQuery(''#btn_rfc'').click();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128794400691357600)
,p_name=>'New'
,p_event_sequence=>240
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_NUM_DOC_IDENTIFICACION'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128794943128357603)
,p_event_id=>wwv_flow_imp.id(128794400691357600)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P51_NUM_TRIBUTARIO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128795451052357604)
,p_event_id=>wwv_flow_imp.id(128794400691357600)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var valor = $v("P51_NUM_DOC_IDENTIFICACION");',
unistr('apex.message.confirm( "\00BFDeseas reemplazar el RFC en Num Tributario?", function( okPressed ) {'),
'    if( okPressed ) {',
'        $s("P51_NUM_TRIBUTARIO", valor);',
'    } else {',
'        $s("P51_NUM_TRIBUTARIO", '''');',
'    }',
'});'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128795880860357604)
,p_name=>'Tab_IdTrib'
,p_event_sequence=>250
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_TIPO_ID_TRIBUTARIA'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === 9'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keydown'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128796377959357604)
,p_event_id=>wwv_flow_imp.id(128795880860357604)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Ejec_Tab'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.jQuery(''#btn_rfc'').click();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128796713060357604)
,p_name=>'Tab_NumTribu'
,p_event_sequence=>260
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P51_NUM_TRIBUTARIO'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === 9'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keydown'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128797286766357604)
,p_event_id=>wwv_flow_imp.id(128796713060357604)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Ejec_Tab'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.jQuery(''#btn_rfc'').click();'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(128773010207357571)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Insert_IdUnicPersona'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    cIDUNICOPERSONA PERSONAS_IDUNICOPERSONA.IDUNICOPERSONA%type;',
'BEGIN',
'	INSERT INTO PERSONAS_IDUNICOPERSONA (IDUNICOPERSONA, TIPO_DOC_IDENTIFICACION, NUM_DOC_IDENTIFICACION, TIPO_ID_TRIBUTARIA, NUM_TRIBUTARIO, CURP)',
'	     VALUES (:P51_C_IDCLIENTEUNICO, :P51_TIPO_DOC_IDENTIFICACION, :P51_NUM_DOC_IDENTIFICACION, :P51_TIPO_ID_TRIBUTARIA, :P51_NUM_TRIBUTARIO,:P51_CURP);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>128773010207357571
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(128769885357357564)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(403708520904860542)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>unistr('Process form Persona Natural Jur\00EDdica')
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>128769885357357564
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(128772266323357570)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Ejecuta_RFC'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    cNum_Tributario  PERSONA_NATURAL_JURIDICA.Num_Tributario%TYPE;',
'    vl_Total        NUMBER := 0;',
'BEGIN ',
'    :P51_RFCDEPASO := ''A'';',
'    IF :P51_TIPO_DOC_IDENTIFICACION = ''RFC'' OR :P51_TIPO_ID_TRIBUTARIA = ''RFC'' THEN',
'        IF :P51_FECNACIMIENTO IS NULL THEN',
'            apex_error.add_error(p_message => ''Debe Ingresar la Fecha de Nacimiento.'',p_display_location => apex_error.c_inline_in_notification);',
'        ',
'        ELSIF :P51_NOMBRE IS NULL THEN',
'            apex_error.add_error(p_message => ''Debe Ingresar el Nombre de la Persona.'',p_display_location => apex_error.c_inline_in_notification);',
'        ELSIF  (:P51_TIPO_PERSONA =''FISICA'') AND (:P51_APELLIDO_PATERNO IS NULL) THEN',
'                apex_error.add_error(p_message => ''Debe Ingresar el Apellido Paterno.'',p_display_location => apex_error.c_inline_in_notification);',
'        ELSE ',
'            cNum_Tributario := SICAS_OC.OC_GENERARFC.GENERAPRINCIPAL(:P51_NOMBRE,:P51_APELLIDO_PATERNO,:P51_APELLIDO_MATERNO,:P51_FECNACIMIENTO);',
'            :P51_NUM_TRIBUTARIO := ''''||cNum_Tributario; ',
'            :P51_RFCDEPASO :=''A''|| cNum_Tributario;',
'',
'            IF :P51_TIPO_DOC_IDENTIFICACION = ''RFC'' OR :P51_TIPO_ID_TRIBUTARIA = ''RFC'' THEN',
'                :P51_RFCDEPASO := ''B''||cNum_Tributario;',
'',
'                SELECT COUNT(1)',
'         		INTO vl_Total',
'         		FROM SICAS_OC.PERSONA_NATURAL_JURIDICA ',
'         		WHERE TIPO_DOC_IDENTIFICACION = :P51_TIPO_DOC_IDENTIFICACION AND NUM_DOC_IDENTIFICACION = :P51_NUM_DOC_IDENTIFICACION AND ROWNUM <= 1;',
'',
'                IF (NVL(:P51_NUM_DOC_IDENTIFICACION,''NO_DATA'') != cNum_Tributario AND vl_Total = 0) THEN',
'                    :P51_RFCDEPASO := ''C''||cNum_Tributario;',
'                    :P51_NUM_DOC_IDENTIFICACION := cNum_Tributario;',
'                /*ELSIF (vl_Total >= 1) THEN',
'                    :P51_NUM_TRIBUTARIO := cNum_Tributario;',
'                    apex_error.add_error(p_message => cNum_Tributario||'' ''||:P51_NUM_DOC_IDENTIFICACION ,p_display_location => apex_error.c_inline_in_notification);',
unistr('                    raise_application_error(-20201,''El N\00FAmero Generado es Id\00E9ntico al Capturado en Documento de Identificaci\00F3n.'');   	  '),
'                ELSE',
'                    :P51_RFCDEPASO := ''C''||cNum_Tributario;',
'                    :P51_NUM_TRIBUTARIO := cNum_Tributario;',
unistr('                    apex_error.add_error(p_message => cNum_Tributario||''  El N\00FAmero Generado es Id\00E9ntico al Capturado en Documento de Identificaci\00F3n.'' ,p_display_location => apex_error.c_inline_in_notification);'),
unistr('  	    	        raise_application_error(-20201,''El N\00FAmero Generado es Id\00E9ntico al Capturado en Documento de Identificaci\00F3n.'');   	  		 	          '),
'	           */ END IF;',
'            END IF;',
'',
'            IF :P51_NUM_TRIBUTARIO IS NOT NULL AND :P51_NUM_DOC_IDENTIFICACION IS NULL THEN',
'                SELECT COUNT(1)',
'         		INTO vl_Total',
'         		FROM SICAS_OC.PERSONA_NATURAL_JURIDICA ',
'         		WHERE TIPO_DOC_IDENTIFICACION = :P51_TIPO_DOC_IDENTIFICACION AND NUM_DOC_IDENTIFICACION = :P51_NUM_DOC_IDENTIFICACION AND ROWNUM <= 1;',
'',
'                IF (NVL(:P51_NUM_DOC_IDENTIFICACION,''X'') != cNum_Tributario) AND vl_Total = 0 THEN',
'	 	           IF (NVL(:P51_NUM_DOC_IDENTIFICACION,''NO_DATA'') != cNum_Tributario AND vl_Total = 0) THEN',
'                        :P51_RFCDEPASO := ''C''||cNum_Tributario;',
'                        :P51_NUM_DOC_IDENTIFICACION := cNum_Tributario;',
'                    ELSE',
unistr('                        apex_error.add_error(p_message => ''El N\00FAmero Generado es Id\00E9ntico al Capturado en Num Tributario.'',p_display_location => apex_error.c_inline_in_notification);'),
unistr('  	    	            raise_application_error(-20201,''El N\00FAmero Generado es Id\00E9ntico al Capturado en Num Tributario.'');   	  		 	          '),
'	                END IF;',
'                END IF;',
'            END IF;',
'        END IF;',
'    ELSE',
unistr('        apex_error.add_error(p_message => ''Funci\00F3n Habilitada Solo para Tipo de Documento o Identificaci\00F3n Tributaria RFC.'',p_display_location => apex_error.c_inline_in_notification);'),
unistr('        raise_application_error(-20201,''Funci\00F3n Habilitada Solo para Tipo de Documento o Identificaci\00F3n Tributaria RFC.'');'),
'    END IF;',
'    --RETURN cNum_Tributario;',
'EXCEPTION',
'    WHEN OTHERS THEN ',
unistr('        apex_error.add_error(p_message => ''Ocurri\00F3 un error: ''||SQLERRM,p_display_location => apex_error.c_inline_in_notification);'),
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>128772266323357570
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(128772634553357571)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'New'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
' BEGIN ',
' ',
'  IF :P51_TIPO_DOC_IDENTIFICACION = ''RFC'' OR :P51_TIPO_ID_TRIBUTARIA = ''RFC'' THEN',
'        IF :P51_FECNACIMIENTO IS NULL THEN',
'         APEX_ERROR.ADD_ERROR(',
'            p_message => ''Debe Ingresar la Fecha de Nacimiento0'',',
'            p_display_location => APEX_ERROR.C_INLINE_IN_NOTIFICATION',
'        );',
'            ',
'        /*ELSIF NVL(:P51_TIPO_PERSONA,''X'') != ''FISICA'' THEN',
unistr('            apex_error.add_error(p_message => ''Solamente se Genera el RFC para Personas F\00EDsicas.'',p_display_location => apex_error.c_inline_in_notification);'),
'        */ELSIF :P51_NOMBRE IS NULL THEN',
'           APEX_ERROR.ADD_ERROR(',
'            p_message => ''Debe Ingresar el Nombre de la Persona.'',',
'            p_display_location => APEX_ERROR.C_INLINE_IN_NOTIFICATION',
'        );',
'',
'        ELSIF (TRIM(:P51_APELLIDO_PATERNO) IS NULL OR TRIM(:P51_APELLIDO_PATERNO) = '''') AND (:P51_TIPO_PERSONA = ''FISICA'') THEN ',
'            apex_error.add_error(p_message => ''Debe Ingresar el Apellido Paterno.'',p_display_location => apex_error.c_inline_in_notification);',
'            raise_application_error(-20201,''Debe Ingresar el Apellido Paterno.'');',
'END IF; ',
'',
'END IF; ',
'',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>128772634553357571
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(128769426816357564)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(403708520904860542)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>unistr('Initialize form Persona Natural Jur\00EDdica')
,p_internal_uid=>128769426816357564
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

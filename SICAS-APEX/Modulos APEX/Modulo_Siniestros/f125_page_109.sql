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
,p_default_id_offset=>83300788917688700
,p_default_owner=>'SICAS_OC'
);
end;
/
 
prompt APPLICATION 125 - Siniestros
--
-- Application Export:
--   Application:     125
--   Name:            Siniestros
--   Date and Time:   10:23 Monday July 27, 2026
--   Exported By:     LREYNOSO
--   Flashback:       0
--   Export Type:     Page Export
--   Manifest
--     PAGE: 109
--   Manifest End
--   Version:         23.2.0
--   Instance ID:     709450366953385
--

begin
null;
end;
/
prompt --application/pages/delete_00109
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>109);
end;
/
prompt --application/pages/page_00109
begin
wwv_flow_imp_page.create_page(
 p_id=>109
,p_name=>'Beneficiarios'
,p_alias=>'BENEFICIARIOS'
,p_page_mode=>'MODAL'
,p_step_title=>'Beneficiarios'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#:ui-dialog--stretch'
,p_dialog_chained=>'N'
,p_protection_level=>'C'
,p_page_component_map=>'02'
,p_last_updated_by=>'LREYNOSO'
,p_last_upd_yyyymmddhh24miss=>'20260721125234'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(430517013841644977)
,p_plug_name=>'control'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(437742052681685805)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_condition_type=>'NEVER'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(498885041473659533)
,p_plug_name=>'Beneficiarios'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(283372144819041557)
,p_plug_display_sequence=>20
,p_query_type=>'TABLE'
,p_query_table=>'BENEF_SIN'
,p_include_rowid_column=>true
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(426029663227206478)
,p_plug_name=>'benef1'
,p_parent_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_region_css_classes=>'u-margin-top-lg'
,p_region_template_options=>'#DEFAULT#:margin-top-sm'
,p_plug_template=>wwv_flow_imp.id(283372144819041557)
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>6
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_item_display_point=>'BELOW'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(426029763802206479)
,p_plug_name=>'benef2'
,p_parent_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(283372144819041557)
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>6
,p_plug_display_point=>'SUB_REGIONS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(498918226996659606)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(283375036705041561)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_attribute_01=>'N'
,p_attribute_02=>'TEXT'
,p_attribute_03=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(446479716415670268)
,p_button_sequence=>90
,p_button_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_button_name=>'Especiales'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(283505443680041818)
,p_button_image_alt=>'Beneficiario especial'
,p_button_redirect_url=>'f?p=&APP_ID.:1500:&SESSION.::&DEBUG.:1500::'
,p_grid_new_row=>'N'
,p_grid_new_column=>'N'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(446484112442670312)
,p_button_sequence=>90
,p_button_plug_id=>wwv_flow_imp.id(426029763802206479)
,p_button_name=>'CREA_RFC'
,p_button_static_id=>'btn_rfc'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(283505443680041818)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Genera RFC'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>2
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(498918644331659606)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(498918226996659606)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(283505443680041818)
,p_button_image_alt=>'Cancelar'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(498920057762659613)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(498918226996659606)
,p_button_name=>'DELETE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(283505443680041818)
,p_button_image_alt=>'Borrar'
,p_button_position=>'DELETE'
,p_button_execute_validations=>'N'
,p_confirm_message=>'Desea Borrar el registro?'
,p_confirm_style=>'danger'
,p_button_condition=>'P109_ROWID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(498920403949659613)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(498918226996659606)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(283505443680041818)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Aplicar Cambios'
,p_button_position=>'NEXT'
,p_button_condition=>'P109_ROWID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(498920767746659613)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(498918226996659606)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(283505443680041818)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Crear Beneficiario'
,p_button_position=>'NEXT'
,p_button_condition=>'P109_ROWID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(184063731101908038)
,p_name=>'P109_TIPO_PERSONA'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'Tipo Persona'
,p_source=>'TIPO_PERSONA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TIPPER'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT DescValLst,CodValor',
'FROM VALORES_DE_LISTAS',
'WHERE CodLista = ''TIPPER'''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(283504272272041808)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(184063838044908039)
,p_name=>'P109_CURP'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(426029663227206478)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'CURP'
,p_source=>'CURP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>20
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(184063940715908040)
,p_name=>'P109_CODIGOZIP'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(426029763802206479)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>unistr('C\00F3digo ZIP')
,p_source=>'CODIGOZIP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'left'
,p_attribute_04=>'decimal'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(310566135569211755)
,p_name=>'P109_CUENTA_CLABE_CTRL'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(426029763802206479)
,p_prompt=>'Cuenta Clabe Ctrl'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_required_patch=>wwv_flow_imp.id(382085968144100281)
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(430517085408644978)
,p_name=>'P109_CN_SINIESTRO'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(430517013841644977)
,p_prompt=>'Cn Siniestro'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(437827822003685978)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(430517261748644979)
,p_name=>'P109_CN_POLIZA'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(430517013841644977)
,p_prompt=>'New'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(437827822003685978)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(430517935840644986)
,p_name=>'P109_CN_BENEF'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(430517013841644977)
,p_prompt=>'New'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(437827822003685978)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(430518023128644987)
,p_name=>'P109_CN_CODCIA'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(430517013841644977)
,p_prompt=>'New'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(437827822003685978)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(430673852674403296)
,p_name=>'P109_CN_CODASEGURADO'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(430517013841644977)
,p_prompt=>'New'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(437827822003685978)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(442242457399727269)
,p_name=>'P109_ROWID'
,p_source_data_type=>'ROWID'
,p_is_primary_key=>true
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_source=>'ROWID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(446481872124670290)
,p_name=>'P109_ID_BEN_ESP'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'Nuevo'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(447215107065675096)
,p_name=>'P109_CODPARENT_C'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT count(*)',
'        FROM VALORES_DE_LISTAS',
'       WHERE CodLista = ''PARANLIN''',
'         AND CodValor = :P109_CODPARENT;'))
,p_item_default_type=>'SQL_QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(447609156461935665)
,p_name=>'P109_FEC_ESTADO'
,p_source_data_type=>'DATE'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_imp.id(426029763802206479)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_default=>'sysdate'
,p_item_default_type=>'EXPRESSION'
,p_item_default_language=>'PLSQL'
,p_prompt=>'Fecha Estatus'
,p_source=>'FECESTADO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'Y'
,p_attribute_03=>'Y'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498885441007659536)
,p_name=>'P109_IDSINIESTRO'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'Siniestro'
,p_source=>'IDSINIESTRO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>4
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498885787674659539)
,p_name=>'P109_BENEF'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>unistr('N\00FAmero Beneficiario')
,p_source=>'BENEF'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>11
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498886247080659539)
,p_name=>'P109_IDPOLIZA'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>unistr('P\00F3liza')
,p_source=>'IDPOLIZA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_imp.id(283504272272041808)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attribute_03=>'right'
,p_attribute_04=>'text'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498886644114659541)
,p_name=>'P109_COD_ASEGURADO'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_source=>'COD_ASEGURADO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498886983455659542)
,p_name=>'P109_NOMBRE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>unistr('Nombres / Raz\00F3n Social')
,p_source=>'NOMBRE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>300
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(283504272272041808)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
,p_attribute_06=>'UPPER'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498887388189659542)
,p_name=>'P109_PORCEPART'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>unistr('% Participaci\00F3n')
,p_source=>'PORCEPART'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(283504272272041808)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'0'
,p_attribute_02=>'100'
,p_attribute_03=>'center'
,p_attribute_04=>'text'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498887845139659544)
,p_name=>'P109_CODPARENT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'Parentesco'
,p_source=>'CODPARENT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CodValor||'' - ''||DescValLst DESCRIP,CodValor',
'  FROM VALORES_DE_LISTAS',
'WHERE CodLista = ''PARENT'''))
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>0
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498888197978659545)
,p_name=>'P109_ESTADO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_imp.id(426029763802206479)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_default=>'ACTIVO'
,p_prompt=>'Estatus'
,p_source=>'ESTADO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'Y'
,p_attribute_03=>'Y'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498888566550659545)
,p_name=>'P109_SEXO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'Sexo'
,p_source=>'SEXO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:Masculino;M,Femenino;F'
,p_cHeight=>1
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498889372813659547)
,p_name=>'P109_FECALTA'
,p_source_data_type=>'DATE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_default=>'sysdate'
,p_item_default_type=>'EXPRESSION'
,p_item_default_language=>'PLSQL'
,p_prompt=>'Fecha Alta'
,p_source=>'FECALTA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_imp.id(283502998174041805)
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
 p_id=>wwv_flow_imp.id(498889858199659549)
,p_name=>'P109_FECBAJA'
,p_source_data_type=>'DATE'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_source=>'FECBAJA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498890205613659550)
,p_name=>'P109_MOTBAJA'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_source=>'MOTBAJA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498890643139659550)
,p_name=>'P109_OBSERVACIONES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(426029663227206478)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'Observaciones'
,p_source=>'OBERVACIONES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>300
,p_cHeight=>10
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498891000897659552)
,p_name=>'P109_DIRECCION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_source=>'DIRECCION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498891408133659552)
,p_name=>'P109_EMAIL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(426029663227206478)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'Email'
,p_source=>'EMAIL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>100
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498891808986659553)
,p_name=>'P109_TELEFONO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(426029663227206478)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>unistr('Tel\00E9fono')
,p_source=>'TELEFONO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>10
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498892253616659553)
,p_name=>'P109_CUENTA_CLAVE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(426029763802206479)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'No. Cuenta CLABE'
,p_source=>'CUENTA_CLAVE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>18
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498892644605659553)
,p_name=>'P109_ENT_FINANCIERA'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(426029763802206479)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'Banco'
,p_source=>'ENT_FINANCIERA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CodEntidad||'' - ''||SUBSTR(OC_ENTIDAD_FINANCIERA.NOMBRE_COMERCIAL(CodCia, Codentidad),1,300) DescEntidad,CodEntidad',
'  FROM ENTIDAD_FINANCIERA',
' WHERE CodCia = :CodCia',
' ORDER BY 2'))
,p_cHeight=>1
,p_colspan=>12
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498892975839659555)
,p_name=>'P109_INDPAGO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_source=>'INDPAGO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498893444549659555)
,p_name=>'P109_PORCEAPL'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_source=>'PORCEAPL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498893813836659556)
,p_name=>'P109_FECNAC'
,p_source_data_type=>'DATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(426029663227206478)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'Fecha de Nacimiento'
,p_source=>'FECNAC'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_imp.id(283504272272041808)
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
 p_id=>wwv_flow_imp.id(498894215113659556)
,p_name=>'P109_NUMCUENTABANCARIA'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(426029763802206479)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'No. Cuenta Bancaria'
,p_source=>'NUMCUENTABANCARIA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>20
,p_colspan=>6
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498894568844659558)
,p_name=>'P109_INDAPLICAISR'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(426029763802206479)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_default=>'N'
,p_prompt=>'Aplica ISR'
,p_source=>'INDAPLICAISR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SINGLE_CHECKBOX'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'S'
,p_attribute_03=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498894965999659558)
,p_name=>'P109_PORCENTISR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(426029763802206479)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'Porcentaje'
,p_source=>'PORCENTISR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
,p_attribute_04=>'text'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498895375479659559)
,p_name=>'P109_TIPO_ID_TRIBUTARIO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(426029763802206479)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'Tipo Documento Tributario'
,p_source=>'TIPO_ID_TRIBUTARIO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TIPODOCU'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CodValor||'' - ''||DescValLst DESCRIP,CodValor',
'FROM VALORES_DE_LISTAS',
'WHERE CodLista = ''TIPODOCU'''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_colspan=>5
,p_field_template=>wwv_flow_imp.id(283504272272041808)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498895837682659559)
,p_name=>'P109_NUM_DOC_TRIBUTARIO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(426029763802206479)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>unistr('N\00FAmero de Documento')
,p_source=>'NUM_DOC_TRIBUTARIO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>20
,p_begin_on_new_line=>'N'
,p_colspan=>5
,p_field_template=>wwv_flow_imp.id(283504272272041808)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
,p_attribute_06=>'UPPER'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498896177654659561)
,p_name=>'P109_APELLIDO_PATERNO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'Apellido Paterno'
,p_source=>'APELLIDO_PATERNO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
,p_attribute_06=>'UPPER'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498896611891659564)
,p_name=>'P109_APELLIDO_MATERNO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'Apellido Materno'
,p_source=>'APELLIDO_MATERNO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
,p_attribute_06=>'UPPER'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498897011741659564)
,p_name=>'P109_TIPO_PAGO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_source=>'TIPO_PAGO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498897268520659566)
,p_name=>'P109_FECFIRMARECLAMACION'
,p_source_data_type=>'DATE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(426029763802206479)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>unistr('Fecha Firma Reclamaci\00F3n')
,p_source=>'FECFIRMARECLAMACION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>wwv_flow_imp.id(283502998174041805)
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
 p_id=>wwv_flow_imp.id(498897714984659566)
,p_name=>'P109_TELEFONO_LOCAL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(426029663227206478)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>unistr('Tel\00E9fono Local')
,p_source=>'TELEFONO_LOCAL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>10
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
end;
/
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498898144549659567)
,p_name=>'P109_CODCIA'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_source=>'CODCIA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498898559811659567)
,p_name=>'P109_CODEMPRESA'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_source=>'CODEMPRESA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498898908908659569)
,p_name=>'P109_CODUSUARIO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_source=>'CODUSUARIO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498899295157659570)
,p_name=>'P109_FECREGISTRO'
,p_source_data_type=>'DATE'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_source=>'FECREGISTRO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498899680116659572)
,p_name=>'P109_IDTIPO_PAGO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(426029763802206479)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'Tipo de Pago'
,p_source=>'IDTIPO_PAGO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT A.CODVALOR||'' - ''||A.DESCVALLST descrip,A.CODVALOR',
'  FROM VALORES_DE_LISTAS A',
' WHERE A.CODLISTA = ''PAGOBENEF''',
' ORDER BY A.CODVALOR'))
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>5
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498900097692659574)
,p_name=>'P109_TP_IDENTIFICACION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(426029763802206479)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>unistr('Tipo Documento Identificaci\00F3n')
,p_source=>'TP_IDENTIFICACION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'TIPODOCU'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CodValor||'' - ''||DescValLst DESCRIP,CodValor',
'FROM VALORES_DE_LISTAS',
'WHERE CodLista = ''TIPODOCU'''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_colspan=>5
,p_field_template=>wwv_flow_imp.id(283504272272041808)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498900478563659574)
,p_name=>'P109_NUM_IDENTIFICACION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(426029763802206479)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>unistr('N\00FAmero Identificaci\00F3n')
,p_source=>'NUM_IDENTIFICACION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>30
,p_begin_on_new_line=>'N'
,p_colspan=>5
,p_field_template=>wwv_flow_imp.id(283504272272041808)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>'Este campo se actualiza al modificar Nombres o fecha de nacimiento'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
,p_attribute_06=>'UPPER'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498900908958659575)
,p_name=>'P109_COD_CONVENIO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_imp.id(426029763802206479)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>'No. Convenio'
,p_source=>'COD_CONVENIO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>20
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'NONE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498901357466659577)
,p_name=>'P109_ID_EDAD_MINORIA'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(426029663227206478)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>unistr('Beneficiario con Minor\00EDa de Edad')
,p_source=>'ID_EDAD_MINORIA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SINGLE_CHECKBOX'
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'S'
,p_attribute_03=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498901756383659577)
,p_name=>'P109_NOMBRE_MINORIA'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(426029663227206478)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>unistr('Nombre Minor\00EDa')
,p_source=>'NOMBRE_MINORIA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>100
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
,p_attribute_06=>'UPPER'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498902148786659578)
,p_name=>'P109_PORC_MINORIA'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(426029663227206478)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_prompt=>unistr('Porcentaje Minor\00EDa')
,p_source=>'PORC_MINORIA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(283502998174041805)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attribute_03=>'right'
,p_attribute_04=>'text'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498902544104659578)
,p_name=>'P109_SIT_CLIENTE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_source=>'SIT_CLIENTE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498902916444659580)
,p_name=>'P109_SIT_REFERENCIA'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_source=>'SIT_REFERENCIA'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498903279406659581)
,p_name=>'P109_SIT_CONCEPTO'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_source=>'SIT_CONCEPTO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(498903677469659583)
,p_name=>'P109_IDREGFISSAT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_item_source_plug_id=>wwv_flow_imp.id(498885041473659533)
,p_source=>'IDREGFISSAT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(430516209940644969)
,p_validation_name=>'VALIDAR_PORCENTAJE'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
' DECLARE',
'   nPorcentaje BENEF_SIN.PORCEPART%TYPE;',
'BEGIN',
'',
'BEGIN',
' SELECT NVL(SUM(PORCEPART),0) + :P109_PORCEPART',
'     INTO nPorcentaje',
'      FROM BENEF_SIN B',
'     WHERE B.IDPOLIZA = :P109_CN_POLIZA',
'       AND B.IDSINIESTRO = :P109_CN_SINIESTRO',
'       and B.COD_ASEGURADO = :P109_CN_CODASEGURADO;',
'EXCEPTION',
'    WHEN OTHERS THEN ',
'    nPorcentaje := 200;',
'END;',
'',
'IF nPorcentaje <= 100 THEN',
'  RETURN TRUE;',
'  ELSE ',
'  RETURN FALSE;',
'  END IF;',
'',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>unistr('La suma del porcentaje de participaci\00F3n de todos los beneficiarios no puede ser mayor a 100.')
,p_always_execute=>'Y'
,p_when_button_pressed=>wwv_flow_imp.id(498920767746659613)
,p_associated_item=>wwv_flow_imp.id(498887388189659542)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(309295581863514372)
,p_validation_name=>'CUENTA_CLABE_SAVE'
,p_validation_sequence=>20
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  RETURN OC_GENERALES.valida_clabe(:P109_CUENTA_CLAVE);',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>unistr('La cuenta CLABE ingresada no es v\00E1lida.')
,p_validation_condition=>'P109_CUENTA_CLAVE'
,p_validation_condition_type=>'ITEM_IS_NOT_NULL'
,p_when_button_pressed=>wwv_flow_imp.id(498920403949659613)
,p_associated_item=>wwv_flow_imp.id(498892253616659553)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(246202025251629690)
,p_validation_name=>'CUENTA_CLABE_CREATE'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  RETURN OC_GENERALES.valida_clabe(:P109_CUENTA_CLAVE);',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>unistr('La cuenta CLABE ingresada no es v\00E1lida.')
,p_validation_condition=>'P109_CUENTA_CLAVE'
,p_validation_condition_type=>'ITEM_IS_NOT_NULL'
,p_when_button_pressed=>wwv_flow_imp.id(498920767746659613)
,p_associated_item=>wwv_flow_imp.id(498892253616659553)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(184064472486908045)
,p_validation_name=>'VALIDA_CURP'
,p_validation_sequence=>40
,p_validation=>'P109_CURP'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Al aplicar ISR, es necesario ingresar el CURP'
,p_validation_condition=>'P109_INDAPLICAISR'
,p_validation_condition2=>'S'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(184064537955908046)
,p_validation_name=>'VALIDA_CODPOS'
,p_validation_sequence=>50
,p_validation=>'P109_CODIGOZIP'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>unistr('Al aplicar ISR, es necesario ingresar el C\00F3digo Postal')
,p_validation_condition=>'P109_INDAPLICAISR'
,p_validation_condition2=>'S'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(186442754920170203)
,p_validation_name=>'VALIDA_FISICA'
,p_validation_sequence=>70
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE ',
'    es_vacio boolean;',
'   BEGIN',
'        IF :P109_FECNAC IS NULL OR :P109_APELLIDO_PATERNO IS NULL THEN',
'            es_vacio := FALSE;',
'        END IF;',
'        return es_vacio;',
'   END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Hacen falta campos obligatorios para personas F\00EDsicas'),
'    NOMBRE, APELLIDO PATERNO,FECHA NACIMIENTO'))
,p_validation_condition=>'P109_TIPO_PERSONA'
,p_validation_condition2=>'FISICA'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(186443284089170208)
,p_validation_name=>'VALIDA_MORAL'
,p_validation_sequence=>80
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE ',
'    es_vacio boolean;',
'   BEGIN',
'        IF :P109_FECNAC IS NULL THEN',
'            es_vacio := FALSE;',
'        END IF;',
'        return es_vacio;',
'   END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Hacen falta campos obligatorios para personas Morales',
'    NOMBRE, FECHA NACIMIENTO'))
,p_validation_condition=>'P109_TIPO_PERSONA'
,p_validation_condition2=>'MORAL'
,p_validation_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(498918674579659606)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(498918644331659606)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(498919482583659609)
,p_event_id=>wwv_flow_imp.id(498918674579659606)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(430515980919644967)
,p_name=>'DA_FOCUS'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(430516089437644968)
,p_event_id=>wwv_flow_imp.id(430515980919644967)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_TIPO_PERSONA'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(446479394780670265)
,p_name=>'OnClose'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(446479716415670268)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(446479515260670266)
,p_event_id=>wwv_flow_imp.id(446479394780670265)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_ID_BEN_ESP'
,p_attribute_01=>'DIALOG_RETURN_ITEM'
,p_attribute_09=>'N'
,p_attribute_10=>'P1500_BEN_ESP'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(446481975683670291)
,p_name=>'Oculta ID Ben'
,p_event_sequence=>40
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(446482129152670292)
,p_event_id=>wwv_flow_imp.id(446481975683670291)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_ID_BEN_ESP'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(446482392553670295)
,p_name=>'Cambia ID'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P109_ID_BEN_ESP'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(446482528824670296)
,p_event_id=>wwv_flow_imp.id(446482392553670295)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    vApellidoMaterno    VARCHAR2(100);',
'BEGIN',
'    SELECT NOMBRE',
'    INTO :P109_NOMBRE',
'    FROM BENEF_SIN_ESP ',
'    WHERE IDBENEFICIARIO= :P109_ID_BEN_ESP',
'    ;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        :P109_NOMBRE := NULL;',
'END;'))
,p_attribute_02=>'P109_ID_BEN_ESP'
,p_attribute_03=>'P109_NOMBRE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(446482634001670297)
,p_event_id=>wwv_flow_imp.id(446482392553670295)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    vApellidoMaterno    VARCHAR2(100);',
'BEGIN',
'    SELECT APELLIDO_PATERNO',
'    INTO :P109_APELLIDO_PATERNO',
'    FROM BENEF_SIN_ESP ',
'    WHERE IDBENEFICIARIO= :P109_ID_BEN_ESP',
'    ;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        :P109_APELLIDO_PATERNO := NULL;',
'END;'))
,p_attribute_02=>'P109_ID_BEN_ESP'
,p_attribute_03=>'P109_APELLIDO_PATERNO'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(446482725954670298)
,p_event_id=>wwv_flow_imp.id(446482392553670295)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    vApellidoMaterno    VARCHAR2(100);',
'BEGIN',
'    SELECT APELLIDO_MATERNO',
'    INTO :P109_APELLIDO_MATERNO',
'    FROM BENEF_SIN_ESP ',
'    WHERE IDBENEFICIARIO= :P109_ID_BEN_ESP',
'    ;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        :P109_APELLIDO_MATERNO := NULL;',
'END;'))
,p_attribute_02=>'P109_ID_BEN_ESP'
,p_attribute_03=>'P109_APELLIDO_MATERNO'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(446482783111670299)
,p_event_id=>wwv_flow_imp.id(446482392553670295)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_CODPARENT'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'SELECT CODPARENT FROM BENEF_SIN_ESP WHERE IDBENEFICIARIO= :P109_ID_BEN_ESP;'
,p_attribute_07=>'P109_ID_BEN_ESP'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(446482916946670300)
,p_event_id=>wwv_flow_imp.id(446482392553670295)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_PORCEPART'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'SELECT PORCEPART FROM BENEF_SIN_ESP WHERE IDBENEFICIARIO= :P109_ID_BEN_ESP;'
,p_attribute_07=>'P109_ID_BEN_ESP'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(446483049169670301)
,p_event_id=>wwv_flow_imp.id(446482392553670295)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_FECNAC'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'SELECT TO_CHAR(FECNAC,''DD/MM/YYYY'') FROM BENEF_SIN_ESP WHERE IDBENEFICIARIO= :P109_ID_BEN_ESP;'
,p_attribute_07=>'P109_ID_BEN_ESP'
,p_attribute_08=>'N'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(446483105294670302)
,p_event_id=>wwv_flow_imp.id(446482392553670295)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_TIPO_ID_TRIBUTARIO'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'SELECT TIPO_ID_TRIBUTARIO FROM BENEF_SIN_ESP WHERE IDBENEFICIARIO= :P109_ID_BEN_ESP;'
,p_attribute_07=>'P109_ID_BEN_ESP'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(446483245262670303)
,p_event_id=>wwv_flow_imp.id(446482392553670295)
,p_event_result=>'TRUE'
,p_action_sequence=>80
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_NUM_DOC_TRIBUTARIO'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'SELECT NUM_DOC_TRIBUTARIO FROM BENEF_SIN_ESP WHERE IDBENEFICIARIO= :P109_ID_BEN_ESP;'
,p_attribute_07=>'P109_ID_BEN_ESP'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(446483291413670304)
,p_event_id=>wwv_flow_imp.id(446482392553670295)
,p_event_result=>'TRUE'
,p_action_sequence=>90
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_SEXO'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'SELECT SEXO FROM BENEF_SIN_ESP WHERE IDBENEFICIARIO= :P109_ID_BEN_ESP;'
,p_attribute_07=>'P109_ID_BEN_ESP'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(446483404075670305)
,p_event_id=>wwv_flow_imp.id(446482392553670295)
,p_event_result=>'TRUE'
,p_action_sequence=>100
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_ENT_FINANCIERA'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'SELECT ENT_FINANCIERA FROM BENEF_SIN_ESP WHERE IDBENEFICIARIO= :P109_ID_BEN_ESP;'
,p_attribute_07=>'P109_ID_BEN_ESP'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(446483635716670307)
,p_event_id=>wwv_flow_imp.id(446482392553670295)
,p_event_result=>'TRUE'
,p_action_sequence=>110
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_NUMCUENTABANCARIA'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'SELECT NUMCUENTABANCARIA FROM BENEF_SIN_ESP WHERE IDBENEFICIARIO= :P109_ID_BEN_ESP;'
,p_attribute_07=>'P109_ID_BEN_ESP'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(446483854779670309)
,p_event_id=>wwv_flow_imp.id(446482392553670295)
,p_event_result=>'TRUE'
,p_action_sequence=>120
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_CUENTA_CLAVE'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'SELECT CUENTA_CLABE FROM BENEF_SIN_ESP WHERE IDBENEFICIARIO= :P109_ID_BEN_ESP;'
,p_attribute_07=>'P109_ID_BEN_ESP'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(446484007187670311)
,p_event_id=>wwv_flow_imp.id(446482392553670295)
,p_event_result=>'TRUE'
,p_action_sequence=>130
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_NUMCUENTABANCARIA'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(446484180807670313)
,p_name=>'Calcula RFC'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(446484112442670312)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(446484333368670314)
,p_event_id=>wwv_flow_imp.id(446484180807670313)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_NUM_DOC_TRIBUTARIO'
,p_attribute_01=>'FUNCTION_BODY'
,p_attribute_06=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*SELECT ',
'OC_PERSONA_NATURAL_JURIDICA.NUMERO_TRIBUTARIO_RFC(:P109_NOMBRE, :P109_APELLIDO_PATERNO,  :P109_APELLIDO_MATERNO, :P109_FECNAC,''FISICA'') AS D',
'FROM DUAL',
'*/',
'DECLARE',
'    cNum_Tributario VARCHAR2(20);',
'BEGIN',
'    cNum_Tributario := SICAS_OC.OC_GENERARFC.GENERAPRINCIPAL(:P109_NOMBRE, :P109_APELLIDO_PATERNO,:P109_APELLIDO_MATERNO, :P109_FECNAC);',
'	--:P109_NUM_IDENTIFICACION := cNum_Tributario;',
'    IF (:P109_TIPO_PERSONA = ''FISICA'') THEN',
'   -- IF :P109_TIPO_ID_TRIBUTARIO = ''RFC'' THEN',
'         	',
'	    IF NVL(:P109_NUM_DOC_TRIBUTARIO,''X'') != cNum_Tributario THEN',
unistr('            --SET_ALERT_PROPERTY(''CONF_ALERT'',ALERT_MESSAGE_TEXT,''Desea Reemplazar el N\00FAmero de Documento Tributario por este otro ''||cNum_Tributario||''?'');'),
'	 	           ',
'	        --IF SHOW_ALERT(''CONF_ALERT'') = ALERT_BUTTON1 THEN',
'	 	',
'	            :P109_NUM_DOC_TRIBUTARIO := cNum_Tributario;',
'                --:P109_NUM_DOC_TRIBUTARIO := cNum_Tributario;  Esta es la PK',
'                :P109_TIPO_ID_TRIBUTARIO := ''RFC'';',
'                :P109_TP_IDENTIFICACION := ''RFC'';',
'                ',
'                apex_javascript.add_onload_code (p_code => ''apex.item("P109_NUM_IDENTIFICACION").setFocus();'');',
'	 	   -- END IF;',
'        --ELSE',
unistr('            --nDummy := Alerta(''El N\00FAmero Generado es Id\00E9ntico al Capturado en el N\00FAmero de Documento Tributario.'');'),
'  	        --RAISE FORM_TRIGGER_FAILURE;	    	  		 	          ',
'	    END IF;',
'    END IF;',
'',
'    RETURN cNum_Tributario;',
'END;'))
,p_attribute_07=>'P109_NOMBRE,P109_APELLIDO_PATERNO,P109_APELLIDO_MATERNO,P109_FECNAC'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_client_condition_type=>'EQUALS'
,p_client_condition_element=>'P109_TIPO_PERSONA'
,p_client_condition_expression=>'FISICA'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(447212085309675066)
,p_event_id=>wwv_flow_imp.id(446484180807670313)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_NUM_DOC_TRIBUTARIO'
,p_client_condition_type=>'NOT_NULL'
,p_client_condition_element=>'P109_FECNAC'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(447214909611675094)
,p_name=>'Cambia COPARENT ACT'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P109_CODPARENT'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(447215640724675101)
,p_event_id=>wwv_flow_imp.id(447214909611675094)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_CODPARENT_C'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT count(*)',
'        FROM VALORES_DE_LISTAS',
'       WHERE CodLista = ''PARANLIN''',
'         AND CodValor = :P109_CODPARENT'))
,p_attribute_07=>'P109_CODPARENT'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(447215217761675097)
,p_name=>'Cambia COPARENT SI'
,p_event_sequence=>80
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P109_CODPARENT_C'
,p_condition_element=>'P109_CODPARENT_C'
,p_triggering_condition_type=>'GREATER_THAN'
,p_triggering_expression=>'0'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(447215682515675102)
,p_event_id=>wwv_flow_imp.id(447215217761675097)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_TIPO_ID_TRIBUTARIO'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'RFC'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(447215838006675103)
,p_event_id=>wwv_flow_imp.id(447215217761675097)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_PORCENTISR'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'20'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(447215866658675104)
,p_event_id=>wwv_flow_imp.id(447215217761675097)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_INDAPLICAISR'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'S'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(447215424586675099)
,p_name=>'Cambia COPARENT_NO'
,p_event_sequence=>90
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P109_CODPARENT_C'
,p_condition_element=>'P109_CODPARENT_C'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'0'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(447216001593675105)
,p_event_id=>wwv_flow_imp.id(447215424586675099)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_TIPO_ID_TRIBUTARIO'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'RFC'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(447216159326675106)
,p_event_id=>wwv_flow_imp.id(447215424586675099)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_PORCENTISR'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(447216208287675107)
,p_event_id=>wwv_flow_imp.id(447215424586675099)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_INDAPLICAISR'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'N'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(420706092182509645)
,p_name=>'tipopago'
,p_event_sequence=>100
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P109_IDTIPO_PAGO'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(420706261009509646)
,p_event_id=>wwv_flow_imp.id(420706092182509645)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if ($v("P109_IDTIPO_PAGO") == "CHQ") {',
'           $s("P109_ENT_FINANCIERA","012");',
'}',
'if ($v("P109_IDTIPO_PAGO") == "TRS") {',
'           $s("P109_ENT_FINANCIERA","012");',
'}',
'if ($v("P109_IDTIPO_PAGO") == "SSIT") {',
'           $s("P109_ENT_FINANCIERA","012");',
'//           :BK_BENEF.COD_CONVENIO   := OC_VALORES_DE_LISTAS.BUSCA_LVALOR(''CONVENIO'',:BK_BENEF.ENT_FINANCIERA);',
'}',
'if ($v("P109_IDTIPO_PAGO") == "RST") {',
'           $s("P109_ENT_FINANCIERA","012");',
'}',
''))
);
end;
/
begin
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(420709656522509680)
,p_name=>'cambio en banco'
,p_event_sequence=>110
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P109_ENT_FINANCIERA'
,p_condition_element=>'P109_ENT_FINANCIERA'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'012'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(420709750203509681)
,p_event_id=>wwv_flow_imp.id(420709656522509680)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_CUENTA_CLAVE'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(420709926432509683)
,p_event_id=>wwv_flow_imp.id(420709656522509680)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_CUENTA_CLAVE'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(420709993362509684)
,p_event_id=>wwv_flow_imp.id(420709656522509680)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_NUMCUENTABANCARIA'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(420709810369509682)
,p_event_id=>wwv_flow_imp.id(420709656522509680)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_NUMCUENTABANCARIA'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(420710165296509685)
,p_name=>'cambio en ISR'
,p_event_sequence=>120
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P109_INDAPLICAISR'
,p_condition_element=>'P109_INDAPLICAISR'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'S'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(420710220502509686)
,p_event_id=>wwv_flow_imp.id(420710165296509685)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_PORCENTISR'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(420710325609509687)
,p_event_id=>wwv_flow_imp.id(420710165296509685)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_PORCENTISR'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(184064232855908043)
,p_event_id=>wwv_flow_imp.id(420710165296509685)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'CURP_REQUE'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.item("P109_CURP").setRequired(true);',
'apex.item("P109_CODIGOZIP").setRequired(true);'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(184064339020908044)
,p_event_id=>wwv_flow_imp.id(420710165296509685)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'CURP_NOREQ'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.item("P109_CURP").setRequired(false);',
'apex.item("P109_CODIGOZIP").setRequired(true);'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(388913136680096890)
,p_name=>'New'
,p_event_sequence=>130
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(388913169389096891)
,p_event_id=>wwv_flow_imp.id(388913136680096890)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_NOMBRE_MINORIA,P109_PORC_MINORIA'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(388913342346096892)
,p_name=>'cambia minoria'
,p_event_sequence=>140
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P109_ID_EDAD_MINORIA'
,p_condition_element=>'P109_ID_EDAD_MINORIA'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'S'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(388913422135096893)
,p_event_id=>wwv_flow_imp.id(388913342346096892)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_NOMBRE_MINORIA,P109_PORC_MINORIA'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(388913446893096894)
,p_event_id=>wwv_flow_imp.id(388913342346096892)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_NOMBRE_MINORIA,P109_PORC_MINORIA'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(309296675216514383)
,p_name=>'DA_VALIDA_CLABE'
,p_event_sequence=>150
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P109_CUENTA_CLAVE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keyup'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(310462147169478634)
,p_event_id=>wwv_flow_imp.id(309296675216514383)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('// Limpia cualquier temporizador anterior para evitar m\00FAltiples llamadas mientras el usuario sigue escribiendo'),
'clearTimeout(window._clabeTimer);',
'',
unistr('// Establece un nuevo temporizador que se ejecuta 300 ms despu\00E9s del \00FAltimo evento de teclado'),
'window._clabeTimer = setTimeout(function () {',
'',
'  // Llama al proceso Ajax definido en APEX llamado "VAL_CLABE"',
'  apex.server.process("VAL_CLABE", {',
unistr('    // Env\00EDa el valor del campo CLABE como par\00E1metro del proceso'),
'    pageItems: "#P109_CUENTA_CLAVE"',
'  }, {',
'    // Espera una respuesta de tipo texto (no JSON)',
'    dataType: "text",',
'',
unistr('    // Funci\00F3n a ejecutar cuando se recibe una respuesta del proceso'),
'    success: function (response) {',
unistr('      // Limpia cualquier mensaje de error existente en la p\00E1gina'),
'      apex.message.clearErrors();',
'',
unistr('      // Si la respuesta es "ERROR", muestra un mensaje de validaci\00F3n en el campo'),
'      if (response.trim() === "ERROR") {',
'        apex.message.showErrors([{',
'          type: "error",                // Tipo de mensaje',
unistr('          location: "inline",           // Ubicaci\00F3n: junto al campo'),
unistr('          pageItem: "P109_CUENTA_CLAVE",// \00CDtem al que se asocia el mensaje'),
unistr('          message: "La cuenta CLABE ingresada no es v\00E1lida.", // Texto del error'),
'          unsafe: false                 // Escapa HTML para evitar problemas de seguridad',
'        }]);',
'      }',
'    }',
'  });',
'',
unistr('}, 300); // Tiempo de espera antes de ejecutar la validaci\00F3n (en milisegundos)'),
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(310565929286211753)
,p_name=>'GetValueInsert'
,p_event_sequence=>160
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P109_CUENTA_CLAVE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_required_patch=>wwv_flow_imp.id(437659831918685547)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(310566026919211754)
,p_event_id=>wwv_flow_imp.id(310565929286211753)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var vGetValueInsert;',
'',
'vGetValueInsert = $v( "P109_CUENTA_CLAVE" );',
'',
'apex.message.alert( "##Valor Cuenta Clabe:: " + vGetValueInsert );',
'',
'apex.item( "P109_CUENTA_CLABE_CTRL" ).setValue( "#" + vGetValueInsert);'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(184064620907908047)
,p_name=>'VALIDA_FISICA'
,p_event_sequence=>170
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P109_TIPO_PERSONA'
,p_condition_element=>'P109_TIPO_PERSONA'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'FISICA'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(186442918685170205)
,p_event_id=>wwv_flow_imp.id(184064620907908047)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_APELLIDO_PATERNO, P109_APELLIDO_MATERNO'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT NVL(APELLIDO_PATERNO,'''') APELLIDO_PATERNO ,NVL(APELLIDO_MATERNO,'''') APELLIDO_MATERNO',
'FROM BENEF_SIN ',
'WHERE IDSINIESTRO = :P109_IDSINIESTRO',
'    AND IDPOLIZA =  :P109_IDPOLIZA ',
'    AND BENEF = :P109_BENEF',
'    AND ROWNUM <= 1;',
''))
,p_attribute_07=>'P109_IDSINIESTRO,P109_IDPOLIZA,P109_BENEF'
,p_attribute_08=>'Y'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(184064786807908048)
,p_event_id=>wwv_flow_imp.id(184064620907908047)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'apex.item(''P109_APELLIDO_PATERNO'').enable();',
'apex.item(''P109_APELLIDO_MATERNO'').enable();',
'',
'apex.item("P109_APELLIDO_PATERNO").setRequired(true);',
'apex.item("P109_APELLIDO_MATERNO").setRequired(true);',
''))
,p_client_condition_type=>'NULL'
,p_client_condition_element=>'P109_APELLIDO_PATERNO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(186443052479170206)
,p_event_id=>wwv_flow_imp.id(184064620907908047)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_APELLIDO_PATERNO,P109_APELLIDO_MATERNO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(184064913815908050)
,p_name=>'VALIDA_MORAL'
,p_event_sequence=>180
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P109_TIPO_PERSONA'
,p_condition_element=>'P109_TIPO_PERSONA'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'MORAL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(186443314469170209)
,p_event_id=>wwv_flow_imp.id(184064913815908050)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_APELLIDO_PATERNO,P109_APELLIDO_MATERNO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(186442536518170201)
,p_event_id=>wwv_flow_imp.id(184064913815908050)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.item("P109_APELLIDO_PATERNO").disable();',
'apex.item("P109_APELLIDO_MATERNO").disable();',
'',
'apex.item("P109_APELLIDO_PATERNO").setRequired(false);',
'apex.item("P109_APELLIDO_MATERNO").setRequired(false);',
''))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(186442793492170204)
,p_event_id=>wwv_flow_imp.id(184064913815908050)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_APELLIDO_PATERNO,P109_APELLIDO_MATERNO'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT '''' APELLIDO_PATERNO,'''' APELLIDO_MATERNO ',
'FROM DUAL;'))
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(382085968144100281)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(186443141854170207)
,p_event_id=>wwv_flow_imp.id(184064913815908050)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P109_APELLIDO_PATERNO,P109_APELLIDO_MATERNO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(186443465446170210)
,p_name=>'Ejec_TabNombre'
,p_event_sequence=>190
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P109_NOMBRE'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === 9'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keydown'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(186443554579170211)
,p_event_id=>wwv_flow_imp.id(186443465446170210)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.jQuery(''#btn_rfc'').click();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(186443640229170212)
,p_name=>'Ejec_TabPaterno'
,p_event_sequence=>200
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P109_APELLIDO_PATERNO'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === 9'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keydown'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(186443781985170213)
,p_event_id=>wwv_flow_imp.id(186443640229170212)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.jQuery(''#btn_rfc'').click();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(186443827187170214)
,p_name=>'Ejec_TabMaterno'
,p_event_sequence=>210
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P109_APELLIDO_MATERNO'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === 9'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keydown'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(186443907713170215)
,p_event_id=>wwv_flow_imp.id(186443827187170214)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.jQuery(''#btn_rfc'').click();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(186444003930170216)
,p_name=>'Ejec_TabNacim'
,p_event_sequence=>220
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P109_FECNAC'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.which === 9'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keydown'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(186444169748170217)
,p_event_id=>wwv_flow_imp.id(186444003930170216)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.jQuery(''#btn_rfc'').click();'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(346456254957268688)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'New'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P109_CODCIA:=:codcia;',
':P109_CODEMPRESA:=:codempresa;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>20046810357260831
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(442242467074727270)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(498885041473659533)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Beneficiarios'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>115833022474719413
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(498922041494659616)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>172512596894651759
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(430517317577644980)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'cargar_nro_benef'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF :P109_CN_BENEF IS NULL THEN',
'    BEGIN ',
'        SELECT COUNT(B.BENEF) + 1',
'          INTO :P109_BENEF',
'          FROM BENEF_SIN B',
'         WHERE B.IDPOLIZA = :P109_CN_POLIZA',
'           AND B.IDSINIESTRO = :P109_CN_SINIESTRO;',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN ',
'        :P109_BENEF := 1;',
'        WHEN OTHERS THEN',
'        :P109_BENEF := 99;',
'    END;',
'ELSE',
':P109_BENEF := :P109_CN_BENEF;',
':P109_CODCIA := :P109_CN_CODCIA;',
'/*',
'',
' SELECT IDSINIESTRO,',
' IDPOLIZA,',
' BENEF,',
' NOMBRE,',
' APELLIDO_PATERNO,',
' APELLIDO_MATERNO,',
' CODPARENT,',
' SEXO,',
' FECALTA,',
' PORCEPART,',
' COD_ASEGURADO,',
' FECBAJA,',
' MOTBAJA,',
' DIRECCION,',
' INDPAGO,',
' PORCEAPL,',
' TIPO_PAGO,',
' CODCIA,',
' CODEMPRESA,',
' CODUSUARIO,',
' FECREGISTRO,',
' SIT_CLIENTE,',
' SIT_REFERENCIA,',
' SIT_CONCEPTO,',
' IDREGFISSAT,',
' ROWID',
' INTO :P109_IDSINIESTRO,',
':P109_IDPOLIZA,',
':P109_BENEF,',
':P109_NOMBRE,',
':P109_APELLIDO_PATERNO,',
':P109_APELLIDO_MATERNO,',
':P109_CODPARENT,',
':P109_SEXO,',
':P109_FECALTA,',
':P109_PORCEPART,',
':P109_COD_ASEGURADO,',
':P109_FECBAJA,',
':P109_MOTBAJA,',
':P109_DIRECCION,',
':P109_INDPAGO,',
':P109_PORCEAPL,',
':P109_TIPO_PAGO,',
':P109_CODCIA,',
':P109_CODEMPRESA,',
':P109_CODUSUARIO,',
':P109_FECREGISTRO,',
':P109_SIT_CLIENTE,',
':P109_SIT_REFERENCIA,',
':P109_SIT_CONCEPTO,',
':P109_IDREGFISSAT,',
':P109_ROWID',
'      FROM BENEF_SIN  B',
'     WHERE B.IDPOLIZA = :P109_CN_POLIZA     ',
'       AND B.IDSINIESTRO = :P109_CN_SINIESTRO',
'       AND B.BENEF = :P109_CN_BENEF;',
'*/',
'END IF;',
'',
':P109_IDPOLIZA := :P109_CN_POLIZA;',
':P109_IDSINIESTRO := :P109_CN_SINIESTRO;',
':P109_COD_ASEGURADO :=  :P109_CN_CODASEGURADO;'))
,p_process_clob_language=>'PLSQL'
,p_process_error_message=>unistr('No se carg\00F3 el Nro. del Beneficiario.')
,p_internal_uid=>104107872977637123
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(442242636509727271)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(498885041473659533)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'get record'
,p_internal_uid=>115833191909719414
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(310462214443478635)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'VAL_CLABE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  IF OC_GENERALES.valida_clabe(:P109_CUENTA_CLAVE) THEN',
'    HTP.P(''OK'');',
'  ELSE',
'    HTP.P(''ERROR'');',
'  END IF;',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    HTP.P(''ERROR'');',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>35385301836849002
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

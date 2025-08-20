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
,p_default_workspace_id=>125
,p_default_application_id=>111
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
--     PAGE: 103
--   Manifest End
--   Version:         23.2.0
--   Instance ID:     709450366953385
--

begin
null;
end;
/
prompt --application/pages/delete_00103
begin
wwv_flow_imp_page.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>103);
end;
/
prompt --application/pages/page_00103
begin
wwv_flow_imp_page.create_page(
 p_id=>103
,p_name=>'Alta de Siniestros'
,p_alias=>'ALTA-DE-SINIESTROS'
,p_step_title=>'Alta de Siniestros'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'16'
,p_last_updated_by=>'OCOLMENARES'
,p_last_upd_yyyymmddhh24miss=>'20250806161810'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(202738345101469791)
,p_plug_name=>'Alta de Siniestros'
,p_region_css_classes=>'bread'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(162652651220056151)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(162583490167055928)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_imp.id(162754962104056361)
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(217927744459922908)
,p_plug_name=>'Detalle'
,p_region_template_options=>'#DEFAULT#:t-Form--slimPadding'
,p_plug_template=>wwv_flow_imp.id(162620056042056097)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(223885474974100869)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_button_name=>'buscar'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--primary:t-Button--iconLeft:t-Button--padTop'
,p_button_template_id=>wwv_flow_imp.id(162753536795056358)
,p_button_image_alt=>'Buscar'
,p_icon_css_classes=>'fa-search'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(151271787686177989)
,p_button_sequence=>500
,p_button_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_button_name=>'conalep'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch:t-Button--padLeft:t-Button--padRight:t-Button--padTop:t-Button--padBottom'
,p_button_template_id=>wwv_flow_imp.id(162753354903056358)
,p_button_image_alt=>'CONALEP'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
,p_grid_column_span=>2
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(170866510921204551)
,p_button_sequence=>520
,p_button_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_button_name=>'conalep_1'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--padLeft:t-Button--padRight:t-Button--padTop:t-Button--padBottom'
,p_button_template_id=>wwv_flow_imp.id(162752652549056350)
,p_button_image_alt=>'CONALEP'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(151271882362177990)
,p_button_sequence=>530
,p_button_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_button_name=>'DAFI'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch:t-Button--padLeft:t-Button--padRight:t-Button--padTop:t-Button--padBottom'
,p_button_template_id=>wwv_flow_imp.id(162753354903056358)
,p_button_image_alt=>'DAFI'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
,p_grid_column_span=>2
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(170867121320204557)
,p_button_sequence=>560
,p_button_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_button_name=>'DAFI_1'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--padLeft:t-Button--padRight:t-Button--padTop:t-Button--padBottom'
,p_button_template_id=>wwv_flow_imp.id(162752652549056350)
,p_button_image_alt=>'DAFI'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(53166530660504621)
,p_button_sequence=>650
,p_button_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_button_name=>'info_siniestro'
,p_button_static_id=>'info_siniestro'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(162753354903056358)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'info_siniestro'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(229533938903641978)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(202738345101469791)
,p_button_name=>'VOLVER'
,p_button_static_id=>'volver'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(162752652549056350)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Volver'
,p_button_position=>'BOTTOM'
,p_button_redirect_url=>'f?p=&APP_ID.:&P103_PAGINA.:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-arrow-left-alt'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(201410199852730396)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_button_name=>'gRABAR'
,p_button_static_id=>'gRABAR'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_imp.id(162753354903056358)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Grabar'
,p_button_position=>'TOP'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(55667772990358921)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_button_name=>'gRABAR_1'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>wwv_flow_imp.id(162753354903056358)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Grabar'
,p_button_position=>'TOP'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(201410593318730400)
,p_branch_name=>'SALIR'
,p_branch_action=>'f?p=&APP_ID.:100:&SESSION.::&DEBUG.:103::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(201410199852730396)
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(53167306809504629)
,p_branch_name=>'Go To Page 1031'
,p_branch_action=>'f?p=&APP_ID.:1031:&SESSION.::&DEBUG.:CR,1031:P1031_IDPOLIZA,P1031_CURP,P1031_TIPO_CONSULTA,P1031_RFC,P1031_COD_ASEGURADO,P1031_SINIESTROS_PAS,P1031_UNDERAGE:&P103_IDPOLIZA.,&P103_CURP.,&P103_TIPO_BUSQUEDA.,&P103_NUM_TRIBUTARIO.,&P103_COD_ASEGURADO.,&P103_SINIESTROS_PAS.,&P103_UNDERAGE.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(53166530660504621)
,p_branch_sequence=>20
,p_branch_condition_type=>'ITEM_IS_NOT_NULL'
,p_branch_condition=>'P103_TIPO_BUSQUEDA'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53166744931504623)
,p_name=>'P103_TIPO_BUSQUEDA'
,p_item_sequence=>660
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53904476902257808)
,p_name=>'P103_UNDERAGE'
,p_item_sequence=>670
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53906578228257829)
,p_name=>'P103_EDAD_ASEGURADO'
,p_item_sequence=>680
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(71376281321639025)
,p_name=>'P103_PAGINA'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(91587229349740906)
,p_name=>'P103_IDTPORIGEN_1'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Flujo Siniestro'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CodValor||'' - ''||DescValLst descrip,CodValor',
'  FROM VALORES_DE_LISTAS',
'WHERE CodLista = ''TIPORI''',
'ORDER BY DescValLst'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(91587338434740907)
,p_name=>'P103_AUTORIZACION_REQUERIDA_1'
,p_item_sequence=>360
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>unistr('Autorización')
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(91587455189740908)
,p_name=>'P103_CODRIESGOREA_1'
,p_item_sequence=>380
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Tipo Reaseguro'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'      SELECT codriesgo||'' - ''||DescRiesgo descrip,codriesgo',
'        FROM REA_RIESGOS',
'       WHERE CodCia     = nvl(:CodCia,1)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(91587563681740909)
,p_name=>'P103_IDCONTRIBUTORIO_1'
,p_item_sequence=>340
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>unistr('Tipo Pago Póliza')
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:N - NO CONTRIBUTORIO;N,S - CONTRIBUTORIO;S'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(91587653460740910)
,p_name=>'P103_COD_MONEDA_1'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Moneda'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'MONEDAS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ''%'' Cod_Moneda, ''TODAS'' Desc_Moneda',
'  FROM DUAL',
' UNION',
'SELECT Cod_Moneda, Desc_Moneda',
'  FROM MONEDA '))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_grid_column=>10
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(137566512728503170)
,p_name=>'P103_IDCREDITO'
,p_item_sequence=>550
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>unistr('Nro. de Crédito')
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(138046364804858337)
,p_name=>'P103_CODASEGURADO_HIDE'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(148272514917637778)
,p_name=>'P103_CODASEG_MIG'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(150323522193061674)
,p_name=>'P103_SINIESTROS_PAS'
,p_item_sequence=>640
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(151271954407177991)
,p_name=>'P103_CODPLANTEL'
,p_item_sequence=>510
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Plantel'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT DescValLst, CodValor',
'  FROM VALORES_DE_LISTAS',
'WHERE CodLista = ''PLANTEL''',
'ORDER BY DescValLst'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(151272034682177992)
,p_name=>'P103_EMPRESA_LABORA'
,p_item_sequence=>540
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Empresa'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(153150448822095045)
,p_name=>'P103_NAMEASEG'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(170865263353204539)
,p_name=>'P103_DAFI_VAL'
,p_item_sequence=>570
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(201410098887730395)
,p_name=>'P103_IDCOLEINDI'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(201410426595730398)
,p_name=>'P103_FECREGISTRO'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(201410474844730399)
,p_name=>'P103_CODUSUARIO'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202739212510475508)
,p_name=>'P103_IDPOLIZA'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>unistr('Póliza Consecutivo')
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(162752183495056348)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202739609956475516)
,p_name=>'P103_FECINIVIG'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Inicio Vigencia'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202740022739475516)
,p_name=>'P103_FECFINVIG'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Fin Vigencia'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'Y'
,p_attribute_03=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202740383784475517)
,p_name=>'P103_IDSINIESTRO'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Siniestro'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202740753049475519)
,p_name=>'P103_NNUMPOLUNICO'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>unistr('Póliza Única')
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202741205058475519)
,p_name=>'P103_NOMCONTRATANTE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Contratante'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202741584983475520)
,p_name=>'P103_NUMSINIREF'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'No. de Referencia'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>30
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202742032480475520)
,p_name=>'P103_COD_MONEDA'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202742358860475525)
,p_name=>'P103_COD_ASEGURADO'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Asegurado'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'ASEG_ALTA_SIN'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT D.Cod_Asegurado||'' - ''||SUBSTR(OC_ASEGURADO.NOMBRE_ASEGURADO(D.CodCia, D.CodEmpresa, D.Cod_Asegurado),1,300) NombreAseg, D.Cod_Asegurado',
'  FROM DETALLE_POLIZA D',
' WHERE IdPoliza = :p103_IdPoliza',
'   AND CodCia   = nvl(:CodCia,1)',
'   AND OC_ASEGURADO_CERTIFICADO.TIENE_ASEGURADOS(CodCia, IdPoliza, IDetPol, 0) = ''N''',
' UNION ALL',
'SELECT A.Cod_Asegurado||'' - ''||SUBSTR(OC_ASEGURADO.NOMBRE_ASEGURADO(D.CodCia, D.CodEmpresa, A.Cod_Asegurado),1,300) NombreAseg, A.Cod_Asegurado',
'  FROM DETALLE_POLIZA D, ASEGURADO_CERTIFICADO A',
' WHERE A.IDetPol  = D.IDetPol',
'   AND A.IdPoliza = D.IdPoliza',
'   AND D.IdPoliza = :p103_IdPoliza',
'   AND D.CodCia   = nvl(:CodCia,1)',
'   AND A.COD_ASEGURADO = NVL(:P103_CODASEGURADO_HIDE,A.COD_ASEGURADO)',
''))
,p_lov_cascade_parent_items=>'P103_IDPOLIZA'
,p_ajax_items_to_submit=>'P103_IDPOLIZA,P103_COD_ASEGURADO'
,p_ajax_optimize_refresh=>'Y'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202742773193475526)
,p_name=>'P103_NOMIDCOLEINDI'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>unistr('Tipo de Póliza')
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202743219279475530)
,p_name=>'P103_IDETPOL'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Detalle/Subgrupo'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT d.idetpol||'' - ''||t.descripcion Detalle_Subgrupo, D.idetpol',
'  FROM DETALLE_POLIZA D,TIPOS_DE_SEGUROS T',
' WHERE d.IdPoliza = :p103_IdPoliza',
'   and D.Cod_Asegurado = :P103_COD_ASEGURADO',
'   and T.IdTipoSeg  = D.IdTipoSeg',
'       AND T.CodEmpresa = D.CodEmpresa',
'       AND T.CodCia     = D.CodCia',
'   AND d.CodCia   = nvl(:CodCia,1)',
'   AND OC_ASEGURADO_CERTIFICADO.TIENE_ASEGURADOS(d.CodCia, d.IdPoliza, d.IDetPol, 0) = ''N''',
' UNION',
'SELECT d.idetpol||'' - ''||t.descripcion  Detalle_Subgrupo, D.idetpol',
'  FROM DETALLE_POLIZA D, ASEGURADO_CERTIFICADO A,TIPOS_DE_SEGUROS T',
' WHERE A.IDetPol  = D.IDetPol',
'   and a.cod_asegurado = :P103_COD_ASEGURADO',
'   AND A.IdPoliza = D.IdPoliza',
'   and T.IdTipoSeg  = D.IdTipoSeg',
'       AND T.CodEmpresa = D.CodEmpresa',
'       AND T.CodCia     = D.CodCia',
'   AND D.IdPoliza = :p103_IdPoliza',
'   AND D.CodCia   = nvl(:CodCia,1)',
'',
'',
'',
''))
,p_lov_cascade_parent_items=>'P103_COD_ASEGURADO,P103_IDPOLIZA'
,p_ajax_items_to_submit=>'P103_COD_ASEGURADO,P103_IDPOLIZA'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202743559726475530)
,p_name=>'P103_STS_SINIESTRO'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Status Siniestro'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'ESTATUS DE SINIESTROS'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'      SELECT CODVALOR||'' - ''||DescValLst DescValLst,CODVALOR',
'        ',
'        FROM VALORES_DE_LISTAS',
'       WHERE CodLista = ''ESTADOS'''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202743997678475531)
,p_name=>'P103_TIPO_SINIESTRO'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Tipo de Siniestro'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT  CodValor||'' - ''||DescValLst as des, CodValor',
'  FROM VALORES_DE_LISTAS',
'WHERE CodLista = ''TIPOSINI'''))
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202744421034475533)
,p_name=>'P103_FECSTS'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Fecha de Estatus'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202744824809475533)
,p_name=>'P103_MOTIVO_DE_SINIESTRO'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Causas de Siniestros'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT A.CAGE_ID_CONCEP_ALF||'' - ''||A.CAGE_VALOR_LARGO DESCRIP, A.CAGE_ID_CONCEP_ALF',
'FROM SAI_CAT_GENERAL A',
'WHERE A.CAGE_CD_CATALOGO = 1',
'ORDER BY 2',
''))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(162752183495056348)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202745228425475534)
,p_name=>'P103_MONTO_RESERVA_MONEDA'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Monto Reserva'
,p_format_mask=>'999,999,990.00'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202745584993475534)
,p_name=>'P103_SUBMOTIVO_SINIESTRO'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Diagnostico'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT A.CAGE_VALOR_LARGO, A.CAGE_NOM_CONCEP',
'  FROM SAI_CAT_GENERAL A',
' WHERE A.CAGE_CD_CATALOGO   = 9',
'   AND A.CAGE_CD_ESTATUS    = ''ACT''',
'   AND A.CAGE_ID_CONCEP_ALF = :P103_MOTIVO_DE_SINIESTRO',
' ORDER BY A.CAGE_NOM_CONCEP ',
''))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P103_MOTIVO_DE_SINIESTRO'
,p_ajax_items_to_submit=>'P103_MOTIVO_DE_SINIESTRO,P103_SUBMOTIVO_SINIESTRO'
,p_ajax_optimize_refresh=>'Y'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202745966658475542)
,p_name=>'P103_MONTO_PAGO_MONEDA'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Monto Pagado'
,p_format_mask=>'999,999,990.00'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202746389189475542)
,p_name=>'P103_FEC_OCURRENCIA'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Fecha Ocurrencia'
,p_format_mask=>'DD/MM/RRRR'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_colspan=>3
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'POPUP'
,p_attribute_03=>'NONE'
,p_attribute_06=>'NONE'
,p_attribute_09=>'N'
,p_attribute_11=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202746839317475544)
,p_name=>'P103_FEC_NOTIFICACION'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>unistr('Fecha Notificación')
,p_format_mask=>'DD/MM/RRRR'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_grid_column=>5
,p_field_template=>wwv_flow_imp.id(162752183495056348)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'POPUP'
,p_attribute_03=>'NONE'
,p_attribute_06=>'NONE'
,p_attribute_09=>'N'
,p_attribute_11=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202747239583475544)
,p_name=>'P103_NMTOPEND'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Monto Pendiente'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_grid_column=>10
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'VALUE'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLAIN'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202747637996475545)
,p_name=>'P103_IDTPORIGEN'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202748038825475547)
,p_name=>'P103_IDCONTRIBUTORIO'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202748403375475547)
,p_name=>'P103_AUTORIZACION_REQUERIDA'
,p_item_sequence=>350
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202748780427475548)
,p_name=>'P103_CODRIESGOREA'
,p_item_sequence=>370
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202749173685475550)
,p_name=>'P103_DESC_SINIESTRO'
,p_item_sequence=>390
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>unistr('Descripción de Siniestro')
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'Y'
,p_attribute_02=>'N'
,p_attribute_03=>'N'
,p_attribute_04=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202749576253475551)
,p_name=>'P103_CODPAISOCURR'
,p_item_sequence=>400
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>unistr('País')
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'SELECT codpais||'' - ''||DescPais descr, CodPais FROM PAIS'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202750018437475553)
,p_name=>'P103_CODPROVEEDOR'
,p_item_sequence=>440
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Hospital'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CodProveedor||'' - ''||SUBSTR(OC_PROVEEDORES.NOMBRE_PROVEEDOR(CodCia, CodProveedor),1,100) NomProveedor,CodProveedor',
'  FROM PROVEEDORES',
' WHERE CODCIA         = :CodCia',
'   AND CLASEPROVEEDOR = ''HOSPIT''',
' ORDER BY 2 ASC',
''))
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202750428354475553)
,p_name=>'P103_CODPROVOCURR'
,p_item_sequence=>410
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Estado'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CodEstado||'' - ''||DescEstado AS DESCRIP, CodEstado',
'  FROM PROVINCIA',
' WHERE CodPais = :P103_CODPAISOCURR',
''))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P103_CODPAISOCURR'
,p_ajax_items_to_submit=>'P103_CODPAISOCURR,P103_CODPROVOCURR'
,p_ajax_optimize_refresh=>'Y'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>wwv_flow_imp.id(162752183495056348)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202750785800475556)
,p_name=>'P103_NOM_MEDICO_CERTIFICA'
,p_item_sequence=>450
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>unistr('Médico')
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>4
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202751158473475561)
,p_name=>'P103_NUM_TRIBUTARIO'
,p_item_sequence=>480
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'RFC'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>4
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
end;
/
begin
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202751558283475562)
,p_name=>'P103_CODMUNICIPIO'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Municipio'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT M.CODMUNICIPIO||'' - ''||M.DESCMUNICIPIO descrip,',
'       M.CODMUNICIPIO       ',
'  FROM CORREGIMIENTO M',
' WHERE M.CODPAIS   = :p103_CODPAISOCURR',
'   AND M.CODESTADO = :p103_CODPROVOCURR',
' ORDER BY M.DESCMUNICIPIO',
''))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P103_CODPAISOCURR,P103_CODPROVOCURR'
,p_ajax_items_to_submit=>'P103_CODPAISOCURR,P103_CODPROVOCURR,P103_CODMUNICIPIO'
,p_ajax_optimize_refresh=>'Y'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(162752183495056348)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'POPUP'
,p_attribute_02=>'FIRST_ROWSET'
,p_attribute_03=>'N'
,p_attribute_04=>'N'
,p_attribute_05=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202751968258475566)
,p_name=>'P103_ID_CEDULA_MEDICA'
,p_item_sequence=>460
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Cedula'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202752372943475566)
,p_name=>'P103_NOMNUMSEMANA'
,p_item_sequence=>470
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'VoBo Comercial'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202752798073475567)
,p_name=>'P103_CURP'
,p_item_sequence=>490
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'CURP'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_attribute_01=>'N'
,p_attribute_02=>'N'
,p_attribute_04=>'TEXT'
,p_attribute_05=>'BOTH'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(202753209253475567)
,p_name=>'P103_TP_ASEGURADO'
,p_item_sequence=>430
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_prompt=>'Tipo de Asegurado'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CodValor||'' - ''||DescValLst, CodValor',
'  FROM VALORES_DE_LISTAS',
'WHERE CodLista = ''TIPOASEG''',
'ORDER BY DescValLst'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>wwv_flow_imp.id(162750909397056345)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(207024418130295904)
,p_name=>'P103_CNUMPOLREF_OBS'
,p_item_sequence=>580
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(207024521740295905)
,p_name=>'P103_CNUMPOLREF'
,p_item_sequence=>590
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(223885660248100871)
,p_name=>'P103_ERR_FECO'
,p_item_sequence=>600
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(223886268727100877)
,p_name=>'P103_IDENDOSO'
,p_item_sequence=>620
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(230469047367096078)
,p_name=>'P103_RFC_ASEGURADO'
,p_item_sequence=>630
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(230820801623965089)
,p_name=>'P103_ERR_FECN'
,p_item_sequence=>610
,p_item_plug_id=>wwv_flow_imp.id(217927744459922908)
,p_display_as=>'NATIVE_HIDDEN'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(223886394301100878)
,p_validation_name=>'Fecha Ocurrencia'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'Dummy NUMBER;',
'nValid  NUMBER(1) := 0;',
'dFecIniVig DATE;',
'dFecFinVig DATE;',
'dFecAnul DATE;',
'CIDPAGOS VARCHAR(2);',
'DFECINIVIGPAG  DATE;',
'DFECFINVIGPAG  DATE;',
'DFECPERESPERA  DATE;',
'CSTSPOLIZA POLIZAS.STSPOLIZA%TYPE;',
'CINDFACTURAPOL POLIZAS.INDFACTURAPOL%TYPE;',
'NDIASCANCELACION TIPOS_DE_SEGUROS.DIASCANCELACION%TYPE;',
'NIDFACTURA FACTURAS.IDFACTURA%TYPE;',
'BEGIN',
':P103_ERR_FECO:= null;',
'BEGIN',
'SELECT FecIniVig,',
'FecFinVig,',
'FecAnul,',
'STSPOLIZA,',
'INDFACTURAPOL',
'INTO dFecIniVig,',
'DFecFinVig,',
'dFecAnul,',
'CSTSPOLIZA,',
'CINDFACTURAPOL',
'FROM POLIZAS ',
'WHERE IdPoliza = :P103_IDPOLIZA;',
'exCEPTION',
'WHEN NO_DATA_FOUND THEN',
'raise_application_error(-20105,''No existe la poliza (FEC_OCURRENCIA)'');',
' WHEN OTHERS THEN',
'raise_application_error(-20105,''Poliza con problemas (FEC_OCURRENCIA-OTHERS)'');',
'eND;',
'BEGIN',
'SELECT TS.DIASCANCELACION',
'INTO NDIASCANCELACION',
'FROM DETALLE_POLIZA DP,',
'TIPOS_DE_SEGUROS TS  ',
'WHERE DP.IDPOLIZA = :P103_IdPoliza',
'AND DP.IDETPOL  = (SELECT MIN(DP1.IDETPOL)',
'FROM DETALLE_POLIZA DP1',
'WHERE DP1.IDPOLIZA = DP.IDPOLIZA)',
'AND TS.IDTIPOSEG  = DP.IDTIPOSEG',
'AND TS.CODCIA  = DP.CODCIA',
'AND TS.CODEMPRESA = DP.CODEMPRESA;',
'EXCEPTION',
'WHEN NO_DATA_FOUND THEN',
':P103_ERR_FECO:=''No existe la poliza (FEC_OCURRENCIA 1)'';',
'WHEN OTHERS THEN',
':P103_ERR_FECO:=''Poliza con problemas (FEC_OCURRENCIA 1-OTHERS)'';',
'eND; ',
'IF :P103_Fec_Ocurrencia IS NULL THEN ',
':P103_ERR_FECO:=''La Fecha de OCURRENCIA, es obligatorioa'';',
'END IF; ',
'IF to_date(:P103_Fec_Ocurrencia,''dd/mm/rrrr'') < dFecIniVig  OR ',
'to_date(:P103_Fec_Ocurrencia,''dd/mm/rrrr'') > dFecFinVig THEN ',
unistr(':P103_ERR_FECO:=''La Fecha de OCURRENCIA, esta fuera del rango de vigencia de la Póliza'';'),
'END IF; ',
'IF to_date(:P103_Fec_Ocurrencia,''dd/mm/rrrr'') > TRUNC (sysdate) THEN',
':P103_ERR_FECO:=''La Fecha de OCURRENCIA NO puede ser Mayor  a la Fecha de SISTEMA  '';',
'END IF; ',
'',
'if :P103_ERR_FECO is not null then return false; else return true; end if;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'&P103_ERR_FECO.'
,p_when_button_pressed=>wwv_flow_imp.id(201410199852730396)
,p_associated_item=>wwv_flow_imp.id(202746389189475542)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(230820918702965090)
,p_validation_name=>'Fecha NOTIFICACION'
,p_validation_sequence=>20
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'Dummy          NUMBER;',
'dFecIniVig     DATE;',
'dFecFinVig     DATE;',
'NMESESOCUVSFIN NUMBER;',
'BEGIN ',
':P103_ERR_FECN := NULL;',
'	--',
'  SELECT FecIniVig,',
'         FecFinVig,',
'         TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE),FecFinVig))',
'    INTO dFecIniVig,',
'         dFecFinVig,',
'         NMESESOCUVSFIN',
'    FROM POLIZAS ',
'   WHERE IdPoliza = :P103_iDPOLIZA;',
'  -- 	',
'  IF TO_DATE(:P103_Fec_Notificacion,''DD/MM/RRRR'') > TRUNC(SYSDATE) THEN',
unistr('	    :P103_ERR_FECN := (''La Fecha de NOTIFICACIÓN, no puede ser Mayor a la fecha del SISTEMA'');'),
'        ',
'  END IF;',
'  --',
'  IF TO_DATE(:P103_Fec_Notificacion,''DD/MM/RRRR'') < TO_DATE(:P103_Fec_OCURRENCIA,''DD/MM/RRRR'') THEN',
unistr('	    :P103_ERR_FECN:= (''La Fecha de NOTIFICACIÓN, no puede ser Menor a la fecha de OCURRIDO'');'),
'  END IF;',
'  --',
'  IF TO_DATE(:P103_Fec_Notificacion,''DD/MM/RRRR'') < dFecIniVig THEN',
unistr('	    :P103_ERR_FECN:=(''La Fecha de NOTIFICACIÓN, no puede ser Menor a la fecha de Inicio de Vigencia de la póliza'');'),
'  END IF;',
'  --',
'  --',
'  -- VALIDA POR TIEMPO DE RECLAMACION',
'  --',
'  IF :P103_TIPO_SINIESTRO IN (''003'',''006'',''008'',''012'',''013'',''014'') THEN',
'  	 -- FALLECIEMIENTO',
'     IF NMESESOCUVSFIN > 60 THEN',
unistr('        :P103_ERR_FECN := (''Fecha de Notificación para fallecimiento, esta fuera de la Fecha permitida por Ley (5 AÑOS)'');'),
'     END IF;  ',
'  ELSE',
'     -- OTRAS COBERTURAS',
'     IF NMESESOCUVSFIN > 24 THEN',
unistr('        :P103_ERR_FECN := (''Fecha de Notificación para esta cobertura, esta fuera de la Fecha permitida por Ley (2 AÑOS)'');'),
'     END IF;  ',
'  END IF; ',
'',
'  if :P103_ERR_FECN is null then',
'    return true;',
'  else',
'  return false;',
'  end if;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'&P103_ERR_FECN.'
,p_when_button_pressed=>wwv_flow_imp.id(201410199852730396)
,p_associated_item=>wwv_flow_imp.id(202746839317475544)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(230820058529965082)
,p_validation_name=>'New'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P103_CODPROVOCURR is null or :P103_CODMUNICIPIO is null then',
'return false;',
'else',
'return true;',
'end if;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'El Estado y Municipio es Obligatorio'
,p_when_button_pressed=>wwv_flow_imp.id(201410199852730396)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(142774557674445430)
,p_validation_name=>'idetpol requerido'
,p_validation_sequence=>40
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P103_IDETPOL is null then',
'return false;',
'else',
'return true;',
'end if;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'El valor para Detalle/Subgrupo es Obligatorio, favor de proporcionarlo'
,p_when_button_pressed=>wwv_flow_imp.id(201410199852730396)
,p_associated_item=>wwv_flow_imp.id(202743219279475530)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(223885798202100872)
,p_name=>'fec_ocurrencia'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P103_FEC_OCURRENCIA'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(223885978941100874)
,p_event_id=>wwv_flow_imp.id(223885798202100872)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'NULL;'
,p_attribute_02=>'P103_FEC_OCURRENCIA,P103_IDPOLIZA'
,p_attribute_03=>'P103_FEC_OCURRENCIA,P103_IDPOLIZA'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(223887024387100884)
,p_event_id=>wwv_flow_imp.id(223885798202100872)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'Dummy NUMBER;',
'nValid  NUMBER(1) := 0;',
'dFecIniVig DATE;',
'dFecFinVig DATE;',
'dFecAnul DATE;',
'CIDPAGOS VARCHAR(2);',
'DFECINIVIGPAG  DATE;',
'DFECFINVIGPAG  DATE;',
'DFECPERESPERA  DATE;',
'CSTSPOLIZA POLIZAS.STSPOLIZA%TYPE;',
'CINDFACTURAPOL POLIZAS.INDFACTURAPOL%TYPE;',
'NDIASCANCELACION TIPOS_DE_SEGUROS.DIASCANCELACION%TYPE;',
'NIDFACTURA FACTURAS.IDFACTURA%TYPE;',
'BEGIN',
':P103_ERR_FECO:=NULL;',
'',
'BEGIN',
'SELECT FecIniVig,',
'FecFinVig,',
'FecAnul,',
'STSPOLIZA,',
'INDFACTURAPOL',
'INTO dFecIniVig,',
'DFecFinVig,',
'dFecAnul,',
'CSTSPOLIZA,',
'CINDFACTURAPOL',
'FROM POLIZAS ',
'WHERE IdPoliza = :P103_IDPOLIZA;',
'exCEPTION',
'WHEN NO_DATA_FOUND THEN',
'raise_application_error(-20105,''No existe la poliza (FEC_OCURRENCIA)'');',
' WHEN OTHERS THEN',
'raise_application_error(-20105,''Poliza con problemas (FEC_OCURRENCIA-OTHERS)'');',
'eND;',
'BEGIN',
'SELECT TS.DIASCANCELACION',
'INTO NDIASCANCELACION',
'FROM DETALLE_POLIZA DP,',
'TIPOS_DE_SEGUROS TS  ',
'WHERE DP.IDPOLIZA = :P103_IdPoliza',
'AND DP.IDETPOL  = (SELECT MIN(DP1.IDETPOL)',
'FROM DETALLE_POLIZA DP1',
'WHERE DP1.IDPOLIZA = DP.IDPOLIZA)',
'AND TS.IDTIPOSEG  = DP.IDTIPOSEG',
'AND TS.CODCIA  = DP.CODCIA',
'AND TS.CODEMPRESA = DP.CODEMPRESA;',
'EXCEPTION',
'WHEN NO_DATA_FOUND THEN',
':P103_ERR_FECO:=''No existe la poliza (FEC_OCURRENCIA 1)'';',
'WHEN OTHERS THEN',
':P103_ERR_FECO:=''Poliza con problemas (FEC_OCURRENCIA 1-OTHERS)'';',
'eND; ',
'IF :P103_Fec_Ocurrencia IS NULL THEN ',
':P103_ERR_FECO:=''La Fecha de OCURRENCIA, es obligatorioa'';',
'END IF; ',
'IF to_date(:P103_Fec_Ocurrencia,''dd/mm/rrrr'') < dFecIniVig  OR ',
'to_date(:P103_Fec_Ocurrencia,''dd/mm/rrrr'') > dFecFinVig THEN ',
unistr(':P103_ERR_FECO:=''La Fecha de OCURRENCIA, esta fuera del rango de vigencia de la Póliza'';'),
'END IF; ',
'IF to_date(:P103_Fec_Ocurrencia,''dd/mm/rrrr'') > TRUNC (sysdate) THEN',
':P103_ERR_FECO:=''La Fecha de OCURRENCIA NO puede ser Mayor  a la Fecha de SISTEMA  '';',
'END IF; ',
'',
'',
'END;'))
,p_attribute_02=>'P103_ERR_FECO'
,p_attribute_03=>'P103_ERR_FECO'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(223886821664100882)
,p_event_id=>wwv_flow_imp.id(223885798202100872)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'Dummy NUMBER;',
'nValid  NUMBER(1) := 0;',
'dFecIniVig DATE;',
'dFecFinVig DATE;',
'dFecAnul DATE;',
'CIDPAGOS VARCHAR(2);',
'DFECINIVIGPAG  DATE;',
'DFECFINVIGPAG  DATE;',
'DFECPERESPERA  DATE;',
'CSTSPOLIZA POLIZAS.STSPOLIZA%TYPE;',
'CINDFACTURAPOL POLIZAS.INDFACTURAPOL%TYPE;',
'NDIASCANCELACION TIPOS_DE_SEGUROS.DIASCANCELACION%TYPE;',
'NIDFACTURA FACTURAS.IDFACTURA%TYPE;',
'BEGIN',
'BEGIN',
'SELECT FecIniVig,',
'FecFinVig,',
'FecAnul,',
'STSPOLIZA,',
'INDFACTURAPOL',
'INTO dFecIniVig,',
'DFecFinVig,',
'dFecAnul,',
'CSTSPOLIZA,',
'CINDFACTURAPOL',
'FROM POLIZAS ',
'WHERE IdPoliza = :P103_IDPOLIZA;',
'eND;',
'BEGIN',
'SELECT TS.DIASCANCELACION',
'INTO NDIASCANCELACION',
'FROM DETALLE_POLIZA DP,',
'TIPOS_DE_SEGUROS TS  ',
'WHERE DP.IDPOLIZA = :P103_IdPoliza',
'AND DP.IDETPOL  = (SELECT MIN(DP1.IDETPOL)',
'FROM DETALLE_POLIZA DP1',
'WHERE DP1.IDPOLIZA = DP.IDPOLIZA)',
'AND TS.IDTIPOSEG  = DP.IDTIPOSEG',
'AND TS.CODCIA  = DP.CODCIA',
'AND TS.CODEMPRESA = DP.CODEMPRESA;',
'eND; ',
'',
'BEGIN',
'SELECT ''S''',
'INTO CIDPAGOS',
'FROM FACTURAS F',
'WHERE F.CODCIA=:CODCIA',
'aND F.IDPOLIZA=:P103_IDPOLIZA',
'AND F.STSFACT=''PAG'';',
'EXCEPTION',
'WHEN NO_DATA_FOUND THEN ',
'CIDPAGOS:=''N'';',
'WHEN OTHERS THEN',
'CIDPAGOS:=''N'';',
'END;',
'IF CIDPAGOS=''S'' THEN  ',
'iF CINDFACTURAPOL=''S'' THEN',
'BEGIN',
'SELECT MAX(F.IDFACTURA) ',
'INTO NIDFACTURA',
'FROM FACTURAS F',
'WHERE F.CODCIA=:CODCIA',
'AND F.IDPOLIZA=:P103_IDPOLIZA',
'AND F.STSFACT=''PAG'';',
'BEGIN',
'SELECT F.FECVENC,',
'F.FECFINVIG,',
'F.FECVENC+NDIASCANCELACION',
'INTO DFECINIVIGPAG,',
'DFECFINVIGPAG,',
'DFECPERESPERA',
'FROM FACTURAS F',
'WHERE F.IDFACTURA=NIDFACTURA;',
'EXCEPTION',
'WHEN NO_DATA_FOUND THEN NULL;',
'WHEN OTHERS THEN NULL;',
'END;',
'EXCEPTION',
'WHEN NO_DATA_FOUND THEN NULL;',
'WHEN OTHERS THEN NULL;',
'END;',
'ELSE',
'BEGIN ',
'SELECT MAX(F.IDFACTURA) ',
'INTO NIDFACTURA',
'FROM FACTURAS F',
'WHERE F.CODCIA=:CODCIA',
'AND F.IDPOLIZA=:P103_IDPOLIZA',
'AND F.IDETPOL=:P103_IDETPOL',
'AND F.IDENDOSO=:P103_IDENDOSO',
'AND F.STSFACT=''PAG'';',
'BEGIN',
'SELECT F.FECVENC,',
'F.FECFINVIG,',
'F.FECVENC+NDIASCANCELACION',
'INTO DFECINIVIGPAG,',
'DFECFINVIGPAG,',
'DFECPERESPERA',
'FROM FACTURAS F',
'WHERE F.IDFACTURA=NIDFACTURA;',
'EXCEPTION',
'WHEN NO_DATA_FOUND THEN NULL;',
'WHEN OTHERS THEN NULL;',
'END;',
'EXCEPTION',
'WHEN NO_DATA_FOUND THEN NULL;',
'WHEN OTHERS THEN NULL;',
'END;',
'END IF;',
'ELSE',
'IF CINDFACTURAPOL=''S'' THEN',
'BEGIN',
'SELECT MIN(F.IDFACTURA) ',
'INTO NIDFACTURA',
'FROM FACTURAS F',
'WHERE F.CODCIA=:CODCIA',
'AND F.IDPOLIZA=:P103_IDPOLIZA',
'AND F.STSFACT=''EMI'';',
'BEGIN',
'SELECT F.FECVENC,',
'F.FECFINVIG,',
'F.FECVENC+NDIASCANCELACION',
'INTO DFECINIVIGPAG,',
'DFECFINVIGPAG,',
'DFECPERESPERA',
'FROM FACTURAS F',
'WHERE F.IDFACTURA = NIDFACTURA;',
'EXCEPTION',
'WHEN NO_DATA_FOUND THEN NULL;WHEN OTHERS THEN NULL;END;',
'EXCEPTION',
'WHEN NO_DATA_FOUND THEN NULL;WHEN OTHERS THEN NULL;END;',
'ELSE',
'BEGIN ',
'SELECT MIN(F.IDFACTURA) ',
'INTO NIDFACTURA',
'FROM FACTURAS F',
'WHERE F.CODCIA=:CODCIA',
'AND F.IDPOLIZA=:P103_IDPOLIZA',
'AND F.IDETPOL=:P103_IDETPOL',
'AND F.IDENDOSO=:P103_IDENDOSO',
'AND F.STSFACT=''EMI'';',
'BEGIN',
'sELECT F.FECVENC,',
'F.FECFINVIG,',
'F.FECVENC+NDIASCANCELACION',
'INTO DFECINIVIGPAG,',
'DFECFINVIGPAG,',
'DFECPERESPERA',
'FROM FACTURAS F',
'WHERE F.IDFACTURA=NIDFACTURA;',
'EXCEPTION',
'WHEN NO_DATA_FOUND THEN NULL;',
'WHEN OTHERS THEN NULL;',
'eND;',
'EXCEPTION',
'wHEN NO_DATA_FOUND THEN NULL;',
'WHEN OTHERS THEN NULL;',
'END;',
'END IF;',
'END IF;',
':P103_IDTPORIGEN:=''NORMAL'';',
'IF CSTSPOLIZA=''ANU'' OR ',
'CSTSPOLIZA=''SUS'' THEN',
'IF DFECFINVIGPAG IS NOT NULL THEN',
'IF :P103_Fec_Ocurrencia>DFECFINVIGPAG THEN',
':P103_IDTPORIGEN:=''CANMAY'';',
'ELSE',
':P103_IDTPORIGEN:=''CANPAG'';',
'END IF; ',
'ELSE  ',
':P103_IDTPORIGEN:=''CANSIN'';',
'END IF;',
'ELSE',
'IF CIDPAGOS=''N'' THEN',
':P103_IDTPORIGEN:=''SINPAG'';',
'END IF;',
'IF :P103_Fec_Ocurrencia BETWEEN DFECINIVIGPAG AND DFECPERESPERA THEN',
':P103_IDTPORIGEN:=''PERGRA'';',
'END IF;END IF;',
':P103_AUTORIZACION_REQUERIDA := OC_VALORES_DE_LISTAS.BUSCA_LVALOR(''APRORI'',:P103_IDTPORIGEN);',
'--:P103_NOMIDTPORIGEN:=OC_VALORES_DE_LISTAS.BUSCA_LVALOR(''TIPORI'',:P103_IDTPORIGEN);',
'',
'',
':P103_IDTPORIGEN_1:=:P103_IDTPORIGEN;',
':P103_AUTORIZACION_REQUERIDA_1 := :P103_AUTORIZACION_REQUERIDA;',
'END;'))
,p_attribute_02=>'P103_IDTPORIGEN,P103_AUTORIZACION_REQUERIDA,P103_IDTPORIGEN_1,P103_AUTORIZACION_REQUERIDA_1'
,p_attribute_03=>'P103_IDTPORIGEN,P103_AUTORIZACION_REQUERIDA,P103_IDTPORIGEN_1,P103_AUTORIZACION_REQUERIDA_1'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(230471909419096107)
,p_event_id=>wwv_flow_imp.id(223885798202100872)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var ccv;',
' apex.message.alert($v("P103_ERR_FECO"));',
''))
,p_client_condition_type=>'NOT_NULL'
,p_client_condition_element=>'P103_ERR_FECO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(230820317914965084)
,p_name=>'fec_notifica'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P103_FEC_NOTIFICACION'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(230820438303965085)
,p_event_id=>wwv_flow_imp.id(230820317914965084)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'NULL;'
,p_attribute_02=>'P103_FEC_OCURRENCIA,P103_IDPOLIZA,P103_FEC_NOTIFICACION,P103_TIPO_SINIESTRO'
,p_attribute_03=>'P103_FEC_OCURRENCIA,P103_IDPOLIZA,P103_FEC_NOTIFICACION,P103_TIPO_SINIESTRO'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(230820495266965086)
,p_event_id=>wwv_flow_imp.id(230820317914965084)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'Dummy          NUMBER;',
'dFecIniVig     DATE;',
'dFecFinVig     DATE;',
'NMESESOCUVSFIN NUMBER;',
'BEGIN ',
':P103_ERR_FECN := NULL;',
'	--',
'  SELECT FecIniVig,',
'         FecFinVig,',
'         TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE),FecFinVig))',
'    INTO dFecIniVig,',
'         dFecFinVig,',
'         NMESESOCUVSFIN',
'    FROM POLIZAS ',
'   WHERE IdPoliza = :P103_iDPOLIZA;',
'  -- 	',
'  IF TO_DATE(:P103_Fec_Notificacion,''DD/MM/RRRR'') > TRUNC(SYSDATE) THEN',
unistr('	    :P103_ERR_FECN := (''La Fecha de NOTIFICACIÓN, no puede ser Mayor a la fecha del SISTEMA'');'),
'        :P103_FEC_NOTIFICACION := TRUNC(SYSDATE);',
'  END IF;',
'  --',
'  IF TO_DATE(:P103_Fec_Notificacion,''DD/MM/RRRR'') < TO_DATE(:P103_Fec_OCURRENCIA,''DD/MM/RRRR'') THEN',
unistr('	    :P103_ERR_FECN:= (''La Fecha de NOTIFICACIÓN, no puede ser Menor a la fecha de OCURRIDO'');'),
'  END IF;',
'  --',
'  IF TO_DATE(:P103_Fec_Notificacion,''DD/MM/RRRR'') < dFecIniVig THEN',
unistr('	    :P103_ERR_FECN:=(''La Fecha de NOTIFICACIÓN, no puede ser Menor a la fecha de Inicio de Vigencia de la póliza'');'),
'  END IF;',
'  --',
'  IF (TRUNC(SYSDATE) - TO_DATE(:P103_Fec_Notificacion,''DD/MM/RRRR'')) > 30 THEN',
unistr('	    :P103_ERR_FECN := (''SOLO AVISO - Existen mas de 30 dias entre el dia de hoy y la fecha de NOTIFICACIÓN'');'),
'  END IF;',
'  --',
'  -- VALIDA POR TIEMPO DE RECLAMACION',
'  --',
'  IF :P103_TIPO_SINIESTRO IN (''003'',''008'',''012'',''013'',''014'') THEN',
'  	 -- FALLECIEMIENTO',
'     IF NMESESOCUVSFIN > 60 THEN',
unistr('        :P103_ERR_FECN := (''Fecha de Notificación para fallecimiento, esta fuera de la Fecha permitida por Ley (5 AÑOS)'');'),
'     END IF;  ',
'  ELSE',
'     -- OTRAS COBERTURAS',
'     IF NMESESOCUVSFIN > 24 THEN',
unistr('        :P103_ERR_FECN := (''Fecha de Notificación para esta cobertura, esta fuera de la Fecha permitida por Ley (2 AÑOS)'');'),
'     END IF;  ',
'  END IF; ',
'END;'))
,p_attribute_02=>'P103_ERR_FECN'
,p_attribute_03=>'P103_ERR_FECN'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(230820718609965088)
,p_event_id=>wwv_flow_imp.id(230820317914965084)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var ccv;',
' apex.message.alert($v("P103_ERR_FECN"));',
''))
,p_client_condition_type=>'NOT_NULL'
,p_client_condition_element=>'P103_ERR_FECN'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(229284841255115602)
,p_name=>'PageLoadHide'
,p_event_sequence=>60
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(229284864149115603)
,p_event_id=>wwv_flow_imp.id(229284841255115602)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P103_COD_MONEDA_1,P103_IDCONTRIBUTORIO_1,P103_CODRIESGOREA_1,P103_IDTPORIGEN_1,P103_AUTORIZACION_REQUERIDA_1'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151272176220177993)
,p_event_id=>wwv_flow_imp.id(229284841255115602)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P103_CODPLANTEL,P103_EMPRESA_LABORA'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(170866663497204553)
,p_event_id=>wwv_flow_imp.id(229284841255115602)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_imp.id(170866510921204551)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(170867809123204564)
,p_event_id=>wwv_flow_imp.id(229284841255115602)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_imp.id(170867121320204557)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53166687596504622)
,p_event_id=>wwv_flow_imp.id(229284841255115602)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_imp.id(53166530660504621)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(55667855258358922)
,p_event_id=>wwv_flow_imp.id(229284841255115602)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_imp.id(201410199852730396)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53169389401504649)
,p_event_id=>wwv_flow_imp.id(229284841255115602)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P103_SINIESTROS_PAS,P103_TIPO_BUSQUEDA,P103_UNDERAGE,P103_EDAD_ASEGURADO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(230472487654096113)
,p_name=>'rfc_curp'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P103_COD_ASEGURADO'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(230472560676096114)
,p_event_id=>wwv_flow_imp.id(230472487654096113)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'nDummy          NUMBER;',
'cCadena         VARCHAR2(2000) := NULL;',
'nExiste         NUMBER;',
'BEGIN',
'     --',
'     BEGIN',
'       SELECT P.NUM_TRIBUTARIO,',
'              P.CURP',
'         INTO :P103_NUM_TRIBUTARIO, ',
'              :P103_CURP',
'         FROM ASEGURADO A,',
'              PERSONA_NATURAL_JURIDICA P',
'        WHERE A.COD_ASEGURADO = :P103_COD_ASEGURADO',
'          --',
'          AND P.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION',
'          AND P.NUM_DOC_IDENTIFICACION  = A.NUM_DOC_IDENTIFICACION;',
'     EXCEPTION',
'       WHEN OTHERS THEN NULL;',
'     END;',
'END;',
''))
,p_attribute_02=>'P103_NUM_TRIBUTARIO,P103_CURP,P103_COD_ASEGURADO'
,p_attribute_03=>'P103_NUM_TRIBUTARIO,P103_CURP'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151272292638177994)
,p_name=>'conalep'
,p_event_sequence=>90
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(151271787686177989)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(170866571351204552)
,p_event_id=>wwv_flow_imp.id(151272292638177994)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_imp.id(170866510921204551)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151272353689177995)
,p_event_id=>wwv_flow_imp.id(151272292638177994)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P103_CODPLANTEL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151272396362177996)
,p_name=>'dafi'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(151271882362177990)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151272506339177997)
,p_event_id=>wwv_flow_imp.id(151272396362177996)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P103_EMPRESA_LABORA,P103_IDCREDITO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(170867860925204565)
,p_event_id=>wwv_flow_imp.id(151272396362177996)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_imp.id(170867121320204557)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(150323180524061671)
,p_name=>'val_asegurado'
,p_event_sequence=>120
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P103_COD_ASEGURADO'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(150323448238061673)
,p_event_id=>wwv_flow_imp.id(150323180524061671)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    nCount      NUMBER:=0;',
'    nEdad       NUMBER;',
'BEGIN',
'    ',
'    :P103_SINIESTROS_PAS    := NULL;',
'    :P103_UNDERAGE          := NULL;',
'    :P103_EDAD_ASEGURADO    := NULL;',
'    :P103_TIPO_BUSQUEDA     := ''COD_ASEGURADO'';',
'',
'    nEdad := OC_ASEGURADO.EDAD_ASEGURADO(1,1,:P103_COD_ASEGURADO,SYSDATE);',
'    :P103_EDAD_ASEGURADO := nEdad;',
'    ',
'    SELECT COUNT(*) ',
'    INTO nCount',
'    FROM SINIESTRO A',
'    WHERE A.IDPOLIZA    = :P103_IDPOLIZA',
'    AND A.COD_ASEGURADO = :P103_COD_ASEGURADO',
'    AND A.STS_SINIESTRO IN (''EMI'', ''PGP'', ''PGT'')',
'    AND A.FEC_OCURRENCIA >= ADD_MONTHS(SYSDATE, -60);',
'',
'    IF nCount = 1 THEN',
unistr('        :P103_SINIESTROS_PAS := ''TIENE ''||nCount||'' SINIESTRO REGISTRADO CON PÓLIZA CONSECUTIVO: ''||:P103_IDPOLIZA||''.:'';'),
'    ELSIF nCount > 1 THEN',
unistr('        :P103_SINIESTROS_PAS := ''TIENE ''||nCount||'' SINIESTROS REGISTRADOS CON PÓLIZA CONSECUTIVO: ''||:P103_IDPOLIZA||''.:'';'),
'    END IF;',
'',
'    IF nEdad < 18 THEN',
'        nCount := OC_SINIESTRO.NUMERO_COINCIDENCIAS_FONETICA_ASEGURADO(1,1,:P103_IDPOLIZA,:P103_COD_ASEGURADO);',
'        ',
'        IF nCount > 0 then',
unistr('            :P103_UNDERAGE := ''Asegurado ''||OC_ASEGURADO.NOMBRE_ASEGURADO(1,1,:P103_COD_ASEGURADO)||''(Menor de edad), se encontraron las siguientes coincidencias de Siniestros registrados con póliza consecutivo: '''),
'                                ||:P103_IDPOLIZA||'' en base a busqueda por coincidencia fonetica.:'';',
'        END IF;',
'',
'    END IF;',
'',
'    EXCEPTION ',
'       WHEN OTHERS THEN ',
'         NULL;',
'END;'))
,p_attribute_02=>'P103_COD_ASEGURADO,P103_SINIESTROS_PAS,P103_TIPO_BUSQUEDA,P103_IDPOLIZA,P103_UNDERAGE,P103_EDAD_ASEGURADO'
,p_attribute_03=>'P103_SINIESTROS_PAS,P103_TIPO_BUSQUEDA,P103_UNDERAGE,P103_EDAD_ASEGURADO'
,p_attribute_04=>'Y'
,p_attribute_05=>'PLSQL'
,p_stop_execution_on_error=>'N'
,p_wait_for_result=>'Y'
,p_client_condition_type=>'NOT_NULL'
,p_client_condition_element=>'P103_COD_ASEGURADO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53904796767257811)
,p_event_id=>wwv_flow_imp.id(150323180524061671)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var warningEl = document.getElementById("warning-underage");',
'',
'if (warningEl) {',
'    warningEl.remove();',
'}',
'',
'var edad = apex.item("P103_EDAD_ASEGURADO").getValue();',
'if (edad && parseInt(edad) < 18) {',
'    var errorHtml = `<span class="t-Form-error" id="warning-underage">',
'        <div >Asegurado es menor de edad</div>',
'      </span>`;',
'',
unistr('    // Obtener el contenedor donde se insertará el código'),
'    var targetElement = document.getElementById("P103_COD_ASEGURADO_error_placeholder");',
'',
'    // Verifica si existe y luego inserta',
'    if (targetElement) {',
'        targetElement.insertAdjacentHTML("afterend", errorHtml);',
'    }',
'}'))
);
end;
/
begin
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53166854915504624)
,p_event_id=>wwv_flow_imp.id(150323180524061671)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if (',
'    apex.item("P103_SINIESTROS_PAS").getValue() ||',
'    apex.item("P103_UNDERAGE").getValue()',
') {',
'    document.getElementById("info_siniestro").click();',
'}'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(153150218100095043)
,p_name=>'PageLoad'
,p_event_sequence=>130
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(153150273407095044)
,p_event_id=>wwv_flow_imp.id(153150218100095043)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF :P103_CODASEG_MIG IS NOT NULL THEN ',
'BEGIN',
'SELECT A.Cod_Asegurado||'' - ''||SUBSTR(OC_ASEGURADO.NOMBRE_ASEGURADO(D.CodCia, D.CodEmpresa, A.Cod_Asegurado),1,300) NombreAseg',
'  INTO :P103_NAMEASEG',
'  FROM DETALLE_POLIZA D, ASEGURADO_CERTIFICADO A',
' WHERE A.IDetPol  = D.IDetPol',
'   AND A.IdPoliza = D.IdPoliza',
'   AND D.IdPoliza = :p103_IdPoliza',
'   AND A.COD_ASEGURADO = :P103_CODASEG_MIG',
'   AND D.CodCia   = nvl(:CodCia,1);',
'EXCEPTION',
'     WHEN OTHERS THEN ',
'        :P103_NAMEASEG := NULL;',
'END;',
'END IF;'))
,p_attribute_02=>'P103_IDPOLIZA,P103_CODASEG_MIG'
,p_attribute_03=>'P103_NAMEASEG'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(153150485816095046)
,p_event_id=>wwv_flow_imp.id(153150218100095043)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'let ncod = apex.item("P103_CODASEG_MIG").getValue(); ',
'let ccod = apex.item("P103_NAMESEG").getValue();',
'',
'apex.item("P103_COD_ASEGURADO").setValue(ncod,ccod,true);',
'',
'',
''))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(153150853715095050)
,p_event_id=>wwv_flow_imp.id(153150218100095043)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'NULL;'
,p_attribute_02=>'P103_COD_ASEGURADO'
,p_attribute_03=>'P103_COD_ASEGURADO'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(153151049165095051)
,p_event_id=>wwv_flow_imp.id(153150218100095043)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'nDummy          NUMBER;',
'cCadena         VARCHAR2(2000) := NULL;',
'nExiste         NUMBER;',
'BEGIN',
'     --',
'     BEGIN',
'       SELECT P.NUM_TRIBUTARIO,',
'              P.CURP',
'         INTO :P103_NUM_TRIBUTARIO, ',
'              :P103_CURP',
'         FROM ASEGURADO A,',
'              PERSONA_NATURAL_JURIDICA P',
'        WHERE A.COD_ASEGURADO = :P103_COD_ASEGURADO',
'          --',
'          AND P.TIPO_DOC_IDENTIFICACION = A.TIPO_DOC_IDENTIFICACION',
'          AND P.NUM_DOC_IDENTIFICACION  = A.NUM_DOC_IDENTIFICACION;',
'     EXCEPTION',
'       WHEN OTHERS THEN NULL;',
'     END;',
'END;',
''))
,p_attribute_02=>'P103_NUM_TRIBUTARIO,P103_CURP'
,p_attribute_03=>'P103_NUM_TRIBUTARIO,P103_CURP'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(170866753368204554)
,p_name=>'Hide Conalep'
,p_event_sequence=>140
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(170866510921204551)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(170866911830204555)
,p_event_id=>wwv_flow_imp.id(170866753368204554)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P103_CODPLANTEL'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(170866969433204556)
,p_event_id=>wwv_flow_imp.id(170866753368204554)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_imp.id(170866510921204551)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(170867616517204562)
,p_event_id=>wwv_flow_imp.id(170866753368204554)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P103_CODPLANTEL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(170867267375204559)
,p_name=>'Hide DAFI'
,p_event_sequence=>150
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(170867121320204557)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(170867431420204560)
,p_event_id=>wwv_flow_imp.id(170867267375204559)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P103_EMPRESA_LABORA,P103_IDCREDITO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(170867541472204561)
,p_event_id=>wwv_flow_imp.id(170867267375204559)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_imp.id(170867121320204557)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(170867728433204563)
,p_event_id=>wwv_flow_imp.id(170867267375204559)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P103_EMPRESA_LABORA'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(136776583750742756)
,p_name=>'UPPER_MEDICO'
,p_event_sequence=>160
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P103_NOM_MEDICO_CERTIFICA'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keyup'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(136777069665742876)
,p_event_id=>wwv_flow_imp.id(136776583750742756)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'$s("P103_NOM_MEDICO_CERTIFICA",$v("P103_NOM_MEDICO_CERTIFICA").toUpperCase());'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(136777365526745080)
,p_name=>'UPPER_RFC'
,p_event_sequence=>170
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P103_NUM_TRIBUTARIO'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keyup'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(136777704291745081)
,p_event_id=>wwv_flow_imp.id(136777365526745080)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'$s("P103_NUM_TRIBUTARIO",$v("P103_NUM_TRIBUTARIO").toUpperCase());'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(136778170658746558)
,p_name=>'UPPER_CURP'
,p_event_sequence=>180
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P103_CURP'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keyup'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(136778494397746559)
,p_event_id=>wwv_flow_imp.id(136778170658746558)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'$s("P103_CURP",$v("P103_CURP").toUpperCase());'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(136802589735930216)
,p_name=>'UPPER_CEDULA'
,p_event_sequence=>190
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P103_ID_CEDULA_MEDICA'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keyup'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(136802714712930217)
,p_event_id=>wwv_flow_imp.id(136802589735930216)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'$s("P103_ID_CEDULA_MEDICA",$v("P103_ID_CEDULA_MEDICA").toUpperCase());'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(136802776060930218)
,p_name=>'UPPER_DESC_SINIESTRO'
,p_event_sequence=>200
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P103_DESC_SINIESTRO'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keyup'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(136802912557930219)
,p_event_id=>wwv_flow_imp.id(136802776060930218)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'$s("P103_DESC_SINIESTRO",$v("P103_DESC_SINIESTRO").toUpperCase());'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(53166950292504625)
,p_name=>'coincidencia_curp'
,p_event_sequence=>210
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P103_CURP'
,p_condition_element=>'P103_CURP'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'focusout'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53167005988504626)
,p_event_id=>wwv_flow_imp.id(53166950292504625)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    nContador   number := 0;',
'    cSqury      clob;',
'BEGIN',
'',
'    :P103_SINIESTROS_PAS    := NULL;',
'    :P103_TIPO_BUSQUEDA     := ''CURP''; ',
'',
'    SELECT count(*)',
'        INTO nContador',
'    FROM ',
'        SINIESTRO S',
'    JOIN ',
'        ASEGURADO A',
'        ON A.Cod_Asegurado = S.Cod_Asegurado',
'    JOIN ',
'        persona_natural_juridica pnj',
'        ON PNJ.tipo_doc_identificacion = A.tipo_doc_identificacion',
'        AND PNJ.num_doc_identificacion = A.num_doc_identificacion',
'    WHERE ',
'        pnj.CURP = :P103_CURP',
'        AND S.IDPOLIZA = :P103_IDPOLIZA',
'        AND S.STS_SINIESTRO IN (''EMI'', ''PGP'', ''PGT'')',
'        AND S.FEC_OCURRENCIA >= ADD_MONTHS(SYSDATE, -60);',
'',
'    IF nContador > 0 then',
'        :P103_SINIESTROS_PAS := ''Se encontraron ''||nContador||',
unistr('                                '' coincidencias en Siniestro(s) registrados con póliza consecutivo "''||:P103_IDPOLIZA||'),
'                                ''" y CURP "''||:P103_CURP ||''".:'';',
'    END IF;',
'',
'END;'))
,p_attribute_02=>'P103_CURP,P103_SINIESTROS_PAS,P103_IDPOLIZA'
,p_attribute_03=>'P103_SINIESTROS_PAS,P103_TIPO_BUSQUEDA'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53167155310504627)
,p_event_id=>wwv_flow_imp.id(53166950292504625)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'document.getElementById("info_siniestro").click();'
,p_client_condition_type=>'NOT_NULL'
,p_client_condition_element=>'P103_SINIESTROS_PAS'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(53903702491257801)
,p_name=>'coincidencia_rfc'
,p_event_sequence=>220
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P103_NUM_TRIBUTARIO'
,p_condition_element=>'P103_NUM_TRIBUTARIO'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'focusout'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53903820772257802)
,p_event_id=>wwv_flow_imp.id(53903702491257801)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    nContador   number := 0;',
'    cSqury      clob;',
'BEGIN',
'',
'    :P103_SINIESTROS_PAS    := NULL;',
'    :P103_TIPO_BUSQUEDA     := ''RFC'';  ',
'',
'',
'    SELECT count(*)',
'        INTO nContador',
'    FROM ',
'        SINIESTRO S',
'    WHERE S.IDPOLIZA = :P103_IDPOLIZA',
'    AND S.RFC_ASEGURADO = :P103_NUM_TRIBUTARIO',
'    AND S.STS_SINIESTRO IN (''EMI'', ''PGP'', ''PGT'')',
'    AND S.FEC_OCURRENCIA >= ADD_MONTHS(SYSDATE, -60);',
'',
'    IF nContador > 0 then',
'        :P103_SINIESTROS_PAS := ''Se encontraron ''||nContador||',
unistr('                                '' coincidencia(s) en Siniestros registrados con póliza consecutivo "''||:P103_IDPOLIZA||'),
'                                ''" y RFC "''||:P103_NUM_TRIBUTARIO ||''".:'';',
'    END IF;',
'',
'END;'))
,p_attribute_02=>'P103_SINIESTROS_PAS,P103_TIPO_BUSQUEDA,P103_IDPOLIZA,P103_NUM_TRIBUTARIO'
,p_attribute_03=>'P103_SINIESTROS_PAS,P103_TIPO_BUSQUEDA'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53903911061257803)
,p_event_id=>wwv_flow_imp.id(53903702491257801)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'document.getElementById("info_siniestro").click();'
,p_client_condition_type=>'NOT_NULL'
,p_client_condition_element=>'P103_SINIESTROS_PAS'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(55667984450358923)
,p_name=>'New'
,p_event_sequence=>230
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(55667772990358921)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(55668034245358924)
,p_event_id=>wwv_flow_imp.id(55667984450358923)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_imp.id(55667772990358921)
,p_build_option_id=>wwv_flow_imp.id(162582919312055914)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(55668134169358925)
,p_event_id=>wwv_flow_imp.id(55667984450358923)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'apex.widget.waitPopup();'
,p_build_option_id=>wwv_flow_imp.id(162582919312055914)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(55668268211358926)
,p_event_id=>wwv_flow_imp.id(55667984450358923)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    document.getElementById("gRABAR").click();',
''))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(230471525593096103)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'New'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'Dummy         NUMBER(5);',
'cIndDeclara   VARCHAR2(1);',
'cStsPoliza    POLIZAS.StsPoliza%TYPE;',
'TpoPol        VARCHAR2(1);',
'nINDPOLCOL    POLIZAS.INDPOLCOL%TYPE;',
'--',
'BEGIN',
'IF :P103_IdPoliza IS NOT NULL THEN',
'',
'     :P103_TIPO_SINIESTRO := ''001'';',
':P103_CODPAISOCURR := ''001'';',
'     BEGIN',
'       SELECT StsPoliza,          ',
'              Cod_Moneda, ',
'              NumPolUnico,        ',
'              --NumPolRef, ',
'              --NumPolRef,          ',
'              OC_CLIENTES.NOMBRE_CLIENTE(CodCliente) NomContratante,',
'              FECINIVIG,',
'              FECFINVIG,',
'              CODRIESGOREA,',
'--              GT_REA_RIESGOS.DESCRIPCION_RIESGO(:P103_CodCia, CodRiesgoRea),',
'              DECODE(NVL(PORCENCONTRIBUTORIO,0),0,''N'',''S'')',
'--              DECODE(DECODE(NVL(PORCENCONTRIBUTORIO,0),0,''N'',''S''),''N'',''NO CONTRIBUTORIO'',''CONTRIBUTORIO'')',
'              --CODAGRUPADOR              ',
'         INTO cStsPoliza,         ',
'              :P103_Cod_Moneda, ',
'              :P103_NNumPolUnico,  ',
'--              :P103_cNumPolRef_Dat,  ',
'--              :P103_cNumPolRef_Res, ',
'              :P103_NomContratante,',
'              :P103_FECINIVIG,',
'              :P103_FECFINVIG,',
'              :P103_CODRIESGOREA,',
'--              :P103_NOMCODRIESGOREA,',
'              :P103_IDCONTRIBUTORIO',
'--              :P103_NOMIDCONTRIBUTORIO',
'              --:P103_CODAGRUPADOR',
'         FROM POLIZAS',
'        WHERE IdPoliza   = :P103_IdPoliza',
'          AND CodCia     = 1;',
'     END;',
'     --',
'     IF cStsPoliza = ''SOL'' THEN',
unistr('         RAISE_APPLICATION_ERROR(-20102,''Póliza No. '' || :P103_IdPoliza || '' está como Solicitud y NO puede generarle Siniestros'');'),
'     ELSIF cStsPoliza = ''XRE'' THEN',
unistr('         RAISE_APPLICATION_ERROR(-20102,''Póliza No. '' || :P103_IdPoliza || '' está por Renovarse y NO puede generarle Siniestros'');'),
'     END IF;',
'     --',
'     :P103_cNumPolRef_Obs     := :P103_cNumPolRef;',
'--     :P103_cDescMoneda   := FUNC_DESCRIPCION_MONEDA(:P103_Cod_Moneda);',
'     ----------------------  INDIVIDUL  -   COLECTIVO   -----------',
'     BEGIN	',
'       SELECT INDPOLCOL ',
'         INTO nINDPOLCOL',
'         FROM POLIZAS k',
'        WHERE K.IDPOLIZA =:P103_IdPoliza;',
'     EXCEPTION  ',
'       WHEN NO_DATA_FOUND THEN',
'            nINDPOLCOL :=NULL;',
'       WHEN OTHERS THEN',
'            nINDPOLCOL := NULL;',
'     END;',
'     --',
'     IF nINDPOLCOL IS NULL THEN',
'        BEGIN ',
'          SELECT DECODE( VL.DESCVALLST,''INDIVIDUAL'',''N'',''S'')',
'            INTO nINDPOLCOL',
'            FROM POLIZAS           P,',
'                 DETALLE_POLIZA    DP,',
'                 PLAN_COBERTURAS   PC,',
'                 VALORES_DE_LISTAS VL',
'	         WHERE P.IDPOLIZA   = :P103_IdPoliza',
'             AND DP.IDPOLIZA   = P.IDPOLIZA',
'	           AND DP.IDETPOL    = 1 ',
'	           AND PC.CODCIA     = DP.CODCIA',
'	           AND PC.CODEMPRESA = DP.CODEMPRESA',
'	           AND PC.IDTIPOSEG  = DP.IDTIPOSEG',
'	           AND PC.PLANCOB    = DP.PLANCOB',
'	           AND VL.CODLISTA   = ''TIPORAMO''',
'	           AND VL.CODVALOR   = PC.CODTIPOPLAN;',
'        EXCEPTION',
'        	WHEN NO_DATA_FOUND THEN',
' 		           nINDPOLCOL :=NULL;',
'          WHEN OTHERS  THEN',
'               nINDPOLCOL :=NULL;',
'        END;	         ',
'     END IF; ',
'     --    ',
'     :P103_IDCOLEINDI := nINDPOLCOL;',
'     --     ',
'     IF :P103_IDCOLEINDI = ''S'' THEN',
'        :P103_NOMIDCOLEINDI := ''COLECTIVO'';',
'     ELSE',
'        :P103_NOMIDCOLEINDI := ''INDIVIDUAL'';',
'     END IF;',
'     --',
'     --',
'  :P103_STS_SINIESTRO:=''SOL'';',
':P103_FECSTS := TRUNC(SYSDATE);',
':P103_FEC_OCURRENCIA := NULL;',
':P103_FEC_NOTIFICACION := TRUNC(SYSDATE);',
'END IF;',
'',
':P103_CODRIESGOREA_1 := :P103_CODRIESGOREA;',
':P103_IDCONTRIBUTORIO_1 := :P103_IDCONTRIBUTORIO;',
':P103_Cod_Moneda_1 := :P103_Cod_Moneda;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>179138993599717879
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(201410286373730397)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'INSERT'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'cIdTipoSeg          TIPOS_DE_SEGUROS.IdTipoSeg%TYPE;',
'cPlanCob            PLAN_COBERTURAS.PlanCob%TYPE;',
'--cUltAsig            CONFIG_NOMSIN.UltSinAsig%TYPE;  --REISIN',
'Dummy               NUMBER;',
'nIdTarea            TAREA.IdTarea%TYPE;',
'nTiempo             PROC_TAREA.Tiempo%TYPE;',
'cParametro_Tiempo   PROC_TAREA.Parametro_Tiempo%TYPE;',
'dFechaEsperada      TAREA.FechaEsperada%TYPE;',
'p_msg_regreso       varchar2(50);',
'ExisteCausa         Number := 0;',
'CTIPO_DOC_IDENTIFICACION  ASEGURADO.TIPO_DOC_IDENTIFICACION%TYPE;',
'CNUM_DOC_IDENTIFICACION   ASEGURADO.NUM_DOC_IDENTIFICACION%TYPE;',
'PMENSAJE  VARCHAR2(2000); ',
'--',
'nIdPoliza_Obs   SINIESTRO.IDPOLIZA%TYPE;',
'cNumPolRef_Obs    SINIESTRO.NUMSINIREF%TYPE;',
'nIdSiniestro_Obs  SINIESTRO.IDSINIESTRO%TYPE;',
'nCodAsegurado_Obs SINIESTRO.COD_ASEGURADO%TYPE;',
'cNomAseg_Obs     VARCHAR2(3000);',
'nTasa                   NUMBER;',
'',
'BEGIN',
'  --',
'',
'  BEGIN',
'    SELECT IdTipoSeg,  PlanCob',
'      INTO cIdTipoSeg, cPlanCob',
'      FROM DETALLE_POLIZA',
'     WHERE IdPoliza   = :P103_IdPoliza',
'       AND CodCia     = :CodCia',
'       AND CodEmpresa = :CodEmpresa',
'       AND IdetPol    = :P103_Idetpol;  ',
'  EXCEPTION ',
'    WHEN NO_DATA_FOUND THEn ',
unistr('--         Dummy := (''PRE-INSERT No Existen Pólizas Asociadas o No Seleccionó el Subgrupo'');'),
unistr('        RAISE_APPLICATION_ERROR(-20102,''No Existen Pólizas Asociadas o No Seleccionó el Subgrupo'');'),
'  END;',
'  --',
'  BEGIN',
'    SELECT Cod_Moneda',
'      INTO :P103_Cod_Moneda',
'        FROM POLIZAS',
'       WHERE IdPoliza = :P103_IdPoliza;',
'  END;',
'  ',
'  nTasa := 1 ;--SICAS_OC.LIBSICAS.TASA_DE_CAMBIO(:P103_Cod_Moneda,SYSDATE);',
'  --',
'  :P103_STS_SINIESTRO := ''SOL'';',
'  :P103_CODUSUARIO    := :APP_USER;',
'  :P103_FECREGISTRO   := TRUNC(SYSDATE);',
'',
'  -----------------------------------',
'  BEGIN',
'    :P103_IdSiniestro := OC_SINIESTRO.F_GET_SIN(p_msg_regreso);',
'    commit;',
'    --',
'      nIdPoliza_Obs     := :P103_IdPoliza;',
'      cNumPolRef_Obs        := :P103_NUMSINIREF;',
'      nIdSiniestro_Obs  := :P103_IdSiniestro;',
'      nCodAsegurado_Obs := :P103_COD_ASEGURADO;',
'--      cNomAseg_Obs             := OC_ASEGURADO.NOMBRE_ASEGURADO(:CodCia, :CodEmpresa, :P103_nCodAsegurado_Obs);    ',
'    ',
'    insert into OBSERVACION_SINIESTRO (idsiniestro,idpoliza,idobserva,fecobserv,codusuario,descripcion,idtpopagosin,codcia,codempresa)',
unistr('    values (:P103_IDSINIESTRO,nIdPoliza_Obs,1,trunc(sysdatE),:app_user,''Creación de Siniestro'',null,:codcia,:codempresa);'),
'  END;',
'  --',
'  --',
'  --',
'',
'  IF --:P103_CODAGRUPADOR = ''1053'' AND   --CONALEP ',
'       :P103_CODPLANTEL IS NOT NULL THEN  ',
'     --',
'     INSERT INTO DATOS_SINIESTRO_NEGOCIO',
'      (CODCIA,                                  CODEMPRESA,   ',
'       IDSINIESTRO,                             CODAGRUPADOR,  ',
'       CODPLANTEL,                              ST_SINIESTRO_DOCTO,',
'       ID_MOTIVO_RECHAZO,                       MONTO_RECHAZO_NOCUM,',
'       FECHA_REGISTRO,                          USUARIO_REGISTRO)',
'     VALUES',
'      (:CODCIA,                   :CODEMPRESA,   ',
'       :P103_IDSINIESTRO,              ''1053'',',
'       :P103_CODPLANTEL,        :P103_ST_SINIESTRO_DOCTO,',
'       :P103_ID_MOTIVO_RECHAZO, :P103_MONTO_RECHAZO_NOCUM,',
'       TRUNC(SYSDATE),                          :APP_USER);',
'     --',
'  END IF;',
'  --',
'  BEGIN',
'   SELECT A.TIPO_DOC_IDENTIFICACION,',
'          A.NUM_DOC_IDENTIFICACION   ',
'     INTO CTIPO_DOC_IDENTIFICACION, ',
'          CNUM_DOC_IDENTIFICACION          ',
'     FROM ASEGURADO A',
'    WHERE A.COD_ASEGURADO = :P103_COD_ASEGURADO;',
'  EXCEPTION',
'    WHEN OTHERS THEN NULL;',
'  END;',
'  --',
'  IF :P103_NUM_TRIBUTARIO_ACT = :P103_NUM_TRIBUTARIO THEN',
'       NULL;',
'  ELSE',
'       IF :P103_NUM_TRIBUTARIO IS NOT NULL THEN',
'             --',
'             :P103_RFC_ASEGURADO := :P103_NUM_TRIBUTARIO;',
'             --',
'             UPDATE PERSONA_NATURAL_JURIDICA P',
'           SET P.NUM_TRIBUTARIO = :P103_NUM_TRIBUTARIO',
'         WHERE P.TIPO_DOC_IDENTIFICACION = CTIPO_DOC_IDENTIFICACION',
'           AND P.NUM_DOC_IDENTIFICACION  = CNUM_DOC_IDENTIFICACION;',
'        --',
'        TH_CONTROL_CAMBIO_DATOS.INSERTA_CAMBIO(:P103_CODCIA,',
'                                               :P103_CODEMPRESA,',
'                                               :P103_IDPOLIZA,',
'                                               :P103_IDSINIESTRO,',
'                                               ''NUM_TRIBUTARIO'',                 --CAMPO',
'                                               ''PERSONA_NATURAL_JURIDICA'',        --IDTABLA,',
'                                               :P103_NUM_TRIBUTARIO_ACT, --VALORANTERIOR',
'                                               :P103_NUM_TRIBUTARIO,     --VALORNUEVO',
'                                               USER,',
'                                               ''MODOPE'',',
'                                               PMENSAJE);',
'        --',
'       END IF;     ',
'  END IF;',
'  --',
'  IF :P103_CURP_ACT = :P103_CURP THEN',
'       NULL;',
'  ELSE',
'       IF :P103_CURP IS NOT NULL THEN',
'             --',
'             UPDATE PERSONA_NATURAL_JURIDICA P',
'           SET P.CURP = :P103_CURP',
'         WHERE P.TIPO_DOC_IDENTIFICACION = CTIPO_DOC_IDENTIFICACION',
'           AND P.NUM_DOC_IDENTIFICACION  = CNUM_DOC_IDENTIFICACION;',
'        --',
'        TH_CONTROL_CAMBIO_DATOS.INSERTA_CAMBIO(:CODCIA,',
'                                               :CODEMPRESA,',
'                                               :P103_IDPOLIZA,',
'                                               :P103_IDSINIESTRO,',
'                                               ''CURP'',                     --CAMPO',
'                                               ''PERSONA_NATURAL_JURIDICA'', --IDTABLA,',
'                                               :P103_CURP_ACT,    --VALORANTERIOR',
'                                               :P103_CURP,        --VALORNUEVO',
'                                               USER,',
'                                               ''MODOPE'',',
'                                               PMENSAJE);',
'       END IF;     ',
'  END IF;',
'  INSERT INTO SINIESTRO (CODCIA, IDSINIESTRO, IDPOLIZA, NUMSINIREF, TIPO_SINIESTRO, FEC_OCURRENCIA, FEC_NOTIFICACION, STS_SINIESTRO,',
'  FECSTS, DESC_SINIESTRO, MONTO_RESERVA_LOCAL, MONTO_RESERVA_MONEDA, MONTO_PAGO_LOCAL, MONTO_PAGO_MONEDA, COD_MONEDA, IDETPOL,',
'  CODEMPRESA, CODPAISOCURR, CODPROVocurr, COD_ASEGURADO, IDCOLEINDI, IDTPORIGEN, CODUSUARIO, FECREGISTRO, SUBMOTIVO_SINIESTRO,',
'  CODRIESGOREA,IDCONTRIBUTORIO,RFC_ASEGURADO,CODMUNICIPIO,EMPRESA_LABORA,MOTIVO_DE_SINIESTRO  ',
'  ,CODPROVEEDOR, NOM_MEDICO_CERTIFICA, ID_CEDULA_MEDICA, TP_ASEGURADO,IDCREDITO,HISTORIAL_SINIESTROS',
'  )',
'  VALUES (:CODCIA, :P103_IDSINIESTRO, :P103_IDPOLIZA, :P103_NUMSINIREF, :P103_TIPO_SINIESTRO, :P103_FEC_OCURRENCIA, :P103_FEC_NOTIFICACION, :P103_STS_SINIESTRO,',
'  :P103_FECSTS, upper(:P103_DESC_SINIESTRO), :P103_MONTO_RESERVA_MONEDA/nTasa, :P103_MONTO_RESERVA_MONEDA,:P103_MONTO_PAGO_MONEDA / nTasa, :P103_MONTO_PAGO_MONEDA, :P103_COD_MONEDA, :P103_IDETPOL,',
'  :CODEMPRESA, :P103_CODPAISOCURR, :P103_CODPROVOCURR, :P103_COD_ASEGURADO, :P103_IDCOLEINDI, :P103_IDTPORIGEN, :P103_CODUSUARIO, :P103_FECREGISTRO, :P103_SUBMOTIVO_SINIESTRO,',
'  :P103_CODRIESGOREA, :P103_IDCONTRIBUTORIO, :P103_NUM_TRIBUTARIO, :P103_CODMUNICIPIO,:P103_EMPRESA_LABORA,:P103_MOTIVO_DE_SINIESTRO',
'  ,:P103_CODPROVEEDOR, :P103_NOM_MEDICO_CERTIFICA, :P103_ID_CEDULA_MEDICA, :P103_TP_ASEGURADO,:P103_IDCREDITO,OC_SINIESTRO.LISTAR_SINIESTROS_RELACIONADOS(:P103_IDPOLIZA,:P103_COD_ASEGURADO,:P103_CURP,:P103_NUM_TRIBUTARIO)',
'  );',
'',
'',
'/*',
'EXCEPTION',
'  WHEN OTHERS THEN ',
'    Dummy := (''Error en Insertar Generacion de Siniestro-''||SQLERRM);',
'    RAISE_APPLICATION_ERROR(-20102,DUMMY);',
'    */',
'END; '))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(201410199852730396)
,p_process_success_message=>'Se creo el Siniestro &P103_IDSINIESTRO.'
,p_internal_uid=>150077754380352173
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(223885569812100870)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'llena'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'Dummy         NUMBER(5);',
'cIndDeclara   VARCHAR2(1);',
'cStsPoliza    POLIZAS.StsPoliza%TYPE;',
'TpoPol        VARCHAR2(1);',
'nINDPOLCOL    POLIZAS.INDPOLCOL%TYPE;',
'--',
'BEGIN',
'     :P103_TIPO_SINIESTRO := ''001'';',
':P103_CODPAISOCURR := ''001'';',
'     BEGIN',
'       SELECT StsPoliza,          ',
'              Cod_Moneda, ',
'              NumPolUnico,        ',
'              --NumPolRef, ',
'              --NumPolRef,          ',
'              OC_CLIENTES.NOMBRE_CLIENTE(CodCliente) NomContratante,',
'              FECINIVIG,',
'              FECFINVIG,',
'              CODRIESGOREA,',
'--              GT_REA_RIESGOS.DESCRIPCION_RIESGO(:P103_CodCia, CodRiesgoRea),',
'              DECODE(NVL(PORCENCONTRIBUTORIO,0),0,''N'',''S'')',
'--              DECODE(DECODE(NVL(PORCENCONTRIBUTORIO,0),0,''N'',''S''),''N'',''NO CONTRIBUTORIO'',''CONTRIBUTORIO'')',
'              --CODAGRUPADOR              ',
'         INTO cStsPoliza,         ',
'              :P103_Cod_Moneda, ',
'              :P103_NNumPolUnico,  ',
'--              :P103_cNumPolRef_Dat,  ',
'--              :P103_cNumPolRef_Res, ',
'              :P103_NomContratante,',
'              :P103_FECINIVIG,',
'              :P103_FECFINVIG,',
'              :P103_CODRIESGOREA,',
'--              :P103_NOMCODRIESGOREA,',
'              :P103_IDCONTRIBUTORIO',
'--              :P103_NOMIDCONTRIBUTORIO',
'              --:P103_CODAGRUPADOR',
'         FROM POLIZAS',
'        WHERE IdPoliza   = :P103_IdPoliza',
'          AND CodCia     = 1;',
'     END;',
'     --',
'     IF cStsPoliza = ''SOL'' THEN',
unistr('         RAISE_APPLICATION_ERROR(-20102,''Póliza No. '' || :P103_IdPoliza || '' está como Solicitud y NO puede generarle Siniestros'');'),
'     ELSIF cStsPoliza = ''XRE'' THEN',
unistr('         RAISE_APPLICATION_ERROR(-20102,''Póliza No. '' || :P103_IdPoliza || '' está por Renovarse y NO puede generarle Siniestros'');'),
'     END IF;',
'     --',
'     :P103_cNumPolRef_Obs     := :P103_cNumPolRef;',
'--     :P103_cDescMoneda   := FUNC_DESCRIPCION_MONEDA(:P103_Cod_Moneda);',
'     ----------------------  INDIVIDUL  -   COLECTIVO   -----------',
'     BEGIN	',
'       SELECT INDPOLCOL ',
'         INTO nINDPOLCOL',
'         FROM POLIZAS k',
'        WHERE K.IDPOLIZA =:P103_IdPoliza;',
'     EXCEPTION  ',
'       WHEN NO_DATA_FOUND THEN',
'            nINDPOLCOL :=NULL;',
'       WHEN OTHERS THEN',
'            nINDPOLCOL := NULL;',
'     END;',
'     --',
'     IF nINDPOLCOL IS NULL THEN',
'        BEGIN ',
'          SELECT DECODE( VL.DESCVALLST,''INDIVIDUAL'',''N'',''S'')',
'            INTO nINDPOLCOL',
'            FROM POLIZAS           P,',
'                 DETALLE_POLIZA    DP,',
'                 PLAN_COBERTURAS   PC,',
'                 VALORES_DE_LISTAS VL',
'	         WHERE P.IDPOLIZA   = :P103_IdPoliza',
'             AND DP.IDPOLIZA   = P.IDPOLIZA',
'	           AND DP.IDETPOL    = 1 ',
'	           AND PC.CODCIA     = DP.CODCIA',
'	           AND PC.CODEMPRESA = DP.CODEMPRESA',
'	           AND PC.IDTIPOSEG  = DP.IDTIPOSEG',
'	           AND PC.PLANCOB    = DP.PLANCOB',
'	           AND VL.CODLISTA   = ''TIPORAMO''',
'	           AND VL.CODVALOR   = PC.CODTIPOPLAN;',
'        EXCEPTION',
'        	WHEN NO_DATA_FOUND THEN',
' 		           nINDPOLCOL :=NULL;',
'          WHEN OTHERS  THEN',
'               nINDPOLCOL :=NULL;',
'        END;	         ',
'     END IF; ',
'     --    ',
'     :P103_IDCOLEINDI := nINDPOLCOL;',
'     --     ',
'     IF :P103_IDCOLEINDI = ''S'' THEN',
'        :P103_NOMIDCOLEINDI := ''COLECTIVO'';',
'     ELSE',
'        :P103_NOMIDCOLEINDI := ''INDIVIDUAL'';',
'     END IF;',
'     --',
'     --',
'  :P103_STS_SINIESTRO:=''SOL'';',
':P103_FECSTS := TRUNC(SYSDATE);',
':P103_FEC_OCURRENCIA := NULL;',
'',
':P103_CODRIESGOREA_1 := :P103_CODRIESGOREA;',
':P103_IDCONTRIBUTORIO_1 := :P103_IDCONTRIBUTORIO;',
':P103_Cod_Moneda_1 := :P103_Cod_Moneda;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(223885474974100869)
,p_internal_uid=>172553037818722646
);
end;
/
begin
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(136778918924749123)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'complementa_1'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'CTIPO_DOC_IDENTIFICACION  ASEGURADO.TIPO_DOC_IDENTIFICACION%TYPE;',
'CNUM_DOC_IDENTIFICACION   ASEGURADO.NUM_DOC_IDENTIFICACION%TYPE;',
'PMENSAJE  VARCHAR2(2000); ',
'',
'begin',
'  BEGIN',
'   SELECT A.TIPO_DOC_IDENTIFICACION,',
'          A.NUM_DOC_IDENTIFICACION   ',
'     INTO CTIPO_DOC_IDENTIFICACION, ',
'          CNUM_DOC_IDENTIFICACION          ',
'     FROM ASEGURADO A',
'    WHERE A.COD_ASEGURADO = :P61_COD_ASEGURADO;',
'  EXCEPTION',
'    WHEN OTHERS THEN NULL;',
'  END;',
'  --',
'  	 IF :P61_NUM_TRIBUTARIO IS NOT NULL THEN',
'  	 	  --',
'--  	 	  :BK_DATOS_SINI.RFC_ASEGURADO := :BK_DATOS_SINI.NUM_TRIBUTARIO;',
'  	 	  --',
'  	 	  UPDATE PERSONA_NATURAL_JURIDICA P',
'           SET P.NUM_TRIBUTARIO = :P61_NUM_TRIBUTARIO',
'         WHERE P.TIPO_DOC_IDENTIFICACION = CTIPO_DOC_IDENTIFICACION',
'           AND P.NUM_DOC_IDENTIFICACION  = CNUM_DOC_IDENTIFICACION;',
'        --',
'        TH_CONTROL_CAMBIO_DATOS.INSERTA_CAMBIO(:CODCIA,',
'                                               :CODEMPRESA,',
'                                               :P61_IDPOLIZA,',
'                                               :P61_IDSINIESTRO,',
'                                               ''NUM_TRIBUTARIO'',                 --CAMPO',
'                                               ''PERSONA_NATURAL_JURIDICA'',        --IDTABLA,',
'                                               :P61_NUM_TRIBUTARIO, --VALORANTERIOR',
'                                               :P61_NUM_TRIBUTARIO,     --VALORNUEVO',
'                                               :APP_USER,',
'                                               ''MODOPE'',',
'                                               PMENSAJE);',
'        --',
'  	 END IF; 	',
'  --',
'  	 IF :P61_CURP IS NOT NULL THEN',
'  	 	  --',
'  	 	  UPDATE PERSONA_NATURAL_JURIDICA P',
'           SET P.CURP = :P61_CURP',
'         WHERE P.TIPO_DOC_IDENTIFICACION = CTIPO_DOC_IDENTIFICACION',
'           AND P.NUM_DOC_IDENTIFICACION  = CNUM_DOC_IDENTIFICACION;',
'        --',
'        TH_CONTROL_CAMBIO_DATOS.INSERTA_CAMBIO(:CODCIA,',
'                                               :CODEMPRESA,',
'                                               :P61_IDPOLIZA,',
'                                               :P61_IDSINIESTRO,',
'                                               ''CURP'',                     --CAMPO',
'                                               ''PERSONA_NATURAL_JURIDICA'', --IDTABLA,',
'                                               :P61_CURP,    --VALORANTERIOR',
'                                               :P61_CURP,        --VALORNUEVO',
'                                               :APP_USER,',
'                                               ''MODOPE'',',
'                                               PMENSAJE);',
'  	 END IF; 	',
'',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(201410199852730396)
,p_internal_uid=>85446386931370899
);
null;
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

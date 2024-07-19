CREATE OR REPLACE PACKAGE SICAS_OC.OC_APIQUIENESQUIEN IS
    
    FUNCTION getToken  RETURN VARCHAR2;

    PROCEDURE Find(
                            PA_NOMBRE           IN  VARCHAR2,
                            PA_RFC              IN  VARCHAR2,
                            PA_FECHANACIMIENTO  IN  VARCHAR2,
                            PA_CURP             IN  VARCHAR2,
                            PA_COINCIDENCIAS    OUT NUMBER);

    FUNCTION FindListas(
                            PA_NOMBRE           IN  VARCHAR2,
                            PA_RFC              IN  VARCHAR2,
                            PA_FECHANACIMIENTO  IN  VARCHAR2,
                            PA_CURP             IN  VARCHAR2,
                            PA_COINCIDENCIAS    OUT NUMBER) RETURN VARCHAR2;

    PROCEDURE FindNvo(
                            PA_NOMBRE           IN  VARCHAR2,
                            PA_RFC              IN  VARCHAR2,
                            PA_FECHANACIMIENTO  IN  VARCHAR2,
                            PA_CURP             IN  VARCHAR2,
                            PA_COINCIDENCIAS    OUT NUMBER,
                            PA_NOMCOMPLETO      OUT VARCHAR2,
                            PA_FECNACIMIENTO    OUT VARCHAR2,
                            PA_RFCOUT           OUT VARCHAR2);

    PROCEDURE FindForms(
                            PA_NOMBRE           IN  VARCHAR2,
                            PA_RFC              IN  VARCHAR2,
                            PA_FECHANACIMIENTO  IN  VARCHAR2,
                            PA_CURP             IN  VARCHAR2,
                            PA_USUARIO          IN  VARCHAR2,
                            PA_COINCIDENCIAS    OUT NUMBER,
                            PA_SALIDA           OUT VARCHAR2);

    req                 utl_http.req;
    res                 utl_http.resp;
    vl_Token            VARCHAR2(4000);
    client_id           VARCHAR2(4000)  := OC_GENERALES.BUSCA_PARAMETRO(1,'QE1');--SI CAMBIA EL ID SECRETO EN PLATAFORMA QUIEN ES QUIEN, SE DEBE ACTUALIZAR EL PARAMETRO

    url_getToken        VARCHAR2(4000)  := OC_GENERALES.BUSCA_PARAMETRO(1,'QE2')||client_id;
    client_secret       VARCHAR2(4000)  := OC_GENERALES.BUSCA_PARAMETRO(1,'QE3'); --SI CAMBIA EL ID SECRETO EN PLATAFORMA QUIEN ES QUIEN, SE DEBE ACTUALIZAR EL PARAMETRO
    url_Find            VARCHAR2(32000) := OC_GENERALES.BUSCA_PARAMETRO(1,'QE4')||client_id||'&'||'username='||OC_GENERALES.BUSCA_PARAMETRO(1,'QE5');  

    vl_parametro1       VARCHAR2(4000)  := '&'||'name=';
    vl_parametro2       VARCHAR2(4000)  := '&'||'rfc=';
    vl_parametro3       VARCHAR2(4000)  := '&'||'birthday=';  
    vl_parametro4       VARCHAR2(4000)  := '&'||'curp=';

    buffer              VARCHAR2(32000);
    lvc_wallet_path     VARCHAR2(100):= OC_GENERALES.BUSCA_PARAMETRO(1,'QE6');
    lvc_wallet_pass     VARCHAR2(20):=  OC_GENERALES.BUSCA_PARAMETRO(1,'QE7');

    v_json_obj          JSON_OBJECT_T;
    v_Succes            VARCHAR2(4000);
    v_msj_respuesta     VARCHAR2(4000);
    v_account_number    VARCHAR2(4000);
    v_data_array        JSON_ARRAY_T;
    v_data_obj          JSON_OBJECT_T;
    l_keys              JSON_KEY_LIST;
    l_keys_str          VARCHAR2(32000);

END;
/

CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_APIQUIENESQUIEN IS
    
    FUNCTION getToken  RETURN VARCHAR2 IS
    
        BEGIN
            utl_http.set_wallet(lvc_wallet_path, lvc_wallet_pass);
            req := utl_http.begin_request( url_getToken, 'GET', ' HTTP/1.1');
            utl_http.set_header( req, 'user-agent', 'mozilla/4.0');
            utl_http.set_header( req,'content-type', 'application/x-www-form-urlencoded' );
            utl_http.set_header(req, 'Authorization', 'Bearer ' ||client_secret);
            --utl_http.write_text(req, content);
            res := utl_http.get_response(req);

            BEGIN
                utl_http.read_line(res, buffer);
                vl_Token := SUBSTR(buffer,INSTR(buffer,'|')+1,LENGTH(buffer));
                --dbms_output.put_line('Token: '||vl_Token);
                utl_http.end_response(res);
            EXCEPTION
                WHEN utl_http.end_of_body THEN
                    utl_http.end_response(res);
            END;

        RETURN vl_Token;
        EXCEPTION
            WHEN utl_http.end_of_body THEN
                utl_http.end_response(res);
                RETURN 'ERROR: '||SQLERRM;
    END getToken;

    PROCEDURE Find(
                            PA_NOMBRE           IN  VARCHAR2,
                            PA_RFC              IN  VARCHAR2,
                            PA_FECHANACIMIENTO  IN  VARCHAR2,
                            PA_CURP             IN  VARCHAR2,
                            PA_COINCIDENCIAS    OUT NUMBER) IS

    vl_Maximo               NUMBER := 0;
    vl_ID_PERSONA           VARCHAR2(30);
    vl_NOMBRE               VARCHAR2(250);
    vl_PATERNO              VARCHAR2(250);
    vl_MATERNO              VARCHAR2(250);
    vl_CURP                 VARCHAR2(300);
    vl_RFC                  VARCHAR2(120);
    vl_FECHA_NACIMIENTO     VARCHAR2(100);
    vl_LISTA                VARCHAR2(100);
    vl_ESTATUS              VARCHAR2(200);
    vl_DEPENDENCIA          VARCHAR2(1000);
    vl_PUESTO               VARCHAR2(1000);
    vl_IDDISPO              NUMBER;
    vl_CURP2                VARCHAR2(300);
    vl_IDREL                VARCHAR2(1000);
    vl_PARENTESCO           VARCHAR2(1000);
    vl_RAZONSOC             VARCHAR2(1000);
    vl_RFCMORAL             VARCHAR2(150);
    vl_ISSSTE               VARCHAR2(1000);
    vl_IMSS                 VARCHAR2(1000);
    vl_INGRESOS             VARCHAR2(1000);
    vl_NOMBRECOMP           VARCHAR2(250);
    vl_APELLIDOS            VARCHAR2(250);
    vl_ENTIDAD              VARCHAR2(1000);
    vl_SEXO                 VARCHAR2(200);
    vl_AREA                 VARCHAR2(1000);

    BEGIN

        vl_parametro1 := vl_parametro1||PA_NOMBRE;
        vl_parametro2 := vl_parametro2||PA_RFC;
        vl_parametro3 := vl_parametro3||PA_FECHANACIMIENTO;  
        vl_parametro4 := vl_parametro4||PA_CURP;

        IF PA_RFC IS NOT NULL THEN
            url_Find := url_Find || vl_parametro2;
        END IF;

        IF PA_NOMBRE IS NOT NULL THEN
            url_Find := url_Find || vl_parametro1;
        END IF;

        IF PA_FECHANACIMIENTO IS NOT NULL THEN
            IF REGEXP_LIKE (PA_FECHANACIMIENTO, '([0-9]|1[0-2])/([0-2][0-9]|3[0-1])/[0-9]{4}')  THEN --Si la fecha tiene formato correcto se toma en cuenta, si no se ignora
                url_Find := url_Find || vl_parametro3;
            --ELSE
                --RAISE_APPLICATION_ERROR(-20000,'Formato de fecha incorrecto, DD/MM/YYYY');
            END IF;
        END IF;

        IF PA_CURP IS NOT NULL THEN
            url_Find := url_Find || vl_parametro4;
        END IF;

        vl_Token := SICAS_OC.OC_APIQUIENESQUIEN.getToken;

        --utl_http.set_wallet(lvc_wallet_path, lvc_wallet_pass);
        req := utl_http.begin_request( url_Find, 'GET', ' HTTP/1.1');
        --utl_http.set_header( req, 'user-agent', 'mozilla/4.0');
        utl_http.set_header( req,'content-type', 'application/json' );
        utl_http.set_header(req, 'Authorization', 'Bearer ' ||vl_Token);

        res := utl_http.get_response(req);
        BEGIN
            LOOP
                utl_http.read_line(res, buffer);
                buffer := REPLACE(buffer,'\u00f3','ó');
                buffer := REPLACE(buffer,'\u00e1','á');
                buffer := REPLACE(buffer,'\u00e9','é');
                buffer := REPLACE(buffer,'\u00cd','í');
                buffer := REPLACE(buffer,'\u00fa','ú');
                buffer := REPLACE(buffer,'\u00dc','ü');
                -- Convertir el JSON de VARCHAR a JSON_OBJECT_T
                v_json_obj := JSON_OBJECT_T.PARSE(buffer);

                -- Imprimir el objeto JSON
                DBMS_OUTPUT.PUT_LINE(v_json_obj.TO_STRING());

                v_Succes := v_json_obj.GET_STRING('success');
                --DBMS_OUTPUT.PUT_LINE('Success: ' || v_Succes);            
                IF v_Succes = 'true' THEN --SI HAY COINCIDENCIAS

                   -- Convertir el JSON de VARCHAR a JSON_OBJECT_T
                    v_json_obj := JSON_OBJECT_T.PARSE(buffer);

                    v_json_obj.On_error(0);

                    v_data_array := v_json_obj.GET_ARRAY('data');

                    --dbms_output.put_line('Coincidencias: '||TO_NUMBER(v_data_array.get_size));
                    PA_COINCIDENCIAS :=TO_NUMBER(v_data_array.get_size);
                    -- Iterar a través de los elementos del array
                    FOR i IN 0..v_data_array.get_size-1 LOOP
                        -- Obtener el objeto JSON dentro del array
                        v_data_obj := json_object_t(v_data_array.get(i));

                        l_keys := v_data_obj.get_keys;

                        FOR x IN 1..l_keys.COUNT LOOP
                            l_keys_str := l_keys_str || l_keys(x) || ',';
                        END LOOP;

                            SELECT NVL(MAX(REGISTRO),0)+1
                            INTO vl_Maximo
                            FROM SICAS_OC.CAT_QEQ;

                            vl_ID_PERSONA       := TO_CHAR(v_data_obj.get_String('ID_PERSONA'));
                            vl_NOMBRE           := TO_CHAR(v_data_obj.get_String('NOMBRE'));
                            vl_PATERNO          := TO_CHAR(v_data_obj.get_String('PATERNO'));
                            vl_MATERNO          := TO_CHAR(v_data_obj.get_String('MATERNO'));
                            vl_CURP             := TO_CHAR(v_data_obj.get_String('CURP'));
                            vl_RFC              := TO_CHAR(v_data_obj.get_String('RFC'));
                            vl_FECHA_NACIMIENTO := TO_CHAR(v_data_obj.get_String('FECHA_NACIMIENTO'));
                            vl_LISTA            := TO_CHAR(v_data_obj.get_String('LISTA'));
                            vl_ESTATUS          := TO_CHAR(v_data_obj.get_String('ESTATUS'));
                            vl_DEPENDENCIA      := TO_CHAR(v_data_obj.get_String('DEPENDENCIA'));
                            vl_PUESTO           := TO_CHAR(v_data_obj.get_String('PUESTO'));
                            vl_IDDISPO          := TO_CHAR(v_data_obj.get_Number('IDDISPO'));
                            vl_CURP2            := TO_CHAR(v_data_obj.get_String('CURP'));
                            vl_IDREL            := TO_CHAR(v_data_obj.get_String('IDREL'));
                            vl_PARENTESCO       := TO_CHAR(v_data_obj.get_String('PARENTESCO'));
                            vl_RAZONSOC         := TO_CHAR(v_data_obj.get_String('RAZONSOC'));
                            vl_RFCMORAL         := TO_CHAR(v_data_obj.get_String('RFCMORAL'));
                            vl_ISSSTE           := TO_CHAR(v_data_obj.get_String('ISSSTE'));
                            vl_IMSS             := TO_CHAR(v_data_obj.get_String('IMSS'));
                            vl_INGRESOS         := TO_CHAR(v_data_obj.get_String('INGRESOS'));
                            vl_NOMBRECOMP       := TO_CHAR(v_data_obj.get_String('NOMBRECOMP'));
                            vl_APELLIDOS        := TO_CHAR(v_data_obj.get_String('APELLIDOS'));
                            vl_ENTIDAD          := TO_CHAR(v_data_obj.get_String('ENTIDAD'));
                            vl_SEXO             := TO_CHAR(v_data_obj.get_String('SEXO'));
                            vl_AREA             := TO_CHAR(v_data_obj.get_String('AREA'));

                            BEGIN
                                INSERT INTO SICAS_OC.CAT_QEQ 
                                    (CODEMPRESA,CODCIA,ID_PROCESO,ID_PERSONA,NOMBRE,PATERNO,MATERNO,CURP,RFC,FECHA_NACIMIENTO, 
                                    LISTA,ESTATUS,DEPENDENCIA,PUESTO,IDDISPO,CURP_OK,IDREL,PARENTESCO,RAZONSOC,RFCMORAL,ISSSTE,
                                    IMSS,INGRESOS,NOMCOMP,APELLIDOS,ENTIDAD,SEXO,AREA,FECHA_PROCESO,ST_PROCESO,REGISTRO,USRMODIFICA )
                                VALUES(
                                    1,1,1,vl_ID_PERSONA,vl_NOMBRE,vl_PATERNO,vl_MATERNO,vl_CURP,vl_RFC,vl_FECHA_NACIMIENTO,vl_LISTA,
                                    vl_ESTATUS,vl_DEPENDENCIA,vl_PUESTO,vl_IDDISPO,0,vl_IDREL,vl_PARENTESCO,vl_RAZONSOC,vl_RFCMORAL,
                                    vl_ISSSTE,vl_IMSS,vl_INGRESOS,vl_NOMBRECOMP,vl_APELLIDOS,vl_ENTIDAD,vl_SEXO,vl_AREA,SYSDATE,'A',vl_Maximo,'SICAS_OC'
                                );
                            EXCEPTION
                                WHEN OTHERS THEN
                                    vl_Maximo := vl_Maximo;
                            END;

    /*
    dbms_output.put_line('IMAGEN	 : ' || v_data_obj.get_String('IMAGEN'));
    dbms_output.put_line('PERIODO	 : ' || v_data_obj.get_String('PERIODO'));
    dbms_output.put_line('EXPEDIENTE	 : ' || v_data_obj.get_String('EXPEDIENTE'));
    dbms_output.put_line('FECHA_RESOLUCION	 : ' || v_data_obj.get_String('FECHA_RESOLUCION'));
    dbms_output.put_line('CAUSA_IRREGULARIDAD	 : ' || v_data_obj.get_String('CAUSA_IRREGULARIDAD'));
    dbms_output.put_line('SANCION	 : ' || v_data_obj.get_String('SANCION'));
    dbms_output.put_line('FECHA_CARGO_INI	 : ' || v_data_obj.get_String('FECHA_CARGO_INI'));
    dbms_output.put_line('facebook_DESCRIPCION	 : ' || v_data_obj.get_String('facebook_DESCRIPCION'));
    dbms_output.put_line('twitter_DESCRIPCION	 : ' || v_data_obj.get_String('twitter_DESCRIPCION'));
    dbms_output.put_line('FECHA_CARGO_FIN	 : ' || v_data_obj.get_String('FECHA_CARGO_FIN'));
    dbms_output.put_line('DURACION	 : ' || v_data_obj.get_String('DURACION'));
    dbms_output.put_line('MONTO	 : ' || v_data_obj.get_String('MONTO'));
    dbms_output.put_line('AUTORIDAD_SANC	 : ' || v_data_obj.get_String('AUTORIDAD_SANC'));
    dbms_output.put_line('ADMON_LOCAL	 : ' || v_data_obj.get_String('ADMON_LOCAL'));
    dbms_output.put_line('NUMORD	 : ' || v_data_obj.get_String('NUMORD'));
    dbms_output.put_line('RUBRO	 : ' || v_data_obj.get_String('RUBRO'));
    dbms_output.put_line('CENTRAL_OBRERA	 : ' || v_data_obj.get_String('CENTRAL_OBRERA'));
    dbms_output.put_line('NUMSOCIOS	 : ' || v_data_obj.get_String('NUMSOCIOS'));
    dbms_output.put_line('FECHA_VIGENCIA	 : ' || v_data_obj.get_String('FECHA_VIGENCIA'));
    dbms_output.put_line('TITULO	 : ' || v_data_obj.get_String('TITULO'));
    dbms_output.put_line('DOMICILIO_A	 : ' || v_data_obj.get_String('DOMICILIO_A'));
    dbms_output.put_line('DOMICILIO_B	 : ' || v_data_obj.get_String('DOMICILIO_B'));
    dbms_output.put_line('COLONIA	 : ' || v_data_obj.get_String('COLONIA'));
    dbms_output.put_line('CP	 : ' || v_data_obj.get_String('CP'));
    dbms_output.put_line('CIUDAD	 : ' || v_data_obj.get_String('CIUDAD'));
    dbms_output.put_line('LADA	 : ' || v_data_obj.get_String('LADA'));
    dbms_output.put_line('TELEFONO	 : ' || v_data_obj.get_String('TELEFONO'));
    dbms_output.put_line('FAX	 : ' || v_data_obj.get_String('FAX'));
    dbms_output.put_line('EMAIL	 : ' || v_data_obj.get_String('EMAIL'));
    dbms_output.put_line('PAIS	 : ' || v_data_obj.get_String('PAIS'));
    dbms_output.put_line('IDREQUERIMIENTO	 : ' || v_data_obj.get_String('IDREQUERIMIENTO'));
    dbms_output.put_line('FECHAOFICIO	 : ' || v_data_obj.get_String('FECHAOFICIO'));
    dbms_output.put_line('BUSCADO_EN	 : ' || v_data_obj.get_String('BUSCADO_EN'));
    dbms_output.put_line('CIUDADANIA	 : ' || v_data_obj.get_String('CIUDADANIA'));
    dbms_output.put_line('PASAPORTE	 : ' || v_data_obj.get_String('PASAPORTE'));
    dbms_output.put_line('CEDULA	 : ' || v_data_obj.get_String('CEDULA'));
    dbms_output.put_line('NSS	 : ' || v_data_obj.get_String('NSS'));
    dbms_output.put_line('SANCION_INFO	 : ' || v_data_obj.get_String('SANCION_INFO'));
    dbms_output.put_line('INE	 : ' || v_data_obj.get_String('INE'));
    dbms_output.put_line('ITALIAN_FISCAL_CODE	 : ' || v_data_obj.get_String('ITALIAN_FISCAL_CODE'));
    dbms_output.put_line('REGISTRATION_ID	 : ' || v_data_obj.get_String('REGISTRATION_ID'));
    dbms_output.put_line('NATIONAL_FOREIGN_ID	 : ' || v_data_obj.get_String('NATIONAL_FOREIGN_ID'));
    dbms_output.put_line('VAT_NUM	 : ' || v_data_obj.get_String('VAT_NUM'));
    dbms_output.put_line('SERIAL_NUM	 : ' || v_data_obj.get_String('SERIAL_NUM'));
    dbms_output.put_line('KENYAN_ID	 : ' || v_data_obj.get_String('KENYAN_ID'));
    dbms_output.put_line('DNI	 : ' || v_data_obj.get_String('DNI'));
    dbms_output.put_line('MEMBER_ETA	 : ' || v_data_obj.get_String('MEMBER_ETA'));
    dbms_output.put_line('OPERATIONS_IN	 : ' || v_data_obj.get_String('OPERATIONS_IN'));
    dbms_output.put_line('ICTY	 : ' || v_data_obj.get_String('ICTY'));
    dbms_output.put_line('REGISTERED_CHARITY_NO	 : ' || v_data_obj.get_String('REGISTERED_CHARITY_NO'));
    dbms_output.put_line('LEGAL_SITUATION	 : ' || v_data_obj.get_String('LEGAL_SITUATION'));
    dbms_output.put_line('BOSIAN_PERSONAL_ID	 : ' || v_data_obj.get_String('BOSIAN_PERSONAL_ID'));
    dbms_output.put_line('PARENTESCO_CON	 : ' || v_data_obj.get_String('PARENTESCO_CON'));
    dbms_output.put_line('LE_NUMBER	 : ' || v_data_obj.get_String('LE_NUMBER'));
    dbms_output.put_line('RUC_NUMBER	 : ' || v_data_obj.get_String('RUC_NUMBER'));
    dbms_output.put_line('CERTIFICATE_NO	 : ' || v_data_obj.get_String('CERTIFICATE_NO'));
    dbms_output.put_line('PERSONAL_ID_CARD	 : ' || v_data_obj.get_String('PERSONAL_ID_CARD'));
    dbms_output.put_line('FEDERAL_ID_CARD	 : ' || v_data_obj.get_String('FEDERAL_ID_CARD'));
    dbms_output.put_line('VISA_NUM	 : ' || v_data_obj.get_String('VISA_NUM'));
    dbms_output.put_line('NUIT	 : ' || v_data_obj.get_String('NUIT'));
    dbms_output.put_line('NIE	 : ' || v_data_obj.get_String('NIE'));
    dbms_output.put_line('CIF	 : ' || v_data_obj.get_String('CIF'));
    dbms_output.put_line('CUIP	 : ' || v_data_obj.get_String('CUIP'));
    dbms_output.put_line('CRN	 : ' || v_data_obj.get_String('CRN'));
    dbms_output.put_line('FOL_MERC	 : ' || v_data_obj.get_String('FOL_MERC'));
    dbms_output.put_line('CR_NO	 : ' || v_data_obj.get_String('CR_NO'));
    dbms_output.put_line('TRUKISH_ID_NUM	 : ' || v_data_obj.get_String('TRUKISH_ID_NUM'));
    dbms_output.put_line('TRIBAL_MEMBER	 : ' || v_data_obj.get_String('TRIBAL_MEMBER'));
    dbms_output.put_line('REFUGEE_ID_CARD	 : ' || v_data_obj.get_String('REFUGEE_ID_CARD'));
    dbms_output.put_line('RESIDENT_CAN	 : ' || v_data_obj.get_String('RESIDENT_CAN'));
    dbms_output.put_line('CNP	 : ' || v_data_obj.get_String('CNP'));
    dbms_output.put_line('RIF	 : ' || v_data_obj.get_String('RIF'));
    dbms_output.put_line('AIRCRAFT	 : ' || v_data_obj.get_String('AIRCRAFT'));
    dbms_output.put_line('INTERPOL_RED_NOTICE	 : ' || v_data_obj.get_String('INTERPOL_RED_NOTICE'));
    dbms_output.put_line('RTN	 : ' || v_data_obj.get_String('RTN'));
    dbms_output.put_line('SRE	 : ' || v_data_obj.get_String('SRE'));
    dbms_output.put_line('COMPANY_NUM	 : ' || v_data_obj.get_String('COMPANY_NUM'));
    dbms_output.put_line('PUBLIC_REG_NUM	 : ' || v_data_obj.get_String('PUBLIC_REG_NUM'));
    dbms_output.put_line('CHINESE_COMMERCIAL_CODE	 : ' || v_data_obj.get_String('CHINESE_COMMERCIAL_CODE'));
    dbms_output.put_line('GOV_GAZ_NUM	 : ' || v_data_obj.get_String('GOV_GAZ_NUM'));
    dbms_output.put_line('CER_INCORP_NUM	 : ' || v_data_obj.get_String('CER_INCORP_NUM'));
    dbms_output.put_line('DUBAI_CHA_COMM_MEM	 : ' || v_data_obj.get_String('DUBAI_CHA_COMM_MEM'));
    dbms_output.put_line('VESSEL	 : ' || v_data_obj.get_String('VESSEL'));
    dbms_output.put_line('MMSI	 : ' || v_data_obj.get_String('MMSI'));
    dbms_output.put_line('INTERNATIONAL_ID	 : ' || v_data_obj.get_String('INTERNATIONAL_ID'));
    dbms_output.put_line('IDENTIFICACION_NO	 : ' || v_data_obj.get_String('IDENTIFICACION_NO'));
    dbms_output.put_line('RESIDENTE_NO	 : ' || v_data_obj.get_String('RESIDENTE_NO'));
    dbms_output.put_line('LICENCIA_COND	 : ' || v_data_obj.get_String('LICENCIA_COND'));
    dbms_output.put_line('CARTILLA_NO	 : ' || v_data_obj.get_String('CARTILLA_NO'));
    dbms_output.put_line('CUIT	 : ' || v_data_obj.get_String('CUIT'));
    dbms_output.put_line('NIT	 : ' || v_data_obj.get_String('NIT'));
    dbms_output.put_line('BUSINESS_REG_NUM	 : ' || v_data_obj.get_String('BUSINESS_REG_NUM'));
    dbms_output.put_line('US_FEIN	 : ' || v_data_obj.get_String('US_FEIN'));
    dbms_output.put_line('TAXID	 : ' || v_data_obj.get_String('TAXID'));
    dbms_output.put_line('WEB	 : ' || v_data_obj.get_String('WEB'));
    dbms_output.put_line('MATRICULA_MERC	 : ' || v_data_obj.get_String('MATRICULA_MERC'));
    dbms_output.put_line('GAFI	 : ' || v_data_obj.get_String('GAFI'));
    dbms_output.put_line('REPIFE	 : ' || v_data_obj.get_String('REPIFE'));
    dbms_output.put_line('OCED	 : ' || v_data_obj.get_String('OCED'));
    dbms_output.put_line('ORGANISMOS	 : ' || v_data_obj.get_String('ORGANISMOS'));
    dbms_output.put_line('nombrecompsndx	 : ' || v_data_obj.get_String('nombrecompsndx'));
    dbms_output.put_line('ncampos	 : ' || v_data_obj.get_Number('ncampos'));
    dbms_output.put_line('RELACIONADOS	 : ' || v_data_obj.get_String('RELACIONADOS'));
    dbms_output.put_line('DISPOSICION	 : ' || v_data_obj.get_String('DISPOSICION'));
    dbms_output.put_line('CATEGORIA_RIESGO	 : ' || v_data_obj.get_String('CATEGORIA_RIESGO'));
    dbms_output.put_line('COINCIDENCIA	 : ' || v_data_obj.get_Number('COINCIDENCIA'));
    dbms_output.put_line('CAT_INGRESOS	 : ' || v_data_obj.get_String('CAT_INGRESOS'));
    dbms_output.put_line('ORGANISMOS	 : ' || v_data_obj.get_String('ORGANISMOS'));
    dbms_output.put_line('ORGANO	 : ' || v_data_obj.get_String('ORGANO'));
    dbms_output.put_line('TEXTO	 : ' || v_data_obj.get_String('TEXTO'));
    */

                    END LOOP;

                ELSE --NO HAY COINCIDENCIAS
                    v_msj_respuesta := v_json_obj.GET_STRING('status');
                    PA_COINCIDENCIAS := 0;
                    --dbms_output.put_line('Resultado: '||v_msj_respuesta);
                END IF;

            END LOOP;
            COMMIT;
            utl_http.end_response(res);
        EXCEPTION
            WHEN utl_http.end_of_body THEN
                PA_COINCIDENCIAS := 0;
                utl_http.end_response(res);
        END;

    EXCEPTION
            WHEN utl_http.end_of_body THEN
                PA_COINCIDENCIAS := 0;
                utl_http.end_response(res);
    END;

    FUNCTION FindListas(
                            PA_NOMBRE           IN  VARCHAR2,
                            PA_RFC              IN  VARCHAR2,
                            PA_FECHANACIMIENTO  IN  VARCHAR2,
                            PA_CURP             IN  VARCHAR2,
                            PA_COINCIDENCIAS    OUT NUMBER) RETURN VARCHAR2 IS

    vl_Listas   VARCHAR2(4000);

    BEGIN

        vl_parametro1 := vl_parametro1||PA_NOMBRE;
        vl_parametro2 := vl_parametro2||PA_RFC;
        vl_parametro3 := vl_parametro3||PA_FECHANACIMIENTO;  
        vl_parametro4 := vl_parametro4||PA_CURP;

        IF PA_RFC IS NOT NULL THEN
            url_Find := url_Find || vl_parametro2;
        END IF;

        IF PA_NOMBRE IS NOT NULL THEN
            url_Find := url_Find || vl_parametro1;
        END IF;

        IF PA_FECHANACIMIENTO IS NOT NULL THEN
            IF REGEXP_LIKE (PA_FECHANACIMIENTO, '([0-9]|1[0-2])/([0-2][0-9]|3[0-1])/[0-9]{4}')  THEN --Si la fecha tiene formato correcto se toma en cuenta, si no se ignora
                url_Find := url_Find || vl_parametro3;
            --ELSE
                --RAISE_APPLICATION_ERROR(-20000,'Formato de fecha incorrecto, DD/MM/YYYY');
            END IF;
        END IF;

        IF PA_CURP IS NOT NULL THEN
            url_Find := url_Find || vl_parametro4;
        END IF;

        vl_Token := SICAS_OC.OC_APIQUIENESQUIEN.getToken;

        --utl_http.set_wallet(lvc_wallet_path, lvc_wallet_pass);
        req := utl_http.begin_request( url_Find, 'GET', ' HTTP/1.1');
        --utl_http.set_header( req, 'user-agent', 'mozilla/4.0');
        utl_http.set_header( req,'content-type', 'application/json' );
        utl_http.set_header(req, 'Authorization', 'Bearer ' ||vl_Token);

        res := utl_http.get_response(req);
        BEGIN
            LOOP
                utl_http.read_line(res, buffer);
                buffer := REPLACE(buffer,'\u00f3','ó');
                buffer := REPLACE(buffer,'\u00e1','á');
                buffer := REPLACE(buffer,'\u00e9','é');
                buffer := REPLACE(buffer,'\u00cd','í');
                buffer := REPLACE(buffer,'\u00fa','ú');
                buffer := REPLACE(buffer,'\u00dc','ü');
                -- Convertir el JSON de VARCHAR a JSON_OBJECT_T
                v_json_obj := JSON_OBJECT_T.PARSE(buffer);

                -- Imprimir el objeto JSON

                v_Succes := v_json_obj.GET_STRING('success');
                IF v_Succes = 'true' THEN --SI HAY COINCIDENCIAS

                   -- Convertir el JSON de VARCHAR a JSON_OBJECT_T
                    v_json_obj := JSON_OBJECT_T.PARSE(buffer);

                    v_json_obj.On_error(0);

                    v_data_array := v_json_obj.GET_ARRAY('data');

                    PA_COINCIDENCIAS := TO_NUMBER(v_data_array.get_size);
                    -- Iterar a través de los elementos del array
                    FOR i IN 0..v_data_array.get_size-1 LOOP
                        -- Obtener el objeto JSON dentro del array
                        v_data_obj := json_object_t(v_data_array.get(i));

                        l_keys := v_data_obj.get_keys;

                        FOR x IN 1..l_keys.COUNT LOOP
                            l_keys_str := l_keys_str || l_keys(x) || ',';
                        END LOOP;

                            IF i = 0 THEN
                                vl_Listas := v_data_obj.get_String('LISTA');
                            ELSE
                                IF vl_Listas  NOT LIKE '%'||v_data_obj.get_String('LISTA')||'%' THEN 
                                    vl_Listas := vl_Listas||','||v_data_obj.get_String('LISTA');
                                END IF;
                            END IF;
                    END LOOP;

                ELSE --NO HAY COINCIDENCIAS
                    v_msj_respuesta := v_json_obj.GET_STRING('status');
                    PA_COINCIDENCIAS := 0;
                    vl_Listas := '';
                END IF;

            RETURN vl_Listas;
            END LOOP;

            utl_http.end_response(res);
        EXCEPTION
            WHEN utl_http.end_of_body THEN
                PA_COINCIDENCIAS := 0;
                RETURN  '';
                utl_http.end_response(res);
        END;

    EXCEPTION
            WHEN utl_http.end_of_body THEN
                PA_COINCIDENCIAS := 0;
                RETURN '';
                utl_http.end_response(res);
    END FindListas;

    PROCEDURE FindNvo(
                            PA_NOMBRE           IN  VARCHAR2,
                            PA_RFC              IN  VARCHAR2,
                            PA_FECHANACIMIENTO  IN  VARCHAR2,
                            PA_CURP             IN  VARCHAR2,
                            PA_COINCIDENCIAS    OUT NUMBER,
                            PA_NOMCOMPLETO      OUT VARCHAR2,
                            PA_FECNACIMIENTO    OUT VARCHAR2,
                            PA_RFCOUT           OUT VARCHAR2) IS

    vl_Maximo               NUMBER := 0;
    vl_ID_PERSONA           VARCHAR2(30);
    vl_NOMBRE               VARCHAR2(250);
    vl_PATERNO              VARCHAR2(250);
    vl_MATERNO              VARCHAR2(250);
    vl_CURP                 VARCHAR2(30);
    vl_RFC                  VARCHAR2(20);
    vl_FECHA_NACIMIENTO     VARCHAR2(20);
    vl_LISTA                VARCHAR2(10);
    vl_ESTATUS              VARCHAR2(20);
    vl_DEPENDENCIA          VARCHAR2(1000);
    vl_PUESTO               VARCHAR2(1000);
    vl_IDDISPO              NUMBER;
    vl_CURP2                VARCHAR2(30);
    vl_IDREL                VARCHAR2(1000);
    vl_PARENTESCO           VARCHAR2(1000);
    vl_RAZONSOC             VARCHAR2(1000);
    vl_RFCMORAL             VARCHAR2(15);
    vl_ISSSTE               VARCHAR2(1000);
    vl_IMSS                 VARCHAR2(1000);
    vl_INGRESOS             VARCHAR2(1000);
    vl_NOMBRECOMP           VARCHAR2(250);
    vl_APELLIDOS            VARCHAR2(250);
    vl_ENTIDAD              VARCHAR2(1000);
    vl_SEXO                 VARCHAR2(20);
    vl_AREA                 VARCHAR2(1000);

    BEGIN

        vl_parametro1 := vl_parametro1||PA_NOMBRE;
        vl_parametro2 := vl_parametro2||PA_RFC;
        vl_parametro3 := vl_parametro3||PA_FECHANACIMIENTO;  
        vl_parametro4 := vl_parametro4||PA_CURP;

        IF PA_RFC IS NOT NULL THEN
            url_Find := url_Find || vl_parametro2;
        END IF;

        IF PA_NOMBRE IS NOT NULL THEN
            url_Find := url_Find || vl_parametro1;
        END IF;

        IF PA_FECHANACIMIENTO IS NOT NULL THEN
            IF REGEXP_LIKE (PA_FECHANACIMIENTO, '([0-9]|1[0-2])/([0-2][0-9]|3[0-1])/[0-9]{4}')  THEN --Si la fecha tiene formato correcto se toma en cuenta, si no se ignora
                url_Find := url_Find || vl_parametro3;
            --ELSE
                --RAISE_APPLICATION_ERROR(-20000,'Formato de fecha incorrecto, DD/MM/YYYY');
            END IF;
        END IF;

        IF PA_CURP IS NOT NULL THEN
            url_Find := url_Find || vl_parametro4;
        END IF;

        url_Find := url_Find||'&'||'limit=1';

        vl_Token := SICAS_OC.OC_APIQUIENESQUIEN.getToken;

        --utl_http.set_wallet(lvc_wallet_path, lvc_wallet_pass);
        req := utl_http.begin_request( url_Find, 'GET', ' HTTP/1.1');
        --utl_http.set_header( req, 'user-agent', 'mozilla/4.0');
        utl_http.set_header( req,'content-type', 'application/json' );
        utl_http.set_header(req, 'Authorization', 'Bearer ' ||vl_Token);

        res := utl_http.get_response(req);
        BEGIN
            --LOOP
                utl_http.read_line(res, buffer);
                buffer := REPLACE(buffer,'\u00f3','ó');
                buffer := REPLACE(buffer,'\u00e1','á');
                buffer := REPLACE(buffer,'\u00e9','é');
                buffer := REPLACE(buffer,'\u00cd','í');
                buffer := REPLACE(buffer,'\u00fa','ú');
                buffer := REPLACE(buffer,'\u00dc','ü');
                -- Convertir el JSON de VARCHAR a JSON_OBJECT_T
                v_json_obj := JSON_OBJECT_T.PARSE(buffer);

                -- Imprimir el objeto JSON
                --DBMS_OUTPUT.PUT_LINE(v_json_obj.TO_STRING());

                v_Succes := v_json_obj.GET_STRING('success');
                --DBMS_OUTPUT.PUT_LINE('Success: ' || v_Succes);            
                IF v_Succes = 'true' THEN --SI HAY COINCIDENCIAS

                   -- Convertir el JSON de VARCHAR a JSON_OBJECT_T
                    v_json_obj := JSON_OBJECT_T.PARSE(buffer);

                    v_json_obj.On_error(0);

                    v_data_array := v_json_obj.GET_ARRAY('data');

                    --dbms_output.put_line('Coincidencias: '||TO_NUMBER(v_data_array.get_size));
                    -- Iterar a través de los elementos del array
                    --FOR i IN 0..v_data_array.get_size LOOP
                        -- Obtener el objeto JSON dentro del array
                        v_data_obj := json_object_t(v_data_array.get(0));

                        l_keys := v_data_obj.get_keys;


                            SELECT NVL(MAX(REGISTRO),0)+1
                            INTO vl_Maximo
                            FROM SICAS_OC.CAT_QEQ;

                            vl_ID_PERSONA       := TO_CHAR(v_data_obj.get_String('ID_PERSONA'));
                            vl_NOMBRE           := TO_CHAR(v_data_obj.get_String('NOMBRE'));
                            vl_PATERNO          := TO_CHAR(v_data_obj.get_String('PATERNO'));
                            vl_MATERNO          := TO_CHAR(v_data_obj.get_String('MATERNO'));
                            vl_CURP             := TO_CHAR(v_data_obj.get_String('CURP'));
                            vl_RFC              := TO_CHAR(v_data_obj.get_String('RFC'));
                            vl_FECHA_NACIMIENTO := TO_CHAR(v_data_obj.get_String('FECHA_NACIMIENTO'));
                            vl_LISTA            := TO_CHAR(v_data_obj.get_String('LISTA'));
                            vl_ESTATUS          := TO_CHAR(v_data_obj.get_String('ESTATUS'));
                            vl_DEPENDENCIA      := TO_CHAR(v_data_obj.get_String('DEPENDENCIA'));
                            vl_PUESTO           := TO_CHAR(v_data_obj.get_String('PUESTO'));
                            vl_IDDISPO          := TO_CHAR(v_data_obj.get_Number('IDDISPO'));
                            vl_CURP2            := TO_CHAR(v_data_obj.get_String('CURP'));
                            vl_IDREL            := TO_CHAR(v_data_obj.get_String('IDREL'));
                            vl_PARENTESCO       := TO_CHAR(v_data_obj.get_String('PARENTESCO'));
                            vl_RAZONSOC         := TO_CHAR(v_data_obj.get_String('RAZONSOC'));
                            vl_RFCMORAL         := TO_CHAR(v_data_obj.get_String('RFCMORAL'));
                            vl_ISSSTE           := TO_CHAR(v_data_obj.get_String('ISSSTE'));
                            vl_IMSS             := TO_CHAR(v_data_obj.get_String('IMSS'));
                            vl_INGRESOS         := TO_CHAR(v_data_obj.get_String('INGRESOS'));
                            vl_NOMBRECOMP       := TO_CHAR(v_data_obj.get_String('NOMBRECOMP'));
                            vl_APELLIDOS        := TO_CHAR(v_data_obj.get_String('APELLIDOS'));
                            vl_ENTIDAD          := TO_CHAR(v_data_obj.get_String('ENTIDAD'));
                            vl_SEXO             := TO_CHAR(v_data_obj.get_String('SEXO'));
                            vl_AREA             := TO_CHAR(v_data_obj.get_String('AREA'));

                            PA_NOMCOMPLETO      := vl_NOMBRECOMP;
                            PA_FECNACIMIENTO    := vl_FECHA_NACIMIENTO;
                            PA_RFCOUT           := vl_RFC;

                            IF PA_NOMCOMPLETO IS NOT NULL THEN
                                PA_COINCIDENCIAS := 1;
                            ELSE
                                PA_COINCIDENCIAS := 0;
                            END IF;

                            BEGIN
                                INSERT INTO SICAS_OC.CAT_QEQ 
                                    (CODEMPRESA,CODCIA,ID_PROCESO,ID_PERSONA,NOMBRE,PATERNO,MATERNO,CURP,RFC,FECHA_NACIMIENTO, 
                                    LISTA,ESTATUS,DEPENDENCIA,PUESTO,IDDISPO,CURP_OK,IDREL,PARENTESCO,RAZONSOC,RFCMORAL,ISSSTE,
                                    IMSS,INGRESOS,NOMCOMP,APELLIDOS,ENTIDAD,SEXO,AREA,FECHA_PROCESO,ST_PROCESO,REGISTRO,USRMODIFICA )
                                VALUES(
                                    1,1,1,vl_ID_PERSONA,vl_NOMBRE,vl_PATERNO,vl_MATERNO,vl_CURP,vl_RFC,vl_FECHA_NACIMIENTO,vl_LISTA,
                                    vl_ESTATUS,vl_DEPENDENCIA,vl_PUESTO,vl_IDDISPO,0,vl_IDREL,vl_PARENTESCO,vl_RAZONSOC,vl_RFCMORAL,
                                    vl_ISSSTE,vl_IMSS,vl_INGRESOS,vl_NOMBRECOMP,vl_APELLIDOS,vl_ENTIDAD,vl_SEXO,vl_AREA,SYSDATE,'A',vl_Maximo,'SICAS_OC'
                                );
                            EXCEPTION
                                WHEN OTHERS THEN
                                    vl_Maximo := vl_Maximo;
                            END;

                    --END LOOP;

                ELSE --NO HAY COINCIDENCIAS
                    v_msj_respuesta := v_json_obj.GET_STRING('status');
                    PA_COINCIDENCIAS := 0;
                    PA_NOMCOMPLETO      := vl_NOMBRECOMP;
                    PA_FECNACIMIENTO    := vl_FECHA_NACIMIENTO;
                    PA_RFCOUT           := vl_RFC;
                    --dbms_output.put_line('Resultado: '||v_msj_respuesta);
                END IF;

            --END LOOP;
            COMMIT;
            utl_http.end_response(res);
        EXCEPTION
            WHEN utl_http.end_of_body THEN
                dbms_output.put_line('***********'||SQLERRM);
                PA_COINCIDENCIAS := 0;
                PA_NOMCOMPLETO      := vl_NOMBRECOMP;
                PA_FECNACIMIENTO    := vl_FECHA_NACIMIENTO;
                PA_RFCOUT           := vl_RFC;
                utl_http.end_response(res);
        END;

    EXCEPTION
            WHEN utl_http.end_of_body THEN
                PA_COINCIDENCIAS := 0;
                utl_http.end_response(res);
    END FindNvo;

    PROCEDURE FindForms(
                            PA_NOMBRE           IN  VARCHAR2,
                            PA_RFC              IN  VARCHAR2,
                            PA_FECHANACIMIENTO  IN  VARCHAR2,
                            PA_CURP             IN  VARCHAR2,
                            PA_USUARIO          IN  VARCHAR2,
                            PA_COINCIDENCIAS    OUT NUMBER,
                            PA_SALIDA           OUT VARCHAR2) IS

    vl_Salida               VARCHAR2(4000);
    cTotal                  NUMBER := 0;
    vl_Maximo               NUMBER := 0;
    vl_ID_PERSONA           VARCHAR2(100);
    vl_NOMBRE               VARCHAR2(250);
    vl_PATERNO              VARCHAR2(250);
    vl_MATERNO              VARCHAR2(250);
    vl_CURP                 VARCHAR2(30);
    vl_RFC                  VARCHAR2(100);
    vl_FECHA_NACIMIENTO     VARCHAR2(10);
    vl_LISTA                VARCHAR2(50);
    vl_ESTATUS              VARCHAR2(20);
    vl_DEPENDENCIA          VARCHAR2(1000);
    vl_PUESTO               VARCHAR2(1000);
    vl_IDDISPO              NUMBER := 0;
    vl_CURP2                VARCHAR2(100);
    vl_IDREL                VARCHAR2(1000);
    vl_PARENTESCO           VARCHAR2(1000);
    vl_RAZONSOC             VARCHAR2(1000);
    vl_RFCMORAL             VARCHAR2(50);
    vl_ISSSTE               VARCHAR2(1000);
    vl_IMSS                 VARCHAR2(1000);
    vl_INGRESOS             VARCHAR2(1000);
    vl_NOMBRECOMP           VARCHAR2(250);
    vl_APELLIDOS            VARCHAR2(250);
    vl_ENTIDAD              VARCHAR2(1000);
    vl_SEXO                 VARCHAR2(50);
    vl_AREA                 VARCHAR2(1000);

    BEGIN
    PA_COINCIDENCIAS := 0;
        DELETE FROM SICAS_OC.CAT_QEQ 
        WHERE USRMODIFICA = PA_USUARIO
            AND ST_PROCESO = 'F';

        COMMIT;

        vl_parametro1 := vl_parametro1||PA_NOMBRE;
        vl_parametro2 := vl_parametro2||PA_RFC;
        vl_parametro3 := vl_parametro3||PA_FECHANACIMIENTO;  
        vl_parametro4 := vl_parametro4||PA_CURP;

        IF PA_RFC IS NOT NULL THEN
            url_Find := url_Find || vl_parametro2;
        END IF;

        IF PA_NOMBRE IS NOT NULL THEN
            url_Find := url_Find || vl_parametro1;
        END IF;

        IF PA_FECHANACIMIENTO IS NOT NULL THEN
            IF REGEXP_LIKE (PA_FECHANACIMIENTO, '([0-9]|1[0-2])/([0-2][0-9]|3[0-1])/[0-9]{4}')  THEN --Si la fecha tiene formato correcto se toma en cuenta, si no se ignora
                url_Find := url_Find || vl_parametro3;
            END IF;
        END IF;

        IF PA_CURP IS NOT NULL THEN
            url_Find := url_Find || vl_parametro4;
        END IF;

        BEGIN
            vl_Token := SICAS_OC.OC_APIQUIENESQUIEN.getToken;
        EXCEPTION
            WHEN OTHERS THEN
                raise_application_error(-20000,'ERROR AL CONSUMIR TOKEN');
        END;

        utl_http.set_wallet(lvc_wallet_path, lvc_wallet_pass);
        req := utl_http.begin_request( url_Find, 'GET', ' HTTP/1.1');
        --utl_http.set_header( req, 'user-agent', 'mozilla/4.0');
        utl_http.set_header( req,'content-type', 'application/json' );
        utl_http.set_header(req, 'Authorization', 'Bearer ' ||vl_Token);

/*
BUSCAR LIMPIAR COOKIES CON UTL_HTTP
O ASIGNAR UN ID DE SESSION CON UTL_HTTP
O VER COMO CAMBIAR EL CLIENT
*/

        res := utl_http.get_response(req);
        BEGIN
            LOOP
                --utl_http.read_line(res, buffer);
                UTL_HTTP.READ_TEXT(res, buffer,32767);
                buffer := REPLACE(buffer,'\u00f3','ó');
                buffer := REPLACE(buffer,'\u00e1','á');
                buffer := REPLACE(buffer,'\u00e9','é');
                buffer := REPLACE(buffer,'\u00cd','í');
                buffer := REPLACE(buffer,'\u00fa','ú');
                buffer := REPLACE(buffer,'\u00dc','ü');
                -- Convertir el JSON de VARCHAR a JSON_OBJECT_T
                v_json_obj := JSON_OBJECT_T.PARSE(buffer);

                v_Succes := v_json_obj.GET_STRING('success');

                IF v_Succes = 'true' THEN --SI HAY COINCIDENCIAS

                   -- Convertir el JSON de VARCHAR a JSON_OBJECT_T
                    v_json_obj := JSON_OBJECT_T.PARSE(buffer);

                    v_json_obj.On_error(0);

                    v_data_array := v_json_obj.GET_ARRAY('data');

                    PA_COINCIDENCIAS :=TO_NUMBER(v_data_array.get_size);
                    -- Iterar a través de los elementos del array
                    FOR i IN 0..v_data_array.get_size-1 LOOP
                        -- Obtener el objeto JSON dentro del array
                        v_data_obj := json_object_t(v_data_array.get(i));

                        l_keys := v_data_obj.get_keys;

                        FOR x IN 1..l_keys.COUNT LOOP
                            l_keys_str := l_keys_str || l_keys(x) || ',';
                        END LOOP;

                            SELECT NVL(MAX(REGISTRO),0)+1
                            INTO vl_Maximo
                            FROM SICAS_OC.CAT_QEQ;

                            vl_ID_PERSONA       := TO_CHAR(v_data_obj.get_String('ID_PERSONA'));
                            vl_NOMBRE           := TO_CHAR(v_data_obj.get_String('NOMBRE'));
                            vl_PATERNO          := TO_CHAR(v_data_obj.get_String('PATERNO'));
                            vl_MATERNO          := TO_CHAR(v_data_obj.get_String('MATERNO'));
                            vl_CURP             := TO_CHAR(v_data_obj.get_String('CURP'));
                            vl_RFC              := TO_CHAR(v_data_obj.get_String('RFC'));
                            vl_FECHA_NACIMIENTO := TO_CHAR(v_data_obj.get_String('FECHA_NACIMIENTO'));
                            vl_LISTA            := TO_CHAR(v_data_obj.get_String('LISTA'));
                            vl_ESTATUS          := TO_CHAR(v_data_obj.get_String('ESTATUS'));
                            vl_DEPENDENCIA      := TO_CHAR(v_data_obj.get_String('DEPENDENCIA'));
                            vl_PUESTO           := TO_CHAR(v_data_obj.get_String('PUESTO'));
                            vl_IDDISPO          := NVL(TO_CHAR(v_data_obj.get_Number('IDDISPO')),0);
                            vl_CURP2            := TO_CHAR(v_data_obj.get_String('CURP'));
                            vl_IDREL            := TO_CHAR(v_data_obj.get_String('IDREL'));
                            vl_PARENTESCO       := TO_CHAR(v_data_obj.get_String('PARENTESCO'));
                            vl_RAZONSOC         := TO_CHAR(v_data_obj.get_String('RAZONSOC'));
                            vl_RFCMORAL         := TO_CHAR(v_data_obj.get_String('RFCMORAL'));
                            vl_ISSSTE           := TO_CHAR(v_data_obj.get_String('ISSSTE'));
                            vl_IMSS             := TO_CHAR(v_data_obj.get_String('IMSS'));
                            vl_INGRESOS         := TO_CHAR(v_data_obj.get_String('INGRESOS'));
                            vl_NOMBRECOMP       := TO_CHAR(v_data_obj.get_String('NOMBRECOMP'));
                            vl_APELLIDOS        := TO_CHAR(v_data_obj.get_String('APELLIDOS'));
                            vl_ENTIDAD          := TO_CHAR(v_data_obj.get_String('ENTIDAD'));
                            vl_SEXO             := TO_CHAR(v_data_obj.get_String('SEXO'));
                            vl_AREA             := TO_CHAR(v_data_obj.get_String('AREA'));

                            BEGIN
                                INSERT INTO SICAS_OC.CAT_QEQ 
                                    (CODEMPRESA,CODCIA,ID_PROCESO,ID_PERSONA,NOMBRE,PATERNO,MATERNO,CURP,RFC,FECHA_NACIMIENTO, 
                                    LISTA,ESTATUS,DEPENDENCIA,PUESTO,IDDISPO,CURP_OK,IDREL,PARENTESCO,RAZONSOC,RFCMORAL,ISSSTE,
                                    IMSS,INGRESOS,NOMCOMP,APELLIDOS,ENTIDAD,SEXO,AREA,FECHA_PROCESO,ST_PROCESO,REGISTRO,USRMODIFICA )
                                VALUES(
                                    1,1,1,vl_ID_PERSONA,vl_NOMBRE,vl_PATERNO,vl_MATERNO,vl_CURP,vl_RFC,vl_FECHA_NACIMIENTO,vl_LISTA,
                                    vl_ESTATUS,vl_DEPENDENCIA,vl_PUESTO,vl_IDDISPO,0,vl_IDREL,vl_PARENTESCO,vl_RAZONSOC,vl_RFCMORAL,
                                    vl_ISSSTE,vl_IMSS,vl_INGRESOS,vl_NOMBRECOMP,vl_APELLIDOS,vl_ENTIDAD,vl_SEXO,vl_AREA,SYSDATE,'F',vl_Maximo,PA_USUARIO
                                );
                            EXCEPTION
                                WHEN OTHERS THEN
                                    vl_Maximo := 0;
                                    DBMS_OUTPUT.PUT_LINE('ERROR INSRETAR: '||SQLERRM);
                            END;


                    END LOOP;
                    PA_SALIDA := 'termine'||vl_Token;
                    COMMIT;

                /*ELSE --NO HAY COINCIDENCIAS
                    v_msj_respuesta := v_json_obj.GET_STRING('status');
                    PA_COINCIDENCIAS := 0;
                    PA_SALIDA := 'ERR: '||v_Succes||' - '||v_msj_respuesta||' TOKEEEENNN -'||vl_Token;*/
                END IF;

            END LOOP;
            DBMS_LOCK.SLEEP(2);   
           -- utl_http.end_response(res);
        EXCEPTION
            WHEN  UTL_HTTP.TOO_MANY_REQUESTS THEN
                utl_http.end_response(res);
                PA_SALIDA :='mess:' ||utl_http.get_detailed_sqlerrm;
            WHEN utl_http.end_of_body THEN
                utl_http.end_response(res);
        END;

    EXCEPTION
            WHEN utl_http.end_of_body THEN
                utl_http.end_response(res);
            WHEN OTHERS THEN
                PA_SALIDA :=  'Error: '||utl_http.get_detailed_sqlerrm;
                utl_http.end_response(res);
    END;
END;
/

CREATE OR REPLACE PUBLIC SYNONYM OC_APIQUIENESQUIEN FOR SICAS_OC.OC_APIQUIENESQUIEN;
    
GRANT EXECUTE ON SICAS_OC.OC_APIQUIENESQUIEN TO PUBLIC;
/
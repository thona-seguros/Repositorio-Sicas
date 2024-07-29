create or replace PROCEDURE          SICAS_OC.getInfoHTTPSini(
                                        PA_NOMBRE           IN  VARCHAR2,
                                        PA_RFC              IN  VARCHAR2,
                                        PA_FECHANACIMIENTO  IN  VARCHAR2,
                                        PA_CURP             IN  VARCHAR2,
                                        PA_COINCIDENCIAS    OUT NUMBER) IS
                                        
        
        vl_Token            VARCHAR2(4000);
        req                 utl_http.req;
        res                 utl_http.resp;
        client_id           VARCHAR2(4000) := OC_GENERALES.BUSCA_PARAMETRO(1,'QE1');--SI CAMBIA EL ID SECRETO EN PLATAFORMA QUIEN ES QUIEN, SE DEBE ACTUALIZAR EL PARAMETRO
        --OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'021');
        url_getToken        VARCHAR2(4000) := OC_GENERALES.BUSCA_PARAMETRO(1,'QE2')||client_id;
        client_secret       VARCHAR2(4000) := OC_GENERALES.BUSCA_PARAMETRO(1,'QE3'); --SI CAMBIA EL ID SECRETO EN PLATAFORMA QUIEN ES QUIEN, SE DEBE ACTUALIZAR EL PARAMETRO
        url_Find            VARCHAR2(32000) := OC_GENERALES.BUSCA_PARAMETRO(1,'QE4')||client_id||'&'||'username='||OC_GENERALES.BUSCA_PARAMETRO(1,'QE5');  

        vl_parametro1       VARCHAR2(4000) := '&'||'name='||PA_NOMBRE;
        vl_parametro2       VARCHAR2(4000) := '&'||'rfc='||PA_RFC;
        vl_parametro3       VARCHAR2(4000) := '&'||'birthday='||PA_FECHANACIMIENTO;  
        vl_parametro4       VARCHAR2(4000) := '&'||'curp='||PA_CURP;
        

        buffer              VARCHAR2(32000);
        lvc_wallet_path     VARCHAR2(100):= OC_GENERALES.BUSCA_PARAMETRO(1,'QE6');
        lvc_wallet_pass     VARCHAR2(20):=  OC_GENERALES.BUSCA_PARAMETRO(1,'QE7');
        umbral_search       VARCHAR2(5):=  OC_GENERALES.BUSCA_PARAMETRO(1,'QE8');
        v_json_obj          JSON_OBJECT_T;
        v_Succes            VARCHAR2(4000);
        v_msj_respuesta     VARCHAR2(4000);
        v_account_number    VARCHAR2(4000);
        v_data_array        JSON_ARRAY_T;
        v_data_obj          JSON_OBJECT_T;
        l_keys              JSON_KEY_LIST;
        l_keys_str          VARCHAR2(32000);

BEGIN

    IF PA_RFC IS NOT NULL THEN
        url_Find := url_Find || vl_parametro2;
    END IF;

    IF PA_FECHANACIMIENTO IS NOT NULL THEN
        IF REGEXP_LIKE (PA_FECHANACIMIENTO, '([0-9]|1[0-2])/([0-2][0-9]|3[0-1])/[0-9]{4}')  THEN --Si la fecha tiene formato correcto se toma en cuenta, si no se ignora
            url_Find := url_Find || vl_parametro3;
        END IF;
    END IF;

    IF PA_CURP IS NOT NULL THEN
        url_Find := url_Find || vl_parametro4;
    END IF;

    IF PA_NOMBRE IS NOT NULL THEN
        url_Find := url_Find || vl_parametro1;
    END IF;
    
    url_Find := url_Find ||'&'||'percent='||NVL(umbral_search,'90');
    
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
            --DBMS_OUTPUT.PUT_LINE(v_json_obj.TO_STRING());

            v_Succes := v_json_obj.GET_STRING('success');
            --DBMS_OUTPUT.PUT_LINE('Success: ' || v_Succes);            
            IF v_Succes = 'true' THEN --SI HAY COINCIDENCIAS

               -- Convertir el JSON de VARCHAR a JSON_OBJECT_T
                v_json_obj := JSON_OBJECT_T.PARSE(buffer);

                v_json_obj.On_error(0);

                v_data_array := v_json_obj.GET_ARRAY('data');

                dbms_output.put_line('Coincidencias: '||TO_NUMBER(v_data_array.get_size));
                PA_COINCIDENCIAS :=TO_NUMBER(v_data_array.get_size);
                -- Iterar a través de los elementos del array
                FOR i IN 0..v_data_array.get_size-1 LOOP
                    -- Obtener el objeto JSON dentro del array
                    v_data_obj := json_object_t(v_data_array.get(i));

                    l_keys := v_data_obj.get_keys;

                    FOR x IN 1..l_keys.COUNT LOOP
                        l_keys_str := l_keys_str || l_keys(x) || ',';
                    END LOOP;
					/*    
					dbms_output.put_line('ID_PERSONA	 : ' || v_data_obj.get_String('ID_PERSONA'));
					dbms_output.put_line('NOMBRE	 : ' || v_data_obj.get_String('NOMBRE'));
					dbms_output.put_line('PATERNO	 : ' || v_data_obj.get_String('PATERNO'));
					dbms_output.put_line('MATERNO	 : ' || v_data_obj.get_String('MATERNO'));
					dbms_output.put_line('CURP	 : ' || v_data_obj.get_String('CURP'));
					dbms_output.put_line('RFC	 : ' || v_data_obj.get_String('RFC'));
					dbms_output.put_line('FECHA_NACIMIENTO	 : ' || v_data_obj.get_String('FECHA_NACIMIENTO'));
					dbms_output.put_line('SEXO	 : ' || v_data_obj.get_String('SEXO'));
					dbms_output.put_line('LISTA	 : ' || v_data_obj.get_String('LISTA'));
					dbms_output.put_line('ESTATUS	 : ' || v_data_obj.get_String('ESTATUS'));
					*/		
                END LOOP;

            ELSE --NO HAY COINCIDENCIAS
                v_msj_respuesta := v_json_obj.GET_STRING('status');
                PA_COINCIDENCIAS := 0;
                --dbms_output.put_line('Resultado: '||v_msj_respuesta);
            END IF;

        END LOOP;
        utl_http.end_response(res);
    EXCEPTION
        WHEN utl_http.end_of_body THEN
            utl_http.end_response(res);
    END;
END ;
/

CREATE OR REPLACE PUBLIC SYNONYM getInfoHTTPSini FOR SICAS_OC.getInfoHTTPSini;
    
GRANT EXECUTE ON SICAS_OC.getInfoHTTPSini TO PUBLIC;
/
create or replace PACKAGE SICAS_OC.OC_CAT_QEQ IS

FUNCTION ES_QEQ(cTipoDocIdentEmp VARCHAR2,cNumDocIdentEmp VARCHAR2) RETURN VARCHAR2;

PROCEDURE ES_FORMS(
                            PA_NOMBRE           IN  VARCHAR2,
                            PA_RFC              IN  VARCHAR2,
                            PA_FECHANACIMIENTO  IN  VARCHAR2,
                            PA_CURP             IN  VARCHAR2,
                            PA_USUARIO          IN  VARCHAR2,
                            PA_COINCIDENCIAS    OUT NUMBER,
                            PA_SALIDA           OUT VARCHAR2) ;

-- jmmd20181123
PROCEDURE ES_QEQ_NVO(P_TIPO_DOC_IDENTIFICACION        VARCHAR2,
           P_NUM_DOC_IDENTIFICACION         VARCHAR2, 
           P_NOMCOMPQEQ                     OUT VARCHAR2, 
           P_FECHA_NACIMIENTOQEQ            OUT DATE, 
           P_FECNACIMIENTOPNJ               OUT DATE,
           P_RFCQEQ                         OUT VARCHAR2, 
           P_LISTAQEQ                       OUT VARCHAR2, 
           P_VALORSCG                       OUT VARCHAR2, 
           P_REGRESOQEQ                     OUT VARCHAR2);

FUNCTION ES_QEQ_SINIESTRO(cTipoDocIdentEmp VARCHAR2, cNumDocIdentEmp VARCHAR2, cNombreBenef VARCHAR2, cFechaNacimiento varchar2) RETURN VARCHAR2;          

FUNCTION BUSCA_EN_LISTAS_QEQ(P_NOMCOMPQEQ  VARCHAR2) RETURN VARCHAR2;

    vl_TotalCoincidencias  NUMBER := 0;
    vl_ValorBusqueda   VARCHAR2(100);
    vl_ValorBusqueda2   VARCHAR2(100);
END OC_CAT_QEQ;
/

create or replace PACKAGE BODY SICAS_OC.OC_CAT_QEQ IS
--
-- BITACORA DE CAMBIO
-- ALTA   JICO 20170518
-- MODIFICAR LOS CRITERIOS DE VALIDACION EN QEQ		JMMD20181120
FUNCTION ES_QEQ(cTipoDocIdentEmp VARCHAR2, cNumDocIdentEmp VARCHAR2) RETURN VARCHAR2 IS
cES_QEQ     VARCHAR2(1);

 W_NOMBRE         ADMON_RIESGO.NOMBRE%TYPE;
 W_FECNACIMIENTO  PERSONA_NATURAL_JURIDICA.FECNACIMIENTO%TYPE;
    vl_Nacimiento   VARCHAR2(15);
BEGIN
   W_NOMBRE        := TRIM(OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(cTipoDocIdentEmp, cNumDocIdentEmp));
   W_FECNACIMIENTO := OC_PERSONA_NATURAL_JURIDICA.FECHA_NACIMIENTO(cTipoDocIdentEmp, cNumDocIdentEmp);

    IF W_FECNACIMIENTO IS NOT NULL THEN
        vl_Nacimiento := TO_CHAR(W_FECNACIMIENTO,'DD/MM/YYYY');
    ELSE
        vl_Nacimiento := NULL;
    END IF;

   IF cTipoDocIdentEmp = 'RFC' THEN
    vl_ValorBusqueda := cNumDocIdentEmp;
   ELSIF    cTipoDocIdentEmp = 'CURP' THEN
    vl_ValorBusqueda2 := cNumDocIdentEmp;
   END IF;

   BEGIN
        SICAS_OC.getInfoHTTP(W_NOMBRE,vl_ValorBusqueda,vl_Nacimiento,vl_ValorBusqueda2,vl_TotalCoincidencias);

        cES_QEQ := 'S';
   EXCEPTION
    WHEN OTHERS THEN
        vl_TotalCoincidencias := 0;
        cES_QEQ := 'N';
    END;
   --
   -- VALIDA POR NOMBRE
   --

   IF vl_TotalCoincidencias = 0 THEN 

   BEGIN
     SELECT 'S'
       INTO cES_QEQ
       FROM SICAS_OC.CAT_QEQ Q
      WHERE Q.NOMCOMP = W_NOMBRE;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN

          --
          -- VALIDA POR RFC Y FECHA DE NACIMIENTO
          --

          BEGIN
            SELECT 'S'
               INTO cES_QEQ
               FROM SICAS_OC.CAT_QEQ Q
              WHERE Q.RFC = cNumDocIdentEmp
                AND Q.FECHA_NACIMIENTO = W_FECNACIMIENTO;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 --
                 -- VALIDA POR RFC
                 --
                 BEGIN
                   SELECT 'S'
                     INTO cES_QEQ
                     FROM SICAS_OC.CAT_QEQ Q
                    WHERE Q.RFC = cNumDocIdentEmp;
                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                        cES_QEQ := 'N';
                   WHEN TOO_MANY_ROWS THEN
                       cES_QEQ := 'S';
                 END;
                 --
            WHEN TOO_MANY_ROWS THEN
                 cES_QEQ := 'S';
          END;
        --
     WHEN TOO_MANY_ROWS THEN
           cES_QEQ := 'S';
   END;
   END IF;

   RETURN(cES_QEQ);
END ES_QEQ;

PROCEDURE ES_FORMS(
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

    vl_parametro1       VARCHAR2(4000)  := '&'||'name=';
    vl_parametro2       VARCHAR2(4000)  := '&'||'rfc=';
    vl_parametro3       VARCHAR2(4000)  := '&'||'birthday=';  
    vl_parametro4       VARCHAR2(4000)  := '&'||'curp=';
    vl_Token            VARCHAR2(4000);
    client_id           VARCHAR2(4000)  := OC_GENERALES.BUSCA_PARAMETRO(1,'QE1');--SI CAMBIA EL ID SECRETO EN PLATAFORMA QUIEN ES QUIEN, SE DEBE ACTUALIZAR EL PARAMETRO

    url_getToken        VARCHAR2(4000)  := OC_GENERALES.BUSCA_PARAMETRO(1,'QE2')||client_id;
    client_secret       VARCHAR2(4000)  := OC_GENERALES.BUSCA_PARAMETRO(1,'QE3'); --SI CAMBIA EL ID SECRETO EN PLATAFORMA QUIEN ES QUIEN, SE DEBE ACTUALIZAR EL PARAMETRO
    url_Find            VARCHAR2(32000) := OC_GENERALES.BUSCA_PARAMETRO(1,'QE4')||client_id||'&'||'username='||OC_GENERALES.BUSCA_PARAMETRO(1,'QE5');  

    buffer              VARCHAR2(32000);
    lvc_wallet_path     VARCHAR2(100):= OC_GENERALES.BUSCA_PARAMETRO(1,'QE6');
    lvc_wallet_pass     VARCHAR2(20):=  OC_GENERALES.BUSCA_PARAMETRO(1,'QE7');
    umbral_search       VARCHAR2(5):=  OC_GENERALES.BUSCA_PARAMETRO(1,'QE8');
    req                 utl_http.req;
    res                 utl_http.resp;
    v_json_obj          JSON_OBJECT_T;
    v_Succes            VARCHAR2(4000);
    v_msj_respuesta     VARCHAR2(4000);
    v_account_number    VARCHAR2(4000);
    v_data_array        JSON_ARRAY_T;
    v_data_obj          JSON_OBJECT_T;
    l_keys              JSON_KEY_LIST;
    l_keys_str          VARCHAR2(32000);

    BEGIN

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
        
        url_Find := url_Find ||'&'||'percent='||NVL(umbral_search,'90');
        
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
                                    DBMS_OUTPUT.PUT_LINE('ERROR INSERTAR: '||SQLERRM);
                            END;


                    END LOOP;
                    PA_SALIDA := 'termine'||vl_Token;
                    COMMIT;

                ELSE --NO HAY COINCIDENCIAS
                    v_msj_respuesta := v_json_obj.GET_STRING('status');
                    PA_COINCIDENCIAS := 0;
                    PA_SALIDA := v_msj_respuesta;
                    exit;
                END IF;

            END LOOP;
            DBMS_LOCK.SLEEP(2);   
           -- utl_http.end_response(res);
        EXCEPTION
            WHEN  UTL_HTTP.TOO_MANY_REQUESTS THEN
                utl_http.end_response(res);
                PA_SALIDA :=  v_Succes;
            WHEN utl_http.end_of_body THEN
                utl_http.end_response(res);
                PA_SALIDA :=  v_Succes;
        END;

    EXCEPTION
            WHEN utl_http.end_of_body THEN
                utl_http.end_response(res);
                PA_SALIDA :=  v_Succes;
            WHEN OTHERS THEN
                PA_SALIDA :=  'error: '||utl_http.get_detailed_sqlerrm;
                PA_COINCIDENCIAS := -2;
                utl_http.end_response(res);
    END;

PROCEDURE ES_QEQ_NVO(P_TIPO_DOC_IDENTIFICACION                   VARCHAR2,
                                P_NUM_DOC_IDENTIFICACION         VARCHAR2, 
                                P_NOMCOMPQEQ                     OUT VARCHAR2, 
                                P_FECHA_NACIMIENTOQEQ            OUT DATE, 
                                P_FECNACIMIENTOPNJ               OUT DATE,
                                P_RFCQEQ                         OUT VARCHAR2, 
                                P_LISTAQEQ                       OUT VARCHAR2, 
                                P_VALORSCG                       OUT VARCHAR2, 
                                P_REGRESOQEQ                     OUT VARCHAR2) IS

 W_NOMBRE                       ADMON_RIESGO.NOMBRE%TYPE;
 W_FECNACIMIENTO                PERSONA_NATURAL_JURIDICA.FECNACIMIENTO%TYPE;
 W_NOMCOMP                      VARCHAR2(1500);
 W_FECHA_NACIMIENTO             PERSONA_NATURAL_JURIDICA.FECNACIMIENTO%TYPE; --CAT_QEQ.fecha_nacimiento%TYPE;
 W_RFC                          VARCHAR2(200);
 W_LISTA                        ADMON_RIESGO.Observaciones%TYPE;
 W_VALOR_LARGO                  SAI_CAT_GENERAL.CAGE_VALOR_LARGO%TYPE;
 vl_Nombre                      VARCHAR2(1500);
 vl_Nacimiento                  VARCHAR2(20);
 vl_RFC                         VARCHAR2(200);
vl_Nacimiento1                  VARCHAR2(20);
BEGIN

   W_NOMBRE        := TRIM(OC_PERSONA_NATURAL_JURIDICA.NOMBRE_COMPLETO(P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION));
   W_FECNACIMIENTO := OC_PERSONA_NATURAL_JURIDICA.FECHA_NACIMIENTO(P_TIPO_DOC_IDENTIFICACION, P_NUM_DOC_IDENTIFICACION);

    IF W_FECNACIMIENTO IS NOT NULL THEN
        vl_Nacimiento1 := TO_CHAR(W_FECNACIMIENTO,'DD/MM/YYYY');
    ELSE
        vl_Nacimiento1 := NULL;
    END IF;

   W_LISTA := OC_CAT_QEQ.BUSCA_EN_LISTAS_QEQ(W_NOMBRE);

    IF P_TIPO_DOC_IDENTIFICACION = 'RFC' THEN
    vl_ValorBusqueda := P_NUM_DOC_IDENTIFICACION;
   ELSIF    P_TIPO_DOC_IDENTIFICACION = 'CURP' THEN
    vl_ValorBusqueda2 := P_NUM_DOC_IDENTIFICACION;
   END IF;

   BEGIN

        SICAS_OC.OC_APIQUIENESQUIEN.FindNvo(W_NOMBRE,vl_ValorBusqueda,vl_Nacimiento1,vl_ValorBusqueda2,vl_TotalCoincidencias,vl_Nombre,vl_Nacimiento,vl_RFC);

        W_NOMCOMP           :=  vl_Nombre;
        W_RFC               :=  vl_RFC;

        IF vl_Nacimiento IS NOT NULL THEN
            W_FECHA_NACIMIENTO  :=  TO_DATE(vl_Nacimiento,'DD/MM/YYYY');
        END IF;
   EXCEPTION
    WHEN OTHERS THEN
        vl_TotalCoincidencias := 0;
        P_REGRESOQEQ            := 'N4';
        P_NOMCOMPQEQ            := NULL;
        P_FECHA_NACIMIENTOQEQ   := NULL;
        P_FECNACIMIENTOPNJ      := NULL;
        P_RFCQEQ                := NULL;
        P_LISTAQEQ              := NULL;
        P_VALORSCG              := NULL;
        DBMS_OUTPUT.put_line('ME FUI POR DEFAULT A NECESIDAD 5 '||SQLERRM);
    END;
   --
   -- VALIDA POR NOMBRE
   --

   IF vl_TotalCoincidencias = 0 THEN 

   BEGIN

     SELECT DISTINCT Q.NOMCOMP,to_date(Q.fecha_nacimiento,'dd/mm/yyyy'), Q.RFC
       INTO W_NOMCOMP, W_FECHA_NACIMIENTO, W_RFC       
       FROM SICAS_OC.CAT_QEQ Q
           , SICAS_OC.PERSONA_NATURAL_JURIDICA PNJ
--           , SAI_CAT_GENERAL SCG
      WHERE ((Q.NOMCOMP = W_NOMBRE
      AND PNJ.TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION
      AND PNJ.NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION   
      AND Q.RFC IS NOT NULL
      AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NOT NULL 
      AND PNJ.FECNACIMIENTO IS NOT NULL    
      AND Q.RFC = PNJ.NUM_DOC_IDENTIFICACION     
      AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') = PNJ.FECNACIMIENTO )  
      OR (Q.NOMCOMP = W_NOMBRE
         AND PNJ.TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION      
         AND PNJ.NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION 
         AND Q.RFC IS NOT NULL
         AND PNJ.FECNACIMIENTO IS NOT NULL   
         AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NOT NULL   
         AND Q.RFC = PNJ.NUM_DOC_IDENTIFICACION
         AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') != PNJ.FECNACIMIENTO )  
      OR (Q.NOMCOMP = W_NOMBRE
         AND PNJ.TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION      
         AND PNJ.NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION   
         AND Q.RFC IS NOT NULL   
         AND Q.RFC = PNJ.NUM_DOC_IDENTIFICACION
         AND PNJ.FECNACIMIENTO IS NOT NULL 
         AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NULL)
--         AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') != PNJ.FECNACIMIENTO)
      OR (Q.NOMCOMP = W_NOMBRE
         AND PNJ.TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION      
         AND PNJ.NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION    
         AND Q.RFC IS NOT NULL   
         AND Q.RFC = PNJ.NUM_DOC_IDENTIFICACION  
         AND PNJ.FECNACIMIENTO IS NULL 
         AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NOT NULL )
--         AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') != PNJ.FECNACIMIENTO)  
      OR (Q.NOMCOMP = W_NOMBRE
         AND PNJ.TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION      
         AND PNJ.NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION    
         AND Q.RFC IS NOT NULL   
         AND Q.RFC = PNJ.NUM_DOC_IDENTIFICACION  
         AND PNJ.FECNACIMIENTO IS NULL      
         AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') is null   )   
--         AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') = PNJ.FECNACIMIENTO ) 
      OR (Q.NOMCOMP = W_NOMBRE
         AND PNJ.TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION      
         AND PNJ.NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION    
         AND Q.RFC IS NOT NULL   
         AND Q.RFC != PNJ.NUM_DOC_IDENTIFICACION  
         AND PNJ.FECNACIMIENTO IS NOT NULL      
         AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NOT NULL      
         AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') = PNJ.FECNACIMIENTO )  
      OR (Q.NOMCOMP = W_NOMBRE
         AND PNJ.TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION      
         AND PNJ.NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION    
         AND Q.RFC IS NULL   
         AND PNJ.FECNACIMIENTO IS NOT NULL      
         AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NOT NULL      
         AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') = PNJ.FECNACIMIENTO ))  ;                                   

      P_REGRESOQEQ            := 'N1';
      P_NOMCOMPQEQ            := W_NOMCOMP;
      P_FECHA_NACIMIENTOQEQ   := W_FECHA_NACIMIENTO;
      P_FECNACIMIENTOPNJ      := W_FECNACIMIENTO;
      P_RFCQEQ                := W_RFC;
      P_LISTAQEQ              := W_LISTA;
      P_VALORSCG              := W_VALOR_LARGO;
      DBMS_OUTPUT.put_line('ME FUI POR NECESIDAD 1');
   EXCEPTION
      WHEN TOO_MANY_ROWS THEN
        P_REGRESOQEQ            := 'N1';
        P_NOMCOMPQEQ            := W_NOMCOMP;
        P_FECHA_NACIMIENTOQEQ   := W_FECHA_NACIMIENTO;
        P_FECNACIMIENTOPNJ      := W_FECNACIMIENTO;
        P_RFCQEQ                := W_RFC;
        P_LISTAQEQ              := W_LISTA;
        P_VALORSCG              := W_VALOR_LARGO;         
      WHEN NO_DATA_FOUND THEN
                 -- VALIDA NECESIDAD 2
        BEGIN   

         SELECT DISTINCT Q.NOMCOMP,to_date(Q.fecha_nacimiento,'dd/mm/yyyy'), Q.RFC         
           INTO W_NOMCOMP, W_FECHA_NACIMIENTO, W_RFC

           FROM SICAS_OC.CAT_QEQ Q
                 , SICAS_OC.PERSONA_NATURAL_JURIDICA PNJ
--                 , SAI_CAT_GENERAL SCG
           WHERE ((Q.NOMCOMP = W_NOMBRE
             AND PNJ.TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION   
             AND PNJ.NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION 
             AND Q.RFC IS NOT NULL
             AND PNJ.FECNACIMIENTO IS NOT NULL             
             AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NOT NULL     
             AND Q.RFC != PNJ.NUM_DOC_IDENTIFICACION    
             AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') != PNJ.FECNACIMIENTO )                        
             or (Q.NOMCOMP = W_NOMBRE
                AND PNJ.TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION   
                AND PNJ.NUM_DOC_IDENTIFICACION  = P_NUM_DOC_IDENTIFICACION 
                AND Q.RFC IS NOT NULL
                AND PNJ.FECNACIMIENTO IS NOT NULL             
                AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NULL     
                AND Q.RFC != PNJ.NUM_DOC_IDENTIFICACION  )  
--                AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') != PNJ.FECNACIMIENTO )
             or (Q.NOMCOMP = W_NOMBRE
                AND PNJ.TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION   
                AND PNJ.NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION 
                AND Q.RFC IS NOT NULL
                AND PNJ.FECNACIMIENTO IS NULL             
                AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NOT NULL     
                AND Q.RFC != PNJ.NUM_DOC_IDENTIFICACION  )  
--                AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') != PNJ.FECNACIMIENTO )             
             or (Q.NOMCOMP = W_NOMBRE
                AND PNJ.TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION   
                AND PNJ.NUM_DOC_IDENTIFICACION = P_NUM_DOC_IDENTIFICACION 
                AND Q.RFC IS NULL
                AND PNJ.FECNACIMIENTO IS NOT NULL             
                AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NOT NULL 
--                AND Q.RFC != PNJ.NUM_DOC_IDENTIFICACION                
                AND NVL(Q.RFC,'XXXXXXXXXXXXX') != PNJ.NUM_DOC_IDENTIFICACION                        
                AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') != PNJ.FECNACIMIENTO ))  ;           
/*             AND SCG.CAGE_CD_CATALOGO = 5
             AND SCG.CAGE_NOM_CONCEP = Q.LISTA;  */ --JMMD20190611

--                
          P_REGRESOQEQ            := 'N2';
          P_NOMCOMPQEQ            := W_NOMCOMP;
          P_FECHA_NACIMIENTOQEQ   := W_FECHA_NACIMIENTO;
          P_FECNACIMIENTOPNJ      := W_FECNACIMIENTO;
          P_RFCQEQ                := W_RFC;
          P_LISTAQEQ              := W_LISTA;
          P_VALORSCG              := W_VALOR_LARGO;
          DBMS_OUTPUT.put_line('ME FUI POR NECESIDAD 2');
        EXCEPTION
          WHEN TOO_MANY_ROWS THEN
            P_REGRESOQEQ            := 'N2';
            P_NOMCOMPQEQ            := W_NOMCOMP;
            P_FECHA_NACIMIENTOQEQ   := W_FECHA_NACIMIENTO;
            P_FECNACIMIENTOPNJ      := W_FECNACIMIENTO;
            P_RFCQEQ                := W_RFC;
            P_LISTAQEQ              := W_LISTA;
            P_VALORSCG              := W_VALOR_LARGO;             
          WHEN NO_DATA_FOUND THEN
                 -- VALIDA NECESIDAD 3  
             BEGIN

               SELECT DISTINCT Q.NOMCOMP,to_date(Q.fecha_nacimiento,'dd/mm/yyyy'), Q.RFC               
                  INTO W_NOMCOMP, W_FECHA_NACIMIENTO, W_RFC

                  FROM SICAS_OC.CAT_QEQ Q
                       , SICAS_OC.PERSONA_NATURAL_JURIDICA PNJ
--                       , SAI_CAT_GENERAL SCG  
                 WHERE ((Q.NOMCOMP = W_NOMBRE
                   AND PNJ.TIPO_DOC_IDENTIFICACION = P_TIPO_DOC_IDENTIFICACION   
                   AND PNJ.NUM_DOC_IDENTIFICACION  = P_NUM_DOC_IDENTIFICACION    
                   AND Q.RFC IS NULL             
                   AND TO_DATE(Q.FECHA_NACIMIENTO,'DD/MM/YYYY') IS NULL));
/*                  AND SCG.CAGE_CD_CATALOGO = 5
                  AND SCG.CAGE_NOM_CONCEP = Q.LISTA ;  */ -- JMMD20190611

                P_REGRESOQEQ            := 'N3';
                P_NOMCOMPQEQ            := W_NOMCOMP;
                P_FECHA_NACIMIENTOQEQ   := W_FECHA_NACIMIENTO;
                P_FECNACIMIENTOPNJ      := W_FECNACIMIENTO;
                P_RFCQEQ                := W_RFC;
                P_LISTAQEQ              := W_LISTA;
                P_VALORSCG              := W_VALOR_LARGO;  

                DBMS_OUTPUT.put_line('ME FUI POR NECESIDAD 3');
             EXCEPTION
                WHEN TOO_MANY_ROWS THEN
                    P_REGRESOQEQ            := 'N3';
                    P_NOMCOMPQEQ            := W_NOMCOMP;
                    P_FECHA_NACIMIENTOQEQ   := W_FECHA_NACIMIENTO;
                    P_FECNACIMIENTOPNJ      := W_FECNACIMIENTO;
                    P_RFCQEQ                := W_RFC;
                    P_LISTAQEQ              := W_LISTA;
                    P_VALORSCG              := W_VALOR_LARGO;                     
                WHEN OTHERS THEN
                 --                      
                P_REGRESOQEQ            := 'N4';
                P_NOMCOMPQEQ            := NULL;
                P_FECHA_NACIMIENTOQEQ   := NULL;
                P_FECNACIMIENTOPNJ      := NULL;
                P_RFCQEQ                := NULL;
                P_LISTAQEQ              := NULL;
                P_VALORSCG              := NULL;
                DBMS_OUTPUT.put_line('ME FUI POR DEFAULT A NECESIDAD 4 '||SQLERRM);
             END;
        END;
--      
   END;   
    END IF;
END ES_QEQ_NVO; 

FUNCTION ES_QEQ_SINIESTRO(cTipoDocIdentEmp VARCHAR2, cNumDocIdentEmp VARCHAR2, cNombreBenef VARCHAR2, cFechaNacimiento varchar2) RETURN VARCHAR2 IS
cES_QEQ     VARCHAR2(1);

 W_NOMBRE         ADMON_RIESGO.NOMBRE%TYPE;

BEGIN
   W_NOMBRE        := cNombreBenef ;

   IF cTipoDocIdentEmp = 'RFC' THEN
    vl_ValorBusqueda := cNumDocIdentEmp;
   ELSIF    cTipoDocIdentEmp = 'CURP' THEN
    vl_ValorBusqueda2 := cNumDocIdentEmp;
   END IF;

   BEGIN
    SICAS_OC.getInfoHTTPSini(W_NOMBRE,vl_ValorBusqueda,cFechaNacimiento,vl_ValorBusqueda2,vl_TotalCoincidencias);
        IF vl_TotalCoincidencias > 0 THEN
            cES_QEQ := 'S';
        ELSE
            cES_QEQ := 'N';
        END IF;
   EXCEPTION
    WHEN OTHERS THEN
        vl_TotalCoincidencias := 0;
        cES_QEQ := 'N';
    END;
   --
   -- VALIDA POR NOMBRE
   --

   IF vl_TotalCoincidencias = 0 THEN 

   --
   -- VALIDA POR NOMBRE , FECHA DE NACIMIENTO Y RFC
   --
   BEGIN
     SELECT 'S'
       INTO cES_QEQ
       FROM SICAS_OC.CAT_QEQ Q
      WHERE Q.NOMCOMP = W_NOMBRE
        AND Q.FECHA_NACIMIENTO = cFechaNacimiento      
        AND Q.RFC = cNumDocIdentEmp;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN   
   -- VALIDA POR NOMBRE Y RFC     
         BEGIN
           SELECT 'S'
             INTO cES_QEQ
             FROM SICAS_OC.CAT_QEQ Q
            WHERE Q.NOMCOMP = W_NOMBRE      
              AND Q.RFC = cNumDocIdentEmp;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
          --
          -- VALIDA POR NOMBRE
          --
          BEGIN
            SELECT 'S'
               INTO cES_QEQ
               FROM SICAS_OC.CAT_QEQ Q
      	     WHERE Q.NOMCOMP = W_NOMBRE ;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 --
                 -- VALIDA POR RFC
                 --
                 BEGIN
                   SELECT 'S'
                     INTO cES_QEQ
                     FROM SICAS_OC.CAT_QEQ Q
                    WHERE Q.RFC = cNumDocIdentEmp;
                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                        cES_QEQ := 'N';
                   WHEN TOO_MANY_ROWS THEN
                       cES_QEQ := 'S';
                 END;
                 --
                 WHEN TOO_MANY_ROWS THEN
                      cES_QEQ := 'S';
                 END;
            WHEN TOO_MANY_ROWS THEN
               cES_QEQ := 'S';
            END;
        --
     WHEN TOO_MANY_ROWS THEN
           cES_QEQ := 'S';
     END;
   END IF;

   RETURN(cES_QEQ);
END ES_QEQ_SINIESTRO;

FUNCTION BUSCA_EN_LISTAS_QEQ(P_NOMCOMPQEQ  VARCHAR2) RETURN VARCHAR2 IS        
W_LISTAS        ADMON_RIESGO.Observaciones%TYPE;


W_SPV           NUMBER := 0;  
--
CURSOR QUIENESQUIEN IS
SELECT DISTINCT Q.LISTA, SCG.CAGE_VALOR_LARGO
  FROM SICAS_OC.CAT_QEQ Q
  , SICAS_OC.SAI_CAT_GENERAL SCG 
 WHERE Q.NOMCOMP = P_NOMCOMPQEQ 
   AND SCG.CAGE_CD_CATALOGO = 5
   AND SCG.CAGE_NOM_CONCEP = Q.LISTA  
;

vl_Listas           VARCHAR2(4000);
vl_Coincidencias    NUMBER;

CURSOR QUIENESQUIEN1 IS
SELECT DISTINCT SCG.CAGE_NOM_CONCEP LISTA, SCG.CAGE_VALOR_LARGO
  FROM SICAS_OC.SAI_CAT_GENERAL SCG 
 WHERE SCG.CAGE_CD_CATALOGO = 5
   AND SCG.CAGE_NOM_CONCEP IN (SELECT REGEXP_SUBSTR(vl_Listas,'[^,]+', 1, LEVEL) 
                                FROM DUAL
                                CONNECT BY REGEXP_SUBSTR(vl_Listas,'[^,]+', 1, LEVEL) IS NOT NULL)
;


BEGIN
    vl_Listas := SICAS_OC.OC_APIQUIENESQUIEN.FindListas(P_NOMCOMPQEQ,NULL,NULL,NULL,vl_Coincidencias);

    IF vl_Coincidencias > 0 THEN
        /*FOR X IN QUIENESQUIEN1 LOOP
           IF W_SPV = 0 THEN
              W_LISTAS := ('REGISTRADO EN LAS SIGUIENTES LISTAS: '||X.LISTA);
              W_SPV := 1;
           ELSE
              W_LISTAS := W_LISTAS|| (','||' '||X.LISTA||' ');
           END IF;
        END LOOP;*/
        --SE REQUIERE CON EL CRUCE DE LA TABLA COMO EN EL CURSOR O LAS LISTAS QUE TRAIGA QUIEN ES QUIEN BASTA?

        W_LISTAS := ('REGISTRADO EN LAS SIGUIENTES LISTAS: '||vl_Listas);

    ELSE

        FOR X IN QUIENESQUIEN LOOP
           IF W_SPV = 0 THEN
              W_LISTAS := ('REGISTRADO EN LAS SIGUIENTES LISTAS: '||X.LISTA);
              W_SPV := 1;
           ELSE
              W_LISTAS := W_LISTAS|| (','||' '||X.LISTA||' ');
           END IF;
        END LOOP;
    END IF;

    DBMS_OUTPUT.PUT_LINE(W_LISTAS);           
    RETURN (W_LISTAS);

END BUSCA_EN_LISTAS_QEQ; 

END OC_CAT_QEQ;
/

CREATE OR REPLACE PUBLIC SYNONYM OC_CAT_QEQ FOR SICAS_OC.OC_CAT_QEQ;
    
GRANT EXECUTE ON SICAS_OC.OC_CAT_QEQ TO PUBLIC;
/
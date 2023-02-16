CREATE OR REPLACE PACKAGE          GT_WEB_SERVICES AS
    --
    xmlString   VARCHAR2(32767);
    xmlResult   XMLTYPE;
    xmlDom      DBMS_XMLDOM.DOMDocument;

    FUNCTION ExtraStr(cTAG clob,                cXxmlString clob := xmlString) return varchar2;
    FUNCTION SPLIT(p_list varchar2,             p_del VARCHAR2 := ',' ) return split_tbl pipelined;
    FUNCTION JOIN(p_cursor sys_refcursor,       p_del varchar2 := ',') return varchar2;
    FUNCTION RETORNA_PARAM(pParametro VARCHAR2, pParamEntrada CLOB) return VARCHAR2;
    FUNCTION REMPLAZA_ISO88591 (pParamEntrada VARCHAR2) return VARCHAR2;
    FUNCTION Ejecuta_WS(pCodCia NUMBER,         pCodEmpresa NUMBER, pIdWeb NUMBER, pIdWebResp NUMBER, Resultado OUT VARCHAR2, pParamSql VARCHAR2 := NULL)  RETURN XMLTYPE;   
    FUNCTION ExtraeDatos_XML(Doc XMLTYPE,       DatosTag varchar2) Return Varchar2;  
    PROCEDURE InicializaDom (Doc XMLTYPE);
    FUNCTION REPLACE_CLOB (I_SOURCE IN CLOB ,   I_SEARCH IN VARCHAR2 ,I_REPLACE IN CLOB) RETURN CLOB;
    FUNCTION GENERA_XML(pCodCia NUMBER,         pCodEmpresa NUMBER, pIdeWebXml NUMBER, cDatosXml VARCHAR2 := NULL) RETURN XMLTYPE;    
    FUNCTION ExtraeDatos_XmlDom(Tags clob) Return CLOB;
    FUNCTION Similitud(pCadena1 varchar2,       pCadena2 varchar2) RETURN NUMBER;
    FUNCTION Similitud_Porcentual(pCadena1 varchar2, pCadena2 varchar2) return NUMBER;
    --
END GT_WEB_SERVICES;

/

CREATE OR REPLACE PACKAGE BODY          GT_WEB_SERVICES IS
    --
    FUNCTION ExtraStr(cTAG clob, cXxmlString clob := xmlString) return varchar2 is        
        cValor clob;
        cTagUpp clob;
    BEGIN    
        cTagUpp :=  upper(cTag);
        select VALOR
          INTO cValor
          from (
                select 
                        to_clob(upper(substr(column_value, 1, instr(column_value, '>')-1))) tag,
                        substr(column_value, instr(column_value, '>')+1, instr(column_value, '</')-(instr(column_value, '>')+1)) valor
                  from table(GT_WEB_SERVICES.split(cXxmlString, '><'))  
            )
        where TAG IS NOT NULL
          AND DBMS_LOB.Compare(TAG, cTagUpp) = 0;                              
        RETURN cValor;
    EXCEPTION WHEN OTHERS THEN
        RETURN NULL;        
    END ExtraStr;
    --
    FUNCTION split (p_list varchar2, p_del VARCHAR2 := ',') return split_tbl pipelined
        is
        -- select * from table(split('one,two,three'));
            l_idx    NUMBER;
            l_list   varchar2(32727) := p_list;
    Begin
            loop
                l_idx := instr(l_list,p_del);
                if l_idx > 0 then
                    pipe row(substr(l_list,1,l_idx-1));
                    l_list := substr(l_list,l_idx+length(p_del));
                else
                    pipe row(l_list);
                    exit;
                end if;
            end loop;
            return;
    END split;            
    --
    FUNCTION join
        (
            p_cursor sys_refcursor,
            p_del VARCHAR2 := ','
        ) return VARCHAR2
        is
        -- select join(cursor(select ename from emp)) from dual
            l_value   VARCHAR2(32767);
            l_result  VARCHAR2(32767);
        begin
            loop
                fetch p_cursor into l_value;
                exit when p_cursor%notfound;
                if l_result is not null then
                    l_result := l_result || p_del;
                end if;
                l_result := l_result || l_value;
            end loop;
            return l_result;
    END JOIN;

    FUNCTION RETORNA_PARAM(pParametro VARCHAR2, pParamEntrada CLOB) return VARCHAR2 IS
        cVALOR VARCHAR2(32767);
    BEGIN 
            SELECT value
              INTO cVALOR
              FROM (select trim(SUBSTR(REPLACE(column_value, ':', ''), 1, instr(column_value, '=')-2)) param, rtrim(ltrim(SUBSTR(column_value, instr(column_value, '=')+1))) value 
                      from table(GT_WEB_SERVICES.split(pParamEntrada)))
             WHERE DBMS_LOB.COMPARE(UPPER(param), UPPER(pParametro)) = 0;

            return cVALOR;
    EXCEPTION WHEN OTHERS THEN
            return NULL;                          
    END RETORNA_PARAM;
    --
    FUNCTION REMPLAZA_ISO88591 (pParamEntrada VARCHAR2) return VARCHAR2 IS
        ENTRADA VARCHAR2(32767);
        REGSAL VARCHAR2(100);
    BEGIN 
        ENTRADA := pParamEntrada;
        FOR ENT IN (select  DEC, SYMBOL, NAME, NAME_HEX, DESCRIBE
                    from CHAR_HTML) LOOP
              REGSAL := ENT.NAME || '-' || ENT.SYMBOL || '-' || ENT.NAME_HEX;
              ENTRADA := REPLACE(ENTRADA, ENT.NAME,     ENT.SYMBOL);      
              ENTRADA := REPLACE(ENTRADA, substr(ENT.NAME_HEX, 1, 3) || upper(substr(ENT.NAME_HEX, 4, 1))  ||  substr(ENT.NAME_HEX, 5) , ENT.SYMBOL);      
        END LOOP;             
        RETURN ENTRADA;
    EXCEPTION WHEN OTHERS THEN
        --DBMS_OUTPUT.PUT_LINE(REGSAL);        
        RETURN NULL;                              
    END REMPLAZA_ISO88591;    
    --    
    FUNCTION Ejecuta_WS (pCodCia NUMBER, pCodEmpresa NUMBER, pIdWeb NUMBER, pIdWebResp NUMBER, Resultado OUT VARCHAR2, pParamSql VARCHAR2 := null) return XMLTYPE  IS
            l_response_payload  XMLType;
            LRESULT             XMLTYPE;
            l_namespace         VARCHAR2(200);
            l_metodo            VARCHAR2(2000);
            l_target_url        VARCHAR2(200);
            l_soapAction        VARCHAR2(500);
            l_IDWEBXML          NUMBER;            
            esDatosXml          CHAR(1);
            esDatosXMLResp      CHAR(1);
            cDatosXml           VARCHAR2(32767) := NULL;
            pParamResult        VARCHAR2(32767) := NULL;
            CSTRXML             VARCHAR2(32767);            
            I                   NUMBER;
            COL_COUNT           NUMBER;
            DESC_TABLA          DBMS_SQL.DESC_TAB;            
            sqlParametros       VARCHAR2(32767);
            cRespStrXML         CLOB; 
            cTabParam           VARCHAR2(32767);
            clobWorking         CLOB;
            --
            type Xrow           is ref cursor ;
            curResp  XROW;
            --
            Function soap_call ( p_nameSpace VARCHAR2
                                ,p_Metodo    in VARCHAR2
                                ,p_target_url in VARCHAR2
                                ,p_soap_action in VARCHAR2
                                ,c_soap_envelope CLOB     
                                  ) return xmltype is
                l_soap_request  CLOB;
                l_soap_response VARCHAR2(32767);
                l_soap_response2 VARCHAR2(32767);
                http_req        utl_http.req;
                http_resp       utl_http.resp;     
                l_Alterno       XMLTYPE;
                l_cLOB          CLOB;
                l_cLOB2         CLOB;
                buffer          VARCHAR2(31743);
                offset          NUMBER := 1;
                amount          NUMBER := 31743;
                swISO88591      NUMBER(1) := 0;
                --                  
                Begin

                    l_soap_request := GT_WEB_SERVICES.REPLACE_CLOB(c_soap_envelope, '**metodo**', p_Metodo);                                  

                    http_req:= utl_http.begin_request
                                 ( p_target_url
                                 , 'POST'
                                , 'HTTP/1.1'
                                );
                    utl_http.set_header(http_req, 'Content-Type', 'text/xml');
                    utl_http.set_header(http_req, 'Content-Length', dbms_lob.getlength(l_soap_request));
                    utl_http.set_header(http_req, 'SOAPAction', p_soap_action);

                    while(offset < DBMS_LOB.getlength (l_soap_request)) loop
                         dbms_lob.read(l_soap_request, amount, offset, buffer);
                         --dbms_output.put_line('buffer: ' ||buffer);
                         UTL_HTTP.WRITE_TEXT(http_req, buffer);
                         offset := offset + amount;                         
                    end loop;

                    --dbms_output.put_line(l_soap_request);

                    http_resp:= utl_http.get_response(http_req);

                    dbms_output.put_line('OBTENIENDO RESPUESTA');     

                    DBMS_LOB.CREATETEMPORARY(l_cLOB, FALSE);

                    -- LEE LA RESPUESTA DEL WEBSERVICE EN "CHUNKS"
                    -- YA QUE EL TAMA?O DE LA MISMA LO REQUIERE
                    BEGIN
                        LOOP
                            UTL_HTTP.READ_TEXT(http_resp, l_soap_response2,32767);
                            l_cLOB2:= '';
                            DBMS_LOB.WRITEAPPEND(l_cLOB, LENGTH(l_soap_response2), l_soap_response2);
                            l_cLOB2 := l_cLOB;
                        END LOOP;

                    EXCEPTION
                        WHEN UTL_HTTP.END_OF_BODY THEN
                            UTL_HTTP.END_RESPONSE(http_resp);
                    END;

                    --dbms_output.put_line('termino de hacer "CHUNKS"');     

                    IF swISO88591 = 0 AND INSTR(l_cLOB2, 'ISO-8859-1') > 0 THEN
                        swISO88591 := 1;
                        l_cLOB2 := GT_WEB_SERVICES.REMPLAZA_ISO88591(l_cLOB2);
                        IF INSTR(l_cLOB2, 'bm:') > 0 THEN
                            l_cLOB2 := REPLACE(l_cLOB2, 'bm:', ''); 
                            l_cLOB2 := substr(l_cLOB2 , instr(l_cLOB2, '<DataSet>') );
                            l_cLOB2 := substr(l_cLOB2 , 1, instr(l_cLOB2, '</DataSet>')+10); 

                            BEGIN                                              
                            SELECT XMLROOT (XMLTYPE(l_cLOB2), VERSION '1.0" encoding="UTF-8')
                              INTO l_Alterno FROM DUAL;
                            EXCEPTION WHEN OTHERS THEN                            	
                                dbms_output.put_line('Soap Call: ' || SQLERRM || '**' || l_cLOB2);
                            END;
                            l_cLOB2 := TO_CLOB(l_Alterno.getStringVal()); 
                        END IF;                                                     
                    END IF;
                    DBMS_LOCK.SLEEP(2);                                        
                    /*
                    dbms_output.put_line('l_soap_request---------------------------------------------------------------');
                    dbms_output.put_line(l_soap_request);
                    dbms_output.put_line('---------------------------------------------------------------');
                    dbms_output.put_line('l_soap_response2---------------------------------------------------------------');
                    dbms_output.put_line(l_soap_response2 );
                    dbms_output.put_line('l_cLOB2---------------------------------------------------------------');
                    dbms_output.put_line(l_cLOB2);
                    dbms_output.put_line('---------------------------------------------------------------');
		    */
                     return XMLType(l_cLOB2);
                EXCEPTION WHEN OTHERS THEN
                    IF SQLCODE = -29273 THEN
                        raise_application_error(-20010,SQLCODE || '-' || SQLERRM);
                    END IF;
                    /*
                    --dbms_output.put_line('----------------ERROR-----------------------------------------');
                    dbms_output.put_line(SQLCODE ||'-'|| SQLERRM);
                    dbms_output.put_line(l_soap_request);
                    dbms_output.put_line('l_cLOB---------------------------------------------------------');
                    dbms_output.put_line(l_cLOB);                    
                    */
                    return XMLType.createXML(l_cLOB);               
                end;
            --
    BEGIN    
            BEGIN                                               
                SELECT WS.URL, 
                       XML.ESPACIONOMBRE,
                       WS.METODO,
                       XML.IDWEBXML,
                       UPPER(DatosXml),
                       substr(XML.SQLQUERY, 1, 32767)                       
                  INTO l_target_url,
                       l_namespace, 
                       l_metodo,
                       l_IDWEBXML,
                       esDatosXml,
                       cDatosXml                   
                  FROM WEB_SERVICES WS INNER JOIN WEB_SERVICES_XML XML ON XML.CODCIA     = WS.CODCIA
                                                                      AND XML.CODEMPRESA = WS.CODEMPRESA
                                                                      AND XML.IDWEBXML   = WS.IDEWEBXMLENVIO                                                                                        
                 WHERE WS.CODCIA       = pCodCia
                   AND WS.CODEMPRESA   = pCodEmpresa
                   AND WS.IDWEB        = pIdWeb ;

                l_SoapAction    := l_namespace || l_metodo;     

            EXCEPTION WHEN NO_DATA_FOUND THEN
                esDatosXML := 'N';
                cDatosXml := SQLERRM;
            END;                  
            --              
             --respuesta                                                                
            FOR RESP IN (SELECT XMLN.NIVEL,
                               NVL(XMLN.ORDEN, XMLN.NIVEL) ORDEN,
                               0,
                               TRIM(XMLN.NOMBRE) NOMBRE,
                               IDWEBXMLNODO      
                          FROM WEB_SERVICES_XML_NODOS XMLN
                         WHERE XMLN.CODCIA     = pCodCia
                           AND XMLN.CODEMPRESA = pCodEmpresa
                           AND XMLN.IDWEBXML   = pIdWebResp               
                         ORDER BY NIVEL, NVL(XMLN.ORDEN, XMLN.IDWEBXMLNODO)) LOOP

                IF LENGTH(pParamResult) > 0 THEN
                    pParamResult := pParamResult || ',';
                END IF;

                pParamResult := pParamResult || RESP. NOMBRE;

            END LOOP;

            --
        BEGIN
            SELECT upper(XML.DATOSXML), 
                   XML.SQLQUERY
              INTO esDatosXMLResp,
                   cRespStrXML   
              FROM WEB_SERVICES_XML XML
             WHERE XML.CODCIA   = pCodCia
               AND XML.CODEMPRESA = pCodEmpresa
               AND XML.IDWEBXML   = pIdWebResp;

        EXCEPTION WHEN OTHERS THEN
            cRespStrXML := NULL;
        END;
        IF esDatosXML = 'S' then
            --REMPLAZA PARAMETROS
            FOR PARAM IN (select trim(SUBSTR(column_value, 1, instr(column_value, '=')-1)) param, rtrim(ltrim(SUBSTR(column_value, instr(column_value, '=')+1))) value from table(GT_WEB_SERVICES.split(pParamSql))) loop
                sqlParametros := sqlParametros || '     ' || '''' || param.value || '''' || ' ' || replace(PARAM.param, ':', '') || ',' || CHR(10);
                cDatosXml := REPLACE(cDatosXml, PARAM.param, param.value);
            END LOOP;                                
            cDatosXml   := REPLACE(cDatosXml, '®', '''');

            OPEN curResp FOR cDatosXml; 
            --
            LOOP
                FETCH curResp into CSTRXML;
                EXIT WHEN curResp%NOTFOUND;
                    LRESULT := GENERA_XML(pCodCia, pCodEmpresa, l_IDWEBXML, CSTRXML );                                           
                    l_response_payload :=  soap_call(l_namespace, l_metodo, l_target_url, l_SoapAction, LRESULT.getStringVal());

                    Resultado := GT_WEB_SERVICES.ExtraeDatos_XML(l_response_payload, pParamResult);
                    ---
                    IF LENGTH(cRespStrXML) > 0 THEN
                        BEGIN --paso l_response_payload
                            Resultado := pParamSql || ',' || Resultado;
                            SELECT MAX(IDWEBXMLPAR)
                              INTO cTabParam
                            FROM WEB_SERVICES_XML_PARAM PX
                            WHERE PX.CODCIA     = pCodCia
                              AND PX.CODEMPRESA = pCodEmpresa
                              AND PX.IDWEBXML   = pIdWebResp;

                            IF LENGTH(cTabParam) > 0 THEN
                                begin
                                    EXECUTE IMMEDIATE cRespStrXML USING Resultado, l_response_payload;
                                exception when others then
                                    --DBMS_OUTPUT.PUT_LINE('l_response_payload.getStringVal():' || LENGTH(l_response_payload.getStringVal()));
                                    raise_application_error(-20010,'ERROR EN EL EXECUTE (esDatosXML): ' || SQLERRM);
                                end;
                            ELSE
                                --  DBMS_OUTPUT.PUT_LINE(pIdWebResp || ' --1: ' || cStrXML);
                                EXECUTE IMMEDIATE cRespStrXML USING Resultado, cStrXML;
                            END IF;
                        END;
                    END IF;                                                
            END LOOP;              
        ELSE
            FOR PARAM IN (select trim(SUBSTR(column_value, 1, instr(column_value, '=')-1)) param, rtrim(ltrim(SUBSTR(column_value, instr(column_value, '=')+1))) value from table(GT_WEB_SERVICES.split(pParamSql))) loop
                sqlParametros := sqlParametros || '     ' || '''' || param.value || '''' || ' ' || replace(PARAM.param, ':', '') || ',' || CHR(10);
                cDatosXml := replace(cDatosXml, PARAM.param, param.value);
            END LOOP;        
            cDatosXml   := replace(cDatosXml, '®', '''');
            GT_WEB_SERVICES.XMLSTRING := NULL;

            IF LENGTH(cDatosXml) > 0 THEN
                begin
                    EXECUTE IMMEDIATE cDatosXml;
                EXCEPTION WHEN OTHERS THEN
                 DBMS_OUTPUT.PUT_LINE(cDatosXml);  
                 raise_application_error(-20010,'Ejecuta_WS -- ERROR EN EL EXECUTE: ' || SQLERRM);
                end;
            END IF;

            IF dbms_lob.getlength(XMLTYPE.getclobval(GT_WEB_SERVICES.xmlResult))  > 0 then
                clobWorking := GT_WEB_SERVICES.xmlResult.getClobVal();
            else
                clobWorking := GENERA_XML(pCodCia, pCodEmpresa, l_IDWEBXML).getStringVal();
            end if;
            l_response_payload :=  soap_call(l_namespace, l_metodo, l_target_url, l_SoapAction, clobWorking);

            IF dbms_lob.getlength(cRespStrXML) > 0 AND esDatosXMLResp = 'N' THEN  --RESPUESTA                
                BEGIN --paso l_response_payload

                    FOR PARAM IN (select trim(SUBSTR(column_value, 1, instr(column_value, '=')-1)) param, rtrim(ltrim(SUBSTR(column_value, instr(column_value, '=')+1))) value from table(GT_WEB_SERVICES.split(pParamSql))) loop
                        sqlParametros := sqlParametros || '     ' || '''' || param.value || '''' || ' ' || replace(PARAM.param, ':', '') || ',' || CHR(10);
                        cRespStrXML := GT_WEB_SERVICES.REPLACE_CLOB (cRespStrXML, PARAM.param, param.value);
                    END LOOP;        
                    cRespStrXML   := GT_WEB_SERVICES.REPLACE_CLOB(cRespStrXML, '®', '''');            
                    GT_WEB_SERVICES.InicializaDom(l_response_payload);
                    EXECUTE IMMEDIATE cRespStrXML;
                exception when others then
                    --DBMS_OUTPUT.PUT_LINE('ERROR-XX21->' || cRespStrXML);
                    raise_application_error(-20010, 'No hay Respuesta del WS, posiblemente el periodo o el envÌo no hay datos a procesar' || CHR(10) || SQLERRM);                                        
                END;
            END IF;


        END IF;

        return l_response_payload;

    END Ejecuta_WS;
    --
    FUNCTION GENERA_XML(pCodCia NUMBER, pCodEmpresa NUMBER, pIdeWebXml NUMBER, cDatosXml VARCHAR2 := NULL) RETURN XMLTYPE IS        
            cDoc            XMLTYPE;    
            cLinXml         VARCHAR2(5000) := NULL;
            sTab            VARCHAR2(5000);
            nNodo           BINARY_INTEGER  := 0;
            nNivel          NUMBER  := 1;
            nMaxNivel       NUMBER  := 0;
            --
            TYPE RecLinea IS RECORD (
              NIVEL        WEB_SERVICES_XML_NODOS.NIVEL%TYPE,
              ORDEN        WEB_SERVICES_XML_NODOS.ORDEN%TYPE, 
              NIVELFIN     NUMBER,
              CONTENIDO    WEB_SERVICES_XML_NODOS.NOMBRE%TYPE,
              IDWEBXMLNODO WEB_SERVICES_XML_NODOS.IDWEBXMLNODO%TYPE);
            TYPE TabNodo IS TABLE OF RecLinea
              INDEX BY BINARY_INTEGER;
            --     
            tNodos       TabNodo;

            limit_in  NUMBER := 100;

            CURSOR NIVELES_Q IS
              SELECT XMLN.NIVEL,
                   NVL(XMLN.ORDEN, XMLN.NIVEL) ORDEN,
                   0,
                   TRIM(XMLN.NOMBRE) NOMBRE,
                   IDWEBXMLNODO      
              FROM WEB_SERVICES_XML_NODOS XMLN
             WHERE XMLN.CODCIA     = pCodCia
               AND XMLN.CODEMPRESA = pCodEmpresa
               AND XMLN.IDWEBXML   = pIdeWebXml               
             ORDER BY NIVEL, NVL(XMLN.ORDEN, XMLN.IDWEBXMLNODO);

    BEGIN
            cLinXml := NULL;
            BEGIN
                SELECT MAX(XMLN.NIVEL)
                  INTO nMaxNivel
                FROM WEB_SERVICES_XML_NODOS XMLN
                WHERE XMLN.CODCIA     = pCodCia
                  AND XMLN.CODEMPRESA = pCodEmpresa
                  AND XMLN.IDWEBXML   = pIdeWebXml 
                  AND NOMBRE <> 'DATOSXML';
            EXCEPTION WHEN OTHERS THEN
                nMaxNivel := 0;
            END;                  
            --            
            OPEN NIVELES_Q;
            FETCH NIVELES_Q
               BULK COLLECT INTO tNodos LIMIT limit_in;
            CLOSE NIVELES_Q;
            --                
            FOR NodosListin IN tNodos.FIRST .. tNodos.LAST LOOP
                --
                nNodo := nNodo + 1;
                --
                IF LENGTH(TRIM(cLinXml)) > 0 THEN
                    sTab := rpad(' ', (5*(tNodos(NodosListin).Nivel-1)), ' ') ;
                    cLinXml :=  cLinXml ||  sTab;                                   
                END IF;
                --
                cLinXml := cLinXml || '<' || tNodos(NodosListin).contenido;                    
                -- atributos por nodo
                FOR ATRIB IN (SELECT TRIM(XMLA.NOMBRE) contenido
                              FROM WEB_SERVICES_XML_NODOS_ATRIB XMLA                                                                                              
                            WHERE XMLA.CODCIA       = pCodCia
                              AND XMLA.CODEMPRESA   = pCodEmpresa
                              AND XMLA.IDWEBXML     = pIdeWebXml
                              AND XMLA.IDWEBXMLNODO = tNodos(NodosListin).IDWEBXMLNODO
                            ORDER BY NVL(XMLA.ORDEN, XMLA.IDWEBXMLATR) ) LOOP

                    IF LENGTH(cLinXml) > 0 THEN
                        cLinXml := cLinXml || ' ';
                    END IF;

                    cLinXml := cLinXml || ATRIB.contenido;
                END LOOP;
                --                                                                                                                                                                                                                                                                                      
                cLinXml := cLinXml || '>' || CHR(10) ;                    
                BEGIN      
                    IF tNodos(NodosListin).Nivel = tNodos(NodosListin+1).Nivel then
                        cLinXml :=  SUBSTR(cLinXml, 1, (LENGTH(cLinXml) - 1))  || '</' || tNodos(NodosListin).contenido || '>' || CHR(10) ;
                    else
                        nNivel :=tNodos(NodosListin).Nivel  ;
                        tNodos(NodosListin).NIVELFIN := NodosListin; 
                    END IF;
                EXCEPTION WHEN OTHERS THEN                        
                    cLinXml :=  SUBSTR(cLinXml, 1, (LENGTH(cLinXml) - 1))  || '</' || tNodos(NodosListin).contenido || '>' || CHR(10) ;
                    IF length(cDatosXml) > 0 then                                                                                                   
                        cLinXml := cLinXml || sTab || cDatosXml|| CHR(10) ;
                        cLinXml:= REPLACE(cLinXml, '<DATOSXML></DATOSXML>', NULL);
                    END IF;
                    FOR NodosListinF IN REVERSE 1..NodosListin LOOP
                        IF NodosListinF = tNodos(NodosListinF).NIVELFIN THEN
                            sTab := SUBSTR(sTab, 1, LENGTH(sTab)-5);                          
                            cLinXml := cLinXml || sTab || '</' || tNodos(NodosListinF).contenido || '>' || CHR(10) ;
                        END IF;
                    END LOOP;        
                END;

            END LOOP;                
            cDoc := xmltype(cLinXml);
            RETURN  cDoc;
    EXCEPTION WHEN OTHERS THEN
        RETURN  xmltype(nvl(cLinXml,'<?xml version="1.0" encoding="utf-8"?><ERROR>Revise la configuraciÛn de los atributos, pudier· falta atributos del nombre del espacio</ERROR>'));
    END GENERA_XML;
    --
    FUNCTION ExtraeDatos_XML(Doc XMLTYPE, DatosTag VARCHAR2) Return Varchar2 is            
        NodosList       DBMS_XMLDOM.DOMNodeList;
        Nodo            DBMS_XMLDOM.DOMNode;
        DoConvertido    DBMS_XMLDOM.DOMDocument; 
        ndoc            DBMS_XMLDOM.DOMNode; 
        buf             VARCHAR2(32000);
        len             NUMBER;    
        sValor          VARCHAR2(32767) := null;            
        cLinea          VARCHAR2(32767) := null;        
        Opcion          NUMBER ;

    BEGIN         
        DoConvertido     := DBMS_XMLDOM.newDOMDocument(DOC); 
        SELECT COUNT(*) 
          INTO Opcion
          FROM table(GT_WEB_SERVICES.split(DatosTag));

        FOR PARAM IN (select column_value from table(GT_WEB_SERVICES.split(DatosTag))) loop
            NodosList   := DBMS_XMLDOM.getElementsByTagName(DoConvertido, PARAM.column_value);--- '*' extrae todos los nodos
            len  := DBMS_XMLDOM.getLength(NodosList);     

            FOR i IN 0 .. len - 1 LOOP
                Nodo := DBMS_XMLDOM.item(NodosList, i);
                --sValor := DBMS_XMLDOM.getNodeName(Nodo) || ' ' || DBMS_XMLDOM.getNodeValue(DBMS_XMLDOM.getFirstChild(Nodo));
                IF Opcion = 1 THEN
                    sValor := DBMS_XMLDOM.getNodeValue(DBMS_XMLDOM.getFirstChild(Nodo));
                ELSE
                    IF LENGTH(sValor) > 0 THEN
                        sValor := sValor || ',';
                    END IF;
                    cLinea := ':' || PARAM.column_value || '=' || DBMS_XMLDOM.getNodeValue(DBMS_XMLDOM.getFirstChild(Nodo));            
                    sValor :=  sValor || cLinea;
                END IF;                
            END LOOP;

        END LOOP;                                
        RETURN sValor; 
    END ExtraeDatos_XML;
    --
    PROCEDURE InicializaDom (Doc XMLTYPE) is
    BEGIN
        xmlDom     := DBMS_XMLDOM.newDOMDocument(Doc); 
    EXCEPTION WHEN OTHERS THEN
        raise_application_error(-20010,'InicializaDom: ' || SQLCODE || '-' || SQLERRM);
    END InicializaDom;
    --

    FUNCTION REPLACE_CLOB (I_SOURCE IN CLOB ,I_SEARCH IN VARCHAR2 ,I_REPLACE IN CLOB) RETURN CLOB IS
      L_POS PLS_INTEGER;
    BEGIN
      L_POS := INSTR(I_SOURCE, I_SEARCH);
      IF L_POS > 0 THEN
        RETURN SUBSTR(I_SOURCE, 1, L_POS-1) || I_REPLACE || SUBSTR(I_SOURCE, L_POS+LENGTH(I_SEARCH));
      END IF;
      RETURN I_SOURCE;
    END REPLACE_CLOB;

    FUNCTION ExtraeDatos_XmlDom(Tags clob) Return CLOB is            
        NodosList       DBMS_XMLDOM.DOMNodeList;
        Nodo            DBMS_XMLDOM.DOMNode;         
        len             NUMBER;    
        sValor          CLOB := null;            
        cLinea          CLOB := null;        
        Opcion          NUMBER ;

    BEGIN         
        BEGIN
            SELECT COUNT(*) 
              INTO Opcion
              FROM table(GT_WEB_SERVICES.split(Tags));

            FOR PARAM IN (select column_value from table(GT_WEB_SERVICES.split(Tags))) loop
                NodosList   := DBMS_XMLDOM.getElementsByTagName(xmlDom, PARAM.column_value);--- '*' extrae todos los nodos
                len  := DBMS_XMLDOM.getLength(NodosList);                       
                FOR i IN 0 .. len - 1 LOOP
                    Nodo := DBMS_XMLDOM.item(NodosList, i);                
                    IF Opcion = 1 THEN
                        sValor := DBMS_XMLDOM.getNodeValue(DBMS_XMLDOM.getFirstChild(Nodo));
                        exit;
                    ELSE
                        IF LENGTH(sValor) > 0 THEN
                            sValor := sValor || ',';
                        END IF;
                        cLinea := ':' || PARAM.column_value || '=' || DBMS_XMLDOM.getNodeValue(DBMS_XMLDOM.getFirstChild(Nodo));            
                        sValor :=  sValor || cLinea;
                    END IF;                
                END LOOP;

            END LOOP;

        EXCEPTION WHEN OTHERS THEN
            sValor := 'No se pudo recuperar el NODO de ExtraeDatos_XmlDom ya que es muy larga la cadena: ' || sqlerrm;
        END;                         
        RETURN sValor; 
    END ExtraeDatos_XmlDom;
    --
    FUNCTION Similitud(pCadena1 varchar2, pCadena2 varchar2) RETURN NUMBER AS
        cnt1 NUMBER := 0;
        cnt2 NUMBER := 0;
        Cant number; 
        Porcentaje NUMBER;
        Cadena1 varchar2(1000); 
        Cadena2 varchar2(1000);
    BEGIN
        SELECT TRANSLATE(upper(pCadena1), 'Ò·ÈÌÛ˙‡ËÏÚ˘„ı‚ÍÓÙÙ‰ÎÔˆ¸Á—¡…Õ”⁄¿»Ã“Ÿ√’¬ Œ‘€ƒÀœ÷‹«,.-<>;:_{}[]+*~^¥®ø°\?=)(/&%$#"!|∞¨','naeiouaeiouaoaeiooaeioucNAEIOUAEIOUAOAEIOOAEIOUC') 
          INTO Cadena1
        from DUAL;
        SELECT TRANSLATE(upper(pCadena2), 'Ò·ÈÌÛ˙‡ËÏÚ˘„ı‚ÍÓÙÙ‰ÎÔˆ¸Á—¡…Õ”⁄¿»Ã“Ÿ√’¬ Œ‘€ƒÀœ÷‹«,.-<>;:_{}[]+*~^¥®ø°\?=)(/&%$#"!|∞¨','naeiouaeiouaoaeiooaeioucNAEIOUAEIOUAOAEIOOAEIOUC') 
          INTO Cadena2
        from DUAL;

        Cadena1 := Trim(Replace(Cadena1, ' ', ''));
        Cadena2 := Trim(Replace(Cadena2, ' ', ''));
        cnt1 := Length(Cadena1);
        cnt2 := Length(Cadena2);
        Cant := 0;
        Porcentaje := 0;

        If cnt1 <= cnt2 Then
            For I IN  1..cnt1 loop
                If SUBSTR(Cadena1, I, 1) = SUBSTR(Cadena2, I, 1) Then
                    Cant := Cant + 1;
                End If;
            end loop;
            Porcentaje := Cant / cnt2;
        Else
            For I IN 1..cnt2 LOOP
                If SUBSTR(Cadena1, I, 1) = SUBSTR(Cadena2, I, 1) Then
                    Cant := Cant + 1;
                End If;
            end loop;
            Porcentaje := Cant / cnt1;
        End If;            

        RETURN Round(Porcentaje, 2);
    End Similitud;
    --
    FUNCTION Similitud_Porcentual(pCadena1 varchar2, pCadena2 varchar2) return number as
        TYPE RecLinea IS RECORD (
              Nombre VARCHAR2(1000)
           );    
        TYPE TabNodo IS TABLE OF RecLinea INDEX BY BINARY_INTEGER;    
        Temporal1      TabNodo;
        Temporal2      TabNodo;       
        cnt1 NUMBER := 0;
        cnt2 NUMBER := 0;
        Cant number; 
        I    number;
        Porcentaje number;        
        Cadena1 varchar2(1000); 
        Cadena2 varchar2(1000);
    BEGIN

        SELECT TRANSLATE(upper(pCadena1), 'Ò·ÈÌÛ˙‡ËÏÚ˘„ı‚ÍÓÙÙ‰ÎÔˆ¸Á—¡…Õ”⁄¿»Ã“Ÿ√’¬ Œ‘€ƒÀœ÷‹«,.-<>;:_{}[]+*~^¥®ø°\?=)(/&%$#"!|∞¨','naeiouaeiouaoaeiooaeioucNAEIOUAEIOUAOAEIOOAEIOUC') 
          INTO Cadena1
        from DUAL;
        SELECT TRANSLATE(upper(pCadena2), 'Ò·ÈÌÛ˙‡ËÏÚ˘„ı‚ÍÓÙÙ‰ÎÔˆ¸Á—¡…Õ”⁄¿»Ã“Ÿ√’¬ Œ‘€ƒÀœ÷‹«,.-<>;:_{}[]+*~^¥®ø°\?=)(/&%$#"!|∞¨','naeiouaeiouaoaeiooaeioucNAEIOUAEIOUAOAEIOOAEIOUC') 
          INTO Cadena2
        from DUAL;

        FOR CAD1 IN (select COLUMN_VALUE from table(GT_WEB_SERVICES.split(Cadena1, ' '))) LOOP
            cnt1 := cnt1 + 1;
            Temporal1(cnt1).Nombre := CAD1.COLUMN_VALUE;
        END LOOP;                
        FOR CAD2 IN (select COLUMN_VALUE from table(GT_WEB_SERVICES.split(Cadena2, ' '))) LOOP
            cnt2 := cnt2 + 1;
            Temporal2(cnt2).Nombre := CAD2.COLUMN_VALUE;
        END LOOP;
        --FOR NodosListin IN tNodos.FIRST .. tNodos.LAST LOOP
        --    tNodos(NodosListin).cfd_tipocambio; 
        --END LOOP;    
        Cant := 0;    
        Porcentaje := 0;        

        If cnt1 > 1 Or cnt2 > 1 Then
            If cnt1 <= cnt2 Then            
                For I IN REVERSE 1..cnt1 LOOP
                    If InStr(LOWER(Cadena2), LOWER(Temporal1(I).Nombre)) >= 1 Then
                        Cant := Cant + 1;
                    End If;
                END LOOP;
                Porcentaje := Cant / cnt2;
            Else
                For I IN REVERSE 1..cnt2 LOOP
                    If InStr(LOWER(Cadena1), LOWER(Temporal2(I).Nombre)) >= 1 Then
                        Cant := Cant + 1;
                    End If;
                END LOOP;
                Porcentaje := Cant / cnt1;
            End If;
        Else            
            Porcentaje := Similitud(Cadena1, Cadena2) / 100;            
        End If;

        RETURN Round(Porcentaje, 2);

    EXCEPTION WHEN OTHERS THEN    
        RETURN 0;
    End Similitud_Porcentual;
    --
END GT_WEB_SERVICES;

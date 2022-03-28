
/*ESTABLECE VALORES NUEVOS PARA OBTENER RELACION ENTRE FCTURAS*/
UPDATE FACT_ELECT_CONF_DOCTO SET    INDRECURSIVO='N', 
                                    INDIMPUESTO ='N', 
                                    INDRELACION ='S'
 WHERE (Proceso, CODIDENTIFICADOR, ORDENIDENT) = (SELECT 'EMI', 'CRELS', '3' FROM DUAL);
/  
UPDATE FACT_ELECT_CONF_DOCTO SET    INDRECURSIVO='S', 
                                    INDIMPUESTO ='N', 
                                    INDRELACION ='N'
 WHERE (Proceso, CODIDENTIFICADOR, ORDENIDENT) = ( (SELECT 'EMI', 'CREL', '4' FROM DUAL);
/  

Insert into WEB_SERVICES
   (CODCIA, CODEMPRESA, IDWEB, NOMBRE, DESCRIPCION, 
    URL, METODO, IDEWEBXMLENVIO, IDEWEBXMLRESP, STSWEB, 
    CODUSUARIO, FECULTMODIF)
 Values
   (1, 1, 4000, 'CancelarCFDI22', 'Cancelación CFDI Comprobantes emitidos con errores con relación"', 
    'http://minubeya.com/webservice/wsCancelarCFDI22.php?wsdl ', 'CancelarCFDI', 4000, -4000, 'CONFIG', 
    'SICAS_OC', TO_DATE('02/16/2022 00:00:00', 'MM/DD/YYYY HH24:MI:SS'));
COMMIT;

SET DEFINE OFF;
Insert into WEB_SERVICES_XML
   (CODCIA, CODEMPRESA, IDWEBXML, NOMBRE, DESCRIPCION, 
    ESENVIO, STSWSX, CODUSUARIO, FECULTMODIF, SQLQUERY, 
    DATOSXML)
 Values
   (1, 1, -4000, 'Leer_resultado_wsCancelarCFDI22', 'Resultado de la respuesta de wsCancelarCFDI22', 
    'N', 'CONFIG', 'SICAS_OC', TO_DATE('02/16/2022 10:06:22', 'MM/DD/YYYY HH24:MI:SS'), 'DECLARE
       PROCEDURE ACTUALIZA IS 
        TYPE Xrow   IS REF CURSOR;
        NodosList                       DBMS_XMLDOM.DOMNodeList;
        len                             NUMBER;    
        swError                         NUMBER(1);
        nIdCodCia                       NUMBER;
        LINEA                           VARCHAR2(32700);                
    BEGIN
        LINEA := 1;        
        NodosList       := DBMS_XMLDOM.getElementsByTagName(GT_WEB_SERVICES.xmlDom, ''*'');        
        len             := DBMS_XMLDOM.getLength(NodosList);     
        swError         := 0;            
        LINEA := 3;
        
        DBMS_OUTPUT.PUT_LINE(GT_WEB_SERVICES.ExtraeDatos_XmlDom(''codigo''));
        DBMS_OUTPUT.PUT_LINE(GT_WEB_SERVICES.ExtraeDatos_XmlDom(''descripcion''));
        DBMS_OUTPUT.PUT_LINE(GT_WEB_SERVICES.ExtraeDatos_XmlDom(''fecha''));
        
        -- actualiza
        /*GT_DETALLE_TABLERO_CTRL_PAGO.ACTUALIZA_RESPUESTA
                                                (
                                                 nIdCodCia
                                                ,nIdProc
                                                ,nIdProcDet
                                                ,tNodos(NodosListin).fuente 
                                                ,tNodos(NodosListin).folio_solicitud
                                                ,tNodos(NodosListin).referencia
                                                ,tNodos(NodosListin).error
                                                ,tNodos(NodosListin).comentario 
                                                --,tNodos(NodosListin).tipo_pago
                                                );
        */                                                        
        LINEA := 15;                                                    
    EXCEPTION WHEN OTHERS THEN    
               RAISE_APPLICATION_ERROR(-20010,LINEA || ''-'' || ''Error en procedimiento del CLOB (WEB_SERVICES_XML) del retorno del proc ACTUALIZA WS: '' || SQLERRM);
    END ACTUALIZA;          

BEGIN    
    --GT_WEB_SERVICES.InicializaDom(GT_WEB_SERVICES.xmlResult);        
    ACTUALIZA;
END;
', 
    'N');
/    
Insert into WEB_SERVICES_XML
   (CODCIA, CODEMPRESA, IDWEBXML, NOMBRE, DESCRIPCION, 
    ESENVIO, STSWSX, CODUSUARIO, FECULTMODIF, SQLQUERY, 
    DATOSXML)
 Values
   (1, 1, 4000, 'Procesar_wsCancelarCFDI22', 'Envia notificación de cancelación (PROCEDIMIENTO)', 
    'S', 'CONFIG', 'SICAS_OC', TO_DATE('02/16/2022 10:04:53', 'MM/DD/YYYY HH24:MI:SS'), 'DECLARE
    SETHEADERXML    CLOB;                 
        
BEGIN     
    
    FOR LIN_ESQUEMA IN (
                    SELECT XMLELEMENT("soapenv:Envelope", XMLATTRIBUTES(''http://www.w3.org/2001/XMLSchema-instance''      AS "xmlns:xsi",
                                                                        ''http://www.w3.org/2001/XMLSchema'' AS "xmlns:xsd",
                                                                        ''http://schemas.xmlsoap.org/soap/envelope/'' AS "xmlns:soapenv"),
                                XMLELEMENT("soapenv:Header", ''''),
                                XMLELEMENT("soapenv:Body", 
                                    XMLELEMENT("CancelarCFDI",     XMLATTRIBUTES(''http://schemas.xmlsoap.org/soap/encoding/''      AS "soapenv:encodingStyle"),
                                        XMLELEMENT("usuario", XMLATTRIBUTES(''xsd:string''      AS "xsi:type"),  OC_GENERALES.BUSCA_PARAMETRO(:nCodCia,''024'')),
                                        XMLELEMENT("contra",  XMLATTRIBUTES(''xsd:string''      AS "xsi:type"),  OC_GENERALES.BUSCA_PARAMETRO(:nCodCia,''025'')),
                                        XMLELEMENT("uuid",  XMLATTRIBUTES(''xsd:string''      AS "xsi:type"),  :Wuuid ),
                                        XMLELEMENT("motivo",  XMLATTRIBUTES(''xsd:string''      AS "xsi:type"), :Wmotivo ),                                                  
                                        XMLELEMENT("uuid_relacionado", XMLATTRIBUTES(''xsd:string''      AS "xsi:type"), :WuuNuevo)
                                        )))
                    DATOSXML from dual) LOOP            
        --SETHEADERXML := REPLACE(SETHEADERXML, ''<xs_schema></xs_schema>'', LIN_ESQUEMA.DATOSXML.getStringVal());
        SETHEADERXML := LIN_ESQUEMA.DATOSXML.getStringVal();
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(SETHEADERXML);      
    GT_WEB_SERVICES.xmlResult  := XMLType.createXML(SETHEADERXML);            
EXCEPTION WHEN OTHERS THEN
    raise_application_error(-20010,''4000 WEB_SERVICES error generacion XML, No.fact: '' || SQLERRM);    
END;
    ', 
    'N');
/
COMMIT;

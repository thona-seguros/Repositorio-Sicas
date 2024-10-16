CREATE OR REPLACE PACKAGE THONAPI.GENERALES_PLATAFORMA_DIGITAL AS
/******************************************************************************
   NOMBRE:       GENERALES_PLATAFORMA_DIGITAL
   1.0        12/07/2019      CPEREZ<       1. Created this package.
******************************************************************************/
    
    FUNCTION ES_NUMERICO(pEntrada VARCHAR2) RETURN NUMBER;
    FUNCTION DIGITAL_PLANTILLA   (nNivel IN OUT int, pPK1 IN OUT VARCHAR2) return CLOB;
    FUNCTION DIGITAL_GENERAWHERE (pCOLUMN_NAME  VARCHAR2, pPK varchar2, pSqlWhere Varchar2) return VARCHAR2;
    --  
    FUNCTION DIGITAL_CATALOGO_PRODUCT return clob;
    FUNCTION VIGENCIA_HASTA (VIGENCIAINI DATE := SYSDATE) return DATE;
    FUNCTION VIGENCIA_COTIZACION (VIGENCIAINI DATE := SYSDATE) return DATE;
    FUNCTION CALCULA_EDAD (FECHANACIMIENTO DATE, FECHA_CALCULO DATE := TRUNC(SYSDATE)) return NUMBER;
    FUNCTION COPIA_COTIZACION (nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) return NUMBER;    
    FUNCTION MARCA_COTIZACION (nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) return BOOLEAN;
    FUNCTION RECOTIZACION (nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) return BOOLEAN;
    FUNCTION OBTEN_PLANTILLA (nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) return CLOB;
    FUNCTION CONSULTA_COTIZACION (nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) return CLOB;
    FUNCTION CATALOGO_GIRO (pESPARAVIDA CHAR, pESACEPTADO CHAR) return CLOB;
    FUNCTION COBERTURA_ATRIBUTOS(P_IdCotizacion NUMBER, P_IDetCotizacion NUMBER) RETURN CLOB;
    --FUNCTION COBERTURA_ATRIBUTOS (P_IDTIPOSEG VARCHAR2, P_PLANCOB VARCHAR2, P_CODCOBERT VARCHAR2) RETURN CLOB ;
    PROCEDURE RECALCULAR_COTIZACION(p_nCodCia NUMBER, p_nCodEmpresa NUMBER, p_nIdCotizacion NUMBER,
                                  p_cIdTipoSeg VARCHAR2, p_cPlanCob VARCHAR2, p_cIndAsegModelo VARCHAR2,
                                  p_cIndCensoSubgrupo VARCHAR2, p_cIndListadoAseg VARCHAR2);
    FUNCTION DESCARTA_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) return INT;                                  
    FUNCTION DIGITAL_CATALOGO_PROCESO(P_TIPOPROCESO VARCHAR2 := 'EMIS%') RETURN CLOB;
    FUNCTION PLANTILLA_DATOS_PROCESO(W_CODCIA IN NUMBER, W_CODEMPRESA NUMBER, P_IDTIPOSEG   VARCHAR2, P_PLANCOB VARCHAR2, P_TIPOPROCESO VARCHAR2 := 'EMISIO') RETURN CLOB;
    FUNCTION PLANTILLA_DATOS_PROCESO_NEW(W_CODCIA IN NUMBER, W_CODEMPRESA NUMBER, P_IDTIPOSEG   VARCHAR2, P_PLANCOB VARCHAR2, P_TIPOPROCESO VARCHAR2 := 'EMISIO') RETURN CLOB;
    FUNCTION COTIZACION_ACTUALIZA(QRY_DML VARCHAR2) RETURN NUMBER;
    PROCEDURE COTIZACION_EMITIR(p_nCodCia NUMBER, p_nCodEmpresa NUMBER, p_nIdCotizacion NUMBER);
    FUNCTION PRE_EMITE_POLIZA_NEW(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, cCadena VARCHAR2, cIdPoliza NUMBER := NULL) return CLOB;
    FUNCTION CONSULTA_FACTURA(nCodCia NUMBER, nIdPoliza NUMBER) RETURN CLOB;
    FUNCTION PAGO_FACTURA (nIdPoliza NUMBER, nIdFactura NUMBER) RETURN BOOLEAN;
    FUNCTION CONSULTA_COT_PAGO_FRACCIONARIO(nCodCia NUMBER, nIdCotizacion NUMBER) RETURN CLOB;
    FUNCTION CONSULTA_CODIGO_POSTAL(pCatalogo NUMBER := 0, pCODPOSTAL VARCHAR2, pCODPAIS VARCHAR2, pCODESTADO VARCHAR2, pCODMUNICIPIO VARCHAR2, pCODIGO_COLONIA VARCHAR2) RETURN CLOB;
    FUNCTION CATALOGO_GENERAL(pCodLista VARCHAR2 := 'FORMPAGO', pCodValor VARCHAR2) RETURN CLOB;
    FUNCTION CATALOGO_ENTIDAD_FINANCIERA(pCodEntidad VARCHAR2) RETURN CLOB;
    PROCEDURE POLIZA_ANULA(pIDPoliza NUMBER, pMotivAnul VARCHAR2, pCod_Moneda VARCHAR2 := 'PS');
    FUNCTION MUESTRA_COTIZACIONES(pIDCOTIZACION NUMBER, pNombre VARCHAR2, pCodAgente NUMBER, pEstatus VARCHAR2, nNumRegIni NUMBER := 1, nNumRegFin NUMBER := 50) RETURN CLOB;
    FUNCTION PLD_POLIZA_LIBERADA(nIdPoliza NUMBER) RETURN CHAR;
    FUNCTION PLD_POLIZA_BLOQUEDA(nIdPoliza NUMBER) RETURN CHAR;
    FUNCTION COTIZACION_CONCEPTOS_PRIMA(pIDCOTIZACION NUMBER) RETURN CLOB;
    FUNCTION MUESTRA_POLIZAS(pCodCia NUMBER, pIDPOLIZA NUMBER, pRFC varchar2, pNombre VARCHAR2, pCodAgente varchar2, nNumRegIni NUMBER, nNumRegFin NUMBER) RETURN CLOB;
    FUNCTION CONSULTA_AGENTE(pCODCIA NUMBER, pCODEMPRESA NUMBER, pCODAGENTE NUMBER) RETURN CLOB;
    FUNCTION CONDICIONES_GENERALES(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, dFecEmision DATE) RETURN BLOB;
    FUNCTION DESCARTA_POLIZA (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN INT;
    FUNCTION LIMPIA_COTIZACIONES (pFecha DATE := TRUNC(SYSDATE)) RETURN NUMBER;
    FUNCTION PAQUETE_COMERCIAL_DOCUMENTO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, cDescPaquete VARCHAR2) RETURN BLOB;
    FUNCTION QUE_HACER_SINIESTROS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN BLOB;
    
    --
END GENERALES_PLATAFORMA_DIGITAL;
/

--
-- GENERALES_PLATAFORMA_DIGITAL  (Synonym) 
--
CREATE OR REPLACE PUBLIC SYNONYM GENERALES_PLATAFORMA_DIGITAL FOR THONAPI.GENERALES_PLATAFORMA_DIGITAL
/


GRANT EXECUTE ON THONAPI.GENERALES_PLATAFORMA_DIGITAL TO PUBLIC
/
--
-- GENERALES_PLATAFORMA_DIGITAL  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY THONAPI.GENERALES_PLATAFORMA_DIGITAL AS
/******************************************************************************
   NOMBRE:       GENERALES_PLATAFORMA_DIGITAL
   1.0        12/07/2019      CPEREZ<       1. Created this package.
******************************************************************************/
    FUNCTION ES_NUMERICO(pEntrada VARCHAR2) RETURN NUMBER IS
        NUMERO NUMBER ;
        wEntrada VARCHAR2(100);
    BEGIN
        wEntrada := NVL(pEntrada, 'X');
        NUMERO := TO_NUMBER(wEntrada);    
        RETURN 1;
        
    EXCEPTION WHEN OTHERS THEN
        RETURN 0;
    END ES_NUMERICO;
    --
    FUNCTION DIGITAL_PLANTILLA(nNivel IN OUT int, pPK1 IN OUT VARCHAR2) return clob is
        CURSOR DATA(PNIVEL NUMBER) IS 
            SELECT TABLA, NIVEL FROM (
                      SELECT 'COTIZACIONES'                 TABLA, 1 NIVEL FROM DUAL UNION  
                      SELECT 'COTIZACIONES_DETALLE'         TABLA, 2 NIVEL FROM DUAL UNION
                      SELECT 'COTIZACIONES_COBERT_ASEG'     TABLA, 3 NIVEL FROM DUAL UNION
                      SELECT 'COTIZACIONES_ASEG'            TABLA, 3 NIVEL FROM DUAL                       
                      --SELECT 'COTIZACIONES_COBERTURAS'      TABLA, 4 NIVEL FROM DUAL UNION
                      --SELECT 'COBERTURAS_DE_SEGUROS'        TABLA, 5 NIVEL FROM DUAL UNION
                      --SELECT 'COTIZADOR_EDADES_CRITERIO'    TABLA, 5 NIVEL FROM DUAL UNION
                      --SELECT 'COTIZADOR_CRITERIO_PRUEBAS'   TABLA, 5 NIVEL FROM DUAL
                                    )
            WHERE NIVEL = PNIVEL
            ORDER BY NIVEL;                  
        cDATA      DATA%ROWTYPE;

        CURSOR DICCION(PTABLA VARCHAR2) IS 
            SELECT 
                   T.TABLE_NAME,       
                   T.COLUMN_ID, 
                   T.COLUMN_NAME,
                   T.DATA_TYPE,
                   T.DATA_LENGTH,
                   T.DATA_PRECISION,
                   T.DATA_SCALE,
                   CASE WHEN I.UNIQUENESS = 'UNIQUE' THEN IC.COLUMN_POSITION ELSE NULL END INDEX_PK_POSITION,               
                   T.DATA_DEFAULT DATA_DEFAULT,
                   C.COMMENTS 
              FROM  SYS.ALL_TAB_COLUMNS  T LEFT JOIN SYS.ALL_COL_COMMENTS C   ON C.OWNER = T.OWNER AND C.TABLE_NAME = T.TABLE_NAME AND C.COLUMN_NAME = T.COLUMN_NAME
                                           LEFT JOIN SYS.ALL_INDEXES      I   ON I.OWNER = T.OWNER AND I.TABLE_NAME = T.TABLE_NAME AND I.UNIQUENESS = 'UNIQUE'
                                           LEFT JOIN SYS.ALL_IND_COLUMNS  IC  ON IC.TABLE_OWNER = I.OWNER AND IC.TABLE_NAME = I.TABLE_NAME AND IC.INDEX_NAME = I.INDEX_NAME AND IC.COLUMN_NAME = C.COLUMN_NAME                                
            WHERE T.OWNER      = 'SICAS_OC'
              AND T.TABLE_NAME = PTABLA
             ORDER BY T.TABLE_NAME, T.COLUMN_ID;
        cDICCION      DICCION%ROWTYPE;         


        locSalida clob;
        locSalidaNva clob;
        cSqlSelectXml  VARCHAR2(32767) := NULL; 
        cSqlSelect     VARCHAR2(32767) := NULL; 
        cSqlColumn  VARCHAR2(32767) := NULL; 
        cSqlFrom    VARCHAR2(32767) := NULL; 
        cSqlWhere   VARCHAR2(32767) := NULL; 
        cSqlText    VARCHAR2(32767) := NULL; 
        nKey        NUMBER := 0;
        nCampo      NUMBER := 0;
        
        pPK2        VARCHAR2(32767) := NULL;
        
        cur          sys_refcursor;
        cur1         sys_refcursor;
        cur2         sys_refcursor;
        cur3         sys_refcursor;
        cur4         sys_refcursor;
        cur5         sys_refcursor;
        cur6         sys_refcursor;
        cSalida      clob;
        
        --
        curs          NUMBER;
        cols          int;
        d             dbms_sql.desc_tab;
        val           long ; --varchar2(32767);
        cName         varchar2(30);
        cPK2          VARCHAR2(32767);
        xi  NUMBER := 0;
        
        Linea   VARCHAR2(100);
        
    Begin        
        OPEN DATA(nNivel);
        LOOP
            FETCH DATA INTO cDATA;
            EXIT WHEN DATA%NOTFOUND;
            --ObtieneExtructura de la tabla    
            cSqlSelect := NULL;
            cSqlSelectXml   := null;
            cSqlColumn := NULL;
            cSqlWhere  := NULL;
            cSqlFrom   := NULL;
            nKey       := 0;
            nCampo     := 0;
            --
            --
            OPEN DICCION(TRIM(cDATA.TABLA));
            LOOP
                    FETCH DICCION INTO cDICCION;
                    EXIT WHEN DICCION%NOTFOUND;  
                    --                
                    nCampo := nCampo + 1;
                    --                
                    IF cSqlSelectXml IS NULL THEN 
                        cSqlSelectXml := cSqlSelectXml || 'XMLELEMENT("' || TRIM(cDATA.TABLA)  || '", ' ;  --- CAPELE || CHR(10) || CHR(9) ;  
                        --cSqlSelectXml := cSqlSelectXml || 'XMLELEMENT("' || TRIM(cDATA.TABLA)  || '",  XMLATTRIBUTES(0 AS "IDREF"), ' || CHR(10) || CHR(9) ; 
                    ELSE
                        cSqlSelectXml := cSqlSelectXml || '),' ; --- CAPELE || CHR(10) || CHR(9) ; 
                        cSqlSelect := cSqlSelect || ',' ; --- CAPELE || CHR(10) || CHR(9) ;
                    END IF;
                    --
                    IF cDICCION.DATA_TYPE  = 'VARCHAR2' THEN                    
                        cSqlSelectXml := cSqlSelectXml  || 'XMLELEMENT("' || cDICCION.COLUMN_NAME ||'", XMLATTRIBUTES('|| '''' || 'C' || '''' ||' AS "Ty"), SUBSTR(' ||  cDICCION.COLUMN_NAME || ', 1, 100)';
                        --cSqlSelectXml := cSqlSelectXml  || 'XMLELEMENT("' || cDICCION.COLUMN_NAME ||'", XMLATTRIBUTES('|| '''' || 'C' || '''' ||' AS "Ty"), ' ||  cDICCION.COLUMN_NAME ;
                    ELSIF cDICCION.DATA_TYPE  = 'DATE' THEN
                        cSqlSelectXml := cSqlSelectXml  || 'XMLELEMENT("' || cDICCION.COLUMN_NAME ||'", XMLATTRIBUTES('|| '''' || 'D' || '''' ||' AS "Ty"), ' ||  cDICCION.COLUMN_NAME;
                    ELSE
                        cSqlSelectXml := cSqlSelectXml  || 'XMLELEMENT("' || cDICCION.COLUMN_NAME ||'", XMLATTRIBUTES('|| '''' || 'N' || '''' ||' AS "Ty"), ' ||  cDICCION.COLUMN_NAME;
                    END IF;
                    --
                    cSqlSelect := cSqlSelect ||  cDICCION.COLUMN_NAME;                                      
                    --                                       
                    IF LENGTH(cSqlColumn) > 0 THEN cSqlColumn := cSqlColumn || ',' ; END IF;
                    --
                    cSqlColumn := cSqlColumn  || cDICCION.COLUMN_NAME ;
                    --                    
                    IF cDICCION.INDEX_PK_POSITION IS NOT NULL THEN
                        --                                    
                        cSqlWhere :=  GENERALES_PLATAFORMA_DIGITAL.DIGITAL_GENERAWHERE(cDICCION.COLUMN_NAME, pPK1, cSqlWhere);
                        --
                        IF LENGTH(pPK2) > 0 THEN pPK2 := pPK2 || ','; END IF;
                        pPK2 := pPK2 ||  cDICCION.COLUMN_NAME;
                        --                                         
                    END IF;
                    --;      
            END LOOP;                
            CLOSE DICCION;
            --
            cSqlSelectXml := cSqlSelectXml || '),' ; --- CAPELE || CHR(10) || CHR(9) ; 
            cSqlSelectXml := cSqlSelectXml  || 'XMLELEMENT("NIVEL", ' || '''' || 'NIVEL'  || TRIM(TO_CHAR(nNivel, '000')) || '''' ;
            cSqlFrom := ')) AS DATOSXML, ' || cSqlSelect ; --- CAPELE  || CHR(10) || CHR(9) ;
            cSqlFrom := cSqlFrom || ' FROM ' || TRIM(cDATA.TABLA) ;
            --
            SELECT replace(cSqlWhere, ' AND ', ',') 
              INTO cSqlWhere 
              FROM DUAL;
            --
            IF pPK2 IS NOT NULL THEN
                cSqlText := NULL;
                FOR cKeyTab IN (select upper(COLUMN_VALUE) COLUMN_VALUE from table(GT_WEB_SERVICES.SPLIT(pPK2, ','))) LOOP
                        FOR cKey IN (select upper(COLUMN_VALUE) COLUMN_VALUE from table(GT_WEB_SERVICES.SPLIT(cSqlWhere, ','))) LOOP
                            IF cKeyTab.COLUMN_VALUE  = trim(SUBSTR(cKey.COLUMN_VALUE, 1, instr(cKey.COLUMN_VALUE, '=') - 1)) THEN
                                IF LENGTH(cSqlText) > 0 THEN cSqlText := cSqlText || ' AND '; END IF;
                                cSqlText := cSqlText ||  cKeyTab.COLUMN_VALUE|| '=' || SUBSTR(cKey.COLUMN_VALUE, instr(cKey.COLUMN_VALUE, '=') + 1);
                                exit;                                                             
                             END IF;                              
                        END LOOP;              
                END LOOP;
                cSqlWhere := cSqlText;  
            END IF;                     
            --            
            cSqlText := 'SELECT ' || cSqlSelectXml || chr(10) ||  cSqlFrom || chr(10) || '  WHERE ' || cSqlWhere || CHR(10);
            --
            BEGIN
                BEGIN
                    IF nNivel = 1 THEN        
                        OPEN cur1 FOR cSqlText;
                        CUR := cur1;
                    ELSIF nNivel = 2 THEN        
                        OPEN cur2 FOR cSqlText;
                        CUR := cur2;
                    ELSIF nNivel = 3 THEN        
                        OPEN cur3 FOR cSqlText;
                        CUR := cur3;
                    ELSIF nNivel = 4 THEN        
                        OPEN cur4 FOR cSqlText;
                        CUR := cur4;
                    ELSIF nNivel = 5 THEN        
                        OPEN cur5 FOR cSqlText;
                        CUR := cur5;
                    ELSIF nNivel = 6 THEN        
                        OPEN cur6 FOR cSqlText;
                        CUR := cur6;
                    ELSE
                        EXIT;
                    END IF;            
                EXCEPTION WHEN OTHERS THEN
                    RAISE_APPLICATION_ERROR(-20200,SQLERRM); 
                END;
                --
                IF CUR%ROWCOUNT > 1 THEN
                       EXIT;     
                END IF;
                
                BEGIN
                    curs := dbms_sql.to_cursor_number(cur);
                    dbms_sql.describe_columns(curs, COLS, d);
                    FOR i IN 1 .. COLS LOOP
                        dbms_sql.define_column(curs, i, val, 32767);
                    END LOOP;
                    --col_name: D(I).col_name
                    --col_type: D(I).col_type
                    --col_precision: D(I).col_precision
                    --col_max_len: D(I).col_max_len
                    --col_name_len: D(I).col_name_len
                    --col_schema_name: D(I).col_schema_name
                    --col_schema_name_len: D(I).col_schema_name_len
                    --col_scale: D(I).col_scale
                    --col_charsetid: D(I).col_charsetid
                    --col_charsetform: D(I).col_charsetform
                    WHILE dbms_sql.fetch_rows(curs) > 0 LOOP
                    --
                        FOR I IN 1..COLS loop
                            BEGIN
                              --
                              dbms_sql.column_value(curs, i, val);          
                              --
                              IF UPPER(d(i).col_name) = 'DATOSXML' THEN
                                  IF DBMS_LOB.GETLENGTH(cSalida) > 0 THEN cSalida := cSalida || '|'; END IF;
                                  cSalida := cSalida || val;
                              END IF;
                                                      
                            EXCEPTION WHEN others THEN
                                   --dbms_output.put_line(DBMS_LOB.GETLENGTH(val) );
                                   --dbms_output.put_line(DBMS_LOB.GETLENGTH(cSalida) );
                                   --dbms_output.put_line(cSalida);
                                   RAISE_APPLICATION_ERROR(-20200,SQLERRM);
                            END;
                          --

                            FOR cKey IN (select upper(COLUMN_VALUE) COLUMN_VALUE from table(GT_WEB_SERVICES.SPLIT(pPK2, ','))) LOOP     
                                                  
                                IF UPPER(d(i).col_name) = cKey.COLUMN_VALUE THEN
                                   IF LENGTH(cPK2) > 0 THEN cPK2 := cPK2 || ',' ; END IF;
                                   IF d(i).col_type = 1 then
                                        cPK2 := cPK2 || d(i).col_name|| '=' || '''' || val || '''';
                                   ELSE
                                        cPK2 := cPK2 || d(i).col_name|| '=' || val;
                                   END IF;
                                   exit;
                                END IF;
                            END LOOP;
                          --            
                          cSqlWhere :=  GENERALES_PLATAFORMA_DIGITAL.DIGITAL_GENERAWHERE(d(i).col_name, cPK2, cSqlWhere);                                      
                          --
                        END LOOP;
                        pPK2 := cSqlWhere;
                        nNivel := nNivel + 1;
                        BEGIN
                            --
                            IF pPK2 IS NOT NULL THEN
                               pPK1 := pPK2;
                            END IF;
                           --            
                            pPK2 := NULL;
                            locSalida:= cSalida;
                            locSalidaNva :=  DIGITAL_PLANTILLA(nNivel,cSqlWhere); 
                            locSalida := locSalida || locSalidaNva;              
                            --locSalida := replace(locSalida, '<NIVEL>' || TRIM(TO_CHAR((nNivel-1), '000')) || '</NIVEL>', locSalidaNva) ;                        
                            --DBMS_OUTPUT.PUT_LINE('LOCSALIDA 1: ' ||  locSalida);
                        EXCEPTION WHEN OTHERS THEN
                            DBMS_OUTPUT.PUT_LINE('SALIDA LOCSALIDA 1: ' ||  locSalida);
                            EXIT;
                        END;
                        --
                        cSqlWhere  := NULL;
                        cSalida := null;
                    END LOOP;      
                    dbms_sql.close_cursor(curs);            
                END;            
                ----------------------------------------------------------------------------------            
                --nWork_Nivel := nNivel;
                --pPK2 := NULL;
                --CLOSE cur;                
            END;                
        END LOOP;
        --    
        CLOSE DATA;
        --    
        RETURN locSalida;
    EXCEPTION WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE(cSqlText || '-' || SQLERRM);
         DBMS_OUTPUT.PUT_LINE('curs: ' || curs); 
        NULL;        
    END DIGITAL_PLANTILLA;
    --
    FUNCTION DIGITAL_GENERAWHERE(pCOLUMN_NAME VARCHAR2, pPK varchar2, pSqlWhere Varchar2) return varchar2 is
        SqlWhere varchar2(32767);
        linea varchar2(100);
    BEGIN
        SqlWhere := pSqlWhere;
        linea := '1.0';
        FOR cKey IN (select upper(COLUMN_VALUE) COLUMN_VALUE from table(GT_WEB_SERVICES.SPLIT(pPK, ','))) LOOP                                    
        linea := '2.0';
            IF UPPER(pCOLUMN_NAME) = trim(SUBSTR(cKey.COLUMN_VALUE, 1, instr(cKey.COLUMN_VALUE, '=') - 1)) THEN                
                linea := '3.0';
                IF LENGTH(SqlWhere) > 0 THEN SqlWhere := SqlWhere || ' AND '; END IF;
                linea := '4.0';
                SqlWhere := SqlWhere ||  pCOLUMN_NAME|| '=' || SUBSTR(cKey.COLUMN_VALUE, instr(cKey.COLUMN_VALUE, '=') + 1);
                linea := '5.0';
                exit;
            END IF;
            --
        END LOOP;  
        linea := '6.0';
        return SqlWhere;
        --        
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20200,SQLERRM);
    END;
    --
    FUNCTION DIGITAL_CATALOGO_PRODUCT return clob is
    
        CURSOR Q_CATA IS
            SELECT  XMLELEMENT("PRODUCTOS", 
                    XMLELEMENT("CODCOTIZADOR",      G.CODCOTIZADOR), 
                    XMLELEMENT("DESCCOTIZADOR",     G.DESCCOTIZADOR), 
                    XMLELEMENT("IDCOTIZACION",      C.IDCOTIZACION), 
                    XMLELEMENT("NOMBRECONTRATANTE", C.NOMBRECONTRATANTE)) AS DATAXML 
            FROM COTIZADOR_CONFIG G INNER JOIN COTIZACIONES C ON C.CODCIA       = G.CODCIA 
                                                             AND C.CODEMPRESA   = G.CODEMPRESA 
                                                             AND C.CODCOTIZADOR = G.CODCOTIZADOR  
            WHERE G.CODCIA                     =  1
              AND G.CODEMPRESA                 =  1
              AND TRUNC(SYSDATE) BETWEEN G.FECINICOTIZADOR AND G.FECFINCOTIZADOR 
              AND GT_COTIZACIONES.COTIZACION_BASE_WEB(C.CODCIA, C.CODEMPRESA, C.IDCOTIZACION )   = 'S'  
            ORDER BY G.CODCOTIZADOR, C.IDCOTIZACION;
        R_CATA Q_CATA%ROWTYPE;
        --
        CATA CLOB;
        --
    BEGIN
        
             CATA := '<?xml version="1.0" encoding="UTF-8" ?><CATALOGO>';
            /*
            GT_COTIZADOR_CONFIG.COTIZADOR_WEB
            GT_COTIZACIONES.COTIZACION_WEB
            GT_COTIZACIONES.COTIZACION_BASE_WEB
            INDCOTIZADORWEB
            COTIZADOR_CONFIG
            GT_COTIZACIONES.MARCA_COTIZACION_WEB
            */
            OPEN Q_CATA;
            LOOP
                FETCH Q_CATA INTO R_CATA;
                EXIT WHEN Q_CATA%NOTFOUND;
                --
                CATA := CATA || R_CATA.DATAXML.getclobval();
                --
            END LOOP;
            --    
            CLOSE Q_CATA;
            CATA :=  CATA || '</CATALOGO>';
            RETURN  CATA;           

    END;
    --
    FUNCTION VIGENCIA_HASTA(VIGENCIAINI DATE := SYSDATE) return DATE IS
        VIGENCIAFIN DATE;
    BEGIN
     VIGENCIAFIN := TRUNC(ADD_MONTHS(VIGENCIAINI,12));
     RETURN VIGENCIAFIN;
    END;
    --
    FUNCTION VIGENCIA_COTIZACION(VIGENCIAINI DATE := SYSDATE) return DATE IS
        VIGENCIAFIN DATE;
    BEGIN
        VIGENCIAFIN := TRUNC(VIGENCIAINI) + 30;
        RETURN VIGENCIAFIN;
    END;
    --
    FUNCTION CALCULA_EDAD(FECHANACIMIENTO DATE, FECHA_CALCULO DATE := TRUNC(SYSDATE)) return number IS
        nEDAD NUMBER;
    BEGIN    
        nEdad := FLOOR((TRUNC(FECHA_CALCULO) - TRUNC(FECHANACIMIENTO)) / 365.25) ;    
        RETURN nEDAD;        
    END;
    --    
    FUNCTION MARCA_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) return BOOLEAN IS
     
    BEGIN
        GT_COTIZACIONES.MARCA_COTIZACION_WEB( nCodCia, nCodEmpresa, nIdCotizacion);
        RETURN TRUE;
    EXCEPTION WHEN OTHERS THEN
        RETURN FALSE;
    END;
    --
    FUNCTION COPIA_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) return NUMBER IS
        nNuevaIdCotizacion      NUMBER;
        nIdRecotizacionMax      NUMBER;
        nConsecutivoCot         NUMBER;
        cNumUnicoCotizacion     COTIZACIONES.NumUnicoCotizacion%TYPE;
        cNumUnicoCotizacionMax  COTIZACIONES.NumUnicoCotizacion%TYPE;
    BEGIN
         nNuevaIdCotizacion := GT_COTIZACIONES.COPIAR_COTIZACION_WEB(nCodCia , nCodEmpresa , nIdCotizacion );
         cNumUnicoCotizacion := GT_COTIZACIONES.NUMERO_UNICO_COTIZACION(nCodCia , nCodEmpresa , nIdCotizacion );

          cNumUnicoCotizacion := SUBSTR(nNuevaIdCotizacion, 1, 22) || '*' ||  SUBSTR(cNumUnicoCotizacion, 1, 8);
          
          UPDATE COTIZACIONES N SET N.NumUnicoCotizacion = cNumUnicoCotizacion,
                                    N.NUMCOTIZACIONANT   = nIdCotizacion
          WHERE N.CodCia               = nCodCia
            AND N.CODEMPRESA           = nCodEmpresa
            AND N.IdCotizacion         = nNuevaIdCotizacion;                          
          
         RETURN nNuevaIdCotizacion;
    END;
    --
    FUNCTION OBTEN_PLANTILLA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) return CLOB IS
        pPK1            VARCHAR2(32767);
        SetSalidaXml    CLOB;
        nNivel          NUMBER := 1;
    BEGIN
            pPK1    := 'CODCIA=' || nCodCia || ',CODEMPRESA=' || nCodEmpresa || ' ,IDCOTIZACION=' || nIdCotizacion;
            SetSalidaXml := GENERALES_PLATAFORMA_DIGITAL.DIGITAL_PLANTILLA(nNivel, pPK1);         
            SetSalidaXml := '<?xml version="1.0" encoding="UTF-8" ?>' || SetSalidaXml ;
        RETURN   SetSalidaXml;          
    END;
    --
    FUNCTION CONSULTA_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) return CLOB IS
        pPK1            VARCHAR2(32767);
        SetSalidaXml    CLOB;
        nNivel          NUMBER := 1;
    BEGIN   
            pPK1    := 'CODCIA=' || nCodCia || ',CODEMPRESA=' || nCodEmpresa || ' ,IDCOTIZACION=' || nIdCotizacion;
            SetSalidaXml := GENERALES_PLATAFORMA_DIGITAL.DIGITAL_PLANTILLA(nNivel, pPK1);         
            SetSalidaXml := '<?xml version="1.0" encoding="UTF-8" ?>' || SetSalidaXml ;
        RETURN   SetSalidaXml;          
    END;
    --    
    FUNCTION RECOTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) return BOOLEAN IS 
    BEGIN
        GT_COTIZACIONES.RECOTIZACION(NCODCIA, NCODEMPRESA, NIDCOTIZACION);
        RETURN TRUE;
    EXCEPTION WHEN OTHERS THEN
        RETURN FALSE;
    END;
    --    
    FUNCTION CATALOGO_GIRO(pESPARAVIDA CHAR, pESACEPTADO CHAR) return CLOB IS
        SetSalidaXml    CLOB;
        CURSOR Q_CATA IS
                SELECT  XMLELEMENT("GIRO", 
                            XMLELEMENT("ACTIVIDAD", A.DESCRIPCION)) AS DATAXML
                FROM THONAPI.DIGITAL_ACTIVIDADES A
                WHERE ESPARAVIDA = UPPER(pESPARAVIDA)
                  AND ACEPTADAS = UPPER(pESACEPTADO);
        --                  
        R_CATA Q_CATA%ROWTYPE;
        --
        CATA CLOB;
        --
    BEGIN   
            CATA := '<?xml version="1.0" encoding="UTF-8" ?><CATALOGO>';
            OPEN Q_CATA;
            LOOP
                FETCH Q_CATA INTO R_CATA;
                EXIT WHEN Q_CATA%NOTFOUND;
                --
                CATA := CATA || R_CATA.DATAXML.getclobval();
                --
            END LOOP;
            --    
            CLOSE Q_CATA;
            CATA :=  CATA || '</CATALOGO>';
            RETURN  CATA;           

    END;
    --
    FUNCTION COBERTURA_ATRIBUTOS(P_IdCotizacion NUMBER, P_IDetCotizacion NUMBER) RETURN CLOB IS

        CURSOR Q_COB IS
            SELECT XMLELEMENT("ATRIBUTOS", 
                       XMLELEMENT("EDAD_MINIMA",  MIN(CC.EDAD_MINIMA)),
                       XMLELEMENT("EDAD_MAXIMA",  MAX(CC.EDAD_MAXIMA)),
                       XMLELEMENT("EDAD_EXCLUSION",  MAX(CC.EDAD_EXCLUSION))) AS DATAXML  
             FROM SICAS_OC.COTIZACIONES C INNER JOIN COTIZACIONES_COBERT_MASTER CC ON CC.CODCIA = C.CODCIA AND CC.CODEMPRESA = C.CODEMPRESA AND CC.IDCOTIZACION = C.IDCOTIZACION 
            WHERE C.CODCIA               = 1
              AND C.CODEMPRESA           = 1
              AND C.IDCOTIZACION         = P_IdCotizacion
              AND CC.IDETCOTIZACION      = P_IDetCotizacion
              AND C.INDCOTIZACIONBASEWEB = 'S';
                                          
        R_COB Q_COB%ROWTYPE;
        --
        CATA CLOB;
        --
      
    BEGIN
        --        
        CATA := '<?xml version="1.0" encoding="UTF-8" ?><COBERTURA_ATRIBUTOS>';
        OPEN Q_COB ;
        LOOP
            FETCH Q_COB INTO R_COB;
            EXIT WHEN Q_COB%NOTFOUND;
            --
            CATA := CATA || R_COB.DATAXML.getclobval();
            --
        END LOOP;
        --    
        CLOSE Q_COB;
        CATA :=  CATA || '</COBERTURA_ATRIBUTOS>';
        RETURN  CATA;           
        --
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN NULL;     
    END COBERTURA_ATRIBUTOS;  
    --   
    PROCEDURE RECALCULAR_COTIZACION(p_nCodCia NUMBER, p_nCodEmpresa NUMBER, p_nIdCotizacion NUMBER,
                                  p_cIdTipoSeg VARCHAR2, p_cPlanCob VARCHAR2, p_cIndAsegModelo VARCHAR2,
                                  p_cIndCensoSubgrupo VARCHAR2, p_cIndListadoAseg VARCHAR2) IS
    BEGIN                                  
            GT_COTIZACIONES.RECALCULAR_COTIZACION (p_nCodCia , p_nCodEmpresa , p_nIdCotizacion ,
                                  p_cIdTipoSeg , p_cPlanCob , p_cIndAsegModelo ,
                                  p_cIndCensoSubgrupo , p_cIndListadoAseg );
                                  
    END RECALCULAR_COTIZACION;
    --
    FUNCTION DESCARTA_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER) return INT IS       
        nCount NUMBER;
    BEGIN
           DELETE FROM COTIZACIONES  C
                    WHERE C.CODCIA         = nCodCia
                      AND C.CODEMPRESA     = nCodEmpresa
                      AND C.IDCOTIZACION   = nIdCotizacion
                      AND C.CODUSUARIO     = 'THONAPI';  
                      --AND C.INDCOTIZACIONWEB = 'S';    
           --
           nCount := SQL%ROWCOUNT;
           IF SQL%ROWCOUNT > 0 THEN            
               DELETE FROM COTIZACIONES_COBERT_ASEG A
                        WHERE A.CODCIA          = nCodCia
                          AND A.CODEMPRESA      = nCodEmpresa
                          AND A.IDCOTIZACION    = nIdCotizacion;           
           END IF;           
           RETURN nCount;
     END DESCARTA_COTIZACION;
    --
    FUNCTION DIGITAL_CATALOGO_PROCESO(P_TIPOPROCESO VARCHAR2 := 'EMIS%') RETURN CLOB IS
    
        W_CODPLANTILLA  VARCHAR2(100) := NULL;
        W_CODCOTIZADOR  VARCHAR2(100) := NULL;
        W_IDTIPOSEG     VARCHAR2(100) := NULL;
        
        CURSOR Q_COB IS
            SELECT XMLELEMENT("XPROC",  
                                       XMLELEMENT("DESCRIPCION", T.DESCRIPCION), 
                                       --XMLELEMENT("PLANCOB", P.PLANCOB), 
                                       XMLELEMENT("DESC_PLAN", C.DESC_PLAN), 
                                       XMLELEMENT("TIPOPROCESO", P.TIPOPROCESO)) DATOSXML,
                                       P.CODPLANTILLA,
                                       Z.CODCOTIZADOR,
                                       P.IDTIPOSEG,
                                       P.PLANCOB
              FROM CONFIG_PLANTILLAS_PLANCOB P INNER JOIN PLAN_COBERTURAS   C  ON C.IDTIPOSEG = P.IDTIPOSEG AND C.CODCIA = P.CODCIA AND C.CODEMPRESA = P.CODEMPRESA   AND C.PLANCOB = P.PLANCOB  
                                               INNER JOIN TIPOS_DE_SEGUROS  T  ON T.IDTIPOSEG = P.IDTIPOSEG AND T.CODCIA = P.CODCIA AND T.CODEMPRESA = P.CODEMPRESA 
                                               INNER JOIN COTIZACIONES      Z  ON Z.IDTIPOSEG = P.IDTIPOSEG AND Z.CODCIA = P.CODCIA AND Z.CODEMPRESA = P.CODEMPRESA
             WHERE P.CODCIA         = 1
               AND P.CODEMPRESA     = 1
               AND P.TIPOPROCESO LIKE P_TIPOPROCESO                                           
               --AND GT_COTIZACIONES.COTIZACION_BASE_WEB(Z.CODCIA, Z.CODEMPRESA, Z.IDCOTIZACION )   = 'S'                 
            ORDER BY P.IDTIPOSEG, P.PLANCOB, P.TIPOPROCESO, P.PLANCOB;
        R_COB Q_COB%ROWTYPE;
        --
        CATA CLOB;
        --
      
    BEGIN
        --        
        CATA := '<?xml version="1.0" encoding="UTF-8" ?><DIGITAL_CATALOGO_PROCESO>';
        OPEN Q_COB;
        FETCH Q_COB INTO R_COB;
        
        W_CODPLANTILLA := REPLACE(R_COB.CODPLANTILLA, ' ', '_');
        W_CODCOTIZADOR := REPLACE(R_COB.CODCOTIZADOR, ' ', '_');
        W_IDTIPOSEG := REPLACE(R_COB.IDTIPOSEG, ' ', '_');
        
        LOOP
                CATA := CATA || '<'  || REPLACE(R_COB.CODPLANTILLA, ' ', '_') || '>';
            WHILE W_CODPLANTILLA = REPLACE(R_COB.CODPLANTILLA, ' ', '_') LOOP
                    CATA := CATA || '<'  || REPLACE(R_COB.CODCOTIZADOR, ' ', '_') || '>';
                WHILE W_CODCOTIZADOR = REPLACE(R_COB.CODCOTIZADOR, ' ', '_') LOOP
                        CATA := CATA || '<'  ||REPLACE( R_COB.IDTIPOSEG, ' ', '_') || '>';
                    WHILE W_IDTIPOSEG = REPLACE(R_COB.IDTIPOSEG, ' ', '_') LOOP
                        --                           
                        CATA := CATA || R_COB.DATOSXML.getclobval();
                        CATA :=  REPLACE(CATA, 'XPROC',  REPLACE(R_COB.PLANCOB, ' ', '_'));
                        --
                        FETCH Q_COB INTO R_COB;
                        EXIT WHEN Q_COB%NOTFOUND;
                    END LOOP;          
                    CATA := CATA || '</' || W_IDTIPOSEG || '>';
                    EXIT WHEN Q_COB%NOTFOUND;
                    W_IDTIPOSEG := REPLACE(R_COB.IDTIPOSEG, ' ', '_');                              
                END LOOP;                                        
                CATA := CATA || '</' || W_CODCOTIZADOR || '>';
                EXIT WHEN Q_COB%NOTFOUND;
                W_CODCOTIZADOR := REPLACE(R_COB.CODCOTIZADOR, ' ', '_');
            END LOOP;                                        
            CATA := CATA || '</' || W_CODPLANTILLA || '>';
            EXIT WHEN Q_COB%NOTFOUND;
            W_CODPLANTILLA :=REPLACE(R_COB.CODPLANTILLA, ' ', '_');
        END LOOP;
        --            
        CLOSE Q_COB;        
        CATA :=  CATA || '</DIGITAL_CATALOGO_PROCESO>';
        RETURN  CATA;           
        --
    EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN NULL;     
    END DIGITAL_CATALOGO_PROCESO;  
    --   
    FUNCTION PLANTILLA_DATOS_PROCESO(W_CODCIA IN NUMBER, W_CODEMPRESA NUMBER, P_IDTIPOSEG   VARCHAR2, P_PLANCOB VARCHAR2, P_TIPOPROCESO VARCHAR2 := 'EMISIO') RETURN CLOB IS

        R NUMBER := 0;
        wNumReg NUMBER :=1;
        
        CURSOR Q_NUMREG (P_IDTIPOSEG VARCHAR2, P_PLANCOB VARCHAR2) IS 
            SELECT MAX(D.CODSUBGRUPO) CODSUBGRUPO 
              FROM COTIZACIONES C INNER JOIN COTIZACIONES_DETALLE D ON D.CODCIA = C.CODCIA AND D.CODEMPRESA = C.CODEMPRESA AND C.IDCOTIZACION = D.IDCOTIZACION
             WHERE C.IDTIPOSEG  = P_IDTIPOSEG
               AND C.PLANCOB    = P_PLANCOB  
               AND C.CODCIA     = W_CODCIA
               AND C.CODEMPRESA = W_CODEMPRESA
               AND C.INDCOTIZACIONBASEWEB = 'S';
        R_NUMREG Q_NUMREG%ROWTYPE;
        

        CURSOR Q_PLAN (P_IDTIPOSEG VARCHAR2, P_PLANCOB VARCHAR2, P_TIPOPROCESO VARCHAR2) IS
            SELECT P.IDTIPOSEG, P.PLANCOB, P.TIPOPROCESO, P.CODPLANTILLA, CP.DESCPLANTILLA, CP.TIPOPLANTILLA, CP.INDSEPARADOR, CP.ACCIONPLANTILLA
              FROM CONFIG_PLANTILLAS_PLANCOB P,
                   CONFIG_PLANTILLAS CP  
             WHERE P.CODCIA         = W_CODCIA
               AND P.CODEMPRESA     = W_CODEMPRESA
               --AND P.IDTIPOSEG      = P_IDTIPOSEG
               --AND P.PLANCOB        = P_PLANCOB
               --AND P.TIPOPROCESO    = P_TIPOPROCESO
               AND P.CODPLANTILLA    = 'THONAPI'
               AND CP.CODCIA         = P.CODCIA
               AND CP.CODEMPRESA     = P.CODEMPRESA
               AND CP.CODPLANTILLA   = P.CODPLANTILLA               
               AND CP.STSPLANTILLA   = 'ACT';
        R_PLAN Q_PLAN%ROWTYPE;                  

        CURSOR Q_TABLAS (P_CODPLANTILLA VARCHAR2) IS        
            SELECT T.NOMTABLA, T.ORDENPROCESO 
              FROM CONFIG_PLANTILLAS_TABLAS T
             WHERE T.CODCIA         = W_CODCIA
               AND T.CODEMPRESA     = W_CODEMPRESA
               AND T.CODPLANTILLA   = P_CODPLANTILLA
            ORDER BY ORDENPROCESO;
        R_TABLAS Q_TABLAS%ROWTYPE;     
              
        CURSOR Q_CAMPOS (P_CODPLANTILLA VARCHAR2, P_NOMTABLA VARCHAR2, P_ORDENPROCESO NUMBER) IS        
            SELECT C.ORDENCAMPO, C.NOMCAMPO, C.INDCLAVEPRIMARIA, C.TIPOCAMPO, C.NUMDECIMALES, C.INDDATOPART, C.ORDENDATOPART, C.INDASEG, C.VALORDEFAULT
              FROM CONFIG_PLANTILLAS_CAMPOS C 
             WHERE C.CODCIA         = W_CODCIA
               AND C.CODEMPRESA     = W_CODEMPRESA
               AND C.CODPLANTILLA   = P_CODPLANTILLA
               AND C.NOMTABLA       = P_NOMTABLA
               AND C.ORDENPROCESO   = P_ORDENPROCESO
            ORDER BY C.ORDENCAMPO;
        R_CAMPOS Q_CAMPOS%ROWTYPE;            
        --
        RESULTADO CLOB;
        --
      
        FUNCTION GENTAG(NOMTAG VARCHAR2, VALOR VARCHAR2, ES_ATRIB BOOLEAN := FALSE) RETURN VARCHAR2 IS
            XGENTAG VARCHAR2(32727) := NULL;
        BEGIN
            XGENTAG := '<' ||NOMTAG ||'>' || VALOR || '</' ||NOMTAG ||'>';
            RETURN XGENTAG;
        END GENTAG;
        --
        FUNCTION EXTRAE_DICCIONARIO(P_TABLA VARCHAR2, P_COLUMNA VARCHAR2) RETURN VARCHAR2 IS       
            DESCRIPCION VARCHAR2(500);
            SW BOOLEAN := FALSE;
            --
            CURSOR Q_DICC IS
                SELECT C.COMMENTS
                  FROM SYS.ALL_COL_COMMENTS C
                 WHERE C.OWNER = 'SICAS_OC'
                   AND C.TABLE_NAME = P_TABLA
                   AND C.COLUMN_NAME = P_COLUMNA
                   AND LENGTH(TRIM(C.COMMENTS)) > 0; 
            R_DICC Q_DICC%ROWTYPE;
            --                   
            CURSOR Q_DICC2 IS
                SELECT min(C.COMMENTS) COMMENTS
                  FROM SYS.ALL_COL_COMMENTS C
                 WHERE C.OWNER = 'SICAS_OC'
                   AND LENGTH(C.COMMENTS) > 0
                   AND C.COLUMN_NAME = P_COLUMNA; 
            R_DICC2 Q_DICC2%ROWTYPE;
            --                   
        BEGIN
            OPEN Q_DICC;
            LOOP
                FETCH Q_DICC INTO R_DICC;
                EXIT WHEN Q_DICC%NOTFOUND;
                DESCRIPCION := R_DICC.COMMENTS;
                SW := TRUE;
            END LOOP;
            CLOSE Q_DICC;
            IF NOT SW THEN
                DESCRIPCION := replace(P_COLUMNA, '_', ' ');
                DESCRIPCION := UPPER(SUBSTR(DESCRIPCION, 1, 1)) || LOWER(SUBSTR(DESCRIPCION, 2, LENGTH(DESCRIPCION) - 1)); 
--                OPEN Q_DICC2;
--                LOOP
--                    FETCH Q_DICC2 INTO R_DICC2;
--                    EXIT WHEN Q_DICC2%NOTFOUND;                    
--                    DESCRIPCION := R_DICC2.COMMENTS;
--                END LOOP;
--                CLOSE Q_DICC2;            
            END IF;
            RETURN DESCRIPCION;
        END EXTRAE_DICCIONARIO;
        --
    BEGIN
        --
        --RESULTADO := RESULTADO || R_COB.DATAXML.getclobval();      
        --  
        RESULTADO := '<?xml version="1.0" encoding="UTF-8" ?>' ||  CHR(10) ;
        RESULTADO := RESULTADO || '<PLANTILLA>' || CHR(10);
        OPEN Q_PLAN (P_IDTIPOSEG, P_PLANCOB, P_TIPOPROCESO); LOOP        
            FETCH Q_PLAN INTO R_PLAN;
            EXIT WHEN Q_PLAN%NOTFOUND;
            --  
            RESULTADO := RESULTADO || CHR(9) || '<PLAN_COBERT ' || 
                                      'TIPO_PLANTILLA="' || R_PLAN.TIPOPLANTILLA ||'" ' ||
                                      'INDSEPARADOR="' || R_PLAN.INDSEPARADOR ||'" ' ||
                                      'ACCIONPLANTILLA="' || R_PLAN.ACCIONPLANTILLA || '">' ||CHR(10);
            RESULTADO := RESULTADO || CHR(9) || CHR(9) ||GENTAG('IDTIPOSEG', R_PLAN.IDTIPOSEG)||CHR(10);
            RESULTADO := RESULTADO || CHR(9) || CHR(9) ||GENTAG('PLANCOB', R_PLAN.PLANCOB)||CHR(10);
            RESULTADO := RESULTADO || CHR(9) || CHR(9) ||GENTAG('TIPOPROCESO', R_PLAN.TIPOPROCESO)||CHR(10);
            RESULTADO := RESULTADO || CHR(9) || CHR(9) ||GENTAG('CODPLANTILLA', R_PLAN.CODPLANTILLA)||CHR(10);
            RESULTADO := RESULTADO || CHR(9) || CHR(9) ||GENTAG('DESCPLANTILLA', R_PLAN.DESCPLANTILLA)||CHR(10);

                DBMS_OUTPUT.PUT_LINE(P_IDTIPOSEG);
                DBMS_OUTPUT.PUT_LINE(P_PLANCOB);
             
            --
            OPEN Q_NUMREG (P_IDTIPOSEG, P_PLANCOB);
                FETCH Q_NUMREG INTO R_NUMREG;
                DBMS_OUTPUT.PUT_LINE(R_NUMREG.CODSUBGRUPO);
                wNumReg := TO_NUMBER(NVL(R_NUMREG.CODSUBGRUPO, 1));   
                DBMS_OUTPUT.PUT_LINE(wNumReg);
                IF wNumReg = 0 THEN wNumReg := 1; END IF;         
            FOR R IN 1..wNumReg LOOP
                RESULTADO := RESULTADO || CHR(9) || CHR(9) || CHR(9) || '<TABLAS>'|| CHR(10);
                
                OPEN Q_TABLAS (R_PLAN.CODPLANTILLA); LOOP        
                    FETCH Q_TABLAS INTO R_TABLAS;
                    EXIT WHEN Q_TABLAS%NOTFOUND;
                    --
                    RESULTADO := RESULTADO || CHR(9) || CHR(9) || CHR(9) || CHR(9) || '<' || R_TABLAS.NOMTABLA || '>' ||
                                                                                    'ORDENPROCESO="' || R_TABLAS.ORDENPROCESO || '">' || CHR(10);
                    --
                    OPEN Q_CAMPOS (R_PLAN.CODPLANTILLA, R_TABLAS.NOMTABLA, R_TABLAS.ORDENPROCESO); LOOP   
                        FETCH Q_CAMPOS INTO R_CAMPOS;
                        EXIT WHEN Q_CAMPOS%NOTFOUND;
                        --
                            RESULTADO := RESULTADO || CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || '<' || REPLACE(R_CAMPOS.NOMCAMPO, ' ', '_')  || ' ' || 
                                          'ORDENCAMPO="' || R_CAMPOS.ORDENCAMPO ||'" ' ||
                                          'INDCLAVEPRIMARIA="' || R_CAMPOS.INDCLAVEPRIMARIA ||'" ' ||
                                          'TIPOCAMPO="' || R_CAMPOS.TIPOCAMPO ||'" ' ||
                                          'NUMDECIMALES="' || R_CAMPOS.NUMDECIMALES ||'" ' ||
                                          'INDDATOPART="' || R_CAMPOS.INDDATOPART ||'" ' ||
                                          'ORDENDATOPART="' || R_CAMPOS.ORDENDATOPART ||'" ' ||
                                          'INDASEG="' || R_CAMPOS.INDASEG ||'" ' ||
                                          'DEFAULT="' || R_CAMPOS.VALORDEFAULT ||'" ' ||
                                          'CAPTION="' || EXTRAE_DICCIONARIO(R_TABLAS.NOMTABLA, R_CAMPOS.NOMCAMPO)|| '" />' || CHR(10);
                        --
                    END LOOP;
                    --
                    CLOSE Q_CAMPOS;
                    RESULTADO := RESULTADO || CHR(9) || CHR(9) || CHR(9) || CHR(9) || '</' || R_TABLAS.NOMTABLA || '>' ||  CHR(10) ;
                    --
                END LOOP;
                --
                RESULTADO := RESULTADO || CHR(9) || CHR(9) || CHR(9) || '</TABLAS>' || CHR(10) ; 
                --
                CLOSE Q_TABLAS;
            END LOOP;
            RESULTADO := RESULTADO || CHR(9) || '</PLAN_COBERT>' ||  CHR(10) ; 
            CLOSE Q_NUMREG;
        END LOOP;
        --            
        CLOSE Q_PLAN;
        RESULTADO :=  RESULTADO || '</PLANTILLA>';
        RESULTADO := REPLACE(REPLACE(RESULTADO, CHR(9), NULL), CHR(10), NULL);
        RETURN  RESULTADO;           
    END PLANTILLA_DATOS_PROCESO;
    --
    FUNCTION PLANTILLA_DATOS_PROCESO_NEW(W_CODCIA IN NUMBER, W_CODEMPRESA NUMBER, P_IDTIPOSEG   VARCHAR2, P_PLANCOB VARCHAR2, P_TIPOPROCESO VARCHAR2 := 'EMISIO') RETURN CLOB IS

        R NUMBER := 0;
        wNumReg NUMBER :=1;
        
        CURSOR Q_NUMREG (P_IDTIPOSEG VARCHAR2, P_PLANCOB VARCHAR2) IS 
            SELECT MAX(D.CODSUBGRUPO) CODSUBGRUPO 
              FROM COTIZACIONES C INNER JOIN COTIZACIONES_DETALLE D ON D.CODCIA = C.CODCIA AND D.CODEMPRESA = C.CODEMPRESA AND C.IDCOTIZACION = D.IDCOTIZACION
             WHERE C.IDTIPOSEG  = P_IDTIPOSEG
               AND C.PLANCOB    = P_PLANCOB  
               AND C.CODCIA     = W_CODCIA
               AND C.CODEMPRESA = W_CODEMPRESA
               AND C.INDCOTIZACIONBASEWEB = 'S';
        R_NUMREG Q_NUMREG%ROWTYPE;
        

        CURSOR Q_PLAN (P_IDTIPOSEG VARCHAR2, P_PLANCOB VARCHAR2, P_TIPOPROCESO VARCHAR2) IS
            SELECT P.IDTIPOSEG, P.PLANCOB, P.TIPOPROCESO, P.CODPLANTILLA, CP.DESCPLANTILLA, CP.TIPOPLANTILLA, CP.INDSEPARADOR, CP.ACCIONPLANTILLA
              FROM CONFIG_PLANTILLAS_PLANCOB P,
                   CONFIG_PLANTILLAS CP  
             WHERE P.CODCIA         = W_CODCIA
               AND P.CODEMPRESA     = W_CODEMPRESA
               --AND P.IDTIPOSEG      = P_IDTIPOSEG
               --AND P.PLANCOB        = P_PLANCOB
               --AND P.TIPOPROCESO    = P_TIPOPROCESO
               AND P.CODPLANTILLA    = 'THONAPI2'
               AND CP.CODCIA         = P.CODCIA
               AND CP.CODEMPRESA     = P.CODEMPRESA
               AND CP.CODPLANTILLA   = P.CODPLANTILLA               
               AND CP.STSPLANTILLA   = 'ACT';
        R_PLAN Q_PLAN%ROWTYPE;                  

        CURSOR Q_TABLAS (P_CODPLANTILLA VARCHAR2) IS        
            SELECT T.NOMTABLA, T.ORDENPROCESO 
              FROM CONFIG_PLANTILLAS_TABLAS T
             WHERE T.CODCIA         = W_CODCIA
               AND T.CODEMPRESA     = W_CODEMPRESA
               AND T.CODPLANTILLA   = P_CODPLANTILLA
            ORDER BY ORDENPROCESO;
        R_TABLAS Q_TABLAS%ROWTYPE;     
              
        CURSOR Q_CAMPOS (P_CODPLANTILLA VARCHAR2, P_NOMTABLA VARCHAR2, P_ORDENPROCESO NUMBER) IS        
            SELECT C.ORDENCAMPO, C.NOMCAMPO, C.INDCLAVEPRIMARIA, C.TIPOCAMPO, C.NUMDECIMALES, C.INDDATOPART, C.ORDENDATOPART, C.INDASEG, C.VALORDEFAULT
              FROM CONFIG_PLANTILLAS_CAMPOS C 
             WHERE C.CODCIA         = W_CODCIA
               AND C.CODEMPRESA     = W_CODEMPRESA
               AND C.CODPLANTILLA   = P_CODPLANTILLA
               AND C.NOMTABLA       = P_NOMTABLA
               AND C.ORDENPROCESO   = P_ORDENPROCESO
            ORDER BY C.ORDENCAMPO;
        R_CAMPOS Q_CAMPOS%ROWTYPE;            
        --
        RESULTADO CLOB;
        --
      
        FUNCTION GENTAG(NOMTAG VARCHAR2, VALOR VARCHAR2, ES_ATRIB BOOLEAN := FALSE) RETURN VARCHAR2 IS
            XGENTAG VARCHAR2(32727) := NULL;
        BEGIN
            XGENTAG := '<' ||NOMTAG ||'>' || VALOR || '</' ||NOMTAG ||'>';
            RETURN XGENTAG;
        END GENTAG;
        --
        FUNCTION EXTRAE_DICCIONARIO(P_TABLA VARCHAR2, P_COLUMNA VARCHAR2) RETURN VARCHAR2 IS       
            DESCRIPCION VARCHAR2(500);
            SW BOOLEAN := FALSE;
            --
            CURSOR Q_DICC IS
                SELECT C.COMMENTS
                  FROM SYS.ALL_COL_COMMENTS C
                 WHERE C.OWNER = 'SICAS_OC'
                   AND C.TABLE_NAME = P_TABLA
                   AND C.COLUMN_NAME = P_COLUMNA
                   AND LENGTH(TRIM(C.COMMENTS)) > 0; 
            R_DICC Q_DICC%ROWTYPE;
            --                   
            CURSOR Q_DICC2 IS
                SELECT min(C.COMMENTS) COMMENTS
                  FROM SYS.ALL_COL_COMMENTS C
                 WHERE C.OWNER = 'SICAS_OC'
                   AND LENGTH(C.COMMENTS) > 0
                   AND C.COLUMN_NAME = P_COLUMNA; 
            R_DICC2 Q_DICC2%ROWTYPE;
            --                   
        BEGIN
            OPEN Q_DICC;
            LOOP
                FETCH Q_DICC INTO R_DICC;
                EXIT WHEN Q_DICC%NOTFOUND;
                DESCRIPCION := R_DICC.COMMENTS;
                SW := TRUE;
            END LOOP;
            CLOSE Q_DICC;
            IF NOT SW THEN
                DESCRIPCION := replace(P_COLUMNA, '_', ' ');
                DESCRIPCION := UPPER(SUBSTR(DESCRIPCION, 1, 1)) || LOWER(SUBSTR(DESCRIPCION, 2, LENGTH(DESCRIPCION) - 1)); 
--                OPEN Q_DICC2;
--                LOOP
--                    FETCH Q_DICC2 INTO R_DICC2;
--                    EXIT WHEN Q_DICC2%NOTFOUND;                    
--                    DESCRIPCION := R_DICC2.COMMENTS;
--                END LOOP;
--                CLOSE Q_DICC2;            
            END IF;
            RETURN DESCRIPCION;
        END EXTRAE_DICCIONARIO;
        --
    BEGIN
        --
        --RESULTADO := RESULTADO || R_COB.DATAXML.getclobval();      
        --  
        RESULTADO := '<?xml version="1.0" encoding="UTF-8" ?>' ||  CHR(10) ;
        RESULTADO := RESULTADO || '<PLANTILLA>' || CHR(10);
        OPEN Q_PLAN (P_IDTIPOSEG, P_PLANCOB, P_TIPOPROCESO); LOOP        
            FETCH Q_PLAN INTO R_PLAN;
            EXIT WHEN Q_PLAN%NOTFOUND;
            --  
            RESULTADO := RESULTADO || CHR(9) || '<PLAN_COBERT ' || 
                                      'TIPO_PLANTILLA="' || R_PLAN.TIPOPLANTILLA ||'" ' ||
                                      'INDSEPARADOR="' || R_PLAN.INDSEPARADOR ||'" ' ||
                                      'ACCIONPLANTILLA="' || R_PLAN.ACCIONPLANTILLA || '">' ||CHR(10);
            RESULTADO := RESULTADO || CHR(9) || CHR(9) ||GENTAG('IDTIPOSEG', R_PLAN.IDTIPOSEG)||CHR(10);
            RESULTADO := RESULTADO || CHR(9) || CHR(9) ||GENTAG('PLANCOB', R_PLAN.PLANCOB)||CHR(10);
            RESULTADO := RESULTADO || CHR(9) || CHR(9) ||GENTAG('TIPOPROCESO', R_PLAN.TIPOPROCESO)||CHR(10);
            RESULTADO := RESULTADO || CHR(9) || CHR(9) ||GENTAG('CODPLANTILLA', R_PLAN.CODPLANTILLA)||CHR(10);
            RESULTADO := RESULTADO || CHR(9) || CHR(9) ||GENTAG('DESCPLANTILLA', R_PLAN.DESCPLANTILLA)||CHR(10);

                DBMS_OUTPUT.PUT_LINE(P_IDTIPOSEG);
                DBMS_OUTPUT.PUT_LINE(P_PLANCOB);
             
            --
            OPEN Q_NUMREG (P_IDTIPOSEG, P_PLANCOB);
                FETCH Q_NUMREG INTO R_NUMREG;
                DBMS_OUTPUT.PUT_LINE(R_NUMREG.CODSUBGRUPO);
                wNumReg := TO_NUMBER(NVL(R_NUMREG.CODSUBGRUPO, 1));   
                DBMS_OUTPUT.PUT_LINE(wNumReg);
                IF wNumReg = 0 THEN wNumReg := 1; END IF;         
            FOR R IN 1..wNumReg LOOP
                RESULTADO := RESULTADO || CHR(9) || CHR(9) || CHR(9) || '<TABLAS>'|| CHR(10);
                
                OPEN Q_TABLAS (R_PLAN.CODPLANTILLA); LOOP        
                    FETCH Q_TABLAS INTO R_TABLAS;
                    EXIT WHEN Q_TABLAS%NOTFOUND;
                    --
                    RESULTADO := RESULTADO || CHR(9) || CHR(9) || CHR(9) || CHR(9) || '<' || R_TABLAS.NOMTABLA || '>' ||
                                                                                    'ORDENPROCESO="' || R_TABLAS.ORDENPROCESO || '">' || CHR(10);
                    --
                    OPEN Q_CAMPOS (R_PLAN.CODPLANTILLA, R_TABLAS.NOMTABLA, R_TABLAS.ORDENPROCESO); LOOP   
                        FETCH Q_CAMPOS INTO R_CAMPOS;
                        EXIT WHEN Q_CAMPOS%NOTFOUND;
                        --
                            RESULTADO := RESULTADO || CHR(9) || CHR(9) || CHR(9) || CHR(9) || CHR(9) || '<' || REPLACE(R_CAMPOS.NOMCAMPO, ' ', '_')  || ' ' || 
                                          'ORDENCAMPO="' || R_CAMPOS.ORDENCAMPO ||'" ' ||
                                          'INDCLAVEPRIMARIA="' || R_CAMPOS.INDCLAVEPRIMARIA ||'" ' ||
                                          'TIPOCAMPO="' || R_CAMPOS.TIPOCAMPO ||'" ' ||
                                          'NUMDECIMALES="' || R_CAMPOS.NUMDECIMALES ||'" ' ||
                                          'INDDATOPART="' || R_CAMPOS.INDDATOPART ||'" ' ||
                                          'ORDENDATOPART="' || R_CAMPOS.ORDENDATOPART ||'" ' ||
                                          'INDASEG="' || R_CAMPOS.INDASEG ||'" ' ||
                                          'DEFAULT="' || CASE WHEN R > 1 THEN 'A' ELSE R_CAMPOS.VALORDEFAULT END ||'" ' ||
                                          'CAPTION="' || EXTRAE_DICCIONARIO(R_TABLAS.NOMTABLA, R_CAMPOS.NOMCAMPO)|| '" />' || CHR(10);
                        --
                    END LOOP;
                    --
                    CLOSE Q_CAMPOS;
                    RESULTADO := RESULTADO || CHR(9) || CHR(9) || CHR(9) || CHR(9) || '</' || R_TABLAS.NOMTABLA || '>' ||  CHR(10) ;
                    --
                END LOOP;
                --
                RESULTADO := RESULTADO || CHR(9) || CHR(9) || CHR(9) || '</TABLAS>' || CHR(10) ; 
                --
                CLOSE Q_TABLAS;
            END LOOP;
            RESULTADO := RESULTADO || CHR(9) || '</PLAN_COBERT>' ||  CHR(10) ; 
            CLOSE Q_NUMREG;
        END LOOP;
        --            
        CLOSE Q_PLAN;
        RESULTADO :=  RESULTADO || '</PLANTILLA>';
        RESULTADO := REPLACE(REPLACE(RESULTADO, CHR(9), NULL), CHR(10), NULL);
        RETURN  RESULTADO;           
    END PLANTILLA_DATOS_PROCESO_NEW;
    --
    FUNCTION COTIZACION_ACTUALIZA(QRY_DML VARCHAR2) RETURN NUMBER IS            
        V_TABLAS    VARCHAR2(1000) := 'COTIZACIONES|COTIZACIONES_DETALLE|COTIZACIONES_COBERT_ASEG|COTIZACIONES_ASEG|COTIZACIONES_COBERTURAS|COTIZADOR_EDADES_CRITERIO|COTIZADOR_CRITERIO_PRUEBAS';
        SW_EXISTS   NUMBER := 0;
        W_QRY_DML   VARCHAR2(32726);
        --
        CURSOR Q_TABLAS IS
            SELECT COLUMN_VALUE
              FROM TABLE(GT_WEB_SERVICES.SPLIT(V_TABLAS, '|'));
        R_TABLAS    Q_TABLAS%ROWTYPE;                            
    BEGIN
        
        IF INSTR(UPPER(QRY_DML), 'UPDATE') > 0 THEN 
            OPEN Q_TABLAS;            
            LOOP
                 FETCH Q_TABLAS INTO R_TABLAS;
                 EXIT WHEN Q_TABLAS%NOTFOUND; 
                 IF INSTR(QRY_DML, R_TABLAS.COLUMN_VALUE) > 0 THEN
                    SW_EXISTS := 1;
                    EXIT;
                 END IF;
            END LOOP;
            CLOSE Q_TABLAS;
            IF SW_EXISTS = 1 THEN
                W_QRY_DML := REPLACE(QRY_DML, '"', '''');
                EXECUTE IMMEDIATE W_QRY_DML;
                SW_EXISTS := SQL%ROWCOUNT;
            ELSE
                SW_EXISTS :=  -1;  
            END IF;
        ELSE
            SW_EXISTS :=  -2;
        END IF;
        --
        RETURN SW_EXISTS;
        --                                         
    END COTIZACION_ACTUALIZA;
    --
    PROCEDURE COTIZACION_EMITIR(p_nCodCia NUMBER, p_nCodEmpresa NUMBER, p_nIdCotizacion NUMBER)  IS
    BEGIN                                  
            GT_COTIZACIONES.EMITIR_COTIZACION(p_nCodCia, p_nCodEmpresa, p_nIdCotizacion);
                                  
    END COTIZACION_EMITIR;
    --
    FUNCTION PRE_EMITE_POLIZA_NEW(nCodCia NUMBER, nCodEmpresa NUMBER, nIdCotizacion NUMBER, cCadena VARCHAR2, cIdPoliza NUMBER := NULL) return CLOB IS
        --LUCERO MAYOR 
          --cCadena           VARCHAR2(4000) := 'C,RFC,PELC700807XXX,ZORRILLA,NOMCONTRATANTE,ROBERTO,,07/08/1970,,,30/07/2019,30/07/2019,RIO CHURUBUSCO,44,B,,,,55,5530199059,cperex@thonaseguros.mx,CTC,012,123456789012345000,123456789,12345645645645,01/08/2022,BURGER PO KING,,30/07/2019,18/08/2020,ANUA,30/07/2019,18/08/2020,,N,30/07/2019,,1,BENEFICIARIO 1,01/01/2000,25,1,N|A,RFC,,PEDRO,TIMBAK,LUPITA,,07/08/1980,,,30/07/2019,30/07/2019,RIO CHURUBUSCO,44,B,,,,55,5530199059,cperex@thonaseguros.mx,CTC,012,123456789012345000,123456789,12345645645645,01/08/2022,LUCERITO LUC PE�ON,,30/07/2019,18/08/2020,ANUA,30/07/2019,18/08/2020,,N,30/07/2019,,1,BENEFICIARIO 1,01/01/2000,25,1,N,2,BENEFICIARIO 2,01/01/2000,25,1,N,3,BENEFICIARIO 3,01/01/2000,25,1,N,4,BENEFICIARIO 4,01/01/2000,25,1,N|A,RFC,,GABRIELA,LOPEZ,DE SANTA ANA,,07/08/1980,,,30/07/2019,30/07/2019,RIO CHURUBUSCO,44,B,,,,55,5530199059,cperex@thonaseguros.mx,CTC,012,123456789012345000,123456789,12345645645645,01/08/2022,NOMB PAGA CUENTA,,30/07/2019,18/08/2020,ANUA,30/07/2019,18/08/2020,,N,30/07/2019,,1,BENEFICIARIO 1,01/01/2000,25,1,N,2,BENEFICIARIO 2,01/01/2000,25,1,N,3,BENEFICIARIO 3,01/01/2000,25,1,N,4,BENEFICIARIO 4,01/01/2000,25,1,N';
        -----
        --Otros productos
        --cCadena            VARCHAR2(32727) := 'C,RFC,PELC700807XXX,ZORRILLA,NOMCONTRATANTE,ROBERTO,,07/08/1970,,,30/07/2019,30/07/2019,RIO CHURUBUSCO,44,B,,,,55,5530199059,cperex@thonaseguros.mx,CTC,012,123456789012345000,123456789,12345645645645,01/08/2022,BURGER PO KING,,30/07/2019,18/08/2020,ANUA,30/07/2019,18/08/2020,,N,30/07/2019,,1,BENEFICIARIO 1,01/01/2000,25,1,N|A,RFC,,PEDRO,TIMBAK,LUPITA,,07/08/1980,,,30/07/2019,30/07/2019,RIO CHURUBUSCO,44,B,,,,55,5530199059,cperex@thonaseguros.mx,CTC,012,123456789012345000,123456789,12345645645645,01/08/2022,LUCERITO LUC PE�ON,,30/07/2019,18/08/2020,ANUA,30/07/2019,18/08/2020,,N,30/07/2019,,1,BENEFICIARIO 1,01/01/2000,25,1,N,2,BENEFICIARIO 2,01/01/2000,25,1,N,3,BENEFICIARIO 3,01/01/2000,25,1,N,4,BENEFICIARIO 4,01/01/2000,25,1,N';
        ------  
          CRFC              VARCHAR2(20);
          nCodCliente       NUMBER;
          nCod_Asegurado    NUMBER;  
          cTipoDocIdentAseg VARCHAR2(100);
          cNumDocIdentAseg  VARCHAR2(100);
          nIdPoliza         VARCHAR2(100);  
          nIdePol           NUMBER := 1;
          nRegComision      NUMBER := 0;
          nIdTransaccion    NUMBER := 0;                   
          nPorcComProp      NUMBER := 0; 
          nPorcComis        NUMBER := 0; 
          wPorcComProp      NUMBER := 0; 
          wPorcComis        NUMBER := 0; 
          nTotPorcComis     NUMBER := 0;
          cNUMPOLUNICO      VARCHAR2(100);
          cFacturas         CLOB;
          nCantPol          NUMBER := 0;
          dBenefFecNAc      DATE;
          numBenef          NUMBER := 0;
          cCodPaisRes       VARCHAR2(20);     
          cCodProvRes       VARCHAR2(20);      
          cCodDistRes       VARCHAR2(20);
          cCodCorrRes       VARCHAR2(20);
          cCodValor         VARCHAR2(6);
          cTIPORIESGO       varchar2(6);
          cTipPersona       varchar2(6);
          cCodMoneda        POLIZAS.COD_MONEDA%TYPE;
          wIdCotizacion     NUMBER := 0;
          wPorcComis1   NUMBER := 0;     
          wPorcComis2   NUMBER := 0;     
          wPorcComis3   NUMBER := 0;     
          wPorcComisTot NUMBER := 0;
          wPorcComProp1  NUMBER := 0;
          wPorcComProp2  NUMBER := 0;
          wPorcComProp3  NUMBER := 0;
          wPorcComPropT  NUMBER := 0;
          
          CURSOR Q_NUMREG IS
            SELECT CASE WHEN COUNT(COLUMN_VALUE)> 2 THEN 'N' ELSE 'N' END ESCOLECTIVA,
                   COUNT(COLUMN_VALUE) NUMREG
              FROM table(GT_WEB_SERVICES.SPLIT(cCadena, '|'));
          R_NUMREG Q_NUMREG%ROWTYPE;

          CURSOR Q_TRAN (PnIdePol NUMBER) IS
            SELECT D.IDTRANSACCION      
                 FROM DETALLE_TRANSACCION D
                WHERE CodCia        = nCodCia
                  AND CodEmpresa    = nCodEmpresa
                  AND D.CODSUBPROCESO = 'POL'
                  AND D.OBJETO      ='POLIZAS'
                  AND D.VALOR1      = TRIM(TO_CHAR(PnIdePol));
          R_TRAN Q_TRAN%ROWTYPE;          
        
          CURSOR Q_DOMI (pCODPOSTAL VARCHAR2, pCODIGO_COLONIA VARCHAR2) IS
                SELECT DISTINCT                              
                       PA.CODPAIS,       
                       M.CODESTADO,
                       D.CODCIUDAD  ,
                       C.CODMUNICIPIO                       
                  FROM SICAS_OC.APARTADO_POSTAL CP INNER JOIN SICAS_OC.CORREGIMIENTO M ON M.CODMUNICIPIO = CP.CODMUNICIPIO AND M.CODPAIS = CP.CODPAIS AND M.CODESTADO = CP.CODESTADO AND M.CODCIUDAD = CP.CODCIUDAD 
                                                   INNER JOIN SICAS_OC.COLONIA       C ON C.CODPAIS = CP.CODPAIS AND C.CODESTADO = CP.CODESTADO AND C.CODCIUDAD = CP.CODCIUDAD AND C.CODMUNICIPIO = M.CODMUNICIPIO AND C.CODIGO_POSTAL = CP.CODIGO_POSTAL
                                                   INNER JOIN SICAS_OC.PROVINCIA     P ON P.CODPAIS = CP.CODPAIS AND P.CODESTADO = CP.CODESTADO
                                                   INNER JOIN DISTRITO               D ON D.CODPAIS = CP.CODPAIS AND D.CODESTADO = CP.CODESTADO AND D.CODCIUDAD = C.CODCIUDAD 
                                                   INNER JOIN SICAS_OC.PAIS          PA ON PA.CODPAIS = CP.CODPAIS                                   
                WHERE CP.CODIGO_POSTAL      =    pCODPOSTAL
                  AND C.CODIGO_COLONIA      =    pCODIGO_COLONIA;
                  
          R_DOMI Q_DOMI%ROWTYPE;          


         CURSOR DETPOL_Q IS
           SELECT *
             FROM DETALLE_POLIZA
            WHERE CODCIA        = nCodCia
              AND CODEMPRESA    = nCodEmpresa
              AND IDPOLIZA      = nIdPoliza
            ORDER BY IDPOLIZA;                           

    BEGIN
        IF cIdPoliza IS NULL THEN
--            ------------- QUITAR!!!!
--                UPDATE COTIZACIONES C SET IDPOLIZA = NULL, C.STSCOTIZACION = 'EMITID'
--                WHERE C.CODEMPRESA=nCodEmpresa
--                  AND C.CODCIA = nCodCia
--                  AND C.IDCOTIZACION = nIdCotizacion;   
--            ------------------------------------------------        
                IF SICAS_OC.GT_COTIZACIONES.EXISTE_COTIZACION_EMITIDA(NCODCIA, NCODEMPRESA, NIDCOTIZACION ) = 'N' THEN
                    RETURN 'Esta cotizaci�n no esta emitida: ' || NIDCOTIZACION;
                END IF;

                OPEN Q_NUMREG;
                FETCH Q_NUMREG INTO   R_NUMREG;      
                close Q_NUMREG;   
                --
                FOR ENT IN (SELECT COLUMN_VALUE FILA FROM table(GT_WEB_SERVICES.SPLIT(cCadena, '|'))) LOOP
                    --
                    IF OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,3,',') IS NOT NULL THEN
                        CRFC := OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,3,',');
                    ELSE
                        CRFC := OC_PERSONA_NATURAL_JURIDICA.NUMERO_TRIBUTARIO_RFC(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,4,','),
                                                                                  OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,5,','),
                                                                                  OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,6,','),
                                                                                  TO_DATE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,8,','), 'DD/MM/YYYY'),
                                                                                  'FISICA');
                    END IF;                                                                              
                    cTipoDocIdentAseg  :=       OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,2,',');
                    cNumDocIdentAseg   :=       CRFC;                                
                    --
                    IF OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,1,',') = 'C' AND nIdPoliza IS NULL  THEN  
                        nCodCliente := OC_CLIENTES.CODIGO_CLIENTE(cTipoDocIdentAseg, cNumDocIdentAseg);
                    END IF;
                    
                    IF OC_PERSONA_NATURAL_JURIDICA.EXISTE_PERSONA(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,2,','), CRFC) = 'N' THEN
                        --             
                        BEGIN
                        OPEN Q_DOMI(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,18,','), OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,16,','));                    
                            FETCH Q_DOMI INTO   R_DOMI;      
                            close Q_DOMI;   
                            
                            cCodPaisRes       := R_DOMI.CODPAIS; 
                            cCodProvRes       := R_DOMI.CODESTADO;   
                            cCodDistRes       := R_DOMI.CODCIUDAD;
                            cCodCorrRes       := R_DOMI.CODMUNICIPIO ;
                            

                        EXCEPTION WHEN OTHERS THEN
                            NULL;
                            END;
                        OC_PERSONA_NATURAL_JURIDICA.INSERTAR_PERSONA(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,2,','),   --cTipo_Doc_Identificacion
                                                                     CRFC,                                              --cNum_Doc_Identificacion
                                                                     OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,4,','),   --cNombre
                                                                     OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,5,','),   --cApellidoPat
                                                                     OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,6,','),   --cApellidoMat
                                                                     NULL,                                              --cApeCasada
                                                                     OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,7,','),   --cSexo
                                                                     NULL,                                              --cEstadoCivil
                                                                     TO_DATE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,8,','), 'DD/MM/YYYY'),   --dFecNacimiento
                                                                     OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,13,','),  --cDirecRes
                                                                     OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,14,','),  --cNumInterior
                                                                     OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,15,','),  --cNumExterior
                                                                     cCodPaisRes,                                       --cCodPaisRes
                                                                     cCodProvRes,  --OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,16,','),  --cCodProvRes
                                                                     cCodDistRes,                                       --cCodDistRes       
                                                                     cCodCorrRes,                                       --cCodCorrRes
                                                                     OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,18,','),  --cCodPosRes
                                                                     OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,16,','),  --cCodColonia
                                                                     OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,20,','),  --cTelRes
                                                                     OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,21,','),  --cEmail
                                                                     OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,19,',')); --cLadaTelRes
                        IF LENGTH(CRFC) = 13 THEN
                            cTipPersona := 'FISICA';
                        ELSE
                            cTipPersona := 'MORAL';
                        END IF;                                                                     
                        UPDATE PERSONA_NATURAL_JURIDICA J SET J.TIPO_PERSONA = cTipPersona,
                                                              J.TIPO_ID_TRIBUTARIA = 'RFC',
                                                              J.NUM_TRIBUTARIO     = nvl(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,10,','), 'XAXX010101000')
                        WHERE  J.TIPO_DOC_IDENTIFICACION = 'RFC'
                          AND  J.NUM_DOC_IDENTIFICACION = CRFC;
                    END IF;
                    --
                    IF OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,1,',') = 'C' AND nIdePol = 1 AND nIdPoliza IS NULL AND OC_MEDIOS_DE_COBRO.EXISTE_MEDIO_DE_COBRO(cTipoDocIdentAseg, cNumDocIdentAseg, 1) = 'N' THEN
                        OC_MEDIOS_DE_COBRO.INSERTAR(cTipoDocIdentAseg, cNumDocIdentAseg, 1, 'S', 'CTC');
                        UPDATE  MEDIOS_DE_COBRO MD SET MD.CODFORMACOBRO     = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,22,','),
                                                       MD.CODENTIDADFINAN   = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,23,','),
                                                       MD.NUMCUENTABANCARIA = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,24,','),
                                                       MD.NUMCUENTACLABE    = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,25,','),
                                                       MD.NUMTARJETA        = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,26,','),
                                                       MD.FECHAVENCTARJETA  = TO_DATE(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,27,','), 'DD/MM/YYYY'),
                                                       MD.NOMBRETITULAR     = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,28,',')
                        WHERE MD.TIPO_DOC_IDENTIFICACION = cTipoDocIdentAseg
                          AND MD.NUM_DOC_IDENTIFICACION = cNumDocIdentAseg;
                    END IF;
                    --
                    IF nIdPoliza IS NULL and OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,1,',') = 'C'  THEN
                        --
                        IF nvl(nCodCliente, 0) = 0 THEN
                           nCodCliente    := OC_CLIENTES.INSERTAR_CLIENTE(cTipoDocIdentAseg,cNumDocIdentAseg);
                           UPDATE CLIENTES CTE SET TIPOCLIENTE = 'BAJO'
                                  WHERE CTE.CODCLIENTE = nCodCliente;
                        END IF;      
                    ELSE 
                        IF nIdPoliza IS NULL AND OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,1,',') = 'A'  THEN                        
                            nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
                            IF nCod_Asegurado = 0 THEN
                               nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
                            END IF;                                      
                            --                 
                            nIdPoliza := gt_cotizaciones.CREAR_POLIZA(nCodCia,nCodEmpresa, nIdCotizacion, nCodCliente, nCod_Asegurado);
                            --   

                            SELECT C.NUMCOTIZACIONANT
                              INTO wIdCotizacion
                              FROM COTIZACIONES C
                             WHERE C.CODCIA = nCodCia AND C.CODEMPRESA = nCodEmpresa
                               AND C.IDCOTIZACION IN (SELECT P.NUM_COTIZACION 
                                                         FROM POLIZAS P 
                                                        WHERE P.CODCIA = nCodCia 
                                                          AND P.CODEMPRESA = nCodEmpresa 
                                                          AND P.IDPOLIZA = nIdPoliza);
                            --
                           --cNUMPOLUNICO := OC_POLIZAS.NUMERO_UNICO(NCODCIA, NIDPOLIZA);

                              BEGIN
--                                    SELECT NUMPOLUNICO, NUMPOLUNICO, P.COD_MONEDA
--                                      INTO  cNUMPOLUNICO, cNUMPOLUNICO, cCodMoneda
                                    SELECT P.COD_MONEDA
                                      INTO cCodMoneda
                                      FROM POLIZAS P
                                     WHERE P.CODCIA      = nCodCia
                                       AND P.CODEMPRESA  = nCodEmpresa
                                       AND P.IdPoliza    = nIdPoliza;
                                  --
                                  SELECT COUNT(*)
                                    INTO nCantPol
                                    FROM POLIZAS
                                   WHERE CodCia       = nCodCia
                                     AND NumPolUnico  = cNumPolUnico
                                     AND StsPoliza   IN ('EMI','SOL')
                                     AND IdPoliza    != nIdPoliza;
                                     
--                                  IF nCantPol > 0 THEN
--                                     cNUMPOLUNICO := SUBSTR(cNumPolUnico || '-' || NIDPOLIZA, 1, 30);
--                                  END IF;

                                  BEGIN
                                        SELECT CODVALOR
                                          INTO cCodValor
                                          FROM VALORES_DE_LISTAS
                                          WHERE CODLISTA = 'AGRUPA'
                                            AND DESCVALLST = 'PLATAFORMA DIGITAL THONAPI'; 
                                  EXCEPTION WHEN NO_DATA_FOUND THEN
                                        SELECT TRIM(TO_CHAR(TO_NUMBER(MAX(CODVALOR)) + 1, '0000'))
                                          INTO cCodValor
                                          FROM VALORES_DE_LISTAS
                                         WHERE CODLISTA = 'AGRUPA';
                                        INSERT INTO VALORES_DE_LISTAS VALUES ('AGRUPA', cCodValor, 'PLATAFORMA DIGITAL THONAPI');
                                  END;
   
                                  BEGIN
                                    SELECT codvalor
                                      INTO cTIPORIESGO
                                      FROM valores_de_listas 
                                     WHERE codlista = 'TIPRIESG'
                                       AND DESCVALLST IN (SELECT distinct 'RIESGO ' || RIESGOTARIFA 
                                                            FROM COTIZACIONES_DETALLE d 
                                                           WHERE  D.CODCIA = nCodCia 
                                                             AND D.CODEMPRESA = nCodEmpresa 
                                                             AND D.IDCOTIZACION IN (wIdCotizacion));                                  
                                  EXCEPTION WHEN OTHERS THEN
                                        cTIPORIESGO := null;
                                  END;

                                --------------------------------- Comisiones esta dividido en dos etapas, una esta la creacion de la poliza y otra al emitir la poliza
                                IF NVL(wIdCotizacion, 0) <> 0 THEN                                                                               
                                        --Copia Comisiones por nivel a la nueva poliza
                                        SELECT C.PorcComisDir,
                                               c.PorcComisProm,
                                               c.PorcComisAgte                                                       
                                          INTO wPorcComis1, wPorcComis2, wPorcComis3
                                          FROM COTIZACIONES C
                                         WHERE C.CODCIA          =   nCodCia
                                           AND C.CODEMPRESA      =   nCodEmpresa
                                           AND C.IDCOTIZACION    =   wIdCotizacion;
                                        --
                                        wPorcComisTot := 0;
                                        FOR COM IN (
                                            SELECT A.CODNIVEL  
                                              FROM AGENTES_DISTRIBUCION_POLIZA A
                                             WHERE A.CODCIA      = nCodCia
                                               AND A.IDPOLIZA    = nIdPoliza) LOOP
                                                       
                                               IF COM.CODNIVEL = 1 THEN
                                                    wPorcComisTot := wPorcComisTot + wPorcComis1;
                                               ELSIF COM.CODNIVEL = 2 THEN
                                                    wPorcComisTot := wPorcComisTot + wPorcComis2;                                                       
                                               ELSIF COM.CODNIVEL = 3 THEN
                                                    wPorcComisTot := wPorcComisTot + wPorcComis3;
                                               END IF;                                                
                                        END LOOP;
                                END IF;                                                      
                                                                    
                                --UPDATE POLIZAS P SET NUMPOLUNICO = cNUMPOLUNICO,
                                UPDATE POLIZAS P SET P.HORAVIGINI   = '12:00',
                                                      P.HORAVIGFIN   = '12:00',
                                                      P.TIPODIVIDENDO = '003',
                                                      P.IDFORMACOBRO = 1,
                                                      P.CODAGRUPADOR = cCodValor,
                                                      P.TIPORIESGO   = cTIPORIESGO,
                                                      P.CODPLANPAGO = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,32,','),
                                                      P.PORCCOMIS   = NVL(wPorcComisTot, 0)
                                 WHERE P.CODCIA      = nCodCia
                                   AND P.CODEMPRESA  = nCodEmpresa
                                   AND P.IDPOLIZA    = nIdPoliza;
                                   
                                UPDATE DETALLE_POLIZA P SET P.CODPLANPAGO = OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,32,','),
                                                                P.CODCATEGORIA = NULL
                                 WHERE P.CODCIA      = nCodCia
                                   AND P.CODEMPRESA  = nCodEmpresa
                                   AND P.IDPOLIZA    = nIdPoliza;                               
                                   
                              EXCEPTION WHEN OTHERS THEN
                                NULL;
                              END;
                              --
                              GT_COTIZACIONES_COBERT_ASEG.CREAR_COBERTURAS(nCodCia,nCodEmpresa, nIdCotizacion, nIdePol, nIdPoliza, nIdePol, nCod_Asegurado, R_NUMREG.ESCOLECTIVA);
                              --       
                        ELSIF nIdPoliza IS NOT NULL AND OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,1,',') = 'A' THEN
                            nCod_Asegurado := OC_ASEGURADO.CODIGO_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
                            IF nCod_Asegurado = 0 THEN
                                nCod_Asegurado := OC_ASEGURADO.INSERTAR_ASEGURADO(nCodCia, nCodEmpresa, cTipoDocIdentAseg, cNumDocIdentAseg);
                            END IF;     
                            --      
                            nIdePol := nIdePol + 1;
                            GT_COTIZACIONES_COBERT_ASEG.CREAR_COBERTURAS(nCodCia,nCodEmpresa, nIdCotizacion, nIdePol, nIdPoliza, nIdePol, nCod_Asegurado, R_NUMREG.ESCOLECTIVA);
                            UPDATE DETALLE_POLIZA D SET D.COD_ASEGURADO = nCod_Asegurado
                             WHERE D.CODCIA        =   nCodCia
                               AND D.CODEMPRESA    =   nCodEmpresa
                               AND D.IDPOLIZA      =   nIdPoliza
                               AND D.IDETPOL       = nIdePol;
                        END IF;                    
                                     
                    END IF;        
                    --           
                    numBenef := 0;            
                    IF OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,1,',') = 'A' THEN
                        FOR N IN 1..10 LOOP
                            numBenef := (6 * (N -1)); 
                            IF LENGTH(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,40 + numBenef,',')) > 0 THEN
                                begin
                                    dBenefFecNAc := to_date(OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,41+numBenef,','), 'dd/mm/yyyy');
                                exception when others then null; end;
                                OC_BENEFICIARIO.INSERTA_BENEFICIARIO(nIdPoliza, nIdePol, nCod_Asegurado, 
                                                                                        OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,39 + numBenef,','),
                                                                                        OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,40 + numBenef,','), 
                                                                                        OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,42 + numBenef,','), 
                                                                                        OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,43 + numBenef,','), 'N', 
                                                                                        dBenefFecNac, 
                                                                                        OC_PROCESOS_MASIVOS.VALOR_CAMPO(ENT.FILA,44 + numBenef,','));
                            ELSE
                                EXIT;
                            END IF;
                        END LOOP;
                    END IF;          
                                          
                END LOOP;                    
                --             
                IF R_NUMREG.ESCOLECTIVA = 'N' AND nIdPoliza IS NOT NULL THEN
                    UPDATE DETALLE_POLIZA D SET CODFILIAL  = NULL
                      WHERE D.CODCIA        =   nCodCia
                        AND D.CODEMPRESA    =   nCodEmpresa
                        AND D.IDPOLIZA       =   nIdPoliza;
                END IF;                                          
                --   
                --------------------------------- comisiones     
                DECLARE
                    WCODNIVEL number :=0;
                    WPORPRO number :=0;
                    WPORDIST number :=0;                    
                 BEGIN            

--                          FOR R IN (SELECT D.CODNIVEL,
--                                           PorcComis * (PORC_COM_DISTRIBUIDA + CAL_DIST/NOAGENT)   / 100                                   PORDIST,
--                                           PORC_COM_PROPORCIONAL - (PORC_COM_PROPORCIONAL  /( PROPOR/(CAL_PROPOR*sign(CAL_PROPOR))*10)*10) PORPRO,                            
--                                           PorcComis
--                                      FROM AGENTES_DISTRIBUCION_POLIZA D,  
--                                        (                            
--                                        SELECT SUM(D.PORC_COM_DISTRIBUIDA)   DIST,
--                                               SUM(D.PORC_COM_PROPORCIONAL)   PROPOR,
--                                               100 - SUM(D.PORC_COM_DISTRIBUIDA)   CAL_DIST,
--                                               100 - SUM( D.PORC_COM_PROPORCIONAL)  CAL_PROPOR,
--                                               COUNT(*) NOAGENT,
--                                               MAX((SELECT  max(D.PorcComis) FROM DETALLE_POLIZA D WHERE D.CodCia        = nCodCia AND D.IdPoliza      = nIdPoliza)) PorcComis                                       
--                                        FROM AGENTES_DISTRIBUCION_POLIZA D 
--                                        WHERE IdPoliza = nIdPoliza
--                                         AND CodCia   = nCodCia                             
--                                         ) T  
--                                    WHERE IdPoliza = nIdPoliza
--                                     AND CodCia   = nCodCia) LOOP
--                                     
--                                    UPDATE AGENTES_DISTRIBUCION_POLIZA SET Porc_Com_Proporcional = ROUND(R.PORPRO, 6),
--                                                                           Porc_Com_Distribuida  = ROUND( R.PORDIST, 6)
--                                    WHERE IdPoliza = nIdPoliza
--                                      AND CODNIVEL = R.CODNIVEL
--                                     AND CodCia   = nCodCia;
--                                     
--                                     nPorcComis := R.PorcComis;
--                                     WCODNIVEL  := R.CODNIVEL;
--                          END LOOP;                   
--
--                          SELECT SUM(A.PORC_COM_DISTRIBUIDA) 
--                            INTO nTotPorcComis
--                            FROM AGENTES_DISTRIBUCION_POLIZA A      
--                           WHERE CodCia        = nCodCia
--                             AND IdPoliza      = nIdPoliza;
--                            
--                          nTotPorcComis := nPorcComis - nTotPorcComis;
--                            
--                          UPDATE AGENTES_DISTRIBUCION_POLIZA SET PORC_COM_DISTRIBUIDA = PORC_COM_DISTRIBUIDA + nTotPorcComis
--                           WHERE CodCia        = nCodCia
--                             AND IdPoliza      = nIdPoliza
--                             AND CODNIVEL = WCODNIVEL;                        
--                          
-------------------------------------------------------------

                        UPDATE AGENTES_DISTRIBUCION_POLIZA SET  Porc_Com_Distribuida  = wPorcComis1,
                                                                Porc_Com_Proporcional = TRUNC(ROUND((wPorcComis1 * 100) / wPorcComisTot, 2), 2), 
                                                                  PORC_COM_POLIZA       = wPorcComisTot
                        WHERE IdPoliza = nIdPoliza
                          AND CODNIVEL = 1
                          AND CodCia   = nCodCia;
                        IF SQL%ROWCOUNT > 0 THEN
                           wPorcComPropT := wPorcComPropT + TRUNC(ROUND((wPorcComis1 * 100) / wPorcComisTot, 2), 2); 
                        END IF;

                        UPDATE AGENTES_DISTRIBUCION_POLIZA SET  Porc_Com_Distribuida  = wPorcComis2,
                                                                Porc_Com_Proporcional = TRUNC(ROUND((wPorcComis2 * 100) / wPorcComisTot, 2), 2), 
                                                                  PORC_COM_POLIZA       = wPorcComisTot
                        WHERE IdPoliza = nIdPoliza
                          AND CODNIVEL = 2
                          AND CodCia   = nCodCia;
                        IF SQL%ROWCOUNT > 0 THEN
                           wPorcComPropT := wPorcComPropT + TRUNC(ROUND((wPorcComis2 * 100) / wPorcComisTot, 2), 2); 
                        END IF;

                        IF wPorcComisTot = 0 THEN wPorcComisTot := 1; END IF;
                        IF wPorcComis3 = 0 THEN wPorcComis3 := 1;     END IF;

                        UPDATE AGENTES_DISTRIBUCION_POLIZA SET  Porc_Com_Distribuida  = wPorcComis3,
                                                                Porc_Com_Proporcional = TRUNC(ROUND((wPorcComis3 * 100) / wPorcComisTot, 2), 2), 
                                                                  PORC_COM_POLIZA       = wPorcComisTot
                        WHERE IdPoliza = nIdPoliza
                          AND CODNIVEL = 3
                          AND CodCia   = nCodCia;
                        IF SQL%ROWCOUNT > 0 THEN
                           wPorcComPropT := wPorcComPropT + TRUNC(ROUND((wPorcComis3 * 100) / wPorcComisTot, 2), 2); 
                        END IF;

                        UPDATE AGENTES_DISTRIBUCION_POLIZA SET  Porc_Com_Proporcional = Porc_Com_Proporcional + (100 - wPorcComPropT)  
                        WHERE IdPoliza = nIdPoliza
                          AND CODNIVEL = 3
                          AND CodCia   = nCodCia;
                        
                        DELETE AGENTES_DISTRIBUCION_COMISION
                         WHERE CodCia   = nCodCia
                          AND IdPoliza = nIdPoliza;

                        DELETE AGENTES_DETALLES_POLIZAS
                         WHERE CodCia   = nCodCia
                          AND IdPoliza = nIdPoliza;

                        UPDATE DETALLE_POLIZA D SET D.PORCCOMIS = wPorcComisTot
                        WHERE D.CODCIA = nCodCia
                          AND D.CODEMPRESA = nCodEmpresa
                          and D.IDPOLIZA   = nIdPoliza;
                          
                        OC_AGENTES_DISTRIBUCION_POLIZA.COPIAR(nCodCia, nIdPoliza); 
                        
                END;                  
                BEGIN
                       FOR W IN DETPOL_Q LOOP
                          OC_DETALLE_POLIZA.ACTUALIZA_VALORES(W.CODCIA, W.IDPOLIZA, W.IDETPOL, 0);
                          OC_ASISTENCIAS_DETALLE_POLIZA.CARGAR_ASISTENCIAS(W.CODCIA, W.CodEmpresa, W.IDTIPOSEG , W.PLANCOB,  W.IDPOLIZA, W.IDETPOL, W.TASA_CAMBIO, cCodMoneda, W.FECINIVIG, W.FECFINVIG);
                          OC_ASISTENCIAS_DETALLE_POLIZA.EMITIR(W.CODCIA, W.CodEmpresa, W.IDPOLIZA, W.IDETPOL, 0);
                       END LOOP;
                EXCEPTION WHEN OTHERS THEN
                    NULL;
                END;             
        END IF;                        
            --
            IF cIdPoliza IS NOT NULL THEN
                nIdPoliza := cIdPoliza;
            END IF;
            
            BEGIN                                       
               OC_POLIZAS.EMITIR_POLIZA(nCodCia, nIdPoliza, nCodEmpresa);
            EXCEPTION
               WHEN OTHERS THEN
                  IF OC_POLIZAS.BLOQUEADA_PLD(nCodCia, nCodEmpresa, nIdPoliza) = 'S' THEN
                     DECLARE
                        CURSOR PLD_Q IS
                        SELECT XMLElement("FACTURA", XMLATTRIBUTES("IDPOLIZA", "CODIGO","DESCRIPCION")
                                         ) XMLPld
                          FROM (SELECT nIdPoliza IDPOLIZA, 'PLD' CODIGO,'LA POLIZA HA SIDO ENVIADA A PLD PARA SU VALIDACION' DESCRIPCION FROM DUAL);
                        R_Pld PLD_Q%ROWTYPE; 
                     BEGIN
                        cFacturas := '<?xml version="1.0" encoding="UTF-8" ?><FACTURAS>';
                        OPEN PLD_Q;
                        LOOP
                            FETCH PLD_Q INTO   R_Pld;   
                            EXIT WHEN PLD_Q%NOTFOUND;
                            cFacturas :=  cFacturas || R_Pld.XMLPld.getclobval();
                        END LOOP;               
                        CLOSE PLD_Q;   
                        cFacturas :=  cFacturas || '</FACTURAS>';
                        RETURN cFacturas;
                     END;
                  END IF;
            END;
            --
            OC_POLIZAS.INSERTA_CLAUSULAS(nCodCia,nCodEmpresa, nIdPoliza);              

            -------PRE EMISION
            OPEN Q_TRAN(nIdPoliza);
            FETCH Q_TRAN INTO R_TRAN;
            nIdTransaccion :=  TO_NUMBER(R_TRAN.IdTransaccion);     
            close Q_TRAN;                       
            OC_POLIZAS.PRE_EMITE_POLIZA(nCodCia, nCodEmpresa, nIdPoliza, nIdTransaccion);
            ----------------
            
            cFacturas := GENERALES_PLATAFORMA_DIGITAL.CONSULTA_FACTURA(nCodCia, nIdPoliza);       
            --dbms_output.put_line(cFacturas);
            RETURN cFacturas;                          
    END PRE_EMITE_POLIZA_NEW; 
    --
    FUNCTION CONSULTA_FACTURA(nCodCia NUMBER, nIdPoliza NUMBER) RETURN CLOB IS
        CURSOR Q_FAC IS
        SELECT XMLELEMENT("FACTURA",  XMLATTRIBUTES("IDPOLIZA" , "IDETPOL",  
                         "IDFACTURA",  
                         "STSFACT",   
                         "FECANUL",   
                         "FECPAGO",   
                         "FECVENC",   
                         "NUMCUOTA",  
                         "COD_MONEDA", 
                         "MONTO_FACT_MONEDA",
                         "APORTEFONDO",
                         "PRIMANIVELADA",
                         "MONTOTOTAL",
                         "NUMREF",
                         "IDENDOSO")) DATOSXML ,
                          CODEMPRESA  ,     IDFACTURA            
              FROM (                                          
              select  F.IDPOLIZA , F.IDETPOL,  
                         IDFACTURA,  
                         STSFACT,   
                         F.FECANUL,   
                         FECPAGO,   
                         FECVENC,   
                         NUMCUOTA,  
                         COD_MONEDA, 
                         MONTO_FACT_MONEDA,
                         OC_DETALLE_POLIZA.MONTO_APORTE_FONDOS(F.CODCIA, 1, F.IDPOLIZA,  F.IDETPOL) APORTEFONDO,
                         GT_FAI_CONFIG_APORTE_FONDO_DET.MONTO_APORTE_ESPECIFICO(F.CODCIA, 1, F.IDPOLIZA, F.IDETPOL, D.COD_ASEGURADO  , GT_FAI_FONDOS_DETALLE_POLIZA.FONDO_PAGO_PRIMA(F.CODCIA, 1, F.IDPOLIZA, F.IDETPOL, D.COD_ASEGURADO), F.NUMCUOTA) PRIMANIVELADA,
                         GT_FAI_CONFIG_APORTE_FONDO_DET.MONTO_APORTE_ESPECIFICO(F.CODCIA, 1, F.IDPOLIZA, F.IDETPOL, D.COD_ASEGURADO  , GT_FAI_FONDOS_DETALLE_POLIZA.FONDO_PAGO_PRIMA(F.CODCIA, 1, F.IDPOLIZA, F.IDETPOL, D.COD_ASEGURADO), F.NUMCUOTA) + OC_DETALLE_POLIZA.MONTO_APORTE_FONDOS(F.CODCIA, 1, F.IDPOLIZA,  F.IDETPOL) + MONTO_FACT_MONEDA MONTOTOTAL, 
                         (SICAS_OC.OBTIENE_REFERENCIA(F.IDPOLIZA, F.IDFACTURA)) NUMREF,
                         IDENDOSO, D.CODEMPRESA                            
                from FACTURAS F inner join DETALLE_POLIZA D ON D.CODCIA = F.CODCIA  AND D.IDPOLIZA = F.IDPOLIZA AND  D.IDETPOL = F.IDETPOL 
             WHERE F.CODCIA  = nCodCia               
               AND F.IDPOLIZA= nIdPoliza
               ORDER BY IDFACTURA);                    
        R_FAC Q_FAC%ROWTYPE;              
        --
        CURSOR Q_ELEC (pCodCia number, pCodEmpresa number, pIdFactura number) IS
           SELECT   XMLELEMENT("CFDI",  XMLATTRIBUTES("IDTIMBRE" , "CODPROCESO",  
                                 "FECHAUUID",  
                                 "SERIE",   
                                 "CODRESPUESTASAT",   
                                 "STSTIMBRE",
                                 "UUID")   
                                 ) DATOSXML        
           FROM FACT_ELECT_DETALLE_TIMBRE d
           WHERE CODCIA = pCodCia
           AND CODEMPRESA = pCodEmpresa
           AND IDFACTURA = pIdFactura   
           AND CODRESPUESTASAT IN ('201','2001')
           AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_UUID_CANCELADO(D.CODCIA, D.CODEMPRESA, D.IDFACTURA, D.IDNCR, D.UUID) = 'N'
           ORDER BY IDTIMBRE;
        R_ELEC Q_ELEC%ROWTYPE;              
        --
        CATA CLOB;
        CELE CLOB;
        --
    BEGIN   
            CATA := '<?xml version="1.0" encoding="UTF-8" ?><FACTURAS>';
            OPEN Q_FAC;
            LOOP
                FETCH Q_FAC INTO   R_FAC;   
                EXIT WHEN Q_FAC%NOTFOUND;
                
                CATA :=  CATA || R_FAC.DATOSXML.getclobval();
                CELE :=  EMPTY_CLOB();
                OPEN Q_ELEC (nCodCia, R_FAC.CODEMPRESA, R_FAC.IDFACTURA);
                LOOP                                
                    FETCH Q_ELEC INTO R_ELEC;   
                    EXIT WHEN Q_ELEC%NOTFOUND;
                    CELE := CELE ||R_ELEC.DATOSXML.getclobval();                    
                END LOOP;                
                CLOSE Q_ELEC;
                CATA :=  REPLACE(CATA, '"></FACTURA>', '">' || CELE || '</FACTURA>');
            END LOOP;               
            CLOSE Q_FAC;   
            
            CATA :=  CATA || '</FACTURAS>';
            RETURN  CATA;  
            
    END CONSULTA_FACTURA;
    --
    FUNCTION PAGO_FACTURA (nIdPoliza NUMBER, nIdFactura NUMBER) RETURN BOOLEAN IS 
        nCobrar          NUMBER(1);
        nIdTransac       TRANSACCION.IdTransaccion%TYPE;
        nIdTransaccion   TRANSACCION.IdTransaccion%TYPE;
        nCodAsegurado    DETALLE_POLIZA.Cod_Asegurado%TYPE;
        nIdFondo         FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
        nPrimaNivelada   FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;
        nAporteFondo     DETALLE_POLIZA.MontoAporteFondo%TYPE;
        cEstatus         VARCHAR2(10);
        nCodCia          NUMBER := 1;
        nIDOPENPAY       NUMBER := 0;
        cStsPoliza       SICAS_OC.POLIZAS.Stspoliza%TYPE;       
        cCodCFDI         VARCHAR2(100);
        bTerminoOk       BOOLEAN := FALSE;

        CURSOR FACTCOB IS
            SELECT FAC.IdFactura,  POL.CodEmpresa, FAC.IndContabilizada,
                   FAC.Monto_Fact_Moneda, FAC.IdPoliza, FAC.IDetPol,FAC.NumCuota,
                   'EFEC' CodFormaPago,
                   '000'  CodEntidad,
                   POL.STSPOLIZA, 
                   O.IDOPENPAY, 
                   O.COD_MONEDA, 
                   O.MONTOPAGO_LOCAL, 
                   O.MONTOPAGO_MONEDA, 
                   0.NUMAPPROB_OPENPAY,
                   O.STSPAGO, 
                   O.REFERENCIA_THONA, 
                   O.REFERENCIA_OPENPAY, 
                   O.FECHAREG, 
                   O.FECHAPAG, 
                   O.FECHACT, 
                   O.USUARIO
              FROM FACTURAS FAC, POLIZAS POL,    OPENPAY_PAGOS O     
             WHERE FAC.CodCia     = POL.CodCia
               AND FAC.IdPoliza   = POL.IdPoliza
               AND POL.IDPOLIZA   = nIdPoliza
               AND FAC.IdFactura  = nIdFactura
               AND O.IdPoliza     = POL.IDPOLIZA
               AND O.IdFactura    = FAC.IdFactura
               AND O.STSPAGO = 'CargoAprob';                                

        CURSOR Q_FACTURAS IS
            SELECT F.IDFACTURA,
                   F.CODCIA,
                   1    CODEMPRESA,
                   'A'  TIPOCFDI,
                   'N'  IndRelaciona,
                   F.STSFACT
            FROM FACTURAS F
           WHERE F.IDPOLIZA     =  nIdPoliza
           ORDER BY F.IDFACTURA;
        R_FACTURAS Q_FACTURAS%ROWTYPE;          
                   
    BEGIN
    
       --dbms_OUTPUT.PUT_LINE('ESTATUS POLIZA: ' ||FC.STSPOLIZA);
       BEGIN
         SELECT StsPoliza
           INTO cStsPoliza
           FROM POLIZAS
          WHERE CodCia     = 1
            AND CodEmpresa = 1
            AND IdPoliza   = nIdPoliza;
       END;
       
              
       IF cStsPoliza =  'PRE' THEN
         OC_POLIZAS.LIBERA_PRE_EMITE(1, 1, nIdPoliza, trunc(sysdate));
         --         
         OPEN Q_FACTURAS;
         LOOP
                FETCH Q_FACTURAS INTO   R_FACTURAS;   
                EXIT WHEN Q_FACTURAS%NOTFOUND; 
                cCodCFDI := OC_FACTURAS.FACTURA_ELECTRONICA(R_FACTURAS.IDFACTURA, R_FACTURAS.CodCia, R_FACTURAS.CodEmpresa, R_FACTURAS.TipoCfdi, R_FACTURAS.IndRelaciona);
                --               
                dbms_output.put_line(R_FACTURAS.IDFACTURA || '-' || R_FACTURAS.STSFACT || '-' || cCodCFDI);  
                --
                IF OC_GENERALES.BUSCA_PARAMETRO(R_FACTURAS.CodCia, '026') = cCodCFDI THEN --201
                    NULL;
                END IF;
         END LOOP;
         --
         CLOSE Q_FACTURAS;
       END IF;
    
        BEGIN
            SELECT 1
              INTO nIDOPENPAY
            FROM OPENPAY_PAGOS O
            WHERE  O.IdPoliza = nIdPoliza
           AND O.IdFactura    = nIdFactura;
        EXCEPTION WHEN OTHERS THEN
            nIDOPENPAY := 0;            
        END;
        IF NVL(nIDOPENPAY, 0) = 0 THEN                
            BEGIN
                SELECT NVL(MAX(IDOPENPAY),0) + 1 
                  INTO nIDOPENPAY
                FROM OPENPAY_PAGOS O
                WHERE  O.IdPoliza = nIdPoliza
               AND O.IdFactura    = nIdFactura;
            EXCEPTION WHEN OTHERS THEN
                nIDOPENPAY := 1;
            END;
            INSERT INTO OPENPAY_PAGOS
            (IDOPENPAY, IDPOLIZA, IDFACTURA, COD_MONEDA, MONTOPAGO_LOCAL, MONTOPAGO_MONEDA, STSPAGO, REFERENCIA_THONA, REFERENCIA_OPENPAY, NUMAPPROB_OPENPAY) VALUES
            (nIDOPENPAY,nIdPoliza,nIdFactura, 'PS',0,0,'ENV', 'XXXXX', 'XXXX', 'NUMREF0001');            
        END IF;        
        

        FOR FC IN FACTCOB LOOP
            BEGIN
             SELECT D.Cod_Asegurado
               INTO nCodAsegurado
               FROM DETALLE_POLIZA D
              WHERE D.CodCia   = 1
                AND D.IdPoliza = FC.IdPoliza
                AND D.IDetPol  = FC.IDetPol;
            END;
              
            IF FC.IndContabilizada = 'N' THEN
                 nIdTransaccion := OC_TRANSACCION.CREA(1, FC.CodEmpresa, 14, 'CONFAC');
                 OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, 1, FC.CodEmpresa, 14, 'CONFAC',
                                             'FACTURAS', FC.IdPoliza, FC.IDetPol, NULL, FC.IdFactura, FC.Monto_Fact_Moneda);
                 UPDATE FACTURAS
                    SET IdTransacContab  = nIdTransaccion,
                        IndContabilizada = 'S',
                        FecContabilizada = TRUNC(SYSDATE)
                  WHERE IdFactura = FC.IdFactura;
                  OC_COMPROBANTES_CONTABLES.CONTABILIZAR(1, nIdTransaccion, 'C');
            END IF;

            nIdTransac := OC_TRANSACCION.CREA(1,  FC.CodEmpresa, 12, 'PAG');
              
            IF GT_FAI_FONDOS_DETALLE_POLIZA.EXISTEN_FONDOS(1, FC.CodEmpresa, FC.IdPoliza, FC.IDetPol, nCodAsegurado) = 'N' THEN
                nCobrar := OC_FACTURAS.PAGAR (FC.IdFactura, FC.NUMAPPROB_OPENPAY, SYSDATE, FC.MONTOPAGO_MONEDA, FC.CodFormaPago, FC.CodEntidad, nIdTransac);
            ELSE             
                nAporteFondo := OC_DETALLE_POLIZA.MONTO_APORTE_FONDOS(nCodCia, FC.CodEmpresa, FC.IdPoliza,  FC.IDetPol);             
                nIdFondo     := GT_FAI_FONDOS_DETALLE_POLIZA.FONDO_PAGO_PRIMA(nCodCia, FC.CodEmpresa, FC.IdPoliza, FC.IDetPol, nCodAsegurado);             
                IF NVL(nIdFondo,0) > 0 THEN
                    nPrimaNivelada := GT_FAI_CONFIG_APORTE_FONDO_DET.MONTO_APORTE_ESPECIFICO(nCodCia, FC.CodEmpresa, FC.IdPoliza, FC.IDetPol, nCodAsegurado, nIdFondo, FC.NumCuota);
                ELSE
                    nPrimaNivelada := 0;
                END IF;
                nCobrar := OC_FACTURAS.PAGAR_FONDOS(FC.IdFactura, FC.NUMAPPROB_OPENPAY, SYSDATE, FC.Monto_Fact_Moneda, FC.CodFormaPago, FC.CodEntidad, nIdTransac, nPrimaNivelada, nAporteFondo);
            END IF;
              
            IF nCobrar = 1 THEN
                bTerminoOk := TRUE;
                UPDATE PAGOS P SET P.MONEDA = FC.COD_MONEDA, 
                                   P.NUM_RECIBO_REF = FC.NUMAPPROB_OPENPAY
                WHERE   P.CODCIA = nCodCia
                   AND  P.CODEMPRESA = 1
                   AND  P.IDFACTURA  = FC.IdFactura
                   AND P.IDTRANSACCION = nIdTransac;
                                                
                 UPDATE FACTURAS
                    SET FecSts         = TRUNC(SYSDATE),
                        IndDomiciliado = NULL
                  WHERE CodCia    = 1
                    AND IdFactura = FC.IdFactura;

                 OC_COMPROBANTES_CONTABLES.CONTABILIZAR(1, nIdTransac, 'C');
                 
                 cCodCFDI := OC_FACTURAS.FACTURA_ELECTRONICA(FC.IDFACTURA, 1, 1, 'A', 'S');
                --               
                IF OC_GENERALES.BUSCA_PARAMETRO(R_FACTURAS.CodCia, '026') = cCodCFDI THEN --201
                    NULL;
                END IF;
                 
            END IF;
              
       END LOOP;                                 
       RETURN bTerminoOk ;                      
    END PAGO_FACTURA;       
    --
    FUNCTION CONSULTA_COT_PAGO_FRACCIONARIO(nCodCia NUMBER, nIdCotizacion NUMBER) RETURN CLOB IS
        --
         CURSOR Q_FAC IS
            SELECT XMLELEMENT("FRACCIONADO",  XMLATTRIBUTES("IDCOTIZACION" , "FRACCION_PAGO",  
                             "PORCENTAJE",  
                             "PRIMER_RECIBO",   
                             "RECIBOS_SUBSECUENTES",   
                             "NUMPAGOS",
                             "TOTAL")) DATOSXML    
          FROM (
            SELECT 
                   C.IDCOTIZACION,
                   DECODE(CPP_DER.CODPLANPAGO,'ANUA','ANUAL'
                                             ,'SEM','SEMESTRAL'
                                             ,'TRIM','TRIMESTRAL'
                                             ,'MENS','MENSUAL'
                                             ,'OTRO') FRACCION_PAGO,
                   DECODE(NVL(CPP_REC.CODPLANPAGO,'0'),'0','0',CPP_REC.PORCCPTO)              PORCENTAJE,
                   TO_NUMBER(DECODE(NVL(CPP_REC.CODPLANPAGO,'0'),'0',TO_CHAR(NVL(C.PRIMACOTLOCAL,0) + NVL(CCR.MONTOCONCEPTO,0)), --ANUAL
                   ROUND((C.PRIMACOTLOCAL/PP.NUMPAGOS +                             --PMA NETA
                         (C.PRIMACOTLOCAL/PP.NUMPAGOS * (CPP_REC.PORCCPTO/100)) +   --REC X PAGO FRACCIONADO
                         NVL(CCR.MONTOCONCEPTO,0))                                  --DEREMI
                         ,2)
                         ) )        PRIMER_RECIBO,
                   TO_NUMBER(DECODE(NVL(CPP_REC.CODPLANPAGO,'0'),'0','0',           --ANUAL
                   ROUND((C.PRIMACOTLOCAL/PP.NUMPAGOS +                             --PMA NETA
                          (C.PRIMACOTLOCAL/PP.NUMPAGOS * (CPP_REC.PORCCPTO/100)))   --REC X PAGO FRACCIONADO
                         ,2) ) )    RECIBOS_SUBSECUENTES,
                   PP.NUMPAGOS,
                   TO_NUMBER(DECODE(NVL(CPP_REC.CODPLANPAGO,'0'),'0',TO_CHAR(NVL(C.PRIMACOTLOCAL,0) + NVL(CCR.MONTOCONCEPTO,0)),  --ANUAL
                   ROUND((C.PRIMACOTLOCAL +                            --PMA NETA
                         (C.PRIMACOTLOCAL * (CPP_REC.PORCCPTO/100)) +  --REC X PAGO FRACCIONADO
                         NVL(CCR.MONTOCONCEPTO,0))                     --DEREMI
                         ,2)
                         ) )        TOTAL
              FROM COTIZACIONES C,
                   PLAN_DE_PAGOS PP,
                   CONCEPTOS_PLAN_DE_PAGOS CPP_DER,
                   CONCEPTOS_PLAN_DE_PAGOS CPP_REC,
                   CATALOGO_CONCEPTOS_RANGOS CCR   -- COLOCAR SI EL DERECHO SE OBTIENE POR CATALOGO
             WHERE C.CODCIA       = nCodCia
               AND C.CODEMPRESA   = 1
               AND C.IDCOTIZACION = nIdCotizacion
               --
               AND PP.CODPLANPAGO = CPP_DER.CODPLANPAGO
               --
               AND CPP_DER.CODCPTO(+)     = 'DEREMI'
               AND CPP_DER.CODPLANPAGO(+) IN ('ANUA','SEM','TRIM','MENS')   
               --
               AND CPP_REC.CODCPTO(+)     = 'RECFIN'
               AND CPP_REC.CODPLANPAGO(+) = CPP_DER.CODPLANPAGO 
               -- 
               AND CCR.CODCIA(+)       = C.CODCIA
               AND CCR.CODEMPRESA(+)   = C.CODEMPRESA
               AND CCR.CODCONCEPTO(+)  = 'DEREMI'
               AND CCR.IDTIPOSEG(+)    = C.IDTIPOSEG
               AND CCR.CODTIPORANGO(+) = 'MTOPRI'
               AND CCR.CODMONEDA(+)    = C.COD_MONEDA
               AND C.PRIMACOTLOCAL     BETWEEN CCR.RANGOINICIAL(+) AND CCR.RANGOFINAL(+))
            ORDER BY NUMPAGOS;     
               
        R_FAC Q_FAC%ROWTYPE;              
        --
        CATA CLOB;
        --
    BEGIN   
            CATA := '<?xml version="1.0" encoding="UTF-8" ?><FRACCION_PAGO>';
            OPEN Q_FAC;
            LOOP
                FETCH Q_FAC INTO   R_FAC;   
                EXIT WHEN Q_FAC%NOTFOUND;
                CATA :=  CATA || R_FAC.DATOSXML.getclobval();
            END LOOP;               
            CLOSE Q_FAC;   
            
            CATA :=  CATA || '</FRACCION_PAGO>';
            RETURN  CATA;  
    END CONSULTA_COT_PAGO_FRACCIONARIO;
    --                                                                                               
    FUNCTION CONSULTA_CODIGO_POSTAL(pCatalogo NUMBER := 0, pCODPOSTAL VARCHAR2, pCODPAIS VARCHAR2, pCODESTADO VARCHAR2, pCODMUNICIPIO VARCHAR2, pCODIGO_COLONIA VARCHAR2) RETURN CLOB IS
            --
             CURSOR Q_FAC IS
                SELECT XMLELEMENT("CODIGOPOSTAL",  XMLATTRIBUTES("CODIGO_POSTAL" , 
                                                                 "CODPAIS",  
                                                                 "DESCPAIS",  
                                                                 "CODESTADO",   
                                                                 "DESCESTADO",   
                                                                 "CODMUNICIPIO",
                                                                 "DESCMUNICIPIO",
                                                                 "CODIGO_COLONIA",
                                                                 "DESCRIPCION_COLONIA")) DATOSXML    
                FROM (  SELECT DISTINCT 
                               DECODE(pCatalogo, 1, NULL, CP.CODIGO_POSTAL)                                                             CODIGO_POSTAL,
                               DECODE(pCatalogo, 1, DECODE(pCODPAIS, '%',        PA.CODPAIS, NULL), PA.CODPAIS)                         CODPAIS,
                               DECODE(pCatalogo, 1, DECODE(pCODPAIS, '%',        PA.DESCPAIS, NULL), PA.DESCPAIS)                       DESCPAIS,  
                               DECODE(pCatalogo, 1, DECODE(pCODESTADO, '%',      P.CODESTADO, NULL), P.CODESTADO)                       CODESTADO,
                               DECODE(pCatalogo, 1, DECODE(pCODESTADO, '%',      P.DESCESTADO, NULL), P.DESCESTADO)                     DESCESTADO,
                               DECODE(pCatalogo, 1, DECODE(pCODMUNICIPIO, '%',   M.CODMUNICIPIO, NULL), M.CODMUNICIPIO)                 CODMUNICIPIO,       
                               DECODE(pCatalogo, 1, DECODE(pCODMUNICIPIO, '%',   M.DESCMUNICIPIO, NULL), M.DESCMUNICIPIO)               DESCMUNICIPIO,
                               DECODE(pCatalogo, 1, DECODE(pCODIGO_COLONIA, '%', C.CODIGO_COLONIA, NULL), C.CODIGO_COLONIA)             CODIGO_COLONIA,
                               DECODE(pCatalogo, 1, DECODE(pCODIGO_COLONIA, '%', C.DESCRIPCION_COLONIA, NULL), C.DESCRIPCION_COLONIA)   DESCRIPCION_COLONIA       
                          FROM SICAS_OC.APARTADO_POSTAL CP INNER JOIN SICAS_OC.CORREGIMIENTO M ON M.CODMUNICIPIO = CP.CODMUNICIPIO AND M.CODPAIS = CP.CODPAIS AND M.CODESTADO = CP.CODESTADO AND M.CODCIUDAD = CP.CODCIUDAD 
                                                           INNER JOIN SICAS_OC.COLONIA       C ON C.CODPAIS = CP.CODPAIS AND C.CODESTADO = CP.CODESTADO AND C.CODCIUDAD = CP.CODCIUDAD AND C.CODMUNICIPIO = M.CODMUNICIPIO AND C.CODIGO_POSTAL = CP.CODIGO_POSTAL
                                                           INNER JOIN SICAS_OC.PROVINCIA     P ON P.CODPAIS = CP.CODPAIS AND P.CODESTADO = CP.CODESTADO 
                                                           INNER JOIN SICAS_OC.PAIS          PA ON PA.CODPAIS = CP.CODPAIS                                   
                        WHERE CP.CODIGO_POSTAL      =    DECODE(pCODPOSTAL,                                                                                   NULL, CP.CODIGO_POSTAL,     pCODPOSTAL)
                          AND CP.CODPAIS            =    DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODPAIS),         1, pCODPAIS, null),        NULL, CP.CODPAIS,           pCODPAIS)
                          AND CP.CODESTADO          =    DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODESTADO),       1, pCODESTADO, null),      NULL, CP.CODESTADO,         pCODESTADO)
                          AND CP.CODMUNICIPIO       =    DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODMUNICIPIO),    1, pCODMUNICIPIO, null),   NULL, CP.CODMUNICIPIO,      pCODMUNICIPIO)
                          AND C.CODIGO_COLONIA      =    DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODIGO_COLONIA),  1, pCODIGO_COLONIA, null), NULL, C.CODIGO_COLONIA,     pCODIGO_COLONIA)
                          AND PA.DESCPAIS           LIKE DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODPAIS),         1, NULL, pCODPAIS),        NULL, PA.DESCPAIS,          pCODPAIS)
                          AND P.DESCESTADO          LIKE DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODESTADO),       1, NULL, pCODESTADO),      NULL, P.DESCESTADO,         pCODESTADO)
                          AND M.DESCMUNICIPIO       LIKE DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODMUNICIPIO),    1, NULL, pCODMUNICIPIO),   NULL, M.DESCMUNICIPIO,      pCODMUNICIPIO)
                          AND C.DESCRIPCION_COLONIA LIKE DECODE(DECODE(GENERALES_PLATAFORMA_DIGITAL.ES_NUMERICO(pCODIGO_COLONIA),  1, NULL, pCODIGO_COLONIA), NULL, C.DESCRIPCION_COLONIA,pCODIGO_COLONIA)  
                        ORDER BY DESCPAIS, DESCESTADO, DESCMUNICIPIO, DESCRIPCION_COLONIA)  ;                                 
                   
            R_FAC Q_FAC%ROWTYPE;              
            --
            CATA CLOB;
            --
    BEGIN   
                CATA := '<?xml version="1.0" encoding="UTF-8" ?><CODIGOS_POSTALES>';
                OPEN Q_FAC;
                LOOP
                    FETCH Q_FAC INTO   R_FAC;   
                    EXIT WHEN Q_FAC%NOTFOUND;
                    CATA :=  CATA || R_FAC.DATOSXML.getclobval();
                END LOOP;               
                CLOSE Q_FAC;   
                
                CATA :=  CATA || '</CODIGOS_POSTALES>';
                RETURN  CATA;  
    END CONSULTA_CODIGO_POSTAL;
    --
    FUNCTION CATALOGO_GENERAL(pCodLista VARCHAR2 := 'FORMPAGO', pCodValor VARCHAR2) RETURN CLOB IS
        CURSOR Q_CAT IS
      SELECT  XMLELEMENT("CODLISTA",  XMLATTRIBUTES("CODVALOR", 
                                                    "DESCVALLST")) DATOSXML ,
              DESCLISTA DESCLISTA
        FROM (                            
          SELECT T.DESCLISTA,  
                 V.CODVALOR,   
                 V.DESCVALLST                                                      
            FROM TIPO_DE_LISTA T INNER JOIN VALORES_DE_LISTAS V ON T.CODLISTA = V.CODLISTA 
           WHERE T.CODLISTA = DECODE(pCodLista, 'FRECPAGOS', 'XXXX', pCodLista)  
             AND V.CODVALOR = DECODE(UPPER(pCODVALOR), null, CODVALOR, UPPER(pCODVALOR))  
        UNION ALL           
           SELECT 'PLAN_PAGOS'  DESCLISTA, 
                  CODPLANPAGO   CODVALOR, 
                  DESCPLAN      DESCVALLST
            FROM SICAS_OC.PLAN_DE_PAGOS PP             
            WHERE PP.STSPLAN = 'ACT'   
               AND CODPLANPAGO = DECODE(pCodLista, 'FRECPAGOS', DECODE(UPPER(pCODVALOR), null, CODPLANPAGO, UPPER(pCODVALOR)), pCodLista)  
            )
       ORDER BY DESCVALLST;
         R_CAT  Q_CAT%ROWTYPE;      
         --
         cHeader VARCHAR2(100);
         CATA CLOB;
         --
    BEGIN   
        
        OPEN Q_CAT;
        LOOP
            FETCH Q_CAT INTO   R_CAT;   
            EXIT WHEN Q_CAT%NOTFOUND;
            IF CATA IS NULL THEN
               cHeader := REPLACE(R_CAT.DESCLISTA, ' ', '_');
               CATA := '<?xml version="1.0" encoding="UTF-8" ?><'|| cHeader || '>';
            END IF; 
            CATA :=  CATA || R_CAT.DATOSXML.getclobval();
        END LOOP;               
        CLOSE Q_CAT;   
                        
        CATA :=  CATA || '</' || cHeader || '>';
        RETURN  CATA;      
    END CATALOGO_GENERAL;
   --                                                                                                     
    FUNCTION CATALOGO_ENTIDAD_FINANCIERA(pCodEntidad VARCHAR2) RETURN CLOB IS
        CURSOR Q_CAT IS
           SELECT XMLELEMENT("ENTIDAD",  XMLATTRIBUTES("CODENTIDAD", 
                                                      "NOMBRECOMERCIAL", 
                                                      "NOMBRE")) DATOSXML
             FROM (SELECT E.CODENTIDAD, 
                          REPLACE(INITCAP (P.NOMBRE), ' De ', ' de ')   NOMBRE,
                          UPPER(P.NOMBRECOMERCIAL)                      NOMBRECOMERCIAL
                    FROM ENTIDAD_FINANCIERA E INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA P ON P.TIPO_DOC_IDENTIFICACION = E.TIPO_DOC_IDENTIFICACION AND P.NUM_DOC_IDENTIFICACION = E.NUM_DOC_IDENTIFICACION
                   WHERE E.CODCIA = 1
                     AND E.CODENTIDAD = DECODE(pCodEntidad, NULL, CodEntidad, pCodEntidad)
                    ORDER BY P.NOMBRECOMERCIAL);
         R_CAT  Q_CAT%ROWTYPE;      
         --
         cHeader VARCHAR2(100);
         CATA CLOB;
         --
    BEGIN   
        CATA := '<?xml version="1.0" encoding="UTF-8" ?><ENTIDAD_FINANCIERA>';        
        OPEN Q_CAT;
        LOOP
            FETCH Q_CAT INTO   R_CAT;   
            EXIT WHEN Q_CAT%NOTFOUND;
            CATA :=  CATA || R_CAT.DATOSXML.getclobval();
        END LOOP;               
        CLOSE Q_CAT;   
                        
        CATA :=  CATA || '</ENTIDAD_FINANCIERA>';
        RETURN  CATA;      
    END CATALOGO_ENTIDAD_FINANCIERA;
   --                                                   
   PROCEDURE POLIZA_ANULA(pIDPoliza NUMBER, pMotivAnul VARCHAR2, pCod_Moneda VARCHAR2 := 'PS') AS
        pCodCia         NUMBER := 1;
        pCodEmpresa     NUMBER := 1; 
   BEGIN    
        OC_POLIZAS.ANULAR_POLIZA(pCodCia, pCodEmpresa, pIdPoliza, SYSDATE, pMotivAnul, pCod_Moneda, 'POLIZA');
   END POLIZA_ANULA;
   --
    FUNCTION MUESTRA_COTIZACIONES(pIDCOTIZACION NUMBER, pNombre VARCHAR2, pCodAgente NUMBER, pEstatus VARCHAR2, nNumRegIni NUMBER := 1, nNumRegFin NUMBER := 50) RETURN CLOB IS

        --Consulta_Cotizaciones :   En digital lleva registro por RFC o Correo de las cotizaciones y deber�a haber guardado el numero de IDCotizacion y CODAGENTE
        --pEstatus in 'EMITID'  Cotizaci�n solo EMITIDA
        --            'POLEMI', Cotizaci�n con Poliza emitida
        -- Paginaci�n de registros: nNumRegIni y nNumRegFin
        CURSOR Q_COTI IS
          SELECT XMLELEMENT("COTIZACION",  XMLATTRIBUTES("IDCOTIZACION" , 
                                                         "FECHA_COTIZACION",  
                                                         "FECHA_INI_VIG",
                                                         "FECHA_FIN_VIG",
                                                         "FECHA_VENCIMIENTO",  
                                                         "ESTAUS_COTIZACION",   
                                                         "PORCENTAJE_VIGENCIA",   
                                                         "NUM_UNI_COTIZACION",
                                                         "NOMBRE",
                                                         "SUMA_ASEGURADA",
                                                         "PRIMA_COTIZADA",
                                                         "ES_POLIZA_EMITIDA",
                                                         "IDPOLIZA",
                                                         "NUM_RENOVACION_POL",
                                                         "CODAGENTE")) DATOSXML 
            FROM (                                                         
                SELECT A.IDCOTIZACION, 
                       A.FECCOTIZACION                                                      FECHA_COTIZACION,
                       A.FECFINVIGCOT                                                       FECHA_INI_VIG,
                       A.FECFINVIGCOT                                                       FECHA_FIN_VIG,
                       A.FECVENCECOTIZACION                                                 FECHA_VENCIMIENTO,
                       A.STSCOTIZACION                                                      ESTAUS_COTIZACION,
                       DECODE(SIGN(TRUNC((((A.FECVENCECOTIZACION - A.FECCOTIZACION) * 
                             (A.FECVENCECOTIZACION-(TRUNC(SYSDATE)-3)) ) / 10))), -1, 0, 
                             CASE WHEN TRUNC(CEIL((((A.FECVENCECOTIZACION - A.FECCOTIZACION) *
                             (A.FECVENCECOTIZACION-(TRUNC(SYSDATE)-3)) ) / 10)),1) > 100 THEN 0 ELSE 
                             TRUNC(CEIL((((A.FECVENCECOTIZACION - A.FECCOTIZACION) *
                             (A.FECVENCECOTIZACION-(TRUNC(SYSDATE)-3)) ) / 10)),1)END)        PORCENTAJE_VIGENCIA,
                       A.NUMUNICOCOTIZACION                                                 NUM_UNI_COTIZACION,
                       A.NOMBRECONTRATANTE                                                  NOMBRE,
                       A.SUMAASEGCOTMONEDA                                                  SUMA_ASEGURADA,
                       A.PRIMACOTMONEDA                                                     PRIMA_COTIZADA,
                       DECODE(A.IDPOLIZA, NULL, 'N', 'S')                                   ES_POLIZA_EMITIDA,
                       A.IDPOLIZA                                                           IDPOLIZA,
                       A.NUMPOLRENOVACION                                                   NUM_RENOVACION_POL,
                       A.CODAGENTE,
                       NVL(B.NOMBRECONTRATANTE, P.DESC_PLAN)                                NOM_PRODUC               
                FROM COTIZACIONES A LEFT JOIN COTIZACIONES      B ON B.CODCIA       = A.CODCIA      AND B.CODEMPRESA    = A.CODEMPRESA AND B.IDCOTIZACION = A.NUMCOTIZACIONANT  
                                    LEFT JOIN PLAN_COBERTURAS   P ON P.CODCIA       = A.CODCIA      AND P.CODEMPRESA    = A.CODEMPRESA AND P.IDTIPOSEG    = A.IDTIPOSEG   AND P.PLANCOB       = A.PLANCOB 
                 WHERE A.IDCOTIZACION        = DECODE(NVL(pIDCOTIZACION, 0), 0, A.IDCOTIZACION, pIDCOTIZACION)       
                   AND A.CODAGENTE           = pCodAgente
                   AND TRUNC(SYSDATE) BETWEEN  TRUNC(A.FECCOTIZACION) AND TRUNC(A.FECVENCECOTIZACION)
                   AND A.NOMBRECONTRATANTE <> '{NOMBRE}'
                   AND A.CODCIA = 1
                   AND A.CODEMPRESA = 1
                   AND A.STSCOTIZACION  NOT IN ('COTIZA')
                   AND A.STSCOTIZACION = DECODE(pEstatus, NULL, A.STSCOTIZACION, pEstatus)
                   AND A.NOMBRECONTRATANTE LIKE DECODE(pNombre, NULL, '%', replace(replace(pNombre, '%', '*'), '@', '%'))
                ORDER BY decode(a.STSCOTIZACION, 'ANPOLE', 40, 'COTIZA', 10, 'EMITID', decode(ES_POLIZA_EMITIDA, 'S', 25, 'N', 20), 'POLEMI', 30, 50), A.IDCOTIZACION DESC); 
        R_COTI Q_COTI%ROWTYPE;
        --
        CATA CLOB;
        --            
        nNum    NUMBER := 0;    
    BEGIN
            CATA := '<?xml version="1.0" encoding="UTF-8" ?><COTIZACIONES>';
            OPEN Q_COTI;
            LOOP
                FETCH Q_COTI INTO R_COTI;
                EXIT WHEN Q_COTI%NOTFOUND;
                --
                nNum := nNum + 1;
                IF (nNum BETWEEN nNumRegIni and nNumRegFin) or nNumRegIni = 0 THEN 
                    CATA := CATA || R_COTI.DATOSXML.getclobval();
                END IF;
                --
            END LOOP;
            --    
            CLOSE Q_COTI;
            CATA :=  CATA || '</COTIZACIONES>';
            RETURN  CATA;           
    END MUESTRA_COTIZACIONES;
    --
    FUNCTION PLD_POLIZA_LIBERADA(nIdPoliza NUMBER) RETURN CHAR IS
        nCodCia     NUMBER := 1;
        nCodEmpresa NUMBER := 1;
        cChar       CHAR(1);
    BEGIN
        cChar := OC_POLIZAS.LIBERADA_PLD(nCodCia , nCodEmpresa , nIdPoliza );
        RETURN cChar;
    END PLD_POLIZA_LIBERADA;
    --
    FUNCTION PLD_POLIZA_BLOQUEDA(nIdPoliza NUMBER) RETURN CHAR IS
        nCodCia     NUMBER := 1;
        nCodEmpresa NUMBER := 1;
        cChar       CHAR(1);
    BEGIN
        cChar := OC_ADMON_RIESGO.POLIZA_BLOQUEADA(nCodCia , nCodEmpresa , nIdPoliza );
        RETURN cChar;
    END PLD_POLIZA_BLOQUEDA;
    --
    FUNCTION COTIZACION_CONCEPTOS_PRIMA(pIDCOTIZACION NUMBER) RETURN CLOB IS
        CURSOR Q_COTI IS
            SELECT XMLELEMENT("COTIZACION",  XMLATTRIBUTES("IDCOTIZACION", 
                                                            "CODCONCEPTO" , 
                                                            "DESCRIPCONCEPTO",  
                                                            "PORCCONCEPTO",  
                                                            "CODMONEDA",   
                                                            "MONTOCONCEPTO"
                                                             )) DATOSXML 
              FROM (
                    SELECT  pIDCOTIZACION   IDCOTIZACION,
                            P.CODCONCEPTO, 
                            P.DESCRIPCONCEPTO, 
                            P.PORCCONCEPTO,  
                            NVL(C.CODMONEDA, 'PS') CODMONEDA, 
                            NVL(C.MONTOCONCEPTO, 0) MONTOCONCEPTO
                    from SICAS_OC.CATALOGO_DE_CONCEPTOS P  LEFT JOIN SICAS_OC.COTIZACIONES              Z ON Z.CODCIA      = P.CODCIA      AND Z.CODEMPRESA = 1 AND Z.IDCOTIZACION = pIDCOTIZACION     
                                                           LEFT JOIN SICAS_OC.CATALOGO_CONCEPTOS_RANGOS C ON C.CODCONCEPTO = P.CODCONCEPTO AND C.CODCIA = P.CODCIA AND Z.IDTIPOSEG = C.IDTIPOSEG AND C.CODMONEDA = Z.COD_MONEDA 
                    WHERE( (P.INDESIMPUESTO = 'S' 
                      AND P.CODCPTOPRIMASFACTELECT IS NOT NULL)
                       OR P.INDRANGOSTIPSEG = 'S')
                    ORDER BY P.ORDEN_IMPRESION);  
        R_COTI Q_COTI%ROWTYPE;
        --
        CATA CLOB;
        --            
    BEGIN
            CATA := '<?xml version="1.0" encoding="UTF-8" ?><CONCEPTOS_PRIMA>';
            OPEN Q_COTI;
            LOOP
                FETCH Q_COTI INTO R_COTI;
                EXIT WHEN Q_COTI%NOTFOUND;
                --
                    CATA := CATA || R_COTI.DATOSXML.getclobval();
                --
            END LOOP;
            --    
            CLOSE Q_COTI;
            CATA :=  CATA || '</CONCEPTOS_PRIMA>';
            RETURN  CATA;           
    END COTIZACION_CONCEPTOS_PRIMA;           
    --                        
    FUNCTION MUESTRA_POLIZAS(pCodCia NUMBER, pIDPOLIZA NUMBER, pRFC varchar2, pNombre VARCHAR2, pCodAgente varchar2, nNumRegIni NUMBER, nNumRegFin NUMBER) RETURN CLOB IS 
        --pCodCia     NUMBER  := 1;
        --pIDPOLIZA   NUMBER  := 0;
        --pRFC        VARCHAR2(15) := null; 
        --pCodAgente  VARCHAR2(10) := '99'; 
        pEstatus    VARCHAR2(10);
        --nNumRegIni  NUMBER  := 1;
        --nNumRegFin  NUMBER  := 50;

        CURSOR Q_ENACA IS
        
        
            SELECT XMLELEMENT("IDPOLIZA",           IDPOLIZA,     
                   XMLELEMENT("NUMPOLUNICO",        NUMPOLUNICO),
                   XMLELEMENT("NOMPAQ",             NOMPAQ),
                   XMLELEMENT("FECEMISION",         FECEMISION),
                   XMLELEMENT("FECINIVIG",          FECINIVIG),
                   XMLELEMENT("FECFINVIG",          FECFINVIG),
                   XMLELEMENT("STSPOLIZA",          STSPOLIZA),
                   XMLELEMENT("CLIENTE",      XMLATTRIBUTES("NOMBRE_CLIENTE",
                                                            "TELMOVIL",
                                                            "EMAIL"
                                                           )),
                   XMLELEMENT("NUM_COTIZACION",     NUM_COTIZACION),
                   XMLELEMENT("COD_AGENTE",         COD_AGENTE),
                   XMLELEMENT("COD_MONEDA",         COD_MONEDA),
                   XMLELEMENT("PRIMANETA_MONEDA",   PRIMANETA_MONEDA),                                                  
                   XMLELEMENT("REMXX",              REMPLAZO                                                  
                   )) XMLDATOS,
                   CODCIA,
                   CODEMPRESA,
                   IDPOLIZA
            FROM (
            SELECT 
                   P.CODCIA,
                   P.CODEMPRESA,
                   P.IDPOLIZA,
                   P.NUMPOLUNICO,
                   P.FECEMISION,
                   P.FECINIVIG,
                   P.FECFINVIG,
                   P.STSPOLIZA,                   
                   --OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE) NOMBRE_CLIENTE,
                   TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) || ' ' || DECODE(PNJ.ApeCasada,NULL,'', ' de ' ||PNJ.ApeCasada) NOMBRE_CLIENTE,
                   NVL(PNJ.TELMOVIL, PNJ.TELRES) TELMOVIL,
                   PNJ.EMAIL ,
                   P.NUM_COTIZACION,
                   P.COD_AGENTE  ,
                   P.COD_MONEDA,
                   P.PRIMANETA_MONEDA,
                   ANTERIOR.NOMBRECONTRATANTE NOMPAQ,
                   'REMXX'   REMPLAZO
            FROM POLIZAS P  INNER JOIN CLIENTES                 CLI         ON CLI.CodCliente = P.CODCLIENTE
                            INNER JOIN PERSONA_NATURAL_JURIDICA PNJ         ON CLI.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion AND CLI.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion                            
                            LEFT JOIN COTIZACIONES              C           ON C.CODCIA = P.CODCIA AND C.CODEMPRESA = P.CODEMPRESA AND C.IDCOTIZACION = P.NUM_COTIZACION 
                            LEFT JOIN COTIZACIONES              ANTERIOR    ON ANTERIOR.CODCIA = C.CODCIA AND ANTERIOR.CODEMPRESA = C.CODEMPRESA AND ANTERIOR.IDCOTIZACION = C.NUMCOTIZACIONANT
            WHERE  P.CODCIA                     = NVL(pCodCia, 1)              
              AND  P.COD_AGENTE                 = DECODE(NVL(pCodAgente, '0'), '0', P.COD_AGENTE, pCodAgente)              
              AND  P.IDPOLIZA                   = DECODE(NVL(pIDPOLIZA, 0), 0,  P.IDPOLIZA,   pIDPOLIZA)
              AND  PNJ.NUM_DOC_IDENTIFICACION   = DECODE(pRFC, NULL, PNJ.NUM_DOC_IDENTIFICACION, pRFC)
              AND TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) LIKE DECODE(pNombre, NULL, '%', replace(replace(pNombre, '%', '*'), '@', '%'))
             ORDER BY decode(P.STSPOLIZA, 'PLD', 10, 'PRE', 20, 'EMI', 30, 40), P.IDPOLIZA DESC) ;         
        L_ENACA Q_ENACA%ROWTYPE ;
        
        CURSOR Q_DETALLE (nCODCIA NUMBER, nCODEMPRESA NUMBER, nIDPOLIZA NUMBER) IS
            SELECT XMLELEMENT("CERTIFICADO",   XMLATTRIBUTES("IDETPOL", 
                                                              "IDTIPOSEG",
                                                              "PLANCOB",
                                                              "STSDETALLE",
                                                              "FECINIVIG",
                                                              "FECFINVIG",
                                                              "NOMBRE_ASEG",
                                                              "MOTIVANUL",
                                                              "FECANUL",
                                                              "DESCPLAN",
                                                              "SUMA_ASEG_MONEDA"
                                                              )
                   ) XMLDATOS
            FROM (
            SELECT 
                   D.IDETPOL,
                   D.IDTIPOSEG,
                   D.PLANCOB,
                   D.STSDETALLE ,
                   D.FECINIVIG,
                   D.FECFINVIG,     
                   OC_PERSONA_NATURAL_JURIDICA.NOMBRE_PERSONA(D.COD_ASEGURADO) NOMBRE_ASEG,                                   
                   D.MOTIVANUL,
                   D.FECANUL,                       
                   PP.DESCPLAN,
                   D.SUMA_ASEG_MONEDA
            FROM DETALLE_POLIZA       D   LEFT  JOIN PLAN_DE_PAGOS        PP  ON PP.STSPLAN = 'ACT'         AND PP.CODPLANPAGO = D.CODPLANPAGO                 
            WHERE D.CODCIA     = nCODCIA      
              AND D.CODEMPRESA = nCODEMPRESA 
              AND D.IDPOLIZA   = nIDPOLIZA);
        L_DETAL Q_DETALLE%ROWTYPE ;

              
        LIN     CLOB;
        LINDETA CLOB;
        NUMREG  NUMBER;        

    BEGIN
        NUMREG := 0;
        LIN := '<?xml version="1.0" encoding="UTF-8" ?><POLIZA>';
        OPEN Q_ENACA;
        LOOP
            FETCH Q_ENACA INTO L_ENACA;
            EXIT WHEN Q_ENACA%NOTFOUND;
            --
            NUMREG := NUMREG + 1;
               
            IF NUMREG BETWEEN NVL(nNumRegIni, 1) AND NVL(nNumRegFin, 50) THEN
            
                LIN := LIN || L_ENACA.XMLDATOS.getclobval();
                --        
                LINDETA := '<CERTIFICADOS>';
                OPEN Q_DETALLE (L_ENACA.CODCIA, L_ENACA.CODEMPRESA, L_ENACA.IDPOLIZA);        
                LOOP
                    FETCH Q_DETALLE INTO L_DETAL;
                    EXIT WHEN Q_DETALLE%NOTFOUND;    
                    --  
                    LINDETA := LINDETA || L_DETAL.XMLDATOS.getclobval();
                    --                
                END LOOP;
                CLOSE Q_DETALLE;
                --
                LINDETA := LINDETA || '</CERTIFICADOS>';
                --
                LIN :=  GT_WEB_SERVICES.REPLACE_CLOB(LIN, '<REMXX>REMXX</REMXX>', LINDETA);
                
            END IF;
            --
            IF NUMREG = nNumRegFin THEN
                EXIT;
            END IF;
        END LOOP;
        CLOSE Q_ENACA;
        LIN :=  LIN || '</POLIZA>';
        RETURN ( LIN );          
    END MUESTRA_POLIZAS;
    --
    FUNCTION CONSULTA_AGENTE(pCODCIA NUMBER, pCODEMPRESA NUMBER, pCODAGENTE NUMBER) RETURN CLOB IS 
        NUM         NUMBER    :=0;
        nNIVEL       NUMBER    :=5;
        nAgente     NUMBER := 0;
        --pCOD_AGENTE NUMBER := 264;     --264 --3048 -- 99
        nCOD_AGENTE NUMBER;     --264 --3048 -- 99
        Linea       CLOB;
        
        TYPE NIVELES IS RECORD (
            NIVEL   NUMBER,
            JEFE    NUMBER,
            SUB     NUMBER,
            NOMBRE  VARCHAR(500),
            EMAIL   VARCHAR(500),
            TEL     VARCHAR(500),
            EST_AGENTE        AGENTES.EST_AGENTE%TYPE,
            FECALTA           AGENTES.FECALTA%TYPE,
            TIPO_AGENTE       AGENTES.TIPO_AGENTE%TYPE,                                          
            NUMCEDULA         AGENTES_CEDULA_AUTORIZADA.NUMCEDULA%TYPE,             
            TIPOCEDULA        AGENTES_CEDULA_AUTORIZADA.TIPOCEDULA%TYPE,
            FECEXPEDICION     AGENTES_CEDULA_AUTORIZADA.FECEXPEDICION%TYPE,
            FECVENCIMIENTO    AGENTES_CEDULA_AUTORIZADA.FECVENCIMIENTO%TYPE,
            NUMPOLRC          AGENTES_CEDULA_AUTORIZADA.NUMPOLRC%TYPE,
            FECVENCPOLRC      AGENTES_CEDULA_AUTORIZADA.FECVENCPOLRC%TYPE
            );
        TYPE TAB_NIVELES IS TABLE OF NIVELES
            INDEX BY PLS_INTEGER;
        TABLA_NIVELES TAB_NIVELES;
            
    BEGIN
        nCOD_AGENTE := pCODAGENTE;
        FOR NUM IN 1..4 LOOP
            nNIVEL := nNIVEL - 1;
            FOR ENT IN (SELECT A.CODNIVEL NIVEL,
                               A.COD_AGENTE_JEFE, 
                               A.COD_AGENTE,
                               A.TIPO_DOC_IDENTIFICACION,
                               A.NUM_DOC_IDENTIFICACION,
                               A.EST_AGENTE,
                               A.FECALTA,
                               A.IDCUENTACORREO,  
                               A.TIPO_AGENTE,                                  
                               C.NUMCEDULA,       
                               C.TIPOCEDULA,
                               C.FECEXPEDICION,
                               C.FECVENCIMIENTO,
                               C.NUMPOLRC,
                               C.FECVENCPOLRC
                          FROM SICAS_OC.AGENTES A LEFT  JOIN AGENTES_CEDULA_AUTORIZADA C    ON C.CODCIA = A.CODCIA AND C.CODEMPRESA = A.CODEMPRESA AND C.COD_AGENTE = A.COD_AGENTE
                           WHERE A.COD_AGENTE   = nCOD_AGENTE
                             AND A.CODCIA       = pCODCIA
                             AND A.CODEMPRESA   = pCODEMPRESA ) LOOP
                TABLA_NIVELES(NUM).NIVEL      := ENT.NIVEL;
                TABLA_NIVELES(NUM).JEFE       := ENT.COD_AGENTE;
                TABLA_NIVELES(NUM).SUB        := ENT.COD_AGENTE_JEFE;
                SELECT  REPLACE(PA.NOMBRE || ' ' || PA.APELLIDO_MATERNO || ' ' || PA.APELLIDO_PATERNO, '  ', ' '),
                        PA.EMAIL,
                        NVL(PA.TELMOVIL, NVL(PA.TELOFI, PA.TELRES )) TEL                           
                  INTO  TABLA_NIVELES(NUM).NOMBRE, 
                        TABLA_NIVELES(NUM).EMAIL,
                        TABLA_NIVELES(NUM).TEL
                  FROM  PERSONA_NATURAL_JURIDICA PA  
                 WHERE  PA.TIPO_DOC_IDENTIFICACION = ENT.TIPO_DOC_IDENTIFICACION 
                   AND  PA.NUM_DOC_IDENTIFICACION = ENT.NUM_DOC_IDENTIFICACION;
                IF nCOD_AGENTE =  pCODAGENTE THEN                                  
                    TABLA_NIVELES(NUM).EST_AGENTE    := ENT.EST_AGENTE;
                    TABLA_NIVELES(NUM).FECALTA       := ENT.FECALTA;
                    TABLA_NIVELES(NUM).TIPO_AGENTE   := ENT.TIPO_AGENTE;
                    TABLA_NIVELES(NUM).NUMCEDULA     := ENT.NUMCEDULA;
                    TABLA_NIVELES(NUM).TIPOCEDULA    := ENT.TIPOCEDULA;
                    TABLA_NIVELES(NUM).FECEXPEDICION := ENT.FECEXPEDICION;
                    TABLA_NIVELES(NUM).FECVENCIMIENTO := ENT.FECVENCIMIENTO;                    
                    TABLA_NIVELES(NUM).NUMPOLRC      := ENT.NUMPOLRC;
                    TABLA_NIVELES(NUM).FECVENCPOLRC  := ENT.FECVENCPOLRC;            
                END IF;
                --
                nCOD_AGENTE := ENT.COD_AGENTE_JEFE;
                --
            END LOOP;
        END LOOP;    
        --    
        Linea :=  '<?xml version="1.0" encoding="UTF-8" ?>' || CHR(10) || '<ESTRUCTURA>' || CHR(10);
        FOR NUM IN REVERSE  1..TABLA_NIVELES.COUNT LOOP
            LINEA := LINEA || LPAD(CHR(9), TABLA_NIVELES(NUM).NIVEL, CHR(9));
            nAgente := nAgente + 1;
            Linea :=     Linea ||
                        --'<AGENTE' || TABLA_NIVELES(NUM).NIVEL ||  
                        '<AGENTE' || nAgente ||  
                        ' COD_AGENTE="' || TABLA_NIVELES(NUM).JEFE           || '"' ||                   
                        ' NIVEL="' || TABLA_NIVELES(NUM).NIVEL          || '"' ||                  
                        ' NOMBRE="' || TRIM(TABLA_NIVELES(NUM).NOMBRE)  || '"' ||
                        ' EMAIL="' || TABLA_NIVELES(NUM).EMAIL          || '"' ||
                        ' TEL="' || TABLA_NIVELES(NUM).TEL              || '"';
                        --' DEP="' || TABLA_NIVELES(NUM).SUB            || '"';
                        IF TABLA_NIVELES(NUM).JEFE  =  pCODAGENTE THEN 
                            Linea :=   Linea ||
                            ' ESTATUS="' || TABLA_NIVELES(NUM).EST_AGENTE   || '"' ||
                            ' FECHA_ALTA="' || to_char(TABLA_NIVELES(NUM).FECALTA, 'dd/mm/yyyy')      || '"' ||
                            ' TIPO_AGENTE="' || TABLA_NIVELES(NUM).TIPO_AGENTE  || '"' ||
                            ' NUM_CEDULA="' || TABLA_NIVELES(NUM).NUMCEDULA    || '"' ||
                            ' TIPO_CEDULA="' || TABLA_NIVELES(NUM).TIPOCEDULA   || '"' ||
                            ' FECHA_EXPED="' || to_char(TABLA_NIVELES(NUM).FECEXPEDICION, 'dd/mm/yyyy') || '"' ||
                            ' FECHA_VENCIMIENTO="' || to_char(TABLA_NIVELES(NUM).FECVENCIMIENTO, 'dd/mm/yyyy') || '"' ||
                            ' NUM_POL_RC="' || TABLA_NIVELES(NUM).NUMPOLRC     || '"' ||
                            ' FECHA_VENC_RFC="' || to_char(TABLA_NIVELES(NUM).FECVENCPOLRC, 'dd/mm/yyyy') || '"';
                        END IF;                 
                        Linea :=   Linea || '>' ||CHR(10); --  
        END LOOP;
        nAgente := TABLA_NIVELES.COUNT + 1;
        FOR NUM IN 1..TABLA_NIVELES.COUNT LOOP
            nAgente := nAgente - 1;
            LINEA := LINEA || LPAD(CHR(9), TABLA_NIVELES(NUM).NIVEL, CHR(9));
            Linea :=   Linea || '</AGENTE' ||nAgente ||'>' || CHR(10);  
        END LOOP;
        Linea :=  Linea || '</ESTRUCTURA>';        
        RETURN Linea;                             
    END CONSULTA_AGENTE;
    --
    FUNCTION CONDICIONES_GENERALES(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, dFecEmision DATE) RETURN BLOB AS
        bCondicionesGenerales REGISTRO_TIPSEG_AUTORIDAD.CondicionesGenerales%TYPE;
    BEGIN
      BEGIN
         SELECT CondicionesGenerales --IdTipoSeg,FecRegistro,NumAutorTipSeg,Ds_Arch_Congen,StRegistro,Fec_Suspencion
           INTO bCondicionesGenerales
           FROM REGISTRO_TIPSEG_AUTORIDAD
          WHERE CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa
            AND IdTipoSeg     = cIdTipoSeg
            AND dFecEmision   BETWEEN FecRegistro AND NVL(Fec_Suspencion,TRUNC(SYSDATE));
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            bCondicionesGenerales := EMPTY_BLOB();
         WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20200,'Existe m�s de un registro activo para el producto '||OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(nCodCia, nCodEmpresa, cIdTipoSeg)||SQLERRM);
      END;
      RETURN bCondicionesGenerales;
    END CONDICIONES_GENERALES;
    --
    FUNCTION DESCARTA_POLIZA (nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) RETURN INT IS
        nMonto NUMBER := 0;
        SalidaErr EXCEPTION;
    BEGIN    
        --           
        BEGIN

            SELECT count(*) 
              INTO nMonto
              FROM POLIZAS  P
             WHERE P.IdPoliza   = nIdPoliza         
               AND P.CodCia     = nCodCia
               AND P.CODEMPRESA = nCodEmpresa
               AND EXISTS (SELECT 1 FROM COTIZACIONES C WHERE C.CODCIA = nCodCia and C.CODEMPRESA = nCodEmpresa AND C.IDCOTIZACION =  NVL(P.NUM_COTIZACION,0) and C.INDCOTIZACIONWEB = 'S'); 
            IF NVL(nMonto, 0) = 0 THEN
                raise_application_error(-20001, 'Esta p�liza, no es de origen de la Plataforma Digital');
            END IF;
            SELECT SUM(O.MONTOPAGO_MONEDA)
              INTO nMonto
              FROM THONAPI.OPENPAY_PAGOS O 
             WHERE IDPOLIZA = nIdPoliza 
             AND UPPER(STSPAGO) = 'CARGOAPROB';
            IF NVL(nMonto,0) > 0 then
               raise SalidaErr;
            END IF;
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END ;
        --         
        DELETE FROM ENDOSOS       WHERE IdPoliza  = nIdPoliza         AND CodCia    = nCodCia;
        DELETE FROM RESPONSABLE_PAGO_POL       WHERE IdPoliza   = nIdPoliza         AND CodCia     = nCodCia;
        DELETE FROM CLAUSULAS_POLIZA       WHERE IdPoliza  = nIdPoliza         AND CodCia    = nCodCia;
        DELETE FROM COBERT_ACT where  IdPoliza     = nIdPoliza      AND CodEmpresa   = nCodEmpresa      AND CodCia       = nCodCia;
        DELETE FROM ASISTENCIAS_DETALLE_POLIZA where  IdPoliza     = nIdPoliza      AND CodEmpresa   = nCodEmpresa      AND CodCia       = nCodCia;
        DELETE FROM FAI_FONDOS_DETALLE_POLIZA  where  IdPoliza     = nIdPoliza      AND CodEmpresa   = nCodEmpresa      AND CodCia       = nCodCia;
        DELETE FROM RESPONSABLE_PAGO_DET       WHERE IdPoliza   = nIdPoliza         AND CodCia     = nCodCia;
        DELETE FROM CLAUSULAS_DETALLE       WHERE IdPoliza  = nIdPoliza         AND CodCia    = nCodCia;
        DELETE FROM COBERT_ACT_ASEG where  IdPoliza     = nIdPoliza      AND CodEmpresa   = nCodEmpresa      AND CodCia       = nCodCia;
        DELETE FROM ASISTENCIAS_ASEGURADO  where IdPoliza     = nIdPoliza      AND CodEmpresa   = nCodEmpresa      AND CodCia       = nCodCia;
        DELETE FROM ASEGURADO_CERTIFICADO    WHERE IdPoliza = nIdPoliza      AND CodCia   = nCodCia;
        DELETE FROM BENEFICIARIO    where IdPoliza     = nIdPoliza ;   
        FOR X IN (SELECT IdTransaccion, IdFactura FROM FACTURAS          WHERE IdPoliza  = nIdPoliza            AND CodCia    = nCodCia) LOOP
            FOR Y IN (SELECT C.NUMCOMPROB FROM COMPROBANTES_CONTABLES C WHERE CODCIA = nCodCia AND NumTransaccion = X.IdTransaccion) LOOP       
                DELETE FROM COMPROBANTES_DETALLE WHERE CODCIA = nCodCia AND NumComprob = Y.NumComprob;
            END LOOP; 
            DELETE FROM COMPROBANTES_CONTABLES    WHERE CodCia    = nCodCia      AND NumTransaccion = X.IdTransaccion;
            DELETE FROM REA_DISTRIBUCION          WHERE IdTransaccion = X.IdTransaccion;
            DELETE FROM DETALLE_TRANSACCION       WHERE CODCIA = nCodCia AND CODEMPRESA =  nCodEmpresa AND IdTransaccion = X.IdTransaccion;
            DELETE FROM TRANSACCION               WHERE CODCIA = nCodCia AND CODEMPRESA =  nCodEmpresa AND IdTransaccion = X.IdTransaccion;
            DELETE FROM DETALLE_FACTURAS          WHERE IdFactura = X.IdFactura;
        END LOOP;
        
        DELETE FROM COMISIONES  where IdPoliza     = nIdPoliza      AND CodEmpresa   = nCodEmpresa      AND CodCia       = nCodCia;
        DELETE FROM FACTURAS    WHERE IdPoliza  = nIdPoliza      AND CodCia    = nCodCia;
        DELETE FROM SOLICITUD_EMISION  where IdPoliza     = nIdPoliza      AND CodEmpresa   = nCodEmpresa      AND CodCia       = nCodCia;
        DELETE FROM DETALLE_POLIZA    WHERE IdPoliza = nIdPoliza      AND CodCia   = nCodCia;
        DELETE FROM POLIZAS       WHERE IdPoliza = nIdPoliza         AND CodCia   = nCodCia;
        DELETE THONAPI.DOCUMENTOS WHERE IdPoliza = nIdPoliza;
        DELETE THONAPI.OPENPAY_PAGOS O WHERE IDPOLIZA = nIdPoliza AND STSPAGO <> 'CargoAprob';
        RETURN 1;
    EXCEPTION WHEN SalidaErr THEN
        raise_application_error(-20001, 'Error,  No se puede descartar la poliza (' || nIdPoliza || '), ya que tiene recibo(s) pagado(s) en OpenPay.');
        RETURN 0;                          
    END DESCARTA_POLIZA;       
    --
    FUNCTION LIMPIA_COTIZACIONES (pFecha DATE := TRUNC(SYSDATE)) RETURN NUMBER IS             
        nNumReg    NUMBER := 0;
        nNumPol    NUMBER := 0;
        --  
        nCodCia         NUMBER := 1;
        nCodEmpresa     NUMBER := 1;
        --
        CURSOR C_COTIZA IS        
            SELECT C.IDCOTIZACION ,
                   C.IDPOLIZA, 
                   C.CODCIA,
                   C.CODEMPRESA,
                   C.STSCOTIZACION,
                   C.FECVENCECOTIZACION , 
                   OC_POLIZAS.LIBERADA_PLD(CODCIA , CODEMPRESA , C.IDPOLIZA ) LIBERADA,
                   C.NUMCOTIZACIONANT
            FROM COTIZACIONES C 
            WHERE C.CODCIA = nCodCia 
              AND C.CODEMPRESA = nCodEmpresa 
              AND (C.FECVENCECOTIZACION BETWEEN (pFecha-15) AND (pFecha-1)
               OR (C.FECCOTIZACION < SYSDATE AND C.STSCOTIZACION = 'COTIZA'))
              AND C.INDCOTIZACIONWEB = 'S'
              AND C.INDCOTIZACIONBASEWEB <> 'S'
              AND C.STSCOTIZACION <> 'POLEMI'
              AND OC_ADMON_RIESGO.POLIZA_BLOQUEADA(CODCIA , CODEMPRESA , C.IDPOLIZA ) = 'N'
              AND NOT EXISTS (SELECT 1 FROM POLIZAS P WHERE P.IDPOLIZA = C.IDPOLIZA AND P.STSPOLIZA = 'PLD' ) 
              AND NOT EXISTS (SELECT 1 FROM THONAPI.OPENPAY_PAGOS O WHERE O.IDPOLIZA = C.IDPOLIZA AND STSPAGO = 'CargoAprob');                   
        R_COTIZA C_COTIZA%ROWTYPE;          
             
    BEGIN   

        OPEN C_COTIZA;    
        LOOP
            FETCH C_COTIZA INTO R_COTIZA;
            EXIT WHEN C_COTIZA%NOTFOUND;
            IF R_COTIZA.IDPOLIZA IS NOT NULL THEN
               nNumPol := DESCARTA_POLIZA(R_COTIZA.CODCIA, R_COTIZA.CODEMPRESA, R_COTIZA.IDPOLIZA); 
            END IF;
            nNumReg := nNumReg+1;
            DELETE FROM COTIZACIONES_ASEG           C WHERE C.CODCIA = R_COTIZA.CODCIA AND C.CODEMPRESA = R_COTIZA.CODEMPRESA AND C.IDCOTIZACION = R_COTIZA.IDCOTIZACION; 
            DELETE FROM COTIZACIONES_CENSO_ASEG     C WHERE C.CODCIA = R_COTIZA.CODCIA AND C.CODEMPRESA = R_COTIZA.CODEMPRESA AND C.IDCOTIZACION = R_COTIZA.IDCOTIZACION;
            DELETE FROM COTIZACIONES_CLAUSULAS      C WHERE C.CODCIA = R_COTIZA.CODCIA AND C.CODEMPRESA = R_COTIZA.CODEMPRESA AND C.IDCOTIZACION = R_COTIZA.IDCOTIZACION;
            DELETE FROM COTIZACIONES_COBERT_ASEG    C WHERE C.CODCIA = R_COTIZA.CODCIA AND C.CODEMPRESA = R_COTIZA.CODEMPRESA AND C.IDCOTIZACION = R_COTIZA.IDCOTIZACION; 
            DELETE FROM COTIZACIONES_COBERT_MASTER  C WHERE C.CODCIA = R_COTIZA.CODCIA AND C.CODEMPRESA = R_COTIZA.CODEMPRESA AND C.IDCOTIZACION = R_COTIZA.IDCOTIZACION;
            DELETE FROM COTIZACIONES_COBERTURAS     C WHERE C.CODCIA = R_COTIZA.CODCIA AND C.CODEMPRESA = R_COTIZA.CODEMPRESA AND C.IDCOTIZACION = R_COTIZA.IDCOTIZACION;
            DELETE FROM DETALLE_POLIZA_COTIZ        C WHERE C.CODCIA = R_COTIZA.CODCIA AND C.CODEMPRESA = R_COTIZA.CODEMPRESA AND C.IDCOTIZACION = R_COTIZA.IDCOTIZACION;
            DELETE FROM COTIZACIONES_DETALLE        C WHERE C.CODCIA = R_COTIZA.CODCIA AND C.CODEMPRESA = R_COTIZA.CODEMPRESA AND C.IDCOTIZACION = R_COTIZA.IDCOTIZACION;
            DELETE FROM COTIZACIONES                C WHERE C.CODCIA = R_COTIZA.CODCIA AND C.CODEMPRESA = R_COTIZA.CODEMPRESA AND C.IDCOTIZACION = R_COTIZA.IDCOTIZACION;        
        END LOOP;    
        --DBMS_OUTPUT.PUT_LINE('Numero de cotizaciones: '|| nNumReg);        
        RETURN nNumReg;
    END LIMPIA_COTIZACIONES;    
    --
    FUNCTION PAQUETE_COMERCIAL_DOCUMENTO(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2, cDescPaquete VARCHAR2) RETURN BLOB AS
        bCondicionesGenerales PAQUETE_COMERCIAL.DOCUMENTO%TYPE;
    BEGIN              
      RETURN GT_PAQUETE_COMERCIAL.DOCUMENTO(nCodCia, nCodEmpresa, cIdTipoSeg, cPlanCob, cDescPaquete);
    END PAQUETE_COMERCIAL_DOCUMENTO;
    --
    FUNCTION QUE_HACER_SINIESTROS(nCodCia NUMBER, nCodEmpresa NUMBER, cIdTipoSeg VARCHAR2) RETURN BLOB AS
        bQueHacerSiniestros TIPOS_DE_SEGUROS.QueHacerSiniestros%TYPE;
    BEGIN
      BEGIN
         SELECT QueHacerSiniestros
           INTO bQueHacerSiniestros
           FROM TIPOS_DE_SEGUROS
          WHERE CodCia        = nCodCia
            AND CodEmpresa    = nCodEmpresa
            AND IdTipoSeg     = cIdTipoSeg;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            bQueHacerSiniestros := EMPTY_BLOB();
         WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20200,'Existe m�s de un registro activo para el producto '||OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(nCodCia, nCodEmpresa, cIdTipoSeg)||SQLERRM);
      END;
      RETURN bQueHacerSiniestros;
    END QUE_HACER_SINIESTROS;
    --
END GENERALES_PLATAFORMA_DIGITAL;
/

--
-- GENERALES_PLATAFORMA_DIGITAL  (Synonym) 
--
CREATE OR REPLACE PUBLIC SYNONYM GENERALES_PLATAFORMA_DIGITAL FOR THONAPI.GENERALES_PLATAFORMA_DIGITAL
/


GRANT EXECUTE ON THONAPI.GENERALES_PLATAFORMA_DIGITAL TO PUBLIC
/

create or replace FUNCTION SICAS_OC.FN_OBTIENE_REQUISITOS_COB (
    P_IDPOLIZA     IN NUMBER,
    P_CODASEGURADO IN NUMBER,
    P_CODSUBGRUPO  IN NUMBER,
    P_CODCIA       IN NUMBER,
    P_CODEMPRESA   IN NUMBER
) RETURN CLOB
AS
    v_resultado SYS_REFCURSOR;
    v_json      CLOB;
    v_temp      CLOB;
    
    -- Variables para cada columna del resultado
    v_IDTIPOSEG       VARCHAR2(4000);
    v_PLANCOB         VARCHAR2(4000);
    v_CODCOBERT       VARCHAR2(4000);
    v_DESCCOBERT      VARCHAR2(4000);
    v_CODREQUISITO    VARCHAR2(4000);
    v_NOMARCHIVO      VARCHAR2(4000);
    v_DESCREQUISITO   VARCHAR2(4000);
    v_REQUERIDO       VARCHAR2(10);
    v_ORDENEXPEDIENTE NUMBER;
    v_ORDENPDF        NUMBER;
    v_CANTIDAD        NUMBER;
    v_TAMANIOBYTES    NUMBER;
    v_FORMATOS        VARCHAR2(4000);
    v_CLAVEOCR        VARCHAR2(4000);
    v_TOOLTIP         VARCHAR2(4000);
BEGIN
    -- Crear un CLOB temporal para almacenar el JSON
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH('[ '), '[ ');
    
    -- Llamar al procedimiento para obtener los datos
    WS_OBTIENE_REQUISITOS_COB(
        P_IDPOLIZA     => P_IDPOLIZA,
        P_CODASEGURADO => P_CODASEGURADO,
        P_CODSUBGRUPO  => P_CODSUBGRUPO,
        P_CODCIA       => P_CODCIA,
        P_CODEMPRESA   =>  P_CODEMPRESA,
        P_RESULTADO    => v_resultado
    );
    
    -- Recorrer el cursor y construir el JSON manualmente
    LOOP
        FETCH v_resultado INTO v_IDTIPOSEG, v_PLANCOB, v_CODCOBERT, v_DESCCOBERT, v_CODREQUISITO, 
                            v_NOMARCHIVO, v_DESCREQUISITO, v_REQUERIDO, v_ORDENEXPEDIENTE, v_ORDENPDF, 
                            v_CANTIDAD, v_TAMANIOBYTES, v_FORMATOS, v_CLAVEOCR, v_TOOLTIP;
        EXIT WHEN v_resultado%NOTFOUND;
        v_temp := '{' ||
                    '"IDTIPOSEG": "' || NVL(REGEXP_REPLACE(v_IDTIPOSEG, '"', ''), '') || '", ' ||
                    '"PLANCOB": "' || NVL(REGEXP_REPLACE(v_PLANCOB, '"', ''), '') || '", ' ||
                    '"CODCOBERT": "' || NVL(REGEXP_REPLACE(v_CODCOBERT, '"', ''), '') || '", ' ||
                    '"DESCCOBERT": "' || NVL(REGEXP_REPLACE(v_DESCCOBERT, '"', ''), '') || '", ' ||
                    '"CODREQUISITO": "' || NVL(REGEXP_REPLACE(v_CODREQUISITO, '"', ''), '') || '", ' ||
                    '"NOMARCHIVO": "' || NVL(REGEXP_REPLACE(v_NOMARCHIVO, '"', ''), '') || '", ' ||
                    '"DESCREQUISITO": "' || NVL(REGEXP_REPLACE(v_DESCREQUISITO, '"', ''), '') || '", ' ||
                    '"REQUERIDO": "' || NVL(REGEXP_REPLACE(v_REQUERIDO, '"', ''), '') || '", ' ||
                    '"ORDENEXPEDIENTE": ' || NVL(TO_CHAR(v_ORDENEXPEDIENTE), 'null') || ', ' ||
                    '"ORDENPDF": ' || NVL(TO_CHAR(v_ORDENPDF), 'null') || ', ' ||
                    '"CANTIDAD": ' || NVL(TO_CHAR(v_CANTIDAD), 'null') || ', ' ||
                    '"TAMANIOBYTES": ' || NVL(TO_CHAR(v_TAMANIOBYTES), 'null') || ', ' ||
                    '"FORMATOS": "' || NVL(REGEXP_REPLACE(v_FORMATOS, '"', ''), '') || '", ' ||
                    '"CLAVEOCR": "' || NVL(REGEXP_REPLACE(v_CLAVEOCR, '"', ''), '') || '", ' ||
                    '"TOOLTIP": "' || NVL(REGEXP_REPLACE(v_TOOLTIP, '"', ''), '') || '"' ||
                '}';
        
        -- Agregar coma si ya hay contenido previo (más de solo el "[ ")
        IF DBMS_LOB.GETLENGTH(v_json) > 2 THEN
            DBMS_LOB.WRITEAPPEND(v_json, LENGTH(', '), ', ');
        END IF;
        DBMS_LOB.WRITEAPPEND(v_json, LENGTH(v_temp), v_temp);
    END LOOP;
    
    CLOSE v_resultado;
    
    -- Cerrar JSON array
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH(' ]'), ' ]');
    
    RETURN v_json;
EXCEPTION
    WHEN OTHERS THEN
        RETURN '{ "error": "' || SQLERRM || '" }';
END FN_OBTIENE_REQUISITOS_COB;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_OBTIENE_REQUISITOS_COB FOR SICAS_OC.FN_OBTIENE_REQUISITOS_COB
/

GRANT EXECUTE ON SICAS_OC.FN_OBTIENE_REQUISITOS_COB TO PUBLIC
/
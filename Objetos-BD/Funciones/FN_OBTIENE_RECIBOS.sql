create or replace FUNCTION SICAS_OC.FN_OBTIENE_RECIBOS (    
    p_IdPoliza   IN NUMBER DEFAULT NULL,
    p_CodCia     IN NUMBER DEFAULT NULL,
    p_CodEmpresa IN NUMBER DEFAULT NULL  
) RETURN CLOB
AS
    v_resultado SYS_REFCURSOR;
    v_json      CLOB;
    v_temp      CLOB;
    
    -- Variables para cada columna del resultado
    v_IDFACTURA         FACTURAS.IDFACTURA%TYPE;
    v_STSFACT           FACTURAS.STSFACT%TYPE;
    v_numcta            FACTURAS.NUMCUOTA%TYPE;
    v_moneda           FACTURAS.COD_MONEDA%TYPE;
    v_mtomoneda         FACTURAS.MONTO_FACT_MONEDA%TYPE;
    v_comimoneda        FACTURAS.MTOCOMISI_MONEDA%TYPE;
    v_NUMFACT           FACTURAS.NUMFACT%TYPE;
    v_MONTO_FACT_LOCAL  FACTURAS.MONTO_FACT_LOCAL%TYPE;
    v_FECSTS            FACTURAS.FECSTS%TYPE;
    v_RECIBOPAGO        FACTURAS.RECIBOPAGO%TYPE;
    v_FECANUL           FACTURAS.FECANUL%TYPE;
    v_FORMPAGO          FACTURAS.FORMPAGO%TYPE;
    v_SALDO_MONEDA      FACTURAS.SALDO_MONEDA%TYPE;
    v_FECPAGO           FACTURAS.FECPAGO%TYPE;
    v_FOLIOFACTELEC     FACTURAS.FOLIOFACTELEC%TYPE;
BEGIN
    -- Crear un CLOB temporal para almacenar el JSON
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH('[ '), '[ ');
    
    -- Llamar al procedimiento para obtener los datos
    WS_OBTIENE_RECIBOS(       
        p_IdPoliza   => p_IdPoliza,
        p_CodCia     => p_CodCia,
        p_CodEmpresa => p_CodEmpresa,
        p_resultado  => v_resultado
    );
    
    -- Recorrer el cursor y construir el JSON manualmente
    LOOP
        FETCH v_resultado INTO v_IDFACTURA, v_STSFACT, v_numcta, v_moneda, v_mtomoneda, v_comimoneda,
                              v_NUMFACT, v_MONTO_FACT_LOCAL, v_FECSTS, v_RECIBOPAGO, v_FECANUL, v_FORMPAGO,
                              v_SALDO_MONEDA, v_FECPAGO, v_FOLIOFACTELEC;
        EXIT WHEN v_resultado%NOTFOUND;
        v_temp := '{' ||
            '"IDFACTURA": ' || NVL(TO_CHAR(v_IDFACTURA), 'null') || ', ' ||
            '"STSFACT": "' || NVL(v_STSFACT, '') || '", ' ||
            '"numcta": ' || NVL(TO_CHAR(v_numcta), 'null') || ', ' ||
            '"moneda": "' || NVL(TO_CHAR(v_moneda), 'null') || '", ' ||
            '"mtomoneda": ' || NVL(TO_CHAR(v_mtomoneda), 'null') || ', ' ||
            '"comimoneda": ' || NVL(TO_CHAR(v_comimoneda), 'null') || ', ' ||
            '"NUMFACT": "' || NVL(v_NUMFACT, '') || '", ' ||
            '"MONTO_FACT_LOCAL": ' || NVL(TO_CHAR(v_MONTO_FACT_LOCAL), 'null') || ', ' ||
            '"FECSTS": "' || NVL(TO_CHAR(v_FECSTS, 'YYYYMMDD"T"HH24MISS'), '') || '", ' ||
            '"RECIBOPAGO": "' || NVL(v_RECIBOPAGO, '') || '", ' ||
            '"FECANUL": "' || NVL(TO_CHAR(v_FECANUL, 'YYYYMMDD"T"HH24MISS'), '') || '", ' ||
            '"FORMPAGO": "' || NVL(v_FORMPAGO, '') || '", ' ||
            '"SALDO_MONEDA": ' || NVL(TO_CHAR(v_SALDO_MONEDA), 'null') || ', ' ||
            '"FECPAGO": "' || NVL(TO_CHAR(v_FECPAGO, 'YYYYMMDD"T"HH24MISS'), '') || '", ' ||
            '"FOLIOFACTELEC": "' || NVL(v_FOLIOFACTELEC, '') || '"' ||
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
END FN_OBTIENE_RECIBOS;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_OBTIENE_RECIBOS FOR SICAS_OC.FN_OBTIENE_RECIBOS
/

GRANT EXECUTE ON SICAS_OC.FN_OBTIENE_RECIBOS TO PUBLIC
/
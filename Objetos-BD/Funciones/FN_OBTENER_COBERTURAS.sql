create or replace FUNCTION SICAS_OC.FN_OBTENER_COBERTURAS (
    p_idpoliza      IN NUMBER,
    p_codsubgrupo  IN VARCHAR2 DEFAULT NULL, 
    p_codasegurado IN NUMBER DEFAULT NULL, 
    p_codcia       IN NUMBER DEFAULT NULL,
    p_codempresa   IN NUMBER DEFAULT NULL    
) RETURN CLOB 
AS
    v_resultado SYS_REFCURSOR;
    v_json      CLOB;
    v_temp      CLOB;
    -- Variables para cada columna del resultado
    v_codcobert        COBERT_ACT_ASEG.CodCobert%TYPE;
    v_idetpol          NUMBER;
    v_sumaaseg_local   NUMBER(20,2);
    v_sumaaseg_moneda  NUMBER(20,2);
    v_tasa             NUMBER(10,2);
    v_prima_local      NUMBER(10,2);
    v_prima_moneda     NUMBER(10,2);
    v_cod_moneda       COBERT_ACT_ASEG.Cod_Moneda%TYPE;
    v_deducible_local  NUMBER(20,2);
    v_deducible_moneda NUMBER(20,2);
    v_stscobertura     COBERT_ACT_ASEG.StsCobertura%TYPE;
    v_descstatus       VARCHAR2(100);
    v_descobertura     VARCHAR2(200);
    v_codsubgrupo      VARCHAR2(200);
    v_codcategoria     DETALLE_POLIZA.CodCategoria%TYPE;
    v_dessubgrupo      VARCHAR2(200);
    v_descategoria     VARCHAR2(200);
    v_codempresa       COBERT_ACT_ASEG.CodEmpresa%TYPE;
    v_idtiposeg        COBERT_ACT_ASEG.IdTipoSeg%TYPE;
    v_plancob          COBERT_ACT_ASEG.PlanCob%TYPE;
    v_cod_asegurado    COBERT_ACT_ASEG.Cod_Asegurado%TYPE;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH('[ '), '[ '); -- Abrir JSON array
    WS_OBTENER_COBERTURAS(
        p_idpoliza      => p_idpoliza, 
        p_codsubgrupo  => p_codsubgrupo,
        p_codasegurado => p_codasegurado,
        p_codcia      => p_codcia,
        p_codempresa  => p_codempresa,
        p_resultado     => v_resultado
    );
    LOOP
        FETCH v_resultado INTO 
            v_codcobert, v_idetpol, v_sumaaseg_local, v_sumaaseg_moneda, v_tasa, v_prima_local, 
            v_prima_moneda, v_cod_moneda, v_deducible_local, v_deducible_moneda, 
            v_stscobertura, v_descstatus, v_descobertura, v_codsubgrupo, 
            v_codcategoria, v_dessubgrupo, v_descategoria, v_codempresa, 
            v_idtiposeg, v_plancob, v_cod_asegurado;
        EXIT WHEN v_resultado%NOTFOUND;
        v_temp := '{
            "CodCobert": "' || v_codcobert || '",
            "IDetPol": "' || v_idetpol || '",
            "SumaAseg_Local": ' || TO_CHAR(v_sumaaseg_local, 'FM9999999990.00') || ',
            "SumaAseg_Moneda": ' || TO_CHAR(v_sumaaseg_moneda, 'FM9999999990.00') || ',
            "Tasa": ' || TO_CHAR(v_tasa, 'FM99990.00') || ',
            "Prima_Local": ' || TO_CHAR(v_prima_local, 'FM99990.00') || ',
            "Prima_Moneda": ' || TO_CHAR(v_prima_moneda, 'FM99990.00') || ',
            "Cod_Moneda": "' || v_cod_moneda || '",
            "Deducible_Local": ' || TO_CHAR(NVL(v_deducible_local, 0), 'FM9999999990.00') || ',
            "Deducible_Moneda": ' || TO_CHAR(NVL(v_deducible_moneda, 0), 'FM9999999990.00') || ',
            "StsCobertura": "' || v_stscobertura || '",
            "cDescStatus": "' || v_descstatus || '",
            "DescCobertura": "' || v_descobertura || '",
            "CodSubGrupo": "' || v_codsubgrupo || '",           
            "DesSubgrupo": "' || v_dessubgrupo || '",
            "CodCategoria": "' || v_codcategoria || '",
            "DesCategoria": "' || v_descategoria || '",
            "CodEmpresa": ' || v_codempresa || ',
            "IdTipoSeg": "' || v_idtiposeg || '",
            "PlanCob": "' || v_plancob || '",
            "Cod_Asegurado": ' || v_cod_asegurado || '
        }';
        IF DBMS_LOB.GETLENGTH(v_json) > 2 THEN
            DBMS_LOB.WRITEAPPEND(v_json, LENGTH(', '), ', ');
        END IF;
        DBMS_LOB.WRITEAPPEND(v_json, LENGTH(v_temp), v_temp);
    END LOOP;
    CLOSE v_resultado;
    DBMS_LOB.WRITEAPPEND(v_json, LENGTH(' ]'), ' ]');
    RETURN v_json;
EXCEPTION
    WHEN OTHERS THEN
        RETURN '{ "error": "' || SQLERRM || '" }';
END FN_OBTENER_COBERTURAS;
/

CREATE OR REPLACE PUBLIC SYNONYM FN_OBTENER_COBERTURAS FOR SICAS_OC.FN_OBTENER_COBERTURAS
/

GRANT EXECUTE ON SICAS_OC.FN_OBTENER_COBERTURAS TO PUBLIC
/
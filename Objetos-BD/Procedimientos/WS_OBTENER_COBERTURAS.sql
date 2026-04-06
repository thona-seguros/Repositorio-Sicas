create or replace PROCEDURE SICAS_OC.WS_OBTENER_COBERTURAS (
    p_idpoliza      IN NUMBER,
    p_codsubgrupo  IN NUMBER DEFAULT NULL, 
    p_codasegurado IN NUMBER DEFAULT NULL, 
    p_codcia       IN NUMBER DEFAULT NULL,
    p_codempresa   IN NUMBER DEFAULT NULL,  
    p_resultado     OUT SYS_REFCURSOR
) AS
BEGIN
    -- Apertura del cursor dinámico para retornar el resultado
    OPEN p_resultado FOR
        SELECT DISTINCT 
            CA.CodCobert, 
            DP.IDetPol,
            CAST(CA.SumaAseg_Local AS NUMBER(20,2)) AS SumaAseg_Local, 
            CAST(CA.SumaAseg_Moneda AS NUMBER(20,2)) AS SumaAseg_Moneda, 
            CAST(0 AS NUMBER(10,2)) AS Tasa, 
            CAST(0 AS NUMBER(10,2)) AS Prima_Local, 
            CAST(0 AS NUMBER(10,2)) AS Prima_Moneda, 
            CA.Cod_Moneda,
            CAST(CA.Deducible_Local AS NUMBER(20,2)) AS Deducible_Local, 
            CAST(CA.Deducible_Moneda AS NUMBER(20,2)) AS Deducible_Moneda, 
            CA.StsCobertura,
            OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', CA.StsCobertura) AS cDescStatus,
            OC_COBERTURAS_DE_SEGUROS.DESCRIPCION_COBERTURA(CA.CodCia, CA.CodEmpresa, CA.IdTipoSeg, CA.PlanCob, CA.CodCobert) AS DescCobertura,
            DP.CodFilial AS CodSubGrupo, 
            DP.CodCategoria AS CodCategoria,
            OC_FILIALES.NOMBRE_FILIAL(CA.CodCia, PO.CodGrupoEC, DP.CodFilial) AS DesSubgrupo,
            OC_FILIALES_CATEGORIAS.DESCRIPCION_CATEGORIA(CA.CodCia, PO.CodGrupoEC, DP.CodFilial, DP.CodCategoria) AS DesCategoria,
            CA.CodEmpresa, 
            CA.IdTipoSeg, 
            CA.PlanCob,
            CA.Cod_Asegurado
        FROM COBERT_ACT_ASEG CA
        JOIN POLIZAS PO ON CA.IdPoliza = PO.IdPoliza
        JOIN DETALLE_POLIZA DP ON CA.IdPoliza = DP.IdPoliza AND CA.IDetPol = DP.IDetPol
       WHERE CA.IdPoliza      = p_idpoliza
         AND CA.CodCia = p_codcia
         AND CA.codempresa = p_codempresa
         --AND (DP.CodFilial = p_codsubgrupo OR p_codsubgrupo IS NULL)
         AND (DP.IDetPol = p_codsubgrupo OR p_codsubgrupo IS NULL)
         AND (CA.Cod_Asegurado = p_codasegurado OR p_codasegurado IS NULL)
         
        UNION 
        
        SELECT DISTINCT 
            CT.CodCobert, 
            DP.IDetPol,
            CAST(CT.SumaAseg_Local AS NUMBER(20,2)) AS SumaAseg_Local, 
            CAST(CT.SumaAseg_Moneda AS NUMBER(20,2)) AS SumaAseg_Moneda, 
            CAST(0 AS NUMBER(10,2)) AS Tasa, 
            CAST(0 AS NUMBER(10,2)) AS Prima_Local, 
            CAST(0 AS NUMBER(10,2)) AS Prima_Moneda, 
            CT.Cod_Moneda,
            CAST(CT.Deducible_Local AS NUMBER(20,2)) AS Deducible_Local, 
            CAST(CT.Deducible_Moneda AS NUMBER(20,2)) AS Deducible_Moneda, 
            CT.StsCobertura,
            OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', CT.StsCobertura) AS cDescStatus,
            OC_COBERTURAS_DE_SEGUROS.DESCRIPCION_COBERTURA(CT.CodCia, CT.CodEmpresa, CT.IdTipoSeg, CT.PlanCob, CT.CodCobert) AS DescCobertura,
            DP.CodFilial AS CodSubGrupo, 
            DP.CodCategoria AS CodCategoria,
            OC_FILIALES.NOMBRE_FILIAL(CT.CodCia, PO.CodGrupoEC, DP.CodFilial) AS DesSubgrupo,
            OC_FILIALES_CATEGORIAS.DESCRIPCION_CATEGORIA(CT.CodCia, PO.CodGrupoEC, DP.CodFilial, DP.CodCategoria) AS DesCategoria,
            CT.CodEmpresa, 
            CT.IdTipoSeg, 
            CT.PlanCob,
            CT.Cod_Asegurado
        FROM COBERT_ACT CT
        JOIN POLIZAS PO ON CT.IdPoliza = PO.IdPoliza
        JOIN DETALLE_POLIZA DP ON CT.IdPoliza = DP.IdPoliza AND CT.IDetPol = DP.IDetPol
        WHERE CT.IdPoliza      = p_idpoliza
          AND CT.CodCia = p_codcia
          AND CT.codempresa = p_codempresa
          --AND (DP.CodFilial = p_codsubgrupo OR p_codsubgrupo IS NULL)
         AND (DP.IDetPol = p_codsubgrupo OR p_codsubgrupo IS NULL)
          AND (CT.Cod_Asegurado = p_codasegurado OR p_codasegurado IS NULL);
END WS_OBTENER_COBERTURAS;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_OBTENER_COBERTURAS FOR SICAS_OC.WS_OBTENER_COBERTURAS
/

GRANT EXECUTE ON SICAS_OC.WS_OBTENER_COBERTURAS TO PUBLIC
/
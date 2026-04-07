create or replace PROCEDURE SICAS_OC.WS_OBTIENE_POLIZAS_ASEGURADO2 (
    p_codasegurado IN NUMBER,
    p_codcia       IN NUMBER DEFAULT NULL,
    p_codempresa   IN NUMBER DEFAULT NULL, 
    p_resultado    OUT SYS_REFCURSOR
) AS
    v_tipo_doc_identificacion ASEGURADO.TIPO_DOC_IDENTIFICACION%TYPE;
    v_num_doc_identificacion  ASEGURADO.NUM_DOC_IDENTIFICACION%TYPE;
BEGIN
    -- Obtener el tipo y número de documento de identificación del asegurado
    SELECT TIPO_DOC_IDENTIFICACION, NUM_DOC_IDENTIFICACION
    INTO v_tipo_doc_identificacion, v_num_doc_identificacion
    FROM ASEGURADO
    WHERE COD_ASEGURADO = p_codasegurado;
    -- Abrir el cursor con la consulta principal
    OPEN p_resultado FOR
    SELECT DISTINCT 
        THONAPI.FLUJO_SINIESTROS_SIGO.agente(
            v_tipo_doc_identificacion,
            v_num_doc_identificacion,
            p.idpoliza,
            dp.idetpol
        ) AS COD_ASEGURADO,
        P.CodCliente,
        REPLACE(OC_CLIENTES.NOMBRE_CLIENTE(P.CodCliente), ',') AS NomContratante,
        P.NumPolUnico,
        DP.IdPoliza,
        DP.IDetPol,
        sicas_apex.get_fecha_pago(1, DP.IdPoliza) AS fecpago,
        DP.FecIniVig,
        DP.FecFinVig,
        DP.IdTipoSeg,
        DP.PlanCob,
        DP.StsDetalle,
        DP.CodEmpresa,
        P.IndPolCol,
        OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(DP.CodCia, DP.CodEmpresa, DP.IdTipoSeg) AS DescTipoSeg,
        OC_PLAN_COBERTURAS.NOMBRE_PLANCOB(DP.CodCia, DP.CodEmpresa, DP.IdTipoSeg, DP.PlanCob) AS DescPlanCob,
        OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ESTADOS', DP.StsDetalle) AS DescStatus,
        P.NUMPOLREF,    
        P.CodCia AS CodCia,
        P.TipoAdministracion,
        OC_VALORES_DE_LISTAS.BUSCA_LVALOR('ADMINPOL', P.TipoAdministracion) AS DescTipoAdmon,
        OC_PLAN_DE_PAGOS.DESCRIPCION_PLAN(DP.CodCia, DP.CodEmpresa, DP.CodPlanPago) AS PlanPago,
        OC_PLAN_DE_PAGOS.FRECUENCIA_PAGOS(DP.CodCia, DP.CodEmpresa, DP.CodPlanPago) AS FrecPago,
        P.CodGrupoEc AS CodGrupoEc,
        DP.CodFilial AS CodFilial,
        DP.CodCategoria AS CodCategoria,
        P.DescPoliza,
        AP.Cod_Agente AS CodAgente,
        OC_AGENTES.NOMBRE_AGENTE(DP.CodCia, AP.Cod_Agente) AS NomAgente,
        P.FecRenovacion AS FecRenovacion,
        SICAS_APEX.GET_ESTATUS_PAGO(P.CODCIA, P.IDPOLIZA) AS StsPoliza,
        P.IndFacturaPol,
        P.CodAgrupador,
        OC_VALORES_DE_LISTAS.BUSCA_LVALOR('AGRUPA', P.CodAgrupador) AS DescAgrupador,
        SICAS_APEX.TRAE_NOMBRE_SUBGRUPO(DP.CodCia, DP.CodFilial, P.CodGrupoEc) AS DESC_SUBGRUPO,
        OC_FILIALES_CATEGORIAS.DESCRIPCION_CATEGORIA(DP.CODCIA, P.CodGrupoEc, DP.CodFilial, DP.CodCategoria) AS DESC_CATEGORIA,
        P.ASEGADHERIDOSPOR,
        OC_VALORES_DE_LISTAS.BUSCA_LVALOR('PRESCONT', P.ASEGADHERIDOSPOR) AS DESCASEGADHERIDOSPOR,       
        VL.CODVALOR AS ID_Ramo,          
        VL.DESCVALLST AS Desc_Ramo       
    FROM POLIZAS P
    JOIN DETALLE_POLIZA DP ON DP.IdPoliza = P.IdPoliza AND DP.CodEmpresa = P.CodEmpresa AND DP.CodCia = P.CodCia
    JOIN TIPOS_DE_SEGUROS TS ON TS.CODCIA  = DP.CODCIA AND TS.CODEMPRESA = DP.CODEMPRESA AND TS.IDTIPOSEG  = DP.IDTIPOSEG
    JOIN VALORES_DE_LISTAS VL ON VL.CODLISTA = 'CODRAMOS' AND VL.CODVALOR = TS.CODTIPOPLAN
    JOIN AGENTE_POLIZA AP ON AP.CODCIA = P.CODCIA AND AP.IDPOLIZA = P.IDPOLIZA AND AP.IND_PRINCIPAL = 'S'
    WHERE P.CodCia = p_codcia
      AND P.codempresa = p_codempresa
      AND THONAPI.FLUJO_SINIESTROS_SIGO.agente(
            v_tipo_doc_identificacion,
            v_num_doc_identificacion,
            p.idpoliza,
            dp.idetpol
          ) = p_codasegurado
      AND (P.IdPoliza, DP.IDetPol) IN (
          SELECT DISTINCT AC.IdPoliza, AC.IDetPol
          FROM ASEGURADO A
          JOIN ASEGURADO_CERTIFICADO AC ON AC.CodCia = A.CodCia AND AC.Cod_Asegurado = A.Cod_Asegurado
          --WHERE A.COD_ASEGURADO = p_codasegurado
          WHERE A.TIPO_DOC_IDENTIFICACION = v_tipo_doc_identificacion
            AND A.NUM_DOC_IDENTIFICACION = v_num_doc_identificacion
          UNION 
          SELECT DISTINCT AC.IdPoliza, AC.IDetPol
          FROM ASEGURADO A
          JOIN ASEGURADO_CERT AC ON AC.CodCia = A.CodCia AND AC.Cod_Asegurado = A.Cod_Asegurado
          WHERE A.TIPO_DOC_IDENTIFICACION = v_tipo_doc_identificacion
            AND A.NUM_DOC_IDENTIFICACION = v_num_doc_identificacion
          UNION
          SELECT DISTINCT D.IdPoliza, D.IDetPol
          FROM ASEGURADO A
          JOIN DETALLE_POLIZA D ON D.CodCia = A.CodCia AND D.Cod_Asegurado = A.Cod_Asegurado
          WHERE OC_ASEGURADO_CERTIFICADO.TIENE_ASEGURADOS(D.CodCia, D.IdPoliza, D.IDetPol, 0) = 'N'
            AND A.TIPO_DOC_IDENTIFICACION = v_tipo_doc_identificacion
            AND A.NUM_DOC_IDENTIFICACION = v_num_doc_identificacion
          UNION
          SELECT DISTINCT D.IdPoliza, D.IDetPol
          FROM ASEGURADO A
          JOIN CLIENTES C ON A.NUM_DOC_IDENTIFICACION = C.NUM_DOC_IDENTIFICACION AND A.TIPO_DOC_IDENTIFICACION = C.TIPO_DOC_IDENTIFICACION
          JOIN POLIZAS P2 ON P2.CodCliente = C.CodCliente
          JOIN DETALLE_POLIZA D ON D.IdPoliza = P2.IdPoliza AND D.CodCia = P2.CodCia
          WHERE A.TIPO_DOC_IDENTIFICACION = v_tipo_doc_identificacion
            AND A.NUM_DOC_IDENTIFICACION = v_num_doc_identificacion
      );
END WS_OBTIENE_POLIZAS_ASEGURADO2;
/

CREATE OR REPLACE PUBLIC SYNONYM WS_OBTIENE_POLIZAS_ASEGURADO2 FOR SICAS_OC.WS_OBTIENE_POLIZAS_ASEGURADO2
/

GRANT EXECUTE ON SICAS_OC.WS_OBTIENE_POLIZAS_ASEGURADO2 TO PUBLIC
/
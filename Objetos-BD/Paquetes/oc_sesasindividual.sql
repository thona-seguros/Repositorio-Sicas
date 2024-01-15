CREATE OR REPLACE PACKAGE SICAS_OC.OC_SESASINDIVIDUAL IS
    PROCEDURE DATGEN_VI (
        nCodCia           SICAS_OC.SESAS_DATGEN.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_DATGEN.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_DATGEN.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_DATGEN.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_DATGEN.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    );

    PROCEDURE EMISION_VI (
        nCodCia           SICAS_OC.SESAS_EMISION.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_EMISION.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_EMISION.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    );

    PROCEDURE SINIESTROS_VI (
        nCodCia           SICAS_OC.SESAS_SINIESTROS.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_SINIESTROS.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_SINIESTROS.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_SINIESTROS.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_SINIESTROS.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    );

    PROCEDURE DATGEN_AP (
        nCodCia           SICAS_OC.SESAS_DATGEN.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_DATGEN.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_DATGEN.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_DATGEN.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_DATGEN.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    );

    PROCEDURE EMISION_AP (
        nCodCia           SICAS_OC.SESAS_EMISION.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_EMISION.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_EMISION.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    );

    PROCEDURE SINIESTROS_AP (
        nCodCia           SICAS_OC.SESAS_SINIESTROS.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_SINIESTROS.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_SINIESTROS.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_SINIESTROS.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_SINIESTROS.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    );

    PROCEDURE DATGEN_GM (
        nCodCia           SICAS_OC.SESAS_DATGEN.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_DATGEN.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_DATGEN.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_DATGEN.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_DATGEN.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    );

    PROCEDURE EMISION_GM (
        nCodCia           SICAS_OC.SESAS_EMISION.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_EMISION.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_EMISION.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    );

    PROCEDURE SINIESTROS_GM (
        nCodCia           SICAS_OC.SESAS_SINIESTROS.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_SINIESTROS.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_SINIESTROS.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_SINIESTROS.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_SINIESTROS.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    );

    dvarFecDesde        DATE;
    dvarFecHasta        DATE;
    nEjecucion          NUMBER;
    nMontoDeducible     NUMBER;
    NMONTORECLAMO       NUMBER;
    nComisionDirecta2   NUMBER;
    vl_Total1           NUMBER;
    vl_Total2           NUMBER;

END OC_SESASINDIVIDUAL;
/

CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_SESASINDIVIDUAL IS

    PROCEDURE DATGEN_VI (
        nCodCia           SICAS_OC.SESAS_DATGEN.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_DATGEN.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_DATGEN.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_DATGEN.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_DATGEN.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    ) IS

        CURSOR CUR_PRINCIPAL IS
        SELECT
            nCodCia,
            nCodEmpresa,
            cCodReporteDatGen,
            cCodUsuario,
            P.NumPolUnico                                                                                                         NumPoliza,
            NVL(TRIM(LPAD(XX.IdPoliza, 8, '0'))
                || TRIM(LPAD(XX.IDetPol, 2, '0'))
                || TRIM(LPAD(XX.Cod_Asegurado, 10, '0')), TRIM(LPAD(D.IdPoliza, 8, '0'))
                                                          || TRIM(LPAD(D.IDetPol, 2, '0'))
                                                          || TRIM(LPAD(D.Cod_Asegurado, 10, '0')))                                                                              NumCertificado,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOSEGURO(CS.TipoSeguro, NULL)                                                          TipoSeguro,
            DECODE(P.Cod_Moneda, 'PS', '10', 'USD', '20',
                   '30')                                                                                                          Moneda,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(PN.CodPaisRes, PN.CodProvRes, PN.CODPAISRES, PN.CODPROVRES, P.IdPoliza) EntidadAsegurado,
            D.FecIniVig                                                                                                           FecIniVig,
            CASE WHEN OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob) IN ( '2', '02' ) THEN TO_DATE('31/12/9999', 'DD/MM/YYYY') ELSE D.FecFinVig END  FecFinVig,
            D.FecIniVig                                                                                                           FecAltCert,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, D.FecAnul, dFecDesde,dFecHasta,'VII')                  FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT(D.CodCia, D.IdPoliza, D.IDETPOL, D.FecAnul, dFecHasta, D.StsDetalle, D.FecIniVig, D.FecFinVig, NVL(XX.COD_ASEGURADO, D.COD_ASEGURADO)) StatusCert,
            SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA(D.CodCia, D.IdPoliza)                                                         FormaVta,
            NVL(CS.SubTipoSeg, '1')                                                                                               SubTipoSeg,
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            ( CASE WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN 1 ELSE CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) END ) AnioPoliza,
            SUBSTR(PN.CodActividad, 1, 3)                                                                                         Ocupacion,
            NVL(CS.TipoRiesgo, '1')                                                                                               TipoRiesgo,
            SICAS_OC.OC_PROCESOSSESAS.GETPRIMACEDIDA(D.CodCia, P.IdPoliza)                                                        PrimaCedida,
            SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(D.CodCia, D.CodEmpresa, P.IdPoliza, dFecDesde, dFecHasta)                  ComisionDirecta,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, P.IdPoliza)                                                          MontoDividendo,
            D.IdPoliza,
            D.IDetPol,
            NVL(XX.COD_ASEGURADO, D.COD_ASEGURADO)                                                                                Cod_Asegurado,
            NVL(PC.PLANPOLIZA, '01')                                                                                               PlanPoliza,
            NVL(CS.MODALPOLIZA, '1')                                                                                              ModalidadPoliza,
            DECODE(P.CodPlanPago, 'CONT', '1', 'UNIC', '1', '3')                                                                    FormaPago,
            ( CASE WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN  1 ELSE  CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)  END  )   PlazoPagoPrima,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, P.IdPoliza, 'VII')                                                    Coaseguro,
            DECODE(P.NumRenov, 0, 0, 1)                                                                                           Emision,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONINV(D.CodCia, P.IdPoliza)                                                          SdoFonInv,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONADM(D.CodCia, P.IdPoliza)                                                          SdoFonAdm,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTORESCATE(D.CodCia, P.IdPoliza)                                                        MontoRescate
        FROM SICAS_OC.POLIZAS P
        INNER JOIN SICAS_OC.DETALLE_POLIZA                  D
            ON D.IdPoliza = P.IdPoliza
            AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            AND D.CodCia = P.CodCia
        LEFT JOIN SICAS_OC.ASEGURADO_CERTIFICADO    XX 
            ON XX.CodCia = D.CodCia
            AND XX.IdPoliza = D.IdPoliza
            AND XX.IdetPol = D.IDetPol
        INNER JOIN SICAS_OC.ASEGURADO                A 
            ON A.Cod_Asegurado = NVL(XX.Cod_Asegurado,D.Cod_Asegurado)
        INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN 
            ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
            AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
        INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC 
            ON PC.CodCia = D.CodCia
            AND PC.CodEmpresa = D.CodEmpresa
            AND PC.IdTipoSeg = D.IdTipoSeg
            AND PC.PlanCob = D.PlanCob
        INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO CS 
            ON CS.CodCia = PC.CodCia
            AND CS.CodEmpresa = PC.CodEmpresa
            AND CS.IdTipoSeg = PC.IdTipoSeg
        WHERE D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND (P.FecEmision <= dvarFecHasta AND D.FecFinVig >= dvarFecDesde)

            AND D.IDetPol > 0
            AND D.IdPoliza > 0
            AND P.NumPolUnico NOT LIKE 'TRD%' -- Infonacot
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )

            AND ( PC.CodTipoPlan = '011'
                  OR ( EXISTS (
                SELECT
                    'S'
                FROM
                    SICAS_OC.COBERTURAS_DE_SEGUROS CAS
                WHERE
                        CAS.CODCIA = D.CodCia
                    AND CAS.CodEmpresa = D.CodEmpresa
                    AND CAS.IDTIPOSEG = D.IdTipoSeg
                    AND CAS.PLANCOB = D.PLANCOB
                    AND CAS.IDRAMOREAL = '010'
                    AND CAS.CODCOBERT IN (
                        SELECT
                            CODCOBERT
                        FROM
                            SICAS_OC.COBERTURAS X
                        WHERE
                                X.IDPOLIZA = D.IdPoliza
                            AND X.IDETPOL = D.IDETPOL
                            AND D.IDTIPOSEG = X.IDTIPOSEG
                    )
            )
                       AND PC.CodTipoPlan = '099'
                       AND PC.IdTipoSeg = 'PPAQI' ) )
            AND ( ( cFiltrarPolizas = 'N' )
                  OR ( cFiltrarPolizas = 'S'
                       AND D.IdPoliza IN (
                SELECT
                    IdPoliza
                FROM
                    SICAS_OC.FILTRAR_POLIZAS_SESAS
                WHERE
                        CodCia = nCodCia
                    AND CodEmpresa = nCodEmpresa
                    AND ProcesoSesas = cCodReporteProces
                    AND UsuarioCarga = cCodUsuario
                    AND Observacion = 'OK'
            ) ) )
        UNION ALL
        SELECT
            nCodCia,
            nCodEmpresa,
            cCodReporteDatGen,
            cCodUsuario,
            P.NumPolUnico                                                                                                         NumPoliza,
            NVL(TRIM(LPAD(XX.IdPoliza, 8, '0'))
                || TRIM(LPAD(XX.IDetPol, 2, '0'))
                || TRIM(LPAD(XX.Cod_Asegurado, 10, '0')), TRIM(LPAD(D.IdPoliza, 8, '0'))
                                                          || TRIM(LPAD(D.IDetPol, 2, '0'))
                                                          || TRIM(LPAD(D.Cod_Asegurado, 10, '0')))                                                                              NumCertificado,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOSEGURO(CS.TipoSeguro, NULL)                                                          TipoSeguro,
            DECODE(P.Cod_Moneda, 'PS', '10', 'USD', '20',
                   '30')                                                                                                          Moneda,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(PN.CodPaisRes, PN.CodProvRes, PN.CODPAISRES, PN.CODPROVRES, P.IdPoliza) EntidadAsegurado,
            D.FecIniVig                                                                                                           FecIniVig,
            CASE
                WHEN OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob) IN ( '2', '02' ) THEN
                    TO_DATE('31/12/9999', 'DD/MM/YYYY')
                ELSE
                    D.FecFinVig
            END                                                                                                                   FecFinVig,
            D.FecIniVig                                                                                                           FecAltCert,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, D.FecAnul, dFecDesde,dFecHasta,'VII')                  FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT(D.CodCia, D.IdPoliza, D.IDETPOL, D.FecAnul, dFecHasta,
                                                    D.StsDetalle, D.FecIniVig, D.FecFinVig, NVL(XX.COD_ASEGURADO, D.COD_ASEGURADO))             StatusCert,
            SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA(D.CodCia, D.IdPoliza)                                                         FormaVta,
            NVL(CS.SubTipoSeg, '1')                                                                                               SubTipoSeg,
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            (
                CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END
            )                                                                                                                     AnioPoliza,
            SUBSTR(PN.CodActividad, 1, 3)                                                                                         Ocupacion,
            NVL(CS.TipoRiesgo, '1')                                                                                               TipoRiesgo,
            SICAS_OC.OC_PROCESOSSESAS.GETPRIMACEDIDA(D.CodCia, P.IdPoliza)                                                        PrimaCedida,
            SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(D.CodCia, D.CodEmpresa, P.IdPoliza, dFecDesde, dFecHasta)                  ComisionDirecta,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, P.IdPoliza)                                                          MontoDividendo,
            D.IdPoliza,
            D.IDetPol,
            NVL(XX.COD_ASEGURADO, D.COD_ASEGURADO)                                                                                Cod_Asegurado,
            NVL(PC.PLANPOLIZA, '01')                                                                                                PlanPoliza,
            NVL(CS.MODALPOLIZA, '1')                                                                                              ModalidadPoliza,
            DECODE(P.CodPlanPago, 'CONT', '1', 'UNIC', '1',  '3')                                                                                                           FormaPago,
            (  CASE  WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN  1  ELSE  CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) END ) PlazoPagoPrima,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, P.IdPoliza, 'VII')                                                    Coaseguro,
            DECODE(P.NumRenov, 0, 0, 1)                                                                                           Emision,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONINV(D.CodCia, P.IdPoliza)                                                          SdoFonInv,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONADM(D.CodCia, P.IdPoliza)                                                          SdoFonAdm,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTORESCATE(D.CodCia, P.IdPoliza)                                                        MontoRescate
        FROM SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA                  D ON D.CodCia = P.CodCia
                                             AND D.IdPoliza = P.IdPoliza
                                             AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            LEFT JOIN SICAS_OC.ASEGURADO_CERTIFICADO    XX 
                ON XX.CodCia = D.CodCia
                AND XX.IdPoliza = D.IdPoliza
                AND XX.IdetPol = D.IDetPol
            INNER JOIN SICAS_OC.ASEGURADO                A 
                ON A.Cod_Asegurado = NVL(XX.Cod_Asegurado,D.Cod_Asegurado)
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
                                                               AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
            INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC ON PC.CodCia = D.CodCia
                                                      AND PC.CodEmpresa = D.CodEmpresa
                                                      AND PC.IdTipoSeg = D.IdTipoSeg
                                                      AND PC.PlanCob = D.PlanCob
            INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO CS ON CS.CodCia = PC.CodCia
                                                               AND CS.CodEmpresa = PC.CodEmpresa
                                                               AND CS.IdTipoSeg = PC.IdTipoSeg
        WHERE
                D.StsDetalle = 'ANU'
            AND D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND D.IDetPol > 0
            AND D.IdPoliza > 0
            AND P.NumPolUnico NOT LIKE 'TRD%' -- Infonacot
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
            AND ( PC.CodTipoPlan = '011'
                  OR ( EXISTS (
                SELECT  'S'
                FROM  SICAS_OC.COBERTURAS_DE_SEGUROS CAS
                WHERE CAS.CODCIA = D.CodCia
                    AND CAS.CodEmpresa = D.CodEmpresa
                    AND CAS.IDTIPOSEG = D.IdTipoSeg
                    AND CAS.PLANCOB = D.PLANCOB
                    AND CAS.IDRAMOREAL = '010'
                    AND CAS.CODCOBERT IN (
                        SELECT  CODCOBERT
                        FROM  SICAS_OC.COBERTURAS X
                        WHERE
                                X.IDPOLIZA = D.IdPoliza
                            AND X.IDETPOL = D.IDETPOL
                            AND D.IDTIPOSEG = X.IDTIPOSEG
                    )
            )
                       AND PC.CodTipoPlan = '099'
                       AND PC.IdTipoSeg = 'PPAQI' ) )
            AND EXISTS (
                SELECT /*+ INDEX(DT SYS_C0031885) */
                    'S'
                FROM
                         SICAS_OC.TRANSACCION T
                    INNER JOIN SICAS_OC.DETALLE_TRANSACCION DT ON DT.IdTransaccion = T.IdTransaccion
                                                                  AND DT.CodCia = T.CodCia
                WHERE
                        DT.Valor1 = D.IdPoliza
                    AND DT.Valor2 = D.IDetPol
                    AND DT.Correlativo > 0
                    AND DT.CodSubProceso NOT IN ( 'ESV', 'PAG' )
                    AND T.CodCia = D.CodCia
                    AND T.CodEmpresa = D.CodEmpresa
                    AND T.IdTransaccion > 0
                    AND T.IdProceso = 2
                    AND T.FechaTransaccion BETWEEN dvarFecDesde AND dvarFecHasta
            )
            AND ( ( cFiltrarPolizas = 'N' )
                  OR ( cFiltrarPolizas = 'S'
                       AND D.IdPoliza IN (
                SELECT
                    IdPoliza
                FROM
                    SICAS_OC.FILTRAR_POLIZAS_SESAS
                WHERE
                        CodCia = nCodCia
                    AND CodEmpresa = nCodEmpresa
                    AND ProcesoSesas = cCodReporteProces
                    AND UsuarioCarga = cCodUsuario
                    AND Observacion = 'OK'
            ) ) )
        UNION ALL
        SELECT
            nCodCia,
            nCodEmpresa,
            cCodReporteDatGen,
            cCodUsuario,
            P.NumPolUnico                                                                                                         NumPoliza,
            NVL(TRIM(LPAD(XX.IdPoliza, 8, '0'))
                || TRIM(LPAD(XX.IDetPol, 2, '0'))
                || TRIM(LPAD(XX.Cod_Asegurado, 10, '0')), TRIM(LPAD(D.IdPoliza, 8, '0'))
                                                          || TRIM(LPAD(D.IDetPol, 2, '0'))
                                                          || TRIM(LPAD(D.Cod_Asegurado, 10, '0')))                                                                              NumCertificado,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOSEGURO(CS.TipoSeguro, NULL)                                                          TipoSeguro,
            DECODE(P.Cod_Moneda, 'PS', '10', 'USD', '20',
                   '30')                                                                                                          Moneda,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(PN.CodPaisRes, PN.CodProvRes, PN.CODPAISRES, PN.CODPROVRES, P.IdPoliza) EntidadAsegurado,
            D.FecIniVig                                                                                                           FecIniVig,
            CASE
                WHEN OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob) IN ( '2', '02' ) THEN
                    TO_DATE('31/12/9999', 'DD/MM/YYYY')
                ELSE
                    D.FecFinVig
            END                                                                                                                   FecFinVig,
            D.FecIniVig                                                                                                           FecAltCert,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, D.FecAnul, dFecDesde,dFecHasta,'VII')                  FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT(D.CodCia, D.IdPoliza, D.IDETPOL, D.FecAnul, dFecHasta,
                                                    D.StsDetalle, D.FecIniVig, D.FecFinVig, NVL(XX.COD_ASEGURADO, D.COD_ASEGURADO))             StatusCert,
            SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA(D.CodCia, D.IdPoliza)                                                         FormaVta,
            NVL(CS.SubTipoSeg, '1')                                                                                               SubTipoSeg,
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            (
                CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END
            )                                                                                                                     AnioPoliza,
            SUBSTR(PN.CodActividad, 1, 3)                                                                                         Ocupacion,
            NVL(CS.TipoRiesgo, '1')                                                                                               TipoRiesgo,
            SICAS_OC.OC_PROCESOSSESAS.GETPRIMACEDIDA(D.CodCia, P.IdPoliza)                                                        PrimaCedida,
            SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(D.CodCia, D.CodEmpresa, P.IdPoliza, dFecDesde, dFecHasta)                  ComisionDirecta,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, P.IdPoliza)                                                          MontoDividendo,
            D.IdPoliza,
            D.IDetPol,
            NVL(XX.COD_ASEGURADO, D.COD_ASEGURADO)                                                                                Cod_Asegurado,
            NVL(PC.PLANPOLIZA, '01')                                                                                             PlanPoliza,
            NVL(CS.MODALPOLIZA, '1')                                                                                              ModalidadPoliza,
            DECODE(P.CodPlanPago, 'CONT', '1', 'UNIC', '1',  '3') FormaPago,
            (
                CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END
            )                                                                                                                     PlazoPagoPrima,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, P.IdPoliza, 'VII')                                                    Coaseguro,
            DECODE(P.NumRenov, 0, 0, 1)                                                                                           Emision,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONINV(D.CodCia, P.IdPoliza)                                                          SdoFonInv,
            SICAS_OC.OC_PROCESOSSESAS.GETSDOFONADM(D.CodCia, P.IdPoliza)                                                          SdoFonAdm,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTORESCATE(D.CodCia, P.IdPoliza)                                                        MontoRescate
        FROM
                 SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA                  D ON  D.IdPoliza = P.IdPoliza
                                             AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
                                             AND D.CodCia = P.CodCia
            LEFT JOIN SICAS_OC.ASEGURADO_CERTIFICADO    XX 
                ON XX.CodCia = D.CodCia
                AND XX.IdPoliza = D.IdPoliza
                AND XX.IdetPol = D.IDetPol
            INNER JOIN SICAS_OC.ASEGURADO                A 
                ON A.Cod_Asegurado = NVL(XX.Cod_Asegurado,D.Cod_Asegurado)
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
                                                               AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
            INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC ON PC.CodCia = D.CodCia
                                                      AND PC.CodEmpresa = D.CodEmpresa
                                                      AND PC.IdTipoSeg = D.IdTipoSeg
                                                      AND PC.PlanCob = D.PlanCob
            INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO CS ON CS.CodCia = PC.CodCia
                                                               AND CS.CodEmpresa = PC.CodEmpresa
                                                               AND CS.IdTipoSeg = PC.IdTipoSeg
        WHERE
                D.FecFinVig < dvarFecDesde
            AND D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND D.IDetPol > 0
            AND D.IdPoliza > 0
            AND P.NumPolUnico NOT LIKE 'TRD%' -- Infonacot
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )

            AND ( PC.CodTipoPlan = '011'
                  OR ( EXISTS (
                SELECT  'S'
                FROM SICAS_OC.COBERTURAS_DE_SEGUROS CAS
                WHERE CAS.CODCIA = D.CodCia
                    AND CAS.CodEmpresa = D.CodEmpresa
                    AND CAS.IDTIPOSEG = D.IdTipoSeg
                    AND CAS.PLANCOB = D.PLANCOB
                    AND CAS.IDRAMOREAL = '010'
                    AND CAS.CODCOBERT IN (
                        SELECT CODCOBERT
                        FROM SICAS_OC.COBERTURAS X
                        WHERE X.IDPOLIZA = D.IdPoliza
                            AND X.IDETPOL = D.IDETPOL
                            AND D.IDTIPOSEG = X.IDTIPOSEG  ) )
                       AND PC.CodTipoPlan = '099'
                       AND PC.IdTipoSeg = 'PPAQI' ) )
            AND EXISTS (
                SELECT /*+ INDEX(DT SYS_C0031885) */
                    'S'
                FROM SICAS_OC.TRANSACCION T
                INNER JOIN SICAS_OC.DETALLE_TRANSACCION DT 
                    ON DT.CodCia = T.CodCia
                    AND DT.IdTransaccion = T.IdTransaccion
                WHERE DT.Valor1 = D.IdPoliza
                    AND DT.CodSubProceso NOT IN ( 'ESV', 'PAG' )
                    AND T.CodCia = D.CodCia
                    AND T.CodEmpresa = D.CodEmpresa
                    AND DT.Correlativo > 0
                    AND T.IdTransaccion > 0
                    AND T.IdProceso != 6
                    AND T.FechaTransaccion BETWEEN dvarFecDesde AND dvarFecHasta
            )
            AND ( ( cFiltrarPolizas = 'N' )
                  OR ( cFiltrarPolizas = 'S'
                AND D.IdPoliza IN (
                SELECT IdPoliza
                FROM SICAS_OC.FILTRAR_POLIZAS_SESAS
                WHERE CodCia = nCodCia
                    AND CodEmpresa = nCodEmpresa
                    AND ProcesoSesas = cCodReporteProces
                    AND UsuarioCarga = cCodUsuario
                    AND Observacion = 'OK'
            ) ) );

        TYPE rec_sesasdatgen IS RECORD (
            CODCIA           NUMBER(14, 0),
            CODEMPRESA       NUMBER(14, 0),
            CODREPORTE       VARCHAR2(30),
            CODUSUARIO       VARCHAR2(30),
            NUMPOLIZA        VARCHAR2(30),
            NUMCERTIFICADO   VARCHAR2(30),
            TIPOSEGURO       VARCHAR2(1),
            MONEDA           VARCHAR2(2),
            ENTIDADASEGURADO VARCHAR2(2),
            FECINIVIG        DATE,
            FECFINVIG        DATE,
            FECALTCERT       DATE,
            FECBAJCERT       DATE,
            FECNACIM         DATE,
            FECEMISION       DATE,
            SEXO             VARCHAR2(1),
            STATUSCERT       VARCHAR2(1),
            FORMAVTA         VARCHAR2(2),
            SUBTIPOSEG       VARCHAR2(1),
            TIPODIVIDENDO    VARCHAR2(1),
            ANIOPOLIZA       NUMBER(2, 0),
            OCUPACION        VARCHAR2(3),
            TIPORIESGO       VARCHAR2(1),
            PRIMACEDIDA      NUMBER(18, 2),
            ComisionDirecta  NUMBER,
            MONTODIVIDENDO   NUMBER(23, 2),
            IDPOLIZA         NUMBER(14, 0),
            IDETPOL          NUMBER(14, 0),
            CodAsegurado     NUMBER(14, 0),
            PLANPOLIZA       VARCHAR2(2),
            MODALIDADPOLIZA  VARCHAR2(2),
            FORMAPAGO        VARCHAR2(1),
            PLAZOPAGOPRIMA   NUMBER(2, 0),
            COASEGURO        VARCHAR2(1),
            EMISION          VARCHAR2(1),
            SDOFONINV        NUMBER(23, 2),
            SDOFONADM        NUMBER(23, 2),
            MONTORESCATE     NUMBER(18, 2)
        );
        TYPE type_sesasdatgen IS TABLE OF rec_sesasdatgen;
        obj_sesasdatgen type_sesasdatgen;

    BEGIN

        DELETE SICAS_OC.SESAS_DATGEN
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND NUMPOLIZA >= '0'
            AND NUMCERTIFICADO >= '0';

        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND IDSECUENCIA>=0;

        COMMIT;
        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');

        OPEN CUR_PRINCIPAL;
        LOOP
            FETCH CUR_PRINCIPAL
            BULK COLLECT INTO obj_sesasdatgen;
            FOR x IN 1..obj_sesasdatgen.COUNT LOOP
                BEGIN
                    SELECT SUM(PRIMANETA_MONEDA)
                    INTO nComisionDirecta2
                    FROM SICAS_OC.ASEGURADO_CERTIFICADO
                    WHERE CODCIA = obj_sesasdatgen(x).CodCia
                        AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                        AND IDETPOL = obj_sesasdatgen(x).IDetPol;

                    SELECT NVL((ROUND((100 / nComisionDirecta2), 10) * PRIMANETA_MONEDA) *(ROUND((obj_sesasdatgen(x).ComisionDirecta / 100),10)), 0)
                    INTO nComisionDirecta2
                    FROM SICAS_OC.ASEGURADO_CERTIFICADO
                    WHERE CODCIA = obj_sesasdatgen(x).CodCia
                        AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                        AND IDETPOL = obj_sesasdatgen(x).IDetPol
                        AND COD_ASEGURADO = obj_sesasdatgen(x).CodAsegurado;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN 
                        BEGIN                        
                            SELECT SUM(PRIMA_MONEDA)
                            INTO nComisionDirecta2
                            FROM SICAS_OC.DETALLE_POLIZA
                            WHERE CODCIA = obj_sesasdatgen(x).CodCia
                                AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                                AND IDETPOL >= 1;

                            SELECT NVL((ROUND((100 / nComisionDirecta2), 10) * PRIMA_MONEDA) *(ROUND((obj_sesasdatgen(x).ComisionDirecta / 100),10)), 0)
                            INTO nComisionDirecta2
                            FROM SICAS_OC.DETALLE_POLIZA
                            WHERE CODCIA = obj_sesasdatgen(x).CodCia
                                AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                                AND IDETPOL = obj_sesasdatgen(x).IDetPol
                                AND COD_ASEGURADO = obj_sesasdatgen(x).CodAsegurado;
                        EXCEPTION
                            WHEN OTHERS THEN 
                                nComisionDirecta2 := obj_sesasdatgen(x).ComisionDirecta;
                        END;
                    WHEN OTHERS THEN
                        nComisionDirecta2 := obj_sesasdatgen(x).ComisionDirecta;
                END;

                BEGIN
                --Inserto lo que antes era el cursor: c_archivo
                    INSERT INTO SICAS_OC.SESAS_DATGEN ( CodCia,
                                                        CodEmpresa,
                                                        CodReporte,
                                                        CodUsuario,
                                                        NumPoliza,
                                                        NumCertificado,
                                                        TipoSeguro,
                                                        Moneda,
                                                        EntidadAsegurado,
                                                        FecIniVig,
                                                        FecFinVig,
                                                        FecAltCert,
                                                        FecBajCert,
                                                        FecNacim,
                                                        FecEmision,
                                                        Sexo,
                                                        StatusCert,
                                                        FormaVta,
                                                        SubTipoSeg,
                                                        TipoDividendo,
                                                        AnioPoliza,
                                                        Ocupacion,
                                                        TipoRiesgo,
                                                        PrimaCedida,
                                                        ComisionDirecta,
                                                        MontoDividendo,
                                                        IdPoliza,
                                                        IDetPol,
                                                        CodAsegurado,
                                                        PlanPoliza,
                                                        ModalidadPoliza,
                                                        FormaPago,
                                                        PlazoPagoPrima,
                                                        Coaseguro,
                                                        Emision,
                                                        SdoFonInv,
                                                        SdoFonAdm,
                                                        MontoRescate
                                            ) VALUES (
                                                        obj_sesasdatgen(x).CodCia,
                                                        obj_sesasdatgen(x).CodEmpresa,
                                                        obj_sesasdatgen(x).CodReporte,
                                                        obj_sesasdatgen(x).CodUsuario,
                                                        obj_sesasdatgen(x).NumPoliza,
                                                        obj_sesasdatgen(x).NumCertificado,
                                                        obj_sesasdatgen(x).TipoSeguro,
                                                        obj_sesasdatgen(x).Moneda,
                                                        obj_sesasdatgen(x).EntidadAsegurado,
                                                        obj_sesasdatgen(x).FecIniVig,
                                                        obj_sesasdatgen(x).FecFinVig,
                                                        obj_sesasdatgen(x).FecAltCert,
                                                        obj_sesasdatgen(x).FecBajCert,
                                                        obj_sesasdatgen(x).FecNacim,
                                                        obj_sesasdatgen(x).FecEmision,
                                                        obj_sesasdatgen(x).Sexo,
                                                        obj_sesasdatgen(x).StatusCert,
                                                        obj_sesasdatgen(x).FormaVta,
                                                        obj_sesasdatgen(x).SubTipoSeg,
                                                        obj_sesasdatgen(x).TipoDividendo,
                                                        obj_sesasdatgen(x).AnioPoliza,
                                                        obj_sesasdatgen(x).Ocupacion,
                                                        obj_sesasdatgen(x).TipoRiesgo,
                                                        obj_sesasdatgen(x).PrimaCedida,
                                                        ROUND(nComisionDirecta2, 2),
                                                        obj_sesasdatgen(x).MontoDividendo,
                                                        obj_sesasdatgen(x).IdPoliza,
                                                        obj_sesasdatgen(x).IDetPol,
                                                        obj_sesasdatgen(x).CodAsegurado,
                                                        obj_sesasdatgen(x).PlanPoliza,
                                                        obj_sesasdatgen(x).ModalidadPoliza,
                                                        obj_sesasdatgen(x).FormaPago,
                                                        ( CASE obj_sesasdatgen(x).FormaPago WHEN '1' THEN  1 ELSE obj_sesasdatgen(x).PlazoPagoPrima END ),
                                                        obj_sesasdatgen(x).Coaseguro,
                                                        obj_sesasdatgen(x).Emision,
                                                        obj_sesasdatgen(x).SdoFonInv,
                                                        obj_sesasdatgen(x).SdoFonAdm,
                                                        obj_sesasdatgen(x).MontoRescate
                                                    );

                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,                                              obj_sesasdatgen(x).NumCertificado, SQLCODE, 'El registro ya existe en la SESA, favor de validarlo.');
                    WHEN OTHERS THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, SQLERRM);
                END;

            END LOOP;
            EXIT WHEN obj_sesasdatgen.COUNT = 0;
        END LOOP;
        CLOSE CUR_PRINCIPAL;
        COMMIT;
    END DATGEN_VI;

    PROCEDURE EMISION_VI (
        nCodCia           SICAS_OC.SESAS_EMISION.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_EMISION.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_EMISION.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    ) IS
        nPmaEmiCob         NUMBER(20, 10);
        nMtoAsistLocal     NUMBER(20, 2);
        cStatus1           VARCHAR2(6);
        cStatus2           VARCHAR2(6);
        cStatus3           VARCHAR2(6);
        cStatus4           VARCHAR2(6);
        cStatus5           VARCHAR2(6) := 'SOL';
        cStatus6           VARCHAR2(6) := 'SOLICI';
        cTodasAnuladas     VARCHAR2(1);
        cRecalculoPrimas   VARCHAR2(1);
        nEdad              NUMBER(5);
        nTasa              NUMBER;
        cTipoSumaSeg       VARCHAR2(1);
        nIdPoliza          SICAS_OC.DETALLE_POLIZA.IDPOLIZA%TYPE;
        nIDetPol           SICAS_OC.DETALLE_POLIZA.IDETPOL%TYPE;
        nCod_Asegurado     SICAS_OC.DETALLE_POLIZA.COD_ASEGURADO%TYPE;
        dFecIniVig         SICAS_OC.DETALLE_POLIZA.FECINIVIG%TYPE;
        dFecFinVig         SICAS_OC.DETALLE_POLIZA.FECFINVIG%TYPE;
        nIdPolizaProc      SICAS_OC.POLIZAS.IdPoliza%TYPE;
        nIDetPolProc       SICAS_OC.DETALLE_POLIZA.IDetPol%TYPE;
        nIdPolizaProcCalc  SICAS_OC.POLIZAS.IdPoliza%TYPE := 0;
        nIdPolizaCalc      SICAS_OC.POLIZAS.IdPoliza%TYPE := 0;
        nPrima_Moneda      SICAS_OC.COBERT_ACT.Prima_Moneda%TYPE;
        cCodCobert         SICAS_OC.COBERTURAS_DE_SEGUROS.CodCobert%TYPE;
        nPrimaMonedaTotPol SICAS_OC.POLIZAS.PrimaNeta_Moneda%TYPE;
        nIdTarifa          SICAS_OC.TARIFA_CONTROL_VIGENCIAS.IdTarifa%TYPE;
        cSexo              SICAS_OC.PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
        cRiesgo            SICAS_OC.ACTIVIDADES_ECONOMICAS.RiesgoActividad%TYPE;
        cCodActividad      SICAS_OC.PERSONA_NATURAL_JURIDICA.CodActividad%TYPE;
        nPeriodoEspCob     SICAS_OC.COBERTURAS_DE_SEGUROS.PeriodoEsperaMeses%TYPE;
        nCodAseguradoAfina SICAS_OC.ASEGURADO.COD_ASEGURADO%TYPE;
        nPrimaDevengada    SICAS_OC.SESAS_EMISION.PrimaDevengada%TYPE;
        nNumDiasRenta      SICAS_OC.SESAS_EMISION.NumDiasRenta%TYPE;
        cTipoExtraPrima    SICAS_OC.SESAS_EMISION.TipoExtraPrima%TYPE := '9';  --9 ES NO APLICA

        CURSOR cPolizas_DatGen IS
        SELECT  IdPoliza,
                IDetPol,
                CodAsegurado,
                FecIniVig,
                FECFINVIG,
                fecbajcert,
                TipoDetalle,
                NumPoliza,
                NumCertificado
        FROM SICAS_OC.SESAS_DATGEN
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = 'SESADATVII'
            AND CodUsuario = cCodUsuario
            AND NUMPOLIZA >= '0'
            AND NUMCERTIFICADO >= '0'; --FILTRO POR OSBERVACIONES

        TYPE rec_sesasdatgen IS RECORD (
            IDPOLIZA       NUMBER(14, 0),
            IDETPOL        NUMBER(14, 0),
            CodAsegurado   NUMBER(14, 0),
            FECINIVIG      DATE,
            FECFINVIG      DATE,
            fecbajcert     DATE,
            TIPODETALLE    VARCHAR2(3),
            NUMPOLIZA      VARCHAR2(30),
            NUMCERTIFICADO VARCHAR2(30)
        );
        TYPE type_sesasdatgen IS TABLE OF rec_sesasdatgen;
        obj_sesasdatgen    type_sesasdatgen;

        CURSOR POL_Q IS
        SELECT  P.IdPoliza,
                P.StsPoliza,
                P.TipoAdministracion,
                D.IdTipoSeg,
                D.PlanCob,
                D.FecIniVig
        FROM SICAS_OC.POLIZAS P
        INNER JOIN SICAS_OC.DETALLE_POLIZA D 
            ON D.IdPoliza = P.IdPoliza
            AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            AND D.CodCia = P.CodCia
        WHERE P.CodCia = nCodCia
            AND P.IdPoliza = nIdPolizaProc
            AND P.StsPoliza NOT IN ( 'SOL', 'PRE' )
            AND ( P.MotivAnul IS NULL
                  OR NVL(P.MotivAnul, 'NULL') IS NOT NULL
                  AND P.FecSts BETWEEN dvarFecDesde AND dvarFecHasta )
        UNION
        SELECT  P.IdPoliza,
                P.StsPoliza,
                P.TipoAdministracion,
                D.IdTipoSeg,
                D.PlanCob,
                D.FecIniVig
        FROM SICAS_OC.POLIZAS P
        INNER JOIN SICAS_OC.DETALLE_POLIZA D 
            ON P.IdPoliza = P.IdPoliza
            AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            AND D.CodCia = P.CodCia
        WHERE P.CodCia = nCodCia
            AND D.IDetPol = nIDetPolProc
            AND D.IdPoliza != nIdPolizaProc
            AND P.StsPoliza NOT IN ( 'SOL', 'PRE' )
            AND P.NumPolUnico IN (  SELECT NumPolUnico
                                    FROM SICAS_OC.POLIZAS
                                    WHERE CodCia = nCodCia
                                        AND IdPoliza = nIdPolizaProc)
            AND ( D.MotivAnul IS NULL
                  OR NVL(D.MotivAnul, 'NULL') IS NOT NULL
                  AND D.FecAnul BETWEEN dvarFecDesde AND dvarFecHasta
                  OR P.StsPoliza = 'ANU'
                  AND P.FecSts BETWEEN dvarFecDesde AND dvarFecHasta );

        TYPE rec_sesasdatgen2 IS RECORD (
            IDPOLIZA           NUMBER(14, 0),
            StsPoliza          VARCHAR2(3),
            TipoAdministracion VARCHAR2(6),
            IdTipoSeg          VARCHAR2(6),
            PlanCob            VARCHAR2(15),
            FecIniVig          DATE
        );
        TYPE type_sesasdatgen2 IS TABLE OF rec_sesasdatgen2; 

        obj_sesasdatgen2   type_sesasdatgen2;

        TYPE rec_sesasdatgen4 IS RECORD (
            CodCobert     VARCHAR2(6),
            OrdenSESAS    NUMBER(5, 0),
            PeriodoEspera NUMBER(3, 0),
            ClaveSESAS    VARCHAR2(3),
            Suma_Moneda   NUMBER(18, 6),
            Prima_Moneda  NUMBER(18, 6)
        );

        TYPE type_sesasdatgen4 IS TABLE OF rec_sesasdatgen4;

        obj_sesasdatgen4   type_sesasdatgen4;

        CURSOR COBERT_Q IS
        SELECT C.CodCobert,
                NVL(OrdenSESAS, 0)         OrdenSESAS,
                NVL(PeriodoEsperaMeses, 0) PeriodoEspera,
                NVL(ClaveSESASNEW, '99')   ClaveSESAS,
                --, NVL(NumDiasRenta      ,    0) NumDiasRenta
                (CASE NVL(CLAVESESASNEW, '99') WHEN '10' THEN 0.0  ELSE SUM(SumaAseg_Moneda) END )                          Suma_Moneda,
                SUM(C.Prima_Moneda)        Prima_Moneda
        FROM SICAS_OC.COBERT_ACT C
        INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS 
            ON CS.CodCobert = C.CodCobert
            AND CS.PlanCob = C.PlanCob
            AND CS.IdTipoSeg = C.IdTipoSeg
            AND CS.CodEmpresa = C.CodEmpresa
            AND CS.CodCia = C.CodCia
        WHERE C.StsCobertura NOT IN ( cStatus1, cStatus2, cStatus5 )
          AND C.Cod_Asegurado = nCod_Asegurado
            AND C.IDetPol = nIDetPol
            AND C.IdPoliza = nIdPoliza
            AND C.CodCia = nCodCia
        GROUP BY C.CodCobert,NVL(OrdenSESAS, 0),NVL(PeriodoEsperaMeses, 0),NVL(ClaveSESASNEW, '99')--, NVL(NumDiasRenta, 0)

        UNION ALL

        SELECT
                C.CodCobert,
                NVL(OrdenSESAS, 0)         OrdenSESAS,
                NVL(PeriodoEsperaMeses, 0) PeriodoEspera,
                NVL(ClaveSESASNEW, '99')   ClaveSESAS,
                --, NVL(NumDiasRenta      ,    0) NumDiasRenta
                ( CASE NVL(CLAVESESASNEW, '99') WHEN '10' THEN 0.0 ELSE SUM(SumaAseg_Moneda) END)                          Suma_Moneda,
                SUM(C.Prima_Moneda)        Prima_Moneda
        FROM SICAS_OC.COBERT_ACT_ASEG C
        INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS 
            ON CS.CodCobert = C.CodCobert
            AND CS.PlanCob = C.PlanCob
            AND CS.IdTipoSeg = C.IdTipoSeg
            AND CS.CodEmpresa = C.CodEmpresa
            AND CS.CodCia = C.CodCia
        WHERE C.StsCobertura NOT IN ( cStatus1, cStatus2, cStatus5 )
            AND C.Cod_Asegurado = nCod_Asegurado
            AND C.IDetPol = nIDetPol
            AND C.IdPoliza = nIdPoliza
            AND C.CodCia = nCodCia
        GROUP BY C.CodCobert,NVL(OrdenSESAS, 0),NVL(PeriodoEsperaMeses, 0),NVL(ClaveSESASNEW, '99');--, NVL(NumDiasRenta, 0);

        TYPE rec_sesasdatgen3 IS RECORD (
            Cod_Asegurado   NUMBER(14, 0),
            SumaAseg_Moneda NUMBER(18, 2),
            CodCobert       VARCHAR2(6),
            Tasa            NUMBER(18, 6),
            Porc_Tasa       NUMBER(28, 6),
            CodTarifa       VARCHAR2(30),
            IdTipoSeg       VARCHAR2(6),
            PlanCob         VARCHAR2(15),
            FactorTasa      NUMBER,
            Prima_Cobert    NUMBER(18, 2)
        );

        TYPE type_sesasdatgen3 IS TABLE OF rec_sesasdatgen3;

        obj_sesasdatgen3   type_sesasdatgen3;

        CURSOR CALC_Q IS
        SELECT  C.Cod_Asegurado,
                C.SumaAseg_Moneda,
                C.CodCobert,
                NVL(C.Tasa, 0)                                                   Tasa,
                CS.Porc_Tasa,
                CS.CodTarifa,
                C.IdTipoSeg,
                C.PlanCob,
                DECODE(CS.TipoTasa, 'C', 100, DECODE(CS.TipoTasa, 'M', 1000, 1)) FactorTasa,
                CS.Prima_Cobert
        FROM SICAS_OC.COBERT_ACT C
        INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS 
            ON CS.CodCobert = C.CodCobert
            AND CS.PlanCob = C.PlanCob
            AND CS.IdTipoSeg = C.IdTipoSeg
            AND CS.CodEmpresa = C.CodEmpresa
            AND CS.CodCia = C.CodCia
        WHERE C.SumaAseg_Moneda > 0
            AND C.CodCia = nCodCia
            AND C.IdPoliza = nIdPolizaCalc

        UNION ALL
        SELECT  C.Cod_Asegurado,
                C.SumaAseg_Moneda,
                C.CodCobert,
                NVL(C.Tasa, 0)                                                   Tasa,
                CS.Porc_Tasa,
                CS.CodTarifa,
                C.IdTipoSeg,
                C.PlanCob,
                DECODE(CS.TipoTasa, 'C', 100, DECODE(CS.TipoTasa, 'M', 1000, 1)) FactorTasa,
                CS.Prima_Cobert
        FROM SICAS_OC.COBERT_ACT_ASEG C
        INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS 
            ON CS.CodCobert = C.CodCobert
            AND CS.PlanCob = C.PlanCob
            AND CS.IdTipoSeg = C.IdTipoSeg
            AND CS.CodEmpresa = C.CodEmpresa
            AND CS.CodCia = C.CodCia
        WHERE C.SumaAseg_Moneda > 0
            AND C.CodCia = nCodCia
            AND C.IdPoliza = nIdPolizaCalc;

    BEGIN

        DELETE SICAS_OC.SESAS_EMISION
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND NUMPOLIZA >= '0'
            AND NUMCERTIFICADO >= '0';

        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE  CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND IDSECUENCIA>=0;

        COMMIT;

        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');
        SICAS_OC.OC_SESASINDIVIDUAL.DATGEN_VI(nCodCia, nCodEmpresa, dFecDesde, dFecHasta, cCodUsuario, 'SESADATVII', 'SESADATVII', cFiltrarPolizas);

        --CURSOR cPolizas_DatGen IS
        SELECT  IdPoliza,
                IDetPol,
                CodAsegurado,
                FecIniVig,
                FECFINVIG,
                fecbajcert,
                TipoDetalle,
                NumPoliza,
                NumCertificado
        BULK COLLECT INTO obj_sesasdatgen
        FROM SICAS_OC.SESAS_DATGEN
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = 'SESADATVII'
            AND CodUsuario = cCodUsuario
            AND NUMPOLIZA >= '0'
            AND NUMCERTIFICADO >= '0';

        BEGIN
            OPEN cPolizas_DatGen;
            LOOP
                FETCH cPolizas_DatGen
                BULK COLLECT INTO obj_sesasdatgen;
                FOR x IN 1..obj_sesasdatgen.COUNT LOOP
            --FOR x IN cPolizas_DatGen LOOP

                    nIdPoliza := obj_sesasdatgen(x).IdPoliza;
                    nIDetPol := obj_sesasdatgen(x).IDetPol;
                    nCod_Asegurado := obj_sesasdatgen(x).CodAsegurado;
                    dFecIniVig := obj_sesasdatgen(x).FecIniVig;
                    dFecFinVig := obj_sesasdatgen(x).FecFinVig;
                    nIdPolizaProc := obj_sesasdatgen(x).IdPoliza;
                    nIDetPolProc := obj_sesasdatgen(x).IDetPol;
                    nMtoAsistLocal := 0;
                    nPmaEmiCob := 0;




               --     IF NVL(nIdPolizaProcCalc, 0) != NVL(nIdPoliza, 0) THEN
                        nIdPolizaProcCalc := nIdPoliza;
                        nPrimaMonedaTotPol := 0;
         -- Verifica si Todas Están Anuladas
                        cTodasAnuladas := 'N';
                        FOR z IN POL_Q LOOP
                            IF z.StsPoliza != 'ANU' THEN
                                cTodasAnuladas := 'N';
                                EXIT;
                            ELSE
                                cTodasAnuladas := 'S';
                            END IF;
                        END LOOP;


             --obj_sesasdatgen2

                        OPEN POL_Q;
                        LOOP
                            FETCH POL_Q
                            BULK COLLECT INTO obj_sesasdatgen2;
                            FOR z IN 1..obj_sesasdatgen2.COUNT LOOP

                                IF cTodasAnuladas = 'N' THEN
                                    IF obj_sesasdatgen2(z).StsPoliza IN ( 'EMI', 'REN' ) THEN
                                        cStatus1 := 'CEX';
                                        cStatus2 := ' ';
                                        cStatus3 := 'EXCLUI';
                                        cStatus4 := ' ';
                                    ELSE
                                        cStatus1 := 'CEX';
                                        cStatus2 := 'ANU';
                                        cStatus3 := 'EXCLUI';
                                        cStatus4 := 'ANULAD';
                                    END IF;

                                    SELECT NVL(SUM(Prima_Moneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                                    INTO nPrimaMonedaTotPol
                                    FROM SICAS_OC.COBERT_ACT
                                    WHERE CodCia = nCodCia
                                        AND IdPoliza = obj_sesasdatgen2(z).IdPoliza
                                        AND StsCobertura NOT IN ( cStatus1, cStatus2, cStatus5 );
                    --
                                    SELECT NVL(SUM(MontoAsistMoneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                                    INTO nPrimaMonedaTotPol
                                    FROM SICAS_OC.ASISTENCIAS_DETALLE_POLIZA
                                    WHERE CodCia = nCodCia
                                        AND IdPoliza = obj_sesasdatgen2(z).IdPoliza
                                        AND StsAsistencia NOT IN ( cStatus3, cStatus4, cStatus6 );
                    --
                                    SELECT NVL(SUM(Prima_Moneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                                    INTO nPrimaMonedaTotPol
                                    FROM SICAS_OC.COBERT_ACT_ASEG
                                    WHERE CodCia = nCodCia
                                        AND IdPoliza = obj_sesasdatgen2(z).IdPoliza
                                        AND StsCobertura NOT IN ( cStatus1, cStatus2, cStatus5 );
                    --
                                    SELECT NVL(SUM(MontoAsistMoneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                                    INTO nPrimaMonedaTotPol
                                    FROM SICAS_OC.ASISTENCIAS_ASEGURADO
                                    WHERE CodCia = nCodCia
                                        AND IdPoliza = obj_sesasdatgen2(z).IdPoliza
                                        AND StsAsistencia NOT IN ( cStatus3, cStatus4, cStatus6 );

                                ELSIF cTodasAnuladas = 'S' AND nIdPolizaProcCalc = obj_sesasdatgen2(z).IdPoliza THEN
                                    SELECT NVL(SUM(Prima_Moneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                                    INTO nPrimaMonedaTotPol
                                    FROM SICAS_OC.COBERT_ACT
                                    WHERE CodCia = nCodCia
                                        AND IdPoliza = obj_sesasdatgen2(z).IdPoliza;
                    --
                                    SELECT NVL(SUM(MontoAsistMoneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                                    INTO nPrimaMonedaTotPol
                                    FROM SICAS_OC.ASISTENCIAS_DETALLE_POLIZA
                                    WHERE CodCia = nCodCia
                                        AND IdPoliza = obj_sesasdatgen2(z).IdPoliza;
                    --
                                    SELECT NVL(SUM(Prima_Moneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                                    INTO nPrimaMonedaTotPol
                                    FROM SICAS_OC.COBERT_ACT_ASEG
                                    WHERE CodCia = nCodCia
                                        AND IdPoliza = obj_sesasdatgen2(z).IdPoliza;
                    --
                                    SELECT NVL(SUM(MontoAsistMoneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                                    INTO nPrimaMonedaTotPol
                                    FROM SICAS_OC.ASISTENCIAS_ASEGURADO
                                    WHERE CodCia = nCodCia
                                        AND IdPoliza = obj_sesasdatgen2(z).IdPoliza;

                                END IF;
                    --END LOOP;  cierre obj_sesasdatgen2
                            END LOOP;

                            EXIT WHEN obj_sesasdatgen2.COUNT = 0;
                        END LOOP;



                        CLOSE POL_Q;
                        
                        --COMMIT;
                        
                        IF NVL(nPrimaMonedaTotPol, 0) = 0 THEN
                            OPEN POL_Q;
                            LOOP
                                FETCH POL_Q
                                BULK COLLECT INTO obj_sesasdatgen2;
                                FOR z IN 1..obj_sesasdatgen2.COUNT LOOP
                    --FOR z IN POL_Q LOOP

                                    nIdPolizaCalc := obj_sesasdatgen2(z).IdPoliza;
                       -- BEGIN
                                    nIdTarifa := SICAS_OC.GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, obj_sesasdatgen2(z).IdTipoSeg, obj_sesasdatgen2(z).PlanCob, obj_sesasdatgen2(z).FecIniVig);
                       /* EXCEPTION
                            WHEN OTHERS THEN --ERROR ZIP
                               SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia,nCodEmpresa,cCodReporteProces,cCodUsuario,
                                                                    obj_sesasdatgen(x).IdPoliza,obj_sesasdatgen(x).NumCertificado,SQLCODE,SQLERRM);         
                        END;*/
                                    nCodAseguradoAfina := NULL;
                                    OPEN CALC_Q;
                                    LOOP
                                        FETCH CALC_Q
                                        BULK COLLECT INTO obj_sesasdatgen3;
                                        FOR w IN 1..obj_sesasdatgen3.COUNT LOOP
                        --FOR w IN CALC_Q LOOP
                                            IF obj_sesasdatgen3(w).Tasa > 0 THEN
                                                nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol, 0) + ( obj_sesasdatgen3(w).SumaAseg_Moneda *
                                                obj_sesasdatgen3(w).Tasa );

                                            ELSIF obj_sesasdatgen3(w).CodTarifa IS NULL THEN
                                                IF NVL(obj_sesasdatgen3(w).Prima_Cobert, 0) != 0 THEN
                                                    nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol, 0) + NVL(obj_sesasdatgen3(w).Prima_Cobert,
                                                    0);

                                                ELSE
                                                    nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol, 0) + ( obj_sesasdatgen3(w).SumaAseg_Moneda *
                                                    obj_sesasdatgen3(w).Porc_Tasa / 1000 );
                                                END IF;
                                            ELSE
                                --Afinación para no obtener N veces la mismsa información cuando se trata del mismo asegurado
                                                IF nCodAseguradoAfina IS NULL OR nCodAseguradoAfina <> obj_sesasdatgen3(w).Cod_Asegurado THEN
                                                    nCodAseguradoAfina := obj_sesasdatgen3(w).Cod_Asegurado;
                                                    BEGIN
                                                        SICAS_OC.OC_PROCESOSSESAS.DATOSASEGURADO(nCodCia, nCodEmpresa, obj_sesasdatgen3(w).Cod_Asegurado, dFecIniVig, cSexo,nEdad, cCodActividad, cRiesgo);

                                                        IF cSexo IS NULL OR nEdad IS NULL OR cCodActividad IS NULL OR cRiesgo IS NULL THEN
                                                            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces,cCodUsuario, nIdPoliza,'ER-' || nCod_Asegurado, SQLCODE,SQLERRM); 
                                            --EXIT; BREAK
                                                        END IF;

                                                    EXCEPTION
                                                        WHEN OTHERS THEN --ERROR ZIP
                                                            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces,cCodUsuario, nIdPoliza,'ER3-' || nCod_Asegurado, SQLCODE, SQLERRM);
                                                    END;

                                                END IF;

                                                BEGIN
                                                    nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, obj_sesasdatgen3(w).IdTipoSeg, obj_sesasdatgen3(w).PlanCob, obj_sesasdatgen3(w).CodCobert, nEdad, cSexo, cRiesgo, nIdTarifa);

                                                EXCEPTION
                                                    WHEN OTHERS THEN
                                                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces,cCodUsuario, nIdPoliza,nCod_Asegurado, SQLCODE, SQLERRM);
                                                END;

                               /* IF nTasa IS NULL THEN
                                    SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia,nCodEmpresa,cCodReporteProces,cCodUsuario,
                                                                    obj_sesasdatgen(x).IdPoliza,obj_sesasdatgen(x).NumCertificado,SQLCODE,SQLERRM); 
                               /* END IF;*/

                                                nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol, 0) + obj_sesasdatgen3(w).SumaAseg_Moneda *nTasa / obj_sesasdatgen3(w).FactorTasa;

                                            END IF;
                        --END LOOP;
                                        END LOOP;

                                        EXIT WHEN obj_sesasdatgen3.COUNT = 0;
                                    END LOOP;

                                    CLOSE CALC_Q;
                                    --COMMIT;
                                END LOOP;

                                EXIT WHEN obj_sesasdatgen2.COUNT = 0;
                            END LOOP;

                            CLOSE POL_Q;
                            
                            COMMIT;

                    --END LOOP;
                        END IF;
             --
                        IF NVL(nPrimaMonedaTotPol, 0) = 0 THEN
                            nPrimaMonedaTotPol := 1;
                        END IF;
                  --***  END IF;

                    OPEN POL_Q;
                    LOOP
                        FETCH POL_Q
                        BULK COLLECT INTO obj_sesasdatgen2;
                        FOR z IN 1..obj_sesasdatgen2.COUNT LOOP
                            IF cTodasAnuladas = 'N' AND nIdPolizaProcCalc = obj_sesasdatgen2(z).IdPoliza THEN
                                IF obj_sesasdatgen2(z).StsPoliza IN ( 'EMI', 'REN' ) THEN
                                    cStatus1 := 'CEX';
                                    cStatus2 := ' ';
                                    cStatus3 := 'EXCLUI';
                                    cStatus4 := ' ';
                                ELSE
                                    cStatus1 := 'CEX';
                                    cStatus2 := 'ANU';
                                    cStatus3 := 'EXCLUI';
                                    cStatus4 := 'ANULAD';
                                END IF;

                            ELSIF cTodasAnuladas = 'S' AND nIdPolizaProcCalc = obj_sesasdatgen2(z).IdPoliza THEN
                                cStatus1 := ' ';
                                cStatus2 := ' ';
                                cStatus3 := ' ';
                                cStatus4 := ' ';
                            END IF;
                        END LOOP;

                        EXIT WHEN obj_sesasdatgen2.COUNT = 0;
                    END LOOP;

                    CLOSE POL_Q;
                    --COMMIT;

                    SELECT NVL(SUM(MontoAsistLocal), 0)
                    INTO nMtoAsistLocal
                    FROM SICAS_OC.ASISTENCIAS_DETALLE_POLIZA
                    WHERE CodCia = nCodCia
                        AND CodEmpresa = nCodEmpresa
                        AND IdPoliza = nIdPoliza
                        AND IDetPol = nIDetPol
                        AND StsAsistencia <> 'EXCLUI';
cStatus2 :='A';
                    BEGIN
                        OPEN COBERT_Q;
                        LOOP
                            FETCH COBERT_Q
                            BULK COLLECT INTO obj_sesasdatgen4;
                            FOR w IN 1..obj_sesasdatgen4.COUNT LOOP

            --FOR w IN COBERT_Q LOOP
              --IF obj_sesasdatgen3(w).PeriodoEspera > NVL(nPeriodoEspCob, 0) THEN
              --   nPeriodoEspCob := obj_sesasdatgen3(w).PeriodoEspera;
              --END IF; 
              --
               --se cambiar el valor de la variable ya que no se le asigno valor y e pone el valor de la consulta
                --nPmaEmiCob     := NVL(nPrima_Moneda, 0);
                                nPmaEmiCob := NVL(obj_sesasdatgen4(w).Prima_Moneda, 0);
              --

                                IF obj_sesasdatgen4(w).OrdenSESAS = 1 THEN
                                    nPmaEmiCob := NVL(nPmaEmiCob, 0) + NVL(nMtoAsistLocal, 0);
                                    nMtoAsistLocal := 0;
                                END IF;
               -- nPrimaDevengada := nPmaEmiCob; --Ver calculo
              --Inserto Emisión/Coberturas

                                nPrimaDevengada := SICAS_OC.OC_PROCESOSSESAS.GETPRIMADEVENGADA(nidPoliza, nPmaEmiCob, dFecHasta, dFecIniVig,dFecFinVig);

                                IF obj_sesasdatgen(x).FecBAJCERT < dvarFecDesde THEN
                                    nPmaEmiCob := 0;
                                END IF;

                                IF dFecFinVig <= dFecHasta THEN
                                    nPrimaDevengada := nPmaEmiCob;
                                END IF;

                            cTipoSumaSeg := SICAS_OC.OC_PROCESOSSESAS.GETTIPOSUMASEG(nCodCia, LPAD(obj_sesasdatgen4(w).ClaveSESAS, 2, '0'),'VIDA');

                                BEGIN
                                    INSERT INTO SICAS_OC.SESAS_EMISION (CodCia,
                                                                        CodEmpresa,
                                                                        CodReporte,
                                                                        CodUsuario,
                                                                        NumPoliza,
                                                                        NumCertificado,
                                                                        Cobertura,
                                                                        TipoSumaSeg,
                                                                        PeriodoEspera,
                                                                        SumaAsegurada,
                                                                        PrimaEmitida,
                                                                        PrimaDevengada,
                                                                        TipoExtraPrima,
                                                                        OrdenSesas
                                                            ) VALUES (
                                                                        nCodCia,
                                                                        nCodEmpresa,
                                                                        cCodReporteProces,
                                                                        cCodUsuario,
                                                                        obj_sesasdatgen(x).NumPoliza,
                                                                        obj_sesasdatgen(x).NumCertificado,
                                                                        LPAD(obj_sesasdatgen4(w).ClaveSESAS, 2, '0'),
                                                                        cTipoSumaSeg,
                                                                        obj_sesasdatgen4(w).PeriodoEspera,
                                                                        NVL(obj_sesasdatgen4(w).Suma_Moneda, 0),
                                                                        nPmaEmiCob,
                                                                        nPrimaDevengada,
                                                                        cTipoExtraPrima,
                                                                        obj_sesasdatgen4(w).OrdenSESAS
                                                                    );

                                EXCEPTION
                                    WHEN DUP_VAL_ON_INDEX THEN
                                        UPDATE SICAS_OC.SESAS_EMISION
                                        SET PrimaEmitida = NVL(PrimaEmitida, 0) + NVL(nPmaEmiCob, 0),
                                            SumaAsegurada = NVL(SumaAsegurada, 0) + NVL(NVL(obj_sesasdatgen4(w).Suma_Moneda, 0), 0),
                                            primadevengada = primadevengada + nPrimaDevengada,
                                            fechainsert = sysdate
                                        WHERE CodCia = nCodCia
                                            AND CodEmpresa = nCodEmpresa
                                            AND CodReporte = cCodReporteProces
                                            AND CodUsuario = cCodUsuario
                                            AND NumPoliza = obj_sesasdatgen(x).NumPoliza 
                                            AND NumCertificado = obj_sesasdatgen(x).NumCertificado
                                            AND Cobertura = LPAD(obj_sesasdatgen4(w).ClaveSESAS, 2, '0');
                      --AND  OrdenSesas     = nOrdenSesas;
                                        --COMMIT;
                                    WHEN OTHERS THEN
                                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario,obj_sesasdatgen(x).IdPoliza,obj_sesasdatgen(x).NumCertificado, SQLCODE, SQLERRM);
                                END;

            --END LOOP;
                            END LOOP;

                            EXIT WHEN obj_sesasdatgen4.COUNT = 0;
                        END LOOP;

                        CLOSE COBERT_Q;
                    EXCEPTION
                        WHEN OTHERS THEN
                            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, obj_sesasdatgen(x).IdPoliza,obj_sesasdatgen(x).NumCertificado, SQLCODE, SQLERRM);
                    END;

                  --  COMMIT;

        --END LOOP; cierre obj_sesasdatgen
                END LOOP;

                EXIT WHEN obj_sesasdatgen.COUNT = 0;  
            END LOOP;
            CLOSE cPolizas_DatGen;
        EXCEPTION
            WHEN OTHERS THEN
                SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, nIdPoliza,nCod_Asegurado, SQLCODE, SQLERRM);
        END;

        COMMIT;



        OPEN cPolizas_DatGen;
        LOOP
            FETCH cPolizas_DatGen
            BULK COLLECT INTO obj_sesasdatgen;
            FOR x IN 1..obj_sesasdatgen.COUNT LOOP         

                SELECT SUM(SUMAASEG),SUM(PRIMANETA)
                INTO nComisionDirecta2,nPmaEmiCob
                FROM SICAS_OC.ASEGURADO_CERTIFICADO
                WHERE CODCIA = nCodCia
                    AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                    AND IDETPOL = obj_sesasdatgen(x).IDetPol;

                IF nComisionDirecta2 IS NULL THEN 

                    SELECT SUM(SUMA_ASEG_MONEDA),SUM(PRIMA_MONEDA)
                    INTO nComisionDirecta2,nPmaEmiCob
                    FROM SICAS_OC.DETALLE_POLIZA 
                    WHERE CODCIA = nCodCia
                        AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                        AND IDETPOL = obj_sesasdatgen(x).IDetPol;

               END IF;

               IF nComisionDirecta2 IS NULL THEN               
                    nComisionDirecta2 := nPmaEmiCob;
               END IF;


                SELECT COUNT(1) --Total de coberturas
                INTO vl_Total1
                FROM SICAS_OC.COBERT_ACT 
                WHERE IDPOLIZA = obj_sesasdatgen(x).IdPoliza 
                    AND IDETPOL = obj_sesasdatgen(x).IDetPol
                    AND COD_ASEGURADO = obj_sesasdatgen(x).CodAsegurado;

                IF vl_Total1 > 1 THEN

                    BEGIN

                        SELECT COUNT(1) --Total de coberturas
                        INTO vl_Total2
                        FROM SICAS_OC.COBERT_ACT 
                        WHERE IDPOLIZA = obj_sesasdatgen(x).IdPoliza 
                            AND IDETPOL = obj_sesasdatgen(x).IDetPol
                            AND COD_ASEGURADO = obj_sesasdatgen(x).CodAsegurado
                            AND PRIMA_MONEDA = 0
                        GROUP BY IDPOLIZA,IDETPOL,COD_ASEGURADO;
                    EXCEPTION
                        WHEN OTHERS THEN
                            vl_Total2 := 0;
                    END;

                    IF ((vl_Total1 = 2) AND (vl_Total2 = 1)) OR ((vl_Total1 > 2) AND (vl_Total2 >= 2)) THEN

                        UPDATE SICAS_OC.SESAS_EMISION E
                        SET PrimaEmitida = NVL((ROUND((100 / nComisionDirecta2), 10) * NVL(SumaAsegurada, 0)) *(ROUND((nPmaEmiCob / 100), 10)), 0)   ,
                            PrimaDevengada = SICAS_OC.OC_PROCESOSSESAS.GETPRIMADEVENGADA(obj_sesasdatgen(x).IdPoliza, NVL((ROUND((100 / nComisionDirecta2), 10) * NVL(SumaAsegurada, 0)) *(ROUND((nPmaEmiCob / 100), 10)), 0) , dvarFecHasta, obj_sesasdatgen(x).FecIniVig,obj_sesasdatgen(x).FecFinVig),
                            fechainsert = sysdate,
                            SumaAsegurada = case when Cobertura = '10' then 0.0 else SumaAsegurada end
                        WHERE NUMCERTIFICADO||COBERTURA = TRIM(LPAD(obj_sesasdatgen(x).IdPoliza, 8, '0')) ||TRIM(LPAD(obj_sesasdatgen(x).IDetPol, 2, '0')) ||TRIM(LPAD(obj_sesasdatgen(x).CodAsegurado, 10, '0'))||COBERTURA;

                    END IF;
                END IF;

                END LOOP;
            EXIT WHEN obj_sesasdatgen.COUNT = 0;
        END LOOP;

        CLOSE cPolizas_DatGen;
        COMMIT;

    END EMISION_VI;

    PROCEDURE SINIESTROS_VI (
        nCodCia           SICAS_OC.SESAS_SINIESTROS.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_SINIESTROS.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_SINIESTROS.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_SINIESTROS.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_SINIESTROS.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    ) IS

        dFecConSin     SICAS_OC.SESAS_SINIESTROS.FECCONSIN%TYPE;
        dFecPagSin     SICAS_OC.SESAS_SINIESTROS.FECPAGSIN%TYPE;
        nMontoPagSin   SICAS_OC.SESAS_SINIESTROS.MONTOPAGSIN%TYPE;
        nNumAprobacion APROBACIONES.NUM_APROBACION%TYPE;
        nIdTransaccion APROBACIONES.IDTRANSACCION%TYPE;
        cTipAprobacion NUMBER;
      --
        CURSOR cSiniestros IS
        SELECT
            P.NumPolUnico                                                                                                           NumPoliza,
            TRIM(LPAD(S.IdPoliza, 8, '0'))
            || TRIM(LPAD(S.IDetPol, 2, '0'))
            || TRIM(LPAD(S.Cod_Asegurado, 10, '0'))                                                                                 NumCertificado,
            S.IdSiniestro                                                                                                           NumSiniestro,
            S.Fec_Ocurrencia                                                                                                        FecOcuSin,
            S.Fec_Notificacion                                                                                                      FecRepSin,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(S.CODPAISOCURR, S.CODPROVOCURR, PN.CODPAISRES, PN.CODPROVRES, S.IdPoliza) EntOcuSin,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSIN(S.CodCia, S.IdPoliza, S.IdSiniestro, S.Sts_Siniestro,((
                CASE WHEN R.TIPO_MOVIMIENTO IN('PAGOS') THEN R.IMPTE_MOVIMIENTO *( CASE WHEN R.SIGNO = '-' THEN -1 ELSE 1 END ) ELSE 0 END ) +(
                CASE WHEN R.TIPO_MOVIMIENTO IN('DESPAG', 'DESCUE', 'DEDUC') THEN
                        R.IMPTE_MOVIMIENTO *( CASE  WHEN R.SIGNO = '-' THEN-1 ELSE 1 END )ELSE  0END )),(
                CASE WHEN R.TIPO_MOVIMIENTO IN('ESTINI', 'AJUMAS', 'AJUMEN') THEN
                        R.IMPTE_MOVIMIENTO *( CASE WHEN R.SIGNO = '-' THEN - 1 ELSE 1 END  ) ELSE   0 END ), 'SINVII')                                                                                                            StatusReclamacion,
            CASE WHEN LENGTH(NVL(REPLACE(S.submotivo_siniestro, '.', ''), S.Motivo_De_Siniestro)) = 3 THEN S.Motivo_De_Siniestro || 'X'
                ELSE NVL(REPLACE(S.submotivo_siniestro, '.', ''), S.Motivo_De_Siniestro) END                                                                                                                     CausaSiniestro,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                          Sexo,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOMOVRECLAMO()                                                                           TipMovRec,
            PN.FecNacimiento                                                                                                        FecNacim,
            0                                                                                                                       MontoVencimiento   --Default 0
            ,
            0 MontoRecRea        --Default 0
                  --, S.Monto_Pago_Moneda
                  --, S.Monto_Reserva_Moneda 
            ,
            (
                CASE
                    WHEN R.TIPO_MOVIMIENTO IN ( 'PAGOS' ) THEN
                        R.IMPTE_MOVIMIENTO * (
                            CASE
                                WHEN R.SIGNO = '-' THEN
                                    - 1
                                ELSE
                                    1
                            END
                        )
                    ELSE
                        0
                END
            ) + (
                CASE
                    WHEN R.TIPO_MOVIMIENTO IN ( 'DESPAG', 'DESCUE', 'DEDUC' ) THEN
                        R.IMPTE_MOVIMIENTO * (
                            CASE
                                WHEN R.SIGNO = '-' THEN
                                    - 1
                                ELSE
                                    1
                            END
                        )
                    ELSE
                        0
                END
            )                                                                                                                       Monto_Pago_Moneda,
            CASE
                WHEN R.TIPO_MOVIMIENTO IN ( 'ESTINI', 'AJUMAS', 'AJUMEN' ) THEN
                    R.IMPTE_MOVIMIENTO * (
                        CASE
                            WHEN R.SIGNO = '-' THEN
                                - 1
                            ELSE
                                1
                        END
                    )
                ELSE
                    0
            END                                                                                                                     Monto_Reserva_Moneda,
            S.IdPoliza,
            S.IDetPol,
            S.Cod_Asegurado,
            P.MONTODEDUCIBLE
        FROM SICAS_OC.POLIZAS P
        INNER JOIN SICAS_OC.DETALLE_POLIZA D
            ON D.IdPoliza = P.IdPoliza
            AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            AND D.CODCIA = P.CODCIA
        INNER JOIN SICAS_OC.SINIESTRO                S 
            ON S.IDetPol = D.IDetPol
            AND S.IdPoliza = D.IdPoliza
        INNER JOIN SICAS_OC.ASEGURADO                CL 
            ON CL.Cod_Asegurado = S.Cod_Asegurado
        INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN 
            ON PN.Num_Doc_Identificacion = CL.Num_Doc_Identificacion
            AND PN.Tipo_Doc_Identificacion = CL.Tipo_Doc_Identificacion
        INNER JOIN SICAS_OC.RESERVA_DET              R 
            ON R.ID_SINIESTRO = S.IDSINIESTRO
            AND R.ID_POLIZA = S.IDPOLIZA
            AND R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta
        WHERE   S.Sts_Siniestro != 'SOL'
            AND P.NumPolUnico NOT LIKE 'TRD%' -- Infonacot

            AND D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND ( D.IdTipoSeg IN (
                                    SELECT PC.IdTipoSeg
                                    FROM SICAS_OC.PLAN_COBERTURAS PC
                                    WHERE PC.CodTipoPlan IN ( '011' ) )
                  OR EXISTS (   SELECT 'S'
                                FROM SICAS_OC.COBERTURAS_DE_SEGUROS CAS
                                WHERE CAS.CODCIA = D.CodCia
                                    AND CAS.CodEmpresa = D.CodEmpresa
                                    AND CAS.IDTIPOSEG = D.IdTipoSeg
                                    AND CAS.PLANCOB = D.PLANCOB
                                    AND CAS.IDRAMOREAL = '010'
                                    AND CAS.CODCOBERT IN (  SELECT CODCOBERT
                                                            FROM SICAS_OC.COBERTURAS X
                                                            WHERE X.IDPOLIZA = D.IdPoliza
                                                                AND X.IDETPOL = D.IDETPOL
                                                                AND D.IDTIPOSEG = X.IDTIPOSEG)
                ) )
            AND ( EXISTS (  SELECT 'S'
                            FROM SICAS_OC.APROBACION_ASEG A
                            INNER JOIN SICAS_OC.COMPROBANTES_CONTABLES B 
                                ON B.NumTransaccion = A.IdTransaccion
                            WHERE A.IdSiniestro = S.IdSiniestro
                                AND A.IdTransaccion = R.TRANSACCION
                                           
                                AND B.FecComprob BETWEEN dvarFecDesde AND dvarFecHasta
                        )
                  OR EXISTS (   SELECT 'S'
                                FROM SICAS_OC.APROBACIONES A
                                INNER JOIN SICAS_OC.COMPROBANTES_CONTABLES B 
                                    ON B.NumTransaccion = A.IdTransaccion
                                WHERE A.IdSiniestro = S.IdSiniestro
                                    AND A.IdTransaccion = R.TRANSACCION
                                    AND B.FecComprob BETWEEN dvarFecDesde AND dvarFecHasta
                            )
                  OR R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta )
            AND ( ( cFiltrarPolizas = 'N' ) OR ( cFiltrarPolizas = 'S' AND D.IdPoliza IN (
                SELECT IdPoliza
                FROM SICAS_OC.FILTRAR_POLIZAS_SESAS
                WHERE CodCia = nCodCia
                    AND CodEmpresa = nCodEmpresa
                    AND ProcesoSesas = cCodReporteProces
                    AND UsuarioCarga = cCodUsuario
                    AND Observacion = 'OK'
            ) ) );
   --
        CURSOR cCoberturas (
            nIdPoliza    SINIESTRO.IdPoliza%TYPE,
            nIdSiniestro SINIESTRO.IdSiniestro%TYPE
        ) IS
        SELECT
            NVL(CS.CLAVESESASNEW, '1') ClaveSesas,
            NVL(CS.OrdenSesas, 0)      OrdenSesas
                   -- , CS.CodCobert
            ,
            SUM(
                CASE
                    WHEN R.TIPO_MOVIMIENTO IN('ESTINI', 'AJUMAS', 'AJUMEN') THEN
                        R.IMPTE_MOVIMIENTO *(
                            CASE
                                WHEN R.SIGNO = '-' THEN
                                    - 1
                                ELSE
                                    1
                            END
                        )
                    ELSE
                        0
                END
            )                          MontoReclamado,
            NVL(SUM(
                CASE
                    WHEN R.TIPO_MOVIMIENTO =('PAGOS') THEN
                        R.IMPTE_MOVIMIENTO
                END
            ), 0) + NVL(SUM(
                CASE
                    WHEN R.TIPO_MOVIMIENTO IN('DESPAG', 'DESCUE', 'DEDUC') THEN
                        R.IMPTE_MOVIMIENTO *(
                            CASE
                                WHEN R.SIGNO = '-' THEN
                                    - 1
                                ELSE
                                    1
                            END
                        )
                    ELSE
                        0
                END
            ), 0)                      MontoPagado
        FROM SICAS_OC.SINIESTRO S
        INNER JOIN SICAS_OC.DETALLE_POLIZA        D 
            ON D.IdPoliza = S.IdPoliza 
            AND D.IDetPol = S.IDetPol
        INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS 
            ON CS.PlanCob = D.PlanCob
            AND CS.IdTipoSeg = D.IdTipoSeg
            AND CS.CodEmpresa = D.CodEmpresa
            AND CS.CodCia = D.CodCia
        INNER JOIN SICAS_OC.RESERVA_DET           R 
            ON R.ID_SINIESTRO = S.IDSINIESTRO
            AND R.ID_POLIZA = S.IDPOLIZA
            AND R.ID_COBERTURA = Cs.CodCobert
            AND R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta
        WHERE S.IdSiniestro = nIdSiniestro
            AND S.IdPoliza = nIdPoliza
            AND NVL(Cs.IDRAMOREAL, '010') <> '030'
            AND R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta
        GROUP BY NVL(CS.CLAVESESASNEW, '1'),NVL(CS.OrdenSesas, 0)--, CS.CodCobert
            ;/*
            UNION

            SELECT  NVL(CS.CLAVESESASNEW, '1')      ClaveSesas
                    , NVL(CS.OrdenSesas, 0)        OrdenSesas
                    , CS.CodCobert
                    , SUM(CASE  WHEN R.TIPO_MOVIMIENTO <> 'PAGOS' THEN R.IMPTE_MOVIMIENTO* (CASE WHEN R.SIGNO = '-' THEN -1 ELSE 1 END ) ELSE 0 END)  MontoReclamado
                     , SUM(CASE  WHEN R.TIPO_MOVIMIENTO = 'PAGOS' THEN R.IMPTE_MOVIMIENTO* (CASE WHEN R.SIGNO = '-' THEN -1 ELSE 1 END ) ELSE 0 END)  MontoPagado
            FROM   SICAS_OC.SINIESTRO               S 
            INNER JOIN SICAS_OC.COBERTURA_SINIESTRO_ASEG     C
                ON C.IdSiniestro = S.IdSiniestro
                AND C.IDPOLIZA = S.IDPOLIZA
            INNER JOIN SICAS_OC.DETALLE_POLIZA          D
                ON D.IDetPol     = S.IDetPol
                AND  D.IdPoliza    = S.IdPoliza
            INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS  CS
                ON CS.CodCobert  = C.CodCobert
                AND  CS.PlanCob    = D.PlanCob
                AND  CS.IdTipoSeg  = D.IdTipoSeg
                AND  CS.CodEmpresa = D.CodEmpresa
                AND  CS.CodCia     = D.CodCia
            INNER JOIN CONFIG_TRANSAC_SINIESTROS CTS 
                ON CTS.CODTRANSAC = C.CODTRANSAC
            INNER JOIN SICAS_OC.RESERVA_DET R
                ON R.ID_SINIESTRO= S.IDSINIESTRO
                AND R.ID_POLIZA = S.IDPOLIZA 
                AND R.ID_COBERTURA = C.CodCobert
                AND R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta 
            WHERE  S.IdSiniestro = nIdSiniestro
                AND  S.IdPoliza    = nIdPoliza
                AND R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta 
            GROUP BY NVL(CS.CLAVESESASNEW, '1'), NVL(CS.OrdenSesas, 0), CS.CodCobert,(CASE  WHEN R.TIPO_MOVIMIENTO <> 'PAGOS' THEN R.IMPTE_MOVIMIENTO* (CASE WHEN R.SIGNO = '-' THEN -1 ELSE 1 END ) ELSE 0 END)
            ;*/
        nMontoReclamo  NUMBER := NULL;
    BEGIN

        DELETE SICAS_OC.SESAS_SINIESTROS
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND NUMPOLIZA >= '0'
            AND NUMCERTIFICADO >= '0';

        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND IDSECUENCIA>=0;

        COMMIT;
        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');
        FOR x IN cSiniestros LOOP
            FOR y IN cCoberturas(x.IdPoliza, x.NumSiniestro) LOOP
                dFecConSin := NULL;
                dFecPagSin := NULL;
                nMontoPagSin := NULL;
                nNumAprobacion := NULL;
                nIdTransaccion := NULL;
                SICAS_OC.OC_PROCESOSSESAS.DATOSSINIESTROS(nCodCia, nCodEmpresa, x.IdPoliza, x.NumSiniestro, '',dFecPagSin, nMontoPagSin, dFecConSin);

                BEGIN
                    SELECT MIN(FE_MOVTO)
                    INTO dFecConSin
                    FROM SICAS_OC.RESERVA_DET
                    WHERE ID_POLIZA = x.IdPoliza
                        AND ID_SINIESTRO = x.NumSiniestro;

                EXCEPTION
                    WHEN OTHERS THEN
                        dFecConSin := NULL;
                END;

                nMontoReclamo := NVL(x.MONTODEDUCIBLE, 0) + NVL(y.MontoReclamado, 0);

              --Inserto Siniestros/Coberturas
                BEGIN
                    INSERT INTO SICAS_OC.SESAS_SINIESTROS ( CodCia,
                                                            CodEmpresa,
                                                            CodReporte,
                                                            CodUsuario,
                                                            NumPoliza,
                                                            NumCertificado,
                                                            NumSiniestro,
                                                            FecOcuSin,
                                                            FecRepRec,
                                                            FecConSin,
                                                            FecPagSin,
                                                            StatusReclamacion,
                                                            EntOcuSin,
                                                            Cobertura,
                                                            MontoReclamado,
                                                            CausaSiniestro,
                                                            MontoDeducible,
                                                            MontoCoaseguro,
                                                            MontoPagSin,
                                                            MontoRecRea,
                                                            MontoDividendo,
                                                            TipMovRec,
                                                            MontoVencimiento,
                                                            MontoRescate,
                                                            TipoGasto,
                                                            PeriodoEspera,
                                                            TipoPago,
                                                            Sexo,
                                                            FecNacim,
                                                            OrdenSesas
                                                ) VALUES (
                                                            nCodCia,
                                                            nCodEmpresa,
                                                            cCodReporteProces,
                                                            cCodUsuario,
                                                            x.NumPoliza,
                                                            x.NumCertificado,
                                                            x.NumSiniestro,
                                                            x.FecOcuSin,
                                                            x.FecRepSin,
                                                            dFecConSin,
                                                            dFecPagSin,
                                                            x.StatusReclamacion,
                                                            x.EntOcuSin,
                                                            y.ClaveSesas,
                                                            nMontoReclamo,
                                                            x.CausaSiniestro,
                                                            x.MONTODEDUCIBLE,
                                                            NULL/*NVL(x.MontoCoaseguro, 0)*/,
                                                            NVL(y.MontoPagado, 0),
                                                            NVL(x.MontoRecRea, 0),
                                                            NULL/*NVL(nMontoDividendo, 0)*/,
                                                            x.TipMovRec,
                                                            NVL(x.MontoVencimiento, 0),
                                                            NULL/*NVL(nMontoRescate, 0)*/,
                                                            NULL/*cTipoGasto */,
                                                            NULL /*nPeriodoEspera*/,
                                                            NULL/*cTipoPago */,
                                                            x.Sexo,
                                                            x.FecNacim,
                                                            y.OrdenSesas
                                                        );

                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        UPDATE SICAS_OC.SESAS_SINIESTROS
                        SET   /* MontoReclamado   = NVL(MontoReclamado  , 0) + NVL(y.MontoReclamado  , 0)
                          ,    MontoDeducible   = NVL(MontoDeducible  , 0) + NVL(NULL/*nMontoDeducible  , 0)
                          ,*/
                            MontoCoaseguro = NVL(MontoCoaseguro, 0) + NVL(NULL/*x.MontoCoaseguro*/, 0)
                         -- ,    MontoPagSin      = NVL(MontoPagSin     , 0) + NVL(nMontoPagSin     , 0)
                            ,
                            MontoRecRea = NVL(MontoRecRea, 0) + NVL(x.MontoRecRea, 0),
                            MontoDividendo = NVL(MontoDividendo, 0) + NVL(NULL/*nMontoDividendo */, 0),
                            MontoVencimiento = NVL(MontoVencimiento, 0) + NVL(x.MontoVencimiento, 0),
                            MontoRescate = NVL(MontoRescate, 0) + NVL(NULL/*nMontoRescate*/, 0),
                                            fechainsert = sysdate
                        WHERE CodCia = nCodCia
                            AND CodEmpresa = nCodEmpresa
                            AND CodReporte = cCodReporteProces
                            AND CodUsuario = cCodUsuario
                            AND NumPoliza = x.NumPoliza
                            AND NumCertificado = x.NumCertificado
                            AND NumSiniestro = x.NumSiniestro
                            AND Cobertura = y.ClaveSesas;

                        COMMIT;
                    WHEN OTHERS THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, x.NumPoliza,x.NumCertificado, SQLCODE, SQLERRM);
                END;

                BEGIN
                    SELECT MAX(FE_MOVTO)
                    INTO dFecPagSin
                    FROM SICAS_OC.RESERVA_DET
                    WHERE ID_POLIZA = x.IdPoliza
                        AND ID_SINIESTRO = x.NumSiniestro
                        AND AÑO_MOVIMIENTO = TO_NUMBER(TO_CHAR(dvarFecDesde, 'YYYY'))
                        AND TIPO_MOVIMIENTO = 'PAGOS';

                EXCEPTION
                    WHEN OTHERS THEN
                        dFecPagSin := NULL;
                END;

                UPDATE SICAS_OC.SESAS_SINIESTROS
                SET STATUSRECLAMACION = SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSINVII(nCodCia, x.IdPoliza, x.NumSiniestro, x.StatusReclamacion,
                    NVL(y.MontoPagado, 0), nMontoReclamo, 'SINVII'),
                    FECPAGSIN = dFecPagSin,
                    fechainsert = sysdate
                WHERE NUMPOLIZA = x.NumPoliza
                    AND NUMSINIESTRO = x.NumSiniestro;--OrdeSesas

            END LOOP;
        END LOOP;

        UPDATE SICAS_OC.SESAS_SINIESTROS
        SET  STATUSRECLAMACION = SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSINVII(CodCia, NULL, NumSiniestro, StatusReclamacion, MONTOPAGSIN,MONTORECLAMADO, 'SINVII'),
             FECPAGSIN = CASE WHEN MONTOPAGSIN = 0 THEN NULL ELSE FECPAGSIN END,
             fechainsert = sysdate
        WHERE NUMPOLIZA = NumPoliza
            AND NUMSINIESTRO = NumSiniestro;--OrdeSesas

        COMMIT;
    END SINIESTROS_VI;

    PROCEDURE DATGEN_AP (
        nCodCia           SICAS_OC.SESAS_DATGEN.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_DATGEN.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_DATGEN.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_DATGEN.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_DATGEN.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    ) IS

        CURSOR CUR_PRINCIPAL IS
        SELECT
            nCodCia,
            nCodEmpresa,
            cCodReporteDatGen,
            cCodUsuario,
            P.NumPolUnico                                                                                                         NumPoliza,
            NVL(TRIM(LPAD(XX.IdPoliza, 8, '0'))|| TRIM(LPAD(XX.IDetPol, 2, '0')) || TRIM(LPAD(XX.Cod_Asegurado, 10, '0')), 
                TRIM(LPAD(D.IdPoliza, 8, '0'))|| TRIM(LPAD(D.IDetPol, 2, '0'))|| TRIM(LPAD(D.Cod_Asegurado, 10, '0')))            NumCertificado,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOSEGURO(CS.TipoSeguro, NULL)                                                          TipoSeguro,
            DECODE(P.Cod_Moneda, 'PS', '10', 'USD', '20', '30')                                                                                                          Moneda,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(PN.CodPaisRes, PN.CodProvRes, PN.CODPAISRES, PN.CODPROVRES, P.IdPoliza) EntidadAsegurado,
            D.FecIniVig                                                                                                           FecIniVig,
            CASE WHEN OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob) IN ( '2', '02' ) THEN TO_DATE('31/12/9999', 'DD/MM/YYYY') ELSE D.FecFinVig END FecFinVig,
            D.FecIniVig                                                                                                           FecAltCert,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, D.FecAnul, dFecDesde,dFecHasta)                  FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERTAP(D.CodCia, D.IdPoliza, D.IDETPOL, D.FecAnul, dFecHasta, D.StsDetalle, D.FecIniVig, D.FecFinVig, NVL(XX.Cod_Asegurado, D.Cod_Asegurado))             StatusCert,
            SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA(D.CodCia, D.IdPoliza)                                                         FormaVta,
            NVL(CS.SubTipoSeg, '1')                                                                                               SubTipoSeg,
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
           /* ( CASE WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN 1
                    ELSE CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) END)*/
            CASE WHEN NVL(P.NumRenov,0) = 0 THEN  SICAS_OC.OC_PROCESOSSESAS.GETANIOPOLIZA(P.NUMPOLUNICO)  ELSE  P.NumRenov + 1 END AnioPoliza,
            SICAS_OC.OC_PROCESOSSESAS.GETOCUPACIONAP(PN.CodActividad,'API')                                                     Ocupacion,
            NVL(CS.TipoRiesgo, '1')                                                                                               TipoRiesgo,
            SICAS_OC.OC_PROCESOSSESAS.GETPRIMACEDIDA(D.CodCia, P.IdPoliza)                                                        PrimaCedida,
            SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(D.CodCia, D.CodEmpresa, P.IdPoliza, dFecDesde, dFecHasta)                  ComisionDirecta,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, P.IdPoliza)                                                          MontoDividendo,
            D.IdPoliza,
            D.IDetPol,
            NVL(XX.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            NVL(PC.PLANPOLIZA, '01') /*OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob) */          PlanPoliza,
            NVL(CS.MODALPOLIZA, '1')                                                                                              ModalidadPoliza,
            DECODE(P.CodPlanPago, 'CONT', '1', 'UNIC', '1','2')                                                                                                           FormaPago,
            DECODE(P.NumRenov, 0, 0, 1)                                                                                           Emision
        FROM SICAS_OC.POLIZAS P
        INNER JOIN SICAS_OC.DETALLE_POLIZA D
            ON D.IdPoliza = P.IdPoliza
            AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            AND D.CodCia = P.CodCia
        LEFT JOIN SICAS_OC.ASEGURADO_CERTIFICADO    XX 
            ON XX.CodCia = D.CodCia
            AND XX.IdPoliza = D.IdPoliza
            AND XX.IdetPol = D.IDetPol
        INNER JOIN SICAS_OC.ASEGURADO                A 
                ON A.Cod_Asegurado = NVL(XX.Cod_Asegurado,D.Cod_Asegurado)
        INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN 
            ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
            AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
        INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC 
            ON PC.CodCia = D.CodCia
            AND PC.CodEmpresa = D.CodEmpresa
            AND PC.IdTipoSeg = D.IdTipoSeg
            AND PC.PlanCob = D.PlanCob
        INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO CS 
            ON CS.CodCia = PC.CodCia
            AND CS.CodEmpresa = PC.CodEmpresa
            AND CS.IdTipoSeg = PC.IdTipoSeg
        /*INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CAS
			ON CAS.CODCIA 					= PC.CodCia
			AND CAS.CodEmpresa 				= PC.CodEmpresa
			AND CAS.IDTIPOSEG 				= PC.IdTipoSeg

			AND CAS.PLANCOB 			= PC.PLANCOB*/

        WHERE D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND D.IDetPol > 0
            AND D.IdPoliza > 0
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
            --AND PC.CodTipoPlan             = '031'
           /* AND (PC.CodTipoPlan = '031'
                OR (PC.CodTipoPlan = '099' AND CAS.IDRAMOREAL =  '030'  AND PC.IdTipoSeg  IN ('PPAQI')))*/
            AND ( PC.CodTipoPlan = '031'
                  OR ( EXISTS (
                SELECT 'S'
                FROM SICAS_OC.COBERTURAS_DE_SEGUROS CAS
                WHERE CAS.CODCIA = D.CodCia
                    AND CAS.CodEmpresa = D.CodEmpresa
                    AND CAS.IDTIPOSEG = D.IdTipoSeg
                    AND CAS.PLANCOB = D.PLANCOB
                    AND CAS.IDRAMOREAL = '030'
                    AND CAS.CODCOBERT IN (
                        SELECT CODCOBERT
                        FROM  SICAS_OC.COBERTURAS X
                        WHERE X.IDPOLIZA = P.IdPoliza
                            AND X.IDETPOL = D.IDETPOL
                            AND D.IDTIPOSEG = X.IDTIPOSEG
                    ) )
                       AND PC.CodTipoPlan = '099'
                       AND PC.IdTipoSeg = 'PPAQI' ) )
            /*AND ( ( D.FecFinVig BETWEEN dvarFecDesde AND dvarFecHasta  )
                  OR ( D.FecIniVig BETWEEN dvarFecDesde AND dvarFecHasta AND P.FecEmision <= dvarFecHasta)
               OR ( P.FECEMISION BETWEEN dvarFecDesde AND dvarFecHasta ) )*/
               AND (P.FecEmision <= dvarFecHasta AND D.FecFinVig >= dvarFecDesde)
            AND ( ( cFiltrarPolizas = 'N' )
                  OR ( cFiltrarPolizas = 'S'
                       AND D.IdPoliza IN (
                SELECT IdPoliza
                FROM  SICAS_OC.FILTRAR_POLIZAS_SESAS
                WHERE CodCia = nCodCia
                    AND CodEmpresa = nCodEmpresa
                    AND ProcesoSesas = cCodReporteProces
                    AND UsuarioCarga = cCodUsuario
                    AND Observacion = 'OK'
            ) ) )
        UNION ALL
        SELECT
            nCodCia,
            nCodEmpresa,
            cCodReporteDatGen,
            cCodUsuario,
            P.NumPolUnico                                                                                                         NumPoliza,
            NVL(TRIM(LPAD(XX.IdPoliza, 8, '0'))
                || TRIM(LPAD(XX.IDetPol, 2, '0'))
                || TRIM(LPAD(XX.Cod_Asegurado, 10, '0')), TRIM(LPAD(D.IdPoliza, 8, '0'))
                                                          || TRIM(LPAD(D.IDetPol, 2, '0'))
                                                          || TRIM(LPAD(D.Cod_Asegurado, 10, '0')))                                                                              NumCertificado,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOSEGURO(CS.TipoSeguro, NULL)                                                          TipoSeguro,
            DECODE(P.Cod_Moneda, 'PS', '10', 'USD', '20', '30')                                                                                                          Moneda,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(PN.CodPaisRes, PN.CodProvRes, PN.CODPAISRES, PN.CODPROVRES, P.IdPoliza) EntidadAsegurado,
            D.FecIniVig                                                                                                           FecIniVig,
            CASE WHEN OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob) IN ( '2', '02' ) THEN TO_DATE('31/12/9999', 'DD/MM/YYYY') ELSE  D.FecFinVig END FecFinVig,
            D.FecIniVig                                                                                                           FecAltCert,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, D.FecAnul, dFecDesde,dFecHasta)                  FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERTAP(D.CodCia, D.IdPoliza, D.IDETPOL, D.FecAnul, dFecHasta, D.StsDetalle, D.FecIniVig, D.FecFinVig, NVL(XX.Cod_Asegurado, D.Cod_Asegurado))             StatusCert,
            SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA(D.CodCia, D.IdPoliza)                                                         FormaVta,
            NVL(CS.SubTipoSeg, '1')                                                                                               SubTipoSeg,
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            /*(
                CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END
            ) */ 
            CASE WHEN NVL(P.NumRenov,0) = 0 THEN  SICAS_OC.OC_PROCESOSSESAS.GETANIOPOLIZA(P.NUMPOLUNICO)  ELSE  P.NumRenov + 1 END AnioPoliza,
            SICAS_OC.OC_PROCESOSSESAS.GETOCUPACIONAP(PN.CodActividad,'API')                                                       Ocupacion,
            NVL(CS.TipoRiesgo, '1')                                                                                               TipoRiesgo,
            SICAS_OC.OC_PROCESOSSESAS.GETPRIMACEDIDA(D.CodCia, P.IdPoliza)                                                        PrimaCedida,
            SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(D.CodCia, D.CodEmpresa, P.IdPoliza, dFecDesde, dFecHasta)                  ComisionDirecta,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, P.IdPoliza)                                                          MontoDividendo,
            D.IdPoliza,
            D.IDetPol,
            NVL(XX.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            NVL(PC.PLANPOLIZA, '01') /*OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob) */      PlanPoliza,
            NVL(CS.MODALPOLIZA, '1')                                                                                              ModalidadPoliza,
            DECODE(P.CodPlanPago, 'CONT', '1', 'UNIC', '1', '2')                                                                                                           FormaPago,
            DECODE(P.NumRenov, 0, 0, 1)                                                                                           Emision
        FROM SICAS_OC.POLIZAS P
        INNER JOIN SICAS_OC.DETALLE_POLIZA                  D
            ON D.IdPoliza = P.IdPoliza
            AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            AND D.CodCia = P.CodCia
        LEFT JOIN SICAS_OC.ASEGURADO_CERTIFICADO    XX 
            ON XX.CodCia = D.CodCia
            AND XX.IdPoliza = D.IdPoliza
            AND XX.IdetPol = D.IDetPol
        INNER JOIN SICAS_OC.ASEGURADO                A 
            ON A.Cod_Asegurado = NVL(XX.Cod_Asegurado,D.Cod_Asegurado)
        INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN 
            ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
            AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
        INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC 
            ON PC.CodCia = D.CodCia
            AND PC.CodEmpresa = D.CodEmpresa
            AND PC.IdTipoSeg = D.IdTipoSeg
            AND PC.PlanCob = D.PlanCob
        INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO CS 
            ON CS.CodCia = PC.CodCia
            AND CS.CodEmpresa = PC.CodEmpresa
            AND CS.IdTipoSeg = PC.IdTipoSeg
        /*INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CAS
			ON CAS.CODCIA 					= PC.CodCia
			AND CAS.CodEmpresa 				= PC.CodEmpresa
			AND CAS.IDTIPOSEG 				= PC.IdTipoSeg
			AND CAS.PLANCOB 			= PC.PLANCOB*/

        WHERE D.StsDetalle = 'ANU'
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
            --AND D.MotivAnul               != 'REEX'
            AND D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND D.IDetPol > 0
            AND D.IdPoliza > 0
            --AND PC.CodTipoPlan             = '031'
            /*AND (PC.CodTipoPlan = '031'

                OR (PC.CodTipoPlan = '099' AND CAS.IDRAMOREAL =  '030'  AND PC.IdTipoSeg  IN ('PPAQI')))*/

            AND ( PC.CodTipoPlan = '031'
                  OR ( EXISTS (
                SELECT 'S'
                FROM SICAS_OC.COBERTURAS_DE_SEGUROS CAS
                WHERE CAS.CODCIA = D.CodCia
                    AND CAS.CodEmpresa = D.CodEmpresa
                    AND CAS.IDTIPOSEG = D.IdTipoSeg
                    AND CAS.PLANCOB = D.PLANCOB
                    AND CAS.IDRAMOREAL = '030'
                    AND CAS.CODCOBERT IN (
                        SELECT CODCOBERT
                        FROM SICAS_OC.COBERTURAS X
                        WHERE X.IDPOLIZA = P.IdPoliza
                            AND X.IDETPOL = D.IDETPOL
                            AND D.IDTIPOSEG = X.IDTIPOSEG
                    ) )
                       AND PC.CodTipoPlan = '099'
                       AND PC.IdTipoSeg = 'PPAQI' ) )
            AND EXISTS (
                SELECT /*+ INDEX(DT SYS_C0031885) */
                    'S'
                FROM SICAS_OC.TRANSACCION T
                INNER JOIN SICAS_OC.DETALLE_TRANSACCION DT 
                    ON DT.IdTransaccion = T.IdTransaccion
                WHERE DT.Valor1 = P.IdPoliza
                    AND DT.Valor2 = D.IDetPol
                    AND DT.Correlativo > 0
                    AND DT.CodSubProceso NOT IN ( 'ESV', 'PAG' )
                    AND DT.CodCia = T.CodCia
                    AND T.CodCia = D.CodCia
                    AND T.CodEmpresa = D.CodEmpresa
                    AND T.IdTransaccion > 0
                    AND T.IdProceso = 2
                    AND T.FechaTransaccion BETWEEN dvarFecDesde AND dvarFecHasta
            )
            AND ( ( cFiltrarPolizas = 'N' )
                  OR ( cFiltrarPolizas = 'S'
                       AND D.IdPoliza IN (
                SELECT
                    IdPoliza
                FROM
                    SICAS_OC.FILTRAR_POLIZAS_SESAS
                WHERE
                        CodCia = nCodCia
                    AND CodEmpresa = nCodEmpresa
                    AND ProcesoSesas = cCodReporteProces
                    AND UsuarioCarga = cCodUsuario
                    AND Observacion = 'OK'
            ) ) )
        UNION ALL
        SELECT
            nCodCia,
            nCodEmpresa,
            cCodReporteDatGen,
            cCodUsuario,
            P.NumPolUnico                                                                                                         NumPoliza,
            NVL(TRIM(LPAD(XX.IdPoliza, 8, '0'))
                || TRIM(LPAD(XX.IDetPol, 2, '0'))
                || TRIM(LPAD(XX.Cod_Asegurado, 10, '0')), TRIM(LPAD(D.IdPoliza, 8, '0'))
                                                          || TRIM(LPAD(D.IDetPol, 2, '0'))
                                                          || TRIM(LPAD(D.Cod_Asegurado, 10, '0')))                                                                              NumCertificado,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOSEGURO(CS.TipoSeguro, NULL)                                                          TipoSeguro,
            DECODE(P.Cod_Moneda, 'PS', '10', 'USD', '20',
                   '30')                                                                                                          Moneda,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(PN.CodPaisRes, PN.CodProvRes, PN.CODPAISRES, PN.CODPROVRES, P.IdPoliza) EntidadAsegurado,
            D.FecIniVig                                                                                                           FecIniVig,
            CASE WHEN OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob) IN ( '2', '02' ) THEN
                    TO_DATE('31/12/9999', 'DD/MM/YYYY')  ELSE D.FecFinVig END FecFinVig,
            D.FecIniVig                                                                                                           FecAltCert,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, D.FecAnul, dFecDesde,dFecHasta)                  FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERTAP(D.CodCia, D.IdPoliza, D.IDETPOL, D.FecAnul, dFecHasta, D.StsDetalle, D.FecIniVig, D.FecFinVig, NVL(XX.Cod_Asegurado, D.Cod_Asegurado))             StatusCert,
            SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA(D.CodCia, D.IdPoliza)                                                         FormaVta,
            NVL(CS.SubTipoSeg, '1')                                                                                               SubTipoSeg,
            SUBSTR(NVL(P.TipoDividendo, '003'), - 1)                                                                              TipoDividendo,
            /*(
                CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END
            )*/
            CASE WHEN NVL(P.NumRenov,0) = 0 THEN  SICAS_OC.OC_PROCESOSSESAS.GETANIOPOLIZA(P.NUMPOLUNICO)  ELSE  P.NumRenov + 1 END       AnioPoliza,
            SICAS_OC.OC_PROCESOSSESAS.GETOCUPACIONAP(PN.CodActividad,'API')                                                       Ocupacion,
            NVL(CS.TipoRiesgo, '1')                                                                                               TipoRiesgo,
            SICAS_OC.OC_PROCESOSSESAS.GETPRIMACEDIDA(D.CodCia, P.IdPoliza)                                                        PrimaCedida,
            SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(D.CodCia, D.CodEmpresa, P.IdPoliza, dFecDesde, dFecHasta)                  ComisionDirecta,
            SICAS_OC.OC_PROCESOSSESAS.GETMNTODIVID(D.CodCia, P.IdPoliza)                                                          MontoDividendo,
            P.IdPoliza,
            D.IDetPol,
            NVL(XX.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            NVL(PC.PLANPOLIZA, '01') /*OC_PLAN_COBERTURAS.PLAN_POLIZA(D.CodCia, D.CodEmpresa, D.IdTipoSeg, D.PlanCob) */                                                                                             PlanPoliza,
            NVL(CS.MODALPOLIZA, '1')                                                                                              ModalidadPoliza,
            DECODE(P.CodPlanPago, 'CONT', '1', 'UNIC', '1', '2')                        FormaPago,
            DECODE(P.NumRenov, 0, 0, 1)                                                                                           Emision
        FROM SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA D                  ON  D.IdPoliza = P.IdPoliza
                                             AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
                                             AND D.CodCia = P.CodCia
            LEFT JOIN SICAS_OC.ASEGURADO_CERTIFICADO    XX 
                ON XX.CodCia = D.CodCia
                AND XX.IdPoliza = D.IdPoliza
                AND XX.IdetPol = D.IDetPol
            INNER JOIN SICAS_OC.ASEGURADO                A 
                ON A.Cod_Asegurado = NVL(XX.Cod_Asegurado,D.Cod_Asegurado)
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
                                                               AND PN.Tipo_Doc_Identificacion = A.Tipo_Doc_Identificacion
            INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC ON PC.CodCia = D.CodCia
                                                      AND PC.CodEmpresa = D.CodEmpresa
                                                      AND PC.IdTipoSeg = D.IdTipoSeg
                                                      AND PC.PlanCob = D.PlanCob
            INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO CS ON CS.CodCia = PC.CodCia
                                                               AND CS.CodEmpresa = PC.CodEmpresa
                                                               AND CS.IdTipoSeg = PC.IdTipoSeg
        /*INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CAS
			ON CAS.CODCIA 					= PC.CodCia
			AND CAS.CodEmpresa 				= PC.CodEmpresa
			AND CAS.IDTIPOSEG 				= PC.IdTipoSeg
			AND CAS.PLANCOB 			= PC.PLANCOB*/

        WHERE D.FecFinVig < dFecDesde
            AND D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
            AND D.IDetPol > 0
            AND D.IdPoliza > 0
         --AND PC.CodTipoPlan             = '031'
         /*AND (PC.CodTipoPlan = '031'

                OR (PC.CodTipoPlan = '099' AND CAS.IDRAMOREAL =  '030'  AND PC.IdTipoSeg  IN ('PPAQI')))*/
            AND ( PC.CodTipoPlan = '031'
                  OR ( EXISTS (
                SELECT  'S'
                FROM  SICAS_OC.COBERTURAS_DE_SEGUROS CAS
                WHERE  CAS.CODCIA = D.CodCia
                    AND CAS.CodEmpresa = D.CodEmpresa
                    AND CAS.IDTIPOSEG = D.IdTipoSeg
                    AND CAS.PLANCOB = D.PLANCOB
                    AND CAS.IDRAMOREAL = '030'
                    AND CAS.CODCOBERT IN (
                        SELECT CODCOBERT
                        FROM SICAS_OC.COBERTURAS X
                        WHERE X.IDPOLIZA = P.IdPoliza
                            AND X.IDETPOL = D.IDETPOL
                            AND D.IDTIPOSEG = X.IDTIPOSEG
                    ) )
                       AND PC.CodTipoPlan = '099'
                       AND PC.IdTipoSeg = 'PPAQI' ) )
            AND EXISTS (
                SELECT /*+ INDEX(DT SYS_C0031885) */
                    'S'
                FROM  SICAS_OC.TRANSACCION T
                    INNER JOIN SICAS_OC.DETALLE_TRANSACCION DT ON DT.IdTransaccion = T.IdTransaccion
                WHERE DT.Valor1 = P.IdPoliza
                    AND DT.Correlativo > 0
                    AND DT.CodSubProceso NOT IN ( 'ESV', 'PAG' )
                    AND DT.CodCia = T.CodCia
                    AND T.CodCia = D.CodCia
                    AND T.CodEmpresa = D.CodEmpresa
                    AND T.IdTransaccion > 0
                    AND T.IdProceso != 6
                    AND T.FechaTransaccion BETWEEN dvarFecDesde AND dvarFecHasta
            )
            AND ( ( cFiltrarPolizas = 'N' )
                  OR ( cFiltrarPolizas = 'S'
                       AND D.IdPoliza IN (
                SELECT IdPoliza
                FROM SICAS_OC.FILTRAR_POLIZAS_SESAS
                WHERE CodCia = nCodCia
                    AND CodEmpresa = nCodEmpresa
                    AND ProcesoSesas = cCodReporteProces
                    AND UsuarioCarga = cCodUsuario
                    AND Observacion = 'OK'
            ) ) );

        TYPE rec_sesasdatgen IS RECORD (
            CODCIA           NUMBER(14, 0),
            CODEMPRESA       NUMBER(14, 0),
            CODREPORTE       VARCHAR2(30),
            CODUSUARIO       VARCHAR2(30),
            NUMPOLIZA        VARCHAR2(30),
            NUMCERTIFICADO   VARCHAR2(30),
            TIPOSEGURO       VARCHAR2(1),
            MONEDA           VARCHAR2(2),
            ENTIDADASEGURADO VARCHAR2(2),
            FECINIVIG        DATE,
            FECFINVIG        DATE,
            FECALTCERT       DATE,
            FECBAJCERT       DATE,
            FECNACIM         DATE,
            FECEMISION       DATE,
            SEXO             VARCHAR2(1),
            STATUSCERT       VARCHAR2(1),
            FORMAVTA         VARCHAR2(2),
            SUBTIPOSEG       VARCHAR2(1),
            TIPODIVIDENDO    VARCHAR2(1),
            ANIOPOLIZA       NUMBER(2, 0),
            OCUPACION        VARCHAR2(3),
            TIPORIESGO       VARCHAR2(1),
            PRIMACEDIDA      NUMBER(18, 2),
            ComisionDirecta  NUMBER(18,10),
            MONTODIVIDENDO   NUMBER(23, 2),
            IDPOLIZA         NUMBER(14, 0),
            IDETPOL          NUMBER(14, 0),
            CodAsegurado     NUMBER(14, 0),
            PLANPOLIZA       VARCHAR2(2),
            MODALIDADPOLIZA  VARCHAR2(2),
            FORMAPAGO        VARCHAR2(1),
            EMISION          VARCHAR2(1)

        --MODASUMASEG	VARCHAR2(1 ),
        --TIPODETALLE	VARCHAR2(3 ),
        --CantAsegModelo      NUMBER,
        --PolConcentrada  VARCHAR2(50),
        --IndAsegModelo  VARCHAR2(1),
        --IdEndoso        NUMBER
        --nCantCertificados  NUMBER,
        --cFormaVta       VARCHAR2(50)*/
        );
        TYPE type_sesasdatgen IS TABLE OF rec_sesasdatgen;
        obj_sesasdatgen type_sesasdatgen;

    BEGIN

        DELETE SICAS_OC.SESAS_DATGEN
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND NUMPOLIZA >= '0'
            AND NUMCERTIFICADO >= '0';

        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND IDSECUENCIA>=0;

        COMMIT;
        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY')  || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');

      --Inserto lo que antes era el cursor: c_archivo
        OPEN CUR_PRINCIPAL;
        LOOP
            FETCH CUR_PRINCIPAL
            BULK COLLECT INTO obj_sesasdatgen;
            FOR x IN 1..obj_sesasdatgen.COUNT LOOP
            nComisionDirecta2 := NVL(obj_sesasdatgen(x).ComisionDirecta ,0);
               /* BEGIN

                    SELECT SUM(PRIMANETA_MONEDA)
                    INTO nComisionDirecta2
                    FROM SICAS_OC.ASEGURADO_CERTIFICADO
                    WHERE CODCIA = obj_sesasdatgen(x).CodCia
                        AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                        AND IDETPOL = obj_sesasdatgen(x).IDetPol;

                    SELECT NVL((ROUND((100 / nComisionDirecta2), 10) * PRIMANETA_MONEDA) *(ROUND((obj_sesasdatgen(x).ComisionDirecta / 100), 10)), 0)
                    INTO nComisionDirecta2
                    FROM SICAS_OC.ASEGURADO_CERTIFICADO
                    WHERE  CODCIA = obj_sesasdatgen(x).CodCia
                        AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                        AND IDETPOL = obj_sesasdatgen(x).IDetPol
                        AND COD_ASEGURADO = obj_sesasdatgen(x).CodAsegurado;

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN 
                        BEGIN                        
                            SELECT SUM(PRIMA_MONEDA)
                            INTO nComisionDirecta2
                            FROM SICAS_OC.DETALLE_POLIZA
                            WHERE CODCIA = obj_sesasdatgen(x).CodCia
                                AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza;

                            SELECT NVL((ROUND((100 / nComisionDirecta2), 10) * PRIMA_MONEDA) *(ROUND((obj_sesasdatgen(x).ComisionDirecta / 100),10)), 0)
                            INTO nComisionDirecta2
                            FROM SICAS_OC.DETALLE_POLIZA
                            WHERE CODCIA = obj_sesasdatgen(x).CodCia
                                AND IDPOLIZA = obj_sesasdatgen(x).IdPoliza
                                AND IDETPOL = obj_sesasdatgen(x).IDetPol
                                AND COD_ASEGURADO = obj_sesasdatgen(x).CodAsegurado;
                        EXCEPTION
                            WHEN OTHERS THEN 
                                nComisionDirecta2 := obj_sesasdatgen(x).ComisionDirecta;
                        END;
                    WHEN OTHERS THEN
                        nComisionDirecta2 := obj_sesasdatgen(x).ComisionDirecta;
                END;
*/
                BEGIN
                    INSERT INTO SICAS_OC.SESAS_DATGEN (
                        CodCia,
                        CodEmpresa,
                        CodReporte,
                        CodUsuario,
                        NumPoliza,
                        NumCertificado,
                        TipoSeguro,
                        Moneda,
                        EntidadAsegurado,
                        FecIniVig,
                        FecFinVig,
                        FecAltCert,
                        FecBajCert,
                        FecNacim,
                        FecEmision,
                        Sexo,
                        StatusCert,
                        FormaVta,
                        SubTipoSeg,
                        TipoDividendo,
                        AnioPoliza,
                        Ocupacion,
                        TipoRiesgo,
                        PrimaCedida,
                        ComisionDirecta,
                        MontoDividendo,
                        IdPoliza,
                        IDetPol,
                        CodAsegurado,
                        PlanPoliza,
                        ModalidadPoliza,
                        FormaPago,
                        Emision
                    ) VALUES (
                        obj_sesasdatgen(x).CodCia,
                        obj_sesasdatgen(x).CodEmpresa,
                        obj_sesasdatgen(x).CodReporte,
                        obj_sesasdatgen(x).CodUsuario,
                        obj_sesasdatgen(x).NumPoliza,
                        obj_sesasdatgen(x).NumCertificado,
                        obj_sesasdatgen(x).TipoSeguro,
                        obj_sesasdatgen(x).Moneda,
                        obj_sesasdatgen(x).EntidadAsegurado,
                        obj_sesasdatgen(x).FecIniVig,
                        obj_sesasdatgen(x).FecFinVig,
                        obj_sesasdatgen(x).FecAltCert,
                        obj_sesasdatgen(x).FecBajCert,
                        obj_sesasdatgen(x).FecNacim,
                        obj_sesasdatgen(x).FecEmision,
                        obj_sesasdatgen(x).Sexo,
                        obj_sesasdatgen(x).StatusCert,
                        obj_sesasdatgen(x).FormaVta,
                        obj_sesasdatgen(x).SubTipoSeg,
                        obj_sesasdatgen(x).TipoDividendo,
                        obj_sesasdatgen(x).AnioPoliza,
                        obj_sesasdatgen(x).Ocupacion,
                        obj_sesasdatgen(x).TipoRiesgo,
                        obj_sesasdatgen(x).PrimaCedida,
                        ROUND(nComisionDirecta2, 2),
                        obj_sesasdatgen(x).MontoDividendo,
                        obj_sesasdatgen(x).IdPoliza,
                        obj_sesasdatgen(x).IDetPol,
                        obj_sesasdatgen(x).CodAsegurado,
                        obj_sesasdatgen(x).PlanPoliza,
                        obj_sesasdatgen(x).ModalidadPoliza,
                        obj_sesasdatgen(x).FormaPago,
                        obj_sesasdatgen(x).Emision
                    );

                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(
                        x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, 'El registro ya existe en la SESA, favor de validarlo.');
                    WHEN OTHERS THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(obj_sesasdatgen(x).CodCia, obj_sesasdatgen(x).CodEmpresa, obj_sesasdatgen(
                        x).CodReporte, obj_sesasdatgen(x).CodUsuario, obj_sesasdatgen(x).NumPoliza,
                                                                     obj_sesasdatgen(x).NumCertificado, SQLCODE, SQLERRM);
                END;

            END LOOP;

            EXIT WHEN obj_sesasdatgen.COUNT = 0;
        END LOOP;

        CLOSE CUR_PRINCIPAL;
        COMMIT;
    END DATGEN_AP;

    PROCEDURE EMISION_AP (
        nCodCia           SICAS_OC.SESAS_EMISION.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_EMISION.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_EMISION.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    ) IS

        nPmaEmiCob         NUMBER(20, 10);
        nMtoAsistLocal     NUMBER(20, 2);
      --
        nIdPoliza          DETALLE_POLIZA.IDPOLIZA%TYPE;
        nIDetPol           DETALLE_POLIZA.IDETPOL%TYPE;
        nCod_Asegurado     DETALLE_POLIZA.COD_ASEGURADO%TYPE;
        dFecIniVig         DETALLE_POLIZA.FECINIVIG%TYPE;
        dFecFinVig         DETALLE_POLIZA.FECFINVIG%TYPE;
        nIdPolizaProc      POLIZAS.IdPoliza%TYPE;
        nIDetPolProc       DETALLE_POLIZA.IDetPol%TYPE;
        nIdPolizaProcCalc  POLIZAS.IdPoliza%TYPE := 0;
        nIdPolizaCalc      POLIZAS.IdPoliza%TYPE := 0;
        cStatus1           VARCHAR2(6);
        cStatus2           VARCHAR2(6);
        cStatus3           VARCHAR2(6);
        cStatus4           VARCHAR2(6);
        cStatus5           VARCHAR2(6) := 'SOL';
        cStatus6           VARCHAR2(6) := 'SOLICI';
        cCodCobert         COBERTURAS_DE_SEGUROS.CodCobert%TYPE;
        nPrimaMonedaTotPol POLIZAS.PrimaNeta_Moneda%TYPE;
        cTodasAnuladas     VARCHAR2(1);
        nPrima_Moneda      COBERT_ACT.Prima_Moneda%TYPE;
        cRecalculoPrimas   VARCHAR2(1);
        nIdTarifa          TARIFA_CONTROL_VIGENCIAS.IdTarifa%TYPE;
        cSexo              PERSONA_NATURAL_JURIDICA.Sexo%TYPE;
        cRiesgo            ACTIVIDADES_ECONOMICAS.RiesgoActividad%TYPE;
        cCodActividad      PERSONA_NATURAL_JURIDICA.CodActividad%TYPE;
        nEdad              NUMBER(5);
        nTasa              NUMBER;
        nPeriodoEspCob     COBERTURAS_DE_SEGUROS.PeriodoEsperaMeses%TYPE;
        cTipoSumaSeg       VARCHAR2(1);
        nCodAseguradoAfina ASEGURADO.COD_ASEGURADO%TYPE;
        nPrimaDevengada    SICAS_OC.SESAS_EMISION.PrimaDevengada%TYPE;
      --
        CURSOR cPolizas_DatGen IS
        SELECT
            IdPoliza,
            IDetPol,
            CodAsegurado,
            FecIniVig,
            FecFinVig,
            FecBajCert,
            TipoDetalle,
            NumPoliza,
            NumCertificado
        FROM SICAS_OC.SESAS_DATGEN
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = 'SESADATAPI'
            AND CodUsuario = cCodUsuario
            AND NUMPOLIZA >= '0'
            AND NUMCERTIFICADO >= '0';
      --
        CURSOR POL_Q IS
        SELECT
            P.IdPoliza,
            P.StsPoliza,
            P.TipoAdministracion,
            D.IdTipoSeg,
            D.PlanCob,
            D.FecIniVig
        FROM SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA D ON D.IdPoliza = P.IdPoliza
            AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
                                                    AND D.CodCia = P.CodCia
        WHERE  P.CodCia = nCodCia
            AND P.IdPoliza = nIdPolizaProc
            AND P.StsPoliza NOT IN ( 'SOL', 'PRE' )
            AND ( P.MotivAnul IS NULL
                  OR NVL(P.MotivAnul, 'NULL') IS NOT NULL
                  AND P.FecSts BETWEEN dvarFecDesde AND dvarFecHasta )
        UNION
        SELECT
            P.IdPoliza,
            P.StsPoliza,
            P.TipoAdministracion,
            D.IdTipoSeg,
            D.PlanCob,
            D.FecIniVig
        FROM
                 SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA D ON D.IdPoliza = P.IdPoliza
            AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
                                                    AND D.CodCia = P.CodCia
        WHERE
                P.CodCia = nCodCia
            AND P.IdPoliza != nIdPolizaProc
            AND P.StsPoliza NOT IN ( 'SOL', 'PRE' )
            AND P.NumPolUnico IN (
                SELECT
                    NumPolUnico
                FROM
                    SICAS_OC.POLIZAS
                WHERE
                        CodCia = nCodCia
                    AND IdPoliza = nIdPolizaProc
            )
            AND D.IDetPol = nIDetPolProc
            AND ( D.MotivAnul IS NULL
                  OR NVL(D.MotivAnul, 'NULL') IS NOT NULL
                  AND D.FecAnul BETWEEN dvarFecDesde AND dvarFecHasta
                  OR P.StsPoliza = 'ANU'
                  AND P.FecSts BETWEEN dvarFecDesde AND dvarFecHasta );

        CURSOR COBERT_Q IS
        SELECT
            C.CodCobert,
            NVL(OrdenSESAS, 0)         OrdenSESAS,
            NVL(PeriodoEsperaMeses, 0) PeriodoEspera,
            NVL(ClaveSESASNEW, '99')   ClaveSESAS,
            SUM(SumaAseg_Moneda)       Suma_Moneda,
            SUM(C.Prima_Moneda)        Prima_Moneda
        FROM
                 SICAS_OC.COBERT_ACT C
            INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS ON CS.CodCobert = C.CodCobert
                                                            AND CS.PlanCob = C.PlanCob
                                                            AND CS.IdTipoSeg = C.IdTipoSeg
                                                            AND CS.CodEmpresa = C.CodEmpresa
                                                            AND CS.CodCia = C.CodCia
        WHERE
            C.StsCobertura NOT IN ( cStatus1, cStatus2, cStatus5 )
            --AND C.Cod_Asegurado = nCod_Asegurado
            AND C.IDetPol = nIDetPol
            AND C.IdPoliza = nIdPoliza
            AND C.CodCia = nCodCia
            AND CS.CLAVESESASNEW <> '10'
        GROUP BY
            C.CodCobert,
            NVL(OrdenSESAS, 0),
            NVL(PeriodoEsperaMeses, 0),
            NVL(ClaveSESASNEW, '99')
        UNION ALL
        SELECT
            C.CodCobert,
            NVL(CS.OrdenSESAS, 0)         OrdenSESAS,
            NVL(CS.PeriodoEsperaMeses, 0) PeriodoEspera,
            NVL(CS.CLAVESESASNEW, '99')   ClaveSESAS,
            0.0                           Suma_Moneda,
            SUM(C.Prima_Moneda)           Prima_Moneda
        FROM
                 SICAS_OC.COBERT_ACT C
            INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS ON CS.CodCobert = C.CodCobert
                                                            AND CS.PlanCob = C.PlanCob
                                                            AND CS.IdTipoSeg = C.IdTipoSeg
                                                            AND CS.CodEmpresa = C.CodEmpresa
                                                            AND CS.CodCia = C.CodCia
        WHERE
            C.StsCobertura NOT IN ( cStatus1, cStatus2, cStatus5 )
           -- AND C.Cod_Asegurado = nCod_Asegurado
            AND C.IDetPol = nIDetPol
            AND C.IdPoliza = nIdPoliza
            AND C.CodCia = nCodCia
            AND CS.CLAVESESASNEW = '10'
        GROUP BY
            C.CodCobert,
            NVL(OrdenSESAS, 0),
            NVL(PeriodoEsperaMeses, 0),
            NVL(CLAVESESASNEW, '99')
        UNION ALL
        SELECT
            C.CodCobert,
            NVL(OrdenSESAS, 0)         OrdenSESAS,
            NVL(PeriodoEsperaMeses, 0) PeriodoEspera,
            NVL(ClaveSESASNEW, '99')   ClaveSESAS,
            SUM(SumaAseg_Moneda)       Suma_Moneda,
            SUM(C.Prima_Moneda)        Prima_Moneda
        FROM
                 SICAS_OC.COBERT_ACT_ASEG C
            INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS ON CS.CodCobert = C.CodCobert
                                                            AND CS.PlanCob = C.PlanCob
                                                            AND CS.IdTipoSeg = C.IdTipoSeg
                                                            AND CS.CodEmpresa = C.CodEmpresa
        WHERE
            C.StsCobertura NOT IN ( cStatus1, cStatus2, cStatus5 )
           -- AND C.Cod_Asegurado = nCod_Asegurado
            AND C.IDetPol = nIDetPol
            AND C.IdPoliza = nIdPoliza
            AND C.CodCia = nCodCia
            AND CS.CLAVESESASNEW <> '10'
        GROUP BY
            C.CodCobert,
            NVL(OrdenSESAS, 0),
            NVL(PeriodoEsperaMeses, 0),
            NVL(ClaveSESASNEW, '99')
        UNION ALL
        SELECT
            C.CodCobert,
            NVL(OrdenSESAS, 0)         OrdenSESAS,
            NVL(PeriodoEsperaMeses, 0) PeriodoEspera,
            NVL(CLAVESESASNEW, '99')   ClaveSESAS,
            0.0                        Suma_Moneda,
            SUM(C.Prima_Moneda)        Prima_Moneda
        FROM
                 SICAS_OC.COBERT_ACT_ASEG C
            INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS ON CS.CodCobert = C.CodCobert
                                                            AND CS.PlanCob = C.PlanCob
                                                            AND CS.IdTipoSeg = C.IdTipoSeg
                                                            AND CS.CodEmpresa = C.CodEmpresa
                                                            AND CS.CodCia = C.CodCia
        WHERE
            C.StsCobertura NOT IN ( cStatus1, cStatus2, cStatus5 )
            --AND C.Cod_Asegurado = nCod_Asegurado
            AND C.IDetPol = nIDetPol
            AND C.IdPoliza = nIdPoliza
            AND C.CodCia = nCodCia
            AND CS.CLAVESESASNEW = '10'
        GROUP BY
            C.CodCobert,
            NVL(OrdenSESAS, 0),
            NVL(PeriodoEsperaMeses, 0),
            NVL(CLAVESESASNEW, '99');

      --
        CURSOR CALC_Q IS
        SELECT
            C.Cod_Asegurado,
            C.SumaAseg_Moneda,
            C.CodCobert,
            C.Tasa,
            CS.Porc_Tasa,
            CS.CodTarifa,
            C.IdTipoSeg,
            C.PlanCob,
            DECODE(CS.TipoTasa, 'C', 100, DECODE(CS.TipoTasa, 'M', 1000, 1)) FactorTasa,
            CS.Prima_Cobert
        FROM
                 SICAS_OC.COBERT_ACT C
            INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS ON CS.CodCobert = C.CodCobert
                                                            AND CS.PlanCob = C.PlanCob
                                                            AND CS.IdTipoSeg = C.IdTipoSeg
                                                            AND CS.CodEmpresa = C.CodEmpresa
                                                            AND CS.CodCia = C.CodCia
        WHERE
                C.SumaAseg_Moneda > 0
            AND C.CodCia = nCodCia
            AND C.IdPoliza = nIdPolizaCalc
        UNION ALL
        SELECT
            C.Cod_Asegurado,
            C.SumaAseg_Moneda,
            C.CodCobert,
            C.Tasa,
            CS.Porc_Tasa,
            CS.CodTarifa,
            C.IdTipoSeg,
            C.PlanCob,
            DECODE(CS.TipoTasa, 'C', 100, DECODE(CS.TipoTasa, 'M', 1000, 1)) FactorTasa,
            CS.Prima_Cobert
        FROM
                 SICAS_OC.COBERT_ACT_ASEG C
            INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS ON CS.CodCobert = C.CodCobert
                                                            AND CS.PlanCob = C.PlanCob
                                                            AND CS.IdTipoSeg = C.IdTipoSeg
                                                            AND CS.CodEmpresa = C.CodEmpresa
                                                            AND CS.CodCia = C.CodCia
        WHERE
                C.SumaAseg_Moneda > 0
            AND C.CodCia = nCodCia
            AND C.IdPoliza = nIdPolizaCalc;

        nDiasRenta         NUMBER;
    BEGIN

        DELETE SICAS_OC.SESAS_EMISION
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND NUMPOLIZA >= '0'
            AND NUMCERTIFICADO >= '0';

        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND IDSECUENCIA>=0;

        COMMIT;
        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY')  || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY')  || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');
        
        SICAS_OC.OC_SESASINDIVIDUAL.DATGEN_AP(nCodCia, nCodEmpresa, dFecDesde, dFecHasta, cCodUsuario, 'SESADATAPI', 'SESADATAPI'/*cCodReporteProces*/, cFiltrarPolizas);

        FOR x IN cPolizas_DatGen LOOP
            nIdPoliza := x.IdPoliza;
            nIDetPol := x.IDetPol;
            nCod_Asegurado := x.CodAsegurado;
            dFecIniVig := x.FecIniVig;
            dFecFinVig := x.FecFinVig;
            nIdPolizaProc := x.IdPoliza;
            nIDetPolProc := x.IDetPol;
            nMtoAsistLocal := 0;
            nPmaEmiCob := 0;
            IF NVL(nIdPolizaProcCalc, 0) != NVL(nIdPoliza, 0) THEN
                nIdPolizaProcCalc := nIdPoliza;
                nPrimaMonedaTotPol := 0;
             --
             -- Verifica si Todas Están Anuladas
                cTodasAnuladas := 'N';
                FOR z IN POL_Q LOOP
                    IF z.StsPoliza != 'ANU' THEN
                        cTodasAnuladas := 'N';
                        EXIT;
                    ELSE
                        cTodasAnuladas := 'S';
                    END IF;
                END LOOP;
             --
                FOR z IN POL_Q LOOP
                    IF cTodasAnuladas = 'N' THEN
                        IF Z.StsPoliza IN ( 'EMI', 'REN' ) THEN
                            cStatus1 := 'CEX';
                            cStatus2 := ' ';
                            cStatus3 := 'EXCLUI';
                            cStatus4 := ' ';
                        ELSE
                            cStatus1 := 'CEX';
                            cStatus2 := 'ANU';
                            cStatus3 := 'EXCLUI';
                            cStatus4 := 'ANULAD';
                        END IF;
                    --
                        SELECT
                            NVL(SUM(Prima_Moneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                        INTO nPrimaMonedaTotPol
                        FROM
                            SICAS_OC.COBERT_ACT
                        WHERE
                                CodCia = nCodCia
                            AND IdPoliza = z.IdPoliza
                            AND StsCobertura NOT IN ( cStatus1, cStatus2, cStatus5 );
                    --
                        SELECT
                            NVL(SUM(MontoAsistMoneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                        INTO nPrimaMonedaTotPol
                        FROM
                            SICAS_OC.ASISTENCIAS_DETALLE_POLIZA
                        WHERE
                                CodCia = nCodCia
                            AND IdPoliza = z.IdPoliza
                            AND StsAsistencia NOT IN ( cStatus3, cStatus4, cStatus6 );
                    --
                        SELECT
                            NVL(SUM(Prima_Moneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                        INTO nPrimaMonedaTotPol
                        FROM
                            SICAS_OC.COBERT_ACT_ASEG
                        WHERE
                                CodCia = nCodCia
                            AND IdPoliza = z.IdPoliza
                            AND StsCobertura NOT IN ( cStatus1, cStatus2, cStatus5 );
                    --
                        SELECT
                            NVL(SUM(MontoAsistMoneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                        INTO nPrimaMonedaTotPol
                        FROM
                            SICAS_OC.ASISTENCIAS_ASEGURADO
                        WHERE
                                CodCia = nCodCia
                            AND IdPoliza = z.IdPoliza
                            AND StsAsistencia NOT IN ( cStatus3, cStatus4, cStatus6 );

                    ELSIF  cTodasAnuladas = 'S' AND nIdPolizaProcCalc = z.IdPoliza THEN
                        SELECT
                            NVL(SUM(Prima_Moneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                        INTO nPrimaMonedaTotPol
                        FROM
                            SICAS_OC.COBERT_ACT
                        WHERE
                                CodCia = nCodCia
                            AND IdPoliza = z.IdPoliza;
                    --
                        SELECT
                            NVL(SUM(MontoAsistMoneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                        INTO nPrimaMonedaTotPol
                        FROM
                            SICAS_OC.ASISTENCIAS_DETALLE_POLIZA
                        WHERE
                                CodCia = nCodCia
                            AND IdPoliza = z.IdPoliza;
                    --
                        SELECT
                            NVL(SUM(Prima_Moneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                        INTO nPrimaMonedaTotPol
                        FROM
                            SICAS_OC.COBERT_ACT_ASEG
                        WHERE
                                CodCia = nCodCia
                            AND IdPoliza = z.IdPoliza;
                    --
                        SELECT
                            NVL(SUM(MontoAsistMoneda), 0) + NVL(nPrimaMonedaTotPol, 0)
                        INTO nPrimaMonedaTotPol
                        FROM
                            SICAS_OC.ASISTENCIAS_ASEGURADO
                        WHERE
                                CodCia = nCodCia
                            AND IdPoliza = z.IdPoliza;

                    END IF;
                END LOOP; 
             --
                IF NVL(nPrimaMonedaTotPol, 0) = 0 THEN
                    FOR z IN POL_Q LOOP
                        nIdPolizaCalc := z.IdPoliza;
                        nIdTarifa := SICAS_OC.GT_TARIFA_CONTROL_VIGENCIAS.TARIFA_VIGENTE(nCodCia, nCodEmpresa, z.IdTipoSeg, z.PlanCob,
                        z.FecIniVig);
                    --
                        nCodAseguradoAfina := NULL;
                        FOR w IN CALC_Q LOOP
                            IF w.Tasa > 0 THEN
                                nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol, 0) + ( w.SumaAseg_Moneda * w.Tasa );

                            ELSIF w.CodTarifa IS NULL THEN
                                IF NVL(w.Prima_Cobert, 0) != 0 THEN
                                    nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol, 0) + NVL(w.Prima_Cobert, 0);

                                ELSE
                                    nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol, 0) + ( w.SumaAseg_Moneda * w.Porc_Tasa / 1000 );
                                END IF;
                            ELSE
                           --Afinación para no obtener N veces la mismsa información cuando se trata del mismo asegurado
                                IF nCodAseguradoAfina IS NULL OR nCodAseguradoAfina <> w.Cod_Asegurado THEN
                                    nCodAseguradoAfina := w.Cod_Asegurado;
                                    BEGIN
                                        SICAS_OC.OC_PROCESOSSESAS.DATOSASEGURADO(nCodCia, nCodEmpresa, w.Cod_Asegurado, dFecIniVig, cSexo,
                                                                                nEdad, cCodActividad, cRiesgo);

                                        IF cSexo IS NULL OR nEdad IS NULL OR cCodActividad IS NULL OR cRiesgo IS NULL THEN
                                            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario,
                                            nIdPoliza,
                                                                                         'ER-' || nCod_Asegurado, SQLCODE, SQLERRM); 
                                        --EXIT; --BREAK
                                        END IF;

                                    EXCEPTION
                                        WHEN OTHERS THEN --ERROR ZIP
                                            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario,
                                            nIdPoliza,
                                                                                         'ER2-' || nCod_Asegurado, SQLCODE, SQLERRM);
                                    END;

                                END IF;
                           --
                                BEGIN
                                    nTasa := OC_TARIFA_SEXO_EDAD_RIESGO.TASA_TARIFA(nCodCia, nCodEmpresa, w.IdTipoSeg, w.PlanCob, w.CodCobert,nEdad, cSexo, cRiesgo, nIdTarifa);

                                EXCEPTION
                                    WHEN OTHERS THEN
                                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario,
                                        nIdPoliza,
                                                                                     'ER1-OC_TARIFA_SEXO_EDAD_RIESGO: ' || nCod_Asegurado,
                                                                                     SQLCODE, SQLERRM);
                                END;

                           --IF nTasa IS NULL OR nTasa = '' THEN
                            --SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia,nCodEmpresa,cCodReporteProces,cCodUsuario,nIdPoliza,'ER2-OC_TARIFA_SEXO_EDAD_RIESGO: '||nCod_Asegurado,SQLCODE,SQLERRM); 
                           --END IF;

                                nPrimaMonedaTotPol := NVL(nPrimaMonedaTotPol, 0) + W.SumaAseg_Moneda * nTasa / W.FactorTasa;

                            END IF;
                        END LOOP;

                    END LOOP;
                END IF;
             --
                IF NVL(nPrimaMonedaTotPol, 0) = 0 THEN
                    nPrimaMonedaTotPol := 1;
                END IF;
            END IF;
          --
            FOR z IN POL_Q LOOP
                IF cTodasAnuladas = 'N' AND nIdPolizaProcCalc = z.IdPoliza THEN
                    IF z.StsPoliza IN ( 'EMI', 'REN' ) THEN
                        cStatus1 := 'CEX';
                        cStatus2 := ' ';
                        cStatus3 := 'EXCLUI';
                        cStatus4 := ' ';
                    ELSE
                        cStatus1 := 'CEX';
                        cStatus2 := 'ANU';
                        cStatus3 := 'EXCLUI';
                        cStatus4 := 'ANULAD';
                    END IF;

                ELSIF  cTodasAnuladas = 'S' AND nIdPolizaProcCalc = z.IdPoliza THEN
                    cStatus1 := ' ';
                    cStatus2 := ' ';
                    cStatus3 := ' ';
                    cStatus4 := ' ';
                END IF;
            END LOOP;
          --
            SELECT
                NVL(SUM(MontoAsistLocal), 0)
            INTO nMtoAsistLocal
            FROM
                SICAS_OC.ASISTENCIAS_DETALLE_POLIZA
            WHERE
                    CodCia = nCodCia
                AND CodEmpresa = nCodEmpresa
                AND IdPoliza = nIdPoliza
                AND IDetPol = nIDetPol
                AND StsAsistencia <> 'EXCLUI';
          --

          cStatus2 :='A';
            FOR w IN COBERT_Q LOOP

              --IF w.PeriodoEspera > NVL(nPeriodoEspCob, 0) THEN
              --   nPeriodoEspCob := w.PeriodoEspera;
              --END IF; 


              --se cambiar el valor de la variable ya que no se le asigno valor y e pone el valor de la consulta
              --nPmaEmiCob     := NVL(nPrima_Moneda, 0);
                nPmaEmiCob := NVL(w.Prima_Moneda, 0);
              --
                IF w.OrdenSESAS = 1 THEN
                    nPmaEmiCob := NVL(nPmaEmiCob, 0) + NVL(nMtoAsistLocal, 0);
                    nMtoAsistLocal := 0;
                END IF;
              --
              --nPrimaDevengada := nPmaEmiCob; --Ver calculo
                nPrimaDevengada := SICAS_OC.OC_PROCESOSSESAS.GETPRIMADEVENGADA(nidPoliza, nPmaEmiCob, dFecHasta, dFecIniVig, dFecFinVig);

                nDiasRenta := SICAS_OC.OC_PROCESOSSESAS.GETNUMDIASRENTA();
              --Inserto Emisión/Coberturas
                /*IF x.Fecbajcert < dvarFecDesde THEN
                    nPmaEmiCob := 0;
                END IF;
                */
                IF dFecFinVig <= dFecHasta THEN
                    nPrimaDevengada := nPmaEmiCob;
                END IF;

                BEGIN
                    INSERT INTO SICAS_OC.SESAS_EMISION (
                        CodCia,
                        CodEmpresa,
                        CodReporte,
                        CodUsuario,
                        NumPoliza,
                        NumCertificado,
                        Cobertura,
                        TipoSumaSeg,
                        PeriodoEspera,
                        SumaAsegurada,
                        PrimaEmitida,
                        PrimaDevengada,
                        NumDiasRenta,
                        TipoExtraPrima,
                        OrdenSesas
                    ) VALUES (
                        nCodCia,
                        nCodEmpresa,
                        cCodReporteProces,
                        cCodUsuario,
                        x.NumPoliza,
                        x.NumCertificado,
                        LPAD(w.ClaveSESAS, 2, '0'),
                        cTipoSumaSeg,
                        w.PeriodoEspera,
                        NVL(w.Suma_Moneda, 0),
                        nPmaEmiCob,
                        nPrimaDevengada,
                        nDiasRenta,
                        NULL,
                        w.OrdenSESAS
                    );

                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        UPDATE SICAS_OC.SESAS_EMISION
                        SET
                            PrimaEmitida = NVL(PrimaEmitida, 0) + NVL(nPmaEmiCob, 0),
                            SumaAsegurada = NVL(SumaAsegurada, 0) + NVL(NVL(w.Suma_Moneda, 0), 0),
                            primadevengada = primadevengada + nPrimaDevengada,
                                            fechainsert = sysdate
                        WHERE
                                CodCia = nCodCia
                            AND CodEmpresa = nCodEmpresa
                            AND CodReporte = cCodReporteProces
                            AND CodUsuario = cCodUsuario
                            AND NumPoliza = x.NumPoliza
                            AND NumCertificado = x.NumCertificado
                            AND Cobertura = LPAD(w.ClaveSESAS, 2, '0');
                      --AND  OrdenSesas     = nOrdenSesas;
                        COMMIT;
                    WHEN OTHERS THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, x.NumPoliza, x.NumCertificado, SQLCODE, SQLERRM);
                END;

              --
            END LOOP;

        END LOOP;
        COMMIT;

       FOR x IN cPolizas_DatGen LOOP      

                SELECT SUM(SUMAASEG),SUM(PRIMANETA)
                INTO nComisionDirecta2,nPmaEmiCob
                FROM SICAS_OC.ASEGURADO_CERTIFICADO
                WHERE CODCIA = nCodCia
                    AND IDPOLIZA = x.IdPoliza
                    AND IDETPOL = x.IDetPol;

                IF nComisionDirecta2 IS NULL THEN 

                    SELECT SUM(SUMA_ASEG_MONEDA),SUM(PRIMA_MONEDA)
                    INTO nComisionDirecta2,nPmaEmiCob
                    FROM SICAS_OC.DETALLE_POLIZA 
                    WHERE CODCIA = nCodCia
                        AND IDPOLIZA = x.IdPoliza
                        AND IDETPOL = x.IDetPol;

               END IF;

               IF nComisionDirecta2 IS NULL THEN               
                    nComisionDirecta2 := nPmaEmiCob;
               END IF;


                SELECT COUNT(1) --Total de coberturas
                INTO vl_Total1
                FROM SICAS_OC.COBERT_ACT 
                WHERE IDPOLIZA = x.IdPoliza
                    AND IDETPOL = x.IDetPol
                    AND COD_ASEGURADO = x.CodAsegurado;

                IF vl_Total1 > 1 THEN

                    BEGIN

                        SELECT COUNT(1) --Total de coberturas
                        INTO vl_Total2
                        FROM SICAS_OC.COBERT_ACT 
                        WHERE IDPOLIZA = x.IdPoliza
                            AND IDETPOL = x.IDetPol
                            AND COD_ASEGURADO = x.CodAsegurado
                            AND PRIMA_MONEDA = 0
                        GROUP BY IDPOLIZA,IDETPOL,COD_ASEGURADO;
                    EXCEPTION
                        WHEN OTHERS THEN
                            vl_Total2 := 0;
                    END;

                IF ((vl_Total1 = 2) AND (vl_Total2 = 1)) OR ((vl_Total1 > 2) AND (vl_Total2 >= 2)) THEN

                    UPDATE SICAS_OC.SESAS_EMISION E
                    SET PrimaEmitida = NVL((ROUND((100 / nComisionDirecta2), 10) * NVL(SumaAsegurada, 0)) *(ROUND((nPmaEmiCob / 100), 10)), 0)   ,
                        PrimaDevengada = SICAS_OC.OC_PROCESOSSESAS.GETPRIMADEVENGADA(x.IdPoliza, NVL((ROUND((100 / nComisionDirecta2), 10) * NVL(SumaAsegurada, 0)) *(ROUND((nPmaEmiCob / 100), 10)), 0) , dvarFecHasta, x.FecIniVig,x.FecFinVig),
                                                fechainsert = sysdate
                    WHERE NUMCERTIFICADO||COBERTURA = TRIM(LPAD(x.IdPoliza, 8, '0')) ||TRIM(LPAD(x.IDetPol, 2, '0')) ||TRIM(LPAD(x.CodAsegurado, 10, '0'))||COBERTURA;
                END IF;
            END IF;
        END LOOP;

        COMMIT;

    END EMISION_AP;

    PROCEDURE SINIESTROS_AP (
        nCodCia           SICAS_OC.SESAS_SINIESTROS.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_SINIESTROS.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_SINIESTROS.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_SINIESTROS.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_SINIESTROS.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    ) IS

        dFecConSin        SICAS_OC.SESAS_SINIESTROS.FECCONSIN%TYPE;
        dFecPagSin        SICAS_OC.SESAS_SINIESTROS.FECPAGSIN%TYPE;
        nMontoPagSin      SICAS_OC.SESAS_SINIESTROS.MONTOPAGSIN%TYPE;
        nNumAprobacion    APROBACIONES.NUM_APROBACION%TYPE;
        nIdTransaccion    APROBACIONES.IDTRANSACCION%TYPE;
        nMontoDeducible   SICAS_OC.SESAS_SINIESTROS.MONTODEDUCIBLE%TYPE;
        cTipAprobacion    NUMBER;
        nMontoDividendo   NUMBER;
        nMontoVencimiento NUMBER;
        cTipoPago         VARCHAR2(4000);
        nPeriodoEspera    NUMBER;
        cTipoGasto        VARCHAR2(4000);
        nMontoRescate     NUMBER;
        cCausaSiniestro   VARCHAR2(4000);
      --
        CURSOR cSiniestros IS
        SELECT
            P.NumPolUnico                                                                                                           NumPoliza,
            TRIM(LPAD(S.IdPoliza, 8, '0'))
            || TRIM(LPAD(S.IDetPol, 2, '0'))
            || TRIM(LPAD(S.Cod_Asegurado, 10, '0'))                                                                                 NumCertificado,
            S.IdSiniestro                                                                                                           NumSiniestro,
            S.Fec_Ocurrencia                                                                                                        FecOcuSin,
            S.Fec_Notificacion                                                                                                      FecRepSin,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(S.CODPAISOCURR, S.CODPROVOCURR, PN.CODPAISRES, PN.CODPROVRES, S.IdPoliza) EntOcuSin,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSIN(S.CodCia, P.IdPoliza, S.IdSiniestro, S.Sts_Siniestro,(
                CASE
                    WHEN R.TIPO_MOVIMIENTO IN('PAGOS') THEN
                        R.IMPTE_MOVIMIENTO *(
                            CASE
                                WHEN R.SIGNO = '-' THEN
                                    - 1
                                ELSE
                                    1
                            END
                        )
                    ELSE
                        0
                END
            ) +(
                CASE
                    WHEN R.TIPO_MOVIMIENTO IN('DESPAG', 'DESCUE', 'DEDUC') THEN
                        R.IMPTE_MOVIMIENTO *(
                            CASE
                                WHEN R.SIGNO = '-' THEN
                                    - 1
                                ELSE
                                    1
                            END
                        )
                    ELSE
                        0
                END
            ),(
                CASE
                    WHEN R.TIPO_MOVIMIENTO IN('ESTINI', 'AJUMAS', 'AJUMEN') THEN
                        R.IMPTE_MOVIMIENTO *(
                            CASE
                                WHEN R.SIGNO = '-' THEN
                                    - 1
                                ELSE
                                    1
                            END
                        )
                    ELSE
                        0
                END
            ), 'SINAPI')                                                                                                            StatusReclamacion,
            CASE
                WHEN LENGTH(NVL(REPLACE(S.submotivo_siniestro, '.', ''), S.Motivo_De_Siniestro)) = 3 THEN
                    S.Motivo_De_Siniestro || 'X'
                ELSE
                    NVL(REPLACE(S.submotivo_siniestro, '.', ''), S.Motivo_De_Siniestro)
            END                                                                                                                     CausaSiniestro,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                          Sexo,
            PN.FecNacimiento                                                                                                        FecNacim,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOMOVRECLAMO()                                                                           TipMovRec,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, P.IdPoliza, NULL)                                                      MontoCoaseguro  --Default 1  
            ,
            0                                                                                                                       MontoRecRea      --Default 0
                  --, S.Monto_Pago_Moneda
                  --, S.Monto_Reserva_Moneda
            ,
            (
                CASE
                    WHEN R.TIPO_MOVIMIENTO IN ( 'PAGOS' ) THEN
                        R.IMPTE_MOVIMIENTO * (
                            CASE
                                WHEN R.SIGNO = '-' THEN
                                    - 1
                                ELSE
                                    1
                            END
                        )
                    ELSE
                        0
                END
            ) + (
                CASE
                    WHEN R.TIPO_MOVIMIENTO IN ( 'DESPAG', 'DESCUE', 'DEDUC' ) THEN
                        R.IMPTE_MOVIMIENTO * (
                            CASE
                                WHEN R.SIGNO = '-' THEN
                                    - 1
                                ELSE
                                    1
                            END
                        )
                    ELSE
                        0
                END
            )                                                                                                                       Monto_Pago_Moneda,
            CASE
                WHEN R.TIPO_MOVIMIENTO IN ( 'ESTINI', 'AJUMAS', 'AJUMEN' ) THEN
                    R.IMPTE_MOVIMIENTO * (
                        CASE
                            WHEN R.SIGNO = '-' THEN
                                - 1
                            ELSE
                                1
                        END
                    )
                ELSE
                    0
            END                                                                                                                     Monto_Reserva_Moneda,
            S.IdPoliza,
            D.IDetPol,
            S.Cod_Asegurado,
            P.MONTODEDUCIBLE
        FROM
                 SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA           D ON D.IdPoliza = P.IdPoliza
                AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
                AND D.CODCIA = P.CODCIA
            INNER JOIN SICAS_OC.SINIESTRO                S ON S.IdPoliza = D.IdPoliza
                                               AND S.IDetPol = D.IDetPol
            INNER JOIN SICAS_OC.ASEGURADO                CL ON CL.Cod_Asegurado = S.Cod_Asegurado
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = CL.Num_Doc_Identificacion
                                                               AND PN.Tipo_Doc_Identificacion = CL.Tipo_Doc_Identificacion
            INNER JOIN SICAS_OC.RESERVA_DET              R ON R.ID_SINIESTRO = S.IDSINIESTRO
                                                 AND R.ID_POLIZA = S.IDPOLIZA
                                                 AND R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta
        WHERE  /*S.Fec_Notificacion        BETWEEN dvarFecDesde AND dvarFecHasta
               AND */
                S.Sts_Siniestro != 'SOL'
            AND D.IdTipoSeg IN (
                SELECT
                    PC.IdTipoSeg IdTipoSeg
                FROM
                    SICAS_OC.PLAN_COBERTURAS PC
                                                  /* INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS  CAS
                                                    ON CAS.IDTIPOSEG = PC.IDTIPOSEG
                                                    AND CAS.PLANCOB = PC.PLANCOB*/
                WHERE  /*(PC.CodTipoPlan = '031'
                                                        OR (PC.CodTipoPlan = '099' AND CAS.IDRAMOREAL =  '030'  AND PC.IdTipoSeg  IN ('PPAQI')))*/
                    ( PC.CodTipoPlan = '031'
                      OR ( EXISTS (
                        SELECT
                            'S'
                        FROM
                            SICAS_OC.COBERTURAS_DE_SEGUROS CAS
                        WHERE
                                CAS.CODCIA = D.CodCia
                            AND CAS.CodEmpresa = D.CodEmpresa
                            AND CAS.IDTIPOSEG = D.IdTipoSeg
                            AND CAS.PLANCOB = D.PLANCOB
                            AND CAS.IDRAMOREAL = '030'
                            AND CAS.CODCOBERT IN (
                                SELECT
                                    CODCOBERT
                                FROM
                                    SICAS_OC.COBERTURAS X
                                WHERE
                                        X.IDPOLIZA = P.IdPoliza
                                    AND X.IDETPOL = D.IDETPOL
                                    AND D.IDTIPOSEG = X.IDTIPOSEG
                            )
                    )
                           AND PC.CodTipoPlan = '099'
                           AND PC.IdTipoSeg = 'PPAQI' ) )
            )
            AND ( EXISTS (
                SELECT
                    'S'
                FROM
                         SICAS_OC.APROBACION_ASEG A
                    INNER JOIN SICAS_OC.COMPROBANTES_CONTABLES B ON B.NumTransaccion = A.IdTransaccion
                WHERE
                        A.IdSiniestro = S.IdSiniestro 
                               /* AND A.IDPOLIZA = S.IdPoliza 
                                AND A.COD_ASEGURADO = S.Cod_Asegurado */
                    AND B.FecComprob BETWEEN dvarFecDesde AND dvarFecHasta
            )
                  OR EXISTS (
                SELECT
                    'S'
                FROM
                         SICAS_OC.APROBACIONES A
                    INNER JOIN SICAS_OC.COMPROBANTES_CONTABLES B ON B.NumTransaccion = A.IdTransaccion
                WHERE
                        A.IdSiniestro = S.IdSiniestro 
                                /*AND A.IDPOLIZA = S.IdPoliza 
                                AND A.COD_ASEGURADO = S.Cod_Asegurado */
                    AND B.FecComprob BETWEEN dvarFecDesde AND dvarFecHasta
            )
                  OR R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta )
            AND D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND ( ( cFiltrarPolizas = 'N' )
                  OR ( cFiltrarPolizas = 'S'
                       AND D.IdPoliza IN (
                SELECT
                    IdPoliza
                FROM
                    SICAS_OC.FILTRAR_POLIZAS_SESAS
                WHERE
                        CodCia = nCodCia
                    AND CodEmpresa = nCodEmpresa
                    AND ProcesoSesas = cCodReporteProces
                    AND UsuarioCarga = cCodUsuario
                    AND Observacion = 'OK'
            ) ) );
   --
        CURSOR cCoberturas (
            nIdPoliza    SINIESTRO.IdPoliza%TYPE,
            nIdSiniestro SINIESTRO.IdSiniestro%TYPE
        ) IS
        SELECT
            NVL(CS.CLAVESESASNEW, '1')                    ClaveSesas,
            NVL(CS.OrdenSesas, 0)                         OrdenSesas
                   -- , CS.CodCobert
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETNUMRECLAMACION() /*C.NumMod */ NumReclamacion,
            SUM(
                CASE
                    WHEN R.TIPO_MOVIMIENTO IN('ESTINI', 'AJUMAS', 'AJUMEN') THEN
                        R.IMPTE_MOVIMIENTO *(
                            CASE
                                WHEN R.SIGNO = '-' THEN
                                    - 1
                                ELSE
                                    1
                            END
                        )
                    ELSE
                        0
                END
            )                                             MontoReclamado,
            NVL(SUM(
                CASE
                    WHEN R.TIPO_MOVIMIENTO =('PAGOS') THEN
                        R.IMPTE_MOVIMIENTO
                END
            ), 0) + NVL(SUM(
                CASE
                    WHEN R.TIPO_MOVIMIENTO IN('DESPAG', 'DESCUE', 'DEDUC') THEN
                        R.IMPTE_MOVIMIENTO *(
                            CASE
                                WHEN R.SIGNO = '-' THEN
                                    - 1
                                ELSE
                                    1
                            END
                        )
                    ELSE
                        0
                END
            ), 0)                                         MontoPagado
        FROM
                 SICAS_OC.SINIESTRO S
            INNER JOIN SICAS_OC.DETALLE_POLIZA        D ON D.IDetPol = S.IDetPol
                                                    AND D.IdPoliza = S.IdPoliza
                                                    AND D.CODCIA = S.CODCIA
            INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS ON CS.PlanCob = D.PlanCob
                                                            AND CS.IdTipoSeg = D.IdTipoSeg
                                                            AND CS.CodEmpresa = D.CodEmpresa
                                                            AND CS.CodCia = D.CodCia
            INNER JOIN SICAS_OC.RESERVA_DET           R ON R.ID_SINIESTRO = S.IDSINIESTRO
                                                 AND R.ID_POLIZA = S.IDPOLIZA
                                                 AND R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta
        WHERE
                S.IdSiniestro = nIdSiniestro
            AND S.IdPoliza = nIdPoliza
            AND R.ID_COBERTURA = Cs.CodCobert
            AND NVL(Cs.IDRAMOREAL, '030') <> '010'
            AND R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta
        GROUP BY
            NVL(CS.CLAVESESASNEW, '1'),
            NVL(CS.OrdenSesas, 0)/*,CS.CodCobert*/,
            SICAS_OC.OC_PROCESOSSESAS.GETNUMRECLAMACION();

            /*

          SELECT NVL(CS.ClaveSesasNEW, '1')      ClaveSesas
               , NVL(CS.OrdenSesas, 0)        OrdenSesas
               , C.CodCobert
               , SICAS_OC.OC_PROCESOSSESAS.GETNUMRECLAMACION() /*C.NumMod */                  --  NumReclamacion
               /*, ((Monto_Reservado_Moneda * (CASE WHEN CTS.SIGNO = '-' THEN -1 ELSE 1 END )))  MontoReclamado
          FROM   SICAS_OC.SINIESTRO               S 
            INNER JOIN SICAS_OC.COBERTURA_SINIESTRO     C
                ON C.IdSiniestro = S.IdSiniestro
                AND C.IDPOLIZA = S.IDPOLIZA
            INNER JOIN SICAS_OC.DETALLE_POLIZA          D
                ON D.IDetPol     = S.IDetPol
                AND  D.IdPoliza    = S.IdPoliza
            INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS  CS
                ON CS.CodCobert  = C.CodCobert
                AND  CS.PlanCob    = D.PlanCob
                AND  CS.IdTipoSeg  = D.IdTipoSeg
                AND  CS.CodEmpresa = D.CodEmpresa
                AND  CS.CodCia     = D.CodCia
            INNER JOIN CONFIG_TRANSAC_SINIESTROS CTS 
                ON CTS.CODTRANSAC = C.CODTRANSAC
          WHERE  C.IdSiniestro = nIdSiniestro
            AND  C.IdPoliza    = nIdPoliza
          GROUP BY NVL(CS.ClaveSesasNEW, '1'), NVL(CS.OrdenSesas, 0), C.CodCobert, C.NumMod,((Monto_Reservado_Moneda * (CASE WHEN CTS.SIGNO = '-' THEN -1 ELSE 1 END )))
          UNION
          SELECT NVL(CS.ClaveSesasNEW, '1')      ClaveSesas
               , NVL(CS.OrdenSesas, 0)        OrdenSesas
               , C.CodCobert
               , C.NumMod                     NumReclamacion
               , ((Monto_Reservado_Moneda * (CASE WHEN CTS.SIGNO = '-' THEN -1 ELSE 1 END )))  MontoReclamado
          FROM   SICAS_OC.SINIESTRO               S 
            INNER JOIN SICAS_OC.COBERTURA_SINIESTRO_ASEG     C
                ON C.IdSiniestro = S.IdSiniestro
                AND C.IDPOLIZA = S.IDPOLIZA
            INNER JOIN SICAS_OC.DETALLE_POLIZA          D
                ON D.IDetPol     = S.IDetPol
                AND  D.IdPoliza    = S.IdPoliza
            INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS  CS
                ON CS.CodCobert  = C.CodCobert
                AND  CS.PlanCob    = D.PlanCob
                AND  CS.IdTipoSeg  = D.IdTipoSeg
                AND  CS.CodEmpresa = D.CodEmpresa
                AND  CS.CodCia     = D.CodCia
            INNER JOIN CONFIG_TRANSAC_SINIESTROS CTS 
                ON CTS.CODTRANSAC = C.CODTRANSAC
          WHERE  C.IdSiniestro = nIdSiniestro
            AND  C.IdPoliza    = nIdPoliza
          GROUP BY NVL(CS.ClaveSesasNEW, '1'), NVL(CS.OrdenSesas, 0), C.CodCobert, C.NumMod,((Monto_Reservado_Moneda * (CASE WHEN CTS.SIGNO = '-' THEN -1 ELSE 1 END )));*/
        nMontoReclamo     NUMBER NULL;
    BEGIN

        DELETE SICAS_OC.SESAS_SINIESTROS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND NUMPOLIZA >= '0'
            AND NUMCERTIFICADO >= '0';

        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND IDSECUENCIA>=0;

        COMMIT;
        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY')
                                || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY')
                                || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');
        FOR x IN cSiniestros LOOP
            FOR y IN cCoberturas(x.IdPoliza, x.NumSiniestro) LOOP
                dFecConSin := NULL;
                dFecPagSin := NULL;
                nMontoPagSin := NULL;
                nNumAprobacion := NULL;
                nIdTransaccion := NULL;
                nMontoDeducible := NULL;

             /* IF nMontoDeducible IS NULL THEN

                SELECT deducible_moneda
                     INTO   nMontoDeducible
                     FROM   SICAS_OC.COBERT_ACT
                     WHERE  CodCia        = nCodCia
                           AND  IdPoliza      = x.IdPoliza
                           AND  IdetPol       = x.IdetPol
                           AND  Cod_Asegurado = x.Cod_Asegurado
                           AND  CodCobert     = y.CodCobert;
                           dbms_output.put_line('1  ('||nMontoDeducible||')');
              END IF;

              IF (nMontoDeducible IS NULL) OR (nMontoDeducible ='') THEN
                SELECT deducible_moneda
                     INTO   nMontoDeducible
                     FROM   SICAS_OC.COBERT_ACT_ASEG
                     WHERE  CodCia        = nCodCia
                           AND  IdPoliza      = x.IdPoliza
                           AND  IdetPol       = x.IdetPol
                           AND  Cod_Asegurado = x.Cod_Asegurado
                           AND  CodCobert     = y.CodCobert;
                           dbms_output.put_line('2  ('||nMontoDeducible||')');
              END IF;*/

              /*IF nMontoDeducible IS NULL THEN
                SELECT MONTODEDUCIBLE
                            INTO nMontoDeducible
                            FROM SICAS_OC.POLIZAS
                            WHERE IdPoliza      = x.IdPoliza;
                        dbms_output.put_line('3  ('||nMontoDeducible||')');
              END IF;

              IF x.NumSiniestro  IN (369057) THEN
                    dbms_output.put_line('poliza  '|| x.IdPoliza  ||'  ASEGURADO  '||x.Cod_Asegurado||'  deducible  '||nMontoDeducible);
                END IF;*/

                nMontoDividendo := NULL;
                nMontoVencimiento := NULL;
                cTipoPago := NULL;
                nPeriodoEspera := NULL;
                cTipoGasto := NULL;
                nMontoRescate := NULL;

             /* SICAS_OC.OC_PROCESOSSESAS.DATOSSINIESTROS(nCodCia,nCodEmpresa,x.IdPoliza,x.NumSiniestro, ''y.CodCobert ,dFecPagSin,nMontoPagSin,dFecConSin);

             /* IF dFecPagSin < dFecDesde OR dFecPagSin > dFecHasta THEN
                dFecPagSin := NULL;
            ELSIF dFecPagSin IS NULL THEN
                BEGIN
                    SELECT MIN(FE_MOVTO)
                    INTO dFecPagSin
                    FROM SICAS_OC.RESERVA_DET
                    WHERE ID_POLIZA = x.IdPoliza
                        AND ID_SINIESTRO = x.NumSiniestro
                        AND AÑO_MOVIMIENTO = TO_NUMBER(TO_CHAR(dvarFecDesde,'YYYY'))
                        AND TIPO_MOVIMIENTO = 'PAGOS';
                EXCEPTION
                    WHEN OTHERS THEN
                        dFecPagSin := NULL;
                END;
            END IF;*/

                BEGIN
                    SELECT
                        MIN(FE_MOVTO)
                    INTO dFecConSin
                    FROM
                        SICAS_OC.RESERVA_DET
                    WHERE
                            ID_POLIZA = x.IdPoliza
                        AND ID_SINIESTRO = x.NumSiniestro
                        AND AÑO_MOVIMIENTO = TO_NUMBER(TO_CHAR(dvarFecDesde, 'YYYY'));

                EXCEPTION
                    WHEN OTHERS THEN
                        dFecConSin := NULL;
                END;

                nMontoReclamo := NVL(x.MONTODEDUCIBLE, 0) + NVL(y.MontoReclamado, 0);


              --Inserto Siniestros/Coberturas
                BEGIN
                    INSERT INTO SICAS_OC.SESAS_SINIESTROS (
                        CodCia,
                        CodEmpresa,
                        CodReporte,
                        CodUsuario,
                        NumPoliza,
                        NumCertificado,
                        NumSiniestro,
                        NumReclamacion,
                        FecOcuSin,
                        FecRepRec,
                        FecConSin,
                        FecPagSin,
                        StatusReclamacion,
                        EntOcuSin,
                        Cobertura,
                        MontoReclamado,
                        CausaSiniestro,
                        MontoDeducible,
                        MontoCoaseguro,
                        MontoPagSin,
                        MontoRecRea,
                        MontoDividendo,
                        TipMovRec,
                        MontoVencimiento,
                        MontoRescate,
                        TipoGasto,
                        PeriodoEspera,
                        TipoPago,
                        Sexo,
                        FecNacim,
                        OrdenSesas
                    ) VALUES (
                        nCodCia,
                        nCodEmpresa,
                        cCodReporteProces,
                        cCodUsuario,
                        x.NumPoliza,
                        x.NumCertificado,
                        x.NumSiniestro,
                        y.NumReclamacion,
                        x.FecOcuSin,
                        x.FecRepSin,
                        dFecConSin,
                        dFecPagSin,
                        x.StatusReclamacion,
                        x.EntOcuSin,
                        y.ClaveSesas,
                        nMontoReclamo,
                        x.CausaSiniestro,
                        NVL(x.MONTODEDUCIBLE, 0),
                        NVL(x.MontoCoaseguro, 0),
                        NVL(y.MontoPagado, 0),
                        NVL(x.MontoRecRea, 0),
                        NVL(nMontoDividendo, 0),
                        x.TipMovRec,
                        NVL(nMontoVencimiento, 0),
                        NVL(nMontoRescate, 0),
                        cTipoGasto,
                        nPeriodoEspera,
                        cTipoPago,
                        x.Sexo,
                        x.FecNacim,
                        y.OrdenSesas
                    );

                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN
                        UPDATE SICAS_OC.SESAS_SINIESTROS
                        SET   /* MontoReclamado   = NVL(MontoReclamado  , 0) + NVL(y.MontoReclamado  , 0)
                          ,    MontoDeducible   = NVL(MontoDeducible  , 0) + NVL(nMontoDeducible  , 0)
                          ,  */
                            MontoCoaseguro = NVL(MontoCoaseguro, 0) + NVL(x.MontoCoaseguro, 0)
                         -- ,    MontoPagSin      = NVL(MontoPagSin     , 0) + NVL(nMontoPagSin     , 0)
                            ,
                            MontoRecRea = NVL(MontoRecRea, 0) + NVL(x.MontoRecRea, 0),
                            MontoDividendo = NVL(MontoDividendo, 0) + NVL(nMontoDividendo, 0),
                            MontoVencimiento = NVL(MontoVencimiento, 0) + NVL(nMontoVencimiento, 0),
                            MontoRescate = NVL(MontoRescate, 0) + NVL(nMontoRescate, 0),
                                            fechainsert = sysdate
                        WHERE
                                CodCia = nCodCia
                            AND CodEmpresa = nCodEmpresa
                            AND CodReporte = cCodReporteProces
                            AND CodUsuario = cCodUsuario
                            AND NumPoliza = x.NumPoliza
                            AND NumCertificado = x.NumCertificado
                            AND NumSiniestro = x.NumSiniestro
                            AND Cobertura = y.ClaveSesas;

                        COMMIT;
                    WHEN OTHERS THEN
                        SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, x.NumPoliza,
                                                                     x.NumCertificado, SQLCODE, SQLERRM);
                END;

                BEGIN
                    SELECT
                        MIN(FE_MOVTO)
                    INTO dFecPagSin
                    FROM
                        SICAS_OC.RESERVA_DET
                    WHERE
                            ID_POLIZA = x.IdPoliza
                        AND ID_SINIESTRO = x.NumSiniestro
                        AND AÑO_MOVIMIENTO = TO_NUMBER(TO_CHAR(dvarFecDesde, 'YYYY'))
                        AND TIPO_MOVIMIENTO = 'PAGOS';

                EXCEPTION
                    WHEN OTHERS THEN
                        dFecPagSin := NULL;
                END;

                UPDATE SICAS_OC.SESAS_SINIESTROS
                SET
                    STATUSRECLAMACION = SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSIN(nCodCia, x.IdPoliza, x.NumSiniestro, x.StatusReclamacion,
                    y.MontoPagado,  nMontoReclamo, 'SINAPI'),
                    FECPAGSIN = dFecPagSin,
                     fechainsert = sysdate
                WHERE
                        NUMPOLIZA = x.NumPoliza
                    AND NUMSINIESTRO = x.NumSiniestro
                    AND COBERTURA = y.ClaveSesas;

            END LOOP;
        END LOOP;

        UPDATE SICAS_OC.SESAS_SINIESTROS
        SET  STATUSRECLAMACION = SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSIN(CodCia, NULL, NumSiniestro, StatusReclamacion, MONTOPAGSIN, MONTORECLAMADO, 'SINAPI'),
            FECPAGSIN = CASE WHEN MONTOPAGSIN = 0 THEN NULL  ELSE FECPAGSIN END,
                fechainsert = sysdate
        WHERE NUMPOLIZA = NumPoliza
            AND NUMSINIESTRO = NumSiniestro;--OrdeSesas

        COMMIT;
    END SINIESTROS_AP;

    PROCEDURE DATGEN_GM (
        nCodCia           SICAS_OC.SESAS_DATGEN.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_DATGEN.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_DATGEN.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_DATGEN.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_DATGEN.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    ) IS
      --
        nCodCia2          SICAS_OC.SESAS_DATGEN.CODCIA%TYPE;
        nCodEmpresa2      SICAS_OC.SESAS_DATGEN.CODEMPRESA%TYPE;
        nIdPoliza         SICAS_OC.SESAS_DATGEN.IDPOLIZA%TYPE;
        nIDetPol          SICAS_OC.SESAS_DATGEN.IDETPOL%TYPE;
        nComisionDirecta  SICAS_OC.SESAS_DATGEN.COMISIONDIRECTA%TYPE;
        nCantCertificados SICAS_OC.SESAS_DATGEN.CANTCERTIFICADOS%TYPE;
        cFormaVta         SICAS_OC.SESAS_DATGEN.FORMAVTA%TYPE;
      --
        CURSOR C_POL_IND_Q IS
        SELECT
            nCodCia                                                                                                               CodCia,
            nCodEmpresa                                                                                                           CodEmpresa,
            cCodReporteDatGen                                                                                                     CodReporte,
            cCodUsuario                                                                                                           CodUsuario,
            P.NumPolUnico                                                                                                         NumPoliza,
            NVL(TRIM(LPAD(XX.IdPoliza, 8, '0'))
                || TRIM(LPAD(XX.IDetPol, 2, '0'))
                || TRIM(LPAD(XX.Cod_Asegurado, 10, '0')), TRIM(LPAD(D.IdPoliza, 8, '0'))
                                                          || TRIM(LPAD(D.IDetPol, 2, '0'))
                                                          || TRIM(LPAD(D.Cod_Asegurado, 10, '0')))                                                                              NumCertificado,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOSEGURO(C.TipoSeguro, NULL)                                                           TipoSeguro,
                DECODE(P.Cod_Moneda, 'PS', '10', 'USD', '20', '30')                                                                 Moneda,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(PN.CodPaisRes, PN.CodProvRes, PN.CodPaisRes, PN.CodProvRes, P.IdPoliza) EntidadAsegurado,
            D.FecIniVig                                                                                                           FecIniVig,
            D.FecFinVig                                                                                                           FecFinVig,
            D.FecIniVig                                                                                                           FecAltCert,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(D.IdPoliza, D.FecIniVig, D.FecFinVig, D.FecAnul, dFecDesde,dFecHasta)                  FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT(D.CodCia, D.IdPoliza, D.IDETPOL, D.FecAnul, dFecHasta,D.StsDetalle, D.FecIniVig, D.FecFinVig, NVL(XX.Cod_Asegurado, D.Cod_Asegurado))             StatusCert,
            NVL(C.SubTipoSeg, '1')                                                                                                SubTipoSeg,
            ( CASE WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN 1 ELSE CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)  END )                                                                                                                     AnioPoliza,
            DECODE(C.MODALSUMAASEG, 'N', 'N', 'N')                                                                                ModSumAseg   --Siempre debe retornar N, se puede implementar una función si se requieren cambiar reglas de negocio
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, P.IdPoliza, 'GMM')                                                    Coaseguro    --no se usa la función porque dicen que por default un 1 y a futuro puede ser una función, tal vez la misma función y poner que si viene de GMMI devolver un 1
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETPRIMACEDIDA(D.CodCia, P.IdPoliza)                                                        PrimaCedida  --no se usa la función porque dicen que por default un 0 y a futuro puede ser una función, tal vez la misma función y poner que si viene de GMMI devolver un 0
            ,
            P.IdPoliza                                                                                                            IdPoliza,
            D.IDetPol                                                                                                             IDetPol,
            NVL(XX.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            NVL(D.CANTASEGMODELO, 0)                                                                                              CANTASEGMODELO
            ,SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(D.CodCia, D.CodEmpresa, D.IdPoliza, dFecDesde, dFecHasta)                  ComisionDirecta
        FROM  SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA      D
                ON D.CodCia = P.CodCia
                AND D.IdPoliza = P.IdPoliza
                AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            LEFT JOIN SICAS_OC.ASEGURADO_CERTIFICADO    XX 
                ON XX.CodCia = D.CodCia
                AND XX.IdPoliza = D.IdPoliza
                AND XX.IdetPol = D.IDetPol
            INNER JOIN SICAS_OC.ASEGURADO                A 
                ON A.Cod_Asegurado = NVL(XX.Cod_Asegurado,D.Cod_Asegurado)
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN 
                ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
            INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC 
                ON PC.IdTipoSeg = D.IdTipoSeg
                AND PC.CodEmpresa = D.CodEmpresa
                AND PC.CodCia = D.CodCia
                AND PC.PlanCob = D.PlanCob
            INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO C 
                ON C.CodCia = PC.CodCia
                AND C.CodEmpresa = PC.CodEmpresa
                AND C.IdTipoSeg = PC.IdTipoSeg

        WHERE PC.CodTipoPlan = '034'  -- Corresponde a GMM Individual
            /*AND ( ( D.FecFinVig BETWEEN dvarFecDesde AND dvarFecHasta  )
                  OR ( D.FecIniVig BETWEEN dvarFecDesde AND dvarFecHasta AND P.FecEmision <= dvarFecHasta ) )*/
            AND (P.FecEmision <= dvarFecHasta AND D.FecFinVig >= dvarFecDesde)
            AND D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
            AND ( ( cFiltrarPolizas = 'N' )
                  OR ( cFiltrarPolizas = 'S' AND D.IdPoliza IN (
                SELECT
                    IdPoliza
                FROM
                    SICAS_OC.FILTRAR_POLIZAS_SESAS
                WHERE
                        CodCia = nCodCia
                    AND CodEmpresa = nCodEmpresa
                    AND ProcesoSesas = cCodReporteProces
                    AND UsuarioCarga = cCodUsuario
                    AND Observacion = 'OK'
            ) ) )
        UNION ALL
        SELECT
            nCodCia                                                                                                               CodCia,
            nCodEmpresa                                                                                                           CodEmpresa,
            cCodReporteDatGen                                                                                                     CodReporte,
            cCodUsuario                                                                                                           CodUsuario,
            P.NumPolUnico                                                                                                         NumPoliza,
            NVL(TRIM(LPAD(XX.IdPoliza, 8, '0'))
                || TRIM(LPAD(XX.IDetPol, 2, '0'))
                || TRIM(LPAD(XX.Cod_Asegurado, 10, '0')), TRIM(LPAD(D.IdPoliza, 8, '0'))
                                                          || TRIM(LPAD(D.IDetPol, 2, '0'))
                                                          || TRIM(LPAD(D.Cod_Asegurado, 10, '0')))                                                                              NumCertificado,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOSEGURO(C.TipoSeguro, NULL)                                                           TipoSeguro,
            DECODE(P.Cod_Moneda, 'PS', '10', 'USD', '20',
                   '30')                                                                                                          Moneda,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(PN.CodPaisRes, PN.CodProvRes, PN.CodPaisRes, PN.CodProvRes, P.IdPoliza) EntidadAsegurado,
            D.FecIniVig                                                                                                           FecIniVig,
            D.FecFinVig                                                                                                           FecFinVig,
            D.FecIniVig                                                                                                           FecAltCert,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(P.IdPoliza, D.FecIniVig, D.FecFinVig, D.FecAnul,dFecDesde, dFecHasta)                  FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT(D.CodCia, D.IdPoliza, D.IDETPOL, D.FecAnul, dFecHasta,
                                                    D.StsDetalle, D.FecIniVig, D.FecFinVig, NVL(XX.Cod_Asegurado, D.Cod_Asegurado))             StatusCert,
            NVL(C.SubTipoSeg, '1')                                                                                                SubTipoSeg,
            (
                CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END
            )                                                                                                                     AnioPoliza,
            DECODE(C.MODALSUMAASEG, 'N', 'N', 'N')                                                                                ModSumAseg   --Siempre debe retornar N, se puede implementar una función si se requieren cambiar reglas de negocio
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, P.IdPoliza, 'GMM')                                                    Coaseguro    --no se usa la función porque dicen que por default un 1 y a futuro puede ser una función, tal vez la misma función y poner que si viene de GMMI devolver un 1
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETPRIMACEDIDA(D.CodCia, P.IdPoliza)                                                        PrimaCedida  --no se usa la función porque dicen que por default un 0 y a futuro puede ser una función, tal vez la misma función y poner que si viene de GMMI devolver un 0
            ,
            P.IdPoliza                                                                                                            IdPoliza,
            D.IDetPol                                                                                                             IDetPol,
            NVL(XX.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            NVL(D.CANTASEGMODELO, 0)                                                                                              CANTASEGMODELO
            ,SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(D.CodCia, D.CodEmpresa, D.IdPoliza, dFecDesde, dFecHasta)                  ComisionDirecta
        FROM
                 SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA      D ON D.CodCia = P.CodCia
                                             AND D.IdPoliza = P.IdPoliza
                                             AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            LEFT JOIN SICAS_OC.ASEGURADO_CERTIFICADO    XX ON XX.CodCia = D.CodCia
                                                           AND XX.IdPoliza = D.IdPoliza
                                                           AND XX.IdetPol = D.IDetPol
            INNER JOIN SICAS_OC.ASEGURADO                A ON A.Cod_Asegurado =  NVL(XX.Cod_Asegurado,D.Cod_Asegurado)
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
            INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC ON PC.IdTipoSeg = D.IdTipoSeg
                                                      AND PC.CodEmpresa = D.CodEmpresa
                                                      AND PC.CodCia = D.CodCia
                                                      AND PC.PlanCob = D.PlanCob
            INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO C ON C.CodCia = PC.CodCia
                                                              AND C.CodEmpresa = PC.CodEmpresa
                                                              AND C.IdTipoSeg = PC.IdTipoSeg

        WHERE
                D.StsDetalle = 'ANU'
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
            --AND D.MotivAnul               != 'REEX'
            AND D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND D.IDetPol > 0
            AND D.IdPoliza > 0
            --AND PC.CodTipoPlan             = '031'
            /*AND (PC.CodTipoPlan = '031'

                OR (PC.CodTipoPlan = '099' AND CAS.IDRAMOREAL =  '030'  AND PC.IdTipoSeg  IN ('PPAQI')))*/

            AND PC.CodTipoPlan = '034'
            AND EXISTS (
                SELECT /*+ INDEX(DT SYS_C0031885) */
                    'S'
                FROM
                         SICAS_OC.TRANSACCION T
                    INNER JOIN SICAS_OC.DETALLE_TRANSACCION DT ON DT.IdTransaccion = T.IdTransaccion
                WHERE
                        DT.Valor1 = P.IdPoliza
                    AND DT.Valor2 = D.IDetPol
                    AND DT.Correlativo > 0
                    AND DT.CodSubProceso NOT IN ( 'ESV', 'PAG' )
                    AND DT.CodCia = T.CodCia
                    AND T.CodCia = D.CodCia
                    AND T.CodEmpresa = D.CodEmpresa
                    AND T.IdTransaccion > 0
                    AND T.IdProceso = 2
                    AND T.FechaTransaccion BETWEEN dvarFecDesde AND dvarFecHasta
            )
            AND ( ( cFiltrarPolizas = 'N' )
                  OR ( cFiltrarPolizas = 'S'
                       AND D.IdPoliza IN (
                SELECT
                    IdPoliza
                FROM
                    SICAS_OC.FILTRAR_POLIZAS_SESAS
                WHERE
                        CodCia = nCodCia
                    AND CodEmpresa = nCodEmpresa
                    AND ProcesoSesas = cCodReporteProces
                    AND UsuarioCarga = cCodUsuario
                    AND Observacion = 'OK'
            ) ) )
        UNION ALL
        SELECT
            nCodCia                                                                                                               CodCia,
            nCodEmpresa                                                                                                           CodEmpresa,
            cCodReporteDatGen                                                                                                     CodReporte,
            cCodUsuario                                                                                                           CodUsuario,
            P.NumPolUnico                                                                                                         NumPoliza,
            NVL(TRIM(LPAD(XX.IdPoliza, 8, '0')) || TRIM(LPAD(XX.IDetPol, 2, '0')) || TRIM(LPAD(XX.Cod_Asegurado, 10, '0')), TRIM(LPAD(D.IdPoliza, 8, '0'))  || TRIM(LPAD(D.IDetPol, 2, '0')) || TRIM(LPAD(D.Cod_Asegurado, 10, '0')))                                                                              NumCertificado,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOSEGURO(C.TipoSeguro, NULL)                                                           TipoSeguro,
            DECODE(P.Cod_Moneda, 'PS', '10', 'USD', '20', '30')                                                                                                          Moneda,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(PN.CodPaisRes, PN.CodProvRes, PN.CodPaisRes, PN.CodProvRes, P.IdPoliza) EntidadAsegurado,
            D.FecIniVig                                                                                                           FecIniVig,
            D.FecFinVig                                                                                                           FecFinVig,
            D.FecIniVig                                                                                                           FecAltCert,
            SICAS_OC.OC_PROCESOSSESAS.GETFECBAJACERT(P.IdPoliza, D.FecIniVig, D.FecFinVig, D.FecAnul, dFecDesde,dFecHasta)                  FecBajCert,
            PN.FecNacimiento                                                                                                      FecNacim,
            P.FecEmision                                                                                                          FecEmision,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                        Sexo,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSCERT(D.CodCia, D.IdPoliza, D.IDETPOL, D.FecAnul, dFecHasta,
                                                    D.StsDetalle, D.FecIniVig, D.FecFinVig, NVL(XX.Cod_Asegurado, D.Cod_Asegurado))             StatusCert,
            NVL(C.SubTipoSeg, '1')                                                                                                SubTipoSeg,
            (
                CASE
                    WHEN CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12) < 1 THEN
                        1
                    ELSE
                        CEIL(MONTHS_BETWEEN(D.FecFinVig, D.FecIniVig) / 12)
                END
            )                                                                                                                     AnioPoliza,
            DECODE(C.MODALSUMAASEG, 'N', 'N', 'N')                                                                                ModSumAseg   --Siempre debe retornar N, se puede implementar una función si se requieren cambiar reglas de negocio
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, P.IdPoliza, 'GMM')                                                    Coaseguro    --no se usa la función porque dicen que por default un 1 y a futuro puede ser una función, tal vez la misma función y poner que si viene de GMMI devolver un 1
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETPRIMACEDIDA(D.CodCia, P.IdPoliza)                                                        PrimaCedida  --no se usa la función porque dicen que por default un 0 y a futuro puede ser una función, tal vez la misma función y poner que si viene de GMMI devolver un 0
            ,
            P.IdPoliza                                                                                                            IdPoliza,
            D.IDetPol                                                                                                             IDetPol,
            NVL(XX.Cod_Asegurado, D.Cod_Asegurado)                                                                                Cod_Asegurado,
            NVL(D.CANTASEGMODELO, 0)                                                                                              CANTASEGMODELO
            ,SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(D.CodCia, D.CodEmpresa, D.IdPoliza, dFecDesde, dFecHasta)                  ComisionDirecta
        FROM  SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA D ON D.CodCia = P.CodCia
                                             AND D.IdPoliza = P.IdPoliza
                                             AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
            LEFT JOIN SICAS_OC.ASEGURADO_CERTIFICADO    XX ON XX.CodCia = D.CodCia
                                                           AND XX.IdPoliza = D.IdPoliza
                                                           AND XX.IdetPol = D.IDetPol
            INNER JOIN SICAS_OC.ASEGURADO                A ON A.Cod_Asegurado =  NVL(XX.Cod_Asegurado,D.Cod_Asegurado)
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = A.Num_Doc_Identificacion
            INNER JOIN SICAS_OC.PLAN_COBERTURAS          PC ON PC.IdTipoSeg = D.IdTipoSeg
                                                      AND PC.CodEmpresa = D.CodEmpresa
                                                      AND PC.CodCia = D.CodCia
                                                      AND PC.PlanCob = D.PlanCob
            INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO C ON C.CodCia = PC.CodCia
                                                              AND C.CodEmpresa = PC.CodEmpresa
                                                              AND C.IdTipoSeg = PC.IdTipoSeg

        WHERE
                D.FecFinVig < dFecDesde
            AND D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND D.StsDetalle NOT IN ( 'SOL', 'PRE' )
            AND P.STSPOLIZA NOT IN ( 'SOL', 'PRE' )
            AND D.IDetPol > 0
            AND D.IdPoliza > 0
         --AND PC.CodTipoPlan             = '031'
         /*AND (PC.CodTipoPlan = '031'
                OR (PC.CodTipoPlan = '099' AND CAS.IDRAMOREAL =  '030'  AND PC.IdTipoSeg  IN ('PPAQI')))*/
            AND PC.CodTipoPlan = '034'
            AND EXISTS (
                SELECT /*+ INDEX(DT SYS_C0031885) */
                    'S'
                FROM
                         SICAS_OC.TRANSACCION T
                    INNER JOIN SICAS_OC.DETALLE_TRANSACCION DT ON DT.IdTransaccion = T.IdTransaccion
                WHERE
                        DT.Valor1 = P.IdPoliza
                    AND DT.Correlativo > 0
                    AND DT.CodSubProceso NOT IN ( 'ESV', 'PAG' )
                    AND DT.CodCia = T.CodCia
                    AND T.CodCia = D.CodCia
                    AND T.CodEmpresa = D.CodEmpresa
                    AND T.IdTransaccion > 0
                    AND T.IdProceso != 6
                    AND T.FechaTransaccion BETWEEN dvarFecDesde AND dvarFecHasta
            )
            AND ( ( cFiltrarPolizas = 'N' )
                  OR ( cFiltrarPolizas = 'S'
                       AND D.IdPoliza IN (
                SELECT
                    IdPoliza
                FROM
                    SICAS_OC.FILTRAR_POLIZAS_SESAS
                WHERE
                        CodCia = nCodCia
                    AND CodEmpresa = nCodEmpresa
                    AND ProcesoSesas = cCodReporteProces
                    AND UsuarioCarga = cCodUsuario
                    AND Observacion = 'OK'
            ) ) );

        TYPE r_SesasDatGen IS RECORD (
            CodCia           NUMBER(14, 0),
            CodEmpresa       NUMBER(14, 0),
            CodReporte       VARCHAR2(30),
            CodUsuario       VARCHAR2(30),
            NumPoliza        VARCHAR2(30),
            NumCertificado   VARCHAR2(30),
            TipoSeguro       VARCHAR2(1),
            Moneda           VARCHAR2(2),
            EntidadAsegurado VARCHAR2(2),
            FecIniVig        DATE,
            FecFinVig        DATE,
            FecAltCert       DATE,
            FecBajCert       DATE,
            FecNacim         DATE,
            FecEmision       DATE,
            Sexo             VARCHAR2(1),
            StatusCert       VARCHAR2(1),
            SubTipoSeg       VARCHAR2(1),
            AnioPoliza       NUMBER(2, 0),
            ModaSumAseg      VARCHAR2(1),
            Coaseguro        VARCHAR2(1),
            PrimaCedida      NUMBER(18, 2),
            IdPoliza         NUMBER(14, 0),
            IdetPol          NUMBER(14, 0),
            Cod_Asegurado    NUMBER(14, 0),
            CANTASEGMODELO   NUMBER,
            ComisionDirecta NUMBER
        );
      --
        TYPE t_SesasDatGen IS
            TABLE OF r_SesasDatGen;
        o_DatGen          t_SesasDatGen;
        nComisionDirecta2 NUMBER(18, 10);
        vl_Contador       NUMBER;
        vl_Contador2      NUMBER;
        vl_AsegModel      NUMBER;
        vl_CodValido      NUMBER;
        vl_Asegurado2     NUMBER;
    BEGIN

        DELETE SICAS_OC.SESAS_DATGEN
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND NUMPOLIZA >= '0'
            AND NUMCERTIFICADO >= '0';

      --
        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND IDSECUENCIA>=0;
      --
        COMMIT;
      --
        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');
      --
      --Inicializo variables de Afinación
        nCodCia2 := 0;
        nCodEmpresa2 := 0;
        nIdPoliza := 0;
        nIDetPol := 0;
        nComisionDirecta := 0;
        nCantCertificados := 0;
        cFormaVta := NULL;
        OPEN C_POL_IND_Q;
        LOOP
            FETCH C_POL_IND_Q
            BULK COLLECT INTO o_DatGen;
         --
            FOR x IN 1..o_DatGen.COUNT LOOP
                IF nCodCia2 <> o_DatGen(x).CodCia OR nCodEmpresa2 <> o_DatGen(x).CodEmpresa OR nIdPoliza <> o_DatGen(x).IdPoliza OR nIDetPol <>
                o_DatGen(x).IDetPol THEN
                    nCodCia2 := o_DatGen(x).CodCia;
                    nCodEmpresa2 := o_DatGen(x).CodEmpresa;
                    nIdPoliza := o_DatGen(x).IdPoliza;
                    nIDetPol := o_DatGen(x).IDetPol;
                    nComisionDirecta := SICAS_OC.OC_PROCESOSSESAS.GETMONTOCOMISIONAP(o_DatGen(x).CodCia, o_DatGen(x).CodEmpresa, o_DatGen(
                    x).IdPoliza, dFecDesde, dFecHasta);

                    cFormaVta := SICAS_OC.OC_PROCESOSSESAS.GETFORMAVENTA(o_DatGen(x).CodCia, o_DatGen(x).IdPoliza);

                END IF;

             --Inserto los registros
                BEGIN
                    SELECT  NVL(CANTASEGMODELO, 0)
                    INTO vl_AsegModel
                    FROM SICAS_OC.DETALLE_POLIZA
                    WHERE IDPOLIZA = o_DatGen(x).IdPoliza
                        AND IDETPOL = o_DatGen(x).IDetPol;

                EXCEPTION
                    WHEN OTHERS THEN
                        vl_AsegModel := 0;
                END;

                BEGIN
                    SELECT NVL(CANTASEGMODELO, 0)
                    INTO vl_AsegModel
                    FROM SICAS_OC.DETALLE_POLIZA
                    WHERE IDPOLIZA = o_DatGen(x).IdPoliza
                        AND IDETPOL = o_DatGen(x).IDetPol;

                EXCEPTION
                    WHEN OTHERS THEN
                        vl_AsegModel := 0;
                END;
              /*  DBMS_OUTPUT.PUT_LINE('POLIZA  '|| o_DatGen(x).IdPoliza   ||'  ASEGMODELO  '||vl_AsegModel);*/

                IF vl_AsegModel <= 1 THEN
                    BEGIN
                        SELECT SUM(PRIMANETA_MONEDA)
                        INTO nComisionDirecta2
                        FROM SICAS_OC.ASEGURADO_CERTIFICADO
                        WHERE CODCIA = o_DatGen(x).CodCia
                            AND IDPOLIZA = o_DatGen(x).IdPoliza
                            AND IDETPOL = o_DatGen(x).IDetPol;

                        SELECT
                            NVL((ROUND((100 / nComisionDirecta2), 10) * PRIMANETA_MONEDA) *(ROUND((nComisionDirecta / 100), 10)), 0)
                        INTO nComisionDirecta2
                        FROM
                            SICAS_OC.ASEGURADO_CERTIFICADO
                        WHERE
                                CODCIA = o_DatGen(x).CodCia
                            AND IDPOLIZA = o_DatGen(x).IdPoliza
                            AND IDETPOL = o_DatGen(x).IDetPol
                            AND COD_ASEGURADO = o_DatGen(x).Cod_Asegurado;

                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN 
                        BEGIN                        
                            SELECT SUM(PRIMA_MONEDA)
                            INTO nComisionDirecta2
                            FROM SICAS_OC.DETALLE_POLIZA
                            WHERE CODCIA = o_DatGen(x).CodCia
                                AND IDPOLIZA = o_DatGen(x).IdPoliza
                                AND IDETPOL >= 1;

                            SELECT NVL((ROUND((100 / nComisionDirecta2), 10) * PRIMA_MONEDA) *(ROUND((nComisionDirecta / 100),10)), 0)
                            INTO nComisionDirecta2
                            FROM SICAS_OC.DETALLE_POLIZA
                            WHERE CODCIA = o_DatGen(x).CodCia
                                AND IDPOLIZA = o_DatGen(x).IdPoliza
                                AND IDETPOL = o_DatGen(x).IDetPol
                                AND COD_ASEGURADO = o_DatGen(x).Cod_Asegurado;
                        EXCEPTION
                            WHEN OTHERS THEN 
                                nComisionDirecta2 := o_DatGen(x).ComisionDirecta;
                        END;
                        WHEN OTHERS THEN
                            nComisionDirecta2 := nComisionDirecta;
                    END;

                    BEGIN
                        INSERT INTO SICAS_OC.SESAS_DATGEN (
                            CodCia,
                            CodEmpresa,
                            CodReporte,
                            CodUsuario,
                            NumPoliza,
                            NumCertificado,
                            TipoSeguro,
                            Moneda,
                            EntidadAsegurado,
                            FecIniVig,
                            FecFinVig,
                            FecAltCert,
                            FecBajCert,
                            FecNacim,
                            FecEmision,
                            Sexo,
                            StatusCert,
                            FormaVta,
                            SubTipoSeg,
                            AnioPoliza,
                            ModaSumAseg,
                            Coaseguro,
                            PrimaCedida,
                            ComisionDirecta,
                            IdPoliza,
                            IDetPol,
                            CodAsegurado
                        ) VALUES (
                            o_DatGen(x).CodCia,
                            o_DatGen(x).CodEmpresa,
                            o_DatGen(x).CodReporte,
                            o_DatGen(x).CodUsuario,
                            o_DatGen(x).NumPoliza,
                            o_DatGen(x).NumCertificado,
                            o_DatGen(x).TipoSeguro,
                            o_DatGen(x).Moneda,
                            o_DatGen(x).EntidadAsegurado,
                            o_DatGen(x).FecIniVig,
                            o_DatGen(x).FecFinVig,
                            o_DatGen(x).FecAltCert,
                            o_DatGen(x).FecBajCert,
                            o_DatGen(x).FecNacim,
                            o_DatGen(x).FecEmision,
                            o_DatGen(x).Sexo,
                            o_DatGen(x).StatusCert,
                            cFormaVta,
                            o_DatGen(x).SubTipoSeg,
                            o_DatGen(x).AnioPoliza,
                            o_DatGen(x).ModaSumAseg,
                            o_DatGen(x).Coaseguro,
                            o_DatGen(x).PrimaCedida,
                            ROUND(nComisionDirecta2, 2),
                            o_DatGen(x).IdPoliza,
                            o_DatGen(x).IDetPol,
                            o_DatGen(x).Cod_Asegurado
                        );

                    EXCEPTION
                        WHEN DUP_VAL_ON_INDEX THEN
                            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(o_DatGen(x).CodCia, o_DatGen(x).CodEmpresa, o_DatGen(x).CodReporte,
                            o_DatGen(x).CodUsuario, o_DatGen(x).NumPoliza,o_DatGen(x).NumCertificado, SQLCODE, 'El registro ya existe en la SESA, favor de validarlo.');
                        WHEN OTHERS THEN
                            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(o_DatGen(x).CodCia, o_DatGen(x).CodEmpresa, o_DatGen(x).CodReporte,
                            o_DatGen(x).CodUsuario, o_DatGen(x).NumPoliza,o_DatGen(x).NumCertificado, SQLCODE, SQLERRM);
                    END;

                ELSE
                    vl_Contador2 := 0;
                    nComisionDirecta2 := ROUND(nComisionDirecta / vl_AsegModel, 10);
                    BEGIN
                        SELECT
                            COUNT(1)
                        INTO vl_CodValido
                        FROM
                            SICAS_OC.SESA_ASEGMODELO
                        WHERE
                                CODCIA = o_DatGen(x).CodCia
                            AND CodEmpresa = o_DatGen(x).CodEmpresa
                            AND COD_ASEGURADO = o_DatGen(x).Cod_Asegurado;

                        IF ( vl_CodValido = 1 ) THEN --Si el asegurado modelo corresponde al catalogo, se recorre la inserción, si no, solo se inserta en el log de errores

                            WHILE vl_Contador2 <= ( vl_AsegModel - 1 ) LOOP
                                vl_Asegurado2 := TO_CHAR(o_DatGen(x).NumCertificado + vl_Contador2);
                                INSERT INTO SICAS_OC.SESAS_DATGEN (
                                    CodCia,
                                    CodEmpresa,
                                    CodReporte,
                                    CodUsuario,
                                    NumPoliza,
                                    NumCertificado,
                                    TipoSeguro,
                                    Moneda,
                                    EntidadAsegurado,
                                    FecIniVig,
                                    FecFinVig,
                                    FecAltCert,
                                    FecBajCert,
                                    FecNacim,
                                    FecEmision,
                                    Sexo,
                                    StatusCert,
                                    FormaVta,
                                    SubTipoSeg,
                                    AnioPoliza,
                                    ModaSumAseg,
                                    Coaseguro,
                                    PrimaCedida,
                                    ComisionDirecta,
                                    IdPoliza,
                                    IDetPol,
                                    CodAsegurado
                                ) VALUES (
                                    o_DatGen(x).CodCia,
                                    o_DatGen(x).CodEmpresa,
                                    o_DatGen(x).CodReporte,
                                    o_DatGen(x).CodUsuario,
                                    o_DatGen(x).NumPoliza,
                                    LPAD(vl_Asegurado2, 20, '0'),
                                    o_DatGen(x).TipoSeguro,
                                    o_DatGen(x).Moneda,
                                    o_DatGen(x).EntidadAsegurado,
                                    o_DatGen(x).FecIniVig,
                                    o_DatGen(x).FecFinVig,
                                    o_DatGen(x).FecAltCert,
                                    o_DatGen(x).FecBajCert,
                                    o_DatGen(x).FecNacim,
                                    o_DatGen(x).FecEmision,
                                    o_DatGen(x).Sexo,
                                    o_DatGen(x).StatusCert,
                                    cFormaVta,
                                    o_DatGen(x).SubTipoSeg,
                                    o_DatGen(x).AnioPoliza,
                                    o_DatGen(x).ModaSumAseg,
                                    o_DatGen(x).Coaseguro,
                                    o_DatGen(x).PrimaCedida,
                                    ROUND(nComisionDirecta2, 2),
                                    o_DatGen(x).IdPoliza,
                                    o_DatGen(x).IDetPol,
                                    o_DatGen(x).Cod_Asegurado
                                );

                                vl_Contador2 := vl_Contador2 + 1;
                            END LOOP;

                            COMMIT;
                        ELSIF vl_CodValido > 1 THEN
                            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(o_DatGen(x).CodCia, o_DatGen(x).CodEmpresa, o_DatGen(x).CodReporte,
                            o_DatGen(x).CodUsuario, o_DatGen(x).NumPoliza,
                                                                         o_DatGen(x).NumCertificado, SQLCODE, 'La póliza '
                                                                                                              || o_DatGen(x).IdPoliza
                                                                                                              || ' tiene '
                                                                                                              || vl_CodValido
                                                                                                              || ' certificados de Asegurado Modelo validos en el catálogo.');
                        ELSIF vl_CodValido = 0 THEN
                            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(o_DatGen(x).CodCia, o_DatGen(x).CodEmpresa, o_DatGen(x).CodReporte,
                            o_DatGen(x).CodUsuario, o_DatGen(x).NumPoliza,
                                                                         o_DatGen(x).NumCertificado, SQLCODE, 'La póliza '
                                                                                                              || o_DatGen(x).IdPoliza
                                                                                                              || ' NO tiene certificados de Asegurado Modelo validos en el catálogo.');
                        END IF;

                    EXCEPTION
                        WHEN DUP_VAL_ON_INDEX THEN
                            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(o_DatGen(x).CodCia, o_DatGen(x).CodEmpresa, o_DatGen(x).CodReporte,
                            o_DatGen(x).CodUsuario, o_DatGen(x).NumPoliza,
                                                                         o_DatGen(x).NumCertificado, SQLCODE, 'El registro ya existe en la SESA, favor de validarlo.');
                        WHEN OTHERS THEN
                            SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(o_DatGen(x).CodCia, o_DatGen(x).CodEmpresa, o_DatGen(x).CodReporte,
                            o_DatGen(x).CodUsuario, o_DatGen(x).NumPoliza,
                                                                         o_DatGen(x).NumCertificado, SQLCODE, SQLERRM);
                    END;

                END IF;

            END LOOP;

            EXIT WHEN o_DatGen.COUNT = 0;
        END LOOP;

        CLOSE C_POL_IND_Q;
      --
        COMMIT;
    END DATGEN_GM;

    PROCEDURE EMISION_GM (
        nCodCia           SICAS_OC.SESAS_EMISION.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_EMISION.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_EMISION.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_EMISION.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    ) IS

        nPmaEmiCob      NUMBER(20, 10);
        nMtoAsistLocal  NUMBER(20, 2);
        nCodSegurado    NUMBER;
        nIdPoliza       DETALLE_POLIZA.IDPOLIZA%TYPE;
        nIDetPol        DETALLE_POLIZA.IDETPOL%TYPE;
        dFecIniVig      DETALLE_POLIZA.FECINIVIG%TYPE;
        dFecFinVig      DETALLE_POLIZA.FECFINVIG%TYPE;
        nPrimaDevengada SICAS_OC.SESAS_EMISION.PrimaDevengada%TYPE;
        cTipoExtraPrima SICAS_OC.SESAS_EMISION.TIPOEXTRAPRIMA%TYPE;
        nNumDiasRenta   SICAS_OC.SESAS_EMISION.NumDiasRenta%TYPE;
        CURSOR cPolizas_DatGen IS
        SELECT
            IdPoliza,
            IDetPol,
            CodAsegurado,
            FecIniVig,
            FecFinVig,
            FecBajCert,
            TipoDetalle,
            NumPoliza,
            NumCertificado
        FROM  SICAS_OC.SESAS_DATGEN
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = 'SESADATGMI'
            AND CodUsuario = cCodUsuario
            AND NUMPOLIZA >= '0'
            AND NUMCERTIFICADO >= '0'
            AND ( fecbajcert IS NULL
                  OR fecbajcert >= dFecDesde );
      --
        TYPE r_SesasDatGen IS RECORD (
            IdPoliza       NUMBER(14, 0),
            IDetPol        NUMBER(14, 0),
            CodAsegurado   NUMBER(14, 0),
            FecIniVig      DATE,
            FecFinVig      DATE,
            FecBajCert     DATE,
            TipoDetalle    VARCHAR2(3),
            NumPoliza      VARCHAR2(30),
            NumCertificado VARCHAR2(30)
        );
      --
        TYPE t_SesasDatGen IS  TABLE OF r_SesasDatGen;
      --
        o_SesasDatGen   t_SesasDatGen;

        CURSOR COBERT_Q IS
        SELECT
            CodCobert,
            OrdenSESAS,
            ClaveSESAS,
            SUM(Suma_Moneda)  Suma_Moneda,
            SUM(Prima_Moneda) Prima_Moneda
        FROM
            (   SELECT
                    C.CodCobert               CodCobert,
                    NVL(OrdenSESAS, 0)        OrdenSESAS,
                    NVL(ClaveSESASNew, '099') ClaveSESAS,
                    SUM(C.SumaAseg_Moneda)    Suma_Moneda,
                    SUM(C.Prima_Moneda)       Prima_Moneda
                FROM SICAS_OC.COBERT_ACT C
                INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS 
                    ON CS.CodCobert = C.CodCobert
                    AND CS.PlanCob = C.PlanCob
                    AND CS.IdTipoSeg = C.IdTipoSeg
                    AND CS.CodEmpresa = C.CodEmpresa
                   AND CS.CodCia = C.CodCia
                WHERE C.IDetPol = nIDetPol
                    AND C.IdPoliza = nIdPoliza
                    AND C.CodCia = nCodCia
                    AND C.COD_ASEGURADO = nCodSegurado --Argenis
                GROUP BY
                    C.CodCobert,
                    NVL(OrdenSESAS, 0),
                    NVL(ClaveSESASNew, '099')
                UNION
                SELECT
                    C.CodCobert               CodCobert,
                    NVL(OrdenSESAS, 0)        OrdenSESAS,
                    NVL(ClaveSESASNew, '099') ClaveSESAS,
                    SUM(C.SumaAseg_Moneda)    Suma_Moneda,
                    SUM(C.Prima_Moneda)       Prima_Moneda
                FROM SICAS_OC.COBERT_ACT_ASEG C
                    INNER JOIN SICAS_OC.COBERTURAS_DE_SEGUROS CS ON CS.CodCobert = C.CodCobert
                                                                    AND CS.PlanCob = C.PlanCob
                                                                    AND CS.IdTipoSeg = C.IdTipoSeg
                                                                    AND CS.CodEmpresa = C.CodEmpresa
                                                                    AND CS.CodCia = C.CodCia
                WHERE
                        C.IDetPol = nIDetPol
                    AND C.IdPoliza = nIdPoliza
                    AND C.CodCia = nCodCia
                    AND C.COD_ASEGURADO = nCodSegurado --Argenis
                GROUP BY
                    C.CodCobert,
                    NVL(OrdenSESAS, 0),
                    NVL(ClaveSESASNew, '099')
            )
        GROUP BY
            CodCobert,
            OrdenSESAS,
            ClaveSESAS;
      --
        TYPE r_SesasEmision IS RECORD (
            CodCobert    VARCHAR2(6),
            OrdenSESAS   NUMBER(5, 0),
            ClaveSESAS   VARCHAR2(3),
            Suma_Moneda  NUMBER(18, 6),
            Prima_Moneda NUMBER(18, 6)
        );
      --
        TYPE t_SesasEmision IS
            TABLE OF r_SesasEmision;
      --
        o_SesasEmision  t_SesasEmision;
        vl_prov         NUMBER;
    BEGIN

        DELETE SICAS_OC.SESAS_EMISION
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND NUMPOLIZA >= '0'
            AND NUMCERTIFICADO >= '0';

        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE
                CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND IDSECUENCIA>=0;
      --
        COMMIT;
      --

        SICAS_OC.OC_SESASINDIVIDUAL.DATGEN_GM(nCodCia, nCodEmpresa, dFecDesde, dFecHasta, cCodUsuario,'SESADATGMI', 'SESADATGMI', cFiltrarPolizas);

        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY')  || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');
        OPEN cPolizas_DatGen;
        LOOP
            FETCH cPolizas_DatGen
            BULK COLLECT INTO o_SesasDatGen;
            FOR x IN 1..o_SesasDatGen.COUNT LOOP
                nIdPoliza := o_SesasDatGen(x).IdPoliza;
                nIDetPol := o_SesasDatGen(x).IDetPol;
                dFecIniVig := o_SesasDatGen(x).FecIniVig;
                dFecFinVig := o_SesasDatGen(x).FecFinVig;
                nCodSegurado := o_SesasDatGen(x).CodAsegurado; --Argenis
                nMtoAsistLocal := 0;
                nPmaEmiCob := 0;
                OPEN COBERT_Q;
                LOOP
                    FETCH COBERT_Q
                    BULK COLLECT INTO o_SesasEmision;
                    FOR w IN 1..o_SesasEmision.COUNT LOOP
                        nPrimaDevengada := NULL; --Implementar la función que devuelve la prima devengada
                    --se cambiar el valor de la variable ya que no se le asigno valor y e pone el valor de la consulta
                        nPmaEmiCob := NVL(o_SesasEmision(w).Prima_Moneda, 0);
                        IF o_SesasDatGen(x).FECINIVIG < dvarFecDesde OR ( o_SesasDatGen(x).FecBajCert < dFecDesde ) THEN --ARGENIS
                            nPmaEmiCob := 0;
                        END IF;

                        IF dFecFinVig <= dFecHasta THEN --ARGENIS
                            nPrimaDevengada := nPmaEmiCob;
                        END IF;
                        nPrimaDevengada := SICAS_OC.OC_PROCESOSSESAS.GETPRIMADEVENGADA(nidPoliza, nPmaEmiCob, dvarFecHasta, dFecIniVig, dFecFinVig);
                    --Inserto Emisión/Coberturas
                        BEGIN
                            INSERT INTO SICAS_OC.SESAS_EMISION (
                                CodCia,
                                CodEmpresa,
                                CodReporte,
                                CodUsuario,
                                NumPoliza,
                                NumCertificado,
                                Cobertura,
                                SumaAsegurada,
                                PrimaEmitida,
                                PrimaDevengada,
                                NumDiasRenta,
                                TipoExtraPrima,
                                OrdenSesas
                            ) VALUES (
                                nCodCia,
                                nCodEmpresa,
                                cCodReporteProces,
                                cCodUsuario,
                                o_SesasDatGen(x).NumPoliza,
                                o_SesasDatGen(x).NumCertificado,
                                LPAD(o_SesasEmision(w).ClaveSESAS, 2, '0'),
                                NVL(o_SesasEmision(w).Suma_Moneda, 0),
                                nPmaEmiCob,
                                nPrimaDevengada,
                                nNumDiasRenta,
                                cTipoExtraPrima,
                                o_SesasEmision(w).OrdenSESAS
                            );

                        EXCEPTION
                            WHEN DUP_VAL_ON_INDEX THEN
                                UPDATE SICAS_OC.SESAS_EMISION
                                SET
                                    PrimaEmitida = NVL(PrimaEmitida, 0) + nPmaEmiCob,
                                    SumaAsegurada = NVL(SumaAsegurada, 0) + NVL(NVL(o_SesasEmision(w).Suma_Moneda, 0), 0),
                                    primadevengada = primadevengada + nPrimaDevengada,
                                            fechainsert = sysdate
                                WHERE
                                        CodCia = nCodCia
                                    AND CodEmpresa = nCodEmpresa
                                    AND CodReporte = cCodReporteProces
                                    AND CodUsuario = cCodUsuario
                                    AND NumPoliza = o_SesasDatGen(x).NumPoliza
                                    AND NumCertificado = o_SesasDatGen(x).NumCertificado
                                    AND Cobertura = LPAD(o_SesasEmision(w).ClaveSESAS, 2, '0');
                          --AND  OrdenSesas     = nOrdenSesas;

                            WHEN OTHERS THEN
                                SICAS_OC.OC_LOGERRORES_SESAS.SPINSERTLOGSESAS(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, o_SesasDatGen(
                                x).NumPoliza,
                                                                             o_SesasDatGen(x).NumCertificado, SQLCODE, SQLERRM);
                        END;

                    END LOOP;

                    EXIT WHEN o_SesasEmision.COUNT = 0;
                END LOOP;

                CLOSE COBERT_Q;
                COMMIT;

            END LOOP;
            EXIT WHEN o_SesasDatGen.COUNT = 0;
        END LOOP;

        CLOSE cPolizas_DatGen;
        COMMIT;

        OPEN cPolizas_DatGen;
        LOOP
            FETCH cPolizas_DatGen
            BULK COLLECT INTO o_SesasDatGen;
            FOR x IN 1..o_SesasDatGen.COUNT LOOP         

                SELECT SUM(SUMAASEG),SUM(PRIMANETA)
                INTO nComisionDirecta2,nPmaEmiCob
                FROM SICAS_OC.ASEGURADO_CERTIFICADO
                WHERE CODCIA = nCodCia
                    AND IDPOLIZA = o_SesasDatGen(x).IdPoliza
                    AND IDETPOL = o_SesasDatGen(x).IDetPol;

                IF nComisionDirecta2 IS NULL THEN 

                    SELECT SUM(SUMA_ASEG_MONEDA),SUM(PRIMA_MONEDA)
                    INTO nComisionDirecta2,nPmaEmiCob
                    FROM SICAS_OC.DETALLE_POLIZA 
                    WHERE CODCIA = nCodCia
                        AND IDPOLIZA = o_SesasDatGen(x).IdPoliza
                        AND IDETPOL = o_SesasDatGen(x).IDetPol;

               END IF;

               IF nComisionDirecta2 IS NULL THEN               
                    nComisionDirecta2 := nPmaEmiCob;
               END IF;

                SELECT COUNT(1) --Total de coberturas
                INTO vl_Total1
                FROM SICAS_OC.COBERT_ACT 
                WHERE IDPOLIZA = o_SesasDatGen(x).IdPoliza 
                    AND IDETPOL = o_SesasDatGen(x).IDetPol
                    AND COD_ASEGURADO = o_SesasDatGen(x).CodAsegurado;

                IF vl_Total1 > 1 THEN

                    BEGIN

                        SELECT COUNT(1) --Total de coberturas
                        INTO vl_Total2
                        FROM SICAS_OC.COBERT_ACT 
                        WHERE IDPOLIZA = o_SesasDatGen(x).IdPoliza 
                            AND IDETPOL = o_SesasDatGen(x).IDetPol
                            AND COD_ASEGURADO = o_SesasDatGen(x).CodAsegurado
                            AND PRIMA_MONEDA = 0
                        GROUP BY IDPOLIZA,IDETPOL,COD_ASEGURADO;
                    EXCEPTION
                        WHEN OTHERS THEN
                            vl_Total2 := 0;
                    END;

                    IF ((vl_Total1 = 2) AND (vl_Total2 = 1)) OR ((vl_Total1 > 2) AND (vl_Total2 >= 2)) THEN

                        UPDATE SICAS_OC.SESAS_EMISION E
                        SET PrimaEmitida = NVL((ROUND((100 / nComisionDirecta2), 10) * NVL(SumaAsegurada, 0)) *(ROUND((nPmaEmiCob / 100), 10)), 0)   ,
                            PrimaDevengada = SICAS_OC.OC_PROCESOSSESAS.GETPRIMADEVENGADA(o_SesasDatGen(x).IdPoliza, NVL((ROUND((100 / nComisionDirecta2), 10) * NVL(SumaAsegurada, 0)) *(ROUND((nPmaEmiCob / 100), 10)), 0) , dvarFecHasta, o_SesasDatGen(x).FecIniVig,o_SesasDatGen(x).FecFinVig),
                                                    fechainsert = sysdate
                        WHERE NUMCERTIFICADO||COBERTURA = TRIM(LPAD(o_SesasDatGen(x).IdPoliza, 8, '0')) ||TRIM(LPAD(o_SesasDatGen(x).IDetPol, 2, '0')) ||TRIM(LPAD(o_SesasDatGen(x).CodAsegurado, 10, '0'))||COBERTURA;

                    END IF;
                END IF;

                END LOOP;
            EXIT WHEN o_SesasDatGen.COUNT = 0;
        END LOOP;

        CLOSE cPolizas_DatGen;
        COMMIT;     

    END EMISION_GM;

    PROCEDURE SINIESTROS_GM (
        nCodCia           SICAS_OC.SESAS_SINIESTROS.CODCIA%TYPE,
        nCodEmpresa       SICAS_OC.SESAS_SINIESTROS.CODEMPRESA%TYPE,
        dFecDesde         DATE,
        dFecHasta         DATE,
        cCodUsuario       SICAS_OC.SESAS_SINIESTROS.CODUSUARIO%TYPE,
        cCodReporteDatGen SICAS_OC.SESAS_SINIESTROS.CODREPORTE%TYPE,
        cCodReporteProces SICAS_OC.SESAS_SINIESTROS.CODREPORTE%TYPE,
        cFiltrarPolizas   VARCHAR2
    ) IS

        dvarFecDesde     DATE;
        dvarFecHasta     DATE;
        dFecConSin       SICAS_OC.SESAS_SINIESTROS.FECCONSIN%TYPE;
        dFecPagSin       SICAS_OC.SESAS_SINIESTROS.FECPAGSIN%TYPE;
        nMontoPagSin     SICAS_OC.SESAS_SINIESTROS.MONTOPAGSIN%TYPE;
        nNumAprobacion   APROBACIONES.NUM_APROBACION%TYPE;
        nIdTransaccion   APROBACIONES.IDTRANSACCION%TYPE;
        cTipAprobacion   NUMBER;
        CURSOR cSiniestros IS
        SELECT
            S.IdPoliza,
            S.IDetPol,
            P.NumPolUnico                                                                                                           NumPoliza,
            TRIM(LPAD(S.IdPoliza, 8, '0'))
            || TRIM(LPAD(S.IDetPol, 2, '0'))
            || TRIM(LPAD(S.Cod_Asegurado, 10, '0'))                                                                                 NumCertificado,
            S.IdSiniestro                                                                                                           NumSiniestro,
            SICAS_OC.OC_PROCESOSSESAS.GETNUMRECLAMOSINI()                                                                           NumReclamacion  --Por definir
            ,
            S.Fec_Ocurrencia                                                                                                        FecOcuSin,
            S.Fec_Notificacion                                                                                                      FecRepSin       --Por Definir  fecha reclamación
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETENTIDADASEGURADO(S.CodPaisOcurr, S.CodProvOcurr, PN.CodPaisRes, PN.CodProvRes, S.IdPoliza) EntOcuSin,
            SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSINGMM(S.CodCia, S.IdPoliza, S.IdSiniestro, S.Sts_Siniestro,(
                CASE
                    WHEN R.TIPO_MOVIMIENTO IN('PAGOS') THEN
                        R.IMPTE_MOVIMIENTO *(
                            CASE
                                WHEN R.SIGNO = '-' THEN
                                    - 1
                                ELSE
                                    1
                            END
                        )
                    ELSE
                        0
                END
            ) +(
                CASE
                    WHEN R.TIPO_MOVIMIENTO IN('DESPAG', 'DESCUE', 'DEDUC') THEN
                        R.IMPTE_MOVIMIENTO *(
                            CASE
                                WHEN R.SIGNO = '-' THEN
                                    - 1
                                ELSE
                                    1
                            END
                        )
                    ELSE
                        0
                END
            ),
                                                   CASE
                                                       WHEN R.TIPO_MOVIMIENTO IN('ESTINI', 'AJUMAS', 'AJUMEN') THEN
                                                           R.IMPTE_MOVIMIENTO *(
                                                               CASE
                                                                   WHEN R.SIGNO = '-' THEN
                                                                       - 1
                                                                   ELSE
                                                                       1
                                                               END
                                                           )
                                                       ELSE
                                                           0
                                                   END, 'SINGMC')                                                                                                             StatusReclamacion  --Aplicar en la rutina la parte de SINGMMC
                                                   ,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOGASTOINI()                                                                             TipoGasto       --Por Definir
            ,
            0                                                                                                                       PeriodoEspera   --Revisar porque este va a nivel cobertura y el reporte no va a ese nivel, va a nivel siniestro
            ,
            CASE
                WHEN LENGTH(NVL(REPLACE(S.submotivo_siniestro, '.', ''), S.Motivo_De_Siniestro)) = 3 THEN
                    S.Motivo_De_Siniestro || 'X'
                ELSE
                    NVL(REPLACE(S.submotivo_siniestro, '.', ''), S.Motivo_De_Siniestro)
            END                                                                                                                     CausaSiniestro,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOPAGOSINI()                                                                             TipoPago        --Por Definir
            ,
            DECODE(PN.Sexo, 'F', 'F', 'M')                                                                                          Sexo,
            PN.FecNacimiento                                                                                                        FecNacim,
            NVL(P.MONTODEDUCIBLE, 0)                                                                                                MontoDeducible  --Por definir y revisar porque este va a nivel cobertura y el reporte no va a ese nivel, va a nivel siniestro
            ,
            SICAS_OC.OC_PROCESOSSESAS.GETCOASEGURO(D.CodCia, D.IdPoliza, 'GMM')                                                     MontoCoaseguro  --Default 0   
            ,
            0                                                                                                                       MontoRecRea     --Default 0
            ,
            CASE
                WHEN R.TIPO_MOVIMIENTO IN ( 'ESTINI', 'AJUMAS', 'AJUMEN' ) THEN
                    R.IMPTE_MOVIMIENTO * (
                        CASE
                            WHEN R.SIGNO = '-' THEN
                                - 1
                            ELSE
                                1
                        END
                    )
                ELSE
                    0
            END                                                                                                                     MontoReclamado,
            SICAS_OC.OC_PROCESOSSESAS.GETTIPOMOVRECLAMO()                                                                           TipMovRec       --Por definir y revisar porque este va a nivel cobertura y el reporte no va a ese nivel, va a nivel siniestro
            ,
            (
                CASE
                    WHEN R.TIPO_MOVIMIENTO IN ( 'PAGOS' ) THEN
                        R.IMPTE_MOVIMIENTO * (
                            CASE
                                WHEN R.SIGNO = '-' THEN
                                    - 1
                                ELSE
                                    1
                            END
                        )
                    ELSE
                        0
                END
            ) + (
                CASE
                    WHEN R.TIPO_MOVIMIENTO IN ( 'DESPAG', 'DESCUE', 'DEDUC' ) THEN
                        R.IMPTE_MOVIMIENTO * (
                            CASE
                                WHEN R.SIGNO = '-' THEN
                                    - 1
                                ELSE
                                    1
                            END
                        )
                    ELSE
                        0
                END
            )                                                                                                                       Monto_Pago_Moneda
        FROM
                 SICAS_OC.POLIZAS P
            INNER JOIN SICAS_OC.DETALLE_POLIZA D ON D.IdPoliza = P.IdPoliza
                AND D.IDETPOL >= (SELECT MIN(IDETPOL) FROM SICAS_OC.DETALLE_POLIZA WHERE IDPOLIZA = P.IDPOLIZA AND CODCIA = P.CODCIA)
                AND D.CODCIA = P.CODCIA
            INNER JOIN SICAS_OC.SINIESTRO                S ON S.IDetPol = D.IDetPol
                                               AND S.IdPoliza = D.IdPoliza
            INNER JOIN SICAS_OC.ASEGURADO                CL ON CL.Cod_Asegurado = S.Cod_Asegurado
            INNER JOIN SICAS_OC.PERSONA_NATURAL_JURIDICA PN ON PN.Num_Doc_Identificacion = CL.Num_Doc_Identificacion
                                                               AND PN.Tipo_Doc_Identificacion = CL.Tipo_Doc_Identificacion
            INNER JOIN SICAS_OC.CONFIG_SESAS_TIPO_SEGURO C ON C.IdTipoSeg = D.IdTipoSeg
                                                              AND C.CodEmpresa = D.CodEmpresa
                                                              AND C.CodCia = D.CodCia
            INNER JOIN SICAS_OC.RESERVA_DET              R ON R.ID_SINIESTRO = S.IDSINIESTRO
                                                 AND R.ID_POLIZA = S.IDPOLIZA
                                                 AND R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta
        WHERE  /*S.Fec_Notificacion  BETWEEN dvarFecDesde AND dvarFecHasta
            AND  */
                S.Sts_Siniestro != 'SOL'
            AND ( EXISTS (
                SELECT
                    'S'
                FROM
                         SICAS_OC.APROBACION_ASEG A
                    INNER JOIN SICAS_OC.COMPROBANTES_CONTABLES B ON B.NumTransaccion = A.IdTransaccion
                WHERE
                        A.IdSiniestro = S.IdSiniestro 
                                /*AND A.IDPOLIZA = S.IdPoliza 
                                AND A.COD_ASEGURADO = S.Cod_Asegurado */
                    AND B.FecComprob BETWEEN dvarFecDesde AND dvarFecHasta
            )
                  OR EXISTS (
                SELECT
                    'S'
                FROM
                         SICAS_OC.APROBACIONES A
                    INNER JOIN SICAS_OC.COMPROBANTES_CONTABLES B ON B.NumTransaccion = A.IdTransaccion
                WHERE
                        A.IdSiniestro = S.IdSiniestro 
                               /* AND A.IDPOLIZA = S.IdPoliza 
                                AND A.COD_ASEGURADO = S.Cod_Asegurado */
                    AND B.FecComprob BETWEEN dvarFecDesde AND dvarFecHasta
            )

                    --OR R.FE_MOVTO BETWEEN dvarFecDesde AND dvarFecHasta 
             )
            AND D.IdTipoSeg IN (
                SELECT
                    PC.IdTipoSeg
                FROM
                    SICAS_OC.PLAN_COBERTURAS PC
                WHERE
                    PC.CodTipoPlan IN ( '034' )
            ) -- Corresponden a GMM de Grupo y Colectivo respectivamente
            AND D.CodEmpresa = nCodEmpresa
            AND D.CodCia = nCodCia
            AND ( ( cFiltrarPolizas = 'N' )
                  OR ( cFiltrarPolizas = 'S'
                       AND P.IdPoliza IN (
                SELECT
                    IdPoliza
                FROM
                    SICAS_OC.FILTRAR_POLIZAS_SESAS
                WHERE
                        CodCia = nCodCia
                    AND CodEmpresa = nCodEmpresa
                    AND ProcesoSesas = cCodReporteProces
                    AND UsuarioCarga = cCodUsuario
                    AND Observacion = 'OK'
            ) ) );
      --
        TYPE r_SesasSiniestro IS RECORD (
            IdPoliza          NUMBER(14, 0),
            IDetPol           NUMBER(14, 0),
            NumPoliza         VARCHAR2(30),
            NumCertificado    VARCHAR2(30),
            NumSiniestro      VARCHAR2(20),
            NumReclamacion    VARCHAR2(20),
            FecOcuSin         DATE,
            FecRepSin         DATE,
            EntOcuSin         VARCHAR2(2),
            StatusReclamacion VARCHAR2(1),
            TipoGasto         VARCHAR2(2),
            PeriodoEspera     NUMBER(2, 0),
            CausaSiniestro    VARCHAR2(4),
            TipoPago          VARCHAR2(1),
            Sexo              VARCHAR2(1),
            FecNacim          DATE,
            MontoDeducible    NUMBER(18, 2),
            MontoCoaseguro    NUMBER(18, 2),
            MontoRecRea       NUMBER(18, 2),
            MontoReclamado    NUMBER(23, 2),
            TipMovRec         VARCHAR2(1),
            Monto_Pago_Moneda NUMBER
        );
        TYPE t_SesasSiniestro IS
            TABLE OF r_SesasSiniestro;
        o_SesasSiniestro t_SesasSiniestro;
        nMonto_Moneda    NUMBER;
        nMontoPagado     NUMBER;
    BEGIN

        DELETE SICAS_OC.SESAS_SINIESTROS
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND NUMPOLIZA >= '0'
            AND NUMCERTIFICADO >= '0';

        DELETE SICAS_OC.LOGERRORES_SESAS
        WHERE CodCia = nCodCia
            AND CodEmpresa = nCodEmpresa
            AND CodReporte = cCodReporteProces
            AND CodUsuario = cCodUsuario
            AND IDSECUENCIA>=0;

        COMMIT;
        dvarFecDesde := TO_DATE(TO_CHAR(dFecDesde, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
        dvarFecHasta := TO_DATE(TO_CHAR(dFecHasta, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');
        OPEN cSiniestros;
        LOOP
            FETCH cSiniestros
            BULK COLLECT INTO o_SesasSiniestro;
            FOR x IN 1..o_SesasSiniestro.COUNT LOOP
                dFecConSin := NULL;
                dFecPagSin := NULL;
                nMontoPagSin := NULL;
                nNumAprobacion := NULL;
                nIdTransaccion := NULL;

            /*SICAS_OC.OC_PROCESOSSESAS.DATOSSINIESTROS(nCodCia,nCodEmpresa,o_SesasSiniestro(x).IdPoliza,o_SesasSiniestro(x).NumSiniestro,NULL,dFecPagSin,nMontoPagSin,dFecConSin);

            IF dFecPagSin < dFecDesde OR dFecPagSin > dFecHasta THEN
                dFecPagSin := NULL;
            ELSIF dFecPagSin IS NULL THEN*/

           -- END IF;
                BEGIN
                    SELECT MIN(FE_MOVTO)
                    INTO dFecConSin
                    FROM  SICAS_OC.RESERVA_DET
                    WHERE ID_POLIZA = o_SesasSiniestro(x).IdPoliza
                        AND ID_SINIESTRO = o_SesasSiniestro(x).NumSiniestro
                        AND AÑO_MOVIMIENTO = TO_NUMBER(TO_CHAR(dvarFecDesde, 'YYYY'));

                EXCEPTION
                    WHEN OTHERS THEN
                        dFecConSin := NULL;
                END;

                nMontoReclamo := NVL(o_SesasSiniestro(x).MONTODEDUCIBLE, 0) + NVL(o_SesasSiniestro(x).MontoReclamado, 0);

                SICAS_OC.OC_PROCESOSSESAS.INSERTASINIESTRO(nCodCia, nCodEmpresa, cCodReporteProces, cCodUsuario, o_SesasSiniestro(x).
                NumPoliza,
                                                          o_SesasSiniestro(x).NumCertificado, o_SesasSiniestro(x).NumSiniestro, o_SesasSiniestro(
                                                          x).NumReclamacion, o_SesasSiniestro(x).FecOcuSin, o_SesasSiniestro(x).FecRepSin,
                                                          dFecConSin, NVL(dFecPagSin, dFecPagSin), o_SesasSiniestro(x).StatusReclamacion,
                                                          o_SesasSiniestro(x).EntOcuSin, ' '                                --Cobertura
                                                          , nMontoReclamo,
                                                          o_SesasSiniestro(x).CausaSiniestro, NVL(o_SesasSiniestro(x).MontoDeducible,
                                                          0), o_SesasSiniestro(x).MontoCoaseguro, o_SesasSiniestro(x).Monto_Pago_Moneda,
                                                          o_SesasSiniestro(x).MontoRecRea, NULL                                --MontoDividendo
                                                          ,
                                                          o_SesasSiniestro(x).TipMovRec, NULL                                --MontoVencimiento
                                                          , NULL                                --MontoRescate
                                                          , o_SesasSiniestro(x).TipoGasto, o_SesasSiniestro(x).PeriodoEspera,
                                                          o_SesasSiniestro(x).TipoPago, o_SesasSiniestro(x).Sexo, o_SesasSiniestro(x).
                                                          FecNacim, NULL);                             --OrdeSesas

                BEGIN
                    SELECT MAX(FE_MOVTO)
                    INTO dFecPagSin
                    FROM SICAS_OC.RESERVA_DET
                    WHERE ID_POLIZA = o_SesasSiniestro(x).IdPoliza
                        AND ID_SINIESTRO = o_SesasSiniestro(x).NumSiniestro
                        AND AÑO_MOVIMIENTO = TO_NUMBER(TO_CHAR(dvarFecDesde, 'YYYY'))
                        AND TIPO_MOVIMIENTO = 'PAGOS';
                EXCEPTION
                    WHEN OTHERS THEN
                        dFecPagSin := NULL;
                END;

                UPDATE SICAS_OC.SESAS_SINIESTROS
                SET STATUSRECLAMACION = SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSINGMM(nCodCia, o_SesasSiniestro(x).IdPoliza, o_SesasSiniestro( x).NumSiniestro, o_SesasSiniestro(x).StatusReclamacion, o_SesasSiniestro(x).Monto_Pago_Moneda, nMontoReclamo, 'SINGMC'),
                    FECPAGSIN = dFecPagSin,
                    fechainsert = sysdate
                WHERE NUMPOLIZA = o_SesasSiniestro(x).NumPoliza
                    AND NUMSINIESTRO = o_SesasSiniestro(x).NumSiniestro;--OrdeSesas

            END LOOP;

            EXIT WHEN o_SesasSiniestro.COUNT = 0;
        END LOOP;
        CLOSE cSiniestros;

        UPDATE SICAS_OC.SESAS_SINIESTROS
        SET STATUSRECLAMACION = SICAS_OC.OC_PROCESOSSESAS.GETSTATUSSINGMM(CodCia, NULL, NumSiniestro, StatusReclamacion, MONTOPAGSIN, MONTORECLAMADO, 'SINGMC'),
            FECPAGSIN = CASE WHEN MONTOPAGSIN = 0 THEN  NULL ELSE FECPAGSIN END,
            fechainsert = sysdate
        WHERE  NUMPOLIZA = NumPoliza
            AND NUMSINIESTRO = NumSiniestro;--OrdeSesas

        COMMIT;
    END SINIESTROS_GM;

END OC_SESASINDIVIDUAL;
/

CREATE OR REPLACE PUBLIC SYNONYM OC_SESASINDIVIDUAL FOR SICAS_OC.OC_SESASINDIVIDUAL
/
GRANT EXECUTE ON SICAS_OC.OC_SESASINDIVIDUAL TO PUBLIC
/
